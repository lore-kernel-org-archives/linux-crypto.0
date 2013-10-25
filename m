From: Ruchika Gupta <ruchika.gupta@freescale.com>
Subject: [PATCH 3/3] crypto: caam - Modify the interface layers to use JR API's
Date: Fri, 25 Oct 2013 12:01:03 +0530
Message-ID: <1382682663-18651-3-git-send-email-ruchika.gupta@freescale.com>
References: <1382682663-18651-1-git-send-email-ruchika.gupta@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <herbert@gondor.hengli.com.au>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:48157 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751349Ab3JYGgS (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 25 Oct 2013 02:36:18 -0400
In-Reply-To: <1382682663-18651-1-git-send-email-ruchika.gupta@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

- Earlier interface layers - caamalg, caamhash, caamrng were
  directly using the Controller driver private structure to access
  the Job ring.
- Changed the above to use alloc/free API's provided by Job Ring Drive

Signed-off-by: Ruchika Gupta <ruchika.gupta@freescale.com>
Reviewed-by: Garg Vakul-B16394 <vakul@freescale.com>
---
 drivers/crypto/caam/caamalg.c  | 92 +++++++++------------------------------
 drivers/crypto/caam/caamhash.c | 97 +++++++++++-------------------------------
 drivers/crypto/caam/caamrng.c  | 37 ++++------------
 drivers/crypto/caam/intern.h   |  7 ---
 4 files changed, 55 insertions(+), 178 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index ad9781e..4f44b71 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -86,6 +86,7 @@
 #else
 #define debug(format, arg...)
 #endif
+static struct list_head alg_list;
 
 /* Set DK bit in class 1 operation if shared */
 static inline void append_dec_op1(u32 *desc, u32 type)
@@ -2057,7 +2058,6 @@ static struct caam_alg_template driver_algs[] = {
 
 struct caam_crypto_alg {
 	struct list_head entry;
-	struct device *ctrldev;
 	int class1_alg_type;
 	int class2_alg_type;
 	int alg_op;
@@ -2070,16 +2070,12 @@ static int caam_cra_init(struct crypto_tfm *tfm)
 	struct caam_crypto_alg *caam_alg =
 		 container_of(alg, struct caam_crypto_alg, crypto_alg);
 	struct caam_ctx *ctx = crypto_tfm_ctx(tfm);
-	struct caam_drv_private *priv = dev_get_drvdata(caam_alg->ctrldev);
-	struct platform_device *pdev;
-	int tgt_jr = atomic_inc_return(&priv->tfm_count);
 
-	/*
-	 * distribute tfms across job rings to ensure in-order
-	 * crypto request processing per tfm
-	 */
-	pdev = priv->jrpdev[(tgt_jr / 2) % priv->total_jobrs];
-	ctx->jrdev = &pdev->dev;
+	ctx->jrdev = caam_jr_alloc();
+	if (IS_ERR(ctx->jrdev)) {
+		pr_err("Job Ring Device allocation for transform failed\n");
+		return PTR_ERR(ctx->jrdev);
+	}
 
 	/* copy descriptor header template value */
 	ctx->class1_alg_type = OP_TYPE_CLASS1_ALG | caam_alg->class1_alg_type;
@@ -2106,44 +2102,26 @@ static void caam_cra_exit(struct crypto_tfm *tfm)
 		dma_unmap_single(ctx->jrdev, ctx->sh_desc_givenc_dma,
 				 desc_bytes(ctx->sh_desc_givenc),
 				 DMA_TO_DEVICE);
+
+	caam_jr_free(ctx->jrdev);
 }
 
 static void __exit caam_algapi_exit(void)
 {
 
-	struct device_node *dev_node;
-	struct platform_device *pdev;
-	struct device *ctrldev;
-	struct caam_drv_private *priv;
 	struct caam_crypto_alg *t_alg, *n;
 
-	dev_node = of_find_compatible_node(NULL, NULL, "fsl,sec-v4.0");
-	if (!dev_node) {
-		dev_node = of_find_compatible_node(NULL, NULL, "fsl,sec4.0");
-		if (!dev_node)
-			return;
-	}
-
-	pdev = of_find_device_by_node(dev_node);
-	if (!pdev)
-		return;
-
-	ctrldev = &pdev->dev;
-	of_node_put(dev_node);
-	priv = dev_get_drvdata(ctrldev);
-
-	if (!priv->alg_list.next)
+	if (!alg_list.next)
 		return;
 
-	list_for_each_entry_safe(t_alg, n, &priv->alg_list, entry) {
+	list_for_each_entry_safe(t_alg, n, &alg_list, entry) {
 		crypto_unregister_alg(&t_alg->crypto_alg);
 		list_del(&t_alg->entry);
 		kfree(t_alg);
 	}
 }
 
-static struct caam_crypto_alg *caam_alg_alloc(struct device *ctrldev,
-					      struct caam_alg_template
+static struct caam_crypto_alg *caam_alg_alloc(struct caam_alg_template
 					      *template)
 {
 	struct caam_crypto_alg *t_alg;
@@ -2151,7 +2129,7 @@ static struct caam_crypto_alg *caam_alg_alloc(struct device *ctrldev,
 
 	t_alg = kzalloc(sizeof(struct caam_crypto_alg), GFP_KERNEL);
 	if (!t_alg) {
-		dev_err(ctrldev, "failed to allocate t_alg\n");
+		pr_err("failed to allocate t_alg\n");
 		return ERR_PTR(-ENOMEM);
 	}
 
@@ -2183,69 +2161,39 @@ static struct caam_crypto_alg *caam_alg_alloc(struct device *ctrldev,
 	t_alg->class1_alg_type = template->class1_alg_type;
 	t_alg->class2_alg_type = template->class2_alg_type;
 	t_alg->alg_op = template->alg_op;
-	t_alg->ctrldev = ctrldev;
 
 	return t_alg;
 }
 
 static int __init caam_algapi_init(void)
 {
-	struct device_node *dev_node;
-	struct platform_device *pdev;
-	struct device *ctrldev;
-	struct caam_drv_private *priv;
 	int i = 0, err = 0;
 
-	dev_node = of_find_compatible_node(NULL, NULL, "fsl,sec-v4.0");
-	if (!dev_node) {
-		dev_node = of_find_compatible_node(NULL, NULL, "fsl,sec4.0");
-		if (!dev_node)
-			return -ENODEV;
-	}
-
-	pdev = of_find_device_by_node(dev_node);
-	if (!pdev)
-		return -ENODEV;
-
-	ctrldev = &pdev->dev;
-	priv = dev_get_drvdata(ctrldev);
-	of_node_put(dev_node);
-
-	/*
-	 * If priv is NULL, it's probably because the caam driver wasn't
-	 * properly initialized (e.g. RNG4 init failed). Thus, bail out here.
-	 */
-	if (!priv)
-		return -ENODEV;
-
-	INIT_LIST_HEAD(&priv->alg_list);
-
-	atomic_set(&priv->tfm_count, -1);
+	INIT_LIST_HEAD(&alg_list);
 
 	/* register crypto algorithms the device supports */
 	for (i = 0; i < ARRAY_SIZE(driver_algs); i++) {
 		/* TODO: check if h/w supports alg */
 		struct caam_crypto_alg *t_alg;
 
-		t_alg = caam_alg_alloc(ctrldev, &driver_algs[i]);
+		t_alg = caam_alg_alloc(&driver_algs[i]);
 		if (IS_ERR(t_alg)) {
 			err = PTR_ERR(t_alg);
-			dev_warn(ctrldev, "%s alg allocation failed\n",
-				 driver_algs[i].driver_name);
+			pr_warn("%s alg allocation failed\n",
+				driver_algs[i].driver_name);
 			continue;
 		}
 
 		err = crypto_register_alg(&t_alg->crypto_alg);
 		if (err) {
-			dev_warn(ctrldev, "%s alg registration failed\n",
+			pr_warn("%s alg registration failed\n",
 				t_alg->crypto_alg.cra_driver_name);
 			kfree(t_alg);
 		} else
-			list_add_tail(&t_alg->entry, &priv->alg_list);
+			list_add_tail(&t_alg->entry, &alg_list);
 	}
-	if (!list_empty(&priv->alg_list))
-		dev_info(ctrldev, "%s algorithms registered in /proc/crypto\n",
-			 (char *)of_get_property(dev_node, "compatible", NULL));
+	if (!list_empty(&alg_list))
+		pr_info("caam algorithms registered in /proc/crypto\n");
 
 	return err;
 }
diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index 91a9354..0378328 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -94,6 +94,9 @@
 #define debug(format, arg...)
 #endif
 
+
+static struct list_head hash_list;
+
 /* ahash per-session context */
 struct caam_hash_ctx {
 	struct device *jrdev;
@@ -1653,7 +1656,6 @@ static struct caam_hash_template driver_hash[] = {
 
 struct caam_hash_alg {
 	struct list_head entry;
-	struct device *ctrldev;
 	int alg_type;
 	int alg_op;
 	struct ahash_alg ahash_alg;
@@ -1670,7 +1672,6 @@ static int caam_hash_cra_init(struct crypto_tfm *tfm)
 	struct caam_hash_alg *caam_hash =
 		 container_of(alg, struct caam_hash_alg, ahash_alg);
 	struct caam_hash_ctx *ctx = crypto_tfm_ctx(tfm);
-	struct caam_drv_private *priv = dev_get_drvdata(caam_hash->ctrldev);
 	/* Sizes for MDHA running digests: MD5, SHA1, 224, 256, 384, 512 */
 	static const u8 runninglen[] = { HASH_MSG_LEN + MD5_DIGEST_SIZE,
 					 HASH_MSG_LEN + SHA1_DIGEST_SIZE,
@@ -1678,17 +1679,17 @@ static int caam_hash_cra_init(struct crypto_tfm *tfm)
 					 HASH_MSG_LEN + SHA256_DIGEST_SIZE,
 					 HASH_MSG_LEN + 64,
 					 HASH_MSG_LEN + SHA512_DIGEST_SIZE };
-	int tgt_jr = atomic_inc_return(&priv->tfm_count);
 	int ret = 0;
-	struct platform_device *pdev;
 
 	/*
-	 * distribute tfms across job rings to ensure in-order
+	 * Get a Job ring from Job Ring driver to ensure in-order
 	 * crypto request processing per tfm
 	 */
-	pdev = priv->jrpdev[tgt_jr % priv->total_jobrs];
-	ctx->jrdev = &pdev->dev;
-
+	ctx->jrdev = caam_jr_alloc();
+	if (IS_ERR(ctx->jrdev)) {
+		pr_err("Job Ring Device allocation for transform failed\n");
+		return PTR_ERR(ctx->jrdev);
+	}
 	/* copy descriptor header template value */
 	ctx->alg_type = OP_TYPE_CLASS2_ALG | caam_hash->alg_type;
 	ctx->alg_op = OP_TYPE_CLASS2_ALG | caam_hash->alg_op;
@@ -1731,35 +1732,18 @@ static void caam_hash_cra_exit(struct crypto_tfm *tfm)
 	    !dma_mapping_error(ctx->jrdev, ctx->sh_desc_finup_dma))
 		dma_unmap_single(ctx->jrdev, ctx->sh_desc_finup_dma,
 				 desc_bytes(ctx->sh_desc_finup), DMA_TO_DEVICE);
+
+	caam_jr_free(ctx->jrdev);
 }
 
 static void __exit caam_algapi_hash_exit(void)
 {
-	struct device_node *dev_node;
-	struct platform_device *pdev;
-	struct device *ctrldev;
-	struct caam_drv_private *priv;
 	struct caam_hash_alg *t_alg, *n;
 
-	dev_node = of_find_compatible_node(NULL, NULL, "fsl,sec-v4.0");
-	if (!dev_node) {
-		dev_node = of_find_compatible_node(NULL, NULL, "fsl,sec4.0");
-		if (!dev_node)
-			return;
-	}
-
-	pdev = of_find_device_by_node(dev_node);
-	if (!pdev)
-		return;
-
-	ctrldev = &pdev->dev;
-	of_node_put(dev_node);
-	priv = dev_get_drvdata(ctrldev);
-
-	if (!priv->hash_list.next)
+	if (!hash_list.next)
 		return;
 
-	list_for_each_entry_safe(t_alg, n, &priv->hash_list, entry) {
+	list_for_each_entry_safe(t_alg, n, &hash_list, entry) {
 		crypto_unregister_ahash(&t_alg->ahash_alg);
 		list_del(&t_alg->entry);
 		kfree(t_alg);
@@ -1767,7 +1751,7 @@ static void __exit caam_algapi_hash_exit(void)
 }
 
 static struct caam_hash_alg *
-caam_hash_alloc(struct device *ctrldev, struct caam_hash_template *template,
+caam_hash_alloc(struct caam_hash_template *template,
 		bool keyed)
 {
 	struct caam_hash_alg *t_alg;
@@ -1776,7 +1760,7 @@ caam_hash_alloc(struct device *ctrldev, struct caam_hash_template *template,
 
 	t_alg = kzalloc(sizeof(struct caam_hash_alg), GFP_KERNEL);
 	if (!t_alg) {
-		dev_err(ctrldev, "failed to allocate t_alg\n");
+		pr_err("failed to allocate t_alg\n");
 		return ERR_PTR(-ENOMEM);
 	}
 
@@ -1807,44 +1791,15 @@ caam_hash_alloc(struct device *ctrldev, struct caam_hash_template *template,
 
 	t_alg->alg_type = template->alg_type;
 	t_alg->alg_op = template->alg_op;
-	t_alg->ctrldev = ctrldev;
 
 	return t_alg;
 }
 
 static int __init caam_algapi_hash_init(void)
 {
-	struct device_node *dev_node;
-	struct platform_device *pdev;
-	struct device *ctrldev;
-	struct caam_drv_private *priv;
 	int i = 0, err = 0;
 
-	dev_node = of_find_compatible_node(NULL, NULL, "fsl,sec-v4.0");
-	if (!dev_node) {
-		dev_node = of_find_compatible_node(NULL, NULL, "fsl,sec4.0");
-		if (!dev_node)
-			return -ENODEV;
-	}
-
-	pdev = of_find_device_by_node(dev_node);
-	if (!pdev)
-		return -ENODEV;
-
-	ctrldev = &pdev->dev;
-	priv = dev_get_drvdata(ctrldev);
-	of_node_put(dev_node);
-
-	/*
-	 * If priv is NULL, it's probably because the caam driver wasn't
-	 * properly initialized (e.g. RNG4 init failed). Thus, bail out here.
-	 */
-	if (!priv)
-		return -ENODEV;
-
-	INIT_LIST_HEAD(&priv->hash_list);
-
-	atomic_set(&priv->tfm_count, -1);
+	INIT_LIST_HEAD(&hash_list);
 
 	/* register crypto algorithms the device supports */
 	for (i = 0; i < ARRAY_SIZE(driver_hash); i++) {
@@ -1852,38 +1807,38 @@ static int __init caam_algapi_hash_init(void)
 		struct caam_hash_alg *t_alg;
 
 		/* register hmac version */
-		t_alg = caam_hash_alloc(ctrldev, &driver_hash[i], true);
+		t_alg = caam_hash_alloc(&driver_hash[i], true);
 		if (IS_ERR(t_alg)) {
 			err = PTR_ERR(t_alg);
-			dev_warn(ctrldev, "%s alg allocation failed\n",
-				 driver_hash[i].driver_name);
+			pr_warn("%s alg allocation failed\n",
+				driver_hash[i].driver_name);
 			continue;
 		}
 
 		err = crypto_register_ahash(&t_alg->ahash_alg);
 		if (err) {
-			dev_warn(ctrldev, "%s alg registration failed\n",
+			pr_warn("%s alg registration failed\n",
 				t_alg->ahash_alg.halg.base.cra_driver_name);
 			kfree(t_alg);
 		} else
-			list_add_tail(&t_alg->entry, &priv->hash_list);
+			list_add_tail(&t_alg->entry, &hash_list);
 
 		/* register unkeyed version */
-		t_alg = caam_hash_alloc(ctrldev, &driver_hash[i], false);
+		t_alg = caam_hash_alloc(&driver_hash[i], false);
 		if (IS_ERR(t_alg)) {
 			err = PTR_ERR(t_alg);
-			dev_warn(ctrldev, "%s alg allocation failed\n",
-				 driver_hash[i].driver_name);
+			pr_warn("%s alg allocation failed\n",
+				driver_hash[i].driver_name);
 			continue;
 		}
 
 		err = crypto_register_ahash(&t_alg->ahash_alg);
 		if (err) {
-			dev_warn(ctrldev, "%s alg registration failed\n",
+			pr_warn("%s alg registration failed\n",
 				t_alg->ahash_alg.halg.base.cra_driver_name);
 			kfree(t_alg);
 		} else
-			list_add_tail(&t_alg->entry, &priv->hash_list);
+			list_add_tail(&t_alg->entry, &hash_list);
 	}
 
 	return err;
diff --git a/drivers/crypto/caam/caamrng.c b/drivers/crypto/caam/caamrng.c
index 4e4ed15..28486b1 100644
--- a/drivers/crypto/caam/caamrng.c
+++ b/drivers/crypto/caam/caamrng.c
@@ -273,42 +273,23 @@ static struct hwrng caam_rng = {
 
 static void __exit caam_rng_exit(void)
 {
+	caam_jr_free(rng_ctx.jrdev);
 	hwrng_unregister(&caam_rng);
 }
 
 static int __init caam_rng_init(void)
 {
-	struct device_node *dev_node;
-	struct platform_device *pdev, *jrpdev;
-	struct device *ctrldev;
-	struct caam_drv_private *priv;
-
-	dev_node = of_find_compatible_node(NULL, NULL, "fsl,sec-v4.0");
-	if (!dev_node) {
-		dev_node = of_find_compatible_node(NULL, NULL, "fsl,sec4.0");
-		if (!dev_node)
-			return -ENODEV;
-	}
-
-	pdev = of_find_device_by_node(dev_node);
-	if (!pdev)
-		return -ENODEV;
+	struct device *dev;
 
-	ctrldev = &pdev->dev;
-	priv = dev_get_drvdata(ctrldev);
-	of_node_put(dev_node);
-
-	/*
-	 * If priv is NULL, it's probably because the caam driver wasn't
-	 * properly initialized (e.g. RNG4 init failed). Thus, bail out here.
-	 */
-	if (!priv)
-		return -ENODEV;
+	dev = caam_jr_alloc();
+	if (IS_ERR(dev)) {
+		pr_err("Job Ring Device allocation for transform failed\n");
+		return PTR_ERR(dev);
+	}
 
-	jrpdev = priv->jrpdev[0];
-	caam_init_rng(&rng_ctx, &jrpdev->dev);
+	caam_init_rng(&rng_ctx, dev);
 
-	dev_info(&jrpdev->dev, "registering rng-caam\n");
+	dev_info(dev, "registering rng-caam\n");
 	return hwrng_register(&caam_rng);
 }
 
diff --git a/drivers/crypto/caam/intern.h b/drivers/crypto/caam/intern.h
index b781445..6d85fcc 100644
--- a/drivers/crypto/caam/intern.h
+++ b/drivers/crypto/caam/intern.h
@@ -83,13 +83,6 @@ struct caam_drv_private {
 	u8 qi_present;		/* Nonzero if QI present in device */
 	int secvio_irq;		/* Security violation interrupt number */
 
-	/* which jr allocated to scatterlist crypto */
-	atomic_t tfm_count ____cacheline_aligned;
-	/* list of registered crypto algorithms (mk generic context handle?) */
-	struct list_head alg_list;
-	/* list of registered hash algorithms (mk generic context handle?) */
-	struct list_head hash_list;
-
 #define	RNG4_MAX_HANDLES 2
 	/* RNG4 block */
 	u32 rng4_sh_init;	/* This bitmap shows which of the State
-- 
1.8.1.4
