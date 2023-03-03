Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17855C7EE2D
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Mar 2023 17:10:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230420AbjCCRKB (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 3 Mar 2023 12:10:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231542AbjCCRKB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 3 Mar 2023 12:10:01 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 823FD22A18
        for <linux-crypto@vger.kernel.org>; Fri,  3 Mar 2023 09:09:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677863393; x=1709399393;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=MqVdqfn4wBiaDNHAfqRJsRdWgMIWzaAKnzMU//cyHOo=;
  b=M9SaXvLYzhQHpMwOF67we9DNI/gRfT+sG9xA1nVmQQVA19e0zHd6j7be
   P9Yhm037AzQaLj9JGSGlxzQ1NU78annQkG6wNvPbtTvGOQr5e9o2YyzaK
   20oJbIqAt/+zXjg7z/k347yffsHqyL/GZJAKotoeZK42K7Pmg/M+KpHDq
   kmuRQbwJ7WQ6EyqR5UOQKz9MtPzn3CSxITwvyWMwX5Hk5my1dzTTrsH3y
   H/6r69fC6LUIGbdm+b+6GujqE6KeSpGisq/axvWYZV4NkkEZxvhnC1EXm
   Wcb7jnpEwG6JyocYl6MCdwXzEbDVMCN5DjbE67QoX0OoeklH3PMYE9QCt
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10638"; a="315495524"
X-IronPort-AV: E=Sophos;i="5.98,231,1673942400"; 
   d="scan'208";a="315495524"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2023 09:07:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10638"; a="707908047"
X-IronPort-AV: E=Sophos;i="5.98,231,1673942400"; 
   d="scan'208";a="707908047"
Received: from r031s002_zp31l10c01.gv.intel.com (HELO fedora..) ([10.219.171.29])
  by orsmga001.jf.intel.com with ESMTP; 03 Mar 2023 09:07:09 -0800
From:   Damian Muszynski <damian.muszynski@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Damian Muszynski <damian.muszynski@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH] crypto: qat - add support for 402xx devices
Date:   Fri,  3 Mar 2023 17:56:50 +0100
Message-Id: <20230303165650.81405-1-damian.muszynski@intel.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Organization: Intel Technology Poland sp. z o.o. - ul. Slowackiego 173, 80-298 Gdansk - KRS 101882 - NIP 957-07-52-316
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

QAT_402xx is a derivative of 4xxx. Add support for that device in the
qat_4xxx driver by including the DIDs (both PF and VF), extending the
probe and the firmware loader.

402xx uses different firmware images than 4xxx. To allow that the logic
that selects the firmware images was modified.

Signed-off-by: Damian Muszynski <damian.muszynski@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 .../crypto/qat/qat_4xxx/adf_4xxx_hw_data.c    | 43 ++++++++++++++++---
 .../crypto/qat/qat_4xxx/adf_4xxx_hw_data.h    |  9 +++-
 drivers/crypto/qat/qat_4xxx/adf_drv.c         |  3 +-
 .../crypto/qat/qat_common/adf_accel_devices.h |  2 +
 drivers/crypto/qat/qat_common/qat_hal.c       |  1 +
 drivers/crypto/qat/qat_common/qat_uclo.c      |  1 +
 6 files changed, 52 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/qat/qat_4xxx/adf_4xxx_hw_data.c b/drivers/crypto/qat/qat_4xxx/adf_4xxx_hw_data.c
index 834a705180c0..2fb904800145 100644
--- a/drivers/crypto/qat/qat_4xxx/adf_4xxx_hw_data.c
+++ b/drivers/crypto/qat/qat_4xxx/adf_4xxx_hw_data.c
@@ -28,6 +28,18 @@ static struct adf_fw_config adf_4xxx_fw_dc_config[] = {
 	{0x100, ADF_4XXX_ADMIN_OBJ},
 };
 
+static struct adf_fw_config adf_402xx_fw_cy_config[] = {
+	{0xF0, ADF_402XX_SYM_OBJ},
+	{0xF, ADF_402XX_ASYM_OBJ},
+	{0x100, ADF_402XX_ADMIN_OBJ},
+};
+
+static struct adf_fw_config adf_402xx_fw_dc_config[] = {
+	{0xF0, ADF_402XX_DC_OBJ},
+	{0xF, ADF_402XX_DC_OBJ},
+	{0x100, ADF_402XX_ADMIN_OBJ},
+};
+
 /* Worker thread to service arbiter mappings */
 static const u32 thrd_to_arb_map[ADF_4XXX_MAX_ACCELENGINES] = {
 	0x5555555, 0x5555555, 0x5555555, 0x5555555,
@@ -286,7 +298,7 @@ static u32 uof_get_num_objs(void)
 	return ARRAY_SIZE(adf_4xxx_fw_cy_config);
 }
 
