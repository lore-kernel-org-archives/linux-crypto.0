Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DA25C433F5
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Nov 2021 12:05:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 42B1961B53
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Nov 2021 12:05:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230353AbhKOMIg (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 15 Nov 2021 07:08:36 -0500
Received: from mga09.intel.com ([134.134.136.24]:13651 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231599AbhKOMIL (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 15 Nov 2021 07:08:11 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10168"; a="233265641"
X-IronPort-AV: E=Sophos;i="5.87,236,1631602800"; 
   d="scan'208";a="233265641"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2021 04:04:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,236,1631602800"; 
   d="scan'208";a="535486578"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.76])
  by orsmga001.jf.intel.com with ESMTP; 15 Nov 2021 04:04:27 -0800
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        marco.chiappero@intel.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH v2 24/24] crypto: qat - improve logging of PFVF messages
Date:   Mon, 15 Nov 2021 12:03:36 +0000
Message-Id: <20211115120336.22292-25-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115120336.22292-1-giovanni.cabiddu@intel.com>
References: <20211115120336.22292-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Marco Chiappero <marco.chiappero@intel.com>

Improve and simplify logging of PFVF messages.

Signed-off-by: Marco Chiappero <marco.chiappero@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/qat/qat_common/adf_gen2_pfvf.c |  4 +--
 .../crypto/qat/qat_common/adf_pfvf_pf_proto.c | 30 +++++++------------
 .../crypto/qat/qat_common/adf_pfvf_vf_proto.c |  7 +++--
 3 files changed, 17 insertions(+), 24 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_gen2_pfvf.c b/drivers/crypto/qat/qat_common/adf_gen2_pfvf.c
index 7f7ff9dcf4af..6825b7bdd856 100644
--- a/drivers/crypto/qat/qat_common/adf_gen2_pfvf.c
+++ b/drivers/crypto/qat/qat_common/adf_gen2_pfvf.c
@@ -180,14 +180,14 @@ static u32 adf_gen2_pfvf_recv(struct adf_accel_dev *accel_dev, u8 vf_nr)
 	msg = ADF_CSR_RD(pmisc_addr, pfvf_offset);
 	if (!(msg & int_bit)) {
 		dev_info(&GET_DEV(accel_dev),
-			 "Spurious PFVF interrupt, msg %X. Ignored\n", msg);
+			 "Spurious PFVF interrupt, msg 0x%.8x. Ignored\n", msg);
 		return 0;
 	}
 
 	/* Ignore legacy non-system (non-kernel) VF2PF messages */
 	if (!(msg & msg_origin)) {
 		dev_dbg(&GET_DEV(accel_dev),
-			"Ignored non-system message (0x%x);\n", msg);
+			"Ignored non-system message (0x%.8x);\n", msg);
 		return 0;
 	}
 
diff --git a/drivers/crypto/qat/qat_common/adf_pfvf_pf_proto.c b/drivers/crypto/qat/qat_common/adf_pfvf_pf_proto.c
index 82b6cc7162ba..631038bad21e 100644
--- a/drivers/crypto/qat/qat_common/adf_pfvf_pf_proto.c
+++ b/drivers/crypto/qat/qat_common/adf_pfvf_pf_proto.c
@@ -49,20 +49,13 @@ static int adf_handle_vf2pf_msg(struct adf_accel_dev *accel_dev, u32 vf_nr,
 		u8 compat;
 
 		dev_dbg(&GET_DEV(accel_dev),
-			"Compatibility Version Request from VF%d vers=%u\n",
-			vf_nr, vf_compat_ver);
+			"VersionRequest received from VF%d (vers %d) to PF (vers %d)\n",
+			vf_nr, vf_compat_ver, ADF_PFVF_COMPAT_THIS_VERSION);
 
-		if (vf_compat_ver <= ADF_PFVF_COMPAT_THIS_VERSION) {
+		if (vf_compat_ver <= ADF_PFVF_COMPAT_THIS_VERSION)
 			compat = ADF_PF2VF_VF_COMPATIBLE;
-			dev_dbg(&GET_DEV(accel_dev),
-				"VF (vers %d) compatible with PF (vers %d)\n",
-				vf_compat_ver, ADF_PFVF_COMPAT_THIS_VERSION);
-		} else {
+		else
 			compat = ADF_PF2VF_VF_COMPAT_UNKNOWN;
-			dev_err(&GET_DEV(accel_dev),
-				"VF (vers %d) compat with PF (vers %d) unkn.\n",
-				vf_compat_ver, ADF_PFVF_COMPAT_THIS_VERSION);
-		}
 
 		resp =  ADF_PF2VF_MSGORIGIN_SYSTEM;
 		resp |= ADF_PF2VF_MSGTYPE_VERSION_RESP << ADF_PF2VF_MSGTYPE_SHIFT;
