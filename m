Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E66CC433F5
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Nov 2021 20:52:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7B85660FD8
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Nov 2021 20:52:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233133AbhKJUzZ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 10 Nov 2021 15:55:25 -0500
Received: from mga09.intel.com ([134.134.136.24]:55765 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233059AbhKJUzX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 10 Nov 2021 15:55:23 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10164"; a="232611032"
X-IronPort-AV: E=Sophos;i="5.87,224,1631602800"; 
   d="scan'208";a="232611032"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2021 12:52:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,224,1631602800"; 
   d="scan'208";a="642663065"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.51])
  by fmsmga001.fm.intel.com with ESMTP; 10 Nov 2021 12:52:33 -0800
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        marco.chiappero@intel.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH 08/24] crypto: qat - split PFVF message decoding from handling
Date:   Wed, 10 Nov 2021 20:52:01 +0000
Message-Id: <20211110205217.99903-9-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211110205217.99903-1-giovanni.cabiddu@intel.com>
References: <20211110205217.99903-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Marco Chiappero <marco.chiappero@intel.com>

Refactor the receive and handle logic to separate the parsing and
handling of the PFVF message from the initial retrieval and ACK.

This is to allow the intoduction of the recv function in a subsequent
patch.

Signed-off-by: Marco Chiappero <marco.chiappero@intel.com>
Co-developed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/qat/qat_common/adf_pf2vf_msg.c | 68 ++++++++++++-------
 drivers/crypto/qat/qat_common/adf_vf2pf_msg.c | 62 ++++++++---------
 2 files changed, 71 insertions(+), 59 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c b/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
index 296f54805e33..201744825e23 100644
--- a/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
+++ b/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
@@ -178,30 +178,12 @@ static int adf_send_vf2pf_req(struct adf_accel_dev *accel_dev, u32 msg)
 	return 0;
 }
 
-bool adf_recv_and_handle_vf2pf_msg(struct adf_accel_dev *accel_dev, u32 vf_nr)
+static int adf_handle_vf2pf_msg(struct adf_accel_dev *accel_dev, u32 vf_nr,
+				u32 msg, u32 *response)
 {
 	struct adf_accel_vf_info *vf_info = &accel_dev->pf.vf_info[vf_nr];
 	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
-	int bar_id = hw_data->get_misc_bar_id(hw_data);
-	struct adf_bar *pmisc = &GET_BARS(accel_dev)[bar_id];
-	void __iomem *pmisc_addr = pmisc->virt_addr;
-	u32 msg, resp = 0;
-
-	/* Read message from the VF */
-	msg = ADF_CSR_RD(pmisc_addr, hw_data->get_pf2vf_offset(vf_nr));
-	if (!(msg & ADF_VF2PF_INT)) {
-		dev_info(&GET_DEV(accel_dev),
-			 "Spurious VF2PF interrupt, msg %X. Ignored\n", msg);
-		return true;
-	}
-
-	if (!(msg & ADF_VF2PF_MSGORIGIN_SYSTEM))
-		/* Ignore legacy non-system (non-kernel) VF2PF messages */
-		return true;
-
-	/* To ACK, clear the VF2PFINT bit */
-	msg &= ~ADF_VF2PF_INT;
-	ADF_CSR_WR(pmisc_addr, hw_data->get_pf2vf_offset(vf_nr), msg);
+	u32 resp = 0;
 
 	switch ((msg & ADF_VF2PF_MSGTYPE_MASK) >> ADF_VF2PF_MSGTYPE_SHIFT) {
 	case ADF_VF2PF_MSGTYPE_COMPAT_VER_REQ:
@@ -271,17 +253,51 @@ bool adf_recv_and_handle_vf2pf_msg(struct adf_accel_dev *accel_dev, u32 vf_nr)
 		}
 		break;
 	default:
-		goto err;
+		dev_dbg(&GET_DEV(accel_dev), "Unknown message from VF%d (0x%x)\n",
+			vf_nr + 1, msg);
+		return -ENOMSG;
+	}
+
+	*response = resp;
+
+	return 0;
+}
+
+bool adf_recv_and_handle_vf2pf_msg(struct adf_accel_dev *accel_dev, u32 vf_nr)
+{
+	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
+	int bar_id = hw_data->get_misc_bar_id(hw_data);
+	struct adf_bar *pmisc = &GET_BARS(accel_dev)[bar_id];
+	void __iomem *pmisc_addr = pmisc->virt_addr;
+	u32 msg, resp = 0;
+
+	/* Read message from the VF */
+	msg = ADF_CSR_RD(pmisc_addr, hw_data->get_pf2vf_offset(vf_nr));
+	if (!(msg & ADF_VF2PF_INT)) {
+		dev_info(&GET_DEV(accel_dev),
+			 "Spurious VF2PF interrupt, msg %X. Ignored\n", msg);
+		return true;
+	}
+
+	/* Ignore legacy non-system (non-kernel) VF2PF messages */
+	if (!(msg & ADF_VF2PF_MSGORIGIN_SYSTEM)) {
+		dev_dbg(&GET_DEV(accel_dev),
+			"Ignored non-system message from VF%d (0x%x);\n",
+			vf_nr + 1, msg);
+		return true;
 	}
 
+	/* To ACK, clear the VF2PFINT bit */
+	msg &= ~ADF_VF2PF_INT;
+	ADF_CSR_WR(pmisc_addr, hw_data->get_pf2vf_offset(vf_nr), msg);
+
+	if (adf_handle_vf2pf_msg(accel_dev, vf_nr, msg, &resp))
+		return false;
+
 	if (resp && adf_send_pf2vf_msg(accel_dev, vf_nr, resp))
 		dev_err(&GET_DEV(accel_dev), "Failed to send response to VF\n");
 
 	return true;
-err:
-	dev_dbg(&GET_DEV(accel_dev), "Unknown message from VF%d (0x%x);\n",
-		vf_nr + 1, msg);
-	return false;
 }
 
 void adf_pf2vf_notify_restarting(struct adf_accel_dev *accel_dev)
