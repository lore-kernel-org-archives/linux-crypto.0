From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH] crypto: fix AEAD tag memory handling
Date: Wed, 09 Nov 2016 14:20:13 +0100
Message-ID: <13567923.CP2Rp1drvf@positron.chronox.de>
References: <4006219.iWaCqWYv1B@positron.chronox.de> <2822295.gL4fqFHz8h@positron.chronox.de> <alpine.OSX.2.20.1610311456250.4111@mjmartin-mac01.local>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="nextPart1892807.hz7V3SvfF6"
Content-Transfer-Encoding: 7Bit
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
To: Mat Martineau <mathew.j.martineau@linux.intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:47106 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932533AbcKINUY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 9 Nov 2016 08:20:24 -0500
In-Reply-To: <alpine.OSX.2.20.1610311456250.4111@mjmartin-mac01.local>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This is a multi-part message in MIME format.

--nextPart1892807.hz7V3SvfF6
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Am Montag, 31. Oktober 2016, 16:18:32 CET schrieb Mat Martineau:

Hi Mat,
> 
> My main concern is getting the semantics correct and consistent in a
> single patch series. It would be a big problem to explain that AF_ALG AEAD
> read and write works one way in 4.x, another way in 4.y, and some
> different way in 4.z.

I do have a patch now available that exactly does what you suggest. See the 
patch attached. It works with the following exception.

In the case of sendpage and using an in-place cipher operation, the patch 
breaks as follows. When the caller sends the same buffer for a sendpage 
operation, the cipher operation now will write the ciphertext to the beginning 
of the buffer where the AAD used to be. The subsequent tag calculation will 
now use the data it finds where the AAD is expected. As the cipher operation 
has already replaced the AAD with the ciphertext, the tag calculation will 
take the ciphertext as AAD and thus calculate a wrong tag.

Thus, the only way to avoid that would be to duplicate the AAD into an 
internal buffer. But that would defeat the entire purpose of sendpage.

The patch, however, works with sendmsg as well as sendpage when the src and 
dst buffers are different.

Ciao
Stephan
--nextPart1892807.hz7V3SvfF6
Content-Disposition: attachment; filename="fix_read_offset.diff"
Content-Transfer-Encoding: 7Bit
Content-Type: text/x-patch; charset="UTF-8"; name="fix_read_offset.diff"

