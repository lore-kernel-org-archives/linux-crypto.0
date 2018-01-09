From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 1/5] staging: ccree: use a consistent file naming convention
Date: Tue,  9 Jan 2018 10:24:29 +0000
Message-ID: <1515493478-30454-2-git-send-email-gilad@benyossef.com>
References: <1515493478-30454-1-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
 driverdev-devel@linuxdriverproject.org, linux-crypto@vger.kernel.org,
 Ofir Drang <ofir.drang@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1515493478-30454-1-git-send-email-gilad@benyossef.com>
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

The ccree driver source files were using an inconsistent
naming convention stemming from what the company was called
when they were added.

Move to a single consistent naming convention for better
code readability.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/Makefile                       |  6 +++---
 drivers/staging/ccree/{ssi_aead.c => cc_aead.c}      | 12 ++++++------
 drivers/staging/ccree/{ssi_aead.h => cc_aead.h}      |  2 +-
 .../ccree/{ssi_buffer_mgr.c => cc_buffer_mgr.c}      |  8 ++++----
 .../ccree/{ssi_buffer_mgr.h => cc_buffer_mgr.h}      |  4 ++--
 drivers/staging/ccree/{ssi_cipher.c => cc_cipher.c}  |  8 ++++----
 drivers/staging/ccree/{ssi_cipher.h => cc_cipher.h}  |  6 +++---
 drivers/staging/ccree/cc_debugfs.c                   |  2 +-
 drivers/staging/ccree/{ssi_driver.c => cc_driver.c}  | 20 ++++++++++----------
 drivers/staging/ccree/{ssi_driver.h => cc_driver.h}  |  6 +++---
 drivers/staging/ccree/{ssi_fips.c => cc_fips.c}      |  4 ++--
 drivers/staging/ccree/{ssi_fips.h => cc_fips.h}      |  0
 drivers/staging/ccree/{ssi_hash.c => cc_hash.c}      | 10 +++++-----
 drivers/staging/ccree/{ssi_hash.h => cc_hash.h}      |  4 ++--
 drivers/staging/ccree/{dx_host.h => cc_host_regs.h}  |  0
 drivers/staging/ccree/cc_hw_queue_defs.h             |  2 +-
 drivers/staging/ccree/{ssi_ivgen.c => cc_ivgen.c}    | 10 +++++-----
 drivers/staging/ccree/{ssi_ivgen.h => cc_ivgen.h}    |  0
 .../ccree/{dx_crys_kernel.h => cc_kernel_regs.h}     |  0
 drivers/staging/ccree/{ssi_pm.c => cc_pm.c}          | 14 +++++++-------
 drivers/staging/ccree/{ssi_pm.h => cc_pm.h}          |  4 ++--
 .../ccree/{ssi_request_mgr.c => cc_request_mgr.c}    | 10 +++++-----
 .../ccree/{ssi_request_mgr.h => cc_request_mgr.h}    |  2 +-
 .../staging/ccree/{ssi_sram_mgr.c => cc_sram_mgr.c}  |  4 ++--
 .../staging/ccree/{ssi_sram_mgr.h => cc_sram_mgr.h}  |  0
 25 files changed, 69 insertions(+), 69 deletions(-)
 rename drivers/staging/ccree/{ssi_aead.c => cc_aead.c} (99%)
 rename drivers/staging/ccree/{ssi_aead.h => cc_aead.h} (99%)
 rename drivers/staging/ccree/{ssi_buffer_mgr.c => cc_buffer_mgr.c} (99%)
 rename drivers/staging/ccree/{ssi_buffer_mgr.h => cc_buffer_mgr.h} (97%)
 rename drivers/staging/ccree/{ssi_cipher.c => cc_cipher.c} (99%)
 rename drivers/staging/ccree/{ssi_cipher.h => cc_cipher.h} (95%)
 rename drivers/staging/ccree/{ssi_driver.c => cc_driver.c} (98%)
 rename drivers/staging/ccree/{ssi_driver.h => cc_driver.h} (98%)
 rename drivers/staging/ccree/{ssi_fips.c => cc_fips.c} (98%)
 rename drivers/staging/ccree/{ssi_fips.h => cc_fips.h} (100%)
 rename drivers/staging/ccree/{ssi_hash.c => cc_hash.c} (99%)
 rename drivers/staging/ccree/{ssi_hash.h => cc_hash.h} (98%)
 rename drivers/staging/ccree/{dx_host.h => cc_host_regs.h} (100%)
 rename drivers/staging/ccree/{ssi_ivgen.c => cc_ivgen.c} (98%)
 rename drivers/staging/ccree/{ssi_ivgen.h => cc_ivgen.h} (100%)
 rename drivers/staging/ccree/{dx_crys_kernel.h => cc_kernel_regs.h} (100%)
 rename drivers/staging/ccree/{ssi_pm.c => cc_pm.c} (93%)
 rename drivers/staging/ccree/{ssi_pm.h => cc_pm.h} (95%)
 rename drivers/staging/ccree/{ssi_request_mgr.c => cc_request_mgr.c} (99%)
 rename drivers/staging/ccree/{ssi_request_mgr.h => cc_request_mgr.h} (98%)
 rename drivers/staging/ccree/{ssi_sram_mgr.c => cc_sram_mgr.c} (98%)
 rename drivers/staging/ccree/{ssi_sram_mgr.h => cc_sram_mgr.h} (100%)

