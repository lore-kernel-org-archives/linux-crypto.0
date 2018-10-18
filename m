Return-Path: <SRS0=XFsj=M6=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:37506 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726758AbeJRVBZ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Oct 2018 17:01:25 -0400
From: Yael Chemla <yael.chemla@foss.arm.com>
To: Gilad Ben-Yossef <gilad@benyossef.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, Ofir Drang <ofir.drang@arm.com>,
        linux-kernel@vger.kernel.org
Cc: Yael Chemla <yael.chemla@foss.arm.com>
Subject: [PATCH 1/3] crypto: ccree: adjust hash length to suit certain context specifics
Date: Thu, 18 Oct 2018 13:59:57 +0100
Message-Id: <1539867599-20504-2-git-send-email-yael.chemla@foss.arm.com>
In-Reply-To: <1539867599-20504-1-git-send-email-yael.chemla@foss.arm.com>
References: <1539867599-20504-1-git-send-email-yael.chemla@foss.arm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Adjust hash length such that it will not be fixed and general for all algs.
Instead make it suitable for certain context information.
This is preparation for SM3 support.

Signed-off-by: Yael Chemla <yael.chemla@foss.arm.com>
---
 drivers/crypto/ccree/cc_aead.c   | 19 ++++++++++++++-----
 drivers/crypto/ccree/cc_driver.c | 10 ++++++++--
 drivers/crypto/ccree/cc_driver.h |  2 +-
 drivers/crypto/ccree/cc_hash.c   | 40 ++++++++++++++++++++++++----------------
 4 files changed, 47 insertions(+), 24 deletions(-)

diff --git a/drivers/crypto/ccree/cc_aead.c b/drivers/crypto/ccree/cc_aead.c
index 01b82b8..e0ac376c 100644
--- a/drivers/crypto/ccree/cc_aead.c
+++ b/drivers/crypto/ccree/cc_aead.c
@@ -58,6 +58,7 @@ struct cc_aead_ctx {
 	unsigned int enc_keylen;
 	unsigned int auth_keylen;
 	unsigned int authsize; /* Actual (reduced?) size of the MAC/ICv */
+	unsigned int hash_len;
 	enum drv_cipher_mode cipher_mode;
 	enum cc_flow_mode flow_mode;
 	enum drv_hash_mode auth_mode;
@@ -122,6 +123,13 @@ static void cc_aead_exit(struct crypto_aead *tfm)
 	}
 }
 
+static unsigned int cc_get_aead_hash_len(struct crypto_aead *tfm)
+{
+	struct cc_aead_ctx *ctx = crypto_aead_ctx(tfm);
+
+	return cc_get_default_hash_len(ctx->drvdata);
+}
+
 static int cc_aead_init(struct crypto_aead *tfm)
 {
 	struct aead_alg *alg = crypto_aead_alg(tfm);
@@ -196,6 +204,7 @@ static int cc_aead_init(struct crypto_aead *tfm)
 		ctx->auth_state.hmac.ipad_opad = NULL;
 		ctx->auth_state.hmac.padded_authkey = NULL;
 	}
+	ctx->hash_len = cc_get_aead_hash_len(tfm);
 
 	return 0;
 
@@ -327,7 +336,7 @@ static int hmac_setkey(struct cc_hw_desc *desc, struct cc_aead_ctx *ctx)
 		/* Load the hash current length*/
 		hw_desc_init(&desc[idx]);
 		set_cipher_mode(&desc[idx], hash_mode);
-		set_din_const(&desc[idx], 0, ctx->drvdata->hash_len_sz);
+		set_din_const(&desc[idx], 0, ctx->hash_len);
 		set_flow_mode(&desc[idx], S_DIN_to_HASH);
 		set_setup_mode(&desc[idx], SETUP_LOAD_KEY0);
 		idx++;
