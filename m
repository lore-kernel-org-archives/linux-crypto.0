From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH] crypto: algif - change algif_skcipher to be asynchronous
Date: Tue, 13 Jan 2015 12:28:23 -0800
Message-ID: <20150113202823.32244.45456.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	qat-linux@intel.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:44667 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751113AbbAMUbo (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 13 Jan 2015 15:31:44 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The way the algif_skcipher works currently is that on sendmsg/sendpage it
builds an sgl for the input data and then on read/recvmsg it sends the job
for encryption putting the user to sleep till the data is processed.
This way it can only handle one job at a given time.
This patch changes it to be asynchronous.
The idea is to allow enqueue multiple jobs to get most of available crypto HW
accelerators and then read when the data is processed without blocking.
To allow that both the input and output sgl need to be know at sendmsg/sendpage
or the operation needs to happen "in place" in the input sgl. The approach here
is to use the "in place" operation and process the data in the sgl provided in
sendmsg. To allow that new user visible flags are introduced:
ALG_SET_OP_TYPE
ALG_OP_OUTOF_PLACE
ALG_OP_IN_PLACE
By default the operation type is ALG_OP_OUTOF_PLACE, which works the same way as
without the change and allows existing application working without any update.

Using the test application from https://lkml.org/lkml/2011/8/28/87 with small
modification to support in place operation, and reading after every 16th
sendmsg these are the results:

# time ./crypto_user_test
doing zero copy out of place

real	0m18.161s
user	0m0.253s
sys	0m5.356s

# time ./crypto_user_test inplace
doing zero copy in place

real	0m4.808s
user	0m0.132s
sys	0m2.937s

Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 crypto/af_alg.c             |    6 +
 crypto/algif_skcipher.c     |  284 ++++++++++++++++++++++++++++++++++++++++++-
 include/crypto/if_alg.h     |    1 
 include/uapi/linux/if_alg.h |    9 +
 4 files changed, 290 insertions(+), 10 deletions(-)

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index 76d739d..e9b2692 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -428,6 +428,12 @@ int af_alg_cmsg_send(struct msghdr *msg, struct af_alg_control *con)
 			con->op = *(u32 *)CMSG_DATA(cmsg);
 			break;
 
+		case ALG_SET_OP_TYPE:
+			if (cmsg->cmsg_len < CMSG_LEN(sizeof(u32)))
+				return -EINVAL;
+			con->op_type = *(u32 *)CMSG_DATA(cmsg);
+			break;
+
 		case ALG_SET_AEAD_ASSOCLEN:
 			if (cmsg->cmsg_len < CMSG_LEN(sizeof(u32)))
 				return -EINVAL;
diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index 38a6757..8e68ce9 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -19,6 +19,7 @@
 #include <linux/list.h>
 #include <linux/kernel.h>
 #include <linux/mm.h>
+#include <linux/mempool.h>
 #include <linux/module.h>
 #include <linux/net.h>
 #include <net/sock.h>
@@ -27,6 +28,7 @@ struct skcipher_sg_list {
 	struct list_head list;
 
 	int cur;
+	int last_sent;
 
 	struct scatterlist sg[0];
 };
@@ -39,19 +41,171 @@ struct skcipher_ctx {
 
 	struct af_alg_completion completion;
 
+	struct kmem_cache *cache;
+	mempool_t *pool;
 	unsigned used;
-
+	unsigned processed;
+	unsigned sent;
 	unsigned int len;
+	atomic_t inflight;
 	bool more;
 	bool merge;
 	bool enc;
+	bool inplace;
+	spinlock_t lock; /* Keeps used, sent & processed vars consistent */
 
 	struct ablkcipher_request req;
 };
 
+struct skcipher_req {
+	unsigned int len;
+};
+
+#define GET_SREQ(areq, ctx) (struct skcipher_req *)((char *)req + \
+	crypto_ablkcipher_reqsize(crypto_ablkcipher_reqtfm(&ctx->req)))
+
 #define MAX_SGL_ENTS ((4096 - sizeof(struct skcipher_sg_list)) / \
 		      sizeof(struct scatterlist) - 1)
 
