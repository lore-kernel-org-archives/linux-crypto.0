From: Corentin Labbe <clabbe.montjoie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 5/6] crypto: stm32-hash: convert to the new
 crypto engine API
Date: Fri, 26 Jan 2018 20:15:33 +0100
Message-ID: <20180126191534.17569-6-clabbe.montjoie@gmail.com>
References: <20180126191534.17569-1-clabbe.montjoie@gmail.com>
Reply-To: clabbe.montjoie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org,
	linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	virtualization-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org,
	linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org,
	Corentin Labbe <clabbe.montjoie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: alexandre.torgue-qxv4g6HH51o@public.gmane.org,
	arei.gonglei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org,
	corbet-T1hC0tSOHrs@public.gmane.org,
	davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org,
	herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org,
	jasowang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
	mcoquelin.stm32-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org,
	mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
	fabien.dessenne-qxv4g6HH51o@public.gmane.org
Return-path: <linux-sunxi+bncBD7YLCN32UNBB5X5VXJQKGQEVP6J2HY-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Sender: linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
In-Reply-To: <20180126191534.17569-1-clabbe.montjoie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Post: <https://groups.google.com/group/linux-sunxi/post>, <mailto:linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <https://groups.google.com/support/>, <mailto:linux-sunxi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <https://groups.google.com/group/linux-sunxi
List-Subscribe: <https://groups.google.com/group/linux-sunxi/subscribe>, <mailto:linux-sunxi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+1076902468213+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <https://groups.google.com/group/linux-sunxi/subscribe>
List-Id: linux-crypto.vger.kernel.org

This patch convert the stm32-hash driver to the new crypto engine API.

Signed-off-by: Corentin Labbe <clabbe.montjoie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Tested-by: Fabien Dessenne <fabien.dessenne-qxv4g6HH51o@public.gmane.org>
---
 drivers/crypto/stm32/stm32-hash.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/stm32/stm32-hash.c b/drivers/crypto/stm32/stm32-hash.c
index 4ca4a264a833..89b0c2490d80 100644
--- a/drivers/crypto/stm32/stm32-hash.c
+++ b/drivers/crypto/stm32/stm32-hash.c
@@ -122,6 +122,7 @@ enum stm32_hash_data_format {
 #define HASH_DMA_THRESHOLD		50
 
 struct stm32_hash_ctx {
+	struct crypto_engine_ctx enginectx;
 	struct stm32_hash_dev	*hdev;
 	unsigned long		flags;
 
@@ -828,15 +829,19 @@ static int stm32_hash_hw_init(struct stm32_hash_dev *hdev,
 	return 0;
 }
 
+static int stm32_hash_one_request(struct crypto_engine *engine, void *areq);
+static int stm32_hash_prepare_req(struct crypto_engine *engine, void *areq);
+
 static int stm32_hash_handle_queue(struct stm32_hash_dev *hdev,
 				   struct ahash_request *req)
 {
 	return crypto_transfer_hash_request_to_engine(hdev->engine, req);
 }
 
-static int stm32_hash_prepare_req(struct crypto_engine *engine,
-				  struct ahash_request *req)
+static int stm32_hash_prepare_req(struct crypto_engine *engine, void *areq)
 {
+	struct ahash_request *req = container_of(areq, struct ahash_request,
+						 base);
 	struct stm32_hash_ctx *ctx = crypto_ahash_ctx(crypto_ahash_reqtfm(req));
 	struct stm32_hash_dev *hdev = stm32_hash_find_dev(ctx);
 	struct stm32_hash_request_ctx *rctx;
@@ -854,9 +859,10 @@ static int stm32_hash_prepare_req(struct crypto_engine *engine,
 	return stm32_hash_hw_init(hdev, rctx);
 }
 
-static int stm32_hash_one_request(struct crypto_engine *engine,
-				  struct ahash_request *req)
+static int stm32_hash_one_request(struct crypto_engine *engine, void *areq)
 {
+	struct ahash_request *req = container_of(areq, struct ahash_request,
+						 base);
 	struct stm32_hash_ctx *ctx = crypto_ahash_ctx(crypto_ahash_reqtfm(req));
 	struct stm32_hash_dev *hdev = stm32_hash_find_dev(ctx);
 	struct stm32_hash_request_ctx *rctx;
@@ -1033,6 +1039,9 @@ static int stm32_hash_cra_init_algs(struct crypto_tfm *tfm,
 	if (algs_hmac_name)
 		ctx->flags |= HASH_FLAGS_HMAC;
 
+	ctx->enginectx.op.do_one_request = stm32_hash_one_request;
+	ctx->enginectx.op.prepare_request = stm32_hash_prepare_req;
+	ctx->enginectx.op.unprepare_request = NULL;
 	return 0;
 }
 
@@ -1493,9 +1502,6 @@ static int stm32_hash_probe(struct platform_device *pdev)
 		goto err_engine;
 	}
 
-	hdev->engine->prepare_hash_request = stm32_hash_prepare_req;
-	hdev->engine->hash_one_request = stm32_hash_one_request;
-
 	ret = crypto_engine_start(hdev->engine);
 	if (ret)
 		goto err_engine_start;
-- 
2.13.6
