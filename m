Return-Path: <SRS0=5ZxX=EM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8BAFC55179
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Nov 2020 11:29:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 57CBF206C1
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Nov 2020 11:29:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727256AbgKFL3F (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 6 Nov 2020 06:29:05 -0500
Received: from mga07.intel.com ([134.134.136.100]:59431 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727253AbgKFL3F (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 Nov 2020 06:29:05 -0500
IronPort-SDR: 2D2NK7fTDZi87tcY1oFeqAmBnDqsreg/fIPxvcvTTo2gI5wHGw4589FRLRbpUBAt8tFUR3RPi6
 4KPYrCVUshxQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9796"; a="233698318"
X-IronPort-AV: E=Sophos;i="5.77,456,1596524400"; 
   d="scan'208";a="233698318"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2020 03:29:04 -0800
IronPort-SDR: f3NvZofmzmqQrl7hPo4WrzzqSsGfcpYC7uj0dspkHJZz2LkPNjoU4KLTrKhVGtiLYaHAHDNh8U
 nL0KxlHl/y8Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,456,1596524400"; 
   d="scan'208";a="529779309"
Received: from haps801-neoncity02.sh.intel.com ([10.67.114.160])
  by fmsmga005.fm.intel.com with ESMTP; 06 Nov 2020 03:29:02 -0800
From:   Jack Xu <jack.xu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Jack Xu <jack.xu@intel.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH 18/32] crypto: qat - loader: add next neighbor to chip_info
Date:   Fri,  6 Nov 2020 19:27:56 +0800
Message-Id: <20201106112810.2566-19-jack.xu@intel.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20201106112810.2566-1-jack.xu@intel.com>
References: <20201106112810.2566-1-jack.xu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Introduce the next neighbor (NN) capability in chip_info as NN registers
are not supported in certain SKUs of QAT.

Signed-off-by: Jack Xu <jack.xu@intel.com>
Co-developed-by: Wojciech Ziemba <wojciech.ziemba@intel.com>
Signed-off-by: Wojciech Ziemba <wojciech.ziemba@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 .../crypto/qat/qat_common/icp_qat_fw_loader_handle.h |  1 +
 drivers/crypto/qat/qat_common/qat_hal.c              | 11 ++++++++++-
 drivers/crypto/qat/qat_common/qat_uclo.c             | 12 +++++++-----
 3 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/icp_qat_fw_loader_handle.h b/drivers/crypto/qat/qat_common/icp_qat_fw_loader_handle.h
index 6b1ad629357b..8025be597d18 100644
--- a/drivers/crypto/qat/qat_common/icp_qat_fw_loader_handle.h
+++ b/drivers/crypto/qat/qat_common/icp_qat_fw_loader_handle.h
@@ -24,6 +24,7 @@ struct icp_qat_fw_loader_hal_handle {
 
 struct icp_qat_fw_loader_chip_info {
 	bool sram_visible;
+	bool nn;
 	bool fw_auth;
 };
 
diff --git a/drivers/crypto/qat/qat_common/qat_hal.c b/drivers/crypto/qat/qat_common/qat_hal.c
index 2faf8638526c..e0d0ab43fd12 100644
--- a/drivers/crypto/qat/qat_common/qat_hal.c
+++ b/drivers/crypto/qat/qat_common/qat_hal.c
@@ -603,7 +603,9 @@ static int qat_hal_clear_gpr(struct icp_qat_fw_loader_handle *handle)
 		qat_hal_wr_ae_csr(handle, ae, AE_MISC_CONTROL, csr_val);
 		csr_val = qat_hal_rd_ae_csr(handle, ae, CTX_ENABLES);
 		csr_val &= IGNORE_W1C_MASK;
-		csr_val |= CE_NN_MODE;
+		if (handle->chip_info->nn)
+			csr_val |= CE_NN_MODE;
+
 		qat_hal_wr_ae_csr(handle, ae, CTX_ENABLES, csr_val);
 		qat_hal_wr_uwords(handle, ae, 0, ARRAY_SIZE(inst),
 				  (u64 *)inst);
@@ -665,10 +667,12 @@ static int qat_hal_chip_init(struct icp_qat_fw_loader_handle *handle,
 	case PCI_DEVICE_ID_INTEL_QAT_C62X:
 	case PCI_DEVICE_ID_INTEL_QAT_C3XXX:
 		handle->chip_info->sram_visible = false;
+		handle->chip_info->nn = true;
 		handle->chip_info->fw_auth = true;
 		break;
 	case PCI_DEVICE_ID_INTEL_QAT_DH895XCC:
 		handle->chip_info->sram_visible = true;
+		handle->chip_info->nn = true;
 		handle->chip_info->fw_auth = false;
 		break;
 	default:
@@ -1433,6 +1437,11 @@ int qat_hal_init_nn(struct icp_qat_fw_loader_handle *handle,
 {
 	int stat = 0;
 	unsigned char ctx;
+	if (!handle->chip_info->nn) {
+		dev_err(&handle->pci_dev->dev, "QAT: No next neigh in 0x%x\n",
+			handle->pci_dev->device);
+		return -EINVAL;
+	}
 
 	if (ctx_mask == 0)
 		return -EINVAL;
diff --git a/drivers/crypto/qat/qat_common/qat_uclo.c b/drivers/crypto/qat/qat_common/qat_uclo.c
index 5774916497bd..fce075874962 100644
--- a/drivers/crypto/qat/qat_common/qat_uclo.c
+++ b/drivers/crypto/qat/qat_common/qat_uclo.c
@@ -884,11 +884,13 @@ static int qat_hal_set_modes(struct icp_qat_fw_loader_handle *handle,
 		pr_err("QAT: qat_hal_set_ae_ctx_mode error\n");
 		return ret;
 	}
-	mode = ICP_QAT_NN_MODE(uof_image->ae_mode);
-	ret = qat_hal_set_ae_nn_mode(handle, ae, mode);
-	if (ret) {
-		pr_err("QAT: qat_hal_set_ae_nn_mode error\n");
-		return ret;
+	if (handle->chip_info->nn) {
+		mode = ICP_QAT_NN_MODE(uof_image->ae_mode);
+		ret = qat_hal_set_ae_nn_mode(handle, ae, mode);
+		if (ret) {
+			pr_err("QAT: qat_hal_set_ae_nn_mode error\n");
+			return ret;
+		}
 	}
 	mode = ICP_QAT_LOC_MEM0_MODE(uof_image->ae_mode);
 	ret = qat_hal_set_ae_lm_mode(handle, ae, ICP_LMEM0, mode);
-- 
2.25.4

