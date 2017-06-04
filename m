From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH v3 17/18] staging: ccree: remove last remnants of sblkcipher
Date: Sun,  4 Jun 2017 11:02:38 +0300
Message-ID: <1496563362-7954-18-git-send-email-gilad@benyossef.com>
References: <1496563362-7954-1-git-send-email-gilad@benyossef.com>
Cc: Joe Perches <joe@perches.com>, Ofir Drang <ofir.drang@arm.com>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from foss.arm.com ([217.140.101.70]:52856 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751322AbdFDIE0 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 4 Jun 2017 04:04:26 -0400
In-Reply-To: <1496563362-7954-1-git-send-email-gilad@benyossef.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The cipher code had some left overs of an attempt to support
synch. cipher API with the HW. Remove the code handling this.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_cipher.c | 102 +++----------------------------------
 drivers/staging/ccree/ssi_driver.h |   1 -
 2 files changed, 6 insertions(+), 97 deletions(-)

diff --git a/drivers/staging/ccree/ssi_cipher.c b/drivers/staging/ccree/ssi_cipher.c
index e16fd36..2dfc6a3 100644
--- a/drivers/staging/ccree/ssi_cipher.c
+++ b/drivers/staging/ccree/ssi_cipher.c
@@ -36,7 +36,6 @@
 #define MAX_ABLKCIPHER_SEQ_LEN 6
 
 #define template_ablkcipher	template_u.ablkcipher
-#define template_sblkcipher	template_u.blkcipher
 
 #define SSI_MIN_AES_XTS_SIZE 0x10
 #define SSI_MAX_AES_XTS_SIZE 0x2000
@@ -886,69 +885,6 @@ static void ssi_ablkcipher_complete(struct device *dev, void *ssi_req, void __io
 			       ivsize, areq, cc_base);
 }
 
-
-
-static int ssi_sblkcipher_init(struct crypto_tfm *tfm)
-{
-	struct ssi_ablkcipher_ctx *ctx_p = crypto_tfm_ctx(tfm);
-
-	/* Allocate sync ctx buffer */
-	ctx_p->sync_ctx = kmalloc(sizeof(struct blkcipher_req_ctx), GFP_KERNEL|GFP_DMA);
-	if (!ctx_p->sync_ctx) {
-		SSI_LOG_ERR("Allocating sync ctx buffer in context failed\n");
-		return -ENOMEM;
-	}
-	SSI_LOG_DEBUG("Allocated sync ctx buffer in context ctx_p->sync_ctx=@%p\n",
-								ctx_p->sync_ctx);
-
-	return ssi_blkcipher_init(tfm);
-}
-
-
-static void ssi_sblkcipher_exit(struct crypto_tfm *tfm)
-{
-	struct ssi_ablkcipher_ctx *ctx_p = crypto_tfm_ctx(tfm);
-
-	kfree(ctx_p->sync_ctx);
-	SSI_LOG_DEBUG("Free sync ctx buffer in context ctx_p->sync_ctx=@%p\n", ctx_p->sync_ctx);
-
-	ssi_blkcipher_exit(tfm);
-}
-
-#ifdef SYNC_ALGS
-static int ssi_sblkcipher_encrypt(struct blkcipher_desc *desc,
-                        struct scatterlist *dst, struct scatterlist *src,
-                        unsigned int nbytes)
-{
-	struct crypto_blkcipher *blk_tfm = desc->tfm;
-	struct crypto_tfm *tfm = crypto_blkcipher_tfm(blk_tfm);
-	struct ssi_ablkcipher_ctx *ctx_p = crypto_tfm_ctx(tfm);
-	struct blkcipher_req_ctx *req_ctx = ctx_p->sync_ctx;
-	unsigned int ivsize = crypto_blkcipher_ivsize(blk_tfm);
-
-	req_ctx->backup_info = desc->info;
-	req_ctx->is_giv = false;
-
-	return ssi_blkcipher_process(tfm, req_ctx, dst, src, nbytes, desc->info, ivsize, NULL, DRV_CRYPTO_DIRECTION_ENCRYPT);
-}
-
-static int ssi_sblkcipher_decrypt(struct blkcipher_desc *desc,
-                        struct scatterlist *dst, struct scatterlist *src,
-                        unsigned int nbytes)
-{
-	struct crypto_blkcipher *blk_tfm = desc->tfm;
-	struct crypto_tfm *tfm = crypto_blkcipher_tfm(blk_tfm);
-	struct ssi_ablkcipher_ctx *ctx_p = crypto_tfm_ctx(tfm);
-	struct blkcipher_req_ctx *req_ctx = ctx_p->sync_ctx;
-	unsigned int ivsize = crypto_blkcipher_ivsize(blk_tfm);
-
-	req_ctx->backup_info = desc->info;
-	req_ctx->is_giv = false;
-
-	return ssi_blkcipher_process(tfm, req_ctx, dst, src, nbytes, desc->info, ivsize, NULL, DRV_CRYPTO_DIRECTION_DECRYPT);
-}
-#endif
-
 /* Async wrap functions */
 
 static int ssi_ablkcipher_init(struct crypto_tfm *tfm)
