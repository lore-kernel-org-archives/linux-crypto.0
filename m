Return-Path: <SRS0=adZw=7Y=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7F8AC433E2
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Jun 2020 21:22:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AFB312074B
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Jun 2020 21:22:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726306AbgFKVWD (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 11 Jun 2020 17:22:03 -0400
Received: from mga04.intel.com ([192.55.52.120]:17090 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726153AbgFKVWD (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 11 Jun 2020 17:22:03 -0400
IronPort-SDR: cF1aINz6yiItCEHDSHy2g/vdhszuupZRNHNm8/NuJ9vW1HENL1HZzHDJOX4kPkLILp/wZ0JA31
 y0ddmskqvBww==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2020 14:22:02 -0700
IronPort-SDR: mRseaWrMjz0pJyzej3uEp+7dFkgbn8Xe0S8ia8fU1PskZ3VKoJJDRKv/5teWvPhkdOOLgKek8Q
 n35IUoU1qgDA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,501,1583222400"; 
   d="scan'208";a="314926405"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.51])
  by FMSMGA003.fm.intel.com with ESMTP; 11 Jun 2020 14:22:01 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org,
        Wojciech Ziemba <wojciech.ziemba@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH 2/3] crypto: qat - send admin messages to set of AEs
Date:   Thu, 11 Jun 2020 22:14:48 +0100
Message-Id: <20200611211449.76144-3-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200611211449.76144-1-giovanni.cabiddu@intel.com>
References: <20200611211449.76144-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Wojciech Ziemba <wojciech.ziemba@intel.com>

Update the logic that sends admin messages to be able to target a subset
of Acceleration Engines (AEs) in the device.
In future not all admin messages need to be sent to all the AEs.

Signed-off-by: Wojciech Ziemba <wojciech.ziemba@intel.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/qat/qat_common/adf_admin.c | 64 ++++++++++++++++-------
 1 file changed, 46 insertions(+), 18 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_admin.c b/drivers/crypto/qat/qat_common/adf_admin.c
index a51ba0039cff..aa610f80296d 100644
--- a/drivers/crypto/qat/qat_common/adf_admin.c
+++ b/drivers/crypto/qat/qat_common/adf_admin.c
@@ -16,6 +16,7 @@
 #define ADF_DH895XCC_MAILBOX_BASE_OFFSET 0x20970
 #define ADF_DH895XCC_MAILBOX_STRIDE 0x1000
 #define ADF_ADMINMSG_LEN 32
+#define ADF_CONST_TABLE_SIZE 1024
 
 static const u8 const_tab[1024] __aligned(1024) = {
 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
@@ -114,6 +115,7 @@ static int adf_put_admin_msg_sync(struct adf_accel_dev *accel_dev, u32 ae,
 	int offset = ae * ADF_ADMINMSG_LEN * 2;
 	void __iomem *mailbox = admin->mailbox_addr;
 	int mb_offset = ae * ADF_DH895XCC_MAILBOX_STRIDE;
+	struct icp_qat_fw_init_admin_req *request = in;
 	int times, received;
 
 	mutex_lock(&admin->lock);
@@ -138,33 +140,57 @@ static int adf_put_admin_msg_sync(struct adf_accel_dev *accel_dev, u32 ae,
 		       ADF_ADMINMSG_LEN, ADF_ADMINMSG_LEN);
 	else
 		dev_err(&GET_DEV(accel_dev),
-			"Failed to send admin msg to accelerator\n");
+			"Failed to send admin msg %d to accelerator %d\n",
+			request->cmd_id, ae);
 
 	mutex_unlock(&admin->lock);
 	return received ? 0 : -EFAULT;
 }
 
-static int adf_send_admin_cmd(struct adf_accel_dev *accel_dev, int cmd)
+static int adf_send_admin(struct adf_accel_dev *accel_dev,
+			  struct icp_qat_fw_init_admin_req *req,
+			  struct icp_qat_fw_init_admin_resp *resp,
+			  const unsigned long ae_mask)
 {
+	u32 ae;
+
+	for_each_set_bit(ae, &ae_mask, ICP_QAT_HW_AE_DELIMITER)
+		if (adf_put_admin_msg_sync(accel_dev, ae, req, resp) ||
+		    resp->status)
+			return -EFAULT;
+
+	return 0;
+}
+
+static int adf_init_me(struct adf_accel_dev *accel_dev)
+{
+	struct icp_qat_fw_init_admin_req req;
+	struct icp_qat_fw_init_admin_resp resp;
 	struct adf_hw_device_data *hw_device = accel_dev->hw_device;
+	u32 ae_mask = hw_device->ae_mask;
+
+	memset(&req, 0, sizeof(req));
+	memset(&resp, 0, sizeof(resp));
+	req.cmd_id = ICP_QAT_FW_INIT_ME;
+
+	return adf_send_admin(accel_dev, &req, &resp, ae_mask);
+}
+
+static int adf_set_fw_constants(struct adf_accel_dev *accel_dev)
+{
 	struct icp_qat_fw_init_admin_req req;
 	struct icp_qat_fw_init_admin_resp resp;
-	int i;
+	struct adf_hw_device_data *hw_device = accel_dev->hw_device;
+	u32 ae_mask = hw_device->ae_mask;
 
-	memset(&req, 0, sizeof(struct icp_qat_fw_init_admin_req));
-	req.cmd_id = cmd;
+	memset(&req, 0, sizeof(req));
+	memset(&resp, 0, sizeof(resp));
+	req.cmd_id = ICP_QAT_FW_CONSTANTS_CFG;
 
-	if (cmd == ICP_QAT_FW_CONSTANTS_CFG) {
-		req.init_cfg_sz = 1024;
-		req.init_cfg_ptr = accel_dev->admin->const_tbl_addr;
-	}
-	for (i = 0; i < hw_device->get_num_aes(hw_device); i++) {
-		memset(&resp, 0, sizeof(struct icp_qat_fw_init_admin_resp));
-		if (adf_put_admin_msg_sync(accel_dev, i, &req, &resp) ||
-		    resp.status)
-			return -EFAULT;
-	}
-	return 0;
+	req.init_cfg_sz = ADF_CONST_TABLE_SIZE;
+	req.init_cfg_ptr = accel_dev->admin->const_tbl_addr;
+
+	return adf_send_admin(accel_dev, &req, &resp, ae_mask);
 }
 
 /**
@@ -177,11 +203,13 @@ static int adf_send_admin_cmd(struct adf_accel_dev *accel_dev, int cmd)
  */
 int adf_send_admin_init(struct adf_accel_dev *accel_dev)
 {
-	int ret = adf_send_admin_cmd(accel_dev, ICP_QAT_FW_INIT_ME);
+	int ret;
 
+	ret = adf_init_me(accel_dev);
 	if (ret)
 		return ret;
-	return adf_send_admin_cmd(accel_dev, ICP_QAT_FW_CONSTANTS_CFG);
+
+	return adf_set_fw_constants(accel_dev);
 }
 EXPORT_SYMBOL_GPL(adf_send_admin_init);
 
-- 
2.26.2

