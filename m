Return-Path: <SRS0=5ZxX=EM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44953C55179
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Nov 2020 11:29:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EEADC206C1
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Nov 2020 11:29:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727220AbgKFL33 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 6 Nov 2020 06:29:29 -0500
Received: from mga07.intel.com ([134.134.136.100]:59432 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727170AbgKFL33 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 Nov 2020 06:29:29 -0500
IronPort-SDR: in51/2GNbJAn2lajSk6hRy9avGQuOjpNRFDore+isnIzzLQ0dv+FfiFDM7atvkt34PO1BQ3NR8
 NfNbn9csT/8Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9796"; a="233698366"
X-IronPort-AV: E=Sophos;i="5.77,456,1596524400"; 
   d="scan'208";a="233698366"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2020 03:29:28 -0800
IronPort-SDR: /P2Y/mOCB0qYxNoOgQpYaA36/j05G1ESPzUfX7h2CfypqbqYsI/FlJs9/N9Fj7EAIKcrGqv4Sq
 eSJSFoWS9zVg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,456,1596524400"; 
   d="scan'208";a="529779450"
Received: from haps801-neoncity02.sh.intel.com ([10.67.114.160])
  by fmsmga005.fm.intel.com with ESMTP; 06 Nov 2020 03:29:27 -0800
From:   Jack Xu <jack.xu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Jack Xu <jack.xu@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH 32/32] crypto: qat - loader: add gen4 firmware loader
Date:   Fri,  6 Nov 2020 19:28:10 +0800
Message-Id: <20201106112810.2566-33-jack.xu@intel.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20201106112810.2566-1-jack.xu@intel.com>
References: <20201106112810.2566-1-jack.xu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add support for the QAT gen4 devices in the firmware loader.

Signed-off-by: Jack Xu <jack.xu@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 .../crypto/qat/qat_common/adf_accel_devices.h |  2 +
 drivers/crypto/qat/qat_common/icp_qat_hal.h   | 12 ++-
 drivers/crypto/qat/qat_common/icp_qat_uclo.h  |  2 +
 drivers/crypto/qat/qat_common/qat_hal.c       | 77 +++++++++++++++----
 drivers/crypto/qat/qat_common/qat_uclo.c      |  2 +
 5 files changed, 78 insertions(+), 17 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_accel_devices.h b/drivers/crypto/qat/qat_common/adf_accel_devices.h
index 996d25565b11..5694422ec66c 100644
--- a/drivers/crypto/qat/qat_common/adf_accel_devices.h
+++ b/drivers/crypto/qat/qat_common/adf_accel_devices.h
@@ -15,6 +15,8 @@
 #define ADF_C62XVF_DEVICE_NAME "c6xxvf"
 #define ADF_C3XXX_DEVICE_NAME "c3xxx"
 #define ADF_C3XXXVF_DEVICE_NAME "c3xxxvf"
+#define ADF_4XXX_PCI_DEVICE_ID 0x4940
+#define ADF_4XXXIOV_PCI_DEVICE_ID 0x4941
 #define ADF_ERRSOU3 (0x3A000 + 0x0C)
 #define ADF_ERRSOU5 (0x3A000 + 0xD8)
 #define ADF_DEVICE_FUSECTL_OFFSET 0x40
diff --git a/drivers/crypto/qat/qat_common/icp_qat_hal.h b/drivers/crypto/qat/qat_common/icp_qat_hal.h
index 8372f18ebc80..20b2ee1fc65a 100644
--- a/drivers/crypto/qat/qat_common/icp_qat_hal.h
+++ b/drivers/crypto/qat/qat_common/icp_qat_hal.h
@@ -10,6 +10,14 @@ enum hal_global_csr {
 	ICP_GLOBAL_CLK_ENABLE = 0xA50
 };
 
