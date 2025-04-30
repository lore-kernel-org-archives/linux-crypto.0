Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18C492586C1
	for <linux-crypto@vger.kernel.org>; Wed, 30 Apr 2025 11:35:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746012923; cv=none; b=uVU7KgiMExQV8ikYA3pSBHHTgA2U+6Tnt5CIX1OS7dj0otiJAa1T+PNIAovSqBC45Cs/F7bEsZn5hUhUK3RigO1uUCJf94tcxFsFOlIfxulK23cMuZeyZkp8k9DNhqGDz/vsRP8Sk4bOWkJ5nhL3zJzSSZWaDXcvyqIdAnskz9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746012923; c=relaxed/simple;
	bh=6L7V/scOUMrLvSwy1NoEO+t9Hhqz3wCudBXQWYhCukU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=r8l2EUmLopElF4ukt9oXDNFz0IJd4vk2KDzJKf2quyhv6FfHx5HmiNhrX28T2FzIYgDus6Z7zAviHE+LMsziwy9ufGt1JlnmOlyiJ7vrefXy3KDk8qkKLTiA0FE3vhUH6X5PanoRYh4N4gi1xmxop1ctXPH6n64XSUM7cViwUeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=A+Vy6dky; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="A+Vy6dky"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746012921; x=1777548921;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6L7V/scOUMrLvSwy1NoEO+t9Hhqz3wCudBXQWYhCukU=;
  b=A+Vy6dkyygxMTgj27gYGaylj4sPpGVwXrDRNvMdve3MIWLlHSTWGaQB/
   V70lV9oFQvu51Awo+s0F1uK9PUtlDJy3C1H7817JB9FidfvP1BGZqF9q9
   x7x/nn19IdjKG0m4Rs+fviU8vAVze0fUgYFbUxU9A9cOTSpK+yIeRX8PO
   seyXt/+MtV89nG/NlLXdg0slQCL/JtbqzvklyZ/HXjhxXty6t2hMoHJ+Z
   N9NQv3Zx/Tkczpj9Jpw/BX8VnFnh9SzM/8Q6d9D3eDg7e3sYNaf7S53hs
   j/eOca+PNja6UhFCsdTxHv4Mf40JKsQYqglF23TCq87fXqyieSQs5CxKh
   g==;
X-CSE-ConnectionGUID: Xgr1ho3yTuCbObipgl4UXg==
X-CSE-MsgGUID: Ia3GWXKYQOegdTSp4SFnaw==
X-IronPort-AV: E=McAfee;i="6700,10204,11418"; a="51331164"
X-IronPort-AV: E=Sophos;i="6.15,251,1739865600"; 
   d="scan'208";a="51331164"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2025 04:35:21 -0700
X-CSE-ConnectionGUID: Rg55coD8RT2RtBoUsEYyoQ==
X-CSE-MsgGUID: yPdyuuWPT+eWuGSKfUz/aw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,251,1739865600"; 
   d="scan'208";a="133812559"
Received: from t21-qat.iind.intel.com ([10.49.15.35])
  by orviesa009.jf.intel.com with ESMTP; 30 Apr 2025 04:35:19 -0700
From: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com
Subject: [PATCH 10/11] crypto: qat - add firmware headers for GEN6 devices
Date: Wed, 30 Apr 2025 12:34:52 +0100
Message-Id: <20250430113453.1587497-11-suman.kumar.chakraborty@intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20250430113453.1587497-1-suman.kumar.chakraborty@intel.com>
References: <20250430113453.1587497-1-suman.kumar.chakraborty@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add firmware headers related to compression that define macros for
building the hardware configuration word, along with bitfields related
to algorithm settings.

Signed-off-by: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 .../intel/qat/qat_common/icp_qat_hw_51_comp.h |  99 ++++++
 .../qat/qat_common/icp_qat_hw_51_comp_defs.h  | 318 ++++++++++++++++++
 2 files changed, 417 insertions(+)
 create mode 100644 drivers/crypto/intel/qat/qat_common/icp_qat_hw_51_comp.h
 create mode 100644 drivers/crypto/intel/qat/qat_common/icp_qat_hw_51_comp_defs.h

