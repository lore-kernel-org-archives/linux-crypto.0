Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BDDEC41537
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Aug 2021 20:22:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 518E760EB2
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Aug 2021 20:22:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237136AbhHLUWg (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 12 Aug 2021 16:22:36 -0400
Received: from mga03.intel.com ([134.134.136.65]:4154 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237165AbhHLUWf (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Aug 2021 16:22:35 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10074"; a="215474066"
X-IronPort-AV: E=Sophos;i="5.84,316,1620716400"; 
   d="scan'208";a="215474066"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2021 13:22:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,316,1620716400"; 
   d="scan'208";a="517608726"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.51])
  by FMSMGA003.fm.intel.com with ESMTP; 12 Aug 2021 13:22:08 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Marco Chiappero <marco.chiappero@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Fiona Trahe <fiona.trahe@intel.com>
Subject: [PATCH 17/20] crypto: qat - remove the unnecessary get_vintmsk_offset()
Date:   Thu, 12 Aug 2021 21:21:26 +0100
Message-Id: <20210812202129.18831-18-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210812202129.18831-1-giovanni.cabiddu@intel.com>
References: <20210812202129.18831-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Marco Chiappero <marco.chiappero@intel.com>

All QAT GEN2 devices share the same register offset for masking interrupts,
so they don't need any complex device specific infrastructure.

Remove this function in favor of a constant in order to simplify the code.
Also, future generations may require a more complex device specific
handling, making the current approach obsolete anyway.

Signed-off-by: Marco Chiappero <marco.chiappero@intel.com>
Co-developed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Fiona Trahe <fiona.trahe@intel.com>
---
 drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c           | 6 ------
 drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.h           | 1 -
 drivers/crypto/qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.c       | 6 ------
 drivers/crypto/qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.h       | 1 -
 drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.c             | 5 -----
 drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.h             | 1 -
 drivers/crypto/qat/qat_c62xvf/adf_c62xvf_hw_data.c         | 6 ------
 drivers/crypto/qat/qat_c62xvf/adf_c62xvf_hw_data.h         | 1 -
 drivers/crypto/qat/qat_common/adf_accel_devices.h          | 1 -
 drivers/crypto/qat/qat_common/adf_vf_isr.c                 | 4 ++--
 drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c     | 6 ------
 drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.h     | 1 -
 drivers/crypto/qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.c | 6 ------
 drivers/crypto/qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.h | 1 -
 14 files changed, 2 insertions(+), 44 deletions(-)

diff --git a/drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c b/drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c
index 569d4a9fd8cf..3027c01bc89e 100644
--- a/drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c
+++ b/drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c
@@ -111,11 +111,6 @@ static u32 get_pf2vf_offset(u32 i)
 	return ADF_C3XXX_PF2VF_OFFSET(i);
 }
 
-static u32 get_vintmsk_offset(u32 i)
-{
-	return ADF_C3XXX_VINTMSK_OFFSET(i);
-}
-
 static void adf_enable_error_correction(struct adf_accel_dev *accel_dev)
 {
 	struct adf_hw_device_data *hw_device = accel_dev->hw_device;
@@ -195,7 +190,6 @@ void adf_init_hw_data_c3xxx(struct adf_hw_device_data *hw_data)
 	hw_data->get_sram_bar_id = get_sram_bar_id;
 	hw_data->get_etr_bar_id = get_etr_bar_id;
 	hw_data->get_misc_bar_id = get_misc_bar_id;
-	hw_data->get_vintmsk_offset = get_vintmsk_offset;
 	hw_data->get_admin_info = adf_gen2_get_admin_info;
 	hw_data->get_arb_info = adf_gen2_get_arb_info;
 	hw_data->get_sku = get_sku;
diff --git a/drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.h b/drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.h
index fece8e38025a..86ee02a86789 100644
--- a/drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.h
+++ b/drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.h
@@ -29,7 +29,6 @@
 #define ADF_C3XXX_ERRSSMSH_EN BIT(3)
 
 #define ADF_C3XXX_PF2VF_OFFSET(i)	(0x3A000 + 0x280 + ((i) * 0x04))
-#define ADF_C3XXX_VINTMSK_OFFSET(i)	(0x3A000 + 0x200 + ((i) * 0x04))
 
 /* AE to function mapping */
 #define ADF_C3XXX_AE2FUNC_MAP_GRP_A_NUM_REGS 48
diff --git a/drivers/crypto/qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.c b/drivers/crypto/qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.c
index 3f840560d702..3e69b520e82f 100644
--- a/drivers/crypto/qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.c
+++ b/drivers/crypto/qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.c
@@ -52,11 +52,6 @@ static u32 get_pf2vf_offset(u32 i)
 	return ADF_C3XXXIOV_PF2VF_OFFSET;
 }
 
