Return-Path: <SRS0=5ZxX=EM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E829AC2D0A3
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Nov 2020 11:29:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F510206C1
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Nov 2020 11:29:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727239AbgKFL3O (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 6 Nov 2020 06:29:14 -0500
Received: from mga07.intel.com ([134.134.136.100]:59432 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727220AbgKFL3N (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 Nov 2020 06:29:13 -0500
IronPort-SDR: SRudBIqzwkDgxtgiySDMhpiow20ANozodvDK442qQQi7hH93MIDyZvATUtSUtdavJKd/X77B3u
 QSNshqX/IchQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9796"; a="233698329"
X-IronPort-AV: E=Sophos;i="5.77,456,1596524400"; 
   d="scan'208";a="233698329"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2020 03:29:13 -0800
IronPort-SDR: xpfyq6X8TXYsjIlHTYcWLlOaUSMzZTECupoHpkkNa5TTkEol9ZwOekajC2dkuj3HK1CJJUVlwe
 rMTPk0jSFXOA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,456,1596524400"; 
   d="scan'208";a="529779344"
Received: from haps801-neoncity02.sh.intel.com ([10.67.114.160])
  by fmsmga005.fm.intel.com with ESMTP; 06 Nov 2020 03:29:11 -0800
From:   Jack Xu <jack.xu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Jack Xu <jack.xu@intel.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH 23/32] crypto: qat - loader: add wake up event to chip info
Date:   Fri,  6 Nov 2020 19:28:01 +0800
Message-Id: <20201106112810.2566-24-jack.xu@intel.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20201106112810.2566-1-jack.xu@intel.com>
References: <20201106112810.2566-1-jack.xu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add the wake up event to chip info since this value will be different
in the next generation of QAT devices.

Signed-off-by: Jack Xu <jack.xu@intel.com>
Co-developed-by: Wojciech Ziemba <wojciech.ziemba@intel.com>
Signed-off-by: Wojciech Ziemba <wojciech.ziemba@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/qat/qat_common/icp_qat_fw_loader_handle.h | 1 +
 drivers/crypto/qat/qat_common/icp_qat_hal.h              | 1 +
 drivers/crypto/qat/qat_common/qat_hal.c                  | 5 ++++-
 3 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/qat/qat_common/icp_qat_fw_loader_handle.h b/drivers/crypto/qat/qat_common/icp_qat_fw_loader_handle.h
index 1d6ab3407dc9..090c3e73938c 100644
--- a/drivers/crypto/qat/qat_common/icp_qat_fw_loader_handle.h
+++ b/drivers/crypto/qat/qat_common/icp_qat_fw_loader_handle.h
@@ -30,6 +30,7 @@ struct icp_qat_fw_loader_chip_info {
 	u32 icp_rst_csr;
 	u32 icp_rst_mask;
 	u32 glb_clk_enable_csr;
+	u32 wakeup_event_val;
 	bool fw_auth;
 };
 
diff --git a/drivers/crypto/qat/qat_common/icp_qat_hal.h b/drivers/crypto/qat/qat_common/icp_qat_hal.h
index 82ac33a4500f..b3aa4c8a3ba8 100644
--- a/drivers/crypto/qat/qat_common/icp_qat_hal.h
+++ b/drivers/crypto/qat/qat_common/icp_qat_hal.h
@@ -87,6 +87,7 @@ enum fcu_sts {
 #define XCWE_VOLUNTARY              (0x1)
 #define LCS_STATUS          (0x1)
 #define MMC_SHARE_CS_BITPOS         2
+#define WAKEUP_EVENT 0x10000
 #define FCU_CTRL_AE_POS     0x8
 #define FCU_AUTH_STS_MASK   0x7
 #define FCU_STS_DONE_POS    0x9
diff --git a/drivers/crypto/qat/qat_common/qat_hal.c b/drivers/crypto/qat/qat_common/qat_hal.c
index 6e6bca281ab7..c073e4e3e3ae 100644
--- a/drivers/crypto/qat/qat_common/qat_hal.c
+++ b/drivers/crypto/qat/qat_common/qat_hal.c
@@ -702,6 +702,7 @@ static int qat_hal_chip_init(struct icp_qat_fw_loader_handle *handle,
 		handle->chip_info->lm_size = ICP_QAT_UCLO_MAX_LMEM_REG;
 		handle->chip_info->icp_rst_csr = ICP_RESET;
 		handle->chip_info->glb_clk_enable_csr = ICP_GLOBAL_CLK_ENABLE;
+		handle->chip_info->wakeup_event_val = WAKEUP_EVENT;
 		handle->chip_info->fw_auth = true;
 		break;
 	case PCI_DEVICE_ID_INTEL_QAT_DH895XCC:
@@ -711,6 +712,7 @@ static int qat_hal_chip_init(struct icp_qat_fw_loader_handle *handle,
 		handle->chip_info->lm_size = ICP_QAT_UCLO_MAX_LMEM_REG;
 		handle->chip_info->icp_rst_csr = ICP_RESET;
 		handle->chip_info->glb_clk_enable_csr = ICP_GLOBAL_CLK_ENABLE;
+		handle->chip_info->wakeup_event_val = WAKEUP_EVENT;
 		handle->chip_info->fw_auth = false;
 		break;
 	default:
@@ -834,6 +836,7 @@ void qat_hal_deinit(struct icp_qat_fw_loader_handle *handle)
 int qat_hal_start(struct icp_qat_fw_loader_handle *handle)
 {
 	unsigned long ae_mask = handle->hal_handle->ae_mask;
+	u32 wakeup_val = handle->chip_info->wakeup_event_val;
 	unsigned int fcu_sts;
 	unsigned char ae;
 	u32 ae_ctr = 0;
@@ -852,7 +855,7 @@ int qat_hal_start(struct icp_qat_fw_loader_handle *handle)
 		return 0;
 	} else {
 		for_each_set_bit(ae, &ae_mask, handle->hal_handle->ae_max_num) {
-			qat_hal_put_wakeup_event(handle, ae, 0, 0x10000);
+			qat_hal_put_wakeup_event(handle, ae, 0, wakeup_val);
 			qat_hal_enable_ctx(handle, ae, ICP_QAT_UCLO_AE_ALL_CTX);
 			ae_ctr++;
 		}
-- 
2.25.4

