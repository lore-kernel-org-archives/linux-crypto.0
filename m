From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 20/24] staging: ccree: remove unneeded wrapper function
Date: Mon, 13 Nov 2017 14:45:48 +0000
Message-ID: <1510584358-29473-21-git-send-email-gilad@benyossef.com>
References: <1510584358-29473-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>, linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1510584358-29473-1-git-send-email-gilad@benyossef.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Remove unneeded wrapper function to simplify code.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_hash.c | 21 ++++++---------------
 1 file changed, 6 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/ccree/ssi_hash.c b/drivers/staging/ccree/ssi_hash.c
index afdc44e..a2e8a9d 100644
--- a/drivers/staging/ccree/ssi_hash.c
+++ b/drivers/staging/ccree/ssi_hash.c
@@ -986,10 +986,8 @@ static int ssi_hash_init(struct ahash_req_ctx *state, struct ssi_hash_ctx *ctx)
 	return 0;
 }
 
-static int ssi_hash_setkey(void *hash,
-			   const u8 *key,
-			   unsigned int keylen,
-			   bool synchronize)
+static int ssi_ahash_setkey(struct crypto_ahash *ahash, const u8 *key,
+			    unsigned int keylen)
 {
 	unsigned int hmac_pad_const[2] = { HMAC_IPAD_CONST, HMAC_OPAD_CONST };
 	struct ssi_crypto_req ssi_req = {};
@@ -1001,12 +999,12 @@ static int ssi_hash_setkey(void *hash,
 	ssi_sram_addr_t larval_addr;
 	struct device *dev;
 
-	ctx = crypto_ahash_ctx(((struct crypto_ahash *)hash));
+	ctx = crypto_ahash_ctx(ahash);
 	dev = drvdata_to_dev(ctx->drvdata);
 	dev_dbg(dev, "start keylen: %d", keylen);
 
-	blocksize = crypto_tfm_alg_blocksize(&((struct crypto_ahash *)hash)->base);
-	digestsize = crypto_ahash_digestsize(((struct crypto_ahash *)hash));
+	blocksize = crypto_tfm_alg_blocksize(&ahash->base);
+	digestsize = crypto_ahash_digestsize(ahash);
 
 	larval_addr = cc_larval_digest_addr(ctx->drvdata, ctx->hash_mode);
 
@@ -1167,8 +1165,7 @@ static int ssi_hash_setkey(void *hash,
 
 out:
 	if (rc)
-		crypto_ahash_set_flags((struct crypto_ahash *)hash,
-				       CRYPTO_TFM_RES_BAD_KEY_LEN);
+		crypto_ahash_set_flags(ahash, CRYPTO_TFM_RES_BAD_KEY_LEN);
 
 	if (ctx->key_params.key_dma_addr) {
 		dma_unmap_single(dev, ctx->key_params.key_dma_addr,
@@ -1879,12 +1876,6 @@ static int ssi_ahash_import(struct ahash_request *req, const void *in)
 	return rc;
 }
 
-static int ssi_ahash_setkey(struct crypto_ahash *ahash,
-			    const u8 *key, unsigned int keylen)
-{
-	return ssi_hash_setkey((void *)ahash, key, keylen, false);
-}
-
 struct ssi_hash_template {
 	char name[CRYPTO_MAX_ALG_NAME];
 	char driver_name[CRYPTO_MAX_ALG_NAME];
-- 
2.7.4
