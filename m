From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 09/10] staging: ccree: fix AEAD func naming convention
Date: Sun,  3 Dec 2017 13:58:20 +0000
Message-ID: <1512309503-29766-10-git-send-email-gilad@benyossef.com>
References: <1512309503-29766-1-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, devel@driverdev.osuosl.org,
 driverdev-devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
 Ofir Drang <ofir.drang@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1512309503-29766-1-git-send-email-gilad@benyossef.com>
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

The aead files was using a func naming convention which was inconsistent
(ssi vs. cc), included a useless prefix (ssi_aead) and often used
too long function names producing monster func names such as
ssi_aead_gcm_setup_ghash_desc() that made the call site code hard
to read.

Make the code more readable by switching to a simpler, consistent naming
conventionfor all the function defined in the file.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_aead.c   | 544 ++++++++++++++++++-------------------
 drivers/staging/ccree/ssi_aead.h   |   4 +-
 drivers/staging/ccree/ssi_driver.c |   6 +-
 3 files changed, 273 insertions(+), 281 deletions(-)

diff --git a/drivers/staging/ccree/ssi_aead.c b/drivers/staging/ccree/ssi_aead.c
index f214df7..54edd99 100644
--- a/drivers/staging/ccree/ssi_aead.c
+++ b/drivers/staging/ccree/ssi_aead.c
@@ -51,7 +51,7 @@
 /* Value of each ICV_CMP byte (of 8) in case of success */
 #define ICV_VERIF_OK 0x01
 
