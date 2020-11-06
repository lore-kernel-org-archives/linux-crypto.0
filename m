Return-Path: <SRS0=5ZxX=EM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D36DC55179
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Nov 2020 11:29:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 348A0206C1
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Nov 2020 11:29:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727260AbgKFL3P (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 6 Nov 2020 06:29:15 -0500
Received: from mga07.intel.com ([134.134.136.100]:59432 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727253AbgKFL3P (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 Nov 2020 06:29:15 -0500
IronPort-SDR: 2YsR7VRBKtXkoD6kHhEWSNIPjJF5GXAtZaoi62c23CTpLrnNZdeFKLwfCXSv3x6zlQOt5de5CK
 sWiVqH9PQfiw==
X-IronPort-AV: E=McAfee;i="6000,8403,9796"; a="233698334"
X-IronPort-AV: E=Sophos;i="5.77,456,1596524400"; 
   d="scan'208";a="233698334"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2020 03:29:14 -0800
IronPort-SDR: 9XKlYgyarV6Ym06TbRmveJWkOlAK0PjWXmHHPO5rTWGF1mp2RYdQPwrPKp1448E/oPOzX0CNb9
 XfTljXAQBYXg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,456,1596524400"; 
   d="scan'208";a="529779351"
Received: from haps801-neoncity02.sh.intel.com ([10.67.114.160])
  by fmsmga005.fm.intel.com with ESMTP; 06 Nov 2020 03:29:13 -0800
From:   Jack Xu <jack.xu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Jack Xu <jack.xu@intel.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH 24/32] crypto: qat - loader: add misc control CSR to chip info
Date:   Fri,  6 Nov 2020 19:28:02 +0800
Message-Id: <20201106112810.2566-25-jack.xu@intel.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20201106112810.2566-1-jack.xu@intel.com>
References: <20201106112810.2566-1-jack.xu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add misc control CSR to chip info since the CSR offset will be different
in the next generation of QAT devices.

Signed-off-by: Jack Xu <jack.xu@intel.com>
Co-developed-by: Wojciech Ziemba <wojciech.ziemba@intel.com>
Signed-off-by: Wojciech Ziemba <wojciech.ziemba@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 .../crypto/qat/qat_common/icp_qat_fw_loader_handle.h  |  1 +
 drivers/crypto/qat/qat_common/qat_hal.c               | 11 +++++++----
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/icp_qat_fw_loader_handle.h b/drivers/crypto/qat/qat_common/icp_qat_fw_loader_handle.h
index 090c3e73938c..81dba42248bf 100644
--- a/drivers/crypto/qat/qat_common/icp_qat_fw_loader_handle.h
+++ b/drivers/crypto/qat/qat_common/icp_qat_fw_loader_handle.h
@@ -30,6 +30,7 @@ struct icp_qat_fw_loader_chip_info {
 	u32 icp_rst_csr;
 	u32 icp_rst_mask;
 	u32 glb_clk_enable_csr;
+	u32 misc_ctl_csr;
 	u32 wakeup_event_val;
 	bool fw_auth;
 };
diff --git a/drivers/crypto/qat/qat_common/qat_hal.c b/drivers/crypto/qat/qat_common/qat_hal.c
index c073e4e3e3ae..eae1a5e0efeb 100644
--- a/drivers/crypto/qat/qat_common/qat_hal.c
+++ b/drivers/crypto/qat/qat_common/qat_hal.c
@@ -417,13 +417,14 @@ int qat_hal_check_ae_active(struct icp_qat_fw_loader_handle *handle,
 static void qat_hal_reset_timestamp(struct icp_qat_fw_loader_handle *handle)
 {
 	unsigned long ae_mask = handle->hal_handle->ae_mask;
-	unsigned int misc_ctl;
+	unsigned int misc_ctl_csr, misc_ctl;
 	unsigned char ae;
 
+	misc_ctl_csr = handle->chip_info->misc_ctl_csr;
 	/* stop the timestamp timers */
-	misc_ctl = GET_CAP_CSR(handle, MISC_CONTROL);
+	misc_ctl = GET_CAP_CSR(handle, misc_ctl_csr);
 	if (misc_ctl & MC_TIMESTAMP_ENABLE)
-		SET_CAP_CSR(handle, MISC_CONTROL, misc_ctl &
+		SET_CAP_CSR(handle, misc_ctl_csr, misc_ctl &
 			    (~MC_TIMESTAMP_ENABLE));
 
 	for_each_set_bit(ae, &ae_mask, handle->hal_handle->ae_max_num) {
@@ -431,7 +432,7 @@ static void qat_hal_reset_timestamp(struct icp_qat_fw_loader_handle *handle)
 		qat_hal_wr_ae_csr(handle, ae, TIMESTAMP_HIGH, 0);
 	}
 	/* start timestamp timers */
-	SET_CAP_CSR(handle, MISC_CONTROL, misc_ctl | MC_TIMESTAMP_ENABLE);
+	SET_CAP_CSR(handle, misc_ctl_csr, misc_ctl | MC_TIMESTAMP_ENABLE);
 }
 
 #define ESRAM_AUTO_TINIT	BIT(2)
@@ -702,6 +703,7 @@ static int qat_hal_chip_init(struct icp_qat_fw_loader_handle *handle,
 		handle->chip_info->lm_size = ICP_QAT_UCLO_MAX_LMEM_REG;
 		handle->chip_info->icp_rst_csr = ICP_RESET;
 		handle->chip_info->glb_clk_enable_csr = ICP_GLOBAL_CLK_ENABLE;
+		handle->chip_info->misc_ctl_csr = MISC_CONTROL;
 		handle->chip_info->wakeup_event_val = WAKEUP_EVENT;
 		handle->chip_info->fw_auth = true;
 		break;
@@ -712,6 +714,7 @@ static int qat_hal_chip_init(struct icp_qat_fw_loader_handle *handle,
 		handle->chip_info->lm_size = ICP_QAT_UCLO_MAX_LMEM_REG;
 		handle->chip_info->icp_rst_csr = ICP_RESET;
 		handle->chip_info->glb_clk_enable_csr = ICP_GLOBAL_CLK_ENABLE;
+		handle->chip_info->misc_ctl_csr = MISC_CONTROL;
 		handle->chip_info->wakeup_event_val = WAKEUP_EVENT;
 		handle->chip_info->fw_auth = false;
 		break;
-- 
2.25.4

