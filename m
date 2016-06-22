From: Tero Kristo <t-kristo@ti.com>
Subject: [PATCHv2 11/27] crypto: omap-aes: Add fallback support
Date: Wed, 22 Jun 2016 16:23:44 +0300
Message-ID: <1466601840-18486-12-git-send-email-t-kristo@ti.com>
References: <1466601840-18486-1-git-send-email-t-kristo@ti.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-arm-kernel@lists.infradead.org>
To: <linux-omap@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<tony@atomide.com>, <herbert@gondor.apana.org.au>,
	<davem@davemloft.net>, <lokeshvutla@ti.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([198.47.19.11]:36763 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752311AbcFVNZW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 22 Jun 2016 09:25:22 -0400
In-Reply-To: <1466601840-18486-1-git-send-email-t-kristo@ti.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Lokesh Vutla <lokeshvutla@ti.com>

As setting up the DMA operations is quite costly, add software fallback
support for requests smaller than 200 bytes. This change gives some 10%
extra performance in ipsec use case.

Signed-off-by: Lokesh Vutla <lokeshvutla@ti.com>
Signed-off-by: Tero Kristo <t-kristo@ti.com>
---
 drivers/crypto/Kconfig    |  3 +++
 drivers/crypto/omap-aes.c | 45 ++++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 45 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index d77ba2f..0c57ac9 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -305,6 +305,9 @@ config CRYPTO_DEV_OMAP_AES
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
index f710602..867e56a 100644
--- a/drivers/crypto/omap-aes.c
+++ b/drivers/crypto/omap-aes.c
@@ -103,6 +103,7 @@ struct omap_aes_ctx {
 	int		keylen;
 	u32		key[AES_KEYSIZE_256 / sizeof(u32)];
 	unsigned long	flags;
+	struct crypto_ablkcipher	*fallback;
 };
 
 struct omap_aes_reqctx {
@@ -680,15 +681,28 @@ static void omap_aes_done_task(unsigned long data)
 
 static int omap_aes_crypt(struct ablkcipher_request *req, unsigned long mode)
 {
+	struct crypto_tfm *tfm =
+		crypto_ablkcipher_tfm(crypto_ablkcipher_reqtfm(req));
 	struct omap_aes_ctx *ctx = crypto_ablkcipher_ctx(
 			crypto_ablkcipher_reqtfm(req));
 	struct omap_aes_reqctx *rctx = ablkcipher_request_ctx(req);
 	struct omap_aes_dev *dd;
+	int ret;
 
 	pr_debug("nbytes: %d, enc: %d, cbc: %d\n", req->nbytes,
 		  !!(mode & FLAGS_ENCRYPT),
 		  !!(mode & FLAGS_CBC));
 
+	if (req->nbytes < 200) {
+		ablkcipher_request_set_tfm(req, ctx->fallback);
+
+		if (mode & FLAGS_ENCRYPT)
+			ret = crypto_ablkcipher_encrypt(req);
+		else
+			ret = crypto_ablkcipher_decrypt(req);
+		ablkcipher_request_set_tfm(req, __crypto_ablkcipher_cast(tfm));
+		return ret;
+	}
 	dd = omap_aes_find_dev(ctx);
 	if (!dd)
 		return -ENODEV;
@@ -704,6 +718,7 @@ static int omap_aes_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
 			   unsigned int keylen)
 {
 	struct omap_aes_ctx *ctx = crypto_ablkcipher_ctx(tfm);
+	int ret;
 
 	if (keylen != AES_KEYSIZE_128 && keylen != AES_KEYSIZE_192 &&
 		   keylen != AES_KEYSIZE_256)
@@ -714,6 +729,14 @@ static int omap_aes_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
 	memcpy(ctx->key, key, keylen);
 	ctx->keylen = keylen;
 
+	ctx->fallback->base.crt_flags &= ~CRYPTO_TFM_REQ_MASK;
+	ctx->fallback->base.crt_flags |=
+		tfm->base.crt_flags & CRYPTO_TFM_REQ_MASK;
+
+	ret = crypto_ablkcipher_setkey(ctx->fallback, key, keylen);
+	if (!ret)
+		return 0;
+
 	return 0;
 }
 
@@ -751,6 +774,11 @@ static int omap_aes_cra_init(struct crypto_tfm *tfm)
 {
 	struct omap_aes_dev *dd = NULL;
 	int err;
+	const char *name = crypto_tfm_alg_name(tfm);
+	const u32 flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK;
+	struct omap_aes_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct crypto_ablkcipher *blk;
+
 
 	list_for_each_entry(dd, &dev_list, list) {
 		err = pm_runtime_get_sync(dd->dev);
@@ -761,6 +789,12 @@ static int omap_aes_cra_init(struct crypto_tfm *tfm)
 		}
 	}
 
+	blk = crypto_alloc_ablkcipher(name, 0, flags);
+	if (IS_ERR(blk))
+		return PTR_ERR(blk);
+
+	ctx->fallback = blk;
+
 	tfm->crt_ablkcipher.reqsize = sizeof(struct omap_aes_reqctx);
 
 	return 0;
@@ -769,11 +803,16 @@ static int omap_aes_cra_init(struct crypto_tfm *tfm)
 static void omap_aes_cra_exit(struct crypto_tfm *tfm)
 {
 	struct omap_aes_dev *dd = NULL;
+	struct omap_aes_ctx *ctx = crypto_tfm_ctx(tfm);
 
 	list_for_each_entry(dd, &dev_list, list) {
 		pm_runtime_put_sync(dd->dev);
 	}
 
+	if (ctx->fallback)
+		crypto_free_ablkcipher(ctx->fallback);
+
+	ctx->fallback = NULL;
 }
 
 /* ********************** ALGS ************************************ */
@@ -785,7 +824,7 @@ static struct crypto_alg algs_ecb_cbc[] = {
 	.cra_priority		= 300,
 	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER |
 				  CRYPTO_ALG_KERN_DRIVER_ONLY |
-				  CRYPTO_ALG_ASYNC,
+				  CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK,
 	.cra_blocksize		= AES_BLOCK_SIZE,
 	.cra_ctxsize		= sizeof(struct omap_aes_ctx),
 	.cra_alignmask		= 0,
@@ -807,7 +846,7 @@ static struct crypto_alg algs_ecb_cbc[] = {
 	.cra_priority		= 300,
 	.cra_flags		= CRYPTO_ALG_TYPE_ABLKCIPHER |
 				  CRYPTO_ALG_KERN_DRIVER_ONLY |
-				  CRYPTO_ALG_ASYNC,
+				  CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK,
 	.cra_blocksize		= AES_BLOCK_SIZE,
 	.cra_ctxsize		= sizeof(struct omap_aes_ctx),
 	.cra_alignmask		= 0,
@@ -833,7 +872,7 @@ static struct crypto_alg algs_ctr[] = {
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
