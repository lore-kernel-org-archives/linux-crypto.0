Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66B79CDB474
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Oct 2023 10:35:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376910AbjJTKfT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Oct 2023 06:35:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376881AbjJTKfN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Oct 2023 06:35:13 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA765D5F
        for <linux-crypto@vger.kernel.org>; Fri, 20 Oct 2023 03:35:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697798108; x=1729334108;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MLQg4DmJSGx+dGiUYR+M9dU3ue1hf93ug5L+Or0WW2Y=;
  b=bIUzBuzNCkDqW9X5xyDLf/SoFVGNfOhriRvw8opYDxjt6JHeS5HDSVPK
   uKr9Dt+zKqYObTCTIRn9RqMoYDCEVyvSyzJf/WhE1zinQbxtEdMPGO7vx
   YEfau4+cWO+I6Jat7GI39LMT191LojS4t1S3tADKD4Vw4j0txA8mu/U1+
   ANtEJc37mmM0dLyhJhrJIOsUfcFC62HQaVDzBmADO45DVi6bQ+OZanLgV
   1szDNAP4qQciHP1/nsGQFmA4Yw1tf8VUBab7eoGn26Lw8jZPEqtc/gTfK
   hUXu6PcOUOZlPx6vKlfK/nFH+O6T/yfjEM/PIQ7sYchEWmVNbdKVk+1Yz
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10868"; a="383686715"
X-IronPort-AV: E=Sophos;i="6.03,238,1694761200"; 
   d="scan'208";a="383686715"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2023 03:35:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10868"; a="792369941"
X-IronPort-AV: E=Sophos;i="6.03,238,1694761200"; 
   d="scan'208";a="792369941"
Received: from fl31ca105gs0706.deacluster.intel.com (HELO fl31ca105gs0706..) ([10.45.133.167])
  by orsmga001.jf.intel.com with ESMTP; 20 Oct 2023 03:35:02 -0700
From:   Shashank Gupta <shashank.gupta@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Shashank Gupta <shashank.gupta@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Tero Kristo <tero.kristo@linux.intel.com>
Subject: [PATCH 8/9] crypto: qat - add error counters
Date:   Fri, 20 Oct 2023 11:32:52 +0100
Message-ID: <20231020103431.230671-9-shashank.gupta@intel.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231020103431.230671-1-shashank.gupta@intel.com>
References: <20231020103431.230671-1-shashank.gupta@intel.com>
MIME-Version: 1.0
Organization: Intel Technology Poland sp. z o.o. - ul. Slowackiego 173, 80-298 Gdansk - KRS 101882 - NIP 957-07-52-316
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Introduce ras counters interface for counting QAT specific device
errors and expose them through the newly created qat_ras sysfs
group attribute.

This adds the following attributes:

- errors_correctable: number of correctable errors
- errors_nonfatal: number of uncorrectable non fatal errors
- errors_fatal: number of uncorrectable fatal errors
- reset_error_counters: resets all counters

These counters are initialized during device bring up and cleared
during device shutdown and are applicable only to QAT GEN4 devices.

Signed-off-by: Shashank Gupta <shashank.gupta@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Tero Kristo <tero.kristo@linux.intel.com>
---
 .../ABI/testing/sysfs-driver-qat_ras          |  42 +++++++
 drivers/crypto/intel/qat/qat_4xxx/adf_drv.c   |   1 +
 drivers/crypto/intel/qat/qat_common/Makefile  |   1 +
 .../intel/qat/qat_common/adf_accel_devices.h  |  14 +++
 .../crypto/intel/qat/qat_common/adf_init.c    |   3 +
 .../qat/qat_common/adf_sysfs_ras_counters.c   | 112 ++++++++++++++++++
 .../qat/qat_common/adf_sysfs_ras_counters.h   |  28 +++++
 7 files changed, 201 insertions(+)
 create mode 100644 Documentation/ABI/testing/sysfs-driver-qat_ras
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_sysfs_ras_counters.c
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_sysfs_ras_counters.h

