From: LABBE Corentin <clabbe.montjoie@gmail.com>
Subject: [PATCH 5/5] hwrng: amd: Rework of the amd768-hwrng driver
Date: Fri, 19 Aug 2016 15:42:57 +0200
Message-ID: <1471614177-12380-5-git-send-email-clabbe.montjoie@gmail.com>
References: <1471614177-12380-1-git-send-email-clabbe.montjoie@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        LABBE Corentin <clabbe.montjoie@gmail.com>
To: herbert@gondor.apana.org.au, mpm@selenic.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1471614177-12380-1-git-send-email-clabbe.montjoie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This patch convert the hwrng interface used by amd768-rng to its new API
by replacing data_read()/data_present() by read().

Furthermore, Instead of having two global variable, it's better to use a
private struct. This will permit to remove amd_pdev variable.

Finally, Instead of accessing hw directly via pmbase, it's better to
access after ioport_map() via ioread32/iowrite32.

Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
---
 drivers/char/hw_random/amd-rng.c | 151 +++++++++++++++++++++++++--------------
 1 file changed, 99 insertions(+), 52 deletions(-)

diff --git a/drivers/char/hw_random/amd-rng.c b/drivers/char/hw_random/amd-rng.c
index 9ddc99c..efdd853 100644
--- a/drivers/char/hw_random/amd-rng.c
+++ b/drivers/char/hw_random/amd-rng.c
@@ -32,6 +32,14 @@
 
 #define DRV_NAME "AMD768-HWRNG"
 
