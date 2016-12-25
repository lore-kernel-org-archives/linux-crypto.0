From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: [PATCH 1/2] crypto: aead AF_ALG - overhaul memory management
Date: Sun, 25 Dec 2016 18:15:06 +0100
Message-ID: <2789022.qIBfP2h8Cy@positron.chronox.de>
References: <1486189.x0AQ4O6r2j@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:54982 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750860AbcLYRQa (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 25 Dec 2016 12:16:30 -0500
In-Reply-To: <1486189.x0AQ4O6r2j@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The updated memory management is described in the top part of the code.
As one benefit of the changed memory management, the AIO and synchronous
operation is now implemented in one common function. The AF_ALG
operation uses the async kernel crypto API interface for each cipher
operation. Thus, the only difference between the AIO and sync operation
types visible from user space is:

1. the callback function to be invoked when the asynchronous operation
   is completed

2. whether to wait for the completion of the kernel crypto API operation
   or not

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/algif_aead.c | 439 +++++++++++++++++++++++-----------------------------
 1 file changed, 195 insertions(+), 244 deletions(-)

diff --git a/crypto/algif_aead.c b/crypto/algif_aead.c
index f849311..3ca68fb 100644
--- a/crypto/algif_aead.c
+++ b/crypto/algif_aead.c
@@ -11,6 +11,25 @@
  * under the terms of the GNU General Public License as published by the Free
  * Software Foundation; either version 2 of the License, or (at your option)
  * any later version.
+ *
+ * The following concept of the memory management is used:
+ *
+ * The kernel maintains two SGLs, the TX SGL and the RX SGL. The TX SGL is
+ * filled by user space with the data submitted via sendpage/sendmsg. Filling
+ * up the TX SGL does not cause a crypto operation -- the data will only be
+ * tracked by the kernel. Upon receipt of one recvmsg call, the caller must
+ * provide a buffer which is tracked with the RX SGL.
+ *
+ * During the processing of the recvmsg operation, the cipher request is
+ * allocated and prepared. To support multiple recvmsg operations operating
+ * on one TX SGL, an offset pointer into the TX SGL is maintained. The TX SGL
+ * that is used for the crypto request is scatterwalk_ffwd by the offset
+ * pointer to obtain the start address the crypto operation shall use for
+ * the input data.
+ *
+ * After the completion of the crypto operation, the RX SGL and the cipher
+ * request is released. The TX SGL is released once all parts of it are
+ * processed.
  */
 
 #include <crypto/internal/aead.h>
@@ -24,7 +43,7 @@
 #include <linux/net.h>
 #include <net/sock.h>
 
-struct aead_sg_list {
+struct aead_async_tsgl {
 	unsigned int cur;
 	struct scatterlist sg[ALG_MAX_PAGES];
 };
@@ -35,34 +54,38 @@ struct aead_async_rsgl {
 };
 
 struct aead_async_req {
-	struct scatterlist *tsgl;
-	struct aead_async_rsgl first_rsgl;
-	struct list_head list;
 	struct kiocb *iocb;
-	unsigned int tsgls;
-	char iv[];
+	struct sock *sk;
+
+	struct aead_async_rsgl first_rsgl;	/* First RX SG */
+	struct list_head list;			/* Track RX SGs */
+
+	unsigned int areqlen;			/* Length of this data struct */
+	struct aead_request aead_req;		/* req ctx trails this struct */
 };
 
 struct aead_ctx {
-	struct aead_sg_list tsgl;
-	struct aead_async_rsgl first_rsgl;
-	struct list_head list;
+	struct aead_async_tsgl tsgl;
 
 	void *iv;
+	size_t aead_assoclen;
 
-	struct af_alg_completion completion;
+	struct af_alg_completion completion;	/* sync work queue */
 
-	unsigned long used;
+	unsigned int inflight;			/* outstanding AIO ops */
+	size_t used;				/* TX bytes sent to kernel */
+	size_t processed;			/* number of bytes processed */
 
-	unsigned int len;
 	bool more;
 	bool merge;
 	bool enc;
 
-	size_t aead_assoclen;
-	struct aead_request aead_req;
+	unsigned int len;			/* length data structure */
+	struct crypto_aead *aead_tfm;
 };
 
+static DECLARE_WAIT_QUEUE_HEAD(aead_aio_finish_wait);
+
 static inline int aead_sndbuf(struct sock *sk)
 {
 	struct alg_sock *ask = alg_sk(sk);
@@ -79,34 +102,43 @@ static inline bool aead_writable(struct sock *sk)
 
 static inline bool aead_sufficient_data(struct aead_ctx *ctx)
 {
-	unsigned as = crypto_aead_authsize(crypto_aead_reqtfm(&ctx->aead_req));
+	unsigned as = crypto_aead_authsize(ctx->aead_tfm);
 
 	/*
 	 * The minimum amount of memory needed for an AEAD cipher is
 	 * the AAD and in case of decryption the tag.
+	 *
+	 * Also, sufficient data must be available after disregarding the
+	 * already processed data.
 	 */
-	return ctx->used >= ctx->aead_assoclen + (ctx->enc ? 0 : as);
+	return ctx->used >= ctx->aead_assoclen + (ctx->enc ? 0 : as) +
+			    ctx->processed;
 }
 
 static void aead_reset_ctx(struct aead_ctx *ctx)
 {
-	struct aead_sg_list *sgl = &ctx->tsgl;
+	struct aead_async_tsgl *sgl = &ctx->tsgl;
 
 	sg_init_table(sgl->sg, ALG_MAX_PAGES);
 	sgl->cur = 0;
 	ctx->used = 0;
+	ctx->processed = 0;
 	ctx->more = 0;
 	ctx->merge = 0;
 }
 
-static void aead_put_sgl(struct sock *sk)
+static void aead_pull_tsgl(struct sock *sk, bool force)
 {
 	struct alg_sock *ask = alg_sk(sk);
 	struct aead_ctx *ctx = ask->private;
-	struct aead_sg_list *sgl = &ctx->tsgl;
+	struct aead_async_tsgl *sgl = &ctx->tsgl;
 	struct scatterlist *sg = sgl->sg;
 	unsigned int i;
 
+	/* leave provided data in tact if we did not finish AIO work */
+	if (!force && ctx->used > ctx->processed)
+		return;
+
 	for (i = 0; i < sgl->cur; i++) {
 		if (!sg_page(sg + i))
 			continue;
@@ -117,6 +149,19 @@ static void aead_put_sgl(struct sock *sk)
 	aead_reset_ctx(ctx);
 }
 
+static void aead_free_rsgl(struct aead_async_req *areq)
+{
+	struct sock *sk = areq->sk;
+	struct aead_async_rsgl *rsgl, *tmp;
+
+	list_for_each_entry_safe(rsgl, tmp, &areq->list, list) {
+		af_alg_free_sg(&rsgl->sgl);
+		if (rsgl != &areq->first_rsgl)
+			sock_kfree_s(sk, rsgl, sizeof(*rsgl));
+		list_del(&rsgl->list);
+	}
+}
+
 static void aead_wmem_wakeup(struct sock *sk)
 {
 	struct socket_wq *wq;
@@ -189,9 +234,8 @@ static int aead_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 	struct sock *sk = sock->sk;
 	struct alg_sock *ask = alg_sk(sk);
 	struct aead_ctx *ctx = ask->private;
-	unsigned ivsize =
-		crypto_aead_ivsize(crypto_aead_reqtfm(&ctx->aead_req));
-	struct aead_sg_list *sgl = &ctx->tsgl;
+	unsigned ivsize = crypto_aead_ivsize(ctx->aead_tfm);
+	struct aead_async_tsgl *sgl = &ctx->tsgl;
 	struct af_alg_control con = {};
 	long copied = 0;
 	bool enc = 0;
@@ -258,7 +302,7 @@ static int aead_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 
 		if (!aead_writable(sk)) {
 			/* user space sent too much data */
-			aead_put_sgl(sk);
+			aead_pull_tsgl(sk, 1);
 			err = -EMSGSIZE;
 			goto unlock;
 		}
@@ -269,7 +313,7 @@ static int aead_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 			size_t plen = 0;
 
 			if (sgl->cur >= ALG_MAX_PAGES) {
-				aead_put_sgl(sk);
+				aead_pull_tsgl(sk, 1);
 				err = -E2BIG;
 				goto unlock;
 			}
@@ -305,7 +349,7 @@ static int aead_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 
 	ctx->more = msg->msg_flags & MSG_MORE;
 	if (!ctx->more && !aead_sufficient_data(ctx)) {
-		aead_put_sgl(sk);
+		aead_pull_tsgl(sk, 1);
 		err = -EMSGSIZE;
 	}
 
@@ -322,7 +366,7 @@ static ssize_t aead_sendpage(struct socket *sock, struct page *page,
 	struct sock *sk = sock->sk;
 	struct alg_sock *ask = alg_sk(sk);
 	struct aead_ctx *ctx = ask->private;
-	struct aead_sg_list *sgl = &ctx->tsgl;
+	struct aead_async_tsgl *sgl = &ctx->tsgl;
 	int err = -EINVAL;
 
 	if (flags & MSG_SENDPAGE_NOTLAST)
@@ -340,7 +384,7 @@ static ssize_t aead_sendpage(struct socket *sock, struct page *page,
 
 	if (!aead_writable(sk)) {
 		/* user space sent too much data */
-		aead_put_sgl(sk);
+		aead_pull_tsgl(sk, 1);
 		err = -EMSGSIZE;
 		goto unlock;
 	}
@@ -357,7 +401,7 @@ static ssize_t aead_sendpage(struct socket *sock, struct page *page,
 done:
 	ctx->more = flags & MSG_MORE;
 	if (!ctx->more && !aead_sufficient_data(ctx)) {
-		aead_put_sgl(sk);
+		aead_pull_tsgl(sk, 1);
 		err = -EMSGSIZE;
 	}
 
@@ -368,190 +412,48 @@ static ssize_t aead_sendpage(struct socket *sock, struct page *page,
 	return err ?: size;
 }
 
-#define GET_ASYM_REQ(req, tfm) (struct aead_async_req *) \
-		((char *)req + sizeof(struct aead_request) + \
-		 crypto_aead_reqsize(tfm))
-
- #define GET_REQ_SIZE(tfm) sizeof(struct aead_async_req) + \
-	crypto_aead_reqsize(tfm) + crypto_aead_ivsize(tfm) + \
-	sizeof(struct aead_request)
-
 static void aead_async_cb(struct crypto_async_request *_req, int err)
 {
-	struct sock *sk = _req->data;
+	struct aead_async_req *areq = _req->data;
+	struct sock *sk = areq->sk;
 	struct alg_sock *ask = alg_sk(sk);
 	struct aead_ctx *ctx = ask->private;
-	struct crypto_aead *tfm = crypto_aead_reqtfm(&ctx->aead_req);
-	struct aead_request *req = aead_request_cast(_req);
-	struct aead_async_req *areq = GET_ASYM_REQ(req, tfm);
-	struct scatterlist *sg = areq->tsgl;
-	struct aead_async_rsgl *rsgl;
 	struct kiocb *iocb = areq->iocb;
-	unsigned int i, reqlen = GET_REQ_SIZE(tfm);
 
-	list_for_each_entry(rsgl, &areq->list, list) {
-		af_alg_free_sg(&rsgl->sgl);
-		if (rsgl != &areq->first_rsgl)
-			sock_kfree_s(sk, rsgl, sizeof(*rsgl));
-	}
+	lock_sock(sk);
 
-	for (i = 0; i < areq->tsgls; i++)
-		put_page(sg_page(sg + i));
+	BUG_ON(!ctx->inflight);
 
-	sock_kfree_s(sk, areq->tsgl, sizeof(*areq->tsgl) * areq->tsgls);
-	sock_kfree_s(sk, req, reqlen);
+	aead_free_rsgl(areq);
+	sock_kfree_s(sk, areq, areq->areqlen);
+	aead_pull_tsgl(sk, 0);
 	__sock_put(sk);
+	ctx->inflight--;
 	iocb->ki_complete(iocb, err, err);
-}
-
-static int aead_recvmsg_async(struct socket *sock, struct msghdr *msg,
-			      int flags)
-{
-	struct sock *sk = sock->sk;
-	struct alg_sock *ask = alg_sk(sk);
-	struct aead_ctx *ctx = ask->private;
-	struct crypto_aead *tfm = crypto_aead_reqtfm(&ctx->aead_req);
-	struct aead_async_req *areq;
-	struct aead_request *req = NULL;
-	struct aead_sg_list *sgl = &ctx->tsgl;
-	struct aead_async_rsgl *last_rsgl = NULL, *rsgl;
-	unsigned int as = crypto_aead_authsize(tfm);
-	unsigned int i, reqlen = GET_REQ_SIZE(tfm);
-	int err = -ENOMEM;
-	unsigned long used;
-	size_t outlen = 0;
-	size_t usedpages = 0;
 
-	lock_sock(sk);
-	if (ctx->more) {
-		err = aead_wait_for_data(sk, flags);
-		if (err)
-			goto unlock;
-	}
-
-	if (!aead_sufficient_data(ctx))
-		goto unlock;
-
-	used = ctx->used;
-	if (ctx->enc)
-		outlen = used + as;
-	else
-		outlen = used - as;
-
-	req = sock_kmalloc(sk, reqlen, GFP_KERNEL);
-	if (unlikely(!req))
-		goto unlock;
-
-	areq = GET_ASYM_REQ(req, tfm);
-	memset(&areq->first_rsgl, '\0', sizeof(areq->first_rsgl));
-	INIT_LIST_HEAD(&areq->list);
-	areq->iocb = msg->msg_iocb;
-	memcpy(areq->iv, ctx->iv, crypto_aead_ivsize(tfm));
-	aead_request_set_tfm(req, tfm);
-	aead_request_set_ad(req, ctx->aead_assoclen);
-	aead_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
-				  aead_async_cb, sk);
-	used -= ctx->aead_assoclen;
-
-	/* take over all tx sgls from ctx */
-	areq->tsgl = sock_kmalloc(sk,
-				  sizeof(*areq->tsgl) * max_t(u32, sgl->cur, 1),
-				  GFP_KERNEL);
-	if (unlikely(!areq->tsgl))
-		goto free;
-
-	sg_init_table(areq->tsgl, max_t(u32, sgl->cur, 1));
-	for (i = 0; i < sgl->cur; i++)
-		sg_set_page(&areq->tsgl[i], sg_page(&sgl->sg[i]),
-			    sgl->sg[i].length, sgl->sg[i].offset);
-
-	areq->tsgls = sgl->cur;
-
-	/* create rx sgls */
-	while (outlen > usedpages && iov_iter_count(&msg->msg_iter)) {
-		size_t seglen = min_t(size_t, iov_iter_count(&msg->msg_iter),
-				      (outlen - usedpages));
-
-		if (list_empty(&areq->list)) {
-			rsgl = &areq->first_rsgl;
-
-		} else {
-			rsgl = sock_kmalloc(sk, sizeof(*rsgl), GFP_KERNEL);
-			if (unlikely(!rsgl)) {
-				err = -ENOMEM;
-				goto free;
-			}
-		}
-		rsgl->sgl.npages = 0;
-		list_add_tail(&rsgl->list, &areq->list);
-
-		/* make one iovec available as scatterlist */
-		err = af_alg_make_sg(&rsgl->sgl, &msg->msg_iter, seglen);
-		if (err < 0)
-			goto free;
-
-		usedpages += err;
-
-		/* chain the new scatterlist with previous one */
-		if (last_rsgl)
-			af_alg_link_sg(&last_rsgl->sgl, &rsgl->sgl);
-
-		last_rsgl = rsgl;
-
-		iov_iter_advance(&msg->msg_iter, err);
-	}
-
-	/* ensure output buffer is sufficiently large */
-	if (usedpages < outlen) {
-		err = -EINVAL;
-		goto unlock;
-	}
-
-	aead_request_set_crypt(req, areq->tsgl, areq->first_rsgl.sgl.sg, used,
-			       areq->iv);
-	err = ctx->enc ? crypto_aead_encrypt(req) : crypto_aead_decrypt(req);
-	if (err) {
-		if (err == -EINPROGRESS) {
-			sock_hold(sk);
-			err = -EIOCBQUEUED;
-			aead_reset_ctx(ctx);
-			goto unlock;
-		} else if (err == -EBADMSG) {
-			aead_put_sgl(sk);
-		}
-		goto free;
-	}
-	aead_put_sgl(sk);
-
-free:
-	list_for_each_entry(rsgl, &areq->list, list) {
-		af_alg_free_sg(&rsgl->sgl);
-		if (rsgl != &areq->first_rsgl)
-			sock_kfree_s(sk, rsgl, sizeof(*rsgl));
-	}
-	if (areq->tsgl)
-		sock_kfree_s(sk, areq->tsgl, sizeof(*areq->tsgl) * areq->tsgls);
-	if (req)
-		sock_kfree_s(sk, req, reqlen);
-unlock:
-	aead_wmem_wakeup(sk);
 	release_sock(sk);
-	return err ? err : outlen;
+
+	wake_up_interruptible(&aead_aio_finish_wait);
 }
 
-static int aead_recvmsg_sync(struct socket *sock, struct msghdr *msg, int flags)
+static int aead_recvmsg(struct socket *sock, struct msghdr *msg, size_t ignored,
+			int flags)
 {
 	struct sock *sk = sock->sk;
 	struct alg_sock *ask = alg_sk(sk);
 	struct aead_ctx *ctx = ask->private;
-	unsigned as = crypto_aead_authsize(crypto_aead_reqtfm(&ctx->aead_req));
-	struct aead_sg_list *sgl = &ctx->tsgl;
+	struct crypto_aead *tfm = ctx->aead_tfm;
+	unsigned int as = crypto_aead_authsize(tfm);
+	unsigned int areqlen =
+		sizeof(struct aead_async_req) + crypto_aead_reqsize(tfm);
+	struct aead_async_tsgl *tsgl = &ctx->tsgl;
+	struct aead_async_req *areq;
 	struct aead_async_rsgl *last_rsgl = NULL;
-	struct aead_async_rsgl *rsgl, *tmp;
+	struct scatterlist tsgl_head[2], *tsgl_head_p;
 	int err = -EINVAL;
-	unsigned long used = 0;
-	size_t outlen = 0;
-	size_t usedpages = 0;
+	size_t used = 0;		/* [in]  TX bufs to be en/decrypted */
+	size_t outlen = 0;		/* [out] RX bufs produced by kernel */
+	size_t usedpages = 0;		/* [in]  RX bufs to be used from user */
 
 	lock_sock(sk);
 
@@ -566,8 +468,11 @@ static int aead_recvmsg_sync(struct socket *sock, struct msghdr *msg, int flags)
 			goto unlock;
 	}
 
-	/* data length provided by caller via sendmsg/sendpage */
-	used = ctx->used;
+	/*
+	 * Data length provided by caller via sendmsg/sendpage that has not
+	 * yet been processed.
+	 */
+	used = ctx->used - ctx->processed;
 
 	/*
 	 * Make sure sufficient data is present -- note, the same check is
@@ -600,86 +505,131 @@ static int aead_recvmsg_sync(struct socket *sock, struct msghdr *msg, int flags)
 	 */
 	used -= ctx->aead_assoclen;
 
-	/* convert iovecs of output buffers into scatterlists */
+	/* Allocate cipher request for current operation. */
+	areq = sock_kmalloc(sk, areqlen, GFP_KERNEL);
+	if (unlikely(!areq)) {
+		err = -ENOMEM;
+		goto unlock;
+	}
+	areq->areqlen = areqlen;
+	areq->sk = sk;
+	INIT_LIST_HEAD(&areq->list);
+
+	/* convert iovecs of output buffers into RX SGL */
 	while (outlen > usedpages && iov_iter_count(&msg->msg_iter)) {
+		struct aead_async_rsgl *rsgl;
 		size_t seglen = min_t(size_t, iov_iter_count(&msg->msg_iter),
 				      (outlen - usedpages));
 
-		if (list_empty(&ctx->list)) {
-			rsgl = &ctx->first_rsgl;
+		if (list_empty(&areq->list)) {
+			rsgl = &areq->first_rsgl;
 		} else {
 			rsgl = sock_kmalloc(sk, sizeof(*rsgl), GFP_KERNEL);
 			if (unlikely(!rsgl)) {
 				err = -ENOMEM;
-				goto unlock;
+				goto free;
 			}
 		}
+
 		rsgl->sgl.npages = 0;
-		list_add_tail(&rsgl->list, &ctx->list);
+		list_add_tail(&rsgl->list, &areq->list);
 
 		/* make one iovec available as scatterlist */
 		err = af_alg_make_sg(&rsgl->sgl, &msg->msg_iter, seglen);
 		if (err < 0)
-			goto unlock;
-		usedpages += err;
+			goto free;
+
 		/* chain the new scatterlist with previous one */
 		if (last_rsgl)
 			af_alg_link_sg(&last_rsgl->sgl, &rsgl->sgl);
 
 		last_rsgl = rsgl;
-
+		usedpages += err;
 		iov_iter_advance(&msg->msg_iter, err);
 	}
 
-	/* ensure output buffer is sufficiently large */
+	/*
+	 * Ensure output buffer is sufficiently large. If the caller provides
+	 * less buffer space, only use the relative required input size. This
+	 * allows AIO operation where the caller sent all data to be processed
+	 * and the AIO operation performs the operation on the different chunks
+	 * of the input data.
+	 */
 	if (usedpages < outlen) {
-		err = -EINVAL;
-		goto unlock;
-	}
+		size_t less = outlen - usedpages;
 
-	sg_mark_end(sgl->sg + sgl->cur - 1);
-	aead_request_set_crypt(&ctx->aead_req, sgl->sg, ctx->first_rsgl.sgl.sg,
-			       used, ctx->iv);
-	aead_request_set_ad(&ctx->aead_req, ctx->aead_assoclen);
+		if (used < less) {
+			err = -EINVAL;
+			goto free;
+		}
+		used -= less;
+		outlen -= less;
+	}
 
-	err = af_alg_wait_for_completion(ctx->enc ?
-					 crypto_aead_encrypt(&ctx->aead_req) :
-					 crypto_aead_decrypt(&ctx->aead_req),
+	sg_mark_end(tsgl->sg + tsgl->cur - 1);
+
+	/* Get the head of the SGL we want to process */
+	tsgl_head_p = scatterwalk_ffwd(tsgl_head, tsgl->sg, ctx->processed);
+	BUG_ON(!tsgl_head_p);
+
+	/* Initialize the crypto operation */
+	aead_request_set_crypt(&areq->aead_req, tsgl_head_p,
+			       areq->first_rsgl.sgl.sg, used, ctx->iv);
+	aead_request_set_ad(&areq->aead_req, ctx->aead_assoclen);
+	aead_request_set_tfm(&areq->aead_req, tfm);
+
+	if (msg->msg_iocb && !is_sync_kiocb(msg->msg_iocb)) {
+		/* AIO operation */
+		areq->iocb = msg->msg_iocb;
+		aead_request_set_callback(&areq->aead_req,
+					  CRYPTO_TFM_REQ_MAY_BACKLOG,
+					  aead_async_cb, areq);
+		err = ctx->enc ? crypto_aead_encrypt(&areq->aead_req) :
+				 crypto_aead_decrypt(&areq->aead_req);
+	} else {
+		/* Synchronous operation */
+		aead_request_set_callback(&areq->aead_req,
+					  CRYPTO_TFM_REQ_MAY_BACKLOG,
+					  af_alg_complete, &ctx->completion);
+		err = af_alg_wait_for_completion(ctx->enc ?
+					 crypto_aead_encrypt(&areq->aead_req) :
+					 crypto_aead_decrypt(&areq->aead_req),
 					 &ctx->completion);
+	}
 
 	if (err) {
-		/* EBADMSG implies a valid cipher operation took place */
-		if (err == -EBADMSG)
-			aead_put_sgl(sk);
+		/* AIO operation in progress */
+		if (err == -EINPROGRESS) {
+			sock_hold(sk);
+			err = -EIOCBQUEUED;
 
-		goto unlock;
+			/* Remember the TX bytes that were processed. */
+			ctx->processed += ctx->enc ? (outlen - as) :
+						     (outlen + as);
+			ctx->inflight++;
+
+			goto unlock;
+		}
+		/* EBADMSG implies a valid cipher operation took place */
+		else if (err != -EBADMSG)
+			goto free;
 	}
 
-	aead_put_sgl(sk);
-	err = 0;
+	/* Remember the TX bytes that were processed. */
+	ctx->processed += ctx->enc ? (outlen - as) : (outlen + as);
+
+free:
+	aead_free_rsgl(areq);
+	if (areq)
+		sock_kfree_s(sk, areq, areqlen);
+	aead_pull_tsgl(sk, 0);
 
 unlock:
-	list_for_each_entry_safe(rsgl, tmp, &ctx->list, list) {
-		af_alg_free_sg(&rsgl->sgl);
-		if (rsgl != &ctx->first_rsgl)
-			sock_kfree_s(sk, rsgl, sizeof(*rsgl));
-		list_del(&rsgl->list);
-	}
-	INIT_LIST_HEAD(&ctx->list);
 	aead_wmem_wakeup(sk);
 	release_sock(sk);
-
 	return err ? err : outlen;
 }
 
-static int aead_recvmsg(struct socket *sock, struct msghdr *msg, size_t ignored,
-			int flags)
-{
-	return (msg->msg_iocb && !is_sync_kiocb(msg->msg_iocb)) ?
-		aead_recvmsg_async(sock, msg, flags) :
-		aead_recvmsg_sync(sock, msg, flags);
-}
-
 static unsigned int aead_poll(struct file *file, struct socket *sock,
 			      poll_table *wait)
 {
@@ -746,11 +696,14 @@ static void aead_sock_destruct(struct sock *sk)
 {
 	struct alg_sock *ask = alg_sk(sk);
 	struct aead_ctx *ctx = ask->private;
-	unsigned int ivlen = crypto_aead_ivsize(
-				crypto_aead_reqtfm(&ctx->aead_req));
+	unsigned int ivlen = crypto_aead_ivsize(ctx->aead_tfm);
 
 	WARN_ON(atomic_read(&sk->sk_refcnt) != 0);
-	aead_put_sgl(sk);
+
+	/* Suspend caller if AIO operations are in flight. */
+	wait_event_interruptible(aead_aio_finish_wait, (ctx->inflight == 0));
+
+	aead_pull_tsgl(sk, 1);
 	sock_kzfree_s(sk, ctx->iv, ivlen);
 	sock_kfree_s(sk, ctx, ctx->len);
 	af_alg_release_parent(sk);
@@ -760,7 +713,7 @@ static int aead_accept_parent(void *private, struct sock *sk)
 {
 	struct aead_ctx *ctx;
 	struct alg_sock *ask = alg_sk(sk);
-	unsigned int len = sizeof(*ctx) + crypto_aead_reqsize(private);
+	unsigned int len = sizeof(*ctx);
 	unsigned int ivlen = crypto_aead_ivsize(private);
 
 	ctx = sock_kmalloc(sk, len, GFP_KERNEL);
@@ -777,20 +730,18 @@ static int aead_accept_parent(void *private, struct sock *sk)
 
 	ctx->len = len;
 	ctx->used = 0;
+	ctx->processed = 0;
 	ctx->more = 0;
 	ctx->merge = 0;
 	ctx->enc = 0;
+	ctx->inflight = 0;
 	ctx->tsgl.cur = 0;
 	ctx->aead_assoclen = 0;
 	af_alg_init_completion(&ctx->completion);
 	sg_init_table(ctx->tsgl.sg, ALG_MAX_PAGES);
-	INIT_LIST_HEAD(&ctx->list);
 
 	ask->private = ctx;
-
-	aead_request_set_tfm(&ctx->aead_req, private);
-	aead_request_set_callback(&ctx->aead_req, CRYPTO_TFM_REQ_MAY_BACKLOG,
-				  af_alg_complete, &ctx->completion);
+	ctx->aead_tfm = private;
 
 	sk->sk_destruct = aead_sock_destruct;
 
-- 
2.9.3
