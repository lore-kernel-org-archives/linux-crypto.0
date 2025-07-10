Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00F6B28751E
	for <linux-crypto@vger.kernel.org>; Thu, 10 Jul 2025 06:39:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752129599; cv=none; b=O1jnDc2jarlq6x3VoivM1BwF5Y+YfLOLSDChPxxxL42hwB4Ism6FHyDkWD/9JP9FuVJnwd9Hnt27KtYpJ0603YCVnFjL2EOmq4jFMUV544MBnRTfMiA3Z+AidoFRgariZ4xXm1sx2EiFD5GjEZE/wvtCKzed6dUafk2kFz71tuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752129599; c=relaxed/simple;
	bh=5vdcy1niK2j4JAkI+eAnKb3TalSXRj8cZ8M+EvFeyVI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=RAqTJOPODFML4EUsze5nJ0U4L5wjIt7pZsl9L713Ccs1gmuPPesEwfCMeOKlp47GYWWxgdTIIfiKHTpeGoC/nsGdAElvsDGnN5Xl+Icb9N4zB6sqF7vE0iqpWrdF6a+SESfRhVIIIZ/ol65JOszQljVsy2wZ1Y6aJoMdAzdJdfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=b2j/3Uqf; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="b2j/3Uqf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752129597; x=1783665597;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5vdcy1niK2j4JAkI+eAnKb3TalSXRj8cZ8M+EvFeyVI=;
  b=b2j/3Uqfv3aY34NqGlLWBlt7VkNd8pJk2PyP4JEpVgmf0PUEaBC/Vdlh
   ylpYtrjnHmo8URleb4hlviOXRV022Evqu1Ht1fBTFLQLREcLX4XjU9EGP
   cofgunGIMM3yZG2Ix8l7Y12pkih4TBCudkY3Q4ijTL3HxXCMUghOSkH6Q
   Rn37FO9M7HwQiS1HtTCuc/QlyscI6fW/6xB/xJLd1TOKi4olFUrEskLzd
   YcJDez+XxRLQFCKreqAfKIl31fXXrrzKiTycQvK+r42XXUL7H8eOKOpfI
   ooAXPjLC87ePxw6Wj3XGFSozUK3uDc0WChRyKwlPpBvHQkasB+8GbvS8b
   w==;
X-CSE-ConnectionGUID: BHtT90UHTJ2K7ORYFeECrw==
X-CSE-MsgGUID: 8IiztolpQjuf9wkmfolqgw==
X-IronPort-AV: E=McAfee;i="6800,10657,11489"; a="53512252"
X-IronPort-AV: E=Sophos;i="6.16,300,1744095600"; 
   d="scan'208";a="53512252"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2025 23:39:57 -0700
X-CSE-ConnectionGUID: dDSccZ8USEyqzAfIkLOcAQ==
X-CSE-MsgGUID: hbAJytPaRh+VO2c/577T5w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,300,1744095600"; 
   d="scan'208";a="155632198"
Received: from t21-qat.iind.intel.com ([10.49.15.35])
  by fmviesa007.fm.intel.com with ESMTP; 09 Jul 2025 23:39:55 -0700
From: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com
Subject: [PATCH 2/3] crypto: qat - enable telemetry for GEN6 devices
Date: Thu, 10 Jul 2025 07:39:44 +0100
Message-Id: <20250710063945.516678-3-suman.kumar.chakraborty@intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20250710063945.516678-1-suman.kumar.chakraborty@intel.com>
References: <20250710063945.516678-1-suman.kumar.chakraborty@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Vijay Sundar Selvamani <vijay.sundar.selvamani@intel.com>

Enable telemetry for QAT GEN6 devices by defining the firmware data
structures layouts, implementing the counters parsing logic and setting
the required properties on the adf_tl_hw_data data structure.

As for QAT GEN4, telemetry counters are exposed via debugfs using the
interface described in Documentation/ABI/testing/debugfs-driver-qat_telemetry.