diff --git a/Documentation/ABI/testing/sysfs-driver-qat_ras b/Documentation/ABI/testing/sysfs-driver-qat_ras
new file mode 100644
index 000000000000..bbdbe7aabe58
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-driver-qat_ras
@@ -0,0 +1,42 @@
+What:		/sys/bus/pci/devices/<BDF>/qat_ras/errors_correctable
+Date:		January 2024
+KernelVersion:	6.7
+Contact:	qat-linux@intel.com
+Description:	(RO) Reports the number of correctable errors detected by the device.
+
+		This attribute is only available for qat_4xxx devices.
+
+What:		/sys/bus/pci/devices/<BDF>/qat_ras/errors_nonfatal
+Date:		January 2024
+KernelVersion:	6.7
+Contact:	qat-linux@intel.com
+Description:	(RO) Reports the number of non fatal errors detected by the device.
+
+		This attribute is only available for qat_4xxx devices.
+
+What:		/sys/bus/pci/devices/<BDF>/qat_ras/errors_fatal
+Date:		January 2024
+KernelVersion:	6.7
+Contact:	qat-linux@intel.com
+Description:	(RO) Reports the number of fatal errors detected by the device.
+
+		This attribute is only available for qat_4xxx devices.
+
+What:		/sys/bus/pci/devices/<BDF>/qat_ras/reset_error_counters
+Date:		January 2024
+KernelVersion:	6.7
+Contact:	qat-linux@intel.com
+Description:	(WO) Write to resets all error counters of a device.
+
+		The following example reports how to reset the counters::
+
+			# echo 1 > /sys/bus/pci/devices/<BDF>/qat_ras/reset_error_counters
+			# cat /sys/bus/pci/devices/<BDF>/qat_ras/errors_correctable
+			0
+			# cat /sys/bus/pci/devices/<BDF>/qat_ras/errors_nonfatal
+			0
+			# cat /sys/bus/pci/devices/<BDF>/qat_ras/errors_fatal
+			0
+
+		This attribute is only available for qat_4xxx devices.
+
diff --git a/drivers/crypto/intel/qat/qat_4xxx/adf_drv.c b/drivers/crypto/intel/qat/qat_4xxx/adf_drv.c
index 2ccd1223f1ef..8f483d1197dd 100644
--- a/drivers/crypto/intel/qat/qat_4xxx/adf_drv.c
+++ b/drivers/crypto/intel/qat/qat_4xxx/adf_drv.c
@@ -418,6 +418,7 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto out_err;
 	}
 
+	accel_dev->ras_errors.enabled = true;
 	adf_dbgfs_init(accel_dev);
 
 	ret = adf_dev_up(accel_dev, true);
diff --git a/drivers/crypto/intel/qat/qat_common/Makefile b/drivers/crypto/intel/qat/qat_common/Makefile
index 151fd3c01f62..58f3c181b2ce 100644
--- a/drivers/crypto/intel/qat/qat_common/Makefile
+++ b/drivers/crypto/intel/qat/qat_common/Makefile
@@ -12,6 +12,7 @@ intel_qat-objs := adf_cfg.o \
 	adf_admin.o \
 	adf_hw_arbiter.o \
 	adf_sysfs.o \
+	adf_sysfs_ras_counters.o \
 	adf_gen2_hw_data.o \
 	adf_gen2_config.o \
 	adf_gen4_hw_data.o \
diff --git a/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h b/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h
index 65d52a07e435..197e10eb5534 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h
@@ -7,6 +7,7 @@
 #include <linux/list.h>
 #include <linux/io.h>
 #include <linux/ratelimit.h>
+#include <linux/types.h>
 #include "adf_cfg_common.h"
 #include "adf_pfvf_msg.h"
 
@@ -81,6 +82,18 @@ enum dev_sku_info {
 	DEV_SKU_UNKNOWN,
 };
 
