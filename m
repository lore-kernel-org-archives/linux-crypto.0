Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08A6CC433EF
	for <linux-crypto@archiver.kernel.org>; Wed, 17 Nov 2021 14:31:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E71A361BCF
	for <linux-crypto@archiver.kernel.org>; Wed, 17 Nov 2021 14:31:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234850AbhKQOeT (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 17 Nov 2021 09:34:19 -0500
Received: from mga01.intel.com ([192.55.52.88]:57906 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234772AbhKQOeR (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 17 Nov 2021 09:34:17 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10170"; a="257722588"
X-IronPort-AV: E=Sophos;i="5.87,241,1631602800"; 
   d="scan'208";a="257722588"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2021 06:31:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,241,1631602800"; 
   d="scan'208";a="735829658"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.76])
  by fmsmga006.fm.intel.com with ESMTP; 17 Nov 2021 06:31:14 -0800
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        marco.chiappero@intel.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH v3 03/25] crypto: qat - refactor PF top half for PFVF
Date:   Wed, 17 Nov 2021 14:30:36 +0000
Message-Id: <20211117143058.211550-4-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211117143058.211550-1-giovanni.cabiddu@intel.com>
References: <20211117143058.211550-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Marco Chiappero <marco.chiappero@intel.com>

Move logic associated to handling VF2PF interrupt to its own function.
This will simplify the handling of multiple interrupt sources in the
function adf_msix_isr_ae() in the future.

Signed-off-by: Marco Chiappero <marco.chiappero@intel.com>
Co-developed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/qat/qat_common/adf_isr.c | 84 +++++++++++++------------
 1 file changed, 44 insertions(+), 40 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_isr.c b/drivers/crypto/qat/qat_common/adf_isr.c
index 40593c9449a2..5dfc534f1bf0 100644
--- a/drivers/crypto/qat/qat_common/adf_isr.c
+++ b/drivers/crypto/qat/qat_common/adf_isr.c
@@ -54,52 +54,56 @@ static irqreturn_t adf_msix_isr_bundle(int irq, void *bank_ptr)
 	return IRQ_HANDLED;
 }
 
+#ifdef CONFIG_PCI_IOV
+static bool adf_handle_vf2pf_int(struct adf_accel_dev *accel_dev)
+{
+	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
+	int bar_id = hw_data->get_misc_bar_id(hw_data);
+	struct adf_bar *pmisc = &GET_BARS(accel_dev)[bar_id];
+	void __iomem *pmisc_addr = pmisc->virt_addr;
+	bool irq_handled = false;
+	unsigned long vf_mask;
+
+	/* Get the interrupt sources triggered by VFs */
+	vf_mask = hw_data->get_vf2pf_sources(pmisc_addr);
+
+	if (vf_mask) {
+		struct adf_accel_vf_info *vf_info;
+		int i;
+
+		/* Disable VF2PF interrupts for VFs with pending ints */
+		adf_disable_vf2pf_interrupts_irq(accel_dev, vf_mask);
+
+		/*
+		 * Handle VF2PF interrupt unless the VF is malicious and
+		 * is attempting to flood the host OS with VF2PF interrupts.
+		 */
+		for_each_set_bit(i, &vf_mask, ADF_MAX_NUM_VFS) {
+			vf_info = accel_dev->pf.vf_info + i;
+
+			if (!__ratelimit(&vf_info->vf2pf_ratelimit)) {
+				dev_info(&GET_DEV(accel_dev),
+					 "Too many ints from VF%d\n",
+					  vf_info->vf_nr + 1);
+				continue;
+			}
+
+			adf_schedule_vf2pf_handler(vf_info);
+			irq_handled = true;
+		}
+	}
+	return irq_handled;
+}
+#endif /* CONFIG_PCI_IOV */
+
 static irqreturn_t adf_msix_isr_ae(int irq, void *dev_ptr)
 {
 	struct adf_accel_dev *accel_dev = dev_ptr;
 
 #ifdef CONFIG_PCI_IOV
 	/* If SR-IOV is enabled (vf_info is non-NULL), check for VF->PF ints */
-	if (accel_dev->pf.vf_info) {
-		struct adf_hw_device_data *hw_data = accel_dev->hw_device;
-		struct adf_bar *pmisc =
-			&GET_BARS(accel_dev)[hw_data->get_misc_bar_id(hw_data)];
-		void __iomem *pmisc_addr = pmisc->virt_addr;
-		unsigned long vf_mask;
-
-		/* Get the interrupt sources triggered by VFs */
-		vf_mask = hw_data->get_vf2pf_sources(pmisc_addr);
-
-		if (vf_mask) {
-			struct adf_accel_vf_info *vf_info;
-			bool irq_handled = false;
-			int i;
-
-			/* Disable VF2PF interrupts for VFs with pending ints */
-			adf_disable_vf2pf_interrupts_irq(accel_dev, vf_mask);
-
-			/*
-			 * Handle VF2PF interrupt unless the VF is malicious and
-			 * is attempting to flood the host OS with VF2PF interrupts.
-			 */
-			for_each_set_bit(i, &vf_mask, ADF_MAX_NUM_VFS) {
-				vf_info = accel_dev->pf.vf_info + i;
-
-				if (!__ratelimit(&vf_info->vf2pf_ratelimit)) {
-					dev_info(&GET_DEV(accel_dev),
-						 "Too many ints from VF%d\n",
-						  vf_info->vf_nr + 1);
-					continue;
-				}
-
-				adf_schedule_vf2pf_handler(vf_info);
-				irq_handled = true;
-			}
-
-			if (irq_handled)
-				return IRQ_HANDLED;
-		}
-	}
+	if (accel_dev->pf.vf_info && adf_handle_vf2pf_int(accel_dev))
+		return IRQ_HANDLED;
 #endif /* CONFIG_PCI_IOV */
 
 	dev_dbg(&GET_DEV(accel_dev), "qat_dev%d spurious AE interrupt\n",
-- 
2.33.1

