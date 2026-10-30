Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.14
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793370627;
	b=lmstAqkZSw6RUDi4Yt0du2Pmuv9Dn92hR9/HxR0yh6xvmd0NoSeo6EV9fUCHR26J5YOi
	 S0oLZ0M5yVAnoOFVjL7qbahqTNVIIX1/Et4on8PNxBzAqiRdePg47CkXKy/13mlslTGXr
	 5gmBdEyeEIiqBkhaPj9bVItHGZhGUBQCSm61CuOrzNsgALivGh+zD2j4c4D0ttc1aPdz7
	 cy+4dIUy8OfE6imG/3XOb9iYE6+xqyZE7KDGwSyWQJg3D42RTRg/7+NsbZAZVLF2qcijg
	 fQcwCiY1N6RfgJJSQb1CS3yosJnG0nLL7soneuHH95gEsktf7/LL/h0FkRMXH1ilE5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793370627;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Organization:Content-Transfer-Encoding;
	bh=XqXxmQ7vWS4WP8Ipija+7vKJtNS7T0e+wQ5bsCsvYC0=;
	b=S03/tExaHPYm7NFdQjQjXUHHfHPgRRN/OcHUqEozKX/TbnbSyFKkpirR4WgqMqMZIsSs
	 4b4nY+0oxMYcYfewL5jXKJ13rpKtRHOkb8cNbieI34smzFBuros9epE5ISUcC/OweUIL8
	 DdlTyQOfBAMYz2Dtl8TgkoR7v4FHLcxIz7/msk+uCbtpgyeb5JFG+9YSq4BYCLYxwBnvV
	 /NL+r34dvwfBXLdZffMkYlWp4tTKJOD4CxORxK07qHdlMKN5VZph0iyFafdyuP/QcWAEi
	 bNnqp2uVJJn/pBMxmXcCIfuuw5eOpQPsu0mQig2qm7vma1twB88RzQdhStZwQI9txig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=IkNNTKMR;
	arc=none smtp.remote-ip=192.198.163.14
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BECF606A321
	for <linux-crypto@vger.kernel.org>; Fri, 30 Oct 2026 14:30:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4BECF606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=IkNNTKMR
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793370625; x=1824906625;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YhxIs2NaUHneCyBaZkvWnRRLtpguSCHx+Xayxscw0Qw=;
  b=IkNNTKMR2FFzfv3uPiIo0zBBRqgQlk/6Iv+PA4KYn2eZS+HgVTyAIocZ
   8YPaFnAyercTm9m83vQ+zOf32i9BGerp4RS0isrR1oR9aRd3XSD3+DOqy
   iJ2WaXWWaIn//AsfPC/KiiYRkeTnzt/wSU8nE/1kUmCWBMJbU/JOY9RG0
   APF5K6YRKs8p2aAcqNyLsN/5BfujhheONdJT/633InEMop/rH0njGB3uC
   SGsh7fgtyu599QsWERmnqn/zdzgcGAV9j1UA8l9m2I42cvf8Cx3ftm7Ga
   aCojLcrUVoBvY7CNT0qHQBXR16TzYwSezW4azh47gCxQQ489lIWMil3Bl
   Q==;
X-CSE-ConnectionGUID: J2Su5tg6RSGh/ehVabbKog==
X-CSE-MsgGUID: deTnMdTmSci1utL+c6fWLA==
X-IronPort-AV: E=McAfee;i="6800,10657,11951"; a="2167045"
X-IronPort-AV: E=Sophos;i="6.27,186,1787036400"; 
   d="scan'208";a="2167045"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2026 07:30:25 -0700
X-CSE-ConnectionGUID: aSTvvV9GT1W9yhGduZ8O0g==
X-CSE-MsgGUID: nRLaWEL/Qk+zgsIBw5dmbg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,186,1787036400"; 
   d="scan'208";a="5417515"
Received: from silpixa00401812.ir.intel.com ([10.20.226.90])
  by orviesa001.jf.intel.com with ESMTP; 30 Oct 2026 07:30:23 -0700
