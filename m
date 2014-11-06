From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH RFC 2/4] crypto: qat - Add PKE firmware
Date: Thu, 06 Nov 2014 11:59:43 -0800
Message-ID: <20141106195943.13328.16230.stgit@tstruk-mobl1>
References: <20141106195931.13328.90501.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	qat-linux@intel.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:20801 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750877AbaKFUCO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 6 Nov 2014 15:02:14 -0500
In-Reply-To: <20141106195931.13328.90501.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add PKE firmware header file and code that loads the PKE firmware.

Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 drivers/crypto/qat/qat_common/adf_accel_devices.h |    4 +
 drivers/crypto/qat/qat_common/adf_accel_engine.c  |   44 ++++++++-
 drivers/crypto/qat/qat_common/adf_ctl_drv.c       |    1 
 drivers/crypto/qat/qat_common/icp_qat_fw_pke.h    |   99 +++++++++++++++++++++
 4 files changed, 144 insertions(+), 4 deletions(-)
 create mode 100644 drivers/crypto/qat/qat_common/icp_qat_fw_pke.h

diff --git a/drivers/crypto/qat/qat_common/adf_accel_devices.h b/drivers/crypto/qat/qat_common/adf_accel_devices.h
index 2ed4256..9586e5e 100644
--- a/drivers/crypto/qat/qat_common/adf_accel_devices.h
+++ b/drivers/crypto/qat/qat_common/adf_accel_devices.h
@@ -182,6 +182,10 @@ struct icp_qat_fw_loader_handle;
 struct adf_fw_loader_data {
 	struct icp_qat_fw_loader_handle *fw_loader;
 	const struct firmware *uof_fw;
+	const struct firmware *mmp_fw;
+	char *mmp_vaddr;
+	dma_addr_t mmp_addr;
+	size_t mmp_fw_size;
 };
 
 struct adf_accel_dev {
diff --git a/drivers/crypto/qat/qat_common/adf_accel_engine.c b/drivers/crypto/qat/qat_common/adf_accel_engine.c
index c77453b..e9e131b 100644
--- a/drivers/crypto/qat/qat_common/adf_accel_engine.c
+++ b/drivers/crypto/qat/qat_common/adf_accel_engine.c
@@ -51,6 +51,8 @@
 #include "adf_common_drv.h"
 #include "icp_qat_uclo.h"
 
+#define ADF_QAT_MMP_FW "qat_mmp.bin"
+
 int adf_ae_fw_load(struct adf_accel_dev *accel_dev)
 {
 	struct adf_fw_loader_data *loader_data = accel_dev->fw_loader;
@@ -63,20 +65,51 @@ int adf_ae_fw_load(struct adf_accel_dev *accel_dev)
 		pr_err("QAT: Failed to load firmware %s\n", hw_device->fw_name);
 		return -EFAULT;
 	}
-
+	if (request_firmware(&loader_data->mmp_fw, ADF_QAT_MMP_FW,
+			     &accel_dev->accel_pci_dev.pci_dev->dev)) {
+		pr_err("QAT: Failed to load firmware %s\n", ADF_QAT_MMP_FW);
+		goto err_uof;
+	}
 	uof_size = loader_data->uof_fw->size;
 	uof_addr = (void *)loader_data->uof_fw->data;
+	loader_data->mmp_vaddr = kmalloc_node(loader_data->mmp_fw->size,
+					      GFP_KERNEL,
+					      dev_to_node(&GET_DEV(accel_dev)));
+	if (!loader_data->mmp_vaddr)
+		goto err_mmp;
+
+	loader_data->mmp_fw_size = loader_data->mmp_fw->size;
+	memcpy(loader_data->mmp_vaddr, loader_data->mmp_fw->data,
+	       loader_data->mmp_fw_size);
+	loader_data->mmp_addr = dma_map_single(&GET_DEV(accel_dev),
+					       (void *)loader_data->mmp_vaddr,
+					       loader_data->mmp_fw->size,
+					       DMA_TO_DEVICE);
+	if (dma_mapping_error(&GET_DEV(accel_dev), loader_data->mmp_addr)) {
+		pr_err("QAT: Failed to dmamap MMP fw\n");
+		goto err_free;
+	}
 	if (qat_uclo_map_uof_obj(loader_data->fw_loader, uof_addr, uof_size)) {
 		pr_err("QAT: Failed to map UOF\n");
-		goto out_err;
+		goto err_dma_map;
 	}
 	if (qat_uclo_wr_all_uimage(loader_data->fw_loader)) {
 		pr_err("QAT: Failed to map UOF\n");
-		goto out_err;
+		goto uclo_del_obj;
 	}
+	release_firmware(loader_data->mmp_fw);
 	return 0;
 
-out_err:
+uclo_del_obj:
+	qat_uclo_del_uof_obj(loader_data->fw_loader);
+err_dma_map:
+	dma_unmap_single(&GET_DEV(accel_dev), loader_data->mmp_addr,
+			 loader_data->mmp_fw->size, DMA_TO_DEVICE);
+err_free:
+	kfree(loader_data->mmp_vaddr);
+err_mmp:
+	release_firmware(loader_data->mmp_fw);
+err_uof:
 	release_firmware(loader_data->uof_fw);
 	return -EFAULT;
 }