@@ -1014,7 +950,6 @@ static struct ssi_alg_template blkcipher_algs[] = {
 			},
 		.cipher_mode = DRV_CIPHER_XTS,
 		.flow_mode = S_DIN_to_AES,
-        .synchronous = false,
 	},
 	{
 		.name = "xts(aes)",
@@ -1031,7 +966,6 @@ static struct ssi_alg_template blkcipher_algs[] = {
 			},
 		.cipher_mode = DRV_CIPHER_XTS,
 		.flow_mode = S_DIN_to_AES,
-	.synchronous = false,
 	},
 	{
 		.name = "xts(aes)",
@@ -1048,7 +982,6 @@ static struct ssi_alg_template blkcipher_algs[] = {
 			},
 		.cipher_mode = DRV_CIPHER_XTS,
 		.flow_mode = S_DIN_to_AES,
-	.synchronous = false,
 	},
 #endif /*SSI_CC_HAS_AES_XTS*/
 #if SSI_CC_HAS_AES_ESSIV
@@ -1067,7 +1000,6 @@ static struct ssi_alg_template blkcipher_algs[] = {
 			},
 		.cipher_mode = DRV_CIPHER_ESSIV,
 		.flow_mode = S_DIN_to_AES,
-		.synchronous = false,
 	},
 	{
 		.name = "essiv(aes)",
@@ -1084,7 +1016,6 @@ static struct ssi_alg_template blkcipher_algs[] = {
 			},
 		.cipher_mode = DRV_CIPHER_ESSIV,
 		.flow_mode = S_DIN_to_AES,
-		.synchronous = false,
 	},
 	{
 		.name = "essiv(aes)",
@@ -1101,7 +1032,6 @@ static struct ssi_alg_template blkcipher_algs[] = {
 			},
 		.cipher_mode = DRV_CIPHER_ESSIV,
 		.flow_mode = S_DIN_to_AES,
-		.synchronous = false,
 	},
 #endif /*SSI_CC_HAS_AES_ESSIV*/
 #if SSI_CC_HAS_AES_BITLOCKER
@@ -1120,7 +1050,6 @@ static struct ssi_alg_template blkcipher_algs[] = {
 			},
 		.cipher_mode = DRV_CIPHER_BITLOCKER,
 		.flow_mode = S_DIN_to_AES,
-		.synchronous = false,
 	},
 	{
 		.name = "bitlocker(aes)",
@@ -1137,7 +1066,6 @@ static struct ssi_alg_template blkcipher_algs[] = {
 			},
 		.cipher_mode = DRV_CIPHER_BITLOCKER,
 		.flow_mode = S_DIN_to_AES,
-		.synchronous = false,
 	},
 	{
 		.name = "bitlocker(aes)",
@@ -1154,7 +1082,6 @@ static struct ssi_alg_template blkcipher_algs[] = {
 			},
 		.cipher_mode = DRV_CIPHER_BITLOCKER,
 		.flow_mode = S_DIN_to_AES,
-		.synchronous = false,
 	},
 #endif /*SSI_CC_HAS_AES_BITLOCKER*/
 	{
@@ -1172,7 +1099,6 @@ static struct ssi_alg_template blkcipher_algs[] = {
 			},
 		.cipher_mode = DRV_CIPHER_ECB,
 		.flow_mode = S_DIN_to_AES,
-        .synchronous = false,
 	},
 	{
 		.name = "cbc(aes)",
@@ -1186,10 +1112,9 @@ static struct ssi_alg_template blkcipher_algs[] = {
 			.min_keysize = AES_MIN_KEY_SIZE,
 			.max_keysize = AES_MAX_KEY_SIZE,
 			.ivsize = AES_BLOCK_SIZE,
-			},
+		},
 		.cipher_mode = DRV_CIPHER_CBC,
 		.flow_mode = S_DIN_to_AES,
