Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9780CEEAA4E
	for <linux-crypto@archiver.kernel.org>; Thu, 14 Sep 2023 15:04:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240629AbjINPEc (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 14 Sep 2023 11:04:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240536AbjINPE1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 14 Sep 2023 11:04:27 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BED191FC2
        for <linux-crypto@vger.kernel.org>; Thu, 14 Sep 2023 08:04:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694703863; x=1726239863;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=EAZ+vwVkqFQnTej1nPjNWrzaBMlYuKif+2RPCaApkDw=;
  b=adJWRXuaN8uonNvjxLOgcxCBH2mTISzYvAXDmVssa9btnbzcRM5Fc6AG
   m0GGW8Q+sz2faSvWryW8i6fU+zFbd29eTHq0GX1kcNkAabBbVdYjl2dGK
   hK97P2qDf6SqvdCbk7pr8m8KxBv8di/yF42Q3HZ3pkrS5GSrXzji/Wo5c
   a/IhU8JsTeRXQdiTbLcM6mN56DnS5BaFuZZMPY1IIDHWlE+PhoimWR+YU
   eQ+bodG+QtqL4Bo+1UpzJ9NEkIjncyyd063LXdlFReFeXJrgd9TgVqOfp
   9OgjIolV+rz/V+cbaKSLprdZ4xrKyhufYqtpGQchEh+aeSlw3IEDicfTe
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10833"; a="381679569"
X-IronPort-AV: E=Sophos;i="6.02,146,1688454000"; 
   d="scan'208";a="381679569"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2023 07:35:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10833"; a="810089509"
X-IronPort-AV: E=Sophos;i="6.02,146,1688454000"; 
   d="scan'208";a="810089509"
Received: from silpixa00400295.ir.intel.com ([10.237.213.194])
  by fmsmga008.fm.intel.com with ESMTP; 14 Sep 2023 07:35:03 -0700
From:   Adam Guerin <adam.guerin@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 1/2] crypto: qat - consolidate services structure
Date:   Thu, 14 Sep 2023 15:14:12 +0100
Message-Id: <20230914141413.466155-2-adam.guerin@intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230914141413.466155-1-adam.guerin@intel.com>
References: <20230914141413.466155-1-adam.guerin@intel.com>
MIME-Version: 1.0
Organisation: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare, Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

The data structure that associates a service id with its name is
replicated across the driver.
Remove duplication by moving this data structure to a new include file,
adf_cfg_services.h in order to have consistency across the drivers.

Note that the data structure is re-instantiated every time the new
include is added to a compilation unit.

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 .../intel/qat/qat_4xxx/adf_4xxx_hw_data.c     | 27 ++-------------
 drivers/crypto/intel/qat/qat_4xxx/adf_drv.c   | 33 +++----------------
 .../intel/qat/qat_common/adf_cfg_services.h   | 32 ++++++++++++++++++
 .../crypto/intel/qat/qat_common/adf_sysfs.c   | 17 ++--------
 4 files changed, 42 insertions(+), 67 deletions(-)
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_cfg_services.h

diff --git a/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c b/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
index dd4464b7e00b..cc2285b9f17b 100644
--- a/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
@@ -11,6 +11,7 @@
 #include <adf_gen4_pm.h>
 #include <adf_gen4_timer.h>
 #include "adf_4xxx_hw_data.h"
