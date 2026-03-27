Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 817D436C0B9
	for <linux-crypto@vger.kernel.org>; Fri, 27 Mar 2026 21:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774648016; cv=none; b=j3P9GazUCIxP7Je1M/s3AtF+7iRuBFf37UpOlilXhSsrkNPab06QYrNc7gCKfPl1YZWEVMKVhwXJl1zZSVyMsYG7mrFTa+RwjtCLtZzPk2CiEVRpzPbBzq0ev1OiBlr5L4UnfXnxA+I44GzRD9YaiSyhdN+hBWVG3FLiT28EBfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774648016; c=relaxed/simple;
	bh=8rOUjearpOEgPxaGY6Wggmk5VJL6bQr0Yln7SWGj2J0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kYt02iVDHc4vT+dfI8fOuHtSs3BmSBP5+LqHeyRfkOQvtJZ8AHWYpSWBQMTH5lCNkweFLOFMuSCQuTkxqcoKun4JUUM199H06UB+l6PagyszKH0U9F2KlJsPFFIG+NZ5NcCWbf8Goq9ntqZifbFnb9GDouE0LZBadmeS3EgMujM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=apF/zzIF; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="apF/zzIF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774648013; x=1806184013;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=8rOUjearpOEgPxaGY6Wggmk5VJL6bQr0Yln7SWGj2J0=;
  b=apF/zzIFkcm8mKIhAlMLlxuYfWDtGDcj+NO/7c5Cv3P8t0C/4i+Upraw
   G/SQelwCe7CJxraBIvVX2P/p2qCyvSEZcM8LDaB2HiFeQfrFLnfE3fA7w
   6KjI9NQWhXHqQJNzClKhH1Ln0BY4xB42NQPQhejlcSFUAabTMx3hOjgh3
   wJtDzEa2xR8W/A4RpJD8k+TElVXRlpvH1e0h79hbu0DaVPM/Y1ST78uCW
   8dK+P62uFIHDtfGtDJCMs5jKxgIvv7iZKN1pQDoV+a5We1IU8Uw8ZnP/p
   Rn+7HX/29tFpFa+EYrWwDILOXEraHK6vNcF6pPCa1WNtOYqqvTnrV1SAH
   g==;
X-CSE-ConnectionGUID: SMNGndVSSneBbzXzpzfmLQ==
X-CSE-MsgGUID: 3a0W12uiTGKUQ5UUxA/FPw==
X-IronPort-AV: E=McAfee;i="6800,10657,11742"; a="79591298"
X-IronPort-AV: E=Sophos;i="6.23,144,1770624000"; 
   d="scan'208";a="79591298"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2026 14:46:53 -0700
X-CSE-ConnectionGUID: o7ljKIA1Sz+iSCYKVVGmFA==
X-CSE-MsgGUID: kaT2xBA0Q7ePtUrjpUbwyg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,144,1770624000"; 
   d="scan'208";a="263382837"
Received: from silpixa00401971.ir.intel.com ([10.20.226.106])
  by orviesa001.jf.intel.com with ESMTP; 27 Mar 2026 14:46:52 -0700
From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>,
	Laurent M Coquerel <laurent.m.coquerel@intel.com>
Subject: [PATCH] crypto: qat - add support for zstd
Date: Fri, 27 Mar 2026 21:37:05 +0000
Message-ID: <20260327214645.2098424-1-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit

Add support for the ZSTD algorithm for QAT GEN4, GEN5 and GEN6 via the
acomp API.

For GEN4 and GEN5, compression is performed in hardware using LZ4s, a
QAT-specific variant of LZ4. The compressed output is post-processed to
generate ZSTD sequences, and the ZSTD library is then used to produce
the final ZSTD stream via zstd_compress_sequences_and_literals(). Only
inputs between 8 KB and 512 KB are offloaded to the device. The minimum
size restriction will be relaxed once polling support is added. The
maximum size is limited by the use of pre-allocated per-CPU scratch
buffers. On these generations, only compression is offloaded to hardware;
decompression always falls back to software.

For GEN6, both compression and decompression are offloaded to the
accelerator, which natively supports the ZSTD algorithm. There is no
limit on the input buffer size supported. However, since GEN6 is limited
to a history size of 64 KB, decompression of frames compressed with a
larger history falls back to software.

Since GEN2 devices do not support ZSTD or LZ4s, add a mechanism that
prevents selecting GEN2 compression instances for ZSTD or LZ4s when a
GEN2 plug-in card is present on a system with an embedded GEN4, GEN5 or
GEN6 device.

In addition, modify the algorithm registration logic to allow
registering the correct implementation, i.e. LZ4s based for GEN4 and
GEN5 or native ZSTD for GEN6.

Co-developed-by: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
Signed-off-by: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Laurent M Coquerel <laurent.m.coquerel@intel.com>
---
 drivers/crypto/intel/qat/Kconfig              |   1 +
 .../intel/qat/qat_420xx/adf_420xx_hw_data.c   |   1 +
 .../intel/qat/qat_4xxx/adf_4xxx_hw_data.c     |   1 +
 .../intel/qat/qat_6xxx/adf_6xxx_hw_data.c     |  17 +
 drivers/crypto/intel/qat/qat_common/Makefile  |   1 +
 .../intel/qat/qat_common/adf_accel_devices.h  |   6 +
 .../intel/qat/qat_common/adf_common_drv.h     |   6 +-
 .../intel/qat/qat_common/adf_gen4_hw_data.c   |  18 +-
 .../crypto/intel/qat/qat_common/adf_init.c    |   6 +-
 .../crypto/intel/qat/qat_common/icp_qat_fw.h  |   7 +
 .../intel/qat/qat_common/icp_qat_fw_comp.h    |   2 +
 .../crypto/intel/qat/qat_common/icp_qat_hw.h  |   3 +-
 .../intel/qat/qat_common/qat_comp_algs.c      | 524 +++++++++++++++++-
 .../intel/qat/qat_common/qat_comp_req.h       |   9 +
 .../qat/qat_common/qat_comp_zstd_utils.c      | 165 ++++++
 .../qat/qat_common/qat_comp_zstd_utils.h      |  13 +
 .../intel/qat/qat_common/qat_compression.c    |  23 +-
 17 files changed, 773 insertions(+), 30 deletions(-)
 create mode 100644 drivers/crypto/intel/qat/qat_common/qat_comp_zstd_utils.c
 create mode 100644 drivers/crypto/intel/qat/qat_common/qat_comp_zstd_utils.h

diff --git a/drivers/crypto/intel/qat/Kconfig b/drivers/crypto/intel/qat/Kconfig
index 4b4861460dd4..9a48bc7c3118 100644
--- a/drivers/crypto/intel/qat/Kconfig
+++ b/drivers/crypto/intel/qat/Kconfig
@@ -11,6 +11,7 @@ config CRYPTO_DEV_QAT
 	select CRYPTO_LIB_SHA1
 	select CRYPTO_LIB_SHA256
 	select CRYPTO_LIB_SHA512
+	select CRYPTO_ZSTD
 	select FW_LOADER
 	select CRC8
 
diff --git a/drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c b/drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c
index 0002122219bc..19f9f738630b 100644
--- a/drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c
@@ -488,6 +488,7 @@ void adf_init_hw_data_420xx(struct adf_hw_device_data *hw_data, u32 dev_id)
 	hw_data->clock_frequency = ADF_420XX_AE_FREQ;
 	hw_data->services_supported = adf_gen4_services_supported;
 	hw_data->get_svc_slice_cnt = adf_gen4_get_svc_slice_cnt;