diff --git a/drivers/staging/ccree/Makefile b/drivers/staging/ccree/Makefile
index c107e25..bdc2797 100644
--- a/drivers/staging/ccree/Makefile
+++ b/drivers/staging/ccree/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 
 obj-$(CONFIG_CRYPTO_DEV_CCREE) := ccree.o
-ccree-y := ssi_driver.o ssi_buffer_mgr.o ssi_request_mgr.o ssi_cipher.o ssi_hash.o ssi_aead.o ssi_ivgen.o ssi_sram_mgr.o
-ccree-$(CONFIG_CRYPTO_FIPS) += ssi_fips.o
+ccree-y := cc_driver.o cc_buffer_mgr.o cc_request_mgr.o cc_cipher.o cc_hash.o cc_aead.o cc_ivgen.o cc_sram_mgr.o
+ccree-$(CONFIG_CRYPTO_FIPS) += cc_fips.o
 ccree-$(CONFIG_DEBUG_FS) += cc_debugfs.o
-ccree-$(CONFIG_PM) += ssi_pm.o
+ccree-$(CONFIG_PM) += cc_pm.o
diff --git a/drivers/staging/ccree/ssi_aead.c b/drivers/staging/ccree/cc_aead.c
similarity index 99%
rename from drivers/staging/ccree/ssi_aead.c
rename to drivers/staging/ccree/cc_aead.c
index 6f41a00..da74423 100644
--- a/drivers/staging/ccree/ssi_aead.c
+++ b/drivers/staging/ccree/cc_aead.c
@@ -15,12 +15,12 @@
 #include <crypto/des.h>
 #include <linux/rtnetlink.h>
 #include <linux/version.h>
-#include "ssi_driver.h"
-#include "ssi_buffer_mgr.h"
-#include "ssi_aead.h"
-#include "ssi_request_mgr.h"
-#include "ssi_hash.h"
-#include "ssi_sram_mgr.h"
+#include "cc_driver.h"
+#include "cc_buffer_mgr.h"
+#include "cc_aead.h"
+#include "cc_request_mgr.h"
+#include "cc_hash.h"
+#include "cc_sram_mgr.h"
 
 #define template_aead	template_u.aead
 
diff --git a/drivers/staging/ccree/ssi_aead.h b/drivers/staging/ccree/cc_aead.h
similarity index 99%
rename from drivers/staging/ccree/ssi_aead.h
rename to drivers/staging/ccree/cc_aead.h
index 9567b8f..5edf3b3 100644
--- a/drivers/staging/ccree/ssi_aead.h
+++ b/drivers/staging/ccree/cc_aead.h
@@ -1,7 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 /* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
 
-/* \file ssi_aead.h
+/* \file cc_aead.h
  * ARM CryptoCell AEAD Crypto API
  */
 
diff --git a/drivers/staging/ccree/ssi_buffer_mgr.c b/drivers/staging/ccree/cc_buffer_mgr.c
similarity index 99%
rename from drivers/staging/ccree/ssi_buffer_mgr.c
rename to drivers/staging/ccree/cc_buffer_mgr.c
index 684070d..01c786c 100644
--- a/drivers/staging/ccree/ssi_buffer_mgr.c
+++ b/drivers/staging/ccree/cc_buffer_mgr.c
@@ -13,11 +13,11 @@
 #include <linux/module.h>
 #include <linux/platform_device.h>
 