+#include "adf_cfg_services.h"
 #include "icp_qat_hw.h"
 
 enum adf_fw_objs {
@@ -100,30 +101,6 @@ static struct adf_hw_device_class adf_4xxx_class = {
 	.instances = 0,
 };
 
-enum dev_services {
-	SVC_CY = 0,
-	SVC_CY2,
-	SVC_DC,
-	SVC_SYM,
-	SVC_ASYM,
-	SVC_DC_ASYM,
-	SVC_ASYM_DC,
-	SVC_DC_SYM,
-	SVC_SYM_DC,
-};
-
-static const char *const dev_cfg_services[] = {
-	[SVC_CY] = ADF_CFG_CY,
-	[SVC_CY2] = ADF_CFG_ASYM_SYM,
-	[SVC_DC] = ADF_CFG_DC,
-	[SVC_SYM] = ADF_CFG_SYM,
-	[SVC_ASYM] = ADF_CFG_ASYM,
-	[SVC_DC_ASYM] = ADF_CFG_DC_ASYM,
-	[SVC_ASYM_DC] = ADF_CFG_ASYM_DC,
-	[SVC_DC_SYM] = ADF_CFG_DC_SYM,
-	[SVC_SYM_DC] = ADF_CFG_SYM_DC,
-};
-
 static int get_service_enabled(struct adf_accel_dev *accel_dev)
 {
 	char services[ADF_CFG_MAX_VAL_LEN_IN_BYTES] = {0};
@@ -137,7 +114,7 @@ static int get_service_enabled(struct adf_accel_dev *accel_dev)
 		return ret;
 	}
 
-	ret = match_string(dev_cfg_services, ARRAY_SIZE(dev_cfg_services),
+	ret = match_string(adf_cfg_services, ARRAY_SIZE(adf_cfg_services),
 			   services);
 	if (ret < 0)
 		dev_err(&GET_DEV(accel_dev),
diff --git a/drivers/crypto/intel/qat/qat_4xxx/adf_drv.c b/drivers/crypto/intel/qat/qat_4xxx/adf_drv.c
index 6d4e2e139ffa..204a00a204f2 100644
--- a/drivers/crypto/intel/qat/qat_4xxx/adf_drv.c
+++ b/drivers/crypto/intel/qat/qat_4xxx/adf_drv.c
@@ -11,6 +11,7 @@
 #include <adf_heartbeat.h>
 
 #include "adf_4xxx_hw_data.h"
+#include "adf_cfg_services.h"
 #include "qat_compression.h"
 #include "qat_crypto.h"
 #include "adf_transport_access_macros.h"
@@ -23,30 +24,6 @@ static const struct pci_device_id adf_pci_tbl[] = {
 };
 MODULE_DEVICE_TABLE(pci, adf_pci_tbl);
 
-enum configs {
-	DEV_CFG_CY = 0,
-	DEV_CFG_DC,
-	DEV_CFG_SYM,
-	DEV_CFG_ASYM,
-	DEV_CFG_ASYM_SYM,
-	DEV_CFG_ASYM_DC,
-	DEV_CFG_DC_ASYM,
-	DEV_CFG_SYM_DC,
-	DEV_CFG_DC_SYM,
-};
-
-static const char * const services_operations[] = {
-	ADF_CFG_CY,
-	ADF_CFG_DC,
-	ADF_CFG_SYM,
-	ADF_CFG_ASYM,
-	ADF_CFG_ASYM_SYM,
-	ADF_CFG_ASYM_DC,
-	ADF_CFG_DC_ASYM,
-	ADF_CFG_SYM_DC,
-	ADF_CFG_DC_SYM,
-};
-
 static void adf_cleanup_accel(struct adf_accel_dev *accel_dev)
 {
 	if (accel_dev->hw_device) {
@@ -292,16 +269,16 @@ int adf_gen4_dev_config(struct adf_accel_dev *accel_dev)
 	if (ret)
 		goto err;
 
-	ret = sysfs_match_string(services_operations, services);
+	ret = sysfs_match_string(adf_cfg_services, services);
 	if (ret < 0)
 		goto err;
 
 	switch (ret) {
-	case DEV_CFG_CY:
-	case DEV_CFG_ASYM_SYM:
+	case SVC_CY:
+	case SVC_CY2:
 		ret = adf_crypto_dev_config(accel_dev);
 		break;
-	case DEV_CFG_DC:
+	case SVC_DC:
 		ret = adf_comp_dev_config(accel_dev);
 		break;
 	default:
diff --git a/drivers/crypto/intel/qat/qat_common/adf_cfg_services.h b/drivers/crypto/intel/qat/qat_common/adf_cfg_services.h
new file mode 100644
index 000000000000..7fcb3b8f148a
--- /dev/null
+++ b/drivers/crypto/intel/qat/qat_common/adf_cfg_services.h
@@ -0,0 +1,32 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/* Copyright(c) 2023 Intel Corporation */
+#ifndef _ADF_CFG_SERVICES_H_
+#define _ADF_CFG_SERVICES_H_
+
+#include "adf_cfg_strings.h"
+
+enum adf_services {
+	SVC_CY = 0,
+	SVC_CY2,
+	SVC_DC,
+	SVC_SYM,
+	SVC_ASYM,
+	SVC_DC_ASYM,
+	SVC_ASYM_DC,
+	SVC_DC_SYM,
+	SVC_SYM_DC,
+};
+
+static const char *const adf_cfg_services[] = {
+	[SVC_CY] = ADF_CFG_CY,
+	[SVC_CY2] = ADF_CFG_ASYM_SYM,
+	[SVC_DC] = ADF_CFG_DC,
+	[SVC_SYM] = ADF_CFG_SYM,
+	[SVC_ASYM] = ADF_CFG_ASYM,
+	[SVC_DC_ASYM] = ADF_CFG_DC_ASYM,
+	[SVC_ASYM_DC] = ADF_CFG_ASYM_DC,
+	[SVC_DC_SYM] = ADF_CFG_DC_SYM,
+	[SVC_SYM_DC] = ADF_CFG_SYM_DC,
+};
+
+#endif
diff --git a/drivers/crypto/intel/qat/qat_common/adf_sysfs.c b/drivers/crypto/intel/qat/qat_common/adf_sysfs.c
index 8672cfa2800f..f4a89f7ed4e9 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_sysfs.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_sysfs.c
@@ -5,6 +5,7 @@
 #include <linux/pci.h>
 #include "adf_accel_devices.h"
 #include "adf_cfg.h"
+#include "adf_cfg_services.h"
 #include "adf_common_drv.h"
 
 static const char * const state_operations[] = {
@@ -84,18 +85,6 @@ static ssize_t state_store(struct device *dev, struct device_attribute *attr,
 	return count;
 }
 
-static const char * const services_operations[] = {
-	ADF_CFG_CY,
-	ADF_CFG_DC,
-	ADF_CFG_SYM,
-	ADF_CFG_ASYM,
-	ADF_CFG_ASYM_SYM,
-	ADF_CFG_ASYM_DC,
-	ADF_CFG_DC_ASYM,
-	ADF_CFG_SYM_DC,
-	ADF_CFG_DC_SYM,
-};
-
 static ssize_t cfg_services_show(struct device *dev, struct device_attribute *attr,
 				 char *buf)
 {
@@ -130,7 +119,7 @@ static ssize_t cfg_services_store(struct device *dev, struct device_attribute *a
 	struct adf_accel_dev *accel_dev;
 	int ret;
 
-	ret = sysfs_match_string(services_operations, buf);
+	ret = sysfs_match_string(adf_cfg_services, buf);
 	if (ret < 0)
 		return ret;
 
@@ -144,7 +133,7 @@ static ssize_t cfg_services_store(struct device *dev, struct device_attribute *a
 		return -EINVAL;
 	}
 
-	ret = adf_sysfs_update_dev_config(accel_dev, services_operations[ret]);
+	ret = adf_sysfs_update_dev_config(accel_dev, adf_cfg_services[ret]);
 	if (ret < 0)
 		return ret;
 
-- 
2.40.1

