Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0148D29ACCB
	for <linux-crypto@vger.kernel.org>; Mon,  7 Jul 2025 12:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751891337; cv=none; b=WxY6dTpf5oQCIifsxXC2Sr+atJSq5jOQBalsCkhw5OLo42VI94kAZR1EtfJ17CFAsfjq59K3g0RK5JSZLTGBsISJFaYVCnhv/VuikNPO4OH9LqykjKZJ2s5m6yAcRa5iUY1scDmKQxdB+yVBjSOk6wpJaaKehN4nDtpJjEaIU2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751891337; c=relaxed/simple;
	bh=U0khWWHhUsw8NN5Pg0ryJ8B/ryEeIxRUHdKn0Asfdks=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=OxpNr7ZnhTCTT0xWG38qKNQPSgjy8FtL3r9RJ8g8GHPoP6WFi4VaN2Gk/gszuVr30kZ8aoCR0tJLw5SBJP23hAbi0hg7gbhdageZIh+HmgCrZiLg/4SRJ9GGuM45K7UvMi8h6CKbjWYa1v88uswREGr3IP5BVgZyJgYQ7AHPZtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QqDQODbr; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QqDQODbr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751891337; x=1783427337;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=U0khWWHhUsw8NN5Pg0ryJ8B/ryEeIxRUHdKn0Asfdks=;
  b=QqDQODbruirpUcCbntXM4GOFiAkS/48gj+T0Q08wfDI/W48qVZIMuA9O
   cxqZGHDSG5pDcXwXSUle3srtfS7yuEtq6vihyQzKvcAteCnCTFKJEpbfj
   bxFNnXSe0fnPSRlwZt2Ed7CTYdV4qZLiC/FBeROHT34ZuY7t68PSK/cZc
   dGFtQMUQJi9/yooeyoZ4hcHwCObLsLrsz0IZPALvWuRFMqEw5VRy63arp
   ArL+DbRqG4KOPM7v9MvmgW3QVV35mm3FFmRII/a4oXX78b7dwKpf6sKl+
   IbbcTeSU/Q2q8m/M6hi86EbT87IHjX6f+Tj6dW5TpEtFyHl9K1JU+QHRd
   g==;
X-CSE-ConnectionGUID: Rm5iPLedQzKC+kfgbxE9Dg==
X-CSE-MsgGUID: 1OeyzrshSAC5GoXkJmisPw==
X-IronPort-AV: E=McAfee;i="6800,10657,11487"; a="57779493"
X-IronPort-AV: E=Sophos;i="6.16,294,1744095600"; 
   d="scan'208";a="57779493"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2025 05:28:56 -0700
X-CSE-ConnectionGUID: UUxoc8DjSCeRXSgWQL8DCw==
X-CSE-MsgGUID: 7Mm34AwcSoyyNGQMCa+4Kw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,294,1744095600"; 
   d="scan'208";a="159474568"
Received: from t21-qat.iind.intel.com ([10.49.15.35])
  by fmviesa005.fm.intel.com with ESMTP; 07 Jul 2025 05:28:54 -0700
From: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com
Subject: [PATCH 2/2] crypto: qat - enable power management debugfs for GEN6 devices
Date: Mon,  7 Jul 2025 13:28:46 +0100
Message-Id: <20250707122846.1308115-3-suman.kumar.chakraborty@intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20250707122846.1308115-1-suman.kumar.chakraborty@intel.com>
References: <20250707122846.1308115-1-suman.kumar.chakraborty@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: George Abraham P <george.abraham.p@intel.com>

The QAT driver includes infrastructure to report power management (PM)
information via debugfs. Extend this support to QAT GEN6 devices
by exposing PM debug data through the `pm_status` file.

This implementation reports the current PM state, power management
hardware control and status registers (CSR), and per-domain power
status specific to the QAT GEN6 architecture.

The debug functionality is implemented in adf_gen6_pm_dbgfs.c
and initialized as part of the enable_pm() function.