+	hw_data->accel_capabilities_ext_mask = ADF_ACCEL_CAPABILITIES_EXT_ZSTD_LZ4S;
 
 	adf_gen4_set_err_mask(&hw_data->dev_err_mask);
 	adf_gen4_init_hw_csr_ops(&hw_data->csr_ops);
diff --git a/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c b/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
index 900f19b90b2d..49b425be34c8 100644
--- a/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
@@ -473,6 +473,7 @@ void adf_init_hw_data_4xxx(struct adf_hw_device_data *hw_data, u32 dev_id)
 	hw_data->clock_frequency = ADF_4XXX_AE_FREQ;
 	hw_data->services_supported = adf_gen4_services_supported;
 	hw_data->get_svc_slice_cnt = adf_gen4_get_svc_slice_cnt;
+	hw_data->accel_capabilities_ext_mask = ADF_ACCEL_CAPABILITIES_EXT_ZSTD_LZ4S;
 
 	adf_gen4_set_err_mask(&hw_data->dev_err_mask);
 	adf_gen4_init_hw_csr_ops(&hw_data->csr_ops);
diff --git a/drivers/crypto/intel/qat/qat_6xxx/adf_6xxx_hw_data.c b/drivers/crypto/intel/qat/qat_6xxx/adf_6xxx_hw_data.c
index 177bc4eb3c24..205680797e2c 100644
--- a/drivers/crypto/intel/qat/qat_6xxx/adf_6xxx_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_6xxx/adf_6xxx_hw_data.c
@@ -33,6 +33,8 @@
 #define ADF_AE_GROUP_1		GENMASK(7, 4)
 #define ADF_AE_GROUP_2		BIT(8)
 
+#define ASB_MULTIPLIER		9
+
 struct adf_ring_config {
 	u32 ring_mask;
 	enum adf_cfg_service_type ring_type;
@@ -509,6 +511,9 @@ static int build_comp_block(void *ctx, enum adf_dc_algo algo)
 	case QAT_DEFLATE:
 		header->service_cmd_id = ICP_QAT_FW_COMP_CMD_DYNAMIC;
 	break;
+	case QAT_ZSTD:
+		header->service_cmd_id = ICP_QAT_FW_COMP_CMD_ZSTD_COMPRESS;
+	break;
 	default:
 		return -EINVAL;
 	}
@@ -519,6 +524,13 @@ static int build_comp_block(void *ctx, enum adf_dc_algo algo)
 	cd_pars->u.sl.comp_slice_cfg_word[0] = lower_val;
 	cd_pars->u.sl.comp_slice_cfg_word[1] = 0;
 
+	/*
+	 * Store Auto Select Best (ASB) multiplier in the request template.
+	 * This will be used in the data path to set the actual threshold
+	 * value based on the input data size.
+	 */
+	req_tmpl->u3.asb_threshold.asb_value = ASB_MULTIPLIER;
+
 	return 0;
 }
 
@@ -532,12 +544,16 @@ static int build_decomp_block(void *ctx, enum adf_dc_algo algo)
 	case QAT_DEFLATE:
 		header->service_cmd_id = ICP_QAT_FW_COMP_CMD_DECOMPRESS;
 	break;
+	case QAT_ZSTD:
+		header->service_cmd_id = ICP_QAT_FW_COMP_CMD_ZSTD_DECOMPRESS;
+	break;
 	default:
 		return -EINVAL;
 	}
 
 	cd_pars->u.sl.comp_slice_cfg_word[0] = 0;
 	cd_pars->u.sl.comp_slice_cfg_word[1] = 0;
+	req_tmpl->u3.asb_threshold.asb_value = 0;
 
 	return 0;
 }
@@ -1030,6 +1046,7 @@ void adf_init_hw_data_6xxx(struct adf_hw_device_data *hw_data)
 	hw_data->num_rps = ADF_GEN6_ETR_MAX_BANKS;
 	hw_data->clock_frequency = ADF_6XXX_AE_FREQ;
 	hw_data->get_svc_slice_cnt = adf_gen6_get_svc_slice_cnt;
+	hw_data->accel_capabilities_ext_mask = ADF_ACCEL_CAPABILITIES_EXT_ZSTD;
 
 	adf_gen6_init_services_supported(hw_data);
 	adf_gen6_init_hw_csr_ops(&hw_data->csr_ops);
diff --git a/drivers/crypto/intel/qat/qat_common/Makefile b/drivers/crypto/intel/qat/qat_common/Makefile
index 016b81e60cfb..9478111c8437 100644
--- a/drivers/crypto/intel/qat/qat_common/Makefile
+++ b/drivers/crypto/intel/qat/qat_common/Makefile
@@ -41,6 +41,7 @@ intel_qat-y := adf_accel_engine.o \
 	qat_bl.o \
 	qat_comp_algs.o \
 	qat_compression.o \
+	qat_comp_zstd_utils.o \
 	qat_crypto.o \
 	qat_hal.o \
 	qat_mig_dev.o \
diff --git a/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h b/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h
index cac110215c5e..03a4e9690208 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h
@@ -59,6 +59,11 @@ enum adf_accel_capabilities {
 	ADF_ACCEL_CAPABILITIES_RANDOM_NUMBER = 128
 };
 
