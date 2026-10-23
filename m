Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792766921;
	b=G6YBWKpqdcRa9FqHTrHWbNXynNmh4Qc6saXUa3PNtw9Yw0oIx6cMzYankF7//DB5TrUN
	 7/afIeEh6V21iwNvJBP8pmoWVHHk/AdOlCoNJr/DO9H/ijq4sJCsO/hx7cIgH8vIzxaIV
	 s6S36tu7G7rWD/idYX7fwPOX7ZptdSKfPqc5BiEcdp3dqZE6nLIIEu0iqVnIvIX6/krjP
	 bMCoNDg35YSRRN4Emocye1itNOZuFD5X4jk9/FGW99Ht1XE3w9gdqmCFInK9uEyMEnGho
	 NRwx7zONDOURalINfx/h+L0KhWSpcvz9hGR1zIU3B7yPRlcEWZPcjjbnOCImrQwTwPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792766921;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Organization:Content-Transfer-Encoding;
	bh=YKJOtyrgf4hZp4616LOWGQscZhC96pEJuai40d/YdHI=;
	b=Myiwkutonm5J2G3z1HK9agrzKi+mu6yhTq3KLmzF0KbCdZxs3eE8irWRMYnlcq3t+2P9
	 uOUR8EZJs9ru4sMcaM/5k1AwJbKIdalvuBCvet0ZGpKuGzzA5K7AaRbt2VMpZIQs7aV/K
	 oVfVxBcPF3+Q++dN6jtbgpR7WoQi2Cw8omOAKmLKF+3AIrXhYTRLhqqE2h4PbJYlLUb/s
	 CVcajBT0cp5FqituqaHukKCEKc89e0gOu6b9UY5iW6ilxkQ4qhvigsbNr1lm1+uOTgOAh
	 F+kbxqneisfxfDfafUzZxmTHBSfG2XKceXQxtVvENSpucgLpMTJVHRMjTTAEJtqFkoQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=bOgPBdRt;
	arc=none smtp.remote-ip=192.198.163.16
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7B02606A320
	for <linux-crypto@vger.kernel.org>; Fri, 23 Oct 2026 14:48:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D7B02606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=bOgPBdRt
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792766920; x=1824302920;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=z+6Eh2m+0OYdTyHSR6yhRE+pDlkuCQG6QhqLvrKFHVw=;
  b=bOgPBdRtTXA4G9nZ8KDm6LDenHZ4yqJJYta+ykPWshDnkrlx8rCUaNZx
   P64p4dW4SgviCweBrT9X0Cz4IuNdKXGuHhLVYdyoz2XgQQaqWF/UjCujM
   FnfZSzsoA8dtw+Oy8r4/w/LjZ/EatnR8B5cUmtw7fBPlj5eJ4UjlOWyeZ
   Bc3NONH54QDFtni4P9/xL8Nh0yXeRicmrPskatYq8k/Y51kiKFEJBVPBL
   AGezYgPs+MSYUE7i8vfiO+orKmNkGso4M/eg09sNmyYus3s920UWJBuVT
   arQ7byQOkuT2lInFF64tPV0mt4yzb498dOizyTZkgOGo1oEhQMZv2OH3G
   A==;
X-CSE-ConnectionGUID: pnXDaknmSAuNOzj+r4Jhrg==
X-CSE-MsgGUID: WBacxkaISreoRH45j0SmRA==
X-IronPort-AV: E=McAfee;i="6800,10657,11944"; a="1534175"
X-IronPort-AV: E=Sophos;i="6.27,174,1787036400"; 
   d="scan'208";a="1534175"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2026 07:48:40 -0700
X-CSE-ConnectionGUID: dh3ZVKXTR22QcSgYtnqgNw==
X-CSE-MsgGUID: IFdd8WOHQg2FaB8foopjqQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,174,1787036400"; 
   d="scan'208";a="3598349"
Received: from silpixa00401812.ir.intel.com ([10.20.226.90])
  by orviesa005.jf.intel.com with ESMTP; 23 Oct 2026 07:48:38 -0700
