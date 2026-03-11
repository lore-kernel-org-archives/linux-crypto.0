Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC706363C6B
	for <linux-crypto@vger.kernel.org>; Wed, 11 Mar 2026 08:21:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773217285; cv=none; b=UYe9cs0F0cv9jnghgIuo4JexH+iNKNmRg4TwqHZmh7kNitBvplNi2b5mslNuvAh82OMwT7uaNuUCuWr3FKNdndt48dwuZsRVvW9icOsfdm1A/INvveFSK9eRAglnC35wLRy31oLM4jZiAclnpA7BlmupV8mC5dDJw5aBJ3hxN+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773217285; c=relaxed/simple;
	bh=8MAPtmhyD0+901d23UcMPZHu6+0L5G2ZuKXLwpi3JLg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=b1SoiWmsZqoSuGEyYMky08z7sWrqHRLt3UbaGRRPD5TWHyVWwfIExk2d4SlE3vlmn2QTUitLHBvyvSo7NF2L/OYHV8hiR5a0ZvEhTO69quAiXInZ5giVqIPC1QT6EeXXB4gb09bH+Ex9xnLZDnet+12wDeEoeO4mCb3d91Qkf4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cQFHKDHE; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cQFHKDHE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1773217284; x=1804753284;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=8MAPtmhyD0+901d23UcMPZHu6+0L5G2ZuKXLwpi3JLg=;
  b=cQFHKDHE7Gz80M38O4K++glPGtbpnQcfRhwofFTtRK/cT8c1j+2Y4ZvF
   6lJoXOFID32nnmLqAtFB58v1mvZWTVxIJ3ALXuutSu4yum4+Ue+ysjQRv
   AcBS5l2ZWaABxydDTmKHG4M/nTkWxfahum1g04Ca9CCnA5/uF97Tdc0v1
   J73MpfCEj9bf43NJk97EfaFsalq37FZE3nBOSSTjsWwJuBCXr+MhMumyY
   xVvBZCz9/VxeFzNEAbTX+x+SCntJqial7glmPP+JZ1hwBx4DKKfeyaFv8
   MiOfmgmDSV5x1saRgEz8Fcw72GU0h5UWAxJo2a1cthzQxHoWtsoBbgwDJ
   Q==;
X-CSE-ConnectionGUID: rPc/J5V9QFmXdfbnmbp9GQ==
X-CSE-MsgGUID: Gtt99YRwR5aVceh/0VmDfg==
X-IronPort-AV: E=McAfee;i="6800,10657,11725"; a="85632423"
X-IronPort-AV: E=Sophos;i="6.23,113,1770624000"; 
   d="scan'208";a="85632423"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2026 01:21:23 -0700
X-CSE-ConnectionGUID: 2irlLnSmQuyf1B0yzpxBew==
X-CSE-MsgGUID: OI5Ef931ROasp2GF4u8qLg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,113,1770624000"; 
   d="scan'208";a="246002324"
Received: from indlpbc065983.iind.intel.com ([10.49.120.87])
  by fmviesa001.fm.intel.com with ESMTP; 11 Mar 2026 01:21:21 -0700
From: George Abraham P <george.abraham.p@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	George Abraham P <george.abraham.p@intel.com>,
	Aviraj Cj <aviraj.cj@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH] crypto: qat - add wireless mode support for QAT GEN6
Date: Wed, 11 Mar 2026 13:52:45 +0530
Message-Id: <20260311082245.3466672-1-george.abraham.p@intel.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add wireless mode support for QAT GEN6 devices.

When the WCP_WAT fuse bit is clear, the device operates in wireless
cipher mode (wcy_mode). In this mode all accelerator engines load the
wireless firmware and service configuration via 'cfg_services' sysfs
attribute is restricted to 'sym' only.

The get_accel_cap() function is extended to report wireless-specific
capabilities (ZUC, ZUC-256, 5G, extended algorithm chaining) gated by
their respective slice-disable fuse bits. The set_ssm_wdtimer() function
is updated to configure WCP (wireless cipher) and WAT (wireless
authentication) watchdog timers. The adf_gen6_cfg_dev_init() function is
updated to use adf_6xxx_is_wcy() to enforce sym-only service selection
for WCY devices during initialization.

