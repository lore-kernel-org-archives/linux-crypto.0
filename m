Return-Path: <SRS0=5ZxX=EM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22606C55178
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Nov 2020 11:28:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C9827206C1
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Nov 2020 11:28:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727150AbgKFL2t (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 6 Nov 2020 06:28:49 -0500
Received: from mga07.intel.com ([134.134.136.100]:59373 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727215AbgKFL2s (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 Nov 2020 06:28:48 -0500
IronPort-SDR: 9GOmNadidBPTK5rMh44ITzwyNGggVRcuPdJBCjQpSsA8HlxLf0uf6WGVQsKpvzgTr5e4nbZmig
 527ljyfrDp1Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9796"; a="233698292"
X-IronPort-AV: E=Sophos;i="5.77,456,1596524400"; 
   d="scan'208";a="233698292"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2020 03:28:48 -0800
IronPort-SDR: ZnDv4CsVIXgmuwF1OY2Lak8HKANEV7s7I9XK3oiBIL7LJE8sX8iGs7k9MdZs9CzsLLL/4mqxl+
 L19rVFvUS7qw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,456,1596524400"; 
   d="scan'208";a="529779224"
Received: from haps801-neoncity02.sh.intel.com ([10.67.114.160])
  by fmsmga005.fm.intel.com with ESMTP; 06 Nov 2020 03:28:46 -0800
From:   Jack Xu <jack.xu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Jack Xu <jack.xu@intel.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH 09/32] crypto: qat - loader: change type for ctx_mask
Date:   Fri,  6 Nov 2020 19:27:47 +0800
Message-Id: <20201106112810.2566-10-jack.xu@intel.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20201106112810.2566-1-jack.xu@intel.com>
References: <20201106112810.2566-1-jack.xu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Change type for ctx_mask from unsigned char to unsigned long to avoid
type casting.

Signed-off-by: Jack Xu <jack.xu@intel.com>
Co-developed-by: Wojciech Ziemba <wojciech.ziemba@intel.com>
Signed-off-by: Wojciech Ziemba <wojciech.ziemba@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/qat/qat_common/adf_common_drv.h |  8 ++++----
 drivers/crypto/qat/qat_common/qat_hal.c        | 16 ++++++++--------
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_common_drv.h b/drivers/crypto/qat/qat_common/adf_common_drv.h
index 22ac0517d15d..8109e2ab4257 100644
--- a/drivers/crypto/qat/qat_common/adf_common_drv.h
+++ b/drivers/crypto/qat/qat_common/adf_common_drv.h
@@ -163,19 +163,19 @@ int qat_hal_batch_wr_lm(struct icp_qat_fw_loader_handle *handle,
 			unsigned char ae,
 			struct icp_qat_uof_batch_init *lm_init_header);
 int qat_hal_init_gpr(struct icp_qat_fw_loader_handle *handle,
-		     unsigned char ae, unsigned char ctx_mask,
+		     unsigned char ae, unsigned long ctx_mask,
 		     enum icp_qat_uof_regtype reg_type,
 		     unsigned short reg_num, unsigned int regdata);
 int qat_hal_init_wr_xfer(struct icp_qat_fw_loader_handle *handle,
-			 unsigned char ae, unsigned char ctx_mask,
+			 unsigned char ae, unsigned long ctx_mask,
 			 enum icp_qat_uof_regtype reg_type,
 			 unsigned short reg_num, unsigned int regdata);
 int qat_hal_init_rd_xfer(struct icp_qat_fw_loader_handle *handle,
-			 unsigned char ae, unsigned char ctx_mask,
+			 unsigned char ae, unsigned long ctx_mask,
 			 enum icp_qat_uof_regtype reg_type,
 			 unsigned short reg_num, unsigned int regdata);
 int qat_hal_init_nn(struct icp_qat_fw_loader_handle *handle,
-		    unsigned char ae, unsigned char ctx_mask,
+		    unsigned char ae, unsigned long ctx_mask,
 		    unsigned short reg_num, unsigned int regdata);
 int qat_hal_wr_lm(struct icp_qat_fw_loader_handle *handle,
 		  unsigned char ae, unsigned short lm_addr, unsigned int value);
diff --git a/drivers/crypto/qat/qat_common/qat_hal.c b/drivers/crypto/qat/qat_common/qat_hal.c
index c628ea30e3c2..a9243758a959 100644
--- a/drivers/crypto/qat/qat_common/qat_hal.c
+++ b/drivers/crypto/qat/qat_common/qat_hal.c
@@ -1274,7 +1274,7 @@ static int qat_hal_convert_abs_to_rel(struct icp_qat_fw_loader_handle
 }
 
 int qat_hal_init_gpr(struct icp_qat_fw_loader_handle *handle,
-		     unsigned char ae, unsigned char ctx_mask,
+		     unsigned char ae, unsigned long ctx_mask,
 		     enum icp_qat_uof_regtype reg_type,
 		     unsigned short reg_num, unsigned int regdata)
 {
@@ -1294,7 +1294,7 @@ int qat_hal_init_gpr(struct icp_qat_fw_loader_handle *handle,
 		} else {
 			reg = reg_num;
 			type = reg_type;
-			if (!test_bit(ctx, (unsigned long *)&ctx_mask))
+			if (!test_bit(ctx, &ctx_mask))
 				continue;
 		}
 		stat = qat_hal_wr_rel_reg(handle, ae, ctx, type, reg, regdata);
@@ -1308,7 +1308,7 @@ int qat_hal_init_gpr(struct icp_qat_fw_loader_handle *handle,
 }
 
 int qat_hal_init_wr_xfer(struct icp_qat_fw_loader_handle *handle,
-			 unsigned char ae, unsigned char ctx_mask,
+			 unsigned char ae, unsigned long ctx_mask,
 			 enum icp_qat_uof_regtype reg_type,
 			 unsigned short reg_num, unsigned int regdata)
 {
@@ -1328,7 +1328,7 @@ int qat_hal_init_wr_xfer(struct icp_qat_fw_loader_handle *handle,
 		} else {
 			reg = reg_num;
 			type = reg_type;
-			if (!test_bit(ctx, (unsigned long *)&ctx_mask))
+			if (!test_bit(ctx, &ctx_mask))
 				continue;
 		}
 		stat = qat_hal_put_rel_wr_xfer(handle, ae, ctx, type, reg,
@@ -1343,7 +1343,7 @@ int qat_hal_init_wr_xfer(struct icp_qat_fw_loader_handle *handle,
 }
 
 int qat_hal_init_rd_xfer(struct icp_qat_fw_loader_handle *handle,
-			 unsigned char ae, unsigned char ctx_mask,
+			 unsigned char ae, unsigned long ctx_mask,
 			 enum icp_qat_uof_regtype reg_type,
 			 unsigned short reg_num, unsigned int regdata)
 {
@@ -1363,7 +1363,7 @@ int qat_hal_init_rd_xfer(struct icp_qat_fw_loader_handle *handle,
 		} else {
 			reg = reg_num;
 			type = reg_type;
-			if (!test_bit(ctx, (unsigned long *)&ctx_mask))
+			if (!test_bit(ctx, &ctx_mask))
 				continue;
 		}
 		stat = qat_hal_put_rel_rd_xfer(handle, ae, ctx, type, reg,
@@ -1378,7 +1378,7 @@ int qat_hal_init_rd_xfer(struct icp_qat_fw_loader_handle *handle,
 }
 
 int qat_hal_init_nn(struct icp_qat_fw_loader_handle *handle,
-		    unsigned char ae, unsigned char ctx_mask,
+		    unsigned char ae, unsigned long ctx_mask,
 		    unsigned short reg_num, unsigned int regdata)
 {
 	int stat = 0;
@@ -1388,7 +1388,7 @@ int qat_hal_init_nn(struct icp_qat_fw_loader_handle *handle,
 		return -EINVAL;
 
 	for (ctx = 0; ctx < ICP_QAT_UCLO_MAX_CTX; ctx++) {
-		if (!test_bit(ctx, (unsigned long *)&ctx_mask))
+		if (!test_bit(ctx, &ctx_mask))
 			continue;
 		stat = qat_hal_put_rel_nn(handle, ae, ctx, reg_num, regdata);
 		if (stat) {
-- 
2.25.4

