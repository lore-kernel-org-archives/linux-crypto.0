From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 8/8] crypto: rsa-pkcs1pad - Avoid copying output when possible
Date: Wed, 22 Jun 2016 18:16:58 +0800
Message-ID: <E1bFfDO-0007zw-QN@gondolin.me.apana.org.au>
References: <20160622101432.GA30454@gondor.apana.org.au>
To: Andrzej Zaborowski <andrew.zaborowski@intel.com>,
	Tadeusz Struk <tadeusz.struk@intel.com>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Tudor Ambarus <tudor-dan.ambarus@nxp.com>,
	Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:47554 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752624AbcFVMeT (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 22 Jun 2016 08:34:19 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

In the vast majority of cases (2^-32 on 32-bit and 2^-64 on 64-bit)
cases, the result from encryption/signing will require no padding.

This patch makes these two operations write their output directly
to the final destination.  Only in the exceedingly rare cases where
fixup is needed to we copy it out and back to add the leading zeroes.

This patch also makes use of the crypto_akcipher_set_crypt API
instead of writing the akcipher request directly.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/rsa-pkcs1pad.c |  112 ++++++++++++++++++++------------------------------
 1 file changed, 45 insertions(+), 67 deletions(-)

diff --git a/crypto/rsa-pkcs1pad.c b/crypto/rsa-pkcs1pad.c
index ebd8514..8ccfdd7 100644
--- a/crypto/rsa-pkcs1pad.c
+++ b/crypto/rsa-pkcs1pad.c
@@ -185,37 +185,36 @@ static int pkcs1pad_encrypt_sign_complete(struct akcipher_request *req, int err)
 	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
 	struct pkcs1pad_ctx *ctx = akcipher_tfm_ctx(tfm);
 	struct pkcs1pad_request *req_ctx = akcipher_request_ctx(req);
-	size_t pad_len = ctx->key_size - req_ctx->child_req.dst_len;
-	size_t chunk_len, pad_left;
-	struct sg_mapping_iter miter;
-
-	if (!err) {
-		if (pad_len) {
-			sg_miter_start(&miter, req->dst,
-					sg_nents_for_len(req->dst, pad_len),
-					SG_MITER_ATOMIC | SG_MITER_TO_SG);
-
-			pad_left = pad_len;
-			while (pad_left) {
-				sg_miter_next(&miter);
-
-				chunk_len = min(miter.length, pad_left);
-				memset(miter.addr, 0, chunk_len);
-				pad_left -= chunk_len;
-			}
-
-			sg_miter_stop(&miter);
-		}
-
-		sg_pcopy_from_buffer(req->dst,
-				sg_nents_for_len(req->dst, ctx->key_size),
-				req_ctx->out_buf, req_ctx->child_req.dst_len,
-				pad_len);
-	}
+	unsigned int pad_len;
+	unsigned int len;
+	u8 *out_buf;
+
+	if (err)
+		goto out;
+
+	len = req_ctx->child_req.dst_len;
+	pad_len = ctx->key_size - len;
+
+	/* Four billion to one */
+	if (likely(!pad_len))
+		goto out;
+
+	out_buf = kzalloc(ctx->key_size, GFP_ATOMIC);
+	err = -ENOMEM;
+	if (!out_buf)
+		goto out;
+
+	sg_copy_to_buffer(req->dst, sg_nents_for_len(req->dst, len),
+			  out_buf + pad_len, len);
+	sg_copy_from_buffer(req->dst,
+			    sg_nents_for_len(req->dst, ctx->key_size),
+			    out_buf, ctx->key_size);
+	kzfree(out_buf);
+
+out:
 	req->dst_len = ctx->key_size;
 
 	kfree(req_ctx->in_buf);
-	kzfree(req_ctx->out_buf);
 
 	return err;
 }
@@ -255,15 +254,6 @@ static int pkcs1pad_encrypt(struct akcipher_request *req)
 		return -EOVERFLOW;
 	}
 
-	/*
-	 * Replace both input and output to add the padding in the input and
-	 * the potential missing leading zeros in the output.
-	 */
-	req_ctx->child_req.src = req_ctx->in_sg;
-	req_ctx->child_req.src_len = ctx->key_size - 1;
-	req_ctx->child_req.dst = req_ctx->out_sg;
-	req_ctx->child_req.dst_len = ctx->key_size;
-
 	req_ctx->in_buf = kmalloc(ctx->key_size - 1 - req->src_len,
 				  GFP_KERNEL);
 	if (!req_ctx->in_buf)
@@ -291,6 +281,10 @@ static int pkcs1pad_encrypt(struct akcipher_request *req)
 	akcipher_request_set_callback(&req_ctx->child_req, req->base.flags,
 			pkcs1pad_encrypt_sign_complete_cb, req);
 
