Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E8BBC04A6A
	for <linux-crypto@archiver.kernel.org>; Sun, 13 Aug 2023 06:55:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230316AbjHMGzU (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 13 Aug 2023 02:55:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230328AbjHMGy6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 13 Aug 2023 02:54:58 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A1111722
        for <linux-crypto@vger.kernel.org>; Sat, 12 Aug 2023 23:55:00 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qV503-002bpa-CP; Sun, 13 Aug 2023 14:54:56 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 13 Aug 2023 14:54:55 +0800
From:   "Herbert Xu" <herbert@gondor.apana.org.au>
Date:   Sun, 13 Aug 2023 14:54:55 +0800
Subject: [v2 PATCH 24/36] crypto: amlogic - Use new crypto_engine_op interface
References: <ZNh94a7YYnvx0l8C@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Gaurav Jain <gaurav.jain@nxp.com>
Message-Id: <E1qV503-002bpa-CP@formenos.hmeau.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Use the new crypto_engine_op interface where the callback is stored
in the algorithm object.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/crypto/amlogic/amlogic-gxl-cipher.c |   11 +----
 drivers/crypto/amlogic/amlogic-gxl-core.c   |   60 +++++++++++++++++++---------
 drivers/crypto/amlogic/amlogic-gxl.h        |    5 --
 3 files changed, 47 insertions(+), 29 deletions(-)

diff --git a/drivers/crypto/amlogic/amlogic-gxl-cipher.c b/drivers/crypto/amlogic/amlogic-gxl-cipher.c
index 03b6586b71ef..3308406612fc 100644
--- a/drivers/crypto/amlogic/amlogic-gxl-cipher.c
+++ b/drivers/crypto/amlogic/amlogic-gxl-cipher.c
@@ -65,7 +65,7 @@ static int meson_cipher_do_fallback(struct skcipher_request *areq)
 	struct skcipher_alg *alg = crypto_skcipher_alg(tfm);
 	struct meson_alg_template *algt;
 
-	algt = container_of(alg, struct meson_alg_template, alg.skcipher);
+	algt = container_of(alg, struct meson_alg_template, alg.skcipher.base);
 	algt->stat_fb++;
 #endif
 	skcipher_request_set_tfm(&rctx->fallback_req, op->fallback_tfm);
@@ -101,7 +101,7 @@ static int meson_cipher(struct skcipher_request *areq)
 	void *backup_iv = NULL, *bkeyiv;
 	u32 v;
 
-	algt = container_of(alg, struct meson_alg_template, alg.skcipher);
+	algt = container_of(alg, struct meson_alg_template, alg.skcipher.base);
 
 	dev_dbg(mc->dev, "%s %s %u %x IV(%u) key=%u flow=%d\n", __func__,
 		crypto_tfm_alg_name(areq->base.tfm),
@@ -258,8 +258,7 @@ static int meson_cipher(struct skcipher_request *areq)
 	return err;
 }
 
-static int meson_handle_cipher_request(struct crypto_engine *engine,
-				       void *areq)
+int meson_handle_cipher_request(struct crypto_engine *engine, void *areq)
 {
 	int err;
 	struct skcipher_request *breq = container_of(areq, struct skcipher_request, base);
@@ -318,7 +317,7 @@ int meson_cipher_init(struct crypto_tfm *tfm)
 
 	memset(op, 0, sizeof(struct meson_cipher_tfm_ctx));
 
-	algt = container_of(alg, struct meson_alg_template, alg.skcipher);
+	algt = container_of(alg, struct meson_alg_template, alg.skcipher.base);
 	op->mc = algt->mc;
 
 	op->fallback_tfm = crypto_alloc_skcipher(name, 0, CRYPTO_ALG_NEED_FALLBACK);
@@ -331,8 +330,6 @@ int meson_cipher_init(struct crypto_tfm *tfm)
 	sktfm->reqsize = sizeof(struct meson_cipher_req_ctx) +
 			 crypto_skcipher_reqsize(op->fallback_tfm);
 
-	op->enginectx.op.do_one_request = meson_handle_cipher_request;
-
 	return 0;
 }
 
diff --git a/drivers/crypto/amlogic/amlogic-gxl-core.c b/drivers/crypto/amlogic/amlogic-gxl-core.c
index 937187027ad5..9846d791c956 100644
--- a/drivers/crypto/amlogic/amlogic-gxl-core.c
+++ b/drivers/crypto/amlogic/amlogic-gxl-core.c
@@ -6,17 +6,20 @@
  *
  * Core file which registers crypto algorithms supported by the hardware.
  */
+
+#include <crypto/engine.h>
+#include <crypto/internal/skcipher.h>
 #include <linux/clk.h>
-#include <linux/crypto.h>
-#include <linux/io.h>
+#include <linux/dma-mapping.h>
+#include <linux/err.h>
 #include <linux/interrupt.h>
+#include <linux/io.h>
 #include <linux/irq.h>
+#include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
 #include <linux/platform_device.h>
-#include <crypto/internal/skcipher.h>
-#include <linux/dma-mapping.h>
 
 #include "amlogic-gxl.h"
 
@@ -47,7 +50,7 @@ static struct meson_alg_template mc_algs[] = {
 {
 	.type = CRYPTO_ALG_TYPE_SKCIPHER,
 	.blockmode = MESON_OPMODE_CBC,
-	.alg.skcipher = {
+	.alg.skcipher.base = {
 		.base = {
 			.cra_name = "cbc(aes)",
 			.cra_driver_name = "cbc-aes-gxl",
@@ -68,12 +71,15 @@ static struct meson_alg_template mc_algs[] = {
 		.setkey		= meson_aes_setkey,
 		.encrypt	= meson_skencrypt,
 		.decrypt	= meson_skdecrypt,
-	}
+	},
+	.alg.skcipher.op = {
+		.do_one_request = meson_handle_cipher_request,
+	},
 },
 {
 	.type = CRYPTO_ALG_TYPE_SKCIPHER,
 	.blockmode = MESON_OPMODE_ECB,
-	.alg.skcipher = {
+	.alg.skcipher.base = {
 		.base = {
 			.cra_name = "ecb(aes)",
 			.cra_driver_name = "ecb-aes-gxl",
@@ -93,33 +99,43 @@ static struct meson_alg_template mc_algs[] = {
 		.setkey		= meson_aes_setkey,
 		.encrypt	= meson_skencrypt,
 		.decrypt	= meson_skdecrypt,
-	}
+	},
+	.alg.skcipher.op = {
+		.do_one_request = meson_handle_cipher_request,
+	},
 },
 };
 
-#ifdef CONFIG_CRYPTO_DEV_AMLOGIC_GXL_DEBUG
 static int meson_debugfs_show(struct seq_file *seq, void *v)
 {
-	struct meson_dev *mc = seq->private;
+	struct meson_dev *mc __maybe_unused = seq->private;
 	int i;
 
 	for (i = 0; i < MAXFLOW; i++)
-		seq_printf(seq, "Channel %d: nreq %lu\n", i, mc->chanlist[i].stat_req);
+		seq_printf(seq, "Channel %d: nreq %lu\n", i,
+#ifdef CONFIG_CRYPTO_DEV_AMLOGIC_GXL_DEBUG
+			   mc->chanlist[i].stat_req);
+#else
+			   0ul);
+#endif
 
 	for (i = 0; i < ARRAY_SIZE(mc_algs); i++) {
 		switch (mc_algs[i].type) {
 		case CRYPTO_ALG_TYPE_SKCIPHER:
 			seq_printf(seq, "%s %s %lu %lu\n",
-				   mc_algs[i].alg.skcipher.base.cra_driver_name,
-				   mc_algs[i].alg.skcipher.base.cra_name,
+				   mc_algs[i].alg.skcipher.base.base.cra_driver_name,
+				   mc_algs[i].alg.skcipher.base.base.cra_name,
+#ifdef CONFIG_CRYPTO_DEV_AMLOGIC_GXL_DEBUG
 				   mc_algs[i].stat_req, mc_algs[i].stat_fb);
+#else
+				   0ul, 0ul);
+#endif
 			break;
 		}
 	}
 	return 0;
 }
 DEFINE_SHOW_ATTRIBUTE(meson_debugfs);
-#endif
 
 static void meson_free_chanlist(struct meson_dev *mc, int i)
 {
@@ -183,10 +199,10 @@ static int meson_register_algs(struct meson_dev *mc)
 		mc_algs[i].mc = mc;
 		switch (mc_algs[i].type) {
 		case CRYPTO_ALG_TYPE_SKCIPHER:
-			err = crypto_register_skcipher(&mc_algs[i].alg.skcipher);
+			err = crypto_engine_register_skcipher(&mc_algs[i].alg.skcipher);
 			if (err) {
 				dev_err(mc->dev, "Fail to register %s\n",
-					mc_algs[i].alg.skcipher.base.cra_name);
+					mc_algs[i].alg.skcipher.base.base.cra_name);
 				mc_algs[i].mc = NULL;
 				return err;
 			}
@@ -206,7 +222,7 @@ static void meson_unregister_algs(struct meson_dev *mc)
 			continue;
 		switch (mc_algs[i].type) {
 		case CRYPTO_ALG_TYPE_SKCIPHER:
-			crypto_unregister_skcipher(&mc_algs[i].alg.skcipher);
+			crypto_engine_unregister_skcipher(&mc_algs[i].alg.skcipher);
 			break;
 		}
 	}
@@ -264,10 +280,16 @@ static int meson_crypto_probe(struct platform_device *pdev)
 	if (err)
 		goto error_alg;
 
+	if (IS_ENABLED(CONFIG_CRYPTO_DEV_AMLOGIC_GXL_DEBUG)) {
+		struct dentry *dbgfs_dir;
+
+		dbgfs_dir = debugfs_create_dir("gxl-crypto", NULL);
+		debugfs_create_file("stats", 0444, dbgfs_dir, mc, &meson_debugfs_fops);
+
 #ifdef CONFIG_CRYPTO_DEV_AMLOGIC_GXL_DEBUG
-	mc->dbgfs_dir = debugfs_create_dir("gxl-crypto", NULL);
-	debugfs_create_file("stats", 0444, mc->dbgfs_dir, mc, &meson_debugfs_fops);
+		mc->dbgfs_dir = dbgfs_dir;
 #endif
+	}
 
 	return 0;
 error_alg:
diff --git a/drivers/crypto/amlogic/amlogic-gxl.h b/drivers/crypto/amlogic/amlogic-gxl.h
index 8c0746a1d6d4..1013a666c932 100644
--- a/drivers/crypto/amlogic/amlogic-gxl.h
+++ b/drivers/crypto/amlogic/amlogic-gxl.h
@@ -114,7 +114,6 @@ struct meson_cipher_req_ctx {
 
 /*
  * struct meson_cipher_tfm_ctx - context for a skcipher TFM
- * @enginectx:		crypto_engine used by this TFM
  * @key:		pointer to key data
  * @keylen:		len of the key
  * @keymode:		The keymode(type and size of key) associated with this TFM
@@ -122,7 +121,6 @@ struct meson_cipher_req_ctx {
  * @fallback_tfm:	pointer to the fallback TFM
  */
 struct meson_cipher_tfm_ctx {
-	struct crypto_engine_ctx enginectx;
 	u32 *key;
 	u32 keylen;
 	u32 keymode;
@@ -143,7 +141,7 @@ struct meson_alg_template {
 	u32 type;
 	u32 blockmode;
 	union {
-		struct skcipher_alg skcipher;
+		struct skcipher_engine_alg skcipher;
 	} alg;
 	struct meson_dev *mc;
 #ifdef CONFIG_CRYPTO_DEV_AMLOGIC_GXL_DEBUG
@@ -160,3 +158,4 @@ int meson_cipher_init(struct crypto_tfm *tfm);
 void meson_cipher_exit(struct crypto_tfm *tfm);
 int meson_skdecrypt(struct skcipher_request *areq);
 int meson_skencrypt(struct skcipher_request *areq);
+int meson_handle_cipher_request(struct crypto_engine *engine, void *areq);