diff --git a/drivers/crypto/intel/qat/qat_common/icp_qat_hw_51_comp.h b/drivers/crypto/intel/qat/qat_common/icp_qat_hw_51_comp.h
new file mode 100644
index 000000000000..dce639152345
--- /dev/null
+++ b/drivers/crypto/intel/qat/qat_common/icp_qat_hw_51_comp.h
@@ -0,0 +1,99 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/* Copyright(c) 2025 Intel Corporation */
+#ifndef ICP_QAT_HW_51_COMP_H_
+#define ICP_QAT_HW_51_COMP_H_
+
+#include <linux/types.h>
+
+#include "icp_qat_fw.h"
+#include "icp_qat_hw_51_comp_defs.h"
+
+struct icp_qat_hw_comp_51_config_csr_lower {
+	enum icp_qat_hw_comp_51_abd abd;
+	enum icp_qat_hw_comp_51_lllbd_ctrl lllbd;
+	enum icp_qat_hw_comp_51_search_depth sd;
+	enum icp_qat_hw_comp_51_min_match_control mmctrl;
+	enum icp_qat_hw_comp_51_lz4_block_checksum lbc;
+};
+
+static inline u32
+ICP_QAT_FW_COMP_51_BUILD_CONFIG_LOWER(struct icp_qat_hw_comp_51_config_csr_lower csr)
+{
+	u32 val32 = 0;
+
+	QAT_FIELD_SET(val32, csr.abd,
+		      ICP_QAT_HW_COMP_51_CONFIG_CSR_ABD_BITPOS,
+		      ICP_QAT_HW_COMP_51_CONFIG_CSR_ABD_MASK);
+	QAT_FIELD_SET(val32, csr.lllbd,
+		      ICP_QAT_HW_COMP_51_CONFIG_CSR_LLLBD_CTRL_BITPOS,
+		      ICP_QAT_HW_COMP_51_CONFIG_CSR_LLLBD_CTRL_MASK);
+	QAT_FIELD_SET(val32, csr.sd,
+		      ICP_QAT_HW_COMP_51_CONFIG_CSR_SEARCH_DEPTH_BITPOS,
+		      ICP_QAT_HW_COMP_51_CONFIG_CSR_SEARCH_DEPTH_MASK);
+	QAT_FIELD_SET(val32, csr.mmctrl,
+		      ICP_QAT_HW_COMP_51_CONFIG_CSR_MIN_MATCH_CONTROL_BITPOS,
+		      ICP_QAT_HW_COMP_51_CONFIG_CSR_MIN_MATCH_CONTROL_MASK);
+	QAT_FIELD_SET(val32, csr.lbc,
+		      ICP_QAT_HW_COMP_51_CONFIG_CSR_LZ4_BLOCK_CHECKSUM_BITPOS,
+		      ICP_QAT_HW_COMP_51_CONFIG_CSR_LZ4_BLOCK_CHECKSUM_MASK);
+
+	return val32;
+}
+
+struct icp_qat_hw_comp_51_config_csr_upper {
+	enum icp_qat_hw_comp_51_dmm_algorithm edmm;
+	enum icp_qat_hw_comp_51_bms bms;
+	enum icp_qat_hw_comp_51_scb_mode_reset_mask scb_mode_reset;
+};
+
+static inline u32
+ICP_QAT_FW_COMP_51_BUILD_CONFIG_UPPER(struct icp_qat_hw_comp_51_config_csr_upper csr)
+{
+	u32 val32 = 0;
+
+	QAT_FIELD_SET(val32, csr.edmm,
+		      ICP_QAT_HW_COMP_51_CONFIG_CSR_DMM_ALGORITHM_BITPOS,
+		      ICP_QAT_HW_COMP_51_CONFIG_CSR_DMM_ALGORITHM_MASK);
+	QAT_FIELD_SET(val32, csr.bms,
+		      ICP_QAT_HW_COMP_51_CONFIG_CSR_BMS_BITPOS,
+		      ICP_QAT_HW_COMP_51_CONFIG_CSR_BMS_MASK);
+	QAT_FIELD_SET(val32, csr.scb_mode_reset,
+		      ICP_QAT_HW_COMP_51_CONFIG_CSR_SCB_MODE_RESET_MASK_BITPOS,
+		      ICP_QAT_HW_COMP_51_CONFIG_CSR_SCB_MODE_RESET_MASK_MASK);
+
+	return val32;
+}
+
+struct icp_qat_hw_decomp_51_config_csr_lower {
+	enum icp_qat_hw_decomp_51_lz4_block_checksum lbc;
+};
+
+static inline u32
+ICP_QAT_FW_DECOMP_51_BUILD_CONFIG_LOWER(struct icp_qat_hw_decomp_51_config_csr_lower csr)
+{
+	u32 val32 = 0;
+
+	QAT_FIELD_SET(val32, csr.lbc,
+		      ICP_QAT_HW_DECOMP_51_CONFIG_CSR_LZ4_BLOCK_CHECKSUM_BITPOS,
+		      ICP_QAT_HW_DECOMP_51_CONFIG_CSR_LZ4_BLOCK_CHECKSUM_MASK);
+
+	return val32;
+}
+
+struct icp_qat_hw_decomp_51_config_csr_upper {
+	enum icp_qat_hw_decomp_51_bms bms;
+};
+
+static inline u32
+ICP_QAT_FW_DECOMP_51_BUILD_CONFIG_UPPER(struct icp_qat_hw_decomp_51_config_csr_upper csr)
+{
+	u32 val32 = 0;
+
+	QAT_FIELD_SET(val32, csr.bms,
+		      ICP_QAT_HW_DECOMP_51_CONFIG_CSR_BMS_BITPOS,
+		      ICP_QAT_HW_DECOMP_51_CONFIG_CSR_BMS_MASK);
+
+	return val32;
+}
+
+#endif /* ICP_QAT_HW_51_COMP_H_ */
diff --git a/drivers/crypto/intel/qat/qat_common/icp_qat_hw_51_comp_defs.h b/drivers/crypto/intel/qat/qat_common/icp_qat_hw_51_comp_defs.h
new file mode 100644
index 000000000000..e745688c5da4
--- /dev/null
+++ b/drivers/crypto/intel/qat/qat_common/icp_qat_hw_51_comp_defs.h
@@ -0,0 +1,318 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/* Copyright(c) 2025 Intel Corporation */
+#ifndef ICP_QAT_HW_51_COMP_DEFS_H_
+#define ICP_QAT_HW_51_COMP_DEFS_H_
+
+#include <linux/bits.h>
+
+#define ICP_QAT_HW_COMP_51_CONFIG_CSR_SOM_CONTROL_BITPOS	28
+#define ICP_QAT_HW_COMP_51_CONFIG_CSR_SOM_CONTROL_MASK		GENMASK(1, 0)
+enum icp_qat_hw_comp_51_som_control {
+	ICP_QAT_HW_COMP_51_SOM_CONTROL_NORMAL_MODE = 0x0,
+	ICP_QAT_HW_COMP_51_SOM_CONTROL_DICTIONARY_MODE = 0x1,
+	ICP_QAT_HW_COMP_51_SOM_CONTROL_INPUT_CRC = 0x2,
+	ICP_QAT_HW_COMP_51_SOM_CONTROL_RESERVED_MODE = 0x3,
+};
+
+#define ICP_QAT_HW_COMP_51_CONFIG_CSR_SOM_CONTROL_DEFAULT_VAL \
+	ICP_QAT_HW_COMP_51_SOM_CONTROL_NORMAL_MODE
+#define ICP_QAT_HW_COMP_51_CONFIG_CSR_SKIP_HASH_RD_CONTROL_BITPOS	27
+#define ICP_QAT_HW_COMP_51_CONFIG_CSR_SKIP_HASH_RD_CONTROL_MASK		GENMASK(0, 0)
+enum icp_qat_hw_comp_51_skip_hash_rd_control {
+	ICP_QAT_HW_COMP_51_SKIP_HASH_RD_CONTROL_NO_SKIP = 0x0,
+	ICP_QAT_HW_COMP_51_SKIP_HASH_RD_CONTROL_SKIP_HASH_READS = 0x1,
+};
+
+#define ICP_QAT_HW_COMP_51_CONFIG_CSR_SKIP_HASH_RD_CONTROL_DEFAULT_VAL \
+	ICP_QAT_HW_COMP_51_SKIP_HASH_RD_CONTROL_NO_SKIP
+#define ICP_QAT_HW_COMP_51_CONFIG_CSR_BYPASS_COMPRESSION_BITPOS	25
+#define ICP_QAT_HW_COMP_51_CONFIG_CSR_BYPASS_COMPRESSION_MASK	GENMASK(0, 0)
+enum icp_qat_hw_comp_51_bypass_compression {
+	ICP_QAT_HW_COMP_51_BYPASS_COMPRESSION_DISABLED = 0x0,
+	ICP_QAT_HW_COMP_51_BYPASS_COMPRESSION_ENABLED = 0x1,
+};
+
+#define ICP_QAT_HW_COMP_51_CONFIG_CSR_BYPASS_COMPRESSION_DEFAULT_VAL \
+	ICP_QAT_HW_COMP_51_BYPASS_COMPRESSION_DISABLED
+#define ICP_QAT_HW_COMP_51_CONFIG_CSR_DMM_ALGORITHM_BITPOS	22
+#define ICP_QAT_HW_COMP_51_CONFIG_CSR_DMM_ALGORITHM_MASK	GENMASK(0, 0)
+enum icp_qat_hw_comp_51_dmm_algorithm {
+	ICP_QAT_HW_COMP_51_DMM_ALGORITHM_EDMM_ENABLED = 0x0,
+	ICP_QAT_HW_COMP_51_DMM_ALGORITHM_ZSTD_DMM_LITE = 0x1,
+};
+
+#define ICP_QAT_HW_COMP_51_CONFIG_CSR_DMM_ALGORITHM_DEFAULT_VAL \
+	ICP_QAT_HW_COMP_51_DMM_ALGORITHM_EDMM_ENABLED
+#define ICP_QAT_HW_COMP_51_CONFIG_CSR_TOKEN_FUSION_INTERNAL_ONLY_BITPOS	21
+#define ICP_QAT_HW_COMP_51_CONFIG_CSR_TOKEN_FUSION_INTERNAL_ONLY_MASK	GENMASK(0, 0)
+enum icp_qat_hw_comp_51_token_fusion_internal_only {
+	ICP_QAT_HW_COMP_51_TOKEN_FUSION_INTERNAL_ONLY_ENABLED = 0x0,
+	ICP_QAT_HW_COMP_51_TOKEN_FUSION_INTERNAL_ONLY_DISABLED = 0x1,
+};
+
+#define ICP_QAT_HW_COMP_51_CONFIG_CSR_TOKEN_FUSION_INTERNAL_ONLY_DEFAULT_VAL \
+	ICP_QAT_HW_COMP_51_TOKEN_FUSION_INTERNAL_ONLY_ENABLED
+#define ICP_QAT_HW_COMP_51_CONFIG_CSR_BMS_BITPOS	19
+#define ICP_QAT_HW_COMP_51_CONFIG_CSR_BMS_MASK		GENMASK(1, 0)
+enum icp_qat_hw_comp_51_bms {
+	ICP_QAT_HW_COMP_51_BMS_BMS_64KB = 0x0,
+	ICP_QAT_HW_COMP_51_BMS_BMS_256KB = 0x1,
+	ICP_QAT_HW_COMP_51_BMS_BMS_1MB = 0x2,
+	ICP_QAT_HW_COMP_51_BMS_BMS_4MB = 0x3,
+};
+
+#define ICP_QAT_HW_COMP_51_CONFIG_CSR_BMS_DEFAULT_VAL \
+	ICP_QAT_HW_COMP_51_BMS_BMS_64KB
+#define ICP_QAT_HW_COMP_51_CONFIG_CSR_SCB_MODE_RESET_MASK_BITPOS	18
+#define ICP_QAT_HW_COMP_51_CONFIG_CSR_SCB_MODE_RESET_MASK_MASK		GENMASK(0, 0)
+enum icp_qat_hw_comp_51_scb_mode_reset_mask {
+	ICP_QAT_HW_COMP_51_SCB_MODE_RESET_MASK_DO_NOT_RESET_HB_HT = 0x0,
+	ICP_QAT_HW_COMP_51_SCB_MODE_RESET_MASK_RESET_HB_HT = 0x1,
+};
+
+#define ICP_QAT_HW_COMP_51_CONFIG_CSR_SCB_MODE_RESET_MASK_DEFAULT_VAL \
+	ICP_QAT_HW_COMP_51_SCB_MODE_RESET_MASK_DO_NOT_RESET_HB_HT
+#define ICP_QAT_HW_COMP_51_CONFIG_CSR_ZSTD_FRAME_GEN_DEC_EN_BITPOS	2
+#define ICP_QAT_HW_COMP_51_CONFIG_CSR_ZSTD_FRAME_GEN_DEC_EN_MASK	GENMASK(0, 0)
+enum icp_qat_hw_comp_51_zstd_frame_gen_dec_en {
+	ICP_QAT_HW_COMP_51_ZSTD_FRAME_GEN_DEC_EN_ZSTD_FRAME_HDR_DISABLE = 0x0,
+	ICP_QAT_HW_COMP_51_ZSTD_FRAME_GEN_DEC_EN_ZSTD_FRAME_HDR_ENABLE = 0x1,
+};
+
+#define ICP_QAT_HW_COMP_51_CONFIG_CSR_ZSTD_FRAME_GEN_DEC_EN_DEFAULT_VAL \
+	ICP_QAT_HW_COMP_51_ZSTD_FRAME_GEN_DEC_EN_ZSTD_FRAME_HDR_ENABLE
+#define ICP_QAT_HW_COMP_51_CONFIG_CSR_CNV_DISABLE_BITPOS	1
+#define ICP_QAT_HW_COMP_51_CONFIG_CSR_CNV_DISABLE_MASK		GENMASK(0, 0)
+enum icp_qat_hw_comp_51_cnv_disable {
+	ICP_QAT_HW_COMP_51_CNV_DISABLE_CNV_ENABLED = 0x0,
+	ICP_QAT_HW_COMP_51_CNV_DISABLE_CNV_DISABLED = 0x1,
+};
+
+#define ICP_QAT_HW_COMP_51_CONFIG_CSR_CNV_DISABLE_DEFAULT_VAL \
+	ICP_QAT_HW_COMP_51_CNV_DISABLE_CNV_ENABLED
+#define ICP_QAT_HW_COMP_51_CONFIG_CSR_ASB_DISABLE_BITPOS	0
+#define ICP_QAT_HW_COMP_51_CONFIG_CSR_ASB_DISABLE_MASK		GENMASK(0, 0)
+enum icp_qat_hw_comp_51_asb_disable {
+	ICP_QAT_HW_COMP_51_ASB_DISABLE_ASB_ENABLED = 0x0,
+	ICP_QAT_HW_COMP_51_ASB_DISABLE_ASB_DISABLED = 0x1,
+};
+
+#define ICP_QAT_HW_COMP_51_CONFIG_CSR_ASB_DISABLE_DEFAULT_VAL \
+	ICP_QAT_HW_COMP_51_ASB_DISABLE_ASB_ENABLED
+#define ICP_QAT_HW_COMP_51_CONFIG_CSR_SPEC_DECODER_INTERNAL_ONLY_BITPOS	21
+#define ICP_QAT_HW_COMP_51_CONFIG_CSR_SPEC_DECODER_INTERNAL_ONLY_MASK	GENMASK(0, 0)
+enum icp_qat_hw_comp_51_spec_decoder_internal_only {
+	ICP_QAT_HW_COMP_51_SPEC_DECODER_INTERNAL_ONLY_NORMAL = 0x0,
+	ICP_QAT_HW_COMP_51_SPEC_DECODER_INTERNAL_ONLY_DISABLED = 0x1,
+};
+
+#define ICP_QAT_HW_COMP_51_CONFIG_CSR_SPEC_DECODER_INTERNAL_ONLY_DEFAULT_VAL \
+	ICP_QAT_HW_COMP_51_SPEC_DECODER_INTERNAL_ONLY_NORMAL
+#define ICP_QAT_HW_COMP_51_CONFIG_CSR_MINI_XCAM_INTERNAL_ONLY_BITPOS	20
+#define ICP_QAT_HW_COMP_51_CONFIG_CSR_MINI_XCAM_INTERNAL_ONLY_MASK	GENMASK(0, 0)
+enum icp_qat_hw_comp_51_mini_xcam_internal_only {
+	ICP_QAT_HW_COMP_51_MINI_XCAM_INTERNAL_ONLY_NORMAL = 0x0,
+	ICP_QAT_HW_COMP_51_MINI_XCAM_INTERNAL_ONLY_DISABLED = 0x1,
+};
+
+#define ICP_QAT_HW_COMP_51_CONFIG_CSR_MINI_XCAM_INTERNAL_ONLY_DEFAULT_VAL \
+	ICP_QAT_HW_COMP_51_MINI_XCAM_INTERNAL_ONLY_NORMAL
+#define ICP_QAT_HW_COMP_51_CONFIG_CSR_REP_OFF_ENC_INTERNAL_ONLY_BITPOS	19
+#define ICP_QAT_HW_COMP_51_CONFIG_CSR_REP_OFF_ENC_INTERNAL_ONLY_MASK	GENMASK(0, 0)
+enum icp_qat_hw_comp_51_rep_off_enc_internal_only {
+	ICP_QAT_HW_COMP_51_REP_OFF_ENC_INTERNAL_ONLY_ENABLED = 0x0,
+	ICP_QAT_HW_COMP_51_REP_OFF_ENC_INTERNAL_ONLY_DISABLED = 0x1,
+};
+
+#define ICP_QAT_HW_COMP_51_CONFIG_CSR_REP_OFF_ENC_INTERNAL_ONLY_DEFAULT_VAL \
+	ICP_QAT_HW_COMP_51_REP_OFF_ENC_INTERNAL_ONLY_ENABLED
+#define ICP_QAT_HW_COMP_51_CONFIG_CSR_PROG_BLOCK_DROP_INTERNAL_ONLY_BITPOS	18
+#define ICP_QAT_HW_COMP_51_CONFIG_CSR_PROG_BLOCK_DROP_INTERNAL_ONLY_MASK	GENMASK(0, 0)
+enum icp_qat_hw_comp_51_prog_block_drop_internal_only {
+	ICP_QAT_HW_COMP_51_PROG_BLOCK_DROP_INTERNAL_ONLY_DISABLE = 0x0,
+	ICP_QAT_HW_COMP_51_PROG_BLOCK_DROP_INTERNAL_ONLY_ENABLE = 0x1,
+};
+
+#define ICP_QAT_HW_COMP_51_CONFIG_CSR_PROG_BLOCK_DROP_INTERNAL_ONLY_DEFAULT_VAL \
+	ICP_QAT_HW_COMP_51_PROG_BLOCK_DROP_INTERNAL_ONLY_DISABLE
+#define ICP_QAT_HW_COMP_51_CONFIG_CSR_SKIP_HASH_OVERRIDE_INTERNAL_ONLY_BITPOS	17
+#define ICP_QAT_HW_COMP_51_CONFIG_CSR_SKIP_HASH_OVERRIDE_INTERNAL_ONLY_MASK	GENMASK(0, 0)
+enum icp_qat_hw_comp_51_skip_hash_override_internal_only {
+	ICP_QAT_HW_COMP_51_SKIP_HASH_OVERRIDE_INTERNAL_ONLY_DETERMINE_HASH_PARAMS = 0x0,
+	ICP_QAT_HW_COMP_51_SKIP_HASH_OVERRIDE_INTERNAL_ONLY_OVERRIDE_HASH_PARAMS = 0x1,
+};
+
+#define ICP_QAT_HW_COMP_51_CONFIG_CSR_SKIP_HASH_OVERRIDE_INTERNAL_ONLY_DEFAULT_VAL \
+	ICP_QAT_HW_COMP_51_SKIP_HASH_OVERRIDE_INTERNAL_ONLY_DETERMINE_HASH_PARAMS
+#define ICP_QAT_HW_COMP_51_CONFIG_CSR_HBS_BITPOS	14
+#define ICP_QAT_HW_COMP_51_CONFIG_CSR_HBS_MASK		GENMASK(2, 0)
+enum icp_qat_hw_comp_51_hbs {
+	ICP_QAT_HW_COMP_51_HBS_32KB = 0x0,
+	ICP_QAT_HW_COMP_51_HBS_64KB = 0x1,
+};
+
+#define ICP_QAT_HW_COMP_51_CONFIG_CSR_HBS_DEFAULT_VAL \
+	ICP_QAT_HW_COMP_51_HBS_32KB
+#define ICP_QAT_HW_COMP_51_CONFIG_CSR_ABD_BITPOS	13
+#define ICP_QAT_HW_COMP_51_CONFIG_CSR_ABD_MASK		GENMASK(0, 0)
+enum icp_qat_hw_comp_51_abd {
+	ICP_QAT_HW_COMP_51_ABD_ABD_ENABLED = 0x0,
+	ICP_QAT_HW_COMP_51_ABD_ABD_DISABLED = 0x1,
+};
+
+#define ICP_QAT_HW_COMP_51_CONFIG_CSR_ABD_DEFAULT_VAL \
+	ICP_QAT_HW_COMP_51_ABD_ABD_ENABLED
+#define ICP_QAT_HW_COMP_51_CONFIG_CSR_LLLBD_CTRL_BITPOS	12
+#define ICP_QAT_HW_COMP_51_CONFIG_CSR_LLLBD_CTRL_MASK	GENMASK(0, 0)
+enum icp_qat_hw_comp_51_lllbd_ctrl {
+	ICP_QAT_HW_COMP_51_LLLBD_CTRL_LLLBD_ENABLED = 0x0,
+	ICP_QAT_HW_COMP_51_LLLBD_CTRL_LLLBD_DISABLED = 0x1,
+};
+
+#define ICP_QAT_HW_COMP_51_CONFIG_CSR_LLLBD_CTRL_DEFAULT_VAL \
+	ICP_QAT_HW_COMP_51_LLLBD_CTRL_LLLBD_ENABLED
+#define ICP_QAT_HW_COMP_51_CONFIG_CSR_SEARCH_DEPTH_BITPOS	8
+#define ICP_QAT_HW_COMP_51_CONFIG_CSR_SEARCH_DEPTH_MASK		GENMASK(3, 0)
+enum icp_qat_hw_comp_51_search_depth {
+	ICP_QAT_HW_COMP_51_SEARCH_DEPTH_LEVEL_1 = 0x1,
+	ICP_QAT_HW_COMP_51_SEARCH_DEPTH_LEVEL_6 = 0x3,
+	ICP_QAT_HW_COMP_51_SEARCH_DEPTH_LEVEL_9 = 0x4,
+	ICP_QAT_HW_COMP_51_SEARCH_DEPTH_LEVEL_10 = 0x4,
+};
+
+#define ICP_QAT_HW_COMP_51_CONFIG_CSR_SEARCH_DEPTH_DEFAULT_VAL \
+	ICP_QAT_HW_COMP_51_SEARCH_DEPTH_LEVEL_1
+#define ICP_QAT_HW_COMP_51_CONFIG_CSR_FORMAT_BITPOS	5
+#define ICP_QAT_HW_COMP_51_CONFIG_CSR_FORMAT_MASK	GENMASK(2, 0)
+enum icp_qat_hw_comp_51_format {
+	ICP_QAT_HW_COMP_51_FORMAT_ILZ77 = 0x1,
+	ICP_QAT_HW_COMP_51_FORMAT_LZ4 = 0x2,
+	ICP_QAT_HW_COMP_51_FORMAT_LZ4s = 0x3,
+	ICP_QAT_HW_COMP_51_FORMAT_ZSTD = 0x4,
+};
+
+#define ICP_QAT_HW_COMP_51_CONFIG_CSR_FORMAT_DEFAULT_VAL \
+	ICP_QAT_HW_COMP_51_FORMAT_ILZ77
+#define ICP_QAT_HW_COMP_51_CONFIG_CSR_MIN_MATCH_CONTROL_BITPOS	4
+#define ICP_QAT_HW_COMP_51_CONFIG_CSR_MIN_MATCH_CONTROL_MASK	GENMASK(0, 0)
+enum icp_qat_hw_comp_51_min_match_control {
+	ICP_QAT_HW_COMP_51_MIN_MATCH_CONTROL_MATCH_3B = 0x0,
+	ICP_QAT_HW_COMP_51_MIN_MATCH_CONTROL_MATCH_4B = 0x1,
+};
+
+#define ICP_QAT_HW_COMP_51_CONFIG_CSR_MIN_MATCH_CONTROL_DEFAULT_VAL \
+	ICP_QAT_HW_COMP_51_MIN_MATCH_CONTROL_MATCH_3B
+#define ICP_QAT_HW_COMP_51_CONFIG_CSR_SKIP_HASH_COLLISION_BITPOS	3
+#define ICP_QAT_HW_COMP_51_CONFIG_CSR_SKIP_HASH_COLLISION_MASK		GENMASK(0, 0)
+enum icp_qat_hw_comp_51_skip_hash_collision {
+	ICP_QAT_HW_COMP_51_SKIP_HASH_COLLISION_ALLOW = 0x0,
+	ICP_QAT_HW_COMP_51_SKIP_HASH_COLLISION_DONT_ALLOW = 0x1,
+};
+
+#define ICP_QAT_HW_COMP_51_CONFIG_CSR_SKIP_HASH_COLLISION_DEFAULT_VAL \
+	ICP_QAT_HW_COMP_51_SKIP_HASH_COLLISION_ALLOW
+#define ICP_QAT_HW_COMP_51_CONFIG_CSR_SKIP_HASH_UPDATE_BITPOS	2
+#define ICP_QAT_HW_COMP_51_CONFIG_CSR_SKIP_HASH_UPDATE_MASK	GENMASK(0, 0)
+enum icp_qat_hw_comp_51_skip_hash_update {
+	ICP_QAT_HW_COMP_51_SKIP_HASH_UPDATE_ALLOW = 0x0,
+	ICP_QAT_HW_COMP_51_SKIP_HASH_UPDATE_DONT_ALLOW = 0x1,
+};
+
+#define ICP_QAT_HW_COMP_51_CONFIG_CSR_SKIP_HASH_UPDATE_DEFAULT_VAL \
+	ICP_QAT_HW_COMP_51_SKIP_HASH_UPDATE_ALLOW
+#define ICP_QAT_HW_COMP_51_CONFIG_CSR_BYTE_SKIP_BITPOS	1
+#define ICP_QAT_HW_COMP_51_CONFIG_CSR_BYTE_SKIP_MASK	GENMASK(0, 0)
+enum icp_qat_hw_comp_51_byte_skip {
+	ICP_QAT_HW_COMP_51_BYTE_SKIP_3BYTE_TOKEN = 0x0,
+	ICP_QAT_HW_COMP_51_BYTE_SKIP_3BYTE_LITERAL = 0x1,
+};
+
+#define ICP_QAT_HW_COMP_51_CONFIG_CSR_BYTE_SKIP_DEFAULT_VAL \
+	ICP_QAT_HW_COMP_51_BYTE_SKIP_3BYTE_TOKEN
+#define ICP_QAT_HW_COMP_51_CONFIG_CSR_LZ4_BLOCK_CHECKSUM_BITPOS	0
+#define ICP_QAT_HW_COMP_51_CONFIG_CSR_LZ4_BLOCK_CHECKSUM_MASK	GENMASK(0, 0)
+enum icp_qat_hw_comp_51_lz4_block_checksum {
+	ICP_QAT_HW_COMP_51_LZ4_BLOCK_CHECKSUM_ABSENT = 0x0,
+	ICP_QAT_HW_COMP_51_LZ4_BLOCK_CHECKSUM_PRESENT = 0x1,
+};
+
+#define ICP_QAT_HW_COMP_51_CONFIG_CSR_LZ4_BLOCK_CHECKSUM_DEFAULT_VAL \
+	ICP_QAT_HW_COMP_51_LZ4_BLOCK_CHECKSUM_ABSENT
+#define ICP_QAT_HW_DECOMP_51_CONFIG_CSR_DISCARD_DATA_BITPOS	26
+#define ICP_QAT_HW_DECOMP_51_CONFIG_CSR_DISCARD_DATA_MASK	GENMASK(0, 0)
+enum icp_qat_hw_decomp_51_discard_data {
+	ICP_QAT_HW_DECOMP_51_DISCARD_DATA_DISABLED = 0x0,
+	ICP_QAT_HW_DECOMP_51_DISCARD_DATA_ENABLED = 0x1,
+};
+
+#define ICP_QAT_HW_DECOMP_51_CONFIG_CSR_DISCARD_DATA_DEFAULT_VAL \
+	ICP_QAT_HW_DECOMP_51_DISCARD_DATA_DISABLED
+#define ICP_QAT_HW_DECOMP_51_CONFIG_CSR_BMS_BITPOS	19
+#define ICP_QAT_HW_DECOMP_51_CONFIG_CSR_BMS_MASK	GENMASK(1, 0)
+enum icp_qat_hw_decomp_51_bms {
+	ICP_QAT_HW_DECOMP_51_BMS_BMS_64KB = 0x0,
+	ICP_QAT_HW_DECOMP_51_BMS_BMS_256KB = 0x1,
+	ICP_QAT_HW_DECOMP_51_BMS_BMS_1MB = 0x2,
+	ICP_QAT_HW_DECOMP_51_BMS_BMS_4MB = 0x3,
+};
+
+#define ICP_QAT_HW_DECOMP_51_CONFIG_CSR_BMS_DEFAULT_VAL \
+	ICP_QAT_HW_DECOMP_51_BMS_BMS_64KB
+#define ICP_QAT_HW_DECOMP_51_CONFIG_CSR_ZSTD_FRAME_GEN_DEC_EN_BITPOS	2
+#define ICP_QAT_HW_DECOMP_51_CONFIG_CSR_ZSTD_FRAME_GEN_DEC_EN_MASK	GENMASK(0, 0)
+enum icp_qat_hw_decomp_51_zstd_frame_gen_dec_en {
+	ICP_QAT_HW_DECOMP_51_ZSTD_FRAME_GEN_DEC_EN_ZSTD_FRAME_HDR_DISABLE = 0x0,
+	ICP_QAT_HW_DECOMP_51_ZSTD_FRAME_GEN_DEC_EN_ZSTD_FRAME_HDR_ENABLE = 0x1,
+};
+
+#define ICP_QAT_HW_DECOMP_51_CONFIG_CSR_ZSTD_FRAME_GEN_DEC_EN_DEFAULT_VAL \
+	ICP_QAT_HW_DECOMP_51_ZSTD_FRAME_GEN_DEC_EN_ZSTD_FRAME_HDR_ENABLE
+#define ICP_QAT_HW_DECOMP_51_CONFIG_CSR_SPEC_DECODER_INTERNAL_ONLY_BITPOS	21
+#define ICP_QAT_HW_DECOMP_51_CONFIG_CSR_SPEC_DECODER_INTERNAL_ONLY_MASK		GENMASK(0, 0)
+enum icp_qat_hw_decomp_51_spec_decoder_internal_only {
+	ICP_QAT_HW_DECOMP_51_SPEC_DECODER_INTERNAL_ONLY_NORMAL = 0x0,
+	ICP_QAT_HW_DECOMP_51_SPEC_DECODER_INTERNAL_ONLY_DISABLED = 0x1,
+};
+
+#define ICP_QAT_HW_DECOMP_51_CONFIG_CSR_SPEC_DECODER_INTERNAL_ONLY_DEFAULT_VAL \
+	ICP_QAT_HW_DECOMP_51_SPEC_DECODER_INTERNAL_ONLY_NORMAL
+#define ICP_QAT_HW_DECOMP_51_CONFIG_CSR_MINI_XCAM_INTERNAL_ONLY_BITPOS	20
+#define ICP_QAT_HW_DECOMP_51_CONFIG_CSR_MINI_XCAM_INTERNAL_ONLY_MASK	GENMASK(0, 0)
+enum icp_qat_hw_decomp_51_mini_xcam_internal_only {
+	ICP_QAT_HW_DECOMP_51_MINI_XCAM_INTERNAL_ONLY_NORMAL = 0x0,
+	ICP_QAT_HW_DECOMP_51_MINI_XCAM_INTERNAL_ONLY_DISABLED = 0x1,
+};
+
+#define ICP_QAT_HW_DECOMP_51_CONFIG_CSR_MINI_XCAM_INTERNAL_ONLY_DEFAULT_VAL \
+	ICP_QAT_HW_DECOMP_51_MINI_XCAM_INTERNAL_ONLY_NORMAL
+#define ICP_QAT_HW_DECOMP_51_CONFIG_CSR_HBS_BITPOS	14
+#define ICP_QAT_HW_DECOMP_51_CONFIG_CSR_HBS_MASK	GENMASK(2, 0)
+enum icp_qat_hw_decomp_51_hbs {
+	ICP_QAT_HW_DECOMP_51_HBS_32KB = 0x0,
+	ICP_QAT_HW_DECOMP_51_HBS_64KB = 0x1,
+};
+
+#define ICP_QAT_HW_DECOMP_51_CONFIG_CSR_HBS_DEFAULT_VAL \
+	ICP_QAT_HW_DECOMP_51_HBS_32KB
+#define ICP_QAT_HW_DECOMP_51_CONFIG_CSR_FORMAT_BITPOS	5
+#define ICP_QAT_HW_DECOMP_51_CONFIG_CSR_FORMAT_MASK	GENMASK(2, 0)
+enum icp_qat_hw_decomp_51_format {
+	ICP_QAT_HW_DECOMP_51_FORMAT_ILZ77 = 0x1,
+	ICP_QAT_HW_DECOMP_51_FORMAT_LZ4 = 0x2,
+	ICP_QAT_HW_DECOMP_51_FORMAT_RESERVED = 0x3,
+	ICP_QAT_HW_DECOMP_51_FORMAT_ZSTD = 0x4,
+};
+
+#define ICP_QAT_HW_DECOMP_51_CONFIG_CSR_FORMAT_DEFAULT_VAL \
+	ICP_QAT_HW_DECOMP_51_FORMAT_ILZ77
+#define ICP_QAT_HW_DECOMP_51_CONFIG_CSR_LZ4_BLOCK_CHECKSUM_BITPOS	0
+#define ICP_QAT_HW_DECOMP_51_CONFIG_CSR_LZ4_BLOCK_CHECKSUM_MASK		GENMASK(0, 0)
+enum icp_qat_hw_decomp_51_lz4_block_checksum {
+	ICP_QAT_HW_DECOMP_51_LZ4_BLOCK_CHECKSUM_ABSENT = 0x0,
+	ICP_QAT_HW_DECOMP_51_LZ4_BLOCK_CHECKSUM_PRESENT = 0x1,
+};
+
+#define ICP_QAT_HW_DECOMP_51_CONFIG_CSR_LZ4_BLOCK_CHECKSUM_DEFAULT_VAL \
+	ICP_QAT_HW_DECOMP_51_LZ4_BLOCK_CHECKSUM_ABSENT
+
+#endif /* ICP_QAT_HW_51_COMP_DEFS_H_ */
-- 
2.40.1