diff --git a/drivers/crypto/qat/qat_common/adf_vf2pf_msg.c b/drivers/crypto/qat/qat_common/adf_vf2pf_msg.c
index e383232b0685..01a6e68f256b 100644
--- a/drivers/crypto/qat/qat_common/adf_vf2pf_msg.c
+++ b/drivers/crypto/qat/qat_common/adf_vf2pf_msg.c
@@ -47,6 +47,34 @@ void adf_vf2pf_notify_shutdown(struct adf_accel_dev *accel_dev)
 }
 EXPORT_SYMBOL_GPL(adf_vf2pf_notify_shutdown);
 
+static bool adf_handle_pf2vf_msg(struct adf_accel_dev *accel_dev, u32 msg)
+{
+	switch ((msg & ADF_PF2VF_MSGTYPE_MASK) >> ADF_PF2VF_MSGTYPE_SHIFT) {
+	case ADF_PF2VF_MSGTYPE_RESTARTING:
+		dev_dbg(&GET_DEV(accel_dev),
+			"Restarting msg received from PF 0x%x\n", msg);
+
+		adf_pf2vf_handle_pf_restarting(accel_dev);
+		return false;
+	case ADF_PF2VF_MSGTYPE_VERSION_RESP:
+		dev_dbg(&GET_DEV(accel_dev),
+			"Version resp received from PF 0x%x\n", msg);
+		accel_dev->vf.pf_version =
+			(msg & ADF_PF2VF_VERSION_RESP_VERS_MASK) >>
+			ADF_PF2VF_VERSION_RESP_VERS_SHIFT;
+		accel_dev->vf.compatible =
+			(msg & ADF_PF2VF_VERSION_RESP_RESULT_MASK) >>
+			ADF_PF2VF_VERSION_RESP_RESULT_SHIFT;
+		complete(&accel_dev->vf.iov_msg_completion);
+		return true;
+	default:
+		dev_err(&GET_DEV(accel_dev),
+			"Unknown PF2VF message(0x%x)\n", msg);
+	}
+
+	return false;
+}
+
 bool adf_recv_and_handle_pf2vf_msg(struct adf_accel_dev *accel_dev)
 {
 	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
@@ -54,7 +82,6 @@ bool adf_recv_and_handle_pf2vf_msg(struct adf_accel_dev *accel_dev)
 			&GET_BARS(accel_dev)[hw_data->get_misc_bar_id(hw_data)];
 	void __iomem *pmisc_bar_addr = pmisc->virt_addr;
 	u32 offset = hw_data->get_pf2vf_offset(0);
-	bool ret;
 	u32 msg;
 
 	/* Read the message from PF */
@@ -73,36 +100,5 @@ bool adf_recv_and_handle_pf2vf_msg(struct adf_accel_dev *accel_dev)
 	msg &= ~ADF_PF2VF_INT;
 	ADF_CSR_WR(pmisc_bar_addr, offset, msg);
 
-	switch ((msg & ADF_PF2VF_MSGTYPE_MASK) >> ADF_PF2VF_MSGTYPE_SHIFT) {
-	case ADF_PF2VF_MSGTYPE_RESTARTING:
-		dev_dbg(&GET_DEV(accel_dev),
-			"Restarting msg received from PF 0x%x\n", msg);
-
-		adf_pf2vf_handle_pf_restarting(accel_dev);
-		ret = false;
-		break;
-	case ADF_PF2VF_MSGTYPE_VERSION_RESP:
-		dev_dbg(&GET_DEV(accel_dev),
-			"Version resp received from PF 0x%x\n", msg);
-		accel_dev->vf.pf_version =
-			(msg & ADF_PF2VF_VERSION_RESP_VERS_MASK) >>
-			ADF_PF2VF_VERSION_RESP_VERS_SHIFT;
-		accel_dev->vf.compatible =
-			(msg & ADF_PF2VF_VERSION_RESP_RESULT_MASK) >>
-			ADF_PF2VF_VERSION_RESP_RESULT_SHIFT;
-		complete(&accel_dev->vf.iov_msg_completion);
-		ret = true;
-		break;
-	default:
-		goto err;
-	}
-
-	return ret;
-
-err:
-	dev_err(&GET_DEV(accel_dev),
-		"Unknown message from PF (0x%x); leaving PF2VF ints disabled\n",
-		msg);
-
-	return false;
+	return adf_handle_pf2vf_msg(accel_dev, msg);
 }
-- 
2.33.1

