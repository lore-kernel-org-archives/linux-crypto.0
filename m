Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4746CC001DB
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Aug 2023 09:31:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233345AbjHKJbN (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Aug 2023 05:31:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232954AbjHKJat (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Aug 2023 05:30:49 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB62030E7
        for <linux-crypto@vger.kernel.org>; Fri, 11 Aug 2023 02:30:47 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qUOTi-0020kB-T4; Fri, 11 Aug 2023 17:30:43 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 11 Aug 2023 17:30:43 +0800
From:   "Herbert Xu" <herbert@gondor.apana.org.au>
Date:   Fri, 11 Aug 2023 17:30:43 +0800
Subject: [PATCH 31/36] crypto: rk3288 - Use new crypto_engine_op interface
References: <ZNX/BwEkV3SDpsAS@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Gaurav Jain <gaurav.jain@nxp.com>
Message-Id: <E1qUOTi-0020kB-T4@formenos.hmeau.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Use the new crypto_engine_op interface where the callback is stored
in the algorithm object.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/crypto/rockchip/rk3288_crypto.c          |   58 +++++++++++--------
 drivers/crypto/rockchip/rk3288_crypto.h          |   21 ++-----
 drivers/crypto/rockchip/rk3288_crypto_ahash.c    |   67 +++++++++++++----------
 drivers/crypto/rockchip/rk3288_crypto_skcipher.c |   60 ++++++++++++++------
 4 files changed, 123 insertions(+), 83 deletions(-)

diff --git a/drivers/crypto/rockchip/rk3288_crypto.c b/drivers/crypto/rockchip/rk3288_crypto.c
index 9f6ba770a90a..937826c50470 100644
--- a/drivers/crypto/rockchip/rk3288_crypto.c
+++ b/drivers/crypto/rockchip/rk3288_crypto.c
@@ -10,14 +10,22 @@
  */
 
 #include "rk3288_crypto.h"
+#include <crypto/engine.h>
+#include <crypto/internal/hash.h>
+#include <crypto/internal/skcipher.h>
+#include <linux/clk.h>
 #include <linux/dma-mapping.h>
+#include <linux/debugfs.h>
+#include <linux/delay.h>
+#include <linux/err.h>
+#include <linux/kernel.h>
+#include <linux/io.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
-#include <linux/clk.h>
-#include <linux/crypto.h>
 #include <linux/reset.h>
+#include <linux/spinlock.h>
 
 static struct rockchip_ip rocklist = {
 	.dev_list = LIST_HEAD_INIT(rocklist.dev_list),
@@ -184,7 +192,6 @@ static struct rk_crypto_tmp *rk_cipher_algs[] = {
 	&rk_ahash_md5,
 };
 
-#ifdef CONFIG_CRYPTO_DEV_ROCKCHIP_DEBUG
 static int rk_crypto_debugfs_show(struct seq_file *seq, void *v)
 {
 	struct rk_crypto_info *dd;
@@ -204,8 +211,8 @@ static int rk_crypto_debugfs_show(struct seq_file *seq, void *v)
 		switch (rk_cipher_algs[i]->type) {
 		case CRYPTO_ALG_TYPE_SKCIPHER:
 			seq_printf(seq, "%s %s reqs=%lu fallback=%lu\n",
-				   rk_cipher_algs[i]->alg.skcipher.base.cra_driver_name,
-				   rk_cipher_algs[i]->alg.skcipher.base.cra_name,
+				   rk_cipher_algs[i]->alg.skcipher.base.base.cra_driver_name,
+				   rk_cipher_algs[i]->alg.skcipher.base.base.cra_name,
 				   rk_cipher_algs[i]->stat_req, rk_cipher_algs[i]->stat_fb);
 			seq_printf(seq, "\tfallback due to length: %lu\n",
 				   rk_cipher_algs[i]->stat_fb_len);
@@ -216,8 +223,8 @@ static int rk_crypto_debugfs_show(struct seq_file *seq, void *v)
 			break;
 		case CRYPTO_ALG_TYPE_AHASH:
 			seq_printf(seq, "%s %s reqs=%lu fallback=%lu\n",
-				   rk_cipher_algs[i]->alg.hash.halg.base.cra_driver_name,
-				   rk_cipher_algs[i]->alg.hash.halg.base.cra_name,
+				   rk_cipher_algs[i]->alg.hash.base.halg.base.cra_driver_name,
+				   rk_cipher_algs[i]->alg.hash.base.halg.base.cra_name,
 				   rk_cipher_algs[i]->stat_req, rk_cipher_algs[i]->stat_fb);
 			break;
 		}
@@ -226,17 +233,20 @@ static int rk_crypto_debugfs_show(struct seq_file *seq, void *v)
 }
 
 DEFINE_SHOW_ATTRIBUTE(rk_crypto_debugfs);
-#endif
 
 static void register_debugfs(struct rk_crypto_info *crypto_info)
 {
-#ifdef CONFIG_CRYPTO_DEV_ROCKCHIP_DEBUG
+	struct dentry *dbgfs_dir __maybe_unused;
+	struct dentry *dbgfs_stats __maybe_unused;
+
 	/* Ignore error of debugfs */
-	rocklist.dbgfs_dir = debugfs_create_dir("rk3288_crypto", NULL);
-	rocklist.dbgfs_stats = debugfs_create_file("stats", 0444,
-						   rocklist.dbgfs_dir,
-						   &rocklist,
-						   &rk_crypto_debugfs_fops);
+	dbgfs_dir = debugfs_create_dir("rk3288_crypto", NULL);
+	dbgfs_stats = debugfs_create_file("stats", 0444, dbgfs_dir, &rocklist,
+					  &rk_crypto_debugfs_fops);
+
+#ifdef CONFIG_CRYPTO_DEV_ROCKCHIP_DEBUG
+	rocklist.dbgfs_dir = dbgfs_dir;
+	rocklist.dbgfs_stats = dbgfs_stats;
 #endif
 }
 
@@ -250,15 +260,15 @@ static int rk_crypto_register(struct rk_crypto_info *crypto_info)
 		switch (rk_cipher_algs[i]->type) {
 		case CRYPTO_ALG_TYPE_SKCIPHER:
 			dev_info(crypto_info->dev, "Register %s as %s\n",
-				 rk_cipher_algs[i]->alg.skcipher.base.cra_name,
-				 rk_cipher_algs[i]->alg.skcipher.base.cra_driver_name);
-			err = crypto_register_skcipher(&rk_cipher_algs[i]->alg.skcipher);
+				 rk_cipher_algs[i]->alg.skcipher.base.base.cra_name,
+				 rk_cipher_algs[i]->alg.skcipher.base.base.cra_driver_name);
+			err = crypto_engine_register_skcipher(&rk_cipher_algs[i]->alg.skcipher);
 			break;
 		case CRYPTO_ALG_TYPE_AHASH:
 			dev_info(crypto_info->dev, "Register %s as %s\n",
-				 rk_cipher_algs[i]->alg.hash.halg.base.cra_name,
-				 rk_cipher_algs[i]->alg.hash.halg.base.cra_driver_name);
-			err = crypto_register_ahash(&rk_cipher_algs[i]->alg.hash);
+				 rk_cipher_algs[i]->alg.hash.base.halg.base.cra_name,
+				 rk_cipher_algs[i]->alg.hash.base.halg.base.cra_driver_name);
+			err = crypto_engine_register_ahash(&rk_cipher_algs[i]->alg.hash);
 			break;
 		default:
 			dev_err(crypto_info->dev, "unknown algorithm\n");
@@ -271,9 +281,9 @@ static int rk_crypto_register(struct rk_crypto_info *crypto_info)
 err_cipher_algs:
 	for (k = 0; k < i; k++) {
 		if (rk_cipher_algs[i]->type == CRYPTO_ALG_TYPE_SKCIPHER)
-			crypto_unregister_skcipher(&rk_cipher_algs[k]->alg.skcipher);
+			crypto_engine_unregister_skcipher(&rk_cipher_algs[k]->alg.skcipher);
 		else
-			crypto_unregister_ahash(&rk_cipher_algs[i]->alg.hash);
+			crypto_engine_unregister_ahash(&rk_cipher_algs[i]->alg.hash);
 	}
 	return err;
 }
@@ -284,9 +294,9 @@ static void rk_crypto_unregister(void)
 
 	for (i = 0; i < ARRAY_SIZE(rk_cipher_algs); i++) {
 		if (rk_cipher_algs[i]->type == CRYPTO_ALG_TYPE_SKCIPHER)
-			crypto_unregister_skcipher(&rk_cipher_algs[i]->alg.skcipher);
+			crypto_engine_unregister_skcipher(&rk_cipher_algs[i]->alg.skcipher);
 		else
-			crypto_unregister_ahash(&rk_cipher_algs[i]->alg.hash);
+			crypto_engine_unregister_ahash(&rk_cipher_algs[i]->alg.hash);
 	}
 }
 