+enum {
+	MISC_CONTROL_C4XXX = 0xAA0,
+	ICP_RESET_CPP0 = 0x938,
+	ICP_RESET_CPP1 = 0x93c,
+	ICP_GLOBAL_CLK_ENABLE_CPP0 = 0x964,
+	ICP_GLOBAL_CLK_ENABLE_CPP1 = 0x968
+};
+
 enum hal_ae_csr {
 	USTORE_ADDRESS = 0x000,
 	USTORE_DATA_LOWER = 0x004,
@@ -111,7 +119,9 @@ enum fcu_sts {
 #define ICP_QAT_CAP_OFFSET (ICP_QAT_AE_OFFSET + 0x10000)
 #define LOCAL_TO_XFER_REG_OFFSET 0x800
 #define ICP_QAT_EP_OFFSET 0x3a000
-
+#define ICP_QAT_EP_OFFSET_4XXX   0x200000 /* HI MMIO CSRs */
+#define ICP_QAT_AE_OFFSET_4XXX   0x600000
+#define ICP_QAT_CAP_OFFSET_4XXX  0x640000
 #define SET_CAP_CSR(handle, csr, val) \
 	ADF_CSR_WR((handle)->hal_cap_g_ctl_csr_addr_v, csr, val)
 #define GET_CAP_CSR(handle, csr) \
diff --git a/drivers/crypto/qat/qat_common/icp_qat_uclo.h b/drivers/crypto/qat/qat_common/icp_qat_uclo.h
index 0ec8a5ab51b5..4b36869bf460 100644
--- a/drivers/crypto/qat/qat_common/icp_qat_uclo.h
+++ b/drivers/crypto/qat/qat_common/icp_qat_uclo.h
@@ -6,6 +6,7 @@
 #define ICP_QAT_AC_895XCC_DEV_TYPE 0x00400000
 #define ICP_QAT_AC_C62X_DEV_TYPE   0x01000000
 #define ICP_QAT_AC_C3XXX_DEV_TYPE  0x02000000
+#define ICP_QAT_AC_4XXX_A_DEV_TYPE 0x08000000
 #define ICP_QAT_UCLO_MAX_AE       12
 #define ICP_QAT_UCLO_MAX_CTX      8
 #define ICP_QAT_UCLO_MAX_UIMAGE   (ICP_QAT_UCLO_MAX_AE * ICP_QAT_UCLO_MAX_CTX)
@@ -13,6 +14,7 @@
 #define ICP_QAT_UCLO_MAX_XFER_REG 128
 #define ICP_QAT_UCLO_MAX_GPR_REG  128
 #define ICP_QAT_UCLO_MAX_LMEM_REG 1024
+#define ICP_QAT_UCLO_MAX_LMEM_REG_2X 1280
 #define ICP_QAT_UCLO_AE_ALL_CTX   0xff
 #define ICP_QAT_UOF_OBJID_LEN     8
 #define ICP_QAT_UOF_FID 0xc6c2
diff --git a/drivers/crypto/qat/qat_common/qat_hal.c b/drivers/crypto/qat/qat_common/qat_hal.c
index a3c1f2163910..bd3028126cbe 100644
--- a/drivers/crypto/qat/qat_common/qat_hal.c
+++ b/drivers/crypto/qat/qat_common/qat_hal.c
@@ -695,6 +695,39 @@ static int qat_hal_chip_init(struct icp_qat_fw_loader_handle *handle,
 
 	handle->pci_dev = pci_info->pci_dev;
 	switch (handle->pci_dev->device) {
+	case ADF_4XXX_PCI_DEVICE_ID:
+		handle->chip_info->sram_visible = false;
+		handle->chip_info->nn = false;
+		handle->chip_info->lm2lm3 = true;
+		handle->chip_info->lm_size = ICP_QAT_UCLO_MAX_LMEM_REG_2X;
+		handle->chip_info->icp_rst_csr = ICP_RESET_CPP0;
+		handle->chip_info->icp_rst_mask = 0x100015;
+		handle->chip_info->glb_clk_enable_csr = ICP_GLOBAL_CLK_ENABLE_CPP0;
+		handle->chip_info->misc_ctl_csr = MISC_CONTROL_C4XXX;
+		handle->chip_info->wakeup_event_val = 0x80000000;
+		handle->chip_info->fw_auth = true;
+		handle->chip_info->css_3k = true;
+		handle->chip_info->tgroup_share_ustore = true;
+		handle->chip_info->fcu_ctl_csr = FCU_CONTROL_4XXX;
+		handle->chip_info->fcu_sts_csr = FCU_STATUS_4XXX;
+		handle->chip_info->fcu_dram_addr_hi = FCU_DRAM_ADDR_HI_4XXX;
+		handle->chip_info->fcu_dram_addr_lo = FCU_DRAM_ADDR_LO_4XXX;
+		handle->chip_info->fcu_loaded_ae_csr = FCU_AE_LOADED_4XXX;
+		handle->chip_info->fcu_loaded_ae_pos = 0;
+
+		handle->hal_cap_g_ctl_csr_addr_v =
+			(void __iomem *)((uintptr_t)misc_bar->virt_addr +
+			ICP_QAT_CAP_OFFSET_4XXX);
+		handle->hal_cap_ae_xfer_csr_addr_v =
+			(void __iomem *)((uintptr_t)misc_bar->virt_addr +
+			ICP_QAT_AE_OFFSET_4XXX);
+		handle->hal_ep_csr_addr_v =
+			(void __iomem *)((uintptr_t)misc_bar->virt_addr +
+			ICP_QAT_EP_OFFSET_4XXX);
+		handle->hal_cap_ae_local_csr_addr_v =
+			(void __iomem *)((uintptr_t)handle->hal_cap_ae_xfer_csr_addr_v
+							+ LOCAL_TO_XFER_REG_OFFSET);
+		break;
 	case PCI_DEVICE_ID_INTEL_QAT_C62X:
 	case PCI_DEVICE_ID_INTEL_QAT_C3XXX:
 		handle->chip_info->sram_visible = false;
@@ -702,6 +735,8 @@ static int qat_hal_chip_init(struct icp_qat_fw_loader_handle *handle,
 		handle->chip_info->lm2lm3 = false;
 		handle->chip_info->lm_size = ICP_QAT_UCLO_MAX_LMEM_REG;
 		handle->chip_info->icp_rst_csr = ICP_RESET;
+		handle->chip_info->icp_rst_mask = (hw_data->ae_mask << RST_CSR_AE_LSB) |
+						  (hw_data->accel_mask << RST_CSR_QAT_LSB);
 		handle->chip_info->glb_clk_enable_csr = ICP_GLOBAL_CLK_ENABLE;
 		handle->chip_info->misc_ctl_csr = MISC_CONTROL;
 		handle->chip_info->wakeup_event_val = WAKEUP_EVENT;
@@ -714,6 +749,18 @@ static int qat_hal_chip_init(struct icp_qat_fw_loader_handle *handle,
 		handle->chip_info->fcu_dram_addr_lo = FCU_DRAM_ADDR_LO;
 		handle->chip_info->fcu_loaded_ae_csr = FCU_STATUS;
 		handle->chip_info->fcu_loaded_ae_pos = FCU_LOADED_AE_POS;
+		handle->hal_cap_g_ctl_csr_addr_v =
+			(void __iomem *)((uintptr_t)misc_bar->virt_addr +
+			ICP_QAT_CAP_OFFSET);
+		handle->hal_cap_ae_xfer_csr_addr_v =
+			(void __iomem *)((uintptr_t)misc_bar->virt_addr +
+			ICP_QAT_AE_OFFSET);
+		handle->hal_ep_csr_addr_v =
+			(void __iomem *)((uintptr_t)misc_bar->virt_addr +
+			ICP_QAT_EP_OFFSET);
+		handle->hal_cap_ae_local_csr_addr_v =
+			(void __iomem *)((uintptr_t)handle->hal_cap_ae_xfer_csr_addr_v
+			+ LOCAL_TO_XFER_REG_OFFSET);
 		break;
 	case PCI_DEVICE_ID_INTEL_QAT_DH895XCC:
 		handle->chip_info->sram_visible = true;
@@ -721,6 +768,8 @@ static int qat_hal_chip_init(struct icp_qat_fw_loader_handle *handle,
 		handle->chip_info->lm2lm3 = false;
 		handle->chip_info->lm_size = ICP_QAT_UCLO_MAX_LMEM_REG;
 		handle->chip_info->icp_rst_csr = ICP_RESET;
+		handle->chip_info->icp_rst_mask = (hw_data->ae_mask << RST_CSR_AE_LSB) |
+						  (hw_data->accel_mask << RST_CSR_QAT_LSB);
 		handle->chip_info->glb_clk_enable_csr = ICP_GLOBAL_CLK_ENABLE;
 		handle->chip_info->misc_ctl_csr = MISC_CONTROL;
 		handle->chip_info->wakeup_event_val = WAKEUP_EVENT;
@@ -733,6 +782,18 @@ static int qat_hal_chip_init(struct icp_qat_fw_loader_handle *handle,
 		handle->chip_info->fcu_dram_addr_lo = 0;
 		handle->chip_info->fcu_loaded_ae_csr = 0;
 		handle->chip_info->fcu_loaded_ae_pos = 0;
+		handle->hal_cap_g_ctl_csr_addr_v =
+			(void __iomem *)((uintptr_t)misc_bar->virt_addr +
+			ICP_QAT_CAP_OFFSET);
+		handle->hal_cap_ae_xfer_csr_addr_v =
+			(void __iomem *)((uintptr_t)misc_bar->virt_addr +
+			ICP_QAT_AE_OFFSET);
+		handle->hal_ep_csr_addr_v =
+			(void __iomem *)((uintptr_t)misc_bar->virt_addr +
+			ICP_QAT_EP_OFFSET);
+		handle->hal_cap_ae_local_csr_addr_v =
+			(void __iomem *)((uintptr_t)handle->hal_cap_ae_xfer_csr_addr_v
+			+ LOCAL_TO_XFER_REG_OFFSET);
 		break;
 	default:
 		ret = -EINVAL;
@@ -744,22 +805,6 @@ static int qat_hal_chip_init(struct icp_qat_fw_loader_handle *handle,
 			&pci_info->pci_bars[hw_data->get_sram_bar_id(hw_data)];
 		handle->hal_sram_addr_v = sram_bar->virt_addr;
 	}
-
-	handle->chip_info->icp_rst_mask = (hw_data->ae_mask << RST_CSR_AE_LSB) |
-					  (hw_data->accel_mask << RST_CSR_QAT_LSB);
-	handle->hal_cap_g_ctl_csr_addr_v =
-		(void __iomem *)((uintptr_t)misc_bar->virt_addr +
-				 ICP_QAT_CAP_OFFSET);
-	handle->hal_cap_ae_xfer_csr_addr_v =
-		(void __iomem *)((uintptr_t)misc_bar->virt_addr +
-				 ICP_QAT_AE_OFFSET);
-	handle->hal_ep_csr_addr_v =
-		(void __iomem *)((uintptr_t)misc_bar->virt_addr +
-				 ICP_QAT_EP_OFFSET);
-	handle->hal_cap_ae_local_csr_addr_v =
-		(void __iomem *)((uintptr_t)handle->hal_cap_ae_xfer_csr_addr_v +
-				 LOCAL_TO_XFER_REG_OFFSET);
-	handle->pci_dev = pci_info->pci_dev;
 	handle->hal_handle->revision_id = accel_dev->accel_pci_dev.revid;
 	handle->hal_handle->ae_mask = hw_data->ae_mask;
 	handle->hal_handle->admin_ae_mask = hw_data->admin_ae_mask;
diff --git a/drivers/crypto/qat/qat_common/qat_uclo.c b/drivers/crypto/qat/qat_common/qat_uclo.c
index c089c2709376..1fb5fc852f6b 100644
--- a/drivers/crypto/qat/qat_common/qat_uclo.c
+++ b/drivers/crypto/qat/qat_common/qat_uclo.c
@@ -728,6 +728,8 @@ qat_uclo_get_dev_type(struct icp_qat_fw_loader_handle *handle)
 		return ICP_QAT_AC_C62X_DEV_TYPE;
 	case PCI_DEVICE_ID_INTEL_QAT_C3XXX:
 		return ICP_QAT_AC_C3XXX_DEV_TYPE;
+	case ADF_4XXX_PCI_DEVICE_ID:
+		return ICP_QAT_AC_4XXX_A_DEV_TYPE;
 	default:
 		pr_err("QAT: unsupported device 0x%x\n",
 		       handle->pci_dev->device);
-- 
2.25.4

