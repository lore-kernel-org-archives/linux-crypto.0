From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH] crypto: qat - zero esram only for DH85x devices
Date: Thu, 22 Dec 2016 15:00:24 +0000
Message-ID: <20161222150024.6122-1-giovanni.cabiddu@intel.com>
Cc: linux-crypto@vger.kernel.org, giovanni.cabiddu@gmail.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:31086 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758567AbcLVPA2 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 22 Dec 2016 10:00:28 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Zero embedded ram in DH85x devices. This is not
needed for newer generations as it is done by HW.

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/qat/qat_common/qat_hal.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/qat_hal.c b/drivers/crypto/qat/qat_common/qat_hal.c
index 1e480f1..8c4fd25 100644
--- a/drivers/crypto/qat/qat_common/qat_hal.c
+++ b/drivers/crypto/qat/qat_common/qat_hal.c
@@ -456,7 +456,7 @@ static int qat_hal_init_esram(struct icp_qat_fw_loader_handle *handle)
 	unsigned int csr_val;
 	int times = 30;
 
-	if (handle->pci_dev->device == ADF_C3XXX_PCI_DEVICE_ID)
+	if (handle->pci_dev->device != ADF_DH895XCC_PCI_DEVICE_ID)
 		return 0;
 
 	csr_val = ADF_CSR_RD(csr_addr, 0);
@@ -716,7 +716,7 @@ int qat_hal_init(struct adf_accel_dev *accel_dev)
 		(void __iomem *)((uintptr_t)handle->hal_cap_ae_xfer_csr_addr_v +
 				 LOCAL_TO_XFER_REG_OFFSET);
 	handle->pci_dev = pci_info->pci_dev;
-	if (handle->pci_dev->device != ADF_C3XXX_PCI_DEVICE_ID) {
+	if (handle->pci_dev->device == ADF_DH895XCC_PCI_DEVICE_ID) {
 		sram_bar =
 			&pci_info->pci_bars[hw_data->get_sram_bar_id(hw_data)];
 		handle->hal_sram_addr_v = sram_bar->virt_addr;
-- 
2.9.3
