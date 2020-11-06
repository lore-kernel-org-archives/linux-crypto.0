Return-Path: <SRS0=5ZxX=EM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2B33C2D0A3
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Nov 2020 11:29:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 804FC206B2
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Nov 2020 11:28:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727238AbgKFL2y (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 6 Nov 2020 06:28:54 -0500
Received: from mga07.intel.com ([134.134.136.100]:59373 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727225AbgKFL2y (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 Nov 2020 06:28:54 -0500
IronPort-SDR: i6VD55Vu9RgxFFd7FzVUgjNWxAQDQebDJzXxtZWTbS8Kqk26lWoP95VZO0/jFJxD+1jPR1wbj3
 NN+J0JhAMkag==
X-IronPort-AV: E=McAfee;i="6000,8403,9796"; a="233698304"
X-IronPort-AV: E=Sophos;i="5.77,456,1596524400"; 
   d="scan'208";a="233698304"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2020 03:28:53 -0800
IronPort-SDR: Cs4ymml5y9zKKOiEMVyKgfSFNXAF3mZLWX5hXdkOA+FXcopyCp9V3WQt+OyZJZRTA1gl1wk3we
 kZuDs1zW5Ubw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,456,1596524400"; 
   d="scan'208";a="529779247"
Received: from haps801-neoncity02.sh.intel.com ([10.67.114.160])
  by fmsmga005.fm.intel.com with ESMTP; 06 Nov 2020 03:28:52 -0800
From:   Jack Xu <jack.xu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Jack Xu <jack.xu@intel.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH 12/32] crypto: qat - loader: remove global CSRs helpers
Date:   Fri,  6 Nov 2020 19:27:50 +0800
Message-Id: <20201106112810.2566-13-jack.xu@intel.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20201106112810.2566-1-jack.xu@intel.com>
References: <20201106112810.2566-1-jack.xu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Include the offset of GLOBAL_CSR directly into the enum hal_global_csr
and remove the macros SET_GLB_CSR/GET_GLB_CSR to simplify the global CSR
access.

Signed-off-by: Jack Xu <jack.xu@intel.com>
Co-developed-by: Wojciech Ziemba <wojciech.ziemba@intel.com>
Signed-off-by: Wojciech Ziemba <wojciech.ziemba@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/qat/qat_common/icp_qat_hal.h |  9 +++------
 drivers/crypto/qat/qat_common/qat_hal.c     | 20 ++++++++++----------
 2 files changed, 13 insertions(+), 16 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/icp_qat_hal.h b/drivers/crypto/qat/qat_common/icp_qat_hal.h
index 5640bb278bb1..c2166dacdf5b 100644
--- a/drivers/crypto/qat/qat_common/icp_qat_hal.h
+++ b/drivers/crypto/qat/qat_common/icp_qat_hal.h
@@ -5,9 +5,9 @@
 #include "icp_qat_fw_loader_handle.h"
 
 enum hal_global_csr {
-	MISC_CONTROL = 0x04,
-	ICP_RESET = 0x0c,
-	ICP_GLOBAL_CLK_ENABLE = 0x50
+	MISC_CONTROL = 0xA04,
+	ICP_RESET = 0xA0c,
+	ICP_GLOBAL_CLK_ENABLE = 0xA50
 };
 
 enum hal_ae_csr {
@@ -78,7 +78,6 @@ enum fcu_sts {
 #define XCWE_VOLUNTARY              (0x1)
 #define LCS_STATUS          (0x1)
 #define MMC_SHARE_CS_BITPOS         2
-#define GLOBAL_CSR                0xA00
 #define FCU_CTRL_AE_POS     0x8
 #define FCU_AUTH_STS_MASK   0x7
 #define FCU_STS_DONE_POS    0x9
@@ -91,8 +90,6 @@ enum fcu_sts {
 	ADF_CSR_WR((handle)->hal_cap_g_ctl_csr_addr_v, csr, val)
 #define GET_CAP_CSR(handle, csr) \
 	ADF_CSR_RD((handle)->hal_cap_g_ctl_csr_addr_v, csr)
-#define SET_GLB_CSR(handle, csr, val) SET_CAP_CSR(handle, csr + GLOBAL_CSR, val)
-#define GET_GLB_CSR(handle, csr) GET_CAP_CSR(handle, GLOBAL_CSR + csr)
 #define AE_CSR(handle, ae) \
 	((char __iomem *)(handle)->hal_cap_ae_local_csr_addr_v + ((ae) << 12))
 #define AE_CSR_ADDR(handle, ae, csr) (AE_CSR(handle, ae) + (0x3ff & (csr)))
diff --git a/drivers/crypto/qat/qat_common/qat_hal.c b/drivers/crypto/qat/qat_common/qat_hal.c
index f127233eec17..15ebb57ea14a 100644
--- a/drivers/crypto/qat/qat_common/qat_hal.c
+++ b/drivers/crypto/qat/qat_common/qat_hal.c
@@ -273,10 +273,10 @@ void qat_hal_reset(struct icp_qat_fw_loader_handle *handle)
 {
 	unsigned int ae_reset_csr;
 
-	ae_reset_csr = GET_GLB_CSR(handle, ICP_RESET);
+	ae_reset_csr = GET_CAP_CSR(handle, ICP_RESET);
 	ae_reset_csr |= handle->hal_handle->ae_mask << RST_CSR_AE_LSB;
 	ae_reset_csr |= handle->hal_handle->slice_mask << RST_CSR_QAT_LSB;
-	SET_GLB_CSR(handle, ICP_RESET, ae_reset_csr);
+	SET_CAP_CSR(handle, ICP_RESET, ae_reset_csr);
 }
 
 static void qat_hal_wr_indr_csr(struct icp_qat_fw_loader_handle *handle,
@@ -390,9 +390,9 @@ static void qat_hal_reset_timestamp(struct icp_qat_fw_loader_handle *handle)
 	unsigned char ae;
 
 	/* stop the timestamp timers */
-	misc_ctl = GET_GLB_CSR(handle, MISC_CONTROL);
+	misc_ctl = GET_CAP_CSR(handle, MISC_CONTROL);
 	if (misc_ctl & MC_TIMESTAMP_ENABLE)
-		SET_GLB_CSR(handle, MISC_CONTROL, misc_ctl &
+		SET_CAP_CSR(handle, MISC_CONTROL, misc_ctl &
 			    (~MC_TIMESTAMP_ENABLE));
 
 	for_each_set_bit(ae, &ae_mask, handle->hal_handle->ae_max_num) {
@@ -400,7 +400,7 @@ static void qat_hal_reset_timestamp(struct icp_qat_fw_loader_handle *handle)
 		qat_hal_wr_ae_csr(handle, ae, TIMESTAMP_HIGH, 0);
 	}
 	/* start timestamp timers */
-	SET_GLB_CSR(handle, MISC_CONTROL, misc_ctl | MC_TIMESTAMP_ENABLE);
+	SET_CAP_CSR(handle, MISC_CONTROL, misc_ctl | MC_TIMESTAMP_ENABLE);
 }
 
 #define ESRAM_AUTO_TINIT	BIT(2)
@@ -448,21 +448,21 @@ int qat_hal_clr_reset(struct icp_qat_fw_loader_handle *handle)
 	unsigned int csr;
 
 	/* write to the reset csr */
-	ae_reset_csr = GET_GLB_CSR(handle, ICP_RESET);
+	ae_reset_csr = GET_CAP_CSR(handle, ICP_RESET);
 	ae_reset_csr &= ~(handle->hal_handle->ae_mask << RST_CSR_AE_LSB);
 	ae_reset_csr &= ~(handle->hal_handle->slice_mask << RST_CSR_QAT_LSB);
 	do {
-		SET_GLB_CSR(handle, ICP_RESET, ae_reset_csr);
+		SET_CAP_CSR(handle, ICP_RESET, ae_reset_csr);
 		if (!(times--))
 			goto out_err;
-		csr = GET_GLB_CSR(handle, ICP_RESET);
+		csr = GET_CAP_CSR(handle, ICP_RESET);
 	} while ((handle->hal_handle->ae_mask |
 		 (handle->hal_handle->slice_mask << RST_CSR_QAT_LSB)) & csr);
 	/* enable clock */
-	clk_csr = GET_GLB_CSR(handle, ICP_GLOBAL_CLK_ENABLE);
+	clk_csr = GET_CAP_CSR(handle, ICP_GLOBAL_CLK_ENABLE);
 	clk_csr |= handle->hal_handle->ae_mask << 0;
 	clk_csr |= handle->hal_handle->slice_mask << 20;
-	SET_GLB_CSR(handle, ICP_GLOBAL_CLK_ENABLE, clk_csr);
+	SET_CAP_CSR(handle, ICP_GLOBAL_CLK_ENABLE, clk_csr);
 	if (qat_hal_check_ae_alive(handle))
 		goto out_err;
 
-- 
2.25.4

