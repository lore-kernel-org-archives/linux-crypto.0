Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 832AEC001B0
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Aug 2023 09:31:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235005AbjHKJbf (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Aug 2023 05:31:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235068AbjHKJa5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Aug 2023 05:30:57 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33D9F30F0
        for <linux-crypto@vger.kernel.org>; Fri, 11 Aug 2023 02:30:56 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qUOTr-0020mB-BS; Fri, 11 Aug 2023 17:30:52 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 11 Aug 2023 17:30:51 +0800
From:   "Herbert Xu" <herbert@gondor.apana.org.au>
Date:   Fri, 11 Aug 2023 17:30:51 +0800
Subject: [PATCH 35/36] crypto: zynqmp - Use new crypto_engine_op interface
References: <ZNX/BwEkV3SDpsAS@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Gaurav Jain <gaurav.jain@nxp.com>
Message-Id: <E1qUOTr-0020mB-BS@formenos.hmeau.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Use the new crypto_engine_op interface where the callback is stored
in the algorithm object.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/crypto/xilinx/zynqmp-aes-gcm.c |   35 ++++++++++++++++-----------------
 1 file changed, 18 insertions(+), 17 deletions(-)

diff --git a/drivers/crypto/xilinx/zynqmp-aes-gcm.c b/drivers/crypto/xilinx/zynqmp-aes-gcm.c
index ae7dd82abea1..42fe2b7afef2 100644
--- a/drivers/crypto/xilinx/zynqmp-aes-gcm.c
+++ b/drivers/crypto/xilinx/zynqmp-aes-gcm.c
@@ -9,13 +9,14 @@
 #include <crypto/gcm.h>
 #include <crypto/internal/aead.h>
 #include <crypto/scatterwalk.h>
-
 #include <linux/dma-mapping.h>
+#include <linux/err.h>
+#include <linux/firmware/xlnx-zynqmp.h>
+#include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/of_device.h>
 #include <linux/platform_device.h>
-
-#include <linux/firmware/xlnx-zynqmp.h>
+#include <linux/string.h>
 
 #define ZYNQMP_DMA_BIT_MASK	32U
 
@@ -43,7 +44,7 @@ enum zynqmp_aead_keysrc {
 
 struct zynqmp_aead_drv_ctx {
 	union {
-		struct aead_alg aead;
+		struct aead_engine_alg aead;
 	} alg;
 	struct device *dev;
 	struct crypto_engine *engine;
@@ -60,7 +61,6 @@ struct zynqmp_aead_hw_req {
 };
 
 struct zynqmp_aead_tfm_ctx {
-	struct crypto_engine_ctx engine_ctx;
 	struct device *dev;
 	u8 key[ZYNQMP_AES_KEY_SIZE];
 	u8 *iv;
@@ -286,7 +286,7 @@ static int zynqmp_aes_aead_encrypt(struct aead_request *req)
 	struct zynqmp_aead_req_ctx *rq_ctx = aead_request_ctx(req);
 
 	rq_ctx->op = ZYNQMP_AES_ENCRYPT;
-	drv_ctx = container_of(alg, struct zynqmp_aead_drv_ctx, alg.aead);
+	drv_ctx = container_of(alg, struct zynqmp_aead_drv_ctx, alg.aead.base);
 
 	return crypto_transfer_aead_request_to_engine(drv_ctx->engine, req);
 }
@@ -299,7 +299,7 @@ static int zynqmp_aes_aead_decrypt(struct aead_request *req)
 	struct zynqmp_aead_req_ctx *rq_ctx = aead_request_ctx(req);
 
 	rq_ctx->op = ZYNQMP_AES_DECRYPT;
-	drv_ctx = container_of(alg, struct zynqmp_aead_drv_ctx, alg.aead);
+	drv_ctx = container_of(alg, struct zynqmp_aead_drv_ctx, alg.aead.base);
 
 	return crypto_transfer_aead_request_to_engine(drv_ctx->engine, req);
 }
@@ -312,18 +312,16 @@ static int zynqmp_aes_aead_init(struct crypto_aead *aead)
 	struct zynqmp_aead_drv_ctx *drv_ctx;
 	struct aead_alg *alg = crypto_aead_alg(aead);
 
-	drv_ctx = container_of(alg, struct zynqmp_aead_drv_ctx, alg.aead);
+	drv_ctx = container_of(alg, struct zynqmp_aead_drv_ctx, alg.aead.base);
 	tfm_ctx->dev = drv_ctx->dev;
 
-	tfm_ctx->engine_ctx.op.do_one_request = zynqmp_handle_aes_req;
-
-	tfm_ctx->fbk_cipher = crypto_alloc_aead(drv_ctx->alg.aead.base.cra_name,
+	tfm_ctx->fbk_cipher = crypto_alloc_aead(drv_ctx->alg.aead.base.base.cra_name,
 						0,
 						CRYPTO_ALG_NEED_FALLBACK);
 
 	if (IS_ERR(tfm_ctx->fbk_cipher)) {
 		pr_err("%s() Error: failed to allocate fallback for %s\n",
-		       __func__, drv_ctx->alg.aead.base.cra_name);
+		       __func__, drv_ctx->alg.aead.base.base.cra_name);
 		return PTR_ERR(tfm_ctx->fbk_cipher);
 	}
 
@@ -348,7 +346,7 @@ static void zynqmp_aes_aead_exit(struct crypto_aead *aead)
 }
 
 static struct zynqmp_aead_drv_ctx aes_drv_ctx = {
-	.alg.aead = {
+	.alg.aead.base = {
 		.setkey		= zynqmp_aes_aead_setkey,
 		.setauthsize	= zynqmp_aes_aead_setauthsize,
 		.encrypt	= zynqmp_aes_aead_encrypt,
@@ -370,7 +368,10 @@ static struct zynqmp_aead_drv_ctx aes_drv_ctx = {
 		.cra_ctxsize		= sizeof(struct zynqmp_aead_tfm_ctx),
 		.cra_module		= THIS_MODULE,
 		}
-	}
+	},
+	.alg.aead.op = {
+		.do_one_request = zynqmp_handle_aes_req,
+	},
 };
 
 static int zynqmp_aes_aead_probe(struct platform_device *pdev)
@@ -403,7 +404,7 @@ static int zynqmp_aes_aead_probe(struct platform_device *pdev)
 		goto err_engine;
 	}
 
-	err = crypto_register_aead(&aes_drv_ctx.alg.aead);
+	err = crypto_engine_register_aead(&aes_drv_ctx.alg.aead);
 	if (err < 0) {
 		dev_err(dev, "Failed to register AEAD alg.\n");
 		goto err_aead;
@@ -411,7 +412,7 @@ static int zynqmp_aes_aead_probe(struct platform_device *pdev)
 	return 0;
 
 err_aead:
-	crypto_unregister_aead(&aes_drv_ctx.alg.aead);
+	crypto_engine_unregister_aead(&aes_drv_ctx.alg.aead);
 
 err_engine:
 	if (aes_drv_ctx.engine)
@@ -423,7 +424,7 @@ static int zynqmp_aes_aead_probe(struct platform_device *pdev)
 static int zynqmp_aes_aead_remove(struct platform_device *pdev)
 {
 	crypto_engine_exit(aes_drv_ctx.engine);
-	crypto_unregister_aead(&aes_drv_ctx.alg.aead);
+	crypto_engine_unregister_aead(&aes_drv_ctx.alg.aead);
 
 	return 0;
 }
