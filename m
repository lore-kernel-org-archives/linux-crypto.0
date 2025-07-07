Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECC0E29ACC6
	for <linux-crypto@vger.kernel.org>; Mon,  7 Jul 2025 12:28:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751891338; cv=none; b=BcNyk54ECwcDmJFzTtPiRFe13MeynhTarPiifUF5d/bIzFFLWq3hR7+n0yKDFnxPiIw7cym9gtC+kCpSjjvgPFx4gqzRDsugSxBR5jd2Rcw7SBCKb+WO+cJLf8/xzVM2V8QblkDRw9nxKGQUoECIxIim3REq1bKCweGWZ8PNgQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751891338; c=relaxed/simple;
	bh=31LvNc9YajzMw45x3IxHv0yCzc5JRFpLJFVwFgRz5LM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=G58HbthKraT6gjdBVw9WVAnAwO4vjBFyOhGpgn/PTuaVgngWwfKqfFLCQ+WFXIOHeVz/N+9ojZYLhSbOh3fPi8UOvWoaW+YD+x8gHDkkkXuCv6xqv2igdtAG/MGKCcDDiyK0TRfWlDot+79ZgTALTObRdbuz0gci2obbW/I81PM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LdJDkgHO; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LdJDkgHO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751891337; x=1783427337;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=31LvNc9YajzMw45x3IxHv0yCzc5JRFpLJFVwFgRz5LM=;
  b=LdJDkgHOW6UdmZNdnYpih0Hyv+lFez5qEGin+ujzMqrl4addalxbPpTz
   07QGiViiGIWvXjpGR9Y7UhVeyG1ezuAm49gfPHOxPcHCU4/kgyER9UNL/
   tnbK4jkxqSN5J4fCxlhFa6B5o2AlNAtmYNoosCDYXwVoGLI1rKouX7lrU
   S06EDj8q5HaOoMIfuBWQ7Xik/n/gTrSaAQo44gjxq+uBgzptgmiy8D7ze
   XDy5kwL7vrx6U/eMTTMDSqCbCIOyXfNUIv35cZxEgWEVmi9osrVvmP+Bj
   vCc8LW7ZEqH5oVpB1APU+PN0ame693zSrJvZRsQMHXd2M3NItl8q7qSPA
   Q==;
X-CSE-ConnectionGUID: 1rkgcssYRVGj1pNIlFNBCA==
X-CSE-MsgGUID: eH44IVd9SGq9F3NTIoIrLA==
X-IronPort-AV: E=McAfee;i="6800,10657,11487"; a="57779491"
X-IronPort-AV: E=Sophos;i="6.16,294,1744095600"; 
   d="scan'208";a="57779491"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2025 05:28:55 -0700
X-CSE-ConnectionGUID: 7Alh7wi3R8eHQpFua0uF7w==
X-CSE-MsgGUID: hMuUP5TURIyyAmf9+bIV6Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,294,1744095600"; 
   d="scan'208";a="159474560"
Received: from t21-qat.iind.intel.com ([10.49.15.35])
  by fmviesa005.fm.intel.com with ESMTP; 07 Jul 2025 05:28:52 -0700
From: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com
Subject: [PATCH 1/2] crypto: qat - relocate power management debugfs helper APIs
Date: Mon,  7 Jul 2025 13:28:45 +0100
Message-Id: <20250707122846.1308115-2-suman.kumar.chakraborty@intel.com>
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

Relocate the power management debugfs helper APIs in a common file
adf_pm_dbgfs_utils.h and adf_pm_dbgfs_utils.c so that it can be shared
between device generations.

When moving logic from adf_gen4_pm_debugfs.c to adf_pm_dbgfs_utils.c, the
include kernel.h has been replaced with the required include.

This does not introduce any functional change.

Signed-off-by: George Abraham P <george.abraham.p@intel.com>
Signed-off-by: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/intel/qat/qat_common/Makefile  |   1 +
 .../qat/qat_common/adf_gen4_pm_debugfs.c      | 105 ++++--------------
 .../intel/qat/qat_common/adf_pm_dbgfs_utils.c |  52 +++++++++
 .../intel/qat/qat_common/adf_pm_dbgfs_utils.h |  36 ++++++
 4 files changed, 108 insertions(+), 86 deletions(-)
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_pm_dbgfs_utils.c
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_pm_dbgfs_utils.h