+static int skcipher_wait_for_cb(struct sock *sk, unsigned flags)
+{
+	struct alg_sock *ask = alg_sk(sk);
+	struct skcipher_ctx *ctx = ask->private;
+	long timeout;
+	DEFINE_WAIT(wait);
+	int err = -ERESTARTSYS;
+
+	if (flags & MSG_DONTWAIT)
+		return -EAGAIN;
+
+	set_bit(SOCK_ASYNC_WAITDATA, &sk->sk_socket->flags);
+
+	for (;;) {
+		if (signal_pending(current))
+			break;
+		prepare_to_wait(sk_sleep(sk), &wait, TASK_INTERRUPTIBLE);
+		timeout = MAX_SCHEDULE_TIMEOUT;
+		if (sk_wait_event(sk, &timeout, ctx->processed)) {
+			err = 0;
+			break;
+		}
+	}
+	finish_wait(sk_sleep(sk), &wait);
+
+	clear_bit(SOCK_ASYNC_WAITDATA, &sk->sk_socket->flags);
+
+	return err;
+}
+
+static void skcipher_data_cb_wakeup(struct sock *sk)
+{
+	struct alg_sock *ask = alg_sk(sk);
+	struct skcipher_ctx *ctx = ask->private;
+	struct socket_wq *wq;
+
+	if (!ctx->processed)
+		return;
+
+	rcu_read_lock();
+	wq = rcu_dereference(sk->sk_wq);
+	if (wq_has_sleeper(wq))
+		wake_up_interruptible_sync_poll(&wq->wait, POLLOUT |
+							   POLLRDNORM |
+							   POLLRDBAND);
+	sk_wake_async(sk, SOCK_WAKE_SPACE, POLL_OUT);
+	rcu_read_unlock();
+}
+
+static void skcipher_cb(struct crypto_async_request *req, int err)
+{
+	struct sock *sk = req->data;
+	struct alg_sock *ask = alg_sk(sk);
+	struct skcipher_ctx *ctx = ask->private;
+	struct skcipher_req *sreq = GET_SREQ(req, ctx);
+
+	spin_lock(&ctx->lock);
+	ctx->sent -= sreq->len;
+	ctx->processed += sreq->len;
+	spin_unlock(&ctx->lock);
+	atomic_dec(&ctx->inflight);
+	mempool_free(req, ctx->pool);
+	skcipher_data_cb_wakeup(sk);
+}
+
+static void skcipher_mempool_free(void *_req, void *_sk)
+{
+	struct sock *sk = _sk;
+	struct alg_sock *ask = alg_sk(sk);
+	struct skcipher_ctx *ctx = ask->private;
+	struct kmem_cache *cache = ctx->cache;
+
+	kmem_cache_free(cache, _req);
+}
+
+static void *skcipher_mempool_alloc(gfp_t gfp_mask, void *_sk)
+{
+	struct sock *sk = _sk;
+	struct alg_sock *ask = alg_sk(sk);
+	struct skcipher_ctx *ctx = ask->private;
+	struct kmem_cache *cache = ctx->cache;
+	struct ablkcipher_request *req;
+	struct skcipher_req *sreq;
+
+	req = kmem_cache_alloc(cache, gfp_mask);
+	if (req) {
+		sreq = GET_SREQ(req, ctx);
+		sreq->len = 0;
+		ablkcipher_request_set_tfm(req,
+					   crypto_ablkcipher_reqtfm(&ctx->req));
+		ablkcipher_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
+						skcipher_cb, sk);
+	}
+	return req;
+}
+
+static void skcipher_cache_constructor(void *v)
+{
+	memset(v, 0, sizeof(struct skcipher_req));
+}
+
+static int skcipher_mempool_create(struct sock *sk)
+{
+	struct alg_sock *ask = alg_sk(sk);
+	struct skcipher_ctx *ctx = ask->private;
+	unsigned int len =
+		crypto_ablkcipher_reqsize(crypto_ablkcipher_reqtfm(&ctx->req)) +
+			sizeof(struct skcipher_req);
+	char buf[32];
+
+	snprintf(buf, sizeof(buf), "skcipher_%p", ctx);
+	ctx->cache = kmem_cache_create(buf, len, 0, SLAB_HWCACHE_ALIGN |
+				       SLAB_TEMPORARY,
+				       skcipher_cache_constructor);
+	if (unlikely(!ctx->cache))
+		return -ENOMEM;
+
+	ctx->pool = mempool_create(128, skcipher_mempool_alloc,
+				   skcipher_mempool_free, sk);
+
+	if (unlikely(!ctx->pool)) {
+		kmem_cache_destroy(ctx->cache);
+		return -ENOMEM;
+	}
+	return 0;
+}
+
+static void skcipher_mempool_destroy(struct skcipher_ctx *ctx)
+{
+	if (ctx->pool)
+		mempool_destroy(ctx->pool);
+
+	if (ctx->cache)
+		kmem_cache_destroy(ctx->cache);
+
+	ctx->cache = NULL;
+	ctx->pool = NULL;
+}
+
 static inline int skcipher_sndbuf(struct sock *sk)
 {
 	struct alg_sock *ask = alg_sk(sk);
@@ -86,6 +240,7 @@ static int skcipher_alloc_sgl(struct sock *sk)
 
 		sg_init_table(sgl->sg, MAX_SGL_ENTS + 1);
 		sgl->cur = 0;
+		sgl->last_sent = 0;
 
 		if (sg)
 			scatterwalk_sg_chain(sg, MAX_SGL_ENTS + 1, sgl->sg);
@@ -119,6 +274,9 @@ static void skcipher_pull_sgl(struct sock *sk, int used)
 			sg[i].offset += plen;
 
 			used -= plen;
+			spin_lock_bh(&ctx->lock);
+			ctx->processed -= plen;
+			spin_unlock_bh(&ctx->lock);
 			ctx->used -= plen;
 
 			if (sg[i].length)
@@ -252,10 +410,15 @@ static int skcipher_sendmsg(struct kiocb *unused, struct socket *sock,
 	long copied = 0;
 	bool enc = 0;
 	bool init = 0;
+	bool inplace = 0;
 	int err;
 	int i;
+	int flags = msg->msg_flags;
 
 	if (msg->msg_controllen) {
+		if (ctx->used)
+			return -EINVAL;
+
 		err = af_alg_cmsg_send(msg, &con);
 		if (err)
 			return err;
@@ -272,6 +435,17 @@ static int skcipher_sendmsg(struct kiocb *unused, struct socket *sock,
 			return -EINVAL;
 		}
 
+		switch (con.op_type) {
+		case ALG_OP_IN_PLACE:
+			inplace = true;
+			break;
+		case ALG_OP_OUTOF_PLACE:
+			inplace = false;
+			break;
+		default:
+			return -EINVAL;
+		}
+
 		if (con.iv && con.iv->ivlen != ivsize)
 			return -EINVAL;
 	}
@@ -279,11 +453,14 @@ static int skcipher_sendmsg(struct kiocb *unused, struct socket *sock,
 	err = -EINVAL;
 
 	lock_sock(sk);
-	if (!ctx->more && ctx->used)
+	if (!ctx->inplace && !ctx->more && ctx->used)
 		goto unlock;
 
 	if (init) {
 		ctx->enc = enc;
+		ctx->inplace = inplace;
+		ctx->processed = 0;
+		ctx->sent = 0;
 		if (con.iv)
 			memcpy(ctx->iv, con.iv->iv, ivsize);
 	}
@@ -293,6 +470,10 @@ static int skcipher_sendmsg(struct kiocb *unused, struct socket *sock,
 		unsigned long len = size;
 		int plen;
 
+		/* Inplace works with zero copy only */
+		if (inplace)
+			goto unlock;
+
 		if (ctx->merge) {
 			sgl = list_entry(ctx->tsgl.prev,
 					 struct skcipher_sg_list, list);
@@ -361,10 +542,12 @@ static int skcipher_sendmsg(struct kiocb *unused, struct socket *sock,
 
 		ctx->merge = plen & (PAGE_SIZE - 1);
 	}
+	if (ctx->inplace)
+		flags |= MSG_MORE;
 
 	err = 0;
 
-	ctx->more = msg->msg_flags & MSG_MORE;
+	ctx->more = flags & MSG_MORE;
 
 unlock:
 	skcipher_data_wakeup(sk);
@@ -373,6 +556,8 @@ unlock:
 	return copied ?: err;
 }
 
+#define LAST_PAGE(f) (!(f & MSG_SENDPAGE_NOTLAST))
+
 static ssize_t skcipher_sendpage(struct socket *sock, struct page *page,
 				 int offset, size_t size, int flags)
 {
@@ -386,7 +571,7 @@ static ssize_t skcipher_sendpage(struct socket *sock, struct page *page,
 		flags |= MSG_MORE;
 
 	lock_sock(sk);
-	if (!ctx->more && ctx->used)
+	if (!ctx->inplace && !ctx->more && ctx->used)
 		goto unlock;
 
 	if (!size)
@@ -402,6 +587,9 @@ static ssize_t skcipher_sendpage(struct socket *sock, struct page *page,
 	if (err)
 		goto unlock;
 
+	if (ctx->inplace && page == ZERO_PAGE(0))
+		ctx->inplace = false;
+
 	ctx->merge = 0;
 	sgl = list_entry(ctx->tsgl.prev, struct skcipher_sg_list, list);
 
@@ -414,13 +602,60 @@ static ssize_t skcipher_sendpage(struct socket *sock, struct page *page,
 	sgl->cur++;
 	ctx->used += size;
 
+	if (LAST_PAGE(flags) && ctx->inplace) {
+		struct scatterlist *sg = sgl->sg + sgl->last_sent;
+		struct ablkcipher_request *req;
+		struct skcipher_req *sreq;
+		int nr_pages;
+
+		req = mempool_alloc(ctx->pool, GFP_KERNEL);
+		if (unlikely(!req)) {
+			put_page(page);
+			sgl->cur--;
+			sg_unmark_end(sgl->sg + sgl->cur);
+			ctx->used -= size;
+			err = -ENOMEM;
+			goto unlock;
+		}
+
+		sreq = GET_SREQ(req, ctx);
+		spin_lock_bh(&ctx->lock);
+		sreq->len = ctx->used - ctx->processed - ctx->sent;
+		ctx->sent += sreq->len;
+		spin_unlock_bh(&ctx->lock);
+		err = -EINVAL;
+		nr_pages = sgl->cur - sgl->last_sent;
+		sgl->last_sent = sgl->cur;
+
+		ablkcipher_request_set_crypt(req, sg, sg, sreq->len, ctx->iv);
+
+		err = ctx->enc ? crypto_ablkcipher_encrypt(req) :
+				 crypto_ablkcipher_decrypt(req);
+
+		if (!err) {
+			spin_lock_bh(&ctx->lock);
+			ctx->processed += sreq->len;
+			ctx->sent -= sreq->len;
+			spin_unlock_bh(&ctx->lock);
+			mempool_free(req, ctx->pool);
+		} else if (err == -EINPROGRESS) {
+			atomic_inc(&ctx->inflight);
+			err = 0;
+		} else {
+			spin_lock_bh(&ctx->lock);
+			ctx->sent -= sreq->len;
+			ctx->used += sreq->len;
+			spin_unlock_bh(&ctx->lock);
+			sgl->last_sent -= nr_pages;
+			mempool_free(req, ctx->pool);
+		}
+	}
 done:
 	ctx->more = flags & MSG_MORE;
 
 unlock:
 	skcipher_data_wakeup(sk);
 	release_sock(sk);
-
 	return err ?: size;
 }
 
@@ -460,6 +695,17 @@ static int skcipher_recvmsg(struct kiocb *unused, struct socket *sock,
 					goto unlock;
 			}
 
+			if (ctx->inplace) {
+				if (!ctx->processed) {
+					err = skcipher_wait_for_cb(sk, flags);
+					if (err)
+						goto unlock;
+				}
+				used = min_t(unsigned long, ctx->processed,
+					     seglen);
+				goto free_tx;
+			}
+
 			used = min_t(unsigned long, ctx->used, seglen);
 
 			used = af_alg_make_sg(&ctx->rsgl, from, used, 1);
@@ -489,7 +735,8 @@ free:
 
 			if (err)
 				goto unlock;
-
+			ctx->processed += used;
+free_tx:
 			copied += used;
 			from += used;
 			seglen -= used;
@@ -506,7 +753,6 @@ unlock:
 	return copied ?: err;
 }
 
-
 static unsigned int skcipher_poll(struct file *file, struct socket *sock,
 				  poll_table *wait)
 {
@@ -518,7 +764,7 @@ static unsigned int skcipher_poll(struct file *file, struct socket *sock,
 	sock_poll_wait(file, sk_sleep(sk), wait);
 	mask = 0;
 
-	if (ctx->used)
+	if ((!ctx->inplace && ctx->used) || (ctx->inplace && ctx->processed))
 		mask |= POLLIN | POLLRDNORM;
 
 	if (skcipher_writable(sk))
@@ -564,12 +810,25 @@ static int skcipher_setkey(void *private, const u8 *key, unsigned int keylen)
 	return crypto_ablkcipher_setkey(private, key, keylen);
 }
 
+static void skcipher_wait(struct sock *sk)
+{
+	struct alg_sock *ask = alg_sk(sk);
+	struct skcipher_ctx *ctx = ask->private;
+	int ctr = 0;
+
+	while (atomic_read(&ctx->inflight) && ctr++ < 100)
+		msleep(100);
+}
+
 static void skcipher_sock_destruct(struct sock *sk)
 {
 	struct alg_sock *ask = alg_sk(sk);
 	struct skcipher_ctx *ctx = ask->private;
 	struct crypto_ablkcipher *tfm = crypto_ablkcipher_reqtfm(&ctx->req);
 
+	if (atomic_read(&ctx->inflight))
+		skcipher_wait(sk);
+	skcipher_mempool_destroy(ctx);
 	skcipher_free_sgl(sk);
 	sock_kzfree_s(sk, ctx->iv, crypto_ablkcipher_ivsize(tfm));
 	sock_kfree_s(sk, ctx, ctx->len);
@@ -597,11 +856,15 @@ static int skcipher_accept_parent(void *private, struct sock *sk)
 
 	INIT_LIST_HEAD(&ctx->tsgl);
 	ctx->len = len;
+	ctx->processed = 0;
+	ctx->sent = 0;
 	ctx->used = 0;
 	ctx->more = 0;
 	ctx->merge = 0;
 	ctx->enc = 0;
+	atomic_set(&ctx->inflight, 0);
 	af_alg_init_completion(&ctx->completion);
+	spin_lock_init(&ctx->lock);
 
 	ask->private = ctx;
 
@@ -609,6 +872,11 @@ static int skcipher_accept_parent(void *private, struct sock *sk)
 	ablkcipher_request_set_callback(&ctx->req, CRYPTO_TFM_REQ_MAY_BACKLOG,
 					af_alg_complete, &ctx->completion);
 
+	if (skcipher_mempool_create(sk)) {
+		sock_kzfree_s(sk, ctx->iv, crypto_ablkcipher_ivsize(private));
+		sock_kfree_s(sk, ctx, ctx->len);
+		return -ENOMEM;
+	}
 	sk->sk_destruct = skcipher_sock_destruct;
 
 	return 0;
diff --git a/include/crypto/if_alg.h b/include/crypto/if_alg.h
index 5c7b6c5..7121b3d 100644
--- a/include/crypto/if_alg.h
+++ b/include/crypto/if_alg.h
@@ -42,6 +42,7 @@ struct af_alg_completion {
 struct af_alg_control {
 	struct af_alg_iv *iv;
 	int op;
+	int op_type;
 	unsigned int aead_assoclen;
 };
 
diff --git a/include/uapi/linux/if_alg.h b/include/uapi/linux/if_alg.h
index f2acd2f..861b0798 100644
--- a/include/uapi/linux/if_alg.h
+++ b/include/uapi/linux/if_alg.h
@@ -32,11 +32,16 @@ struct af_alg_iv {
 #define ALG_SET_KEY			1
 #define ALG_SET_IV			2
 #define ALG_SET_OP			3
-#define ALG_SET_AEAD_ASSOCLEN		4
-#define ALG_SET_AEAD_AUTHSIZE		5
+#define ALG_SET_OP_TYPE			4
+#define ALG_SET_AEAD_ASSOCLEN		5
+#define ALG_SET_AEAD_AUTHSIZE		6
 
 /* Operations */
 #define ALG_OP_DECRYPT			0
 #define ALG_OP_ENCRYPT			1
 
+/* Operation types */
+#define ALG_OP_OUTOF_PLACE		0
+#define ALG_OP_IN_PLACE			1
+
 #endif	/* _LINUX_IF_ALG_H */