@@ -465,7 +474,7 @@ static int cc_get_plain_hmac_key(struct crypto_aead *tfm, const u8 *key,
 			/* Load the hash current length*/
 			hw_desc_init(&desc[idx]);
 			set_cipher_mode(&desc[idx], hashmode);
-			set_din_const(&desc[idx], 0, ctx->drvdata->hash_len_sz);
+			set_din_const(&desc[idx], 0, ctx->hash_len);
 			set_cipher_config1(&desc[idx], HASH_PADDING_ENABLED);
 			set_flow_mode(&desc[idx], S_DIN_to_HASH);
 			set_setup_mode(&desc[idx], SETUP_LOAD_KEY0);
@@ -1001,7 +1010,7 @@ static void cc_set_hmac_desc(struct aead_request *req, struct cc_hw_desc desc[],
 	hw_desc_init(&desc[idx]);
 	set_cipher_mode(&desc[idx], hash_mode);
 	set_din_sram(&desc[idx], cc_digest_len_addr(ctx->drvdata, hash_mode),
-		     ctx->drvdata->hash_len_sz);
+		     ctx->hash_len);
 	set_flow_mode(&desc[idx], S_DIN_to_HASH);
 	set_setup_mode(&desc[idx], SETUP_LOAD_KEY0);
 	idx++;
@@ -1098,7 +1107,7 @@ static void cc_proc_scheme_desc(struct aead_request *req,
 	hw_desc_init(&desc[idx]);
 	set_cipher_mode(&desc[idx], hash_mode);
 	set_dout_sram(&desc[idx], aead_handle->sram_workspace_addr,
-		      ctx->drvdata->hash_len_sz);
+		      ctx->hash_len);
 	set_flow_mode(&desc[idx], S_HASH_to_DOUT);
 	set_setup_mode(&desc[idx], SETUP_WRITE_STATE1);
 	set_cipher_do(&desc[idx], DO_PAD);
@@ -1128,7 +1137,7 @@ static void cc_proc_scheme_desc(struct aead_request *req,
 	hw_desc_init(&desc[idx]);
 	set_cipher_mode(&desc[idx], hash_mode);
 	set_din_sram(&desc[idx], cc_digest_len_addr(ctx->drvdata, hash_mode),
-		     ctx->drvdata->hash_len_sz);
+		     ctx->hash_len);
 	set_cipher_config1(&desc[idx], HASH_PADDING_ENABLED);
 	set_flow_mode(&desc[idx], S_DIN_to_HASH);
 	set_setup_mode(&desc[idx], SETUP_LOAD_KEY0);
diff --git a/drivers/crypto/ccree/cc_driver.c b/drivers/crypto/ccree/cc_driver.c
index 1ff229c..14e1970 100644
--- a/drivers/crypto/ccree/cc_driver.c
+++ b/drivers/crypto/ccree/cc_driver.c
@@ -206,12 +206,10 @@ static int init_cc_resources(struct platform_device *plat_dev)
 	new_drvdata->hw_rev = hw_rev->rev;
 
 	if (hw_rev->rev >= CC_HW_REV_712) {
-		new_drvdata->hash_len_sz = HASH_LEN_SIZE_712;
 		new_drvdata->axim_mon_offset = CC_REG(AXIM_MON_COMP);
 		new_drvdata->sig_offset = CC_REG(HOST_SIGNATURE_712);
 		new_drvdata->ver_offset = CC_REG(HOST_VERSION_712);
 	} else {
-		new_drvdata->hash_len_sz = HASH_LEN_SIZE_630;
 		new_drvdata->axim_mon_offset = CC_REG(AXIM_MON_COMP8);
 		new_drvdata->sig_offset = CC_REG(HOST_SIGNATURE_630);
 		new_drvdata->ver_offset = CC_REG(HOST_VERSION_630);
@@ -461,6 +459,14 @@ int cc_clk_on(struct cc_drvdata *drvdata)
 	return 0;
 }
 
+unsigned int cc_get_default_hash_len(struct cc_drvdata *drvdata)
+{
+	if (drvdata->hw_rev >= CC_HW_REV_712)
+		return HASH_LEN_SIZE_712;
+	else
+		return HASH_LEN_SIZE_630;
+}
+
 void cc_clk_off(struct cc_drvdata *drvdata)
 {
 	struct clk *clk = drvdata->clk;
diff --git a/drivers/crypto/ccree/cc_driver.h b/drivers/crypto/ccree/cc_driver.h
index d608a4f..27bb97c 100644
--- a/drivers/crypto/ccree/cc_driver.h
+++ b/drivers/crypto/ccree/cc_driver.h
@@ -127,7 +127,6 @@ struct cc_drvdata {
 	bool coherent;
 	char *hw_rev_name;
 	enum cc_hw_rev hw_rev;
-	u32 hash_len_sz;
 	u32 axim_mon_offset;
 	u32 sig_offset;
 	u32 ver_offset;
@@ -182,6 +181,7 @@ int init_cc_regs(struct cc_drvdata *drvdata, bool is_probe);
 void fini_cc_regs(struct cc_drvdata *drvdata);
 int cc_clk_on(struct cc_drvdata *drvdata);
 void cc_clk_off(struct cc_drvdata *drvdata);
+unsigned int cc_get_default_hash_len(struct cc_drvdata *drvdata);
 
 static inline void cc_iowrite(struct cc_drvdata *drvdata, u32 reg, u32 val)
 {
diff --git a/drivers/crypto/ccree/cc_hash.c b/drivers/crypto/ccree/cc_hash.c
index b931330..7af5b61 100644
--- a/drivers/crypto/ccree/cc_hash.c
+++ b/drivers/crypto/ccree/cc_hash.c
@@ -82,6 +82,7 @@ struct cc_hash_ctx {
 	int hash_mode;
 	int hw_mode;
 	int inter_digestsize;
+	unsigned int hash_len;
 	struct completion setkey_comp;
 	bool is_hmac;
 };
@@ -138,10 +139,10 @@ static void cc_init_req(struct device *dev, struct ahash_req_ctx *state,
 			    ctx->hash_mode == DRV_HASH_SHA384)
 				memcpy(state->digest_bytes_len,
 				       digest_len_sha512_init,
-				       ctx->drvdata->hash_len_sz);
+				       ctx->hash_len);
 			else
 				memcpy(state->digest_bytes_len, digest_len_init,
-				       ctx->drvdata->hash_len_sz);
+				       ctx->hash_len);
 		}
 
 		if (ctx->hash_mode != DRV_HASH_NULL) {
@@ -367,7 +368,7 @@ static int cc_fin_hmac(struct cc_hw_desc *desc, struct ahash_request *req,
 	set_cipher_mode(&desc[idx], ctx->hw_mode);
 	set_din_sram(&desc[idx],
 		     cc_digest_len_addr(ctx->drvdata, ctx->hash_mode),
-		     ctx->drvdata->hash_len_sz);
+		     ctx->hash_len);
 	set_cipher_config1(&desc[idx], HASH_PADDING_ENABLED);
 	set_flow_mode(&desc[idx], S_DIN_to_HASH);
 	set_setup_mode(&desc[idx], SETUP_LOAD_KEY0);
@@ -459,9 +460,9 @@ static int cc_hash_digest(struct ahash_request *req)
 	if (is_hmac) {
 		set_din_type(&desc[idx], DMA_DLLI,
 			     state->digest_bytes_len_dma_addr,
-			     ctx->drvdata->hash_len_sz, NS_BIT);
+			     ctx->hash_len, NS_BIT);
 	} else {
-		set_din_const(&desc[idx], 0, ctx->drvdata->hash_len_sz);
+		set_din_const(&desc[idx], 0, ctx->hash_len);
 		if (nbytes)
 			set_cipher_config1(&desc[idx], HASH_PADDING_ENABLED);
 		else
@@ -478,7 +479,7 @@ static int cc_hash_digest(struct ahash_request *req)
 		hw_desc_init(&desc[idx]);
 		set_cipher_mode(&desc[idx], ctx->hw_mode);
 		set_dout_dlli(&desc[idx], state->digest_buff_dma_addr,
-			      ctx->drvdata->hash_len_sz, NS_BIT, 0);
+			      ctx->hash_len, NS_BIT, 0);
 		set_flow_mode(&desc[idx], S_HASH_to_DOUT);
 		set_setup_mode(&desc[idx], SETUP_WRITE_STATE1);
 		set_cipher_do(&desc[idx], DO_PAD);
@@ -516,7 +517,7 @@ static int cc_restore_hash(struct cc_hw_desc *desc, struct cc_hash_ctx *ctx,
 	set_cipher_mode(&desc[idx], ctx->hw_mode);
 	set_cipher_config1(&desc[idx], HASH_PADDING_DISABLED);
 	set_din_type(&desc[idx], DMA_DLLI, state->digest_bytes_len_dma_addr,
-		     ctx->drvdata->hash_len_sz, NS_BIT);
+		     ctx->hash_len, NS_BIT);
 	set_flow_mode(&desc[idx], S_DIN_to_HASH);
 	set_setup_mode(&desc[idx], SETUP_LOAD_KEY0);
 	idx++;
@@ -587,7 +588,7 @@ static int cc_hash_update(struct ahash_request *req)
 	hw_desc_init(&desc[idx]);
 	set_cipher_mode(&desc[idx], ctx->hw_mode);
 	set_dout_dlli(&desc[idx], state->digest_bytes_len_dma_addr,
-		      ctx->drvdata->hash_len_sz, NS_BIT, 1);
+		      ctx->hash_len, NS_BIT, 1);
 	set_queue_last_ind(ctx->drvdata, &desc[idx]);
 	set_flow_mode(&desc[idx], S_HASH_to_DOUT);
 	set_setup_mode(&desc[idx], SETUP_WRITE_STATE1);
