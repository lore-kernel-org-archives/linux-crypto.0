Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06A29C04A94
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Aug 2023 09:31:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231760AbjHKJbA (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Aug 2023 05:31:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235022AbjHKJam (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Aug 2023 05:30:42 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64C1330DC
        for <linux-crypto@vger.kernel.org>; Fri, 11 Aug 2023 02:30:41 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qUOTc-0020ip-Gy; Fri, 11 Aug 2023 17:30:37 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 11 Aug 2023 17:30:36 +0800
From:   "Herbert Xu" <herbert@gondor.apana.org.au>
Date:   Fri, 11 Aug 2023 17:30:36 +0800
Subject: [PATCH 28/36] crypto: sl3516 - Use new crypto_engine_op interface
References: <ZNX/BwEkV3SDpsAS@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Gaurav Jain <gaurav.jain@nxp.com>
Message-Id: <E1qUOTc-0020ip-Gy@formenos.hmeau.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Use the new crypto_engine_op interface where the callback is stored
in the algorithm object.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/crypto/gemini/sl3516-ce-cipher.c |   20 ++++++------
 drivers/crypto/gemini/sl3516-ce-core.c   |   49 ++++++++++++++++++-------------
 drivers/crypto/gemini/sl3516-ce.h        |    8 +----
 3 files changed, 43 insertions(+), 34 deletions(-)

diff --git a/drivers/crypto/gemini/sl3516-ce-cipher.c b/drivers/crypto/gemini/sl3516-ce-cipher.c
index 0232f847785a..49dce9e0a834 100644
--- a/drivers/crypto/gemini/sl3516-ce-cipher.c
+++ b/drivers/crypto/gemini/sl3516-ce-cipher.c
@@ -8,13 +8,17 @@
  * ECB mode.
  */
 
-#include <linux/crypto.h>
+#include <crypto/engine.h>
+#include <crypto/internal/skcipher.h>
+#include <crypto/scatterwalk.h>
 #include <linux/dma-mapping.h>
 #include <linux/delay.h>
+#include <linux/err.h>
 #include <linux/io.h>
+#include <linux/kernel.h>
 #include <linux/pm_runtime.h>
-#include <crypto/scatterwalk.h>
-#include <crypto/internal/skcipher.h>
+#include <linux/slab.h>
+#include <linux/string.h>
 #include "sl3516-ce.h"
 
 /* sl3516_ce_need_fallback - check if a request can be handled by the CE */
@@ -105,7 +109,7 @@ static int sl3516_ce_cipher_fallback(struct skcipher_request *areq)
 	struct sl3516_ce_alg_template *algt;
 	int err;
 
-	algt = container_of(alg, struct sl3516_ce_alg_template, alg.skcipher);
+	algt = container_of(alg, struct sl3516_ce_alg_template, alg.skcipher.base);
 	algt->stat_fb++;
 
 	skcipher_request_set_tfm(&rctx->fallback_req, op->fallback_tfm);
@@ -136,7 +140,7 @@ static int sl3516_ce_cipher(struct skcipher_request *areq)
 	int err = 0;
 	int i;
 
-	algt = container_of(alg, struct sl3516_ce_alg_template, alg.skcipher);
+	algt = container_of(alg, struct sl3516_ce_alg_template, alg.skcipher.base);
 
 	dev_dbg(ce->dev, "%s %s %u %x IV(%p %u) key=%u\n", __func__,
 		crypto_tfm_alg_name(areq->base.tfm),
@@ -258,7 +262,7 @@ static int sl3516_ce_cipher(struct skcipher_request *areq)
 	return err;
 }
 
-static int sl3516_ce_handle_cipher_request(struct crypto_engine *engine, void *areq)
+int sl3516_ce_handle_cipher_request(struct crypto_engine *engine, void *areq)
 {
 	int err;
 	struct skcipher_request *breq = container_of(areq, struct skcipher_request, base);
@@ -318,7 +322,7 @@ int sl3516_ce_cipher_init(struct crypto_tfm *tfm)
 
 	memset(op, 0, sizeof(struct sl3516_ce_cipher_tfm_ctx));
 
-	algt = container_of(alg, struct sl3516_ce_alg_template, alg.skcipher);
+	algt = container_of(alg, struct sl3516_ce_alg_template, alg.skcipher.base);
 	op->ce = algt->ce;
 
 	op->fallback_tfm = crypto_alloc_skcipher(name, 0, CRYPTO_ALG_NEED_FALLBACK);
@@ -335,8 +339,6 @@ int sl3516_ce_cipher_init(struct crypto_tfm *tfm)
 		 crypto_tfm_alg_driver_name(&sktfm->base),
 		 crypto_tfm_alg_driver_name(crypto_skcipher_tfm(op->fallback_tfm)));
 
-	op->enginectx.op.do_one_request = sl3516_ce_handle_cipher_request;
-
 	err = pm_runtime_get_sync(op->ce->dev);
 	if (err < 0)
 		goto error_pm;
diff --git a/drivers/crypto/gemini/sl3516-ce-core.c b/drivers/crypto/gemini/sl3516-ce-core.c
index b7524b649068..0fd47ab9df5c 100644
--- a/drivers/crypto/gemini/sl3516-ce-core.c
+++ b/drivers/crypto/gemini/sl3516-ce-core.c
@@ -6,22 +6,25 @@
  *
  * Core file which registers crypto algorithms supported by the CryptoEngine
  */
+
+#include <crypto/engine.h>
+#include <crypto/internal/rng.h>
+#include <crypto/internal/skcipher.h>
 #include <linux/clk.h>
-#include <linux/crypto.h>
 #include <linux/debugfs.h>
 #include <linux/dev_printk.h>
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
 
 #include "sl3516-ce.h"
 
@@ -217,7 +220,7 @@ static struct sl3516_ce_alg_template ce_algs[] = {
 {
 	.type = CRYPTO_ALG_TYPE_SKCIPHER,
 	.mode = ECB_AES,
-	.alg.skcipher = {
+	.alg.skcipher.base = {
 		.base = {
 			.cra_name = "ecb(aes)",
 			.cra_driver_name = "ecb-aes-sl3516",
@@ -236,11 +239,13 @@ static struct sl3516_ce_alg_template ce_algs[] = {
 		.setkey		= sl3516_ce_aes_setkey,
 		.encrypt	= sl3516_ce_skencrypt,
 		.decrypt	= sl3516_ce_skdecrypt,
-	}
+	},
+	.alg.skcipher.op = {
+		.do_one_request = sl3516_ce_handle_cipher_request,
+	},
 },
 };
 
-#ifdef CONFIG_CRYPTO_DEV_SL3516_DEBUG
 static int sl3516_ce_debugfs_show(struct seq_file *seq, void *v)
 {
 	struct sl3516_ce_dev *ce = seq->private;
@@ -264,8 +269,8 @@ static int sl3516_ce_debugfs_show(struct seq_file *seq, void *v)
 		switch (ce_algs[i].type) {
 		case CRYPTO_ALG_TYPE_SKCIPHER:
 			seq_printf(seq, "%s %s reqs=%lu fallback=%lu\n",
-				   ce_algs[i].alg.skcipher.base.cra_driver_name,
-				   ce_algs[i].alg.skcipher.base.cra_name,
+				   ce_algs[i].alg.skcipher.base.base.cra_driver_name,
+				   ce_algs[i].alg.skcipher.base.base.cra_name,
 				   ce_algs[i].stat_req, ce_algs[i].stat_fb);
 			break;
 		}
@@ -274,7 +279,6 @@ static int sl3516_ce_debugfs_show(struct seq_file *seq, void *v)
 }
 
 DEFINE_SHOW_ATTRIBUTE(sl3516_ce_debugfs);
-#endif
 
 static int sl3516_ce_register_algs(struct sl3516_ce_dev *ce)
 {
@@ -286,11 +290,11 @@ static int sl3516_ce_register_algs(struct sl3516_ce_dev *ce)
 		switch (ce_algs[i].type) {
 		case CRYPTO_ALG_TYPE_SKCIPHER:
 			dev_info(ce->dev, "DEBUG: Register %s\n",
-				 ce_algs[i].alg.skcipher.base.cra_name);
-			err = crypto_register_skcipher(&ce_algs[i].alg.skcipher);
+				 ce_algs[i].alg.skcipher.base.base.cra_name);
+			err = crypto_engine_register_skcipher(&ce_algs[i].alg.skcipher);
 			if (err) {
 				dev_err(ce->dev, "Fail to register %s\n",
-					ce_algs[i].alg.skcipher.base.cra_name);
+					ce_algs[i].alg.skcipher.base.base.cra_name);
 				ce_algs[i].ce = NULL;
 				return err;
 			}
@@ -313,8 +317,8 @@ static void sl3516_ce_unregister_algs(struct sl3516_ce_dev *ce)
 		switch (ce_algs[i].type) {
 		case CRYPTO_ALG_TYPE_SKCIPHER:
 			dev_info(ce->dev, "Unregister %d %s\n", i,
-				 ce_algs[i].alg.skcipher.base.cra_name);
-			crypto_unregister_skcipher(&ce_algs[i].alg.skcipher);
+				 ce_algs[i].alg.skcipher.base.base.cra_name);
+			crypto_engine_unregister_skcipher(&ce_algs[i].alg.skcipher);
 			break;
 		}
 	}
@@ -473,13 +477,20 @@ static int sl3516_ce_probe(struct platform_device *pdev)
 
 	pm_runtime_put_sync(ce->dev);
 
+	if (IS_ENABLED(CONFIG_CRYPTO_DEV_SL3516_DEBUG)) {
+		struct dentry *dbgfs_dir __maybe_unused;
+		struct dentry *dbgfs_stats __maybe_unused;
+
+		/* Ignore error of debugfs */
+		dbgfs_dir = debugfs_create_dir("sl3516", NULL);
+		dbgfs_stats = debugfs_create_file("stats", 0444,
+						  dbgfs_dir, ce,
+						  &sl3516_ce_debugfs_fops);
 #ifdef CONFIG_CRYPTO_DEV_SL3516_DEBUG
-	/* Ignore error of debugfs */
-	ce->dbgfs_dir = debugfs_create_dir("sl3516", NULL);
-	ce->dbgfs_stats = debugfs_create_file("stats", 0444,
-					      ce->dbgfs_dir, ce,
-					      &sl3516_ce_debugfs_fops);
+		ce->dbgfs_dir = dbgfs_dir;
+		ce->dbgfs_stats = dbgfs_stats;
 #endif
+	}
 
 	return 0;
 error_pmuse:
diff --git a/drivers/crypto/gemini/sl3516-ce.h b/drivers/crypto/gemini/sl3516-ce.h
index 4c0ec6c920d1..9e1a7e7f8961 100644
--- a/drivers/crypto/gemini/sl3516-ce.h
+++ b/drivers/crypto/gemini/sl3516-ce.h
@@ -17,7 +17,6 @@
 #include <crypto/engine.h>
 #include <crypto/scatterwalk.h>
 #include <crypto/skcipher.h>
-#include <linux/crypto.h>
 #include <linux/debugfs.h>
 #include <linux/hw_random.h>
 
@@ -292,16 +291,12 @@ struct sl3516_ce_cipher_req_ctx {
 
 /*
  * struct sl3516_ce_cipher_tfm_ctx - context for a skcipher TFM
- * @enginectx:		crypto_engine used by this TFM
  * @key:		pointer to key data
  * @keylen:		len of the key
  * @ce:			pointer to the private data of driver handling this TFM
  * @fallback_tfm:	pointer to the fallback TFM
- *
- * enginectx must be the first element
  */
 struct sl3516_ce_cipher_tfm_ctx {
-	struct crypto_engine_ctx enginectx;
 	u32 *key;
 	u32 keylen;
 	struct sl3516_ce_dev *ce;
@@ -324,7 +319,7 @@ struct sl3516_ce_alg_template {
 	u32 mode;
 	struct sl3516_ce_dev *ce;
 	union {
-		struct skcipher_alg skcipher;
+		struct skcipher_engine_alg skcipher;
 	} alg;
 	unsigned long stat_req;
 	unsigned long stat_fb;
@@ -345,3 +340,4 @@ int sl3516_ce_run_task(struct sl3516_ce_dev *ce,
 
 int sl3516_ce_rng_register(struct sl3516_ce_dev *ce);
 void sl3516_ce_rng_unregister(struct sl3516_ce_dev *ce);
+int sl3516_ce_handle_cipher_request(struct crypto_engine *engine, void *areq);