+	/* Reuse output buffer */
+	akcipher_request_set_crypt(&req_ctx->child_req, req_ctx->in_sg,
+				   req->dst, ctx->key_size - 1, req->dst_len);
+
 	err = crypto_akcipher_encrypt(&req_ctx->child_req);
 	if (err != -EINPROGRESS &&
 			(err != -EBUSY ||
@@ -372,12 +366,6 @@ static int pkcs1pad_decrypt(struct akcipher_request *req)
 	if (!ctx->key_size || req->src_len != ctx->key_size)
 		return -EINVAL;
 
-	/* Reuse input buffer, output to a new buffer */
-	req_ctx->child_req.src = req->src;
-	req_ctx->child_req.src_len = req->src_len;
-	req_ctx->child_req.dst = req_ctx->out_sg;
-	req_ctx->child_req.dst_len = ctx->key_size ;
-
 	req_ctx->out_buf = kmalloc(ctx->key_size, GFP_KERNEL);
 	if (!req_ctx->out_buf)
 		return -ENOMEM;
@@ -389,6 +377,11 @@ static int pkcs1pad_decrypt(struct akcipher_request *req)
 	akcipher_request_set_callback(&req_ctx->child_req, req->base.flags,
 			pkcs1pad_decrypt_complete_cb, req);
 
+	/* Reuse input buffer, output to a new buffer */
+	akcipher_request_set_crypt(&req_ctx->child_req, req->src,
+				   req_ctx->out_sg, req->src_len,
+				   ctx->key_size);
+
 	err = crypto_akcipher_decrypt(&req_ctx->child_req);
 	if (err != -EINPROGRESS &&
 			(err != -EBUSY ||
@@ -422,15 +415,6 @@ static int pkcs1pad_sign(struct akcipher_request *req)
 		return -EOVERFLOW;
 	}
 
-	/*
-	 * Replace both input and output to add the padding in the input and
-	 * the potential missing leading zeros in the output.
-	 */
-	req_ctx->child_req.src = req_ctx->in_sg;
-	req_ctx->child_req.src_len = ctx->key_size - 1;
-	req_ctx->child_req.dst = req_ctx->out_sg;
-	req_ctx->child_req.dst_len = ctx->key_size;
-
 	req_ctx->in_buf = kmalloc(ctx->key_size - 1 - req->src_len,
 				  GFP_KERNEL);
 	if (!req_ctx->in_buf)
@@ -447,19 +431,14 @@ static int pkcs1pad_sign(struct akcipher_request *req)
 	pkcs1pad_sg_set_buf(req_ctx->in_sg, req_ctx->in_buf,
 			ctx->key_size - 1 - req->src_len, req->src);
 
-	req_ctx->out_buf = kmalloc(ctx->key_size, GFP_KERNEL);
-	if (!req_ctx->out_buf) {
-		kfree(req_ctx->in_buf);
-		return -ENOMEM;
-	}
-
-	pkcs1pad_sg_set_buf(req_ctx->out_sg, req_ctx->out_buf,
-			ctx->key_size, NULL);
-
 	akcipher_request_set_tfm(&req_ctx->child_req, ctx->child);
 	akcipher_request_set_callback(&req_ctx->child_req, req->base.flags,
 			pkcs1pad_encrypt_sign_complete_cb, req);
 
+	/* Reuse output buffer */
+	akcipher_request_set_crypt(&req_ctx->child_req, req_ctx->in_sg,
+				   req->dst, ctx->key_size - 1, req->dst_len);
+
 	err = crypto_akcipher_sign(&req_ctx->child_req);
 	if (err != -EINPROGRESS &&
 			(err != -EBUSY ||
@@ -559,12 +538,6 @@ static int pkcs1pad_verify(struct akcipher_request *req)
 	if (!ctx->key_size || req->src_len < ctx->key_size)
 		return -EINVAL;
 
-	/* Reuse input buffer, output to a new buffer */
-	req_ctx->child_req.src = req->src;
-	req_ctx->child_req.src_len = req->src_len;
-	req_ctx->child_req.dst = req_ctx->out_sg;
-	req_ctx->child_req.dst_len = ctx->key_size;
-
 	req_ctx->out_buf = kmalloc(ctx->key_size, GFP_KERNEL);
 	if (!req_ctx->out_buf)
 		return -ENOMEM;
@@ -576,6 +549,11 @@ static int pkcs1pad_verify(struct akcipher_request *req)
 	akcipher_request_set_callback(&req_ctx->child_req, req->base.flags,
 			pkcs1pad_verify_complete_cb, req);
 
+	/* Reuse input buffer, output to a new buffer */
+	akcipher_request_set_crypt(&req_ctx->child_req, req->src,
+				   req_ctx->out_sg, req->src_len,
+				   ctx->key_size);
+
 	err = crypto_akcipher_verify(&req_ctx->child_req);
 	if (err != -EINPROGRESS &&
 			(err != -EBUSY ||
