Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0591C433F5
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Sep 2021 11:45:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 90E0F610E6
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Sep 2021 11:45:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240402AbhI1Lqq (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 28 Sep 2021 07:46:46 -0400
Received: from mga07.intel.com ([134.134.136.100]:37909 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240396AbhI1Lqo (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Sep 2021 07:46:44 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10120"; a="288339075"
X-IronPort-AV: E=Sophos;i="5.85,329,1624345200"; 
   d="scan'208";a="288339075"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2021 04:45:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,329,1624345200"; 
   d="scan'208";a="562224838"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.51])
  by fmsmga002.fm.intel.com with ESMTP; 28 Sep 2021 04:45:03 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Marco Chiappero <marco.chiappero@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH 09/12] crypto: qat - rename pfvf collision constants
Date:   Tue, 28 Sep 2021 12:44:37 +0100
Message-Id: <20210928114440.355368-10-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210928114440.355368-1-giovanni.cabiddu@intel.com>
References: <20210928114440.355368-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Marco Chiappero <marco.chiappero@intel.com>

Replace any reference of "IOV" with PFVF in the collision constants.

Signed-off-by: Marco Chiappero <marco.chiappero@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/qat/qat_common/adf_pf2vf_msg.c | 26 +++++++++----------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c b/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
index 22977001271c..5459f295fcd9 100644
--- a/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
+++ b/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
@@ -5,14 +5,14 @@
 #include "adf_common_drv.h"
 #include "adf_pf2vf_msg.h"
 
-#define ADF_IOV_MSG_COLLISION_DETECT_DELAY	10
-#define ADF_IOV_MSG_ACK_DELAY			2
-#define ADF_IOV_MSG_ACK_MAX_RETRY		100
-#define ADF_IOV_MSG_RETRY_DELAY			5
-#define ADF_IOV_MSG_MAX_RETRIES			3
-#define ADF_IOV_MSG_RESP_TIMEOUT	(ADF_IOV_MSG_ACK_DELAY * \
-					 ADF_IOV_MSG_ACK_MAX_RETRY + \
-					 ADF_IOV_MSG_COLLISION_DETECT_DELAY)
+#define ADF_PFVF_MSG_COLLISION_DETECT_DELAY	10
+#define ADF_PFVF_MSG_ACK_DELAY			2
+#define ADF_PFVF_MSG_ACK_MAX_RETRY		100
+#define ADF_PFVF_MSG_RETRY_DELAY		5
+#define ADF_PFVF_MSG_MAX_RETRIES		3
+#define ADF_PFVF_MSG_RESP_TIMEOUT	(ADF_PFVF_MSG_ACK_DELAY * \
+					 ADF_PFVF_MSG_ACK_MAX_RETRY + \
+					 ADF_PFVF_MSG_COLLISION_DETECT_DELAY)
 
 void adf_enable_vf2pf_interrupts(struct adf_accel_dev *accel_dev, u32 vf_mask)
 {
@@ -103,9 +103,9 @@ static int __adf_iov_putmsg(struct adf_accel_dev *accel_dev, u32 msg, u8 vf_nr)
 
 	/* Wait for confirmation from remote func it received the message */
 	do {
-		msleep(ADF_IOV_MSG_ACK_DELAY);
+		msleep(ADF_PFVF_MSG_ACK_DELAY);
 		val = ADF_CSR_RD(pmisc_bar_addr, pf2vf_offset);
-	} while ((val & int_bit) && (count++ < ADF_IOV_MSG_ACK_MAX_RETRY));
+	} while ((val & int_bit) && (count++ < ADF_PFVF_MSG_ACK_MAX_RETRY));
 
 	if (val != msg) {
 		dev_dbg(&GET_DEV(accel_dev),
@@ -146,8 +146,8 @@ int adf_iov_putmsg(struct adf_accel_dev *accel_dev, u32 msg, u8 vf_nr)
 	do {
 		ret = __adf_iov_putmsg(accel_dev, msg, vf_nr);
 		if (ret)
-			msleep(ADF_IOV_MSG_RETRY_DELAY);
-	} while (ret && (count++ < ADF_IOV_MSG_MAX_RETRIES));
+			msleep(ADF_PFVF_MSG_RETRY_DELAY);
+	} while (ret && (count++ < ADF_PFVF_MSG_MAX_RETRIES));
 
 	return ret;
 }
@@ -277,7 +277,7 @@ void adf_pf2vf_notify_restarting(struct adf_accel_dev *accel_dev)
 
 static int adf_vf2pf_request_version(struct adf_accel_dev *accel_dev)
 {
-	unsigned long timeout = msecs_to_jiffies(ADF_IOV_MSG_RESP_TIMEOUT);
+	unsigned long timeout = msecs_to_jiffies(ADF_PFVF_MSG_RESP_TIMEOUT);
 	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
 	u32 msg = 0;
 	int ret;
-- 
2.31.1

