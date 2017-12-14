From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 08/10] staging: ccree: remove ssi_config.h
Date: Thu, 14 Dec 2017 14:02:45 +0000
Message-ID: <1513260170-26346-9-git-send-email-gilad@benyossef.com>
References: <1513260170-26346-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1513260170-26346-1-git-send-email-gilad@benyossef.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Now that the only thing left in ssi_config is the maximum
DMA mask length we get move that to ssi_driver.h and get
rid of the file.

All of ccree is now runtime configurable or under Kbuild control.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/cc_debugfs.c      |  1 -
 drivers/staging/ccree/ssi_aead.c        |  1 -
 drivers/staging/ccree/ssi_buffer_mgr.h  |  1 -
 drivers/staging/ccree/ssi_cipher.c      |  1 -
 drivers/staging/ccree/ssi_config.h      | 30 ------------------------------
 drivers/staging/ccree/ssi_driver.c      |  1 -
 drivers/staging/ccree/ssi_driver.h      |  4 +++-
 drivers/staging/ccree/ssi_fips.c        |  1 -
 drivers/staging/ccree/ssi_hash.c        |  1 -
 drivers/staging/ccree/ssi_ivgen.c       |  1 -
 drivers/staging/ccree/ssi_pm.c          |  1 -
 drivers/staging/ccree/ssi_pm.h          |  1 -
 drivers/staging/ccree/ssi_request_mgr.c |  1 -
 13 files changed, 3 insertions(+), 42 deletions(-)
 delete mode 100644 drivers/staging/ccree/ssi_config.h

diff --git a/drivers/staging/ccree/cc_debugfs.c b/drivers/staging/ccree/cc_debugfs.c
index 7768a7b..7cd33957 100644
--- a/drivers/staging/ccree/cc_debugfs.c
+++ b/drivers/staging/ccree/cc_debugfs.c
@@ -17,7 +17,6 @@
 #include <linux/kernel.h>
 #include <linux/debugfs.h>
 #include <linux/stringify.h>
-#include "ssi_config.h"
 #include "ssi_driver.h"
 #include "cc_crypto_ctx.h"
 
diff --git a/drivers/staging/ccree/ssi_aead.c b/drivers/staging/ccree/ssi_aead.c
index ce26e68..1522b00 100644
--- a/drivers/staging/ccree/ssi_aead.c
+++ b/drivers/staging/ccree/ssi_aead.c
@@ -28,7 +28,6 @@
 #include <crypto/des.h>
 #include <linux/rtnetlink.h>
 #include <linux/version.h>
-#include "ssi_config.h"
 #include "ssi_driver.h"
 #include "ssi_buffer_mgr.h"
 #include "ssi_aead.h"
diff --git a/drivers/staging/ccree/ssi_buffer_mgr.h b/drivers/staging/ccree/ssi_buffer_mgr.h
index da43354..395c93f 100644
--- a/drivers/staging/ccree/ssi_buffer_mgr.h
+++ b/drivers/staging/ccree/ssi_buffer_mgr.h
@@ -23,7 +23,6 @@
 
 #include <crypto/algapi.h>
 
