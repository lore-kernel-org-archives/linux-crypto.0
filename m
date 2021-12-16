Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19AECC433FE
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Dec 2021 09:12:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232937AbhLPJML (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 16 Dec 2021 04:12:11 -0500
Received: from mga12.intel.com ([192.55.52.136]:9714 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232971AbhLPJMH (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Dec 2021 04:12:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639645927; x=1671181927;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5URAupbObig7I1y/mRj6LyTGu73AjYDF42Q2h5Kh+CM=;
  b=it/+p/VPKmrYZPLrcFuJc9X6tMJxFNiq80Cxp4gqF/jzcGotVLHjUwJV
   2M7wLSMkmuGvzKb5qnOB6TStHb6tS8Woeh8fRH5xcb6TkXRd6bAsRePNc
   tpomJj1OpiUEh6NjlkysiR/m0W5yGw2KN9spcO4BJkvipo9VD2ghXW8DQ
   b3do4OquM7WDGkVJYEcX9nlbNkJMwG6V7+0i8jWejRhtoSidpCQ34CBfq
   ST3/gnzswTCOb+vbPldNb0jU8EFO2/fV0tpod+3vJa5wDSp0LnAVWfYQ8
   yrs07xMy3quLR2KxVMQyBGceRULlBV9D/33UrgS5g7glckkYPi7pTbZ8s
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10199"; a="219458489"
X-IronPort-AV: E=Sophos;i="5.88,211,1635231600"; 
   d="scan'208";a="219458489"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2021 01:11:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,211,1635231600"; 
   d="scan'208";a="465968673"
Received: from silpixa00393544.ir.intel.com ([10.237.213.118])
  by orsmga006.jf.intel.com with ESMTP; 16 Dec 2021 01:11:52 -0800
From:   Marco Chiappero <marco.chiappero@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        giovanni.cabiddu@intel.com, marco.chiappero@intel.com,
        Fiona Trahe <fiona.trahe@intel.com>
Subject: [PATCH 22/24] crypto: qat - add PFVF support to enable the reset of ring pairs
Date:   Thu, 16 Dec 2021 09:13:32 +0000
Message-Id: <20211216091334.402420-23-marco.chiappero@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211216091334.402420-1-marco.chiappero@intel.com>
References: <20211216091334.402420-1-marco.chiappero@intel.com>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Extend support for resetting ring pairs on the device to VFs. Such
reset happens by sending a request to the PF over the PFVF protocol.

This patch defines two new PFVF messages and adds the PFVF logic for
handling the request on PF, triggering the reset, and VFs, accepting the
'success'/'error' response.

This feature is GEN4 specific.

This patch is based on earlier work done by Zelin Deng.

Signed-off-by: Marco Chiappero <marco.chiappero@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Fiona Trahe <fiona.trahe@intel.com>
---
 drivers/crypto/qat/qat_common/adf_pfvf_msg.h  | 14 +++++
 .../crypto/qat/qat_common/adf_pfvf_pf_proto.c | 52 +++++++++++++++++++
 .../crypto/qat/qat_common/adf_pfvf_vf_proto.c |  1 +
 3 files changed, 67 insertions(+)

diff --git a/drivers/crypto/qat/qat_common/adf_pfvf_msg.h b/drivers/crypto/qat/qat_common/adf_pfvf_msg.h
index f00e9e2c585b..86b0e7baa4d3 100644
--- a/drivers/crypto/qat/qat_common/adf_pfvf_msg.h
+++ b/drivers/crypto/qat/qat_common/adf_pfvf_msg.h
@@ -99,6 +99,8 @@ enum pf2vf_msgtype {
 	ADF_PF2VF_MSGTYPE_RESTARTING		= 0x01,
 	ADF_PF2VF_MSGTYPE_VERSION_RESP		= 0x02,
 	ADF_PF2VF_MSGTYPE_BLKMSG_RESP		= 0x03,
+/* Values from 0x10 are Gen4 specific, message type is only 4 bits in Gen2 devices. */
+	ADF_PF2VF_MSGTYPE_RP_RESET_RESP		= 0x10,
 };
 
 /* VF->PF messages */
@@ -110,6 +112,8 @@ enum vf2pf_msgtype {
 	ADF_VF2PF_MSGTYPE_LARGE_BLOCK_REQ	= 0x07,
 	ADF_VF2PF_MSGTYPE_MEDIUM_BLOCK_REQ	= 0x08,
 	ADF_VF2PF_MSGTYPE_SMALL_BLOCK_REQ	= 0x09,
+/* Values from 0x10 are Gen4 specific, message type is only 4 bits in Gen2 devices. */
+	ADF_VF2PF_MSGTYPE_RP_RESET		= 0x10,
 };
 
 /* VF/PF compatibility version. */
@@ -134,6 +138,16 @@ enum pf2vf_compat_response {
 	ADF_PF2VF_VF_COMPAT_UNKNOWN		= 0x03,
 };
 
+enum ring_reset_result {
+	RPRESET_SUCCESS				= 0x01,
+	RPRESET_NOT_SUPPORTED			= 0x02,
+	RPRESET_INVAL_BANK			= 0x03,
+	RPRESET_TIMEOUT				= 0x04,
+};
+
+#define ADF_VF2PF_RNG_RESET_RP_MASK		GENMASK(1, 0)
+#define ADF_VF2PF_RNG_RESET_RSVD_MASK		GENMASK(25, 2)
+
 /* PF->VF Block Responses */
 #define ADF_PF2VF_BLKMSG_RESP_TYPE_MASK		GENMASK(1, 0)
 #define ADF_PF2VF_BLKMSG_RESP_DATA_MASK		GENMASK(9, 2)
diff --git a/drivers/crypto/qat/qat_common/adf_pfvf_pf_proto.c b/drivers/crypto/qat/qat_common/adf_pfvf_pf_proto.c
index 84230aac67e6..588352de1ef0 100644
--- a/drivers/crypto/qat/qat_common/adf_pfvf_pf_proto.c
+++ b/drivers/crypto/qat/qat_common/adf_pfvf_pf_proto.c
@@ -178,6 +178,55 @@ static struct pfvf_message handle_blkmsg_req(struct adf_accel_vf_info *vf_info,
 	return resp;
 }
 
+static struct pfvf_message handle_rp_reset_req(struct adf_accel_dev *accel_dev, u8 vf_nr,
+					       struct pfvf_message req)
+{
+	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
+	struct pfvf_message resp = {
+		.type = ADF_PF2VF_MSGTYPE_RP_RESET_RESP,
+		.data = RPRESET_SUCCESS
+	};
+	u32 bank_number;
+	u32 rsvd_field;
+
+	bank_number = FIELD_GET(ADF_VF2PF_RNG_RESET_RP_MASK, req.data);
+	rsvd_field = FIELD_GET(ADF_VF2PF_RNG_RESET_RSVD_MASK, req.data);
+
+	dev_dbg(&GET_DEV(accel_dev),
+		"Ring Pair Reset Message received from VF%d for bank 0x%x\n",
+		vf_nr, bank_number);
+
+	if (!hw_data->ring_pair_reset || rsvd_field) {
+		dev_dbg(&GET_DEV(accel_dev),
+			"Ring Pair Reset for VF%d is not supported\n", vf_nr);
+		resp.data = RPRESET_NOT_SUPPORTED;
+		goto out;
+	}
+
+	if (bank_number >= hw_data->num_banks_per_vf) {
+		dev_err(&GET_DEV(accel_dev),
+			"Invalid bank number (0x%x) from VF%d for Ring Reset\n",
+			bank_number, vf_nr);
+		resp.data = RPRESET_INVAL_BANK;
+		goto out;
+	}
+
+	/* Convert the VF provided value to PF bank number */
+	bank_number = vf_nr * hw_data->num_banks_per_vf + bank_number;
+	if (hw_data->ring_pair_reset(accel_dev, bank_number)) {
+		dev_dbg(&GET_DEV(accel_dev),
+			"Ring pair reset for VF%d failure\n", vf_nr);
+		resp.data = RPRESET_TIMEOUT;
+		goto out;
+	}
+
+	dev_dbg(&GET_DEV(accel_dev),
+		"Ring pair reset for VF%d successfully\n", vf_nr);
+
+out:
+	return resp;
+}
+
 static int adf_handle_vf2pf_msg(struct adf_accel_dev *accel_dev, u8 vf_nr,
 				struct pfvf_message msg, struct pfvf_message *resp)
 {
@@ -245,6 +294,9 @@ static int adf_handle_vf2pf_msg(struct adf_accel_dev *accel_dev, u8 vf_nr,
 	case ADF_VF2PF_MSGTYPE_SMALL_BLOCK_REQ:
 		*resp = handle_blkmsg_req(vf_info, msg);
 		break;
+	case ADF_VF2PF_MSGTYPE_RP_RESET:
+		*resp = handle_rp_reset_req(accel_dev, vf_nr, msg);
+		break;
 	default:
 		dev_dbg(&GET_DEV(accel_dev),
 			"Unknown message from VF%d (type 0x%.4x, data: 0x%.4x)\n",
diff --git a/drivers/crypto/qat/qat_common/adf_pfvf_vf_proto.c b/drivers/crypto/qat/qat_common/adf_pfvf_vf_proto.c
index 0e4b8397cbe3..1015155b6374 100644
--- a/drivers/crypto/qat/qat_common/adf_pfvf_vf_proto.c
+++ b/drivers/crypto/qat/qat_common/adf_pfvf_vf_proto.c
@@ -310,6 +310,7 @@ static bool adf_handle_pf2vf_msg(struct adf_accel_dev *accel_dev,
 		return false;
 	case ADF_PF2VF_MSGTYPE_VERSION_RESP:
 	case ADF_PF2VF_MSGTYPE_BLKMSG_RESP:
+	case ADF_PF2VF_MSGTYPE_RP_RESET_RESP:
 		dev_dbg(&GET_DEV(accel_dev),
 			"Response Message received from PF (type 0x%.4x, data 0x%.4x)\n",
 			msg.type, msg.data);
-- 
2.31.1

