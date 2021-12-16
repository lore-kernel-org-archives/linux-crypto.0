Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 549A2C433F5
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Dec 2021 09:11:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232930AbhLPJLQ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 16 Dec 2021 04:11:16 -0500
Received: from mga12.intel.com ([192.55.52.136]:9653 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232925AbhLPJLO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Dec 2021 04:11:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639645874; x=1671181874;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=NAnphNHT/gBugaCkRUMP+RZ7Sjjpk/Tmol23ImOmNCY=;
  b=BSg9ahoBO8Dxg53izy422AyEedBXfINN/Ggp9p9nEtoHE14iaiBKoCkA
   0nyOpK2RLUsvcyXNWXyMYm6If24lNcSquPriGNoMfgXgFhpS6Ysi0LdNe
   u2mobAFOV/GRecGa63oQEPO+AtL6jyDBpko32i2PLSp5Yg+tmHq/32maJ
   l13hQOTq4DEDC/gKvOSAg4br/SLAlr9/efqjIcZtdEwersjzokTLD6SeF
   R+NTvkI/3txW3D14/Fis7+dpBXIVNf2zAkxWx74VcfCgfVQFZOAG8gxCY
   wSf/eOf2FclbGOJvkfTjFbvo1p5kSeHohaB6q0Qx20CZUdLP7fUfqVJ9+
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10199"; a="219458340"
X-IronPort-AV: E=Sophos;i="5.88,211,1635231600"; 
   d="scan'208";a="219458340"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2021 01:11:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,211,1635231600"; 
   d="scan'208";a="465968408"
Received: from silpixa00393544.ir.intel.com ([10.237.213.118])
  by orsmga006.jf.intel.com with ESMTP; 16 Dec 2021 01:11:12 -0800
From:   Marco Chiappero <marco.chiappero@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        giovanni.cabiddu@intel.com, marco.chiappero@intel.com,
        Fiona Trahe <fiona.trahe@intel.com>
Subject: [PATCH 02/24] crypto: qat - set CIPHER capability for QAT GEN2
Date:   Thu, 16 Dec 2021 09:13:12 +0000
Message-Id: <20211216091334.402420-3-marco.chiappero@intel.com>
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

Set the CIPHER capability for QAT GEN2 devices if the hardware supports
it. This is done if both the CIPHER and the AUTHENTICATION engines are
available on the device.

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Marco Chiappero <marco.chiappero@intel.com>
Reviewed-by: Fiona Trahe <fiona.trahe@intel.com>
Reviewed-by: Marco Chiappero <marco.chiappero@intel.com>
---
 drivers/crypto/qat/qat_common/adf_gen2_hw_data.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_gen2_hw_data.c b/drivers/crypto/qat/qat_common/adf_gen2_hw_data.c
index 3b48fdaaff6d..3ea26f2f4a22 100644
--- a/drivers/crypto/qat/qat_common/adf_gen2_hw_data.c
+++ b/drivers/crypto/qat/qat_common/adf_gen2_hw_data.c
@@ -211,17 +211,23 @@ u32 adf_gen2_get_accel_cap(struct adf_accel_dev *accel_dev)
 	u32 legfuses;
 	u32 capabilities = ICP_ACCEL_CAPABILITIES_CRYPTO_SYMMETRIC |
 			   ICP_ACCEL_CAPABILITIES_CRYPTO_ASYMMETRIC |
-			   ICP_ACCEL_CAPABILITIES_AUTHENTICATION;
+			   ICP_ACCEL_CAPABILITIES_AUTHENTICATION |
+			   ICP_ACCEL_CAPABILITIES_CIPHER;
 
 	/* Read accelerator capabilities mask */
 	pci_read_config_dword(pdev, ADF_DEVICE_LEGFUSE_OFFSET, &legfuses);
 
-	if (legfuses & ICP_ACCEL_MASK_CIPHER_SLICE)
+	/* A set bit in legfuses means the feature is OFF in this SKU */
+	if (legfuses & ICP_ACCEL_MASK_CIPHER_SLICE) {
 		capabilities &= ~ICP_ACCEL_CAPABILITIES_CRYPTO_SYMMETRIC;
+		capabilities &= ~ICP_ACCEL_CAPABILITIES_CIPHER;
+	}
 	if (legfuses & ICP_ACCEL_MASK_PKE_SLICE)
 		capabilities &= ~ICP_ACCEL_CAPABILITIES_CRYPTO_ASYMMETRIC;
-	if (legfuses & ICP_ACCEL_MASK_AUTH_SLICE)
+	if (legfuses & ICP_ACCEL_MASK_AUTH_SLICE) {
 		capabilities &= ~ICP_ACCEL_CAPABILITIES_AUTHENTICATION;
+		capabilities &= ~ICP_ACCEL_CAPABILITIES_CIPHER;
+	}
 
 	if ((straps | fuses) & ADF_POWERGATE_PKE)
 		capabilities &= ~ICP_ACCEL_CAPABILITIES_CRYPTO_ASYMMETRIC;
-- 
2.31.1

