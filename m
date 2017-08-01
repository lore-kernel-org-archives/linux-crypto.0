From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: [PATCH] crypto: AF_ALG - consolidate common code in recvmsg
Date: Tue, 01 Aug 2017 08:26:41 +0200
Message-ID: <14040146.L7RloSqObM@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:60912 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751038AbdHAG0o (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 1 Aug 2017 02:26:44 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The recvmsg handler has the following common code that is consolidated:

* af_alg_alloc_areq: allocation of the request data structure for the
  cipher operation

* af_alg_get_rsgl: creation of the RX SGL anchored in the request data
  structure

The request data structure is extended by the field last_rsgl which
points to the last RX SGL list entry. This shall help recvmsg
implementation to chain the RX SGL to other SG(L)s if needed. It is
currently used by algif_aead which chains the tag SGL to the RX SGL
during decryption.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/af_alg.c         | 96 +++++++++++++++++++++++++++++++++++++++++++++++++
 crypto/algif_aead.c     | 70 ++++++------------------------------
 crypto/algif_skcipher.c | 65 +++++----------------------------
 include/crypto/if_alg.h |  7 ++++
 4 files changed, 121 insertions(+), 117 deletions(-)

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index ae0e93103c76..d6936c0e08d9 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -1104,6 +1104,102 @@ unsigned int af_alg_poll(struct file *file, struct socket *sock,
 }
 EXPORT_SYMBOL_GPL(af_alg_poll);
 
+/**
+ * af_alg_alloc_areq - allocate struct af_alg_async_req
+ *
+ * @sk socket of connection to user space
+ * @areqlen size of struct af_alg_async_req + crypto_*_reqsize
+ * @return allocated data structure or ERR_PTR upon error
+ */
+struct af_alg_async_req *af_alg_alloc_areq(struct sock *sk,
+					   unsigned int areqlen)
+{
+	struct af_alg_async_req *areq = sock_kmalloc(sk, areqlen, GFP_KERNEL);
+
+	if (unlikely(!areq))
+		return ERR_PTR(-ENOMEM);
+
+	areq->areqlen = areqlen;
+	areq->sk = sk;
+	areq->last_rsgl = NULL;
+	INIT_LIST_HEAD(&areq->rsgl_list);
+	areq->tsgl = NULL;
+	areq->tsgl_entries = 0;
+
+	return areq;
+}
+EXPORT_SYMBOL_GPL(af_alg_alloc_areq);
+
+/**
+ * af_alg_get_rsgl - create the RX SGL for the output data from the crypto
+ *		     operation
+ *
+ * @sk socket of connection to user space
+ * @msg user space message
+ * @flags flags used to invoke recvmsg with
+ * @areq instance of the cryptographic request that will hold the RX SGL
+ * @maxsize maximum number of bytes to be pulled from user space
+ * @outlen number of bytes in the RX SGL
+ * @return 0 on success, < 0 upon error
+ */
+int af_alg_get_rsgl(struct sock *sk, struct msghdr *msg, int flags,
+		    struct af_alg_async_req *areq, size_t maxsize,
+		    size_t *outlen)
+{
+	struct alg_sock *ask = alg_sk(sk);
+	struct af_alg_ctx *ctx = ask->private;
+	size_t len = 0;
+
+	while (maxsize > len && msg_data_left(msg)) {
+		struct af_alg_rsgl *rsgl;
+		size_t seglen;
+		int err;
+
+		/* limit the amount of readable buffers */
+		if (!af_alg_readable(sk))
+			break;
+
+		if (!ctx->used) {
+			err = af_alg_wait_for_data(sk, flags);
+			if (err)
+				return err;
+		}
+
+		seglen = min_t(size_t, (maxsize - len),
+			       msg_data_left(msg));
+
+		if (list_empty(&areq->rsgl_list)) {
+			rsgl = &areq->first_rsgl;
+		} else {
+			rsgl = sock_kmalloc(sk, sizeof(*rsgl), GFP_KERNEL);
+			if (unlikely(!rsgl))
+				return -ENOMEM;
+		}
+
+		rsgl->sgl.npages = 0;
+		list_add_tail(&rsgl->list, &areq->rsgl_list);
+
+		/* make one iovec available as scatterlist */
+		err = af_alg_make_sg(&rsgl->sgl, &msg->msg_iter, seglen);
+		if (err < 0)
+			return err;
+
+		/* chain the new scatterlist with previous one */
+		if (areq->last_rsgl)
+			af_alg_link_sg(&areq->last_rsgl->sgl, &rsgl->sgl);
+
+		areq->last_rsgl = rsgl;
+		len += err;
+		ctx->rcvused += err;
+		rsgl->sg_num_bytes = err;
+		iov_iter_advance(&msg->msg_iter, err);
+	}
+
+	*outlen = len;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(af_alg_get_rsgl);
+
 static int __init af_alg_init(void)
 {
 	int err = proto_register(&alg_proto, 0);
diff --git a/crypto/algif_aead.c b/crypto/algif_aead.c
index 478bacf30079..48d46e74ed0d 100644
--- a/crypto/algif_aead.c
+++ b/crypto/algif_aead.c
@@ -102,10 +102,7 @@ static int _aead_recvmsg(struct socket *sock, struct msghdr *msg,
 	struct crypto_aead *tfm = aeadc->aead;
 	struct crypto_skcipher *null_tfm = aeadc->null_tfm;
 	unsigned int as = crypto_aead_authsize(tfm);
-	unsigned int areqlen =
-		sizeof(struct af_alg_async_req) + crypto_aead_reqsize(tfm);
 	struct af_alg_async_req *areq;
-	struct af_alg_rsgl *last_rsgl = NULL;
 	struct af_alg_tsgl *tsgl;
 	struct scatterlist *src;
 	int err = 0;
@@ -152,61 +149,15 @@ static int _aead_recvmsg(struct socket *sock, struct msghdr *msg,
 	used -= ctx->aead_assoclen;
 
 	/* Allocate cipher request for current operation. */
-	areq = sock_kmalloc(sk, areqlen, GFP_KERNEL);
-	if (unlikely(!areq))
-		return -ENOMEM;
-	areq->areqlen = areqlen;
-	areq->sk = sk;
-	INIT_LIST_HEAD(&areq->rsgl_list);
-	areq->tsgl = NULL;
-	areq->tsgl_entries = 0;
+	areq = af_alg_alloc_areq(sk, sizeof(struct af_alg_async_req) +
+				     crypto_aead_reqsize(tfm));
+	if (IS_ERR(areq))
+		return PTR_ERR(areq);
 
 	/* convert iovecs of output buffers into RX SGL */
-	while (outlen > usedpages && msg_data_left(msg)) {
-		struct af_alg_rsgl *rsgl;
-		size_t seglen;
-
-		/* limit the amount of readable buffers */
-		if (!af_alg_readable(sk))
-			break;
-
-		if (!ctx->used) {
-			err = af_alg_wait_for_data(sk, flags);
-			if (err)
-				goto free;
-		}
-
-		seglen = min_t(size_t, (outlen - usedpages),
-			       msg_data_left(msg));
-
-		if (list_empty(&areq->rsgl_list)) {
-			rsgl = &areq->first_rsgl;
-		} else {
-			rsgl = sock_kmalloc(sk, sizeof(*rsgl), GFP_KERNEL);
-			if (unlikely(!rsgl)) {
-				err = -ENOMEM;
-				goto free;
-			}
-		}
-
-		rsgl->sgl.npages = 0;
-		list_add_tail(&rsgl->list, &areq->rsgl_list);
-
-		/* make one iovec available as scatterlist */
-		err = af_alg_make_sg(&rsgl->sgl, &msg->msg_iter, seglen);
-		if (err < 0)
-			goto free;
-
-		/* chain the new scatterlist with previous one */
-		if (last_rsgl)
-			af_alg_link_sg(&last_rsgl->sgl, &rsgl->sgl);
-
-		last_rsgl = rsgl;
-		usedpages += err;
-		ctx->rcvused += err;
-		rsgl->sg_num_bytes = err;
-		iov_iter_advance(&msg->msg_iter, err);
-	}
+	err = af_alg_get_rsgl(sk, msg, flags, areq, outlen, &usedpages);
+	if (err)
+		goto free;
 
 	/*
 	 * Ensure output buffer is sufficiently large. If the caller provides
@@ -297,9 +248,9 @@ static int _aead_recvmsg(struct socket *sock, struct msghdr *msg,
 		af_alg_pull_tsgl(sk, processed, areq->tsgl, processed - as);
 
 		/* chain the areq TX SGL holding the tag with RX SGL */
-		if (last_rsgl) {
+		if (usedpages) {
 			/* RX SGL present */
-			struct af_alg_sgl *sgl_prev = &last_rsgl->sgl;
+			struct af_alg_sgl *sgl_prev = &areq->last_rsgl->sgl;
 
 			sg_unmark_end(sgl_prev->sg + sgl_prev->npages - 1);
 			sg_chain(sgl_prev->sg, sgl_prev->npages + 1,
@@ -346,8 +297,7 @@ static int _aead_recvmsg(struct socket *sock, struct msghdr *msg,
 
 free:
 	af_alg_free_areq_sgls(areq);
-	if (areq)
-		sock_kfree_s(sk, areq, areqlen);
+	sock_kfree_s(sk, areq, areq->areqlen);
 
 	return err ? err : outlen;
 }
diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index 5bd85c1dd188..8ae4170aaeb4 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -68,68 +68,20 @@ static int _skcipher_recvmsg(struct socket *sock, struct msghdr *msg,
 	struct skcipher_tfm *skc = pask->private;
 	struct crypto_skcipher *tfm = skc->skcipher;
 	unsigned int bs = crypto_skcipher_blocksize(tfm);
-	unsigned int areqlen = sizeof(struct af_alg_async_req) +
-			       crypto_skcipher_reqsize(tfm);
 	struct af_alg_async_req *areq;
-	struct af_alg_rsgl *last_rsgl = NULL;
 	int err = 0;
 	size_t len = 0;
 
 	/* Allocate cipher request for current operation. */
-	areq = sock_kmalloc(sk, areqlen, GFP_KERNEL);
-	if (unlikely(!areq))
-		return -ENOMEM;
-	areq->areqlen = areqlen;
-	areq->sk = sk;
-	INIT_LIST_HEAD(&areq->rsgl_list);
-	areq->tsgl = NULL;
-	areq->tsgl_entries = 0;
+	areq = af_alg_alloc_areq(sk, sizeof(struct af_alg_async_req) +
+				     crypto_skcipher_reqsize(tfm));
+	if (IS_ERR(areq))
+		return PTR_ERR(areq);
 
 	/* convert iovecs of output buffers into RX SGL */
-	while (msg_data_left(msg)) {
-		struct af_alg_rsgl *rsgl;
-		size_t seglen;
-
-		/* limit the amount of readable buffers */
-		if (!af_alg_readable(sk))
-			break;
-
-		if (!ctx->used) {
-			err = af_alg_wait_for_data(sk, flags);
-			if (err)
-				goto free;
-		}
-
-		seglen = min_t(size_t, ctx->used, msg_data_left(msg));
-
-		if (list_empty(&areq->rsgl_list)) {
-			rsgl = &areq->first_rsgl;
-		} else {
-			rsgl = sock_kmalloc(sk, sizeof(*rsgl), GFP_KERNEL);
-			if (!rsgl) {
-				err = -ENOMEM;
-				goto free;
-			}
-		}
-
-		rsgl->sgl.npages = 0;
-		list_add_tail(&rsgl->list, &areq->rsgl_list);
-
-		/* make one iovec available as scatterlist */
-		err = af_alg_make_sg(&rsgl->sgl, &msg->msg_iter, seglen);
-		if (err < 0)
-			goto free;
-
-		/* chain the new scatterlist with previous one */
-		if (last_rsgl)
-			af_alg_link_sg(&last_rsgl->sgl, &rsgl->sgl);
-
-		last_rsgl = rsgl;
-		len += err;
-		ctx->rcvused += err;
-		rsgl->sg_num_bytes = err;
-		iov_iter_advance(&msg->msg_iter, err);
-	}
+	err = af_alg_get_rsgl(sk, msg, flags, areq, -1, &len);
+	if (err)
+		goto free;
 
 	/* Process only as much RX buffers for which we have TX data */
 	if (len > ctx->used)
@@ -197,8 +149,7 @@ static int _skcipher_recvmsg(struct socket *sock, struct msghdr *msg,
 
 free:
 	af_alg_free_areq_sgls(areq);
-	if (areq)
-		sock_kfree_s(sk, areq, areqlen);
+	sock_kfree_s(sk, areq, areq->areqlen);
 
 	return err ? err : len;
 }
diff --git a/include/crypto/if_alg.h b/include/crypto/if_alg.h
index 7bac3fee6061..75ec9c662268 100644
--- a/include/crypto/if_alg.h
+++ b/include/crypto/if_alg.h
@@ -93,6 +93,7 @@ struct af_alg_rsgl {
  * @iocb:		IOCB for AIO operations
  * @sk:			Socket the request is associated with
  * @first_rsgl:		First RX SG
+ * @last_rsgl:		Pointer to last RX SG
  * @rsgl_list:		Track RX SGs
  * @tsgl:		Private, per request TX SGL of buffers to process
  * @tsgl_entries:	Number of entries in priv. TX SGL
@@ -105,6 +106,7 @@ struct af_alg_async_req {
 	struct sock *sk;
 
 	struct af_alg_rsgl first_rsgl;
+	struct af_alg_rsgl *last_rsgl;
 	struct list_head rsgl_list;
 
 	struct scatterlist *tsgl;
@@ -256,5 +258,10 @@ ssize_t af_alg_sendpage(struct socket *sock, struct page *page,
 void af_alg_async_cb(struct crypto_async_request *_req, int err);
 unsigned int af_alg_poll(struct file *file, struct socket *sock,
 			 poll_table *wait);
+struct af_alg_async_req *af_alg_alloc_areq(struct sock *sk,
+					   unsigned int areqlen);
+int af_alg_get_rsgl(struct sock *sk, struct msghdr *msg, int flags,
+		    struct af_alg_async_req *areq, size_t maxsize,
+		    size_t *outlen);
 
 #endif	/* _CRYPTO_IF_ALG_H */
-- 
2.13.3