-        .synchronous = false,
 	},
 	{
 		.name = "ofb(aes)",
@@ -1206,7 +1131,6 @@ static struct ssi_alg_template blkcipher_algs[] = {
 			},
 		.cipher_mode = DRV_CIPHER_OFB,
 		.flow_mode = S_DIN_to_AES,
-        .synchronous = false,
 	},
 #if SSI_CC_HAS_AES_CTS
 	{
@@ -1224,7 +1148,6 @@ static struct ssi_alg_template blkcipher_algs[] = {
 			},
 		.cipher_mode = DRV_CIPHER_CBC_CTS,
 		.flow_mode = S_DIN_to_AES,
-        .synchronous = false,
 	},
 #endif
 	{
@@ -1242,7 +1165,6 @@ static struct ssi_alg_template blkcipher_algs[] = {
 			},
 		.cipher_mode = DRV_CIPHER_CTR,
 		.flow_mode = S_DIN_to_AES,
-        .synchronous = false,
 	},
 	{
 		.name = "cbc(des3_ede)",
@@ -1259,7 +1181,6 @@ static struct ssi_alg_template blkcipher_algs[] = {
 			},
 		.cipher_mode = DRV_CIPHER_CBC,
 		.flow_mode = S_DIN_to_DES,
-        .synchronous = false,
 	},
 	{
 		.name = "ecb(des3_ede)",
@@ -1276,7 +1197,6 @@ static struct ssi_alg_template blkcipher_algs[] = {
 			},
 		.cipher_mode = DRV_CIPHER_ECB,
 		.flow_mode = S_DIN_to_DES,
-        .synchronous = false,
 	},
 	{
 		.name = "cbc(des)",
@@ -1293,7 +1213,6 @@ static struct ssi_alg_template blkcipher_algs[] = {
 			},
 		.cipher_mode = DRV_CIPHER_CBC,
 		.flow_mode = S_DIN_to_DES,
-        .synchronous = false,
 	},
 	{
 		.name = "ecb(des)",
@@ -1310,7 +1229,6 @@ static struct ssi_alg_template blkcipher_algs[] = {
 			},
 		.cipher_mode = DRV_CIPHER_ECB,
 		.flow_mode = S_DIN_to_DES,
-        .synchronous = false,
 	},
 #if SSI_CC_HAS_MULTI2
 	{
@@ -1328,7 +1246,6 @@ static struct ssi_alg_template blkcipher_algs[] = {
 			},
 		.cipher_mode = DRV_MULTI2_CBC,
 		.flow_mode = S_DIN_to_MULTI2,
-        .synchronous = false,
 	},
 	{
 		.name = "ofb(multi2)",
@@ -1345,7 +1262,6 @@ static struct ssi_alg_template blkcipher_algs[] = {
 			},
 		.cipher_mode = DRV_MULTI2_OFB,
 		.flow_mode = S_DIN_to_MULTI2,
-        .synchronous = false,
 	},
 #endif /*SSI_CC_HAS_MULTI2*/
 };
@@ -1373,18 +1289,12 @@ struct ssi_crypto_alg *ssi_ablkcipher_create_alg(struct ssi_alg_template *templa
 	alg->cra_alignmask = 0;
 	alg->cra_ctxsize = sizeof(struct ssi_ablkcipher_ctx);
 
-	alg->cra_init = template->synchronous? ssi_sblkcipher_init:ssi_ablkcipher_init;
-	alg->cra_exit = template->synchronous? ssi_sblkcipher_exit:ssi_blkcipher_exit;
-	alg->cra_type = template->synchronous? &crypto_blkcipher_type:&crypto_ablkcipher_type;
-	if(template->synchronous) {
-		alg->cra_blkcipher = template->template_sblkcipher;
-		alg->cra_flags = CRYPTO_ALG_KERN_DRIVER_ONLY |
-				template->type;
-	} else {
-		alg->cra_ablkcipher = template->template_ablkcipher;
-		alg->cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_KERN_DRIVER_ONLY |
+	alg->cra_init = ssi_ablkcipher_init;
+	alg->cra_exit = ssi_blkcipher_exit;
+	alg->cra_type = &crypto_ablkcipher_type;
+	alg->cra_ablkcipher = template->template_ablkcipher;
+	alg->cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_KERN_DRIVER_ONLY |
 				template->type;
-	}
 
 	t_alg->cipher_mode = template->cipher_mode;
 	t_alg->flow_mode = template->flow_mode;
diff --git a/drivers/staging/ccree/ssi_driver.h b/drivers/staging/ccree/ssi_driver.h
index 4c6eef9..34bd7ef 100644
--- a/drivers/staging/ccree/ssi_driver.h
+++ b/drivers/staging/ccree/ssi_driver.h
@@ -176,7 +176,6 @@ struct ssi_alg_template {
 	int cipher_mode;
 	int flow_mode; /* Note: currently, refers to the cipher mode only. */
 	int auth_mode;
-	bool synchronous;
 	struct ssi_drvdata *drvdata;
 };
 
-- 
2.1.4