Co-developed-by: Aviraj Cj <aviraj.cj@intel.com>
Signed-off-by: Aviraj Cj <aviraj.cj@intel.com>
Signed-off-by: George Abraham P <george.abraham.p@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 .../intel/qat/qat_6xxx/adf_6xxx_hw_data.c     | 97 +++++++++++++++++--
 .../intel/qat/qat_6xxx/adf_6xxx_hw_data.h     | 14 +++
 drivers/crypto/intel/qat/qat_6xxx/adf_drv.c   | 33 ++++++-
 .../intel/qat/qat_common/adf_fw_config.h      |  1 +
 .../intel/qat/qat_common/adf_gen6_shared.c    |  6 --
 .../intel/qat/qat_common/adf_gen6_shared.h    |  1 -
 .../crypto/intel/qat/qat_common/icp_qat_hw.h  |  3 +-
 7 files changed, 137 insertions(+), 18 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_6xxx/adf_6xxx_hw_data.c b/drivers/crypto/intel/qat/qat_6xxx/adf_6xxx_hw_data.c
index bed88d3ce8ca..f4c61978b048 100644
--- a/drivers/crypto/intel/qat/qat_6xxx/adf_6xxx_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_6xxx/adf_6xxx_hw_data.c
@@ -82,10 +82,15 @@ static const unsigned long thrd_mask_dcpr[ADF_6XXX_MAX_ACCELENGINES] = {
 	0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x00
 };
 
+static const unsigned long thrd_mask_wcy[ADF_6XXX_MAX_ACCELENGINES] = {
+	0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x00
+};
+
 static const char *const adf_6xxx_fw_objs[] = {
 	[ADF_FW_CY_OBJ] = ADF_6XXX_CY_OBJ,
 	[ADF_FW_DC_OBJ] = ADF_6XXX_DC_OBJ,
 	[ADF_FW_ADMIN_OBJ] = ADF_6XXX_ADMIN_OBJ,
+	[ADF_FW_WCY_OBJ] = ADF_6XXX_WCY_OBJ,
 };
 
 static const struct adf_fw_config adf_default_fw_config[] = {
@@ -94,6 +99,12 @@ static const struct adf_fw_config adf_default_fw_config[] = {
 	{ ADF_AE_GROUP_2, ADF_FW_ADMIN_OBJ },
 };
 
+static const struct adf_fw_config adf_wcy_fw_config[] = {
+	{ ADF_AE_GROUP_1, ADF_FW_WCY_OBJ },
+	{ ADF_AE_GROUP_0, ADF_FW_WCY_OBJ },
+	{ ADF_AE_GROUP_2, ADF_FW_ADMIN_OBJ },
+};
+
 static struct adf_hw_device_class adf_6xxx_class = {
 	.name = ADF_6XXX_DEVICE_NAME,
 	.type = DEV_6XXX,
@@ -118,6 +129,12 @@ static bool services_supported(unsigned long mask)
 	}
 }
 
+static bool wcy_services_supported(unsigned long mask)
+{
+	/* The wireless SKU supports only the symmetric crypto service */
+	return mask == BIT(SVC_SYM);
+}
+
 static int get_service(unsigned long *mask)
 {
 	if (test_and_clear_bit(SVC_ASYM, mask))
@@ -155,8 +172,12 @@ static enum adf_cfg_service_type get_ring_type(unsigned int service)
 	}
 }
 
