From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: [PATCH v2 1/2] crypto: skcipher AF_ALG - overhaul memory management
Date: Wed, 08 Feb 2017 21:15:15 +0100
Message-ID: <2948221.o8bBGdTGNn@positron.chronox.de>
References: <2626546.tAxUg930Nc@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:55802 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751394AbdBHUQ1 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 8 Feb 2017 15:16:27 -0500
In-Reply-To: <2626546.tAxUg930Nc@positron.chronox.de>
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

In addition, the code structure is adjusted to match the structure of
algif_aead for easier code assessment.

The user space interface changed slightly as follows: the old AIO
operation returned zero upon success and < 0 in case of an error to user
space. As all other AF_ALG interfaces (including the sync skcipher
interface) returned the number of processed bytes upon success and < 0
in case of an error, the new skcipher interface (regardless of AIO or
sync) returns the number of processed bytes in case of success.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/algif_skcipher.c | 472 ++++++++++++++++++++----------------------------
 1 file changed, 193 insertions(+), 279 deletions(-)

diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index a9e79d8..e65ebc4 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -10,6 +10,25 @@
  * Software Foundation; either version 2 of the License, or (at your option)
  * any later version.
  *
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
+ * request is released. The processed TX SGL parts are released together with
+ * the RX SGL release and the offset pointer is reduced by the released
+ * data.
  */
 
 #include <crypto/scatterwalk.h>
@@ -31,78 +50,50 @@ struct skcipher_sg_list {
 	struct scatterlist sg[0];
 };
 
+struct skcipher_rsgl {
+	struct af_alg_sgl sgl;
+	struct list_head list;
+};
+
+struct skcipher_async_req {
+	struct kiocb *iocb;
+	struct sock *sk;
+
+	struct skcipher_rsgl first_sgl;
+	struct list_head rsgl_list;
+
+	unsigned int areqlen;
+	struct skcipher_request req;
+};
+
 struct skcipher_tfm {
 	struct crypto_skcipher *skcipher;
 	bool has_key;
 };
 
 struct skcipher_ctx {
-	struct list_head tsgl;
-	struct af_alg_sgl rsgl;
+	struct list_head tsgl_list;
 
 	void *iv;
 
 	struct af_alg_completion completion;
 
-	atomic_t inflight;
+	unsigned int inflight;
 	size_t used;
+	size_t processed;
 
-	unsigned int len;
 	bool more;
 	bool merge;
 	bool enc;
 
-	struct skcipher_request req;
-};
-
-struct skcipher_async_rsgl {
-	struct af_alg_sgl sgl;
-	struct list_head list;
+	unsigned int len;
 };
 
-struct skcipher_async_req {
-	struct kiocb *iocb;
-	struct skcipher_async_rsgl first_sgl;
-	struct list_head list;
-	struct scatterlist *tsg;
-	atomic_t *inflight;
-	struct skcipher_request req;
-};
+static DECLARE_WAIT_QUEUE_HEAD(skcipher_aio_finish_wait);
 
 #define MAX_SGL_ENTS ((4096 - sizeof(struct skcipher_sg_list)) / \
 		      sizeof(struct scatterlist) - 1)
 
-static void skcipher_free_async_sgls(struct skcipher_async_req *sreq)
-{
-	struct skcipher_async_rsgl *rsgl, *tmp;
-	struct scatterlist *sgl;
-	struct scatterlist *sg;
-	int i, n;
-
-	list_for_each_entry_safe(rsgl, tmp, &sreq->list, list) {
-		af_alg_free_sg(&rsgl->sgl);
-		if (rsgl != &sreq->first_sgl)
-			kfree(rsgl);
-	}
-	sgl = sreq->tsg;
-	n = sg_nents(sgl);
-	for_each_sg(sgl, sg, n, i)
-		put_page(sg_page(sg));
-
-	kfree(sreq->tsg);
-}
-
-static void skcipher_async_cb(struct crypto_async_request *req, int err)
-{
-	struct skcipher_async_req *sreq = req->data;
-	struct kiocb *iocb = sreq->iocb;
-
-	atomic_dec(sreq->inflight);
-	skcipher_free_async_sgls(sreq);
-	kzfree(sreq);
-	iocb->ki_complete(iocb, err, err);
-}
-
 static inline int skcipher_sndbuf(struct sock *sk)
 {
 	struct alg_sock *ask = alg_sk(sk);
@@ -117,15 +108,15 @@ static inline bool skcipher_writable(struct sock *sk)
 	return PAGE_SIZE <= skcipher_sndbuf(sk);
 }
 
