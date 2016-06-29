From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 16/28] crypto: mxs-dcp - Use skcipher for fallback
Date: Wed, 29 Jun 2016 18:04:02 +0800
Message-ID: <E1bICLi-0006v3-Kz@gondolin.me.apana.org.au>
References: <20160629100223.GA26260@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:33964 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482AbcF2KEF (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 29 Jun 2016 06:04:05 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1bICLi-0005K2-Os
	for <linux-crypto@vger.kernel.org>; Wed, 29 Jun 2016 20:04:02 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch replaces use of the obsolete ablkcipher with skcipher.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/crypto/mxs-dcp.c |   47 +++++++++++++++++++++--------------------------
 1 file changed, 21 insertions(+), 26 deletions(-)

diff --git a/drivers/crypto/mxs-dcp.c b/drivers/crypto/mxs-dcp.c
index 59ed54e..625ee50 100644
--- a/drivers/crypto/mxs-dcp.c
+++ b/drivers/crypto/mxs-dcp.c
@@ -11,7 +11,6 @@
  * http://www.gnu.org/copyleft/gpl.html
  */
 
-#include <linux/crypto.h>
 #include <linux/dma-mapping.h>
 #include <linux/interrupt.h>
 #include <linux/io.h>
@@ -25,6 +24,7 @@
 #include <crypto/aes.h>
 #include <crypto/sha.h>
 #include <crypto/internal/hash.h>
+#include <crypto/internal/skcipher.h>
 
 #define DCP_MAX_CHANS	4
 #define DCP_BUF_SZ	PAGE_SIZE
@@ -84,7 +84,7 @@ struct dcp_async_ctx {
 	unsigned int			hot:1;
 
 	/* Crypto-specific context */
-	struct crypto_ablkcipher	*fallback;
+	struct crypto_skcipher		*fallback;
 	unsigned int			key_len;
 	uint8_t				key[AES_KEYSIZE_128];
 };
@@ -374,20 +374,22 @@ static int dcp_chan_thread_aes(void *data)
 
 static int mxs_dcp_block_fallback(struct ablkcipher_request *req, int enc)
 {
-	struct crypto_tfm *tfm =
-		crypto_ablkcipher_tfm(crypto_ablkcipher_reqtfm(req));
-	struct dcp_async_ctx *ctx = crypto_ablkcipher_ctx(
-		crypto_ablkcipher_reqtfm(req));
+	struct crypto_ablkcipher *tfm = crypto_ablkcipher_reqtfm(req);
+	struct dcp_async_ctx *ctx = crypto_ablkcipher_ctx(tfm);
+	SKCIPHER_REQUEST_ON_STACK(subreq, ctx->fallback);
 	int ret;
 
-	ablkcipher_request_set_tfm(req, ctx->fallback);
+	skcipher_request_set_tfm(subreq, ctx->fallback);
+	skcipher_request_set_callback(subreq, req->base.flags, NULL, NULL);
+	skcipher_request_set_crypt(subreq, req->src, req->dst,
+				   req->nbytes, req->info);
 
 	if (enc)
-		ret = crypto_ablkcipher_encrypt(req);
+		ret = crypto_skcipher_encrypt(subreq);
 	else
-		ret = crypto_ablkcipher_decrypt(req);
+		ret = crypto_skcipher_decrypt(subreq);
 
-	ablkcipher_request_set_tfm(req, __crypto_ablkcipher_cast(tfm));
+	skcipher_request_zero(subreq);
 
 	return ret;
 }
@@ -453,28 +455,22 @@ static int mxs_dcp_aes_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
 		return 0;
 	}
 
-	/* Check if the key size is supported by kernel at all. */
-	if (len != AES_KEYSIZE_192 && len != AES_KEYSIZE_256) {
-		tfm->base.crt_flags |= CRYPTO_TFM_RES_BAD_KEY_LEN;
-		return -EINVAL;
-	}
-
 	/*
 	 * If the requested AES key size is not supported by the hardware,
 	 * but is supported by in-kernel software implementation, we use
 	 * software fallback.
 	 */
-	actx->fallback->base.crt_flags &= ~CRYPTO_TFM_REQ_MASK;
-	actx->fallback->base.crt_flags |=
-		tfm->base.crt_flags & CRYPTO_TFM_REQ_MASK;
+	crypto_skcipher_clear_flags(actx->fallback, CRYPTO_TFM_REQ_MASK);
+	crypto_skcipher_set_flags(actx->fallback,
+				  tfm->base.crt_flags & CRYPTO_TFM_REQ_MASK);
 
-	ret = crypto_ablkcipher_setkey(actx->fallback, key, len);
+	ret = crypto_skcipher_setkey(actx->fallback, key, len);
 	if (!ret)
 		return 0;
 
 	tfm->base.crt_flags &= ~CRYPTO_TFM_RES_MASK;
-	tfm->base.crt_flags |=
-		actx->fallback->base.crt_flags & CRYPTO_TFM_RES_MASK;
+	tfm->base.crt_flags |= crypto_skcipher_get_flags(actx->fallback) &
+			       CRYPTO_TFM_RES_MASK;
 
 	return ret;
 }
@@ -484,9 +480,9 @@ static int mxs_dcp_aes_fallback_init(struct crypto_tfm *tfm)
 	const char *name = crypto_tfm_alg_name(tfm);
 	const uint32_t flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK;
 	struct dcp_async_ctx *actx = crypto_tfm_ctx(tfm);
-	struct crypto_ablkcipher *blk;
+	struct crypto_skcipher *blk;
 
-	blk = crypto_alloc_ablkcipher(name, 0, flags);
+	blk = crypto_alloc_skcipher(name, 0, flags);
 	if (IS_ERR(blk))
 		return PTR_ERR(blk);
 
@@ -499,8 +495,7 @@ static void mxs_dcp_aes_fallback_exit(struct crypto_tfm *tfm)
 {
 	struct dcp_async_ctx *actx = crypto_tfm_ctx(tfm);
 
-	crypto_free_ablkcipher(actx->fallback);
-	actx->fallback = NULL;
+	crypto_free_skcipher(actx->fallback);
 }
 
 /*