From: Ahsan Atta <ahsan.atta@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	Bairavi Alagappan <bairavix.alagappan@intel.com>,
	Ahsan Atta <ahsan.atta@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH v2 1/2] crypto: qat - enable three-service mode for QAT GEN5 devices
Date: Fri, 30 Oct 2026 14:30:18 +0000
Message-ID: <20261030143019.484280-2-ahsan.atta@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20261030143019.484280-1-ahsan.atta@intel.com>
References: <20261030143019.484280-1-ahsan.atta@intel.com>
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
mapping, and thread-to-arbiter mapping required for three-service mode.

Signed-off-by: Bairavi Alagappan <bairavix.alagappan@intel.com>
Signed-off-by: Ahsan Atta <ahsan.atta@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 .../intel/qat/qat_420xx/adf_420xx_hw_data.c   | 59 ++++++++++++++++++-
 .../intel/qat/qat_420xx/adf_420xx_hw_data.h   |  6 ++
 .../intel/qat/qat_common/adf_cfg_services.c   |  3 +
 .../intel/qat/qat_common/adf_cfg_services.h   |  1 +
 4 files changed, 67 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c b/drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c
index d6f1f626cf5a..23684868b4e3 100644
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
@@ -425,6 +450,36 @@ static void adf_gen4_set_err_mask(struct adf_dev_err_mask *dev_err_mask)
 	dev_err_mask->ssmfeatren_mask = ADF_420XX_SSMFEATREN_MASK;
 }
 
+static u16 adf_420xx_get_ring_to_svc_map(struct adf_accel_dev *accel_dev)
+{
+	if (adf_get_service_enabled(accel_dev) == SVC_SYM_ASYM_DC)
+		return ADF_420XX_SYM_ASYM_DC_RING_TO_SRV_MAP;
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
 void adf_init_hw_data_420xx(struct adf_hw_device_data *hw_data, u32 dev_id)
 {
 	hw_data->dev_class = &adf_420xx_class;
@@ -472,7 +527,7 @@ void adf_init_hw_data_420xx(struct adf_hw_device_data *hw_data, u32 dev_id)
 	hw_data->get_ena_thd_mask = get_ena_thd_mask;
 	hw_data->set_msix_rttable = adf_gen4_set_msix_default_rttable;
 	hw_data->set_ssm_wdtimer = adf_gen4_set_ssm_wdtimer;
-	hw_data->get_ring_to_svc_map = adf_gen4_get_ring_to_svc_map;
+	hw_data->get_ring_to_svc_map = adf_420xx_get_ring_to_svc_map;
 	hw_data->disable_iov = adf_disable_sriov;
 	hw_data->ring_pair_reset = adf_gen4_ring_pair_reset;
 	hw_data->bank_state_save = adf_bank_state_save;
@@ -485,7 +540,7 @@ void adf_init_hw_data_420xx(struct adf_hw_device_data *hw_data, u32 dev_id)
 	hw_data->get_hb_clock = adf_gen4_get_heartbeat_clock;
 	hw_data->num_hb_ctrs = ADF_NUM_HB_CNT_PER_AE;
 	hw_data->clock_frequency = ADF_420XX_AE_FREQ;
-	hw_data->services_supported = adf_gen4_services_supported;
+	hw_data->services_supported = adf_420xx_services_supported;
 	hw_data->get_svc_slice_cnt = adf_gen4_get_svc_slice_cnt;
 	hw_data->accel_capabilities_ext_mask = ADF_ACCEL_CAPABILITIES_EXT_ZSTD_LZ4S;
 
diff --git a/drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.h b/drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.h
index 99abbfc14820..1fdaed3dd952 100644
--- a/drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.h
+++ b/drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.h
@@ -17,6 +17,12 @@
 #define ADF_420XX_PARITYERRORMASK_PKE_MASK	(0xFFF)
 #define ADF_420XX_PARITYERRORMASK_WAT_WCP_MASK	(0x3FF03FF)
 
+#define ADF_420XX_SYM_ASYM_DC_RING_TO_SRV_MAP \
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

