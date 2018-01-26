From: Corentin Labbe <clabbe.montjoie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 3/6] crypto: omap: convert to new crypto
 engine API
Date: Fri, 26 Jan 2018 20:15:31 +0100
Message-ID: <20180126191534.17569-4-clabbe.montjoie@gmail.com>
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
Return-path: <linux-sunxi+bncBD7YLCN32UNBB4P5VXJQKGQE6BMUF3I-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Sender: linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
In-Reply-To: <20180126191534.17569-1-clabbe.montjoie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Post: <https://groups.google.com/group/linux-sunxi/post>, <mailto:linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <https://groups.google.com/support/>, <mailto:linux-sunxi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <https://groups.google.com/group/linux-sunxi
List-Subscribe: <https://groups.google.com/group/linux-sunxi/subscribe>, <mailto:linux-sunxi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+1076902468213+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <https://groups.google.com/group/linux-sunxi/subscribe>
List-Id: linux-crypto.vger.kernel.org

This patch convert the driver to the new crypto engine API.

Signed-off-by: Corentin Labbe <clabbe.montjoie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 drivers/crypto/omap-aes.c | 21 +++++++++++++++------
 drivers/crypto/omap-aes.h |  3 +++
 drivers/crypto/omap-des.c | 24 ++++++++++++++++++------
 3 files changed, 36 insertions(+), 12 deletions(-)

diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
index fbec0a2e76dd..5bd383ed3dec 100644
--- a/drivers/crypto/omap-aes.c
+++ b/drivers/crypto/omap-aes.c
@@ -388,7 +388,7 @@ static void omap_aes_finish_req(struct omap_aes_dev *dd, int err)
 
 	pr_debug("err: %d\n", err);
 
-	crypto_finalize_cipher_request(dd->engine, req, err);
+	crypto_finalize_ablkcipher_request(dd->engine, req, err);
 
 	pm_runtime_mark_last_busy(dd->dev);
 	pm_runtime_put_autosuspend(dd->dev);
@@ -408,14 +408,15 @@ static int omap_aes_handle_queue(struct omap_aes_dev *dd,
 				 struct ablkcipher_request *req)
 {
 	if (req)
-		return crypto_transfer_cipher_request_to_engine(dd->engine, req);
+		return crypto_transfer_ablkcipher_request_to_engine(dd->engine, req);
 
 	return 0;
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
index 8906342e2b9a..fc3b46a85809 100644
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
+	struct crypto_engine_ctx enginectx;
 	int		keylen;
 	u32		key[AES_KEYSIZE_256 / sizeof(u32)];
 	u8		nonce[4];
diff --git a/drivers/crypto/omap-des.c b/drivers/crypto/omap-des.c
index ebc5c0f11f03..eb95b0d7f184 100644
--- a/drivers/crypto/omap-des.c
+++ b/drivers/crypto/omap-des.c
@@ -86,6 +86,7 @@
 #define FLAGS_OUT_DATA_ST_SHIFT	10
 
 struct omap_des_ctx {
+	struct crypto_engine_ctx enginectx;
 	struct omap_des_dev *dd;
 
 	int		keylen;
@@ -498,7 +499,7 @@ static void omap_des_finish_req(struct omap_des_dev *dd, int err)
 
 	pr_debug("err: %d\n", err);
 
-	crypto_finalize_cipher_request(dd->engine, req, err);
+	crypto_finalize_ablkcipher_request(dd->engine, req, err);
 
 	pm_runtime_mark_last_busy(dd->dev);
 	pm_runtime_put_autosuspend(dd->dev);
@@ -520,14 +521,15 @@ static int omap_des_handle_queue(struct omap_des_dev *dd,
 				 struct ablkcipher_request *req)
 {
 	if (req)
-		return crypto_transfer_cipher_request_to_engine(dd->engine, req);
+		return crypto_transfer_ablkcipher_request_to_engine(dd->engine, req);
 
 	return 0;
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
