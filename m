From: LABBE Corentin <clabbe.montjoie@gmail.com>
Subject: [PATCH v2 1/5] hwrng: amd: Fix style problem with blank line
Date: Thu, 25 Aug 2016 14:16:31 +0200
Message-ID: <1472127395-32195-2-git-send-email-clabbe.montjoie@gmail.com>
References: <1472127395-32195-1-git-send-email-clabbe.montjoie@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        LABBE Corentin <clabbe.montjoie@gmail.com>
To: mpm@selenic.com, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1472127395-32195-1-git-send-email-clabbe.montjoie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Some blank line are unncessary, and one is missing after declaration.
This patch fix thoses style problems.

Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
---
 drivers/char/hw_random/amd-rng.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/char/hw_random/amd-rng.c b/drivers/char/hw_random/amd-rng.c
index 48f6a83..45b7965 100644
--- a/drivers/char/hw_random/amd-rng.c
+++ b/drivers/char/hw_random/amd-rng.c
@@ -31,10 +31,8 @@
 #include <linux/delay.h>
 #include <asm/io.h>
 
-
 #define PFX	KBUILD_MODNAME ": "
 
-
 /*
  * Data for PCI driver interface
  *
@@ -52,7 +50,6 @@ MODULE_DEVICE_TABLE(pci, pci_tbl);
 
 static struct pci_dev *amd_pdev;
 
-
 static int amd_rng_data_present(struct hwrng *rng, int wait)
 {
 	u32 pmbase = (u32)rng->priv;
@@ -100,7 +97,6 @@ static void amd_rng_cleanup(struct hwrng *rng)
 	pci_write_config_byte(amd_pdev, 0x40, rnen);
 }
 
-
 static struct hwrng amd_rng = {
 	.name		= "amd",
 	.init		= amd_rng_init,
@@ -109,7 +105,6 @@ static struct hwrng amd_rng = {
 	.data_read	= amd_rng_data_read,
 };
 
-
 static int __init mod_init(void)
 {
 	int err = -ENODEV;
@@ -157,6 +152,7 @@ out:
 static void __exit mod_exit(void)
 {
 	u32 pmbase = (unsigned long)amd_rng.priv;
+
 	release_region(pmbase + 0xF0, 8);
 	hwrng_unregister(&amd_rng);
 }
-- 
2.7.3
