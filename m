Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD48BC433EF
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Sep 2021 11:45:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C1A0461139
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Sep 2021 11:45:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240404AbhI1Lqr (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 28 Sep 2021 07:46:47 -0400
Received: from mga07.intel.com ([134.134.136.100]:37931 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240400AbhI1Lqq (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Sep 2021 07:46:46 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10120"; a="288339077"
X-IronPort-AV: E=Sophos;i="5.85,329,1624345200"; 
   d="scan'208";a="288339077"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2021 04:45:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,329,1624345200"; 
   d="scan'208";a="562224863"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.51])
  by fmsmga002.fm.intel.com with ESMTP; 28 Sep 2021 04:45:05 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Marco Chiappero <marco.chiappero@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH 10/12] crypto: qat - add VF and PF wrappers to common send function
Date:   Tue, 28 Sep 2021 12:44:38 +0100
Message-Id: <20210928114440.355368-11-giovanni.cabiddu@intel.com>
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

The send function, adf_iov_putmsg(), is shared by both PF and VF.
This commit provides two direction specific APIs, adf_send_pf2vf_msg()
and adf_send_vf2pf_msg() which decouple the implementation, which can
change and evolve over time, from the user.

With this change, the adf_iov_putmsg() is now isolated inside the file
adf_pf2vf_msg.c and has been marked as static.

Signed-off-by: Marco Chiappero <marco.chiappero@intel.com>
Co-developed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 .../crypto/qat/qat_common/adf_common_drv.h    |  3 +-
 drivers/crypto/qat/qat_common/adf_pf2vf_msg.c | 37 +++++++++++++++++--
 drivers/crypto/qat/qat_common/adf_vf2pf_msg.c |  4 +-
 3 files changed, 36 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_common_drv.h b/drivers/crypto/qat/qat_common/adf_common_drv.h
index 4261749fae8d..dd82272019ec 100644
--- a/drivers/crypto/qat/qat_common/adf_common_drv.h
+++ b/drivers/crypto/qat/qat_common/adf_common_drv.h
@@ -62,7 +62,6 @@ int adf_dev_start(struct adf_accel_dev *accel_dev);
 void adf_dev_stop(struct adf_accel_dev *accel_dev);
 void adf_dev_shutdown(struct adf_accel_dev *accel_dev);
 
-int adf_iov_putmsg(struct adf_accel_dev *accel_dev, u32 msg, u8 vf_nr);
 void adf_pf2vf_notify_restarting(struct adf_accel_dev *accel_dev);
 int adf_enable_vf2pf_comms(struct adf_accel_dev *accel_dev);
 void adf_vf2pf_req_hndl(struct adf_accel_vf_info *vf_info);
