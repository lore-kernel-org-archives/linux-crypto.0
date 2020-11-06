Return-Path: <SRS0=5ZxX=EM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14549C55178
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Nov 2020 11:29:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C1086206C1
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Nov 2020 11:29:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727215AbgKFL3M (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 6 Nov 2020 06:29:12 -0500
Received: from mga07.intel.com ([134.134.136.100]:59432 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727239AbgKFL3M (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 Nov 2020 06:29:12 -0500
IronPort-SDR: 5i+OWs85l3dRDgAWXmwlbLqTGvTBSnJmz0TZCRv7OIXocH43hm2T13BZuuRNzZ/Oe2+O4Gw6XR
 BxXe5Lwj9WWw==
X-IronPort-AV: E=McAfee;i="6000,8403,9796"; a="233698325"
X-IronPort-AV: E=Sophos;i="5.77,456,1596524400"; 
   d="scan'208";a="233698325"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2020 03:29:11 -0800
IronPort-SDR: awki2AW2TR+aGlIixfEzSeQ7HxPLVidGU1+qBM7297RBKkWwO/KVgyvwIjMpUJvlui8eYCOcG6
 YujnWTw2K/uw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,456,1596524400"; 
   d="scan'208";a="529779341"
Received: from haps801-neoncity02.sh.intel.com ([10.67.114.160])
  by fmsmga005.fm.intel.com with ESMTP; 06 Nov 2020 03:29:09 -0800
From:   Jack Xu <jack.xu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Jack Xu <jack.xu@intel.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH 22/32] crypto: qat - loader: add clock enable CSR to chip info
Date:   Fri,  6 Nov 2020 19:28:00 +0800
Message-Id: <20201106112810.2566-23-jack.xu@intel.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20201106112810.2566-1-jack.xu@intel.com>
References: <20201106112810.2566-1-jack.xu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add global clock enable CSR to the chip info since the CSR offset
will be different in the next generation of QAT devices.

Signed-off-by: Jack Xu <jack.xu@intel.com>
Co-developed-by: Wojciech Ziemba <wojciech.ziemba@intel.com>
Signed-off-by: Wojciech Ziemba <wojciech.ziemba@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 .../crypto/qat/qat_common/icp_qat_fw_loader_handle.h   |  1 +
 drivers/crypto/qat/qat_common/qat_hal.c                | 10 ++++++----
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/icp_qat_fw_loader_handle.h b/drivers/crypto/qat/qat_common/icp_qat_fw_loader_handle.h
index 5e2c0ef6d26c..1d6ab3407dc9 100644
--- a/drivers/crypto/qat/qat_common/icp_qat_fw_loader_handle.h
+++ b/drivers/crypto/qat/qat_common/icp_qat_fw_loader_handle.h
@@ -29,6 +29,7 @@ struct icp_qat_fw_loader_chip_info {
 	u32 lm_size;
 	u32 icp_rst_csr;
 	u32 icp_rst_mask;
+	u32 glb_clk_enable_csr;
 	bool fw_auth;
 };
 
diff --git a/drivers/crypto/qat/qat_common/qat_hal.c b/drivers/crypto/qat/qat_common/qat_hal.c
index 0d64e074fb44..6e6bca281ab7 100644
--- a/drivers/crypto/qat/qat_common/qat_hal.c
+++ b/drivers/crypto/qat/qat_common/qat_hal.c
@@ -471,11 +471,11 @@ static int qat_hal_init_esram(struct icp_qat_fw_loader_handle *handle)
 #define SHRAM_INIT_CYCLES 2060
 int qat_hal_clr_reset(struct icp_qat_fw_loader_handle *handle)
 {
+	unsigned int clk_csr = handle->chip_info->glb_clk_enable_csr;
 	unsigned int reset_mask = handle->chip_info->icp_rst_mask;
 	unsigned int reset_csr = handle->chip_info->icp_rst_csr;
 	unsigned long ae_mask = handle->hal_handle->ae_mask;
 	unsigned char ae = 0;
-	unsigned int clk_csr;
 	unsigned int times = 100;
 	unsigned int csr_val;
 
@@ -490,9 +490,9 @@ int qat_hal_clr_reset(struct icp_qat_fw_loader_handle *handle)
 		csr_val &= reset_mask;
 	} while (csr_val);
 	/* enable clock */
-	clk_csr = GET_CAP_CSR(handle, ICP_GLOBAL_CLK_ENABLE);
-	clk_csr |= reset_mask;
-	SET_CAP_CSR(handle, ICP_GLOBAL_CLK_ENABLE, clk_csr);
+	csr_val = GET_CAP_CSR(handle, clk_csr);
+	csr_val |= reset_mask;
+	SET_CAP_CSR(handle, clk_csr, csr_val);
 	if (qat_hal_check_ae_alive(handle))
 		goto out_err;
 
@@ -701,6 +701,7 @@ static int qat_hal_chip_init(struct icp_qat_fw_loader_handle *handle,
 		handle->chip_info->lm2lm3 = false;
 		handle->chip_info->lm_size = ICP_QAT_UCLO_MAX_LMEM_REG;
 		handle->chip_info->icp_rst_csr = ICP_RESET;
+		handle->chip_info->glb_clk_enable_csr = ICP_GLOBAL_CLK_ENABLE;
 		handle->chip_info->fw_auth = true;
 		break;
 	case PCI_DEVICE_ID_INTEL_QAT_DH895XCC:
@@ -709,6 +710,7 @@ static int qat_hal_chip_init(struct icp_qat_fw_loader_handle *handle,
 		handle->chip_info->lm2lm3 = false;
 		handle->chip_info->lm_size = ICP_QAT_UCLO_MAX_LMEM_REG;
 		handle->chip_info->icp_rst_csr = ICP_RESET;
+		handle->chip_info->glb_clk_enable_csr = ICP_GLOBAL_CLK_ENABLE;
 		handle->chip_info->fw_auth = false;
 		break;
 	default:
-- 
2.25.4

