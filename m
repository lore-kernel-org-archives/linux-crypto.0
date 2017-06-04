From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH v3 16/18] staging: ccree: remove last remnants of sash algo
Date: Sun,  4 Jun 2017 11:02:37 +0300
Message-ID: <1496563362-7954-17-git-send-email-gilad@benyossef.com>
References: <1496563362-7954-1-git-send-email-gilad@benyossef.com>
Cc: Joe Perches <joe@perches.com>, Ofir Drang <ofir.drang@arm.com>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from foss.arm.com ([217.140.101.70]:52842 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751139AbdFDIEa (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 4 Jun 2017 04:04:30 -0400
In-Reply-To: <1496563362-7954-1-git-send-email-gilad@benyossef.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The hash code had some left overs from a misguided attempt
to support shash API with the HW. Remove the code handling
this.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_hash.c | 448 +++++++++++----------------------------
 1 file changed, 127 insertions(+), 321 deletions(-)

diff --git a/drivers/staging/ccree/ssi_hash.c b/drivers/staging/ccree/ssi_hash.c
index 47bc496..ed1c672 100644
--- a/drivers/staging/ccree/ssi_hash.c
+++ b/drivers/staging/ccree/ssi_hash.c
@@ -76,15 +76,11 @@ static void ssi_hash_create_cmac_setup(struct ahash_request *areq,
 
 struct ssi_hash_alg {
 	struct list_head entry;
-	bool synchronize;
 	int hash_mode;
 	int hw_mode;
 	int inter_digestsize;
 	struct ssi_drvdata *drvdata;
-	union {
-		struct ahash_alg ahash_alg;
-		struct shash_alg shash_alg;
-	};
+	struct ahash_alg ahash_alg;
 };
 
 
@@ -112,8 +108,6 @@ struct ssi_hash_ctx {
 	bool is_hmac;
 };
 
-static const struct crypto_type crypto_shash_type;
-
 static void ssi_hash_create_data_desc(
 	struct ahash_req_ctx *areq_ctx,
 	struct ssi_hash_ctx *ctx,
@@ -1015,15 +1009,9 @@ static int ssi_hash_setkey(void *hash,
 	 SSI_LOG_DEBUG("ssi_hash_setkey: start keylen: %d", keylen);
 
 	CHECK_AND_RETURN_UPON_FIPS_ERROR();
-	if (synchronize) {
-		ctx = crypto_shash_ctx(((struct crypto_shash *)hash));
-		blocksize = crypto_tfm_alg_blocksize(&((struct crypto_shash *)hash)->base);
-		digestsize = crypto_shash_digestsize(((struct crypto_shash *)hash));
-	} else {
-		ctx = crypto_ahash_ctx(((struct crypto_ahash *)hash));
-		blocksize = crypto_tfm_alg_blocksize(&((struct crypto_ahash *)hash)->base);
-		digestsize = crypto_ahash_digestsize(((struct crypto_ahash *)hash));
-	}
+	ctx = crypto_ahash_ctx(((struct crypto_ahash *)hash));
+	blocksize = crypto_tfm_alg_blocksize(&((struct crypto_ahash *)hash)->base);
+	digestsize = crypto_ahash_digestsize(((struct crypto_ahash *)hash));
 
 	larval_addr = ssi_ahash_get_larval_digest_sram_addr(
 					ctx->drvdata, ctx->hash_mode);
@@ -1184,13 +1172,8 @@ static int ssi_hash_setkey(void *hash,
 	rc = send_request(ctx->drvdata, &ssi_req, desc, idx, 0);
 
 out:
-	if (rc != 0) {
-		if (synchronize) {
-			crypto_shash_set_flags((struct crypto_shash *)hash, CRYPTO_TFM_RES_BAD_KEY_LEN);
-		} else {
-			crypto_ahash_set_flags((struct crypto_ahash *)hash, CRYPTO_TFM_RES_BAD_KEY_LEN);
-		}
-	}
+	if (rc)
+		crypto_ahash_set_flags((struct crypto_ahash *)hash, CRYPTO_TFM_RES_BAD_KEY_LEN);
 
 	if (ctx->key_params.key_dma_addr) {
 		dma_unmap_single(&ctx->drvdata->plat_dev->dev,
@@ -1395,23 +1378,6 @@ static int ssi_hash_alloc_ctx(struct ssi_hash_ctx *ctx)
 	return -ENOMEM;
 }
 
-static int ssi_shash_cra_init(struct crypto_tfm *tfm)
-{
-	struct ssi_hash_ctx *ctx = crypto_tfm_ctx(tfm);
-	struct shash_alg * shash_alg =
-		container_of(tfm->__crt_alg, struct shash_alg, base);
-	struct ssi_hash_alg *ssi_alg =
-			container_of(shash_alg, struct ssi_hash_alg, shash_alg);
-
-	CHECK_AND_RETURN_UPON_FIPS_ERROR();
-	ctx->hash_mode = ssi_alg->hash_mode;
-	ctx->hw_mode = ssi_alg->hw_mode;
-	ctx->inter_digestsize = ssi_alg->inter_digestsize;
-	ctx->drvdata = ssi_alg->drvdata;
-
-	return ssi_hash_alloc_ctx(ctx);
-}
-
 static int ssi_ahash_cra_init(struct crypto_tfm *tfm)
 {
 	struct ssi_hash_ctx *ctx = crypto_tfm_ctx(tfm);
@@ -1764,100 +1730,6 @@ static int ssi_mac_digest(struct ahash_request *req)
 	return rc;
 }
 
-//shash wrap functions
-#ifdef SYNC_ALGS
-static int ssi_shash_digest(struct shash_desc *desc,
-			    const u8 *data, unsigned int len, u8 *out)
-{
-	struct ahash_req_ctx *state = shash_desc_ctx(desc);
-	struct crypto_shash *tfm = desc->tfm;
-	struct ssi_hash_ctx *ctx = crypto_shash_ctx(tfm);
-	u32 digestsize = crypto_shash_digestsize(tfm);
-	struct scatterlist src;
-
-	if (len == 0) {
-		return ssi_hash_digest(state, ctx, digestsize, NULL, 0, out, NULL);
-	}
-
-	/* sg_init_one may crash when len is 0 (depends on kernel configuration) */
-	sg_init_one(&src, (const void *)data, len);
-
-	return ssi_hash_digest(state, ctx, digestsize, &src, len, out, NULL);
-}
-
-static int ssi_shash_update(struct shash_desc *desc,
-						const u8 *data, unsigned int len)
-{
-	struct ahash_req_ctx *state = shash_desc_ctx(desc);
-	struct crypto_shash *tfm = desc->tfm;
-	struct ssi_hash_ctx *ctx = crypto_shash_ctx(tfm);
-	u32 blocksize = crypto_tfm_alg_blocksize(&tfm->base);
-	struct scatterlist src;
-
-	sg_init_one(&src, (const void *)data, len);
-
-	return ssi_hash_update(state, ctx, blocksize, &src, len, NULL);
-}
-
-static int ssi_shash_finup(struct shash_desc *desc,
-			   const u8 *data, unsigned int len, u8 *out)
-{
-	struct ahash_req_ctx *state = shash_desc_ctx(desc);
-	struct crypto_shash *tfm = desc->tfm;
-	struct ssi_hash_ctx *ctx = crypto_shash_ctx(tfm);
-	u32 digestsize = crypto_shash_digestsize(tfm);
-	struct scatterlist src;
-
-	sg_init_one(&src, (const void *)data, len);
-
-	return ssi_hash_finup(state, ctx, digestsize, &src, len, out, NULL);
-}
-
-static int ssi_shash_final(struct shash_desc *desc, u8 *out)
-{
-	struct ahash_req_ctx *state = shash_desc_ctx(desc);
-	struct crypto_shash *tfm = desc->tfm;
-	struct ssi_hash_ctx *ctx = crypto_shash_ctx(tfm);
-	u32 digestsize = crypto_shash_digestsize(tfm);
-
-	return ssi_hash_final(state, ctx, digestsize, NULL, 0, out, NULL);
-}
-
-static int ssi_shash_init(struct shash_desc *desc)
-{
-	struct ahash_req_ctx *state = shash_desc_ctx(desc);
-	struct crypto_shash *tfm = desc->tfm;
-	struct ssi_hash_ctx *ctx = crypto_shash_ctx(tfm);
-
-	return ssi_hash_init(state, ctx);
-}
-
-#ifdef EXPORT_FIXED
-static int ssi_shash_export(struct shash_desc *desc, void *out)
-{
-	struct crypto_shash *tfm = desc->tfm;
-	struct ssi_hash_ctx *ctx = crypto_shash_ctx(tfm);
-
-	return ssi_hash_export(ctx, out);
-}
-
-static int ssi_shash_import(struct shash_desc *desc, const void *in)
-{
-	struct crypto_shash *tfm = desc->tfm;
-	struct ssi_hash_ctx *ctx = crypto_shash_ctx(tfm);
-
-	return ssi_hash_import(ctx, in);
-}
-#endif
-
-static int ssi_shash_setkey(struct crypto_shash *tfm,
-			    const u8 *key, unsigned int keylen)
-{
-	return ssi_hash_setkey((void *) tfm, key, keylen, true);
-}
-
-#endif /* SYNC_ALGS */
-
 //ahash wrap functions
 static int ssi_ahash_digest(struct ahash_request *req)
 {
@@ -1941,10 +1813,7 @@ struct ssi_hash_template {
 	char hmac_driver_name[CRYPTO_MAX_ALG_NAME];
 	unsigned int blocksize;
 	bool synchronize;
-	union {
-		struct ahash_alg template_ahash;
-		struct shash_alg template_shash;
-	};
+	struct ahash_alg template_ahash;
 	int hash_mode;
 	int hw_mode;
 	int inter_digestsize;
@@ -1961,22 +1830,20 @@ static struct ssi_hash_template driver_hash[] = {
 		.hmac_driver_name = "hmac-sha1-dx",
 		.blocksize = SHA1_BLOCK_SIZE,
 		.synchronize = false,
-		{
-			.template_ahash = {
-				.init = ssi_ahash_init,
-				.update = ssi_ahash_update,
-				.final = ssi_ahash_final,
-				.finup = ssi_ahash_finup,
-				.digest = ssi_ahash_digest,
+		.template_ahash = {
+			.init = ssi_ahash_init,
+			.update = ssi_ahash_update,
+			.final = ssi_ahash_final,
+			.finup = ssi_ahash_finup,
+			.digest = ssi_ahash_digest,
 #ifdef EXPORT_FIXED
-				.export = ssi_ahash_export,
-				.import = ssi_ahash_import,
+			.export = ssi_ahash_export,
+			.import = ssi_ahash_import,
 #endif
-				.setkey = ssi_ahash_setkey,
-				.halg = {
-					.digestsize = SHA1_DIGEST_SIZE,
-					.statesize = sizeof(struct sha1_state),
-				},
+			.setkey = ssi_ahash_setkey,
+			.halg = {
+				.digestsize = SHA1_DIGEST_SIZE,
+				.statesize = sizeof(struct sha1_state),
 			},
 		},
 		.hash_mode = DRV_HASH_SHA1,
@@ -1989,23 +1856,20 @@ static struct ssi_hash_template driver_hash[] = {
 		.hmac_name = "hmac(sha256)",
 		.hmac_driver_name = "hmac-sha256-dx",
 		.blocksize = SHA256_BLOCK_SIZE,
-		.synchronize = false,
-		{
-			.template_ahash = {
-				.init = ssi_ahash_init,
-				.update = ssi_ahash_update,
-				.final = ssi_ahash_final,
-				.finup = ssi_ahash_finup,
-				.digest = ssi_ahash_digest,
+		.template_ahash = {
+			.init = ssi_ahash_init,
+			.update = ssi_ahash_update,
+			.final = ssi_ahash_final,
+			.finup = ssi_ahash_finup,
+			.digest = ssi_ahash_digest,
 #ifdef EXPORT_FIXED
-				.export = ssi_ahash_export,
-				.import = ssi_ahash_import,
+			.export = ssi_ahash_export,
+			.import = ssi_ahash_import,
 #endif
-				.setkey = ssi_ahash_setkey,
-				.halg = {
-					.digestsize = SHA256_DIGEST_SIZE,
-					.statesize = sizeof(struct sha256_state),
-				},
+			.setkey = ssi_ahash_setkey,
+			.halg = {
+				.digestsize = SHA256_DIGEST_SIZE,
+				.statesize = sizeof(struct sha256_state),
 			},
 		},
 		.hash_mode = DRV_HASH_SHA256,
@@ -2018,23 +1882,20 @@ static struct ssi_hash_template driver_hash[] = {
 		.hmac_name = "hmac(sha224)",
 		.hmac_driver_name = "hmac-sha224-dx",
 		.blocksize = SHA224_BLOCK_SIZE,
-		.synchronize = false,
-		{
-			.template_ahash = {
-				.init = ssi_ahash_init,
-				.update = ssi_ahash_update,
-				.final = ssi_ahash_final,
-				.finup = ssi_ahash_finup,
-				.digest = ssi_ahash_digest,
+		.template_ahash = {
+			.init = ssi_ahash_init,
+			.update = ssi_ahash_update,
+			.final = ssi_ahash_final,
+			.finup = ssi_ahash_finup,
+			.digest = ssi_ahash_digest,
 #ifdef EXPORT_FIXED
-				.export = ssi_ahash_export,
-				.import = ssi_ahash_import,
+			.export = ssi_ahash_export,
+			.import = ssi_ahash_import,
 #endif
-				.setkey = ssi_ahash_setkey,
-				.halg = {
-					.digestsize = SHA224_DIGEST_SIZE,
-					.statesize = sizeof(struct sha256_state),
-				},
+			.setkey = ssi_ahash_setkey,
+			.halg = {
+				.digestsize = SHA224_DIGEST_SIZE,
+				.statesize = sizeof(struct sha256_state),
 			},
 		},
 		.hash_mode = DRV_HASH_SHA224,
@@ -2048,23 +1909,20 @@ static struct ssi_hash_template driver_hash[] = {
 		.hmac_name = "hmac(sha384)",
 		.hmac_driver_name = "hmac-sha384-dx",
 		.blocksize = SHA384_BLOCK_SIZE,
-		.synchronize = false,
-		{
-			.template_ahash = {
-				.init = ssi_ahash_init,
-				.update = ssi_ahash_update,
-				.final = ssi_ahash_final,
-				.finup = ssi_ahash_finup,
-				.digest = ssi_ahash_digest,
+		.template_ahash = {
+			.init = ssi_ahash_init,
+			.update = ssi_ahash_update,
+			.final = ssi_ahash_final,
+			.finup = ssi_ahash_finup,
+			.digest = ssi_ahash_digest,
 #ifdef EXPORT_FIXED
-				.export = ssi_ahash_export,
-				.import = ssi_ahash_import,
+			.export = ssi_ahash_export,
+			.import = ssi_ahash_import,
 #endif
-				.setkey = ssi_ahash_setkey,
-				.halg = {
-					.digestsize = SHA384_DIGEST_SIZE,
-					.statesize = sizeof(struct sha512_state),
-				},
+			.setkey = ssi_ahash_setkey,
+			.halg = {
+				.digestsize = SHA384_DIGEST_SIZE,
+				.statesize = sizeof(struct sha512_state),
 			},
 		},
 		.hash_mode = DRV_HASH_SHA384,
@@ -2077,23 +1935,20 @@ static struct ssi_hash_template driver_hash[] = {
 		.hmac_name = "hmac(sha512)",
 		.hmac_driver_name = "hmac-sha512-dx",
 		.blocksize = SHA512_BLOCK_SIZE,
-		.synchronize = false,
-		{
-			.template_ahash = {
-				.init = ssi_ahash_init,
-				.update = ssi_ahash_update,
-				.final = ssi_ahash_final,
-				.finup = ssi_ahash_finup,
-				.digest = ssi_ahash_digest,
+		.template_ahash = {
+			.init = ssi_ahash_init,
+			.update = ssi_ahash_update,
+			.final = ssi_ahash_final,
+			.finup = ssi_ahash_finup,
+			.digest = ssi_ahash_digest,
 #ifdef EXPORT_FIXED
-				.export = ssi_ahash_export,
-				.import = ssi_ahash_import,
+			.export = ssi_ahash_export,
+			.import = ssi_ahash_import,
 #endif
-				.setkey = ssi_ahash_setkey,
-				.halg = {
-					.digestsize = SHA512_DIGEST_SIZE,
-					.statesize = sizeof(struct sha512_state),
-				},
+			.setkey = ssi_ahash_setkey,
+			.halg = {
+				.digestsize = SHA512_DIGEST_SIZE,
+				.statesize = sizeof(struct sha512_state),
 			},
 		},
 		.hash_mode = DRV_HASH_SHA512,
@@ -2107,23 +1962,20 @@ static struct ssi_hash_template driver_hash[] = {
 		.hmac_name = "hmac(md5)",
 		.hmac_driver_name = "hmac-md5-dx",
 		.blocksize = MD5_HMAC_BLOCK_SIZE,
-		.synchronize = false,
-		{
-			.template_ahash = {
-				.init = ssi_ahash_init,
-				.update = ssi_ahash_update,
-				.final = ssi_ahash_final,
-				.finup = ssi_ahash_finup,
-				.digest = ssi_ahash_digest,
+		.template_ahash = {
+			.init = ssi_ahash_init,
+			.update = ssi_ahash_update,
+			.final = ssi_ahash_final,
+			.finup = ssi_ahash_finup,
+			.digest = ssi_ahash_digest,
 #ifdef EXPORT_FIXED
-				.export = ssi_ahash_export,
-				.import = ssi_ahash_import,
+			.export = ssi_ahash_export,
+			.import = ssi_ahash_import,
 #endif
-				.setkey = ssi_ahash_setkey,
-				.halg = {
-					.digestsize = MD5_DIGEST_SIZE,
-					.statesize = sizeof(struct md5_state),
-				},
+			.setkey = ssi_ahash_setkey,
+			.halg = {
+				.digestsize = MD5_DIGEST_SIZE,
+				.statesize = sizeof(struct md5_state),
 			},
 		},
 		.hash_mode = DRV_HASH_MD5,
@@ -2134,23 +1986,20 @@ static struct ssi_hash_template driver_hash[] = {
 		.name = "xcbc(aes)",
 		.driver_name = "xcbc-aes-dx",
 		.blocksize = AES_BLOCK_SIZE,
-		.synchronize = false,
-		{
-			.template_ahash = {
-				.init = ssi_ahash_init,
-				.update = ssi_mac_update,
-				.final = ssi_mac_final,
-				.finup = ssi_mac_finup,
-				.digest = ssi_mac_digest,
-				.setkey = ssi_xcbc_setkey,
+		.template_ahash = {
+			.init = ssi_ahash_init,
+			.update = ssi_mac_update,
+			.final = ssi_mac_final,
+			.finup = ssi_mac_finup,
+			.digest = ssi_mac_digest,
+			.setkey = ssi_xcbc_setkey,
 #ifdef EXPORT_FIXED
-				.export = ssi_ahash_export,
-				.import = ssi_ahash_import,
+			.export = ssi_ahash_export,
+			.import = ssi_ahash_import,
 #endif
-				.halg = {
-					.digestsize = AES_BLOCK_SIZE,
-					.statesize = sizeof(struct aeshash_state),
-				},
+			.halg = {
+				.digestsize = AES_BLOCK_SIZE,
+				.statesize = sizeof(struct aeshash_state),
 			},
 		},
 		.hash_mode = DRV_HASH_NULL,
@@ -2162,23 +2011,20 @@ static struct ssi_hash_template driver_hash[] = {
 		.name = "cmac(aes)",
 		.driver_name = "cmac-aes-dx",
 		.blocksize = AES_BLOCK_SIZE,
-		.synchronize = false,
-		{
-			.template_ahash = {
-				.init = ssi_ahash_init,
-				.update = ssi_mac_update,
-				.final = ssi_mac_final,
-				.finup = ssi_mac_finup,
-				.digest = ssi_mac_digest,
-				.setkey = ssi_cmac_setkey,
+		.template_ahash = {
+			.init = ssi_ahash_init,
+			.update = ssi_mac_update,
+			.final = ssi_mac_final,
+			.finup = ssi_mac_finup,
+			.digest = ssi_mac_digest,
+			.setkey = ssi_cmac_setkey,
 #ifdef EXPORT_FIXED
-				.export = ssi_ahash_export,
-				.import = ssi_ahash_import,
+			.export = ssi_ahash_export,
+			.import = ssi_ahash_import,
 #endif
-				.halg = {
-					.digestsize = AES_BLOCK_SIZE,
-					.statesize = sizeof(struct aeshash_state),
-				},
+			.halg = {
+				.digestsize = AES_BLOCK_SIZE,
+				.statesize = sizeof(struct aeshash_state),
 			},
 		},
 		.hash_mode = DRV_HASH_NULL,
@@ -2194,6 +2040,7 @@ ssi_hash_create_alg(struct ssi_hash_template *template, bool keyed)
 {
 	struct ssi_hash_alg *t_crypto_alg;
 	struct crypto_alg *alg;
+	struct ahash_alg *halg;
 
 	t_crypto_alg = kzalloc(sizeof(struct ssi_hash_alg), GFP_KERNEL);
 	if (!t_crypto_alg) {
@@ -2201,20 +2048,9 @@ ssi_hash_create_alg(struct ssi_hash_template *template, bool keyed)
 		return ERR_PTR(-ENOMEM);
 	}
 
-	t_crypto_alg->synchronize = template->synchronize;
-	if (template->synchronize) {
-		struct shash_alg *halg;
-		t_crypto_alg->shash_alg = template->template_shash;
-		halg = &t_crypto_alg->shash_alg;
-		alg = &halg->base;
-		if (!keyed) halg->setkey = NULL;
-	} else {
-		struct ahash_alg *halg;
-		t_crypto_alg->ahash_alg = template->template_ahash;
-		halg = &t_crypto_alg->ahash_alg;
-		alg = &halg->halg.base;
-		if (!keyed) halg->setkey = NULL;
-	}
+	t_crypto_alg->ahash_alg = template->template_ahash;
+	halg = &t_crypto_alg->ahash_alg;
+	alg = &halg->halg.base;
 
 	if (keyed) {
 		snprintf(alg->cra_name, CRYPTO_MAX_ALG_NAME, "%s",
@@ -2222,6 +2058,7 @@ ssi_hash_create_alg(struct ssi_hash_template *template, bool keyed)
 		snprintf(alg->cra_driver_name, CRYPTO_MAX_ALG_NAME, "%s",
 			 template->hmac_driver_name);
 	} else {
+		halg->setkey = NULL;
 		snprintf(alg->cra_name, CRYPTO_MAX_ALG_NAME, "%s",
 			 template->name);
 		snprintf(alg->cra_driver_name, CRYPTO_MAX_ALG_NAME, "%s",
@@ -2234,17 +2071,10 @@ ssi_hash_create_alg(struct ssi_hash_template *template, bool keyed)
 	alg->cra_alignmask = 0;
 	alg->cra_exit = ssi_hash_cra_exit;
 
-	if (template->synchronize) {
-		alg->cra_init = ssi_shash_cra_init;
-		alg->cra_flags = CRYPTO_ALG_TYPE_SHASH |
-			CRYPTO_ALG_KERN_DRIVER_ONLY;
-		alg->cra_type = &crypto_shash_type;
-	} else {
-		alg->cra_init = ssi_ahash_cra_init;
-		alg->cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_TYPE_AHASH |
+	alg->cra_init = ssi_ahash_cra_init;
+	alg->cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_TYPE_AHASH |
 			CRYPTO_ALG_KERN_DRIVER_ONLY;
-		alg->cra_type = &crypto_ahash_type;
-	}
+	alg->cra_type = &crypto_ahash_type;
 
 	t_crypto_alg->hash_mode = template->hash_mode;
 	t_crypto_alg->hw_mode = template->hw_mode;
@@ -2429,24 +2259,15 @@ int ssi_hash_alloc(struct ssi_drvdata *drvdata)
 			}
 			t_alg->drvdata = drvdata;
 
-			if (t_alg->synchronize) {
-				rc = crypto_register_shash(&t_alg->shash_alg);
-				if (unlikely(rc != 0)) {
-					SSI_LOG_ERR("%s alg registration failed\n",
-						t_alg->shash_alg.base.cra_driver_name);
-					kfree(t_alg);
-					goto fail;
-				} else
-					list_add_tail(&t_alg->entry, &hash_handle->hash_list);
+			rc = crypto_register_ahash(&t_alg->ahash_alg);
+			if (unlikely(rc)) {
+				SSI_LOG_ERR("%s alg registration failed\n",
+					    driver_hash[alg].driver_name);
+				kfree(t_alg);
+				goto fail;
 			} else {
-				rc = crypto_register_ahash(&t_alg->ahash_alg);
-				if (unlikely(rc != 0)) {
-					SSI_LOG_ERR("%s alg registration failed\n",
-						t_alg->ahash_alg.halg.base.cra_driver_name);
-					kfree(t_alg);
-					goto fail;
-				} else
-					list_add_tail(&t_alg->entry, &hash_handle->hash_list);
+				list_add_tail(&t_alg->entry,
+					      &hash_handle->hash_list);
 			}
 		}
 
@@ -2460,25 +2281,14 @@ int ssi_hash_alloc(struct ssi_drvdata *drvdata)
 		}
 		t_alg->drvdata = drvdata;
 
-		if (t_alg->synchronize) {
-			rc = crypto_register_shash(&t_alg->shash_alg);
-			if (unlikely(rc != 0)) {
-				SSI_LOG_ERR("%s alg registration failed\n",
-					t_alg->shash_alg.base.cra_driver_name);
-				kfree(t_alg);
-				goto fail;
-			} else
-				list_add_tail(&t_alg->entry, &hash_handle->hash_list);
-
+		rc = crypto_register_ahash(&t_alg->ahash_alg);
+		if (unlikely(rc)) {
+			SSI_LOG_ERR("%s alg registration failed\n",
+				    driver_hash[alg].driver_name);
+			kfree(t_alg);
+			goto fail;
 		} else {
-			rc = crypto_register_ahash(&t_alg->ahash_alg);
-			if (unlikely(rc != 0)) {
-				SSI_LOG_ERR("%s alg registration failed\n",
-					t_alg->ahash_alg.halg.base.cra_driver_name);
-				kfree(t_alg);
-				goto fail;
-			} else
-				list_add_tail(&t_alg->entry, &hash_handle->hash_list);
+			list_add_tail(&t_alg->entry, &hash_handle->hash_list);
 		}
 	}
 
@@ -2501,11 +2311,7 @@ int ssi_hash_free(struct ssi_drvdata *drvdata)
 	if (hash_handle != NULL) {
 
 		list_for_each_entry_safe(t_hash_alg, hash_n, &hash_handle->hash_list, entry) {
-			if (t_hash_alg->synchronize) {
-				crypto_unregister_shash(&t_hash_alg->shash_alg);
-			} else {
-				crypto_unregister_ahash(&t_hash_alg->ahash_alg);
-			}
+			crypto_unregister_ahash(&t_hash_alg->ahash_alg);
 			list_del(&t_hash_alg->entry);
 			kfree(t_hash_alg);
 		}
-- 
2.1.4