diff --git a/drivers/crypto/intel/qat/qat_common/Makefile b/drivers/crypto/intel/qat/qat_common/Makefile
index e426cc3c49c3..5826180c2051 100644
--- a/drivers/crypto/intel/qat/qat_common/Makefile
+++ b/drivers/crypto/intel/qat/qat_common/Makefile
@@ -52,6 +52,7 @@ intel_qat-$(CONFIG_DEBUG_FS) += adf_cnv_dbgfs.o \
 				adf_heartbeat_dbgfs.o \
 				adf_heartbeat.o \
 				adf_pm_dbgfs.o \
+				adf_pm_dbgfs_utils.o \
 				adf_telemetry.o \
 				adf_tl_debugfs.o \
 				adf_transport_debug.o
diff --git a/drivers/crypto/intel/qat/qat_common/adf_gen4_pm_debugfs.c b/drivers/crypto/intel/qat/qat_common/adf_gen4_pm_debugfs.c
index 2e4095c4c12c..b7e38842a46d 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_gen4_pm_debugfs.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_gen4_pm_debugfs.c
@@ -1,47 +1,18 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /* Copyright(c) 2023 Intel Corporation */
 #include <linux/dma-mapping.h>
-#include <linux/kernel.h>
 #include <linux/string_helpers.h>
-#include <linux/stringify.h>
 
 #include "adf_accel_devices.h"
 #include "adf_admin.h"
 #include "adf_common_drv.h"
 #include "adf_gen4_pm.h"
+#include "adf_pm_dbgfs_utils.h"
 #include "icp_qat_fw_init_admin.h"
 
