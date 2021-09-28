Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D33BC433EF
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Sep 2021 11:45:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 342256113E
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Sep 2021 11:45:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231202AbhI1Lqi (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 28 Sep 2021 07:46:38 -0400
Received: from mga07.intel.com ([134.134.136.100]:37909 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240390AbhI1Lqi (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Sep 2021 07:46:38 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10120"; a="288339055"
X-IronPort-AV: E=Sophos;i="5.85,329,1624345200"; 
   d="scan'208";a="288339055"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2021 04:44:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,329,1624345200"; 
   d="scan'208";a="562224711"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.51])
  by fmsmga002.fm.intel.com with ESMTP; 28 Sep 2021 04:44:56 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Marco Chiappero <marco.chiappero@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH 05/12] crypto: qat - remove duplicated logic across GEN2 drivers
Date:   Tue, 28 Sep 2021 12:44:33 +0100
Message-Id: <20210928114440.355368-6-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210928114440.355368-1-giovanni.cabiddu@intel.com>
References: <20210928114440.355368-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Marco Chiappero <marco.chiappero@intel.com>

QAT GEN2 devices share most of the behavior which means a number of
device specific functions can be shared too and some differences
abstracted away by simple parameters.

The functions adf_enable_error_correction(), get_num_accels(),
get_num_aes() and get_pf2vf_offset() for c3xxx, c62x and dh895xx have
been reworked and moved to the GEN2 file, adf_gen2_hw_data.c.
The definitions of tx_rx_gap and tx_rings_mask have been moved to
adf_gen2_hw_data.h.

Signed-off-by: Marco Chiappero <marco.chiappero@intel.com>
Co-developed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 .../crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c  | 79 ++-----------------
 .../crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.h  | 13 +--
 .../crypto/qat/qat_c62x/adf_c62x_hw_data.c    | 77 ++----------------
 .../crypto/qat/qat_c62x/adf_c62x_hw_data.h    | 12 ---
 .../crypto/qat/qat_common/adf_gen2_hw_data.c  | 70 ++++++++++++++++
 .../crypto/qat/qat_common/adf_gen2_hw_data.h  | 15 ++++
 .../qat/qat_dh895xcc/adf_dh895xcc_hw_data.c   | 75 ++----------------
 .../qat/qat_dh895xcc/adf_dh895xcc_hw_data.h   | 11 ---
 8 files changed, 107 insertions(+), 245 deletions(-)

diff --git a/drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c b/drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c
index b9bd52eaa184..6a39d2e7f4c0 100644
--- a/drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c
+++ b/drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c
@@ -48,34 +48,6 @@ static u32 get_ae_mask(struct adf_hw_device_data *self)
 	return ~(fuses | straps) & ADF_C3XXX_ACCELENGINES_MASK;
 }
 
