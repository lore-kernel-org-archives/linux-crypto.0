From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH  v2 1/3] crypto: qat - add support for MMP FW
Date: Tue, 14 Jul 2015 11:32:48 -0700
Message-ID: <20150714183248.18949.5966.stgit@tstruk-mobl1>
References: <20150714183243.18949.93255.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com,
	pingchao.yang@intel.com, davem@davemloft.net,
	tadeusz.struk@intel.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:21791 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752829AbbGNSdR (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 14 Jul 2015 14:33:17 -0400
In-Reply-To: <20150714183243.18949.93255.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Pingchao Yang <pingchao.yang@intel.com>

Load Modular Math Processor(MMP) firmware into QAT devices to support
public key algorithm acceleration.

Signed-off-by: Pingchao Yang <pingchao.yang@intel.com>
Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 drivers/crypto/qat/qat_common/adf_accel_devices.h  |    1 +
 drivers/crypto/qat/qat_common/adf_common_drv.h     |    2 +
 drivers/crypto/qat/qat_common/qat_hal.c            |   13 ++++++----
 drivers/crypto/qat/qat_common/qat_uclo.c           |   27 ++++----------------
 .../crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c |    6 ++++
 .../crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.h |    1 +
 6 files changed, 24 insertions(+), 26 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_accel_devices.h b/drivers/crypto/qat/qat_common/adf_accel_devices.h
index 5fe9029..91c969e 100644
--- a/drivers/crypto/qat/qat_common/adf_accel_devices.h
+++ b/drivers/crypto/qat/qat_common/adf_accel_devices.h
@@ -135,6 +135,7 @@ struct adf_hw_device_data {
 	struct adf_hw_device_class *dev_class;
 	uint32_t (*get_accel_mask)(uint32_t fuse);
 	uint32_t (*get_ae_mask)(uint32_t fuse);
+	uint32_t (*get_sram_bar_id)(struct adf_hw_device_data *self);
 	uint32_t (*get_misc_bar_id)(struct adf_hw_device_data *self);
 	uint32_t (*get_etr_bar_id)(struct adf_hw_device_data *self);
 	uint32_t (*get_num_aes)(struct adf_hw_device_data *self);
diff --git a/drivers/crypto/qat/qat_common/adf_common_drv.h b/drivers/crypto/qat/qat_common/adf_common_drv.h
index 27e16c0..1e82ad4 100644
--- a/drivers/crypto/qat/qat_common/adf_common_drv.h
+++ b/drivers/crypto/qat/qat_common/adf_common_drv.h
@@ -196,4 +196,6 @@ int qat_uclo_wr_all_uimage(struct icp_qat_fw_loader_handle *handle);
 void qat_uclo_del_uof_obj(struct icp_qat_fw_loader_handle *handle);
 int qat_uclo_map_uof_obj(struct icp_qat_fw_loader_handle *handle,
 			 void *addr_ptr, int mem_size);
+void qat_uclo_wr_mimage(struct icp_qat_fw_loader_handle *handle,
+			void *addr_ptr, int mem_size);
 #endif
diff --git a/drivers/crypto/qat/qat_common/qat_hal.c b/drivers/crypto/qat/qat_common/qat_hal.c
index 274ff7e..1d6d289 100644
--- a/drivers/crypto/qat/qat_common/qat_hal.c
+++ b/drivers/crypto/qat/qat_common/qat_hal.c
@@ -679,21 +679,24 @@ int qat_hal_init(struct adf_accel_dev *accel_dev)
 	struct icp_qat_fw_loader_handle *handle;
 	struct adf_accel_pci *pci_info = &accel_dev->accel_pci_dev;
 	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
-	struct adf_bar *bar =
+	struct adf_bar *misc_bar =
 			&pci_info->pci_bars[hw_data->get_misc_bar_id(hw_data)];
+	struct adf_bar *sram_bar =
+			&pci_info->pci_bars[hw_data->get_sram_bar_id(hw_data)];
 
 	handle = kzalloc(sizeof(*handle), GFP_KERNEL);
 	if (!handle)
 		return -ENOMEM;
 
-	handle->hal_cap_g_ctl_csr_addr_v = bar->virt_addr +
+	handle->hal_cap_g_ctl_csr_addr_v = misc_bar->virt_addr +
 						ICP_DH895XCC_CAP_OFFSET;
-	handle->hal_cap_ae_xfer_csr_addr_v = bar->virt_addr +
+	handle->hal_cap_ae_xfer_csr_addr_v = misc_bar->virt_addr +
 						ICP_DH895XCC_AE_OFFSET;
-	handle->hal_ep_csr_addr_v = bar->virt_addr + ICP_DH895XCC_EP_OFFSET;
+	handle->hal_ep_csr_addr_v = misc_bar->virt_addr +
+				    ICP_DH895XCC_EP_OFFSET;
 	handle->hal_cap_ae_local_csr_addr_v =
 		handle->hal_cap_ae_xfer_csr_addr_v + LOCAL_TO_XFER_REG_OFFSET;
-
+	handle->hal_sram_addr_v = sram_bar->virt_addr;
 	handle->hal_handle = kzalloc(sizeof(*handle->hal_handle), GFP_KERNEL);
 	if (!handle->hal_handle)
 		goto out_hal_handle;
diff --git a/drivers/crypto/qat/qat_common/qat_uclo.c b/drivers/crypto/qat/qat_common/qat_uclo.c
index 1e27f9f..c48f181 100644
--- a/drivers/crypto/qat/qat_common/qat_uclo.c
+++ b/drivers/crypto/qat/qat_common/qat_uclo.c
@@ -359,28 +359,7 @@ static int qat_uclo_init_umem_seg(struct icp_qat_fw_loader_handle *handle,
 static int qat_uclo_init_ae_memory(struct icp_qat_fw_loader_handle *handle,
 				   struct icp_qat_uof_initmem *init_mem)
 {
-	unsigned int i;
-	struct icp_qat_uof_memvar_attr *mem_val_attr;
-
-	mem_val_attr =
-		(struct icp_qat_uof_memvar_attr *)((unsigned long)init_mem +
-		sizeof(struct icp_qat_uof_initmem));
-
 	switch (init_mem->region) {
-	case ICP_QAT_UOF_SRAM_REGION:
-		if ((init_mem->addr + init_mem->num_in_bytes) >
-		    ICP_DH895XCC_PESRAM_BAR_SIZE) {
-			pr_err("QAT: initmem on SRAM is out of range");
-			return -EINVAL;
-		}
-		for (i = 0; i < init_mem->val_attr_num; i++) {
-			qat_uclo_wr_sram_by_words(handle,
-						  init_mem->addr +
-						  mem_val_attr->offset_in_byte,
-						  &mem_val_attr->value, 4);
-			mem_val_attr++;
-		}
-		break;
 	case ICP_QAT_UOF_LMEM_REGION:
 		if (qat_uclo_init_lmem_seg(handle, init_mem))
 			return -EINVAL;
@@ -990,6 +969,12 @@ out_err:
 	return -EFAULT;
 }
 
+void qat_uclo_wr_mimage(struct icp_qat_fw_loader_handle *handle,
+			void *addr_ptr, int mem_size)
+{
+	qat_uclo_wr_sram_by_words(handle, 0, addr_ptr, ALIGN(mem_size, 4));
+}
+
 int qat_uclo_map_uof_obj(struct icp_qat_fw_loader_handle *handle,
 			 void *addr_ptr, int mem_size)
 {
diff --git a/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c b/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
index b138692..7093fc0 100644
--- a/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
+++ b/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
@@ -117,6 +117,11 @@ static uint32_t get_etr_bar_id(struct adf_hw_device_data *self)
 	return ADF_DH895XCC_ETR_BAR;
 }
 
+static uint32_t get_sram_bar_id(struct adf_hw_device_data *self)
+{
+	return ADF_DH895XCC_SRAM_BAR;
+}
+
 static enum dev_sku_info get_sku(struct adf_hw_device_data *self)
 {
 	int sku = (self->fuses & ADF_DH895XCC_FUSECTL_SKU_MASK)
@@ -219,6 +224,7 @@ void adf_init_hw_data_dh895xcc(struct adf_hw_device_data *hw_data)
 	hw_data->get_num_aes = get_num_aes;
 	hw_data->get_etr_bar_id = get_etr_bar_id;
 	hw_data->get_misc_bar_id = get_misc_bar_id;
+	hw_data->get_sram_bar_id = get_sram_bar_id;
 	hw_data->get_sku = get_sku;
 	hw_data->fw_name = ADF_DH895XCC_FW;
 	hw_data->init_admin_comms = adf_init_admin_comms;
diff --git a/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.h b/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.h
index 25269a9..87fb1fad 100644
--- a/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.h
+++ b/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.h
@@ -48,6 +48,7 @@
 #define ADF_DH895x_HW_DATA_H_
 
 /* PCIe configuration space */
+#define ADF_DH895XCC_SRAM_BAR 0
 #define ADF_DH895XCC_PMISC_BAR 1
 #define ADF_DH895XCC_ETR_BAR 2
 #define ADF_DH895XCC_RX_RINGS_OFFSET 8
