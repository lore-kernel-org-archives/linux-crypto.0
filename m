Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97530C04A6A
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Aug 2023 09:31:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234007AbjHKJa7 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Aug 2023 05:30:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234919AbjHKJah (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Aug 2023 05:30:37 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 654E930D2
        for <linux-crypto@vger.kernel.org>; Fri, 11 Aug 2023 02:30:35 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qUOTW-0020hV-A6; Fri, 11 Aug 2023 17:30:31 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 11 Aug 2023 17:30:30 +0800
From:   "Herbert Xu" <herbert@gondor.apana.org.au>
Date:   Fri, 11 Aug 2023 17:30:30 +0800
Subject: [PATCH 25/36] crypto: aspeed - Use new crypto_engine_op interface
References: <ZNX/BwEkV3SDpsAS@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Gaurav Jain <gaurav.jain@nxp.com>
Message-Id: <E1qUOTW-0020hV-A6@formenos.hmeau.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Use the new crypto_engine_op interface where the callback is stored
in the algorithm object.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/crypto/aspeed/aspeed-acry.c        |   39 ++++----
 drivers/crypto/aspeed/aspeed-hace-crypto.c |  132 ++++++++++++++++++++---------
 drivers/crypto/aspeed/aspeed-hace-hash.c   |   97 ++++++++++++++++-----
 drivers/crypto/aspeed/aspeed-hace.c        |    9 +
 drivers/crypto/aspeed/aspeed-hace.h        |   30 +-----
 5 files changed, 202 insertions(+), 105 deletions(-)

diff --git a/drivers/crypto/aspeed/aspeed-acry.c b/drivers/crypto/aspeed/aspeed-acry.c
index 5ae529ce6806..2a970367e686 100644
--- a/drivers/crypto/aspeed/aspeed-acry.c
+++ b/drivers/crypto/aspeed/aspeed-acry.c
@@ -2,25 +2,26 @@
 /*
  * Copyright 2021 Aspeed Technology Inc.
  */
-#include <crypto/akcipher.h>
-#include <crypto/algapi.h>
 #include <crypto/engine.h>
 #include <crypto/internal/akcipher.h>
 #include <crypto/internal/rsa.h>
 #include <crypto/scatterwalk.h>
 #include <linux/clk.h>
-#include <linux/platform_device.h>
+#include <linux/count_zeros.h>
+#include <linux/dma-mapping.h>
+#include <linux/err.h>
+#include <linux/interrupt.h>
+#include <linux/kernel.h>
+#include <linux/mfd/syscon.h>
 #include <linux/module.h>
-#include <linux/of_address.h>
-#include <linux/of_irq.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
-#include <linux/mfd/syscon.h>
-#include <linux/interrupt.h>
-#include <linux/count_zeros.h>
-#include <linux/err.h>
-#include <linux/dma-mapping.h>
+#include <linux/of_address.h>
+#include <linux/of_irq.h>
+#include <linux/platform_device.h>
 #include <linux/regmap.h>
+#include <linux/slab.h>
+#include <linux/string.h>
 
 #ifdef CONFIG_CRYPTO_DEV_ASPEED_DEBUG
 #define ACRY_DBG(d, fmt, ...)	\
@@ -112,7 +113,6 @@ struct aspeed_acry_dev {
 };
 
 struct aspeed_acry_ctx {
-	struct crypto_engine_ctx	enginectx;
 	struct aspeed_acry_dev		*acry_dev;
 
 	struct rsa_key			key;
@@ -131,7 +131,7 @@ struct aspeed_acry_ctx {
 
 struct aspeed_acry_alg {
 	struct aspeed_acry_dev		*acry_dev;
-	struct akcipher_alg		akcipher;
+	struct akcipher_engine_alg	akcipher;
 };
 
 enum aspeed_rsa_key_mode {
@@ -577,7 +577,7 @@ static int aspeed_acry_rsa_init_tfm(struct crypto_akcipher *tfm)
 	const char *name = crypto_tfm_alg_name(&tfm->base);
 	struct aspeed_acry_alg *acry_alg;
 
-	acry_alg = container_of(alg, struct aspeed_acry_alg, akcipher);
+	acry_alg = container_of(alg, struct aspeed_acry_alg, akcipher.base);
 
 	ctx->acry_dev = acry_alg->acry_dev;
 
@@ -589,8 +589,6 @@ static int aspeed_acry_rsa_init_tfm(struct crypto_akcipher *tfm)
 		return PTR_ERR(ctx->fallback_tfm);
 	}
 
-	ctx->enginectx.op.do_one_request = aspeed_acry_do_request;
-
 	return 0;
 }
 
@@ -603,7 +601,7 @@ static void aspeed_acry_rsa_exit_tfm(struct crypto_akcipher *tfm)
 
 static struct aspeed_acry_alg aspeed_acry_akcipher_algs[] = {
 	{
-		.akcipher = {
+		.akcipher.base = {
 			.encrypt = aspeed_acry_rsa_enc,
 			.decrypt = aspeed_acry_rsa_dec,
 			.sign = aspeed_acry_rsa_dec,
@@ -625,6 +623,9 @@ static struct aspeed_acry_alg aspeed_acry_akcipher_algs[] = {
 				.cra_ctxsize = sizeof(struct aspeed_acry_ctx),
 			},
 		},
+		.akcipher.op = {
+			.do_one_request = aspeed_acry_do_request,
+		},
 	},
 };
 
@@ -634,10 +635,10 @@ static void aspeed_acry_register(struct aspeed_acry_dev *acry_dev)
 
 	for (i = 0; i < ARRAY_SIZE(aspeed_acry_akcipher_algs); i++) {
 		aspeed_acry_akcipher_algs[i].acry_dev = acry_dev;
-		rc = crypto_register_akcipher(&aspeed_acry_akcipher_algs[i].akcipher);
+		rc = crypto_engine_register_akcipher(&aspeed_acry_akcipher_algs[i].akcipher);
 		if (rc) {
 			ACRY_DBG(acry_dev, "Failed to register %s\n",
-				 aspeed_acry_akcipher_algs[i].akcipher.base.cra_name);
+				 aspeed_acry_akcipher_algs[i].akcipher.base.base.cra_name);
 		}
 	}
 }
@@ -647,7 +648,7 @@ static void aspeed_acry_unregister(struct aspeed_acry_dev *acry_dev)
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(aspeed_acry_akcipher_algs); i++)
-		crypto_unregister_akcipher(&aspeed_acry_akcipher_algs[i].akcipher);
+		crypto_engine_unregister_akcipher(&aspeed_acry_akcipher_algs[i].akcipher);
 }
 
 /* ACRY interrupt service routine. */
