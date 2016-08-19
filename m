From: LABBE Corentin <clabbe.montjoie@gmail.com>
Subject: [PATCH 3/5] hwrng: amd: Be consitent with the driver name
Date: Fri, 19 Aug 2016 15:42:55 +0200
Message-ID: <1471614177-12380-3-git-send-email-clabbe.montjoie@gmail.com>
References: <1471614177-12380-1-git-send-email-clabbe.montjoie@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        LABBE Corentin <clabbe.montjoie@gmail.com>
To: herbert@gondor.apana.org.au, mpm@selenic.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1471614177-12380-1-git-send-email-clabbe.montjoie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The driver name is displayed each time differently.
This patch make use of the same name everywhere.

Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
---
 drivers/char/hw_random/amd-rng.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/char/hw_random/amd-rng.c b/drivers/char/hw_random/amd-rng.c
index d0042f5..d0a806a 100644
--- a/drivers/char/hw_random/amd-rng.c
+++ b/drivers/char/hw_random/amd-rng.c
@@ -31,7 +31,7 @@
 #include <linux/delay.h>
 #include <asm/io.h>
 
-#define PFX	KBUILD_MODNAME ": "
+#define DRV_NAME "AMD768-HWRNG"
 
 /*
  * Data for PCI driver interface
@@ -98,7 +98,7 @@ static void amd_rng_cleanup(struct hwrng *rng)
 }
 
 static struct hwrng amd_rng = {
-	.name		= "amd",
+	.name		= DRV_NAME,
 	.init		= amd_rng_init,
 	.cleanup	= amd_rng_cleanup,
 	.data_present	= amd_rng_data_present,
@@ -128,8 +128,8 @@ found:
 	pmbase &= 0x0000FF00;
 	if (pmbase == 0)
 		goto out;
-	if (!request_region(pmbase + 0xF0, 8, "AMD HWRNG")) {
-		dev_err(&pdev->dev, "AMD HWRNG region 0x%x already in use!\n",
+	if (!request_region(pmbase + 0xF0, 8, DRV_NAME)) {
+		dev_err(&pdev->dev, DRV_NAME " region 0x%x already in use!\n",
 			pmbase + 0xF0);
 		err = -EBUSY;
 		goto out;
@@ -137,11 +137,10 @@ found:
 	amd_rng.priv = (unsigned long)pmbase;
 	amd_pdev = pdev;
 
-	pr_info("AMD768 RNG detected\n");
+	pr_info(DRV_NAME " detected\n");
 	err = hwrng_register(&amd_rng);
 	if (err) {
-		pr_err(PFX "RNG registering failed (%d)\n",
-		       err);
+		pr_err(DRV_NAME " registering failed (%d)\n", err);
 		release_region(pmbase + 0xF0, 8);
 		goto out;
 	}
-- 
2.7.3
