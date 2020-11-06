Return-Path: <SRS0=5ZxX=EM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A507CC2D0A3
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Nov 2020 11:29:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 571E3206C1
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Nov 2020 11:29:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726422AbgKFL3Y (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 6 Nov 2020 06:29:24 -0500
Received: from mga07.intel.com ([134.134.136.100]:59432 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727233AbgKFL3Y (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 Nov 2020 06:29:24 -0500
IronPort-SDR: n8o45HVi5fxjpLmBQZFZ1KrGjqXhsA5kFjmMeC4ZMVRoBiCbbaQC4g6Z53/33AEDbRZBiPnAE3
 8xlg13IqutvA==
X-IronPort-AV: E=McAfee;i="6000,8403,9796"; a="233698356"
X-IronPort-AV: E=Sophos;i="5.77,456,1596524400"; 
   d="scan'208";a="233698356"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2020 03:29:23 -0800
IronPort-SDR: 6AyKmqskDqAXb4O9UELjFYnh1kOOQHc7H5rS9mOAO8Dy7jox2oOchtsfUkeKl95H86EL+ZCZzI
 8UGnY86i8COg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,456,1596524400"; 
   d="scan'208";a="529779416"
Received: from haps801-neoncity02.sh.intel.com ([10.67.114.160])
  by fmsmga005.fm.intel.com with ESMTP; 06 Nov 2020 03:29:21 -0800
From:   Jack Xu <jack.xu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Jack Xu <jack.xu@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH 29/32] crypto: qat - loader: allow to target specific AEs
Date:   Fri,  6 Nov 2020 19:28:07 +0800
Message-Id: <20201106112810.2566-30-jack.xu@intel.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20201106112810.2566-1-jack.xu@intel.com>
References: <20201106112810.2566-1-jack.xu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Introduce new API, qat_uclo_set_cfg_ae_mask(), to allow the load of the
firmware image to a subset of Acceleration Engines (AEs). This is
required by the next generation of QAT devices to be able to load
different firmware images to the device.

Signed-off-by: Jack Xu <jack.xu@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 .../crypto/qat/qat_common/adf_common_drv.h    |  2 +
 .../qat/qat_common/icp_qat_fw_loader_handle.h |  1 +
 drivers/crypto/qat/qat_common/icp_qat_hal.h   |  2 +
 drivers/crypto/qat/qat_common/icp_qat_uclo.h  |  2 +-
 drivers/crypto/qat/qat_common/qat_hal.c       |  1 +
 drivers/crypto/qat/qat_common/qat_uclo.c      | 42 +++++++++++++++----
 6 files changed, 42 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_common_drv.h b/drivers/crypto/qat/qat_common/adf_common_drv.h
index f4c90c701670..c61476553728 100644
--- a/drivers/crypto/qat/qat_common/adf_common_drv.h
+++ b/drivers/crypto/qat/qat_common/adf_common_drv.h
@@ -186,6 +186,8 @@ int qat_uclo_wr_mimage(struct icp_qat_fw_loader_handle *handle, void *addr_ptr,
 		       int mem_size);
 int qat_uclo_map_obj(struct icp_qat_fw_loader_handle *handle,
 		     void *addr_ptr, u32 mem_size, char *obj_name);
+int qat_uclo_set_cfg_ae_mask(struct icp_qat_fw_loader_handle *handle,
+			     unsigned int cfg_ae_mask);
 #if defined(CONFIG_PCI_IOV)
 int adf_sriov_configure(struct pci_dev *pdev, int numvfs);
 void adf_disable_sriov(struct adf_accel_dev *accel_dev);
diff --git a/drivers/crypto/qat/qat_common/icp_qat_fw_loader_handle.h b/drivers/crypto/qat/qat_common/icp_qat_fw_loader_handle.h
index e280a077303f..cc9b83d965af 100644
--- a/drivers/crypto/qat/qat_common/icp_qat_fw_loader_handle.h
+++ b/drivers/crypto/qat/qat_common/icp_qat_fw_loader_handle.h
@@ -49,6 +49,7 @@ struct icp_qat_fw_loader_handle {
 	void *obj_handle;
 	void *sobj_handle;
 	void *mobj_handle;
+	unsigned int cfg_ae_mask;
 	void __iomem *hal_sram_addr_v;
 	void __iomem *hal_cap_g_ctl_csr_addr_v;
 	void __iomem *hal_cap_ae_xfer_csr_addr_v;
diff --git a/drivers/crypto/qat/qat_common/icp_qat_hal.h b/drivers/crypto/qat/qat_common/icp_qat_hal.h
index b3aa4c8a3ba8..02476b2ceee1 100644
--- a/drivers/crypto/qat/qat_common/icp_qat_hal.h
+++ b/drivers/crypto/qat/qat_common/icp_qat_hal.h
@@ -68,6 +68,8 @@ enum fcu_sts {
 	FCU_STS_LOAD_FAIL = 4,
 	FCU_STS_BUSY      = 5
 };
+
+#define ALL_AE_MASK                 0xFFFFFFFF
 #define UA_ECS                      (0x1 << 31)
 #define ACS_ABO_BITPOS              31
 #define ACS_ACNO                    0x7
diff --git a/drivers/crypto/qat/qat_common/icp_qat_uclo.h b/drivers/crypto/qat/qat_common/icp_qat_uclo.h
index 4315b4504c26..0ec8a5ab51b5 100644
--- a/drivers/crypto/qat/qat_common/icp_qat_uclo.h
+++ b/drivers/crypto/qat/qat_common/icp_qat_uclo.h
@@ -432,7 +432,7 @@ struct icp_qat_suof_handle {
 
 struct icp_qat_fw_auth_desc {
 	unsigned int   img_len;
-	unsigned int   reserved;
+	unsigned int   ae_mask;
 	unsigned int   css_hdr_high;
 	unsigned int   css_hdr_low;
 	unsigned int   img_high;
diff --git a/drivers/crypto/qat/qat_common/qat_hal.c b/drivers/crypto/qat/qat_common/qat_hal.c
index da138fb11a63..94c0b04088b5 100644
--- a/drivers/crypto/qat/qat_common/qat_hal.c
+++ b/drivers/crypto/qat/qat_common/qat_hal.c
@@ -761,6 +761,7 @@ static int qat_hal_chip_init(struct icp_qat_fw_loader_handle *handle,
 	handle->hal_handle->revision_id = accel_dev->accel_pci_dev.revid;
 	handle->hal_handle->ae_mask = hw_data->ae_mask;
 	handle->hal_handle->slice_mask = hw_data->accel_mask;
+	handle->cfg_ae_mask = ALL_AE_MASK;
 	/* create AE objects */
 	handle->hal_handle->upc_mask = 0x1ffff;
 	handle->hal_handle->max_ustore = 0x4000;
diff --git a/drivers/crypto/qat/qat_common/qat_uclo.c b/drivers/crypto/qat/qat_common/qat_uclo.c
index 3c5746d52756..c6b309d107f3 100644
--- a/drivers/crypto/qat/qat_common/qat_uclo.c
+++ b/drivers/crypto/qat/qat_common/qat_uclo.c
@@ -374,6 +374,7 @@ static int qat_uclo_init_ustore(struct icp_qat_fw_loader_handle *handle,
 	unsigned int patt_pos;
 	struct icp_qat_uclo_objhandle *obj_handle = handle->obj_handle;
 	unsigned long ae_mask = handle->hal_handle->ae_mask;
+	unsigned long cfg_ae_mask = handle->cfg_ae_mask;
 	u64 *fill_data;
 
 	uof_image = image->img_ptr;
@@ -389,6 +390,10 @@ static int qat_uclo_init_ustore(struct icp_qat_fw_loader_handle *handle,
 	for_each_set_bit(ae, &ae_mask, handle->hal_handle->ae_max_num) {
 		if (!test_bit(ae, (unsigned long *)&uof_image->ae_assigned))
 			continue;
+
+		if (!test_bit(ae, &cfg_ae_mask))
+			continue;
+
 		ustore_size = obj_handle->ae_data[ae].eff_ustore_size;
 		patt_pos = page->beg_addr_p + page->micro_words_num;
 
@@ -653,8 +658,12 @@ static int qat_uclo_map_ae(struct icp_qat_fw_loader_handle *handle, int max_ae)
 	int mflag = 0;
 	struct icp_qat_uclo_objhandle *obj_handle = handle->obj_handle;
 	unsigned long ae_mask = handle->hal_handle->ae_mask;
+	unsigned long cfg_ae_mask = handle->cfg_ae_mask;
 
 	for_each_set_bit(ae, &ae_mask, max_ae) {
+		if (!test_bit(ae, &cfg_ae_mask))
+			continue;
+
 		for (i = 0; i < obj_handle->uimage_num; i++) {
 			if (!test_bit(ae, (unsigned long *)
 			&obj_handle->ae_uimage[i].img_ptr->ae_assigned))
@@ -931,10 +940,14 @@ static int qat_uclo_set_ae_mode(struct icp_qat_fw_loader_handle *handle)
 	struct icp_qat_uclo_aedata *ae_data;
 	struct icp_qat_uclo_objhandle *obj_handle = handle->obj_handle;
 	unsigned long ae_mask = handle->hal_handle->ae_mask;
+	unsigned long cfg_ae_mask = handle->cfg_ae_mask;
 	unsigned char ae, s;
 	int error;
 
 	for_each_set_bit(ae, &ae_mask, handle->hal_handle->ae_max_num) {
+		if (!test_bit(ae, &cfg_ae_mask))
+			continue;
+
 		ae_data = &obj_handle->ae_data[ae];
 		for (s = 0; s < min_t(unsigned int, ae_data->slice_num,
 				      ICP_QAT_UCLO_MAX_CTX); s++) {
@@ -1176,6 +1189,7 @@ static int qat_uclo_map_suof(struct icp_qat_fw_loader_handle *handle,
 						 &suof_img_hdr[i]);
 		if (ret)
 			return ret;
+		suof_img_hdr[i].ae_mask &= handle->cfg_ae_mask;
 		if ((suof_img_hdr[i].ae_mask & 0x1) != 0)
 			ae0_img = i;
 	}
@@ -1277,6 +1291,7 @@ static int qat_uclo_map_auth_fw(struct icp_qat_fw_loader_handle *handle,
 	struct icp_qat_auth_chunk *auth_chunk;
 	u64 virt_addr,  bus_addr, virt_base;
 	unsigned int length, simg_offset = sizeof(*auth_chunk);
+	struct icp_qat_simg_ae_mode *simg_ae_mode;
 	struct icp_firml_dram_desc img_desc;
 
 	if (size > (ICP_QAT_AE_IMG_OFFSET(handle) + ICP_QAT_CSS_MAX_IMAGE_LEN)) {
@@ -1366,6 +1381,11 @@ static int qat_uclo_map_auth_fw(struct icp_qat_fw_loader_handle *handle,
 		auth_desc->img_ae_insts_high = (unsigned int)
 					     (bus_addr >> BITS_IN_DWORD);
 		auth_desc->img_ae_insts_low = (unsigned int)bus_addr;
+		virt_addr += sizeof(struct icp_qat_css_hdr);
+		virt_addr += ICP_QAT_CSS_FWSK_PUB_LEN(handle);
+		virt_addr += ICP_QAT_CSS_SIGNATURE_LEN(handle);
+		simg_ae_mode = (struct icp_qat_simg_ae_mode *)(uintptr_t)virt_addr;
+		auth_desc->ae_mask = simg_ae_mode->ae_mask & handle->cfg_ae_mask;
 	} else {
 		auth_desc->img_ae_insts_high = auth_desc->img_high;
 		auth_desc->img_ae_insts_low = auth_desc->img_low;
@@ -1377,7 +1397,6 @@ static int qat_uclo_map_auth_fw(struct icp_qat_fw_loader_handle *handle,
 static int qat_uclo_load_fw(struct icp_qat_fw_loader_handle *handle,
 			    struct icp_qat_fw_auth_desc *desc)
 {
-	struct icp_qat_simg_ae_mode *virt_addr;
 	unsigned long ae_mask = handle->hal_handle->ae_mask;
 	u32 fcu_sts_csr, fcu_ctl_csr;
 	u32 loaded_aes, loaded_csr;
@@ -1388,15 +1407,10 @@ static int qat_uclo_load_fw(struct icp_qat_fw_loader_handle *handle,
 	fcu_sts_csr = handle->chip_info->fcu_sts_csr;
 	loaded_csr = handle->chip_info->fcu_loaded_ae_csr;
 
-	virt_addr = (void *)((uintptr_t)desc +
-		     sizeof(struct icp_qat_auth_chunk) +
-		     sizeof(struct icp_qat_css_hdr) +
-		     ICP_QAT_CSS_FWSK_PUB_LEN(handle) +
-		     ICP_QAT_CSS_SIGNATURE_LEN(handle));
 	for_each_set_bit(i, &ae_mask, handle->hal_handle->ae_max_num) {
 		int retry = 0;
 
-		if (!((virt_addr->ae_mask >> i) & 0x1))
+		if (!((desc->ae_mask >> i) & 0x1))
 			continue;
 		if (qat_hal_check_ae_active(handle, i)) {
 			pr_err("QAT: AE %d is active\n", i);
@@ -1866,6 +1880,7 @@ static void qat_uclo_wr_uimage_page(struct icp_qat_fw_loader_handle *handle,
 {
 	struct icp_qat_uclo_objhandle *obj_handle = handle->obj_handle;
 	unsigned long ae_mask = handle->hal_handle->ae_mask;
+	unsigned long cfg_ae_mask = handle->cfg_ae_mask;
 	unsigned long ae_assigned = image->ae_assigned;
 	struct icp_qat_uclo_aedata *aed;
 	unsigned int ctx_mask, s;
@@ -1880,6 +1895,9 @@ static void qat_uclo_wr_uimage_page(struct icp_qat_fw_loader_handle *handle,
 	/* load the default page and set assigned CTX PC
 	 * to the entrypoint address */
 	for_each_set_bit(ae, &ae_mask, handle->hal_handle->ae_max_num) {
+		if (!test_bit(ae, &cfg_ae_mask))
+			continue;
+
 		if (!test_bit(ae, &ae_assigned))
 			continue;
 
@@ -1957,3 +1975,13 @@ int qat_uclo_wr_all_uimage(struct icp_qat_fw_loader_handle *handle)
 	return (handle->chip_info->fw_auth) ? qat_uclo_wr_suof_img(handle) :
 				   qat_uclo_wr_uof_img(handle);
 }
+
+int qat_uclo_set_cfg_ae_mask(struct icp_qat_fw_loader_handle *handle,
+			     unsigned int cfg_ae_mask)
+{
+	if (!cfg_ae_mask)
+		return -EINVAL;
+
+	handle->cfg_ae_mask = cfg_ae_mask;
+	return 0;
+}
-- 
2.25.4