diff --git a/drivers/crypto/aspeed/aspeed-hace-crypto.c b/drivers/crypto/aspeed/aspeed-hace-crypto.c
index 8d6d9ecb3a28..f0eddb7854e5 100644
--- a/drivers/crypto/aspeed/aspeed-hace-crypto.c
+++ b/drivers/crypto/aspeed/aspeed-hace-crypto.c
@@ -4,6 +4,17 @@
  */
 
 #include "aspeed-hace.h"
+#include <crypto/des.h>
+#include <crypto/engine.h>
+#include <crypto/internal/des.h>
+#include <crypto/internal/skcipher.h>
+#include <linux/dma-mapping.h>
+#include <linux/err.h>
+#include <linux/io.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/scatterlist.h>
+#include <linux/string.h>
 
 #ifdef CONFIG_CRYPTO_DEV_ASPEED_HACE_CRYPTO_DEBUG
 #define CIPHER_DBG(h, fmt, ...)	\
@@ -696,7 +707,7 @@ static int aspeed_crypto_cra_init(struct crypto_skcipher *tfm)
 	struct aspeed_hace_alg *crypto_alg;
 
 
-	crypto_alg = container_of(alg, struct aspeed_hace_alg, alg.skcipher);
+	crypto_alg = container_of(alg, struct aspeed_hace_alg, alg.skcipher.base);
 	ctx->hace_dev = crypto_alg->hace_dev;
 	ctx->start = aspeed_hace_skcipher_trigger;
 
@@ -713,8 +724,6 @@ static int aspeed_crypto_cra_init(struct crypto_skcipher *tfm)
 	crypto_skcipher_set_reqsize(tfm, sizeof(struct aspeed_cipher_reqctx) +
 			 crypto_skcipher_reqsize(ctx->fallback_tfm));
 
-	ctx->enginectx.op.do_one_request = aspeed_crypto_do_request;
-
 	return 0;
 }
 