+enum ras_errors {
+	ADF_RAS_CORR,
+	ADF_RAS_UNCORR,
+	ADF_RAS_FATAL,
+	ADF_RAS_ERRORS,
+};
+
+struct adf_error_counters {
+	atomic_t counter[ADF_RAS_ERRORS];
+	bool enabled;
+};
+
 static inline const char *get_sku_info(enum dev_sku_info info)
 {
 	switch (info) {
@@ -360,6 +373,7 @@ struct adf_accel_dev {
 			u8 pf_compat_ver;
 		} vf;
 	};
+	struct adf_error_counters ras_errors;
 	struct mutex state_lock; /* protect state of the device */
 	bool is_vf;
 	u32 accel_id;
diff --git a/drivers/crypto/intel/qat/qat_common/adf_init.c b/drivers/crypto/intel/qat/qat_common/adf_init.c
index b3cf0720cf9a..00a32efdfc59 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_init.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_init.c
@@ -9,6 +9,7 @@
 #include "adf_common_drv.h"
 #include "adf_dbgfs.h"
 #include "adf_heartbeat.h"
+#include "adf_sysfs_ras_counters.h"
 
 static LIST_HEAD(service_table);
 static DEFINE_MUTEX(service_lock);
@@ -242,6 +243,7 @@ static int adf_dev_start(struct adf_accel_dev *accel_dev)
 	set_bit(ADF_STATUS_COMP_ALGS_REGISTERED, &accel_dev->status);
 
 	adf_dbgfs_add(accel_dev);
+	adf_sysfs_start_ras(accel_dev);
 
 	return 0;
 }
@@ -268,6 +270,7 @@ static void adf_dev_stop(struct adf_accel_dev *accel_dev)
 		return;
 
 	adf_dbgfs_rm(accel_dev);
+	adf_sysfs_stop_ras(accel_dev);
 
 	clear_bit(ADF_STATUS_STARTING, &accel_dev->status);
 	clear_bit(ADF_STATUS_STARTED, &accel_dev->status);
