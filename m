Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F949C001DB
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Aug 2023 09:30:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235048AbjHKJaw (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Aug 2023 05:30:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234959AbjHKJaa (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Aug 2023 05:30:30 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D07612D79
        for <linux-crypto@vger.kernel.org>; Fri, 11 Aug 2023 02:30:28 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qUOTQ-0020gC-0Q; Fri, 11 Aug 2023 17:30:25 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 11 Aug 2023 17:30:24 +0800
From:   "Herbert Xu" <herbert@gondor.apana.org.au>
Date:   Fri, 11 Aug 2023 17:30:24 +0800
Subject: [PATCH 22/36] crypto: sun8i-ce - Use new crypto_engine_op interface
References: <ZNX/BwEkV3SDpsAS@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Gaurav Jain <gaurav.jain@nxp.com>
Message-Id: <E1qUOTQ-0020gC-0Q@formenos.hmeau.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Use the new crypto_engine_op interface where the callback is stored
in the algorithm object.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c |   10 -
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c   |  171 ++++++++++++--------
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c   |   52 +++---
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h        |   13 -
 4 files changed, 144 insertions(+), 102 deletions(-)

diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
index 573a08fa7afa..4c3a8e3e9c2c 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
@@ -29,7 +29,7 @@ static int sun8i_ce_cipher_need_fallback(struct skcipher_request *areq)
 	struct sun8i_ce_alg_template *algt;
 	unsigned int todo, len;
 
-	algt = container_of(alg, struct sun8i_ce_alg_template, alg.skcipher);
+	algt = container_of(alg, struct sun8i_ce_alg_template, alg.skcipher.base);
 
 	if (sg_nents_for_len(areq->src, areq->cryptlen) > MAX_SG ||
 	    sg_nents_for_len(areq->dst, areq->cryptlen) > MAX_SG) {
@@ -133,7 +133,7 @@ static int sun8i_ce_cipher_prepare(struct crypto_engine *engine, void *async_req
 	int ns = sg_nents_for_len(areq->src, areq->cryptlen);
 	int nd = sg_nents_for_len(areq->dst, areq->cryptlen);
 
-	algt = container_of(alg, struct sun8i_ce_alg_template, alg.skcipher);
+	algt = container_of(alg, struct sun8i_ce_alg_template, alg.skcipher.base);
 
 	dev_dbg(ce->dev, "%s %s %u %x IV(%p %u) key=%u\n", __func__,
 		crypto_tfm_alg_name(areq->base.tfm),
@@ -355,7 +355,7 @@ static void sun8i_ce_cipher_unprepare(struct crypto_engine *engine,
 	dma_unmap_single(ce->dev, rctx->addr_key, op->keylen, DMA_TO_DEVICE);
 }
 
-static int sun8i_ce_cipher_do_one(struct crypto_engine *engine, void *areq)
+int sun8i_ce_cipher_do_one(struct crypto_engine *engine, void *areq)
 {
 	int err = sun8i_ce_cipher_prepare(engine, areq);
 
@@ -416,7 +416,7 @@ int sun8i_ce_cipher_init(struct crypto_tfm *tfm)
 
 	memset(op, 0, sizeof(struct sun8i_cipher_tfm_ctx));
 
-	algt = container_of(alg, struct sun8i_ce_alg_template, alg.skcipher);
+	algt = container_of(alg, struct sun8i_ce_alg_template, alg.skcipher.base);
 	op->ce = algt->ce;
 
 	op->fallback_tfm = crypto_alloc_skcipher(name, 0, CRYPTO_ALG_NEED_FALLBACK);
@@ -433,8 +433,6 @@ int sun8i_ce_cipher_init(struct crypto_tfm *tfm)
 	       crypto_tfm_alg_driver_name(crypto_skcipher_tfm(op->fallback_tfm)),
 	       CRYPTO_MAX_ALG_NAME);
 
-	op->enginectx.op.do_one_request = sun8i_ce_cipher_do_one;
-
 	err = pm_runtime_get_sync(op->ce->dev);
 	if (err < 0)
 		goto error_pm;
diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
index 07ea0cc82b16..1c2c32d0568e 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
@@ -9,21 +9,25 @@
  *
  * You could find a link for the datasheet in Documentation/arch/arm/sunxi.rst
  */
+
+#include <crypto/engine.h>
+#include <crypto/internal/hash.h>
+#include <crypto/internal/rng.h>
+#include <crypto/internal/skcipher.h>
 #include <linux/clk.h>
-#include <linux/crypto.h>
 #include <linux/delay.h>
 #include <linux/dma-mapping.h>
+#include <linux/err.h>
 #include <linux/interrupt.h>
 #include <linux/io.h>
 #include <linux/irq.h>
+#include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
 #include <linux/reset.h>
-#include <crypto/internal/rng.h>
-#include <crypto/internal/skcipher.h>
 
 #include "sun8i-ce.h"
 
@@ -277,7 +281,7 @@ static struct sun8i_ce_alg_template ce_algs[] = {
 	.type = CRYPTO_ALG_TYPE_SKCIPHER,
 	.ce_algo_id = CE_ID_CIPHER_AES,
 	.ce_blockmode = CE_ID_OP_CBC,
-	.alg.skcipher = {
+	.alg.skcipher.base = {
 		.base = {
 			.cra_name = "cbc(aes)",
 			.cra_driver_name = "cbc-aes-sun8i-ce",
@@ -298,13 +302,16 @@ static struct sun8i_ce_alg_template ce_algs[] = {
 		.setkey		= sun8i_ce_aes_setkey,
 		.encrypt	= sun8i_ce_skencrypt,
 		.decrypt	= sun8i_ce_skdecrypt,
-	}
+	},
+	.alg.skcipher.op = {
+		.do_one_request = sun8i_ce_cipher_do_one,
+	},
 },
 {
 	.type = CRYPTO_ALG_TYPE_SKCIPHER,
 	.ce_algo_id = CE_ID_CIPHER_AES,
 	.ce_blockmode = CE_ID_OP_ECB,
-	.alg.skcipher = {
+	.alg.skcipher.base = {
 		.base = {
 			.cra_name = "ecb(aes)",
 			.cra_driver_name = "ecb-aes-sun8i-ce",
@@ -324,13 +331,16 @@ static struct sun8i_ce_alg_template ce_algs[] = {
 		.setkey		= sun8i_ce_aes_setkey,
 		.encrypt	= sun8i_ce_skencrypt,
 		.decrypt	= sun8i_ce_skdecrypt,
-	}
+	},
+	.alg.skcipher.op = {
+		.do_one_request = sun8i_ce_cipher_do_one,
+	},
 },
 {
 	.type = CRYPTO_ALG_TYPE_SKCIPHER,
 	.ce_algo_id = CE_ID_CIPHER_DES3,
 	.ce_blockmode = CE_ID_OP_CBC,
-	.alg.skcipher = {
+	.alg.skcipher.base = {
 		.base = {
 			.cra_name = "cbc(des3_ede)",
 			.cra_driver_name = "cbc-des3-sun8i-ce",
@@ -351,13 +361,16 @@ static struct sun8i_ce_alg_template ce_algs[] = {
 		.setkey		= sun8i_ce_des3_setkey,
 		.encrypt	= sun8i_ce_skencrypt,
 		.decrypt	= sun8i_ce_skdecrypt,
-	}
+	},
+	.alg.skcipher.op = {
+		.do_one_request = sun8i_ce_cipher_do_one,
+	},
 },
 {
 	.type = CRYPTO_ALG_TYPE_SKCIPHER,
 	.ce_algo_id = CE_ID_CIPHER_DES3,
 	.ce_blockmode = CE_ID_OP_ECB,
-	.alg.skcipher = {
+	.alg.skcipher.base = {
 		.base = {
 			.cra_name = "ecb(des3_ede)",
 			.cra_driver_name = "ecb-des3-sun8i-ce",
@@ -377,12 +390,15 @@ static struct sun8i_ce_alg_template ce_algs[] = {
 		.setkey		= sun8i_ce_des3_setkey,
 		.encrypt	= sun8i_ce_skencrypt,
 		.decrypt	= sun8i_ce_skdecrypt,
-	}
+	},
+	.alg.skcipher.op = {
+		.do_one_request = sun8i_ce_cipher_do_one,
+	},
 },
 #ifdef CONFIG_CRYPTO_DEV_SUN8I_CE_HASH
 {	.type = CRYPTO_ALG_TYPE_AHASH,
 	.ce_algo_id = CE_ID_HASH_MD5,
-	.alg.hash = {
+	.alg.hash.base = {
 		.init = sun8i_ce_hash_init,
 		.update = sun8i_ce_hash_update,
 		.final = sun8i_ce_hash_final,
@@ -390,6 +406,8 @@ static struct sun8i_ce_alg_template ce_algs[] = {
 		.digest = sun8i_ce_hash_digest,
 		.export = sun8i_ce_hash_export,
 		.import = sun8i_ce_hash_import,
+		.init_tfm = sun8i_ce_hash_init_tfm,
+		.exit_tfm = sun8i_ce_hash_exit_tfm,
 		.halg = {
 			.digestsize = MD5_DIGEST_SIZE,
 			.statesize = sizeof(struct md5_state),
@@ -404,15 +422,17 @@ static struct sun8i_ce_alg_template ce_algs[] = {
 				.cra_blocksize = MD5_HMAC_BLOCK_SIZE,
 				.cra_ctxsize = sizeof(struct sun8i_ce_hash_tfm_ctx),
 				.cra_module = THIS_MODULE,
-				.cra_init = sun8i_ce_hash_crainit,
-				.cra_exit = sun8i_ce_hash_craexit,
 			}
 		}
-	}
+	},
+	.alg.hash.op = {
+		.do_one_request = sun8i_ce_hash_run,
+	},
+
 },
 {	.type = CRYPTO_ALG_TYPE_AHASH,
 	.ce_algo_id = CE_ID_HASH_SHA1,
-	.alg.hash = {
+	.alg.hash.base = {
 		.init = sun8i_ce_hash_init,
 		.update = sun8i_ce_hash_update,
 		.final = sun8i_ce_hash_final,
@@ -420,6 +440,8 @@ static struct sun8i_ce_alg_template ce_algs[] = {
 		.digest = sun8i_ce_hash_digest,
 		.export = sun8i_ce_hash_export,
 		.import = sun8i_ce_hash_import,
+		.init_tfm = sun8i_ce_hash_init_tfm,
+		.exit_tfm = sun8i_ce_hash_exit_tfm,
 		.halg = {
 			.digestsize = SHA1_DIGEST_SIZE,
 			.statesize = sizeof(struct sha1_state),
@@ -434,15 +456,16 @@ static struct sun8i_ce_alg_template ce_algs[] = {
 				.cra_blocksize = SHA1_BLOCK_SIZE,
 				.cra_ctxsize = sizeof(struct sun8i_ce_hash_tfm_ctx),
 				.cra_module = THIS_MODULE,
-				.cra_init = sun8i_ce_hash_crainit,
-				.cra_exit = sun8i_ce_hash_craexit,
 			}
 		}
-	}
+	},
+	.alg.hash.op = {
+		.do_one_request = sun8i_ce_hash_run,
+	},
 },
 {	.type = CRYPTO_ALG_TYPE_AHASH,
 	.ce_algo_id = CE_ID_HASH_SHA224,
-	.alg.hash = {
+	.alg.hash.base = {
 		.init = sun8i_ce_hash_init,
 		.update = sun8i_ce_hash_update,
 		.final = sun8i_ce_hash_final,
@@ -450,6 +473,8 @@ static struct sun8i_ce_alg_template ce_algs[] = {
 		.digest = sun8i_ce_hash_digest,
 		.export = sun8i_ce_hash_export,
 		.import = sun8i_ce_hash_import,
+		.init_tfm = sun8i_ce_hash_init_tfm,
+		.exit_tfm = sun8i_ce_hash_exit_tfm,
 		.halg = {
 			.digestsize = SHA224_DIGEST_SIZE,
 			.statesize = sizeof(struct sha256_state),
@@ -464,15 +489,16 @@ static struct sun8i_ce_alg_template ce_algs[] = {
 				.cra_blocksize = SHA224_BLOCK_SIZE,
 				.cra_ctxsize = sizeof(struct sun8i_ce_hash_tfm_ctx),
 				.cra_module = THIS_MODULE,
-				.cra_init = sun8i_ce_hash_crainit,
-				.cra_exit = sun8i_ce_hash_craexit,
 			}
 		}
-	}
+	},
+	.alg.hash.op = {
+		.do_one_request = sun8i_ce_hash_run,
+	},
 },
 {	.type = CRYPTO_ALG_TYPE_AHASH,
 	.ce_algo_id = CE_ID_HASH_SHA256,
-	.alg.hash = {
+	.alg.hash.base = {
 		.init = sun8i_ce_hash_init,
 		.update = sun8i_ce_hash_update,
 		.final = sun8i_ce_hash_final,
@@ -480,6 +506,8 @@ static struct sun8i_ce_alg_template ce_algs[] = {
 		.digest = sun8i_ce_hash_digest,
 		.export = sun8i_ce_hash_export,
 		.import = sun8i_ce_hash_import,
+		.init_tfm = sun8i_ce_hash_init_tfm,
+		.exit_tfm = sun8i_ce_hash_exit_tfm,
 		.halg = {
 			.digestsize = SHA256_DIGEST_SIZE,
 			.statesize = sizeof(struct sha256_state),
@@ -494,15 +522,16 @@ static struct sun8i_ce_alg_template ce_algs[] = {
 				.cra_blocksize = SHA256_BLOCK_SIZE,
 				.cra_ctxsize = sizeof(struct sun8i_ce_hash_tfm_ctx),
 				.cra_module = THIS_MODULE,
-				.cra_init = sun8i_ce_hash_crainit,
-				.cra_exit = sun8i_ce_hash_craexit,
 			}
 		}
-	}
+	},
+	.alg.hash.op = {
+		.do_one_request = sun8i_ce_hash_run,
+	},
 },
 {	.type = CRYPTO_ALG_TYPE_AHASH,
 	.ce_algo_id = CE_ID_HASH_SHA384,
-	.alg.hash = {
+	.alg.hash.base = {
 		.init = sun8i_ce_hash_init,
 		.update = sun8i_ce_hash_update,
 		.final = sun8i_ce_hash_final,
@@ -510,6 +539,8 @@ static struct sun8i_ce_alg_template ce_algs[] = {
 		.digest = sun8i_ce_hash_digest,
 		.export = sun8i_ce_hash_export,
 		.import = sun8i_ce_hash_import,
+		.init_tfm = sun8i_ce_hash_init_tfm,
+		.exit_tfm = sun8i_ce_hash_exit_tfm,
 		.halg = {
 			.digestsize = SHA384_DIGEST_SIZE,
 			.statesize = sizeof(struct sha512_state),
@@ -524,15 +555,16 @@ static struct sun8i_ce_alg_template ce_algs[] = {
 				.cra_blocksize = SHA384_BLOCK_SIZE,
 				.cra_ctxsize = sizeof(struct sun8i_ce_hash_tfm_ctx),
 				.cra_module = THIS_MODULE,
-				.cra_init = sun8i_ce_hash_crainit,
-				.cra_exit = sun8i_ce_hash_craexit,
 			}
 		}
-	}
+	},
+	.alg.hash.op = {
+		.do_one_request = sun8i_ce_hash_run,
+	},
 },
 {	.type = CRYPTO_ALG_TYPE_AHASH,
 	.ce_algo_id = CE_ID_HASH_SHA512,
-	.alg.hash = {
+	.alg.hash.base = {
 		.init = sun8i_ce_hash_init,
 		.update = sun8i_ce_hash_update,
 		.final = sun8i_ce_hash_final,
@@ -540,6 +572,8 @@ static struct sun8i_ce_alg_template ce_algs[] = {
 		.digest = sun8i_ce_hash_digest,
 		.export = sun8i_ce_hash_export,
 		.import = sun8i_ce_hash_import,
+		.init_tfm = sun8i_ce_hash_init_tfm,
+		.exit_tfm = sun8i_ce_hash_exit_tfm,
 		.halg = {
 			.digestsize = SHA512_DIGEST_SIZE,
 			.statesize = sizeof(struct sha512_state),
@@ -554,11 +588,12 @@ static struct sun8i_ce_alg_template ce_algs[] = {
 				.cra_blocksize = SHA512_BLOCK_SIZE,
 				.cra_ctxsize = sizeof(struct sun8i_ce_hash_tfm_ctx),
 				.cra_module = THIS_MODULE,
-				.cra_init = sun8i_ce_hash_crainit,
-				.cra_exit = sun8i_ce_hash_craexit,
 			}
 		}
-	}
+	},
+	.alg.hash.op = {
+		.do_one_request = sun8i_ce_hash_run,
+	},
 },
 #endif
 #ifdef CONFIG_CRYPTO_DEV_SUN8I_CE_PRNG
@@ -582,14 +617,18 @@ static struct sun8i_ce_alg_template ce_algs[] = {
 #endif
 };
 
-#ifdef CONFIG_CRYPTO_DEV_SUN8I_CE_DEBUG
 static int sun8i_ce_debugfs_show(struct seq_file *seq, void *v)
 {
-	struct sun8i_ce_dev *ce = seq->private;
+	struct sun8i_ce_dev *ce __maybe_unused = seq->private;
 	unsigned int i;
 
 	for (i = 0; i < MAXFLOW; i++)
-		seq_printf(seq, "Channel %d: nreq %lu\n", i, ce->chanlist[i].stat_req);
+		seq_printf(seq, "Channel %d: nreq %lu\n", i,
+#ifdef CONFIG_CRYPTO_DEV_SUN8I_CE_DEBUG
+			   ce->chanlist[i].stat_req);
+#else
+			   0ul);
+#endif
 
 	for (i = 0; i < ARRAY_SIZE(ce_algs); i++) {
 		if (!ce_algs[i].ce)
@@ -597,8 +636,8 @@ static int sun8i_ce_debugfs_show(struct seq_file *seq, void *v)
 		switch (ce_algs[i].type) {
 		case CRYPTO_ALG_TYPE_SKCIPHER:
 			seq_printf(seq, "%s %s reqs=%lu fallback=%lu\n",
-				   ce_algs[i].alg.skcipher.base.cra_driver_name,
-				   ce_algs[i].alg.skcipher.base.cra_name,
+				   ce_algs[i].alg.skcipher.base.base.cra_driver_name,
+				   ce_algs[i].alg.skcipher.base.base.cra_name,
 				   ce_algs[i].stat_req, ce_algs[i].stat_fb);
 			seq_printf(seq, "\tLast fallback is: %s\n",
 				   ce_algs[i].fbname);
@@ -621,8 +660,8 @@ static int sun8i_ce_debugfs_show(struct seq_file *seq, void *v)
 			break;
 		case CRYPTO_ALG_TYPE_AHASH:
 			seq_printf(seq, "%s %s reqs=%lu fallback=%lu\n",
-				   ce_algs[i].alg.hash.halg.base.cra_driver_name,
-				   ce_algs[i].alg.hash.halg.base.cra_name,
+				   ce_algs[i].alg.hash.base.halg.base.cra_driver_name,
+				   ce_algs[i].alg.hash.base.halg.base.cra_name,
 				   ce_algs[i].stat_req, ce_algs[i].stat_fb);
 			seq_printf(seq, "\tLast fallback is: %s\n",
 				   ce_algs[i].fbname);
@@ -643,7 +682,8 @@ static int sun8i_ce_debugfs_show(struct seq_file *seq, void *v)
 			break;
 		}
 	}
-#ifdef CONFIG_CRYPTO_DEV_SUN8I_CE_TRNG
+#if defined(CONFIG_CRYPTO_DEV_SUN8I_CE_TRNG) && \
+    defined(CONFIG_CRYPTO_DEV_SUN8I_CE_DEBUG)
 	seq_printf(seq, "HWRNG %lu %lu\n",
 		   ce->hwrng_stat_req, ce->hwrng_stat_bytes);
 #endif
@@ -651,7 +691,6 @@ static int sun8i_ce_debugfs_show(struct seq_file *seq, void *v)
 }
 
 DEFINE_SHOW_ATTRIBUTE(sun8i_ce_debugfs);
-#endif
 
 static void sun8i_ce_free_chanlist(struct sun8i_ce_dev *ce, int i)
 {
@@ -839,7 +878,7 @@ static int sun8i_ce_register_algs(struct sun8i_ce_dev *ce)
 			if (ce_method == CE_ID_NOTSUPP) {
 				dev_dbg(ce->dev,
 					"DEBUG: Algo of %s not supported\n",
-					ce_algs[i].alg.skcipher.base.cra_name);
+					ce_algs[i].alg.skcipher.base.base.cra_name);
 				ce_algs[i].ce = NULL;
 				break;
 			}
@@ -847,16 +886,16 @@ static int sun8i_ce_register_algs(struct sun8i_ce_dev *ce)
 			ce_method = ce->variant->op_mode[id];
 			if (ce_method == CE_ID_NOTSUPP) {
 				dev_dbg(ce->dev, "DEBUG: Blockmode of %s not supported\n",
-					ce_algs[i].alg.skcipher.base.cra_name);
+					ce_algs[i].alg.skcipher.base.base.cra_name);
 				ce_algs[i].ce = NULL;
 				break;
 			}
 			dev_info(ce->dev, "Register %s\n",
-				 ce_algs[i].alg.skcipher.base.cra_name);
-			err = crypto_register_skcipher(&ce_algs[i].alg.skcipher);
+				 ce_algs[i].alg.skcipher.base.base.cra_name);
+			err = crypto_engine_register_skcipher(&ce_algs[i].alg.skcipher);
 			if (err) {
 				dev_err(ce->dev, "ERROR: Fail to register %s\n",
-					ce_algs[i].alg.skcipher.base.cra_name);
+					ce_algs[i].alg.skcipher.base.base.cra_name);
 				ce_algs[i].ce = NULL;
 				return err;
 			}
@@ -867,16 +906,16 @@ static int sun8i_ce_register_algs(struct sun8i_ce_dev *ce)
 			if (ce_method == CE_ID_NOTSUPP) {
 				dev_info(ce->dev,
 					 "DEBUG: Algo of %s not supported\n",
-					 ce_algs[i].alg.hash.halg.base.cra_name);
+					 ce_algs[i].alg.hash.base.halg.base.cra_name);
 				ce_algs[i].ce = NULL;
 				break;
 			}
 			dev_info(ce->dev, "Register %s\n",
-				 ce_algs[i].alg.hash.halg.base.cra_name);
-			err = crypto_register_ahash(&ce_algs[i].alg.hash);
+				 ce_algs[i].alg.hash.base.halg.base.cra_name);
+			err = crypto_engine_register_ahash(&ce_algs[i].alg.hash);
 			if (err) {
 				dev_err(ce->dev, "ERROR: Fail to register %s\n",
-					ce_algs[i].alg.hash.halg.base.cra_name);
+					ce_algs[i].alg.hash.base.halg.base.cra_name);
 				ce_algs[i].ce = NULL;
 				return err;
 			}
@@ -916,13 +955,13 @@ static void sun8i_ce_unregister_algs(struct sun8i_ce_dev *ce)
 		switch (ce_algs[i].type) {
 		case CRYPTO_ALG_TYPE_SKCIPHER:
 			dev_info(ce->dev, "Unregister %d %s\n", i,
-				 ce_algs[i].alg.skcipher.base.cra_name);
-			crypto_unregister_skcipher(&ce_algs[i].alg.skcipher);
+				 ce_algs[i].alg.skcipher.base.base.cra_name);
+			crypto_engine_unregister_skcipher(&ce_algs[i].alg.skcipher);
 			break;
 		case CRYPTO_ALG_TYPE_AHASH:
 			dev_info(ce->dev, "Unregister %d %s\n", i,
-				 ce_algs[i].alg.hash.halg.base.cra_name);
-			crypto_unregister_ahash(&ce_algs[i].alg.hash);
+				 ce_algs[i].alg.hash.base.halg.base.cra_name);
+			crypto_engine_unregister_ahash(&ce_algs[i].alg.hash);
 			break;
 		case CRYPTO_ALG_TYPE_RNG:
 			dev_info(ce->dev, "Unregister %d %s\n", i,
@@ -1007,13 +1046,21 @@ static int sun8i_ce_probe(struct platform_device *pdev)
 
 	pm_runtime_put_sync(ce->dev);
 
+	if (IS_ENABLED(CONFIG_CRYPTO_DEV_SUN8I_CE_DEBUG)) {
+		struct dentry *dbgfs_dir __maybe_unused;
+		struct dentry *dbgfs_stats __maybe_unused;
+
+		/* Ignore error of debugfs */
+		dbgfs_dir = debugfs_create_dir("sun8i-ce", NULL);
+		dbgfs_stats = debugfs_create_file("stats", 0444,
+						  dbgfs_dir, ce,
+						  &sun8i_ce_debugfs_fops);
+
 #ifdef CONFIG_CRYPTO_DEV_SUN8I_CE_DEBUG
-	/* Ignore error of debugfs */
-	ce->dbgfs_dir = debugfs_create_dir("sun8i-ce", NULL);
-	ce->dbgfs_stats = debugfs_create_file("stats", 0444,
-					      ce->dbgfs_dir, ce,
-					      &sun8i_ce_debugfs_fops);
+		ce->dbgfs_dir = dbgfs_dir;
+		ce->dbgfs_stats = dbgfs_stats;
 #endif
+	}
 
 	return 0;
 error_alg:
diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c
index 04d7d890de58..5abd4d756450 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c
@@ -9,46 +9,46 @@
  *
  * You could find the datasheet in Documentation/arch/arm/sunxi.rst
  */
+
+#include <crypto/internal/hash.h>
+#include <crypto/md5.h>
+#include <crypto/sha1.h>
+#include <crypto/sha2.h>
 #include <linux/bottom_half.h>
 #include <linux/dma-mapping.h>
+#include <linux/kernel.h>
 #include <linux/pm_runtime.h>
 #include <linux/scatterlist.h>
-#include <crypto/internal/hash.h>
-#include <crypto/sha1.h>
-#include <crypto/sha2.h>
-#include <crypto/md5.h>
+#include <linux/slab.h>
+#include <linux/string.h>
 #include "sun8i-ce.h"
 
-int sun8i_ce_hash_crainit(struct crypto_tfm *tfm)
+int sun8i_ce_hash_init_tfm(struct crypto_ahash *tfm)
 {
-	struct sun8i_ce_hash_tfm_ctx *op = crypto_tfm_ctx(tfm);
-	struct ahash_alg *alg = __crypto_ahash_alg(tfm->__crt_alg);
+	struct sun8i_ce_hash_tfm_ctx *op = crypto_ahash_ctx(tfm);
+	struct ahash_alg *alg = crypto_ahash_alg(tfm);
 	struct sun8i_ce_alg_template *algt;
 	int err;
 
-	memset(op, 0, sizeof(struct sun8i_ce_hash_tfm_ctx));
-
-	algt = container_of(alg, struct sun8i_ce_alg_template, alg.hash);
+	algt = container_of(alg, struct sun8i_ce_alg_template, alg.hash.base);
 	op->ce = algt->ce;
 
-	op->enginectx.op.do_one_request = sun8i_ce_hash_run;
-
 	/* FALLBACK */
-	op->fallback_tfm = crypto_alloc_ahash(crypto_tfm_alg_name(tfm), 0,
+	op->fallback_tfm = crypto_alloc_ahash(crypto_ahash_alg_name(tfm), 0,
 					      CRYPTO_ALG_NEED_FALLBACK);
 	if (IS_ERR(op->fallback_tfm)) {
 		dev_err(algt->ce->dev, "Fallback driver could no be loaded\n");
 		return PTR_ERR(op->fallback_tfm);
 	}
 
-	if (algt->alg.hash.halg.statesize < crypto_ahash_statesize(op->fallback_tfm))
-		algt->alg.hash.halg.statesize = crypto_ahash_statesize(op->fallback_tfm);
+	crypto_ahash_set_statesize(tfm,
+				   crypto_ahash_statesize(op->fallback_tfm));
 
-	crypto_ahash_set_reqsize(__crypto_ahash_cast(tfm),
+	crypto_ahash_set_reqsize(tfm,
 				 sizeof(struct sun8i_ce_hash_reqctx) +
 				 crypto_ahash_reqsize(op->fallback_tfm));
 
-	memcpy(algt->fbname, crypto_tfm_alg_driver_name(&op->fallback_tfm->base),
+	memcpy(algt->fbname, crypto_ahash_driver_name(op->fallback_tfm),
 	       CRYPTO_MAX_ALG_NAME);
 
 	err = pm_runtime_get_sync(op->ce->dev);
@@ -61,9 +61,9 @@ int sun8i_ce_hash_crainit(struct crypto_tfm *tfm)
 	return err;
 }
 
-void sun8i_ce_hash_craexit(struct crypto_tfm *tfm)
+void sun8i_ce_hash_exit_tfm(struct crypto_ahash *tfm)
 {
-	struct sun8i_ce_hash_tfm_ctx *tfmctx = crypto_tfm_ctx(tfm);
+	struct sun8i_ce_hash_tfm_ctx *tfmctx = crypto_ahash_ctx(tfm);
 
 	crypto_free_ahash(tfmctx->fallback_tfm);
 	pm_runtime_put_sync_suspend(tfmctx->ce->dev);
@@ -202,7 +202,7 @@ static bool sun8i_ce_hash_need_fallback(struct ahash_request *areq)
 	struct sun8i_ce_alg_template *algt;
 	struct scatterlist *sg;
 
-	algt = container_of(alg, struct sun8i_ce_alg_template, alg.hash);
+	algt = container_of(alg, struct sun8i_ce_alg_template, alg.hash.base);
 
 	if (areq->nbytes == 0) {
 		algt->stat_fb_len0++;
@@ -251,7 +251,7 @@ int sun8i_ce_hash_digest(struct ahash_request *areq)
 			return sun8i_ce_hash_digest_fb(areq);
 	}
 
-	algt = container_of(alg, struct sun8i_ce_alg_template, alg.hash);
+	algt = container_of(alg, struct sun8i_ce_alg_template, alg.hash.base);
 	ce = algt->ce;
 
 	e = sun8i_ce_get_engine_number(ce);
@@ -343,11 +343,11 @@ int sun8i_ce_hash_run(struct crypto_engine *engine, void *breq)
 	dma_addr_t addr_res, addr_pad;
 	int ns = sg_nents_for_len(areq->src, areq->nbytes);
 
-	algt = container_of(alg, struct sun8i_ce_alg_template, alg.hash);
+	algt = container_of(alg, struct sun8i_ce_alg_template, alg.hash.base);
 	ce = algt->ce;
 
-	bs = algt->alg.hash.halg.base.cra_blocksize;
-	digestsize = algt->alg.hash.halg.digestsize;
+	bs = algt->alg.hash.base.halg.base.cra_blocksize;
+	digestsize = algt->alg.hash.base.halg.digestsize;
 	if (digestsize == SHA224_DIGEST_SIZE)
 		digestsize = SHA256_DIGEST_SIZE;
 	if (digestsize == SHA384_DIGEST_SIZE)
@@ -452,14 +452,14 @@ int sun8i_ce_hash_run(struct crypto_engine *engine, void *breq)
 
 	chan->timeout = areq->nbytes;
 
-	err = sun8i_ce_run_task(ce, flow, crypto_tfm_alg_name(areq->base.tfm));
+	err = sun8i_ce_run_task(ce, flow, crypto_ahash_alg_name(tfm));
 
 	dma_unmap_single(ce->dev, addr_pad, j * 4, DMA_TO_DEVICE);
 	dma_unmap_sg(ce->dev, areq->src, ns, DMA_TO_DEVICE);
 	dma_unmap_single(ce->dev, addr_res, digestsize, DMA_FROM_DEVICE);
 
 
-	memcpy(areq->result, result, algt->alg.hash.halg.digestsize);
+	memcpy(areq->result, result, algt->alg.hash.base.halg.digestsize);
 theend:
 	kfree(buf);
 	kfree(result);
diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h
index 27029fb77e29..9e0847fffd05 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h
@@ -265,14 +265,12 @@ struct sun8i_cipher_req_ctx {
 
 /*
  * struct sun8i_cipher_tfm_ctx - context for a skcipher TFM
- * @enginectx:		crypto_engine used by this TFM
  * @key:		pointer to key data
  * @keylen:		len of the key
  * @ce:			pointer to the private data of driver handling this TFM
  * @fallback_tfm:	pointer to the fallback TFM
  */
 struct sun8i_cipher_tfm_ctx {
-	struct crypto_engine_ctx enginectx;
 	u32 *key;
 	u32 keylen;
 	struct sun8i_ce_dev *ce;
@@ -281,12 +279,10 @@ struct sun8i_cipher_tfm_ctx {
 
 /*
  * struct sun8i_ce_hash_tfm_ctx - context for an ahash TFM
- * @enginectx:		crypto_engine used by this TFM
  * @ce:			pointer to the private data of driver handling this TFM
  * @fallback_tfm:	pointer to the fallback TFM
  */
 struct sun8i_ce_hash_tfm_ctx {
-	struct crypto_engine_ctx enginectx;
 	struct sun8i_ce_dev *ce;
 	struct crypto_ahash *fallback_tfm;
 };
@@ -329,8 +325,8 @@ struct sun8i_ce_alg_template {
 	u32 ce_blockmode;
 	struct sun8i_ce_dev *ce;
 	union {
-		struct skcipher_alg skcipher;
-		struct ahash_alg hash;
+		struct skcipher_engine_alg skcipher;
+		struct ahash_engine_alg hash;
 		struct rng_alg rng;
 	} alg;
 	unsigned long stat_req;
@@ -355,6 +351,7 @@ int sun8i_ce_des3_setkey(struct crypto_skcipher *tfm, const u8 *key,
 			 unsigned int keylen);
 int sun8i_ce_cipher_init(struct crypto_tfm *tfm);
 void sun8i_ce_cipher_exit(struct crypto_tfm *tfm);
+int sun8i_ce_cipher_do_one(struct crypto_engine *engine, void *areq);
 int sun8i_ce_skdecrypt(struct skcipher_request *areq);
 int sun8i_ce_skencrypt(struct skcipher_request *areq);
 
@@ -362,8 +359,8 @@ int sun8i_ce_get_engine_number(struct sun8i_ce_dev *ce);
 
 int sun8i_ce_run_task(struct sun8i_ce_dev *ce, int flow, const char *name);
 
-int sun8i_ce_hash_crainit(struct crypto_tfm *tfm);
-void sun8i_ce_hash_craexit(struct crypto_tfm *tfm);
+int sun8i_ce_hash_init_tfm(struct crypto_ahash *tfm);
+void sun8i_ce_hash_exit_tfm(struct crypto_ahash *tfm);
 int sun8i_ce_hash_init(struct ahash_request *areq);
 int sun8i_ce_hash_export(struct ahash_request *areq, void *out);
 int sun8i_ce_hash_import(struct ahash_request *areq, const void *in);
