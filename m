From: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Subject: [PATCH] hwrng: geode-rng - Migrate to managed API
Date: Sun, 11 Sep 2016 20:53:21 +0530
Message-ID: <1473607401-25873-1-git-send-email-prasannatsmkumar@gmail.com>
Cc: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
To: herbert@gondor.apana.org.au, mpm@selenic.com,
        linux-geode@lists.infradead.org, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:32794 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750912AbcIKPYL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 11 Sep 2016 11:24:11 -0400
Received: by mail-pf0-f194.google.com with SMTP id 128so6786244pfb.0
        for <linux-crypto@vger.kernel.org>; Sun, 11 Sep 2016 08:24:11 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Use devm_ioremap and devm_hwrng_register instead of ioremap and
hwrng_register. This removes error handling code. Also moved code around
by removing goto statements. This improves code readability.

Signed-off-by: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
---
 drivers/char/hw_random/geode-rng.c | 50 ++++++++++++--------------------------
 1 file changed, 15 insertions(+), 35 deletions(-)

diff --git a/drivers/char/hw_random/geode-rng.c b/drivers/char/hw_random/geode-rng.c
index 0d0579f..79e7482 100644
--- a/drivers/char/hw_random/geode-rng.c
+++ b/drivers/char/hw_random/geode-rng.c
@@ -31,9 +31,6 @@
 #include <linux/delay.h>
 #include <asm/io.h>
 
-
-#define PFX	KBUILD_MODNAME ": "
-
 #define GEODE_RNG_DATA_REG   0x50
 #define GEODE_RNG_STATUS_REG 0x54
 
@@ -85,7 +82,6 @@ static struct hwrng geode_rng = {
 
 static int __init mod_init(void)
 {
-	int err = -ENODEV;
 	struct pci_dev *pdev = NULL;
 	const struct pci_device_id *ent;
 	void __iomem *mem;
@@ -93,43 +89,27 @@ static int __init mod_init(void)
 
 	for_each_pci_dev(pdev) {
 		ent = pci_match_id(pci_tbl, pdev);
-		if (ent)
-			goto found;
-	}
-	/* Device not found. */
-	goto out;
-
-found:
-	rng_base = pci_resource_start(pdev, 0);
-	if (rng_base == 0)
-		goto out;
-	err = -ENOMEM;
-	mem = ioremap(rng_base, 0x58);
-	if (!mem)
-		goto out;
-	geode_rng.priv = (unsigned long)mem;
-
-	pr_info("AMD Geode RNG detected\n");
-	err = hwrng_register(&geode_rng);
-	if (err) {
-		pr_err(PFX "RNG registering failed (%d)\n",
-		       err);
-		goto err_unmap;
+		if (ent) {
+			rng_base = pci_resource_start(pdev, 0);
+			if (rng_base == 0)
+				return -ENODEV;
+
+			mem = devm_ioremap(&pdev->dev, rng_base, 0x58);
+			if (IS_ERR(mem))
+				return PTR_ERR(mem);
+			geode_rng.priv = (unsigned long)mem;
+
+			pr_info("AMD Geode RNG detected\n");
+			return devm_hwrng_register(&pdev->dev, &geode_rng);
+		}
 	}
-out:
-	return err;
 
-err_unmap:
-	iounmap(mem);
-	goto out;
+	/* Device not found. */
+	return -ENODEV;
 }
 
 static void __exit mod_exit(void)
 {
-	void __iomem *mem = (void __iomem *)geode_rng.priv;
-
-	hwrng_unregister(&geode_rng);
-	iounmap(mem);
 }
 
 module_init(mod_init);
-- 
2.5.0
