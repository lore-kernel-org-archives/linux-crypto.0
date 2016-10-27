From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH] crypto: fix AEAD tag memory handling
Date: Thu, 27 Oct 2016 03:00:24 +0200
Message-ID: <4006219.iWaCqWYv1B@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:47012 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932997AbcJ0BAe (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 26 Oct 2016 21:00:34 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

for this patch, I have updated the testing for libkcapi accordingly and all
tests pass. I will push the libkcapi code 0.12 with that test code change
out shortly. Using the current upstream version of 0.11.1 will show failures
as it expects the correct recv return code. As stated below, that return
code has changed which implies that some of the tests will fail.

---8<---

For encryption, the AEAD ciphers require AAD || PT as input and generate
AAD || CT || Tag as output and vice versa for decryption. Prior to this
patch, the AF_ALG interface for AEAD ciphers requires the buffer to be
present as input for encryption. Similarly, the output buffer for
decryption required the presence of the tag buffer too. This implies
that the kernel reads / writes data buffers from/to user space
even though this operation is not required.

This patch changes the AF_ALG AEAD interface to be consistent with the
in-kernel AEAD cipher memory requirements.

In addition, the code now handles the situation where the provided
output buffer is too small by reducing the size of the processed
input buffer accordingly. Due to this handling, the changes are
transparent to user space with one exception: the return code of recv
indicates the processed of output buffer size. That output buffer has a
different size compared to before the patch which implies that the
return code of recv will also be different. For example, a decryption
operation uses 16 bytes AAD, 16 bytes CT and 16 bytes tag, the AF_ALG
AEAD interface before showed a recv return code of 48 (bytes) whereas
after this patch, the return code is 32 since the tag is not returned
any more.

Reported-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/algif_aead.c | 77 ++++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 55 insertions(+), 22 deletions(-)

diff --git a/crypto/algif_aead.c b/crypto/algif_aead.c
index 80a0f1a..c54bcb8 100644
--- a/crypto/algif_aead.c
+++ b/crypto/algif_aead.c
@@ -81,7 +81,11 @@ static inline bool aead_sufficient_data(struct aead_ctx *ctx)
 {
 	unsigned as = crypto_aead_authsize(crypto_aead_reqtfm(&ctx->aead_req));
 
-	return ctx->used >= ctx->aead_assoclen + as;
+	/*
+	 * The minimum amount of memory needed for an AEAD cipher is
+	 * the AAD and in case of decryption the tag.
+	 */
+	return ctx->used >= ctx->aead_assoclen + (ctx->enc ? 0 : as);
 }
 
 static void aead_reset_ctx(struct aead_ctx *ctx)
@@ -426,12 +430,15 @@ static int aead_recvmsg_async(struct socket *sock, struct msghdr *msg,
 			goto unlock;
 	}
 
-	used = ctx->used;
-	outlen = used;
-
 	if (!aead_sufficient_data(ctx))
 		goto unlock;
 
+	used = ctx->used;
+	if (ctx->enc)
+		outlen = used + as;
+	else
+		outlen = used - as;
+
 	req = sock_kmalloc(sk, reqlen, GFP_KERNEL);
 	if (unlikely(!req))
 		goto unlock;
@@ -445,7 +452,7 @@ static int aead_recvmsg_async(struct socket *sock, struct msghdr *msg,
 	aead_request_set_ad(req, ctx->aead_assoclen);
 	aead_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
 				  aead_async_cb, sk);
-	used -= ctx->aead_assoclen + (ctx->enc ? as : 0);
+	used -= ctx->aead_assoclen;
 
 	/* take over all tx sgls from ctx */
 	areq->tsgl = sock_kmalloc(sk, sizeof(*areq->tsgl) * sgl->cur,
@@ -461,7 +468,7 @@ static int aead_recvmsg_async(struct socket *sock, struct msghdr *msg,
 	areq->tsgls = sgl->cur;
 
 	/* create rx sgls */
-	while (iov_iter_count(&msg->msg_iter)) {
+	while (outlen > usedpages && iov_iter_count(&msg->msg_iter)) {
 		size_t seglen = min_t(size_t, iov_iter_count(&msg->msg_iter),
 				      (outlen - usedpages));
 
@@ -491,16 +498,20 @@ static int aead_recvmsg_async(struct socket *sock, struct msghdr *msg,
 
 		last_rsgl = rsgl;
 
-		/* we do not need more iovecs as we have sufficient memory */
-		if (outlen <= usedpages)
-			break;
-
 		iov_iter_advance(&msg->msg_iter, err);
 	}
-	err = -EINVAL;
+
 	/* ensure output buffer is sufficiently large */
-	if (usedpages < outlen)
-		goto free;
+	if (usedpages < outlen) {
+		size_t less = outlen - usedpages;
+
+		if (used < less) {
+			err = -EINVAL;
+			goto unlock;
+		}
+		used -= less;
+		outlen -= less;
+	}
 
 	aead_request_set_crypt(req, areq->tsgl, areq->first_rsgl.sgl.sg, used,
 			       areq->iv);
@@ -571,6 +582,7 @@ static int aead_recvmsg_sync(struct socket *sock, struct msghdr *msg, int flags)
 			goto unlock;
 	}
 
+	/* data length provided by caller via sendmsg/sendpage */
 	used = ctx->used;
 
 	/*
@@ -585,16 +597,27 @@ static int aead_recvmsg_sync(struct socket *sock, struct msghdr *msg, int flags)
 	if (!aead_sufficient_data(ctx))
 		goto unlock;
 
-	outlen = used;
+	/*
+	 * Calculate the minimum output buffer size holding the result of the
+	 * cipher operation. When encrypting data, the receiving buffer is
+	 * larger by the tag length compared to the input buffer as the
+	 * encryption operation generates the tag. For decryption, the input
+	 * buffer provides the tag which is consumed resulting in only the
+	 * plaintext without a buffer for the tag returned to the caller.
+	 */
+	if (ctx->enc)
+		outlen = used + as;
+	else
+		outlen = used - as;
 
 	/*
 	 * The cipher operation input data is reduced by the associated data
 	 * length as this data is processed separately later on.
 	 */
-	used -= ctx->aead_assoclen + (ctx->enc ? as : 0);
+	used -= ctx->aead_assoclen;
 
 	/* convert iovecs of output buffers into scatterlists */
-	while (iov_iter_count(&msg->msg_iter)) {
+	while (outlen > usedpages && iov_iter_count(&msg->msg_iter)) {
 		size_t seglen = min_t(size_t, iov_iter_count(&msg->msg_iter),
 				      (outlen - usedpages));
 
@@ -621,16 +644,26 @@ static int aead_recvmsg_sync(struct socket *sock, struct msghdr *msg, int flags)
 
 		last_rsgl = rsgl;
 
-		/* we do not need more iovecs as we have sufficient memory */
-		if (outlen <= usedpages)
-			break;
 		iov_iter_advance(&msg->msg_iter, err);
 	}
 
-	err = -EINVAL;
 	/* ensure output buffer is sufficiently large */
-	if (usedpages < outlen)
-		goto unlock;
+	if (usedpages < outlen) {
+		size_t less = outlen - usedpages;
+
+		if (used < less) {
+			err = -EINVAL;
+			goto unlock;
+		}
+
+		/*
+		 * Caller has smaller output buffer than needed, reduce
+		 * the input data length to be processed to fit the provided
+		 * output buffer.
+		 */
+		used -= less;
+		outlen -= less;
+	}
 
 	sg_mark_end(sgl->sg + sgl->cur - 1);
 	aead_request_set_crypt(&ctx->aead_req, sgl->sg, ctx->first_rsgl.sgl.sg,
-- 
2.7.4