@@ -729,7 +738,7 @@ static void aspeed_crypto_cra_exit(struct crypto_skcipher *tfm)
 
 static struct aspeed_hace_alg aspeed_crypto_algs[] = {
 	{
-		.alg.skcipher = {
+		.alg.skcipher.base = {
 			.min_keysize	= AES_MIN_KEY_SIZE,
 			.max_keysize	= AES_MAX_KEY_SIZE,
 			.setkey		= aspeed_aes_setkey,
@@ -749,10 +758,13 @@ static struct aspeed_hace_alg aspeed_crypto_algs[] = {
 				.cra_alignmask		= 0x0f,
 				.cra_module		= THIS_MODULE,
 			}
-		}
+		},
+		.alg.skcipher.op = {
+			.do_one_request = aspeed_crypto_do_request,
+		},
 	},
 	{
-		.alg.skcipher = {
+		.alg.skcipher.base = {
 			.ivsize		= AES_BLOCK_SIZE,
 			.min_keysize	= AES_MIN_KEY_SIZE,
 			.max_keysize	= AES_MAX_KEY_SIZE,
@@ -773,10 +785,13 @@ static struct aspeed_hace_alg aspeed_crypto_algs[] = {
 				.cra_alignmask		= 0x0f,
 				.cra_module		= THIS_MODULE,
 			}
-		}
+		},
+		.alg.skcipher.op = {
+			.do_one_request = aspeed_crypto_do_request,
+		},
 	},
 	{
-		.alg.skcipher = {
+		.alg.skcipher.base = {
 			.ivsize		= AES_BLOCK_SIZE,
 			.min_keysize	= AES_MIN_KEY_SIZE,
 			.max_keysize	= AES_MAX_KEY_SIZE,
@@ -797,10 +812,13 @@ static struct aspeed_hace_alg aspeed_crypto_algs[] = {
 				.cra_alignmask		= 0x0f,
 				.cra_module		= THIS_MODULE,
 			}
-		}
+		},
+		.alg.skcipher.op = {
+			.do_one_request = aspeed_crypto_do_request,
+		},
 	},
 	{
-		.alg.skcipher = {
+		.alg.skcipher.base = {
 			.ivsize		= AES_BLOCK_SIZE,
 			.min_keysize	= AES_MIN_KEY_SIZE,
 			.max_keysize	= AES_MAX_KEY_SIZE,
@@ -821,10 +839,13 @@ static struct aspeed_hace_alg aspeed_crypto_algs[] = {
 				.cra_alignmask		= 0x0f,
 				.cra_module		= THIS_MODULE,
 			}
-		}
+		},
+		.alg.skcipher.op = {
+			.do_one_request = aspeed_crypto_do_request,
+		},
 	},
 	{
-		.alg.skcipher = {
+		.alg.skcipher.base = {
 			.min_keysize	= DES_KEY_SIZE,
 			.max_keysize	= DES_KEY_SIZE,
 			.setkey		= aspeed_des_setkey,
@@ -844,10 +865,13 @@ static struct aspeed_hace_alg aspeed_crypto_algs[] = {
 				.cra_alignmask		= 0x0f,
 				.cra_module		= THIS_MODULE,
 			}
-		}
+		},
+		.alg.skcipher.op = {
+			.do_one_request = aspeed_crypto_do_request,
+		},
 	},
 	{
-		.alg.skcipher = {
+		.alg.skcipher.base = {
 			.ivsize		= DES_BLOCK_SIZE,
 			.min_keysize	= DES_KEY_SIZE,
 			.max_keysize	= DES_KEY_SIZE,
@@ -868,10 +892,13 @@ static struct aspeed_hace_alg aspeed_crypto_algs[] = {
 				.cra_alignmask		= 0x0f,
 				.cra_module		= THIS_MODULE,
 			}
-		}
+		},
+		.alg.skcipher.op = {
+			.do_one_request = aspeed_crypto_do_request,
+		},
 	},
 	{
-		.alg.skcipher = {
+		.alg.skcipher.base = {
 			.ivsize		= DES_BLOCK_SIZE,
 			.min_keysize	= DES_KEY_SIZE,
 			.max_keysize	= DES_KEY_SIZE,
@@ -892,10 +919,13 @@ static struct aspeed_hace_alg aspeed_crypto_algs[] = {
 				.cra_alignmask		= 0x0f,
 				.cra_module		= THIS_MODULE,
 			}
-		}
+		},
+		.alg.skcipher.op = {
+			.do_one_request = aspeed_crypto_do_request,
+		},
 	},
 	{
-		.alg.skcipher = {
+		.alg.skcipher.base = {
 			.ivsize		= DES_BLOCK_SIZE,
 			.min_keysize	= DES_KEY_SIZE,
 			.max_keysize	= DES_KEY_SIZE,
@@ -916,10 +946,13 @@ static struct aspeed_hace_alg aspeed_crypto_algs[] = {
 				.cra_alignmask		= 0x0f,
 				.cra_module		= THIS_MODULE,
 			}
-		}
+		},
+		.alg.skcipher.op = {
+			.do_one_request = aspeed_crypto_do_request,
+		},
 	},
 	{
-		.alg.skcipher = {
+		.alg.skcipher.base = {
 			.min_keysize	= DES3_EDE_KEY_SIZE,
 			.max_keysize	= DES3_EDE_KEY_SIZE,
 			.setkey		= aspeed_des_setkey,
@@ -939,10 +972,13 @@ static struct aspeed_hace_alg aspeed_crypto_algs[] = {
 				.cra_alignmask		= 0x0f,
 				.cra_module		= THIS_MODULE,
 			}
-		}
+		},
+		.alg.skcipher.op = {
+			.do_one_request = aspeed_crypto_do_request,
+		},
 	},
 	{
-		.alg.skcipher = {
+		.alg.skcipher.base = {
 			.ivsize		= DES_BLOCK_SIZE,
 			.min_keysize	= DES3_EDE_KEY_SIZE,
 			.max_keysize	= DES3_EDE_KEY_SIZE,
@@ -963,10 +999,13 @@ static struct aspeed_hace_alg aspeed_crypto_algs[] = {
 				.cra_alignmask		= 0x0f,
 				.cra_module		= THIS_MODULE,
 			}
-		}
+		},
+		.alg.skcipher.op = {
+			.do_one_request = aspeed_crypto_do_request,
+		},
 	},
 	{
-		.alg.skcipher = {
+		.alg.skcipher.base = {
 			.ivsize		= DES_BLOCK_SIZE,
 			.min_keysize	= DES3_EDE_KEY_SIZE,
 			.max_keysize	= DES3_EDE_KEY_SIZE,
@@ -987,10 +1026,13 @@ static struct aspeed_hace_alg aspeed_crypto_algs[] = {
 				.cra_alignmask		= 0x0f,
 				.cra_module		= THIS_MODULE,
 			}
-		}
+		},
+		.alg.skcipher.op = {
+			.do_one_request = aspeed_crypto_do_request,
+		},
 	},
 	{
-		.alg.skcipher = {
+		.alg.skcipher.base = {
 			.ivsize		= DES_BLOCK_SIZE,
 			.min_keysize	= DES3_EDE_KEY_SIZE,
 			.max_keysize	= DES3_EDE_KEY_SIZE,
@@ -1011,13 +1053,16 @@ static struct aspeed_hace_alg aspeed_crypto_algs[] = {
 				.cra_alignmask		= 0x0f,
 				.cra_module		= THIS_MODULE,
 			}
-		}
+		},
+		.alg.skcipher.op = {
+			.do_one_request = aspeed_crypto_do_request,
+		},
 	},
 };
 
 static struct aspeed_hace_alg aspeed_crypto_algs_g6[] = {
 	{
-		.alg.skcipher = {
+		.alg.skcipher.base = {
 			.ivsize		= AES_BLOCK_SIZE,
 			.min_keysize	= AES_MIN_KEY_SIZE,
 			.max_keysize	= AES_MAX_KEY_SIZE,
@@ -1037,10 +1082,13 @@ static struct aspeed_hace_alg aspeed_crypto_algs_g6[] = {
 				.cra_alignmask		= 0x0f,
 				.cra_module		= THIS_MODULE,
 			}
-		}
+		},
+		.alg.skcipher.op = {
+			.do_one_request = aspeed_crypto_do_request,
+		},
 	},
 	{
-		.alg.skcipher = {
+		.alg.skcipher.base = {
 			.ivsize		= DES_BLOCK_SIZE,
 			.min_keysize	= DES_KEY_SIZE,
 			.max_keysize	= DES_KEY_SIZE,
@@ -1060,10 +1108,13 @@ static struct aspeed_hace_alg aspeed_crypto_algs_g6[] = {
 				.cra_alignmask		= 0x0f,
 				.cra_module		= THIS_MODULE,
 			}
-		}
+		},
+		.alg.skcipher.op = {
+			.do_one_request = aspeed_crypto_do_request,
+		},
 	},
 	{
-		.alg.skcipher = {
+		.alg.skcipher.base = {
 			.ivsize		= DES_BLOCK_SIZE,
 			.min_keysize	= DES3_EDE_KEY_SIZE,
 			.max_keysize	= DES3_EDE_KEY_SIZE,
@@ -1083,7 +1134,10 @@ static struct aspeed_hace_alg aspeed_crypto_algs_g6[] = {
 				.cra_alignmask		= 0x0f,
 				.cra_module		= THIS_MODULE,
 			}
-		}
+		},
+		.alg.skcipher.op = {
+			.do_one_request = aspeed_crypto_do_request,
+		},
 	},
 
 };
