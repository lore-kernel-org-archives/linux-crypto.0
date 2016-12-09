From: Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH 1/7] hwrng: core: do not use multiple blank lines
Date: Fri,  9 Dec 2016 15:21:33 +0100
Message-ID: <1481293299-21697-1-git-send-email-clabbe.montjoie@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Corentin Labbe <clabbe.montjoie@gmail.com>
To: mpm@selenic.com, herbert@gondor.apana.org.au, arnd@arndb.de,
        gregkh@linuxfoundation.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wj0-f194.google.com ([209.85.210.194]:32982 "EHLO
        mail-wj0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932343AbcLIOYM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Dec 2016 09:24:12 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch fix the checkpatch warning "Please don't use multiple blank lines"

Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 drivers/char/hw_random/core.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index d2d2c89..00cbb81 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -30,7 +30,6 @@
 
  */
 
-
 #include <linux/device.h>
 #include <linux/hw_random.h>
 #include <linux/module.h>
@@ -45,12 +44,10 @@
 #include <linux/err.h>
 #include <asm/uaccess.h>
 
-
 #define RNG_MODULE_NAME		"hw_random"
 #define PFX			RNG_MODULE_NAME ": "
 #define RNG_MISCDEV_MINOR	183 /* official */
 
-
 static struct hwrng *current_rng;
 static struct task_struct *hwrng_fill;
 static LIST_HEAD(rng_list);
@@ -296,7 +293,6 @@ static ssize_t rng_dev_read(struct file *filp, char __user *buf,
 	goto out;
 }
 
-
 static const struct file_operations rng_chrdev_ops = {
 	.owner		= THIS_MODULE,
 	.open		= rng_dev_open,
@@ -314,7 +310,6 @@ static struct miscdevice rng_miscdev = {
 	.groups		= rng_dev_groups,
 };
 
-
 static ssize_t hwrng_attr_current_store(struct device *dev,
 					struct device_attribute *attr,
 					const char *buf, size_t len)
-- 
2.7.3
