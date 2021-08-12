Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFBF5C4338F
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Aug 2021 20:22:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D2A4060EB2
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Aug 2021 20:22:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237100AbhHLUW1 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 12 Aug 2021 16:22:27 -0400
Received: from mga03.intel.com ([134.134.136.65]:4154 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236956AbhHLUWZ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Aug 2021 16:22:25 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10074"; a="215474039"
X-IronPort-AV: E=Sophos;i="5.84,316,1620716400"; 
   d="scan'208";a="215474039"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2021 13:21:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,316,1620716400"; 
   d="scan'208";a="517608642"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.51])
  by FMSMGA003.fm.intel.com with ESMTP; 12 Aug 2021 13:21:57 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Marco Chiappero <marco.chiappero@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Fiona Trahe <fiona.trahe@intel.com>
Subject: [PATCH 11/20] crypto: qat - move pf2vf interrupt [en|dis]able to adf_vf_isr.c
Date:   Thu, 12 Aug 2021 21:21:20 +0100
Message-Id: <20210812202129.18831-12-giovanni.cabiddu@intel.com>
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

Interrupt code to enable interrupts from PF does not belong to the
protocol code, so move it to the interrupt handling specific file for
better code organization.

Signed-off-by: Marco Chiappero <marco.chiappero@intel.com>
Co-developed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Fiona Trahe <fiona.trahe@intel.com>
---
 drivers/crypto/qat/qat_common/adf_pf2vf_msg.c | 20 -------------------
 drivers/crypto/qat/qat_common/adf_vf_isr.c    | 20 +++++++++++++++++++
 2 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c b/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
index d42461cb611f..0a927ed91b19 100644
--- a/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
+++ b/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
@@ -11,26 +11,6 @@
 #define ADF_DH895XCC_ERRMSK5	(ADF_DH895XCC_EP_OFFSET + 0xDC)
 #define ADF_DH895XCC_ERRMSK5_VF2PF_U_MASK(vf_mask) (vf_mask >> 16)
 
-void adf_enable_pf2vf_interrupts(struct adf_accel_dev *accel_dev)
-{
-	struct adf_accel_pci *pci_info = &accel_dev->accel_pci_dev;
-	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
-	void __iomem *pmisc_bar_addr =
-		pci_info->pci_bars[hw_data->get_misc_bar_id(hw_data)].virt_addr;
-
-	ADF_CSR_WR(pmisc_bar_addr, hw_data->get_vintmsk_offset(0), 0x0);
-}
-
-void adf_disable_pf2vf_interrupts(struct adf_accel_dev *accel_dev)
-{
-	struct adf_accel_pci *pci_info = &accel_dev->accel_pci_dev;
-	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
-	void __iomem *pmisc_bar_addr =
-		pci_info->pci_bars[hw_data->get_misc_bar_id(hw_data)].virt_addr;
-
-	ADF_CSR_WR(pmisc_bar_addr, hw_data->get_vintmsk_offset(0), 0x2);
-}
-
 void adf_enable_vf2pf_interrupts(struct adf_accel_dev *accel_dev,
 				 u32 vf_mask)
 {
diff --git a/drivers/crypto/qat/qat_common/adf_vf_isr.c b/drivers/crypto/qat/qat_common/adf_vf_isr.c
index 4359ca633ea9..aa44e8638fa8 100644
--- a/drivers/crypto/qat/qat_common/adf_vf_isr.c
+++ b/drivers/crypto/qat/qat_common/adf_vf_isr.c
@@ -29,6 +29,26 @@ struct adf_vf_stop_data {
 	struct work_struct work;
 };
 
+void adf_enable_pf2vf_interrupts(struct adf_accel_dev *accel_dev)
+{
+	struct adf_accel_pci *pci_info = &accel_dev->accel_pci_dev;
+	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
+	void __iomem *pmisc_bar_addr =
+		pci_info->pci_bars[hw_data->get_misc_bar_id(hw_data)].virt_addr;
+
+	ADF_CSR_WR(pmisc_bar_addr, hw_data->get_vintmsk_offset(0), 0x0);
+}
+
+void adf_disable_pf2vf_interrupts(struct adf_accel_dev *accel_dev)
+{
+	struct adf_accel_pci *pci_info = &accel_dev->accel_pci_dev;
+	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
+	void __iomem *pmisc_bar_addr =
+		pci_info->pci_bars[hw_data->get_misc_bar_id(hw_data)].virt_addr;
+
+	ADF_CSR_WR(pmisc_bar_addr, hw_data->get_vintmsk_offset(0), 0x2);
+}
+
 static int adf_enable_msi(struct adf_accel_dev *accel_dev)
 {
 	struct adf_accel_pci *pci_dev_info = &accel_dev->accel_pci_dev;
-- 
2.31.1