@@ -1093,13 +1147,13 @@ void aspeed_unregister_hace_crypto_algs(struct aspeed_hace_dev *hace_dev)
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(aspeed_crypto_algs); i++)
-		crypto_unregister_skcipher(&aspeed_crypto_algs[i].alg.skcipher);
+		crypto_engine_unregister_skcipher(&aspeed_crypto_algs[i].alg.skcipher);
 
 	if (hace_dev->version != AST2600_VERSION)
 		return;
 
 	for (i = 0; i < ARRAY_SIZE(aspeed_crypto_algs_g6); i++)
-		crypto_unregister_skcipher(&aspeed_crypto_algs_g6[i].alg.skcipher);
+		crypto_engine_unregister_skcipher(&aspeed_crypto_algs_g6[i].alg.skcipher);
 }
 
 void aspeed_register_hace_crypto_algs(struct aspeed_hace_dev *hace_dev)
@@ -1110,10 +1164,10 @@ void aspeed_register_hace_crypto_algs(struct aspeed_hace_dev *hace_dev)
 
 	for (i = 0; i < ARRAY_SIZE(aspeed_crypto_algs); i++) {
 		aspeed_crypto_algs[i].hace_dev = hace_dev;
-		rc = crypto_register_skcipher(&aspeed_crypto_algs[i].alg.skcipher);
+		rc = crypto_engine_register_skcipher(&aspeed_crypto_algs[i].alg.skcipher);
 		if (rc) {
 			CIPHER_DBG(hace_dev, "Failed to register %s\n",
-				   aspeed_crypto_algs[i].alg.skcipher.base.cra_name);
+				   aspeed_crypto_algs[i].alg.skcipher.base.base.cra_name);
 		}
 	}
 