From: Ahsan Atta <ahsan.atta@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	Bairavi Alagappan <bairavix.alagappan@intel.com>,
	Ahsan Atta <ahsan.atta@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH RESEND 1/2] crypto: qat - enable three-service mode for QAT GEN5 devices
Date: Fri, 23 Oct 2026 15:48:34 +0100
Message-ID: <20261023144835.170453-2-ahsan.atta@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20261023144835.170453-1-ahsan.atta@intel.com>
References: <20261023144835.170453-1-ahsan.atta@intel.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit

From: Bairavi Alagappan <bairavix.alagappan@intel.com>

QAT GEN5 devices have enough accelerator engines to support three
concurrent services. However, the qat_420xx module does not currently
allow configuring symmetric crypto, asymmetric crypto, and compression
services together.

Add support for enabling these three services concurrently on QAT GEN5
devices.

Define the corresponding firmware object layout, ring-to-service
mapping, thread-to-arbiter mapping, and service-to-accelerator-engine
accounting required for three-service mode.

Signed-off-by: Bairavi Alagappan <bairavix.alagappan@intel.com>
Signed-off-by: Ahsan Atta <ahsan.atta@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 .../intel/qat/qat_420xx/adf_420xx_hw_data.c   | 104 +++++++++++++++++-
 .../intel/qat/qat_420xx/adf_420xx_hw_data.h   |   6 +
 .../intel/qat/qat_common/adf_cfg_services.c   |   3 +
 .../intel/qat/qat_common/adf_cfg_services.h   |   1 +
 4 files changed, 111 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c b/drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c
index d6f1f626cf5a..3f994ae6fd89 100644
--- a/drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c
@@ -89,6 +89,14 @@ static const struct adf_fw_config adf_fw_dcc_config[] = {
 	{ADF_AE_GROUP_4, ADF_FW_ADMIN_OBJ},
 };
 
+static const struct adf_fw_config adf_fw_asym_sym_dc_config[] = {
+	{ADF_AE_GROUP_3, ADF_FW_DC_OBJ},
+	{ADF_AE_GROUP_2, ADF_FW_DC_OBJ},
+	{ADF_AE_GROUP_1, ADF_FW_SYM_OBJ},
+	{ADF_AE_GROUP_0, ADF_FW_ASYM_OBJ},
+	{ADF_AE_GROUP_4, ADF_FW_ADMIN_OBJ},
+};
+
 
 static struct adf_hw_device_class adf_420xx_class = {
 	.name = ADF_420XX_DEVICE_NAME,
@@ -135,6 +143,8 @@ static u32 uof_get_num_objs(struct adf_accel_dev *accel_dev)
 		return ARRAY_SIZE(adf_fw_asym_dc_config);
 	case SVC_SYM_DC:
 		return ARRAY_SIZE(adf_fw_sym_dc_config);
+	case SVC_SYM_ASYM_DC:
+		return ARRAY_SIZE(adf_fw_asym_sym_dc_config);
 	default:
 		return 0;
 	}
@@ -157,6 +167,8 @@ static const struct adf_fw_config *get_fw_config(struct adf_accel_dev *accel_dev
 		return adf_fw_asym_dc_config;
 	case SVC_SYM_DC:
 		return adf_fw_sym_dc_config;
+	case SVC_SYM_ASYM_DC:
+		return adf_fw_asym_sym_dc_config;
 	default:
 		return NULL;
 	}
@@ -288,13 +300,26 @@ static u32 get_accel_cap(struct adf_accel_dev *accel_dev)
 		return capabilities_asym | capabilities_dc;
 	case SVC_SYM_DC:
 		return capabilities_sym | capabilities_dc;
+	case SVC_SYM_ASYM_DC:
+		return capabilities_sym | capabilities_asym | capabilities_dc;
 	default:
 		return 0;
 	}
 }
 