@@ -200,7 +199,7 @@ void adf_enable_vf2pf_interrupts(struct adf_accel_dev *accel_dev,
 void adf_enable_pf2vf_interrupts(struct adf_accel_dev *accel_dev);
 void adf_disable_pf2vf_interrupts(struct adf_accel_dev *accel_dev);
 void adf_schedule_vf2pf_handler(struct adf_accel_vf_info *vf_info);
-
+int adf_send_vf2pf_msg(struct adf_accel_dev *accel_dev, u32 msg);
 int adf_vf2pf_notify_init(struct adf_accel_dev *accel_dev);
 void adf_vf2pf_notify_shutdown(struct adf_accel_dev *accel_dev);
 int adf_init_pf_wq(void);
diff --git a/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c b/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
index 5459f295fcd9..23bcbb2e22e2 100644
--- a/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
+++ b/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
@@ -138,7 +138,7 @@ static int __adf_iov_putmsg(struct adf_accel_dev *accel_dev, u32 msg, u8 vf_nr)
  *
  * Return: 0 on success, error code otherwise.
  */
-int adf_iov_putmsg(struct adf_accel_dev *accel_dev, u32 msg, u8 vf_nr)
+static int adf_iov_putmsg(struct adf_accel_dev *accel_dev, u32 msg, u8 vf_nr)
 {
 	u32 count = 0;
 	int ret;
@@ -152,6 +152,35 @@ int adf_iov_putmsg(struct adf_accel_dev *accel_dev, u32 msg, u8 vf_nr)
 	return ret;
 }
 
+/**
+ * adf_send_pf2vf_msg() - send PF to VF message
+ * @accel_dev:	Pointer to acceleration device
+ * @vf_nr:	VF number to which the message will be sent
+ * @msg:	Message to send
+ *
+ * This function allows the PF to send a message to a specific VF.
+ *
+ * Return: 0 on success, error code otherwise.
+ */
+static int adf_send_pf2vf_msg(struct adf_accel_dev *accel_dev, u8 vf_nr, u32 msg)
+{
+	return adf_iov_putmsg(accel_dev, msg, vf_nr);
+}
+
+/**
+ * adf_send_vf2pf_msg() - send VF to PF message
+ * @accel_dev:	Pointer to acceleration device
+ * @msg:	Message to send
+ *
+ * This function allows the VF to send a message to the PF.
+ *
+ * Return: 0 on success, error code otherwise.
+ */
+int adf_send_vf2pf_msg(struct adf_accel_dev *accel_dev, u32 msg)
+{
+	return adf_iov_putmsg(accel_dev, msg, 0);
+}
+
 void adf_vf2pf_req_hndl(struct adf_accel_vf_info *vf_info)
 {
 	struct adf_accel_dev *accel_dev = vf_info->accel_dev;
@@ -248,7 +277,7 @@ void adf_vf2pf_req_hndl(struct adf_accel_vf_info *vf_info)
 		goto err;
 	}
 
-	if (resp && adf_iov_putmsg(accel_dev, resp, vf_nr))
+	if (resp && adf_send_pf2vf_msg(accel_dev, vf_nr, resp))
 		dev_err(&GET_DEV(accel_dev), "Failed to send response to VF\n");
 
 out:
@@ -269,7 +298,7 @@ void adf_pf2vf_notify_restarting(struct adf_accel_dev *accel_dev)
 	int i, num_vfs = pci_num_vf(accel_to_pci_dev(accel_dev));
 
 	for (i = 0, vf = accel_dev->pf.vf_info; i < num_vfs; i++, vf++) {
-		if (vf->init && adf_iov_putmsg(accel_dev, msg, i))
+		if (vf->init && adf_send_pf2vf_msg(accel_dev, i, msg))
 			dev_err(&GET_DEV(accel_dev),
 				"Failed to send restarting msg to VF%d\n", i);
 	}
@@ -290,7 +319,7 @@ static int adf_vf2pf_request_version(struct adf_accel_dev *accel_dev)
 	reinit_completion(&accel_dev->vf.iov_msg_completion);
 
 	/* Send request from VF to PF */
-	ret = adf_iov_putmsg(accel_dev, msg, 0);
+	ret = adf_send_vf2pf_msg(accel_dev, msg);
 	if (ret) {
 		dev_err(&GET_DEV(accel_dev),
 			"Failed to send Compatibility Version Request.\n");
diff --git a/drivers/crypto/qat/qat_common/adf_vf2pf_msg.c b/drivers/crypto/qat/qat_common/adf_vf2pf_msg.c
index 3e25fac051b2..8d11bb24cea0 100644
--- a/drivers/crypto/qat/qat_common/adf_vf2pf_msg.c
+++ b/drivers/crypto/qat/qat_common/adf_vf2pf_msg.c
@@ -17,7 +17,7 @@ int adf_vf2pf_notify_init(struct adf_accel_dev *accel_dev)
 	u32 msg = (ADF_VF2PF_MSGORIGIN_SYSTEM |
 		(ADF_VF2PF_MSGTYPE_INIT << ADF_VF2PF_MSGTYPE_SHIFT));
 
-	if (adf_iov_putmsg(accel_dev, msg, 0)) {
+	if (adf_send_vf2pf_msg(accel_dev, msg)) {
 		dev_err(&GET_DEV(accel_dev),
 			"Failed to send Init event to PF\n");
 		return -EFAULT;
@@ -41,7 +41,7 @@ void adf_vf2pf_notify_shutdown(struct adf_accel_dev *accel_dev)
 	    (ADF_VF2PF_MSGTYPE_SHUTDOWN << ADF_VF2PF_MSGTYPE_SHIFT));
 
 	if (test_bit(ADF_STATUS_PF_RUNNING, &accel_dev->status))
-		if (adf_iov_putmsg(accel_dev, msg, 0))
+		if (adf_send_vf2pf_msg(accel_dev, msg))
 			dev_err(&GET_DEV(accel_dev),
 				"Failed to send Shutdown event to PF\n");
 }
-- 
2.31.1