@@ -85,6 +118,9 @@ int adf_ae_fw_release(struct adf_accel_dev *accel_dev)
 {
 	struct adf_fw_loader_data *loader_data = accel_dev->fw_loader;
 
+	dma_unmap_single(&GET_DEV(accel_dev), loader_data->mmp_addr,
+			 loader_data->mmp_fw_size, DMA_TO_DEVICE);
+	kfree(loader_data->mmp_vaddr);
 	release_firmware(loader_data->uof_fw);
 	qat_uclo_del_uof_obj(loader_data->fw_loader);
 	qat_hal_deinit(loader_data->fw_loader);
diff --git a/drivers/crypto/qat/qat_common/adf_ctl_drv.c b/drivers/crypto/qat/qat_common/adf_ctl_drv.c
index 244d733..a660539 100644
--- a/drivers/crypto/qat/qat_common/adf_ctl_drv.c
+++ b/drivers/crypto/qat/qat_common/adf_ctl_drv.c
@@ -486,5 +486,6 @@ module_init(adf_register_ctl_device_driver);
 module_exit(adf_unregister_ctl_device_driver);
 MODULE_LICENSE("Dual BSD/GPL");
 MODULE_AUTHOR("Intel");
+MODULE_FIRMWARE("qat_mmp.bin");
 MODULE_DESCRIPTION("Intel(R) QuickAssist Technology");
 MODULE_ALIAS("intel_qat");
diff --git a/drivers/crypto/qat/qat_common/icp_qat_fw_pke.h b/drivers/crypto/qat/qat_common/icp_qat_fw_pke.h
new file mode 100644
index 0000000..4b8910f
--- /dev/null
+++ b/drivers/crypto/qat/qat_common/icp_qat_fw_pke.h
@@ -0,0 +1,99 @@
+/*
+  This file is provided under a dual BSD/GPLv2 license.  When using or
+  redistributing this file, you may do so under either license.
+
+  GPL LICENSE SUMMARY
+  Copyright(c) 2014 Intel Corporation.
+  This program is free software; you can redistribute it and/or modify
+  it under the terms of version 2 of the GNU General Public License as
+  published by the Free Software Foundation.
+
+  This program is distributed in the hope that it will be useful, but
+  WITHOUT ANY WARRANTY; without even the implied warranty of
+  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+  General Public License for more details.
+
+  Contact Information:
+  qat-linux@intel.com
+
+  BSD LICENSE
+  Copyright(c) 2014 Intel Corporation.
+  Redistribution and use in source and binary forms, with or without
+  modification, are permitted provided that the following conditions
+  are met:
+
+	* Redistributions of source code must retain the above copyright
+	  notice, this list of conditions and the following disclaimer.
+	* Redistributions in binary form must reproduce the above copyright
+	  notice, this list of conditions and the following disclaimer in
+	  the documentation and/or other materials provided with the
+	  distribution.
+	* Neither the name of Intel Corporation nor the names of its
+	  contributors may be used to endorse or promote products derived
+	  from this software without specific prior written permission.
+
+  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+  OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+*/
+#ifndef _ICP_QAT_FW_PKE_
+#define _ICP_QAT_FW_PKE_
+
+#include "icp_qat_fw.h"
+
+struct icp_qat_fw_req_hdr_pke_cd_pars {
+	uint64_t content_desc_addr;
+	uint32_t content_desc_resrvd;
+	uint32_t func_id;
+};
+
+struct icp_qat_fw_req_pke_mid {
+	uint64_t opaque_data;
+	uint64_t src_data_addr;
+	uint64_t dest_data_addr;
+};
+
+struct icp_qat_fw_req_pke_hdr {
+	uint8_t resrvd1;
+	uint8_t resrvd2;
+	uint8_t service_type;
+	uint8_t hdr_flags;
+	uint16_t comn_req_flags;
+	uint16_t resrvd4;
+	struct icp_qat_fw_req_hdr_pke_cd_pars cd_pars;
+};
+
+struct icp_qat_fw_pke_request {
+	struct icp_qat_fw_req_pke_hdr pke_hdr;
+	struct icp_qat_fw_req_pke_mid pke_mid;
+	uint8_t output_param_count;
+	uint8_t input_param_count;
+	uint16_t output_param_size;
+	uint32_t input_param_size;
+	uint64_t next_req_adr;
+};
+
+struct icp_qat_fw_resp_pke_hdr {
+	uint8_t resrvd1;
+	uint8_t resrvd2;
+	uint8_t response_type;
+	uint8_t hdr_flags;
+	uint16_t comn_resp_flags;
+	uint16_t resrvd4;
+};
+
+struct icp_qat_fw_pke_resp {
+	struct icp_qat_fw_resp_pke_hdr pke_resp_hdr;
+	uint64_t opaque_data;
+	uint64_t src_data_addr;
+	uint64_t dest_data_addr;
+};
+#endif
