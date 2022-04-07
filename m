Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDC66C433F5
	for <linux-crypto@archiver.kernel.org>; Thu,  7 Apr 2022 16:51:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345845AbiDGQxN (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 7 Apr 2022 12:53:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244193AbiDGQxK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 7 Apr 2022 12:53:10 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9346FDEB3
        for <linux-crypto@vger.kernel.org>; Thu,  7 Apr 2022 09:51:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649350269; x=1680886269;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jZTk0qmz2BwKe1dxQw9KLceLZ4IYx9QV2xovFXNFxqw=;
  b=gkvY9K6QtJu/lZhQwb/m7vQLs7AhrJC0nSGLNLOvF/gOkCuEOUfu3O5G
   PKme6e03/sA98N/CM6Hjfgq5es4rCkrmF5QWRBSMuRyhkZOv6G3kpG2JF
   l5nfc/O+GIOtLbwrxhU32rIa71IEzA6EOWZh6dGWb5jrmITJNeh9riC1d
   n3Dxa2yhYV4wNcAKcKlWa5cAY9z+yPKCVOgkG9xZcx+jjWe+tYIrhWoJ4
   8vzYCOPgxsDyyobbv06ag10rBASMR3R7qDC5fDfwkvlwd+mBR2gEyD+8U
   ZGhGRu2ekdleocv5XAlhOLt1ipVUFmh90cevikGoixpV49QWN9KWR5y8X
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10310"; a="241312028"
X-IronPort-AV: E=Sophos;i="5.90,242,1643702400"; 
   d="scan'208";a="241312028"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2022 09:51:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,242,1643702400"; 
   d="scan'208";a="652898298"
Received: from silpixa00393544.ir.intel.com ([10.237.213.118])
  by fmsmga002.fm.intel.com with ESMTP; 07 Apr 2022 09:51:06 -0700
From:   Marco Chiappero <marco.chiappero@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        giovanni.cabiddu@intel.com,
        Marco Chiappero <marco.chiappero@intel.com>
Subject: [PATCH v2 03/16] crypto: qat - fix ETR sources enabled by default on GEN2 devices
Date:   Thu,  7 Apr 2022 17:54:42 +0100
Message-Id: <20220407165455.256777-4-marco.chiappero@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220407165455.256777-1-marco.chiappero@intel.com>
References: <20220407165455.256777-1-marco.chiappero@intel.com>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

When the driver starts the device, it enables all the necessary
interrupts. However interrupts associated to host rings are enabled by
default on all GEN2 devices (except for dh895x) even when SR-IOV is
active. Fix this behaviour by checking if data structures associated to
VFs have been allocated to determine whether to enable such interrupts
or not.

Since the logic for the fix is the same across GEN2 devices, replace
the function to be fixed (adf_enable_ints()) with a single one
(adf_gen2_enable_ints()) in the common GEN2 code in adf_gen2_hw_data.c.
Likewise, remove the unnecessary duplication of defines too.

Signed-off-by: Marco Chiappero <marco.chiappero@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c | 15 +--------------
 drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.h |  4 ----
 drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.c   | 15 +--------------
 drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.h   |  4 ----
 drivers/crypto/qat/qat_common/adf_gen2_hw_data.c | 13 +++++++++++++
 drivers/crypto/qat/qat_common/adf_gen2_hw_data.h |  6 ++++++
 .../qat/qat_dh895xcc/adf_dh895xcc_hw_data.c      | 16 +---------------
 .../qat/qat_dh895xcc/adf_dh895xcc_hw_data.h      |  4 ----
 8 files changed, 22 insertions(+), 55 deletions(-)

diff --git a/drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c b/drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c
index b941fe3713ff..50d5afa26a9b 100644
--- a/drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c
+++ b/drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c
@@ -78,19 +78,6 @@ static const u32 *adf_get_arbiter_mapping(void)
 	return thrd_to_arb_map;
 }
 
