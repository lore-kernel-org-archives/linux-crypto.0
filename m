From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH] crypto: qat - remove redundant struct elem
Date: Fri, 24 Jul 2015 13:18:25 -0700
Message-ID: <20150724201825.27602.85101.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org,
	Bruce Allan <bruce.w.allan@intel.com>, qat-linux@intel.com,
	tadeusz.struk@intel.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:58767 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753422AbbGXUTG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 24 Jul 2015 16:19:06 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Bruce Allan <bruce.w.allan@intel.com>

The element pci_dev_id in the struct adf_hw_device_data is redundant since
the PCI device id can be retrieved from the struct pci_dev.

Signed-off-by: Bruce Allan <bruce.w.allan@intel.com>
Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 drivers/crypto/qat/qat_common/adf_accel_devices.h  |    1 -
 .../crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c |    1 -
 drivers/crypto/qat/qat_dh895xcc/adf_drv.c          |    2 +-
 3 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_accel_devices.h b/drivers/crypto/qat/qat_common/adf_accel_devices.h
index 45db8d5..99cbce6 100644
--- a/drivers/crypto/qat/qat_common/adf_accel_devices.h
+++ b/drivers/crypto/qat/qat_common/adf_accel_devices.h
@@ -153,7 +153,6 @@ struct adf_hw_device_data {
 	void (*enable_ints)(struct adf_accel_dev *accel_dev);
 	const char *fw_name;
 	const char *fw_mmp_name;
-	uint32_t pci_dev_id;
 	uint32_t fuses;
 	uint32_t accel_capabilities_mask;
 	uint16_t accel_mask;
diff --git a/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c b/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
index eb2f408..155ace9 100644
--- a/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
+++ b/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
@@ -208,7 +208,6 @@ void adf_init_hw_data_dh895xcc(struct adf_hw_device_data *hw_data)
 	hw_data->instance_id = dh895xcc_class.instances++;
 	hw_data->num_banks = ADF_DH895XCC_ETR_MAX_BANKS;
 	hw_data->num_accel = ADF_DH895XCC_MAX_ACCELERATORS;
-	hw_data->pci_dev_id = ADF_DH895XCC_PCI_DEVICE_ID;
 	hw_data->num_logical_accel = 1;
 	hw_data->num_engines = ADF_DH895XCC_MAX_ACCELENGINES;
 	hw_data->tx_rx_gap = ADF_DH895XCC_RX_RINGS_OFFSET;
diff --git a/drivers/crypto/qat/qat_dh895xcc/adf_drv.c b/drivers/crypto/qat/qat_dh895xcc/adf_drv.c
index d241037..4abeca1 100644
--- a/drivers/crypto/qat/qat_dh895xcc/adf_drv.c
+++ b/drivers/crypto/qat/qat_dh895xcc/adf_drv.c
@@ -100,7 +100,7 @@ static void adf_cleanup_accel(struct adf_accel_dev *accel_dev)
 	}
 
 	if (accel_dev->hw_device) {
-		switch (accel_dev->hw_device->pci_dev_id) {
+		switch (accel_pci_dev->pci_dev->device) {
 		case ADF_DH895XCC_PCI_DEVICE_ID:
 			adf_clean_hw_data_dh895xcc(accel_dev->hw_device);
 			break;
