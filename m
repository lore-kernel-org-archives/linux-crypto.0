From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH] crypto: qat - Move BAR definitions to device specific module
Date: Tue, 21 Oct 2014 11:01:06 -0700
Message-ID: <20141021180106.21289.79724.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	qat-linux@intel.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:32275 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751561AbaJUSa2 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 21 Oct 2014 14:30:28 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Move PCI BARs definitions to device specific module where it belongs.

Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 drivers/crypto/qat/qat_common/adf_accel_devices.h  |    2 --
 drivers/crypto/qat/qat_common/qat_hal.c            |    3 ++-
 .../crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.h |    2 ++
 3 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_accel_devices.h b/drivers/crypto/qat/qat_common/adf_accel_devices.h
index fe7b3f0..2ed4256 100644
--- a/drivers/crypto/qat/qat_common/adf_accel_devices.h
+++ b/drivers/crypto/qat/qat_common/adf_accel_devices.h
@@ -56,8 +56,6 @@
 #define PCI_VENDOR_ID_INTEL 0x8086
 #define ADF_DH895XCC_DEVICE_NAME "dh895xcc"
 #define ADF_DH895XCC_PCI_DEVICE_ID 0x435
-#define ADF_DH895XCC_PMISC_BAR 1
-#define ADF_DH895XCC_ETR_BAR 2
 #define ADF_PCI_MAX_BARS 3
 #define ADF_DEVICE_NAME_LENGTH 32
 #define ADF_ETR_MAX_RINGS_PER_BANK 16
diff --git a/drivers/crypto/qat/qat_common/qat_hal.c b/drivers/crypto/qat/qat_common/qat_hal.c
index 9b8a315..b818c19 100644
--- a/drivers/crypto/qat/qat_common/qat_hal.c
+++ b/drivers/crypto/qat/qat_common/qat_hal.c
@@ -679,7 +679,8 @@ int qat_hal_init(struct adf_accel_dev *accel_dev)
 	struct icp_qat_fw_loader_handle *handle;
 	struct adf_accel_pci *pci_info = &accel_dev->accel_pci_dev;
 	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
-	struct adf_bar *bar = &pci_info->pci_bars[ADF_DH895XCC_PMISC_BAR];
+	struct adf_bar *bar =
+			&pci_info->pci_bars[hw_data->get_misc_bar_id(hw_data)];
 
 	handle = kzalloc(sizeof(*handle), GFP_KERNEL);
 	if (!handle)
diff --git a/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.h b/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.h
index 65dd1ff..01e0be2 100644
--- a/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.h
+++ b/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.h
@@ -48,6 +48,8 @@
 #define ADF_DH895x_HW_DATA_H_
 
 /* PCIe configuration space */
+#define ADF_DH895XCC_PMISC_BAR 1
+#define ADF_DH895XCC_ETR_BAR 2
 #define ADF_DH895XCC_RX_RINGS_OFFSET 8
 #define ADF_DH895XCC_TX_RINGS_MASK 0xFF
 #define ADF_DH895XCC_FUSECTL_OFFSET 0x40
