Return-Path: <SRS0=5ZxX=EM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC41CC55ABD
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Nov 2020 11:29:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 72BD52078B
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Nov 2020 11:29:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727237AbgKFL3A (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 6 Nov 2020 06:29:00 -0500
Received: from mga07.intel.com ([134.134.136.100]:59373 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727239AbgKFL3A (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 Nov 2020 06:29:00 -0500
IronPort-SDR: uQmrgJ37Ny4L50xASoy+CwxPf6R41MJvV0AqiL+9qpUjFEP9e7GAY2OsuFmYllzJVFLiup/lLa
 3cTrIWP6gRJg==
X-IronPort-AV: E=McAfee;i="6000,8403,9796"; a="233698311"
X-IronPort-AV: E=Sophos;i="5.77,456,1596524400"; 
   d="scan'208";a="233698311"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2020 03:28:59 -0800
IronPort-SDR: yF2RCJZOoM8Q+W80TNUz5jRPop3dmCfGsN6I2oZl1DWs/0KzyoXkqqotTYyLAHlbD5mF8EfpL9
 pRftsCpIlrZw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,456,1596524400"; 
   d="scan'208";a="529779285"
Received: from haps801-neoncity02.sh.intel.com ([10.67.114.160])
  by fmsmga005.fm.intel.com with ESMTP; 06 Nov 2020 03:28:57 -0800
From:   Jack Xu <jack.xu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Jack Xu <jack.xu@intel.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH 15/32] crypto: qat - loader: refactor long expressions
Date:   Fri,  6 Nov 2020 19:27:53 +0800
Message-Id: <20201106112810.2566-16-jack.xu@intel.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20201106112810.2566-1-jack.xu@intel.com>
References: <20201106112810.2566-1-jack.xu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Replace long expressions with local variables in the functions
qat_uclo_wr_uimage_page(), qat_uclo_init_globals() and
qat_uclo_init_umem_seg() to improve readability.

Signed-off-by: Jack Xu <jack.xu@intel.com>
Co-developed-by: Wojciech Ziemba <wojciech.ziemba@intel.com>
Signed-off-by: Wojciech Ziemba <wojciech.ziemba@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/qat/qat_common/qat_uclo.c | 41 +++++++++++++-----------
 1 file changed, 23 insertions(+), 18 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/qat_uclo.c b/drivers/crypto/qat/qat_common/qat_uclo.c
index 095e1b469412..8d08dac94ea9 100644
--- a/drivers/crypto/qat/qat_common/qat_uclo.c
+++ b/drivers/crypto/qat/qat_common/qat_uclo.c
@@ -324,6 +324,7 @@ static int qat_uclo_init_umem_seg(struct icp_qat_fw_loader_handle *handle,
 {
 	struct icp_qat_uclo_objhandle *obj_handle = handle->obj_handle;
 	unsigned int ae, ustore_size, uaddr, i;
+	struct icp_qat_uclo_aedata *aed;
 
 	ustore_size = obj_handle->ustore_phy_size;
 	if (qat_uclo_fetch_initmem_ae(handle, init_mem, ustore_size, &ae))
@@ -333,11 +334,10 @@ static int qat_uclo_init_umem_seg(struct icp_qat_fw_loader_handle *handle,
 		return -EINVAL;
 	/* set the highest ustore address referenced */
 	uaddr = (init_mem->addr + init_mem->num_in_bytes) >> 0x2;
-	for (i = 0; i < obj_handle->ae_data[ae].slice_num; i++) {
-		if (obj_handle->ae_data[ae].ae_slices[i].
-		    encap_image->uwords_num < uaddr)
-			obj_handle->ae_data[ae].ae_slices[i].
-			encap_image->uwords_num = uaddr;
+	aed = &obj_handle->ae_data[ae];
+	for (i = 0; i < aed->slice_num; i++) {
+		if (aed->ae_slices[i].encap_image->uwords_num < uaddr)
+			aed->ae_slices[i].encap_image->uwords_num = uaddr;
 	}
 	return 0;
 }
@@ -845,6 +845,7 @@ static int qat_uclo_init_reg_sym(struct icp_qat_fw_loader_handle *handle,
 static int qat_uclo_init_globals(struct icp_qat_fw_loader_handle *handle)
 {
 	struct icp_qat_uclo_objhandle *obj_handle = handle->obj_handle;
+	struct icp_qat_uclo_aedata *aed;
 	unsigned int s, ae;
 
 	if (obj_handle->global_inited)
@@ -855,13 +856,13 @@ static int qat_uclo_init_globals(struct icp_qat_fw_loader_handle *handle)
 			return -EINVAL;
 		}
 	}
+
 	for (ae = 0; ae < handle->hal_handle->ae_max_num; ae++) {
-		for (s = 0; s < obj_handle->ae_data[ae].slice_num; s++) {
-			if (!obj_handle->ae_data[ae].ae_slices[s].encap_image)
+		aed = &obj_handle->ae_data[ae];
+		for (s = 0; s < aed->slice_num; s++) {
+			if (!aed->ae_slices[s].encap_image)
 				continue;
-			if (qat_uclo_init_reg_sym(handle, ae,
-						  obj_handle->ae_data[ae].
-						  ae_slices[s].encap_image))
+			if (qat_uclo_init_reg_sym(handle, ae, aed->ae_slices[s].encap_image))
 				return -EINVAL;
 		}
 	}
@@ -1820,6 +1821,8 @@ static void qat_uclo_wr_uimage_page(struct icp_qat_fw_loader_handle *handle,
 				    struct icp_qat_uof_image *image)
 {
 	struct icp_qat_uclo_objhandle *obj_handle = handle->obj_handle;
+	unsigned long ae_assigned = image->ae_assigned;
+	struct icp_qat_uclo_aedata *aed;
 	unsigned int ctx_mask, s;
 	struct icp_qat_uclo_page *page;
 	unsigned char ae;
@@ -1832,24 +1835,26 @@ static void qat_uclo_wr_uimage_page(struct icp_qat_fw_loader_handle *handle,
 	/* load the default page and set assigned CTX PC
 	 * to the entrypoint address */
 	for (ae = 0; ae < handle->hal_handle->ae_max_num; ae++) {
-		if (!test_bit(ae, (unsigned long *)&image->ae_assigned))
+		if (!test_bit(ae, &ae_assigned))
 			continue;
+
+		aed = &obj_handle->ae_data[ae];
 		/* find the slice to which this image is assigned */
-		for (s = 0; s < obj_handle->ae_data[ae].slice_num; s++) {
-			if (image->ctx_assigned & obj_handle->ae_data[ae].
-			    ae_slices[s].ctx_mask_assigned)
+		for (s = 0; s < aed->slice_num; s++) {
+			if (image->ctx_assigned &
+			    aed->ae_slices[s].ctx_mask_assigned)
 				break;
 		}
-		if (s >= obj_handle->ae_data[ae].slice_num)
+		if (s >= aed->slice_num)
 			continue;
-		page = obj_handle->ae_data[ae].ae_slices[s].page;
+		page = aed->ae_slices[s].page;
 		if (!page->encap_page->def_page)
 			continue;
 		qat_uclo_wr_uimage_raw_page(handle, page->encap_page, ae);
 
-		page = obj_handle->ae_data[ae].ae_slices[s].page;
+		page = aed->ae_slices[s].page;
 		for (ctx = 0; ctx < ICP_QAT_UCLO_MAX_CTX; ctx++)
-			obj_handle->ae_data[ae].ae_slices[s].cur_page[ctx] =
+			aed->ae_slices[s].cur_page[ctx] =
 					(ctx_mask & (1 << ctx)) ? page : NULL;
 		qat_hal_set_live_ctx(handle, (unsigned char)ae,
 				     image->ctx_assigned);
-- 
2.25.4