Co-developed-by: Vijay Sundar Selvamani <vijay.sundar.selvamani@intel.com>
Signed-off-by: Vijay Sundar Selvamani <vijay.sundar.selvamani@intel.com>
Signed-off-by: George Abraham P <george.abraham.p@intel.com>
Signed-off-by: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 Documentation/ABI/testing/debugfs-driver-qat  |   2 +-
 .../intel/qat/qat_6xxx/adf_6xxx_hw_data.c     |  11 +-
 drivers/crypto/intel/qat/qat_common/Makefile  |   1 +
 .../crypto/intel/qat/qat_common/adf_gen6_pm.h |  24 ++++
 .../intel/qat/qat_common/adf_gen6_pm_dbgfs.c  | 124 ++++++++++++++++++
 5 files changed, 160 insertions(+), 2 deletions(-)
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_gen6_pm_dbgfs.c

diff --git a/Documentation/ABI/testing/debugfs-driver-qat b/Documentation/ABI/testing/debugfs-driver-qat
index bd6793760f29..3f1efbbad6ca 100644
--- a/Documentation/ABI/testing/debugfs-driver-qat
+++ b/Documentation/ABI/testing/debugfs-driver-qat
@@ -67,7 +67,7 @@ Contact:	qat-linux@intel.com
 Description:	(RO) Read returns power management information specific to the
 		QAT device.
 
-		This attribute is only available for qat_4xxx devices.
+		This attribute is only available for qat_4xxx and qat_6xxx devices.
 
 What:		/sys/kernel/debug/qat_<device>_<BDF>/cnv_errors
 Date:		January 2024
diff --git a/drivers/crypto/intel/qat/qat_6xxx/adf_6xxx_hw_data.c b/drivers/crypto/intel/qat/qat_6xxx/adf_6xxx_hw_data.c
index a21a10a8338f..ecef3dc28a91 100644
--- a/drivers/crypto/intel/qat/qat_6xxx/adf_6xxx_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_6xxx/adf_6xxx_hw_data.c
@@ -763,7 +763,16 @@ static int adf_init_device(struct adf_accel_dev *accel_dev)
 
 static int enable_pm(struct adf_accel_dev *accel_dev)
 {
-	return adf_init_admin_pm(accel_dev, ADF_GEN6_PM_DEFAULT_IDLE_FILTER);
+	int ret;
+
+	ret = adf_init_admin_pm(accel_dev, ADF_GEN6_PM_DEFAULT_IDLE_FILTER);
+	if (ret)
+		return ret;
+
+	/* Initialize PM internal data */
+	adf_gen6_init_dev_pm_data(accel_dev);
+
+	return 0;
 }
 
 static int dev_config(struct adf_accel_dev *accel_dev)
diff --git a/drivers/crypto/intel/qat/qat_common/Makefile b/drivers/crypto/intel/qat/qat_common/Makefile
index 5826180c2051..34019d8637a5 100644
--- a/drivers/crypto/intel/qat/qat_common/Makefile
+++ b/drivers/crypto/intel/qat/qat_common/Makefile
@@ -49,6 +49,7 @@ intel_qat-$(CONFIG_DEBUG_FS) += adf_cnv_dbgfs.o \
 				adf_fw_counters.o \
 				adf_gen4_pm_debugfs.o \
 				adf_gen4_tl.o \
+				adf_gen6_pm_dbgfs.o \
 				adf_heartbeat_dbgfs.o \
 				adf_heartbeat.o \
 				adf_pm_dbgfs.o \
diff --git a/drivers/crypto/intel/qat/qat_common/adf_gen6_pm.h b/drivers/crypto/intel/qat/qat_common/adf_gen6_pm.h
index 9a5b995f7ada..4c0d576e8c21 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_gen6_pm.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_gen6_pm.h
@@ -24,5 +24,29 @@ struct adf_accel_dev;
 
 /* cpm_pm_status bitfields */
 #define ADF_GEN6_PM_INIT_STATE			BIT(21)
