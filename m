Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC3B7C433EF
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Dec 2021 09:11:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232918AbhLPJLV (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 16 Dec 2021 04:11:21 -0500
Received: from mga12.intel.com ([192.55.52.136]:9662 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232926AbhLPJLS (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Dec 2021 04:11:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639645878; x=1671181878;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dV59uIF5JkSeVWQspixFMwEK3gXirCFjVDr7IRBwYlg=;
  b=i+gwtdPfUfPWITnrmHRWiUTy+7zE1N3sU4LAX200DgaW2GRcCOh9sYan
   iDuxqhJMuV/kfnpjBqK0CSdCw57Vy+xm6DDlnK0B3BpGO/dva4u678dDh
   Q2pPx/pGi634s9G8MGBykGqch9N9pX++z+KJGjO5J86tZxlrprVUozwvx
   db9udiODjcSZAxpwjNjy3/0lJHWRzyenxM+3v8uNA/10IMi8LG/aR3OKk
   WJ1NebhvMLSGLe354eY3YNv5S0tujHsGR7UGErac1FQAva1x82lJDk5jP
   3JubdqR6FQLlkkr+jAiXqFjOyJCtttfE/Li0uU+fKdcir7c/EbUg1va01
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10199"; a="219458359"
X-IronPort-AV: E=Sophos;i="5.88,211,1635231600"; 
   d="scan'208";a="219458359"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2021 01:11:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,211,1635231600"; 
   d="scan'208";a="465968426"
Received: from silpixa00393544.ir.intel.com ([10.237.213.118])
  by orsmga006.jf.intel.com with ESMTP; 16 Dec 2021 01:11:16 -0800
From:   Marco Chiappero <marco.chiappero@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        giovanni.cabiddu@intel.com, marco.chiappero@intel.com,
        Fiona Trahe <fiona.trahe@intel.com>
Subject: [PATCH 04/24] crypto: qat - extend crypto capability detection for 4xxx
Date:   Thu, 16 Dec 2021 09:13:14 +0000
Message-Id: <20211216091334.402420-5-marco.chiappero@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211216091334.402420-1-marco.chiappero@intel.com>
References: <20211216091334.402420-1-marco.chiappero@intel.com>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

Extended the capability detection logic for 4xxx devices.
Mask out unsupported algorithms and services based on the value read in
the fuse register.

This includes only capabilities for the crypto service.

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Marco Chiappero <marco.chiappero@intel.com>
Reviewed-by: Fiona Trahe <fiona.trahe@intel.com>
Reviewed-by: Marco Chiappero <marco.chiappero@intel.com>
---
 .../crypto/qat/qat_4xxx/adf_4xxx_hw_data.c    | 29 +++++++++++++++++--
 drivers/crypto/qat/qat_common/icp_qat_hw.h    |  9 +++++-
 2 files changed, 34 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/qat/qat_4xxx/adf_4xxx_hw_data.c b/drivers/crypto/qat/qat_4xxx/adf_4xxx_hw_data.c
index 4658b7bf76da..d320c50c4561 100644
--- a/drivers/crypto/qat/qat_4xxx/adf_4xxx_hw_data.c
+++ b/drivers/crypto/qat/qat_4xxx/adf_4xxx_hw_data.c
@@ -98,18 +98,41 @@ static u32 get_accel_cap(struct adf_accel_dev *accel_dev)
 	u32 fusectl1;
 	u32 capabilities = ICP_ACCEL_CAPABILITIES_CRYPTO_SYMMETRIC |
 			   ICP_ACCEL_CAPABILITIES_CRYPTO_ASYMMETRIC |
+			   ICP_ACCEL_CAPABILITIES_CIPHER |
 			   ICP_ACCEL_CAPABILITIES_AUTHENTICATION |
+			   ICP_ACCEL_CAPABILITIES_SHA3 |
+			   ICP_ACCEL_CAPABILITIES_SHA3_EXT |
+			   ICP_ACCEL_CAPABILITIES_HKDF |
+			   ICP_ACCEL_CAPABILITIES_ECEDMONT |
+			   ICP_ACCEL_CAPABILITIES_CHACHA_POLY |
+			   ICP_ACCEL_CAPABILITIES_AESGCM_SPC |
 			   ICP_ACCEL_CAPABILITIES_AES_V2;
 
 	/* Read accelerator capabilities mask */
 	pci_read_config_dword(pdev, ADF_4XXX_FUSECTL1_OFFSET, &fusectl1);
 
-	if (fusectl1 & ICP_ACCEL_4XXX_MASK_CIPHER_SLICE)
+	/* A set bit in fusectl1 means the feature is OFF in this SKU */
+	if (fusectl1 & ICP_ACCEL_4XXX_MASK_CIPHER_SLICE) {
 		capabilities &= ~ICP_ACCEL_CAPABILITIES_CRYPTO_SYMMETRIC;
-	if (fusectl1 & ICP_ACCEL_4XXX_MASK_AUTH_SLICE)
+		capabilities &= ~ICP_ACCEL_CAPABILITIES_HKDF;
+		capabilities &= ~ICP_ACCEL_CAPABILITIES_CIPHER;
+	}
+	if (fusectl1 & ICP_ACCEL_4XXX_MASK_UCS_SLICE) {
+		capabilities &= ~ICP_ACCEL_CAPABILITIES_CHACHA_POLY;
+		capabilities &= ~ICP_ACCEL_CAPABILITIES_AESGCM_SPC;
+		capabilities &= ~ICP_ACCEL_CAPABILITIES_AES_V2;
+		capabilities &= ~ICP_ACCEL_CAPABILITIES_CIPHER;
+	}
+	if (fusectl1 & ICP_ACCEL_4XXX_MASK_AUTH_SLICE) {
 		capabilities &= ~ICP_ACCEL_CAPABILITIES_AUTHENTICATION;
-	if (fusectl1 & ICP_ACCEL_4XXX_MASK_PKE_SLICE)
+		capabilities &= ~ICP_ACCEL_CAPABILITIES_SHA3;
+		capabilities &= ~ICP_ACCEL_CAPABILITIES_SHA3_EXT;
+		capabilities &= ~ICP_ACCEL_CAPABILITIES_CIPHER;
+	}
+	if (fusectl1 & ICP_ACCEL_4XXX_MASK_PKE_SLICE) {
 		capabilities &= ~ICP_ACCEL_CAPABILITIES_CRYPTO_ASYMMETRIC;
+		capabilities &= ~ICP_ACCEL_CAPABILITIES_ECEDMONT;
+	}
 
 	return capabilities;
 }
diff --git a/drivers/crypto/qat/qat_common/icp_qat_hw.h b/drivers/crypto/qat/qat_common/icp_qat_hw.h
index e39e8a2d51a7..5770b2b2c09e 100644
--- a/drivers/crypto/qat/qat_common/icp_qat_hw.h
+++ b/drivers/crypto/qat/qat_common/icp_qat_hw.h
@@ -91,7 +91,14 @@ enum icp_qat_capabilities_mask {
 	ICP_ACCEL_CAPABILITIES_RAND = BIT(7),
 	ICP_ACCEL_CAPABILITIES_ZUC = BIT(8),
 	ICP_ACCEL_CAPABILITIES_SHA3 = BIT(9),
-	/* Bits 10-25 are currently reserved */
+	/* Bits 10-11 are currently reserved */
+	ICP_ACCEL_CAPABILITIES_HKDF = BIT(12),
+	ICP_ACCEL_CAPABILITIES_ECEDMONT = BIT(13),
+	/* Bit 14 is currently reserved */
+	ICP_ACCEL_CAPABILITIES_SHA3_EXT = BIT(15),
+	ICP_ACCEL_CAPABILITIES_AESGCM_SPC = BIT(16),
+	ICP_ACCEL_CAPABILITIES_CHACHA_POLY = BIT(17),
+	/* Bits 18-25 are currently reserved */
 	ICP_ACCEL_CAPABILITIES_AES_V2 = BIT(26)
 };
 
-- 
2.31.1

