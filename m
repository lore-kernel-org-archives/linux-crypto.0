From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH  v3 2/4] crypto: qat - add MMP FW support to accel engine
Date: Wed, 15 Jul 2015 15:28:32 -0700
Message-ID: <20150715222832.22719.40084.stgit@tstruk-mobl1>
References: <20150715222821.22719.34149.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com,
	pingchao.yang@intel.com, davem@davemloft.net,
	tadeusz.struk@intel.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:50890 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753699AbbGOW3Y (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 15 Jul 2015 18:29:24 -0400
In-Reply-To: <20150715222821.22719.34149.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add code that loads the MMP firmware

Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 drivers/crypto/qat/qat_common/adf_accel_devices.h  |    2 +
 drivers/crypto/qat/qat_common/adf_accel_engine.c   |   42 ++++++++++++++++++--
 .../crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c |    1 
 .../crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.h |    2 +
 4 files changed, 42 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_accel_devices.h b/drivers/crypto/qat/qat_common/adf_accel_devices.h
index 91c969e..45db8d5 100644
--- a/drivers/crypto/qat/qat_common/adf_accel_devices.h
+++ b/drivers/crypto/qat/qat_common/adf_accel_devices.h
@@ -152,6 +152,7 @@ struct adf_hw_device_data {
 	void (*exit_arb)(struct adf_accel_dev *accel_dev);
 	void (*enable_ints)(struct adf_accel_dev *accel_dev);
 	const char *fw_name;
+	const char *fw_mmp_name;
 	uint32_t pci_dev_id;
 	uint32_t fuses;
 	uint32_t accel_capabilities_mask;
@@ -185,6 +186,7 @@ struct icp_qat_fw_loader_handle;
 struct adf_fw_loader_data {
 	struct icp_qat_fw_loader_handle *fw_loader;
 	const struct firmware *uof_fw;
+	const struct firmware *mmp_fw;
 };
 
 struct adf_accel_dev {
diff --git a/drivers/crypto/qat/qat_common/adf_accel_engine.c b/drivers/crypto/qat/qat_common/adf_accel_engine.c
index fdda8e7..20b08bd 100644
--- a/drivers/crypto/qat/qat_common/adf_accel_engine.c
+++ b/drivers/crypto/qat/qat_common/adf_accel_engine.c
@@ -55,24 +55,36 @@ int adf_ae_fw_load(struct adf_accel_dev *accel_dev)
 {
 	struct adf_fw_loader_data *loader_data = accel_dev->fw_loader;
 	struct adf_hw_device_data *hw_device = accel_dev->hw_device;
-	void *uof_addr;
-	uint32_t uof_size;
+	void *uof_addr, *mmp_addr;
+	u32 uof_size, mmp_size;
 
+	if (!hw_device->fw_name)
+		return 0;
+
+	if (request_firmware(&loader_data->mmp_fw, hw_device->fw_mmp_name,
+			     &accel_dev->accel_pci_dev.pci_dev->dev)) {
+		dev_err(&GET_DEV(accel_dev), "Failed to load MMP firmware %s\n",
+			hw_device->fw_mmp_name);
+		return -EFAULT;
+	}
 	if (request_firmware(&loader_data->uof_fw, hw_device->fw_name,
 			     &accel_dev->accel_pci_dev.pci_dev->dev)) {
-		dev_err(&GET_DEV(accel_dev), "Failed to load firmware %s\n",
+		dev_err(&GET_DEV(accel_dev), "Failed to load UOF firmware %s\n",
 			hw_device->fw_name);
-		return -EFAULT;
+		goto out_err;
 	}
 
 	uof_size = loader_data->uof_fw->size;
 	uof_addr = (void *)loader_data->uof_fw->data;
+	mmp_size = loader_data->mmp_fw->size;
+	mmp_addr = (void *)loader_data->mmp_fw->data;
+	qat_uclo_wr_mimage(loader_data->fw_loader, mmp_addr, mmp_size);
 	if (qat_uclo_map_uof_obj(loader_data->fw_loader, uof_addr, uof_size)) {
 		dev_err(&GET_DEV(accel_dev), "Failed to map UOF\n");
 		goto out_err;
 	}
 	if (qat_uclo_wr_all_uimage(loader_data->fw_loader)) {
-		dev_err(&GET_DEV(accel_dev), "Failed to map UOF\n");
+		dev_err(&GET_DEV(accel_dev), "Failed to load UOF\n");
 		goto out_err;
 	}
 	return 0;
@@ -85,11 +97,17 @@ out_err:
 void adf_ae_fw_release(struct adf_accel_dev *accel_dev)
 {
 	struct adf_fw_loader_data *loader_data = accel_dev->fw_loader;
+	struct adf_hw_device_data *hw_device = accel_dev->hw_device;
+
+	if (!hw_device->fw_name)
+		return;
 
 	qat_uclo_del_uof_obj(loader_data->fw_loader);
 	qat_hal_deinit(loader_data->fw_loader);
 	release_firmware(loader_data->uof_fw);
+	release_firmware(loader_data->mmp_fw);
 	loader_data->uof_fw = NULL;
+	loader_data->mmp_fw = NULL;
 	loader_data->fw_loader = NULL;
 }
 
@@ -99,6 +117,9 @@ int adf_ae_start(struct adf_accel_dev *accel_dev)
 	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
 	uint32_t ae_ctr, ae, max_aes = GET_MAX_ACCELENGINES(accel_dev);
 
+	if (!hw_data->fw_name)
+		return 0;
+
 	for (ae = 0, ae_ctr = 0; ae < max_aes; ae++) {
 		if (hw_data->ae_mask & (1 << ae)) {
 			qat_hal_start(loader_data->fw_loader, ae, 0xFF);
@@ -117,6 +138,9 @@ int adf_ae_stop(struct adf_accel_dev *accel_dev)
 	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
 	uint32_t ae_ctr, ae, max_aes = GET_MAX_ACCELENGINES(accel_dev);
 
+	if (!hw_data->fw_name)
+		return 0;
+
 	for (ae = 0, ae_ctr = 0; ae < max_aes; ae++) {
 		if (hw_data->ae_mask & (1 << ae)) {
 			qat_hal_stop(loader_data->fw_loader, ae, 0xFF);
@@ -143,6 +167,10 @@ static int adf_ae_reset(struct adf_accel_dev *accel_dev, int ae)
 int adf_ae_init(struct adf_accel_dev *accel_dev)
 {
 	struct adf_fw_loader_data *loader_data;
+	struct adf_hw_device_data *hw_device = accel_dev->hw_device;
+
+	if (!hw_device->fw_name)
+		return 0;
 
 	loader_data = kzalloc(sizeof(*loader_data), GFP_KERNEL);
 	if (!loader_data)
@@ -166,6 +194,10 @@ int adf_ae_init(struct adf_accel_dev *accel_dev)
 int adf_ae_shutdown(struct adf_accel_dev *accel_dev)
 {
 	struct adf_fw_loader_data *loader_data = accel_dev->fw_loader;
+	struct adf_hw_device_data *hw_device = accel_dev->hw_device;
+
+	if (!hw_device->fw_name)
+		return 0;
 
 	qat_hal_deinit(loader_data->fw_loader);
 	kfree(accel_dev->fw_loader);
diff --git a/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c b/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
index 7093fc0..eb2f408 100644
--- a/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
+++ b/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
@@ -227,6 +227,7 @@ void adf_init_hw_data_dh895xcc(struct adf_hw_device_data *hw_data)
 	hw_data->get_sram_bar_id = get_sram_bar_id;
 	hw_data->get_sku = get_sku;
 	hw_data->fw_name = ADF_DH895XCC_FW;
+	hw_data->fw_mmp_name = ADF_DH895XCC_MMP;
 	hw_data->init_admin_comms = adf_init_admin_comms;
 	hw_data->exit_admin_comms = adf_exit_admin_comms;
 	hw_data->init_arb = adf_init_arb;
diff --git a/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.h b/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.h
index 87fb1fad..a4963a9 100644
--- a/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.h
+++ b/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.h
@@ -85,5 +85,7 @@
 #define ADF_DH895XCC_ADMINMSGLR_OFFSET (0x3A000 + 0x578)
 #define ADF_DH895XCC_MAILBOX_BASE_OFFSET 0x20970
 #define ADF_DH895XCC_MAILBOX_STRIDE 0x1000
+/* FW names */
 #define ADF_DH895XCC_FW "qat_895xcc.bin"
+#define ADF_DH895XCC_MMP "qat_mmp.bin"
 #endif
