From: Tero Kristo <t-kristo@ti.com>
Subject: [PATCHv3 09/11] crypto: omap-aes: Add fallback support
Date: Thu, 4 Aug 2016 13:28:44 +0300
Message-ID: <1470306526-27219-10-git-send-email-t-kristo@ti.com>
References: <1470306526-27219-1-git-send-email-t-kristo@ti.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-arm-kernel@lists.infradead.org>
To: <herbert@gondor.apana.org.au>, <lokeshvutla@ti.com>,
	<davem@davemloft.net>, <linux-crypto@vger.kernel.org>,
	<tony@atomide.com>, <linux-omap@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([198.47.19.11]:55224 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755382AbcHDKaV (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 4 Aug 2016 06:30:21 -0400
In-Reply-To: <1470306526-27219-1-git-send-email-t-kristo@ti.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Lokesh Vutla <lokeshvutla@ti.com>

As setting up the DMA operations is quite costly, add software fallback
support for requests smaller than 200 bytes. This change gives some 10%
extra performance in ipsec use case.

Signed-off-by: Lokesh Vutla <lokeshvutla@ti.com>
[t-kristo@ti.com: udpated against latest upstream, to use skcipher mainly]
Signed-off-by: Tero Kristo <t-kristo@ti.com>
---
 drivers/crypto/Kconfig    |  3 +++
 drivers/crypto/omap-aes.c | 53 +++++++++++++++++++++++++++++++++++++++++++----
 2 files changed, 52 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 1af94e2..19ee6ee 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -318,6 +318,9 @@ config CRYPTO_DEV_OMAP_AES
 	select CRYPTO_AES
 	select CRYPTO_BLKCIPHER
 	select CRYPTO_ENGINE
+	select CRYPTO_CBC
+	select CRYPTO_ECB
+	select CRYPTO_CTR
 	help
 	  OMAP processors have AES module accelerator. Select this if you
 	  want to use the OMAP module for AES algorithms.
diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
index 3cf7b8f..6ba4f70 100644
--- a/drivers/crypto/omap-aes.c
+++ b/drivers/crypto/omap-aes.c
@@ -35,7 +35,7 @@
 #include <linux/interrupt.h>
 #include <crypto/scatterwalk.h>
 #include <crypto/aes.h>
-#include <crypto/algapi.h>
+#include <crypto/internal/skcipher.h>
 
 #define DST_MAXBURST			4
 #define DMA_MIN				(DST_MAXBURST * sizeof(u32))
@@ -105,6 +105,7 @@ struct omap_aes_ctx {
 	int		keylen;
 	u32		key[AES_KEYSIZE_256 / sizeof(u32)];
 	unsigned long	flags;
+	struct crypto_skcipher	*fallback;
 };
 
 struct omap_aes_reqctx {
@@ -701,11 +702,29 @@ static int omap_aes_crypt(struct ablkcipher_request *req, unsigned long mode)
 			crypto_ablkcipher_reqtfm(req));
 	struct omap_aes_reqctx *rctx = ablkcipher_request_ctx(req);
 	struct omap_aes_dev *dd;
+	int ret;
 
 	pr_debug("nbytes: %d, enc: %d, cbc: %d\n", req->nbytes,
 		  !!(mode & FLAGS_ENCRYPT),
 		  !!(mode & FLAGS_CBC));
 
+	if (req->nbytes < 200) {
+		SKCIPHER_REQUEST_ON_STACK(subreq, ctx->fallback);
+
+		skcipher_request_set_tfm(subreq, ctx->fallback);
+		skcipher_request_set_callback(subreq, req->base.flags, NULL,
+					      NULL);
+		skcipher_request_set_crypt(subreq, req->src, req->dst,
+					   req->nbytes, req->info);
+
+		if (mode & FLAGS_ENCRYPT)
+			ret = crypto_skcipher_encrypt(subreq);
+		else
+			ret = crypto_skcipher_decrypt(subreq);
+
+		skcipher_request_zero(subreq);
+		return ret;
+	}
 	dd = omap_aes_find_dev(ctx);
 	if (!dd)
 		return -ENODEV;
@@ -721,6 +740,7 @@ static int omap_aes_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
 			   unsigned int keylen)
 {
 	struct omap_aes_ctx *ctx = crypto_ablkcipher_ctx(tfm);
+	int ret;
 
 	if (keylen != AES_KEYSIZE_128 && keylen != AES_KEYSIZE_192 &&
 		   keylen != AES_KEYSIZE_256)
@@ -731,6 +751,14 @@ static int omap_aes_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
 	memcpy(ctx->key, key, keylen);
 	ctx->keylen = keylen;
 
+	crypto_skcipher_clear_flags(ctx->fallback, CRYPTO_TFM_REQ_MASK);
+	crypto_skcipher_set_flags(ctx->fallback, tfm->base.crt_flags &
+						 CRYPTO_TFM_REQ_MASK);
+
+	ret = crypto_skcipher_setkey(ctx->fallback, key, keylen);
+	if (!ret)
+		return 0;
+
 	return 0;
 }
 
@@ -766,6 +794,17 @@ static int omap_aes_ctr_decrypt(struct ablkcipher_request *req)
 
 static int omap_aes_cra_init(struct crypto_tfm *tfm)
 {
+	const char *name = crypto_tfm_alg_name(tfm);
+	const u32 flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK;
+	struct omap_aes_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct crypto_skcipher *blk;
+
+	blk = crypto_alloc_skcipher(name, 0, flags);
+	if (IS_ERR(blk))
+		return PTR_ERR(blk);
+
+	ctx->fallback = blk;
+
 	tfm->crt_ablkcipher.reqsize = sizeof(struct omap_aes_reqctx);
 
 	return 0;
@@ -773,6 +812,12 @@ static int omap_aes_cra_init(struct crypto_tfm *tfm)
 
 static void omap_aes_cra_exit(struct crypto_tfm *tfm)
 {
+	struct omap_aes_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	if (ctx->fallback)
+		crypto_free_skcipher(ctx->fallback);
+
+	ctx->fallback = NULL;
 }
 
 /* ********************** ALGS ************************************ */
@@ -784,7 +829,7 @@ static struct crypto_alg algs_ecb_cbc[] = {
 	.cra_priority		= 300,
 	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER |
 				  CRYPTO_ALG_KERN_DRIVER_ONLY |
-				  CRYPTO_ALG_ASYNC,
+				  CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK,
 	.cra_blocksize		= AES_BLOCK_SIZE,
 	.cra_ctxsize		= sizeof(struct omap_aes_ctx),
 	.cra_alignmask		= 0,
@@ -806,7 +851,7 @@ static struct crypto_alg algs_ecb_cbc[] = {
 	.cra_priority		= 300,
 	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER |
 				  CRYPTO_ALG_KERN_DRIVER_ONLY |
-				  CRYPTO_ALG_ASYNC,
+				  CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK,
 	.cra_blocksize		= AES_BLOCK_SIZE,
 	.cra_ctxsize		= sizeof(struct omap_aes_ctx),
 	.cra_alignmask		= 0,
@@ -832,7 +877,7 @@ static struct crypto_alg algs_ctr[] = {
 	.cra_priority		= 300,
 	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER |
 				  CRYPTO_ALG_KERN_DRIVER_ONLY |
-				  CRYPTO_ALG_ASYNC,
+				  CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK,
 	.cra_blocksize		= AES_BLOCK_SIZE,
 	.cra_ctxsize		= sizeof(struct omap_aes_ctx),
 	.cra_alignmask		= 0,
-- 
1.9.1
