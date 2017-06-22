From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH v2 1/7] staging: ccree: fix hash import/export
Date: Thu, 22 Jun 2017 16:36:55 +0300
Message-ID: <1498138623-6126-2-git-send-email-gilad@benyossef.com>
References: <1498138623-6126-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1498138623-6126-1-git-send-email-gilad@benyossef.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hash import and export was saving and restoring the wrong context
and therefore disabled. Fix it by restoring intermediate digest
and additional state needed.

The hash and mac transform now pass testmgr partial hash tests.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_hash.c | 140 +++++++++++++++++++++++++++------------
 drivers/staging/ccree/ssi_hash.h |   2 +
 2 files changed, 98 insertions(+), 44 deletions(-)

diff --git a/drivers/staging/ccree/ssi_hash.c b/drivers/staging/ccree/ssi_hash.c
index ed1c672..c39e3be 100644
--- a/drivers/staging/ccree/ssi_hash.c
+++ b/drivers/staging/ccree/ssi_hash.c
@@ -976,22 +976,6 @@ static int ssi_hash_init(struct ahash_req_ctx *state, struct ssi_hash_ctx *ctx)
 	return 0;
 }
 
-#ifdef EXPORT_FIXED
-static int ssi_hash_export(struct ssi_hash_ctx *ctx, void *out)
-{
-	CHECK_AND_RETURN_UPON_FIPS_ERROR();
-	memcpy(out, ctx, sizeof(struct ssi_hash_ctx));
-	return 0;
-}
-
-static int ssi_hash_import(struct ssi_hash_ctx *ctx, const void *in)
-{
-	CHECK_AND_RETURN_UPON_FIPS_ERROR();
-	memcpy(ctx, in, sizeof(struct ssi_hash_ctx));
-	return 0;
-}
-#endif
-
 static int ssi_hash_setkey(void *hash,
 			   const u8 *key,
 			   unsigned int keylen,
@@ -1782,23 +1766,104 @@ static int ssi_ahash_init(struct ahash_request *req)
 	return ssi_hash_init(state, ctx);
 }
 
-#ifdef EXPORT_FIXED
 static int ssi_ahash_export(struct ahash_request *req, void *out)
 {
 	struct crypto_ahash *ahash = crypto_ahash_reqtfm(req);
 	struct ssi_hash_ctx *ctx = crypto_ahash_ctx(ahash);
+	struct device *dev = &ctx->drvdata->plat_dev->dev;
+	struct ahash_req_ctx *state = ahash_request_ctx(req);
+	u8 *curr_buff = state->buff_index ? state->buff1 : state->buff0;
+	u32 curr_buff_cnt = state->buff_index ? state->buff1_cnt :
+				state->buff0_cnt;
+	const u32 tmp = CC_EXPORT_MAGIC;
+
+	CHECK_AND_RETURN_UPON_FIPS_ERROR();
 
-	return ssi_hash_export(ctx, out);
+	memcpy(out, &tmp, sizeof(u32));
+	out += sizeof(u32);
+
+	dma_sync_single_for_cpu(dev, state->digest_buff_dma_addr,
+				ctx->inter_digestsize, DMA_BIDIRECTIONAL);
+	memcpy(out, state->digest_buff, ctx->inter_digestsize);
+	out += ctx->inter_digestsize;
+
+	if (state->digest_bytes_len_dma_addr) {
+		dma_sync_single_for_cpu(dev, state->digest_bytes_len_dma_addr,
+					HASH_LEN_SIZE, DMA_BIDIRECTIONAL);
+		memcpy(out, state->digest_bytes_len, HASH_LEN_SIZE);
+	}
+	out += HASH_LEN_SIZE;
+
+	memcpy(out, &curr_buff_cnt, sizeof(u32));
+	out += sizeof(u32);
+
+	memcpy(out, curr_buff, curr_buff_cnt);
+
+	/* No sync for device ineeded since we did not change the data,
+	 * we only copy it
+	 */
+
+	return 0;
 }
 
 static int ssi_ahash_import(struct ahash_request *req, const void *in)
 {
 	struct crypto_ahash *ahash = crypto_ahash_reqtfm(req);
 	struct ssi_hash_ctx *ctx = crypto_ahash_ctx(ahash);
+	struct device *dev = &ctx->drvdata->plat_dev->dev;
+	struct ahash_req_ctx *state = ahash_request_ctx(req);
+	u32 tmp;
+	int rc;
+
+	CHECK_AND_RETURN_UPON_FIPS_ERROR();
 
-	return ssi_hash_import(ctx, in);
+	memcpy(&tmp, in, sizeof(u32));
+	if (tmp != CC_EXPORT_MAGIC) {
+		rc = -EINVAL;
+		goto out;
+	}
+	in += sizeof(u32);
+
+	rc = ssi_hash_init(state, ctx);
+	if (rc)
+		goto out;
+
+	dma_sync_single_for_cpu(dev, state->digest_buff_dma_addr,
+				ctx->inter_digestsize, DMA_BIDIRECTIONAL);
+	memcpy(state->digest_buff, in, ctx->inter_digestsize);
+	in += ctx->inter_digestsize;
+
+	if (state->digest_bytes_len_dma_addr) {
+		dma_sync_single_for_cpu(dev, state->digest_bytes_len_dma_addr,
+					HASH_LEN_SIZE, DMA_BIDIRECTIONAL);
+		memcpy(state->digest_bytes_len, in, HASH_LEN_SIZE);
+	}
+	in += HASH_LEN_SIZE;
+
+	dma_sync_single_for_device(dev, state->digest_buff_dma_addr,
+				   ctx->inter_digestsize, DMA_BIDIRECTIONAL);
+
+	if (state->digest_bytes_len_dma_addr)
+		dma_sync_single_for_device(dev,
+					   state->digest_bytes_len_dma_addr,
+					   HASH_LEN_SIZE, DMA_BIDIRECTIONAL);
+
+	state->buff_index = 0;
+
+	/* Sanity check the data as much as possible */
+	memcpy(&tmp, in, sizeof(u32));
+	if (tmp > SSI_MAX_HASH_BLCK_SIZE) {
+		rc = -EINVAL;
+		goto out;
+	}
+	in += sizeof(u32);
+
+	state->buff0_cnt = tmp;
+	memcpy(state->buff0, in, state->buff0_cnt);
+
+out:
+	return rc;
 }