+#define ADF_GEN6_PM_CPM_PM_STATE_MASK		GENMASK(22, 20)
+
+/* fusectl0 bitfields */
+#define ADF_GEN6_PM_ENABLE_PM_MASK		BIT(21)
+#define ADF_GEN6_PM_ENABLE_PM_IDLE_MASK		BIT(22)
+#define ADF_GEN6_PM_ENABLE_DEEP_PM_IDLE_MASK	BIT(23)
+
+/* cpm_pm_fw_init bitfields */
+#define ADF_GEN6_PM_IDLE_FILTER_MASK		GENMASK(5, 3)
+#define ADF_GEN6_PM_IDLE_ENABLE_MASK		BIT(2)
+
+/* ssm_pm_enable bitfield */
+#define ADF_GEN6_PM_SSM_PM_ENABLE_MASK		BIT(0)
+
+/* ssm_pm_domain_status bitfield */
+#define ADF_GEN6_PM_DOMAIN_POWERED_UP_MASK	BIT(0)
+
+#ifdef CONFIG_DEBUG_FS
+void adf_gen6_init_dev_pm_data(struct adf_accel_dev *accel_dev);
+#else
+static inline void adf_gen6_init_dev_pm_data(struct adf_accel_dev *accel_dev)
+{
+}
+#endif /* CONFIG_DEBUG_FS */
 
 #endif /* ADF_GEN6_PM_H */
