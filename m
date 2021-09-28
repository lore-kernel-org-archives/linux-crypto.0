Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FEEDC433FE
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Sep 2021 11:44:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7FBB6610E6
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Sep 2021 11:44:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240395AbhI1Lqg (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 28 Sep 2021 07:46:36 -0400
Received: from mga07.intel.com ([134.134.136.100]:37909 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231202AbhI1Lqg (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Sep 2021 07:46:36 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10120"; a="288339052"
X-IronPort-AV: E=Sophos;i="5.85,329,1624345200"; 
   d="scan'208";a="288339052"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2021 04:44:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,329,1624345200"; 
   d="scan'208";a="562224677"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.51])
  by fmsmga002.fm.intel.com with ESMTP; 28 Sep 2021 04:44:54 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Marco Chiappero <marco.chiappero@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH 04/12] crypto: qat - fix handling of VF to PF interrupts
Date:   Tue, 28 Sep 2021 12:44:32 +0100
Message-Id: <20210928114440.355368-5-giovanni.cabiddu@intel.com>
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

Currently, VF to PF interrupt handling is based on the DH895XCC device
behavior, which is not entirely common to all devices.

In order to make interrupt detection and handling correct for all of the
supported devices, make the interrupt handling device specific by:
 - introducing get_vf2pf_sources() for getting a 32 bits long value
   where each bit represents a vf2pf interrupt;
 - adding the device [enable|disable]_vf2pf_interrupts to hw_data;
 - defining [enable|disable]_vf2pf_interrupts for all the devices that
   are currently supported, using only their required and specific
   ERRSOU|ERRMASK registers (DH895XCC has 32 interrupts spread across
   ERRSOU3 and ERRSOU5, C62X/C3XXX has 16 in ERRSOU3 only, etc).
Code has been shared by different devices wherever possible.

This patch is based on earlier work done by Salvatore Benedetto.

Signed-off-by: Marco Chiappero <marco.chiappero@intel.com>
Co-developed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 .../crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c  |  3 +
 .../crypto/qat/qat_c62x/adf_c62x_hw_data.c    |  3 +
 .../crypto/qat/qat_common/adf_accel_devices.h |  5 ++
 .../crypto/qat/qat_common/adf_gen2_hw_data.c  | 40 +++++++++++
 .../crypto/qat/qat_common/adf_gen2_hw_data.h  | 12 ++++
 drivers/crypto/qat/qat_common/adf_isr.c       | 20 +-----
 drivers/crypto/qat/qat_common/adf_pf2vf_msg.c | 72 +++++--------------
 .../qat/qat_dh895xcc/adf_dh895xcc_hw_data.c   | 49 +++++++++++++
 .../qat/qat_dh895xcc/adf_dh895xcc_hw_data.h   |  5 +-
 9 files changed, 133 insertions(+), 76 deletions(-)

diff --git a/drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c b/drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c
index 3027c01bc89e..b9bd52eaa184 100644
--- a/drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c
+++ b/drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c
@@ -206,6 +206,9 @@ void adf_init_hw_data_c3xxx(struct adf_hw_device_data *hw_data)
 	hw_data->reset_device = adf_reset_flr;
 	hw_data->set_ssm_wdtimer = adf_gen2_set_ssm_wdtimer;
 	hw_data->get_pf2vf_offset = get_pf2vf_offset;
+	hw_data->get_vf2pf_sources = adf_gen2_get_vf2pf_sources;
+	hw_data->enable_vf2pf_interrupts = adf_gen2_enable_vf2pf_interrupts;
+	hw_data->disable_vf2pf_interrupts = adf_gen2_disable_vf2pf_interrupts;
 	hw_data->enable_pfvf_comms = adf_enable_pf2vf_comms;
 	hw_data->disable_iov = adf_disable_sriov;
 	hw_data->min_iov_compat_ver = ADF_PFVF_COMPAT_THIS_VERSION;
diff --git a/drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.c b/drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.c
index b023c80873bb..f28dae0982bc 100644
--- a/drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.c
+++ b/drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.c
@@ -208,6 +208,9 @@ void adf_init_hw_data_c62x(struct adf_hw_device_data *hw_data)
 	hw_data->reset_device = adf_reset_flr;
 	hw_data->set_ssm_wdtimer = adf_gen2_set_ssm_wdtimer;
 	hw_data->get_pf2vf_offset = get_pf2vf_offset;
