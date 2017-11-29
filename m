From: Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH RFC 2/4] crypto: omap: convert to new crypto engine API
Date: Wed, 29 Nov 2017 09:41:19 +0100
Message-ID: <20171129084121.9385-3-clabbe.montjoie@gmail.com>
References: <20171129084121.9385-1-clabbe.montjoie@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: virtualization@lists.linux-foundation.org,
	Corentin Labbe <clabbe.montjoie@gmail.com>, linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
To: herbert@gondor.apana.org.au, alexandre.torgue@st.com,
	arei.gonglei@huawei.com, davem@davemloft.net, jasowang@redhat.com,
	mcoquelin.stm32@gmail.com, mst@redhat.com, fabien.dessenne@st.com
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <20171129084121.9385-1-clabbe.montjoie@gmail.com>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
List-Id: linux-crypto.vger.kernel.org

This patch convert the driver to the new crypto engine API.

Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 drivers/crypto/omap-aes.c | 21 +++++++++++++++------
 drivers/crypto/omap-aes.h |  3 +++
 drivers/crypto/omap-des.c | 24 ++++++++++++++++++------
 3 files changed, 36 insertions(+), 12 deletions(-)

diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
index fbec0a2e76dd..4a31bbfca9a4 100644
--- a/drivers/crypto/omap-aes.c
+++ b/drivers/crypto/omap-aes.c
@@ -388,7 +388,7 @@ static void omap_aes_finish_req(struct omap_aes_dev *dd, int err)
 
 	pr_debug("err: %d\n", err);
 
-	crypto_finalize_cipher_request(dd->engine, req, err);
+	crypto_finalize_request(dd->engine, &req->base, err);
 
 	pm_runtime_mark_last_busy(dd->dev);
 	pm_runtime_put_autosuspend(dd->dev);
@@ -408,14 +408,15 @@ static int omap_aes_handle_queue(struct omap_aes_dev *dd,
 				 struct ablkcipher_request *req)
 {
 	if (req)
-		return crypto_transfer_cipher_request_to_engine(dd->engine, req);
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
 	struct omap_aes_reqctx *rctx = ablkcipher_request_ctx(req);
@@ -468,8 +469,9 @@ static int omap_aes_prepare_req(struct crypto_engine *engine,
 }
 
 static int omap_aes_crypt_req(struct crypto_engine *engine,
-			      struct ablkcipher_request *req)
+			      struct crypto_async_request *areq)
 {
+	struct ablkcipher_request *req = ablkcipher_request_cast(areq);
 	struct omap_aes_reqctx *rctx = ablkcipher_request_ctx(req);
 	struct omap_aes_dev *dd = rctx->dd;
 
@@ -601,6 +603,11 @@ static int omap_aes_ctr_decrypt(struct ablkcipher_request *req)
 	return omap_aes_crypt(req, FLAGS_CTR);
 }
 
+static int omap_aes_prepare_req(struct crypto_engine *engine,
+				struct crypto_async_request *req);
+static int omap_aes_crypt_req(struct crypto_engine *engine,
+			      struct crypto_async_request *req);
+
 static int omap_aes_cra_init(struct crypto_tfm *tfm)
 {
 	const char *name = crypto_tfm_alg_name(tfm);
@@ -616,6 +623,10 @@ static int omap_aes_cra_init(struct crypto_tfm *tfm)
 
 	tfm->crt_ablkcipher.reqsize = sizeof(struct omap_aes_reqctx);
 
+	ctx->enginectx.op.prepare_request = omap_aes_prepare_req;
+	ctx->enginectx.op.unprepare_request = NULL;
+	ctx->enginectx.op.do_one_request = omap_aes_crypt_req;
+
 	return 0;
 }
 
@@ -1119,8 +1130,6 @@ static int omap_aes_probe(struct platform_device *pdev)
 		goto err_engine;
 	}
 
-	dd->engine->prepare_cipher_request = omap_aes_prepare_req;
-	dd->engine->cipher_one_request = omap_aes_crypt_req;
 	err = crypto_engine_start(dd->engine);
 	if (err)
 		goto err_engine;
