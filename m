From: LABBE Corentin <clabbe.montjoie@gmail.com>
Subject: [PATCH 2/2] crypto: omap: convert to the new cryptoengine API
Date: Wed, 18 May 2016 11:21:25 +0200
Message-ID: <1463563285-11742-3-git-send-email-clabbe.montjoie@gmail.com>
References: <1463563285-11742-1-git-send-email-clabbe.montjoie@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	LABBE Corentin <clabbe.montjoie@gmail.com>
To: baolin.wang@linaro.org, herbert@gondor.apana.org.au,
	davem@davemloft.net
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1463563285-11742-1-git-send-email-clabbe.montjoie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Since the crypto engine has been converted to use crypto_async_request
instead of ablkcipher_request, minor changes are needed to use it.

Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
---
 drivers/crypto/omap-aes.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
index d420ec7..1368ab1 100644
--- a/drivers/crypto/omap-aes.c
+++ b/drivers/crypto/omap-aes.c
@@ -530,7 +530,7 @@ static void omap_aes_finish_req(struct omap_aes_dev *dd, int err)
 
 	pr_debug("err: %d\n", err);
 
-	crypto_finalize_request(dd->engine, req, err);
+	crypto_finalize_request(dd->engine, &req->base, err);
 }
 
 static int omap_aes_crypt_dma_stop(struct omap_aes_dev *dd)
@@ -603,14 +603,15 @@ static int omap_aes_handle_queue(struct omap_aes_dev *dd,
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
@@ -653,8 +654,9 @@ static int omap_aes_prepare_req(struct crypto_engine *engine,
 }
 
 static int omap_aes_crypt_req(struct crypto_engine *engine,
-			      struct ablkcipher_request *req)
+			      struct crypto_async_request *areq)
 {
+	struct ablkcipher_request *req = ablkcipher_request_cast(areq);
 	struct omap_aes_ctx *ctx = crypto_ablkcipher_ctx(
 			crypto_ablkcipher_reqtfm(req));
 	struct omap_aes_dev *dd = omap_aes_find_dev(ctx);
-- 
2.7.3