-static u32 get_vintmsk_offset(u32 i)
-{
-	return ADF_C3XXXIOV_VINTMSK_OFFSET;
-}
-
 static int adf_vf_int_noop(struct adf_accel_dev *accel_dev)
 {
 	return 0;
@@ -92,7 +87,6 @@ void adf_init_hw_data_c3xxxiov(struct adf_hw_device_data *hw_data)
 	hw_data->get_etr_bar_id = get_etr_bar_id;
 	hw_data->get_misc_bar_id = get_misc_bar_id;
 	hw_data->get_pf2vf_offset = get_pf2vf_offset;
-	hw_data->get_vintmsk_offset = get_vintmsk_offset;
 	hw_data->get_sku = get_sku;
 	hw_data->enable_ints = adf_vf_void_noop;
 	hw_data->enable_pfvf_comms = adf_enable_vf2pf_comms;
diff --git a/drivers/crypto/qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.h b/drivers/crypto/qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.h
index 7945a9cd1c60..f5de4ce66014 100644
--- a/drivers/crypto/qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.h
+++ b/drivers/crypto/qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.h
@@ -13,7 +13,6 @@
 #define ADF_C3XXXIOV_ETR_BAR 0
 #define ADF_C3XXXIOV_ETR_MAX_BANKS 1
 #define ADF_C3XXXIOV_PF2VF_OFFSET	0x200
-#define ADF_C3XXXIOV_VINTMSK_OFFSET	0x208
 
 void adf_init_hw_data_c3xxxiov(struct adf_hw_device_data *hw_data);
 void adf_clean_hw_data_c3xxxiov(struct adf_hw_device_data *hw_data);
diff --git a/drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.c b/drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.c
index 6660001d4297..b023c80873bb 100644
--- a/drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.c
+++ b/drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.c
@@ -112,10 +112,6 @@ static u32 get_pf2vf_offset(u32 i)
 {
 	return ADF_C62X_PF2VF_OFFSET(i);
 }
-static u32 get_vintmsk_offset(u32 i)
-{
-	return ADF_C62X_VINTMSK_OFFSET(i);
-}
 
 static void adf_enable_error_correction(struct adf_accel_dev *accel_dev)
 {
@@ -196,7 +192,6 @@ void adf_init_hw_data_c62x(struct adf_hw_device_data *hw_data)
 	hw_data->get_sram_bar_id = get_sram_bar_id;
 	hw_data->get_etr_bar_id = get_etr_bar_id;
 	hw_data->get_misc_bar_id = get_misc_bar_id;
-	hw_data->get_vintmsk_offset = get_vintmsk_offset;
 	hw_data->get_admin_info = adf_gen2_get_admin_info;
 	hw_data->get_arb_info = adf_gen2_get_arb_info;
 	hw_data->get_sku = get_sku;
diff --git a/drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.h b/drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.h
index 53d3cb577f5b..e6664bd20c91 100644
--- a/drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.h
+++ b/drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.h
@@ -30,7 +30,6 @@
 #define ADF_C62X_ERRSSMSH_EN BIT(3)
 
 #define ADF_C62X_PF2VF_OFFSET(i)	(0x3A000 + 0x280 + ((i) * 0x04))
-#define ADF_C62X_VINTMSK_OFFSET(i)	(0x3A000 + 0x200 + ((i) * 0x04))
 
 /* AE to function mapping */
 #define ADF_C62X_AE2FUNC_MAP_GRP_A_NUM_REGS 80
diff --git a/drivers/crypto/qat/qat_c62xvf/adf_c62xvf_hw_data.c b/drivers/crypto/qat/qat_c62xvf/adf_c62xvf_hw_data.c
index 67fd41662f20..3bee3e467363 100644
--- a/drivers/crypto/qat/qat_c62xvf/adf_c62xvf_hw_data.c
+++ b/drivers/crypto/qat/qat_c62xvf/adf_c62xvf_hw_data.c
@@ -52,11 +52,6 @@ static u32 get_pf2vf_offset(u32 i)
 	return ADF_C62XIOV_PF2VF_OFFSET;
 }
 
-static u32 get_vintmsk_offset(u32 i)
-{
-	return ADF_C62XIOV_VINTMSK_OFFSET;
-}
-
 static int adf_vf_int_noop(struct adf_accel_dev *accel_dev)
 {
 	return 0;
@@ -92,7 +87,6 @@ void adf_init_hw_data_c62xiov(struct adf_hw_device_data *hw_data)
 	hw_data->get_etr_bar_id = get_etr_bar_id;
 	hw_data->get_misc_bar_id = get_misc_bar_id;
 	hw_data->get_pf2vf_offset = get_pf2vf_offset;
-	hw_data->get_vintmsk_offset = get_vintmsk_offset;
 	hw_data->get_sku = get_sku;
 	hw_data->enable_ints = adf_vf_void_noop;
 	hw_data->enable_pfvf_comms = adf_enable_vf2pf_comms;
diff --git a/drivers/crypto/qat/qat_c62xvf/adf_c62xvf_hw_data.h b/drivers/crypto/qat/qat_c62xvf/adf_c62xvf_hw_data.h
index a6c04cf7a43c..794778c48678 100644
--- a/drivers/crypto/qat/qat_c62xvf/adf_c62xvf_hw_data.h
+++ b/drivers/crypto/qat/qat_c62xvf/adf_c62xvf_hw_data.h
@@ -13,7 +13,6 @@
 #define ADF_C62XIOV_ETR_BAR 0
 #define ADF_C62XIOV_ETR_MAX_BANKS 1
 #define ADF_C62XIOV_PF2VF_OFFSET	0x200
-#define ADF_C62XIOV_VINTMSK_OFFSET	0x208
 
 void adf_init_hw_data_c62xiov(struct adf_hw_device_data *hw_data);
 void adf_clean_hw_data_c62xiov(struct adf_hw_device_data *hw_data);
diff --git a/drivers/crypto/qat/qat_common/adf_accel_devices.h b/drivers/crypto/qat/qat_common/adf_accel_devices.h
index c00b16be8b0d..38c0af6d4e43 100644
--- a/drivers/crypto/qat/qat_common/adf_accel_devices.h
+++ b/drivers/crypto/qat/qat_common/adf_accel_devices.h
@@ -154,7 +154,6 @@ struct adf_hw_device_data {
 	u32 (*get_num_aes)(struct adf_hw_device_data *self);
 	u32 (*get_num_accels)(struct adf_hw_device_data *self);
 	u32 (*get_pf2vf_offset)(u32 i);
-	u32 (*get_vintmsk_offset)(u32 i);
 	void (*get_arb_info)(struct arb_info *arb_csrs_info);
 	void (*get_admin_info)(struct admin_info *admin_csrs_info);
 	enum dev_sku_info (*get_sku)(struct adf_hw_device_data *self);
diff --git a/drivers/crypto/qat/qat_common/adf_vf_isr.c b/drivers/crypto/qat/qat_common/adf_vf_isr.c
index aa44e8638fa8..078f33d583e8 100644
--- a/drivers/crypto/qat/qat_common/adf_vf_isr.c
+++ b/drivers/crypto/qat/qat_common/adf_vf_isr.c
@@ -36,7 +36,7 @@ void adf_enable_pf2vf_interrupts(struct adf_accel_dev *accel_dev)
 	void __iomem *pmisc_bar_addr =
 		pci_info->pci_bars[hw_data->get_misc_bar_id(hw_data)].virt_addr;
 
-	ADF_CSR_WR(pmisc_bar_addr, hw_data->get_vintmsk_offset(0), 0x0);
+	ADF_CSR_WR(pmisc_bar_addr, ADF_VINTMSK_OFFSET, 0x0);
 }
 
 void adf_disable_pf2vf_interrupts(struct adf_accel_dev *accel_dev)
@@ -46,7 +46,7 @@ void adf_disable_pf2vf_interrupts(struct adf_accel_dev *accel_dev)
 	void __iomem *pmisc_bar_addr =
 		pci_info->pci_bars[hw_data->get_misc_bar_id(hw_data)].virt_addr;
 
-	ADF_CSR_WR(pmisc_bar_addr, hw_data->get_vintmsk_offset(0), 0x2);
+	ADF_CSR_WR(pmisc_bar_addr, ADF_VINTMSK_OFFSET, 0x2);
 }
 
 static int adf_enable_msi(struct adf_accel_dev *accel_dev)
diff --git a/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c b/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
index 94fa65bac7e7..0a9ce365a544 100644
--- a/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
+++ b/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
@@ -131,11 +131,6 @@ static u32 get_pf2vf_offset(u32 i)
 	return ADF_DH895XCC_PF2VF_OFFSET(i);
 }
 
