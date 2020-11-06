Return-Path: <SRS0=5ZxX=EM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68FE6C55179
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Nov 2020 11:28:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1F1AA206C1
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Nov 2020 11:28:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727191AbgKFL2n (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 6 Nov 2020 06:28:43 -0500
Received: from mga07.intel.com ([134.134.136.100]:59373 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727171AbgKFL2l (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 Nov 2020 06:28:41 -0500
IronPort-SDR: 2mACi1kv4xwaocq6P2lqegFey34x6moEj2bsroVI2KT4dwe+ZkCX1rxe9eoOwPQtahKoaKP5al
 bTCOWpUYTNJg==
X-IronPort-AV: E=McAfee;i="6000,8403,9796"; a="233698284"
X-IronPort-AV: E=Sophos;i="5.77,456,1596524400"; 
   d="scan'208";a="233698284"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2020 03:28:41 -0800
IronPort-SDR: 8A9cqJxd3Oj4DT6LTAaH9M9biZwTVxxShU4X7llizljWd3Qvgt4qhDfkn6N3TDXzhpa2MiKxh4
 Vr4daj0GgJyQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,456,1596524400"; 
   d="scan'208";a="529779188"
Received: from haps801-neoncity02.sh.intel.com ([10.67.114.160])
  by fmsmga005.fm.intel.com with ESMTP; 06 Nov 2020 03:28:39 -0800
From:   Jack Xu <jack.xu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Jack Xu <jack.xu@intel.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH 05/32] crypto: qat - loader: remove unnecessary parenthesis
Date:   Fri,  6 Nov 2020 19:27:43 +0800
Message-Id: <20201106112810.2566-6-jack.xu@intel.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20201106112810.2566-1-jack.xu@intel.com>
References: <20201106112810.2566-1-jack.xu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Remove unnecessary parenthesis across the firmware loader.

Signed-off-by: Jack Xu <jack.xu@intel.com>
Co-developed-by: Wojciech Ziemba <wojciech.ziemba@intel.com>
Signed-off-by: Wojciech Ziemba <wojciech.ziemba@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/qat/qat_common/qat_hal.c  |  6 +++---
 drivers/crypto/qat/qat_common/qat_uclo.c | 16 ++++++++--------
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/qat_hal.c b/drivers/crypto/qat/qat_common/qat_hal.c
index 5da8475ed876..bbfb2b1b6fee 100644
--- a/drivers/crypto/qat/qat_common/qat_hal.c
+++ b/drivers/crypto/qat/qat_common/qat_hal.c
@@ -158,7 +158,7 @@ int qat_hal_set_ae_ctx_mode(struct icp_qat_fw_loader_handle *handle,
 {
 	unsigned int csr, new_csr;
 
-	if ((mode != 4) && (mode != 8)) {
+	if (mode != 4 && mode != 8) {
 		pr_err("QAT: bad ctx mode=%d\n", mode);
 		return -EINVAL;
 	}
@@ -430,7 +430,7 @@ static int qat_hal_init_esram(struct icp_qat_fw_loader_handle *handle)
 		qat_hal_wait_cycles(handle, 0, ESRAM_AUTO_INIT_USED_CYCLES, 0);
 		csr_val = ADF_CSR_RD(csr_addr, 0);
 	} while (!(csr_val & ESRAM_AUTO_TINIT_DONE) && times--);
-	if ((times < 0)) {
+	if (times < 0) {
 		pr_err("QAT: Fail to init eSram!\n");
 		return -EFAULT;
 	}
@@ -1128,7 +1128,7 @@ int qat_hal_batch_wr_lm(struct icp_qat_fw_loader_handle *handle,
 		plm_init = plm_init->next;
 	}
 	/* exec micro codes */
-	if (micro_inst_arry && (micro_inst_num > 0)) {
+	if (micro_inst_arry && micro_inst_num > 0) {
 		micro_inst_arry[micro_inst_num++] = 0x0E000010000ull;
 		stat = qat_hal_exec_micro_init_lm(handle, ae, 0, &first_exec,
 						  micro_inst_arry,
diff --git a/drivers/crypto/qat/qat_common/qat_uclo.c b/drivers/crypto/qat/qat_common/qat_uclo.c
index 063af33c6ca6..4b2079353aa3 100644
--- a/drivers/crypto/qat/qat_common/qat_uclo.c
+++ b/drivers/crypto/qat/qat_common/qat_uclo.c
@@ -74,7 +74,7 @@ static int qat_uclo_free_ae_data(struct icp_qat_uclo_aedata *ae_data)
 static char *qat_uclo_get_string(struct icp_qat_uof_strtable *str_table,
 				 unsigned int str_offset)
 {
-	if ((!str_table->table_len) || (str_offset > str_table->table_len))
+	if (!str_table->table_len || str_offset > str_table->table_len)
 		return NULL;
 	return (char *)(((uintptr_t)(str_table->strings)) + str_offset);
 }
@@ -736,8 +736,8 @@ static int qat_uclo_check_uof_compat(struct icp_qat_uclo_objhandle *obj_handle)
 		return -EINVAL;
 	}
 	maj_ver = obj_handle->prod_rev & 0xff;
-	if ((obj_handle->encap_uof_obj.obj_hdr->max_cpu_ver < maj_ver) ||
-	    (obj_handle->encap_uof_obj.obj_hdr->min_cpu_ver > maj_ver)) {
+	if (obj_handle->encap_uof_obj.obj_hdr->max_cpu_ver < maj_ver ||
+	    obj_handle->encap_uof_obj.obj_hdr->min_cpu_ver > maj_ver) {
 		pr_err("QAT: UOF majVer 0x%x out of range\n", maj_ver);
 		return -EINVAL;
 	}
@@ -1064,8 +1064,8 @@ static int qat_uclo_check_simg_compat(struct icp_qat_fw_loader_handle *handle,
 		return -EINVAL;
 	}
 	maj_ver = prod_rev & 0xff;
-	if ((maj_ver > img_ae_mode->devmax_ver) ||
-	    (maj_ver < img_ae_mode->devmin_ver)) {
+	if (maj_ver > img_ae_mode->devmax_ver ||
+	    maj_ver < img_ae_mode->devmin_ver) {
 		pr_err("QAT: incompatible device majver 0x%x\n", maj_ver);
 		return -EINVAL;
 	}
@@ -1108,7 +1108,7 @@ static int qat_uclo_map_suof(struct icp_qat_fw_loader_handle *handle,
 	unsigned int i = 0;
 	struct icp_qat_suof_img_hdr img_header;
 
-	if (!suof_ptr || (suof_size == 0)) {
+	if (!suof_ptr || suof_size == 0) {
 		pr_err("QAT: input parameter SUOF pointer/size is NULL\n");
 		return -EINVAL;
 	}
@@ -1199,7 +1199,7 @@ static void qat_uclo_simg_free(struct icp_qat_fw_loader_handle *handle,
 {
 	dma_free_coherent(&handle->pci_dev->dev,
 			  (size_t)(dram_desc->dram_size),
-			  (dram_desc->dram_base_addr_v),
+			  dram_desc->dram_base_addr_v,
 			  dram_desc->dram_bus_addr);
 	memset(dram_desc, 0, sizeof(*dram_desc));
 }
@@ -1851,7 +1851,7 @@ static int qat_uclo_wr_suof_img(struct icp_qat_fw_loader_handle *handle)
 		if (qat_uclo_map_auth_fw(handle,
 					 (char *)simg_hdr[i].simg_buf,
 					 (unsigned int)
-					 (simg_hdr[i].simg_len),
+					 simg_hdr[i].simg_len,
 					 &desc))
 			goto wr_err;
 		if (qat_uclo_auth_fw(handle, desc))
-- 
2.25.4