diff --git a/drivers/crypto/intel/qat/qat_common/adf_sysfs_ras_counters.c b/drivers/crypto/intel/qat/qat_common/adf_sysfs_ras_counters.c
new file mode 100644
index 000000000000..cffe2d722995
--- /dev/null
+++ b/drivers/crypto/intel/qat/qat_common/adf_sysfs_ras_counters.c
@@ -0,0 +1,112 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright(c) 2023 Intel Corporation */
+
+#include <linux/sysfs.h>
+#include <linux/pci.h>
+#include <linux/string.h>
+
+#include "adf_common_drv.h"
+#include "adf_sysfs_ras_counters.h"
+
+static ssize_t errors_correctable_show(struct device *dev,
+				       struct device_attribute *dev_attr,
+				       char *buf)
+{
+	struct adf_accel_dev *accel_dev;
+	unsigned long counter;
+
+	accel_dev = adf_devmgr_pci_to_accel_dev(to_pci_dev(dev));
+	if (!accel_dev)
+		return -EINVAL;
+
+	counter = ADF_RAS_ERR_CTR_READ(accel_dev->ras_errors, ADF_RAS_CORR);
+	return scnprintf(buf, PAGE_SIZE, "%ld\n", counter);
+}
+
+static ssize_t errors_nonfatal_show(struct device *dev,
+				    struct device_attribute *dev_attr,
+				    char *buf)
+{
+	struct adf_accel_dev *accel_dev;
+	unsigned long counter;
+
+	accel_dev = adf_devmgr_pci_to_accel_dev(to_pci_dev(dev));
+	if (!accel_dev)
+		return -EINVAL;
+
+	counter = ADF_RAS_ERR_CTR_READ(accel_dev->ras_errors, ADF_RAS_UNCORR);
+	return scnprintf(buf, PAGE_SIZE, "%ld\n", counter);
+}
+
+static ssize_t errors_fatal_show(struct device *dev,
+				 struct device_attribute *dev_attr,
+				 char *buf)
+{
+	struct adf_accel_dev *accel_dev;
+	unsigned long counter;
+
+	accel_dev = adf_devmgr_pci_to_accel_dev(to_pci_dev(dev));
+	if (!accel_dev)
+		return -EINVAL;
+
+	counter = ADF_RAS_ERR_CTR_READ(accel_dev->ras_errors, ADF_RAS_FATAL);
+	return scnprintf(buf, PAGE_SIZE, "%ld\n", counter);
+}
+
+static ssize_t reset_error_counters_store(struct device *dev,
+					  struct device_attribute *dev_attr,
+					  const char *buf, size_t count)
+{
+	struct adf_accel_dev *accel_dev;
+
+	if (buf[0] != '1' || count != 2)
+		return -EINVAL;
+
+	accel_dev = adf_devmgr_pci_to_accel_dev(to_pci_dev(dev));
+	if (!accel_dev)
+		return -EINVAL;
+
+	ADF_RAS_ERR_CTR_CLEAR(accel_dev->ras_errors);
+
+	return count;
+}
+
+static DEVICE_ATTR_RO(errors_correctable);
+static DEVICE_ATTR_RO(errors_nonfatal);
+static DEVICE_ATTR_RO(errors_fatal);
+static DEVICE_ATTR_WO(reset_error_counters);
+
+static struct attribute *qat_ras_attrs[] = {
+	&dev_attr_errors_correctable.attr,
+	&dev_attr_errors_nonfatal.attr,
+	&dev_attr_errors_fatal.attr,
+	&dev_attr_reset_error_counters.attr,
+	NULL,
+};
+
+static struct attribute_group qat_ras_group = {
+	.attrs = qat_ras_attrs,
+	.name = "qat_ras",
+};
+
+void adf_sysfs_start_ras(struct adf_accel_dev *accel_dev)
+{
+	if (!accel_dev->ras_errors.enabled)
+		return;
+
+	ADF_RAS_ERR_CTR_CLEAR(accel_dev->ras_errors);
+
+	if (device_add_group(&GET_DEV(accel_dev), &qat_ras_group))
+		dev_err(&GET_DEV(accel_dev),
+			"Failed to create qat_ras attribute group.\n");
+}
+
+void adf_sysfs_stop_ras(struct adf_accel_dev *accel_dev)
+{
+	if (!accel_dev->ras_errors.enabled)
+		return;
+
+	device_remove_group(&GET_DEV(accel_dev), &qat_ras_group);
+
+	ADF_RAS_ERR_CTR_CLEAR(accel_dev->ras_errors);
+}
diff --git a/drivers/crypto/intel/qat/qat_common/adf_sysfs_ras_counters.h b/drivers/crypto/intel/qat/qat_common/adf_sysfs_ras_counters.h
new file mode 100644
index 000000000000..1d53234a5ff9
--- /dev/null
+++ b/drivers/crypto/intel/qat/qat_common/adf_sysfs_ras_counters.h
@@ -0,0 +1,28 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/* Copyright(c) 2023 Intel Corporation */
+
+#ifndef ADF_RAS_H
+#define ADF_RAS_H
+
+#include <linux/bitops.h>
+#include <linux/atomic.h>
+
+struct adf_accel_dev;
+
+void adf_sysfs_start_ras(struct adf_accel_dev *accel_dev);
+void adf_sysfs_stop_ras(struct adf_accel_dev *accel_dev);
+
+#define ADF_RAS_ERR_CTR_READ(ras_errors, ERR) \
+	atomic_read(&(ras_errors).counter[ERR])
+
+#define ADF_RAS_ERR_CTR_CLEAR(ras_errors) \
+	do { \
+		for (int err = 0; err < ADF_RAS_ERRORS; ++err) \
+			atomic_set(&(ras_errors).counter[err], 0); \
+	} while (0)
+
+#define ADF_RAS_ERR_CTR_INC(ras_errors, ERR) \
+	atomic_inc(&(ras_errors).counter[ERR])
+
+#endif /* ADF_RAS_H */
+
-- 
2.41.0

