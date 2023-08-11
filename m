Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05830C04A6A
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Aug 2023 09:31:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231643AbjHKJbY (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Aug 2023 05:31:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234953AbjHKJay (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Aug 2023 05:30:54 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFEBD2D79
        for <linux-crypto@vger.kernel.org>; Fri, 11 Aug 2023 02:30:51 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qUOTn-0020l3-7F; Fri, 11 Aug 2023 17:30:48 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 11 Aug 2023 17:30:47 +0800
From:   "Herbert Xu" <herbert@gondor.apana.org.au>
Date:   Fri, 11 Aug 2023 17:30:47 +0800
Subject: [PATCH 33/36] crypto: stm32 - Use new crypto_engine_op interface
References: <ZNX/BwEkV3SDpsAS@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Gaurav Jain <gaurav.jain@nxp.com>
Message-Id: <E1qUOTn-0020l3-7F@formenos.hmeau.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Use the new crypto_engine_op interface where the callback is stored
in the algorithm object.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/crypto/stm32/stm32-cryp.c |  331 ++++++++++++++------------
 drivers/crypto/stm32/stm32-hash.c |  483 +++++++++++++++++++++-----------------
 2 files changed, 452 insertions(+), 362 deletions(-)

diff --git a/drivers/crypto/stm32/stm32-cryp.c b/drivers/crypto/stm32/stm32-cryp.c
index 07e32b8dbe29..c67239686b1e 100644
--- a/drivers/crypto/stm32/stm32-cryp.c
+++ b/drivers/crypto/stm32/stm32-cryp.c
@@ -5,22 +5,24 @@
  * Ux500 support taken from snippets in the old Ux500 cryp driver
  */
 
+#include <crypto/aes.h>
+#include <crypto/engine.h>
+#include <crypto/internal/aead.h>
+#include <crypto/internal/des.h>
+#include <crypto/internal/skcipher.h>
+#include <crypto/scatterwalk.h>
 #include <linux/clk.h>
 #include <linux/delay.h>
-#include <linux/interrupt.h>
+#include <linux/err.h>
 #include <linux/iopoll.h>
+#include <linux/interrupt.h>
+#include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/of_device.h>
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
 #include <linux/reset.h>
-
-#include <crypto/aes.h>
-#include <crypto/internal/des.h>
-#include <crypto/engine.h>
-#include <crypto/scatterwalk.h>
-#include <crypto/internal/aead.h>
-#include <crypto/internal/skcipher.h>
+#include <linux/string.h>
 
 #define DRIVER_NAME             "stm32-cryp"
 
@@ -156,7 +158,6 @@ struct stm32_cryp_caps {
 };
 
 struct stm32_cryp_ctx {
-	struct crypto_engine_ctx enginectx;
 	struct stm32_cryp       *cryp;
 	int                     keylen;
 	__be32                  key[AES_KEYSIZE_256 / sizeof(u32)];
@@ -828,11 +829,8 @@ static int stm32_cryp_cipher_one_req(struct crypto_engine *engine, void *areq);
 
 static int stm32_cryp_init_tfm(struct crypto_skcipher *tfm)
 {
-	struct stm32_cryp_ctx *ctx = crypto_skcipher_ctx(tfm);
-
 	crypto_skcipher_set_reqsize(tfm, sizeof(struct stm32_cryp_reqctx));
 
-	ctx->enginectx.op.do_one_request = stm32_cryp_cipher_one_req;
 	return 0;
 }
 
@@ -840,12 +838,8 @@ static int stm32_cryp_aead_one_req(struct crypto_engine *engine, void *areq);
 
 static int stm32_cryp_aes_aead_init(struct crypto_aead *tfm)
 {
-	struct stm32_cryp_ctx *ctx = crypto_aead_ctx(tfm);
-
 	tfm->reqsize = sizeof(struct stm32_cryp_reqctx);
 
-	ctx->enginectx.op.do_one_request = stm32_cryp_aead_one_req;
-
 	return 0;
 }
 
@@ -1686,143 +1680,178 @@ static irqreturn_t stm32_cryp_irq(int irq, void *arg)
 	return IRQ_WAKE_THREAD;
 }
 
-static struct skcipher_alg crypto_algs[] = {
+static struct skcipher_engine_alg crypto_algs[] = {
 {
-	.base.cra_name		= "ecb(aes)",
-	.base.cra_driver_name	= "stm32-ecb-aes",
-	.base.cra_priority	= 200,
-	.base.cra_flags		= CRYPTO_ALG_ASYNC,
-	.base.cra_blocksize	= AES_BLOCK_SIZE,
-	.base.cra_ctxsize	= sizeof(struct stm32_cryp_ctx),
-	.base.cra_alignmask	= 0,
-	.base.cra_module	= THIS_MODULE,
-
-	.init			= stm32_cryp_init_tfm,
-	.min_keysize		= AES_MIN_KEY_SIZE,
-	.max_keysize		= AES_MAX_KEY_SIZE,
-	.setkey			= stm32_cryp_aes_setkey,
-	.encrypt		= stm32_cryp_aes_ecb_encrypt,
-	.decrypt		= stm32_cryp_aes_ecb_decrypt,
+	.base = {
+		.base.cra_name		= "ecb(aes)",
+		.base.cra_driver_name	= "stm32-ecb-aes",
+		.base.cra_priority	= 200,
+		.base.cra_flags		= CRYPTO_ALG_ASYNC,
+		.base.cra_blocksize	= AES_BLOCK_SIZE,
+		.base.cra_ctxsize	= sizeof(struct stm32_cryp_ctx),
+		.base.cra_alignmask	= 0,
+		.base.cra_module	= THIS_MODULE,
+
+		.init			= stm32_cryp_init_tfm,
+		.min_keysize		= AES_MIN_KEY_SIZE,
+		.max_keysize		= AES_MAX_KEY_SIZE,
+		.setkey			= stm32_cryp_aes_setkey,
+		.encrypt		= stm32_cryp_aes_ecb_encrypt,
+		.decrypt		= stm32_cryp_aes_ecb_decrypt,
+	},
+	.op = {
+		.do_one_request = stm32_cryp_cipher_one_req,
+	},
 },
 {
-	.base.cra_name		= "cbc(aes)",
-	.base.cra_driver_name	= "stm32-cbc-aes",
-	.base.cra_priority	= 200,
-	.base.cra_flags		= CRYPTO_ALG_ASYNC,
-	.base.cra_blocksize	= AES_BLOCK_SIZE,
-	.base.cra_ctxsize	= sizeof(struct stm32_cryp_ctx),
-	.base.cra_alignmask	= 0,
-	.base.cra_module	= THIS_MODULE,
-
-	.init			= stm32_cryp_init_tfm,
-	.min_keysize		= AES_MIN_KEY_SIZE,
-	.max_keysize		= AES_MAX_KEY_SIZE,
-	.ivsize			= AES_BLOCK_SIZE,
-	.setkey			= stm32_cryp_aes_setkey,
-	.encrypt		= stm32_cryp_aes_cbc_encrypt,
-	.decrypt		= stm32_cryp_aes_cbc_decrypt,
+	.base = {
+		.base.cra_name		= "cbc(aes)",
+		.base.cra_driver_name	= "stm32-cbc-aes",
+		.base.cra_priority	= 200,
+		.base.cra_flags		= CRYPTO_ALG_ASYNC,
+		.base.cra_blocksize	= AES_BLOCK_SIZE,
+		.base.cra_ctxsize	= sizeof(struct stm32_cryp_ctx),
+		.base.cra_alignmask	= 0,
+		.base.cra_module	= THIS_MODULE,
+
+		.init			= stm32_cryp_init_tfm,
+		.min_keysize		= AES_MIN_KEY_SIZE,
+		.max_keysize		= AES_MAX_KEY_SIZE,
+		.ivsize			= AES_BLOCK_SIZE,
+		.setkey			= stm32_cryp_aes_setkey,
+		.encrypt		= stm32_cryp_aes_cbc_encrypt,
+		.decrypt		= stm32_cryp_aes_cbc_decrypt,
+	},
+	.op = {
+		.do_one_request = stm32_cryp_cipher_one_req,
+	},
 },
 {
-	.base.cra_name		= "ctr(aes)",
-	.base.cra_driver_name	= "stm32-ctr-aes",
-	.base.cra_priority	= 200,
-	.base.cra_flags		= CRYPTO_ALG_ASYNC,
-	.base.cra_blocksize	= 1,
-	.base.cra_ctxsize	= sizeof(struct stm32_cryp_ctx),
-	.base.cra_alignmask	= 0,
-	.base.cra_module	= THIS_MODULE,
-
-	.init			= stm32_cryp_init_tfm,
-	.min_keysize		= AES_MIN_KEY_SIZE,
-	.max_keysize		= AES_MAX_KEY_SIZE,
-	.ivsize			= AES_BLOCK_SIZE,
-	.setkey			= stm32_cryp_aes_setkey,
-	.encrypt		= stm32_cryp_aes_ctr_encrypt,
-	.decrypt		= stm32_cryp_aes_ctr_decrypt,
+	.base = {
+		.base.cra_name		= "ctr(aes)",
+		.base.cra_driver_name	= "stm32-ctr-aes",
+		.base.cra_priority	= 200,
+		.base.cra_flags		= CRYPTO_ALG_ASYNC,
+		.base.cra_blocksize	= 1,
+		.base.cra_ctxsize	= sizeof(struct stm32_cryp_ctx),
+		.base.cra_alignmask	= 0,
+		.base.cra_module	= THIS_MODULE,
+
+		.init			= stm32_cryp_init_tfm,
+		.min_keysize		= AES_MIN_KEY_SIZE,
+		.max_keysize		= AES_MAX_KEY_SIZE,
+		.ivsize			= AES_BLOCK_SIZE,
+		.setkey			= stm32_cryp_aes_setkey,
+		.encrypt		= stm32_cryp_aes_ctr_encrypt,
+		.decrypt		= stm32_cryp_aes_ctr_decrypt,
+	},
+	.op = {
+		.do_one_request = stm32_cryp_cipher_one_req,
+	},
 },
 {
-	.base.cra_name		= "ecb(des)",
-	.base.cra_driver_name	= "stm32-ecb-des",
-	.base.cra_priority	= 200,
-	.base.cra_flags		= CRYPTO_ALG_ASYNC,
-	.base.cra_blocksize	= DES_BLOCK_SIZE,
-	.base.cra_ctxsize	= sizeof(struct stm32_cryp_ctx),
-	.base.cra_alignmask	= 0,
-	.base.cra_module	= THIS_MODULE,
-
-	.init			= stm32_cryp_init_tfm,
-	.min_keysize		= DES_BLOCK_SIZE,
-	.max_keysize		= DES_BLOCK_SIZE,
-	.setkey			= stm32_cryp_des_setkey,
-	.encrypt		= stm32_cryp_des_ecb_encrypt,
-	.decrypt		= stm32_cryp_des_ecb_decrypt,
+	.base = {
+		.base.cra_name		= "ecb(des)",
+		.base.cra_driver_name	= "stm32-ecb-des",
+		.base.cra_priority	= 200,
+		.base.cra_flags		= CRYPTO_ALG_ASYNC,
+		.base.cra_blocksize	= DES_BLOCK_SIZE,
+		.base.cra_ctxsize	= sizeof(struct stm32_cryp_ctx),
+		.base.cra_alignmask	= 0,
+		.base.cra_module	= THIS_MODULE,
+
+		.init			= stm32_cryp_init_tfm,
+		.min_keysize		= DES_BLOCK_SIZE,
+		.max_keysize		= DES_BLOCK_SIZE,
+		.setkey			= stm32_cryp_des_setkey,
+		.encrypt		= stm32_cryp_des_ecb_encrypt,
+		.decrypt		= stm32_cryp_des_ecb_decrypt,
+	},
+	.op = {
+		.do_one_request = stm32_cryp_cipher_one_req,
+	},
 },
 {
-	.base.cra_name		= "cbc(des)",
-	.base.cra_driver_name	= "stm32-cbc-des",
-	.base.cra_priority	= 200,
-	.base.cra_flags		= CRYPTO_ALG_ASYNC,
-	.base.cra_blocksize	= DES_BLOCK_SIZE,
-	.base.cra_ctxsize	= sizeof(struct stm32_cryp_ctx),
-	.base.cra_alignmask	= 0,
-	.base.cra_module	= THIS_MODULE,
-
-	.init			= stm32_cryp_init_tfm,
-	.min_keysize		= DES_BLOCK_SIZE,
-	.max_keysize		= DES_BLOCK_SIZE,
-	.ivsize			= DES_BLOCK_SIZE,
-	.setkey			= stm32_cryp_des_setkey,
-	.encrypt		= stm32_cryp_des_cbc_encrypt,
-	.decrypt		= stm32_cryp_des_cbc_decrypt,
+	.base = {
+		.base.cra_name		= "cbc(des)",
+		.base.cra_driver_name	= "stm32-cbc-des",
+		.base.cra_priority	= 200,
+		.base.cra_flags		= CRYPTO_ALG_ASYNC,
+		.base.cra_blocksize	= DES_BLOCK_SIZE,
+		.base.cra_ctxsize	= sizeof(struct stm32_cryp_ctx),
+		.base.cra_alignmask	= 0,
+		.base.cra_module	= THIS_MODULE,
+
+		.init			= stm32_cryp_init_tfm,
+		.min_keysize		= DES_BLOCK_SIZE,
+		.max_keysize		= DES_BLOCK_SIZE,
+		.ivsize			= DES_BLOCK_SIZE,
+		.setkey			= stm32_cryp_des_setkey,
+		.encrypt		= stm32_cryp_des_cbc_encrypt,
+		.decrypt		= stm32_cryp_des_cbc_decrypt,
+	},
+	.op = {
+		.do_one_request = stm32_cryp_cipher_one_req,
+	},
 },
 {
-	.base.cra_name		= "ecb(des3_ede)",
-	.base.cra_driver_name	= "stm32-ecb-des3",
-	.base.cra_priority	= 200,
-	.base.cra_flags		= CRYPTO_ALG_ASYNC,
-	.base.cra_blocksize	= DES_BLOCK_SIZE,
-	.base.cra_ctxsize	= sizeof(struct stm32_cryp_ctx),
-	.base.cra_alignmask	= 0,
-	.base.cra_module	= THIS_MODULE,
-
-	.init			= stm32_cryp_init_tfm,
-	.min_keysize		= 3 * DES_BLOCK_SIZE,
-	.max_keysize		= 3 * DES_BLOCK_SIZE,
-	.setkey			= stm32_cryp_tdes_setkey,
-	.encrypt		= stm32_cryp_tdes_ecb_encrypt,
-	.decrypt		= stm32_cryp_tdes_ecb_decrypt,
+	.base = {
+		.base.cra_name		= "ecb(des3_ede)",
+		.base.cra_driver_name	= "stm32-ecb-des3",
+		.base.cra_priority	= 200,
+		.base.cra_flags		= CRYPTO_ALG_ASYNC,
+		.base.cra_blocksize	= DES_BLOCK_SIZE,
+		.base.cra_ctxsize	= sizeof(struct stm32_cryp_ctx),
+		.base.cra_alignmask	= 0,
+		.base.cra_module	= THIS_MODULE,
+
+		.init			= stm32_cryp_init_tfm,
+		.min_keysize		= 3 * DES_BLOCK_SIZE,
+		.max_keysize		= 3 * DES_BLOCK_SIZE,
+		.setkey			= stm32_cryp_tdes_setkey,
+		.encrypt		= stm32_cryp_tdes_ecb_encrypt,
+		.decrypt		= stm32_cryp_tdes_ecb_decrypt,
+	},
+	.op = {
+		.do_one_request = stm32_cryp_cipher_one_req,
+	},
 },
 {
-	.base.cra_name		= "cbc(des3_ede)",
-	.base.cra_driver_name	= "stm32-cbc-des3",
-	.base.cra_priority	= 200,
-	.base.cra_flags		= CRYPTO_ALG_ASYNC,
-	.base.cra_blocksize	= DES_BLOCK_SIZE,
-	.base.cra_ctxsize	= sizeof(struct stm32_cryp_ctx),
-	.base.cra_alignmask	= 0,
-	.base.cra_module	= THIS_MODULE,
-
-	.init			= stm32_cryp_init_tfm,
-	.min_keysize		= 3 * DES_BLOCK_SIZE,
-	.max_keysize		= 3 * DES_BLOCK_SIZE,
-	.ivsize			= DES_BLOCK_SIZE,
-	.setkey			= stm32_cryp_tdes_setkey,
-	.encrypt		= stm32_cryp_tdes_cbc_encrypt,
-	.decrypt		= stm32_cryp_tdes_cbc_decrypt,
+	.base = {
+		.base.cra_name		= "cbc(des3_ede)",
+		.base.cra_driver_name	= "stm32-cbc-des3",
+		.base.cra_priority	= 200,
+		.base.cra_flags		= CRYPTO_ALG_ASYNC,
+		.base.cra_blocksize	= DES_BLOCK_SIZE,
+		.base.cra_ctxsize	= sizeof(struct stm32_cryp_ctx),
+		.base.cra_alignmask	= 0,
+		.base.cra_module	= THIS_MODULE,
+
+		.init			= stm32_cryp_init_tfm,
+		.min_keysize		= 3 * DES_BLOCK_SIZE,
+		.max_keysize		= 3 * DES_BLOCK_SIZE,
+		.ivsize			= DES_BLOCK_SIZE,
+		.setkey			= stm32_cryp_tdes_setkey,
+		.encrypt		= stm32_cryp_tdes_cbc_encrypt,
+		.decrypt		= stm32_cryp_tdes_cbc_decrypt,
+	},
+	.op = {
+		.do_one_request = stm32_cryp_cipher_one_req,
+	},
 },
 };
 
-static struct aead_alg aead_algs[] = {
+static struct aead_engine_alg aead_algs[] = {
 {
-	.setkey		= stm32_cryp_aes_aead_setkey,
-	.setauthsize	= stm32_cryp_aes_gcm_setauthsize,
-	.encrypt	= stm32_cryp_aes_gcm_encrypt,
-	.decrypt	= stm32_cryp_aes_gcm_decrypt,
-	.init		= stm32_cryp_aes_aead_init,
-	.ivsize		= 12,
-	.maxauthsize	= AES_BLOCK_SIZE,
+	.base.setkey		= stm32_cryp_aes_aead_setkey,
+	.base.setauthsize	= stm32_cryp_aes_gcm_setauthsize,
+	.base.encrypt		= stm32_cryp_aes_gcm_encrypt,
+	.base.decrypt		= stm32_cryp_aes_gcm_decrypt,
+	.base.init		= stm32_cryp_aes_aead_init,
+	.base.ivsize		= 12,
+	.base.maxauthsize	= AES_BLOCK_SIZE,
 
-	.base = {
+	.base.base = {
 		.cra_name		= "gcm(aes)",
 		.cra_driver_name	= "stm32-gcm-aes",
 		.cra_priority		= 200,
@@ -1832,17 +1861,20 @@ static struct aead_alg aead_algs[] = {
 		.cra_alignmask		= 0,
 		.cra_module		= THIS_MODULE,
 	},
+	.op = {
+		.do_one_request = stm32_cryp_aead_one_req,
+	},
 },
 {
-	.setkey		= stm32_cryp_aes_aead_setkey,
-	.setauthsize	= stm32_cryp_aes_ccm_setauthsize,
-	.encrypt	= stm32_cryp_aes_ccm_encrypt,
-	.decrypt	= stm32_cryp_aes_ccm_decrypt,
-	.init		= stm32_cryp_aes_aead_init,
-	.ivsize		= AES_BLOCK_SIZE,
-	.maxauthsize	= AES_BLOCK_SIZE,
+	.base.setkey		= stm32_cryp_aes_aead_setkey,
+	.base.setauthsize	= stm32_cryp_aes_ccm_setauthsize,
+	.base.encrypt		= stm32_cryp_aes_ccm_encrypt,
+	.base.decrypt		= stm32_cryp_aes_ccm_decrypt,
+	.base.init		= stm32_cryp_aes_aead_init,
+	.base.ivsize		= AES_BLOCK_SIZE,
+	.base.maxauthsize	= AES_BLOCK_SIZE,
 
-	.base = {
+	.base.base = {
 		.cra_name		= "ccm(aes)",
 		.cra_driver_name	= "stm32-ccm-aes",
 		.cra_priority		= 200,
@@ -1852,6 +1884,9 @@ static struct aead_alg aead_algs[] = {
 		.cra_alignmask		= 0,
 		.cra_module		= THIS_MODULE,
 	},
+	.op = {
+		.do_one_request = stm32_cryp_aead_one_req,
+	},
 },
 };
 
@@ -2013,14 +2048,14 @@ static int stm32_cryp_probe(struct platform_device *pdev)
 		goto err_engine2;
 	}
 
-	ret = crypto_register_skciphers(crypto_algs, ARRAY_SIZE(crypto_algs));
+	ret = crypto_engine_register_skciphers(crypto_algs, ARRAY_SIZE(crypto_algs));
 	if (ret) {
 		dev_err(dev, "Could not register algs\n");
 		goto err_algs;
 	}
 
 	if (cryp->caps->aeads_support) {
-		ret = crypto_register_aeads(aead_algs, ARRAY_SIZE(aead_algs));
+		ret = crypto_engine_register_aeads(aead_algs, ARRAY_SIZE(aead_algs));
 		if (ret)
 			goto err_aead_algs;
 	}
@@ -2032,7 +2067,7 @@ static int stm32_cryp_probe(struct platform_device *pdev)
 	return 0;
 
 err_aead_algs:
-	crypto_unregister_skciphers(crypto_algs, ARRAY_SIZE(crypto_algs));
+	crypto_engine_unregister_skciphers(crypto_algs, ARRAY_SIZE(crypto_algs));
 err_algs:
 err_engine2:
 	crypto_engine_exit(cryp->engine);
@@ -2062,8 +2097,8 @@ static int stm32_cryp_remove(struct platform_device *pdev)
 		return ret;
 
 	if (cryp->caps->aeads_support)
-		crypto_unregister_aeads(aead_algs, ARRAY_SIZE(aead_algs));
-	crypto_unregister_skciphers(crypto_algs, ARRAY_SIZE(crypto_algs));
+		crypto_engine_unregister_aeads(aead_algs, ARRAY_SIZE(aead_algs));
+	crypto_engine_unregister_skciphers(crypto_algs, ARRAY_SIZE(crypto_algs));
 
 	crypto_engine_exit(cryp->engine);
 
diff --git a/drivers/crypto/stm32/stm32-hash.c b/drivers/crypto/stm32/stm32-hash.c
index 88a186c3dd78..cebe3a65f284 100644
--- a/drivers/crypto/stm32/stm32-hash.c
+++ b/drivers/crypto/stm32/stm32-hash.c
@@ -6,12 +6,18 @@
  * Author(s): Lionel DEBIEVE <lionel.debieve@st.com> for STMicroelectronics.
  */
 
+#include <crypto/engine.h>
+#include <crypto/internal/hash.h>
+#include <crypto/md5.h>
+#include <crypto/scatterwalk.h>
+#include <crypto/sha1.h>
+#include <crypto/sha2.h>
+#include <crypto/sha3.h>
 #include <linux/clk.h>
 #include <linux/delay.h>
 #include <linux/dma-mapping.h>
 #include <linux/dmaengine.h>
 #include <linux/interrupt.h>
-#include <linux/io.h>
 #include <linux/iopoll.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
@@ -19,15 +25,7 @@
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
 #include <linux/reset.h>
-
-#include <crypto/engine.h>
-#include <crypto/hash.h>
-#include <crypto/md5.h>
-#include <crypto/scatterwalk.h>
-#include <crypto/sha1.h>
-#include <crypto/sha2.h>
-#include <crypto/sha3.h>
-#include <crypto/internal/hash.h>
+#include <linux/string.h>
 
 #define HASH_CR				0x00
 #define HASH_DIN			0x04
@@ -133,7 +131,6 @@ enum ux500_hash_algo {
 #define HASH_AUTOSUSPEND_DELAY		50
 
 struct stm32_hash_ctx {
-	struct crypto_engine_ctx enginectx;
 	struct stm32_hash_dev	*hdev;
 	struct crypto_shash	*xtfm;
 	unsigned long		flags;
@@ -177,7 +174,7 @@ struct stm32_hash_request_ctx {
 };
 
 struct stm32_hash_algs_info {
-	struct ahash_alg	*algs_list;
+	struct ahash_engine_alg	*algs_list;
 	size_t			size;
 };
 
@@ -1194,8 +1191,6 @@ static int stm32_hash_cra_init_algs(struct crypto_tfm *tfm, u32 algs_flags)
 	if (algs_flags)
 		ctx->flags |= algs_flags;
 
-	ctx->enginectx.op.do_one_request = stm32_hash_one_request;
-
 	return stm32_hash_init_fallback(tfm);
 }
 
@@ -1268,16 +1263,16 @@ static irqreturn_t stm32_hash_irq_handler(int irq, void *dev_id)
 	return IRQ_NONE;
 }
 
-static struct ahash_alg algs_md5[] = {
+static struct ahash_engine_alg algs_md5[] = {
 	{
-		.init = stm32_hash_init,
-		.update = stm32_hash_update,
-		.final = stm32_hash_final,
-		.finup = stm32_hash_finup,
-		.digest = stm32_hash_digest,
-		.export = stm32_hash_export,
-		.import = stm32_hash_import,
-		.halg = {
+		.base.init = stm32_hash_init,
+		.base.update = stm32_hash_update,
+		.base.final = stm32_hash_final,
+		.base.finup = stm32_hash_finup,
+		.base.digest = stm32_hash_digest,
+		.base.export = stm32_hash_export,
+		.base.import = stm32_hash_import,
+		.base.halg = {
 			.digestsize = MD5_DIGEST_SIZE,
 			.statesize = sizeof(struct stm32_hash_state),
 			.base = {
@@ -1293,18 +1288,21 @@ static struct ahash_alg algs_md5[] = {
 				.cra_exit = stm32_hash_cra_exit,
 				.cra_module = THIS_MODULE,
 			}
-		}
+		},
+		.op = {
+			.do_one_request = stm32_hash_one_request,
+		},
 	},
 	{
-		.init = stm32_hash_init,
-		.update = stm32_hash_update,
-		.final = stm32_hash_final,
-		.finup = stm32_hash_finup,
-		.digest = stm32_hash_digest,
-		.export = stm32_hash_export,
-		.import = stm32_hash_import,
-		.setkey = stm32_hash_setkey,
-		.halg = {
+		.base.init = stm32_hash_init,
+		.base.update = stm32_hash_update,
+		.base.final = stm32_hash_final,
+		.base.finup = stm32_hash_finup,
+		.base.digest = stm32_hash_digest,
+		.base.export = stm32_hash_export,
+		.base.import = stm32_hash_import,
+		.base.setkey = stm32_hash_setkey,
+		.base.halg = {
 			.digestsize = MD5_DIGEST_SIZE,
 			.statesize = sizeof(struct stm32_hash_state),
 			.base = {
@@ -1320,20 +1318,23 @@ static struct ahash_alg algs_md5[] = {
 				.cra_exit = stm32_hash_cra_exit,
 				.cra_module = THIS_MODULE,
 			}
-		}
+		},
+		.op = {
+			.do_one_request = stm32_hash_one_request,
+		},
 	}
 };
 
-static struct ahash_alg algs_sha1[] = {
+static struct ahash_engine_alg algs_sha1[] = {
 	{
-		.init = stm32_hash_init,
-		.update = stm32_hash_update,
-		.final = stm32_hash_final,
-		.finup = stm32_hash_finup,
-		.digest = stm32_hash_digest,
-		.export = stm32_hash_export,
-		.import = stm32_hash_import,
-		.halg = {
+		.base.init = stm32_hash_init,
+		.base.update = stm32_hash_update,
+		.base.final = stm32_hash_final,
+		.base.finup = stm32_hash_finup,
+		.base.digest = stm32_hash_digest,
+		.base.export = stm32_hash_export,
+		.base.import = stm32_hash_import,
+		.base.halg = {
 			.digestsize = SHA1_DIGEST_SIZE,
 			.statesize = sizeof(struct stm32_hash_state),
 			.base = {
@@ -1349,18 +1350,21 @@ static struct ahash_alg algs_sha1[] = {
 				.cra_exit = stm32_hash_cra_exit,
 				.cra_module = THIS_MODULE,
 			}
-		}
+		},
+		.op = {
+			.do_one_request = stm32_hash_one_request,
+		},
 	},
 	{
-		.init = stm32_hash_init,
-		.update = stm32_hash_update,
-		.final = stm32_hash_final,
-		.finup = stm32_hash_finup,
-		.digest = stm32_hash_digest,
-		.export = stm32_hash_export,
-		.import = stm32_hash_import,
-		.setkey = stm32_hash_setkey,
-		.halg = {
+		.base.init = stm32_hash_init,
+		.base.update = stm32_hash_update,
+		.base.final = stm32_hash_final,
+		.base.finup = stm32_hash_finup,
+		.base.digest = stm32_hash_digest,
+		.base.export = stm32_hash_export,
+		.base.import = stm32_hash_import,
+		.base.setkey = stm32_hash_setkey,
+		.base.halg = {
 			.digestsize = SHA1_DIGEST_SIZE,
 			.statesize = sizeof(struct stm32_hash_state),
 			.base = {
@@ -1376,20 +1380,23 @@ static struct ahash_alg algs_sha1[] = {
 				.cra_exit = stm32_hash_cra_exit,
 				.cra_module = THIS_MODULE,
 			}
-		}
+		},
+		.op = {
+			.do_one_request = stm32_hash_one_request,
+		},
 	},
 };
 
-static struct ahash_alg algs_sha224[] = {
+static struct ahash_engine_alg algs_sha224[] = {
 	{
-		.init = stm32_hash_init,
-		.update = stm32_hash_update,
-		.final = stm32_hash_final,
-		.finup = stm32_hash_finup,
-		.digest = stm32_hash_digest,
-		.export = stm32_hash_export,
-		.import = stm32_hash_import,
-		.halg = {
+		.base.init = stm32_hash_init,
+		.base.update = stm32_hash_update,
+		.base.final = stm32_hash_final,
+		.base.finup = stm32_hash_finup,
+		.base.digest = stm32_hash_digest,
+		.base.export = stm32_hash_export,
+		.base.import = stm32_hash_import,
+		.base.halg = {
 			.digestsize = SHA224_DIGEST_SIZE,
 			.statesize = sizeof(struct stm32_hash_state),
 			.base = {
@@ -1405,18 +1412,21 @@ static struct ahash_alg algs_sha224[] = {
 				.cra_exit = stm32_hash_cra_exit,
 				.cra_module = THIS_MODULE,
 			}
-		}
+		},
+		.op = {
+			.do_one_request = stm32_hash_one_request,
+		},
 	},
 	{
-		.init = stm32_hash_init,
-		.update = stm32_hash_update,
-		.final = stm32_hash_final,
-		.finup = stm32_hash_finup,
-		.digest = stm32_hash_digest,
-		.setkey = stm32_hash_setkey,
-		.export = stm32_hash_export,
-		.import = stm32_hash_import,
-		.halg = {
+		.base.init = stm32_hash_init,
+		.base.update = stm32_hash_update,
+		.base.final = stm32_hash_final,
+		.base.finup = stm32_hash_finup,
+		.base.digest = stm32_hash_digest,
+		.base.setkey = stm32_hash_setkey,
+		.base.export = stm32_hash_export,
+		.base.import = stm32_hash_import,
+		.base.halg = {
 			.digestsize = SHA224_DIGEST_SIZE,
 			.statesize = sizeof(struct stm32_hash_state),
 			.base = {
@@ -1432,20 +1442,23 @@ static struct ahash_alg algs_sha224[] = {
 				.cra_exit = stm32_hash_cra_exit,
 				.cra_module = THIS_MODULE,
 			}
-		}
+		},
+		.op = {
+			.do_one_request = stm32_hash_one_request,
+		},
 	},
 };
 
-static struct ahash_alg algs_sha256[] = {
+static struct ahash_engine_alg algs_sha256[] = {
 	{
-		.init = stm32_hash_init,
-		.update = stm32_hash_update,
-		.final = stm32_hash_final,
-		.finup = stm32_hash_finup,
-		.digest = stm32_hash_digest,
-		.export = stm32_hash_export,
-		.import = stm32_hash_import,
-		.halg = {
+		.base.init = stm32_hash_init,
+		.base.update = stm32_hash_update,
+		.base.final = stm32_hash_final,
+		.base.finup = stm32_hash_finup,
+		.base.digest = stm32_hash_digest,
+		.base.export = stm32_hash_export,
+		.base.import = stm32_hash_import,
+		.base.halg = {
 			.digestsize = SHA256_DIGEST_SIZE,
 			.statesize = sizeof(struct stm32_hash_state),
 			.base = {
@@ -1461,18 +1474,21 @@ static struct ahash_alg algs_sha256[] = {
 				.cra_exit = stm32_hash_cra_exit,
 				.cra_module = THIS_MODULE,
 			}
-		}
+		},
+		.op = {
+			.do_one_request = stm32_hash_one_request,
+		},
 	},
 	{
-		.init = stm32_hash_init,
-		.update = stm32_hash_update,
-		.final = stm32_hash_final,
-		.finup = stm32_hash_finup,
-		.digest = stm32_hash_digest,
-		.export = stm32_hash_export,
-		.import = stm32_hash_import,
-		.setkey = stm32_hash_setkey,
-		.halg = {
+		.base.init = stm32_hash_init,
+		.base.update = stm32_hash_update,
+		.base.final = stm32_hash_final,
+		.base.finup = stm32_hash_finup,
+		.base.digest = stm32_hash_digest,
+		.base.export = stm32_hash_export,
+		.base.import = stm32_hash_import,
+		.base.setkey = stm32_hash_setkey,
+		.base.halg = {
 			.digestsize = SHA256_DIGEST_SIZE,
 			.statesize = sizeof(struct stm32_hash_state),
 			.base = {
@@ -1488,20 +1504,23 @@ static struct ahash_alg algs_sha256[] = {
 				.cra_exit = stm32_hash_cra_exit,
 				.cra_module = THIS_MODULE,
 			}
-		}
+		},
+		.op = {
+			.do_one_request = stm32_hash_one_request,
+		},
 	},
 };
 
-static struct ahash_alg algs_sha384_sha512[] = {
+static struct ahash_engine_alg algs_sha384_sha512[] = {
 	{
-		.init = stm32_hash_init,
-		.update = stm32_hash_update,
-		.final = stm32_hash_final,
-		.finup = stm32_hash_finup,
-		.digest = stm32_hash_digest,
-		.export = stm32_hash_export,
-		.import = stm32_hash_import,
-		.halg = {
+		.base.init = stm32_hash_init,
+		.base.update = stm32_hash_update,
+		.base.final = stm32_hash_final,
+		.base.finup = stm32_hash_finup,
+		.base.digest = stm32_hash_digest,
+		.base.export = stm32_hash_export,
+		.base.import = stm32_hash_import,
+		.base.halg = {
 			.digestsize = SHA384_DIGEST_SIZE,
 			.statesize = sizeof(struct stm32_hash_state),
 			.base = {
@@ -1517,18 +1536,21 @@ static struct ahash_alg algs_sha384_sha512[] = {
 				.cra_exit = stm32_hash_cra_exit,
 				.cra_module = THIS_MODULE,
 			}
-		}
+		},
+		.op = {
+			.do_one_request = stm32_hash_one_request,
+		},
 	},
 	{
-		.init = stm32_hash_init,
-		.update = stm32_hash_update,
-		.final = stm32_hash_final,
-		.finup = stm32_hash_finup,
-		.digest = stm32_hash_digest,
-		.setkey = stm32_hash_setkey,
-		.export = stm32_hash_export,
-		.import = stm32_hash_import,
-		.halg = {
+		.base.init = stm32_hash_init,
+		.base.update = stm32_hash_update,
+		.base.final = stm32_hash_final,
+		.base.finup = stm32_hash_finup,
+		.base.digest = stm32_hash_digest,
+		.base.setkey = stm32_hash_setkey,
+		.base.export = stm32_hash_export,
+		.base.import = stm32_hash_import,
+		.base.halg = {
 			.digestsize = SHA384_DIGEST_SIZE,
 			.statesize = sizeof(struct stm32_hash_state),
 			.base = {
@@ -1544,17 +1566,20 @@ static struct ahash_alg algs_sha384_sha512[] = {
 				.cra_exit = stm32_hash_cra_exit,
 				.cra_module = THIS_MODULE,
 			}
-		}
+		},
+		.op = {
+			.do_one_request = stm32_hash_one_request,
+		},
 	},
 	{
-		.init = stm32_hash_init,
-		.update = stm32_hash_update,
-		.final = stm32_hash_final,
-		.finup = stm32_hash_finup,
-		.digest = stm32_hash_digest,
-		.export = stm32_hash_export,
-		.import = stm32_hash_import,
-		.halg = {
+		.base.init = stm32_hash_init,
+		.base.update = stm32_hash_update,
+		.base.final = stm32_hash_final,
+		.base.finup = stm32_hash_finup,
+		.base.digest = stm32_hash_digest,
+		.base.export = stm32_hash_export,
+		.base.import = stm32_hash_import,
+		.base.halg = {
 			.digestsize = SHA512_DIGEST_SIZE,
 			.statesize = sizeof(struct stm32_hash_state),
 			.base = {
@@ -1570,18 +1595,21 @@ static struct ahash_alg algs_sha384_sha512[] = {
 				.cra_exit = stm32_hash_cra_exit,
 				.cra_module = THIS_MODULE,
 			}
-		}
+		},
+		.op = {
+			.do_one_request = stm32_hash_one_request,
+		},
 	},
 	{
-		.init = stm32_hash_init,
-		.update = stm32_hash_update,
-		.final = stm32_hash_final,
-		.finup = stm32_hash_finup,
-		.digest = stm32_hash_digest,
-		.export = stm32_hash_export,
-		.import = stm32_hash_import,
-		.setkey = stm32_hash_setkey,
-		.halg = {
+		.base.init = stm32_hash_init,
+		.base.update = stm32_hash_update,
+		.base.final = stm32_hash_final,
+		.base.finup = stm32_hash_finup,
+		.base.digest = stm32_hash_digest,
+		.base.export = stm32_hash_export,
+		.base.import = stm32_hash_import,
+		.base.setkey = stm32_hash_setkey,
+		.base.halg = {
 			.digestsize = SHA512_DIGEST_SIZE,
 			.statesize = sizeof(struct stm32_hash_state),
 			.base = {
@@ -1597,20 +1625,23 @@ static struct ahash_alg algs_sha384_sha512[] = {
 				.cra_exit = stm32_hash_cra_exit,
 				.cra_module = THIS_MODULE,
 			}
-		}
+		},
+		.op = {
+			.do_one_request = stm32_hash_one_request,
+		},
 	},
 };
 
-static struct ahash_alg algs_sha3[] = {
+static struct ahash_engine_alg algs_sha3[] = {
 	{
-		.init = stm32_hash_init,
-		.update = stm32_hash_update,
-		.final = stm32_hash_final,
-		.finup = stm32_hash_finup,
-		.digest = stm32_hash_digest,
-		.export = stm32_hash_export,
-		.import = stm32_hash_import,
-		.halg = {
+		.base.init = stm32_hash_init,
+		.base.update = stm32_hash_update,
+		.base.final = stm32_hash_final,
+		.base.finup = stm32_hash_finup,
+		.base.digest = stm32_hash_digest,
+		.base.export = stm32_hash_export,
+		.base.import = stm32_hash_import,
+		.base.halg = {
 			.digestsize = SHA3_224_DIGEST_SIZE,
 			.statesize = sizeof(struct stm32_hash_state),
 			.base = {
@@ -1626,18 +1657,21 @@ static struct ahash_alg algs_sha3[] = {
 				.cra_exit = stm32_hash_cra_exit,
 				.cra_module = THIS_MODULE,
 			}
-		}
+		},
+		.op = {
+			.do_one_request = stm32_hash_one_request,
+		},
 	},
 	{
-		.init = stm32_hash_init,
-		.update = stm32_hash_update,
-		.final = stm32_hash_final,
-		.finup = stm32_hash_finup,
-		.digest = stm32_hash_digest,
-		.export = stm32_hash_export,
-		.import = stm32_hash_import,
-		.setkey = stm32_hash_setkey,
-		.halg = {
+		.base.init = stm32_hash_init,
+		.base.update = stm32_hash_update,
+		.base.final = stm32_hash_final,
+		.base.finup = stm32_hash_finup,
+		.base.digest = stm32_hash_digest,
+		.base.export = stm32_hash_export,
+		.base.import = stm32_hash_import,
+		.base.setkey = stm32_hash_setkey,
+		.base.halg = {
 			.digestsize = SHA3_224_DIGEST_SIZE,
 			.statesize = sizeof(struct stm32_hash_state),
 			.base = {
@@ -1653,17 +1687,20 @@ static struct ahash_alg algs_sha3[] = {
 				.cra_exit = stm32_hash_cra_exit,
 				.cra_module = THIS_MODULE,
 			}
-		}
+		},
+		.op = {
+			.do_one_request = stm32_hash_one_request,
+		},
 	},
-		{
-		.init = stm32_hash_init,
-		.update = stm32_hash_update,
-		.final = stm32_hash_final,
-		.finup = stm32_hash_finup,
-		.digest = stm32_hash_digest,
-		.export = stm32_hash_export,
-		.import = stm32_hash_import,
-		.halg = {
+	{
+		.base.init = stm32_hash_init,
+		.base.update = stm32_hash_update,
+		.base.final = stm32_hash_final,
+		.base.finup = stm32_hash_finup,
+		.base.digest = stm32_hash_digest,
+		.base.export = stm32_hash_export,
+		.base.import = stm32_hash_import,
+		.base.halg = {
 			.digestsize = SHA3_256_DIGEST_SIZE,
 			.statesize = sizeof(struct stm32_hash_state),
 			.base = {
@@ -1679,18 +1716,21 @@ static struct ahash_alg algs_sha3[] = {
 				.cra_exit = stm32_hash_cra_exit,
 				.cra_module = THIS_MODULE,
 			}
-		}
+		},
+		.op = {
+			.do_one_request = stm32_hash_one_request,
+		},
 	},
 	{
-		.init = stm32_hash_init,
-		.update = stm32_hash_update,
-		.final = stm32_hash_final,
-		.finup = stm32_hash_finup,
-		.digest = stm32_hash_digest,
-		.export = stm32_hash_export,
-		.import = stm32_hash_import,
-		.setkey = stm32_hash_setkey,
-		.halg = {
+		.base.init = stm32_hash_init,
+		.base.update = stm32_hash_update,
+		.base.final = stm32_hash_final,
+		.base.finup = stm32_hash_finup,
+		.base.digest = stm32_hash_digest,
+		.base.export = stm32_hash_export,
+		.base.import = stm32_hash_import,
+		.base.setkey = stm32_hash_setkey,
+		.base.halg = {
 			.digestsize = SHA3_256_DIGEST_SIZE,
 			.statesize = sizeof(struct stm32_hash_state),
 			.base = {
@@ -1706,17 +1746,20 @@ static struct ahash_alg algs_sha3[] = {
 				.cra_exit = stm32_hash_cra_exit,
 				.cra_module = THIS_MODULE,
 			}
-		}
+		},
+		.op = {
+			.do_one_request = stm32_hash_one_request,
+		},
 	},
 	{
-		.init = stm32_hash_init,
-		.update = stm32_hash_update,
-		.final = stm32_hash_final,
-		.finup = stm32_hash_finup,
-		.digest = stm32_hash_digest,
-		.export = stm32_hash_export,
-		.import = stm32_hash_import,
-		.halg = {
+		.base.init = stm32_hash_init,
+		.base.update = stm32_hash_update,
+		.base.final = stm32_hash_final,
+		.base.finup = stm32_hash_finup,
+		.base.digest = stm32_hash_digest,
+		.base.export = stm32_hash_export,
+		.base.import = stm32_hash_import,
+		.base.halg = {
 			.digestsize = SHA3_384_DIGEST_SIZE,
 			.statesize = sizeof(struct stm32_hash_state),
 			.base = {
@@ -1732,18 +1775,21 @@ static struct ahash_alg algs_sha3[] = {
 				.cra_exit = stm32_hash_cra_exit,
 				.cra_module = THIS_MODULE,
 			}
-		}
+		},
+		.op = {
+			.do_one_request = stm32_hash_one_request,
+		},
 	},
 	{
-		.init = stm32_hash_init,
-		.update = stm32_hash_update,
-		.final = stm32_hash_final,
-		.finup = stm32_hash_finup,
-		.digest = stm32_hash_digest,
-		.export = stm32_hash_export,
-		.import = stm32_hash_import,
-		.setkey = stm32_hash_setkey,
-		.halg = {
+		.base.init = stm32_hash_init,
+		.base.update = stm32_hash_update,
+		.base.final = stm32_hash_final,
+		.base.finup = stm32_hash_finup,
+		.base.digest = stm32_hash_digest,
+		.base.export = stm32_hash_export,
+		.base.import = stm32_hash_import,
+		.base.setkey = stm32_hash_setkey,
+		.base.halg = {
 			.digestsize = SHA3_384_DIGEST_SIZE,
 			.statesize = sizeof(struct stm32_hash_state),
 			.base = {
@@ -1759,17 +1805,20 @@ static struct ahash_alg algs_sha3[] = {
 				.cra_exit = stm32_hash_cra_exit,
 				.cra_module = THIS_MODULE,
 			}
-		}
+		},
+		.op = {
+			.do_one_request = stm32_hash_one_request,
+		},
 	},
 	{
-		.init = stm32_hash_init,
-		.update = stm32_hash_update,
-		.final = stm32_hash_final,
-		.finup = stm32_hash_finup,
-		.digest = stm32_hash_digest,
-		.export = stm32_hash_export,
-		.import = stm32_hash_import,
-		.halg = {
+		.base.init = stm32_hash_init,
+		.base.update = stm32_hash_update,
+		.base.final = stm32_hash_final,
+		.base.finup = stm32_hash_finup,
+		.base.digest = stm32_hash_digest,
+		.base.export = stm32_hash_export,
+		.base.import = stm32_hash_import,
+		.base.halg = {
 			.digestsize = SHA3_512_DIGEST_SIZE,
 			.statesize = sizeof(struct stm32_hash_state),
 			.base = {
@@ -1785,18 +1834,21 @@ static struct ahash_alg algs_sha3[] = {
 				.cra_exit = stm32_hash_cra_exit,
 				.cra_module = THIS_MODULE,
 			}
-		}
+		},
+		.op = {
+			.do_one_request = stm32_hash_one_request,
+		},
 	},
 	{
-		.init = stm32_hash_init,
-		.update = stm32_hash_update,
-		.final = stm32_hash_final,
-		.finup = stm32_hash_finup,
-		.digest = stm32_hash_digest,
-		.export = stm32_hash_export,
-		.import = stm32_hash_import,
-		.setkey = stm32_hash_setkey,
-		.halg = {
+		.base.init = stm32_hash_init,
+		.base.update = stm32_hash_update,
+		.base.final = stm32_hash_final,
+		.base.finup = stm32_hash_finup,
+		.base.digest = stm32_hash_digest,
+		.base.export = stm32_hash_export,
+		.base.import = stm32_hash_import,
+		.base.setkey = stm32_hash_setkey,
+		.base.halg = {
 			.digestsize = SHA3_512_DIGEST_SIZE,
 			.statesize = sizeof(struct stm32_hash_state),
 			.base = {
@@ -1812,7 +1864,10 @@ static struct ahash_alg algs_sha3[] = {
 				.cra_exit = stm32_hash_cra_exit,
 				.cra_module = THIS_MODULE,
 			}
-		}
+		},
+		.op = {
+			.do_one_request = stm32_hash_one_request,
+		},
 	}
 };
 
@@ -1823,7 +1878,7 @@ static int stm32_hash_register_algs(struct stm32_hash_dev *hdev)
 
 	for (i = 0; i < hdev->pdata->algs_info_size; i++) {
 		for (j = 0; j < hdev->pdata->algs_info[i].size; j++) {
-			err = crypto_register_ahash(
+			err = crypto_engine_register_ahash(
 				&hdev->pdata->algs_info[i].algs_list[j]);
 			if (err)
 				goto err_algs;
@@ -1835,7 +1890,7 @@ static int stm32_hash_register_algs(struct stm32_hash_dev *hdev)
 	dev_err(hdev->dev, "Algo %d : %d failed\n", i, j);
 	for (; i--; ) {
 		for (; j--;)
-			crypto_unregister_ahash(
+			crypto_engine_unregister_ahash(
 				&hdev->pdata->algs_info[i].algs_list[j]);
 	}
 
@@ -1848,7 +1903,7 @@ static int stm32_hash_unregister_algs(struct stm32_hash_dev *hdev)
 
 	for (i = 0; i < hdev->pdata->algs_info_size; i++) {
 		for (j = 0; j < hdev->pdata->algs_info[i].size; j++)
-			crypto_unregister_ahash(
+			crypto_engine_unregister_ahash(
 				&hdev->pdata->algs_info[i].algs_list[j]);
 	}
 
