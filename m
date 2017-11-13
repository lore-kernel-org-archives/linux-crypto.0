From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 18/24] staging: ccree: rename func for readability
Date: Mon, 13 Nov 2017 14:45:46 +0000
Message-ID: <1510584358-29473-19-git-send-email-gilad@benyossef.com>
References: <1510584358-29473-1-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
 driverdev-devel@linuxdriverproject.org, linux-crypto@vger.kernel.org,
 Ofir Drang <ofir.drang@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1510584358-29473-1-git-send-email-gilad@benyossef.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
List-Id: linux-crypto.vger.kernel.org

Rename the insanely long ssi_ahash_get_larval_digest_sram_addr() func
to cc_larval_digest_addr() for better code readability

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_aead.c |  7 +++----
 drivers/staging/ccree/ssi_hash.c | 13 ++++++-------
 drivers/staging/ccree/ssi_hash.h |  2 +-
 3 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/ccree/ssi_aead.c b/drivers/staging/ccree/ssi_aead.c
index e2cdf52..fcff625 100644
--- a/drivers/staging/ccree/ssi_aead.c
+++ b/drivers/staging/ccree/ssi_aead.c
@@ -336,8 +336,8 @@ static int hmac_setkey(struct cc_hw_desc *desc, struct ssi_aead_ctx *ctx)
 		hw_desc_init(&desc[idx]);
 		set_cipher_mode(&desc[idx], hash_mode);
 		set_din_sram(&desc[idx],
-			     ssi_ahash_get_larval_digest_sram_addr(
-				ctx->drvdata, ctx->auth_mode),
+			     cc_larval_digest_addr(ctx->drvdata,
+						   ctx->auth_mode),
 			     digest_size);
 		set_flow_mode(&desc[idx], S_DIN_to_HASH);
 		set_setup_mode(&desc[idx], SETUP_LOAD_STATE0);
@@ -441,8 +441,7 @@ ssi_get_plain_hmac_key(struct crypto_aead *tfm, const u8 *key,
 	dma_addr_t key_dma_addr = 0;
 	struct ssi_aead_ctx *ctx = crypto_aead_ctx(tfm);
 	struct device *dev = drvdata_to_dev(ctx->drvdata);
-	u32 larval_addr = ssi_ahash_get_larval_digest_sram_addr(
-					ctx->drvdata, ctx->auth_mode);
+	u32 larval_addr = cc_larval_digest_addr(ctx->drvdata, ctx->auth_mode);
 	struct ssi_crypto_req ssi_req = {};
 	unsigned int blocksize;
 	unsigned int digestsize;
diff --git a/drivers/staging/ccree/ssi_hash.c b/drivers/staging/ccree/ssi_hash.c
index 4d7e565..0f67737 100644
--- a/drivers/staging/ccree/ssi_hash.c
+++ b/drivers/staging/ccree/ssi_hash.c
@@ -150,8 +150,8 @@ static int ssi_hash_map_request(struct device *dev,
 				struct ssi_hash_ctx *ctx)
 {
 	bool is_hmac = ctx->is_hmac;
-	ssi_sram_addr_t larval_digest_addr = ssi_ahash_get_larval_digest_sram_addr(
-					ctx->drvdata, ctx->hash_mode);
+	ssi_sram_addr_t larval_digest_addr =
+		cc_larval_digest_addr(ctx->drvdata, ctx->hash_mode);
 	struct ssi_crypto_req ssi_req = {};
 	struct cc_hw_desc desc;
 	int rc = -ENOMEM;
@@ -438,8 +438,8 @@ static int ssi_hash_digest(struct ahash_req_ctx *state,
 	bool is_hmac = ctx->is_hmac;
 	struct ssi_crypto_req ssi_req = {};
 	struct cc_hw_desc desc[SSI_MAX_AHASH_SEQ_LEN];
-	ssi_sram_addr_t larval_digest_addr = ssi_ahash_get_larval_digest_sram_addr(
-					ctx->drvdata, ctx->hash_mode);
+	ssi_sram_addr_t larval_digest_addr =
+		cc_larval_digest_addr(ctx->drvdata, ctx->hash_mode);
 	int idx = 0;
 	int rc = 0;
 
@@ -1008,8 +1008,7 @@ static int ssi_hash_setkey(void *hash,
 	blocksize = crypto_tfm_alg_blocksize(&((struct crypto_ahash *)hash)->base);
 	digestsize = crypto_ahash_digestsize(((struct crypto_ahash *)hash));
 
-	larval_addr = ssi_ahash_get_larval_digest_sram_addr(
-					ctx->drvdata, ctx->hash_mode);
+	larval_addr = cc_larval_digest_addr(ctx->drvdata, ctx->hash_mode);
 
 	/* The keylen value distinguishes HASH in case keylen is ZERO bytes,
 	 * any NON-ZERO value utilizes HMAC flow
@@ -2538,7 +2537,7 @@ static void ssi_hash_create_data_desc(struct ahash_req_ctx *areq_ctx,
  *
  * \return u32 The address of the initial digest in SRAM
  */
-ssi_sram_addr_t ssi_ahash_get_larval_digest_sram_addr(void *drvdata, u32 mode)
+ssi_sram_addr_t cc_larval_digest_addr(void *drvdata, u32 mode)
 {
 	struct ssi_drvdata *_drvdata = (struct ssi_drvdata *)drvdata;
 	struct ssi_hash_handle *hash_handle = _drvdata->hash_handle;
diff --git a/drivers/staging/ccree/ssi_hash.h b/drivers/staging/ccree/ssi_hash.h
index 8e6eee5..32eb473 100644
--- a/drivers/staging/ccree/ssi_hash.h
+++ b/drivers/staging/ccree/ssi_hash.h
@@ -101,7 +101,7 @@ ssi_ahash_get_initial_digest_len_sram_addr(void *drvdata, u32 mode);
  *
  * \return u32 The address of the initial digest in SRAM
  */
-ssi_sram_addr_t ssi_ahash_get_larval_digest_sram_addr(void *drvdata, u32 mode);
+ssi_sram_addr_t cc_larval_digest_addr(void *drvdata, u32 mode);
 
 #endif /*__SSI_HASH_H__*/
 
-- 
2.7.4