-static u32 get_vintmsk_offset(u32 i)
-{
-	return ADF_DH895XCC_VINTMSK_OFFSET(i);
-}
-
 static void adf_enable_error_correction(struct adf_accel_dev *accel_dev)
 {
 	struct adf_hw_device_data *hw_device = accel_dev->hw_device;
@@ -215,7 +210,6 @@ void adf_init_hw_data_dh895xcc(struct adf_hw_device_data *hw_data)
 	hw_data->get_num_aes = get_num_aes;
 	hw_data->get_etr_bar_id = get_etr_bar_id;
 	hw_data->get_misc_bar_id = get_misc_bar_id;
-	hw_data->get_vintmsk_offset = get_vintmsk_offset;
 	hw_data->get_admin_info = adf_gen2_get_admin_info;
 	hw_data->get_arb_info = adf_gen2_get_arb_info;
 	hw_data->get_sram_bar_id = get_sram_bar_id;
diff --git a/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.h b/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.h
index 4d613923d155..f99319cd4543 100644
--- a/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.h
+++ b/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.h
@@ -35,7 +35,6 @@
 #define ADF_DH895XCC_ERRSSMSH_EN BIT(3)
 
 #define ADF_DH895XCC_PF2VF_OFFSET(i)	(0x3A000 + 0x280 + ((i) * 0x04))
-#define ADF_DH895XCC_VINTMSK_OFFSET(i)	(0x3A000 + 0x200 + ((i) * 0x04))
 
 /* AE to function mapping */
 #define ADF_DH895XCC_AE2FUNC_MAP_GRP_A_NUM_REGS 96
diff --git a/drivers/crypto/qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.c b/drivers/crypto/qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.c
index 5f4e264016c9..7c6ed6bc8abf 100644
--- a/drivers/crypto/qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.c
+++ b/drivers/crypto/qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.c
@@ -52,11 +52,6 @@ static u32 get_pf2vf_offset(u32 i)
 	return ADF_DH895XCCIOV_PF2VF_OFFSET;
 }
 
