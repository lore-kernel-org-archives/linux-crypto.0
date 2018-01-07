From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH v3 25/27] staging: ccree: remove unneeded includes
Date: Sun,  7 Jan 2018 12:14:36 +0000
Message-ID: <1515327285-8948-26-git-send-email-gilad@benyossef.com>
References: <1515327285-8948-1-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, devel@driverdev.osuosl.org,
 driverdev-devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
 Ofir Drang <ofir.drang@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1515327285-8948-1-git-send-email-gilad@benyossef.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
List-Id: linux-crypto.vger.kernel.org

Remove include files not needed for compilation.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/cc_aead.c        |  7 -------
 drivers/staging/ccree/cc_buffer_mgr.c  |  6 ------
 drivers/staging/ccree/cc_cipher.c      |  4 ----
 drivers/staging/ccree/cc_driver.c      | 31 -------------------------------
 drivers/staging/ccree/cc_hash.c        |  2 --
 drivers/staging/ccree/cc_ivgen.c       |  1 -
 drivers/staging/ccree/cc_pm.c          |  2 --
 drivers/staging/ccree/cc_request_mgr.c |  5 -----
 8 files changed, 58 deletions(-)

diff --git a/drivers/staging/ccree/cc_aead.c b/drivers/staging/ccree/cc_aead.c
index da74423..265adff 100644
--- a/drivers/staging/ccree/cc_aead.c
+++ b/drivers/staging/ccree/cc_aead.c
@@ -3,18 +3,11 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/platform_device.h>
 #include <crypto/algapi.h>
-#include <crypto/internal/skcipher.h>
-#include <crypto/internal/hash.h>
 #include <crypto/internal/aead.h>
-#include <crypto/sha.h>
-#include <crypto/ctr.h>
 #include <crypto/authenc.h>
-#include <crypto/aes.h>
 #include <crypto/des.h>
 #include <linux/rtnetlink.h>
-#include <linux/version.h>
 #include "cc_driver.h"
 #include "cc_buffer_mgr.h"
 #include "cc_aead.h"
diff --git a/drivers/staging/ccree/cc_buffer_mgr.c b/drivers/staging/ccree/cc_buffer_mgr.c
index 01c786c..14b2eab 100644
--- a/drivers/staging/ccree/cc_buffer_mgr.c
+++ b/drivers/staging/ccree/cc_buffer_mgr.c
@@ -1,17 +1,11 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
 
-#include <linux/crypto.h>
-#include <linux/version.h>
-#include <crypto/algapi.h>
 #include <crypto/internal/aead.h>
-#include <crypto/hash.h>
 #include <crypto/authenc.h>
 #include <crypto/scatterwalk.h>
 #include <linux/dmapool.h>
 #include <linux/dma-mapping.h>
-#include <linux/module.h>
-#include <linux/platform_device.h>
 
 #include "cc_buffer_mgr.h"
 #include "cc_lli_defs.h"
diff --git a/drivers/staging/ccree/cc_cipher.c b/drivers/staging/ccree/cc_cipher.c
index eca0578..8afdbc1 100644
--- a/drivers/staging/ccree/cc_cipher.c
+++ b/drivers/staging/ccree/cc_cipher.c
@@ -3,12 +3,8 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/platform_device.h>
-#include <linux/semaphore.h>
 #include <crypto/algapi.h>
 #include <crypto/internal/skcipher.h>
-#include <crypto/aes.h>
-#include <crypto/ctr.h>
 #include <crypto/des.h>
 #include <crypto/xts.h>
 #include <crypto/scatterwalk.h>
diff --git a/drivers/staging/ccree/cc_driver.c b/drivers/staging/ccree/cc_driver.c
index 98d491e..b49bc25 100644
--- a/drivers/staging/ccree/cc_driver.c
+++ b/drivers/staging/ccree/cc_driver.c
@@ -5,43 +5,12 @@
 #include <linux/module.h>
 
 #include <linux/crypto.h>
-#include <crypto/algapi.h>
-#include <crypto/aes.h>
-#include <crypto/sha.h>
-#include <crypto/aead.h>
-#include <crypto/authenc.h>
-#include <crypto/scatterwalk.h>
-#include <crypto/internal/skcipher.h>
-
-#include <linux/init.h>
 #include <linux/moduleparam.h>
 #include <linux/types.h>
-#include <linux/random.h>
-#include <linux/ioport.h>
 #include <linux/interrupt.h>
-#include <linux/fcntl.h>
-#include <linux/poll.h>
-#include <linux/proc_fs.h>
-#include <linux/mutex.h>
-#include <linux/sysctl.h>
-#include <linux/fs.h>
-#include <linux/cdev.h>
 #include <linux/platform_device.h>
-#include <linux/mm.h>
-#include <linux/delay.h>
-#include <linux/dma-mapping.h>
-#include <linux/dmapool.h>
-#include <linux/list.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
-#include <linux/pm.h>
-
-/* cache.h required for L1_CACHE_ALIGN() and cache_line_size() */
-#include <linux/cache.h>
-#include <linux/io.h>
-#include <linux/uaccess.h>
-#include <linux/pagemap.h>
-#include <linux/sched.h>
 #include <linux/of.h>
 #include <linux/clk.h>
 #include <linux/of_address.h>
diff --git a/drivers/staging/ccree/cc_hash.c b/drivers/staging/ccree/cc_hash.c
index 7c1645d..86f9ec7 100644
--- a/drivers/staging/ccree/cc_hash.c
+++ b/drivers/staging/ccree/cc_hash.c
@@ -3,10 +3,8 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/platform_device.h>
 #include <crypto/algapi.h>
 #include <crypto/hash.h>
-#include <crypto/sha.h>
 #include <crypto/md5.h>
 #include <crypto/internal/hash.h>
 
diff --git a/drivers/staging/ccree/cc_ivgen.c b/drivers/staging/ccree/cc_ivgen.c
index 43f70d4..25a3131 100644
--- a/drivers/staging/ccree/cc_ivgen.c
+++ b/drivers/staging/ccree/cc_ivgen.c
@@ -1,7 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
 
-#include <linux/platform_device.h>
 #include <crypto/ctr.h>
 #include "cc_driver.h"
 #include "cc_ivgen.h"
diff --git a/drivers/staging/ccree/cc_pm.c b/drivers/staging/ccree/cc_pm.c
index 1f5da86..c7d6b86 100644
--- a/drivers/staging/ccree/cc_pm.c
+++ b/drivers/staging/ccree/cc_pm.c
@@ -2,9 +2,7 @@
 /* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
 
 #include <linux/kernel.h>
-#include <linux/platform_device.h>
 #include <linux/interrupt.h>
-#include <crypto/ctr.h>
 #include <linux/pm_runtime.h>
 #include "cc_driver.h"
 #include "cc_buffer_mgr.h"
diff --git a/drivers/staging/ccree/cc_request_mgr.c b/drivers/staging/ccree/cc_request_mgr.c
index cbcfcc3..8372410 100644
--- a/drivers/staging/ccree/cc_request_mgr.c
+++ b/drivers/staging/ccree/cc_request_mgr.c
@@ -2,11 +2,6 @@
 /* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
 
 #include <linux/kernel.h>
-#include <linux/platform_device.h>
-#include <linux/interrupt.h>
-#include <linux/delay.h>
-#include <crypto/ctr.h>
-#include <linux/pm_runtime.h>
 #include "cc_driver.h"
 #include "cc_buffer_mgr.h"
 #include "cc_request_mgr.h"
-- 
2.7.4
