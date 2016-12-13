From: Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH v2 4/7] hwrng: core: Replace asm/uaccess.h by linux/uaccess.h
Date: Tue, 13 Dec 2016 15:51:12 +0100
Message-ID: <20161213145115.30082-4-clabbe.montjoie@gmail.com>
References: <20161213145115.30082-1-clabbe.montjoie@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Corentin Labbe <clabbe.montjoie@gmail.com>
To: mpm@selenic.com, herbert@gondor.apana.org.au, arnd@arndb.de,
        gregkh@linuxfoundation.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20161213145115.30082-1-clabbe.montjoie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

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
2.10.2