+static const u32 thrd_to_arb_map_asym_sym_dc[ADF_420XX_MAX_ACCELENGINES] = {
+	0x00000011, 0x00000011, 0x00000011, 0x00000011,
+	0x00002222, 0x00002222, 0x00002222, 0x00002222,
+	0x000000cc, 0x000000cc, 0x000000cc, 0x000000cc,
+	0x000000cc, 0x000000cc, 0x000000cc, 0x000000cc,
+	0x0
+};
+
 static const u32 *adf_get_arbiter_mapping(struct adf_accel_dev *accel_dev)
 {
+	if (adf_get_service_enabled(accel_dev) == SVC_SYM_ASYM_DC)
+		return thrd_to_arb_map_asym_sym_dc;
+
 	if (adf_gen4_init_thd2arb_map(accel_dev))
 		dev_warn(&GET_DEV(accel_dev),
 			 "Failed to generate thread to arbiter mapping");
@@ -425,6 +450,79 @@ static void adf_gen4_set_err_mask(struct adf_dev_err_mask *dev_err_mask)
 	dev_err_mask->ssmfeatren_mask = ADF_420XX_SSMFEATREN_MASK;
 }
 
+static u16 adf_420xx_get_ring_to_svc_map(struct adf_accel_dev *accel_dev)
+{
+	if (adf_get_service_enabled(accel_dev) == SVC_SYM_ASYM_DC)
+		return ADF_GEN4_SYM_ASYM_DC_RING_TO_SRV_MAP;
+
+	return adf_gen4_get_ring_to_svc_map(accel_dev);
+}
+
+static bool adf_420xx_services_supported(unsigned long mask)
+{
+	int num_svc;
+
+	if (mask >= BIT(SVC_COUNT))
+		return false;
+
+	if (test_bit(SVC_DECOMP, &mask))
+		return false;
+
+	num_svc = hweight_long(mask);
+	switch (num_svc) {
+	case ADF_ONE_SERVICE:
+		return true;
+	case ADF_TWO_SERVICES:
+	case ADF_THREE_SERVICES:
+		return !test_bit(SVC_DCC, &mask);
+	default:
+		return false;
+	}
+}
+
+static void adf_update_rl_data(struct adf_rl_hw_data *rl_data)
+{
+	unsigned int num_groups;
+	unsigned int i;
+
+	num_groups = ARRAY_SIZE(adf_fw_asym_sym_dc_config) - ADF_GEN4_ADMIN_ACCELENGINES;
+
+	memset(rl_data->svc_ae_mask, 0, sizeof(rl_data->svc_ae_mask));
+
+	for (i = 0; i < num_groups; i++) {
+		switch (adf_fw_asym_sym_dc_config[i].obj) {
+		case ADF_FW_ASYM_OBJ:
+			rl_data->svc_ae_mask[SVC_ASYM] +=
+				hweight32(adf_fw_asym_sym_dc_config[i].ae_mask);
+			break;
+		case ADF_FW_SYM_OBJ:
+			rl_data->svc_ae_mask[SVC_SYM] +=
+				hweight32(adf_fw_asym_sym_dc_config[i].ae_mask);
+			break;
+		case ADF_FW_DC_OBJ:
+			rl_data->svc_ae_mask[SVC_DC] +=
+				hweight32(adf_fw_asym_sym_dc_config[i].ae_mask);
+			break;
+		default:
+			break;
+		}
+	}
+}
+
+static int adf_420xx_dev_config(struct adf_accel_dev *accel_dev)
+{
+	int ret;
+
+	ret = adf_gen4_dev_config(accel_dev);
+	if (ret)
+		return ret;
+
+	if (adf_get_service_enabled(accel_dev) == SVC_SYM_ASYM_DC)
+		adf_update_rl_data(&GET_HW_DATA(accel_dev)->rl_data);
+
+	return 0;
+}
+
 void adf_init_hw_data_420xx(struct adf_hw_device_data *hw_data, u32 dev_id)
 {
 	hw_data->dev_class = &adf_420xx_class;
@@ -472,20 +570,20 @@ void adf_init_hw_data_420xx(struct adf_hw_device_data *hw_data, u32 dev_id)
 	hw_data->get_ena_thd_mask = get_ena_thd_mask;
 	hw_data->set_msix_rttable = adf_gen4_set_msix_default_rttable;
 	hw_data->set_ssm_wdtimer = adf_gen4_set_ssm_wdtimer;
-	hw_data->get_ring_to_svc_map = adf_gen4_get_ring_to_svc_map;
+	hw_data->get_ring_to_svc_map = adf_420xx_get_ring_to_svc_map;
 	hw_data->disable_iov = adf_disable_sriov;
 	hw_data->ring_pair_reset = adf_gen4_ring_pair_reset;
 	hw_data->bank_state_save = adf_bank_state_save;
 	hw_data->bank_state_restore = adf_bank_state_restore;
 	hw_data->enable_pm = adf_gen4_enable_pm;
 	hw_data->handle_pm_interrupt = adf_gen4_handle_pm_interrupt;
-	hw_data->dev_config = adf_gen4_dev_config;
+	hw_data->dev_config = adf_420xx_dev_config;
 	hw_data->start_timer = adf_timer_start;
 	hw_data->stop_timer = adf_timer_stop;
 	hw_data->get_hb_clock = adf_gen4_get_heartbeat_clock;
 	hw_data->num_hb_ctrs = ADF_NUM_HB_CNT_PER_AE;
 	hw_data->clock_frequency = ADF_420XX_AE_FREQ;
-	hw_data->services_supported = adf_gen4_services_supported;
+	hw_data->services_supported = adf_420xx_services_supported;
 	hw_data->get_svc_slice_cnt = adf_gen4_get_svc_slice_cnt;
 	hw_data->accel_capabilities_ext_mask = ADF_ACCEL_CAPABILITIES_EXT_ZSTD_LZ4S;
 
diff --git a/drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.h b/drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.h
index 99abbfc14820..870222bf855e 100644
--- a/drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.h
+++ b/drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.h
@@ -17,6 +17,12 @@
 #define ADF_420XX_PARITYERRORMASK_PKE_MASK	(0xFFF)
 #define ADF_420XX_PARITYERRORMASK_WAT_WCP_MASK	(0x3FF03FF)
 
+#define ADF_GEN4_SYM_ASYM_DC_RING_TO_SRV_MAP \
+	(ASYM << ADF_CFG_SERV_RING_PAIR_0_SHIFT | \
+	  SYM << ADF_CFG_SERV_RING_PAIR_1_SHIFT | \
+	 COMP << ADF_CFG_SERV_RING_PAIR_2_SHIFT | \
+	 COMP << ADF_CFG_SERV_RING_PAIR_3_SHIFT)
+
 /*
  * SSMFEATREN bit mask
  * BIT(4) - enables parity detection on CPP
diff --git a/drivers/crypto/intel/qat/qat_common/adf_cfg_services.c b/drivers/crypto/intel/qat/qat_common/adf_cfg_services.c
index f7237c7ef2b1..ef245c2e80c1 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_cfg_services.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_cfg_services.c
@@ -148,6 +148,9 @@ int adf_get_service_enabled(struct adf_accel_dev *accel_dev)
 	if (ret)
 		return ret;
 
+	if (test_bit(SVC_SYM, &mask) && test_bit(SVC_ASYM, &mask) && test_bit(SVC_DC, &mask))
+		return SVC_SYM_ASYM_DC;
+
 	if (test_bit(SVC_SYM, &mask) && test_bit(SVC_ASYM, &mask))
 		return SVC_SYM_ASYM;
 
diff --git a/drivers/crypto/intel/qat/qat_common/adf_cfg_services.h b/drivers/crypto/intel/qat/qat_common/adf_cfg_services.h
index 89be2f2c7233..d8b45645d2a9 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_cfg_services.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_cfg_services.h
@@ -24,6 +24,7 @@ enum adf_composed_services {
 	SVC_SYM_ASYM = SVC_COUNT,
 	SVC_SYM_DC,
 	SVC_ASYM_DC,
+	SVC_SYM_ASYM_DC,
 };
 
 enum {
-- 
2.50.1