diff --git a/drivers/crypto/rockchip/rk3288_crypto.h b/drivers/crypto/rockchip/rk3288_crypto.h
index b2695258cade..3aa03cbfb6be 100644
--- a/drivers/crypto/rockchip/rk3288_crypto.h
+++ b/drivers/crypto/rockchip/rk3288_crypto.h
@@ -3,21 +3,18 @@
 #define __RK3288_CRYPTO_H__
 
 #include <crypto/aes.h>
-#include <crypto/internal/des.h>
-#include <crypto/algapi.h>
-#include <linux/dma-mapping.h>
-#include <linux/interrupt.h>
-#include <linux/debugfs.h>
-#include <linux/delay.h>
-#include <linux/pm_runtime.h>
-#include <linux/scatterlist.h>
 #include <crypto/engine.h>
+#include <crypto/internal/des.h>
 #include <crypto/internal/hash.h>
 #include <crypto/internal/skcipher.h>
-
 #include <crypto/md5.h>
 #include <crypto/sha1.h>
 #include <crypto/sha2.h>
+#include <linux/dma-mapping.h>
+#include <linux/interrupt.h>
+#include <linux/pm_runtime.h>
+#include <linux/scatterlist.h>
+#include <linux/types.h>
 
 #define _SBF(v, f)			((v) << (f))
 
