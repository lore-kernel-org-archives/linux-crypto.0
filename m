From: Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH 5/7] hwrng: core: Move hwrng miscdev minor number to include/linux/miscdevice.h
Date: Fri,  9 Dec 2016 15:21:37 +0100
Message-ID: <1481293299-21697-5-git-send-email-clabbe.montjoie@gmail.com>
References: <1481293299-21697-1-git-send-email-clabbe.montjoie@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Corentin Labbe <clabbe.montjoie@gmail.com>
To: mpm@selenic.com, herbert@gondor.apana.org.au, arnd@arndb.de,
        gregkh@linuxfoundation.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1481293299-21697-1-git-send-email-clabbe.montjoie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This patch move the define for hwrng's miscdev minor number to
include/linux/miscdevice.h.
It's better that all minor number are in the same place.
Rename it to HWRNG_MINOR (from RNG_MISCDEV_MINOR) in he process since
no other miscdev define have MISCDEV in their name.

Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 drivers/char/hw_random/core.c | 3 +--
 include/linux/miscdevice.h    | 1 +
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index 7a2e496..1e1e385 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -26,7 +26,6 @@
 
 #define RNG_MODULE_NAME		"hw_random"
 #define PFX			RNG_MODULE_NAME ": "
-#define RNG_MISCDEV_MINOR	183 /* official */
 
 static struct hwrng *current_rng;
 static struct task_struct *hwrng_fill;
@@ -283,7 +282,7 @@ static const struct file_operations rng_chrdev_ops = {
 static const struct attribute_group *rng_dev_groups[];
 
 static struct miscdevice rng_miscdev = {
-	.minor		= RNG_MISCDEV_MINOR,
+	.minor		= HWRNG_MINOR,
 	.name		= RNG_MODULE_NAME,
 	.nodename	= "hwrng",
 	.fops		= &rng_chrdev_ops,
diff --git a/include/linux/miscdevice.h b/include/linux/miscdevice.h
index 722698a..659f586 100644
--- a/include/linux/miscdevice.h
+++ b/include/linux/miscdevice.h
@@ -31,6 +31,7 @@
 #define SGI_MMTIMER		153
 #define STORE_QUEUE_MINOR	155	/* unused */
 #define I2O_MINOR		166
+#define HWRNG_MINOR		183
 #define MICROCODE_MINOR		184
 #define VFIO_MINOR		196
 #define TUN_MINOR		200
-- 
2.7.3