-struct ssi_aead_handle {
+struct cc_aead_handle {
 	ssi_sram_addr_t sram_workspace_addr;
 	struct list_head aead_list;
 };
@@ -68,7 +68,7 @@ struct cc_xcbc_s {
 	dma_addr_t xcbc_keys_dma_addr;
 };
 
-struct ssi_aead_ctx {
+struct cc_aead_ctx {
 	struct ssi_drvdata *drvdata;
 	u8 ctr_nonce[MAX_NONCE_SIZE]; /* used for ctr3686 iv and aes ccm */
 	u8 *enckey;
@@ -90,9 +90,9 @@ static inline bool valid_assoclen(struct aead_request *req)
 	return ((req->assoclen == 16) || (req->assoclen == 20));
 }
 
-static void ssi_aead_exit(struct crypto_aead *tfm)
+static void cc_aead_exit(struct crypto_aead *tfm)
 {
-	struct ssi_aead_ctx *ctx = crypto_aead_ctx(tfm);
+	struct cc_aead_ctx *ctx = crypto_aead_ctx(tfm);
 	struct device *dev = drvdata_to_dev(ctx->drvdata);
 
 	dev_dbg(dev, "Clearing context @%p for %s\n", crypto_aead_ctx(tfm),
@@ -144,10 +144,10 @@ static void ssi_aead_exit(struct crypto_aead *tfm)
 	}
 }
 
-static int ssi_aead_init(struct crypto_aead *tfm)
+static int cc_aead_init(struct crypto_aead *tfm)
 {
 	struct aead_alg *alg = crypto_aead_alg(tfm);
-	struct ssi_aead_ctx *ctx = crypto_aead_ctx(tfm);
+	struct cc_aead_ctx *ctx = crypto_aead_ctx(tfm);
 	struct ssi_crypto_alg *ssi_alg =
 			container_of(alg, struct ssi_crypto_alg, aead_alg);
 	struct device *dev = drvdata_to_dev(ssi_alg->drvdata);
@@ -222,16 +222,16 @@ static int ssi_aead_init(struct crypto_aead *tfm)
 	return 0;
 
 init_failed:
-	ssi_aead_exit(tfm);
+	cc_aead_exit(tfm);
 	return -ENOMEM;
 }
 
-static void ssi_aead_complete(struct device *dev, void *ssi_req)
+static void cc_aead_complete(struct device *dev, void *ssi_req)
 {
 	struct aead_request *areq = (struct aead_request *)ssi_req;
 	struct aead_req_ctx *areq_ctx = aead_request_ctx(areq);
 	struct crypto_aead *tfm = crypto_aead_reqtfm(ssi_req);
-	struct ssi_aead_ctx *ctx = crypto_aead_ctx(tfm);
+	struct cc_aead_ctx *ctx = crypto_aead_ctx(tfm);
 	int err = 0;
 
 	cc_unmap_aead_request(dev, areq);
@@ -277,7 +277,7 @@ static void ssi_aead_complete(struct device *dev, void *ssi_req)
 	aead_request_complete(areq, err);
 }
 
-static int xcbc_setkey(struct cc_hw_desc *desc, struct ssi_aead_ctx *ctx)
+static int xcbc_setkey(struct cc_hw_desc *desc, struct cc_aead_ctx *ctx)
 {
 	/* Load the AES key */
 	hw_desc_init(&desc[0]);
@@ -317,7 +317,7 @@ static int xcbc_setkey(struct cc_hw_desc *desc, struct ssi_aead_ctx *ctx)
 	return 4;
 }
 
-static int hmac_setkey(struct cc_hw_desc *desc, struct ssi_aead_ctx *ctx)
+static int hmac_setkey(struct cc_hw_desc *desc, struct cc_aead_ctx *ctx)
 {
 	unsigned int hmac_pad_const[2] = { HMAC_IPAD_CONST, HMAC_OPAD_CONST };
 	unsigned int digest_ofs = 0;
@@ -386,7 +386,7 @@ static int hmac_setkey(struct cc_hw_desc *desc, struct ssi_aead_ctx *ctx)
 	return idx;
 }
 
-static int validate_keys_sizes(struct ssi_aead_ctx *ctx)
+static int validate_keys_sizes(struct cc_aead_ctx *ctx)
 {
 	struct device *dev = drvdata_to_dev(ctx->drvdata);
 
@@ -435,11 +435,11 @@ static int validate_keys_sizes(struct ssi_aead_ctx *ctx)
  * (copy to intenral buffer or hash in case of key longer than block
  */
 static int
-ssi_get_plain_hmac_key(struct crypto_aead *tfm, const u8 *key,
-		       unsigned int keylen)
+cc_get_plain_hmac_key(struct crypto_aead *tfm, const u8 *key,
+		      unsigned int keylen)
 {
 	dma_addr_t key_dma_addr = 0;
-	struct ssi_aead_ctx *ctx = crypto_aead_ctx(tfm);
+	struct cc_aead_ctx *ctx = crypto_aead_ctx(tfm);
 	struct device *dev = drvdata_to_dev(ctx->drvdata);
 	u32 larval_addr = cc_larval_digest_addr(ctx->drvdata, ctx->auth_mode);
 	struct ssi_crypto_req ssi_req = {};
@@ -557,9 +557,9 @@ ssi_get_plain_hmac_key(struct crypto_aead *tfm, const u8 *key,
 }
 
 static int
-ssi_aead_setkey(struct crypto_aead *tfm, const u8 *key, unsigned int keylen)
+cc_aead_setkey(struct crypto_aead *tfm, const u8 *key, unsigned int keylen)
 {
-	struct ssi_aead_ctx *ctx = crypto_aead_ctx(tfm);
+	struct cc_aead_ctx *ctx = crypto_aead_ctx(tfm);
 	struct rtattr *rta = (struct rtattr *)key;
 	struct ssi_crypto_req ssi_req = {};
 	struct crypto_authenc_key_param *param;
@@ -619,7 +619,7 @@ ssi_aead_setkey(struct crypto_aead *tfm, const u8 *key, unsigned int keylen)
 	if (ctx->auth_mode == DRV_HASH_XCBC_MAC) {
 		memcpy(ctx->auth_state.xcbc.xcbc_keys, key, ctx->auth_keylen);
 	} else if (ctx->auth_mode != DRV_HASH_NULL) { /* HMAC */
-		rc = ssi_get_plain_hmac_key(tfm, key, ctx->auth_keylen);
+		rc = cc_get_plain_hmac_key(tfm, key, ctx->auth_keylen);
 		if (rc)
 			goto badkey;
 	}
@@ -663,10 +663,10 @@ ssi_aead_setkey(struct crypto_aead *tfm, const u8 *key, unsigned int keylen)
 }
 
 #if SSI_CC_HAS_AES_CCM
-static int ssi_rfc4309_ccm_setkey(struct crypto_aead *tfm, const u8 *key,
-				  unsigned int keylen)
+static int cc_rfc4309_ccm_setkey(struct crypto_aead *tfm, const u8 *key,
+				 unsigned int keylen)
 {
-	struct ssi_aead_ctx *ctx = crypto_aead_ctx(tfm);
+	struct cc_aead_ctx *ctx = crypto_aead_ctx(tfm);
 
 	if (keylen < 3)
 		return -EINVAL;
@@ -674,15 +674,15 @@ static int ssi_rfc4309_ccm_setkey(struct crypto_aead *tfm, const u8 *key,
 	keylen -= 3;
 	memcpy(ctx->ctr_nonce, key + keylen, 3);
 
-	return ssi_aead_setkey(tfm, key, keylen);
+	return cc_aead_setkey(tfm, key, keylen);
 }
 #endif /*SSI_CC_HAS_AES_CCM*/
 
-static int ssi_aead_setauthsize(
+static int cc_aead_setauthsize(
 	struct crypto_aead *authenc,
 	unsigned int authsize)
 {
-	struct ssi_aead_ctx *ctx = crypto_aead_ctx(authenc);
+	struct cc_aead_ctx *ctx = crypto_aead_ctx(authenc);
 	struct device *dev = drvdata_to_dev(ctx->drvdata);
 
 	/* Unsupported auth. sizes */
@@ -698,8 +698,8 @@ static int ssi_aead_setauthsize(
 }
 
 #if SSI_CC_HAS_AES_CCM
-static int ssi_rfc4309_ccm_setauthsize(struct crypto_aead *authenc,
-				       unsigned int authsize)
+static int cc_rfc4309_ccm_setauthsize(struct crypto_aead *authenc,
+				      unsigned int authsize)
 {
 	switch (authsize) {
 	case 8:
@@ -710,11 +710,11 @@ static int ssi_rfc4309_ccm_setauthsize(struct crypto_aead *authenc,
 		return -EINVAL;
 	}
 
-	return ssi_aead_setauthsize(authenc, authsize);
+	return cc_aead_setauthsize(authenc, authsize);
 }
 
-static int ssi_ccm_setauthsize(struct crypto_aead *authenc,
-			       unsigned int authsize)
+static int cc_ccm_setauthsize(struct crypto_aead *authenc,
+			      unsigned int authsize)
 {
 	switch (authsize) {
 	case 4:
@@ -729,19 +729,19 @@ static int ssi_ccm_setauthsize(struct crypto_aead *authenc,
 		return -EINVAL;
 	}
 
-	return ssi_aead_setauthsize(authenc, authsize);
+	return cc_aead_setauthsize(authenc, authsize);
 }
 #endif /*SSI_CC_HAS_AES_CCM*/
 
 static void
-ssi_aead_create_assoc_desc(
+cc_set_assoc_desc(
 	struct aead_request *areq,
 	unsigned int flow_mode,
 	struct cc_hw_desc desc[],
 	unsigned int *seq_size)
 {
 	struct crypto_aead *tfm = crypto_aead_reqtfm(areq);
-	struct ssi_aead_ctx *ctx = crypto_aead_ctx(tfm);
+	struct cc_aead_ctx *ctx = crypto_aead_ctx(tfm);
 	struct aead_req_ctx *areq_ctx = aead_request_ctx(areq);
 	enum ssi_req_dma_buf_type assoc_dma_type = areq_ctx->assoc_buff_type;
 	unsigned int idx = *seq_size;
@@ -777,7 +777,7 @@ ssi_aead_create_assoc_desc(
 }
 
 static void
-ssi_aead_process_authenc_data_desc(
+cc_proc_authen_desc(
 	struct aead_request *areq,
 	unsigned int flow_mode,
 	struct cc_hw_desc desc[],
@@ -788,7 +788,7 @@ ssi_aead_process_authenc_data_desc(
 	enum ssi_req_dma_buf_type data_dma_type = areq_ctx->data_buff_type;
 	unsigned int idx = *seq_size;
 	struct crypto_aead *tfm = crypto_aead_reqtfm(areq);
-	struct ssi_aead_ctx *ctx = crypto_aead_ctx(tfm);
+	struct cc_aead_ctx *ctx = crypto_aead_ctx(tfm);
 	struct device *dev = drvdata_to_dev(ctx->drvdata);
 
 	switch (data_dma_type) {
@@ -844,7 +844,7 @@ ssi_aead_process_authenc_data_desc(
 }
 
 static void
-ssi_aead_process_cipher_data_desc(
+cc_proc_cipher_desc(
 	struct aead_request *areq,
 	unsigned int flow_mode,
 	struct cc_hw_desc desc[],
@@ -854,7 +854,7 @@ ssi_aead_process_cipher_data_desc(
 	struct aead_req_ctx *areq_ctx = aead_request_ctx(areq);
 	enum ssi_req_dma_buf_type data_dma_type = areq_ctx->data_buff_type;
 	struct crypto_aead *tfm = crypto_aead_reqtfm(areq);
-	struct ssi_aead_ctx *ctx = crypto_aead_ctx(tfm);
+	struct cc_aead_ctx *ctx = crypto_aead_ctx(tfm);
 	struct device *dev = drvdata_to_dev(ctx->drvdata);
 
 	if (areq_ctx->cryptlen == 0)
@@ -891,13 +891,13 @@ ssi_aead_process_cipher_data_desc(
 	*seq_size = (++idx);
 }
 
-static void ssi_aead_process_digest_result_desc(
+static void cc_proc_digest_desc(
 	struct aead_request *req,
 	struct cc_hw_desc desc[],
 	unsigned int *seq_size)
 {
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
-	struct ssi_aead_ctx *ctx = crypto_aead_ctx(tfm);
+	struct cc_aead_ctx *ctx = crypto_aead_ctx(tfm);
 	struct aead_req_ctx *req_ctx = aead_request_ctx(req);
 	unsigned int idx = *seq_size;
 	unsigned int hash_mode = (ctx->auth_mode == DRV_HASH_SHA1) ?
@@ -942,13 +942,13 @@ static void ssi_aead_process_digest_result_desc(
 	*seq_size = (++idx);
 }
 
-static void ssi_aead_setup_cipher_desc(
+static void cc_set_cipher_desc(
 	struct aead_request *req,
 	struct cc_hw_desc desc[],
 	unsigned int *seq_size)
 {
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
-	struct ssi_aead_ctx *ctx = crypto_aead_ctx(tfm);
+	struct cc_aead_ctx *ctx = crypto_aead_ctx(tfm);
 	struct aead_req_ctx *req_ctx = aead_request_ctx(req);
 	unsigned int hw_iv_size = req_ctx->hw_iv_size;
 	unsigned int idx = *seq_size;
@@ -988,7 +988,7 @@ static void ssi_aead_setup_cipher_desc(
 	*seq_size = idx;
 }
 
-static void ssi_aead_process_cipher(
+static void cc_proc_cipher(
 	struct aead_request *req,
 	struct cc_hw_desc desc[],
 	unsigned int *seq_size,
@@ -1001,8 +1001,8 @@ static void ssi_aead_process_cipher(
 	if (req_ctx->cryptlen == 0)
 		return; /*null processing*/
 
-	ssi_aead_setup_cipher_desc(req, desc, &idx);
-	ssi_aead_process_cipher_data_desc(req, data_flow_mode, desc, &idx);
+	cc_set_cipher_desc(req, desc, &idx);
+	cc_proc_cipher_desc(req, data_flow_mode, desc, &idx);
 	if (direct == DRV_CRYPTO_DIRECTION_ENCRYPT) {
 		/* We must wait for DMA to write all cipher */
 		hw_desc_init(&desc[idx]);
@@ -1014,13 +1014,13 @@ static void ssi_aead_process_cipher(
 	*seq_size = idx;
 }
 
-static void ssi_aead_hmac_setup_digest_desc(
+static void cc_set_hmac_desc(
 	struct aead_request *req,
 	struct cc_hw_desc desc[],
 	unsigned int *seq_size)
 {
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
-	struct ssi_aead_ctx *ctx = crypto_aead_ctx(tfm);
+	struct cc_aead_ctx *ctx = crypto_aead_ctx(tfm);
 	unsigned int hash_mode = (ctx->auth_mode == DRV_HASH_SHA1) ?
 				DRV_HASH_HW_SHA1 : DRV_HASH_HW_SHA256;
 	unsigned int digest_size = (ctx->auth_mode == DRV_HASH_SHA1) ?
@@ -1051,13 +1051,13 @@ static void ssi_aead_hmac_setup_digest_desc(
 	*seq_size = idx;
 }
 
-static void ssi_aead_xcbc_setup_digest_desc(
+static void cc_set_xcbc_desc(
 	struct aead_request *req,
 	struct cc_hw_desc desc[],
 	unsigned int *seq_size)
 {
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
-	struct ssi_aead_ctx *ctx = crypto_aead_ctx(tfm);
+	struct cc_aead_ctx *ctx = crypto_aead_ctx(tfm);
 	unsigned int idx = *seq_size;
 
 	/* Loading MAC state */
@@ -1113,7 +1113,7 @@ static void ssi_aead_xcbc_setup_digest_desc(
 	*seq_size = idx;
 }
 
-static void ssi_aead_process_digest_header_desc(
+static void cc_proc_header_desc(
 	struct aead_request *req,
 	struct cc_hw_desc desc[],
 	unsigned int *seq_size)
@@ -1121,20 +1121,20 @@ static void ssi_aead_process_digest_header_desc(
 	unsigned int idx = *seq_size;
 	/* Hash associated data */
 	if (req->assoclen > 0)
-		ssi_aead_create_assoc_desc(req, DIN_HASH, desc, &idx);
+		cc_set_assoc_desc(req, DIN_HASH, desc, &idx);
 
 	/* Hash IV */
 	*seq_size = idx;
 }
 
-static void ssi_aead_process_digest_scheme_desc(
+static void cc_proc_scheme_desc(
 	struct aead_request *req,
 	struct cc_hw_desc desc[],
 	unsigned int *seq_size)
 {
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
-	struct ssi_aead_ctx *ctx = crypto_aead_ctx(tfm);
-	struct ssi_aead_handle *aead_handle = ctx->drvdata->aead_handle;
+	struct cc_aead_ctx *ctx = crypto_aead_ctx(tfm);
+	struct cc_aead_handle *aead_handle = ctx->drvdata->aead_handle;
 	unsigned int hash_mode = (ctx->auth_mode == DRV_HASH_SHA1) ?
 				DRV_HASH_HW_SHA1 : DRV_HASH_HW_SHA256;
 	unsigned int digest_size = (ctx->auth_mode == DRV_HASH_SHA1) ?
@@ -1192,14 +1192,14 @@ static void ssi_aead_process_digest_scheme_desc(
 	*seq_size = idx;
 }
 
-static void ssi_aead_load_mlli_to_sram(
+static void cc_mlli_to_sram(
 	struct aead_request *req,
 	struct cc_hw_desc desc[],
 	unsigned int *seq_size)
 {
 	struct aead_req_ctx *req_ctx = aead_request_ctx(req);
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
-	struct ssi_aead_ctx *ctx = crypto_aead_ctx(tfm);
+	struct cc_aead_ctx *ctx = crypto_aead_ctx(tfm);
 	struct device *dev = drvdata_to_dev(ctx->drvdata);
 
 	if (req_ctx->assoc_buff_type == SSI_DMA_BUF_MLLI ||
@@ -1221,7 +1221,7 @@ static void ssi_aead_load_mlli_to_sram(
 	}
 }
 
-static enum cc_flow_mode ssi_aead_get_data_flow_mode(
+static enum cc_flow_mode cc_get_data_flow(
 	enum drv_crypto_direction direct,
 	enum cc_flow_mode setup_flow_mode,
 	bool is_single_pass)
@@ -1247,29 +1247,28 @@ static enum cc_flow_mode ssi_aead_get_data_flow_mode(
 	return data_flow_mode;
 }
 
-static void ssi_aead_hmac_authenc(
+static void cc_hmac_authenc(
 	struct aead_request *req,
 	struct cc_hw_desc desc[],
 	unsigned int *seq_size)
 {
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
-	struct ssi_aead_ctx *ctx = crypto_aead_ctx(tfm);
+	struct cc_aead_ctx *ctx = crypto_aead_ctx(tfm);
 	struct aead_req_ctx *req_ctx = aead_request_ctx(req);
 	int direct = req_ctx->gen_ctx.op_type;
-	unsigned int data_flow_mode = ssi_aead_get_data_flow_mode(
+	unsigned int data_flow_mode = cc_get_data_flow(
 		direct, ctx->flow_mode, req_ctx->is_single_pass);
 
 	if (req_ctx->is_single_pass) {
 		/**
 		 * Single-pass flow
 		 */
-		ssi_aead_hmac_setup_digest_desc(req, desc, seq_size);
-		ssi_aead_setup_cipher_desc(req, desc, seq_size);
-		ssi_aead_process_digest_header_desc(req, desc, seq_size);
-		ssi_aead_process_cipher_data_desc(req, data_flow_mode, desc,
-						  seq_size);
-		ssi_aead_process_digest_scheme_desc(req, desc, seq_size);
-		ssi_aead_process_digest_result_desc(req, desc, seq_size);
+		cc_set_hmac_desc(req, desc, seq_size);
+		cc_set_cipher_desc(req, desc, seq_size);
+		cc_proc_header_desc(req, desc, seq_size);
+		cc_proc_cipher_desc(req, data_flow_mode, desc, seq_size);
+		cc_proc_scheme_desc(req, desc, seq_size);
+		cc_proc_digest_desc(req, desc, seq_size);
 		return;
 	}
 
@@ -1280,52 +1279,49 @@ static void ssi_aead_hmac_authenc(
 	 */
 	if (direct == DRV_CRYPTO_DIRECTION_ENCRYPT) {
 		/* encrypt first.. */
-		ssi_aead_process_cipher(req, desc, seq_size, data_flow_mode);
+		cc_proc_cipher(req, desc, seq_size, data_flow_mode);
 		/* authenc after..*/
-		ssi_aead_hmac_setup_digest_desc(req, desc, seq_size);
-		ssi_aead_process_authenc_data_desc(req, DIN_HASH, desc,
-						   seq_size, direct);
-		ssi_aead_process_digest_scheme_desc(req, desc, seq_size);
-		ssi_aead_process_digest_result_desc(req, desc, seq_size);
+		cc_set_hmac_desc(req, desc, seq_size);
+		cc_proc_authen_desc(req, DIN_HASH, desc, seq_size, direct);
+		cc_proc_scheme_desc(req, desc, seq_size);
+		cc_proc_digest_desc(req, desc, seq_size);
 
 	} else { /*DECRYPT*/
 		/* authenc first..*/
-		ssi_aead_hmac_setup_digest_desc(req, desc, seq_size);
-		ssi_aead_process_authenc_data_desc(req, DIN_HASH, desc,
-						   seq_size, direct);
-		ssi_aead_process_digest_scheme_desc(req, desc, seq_size);
+		cc_set_hmac_desc(req, desc, seq_size);
+		cc_proc_authen_desc(req, DIN_HASH, desc, seq_size, direct);
+		cc_proc_scheme_desc(req, desc, seq_size);
 		/* decrypt after.. */
-		ssi_aead_process_cipher(req, desc, seq_size, data_flow_mode);
+		cc_proc_cipher(req, desc, seq_size, data_flow_mode);
 		/* read the digest result with setting the completion bit
 		 * must be after the cipher operation
 		 */
-		ssi_aead_process_digest_result_desc(req, desc, seq_size);
+		cc_proc_digest_desc(req, desc, seq_size);
 	}
 }
 
 static void
-ssi_aead_xcbc_authenc(
+cc_xcbc_authenc(
 	struct aead_request *req,
 	struct cc_hw_desc desc[],
 	unsigned int *seq_size)
 {
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
-	struct ssi_aead_ctx *ctx = crypto_aead_ctx(tfm);
+	struct cc_aead_ctx *ctx = crypto_aead_ctx(tfm);
 	struct aead_req_ctx *req_ctx = aead_request_ctx(req);
 	int direct = req_ctx->gen_ctx.op_type;
-	unsigned int data_flow_mode = ssi_aead_get_data_flow_mode(
+	unsigned int data_flow_mode = cc_get_data_flow(
 		direct, ctx->flow_mode, req_ctx->is_single_pass);
 
 	if (req_ctx->is_single_pass) {
 		/**
 		 * Single-pass flow
 		 */
-		ssi_aead_xcbc_setup_digest_desc(req, desc, seq_size);
-		ssi_aead_setup_cipher_desc(req, desc, seq_size);
-		ssi_aead_process_digest_header_desc(req, desc, seq_size);
-		ssi_aead_process_cipher_data_desc(req, data_flow_mode, desc,
-						  seq_size);
-		ssi_aead_process_digest_result_desc(req, desc, seq_size);
+		cc_set_xcbc_desc(req, desc, seq_size);
+		cc_set_cipher_desc(req, desc, seq_size);
+		cc_proc_header_desc(req, desc, seq_size);
+		cc_proc_cipher_desc(req, data_flow_mode, desc, seq_size);
+		cc_proc_digest_desc(req, desc, seq_size);
 		return;
 	}
 
@@ -1336,27 +1332,25 @@ ssi_aead_xcbc_authenc(
 	 */
 	if (direct == DRV_CRYPTO_DIRECTION_ENCRYPT) {
 		/* encrypt first.. */
-		ssi_aead_process_cipher(req, desc, seq_size, data_flow_mode);
+		cc_proc_cipher(req, desc, seq_size, data_flow_mode);
 		/* authenc after.. */
-		ssi_aead_xcbc_setup_digest_desc(req, desc, seq_size);
-		ssi_aead_process_authenc_data_desc(req, DIN_HASH, desc,
-						   seq_size, direct);
-		ssi_aead_process_digest_result_desc(req, desc, seq_size);
+		cc_set_xcbc_desc(req, desc, seq_size);
+		cc_proc_authen_desc(req, DIN_HASH, desc, seq_size, direct);
+		cc_proc_digest_desc(req, desc, seq_size);
 	} else { /*DECRYPT*/
 		/* authenc first.. */
-		ssi_aead_xcbc_setup_digest_desc(req, desc, seq_size);
-		ssi_aead_process_authenc_data_desc(req, DIN_HASH, desc,
-						   seq_size, direct);
+		cc_set_xcbc_desc(req, desc, seq_size);
+		cc_proc_authen_desc(req, DIN_HASH, desc, seq_size, direct);
 		/* decrypt after..*/
-		ssi_aead_process_cipher(req, desc, seq_size, data_flow_mode);
+		cc_proc_cipher(req, desc, seq_size, data_flow_mode);
 		/* read the digest result with setting the completion bit
 		 * must be after the cipher operation
 		 */
-		ssi_aead_process_digest_result_desc(req, desc, seq_size);
+		cc_proc_digest_desc(req, desc, seq_size);
 	}
 }
 
-static int validate_data_size(struct ssi_aead_ctx *ctx,
+static int validate_data_size(struct cc_aead_ctx *ctx,
 			      enum drv_crypto_direction direct,
 			      struct aead_request *req)
 {
@@ -1455,13 +1449,13 @@ static int set_msg_len(u8 *block, unsigned int msglen, unsigned int csize)
 	return 0;
 }
 
-static int ssi_aead_ccm(
+static int cc_ccm(
 	struct aead_request *req,
 	struct cc_hw_desc desc[],
 	unsigned int *seq_size)
 {
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
-	struct ssi_aead_ctx *ctx = crypto_aead_ctx(tfm);
+	struct cc_aead_ctx *ctx = crypto_aead_ctx(tfm);
 	struct aead_req_ctx *req_ctx = aead_request_ctx(req);
 	unsigned int idx = *seq_size;
 	unsigned int cipher_flow_mode;
@@ -1525,7 +1519,7 @@ static int ssi_aead_ccm(
 
 	/* process assoc data */
 	if (req->assoclen > 0) {
-		ssi_aead_create_assoc_desc(req, DIN_HASH, desc, &idx);
+		cc_set_assoc_desc(req, DIN_HASH, desc, &idx);
 	} else {
 		hw_desc_init(&desc[idx]);
 		set_din_type(&desc[idx], DMA_DLLI,
@@ -1537,8 +1531,7 @@ static int ssi_aead_ccm(
 
 	/* process the cipher */
 	if (req_ctx->cryptlen)
-		ssi_aead_process_cipher_data_desc(req, cipher_flow_mode, desc,
-						  &idx);
+		cc_proc_cipher_desc(req, cipher_flow_mode, desc, &idx);
 
 	/* Read temporal MAC */
 	hw_desc_init(&desc[idx]);
@@ -1583,7 +1576,7 @@ static int ssi_aead_ccm(
 static int config_ccm_adata(struct aead_request *req)
 {
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
-	struct ssi_aead_ctx *ctx = crypto_aead_ctx(tfm);
+	struct cc_aead_ctx *ctx = crypto_aead_ctx(tfm);
 	struct device *dev = drvdata_to_dev(ctx->drvdata);
 	struct aead_req_ctx *req_ctx = aead_request_ctx(req);
 	//unsigned int size_of_a = 0, rem_a_size = 0;
@@ -1639,10 +1632,10 @@ static int config_ccm_adata(struct aead_request *req)
 	return 0;
 }
 
-static void ssi_rfc4309_ccm_process(struct aead_request *req)
+static void cc_proc_rfc4309_ccm(struct aead_request *req)
 {
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
-	struct ssi_aead_ctx *ctx = crypto_aead_ctx(tfm);
+	struct cc_aead_ctx *ctx = crypto_aead_ctx(tfm);
 	struct aead_req_ctx *areq_ctx = aead_request_ctx(req);
 
 	/* L' */
@@ -1666,13 +1659,13 @@ static void ssi_rfc4309_ccm_process(struct aead_request *req)
 
 #if SSI_CC_HAS_AES_GCM
 
-static void ssi_aead_gcm_setup_ghash_desc(
+static void cc_set_ghash_desc(
 	struct aead_request *req,
 	struct cc_hw_desc desc[],
 	unsigned int *seq_size)
 {
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
-	struct ssi_aead_ctx *ctx = crypto_aead_ctx(tfm);
+	struct cc_aead_ctx *ctx = crypto_aead_ctx(tfm);
 	struct aead_req_ctx *req_ctx = aead_request_ctx(req);
 	unsigned int idx = *seq_size;
 
@@ -1746,13 +1739,13 @@ static void ssi_aead_gcm_setup_ghash_desc(
 	*seq_size = idx;
 }
 
-static void ssi_aead_gcm_setup_gctr_desc(
+static void cc_set_gctr_desc(
 	struct aead_request *req,
 	struct cc_hw_desc desc[],
 	unsigned int *seq_size)
 {
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
-	struct ssi_aead_ctx *ctx = crypto_aead_ctx(tfm);
+	struct cc_aead_ctx *ctx = crypto_aead_ctx(tfm);
 	struct aead_req_ctx *req_ctx = aead_request_ctx(req);
 	unsigned int idx = *seq_size;
 
@@ -1784,13 +1777,13 @@ static void ssi_aead_gcm_setup_gctr_desc(
 	*seq_size = idx;
 }
 
-static void ssi_aead_process_gcm_result_desc(
+static void cc_proc_gcm_result(
 	struct aead_request *req,
 	struct cc_hw_desc desc[],
 	unsigned int *seq_size)
 {
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
-	struct ssi_aead_ctx *ctx = crypto_aead_ctx(tfm);
+	struct cc_aead_ctx *ctx = crypto_aead_ctx(tfm);
 	struct aead_req_ctx *req_ctx = aead_request_ctx(req);
 	dma_addr_t mac_result;
 	unsigned int idx = *seq_size;
@@ -1850,7 +1843,7 @@ static void ssi_aead_process_gcm_result_desc(
 	*seq_size = idx;
 }
 
-static int ssi_aead_gcm(
+static int cc_gcm(
 	struct aead_request *req,
 	struct cc_hw_desc desc[],
 	unsigned int *seq_size)
@@ -1866,37 +1859,36 @@ static int ssi_aead_gcm(
 
 	//in RFC4543 no data to encrypt. just copy data from src to dest.
 	if (req_ctx->plaintext_authenticate_only) {
-		ssi_aead_process_cipher_data_desc(req, BYPASS, desc, seq_size);
-		ssi_aead_gcm_setup_ghash_desc(req, desc, seq_size);
+		cc_proc_cipher_desc(req, BYPASS, desc, seq_size);
+		cc_set_ghash_desc(req, desc, seq_size);
 		/* process(ghash) assoc data */
-		ssi_aead_create_assoc_desc(req, DIN_HASH, desc, seq_size);
-		ssi_aead_gcm_setup_gctr_desc(req, desc, seq_size);
-		ssi_aead_process_gcm_result_desc(req, desc, seq_size);
+		cc_set_assoc_desc(req, DIN_HASH, desc, seq_size);
+		cc_set_gctr_desc(req, desc, seq_size);
+		cc_proc_gcm_result(req, desc, seq_size);
 		return 0;
 	}
 
 	// for gcm and rfc4106.
-	ssi_aead_gcm_setup_ghash_desc(req, desc, seq_size);
+	cc_set_ghash_desc(req, desc, seq_size);
 	/* process(ghash) assoc data */
 	if (req->assoclen > 0)
-		ssi_aead_create_assoc_desc(req, DIN_HASH, desc, seq_size);
-	ssi_aead_gcm_setup_gctr_desc(req, desc, seq_size);
+		cc_set_assoc_desc(req, DIN_HASH, desc, seq_size);
+	cc_set_gctr_desc(req, desc, seq_size);
 	/* process(gctr+ghash) */
 	if (req_ctx->cryptlen)
-		ssi_aead_process_cipher_data_desc(req, cipher_flow_mode, desc,
-						  seq_size);
-	ssi_aead_process_gcm_result_desc(req, desc, seq_size);
+		cc_proc_cipher_desc(req, cipher_flow_mode, desc, seq_size);
+	cc_proc_gcm_result(req, desc, seq_size);
 
 	return 0;
 }
 
 #ifdef CC_DEBUG
-static void ssi_aead_dump_gcm(
+static void cc_dump_gcm(
 	const char *title,
 	struct aead_request *req)
 {
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
-	struct ssi_aead_ctx *ctx = crypto_aead_ctx(tfm);
+	struct cc_aead_ctx *ctx = crypto_aead_ctx(tfm);
 	struct aead_req_ctx *req_ctx = aead_request_ctx(req);
 
 	if (ctx->cipher_mode != DRV_CIPHER_GCTR)
@@ -1940,7 +1932,7 @@ static void ssi_aead_dump_gcm(
 static int config_gcm_context(struct aead_request *req)
 {
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
-	struct ssi_aead_ctx *ctx = crypto_aead_ctx(tfm);
+	struct cc_aead_ctx *ctx = crypto_aead_ctx(tfm);
 	struct aead_req_ctx *req_ctx = aead_request_ctx(req);
 	struct device *dev = drvdata_to_dev(ctx->drvdata);
 
@@ -1987,10 +1979,10 @@ static int config_gcm_context(struct aead_request *req)
 	return 0;
 }
 
-static void ssi_rfc4_gcm_process(struct aead_request *req)
+static void cc_proc_rfc4_gcm(struct aead_request *req)
 {
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
-	struct ssi_aead_ctx *ctx = crypto_aead_ctx(tfm);
+	struct cc_aead_ctx *ctx = crypto_aead_ctx(tfm);
 	struct aead_req_ctx *areq_ctx = aead_request_ctx(req);
 
 	memcpy(areq_ctx->ctr_iv + GCM_BLOCK_RFC4_NONCE_OFFSET,
@@ -2003,14 +1995,14 @@ static void ssi_rfc4_gcm_process(struct aead_request *req)
 
 #endif /*SSI_CC_HAS_AES_GCM*/
 
-static int ssi_aead_process(struct aead_request *req,
-			    enum drv_crypto_direction direct)
+static int cc_proc_aead(struct aead_request *req,
+			enum drv_crypto_direction direct)
 {
 	int rc = 0;
 	int seq_len = 0;
 	struct cc_hw_desc desc[MAX_AEAD_PROCESS_SEQ];
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
-	struct ssi_aead_ctx *ctx = crypto_aead_ctx(tfm);
+	struct cc_aead_ctx *ctx = crypto_aead_ctx(tfm);
 	struct aead_req_ctx *areq_ctx = aead_request_ctx(req);
 	struct device *dev = drvdata_to_dev(ctx->drvdata);
 	struct ssi_crypto_req ssi_req = {};
@@ -2031,7 +2023,7 @@ static int ssi_aead_process(struct aead_request *req,
 	}
 
 	/* Setup DX request structure */
-	ssi_req.user_cb = (void *)ssi_aead_complete;
+	ssi_req.user_cb = (void *)cc_aead_complete;
 	ssi_req.user_arg = (void *)req;
 
 	/* Setup request context */
@@ -2138,26 +2130,26 @@ static int ssi_aead_process(struct aead_request *req,
 	/* STAT_PHASE_2: Create sequence */
 
 	/* Load MLLI tables to SRAM if necessary */
-	ssi_aead_load_mlli_to_sram(req, desc, &seq_len);
+	cc_mlli_to_sram(req, desc, &seq_len);
 
 	/*TODO: move seq len by reference */
 	switch (ctx->auth_mode) {
 	case DRV_HASH_SHA1:
 	case DRV_HASH_SHA256:
-		ssi_aead_hmac_authenc(req, desc, &seq_len);
+		cc_hmac_authenc(req, desc, &seq_len);
 		break;
 	case DRV_HASH_XCBC_MAC:
-		ssi_aead_xcbc_authenc(req, desc, &seq_len);
+		cc_xcbc_authenc(req, desc, &seq_len);
 		break;
 #if (SSI_CC_HAS_AES_CCM || SSI_CC_HAS_AES_GCM)
 	case DRV_HASH_NULL:
 #if SSI_CC_HAS_AES_CCM
 		if (ctx->cipher_mode == DRV_CIPHER_CCM)
-			ssi_aead_ccm(req, desc, &seq_len);
+			cc_ccm(req, desc, &seq_len);
 #endif /*SSI_CC_HAS_AES_CCM*/
 #if SSI_CC_HAS_AES_GCM
 		if (ctx->cipher_mode == DRV_CIPHER_GCTR)
-			ssi_aead_gcm(req, desc, &seq_len);
+			cc_gcm(req, desc, &seq_len);
 #endif /*SSI_CC_HAS_AES_GCM*/
 		break;
 #endif
@@ -2181,7 +2173,7 @@ static int ssi_aead_process(struct aead_request *req,
 	return rc;
 }
 
-static int ssi_aead_encrypt(struct aead_request *req)
+static int cc_aead_encrypt(struct aead_request *req)
 {
 	struct aead_req_ctx *areq_ctx = aead_request_ctx(req);
 	int rc;
@@ -2193,7 +2185,7 @@ static int ssi_aead_encrypt(struct aead_request *req)
 
 	areq_ctx->plaintext_authenticate_only = false;
 
-	rc = ssi_aead_process(req, DRV_CRYPTO_DIRECTION_ENCRYPT);
+	rc = cc_proc_aead(req, DRV_CRYPTO_DIRECTION_ENCRYPT);
 	if (rc != -EINPROGRESS)
 		req->iv = areq_ctx->backup_iv;
 
@@ -2201,13 +2193,13 @@ static int ssi_aead_encrypt(struct aead_request *req)
 }
 
 #if SSI_CC_HAS_AES_CCM
-static int ssi_rfc4309_ccm_encrypt(struct aead_request *req)
+static int cc_rfc4309_ccm_encrypt(struct aead_request *req)
 {
-	/* Very similar to ssi_aead_encrypt() above. */
+	/* Very similar to cc_aead_encrypt() above. */
 
 	struct aead_req_ctx *areq_ctx = aead_request_ctx(req);
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
-	struct ssi_aead_ctx *ctx = crypto_aead_ctx(tfm);
+	struct cc_aead_ctx *ctx = crypto_aead_ctx(tfm);
 	struct device *dev = drvdata_to_dev(ctx->drvdata);
 	int rc = -EINVAL;
 
@@ -2221,9 +2213,9 @@ static int ssi_rfc4309_ccm_encrypt(struct aead_request *req)
 	areq_ctx->backup_giv = NULL;
 	areq_ctx->is_gcm4543 = true;
 
-	ssi_rfc4309_ccm_process(req);
+	cc_proc_rfc4309_ccm(req);
 
-	rc = ssi_aead_process(req, DRV_CRYPTO_DIRECTION_ENCRYPT);
+	rc = cc_proc_aead(req, DRV_CRYPTO_DIRECTION_ENCRYPT);
 	if (rc != -EINPROGRESS)
 		req->iv = areq_ctx->backup_iv;
 out:
@@ -2231,7 +2223,7 @@ static int ssi_rfc4309_ccm_encrypt(struct aead_request *req)
 }
 #endif /* SSI_CC_HAS_AES_CCM */
 
-static int ssi_aead_decrypt(struct aead_request *req)
+static int cc_aead_decrypt(struct aead_request *req)
 {
 	struct aead_req_ctx *areq_ctx = aead_request_ctx(req);
 	int rc;
@@ -2243,7 +2235,7 @@ static int ssi_aead_decrypt(struct aead_request *req)
 
 	areq_ctx->plaintext_authenticate_only = false;
 
-	rc = ssi_aead_process(req, DRV_CRYPTO_DIRECTION_DECRYPT);
+	rc = cc_proc_aead(req, DRV_CRYPTO_DIRECTION_DECRYPT);
 	if (rc != -EINPROGRESS)
 		req->iv = areq_ctx->backup_iv;
 
@@ -2251,10 +2243,10 @@ static int ssi_aead_decrypt(struct aead_request *req)
 }
 
 #if SSI_CC_HAS_AES_CCM
-static int ssi_rfc4309_ccm_decrypt(struct aead_request *req)
+static int cc_rfc4309_ccm_decrypt(struct aead_request *req)
 {
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
-	struct ssi_aead_ctx *ctx = crypto_aead_ctx(tfm);
+	struct cc_aead_ctx *ctx = crypto_aead_ctx(tfm);
 	struct device *dev = drvdata_to_dev(ctx->drvdata);
 	struct aead_req_ctx *areq_ctx = aead_request_ctx(req);
 	int rc = -EINVAL;
@@ -2269,9 +2261,9 @@ static int ssi_rfc4309_ccm_decrypt(struct aead_request *req)
 	areq_ctx->backup_giv = NULL;
 
 	areq_ctx->is_gcm4543 = true;
-	ssi_rfc4309_ccm_process(req);
+	cc_proc_rfc4309_ccm(req);
 
-	rc = ssi_aead_process(req, DRV_CRYPTO_DIRECTION_DECRYPT);
+	rc = cc_proc_aead(req, DRV_CRYPTO_DIRECTION_DECRYPT);
 	if (rc != -EINPROGRESS)
 		req->iv = areq_ctx->backup_iv;
 
@@ -2282,10 +2274,10 @@ static int ssi_rfc4309_ccm_decrypt(struct aead_request *req)
 
 #if SSI_CC_HAS_AES_GCM
 
-static int ssi_rfc4106_gcm_setkey(struct crypto_aead *tfm, const u8 *key,
-				  unsigned int keylen)
+static int cc_rfc4106_gcm_setkey(struct crypto_aead *tfm, const u8 *key,
+				 unsigned int keylen)
 {
-	struct ssi_aead_ctx *ctx = crypto_aead_ctx(tfm);
+	struct cc_aead_ctx *ctx = crypto_aead_ctx(tfm);
 	struct device *dev = drvdata_to_dev(ctx->drvdata);
 
 	dev_dbg(dev, "%s()  keylen %d, key %p\n", __func__, keylen, key);
@@ -2296,13 +2288,13 @@ static int ssi_rfc4106_gcm_setkey(struct crypto_aead *tfm, const u8 *key,
 	keylen -= 4;
 	memcpy(ctx->ctr_nonce, key + keylen, 4);
 
-	return ssi_aead_setkey(tfm, key, keylen);
+	return cc_aead_setkey(tfm, key, keylen);
 }
 
-static int ssi_rfc4543_gcm_setkey(struct crypto_aead *tfm, const u8 *key,
-				  unsigned int keylen)
+static int cc_rfc4543_gcm_setkey(struct crypto_aead *tfm, const u8 *key,
+				 unsigned int keylen)
 {
-	struct ssi_aead_ctx *ctx = crypto_aead_ctx(tfm);
+	struct cc_aead_ctx *ctx = crypto_aead_ctx(tfm);
 	struct device *dev = drvdata_to_dev(ctx->drvdata);
 
 	dev_dbg(dev, "%s()  keylen %d, key %p\n", __func__, keylen, key);
@@ -2313,11 +2305,11 @@ static int ssi_rfc4543_gcm_setkey(struct crypto_aead *tfm, const u8 *key,
 	keylen -= 4;
 	memcpy(ctx->ctr_nonce, key + keylen, 4);
 
-	return ssi_aead_setkey(tfm, key, keylen);
+	return cc_aead_setkey(tfm, key, keylen);
 }
 
-static int ssi_gcm_setauthsize(struct crypto_aead *authenc,
-			       unsigned int authsize)
+static int cc_gcm_setauthsize(struct crypto_aead *authenc,
+			      unsigned int authsize)
 {
 	switch (authsize) {
 	case 4:
@@ -2332,13 +2324,13 @@ static int ssi_gcm_setauthsize(struct crypto_aead *authenc,
 		return -EINVAL;
 	}
 
-	return ssi_aead_setauthsize(authenc, authsize);
+	return cc_aead_setauthsize(authenc, authsize);
 }
 
-static int ssi_rfc4106_gcm_setauthsize(struct crypto_aead *authenc,
-				       unsigned int authsize)
+static int cc_rfc4106_gcm_setauthsize(struct crypto_aead *authenc,
+				      unsigned int authsize)
 {
-	struct ssi_aead_ctx *ctx = crypto_aead_ctx(authenc);
+	struct cc_aead_ctx *ctx = crypto_aead_ctx(authenc);
 	struct device *dev = drvdata_to_dev(ctx->drvdata);
 
 	dev_dbg(dev, "authsize %d\n", authsize);
@@ -2352,13 +2344,13 @@ static int ssi_rfc4106_gcm_setauthsize(struct crypto_aead *authenc,
 		return -EINVAL;
 	}
 
-	return ssi_aead_setauthsize(authenc, authsize);
+	return cc_aead_setauthsize(authenc, authsize);
 }
 
-static int ssi_rfc4543_gcm_setauthsize(struct crypto_aead *authenc,
-				       unsigned int authsize)
+static int cc_rfc4543_gcm_setauthsize(struct crypto_aead *authenc,
+				      unsigned int authsize)
 {
-	struct ssi_aead_ctx *ctx = crypto_aead_ctx(authenc);
+	struct cc_aead_ctx *ctx = crypto_aead_ctx(authenc);
 	struct device *dev = drvdata_to_dev(ctx->drvdata);
 
 	dev_dbg(dev, "authsize %d\n", authsize);
@@ -2366,15 +2358,15 @@ static int ssi_rfc4543_gcm_setauthsize(struct crypto_aead *authenc,
 	if (authsize != 16)
 		return -EINVAL;
 
-	return ssi_aead_setauthsize(authenc, authsize);
+	return cc_aead_setauthsize(authenc, authsize);
 }
 
-static int ssi_rfc4106_gcm_encrypt(struct aead_request *req)
+static int cc_rfc4106_gcm_encrypt(struct aead_request *req)
 {
-	/* Very similar to ssi_aead_encrypt() above. */
+	/* Very similar to cc_aead_encrypt() above. */
 
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
-	struct ssi_aead_ctx *ctx = crypto_aead_ctx(tfm);
+	struct cc_aead_ctx *ctx = crypto_aead_ctx(tfm);
 	struct device *dev = drvdata_to_dev(ctx->drvdata);
 	struct aead_req_ctx *areq_ctx = aead_request_ctx(req);
 	int rc = -EINVAL;
@@ -2390,19 +2382,19 @@ static int ssi_rfc4106_gcm_encrypt(struct aead_request *req)
 
 	areq_ctx->plaintext_authenticate_only = false;
 
-	ssi_rfc4_gcm_process(req);
+	cc_proc_rfc4_gcm(req);
 	areq_ctx->is_gcm4543 = true;
 
-	rc = ssi_aead_process(req, DRV_CRYPTO_DIRECTION_ENCRYPT);
+	rc = cc_proc_aead(req, DRV_CRYPTO_DIRECTION_ENCRYPT);
 	if (rc != -EINPROGRESS)
 		req->iv = areq_ctx->backup_iv;
 out:
 	return rc;
 }
 
-static int ssi_rfc4543_gcm_encrypt(struct aead_request *req)
+static int cc_rfc4543_gcm_encrypt(struct aead_request *req)
 {
-	/* Very similar to ssi_aead_encrypt() above. */
+	/* Very similar to cc_aead_encrypt() above. */
 
 	struct aead_req_ctx *areq_ctx = aead_request_ctx(req);
 	int rc;
@@ -2414,22 +2406,22 @@ static int ssi_rfc4543_gcm_encrypt(struct aead_request *req)
 	areq_ctx->backup_iv = req->iv;
 	areq_ctx->backup_giv = NULL;
 
-	ssi_rfc4_gcm_process(req);
+	cc_proc_rfc4_gcm(req);
 	areq_ctx->is_gcm4543 = true;
 
-	rc = ssi_aead_process(req, DRV_CRYPTO_DIRECTION_ENCRYPT);
+	rc = cc_proc_aead(req, DRV_CRYPTO_DIRECTION_ENCRYPT);
 	if (rc != -EINPROGRESS)
 		req->iv = areq_ctx->backup_iv;
 
 	return rc;
 }
 
-static int ssi_rfc4106_gcm_decrypt(struct aead_request *req)
+static int cc_rfc4106_gcm_decrypt(struct aead_request *req)
 {
-	/* Very similar to ssi_aead_decrypt() above. */
+	/* Very similar to cc_aead_decrypt() above. */
 
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
-	struct ssi_aead_ctx *ctx = crypto_aead_ctx(tfm);
+	struct cc_aead_ctx *ctx = crypto_aead_ctx(tfm);
 	struct device *dev = drvdata_to_dev(ctx->drvdata);
 	struct aead_req_ctx *areq_ctx = aead_request_ctx(req);
 	int rc = -EINVAL;
@@ -2445,19 +2437,19 @@ static int ssi_rfc4106_gcm_decrypt(struct aead_request *req)
 
 	areq_ctx->plaintext_authenticate_only = false;
 
-	ssi_rfc4_gcm_process(req);
+	cc_proc_rfc4_gcm(req);
 	areq_ctx->is_gcm4543 = true;
 
-	rc = ssi_aead_process(req, DRV_CRYPTO_DIRECTION_DECRYPT);
+	rc = cc_proc_aead(req, DRV_CRYPTO_DIRECTION_DECRYPT);
 	if (rc != -EINPROGRESS)
 		req->iv = areq_ctx->backup_iv;
 out:
 	return rc;
 }
 
-static int ssi_rfc4543_gcm_decrypt(struct aead_request *req)
+static int cc_rfc4543_gcm_decrypt(struct aead_request *req)
 {
-	/* Very similar to ssi_aead_decrypt() above. */
+	/* Very similar to cc_aead_decrypt() above. */
 
 	struct aead_req_ctx *areq_ctx = aead_request_ctx(req);
 	int rc;
@@ -2469,10 +2461,10 @@ static int ssi_rfc4543_gcm_decrypt(struct aead_request *req)
 	areq_ctx->backup_iv = req->iv;
 	areq_ctx->backup_giv = NULL;
 
-	ssi_rfc4_gcm_process(req);
+	cc_proc_rfc4_gcm(req);
 	areq_ctx->is_gcm4543 = true;
 
-	rc = ssi_aead_process(req, DRV_CRYPTO_DIRECTION_DECRYPT);
+	rc = cc_proc_aead(req, DRV_CRYPTO_DIRECTION_DECRYPT);
 	if (rc != -EINPROGRESS)
 		req->iv = areq_ctx->backup_iv;
 
@@ -2488,12 +2480,12 @@ static struct ssi_alg_template aead_algs[] = {
 		.blocksize = AES_BLOCK_SIZE,
 		.type = CRYPTO_ALG_TYPE_AEAD,
 		.template_aead = {
-			.setkey = ssi_aead_setkey,
-			.setauthsize = ssi_aead_setauthsize,
-			.encrypt = ssi_aead_encrypt,
-			.decrypt = ssi_aead_decrypt,
-			.init = ssi_aead_init,
-			.exit = ssi_aead_exit,
+			.setkey = cc_aead_setkey,
+			.setauthsize = cc_aead_setauthsize,
+			.encrypt = cc_aead_encrypt,
+			.decrypt = cc_aead_decrypt,
+			.init = cc_aead_init,
+			.exit = cc_aead_exit,
 			.ivsize = AES_BLOCK_SIZE,
 			.maxauthsize = SHA1_DIGEST_SIZE,
 		},
@@ -2507,12 +2499,12 @@ static struct ssi_alg_template aead_algs[] = {
 		.blocksize = DES3_EDE_BLOCK_SIZE,
 		.type = CRYPTO_ALG_TYPE_AEAD,
 		.template_aead = {
-			.setkey = ssi_aead_setkey,
-			.setauthsize = ssi_aead_setauthsize,
-			.encrypt = ssi_aead_encrypt,
-			.decrypt = ssi_aead_decrypt,
-			.init = ssi_aead_init,
-			.exit = ssi_aead_exit,
+			.setkey = cc_aead_setkey,
+			.setauthsize = cc_aead_setauthsize,
+			.encrypt = cc_aead_encrypt,
+			.decrypt = cc_aead_decrypt,
+			.init = cc_aead_init,
+			.exit = cc_aead_exit,
 			.ivsize = DES3_EDE_BLOCK_SIZE,
 			.maxauthsize = SHA1_DIGEST_SIZE,
 		},
@@ -2526,12 +2518,12 @@ static struct ssi_alg_template aead_algs[] = {
 		.blocksize = AES_BLOCK_SIZE,
 		.type = CRYPTO_ALG_TYPE_AEAD,
 		.template_aead = {
-			.setkey = ssi_aead_setkey,
-			.setauthsize = ssi_aead_setauthsize,
-			.encrypt = ssi_aead_encrypt,
-			.decrypt = ssi_aead_decrypt,
-			.init = ssi_aead_init,
-			.exit = ssi_aead_exit,
+			.setkey = cc_aead_setkey,
+			.setauthsize = cc_aead_setauthsize,
+			.encrypt = cc_aead_encrypt,
+			.decrypt = cc_aead_decrypt,
+			.init = cc_aead_init,
+			.exit = cc_aead_exit,
 			.ivsize = AES_BLOCK_SIZE,
 			.maxauthsize = SHA256_DIGEST_SIZE,
 		},
@@ -2545,12 +2537,12 @@ static struct ssi_alg_template aead_algs[] = {
 		.blocksize = DES3_EDE_BLOCK_SIZE,
 		.type = CRYPTO_ALG_TYPE_AEAD,
 		.template_aead = {
-			.setkey = ssi_aead_setkey,
-			.setauthsize = ssi_aead_setauthsize,
-			.encrypt = ssi_aead_encrypt,
-			.decrypt = ssi_aead_decrypt,
-			.init = ssi_aead_init,
-			.exit = ssi_aead_exit,
+			.setkey = cc_aead_setkey,
+			.setauthsize = cc_aead_setauthsize,
+			.encrypt = cc_aead_encrypt,
+			.decrypt = cc_aead_decrypt,
+			.init = cc_aead_init,
+			.exit = cc_aead_exit,
 			.ivsize = DES3_EDE_BLOCK_SIZE,
 			.maxauthsize = SHA256_DIGEST_SIZE,
 		},
@@ -2564,12 +2556,12 @@ static struct ssi_alg_template aead_algs[] = {
 		.blocksize = AES_BLOCK_SIZE,
 		.type = CRYPTO_ALG_TYPE_AEAD,
 		.template_aead = {
-			.setkey = ssi_aead_setkey,
-			.setauthsize = ssi_aead_setauthsize,
-			.encrypt = ssi_aead_encrypt,
-			.decrypt = ssi_aead_decrypt,
-			.init = ssi_aead_init,
-			.exit = ssi_aead_exit,
+			.setkey = cc_aead_setkey,
+			.setauthsize = cc_aead_setauthsize,
+			.encrypt = cc_aead_encrypt,
+			.decrypt = cc_aead_decrypt,
+			.init = cc_aead_init,
+			.exit = cc_aead_exit,
 			.ivsize = AES_BLOCK_SIZE,
 			.maxauthsize = AES_BLOCK_SIZE,
 		},
@@ -2583,12 +2575,12 @@ static struct ssi_alg_template aead_algs[] = {
 		.blocksize = 1,
 		.type = CRYPTO_ALG_TYPE_AEAD,
 		.template_aead = {
-			.setkey = ssi_aead_setkey,
-			.setauthsize = ssi_aead_setauthsize,
-			.encrypt = ssi_aead_encrypt,
-			.decrypt = ssi_aead_decrypt,
-			.init = ssi_aead_init,
-			.exit = ssi_aead_exit,
+			.setkey = cc_aead_setkey,
+			.setauthsize = cc_aead_setauthsize,
+			.encrypt = cc_aead_encrypt,
+			.decrypt = cc_aead_decrypt,
+			.init = cc_aead_init,
+			.exit = cc_aead_exit,
 			.ivsize = CTR_RFC3686_IV_SIZE,
 			.maxauthsize = SHA1_DIGEST_SIZE,
 		},
@@ -2602,12 +2594,12 @@ static struct ssi_alg_template aead_algs[] = {
 		.blocksize = 1,
 		.type = CRYPTO_ALG_TYPE_AEAD,
 		.template_aead = {
-			.setkey = ssi_aead_setkey,
-			.setauthsize = ssi_aead_setauthsize,
-			.encrypt = ssi_aead_encrypt,
-			.decrypt = ssi_aead_decrypt,
-			.init = ssi_aead_init,
-			.exit = ssi_aead_exit,
+			.setkey = cc_aead_setkey,
+			.setauthsize = cc_aead_setauthsize,
+			.encrypt = cc_aead_encrypt,
+			.decrypt = cc_aead_decrypt,
+			.init = cc_aead_init,
+			.exit = cc_aead_exit,
 			.ivsize = CTR_RFC3686_IV_SIZE,
 			.maxauthsize = SHA256_DIGEST_SIZE,
 		},
@@ -2621,12 +2613,12 @@ static struct ssi_alg_template aead_algs[] = {
 		.blocksize = 1,
 		.type = CRYPTO_ALG_TYPE_AEAD,
 		.template_aead = {
-			.setkey = ssi_aead_setkey,
-			.setauthsize = ssi_aead_setauthsize,
-			.encrypt = ssi_aead_encrypt,
-			.decrypt = ssi_aead_decrypt,
-			.init = ssi_aead_init,
-			.exit = ssi_aead_exit,
+			.setkey = cc_aead_setkey,
+			.setauthsize = cc_aead_setauthsize,
+			.encrypt = cc_aead_encrypt,
+			.decrypt = cc_aead_decrypt,
+			.init = cc_aead_init,
+			.exit = cc_aead_exit,
 			.ivsize = CTR_RFC3686_IV_SIZE,
 			.maxauthsize = AES_BLOCK_SIZE,
 		},
@@ -2641,12 +2633,12 @@ static struct ssi_alg_template aead_algs[] = {
 		.blocksize = 1,
 		.type = CRYPTO_ALG_TYPE_AEAD,
 		.template_aead = {
-			.setkey = ssi_aead_setkey,
-			.setauthsize = ssi_ccm_setauthsize,
-			.encrypt = ssi_aead_encrypt,
-			.decrypt = ssi_aead_decrypt,
-			.init = ssi_aead_init,
-			.exit = ssi_aead_exit,
+			.setkey = cc_aead_setkey,
+			.setauthsize = cc_ccm_setauthsize,
+			.encrypt = cc_aead_encrypt,
+			.decrypt = cc_aead_decrypt,
+			.init = cc_aead_init,
+			.exit = cc_aead_exit,
 			.ivsize = AES_BLOCK_SIZE,
 			.maxauthsize = AES_BLOCK_SIZE,
 		},
@@ -2660,12 +2652,12 @@ static struct ssi_alg_template aead_algs[] = {
 		.blocksize = 1,
 		.type = CRYPTO_ALG_TYPE_AEAD,
 		.template_aead = {
-			.setkey = ssi_rfc4309_ccm_setkey,
-			.setauthsize = ssi_rfc4309_ccm_setauthsize,
-			.encrypt = ssi_rfc4309_ccm_encrypt,
-			.decrypt = ssi_rfc4309_ccm_decrypt,
-			.init = ssi_aead_init,
-			.exit = ssi_aead_exit,
+			.setkey = cc_rfc4309_ccm_setkey,
+			.setauthsize = cc_rfc4309_ccm_setauthsize,
+			.encrypt = cc_rfc4309_ccm_encrypt,
+			.decrypt = cc_rfc4309_ccm_decrypt,
+			.init = cc_aead_init,
+			.exit = cc_aead_exit,
 			.ivsize = CCM_BLOCK_IV_SIZE,
 			.maxauthsize = AES_BLOCK_SIZE,
 		},
@@ -2681,12 +2673,12 @@ static struct ssi_alg_template aead_algs[] = {
 		.blocksize = 1,
 		.type = CRYPTO_ALG_TYPE_AEAD,
 		.template_aead = {
-			.setkey = ssi_aead_setkey,
-			.setauthsize = ssi_gcm_setauthsize,
-			.encrypt = ssi_aead_encrypt,
-			.decrypt = ssi_aead_decrypt,
-			.init = ssi_aead_init,
-			.exit = ssi_aead_exit,
+			.setkey = cc_aead_setkey,
+			.setauthsize = cc_gcm_setauthsize,
+			.encrypt = cc_aead_encrypt,
+			.decrypt = cc_aead_decrypt,
+			.init = cc_aead_init,
+			.exit = cc_aead_exit,
 			.ivsize = 12,
 			.maxauthsize = AES_BLOCK_SIZE,
 		},
@@ -2700,12 +2692,12 @@ static struct ssi_alg_template aead_algs[] = {
 		.blocksize = 1,
 		.type = CRYPTO_ALG_TYPE_AEAD,
 		.template_aead = {
-			.setkey = ssi_rfc4106_gcm_setkey,
-			.setauthsize = ssi_rfc4106_gcm_setauthsize,
-			.encrypt = ssi_rfc4106_gcm_encrypt,
-			.decrypt = ssi_rfc4106_gcm_decrypt,
-			.init = ssi_aead_init,
-			.exit = ssi_aead_exit,
+			.setkey = cc_rfc4106_gcm_setkey,
+			.setauthsize = cc_rfc4106_gcm_setauthsize,
+			.encrypt = cc_rfc4106_gcm_encrypt,
+			.decrypt = cc_rfc4106_gcm_decrypt,
+			.init = cc_aead_init,
+			.exit = cc_aead_exit,
 			.ivsize = GCM_BLOCK_RFC4_IV_SIZE,
 			.maxauthsize = AES_BLOCK_SIZE,
 		},
@@ -2719,12 +2711,12 @@ static struct ssi_alg_template aead_algs[] = {
 		.blocksize = 1,
 		.type = CRYPTO_ALG_TYPE_AEAD,
 		.template_aead = {
-			.setkey = ssi_rfc4543_gcm_setkey,
-			.setauthsize = ssi_rfc4543_gcm_setauthsize,
-			.encrypt = ssi_rfc4543_gcm_encrypt,
-			.decrypt = ssi_rfc4543_gcm_decrypt,
-			.init = ssi_aead_init,
-			.exit = ssi_aead_exit,
+			.setkey = cc_rfc4543_gcm_setkey,
+			.setauthsize = cc_rfc4543_gcm_setauthsize,
+			.encrypt = cc_rfc4543_gcm_encrypt,
+			.decrypt = cc_rfc4543_gcm_decrypt,
+			.init = cc_aead_init,
+			.exit = cc_aead_exit,
 			.ivsize = GCM_BLOCK_RFC4_IV_SIZE,
 			.maxauthsize = AES_BLOCK_SIZE,
 		},
@@ -2735,7 +2727,7 @@ static struct ssi_alg_template aead_algs[] = {
 #endif /*SSI_CC_HAS_AES_GCM*/
 };
 
-static struct ssi_crypto_alg *ssi_aead_create_alg(
+static struct ssi_crypto_alg *cc_create_aead_alg(
 			struct ssi_alg_template *template,
 			struct device *dev)
 {
@@ -2755,11 +2747,11 @@ static struct ssi_crypto_alg *ssi_aead_create_alg(
 	alg->base.cra_module = THIS_MODULE;
 	alg->base.cra_priority = SSI_CRA_PRIO;
 
-	alg->base.cra_ctxsize = sizeof(struct ssi_aead_ctx);
+	alg->base.cra_ctxsize = sizeof(struct cc_aead_ctx);
 	alg->base.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_KERN_DRIVER_ONLY |
 			 template->type;
-	alg->init = ssi_aead_init;
-	alg->exit = ssi_aead_exit;
+	alg->init = cc_aead_init;
+	alg->exit = cc_aead_exit;
 
 	t_alg->aead_alg = *alg;
 
@@ -2770,11 +2762,11 @@ static struct ssi_crypto_alg *ssi_aead_create_alg(
 	return t_alg;
 }
 
-int ssi_aead_free(struct ssi_drvdata *drvdata)
+int cc_aead_free(struct ssi_drvdata *drvdata)
 {
 	struct ssi_crypto_alg *t_alg, *n;
-	struct ssi_aead_handle *aead_handle =
-		(struct ssi_aead_handle *)drvdata->aead_handle;
+	struct cc_aead_handle *aead_handle =
+		(struct cc_aead_handle *)drvdata->aead_handle;
 
 	if (aead_handle) {
 		/* Remove registered algs */
@@ -2791,9 +2783,9 @@ int ssi_aead_free(struct ssi_drvdata *drvdata)
 	return 0;
 }
 
-int ssi_aead_alloc(struct ssi_drvdata *drvdata)
+int cc_aead_alloc(struct ssi_drvdata *drvdata)
 {
-	struct ssi_aead_handle *aead_handle;
+	struct cc_aead_handle *aead_handle;
 	struct ssi_crypto_alg *t_alg;
 	int rc = -ENOMEM;
 	int alg;
@@ -2819,7 +2811,7 @@ int ssi_aead_alloc(struct ssi_drvdata *drvdata)
 
 	/* Linux crypto */
 	for (alg = 0; alg < ARRAY_SIZE(aead_algs); alg++) {
-		t_alg = ssi_aead_create_alg(&aead_algs[alg], dev);
+		t_alg = cc_create_aead_alg(&aead_algs[alg], dev);
 		if (IS_ERR(t_alg)) {
 			rc = PTR_ERR(t_alg);
 			dev_err(dev, "%s alg allocation failed\n",
@@ -2844,7 +2836,7 @@ int ssi_aead_alloc(struct ssi_drvdata *drvdata)
 fail2:
 	kfree(t_alg);
 fail1:
-	ssi_aead_free(drvdata);
+	cc_aead_free(drvdata);
 fail0:
 	return rc;
 }
diff --git a/drivers/staging/ccree/ssi_aead.h b/drivers/staging/ccree/ssi_aead.h
index 4e29063..5172241 100644
--- a/drivers/staging/ccree/ssi_aead.h
+++ b/drivers/staging/ccree/ssi_aead.h
@@ -116,7 +116,7 @@ struct aead_req_ctx {
 	bool plaintext_authenticate_only; //for gcm_rfc4543
 };
 
-int ssi_aead_alloc(struct ssi_drvdata *drvdata);
-int ssi_aead_free(struct ssi_drvdata *drvdata);
+int cc_aead_alloc(struct ssi_drvdata *drvdata);
+int cc_aead_free(struct ssi_drvdata *drvdata);
 
 #endif /*__SSI_AEAD_H__*/
diff --git a/drivers/staging/ccree/ssi_driver.c b/drivers/staging/ccree/ssi_driver.c
index 0b2593f..041624f 100644
--- a/drivers/staging/ccree/ssi_driver.c
+++ b/drivers/staging/ccree/ssi_driver.c
@@ -365,9 +365,9 @@ static int init_cc_resources(struct platform_device *plat_dev)
 		goto post_cipher_err;
 	}
 
-	rc = ssi_aead_alloc(new_drvdata);
+	rc = cc_aead_alloc(new_drvdata);
 	if (rc) {
-		dev_err(dev, "ssi_aead_alloc failed\n");
+		dev_err(dev, "cc_aead_alloc failed\n");
 		goto post_hash_err;
 	}
 
@@ -417,7 +417,7 @@ static void cleanup_cc_resources(struct platform_device *plat_dev)
 	struct ssi_drvdata *drvdata =
 		(struct ssi_drvdata *)platform_get_drvdata(plat_dev);
 
-	ssi_aead_free(drvdata);
+	cc_aead_free(drvdata);
 	ssi_hash_free(drvdata);
 	ssi_ablkcipher_free(drvdata);
 	ssi_ivgen_fini(drvdata);
-- 
2.7.4