@@ -1122,10 +1176,10 @@ void aspeed_register_hace_crypto_algs(struct aspeed_hace_dev *hace_dev)
 
 	for (i = 0; i < ARRAY_SIZE(aspeed_crypto_algs_g6); i++) {
 		aspeed_crypto_algs_g6[i].hace_dev = hace_dev;
-		rc = crypto_register_skcipher(&aspeed_crypto_algs_g6[i].alg.skcipher);
+		rc = crypto_engine_register_skcipher(&aspeed_crypto_algs_g6[i].alg.skcipher);
 		if (rc) {
 			CIPHER_DBG(hace_dev, "Failed to register %s\n",
-				   aspeed_crypto_algs_g6[i].alg.skcipher.base.cra_name);
+				   aspeed_crypto_algs_g6[i].alg.skcipher.base.base.cra_name);
 		}
 	}
 }
diff --git a/drivers/crypto/aspeed/aspeed-hace-hash.c b/drivers/crypto/aspeed/aspeed-hace-hash.c
index f8c96568142e..abc459af2ac8 100644
--- a/drivers/crypto/aspeed/aspeed-hace-hash.c
+++ b/drivers/crypto/aspeed/aspeed-hace-hash.c
@@ -4,6 +4,17 @@
  */
 
 #include "aspeed-hace.h"
+#include <crypto/engine.h>
+#include <crypto/hmac.h>
+#include <crypto/internal/hash.h>
+#include <crypto/scatterwalk.h>
+#include <crypto/sha1.h>
+#include <crypto/sha2.h>
+#include <linux/dma-mapping.h>
+#include <linux/err.h>
+#include <linux/io.h>
+#include <linux/kernel.h>
+#include <linux/string.h>
 
 #ifdef CONFIG_CRYPTO_DEV_ASPEED_DEBUG
 #define AHASH_DBG(h, fmt, ...)	\
@@ -858,7 +869,7 @@ static int aspeed_sham_cra_init(struct crypto_tfm *tfm)
 	struct aspeed_sham_ctx *tctx = crypto_tfm_ctx(tfm);
 	struct aspeed_hace_alg *ast_alg;
 
-	ast_alg = container_of(alg, struct aspeed_hace_alg, alg.ahash);
+	ast_alg = container_of(alg, struct aspeed_hace_alg, alg.ahash.base);
 	tctx->hace_dev = ast_alg->hace_dev;
 	tctx->flags = 0;
 
@@ -880,8 +891,6 @@ static int aspeed_sham_cra_init(struct crypto_tfm *tfm)
 		}
 	}
 
