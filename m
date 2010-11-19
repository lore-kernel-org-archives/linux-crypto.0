From: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Subject: [PATCH v3 1/8] omap-sham: uses digest buffer in request context
Date: Fri, 19 Nov 2010 16:04:22 +0200
Message-ID: <69a055298432b7a5ebe4025b76c8a8b30b4d9abf.1290174993.git.dmitry.kasatkin@nokia.com>
References: <cover.1290174993.git.dmitry.kasatkin@nokia.com>
Cc: linux-crypto@vger.kernel.org, linux-omap@vger.kernel.org
To: herbert@gondor.hengli.com.au
Return-path: <linux-omap-owner@vger.kernel.org>
In-Reply-To: <cover.1290174993.git.dmitry.kasatkin@nokia.com>
In-Reply-To: <cover.1290174993.git.dmitry.kasatkin@nokia.com>
References: <cover.1290174993.git.dmitry.kasatkin@nokia.com>
Sender: linux-omap-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Currently driver storred digest results in req->results
provided by the client. But some clients do not set it
until final() call. It leads to crash.
Changed to use internal buffer to store temporary digest results.

Signed-off-by: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
---
 drivers/crypto/omap-sham.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
index a081c7c..2222370 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -97,6 +97,7 @@ struct omap_sham_reqctx {
 	unsigned long		flags;
 	unsigned long		op;
 
+	u8			digest[SHA1_DIGEST_SIZE];
 	size_t			digcnt;
 	u8			*buffer;
 	size_t			bufcnt;
@@ -194,7 +195,7 @@ static inline int omap_sham_wait(struct omap_sham_dev *dd, u32 offset, u32 bit)
 static void omap_sham_copy_hash(struct ahash_request *req, int out)
 {
 	struct omap_sham_reqctx *ctx = ahash_request_ctx(req);
-	u32 *hash = (u32 *)req->result;
+	u32 *hash = (u32 *)ctx->digest;
 	int i;
 
 	if (likely(ctx->flags & FLAGS_SHA1)) {
@@ -453,8 +454,11 @@ static void omap_sham_cleanup(struct ahash_request *req)
 	ctx->flags |= FLAGS_CLEAN;
 	spin_unlock_irqrestore(&dd->lock, flags);
 
-	if (ctx->digcnt)
+	if (ctx->digcnt) {
 		clk_disable(dd->iclk);
+		memcpy(req->result, ctx->digest, (ctx->flags & FLAGS_SHA1) ?
+				SHA1_DIGEST_SIZE : MD5_DIGEST_SIZE);
+	}
 
 	if (ctx->dma_addr)
 		dma_unmap_single(dd->dev, ctx->dma_addr, ctx->buflen,
@@ -576,6 +580,7 @@ static int omap_sham_final_req(struct omap_sham_dev *dd)
 
 static int omap_sham_finish_req_hmac(struct ahash_request *req)
 {
+	struct omap_sham_reqctx *ctx = ahash_request_ctx(req);
 	struct omap_sham_ctx *tctx = crypto_tfm_ctx(req->base.tfm);
 	struct omap_sham_hmac_ctx *bctx = tctx->base;
 	int bs = crypto_shash_blocksize(bctx->shash);
@@ -590,7 +595,7 @@ static int omap_sham_finish_req_hmac(struct ahash_request *req)
 
 	return crypto_shash_init(&desc.shash) ?:
 	       crypto_shash_update(&desc.shash, bctx->opad, bs) ?:
-	       crypto_shash_finup(&desc.shash, req->result, ds, req->result);
+	       crypto_shash_finup(&desc.shash, ctx->digest, ds, ctx->digest);
 }
 
 static void omap_sham_finish_req(struct ahash_request *req, int err)
-- 
1.7.0.4