diff --git a/crypto/algif_aead.c b/crypto/algif_aead.c
index c54bcb8..c8efd01 100644
--- a/crypto/algif_aead.c
+++ b/crypto/algif_aead.c
@@ -32,6 +32,7 @@ struct aead_sg_list {
 struct aead_async_rsgl {
 	struct af_alg_sgl sgl;
 	struct list_head list;
+	bool new_page;
 };
 
 struct aead_async_req {
@@ -405,6 +406,61 @@ static void aead_async_cb(struct crypto_async_request *_req, int err)
 	iocb->ki_complete(iocb, err, err);
 }
 
+/**
+ * scatterwalk_get_part() - get subset a scatterlist
+ *
+ * @dst: destination SGL to receive the pointers from source SGL
+ * @src: source SGL
+ * @len: data length in bytes to get from source SGL
+ * @max_sgs: number of SGs present in dst SGL to prevent overstepping boundaries
+ *
+ * @return: number of SG entries in dst
+ */
+static inline int scatterwalk_get_part(struct scatterlist *dst,
+				       struct scatterlist *src,
+				       unsigned int len, unsigned int max_sgs)
+{
+	/* leave one SG entry for chaining */
+	unsigned int j = 1;
+
+	while (len && j < max_sgs) {
+		unsigned int todo = min_t(unsigned int, len, src->length);
+
+		sg_set_page(dst, sg_page(src), todo, src->offset);
+		if (src->length >= len) {
+			sg_mark_end(dst);
+			break;
+		}
+		len -= todo;
+		j++;
+		src = sg_next(src);
+		dst = sg_next(dst);
+	}
+
+	return j;
+}
+
+static inline int aead_alloc_rsgl(struct sock *sk, struct aead_async_rsgl **ret)
+{
+	struct aead_async_rsgl *rsgl =
+				sock_kmalloc(sk, sizeof(*rsgl), GFP_KERNEL);
+	if (unlikely(!rsgl))
+		return -ENOMEM;
+	*ret = rsgl;
+	return 0;
+}
+
+static inline int aead_get_rsgl_areq(struct sock *sk,
+				     struct aead_async_req *areq,
+				     struct aead_async_rsgl **ret)
+{
+	if (list_empty(&areq->list)) {
+		*ret = &areq->first_rsgl;
+		return 0;
+	} else
+		return aead_alloc_rsgl(sk, ret);
+}
+
 static int aead_recvmsg_async(struct socket *sock, struct msghdr *msg,
 			      int flags)
 {
@@ -433,7 +489,7 @@ static int aead_recvmsg_async(struct socket *sock, struct msghdr *msg,
 	if (!aead_sufficient_data(ctx))
 		goto unlock;
 
-	used = ctx->used;
+	used = ctx->used - ctx->aead_assoclen;
 	if (ctx->enc)
 		outlen = used + as;
 	else
@@ -452,7 +508,6 @@ static int aead_recvmsg_async(struct socket *sock, struct msghdr *msg,
 	aead_request_set_ad(req, ctx->aead_assoclen);
 	aead_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
 				  aead_async_cb, sk);
-	used -= ctx->aead_assoclen;
 
 	/* take over all tx sgls from ctx */
 	areq->tsgl = sock_kmalloc(sk, sizeof(*areq->tsgl) * sgl->cur,
@@ -467,21 +522,26 @@ static int aead_recvmsg_async(struct socket *sock, struct msghdr *msg,
 
 	areq->tsgls = sgl->cur;
 
+	/* set AAD buffer */
+	err = aead_get_rsgl_areq(sk, areq, &rsgl);
+	if (err)
+		goto free;
+	list_add_tail(&rsgl->list, &areq->list);
+	sg_init_table(rsgl->sgl.sg, ALG_MAX_PAGES);
+	rsgl->sgl.npages = scatterwalk_get_part(rsgl->sgl.sg, sgl->sg,
+						ctx->aead_assoclen,
+						ALG_MAX_PAGES);
+	rsgl->new_page = false;
+	last_rsgl = rsgl;
+
 	/* create rx sgls */
 	while (outlen > usedpages && iov_iter_count(&msg->msg_iter)) {
 		size_t seglen = min_t(size_t, iov_iter_count(&msg->msg_iter),
 				      (outlen - usedpages));
 
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
+		err = aead_get_rsgl_areq(sk, areq, &rsgl);
+		if (err)
+			goto free;
 		rsgl->sgl.npages = 0;
 		list_add_tail(&rsgl->list, &areq->list);
 
@@ -491,6 +551,7 @@ static int aead_recvmsg_async(struct socket *sock, struct msghdr *msg,
 			goto free;
 
 		usedpages += err;
+		rsgl->new_page = true;
 
 		/* chain the new scatterlist with previous one */
 		if (last_rsgl)
@@ -531,7 +592,8 @@ static int aead_recvmsg_async(struct socket *sock, struct msghdr *msg,
 
 free:
 	list_for_each_entry(rsgl, &areq->list, list) {
-		af_alg_free_sg(&rsgl->sgl);
+		if (rsgl->new_page)
+			af_alg_free_sg(&rsgl->sgl);
 		if (rsgl != &areq->first_rsgl)
 			sock_kfree_s(sk, rsgl, sizeof(*rsgl));
 	}
@@ -545,6 +607,16 @@ static int aead_recvmsg_async(struct socket *sock, struct msghdr *msg,
 	return err ? err : outlen;
 }
 
+static inline int aead_get_rsgl_ctx(struct sock *sk, struct aead_ctx *ctx,
+				    struct aead_async_rsgl **ret)
+{
+	if (list_empty(&ctx->list)) {
+		*ret = &ctx->first_rsgl;
+		return 0;
+	} else
+		return aead_alloc_rsgl(sk, ret);
+}
+
 static int aead_recvmsg_sync(struct socket *sock, struct msghdr *msg, int flags)
 {
 	struct sock *sk = sock->sk;
@@ -582,9 +654,6 @@ static int aead_recvmsg_sync(struct socket *sock, struct msghdr *msg, int flags)
 			goto unlock;
 	}
 
-	/* data length provided by caller via sendmsg/sendpage */
-	used = ctx->used;
-
 	/*
 	 * Make sure sufficient data is present -- note, the same check is
 	 * is also present in sendmsg/sendpage. The checks in sendpage/sendmsg
@@ -598,6 +667,12 @@ static int aead_recvmsg_sync(struct socket *sock, struct msghdr *msg, int flags)
 		goto unlock;
 
 	/*
+	 * The cipher operation input data is reduced by the associated data
+	 * as the destination buffer will not hold the AAD.
+	 */
+	used = ctx->used - ctx->aead_assoclen;
+
+	/*
 	 * Calculate the minimum output buffer size holding the result of the
 	 * cipher operation. When encrypting data, the receiving buffer is
 	 * larger by the tag length compared to the input buffer as the
@@ -611,25 +686,29 @@ static int aead_recvmsg_sync(struct socket *sock, struct msghdr *msg, int flags)
 		outlen = used - as;
 
 	/*
-	 * The cipher operation input data is reduced by the associated data
-	 * length as this data is processed separately later on.
+	 * Pre-pend the AAD buffer from the source SGL to the destination SGL.
+	 * As the AAD buffer is not touched by the AEAD operation, the source
+	 * SG buffers remain unchanged.
 	 */
-	used -= ctx->aead_assoclen;
+	err = aead_get_rsgl_ctx(sk, ctx, &rsgl);
+	if (err)
+		goto unlock;
+	list_add_tail(&rsgl->list, &ctx->list);
+	sg_init_table(rsgl->sgl.sg, ALG_MAX_PAGES);
+	rsgl->sgl.npages = scatterwalk_get_part(rsgl->sgl.sg, sgl->sg,
+						ctx->aead_assoclen,
+						ALG_MAX_PAGES);
+	rsgl->new_page = false;
+	last_rsgl = rsgl;
 
 	/* convert iovecs of output buffers into scatterlists */
 	while (outlen > usedpages && iov_iter_count(&msg->msg_iter)) {
 		size_t seglen = min_t(size_t, iov_iter_count(&msg->msg_iter),
 				      (outlen - usedpages));
 
-		if (list_empty(&ctx->list)) {
-			rsgl = &ctx->first_rsgl;
-		} else {
-			rsgl = sock_kmalloc(sk, sizeof(*rsgl), GFP_KERNEL);
-			if (unlikely(!rsgl)) {
-				err = -ENOMEM;
-				goto unlock;
-			}
-		}
+		err = aead_get_rsgl_ctx(sk, ctx, &rsgl);
+		if (err)
+			goto unlock;
 		rsgl->sgl.npages = 0;
 		list_add_tail(&rsgl->list, &ctx->list);
 
@@ -637,7 +716,10 @@ static int aead_recvmsg_sync(struct socket *sock, struct msghdr *msg, int flags)
 		err = af_alg_make_sg(&rsgl->sgl, &msg->msg_iter, seglen);
 		if (err < 0)
 			goto unlock;
+
 		usedpages += err;
+		rsgl->new_page = true;
+
 		/* chain the new scatterlist with previous one */
 		if (last_rsgl)
 			af_alg_link_sg(&last_rsgl->sgl, &rsgl->sgl);
@@ -688,7 +770,8 @@ static int aead_recvmsg_sync(struct socket *sock, struct msghdr *msg, int flags)
 
 unlock:
 	list_for_each_entry_safe(rsgl, tmp, &ctx->list, list) {
-		af_alg_free_sg(&rsgl->sgl);
+		if (rsgl->new_page)
+			af_alg_free_sg(&rsgl->sgl);
 		if (rsgl != &ctx->first_rsgl)
 			sock_kfree_s(sk, rsgl, sizeof(*rsgl));
 		list_del(&rsgl->list);

--nextPart1892807.hz7V3SvfF6--
