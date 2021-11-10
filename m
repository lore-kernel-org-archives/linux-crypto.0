Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 768A8C43219
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Nov 2021 20:53:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5DF9E611F2
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Nov 2021 20:53:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233115AbhKJUzv (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 10 Nov 2021 15:55:51 -0500
Received: from mga09.intel.com ([134.134.136.24]:55820 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233141AbhKJUzs (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 10 Nov 2021 15:55:48 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10164"; a="232611456"
X-IronPort-AV: E=Sophos;i="5.87,224,1631602800"; 
   d="scan'208";a="232611456"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2021 12:53:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,224,1631602800"; 
   d="scan'208";a="642663505"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.51])
  by fmsmga001.fm.intel.com with ESMTP; 10 Nov 2021 12:52:58 -0800
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        marco.chiappero@intel.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH 23/24] crypto: qat - fix VF IDs in PFVF log messages
Date:   Wed, 10 Nov 2021 20:52:16 +0000
Message-Id: <20211110205217.99903-24-giovanni.cabiddu@intel.com>
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

PFVF debug messages use a mix of zero and one based VF IDs.
Switch to zero based VF numbers in all log messages.

Signed-off-by: Marco Chiappero <marco.chiappero@intel.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/qat/qat_common/adf_isr.c           |  2 +-
 drivers/crypto/qat/qat_common/adf_pfvf_pf_proto.c | 10 +++++-----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_isr.c b/drivers/crypto/qat/qat_common/adf_isr.c
index 358200c0d598..522e0c10d9b9 100644
--- a/drivers/crypto/qat/qat_common/adf_isr.c
+++ b/drivers/crypto/qat/qat_common/adf_isr.c
@@ -123,7 +123,7 @@ static bool adf_handle_vf2pf_int(struct adf_accel_dev *accel_dev)
 			if (!__ratelimit(&vf_info->vf2pf_ratelimit)) {
 				dev_info(&GET_DEV(accel_dev),
 					 "Too many ints from VF%d\n",
-					  vf_info->vf_nr + 1);
+					  vf_info->vf_nr);
 				continue;
 			}
 
diff --git a/drivers/crypto/qat/qat_common/adf_pfvf_pf_proto.c b/drivers/crypto/qat/qat_common/adf_pfvf_pf_proto.c
index 2ffd1f442e35..82b6cc7162ba 100644
--- a/drivers/crypto/qat/qat_common/adf_pfvf_pf_proto.c
+++ b/drivers/crypto/qat/qat_common/adf_pfvf_pf_proto.c
@@ -50,7 +50,7 @@ static int adf_handle_vf2pf_msg(struct adf_accel_dev *accel_dev, u32 vf_nr,
 
 		dev_dbg(&GET_DEV(accel_dev),
 			"Compatibility Version Request from VF%d vers=%u\n",
-			vf_nr + 1, vf_compat_ver);
+			vf_nr, vf_compat_ver);
 
 		if (vf_compat_ver <= ADF_PFVF_COMPAT_THIS_VERSION) {
 			compat = ADF_PF2VF_VF_COMPATIBLE;
@@ -76,7 +76,7 @@ static int adf_handle_vf2pf_msg(struct adf_accel_dev *accel_dev, u32 vf_nr,
 
 		dev_dbg(&GET_DEV(accel_dev),
 			"Legacy VersionRequest received from VF%d 0x%x\n",
-			vf_nr + 1, msg);
+			vf_nr, msg);
 
 		/* PF always newer than legacy VF */
 		compat = ADF_PF2VF_VF_COMPATIBLE;
@@ -93,7 +93,7 @@ static int adf_handle_vf2pf_msg(struct adf_accel_dev *accel_dev, u32 vf_nr,
 		{
 		dev_dbg(&GET_DEV(accel_dev),
 			"Init message received from VF%d 0x%x\n",
-			vf_nr + 1, msg);
+			vf_nr, msg);
 		vf_info->init = true;
 		}
 		break;
@@ -101,13 +101,13 @@ static int adf_handle_vf2pf_msg(struct adf_accel_dev *accel_dev, u32 vf_nr,
 		{
 		dev_dbg(&GET_DEV(accel_dev),
 			"Shutdown message received from VF%d 0x%x\n",
-			vf_nr + 1, msg);
+			vf_nr, msg);
 		vf_info->init = false;
 		}
 		break;
 	default:
 		dev_dbg(&GET_DEV(accel_dev), "Unknown message from VF%d (0x%x)\n",
-			vf_nr + 1, msg);
+			vf_nr, msg);
 		return -ENOMSG;
 	}
 
-- 
2.33.1

