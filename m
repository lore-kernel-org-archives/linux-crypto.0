From: Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH 7/7] hwrng: core: Remove two unused include
Date: Fri,  9 Dec 2016 15:21:39 +0100
Message-ID: <1481293299-21697-7-git-send-email-clabbe.montjoie@gmail.com>
References: <1481293299-21697-1-git-send-email-clabbe.montjoie@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Corentin Labbe <clabbe.montjoie@gmail.com>
To: mpm@selenic.com, herbert@gondor.apana.org.au, arnd@arndb.de,
        gregkh@linuxfoundation.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1481293299-21697-1-git-send-email-clabbe.montjoie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

linux/fs.h and linux/sched.h are useless for hw_random/core.c.
This patch remove them.

Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 drivers/char/hw_random/core.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index 5c654b5..85c9ab3 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -13,14 +13,12 @@
 #include <linux/delay.h>
 #include <linux/device.h>
 #include <linux/err.h>
-#include <linux/fs.h>
 #include <linux/hw_random.h>
 #include <linux/kernel.h>
 #include <linux/kthread.h>
 #include <linux/miscdevice.h>
 #include <linux/module.h>
 #include <linux/random.h>
-#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/uaccess.h>
 
-- 
2.7.3
