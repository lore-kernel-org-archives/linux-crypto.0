From: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Subject: [PATCH 4/4] crypto: omap-sham - hmac calculation bug fix for sha1 base hash
Date: Wed, 20 Apr 2011 13:34:58 +0300
Message-ID: <37ae71e1cebcd6e46432036189f6750e27f4d1a1.1303295558.git.dmitry.kasatkin@nokia.com>
References: <cover.1303295558.git.dmitry.kasatkin@nokia.com>
Cc: linux-crypto@vger.kernel.org, linux-omap@vger.kernel.org
To: herbert@gondor.hengli.com.au
Return-path: <linux-omap-owner@vger.kernel.org>
In-Reply-To: <cover.1303295558.git.dmitry.kasatkin@nokia.com>
In-Reply-To: <cover.1303295558.git.dmitry.kasatkin@nokia.com>
References: <cover.1303295558.git.dmitry.kasatkin@nokia.com>
Sender: linux-omap-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This patch fixes 2 hmac inter-dependent bugs.

1. "omap-sham: hash-in-progress is stored in hw format" commit introduced
optimization where temporary hash had been stored in OMAP specific format
(big endian).
For SHA1 it is different to real hash format, which is little endian.
Final HMAC value was calculated using incorrect hash.
Because CONFIG_CRYPTO_MANAGER_TESTS was disabled this error remained
unnoticed. After enabling this option, bug has been found.

2. HMAC was calculated using temporrary hash value.
For a single-request updates, temporary hash was the final one and
HMAC result was correct. But in fact only the final hash had to be used.
All crypto tests for HMAC produces only single request and
could not catch the problem. This problem is fixed here.

Signed-off-by: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
---
 drivers/crypto/omap-sham.c |   71 +++++++++++++++++++------------------------
 1 files changed, 31 insertions(+), 40 deletions(-)

diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
index f5c01dc..ba8f1ea 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -78,7 +78,6 @@
 #define FLAGS_SHA1		0x0010
 #define FLAGS_DMA_ACTIVE	0x0020
 #define FLAGS_OUTPUT_READY	0x0040
-#define FLAGS_CLEAN		0x0080
 #define FLAGS_INIT		0x0100
 #define FLAGS_CPU		0x0200
 #define FLAGS_HMAC		0x0400
@@ -511,26 +510,6 @@ static int omap_sham_update_dma_stop(struct omap_sham_dev *dd)
 	return 0;
 }
 
-static void omap_sham_cleanup(struct ahash_request *req)
-{
-	struct omap_sham_reqctx *ctx = ahash_request_ctx(req);
-	struct omap_sham_dev *dd = ctx->dd;
-	unsigned long flags;
-
-	spin_lock_irqsave(&dd->lock, flags);
-	if (ctx->flags & FLAGS_CLEAN) {
-		spin_unlock_irqrestore(&dd->lock, flags);
-		return;
-	}
-	ctx->flags |= FLAGS_CLEAN;
-	spin_unlock_irqrestore(&dd->lock, flags);
-
-	if (ctx->digcnt)
-		omap_sham_copy_ready_hash(req);
-
-	dev_dbg(dd->dev, "digcnt: %d, bufcnt: %d\n", ctx->digcnt, ctx->bufcnt);
-}
-
 static int omap_sham_init(struct ahash_request *req)
 {
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
@@ -618,9 +597,8 @@ static int omap_sham_final_req(struct omap_sham_dev *dd)
 	return err;
 }
 
-static int omap_sham_finish_req_hmac(struct ahash_request *req)
+static int omap_sham_finish_hmac(struct ahash_request *req)
 {
-	struct omap_sham_reqctx *ctx = ahash_request_ctx(req);
 	struct omap_sham_ctx *tctx = crypto_tfm_ctx(req->base.tfm);
 	struct omap_sham_hmac_ctx *bctx = tctx->base;
 	int bs = crypto_shash_blocksize(bctx->shash);
@@ -635,7 +613,24 @@ static int omap_sham_finish_req_hmac(struct ahash_request *req)
 
 	return crypto_shash_init(&desc.shash) ?:
 	       crypto_shash_update(&desc.shash, bctx->opad, bs) ?:
-	       crypto_shash_finup(&desc.shash, ctx->digest, ds, ctx->digest);
+	       crypto_shash_finup(&desc.shash, req->result, ds, req->result);
+}
+
+static int omap_sham_finish(struct ahash_request *req)
+{
+	struct omap_sham_reqctx *ctx = ahash_request_ctx(req);
+	struct omap_sham_dev *dd = ctx->dd;
+	int err = 0;
+
+	if (ctx->digcnt) {
+		omap_sham_copy_ready_hash(req);
+		if (ctx->flags & FLAGS_HMAC)
+			err = omap_sham_finish_hmac(req);
+	}
+
+	dev_dbg(dd->dev, "digcnt: %d, bufcnt: %d\n", ctx->digcnt, ctx->bufcnt);
+
+	return err;
 }
 
 static void omap_sham_finish_req(struct ahash_request *req, int err)
@@ -645,15 +640,12 @@ static void omap_sham_finish_req(struct ahash_request *req, int err)
 
 	if (!err) {
 		omap_sham_copy_hash(ctx->dd->req, 1);
-		if (ctx->flags & FLAGS_HMAC)
-			err = omap_sham_finish_req_hmac(req);
+		if (ctx->flags & FLAGS_FINAL)
+			err = omap_sham_finish(req);
 	} else {
 		ctx->flags |= FLAGS_ERROR;
 	}
 
-	if ((ctx->flags & FLAGS_FINAL) || err)
-		omap_sham_cleanup(req);
-
 	clk_disable(dd->iclk);
 	dd->flags &= ~FLAGS_BUSY;
 
@@ -809,22 +801,21 @@ static int omap_sham_final_shash(struct ahash_request *req)
 static int omap_sham_final(struct ahash_request *req)
 {
 	struct omap_sham_reqctx *ctx = ahash_request_ctx(req);
-	int err = 0;
 
 	ctx->flags |= FLAGS_FINUP;
 
-	if (!(ctx->flags & FLAGS_ERROR)) {
-		/* OMAP HW accel works only with buffers >= 9 */
-		/* HMAC is always >= 9 because of ipad */
-		if ((ctx->digcnt + ctx->bufcnt) < 9)
-			err = omap_sham_final_shash(req);
-		else if (ctx->bufcnt)
-			return omap_sham_enqueue(req, OP_FINAL);
-	}
+	if (ctx->flags & FLAGS_ERROR)
+		return 0; /* uncompleted hash is not needed */
 
-	omap_sham_cleanup(req);
+	/* OMAP HW accel works only with buffers >= 9 */
+	/* HMAC is always >= 9 because ipad == block size */
+	if ((ctx->digcnt + ctx->bufcnt) < 9)
+		return omap_sham_final_shash(req);
+	else if (ctx->bufcnt)
+		return omap_sham_enqueue(req, OP_FINAL);
 
-	return err;
+	/* copy ready hash (+ finalize hmac) */
+	return omap_sham_finish(req);
 }
 
 static int omap_sham_finup(struct ahash_request *req)
-- 
1.7.1

