From: Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH 4/7] hwrng: core: Replace asm/uaccess.h by linux/uaccess.h
Date: Fri,  9 Dec 2016 15:21:36 +0100
Message-ID: <1481293299-21697-4-git-send-email-clabbe.montjoie@gmail.com>
References: <1481293299-21697-1-git-send-email-clabbe.montjoie@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Corentin Labbe <clabbe.montjoie@gmail.com>
To: mpm@selenic.com, herbert@gondor.apana.org.au, arnd@arndb.de,
        gregkh@linuxfoundation.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wj0-f195.google.com ([209.85.210.195]:35205 "EHLO
        mail-wj0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933363AbcLIOYP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Dec 2016 09:24:15 -0500
In-Reply-To: <1481293299-21697-1-git-send-email-clabbe.montjoie@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch fix the checkpatch warning about asm/uaccess.h.
In the same time, we sort the headers in alphabetical order.

Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 drivers/char/hw_random/core.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index a8e63ae..7a2e496 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -10,19 +10,19 @@
  * of the GNU General Public License, incorporated herein by reference.
  */
 
+#include <linux/delay.h>
 #include <linux/device.h>
+#include <linux/err.h>
+#include <linux/fs.h>
 #include <linux/hw_random.h>
-#include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/fs.h>
-#include <linux/sched.h>
-#include <linux/miscdevice.h>
 #include <linux/kthread.h>
-#include <linux/delay.h>
-#include <linux/slab.h>
+#include <linux/miscdevice.h>
+#include <linux/module.h>
 #include <linux/random.h>
-#include <linux/err.h>
-#include <asm/uaccess.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+#include <linux/uaccess.h>
 
 #define RNG_MODULE_NAME		"hw_random"
 #define PFX			RNG_MODULE_NAME ": "
-- 
2.7.3
