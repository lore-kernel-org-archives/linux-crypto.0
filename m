Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5990DC04A6A
	for <linux-crypto@archiver.kernel.org>; Sun, 13 Aug 2023 06:55:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230299AbjHMGzq (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 13 Aug 2023 02:55:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230025AbjHMGzQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 13 Aug 2023 02:55:16 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E0391725
        for <linux-crypto@vger.kernel.org>; Sat, 12 Aug 2023 23:55:17 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qV50K-002bwE-9i; Sun, 13 Aug 2023 14:55:13 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 13 Aug 2023 14:55:12 +0800
From:   "Herbert Xu" <herbert@gondor.apana.org.au>
Date:   Sun, 13 Aug 2023 14:55:12 +0800
Subject: [v2 PATCH 32/36] crypto: jh7110 - Use new crypto_engine_op interface
References: <ZNh94a7YYnvx0l8C@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Gaurav Jain <gaurav.jain@nxp.com>
Message-Id: <E1qV50K-002bwE-9i@formenos.hmeau.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Use the new crypto_engine_op interface where the callback is stored
in the algorithm object.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/crypto/starfive/jh7110-aes.c  |  164 +++++++++++--------
 drivers/crypto/starfive/jh7110-cryp.c |    9 -
 drivers/crypto/starfive/jh7110-cryp.h |    2 
 drivers/crypto/starfive/jh7110-hash.c |  282 ++++++++++++++++++----------------
 4 files changed, 252 insertions(+), 205 deletions(-)

diff --git a/drivers/crypto/starfive/jh7110-aes.c b/drivers/crypto/starfive/jh7110-aes.c
index 777656cbb7ce..9378e6682f0e 100644
--- a/drivers/crypto/starfive/jh7110-aes.c
+++ b/drivers/crypto/starfive/jh7110-aes.c
@@ -5,12 +5,17 @@
  * Copyright (c) 2022 StarFive Technology
  */
 
-#include <linux/iopoll.h>
+#include <crypto/engine.h>
 #include <crypto/gcm.h>
-#include <crypto/scatterwalk.h>
 #include <crypto/internal/aead.h>
 #include <crypto/internal/skcipher.h>
+#include <crypto/scatterwalk.h>
 #include "jh7110-cryp.h"
+#include <linux/err.h>
+#include <linux/iopoll.h>
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/string.h>
 
 #define STARFIVE_AES_REGS_OFFSET	0x100
 #define STARFIVE_AES_AESDIO0R		(STARFIVE_AES_REGS_OFFSET + 0x0)
@@ -554,8 +559,6 @@ static int starfive_aes_init_tfm(struct crypto_skcipher *tfm)
 	crypto_skcipher_set_reqsize(tfm, sizeof(struct starfive_cryp_request_ctx) +
 				    sizeof(struct skcipher_request));
 
-	ctx->enginectx.op.do_one_request = starfive_aes_do_one_req;
-
 	return 0;
 }
 
@@ -638,8 +641,6 @@ static int starfive_aes_aead_init_tfm(struct crypto_aead *tfm)
 	crypto_aead_set_reqsize(tfm, sizeof(struct starfive_cryp_ctx) +
 				sizeof(struct aead_request));
 
-	ctx->enginectx.op.do_one_request = starfive_aes_aead_do_one_req;
-
 	return 0;
 }
 
@@ -844,15 +845,15 @@ static int starfive_aes_ccm_decrypt(struct aead_request *req)
 	return starfive_aes_aead_crypt(req, STARFIVE_AES_MODE_CCM);
 }
 
