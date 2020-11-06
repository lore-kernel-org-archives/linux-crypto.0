Return-Path: <SRS0=5ZxX=EM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74688C2D0A3
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Nov 2020 11:29:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2867D206C1
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Nov 2020 11:29:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727251AbgKFL3L (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 6 Nov 2020 06:29:11 -0500
Received: from mga07.intel.com ([134.134.136.100]:59432 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727215AbgKFL3L (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 Nov 2020 06:29:11 -0500
IronPort-SDR: Bv13MaVyhdSLxy/7Q+BvTd6yX7OCgsUb5ImFZMOVFwViToQkIISIdsxp1V1QR+ax/Kk/XT8Rl+
 Lz2wX4tlsc1g==
X-IronPort-AV: E=McAfee;i="6000,8403,9796"; a="233698323"
X-IronPort-AV: E=Sophos;i="5.77,456,1596524400"; 
   d="scan'208";a="233698323"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2020 03:29:09 -0800
IronPort-SDR: AaGJ2bla/Fh85BJc/Cec6Vt8OAuBkO8fX4RiH2X9gfNQwxcN5v1u1t9tJUOeCNrMYRIofFyaLa
 r/cqJxwoGsYA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,456,1596524400"; 
   d="scan'208";a="529779332"
Received: from haps801-neoncity02.sh.intel.com ([10.67.114.160])
  by fmsmga005.fm.intel.com with ESMTP; 06 Nov 2020 03:29:07 -0800
From:   Jack Xu <jack.xu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Jack Xu <jack.xu@intel.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH 21/32] crypto: qat - loader: add reset CSR and mask to chip info
Date:   Fri,  6 Nov 2020 19:27:59 +0800
Message-Id: <20201106112810.2566-22-jack.xu@intel.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20201106112810.2566-1-jack.xu@intel.com>
References: <20201106112810.2566-1-jack.xu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add reset CSR offset and mask to chip info since they are different
in new QAT devices. This also simplifies the reset/clrReset functions
by using the reset mask.

Signed-off-by: Jack Xu <jack.xu@intel.com>
Co-developed-by: Wojciech Ziemba <wojciech.ziemba@intel.com>
Signed-off-by: Wojciech Ziemba <wojciech.ziemba@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 .../qat/qat_common/icp_qat_fw_loader_handle.h |  2 +
 drivers/crypto/qat/qat_common/qat_hal.c       | 39 +++++++++++--------
 2 files changed, 24 insertions(+), 17 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/icp_qat_fw_loader_handle.h b/drivers/crypto/qat/qat_common/icp_qat_fw_loader_handle.h
index 0fa5c22fd9c0..5e2c0ef6d26c 100644
--- a/drivers/crypto/qat/qat_common/icp_qat_fw_loader_handle.h
+++ b/drivers/crypto/qat/qat_common/icp_qat_fw_loader_handle.h
@@ -27,6 +27,8 @@ struct icp_qat_fw_loader_chip_info {
 	bool nn;
 	bool lm2lm3;
 	u32 lm_size;
+	u32 icp_rst_csr;
+	u32 icp_rst_mask;
 	bool fw_auth;
 };
 
diff --git a/drivers/crypto/qat/qat_common/qat_hal.c b/drivers/crypto/qat/qat_common/qat_hal.c
index 44cf797ace71..0d64e074fb44 100644
--- a/drivers/crypto/qat/qat_common/qat_hal.c
+++ b/drivers/crypto/qat/qat_common/qat_hal.c
@@ -301,12 +301,13 @@ static unsigned short qat_hal_get_reg_addr(unsigned int type,
 
 void qat_hal_reset(struct icp_qat_fw_loader_handle *handle)
 {
-	unsigned int ae_reset_csr;
+	unsigned int reset_mask = handle->chip_info->icp_rst_mask;
+	unsigned int reset_csr = handle->chip_info->icp_rst_csr;
+	unsigned int csr_val;
 
-	ae_reset_csr = GET_CAP_CSR(handle, ICP_RESET);
-	ae_reset_csr |= handle->hal_handle->ae_mask << RST_CSR_AE_LSB;
-	ae_reset_csr |= handle->hal_handle->slice_mask << RST_CSR_QAT_LSB;
-	SET_CAP_CSR(handle, ICP_RESET, ae_reset_csr);
+	csr_val = GET_CAP_CSR(handle, reset_csr);
+	csr_val |= reset_mask;
+	SET_CAP_CSR(handle, reset_csr, csr_val);
 }
 
 static void qat_hal_wr_indr_csr(struct icp_qat_fw_loader_handle *handle,
@@ -470,28 +471,27 @@ static int qat_hal_init_esram(struct icp_qat_fw_loader_handle *handle)
 #define SHRAM_INIT_CYCLES 2060
 int qat_hal_clr_reset(struct icp_qat_fw_loader_handle *handle)
 {
+	unsigned int reset_mask = handle->chip_info->icp_rst_mask;
+	unsigned int reset_csr = handle->chip_info->icp_rst_csr;
 	unsigned long ae_mask = handle->hal_handle->ae_mask;
-	unsigned int ae_reset_csr;
-	unsigned char ae;
+	unsigned char ae = 0;
 	unsigned int clk_csr;
 	unsigned int times = 100;
-	unsigned int csr;
+	unsigned int csr_val;
 
 	/* write to the reset csr */
-	ae_reset_csr = GET_CAP_CSR(handle, ICP_RESET);
-	ae_reset_csr &= ~(handle->hal_handle->ae_mask << RST_CSR_AE_LSB);
-	ae_reset_csr &= ~(handle->hal_handle->slice_mask << RST_CSR_QAT_LSB);
+	csr_val = GET_CAP_CSR(handle, reset_csr);
+	csr_val &= ~reset_mask;
 	do {
-		SET_CAP_CSR(handle, ICP_RESET, ae_reset_csr);
+		SET_CAP_CSR(handle, reset_csr, csr_val);
 		if (!(times--))
 			goto out_err;
-		csr = GET_CAP_CSR(handle, ICP_RESET);
-	} while ((handle->hal_handle->ae_mask |
-		 (handle->hal_handle->slice_mask << RST_CSR_QAT_LSB)) & csr);
+		csr_val = GET_CAP_CSR(handle, reset_csr);
+		csr_val &= reset_mask;
+	} while (csr_val);
 	/* enable clock */
 	clk_csr = GET_CAP_CSR(handle, ICP_GLOBAL_CLK_ENABLE);
-	clk_csr |= handle->hal_handle->ae_mask << 0;
-	clk_csr |= handle->hal_handle->slice_mask << 20;
+	clk_csr |= reset_mask;
 	SET_CAP_CSR(handle, ICP_GLOBAL_CLK_ENABLE, clk_csr);
 	if (qat_hal_check_ae_alive(handle))
 		goto out_err;
@@ -700,6 +700,7 @@ static int qat_hal_chip_init(struct icp_qat_fw_loader_handle *handle,
 		handle->chip_info->nn = true;
 		handle->chip_info->lm2lm3 = false;
 		handle->chip_info->lm_size = ICP_QAT_UCLO_MAX_LMEM_REG;
+		handle->chip_info->icp_rst_csr = ICP_RESET;
 		handle->chip_info->fw_auth = true;
 		break;
 	case PCI_DEVICE_ID_INTEL_QAT_DH895XCC:
@@ -707,6 +708,7 @@ static int qat_hal_chip_init(struct icp_qat_fw_loader_handle *handle,
 		handle->chip_info->nn = true;
 		handle->chip_info->lm2lm3 = false;
 		handle->chip_info->lm_size = ICP_QAT_UCLO_MAX_LMEM_REG;
+		handle->chip_info->icp_rst_csr = ICP_RESET;
 		handle->chip_info->fw_auth = false;
 		break;
 	default:
@@ -719,6 +721,9 @@ static int qat_hal_chip_init(struct icp_qat_fw_loader_handle *handle,
 			&pci_info->pci_bars[hw_data->get_sram_bar_id(hw_data)];
 		handle->hal_sram_addr_v = sram_bar->virt_addr;
 	}
+
+	handle->chip_info->icp_rst_mask = (hw_data->ae_mask << RST_CSR_AE_LSB) |
+					  (hw_data->accel_mask << RST_CSR_QAT_LSB);
 	handle->hal_cap_g_ctl_csr_addr_v =
 		(void __iomem *)((uintptr_t)misc_bar->virt_addr +
 				 ICP_QAT_CAP_OFFSET);
-- 
2.25.4

