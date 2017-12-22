From: Christian Lamparter <chunkeey@gmail.com>
Subject: [PATCH v1 2/4] crypto: crypto4xx - support Revision B parts
Date: Fri, 22 Dec 2017 21:18:36 +0100
Message-ID: <1e932b627e79aa2c70e2c7278e4ac930303faa3f.1513908140.git.chunkeey@gmail.com>
References: <4baa099377d73ea99c7802a9685815b32e8bf119.1513908140.git.chunkeey@gmail.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:44806 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756322AbdLVUSm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Dec 2017 15:18:42 -0500
Received: by mail-wm0-f67.google.com with SMTP id t8so23745722wmc.3
        for <linux-crypto@vger.kernel.org>; Fri, 22 Dec 2017 12:18:41 -0800 (PST)
Received: from debian64.daheim (p5B0D71BC.dip0.t-ipconnect.de. [91.13.113.188])
        by smtp.gmail.com with ESMTPSA id 20sm12661025wms.8.2017.12.22.12.18.39
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 22 Dec 2017 12:18:39 -0800 (PST)
Received: from chuck by debian64.daheim with local (Exim 4.90_RC4)
        (envelope-from <chunkeey@gmail.com>)
        id 1eSTmA-0005jz-IR
        for linux-crypto@vger.kernel.org; Fri, 22 Dec 2017 21:18:38 +0100
In-Reply-To: <4baa099377d73ea99c7802a9685815b32e8bf119.1513908140.git.chunkeey@gmail.com>
In-Reply-To: <4baa099377d73ea99c7802a9685815b32e8bf119.1513908140.git.chunkeey@gmail.com>
References: <4baa099377d73ea99c7802a9685815b32e8bf119.1513908140.git.chunkeey@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch adds support for the crypto4xx RevB cores
found in the 460EX, 460SX and later cores (like the APM821xx).

Without this patch, the crypto4xx driver will not be
able to process any offloaded requests and simply hang
indefinitely.

Signed-off-by: Christian Lamparter <chunkeey@gmail.com>
---
 drivers/crypto/amcc/crypto4xx_core.c    | 48 +++++++++++++++++++++++++++++----
 drivers/crypto/amcc/crypto4xx_core.h    |  1 +
 drivers/crypto/amcc/crypto4xx_reg_def.h |  4 ++-
 3 files changed, 47 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/amcc/crypto4xx_core.c b/drivers/crypto/amcc/crypto4xx_core.c
index 50d5e64fbdbf..fde0136029f1 100644
--- a/drivers/crypto/amcc/crypto4xx_core.c
+++ b/drivers/crypto/amcc/crypto4xx_core.c
@@ -128,7 +128,14 @@ static void crypto4xx_hw_init(struct crypto4xx_device *dev)
 	writel(PPC4XX_INT_DESCR_CNT, dev->ce_base + CRYPTO4XX_INT_DESCR_CNT);
 	writel(PPC4XX_INT_DESCR_CNT, dev->ce_base + CRYPTO4XX_INT_DESCR_CNT);
 	writel(PPC4XX_INT_CFG, dev->ce_base + CRYPTO4XX_INT_CFG);
-	writel(PPC4XX_PD_DONE_INT, dev->ce_base + CRYPTO4XX_INT_EN);
+	if (dev->is_revb) {
+		writel(PPC4XX_INT_TIMEOUT_CNT_REVB << 10,
+		       dev->ce_base + CRYPTO4XX_INT_TIMEOUT_CNT);
+		writel(PPC4XX_PD_DONE_INT | PPC4XX_TMO_ERR_INT,
+		       dev->ce_base + CRYPTO4XX_INT_EN);
+	} else {
+		writel(PPC4XX_PD_DONE_INT, dev->ce_base + CRYPTO4XX_INT_EN);
+	}
 }
 
 int crypto4xx_alloc_sa(struct crypto4xx_ctx *ctx, u32 size)
@@ -1070,18 +1077,29 @@ static void crypto4xx_bh_tasklet_cb(unsigned long data)
 /**
  * Top Half of isr.
  */
-static irqreturn_t crypto4xx_ce_interrupt_handler(int irq, void *data)
+static inline irqreturn_t crypto4xx_interrupt_handler(int irq, void *data,
+						      u32 clr_val)
 {
 	struct device *dev = (struct device *)data;
 	struct crypto4xx_core_device *core_dev = dev_get_drvdata(dev);
 
-	writel(PPC4XX_INTERRUPT_CLR,
-	       core_dev->dev->ce_base + CRYPTO4XX_INT_CLR);
+	writel(clr_val, core_dev->dev->ce_base + CRYPTO4XX_INT_CLR);
 	tasklet_schedule(&core_dev->tasklet);
 
 	return IRQ_HANDLED;
 }
 
