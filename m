From: Kim Phillips <kim.phillips@freescale.com>
Subject: [PATCH 4/4] crypto/talitos: add hwrng support
Date: Mon, 16 Jun 2008 11:10:53 -0500
Message-ID: <20080616111053.b3a3c99d.kim.phillips@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linuxppc-dev@ozlabs.org, herbert@gondor.apana.org.au
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from de01egw02.freescale.net ([192.88.165.103]:45676 "EHLO
	de01egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753506AbYFPQLh (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 16 Jun 2008 12:11:37 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

register with the hwrng subsystem to provide entropy to the kernel.

Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
---
 drivers/crypto/Kconfig   |    1 +
 drivers/crypto/talitos.c |  136 ++++++++++++++++++++++++++++++++++++++--------
 drivers/crypto/talitos.h |   13 ++++-
 3 files changed, 126 insertions(+), 24 deletions(-)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 98d96df..249c135 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -178,6 +178,7 @@ config CRYPTO_DEV_TALITOS
 	tristate "Talitos Freescale Security Engine (SEC)"
 	select CRYPTO_ALGAPI
 	select CRYPTO_AUTHENC
+	select HW_RANDOM
 	depends on FSL_SOC
 	help
 	  Say 'Y' here to use the Freescale Security Engine (SEC)
diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 64ddad2..e123312 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -124,6 +124,9 @@ struct talitos_private {
 
 	/* list of registered algorithms */
 	struct list_head alg_list;
+
+	/* hwrng device */
+	struct hwrng rng;
 };
 
 /*
@@ -523,8 +526,8 @@ static void talitos_error(unsigned long data)
 			}
 		}
 	}
-	if (reset_dev || isr & ~TALITOS_ISR_CHERR) {
-		dev_err(dev, "done overflow or internal time out error: "
+	if (reset_dev || isr & ~TALITOS_ISR_CHERR || isr_lo) {
+		dev_err(dev, "done overflow, internal time out, or rngu error: "
 		        "ISR 0x%08x_%08x\n", isr, isr_lo);
 
 		/* purge request queues */
@@ -549,7 +552,7 @@ static irqreturn_t talitos_interrupt(int irq, void *data)
 	out_be32(priv->reg + TALITOS_ICR, isr);
 	out_be32(priv->reg + TALITOS_ICR_LO, isr_lo);
 
-	if (unlikely(isr & ~TALITOS_ISR_CHDONE))
+	if (unlikely((isr & ~TALITOS_ISR_CHDONE) || isr_lo))
 		talitos_error((unsigned long)data);
 	else
 		if (likely(isr & TALITOS_ISR_CHDONE))
@@ -559,6 +562,80 @@ static irqreturn_t talitos_interrupt(int irq, void *data)
 }
 
 /*
+ * hwrng
+ */
+static int talitos_rng_data_present(struct hwrng *rng, int wait)
+{
+	struct device *dev = (struct device *)rng->priv;
+	struct talitos_private *priv = dev_get_drvdata(dev);
+	u32 ofl;
+	int i;
+
+	for (i = 0; i < 20; i++) {
+		ofl = in_be32(priv->reg + TALITOS_RNGUSR_LO) &
+		      TALITOS_RNGUSR_LO_OFL;
+		if (ofl || !wait)
+			break;
+		udelay(10);
+	}
+
+	return !!ofl;
+}
+
+static int talitos_rng_data_read(struct hwrng *rng, u32 *data)
+{
+	struct device *dev = (struct device *)rng->priv;
+	struct talitos_private *priv = dev_get_drvdata(dev);
+
+	/* rng fifo requires 64-bit accesses */
+	*data = in_be32(priv->reg + TALITOS_RNGU_FIFO);
+	*data = in_be32(priv->reg + TALITOS_RNGU_FIFO_LO);
+
+	return sizeof(u32);
+}
+
+static int talitos_rng_init(struct hwrng *rng)
+{
+	struct device *dev = (struct device *)rng->priv;
+	struct talitos_private *priv = dev_get_drvdata(dev);
+	unsigned int timeout = TALITOS_TIMEOUT;
+
+	setbits32(priv->reg + TALITOS_RNGURCR_LO, TALITOS_RNGURCR_LO_SR);
+	while (!(in_be32(priv->reg + TALITOS_RNGUSR_LO) & TALITOS_RNGUSR_LO_RD)
+	       && --timeout)
+		cpu_relax();
+	if (timeout == 0) {
+		dev_err(dev, "failed to reset rng hw\n");
+		return -ENODEV;
+	}
+
+	/* start generating */
+	setbits32(priv->reg + TALITOS_RNGUDSR_LO, 0);
+
+	return 0;
+}
+
+static int talitos_register_rng(struct device *dev)
+{
+	struct talitos_private *priv = dev_get_drvdata(dev);
+
+	priv->rng.name		= dev_driver_string(dev),
+	priv->rng.init		= talitos_rng_init,
+	priv->rng.data_present	= talitos_rng_data_present,
+	priv->rng.data_read	= talitos_rng_data_read,
+	priv->rng.priv		= (unsigned long)dev;
+
+	return hwrng_register(&priv->rng);
+}
+
+static void talitos_unregister_rng(struct device *dev)
+{
+	struct talitos_private *priv = dev_get_drvdata(dev);
+
+	hwrng_unregister(&priv->rng);
+}
+
+/*
  * crypto alg
  */
 #define TALITOS_CRA_PRIORITY		3000
@@ -1094,6 +1171,26 @@ static int talitos_cra_init(struct crypto_tfm *tfm)
 	return 0;
 }
 