-static void adf_enable_ints(struct adf_accel_dev *accel_dev)
-{
-	void __iomem *addr;
-
-	addr = (&GET_BARS(accel_dev)[ADF_C3XXX_PMISC_BAR])->virt_addr;
-
-	/* Enable bundle and misc interrupts */
-	ADF_CSR_WR(addr, ADF_C3XXX_SMIAPF0_MASK_OFFSET,
-		   ADF_C3XXX_SMIA0_MASK);
-	ADF_CSR_WR(addr, ADF_C3XXX_SMIAPF1_MASK_OFFSET,
-		   ADF_C3XXX_SMIA1_MASK);
-}
-
 static void configure_iov_threads(struct adf_accel_dev *accel_dev, bool enable)
 {
 	adf_gen2_cfg_iov_thds(accel_dev, enable,
@@ -133,7 +120,7 @@ void adf_init_hw_data_c3xxx(struct adf_hw_device_data *hw_data)
 	hw_data->init_arb = adf_init_arb;
 	hw_data->exit_arb = adf_exit_arb;
 	hw_data->get_arb_mapping = adf_get_arbiter_mapping;
-	hw_data->enable_ints = adf_enable_ints;
+	hw_data->enable_ints = adf_gen2_enable_ints;
 	hw_data->reset_device = adf_reset_flr;
 	hw_data->set_ssm_wdtimer = adf_gen2_set_ssm_wdtimer;
 	hw_data->disable_iov = adf_disable_sriov;
diff --git a/drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.h b/drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.h
index 1b86f828725c..336a06f11dbd 100644
--- a/drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.h
+++ b/drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.h
@@ -13,10 +13,6 @@
 #define ADF_C3XXX_ACCELERATORS_MASK 0x7
 #define ADF_C3XXX_ACCELENGINES_MASK 0x3F
 #define ADF_C3XXX_ETR_MAX_BANKS 16
-#define ADF_C3XXX_SMIAPF0_MASK_OFFSET (0x3A000 + 0x28)
-#define ADF_C3XXX_SMIAPF1_MASK_OFFSET (0x3A000 + 0x30)
-#define ADF_C3XXX_SMIA0_MASK 0xFFFF
-#define ADF_C3XXX_SMIA1_MASK 0x1
 #define ADF_C3XXX_SOFTSTRAP_CSR_OFFSET 0x2EC
 
 /* AE to function mapping */
diff --git a/drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.c b/drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.c
index b1eac2f81faa..c00386fe6587 100644
--- a/drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.c
+++ b/drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.c
@@ -80,19 +80,6 @@ static const u32 *adf_get_arbiter_mapping(void)
 	return thrd_to_arb_map;
 }
 
-static void adf_enable_ints(struct adf_accel_dev *accel_dev)
-{
-	void __iomem *addr;
-
-	addr = (&GET_BARS(accel_dev)[ADF_C62X_PMISC_BAR])->virt_addr;
-
-	/* Enable bundle and misc interrupts */
-	ADF_CSR_WR(addr, ADF_C62X_SMIAPF0_MASK_OFFSET,
-		   ADF_C62X_SMIA0_MASK);
-	ADF_CSR_WR(addr, ADF_C62X_SMIAPF1_MASK_OFFSET,
-		   ADF_C62X_SMIA1_MASK);
-}
-
 static void configure_iov_threads(struct adf_accel_dev *accel_dev, bool enable)
 {
 	adf_gen2_cfg_iov_thds(accel_dev, enable,
@@ -135,7 +122,7 @@ void adf_init_hw_data_c62x(struct adf_hw_device_data *hw_data)
 	hw_data->init_arb = adf_init_arb;
 	hw_data->exit_arb = adf_exit_arb;
 	hw_data->get_arb_mapping = adf_get_arbiter_mapping;
-	hw_data->enable_ints = adf_enable_ints;
+	hw_data->enable_ints = adf_gen2_enable_ints;
 	hw_data->reset_device = adf_reset_flr;
 	hw_data->set_ssm_wdtimer = adf_gen2_set_ssm_wdtimer;
 	hw_data->disable_iov = adf_disable_sriov;
diff --git a/drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.h b/drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.h
index 68c3436bd3aa..008c0a3a9769 100644
--- a/drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.h
+++ b/drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.h
@@ -13,10 +13,6 @@
 #define ADF_C62X_ACCELERATORS_MASK 0x1F
 #define ADF_C62X_ACCELENGINES_MASK 0x3FF
 #define ADF_C62X_ETR_MAX_BANKS 16
-#define ADF_C62X_SMIAPF0_MASK_OFFSET (0x3A000 + 0x28)
-#define ADF_C62X_SMIAPF1_MASK_OFFSET (0x3A000 + 0x30)
-#define ADF_C62X_SMIA0_MASK 0xFFFF
-#define ADF_C62X_SMIA1_MASK 0x1
 #define ADF_C62X_SOFTSTRAP_CSR_OFFSET 0x2EC
 
 /* AE to function mapping */
diff --git a/drivers/crypto/qat/qat_common/adf_gen2_hw_data.c b/drivers/crypto/qat/qat_common/adf_gen2_hw_data.c
index 57035b7dd4b2..d1884547b5a1 100644
--- a/drivers/crypto/qat/qat_common/adf_gen2_hw_data.c
+++ b/drivers/crypto/qat/qat_common/adf_gen2_hw_data.c
@@ -98,6 +98,19 @@ void adf_gen2_get_arb_info(struct arb_info *arb_info)
 }
 EXPORT_SYMBOL_GPL(adf_gen2_get_arb_info);
 
+void adf_gen2_enable_ints(struct adf_accel_dev *accel_dev)
+{
+	void __iomem *addr = adf_get_pmisc_base(accel_dev);
+	u32 val;
+
+	val = accel_dev->pf.vf_info ? 0 : BIT_ULL(GET_MAX_BANKS(accel_dev)) - 1;
+
+	/* Enable bundle and misc interrupts */
+	ADF_CSR_WR(addr, ADF_GEN2_SMIAPF0_MASK_OFFSET, val);
+	ADF_CSR_WR(addr, ADF_GEN2_SMIAPF1_MASK_OFFSET, ADF_GEN2_SMIA1_MASK);
+}
+EXPORT_SYMBOL_GPL(adf_gen2_enable_ints);
+
 static u64 build_csr_ring_base_addr(dma_addr_t addr, u32 size)
 {
 	return BUILD_RING_BASE_ADDR(addr, size);
diff --git a/drivers/crypto/qat/qat_common/adf_gen2_hw_data.h b/drivers/crypto/qat/qat_common/adf_gen2_hw_data.h
index f2e0451b11c0..e4bc07529be4 100644
--- a/drivers/crypto/qat/qat_common/adf_gen2_hw_data.h
+++ b/drivers/crypto/qat/qat_common/adf_gen2_hw_data.h
@@ -145,6 +145,11 @@ do { \
 #define ADF_GEN2_CERRSSMSH(i)		((i) * 0x4000 + 0x10)
 #define ADF_GEN2_ERRSSMSH_EN		BIT(3)
 
+/* Interrupts */
+#define ADF_GEN2_SMIAPF0_MASK_OFFSET    (0x3A000 + 0x28)
+#define ADF_GEN2_SMIAPF1_MASK_OFFSET    (0x3A000 + 0x30)
+#define ADF_GEN2_SMIA1_MASK             0x1
+
 u32 adf_gen2_get_num_accels(struct adf_hw_device_data *self);
 u32 adf_gen2_get_num_aes(struct adf_hw_device_data *self);
 void adf_gen2_enable_error_correction(struct adf_accel_dev *accel_dev);
@@ -153,6 +158,7 @@ void adf_gen2_cfg_iov_thds(struct adf_accel_dev *accel_dev, bool enable,
 void adf_gen2_init_hw_csr_ops(struct adf_hw_csr_ops *csr_ops);
 void adf_gen2_get_admin_info(struct admin_info *admin_csrs_info);
 void adf_gen2_get_arb_info(struct arb_info *arb_info);
+void adf_gen2_enable_ints(struct adf_accel_dev *accel_dev);
 u32 adf_gen2_get_accel_cap(struct adf_accel_dev *accel_dev);
 void adf_gen2_set_ssm_wdtimer(struct adf_accel_dev *accel_dev);
 
diff --git a/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c b/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
index 61d5467e0d92..7375436ac1b8 100644
--- a/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
+++ b/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
@@ -107,20 +107,6 @@ static const u32 *adf_get_arbiter_mapping(void)
 	return thrd_to_arb_map;
 }
 
-static void adf_enable_ints(struct adf_accel_dev *accel_dev)
-{
-	void __iomem *addr;
-
-	addr = (&GET_BARS(accel_dev)[ADF_DH895XCC_PMISC_BAR])->virt_addr;
-
-	/* Enable bundle and misc interrupts */
-	ADF_CSR_WR(addr, ADF_DH895XCC_SMIAPF0_MASK_OFFSET,
-		   accel_dev->pf.vf_info ? 0 :
-			BIT_ULL(GET_MAX_BANKS(accel_dev)) - 1);
-	ADF_CSR_WR(addr, ADF_DH895XCC_SMIAPF1_MASK_OFFSET,
-		   ADF_DH895XCC_SMIA1_MASK);
-}
-
 static u32 get_vf2pf_sources(void __iomem *pmisc_bar)
 {
 	u32 errsou3, errmsk3, errsou5, errmsk5, vf_int_mask;
@@ -222,7 +208,7 @@ void adf_init_hw_data_dh895xcc(struct adf_hw_device_data *hw_data)
 	hw_data->init_arb = adf_init_arb;
 	hw_data->exit_arb = adf_exit_arb;
 	hw_data->get_arb_mapping = adf_get_arbiter_mapping;
-	hw_data->enable_ints = adf_enable_ints;
+	hw_data->enable_ints = adf_gen2_enable_ints;
 	hw_data->reset_device = adf_reset_sbr;
 	hw_data->disable_iov = adf_disable_sriov;
 
diff --git a/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.h b/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.h
index aa17272a1507..7b674bbe4192 100644
--- a/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.h
+++ b/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.h
@@ -19,10 +19,6 @@
 #define ADF_DH895XCC_ACCELERATORS_MASK 0x3F
 #define ADF_DH895XCC_ACCELENGINES_MASK 0xFFF
 #define ADF_DH895XCC_ETR_MAX_BANKS 32
-#define ADF_DH895XCC_SMIAPF0_MASK_OFFSET (0x3A000 + 0x28)
-#define ADF_DH895XCC_SMIAPF1_MASK_OFFSET (0x3A000 + 0x30)
-#define ADF_DH895XCC_SMIA0_MASK 0xFFFFFFFF
-#define ADF_DH895XCC_SMIA1_MASK 0x1
 
 /* Masks for VF2PF interrupts */
 #define ADF_DH895XCC_ERR_REG_VF2PF_L(vf_src)	(((vf_src) & 0x01FFFE00) >> 9)
-- 
2.34.1

