Return-Path: <SRS0=XFsj=M6=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:37518 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726758AbeJRVB2 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Oct 2018 17:01:28 -0400
From: Yael Chemla <yael.chemla@foss.arm.com>
To: Gilad Ben-Yossef <gilad@benyossef.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, Ofir Drang <ofir.drang@arm.com>,
        linux-kernel@vger.kernel.org
Cc: Yael Chemla <yael.chemla@foss.arm.com>
Subject: [PATCH 2/3] crypto: ccree:  modify set_cipher_mode usage from cc_hash
Date: Thu, 18 Oct 2018 13:59:58 +0100
Message-Id: <1539867599-20504-3-git-send-email-yael.chemla@foss.arm.com>
In-Reply-To: <1539867599-20504-1-git-send-email-yael.chemla@foss.arm.com>
References: <1539867599-20504-1-git-send-email-yael.chemla@foss.arm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

encapsulate set_cipher_mode call with another api,
preparation for specific hash behavior as needed in later patches
when SM3 introduced.

Signed-off-by: Yael Chemla <yael.chemla@foss.arm.com>
---
 drivers/crypto/ccree/cc_hash.c          | 18 +++++++++---------
 drivers/crypto/ccree/cc_hw_queue_defs.h | 14 ++++++++++++++
 2 files changed, 23 insertions(+), 9 deletions(-)