+#define GEN_CFG_REG1	0x40
+#define GEN_CFG_REG2	0x41
+#define SMIO_SPACEPTR	0x58
+#define RNGDATA		0x00
+#define RNGDONE		0x04
+#define PMBASE_OFFSET	0xF0
+#define PMBASE_SIZE	8
+
 /*
  * Data for PCI driver interface
  *
@@ -39,6 +47,7 @@
  * PCI ids via MODULE_DEVICE_TABLE.  We do not actually
  * register a pci_driver, because someone else might one day
  * want to register another driver on the same PCI id.
+ * Like i2c-amd756
  */
 static const struct pci_device_id pci_tbl[] = {
 	{ PCI_VDEVICE(AMD, 0x7443), 0, },
@@ -47,112 +56,150 @@ static const struct pci_device_id pci_tbl[] = {
 };
 MODULE_DEVICE_TABLE(pci, pci_tbl);
 
-static struct pci_dev *amd_pdev;
+struct amd768_priv {
+	void __iomem *iobase;
+	struct pci_dev *pcidev;
+	u32 pmbase;
+};
 
-static int amd_rng_data_present(struct hwrng *rng, int wait)
+static int amd_rng_read(struct hwrng *rng, void *buf, size_t max, bool wait)
 {
-	u32 pmbase = (u32)rng->priv;
-	int data, i;
-
-	for (i = 0; i < 20; i++) {
-		data = !!(inl(pmbase + 0xF4) & 1);
-		if (data || !wait)
-			break;
-		udelay(10);
+	u32 *data = buf;
+	struct amd768_priv *priv = (struct amd768_priv *)rng->priv;
+	size_t read = 0;
+	/* We will wait at maximum one time per read */
+	int timeout = max / 4 + 1;
+
+	/*
+	 * RNG data is available when RNGDONE is set to 1
+	 * New random numbers are generated approximately 128 microseconds
+	 * after RNGDATA is read
+	 */
+	while (read < max) {
+		if (ioread32(priv->iobase + RNGDONE) == 0) {
+			if (wait) {
+				/* Delay given by datasheet */
+				usleep_range(128, 196);
+				if (timeout-- == 0)
+					return read;
+			} else {
+				return 0;
+			}
+		} else {
+			*data = ioread32(priv->iobase + RNGDATA);
+			data++;
+			read += 4;
+		}
 	}
-	return data;
-}
-
-static int amd_rng_data_read(struct hwrng *rng, u32 *data)
-{
-	u32 pmbase = (u32)rng->priv;
 
-	*data = inl(pmbase + 0xF0);
-
-	return 4;
+	return read;
 }
 
 static int amd_rng_init(struct hwrng *rng)
 {
 	u8 rnen;
+	struct amd768_priv *priv = (struct amd768_priv *)rng->priv;
 
-	pci_read_config_byte(amd_pdev, 0x40, &rnen);
+	pci_read_config_byte(priv->pcidev, GEN_CFG_REG1, &rnen);
 	rnen |= BIT(7);	/* RNG on */
-	pci_write_config_byte(amd_pdev, 0x40, rnen);
+	pci_write_config_byte(priv->pcidev, GEN_CFG_REG1, rnen);
 
-	pci_read_config_byte(amd_pdev, 0x41, &rnen);
+	pci_read_config_byte(priv->pcidev, GEN_CFG_REG2, &rnen);
 	rnen |= BIT(7);	/* PMIO enable */
-	pci_write_config_byte(amd_pdev, 0x41, rnen);
-
+	pci_write_config_byte(priv->pcidev, GEN_CFG_REG2, rnen);
 	return 0;
 }
 
 static void amd_rng_cleanup(struct hwrng *rng)
 {
 	u8 rnen;
+	struct amd768_priv *priv = (struct amd768_priv *)rng->priv;
 
-	pci_read_config_byte(amd_pdev, 0x40, &rnen);
+	pci_read_config_byte(priv->pcidev, GEN_CFG_REG1, &rnen);
 	rnen &= ~BIT(7);	/* RNG off */
-	pci_write_config_byte(amd_pdev, 0x40, rnen);
+	pci_write_config_byte(priv->pcidev, GEN_CFG_REG1, rnen);
 }
 
 static struct hwrng amd_rng = {
 	.name		= DRV_NAME,
+	.read		= amd_rng_read,
 	.init		= amd_rng_init,
 	.cleanup	= amd_rng_cleanup,
-	.data_present	= amd_rng_data_present,
-	.data_read	= amd_rng_data_read,
 };
 
-static int __init mod_init(void)
+static int mod_init(void)
 {
-	int err = -ENODEV;
+	int err;
 	struct pci_dev *pdev = NULL;
 	const struct pci_device_id *ent;
 	u32 pmbase;
+	struct amd768_priv *priv;
 
 	for_each_pci_dev(pdev) {
 		ent = pci_match_id(pci_tbl, pdev);
 		if (ent)
 			goto found;
 	}
-	/* Device not found. */
-	goto out;
-
+	return -ENODEV;
 found:
-	err = pci_read_config_dword(pdev, 0x58, &pmbase);
+
+	err = pci_read_config_dword(pdev, SMIO_SPACEPTR, &pmbase);
 	if (err)
-		goto out;
-	err = -EIO;
+		return err;
+
 	pmbase &= 0x0000FF00;
-	if (pmbase == 0)
-		goto out;
-	if (!request_region(pmbase + 0xF0, 8, DRV_NAME)) {
-		dev_err(&pdev->dev, DRV_NAME " region 0x%x already in use!\n",
-			pmbase + 0xF0);
-		err = -EBUSY;
-		goto out;
+
+	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	if (!request_region(pmbase + PMBASE_OFFSET, PMBASE_SIZE, DRV_NAME)) {
+		pr_err(DRV_NAME "region 0x%x already in use!\n", pmbase);
+		goto err_pmbase;
+	}
+
+	priv->iobase = ioport_map(pmbase + PMBASE_OFFSET, PMBASE_SIZE);
+	if (!priv->iobase) {
+		pr_err(DRV_NAME "Cannot map ioport\n");
+		err = -EINVAL;
+		goto err_iomap;
 	}
-	amd_rng.priv = (unsigned long)pmbase;
-	amd_pdev = pdev;
+
+	amd_rng.priv = (unsigned long)priv;
+	priv->pmbase = pmbase;
+	priv->pcidev = pdev;
 
 	pr_info(DRV_NAME " detected\n");
+
 	err = hwrng_register(&amd_rng);
 	if (err) {
-		pr_err(DRV_NAME " registering failed (%d)\n", err);
-		release_region(pmbase + 0xF0, 8);
-		goto out;
+		pr_err(DRV_NAME "Cannot register HWRNG %d\n", err);
+		goto err_hwrng;
 	}
-out:
+	return 0;
+
+err_hwrng:
+	ioport_unmap(priv->iobase);
+err_iomap:
+	release_region(pmbase + PMBASE_OFFSET, PMBASE_SIZE);
+err_pmbase:
+	kfree(priv);
 	return err;
 }
 
-static void __exit mod_exit(void)
+static void mod_exit(void)
 {
-	u32 pmbase = (unsigned long)amd_rng.priv;
+	struct amd768_priv *priv;
+
+	priv = (struct amd768_priv *)amd_rng.priv;
 
-	release_region(pmbase + 0xF0, 8);
 	hwrng_unregister(&amd_rng);
+
+	ioport_unmap(priv->iobase);
+
+	release_region(priv->pmbase + PMBASE_OFFSET, PMBASE_SIZE);
+
+	kfree(priv);
 }
 
 module_init(mod_init);
-- 
2.7.3
