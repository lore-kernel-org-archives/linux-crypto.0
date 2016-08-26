From: LABBE Corentin <clabbe.montjoie@gmail.com>
Subject: [PATCH v3 7/8] hwrng: amd: Access hardware via ioread32/iowrite32
Date: Fri, 26 Aug 2016 13:11:35 +0200
Message-ID: <1472209896-17197-8-git-send-email-clabbe.montjoie@gmail.com>
References: <1472209896-17197-1-git-send-email-clabbe.montjoie@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        LABBE Corentin <clabbe.montjoie@gmail.com>
To: mpm@selenic.com, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1472209896-17197-1-git-send-email-clabbe.montjoie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Instead of accessing hw directly via pmbase, it's better to
access after ioport_map() via ioread32/iowrite32.

Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
---
 drivers/char/hw_random/amd-rng.c | 31 +++++++++++++++++++++++++------
 1 file changed, 25 insertions(+), 6 deletions(-)

diff --git a/drivers/char/hw_random/amd-rng.c b/drivers/char/hw_random/amd-rng.c
index 4ef94e9..bfa14b9 100644
--- a/drivers/char/hw_random/amd-rng.c
+++ b/drivers/char/hw_random/amd-rng.c
@@ -32,6 +32,11 @@
 
 #define DRV_NAME "AMD768-HWRNG"
 
+#define RNGDATA		0x00
+#define RNGDONE		0x04
+#define PMBASE_OFFSET	0xF0
+#define PMBASE_SIZE	8
+
 /*
  * Data for PCI driver interface
  *
@@ -48,6 +53,7 @@ static const struct pci_device_id pci_tbl[] = {
 MODULE_DEVICE_TABLE(pci, pci_tbl);
 
 struct amd768_priv {
+	void __iomem *iobase;
 	struct pci_dev *pcidev;
 	u32 pmbase;
 };
@@ -58,7 +64,7 @@ static int amd_rng_data_present(struct hwrng *rng, int wait)
 	int data, i;
 
 	for (i = 0; i < 20; i++) {
-		data = !!(inl(priv->pmbase + 0xF4) & 1);
+		data = !!(ioread32(priv->iobase + RNGDONE) & 1);
 		if (data || !wait)
 			break;
 		udelay(10);
@@ -70,7 +76,7 @@ static int amd_rng_data_read(struct hwrng *rng, u32 *data)
 {
 	struct amd768_priv *priv = (struct amd768_priv *)rng->priv;
 
-	*data = inl(priv->pmbase + 0xF0);
+	*data = ioread32(priv->iobase + RNGDATA);
 
 	return 4;
 }
@@ -138,12 +144,20 @@ found:
 	if (!priv)
 		return -ENOMEM;
 
-	if (!request_region(pmbase + 0xF0, 8, DRV_NAME)) {
+	if (!request_region(pmbase + PMBASE_OFFSET, PMBASE_SIZE, DRV_NAME)) {
 		dev_err(&pdev->dev, DRV_NAME " region 0x%x already in use!\n",
 			pmbase + 0xF0);
 		err = -EBUSY;
 		goto out;
 	}
+
+	priv->iobase = ioport_map(pmbase + PMBASE_OFFSET, PMBASE_SIZE);
+	if (!priv->iobase) {
+		pr_err(DRV_NAME "Cannot map ioport\n");
+		err = -EINVAL;
+		goto err_iomap;
+	}
+
 	amd_rng.priv = (unsigned long)priv;
 	priv->pmbase = pmbase;
 	priv->pcidev = pdev;
@@ -152,11 +166,14 @@ found:
 	err = hwrng_register(&amd_rng);
 	if (err) {
 		pr_err(DRV_NAME " registering failed (%d)\n", err);
-		release_region(pmbase + 0xF0, 8);
-		goto out;
+		goto err_hwrng;
 	}
 	return 0;
 
+err_hwrng:
+	ioport_unmap(priv->iobase);
+err_iomap:
+	release_region(pmbase + PMBASE_OFFSET, PMBASE_SIZE);
 out:
 	kfree(priv);
 	return err;
@@ -170,7 +187,9 @@ static void __exit mod_exit(void)
 
 	hwrng_unregister(&amd_rng);
 
-	release_region(priv->pmbase + 0xF0, 8);
+	ioport_unmap(priv->iobase);
+
+	release_region(priv->pmbase + PMBASE_OFFSET, PMBASE_SIZE);
 
 	kfree(priv);
 }
-- 
2.7.3
