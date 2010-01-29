From: Roel Kluin <roel.kluin@gmail.com>
Subject: [PATCH] geode: Fix cip/blk confusion
Date: Fri, 29 Jan 2010 14:32:56 +0100
Message-ID: <4B62E388.1070707@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Herbert Xu <herbert@gondor.apana.org.au>,
	Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	Andrew Morton <a
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:50357 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754793Ab0A2N1J (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 29 Jan 2010 08:27:09 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

crypto_cipher cip members were set where crypto_cipher blk members should
have been, also the PTR_ERR of the wrong pointer was returned.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
This was already discussed in december/januari but I still cannot find it in
mainline, was it lost?

diff --git a/arch/s390/crypto/aes_s390.c b/arch/s390/crypto/aes_s390.c
index 6be4503..58f4673 100644
--- a/arch/s390/crypto/aes_s390.c
+++ b/arch/s390/crypto/aes_s390.c
@@ -78,14 +78,14 @@ static int setkey_fallback_cip(struct crypto_tfm *tfm, const u8 *in_key,
 	struct s390_aes_ctx *sctx = crypto_tfm_ctx(tfm);
 	int ret;
 
-	sctx->fallback.blk->base.crt_flags &= ~CRYPTO_TFM_REQ_MASK;
-	sctx->fallback.blk->base.crt_flags |= (tfm->crt_flags &
+	sctx->fallback.cip->base.crt_flags &= ~CRYPTO_TFM_REQ_MASK;
+	sctx->fallback.cip->base.crt_flags |= (tfm->crt_flags &
 			CRYPTO_TFM_REQ_MASK);
 
 	ret = crypto_cipher_setkey(sctx->fallback.cip, in_key, key_len);
 	if (ret) {
 		tfm->crt_flags &= ~CRYPTO_TFM_RES_MASK;
-		tfm->crt_flags |= (sctx->fallback.blk->base.crt_flags &
+		tfm->crt_flags |= (sctx->fallback.cip->base.crt_flags &
 				CRYPTO_TFM_RES_MASK);
 	}
 	return ret;
diff --git a/drivers/crypto/geode-aes.c b/drivers/crypto/geode-aes.c
index 4801162..c7a5a43 100644
--- a/drivers/crypto/geode-aes.c
+++ b/drivers/crypto/geode-aes.c
@@ -135,13 +135,13 @@ static int geode_setkey_cip(struct crypto_tfm *tfm, const u8 *key,
 	/*
 	 * The requested key size is not supported by HW, do a fallback
 	 */
-	op->fallback.blk->base.crt_flags &= ~CRYPTO_TFM_REQ_MASK;
-	op->fallback.blk->base.crt_flags |= (tfm->crt_flags & CRYPTO_TFM_REQ_MASK);
+	op->fallback.cip->base.crt_flags &= ~CRYPTO_TFM_REQ_MASK;
+	op->fallback.cip->base.crt_flags |= (tfm->crt_flags & CRYPTO_TFM_REQ_MASK);
 
 	ret = crypto_cipher_setkey(op->fallback.cip, key, len);
 	if (ret) {
 		tfm->crt_flags &= ~CRYPTO_TFM_RES_MASK;
-		tfm->crt_flags |= (op->fallback.blk->base.crt_flags & CRYPTO_TFM_RES_MASK);
+		tfm->crt_flags |= (op->fallback.cip->base.crt_flags & CRYPTO_TFM_RES_MASK);
 	}
 	return ret;
 }
@@ -263,7 +263,7 @@ static int fallback_init_cip(struct crypto_tfm *tfm)
 
 	if (IS_ERR(op->fallback.cip)) {
 		printk(KERN_ERR "Error allocating fallback algo %s\n", name);
-		return PTR_ERR(op->fallback.blk);
+		return PTR_ERR(op->fallback.cip);
 	}
 
 	return 0;
