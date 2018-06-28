From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 1/4] crypto: ccree: fix finup
Date: Thu, 28 Jun 2018 08:32:51 +0100
Message-ID: <1530171175-31960-2-git-send-email-gilad@benyossef.com>
References: <1530171175-31960-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>, Hadar Gat <hadar.gat@arm.com>,
        stable@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1530171175-31960-1-git-send-email-gilad@benyossef.com>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Hadar Gat <hadar.gat@arm.com>

finup() operation was incorrect, padding was missing.
Fix by setting the ccree HW to enable padding.

Signed-off-by: Hadar Gat <hadar.gat@arm.com>
[ gilad@benyossef.com: refactored for better code sharing ]
Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: stable@vger.kernel.org
---
 drivers/crypto/ccree/cc_hash.c | 81 +++++++++---------------------------------
 1 file changed, 16 insertions(+), 65 deletions(-)

diff --git a/drivers/crypto/ccree/cc_hash.c b/drivers/crypto/ccree/cc_hash.c
index 96ff777..e4ebde0 100644
--- a/drivers/crypto/ccree/cc_hash.c
+++ b/drivers/crypto/ccree/cc_hash.c
@@ -602,66 +602,7 @@ static int cc_hash_update(struct ahash_request *req)
 	return rc;
 }
 
-static int cc_hash_finup(struct ahash_request *req)
-{
-	struct ahash_req_ctx *state = ahash_request_ctx(req);
-	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
-	struct cc_hash_ctx *ctx = crypto_ahash_ctx(tfm);
-	u32 digestsize = crypto_ahash_digestsize(tfm);
-	struct scatterlist *src = req->src;
-	unsigned int nbytes = req->nbytes;
-	u8 *result = req->result;
-	struct device *dev = drvdata_to_dev(ctx->drvdata);
-	bool is_hmac = ctx->is_hmac;
-	struct cc_crypto_req cc_req = {};
-	struct cc_hw_desc desc[CC_MAX_HASH_SEQ_LEN];
-	unsigned int idx = 0;
-	int rc;
-	gfp_t flags = cc_gfp_flags(&req->base);
-
-	dev_dbg(dev, "===== %s-finup (%d) ====\n", is_hmac ? "hmac" : "hash",
-		nbytes);
-
-	if (cc_map_req(dev, state, ctx)) {
-		dev_err(dev, "map_ahash_source() failed\n");
-		return -EINVAL;
-	}
-
-	if (cc_map_hash_request_final(ctx->drvdata, state, src, nbytes, 1,
-				      flags)) {
-		dev_err(dev, "map_ahash_request_final() failed\n");
-		cc_unmap_req(dev, state, ctx);
-		return -ENOMEM;
-	}
-	if (cc_map_result(dev, state, digestsize)) {
-		dev_err(dev, "map_ahash_digest() failed\n");
-		cc_unmap_hash_request(dev, state, src, true);
-		cc_unmap_req(dev, state, ctx);
-		return -ENOMEM;
-	}
-
-	/* Setup request structure */
-	cc_req.user_cb = cc_hash_complete;
-	cc_req.user_arg = req;
-
-	idx = cc_restore_hash(desc, ctx, state, idx);
-
-	if (is_hmac)
-		idx = cc_fin_hmac(desc, req, idx);
-
-	idx = cc_fin_result(desc, req, idx);
-
-	rc = cc_send_request(ctx->drvdata, &cc_req, desc, idx, &req->base);
-	if (rc != -EINPROGRESS && rc != -EBUSY) {
-		dev_err(dev, "send_request() failed (rc=%d)\n", rc);
-		cc_unmap_hash_request(dev, state, src, true);
-		cc_unmap_result(dev, state, digestsize, result);
-		cc_unmap_req(dev, state, ctx);
-	}
-	return rc;
-}
-
-static int cc_hash_final(struct ahash_request *req)
+static int cc_do_finup(struct ahash_request *req, bool update)
 {
 	struct ahash_req_ctx *state = ahash_request_ctx(req);
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
@@ -678,21 +619,20 @@ static int cc_hash_final(struct ahash_request *req)
 	int rc;
 	gfp_t flags = cc_gfp_flags(&req->base);
 
-	dev_dbg(dev, "===== %s-final (%d) ====\n", is_hmac ? "hmac" : "hash",
-		nbytes);
+	dev_dbg(dev, "===== %s-%s (%d) ====\n", is_hmac ? "hmac" : "hash",
+		update ? "finup" : "final", nbytes);
 
 	if (cc_map_req(dev, state, ctx)) {
 		dev_err(dev, "map_ahash_source() failed\n");
 		return -EINVAL;
 	}
 
-	if (cc_map_hash_request_final(ctx->drvdata, state, src, nbytes, 0,
+	if (cc_map_hash_request_final(ctx->drvdata, state, src, nbytes, update,
 				      flags)) {
 		dev_err(dev, "map_ahash_request_final() failed\n");
 		cc_unmap_req(dev, state, ctx);
 		return -ENOMEM;
 	}
-
 	if (cc_map_result(dev, state, digestsize)) {
 		dev_err(dev, "map_ahash_digest() failed\n");
 		cc_unmap_hash_request(dev, state, src, true);
@@ -706,7 +646,7 @@ static int cc_hash_final(struct ahash_request *req)
 
 	idx = cc_restore_hash(desc, ctx, state, idx);
 
-	/* "DO-PAD" must be enabled only when writing current length to HW */
+	/* Pad the hash */
 	hw_desc_init(&desc[idx]);
 	set_cipher_do(&desc[idx], DO_PAD);
 	set_cipher_mode(&desc[idx], ctx->hw_mode);
@@ -731,6 +671,17 @@ static int cc_hash_final(struct ahash_request *req)
 	return rc;
 }
 
+static int cc_hash_finup(struct ahash_request *req)
+{
+	return cc_do_finup(req, true);
+}
+
+
+static int cc_hash_final(struct ahash_request *req)
+{
+	return cc_do_finup(req, false);
+}
+
 static int cc_hash_init(struct ahash_request *req)
 {
 	struct ahash_req_ctx *state = ahash_request_ctx(req);
-- 
2.7.4