-#include "ssi_config.h"
 #include "ssi_driver.h"
 
 enum cc_req_dma_buf_type {
diff --git a/drivers/staging/ccree/ssi_cipher.c b/drivers/staging/ccree/ssi_cipher.c
index f940568..86800a7 100644
--- a/drivers/staging/ccree/ssi_cipher.c
+++ b/drivers/staging/ccree/ssi_cipher.c
@@ -26,7 +26,6 @@
 #include <crypto/xts.h>
 #include <crypto/scatterwalk.h>
 
-#include "ssi_config.h"
 #include "ssi_driver.h"
 #include "cc_lli_defs.h"
 #include "ssi_buffer_mgr.h"
diff --git a/drivers/staging/ccree/ssi_config.h b/drivers/staging/ccree/ssi_config.h
deleted file mode 100644
index bc90ad0..0000000
--- a/drivers/staging/ccree/ssi_config.h
+++ /dev/null
@@ -1,30 +0,0 @@
-/*
- * Copyright (C) 2012-2017 ARM Limited or its affiliates.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, see <http://www.gnu.org/licenses/>.
- */
-
-/* \file ssi_config.h
- * Definitions for ARM CryptoCell Linux Crypto Driver
- */
-
-#ifndef __CC_CONFIG_H__
-#define __CC_CONFIG_H__
-
-#include <linux/version.h>
-
-/* was 32 bit, but for juno's sake it was enlarged to 48 bit */
-#define DMA_BIT_MASK_LEN	48
-
-#endif /*__CC_CONFIG_H__*/
-
diff --git a/drivers/staging/ccree/ssi_driver.c b/drivers/staging/ccree/ssi_driver.c
index 195fb27..df6d415 100644
--- a/drivers/staging/ccree/ssi_driver.c
+++ b/drivers/staging/ccree/ssi_driver.c
@@ -59,7 +59,6 @@
 #include <linux/clk.h>
 #include <linux/of_address.h>
 
-#include "ssi_config.h"
 #include "ssi_driver.h"
 #include "ssi_request_mgr.h"
 #include "ssi_buffer_mgr.h"
diff --git a/drivers/staging/ccree/ssi_driver.h b/drivers/staging/ccree/ssi_driver.h
index 12e2a8b..5a56f7a 100644
--- a/drivers/staging/ccree/ssi_driver.h
+++ b/drivers/staging/ccree/ssi_driver.h
@@ -21,7 +21,6 @@
 #ifndef __CC_DRIVER_H__
 #define __CC_DRIVER_H__
 
-#include "ssi_config.h"
 #ifdef COMP_IN_WQ
 #include <linux/workqueue.h>
 #else
@@ -56,6 +55,9 @@ extern bool cc_dump_bytes;
 #define CC_DEV_NAME_STR "cc715ree"
 #define CC_COHERENT_CACHE_PARAMS 0xEEE
 
+/* Maximum DMA mask supported by IP */
+#define DMA_BIT_MASK_LEN 48
+
 #define CC_AXI_IRQ_MASK ((1 << CC_AXIM_CFG_BRESPMASK_BIT_SHIFT) | \
 			  (1 << CC_AXIM_CFG_RRESPMASK_BIT_SHIFT) | \
 			  (1 << CC_AXIM_CFG_INFLTMASK_BIT_SHIFT) | \
diff --git a/drivers/staging/ccree/ssi_fips.c b/drivers/staging/ccree/ssi_fips.c
index a1d7782..9ca6857 100644
--- a/drivers/staging/ccree/ssi_fips.c
+++ b/drivers/staging/ccree/ssi_fips.c
@@ -17,7 +17,6 @@
 #include <linux/kernel.h>
 #include <linux/fips.h>
 
-#include "ssi_config.h"
 #include "ssi_driver.h"
 #include "ssi_fips.h"
 
diff --git a/drivers/staging/ccree/ssi_hash.c b/drivers/staging/ccree/ssi_hash.c
index 0aea404..7f3c22f 100644
--- a/drivers/staging/ccree/ssi_hash.c
+++ b/drivers/staging/ccree/ssi_hash.c
@@ -23,7 +23,6 @@
 #include <crypto/md5.h>
 #include <crypto/internal/hash.h>
 
-#include "ssi_config.h"
 #include "ssi_driver.h"
 #include "ssi_request_mgr.h"
 #include "ssi_buffer_mgr.h"
diff --git a/drivers/staging/ccree/ssi_ivgen.c b/drivers/staging/ccree/ssi_ivgen.c
index 0303c85..d1b8ce0 100644
--- a/drivers/staging/ccree/ssi_ivgen.c
+++ b/drivers/staging/ccree/ssi_ivgen.c
@@ -16,7 +16,6 @@
 
 #include <linux/platform_device.h>
 #include <crypto/ctr.h>
-#include "ssi_config.h"
 #include "ssi_driver.h"
 #include "ssi_ivgen.h"
 #include "ssi_request_mgr.h"
diff --git a/drivers/staging/ccree/ssi_pm.c b/drivers/staging/ccree/ssi_pm.c
index abc715e..5b80b59 100644
--- a/drivers/staging/ccree/ssi_pm.c
+++ b/drivers/staging/ccree/ssi_pm.c
@@ -14,7 +14,6 @@
  * along with this program; if not, see <http://www.gnu.org/licenses/>.
  */
 
-#include "ssi_config.h"
 #include <linux/kernel.h>
 #include <linux/platform_device.h>
 #include <linux/interrupt.h>
diff --git a/drivers/staging/ccree/ssi_pm.h b/drivers/staging/ccree/ssi_pm.h
index 91140a3..1f601bd 100644
--- a/drivers/staging/ccree/ssi_pm.h
+++ b/drivers/staging/ccree/ssi_pm.h
@@ -20,7 +20,6 @@
 #ifndef __CC_POWER_MGR_H__
 #define __CC_POWER_MGR_H__
 
-#include "ssi_config.h"
 #include "ssi_driver.h"
 
 #define CC_SUSPEND_TIMEOUT 3000
diff --git a/drivers/staging/ccree/ssi_request_mgr.c b/drivers/staging/ccree/ssi_request_mgr.c
index 2aa21f8..c57c588 100644
--- a/drivers/staging/ccree/ssi_request_mgr.c
+++ b/drivers/staging/ccree/ssi_request_mgr.c
@@ -14,7 +14,6 @@
  * along with this program; if not, see <http://www.gnu.org/licenses/>.
  */
 
-#include "ssi_config.h"
 #include <linux/kernel.h>
 #include <linux/platform_device.h>
 #include <linux/interrupt.h>
-- 
2.7.4
