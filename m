From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 10/14] crypto: aesni - Use new IV convention
Date: Thu, 09 Jul 2015 07:17:28 +0800
Message-ID: <E1ZCyam-0007Zw-BA@gondolin.me.apana.org.au>
References: <20150708231330.GA28797@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:42777 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752890AbbGHXRc (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 8 Jul 2015 19:17:32 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1ZCyan-0005GM-C8
	for <linux-crypto@vger.kernel.org>; Thu, 09 Jul 2015 09:17:29 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch converts rfc4106 to the new calling convention where
the IV is now in the AD and needs to be skipped.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 arch/x86/crypto/aesni-intel_glue.c |   56 +++++++++++++------------------------
 1 file changed, 20 insertions(+), 36 deletions(-)

diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index dccad38..2347ef0 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -803,10 +803,7 @@ static int rfc4106_init(struct crypto_aead *aead)
 		return PTR_ERR(cryptd_tfm);
 
 	*ctx = cryptd_tfm;
-	crypto_aead_set_reqsize(
-		aead,
-		sizeof(struct aead_request) +
-		crypto_aead_reqsize(&cryptd_tfm->base));
+	crypto_aead_set_reqsize(aead, crypto_aead_reqsize(&cryptd_tfm->base));
 	return 0;
 }
 
@@ -955,8 +952,8 @@ static int helper_rfc4106_encrypt(struct aead_request *req)
 
 	/* Assuming we are supporting rfc4106 64-bit extended */
 	/* sequence numbers We need to have the AAD length equal */
-	/* to 8 or 12 bytes */
-	if (unlikely(req->assoclen != 8 && req->assoclen != 12))
+	/* to 16 or 20 bytes */
+	if (unlikely(req->assoclen != 16 && req->assoclen != 20))
 		return -EINVAL;
 
 	/* IV below built */
@@ -992,9 +989,9 @@ static int helper_rfc4106_encrypt(struct aead_request *req)
 	}
 
 	kernel_fpu_begin();
-	aesni_gcm_enc_tfm(aes_ctx, dst, src, (unsigned long)req->cryptlen, iv,
-		ctx->hash_subkey, assoc, (unsigned long)req->assoclen, dst
-		+ ((unsigned long)req->cryptlen), auth_tag_len);
+	aesni_gcm_enc_tfm(aes_ctx, dst, src, req->cryptlen, iv,
+			  ctx->hash_subkey, assoc, req->assoclen - 8,
+			  dst + req->cryptlen, auth_tag_len);
 	kernel_fpu_end();
 
 	/* The authTag (aka the Integrity Check Value) needs to be written
@@ -1033,12 +1030,12 @@ static int helper_rfc4106_decrypt(struct aead_request *req)
 	struct scatter_walk dst_sg_walk;
 	unsigned int i;
 
-	if (unlikely(req->assoclen != 8 && req->assoclen != 12))
+	if (unlikely(req->assoclen != 16 && req->assoclen != 20))
 		return -EINVAL;
 
 	/* Assuming we are supporting rfc4106 64-bit extended */
 	/* sequence numbers We need to have the AAD length */
-	/* equal to 8 or 12 bytes */
+	/* equal to 16 or 20 bytes */
 
 	tempCipherLen = (unsigned long)(req->cryptlen - auth_tag_len);
 	/* IV below built */
@@ -1075,8 +1072,8 @@ static int helper_rfc4106_decrypt(struct aead_request *req)
 
 	kernel_fpu_begin();
 	aesni_gcm_dec_tfm(aes_ctx, dst, src, tempCipherLen, iv,
-		ctx->hash_subkey, assoc, (unsigned long)req->assoclen,
-		authTag, auth_tag_len);
+			  ctx->hash_subkey, assoc, req->assoclen - 8,
+			  authTag, auth_tag_len);
 	kernel_fpu_end();
 
 	/* Compare generated tag with passed in tag. */
@@ -1105,19 +1102,12 @@ static int rfc4106_encrypt(struct aead_request *req)
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
 	struct cryptd_aead **ctx = crypto_aead_ctx(tfm);
 	struct cryptd_aead *cryptd_tfm = *ctx;
-	struct aead_request *subreq = aead_request_ctx(req);
 
-	aead_request_set_tfm(subreq, irq_fpu_usable() ?
-				     cryptd_aead_child(cryptd_tfm) :
-				     &cryptd_tfm->base);
+	aead_request_set_tfm(req, irq_fpu_usable() ?
+				  cryptd_aead_child(cryptd_tfm) :
+				  &cryptd_tfm->base);
 
-	aead_request_set_callback(subreq, req->base.flags,
-				  req->base.complete, req->base.data);
-	aead_request_set_crypt(subreq, req->src, req->dst,
-			       req->cryptlen, req->iv);
-	aead_request_set_ad(subreq, req->assoclen);
-
-	return crypto_aead_encrypt(subreq);
+	return crypto_aead_encrypt(req);
 }
 
 static int rfc4106_decrypt(struct aead_request *req)
@@ -1125,19 +1115,12 @@ static int rfc4106_decrypt(struct aead_request *req)
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
 	struct cryptd_aead **ctx = crypto_aead_ctx(tfm);
 	struct cryptd_aead *cryptd_tfm = *ctx;
-	struct aead_request *subreq = aead_request_ctx(req);
-
-	aead_request_set_tfm(subreq, irq_fpu_usable() ?
-				     cryptd_aead_child(cryptd_tfm) :
-				     &cryptd_tfm->base);
 
-	aead_request_set_callback(subreq, req->base.flags,
-				  req->base.complete, req->base.data);
-	aead_request_set_crypt(subreq, req->src, req->dst,
-			       req->cryptlen, req->iv);
-	aead_request_set_ad(subreq, req->assoclen);
+	aead_request_set_tfm(req, irq_fpu_usable() ?
+				  cryptd_aead_child(cryptd_tfm) :
+				  &cryptd_tfm->base);
 
-	return crypto_aead_decrypt(subreq);
+	return crypto_aead_decrypt(req);
 }
 #endif
 
@@ -1454,7 +1437,8 @@ static struct aead_alg aesni_aead_algs[] = { {
 		.cra_name		= "rfc4106(gcm(aes))",
 		.cra_driver_name	= "rfc4106-gcm-aesni",
 		.cra_priority		= 400,
-		.cra_flags		= CRYPTO_ALG_ASYNC,
+		.cra_flags		= CRYPTO_ALG_ASYNC |
+					  CRYPTO_ALG_AEAD_NEW,
 		.cra_blocksize		= 1,
 		.cra_ctxsize		= sizeof(struct cryptd_aead *),
 		.cra_module		= THIS_MODULE,