diff --git a/drivers/crypto/intel/qat/qat_common/adf_gen6_pm_dbgfs.c b/drivers/crypto/intel/qat/qat_common/adf_gen6_pm_dbgfs.c
new file mode 100644
index 000000000000..603aefba0fdb
--- /dev/null
+++ b/drivers/crypto/intel/qat/qat_common/adf_gen6_pm_dbgfs.c
@@ -0,0 +1,124 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright(c) 2025 Intel Corporation */
+#include <linux/dma-mapping.h>
+#include <linux/export.h>
+#include <linux/string_helpers.h>
+
+#include "adf_admin.h"
+#include "adf_common_drv.h"
+#include "adf_gen6_pm.h"
+#include "adf_pm_dbgfs_utils.h"
+#include "icp_qat_fw_init_admin.h"
+
+#define PM_INFO_REGSET_ENTRY(_reg_, _field_) \
+	PM_INFO_REGSET_ENTRY_MASK(_reg_, _field_, ADF_GEN6_PM_##_field_##_MASK)
+
+static struct pm_status_row pm_fuse_rows[] = {
+	PM_INFO_REGSET_ENTRY(fusectl0, ENABLE_PM),
+	PM_INFO_REGSET_ENTRY(fusectl0, ENABLE_PM_IDLE),
+	PM_INFO_REGSET_ENTRY(fusectl0, ENABLE_DEEP_PM_IDLE),
+};
+
+static struct pm_status_row pm_info_rows[] = {
+	PM_INFO_REGSET_ENTRY(pm.status, CPM_PM_STATE),
+	PM_INFO_REGSET_ENTRY(pm.fw_init, IDLE_ENABLE),
+	PM_INFO_REGSET_ENTRY(pm.fw_init, IDLE_FILTER),
+};
+
+static struct pm_status_row pm_ssm_rows[] = {
+	PM_INFO_REGSET_ENTRY(ssm.pm_enable, SSM_PM_ENABLE),
+	PM_INFO_REGSET_ENTRY(ssm.pm_domain_status, DOMAIN_POWERED_UP),
+};
+
+static struct pm_status_row pm_csrs_rows[] = {
+	PM_INFO_REGSET_ENTRY32(pm.fw_init, CPM_PM_FW_INIT),
+	PM_INFO_REGSET_ENTRY32(pm.status, CPM_PM_STATUS),
+};
+
+static_assert(sizeof(struct icp_qat_fw_init_admin_pm_info) < PAGE_SIZE);
+
+static ssize_t adf_gen6_print_pm_status(struct adf_accel_dev *accel_dev,
+					char __user *buf, size_t count,
+					loff_t *pos)
+{
+	void __iomem *pmisc = adf_get_pmisc_base(accel_dev);
+	struct icp_qat_fw_init_admin_pm_info *pm_info;
+	dma_addr_t p_state_addr;
+	u32 *pm_info_regs;
+	size_t len = 0;
+	char *pm_kv;
+	u32 val;
+	int ret;
+
+	pm_info = kzalloc(PAGE_SIZE, GFP_KERNEL);
+	if (!pm_info)
+		return -ENOMEM;
+
+	pm_kv = kzalloc(PAGE_SIZE, GFP_KERNEL);
+	if (!pm_kv) {
+		kfree(pm_info);
+		return -ENOMEM;
+	}
+
+	p_state_addr = dma_map_single(&GET_DEV(accel_dev), pm_info, PAGE_SIZE,
+				      DMA_FROM_DEVICE);
+	ret = dma_mapping_error(&GET_DEV(accel_dev), p_state_addr);
+	if (ret)
+		goto out_free;
+
+	/* Query power management information from QAT FW */
+	ret = adf_get_pm_info(accel_dev, p_state_addr, PAGE_SIZE);
+	dma_unmap_single(&GET_DEV(accel_dev), p_state_addr, PAGE_SIZE,
+			 DMA_FROM_DEVICE);
+	if (ret)
+		goto out_free;
+
+	pm_info_regs = (u32 *)pm_info;
+
+	/* Fuse control register */
+	len += scnprintf(&pm_kv[len], PAGE_SIZE - len,
+			 "----------- PM Fuse info ---------\n");
+	len += adf_pm_scnprint_table_lower_keys(&pm_kv[len], pm_fuse_rows,
+						pm_info_regs, PAGE_SIZE - len,
+						ARRAY_SIZE(pm_fuse_rows));
+
+	/* Power management */
+	len += scnprintf(&pm_kv[len], PAGE_SIZE - len,
+			 "----------- PM Info --------------\n");
+
+	len += adf_pm_scnprint_table_lower_keys(&pm_kv[len], pm_info_rows,
+						pm_info_regs, PAGE_SIZE - len,
+						ARRAY_SIZE(pm_info_rows));
+	len += scnprintf(&pm_kv[len], PAGE_SIZE - len, "pm_mode: ACTIVE\n");
+
+	/* Shared Slice Module */
+	len += scnprintf(&pm_kv[len], PAGE_SIZE - len,
+			 "----------- SSM_PM Info ----------\n");
+	len += adf_pm_scnprint_table_lower_keys(&pm_kv[len], pm_ssm_rows,
+						pm_info_regs, PAGE_SIZE - len,
+						ARRAY_SIZE(pm_ssm_rows));
+
+	/* Control status register content */
+	len += scnprintf(&pm_kv[len], PAGE_SIZE - len,
+			 "----------- HW PM CSRs -----------\n");
+	len += adf_pm_scnprint_table_upper_keys(&pm_kv[len], pm_csrs_rows,
+						pm_info_regs, PAGE_SIZE - len,
+						ARRAY_SIZE(pm_csrs_rows));
+
+	val = ADF_CSR_RD(pmisc, ADF_GEN6_PM_INTERRUPT);
+	len += scnprintf(&pm_kv[len], PAGE_SIZE - len, "CPM_PM_INTERRUPT: %#x\n", val);
+	ret = simple_read_from_buffer(buf, count, pos, pm_kv, len);
+
+out_free:
+	kfree(pm_info);
+	kfree(pm_kv);
+
+	return ret;
+}
+
+void adf_gen6_init_dev_pm_data(struct adf_accel_dev *accel_dev)
+{
+	accel_dev->power_management.print_pm_status = adf_gen6_print_pm_status;
+	accel_dev->power_management.present = true;
+}
+EXPORT_SYMBOL_GPL(adf_gen6_init_dev_pm_data);
-- 
2.40.1

