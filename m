From: Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH v2 6/6] crypto: stm32-cryp: convert to the new crypto engine API
Date: Fri, 26 Jan 2018 20:15:34 +0100
Message-ID: <20180126191534.17569-7-clabbe.montjoie@gmail.com>
References: <20180126191534.17569-1-clabbe.montjoie@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe.montjoie@gmail.com>
To: alexandre.torgue@st.com, arei.gonglei@huawei.com, corbet@lwn.net,
        davem@davemloft.net, herbert@gondor.apana.org.au,
        jasowang@redhat.com, mcoquelin.stm32@gmail.com, mst@redhat.com,
        fabien.dessenne@st.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180126191534.17569-1-clabbe.montjoie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This patch convert the stm32-cryp driver to the new crypto engine API.
Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
Tested-by: Fabien Dessenne <fabien.dessenne@st.com>
---
 drivers/crypto/stm32/stm32-cryp.c | 29 +++++++++++++++++++++--------
 1 file changed, 21 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/stm32/stm32-cryp.c b/drivers/crypto/stm32/stm32-cryp.c
index cf1dddbeaa2c..a816b2ffcaad 100644
--- a/drivers/crypto/stm32/stm32-cryp.c
+++ b/drivers/crypto/stm32/stm32-cryp.c
@@ -91,6 +91,7 @@
 #define _walked_out             (cryp->out_walk.offset - cryp->out_sg->offset)
 
 struct stm32_cryp_ctx {
+	struct crypto_engine_ctx enginectx;
 	struct stm32_cryp       *cryp;
 	int                     keylen;
 	u32                     key[AES_KEYSIZE_256 / sizeof(u32)];
@@ -478,7 +479,7 @@ static void stm32_cryp_finish_req(struct stm32_cryp *cryp)
 		free_pages((unsigned long)buf_out, pages);
 	}
 
-	crypto_finalize_cipher_request(cryp->engine, cryp->req, err);
+	crypto_finalize_ablkcipher_request(cryp->engine, cryp->req, err);
 	cryp->req = NULL;
 
 	memset(cryp->ctx->key, 0, cryp->ctx->keylen);
@@ -494,10 +495,19 @@ static int stm32_cryp_cpu_start(struct stm32_cryp *cryp)
 	return 0;
 }
 
+static int stm32_cryp_cipher_one_req(struct crypto_engine *engine, void *areq);
+static int stm32_cryp_prepare_cipher_req(struct crypto_engine *engine,
+					 void *areq);
+
 static int stm32_cryp_cra_init(struct crypto_tfm *tfm)
 {
+	struct stm32_cryp_ctx *ctx = crypto_tfm_ctx(tfm);
+
 	tfm->crt_ablkcipher.reqsize = sizeof(struct stm32_cryp_reqctx);
 
+	ctx->enginectx.op.do_one_request = stm32_cryp_cipher_one_req;
+	ctx->enginectx.op.prepare_request = stm32_cryp_prepare_cipher_req;
+	ctx->enginectx.op.unprepare_request = NULL;
 	return 0;
 }
 
@@ -513,7 +523,7 @@ static int stm32_cryp_crypt(struct ablkcipher_request *req, unsigned long mode)
 
 	rctx->mode = mode;
 
-	return crypto_transfer_cipher_request_to_engine(cryp->engine, req);
+	return crypto_transfer_ablkcipher_request_to_engine(cryp->engine, req);
 }
 
 static int stm32_cryp_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
@@ -695,14 +705,20 @@ static int stm32_cryp_prepare_req(struct crypto_engine *engine,
 }
 
 static int stm32_cryp_prepare_cipher_req(struct crypto_engine *engine,
-					 struct ablkcipher_request *req)
+					 void *areq)
 {
+	struct ablkcipher_request *req = container_of(areq,
+						      struct ablkcipher_request,
+						      base);
+
 	return stm32_cryp_prepare_req(engine, req);
 }
 
-static int stm32_cryp_cipher_one_req(struct crypto_engine *engine,
-				     struct ablkcipher_request *req)
+static int stm32_cryp_cipher_one_req(struct crypto_engine *engine, void *areq)
 {
+	struct ablkcipher_request *req = container_of(areq,
+						      struct ablkcipher_request,
+						      base);
 	struct stm32_cryp_ctx *ctx = crypto_ablkcipher_ctx(
 			crypto_ablkcipher_reqtfm(req));
 	struct stm32_cryp *cryp = ctx->cryp;
@@ -1104,9 +1120,6 @@ static int stm32_cryp_probe(struct platform_device *pdev)
 		goto err_engine1;
 	}
 
-	cryp->engine->prepare_cipher_request = stm32_cryp_prepare_cipher_req;
-	cryp->engine->cipher_one_request = stm32_cryp_cipher_one_req;
-
 	ret = crypto_engine_start(cryp->engine);
 	if (ret) {
 		dev_err(dev, "Could not start crypto engine\n");
-- 
2.13.6