-	tctx->enginectx.op.do_one_request = aspeed_ahash_do_one;
-
 	return 0;
 }
 
@@ -919,7 +928,7 @@ static int aspeed_sham_import(struct ahash_request *req, const void *in)
 
 static struct aspeed_hace_alg aspeed_ahash_algs[] = {
 	{
-		.alg.ahash = {
+		.alg.ahash.base = {
 			.init	= aspeed_sham_init,
 			.update	= aspeed_sham_update,
 			.final	= aspeed_sham_final,
@@ -946,9 +955,12 @@ static struct aspeed_hace_alg aspeed_ahash_algs[] = {
 				}
 			}
 		},
+		.alg.ahash.op = {
+			.do_one_request = aspeed_ahash_do_one,
+		},
 	},
 	{
-		.alg.ahash = {
+		.alg.ahash.base = {
 			.init	= aspeed_sham_init,
 			.update	= aspeed_sham_update,
 			.final	= aspeed_sham_final,
@@ -975,9 +987,12 @@ static struct aspeed_hace_alg aspeed_ahash_algs[] = {
 				}
 			}
 		},
+		.alg.ahash.op = {
+			.do_one_request = aspeed_ahash_do_one,
+		},
 	},
 	{
-		.alg.ahash = {
+		.alg.ahash.base = {
 			.init	= aspeed_sham_init,
 			.update	= aspeed_sham_update,
 			.final	= aspeed_sham_final,
@@ -1004,10 +1019,13 @@ static struct aspeed_hace_alg aspeed_ahash_algs[] = {
 				}
 			}
 		},
+		.alg.ahash.op = {
+			.do_one_request = aspeed_ahash_do_one,
+		},
 	},
 	{
 		.alg_base = "sha1",
-		.alg.ahash = {
+		.alg.ahash.base = {
 			.init	= aspeed_sham_init,
 			.update	= aspeed_sham_update,
 			.final	= aspeed_sham_final,
@@ -1036,10 +1054,13 @@ static struct aspeed_hace_alg aspeed_ahash_algs[] = {
 				}
 			}
 		},
+		.alg.ahash.op = {
+			.do_one_request = aspeed_ahash_do_one,
+		},
 	},
 	{
 		.alg_base = "sha224",
-		.alg.ahash = {
+		.alg.ahash.base = {
 			.init	= aspeed_sham_init,
 			.update	= aspeed_sham_update,
 			.final	= aspeed_sham_final,
@@ -1068,10 +1089,13 @@ static struct aspeed_hace_alg aspeed_ahash_algs[] = {
 				}
 			}
 		},
+		.alg.ahash.op = {
+			.do_one_request = aspeed_ahash_do_one,
+		},
 	},
 	{
 		.alg_base = "sha256",
-		.alg.ahash = {
+		.alg.ahash.base = {
 			.init	= aspeed_sham_init,
 			.update	= aspeed_sham_update,
 			.final	= aspeed_sham_final,
@@ -1100,12 +1124,15 @@ static struct aspeed_hace_alg aspeed_ahash_algs[] = {
 				}
 			}
 		},
+		.alg.ahash.op = {
+			.do_one_request = aspeed_ahash_do_one,
+		},
 	},
 };
 
 static struct aspeed_hace_alg aspeed_ahash_algs_g6[] = {
 	{
-		.alg.ahash = {
+		.alg.ahash.base = {
 			.init	= aspeed_sham_init,
 			.update	= aspeed_sham_update,
 			.final	= aspeed_sham_final,
@@ -1132,9 +1159,12 @@ static struct aspeed_hace_alg aspeed_ahash_algs_g6[] = {
 				}
 			}
 		},
+		.alg.ahash.op = {
+			.do_one_request = aspeed_ahash_do_one,
+		},
 	},
 	{
-		.alg.ahash = {
+		.alg.ahash.base = {
 			.init	= aspeed_sham_init,
 			.update	= aspeed_sham_update,
 			.final	= aspeed_sham_final,
@@ -1161,9 +1191,12 @@ static struct aspeed_hace_alg aspeed_ahash_algs_g6[] = {
 				}
 			}
 		},
+		.alg.ahash.op = {
+			.do_one_request = aspeed_ahash_do_one,
+		},
 	},
 	{
-		.alg.ahash = {
+		.alg.ahash.base = {
 			.init	= aspeed_sha512s_init,
 			.update	= aspeed_sham_update,
 			.final	= aspeed_sham_final,
@@ -1190,9 +1223,12 @@ static struct aspeed_hace_alg aspeed_ahash_algs_g6[] = {
 				}
 			}
 		},
+		.alg.ahash.op = {
+			.do_one_request = aspeed_ahash_do_one,
+		},
 	},
 	{
-		.alg.ahash = {
+		.alg.ahash.base = {
 			.init	= aspeed_sha512s_init,
 			.update	= aspeed_sham_update,
 			.final	= aspeed_sham_final,
@@ -1219,10 +1255,13 @@ static struct aspeed_hace_alg aspeed_ahash_algs_g6[] = {
 				}
 			}
 		},
+		.alg.ahash.op = {
+			.do_one_request = aspeed_ahash_do_one,
+		},
 	},
 	{
 		.alg_base = "sha384",
-		.alg.ahash = {
+		.alg.ahash.base = {
 			.init	= aspeed_sham_init,
 			.update	= aspeed_sham_update,
 			.final	= aspeed_sham_final,
@@ -1251,10 +1290,13 @@ static struct aspeed_hace_alg aspeed_ahash_algs_g6[] = {
 				}
 			}
 		},
+		.alg.ahash.op = {
+			.do_one_request = aspeed_ahash_do_one,
+		},
 	},
 	{
 		.alg_base = "sha512",
-		.alg.ahash = {
+		.alg.ahash.base = {
 			.init	= aspeed_sham_init,
 			.update	= aspeed_sham_update,
 			.final	= aspeed_sham_final,
@@ -1283,10 +1325,13 @@ static struct aspeed_hace_alg aspeed_ahash_algs_g6[] = {
 				}
 			}
 		},
+		.alg.ahash.op = {
+			.do_one_request = aspeed_ahash_do_one,
+		},
 	},
 	{
 		.alg_base = "sha512_224",
-		.alg.ahash = {
+		.alg.ahash.base = {
 			.init	= aspeed_sha512s_init,
 			.update	= aspeed_sham_update,
 			.final	= aspeed_sham_final,
@@ -1315,10 +1360,13 @@ static struct aspeed_hace_alg aspeed_ahash_algs_g6[] = {
 				}
 			}
 		},
+		.alg.ahash.op = {
+			.do_one_request = aspeed_ahash_do_one,
+		},
 	},
 	{
 		.alg_base = "sha512_256",
-		.alg.ahash = {
+		.alg.ahash.base = {
 			.init	= aspeed_sha512s_init,
 			.update	= aspeed_sham_update,
 			.final	= aspeed_sham_final,
@@ -1347,6 +1395,9 @@ static struct aspeed_hace_alg aspeed_ahash_algs_g6[] = {
 				}
 			}
 		},
+		.alg.ahash.op = {
+			.do_one_request = aspeed_ahash_do_one,
+		},
 	},
 };
 
