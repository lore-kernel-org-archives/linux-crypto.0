From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 20/28] crypto: s390/aes - Use skcipher for fallback
Date: Wed, 29 Jun 2016 18:04:07 +0800
Message-ID: <E1bICLn-0006w9-1q@gondolin.me.apana.org.au>
References: <20160629100223.GA26260@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:54065 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898AbcF2KEK (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 29 Jun 2016 06:04:10 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1bICLn-0005Lf-5e
	for <linux-crypto@vger.kernel.org>; Wed, 29 Jun 2016 20:04:07 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch replaces use of the obsolete blkcipher with skcipher.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 arch/s390/crypto/aes_s390.c |  113 +++++++++++++++++++++++---------------------
 1 file changed, 60 insertions(+), 53 deletions(-)

diff --git a/arch/s390/crypto/aes_s390.c b/arch/s390/crypto/aes_s390.c
index 7554a8b..2ea18b0 100644
--- a/arch/s390/crypto/aes_s390.c
+++ b/arch/s390/crypto/aes_s390.c
@@ -22,6 +22,7 @@
 
 #include <crypto/aes.h>
 #include <crypto/algapi.h>
+#include <crypto/internal/skcipher.h>
 #include <linux/err.h>
 #include <linux/module.h>
 #include <linux/cpufeature.h>
@@ -44,7 +45,7 @@ struct s390_aes_ctx {
 	long dec;
 	int key_len;
 	union {
-		struct crypto_blkcipher *blk;
+		struct crypto_skcipher *blk;
 		struct crypto_cipher *cip;
 	} fallback;
 };
@@ -63,7 +64,7 @@ struct s390_xts_ctx {
 	long enc;
 	long dec;
 	int key_len;
-	struct crypto_blkcipher *fallback;
+	struct crypto_skcipher *fallback;
 };
 
 /*
@@ -237,16 +238,16 @@ static int setkey_fallback_blk(struct crypto_tfm *tfm, const u8 *key,
 	struct s390_aes_ctx *sctx = crypto_tfm_ctx(tfm);
 	unsigned int ret;
 
-	sctx->fallback.blk->base.crt_flags &= ~CRYPTO_TFM_REQ_MASK;
-	sctx->fallback.blk->base.crt_flags |= (tfm->crt_flags &
-			CRYPTO_TFM_REQ_MASK);
+	crypto_skcipher_clear_flags(sctx->fallback.blk, CRYPTO_TFM_REQ_MASK);
+	crypto_skcipher_set_flags(sctx->fallback.blk, tfm->crt_flags &
+						      CRYPTO_TFM_REQ_MASK);
+
+	ret = crypto_skcipher_setkey(sctx->fallback.blk, key, len);
+
+	tfm->crt_flags &= ~CRYPTO_TFM_RES_MASK;
+	tfm->crt_flags |= crypto_skcipher_get_flags(sctx->fallback.blk) &
+			  CRYPTO_TFM_RES_MASK;
 
-	ret = crypto_blkcipher_setkey(sctx->fallback.blk, key, len);
-	if (ret) {
-		tfm->crt_flags &= ~CRYPTO_TFM_RES_MASK;
-		tfm->crt_flags |= (sctx->fallback.blk->base.crt_flags &
-				CRYPTO_TFM_RES_MASK);
-	}
 	return ret;
 }
 
@@ -255,15 +256,17 @@ static int fallback_blk_dec(struct blkcipher_desc *desc,
 		unsigned int nbytes)
 {
 	unsigned int ret;
-	struct crypto_blkcipher *tfm;
-	struct s390_aes_ctx *sctx = crypto_blkcipher_ctx(desc->tfm);
+	struct crypto_blkcipher *tfm = desc->tfm;
+	struct s390_aes_ctx *sctx = crypto_blkcipher_ctx(tfm);
+	SKCIPHER_REQUEST_ON_STACK(req, sctx->fallback.blk);
 
-	tfm = desc->tfm;
-	desc->tfm = sctx->fallback.blk;
+	skcipher_request_set_tfm(req, sctx->fallback.blk);
+	skcipher_request_set_callback(req, desc->flags, NULL, NULL);
+	skcipher_request_set_crypt(req, src, dst, nbytes, desc->info);
 
-	ret = crypto_blkcipher_decrypt_iv(desc, dst, src, nbytes);
+	ret = crypto_skcipher_decrypt(req);
 
-	desc->tfm = tfm;
+	skcipher_request_zero(req);
 	return ret;
 }
 
@@ -272,15 +275,15 @@ static int fallback_blk_enc(struct blkcipher_desc *desc,
 		unsigned int nbytes)
 {
 	unsigned int ret;
-	struct crypto_blkcipher *tfm;
-	struct s390_aes_ctx *sctx = crypto_blkcipher_ctx(desc->tfm);
+	struct crypto_blkcipher *tfm = desc->tfm;
+	struct s390_aes_ctx *sctx = crypto_blkcipher_ctx(tfm);
+	SKCIPHER_REQUEST_ON_STACK(req, sctx->fallback.blk);
 
-	tfm = desc->tfm;
-	desc->tfm = sctx->fallback.blk;
+	skcipher_request_set_tfm(req, sctx->fallback.blk);
+	skcipher_request_set_callback(req, desc->flags, NULL, NULL);
+	skcipher_request_set_crypt(req, src, dst, nbytes, desc->info);
 
-	ret = crypto_blkcipher_encrypt_iv(desc, dst, src, nbytes);
-
-	desc->tfm = tfm;
+	ret = crypto_skcipher_encrypt(req);
 	return ret;
 }
 
@@ -370,8 +373,9 @@ static int fallback_init_blk(struct crypto_tfm *tfm)
 	const char *name = tfm->__crt_alg->cra_name;
 	struct s390_aes_ctx *sctx = crypto_tfm_ctx(tfm);
 
-	sctx->fallback.blk = crypto_alloc_blkcipher(name, 0,
-			CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK);
+	sctx->fallback.blk = crypto_alloc_skcipher(name, 0,
+						   CRYPTO_ALG_ASYNC |
+						   CRYPTO_ALG_NEED_FALLBACK);
 
 	if (IS_ERR(sctx->fallback.blk)) {
 		pr_err("Allocating AES fallback algorithm %s failed\n",
@@ -386,8 +390,7 @@ static void fallback_exit_blk(struct crypto_tfm *tfm)
 {
 	struct s390_aes_ctx *sctx = crypto_tfm_ctx(tfm);
 
-	crypto_free_blkcipher(sctx->fallback.blk);
-	sctx->fallback.blk = NULL;
+	crypto_free_skcipher(sctx->fallback.blk);
 }
 
 static struct crypto_alg ecb_aes_alg = {
@@ -536,16 +539,16 @@ static int xts_fallback_setkey(struct crypto_tfm *tfm, const u8 *key,
 	struct s390_xts_ctx *xts_ctx = crypto_tfm_ctx(tfm);
 	unsigned int ret;
 
-	xts_ctx->fallback->base.crt_flags &= ~CRYPTO_TFM_REQ_MASK;
-	xts_ctx->fallback->base.crt_flags |= (tfm->crt_flags &
-			CRYPTO_TFM_REQ_MASK);
+	crypto_skcipher_clear_flags(xts_ctx->fallback, CRYPTO_TFM_REQ_MASK);
+	crypto_skcipher_set_flags(xts_ctx->fallback, tfm->crt_flags &
+						     CRYPTO_TFM_REQ_MASK);
+
+	ret = crypto_skcipher_setkey(xts_ctx->fallback, key, len);
+
+	tfm->crt_flags &= ~CRYPTO_TFM_RES_MASK;
+	tfm->crt_flags |= crypto_skcipher_get_flags(xts_ctx->fallback) &
+			  CRYPTO_TFM_RES_MASK;
 
-	ret = crypto_blkcipher_setkey(xts_ctx->fallback, key, len);
-	if (ret) {
-		tfm->crt_flags &= ~CRYPTO_TFM_RES_MASK;
-		tfm->crt_flags |= (xts_ctx->fallback->base.crt_flags &
-				CRYPTO_TFM_RES_MASK);
-	}
 	return ret;
 }
 
@@ -553,16 +556,18 @@ static int xts_fallback_decrypt(struct blkcipher_desc *desc,
 		struct scatterlist *dst, struct scatterlist *src,
 		unsigned int nbytes)
 {
-	struct s390_xts_ctx *xts_ctx = crypto_blkcipher_ctx(desc->tfm);
-	struct crypto_blkcipher *tfm;
+	struct crypto_blkcipher *tfm = desc->tfm;
+	struct s390_xts_ctx *xts_ctx = crypto_blkcipher_ctx(tfm);
+	SKCIPHER_REQUEST_ON_STACK(req, xts_ctx->fallback);
 	unsigned int ret;
 
-	tfm = desc->tfm;
-	desc->tfm = xts_ctx->fallback;
+	skcipher_request_set_tfm(req, xts_ctx->fallback);
+	skcipher_request_set_callback(req, desc->flags, NULL, NULL);
+	skcipher_request_set_crypt(req, src, dst, nbytes, desc->info);
 
-	ret = crypto_blkcipher_decrypt_iv(desc, dst, src, nbytes);
+	ret = crypto_skcipher_decrypt(req);
 
-	desc->tfm = tfm;
+	skcipher_request_zero(req);
 	return ret;
 }
 
@@ -570,16 +575,18 @@ static int xts_fallback_encrypt(struct blkcipher_desc *desc,
 		struct scatterlist *dst, struct scatterlist *src,
 		unsigned int nbytes)
 {
-	struct s390_xts_ctx *xts_ctx = crypto_blkcipher_ctx(desc->tfm);
-	struct crypto_blkcipher *tfm;
+	struct crypto_blkcipher *tfm = desc->tfm;
+	struct s390_xts_ctx *xts_ctx = crypto_blkcipher_ctx(tfm);
+	SKCIPHER_REQUEST_ON_STACK(req, xts_ctx->fallback);
 	unsigned int ret;
 
-	tfm = desc->tfm;
-	desc->tfm = xts_ctx->fallback;
+	skcipher_request_set_tfm(req, xts_ctx->fallback);
+	skcipher_request_set_callback(req, desc->flags, NULL, NULL);
+	skcipher_request_set_crypt(req, src, dst, nbytes, desc->info);
 
-	ret = crypto_blkcipher_encrypt_iv(desc, dst, src, nbytes);
+	ret = crypto_skcipher_encrypt(req);
 
-	desc->tfm = tfm;
+	skcipher_request_zero(req);
 	return ret;
 }
 
@@ -700,8 +707,9 @@ static int xts_fallback_init(struct crypto_tfm *tfm)
 	const char *name = tfm->__crt_alg->cra_name;
 	struct s390_xts_ctx *xts_ctx = crypto_tfm_ctx(tfm);
 
-	xts_ctx->fallback = crypto_alloc_blkcipher(name, 0,
-			CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK);
+	xts_ctx->fallback = crypto_alloc_skcipher(name, 0,
+						  CRYPTO_ALG_ASYNC |
+						  CRYPTO_ALG_NEED_FALLBACK);
 
 	if (IS_ERR(xts_ctx->fallback)) {
 		pr_err("Allocating XTS fallback algorithm %s failed\n",
@@ -715,8 +723,7 @@ static void xts_fallback_exit(struct crypto_tfm *tfm)
 {
 	struct s390_xts_ctx *xts_ctx = crypto_tfm_ctx(tfm);
 
-	crypto_free_blkcipher(xts_ctx->fallback);
-	xts_ctx->fallback = NULL;
+	crypto_free_skcipher(xts_ctx->fallback);
 }
 
 static struct crypto_alg xts_aes_alg = {
