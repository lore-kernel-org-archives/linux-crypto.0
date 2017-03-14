From: Prarit Bhargava <prarit@redhat.com>
Subject: [PATCH 1/2] hwrng: amd - Revert managed API changes
Date: Tue, 14 Mar 2017 07:36:01 -0400
Message-ID: <1489491362-26339-2-git-send-email-prarit@redhat.com>
References: <1489491362-26339-1-git-send-email-prarit@redhat.com>
Cc: Prarit Bhargava <prarit@redhat.com>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Corentin LABBE <clabbe.montjoie@gmail.com>,
        PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        linux-crypto@vger.kernel.org, linux-geode@lists.infradead.org
To: linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1489491362-26339-1-git-send-email-prarit@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

After commit 31b2a73c9c5f ("hwrng: amd - Migrate to managed API"), the
amd-rng driver uses devres with pci_dev->dev to keep track of resources,
but does not actually register a PCI driver.  This results in the
following issues:

1. The message

WARNING: CPU: 2 PID: 621 at drivers/base/dd.c:349 driver_probe_device+0x38c

is output when the i2c_amd756 driver loads and attempts to register a PCI
driver.  The PCI & device subsystems assume that no resources have been
registered for the device, and the WARN_ON() triggers since amd-rng has
already do so.

2.  The driver leaks memory because the driver does not attach to a
device.  The driver only uses the PCI device as a reference.   devm_*()
functions will release resources on driver detach, which the amd-rng
driver will never do.  As a result,

3.  The driver cannot be reloaded because there is always a use of the
ioport and region after the first load of the driver.

Revert the changes made by 31b2a73c9c5f ("hwrng: amd - Migrate to managed
API").

Signed-off-by: Prarit Bhargava <prarit@redhat.com>
Fixes: 31b2a73c9c5f ("hwrng: amd - Migrate to managed API").
Cc: Matt Mackall <mpm@selenic.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Corentin LABBE <clabbe.montjoie@gmail.com>
Cc: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Cc: Wei Yongjun <weiyongjun1@huawei.com>
Cc: linux-crypto@vger.kernel.org
Cc: linux-geode@lists.infradead.org
---
 drivers/char/hw_random/amd-rng.c |   42 ++++++++++++++++++++++++++++++--------
 1 file changed, 34 insertions(+), 8 deletions(-)

diff --git a/drivers/char/hw_random/amd-rng.c b/drivers/char/hw_random/amd-rng.c
index 4a99ac756f08..9959c762da2f 100644
--- a/drivers/char/hw_random/amd-rng.c
+++ b/drivers/char/hw_random/amd-rng.c
@@ -55,6 +55,7 @@
 struct amd768_priv {
 	void __iomem *iobase;
 	struct pci_dev *pcidev;
+	u32 pmbase;
 };
 
 static int amd_rng_read(struct hwrng *rng, void *buf, size_t max, bool wait)
@@ -148,33 +149,58 @@ static int __init mod_init(void)
 	if (pmbase == 0)
 		return -EIO;
 
-	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
+	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
 	if (!priv)
 		return -ENOMEM;
 
-	if (!devm_request_region(&pdev->dev, pmbase + PMBASE_OFFSET,
-				PMBASE_SIZE, DRV_NAME)) {
+	if (!request_region(pmbase + PMBASE_OFFSET, PMBASE_SIZE, DRV_NAME)) {
 		dev_err(&pdev->dev, DRV_NAME " region 0x%x already in use!\n",
 			pmbase + 0xF0);
-		return -EBUSY;
+		err = -EBUSY;
+		goto out;
 	}
 
-	priv->iobase = devm_ioport_map(&pdev->dev, pmbase + PMBASE_OFFSET,
-			PMBASE_SIZE);
+	priv->iobase = ioport_map(pmbase + PMBASE_OFFSET, PMBASE_SIZE);
 	if (!priv->iobase) {
 		pr_err(DRV_NAME "Cannot map ioport\n");
-		return -ENOMEM;
+		err = -EINVAL;
+		goto err_iomap;
 	}
 
 	amd_rng.priv = (unsigned long)priv;
+	priv->pmbase = pmbase;
 	priv->pcidev = pdev;
 
 	pr_info(DRV_NAME " detected\n");
-	return devm_hwrng_register(&pdev->dev, &amd_rng);
+	err = hwrng_register(&amd_rng);
+	if (err) {
+		pr_err(DRV_NAME " registering failed (%d)\n", err);
+		goto err_hwrng;
+	}
+	return 0;
+
+err_hwrng:
+	ioport_unmap(priv->iobase);
+err_iomap:
+	release_region(pmbase + PMBASE_OFFSET, PMBASE_SIZE);
+out:
+	kfree(priv);
+	return err;
 }
 
 static void __exit mod_exit(void)
 {
+	struct amd768_priv *priv;
+
+	priv = (struct amd768_priv *)amd_rng.priv;
+
+	hwrng_unregister(&amd_rng);
+
+	ioport_unmap(priv->iobase);
+
+	release_region(priv->pmbase + PMBASE_OFFSET, PMBASE_SIZE);
+
+	kfree(priv);
 }
 
 module_init(mod_init);
-- 
1.7.9.3
