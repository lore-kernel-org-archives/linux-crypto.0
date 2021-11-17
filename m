Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39E78C433FE
	for <linux-crypto@archiver.kernel.org>; Wed, 17 Nov 2021 14:32:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1A8CC61BE3
	for <linux-crypto@archiver.kernel.org>; Wed, 17 Nov 2021 14:32:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238570AbhKQOfD (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 17 Nov 2021 09:35:03 -0500
Received: from mga01.intel.com ([192.55.52.88]:57956 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238622AbhKQOey (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 17 Nov 2021 09:34:54 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10170"; a="257722716"
X-IronPort-AV: E=Sophos;i="5.87,241,1631602800"; 
   d="scan'208";a="257722716"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2021 06:31:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,241,1631602800"; 
   d="scan'208";a="735830061"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.76])
  by fmsmga006.fm.intel.com with ESMTP; 17 Nov 2021 06:31:48 -0800
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        marco.chiappero@intel.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH v3 25/25] crypto: qat - improve logging of PFVF messages
Date:   Wed, 17 Nov 2021 14:30:58 +0000
Message-Id: <20211117143058.211550-26-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211117143058.211550-1-giovanni.cabiddu@intel.com>
References: <20211117143058.211550-1-giovanni.cabiddu@intel.com>
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
index f3a0a9d651e0..099e39808d13 100644
--- a/drivers/crypto/qat/qat_common/adf_gen2_pfvf.c
+++ b/drivers/crypto/qat/qat_common/adf_gen2_pfvf.c
@@ -183,14 +183,14 @@ static u32 adf_gen2_pfvf_recv(struct adf_accel_dev *accel_dev, u8 vf_nr)
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
index b486b2b599c2..4f20dd35fcd4 100644
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
 		resp |= ADF_PF2VF_MSGTYPE_VERSION_RESP <<
@@ -77,8 +70,8 @@ static int adf_handle_vf2pf_msg(struct adf_accel_dev *accel_dev, u32 vf_nr,
 		u8 compat;
 
 		dev_dbg(&GET_DEV(accel_dev),
-			"Legacy VersionRequest received from VF%d 0x%x\n",
-			vf_nr, msg);
+			"Legacy VersionRequest received from VF%d to PF (vers 1.1)\n",
+			vf_nr);
 
 		/* PF always newer than legacy VF */
 		compat = ADF_PF2VF_VF_COMPATIBLE;
@@ -95,21 +88,19 @@ static int adf_handle_vf2pf_msg(struct adf_accel_dev *accel_dev, u32 vf_nr,
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
@@ -132,7 +123,8 @@ bool adf_recv_and_handle_vf2pf_msg(struct adf_accel_dev *accel_dev, u32 vf_nr)
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

