Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36166C433EF
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Nov 2021 12:04:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 15A9A61B53
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Nov 2021 12:04:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230477AbhKOMHA (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 15 Nov 2021 07:07:00 -0500
Received: from mga09.intel.com ([134.134.136.24]:13626 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230411AbhKOMG4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 15 Nov 2021 07:06:56 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10168"; a="233265524"
X-IronPort-AV: E=Sophos;i="5.87,236,1631602800"; 
   d="scan'208";a="233265524"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2021 04:03:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,236,1631602800"; 
   d="scan'208";a="535486335"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.76])
  by orsmga001.jf.intel.com with ESMTP; 15 Nov 2021 04:03:51 -0800
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        marco.chiappero@intel.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH v2 03/24] crypto: qat - move vf2pf interrupt helpers
Date:   Mon, 15 Nov 2021 12:03:15 +0000
Message-Id: <20211115120336.22292-4-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115120336.22292-1-giovanni.cabiddu@intel.com>
References: <20211115120336.22292-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Move vf2pf interrupt enable and disable functions from adf_pf2vf_msg.c
to adf_isr.c
This it to separate the interrupt related code from the PFVF protocol
logic.

With this change, the function adf_disable_vf2pf_interrupts_irq() is
only called from adf_isr.c and it has been marked as static.

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Marco Chiappero <marco.chiappero@intel.com>
---
 .../crypto/qat/qat_common/adf_common_drv.h    |  2 -
 drivers/crypto/qat/qat_common/adf_isr.c       | 39 +++++++++++++++++++
 drivers/crypto/qat/qat_common/adf_pf2vf_msg.c | 39 -------------------
 3 files changed, 39 insertions(+), 41 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_common_drv.h b/drivers/crypto/qat/qat_common/adf_common_drv.h
index 2cc6622833c4..d06b5aab7fc3 100644
--- a/drivers/crypto/qat/qat_common/adf_common_drv.h
+++ b/drivers/crypto/qat/qat_common/adf_common_drv.h
@@ -192,8 +192,6 @@ int adf_sriov_configure(struct pci_dev *pdev, int numvfs);
 void adf_disable_sriov(struct adf_accel_dev *accel_dev);
 void adf_disable_vf2pf_interrupts(struct adf_accel_dev *accel_dev,
 				  u32 vf_mask);
-void adf_disable_vf2pf_interrupts_irq(struct adf_accel_dev *accel_dev,
-				      u32 vf_mask);
 void adf_enable_vf2pf_interrupts(struct adf_accel_dev *accel_dev,
 				 u32 vf_mask);
 int adf_enable_pf2vf_comms(struct adf_accel_dev *accel_dev);
diff --git a/drivers/crypto/qat/qat_common/adf_isr.c b/drivers/crypto/qat/qat_common/adf_isr.c
index 5dfc534f1bf0..2b4900c91308 100644
--- a/drivers/crypto/qat/qat_common/adf_isr.c
+++ b/drivers/crypto/qat/qat_common/adf_isr.c
@@ -55,6 +55,45 @@ static irqreturn_t adf_msix_isr_bundle(int irq, void *bank_ptr)
 }
 
 #ifdef CONFIG_PCI_IOV