-/*
- * This is needed because a variable is used to index the mask at
- * pm_scnprint_table(), making it not compile time constant, so the compile
- * asserts from FIELD_GET() or u32_get_bits() won't be fulfilled.
- */
-#define field_get(_mask, _reg) (((_reg) & (_mask)) >> (ffs(_mask) - 1))
-
-#define PM_INFO_MEMBER_OFF(member)	\
-	(offsetof(struct icp_qat_fw_init_admin_pm_info, member) / sizeof(u32))
-
-#define PM_INFO_REGSET_ENTRY_MASK(_reg_, _field_, _mask_)	\
-{								\
-	.reg_offset = PM_INFO_MEMBER_OFF(_reg_),		\
-	.key = __stringify(_field_),				\
-	.field_mask = _mask_,					\
-}
-
-#define PM_INFO_REGSET_ENTRY32(_reg_, _field_)	\
-	PM_INFO_REGSET_ENTRY_MASK(_reg_, _field_, GENMASK(31, 0))
-
 #define PM_INFO_REGSET_ENTRY(_reg_, _field_)	\
 	PM_INFO_REGSET_ENTRY_MASK(_reg_, _field_, ADF_GEN4_PM_##_field_##_MASK)
 
-#define PM_INFO_MAX_KEY_LEN	21
-
-struct pm_status_row {
-	int reg_offset;
-	u32 field_mask;
-	const char *key;
-};
-
 static const struct pm_status_row pm_fuse_rows[] = {
 	PM_INFO_REGSET_ENTRY(fusectl0, ENABLE_PM),
 	PM_INFO_REGSET_ENTRY(fusectl0, ENABLE_PM_IDLE),
@@ -109,44 +80,6 @@ static const struct pm_status_row pm_csrs_rows[] = {
 	PM_INFO_REGSET_ENTRY32(pm.pwrreq, CPM_PM_PWRREQ),
 };
 
-static int pm_scnprint_table(char *buff, const struct pm_status_row *table,
-			     u32 *pm_info_regs, size_t buff_size, int table_len,
-			     bool lowercase)
-{
-	char key[PM_INFO_MAX_KEY_LEN];
-	int wr = 0;
-	int i;
-
-	for (i = 0; i < table_len; i++) {
-		if (lowercase)
-			string_lower(key, table[i].key);
-		else
-			string_upper(key, table[i].key);
-
-		wr += scnprintf(&buff[wr], buff_size - wr, "%s: %#x\n", key,
-				field_get(table[i].field_mask,
-					  pm_info_regs[table[i].reg_offset]));
-	}
-
-	return wr;
-}
-
-static int pm_scnprint_table_upper_keys(char *buff, const struct pm_status_row *table,
-					u32 *pm_info_regs, size_t buff_size,
-					int table_len)
-{
-	return pm_scnprint_table(buff, table, pm_info_regs, buff_size,
-				 table_len, false);
-}
-
-static int pm_scnprint_table_lower_keys(char *buff, const struct pm_status_row *table,
-					u32 *pm_info_regs, size_t buff_size,
-					int table_len)
-{
-	return pm_scnprint_table(buff, table, pm_info_regs, buff_size,
-				 table_len, true);
-}
-
 static_assert(sizeof(struct icp_qat_fw_init_admin_pm_info) < PAGE_SIZE);
 
 static ssize_t adf_gen4_print_pm_status(struct adf_accel_dev *accel_dev,
@@ -191,9 +124,9 @@ static ssize_t adf_gen4_print_pm_status(struct adf_accel_dev *accel_dev,
 	/* Fusectl related */
 	len += scnprintf(&pm_kv[len], PAGE_SIZE - len,
 			 "----------- PM Fuse info ---------\n");
-	len += pm_scnprint_table_lower_keys(&pm_kv[len], pm_fuse_rows,
-					    pm_info_regs, PAGE_SIZE - len,
-					    ARRAY_SIZE(pm_fuse_rows));
+	len += adf_pm_scnprint_table_lower_keys(&pm_kv[len], pm_fuse_rows,
+						pm_info_regs, PAGE_SIZE - len,
+						ARRAY_SIZE(pm_fuse_rows));
 	len += scnprintf(&pm_kv[len], PAGE_SIZE - len, "max_pwrreq: %#x\n",
 			 pm_info->max_pwrreq);
 	len += scnprintf(&pm_kv[len], PAGE_SIZE - len, "min_pwrreq: %#x\n",
@@ -204,28 +137,28 @@ static ssize_t adf_gen4_print_pm_status(struct adf_accel_dev *accel_dev,
 			 "------------  PM Info ------------\n");
 	len += scnprintf(&pm_kv[len], PAGE_SIZE - len, "power_level: %s\n",
 			 pm_info->pwr_state == PM_SET_MIN ? "min" : "max");
-	len += pm_scnprint_table_lower_keys(&pm_kv[len], pm_info_rows,
-					    pm_info_regs, PAGE_SIZE - len,
-					    ARRAY_SIZE(pm_info_rows));
+	len += adf_pm_scnprint_table_lower_keys(&pm_kv[len], pm_info_rows,
+						pm_info_regs, PAGE_SIZE - len,
+						ARRAY_SIZE(pm_info_rows));
 	len += scnprintf(&pm_kv[len], PAGE_SIZE - len, "pm_mode: STATIC\n");
 
 	/* SSM related */
 	len += scnprintf(&pm_kv[len], PAGE_SIZE - len,
 			 "----------- SSM_PM Info ----------\n");
-	len += pm_scnprint_table_lower_keys(&pm_kv[len], pm_ssm_rows,
-					    pm_info_regs, PAGE_SIZE - len,
-					    ARRAY_SIZE(pm_ssm_rows));
+	len += adf_pm_scnprint_table_lower_keys(&pm_kv[len], pm_ssm_rows,
+						pm_info_regs, PAGE_SIZE - len,
+						ARRAY_SIZE(pm_ssm_rows));
 
 	/* Log related */
 	len += scnprintf(&pm_kv[len], PAGE_SIZE - len,
 			 "------------- PM Log -------------\n");
-	len += pm_scnprint_table_lower_keys(&pm_kv[len], pm_log_rows,
-					    pm_info_regs, PAGE_SIZE - len,
-					    ARRAY_SIZE(pm_log_rows));
+	len += adf_pm_scnprint_table_lower_keys(&pm_kv[len], pm_log_rows,
+						pm_info_regs, PAGE_SIZE - len,
+						ARRAY_SIZE(pm_log_rows));
 
-	len += pm_scnprint_table_lower_keys(&pm_kv[len], pm_event_rows,
-					    pm_info_regs, PAGE_SIZE - len,
-					    ARRAY_SIZE(pm_event_rows));
+	len += adf_pm_scnprint_table_lower_keys(&pm_kv[len], pm_event_rows,
+						pm_info_regs, PAGE_SIZE - len,
+						ARRAY_SIZE(pm_event_rows));
 
 	len += scnprintf(&pm_kv[len], PAGE_SIZE - len, "idle_irq_count: %#x\n",
 			 pm->idle_irq_counters);
@@ -241,9 +174,9 @@ static ssize_t adf_gen4_print_pm_status(struct adf_accel_dev *accel_dev,
 	/* CSRs content */
 	len += scnprintf(&pm_kv[len], PAGE_SIZE - len,
 			 "----------- HW PM CSRs -----------\n");
-	len += pm_scnprint_table_upper_keys(&pm_kv[len], pm_csrs_rows,
-					    pm_info_regs, PAGE_SIZE - len,
-					    ARRAY_SIZE(pm_csrs_rows));
+	len += adf_pm_scnprint_table_upper_keys(&pm_kv[len], pm_csrs_rows,
+						pm_info_regs, PAGE_SIZE - len,
+						ARRAY_SIZE(pm_csrs_rows));
 
 	val = ADF_CSR_RD(pmisc, ADF_GEN4_PM_HOST_MSG);
 	len += scnprintf(&pm_kv[len], PAGE_SIZE - len,
diff --git a/drivers/crypto/intel/qat/qat_common/adf_pm_dbgfs_utils.c b/drivers/crypto/intel/qat/qat_common/adf_pm_dbgfs_utils.c
new file mode 100644
index 000000000000..69295a9ddf0a
--- /dev/null
+++ b/drivers/crypto/intel/qat/qat_common/adf_pm_dbgfs_utils.c
@@ -0,0 +1,52 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright(c) 2025 Intel Corporation */
+#include <linux/bitops.h>
+#include <linux/sprintf.h>
+#include <linux/string_helpers.h>
+
+#include "adf_pm_dbgfs_utils.h"
+
+/*
+ * This is needed because a variable is used to index the mask at
+ * pm_scnprint_table(), making it not compile time constant, so the compile
+ * asserts from FIELD_GET() or u32_get_bits() won't be fulfilled.
+ */
+#define field_get(_mask, _reg) (((_reg) & (_mask)) >> (ffs(_mask) - 1))
+
+#define PM_INFO_MAX_KEY_LEN	21
+
+static int pm_scnprint_table(char *buff, const struct pm_status_row *table,
+			     u32 *pm_info_regs, size_t buff_size, int table_len,
+			     bool lowercase)
+{
+	char key[PM_INFO_MAX_KEY_LEN];
+	int wr = 0;
+	int i;
+
+	for (i = 0; i < table_len; i++) {
+		if (lowercase)
+			string_lower(key, table[i].key);
+		else
+			string_upper(key, table[i].key);
+
+		wr += scnprintf(&buff[wr], buff_size - wr, "%s: %#x\n", key,
+				field_get(table[i].field_mask,
+					  pm_info_regs[table[i].reg_offset]));
+	}
+
+	return wr;
+}
+
+int adf_pm_scnprint_table_upper_keys(char *buff, const struct pm_status_row *table,
+				     u32 *pm_info_regs, size_t buff_size, int table_len)
+{
+	return pm_scnprint_table(buff, table, pm_info_regs, buff_size,
+				 table_len, false);
+}
+
+int adf_pm_scnprint_table_lower_keys(char *buff, const struct pm_status_row *table,
+				     u32 *pm_info_regs, size_t buff_size, int table_len)
+{
+	return pm_scnprint_table(buff, table, pm_info_regs, buff_size,
+				 table_len, true);
+}
diff --git a/drivers/crypto/intel/qat/qat_common/adf_pm_dbgfs_utils.h b/drivers/crypto/intel/qat/qat_common/adf_pm_dbgfs_utils.h
new file mode 100644
index 000000000000..854f058b35ed
--- /dev/null
+++ b/drivers/crypto/intel/qat/qat_common/adf_pm_dbgfs_utils.h
@@ -0,0 +1,36 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/* Copyright(c) 2025 Intel Corporation */
+#ifndef ADF_PM_DBGFS_UTILS_H_
+#define ADF_PM_DBGFS_UTILS_H_
+
+#include <linux/stddef.h>
+#include <linux/stringify.h>
+#include <linux/types.h>
+#include "icp_qat_fw_init_admin.h"
+
+#define PM_INFO_MEMBER_OFF(member)	\
+	(offsetof(struct icp_qat_fw_init_admin_pm_info, member) / sizeof(u32))
+
+#define PM_INFO_REGSET_ENTRY_MASK(_reg_, _field_, _mask_)	\
+{								\
+	.reg_offset = PM_INFO_MEMBER_OFF(_reg_),		\
+	.key = __stringify(_field_),				\
+	.field_mask = _mask_,					\
+}
+
+#define PM_INFO_REGSET_ENTRY32(_reg_, _field_)	\
+	PM_INFO_REGSET_ENTRY_MASK(_reg_, _field_, GENMASK(31, 0))
+
+struct pm_status_row {
+	int reg_offset;
+	u32 field_mask;
+	const char *key;
+};
+
+int adf_pm_scnprint_table_upper_keys(char *buff, const struct pm_status_row *table,
+				     u32 *pm_info_regs, size_t buff_size, int table_len);
+
+int adf_pm_scnprint_table_lower_keys(char *buff, const struct pm_status_row *table,
+				     u32 *pm_info_regs, size_t buff_size, int table_len);
+
+#endif /* ADF_PM_DBGFS_UTILS_H_ */
-- 
2.40.1