+/*
+ * given the alg's descriptor header template, determine whether descriptor
+ * type and primary/secondary execution units required match the hw
+ * capabilities description provided in the device tree node.
+ */
+static int hw_supports(struct device *dev, __be32 desc_hdr_template)
+{
+	struct talitos_private *priv = dev_get_drvdata(dev);
+	int ret;
+
+	ret = (1 << DESC_TYPE(desc_hdr_template) & priv->desc_types) &&
+	      (1 << PRIMARY_EU(desc_hdr_template) & priv->exec_units);
+
+	if (SECONDARY_EU(desc_hdr_template))
+		ret = ret && (1 << SECONDARY_EU(desc_hdr_template)
+		              & priv->exec_units);
+
+	return ret;
+}
+
 static int __devexit talitos_remove(struct of_device *ofdev)
 {
 	struct device *dev = &ofdev->dev;
@@ -1107,6 +1204,9 @@ static int __devexit talitos_remove(struct of_device *ofdev)
 		kfree(t_alg);
 	}
 
+	if (hw_supports(dev, DESC_HDR_SEL0_RNG))
+		talitos_unregister_rng(dev);
+
 	kfree(priv->tail);
 	kfree(priv->head);
 
@@ -1167,26 +1267,6 @@ static struct talitos_crypto_alg *talitos_alg_alloc(struct device *dev,
 	return t_alg;
 }
 
-/*
- * given the alg's descriptor header template, determine whether descriptor
- * type and primary/secondary execution units required match the hw
- * capabilities description provided in the device tree node.
- */
-static int hw_supports(struct device *dev, __be32 desc_hdr_template)
-{
-	struct talitos_private *priv = dev_get_drvdata(dev);
-	int ret;
-
-	ret = (1 << DESC_TYPE(desc_hdr_template) & priv->desc_types) &&
-	      (1 << PRIMARY_EU(desc_hdr_template) & priv->exec_units);
-
-	if (SECONDARY_EU(desc_hdr_template))
-		ret = ret && (1 << SECONDARY_EU(desc_hdr_template)
-		              & priv->exec_units);
-
-	return ret;
-}
-
 static int talitos_probe(struct of_device *ofdev,
 			 const struct of_device_id *match)
 {
@@ -1309,6 +1389,16 @@ static int talitos_probe(struct of_device *ofdev,
 		goto err_out;
 	}
 
+	/* register the RNG, if available */
+	if (hw_supports(dev, DESC_HDR_SEL0_RNG)) {
+		err = talitos_register_rng(dev);
+		if (err) {
+			dev_err(dev, "failed to register hwrng: %d\n", err);
+			goto err_out;
+		} else
+			dev_info(dev, "hwrng\n");
+	}
+
 	/* register crypto algorithms the device supports */
 	INIT_LIST_HEAD(&priv->alg_list);
 
diff --git a/drivers/crypto/talitos.h b/drivers/crypto/talitos.h
index 27deb65..de0e377 100644
--- a/drivers/crypto/talitos.h
+++ b/drivers/crypto/talitos.h
@@ -39,7 +39,7 @@
 #define TALITOS_IMR			0x1008  /* interrupt mask register */
 #define   TALITOS_IMR_INIT		0x10fff /* enable channel IRQs */
 #define TALITOS_IMR_LO			0x100C
-#define   TALITOS_IMR_LO_INIT		0x0     /* disable execution unit IRQs*/
+#define   TALITOS_IMR_LO_INIT		0x20000 /* allow RNGU error IRQs */
 #define TALITOS_ISR			0x1010  /* interrupt status register */
 #define   TALITOS_ISR_CHERR		0xaa    /* channel errors mask */
 #define   TALITOS_ISR_CHDONE		0x55    /* channel done mask */
@@ -106,6 +106,17 @@
 #define TALITOS_AFEUISR_LO		0x8034
 #define TALITOS_RNGUISR			0xa030 /* random number unit */
 #define TALITOS_RNGUISR_LO		0xa034
+#define TALITOS_RNGUSR			0xa028 /* rng status */
+#define TALITOS_RNGUSR_LO		0xa02c
+#define   TALITOS_RNGUSR_LO_RD		0x1	/* reset done */
+#define   TALITOS_RNGUSR_LO_OFL		0xff0000/* output FIFO length */
+#define TALITOS_RNGUDSR			0xa010	/* data size */
+#define TALITOS_RNGUDSR_LO		0xa014
+#define TALITOS_RNGU_FIFO		0xa800	/* output FIFO */
+#define TALITOS_RNGU_FIFO_LO		0xa804	/* output FIFO */
+#define TALITOS_RNGURCR			0xa018	/* reset control */
+#define TALITOS_RNGURCR_LO		0xa01c
+#define   TALITOS_RNGURCR_LO_SR		0x1	/* software reset */
 #define TALITOS_PKEUISR			0xc030 /* public key unit */
 #define TALITOS_PKEUISR_LO		0xc034
 #define TALITOS_KEUISR			0xe030 /* kasumi unit */
-- 
1.5.6.rc2.26.g8c37

