From: Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH 3/6] crypto: omap: convert to new crypto engine API
Date: Wed,  3 Jan 2018 21:11:06 +0100
Message-ID: <20180103201109.16077-4-clabbe.montjoie@gmail.com>
References: <20180103201109.16077-1-clabbe.montjoie@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, fabien.dessenne@st.com,
        Corentin Labbe <clabbe.montjoie@gmail.com>
To: alexandre.torgue@st.com, arei.gonglei@huawei.com, corbet@lwn.net,
        davem@davemloft.net, herbert@gondor.apana.org.au,
        jasowang@redhat.com, mcoquelin.stm32@gmail.com, mst@redhat.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180103201109.16077-1-clabbe.montjoie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This patch convert the driver to the new crypto engine API.

Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 drivers/crypto/omap-aes.c | 17 +++++++++++++----
 drivers/crypto/omap-aes.h |  3 +++
 drivers/crypto/omap-des.c | 20 ++++++++++++++++----
 3 files changed, 32 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
index fbec0a2e76dd..518b94628166 100644
--- a/drivers/crypto/omap-aes.c
+++ b/drivers/crypto/omap-aes.c
@@ -414,8 +414,9 @@ static int omap_aes_handle_queue(struct omap_aes_dev *dd,
 }
 
 static int omap_aes_prepare_req(struct crypto_engine *engine,
-				struct ablkcipher_request *req)
+				void *areq)
 {
+	struct ablkcipher_request *req = container_of(areq, struct ablkcipher_request, base);
 	struct omap_aes_ctx *ctx = crypto_ablkcipher_ctx(
 			crypto_ablkcipher_reqtfm(req));
 	struct omap_aes_reqctx *rctx = ablkcipher_request_ctx(req);
@@ -468,8 +469,9 @@ static int omap_aes_prepare_req(struct crypto_engine *engine,
 }
 
 static int omap_aes_crypt_req(struct crypto_engine *engine,
-			      struct ablkcipher_request *req)
+			      void *areq)
 {
+	struct ablkcipher_request *req = container_of(areq, struct ablkcipher_request, base);
 	struct omap_aes_reqctx *rctx = ablkcipher_request_ctx(req);
 	struct omap_aes_dev *dd = rctx->dd;
 
@@ -601,6 +603,11 @@ static int omap_aes_ctr_decrypt(struct ablkcipher_request *req)
 	return omap_aes_crypt(req, FLAGS_CTR);
 }
 
+static int omap_aes_prepare_req(struct crypto_engine *engine,
+				void *req);
+static int omap_aes_crypt_req(struct crypto_engine *engine,
+			      void *req);
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
index ebc5c0f11f03..c6a3b0490616 100644
--- a/drivers/crypto/omap-des.c
+++ b/drivers/crypto/omap-des.c
@@ -86,6 +86,7 @@
 #define FLAGS_OUT_DATA_ST_SHIFT	10
 
 struct omap_des_ctx {
+	struct crypto_engine_reqctx enginectx;
 	struct omap_des_dev *dd;
 
 	int		keylen;
@@ -526,8 +527,9 @@ static int omap_des_handle_queue(struct omap_des_dev *dd,
 }
 
 static int omap_des_prepare_req(struct crypto_engine *engine,
-				struct ablkcipher_request *req)
+				void *areq)
 {
+	struct ablkcipher_request *req = container_of(areq, struct ablkcipher_request, base);
 	struct omap_des_ctx *ctx = crypto_ablkcipher_ctx(
 			crypto_ablkcipher_reqtfm(req));
 	struct omap_des_dev *dd = omap_des_find_dev(ctx);
@@ -582,8 +584,9 @@ static int omap_des_prepare_req(struct crypto_engine *engine,
 }
 
 static int omap_des_crypt_req(struct crypto_engine *engine,
-			      struct ablkcipher_request *req)
+			      void *areq)
 {
+	struct ablkcipher_request *req = container_of(areq, struct ablkcipher_request, base);
 	struct omap_des_ctx *ctx = crypto_ablkcipher_ctx(
 			crypto_ablkcipher_reqtfm(req));
 	struct omap_des_dev *dd = omap_des_find_dev(ctx);
@@ -695,12 +698,23 @@ static int omap_des_cbc_decrypt(struct ablkcipher_request *req)
 	return omap_des_crypt(req, FLAGS_CBC);
 }
 
+static int omap_des_prepare_req(struct crypto_engine *engine,
+				void *areq);
+static int omap_des_crypt_req(struct crypto_engine *engine,
+			      void *areq);
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