-static int skcipher_alloc_sgl(struct sock *sk)
+static int skcipher_alloc_tsgl(struct sock *sk)
 {
 	struct alg_sock *ask = alg_sk(sk);
 	struct skcipher_ctx *ctx = ask->private;
 	struct skcipher_sg_list *sgl;
 	struct scatterlist *sg = NULL;
 
-	sgl = list_entry(ctx->tsgl.prev, struct skcipher_sg_list, list);
-	if (!list_empty(&ctx->tsgl))
+	sgl = list_entry(ctx->tsgl_list.prev, struct skcipher_sg_list, list);
+	if (!list_empty(&ctx->tsgl_list))
 		sg = sgl->sg;
 
 	if (!sg || sgl->cur >= MAX_SGL_ENTS) {
@@ -141,13 +132,13 @@ static int skcipher_alloc_sgl(struct sock *sk)
 		if (sg)
 			sg_chain(sg, MAX_SGL_ENTS + 1, sgl->sg);
 
-		list_add_tail(&sgl->list, &ctx->tsgl);
+		list_add_tail(&sgl->list, &ctx->tsgl_list);
 	}
 
 	return 0;
 }
 
-static void skcipher_pull_sgl(struct sock *sk, size_t used, int put)
+static void skcipher_pull_tsgl(struct sock *sk, size_t used)
 {
 	struct alg_sock *ask = alg_sk(sk);
 	struct skcipher_ctx *ctx = ask->private;
@@ -155,8 +146,8 @@ static void skcipher_pull_sgl(struct sock *sk, size_t used, int put)
 	struct scatterlist *sg;
 	int i;
 
-	while (!list_empty(&ctx->tsgl)) {
-		sgl = list_first_entry(&ctx->tsgl, struct skcipher_sg_list,
+	while (!list_empty(&ctx->tsgl_list)) {
+		sgl = list_first_entry(&ctx->tsgl_list, struct skcipher_sg_list,
 				       list);
 		sg = sgl->sg;
 
@@ -171,30 +162,35 @@ static void skcipher_pull_sgl(struct sock *sk, size_t used, int put)
 
 			used -= plen;
 			ctx->used -= plen;
+			ctx->processed -= plen;
 
 			if (sg[i].length)
 				return;
-			if (put)
-				put_page(sg_page(sg + i));
+
+			put_page(sg_page(sg + i));
 			sg_assign_page(sg + i, NULL);
 		}
 
 		list_del(&sgl->list);
-		sock_kfree_s(sk, sgl,
-			     sizeof(*sgl) + sizeof(sgl->sg[0]) *
-					    (MAX_SGL_ENTS + 1));
+		sock_kfree_s(sk, sgl, sizeof(*sgl) + sizeof(sgl->sg[0]) *
+						     (MAX_SGL_ENTS + 1));
 	}
 
 	if (!ctx->used)
 		ctx->merge = 0;
 }
 
-static void skcipher_free_sgl(struct sock *sk)
+static void skcipher_free_rsgl(struct skcipher_async_req *areq)
 {
-	struct alg_sock *ask = alg_sk(sk);
-	struct skcipher_ctx *ctx = ask->private;
+	struct sock *sk = areq->sk;
+	struct skcipher_rsgl *rsgl, *tmp;
 
-	skcipher_pull_sgl(sk, ctx->used, 1);
+	list_for_each_entry_safe(rsgl, tmp, &areq->rsgl_list, list) {
+		af_alg_free_sg(&rsgl->sgl);
+		list_del(&rsgl->list);
+		if (rsgl != &areq->first_sgl)
+			sock_kfree_s(sk, rsgl, sizeof(*rsgl));
+	}
 }
 
 static int skcipher_wait_for_wmem(struct sock *sk, unsigned flags)
@@ -348,7 +344,7 @@ static int skcipher_sendmsg(struct socket *sock, struct msghdr *msg,
 		size_t plen;
 
 		if (ctx->merge) {
-			sgl = list_entry(ctx->tsgl.prev,
+			sgl = list_entry(ctx->tsgl_list.prev,
 					 struct skcipher_sg_list, list);
 			sg = sgl->sg + sgl->cur - 1;
 			len = min_t(unsigned long, len,
@@ -378,11 +374,12 @@ static int skcipher_sendmsg(struct socket *sock, struct msghdr *msg,
 
 		len = min_t(unsigned long, len, skcipher_sndbuf(sk));
 
-		err = skcipher_alloc_sgl(sk);
+		err = skcipher_alloc_tsgl(sk);
 		if (err)
 			goto unlock;
 
-		sgl = list_entry(ctx->tsgl.prev, struct skcipher_sg_list, list);
+		sgl = list_entry(ctx->tsgl_list.prev, struct skcipher_sg_list,
+				 list);
 		sg = sgl->sg;
 		if (sgl->cur)
 			sg_unmark_end(sg + sgl->cur - 1);
@@ -453,12 +450,12 @@ static ssize_t skcipher_sendpage(struct socket *sock, struct page *page,
 			goto unlock;
 	}
 
-	err = skcipher_alloc_sgl(sk);
+	err = skcipher_alloc_tsgl(sk);
 	if (err)
 		goto unlock;
 
 	ctx->merge = 0;
-	sgl = list_entry(ctx->tsgl.prev, struct skcipher_sg_list, list);
+	sgl = list_entry(ctx->tsgl_list.prev, struct skcipher_sg_list, list);
 
 	if (sgl->cur)
 		sg_unmark_end(sgl->sg + sgl->cur - 1);
@@ -479,25 +476,37 @@ static ssize_t skcipher_sendpage(struct socket *sock, struct page *page,
 	return err ?: size;
 }
 
-static int skcipher_all_sg_nents(struct skcipher_ctx *ctx)
+static void skcipher_async_cb(struct crypto_async_request *req, int err)
 {
-	struct skcipher_sg_list *sgl;
-	struct scatterlist *sg;
-	int nents = 0;
+	struct skcipher_async_req *areq = req->data;
+	struct sock *sk = areq->sk;
+	struct alg_sock *ask = alg_sk(sk);
+	struct skcipher_ctx *ctx = ask->private;
+	struct kiocb *iocb = areq->iocb;
+	unsigned int resultlen;
 
-	list_for_each_entry(sgl, &ctx->tsgl, list) {
-		sg = sgl->sg;
+	lock_sock(sk);
 
-		while (!sg->length)
-			sg++;
+	BUG_ON(!ctx->inflight);
 
-		nents += sg_nents(sg);
-	}
-	return nents;
+	/* Buffer size written by crypto operation. */
+	resultlen = areq->req.cryptlen;
+
+	skcipher_free_rsgl(areq);
+	skcipher_pull_tsgl(sk, areq->req.cryptlen);
+	sock_kfree_s(sk, areq, areq->areqlen);
+	__sock_put(sk);
+	ctx->inflight--;
+
+	iocb->ki_complete(iocb, err ? err : resultlen, 0);
+
+	release_sock(sk);
+
+	wake_up_interruptible(&skcipher_aio_finish_wait);
 }
 
-static int skcipher_recvmsg_async(struct socket *sock, struct msghdr *msg,
-				  int flags)
+static int skcipher_recvmsg(struct socket *sock, struct msghdr *msg,
+			    size_t ignored, int flags)
 {
 	struct sock *sk = sock->sk;
 	struct alg_sock *ask = alg_sk(sk);
@@ -506,215 +515,131 @@ static int skcipher_recvmsg_async(struct socket *sock, struct msghdr *msg,
 	struct skcipher_ctx *ctx = ask->private;
 	struct skcipher_tfm *skc = pask->private;
 	struct crypto_skcipher *tfm = skc->skcipher;
-	struct skcipher_sg_list *sgl;
-	struct scatterlist *sg;
-	struct skcipher_async_req *sreq;
-	struct skcipher_request *req;
-	struct skcipher_async_rsgl *last_rsgl = NULL;
-	unsigned int txbufs = 0, len = 0, tx_nents;
-	unsigned int reqsize = crypto_skcipher_reqsize(tfm);
-	unsigned int ivsize = crypto_skcipher_ivsize(tfm);
+	unsigned int bs = crypto_skcipher_blocksize(tfm);
+	unsigned int areqlen = sizeof(struct skcipher_async_req) +
+			       crypto_skcipher_reqsize(tfm);
+	struct skcipher_sg_list *tsgl;
+	struct skcipher_async_req *areq;
+	struct skcipher_rsgl *last_rsgl = NULL;
+	struct scatterlist tsgl_head[2], *tsgl_head_p;
 	int err = -ENOMEM;
-	bool mark = false;
-	char *iv;
-
-	sreq = kzalloc(sizeof(*sreq) + reqsize + ivsize, GFP_KERNEL);
-	if (unlikely(!sreq))
-		goto out;
-
-	req = &sreq->req;
-	iv = (char *)(req + 1) + reqsize;
-	sreq->iocb = msg->msg_iocb;
-	INIT_LIST_HEAD(&sreq->list);
-	sreq->inflight = &ctx->inflight;
+	size_t len = 0;
 
 	lock_sock(sk);
-	tx_nents = skcipher_all_sg_nents(ctx);
-	sreq->tsg = kcalloc(tx_nents, sizeof(*sg), GFP_KERNEL);
-	if (unlikely(!sreq->tsg))
+
+	/* Allocate cipher request for current operation. */
+	areq = sock_kmalloc(sk, areqlen, GFP_KERNEL);
+	if (unlikely(!areq))
 		goto unlock;
-	sg_init_table(sreq->tsg, tx_nents);
-	memcpy(iv, ctx->iv, ivsize);
-	skcipher_request_set_tfm(req, tfm);
-	skcipher_request_set_callback(req, CRYPTO_TFM_REQ_MAY_SLEEP,
-				      skcipher_async_cb, sreq);
+	areq->areqlen = areqlen;
+	areq->sk = sk;
+	INIT_LIST_HEAD(&areq->rsgl_list);
 
-	while (iov_iter_count(&msg->msg_iter)) {
-		struct skcipher_async_rsgl *rsgl;
-		int used;
+	/* convert iovecs of output buffers into RX SGL */
+	while (len < ctx->used && iov_iter_count(&msg->msg_iter)) {
+		struct skcipher_rsgl *rsgl;
+		size_t seglen;
 
 		if (!ctx->used) {
 			err = skcipher_wait_for_data(sk, flags);
 			if (err)
 				goto free;
 		}
-		sgl = list_first_entry(&ctx->tsgl,
-				       struct skcipher_sg_list, list);
-		sg = sgl->sg;
 
-		while (!sg->length)
-			sg++;
-
-		used = min_t(unsigned long, ctx->used,
-			     iov_iter_count(&msg->msg_iter));
-		used = min_t(unsigned long, used, sg->length);
-
-		if (txbufs == tx_nents) {
-			struct scatterlist *tmp;
-			int x;
-			/* Ran out of tx slots in async request
-			 * need to expand */
-			tmp = kcalloc(tx_nents * 2, sizeof(*tmp),
-				      GFP_KERNEL);
-			if (!tmp) {
-				err = -ENOMEM;
-				goto free;
-			}
+		seglen = min_t(size_t, ctx->used,
+			       iov_iter_count(&msg->msg_iter));
 
-			sg_init_table(tmp, tx_nents * 2);
-			for (x = 0; x < tx_nents; x++)
-				sg_set_page(&tmp[x], sg_page(&sreq->tsg[x]),
-					    sreq->tsg[x].length,
-					    sreq->tsg[x].offset);
-			kfree(sreq->tsg);
-			sreq->tsg = tmp;
-			tx_nents *= 2;
-			mark = true;
-		}
-		/* Need to take over the tx sgl from ctx
-		 * to the asynch req - these sgls will be freed later */
-		sg_set_page(sreq->tsg + txbufs++, sg_page(sg), sg->length,
-			    sg->offset);
-
-		if (list_empty(&sreq->list)) {
-			rsgl = &sreq->first_sgl;
-			list_add_tail(&rsgl->list, &sreq->list);
+		if (list_empty(&areq->rsgl_list)) {
+			rsgl = &areq->first_sgl;
 		} else {
-			rsgl = kmalloc(sizeof(*rsgl), GFP_KERNEL);
+			rsgl = sock_kmalloc(sk, sizeof(*rsgl), GFP_KERNEL);
 			if (!rsgl) {
 				err = -ENOMEM;
 				goto free;
 			}
-			list_add_tail(&rsgl->list, &sreq->list);
 		}
 
-		used = af_alg_make_sg(&rsgl->sgl, &msg->msg_iter, used);
-		err = used;
-		if (used < 0)
+		rsgl->sgl.npages = 0;
+		list_add_tail(&rsgl->list, &areq->rsgl_list);
+
+		/* make one iovec available as scatterlist */
+		err = af_alg_make_sg(&rsgl->sgl, &msg->msg_iter, seglen);
+		if (err < 0)
 			goto free;
+
+		/* chain the new scatterlist with previous one */
 		if (last_rsgl)
 			af_alg_link_sg(&last_rsgl->sgl, &rsgl->sgl);
 
 		last_rsgl = rsgl;
-		len += used;
-		skcipher_pull_sgl(sk, used, 0);
-		iov_iter_advance(&msg->msg_iter, used);
+		len += err;
+		iov_iter_advance(&msg->msg_iter, err);
 	}
 
-	if (mark)
-		sg_mark_end(sreq->tsg + txbufs - 1);
+	/* Process only as much RX buffers for which we have TX data */
+	if (len > ctx->used)
+		len = ctx->used;
+
+	/*
+	 * If more buffers are to be expected to be processed, process only
+	 * full block size buffers.
+	 */
+	if (ctx->more || len < ctx->used)
+		len -= len % bs;
+
+	tsgl = list_first_entry(&ctx->tsgl_list, struct skcipher_sg_list, list);
+	/* Get the head of the SGL we want to process */
+	tsgl_head_p = scatterwalk_ffwd(tsgl_head, tsgl->sg, ctx->processed);
+	BUG_ON(!tsgl_head_p);
+
+	/* Initialize the crypto operation */
+	skcipher_request_set_tfm(&areq->req, tfm);
+	skcipher_request_set_crypt(&areq->req, tsgl_head_p,
+				   areq->first_sgl.sgl.sg, len, ctx->iv);
+
+	if (msg->msg_iocb && !is_sync_kiocb(msg->msg_iocb)) {
+		/* AIO operation */
+		areq->iocb = msg->msg_iocb;
+		skcipher_request_set_callback(&areq->req,
+					      CRYPTO_TFM_REQ_MAY_SLEEP,
+					      skcipher_async_cb, areq);
+		err = ctx->enc ? crypto_skcipher_encrypt(&areq->req) :
+				 crypto_skcipher_decrypt(&areq->req);
+	} else {
+		/* Synchronous operation */
+		skcipher_request_set_callback(&areq->req,
+					      CRYPTO_TFM_REQ_MAY_SLEEP |
+					      CRYPTO_TFM_REQ_MAY_BACKLOG,
+					      af_alg_complete,
+					      &ctx->completion);
+		err = af_alg_wait_for_completion(ctx->enc ?
+					crypto_skcipher_encrypt(&areq->req) :
+					crypto_skcipher_decrypt(&areq->req),
+						 &ctx->completion);
+	}
 
-	skcipher_request_set_crypt(req, sreq->tsg, sreq->first_sgl.sgl.sg,
-				   len, iv);
-	err = ctx->enc ? crypto_skcipher_encrypt(req) :
-			 crypto_skcipher_decrypt(req);
+	/* AIO operation in progress */
 	if (err == -EINPROGRESS) {
-		atomic_inc(&ctx->inflight);
+		sock_hold(sk);
 		err = -EIOCBQUEUED;
-		sreq = NULL;
+		ctx->inflight++;
+		/* Remember the TX bytes that were processed. */
+		ctx->processed += len;
 		goto unlock;
-	}
-free:
-	skcipher_free_async_sgls(sreq);
-unlock:
-	skcipher_wmem_wakeup(sk);
-	release_sock(sk);
-	kzfree(sreq);
-out:
-	return err;
-}
-
-static int skcipher_recvmsg_sync(struct socket *sock, struct msghdr *msg,
-				 int flags)
-{
-	struct sock *sk = sock->sk;
-	struct alg_sock *ask = alg_sk(sk);
-	struct sock *psk = ask->parent;
-	struct alg_sock *pask = alg_sk(psk);
-	struct skcipher_ctx *ctx = ask->private;
-	struct skcipher_tfm *skc = pask->private;
-	struct crypto_skcipher *tfm = skc->skcipher;
-	unsigned bs = crypto_skcipher_blocksize(tfm);
-	struct skcipher_sg_list *sgl;
-	struct scatterlist *sg;
-	int err = -EAGAIN;
-	int used;
-	long copied = 0;
-
-	lock_sock(sk);
-	while (msg_data_left(msg)) {
-		if (!ctx->used) {
-			err = skcipher_wait_for_data(sk, flags);
-			if (err)
-				goto unlock;
-		}
-
-		used = min_t(unsigned long, ctx->used, msg_data_left(msg));
-
-		used = af_alg_make_sg(&ctx->rsgl, &msg->msg_iter, used);
-		err = used;
-		if (err < 0)
-			goto unlock;
-
-		if (ctx->more || used < ctx->used)
-			used -= used % bs;
-
-		err = -EINVAL;
-		if (!used)
-			goto free;
-
-		sgl = list_first_entry(&ctx->tsgl,
-				       struct skcipher_sg_list, list);
-		sg = sgl->sg;
-
-		while (!sg->length)
-			sg++;
-
-		skcipher_request_set_crypt(&ctx->req, sg, ctx->rsgl.sg, used,
-					   ctx->iv);
-
-		err = af_alg_wait_for_completion(
-				ctx->enc ?
-					crypto_skcipher_encrypt(&ctx->req) :
-					crypto_skcipher_decrypt(&ctx->req),
-				&ctx->completion);
+	} else if (!err)
+		/* Remember the TX bytes that were processed. */
+		ctx->processed += len;
 
 free:
-		af_alg_free_sg(&ctx->rsgl);
-
-		if (err)
-			goto unlock;
-
-		copied += used;
-		skcipher_pull_sgl(sk, used, 1);
-		iov_iter_advance(&msg->msg_iter, used);
-	}
-
-	err = 0;
+	skcipher_free_rsgl(areq);
+	if (areq)
+		sock_kfree_s(sk, areq, areqlen);
+	skcipher_pull_tsgl(sk, len);
 
 unlock:
 	skcipher_wmem_wakeup(sk);
 	release_sock(sk);
-
-	return copied ?: err;
-}
-
-static int skcipher_recvmsg(struct socket *sock, struct msghdr *msg,
-			    size_t ignored, int flags)
-{
-	return (msg->msg_iocb && !is_sync_kiocb(msg->msg_iocb)) ?
-		skcipher_recvmsg_async(sock, msg, flags) :
-		skcipher_recvmsg_sync(sock, msg, flags);
+	return err ? err : len;
 }
 
 static unsigned int skcipher_poll(struct file *file, struct socket *sock,
@@ -723,10 +648,9 @@ static unsigned int skcipher_poll(struct file *file, struct socket *sock,
 	struct sock *sk = sock->sk;
 	struct alg_sock *ask = alg_sk(sk);
 	struct skcipher_ctx *ctx = ask->private;
-	unsigned int mask;
+	unsigned int mask = 0;
 
 	sock_poll_wait(file, sk_sleep(sk), wait);
-	mask = 0;
 
 	if (ctx->used)
 		mask |= POLLIN | POLLRDNORM;
@@ -894,26 +818,20 @@ static int skcipher_setkey(void *private, const u8 *key, unsigned int keylen)
 	return err;
 }
 
-static void skcipher_wait(struct sock *sk)
-{
-	struct alg_sock *ask = alg_sk(sk);
-	struct skcipher_ctx *ctx = ask->private;
-	int ctr = 0;
-
-	while (atomic_read(&ctx->inflight) && ctr++ < 100)
-		msleep(100);
-}
-
 static void skcipher_sock_destruct(struct sock *sk)
 {
 	struct alg_sock *ask = alg_sk(sk);
 	struct skcipher_ctx *ctx = ask->private;
-	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(&ctx->req);
+	struct sock *psk = ask->parent;
+	struct alg_sock *pask = alg_sk(psk);
+	struct skcipher_tfm *skc = pask->private;
+	struct crypto_skcipher *tfm = skc->skcipher;
 
-	if (atomic_read(&ctx->inflight))
-		skcipher_wait(sk);
+	/* Suspend caller if AIO operations are in flight. */
+	wait_event_interruptible(skcipher_aio_finish_wait,
+				 (ctx->inflight == 0));
 
-	skcipher_free_sgl(sk);
+	skcipher_pull_tsgl(sk, ctx->used);
 	sock_kzfree_s(sk, ctx->iv, crypto_skcipher_ivsize(tfm));
 	sock_kfree_s(sk, ctx, ctx->len);
 	af_alg_release_parent(sk);
@@ -925,7 +843,7 @@ static int skcipher_accept_parent_nokey(void *private, struct sock *sk)
 	struct alg_sock *ask = alg_sk(sk);
 	struct skcipher_tfm *tfm = private;
 	struct crypto_skcipher *skcipher = tfm->skcipher;
-	unsigned int len = sizeof(*ctx) + crypto_skcipher_reqsize(skcipher);
+	unsigned int len = sizeof(*ctx);
 
 	ctx = sock_kmalloc(sk, len, GFP_KERNEL);
 	if (!ctx)
@@ -940,22 +858,18 @@ static int skcipher_accept_parent_nokey(void *private, struct sock *sk)
 
 	memset(ctx->iv, 0, crypto_skcipher_ivsize(skcipher));
 
-	INIT_LIST_HEAD(&ctx->tsgl);
+	INIT_LIST_HEAD(&ctx->tsgl_list);
 	ctx->len = len;
 	ctx->used = 0;
+	ctx->processed = 0;
+	ctx->inflight = 0;
 	ctx->more = 0;
 	ctx->merge = 0;
 	ctx->enc = 0;
-	atomic_set(&ctx->inflight, 0);
 	af_alg_init_completion(&ctx->completion);
 
 	ask->private = ctx;
 
-	skcipher_request_set_tfm(&ctx->req, skcipher);
-	skcipher_request_set_callback(&ctx->req, CRYPTO_TFM_REQ_MAY_SLEEP |
-						 CRYPTO_TFM_REQ_MAY_BACKLOG,
-				      af_alg_complete, &ctx->completion);
-
 	sk->sk_destruct = skcipher_sock_destruct;
 
 	return 0;
-- 
2.9.3