diff --git a/drivers/crypto/ccree/cc_hash.c b/drivers/crypto/ccree/cc_hash.c
index 7af5b61..adcd9df 100644
--- a/drivers/crypto/ccree/cc_hash.c
+++ b/drivers/crypto/ccree/cc_hash.c
@@ -322,7 +322,7 @@ static int cc_fin_result(struct cc_hw_desc *desc, struct ahash_request *req,
 
 	/* Get final MAC result */
 	hw_desc_init(&desc[idx]);
-	set_cipher_mode(&desc[idx], ctx->hw_mode);
+	set_hash_cipher_mode(&desc[idx], ctx->hw_mode, ctx->hash_mode);
 	/* TODO */
 	set_dout_dlli(&desc[idx], state->digest_result_dma_addr, digestsize,
 		      NS_BIT, 1);
@@ -441,7 +441,7 @@ static int cc_hash_digest(struct ahash_request *req)
 	 * digest
 	 */
 	hw_desc_init(&desc[idx]);
-	set_cipher_mode(&desc[idx], ctx->hw_mode);
+	set_hash_cipher_mode(&desc[idx], ctx->hw_mode, ctx->hash_mode);
 	if (is_hmac) {
 		set_din_type(&desc[idx], DMA_DLLI, state->digest_buff_dma_addr,
 			     ctx->inter_digestsize, NS_BIT);
@@ -455,7 +455,7 @@ static int cc_hash_digest(struct ahash_request *req)
 
 	/* Load the hash current length */
 	hw_desc_init(&desc[idx]);
-	set_cipher_mode(&desc[idx], ctx->hw_mode);
+	set_hash_cipher_mode(&desc[idx], ctx->hw_mode, ctx->hash_mode);
 
 	if (is_hmac) {
 		set_din_type(&desc[idx], DMA_DLLI,
@@ -505,7 +505,7 @@ static int cc_restore_hash(struct cc_hw_desc *desc, struct cc_hash_ctx *ctx,
 {
 	/* Restore hash digest */
 	hw_desc_init(&desc[idx]);
-	set_cipher_mode(&desc[idx], ctx->hw_mode);
+	set_hash_cipher_mode(&desc[idx], ctx->hw_mode, ctx->hash_mode);
 	set_din_type(&desc[idx], DMA_DLLI, state->digest_buff_dma_addr,
 		     ctx->inter_digestsize, NS_BIT);
 	set_flow_mode(&desc[idx], S_DIN_to_HASH);
@@ -514,7 +514,7 @@ static int cc_restore_hash(struct cc_hw_desc *desc, struct cc_hash_ctx *ctx,
 
 	/* Restore hash current length */
 	hw_desc_init(&desc[idx]);
-	set_cipher_mode(&desc[idx], ctx->hw_mode);
+	set_hash_cipher_mode(&desc[idx], ctx->hw_mode, ctx->hash_mode);
 	set_cipher_config1(&desc[idx], HASH_PADDING_DISABLED);
 	set_din_type(&desc[idx], DMA_DLLI, state->digest_bytes_len_dma_addr,
 		     ctx->hash_len, NS_BIT);
@@ -577,7 +577,7 @@ static int cc_hash_update(struct ahash_request *req)
 
 	/* store the hash digest result in context */
 	hw_desc_init(&desc[idx]);
-	set_cipher_mode(&desc[idx], ctx->hw_mode);
+	set_hash_cipher_mode(&desc[idx], ctx->hw_mode, ctx->hash_mode);
 	set_dout_dlli(&desc[idx], state->digest_buff_dma_addr,
 		      ctx->inter_digestsize, NS_BIT, 0);
 	set_flow_mode(&desc[idx], S_HASH_to_DOUT);
@@ -586,7 +586,7 @@ static int cc_hash_update(struct ahash_request *req)
 
 	/* store current hash length in context */
 	hw_desc_init(&desc[idx]);
-	set_cipher_mode(&desc[idx], ctx->hw_mode);
+	set_hash_cipher_mode(&desc[idx], ctx->hw_mode, ctx->hash_mode);
 	set_dout_dlli(&desc[idx], state->digest_bytes_len_dma_addr,
 		      ctx->hash_len, NS_BIT, 1);
 	set_queue_last_ind(ctx->drvdata, &desc[idx]);
@@ -650,7 +650,7 @@ static int cc_do_finup(struct ahash_request *req, bool update)
 	/* Pad the hash */
 	hw_desc_init(&desc[idx]);
 	set_cipher_do(&desc[idx], DO_PAD);
-	set_cipher_mode(&desc[idx], ctx->hw_mode);
+	set_hash_cipher_mode(&desc[idx], ctx->hw_mode, ctx->hash_mode);
 	set_dout_dlli(&desc[idx], state->digest_bytes_len_dma_addr,
 		      ctx->hash_len, NS_BIT, 0);
 	set_setup_mode(&desc[idx], SETUP_WRITE_STATE1);
@@ -2035,7 +2035,7 @@ static void cc_setup_xcbc(struct ahash_request *areq, struct cc_hw_desc desc[],
 					    XCBC_MAC_K1_OFFSET),
 		     CC_AES_128_BIT_KEY_SIZE, NS_BIT);
 	set_setup_mode(&desc[idx], SETUP_LOAD_KEY0);
-	set_cipher_mode(&desc[idx], DRV_CIPHER_XCBC_MAC);
+	set_hash_cipher_mode(&desc[idx], DRV_CIPHER_XCBC_MAC, ctx->hash_mode);
 	set_cipher_config0(&desc[idx], DESC_DIRECTION_ENCRYPT_ENCRYPT);
 	set_key_size_aes(&desc[idx], CC_AES_128_BIT_KEY_SIZE);
 	set_flow_mode(&desc[idx], S_DIN_to_AES);
diff --git a/drivers/crypto/ccree/cc_hw_queue_defs.h b/drivers/crypto/ccree/cc_hw_queue_defs.h
index 45985b9..b367b67 100644
--- a/drivers/crypto/ccree/cc_hw_queue_defs.h
+++ b/drivers/crypto/ccree/cc_hw_queue_defs.h
@@ -455,6 +455,20 @@ static inline void set_cipher_mode(struct cc_hw_desc *pdesc, int mode)
 }
 
 /*
+ * Set the cipher mode for hash algorithms.
+ *
+ * @pdesc: pointer HW descriptor struct
+ * @cipher_mode:  Any one of the modes defined in [CC7x-DESC]
+ * @hash_mode: specifies which hash is being handled
+ */
+static inline void set_hash_cipher_mode(struct cc_hw_desc *pdesc,
+					enum drv_cipher_mode cipher_mode,
+					enum drv_hash_mode hash_mode)
+{
+	set_cipher_mode(pdesc, cipher_mode);
+}
+
+/*
  * Set the cipher configuration fields.
  *
  * @pdesc: pointer HW descriptor struct
-- 
2.7.4
