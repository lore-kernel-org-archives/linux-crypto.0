From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 02/26] staging: ccree: fold hash defs into queue defs
Date: Mon,  1 Jan 2018 12:06:29 +0000
Message-ID: <1514808421-21993-3-git-send-email-gilad@benyossef.com>
References: <1514808421-21993-1-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, devel@driverdev.osuosl.org,
 driverdev-devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
 Ofir Drang <ofir.drang@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1514808421-21993-1-git-send-email-gilad@benyossef.com>
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

Fold the two remaining enum in hash defs into the queue defs
that are using them and delete the hash defs include file.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/cc_hw_queue_defs.h | 13 +++++++++++++
 drivers/staging/ccree/hash_defs.h        | 23 -----------------------
 drivers/staging/ccree/ssi_driver.h       |  1 -
 3 files changed, 13 insertions(+), 24 deletions(-)
 delete mode 100644 drivers/staging/ccree/hash_defs.h

diff --git a/drivers/staging/ccree/cc_hw_queue_defs.h b/drivers/staging/ccree/cc_hw_queue_defs.h
index d691141..da5aabc 100644
--- a/drivers/staging/ccree/cc_hw_queue_defs.h
+++ b/drivers/staging/ccree/cc_hw_queue_defs.h
@@ -186,6 +186,19 @@ enum cc_hw_des_key_size {
 	END_OF_DES_KEYS = S32_MAX,
 };
 
+enum cc_hash_conf_pad {
+	HASH_PADDING_DISABLED = 0,
+	HASH_PADDING_ENABLED = 1,
+	HASH_DIGEST_RESULT_LITTLE_ENDIAN = 2,
+	HASH_CONFIG1_PADDING_RESERVE32 = S32_MAX,
+};
+
+enum cc_hash_cipher_pad {
+	DO_NOT_PAD = 0,
+	DO_PAD = 1,
+	HASH_CIPHER_DO_PADDING_RESERVE32 = S32_MAX,
+};
+
 /*****************************/
 /* Descriptor packing macros */
 /*****************************/
diff --git a/drivers/staging/ccree/hash_defs.h b/drivers/staging/ccree/hash_defs.h
deleted file mode 100644
index d527e06..0000000
--- a/drivers/staging/ccree/hash_defs.h
+++ /dev/null
@@ -1,23 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-// Copyright (C) 2012-2017 ARM Limited or its affiliates.
-
-#ifndef _HASH_DEFS_H_
-#define _HASH_DEFS_H_
-
-#include "cc_crypto_ctx.h"
-
-enum cc_hash_conf_pad {
-	HASH_PADDING_DISABLED = 0,
-	HASH_PADDING_ENABLED = 1,
-	HASH_DIGEST_RESULT_LITTLE_ENDIAN = 2,
-	HASH_CONFIG1_PADDING_RESERVE32 = S32_MAX,
-};
-
-enum cc_hash_cipher_pad {
-	DO_NOT_PAD = 0,
-	DO_PAD = 1,
-	HASH_CIPHER_DO_PADDING_RESERVE32 = S32_MAX,
-};
-
-#endif /*_HASH_DEFS_H_*/
-
diff --git a/drivers/staging/ccree/ssi_driver.h b/drivers/staging/ccree/ssi_driver.h
index e8d70c8..bf3aec8 100644
--- a/drivers/staging/ccree/ssi_driver.h
+++ b/drivers/staging/ccree/ssi_driver.h
@@ -30,7 +30,6 @@
 #include "dx_reg_common.h"
 #define CC_SUPPORT_SHA CC_DEV_SHA_MAX
 #include "cc_crypto_ctx.h"
-#include "hash_defs.h"
 #include "cc_hw_queue_defs.h"
 #include "ssi_sram_mgr.h"
 
-- 
2.7.4
