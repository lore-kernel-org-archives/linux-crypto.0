From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.10 076/111] hwrng: geode - Revert managed API changes
Date: Tue, 28 Mar 2017 14:31:02 +0200
Message-ID: <20170328122918.841904711@linuxfoundation.org>
References: <20170328122915.640228468@linuxfoundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Prarit Bhargava <prarit@redhat.com>,
        Matt Mackall <mpm@selenic.com>,
        Corentin LABBE <clabbe.montjoie@gmail.com>,
        PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        linux-crypto@vger.kernel.org, linux-geode@lists.infradead.org,
        Herbert Xu <herbert@gondor.apana.org.au>
To: linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60282 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754906AbdC1Mkg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Mar 2017 08:40:36 -0400
In-Reply-To: <20170328122915.640228468@linuxfoundation.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

4.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Prarit Bhargava <prarit@redhat.com>

commit 8c75704ebcac2ffa31ee7bcc359baf701b52bf00 upstream.

After commit e9afc746299d ("hwrng: geode - Use linux/io.h instead of
asm/io.h") the geode-rng driver uses devres with pci_dev->dev to keep
track of resources, but does not actually register a PCI driver.  This
results in the following issues:

1.  The driver leaks memory because the driver does not attach to a
device.  The driver only uses the PCI device as a reference.   devm_*()
functions will release resources on driver detach, which the geode-rng
driver will never do.  As a result,

2.  The driver cannot be reloaded because there is always a use of the
ioport and region after the first load of the driver.

Revert the changes made by  e9afc746299d ("hwrng: geode - Use linux/io.h
instead of asm/io.h").

Signed-off-by: Prarit Bhargava <prarit@redhat.com>
Fixes: 6e9b5e76882c ("hwrng: geode - Migrate to managed API")
Cc: Matt Mackall <mpm@selenic.com>
Cc: Corentin LABBE <clabbe.montjoie@gmail.com>
Cc: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Cc: Wei Yongjun <weiyongjun1@huawei.com>
Cc: linux-crypto@vger.kernel.org
Cc: linux-geode@lists.infradead.org
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/char/hw_random/geode-rng.c |   50 +++++++++++++++++++++++++------------
 1 file changed, 35 insertions(+), 15 deletions(-)

--- a/drivers/char/hw_random/geode-rng.c
+++ b/drivers/char/hw_random/geode-rng.c
@@ -31,6 +31,9 @@
 #include <linux/module.h>
 #include <linux/pci.h>
 
+
+#define PFX	KBUILD_MODNAME ": "
+
 #define GEODE_RNG_DATA_REG   0x50
 #define GEODE_RNG_STATUS_REG 0x54
 
@@ -82,6 +85,7 @@ static struct hwrng geode_rng = {
 
 static int __init mod_init(void)
 {
+	int err = -ENODEV;
 	struct pci_dev *pdev = NULL;
 	const struct pci_device_id *ent;
 	void __iomem *mem;
@@ -89,27 +93,43 @@ static int __init mod_init(void)
 
 	for_each_pci_dev(pdev) {
 		ent = pci_match_id(pci_tbl, pdev);
-		if (ent) {
-			rng_base = pci_resource_start(pdev, 0);
-			if (rng_base == 0)
-				return -ENODEV;
-
-			mem = devm_ioremap(&pdev->dev, rng_base, 0x58);
-			if (!mem)
-				return -ENOMEM;
-			geode_rng.priv = (unsigned long)mem;
-
-			pr_info("AMD Geode RNG detected\n");
-			return devm_hwrng_register(&pdev->dev, &geode_rng);
-		}
+		if (ent)
+			goto found;
 	}
-
 	/* Device not found. */
-	return -ENODEV;
+	goto out;
+
+found:
+	rng_base = pci_resource_start(pdev, 0);
+	if (rng_base == 0)
+		goto out;
+	err = -ENOMEM;
+	mem = ioremap(rng_base, 0x58);
+	if (!mem)
+		goto out;
+	geode_rng.priv = (unsigned long)mem;
+
+	pr_info("AMD Geode RNG detected\n");
+	err = hwrng_register(&geode_rng);
+	if (err) {
+		pr_err(PFX "RNG registering failed (%d)\n",
+		       err);
+		goto err_unmap;
+	}
+out:
+	return err;
+
+err_unmap:
+	iounmap(mem);
+	goto out;
 }
 
 static void __exit mod_exit(void)
 {
+	void __iomem *mem = (void __iomem *)geode_rng.priv;
+
+	hwrng_unregister(&geode_rng);
+	iounmap(mem);
 }
 
 module_init(mod_init);
