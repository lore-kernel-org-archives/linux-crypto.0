Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35012C433F5
	for <linux-crypto@archiver.kernel.org>; Wed, 17 Nov 2021 14:31:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1BA8A61B08
	for <linux-crypto@archiver.kernel.org>; Wed, 17 Nov 2021 14:31:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238579AbhKQOey (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 17 Nov 2021 09:34:54 -0500
Received: from mga01.intel.com ([192.55.52.88]:57939 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238622AbhKQOek (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 17 Nov 2021 09:34:40 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10170"; a="257722684"
X-IronPort-AV: E=Sophos;i="5.87,241,1631602800"; 
   d="scan'208";a="257722684"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2021 06:31:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,241,1631602800"; 
   d="scan'208";a="735829829"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.76])
  by fmsmga006.fm.intel.com with ESMTP; 17 Nov 2021 06:31:40 -0800
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        marco.chiappero@intel.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH v3 20/25] crypto: qat - use enums for PFVF protocol codes
Date:   Wed, 17 Nov 2021 14:30:53 +0000
Message-Id: <20211117143058.211550-21-giovanni.cabiddu@intel.com>
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

Replace PFVF constants with enumerations for valid protocol codes.

Signed-off-by: Marco Chiappero <marco.chiappero@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/qat/qat_common/adf_pfvf_msg.h | 33 +++++++++++++-------
 1 file changed, 22 insertions(+), 11 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_pfvf_msg.h b/drivers/crypto/qat/qat_common/adf_pfvf_msg.h
index 23f4c4b35dac..8b476072df28 100644
--- a/drivers/crypto/qat/qat_common/adf_pfvf_msg.h
+++ b/drivers/crypto/qat/qat_common/adf_pfvf_msg.h
@@ -60,8 +60,11 @@
 #define ADF_PF2VF_IN_USE_BY_PF_MASK		0xFFFE0000
 #define ADF_PF2VF_MSGTYPE_MASK			0x0000003C
 #define ADF_PF2VF_MSGTYPE_SHIFT			2
-#define ADF_PF2VF_MSGTYPE_RESTARTING		0x01
-#define ADF_PF2VF_MSGTYPE_VERSION_RESP		0x02
+
+enum pf2vf_msgtype {
+	ADF_PF2VF_MSGTYPE_RESTARTING		= 0x01,
+	ADF_PF2VF_MSGTYPE_VERSION_RESP		= 0x02,
+};
 
 /* VF->PF messages */
 #define ADF_VF2PF_INT				BIT(16)
@@ -70,14 +73,19 @@
 #define ADF_VF2PF_IN_USE_BY_VF_MASK		0x0000FFFE
 #define ADF_VF2PF_MSGTYPE_MASK			0x003C0000
 #define ADF_VF2PF_MSGTYPE_SHIFT			18
-#define ADF_VF2PF_MSGTYPE_INIT			0x3
-#define ADF_VF2PF_MSGTYPE_SHUTDOWN		0x4
-#define ADF_VF2PF_MSGTYPE_VERSION_REQ		0x5
-#define ADF_VF2PF_MSGTYPE_COMPAT_VER_REQ	0x6
+
+enum vf2pf_msgtype {
+	ADF_VF2PF_MSGTYPE_INIT			= 0x03,
+	ADF_VF2PF_MSGTYPE_SHUTDOWN		= 0x04,
+	ADF_VF2PF_MSGTYPE_VERSION_REQ		= 0x05,
+	ADF_VF2PF_MSGTYPE_COMPAT_VER_REQ	= 0x06,
+};
 
 /* VF/PF compatibility version. */
-/* Reference to the current version */
-#define ADF_PFVF_COMPAT_THIS_VERSION		1  /* PF<->VF compat */
+enum pfvf_compatibility_version {
+	/* Reference to the current version */
+	ADF_PFVF_COMPAT_THIS_VERSION		= 0x01,
+};
 
 /* PF->VF Version Response */
 #define ADF_PF2VF_MINORVERSION_SHIFT		6
@@ -86,9 +94,12 @@
 #define ADF_PF2VF_VERSION_RESP_VERS_SHIFT	6
 #define ADF_PF2VF_VERSION_RESP_RESULT_MASK	0x0000C000
 #define ADF_PF2VF_VERSION_RESP_RESULT_SHIFT	14
-#define ADF_PF2VF_VF_COMPATIBLE			1
-#define ADF_PF2VF_VF_INCOMPATIBLE		2
-#define ADF_PF2VF_VF_COMPAT_UNKNOWN		3
+
+enum pf2vf_compat_response {
+	ADF_PF2VF_VF_COMPATIBLE			= 0x01,
+	ADF_PF2VF_VF_INCOMPATIBLE		= 0x02,
+	ADF_PF2VF_VF_COMPAT_UNKNOWN		= 0x03,
+};
 
 /* VF->PF Compatible Version Request */
 #define ADF_VF2PF_COMPAT_VER_REQ_SHIFT		22
-- 
2.33.1