Co-developed-by: George Abraham P <george.abraham.p@intel.com>
Signed-off-by: George Abraham P <george.abraham.p@intel.com>
Signed-off-by: Vijay Sundar Selvamani <vijay.sundar.selvamani@intel.com>
Signed-off-by: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 .../intel/qat/qat_6xxx/adf_6xxx_hw_data.c     |   3 +
 drivers/crypto/intel/qat/qat_common/Makefile  |   1 +
 .../crypto/intel/qat/qat_common/adf_gen6_tl.c | 146 +++++++++++++
 .../crypto/intel/qat/qat_common/adf_gen6_tl.h | 198 ++++++++++++++++++
 4 files changed, 348 insertions(+)
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_gen6_tl.c
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_gen6_tl.h

diff --git a/drivers/crypto/intel/qat/qat_6xxx/adf_6xxx_hw_data.c b/drivers/crypto/intel/qat/qat_6xxx/adf_6xxx_hw_data.c
index ecef3dc28a91..d3f1034f33fb 100644
--- a/drivers/crypto/intel/qat/qat_6xxx/adf_6xxx_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_6xxx/adf_6xxx_hw_data.c
@@ -19,6 +19,7 @@
 #include <adf_gen6_pm.h>
 #include <adf_gen6_ras.h>
 #include <adf_gen6_shared.h>
+#include <adf_gen6_tl.h>
 #include <adf_timer.h>
 #include "adf_6xxx_hw_data.h"
 #include "icp_qat_fw_comp.h"
@@ -861,12 +862,14 @@ void adf_init_hw_data_6xxx(struct adf_hw_device_data *hw_data)
 	hw_data->init_device = adf_init_device;
 	hw_data->enable_pm = enable_pm;
 	hw_data->services_supported = services_supported;
+	hw_data->num_rps = ADF_GEN6_ETR_MAX_BANKS;
 
 	adf_gen6_init_hw_csr_ops(&hw_data->csr_ops);
 	adf_gen6_init_pf_pfvf_ops(&hw_data->pfvf_ops);
 	adf_gen6_init_dc_ops(&hw_data->dc_ops);
 	adf_gen6_init_vf_mig_ops(&hw_data->vfmig_ops);
 	adf_gen6_init_ras_ops(&hw_data->ras_ops);
+	adf_gen6_init_tl_data(&hw_data->tl_data);
 }
 
 void adf_clean_hw_data_6xxx(struct adf_hw_device_data *hw_data)
diff --git a/drivers/crypto/intel/qat/qat_common/Makefile b/drivers/crypto/intel/qat/qat_common/Makefile
index 34019d8637a5..89845754841b 100644
--- a/drivers/crypto/intel/qat/qat_common/Makefile
+++ b/drivers/crypto/intel/qat/qat_common/Makefile
@@ -50,6 +50,7 @@ intel_qat-$(CONFIG_DEBUG_FS) += adf_cnv_dbgfs.o \
 				adf_gen4_pm_debugfs.o \
 				adf_gen4_tl.o \
 				adf_gen6_pm_dbgfs.o \
+				adf_gen6_tl.o \
 				adf_heartbeat_dbgfs.o \
 				adf_heartbeat.o \
 				adf_pm_dbgfs.o \
