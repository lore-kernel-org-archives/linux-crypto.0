Return-Path: <SRS0=5ZxX=EM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A4F3C55179
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Nov 2020 11:29:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DDE2E2078B
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Nov 2020 11:28:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727232AbgKFL26 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 6 Nov 2020 06:28:58 -0500
Received: from mga07.intel.com ([134.134.136.100]:59373 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727231AbgKFL25 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 Nov 2020 06:28:57 -0500
IronPort-SDR: VTZ5CnvDLMLSv+sIuqjSJazK5eE3wtvTkfFSQ/s9gyFnEBfRi7enT5d+u6ZKeRo5FRPWWa8rWr
 4l5vLj/NalIA==
X-IronPort-AV: E=McAfee;i="6000,8403,9796"; a="233698309"
X-IronPort-AV: E=Sophos;i="5.77,456,1596524400"; 
   d="scan'208";a="233698309"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2020 03:28:57 -0800
IronPort-SDR: 1Sog2AjxuYDhFSA4EKJgoPKgZl9QIfpgsA39DlT3DgFxN9IXQzLL17rvNFEkgEoh8e+F939bHt
 a0UkJoQQoFwA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,456,1596524400"; 
   d="scan'208";a="529779278"
Received: from haps801-neoncity02.sh.intel.com ([10.67.114.160])
  by fmsmga005.fm.intel.com with ESMTP; 06 Nov 2020 03:28:55 -0800
From:   Jack Xu <jack.xu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Jack Xu <jack.xu@intel.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH 14/32] crypto: qat - loader: refactor qat_uclo_set_ae_mode()
Date:   Fri,  6 Nov 2020 19:27:52 +0800
Message-Id: <20201106112810.2566-15-jack.xu@intel.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20201106112810.2566-1-jack.xu@intel.com>
References: <20201106112810.2566-1-jack.xu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Refactor qat_uclo_set_ae_mode() by moving the logic that sets the AE
modes to a separate function, qat_hal_set_modes().

Signed-off-by: Jack Xu <jack.xu@intel.com>
Co-developed-by: Wojciech Ziemba <wojciech.ziemba@intel.com>
Signed-off-by: Wojciech Ziemba <wojciech.ziemba@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/qat/qat_common/qat_uclo.c | 69 +++++++++++++++---------
 1 file changed, 43 insertions(+), 26 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/qat_uclo.c b/drivers/crypto/qat/qat_common/qat_uclo.c
index 6423b1ea7021..095e1b469412 100644
--- a/drivers/crypto/qat/qat_common/qat_uclo.c
+++ b/drivers/crypto/qat/qat_common/qat_uclo.c
@@ -869,16 +869,52 @@ static int qat_uclo_init_globals(struct icp_qat_fw_loader_handle *handle)
 	return 0;
 }
 
+static int qat_hal_set_modes(struct icp_qat_fw_loader_handle *handle,
+			     struct icp_qat_uclo_objhandle *obj_handle,
+			     unsigned char ae,
+			     struct icp_qat_uof_image *uof_image)
+{
+	unsigned char mode;
+	int ret;
+
+	mode = ICP_QAT_CTX_MODE(uof_image->ae_mode);
+	ret = qat_hal_set_ae_ctx_mode(handle, ae, mode);
+	if (ret) {
+		pr_err("QAT: qat_hal_set_ae_ctx_mode error\n");
+		return ret;
+	}
+	mode = ICP_QAT_NN_MODE(uof_image->ae_mode);
+	ret = qat_hal_set_ae_nn_mode(handle, ae, mode);
+	if (ret) {
+		pr_err("QAT: qat_hal_set_ae_nn_mode error\n");
+		return ret;
+	}
+	mode = ICP_QAT_LOC_MEM0_MODE(uof_image->ae_mode);
+	ret = qat_hal_set_ae_lm_mode(handle, ae, ICP_LMEM0, mode);
+	if (ret) {
+		pr_err("QAT: qat_hal_set_ae_lm_mode LMEM0 error\n");
+		return ret;
+	}
+	mode = ICP_QAT_LOC_MEM1_MODE(uof_image->ae_mode);
+	ret = qat_hal_set_ae_lm_mode(handle, ae, ICP_LMEM1, mode);
+	if (ret) {
+		pr_err("QAT: qat_hal_set_ae_lm_mode LMEM1 error\n");
+		return ret;
+	}
+	return 0;
+}
+
 static int qat_uclo_set_ae_mode(struct icp_qat_fw_loader_handle *handle)
 {
-	unsigned char ae, nn_mode, s;
 	struct icp_qat_uof_image *uof_image;
 	struct icp_qat_uclo_aedata *ae_data;
 	struct icp_qat_uclo_objhandle *obj_handle = handle->obj_handle;
+	unsigned long ae_mask = handle->hal_handle->ae_mask;
+	unsigned char ae, s;
+	int error;
 
 	for (ae = 0; ae < handle->hal_handle->ae_max_num; ae++) {
-		if (!test_bit(ae,
-			      (unsigned long *)&handle->hal_handle->ae_mask))
+		if (!test_bit(ae, &ae_mask))
 			continue;
 		ae_data = &obj_handle->ae_data[ae];
 		for (s = 0; s < min_t(unsigned int, ae_data->slice_num,
@@ -886,29 +922,10 @@ static int qat_uclo_set_ae_mode(struct icp_qat_fw_loader_handle *handle)
 			if (!obj_handle->ae_data[ae].ae_slices[s].encap_image)
 				continue;
 			uof_image = ae_data->ae_slices[s].encap_image->img_ptr;
-			if (qat_hal_set_ae_ctx_mode(handle, ae,
-						    (char)ICP_QAT_CTX_MODE
-						    (uof_image->ae_mode))) {
-				pr_err("QAT: qat_hal_set_ae_ctx_mode error\n");
-				return -EFAULT;
-			}
-			nn_mode = ICP_QAT_NN_MODE(uof_image->ae_mode);
-			if (qat_hal_set_ae_nn_mode(handle, ae, nn_mode)) {
-				pr_err("QAT: qat_hal_set_ae_nn_mode error\n");
-				return -EFAULT;
-			}
-			if (qat_hal_set_ae_lm_mode(handle, ae, ICP_LMEM0,
-						   (char)ICP_QAT_LOC_MEM0_MODE
-						   (uof_image->ae_mode))) {
-				pr_err("QAT: qat_hal_set_ae_lm_mode LMEM0 error\n");
-				return -EFAULT;
-			}
-			if (qat_hal_set_ae_lm_mode(handle, ae, ICP_LMEM1,
-						   (char)ICP_QAT_LOC_MEM1_MODE
-						   (uof_image->ae_mode))) {
-				pr_err("QAT: qat_hal_set_ae_lm_mode LMEM1 error\n");
-				return -EFAULT;
-			}
+			error = qat_hal_set_modes(handle, obj_handle, ae,
+						  uof_image);
+			if (error)
+				return error;
 		}
 	}
 	return 0;
-- 
2.25.4