-static char *uof_get_name(struct adf_accel_dev *accel_dev, u32 obj_num)
+static char *uof_get_name_4xxx(struct adf_accel_dev *accel_dev, u32 obj_num)
 {
 	switch (get_service_enabled(accel_dev)) {
 	case SVC_CY:
@@ -298,6 +310,18 @@ static char *uof_get_name(struct adf_accel_dev *accel_dev, u32 obj_num)
 	return NULL;
 }
 
+static char *uof_get_name_402xx(struct adf_accel_dev *accel_dev, u32 obj_num)
+{
+	switch (get_service_enabled(accel_dev)) {
+	case SVC_CY:
+		return adf_402xx_fw_cy_config[obj_num].obj_name;
+	case SVC_DC:
+		return adf_402xx_fw_dc_config[obj_num].obj_name;
+	}
+
+	return NULL;
+}
+
 static u32 uof_get_ae_mask(struct adf_accel_dev *accel_dev, u32 obj_num)
 {
 	switch (get_service_enabled(accel_dev)) {
@@ -310,7 +334,7 @@ static u32 uof_get_ae_mask(struct adf_accel_dev *accel_dev, u32 obj_num)
 	return 0;
 }
 
-void adf_init_hw_data_4xxx(struct adf_hw_device_data *hw_data)
+void adf_init_hw_data_4xxx(struct adf_hw_device_data *hw_data, u32 dev_id)
 {
 	hw_data->dev_class = &adf_4xxx_class;
 	hw_data->instance_id = adf_4xxx_class.instances++;
@@ -337,8 +361,6 @@ void adf_init_hw_data_4xxx(struct adf_hw_device_data *hw_data)
 	hw_data->get_admin_info = get_admin_info;
 	hw_data->get_accel_cap = get_accel_cap;
 	hw_data->get_sku = get_sku;
-	hw_data->fw_name = ADF_4XXX_FW;
-	hw_data->fw_mmp_name = ADF_4XXX_MMP;
 	hw_data->init_admin_comms = adf_init_admin_comms;
 	hw_data->exit_admin_comms = adf_exit_admin_comms;
 	hw_data->send_admin_init = adf_send_admin_init;
@@ -349,8 +371,19 @@ void adf_init_hw_data_4xxx(struct adf_hw_device_data *hw_data)
 	hw_data->init_device = adf_init_device;
 	hw_data->reset_device = adf_reset_flr;
 	hw_data->admin_ae_mask = ADF_4XXX_ADMIN_AE_MASK;
+	switch (dev_id) {
+	case ADF_402XX_PCI_DEVICE_ID:
+		hw_data->fw_name = ADF_402XX_FW;
+		hw_data->fw_mmp_name = ADF_402XX_MMP;
+		hw_data->uof_get_name = uof_get_name_402xx;
+		break;
+
+	default:
+		hw_data->fw_name = ADF_4XXX_FW;
+		hw_data->fw_mmp_name = ADF_4XXX_MMP;
+		hw_data->uof_get_name = uof_get_name_4xxx;
+	}
 	hw_data->uof_get_num_objs = uof_get_num_objs;
-	hw_data->uof_get_name = uof_get_name;
 	hw_data->uof_get_ae_mask = uof_get_ae_mask;
 	hw_data->set_msix_rttable = set_msix_default_rttable;
 	hw_data->set_ssm_wdtimer = adf_gen4_set_ssm_wdtimer;
diff --git a/drivers/crypto/qat/qat_4xxx/adf_4xxx_hw_data.h b/drivers/crypto/qat/qat_4xxx/adf_4xxx_hw_data.h
index e98428ba78e2..085e259c245a 100644
--- a/drivers/crypto/qat/qat_4xxx/adf_4xxx_hw_data.h
+++ b/drivers/crypto/qat/qat_4xxx/adf_4xxx_hw_data.h
@@ -56,6 +56,13 @@
 #define ADF_4XXX_DC_OBJ		"qat_4xxx_dc.bin"
 #define ADF_4XXX_ASYM_OBJ	"qat_4xxx_asym.bin"
 #define ADF_4XXX_ADMIN_OBJ	"qat_4xxx_admin.bin"
+/* Firmware for 402XXX */
+#define ADF_402XX_FW		"qat_402xx.bin"
+#define ADF_402XX_MMP		"qat_402xx_mmp.bin"
+#define ADF_402XX_SYM_OBJ	"qat_402xx_sym.bin"
+#define ADF_402XX_DC_OBJ	"qat_402xx_dc.bin"
+#define ADF_402XX_ASYM_OBJ	"qat_402xx_asym.bin"
+#define ADF_402XX_ADMIN_OBJ	"qat_402xx_admin.bin"
 
 /* qat_4xxx fuse bits are different from old GENs, redefine them */
 enum icp_qat_4xxx_slice_mask {
@@ -68,7 +75,7 @@ enum icp_qat_4xxx_slice_mask {
 	ICP_ACCEL_4XXX_MASK_SMX_SLICE = BIT(6),
 };
 
-void adf_init_hw_data_4xxx(struct adf_hw_device_data *hw_data);
+void adf_init_hw_data_4xxx(struct adf_hw_device_data *hw_data, u32 dev_id);
 void adf_clean_hw_data_4xxx(struct adf_hw_device_data *hw_data);
 int adf_gen4_dev_config(struct adf_accel_dev *accel_dev);
 
diff --git a/drivers/crypto/qat/qat_4xxx/adf_drv.c b/drivers/crypto/qat/qat_4xxx/adf_drv.c
index 6f862b56c51c..1b8ccd43d6ee 100644
--- a/drivers/crypto/qat/qat_4xxx/adf_drv.c
+++ b/drivers/crypto/qat/qat_4xxx/adf_drv.c
@@ -16,6 +16,7 @@
 static const struct pci_device_id adf_pci_tbl[] = {
 	{ PCI_VDEVICE(INTEL, ADF_4XXX_PCI_DEVICE_ID), },
 	{ PCI_VDEVICE(INTEL, ADF_401XX_PCI_DEVICE_ID), },
+	{ PCI_VDEVICE(INTEL, ADF_402XX_PCI_DEVICE_ID), },
 	{ }
 };
 MODULE_DEVICE_TABLE(pci, adf_pci_tbl);
@@ -330,7 +331,7 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	}
 
 	accel_dev->hw_device = hw_data;
-	adf_init_hw_data_4xxx(accel_dev->hw_device);
+	adf_init_hw_data_4xxx(accel_dev->hw_device, ent->device);
 
 	pci_read_config_byte(pdev, PCI_REVISION_ID, &accel_pci_dev->revid);
 	pci_read_config_dword(pdev, ADF_4XXX_FUSECTL4_OFFSET, &hw_data->fuses);
diff --git a/drivers/crypto/qat/qat_common/adf_accel_devices.h b/drivers/crypto/qat/qat_common/adf_accel_devices.h
index 7be933d6f0ff..134fc13c2210 100644
--- a/drivers/crypto/qat/qat_common/adf_accel_devices.h
+++ b/drivers/crypto/qat/qat_common/adf_accel_devices.h
@@ -21,6 +21,8 @@
 #define ADF_4XXXIOV_PCI_DEVICE_ID 0x4941
 #define ADF_401XX_PCI_DEVICE_ID 0x4942
 #define ADF_401XXIOV_PCI_DEVICE_ID 0x4943
+#define ADF_402XX_PCI_DEVICE_ID 0x4944
+#define ADF_402XXIOV_PCI_DEVICE_ID 0x4945
 #define ADF_DEVICE_FUSECTL_OFFSET 0x40
 #define ADF_DEVICE_LEGFUSE_OFFSET 0x4C
 #define ADF_DEVICE_FUSECTL_MASK 0x80000000
diff --git a/drivers/crypto/qat/qat_common/qat_hal.c b/drivers/crypto/qat/qat_common/qat_hal.c
index 7bba35280dac..cbb946a80076 100644
--- a/drivers/crypto/qat/qat_common/qat_hal.c
+++ b/drivers/crypto/qat/qat_common/qat_hal.c
@@ -696,6 +696,7 @@ static int qat_hal_chip_init(struct icp_qat_fw_loader_handle *handle,
 	switch (handle->pci_dev->device) {
 	case ADF_4XXX_PCI_DEVICE_ID:
 	case ADF_401XX_PCI_DEVICE_ID:
+	case ADF_402XX_PCI_DEVICE_ID:
 		handle->chip_info->mmp_sram_size = 0;
 		handle->chip_info->nn = false;
 		handle->chip_info->lm2lm3 = true;
diff --git a/drivers/crypto/qat/qat_common/qat_uclo.c b/drivers/crypto/qat/qat_common/qat_uclo.c
index b7f7869ef8b2..3ba8ca20b3d7 100644
--- a/drivers/crypto/qat/qat_common/qat_uclo.c
+++ b/drivers/crypto/qat/qat_common/qat_uclo.c
@@ -732,6 +732,7 @@ qat_uclo_get_dev_type(struct icp_qat_fw_loader_handle *handle)
 		return ICP_QAT_AC_C3XXX_DEV_TYPE;
 	case ADF_4XXX_PCI_DEVICE_ID:
 	case ADF_401XX_PCI_DEVICE_ID:
+	case ADF_402XX_PCI_DEVICE_ID:
 		return ICP_QAT_AC_4XXX_A_DEV_TYPE;
 	default:
 		pr_err("QAT: unsupported device 0x%x\n",
-- 
2.39.2

