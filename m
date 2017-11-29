From: Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH RFC 4/4] crypto: stm32: convert to the new crypto engine API
Date: Wed, 29 Nov 2017 09:41:21 +0100
Message-ID: <20171129084121.9385-5-clabbe.montjoie@gmail.com>
References: <20171129084121.9385-1-clabbe.montjoie@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Corentin Labbe <clabbe.montjoie@gmail.com>
To: herbert@gondor.apana.org.au, alexandre.torgue@st.com,
        arei.gonglei@huawei.com, davem@davemloft.net, jasowang@redhat.com,
        mcoquelin.stm32@gmail.com, mst@redhat.com, fabien.dessenne@st.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171129084121.9385-1-clabbe.montjoie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This patch convert the driver to the new crypto engine API.

Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 drivers/crypto/stm32/stm32-hash.c | 22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/stm32/stm32-hash.c b/drivers/crypto/stm32/stm32-hash.c
index 4ca4a264a833..e3f9f7b04ce2 100644
--- a/drivers/crypto/stm32/stm32-hash.c
+++ b/drivers/crypto/stm32/stm32-hash.c
@@ -122,6 +122,7 @@ enum stm32_hash_data_format {
 #define HASH_DMA_THRESHOLD		50
 
 struct stm32_hash_ctx {
+	struct crypto_engine_reqctx enginectx;
 	struct stm32_hash_dev	*hdev;
 	unsigned long		flags;
 
@@ -811,7 +812,7 @@ static void stm32_hash_finish_req(struct ahash_request *req, int err)
 		rctx->flags |= HASH_FLAGS_ERRORS;
 	}
 
-	crypto_finalize_hash_request(hdev->engine, req, err);
+	crypto_finalize_request(hdev->engine, &req->base, err);
 }
 
 static int stm32_hash_hw_init(struct stm32_hash_dev *hdev,
@@ -828,15 +829,21 @@ static int stm32_hash_hw_init(struct stm32_hash_dev *hdev,
 	return 0;
 }
 
+static int stm32_hash_one_request(struct crypto_engine *engine,
+				  struct crypto_async_request *areq);
+static int stm32_hash_prepare_req(struct crypto_engine *engine,
+				  struct crypto_async_request *areq);
+
 static int stm32_hash_handle_queue(struct stm32_hash_dev *hdev,
 				   struct ahash_request *req)
 {
-	return crypto_transfer_hash_request_to_engine(hdev->engine, req);
+	return crypto_transfer_request_to_engine(hdev->engine, &req->base);
 }
 
 static int stm32_hash_prepare_req(struct crypto_engine *engine,
-				  struct ahash_request *req)
+				  struct crypto_async_request *areq)
 {
+	struct ahash_request *req = ahash_request_cast(areq);
 	struct stm32_hash_ctx *ctx = crypto_ahash_ctx(crypto_ahash_reqtfm(req));
 	struct stm32_hash_dev *hdev = stm32_hash_find_dev(ctx);
 	struct stm32_hash_request_ctx *rctx;
@@ -855,8 +862,9 @@ static int stm32_hash_prepare_req(struct crypto_engine *engine,
 }
 
 static int stm32_hash_one_request(struct crypto_engine *engine,
-				  struct ahash_request *req)
+				  struct crypto_async_request *areq)
 {
+	struct ahash_request *req = ahash_request_cast(areq);
 	struct stm32_hash_ctx *ctx = crypto_ahash_ctx(crypto_ahash_reqtfm(req));
 	struct stm32_hash_dev *hdev = stm32_hash_find_dev(ctx);
 	struct stm32_hash_request_ctx *rctx;
@@ -1033,6 +1041,9 @@ static int stm32_hash_cra_init_algs(struct crypto_tfm *tfm,
 	if (algs_hmac_name)
 		ctx->flags |= HASH_FLAGS_HMAC;
 
+	ctx->enginectx.op.do_one_request = stm32_hash_one_request;
+	ctx->enginectx.op.prepare_request = stm32_hash_prepare_req;
+	ctx->enginectx.op.unprepare_request = NULL;
 	return 0;
 }
 
@@ -1493,9 +1504,6 @@ static int stm32_hash_probe(struct platform_device *pdev)
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
