From: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Subject: [PATCH] hwrng: amd-rng - Migrate to managed API
Date: Fri,  9 Sep 2016 13:28:23 +0530
Message-ID: <1473407903-12470-1-git-send-email-prasannatsmkumar@gmail.com>
Cc: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
To: mpm@selenic.com, herbert@gondor.apana.org.au,
        clabbe.montjoie@gmail.com, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:34677 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751981AbcIIH7K (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Sep 2016 03:59:10 -0400
Received: by mail-pf0-f196.google.com with SMTP id g202so3647176pfb.1
        for <linux-crypto@vger.kernel.org>; Fri, 09 Sep 2016 00:59:09 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Managed API eliminates error handling code, thus reduces several lines
of code.

Signed-off-by: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
---
 drivers/char/hw_random/amd-rng.c | 48 +++++++++-------------------------------
 1 file changed, 11 insertions(+), 37 deletions(-)

diff --git a/drivers/char/hw_random/amd-rng.c b/drivers/char/hw_random/amd-rng.c
index 9959c76..4dbc5aa 100644
--- a/drivers/char/hw_random/amd-rng.c
+++ b/drivers/char/hw_random/amd-rng.c
@@ -55,7 +55,6 @@ MODULE_DEVICE_TABLE(pci, pci_tbl);
 struct amd768_priv {
 	void __iomem *iobase;
 	struct pci_dev *pcidev;
-	u32 pmbase;
 };
 
 static int amd_rng_read(struct hwrng *rng, void *buf, size_t max, bool wait)
@@ -149,58 +148,33 @@ found:
 	if (pmbase == 0)
 		return -EIO;
 
-	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
-	if (!priv)
-		return -ENOMEM;
+	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
+	if (IS_ERR(priv))
+		return PTR_ERR(priv);
 
-	if (!request_region(pmbase + PMBASE_OFFSET, PMBASE_SIZE, DRV_NAME)) {
+	if (!devm_request_region(&pdev->dev, pmbase + PMBASE_OFFSET,
+				PMBASE_SIZE, DRV_NAME)) {
 		dev_err(&pdev->dev, DRV_NAME " region 0x%x already in use!\n",
 			pmbase + 0xF0);
-		err = -EBUSY;
-		goto out;
+		return -EBUSY;
 	}
 
-	priv->iobase = ioport_map(pmbase + PMBASE_OFFSET, PMBASE_SIZE);
-	if (!priv->iobase) {
+	priv->iobase = devm_ioport_map(&pdev->dev, pmbase + PMBASE_OFFSET,
+			PMBASE_SIZE);
+	if (IS_ERR(priv->iobase)) {
 		pr_err(DRV_NAME "Cannot map ioport\n");
-		err = -EINVAL;
-		goto err_iomap;
+		return PTR_ERR(priv->iobase);
 	}
 
 	amd_rng.priv = (unsigned long)priv;
-	priv->pmbase = pmbase;
 	priv->pcidev = pdev;
 
 	pr_info(DRV_NAME " detected\n");
-	err = hwrng_register(&amd_rng);
-	if (err) {
-		pr_err(DRV_NAME " registering failed (%d)\n", err);
-		goto err_hwrng;
-	}
-	return 0;
-
-err_hwrng:
-	ioport_unmap(priv->iobase);
-err_iomap:
-	release_region(pmbase + PMBASE_OFFSET, PMBASE_SIZE);
-out:
-	kfree(priv);
-	return err;
+	return devm_hwrng_register(&pdev->dev, &amd_rng);
 }
 
 static void __exit mod_exit(void)
 {
-	struct amd768_priv *priv;
-
-	priv = (struct amd768_priv *)amd_rng.priv;
-
-	hwrng_unregister(&amd_rng);
-
-	ioport_unmap(priv->iobase);
-
-	release_region(priv->pmbase + PMBASE_OFFSET, PMBASE_SIZE);
-
-	kfree(priv);
 }
 
 module_init(mod_init);
-- 
2.5.0
