From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH v2 03/27] staging: ccree: fold reg common defines into driver
Date: Wed,  3 Jan 2018 13:35:10 +0000
Message-ID: <1514986544-5888-4-git-send-email-gilad@benyossef.com>
References: <1514986544-5888-1-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, devel@driverdev.osuosl.org,
 driverdev-devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
 Ofir Drang <ofir.drang@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1514986544-5888-1-git-send-email-gilad@benyossef.com>
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

Fold the 2 macro defined in dx_reg_common.h into the file they
are used in and delete the file.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/cc_crypto_ctx.h |  4 ++--
 drivers/staging/ccree/dx_reg_common.h | 13 -------------
 drivers/staging/ccree/ssi_driver.h    |  5 +++--
 3 files changed, 5 insertions(+), 17 deletions(-)
 delete mode 100644 drivers/staging/ccree/dx_reg_common.h

diff --git a/drivers/staging/ccree/cc_crypto_ctx.h b/drivers/staging/ccree/cc_crypto_ctx.h
index 1b2698f..88b6e88 100644
--- a/drivers/staging/ccree/cc_crypto_ctx.h
+++ b/drivers/staging/ccree/cc_crypto_ctx.h
@@ -8,7 +8,7 @@
 
 /* context size */
 #ifndef CC_CTX_SIZE_LOG2
-#if (CC_SUPPORT_SHA > 256)
+#if (CC_DEV_SHA_MAX > 256)
 #define CC_CTX_SIZE_LOG2 8
 #else
 #define CC_CTX_SIZE_LOG2 7
@@ -59,7 +59,7 @@
 #define CC_SHA384_BLOCK_SIZE 128
 #define CC_SHA512_BLOCK_SIZE 128
 
-#if (CC_SUPPORT_SHA > 256)
+#if (CC_DEV_SHA_MAX > 256)
 #define CC_DIGEST_SIZE_MAX CC_SHA512_DIGEST_SIZE
 #define CC_HASH_BLOCK_SIZE_MAX CC_SHA512_BLOCK_SIZE /*1024b*/
 #else /* Only up to SHA256 */
diff --git a/drivers/staging/ccree/dx_reg_common.h b/drivers/staging/ccree/dx_reg_common.h
deleted file mode 100644
index 84184d2..0000000
--- a/drivers/staging/ccree/dx_reg_common.h
+++ /dev/null
@@ -1,13 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0-only */
-/* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
-
-#ifndef __CC_REG_COMMON_H__
-#define __CC_REG_COMMON_H__
-
-#define CC_DEV_SIGNATURE 0xDCC71200UL
-
-#define CC_HW_VERSION 0xef840015UL
-
-#define CC_DEV_SHA_MAX 512
-
-#endif /*__CC_REG_COMMON_H__*/
diff --git a/drivers/staging/ccree/ssi_driver.h b/drivers/staging/ccree/ssi_driver.h
index b978862..3810740 100644
--- a/drivers/staging/ccree/ssi_driver.h
+++ b/drivers/staging/ccree/ssi_driver.h
@@ -27,8 +27,7 @@
 
 /* Registers definitions from shared/hw/ree_include */
 #include "dx_host.h"
-#include "dx_reg_common.h"
-#define CC_SUPPORT_SHA CC_DEV_SHA_MAX
+#define CC_DEV_SHA_MAX 512
 #include "cc_crypto_ctx.h"
 #include "cc_hw_queue_defs.h"
 #include "ssi_sram_mgr.h"
@@ -44,6 +43,8 @@ extern bool cc_dump_bytes;
 /* Maximum DMA mask supported by IP */
 #define DMA_BIT_MASK_LEN 48
 
+#define CC_DEV_SIGNATURE 0xDCC71200UL
+
 #define CC_AXI_IRQ_MASK ((1 << CC_AXIM_CFG_BRESPMASK_BIT_SHIFT) | \
 			  (1 << CC_AXIM_CFG_RRESPMASK_BIT_SHIFT) | \
 			  (1 << CC_AXIM_CFG_INFLTMASK_BIT_SHIFT) | \
-- 
2.7.4