@@ -75,8 +68,8 @@ static int adf_handle_vf2pf_msg(struct adf_accel_dev *accel_dev, u32 vf_nr,
 		u8 compat;
 
 		dev_dbg(&GET_DEV(accel_dev),
-			"Legacy VersionRequest received from VF%d 0x%x\n",
-			vf_nr, msg);
+			"Legacy VersionRequest received from VF%d to PF (vers 1.1)\n",
+			vf_nr);
 
 		/* PF always newer than legacy VF */
 		compat = ADF_PF2VF_VF_COMPATIBLE;
@@ -92,21 +85,19 @@ static int adf_handle_vf2pf_msg(struct adf_accel_dev *accel_dev, u32 vf_nr,
 	case ADF_VF2PF_MSGTYPE_INIT:
 		{
 		dev_dbg(&GET_DEV(accel_dev),
-			"Init message received from VF%d 0x%x\n",
-			vf_nr, msg);
+			"Init message received from VF%d\n", vf_nr);
 		vf_info->init = true;
 		}
 		break;
 	case ADF_VF2PF_MSGTYPE_SHUTDOWN:
 		{
 		dev_dbg(&GET_DEV(accel_dev),
-			"Shutdown message received from VF%d 0x%x\n",
-			vf_nr, msg);
+			"Shutdown message received from VF%d\n", vf_nr);
 		vf_info->init = false;
 		}
 		break;
 	default:
-		dev_dbg(&GET_DEV(accel_dev), "Unknown message from VF%d (0x%x)\n",
+		dev_dbg(&GET_DEV(accel_dev), "Unknown message from VF%d (0x%.8x)\n",
 			vf_nr, msg);
 		return -ENOMSG;
 	}
@@ -129,7 +120,8 @@ bool adf_recv_and_handle_vf2pf_msg(struct adf_accel_dev *accel_dev, u32 vf_nr)
 		return false;
 
 	if (resp && adf_send_pf2vf_msg(accel_dev, vf_nr, resp))
-		dev_err(&GET_DEV(accel_dev), "Failed to send response to VF\n");
+		dev_err(&GET_DEV(accel_dev),
+			"Failed to send response to VF%d\n", vf_nr);
 
 	return true;
 }
diff --git a/drivers/crypto/qat/qat_common/adf_pfvf_vf_proto.c b/drivers/crypto/qat/qat_common/adf_pfvf_vf_proto.c
index ea1a00e746ff..9c7489ed122c 100644
--- a/drivers/crypto/qat/qat_common/adf_pfvf_vf_proto.c
+++ b/drivers/crypto/qat/qat_common/adf_pfvf_vf_proto.c
@@ -90,18 +90,19 @@ static bool adf_handle_pf2vf_msg(struct adf_accel_dev *accel_dev, u32 msg)
 {
 	switch ((msg & ADF_PF2VF_MSGTYPE_MASK) >> ADF_PF2VF_MSGTYPE_SHIFT) {
 	case ADF_PF2VF_MSGTYPE_RESTARTING:
-		dev_dbg(&GET_DEV(accel_dev),
-			"Restarting msg received from PF 0x%x\n", msg);
+		dev_dbg(&GET_DEV(accel_dev), "Restarting message received from PF\n");
 
 		adf_pf2vf_handle_pf_restarting(accel_dev);
 		return false;
 	case ADF_PF2VF_MSGTYPE_VERSION_RESP:
+		dev_dbg(&GET_DEV(accel_dev),
+			"Response message received from PF (0x%.8x)\n", msg);
 		accel_dev->vf.response = msg;
 		complete(&accel_dev->vf.msg_received);
 		return true;
 	default:
 		dev_err(&GET_DEV(accel_dev),
-			"Unknown PF2VF message(0x%x)\n", msg);
+			"Unknown PF2VF message (0x%.8x) from PF\n", msg);
 	}
 
 	return false;
-- 
2.33.1

