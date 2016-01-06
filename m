From: Yang Pingchao <pingchao.yang@intel.com>
Subject: [PATCH] crypto: qat - remove to call get_sram_bar_id for qat_c3xxx
Date: Wed,  6 Jan 2016 17:56:34 +0800
Message-ID: <1452074194-115019-1-git-send-email-pingchao.yang@intel.com>
Cc: tadeusz.struk@intel.com, linux-crypto@vger.kernel.org,
	qat-linux@intel.com, Pingchao Yang <pingchao.yang@intel.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:25106 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752098AbcAFJ4h (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 6 Jan 2016 04:56:37 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Pingchao Yang <pingchao.yang@intel.com>

Reported-by : Struk, Tadeusz <tadeusz.struk@intel.com>
Signed-off-by: Yang Pingchao <pingchao.yang@intel.com>
---
 drivers/crypto/qat/qat_common/qat_hal.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/qat_hal.c b/drivers/crypto/qat/qat_common/qat_hal.c
index 0d0b5ed..bcb39b0 100644
--- a/drivers/crypto/qat/qat_common/qat_hal.c
+++ b/drivers/crypto/qat/qat_common/qat_hal.c
@@ -693,14 +693,12 @@ int qat_hal_init(struct adf_accel_dev *accel_dev)
 	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
 	struct adf_bar *misc_bar =
 			&pci_info->pci_bars[hw_data->get_misc_bar_id(hw_data)];
-	struct adf_bar *sram_bar =
-			&pci_info->pci_bars[hw_data->get_sram_bar_id(hw_data)];
+	struct adf_bar *sram_bar;
 
 	handle = kzalloc(sizeof(*handle), GFP_KERNEL);
 	if (!handle)
 		return -ENOMEM;
 
-	handle->hal_sram_addr_v = sram_bar->virt_addr;
 	handle->hal_cap_g_ctl_csr_addr_v =
 		(void __iomem *)((uintptr_t)misc_bar->virt_addr +
 				 ICP_QAT_CAP_OFFSET);
@@ -714,6 +712,11 @@ int qat_hal_init(struct adf_accel_dev *accel_dev)
 		(void __iomem *)((uintptr_t)handle->hal_cap_ae_xfer_csr_addr_v +
 				 LOCAL_TO_XFER_REG_OFFSET);
 	handle->pci_dev = pci_info->pci_dev;
+	if (handle->pci_dev->device != ADF_C3XXX_PCI_DEVICE_ID) {
+		sram_bar =
+			&pci_info->pci_bars[hw_data->get_sram_bar_id(hw_data)];
+		handle->hal_sram_addr_v = sram_bar->virt_addr;
+	}
 	handle->fw_auth = (handle->pci_dev->device ==
 			   ADF_DH895XCC_PCI_DEVICE_ID) ? false : true;
 	handle->hal_handle = kzalloc(sizeof(*handle->hal_handle), GFP_KERNEL);
-- 
2.6.4
