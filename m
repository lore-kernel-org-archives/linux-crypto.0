Return-Path: <SRS0=5ZxX=EM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EDA1C55179
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Nov 2020 11:28:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 37210206C1
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Nov 2020 11:28:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727230AbgKFL2x (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 6 Nov 2020 06:28:53 -0500
Received: from mga07.intel.com ([134.134.136.100]:59373 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727225AbgKFL2x (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 Nov 2020 06:28:53 -0500
IronPort-SDR: oDLTH2x+LYcc7tHLT1pjavogbhptNVcMXalG77o0fFElQK4+t0gFvCKhyZVU6nfaJsEikrZHTx
 gpOkNKQ2d+YQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9796"; a="233698297"
X-IronPort-AV: E=Sophos;i="5.77,456,1596524400"; 
   d="scan'208";a="233698297"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2020 03:28:51 -0800
IronPort-SDR: 4OFh1VFtRy7uAV7kEXNHTJ4Pd+9jPUT8P2vN+IsYkDvuuBpSj/fzEmaffuFQZXC/0AYk51nLc/
 fJrA+7ORHKwA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,456,1596524400"; 
   d="scan'208";a="529779241"
Received: from haps801-neoncity02.sh.intel.com ([10.67.114.160])
  by fmsmga005.fm.intel.com with ESMTP; 06 Nov 2020 03:28:50 -0800
From:   Jack Xu <jack.xu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Jack Xu <jack.xu@intel.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH 11/32] crypto: qat - loader: refactor AE start
Date:   Fri,  6 Nov 2020 19:27:49 +0800
Message-Id: <20201106112810.2566-12-jack.xu@intel.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20201106112810.2566-1-jack.xu@intel.com>
References: <20201106112810.2566-1-jack.xu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Change the API and the behaviour of the qat_hal_start() function.
With this change, the function starts under the hood all acceleration
engines (AEs) and there is no longer need to call it for each engine.

Signed-off-by: Jack Xu <jack.xu@intel.com>
Co-developed-by: Wojciech Ziemba <wojciech.ziemba@intel.com>
Signed-off-by: Wojciech Ziemba <wojciech.ziemba@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 .../crypto/qat/qat_common/adf_accel_engine.c  |  9 ++-----
 .../crypto/qat/qat_common/adf_common_drv.h    |  3 +--
 drivers/crypto/qat/qat_common/qat_hal.c       | 24 ++++++++++++-------
 3 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_accel_engine.c b/drivers/crypto/qat/qat_common/adf_accel_engine.c
index 2c4a8c7c736e..08aaaf2b4659 100644
--- a/drivers/crypto/qat/qat_common/adf_accel_engine.c
+++ b/drivers/crypto/qat/qat_common/adf_accel_engine.c
@@ -74,17 +74,12 @@ int adf_ae_start(struct adf_accel_dev *accel_dev)
 {
 	struct adf_fw_loader_data *loader_data = accel_dev->fw_loader;
 	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
-	u32 ae_ctr, ae, max_aes = GET_MAX_ACCELENGINES(accel_dev);
+	u32 ae_ctr;
 
 	if (!hw_data->fw_name)
 		return 0;
 
-	for (ae = 0, ae_ctr = 0; ae < max_aes; ae++) {
-		if (hw_data->ae_mask & (1 << ae)) {
-			qat_hal_start(loader_data->fw_loader, ae, 0xFF);
-			ae_ctr++;
-		}
-	}
+	ae_ctr = qat_hal_start(loader_data->fw_loader);
 	dev_info(&GET_DEV(accel_dev),
 		 "qat_dev%d started %d acceleration engines\n",
 		 accel_dev->accel_id, ae_ctr);
diff --git a/drivers/crypto/qat/qat_common/adf_common_drv.h b/drivers/crypto/qat/qat_common/adf_common_drv.h
index 8109e2ab4257..945608b71937 100644
--- a/drivers/crypto/qat/qat_common/adf_common_drv.h
+++ b/drivers/crypto/qat/qat_common/adf_common_drv.h
@@ -133,8 +133,7 @@ void adf_vf_isr_resource_free(struct adf_accel_dev *accel_dev);
 
 int qat_hal_init(struct adf_accel_dev *accel_dev);
 void qat_hal_deinit(struct icp_qat_fw_loader_handle *handle);
-void qat_hal_start(struct icp_qat_fw_loader_handle *handle, unsigned char ae,
-		   unsigned int ctx_mask);
+int qat_hal_start(struct icp_qat_fw_loader_handle *handle);
 void qat_hal_stop(struct icp_qat_fw_loader_handle *handle, unsigned char ae,
 		  unsigned int ctx_mask);
 void qat_hal_reset(struct icp_qat_fw_loader_handle *handle);
diff --git a/drivers/crypto/qat/qat_common/qat_hal.c b/drivers/crypto/qat/qat_common/qat_hal.c
index a9243758a959..f127233eec17 100644
--- a/drivers/crypto/qat/qat_common/qat_hal.c
+++ b/drivers/crypto/qat/qat_common/qat_hal.c
@@ -742,26 +742,32 @@ void qat_hal_deinit(struct icp_qat_fw_loader_handle *handle)
 	kfree(handle);
 }
 
-void qat_hal_start(struct icp_qat_fw_loader_handle *handle, unsigned char ae,
-		   unsigned int ctx_mask)
+int qat_hal_start(struct icp_qat_fw_loader_handle *handle)
 {
+	unsigned long ae_mask = handle->hal_handle->ae_mask;
+	unsigned int fcu_sts;
+	unsigned char ae;
+	u32 ae_ctr = 0;
 	int retry = 0;
-	unsigned int fcu_sts = 0;
 
 	if (handle->fw_auth) {
+		ae_ctr = hweight32(ae_mask);
 		SET_CAP_CSR(handle, FCU_CONTROL, FCU_CTRL_CMD_START);
 		do {
 			msleep(FW_AUTH_WAIT_PERIOD);
 			fcu_sts = GET_CAP_CSR(handle, FCU_STATUS);
 			if (((fcu_sts >> FCU_STS_DONE_POS) & 0x1))
-				return;
+				return ae_ctr;
 		} while (retry++ < FW_AUTH_MAX_RETRY);
-		pr_err("QAT: start error (AE 0x%x FCU_STS = 0x%x)\n", ae,
-		       fcu_sts);
+		pr_err("QAT: start error (FCU_STS = 0x%x)\n", fcu_sts);
+		return 0;
 	} else {
-		qat_hal_put_wakeup_event(handle, ae, (~ctx_mask) &
-				 ICP_QAT_UCLO_AE_ALL_CTX, 0x10000);
-		qat_hal_enable_ctx(handle, ae, ctx_mask);
+		for_each_set_bit(ae, &ae_mask, handle->hal_handle->ae_max_num) {
+			qat_hal_put_wakeup_event(handle, ae, 0, 0x10000);
+			qat_hal_enable_ctx(handle, ae, ICP_QAT_UCLO_AE_ALL_CTX);
+			ae_ctr++;
+		}
+		return ae_ctr;
 	}
 }
 
-- 
2.25.4

