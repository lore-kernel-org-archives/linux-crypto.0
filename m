Return-Path: <SRS0=5M5o=S3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE2ABC4321A
	for <linux-crypto@archiver.kernel.org>; Thu, 25 Apr 2019 16:25:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 309FC2077C
	for <linux-crypto@archiver.kernel.org>; Thu, 25 Apr 2019 16:25:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729798AbfDYQZU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 25 Apr 2019 12:25:20 -0400
Received: from inva020.nxp.com ([92.121.34.13]:33002 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729151AbfDYQZT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 25 Apr 2019 12:25:19 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id D88C21A006E;
        Thu, 25 Apr 2019 18:25:17 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id CB6751A0012;
        Thu, 25 Apr 2019 18:25:17 +0200 (CEST)
Received: from fsr-ub1864-014.ea.freescale.net (fsr-ub1864-014.ea.freescale.net [10.171.95.219])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 5CD6F2061F;
        Thu, 25 Apr 2019 18:25:17 +0200 (CEST)
From:   =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Vakul Garg <vakul.garg@nxp.com>,
        Franck Lenormand <franck.lenormand@nxp.com>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        Marcin Niestroj <m.niestroj@grinn-global.com>,
        linux-crypto@vger.kernel.org, NXP Linux Team <linux-imx@nxp.com>
Subject: [PATCH 4/7] crypto: caam/qi - don't allocate an extra platform device
Date:   Thu, 25 Apr 2019 19:24:58 +0300
Message-Id: <20190425162501.4565-5-horia.geanta@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190425162501.4565-1-horia.geanta@nxp.com>
References: <20190425162501.4565-1-horia.geanta@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Use the controller device for caam/qi instead of allocating
a new platform device.
This is needed as a preparation to add support for working behind an
SMMU. A platform device allocated using platform_device_register_full()
is not completely set up - most importantly .dma_configure()
is not called.

Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
---
 drivers/crypto/caam/caamalg_qi.c |  6 +++---
 drivers/crypto/caam/ctrl.c       |  8 ++++----
 drivers/crypto/caam/intern.h     |  7 +++----
 drivers/crypto/caam/qi.c         | 33 +++++---------------------------
 4 files changed, 15 insertions(+), 39 deletions(-)

diff --git a/drivers/crypto/caam/caamalg_qi.c b/drivers/crypto/caam/caamalg_qi.c
index b2e29be79d41..fd38200dbc1c 100644
--- a/drivers/crypto/caam/caamalg_qi.c
+++ b/drivers/crypto/caam/caamalg_qi.c
@@ -2439,7 +2439,7 @@ static int caam_init_common(struct caam_ctx *ctx, struct caam_alg_entry *caam,
 	ctx->cdata.algtype = OP_TYPE_CLASS1_ALG | caam->class1_alg_type;
 	ctx->adata.algtype = OP_TYPE_CLASS2_ALG | caam->class2_alg_type;
 
-	ctx->qidev = priv->qidev;
+	ctx->qidev = ctx->jrdev->parent;
 
 	spin_lock_init(&ctx->lock);
 	ctx->drv_ctx[ENCRYPT] = NULL;
@@ -2599,7 +2599,7 @@ int caam_qi_algapi_init(struct device *ctrldev)
 
 		err = crypto_register_skcipher(&t_alg->skcipher);
 		if (err) {
-			dev_warn(priv->qidev, "%s alg registration failed\n",
+			dev_warn(ctrldev, "%s alg registration failed\n",
 				 t_alg->skcipher.base.cra_driver_name);
 			continue;
 		}
@@ -2655,7 +2655,7 @@ int caam_qi_algapi_init(struct device *ctrldev)
 	}
 
 	if (registered)
-		dev_info(priv->qidev, "algorithms registered in /proc/crypto\n");
+		dev_info(ctrldev, "algorithms registered in /proc/crypto\n");
 
 	return err;
 }
diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index 36c2f15100a4..38bcbbccdfda 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -323,8 +323,8 @@ static int caam_remove(struct platform_device *pdev)
 	of_platform_depopulate(ctrldev);
 
 #ifdef CONFIG_CAAM_QI
-	if (ctrlpriv->qidev)
-		caam_qi_shutdown(ctrlpriv->qidev);
+	if (ctrlpriv->qi_init)
+		caam_qi_shutdown(ctrldev);
 #endif
 
 	/*
@@ -900,8 +900,8 @@ static int caam_probe(struct platform_device *pdev)
 
 shutdown_qi:
 #ifdef CONFIG_CAAM_QI
-	if (ctrlpriv->qidev)
-		caam_qi_shutdown(ctrlpriv->qidev);
+	if (ctrlpriv->qi_init)
+		caam_qi_shutdown(dev);
 #endif
 iounmap_ctrl:
 	iounmap(ctrl);
diff --git a/drivers/crypto/caam/intern.h b/drivers/crypto/caam/intern.h
index 50e24ebc533b..c9089da5dbaf 100644
--- a/drivers/crypto/caam/intern.h
+++ b/drivers/crypto/caam/intern.h
@@ -63,10 +63,6 @@ struct caam_drv_private_jr {
  * Driver-private storage for a single CAAM block instance
  */
 struct caam_drv_private {
-#ifdef CONFIG_CAAM_QI
-	struct device *qidev;
-#endif
-
 	/* Physical-presence section */
 	struct caam_ctrl __iomem *ctrl; /* controller region */
 	struct caam_deco __iomem *deco; /* DECO/CCB views */
@@ -80,6 +76,9 @@ struct caam_drv_private {
 	 */
 	u8 total_jobrs;		/* Total Job Rings in device */
 	u8 qi_present;		/* Nonzero if QI present in device */
+#ifdef CONFIG_CAAM_QI
+	u8 qi_init;		/* Nonzero if QI has been initialized */
+#endif
 	u8 mc_en;		/* Nonzero if MC f/w is active */
 	int secvio_irq;		/* Security violation interrupt number */
 	int virt_en;		/* Virtualization enabled in CAAM */
diff --git a/drivers/crypto/caam/qi.c b/drivers/crypto/caam/qi.c
index 2d9b0485141f..46fca2c9fb24 100644
--- a/drivers/crypto/caam/qi.c
+++ b/drivers/crypto/caam/qi.c
@@ -4,7 +4,7 @@
  * Queue Interface backend functionality
  *
  * Copyright 2013-2016 Freescale Semiconductor, Inc.
- * Copyright 2016-2017 NXP
+ * Copyright 2016-2017, 2019 NXP
  */
 
 #include <linux/cpumask.h>
@@ -59,11 +59,9 @@ static DEFINE_PER_CPU(int, last_cpu);
 /*
  * caam_qi_priv - CAAM QI backend private params
  * @cgr: QMan congestion group
- * @qi_pdev: platform device for QI backend
  */
 struct caam_qi_priv {
 	struct qman_cgr cgr;
-	struct platform_device *qi_pdev;
 };
 
 static struct caam_qi_priv qipriv ____cacheline_aligned;
@@ -491,7 +489,7 @@ EXPORT_SYMBOL(caam_drv_ctx_rel);
 void caam_qi_shutdown(struct device *qidev)
 {
 	int i;
-	struct caam_qi_priv *priv = dev_get_drvdata(qidev);
+	struct caam_qi_priv *priv = &qipriv;
 	const cpumask_t *cpus = qman_affine_cpus();
 
 	for_each_cpu(i, cpus) {
@@ -509,8 +507,6 @@ void caam_qi_shutdown(struct device *qidev)
 	qman_release_cgrid(priv->cgr.cgrid);
 
 	kmem_cache_destroy(qi_cache);
-
-	platform_device_unregister(priv->qi_pdev);
 }
 
 static void cgr_cb(struct qman_portal *qm, struct qman_cgr *cgr, int congested)
@@ -695,33 +691,17 @@ static void free_rsp_fqs(void)
 int caam_qi_init(struct platform_device *caam_pdev)
 {
 	int err, i;
-	struct platform_device *qi_pdev;
 	struct device *ctrldev = &caam_pdev->dev, *qidev;
 	struct caam_drv_private *ctrlpriv;
 	const cpumask_t *cpus = qman_affine_cpus();
-	static struct platform_device_info qi_pdev_info = {
-		.name = "caam_qi",
-		.id = PLATFORM_DEVID_NONE
-	};
-
-	qi_pdev_info.parent = ctrldev;
-	qi_pdev_info.dma_mask = dma_get_mask(ctrldev);
-	qi_pdev = platform_device_register_full(&qi_pdev_info);
-	if (IS_ERR(qi_pdev))
-		return PTR_ERR(qi_pdev);
-	set_dma_ops(&qi_pdev->dev, get_dma_ops(ctrldev));
 
 	ctrlpriv = dev_get_drvdata(ctrldev);
-	qidev = &qi_pdev->dev;
-
-	qipriv.qi_pdev = qi_pdev;
-	dev_set_drvdata(qidev, &qipriv);
+	qidev = ctrldev;
 
 	/* Initialize the congestion detection */
 	err = init_cgr(qidev);
 	if (err) {
 		dev_err(qidev, "CGR initialization failed: %d\n", err);
-		platform_device_unregister(qi_pdev);
 		return err;
 	}
 
@@ -730,7 +710,6 @@ int caam_qi_init(struct platform_device *caam_pdev)
 	if (err) {
 		dev_err(qidev, "Can't allocate CAAM response FQs: %d\n", err);
 		free_rsp_fqs();
-		platform_device_unregister(qi_pdev);
 		return err;
 	}
 
@@ -753,15 +732,11 @@ int caam_qi_init(struct platform_device *caam_pdev)
 		napi_enable(irqtask);
 	}
 
-	/* Hook up QI device to parent controlling caam device */
-	ctrlpriv->qidev = qidev;
-
 	qi_cache = kmem_cache_create("caamqicache", CAAM_QI_MEMCACHE_SIZE, 0,
 				     SLAB_CACHE_DMA, NULL);
 	if (!qi_cache) {
 		dev_err(qidev, "Can't allocate CAAM cache\n");
 		free_rsp_fqs();
-		platform_device_unregister(qi_pdev);
 		return -ENOMEM;
 	}
 
@@ -769,6 +744,8 @@ int caam_qi_init(struct platform_device *caam_pdev)
 	debugfs_create_file("qi_congested", 0444, ctrlpriv->ctl,
 			    &times_congested, &caam_fops_u64_ro);
 #endif
+
+	ctrlpriv->qi_init = 1;
 	dev_info(qidev, "Linux CAAM Queue I/F driver initialised\n");
 	return 0;
 }
-- 
2.17.1