-static struct skcipher_alg skcipher_algs[] = {
+static struct skcipher_engine_alg skcipher_algs[] = {
 {
-	.init				= starfive_aes_init_tfm,
-	.setkey				= starfive_aes_setkey,
-	.encrypt			= starfive_aes_ecb_encrypt,
-	.decrypt			= starfive_aes_ecb_decrypt,
-	.min_keysize			= AES_MIN_KEY_SIZE,
-	.max_keysize			= AES_MAX_KEY_SIZE,
-	.base = {
+	.base.init			= starfive_aes_init_tfm,
+	.base.setkey			= starfive_aes_setkey,
+	.base.encrypt			= starfive_aes_ecb_encrypt,
+	.base.decrypt			= starfive_aes_ecb_decrypt,
+	.base.min_keysize		= AES_MIN_KEY_SIZE,
+	.base.max_keysize		= AES_MAX_KEY_SIZE,
+	.base.base = {
 		.cra_name		= "ecb(aes)",
 		.cra_driver_name	= "starfive-ecb-aes",
 		.cra_priority		= 200,
@@ -862,15 +863,18 @@ static struct skcipher_alg skcipher_algs[] = {
 		.cra_alignmask		= 0xf,
 		.cra_module		= THIS_MODULE,
 	},
+	.op = {
+		.do_one_request = starfive_aes_do_one_req,
+	},
 }, {
-	.init				= starfive_aes_init_tfm,
-	.setkey				= starfive_aes_setkey,
-	.encrypt			= starfive_aes_cbc_encrypt,
-	.decrypt			= starfive_aes_cbc_decrypt,
-	.min_keysize			= AES_MIN_KEY_SIZE,
-	.max_keysize			= AES_MAX_KEY_SIZE,
-	.ivsize				= AES_BLOCK_SIZE,
-	.base = {
+	.base.init			= starfive_aes_init_tfm,
+	.base.setkey			= starfive_aes_setkey,
+	.base.encrypt			= starfive_aes_cbc_encrypt,
+	.base.decrypt			= starfive_aes_cbc_decrypt,
+	.base.min_keysize		= AES_MIN_KEY_SIZE,
+	.base.max_keysize		= AES_MAX_KEY_SIZE,
+	.base.ivsize			= AES_BLOCK_SIZE,
+	.base.base = {
 		.cra_name		= "cbc(aes)",
 		.cra_driver_name	= "starfive-cbc-aes",
 		.cra_priority		= 200,
@@ -880,15 +884,18 @@ static struct skcipher_alg skcipher_algs[] = {
 		.cra_alignmask		= 0xf,
 		.cra_module		= THIS_MODULE,
 	},
+	.op = {
+		.do_one_request = starfive_aes_do_one_req,
+	},
 }, {
-	.init				= starfive_aes_init_tfm,
-	.setkey				= starfive_aes_setkey,
-	.encrypt			= starfive_aes_ctr_encrypt,
-	.decrypt			= starfive_aes_ctr_decrypt,
-	.min_keysize			= AES_MIN_KEY_SIZE,
-	.max_keysize			= AES_MAX_KEY_SIZE,
-	.ivsize				= AES_BLOCK_SIZE,
-	.base = {
+	.base.init			= starfive_aes_init_tfm,
+	.base.setkey			= starfive_aes_setkey,
+	.base.encrypt			= starfive_aes_ctr_encrypt,
+	.base.decrypt			= starfive_aes_ctr_decrypt,
+	.base.min_keysize		= AES_MIN_KEY_SIZE,
+	.base.max_keysize		= AES_MAX_KEY_SIZE,
+	.base.ivsize			= AES_BLOCK_SIZE,
+	.base.base = {
 		.cra_name		= "ctr(aes)",
 		.cra_driver_name	= "starfive-ctr-aes",
 		.cra_priority		= 200,
@@ -898,15 +905,18 @@ static struct skcipher_alg skcipher_algs[] = {
 		.cra_alignmask		= 0xf,
 		.cra_module		= THIS_MODULE,
 	},
+	.op = {
+		.do_one_request = starfive_aes_do_one_req,
+	},
 }, {
-	.init				= starfive_aes_init_tfm,
-	.setkey				= starfive_aes_setkey,
-	.encrypt			= starfive_aes_cfb_encrypt,
-	.decrypt			= starfive_aes_cfb_decrypt,
-	.min_keysize			= AES_MIN_KEY_SIZE,
-	.max_keysize			= AES_MAX_KEY_SIZE,
-	.ivsize				= AES_BLOCK_SIZE,
-	.base = {
+	.base.init			= starfive_aes_init_tfm,
+	.base.setkey			= starfive_aes_setkey,
+	.base.encrypt			= starfive_aes_cfb_encrypt,
+	.base.decrypt			= starfive_aes_cfb_decrypt,
+	.base.min_keysize		= AES_MIN_KEY_SIZE,
+	.base.max_keysize		= AES_MAX_KEY_SIZE,
+	.base.ivsize			= AES_BLOCK_SIZE,
+	.base.base = {
 		.cra_name		= "cfb(aes)",
 		.cra_driver_name	= "starfive-cfb-aes",
 		.cra_priority		= 200,
@@ -916,15 +926,18 @@ static struct skcipher_alg skcipher_algs[] = {
 		.cra_alignmask		= 0xf,
 		.cra_module		= THIS_MODULE,
 	},
+	.op = {
+		.do_one_request = starfive_aes_do_one_req,
+	},
 }, {
-	.init				= starfive_aes_init_tfm,
-	.setkey				= starfive_aes_setkey,
-	.encrypt			= starfive_aes_ofb_encrypt,
-	.decrypt			= starfive_aes_ofb_decrypt,
-	.min_keysize			= AES_MIN_KEY_SIZE,
-	.max_keysize			= AES_MAX_KEY_SIZE,
-	.ivsize				= AES_BLOCK_SIZE,
-	.base = {
+	.base.init			= starfive_aes_init_tfm,
+	.base.setkey			= starfive_aes_setkey,
+	.base.encrypt			= starfive_aes_ofb_encrypt,
+	.base.decrypt			= starfive_aes_ofb_decrypt,
+	.base.min_keysize		= AES_MIN_KEY_SIZE,
+	.base.max_keysize		= AES_MAX_KEY_SIZE,
+	.base.ivsize			= AES_BLOCK_SIZE,
+	.base.base = {
 		.cra_name		= "ofb(aes)",
 		.cra_driver_name	= "starfive-ofb-aes",
 		.cra_priority		= 200,
@@ -934,20 +947,23 @@ static struct skcipher_alg skcipher_algs[] = {
 		.cra_alignmask		= 0xf,
 		.cra_module		= THIS_MODULE,
 	},
+	.op = {
+		.do_one_request = starfive_aes_do_one_req,
+	},
 },
 };
 
-static struct aead_alg aead_algs[] = {
-{
-	.setkey                         = starfive_aes_aead_setkey,
-	.setauthsize                    = starfive_aes_gcm_setauthsize,
-	.encrypt                        = starfive_aes_gcm_encrypt,
-	.decrypt                        = starfive_aes_gcm_decrypt,
-	.init                           = starfive_aes_aead_init_tfm,
-	.exit                           = starfive_aes_aead_exit_tfm,
-	.ivsize                         = GCM_AES_IV_SIZE,
-	.maxauthsize                    = AES_BLOCK_SIZE,
-	.base = {
+static struct aead_engine_alg aead_algs[] = {
+{
+	.base.setkey			= starfive_aes_aead_setkey,
+	.base.setauthsize		= starfive_aes_gcm_setauthsize,
+	.base.encrypt			= starfive_aes_gcm_encrypt,
+	.base.decrypt			= starfive_aes_gcm_decrypt,
+	.base.init			= starfive_aes_aead_init_tfm,
+	.base.exit			= starfive_aes_aead_exit_tfm,
+	.base.ivsize			= GCM_AES_IV_SIZE,
+	.base.maxauthsize		= AES_BLOCK_SIZE,
+	.base.base = {
 		.cra_name               = "gcm(aes)",
 		.cra_driver_name        = "starfive-gcm-aes",
 		.cra_priority           = 200,
@@ -957,16 +973,19 @@ static struct aead_alg aead_algs[] = {
 		.cra_alignmask          = 0xf,
 		.cra_module             = THIS_MODULE,
 	},
+	.op = {
+		.do_one_request = starfive_aes_aead_do_one_req,
+	},
 }, {
-	.setkey		                = starfive_aes_aead_setkey,
-	.setauthsize	                = starfive_aes_ccm_setauthsize,
-	.encrypt	                = starfive_aes_ccm_encrypt,
-	.decrypt	                = starfive_aes_ccm_decrypt,
-	.init		                = starfive_aes_aead_init_tfm,
-	.exit		                = starfive_aes_aead_exit_tfm,
-	.ivsize		                = AES_BLOCK_SIZE,
-	.maxauthsize	                = AES_BLOCK_SIZE,
-	.base = {
+	.base.setkey			= starfive_aes_aead_setkey,
+	.base.setauthsize		= starfive_aes_ccm_setauthsize,
+	.base.encrypt			= starfive_aes_ccm_encrypt,
+	.base.decrypt			= starfive_aes_ccm_decrypt,
+	.base.init			= starfive_aes_aead_init_tfm,
+	.base.exit			= starfive_aes_aead_exit_tfm,
+	.base.ivsize			= AES_BLOCK_SIZE,
+	.base.maxauthsize		= AES_BLOCK_SIZE,
+	.base.base = {
 		.cra_name		= "ccm(aes)",
 		.cra_driver_name	= "starfive-ccm-aes",
 		.cra_priority		= 200,
@@ -977,6 +996,9 @@ static struct aead_alg aead_algs[] = {
 		.cra_alignmask		= 0xf,
 		.cra_module		= THIS_MODULE,
 	},
+	.op = {
+		.do_one_request = starfive_aes_aead_do_one_req,
+	},
 },
 };
 
@@ -984,19 +1006,19 @@ int starfive_aes_register_algs(void)
 {
 	int ret;
 
-	ret = crypto_register_skciphers(skcipher_algs, ARRAY_SIZE(skcipher_algs));
+	ret = crypto_engine_register_skciphers(skcipher_algs, ARRAY_SIZE(skcipher_algs));
 	if (ret)
 		return ret;
 
-	ret = crypto_register_aeads(aead_algs, ARRAY_SIZE(aead_algs));
+	ret = crypto_engine_register_aeads(aead_algs, ARRAY_SIZE(aead_algs));
 	if (ret)
-		crypto_unregister_skciphers(skcipher_algs, ARRAY_SIZE(skcipher_algs));
+		crypto_engine_unregister_skciphers(skcipher_algs, ARRAY_SIZE(skcipher_algs));
 
 	return ret;
 }
 
 void starfive_aes_unregister_algs(void)
 {
-	crypto_unregister_aeads(aead_algs, ARRAY_SIZE(aead_algs));
-	crypto_unregister_skciphers(skcipher_algs, ARRAY_SIZE(skcipher_algs));
+	crypto_engine_unregister_aeads(aead_algs, ARRAY_SIZE(aead_algs));
+	crypto_engine_unregister_skciphers(skcipher_algs, ARRAY_SIZE(skcipher_algs));
 }
diff --git a/drivers/crypto/starfive/jh7110-cryp.c b/drivers/crypto/starfive/jh7110-cryp.c
index ab37010ceb88..890ad5259329 100644
--- a/drivers/crypto/starfive/jh7110-cryp.c
+++ b/drivers/crypto/starfive/jh7110-cryp.c
@@ -7,17 +7,20 @@
  *
  */
 
+#include <crypto/engine.h>
+#include "jh7110-cryp.h"
 #include <linux/clk.h>
-#include <linux/delay.h>
+#include <linux/completion.h>
+#include <linux/err.h>
 #include <linux/interrupt.h>
 #include <linux/iopoll.h>
+#include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/of_device.h>
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
 #include <linux/reset.h>
-
-#include "jh7110-cryp.h"
+#include <linux/spinlock.h>
 
 #define DRIVER_NAME             "jh7110-crypto"
 
diff --git a/drivers/crypto/starfive/jh7110-cryp.h b/drivers/crypto/starfive/jh7110-cryp.h
index 345a8d878761..fe011d50473d 100644
--- a/drivers/crypto/starfive/jh7110-cryp.h
+++ b/drivers/crypto/starfive/jh7110-cryp.h
@@ -3,7 +3,6 @@
 #define __STARFIVE_STR_H__
 
 #include <crypto/aes.h>
-#include <crypto/engine.h>
 #include <crypto/hash.h>
 #include <crypto/scatterwalk.h>
 #include <crypto/sha2.h>
@@ -151,7 +150,6 @@ union starfive_alg_cr {
 };
 
 struct starfive_cryp_ctx {
-	struct crypto_engine_ctx		enginectx;
 	struct starfive_cryp_dev		*cryp;
 	struct starfive_cryp_request_ctx	*rctx;
 
diff --git a/drivers/crypto/starfive/jh7110-hash.c b/drivers/crypto/starfive/jh7110-hash.c
index 7fe89cd13336..739e944229af 100644
--- a/drivers/crypto/starfive/jh7110-hash.c
+++ b/drivers/crypto/starfive/jh7110-hash.c
@@ -6,11 +6,14 @@
  *
  */
 
+#include <crypto/engine.h>
+#include <crypto/internal/hash.h>
+#include <crypto/scatterwalk.h>
+#include "jh7110-cryp.h"
+#include <linux/amba/pl080.h>
 #include <linux/clk.h>
-#include <linux/crypto.h>
 #include <linux/dma-direct.h>
 #include <linux/interrupt.h>
-#include <linux/io.h>
 #include <linux/iopoll.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
@@ -18,13 +21,6 @@
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
 #include <linux/reset.h>
-#include <linux/amba/pl080.h>
-
-#include <crypto/hash.h>
-#include <crypto/scatterwalk.h>
-#include <crypto/internal/hash.h>
-
-#include "jh7110-cryp.h"
 
 #define STARFIVE_HASH_REGS_OFFSET	0x300
 #define STARFIVE_HASH_SHACSR		(STARFIVE_HASH_REGS_OFFSET + 0x0)
@@ -433,8 +429,6 @@ static int starfive_hash_init_tfm(struct crypto_ahash *hash,
 	ctx->keylen = 0;
 	ctx->hash_mode = mode;
 
-	ctx->enginectx.op.do_one_request = starfive_hash_one_request;
-
 	return 0;
 }
 
@@ -612,18 +606,18 @@ static int starfive_hmac_sm3_init_tfm(struct crypto_ahash *hash)
 				      STARFIVE_HASH_SM3);
 }
 
-static struct ahash_alg algs_sha2_sm3[] = {
+static struct ahash_engine_alg algs_sha2_sm3[] = {
 {
-	.init     = starfive_hash_init,
-	.update   = starfive_hash_update,
-	.final    = starfive_hash_final,
-	.finup    = starfive_hash_finup,
-	.digest   = starfive_hash_digest,
-	.export   = starfive_hash_export,
-	.import   = starfive_hash_import,
-	.init_tfm = starfive_sha224_init_tfm,
-	.exit_tfm = starfive_hash_exit_tfm,
-	.halg = {
+	.base.init     = starfive_hash_init,
+	.base.update   = starfive_hash_update,
+	.base.final    = starfive_hash_final,
+	.base.finup    = starfive_hash_finup,
+	.base.digest   = starfive_hash_digest,
+	.base.export   = starfive_hash_export,
+	.base.import   = starfive_hash_import,
+	.base.init_tfm = starfive_sha224_init_tfm,
+	.base.exit_tfm = starfive_hash_exit_tfm,
+	.base.halg = {
 		.digestsize = SHA224_DIGEST_SIZE,
 		.statesize  = sizeof(struct sha256_state),
 		.base = {
@@ -638,19 +632,22 @@ static struct ahash_alg algs_sha2_sm3[] = {
 			.cra_alignmask		= 3,
 			.cra_module		= THIS_MODULE,
 		}
-	}
+	},
+	.op = {
+		.do_one_request = starfive_hash_one_request,
+	},
 }, {
-	.init     = starfive_hash_init,
-	.update   = starfive_hash_update,
-	.final    = starfive_hash_final,
-	.finup    = starfive_hash_finup,
-	.digest   = starfive_hash_digest,
-	.export   = starfive_hash_export,
-	.import   = starfive_hash_import,
-	.init_tfm = starfive_hmac_sha224_init_tfm,
-	.exit_tfm = starfive_hash_exit_tfm,
-	.setkey   = starfive_hash_setkey,
-	.halg = {
+	.base.init     = starfive_hash_init,
+	.base.update   = starfive_hash_update,
+	.base.final    = starfive_hash_final,
+	.base.finup    = starfive_hash_finup,
+	.base.digest   = starfive_hash_digest,
+	.base.export   = starfive_hash_export,
+	.base.import   = starfive_hash_import,
+	.base.init_tfm = starfive_hmac_sha224_init_tfm,
+	.base.exit_tfm = starfive_hash_exit_tfm,
+	.base.setkey   = starfive_hash_setkey,
+	.base.halg = {
 		.digestsize = SHA224_DIGEST_SIZE,
 		.statesize  = sizeof(struct sha256_state),
 		.base = {
@@ -665,18 +662,21 @@ static struct ahash_alg algs_sha2_sm3[] = {
 			.cra_alignmask		= 3,
 			.cra_module		= THIS_MODULE,
 		}
-	}
+	},
+	.op = {
+		.do_one_request = starfive_hash_one_request,
+	},
 }, {
-	.init     = starfive_hash_init,
-	.update   = starfive_hash_update,
-	.final    = starfive_hash_final,
-	.finup    = starfive_hash_finup,
-	.digest   = starfive_hash_digest,
-	.export   = starfive_hash_export,
-	.import   = starfive_hash_import,
-	.init_tfm = starfive_sha256_init_tfm,
-	.exit_tfm = starfive_hash_exit_tfm,
-	.halg = {
+	.base.init     = starfive_hash_init,
+	.base.update   = starfive_hash_update,
+	.base.final    = starfive_hash_final,
+	.base.finup    = starfive_hash_finup,
+	.base.digest   = starfive_hash_digest,
+	.base.export   = starfive_hash_export,
+	.base.import   = starfive_hash_import,
+	.base.init_tfm = starfive_sha256_init_tfm,
+	.base.exit_tfm = starfive_hash_exit_tfm,
+	.base.halg = {
 		.digestsize = SHA256_DIGEST_SIZE,
 		.statesize  = sizeof(struct sha256_state),
 		.base = {
@@ -691,19 +691,22 @@ static struct ahash_alg algs_sha2_sm3[] = {
 			.cra_alignmask		= 3,
 			.cra_module		= THIS_MODULE,
 		}
-	}
+	},
+	.op = {
+		.do_one_request = starfive_hash_one_request,
+	},
 }, {
-	.init     = starfive_hash_init,
-	.update   = starfive_hash_update,
-	.final    = starfive_hash_final,
-	.finup    = starfive_hash_finup,
-	.digest   = starfive_hash_digest,
-	.export   = starfive_hash_export,
-	.import   = starfive_hash_import,
-	.init_tfm = starfive_hmac_sha256_init_tfm,
-	.exit_tfm = starfive_hash_exit_tfm,
-	.setkey   = starfive_hash_setkey,
-	.halg = {
+	.base.init     = starfive_hash_init,
+	.base.update   = starfive_hash_update,
+	.base.final    = starfive_hash_final,
+	.base.finup    = starfive_hash_finup,
+	.base.digest   = starfive_hash_digest,
+	.base.export   = starfive_hash_export,
+	.base.import   = starfive_hash_import,
+	.base.init_tfm = starfive_hmac_sha256_init_tfm,
+	.base.exit_tfm = starfive_hash_exit_tfm,
+	.base.setkey   = starfive_hash_setkey,
+	.base.halg = {
 		.digestsize = SHA256_DIGEST_SIZE,
 		.statesize  = sizeof(struct sha256_state),
 		.base = {
@@ -718,18 +721,21 @@ static struct ahash_alg algs_sha2_sm3[] = {
 			.cra_alignmask		= 3,
 			.cra_module		= THIS_MODULE,
 		}
-	}
+	},
+	.op = {
+		.do_one_request = starfive_hash_one_request,
+	},
 }, {
-	.init     = starfive_hash_init,
-	.update   = starfive_hash_update,
-	.final    = starfive_hash_final,
-	.finup    = starfive_hash_finup,
-	.digest   = starfive_hash_digest,
-	.export   = starfive_hash_export,
-	.import   = starfive_hash_import,
-	.init_tfm = starfive_sha384_init_tfm,
-	.exit_tfm = starfive_hash_exit_tfm,
-	.halg = {
+	.base.init     = starfive_hash_init,
+	.base.update   = starfive_hash_update,
+	.base.final    = starfive_hash_final,
+	.base.finup    = starfive_hash_finup,
+	.base.digest   = starfive_hash_digest,
+	.base.export   = starfive_hash_export,
+	.base.import   = starfive_hash_import,
+	.base.init_tfm = starfive_sha384_init_tfm,
+	.base.exit_tfm = starfive_hash_exit_tfm,
+	.base.halg = {
 		.digestsize = SHA384_DIGEST_SIZE,
 		.statesize  = sizeof(struct sha512_state),
 		.base = {
@@ -744,19 +750,22 @@ static struct ahash_alg algs_sha2_sm3[] = {
 			.cra_alignmask		= 3,
 			.cra_module		= THIS_MODULE,
 		}
-	}
+	},
+	.op = {
+		.do_one_request = starfive_hash_one_request,
+	},
 }, {
-	.init     = starfive_hash_init,
-	.update   = starfive_hash_update,
-	.final    = starfive_hash_final,
-	.finup    = starfive_hash_finup,
-	.digest   = starfive_hash_digest,
-	.export   = starfive_hash_export,
-	.import   = starfive_hash_import,
-	.init_tfm = starfive_hmac_sha384_init_tfm,
-	.exit_tfm = starfive_hash_exit_tfm,
-	.setkey   = starfive_hash_setkey,
-	.halg = {
+	.base.init     = starfive_hash_init,
+	.base.update   = starfive_hash_update,
+	.base.final    = starfive_hash_final,
+	.base.finup    = starfive_hash_finup,
+	.base.digest   = starfive_hash_digest,
+	.base.export   = starfive_hash_export,
+	.base.import   = starfive_hash_import,
+	.base.init_tfm = starfive_hmac_sha384_init_tfm,
+	.base.exit_tfm = starfive_hash_exit_tfm,
+	.base.setkey   = starfive_hash_setkey,
+	.base.halg = {
 		.digestsize = SHA384_DIGEST_SIZE,
 		.statesize  = sizeof(struct sha512_state),
 		.base = {
@@ -771,18 +780,21 @@ static struct ahash_alg algs_sha2_sm3[] = {
 			.cra_alignmask		= 3,
 			.cra_module		= THIS_MODULE,
 		}
-	}
+	},
+	.op = {
+		.do_one_request = starfive_hash_one_request,
+	},
 }, {
-	.init     = starfive_hash_init,
-	.update   = starfive_hash_update,
-	.final    = starfive_hash_final,
-	.finup    = starfive_hash_finup,
-	.digest   = starfive_hash_digest,
-	.export   = starfive_hash_export,
-	.import   = starfive_hash_import,
-	.init_tfm = starfive_sha512_init_tfm,
-	.exit_tfm = starfive_hash_exit_tfm,
-	.halg = {
+	.base.init     = starfive_hash_init,
+	.base.update   = starfive_hash_update,
+	.base.final    = starfive_hash_final,
+	.base.finup    = starfive_hash_finup,
+	.base.digest   = starfive_hash_digest,
+	.base.export   = starfive_hash_export,
+	.base.import   = starfive_hash_import,
+	.base.init_tfm = starfive_sha512_init_tfm,
+	.base.exit_tfm = starfive_hash_exit_tfm,
+	.base.halg = {
 		.digestsize = SHA512_DIGEST_SIZE,
 		.statesize  = sizeof(struct sha512_state),
 		.base = {
@@ -797,19 +809,22 @@ static struct ahash_alg algs_sha2_sm3[] = {
 			.cra_alignmask		= 3,
 			.cra_module		= THIS_MODULE,
 		}
-	}
+	},
+	.op = {
+		.do_one_request = starfive_hash_one_request,
+	},
 }, {
-	.init     = starfive_hash_init,
-	.update   = starfive_hash_update,
-	.final    = starfive_hash_final,
-	.finup    = starfive_hash_finup,
-	.digest   = starfive_hash_digest,
-	.export   = starfive_hash_export,
-	.import   = starfive_hash_import,
-	.init_tfm = starfive_hmac_sha512_init_tfm,
-	.exit_tfm = starfive_hash_exit_tfm,
-	.setkey   = starfive_hash_setkey,
-	.halg = {
+	.base.init     = starfive_hash_init,
+	.base.update   = starfive_hash_update,
+	.base.final    = starfive_hash_final,
+	.base.finup    = starfive_hash_finup,
+	.base.digest   = starfive_hash_digest,
+	.base.export   = starfive_hash_export,
+	.base.import   = starfive_hash_import,
+	.base.init_tfm = starfive_hmac_sha512_init_tfm,
+	.base.exit_tfm = starfive_hash_exit_tfm,
+	.base.setkey   = starfive_hash_setkey,
+	.base.halg = {
 		.digestsize = SHA512_DIGEST_SIZE,
 		.statesize  = sizeof(struct sha512_state),
 		.base = {
@@ -824,18 +839,21 @@ static struct ahash_alg algs_sha2_sm3[] = {
 			.cra_alignmask		= 3,
 			.cra_module		= THIS_MODULE,
 		}
-	}
+	},
+	.op = {
+		.do_one_request = starfive_hash_one_request,
+	},
 }, {
-	.init     = starfive_hash_init,
-	.update   = starfive_hash_update,
-	.final    = starfive_hash_final,
-	.finup    = starfive_hash_finup,
-	.digest   = starfive_hash_digest,
-	.export   = starfive_hash_export,
-	.import   = starfive_hash_import,
-	.init_tfm = starfive_sm3_init_tfm,
-	.exit_tfm = starfive_hash_exit_tfm,
-	.halg = {
+	.base.init     = starfive_hash_init,
+	.base.update   = starfive_hash_update,
+	.base.final    = starfive_hash_final,
+	.base.finup    = starfive_hash_finup,
+	.base.digest   = starfive_hash_digest,
+	.base.export   = starfive_hash_export,
+	.base.import   = starfive_hash_import,
+	.base.init_tfm = starfive_sm3_init_tfm,
+	.base.exit_tfm = starfive_hash_exit_tfm,
+	.base.halg = {
 		.digestsize = SM3_DIGEST_SIZE,
 		.statesize  = sizeof(struct sm3_state),
 		.base = {
@@ -850,19 +868,22 @@ static struct ahash_alg algs_sha2_sm3[] = {
 			.cra_alignmask		= 3,
 			.cra_module		= THIS_MODULE,
 		}
-	}
+	},
+	.op = {
+		.do_one_request = starfive_hash_one_request,
+	},
 }, {
-	.init	  = starfive_hash_init,
-	.update	  = starfive_hash_update,
-	.final	  = starfive_hash_final,
-	.finup	  = starfive_hash_finup,
-	.digest	  = starfive_hash_digest,
-	.export	  = starfive_hash_export,
-	.import	  = starfive_hash_import,
-	.init_tfm = starfive_hmac_sm3_init_tfm,
-	.exit_tfm = starfive_hash_exit_tfm,
-	.setkey	  = starfive_hash_setkey,
-	.halg = {
+	.base.init	  = starfive_hash_init,
+	.base.update	  = starfive_hash_update,
+	.base.final	  = starfive_hash_final,
+	.base.finup	  = starfive_hash_finup,
+	.base.digest	  = starfive_hash_digest,
+	.base.export	  = starfive_hash_export,
+	.base.import	  = starfive_hash_import,
+	.base.init_tfm = starfive_hmac_sm3_init_tfm,
+	.base.exit_tfm = starfive_hash_exit_tfm,
+	.base.setkey	  = starfive_hash_setkey,
+	.base.halg = {
 		.digestsize = SM3_DIGEST_SIZE,
 		.statesize  = sizeof(struct sm3_state),
 		.base = {
@@ -877,16 +898,19 @@ static struct ahash_alg algs_sha2_sm3[] = {
 			.cra_alignmask		= 3,
 			.cra_module		= THIS_MODULE,
 		}
-	}
+	},
+	.op = {
+		.do_one_request = starfive_hash_one_request,
+	},
 },
 };
 
 int starfive_hash_register_algs(void)
 {
-	return crypto_register_ahashes(algs_sha2_sm3, ARRAY_SIZE(algs_sha2_sm3));
+	return crypto_engine_register_ahashes(algs_sha2_sm3, ARRAY_SIZE(algs_sha2_sm3));
 }
 
 void starfive_hash_unregister_algs(void)
 {
-	crypto_unregister_ahashes(algs_sha2_sm3, ARRAY_SIZE(algs_sha2_sm3));
+	crypto_engine_unregister_ahashes(algs_sha2_sm3, ARRAY_SIZE(algs_sha2_sm3));
 }