-#endif
 
 static int ssi_ahash_setkey(struct crypto_ahash *ahash,
 			const u8 *key, unsigned int keylen)
@@ -1820,6 +1885,9 @@ struct ssi_hash_template {
 	struct ssi_drvdata *drvdata;
 };
 
+#define CC_STATE_SIZE(_x) \
+	((_x) + HASH_LEN_SIZE + SSI_MAX_HASH_BLCK_SIZE + (2 * sizeof(u32)))
+
 /* hash descriptors */
 static struct ssi_hash_template driver_hash[] = {
 	//Asynchronize hash template
@@ -1836,14 +1904,12 @@ static struct ssi_hash_template driver_hash[] = {
 			.final = ssi_ahash_final,
 			.finup = ssi_ahash_finup,
 			.digest = ssi_ahash_digest,
-#ifdef EXPORT_FIXED
 			.export = ssi_ahash_export,
 			.import = ssi_ahash_import,
-#endif
 			.setkey = ssi_ahash_setkey,
 			.halg = {
 				.digestsize = SHA1_DIGEST_SIZE,
-				.statesize = sizeof(struct sha1_state),
+				.statesize = CC_STATE_SIZE(SHA1_DIGEST_SIZE),
 			},
 		},
 		.hash_mode = DRV_HASH_SHA1,
@@ -1862,14 +1928,12 @@ static struct ssi_hash_template driver_hash[] = {
 			.final = ssi_ahash_final,
 			.finup = ssi_ahash_finup,
 			.digest = ssi_ahash_digest,
-#ifdef EXPORT_FIXED
 			.export = ssi_ahash_export,
 			.import = ssi_ahash_import,
-#endif
 			.setkey = ssi_ahash_setkey,
 			.halg = {
 				.digestsize = SHA256_DIGEST_SIZE,
-				.statesize = sizeof(struct sha256_state),
+				.statesize = CC_STATE_SIZE(SHA256_DIGEST_SIZE)
 			},
 		},
 		.hash_mode = DRV_HASH_SHA256,
@@ -1888,14 +1952,12 @@ static struct ssi_hash_template driver_hash[] = {
 			.final = ssi_ahash_final,
 			.finup = ssi_ahash_finup,
 			.digest = ssi_ahash_digest,
-#ifdef EXPORT_FIXED
 			.export = ssi_ahash_export,
 			.import = ssi_ahash_import,
-#endif
 			.setkey = ssi_ahash_setkey,
 			.halg = {
 				.digestsize = SHA224_DIGEST_SIZE,
-				.statesize = sizeof(struct sha256_state),
+				.statesize = CC_STATE_SIZE(SHA224_DIGEST_SIZE),
 			},
 		},
 		.hash_mode = DRV_HASH_SHA224,
@@ -1915,14 +1977,12 @@ static struct ssi_hash_template driver_hash[] = {
 			.final = ssi_ahash_final,
 			.finup = ssi_ahash_finup,
 			.digest = ssi_ahash_digest,
-#ifdef EXPORT_FIXED
 			.export = ssi_ahash_export,
 			.import = ssi_ahash_import,
-#endif
 			.setkey = ssi_ahash_setkey,
 			.halg = {
 				.digestsize = SHA384_DIGEST_SIZE,
-				.statesize = sizeof(struct sha512_state),
+				.statesize = CC_STATE_SIZE(SHA384_DIGEST_SIZE),
 			},
 		},
 		.hash_mode = DRV_HASH_SHA384,
@@ -1941,14 +2001,12 @@ static struct ssi_hash_template driver_hash[] = {
 			.final = ssi_ahash_final,
 			.finup = ssi_ahash_finup,
 			.digest = ssi_ahash_digest,
-#ifdef EXPORT_FIXED
 			.export = ssi_ahash_export,
 			.import = ssi_ahash_import,
-#endif
 			.setkey = ssi_ahash_setkey,
 			.halg = {
 				.digestsize = SHA512_DIGEST_SIZE,
-				.statesize = sizeof(struct sha512_state),
+				.statesize = CC_STATE_SIZE(SHA512_DIGEST_SIZE),
 			},
 		},
 		.hash_mode = DRV_HASH_SHA512,
@@ -1968,14 +2026,12 @@ static struct ssi_hash_template driver_hash[] = {
 			.final = ssi_ahash_final,
 			.finup = ssi_ahash_finup,
 			.digest = ssi_ahash_digest,
-#ifdef EXPORT_FIXED
 			.export = ssi_ahash_export,
 			.import = ssi_ahash_import,
-#endif
 			.setkey = ssi_ahash_setkey,
 			.halg = {
 				.digestsize = MD5_DIGEST_SIZE,
-				.statesize = sizeof(struct md5_state),
+				.statesize = CC_STATE_SIZE(MD5_DIGEST_SIZE),
 			},
 		},
 		.hash_mode = DRV_HASH_MD5,
@@ -1993,13 +2049,11 @@ static struct ssi_hash_template driver_hash[] = {
 			.finup = ssi_mac_finup,
 			.digest = ssi_mac_digest,
 			.setkey = ssi_xcbc_setkey,
-#ifdef EXPORT_FIXED
 			.export = ssi_ahash_export,
 			.import = ssi_ahash_import,
-#endif
 			.halg = {
 				.digestsize = AES_BLOCK_SIZE,
-				.statesize = sizeof(struct aeshash_state),
+				.statesize = CC_STATE_SIZE(AES_BLOCK_SIZE),
 			},
 		},
 		.hash_mode = DRV_HASH_NULL,
@@ -2018,13 +2072,11 @@ static struct ssi_hash_template driver_hash[] = {
 			.finup = ssi_mac_finup,
 			.digest = ssi_mac_digest,
 			.setkey = ssi_cmac_setkey,
-#ifdef EXPORT_FIXED
 			.export = ssi_ahash_export,
 			.import = ssi_ahash_import,
-#endif
 			.halg = {
 				.digestsize = AES_BLOCK_SIZE,
-				.statesize = sizeof(struct aeshash_state),
+				.statesize = CC_STATE_SIZE(AES_BLOCK_SIZE),
 			},
 		},
 		.hash_mode = DRV_HASH_NULL,
diff --git a/drivers/staging/ccree/ssi_hash.h b/drivers/staging/ccree/ssi_hash.h
index 7c94661..0bb99cb 100644
--- a/drivers/staging/ccree/ssi_hash.h
+++ b/drivers/staging/ccree/ssi_hash.h
@@ -39,6 +39,8 @@
 #define XCBC_MAC_K2_OFFSET 16
 #define XCBC_MAC_K3_OFFSET 32
 
+#define CC_EXPORT_MAGIC 0xC2EE1070U
+
 // this struct was taken from drivers/crypto/nx/nx-aes-xcbc.c and it is used for xcbc/cmac statesize
 struct aeshash_state {
 	u8 state[AES_BLOCK_SIZE];
-- 
2.1.4