@@ -231,7 +228,6 @@ struct rk_crypto_info {
 
 /* the private variable of hash */
 struct rk_ahash_ctx {
-	struct crypto_engine_ctx enginectx;
 	/* for fallback */
 	struct crypto_ahash		*fallback_tfm;
 };
@@ -246,7 +242,6 @@ struct rk_ahash_rctx {
 
 /* the private variable of cipher */
 struct rk_cipher_ctx {
-	struct crypto_engine_ctx enginectx;
 	unsigned int			keylen;
 	u8				key[AES_MAX_KEY_SIZE];
 	u8				iv[AES_BLOCK_SIZE];
@@ -264,8 +259,8 @@ struct rk_crypto_tmp {
 	u32 type;
 	struct rk_crypto_info           *dev;
 	union {
-		struct skcipher_alg	skcipher;
-		struct ahash_alg	hash;
+		struct skcipher_engine_alg skcipher;
+		struct ahash_engine_alg hash;
 	} alg;
 	unsigned long stat_req;
 	unsigned long stat_fb;
diff --git a/drivers/crypto/rockchip/rk3288_crypto_ahash.c b/drivers/crypto/rockchip/rk3288_crypto_ahash.c
index 1519aa0a0f7c..8c143180645e 100644
--- a/drivers/crypto/rockchip/rk3288_crypto_ahash.c
+++ b/drivers/crypto/rockchip/rk3288_crypto_ahash.c
@@ -8,9 +8,15 @@
  *
  * Some ideas are from marvell/cesa.c and s5p-sss.c driver.
  */
-#include <linux/device.h>
+
 #include <asm/unaligned.h>
+#include <crypto/internal/hash.h>
+#include <linux/device.h>
+#include <linux/err.h>
 #include <linux/iopoll.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/string.h>
 #include "rk3288_crypto.h"
 
 /*
@@ -40,8 +46,8 @@ static int rk_ahash_digest_fb(struct ahash_request *areq)
 	struct rk_ahash_rctx *rctx = ahash_request_ctx(areq);
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
 	struct rk_ahash_ctx *tfmctx = crypto_ahash_ctx(tfm);
-	struct ahash_alg *alg = __crypto_ahash_alg(tfm->base.__crt_alg);
-	struct rk_crypto_tmp *algt = container_of(alg, struct rk_crypto_tmp, alg.hash);
+	struct ahash_alg *alg = crypto_ahash_alg(tfm);
+	struct rk_crypto_tmp *algt = container_of(alg, struct rk_crypto_tmp, alg.hash.base);
 
 	algt->stat_fb++;
 
@@ -254,8 +260,8 @@ static int rk_hash_run(struct crypto_engine *engine, void *breq)
 	struct ahash_request *areq = container_of(breq, struct ahash_request, base);
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
 	struct rk_ahash_rctx *rctx = ahash_request_ctx(areq);
-	struct ahash_alg *alg = __crypto_ahash_alg(tfm->base.__crt_alg);
-	struct rk_crypto_tmp *algt = container_of(alg, struct rk_crypto_tmp, alg.hash);
+	struct ahash_alg *alg = crypto_ahash_alg(tfm);
+	struct rk_crypto_tmp *algt = container_of(alg, struct rk_crypto_tmp, alg.hash.base);
 	struct scatterlist *sg = areq->src;
 	struct rk_crypto_info *rkc = rctx->dev;
 	int err;
@@ -335,12 +341,12 @@ static int rk_hash_run(struct crypto_engine *engine, void *breq)
 	return 0;
 }
 
-static int rk_cra_hash_init(struct crypto_tfm *tfm)
+static int rk_hash_init_tfm(struct crypto_ahash *tfm)
 {
-	struct rk_ahash_ctx *tctx = crypto_tfm_ctx(tfm);
-	const char *alg_name = crypto_tfm_alg_name(tfm);
-	struct ahash_alg *alg = __crypto_ahash_alg(tfm->__crt_alg);
-	struct rk_crypto_tmp *algt = container_of(alg, struct rk_crypto_tmp, alg.hash);
+	struct rk_ahash_ctx *tctx = crypto_ahash_ctx(tfm);
+	const char *alg_name = crypto_ahash_alg_name(tfm);
+	struct ahash_alg *alg = crypto_ahash_alg(tfm);
+	struct rk_crypto_tmp *algt = container_of(alg, struct rk_crypto_tmp, alg.hash.base);
 
 	/* for fallback */
 	tctx->fallback_tfm = crypto_alloc_ahash(alg_name, 0,
@@ -350,25 +356,23 @@ static int rk_cra_hash_init(struct crypto_tfm *tfm)
 		return PTR_ERR(tctx->fallback_tfm);
 	}
 
-	crypto_ahash_set_reqsize(__crypto_ahash_cast(tfm),
+	crypto_ahash_set_reqsize(tfm,
 				 sizeof(struct rk_ahash_rctx) +
 				 crypto_ahash_reqsize(tctx->fallback_tfm));
 
-	tctx->enginectx.op.do_one_request = rk_hash_run;
-
 	return 0;
 }
 
-static void rk_cra_hash_exit(struct crypto_tfm *tfm)
+static void rk_hash_exit_tfm(struct crypto_ahash *tfm)
 {
-	struct rk_ahash_ctx *tctx = crypto_tfm_ctx(tfm);
+	struct rk_ahash_ctx *tctx = crypto_ahash_ctx(tfm);
 
 	crypto_free_ahash(tctx->fallback_tfm);
 }
 
 struct rk_crypto_tmp rk_ahash_sha1 = {
 	.type = CRYPTO_ALG_TYPE_AHASH,
-	.alg.hash = {
+	.alg.hash.base = {
 		.init = rk_ahash_init,
 		.update = rk_ahash_update,
 		.final = rk_ahash_final,
@@ -376,6 +380,8 @@ struct rk_crypto_tmp rk_ahash_sha1 = {
 		.export = rk_ahash_export,
 		.import = rk_ahash_import,
 		.digest = rk_ahash_digest,
+		.init_tfm = rk_hash_init_tfm,
+		.exit_tfm = rk_hash_exit_tfm,
 		.halg = {
 			 .digestsize = SHA1_DIGEST_SIZE,
 			 .statesize = sizeof(struct sha1_state),
@@ -388,17 +394,18 @@ struct rk_crypto_tmp rk_ahash_sha1 = {
 				  .cra_blocksize = SHA1_BLOCK_SIZE,
 				  .cra_ctxsize = sizeof(struct rk_ahash_ctx),
 				  .cra_alignmask = 3,
-				  .cra_init = rk_cra_hash_init,
-				  .cra_exit = rk_cra_hash_exit,
 				  .cra_module = THIS_MODULE,
 			}
 		}
-	}
+	},
+	.alg.hash.op = {
+		.do_one_request = rk_hash_run,
+	},
 };
 
 struct rk_crypto_tmp rk_ahash_sha256 = {
 	.type = CRYPTO_ALG_TYPE_AHASH,
-	.alg.hash = {
+	.alg.hash.base = {
 		.init = rk_ahash_init,
 		.update = rk_ahash_update,
 		.final = rk_ahash_final,
@@ -406,6 +413,8 @@ struct rk_crypto_tmp rk_ahash_sha256 = {
 		.export = rk_ahash_export,
 		.import = rk_ahash_import,
 		.digest = rk_ahash_digest,
+		.init_tfm = rk_hash_init_tfm,
+		.exit_tfm = rk_hash_exit_tfm,
 		.halg = {
 			 .digestsize = SHA256_DIGEST_SIZE,
 			 .statesize = sizeof(struct sha256_state),
@@ -418,17 +427,18 @@ struct rk_crypto_tmp rk_ahash_sha256 = {
 				  .cra_blocksize = SHA256_BLOCK_SIZE,
 				  .cra_ctxsize = sizeof(struct rk_ahash_ctx),
 				  .cra_alignmask = 3,
-				  .cra_init = rk_cra_hash_init,
-				  .cra_exit = rk_cra_hash_exit,
 				  .cra_module = THIS_MODULE,
 			}
 		}
-	}
+	},
+	.alg.hash.op = {
+		.do_one_request = rk_hash_run,
+	},
 };
 
 struct rk_crypto_tmp rk_ahash_md5 = {
 	.type = CRYPTO_ALG_TYPE_AHASH,
-	.alg.hash = {
+	.alg.hash.base = {
 		.init = rk_ahash_init,
 		.update = rk_ahash_update,
 		.final = rk_ahash_final,
@@ -436,6 +446,8 @@ struct rk_crypto_tmp rk_ahash_md5 = {
 		.export = rk_ahash_export,
 		.import = rk_ahash_import,
 		.digest = rk_ahash_digest,
+		.init_tfm = rk_hash_init_tfm,
+		.exit_tfm = rk_hash_exit_tfm,
 		.halg = {
 			 .digestsize = MD5_DIGEST_SIZE,
 			 .statesize = sizeof(struct md5_state),
@@ -448,10 +460,11 @@ struct rk_crypto_tmp rk_ahash_md5 = {
 				  .cra_blocksize = SHA1_BLOCK_SIZE,
 				  .cra_ctxsize = sizeof(struct rk_ahash_ctx),
 				  .cra_alignmask = 3,
-				  .cra_init = rk_cra_hash_init,
-				  .cra_exit = rk_cra_hash_exit,
 				  .cra_module = THIS_MODULE,
 			}
 		}
-	}
+	},
+	.alg.hash.op = {
+		.do_one_request = rk_hash_run,
+	},
 };
diff --git a/drivers/crypto/rockchip/rk3288_crypto_skcipher.c b/drivers/crypto/rockchip/rk3288_crypto_skcipher.c
index 59069457582b..da95747d973f 100644
--- a/drivers/crypto/rockchip/rk3288_crypto_skcipher.c
+++ b/drivers/crypto/rockchip/rk3288_crypto_skcipher.c
@@ -8,8 +8,14 @@
  *
  * Some ideas are from marvell-cesa.c and s5p-sss.c driver.
  */
-#include <linux/device.h>
+
+#include <crypto/engine.h>
+#include <crypto/internal/skcipher.h>
 #include <crypto/scatterwalk.h>
+#include <linux/device.h>
+#include <linux/err.h>
+#include <linux/kernel.h>
+#include <linux/string.h>
 #include "rk3288_crypto.h"
 
 #define RK_CRYPTO_DEC			BIT(0)
@@ -18,7 +24,7 @@ static int rk_cipher_need_fallback(struct skcipher_request *req)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct skcipher_alg *alg = crypto_skcipher_alg(tfm);
-	struct rk_crypto_tmp *algt = container_of(alg, struct rk_crypto_tmp, alg.skcipher);
+	struct rk_crypto_tmp *algt = container_of(alg, struct rk_crypto_tmp, alg.skcipher.base);
 	struct scatterlist *sgs, *sgd;
 	unsigned int stodo, dtodo, len;
 	unsigned int bs = crypto_skcipher_blocksize(tfm);
@@ -65,7 +71,7 @@ static int rk_cipher_fallback(struct skcipher_request *areq)
 	struct rk_cipher_ctx *op = crypto_skcipher_ctx(tfm);
 	struct rk_cipher_rctx *rctx = skcipher_request_ctx(areq);
 	struct skcipher_alg *alg = crypto_skcipher_alg(tfm);
-	struct rk_crypto_tmp *algt = container_of(alg, struct rk_crypto_tmp, alg.skcipher);
+	struct rk_crypto_tmp *algt = container_of(alg, struct rk_crypto_tmp, alg.skcipher.base);
 	int err;
 
 	algt->stat_fb++;
@@ -305,7 +311,7 @@ static int rk_cipher_run(struct crypto_engine *engine, void *async_req)
 	unsigned int len = areq->cryptlen;
 	unsigned int todo;
 	struct skcipher_alg *alg = crypto_skcipher_alg(tfm);
-	struct rk_crypto_tmp *algt = container_of(alg, struct rk_crypto_tmp, alg.skcipher);
+	struct rk_crypto_tmp *algt = container_of(alg, struct rk_crypto_tmp, alg.skcipher.base);
 	struct rk_crypto_info *rkc = rctx->dev;
 
 	err = pm_runtime_resume_and_get(rkc->dev);
@@ -430,7 +436,7 @@ static int rk_cipher_tfm_init(struct crypto_skcipher *tfm)
 	struct rk_cipher_ctx *ctx = crypto_skcipher_ctx(tfm);
 	const char *name = crypto_tfm_alg_name(&tfm->base);
 	struct skcipher_alg *alg = crypto_skcipher_alg(tfm);
-	struct rk_crypto_tmp *algt = container_of(alg, struct rk_crypto_tmp, alg.skcipher);
+	struct rk_crypto_tmp *algt = container_of(alg, struct rk_crypto_tmp, alg.skcipher.base);
 
 	ctx->fallback_tfm = crypto_alloc_skcipher(name, 0, CRYPTO_ALG_NEED_FALLBACK);
 	if (IS_ERR(ctx->fallback_tfm)) {
@@ -442,8 +448,6 @@ static int rk_cipher_tfm_init(struct crypto_skcipher *tfm)
 	tfm->reqsize = sizeof(struct rk_cipher_rctx) +
 		crypto_skcipher_reqsize(ctx->fallback_tfm);
 
-	ctx->enginectx.op.do_one_request = rk_cipher_run;
-
 	return 0;
 }
 
@@ -457,7 +461,7 @@ static void rk_cipher_tfm_exit(struct crypto_skcipher *tfm)
 
 struct rk_crypto_tmp rk_ecb_aes_alg = {
 	.type = CRYPTO_ALG_TYPE_SKCIPHER,
-	.alg.skcipher = {
+	.alg.skcipher.base = {
 		.base.cra_name		= "ecb(aes)",
 		.base.cra_driver_name	= "ecb-aes-rk",
 		.base.cra_priority	= 300,
@@ -474,12 +478,15 @@ struct rk_crypto_tmp rk_ecb_aes_alg = {
 		.setkey			= rk_aes_setkey,
 		.encrypt		= rk_aes_ecb_encrypt,
 		.decrypt		= rk_aes_ecb_decrypt,
-	}
+	},
+	.alg.skcipher.op = {
+		.do_one_request = rk_cipher_run,
+	},
 };
 
 struct rk_crypto_tmp rk_cbc_aes_alg = {
 	.type = CRYPTO_ALG_TYPE_SKCIPHER,
-	.alg.skcipher = {
+	.alg.skcipher.base = {
 		.base.cra_name		= "cbc(aes)",
 		.base.cra_driver_name	= "cbc-aes-rk",
 		.base.cra_priority	= 300,
@@ -497,12 +504,15 @@ struct rk_crypto_tmp rk_cbc_aes_alg = {
 		.setkey			= rk_aes_setkey,
 		.encrypt		= rk_aes_cbc_encrypt,
 		.decrypt		= rk_aes_cbc_decrypt,
-	}
+	},
+	.alg.skcipher.op = {
+		.do_one_request = rk_cipher_run,
+	},
 };
 
 struct rk_crypto_tmp rk_ecb_des_alg = {
 	.type = CRYPTO_ALG_TYPE_SKCIPHER,
-	.alg.skcipher = {
+	.alg.skcipher.base = {
 		.base.cra_name		= "ecb(des)",
 		.base.cra_driver_name	= "ecb-des-rk",
 		.base.cra_priority	= 300,
@@ -519,12 +529,15 @@ struct rk_crypto_tmp rk_ecb_des_alg = {
 		.setkey			= rk_des_setkey,
 		.encrypt		= rk_des_ecb_encrypt,
 		.decrypt		= rk_des_ecb_decrypt,
-	}
+	},
+	.alg.skcipher.op = {
+		.do_one_request = rk_cipher_run,
+	},
 };
 
 struct rk_crypto_tmp rk_cbc_des_alg = {
 	.type = CRYPTO_ALG_TYPE_SKCIPHER,
-	.alg.skcipher = {
+	.alg.skcipher.base = {
 		.base.cra_name		= "cbc(des)",
 		.base.cra_driver_name	= "cbc-des-rk",
 		.base.cra_priority	= 300,
@@ -542,12 +555,15 @@ struct rk_crypto_tmp rk_cbc_des_alg = {
 		.setkey			= rk_des_setkey,
 		.encrypt		= rk_des_cbc_encrypt,
 		.decrypt		= rk_des_cbc_decrypt,
-	}
+	},
+	.alg.skcipher.op = {
+		.do_one_request = rk_cipher_run,
+	},
 };
 
 struct rk_crypto_tmp rk_ecb_des3_ede_alg = {
 	.type = CRYPTO_ALG_TYPE_SKCIPHER,
-	.alg.skcipher = {
+	.alg.skcipher.base = {
 		.base.cra_name		= "ecb(des3_ede)",
 		.base.cra_driver_name	= "ecb-des3-ede-rk",
 		.base.cra_priority	= 300,
@@ -564,12 +580,15 @@ struct rk_crypto_tmp rk_ecb_des3_ede_alg = {
 		.setkey			= rk_tdes_setkey,
 		.encrypt		= rk_des3_ede_ecb_encrypt,
 		.decrypt		= rk_des3_ede_ecb_decrypt,
-	}
+	},
+	.alg.skcipher.op = {
+		.do_one_request = rk_cipher_run,
+	},
 };
 
 struct rk_crypto_tmp rk_cbc_des3_ede_alg = {
 	.type = CRYPTO_ALG_TYPE_SKCIPHER,
-	.alg.skcipher = {
+	.alg.skcipher.base = {
 		.base.cra_name		= "cbc(des3_ede)",
 		.base.cra_driver_name	= "cbc-des3-ede-rk",
 		.base.cra_priority	= 300,
@@ -587,5 +606,8 @@ struct rk_crypto_tmp rk_cbc_des3_ede_alg = {
 		.setkey			= rk_tdes_setkey,
 		.encrypt		= rk_des3_ede_cbc_encrypt,
 		.decrypt		= rk_des3_ede_cbc_decrypt,
-	}
+	},
+	.alg.skcipher.op = {
+		.do_one_request = rk_cipher_run,
+	},
 };