diff --git a/drivers/crypto/omap-aes.h b/drivers/crypto/omap-aes.h
index 8906342e2b9a..f6ce94907ade 100644
--- a/drivers/crypto/omap-aes.h
+++ b/drivers/crypto/omap-aes.h
@@ -13,6 +13,8 @@
 #ifndef __OMAP_AES_H__
 #define __OMAP_AES_H__
 
+#include <crypto/engine.h>
+
 #define DST_MAXBURST			4
 #define DMA_MIN				(DST_MAXBURST * sizeof(u32))
 
@@ -95,6 +97,7 @@ struct omap_aes_gcm_result {
 };
 
 struct omap_aes_ctx {
+	struct crypto_engine_reqctx enginectx;
 	int		keylen;
 	u32		key[AES_KEYSIZE_256 / sizeof(u32)];
 	u8		nonce[4];
diff --git a/drivers/crypto/omap-des.c b/drivers/crypto/omap-des.c
index ebc5c0f11f03..94212248159e 100644
--- a/drivers/crypto/omap-des.c
+++ b/drivers/crypto/omap-des.c
@@ -86,6 +86,7 @@
 #define FLAGS_OUT_DATA_ST_SHIFT	10
 
 struct omap_des_ctx {
+	struct crypto_engine_reqctx enginectx;
 	struct omap_des_dev *dd;
 
 	int		keylen;
@@ -498,7 +499,7 @@ static void omap_des_finish_req(struct omap_des_dev *dd, int err)
 
 	pr_debug("err: %d\n", err);
 
-	crypto_finalize_cipher_request(dd->engine, req, err);
+	crypto_finalize_request(dd->engine, &req->base, err);
 
 	pm_runtime_mark_last_busy(dd->dev);
 	pm_runtime_put_autosuspend(dd->dev);
@@ -520,14 +521,15 @@ static int omap_des_handle_queue(struct omap_des_dev *dd,
 				 struct ablkcipher_request *req)
 {
 	if (req)
-		return crypto_transfer_cipher_request_to_engine(dd->engine, req);
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
@@ -582,8 +584,9 @@ static int omap_des_prepare_req(struct crypto_engine *engine,
 }
 
 static int omap_des_crypt_req(struct crypto_engine *engine,
-			      struct ablkcipher_request *req)
+			      struct crypto_async_request *areq)
 {
+	struct ablkcipher_request *req = ablkcipher_request_cast(areq);
 	struct omap_des_ctx *ctx = crypto_ablkcipher_ctx(
 			crypto_ablkcipher_reqtfm(req));
 	struct omap_des_dev *dd = omap_des_find_dev(ctx);
@@ -695,12 +698,23 @@ static int omap_des_cbc_decrypt(struct ablkcipher_request *req)
 	return omap_des_crypt(req, FLAGS_CBC);
 }
 
+static int omap_des_prepare_req(struct crypto_engine *engine,
+				struct crypto_async_request *areq);
+static int omap_des_crypt_req(struct crypto_engine *engine,
+			      struct crypto_async_request *areq);
+
 static int omap_des_cra_init(struct crypto_tfm *tfm)
 {
+	struct omap_des_ctx *ctx = crypto_tfm_ctx(tfm);
+
 	pr_debug("enter\n");
 
 	tfm->crt_ablkcipher.reqsize = sizeof(struct omap_des_reqctx);
 
+	ctx->enginectx.op.prepare_request = omap_des_prepare_req;
+	ctx->enginectx.op.unprepare_request = NULL;
+	ctx->enginectx.op.do_one_request = omap_des_crypt_req;
+
 	return 0;
 }
 
@@ -1046,8 +1060,6 @@ static int omap_des_probe(struct platform_device *pdev)
 		goto err_engine;
 	}
 
-	dd->engine->prepare_cipher_request = omap_des_prepare_req;
-	dd->engine->cipher_one_request = omap_des_crypt_req;
 	err = crypto_engine_start(dd->engine);
 	if (err)
 		goto err_engine;
-- 
2.13.6
