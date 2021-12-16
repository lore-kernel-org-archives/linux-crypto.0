Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11271C433FE
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Dec 2021 09:11:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232938AbhLPJLe (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 16 Dec 2021 04:11:34 -0500
Received: from mga12.intel.com ([192.55.52.136]:9683 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232619AbhLPJLc (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Dec 2021 04:11:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639645892; x=1671181892;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ZPoBss+8BrjSnslk/OP6CDGYWVGRc9nCraeKvdVLrjc=;
  b=hyMUT9nsUqf4y5OJYVAsZmGbHpQM97u3FQvxo8voTiy+8N5ccawEuqXH
   MxvjI5eHy0Q8qJVBe/+Y9VPPdCyn4SPvfBTgtly7TyAqy7dhZgEHS48Dc
   AZZ8n3DwtAAHWKwbQ1n61Se4PXuq+8oMzfg8FGInOV9QUfvay0v8beeiz
   pKLnTxGqeHgHlJzPLGJtHq0dI3gcNSYJFb9n9qXPmNSJDyGzNmSq0Jjy/
   M3Dldwog0StkmwWfiBebLlHG3v/p0ta53Q7FwhLjTj2i8rU0hz1P2FSRZ
   gzFLpdTAOsMWnUxcO8wRL0dOmZvf+KW5rdtcEU4GjRhMSOaZyJcix9A0t
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10199"; a="219458432"
X-IronPort-AV: E=Sophos;i="5.88,211,1635231600"; 
   d="scan'208";a="219458432"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2021 01:11:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,211,1635231600"; 
   d="scan'208";a="465968497"
Received: from silpixa00393544.ir.intel.com ([10.237.213.118])
  by orsmga006.jf.intel.com with ESMTP; 16 Dec 2021 01:11:30 -0800
From:   Marco Chiappero <marco.chiappero@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        giovanni.cabiddu@intel.com, marco.chiappero@intel.com,
        Fiona Trahe <fiona.trahe@intel.com>
Subject: [PATCH 11/24] crypto: qat - leverage bitfield.h utils for PFVF messages
Date:   Thu, 16 Dec 2021 09:13:21 +0000
Message-Id: <20211216091334.402420-12-marco.chiappero@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211216091334.402420-1-marco.chiappero@intel.com>
References: <20211216091334.402420-1-marco.chiappero@intel.com>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The PFVF protocol defines messages composed of a number of control
bitfields. Replace all the code setting and retrieving such bits
with the utilities from bitfield.h, to improve code quality and
readability.

Signed-off-by: Marco Chiappero <marco.chiappero@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Fiona Trahe <fiona.trahe@intel.com>
---
 drivers/crypto/qat/qat_common/adf_pfvf_msg.h      |  8 ++++----
 drivers/crypto/qat/qat_common/adf_pfvf_pf_proto.c | 13 +++++++------
 drivers/crypto/qat/qat_common/adf_pfvf_vf_msg.c   |  7 +++----
 3 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_pfvf_msg.h b/drivers/crypto/qat/qat_common/adf_pfvf_msg.h
index 26eb27853e83..daee3d7ceb8c 100644
--- a/drivers/crypto/qat/qat_common/adf_pfvf_msg.h
+++ b/drivers/crypto/qat/qat_common/adf_pfvf_msg.h
@@ -3,6 +3,8 @@
 #ifndef ADF_PFVF_MSG_H
 #define ADF_PFVF_MSG_H
 
+#include <linux/bits.h>
+
 /*
  * PF<->VF Messaging
  * The PF has an array of 32-bit PF2VF registers, one for each VF.  The
@@ -86,10 +88,8 @@ enum pfvf_compatibility_version {
 };
 
 /* PF->VF Version Response */
-#define ADF_PF2VF_VERSION_RESP_VERS_SHIFT	0
-#define ADF_PF2VF_VERSION_RESP_VERS_MASK	0xFF
-#define ADF_PF2VF_VERSION_RESP_RESULT_SHIFT	8
-#define ADF_PF2VF_VERSION_RESP_RESULT_MASK	0x03
+#define ADF_PF2VF_VERSION_RESP_VERS_MASK	GENMASK(7, 0)
+#define ADF_PF2VF_VERSION_RESP_RESULT_MASK	GENMASK(9, 8)
 
 enum pf2vf_compat_response {
 	ADF_PF2VF_VF_COMPATIBLE			= 0x01,
diff --git a/drivers/crypto/qat/qat_common/adf_pfvf_pf_proto.c b/drivers/crypto/qat/qat_common/adf_pfvf_pf_proto.c
index bb4d7db68579..8785b9d1df91 100644
--- a/drivers/crypto/qat/qat_common/adf_pfvf_pf_proto.c
+++ b/drivers/crypto/qat/qat_common/adf_pfvf_pf_proto.c
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: (BSD-3-Clause OR GPL-2.0-only)
 /* Copyright(c) 2015 - 2021 Intel Corporation */
+#include <linux/bitfield.h>
 #include <linux/spinlock.h>
 #include <linux/types.h>
 #include "adf_accel_devices.h"
@@ -64,9 +65,9 @@ static int adf_handle_vf2pf_msg(struct adf_accel_dev *accel_dev, u8 vf_nr,
 			compat = ADF_PF2VF_VF_COMPAT_UNKNOWN;
 
 		resp->type = ADF_PF2VF_MSGTYPE_VERSION_RESP;
-		resp->data = ADF_PFVF_COMPAT_THIS_VERSION <<
-			     ADF_PF2VF_VERSION_RESP_VERS_SHIFT;
-		resp->data |= compat << ADF_PF2VF_VERSION_RESP_RESULT_SHIFT;
+		resp->data = FIELD_PREP(ADF_PF2VF_VERSION_RESP_VERS_MASK,
+					ADF_PFVF_COMPAT_THIS_VERSION) |
+			     FIELD_PREP(ADF_PF2VF_VERSION_RESP_RESULT_MASK, compat);
 		}
 		break;
 	case ADF_VF2PF_MSGTYPE_VERSION_REQ:
@@ -80,10 +81,10 @@ static int adf_handle_vf2pf_msg(struct adf_accel_dev *accel_dev, u8 vf_nr,
 		/* PF always newer than legacy VF */
 		compat = ADF_PF2VF_VF_COMPATIBLE;
 
-		resp->type = ADF_PF2VF_MSGTYPE_VERSION_RESP;
 		/* Set legacy major and minor version to the latest, 1.1 */
-		resp->data |= 0x11;
-		resp->data |= compat << ADF_PF2VF_VERSION_RESP_RESULT_SHIFT;
+		resp->type = ADF_PF2VF_MSGTYPE_VERSION_RESP;
+		resp->data = FIELD_PREP(ADF_PF2VF_VERSION_RESP_VERS_MASK, 0x11) |
+			     FIELD_PREP(ADF_PF2VF_VERSION_RESP_RESULT_MASK, compat);
 		}
 		break;
 	case ADF_VF2PF_MSGTYPE_INIT:
diff --git a/drivers/crypto/qat/qat_common/adf_pfvf_vf_msg.c b/drivers/crypto/qat/qat_common/adf_pfvf_vf_msg.c
index 5184a77598d2..130d7b9c12ea 100644
--- a/drivers/crypto/qat/qat_common/adf_pfvf_vf_msg.c
+++ b/drivers/crypto/qat/qat_common/adf_pfvf_vf_msg.c
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: (BSD-3-Clause OR GPL-2.0-only)
 /* Copyright(c) 2015 - 2021 Intel Corporation */
+#include <linux/bitfield.h>
 #include "adf_accel_devices.h"
 #include "adf_common_drv.h"
 #include "adf_pfvf_msg.h"
@@ -67,10 +68,8 @@ int adf_vf2pf_request_version(struct adf_accel_dev *accel_dev)
 		return ret;
 	}
 
-	pf_version = (resp.data >> ADF_PF2VF_VERSION_RESP_VERS_SHIFT)
-		     & ADF_PF2VF_VERSION_RESP_VERS_MASK;
-	compat = (resp.data >> ADF_PF2VF_VERSION_RESP_RESULT_SHIFT)
-		 & ADF_PF2VF_VERSION_RESP_RESULT_MASK;
+	pf_version = FIELD_GET(ADF_PF2VF_VERSION_RESP_VERS_MASK, resp.data);
+	compat = FIELD_GET(ADF_PF2VF_VERSION_RESP_RESULT_MASK, resp.data);
 
 	/* Response from PF received, check compatibility */
 	switch (compat) {
-- 
2.31.1