@@ -1355,13 +1406,13 @@ void aspeed_unregister_hace_hash_algs(struct aspeed_hace_dev *hace_dev)
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(aspeed_ahash_algs); i++)
-		crypto_unregister_ahash(&aspeed_ahash_algs[i].alg.ahash);
+		crypto_engine_unregister_ahash(&aspeed_ahash_algs[i].alg.ahash);
 
 	if (hace_dev->version != AST2600_VERSION)
 		return;
 
 	for (i = 0; i < ARRAY_SIZE(aspeed_ahash_algs_g6); i++)
-		crypto_unregister_ahash(&aspeed_ahash_algs_g6[i].alg.ahash);
+		crypto_engine_unregister_ahash(&aspeed_ahash_algs_g6[i].alg.ahash);
 }
 
 void aspeed_register_hace_hash_algs(struct aspeed_hace_dev *hace_dev)
@@ -1372,10 +1423,10 @@ void aspeed_register_hace_hash_algs(struct aspeed_hace_dev *hace_dev)
 
 	for (i = 0; i < ARRAY_SIZE(aspeed_ahash_algs); i++) {
 		aspeed_ahash_algs[i].hace_dev = hace_dev;
-		rc = crypto_register_ahash(&aspeed_ahash_algs[i].alg.ahash);
+		rc = crypto_engine_register_ahash(&aspeed_ahash_algs[i].alg.ahash);
 		if (rc) {
 			AHASH_DBG(hace_dev, "Failed to register %s\n",
-				  aspeed_ahash_algs[i].alg.ahash.halg.base.cra_name);
+				  aspeed_ahash_algs[i].alg.ahash.base.halg.base.cra_name);
 		}
 	}
 
