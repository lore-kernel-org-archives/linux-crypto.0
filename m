From: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
Subject: [PATCH 2/2] crypto: caam - fix gfp allocation flags (part II)
Date: Mon, 19 Jun 2017 11:44:46 +0300
Message-ID: <20170619084446.27967-2-horia.geanta@nxp.com>
References: <5215CFD1-A162-4668-A34C-1C29509DC27E@sigma-star.at>
 <20170619084446.27967-1-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: "David S. Miller" <davem@davemloft.net>,
        Dan Douglass <dan.douglass@nxp.com>, <richard@sigma-star.at>,
        Radu Solea <radu.solea@nxp.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        David Gstir <david@sigma-star.at>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-dm3nam03on0056.outbound.protection.outlook.com ([104.47.41.56]:10767
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753769AbdFSIul (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 19 Jun 2017 04:50:41 -0400
In-Reply-To: <20170619084446.27967-1-horia.geanta@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This is the 2nd part of fixing the usage of GFP_KERNEL for memory
allocations, taking care off all the places that haven't caused a real
problem / failure.
Again, the issue being fixed is that GFP_KERNEL should be used only when
MAY_SLEEP flag is set, i.e. MAY_BACKLOG flag usage is orthogonal.

Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
---
 drivers/crypto/caam/caamalg.c    |  7 +++----
 drivers/crypto/caam/caamalg_qi.c | 10 ++++------
 drivers/crypto/caam/caamhash.c   | 32 ++++++++++++++++----------------
 drivers/crypto/caam/caampkc.c    |  4 ++--
 4 files changed, 25 insertions(+), 28 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index 4ecf92e3b404..fde399c88779 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -1187,8 +1187,8 @@ static struct aead_edesc *aead_edesc_alloc(struct aead_request *req,
 	struct crypto_aead *aead = crypto_aead_reqtfm(req);
 	struct caam_ctx *ctx = crypto_aead_ctx(aead);
 	struct device *jrdev = ctx->jrdev;
-	gfp_t flags = (req->base.flags & (CRYPTO_TFM_REQ_MAY_BACKLOG |
-		       CRYPTO_TFM_REQ_MAY_SLEEP)) ? GFP_KERNEL : GFP_ATOMIC;
+	gfp_t flags = (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
+		       GFP_KERNEL : GFP_ATOMIC;
 	int src_nents, mapped_src_nents, dst_nents = 0, mapped_dst_nents = 0;
 	struct aead_edesc *edesc;
 	int sec4_sg_index, sec4_sg_len, sec4_sg_bytes;
@@ -1680,8 +1680,7 @@ static struct ablkcipher_edesc *ablkcipher_giv_edesc_alloc(
 	struct crypto_ablkcipher *ablkcipher = crypto_ablkcipher_reqtfm(req);
 	struct caam_ctx *ctx = crypto_ablkcipher_ctx(ablkcipher);
 	struct device *jrdev = ctx->jrdev;
-	gfp_t flags = (req->base.flags & (CRYPTO_TFM_REQ_MAY_BACKLOG |
-					  CRYPTO_TFM_REQ_MAY_SLEEP)) ?
+	gfp_t flags = (req->base.flags &  CRYPTO_TFM_REQ_MAY_SLEEP) ?
 		       GFP_KERNEL : GFP_ATOMIC;
 	int src_nents, mapped_src_nents, dst_nents, mapped_dst_nents;
 	struct ablkcipher_edesc *edesc;
diff --git a/drivers/crypto/caam/caamalg_qi.c b/drivers/crypto/caam/caamalg_qi.c
index ea0e5b8b9171..78c4c0485c58 100644
--- a/drivers/crypto/caam/caamalg_qi.c
+++ b/drivers/crypto/caam/caamalg_qi.c
@@ -555,8 +555,8 @@ static struct aead_edesc *aead_edesc_alloc(struct aead_request *req,
 	struct caam_aead_alg *alg = container_of(crypto_aead_alg(aead),
 						 typeof(*alg), aead);
 	struct device *qidev = ctx->qidev;
-	gfp_t flags = (req->base.flags & (CRYPTO_TFM_REQ_MAY_BACKLOG |
-		       CRYPTO_TFM_REQ_MAY_SLEEP)) ? GFP_KERNEL : GFP_ATOMIC;
+	gfp_t flags = (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
+		       GFP_KERNEL : GFP_ATOMIC;
 	int src_nents, mapped_src_nents, dst_nents = 0, mapped_dst_nents = 0;
 	struct aead_edesc *edesc;
 	dma_addr_t qm_sg_dma, iv_dma = 0;
@@ -808,8 +808,7 @@ static struct ablkcipher_edesc *ablkcipher_edesc_alloc(struct ablkcipher_request
 	struct crypto_ablkcipher *ablkcipher = crypto_ablkcipher_reqtfm(req);
 	struct caam_ctx *ctx = crypto_ablkcipher_ctx(ablkcipher);
 	struct device *qidev = ctx->qidev;
-	gfp_t flags = (req->base.flags & (CRYPTO_TFM_REQ_MAY_BACKLOG |
-					  CRYPTO_TFM_REQ_MAY_SLEEP)) ?
+	gfp_t flags = (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
 		       GFP_KERNEL : GFP_ATOMIC;
 	int src_nents, mapped_src_nents, dst_nents = 0, mapped_dst_nents = 0;
 	struct ablkcipher_edesc *edesc;
@@ -953,8 +952,7 @@ static struct ablkcipher_edesc *ablkcipher_giv_edesc_alloc(
 	struct crypto_ablkcipher *ablkcipher = crypto_ablkcipher_reqtfm(req);
 	struct caam_ctx *ctx = crypto_ablkcipher_ctx(ablkcipher);
 	struct device *qidev = ctx->qidev;
-	gfp_t flags = (req->base.flags & (CRYPTO_TFM_REQ_MAY_BACKLOG |
-					  CRYPTO_TFM_REQ_MAY_SLEEP)) ?
+	gfp_t flags = (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
 		       GFP_KERNEL : GFP_ATOMIC;
 	int src_nents, mapped_src_nents, dst_nents, mapped_dst_nents;
 	struct ablkcipher_edesc *edesc;
diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index da4f94eab3da..7c44c90ad593 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -719,8 +719,8 @@ static int ahash_update_ctx(struct ahash_request *req)
 	struct caam_hash_ctx *ctx = crypto_ahash_ctx(ahash);
 	struct caam_hash_state *state = ahash_request_ctx(req);
 	struct device *jrdev = ctx->jrdev;
-	gfp_t flags = (req->base.flags & (CRYPTO_TFM_REQ_MAY_BACKLOG |
-		       CRYPTO_TFM_REQ_MAY_SLEEP)) ? GFP_KERNEL : GFP_ATOMIC;
+	gfp_t flags = (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
+		       GFP_KERNEL : GFP_ATOMIC;
 	u8 *buf = current_buf(state);
 	int *buflen = current_buflen(state);
 	u8 *next_buf = alt_buf(state);
@@ -849,8 +849,8 @@ static int ahash_final_ctx(struct ahash_request *req)
 	struct caam_hash_ctx *ctx = crypto_ahash_ctx(ahash);
 	struct caam_hash_state *state = ahash_request_ctx(req);
 	struct device *jrdev = ctx->jrdev;
-	gfp_t flags = (req->base.flags & (CRYPTO_TFM_REQ_MAY_BACKLOG |
-		       CRYPTO_TFM_REQ_MAY_SLEEP)) ? GFP_KERNEL : GFP_ATOMIC;
+	gfp_t flags = (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
+		       GFP_KERNEL : GFP_ATOMIC;
 	int buflen = *current_buflen(state);
 	u32 *desc;
 	int sec4_sg_bytes, sec4_sg_src_index;
@@ -926,8 +926,8 @@ static int ahash_finup_ctx(struct ahash_request *req)
 	struct caam_hash_ctx *ctx = crypto_ahash_ctx(ahash);
 	struct caam_hash_state *state = ahash_request_ctx(req);
 	struct device *jrdev = ctx->jrdev;
-	gfp_t flags = (req->base.flags & (CRYPTO_TFM_REQ_MAY_BACKLOG |
-		       CRYPTO_TFM_REQ_MAY_SLEEP)) ? GFP_KERNEL : GFP_ATOMIC;
+	gfp_t flags = (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
+		       GFP_KERNEL : GFP_ATOMIC;
 	int buflen = *current_buflen(state);
 	u32 *desc;
 	int sec4_sg_src_index;
@@ -1013,8 +1013,8 @@ static int ahash_digest(struct ahash_request *req)
 	struct caam_hash_ctx *ctx = crypto_ahash_ctx(ahash);
 	struct caam_hash_state *state = ahash_request_ctx(req);
 	struct device *jrdev = ctx->jrdev;
-	gfp_t flags = (req->base.flags & (CRYPTO_TFM_REQ_MAY_BACKLOG |
-		       CRYPTO_TFM_REQ_MAY_SLEEP)) ? GFP_KERNEL : GFP_ATOMIC;
+	gfp_t flags = (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
+		       GFP_KERNEL : GFP_ATOMIC;
 	u32 *desc;
 	int digestsize = crypto_ahash_digestsize(ahash);
 	int src_nents, mapped_nents;
@@ -1093,8 +1093,8 @@ static int ahash_final_no_ctx(struct ahash_request *req)
 	struct caam_hash_ctx *ctx = crypto_ahash_ctx(ahash);
 	struct caam_hash_state *state = ahash_request_ctx(req);
 	struct device *jrdev = ctx->jrdev;
-	gfp_t flags = (req->base.flags & (CRYPTO_TFM_REQ_MAY_BACKLOG |
-		       CRYPTO_TFM_REQ_MAY_SLEEP)) ? GFP_KERNEL : GFP_ATOMIC;
+	gfp_t flags = (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
+		       GFP_KERNEL : GFP_ATOMIC;
 	u8 *buf = current_buf(state);
 	int buflen = *current_buflen(state);
 	u32 *desc;
@@ -1154,8 +1154,8 @@ static int ahash_update_no_ctx(struct ahash_request *req)
 	struct caam_hash_ctx *ctx = crypto_ahash_ctx(ahash);
 	struct caam_hash_state *state = ahash_request_ctx(req);
 	struct device *jrdev = ctx->jrdev;
-	gfp_t flags = (req->base.flags & (CRYPTO_TFM_REQ_MAY_BACKLOG |
-		       CRYPTO_TFM_REQ_MAY_SLEEP)) ? GFP_KERNEL : GFP_ATOMIC;
+	gfp_t flags = (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
+		       GFP_KERNEL : GFP_ATOMIC;
 	u8 *buf = current_buf(state);
 	int *buflen = current_buflen(state);
 	u8 *next_buf = alt_buf(state);
@@ -1280,8 +1280,8 @@ static int ahash_finup_no_ctx(struct ahash_request *req)
 	struct caam_hash_ctx *ctx = crypto_ahash_ctx(ahash);
 	struct caam_hash_state *state = ahash_request_ctx(req);
 	struct device *jrdev = ctx->jrdev;
-	gfp_t flags = (req->base.flags & (CRYPTO_TFM_REQ_MAY_BACKLOG |
-		       CRYPTO_TFM_REQ_MAY_SLEEP)) ? GFP_KERNEL : GFP_ATOMIC;
+	gfp_t flags = (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
+		       GFP_KERNEL : GFP_ATOMIC;
 	int buflen = *current_buflen(state);
 	u32 *desc;
 	int sec4_sg_bytes, sec4_sg_src_index, src_nents, mapped_nents;
@@ -1370,8 +1370,8 @@ static int ahash_update_first(struct ahash_request *req)
 	struct caam_hash_ctx *ctx = crypto_ahash_ctx(ahash);
 	struct caam_hash_state *state = ahash_request_ctx(req);
 	struct device *jrdev = ctx->jrdev;
-	gfp_t flags = (req->base.flags & (CRYPTO_TFM_REQ_MAY_BACKLOG |
-		       CRYPTO_TFM_REQ_MAY_SLEEP)) ? GFP_KERNEL : GFP_ATOMIC;
+	gfp_t flags = (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
+		       GFP_KERNEL : GFP_ATOMIC;
 	u8 *next_buf = alt_buf(state);
 	int *next_buflen = alt_buflen(state);
 	int to_hash;
diff --git a/drivers/crypto/caam/caampkc.c b/drivers/crypto/caam/caampkc.c
index 9c508ba6b0f1..7a897209f181 100644
--- a/drivers/crypto/caam/caampkc.c
+++ b/drivers/crypto/caam/caampkc.c
@@ -173,8 +173,8 @@ static struct rsa_edesc *rsa_edesc_alloc(struct akcipher_request *req,
 	struct caam_rsa_ctx *ctx = akcipher_tfm_ctx(tfm);
 	struct device *dev = ctx->dev;
 	struct rsa_edesc *edesc;
-	gfp_t flags = (req->base.flags & (CRYPTO_TFM_REQ_MAY_BACKLOG |
-		       CRYPTO_TFM_REQ_MAY_SLEEP)) ? GFP_KERNEL : GFP_ATOMIC;
+	gfp_t flags = (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
+		       GFP_KERNEL : GFP_ATOMIC;
 	int sgc;
 	int sec4_sg_index, sec4_sg_len = 0, sec4_sg_bytes;
 	int src_nents, dst_nents;
-- 
2.12.0.264.gd6db3f216544
