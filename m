Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D357C433EF
	for <linux-crypto@archiver.kernel.org>; Wed, 17 Nov 2021 14:31:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F2E0861B54
	for <linux-crypto@archiver.kernel.org>; Wed, 17 Nov 2021 14:31:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238589AbhKQOez (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 17 Nov 2021 09:34:55 -0500
Received: from mga01.intel.com ([192.55.52.88]:57960 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238628AbhKQOeo (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 17 Nov 2021 09:34:44 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10170"; a="257722701"
X-IronPort-AV: E=Sophos;i="5.87,241,1631602800"; 
   d="scan'208";a="257722701"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2021 06:31:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,241,1631602800"; 
   d="scan'208";a="735829845"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.76])
  by fmsmga006.fm.intel.com with ESMTP; 17 Nov 2021 06:31:44 -0800
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        marco.chiappero@intel.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH v3 22/25] crypto: qat - refactor pfvf version request messages
Date:   Wed, 17 Nov 2021 14:30:55 +0000
Message-Id: <20211117143058.211550-23-giovanni.cabiddu@intel.com>
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

Refactor version handling logic for ADF_VF2PF_MSGTYPE_COMPAT_VER_REQ
and ADF_VF2PF_MSGTYPE_VERSION_REQ on the PF.
Response messages are now filled only after fully parsing the request,
in a consisted way with the rest of the PFVF codebase.

This patch also fixes a harmless double setting for VERSION in the
response for ADF_VF2PF_MSGTYPE_VERSION_REQ.

Signed-off-by: Marco Chiappero <marco.chiappero@intel.com>
Co-developed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 .../crypto/qat/qat_common/adf_pfvf_pf_proto.c | 42 ++++++++++---------
 1 file changed, 23 insertions(+), 19 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_pfvf_pf_proto.c b/drivers/crypto/qat/qat_common/adf_pfvf_pf_proto.c
index ac6a54cf17f6..c0844fbd896c 100644
--- a/drivers/crypto/qat/qat_common/adf_pfvf_pf_proto.c
+++ b/drivers/crypto/qat/qat_common/adf_pfvf_pf_proto.c
@@ -47,12 +47,7 @@ static int adf_handle_vf2pf_msg(struct adf_accel_dev *accel_dev, u32 vf_nr,
 	case ADF_VF2PF_MSGTYPE_COMPAT_VER_REQ:
 		{
 		u8 vf_compat_ver = msg >> ADF_VF2PF_COMPAT_VER_REQ_SHIFT;
-
-		resp = (ADF_PF2VF_MSGORIGIN_SYSTEM |
-			 (ADF_PF2VF_MSGTYPE_VERSION_RESP <<
-			  ADF_PF2VF_MSGTYPE_SHIFT) |
-			 (ADF_PFVF_COMPAT_THIS_VERSION <<
-			  ADF_PF2VF_VERSION_RESP_VERS_SHIFT));
+		u8 compat;
 
 		dev_dbg(&GET_DEV(accel_dev),
 			"Compatibility Version Request from VF%d vers=%u\n",
@@ -62,37 +57,46 @@ static int adf_handle_vf2pf_msg(struct adf_accel_dev *accel_dev, u32 vf_nr,
 			dev_err(&GET_DEV(accel_dev),
 				"VF (vers %d) incompatible with PF (vers %d)\n",
 				vf_compat_ver, ADF_PFVF_COMPAT_THIS_VERSION);
-			resp |= ADF_PF2VF_VF_INCOMPATIBLE <<
-				ADF_PF2VF_VERSION_RESP_RESULT_SHIFT;
+			compat = ADF_PF2VF_VF_INCOMPATIBLE;
 		} else if (vf_compat_ver > ADF_PFVF_COMPAT_THIS_VERSION) {
 			dev_err(&GET_DEV(accel_dev),
 				"VF (vers %d) compat with PF (vers %d) unkn.\n",
 				vf_compat_ver, ADF_PFVF_COMPAT_THIS_VERSION);
-			resp |= ADF_PF2VF_VF_COMPAT_UNKNOWN <<
-				ADF_PF2VF_VERSION_RESP_RESULT_SHIFT;
+			compat = ADF_PF2VF_VF_COMPAT_UNKNOWN;
 		} else {
 			dev_dbg(&GET_DEV(accel_dev),
 				"VF (vers %d) compatible with PF (vers %d)\n",
 				vf_compat_ver, ADF_PFVF_COMPAT_THIS_VERSION);
-			resp |= ADF_PF2VF_VF_COMPATIBLE <<
-				ADF_PF2VF_VERSION_RESP_RESULT_SHIFT;
+			compat = ADF_PF2VF_VF_COMPATIBLE;
 		}
+
+		resp =  ADF_PF2VF_MSGORIGIN_SYSTEM;
+		resp |= ADF_PF2VF_MSGTYPE_VERSION_RESP <<
+			ADF_PF2VF_MSGTYPE_SHIFT;
+		resp |= ADF_PFVF_COMPAT_THIS_VERSION <<
+			ADF_PF2VF_VERSION_RESP_VERS_SHIFT;
+		resp |= compat << ADF_PF2VF_VERSION_RESP_RESULT_SHIFT;
 		}
 		break;
 	case ADF_VF2PF_MSGTYPE_VERSION_REQ:
+		{
+		u8 compat;
+
 		dev_dbg(&GET_DEV(accel_dev),
 			"Legacy VersionRequest received from VF%d 0x%x\n",
 			vf_nr + 1, msg);
-		resp = (ADF_PF2VF_MSGORIGIN_SYSTEM |
-			 (ADF_PF2VF_MSGTYPE_VERSION_RESP <<
-			  ADF_PF2VF_MSGTYPE_SHIFT) |
-			 (ADF_PFVF_COMPAT_THIS_VERSION <<
-			  ADF_PF2VF_VERSION_RESP_VERS_SHIFT));
-		resp |= ADF_PF2VF_VF_COMPATIBLE <<
-			ADF_PF2VF_VERSION_RESP_RESULT_SHIFT;
+
+		/* PF always newer than legacy VF */
+		compat = ADF_PF2VF_VF_COMPATIBLE;
+
+		resp = ADF_PF2VF_MSGORIGIN_SYSTEM;
+		resp |= ADF_PF2VF_MSGTYPE_VERSION_RESP <<
+			ADF_PF2VF_MSGTYPE_SHIFT;
 		/* Set legacy major and minor version num */
 		resp |= 1 << ADF_PF2VF_MAJORVERSION_SHIFT |
 			1 << ADF_PF2VF_MINORVERSION_SHIFT;
+		resp |= compat << ADF_PF2VF_VERSION_RESP_RESULT_SHIFT;
+		}
 		break;
 	case ADF_VF2PF_MSGTYPE_INIT:
 		{
-- 
2.33.1

