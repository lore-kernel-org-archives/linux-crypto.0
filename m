Return-Path: <SRS0=5ZxX=EM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C87B9C55179
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Nov 2020 11:29:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 842AB206C1
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Nov 2020 11:29:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727249AbgKFL3C (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 6 Nov 2020 06:29:02 -0500
Received: from mga07.intel.com ([134.134.136.100]:59373 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727239AbgKFL3C (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 Nov 2020 06:29:02 -0500
IronPort-SDR: RNYOdXwRGXeH1iIIHyOqopMNblnP4izxgnmnLeDFOdAzlXtXOGgnIDxZ39I/ylCk4+zxI9l2GR
 /h9mSEmcEsQA==
X-IronPort-AV: E=McAfee;i="6000,8403,9796"; a="233698314"
X-IronPort-AV: E=Sophos;i="5.77,456,1596524400"; 
   d="scan'208";a="233698314"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2020 03:29:01 -0800
IronPort-SDR: 7PKyfn+NGi1omd6+iSx5jLm+OOp1R+8Qt6+FSNXZEv1LVNGRfNhtYCMLvt+IDRBuAFVZBxWEBF
 GpS3p9KPdNzw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,456,1596524400"; 
   d="scan'208";a="529779291"
Received: from haps801-neoncity02.sh.intel.com ([10.67.114.160])
  by fmsmga005.fm.intel.com with ESMTP; 06 Nov 2020 03:28:59 -0800
From:   Jack Xu <jack.xu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Jack Xu <jack.xu@intel.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH 16/32] crypto: qat - loader: introduce chip info structure
Date:   Fri,  6 Nov 2020 19:27:54 +0800
Message-Id: <20201106112810.2566-17-jack.xu@intel.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20201106112810.2566-1-jack.xu@intel.com>
References: <20201106112810.2566-1-jack.xu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Introduce the chip info structure which contains device specific
information. The initialization path has been split between common and
hardware specific in order to facilitate the introduction of the next
generation hardware.

Signed-off-by: Jack Xu <jack.xu@intel.com>
Co-developed-by: Wojciech Ziemba <wojciech.ziemba@intel.com>
Signed-off-by: Wojciech Ziemba <wojciech.ziemba@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 .../qat/qat_common/icp_qat_fw_loader_handle.h |   7 +-
 drivers/crypto/qat/qat_common/qat_hal.c       | 110 +++++++++++++-----
 drivers/crypto/qat/qat_common/qat_uclo.c      |   6 +-
 3 files changed, 88 insertions(+), 35 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/icp_qat_fw_loader_handle.h b/drivers/crypto/qat/qat_common/icp_qat_fw_loader_handle.h
index 7d44786a223a..6b1ad629357b 100644
--- a/drivers/crypto/qat/qat_common/icp_qat_fw_loader_handle.h
+++ b/drivers/crypto/qat/qat_common/icp_qat_fw_loader_handle.h
@@ -22,13 +22,18 @@ struct icp_qat_fw_loader_hal_handle {
 	unsigned int max_ustore;
 };
 
+struct icp_qat_fw_loader_chip_info {
+	bool sram_visible;
+	bool fw_auth;
+};
+
 struct icp_qat_fw_loader_handle {
 	struct icp_qat_fw_loader_hal_handle *hal_handle;
+	struct icp_qat_fw_loader_chip_info *chip_info;
 	struct pci_dev *pci_dev;
 	void *obj_handle;
 	void *sobj_handle;
 	void *mobj_handle;
-	bool fw_auth;
 	void __iomem *hal_sram_addr_v;
 	void __iomem *hal_cap_g_ctl_csr_addr_v;
 	void __iomem *hal_cap_ae_xfer_csr_addr_v;
diff --git a/drivers/crypto/qat/qat_common/qat_hal.c b/drivers/crypto/qat/qat_common/qat_hal.c
index 5bf42f01a3de..2faf8638526c 100644
--- a/drivers/crypto/qat/qat_common/qat_hal.c
+++ b/drivers/crypto/qat/qat_common/qat_hal.c
@@ -646,23 +646,41 @@ static int qat_hal_clear_gpr(struct icp_qat_fw_loader_handle *handle)
 	return 0;
 }
 
-int qat_hal_init(struct adf_accel_dev *accel_dev)
+static int qat_hal_chip_init(struct icp_qat_fw_loader_handle *handle,
+			     struct adf_accel_dev *accel_dev)
 {
-	unsigned char ae;
-	unsigned int max_en_ae_id = 0;
-	struct icp_qat_fw_loader_handle *handle;
 	struct adf_accel_pci *pci_info = &accel_dev->accel_pci_dev;
 	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
 	struct adf_bar *misc_bar =
 			&pci_info->pci_bars[hw_data->get_misc_bar_id(hw_data)];
-	unsigned long ae_mask = hw_data->ae_mask;
-	unsigned int csr_val = 0;
+	unsigned int max_en_ae_id = 0;
 	struct adf_bar *sram_bar;
+	unsigned int csr_val = 0;
+	unsigned long ae_mask;
+	unsigned char ae = 0;
+	int ret = 0;
 
-	handle = kzalloc(sizeof(*handle), GFP_KERNEL);
-	if (!handle)
-		return -ENOMEM;
+	handle->pci_dev = pci_info->pci_dev;
+	switch (handle->pci_dev->device) {
+	case PCI_DEVICE_ID_INTEL_QAT_C62X:
+	case PCI_DEVICE_ID_INTEL_QAT_C3XXX:
+		handle->chip_info->sram_visible = false;
+		handle->chip_info->fw_auth = true;
+		break;
+	case PCI_DEVICE_ID_INTEL_QAT_DH895XCC:
+		handle->chip_info->sram_visible = true;
+		handle->chip_info->fw_auth = false;
+		break;
+	default:
+		ret = -EINVAL;
+		goto out_err;
+	}
 
+	if (handle->chip_info->sram_visible) {
+		sram_bar =
+			&pci_info->pci_bars[hw_data->get_sram_bar_id(hw_data)];
+		handle->hal_sram_addr_v = sram_bar->virt_addr;
+	}
 	handle->hal_cap_g_ctl_csr_addr_v =
 		(void __iomem *)((uintptr_t)misc_bar->virt_addr +
 				 ICP_QAT_CAP_OFFSET);
@@ -676,22 +694,14 @@ int qat_hal_init(struct adf_accel_dev *accel_dev)
 		(void __iomem *)((uintptr_t)handle->hal_cap_ae_xfer_csr_addr_v +
 				 LOCAL_TO_XFER_REG_OFFSET);
 	handle->pci_dev = pci_info->pci_dev;
-	if (handle->pci_dev->device == PCI_DEVICE_ID_INTEL_QAT_DH895XCC) {
-		sram_bar =
-			&pci_info->pci_bars[hw_data->get_sram_bar_id(hw_data)];
-		handle->hal_sram_addr_v = sram_bar->virt_addr;
-	}
-	handle->fw_auth = (handle->pci_dev->device ==
-			   PCI_DEVICE_ID_INTEL_QAT_DH895XCC) ? false : true;
-	handle->hal_handle = kzalloc(sizeof(*handle->hal_handle), GFP_KERNEL);
-	if (!handle->hal_handle)
-		goto out_hal_handle;
 	handle->hal_handle->revision_id = accel_dev->accel_pci_dev.revid;
 	handle->hal_handle->ae_mask = hw_data->ae_mask;
 	handle->hal_handle->slice_mask = hw_data->accel_mask;
 	/* create AE objects */
 	handle->hal_handle->upc_mask = 0x1ffff;
 	handle->hal_handle->max_ustore = 0x4000;
+
+	ae_mask = handle->hal_handle->ae_mask;
 	for_each_set_bit(ae, &ae_mask, ICP_QAT_UCLO_MAX_AE) {
 		handle->hal_handle->aes[ae].free_addr = 0;
 		handle->hal_handle->aes[ae].free_size =
@@ -703,37 +713,75 @@ int qat_hal_init(struct adf_accel_dev *accel_dev)
 		max_en_ae_id = ae;
 	}
 	handle->hal_handle->ae_max_num = max_en_ae_id + 1;
+
+	/* Set SIGNATURE_ENABLE[0] to 0x1 in order to enable ALU_OUT csr */
+	for_each_set_bit(ae, &ae_mask, handle->hal_handle->ae_max_num) {
+		csr_val = qat_hal_rd_ae_csr(handle, ae, SIGNATURE_ENABLE);
+		csr_val |= 0x1;
+		qat_hal_wr_ae_csr(handle, ae, SIGNATURE_ENABLE, csr_val);
+	}
+out_err:
+	return ret;
+}
+
+int qat_hal_init(struct adf_accel_dev *accel_dev)
+{
+	struct icp_qat_fw_loader_handle *handle;
+	int ret = 0;
+
+	handle = kzalloc(sizeof(*handle), GFP_KERNEL);
+	if (!handle)
+		return -ENOMEM;
+
+	handle->hal_handle = kzalloc(sizeof(*handle->hal_handle), GFP_KERNEL);
+	if (!handle->hal_handle) {
+		ret = -ENOMEM;
+		goto out_hal_handle;
+	}
+
+	handle->chip_info = kzalloc(sizeof(*handle->chip_info), GFP_KERNEL);
+	if (!handle->chip_info) {
+		ret = -ENOMEM;
+		goto out_chip_info;
+	}
+
+	ret = qat_hal_chip_init(handle, accel_dev);
+	if (ret) {
+		dev_err(&GET_DEV(accel_dev), "qat_hal_chip_init error\n");
+		goto out_err;
+	}
+
 	/* take all AEs out of reset */
-	if (qat_hal_clr_reset(handle)) {
+	ret = qat_hal_clr_reset(handle);
+	if (ret) {
 		dev_err(&GET_DEV(accel_dev), "qat_hal_clr_reset error\n");
 		goto out_err;
 	}
+
 	qat_hal_clear_xfer(handle);
-	if (!handle->fw_auth) {
-		if (qat_hal_clear_gpr(handle))
+	if (!handle->chip_info->fw_auth) {
+		ret = qat_hal_clear_gpr(handle);
+		if (ret)
 			goto out_err;
 	}
 
-	/* Set SIGNATURE_ENABLE[0] to 0x1 in order to enable ALU_OUT csr */
-	for_each_set_bit(ae, &ae_mask, handle->hal_handle->ae_max_num) {
-		csr_val = qat_hal_rd_ae_csr(handle, ae, SIGNATURE_ENABLE);
-		csr_val |= 0x1;
-		qat_hal_wr_ae_csr(handle, ae, SIGNATURE_ENABLE, csr_val);
-	}
 	accel_dev->fw_loader->fw_loader = handle;
 	return 0;
 
 out_err:
+	kfree(handle->chip_info);
+out_chip_info:
 	kfree(handle->hal_handle);
 out_hal_handle:
 	kfree(handle);
-	return -EFAULT;
+	return ret;
 }
 
 void qat_hal_deinit(struct icp_qat_fw_loader_handle *handle)
 {
 	if (!handle)
 		return;
+	kfree(handle->chip_info);
 	kfree(handle->hal_handle);
 	kfree(handle);
 }
@@ -746,7 +794,7 @@ int qat_hal_start(struct icp_qat_fw_loader_handle *handle)
 	u32 ae_ctr = 0;
 	int retry = 0;
 
-	if (handle->fw_auth) {
+	if (handle->chip_info->fw_auth) {
 		ae_ctr = hweight32(ae_mask);
 		SET_CAP_CSR(handle, FCU_CONTROL, FCU_CTRL_CMD_START);
 		do {
@@ -770,7 +818,7 @@ int qat_hal_start(struct icp_qat_fw_loader_handle *handle)
 void qat_hal_stop(struct icp_qat_fw_loader_handle *handle, unsigned char ae,
 		  unsigned int ctx_mask)
 {
-	if (!handle->fw_auth)
+	if (!handle->chip_info->fw_auth)
 		qat_hal_disable_ctx(handle, ae, ctx_mask);
 }
 
diff --git a/drivers/crypto/qat/qat_common/qat_uclo.c b/drivers/crypto/qat/qat_common/qat_uclo.c
index 8d08dac94ea9..1533981baf3a 100644
--- a/drivers/crypto/qat/qat_common/qat_uclo.c
+++ b/drivers/crypto/qat/qat_common/qat_uclo.c
@@ -1405,7 +1405,7 @@ int qat_uclo_wr_mimage(struct icp_qat_fw_loader_handle *handle,
 	struct icp_qat_fw_auth_desc *desc = NULL;
 	int status = 0;
 
-	if (handle->fw_auth) {
+	if (handle->chip_info->fw_auth) {
 		if (!qat_uclo_map_auth_fw(handle, addr_ptr, mem_size, &desc))
 			status = qat_uclo_auth_fw(handle, desc);
 		qat_uclo_ummap_auth_fw(handle, &desc);
@@ -1718,7 +1718,7 @@ int qat_uclo_map_obj(struct icp_qat_fw_loader_handle *handle,
 		obj_size = mem_size;
 	}
 
-	return (handle->fw_auth) ?
+	return (handle->chip_info->fw_auth) ?
 			qat_uclo_map_suof_obj(handle, obj_addr, obj_size) :
 			qat_uclo_map_uof_obj(handle, obj_addr, obj_size);
 }
@@ -1909,6 +1909,6 @@ static int qat_uclo_wr_uof_img(struct icp_qat_fw_loader_handle *handle)
 
 int qat_uclo_wr_all_uimage(struct icp_qat_fw_loader_handle *handle)
 {
-	return (handle->fw_auth) ? qat_uclo_wr_suof_img(handle) :
+	return (handle->chip_info->fw_auth) ? qat_uclo_wr_suof_img(handle) :
 				   qat_uclo_wr_uof_img(handle);
 }
-- 
2.25.4

