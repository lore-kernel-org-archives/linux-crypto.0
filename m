Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94A98C41513
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Aug 2023 09:30:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231631AbjHKJax (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Aug 2023 05:30:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231643AbjHKJad (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Aug 2023 05:30:33 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 149F930C1
        for <linux-crypto@vger.kernel.org>; Fri, 11 Aug 2023 02:30:31 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qUOTS-0020gO-47; Fri, 11 Aug 2023 17:30:27 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 11 Aug 2023 17:30:26 +0800
From:   "Herbert Xu" <herbert@gondor.apana.org.au>
Date:   Fri, 11 Aug 2023 17:30:26 +0800
Subject: [PATCH 23/36] crypto: sun8i-ss - Use new crypto_engine_op interface
References: <ZNX/BwEkV3SDpsAS@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Gaurav Jain <gaurav.jain@nxp.com>
Message-Id: <E1qUOTS-0020gO-47@formenos.hmeau.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Use the new crypto_engine_op interface where the callback is stored
in the algorithm object.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c |   12 -
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c   |  154 ++++++++++++--------
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c   |   77 ++++------
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h        |   17 --
 4 files changed, 145 insertions(+), 115 deletions(-)

diff --git a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c
index 2758dadf74eb..82d5cc20d877 100644
--- a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c
+++ b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c
@@ -24,7 +24,7 @@ static bool sun8i_ss_need_fallback(struct skcipher_request *areq)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(areq);
 	struct skcipher_alg *alg = crypto_skcipher_alg(tfm);
-	struct sun8i_ss_alg_template *algt = container_of(alg, struct sun8i_ss_alg_template, alg.skcipher);
+	struct sun8i_ss_alg_template *algt = container_of(alg, struct sun8i_ss_alg_template, alg.skcipher.base);
 	struct scatterlist *in_sg = areq->src;
 	struct scatterlist *out_sg = areq->dst;
 	struct scatterlist *sg;
@@ -97,7 +97,7 @@ static int sun8i_ss_cipher_fallback(struct skcipher_request *areq)
 	struct skcipher_alg *alg = crypto_skcipher_alg(tfm);
 	struct sun8i_ss_alg_template *algt;
 
-	algt = container_of(alg, struct sun8i_ss_alg_template, alg.skcipher);
+	algt = container_of(alg, struct sun8i_ss_alg_template, alg.skcipher.base);
 	algt->stat_fb++;
 #endif
 	skcipher_request_set_tfm(&rctx->fallback_req, op->fallback_tfm);
@@ -193,7 +193,7 @@ static int sun8i_ss_cipher(struct skcipher_request *areq)
 	int nsgd = sg_nents_for_len(areq->dst, areq->cryptlen);
 	int i;
 
-	algt = container_of(alg, struct sun8i_ss_alg_template, alg.skcipher);
+	algt = container_of(alg, struct sun8i_ss_alg_template, alg.skcipher.base);
 
 	dev_dbg(ss->dev, "%s %s %u %x IV(%p %u) key=%u\n", __func__,
 		crypto_tfm_alg_name(areq->base.tfm),
@@ -324,7 +324,7 @@ static int sun8i_ss_cipher(struct skcipher_request *areq)
 	return err;
 }
 
-static int sun8i_ss_handle_cipher_request(struct crypto_engine *engine, void *areq)
+int sun8i_ss_handle_cipher_request(struct crypto_engine *engine, void *areq)
 {
 	int err;
 	struct skcipher_request *breq = container_of(areq, struct skcipher_request, base);
@@ -390,7 +390,7 @@ int sun8i_ss_cipher_init(struct crypto_tfm *tfm)
 
 	memset(op, 0, sizeof(struct sun8i_cipher_tfm_ctx));
 
-	algt = container_of(alg, struct sun8i_ss_alg_template, alg.skcipher);
+	algt = container_of(alg, struct sun8i_ss_alg_template, alg.skcipher.base);
 	op->ss = algt->ss;
 
 	op->fallback_tfm = crypto_alloc_skcipher(name, 0, CRYPTO_ALG_NEED_FALLBACK);
@@ -408,8 +408,6 @@ int sun8i_ss_cipher_init(struct crypto_tfm *tfm)
 	       crypto_tfm_alg_driver_name(crypto_skcipher_tfm(op->fallback_tfm)),
 	       CRYPTO_MAX_ALG_NAME);
 
-	op->enginectx.op.do_one_request = sun8i_ss_handle_cipher_request;
-
 	err = pm_runtime_resume_and_get(op->ss->dev);
 	if (err < 0) {
 		dev_err(op->ss->dev, "pm error %d\n", err);
diff --git a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c
index 3dd844b40ff7..62c001c9efc2 100644
--- a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c
+++ b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c
@@ -9,10 +9,14 @@
  *
  * You could find a link for the datasheet in Documentation/arch/arm/sunxi.rst
  */
+
+#include <crypto/engine.h>
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
@@ -23,8 +27,6 @@
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
 #include <linux/reset.h>
-#include <crypto/internal/rng.h>
-#include <crypto/internal/skcipher.h>
 
 #include "sun8i-ss.h"
 
@@ -168,7 +170,7 @@ static struct sun8i_ss_alg_template ss_algs[] = {
 	.type = CRYPTO_ALG_TYPE_SKCIPHER,
 	.ss_algo_id = SS_ID_CIPHER_AES,
 	.ss_blockmode = SS_ID_OP_CBC,
-	.alg.skcipher = {
+	.alg.skcipher.base = {
 		.base = {
 			.cra_name = "cbc(aes)",
 			.cra_driver_name = "cbc-aes-sun8i-ss",
@@ -189,13 +191,16 @@ static struct sun8i_ss_alg_template ss_algs[] = {
 		.setkey		= sun8i_ss_aes_setkey,
 		.encrypt	= sun8i_ss_skencrypt,
 		.decrypt	= sun8i_ss_skdecrypt,
-	}
+	},
+	.alg.skcipher.op = {
+		.do_one_request = sun8i_ss_handle_cipher_request,
+	},
 },
 {
 	.type = CRYPTO_ALG_TYPE_SKCIPHER,
 	.ss_algo_id = SS_ID_CIPHER_AES,
 	.ss_blockmode = SS_ID_OP_ECB,
-	.alg.skcipher = {
+	.alg.skcipher.base = {
 		.base = {
 			.cra_name = "ecb(aes)",
 			.cra_driver_name = "ecb-aes-sun8i-ss",
@@ -215,13 +220,16 @@ static struct sun8i_ss_alg_template ss_algs[] = {
 		.setkey		= sun8i_ss_aes_setkey,
 		.encrypt	= sun8i_ss_skencrypt,
 		.decrypt	= sun8i_ss_skdecrypt,
-	}
+	},
+	.alg.skcipher.op = {
+		.do_one_request = sun8i_ss_handle_cipher_request,
+	},
 },
 {
 	.type = CRYPTO_ALG_TYPE_SKCIPHER,
 	.ss_algo_id = SS_ID_CIPHER_DES3,
 	.ss_blockmode = SS_ID_OP_CBC,
-	.alg.skcipher = {
+	.alg.skcipher.base = {
 		.base = {
 			.cra_name = "cbc(des3_ede)",
 			.cra_driver_name = "cbc-des3-sun8i-ss",
@@ -242,13 +250,16 @@ static struct sun8i_ss_alg_template ss_algs[] = {
 		.setkey		= sun8i_ss_des3_setkey,
 		.encrypt	= sun8i_ss_skencrypt,
 		.decrypt	= sun8i_ss_skdecrypt,
-	}
+	},
+	.alg.skcipher.op = {
+		.do_one_request = sun8i_ss_handle_cipher_request,
+	},
 },
 {
 	.type = CRYPTO_ALG_TYPE_SKCIPHER,
 	.ss_algo_id = SS_ID_CIPHER_DES3,
 	.ss_blockmode = SS_ID_OP_ECB,
-	.alg.skcipher = {
+	.alg.skcipher.base = {
 		.base = {
 			.cra_name = "ecb(des3_ede)",
 			.cra_driver_name = "ecb-des3-sun8i-ss",
@@ -268,7 +279,10 @@ static struct sun8i_ss_alg_template ss_algs[] = {
 		.setkey		= sun8i_ss_des3_setkey,
 		.encrypt	= sun8i_ss_skencrypt,
 		.decrypt	= sun8i_ss_skdecrypt,
-	}
+	},
+	.alg.skcipher.op = {
+		.do_one_request = sun8i_ss_handle_cipher_request,
+	},
 },
 #ifdef CONFIG_CRYPTO_DEV_SUN8I_SS_PRNG
 {
@@ -292,7 +306,7 @@ static struct sun8i_ss_alg_template ss_algs[] = {
 #ifdef CONFIG_CRYPTO_DEV_SUN8I_SS_HASH
 {	.type = CRYPTO_ALG_TYPE_AHASH,
 	.ss_algo_id = SS_ID_HASH_MD5,
-	.alg.hash = {
+	.alg.hash.base = {
 		.init = sun8i_ss_hash_init,
 		.update = sun8i_ss_hash_update,
 		.final = sun8i_ss_hash_final,
@@ -300,6 +314,8 @@ static struct sun8i_ss_alg_template ss_algs[] = {
 		.digest = sun8i_ss_hash_digest,
 		.export = sun8i_ss_hash_export,
 		.import = sun8i_ss_hash_import,
+		.init_tfm = sun8i_ss_hash_init_tfm,
+		.exit_tfm = sun8i_ss_hash_exit_tfm,
 		.halg = {
 			.digestsize = MD5_DIGEST_SIZE,
 			.statesize = sizeof(struct md5_state),
@@ -314,15 +330,16 @@ static struct sun8i_ss_alg_template ss_algs[] = {
 				.cra_blocksize = MD5_HMAC_BLOCK_SIZE,
 				.cra_ctxsize = sizeof(struct sun8i_ss_hash_tfm_ctx),
 				.cra_module = THIS_MODULE,
-				.cra_init = sun8i_ss_hash_crainit,
-				.cra_exit = sun8i_ss_hash_craexit,
 			}
 		}
-	}
+	},
+	.alg.hash.op = {
+		.do_one_request = sun8i_ss_hash_run,
+	},
 },
 {	.type = CRYPTO_ALG_TYPE_AHASH,
 	.ss_algo_id = SS_ID_HASH_SHA1,
-	.alg.hash = {
+	.alg.hash.base = {
 		.init = sun8i_ss_hash_init,
 		.update = sun8i_ss_hash_update,
 		.final = sun8i_ss_hash_final,
@@ -330,6 +347,8 @@ static struct sun8i_ss_alg_template ss_algs[] = {
 		.digest = sun8i_ss_hash_digest,
 		.export = sun8i_ss_hash_export,
 		.import = sun8i_ss_hash_import,
+		.init_tfm = sun8i_ss_hash_init_tfm,
+		.exit_tfm = sun8i_ss_hash_exit_tfm,
 		.halg = {
 			.digestsize = SHA1_DIGEST_SIZE,
 			.statesize = sizeof(struct sha1_state),
@@ -344,15 +363,16 @@ static struct sun8i_ss_alg_template ss_algs[] = {
 				.cra_blocksize = SHA1_BLOCK_SIZE,
 				.cra_ctxsize = sizeof(struct sun8i_ss_hash_tfm_ctx),
 				.cra_module = THIS_MODULE,
-				.cra_init = sun8i_ss_hash_crainit,
-				.cra_exit = sun8i_ss_hash_craexit,
 			}
 		}
-	}
+	},
+	.alg.hash.op = {
+		.do_one_request = sun8i_ss_hash_run,
+	},
 },
 {	.type = CRYPTO_ALG_TYPE_AHASH,
 	.ss_algo_id = SS_ID_HASH_SHA224,
-	.alg.hash = {
+	.alg.hash.base = {
 		.init = sun8i_ss_hash_init,
 		.update = sun8i_ss_hash_update,
 		.final = sun8i_ss_hash_final,
@@ -360,6 +380,8 @@ static struct sun8i_ss_alg_template ss_algs[] = {
 		.digest = sun8i_ss_hash_digest,
 		.export = sun8i_ss_hash_export,
 		.import = sun8i_ss_hash_import,
+		.init_tfm = sun8i_ss_hash_init_tfm,
+		.exit_tfm = sun8i_ss_hash_exit_tfm,
 		.halg = {
 			.digestsize = SHA224_DIGEST_SIZE,
 			.statesize = sizeof(struct sha256_state),
@@ -374,15 +396,16 @@ static struct sun8i_ss_alg_template ss_algs[] = {
 				.cra_blocksize = SHA224_BLOCK_SIZE,
 				.cra_ctxsize = sizeof(struct sun8i_ss_hash_tfm_ctx),
 				.cra_module = THIS_MODULE,
-				.cra_init = sun8i_ss_hash_crainit,
-				.cra_exit = sun8i_ss_hash_craexit,
 			}
 		}
-	}
+	},
+	.alg.hash.op = {
+		.do_one_request = sun8i_ss_hash_run,
+	},
 },
 {	.type = CRYPTO_ALG_TYPE_AHASH,
 	.ss_algo_id = SS_ID_HASH_SHA256,
-	.alg.hash = {
+	.alg.hash.base = {
 		.init = sun8i_ss_hash_init,
 		.update = sun8i_ss_hash_update,
 		.final = sun8i_ss_hash_final,
@@ -390,6 +413,8 @@ static struct sun8i_ss_alg_template ss_algs[] = {
 		.digest = sun8i_ss_hash_digest,
 		.export = sun8i_ss_hash_export,
 		.import = sun8i_ss_hash_import,
+		.init_tfm = sun8i_ss_hash_init_tfm,
+		.exit_tfm = sun8i_ss_hash_exit_tfm,
 		.halg = {
 			.digestsize = SHA256_DIGEST_SIZE,
 			.statesize = sizeof(struct sha256_state),
@@ -404,15 +429,16 @@ static struct sun8i_ss_alg_template ss_algs[] = {
 				.cra_blocksize = SHA256_BLOCK_SIZE,
 				.cra_ctxsize = sizeof(struct sun8i_ss_hash_tfm_ctx),
 				.cra_module = THIS_MODULE,
-				.cra_init = sun8i_ss_hash_crainit,
-				.cra_exit = sun8i_ss_hash_craexit,
 			}
 		}
-	}
+	},
+	.alg.hash.op = {
+		.do_one_request = sun8i_ss_hash_run,
+	},
 },
 {	.type = CRYPTO_ALG_TYPE_AHASH,
 	.ss_algo_id = SS_ID_HASH_SHA1,
-	.alg.hash = {
+	.alg.hash.base = {
 		.init = sun8i_ss_hash_init,
 		.update = sun8i_ss_hash_update,
 		.final = sun8i_ss_hash_final,
@@ -420,6 +446,8 @@ static struct sun8i_ss_alg_template ss_algs[] = {
 		.digest = sun8i_ss_hash_digest,
 		.export = sun8i_ss_hash_export,
 		.import = sun8i_ss_hash_import,
+		.init_tfm = sun8i_ss_hash_init_tfm,
+		.exit_tfm = sun8i_ss_hash_exit_tfm,
 		.setkey = sun8i_ss_hmac_setkey,
 		.halg = {
 			.digestsize = SHA1_DIGEST_SIZE,
@@ -435,23 +463,28 @@ static struct sun8i_ss_alg_template ss_algs[] = {
 				.cra_blocksize = SHA1_BLOCK_SIZE,
 				.cra_ctxsize = sizeof(struct sun8i_ss_hash_tfm_ctx),
 				.cra_module = THIS_MODULE,
-				.cra_init = sun8i_ss_hash_crainit,
-				.cra_exit = sun8i_ss_hash_craexit,
 			}
 		}
-	}
+	},
+	.alg.hash.op = {
+		.do_one_request = sun8i_ss_hash_run,
+	},
 },
 #endif
 };
 
-#ifdef CONFIG_CRYPTO_DEV_SUN8I_SS_DEBUG
 static int sun8i_ss_debugfs_show(struct seq_file *seq, void *v)
 {
-	struct sun8i_ss_dev *ss = seq->private;
+	struct sun8i_ss_dev *ss __maybe_unused = seq->private;
 	unsigned int i;
 
 	for (i = 0; i < MAXFLOW; i++)
-		seq_printf(seq, "Channel %d: nreq %lu\n", i, ss->flows[i].stat_req);
+		seq_printf(seq, "Channel %d: nreq %lu\n", i,
+#ifdef CONFIG_CRYPTO_DEV_SUN8I_SS_DEBUG
+			   ss->flows[i].stat_req);
+#else
+			   0ul);
+#endif
 
 	for (i = 0; i < ARRAY_SIZE(ss_algs); i++) {
 		if (!ss_algs[i].ss)
@@ -459,8 +492,8 @@ static int sun8i_ss_debugfs_show(struct seq_file *seq, void *v)
 		switch (ss_algs[i].type) {
 		case CRYPTO_ALG_TYPE_SKCIPHER:
 			seq_printf(seq, "%s %s reqs=%lu fallback=%lu\n",
-				   ss_algs[i].alg.skcipher.base.cra_driver_name,
-				   ss_algs[i].alg.skcipher.base.cra_name,
+				   ss_algs[i].alg.skcipher.base.base.cra_driver_name,
+				   ss_algs[i].alg.skcipher.base.base.cra_name,
 				   ss_algs[i].stat_req, ss_algs[i].stat_fb);
 
 			seq_printf(seq, "\tLast fallback is: %s\n",
@@ -482,8 +515,8 @@ static int sun8i_ss_debugfs_show(struct seq_file *seq, void *v)
 			break;
 		case CRYPTO_ALG_TYPE_AHASH:
 			seq_printf(seq, "%s %s reqs=%lu fallback=%lu\n",
-				   ss_algs[i].alg.hash.halg.base.cra_driver_name,
-				   ss_algs[i].alg.hash.halg.base.cra_name,
+				   ss_algs[i].alg.hash.base.halg.base.cra_driver_name,
+				   ss_algs[i].alg.hash.base.halg.base.cra_name,
 				   ss_algs[i].stat_req, ss_algs[i].stat_fb);
 			seq_printf(seq, "\tLast fallback is: %s\n",
 				   ss_algs[i].fbname);
@@ -502,7 +535,6 @@ static int sun8i_ss_debugfs_show(struct seq_file *seq, void *v)
 }
 
 DEFINE_SHOW_ATTRIBUTE(sun8i_ss_debugfs);
-#endif
 
 static void sun8i_ss_free_flows(struct sun8i_ss_dev *ss, int i)
 {
@@ -659,7 +691,7 @@ static int sun8i_ss_register_algs(struct sun8i_ss_dev *ss)
 			if (ss_method == SS_ID_NOTSUPP) {
 				dev_info(ss->dev,
 					 "DEBUG: Algo of %s not supported\n",
-					 ss_algs[i].alg.skcipher.base.cra_name);
+					 ss_algs[i].alg.skcipher.base.base.cra_name);
 				ss_algs[i].ss = NULL;
 				break;
 			}
@@ -667,16 +699,16 @@ static int sun8i_ss_register_algs(struct sun8i_ss_dev *ss)
 			ss_method = ss->variant->op_mode[id];
 			if (ss_method == SS_ID_NOTSUPP) {
 				dev_info(ss->dev, "DEBUG: Blockmode of %s not supported\n",
-					 ss_algs[i].alg.skcipher.base.cra_name);
+					 ss_algs[i].alg.skcipher.base.base.cra_name);
 				ss_algs[i].ss = NULL;
 				break;
 			}
 			dev_info(ss->dev, "DEBUG: Register %s\n",
-				 ss_algs[i].alg.skcipher.base.cra_name);
-			err = crypto_register_skcipher(&ss_algs[i].alg.skcipher);
+				 ss_algs[i].alg.skcipher.base.base.cra_name);
+			err = crypto_engine_register_skcipher(&ss_algs[i].alg.skcipher);
 			if (err) {
 				dev_err(ss->dev, "Fail to register %s\n",
-					ss_algs[i].alg.skcipher.base.cra_name);
+					ss_algs[i].alg.skcipher.base.base.cra_name);
 				ss_algs[i].ss = NULL;
 				return err;
 			}
@@ -695,16 +727,16 @@ static int sun8i_ss_register_algs(struct sun8i_ss_dev *ss)
 			if (ss_method == SS_ID_NOTSUPP) {
 				dev_info(ss->dev,
 					"DEBUG: Algo of %s not supported\n",
-					ss_algs[i].alg.hash.halg.base.cra_name);
+					ss_algs[i].alg.hash.base.halg.base.cra_name);
 				ss_algs[i].ss = NULL;
 				break;
 			}
 			dev_info(ss->dev, "Register %s\n",
-				 ss_algs[i].alg.hash.halg.base.cra_name);
-			err = crypto_register_ahash(&ss_algs[i].alg.hash);
+				 ss_algs[i].alg.hash.base.halg.base.cra_name);
+			err = crypto_engine_register_ahash(&ss_algs[i].alg.hash);
 			if (err) {
 				dev_err(ss->dev, "ERROR: Fail to register %s\n",
-					ss_algs[i].alg.hash.halg.base.cra_name);
+					ss_algs[i].alg.hash.base.halg.base.cra_name);
 				ss_algs[i].ss = NULL;
 				return err;
 			}
@@ -727,8 +759,8 @@ static void sun8i_ss_unregister_algs(struct sun8i_ss_dev *ss)
 		switch (ss_algs[i].type) {
 		case CRYPTO_ALG_TYPE_SKCIPHER:
 			dev_info(ss->dev, "Unregister %d %s\n", i,
-				 ss_algs[i].alg.skcipher.base.cra_name);
-			crypto_unregister_skcipher(&ss_algs[i].alg.skcipher);
+				 ss_algs[i].alg.skcipher.base.base.cra_name);
+			crypto_engine_unregister_skcipher(&ss_algs[i].alg.skcipher);
 			break;
 		case CRYPTO_ALG_TYPE_RNG:
 			dev_info(ss->dev, "Unregister %d %s\n", i,
@@ -737,8 +769,8 @@ static void sun8i_ss_unregister_algs(struct sun8i_ss_dev *ss)
 			break;
 		case CRYPTO_ALG_TYPE_AHASH:
 			dev_info(ss->dev, "Unregister %d %s\n", i,
-				 ss_algs[i].alg.hash.halg.base.cra_name);
-			crypto_unregister_ahash(&ss_algs[i].alg.hash);
+				 ss_algs[i].alg.hash.base.halg.base.cra_name);
+			crypto_engine_unregister_ahash(&ss_algs[i].alg.hash);
 			break;
 		}
 	}
@@ -851,13 +883,21 @@ static int sun8i_ss_probe(struct platform_device *pdev)
 
 	pm_runtime_put_sync(ss->dev);
 
+	if (IS_ENABLED(CONFIG_CRYPTO_DEV_SUN8I_SS_DEBUG)) {
+		struct dentry *dbgfs_dir __maybe_unused;
+		struct dentry *dbgfs_stats __maybe_unused;
+
+		/* Ignore error of debugfs */
+		dbgfs_dir = debugfs_create_dir("sun8i-ss", NULL);
+		dbgfs_stats = debugfs_create_file("stats", 0444,
+						   dbgfs_dir, ss,
+						   &sun8i_ss_debugfs_fops);
+
 #ifdef CONFIG_CRYPTO_DEV_SUN8I_SS_DEBUG
-	/* Ignore error of debugfs */
-	ss->dbgfs_dir = debugfs_create_dir("sun8i-ss", NULL);
-	ss->dbgfs_stats = debugfs_create_file("stats", 0444,
-					      ss->dbgfs_dir, ss,
-					      &sun8i_ss_debugfs_fops);
+		ss->dbgfs_dir = dbgfs_dir;
+		ss->dbgfs_stats = dbgfs_stats;
 #endif
+	}
 
 	return 0;
 error_alg:
diff --git a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c
index e6865b49b1df..721da87af120 100644
--- a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c
+++ b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c
@@ -9,16 +9,21 @@
  *
  * You could find the datasheet in Documentation/arch/arm/sunxi.rst
  */
-#include <linux/bottom_half.h>
-#include <linux/dma-mapping.h>
-#include <linux/pm_runtime.h>
-#include <linux/scatterlist.h>
-#include <crypto/internal/hash.h>
+
 #include <crypto/hmac.h>
+#include <crypto/internal/hash.h>
+#include <crypto/md5.h>
 #include <crypto/scatterwalk.h>
 #include <crypto/sha1.h>
 #include <crypto/sha2.h>
-#include <crypto/md5.h>
+#include <linux/bottom_half.h>
+#include <linux/dma-mapping.h>
+#include <linux/err.h>
+#include <linux/kernel.h>
+#include <linux/pm_runtime.h>
+#include <linux/scatterlist.h>
+#include <linux/slab.h>
+#include <linux/string.h>
 #include "sun8i-ss.h"
 
 static int sun8i_ss_hashkey(struct sun8i_ss_hash_tfm_ctx *tfmctx, const u8 *key,
@@ -60,14 +65,11 @@ int sun8i_ss_hmac_setkey(struct crypto_ahash *ahash, const u8 *key,
 			 unsigned int keylen)
 {
 	struct sun8i_ss_hash_tfm_ctx *tfmctx = crypto_ahash_ctx(ahash);
-	struct ahash_alg *alg = __crypto_ahash_alg(ahash->base.__crt_alg);
-	struct sun8i_ss_alg_template *algt;
 	int digestsize, i;
 	int bs = crypto_ahash_blocksize(ahash);
 	int ret;
 
-	algt = container_of(alg, struct sun8i_ss_alg_template, alg.hash);
-	digestsize = algt->alg.hash.halg.digestsize;
+	digestsize = crypto_ahash_digestsize(ahash);
 
 	if (keylen > bs) {
 		ret = sun8i_ss_hashkey(tfmctx, key, keylen);
@@ -107,36 +109,33 @@ int sun8i_ss_hmac_setkey(struct crypto_ahash *ahash, const u8 *key,
 	return ret;
 }
 
-int sun8i_ss_hash_crainit(struct crypto_tfm *tfm)
+int sun8i_ss_hash_init_tfm(struct crypto_ahash *tfm)
 {
-	struct sun8i_ss_hash_tfm_ctx *op = crypto_tfm_ctx(tfm);
-	struct ahash_alg *alg = __crypto_ahash_alg(tfm->__crt_alg);
+	struct sun8i_ss_hash_tfm_ctx *op = crypto_ahash_ctx(tfm);
+	struct ahash_alg *alg = crypto_ahash_alg(tfm);
 	struct sun8i_ss_alg_template *algt;
 	int err;
 
-	memset(op, 0, sizeof(struct sun8i_ss_hash_tfm_ctx));
-
-	algt = container_of(alg, struct sun8i_ss_alg_template, alg.hash);
+	algt = container_of(alg, struct sun8i_ss_alg_template, alg.hash.base);
 	op->ss = algt->ss;
 
-	op->enginectx.op.do_one_request = sun8i_ss_hash_run;
-
 	/* FALLBACK */
-	op->fallback_tfm = crypto_alloc_ahash(crypto_tfm_alg_name(tfm), 0,
+	op->fallback_tfm = crypto_alloc_ahash(crypto_ahash_alg_name(tfm), 0,
 					      CRYPTO_ALG_NEED_FALLBACK);
 	if (IS_ERR(op->fallback_tfm)) {
 		dev_err(algt->ss->dev, "Fallback driver could no be loaded\n");
 		return PTR_ERR(op->fallback_tfm);
 	}
 
-	if (algt->alg.hash.halg.statesize < crypto_ahash_statesize(op->fallback_tfm))
-		algt->alg.hash.halg.statesize = crypto_ahash_statesize(op->fallback_tfm);
+	crypto_ahash_set_statesize(tfm,
+				   crypto_ahash_statesize(op->fallback_tfm));
 
-	crypto_ahash_set_reqsize(__crypto_ahash_cast(tfm),
+	crypto_ahash_set_reqsize(tfm,
 				 sizeof(struct sun8i_ss_hash_reqctx) +
 				 crypto_ahash_reqsize(op->fallback_tfm));
 
-	memcpy(algt->fbname, crypto_tfm_alg_driver_name(&op->fallback_tfm->base), CRYPTO_MAX_ALG_NAME);
+	memcpy(algt->fbname, crypto_ahash_driver_name(op->fallback_tfm),
+	       CRYPTO_MAX_ALG_NAME);
 
 	err = pm_runtime_get_sync(op->ss->dev);
 	if (err < 0)
@@ -148,9 +147,9 @@ int sun8i_ss_hash_crainit(struct crypto_tfm *tfm)
 	return err;
 }
 
-void sun8i_ss_hash_craexit(struct crypto_tfm *tfm)
+void sun8i_ss_hash_exit_tfm(struct crypto_ahash *tfm)
 {
-	struct sun8i_ss_hash_tfm_ctx *tfmctx = crypto_tfm_ctx(tfm);
+	struct sun8i_ss_hash_tfm_ctx *tfmctx = crypto_ahash_ctx(tfm);
 
 	kfree_sensitive(tfmctx->ipad);
 	kfree_sensitive(tfmctx->opad);
@@ -203,7 +202,7 @@ int sun8i_ss_hash_final(struct ahash_request *areq)
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
 	struct sun8i_ss_hash_tfm_ctx *tfmctx = crypto_ahash_ctx(tfm);
 #ifdef CONFIG_CRYPTO_DEV_SUN8I_SS_DEBUG
-	struct ahash_alg *alg = __crypto_ahash_alg(tfm->base.__crt_alg);
+	struct ahash_alg *alg = crypto_ahash_alg(tfm);
 	struct sun8i_ss_alg_template *algt;
 #endif
 
@@ -213,7 +212,7 @@ int sun8i_ss_hash_final(struct ahash_request *areq)
 	rctx->fallback_req.result = areq->result;
 
 #ifdef CONFIG_CRYPTO_DEV_SUN8I_SS_DEBUG
-	algt = container_of(alg, struct sun8i_ss_alg_template, alg.hash);
+	algt = container_of(alg, struct sun8i_ss_alg_template, alg.hash.base);
 	algt->stat_fb++;
 #endif
 
@@ -241,7 +240,7 @@ int sun8i_ss_hash_finup(struct ahash_request *areq)
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
 	struct sun8i_ss_hash_tfm_ctx *tfmctx = crypto_ahash_ctx(tfm);
 #ifdef CONFIG_CRYPTO_DEV_SUN8I_SS_DEBUG
-	struct ahash_alg *alg = __crypto_ahash_alg(tfm->base.__crt_alg);
+	struct ahash_alg *alg = crypto_ahash_alg(tfm);
 	struct sun8i_ss_alg_template *algt;
 #endif
 
@@ -253,7 +252,7 @@ int sun8i_ss_hash_finup(struct ahash_request *areq)
 	rctx->fallback_req.src = areq->src;
 	rctx->fallback_req.result = areq->result;
 #ifdef CONFIG_CRYPTO_DEV_SUN8I_SS_DEBUG
-	algt = container_of(alg, struct sun8i_ss_alg_template, alg.hash);
+	algt = container_of(alg, struct sun8i_ss_alg_template, alg.hash.base);
 	algt->stat_fb++;
 #endif
 
@@ -266,7 +265,7 @@ static int sun8i_ss_hash_digest_fb(struct ahash_request *areq)
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
 	struct sun8i_ss_hash_tfm_ctx *tfmctx = crypto_ahash_ctx(tfm);
 #ifdef CONFIG_CRYPTO_DEV_SUN8I_SS_DEBUG
-	struct ahash_alg *alg = __crypto_ahash_alg(tfm->base.__crt_alg);
+	struct ahash_alg *alg = crypto_ahash_alg(tfm);
 	struct sun8i_ss_alg_template *algt;
 #endif
 
@@ -278,7 +277,7 @@ static int sun8i_ss_hash_digest_fb(struct ahash_request *areq)
 	rctx->fallback_req.src = areq->src;
 	rctx->fallback_req.result = areq->result;
 #ifdef CONFIG_CRYPTO_DEV_SUN8I_SS_DEBUG
-	algt = container_of(alg, struct sun8i_ss_alg_template, alg.hash);
+	algt = container_of(alg, struct sun8i_ss_alg_template, alg.hash.base);
 	algt->stat_fb++;
 #endif
 
@@ -347,11 +346,11 @@ static int sun8i_ss_run_hash_task(struct sun8i_ss_dev *ss,
 static bool sun8i_ss_hash_need_fallback(struct ahash_request *areq)
 {
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
-	struct ahash_alg *alg = __crypto_ahash_alg(tfm->base.__crt_alg);
+	struct ahash_alg *alg = crypto_ahash_alg(tfm);
 	struct sun8i_ss_alg_template *algt;
 	struct scatterlist *sg;
 
-	algt = container_of(alg, struct sun8i_ss_alg_template, alg.hash);
+	algt = container_of(alg, struct sun8i_ss_alg_template, alg.hash.base);
 
 	if (areq->nbytes == 0) {
 		algt->stat_fb_len++;
@@ -396,8 +395,8 @@ static bool sun8i_ss_hash_need_fallback(struct ahash_request *areq)
 int sun8i_ss_hash_digest(struct ahash_request *areq)
 {
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
-	struct ahash_alg *alg = __crypto_ahash_alg(tfm->base.__crt_alg);
 	struct sun8i_ss_hash_reqctx *rctx = ahash_request_ctx(areq);
+	struct ahash_alg *alg = crypto_ahash_alg(tfm);
 	struct sun8i_ss_alg_template *algt;
 	struct sun8i_ss_dev *ss;
 	struct crypto_engine *engine;
@@ -406,7 +405,7 @@ int sun8i_ss_hash_digest(struct ahash_request *areq)
 	if (sun8i_ss_hash_need_fallback(areq))
 		return sun8i_ss_hash_digest_fb(areq);
 
-	algt = container_of(alg, struct sun8i_ss_alg_template, alg.hash);
+	algt = container_of(alg, struct sun8i_ss_alg_template, alg.hash.base);
 	ss = algt->ss;
 
 	e = sun8i_ss_get_engine_number(ss);
@@ -482,8 +481,8 @@ int sun8i_ss_hash_run(struct crypto_engine *engine, void *breq)
 	struct ahash_request *areq = container_of(breq, struct ahash_request, base);
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
 	struct sun8i_ss_hash_tfm_ctx *tfmctx = crypto_ahash_ctx(tfm);
-	struct ahash_alg *alg = __crypto_ahash_alg(tfm->base.__crt_alg);
 	struct sun8i_ss_hash_reqctx *rctx = ahash_request_ctx(areq);
+	struct ahash_alg *alg = crypto_ahash_alg(tfm);
 	struct sun8i_ss_alg_template *algt;
 	struct sun8i_ss_dev *ss;
 	struct scatterlist *sg;
@@ -502,10 +501,10 @@ int sun8i_ss_hash_run(struct crypto_engine *engine, void *breq)
 	 */
 	int hmac = 0;
 
-	algt = container_of(alg, struct sun8i_ss_alg_template, alg.hash);
+	algt = container_of(alg, struct sun8i_ss_alg_template, alg.hash.base);
 	ss = algt->ss;
 
-	digestsize = algt->alg.hash.halg.digestsize;
+	digestsize = crypto_ahash_digestsize(tfm);
 	if (digestsize == SHA224_DIGEST_SIZE)
 		digestsize = SHA256_DIGEST_SIZE;
 
@@ -698,7 +697,7 @@ int sun8i_ss_hash_run(struct crypto_engine *engine, void *breq)
 	}
 
 	if (!err)
-		memcpy(areq->result, result, algt->alg.hash.halg.digestsize);
+		memcpy(areq->result, result, crypto_ahash_digestsize(tfm));
 theend:
 	local_bh_disable();
 	crypto_finalize_hash_request(engine, breq, err);
diff --git a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h
index df6f08f6092f..d850fb7948e5 100644
--- a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h
+++ b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h
@@ -201,16 +201,12 @@ struct sun8i_cipher_req_ctx {
 
 /*
  * struct sun8i_cipher_tfm_ctx - context for a skcipher TFM
- * @enginectx:		crypto_engine used by this TFM
  * @key:		pointer to key data
  * @keylen:		len of the key
  * @ss:			pointer to the private data of driver handling this TFM
  * @fallback_tfm:	pointer to the fallback TFM
- *
- * enginectx must be the first element
  */
 struct sun8i_cipher_tfm_ctx {
-	struct crypto_engine_ctx enginectx;
 	u32 *key;
 	u32 keylen;
 	struct sun8i_ss_dev *ss;
@@ -229,14 +225,10 @@ struct sun8i_ss_rng_tfm_ctx {
 
 /*
  * struct sun8i_ss_hash_tfm_ctx - context for an ahash TFM
- * @enginectx:		crypto_engine used by this TFM
  * @fallback_tfm:	pointer to the fallback TFM
  * @ss:			pointer to the private data of driver handling this TFM
- *
- * enginectx must be the first element
  */
 struct sun8i_ss_hash_tfm_ctx {
-	struct crypto_engine_ctx enginectx;
 	struct crypto_ahash *fallback_tfm;
 	struct sun8i_ss_dev *ss;
 	u8 *ipad;
@@ -279,9 +271,9 @@ struct sun8i_ss_alg_template {
 	u32 ss_blockmode;
 	struct sun8i_ss_dev *ss;
 	union {
-		struct skcipher_alg skcipher;
+		struct skcipher_engine_alg skcipher;
 		struct rng_alg rng;
-		struct ahash_alg hash;
+		struct ahash_engine_alg hash;
 	} alg;
 	unsigned long stat_req;
 	unsigned long stat_fb;
@@ -301,6 +293,7 @@ int sun8i_ss_des3_setkey(struct crypto_skcipher *tfm, const u8 *key,
 			 unsigned int keylen);
 int sun8i_ss_cipher_init(struct crypto_tfm *tfm);
 void sun8i_ss_cipher_exit(struct crypto_tfm *tfm);
+int sun8i_ss_handle_cipher_request(struct crypto_engine *engine, void *areq);
 int sun8i_ss_skdecrypt(struct skcipher_request *areq);
 int sun8i_ss_skencrypt(struct skcipher_request *areq);
 
@@ -313,8 +306,8 @@ int sun8i_ss_prng_seed(struct crypto_rng *tfm, const u8 *seed, unsigned int slen
 int sun8i_ss_prng_init(struct crypto_tfm *tfm);
 void sun8i_ss_prng_exit(struct crypto_tfm *tfm);
 
-int sun8i_ss_hash_crainit(struct crypto_tfm *tfm);
-void sun8i_ss_hash_craexit(struct crypto_tfm *tfm);
+int sun8i_ss_hash_init_tfm(struct crypto_ahash *tfm);
+void sun8i_ss_hash_exit_tfm(struct crypto_ahash *tfm);
 int sun8i_ss_hash_init(struct ahash_request *areq);
 int sun8i_ss_hash_export(struct ahash_request *areq, void *out);
 int sun8i_ss_hash_import(struct ahash_request *areq, const void *in);
