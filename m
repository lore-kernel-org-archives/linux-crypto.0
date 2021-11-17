Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2ECA2C433FE
	for <linux-crypto@archiver.kernel.org>; Wed, 17 Nov 2021 14:31:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 16B2C61B54
	for <linux-crypto@archiver.kernel.org>; Wed, 17 Nov 2021 14:31:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238535AbhKQOeU (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 17 Nov 2021 09:34:20 -0500
Received: from mga01.intel.com ([192.55.52.88]:57918 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234772AbhKQOeU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 17 Nov 2021 09:34:20 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10170"; a="257722609"
X-IronPort-AV: E=Sophos;i="5.87,241,1631602800"; 
   d="scan'208";a="257722609"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2021 06:31:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,241,1631602800"; 
   d="scan'208";a="735829681"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.76])
  by fmsmga006.fm.intel.com with ESMTP; 17 Nov 2021 06:31:20 -0800
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        marco.chiappero@intel.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH v3 07/25] crypto: qat - change PFVF ACK behaviour
Date:   Wed, 17 Nov 2021 14:30:40 +0000
Message-Id: <20211117143058.211550-8-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211117143058.211550-1-giovanni.cabiddu@intel.com>
References: <20211117143058.211550-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Change the PFVF receipt flow on the VF side to read, ack and handle the
message instead of read, handle and ack.
This is done for (1) consistency with the PF side, see the function
adf_recv_and_handle_vf2pf_msg() in adf_pf2vf_msg.c, and (2) performance
reasons, to avoid keeping the CSR busy while parsing the message.

In addition, do not ACK PFVF legacy messages, as this driver is not
capable of handling PFVF legacy messages.
If a PFVF message with MSGORIGIN not set is received, do nothing.

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Marco Chiappero <marco.chiappero@intel.com>
---
 drivers/crypto/qat/qat_common/adf_pf2vf_msg.c | 8 ++++----
 drivers/crypto/qat/qat_common/adf_vf2pf_msg.c | 7 ++++---
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c b/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
index 796301e9fe5b..4922ee2a2a08 100644
--- a/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
+++ b/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
@@ -195,14 +195,14 @@ bool adf_recv_and_handle_vf2pf_msg(struct adf_accel_dev *accel_dev, u32 vf_nr)
 		return true;
 	}
 
-	/* To ACK, clear the VF2PFINT bit */
-	msg &= ~ADF_VF2PF_INT;
-	ADF_CSR_WR(pmisc_addr, hw_data->get_pf2vf_offset(vf_nr), msg);
-
 	if (!(msg & ADF_VF2PF_MSGORIGIN_SYSTEM))
 		/* Ignore legacy non-system (non-kernel) VF2PF messages */
 		goto err;
 
+	/* To ACK, clear the VF2PFINT bit */
+	msg &= ~ADF_VF2PF_INT;
+	ADF_CSR_WR(pmisc_addr, hw_data->get_pf2vf_offset(vf_nr), msg);
+
 	switch ((msg & ADF_VF2PF_MSGTYPE_MASK) >> ADF_VF2PF_MSGTYPE_SHIFT) {
 	case ADF_VF2PF_MSGTYPE_COMPAT_VER_REQ:
 		{
diff --git a/drivers/crypto/qat/qat_common/adf_vf2pf_msg.c b/drivers/crypto/qat/qat_common/adf_vf2pf_msg.c
index 064477fcb5fb..a6eaf93d5462 100644
--- a/drivers/crypto/qat/qat_common/adf_vf2pf_msg.c
+++ b/drivers/crypto/qat/qat_common/adf_vf2pf_msg.c
@@ -69,6 +69,10 @@ bool adf_recv_and_handle_pf2vf_msg(struct adf_accel_dev *accel_dev)
 		/* Ignore legacy non-system (non-kernel) PF2VF messages */
 		goto err;
 
+	/* To ack, clear the PF2VFINT bit */
+	msg &= ~ADF_PF2VF_INT;
+	ADF_CSR_WR(pmisc_bar_addr, offset, msg);
+
 	switch ((msg & ADF_PF2VF_MSGTYPE_MASK) >> ADF_PF2VF_MSGTYPE_SHIFT) {
 	case ADF_PF2VF_MSGTYPE_RESTARTING:
 		dev_dbg(&GET_DEV(accel_dev),
@@ -93,9 +97,6 @@ bool adf_recv_and_handle_pf2vf_msg(struct adf_accel_dev *accel_dev)
 		goto err;
 	}
 
-	/* To ack, clear the PF2VFINT bit */
-	msg &= ~ADF_PF2VF_INT;
-	ADF_CSR_WR(pmisc_bar_addr, offset, msg);
 	return ret;
 
 err:
-- 
2.33.1

