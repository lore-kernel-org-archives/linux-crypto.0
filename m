From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH v3] crypto: AF_ALG - fix AEAD tag memory handling
Date: Fri, 02 Dec 2016 15:16:26 +0100
Message-ID: <14103787.a1H06iWQgk@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au, mathew.j.martineau@linux.intel.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:52028 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1760451AbcLBOQc (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 2 Dec 2016 09:16:32 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert, Mat,

as Herbert nacked the patch to disregard the AD in the destination buffer, there will be no user space visible buffer length changes apart from the patch below. Therefore, I would like to suggest to include the patch now. The change for the AD copy-over will come in the next cycle.

The patch v3 is unchanged from v2 other than it was applied to the latest and greatest code level.

Thanks
Stephan

---8<---

For encryption, the AEAD ciphers require AAD || PT as input and generate
AAD || CT || Tag as output and vice versa for decryption. Prior to this
patch, the AF_ALG interface for AEAD ciphers requires the buffer to be
present as input for encryption. Similarly, the output buffer for
decryption required the presence of the tag buffer too. This implies
that the kernel reads / writes data buffers from/to kernel space
even though this operation is not required.

This patch changes the AF_ALG AEAD interface to be consistent with the
in-kernel AEAD cipher requirements.

In addition, the code now handles the situation where the provided
output buffer is too small by reducing the size of the processed
input buffer accordingly. Due to this handling, he changes are
transparent to user space with one exception: the return code of recv
indicates the mount of output buffer. That output buffer has a different
size compared to before the patch which implies that the return code of
recv will also be different. For example, a decryption operation uses 16
bytes AAD, 16 bytes CT and 16 bytes tag, the AF_ALG AEAD interface
before showed a recv return code of 48 (bytes) whereas after this patch,
the return code is 32 since the tag is not returned any more.

Reported-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/algif_aead.c | 77 ++++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 55 insertions(+), 22 deletions(-)

diff --git a/crypto/algif_aead.c b/crypto/algif_aead.c
index 6e95137..846ec53 100644
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
 	areq->tsgl = sock_kmalloc(sk,
@@ -462,7 +469,7 @@ static int aead_recvmsg_async(struct socket *sock, struct msghdr *msg,
 	areq->tsgls = sgl->cur;
 
 	/* create rx sgls */
-	while (iov_iter_count(&msg->msg_iter)) {
+	while (outlen > usedpages && iov_iter_count(&msg->msg_iter)) {
 		size_t seglen = min_t(size_t, iov_iter_count(&msg->msg_iter),
 				      (outlen - usedpages));
 
@@ -492,16 +499,20 @@ static int aead_recvmsg_async(struct socket *sock, struct msghdr *msg,
 
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
@@ -572,6 +583,7 @@ static int aead_recvmsg_sync(struct socket *sock, struct msghdr *msg, int flags)
 			goto unlock;
 	}
 
+	/* data length provided by caller via sendmsg/sendpage */
 	used = ctx->used;
 
 	/*
@@ -586,16 +598,27 @@ static int aead_recvmsg_sync(struct socket *sock, struct msghdr *msg, int flags)
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
 
@@ -622,16 +645,26 @@ static int aead_recvmsg_sync(struct socket *sock, struct msghdr *msg, int flags)
 
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
2.9.3
