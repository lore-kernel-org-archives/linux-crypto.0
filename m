Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74D5BC43460
	for <linux-crypto@archiver.kernel.org>; Mon, 17 May 2021 08:15:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 54CB361221
	for <linux-crypto@archiver.kernel.org>; Mon, 17 May 2021 08:15:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235463AbhEQIRK (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 17 May 2021 04:17:10 -0400
Received: from mga05.intel.com ([192.55.52.43]:28943 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235413AbhEQIRI (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 17 May 2021 04:17:08 -0400
IronPort-SDR: xlXiIj279b0Yp9m4niRtl8WhPENnJ0MJvxECeAFJJBRAXsd7JWlsrHs3Fk0kE5QWY3gtSvyVoE
 d6yTQbAadO5A==
X-IronPort-AV: E=McAfee;i="6200,9189,9986"; a="285940863"
X-IronPort-AV: E=Sophos;i="5.82,306,1613462400"; 
   d="scan'208";a="285940863"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2021 01:15:50 -0700
IronPort-SDR: m/ol3qU7M0U1zUZOBNOo9/SLLHzCfvCwQKUfPROnJC3d7g/61MXyJMqTF/bWVsFtyduedi2HUu
 QQfpkCbRJJVQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,306,1613462400"; 
   d="scan'208";a="410729280"
Received: from qat-server-296.sh.intel.com ([10.67.117.159])
  by orsmga002.jf.intel.com with ESMTP; 17 May 2021 01:15:48 -0700
From:   Jack Xu <jack.xu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Jack Xu <jack.xu@intel.com>,
        Zhehui Xiang <zhehui.xiang@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH 2/5] crypto: qat - check MMP size before writing to the SRAM
Date:   Mon, 17 May 2021 05:13:13 -0400
Message-Id: <20210517091316.69630-3-jack.xu@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517091316.69630-1-jack.xu@intel.com>
References: <20210517091316.69630-1-jack.xu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Change "sram_visible" to "mmp_sram_size" and compare it with the MMP
size to prevent an overly large MMP file being written to SRAM.

Signed-off-by: Jack Xu <jack.xu@intel.com>
Co-developed-by: Zhehui Xiang <zhehui.xiang@intel.com>
Signed-off-by: Zhehui Xiang <zhehui.xiang@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/qat/qat_common/icp_qat_fw_loader_handle.h | 2 +-
 drivers/crypto/qat/qat_common/qat_hal.c                  | 8 ++++----
 drivers/crypto/qat/qat_common/qat_uclo.c                 | 2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/icp_qat_fw_loader_handle.h b/drivers/crypto/qat/qat_common/icp_qat_fw_loader_handle.h
index b8f3463be6ef..7eb5daef4f88 100644
--- a/drivers/crypto/qat/qat_common/icp_qat_fw_loader_handle.h
+++ b/drivers/crypto/qat/qat_common/icp_qat_fw_loader_handle.h
@@ -24,7 +24,7 @@ struct icp_qat_fw_loader_hal_handle {
 };
 
 struct icp_qat_fw_loader_chip_info {
-	bool sram_visible;
+	int mmp_sram_size;
 	bool nn;
 	bool lm2lm3;
 	u32 lm_size;
diff --git a/drivers/crypto/qat/qat_common/qat_hal.c b/drivers/crypto/qat/qat_common/qat_hal.c
index bd3028126cbe..ed9b81347144 100644
--- a/drivers/crypto/qat/qat_common/qat_hal.c
+++ b/drivers/crypto/qat/qat_common/qat_hal.c
@@ -696,7 +696,7 @@ static int qat_hal_chip_init(struct icp_qat_fw_loader_handle *handle,
 	handle->pci_dev = pci_info->pci_dev;
 	switch (handle->pci_dev->device) {
 	case ADF_4XXX_PCI_DEVICE_ID:
-		handle->chip_info->sram_visible = false;
+		handle->chip_info->mmp_sram_size = 0;
 		handle->chip_info->nn = false;
 		handle->chip_info->lm2lm3 = true;
 		handle->chip_info->lm_size = ICP_QAT_UCLO_MAX_LMEM_REG_2X;
@@ -730,7 +730,7 @@ static int qat_hal_chip_init(struct icp_qat_fw_loader_handle *handle,
 		break;
 	case PCI_DEVICE_ID_INTEL_QAT_C62X:
 	case PCI_DEVICE_ID_INTEL_QAT_C3XXX:
-		handle->chip_info->sram_visible = false;
+		handle->chip_info->mmp_sram_size = 0;
 		handle->chip_info->nn = true;
 		handle->chip_info->lm2lm3 = false;
 		handle->chip_info->lm_size = ICP_QAT_UCLO_MAX_LMEM_REG;
@@ -763,7 +763,7 @@ static int qat_hal_chip_init(struct icp_qat_fw_loader_handle *handle,
 			+ LOCAL_TO_XFER_REG_OFFSET);
 		break;
 	case PCI_DEVICE_ID_INTEL_QAT_DH895XCC:
-		handle->chip_info->sram_visible = true;
+		handle->chip_info->mmp_sram_size = 0x40000;
 		handle->chip_info->nn = true;
 		handle->chip_info->lm2lm3 = false;
 		handle->chip_info->lm_size = ICP_QAT_UCLO_MAX_LMEM_REG;
@@ -800,7 +800,7 @@ static int qat_hal_chip_init(struct icp_qat_fw_loader_handle *handle,
 		goto out_err;
 	}
 
-	if (handle->chip_info->sram_visible) {
+	if (handle->chip_info->mmp_sram_size > 0) {
 		sram_bar =
 			&pci_info->pci_bars[hw_data->get_sram_bar_id(hw_data)];
 		handle->hal_sram_addr_v = sram_bar->virt_addr;
diff --git a/drivers/crypto/qat/qat_common/qat_uclo.c b/drivers/crypto/qat/qat_common/qat_uclo.c
index d2c2db58c93f..8adf25769128 100644
--- a/drivers/crypto/qat/qat_common/qat_uclo.c
+++ b/drivers/crypto/qat/qat_common/qat_uclo.c
@@ -1551,7 +1551,7 @@ int qat_uclo_wr_mimage(struct icp_qat_fw_loader_handle *handle,
 			status = qat_uclo_auth_fw(handle, desc);
 		qat_uclo_ummap_auth_fw(handle, &desc);
 	} else {
-		if (!handle->chip_info->sram_visible) {
+		if (handle->chip_info->mmp_sram_size < mem_size) {
 			dev_dbg(&handle->pci_dev->dev,
 				"QAT MMP fw not loaded for device 0x%x",
 				handle->pci_dev->device);
-- 
2.31.1