-static u32 get_num_accels(struct adf_hw_device_data *self)
-{
-	u32 i, ctr = 0;
-
-	if (!self || !self->accel_mask)
-		return 0;
-
-	for (i = 0; i < ADF_C3XXX_MAX_ACCELERATORS; i++) {
-		if (self->accel_mask & (1 << i))
-			ctr++;
-	}
-	return ctr;
-}
-
-static u32 get_num_aes(struct adf_hw_device_data *self)
-{
-	u32 i, ctr = 0;
-
-	if (!self || !self->ae_mask)
-		return 0;
-
-	for (i = 0; i < ADF_C3XXX_MAX_ACCELENGINES; i++) {
-		if (self->ae_mask & (1 << i))
-			ctr++;
-	}
-	return ctr;
-}
-
 static u32 get_misc_bar_id(struct adf_hw_device_data *self)
 {
 	return ADF_C3XXX_PMISC_BAR;
@@ -88,12 +60,12 @@ static u32 get_etr_bar_id(struct adf_hw_device_data *self)
 
 static u32 get_sram_bar_id(struct adf_hw_device_data *self)
 {
-	return 0;
+	return ADF_C3XXX_SRAM_BAR;
 }
 
 static enum dev_sku_info get_sku(struct adf_hw_device_data *self)
 {
-	int aes = get_num_aes(self);
+	int aes = self->get_num_aes(self);
 
 	if (aes == 6)
 		return DEV_SKU_4;
@@ -106,41 +78,6 @@ static const u32 *adf_get_arbiter_mapping(void)
 	return thrd_to_arb_map;
 }
 
-static u32 get_pf2vf_offset(u32 i)
-{
-	return ADF_C3XXX_PF2VF_OFFSET(i);
-}
-
-static void adf_enable_error_correction(struct adf_accel_dev *accel_dev)
-{
-	struct adf_hw_device_data *hw_device = accel_dev->hw_device;
-	struct adf_bar *misc_bar = &GET_BARS(accel_dev)[ADF_C3XXX_PMISC_BAR];
-	unsigned long accel_mask = hw_device->accel_mask;
-	unsigned long ae_mask = hw_device->ae_mask;
-	void __iomem *csr = misc_bar->virt_addr;
-	unsigned int val, i;
-
-	/* Enable Accel Engine error detection & correction */
-	for_each_set_bit(i, &ae_mask, GET_MAX_ACCELENGINES(accel_dev)) {
-		val = ADF_CSR_RD(csr, ADF_C3XXX_AE_CTX_ENABLES(i));
-		val |= ADF_C3XXX_ENABLE_AE_ECC_ERR;
-		ADF_CSR_WR(csr, ADF_C3XXX_AE_CTX_ENABLES(i), val);
-		val = ADF_CSR_RD(csr, ADF_C3XXX_AE_MISC_CONTROL(i));
-		val |= ADF_C3XXX_ENABLE_AE_ECC_PARITY_CORR;
-		ADF_CSR_WR(csr, ADF_C3XXX_AE_MISC_CONTROL(i), val);
-	}
-
-	/* Enable shared memory error detection & correction */
-	for_each_set_bit(i, &accel_mask, ADF_C3XXX_MAX_ACCELERATORS) {
-		val = ADF_CSR_RD(csr, ADF_C3XXX_UERRSSMSH(i));
-		val |= ADF_C3XXX_ERRSSMSH_EN;
-		ADF_CSR_WR(csr, ADF_C3XXX_UERRSSMSH(i), val);
-		val = ADF_CSR_RD(csr, ADF_C3XXX_CERRSSMSH(i));
-		val |= ADF_C3XXX_ERRSSMSH_EN;
-		ADF_CSR_WR(csr, ADF_C3XXX_CERRSSMSH(i), val);
-	}
-}
-
 static void adf_enable_ints(struct adf_accel_dev *accel_dev)
 {
 	void __iomem *addr;
@@ -177,16 +114,16 @@ void adf_init_hw_data_c3xxx(struct adf_hw_device_data *hw_data)
 	hw_data->num_accel = ADF_C3XXX_MAX_ACCELERATORS;
 	hw_data->num_logical_accel = 1;
 	hw_data->num_engines = ADF_C3XXX_MAX_ACCELENGINES;
-	hw_data->tx_rx_gap = ADF_C3XXX_RX_RINGS_OFFSET;
-	hw_data->tx_rings_mask = ADF_C3XXX_TX_RINGS_MASK;
+	hw_data->tx_rx_gap = ADF_GEN2_RX_RINGS_OFFSET;
+	hw_data->tx_rings_mask = ADF_GEN2_TX_RINGS_MASK;
 	hw_data->alloc_irq = adf_isr_resource_alloc;
 	hw_data->free_irq = adf_isr_resource_free;
-	hw_data->enable_error_correction = adf_enable_error_correction;
+	hw_data->enable_error_correction = adf_gen2_enable_error_correction;
 	hw_data->get_accel_mask = get_accel_mask;
 	hw_data->get_ae_mask = get_ae_mask;
 	hw_data->get_accel_cap = adf_gen2_get_accel_cap;
-	hw_data->get_num_accels = get_num_accels;
-	hw_data->get_num_aes = get_num_aes;
+	hw_data->get_num_accels = adf_gen2_get_num_accels;
+	hw_data->get_num_aes = adf_gen2_get_num_aes;
 	hw_data->get_sram_bar_id = get_sram_bar_id;
 	hw_data->get_etr_bar_id = get_etr_bar_id;
 	hw_data->get_misc_bar_id = get_misc_bar_id;
@@ -205,7 +142,7 @@ void adf_init_hw_data_c3xxx(struct adf_hw_device_data *hw_data)
 	hw_data->enable_ints = adf_enable_ints;
 	hw_data->reset_device = adf_reset_flr;
 	hw_data->set_ssm_wdtimer = adf_gen2_set_ssm_wdtimer;
-	hw_data->get_pf2vf_offset = get_pf2vf_offset;
+	hw_data->get_pf2vf_offset = adf_gen2_get_pf2vf_offset;
 	hw_data->get_vf2pf_sources = adf_gen2_get_vf2pf_sources;
 	hw_data->enable_vf2pf_interrupts = adf_gen2_enable_vf2pf_interrupts;
 	hw_data->disable_vf2pf_interrupts = adf_gen2_disable_vf2pf_interrupts;
diff --git a/drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.h b/drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.h
index 86ee02a86789..1b86f828725c 100644
--- a/drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.h
+++ b/drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.h
@@ -6,8 +6,7 @@
 /* PCIe configuration space */
 #define ADF_C3XXX_PMISC_BAR 0
 #define ADF_C3XXX_ETR_BAR 1
-#define ADF_C3XXX_RX_RINGS_OFFSET 8
-#define ADF_C3XXX_TX_RINGS_MASK 0xFF
+#define ADF_C3XXX_SRAM_BAR 0
 #define ADF_C3XXX_MAX_ACCELERATORS 3
 #define ADF_C3XXX_MAX_ACCELENGINES 6
 #define ADF_C3XXX_ACCELERATORS_REG_OFFSET 16
@@ -19,16 +18,6 @@
 #define ADF_C3XXX_SMIA0_MASK 0xFFFF
 #define ADF_C3XXX_SMIA1_MASK 0x1
 #define ADF_C3XXX_SOFTSTRAP_CSR_OFFSET 0x2EC
-/* Error detection and correction */
-#define ADF_C3XXX_AE_CTX_ENABLES(i) (i * 0x1000 + 0x20818)
-#define ADF_C3XXX_AE_MISC_CONTROL(i) (i * 0x1000 + 0x20960)
-#define ADF_C3XXX_ENABLE_AE_ECC_ERR BIT(28)
-#define ADF_C3XXX_ENABLE_AE_ECC_PARITY_CORR (BIT(24) | BIT(12))
-#define ADF_C3XXX_UERRSSMSH(i) (i * 0x4000 + 0x18)
-#define ADF_C3XXX_CERRSSMSH(i) (i * 0x4000 + 0x10)
-#define ADF_C3XXX_ERRSSMSH_EN BIT(3)
-
-#define ADF_C3XXX_PF2VF_OFFSET(i)	(0x3A000 + 0x280 + ((i) * 0x04))
 
 /* AE to function mapping */
 #define ADF_C3XXX_AE2FUNC_MAP_GRP_A_NUM_REGS 48
diff --git a/drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.c b/drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.c
index f28dae0982bc..e259ca38a653 100644
--- a/drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.c
+++ b/drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.c
@@ -48,34 +48,6 @@ static u32 get_ae_mask(struct adf_hw_device_data *self)
 	return ~(fuses | straps) & ADF_C62X_ACCELENGINES_MASK;
 }
 
-static u32 get_num_accels(struct adf_hw_device_data *self)
-{
-	u32 i, ctr = 0;
-
-	if (!self || !self->accel_mask)
-		return 0;
-
-	for (i = 0; i < ADF_C62X_MAX_ACCELERATORS; i++) {
-		if (self->accel_mask & (1 << i))
-			ctr++;
-	}
-	return ctr;
-}
-
-static u32 get_num_aes(struct adf_hw_device_data *self)
-{
-	u32 i, ctr = 0;
-
-	if (!self || !self->ae_mask)
-		return 0;
-
-	for (i = 0; i < ADF_C62X_MAX_ACCELENGINES; i++) {
-		if (self->ae_mask & (1 << i))
-			ctr++;
-	}
-	return ctr;
-}
-
 static u32 get_misc_bar_id(struct adf_hw_device_data *self)
 {
 	return ADF_C62X_PMISC_BAR;
@@ -93,7 +65,7 @@ static u32 get_sram_bar_id(struct adf_hw_device_data *self)
 
 static enum dev_sku_info get_sku(struct adf_hw_device_data *self)
 {
-	int aes = get_num_aes(self);
+	int aes = self->get_num_aes(self);
 
 	if (aes == 8)
 		return DEV_SKU_2;
@@ -108,41 +80,6 @@ static const u32 *adf_get_arbiter_mapping(void)
 	return thrd_to_arb_map;
 }
 
-static u32 get_pf2vf_offset(u32 i)
-{
-	return ADF_C62X_PF2VF_OFFSET(i);
-}
-
-static void adf_enable_error_correction(struct adf_accel_dev *accel_dev)
-{
-	struct adf_hw_device_data *hw_device = accel_dev->hw_device;
-	struct adf_bar *misc_bar = &GET_BARS(accel_dev)[ADF_C62X_PMISC_BAR];
-	unsigned long accel_mask = hw_device->accel_mask;
-	unsigned long ae_mask = hw_device->ae_mask;
-	void __iomem *csr = misc_bar->virt_addr;
-	unsigned int val, i;
-
-	/* Enable Accel Engine error detection & correction */
-	for_each_set_bit(i, &ae_mask, GET_MAX_ACCELENGINES(accel_dev)) {
-		val = ADF_CSR_RD(csr, ADF_C62X_AE_CTX_ENABLES(i));
-		val |= ADF_C62X_ENABLE_AE_ECC_ERR;
-		ADF_CSR_WR(csr, ADF_C62X_AE_CTX_ENABLES(i), val);
-		val = ADF_CSR_RD(csr, ADF_C62X_AE_MISC_CONTROL(i));
-		val |= ADF_C62X_ENABLE_AE_ECC_PARITY_CORR;
-		ADF_CSR_WR(csr, ADF_C62X_AE_MISC_CONTROL(i), val);
-	}
-
-	/* Enable shared memory error detection & correction */
-	for_each_set_bit(i, &accel_mask, ADF_C62X_MAX_ACCELERATORS) {
-		val = ADF_CSR_RD(csr, ADF_C62X_UERRSSMSH(i));
-		val |= ADF_C62X_ERRSSMSH_EN;
-		ADF_CSR_WR(csr, ADF_C62X_UERRSSMSH(i), val);
-		val = ADF_CSR_RD(csr, ADF_C62X_CERRSSMSH(i));
-		val |= ADF_C62X_ERRSSMSH_EN;
-		ADF_CSR_WR(csr, ADF_C62X_CERRSSMSH(i), val);
-	}
-}
-
 static void adf_enable_ints(struct adf_accel_dev *accel_dev)
 {
 	void __iomem *addr;
@@ -179,16 +116,16 @@ void adf_init_hw_data_c62x(struct adf_hw_device_data *hw_data)
 	hw_data->num_accel = ADF_C62X_MAX_ACCELERATORS;
 	hw_data->num_logical_accel = 1;
 	hw_data->num_engines = ADF_C62X_MAX_ACCELENGINES;
-	hw_data->tx_rx_gap = ADF_C62X_RX_RINGS_OFFSET;
-	hw_data->tx_rings_mask = ADF_C62X_TX_RINGS_MASK;
+	hw_data->tx_rx_gap = ADF_GEN2_RX_RINGS_OFFSET;
+	hw_data->tx_rings_mask = ADF_GEN2_TX_RINGS_MASK;
 	hw_data->alloc_irq = adf_isr_resource_alloc;
 	hw_data->free_irq = adf_isr_resource_free;
-	hw_data->enable_error_correction = adf_enable_error_correction;
+	hw_data->enable_error_correction = adf_gen2_enable_error_correction;
 	hw_data->get_accel_mask = get_accel_mask;
 	hw_data->get_ae_mask = get_ae_mask;
 	hw_data->get_accel_cap = adf_gen2_get_accel_cap;
-	hw_data->get_num_accels = get_num_accels;
-	hw_data->get_num_aes = get_num_aes;
+	hw_data->get_num_accels = adf_gen2_get_num_accels;
+	hw_data->get_num_aes = adf_gen2_get_num_aes;
 	hw_data->get_sram_bar_id = get_sram_bar_id;
 	hw_data->get_etr_bar_id = get_etr_bar_id;
 	hw_data->get_misc_bar_id = get_misc_bar_id;
@@ -207,7 +144,7 @@ void adf_init_hw_data_c62x(struct adf_hw_device_data *hw_data)
 	hw_data->enable_ints = adf_enable_ints;
 	hw_data->reset_device = adf_reset_flr;
 	hw_data->set_ssm_wdtimer = adf_gen2_set_ssm_wdtimer;
-	hw_data->get_pf2vf_offset = get_pf2vf_offset;
+	hw_data->get_pf2vf_offset = adf_gen2_get_pf2vf_offset;
 	hw_data->get_vf2pf_sources = adf_gen2_get_vf2pf_sources;
 	hw_data->enable_vf2pf_interrupts = adf_gen2_enable_vf2pf_interrupts;
 	hw_data->disable_vf2pf_interrupts = adf_gen2_disable_vf2pf_interrupts;
diff --git a/drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.h b/drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.h
index e6664bd20c91..68c3436bd3aa 100644
--- a/drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.h
+++ b/drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.h
@@ -7,8 +7,6 @@
 #define ADF_C62X_SRAM_BAR 0
 #define ADF_C62X_PMISC_BAR 1
 #define ADF_C62X_ETR_BAR 2
-#define ADF_C62X_RX_RINGS_OFFSET 8
-#define ADF_C62X_TX_RINGS_MASK 0xFF
 #define ADF_C62X_MAX_ACCELERATORS 5
 #define ADF_C62X_MAX_ACCELENGINES 10
 #define ADF_C62X_ACCELERATORS_REG_OFFSET 16
@@ -20,16 +18,6 @@
 #define ADF_C62X_SMIA0_MASK 0xFFFF
 #define ADF_C62X_SMIA1_MASK 0x1
 #define ADF_C62X_SOFTSTRAP_CSR_OFFSET 0x2EC
-/* Error detection and correction */
-#define ADF_C62X_AE_CTX_ENABLES(i) (i * 0x1000 + 0x20818)
-#define ADF_C62X_AE_MISC_CONTROL(i) (i * 0x1000 + 0x20960)
-#define ADF_C62X_ENABLE_AE_ECC_ERR BIT(28)
-#define ADF_C62X_ENABLE_AE_ECC_PARITY_CORR (BIT(24) | BIT(12))
-#define ADF_C62X_UERRSSMSH(i) (i * 0x4000 + 0x18)
-#define ADF_C62X_CERRSSMSH(i) (i * 0x4000 + 0x10)
-#define ADF_C62X_ERRSSMSH_EN BIT(3)
-
-#define ADF_C62X_PF2VF_OFFSET(i)	(0x3A000 + 0x280 + ((i) * 0x04))
 
 /* AE to function mapping */
 #define ADF_C62X_AE2FUNC_MAP_GRP_A_NUM_REGS 80
diff --git a/drivers/crypto/qat/qat_common/adf_gen2_hw_data.c b/drivers/crypto/qat/qat_common/adf_gen2_hw_data.c
index 566918012778..1deeeaed9a8c 100644
--- a/drivers/crypto/qat/qat_common/adf_gen2_hw_data.c
+++ b/drivers/crypto/qat/qat_common/adf_gen2_hw_data.c
@@ -4,6 +4,14 @@
 #include "icp_qat_hw.h"
 #include <linux/pci.h>
 
+#define ADF_GEN2_PF2VF_OFFSET(i)	(0x3A000 + 0x280 + ((i) * 0x04))
+
+u32 adf_gen2_get_pf2vf_offset(u32 i)
+{
+	return ADF_GEN2_PF2VF_OFFSET(i);
+}
+EXPORT_SYMBOL_GPL(adf_gen2_get_pf2vf_offset);
+
 u32 adf_gen2_get_vf2pf_sources(void __iomem *pmisc_addr)
 {
 	u32 errsou3, errmsk3, vf_int_mask;
@@ -44,6 +52,68 @@ void adf_gen2_disable_vf2pf_interrupts(void __iomem *pmisc_addr, u32 vf_mask)
 }
 EXPORT_SYMBOL_GPL(adf_gen2_disable_vf2pf_interrupts);
 
+u32 adf_gen2_get_num_accels(struct adf_hw_device_data *self)
+{
+	u32 i, ctr = 0;
+
+	if (!self || !self->accel_mask)
+		return 0;
+
+	for (i = 0; i < self->num_accel; i++)
+		if (self->accel_mask & (1 << i))
+			ctr++;
+
+	return ctr;
+}
+EXPORT_SYMBOL_GPL(adf_gen2_get_num_accels);
+
+u32 adf_gen2_get_num_aes(struct adf_hw_device_data *self)
+{
+	u32 i, ctr = 0;
+
+	if (!self || !self->ae_mask)
+		return 0;
+
+	for (i = 0; i < self->num_engines; i++)
+		if (self->ae_mask & (1 << i))
+			ctr++;
+
+	return ctr;
+}
+EXPORT_SYMBOL_GPL(adf_gen2_get_num_aes);
+
+void adf_gen2_enable_error_correction(struct adf_accel_dev *accel_dev)
+{
+	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
+	struct adf_bar *misc_bar = &GET_BARS(accel_dev)
+					[hw_data->get_misc_bar_id(hw_data)];
+	unsigned long accel_mask = hw_data->accel_mask;
+	unsigned long ae_mask = hw_data->ae_mask;
+	void __iomem *csr = misc_bar->virt_addr;
+	unsigned int val, i;
+
+	/* Enable Accel Engine error detection & correction */
+	for_each_set_bit(i, &ae_mask, hw_data->num_engines) {
+		val = ADF_CSR_RD(csr, ADF_GEN2_AE_CTX_ENABLES(i));
+		val |= ADF_GEN2_ENABLE_AE_ECC_ERR;
+		ADF_CSR_WR(csr, ADF_GEN2_AE_CTX_ENABLES(i), val);
+		val = ADF_CSR_RD(csr, ADF_GEN2_AE_MISC_CONTROL(i));
+		val |= ADF_GEN2_ENABLE_AE_ECC_PARITY_CORR;
+		ADF_CSR_WR(csr, ADF_GEN2_AE_MISC_CONTROL(i), val);
+	}
+
+	/* Enable shared memory error detection & correction */
+	for_each_set_bit(i, &accel_mask, hw_data->num_accel) {
+		val = ADF_CSR_RD(csr, ADF_GEN2_UERRSSMSH(i));
+		val |= ADF_GEN2_ERRSSMSH_EN;
+		ADF_CSR_WR(csr, ADF_GEN2_UERRSSMSH(i), val);
+		val = ADF_CSR_RD(csr, ADF_GEN2_CERRSSMSH(i));
+		val |= ADF_GEN2_ERRSSMSH_EN;
+		ADF_CSR_WR(csr, ADF_GEN2_CERRSSMSH(i), val);
+	}
+}
+EXPORT_SYMBOL_GPL(adf_gen2_enable_error_correction);
+
 void adf_gen2_cfg_iov_thds(struct adf_accel_dev *accel_dev, bool enable,
 			   int num_a_regs, int num_b_regs)
 {
diff --git a/drivers/crypto/qat/qat_common/adf_gen2_hw_data.h b/drivers/crypto/qat/qat_common/adf_gen2_hw_data.h
index 3486e51aad75..c169d704097d 100644
--- a/drivers/crypto/qat/qat_common/adf_gen2_hw_data.h
+++ b/drivers/crypto/qat/qat_common/adf_gen2_hw_data.h
@@ -22,6 +22,8 @@
 #define ADF_RING_CSR_INT_FLAG_AND_COL	0x184
 #define ADF_RING_CSR_INT_COL_CTL_ENABLE	0x80000000
 #define ADF_RING_BUNDLE_SIZE		0x1000
+#define ADF_GEN2_RX_RINGS_OFFSET	8
+#define ADF_GEN2_TX_RINGS_MASK		0xFF
 
 #define BUILD_RING_BASE_ADDR(addr, size) \
 	(((addr) >> 6) & (GENMASK_ULL(63, 0) << (size)))
@@ -125,6 +127,15 @@ do { \
 #define ADF_SSMWDT(i)		(ADF_SSMWDT_OFFSET + ((i) * 0x4000))
 #define ADF_SSMWDTPKE(i)	(ADF_SSMWDTPKE_OFFSET + ((i) * 0x4000))
 
+/* Error detection and correction */
+#define ADF_GEN2_AE_CTX_ENABLES(i)	((i) * 0x1000 + 0x20818)
+#define ADF_GEN2_AE_MISC_CONTROL(i)	((i) * 0x1000 + 0x20960)
+#define ADF_GEN2_ENABLE_AE_ECC_ERR	BIT(28)
+#define ADF_GEN2_ENABLE_AE_ECC_PARITY_CORR	(BIT(24) | BIT(12))
+#define ADF_GEN2_UERRSSMSH(i)		((i) * 0x4000 + 0x18)
+#define ADF_GEN2_CERRSSMSH(i)		((i) * 0x4000 + 0x10)
+#define ADF_GEN2_ERRSSMSH_EN		BIT(3)
+
  /* VF2PF interrupts */
 #define ADF_GEN2_ERRSOU3 (0x3A000 + 0x0C)
 #define ADF_GEN2_ERRSOU5 (0x3A000 + 0xD8)
@@ -133,10 +144,14 @@ do { \
 #define ADF_GEN2_ERR_REG_VF2PF(vf_src)	(((vf_src) & 0x01FFFE00) >> 9)
 #define ADF_GEN2_ERR_MSK_VF2PF(vf_mask)	(((vf_mask) & 0xFFFF) << 9)
 
+u32 adf_gen2_get_pf2vf_offset(u32 i);
 u32 adf_gen2_get_vf2pf_sources(void __iomem *pmisc_bar);
 void adf_gen2_enable_vf2pf_interrupts(void __iomem *pmisc_addr, u32 vf_mask);
 void adf_gen2_disable_vf2pf_interrupts(void __iomem *pmisc_addr, u32 vf_mask);
 
+u32 adf_gen2_get_num_accels(struct adf_hw_device_data *self);
+u32 adf_gen2_get_num_aes(struct adf_hw_device_data *self);
+void adf_gen2_enable_error_correction(struct adf_accel_dev *accel_dev);
 void adf_gen2_cfg_iov_thds(struct adf_accel_dev *accel_dev, bool enable,
 			   int num_a_regs, int num_b_regs);
 void adf_gen2_init_hw_csr_ops(struct adf_hw_csr_ops *csr_ops);
diff --git a/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c b/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
index b496032c992b..e5e64f880fbf 100644
--- a/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
+++ b/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
@@ -35,34 +35,6 @@ static u32 get_ae_mask(struct adf_hw_device_data *self)
 	return ~fuses & ADF_DH895XCC_ACCELENGINES_MASK;
 }
 
-static u32 get_num_accels(struct adf_hw_device_data *self)
-{
-	u32 i, ctr = 0;
-
-	if (!self || !self->accel_mask)
-		return 0;
-
-	for (i = 0; i < ADF_DH895XCC_MAX_ACCELERATORS; i++) {
-		if (self->accel_mask & (1 << i))
-			ctr++;
-	}
-	return ctr;
-}
-
-static u32 get_num_aes(struct adf_hw_device_data *self)
-{
-	u32 i, ctr = 0;
-
-	if (!self || !self->ae_mask)
-		return 0;
-
-	for (i = 0; i < ADF_DH895XCC_MAX_ACCELENGINES; i++) {
-		if (self->ae_mask & (1 << i))
-			ctr++;
-	}
-	return ctr;
-}
-
 static u32 get_misc_bar_id(struct adf_hw_device_data *self)
 {
 	return ADF_DH895XCC_PMISC_BAR;
@@ -126,41 +98,6 @@ static const u32 *adf_get_arbiter_mapping(void)
 	return thrd_to_arb_map;
 }
 
-static u32 get_pf2vf_offset(u32 i)
-{
-	return ADF_DH895XCC_PF2VF_OFFSET(i);
-}
-
-static void adf_enable_error_correction(struct adf_accel_dev *accel_dev)
-{
-	struct adf_hw_device_data *hw_device = accel_dev->hw_device;
-	struct adf_bar *misc_bar = &GET_BARS(accel_dev)[ADF_DH895XCC_PMISC_BAR];
-	unsigned long accel_mask = hw_device->accel_mask;
-	unsigned long ae_mask = hw_device->ae_mask;
-	void __iomem *csr = misc_bar->virt_addr;
-	unsigned int val, i;
-
-	/* Enable Accel Engine error detection & correction */
-	for_each_set_bit(i, &ae_mask, GET_MAX_ACCELENGINES(accel_dev)) {
-		val = ADF_CSR_RD(csr, ADF_DH895XCC_AE_CTX_ENABLES(i));
-		val |= ADF_DH895XCC_ENABLE_AE_ECC_ERR;
-		ADF_CSR_WR(csr, ADF_DH895XCC_AE_CTX_ENABLES(i), val);
-		val = ADF_CSR_RD(csr, ADF_DH895XCC_AE_MISC_CONTROL(i));
-		val |= ADF_DH895XCC_ENABLE_AE_ECC_PARITY_CORR;
-		ADF_CSR_WR(csr, ADF_DH895XCC_AE_MISC_CONTROL(i), val);
-	}
-
-	/* Enable shared memory error detection & correction */
-	for_each_set_bit(i, &accel_mask, ADF_DH895XCC_MAX_ACCELERATORS) {
-		val = ADF_CSR_RD(csr, ADF_DH895XCC_UERRSSMSH(i));
-		val |= ADF_DH895XCC_ERRSSMSH_EN;
-		ADF_CSR_WR(csr, ADF_DH895XCC_UERRSSMSH(i), val);
-		val = ADF_CSR_RD(csr, ADF_DH895XCC_CERRSSMSH(i));
-		val |= ADF_DH895XCC_ERRSSMSH_EN;
-		ADF_CSR_WR(csr, ADF_DH895XCC_CERRSSMSH(i), val);
-	}
-}
-
 static void adf_enable_ints(struct adf_accel_dev *accel_dev)
 {
 	void __iomem *addr;
@@ -244,16 +181,16 @@ void adf_init_hw_data_dh895xcc(struct adf_hw_device_data *hw_data)
 	hw_data->num_accel = ADF_DH895XCC_MAX_ACCELERATORS;
 	hw_data->num_logical_accel = 1;
 	hw_data->num_engines = ADF_DH895XCC_MAX_ACCELENGINES;
-	hw_data->tx_rx_gap = ADF_DH895XCC_RX_RINGS_OFFSET;
-	hw_data->tx_rings_mask = ADF_DH895XCC_TX_RINGS_MASK;
+	hw_data->tx_rx_gap = ADF_GEN2_RX_RINGS_OFFSET;
+	hw_data->tx_rings_mask = ADF_GEN2_TX_RINGS_MASK;
 	hw_data->alloc_irq = adf_isr_resource_alloc;
 	hw_data->free_irq = adf_isr_resource_free;
-	hw_data->enable_error_correction = adf_enable_error_correction;
+	hw_data->enable_error_correction = adf_gen2_enable_error_correction;
 	hw_data->get_accel_mask = get_accel_mask;
 	hw_data->get_ae_mask = get_ae_mask;
 	hw_data->get_accel_cap = get_accel_cap;
-	hw_data->get_num_accels = get_num_accels;
-	hw_data->get_num_aes = get_num_aes;
+	hw_data->get_num_accels = adf_gen2_get_num_accels;
+	hw_data->get_num_aes = adf_gen2_get_num_aes;
 	hw_data->get_etr_bar_id = get_etr_bar_id;
 	hw_data->get_misc_bar_id = get_misc_bar_id;
 	hw_data->get_admin_info = adf_gen2_get_admin_info;
@@ -271,7 +208,7 @@ void adf_init_hw_data_dh895xcc(struct adf_hw_device_data *hw_data)
 	hw_data->get_arb_mapping = adf_get_arbiter_mapping;
 	hw_data->enable_ints = adf_enable_ints;
 	hw_data->reset_device = adf_reset_sbr;
-	hw_data->get_pf2vf_offset = get_pf2vf_offset;
+	hw_data->get_pf2vf_offset = adf_gen2_get_pf2vf_offset;
 	hw_data->get_vf2pf_sources = get_vf2pf_sources;
 	hw_data->enable_vf2pf_interrupts = enable_vf2pf_interrupts;
 	hw_data->disable_vf2pf_interrupts = disable_vf2pf_interrupts;
diff --git a/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.h b/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.h
index 0f9f24b44663..0af34dd8708a 100644
--- a/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.h
+++ b/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.h
@@ -7,8 +7,6 @@
 #define ADF_DH895XCC_SRAM_BAR 0
 #define ADF_DH895XCC_PMISC_BAR 1
 #define ADF_DH895XCC_ETR_BAR 2
-#define ADF_DH895XCC_RX_RINGS_OFFSET 8
-#define ADF_DH895XCC_TX_RINGS_MASK 0xFF
 #define ADF_DH895XCC_FUSECTL_SKU_MASK 0x300000
 #define ADF_DH895XCC_FUSECTL_SKU_SHIFT 20
 #define ADF_DH895XCC_FUSECTL_SKU_1 0x0
@@ -25,19 +23,10 @@
 #define ADF_DH895XCC_SMIAPF1_MASK_OFFSET (0x3A000 + 0x30)
 #define ADF_DH895XCC_SMIA0_MASK 0xFFFFFFFF
 #define ADF_DH895XCC_SMIA1_MASK 0x1
-/* Error detection and correction */
-#define ADF_DH895XCC_AE_CTX_ENABLES(i) (i * 0x1000 + 0x20818)
-#define ADF_DH895XCC_AE_MISC_CONTROL(i) (i * 0x1000 + 0x20960)
-#define ADF_DH895XCC_ENABLE_AE_ECC_ERR BIT(28)
-#define ADF_DH895XCC_ENABLE_AE_ECC_PARITY_CORR (BIT(24) | BIT(12))
-#define ADF_DH895XCC_UERRSSMSH(i) (i * 0x4000 + 0x18)
-#define ADF_DH895XCC_CERRSSMSH(i) (i * 0x4000 + 0x10)
-#define ADF_DH895XCC_ERRSSMSH_EN BIT(3)
 
 /* Masks for VF2PF interrupts */
 #define ADF_DH895XCC_ERR_REG_VF2PF_U(vf_src)	(((vf_src) & 0x0000FFFF) << 16)
 #define ADF_DH895XCC_ERR_MSK_VF2PF_U(vf_mask)	((vf_mask) >> 16)
-#define ADF_DH895XCC_PF2VF_OFFSET(i)		(0x3A000 + 0x280 + ((i) * 0x04))
 
 /* AE to function mapping */
 #define ADF_DH895XCC_AE2FUNC_MAP_GRP_A_NUM_REGS 96
-- 
2.31.1