+	hw_data->get_vf2pf_sources = adf_gen2_get_vf2pf_sources;
+	hw_data->enable_vf2pf_interrupts = adf_gen2_enable_vf2pf_interrupts;
+	hw_data->disable_vf2pf_interrupts = adf_gen2_disable_vf2pf_interrupts;
 	hw_data->enable_pfvf_comms = adf_enable_pf2vf_comms;
 	hw_data->disable_iov = adf_disable_sriov;
 	hw_data->min_iov_compat_ver = ADF_PFVF_COMPAT_THIS_VERSION;
diff --git a/drivers/crypto/qat/qat_common/adf_accel_devices.h b/drivers/crypto/qat/qat_common/adf_accel_devices.h
index ca8e23f0bcc4..57d9ca08e611 100644
--- a/drivers/crypto/qat/qat_common/adf_accel_devices.h
+++ b/drivers/crypto/qat/qat_common/adf_accel_devices.h
@@ -177,6 +177,11 @@ struct adf_hw_device_data {
 	void (*enable_ints)(struct adf_accel_dev *accel_dev);
 	void (*set_ssm_wdtimer)(struct adf_accel_dev *accel_dev);
 	int (*enable_pfvf_comms)(struct adf_accel_dev *accel_dev);
+	u32 (*get_vf2pf_sources)(void __iomem *pmisc_addr);
+	void (*enable_vf2pf_interrupts)(void __iomem *pmisc_bar_addr,
+					u32 vf_mask);
+	void (*disable_vf2pf_interrupts)(void __iomem *pmisc_bar_addr,
+					 u32 vf_mask);
 	void (*reset_device)(struct adf_accel_dev *accel_dev);
 	void (*set_msix_rttable)(struct adf_accel_dev *accel_dev);
 	char *(*uof_get_name)(u32 obj_num);
diff --git a/drivers/crypto/qat/qat_common/adf_gen2_hw_data.c b/drivers/crypto/qat/qat_common/adf_gen2_hw_data.c
index 9e560c7d4163..566918012778 100644
--- a/drivers/crypto/qat/qat_common/adf_gen2_hw_data.c
+++ b/drivers/crypto/qat/qat_common/adf_gen2_hw_data.c
@@ -4,6 +4,46 @@
 #include "icp_qat_hw.h"
 #include <linux/pci.h>
 
+u32 adf_gen2_get_vf2pf_sources(void __iomem *pmisc_addr)
+{
+	u32 errsou3, errmsk3, vf_int_mask;
+
+	/* Get the interrupt sources triggered by VFs */
+	errsou3 = ADF_CSR_RD(pmisc_addr, ADF_GEN2_ERRSOU3);
+	vf_int_mask = ADF_GEN2_ERR_REG_VF2PF(errsou3);
+
+	/* To avoid adding duplicate entries to work queue, clear
+	 * vf_int_mask_sets bits that are already masked in ERRMSK register.
+	 */
+	errmsk3 = ADF_CSR_RD(pmisc_addr, ADF_GEN2_ERRMSK3);
+	vf_int_mask &= ~ADF_GEN2_ERR_REG_VF2PF(errmsk3);
+
+	return vf_int_mask;
+}
+EXPORT_SYMBOL_GPL(adf_gen2_get_vf2pf_sources);
+
+void adf_gen2_enable_vf2pf_interrupts(void __iomem *pmisc_addr, u32 vf_mask)
+{
+	/* Enable VF2PF Messaging Ints - VFs 0 through 15 per vf_mask[15:0] */
+	if (vf_mask & 0xFFFF) {
+		u32 val = ADF_CSR_RD(pmisc_addr, ADF_GEN2_ERRMSK3)
+			  & ~ADF_GEN2_ERR_MSK_VF2PF(vf_mask);
+		ADF_CSR_WR(pmisc_addr, ADF_GEN2_ERRMSK3, val);
+	}
+}
+EXPORT_SYMBOL_GPL(adf_gen2_enable_vf2pf_interrupts);
+
+void adf_gen2_disable_vf2pf_interrupts(void __iomem *pmisc_addr, u32 vf_mask)
+{
+	/* Disable VF2PF interrupts for VFs 0 through 15 per vf_mask[15:0] */
+	if (vf_mask & 0xFFFF) {
+		u32 val = ADF_CSR_RD(pmisc_addr, ADF_GEN2_ERRMSK3)
+			  | ADF_GEN2_ERR_MSK_VF2PF(vf_mask);
+		ADF_CSR_WR(pmisc_addr, ADF_GEN2_ERRMSK3, val);
+	}
+}
+EXPORT_SYMBOL_GPL(adf_gen2_disable_vf2pf_interrupts);
+
 void adf_gen2_cfg_iov_thds(struct adf_accel_dev *accel_dev, bool enable,
 			   int num_a_regs, int num_b_regs)
 {
diff --git a/drivers/crypto/qat/qat_common/adf_gen2_hw_data.h b/drivers/crypto/qat/qat_common/adf_gen2_hw_data.h
index 756b0ddfac5e..3486e51aad75 100644
--- a/drivers/crypto/qat/qat_common/adf_gen2_hw_data.h
+++ b/drivers/crypto/qat/qat_common/adf_gen2_hw_data.h
@@ -125,6 +125,18 @@ do { \
 #define ADF_SSMWDT(i)		(ADF_SSMWDT_OFFSET + ((i) * 0x4000))
 #define ADF_SSMWDTPKE(i)	(ADF_SSMWDTPKE_OFFSET + ((i) * 0x4000))
 
+ /* VF2PF interrupts */
+#define ADF_GEN2_ERRSOU3 (0x3A000 + 0x0C)
+#define ADF_GEN2_ERRSOU5 (0x3A000 + 0xD8)
+#define ADF_GEN2_ERRMSK3 (0x3A000 + 0x1C)
+#define ADF_GEN2_ERRMSK5 (0x3A000 + 0xDC)
+#define ADF_GEN2_ERR_REG_VF2PF(vf_src)	(((vf_src) & 0x01FFFE00) >> 9)
+#define ADF_GEN2_ERR_MSK_VF2PF(vf_mask)	(((vf_mask) & 0xFFFF) << 9)
+
+u32 adf_gen2_get_vf2pf_sources(void __iomem *pmisc_bar);
+void adf_gen2_enable_vf2pf_interrupts(void __iomem *pmisc_addr, u32 vf_mask);
+void adf_gen2_disable_vf2pf_interrupts(void __iomem *pmisc_addr, u32 vf_mask);
+
 void adf_gen2_cfg_iov_thds(struct adf_accel_dev *accel_dev, bool enable,
 			   int num_a_regs, int num_b_regs);
 void adf_gen2_init_hw_csr_ops(struct adf_hw_csr_ops *csr_ops);
diff --git a/drivers/crypto/qat/qat_common/adf_isr.c b/drivers/crypto/qat/qat_common/adf_isr.c
index c55a9f14b0d2..40593c9449a2 100644
--- a/drivers/crypto/qat/qat_common/adf_isr.c
+++ b/drivers/crypto/qat/qat_common/adf_isr.c
@@ -16,12 +16,6 @@
 #include "adf_transport_internal.h"
 
 #define ADF_MAX_NUM_VFS	32
-#define ADF_ERRSOU3	(0x3A000 + 0x0C)
-#define ADF_ERRSOU5	(0x3A000 + 0xD8)
-#define ADF_ERRMSK3	(0x3A000 + 0x1C)
-#define ADF_ERRMSK5	(0x3A000 + 0xDC)
-#define ADF_ERR_REG_VF2PF_L(vf_src)	(((vf_src) & 0x01FFFE00) >> 9)
-#define ADF_ERR_REG_VF2PF_U(vf_src)	(((vf_src) & 0x0000FFFF) << 16)
 
 static int adf_enable_msix(struct adf_accel_dev *accel_dev)
 {
@@ -71,22 +65,10 @@ static irqreturn_t adf_msix_isr_ae(int irq, void *dev_ptr)
 		struct adf_bar *pmisc =
 			&GET_BARS(accel_dev)[hw_data->get_misc_bar_id(hw_data)];
 		void __iomem *pmisc_addr = pmisc->virt_addr;
-		u32 errsou3, errsou5, errmsk3, errmsk5;
 		unsigned long vf_mask;
 
 		/* Get the interrupt sources triggered by VFs */
-		errsou3 = ADF_CSR_RD(pmisc_addr, ADF_ERRSOU3);
-		errsou5 = ADF_CSR_RD(pmisc_addr, ADF_ERRSOU5);
-		vf_mask = ADF_ERR_REG_VF2PF_L(errsou3);
-		vf_mask |= ADF_ERR_REG_VF2PF_U(errsou5);
-
-		/* To avoid adding duplicate entries to work queue, clear
-		 * vf_int_mask_sets bits that are already masked in ERRMSK register.
-		 */
-		errmsk3 = ADF_CSR_RD(pmisc_addr, ADF_ERRMSK3);
-		errmsk5 = ADF_CSR_RD(pmisc_addr, ADF_ERRMSK5);
-		vf_mask &= ~ADF_ERR_REG_VF2PF_L(errmsk3);
-		vf_mask &= ~ADF_ERR_REG_VF2PF_U(errmsk5);
+		vf_mask = hw_data->get_vf2pf_sources(pmisc_addr);
 
 		if (vf_mask) {
 			struct adf_accel_vf_info *vf_info;
diff --git a/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c b/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
index d3f6ff68d45d..cdef6c34524e 100644
--- a/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
+++ b/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
@@ -5,82 +5,42 @@
 #include "adf_common_drv.h"
 #include "adf_pf2vf_msg.h"
 
-#define ADF_DH895XCC_EP_OFFSET	0x3A000
-#define ADF_DH895XCC_ERRMSK3	(ADF_DH895XCC_EP_OFFSET + 0x1C)
-#define ADF_DH895XCC_ERRMSK3_VF2PF_L_MASK(vf_mask) ((vf_mask & 0xFFFF) << 9)
-#define ADF_DH895XCC_ERRMSK5	(ADF_DH895XCC_EP_OFFSET + 0xDC)
-#define ADF_DH895XCC_ERRMSK5_VF2PF_U_MASK(vf_mask) (vf_mask >> 16)
-
-static void __adf_enable_vf2pf_interrupts(struct adf_accel_dev *accel_dev,
-					  u32 vf_mask)
+void adf_enable_vf2pf_interrupts(struct adf_accel_dev *accel_dev, u32 vf_mask)
 {
 	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
-	struct adf_bar *pmisc =
-			&GET_BARS(accel_dev)[hw_data->get_misc_bar_id(hw_data)];
+	u32 misc_bar_id = hw_data->get_misc_bar_id(hw_data);
+	struct adf_bar *pmisc = &GET_BARS(accel_dev)[misc_bar_id];
 	void __iomem *pmisc_addr = pmisc->virt_addr;
-	u32 reg;
-
-	/* Enable VF2PF Messaging Ints - VFs 1 through 16 per vf_mask[15:0] */
-	if (vf_mask & 0xFFFF) {
-		reg = ADF_CSR_RD(pmisc_addr, ADF_DH895XCC_ERRMSK3);
-		reg &= ~ADF_DH895XCC_ERRMSK3_VF2PF_L_MASK(vf_mask);
-		ADF_CSR_WR(pmisc_addr, ADF_DH895XCC_ERRMSK3, reg);
-	}
-
-	/* Enable VF2PF Messaging Ints - VFs 17 through 32 per vf_mask[31:16] */
-	if (vf_mask >> 16) {
-		reg = ADF_CSR_RD(pmisc_addr, ADF_DH895XCC_ERRMSK5);
-		reg &= ~ADF_DH895XCC_ERRMSK5_VF2PF_U_MASK(vf_mask);
-		ADF_CSR_WR(pmisc_addr, ADF_DH895XCC_ERRMSK5, reg);
-	}
-}
-
-void adf_enable_vf2pf_interrupts(struct adf_accel_dev *accel_dev, u32 vf_mask)
-{
 	unsigned long flags;
 
 	spin_lock_irqsave(&accel_dev->pf.vf2pf_ints_lock, flags);
-	__adf_enable_vf2pf_interrupts(accel_dev, vf_mask);
+	hw_data->enable_vf2pf_interrupts(pmisc_addr, vf_mask);
 	spin_unlock_irqrestore(&accel_dev->pf.vf2pf_ints_lock, flags);
 }
 
-static void __adf_disable_vf2pf_interrupts(struct adf_accel_dev *accel_dev,
-					   u32 vf_mask)
+void adf_disable_vf2pf_interrupts(struct adf_accel_dev *accel_dev, u32 vf_mask)
 {
 	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
-	struct adf_bar *pmisc =
-			&GET_BARS(accel_dev)[hw_data->get_misc_bar_id(hw_data)];
+	u32 misc_bar_id = hw_data->get_misc_bar_id(hw_data);
+	struct adf_bar *pmisc = &GET_BARS(accel_dev)[misc_bar_id];
 	void __iomem *pmisc_addr = pmisc->virt_addr;
-	u32 reg;
-
-	/* Disable VF2PF interrupts for VFs 1 through 16 per vf_mask[15:0] */
-	if (vf_mask & 0xFFFF) {
-		reg = ADF_CSR_RD(pmisc_addr, ADF_DH895XCC_ERRMSK3) |
-			ADF_DH895XCC_ERRMSK3_VF2PF_L_MASK(vf_mask);
-		ADF_CSR_WR(pmisc_addr, ADF_DH895XCC_ERRMSK3, reg);
-	}
-
-	/* Disable VF2PF interrupts for VFs 17 through 32 per vf_mask[31:16] */
-	if (vf_mask >> 16) {
-		reg = ADF_CSR_RD(pmisc_addr, ADF_DH895XCC_ERRMSK5) |
-			ADF_DH895XCC_ERRMSK5_VF2PF_U_MASK(vf_mask);
-		ADF_CSR_WR(pmisc_addr, ADF_DH895XCC_ERRMSK5, reg);
-	}
-}
-
-void adf_disable_vf2pf_interrupts(struct adf_accel_dev *accel_dev, u32 vf_mask)
-{
 	unsigned long flags;
 
 	spin_lock_irqsave(&accel_dev->pf.vf2pf_ints_lock, flags);
-	__adf_disable_vf2pf_interrupts(accel_dev, vf_mask);
+	hw_data->disable_vf2pf_interrupts(pmisc_addr, vf_mask);
 	spin_unlock_irqrestore(&accel_dev->pf.vf2pf_ints_lock, flags);
 }
 
-void adf_disable_vf2pf_interrupts_irq(struct adf_accel_dev *accel_dev, u32 vf_mask)
+void adf_disable_vf2pf_interrupts_irq(struct adf_accel_dev *accel_dev,
+				      u32 vf_mask)
 {
+	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
+	u32 misc_bar_id = hw_data->get_misc_bar_id(hw_data);
+	struct adf_bar *pmisc = &GET_BARS(accel_dev)[misc_bar_id];
+	void __iomem *pmisc_addr = pmisc->virt_addr;
+
 	spin_lock(&accel_dev->pf.vf2pf_ints_lock);
-	__adf_disable_vf2pf_interrupts(accel_dev, vf_mask);
+	hw_data->disable_vf2pf_interrupts(pmisc_addr, vf_mask);
 	spin_unlock(&accel_dev->pf.vf2pf_ints_lock);
 }
 
diff --git a/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c b/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
index 0a9ce365a544..b496032c992b 100644
--- a/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
+++ b/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
@@ -175,6 +175,52 @@ static void adf_enable_ints(struct adf_accel_dev *accel_dev)
 		   ADF_DH895XCC_SMIA1_MASK);
 }
 
+static u32 get_vf2pf_sources(void __iomem *pmisc_bar)
+{
+	u32 errsou5, errmsk5, vf_int_mask;
+
+	vf_int_mask = adf_gen2_get_vf2pf_sources(pmisc_bar);
+
+	/* Get the interrupt sources triggered by VFs, but to avoid duplicates
+	 * in the work queue, clear vf_int_mask_sets bits that are already
+	 * masked in ERRMSK register.
+	 */
+	errsou5 = ADF_CSR_RD(pmisc_bar, ADF_GEN2_ERRSOU5);
+	errmsk5 = ADF_CSR_RD(pmisc_bar, ADF_GEN2_ERRMSK5);
+	vf_int_mask |= ADF_DH895XCC_ERR_REG_VF2PF_U(errsou5);
+	vf_int_mask &= ~ADF_DH895XCC_ERR_REG_VF2PF_U(errmsk5);
+
+	return vf_int_mask;
+}
+
+static void enable_vf2pf_interrupts(void __iomem *pmisc_addr, u32 vf_mask)
+{
+	/* Enable VF2PF Messaging Ints - VFs 0 through 15 per vf_mask[15:0] */
+	adf_gen2_enable_vf2pf_interrupts(pmisc_addr, vf_mask);
+
+	/* Enable VF2PF Messaging Ints - VFs 16 through 31 per vf_mask[31:16] */
+	if (vf_mask >> 16) {
+		u32 val = ADF_CSR_RD(pmisc_addr, ADF_GEN2_ERRMSK5)
+			  & ~ADF_DH895XCC_ERR_MSK_VF2PF_U(vf_mask);
+
+		ADF_CSR_WR(pmisc_addr, ADF_GEN2_ERRMSK5, val);
+	}
+}
+
+static void disable_vf2pf_interrupts(void __iomem *pmisc_addr, u32 vf_mask)
+{
+	/* Disable VF2PF interrupts for VFs 0 through 15 per vf_mask[15:0] */
+	adf_gen2_disable_vf2pf_interrupts(pmisc_addr, vf_mask);
+
+	/* Disable VF2PF interrupts for VFs 16 through 31 per vf_mask[31:16] */
+	if (vf_mask >> 16) {
+		u32 val = ADF_CSR_RD(pmisc_addr, ADF_GEN2_ERRMSK5)
+			  | ADF_DH895XCC_ERR_MSK_VF2PF_U(vf_mask);
+
+		ADF_CSR_WR(pmisc_addr, ADF_GEN2_ERRMSK5, val);
+	}
+}
+
 static int adf_enable_pf2vf_comms(struct adf_accel_dev *accel_dev)
 {
 	spin_lock_init(&accel_dev->pf.vf2pf_ints_lock);
@@ -226,6 +272,9 @@ void adf_init_hw_data_dh895xcc(struct adf_hw_device_data *hw_data)
 	hw_data->enable_ints = adf_enable_ints;
 	hw_data->reset_device = adf_reset_sbr;
 	hw_data->get_pf2vf_offset = get_pf2vf_offset;
+	hw_data->get_vf2pf_sources = get_vf2pf_sources;
+	hw_data->enable_vf2pf_interrupts = enable_vf2pf_interrupts;
+	hw_data->disable_vf2pf_interrupts = disable_vf2pf_interrupts;
 	hw_data->enable_pfvf_comms = adf_enable_pf2vf_comms;
 	hw_data->disable_iov = adf_disable_sriov;
 	hw_data->min_iov_compat_ver = ADF_PFVF_COMPAT_THIS_VERSION;
diff --git a/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.h b/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.h
index f99319cd4543..0f9f24b44663 100644
--- a/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.h
+++ b/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.h
@@ -34,7 +34,10 @@
 #define ADF_DH895XCC_CERRSSMSH(i) (i * 0x4000 + 0x10)
 #define ADF_DH895XCC_ERRSSMSH_EN BIT(3)
 
-#define ADF_DH895XCC_PF2VF_OFFSET(i)	(0x3A000 + 0x280 + ((i) * 0x04))
+/* Masks for VF2PF interrupts */
+#define ADF_DH895XCC_ERR_REG_VF2PF_U(vf_src)	(((vf_src) & 0x0000FFFF) << 16)
+#define ADF_DH895XCC_ERR_MSK_VF2PF_U(vf_mask)	((vf_mask) >> 16)
+#define ADF_DH895XCC_PF2VF_OFFSET(i)		(0x3A000 + 0x280 + ((i) * 0x04))
 
 /* AE to function mapping */
 #define ADF_DH895XCC_AE2FUNC_MAP_GRP_A_NUM_REGS 96
-- 
2.31.1

