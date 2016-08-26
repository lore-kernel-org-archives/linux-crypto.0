From: LABBE Corentin <clabbe.montjoie@gmail.com>
Subject: [PATCH v3 3/8] hwrng: amd: Be consitent with the driver name
Date: Fri, 26 Aug 2016 13:11:31 +0200
Message-ID: <1472209896-17197-4-git-send-email-clabbe.montjoie@gmail.com>
References: <1472209896-17197-1-git-send-email-clabbe.montjoie@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        LABBE Corentin <clabbe.montjoie@gmail.com>
To: mpm@selenic.com, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1472209896-17197-1-git-send-email-clabbe.montjoie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The driver name is displayed each time differently.
This patch make use of the same name everywhere.

Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
---
 drivers/char/hw_random/amd-rng.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/char/hw_random/amd-rng.c b/drivers/char/hw_random/amd-rng.c
index d0042f5..93157af 100644
--- a/drivers/char/hw_random/amd-rng.c
+++ b/drivers/char/hw_random/amd-rng.c
@@ -31,7 +31,7 @@
 #include <linux/delay.h>
 #include <asm/io.h>
 
-#define PFX	KBUILD_MODNAME ": "
+#define DRV_NAME "AMD768-HWRNG"
 
 /*
  * Data for PCI driver interface
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