-#include "ssi_buffer_mgr.h"
+#include "cc_buffer_mgr.h"
 #include "cc_lli_defs.h"
-#include "ssi_cipher.h"
-#include "ssi_hash.h"
-#include "ssi_aead.h"
+#include "cc_cipher.h"
+#include "cc_hash.h"
+#include "cc_aead.h"
 
 enum dma_buffer_type {
 	DMA_NULL_TYPE = -1,
diff --git a/drivers/staging/ccree/ssi_buffer_mgr.h b/drivers/staging/ccree/cc_buffer_mgr.h
similarity index 97%
rename from drivers/staging/ccree/ssi_buffer_mgr.h
rename to drivers/staging/ccree/cc_buffer_mgr.h
index 0ddadd7..99b752a 100644
--- a/drivers/staging/ccree/ssi_buffer_mgr.h
+++ b/drivers/staging/ccree/cc_buffer_mgr.h
@@ -1,7 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 /* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
 
-/* \file buffer_mgr.h
+/* \file cc_buffer_mgr.h
  * Buffer Manager
  */
 
@@ -10,7 +10,7 @@
 
 #include <crypto/algapi.h>
 
-#include "ssi_driver.h"
+#include "cc_driver.h"
 
 enum cc_req_dma_buf_type {
 	CC_DMA_BUF_NULL = 0,
diff --git a/drivers/staging/ccree/ssi_cipher.c b/drivers/staging/ccree/cc_cipher.c
similarity index 99%
rename from drivers/staging/ccree/ssi_cipher.c
rename to drivers/staging/ccree/cc_cipher.c
index a0e7d00..eca0578 100644
--- a/drivers/staging/ccree/ssi_cipher.c
+++ b/drivers/staging/ccree/cc_cipher.c
@@ -13,11 +13,11 @@
 #include <crypto/xts.h>
 #include <crypto/scatterwalk.h>
 
-#include "ssi_driver.h"
+#include "cc_driver.h"
 #include "cc_lli_defs.h"
-#include "ssi_buffer_mgr.h"
-#include "ssi_cipher.h"
-#include "ssi_request_mgr.h"
+#include "cc_buffer_mgr.h"
+#include "cc_cipher.h"
+#include "cc_request_mgr.h"
 
 #define MAX_ABLKCIPHER_SEQ_LEN 6
 
diff --git a/drivers/staging/ccree/ssi_cipher.h b/drivers/staging/ccree/cc_cipher.h
similarity index 95%
rename from drivers/staging/ccree/ssi_cipher.h
rename to drivers/staging/ccree/cc_cipher.h
index 97b266b..4c181c7 100644
--- a/drivers/staging/ccree/ssi_cipher.h
+++ b/drivers/staging/ccree/cc_cipher.h
@@ -1,7 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 /* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
 
-/* \file ssi_cipher.h
+/* \file cc_cipher.h
  * ARM CryptoCell Cipher Crypto API
  */
 
@@ -10,8 +10,8 @@
 
 #include <linux/kernel.h>
 #include <crypto/algapi.h>
-#include "ssi_driver.h"
-#include "ssi_buffer_mgr.h"
+#include "cc_driver.h"
+#include "cc_buffer_mgr.h"
 
 /* Crypto cipher flags */
 #define CC_CRYPTO_CIPHER_KEY_KFDE0	BIT(0)
diff --git a/drivers/staging/ccree/cc_debugfs.c b/drivers/staging/ccree/cc_debugfs.c
index 72eb2b3..f927a73 100644
--- a/drivers/staging/ccree/cc_debugfs.c
+++ b/drivers/staging/ccree/cc_debugfs.c
@@ -4,7 +4,7 @@
 #include <linux/kernel.h>
 #include <linux/debugfs.h>
 #include <linux/stringify.h>
-#include "ssi_driver.h"
+#include "cc_driver.h"
 #include "cc_crypto_ctx.h"
 
 struct cc_debugfs_ctx {
diff --git a/drivers/staging/ccree/ssi_driver.c b/drivers/staging/ccree/cc_driver.c
similarity index 98%
rename from drivers/staging/ccree/ssi_driver.c
rename to drivers/staging/ccree/cc_driver.c
index b5df9b4..98d491e 100644
--- a/drivers/staging/ccree/ssi_driver.c
+++ b/drivers/staging/ccree/cc_driver.c
@@ -46,17 +46,17 @@
 #include <linux/clk.h>
 #include <linux/of_address.h>
 
-#include "ssi_driver.h"
-#include "ssi_request_mgr.h"
-#include "ssi_buffer_mgr.h"
+#include "cc_driver.h"
+#include "cc_request_mgr.h"
+#include "cc_buffer_mgr.h"
 #include "cc_debugfs.h"
-#include "ssi_cipher.h"
-#include "ssi_aead.h"
-#include "ssi_hash.h"
-#include "ssi_ivgen.h"
-#include "ssi_sram_mgr.h"
-#include "ssi_pm.h"
-#include "ssi_fips.h"
+#include "cc_cipher.h"
+#include "cc_aead.h"
+#include "cc_hash.h"
+#include "cc_ivgen.h"
+#include "cc_sram_mgr.h"
+#include "cc_pm.h"
+#include "cc_fips.h"
 
 bool cc_dump_desc;
 module_param_named(dump_desc, cc_dump_desc, bool, 0600);
diff --git a/drivers/staging/ccree/ssi_driver.h b/drivers/staging/ccree/cc_driver.h
similarity index 98%
rename from drivers/staging/ccree/ssi_driver.h
rename to drivers/staging/ccree/cc_driver.h
index c2b978b..773ac59 100644
--- a/drivers/staging/ccree/ssi_driver.h
+++ b/drivers/staging/ccree/cc_driver.h
@@ -1,7 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 /* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
 
-/* \file ssi_driver.h
+/* \file cc_driver.h
  * ARM CryptoCell Linux Crypto Driver
  */
 
@@ -26,11 +26,11 @@
 #include <linux/platform_device.h>
 
 /* Registers definitions from shared/hw/ree_include */
-#include "dx_host.h"
+#include "cc_host_regs.h"
 #define CC_DEV_SHA_MAX 512
 #include "cc_crypto_ctx.h"
 #include "cc_hw_queue_defs.h"
-#include "ssi_sram_mgr.h"
+#include "cc_sram_mgr.h"
 
 extern bool cc_dump_desc;
 extern bool cc_dump_bytes;
diff --git a/drivers/staging/ccree/ssi_fips.c b/drivers/staging/ccree/cc_fips.c
similarity index 98%
rename from drivers/staging/ccree/ssi_fips.c
rename to drivers/staging/ccree/cc_fips.c
index 2c58f90..b25c34e 100644
--- a/drivers/staging/ccree/ssi_fips.c
+++ b/drivers/staging/ccree/cc_fips.c
@@ -4,8 +4,8 @@
 #include <linux/kernel.h>
 #include <linux/fips.h>
 
-#include "ssi_driver.h"
-#include "ssi_fips.h"
+#include "cc_driver.h"
+#include "cc_fips.h"
 
 static void fips_dsr(unsigned long devarg);
 
diff --git a/drivers/staging/ccree/ssi_fips.h b/drivers/staging/ccree/cc_fips.h
similarity index 100%
rename from drivers/staging/ccree/ssi_fips.h
rename to drivers/staging/ccree/cc_fips.h
diff --git a/drivers/staging/ccree/ssi_hash.c b/drivers/staging/ccree/cc_hash.c
similarity index 99%
rename from drivers/staging/ccree/ssi_hash.c
rename to drivers/staging/ccree/cc_hash.c
index 57031c7..7c1645d 100644
--- a/drivers/staging/ccree/ssi_hash.c
+++ b/drivers/staging/ccree/cc_hash.c
@@ -10,11 +10,11 @@
 #include <crypto/md5.h>
 #include <crypto/internal/hash.h>
 
-#include "ssi_driver.h"
-#include "ssi_request_mgr.h"
-#include "ssi_buffer_mgr.h"
-#include "ssi_hash.h"
-#include "ssi_sram_mgr.h"
+#include "cc_driver.h"
+#include "cc_request_mgr.h"
+#include "cc_buffer_mgr.h"
+#include "cc_hash.h"
+#include "cc_sram_mgr.h"
 
 #define CC_MAX_HASH_SEQ_LEN 12
 #define CC_MAX_OPAD_KEYS_SIZE CC_MAX_HASH_BLCK_SIZE
diff --git a/drivers/staging/ccree/ssi_hash.h b/drivers/staging/ccree/cc_hash.h
similarity index 98%
rename from drivers/staging/ccree/ssi_hash.h
rename to drivers/staging/ccree/cc_hash.h
index e45bb69..aa42b8f 100644
--- a/drivers/staging/ccree/ssi_hash.h
+++ b/drivers/staging/ccree/cc_hash.h
@@ -1,14 +1,14 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 /* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
 
-/* \file ssi_hash.h
+/* \file cc_hash.h
  * ARM CryptoCell Hash Crypto API
  */
 
 #ifndef __CC_HASH_H__
 #define __CC_HASH_H__
 
-#include "ssi_buffer_mgr.h"
+#include "cc_buffer_mgr.h"
 
 #define HMAC_IPAD_CONST	0x36363636
 #define HMAC_OPAD_CONST	0x5C5C5C5C
diff --git a/drivers/staging/ccree/dx_host.h b/drivers/staging/ccree/cc_host_regs.h
similarity index 100%
rename from drivers/staging/ccree/dx_host.h
rename to drivers/staging/ccree/cc_host_regs.h
diff --git a/drivers/staging/ccree/cc_hw_queue_defs.h b/drivers/staging/ccree/cc_hw_queue_defs.h
index bfc18b3..a79f28ce 100644
--- a/drivers/staging/ccree/cc_hw_queue_defs.h
+++ b/drivers/staging/ccree/cc_hw_queue_defs.h
@@ -6,7 +6,7 @@
 
 #include <linux/types.h>
 
-#include "dx_crys_kernel.h"
+#include "cc_kernel_regs.h"
 #include <linux/bitfield.h>
 
 /******************************************************************************
diff --git a/drivers/staging/ccree/ssi_ivgen.c b/drivers/staging/ccree/cc_ivgen.c
similarity index 98%
rename from drivers/staging/ccree/ssi_ivgen.c
rename to drivers/staging/ccree/cc_ivgen.c
index 2ba15a5..43f70d4 100644
--- a/drivers/staging/ccree/ssi_ivgen.c
+++ b/drivers/staging/ccree/cc_ivgen.c
@@ -3,11 +3,11 @@
 
 #include <linux/platform_device.h>
 #include <crypto/ctr.h>
-#include "ssi_driver.h"
-#include "ssi_ivgen.h"
-#include "ssi_request_mgr.h"
-#include "ssi_sram_mgr.h"
-#include "ssi_buffer_mgr.h"
+#include "cc_driver.h"
+#include "cc_ivgen.h"
+#include "cc_request_mgr.h"
+#include "cc_sram_mgr.h"
+#include "cc_buffer_mgr.h"
 
 /* The max. size of pool *MUST* be <= SRAM total size */
 #define CC_IVPOOL_SIZE 1024
diff --git a/drivers/staging/ccree/ssi_ivgen.h b/drivers/staging/ccree/cc_ivgen.h
similarity index 100%
rename from drivers/staging/ccree/ssi_ivgen.h
rename to drivers/staging/ccree/cc_ivgen.h
diff --git a/drivers/staging/ccree/dx_crys_kernel.h b/drivers/staging/ccree/cc_kernel_regs.h
similarity index 100%
rename from drivers/staging/ccree/dx_crys_kernel.h
rename to drivers/staging/ccree/cc_kernel_regs.h
diff --git a/drivers/staging/ccree/ssi_pm.c b/drivers/staging/ccree/cc_pm.c
similarity index 93%
rename from drivers/staging/ccree/ssi_pm.c
rename to drivers/staging/ccree/cc_pm.c
index 3a8d91c..1f5da86 100644
--- a/drivers/staging/ccree/ssi_pm.c
+++ b/drivers/staging/ccree/cc_pm.c
@@ -6,13 +6,13 @@
 #include <linux/interrupt.h>
 #include <crypto/ctr.h>
 #include <linux/pm_runtime.h>
-#include "ssi_driver.h"
-#include "ssi_buffer_mgr.h"
-#include "ssi_request_mgr.h"
-#include "ssi_sram_mgr.h"
-#include "ssi_ivgen.h"
-#include "ssi_hash.h"
-#include "ssi_pm.h"
+#include "cc_driver.h"
+#include "cc_buffer_mgr.h"
+#include "cc_request_mgr.h"
+#include "cc_sram_mgr.h"
+#include "cc_ivgen.h"
+#include "cc_hash.h"
+#include "cc_pm.h"
 
 #define POWER_DOWN_ENABLE 0x01
 #define POWER_DOWN_DISABLE 0x00
diff --git a/drivers/staging/ccree/ssi_pm.h b/drivers/staging/ccree/cc_pm.h
similarity index 95%
rename from drivers/staging/ccree/ssi_pm.h
rename to drivers/staging/ccree/cc_pm.h
index f603255..aac8190 100644
--- a/drivers/staging/ccree/ssi_pm.h
+++ b/drivers/staging/ccree/cc_pm.h
@@ -1,13 +1,13 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 /* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
 
-/* \file ssi_pm.h
+/* \file cc_pm.h
  */
 
 #ifndef __CC_POWER_MGR_H__
 #define __CC_POWER_MGR_H__
 
-#include "ssi_driver.h"
+#include "cc_driver.h"
 
 #define CC_SUSPEND_TIMEOUT 3000
 
diff --git a/drivers/staging/ccree/ssi_request_mgr.c b/drivers/staging/ccree/cc_request_mgr.c
similarity index 99%
rename from drivers/staging/ccree/ssi_request_mgr.c
rename to drivers/staging/ccree/cc_request_mgr.c
index dc3be29..cbcfcc3 100644
--- a/drivers/staging/ccree/ssi_request_mgr.c
+++ b/drivers/staging/ccree/cc_request_mgr.c
@@ -7,11 +7,11 @@
 #include <linux/delay.h>
 #include <crypto/ctr.h>
 #include <linux/pm_runtime.h>
-#include "ssi_driver.h"
-#include "ssi_buffer_mgr.h"
-#include "ssi_request_mgr.h"
-#include "ssi_ivgen.h"
-#include "ssi_pm.h"
+#include "cc_driver.h"
+#include "cc_buffer_mgr.h"
+#include "cc_request_mgr.h"
+#include "cc_ivgen.h"
+#include "cc_pm.h"
 
 #define CC_MAX_POLL_ITER	10
 /* The highest descriptor count in used */
diff --git a/drivers/staging/ccree/ssi_request_mgr.h b/drivers/staging/ccree/cc_request_mgr.h
similarity index 98%
rename from drivers/staging/ccree/ssi_request_mgr.h
rename to drivers/staging/ccree/cc_request_mgr.h
index f11a26a..573cb97 100644
--- a/drivers/staging/ccree/ssi_request_mgr.h
+++ b/drivers/staging/ccree/cc_request_mgr.h
@@ -1,7 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 /* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
 
-/* \file request_mgr.h
+/* \file cc_request_mgr.h
  * Request Manager
  */
 
diff --git a/drivers/staging/ccree/ssi_sram_mgr.c b/drivers/staging/ccree/cc_sram_mgr.c
similarity index 98%
rename from drivers/staging/ccree/ssi_sram_mgr.c
rename to drivers/staging/ccree/cc_sram_mgr.c
index c5497aa..d1f8a9c 100644
--- a/drivers/staging/ccree/ssi_sram_mgr.c
+++ b/drivers/staging/ccree/cc_sram_mgr.c
@@ -1,8 +1,8 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
 
-#include "ssi_driver.h"
-#include "ssi_sram_mgr.h"
+#include "cc_driver.h"
+#include "cc_sram_mgr.h"
 
 /**
  * struct cc_sram_ctx -Internal RAM context manager
diff --git a/drivers/staging/ccree/ssi_sram_mgr.h b/drivers/staging/ccree/cc_sram_mgr.h
similarity index 100%
rename from drivers/staging/ccree/ssi_sram_mgr.h
rename to drivers/staging/ccree/cc_sram_mgr.h
-- 
2.7.4
