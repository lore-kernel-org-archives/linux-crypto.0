From: Hadar Gat <hadar.gat@arm.com>
Subject: [PATCH] crypto: ccree: fix finup
Date: Thu, 21 Jun 2018 12:47:32 +0100
Message-ID: <1529581652-31294-1-git-send-email-hadar.gat@arm.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ofir Drang <ofir.drang@arm.com>,
        Gilad Ben-Yossef <gilad.BenYossef@arm.com>,
        Hadar Gat <hadar.gat@arm.com>, stable@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

finup() operation was incorrect, padding was missing.
Fix by setting the ccree HW to enable padding.

Signed-off-by: Hadar Gat <hadar.gat@arm.com>
Cc: stable@vger.kernel.org
---
 drivers/crypto/ccree/cc_hash.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/ccree/cc_hash.c b/drivers/crypto/ccree/cc_hash.c
index 96ff777..e8bb934 100644
--- a/drivers/crypto/ccree/cc_hash.c
+++ b/drivers/crypto/ccree/cc_hash.c
@@ -500,8 +500,12 @@ static int cc_hash_digest(struct ahash_request *req)
 }
 
 static int cc_restore_hash(struct cc_hw_desc *desc, struct cc_hash_ctx *ctx,
-			   struct ahash_req_ctx *state, unsigned int idx)
+			   struct ahash_req_ctx *state, unsigned int idx,
+			   bool hash_padding)
 {
+	enum cc_hash_conf_pad pad_conf = hash_padding ? HASH_PADDING_ENABLED :
+			HASH_PADDING_DISABLED;
+
 	/* Restore hash digest */
 	hw_desc_init(&desc[idx]);
 	set_cipher_mode(&desc[idx], ctx->hw_mode);
@@ -514,7 +518,7 @@ static int cc_restore_hash(struct cc_hw_desc *desc, struct cc_hash_ctx *ctx,
 	/* Restore hash current length */
 	hw_desc_init(&desc[idx]);
 	set_cipher_mode(&desc[idx], ctx->hw_mode);
-	set_cipher_config1(&desc[idx], HASH_PADDING_DISABLED);
+	set_cipher_config1(&desc[idx], pad_conf);
 	set_din_type(&desc[idx], DMA_DLLI, state->digest_bytes_len_dma_addr,
 		     ctx->drvdata->hash_len_sz, NS_BIT);
 	set_flow_mode(&desc[idx], S_DIN_to_HASH);
@@ -572,7 +576,7 @@ static int cc_hash_update(struct ahash_request *req)
 	cc_req.user_cb = cc_update_complete;
 	cc_req.user_arg = req;
 
-	idx = cc_restore_hash(desc, ctx, state, idx);
+	idx = cc_restore_hash(desc, ctx, state, idx, false);
 
 	/* store the hash digest result in context */
 	hw_desc_init(&desc[idx]);
@@ -644,7 +648,7 @@ static int cc_hash_finup(struct ahash_request *req)
 	cc_req.user_cb = cc_hash_complete;
 	cc_req.user_arg = req;
 
-	idx = cc_restore_hash(desc, ctx, state, idx);
+	idx = cc_restore_hash(desc, ctx, state, idx, true);
 
 	if (is_hmac)
 		idx = cc_fin_hmac(desc, req, idx);
@@ -704,7 +708,7 @@ static int cc_hash_final(struct ahash_request *req)
 	cc_req.user_cb = cc_hash_complete;
 	cc_req.user_arg = req;
 
-	idx = cc_restore_hash(desc, ctx, state, idx);
+	idx = cc_restore_hash(desc, ctx, state, idx, false);
 
 	/* "DO-PAD" must be enabled only when writing current length to HW */
 	hw_desc_init(&desc[idx]);
-- 
2.7.4
