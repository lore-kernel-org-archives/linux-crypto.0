Return-Path: <SRS0=5ZxX=EM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56F27C2D0A3
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Nov 2020 11:29:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C91C206C1
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Nov 2020 11:29:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727253AbgKFL3S (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 6 Nov 2020 06:29:18 -0500
Received: from mga07.intel.com ([134.134.136.100]:59432 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727170AbgKFL3S (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 Nov 2020 06:29:18 -0500
IronPort-SDR: cTDwGxV1tYiqpyWkkD70zeKJl9GN7uM9l6ELAmAXUXsjLPUNMzs4bAmPVQEIHrJLw68Pcx2gBB
 CdC04f3I8wuQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9796"; a="233698341"
X-IronPort-AV: E=Sophos;i="5.77,456,1596524400"; 
   d="scan'208";a="233698341"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2020 03:29:17 -0800
IronPort-SDR: Bzc5mv1ZkLHD8RyzhEkd5k2eGRJslL7e0fpfsQI42Q7W1JhNtanOEol7WRpU7rKzw3q2tsn022
 IdFvX2h7Jpjg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,456,1596524400"; 
   d="scan'208";a="529779370"
Received: from haps801-neoncity02.sh.intel.com ([10.67.114.160])
  by fmsmga005.fm.intel.com with ESMTP; 06 Nov 2020 03:29:16 -0800
From:   Jack Xu <jack.xu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Jack Xu <jack.xu@intel.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH 26/32] crypto: qat - loader: use ae_mask
Date:   Fri,  6 Nov 2020 19:28:04 +0800
Message-Id: <20201106112810.2566-27-jack.xu@intel.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20201106112810.2566-1-jack.xu@intel.com>
References: <20201106112810.2566-1-jack.xu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Use ae_mask to decide which Accelerator Engine (AE) to target in AE
related operations, instead of a sequential loop, to skip AEs that are
fused out.

Signed-off-by: Jack Xu <jack.xu@intel.com>
Co-developed-by: Wojciech Ziemba <wojciech.ziemba@intel.com>
Signed-off-by: Wojciech Ziemba <wojciech.ziemba@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/qat/qat_common/qat_uclo.c | 26 +++++++++++++-----------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/qat_uclo.c b/drivers/crypto/qat/qat_common/qat_uclo.c
index 7b02c4e165c6..0b1cf0708e2e 100644
--- a/drivers/crypto/qat/qat_common/qat_uclo.c
+++ b/drivers/crypto/qat/qat_common/qat_uclo.c
@@ -373,6 +373,7 @@ static int qat_uclo_init_ustore(struct icp_qat_fw_loader_handle *handle,
 	unsigned int ustore_size;
 	unsigned int patt_pos;
 	struct icp_qat_uclo_objhandle *obj_handle = handle->obj_handle;
+	unsigned long ae_mask = handle->hal_handle->ae_mask;
 	u64 *fill_data;
 
 	uof_image = image->img_ptr;
@@ -385,7 +386,7 @@ static int qat_uclo_init_ustore(struct icp_qat_fw_loader_handle *handle,
 		       sizeof(u64));
 	page = image->page;
 
-	for (ae = 0; ae < handle->hal_handle->ae_max_num; ae++) {
+	for_each_set_bit(ae, &ae_mask, handle->hal_handle->ae_max_num) {
 		if (!test_bit(ae, (unsigned long *)&uof_image->ae_assigned))
 			continue;
 		ustore_size = obj_handle->ae_data[ae].eff_ustore_size;
@@ -406,6 +407,7 @@ static int qat_uclo_init_memory(struct icp_qat_fw_loader_handle *handle)
 	int i, ae;
 	struct icp_qat_uclo_objhandle *obj_handle = handle->obj_handle;
 	struct icp_qat_uof_initmem *initmem = obj_handle->init_mem_tab.init_mem;
+	unsigned long ae_mask = handle->hal_handle->ae_mask;
 
 	for (i = 0; i < obj_handle->init_mem_tab.entry_num; i++) {
 		if (initmem->num_in_bytes) {
@@ -418,7 +420,8 @@ static int qat_uclo_init_memory(struct icp_qat_fw_loader_handle *handle)
 			(sizeof(struct icp_qat_uof_memvar_attr) *
 			initmem->val_attr_num));
 	}
-	for (ae = 0; ae < handle->hal_handle->ae_max_num; ae++) {
+
+	for_each_set_bit(ae, &ae_mask, handle->hal_handle->ae_max_num) {
 		if (qat_hal_batch_wr_lm(handle, ae,
 					obj_handle->lm_init_tab[ae])) {
 			pr_err("QAT: fail to batch init lmem for AE %d\n", ae);
@@ -649,11 +652,9 @@ static int qat_uclo_map_ae(struct icp_qat_fw_loader_handle *handle, int max_ae)
 	int i, ae;
 	int mflag = 0;
 	struct icp_qat_uclo_objhandle *obj_handle = handle->obj_handle;
+	unsigned long ae_mask = handle->hal_handle->ae_mask;
 
-	for (ae = 0; ae < max_ae; ae++) {
-		if (!test_bit(ae,
-			      (unsigned long *)&handle->hal_handle->ae_mask))
-			continue;
+	for_each_set_bit(ae, &ae_mask, max_ae) {
 		for (i = 0; i < obj_handle->uimage_num; i++) {
 			if (!test_bit(ae, (unsigned long *)
 			&obj_handle->ae_uimage[i].img_ptr->ae_assigned))
@@ -845,6 +846,7 @@ static int qat_uclo_init_reg_sym(struct icp_qat_fw_loader_handle *handle,
 static int qat_uclo_init_globals(struct icp_qat_fw_loader_handle *handle)
 {
 	struct icp_qat_uclo_objhandle *obj_handle = handle->obj_handle;
+	unsigned long ae_mask = handle->hal_handle->ae_mask;
 	struct icp_qat_uclo_aedata *aed;
 	unsigned int s, ae;
 
@@ -857,7 +859,7 @@ static int qat_uclo_init_globals(struct icp_qat_fw_loader_handle *handle)
 		}
 	}
 
-	for (ae = 0; ae < handle->hal_handle->ae_max_num; ae++) {
+	for_each_set_bit(ae, &ae_mask, handle->hal_handle->ae_max_num) {
 		aed = &obj_handle->ae_data[ae];
 		for (s = 0; s < aed->slice_num; s++) {
 			if (!aed->ae_slices[s].encap_image)
@@ -932,9 +934,7 @@ static int qat_uclo_set_ae_mode(struct icp_qat_fw_loader_handle *handle)
 	unsigned char ae, s;
 	int error;
 
-	for (ae = 0; ae < handle->hal_handle->ae_max_num; ae++) {
-		if (!test_bit(ae, &ae_mask))
-			continue;
+	for_each_set_bit(ae, &ae_mask, handle->hal_handle->ae_max_num) {
 		ae_data = &obj_handle->ae_data[ae];
 		for (s = 0; s < min_t(unsigned int, ae_data->slice_num,
 				      ICP_QAT_UCLO_MAX_CTX); s++) {
@@ -1372,13 +1372,14 @@ static int qat_uclo_load_fw(struct icp_qat_fw_loader_handle *handle,
 	unsigned int fcu_sts;
 	struct icp_qat_simg_ae_mode *virt_addr;
 	unsigned int fcu_loaded_ae_pos = FCU_LOADED_AE_POS;
+	unsigned long ae_mask = handle->hal_handle->ae_mask;
 
 	virt_addr = (void *)((uintptr_t)desc +
 		     sizeof(struct icp_qat_auth_chunk) +
 		     sizeof(struct icp_qat_css_hdr) +
 		     ICP_QAT_CSS_FWSK_PUB_LEN +
 		     ICP_QAT_CSS_SIGNATURE_LEN);
-	for (i = 0; i < handle->hal_handle->ae_max_num; i++) {
+	for_each_set_bit(i, &ae_mask, handle->hal_handle->ae_max_num) {
 		int retry = 0;
 
 		if (!((virt_addr->ae_mask >> i) & 0x1))
@@ -1847,6 +1848,7 @@ static void qat_uclo_wr_uimage_page(struct icp_qat_fw_loader_handle *handle,
 				    struct icp_qat_uof_image *image)
 {
 	struct icp_qat_uclo_objhandle *obj_handle = handle->obj_handle;
+	unsigned long ae_mask = handle->hal_handle->ae_mask;
 	unsigned long ae_assigned = image->ae_assigned;
 	struct icp_qat_uclo_aedata *aed;
 	unsigned int ctx_mask, s;
@@ -1860,7 +1862,7 @@ static void qat_uclo_wr_uimage_page(struct icp_qat_fw_loader_handle *handle,
 		ctx_mask = 0x55;
 	/* load the default page and set assigned CTX PC
 	 * to the entrypoint address */
-	for (ae = 0; ae < handle->hal_handle->ae_max_num; ae++) {
+	for_each_set_bit(ae, &ae_mask, handle->hal_handle->ae_max_num) {
 		if (!test_bit(ae, &ae_assigned))
 			continue;
 
-- 
2.25.4