-static const unsigned long *get_thrd_mask(unsigned int service)
+static const unsigned long *get_thrd_mask(struct adf_accel_dev *accel_dev,
+					  unsigned int service)
 {
+	if (adf_6xxx_is_wcy(GET_HW_DATA(accel_dev)))
+		return (service == SVC_SYM) ? thrd_mask_wcy : NULL;
+
 	switch (service) {
 	case SVC_SYM:
 		return thrd_mask_sym;
@@ -194,7 +215,7 @@ static int get_rp_config(struct adf_accel_dev *accel_dev, struct adf_ring_config
 			return service;
 
 		rp_config[i].ring_type = get_ring_type(service);
-		rp_config[i].thrd_mask = get_thrd_mask(service);
+		rp_config[i].thrd_mask = get_thrd_mask(accel_dev, service);
 
 		/*
 		 * If there is only one service enabled, use all ring pairs for
@@ -386,6 +407,8 @@ static void set_ssm_wdtimer(struct adf_accel_dev *accel_dev)
 	ADF_CSR_WR64_LO_HI(addr, ADF_SSMWDTCNVL_OFFSET, ADF_SSMWDTCNVH_OFFSET, val);
 	ADF_CSR_WR64_LO_HI(addr, ADF_SSMWDTUCSL_OFFSET, ADF_SSMWDTUCSH_OFFSET, val);
 	ADF_CSR_WR64_LO_HI(addr, ADF_SSMWDTDCPRL_OFFSET, ADF_SSMWDTDCPRH_OFFSET, val);
+	ADF_CSR_WR64_LO_HI(addr, ADF_SSMWDTWCPL_OFFSET, ADF_SSMWDTWCPH_OFFSET, val);
+	ADF_CSR_WR64_LO_HI(addr, ADF_SSMWDTWATL_OFFSET, ADF_SSMWDTWATH_OFFSET, val);
 
 	/* Enable watchdog timer for pke */
 	ADF_CSR_WR64_LO_HI(addr, ADF_SSMWDTPKEL_OFFSET, ADF_SSMWDTPKEH_OFFSET, val_pke);
@@ -631,6 +654,12 @@ static int adf_gen6_set_vc(struct adf_accel_dev *accel_dev)
 	return set_vc_config(accel_dev);
 }
 
+static const struct adf_fw_config *get_fw_config(struct adf_accel_dev *accel_dev)
+{
+	return adf_6xxx_is_wcy(GET_HW_DATA(accel_dev)) ? adf_wcy_fw_config :
+							 adf_default_fw_config;
+}
+
 static u32 get_ae_mask(struct adf_hw_device_data *self)
 {
 	unsigned long fuses = self->fuses[ADF_FUSECTL4];
@@ -653,6 +682,38 @@ static u32 get_ae_mask(struct adf_hw_device_data *self)
 	return mask;
 }
 
+static u32 get_accel_cap_wcy(struct adf_accel_dev *accel_dev)
+{
+	u32 capabilities_sym;
+	u32 fuse;
+
+	fuse = GET_HW_DATA(accel_dev)->fuses[ADF_FUSECTL1];
+
+	capabilities_sym = ICP_ACCEL_CAPABILITIES_CRYPTO_SYMMETRIC |
+			   ICP_ACCEL_CAPABILITIES_CIPHER |
+			   ICP_ACCEL_CAPABILITIES_AUTHENTICATION |
+			   ICP_ACCEL_CAPABILITIES_WIRELESS_CRYPTO_EXT |
+			   ICP_ACCEL_CAPABILITIES_5G |
+			   ICP_ACCEL_CAPABILITIES_ZUC |
+			   ICP_ACCEL_CAPABILITIES_ZUC_256 |
+			   ICP_ACCEL_CAPABILITIES_EXT_ALGCHAIN;
+
+	if (fuse & ICP_ACCEL_GEN6_MASK_EIA3_SLICE) {
+		capabilities_sym &= ~ICP_ACCEL_CAPABILITIES_ZUC;
+		capabilities_sym &= ~ICP_ACCEL_CAPABILITIES_ZUC_256;
+	}
+	if (fuse & ICP_ACCEL_GEN6_MASK_ZUC_256_SLICE)
+		capabilities_sym &= ~ICP_ACCEL_CAPABILITIES_ZUC_256;
+
+	if (fuse & ICP_ACCEL_GEN6_MASK_5G_SLICE)
+		capabilities_sym &= ~ICP_ACCEL_CAPABILITIES_5G;
+
+	if (adf_get_service_enabled(accel_dev) == SVC_SYM)
+		return capabilities_sym;
+
+	return 0;
+}
+
 static u32 get_accel_cap(struct adf_accel_dev *accel_dev)
 {
 	u32 capabilities_sym, capabilities_asym;
@@ -661,6 +722,9 @@ static u32 get_accel_cap(struct adf_accel_dev *accel_dev)
 	u32 caps = 0;
 	u32 fusectl1;
 
+	if (adf_6xxx_is_wcy(GET_HW_DATA(accel_dev)))
+		return get_accel_cap_wcy(accel_dev);
+
 	fusectl1 = GET_HW_DATA(accel_dev)->fuses[ADF_FUSECTL1];
 
 	/* Read accelerator capabilities mask */
@@ -733,15 +797,19 @@ static u32 get_accel_cap(struct adf_accel_dev *accel_dev)
 
 static u32 uof_get_num_objs(struct adf_accel_dev *accel_dev)
 {
-	return ARRAY_SIZE(adf_default_fw_config);
+	return adf_6xxx_is_wcy(GET_HW_DATA(accel_dev)) ?
+		       ARRAY_SIZE(adf_wcy_fw_config) :
+		       ARRAY_SIZE(adf_default_fw_config);
 }
 
 static const char *uof_get_name(struct adf_accel_dev *accel_dev, u32 obj_num)
 {
 	int num_fw_objs = ARRAY_SIZE(adf_6xxx_fw_objs);
+	const struct adf_fw_config *fw_config;
 	int id;
 
-	id = adf_default_fw_config[obj_num].obj;
+	fw_config = get_fw_config(accel_dev);
+	id = fw_config[obj_num].obj;
 	if (id >= num_fw_objs)
 		return NULL;
 
@@ -755,15 +823,22 @@ static const char *uof_get_name_6xxx(struct adf_accel_dev *accel_dev, u32 obj_nu
 
 static int uof_get_obj_type(struct adf_accel_dev *accel_dev, u32 obj_num)
 {
+	const struct adf_fw_config *fw_config;
+
 	if (obj_num >= uof_get_num_objs(accel_dev))
 		return -EINVAL;
 
-	return adf_default_fw_config[obj_num].obj;
+	fw_config = get_fw_config(accel_dev);
+
+	return fw_config[obj_num].obj;
 }
 
 static u32 uof_get_ae_mask(struct adf_accel_dev *accel_dev, u32 obj_num)
 {
-	return adf_default_fw_config[obj_num].ae_mask;
+	const struct adf_fw_config *fw_config;
+
+	fw_config = get_fw_config(accel_dev);
+	return fw_config[obj_num].ae_mask;
 }
 
 static const u32 *adf_get_arbiter_mapping(struct adf_accel_dev *accel_dev)
@@ -873,6 +948,14 @@ static void adf_gen6_init_rl_data(struct adf_rl_hw_data *rl_data)
 	init_num_svc_aes(rl_data);
 }
 
+static void adf_gen6_init_services_supported(struct adf_hw_device_data *hw_data)
+{
+	if (adf_6xxx_is_wcy(hw_data))
+		hw_data->services_supported = wcy_services_supported;
+	else
+		hw_data->services_supported = services_supported;
+}
+
 void adf_init_hw_data_6xxx(struct adf_hw_device_data *hw_data)
 {
 	hw_data->dev_class = &adf_6xxx_class;
@@ -929,11 +1012,11 @@ void adf_init_hw_data_6xxx(struct adf_hw_device_data *hw_data)
 	hw_data->stop_timer = adf_timer_stop;
 	hw_data->init_device = adf_init_device;
 	hw_data->enable_pm = enable_pm;
-	hw_data->services_supported = services_supported;
 	hw_data->num_rps = ADF_GEN6_ETR_MAX_BANKS;
 	hw_data->clock_frequency = ADF_6XXX_AE_FREQ;
 	hw_data->get_svc_slice_cnt = adf_gen6_get_svc_slice_cnt;
 
+	adf_gen6_init_services_supported(hw_data);
 	adf_gen6_init_hw_csr_ops(&hw_data->csr_ops);
 	adf_gen6_init_pf_pfvf_ops(&hw_data->pfvf_ops);
 	adf_gen6_init_dc_ops(&hw_data->dc_ops);
diff --git a/drivers/crypto/intel/qat/qat_6xxx/adf_6xxx_hw_data.h b/drivers/crypto/intel/qat/qat_6xxx/adf_6xxx_hw_data.h
index d822911fe68c..fa31d6d584e6 100644
--- a/drivers/crypto/intel/qat/qat_6xxx/adf_6xxx_hw_data.h
+++ b/drivers/crypto/intel/qat/qat_6xxx/adf_6xxx_hw_data.h
@@ -64,10 +64,14 @@
 #define ADF_SSMWDTATHH_OFFSET		0x520C
 #define ADF_SSMWDTCNVL_OFFSET		0x5408
 #define ADF_SSMWDTCNVH_OFFSET		0x540C
+#define ADF_SSMWDTWCPL_OFFSET		0x5608
+#define ADF_SSMWDTWCPH_OFFSET		0x560C
 #define ADF_SSMWDTUCSL_OFFSET		0x5808
 #define ADF_SSMWDTUCSH_OFFSET		0x580C
 #define ADF_SSMWDTDCPRL_OFFSET		0x5A08
 #define ADF_SSMWDTDCPRH_OFFSET		0x5A0C
+#define ADF_SSMWDTWATL_OFFSET		0x5C08
+#define ADF_SSMWDTWATH_OFFSET		0x5C0C
 #define ADF_SSMWDTPKEL_OFFSET		0x5E08
 #define ADF_SSMWDTPKEH_OFFSET		0x5E0C
 
@@ -139,6 +143,7 @@
 #define ADF_6XXX_CY_OBJ		"qat_6xxx_cy.bin"
 #define ADF_6XXX_DC_OBJ		"qat_6xxx_dc.bin"
 #define ADF_6XXX_ADMIN_OBJ	"qat_6xxx_admin.bin"
+#define ADF_6XXX_WCY_OBJ	"qat_6xxx_wcy.bin"
 
 /* RL constants */
 #define ADF_6XXX_RL_PCIE_SCALE_FACTOR_DIV	100
@@ -159,9 +164,18 @@ enum icp_qat_gen6_slice_mask {
 	ICP_ACCEL_GEN6_MASK_PKE_SLICE = BIT(2),
 	ICP_ACCEL_GEN6_MASK_CPR_SLICE = BIT(3),
 	ICP_ACCEL_GEN6_MASK_DCPRZ_SLICE = BIT(4),
+	ICP_ACCEL_GEN6_MASK_EIA3_SLICE = BIT(5),
 	ICP_ACCEL_GEN6_MASK_WCP_WAT_SLICE = BIT(6),
+	ICP_ACCEL_GEN6_MASK_ZUC_256_SLICE = BIT(7),
+	ICP_ACCEL_GEN6_MASK_5G_SLICE = BIT(8),
 };
 
+/* Return true if the device is a wireless crypto (WCY) SKU */
+static inline bool adf_6xxx_is_wcy(struct adf_hw_device_data *hw_data)
+{
+	return !(hw_data->fuses[ADF_FUSECTL1] & ICP_ACCEL_GEN6_MASK_WCP_WAT_SLICE);
+}
+
 void adf_init_hw_data_6xxx(struct adf_hw_device_data *hw_data);
 void adf_clean_hw_data_6xxx(struct adf_hw_device_data *hw_data);
 
diff --git a/drivers/crypto/intel/qat/qat_6xxx/adf_drv.c b/drivers/crypto/intel/qat/qat_6xxx/adf_drv.c
index c1dc9c56fdf5..0684ea9be2ac 100644
--- a/drivers/crypto/intel/qat/qat_6xxx/adf_drv.c
+++ b/drivers/crypto/intel/qat/qat_6xxx/adf_drv.c
@@ -16,6 +16,7 @@
 
 #include "adf_gen6_shared.h"
 #include "adf_6xxx_hw_data.h"
+#include "adf_heartbeat.h"
 
 static int bar_map[] = {
 	0,	/* SRAM */
@@ -53,6 +54,35 @@ static void adf_devmgr_remove(void *accel_dev)
 	adf_devmgr_rm_dev(accel_dev, NULL);
 }
 
+static int adf_gen6_cfg_dev_init(struct adf_accel_dev *accel_dev)
+{
+	const char *config;
+	int ret;
+
+	/*
+	 * Wireless SKU - symmetric crypto service only
+	 * Non-wireless SKU - crypto service for even devices and compression for odd devices
+	 */
+	if (adf_6xxx_is_wcy(GET_HW_DATA(accel_dev)))
+		config = ADF_CFG_SYM;
+	else
+		config = accel_dev->accel_id % 2 ? ADF_CFG_DC : ADF_CFG_CY;
+
+	ret = adf_cfg_section_add(accel_dev, ADF_GENERAL_SEC);
+	if (ret)
+		return ret;
+
+	ret = adf_cfg_add_key_value_param(accel_dev, ADF_GENERAL_SEC,
+					  ADF_SERVICES_ENABLED, config,
+					  ADF_STR);
+	if (ret)
+		return ret;
+
+	adf_heartbeat_save_cfg_param(accel_dev, ADF_CFG_HB_TIMER_MIN_MS);
+
+	return 0;
+}
+
 static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	struct adf_accel_pci *accel_pci_dev;
@@ -91,9 +121,6 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	pci_read_config_dword(pdev, ADF_GEN6_FUSECTL0_OFFSET, &hw_data->fuses[ADF_FUSECTL0]);
 	pci_read_config_dword(pdev, ADF_GEN6_FUSECTL1_OFFSET, &hw_data->fuses[ADF_FUSECTL1]);
 
-	if (!(hw_data->fuses[ADF_FUSECTL1] & ICP_ACCEL_GEN6_MASK_WCP_WAT_SLICE))
-		return dev_err_probe(dev, -EFAULT, "Wireless mode is not supported.\n");
-
 	/* Enable PCI device */
 	ret = pcim_enable_device(pdev);
 	if (ret)
diff --git a/drivers/crypto/intel/qat/qat_common/adf_fw_config.h b/drivers/crypto/intel/qat/qat_common/adf_fw_config.h
index 78957fa900b7..d5c578e3fd8d 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_fw_config.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_fw_config.h
@@ -9,6 +9,7 @@ enum adf_fw_objs {
 	ADF_FW_DC_OBJ,
 	ADF_FW_ADMIN_OBJ,
 	ADF_FW_CY_OBJ,
+	ADF_FW_WCY_OBJ,
 };
 
 struct adf_fw_config {
diff --git a/drivers/crypto/intel/qat/qat_common/adf_gen6_shared.c b/drivers/crypto/intel/qat/qat_common/adf_gen6_shared.c
index c9b151006dca..ffe4525a1e69 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_gen6_shared.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_gen6_shared.c
@@ -31,12 +31,6 @@ void adf_gen6_init_hw_csr_ops(struct adf_hw_csr_ops *csr_ops)
 }
 EXPORT_SYMBOL_GPL(adf_gen6_init_hw_csr_ops);
 
-int adf_gen6_cfg_dev_init(struct adf_accel_dev *accel_dev)
-{
-	return adf_gen4_cfg_dev_init(accel_dev);
-}
-EXPORT_SYMBOL_GPL(adf_gen6_cfg_dev_init);
-
 int adf_gen6_comp_dev_config(struct adf_accel_dev *accel_dev)
 {
 	return adf_comp_dev_config(accel_dev);
diff --git a/drivers/crypto/intel/qat/qat_common/adf_gen6_shared.h b/drivers/crypto/intel/qat/qat_common/adf_gen6_shared.h
index fc6fad029a70..072115a531e4 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_gen6_shared.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_gen6_shared.h
@@ -10,7 +10,6 @@ struct adf_pfvf_ops;
 
 void adf_gen6_init_pf_pfvf_ops(struct adf_pfvf_ops *pfvf_ops);
 void adf_gen6_init_hw_csr_ops(struct adf_hw_csr_ops *csr_ops);
-int adf_gen6_cfg_dev_init(struct adf_accel_dev *accel_dev);
 int adf_gen6_comp_dev_config(struct adf_accel_dev *accel_dev);
 int adf_gen6_no_dev_config(struct adf_accel_dev *accel_dev);
 void adf_gen6_init_vf_mig_ops(struct qat_migdev_ops *vfmig_ops);
diff --git a/drivers/crypto/intel/qat/qat_common/icp_qat_hw.h b/drivers/crypto/intel/qat/qat_common/icp_qat_hw.h
index b8f1c4ffb8b5..0223bd541f1f 100644
--- a/drivers/crypto/intel/qat/qat_common/icp_qat_hw.h
+++ b/drivers/crypto/intel/qat/qat_common/icp_qat_hw.h
@@ -94,7 +94,8 @@ enum icp_qat_capabilities_mask {
 	ICP_ACCEL_CAPABILITIES_AUTHENTICATION = BIT(3),
 	ICP_ACCEL_CAPABILITIES_RESERVED_1 = BIT(4),
 	ICP_ACCEL_CAPABILITIES_COMPRESSION = BIT(5),
-	/* Bits 6-7 are currently reserved */
+	/* Bit 6 is currently reserved */
+	ICP_ACCEL_CAPABILITIES_5G = BIT(7),
 	ICP_ACCEL_CAPABILITIES_ZUC = BIT(8),
 	ICP_ACCEL_CAPABILITIES_SHA3 = BIT(9),
 	/* Bits 10-11 are currently reserved */

base-commit: 00617f6cd0e310d7f3b73006741eb63fc1b7f825
-- 
2.40.1

