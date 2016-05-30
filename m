From: LABBE Corentin <clabbe.montjoie@gmail.com>
Subject: [PATCH v2 2/2] crypto: omap: convert to the new cryptoengine API
Date: Mon, 30 May 2016 15:32:02 +0200
Message-ID: <1464615122-16685-3-git-send-email-clabbe.montjoie@gmail.com>
References: <1464615122-16685-1-git-send-email-clabbe.montjoie@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	LABBE Corentin <clabbe.montjoie@gmail.com>
To: herbert@gondor.apana.org.au, davem@davemloft.net,
	baolin.wang@linaro.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1464615122-16685-1-git-send-email-clabbe.montjoie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Since the crypto engine has been converted to use crypto_async_request
instead of ablkcipher_request, minor changes are needed to use it.

Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
---
 drivers/crypto/omap-aes.c | 10 ++++++----
 drivers/crypto/omap-des.c | 10 ++++++----
 2 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
index ce174d3..7007f13 100644
--- a/drivers/crypto/omap-aes.c
+++ b/drivers/crypto/omap-aes.c
@@ -519,7 +519,7 @@ static void omap_aes_finish_req(struct omap_aes_dev *dd, int err)
 
 	pr_debug("err: %d\n", err);
 
-	crypto_finalize_request(dd->engine, req, err);
+	crypto_finalize_request(dd->engine, &req->base, err);
 }
 
 static int omap_aes_crypt_dma_stop(struct omap_aes_dev *dd)
@@ -592,14 +592,15 @@ static int omap_aes_handle_queue(struct omap_aes_dev *dd,
 				 struct ablkcipher_request *req)
 {
 	if (req)
-		return crypto_transfer_request_to_engine(dd->engine, req);
+		return crypto_transfer_request_to_engine(dd->engine, &req->base);
 
 	return 0;
 }
 
 static int omap_aes_prepare_req(struct crypto_engine *engine,
-				struct ablkcipher_request *req)
+				struct crypto_async_request *areq)
 {
+	struct ablkcipher_request *req = ablkcipher_request_cast(areq);
 	struct omap_aes_ctx *ctx = crypto_ablkcipher_ctx(
 			crypto_ablkcipher_reqtfm(req));
 	struct omap_aes_dev *dd = omap_aes_find_dev(ctx);
@@ -642,8 +643,9 @@ static int omap_aes_prepare_req(struct crypto_engine *engine,
 }
 
 static int omap_aes_crypt_req(struct crypto_engine *engine,
-			      struct ablkcipher_request *req)
+			      struct crypto_async_request *areq)
 {
+	struct ablkcipher_request *req = ablkcipher_request_cast(areq);
 	struct omap_aes_ctx *ctx = crypto_ablkcipher_ctx(
 			crypto_ablkcipher_reqtfm(req));
 	struct omap_aes_dev *dd = omap_aes_find_dev(ctx);
diff --git a/drivers/crypto/omap-des.c b/drivers/crypto/omap-des.c
index 3eedb03..0da5686 100644
--- a/drivers/crypto/omap-des.c
+++ b/drivers/crypto/omap-des.c
@@ -506,7 +506,7 @@ static void omap_des_finish_req(struct omap_des_dev *dd, int err)
 	pr_debug("err: %d\n", err);
 
 	pm_runtime_put(dd->dev);
-	crypto_finalize_request(dd->engine, req, err);
+	crypto_finalize_request(dd->engine, &req->base, err);
 }
 
 static int omap_des_crypt_dma_stop(struct omap_des_dev *dd)
@@ -572,14 +572,15 @@ static int omap_des_handle_queue(struct omap_des_dev *dd,
 				 struct ablkcipher_request *req)
 {
 	if (req)
-		return crypto_transfer_request_to_engine(dd->engine, req);
+		return crypto_transfer_request_to_engine(dd->engine, &req->base);
 
 	return 0;
 }
 
 static int omap_des_prepare_req(struct crypto_engine *engine,
-				struct ablkcipher_request *req)
+				struct crypto_async_request *areq)
 {
+	struct ablkcipher_request *req = ablkcipher_request_cast(areq);
 	struct omap_des_ctx *ctx = crypto_ablkcipher_ctx(
 			crypto_ablkcipher_reqtfm(req));
 	struct omap_des_dev *dd = omap_des_find_dev(ctx);
@@ -620,8 +621,9 @@ static int omap_des_prepare_req(struct crypto_engine *engine,
 }
 
 static int omap_des_crypt_req(struct crypto_engine *engine,
-			      struct ablkcipher_request *req)
+			      struct crypto_async_request *areq)
 {
+	struct ablkcipher_request *req = ablkcipher_request_cast(areq);
 	struct omap_des_ctx *ctx = crypto_ablkcipher_ctx(
 			crypto_ablkcipher_reqtfm(req));
 	struct omap_des_dev *dd = omap_des_find_dev(ctx);
-- 
2.7.3