+static irqreturn_t crypto4xx_ce_interrupt_handler(int irq, void *data)
+{
+	return crypto4xx_interrupt_handler(irq, data, PPC4XX_INTERRUPT_CLR);
+}
+
+static irqreturn_t crypto4xx_ce_interrupt_handler_revb(int irq, void *data)
+{
+	return crypto4xx_interrupt_handler(irq, data, PPC4XX_INTERRUPT_CLR |
+		PPC4XX_TMO_ERR_INT);
+}
+
 /**
  * Supported Crypto Algorithms
  */
@@ -1263,6 +1281,8 @@ static int crypto4xx_probe(struct platform_device *ofdev)
 	struct resource res;
 	struct device *dev = &ofdev->dev;
 	struct crypto4xx_core_device *core_dev;
+	u32 pvr;
+	bool is_revb = true;
 
 	rc = of_address_to_resource(ofdev->dev.of_node, 0, &res);
 	if (rc)
@@ -1279,6 +1299,7 @@ static int crypto4xx_probe(struct platform_device *ofdev)
 		       mfdcri(SDR0, PPC405EX_SDR0_SRST) | PPC405EX_CE_RESET);
 		mtdcri(SDR0, PPC405EX_SDR0_SRST,
 		       mfdcri(SDR0, PPC405EX_SDR0_SRST) & ~PPC405EX_CE_RESET);
+		is_revb = false;
 	} else if (of_find_compatible_node(NULL, NULL,
 			"amcc,ppc460sx-crypto")) {
 		mtdcri(SDR0, PPC460SX_SDR0_SRST,
@@ -1301,7 +1322,22 @@ static int crypto4xx_probe(struct platform_device *ofdev)
 	if (!core_dev->dev)
 		goto err_alloc_dev;
 
+	/*
+	 * Older version of 460EX/GT have a hardware bug.
+	 * Hence they do not support H/W based security intr coalescing
+	 */
+	pvr = mfspr(SPRN_PVR);
+	if (is_revb && ((pvr >> 4) == 0x130218A)) {
+		u32 min = PVR_MIN(pvr);
+
+		if (min < 4) {
+			dev_info(dev, "RevA detected - disable interrupt coalescing\n");
+			is_revb = false;
+		}
+	}
+
 	core_dev->dev->core_dev = core_dev;
+	core_dev->dev->is_revb = is_revb;
 	core_dev->device = dev;
 	spin_lock_init(&core_dev->lock);
 	INIT_LIST_HEAD(&core_dev->dev->alg_list);
@@ -1331,7 +1367,9 @@ static int crypto4xx_probe(struct platform_device *ofdev)
 
 	/* Register for Crypto isr, Crypto Engine IRQ */
 	core_dev->irq = irq_of_parse_and_map(ofdev->dev.of_node, 0);
-	rc = request_irq(core_dev->irq, crypto4xx_ce_interrupt_handler, 0,
+	rc = request_irq(core_dev->irq, is_revb ?
+			 crypto4xx_ce_interrupt_handler_revb :
+			 crypto4xx_ce_interrupt_handler, 0,
 			 core_dev->dev->name, dev);
 	if (rc)
 		goto err_request_irq;
diff --git a/drivers/crypto/amcc/crypto4xx_core.h b/drivers/crypto/amcc/crypto4xx_core.h
index 8ac3bd37203b..013d9992a44e 100644
--- a/drivers/crypto/amcc/crypto4xx_core.h
+++ b/drivers/crypto/amcc/crypto4xx_core.h
@@ -109,6 +109,7 @@ struct crypto4xx_device {
 	struct list_head alg_list;	/* List of algorithm supported
 					by this device */
 	struct ratelimit_state aead_ratelimit;
+	bool is_revb;
 };
 
 struct crypto4xx_core_device {
diff --git a/drivers/crypto/amcc/crypto4xx_reg_def.h b/drivers/crypto/amcc/crypto4xx_reg_def.h
index 0a22ec5d1a96..472331787e04 100644
--- a/drivers/crypto/amcc/crypto4xx_reg_def.h
+++ b/drivers/crypto/amcc/crypto4xx_reg_def.h
@@ -121,13 +121,15 @@
 #define PPC4XX_PD_SIZE				6
 #define PPC4XX_CTX_DONE_INT			0x2000
 #define PPC4XX_PD_DONE_INT			0x8000
+#define PPC4XX_TMO_ERR_INT			0x40000
 #define PPC4XX_BYTE_ORDER			0x22222
 #define PPC4XX_INTERRUPT_CLR			0x3ffff
 #define PPC4XX_PRNG_CTRL_AUTO_EN		0x3
 #define PPC4XX_DC_3DES_EN			1
 #define PPC4XX_TRNG_EN				0x00020000
-#define PPC4XX_INT_DESCR_CNT			4
+#define PPC4XX_INT_DESCR_CNT			7
 #define PPC4XX_INT_TIMEOUT_CNT			0
+#define PPC4XX_INT_TIMEOUT_CNT_REVB		0x3FF
 #define PPC4XX_INT_CFG				1
 /**
  * all follow define are ad hoc
-- 
2.15.1