+enum adf_accel_capabilities_ext {
+	ADF_ACCEL_CAPABILITIES_EXT_ZSTD_LZ4S = BIT(0),
+	ADF_ACCEL_CAPABILITIES_EXT_ZSTD = BIT(1),
+};
+
 enum adf_fuses {
 	ADF_FUSECTL0,
 	ADF_FUSECTL1,
@@ -336,6 +341,7 @@ struct adf_hw_device_data {
 	u32 fuses[ADF_MAX_FUSES];
 	u32 straps;
 	u32 accel_capabilities_mask;
+	u32 accel_capabilities_ext_mask;
 	u32 extended_dc_capabilities;
 	u16 fw_capabilities;
 	u32 clock_frequency;
diff --git a/drivers/crypto/intel/qat/qat_common/adf_common_drv.h b/drivers/crypto/intel/qat/qat_common/adf_common_drv.h
index 6cf3a95489e8..7b8b295ac459 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_common_drv.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_common_drv.h
@@ -111,12 +111,12 @@ void qat_algs_unregister(void);
 int qat_asym_algs_register(void);
 void qat_asym_algs_unregister(void);
 
-struct qat_compression_instance *qat_compression_get_instance_node(int node);
+struct qat_compression_instance *qat_compression_get_instance_node(int node, int alg);
 void qat_compression_put_instance(struct qat_compression_instance *inst);
 int qat_compression_register(void);
 int qat_compression_unregister(void);
-int qat_comp_algs_register(void);
-void qat_comp_algs_unregister(void);
+int qat_comp_algs_register(u32 caps);
+void qat_comp_algs_unregister(u32 caps);
 void qat_comp_alg_callback(void *resp);
 
 int adf_isr_resource_alloc(struct adf_accel_dev *accel_dev);
diff --git a/drivers/crypto/intel/qat/qat_common/adf_gen4_hw_data.c b/drivers/crypto/intel/qat/qat_common/adf_gen4_hw_data.c
index 349fdb323763..f4a58f04071a 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_gen4_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_gen4_hw_data.c
@@ -504,14 +504,20 @@ static int adf_gen4_build_comp_block(void *ctx, enum adf_dc_algo algo)
 	switch (algo) {
 	case QAT_DEFLATE:
 		header->service_cmd_id = ICP_QAT_FW_COMP_CMD_DYNAMIC;
+		hw_comp_lower_csr.algo = ICP_QAT_HW_COMP_20_HW_COMP_FORMAT_ILZ77;
+		hw_comp_lower_csr.lllbd = ICP_QAT_HW_COMP_20_LLLBD_CTRL_LLLBD_ENABLED;
+		hw_comp_lower_csr.skip_ctrl = ICP_QAT_HW_COMP_20_BYTE_SKIP_3BYTE_LITERAL;
+		break;
+	case QAT_LZ4S:
+		header->service_cmd_id = ICP_QAT_FW_COMP_20_CMD_LZ4S_COMPRESS;
+		hw_comp_lower_csr.algo = ICP_QAT_HW_COMP_20_HW_COMP_FORMAT_LZ4S;
+		hw_comp_lower_csr.lllbd = ICP_QAT_HW_COMP_20_LLLBD_CTRL_LLLBD_DISABLED;
+		hw_comp_lower_csr.abd = ICP_QAT_HW_COMP_20_ABD_ABD_DISABLED;
 		break;
 	default:
 		return -EINVAL;
 	}
 
-	hw_comp_lower_csr.skip_ctrl = ICP_QAT_HW_COMP_20_BYTE_SKIP_3BYTE_LITERAL;
-	hw_comp_lower_csr.algo = ICP_QAT_HW_COMP_20_HW_COMP_FORMAT_ILZ77;
-	hw_comp_lower_csr.lllbd = ICP_QAT_HW_COMP_20_LLLBD_CTRL_LLLBD_ENABLED;
 	hw_comp_lower_csr.sd = ICP_QAT_HW_COMP_20_SEARCH_DEPTH_LEVEL_1;
 	hw_comp_lower_csr.hash_update = ICP_QAT_HW_COMP_20_SKIP_HASH_UPDATE_DONT_ALLOW;
 	hw_comp_lower_csr.edmm = ICP_QAT_HW_COMP_20_EXTENDED_DELAY_MATCH_MODE_EDMM_ENABLED;
@@ -538,12 +544,16 @@ static int adf_gen4_build_decomp_block(void *ctx, enum adf_dc_algo algo)
 	switch (algo) {
 	case QAT_DEFLATE:
 		header->service_cmd_id = ICP_QAT_FW_COMP_CMD_DECOMPRESS;
+		hw_decomp_lower_csr.algo = ICP_QAT_HW_DECOMP_20_HW_DECOMP_FORMAT_DEFLATE;
+		break;
+	case QAT_LZ4S:
+		header->service_cmd_id = ICP_QAT_FW_COMP_20_CMD_LZ4S_DECOMPRESS;
+		hw_decomp_lower_csr.algo = ICP_QAT_HW_DECOMP_20_HW_DECOMP_FORMAT_LZ4S;
 		break;
 	default:
 		return -EINVAL;
 	}
 
-	hw_decomp_lower_csr.algo = ICP_QAT_HW_DECOMP_20_HW_DECOMP_FORMAT_DEFLATE;
 	lower_val = ICP_QAT_FW_DECOMP_20_BUILD_CONFIG_LOWER(hw_decomp_lower_csr);
 
 	cd_pars->u.sl.comp_slice_cfg_word[0] = lower_val;
diff --git a/drivers/crypto/intel/qat/qat_common/adf_init.c b/drivers/crypto/intel/qat/qat_common/adf_init.c
index ec376583b3ae..f8088388cf12 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_init.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_init.c
@@ -180,6 +180,7 @@ static int adf_dev_start(struct adf_accel_dev *accel_dev)
 {
 	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
 	struct service_hndl *service;
+	u32 caps;
 	int ret;
 
 	set_bit(ADF_STATUS_STARTING, &accel_dev->status);
@@ -253,7 +254,8 @@ static int adf_dev_start(struct adf_accel_dev *accel_dev)
 	}
 	set_bit(ADF_STATUS_CRYPTO_ALGS_REGISTERED, &accel_dev->status);
 
-	if (!list_empty(&accel_dev->compression_list) && qat_comp_algs_register()) {
+	caps = hw_data->accel_capabilities_ext_mask;
+	if (!list_empty(&accel_dev->compression_list) && qat_comp_algs_register(caps)) {
 		dev_err(&GET_DEV(accel_dev),
 			"Failed to register compression algs\n");
 		set_bit(ADF_STATUS_STARTING, &accel_dev->status);
@@ -308,7 +310,7 @@ static void adf_dev_stop(struct adf_accel_dev *accel_dev)
 
 	if (!list_empty(&accel_dev->compression_list) &&
 	    test_bit(ADF_STATUS_COMP_ALGS_REGISTERED, &accel_dev->status))
-		qat_comp_algs_unregister();
+		qat_comp_algs_unregister(hw_data->accel_capabilities_ext_mask);
 	clear_bit(ADF_STATUS_COMP_ALGS_REGISTERED, &accel_dev->status);
 
 	list_for_each_entry(service, &service_table, list) {
diff --git a/drivers/crypto/intel/qat/qat_common/icp_qat_fw.h b/drivers/crypto/intel/qat/qat_common/icp_qat_fw.h
index c141160421e1..2fea30a78340 100644
--- a/drivers/crypto/intel/qat/qat_common/icp_qat_fw.h
+++ b/drivers/crypto/intel/qat/qat_common/icp_qat_fw.h
@@ -151,6 +151,13 @@ struct icp_qat_fw_comn_resp {
 	ICP_QAT_FW_COMN_CNV_FLAG_BITPOS, \
 	ICP_QAT_FW_COMN_CNV_FLAG_MASK)
 
+#define ICP_QAT_FW_COMN_ST_BLK_FLAG_BITPOS 4
+#define ICP_QAT_FW_COMN_ST_BLK_FLAG_MASK 0x1
+#define ICP_QAT_FW_COMN_HDR_ST_BLK_FLAG_GET(hdr_flags) \
+	QAT_FIELD_GET(hdr_flags, \
+	ICP_QAT_FW_COMN_ST_BLK_FLAG_BITPOS, \
+	ICP_QAT_FW_COMN_ST_BLK_FLAG_MASK)
+
 #define ICP_QAT_FW_COMN_HDR_CNV_FLAG_SET(hdr_t, val) \
 	QAT_FIELD_SET((hdr_t.hdr_flags), (val), \
 	ICP_QAT_FW_COMN_CNV_FLAG_BITPOS, \
diff --git a/drivers/crypto/intel/qat/qat_common/icp_qat_fw_comp.h b/drivers/crypto/intel/qat/qat_common/icp_qat_fw_comp.h
index 81969c515a17..2526053ee630 100644
--- a/drivers/crypto/intel/qat/qat_common/icp_qat_fw_comp.h
+++ b/drivers/crypto/intel/qat/qat_common/icp_qat_fw_comp.h
@@ -8,6 +8,8 @@ enum icp_qat_fw_comp_cmd_id {
 	ICP_QAT_FW_COMP_CMD_STATIC = 0,
 	ICP_QAT_FW_COMP_CMD_DYNAMIC = 1,
 	ICP_QAT_FW_COMP_CMD_DECOMPRESS = 2,
+	ICP_QAT_FW_COMP_CMD_ZSTD_COMPRESS = 10,
+	ICP_QAT_FW_COMP_CMD_ZSTD_DECOMPRESS = 11,
 	ICP_QAT_FW_COMP_CMD_DELIMITER
 };
 
diff --git a/drivers/crypto/intel/qat/qat_common/icp_qat_hw.h b/drivers/crypto/intel/qat/qat_common/icp_qat_hw.h
index 0223bd541f1f..16ef6d98fa42 100644
--- a/drivers/crypto/intel/qat/qat_common/icp_qat_hw.h
+++ b/drivers/crypto/intel/qat/qat_common/icp_qat_hw.h
@@ -336,7 +336,8 @@ enum icp_qat_hw_compression_delayed_match {
 enum icp_qat_hw_compression_algo {
 	ICP_QAT_HW_COMPRESSION_ALGO_DEFLATE = 0,
 	ICP_QAT_HW_COMPRESSION_ALGO_LZS = 1,
-	ICP_QAT_HW_COMPRESSION_ALGO_DELIMITER = 2
+	ICP_QAT_HW_COMPRESSION_ALGO_ZSTD = 2,
+	ICP_QAT_HW_COMPRESSION_ALGO_DELIMITER
 };
 
 enum icp_qat_hw_compression_depth {
diff --git a/drivers/crypto/intel/qat/qat_common/qat_comp_algs.c b/drivers/crypto/intel/qat/qat_common/qat_comp_algs.c
index bfc820a08ada..e0d003b50358 100644
--- a/drivers/crypto/intel/qat/qat_common/qat_comp_algs.c
+++ b/drivers/crypto/intel/qat/qat_common/qat_comp_algs.c
@@ -6,6 +6,7 @@
 #include <crypto/scatterwalk.h>
 #include <linux/dma-mapping.h>
 #include <linux/workqueue.h>
+#include <linux/zstd.h>
 #include "adf_accel_devices.h"
 #include "adf_common_drv.h"
 #include "adf_dc.h"
@@ -13,9 +14,104 @@
 #include "qat_comp_req.h"
 #include "qat_compression.h"
 #include "qat_algs_send.h"
+#include "qat_comp_zstd_utils.h"
+
+#define QAT_ZSTD_SCRATCH_SIZE		524288
+#define QAT_ZSTD_MAX_BLOCK_SIZE		65535
+#define QAT_ZSTD_MAX_CONTENT_SIZE	4096
+#define QAT_LZ4S_MIN_INPUT_SIZE		8192
+#define QAT_LZ4S_MAX_OUTPUT_SIZE	QAT_ZSTD_SCRATCH_SIZE
+#define QAT_MAX_SEQUENCES		(128 * 1024)
 
 static DEFINE_MUTEX(algs_lock);
-static unsigned int active_devs;
+static unsigned int active_devs_deflate;
+static unsigned int active_devs_lz4s;
+static unsigned int active_devs_zstd;
+
+struct qat_zstd_scratch {
+	size_t		cctx_buffer_size;
+	void		*lz4s;
+	void		*literals;
+	void		*out_seqs;
+	void		*workspace;
+	ZSTD_CCtx	*ctx;
+};
+
+static void *qat_zstd_alloc_scratch(void)
+{
+	struct qat_zstd_scratch *scratch;
+	ZSTD_parameters params;
+	size_t cctx_size;
+	ZSTD_CCtx *ctx;
+	size_t zret;
+	int ret;
+
+	ret = -ENOMEM;
+	scratch = kzalloc_obj(*scratch);
+	if (!scratch)
+		return ERR_PTR(ret);
+
+	scratch->lz4s = kvmalloc(QAT_ZSTD_SCRATCH_SIZE, GFP_KERNEL);
+	if (!scratch->lz4s)
+		goto error;
+
+	scratch->literals = kvmalloc(QAT_ZSTD_SCRATCH_SIZE, GFP_KERNEL);
+	if (!scratch->literals)
+		goto error;
+
+	scratch->out_seqs = kvcalloc(QAT_MAX_SEQUENCES, sizeof(ZSTD_Sequence),
+				     GFP_KERNEL);
+	if (!scratch->out_seqs)
+		goto error;
+
+	params = zstd_get_params(zstd_max_clevel(), QAT_ZSTD_SCRATCH_SIZE);
+	cctx_size = zstd_cctx_workspace_bound(&params.cParams);
+
+	scratch->workspace = kvmalloc(cctx_size, GFP_KERNEL | __GFP_ZERO);
+	if (!scratch->workspace)
+		goto error;
+
+	ret = -EINVAL;
+	ctx = zstd_init_cctx(scratch->workspace, cctx_size);
+	if (!ctx)
+		goto error;
+
+	scratch->ctx = ctx;
+	scratch->cctx_buffer_size = cctx_size;
+
+	zret = zstd_cctx_set_param(ctx, ZSTD_c_blockDelimiters, ZSTD_sf_explicitBlockDelimiters);
+	if (zstd_is_error(zret))
+		goto error;
+
+	return scratch;
+
+error:
+	kvfree(scratch->lz4s);
+	kvfree(scratch->literals);
+	kvfree(scratch->out_seqs);
+	kvfree(scratch->workspace);
+	kfree(scratch);
+	return ERR_PTR(ret);
+}
+
+static void qat_zstd_free_scratch(void *ctx)
+{
+	struct qat_zstd_scratch *scratch = ctx;
+
+	if (!scratch)
+		return;
+
+	kvfree(scratch->lz4s);
+	kvfree(scratch->literals);
+	kvfree(scratch->out_seqs);
+	kvfree(scratch->workspace);
+	kfree(scratch);
+}
+
+static struct crypto_acomp_streams qat_zstd_streams = {
+	.alloc_ctx = qat_zstd_alloc_scratch,
+	.free_ctx = qat_zstd_free_scratch,
+};
 
 enum direction {
 	DECOMPRESSION = 0,
@@ -24,10 +120,18 @@ enum direction {
 
 struct qat_compression_req;
 
+struct qat_callback_params {
+	unsigned int produced;
+	unsigned int dlen;
+	bool plain;
+};
+
 struct qat_compression_ctx {
 	u8 comp_ctx[QAT_COMP_CTX_SIZE];
 	struct qat_compression_instance *inst;
-	int (*qat_comp_callback)(struct qat_compression_req *qat_req, void *resp);
+	int (*qat_comp_callback)(struct qat_compression_req *qat_req, void *resp,
+				 struct qat_callback_params *params);
+	struct crypto_acomp *ftfm;
 };
 
 struct qat_compression_req {
@@ -62,6 +166,7 @@ static void qat_comp_generic_callback(struct qat_compression_req *qat_req,
 	struct adf_accel_dev *accel_dev = ctx->inst->accel_dev;
 	struct crypto_acomp *tfm = crypto_acomp_reqtfm(areq);
 	struct qat_compression_instance *inst = ctx->inst;
+	struct qat_callback_params params = { };
 	int consumed, produced;
 	s8 cmp_err, xlt_err;
 	int res = -EBADMSG;
@@ -76,6 +181,10 @@ static void qat_comp_generic_callback(struct qat_compression_req *qat_req,
 	consumed = qat_comp_get_consumed_ctr(resp);
 	produced = qat_comp_get_produced_ctr(resp);
 
+	/* Cache parameters for algorithm specific callback */
+	params.produced = produced;
+	params.dlen = areq->dlen;
+
 	dev_dbg(&GET_DEV(accel_dev),
 		"[%s][%s][%s] slen = %8d dlen = %8d consumed = %8d produced = %8d cmp_err = %3d xlt_err = %3d",
 		crypto_tfm_alg_driver_name(crypto_acomp_tfm(tfm)),
@@ -83,16 +192,20 @@ static void qat_comp_generic_callback(struct qat_compression_req *qat_req,
 		status ? "ERR" : "OK ",
 		areq->slen, areq->dlen, consumed, produced, cmp_err, xlt_err);
 
-	areq->dlen = 0;
+	if (unlikely(status != ICP_QAT_FW_COMN_STATUS_FLAG_OK)) {
+		if (cmp_err == ERR_CODE_OVERFLOW_ERROR || xlt_err == ERR_CODE_OVERFLOW_ERROR)
+			res = -E2BIG;
 
-	if (unlikely(status != ICP_QAT_FW_COMN_STATUS_FLAG_OK))
+		areq->dlen = 0;
 		goto end;
+	}
 
 	if (qat_req->dir == COMPRESSION) {
 		cnv = qat_comp_get_cmp_cnv_flag(resp);
 		if (unlikely(!cnv)) {
 			dev_err(&GET_DEV(accel_dev),
 				"Verified compression not supported\n");
+			areq->dlen = 0;
 			goto end;
 		}
 
@@ -102,33 +215,36 @@ static void qat_comp_generic_callback(struct qat_compression_req *qat_req,
 			dev_dbg(&GET_DEV(accel_dev),
 				"Actual buffer overflow: produced=%d, dlen=%d\n",
 				produced, qat_req->actual_dlen);
+
+			res = -E2BIG;
+			areq->dlen = 0;
 			goto end;
 		}
+
+		params.plain = !!qat_comp_get_cmp_uncomp_flag(resp);
 	}
 
 	res = 0;
 	areq->dlen = produced;
 
 	if (ctx->qat_comp_callback)
-		res = ctx->qat_comp_callback(qat_req, resp);
+		res = ctx->qat_comp_callback(qat_req, resp, &params);
 
 end:
 	qat_bl_free_bufl(accel_dev, &qat_req->buf);
 	acomp_request_complete(areq, res);
+	qat_alg_send_backlog(qat_req->alg_req.backlog);
 }
 
 void qat_comp_alg_callback(void *resp)
 {
 	struct qat_compression_req *qat_req =
 			(void *)(__force long)qat_comp_get_opaque(resp);
-	struct qat_instance_backlog *backlog = qat_req->alg_req.backlog;
 
 	qat_comp_generic_callback(qat_req, resp);
-
-	qat_alg_send_backlog(backlog);
 }
 
-static int qat_comp_alg_init_tfm(struct crypto_acomp *acomp_tfm)
+static int qat_comp_alg_init_tfm(struct crypto_acomp *acomp_tfm, int alg)
 {
 	struct qat_compression_ctx *ctx = acomp_tfm_ctx(acomp_tfm);
 	struct crypto_tfm *tfm = crypto_acomp_tfm(acomp_tfm);
@@ -141,12 +257,12 @@ static int qat_comp_alg_init_tfm(struct crypto_acomp *acomp_tfm)
 		node = tfm->node;
 
 	memset(ctx, 0, sizeof(*ctx));
-	inst = qat_compression_get_instance_node(node);
+	inst = qat_compression_get_instance_node(node, alg);
 	if (!inst)
 		return -EINVAL;
 	ctx->inst = inst;
 
-	ret = qat_comp_build_ctx(inst->accel_dev, ctx->comp_ctx, QAT_DEFLATE);
+	ret = qat_comp_build_ctx(inst->accel_dev, ctx->comp_ctx, alg);
 	if (ret) {
 		qat_compression_put_instance(inst);
 		memset(ctx, 0, sizeof(*ctx));
@@ -155,6 +271,11 @@ static int qat_comp_alg_init_tfm(struct crypto_acomp *acomp_tfm)
 	return ret;
 }
 
+static int qat_comp_alg_deflate_init_tfm(struct crypto_acomp *acomp_tfm)
+{
+	return qat_comp_alg_init_tfm(acomp_tfm, QAT_DEFLATE);
+}
+
 static void qat_comp_alg_exit_tfm(struct crypto_acomp *acomp_tfm)
 {
 	struct qat_compression_ctx *ctx = acomp_tfm_ctx(acomp_tfm);
@@ -237,7 +358,234 @@ static int qat_comp_alg_decompress(struct acomp_req *req)
 	return qat_comp_alg_compress_decompress(req, DECOMPRESSION, 0, 0, 0, 0);
 }
 
-static struct acomp_alg qat_acomp[] = { {
+static int qat_comp_alg_zstd_decompress(struct acomp_req *req)
+{
+	struct crypto_acomp *acomp_tfm = crypto_acomp_reqtfm(req);
+	struct qat_compression_ctx *ctx = acomp_tfm_ctx(acomp_tfm);
+	struct acomp_req *nreq = acomp_request_ctx(req);
+	zstd_frame_header header;
+	void *buffer;
+	size_t zret;
+	int ret;
+
+	buffer = kmap_local_page(sg_page(req->src)) + req->src->offset;
+	zret = zstd_get_frame_header(&header, buffer, req->src->length);
+	kunmap_local(buffer);
+	if (zret) {
+		dev_err(&GET_DEV(ctx->inst->accel_dev),
+			"ZSTD-compressed data has an incomplete frame header\n");
+		return -EINVAL;
+	}
+
+	if (header.windowSize > QAT_ZSTD_MAX_BLOCK_SIZE ||
+	    header.frameContentSize >= QAT_ZSTD_MAX_CONTENT_SIZE) {
+		dev_dbg(&GET_DEV(ctx->inst->accel_dev), "Window size=0x%llx\n",
+			header.windowSize);
+
+		memcpy(nreq, req, sizeof(*req));
+		acomp_request_set_tfm(nreq, ctx->ftfm);
+
+		ret = crypto_acomp_decompress(nreq);
+		req->dlen = nreq->dlen;
+
+		return ret;
+	}
+
+	return qat_comp_alg_compress_decompress(req, DECOMPRESSION, 0, 0, 0, 0);
+}
+
+static int qat_comp_lz4s_zstd_callback(struct qat_compression_req *qat_req, void *resp,
+				       struct qat_callback_params *params)
+{
+	struct qat_compression_ctx *qat_ctx = qat_req->qat_compression_ctx;
+	struct acomp_req *areq = qat_req->acompress_req;
+	struct qat_zstd_scratch *scratch;
+	struct crypto_acomp_stream *s;
+	unsigned int lit_len = 0;
+	ZSTD_Sequence *out_seqs;
+	void *lz4s, *zstd;
+	size_t comp_size;
+	ZSTD_CCtx *ctx;
+	void *literals;
+	int seq_count;
+	int ret = 0;
+
+	if (params->produced + QAT_ZSTD_LIT_COPY_LEN > QAT_ZSTD_SCRATCH_SIZE) {
+		dev_dbg(&GET_DEV(qat_ctx->inst->accel_dev),
+			"LZ4s-ZSTD: produced size (%u) + COPY_SIZE > QAT_ZSTD_SCRATCH_SIZE (%u)\n",
+			params->produced, QAT_ZSTD_SCRATCH_SIZE);
+		areq->dlen = 0;
+		return -E2BIG;
+	}
+
+	s = crypto_acomp_lock_stream_bh(&qat_zstd_streams);
+	scratch = s->ctx;
+
+	lz4s = scratch->lz4s;
+	zstd = lz4s;  /* Output buffer is same as lz4s */
+	out_seqs = scratch->out_seqs;
+	ctx = scratch->ctx;
+	literals = scratch->literals;
+
+	if (likely(!params->plain)) {
+		if (likely(sg_nents(areq->dst) == 1)) {
+			zstd = sg_virt(areq->dst);
+			lz4s = zstd;
+		} else {
+			memcpy_from_sglist(lz4s, areq->dst, 0, params->produced);
+		}
+
+		seq_count = qat_alg_dec_lz4s(out_seqs, QAT_MAX_SEQUENCES, lz4s,
+					     params->produced, literals, &lit_len);
+		if (seq_count < 0) {
+			ret = seq_count;
+			comp_size = 0;
+			goto out;
+		}
+	} else {
+		out_seqs[0].litLength = areq->slen;
+		out_seqs[0].offset = 0;
+		out_seqs[0].matchLength = 0;
+
+		seq_count = 1;
+	}
+
+	comp_size = zstd_compress_sequences_and_literals(ctx, zstd, params->dlen,
+							 out_seqs, seq_count,
+							 literals, lit_len,
+							 QAT_ZSTD_SCRATCH_SIZE,
+							 areq->slen);
+	if (zstd_is_error(comp_size)) {
+		if (comp_size == ZSTD_error_cannotProduce_uncompressedBlock)
+			ret = -E2BIG;
+		else
+			ret = -EOPNOTSUPP;
+
+		comp_size = 0;
+		goto out;
+	}
+
+	if (comp_size > params->dlen) {
+		dev_dbg(&GET_DEV(qat_ctx->inst->accel_dev),
+			"LZ4s-ZSTD: compressed_size (%u) > output buffer size (%u)\n",
+			(unsigned int)comp_size, params->dlen);
+		ret = -EOVERFLOW;
+		goto out;
+	}
+
+	if (unlikely(sg_nents(areq->dst) != 1))
+		memcpy_to_sglist(areq->dst, 0, zstd, comp_size);
+
+out:
+	areq->dlen = comp_size;
+	crypto_acomp_unlock_stream_bh(s);
+
+	return ret;
+}
+
+static int qat_comp_alg_lz4s_zstd_init_tfm(struct crypto_acomp *acomp_tfm)
+{
+	struct qat_compression_ctx *ctx = acomp_tfm_ctx(acomp_tfm);
+	struct crypto_tfm *tfm = crypto_acomp_tfm(acomp_tfm);
+	int reqsize;
+	int ret;
+
+	/* qat_comp_alg_init_tfm() wipes out the ctx */
+	ret = qat_comp_alg_init_tfm(acomp_tfm, QAT_LZ4S);
+	if (ret)
+		return ret;
+
+	ctx->ftfm = crypto_alloc_acomp_node("zstd", 0, CRYPTO_ALG_NEED_FALLBACK,
+					    tfm->node);
+	if (IS_ERR(ctx->ftfm)) {
+		qat_comp_alg_exit_tfm(acomp_tfm);
+		return PTR_ERR(ctx->ftfm);
+	}
+
+	reqsize = max(sizeof(struct qat_compression_req),
+		      sizeof(struct acomp_req) + crypto_acomp_reqsize(ctx->ftfm));
+
+	acomp_tfm->reqsize = reqsize;
+
+	ctx->qat_comp_callback = qat_comp_lz4s_zstd_callback;
+
+	return 0;
+}
+
+static int qat_comp_alg_zstd_init_tfm(struct crypto_acomp *acomp_tfm)
+{
+	struct qat_compression_ctx *ctx = acomp_tfm_ctx(acomp_tfm);
+	struct crypto_tfm *tfm = crypto_acomp_tfm(acomp_tfm);
+	int reqsize;
+	int ret;
+
+	/* qat_comp_alg_init_tfm() wipes out the ctx */
+	ret = qat_comp_alg_init_tfm(acomp_tfm, QAT_ZSTD);
+	if (ret)
+		return ret;
+
+	ctx->ftfm = crypto_alloc_acomp_node("zstd", 0, CRYPTO_ALG_NEED_FALLBACK,
+					    tfm->node);
+	if (IS_ERR(ctx->ftfm)) {
+		qat_comp_alg_exit_tfm(acomp_tfm);
+		return PTR_ERR(ctx->ftfm);
+	}
+
+	reqsize = max(sizeof(struct qat_compression_req),
+		      sizeof(struct acomp_req) + crypto_acomp_reqsize(ctx->ftfm));
+
+	acomp_tfm->reqsize = reqsize;
+
+	return 0;
+}
+
+static void qat_comp_alg_zstd_exit_tfm(struct crypto_acomp *acomp_tfm)
+{
+	struct qat_compression_ctx *ctx = acomp_tfm_ctx(acomp_tfm);
+
+	if (ctx->ftfm)
+		crypto_free_acomp(ctx->ftfm);
+
+	qat_comp_alg_exit_tfm(acomp_tfm);
+}
+
+static int qat_comp_alg_lz4s_zstd_compress(struct acomp_req *req)
+{
+	struct crypto_acomp *acomp_tfm = crypto_acomp_reqtfm(req);
+	struct qat_compression_ctx *ctx = acomp_tfm_ctx(acomp_tfm);
+	struct acomp_req *nreq = acomp_request_ctx(req);
+	int ret;
+
+	if (req->slen >= QAT_LZ4S_MIN_INPUT_SIZE && req->dlen >= QAT_LZ4S_MIN_INPUT_SIZE &&
+	    req->slen <= QAT_LZ4S_MAX_OUTPUT_SIZE && req->dlen <= QAT_LZ4S_MAX_OUTPUT_SIZE)
+		return qat_comp_alg_compress(req);
+
+	memcpy(nreq, req, sizeof(*req));
+	acomp_request_set_tfm(nreq, ctx->ftfm);
+
+	ret = crypto_acomp_compress(nreq);
+	req->dlen = nreq->dlen;
+
+	return ret;
+}
+
+static int qat_comp_alg_sw_decompress(struct acomp_req *req)
+{
+	struct crypto_acomp *acomp_tfm = crypto_acomp_reqtfm(req);
+	struct qat_compression_ctx *ctx = acomp_tfm_ctx(acomp_tfm);
+	struct acomp_req *nreq = acomp_request_ctx(req);
+	int ret;
+
+	memcpy(nreq, req, sizeof(*req));
+	acomp_request_set_tfm(nreq, ctx->ftfm);
+
+	ret = crypto_acomp_decompress(nreq);
+	req->dlen = nreq->dlen;
+
+	return ret;
+}
+
+static struct acomp_alg qat_acomp_deflate[] = { {
 	.base = {
 		.cra_name = "deflate",
 		.cra_driver_name = "qat_deflate",
@@ -247,27 +595,165 @@ static struct acomp_alg qat_acomp[] = { {
 		.cra_reqsize = sizeof(struct qat_compression_req),
 		.cra_module = THIS_MODULE,
 	},
-	.init = qat_comp_alg_init_tfm,
+	.init = qat_comp_alg_deflate_init_tfm,
 	.exit = qat_comp_alg_exit_tfm,
 	.compress = qat_comp_alg_compress,
 	.decompress = qat_comp_alg_decompress,
 }};
 
-int qat_comp_algs_register(void)
+static struct acomp_alg qat_acomp_zstd_lz4s = {
+	.base = {
+		.cra_name = "zstd",
+		.cra_driver_name = "qat_zstd",
+		.cra_priority = 4001,
+		.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY |
+			     CRYPTO_ALG_NEED_FALLBACK,
+		.cra_reqsize = sizeof(struct qat_compression_req),
+		.cra_ctxsize = sizeof(struct qat_compression_ctx),
+		.cra_module = THIS_MODULE,
+	},
+	.init = qat_comp_alg_lz4s_zstd_init_tfm,
+	.exit = qat_comp_alg_zstd_exit_tfm,
+	.compress = qat_comp_alg_lz4s_zstd_compress,
+	.decompress = qat_comp_alg_sw_decompress,
+};
+
+static struct acomp_alg qat_acomp_zstd_native = {
+	.base = {
+		.cra_name = "zstd",
+		.cra_driver_name = "qat_zstd",
+		.cra_priority = 4001,
+		.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY |
+			     CRYPTO_ALG_NEED_FALLBACK,
+		.cra_reqsize = sizeof(struct qat_compression_req),
+		.cra_ctxsize = sizeof(struct qat_compression_ctx),
+		.cra_module = THIS_MODULE,
+	},
+	.init = qat_comp_alg_zstd_init_tfm,
+	.exit = qat_comp_alg_zstd_exit_tfm,
+	.compress = qat_comp_alg_compress,
+	.decompress = qat_comp_alg_zstd_decompress,
+};
+
+static int qat_comp_algs_register_deflate(void)
 {
 	int ret = 0;
 
 	mutex_lock(&algs_lock);
-	if (++active_devs == 1)
-		ret = crypto_register_acomps(qat_acomp, ARRAY_SIZE(qat_acomp));
+	if (++active_devs_deflate == 1) {
+		ret = crypto_register_acomps(qat_acomp_deflate,
+					     ARRAY_SIZE(qat_acomp_deflate));
+		if (ret)
+			active_devs_deflate--;
+	}
 	mutex_unlock(&algs_lock);
+
 	return ret;
 }
 
-void qat_comp_algs_unregister(void)
+static void qat_comp_algs_unregister_deflate(void)
 {
 	mutex_lock(&algs_lock);
-	if (--active_devs == 0)
-		crypto_unregister_acomps(qat_acomp, ARRAY_SIZE(qat_acomp));
+	if (--active_devs_deflate == 0)
+		crypto_unregister_acomps(qat_acomp_deflate, ARRAY_SIZE(qat_acomp_deflate));
 	mutex_unlock(&algs_lock);
 }
+
+static int qat_comp_algs_register_lz4s(void)
+{
+	int ret = 0;
+
+	mutex_lock(&algs_lock);
+	if (++active_devs_lz4s == 1) {
+		ret = crypto_acomp_alloc_streams(&qat_zstd_streams);
+		if (ret) {
+			active_devs_lz4s--;
+			goto unlock;
+		}
+
+		ret = crypto_register_acomp(&qat_acomp_zstd_lz4s);
+		if (ret) {
+			crypto_acomp_free_streams(&qat_zstd_streams);
+			active_devs_lz4s--;
+		}
+	}
+unlock:
+	mutex_unlock(&algs_lock);
+
+	return ret;
+}
+
+static void qat_comp_algs_unregister_lz4s(void)
+{
+	mutex_lock(&algs_lock);
+	if (--active_devs_lz4s == 0) {
+		crypto_unregister_acomp(&qat_acomp_zstd_lz4s);
+		crypto_acomp_free_streams(&qat_zstd_streams);
+	}
+	mutex_unlock(&algs_lock);
+}
+
+static int qat_comp_algs_register_zstd(void)
+{
+	int ret = 0;
+
+	mutex_lock(&algs_lock);
+	if (++active_devs_zstd == 1) {
+		ret = crypto_register_acomp(&qat_acomp_zstd_native);
+		if (ret)
+			active_devs_zstd--;
+	}
+	mutex_unlock(&algs_lock);
+
+	return ret;
+}
+
+static void qat_comp_algs_unregister_zstd(void)
+{
+	mutex_lock(&algs_lock);
+	if (--active_devs_zstd == 0)
+		crypto_unregister_acomp(&qat_acomp_zstd_native);
+	mutex_unlock(&algs_lock);
+}
+
+int qat_comp_algs_register(u32 caps)
+{
+	int ret;
+
+	ret = qat_comp_algs_register_deflate();
+	if (ret)
+		return ret;
+
+	if (caps & ADF_ACCEL_CAPABILITIES_EXT_ZSTD_LZ4S) {
+		ret = qat_comp_algs_register_lz4s();
+		if (ret)
+			goto err_unregister_deflate;
+	}
+
+	if (caps & ADF_ACCEL_CAPABILITIES_EXT_ZSTD) {
+		ret = qat_comp_algs_register_zstd();
+		if (ret)
+			goto err_unregister_lz4s;
+	}
+
+	return ret;
+
+err_unregister_lz4s:
+	if (caps & ADF_ACCEL_CAPABILITIES_EXT_ZSTD_LZ4S)
+		qat_comp_algs_unregister_lz4s();
+err_unregister_deflate:
+	qat_comp_algs_unregister_deflate();
+
+	return ret;
+}
+
+void qat_comp_algs_unregister(u32 caps)
+{
+	qat_comp_algs_unregister_deflate();
+
+	if (caps & ADF_ACCEL_CAPABILITIES_EXT_ZSTD_LZ4S)
+		qat_comp_algs_unregister_lz4s();
+
+	if (caps & ADF_ACCEL_CAPABILITIES_EXT_ZSTD)
+		qat_comp_algs_unregister_zstd();
+}
diff --git a/drivers/crypto/intel/qat/qat_common/qat_comp_req.h b/drivers/crypto/intel/qat/qat_common/qat_comp_req.h
index 18a1f33a6db9..f165d28aaaf4 100644
--- a/drivers/crypto/intel/qat/qat_common/qat_comp_req.h
+++ b/drivers/crypto/intel/qat/qat_common/qat_comp_req.h
@@ -23,6 +23,7 @@ static inline void qat_comp_create_req(void *ctx, void *req, u64 src, u32 slen,
 	fw_req->comn_mid.opaque_data = opaque;
 	req_pars->comp_len = slen;
 	req_pars->out_buffer_sz = dlen;
+	fw_req->u3.asb_threshold.asb_value *= slen >> 4;
 }
 
 static inline void qat_comp_create_compression_req(void *ctx, void *req,
@@ -110,4 +111,12 @@ static inline u8 qat_comp_get_cmp_cnv_flag(void *resp)
 	return ICP_QAT_FW_COMN_HDR_CNV_FLAG_GET(flags);
 }
 
+static inline u8 qat_comp_get_cmp_uncomp_flag(void *resp)
+{
+	struct icp_qat_fw_comp_resp *qat_resp = resp;
+	u8 flags = qat_resp->comn_resp.hdr_flags;
+
+	return ICP_QAT_FW_COMN_HDR_ST_BLK_FLAG_GET(flags);
+}
+
 #endif
diff --git a/drivers/crypto/intel/qat/qat_common/qat_comp_zstd_utils.c b/drivers/crypto/intel/qat/qat_common/qat_comp_zstd_utils.c
new file mode 100644
index 000000000000..62ec2d5c3ab8
--- /dev/null
+++ b/drivers/crypto/intel/qat/qat_common/qat_comp_zstd_utils.c
@@ -0,0 +1,165 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright(c) 2026 Intel Corporation */
+#include <linux/errno.h>
+#include <linux/printk.h>
+#include <linux/string.h>
+#include <linux/unaligned.h>
+#include <linux/zstd.h>
+
+#include "qat_comp_zstd_utils.h"
+
+#define ML_BITS		4
+#define ML_MASK		((1U << ML_BITS) - 1)
+#define RUN_BITS	(8 - ML_BITS)
+#define RUN_MASK	((1U << RUN_BITS) - 1)
+#define LZ4S_MINMATCH	2
+
+/*
+ * ZSTD blocks can decompress to at most min(windowSize, 128KB) bytes.
+ * Insert explicit block delimiters to keep blocks within this limit.
+ */
+#define QAT_ZSTD_BLOCK_MAX	ZSTD_BLOCKSIZE_MAX
+
+static int emit_delimiter(ZSTD_Sequence *out_seqs, size_t *seqs_idx,
+			  size_t out_seqs_capacity, unsigned int lz4s_buff_size)
+{
+	if (*seqs_idx >= out_seqs_capacity - 1) {
+		pr_debug("QAT ZSTD: sequence overflow (seqs_idx:%zu, capacity:%zu, lz4s_size:%u)\n",
+			 *seqs_idx, out_seqs_capacity, lz4s_buff_size);
+		return -EOVERFLOW;
+	}
+
+	out_seqs[*seqs_idx].offset = 0;
+	out_seqs[*seqs_idx].litLength = 0;
+	out_seqs[*seqs_idx].matchLength = 0;
+	(*seqs_idx)++;
+
+	return 0;
+}
+
+int qat_alg_dec_lz4s(ZSTD_Sequence *out_seqs, size_t out_seqs_capacity,
+		     unsigned char *lz4s_buff, unsigned int lz4s_buff_size,
+		     unsigned char *literals, unsigned int *lit_len)
+{
+	unsigned char *end_ip = lz4s_buff + lz4s_buff_size;
+	unsigned char *start, *dest, *dest_end;
+	unsigned int hist_literal_len = 0;
+	unsigned char *ip = lz4s_buff;
+	size_t block_decomp_size = 0;
+	size_t seqs_idx = 0;
+	int ret;
+
+	*lit_len = 0;
+
+	if (!lz4s_buff_size)
+		return 0;
+
+	while (ip < end_ip) {
+		size_t literal_len = 0, match_len = 0;
+		const unsigned int token = *ip++;
+		size_t length = 0;
+		size_t offset = 0;
+
+		/* Get literal length */
+		length = token >> ML_BITS;
+		if (length == RUN_MASK) {
+			unsigned int s;
+
+			do {
+				s = *ip++;
+				length += s;
+			} while (s == 255);
+		}
+
+		literal_len = length;
+
+		start = ip;
+		dest = literals;
+		dest_end = literals + length;
+
+		do {
+			memcpy(dest, start, QAT_ZSTD_LIT_COPY_LEN);
+			dest += QAT_ZSTD_LIT_COPY_LEN;
+			start += QAT_ZSTD_LIT_COPY_LEN;
+		} while (dest < dest_end);
+
+		literals += length;
+		*lit_len += length;
+
+		ip += length;
+		if (ip == end_ip) {
+			literal_len += hist_literal_len;
+			/*
+			 * If adding trailing literals would overflow the
+			 * current block, close it first.
+			 */
+			if (block_decomp_size + literal_len > QAT_ZSTD_BLOCK_MAX) {
+				ret = emit_delimiter(out_seqs, &seqs_idx,
+						     out_seqs_capacity,
+						     lz4s_buff_size);
+				if (ret)
+					return ret;
+			}
+			out_seqs[seqs_idx].litLength = literal_len;
+			out_seqs[seqs_idx].offset = offset;
+			out_seqs[seqs_idx].matchLength = match_len;
+			break;
+		}
+
+		offset = get_unaligned_le16(ip);
+		ip += 2;
+
+		length = token & ML_MASK;
+		if (length == ML_MASK) {
+			unsigned int s;
+
+			do {
+				s = *ip++;
+				length += s;
+			} while (s == 255);
+		}
+		if (length != 0) {
+			length += LZ4S_MINMATCH;
+			match_len = (unsigned short)length;
+			literal_len += hist_literal_len;
+
+			/*
+			 * If this sequence would push the current block past
+			 * the ZSTD maximum, close the block first.
+			 */
+			if (block_decomp_size + literal_len + match_len > QAT_ZSTD_BLOCK_MAX) {
+				ret = emit_delimiter(out_seqs, &seqs_idx,
+						     out_seqs_capacity,
+						     lz4s_buff_size);
+				if (ret)
+					return ret;
+
+				block_decomp_size = 0;
+			}
+
+			out_seqs[seqs_idx].offset = offset;
+			out_seqs[seqs_idx].litLength = literal_len;
+			out_seqs[seqs_idx].matchLength = match_len;
+			hist_literal_len = 0;
+			seqs_idx++;
+			if (seqs_idx >= out_seqs_capacity - 1) {
+				pr_debug("QAT ZSTD: sequence overflow (seqs_idx:%zu, capacity:%zu, lz4s_size:%u)\n",
+					 seqs_idx, out_seqs_capacity, lz4s_buff_size);
+				return -EOVERFLOW;
+			}
+
+			block_decomp_size += literal_len + match_len;
+		} else {
+			if (literal_len > 0) {
+				/*
+				 * When match length is 0, the literal length needs
+				 * to be temporarily stored and processed together
+				 * with the next data block.
+				 */
+				hist_literal_len += literal_len;
+			}
+		}
+	}
+
+	return seqs_idx + 1;
+}
diff --git a/drivers/crypto/intel/qat/qat_common/qat_comp_zstd_utils.h b/drivers/crypto/intel/qat/qat_common/qat_comp_zstd_utils.h
new file mode 100644
index 000000000000..55c7a1b9b848
--- /dev/null
+++ b/drivers/crypto/intel/qat/qat_common/qat_comp_zstd_utils.h
@@ -0,0 +1,13 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/* Copyright(c) 2026 Intel Corporation */
+#ifndef QAT_COMP_ZSTD_UTILS_H_
+#define QAT_COMP_ZSTD_UTILS_H_
+#include <linux/zstd_lib.h>
+
+#define QAT_ZSTD_LIT_COPY_LEN	8
+
+int qat_alg_dec_lz4s(ZSTD_Sequence *out_seqs, size_t out_seqs_capacity,
+		     unsigned char *lz4s_buff, unsigned int lz4s_buff_size,
+		     unsigned char *literals, unsigned int *lit_len);
+
+#endif
diff --git a/drivers/crypto/intel/qat/qat_common/qat_compression.c b/drivers/crypto/intel/qat/qat_common/qat_compression.c
index 53a4db5507ec..1424d7a9bcd3 100644
--- a/drivers/crypto/intel/qat/qat_common/qat_compression.c
+++ b/drivers/crypto/intel/qat/qat_common/qat_compression.c
@@ -46,12 +46,14 @@ static int qat_compression_free_instances(struct adf_accel_dev *accel_dev)
 	return 0;
 }
 
-struct qat_compression_instance *qat_compression_get_instance_node(int node)
+struct qat_compression_instance *qat_compression_get_instance_node(int node, int alg)
 {
 	struct qat_compression_instance *inst = NULL;
+	struct adf_hw_device_data *hw_data = NULL;
 	struct adf_accel_dev *accel_dev = NULL;
 	unsigned long best = ~0;
 	struct list_head *itr;
+	u32 caps, mask;
 
 	list_for_each(itr, adf_devmgr_get_head()) {
 		struct adf_accel_dev *tmp_dev;
@@ -61,6 +63,15 @@ struct qat_compression_instance *qat_compression_get_instance_node(int node)
 		tmp_dev = list_entry(itr, struct adf_accel_dev, list);
 		tmp_dev_node = dev_to_node(&GET_DEV(tmp_dev));
 
+		if (alg == QAT_ZSTD || alg == QAT_LZ4S) {
+			hw_data = tmp_dev->hw_device;
+			caps = hw_data->accel_capabilities_ext_mask;
+			mask = ADF_ACCEL_CAPABILITIES_EXT_ZSTD |
+			       ADF_ACCEL_CAPABILITIES_EXT_ZSTD_LZ4S;
+			if (!(caps & mask))
+				continue;
+		}
+
 		if ((node == tmp_dev_node || tmp_dev_node < 0) &&
 		    adf_dev_started(tmp_dev) && !list_empty(&tmp_dev->compression_list)) {
 			ctr = atomic_read(&tmp_dev->ref_count);
@@ -78,6 +89,16 @@ struct qat_compression_instance *qat_compression_get_instance_node(int node)
 			struct adf_accel_dev *tmp_dev;
 
 			tmp_dev = list_entry(itr, struct adf_accel_dev, list);
+
+			if (alg == QAT_ZSTD || alg == QAT_LZ4S) {
+				hw_data = tmp_dev->hw_device;
+				caps = hw_data->accel_capabilities_ext_mask;
+				mask = ADF_ACCEL_CAPABILITIES_EXT_ZSTD |
+				       ADF_ACCEL_CAPABILITIES_EXT_ZSTD_LZ4S;
+				if (!(caps & mask))
+					continue;
+			}
+
 			if (adf_dev_started(tmp_dev) &&
 			    !list_empty(&tmp_dev->compression_list)) {
 				accel_dev = tmp_dev;

base-commit: 93e03a16c015b8e55e2ec97865f67d9bf1ec1921
-- 
2.53.0