diff --git a/drivers/crypto/intel/qat/qat_common/adf_gen6_tl.c b/drivers/crypto/intel/qat/qat_common/adf_gen6_tl.c
new file mode 100644
index 000000000000..cf804f95838a
--- /dev/null
+++ b/drivers/crypto/intel/qat/qat_common/adf_gen6_tl.c
@@ -0,0 +1,146 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright (c) 2025 Intel Corporation. */
+#include <linux/export.h>
+
+#include "adf_gen6_tl.h"
+#include "adf_telemetry.h"
+#include "adf_tl_debugfs.h"
+#include "icp_qat_fw_init_admin.h"
+
+#define ADF_GEN6_TL_DEV_REG_OFF(reg) ADF_TL_DEV_REG_OFF(reg, gen6)
+
+#define ADF_GEN6_TL_RP_REG_OFF(reg) ADF_TL_RP_REG_OFF(reg, gen6)
+
+#define ADF_GEN6_TL_SL_UTIL_COUNTER(_name)			\
+	ADF_TL_COUNTER("util_" #_name, ADF_TL_SIMPLE_COUNT,	\
+			ADF_TL_SLICE_REG_OFF(_name, reg_tm_slice_util, gen6))
+
+#define ADF_GEN6_TL_SL_EXEC_COUNTER(_name)			\
+	ADF_TL_COUNTER("exec_" #_name, ADF_TL_SIMPLE_COUNT,	\
+			ADF_TL_SLICE_REG_OFF(_name, reg_tm_slice_exec_cnt, gen6))
+
+#define SLICE_IDX(sl) offsetof(struct icp_qat_fw_init_admin_slice_cnt, sl##_cnt)
+
+/* Device level counters. */
+static const struct adf_tl_dbg_counter dev_counters[] = {
+	/* PCIe partial transactions. */
+	ADF_TL_COUNTER(PCI_TRANS_CNT_NAME, ADF_TL_SIMPLE_COUNT,
+		       ADF_GEN6_TL_DEV_REG_OFF(reg_tl_prt_trans_cnt)),
+	/* Max read latency[ns]. */
+	ADF_TL_COUNTER(MAX_RD_LAT_NAME, ADF_TL_COUNTER_NS,
+		       ADF_GEN6_TL_DEV_REG_OFF(reg_tl_rd_lat_max)),
+	/* Read latency average[ns]. */
+	ADF_TL_COUNTER_LATENCY(RD_LAT_ACC_NAME, ADF_TL_COUNTER_NS_AVG,
+			       ADF_GEN6_TL_DEV_REG_OFF(reg_tl_rd_lat_acc),
+			       ADF_GEN6_TL_DEV_REG_OFF(reg_tl_rd_cmpl_cnt)),
+	/* Max "get to put" latency[ns]. */
+	ADF_TL_COUNTER(MAX_LAT_NAME, ADF_TL_COUNTER_NS,
+		       ADF_GEN6_TL_DEV_REG_OFF(reg_tl_gp_lat_max)),
+	/* "Get to put" latency average[ns]. */
+	ADF_TL_COUNTER_LATENCY(LAT_ACC_NAME, ADF_TL_COUNTER_NS_AVG,
+			       ADF_GEN6_TL_DEV_REG_OFF(reg_tl_gp_lat_acc),
+			       ADF_GEN6_TL_DEV_REG_OFF(reg_tl_ae_put_cnt)),
+	/* PCIe write bandwidth[Mbps]. */
+	ADF_TL_COUNTER(BW_IN_NAME, ADF_TL_COUNTER_MBPS,
+		       ADF_GEN6_TL_DEV_REG_OFF(reg_tl_bw_in)),
+	/* PCIe read bandwidth[Mbps]. */
+	ADF_TL_COUNTER(BW_OUT_NAME, ADF_TL_COUNTER_MBPS,
+		       ADF_GEN6_TL_DEV_REG_OFF(reg_tl_bw_out)),
+	/* Page request latency average[ns]. */
+	ADF_TL_COUNTER_LATENCY(PAGE_REQ_LAT_NAME, ADF_TL_COUNTER_NS_AVG,
+			       ADF_GEN6_TL_DEV_REG_OFF(reg_tl_at_page_req_lat_acc),
+			       ADF_GEN6_TL_DEV_REG_OFF(reg_tl_at_page_req_cnt)),
+	/* Page translation latency average[ns]. */
+	ADF_TL_COUNTER_LATENCY(AT_TRANS_LAT_NAME, ADF_TL_COUNTER_NS_AVG,
+			       ADF_GEN6_TL_DEV_REG_OFF(reg_tl_at_trans_lat_acc),
+			       ADF_GEN6_TL_DEV_REG_OFF(reg_tl_at_trans_lat_cnt)),
+	/* Maximum uTLB used. */
+	ADF_TL_COUNTER(AT_MAX_UTLB_USED_NAME, ADF_TL_SIMPLE_COUNT,
+		       ADF_GEN6_TL_DEV_REG_OFF(reg_tl_at_max_utlb_used)),
+};
+
+/* Accelerator utilization counters */
+static const struct adf_tl_dbg_counter sl_util_counters[ADF_TL_SL_CNT_COUNT] = {
+	/* Compression accelerator utilization. */
+	[SLICE_IDX(cpr)] = ADF_GEN6_TL_SL_UTIL_COUNTER(cnv),
+	/* Decompression accelerator utilization. */
+	[SLICE_IDX(dcpr)] = ADF_GEN6_TL_SL_UTIL_COUNTER(dcprz),
+	/* PKE accelerator utilization. */
+	[SLICE_IDX(pke)] = ADF_GEN6_TL_SL_UTIL_COUNTER(pke),
+	/* Wireless Authentication accelerator utilization. */
+	[SLICE_IDX(wat)] = ADF_GEN6_TL_SL_UTIL_COUNTER(wat),
+	/* Wireless Cipher accelerator utilization. */
+	[SLICE_IDX(wcp)] = ADF_GEN6_TL_SL_UTIL_COUNTER(wcp),
+	/* UCS accelerator utilization. */
+	[SLICE_IDX(ucs)] = ADF_GEN6_TL_SL_UTIL_COUNTER(ucs),
+	/* Authentication accelerator utilization. */
+	[SLICE_IDX(ath)] = ADF_GEN6_TL_SL_UTIL_COUNTER(ath),
+};
+
+/* Accelerator execution counters */
+static const struct adf_tl_dbg_counter sl_exec_counters[ADF_TL_SL_CNT_COUNT] = {
+	/* Compression accelerator execution count. */
+	[SLICE_IDX(cpr)] = ADF_GEN6_TL_SL_EXEC_COUNTER(cnv),
+	/* Decompression accelerator execution count. */
+	[SLICE_IDX(dcpr)] = ADF_GEN6_TL_SL_EXEC_COUNTER(dcprz),
+	/* PKE execution count. */
+	[SLICE_IDX(pke)] = ADF_GEN6_TL_SL_EXEC_COUNTER(pke),
+	/* Wireless Authentication accelerator execution count. */
+	[SLICE_IDX(wat)] = ADF_GEN6_TL_SL_EXEC_COUNTER(wat),
+	/* Wireless Cipher accelerator execution count. */
+	[SLICE_IDX(wcp)] = ADF_GEN6_TL_SL_EXEC_COUNTER(wcp),
+	/* UCS accelerator execution count. */
+	[SLICE_IDX(ucs)] = ADF_GEN6_TL_SL_EXEC_COUNTER(ucs),
+	/* Authentication accelerator execution count. */
+	[SLICE_IDX(ath)] = ADF_GEN6_TL_SL_EXEC_COUNTER(ath),
+};
+
+/* Ring pair counters. */
+static const struct adf_tl_dbg_counter rp_counters[] = {
+	/* PCIe partial transactions. */
+	ADF_TL_COUNTER(PCI_TRANS_CNT_NAME, ADF_TL_SIMPLE_COUNT,
+		       ADF_GEN6_TL_RP_REG_OFF(reg_tl_prt_trans_cnt)),
+	/* "Get to put" latency average[ns]. */
+	ADF_TL_COUNTER_LATENCY(LAT_ACC_NAME, ADF_TL_COUNTER_NS_AVG,
+			       ADF_GEN6_TL_RP_REG_OFF(reg_tl_gp_lat_acc),
+			       ADF_GEN6_TL_RP_REG_OFF(reg_tl_ae_put_cnt)),
+	/* PCIe write bandwidth[Mbps]. */
+	ADF_TL_COUNTER(BW_IN_NAME, ADF_TL_COUNTER_MBPS,
+		       ADF_GEN6_TL_RP_REG_OFF(reg_tl_bw_in)),
+	/* PCIe read bandwidth[Mbps]. */
+	ADF_TL_COUNTER(BW_OUT_NAME, ADF_TL_COUNTER_MBPS,
+		       ADF_GEN6_TL_RP_REG_OFF(reg_tl_bw_out)),
+	/* Message descriptor DevTLB hit rate. */
+	ADF_TL_COUNTER(AT_GLOB_DTLB_HIT_NAME, ADF_TL_SIMPLE_COUNT,
+		       ADF_GEN6_TL_RP_REG_OFF(reg_tl_at_glob_devtlb_hit)),
+	/* Message descriptor DevTLB miss rate. */
+	ADF_TL_COUNTER(AT_GLOB_DTLB_MISS_NAME, ADF_TL_SIMPLE_COUNT,
+		       ADF_GEN6_TL_RP_REG_OFF(reg_tl_at_glob_devtlb_miss)),
+	/* Payload DevTLB hit rate. */
+	ADF_TL_COUNTER(AT_PAYLD_DTLB_HIT_NAME, ADF_TL_SIMPLE_COUNT,
+		       ADF_GEN6_TL_RP_REG_OFF(reg_tl_at_payld_devtlb_hit)),
+	/* Payload DevTLB miss rate. */
+	ADF_TL_COUNTER(AT_PAYLD_DTLB_MISS_NAME, ADF_TL_SIMPLE_COUNT,
+		       ADF_GEN6_TL_RP_REG_OFF(reg_tl_at_payld_devtlb_miss)),
+};
+
+void adf_gen6_init_tl_data(struct adf_tl_hw_data *tl_data)
+{
+	tl_data->layout_sz = ADF_GEN6_TL_LAYOUT_SZ;
+	tl_data->slice_reg_sz = ADF_GEN6_TL_SLICE_REG_SZ;
+	tl_data->rp_reg_sz = ADF_GEN6_TL_RP_REG_SZ;
+	tl_data->num_hbuff = ADF_GEN6_TL_NUM_HIST_BUFFS;
+	tl_data->max_rp = ADF_GEN6_TL_MAX_RP_NUM;
+	tl_data->msg_cnt_off = ADF_GEN6_TL_MSG_CNT_OFF;
+	tl_data->cpp_ns_per_cycle = ADF_GEN6_CPP_NS_PER_CYCLE;
+	tl_data->bw_units_to_bytes = ADF_GEN6_TL_BW_HW_UNITS_TO_BYTES;
+
+	tl_data->dev_counters = dev_counters;
+	tl_data->num_dev_counters = ARRAY_SIZE(dev_counters);
+	tl_data->sl_util_counters = sl_util_counters;
+	tl_data->sl_exec_counters = sl_exec_counters;
+	tl_data->rp_counters = rp_counters;
+	tl_data->num_rp_counters = ARRAY_SIZE(rp_counters);
+	tl_data->max_sl_cnt = ADF_GEN6_TL_MAX_SLICES_PER_TYPE;
+}
+EXPORT_SYMBOL_GPL(adf_gen6_init_tl_data);
diff --git a/drivers/crypto/intel/qat/qat_common/adf_gen6_tl.h b/drivers/crypto/intel/qat/qat_common/adf_gen6_tl.h
new file mode 100644
index 000000000000..49db660b8eb9
--- /dev/null
+++ b/drivers/crypto/intel/qat/qat_common/adf_gen6_tl.h
@@ -0,0 +1,198 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/* Copyright (c) 2025 Intel Corporation. */
+#ifndef ADF_GEN6_TL_H
+#define ADF_GEN6_TL_H
+
+#include <linux/types.h>
+
+struct adf_tl_hw_data;
+
+/* Computation constants. */
+#define ADF_GEN6_CPP_NS_PER_CYCLE		2
+#define ADF_GEN6_TL_BW_HW_UNITS_TO_BYTES	64
+
+/* Maximum aggregation time. Value is in milliseconds. */
+#define ADF_GEN6_TL_MAX_AGGR_TIME_MS		4000
+/* Number of buffers to store historic values. */
+#define ADF_GEN6_TL_NUM_HIST_BUFFS \
+	(ADF_GEN6_TL_MAX_AGGR_TIME_MS / ADF_TL_DATA_WR_INTERVAL_MS)
+
+/* Max number of HW resources of one type */
+#define ADF_GEN6_TL_MAX_SLICES_PER_TYPE		32
+#define MAX_ATH_SL_COUNT			7
+#define MAX_CNV_SL_COUNT			2
+#define MAX_DCPRZ_SL_COUNT			2
+#define MAX_PKE_SL_COUNT			32
+#define MAX_UCS_SL_COUNT			4
+#define MAX_WAT_SL_COUNT			5
+#define MAX_WCP_SL_COUNT			5
+
+#define MAX_ATH_CMDQ_COUNT			14
+#define MAX_CNV_CMDQ_COUNT			6
+#define MAX_DCPRZ_CMDQ_COUNT			6
+#define MAX_PKE_CMDQ_COUNT			32
+#define MAX_UCS_CMDQ_COUNT			12
+#define MAX_WAT_CMDQ_COUNT			35
+#define MAX_WCP_CMDQ_COUNT			35
+
+/* Max number of simultaneously monitored ring pairs. */
+#define ADF_GEN6_TL_MAX_RP_NUM			4
+
+/**
+ * struct adf_gen6_tl_slice_data_regs - HW slice data as populated by FW.
+ * @reg_tm_slice_exec_cnt: Slice execution count.
+ * @reg_tm_slice_util: Slice utilization.
+ */
+struct adf_gen6_tl_slice_data_regs {
+	__u32 reg_tm_slice_exec_cnt;
+	__u32 reg_tm_slice_util;
+};
+
+#define ADF_GEN6_TL_SLICE_REG_SZ sizeof(struct adf_gen6_tl_slice_data_regs)
+
+/**
+ * struct adf_gen6_tl_cmdq_data_regs - HW CMDQ data as populated by FW.
+ * @reg_tm_cmdq_wait_cnt: CMDQ wait count.
+ * @reg_tm_cmdq_exec_cnt: CMDQ execution count.
+ * @reg_tm_cmdq_drain_cnt: CMDQ drain count.
+ */
+struct adf_gen6_tl_cmdq_data_regs {
+	__u32 reg_tm_cmdq_wait_cnt;
+	__u32 reg_tm_cmdq_exec_cnt;
+	__u32 reg_tm_cmdq_drain_cnt;
+	__u32 reserved;
+};
+
+#define ADF_GEN6_TL_CMDQ_REG_SZ sizeof(struct adf_gen6_tl_cmdq_data_regs)
+
+/**
+ * struct adf_gen6_tl_device_data_regs - This structure stores device telemetry
+ * counter values as are being populated periodically by device.
+ * @reg_tl_rd_lat_acc: read latency accumulator
+ * @reg_tl_gp_lat_acc: "get to put" latency accumulator
+ * @reg_tl_at_page_req_lat_acc: AT/DevTLB page request latency accumulator
+ * @reg_tl_at_trans_lat_acc: DevTLB transaction latency accumulator
+ * @reg_tl_re_acc: accumulated ring empty time
+ * @reg_tl_prt_trans_cnt: PCIe partial transactions
+ * @reg_tl_rd_lat_max: maximum logged read latency
+ * @reg_tl_rd_cmpl_cnt: read requests completed count
+ * @reg_tl_gp_lat_max: maximum logged get to put latency
+ * @reg_tl_ae_put_cnt: Accelerator Engine put counts across all rings
+ * @reg_tl_bw_in: PCIe write bandwidth
+ * @reg_tl_bw_out: PCIe read bandwidth
+ * @reg_tl_at_page_req_cnt: DevTLB page requests count
+ * @reg_tl_at_trans_lat_cnt: DevTLB transaction latency samples count
+ * @reg_tl_at_max_utlb_used: maximum uTLB used
+ * @reg_tl_re_cnt: ring empty time samples count
+ * @reserved: reserved
+ * @ath_slices: array of Authentication slices utilization registers
+ * @cnv_slices: array of Compression slices utilization registers
+ * @dcprz_slices: array of Decompression slices utilization registers
+ * @pke_slices: array of PKE slices utilization registers
+ * @ucs_slices: array of UCS slices utilization registers
+ * @wat_slices: array of Wireless Authentication slices utilization registers
+ * @wcp_slices: array of Wireless Cipher slices utilization registers
+ * @ath_cmdq: array of Authentication cmdq telemetry registers
+ * @cnv_cmdq: array of Compression cmdq telemetry registers
+ * @dcprz_cmdq: array of Decomopression cmdq telemetry registers
+ * @pke_cmdq: array of PKE cmdq telemetry registers
+ * @ucs_cmdq: array of UCS cmdq telemetry registers
+ * @wat_cmdq: array of Wireless Authentication cmdq telemetry registers
+ * @wcp_cmdq: array of Wireless Cipher cmdq telemetry registers
+ */
+struct adf_gen6_tl_device_data_regs {
+	__u64 reg_tl_rd_lat_acc;
+	__u64 reg_tl_gp_lat_acc;
+	__u64 reg_tl_at_page_req_lat_acc;
+	__u64 reg_tl_at_trans_lat_acc;
+	__u64 reg_tl_re_acc;
+	__u32 reg_tl_prt_trans_cnt;
+	__u32 reg_tl_rd_lat_max;
+	__u32 reg_tl_rd_cmpl_cnt;
+	__u32 reg_tl_gp_lat_max;
+	__u32 reg_tl_ae_put_cnt;
+	__u32 reg_tl_bw_in;
+	__u32 reg_tl_bw_out;
+	__u32 reg_tl_at_page_req_cnt;
+	__u32 reg_tl_at_trans_lat_cnt;
+	__u32 reg_tl_at_max_utlb_used;
+	__u32 reg_tl_re_cnt;
+	__u32 reserved;
+	struct adf_gen6_tl_slice_data_regs ath_slices[MAX_ATH_SL_COUNT];
+	struct adf_gen6_tl_slice_data_regs cnv_slices[MAX_CNV_SL_COUNT];
+	struct adf_gen6_tl_slice_data_regs dcprz_slices[MAX_DCPRZ_SL_COUNT];
+	struct adf_gen6_tl_slice_data_regs pke_slices[MAX_PKE_SL_COUNT];
+	struct adf_gen6_tl_slice_data_regs ucs_slices[MAX_UCS_SL_COUNT];
+	struct adf_gen6_tl_slice_data_regs wat_slices[MAX_WAT_SL_COUNT];
+	struct adf_gen6_tl_slice_data_regs wcp_slices[MAX_WCP_SL_COUNT];
+	struct adf_gen6_tl_cmdq_data_regs ath_cmdq[MAX_ATH_CMDQ_COUNT];
+	struct adf_gen6_tl_cmdq_data_regs cnv_cmdq[MAX_CNV_CMDQ_COUNT];
+	struct adf_gen6_tl_cmdq_data_regs dcprz_cmdq[MAX_DCPRZ_CMDQ_COUNT];
+	struct adf_gen6_tl_cmdq_data_regs pke_cmdq[MAX_PKE_CMDQ_COUNT];
+	struct adf_gen6_tl_cmdq_data_regs ucs_cmdq[MAX_UCS_CMDQ_COUNT];
+	struct adf_gen6_tl_cmdq_data_regs wat_cmdq[MAX_WAT_CMDQ_COUNT];
+	struct adf_gen6_tl_cmdq_data_regs wcp_cmdq[MAX_WCP_CMDQ_COUNT];
+};
+
+/**
+ * struct adf_gen6_tl_ring_pair_data_regs - This structure stores ring pair
+ * telemetry counter values as they are being populated periodically by device.
+ * @reg_tl_gp_lat_acc: get-put latency accumulator
+ * @reg_tl_re_acc: accumulated ring empty time
+ * @reg_tl_pci_trans_cnt: PCIe partial transactions
+ * @reg_tl_ae_put_cnt: Accelerator Engine put counts across all rings
+ * @reg_tl_bw_in: PCIe write bandwidth
+ * @reg_tl_bw_out: PCIe read bandwidth
+ * @reg_tl_at_glob_devtlb_hit: Message descriptor DevTLB hit rate
+ * @reg_tl_at_glob_devtlb_miss: Message descriptor DevTLB miss rate
+ * @reg_tl_at_payld_devtlb_hit: Payload DevTLB hit rate
+ * @reg_tl_at_payld_devtlb_miss: Payload DevTLB miss rate
+ * @reg_tl_re_cnt: ring empty time samples count
+ * @reserved1: reserved
+ */
+struct adf_gen6_tl_ring_pair_data_regs {
+	__u64 reg_tl_gp_lat_acc;
+	__u64 reg_tl_re_acc;
+	__u32 reg_tl_prt_trans_cnt;
+	__u32 reg_tl_ae_put_cnt;
+	__u32 reg_tl_bw_in;
+	__u32 reg_tl_bw_out;
+	__u32 reg_tl_at_glob_devtlb_hit;
+	__u32 reg_tl_at_glob_devtlb_miss;
+	__u32 reg_tl_at_payld_devtlb_hit;
+	__u32 reg_tl_at_payld_devtlb_miss;
+	__u32 reg_tl_re_cnt;
+	__u32 reserved1;
+};
+
+#define ADF_GEN6_TL_RP_REG_SZ sizeof(struct adf_gen6_tl_ring_pair_data_regs)
+
+/**
+ * struct adf_gen6_tl_layout - This structure represents the entire telemetry
+ * counters data: Device + 4 Ring Pairs as they are being populated periodically
+ * by device.
+ * @tl_device_data_regs: structure of device telemetry registers
+ * @tl_ring_pairs_data_regs: array of ring pairs telemetry registers
+ * @reg_tl_msg_cnt: telemetry message counter
+ * @reserved: reserved
+ */
+struct adf_gen6_tl_layout {
+	struct adf_gen6_tl_device_data_regs tl_device_data_regs;
+	struct adf_gen6_tl_ring_pair_data_regs
+		tl_ring_pairs_data_regs[ADF_GEN6_TL_MAX_RP_NUM];
+	__u32 reg_tl_msg_cnt;
+	__u32 reserved;
+};
+
+#define ADF_GEN6_TL_LAYOUT_SZ sizeof(struct adf_gen6_tl_layout)
+#define ADF_GEN6_TL_MSG_CNT_OFF \
+	offsetof(struct adf_gen6_tl_layout, reg_tl_msg_cnt)
+
+#ifdef CONFIG_DEBUG_FS
+void adf_gen6_init_tl_data(struct adf_tl_hw_data *tl_data);
+#else
+static inline void adf_gen6_init_tl_data(struct adf_tl_hw_data *tl_data)
+{
+}
+#endif /* CONFIG_DEBUG_FS */
+#endif /* ADF_GEN6_TL_H */
-- 
2.40.1