+void adf_enable_vf2pf_interrupts(struct adf_accel_dev *accel_dev, u32 vf_mask)
+{
+	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
+	u32 misc_bar_id = hw_data->get_misc_bar_id(hw_data);
+	struct adf_bar *pmisc = &GET_BARS(accel_dev)[misc_bar_id];
+	void __iomem *pmisc_addr = pmisc->virt_addr;
+	unsigned long flags;
+
+	spin_lock_irqsave(&accel_dev->pf.vf2pf_ints_lock, flags);
+	hw_data->enable_vf2pf_interrupts(pmisc_addr, vf_mask);
+	spin_unlock_irqrestore(&accel_dev->pf.vf2pf_ints_lock, flags);
+}
+
+void adf_disable_vf2pf_interrupts(struct adf_accel_dev *accel_dev, u32 vf_mask)
+{
+	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
+	u32 misc_bar_id = hw_data->get_misc_bar_id(hw_data);
+	struct adf_bar *pmisc = &GET_BARS(accel_dev)[misc_bar_id];
+	void __iomem *pmisc_addr = pmisc->virt_addr;
+	unsigned long flags;
+
+	spin_lock_irqsave(&accel_dev->pf.vf2pf_ints_lock, flags);
+	hw_data->disable_vf2pf_interrupts(pmisc_addr, vf_mask);
+	spin_unlock_irqrestore(&accel_dev->pf.vf2pf_ints_lock, flags);
+}
+
+static void adf_disable_vf2pf_interrupts_irq(struct adf_accel_dev *accel_dev,
+					     u32 vf_mask)
+{
+	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
+	u32 misc_bar_id = hw_data->get_misc_bar_id(hw_data);
+	struct adf_bar *pmisc = &GET_BARS(accel_dev)[misc_bar_id];
+	void __iomem *pmisc_addr = pmisc->virt_addr;
+
+	spin_lock(&accel_dev->pf.vf2pf_ints_lock);
+	hw_data->disable_vf2pf_interrupts(pmisc_addr, vf_mask);
+	spin_unlock(&accel_dev->pf.vf2pf_ints_lock);
+}
+
 static bool adf_handle_vf2pf_int(struct adf_accel_dev *accel_dev)
 {
 	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
diff --git a/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c b/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
index 99ee17c3d06b..d0492530c84a 100644
--- a/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
+++ b/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
@@ -14,45 +14,6 @@
 					 ADF_PFVF_MSG_ACK_MAX_RETRY + \
 					 ADF_PFVF_MSG_COLLISION_DETECT_DELAY)
 
-void adf_enable_vf2pf_interrupts(struct adf_accel_dev *accel_dev, u32 vf_mask)
-{
-	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
-	u32 misc_bar_id = hw_data->get_misc_bar_id(hw_data);
-	struct adf_bar *pmisc = &GET_BARS(accel_dev)[misc_bar_id];
-	void __iomem *pmisc_addr = pmisc->virt_addr;
-	unsigned long flags;
-
-	spin_lock_irqsave(&accel_dev->pf.vf2pf_ints_lock, flags);
-	hw_data->enable_vf2pf_interrupts(pmisc_addr, vf_mask);
-	spin_unlock_irqrestore(&accel_dev->pf.vf2pf_ints_lock, flags);
-}
-
-void adf_disable_vf2pf_interrupts(struct adf_accel_dev *accel_dev, u32 vf_mask)
-{
-	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
-	u32 misc_bar_id = hw_data->get_misc_bar_id(hw_data);
-	struct adf_bar *pmisc = &GET_BARS(accel_dev)[misc_bar_id];
-	void __iomem *pmisc_addr = pmisc->virt_addr;
-	unsigned long flags;
-
-	spin_lock_irqsave(&accel_dev->pf.vf2pf_ints_lock, flags);
-	hw_data->disable_vf2pf_interrupts(pmisc_addr, vf_mask);
-	spin_unlock_irqrestore(&accel_dev->pf.vf2pf_ints_lock, flags);
-}
-
-void adf_disable_vf2pf_interrupts_irq(struct adf_accel_dev *accel_dev,
-				      u32 vf_mask)
-{
-	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
-	u32 misc_bar_id = hw_data->get_misc_bar_id(hw_data);
-	struct adf_bar *pmisc = &GET_BARS(accel_dev)[misc_bar_id];
-	void __iomem *pmisc_addr = pmisc->virt_addr;
-
-	spin_lock(&accel_dev->pf.vf2pf_ints_lock);
-	hw_data->disable_vf2pf_interrupts(pmisc_addr, vf_mask);
-	spin_unlock(&accel_dev->pf.vf2pf_ints_lock);
-}
-
 static int __adf_iov_putmsg(struct adf_accel_dev *accel_dev, u32 msg, u8 vf_nr)
 {
 	struct adf_accel_pci *pci_info = &accel_dev->accel_pci_dev;
-- 
2.33.1