@@ -651,7 +652,7 @@ static int cc_do_finup(struct ahash_request *req, bool update)
 	set_cipher_do(&desc[idx], DO_PAD);
 	set_cipher_mode(&desc[idx], ctx->hw_mode);
 	set_dout_dlli(&desc[idx], state->digest_bytes_len_dma_addr,
-		      ctx->drvdata->hash_len_sz, NS_BIT, 0);
+		      ctx->hash_len, NS_BIT, 0);
 	set_setup_mode(&desc[idx], SETUP_WRITE_STATE1);
 	set_flow_mode(&desc[idx], S_HASH_to_DOUT);
 	idx++;
@@ -749,7 +750,7 @@ static int cc_hash_setkey(struct crypto_ahash *ahash, const u8 *key,
 			/* Load the hash current length*/
 			hw_desc_init(&desc[idx]);
 			set_cipher_mode(&desc[idx], ctx->hw_mode);
-			set_din_const(&desc[idx], 0, ctx->drvdata->hash_len_sz);
+			set_din_const(&desc[idx], 0, ctx->hash_len);
 			set_cipher_config1(&desc[idx], HASH_PADDING_ENABLED);
 			set_flow_mode(&desc[idx], S_DIN_to_HASH);
 			set_setup_mode(&desc[idx], SETUP_LOAD_KEY0);
@@ -831,7 +832,7 @@ static int cc_hash_setkey(struct crypto_ahash *ahash, const u8 *key,
 		/* Load the hash current length*/
 		hw_desc_init(&desc[idx]);
 		set_cipher_mode(&desc[idx], ctx->hw_mode);
-		set_din_const(&desc[idx], 0, ctx->drvdata->hash_len_sz);
+		set_din_const(&desc[idx], 0, ctx->hash_len);
 		set_flow_mode(&desc[idx], S_DIN_to_HASH);
 		set_setup_mode(&desc[idx], SETUP_LOAD_KEY0);
 		idx++;
@@ -1069,6 +1070,13 @@ static int cc_alloc_ctx(struct cc_hash_ctx *ctx)
 	return -ENOMEM;
 }
 
+static int cc_get_hash_len(struct crypto_tfm *tfm)
+{
+	struct cc_hash_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	return cc_get_default_hash_len(ctx->drvdata);
+}
+
 static int cc_cra_init(struct crypto_tfm *tfm)
 {
 	struct cc_hash_ctx *ctx = crypto_tfm_ctx(tfm);
@@ -1086,7 +1094,7 @@ static int cc_cra_init(struct crypto_tfm *tfm)
 	ctx->hw_mode = cc_alg->hw_mode;
 	ctx->inter_digestsize = cc_alg->inter_digestsize;
 	ctx->drvdata = cc_alg->drvdata;
-
+	ctx->hash_len = cc_get_hash_len(tfm);
 	return cc_alloc_ctx(ctx);
 }
 
@@ -1465,8 +1473,8 @@ static int cc_hash_export(struct ahash_request *req, void *out)
 	memcpy(out, state->digest_buff, ctx->inter_digestsize);
 	out += ctx->inter_digestsize;
 
-	memcpy(out, state->digest_bytes_len, ctx->drvdata->hash_len_sz);
-	out += ctx->drvdata->hash_len_sz;
+	memcpy(out, state->digest_bytes_len, ctx->hash_len);
+	out += ctx->hash_len;
 
 	memcpy(out, &curr_buff_cnt, sizeof(u32));
 	out += sizeof(u32);
@@ -1494,8 +1502,8 @@ static int cc_hash_import(struct ahash_request *req, const void *in)
 	memcpy(state->digest_buff, in, ctx->inter_digestsize);
 	in += ctx->inter_digestsize;
 
-	memcpy(state->digest_bytes_len, in, ctx->drvdata->hash_len_sz);
-	in += ctx->drvdata->hash_len_sz;
+	memcpy(state->digest_bytes_len, in, ctx->hash_len);
+	in += ctx->hash_len;
 
 	/* Sanity check the data as much as possible */
 	memcpy(&tmp, in, sizeof(u32));
-- 
2.7.4
