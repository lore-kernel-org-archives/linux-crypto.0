Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D24EBCDB474
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Oct 2023 14:53:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377562AbjJTOxI (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Oct 2023 10:53:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377585AbjJTOxI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Oct 2023 10:53:08 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39713D52
        for <linux-crypto@vger.kernel.org>; Fri, 20 Oct 2023 07:53:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697813585; x=1729349585;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Iwg8hMQeepKOeZw+ct/TlXyADbXL37f3doFX8wujw5Y=;
  b=QBtMTm3HRcednU1clpR+q3//Kpjzlm+2O17m3Pybc1c7xku03OZukqg3
   REzEWEMEWDS6wjcusB6AmqzEe3kQkmVl4Wg5MaXLvnRvUusBzplnkiHNq
   xu4oMfAOq07/OO6iAYuqLm6zRYSzsb/wXUY6KO94dVWYVxtPaLlgcJeuT
   xuUwjmt/cybqQghV+CDl4jf6XY7OCupCPIWX8D+7GJK8gqCmtDl+KRDuP
   7NCzT7i5zokCkOFhmkGrsg5P0z4sCYYIo5Ri3aWJknO6lAKES5ixbPoCr
   AMtR0BggOpBu7kM/ynv6kVeg0rpI6ppkj/AkpZWrw92F+h6ZM+eDQhLW/
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10869"; a="376889198"
X-IronPort-AV: E=Sophos;i="6.03,239,1694761200"; 
   d="scan'208";a="376889198"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2023 07:53:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.03,239,1694761200"; 
   d="scan'208";a="5135234"
Received: from unknown (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.216])
  by orviesa001.jf.intel.com with ESMTP; 20 Oct 2023 07:51:51 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Damian Muszynski <damian.muszynski@intel.com>
Subject: [PATCH] crypto: qat - move adf_cfg_services
Date:   Fri, 20 Oct 2023 15:52:51 +0100
Message-ID: <20231020145257.61933-1-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The file adf_cfg_services.h cannot be included in header files since it
instantiates the structure adf_cfg_services. Move that structure to its
own file and export the symbol.

This does not introduce any functional change.

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Damian Muszynski <damian.muszynski@intel.com>
---
 .../intel/qat/qat_4xxx/adf_4xxx_hw_data.c     |  2 +-
 drivers/crypto/intel/qat/qat_common/Makefile  |  1 +
 .../intel/qat/qat_common/adf_cfg_services.c   | 21 +++++++++++++++++++
 .../intel/qat/qat_common/adf_cfg_services.h   | 14 ++-----------
 4 files changed, 25 insertions(+), 13 deletions(-)
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_cfg_services.c

diff --git a/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c b/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
index 2bba58a2c76f..0faedb5b2eb5 100644
--- a/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
@@ -4,6 +4,7 @@
 #include <adf_accel_devices.h>
 #include <adf_admin.h>
 #include <adf_cfg.h>
+#include <adf_cfg_services.h>
 #include <adf_clock.h>
 #include <adf_common_drv.h>
 #include <adf_gen4_dc.h>
@@ -13,7 +14,6 @@
 #include "adf_gen4_ras.h"
 #include <adf_gen4_timer.h>
 #include "adf_4xxx_hw_data.h"
-#include "adf_cfg_services.h"
 #include "icp_qat_hw.h"
 
 #define ADF_AE_GROUP_0		GENMASK(3, 0)
diff --git a/drivers/crypto/intel/qat/qat_common/Makefile b/drivers/crypto/intel/qat/qat_common/Makefile
index 800ad5eba16b..779a8aa0b8d2 100644
--- a/drivers/crypto/intel/qat/qat_common/Makefile
+++ b/drivers/crypto/intel/qat/qat_common/Makefile
@@ -4,6 +4,7 @@ ccflags-y += -DDEFAULT_SYMBOL_NAMESPACE=CRYPTO_QAT
 intel_qat-objs := adf_cfg.o \
 	adf_isr.o \
 	adf_ctl_drv.o \
+	adf_cfg_services.o \
 	adf_dev_mgr.o \
 	adf_init.o \
 	adf_accel_engine.o \
diff --git a/drivers/crypto/intel/qat/qat_common/adf_cfg_services.c b/drivers/crypto/intel/qat/qat_common/adf_cfg_services.c
new file mode 100644
index 000000000000..e34dcedee556
--- /dev/null
+++ b/drivers/crypto/intel/qat/qat_common/adf_cfg_services.c
@@ -0,0 +1,21 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright(c) 2023 Intel Corporation */
+
+#include <linux/export.h>
+#include "adf_cfg_services.h"
+#include "adf_cfg_strings.h"
+
+const char *const adf_cfg_services[] = {
+	[SVC_CY] = ADF_CFG_CY,
+	[SVC_CY2] = ADF_CFG_ASYM_SYM,
+	[SVC_DC] = ADF_CFG_DC,
+	[SVC_DCC] = ADF_CFG_DCC,
+	[SVC_SYM] = ADF_CFG_SYM,
+	[SVC_ASYM] = ADF_CFG_ASYM,
+	[SVC_DC_ASYM] = ADF_CFG_DC_ASYM,
+	[SVC_ASYM_DC] = ADF_CFG_ASYM_DC,
+	[SVC_DC_SYM] = ADF_CFG_DC_SYM,
+	[SVC_SYM_DC] = ADF_CFG_SYM_DC,
+};
+EXPORT_SYMBOL_GPL(adf_cfg_services);
+
diff --git a/drivers/crypto/intel/qat/qat_common/adf_cfg_services.h b/drivers/crypto/intel/qat/qat_common/adf_cfg_services.h
index b353d40c5c6d..f78fd697b4be 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_cfg_services.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_cfg_services.h
@@ -16,19 +16,9 @@ enum adf_services {
 	SVC_ASYM_DC,
 	SVC_DC_SYM,
 	SVC_SYM_DC,
+	SVC_COUNT
 };
 
-static const char *const adf_cfg_services[] = {
-	[SVC_CY] = ADF_CFG_CY,
-	[SVC_CY2] = ADF_CFG_ASYM_SYM,
-	[SVC_DC] = ADF_CFG_DC,
-	[SVC_DCC] = ADF_CFG_DCC,
-	[SVC_SYM] = ADF_CFG_SYM,
-	[SVC_ASYM] = ADF_CFG_ASYM,
-	[SVC_DC_ASYM] = ADF_CFG_DC_ASYM,
-	[SVC_ASYM_DC] = ADF_CFG_ASYM_DC,
-	[SVC_DC_SYM] = ADF_CFG_DC_SYM,
-	[SVC_SYM_DC] = ADF_CFG_SYM_DC,
-};
+extern const char *const adf_cfg_services[SVC_COUNT];
 
 #endif

base-commit: 2ce0d7cbc00a0fc65bb26203efed7ecdc98ba849
-- 
2.41.0