-static u32 get_vintmsk_offset(u32 i)
-{
-	return ADF_DH895XCCIOV_VINTMSK_OFFSET;
-}
-
 static int adf_vf_int_noop(struct adf_accel_dev *accel_dev)
 {
 	return 0;
@@ -92,7 +87,6 @@ void adf_init_hw_data_dh895xcciov(struct adf_hw_device_data *hw_data)
 	hw_data->get_etr_bar_id = get_etr_bar_id;
 	hw_data->get_misc_bar_id = get_misc_bar_id;
 	hw_data->get_pf2vf_offset = get_pf2vf_offset;
-	hw_data->get_vintmsk_offset = get_vintmsk_offset;
 	hw_data->get_sku = get_sku;
 	hw_data->enable_ints = adf_vf_void_noop;
 	hw_data->enable_pfvf_comms = adf_enable_vf2pf_comms;
diff --git a/drivers/crypto/qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.h b/drivers/crypto/qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.h
index 2bfcc67f8f39..306ebb71a408 100644
--- a/drivers/crypto/qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.h
+++ b/drivers/crypto/qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.h
@@ -13,7 +13,6 @@
 #define ADF_DH895XCCIOV_ETR_BAR 0
 #define ADF_DH895XCCIOV_ETR_MAX_BANKS 1
 #define ADF_DH895XCCIOV_PF2VF_OFFSET	0x200
-#define ADF_DH895XCCIOV_VINTMSK_OFFSET	0x208
 
 void adf_init_hw_data_dh895xcciov(struct adf_hw_device_data *hw_data);
 void adf_clean_hw_data_dh895xcciov(struct adf_hw_device_data *hw_data);
-- 
2.31.1