@@ -1384,10 +1435,10 @@ void aspeed_register_hace_hash_algs(struct aspeed_hace_dev *hace_dev)
 
 	for (i = 0; i < ARRAY_SIZE(aspeed_ahash_algs_g6); i++) {
 		aspeed_ahash_algs_g6[i].hace_dev = hace_dev;
-		rc = crypto_register_ahash(&aspeed_ahash_algs_g6[i].alg.ahash);
+		rc = crypto_engine_register_ahash(&aspeed_ahash_algs_g6[i].alg.ahash);
 		if (rc) {
 			AHASH_DBG(hace_dev, "Failed to register %s\n",
-				  aspeed_ahash_algs_g6[i].alg.ahash.halg.base.cra_name);
+				  aspeed_ahash_algs_g6[i].alg.ahash.base.halg.base.cra_name);
 		}
 	}
 }
diff --git a/drivers/crypto/aspeed/aspeed-hace.c b/drivers/crypto/aspeed/aspeed-hace.c
index d2871e1de9c2..8f7aab82e1d8 100644
--- a/drivers/crypto/aspeed/aspeed-hace.c
+++ b/drivers/crypto/aspeed/aspeed-hace.c
@@ -3,7 +3,14 @@
  * Copyright (c) 2021 Aspeed Technology Inc.
  */
 
+#include "aspeed-hace.h"
+#include <crypto/engine.h>
 #include <linux/clk.h>
+#include <linux/dma-mapping.h>
+#include <linux/err.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/of_address.h>
 #include <linux/of_device.h>
@@ -11,8 +18,6 @@
 #include <linux/of.h>
 #include <linux/platform_device.h>
 
-#include "aspeed-hace.h"
-
 #ifdef CONFIG_CRYPTO_DEV_ASPEED_DEBUG
 #define HACE_DBG(d, fmt, ...)	\
 	dev_info((d)->dev, "%s() " fmt, __func__, ##__VA_ARGS__)
diff --git a/drivers/crypto/aspeed/aspeed-hace.h b/drivers/crypto/aspeed/aspeed-hace.h
index 05d0a15d546d..68f70e01fccb 100644
--- a/drivers/crypto/aspeed/aspeed-hace.h
+++ b/drivers/crypto/aspeed/aspeed-hace.h
@@ -2,25 +2,14 @@
 #ifndef __ASPEED_HACE_H__
 #define __ASPEED_HACE_H__
 
-#include <linux/interrupt.h>
-#include <linux/delay.h>
-#include <linux/err.h>
-#include <linux/fips.h>
-#include <linux/dma-mapping.h>
 #include <crypto/aes.h>
-#include <crypto/des.h>
-#include <crypto/scatterwalk.h>
-#include <crypto/internal/aead.h>
-#include <crypto/internal/akcipher.h>
-#include <crypto/internal/des.h>
-#include <crypto/internal/hash.h>
-#include <crypto/internal/kpp.h>
-#include <crypto/internal/skcipher.h>
-#include <crypto/algapi.h>
 #include <crypto/engine.h>
-#include <crypto/hmac.h>
-#include <crypto/sha1.h>
+#include <crypto/hash.h>
 #include <crypto/sha2.h>
+#include <linux/bits.h>
+#include <linux/compiler_attributes.h>
+#include <linux/interrupt.h>
+#include <linux/types.h>
 
 /*****************************
  *                           *
@@ -144,6 +133,7 @@
 					 HACE_CMD_OFB | HACE_CMD_CTR)
 
 struct aspeed_hace_dev;
+struct scatterlist;
 
 typedef int (*aspeed_hace_fn_t)(struct aspeed_hace_dev *);
 
@@ -178,8 +168,6 @@ struct aspeed_sha_hmac_ctx {
 };
 
 struct aspeed_sham_ctx {
-	struct crypto_engine_ctx	enginectx;
-
 	struct aspeed_hace_dev		*hace_dev;
 	unsigned long			flags;	/* hmac flag */
 
@@ -235,8 +223,6 @@ struct aspeed_engine_crypto {
 };
 
 struct aspeed_cipher_ctx {
-	struct crypto_engine_ctx	enginectx;
-
 	struct aspeed_hace_dev		*hace_dev;
 	int				key_len;
 	u8				key[AES_MAX_KEYLENGTH];
@@ -275,8 +261,8 @@ struct aspeed_hace_alg {
 	const char			*alg_base;
 
 	union {
-		struct skcipher_alg	skcipher;
-		struct ahash_alg	ahash;
+		struct skcipher_engine_alg skcipher;
+		struct ahash_engine_alg ahash;
 	} alg;
 };
 
