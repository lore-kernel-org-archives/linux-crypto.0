Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5E61C433F5
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Sep 2021 11:45:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7CC5961139
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Sep 2021 11:45:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240401AbhI1Lqy (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 28 Sep 2021 07:46:54 -0400
Received: from mga07.intel.com ([134.134.136.100]:37939 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240399AbhI1Lqs (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Sep 2021 07:46:48 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10120"; a="288339083"
X-IronPort-AV: E=Sophos;i="5.85,329,1624345200"; 
   d="scan'208";a="288339083"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2021 04:45:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,329,1624345200"; 
   d="scan'208";a="562224894"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.51])
  by fmsmga002.fm.intel.com with ESMTP; 28 Sep 2021 04:45:06 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Marco Chiappero <marco.chiappero@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH 11/12] crypto: qat - extract send and wait from adf_vf2pf_request_version()
Date:   Tue, 28 Sep 2021 12:44:39 +0100
Message-Id: <20210928114440.355368-12-giovanni.cabiddu@intel.com>
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

In the function adf_vf2pf_request_version(), the VF sends a request to
the PF and waits for a response before parsing and handling it.

Since this pattern will be used by other requests, define a new
function, adf_send_vf2pf_req(), that only deals with sending a VF2PF
request and waiting for a response.

Signed-off-by: Marco Chiappero <marco.chiappero@intel.com>
Co-developed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/qat/qat_common/adf_pf2vf_msg.c | 50 ++++++++++++++-----
 1 file changed, 37 insertions(+), 13 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c b/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
index 23bcbb2e22e2..711f6e3f6673 100644
--- a/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
+++ b/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
@@ -181,6 +181,42 @@ int adf_send_vf2pf_msg(struct adf_accel_dev *accel_dev, u32 msg)
 	return adf_iov_putmsg(accel_dev, msg, 0);
 }
 
+/**
+ * adf_send_vf2pf_req() - send VF2PF request message
+ * @accel_dev:	Pointer to acceleration device.
+ * @msg:	Request message to send
+ *
+ * This function sends a message that requires a response from the VF to the PF
+ * and waits for a reply.
+ *
+ * Return: 0 on success, error code otherwise.
+ */
+static int adf_send_vf2pf_req(struct adf_accel_dev *accel_dev, u32 msg)
+{
+	unsigned long timeout = msecs_to_jiffies(ADF_PFVF_MSG_RESP_TIMEOUT);
+	int ret;
+
+	reinit_completion(&accel_dev->vf.iov_msg_completion);
+
+	/* Send request from VF to PF */
+	ret = adf_send_vf2pf_msg(accel_dev, msg);
+	if (ret) {
+		dev_err(&GET_DEV(accel_dev),
+			"Failed to send request msg to PF\n");
+		return ret;
+	}
+
+	/* Wait for response */
+	if (!wait_for_completion_timeout(&accel_dev->vf.iov_msg_completion,
+					 timeout)) {
+		dev_err(&GET_DEV(accel_dev),
+			"PFVF request/response message timeout expired\n");
+		return -EIO;
+	}
+
+	return 0;
+}
+
 void adf_vf2pf_req_hndl(struct adf_accel_vf_info *vf_info)
 {
 	struct adf_accel_dev *accel_dev = vf_info->accel_dev;
@@ -306,7 +342,6 @@ void adf_pf2vf_notify_restarting(struct adf_accel_dev *accel_dev)
 
 static int adf_vf2pf_request_version(struct adf_accel_dev *accel_dev)
 {
-	unsigned long timeout = msecs_to_jiffies(ADF_PFVF_MSG_RESP_TIMEOUT);
 	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
 	u32 msg = 0;
 	int ret;
@@ -316,24 +351,13 @@ static int adf_vf2pf_request_version(struct adf_accel_dev *accel_dev)
 	msg |= ADF_PFVF_COMPAT_THIS_VERSION << ADF_VF2PF_COMPAT_VER_REQ_SHIFT;
 	BUILD_BUG_ON(ADF_PFVF_COMPAT_THIS_VERSION > 255);
 
-	reinit_completion(&accel_dev->vf.iov_msg_completion);
-
-	/* Send request from VF to PF */
-	ret = adf_send_vf2pf_msg(accel_dev, msg);
+	ret = adf_send_vf2pf_req(accel_dev, msg);
 	if (ret) {
 		dev_err(&GET_DEV(accel_dev),
 			"Failed to send Compatibility Version Request.\n");
 		return ret;
 	}
 
-	/* Wait for response */
-	if (!wait_for_completion_timeout(&accel_dev->vf.iov_msg_completion,
-					 timeout)) {
-		dev_err(&GET_DEV(accel_dev),
-			"IOV request/response message timeout expired\n");
-		return -EIO;
-	}
-
 	/* Response from PF received, check compatibility */
 	switch (accel_dev->vf.compatible) {
 	case ADF_PF2VF_VF_COMPATIBLE:
-- 
2.31.1

