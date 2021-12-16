Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8512C433F5
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Dec 2021 09:11:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232951AbhLPJLU (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 16 Dec 2021 04:11:20 -0500
Received: from mga12.intel.com ([192.55.52.136]:9653 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232918AbhLPJLR (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Dec 2021 04:11:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639645877; x=1671181877;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vB/grSDQdAl7lLT6Uv6IOm2Tb+gmkRxxq2A2ADLqsDw=;
  b=O/ya4BTw9AW8qZhSsNNOOMkhI4sF3fRttUBHqo+AdGCZ8XufzEwHRBBv
   95zkpZM4iH5t3G8fBu9jU+sGPEdym2kOw4HoBta42o35VACa6AcMrSM8i
   7YQC4WYkZbFvMDoZ7Szd7LVbGmpjdo6v8juRFQAsb8wEQO903QGIqvhmU
   L0ckCYfLTI2LnlzIVkfJgGcTHW2LUK+CjgAkiEQvp8+BRq5b5lOHP9I/Z
   KFb+CrZAcXmg/He5SICUaDDkwjLSUChvVn1ZNUU+jFHBpeb+2EvkSfwP6
   rxDnf7MBYkHrdHIarGybdlWhBVEwQgrIUypdk3tUDRdNrLZf8TFiqLS0+
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10199"; a="219458352"
X-IronPort-AV: E=Sophos;i="5.88,211,1635231600"; 
   d="scan'208";a="219458352"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2021 01:11:16 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,211,1635231600"; 
   d="scan'208";a="465968411"
Received: from silpixa00393544.ir.intel.com ([10.237.213.118])
  by orsmga006.jf.intel.com with ESMTP; 16 Dec 2021 01:11:13 -0800
From:   Marco Chiappero <marco.chiappero@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        giovanni.cabiddu@intel.com, marco.chiappero@intel.com,
        Fiona Trahe <fiona.trahe@intel.com>
Subject: [PATCH 03/24] crypto: qat - set COMPRESSION capability for QAT GEN2
Date:   Thu, 16 Dec 2021 09:13:13 +0000
Message-Id: <20211216091334.402420-4-marco.chiappero@intel.com>
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

Enhance the device capability detection for QAT GEN2 devices to detect if
a device supports the compression service.

This is done by checking both the fuse and the strap registers for c62x
and c3xxx and only the fuse register for dh895xcc.

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Marco Chiappero <marco.chiappero@intel.com>
Reviewed-by: Fiona Trahe <fiona.trahe@intel.com>
Reviewed-by: Marco Chiappero <marco.chiappero@intel.com>
---
 drivers/crypto/qat/qat_common/adf_gen2_hw_data.c       | 8 +++++++-
 drivers/crypto/qat/qat_common/adf_gen2_hw_data.h       | 1 +
 drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c | 2 ++
 3 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/qat/qat_common/adf_gen2_hw_data.c b/drivers/crypto/qat/qat_common/adf_gen2_hw_data.c
index 3ea26f2f4a22..688dd6f53b0b 100644
--- a/drivers/crypto/qat/qat_common/adf_gen2_hw_data.c
+++ b/drivers/crypto/qat/qat_common/adf_gen2_hw_data.c
@@ -212,7 +212,8 @@ u32 adf_gen2_get_accel_cap(struct adf_accel_dev *accel_dev)
 	u32 capabilities = ICP_ACCEL_CAPABILITIES_CRYPTO_SYMMETRIC |
 			   ICP_ACCEL_CAPABILITIES_CRYPTO_ASYMMETRIC |
 			   ICP_ACCEL_CAPABILITIES_AUTHENTICATION |
-			   ICP_ACCEL_CAPABILITIES_CIPHER;
+			   ICP_ACCEL_CAPABILITIES_CIPHER |
+			   ICP_ACCEL_CAPABILITIES_COMPRESSION;
 
 	/* Read accelerator capabilities mask */
 	pci_read_config_dword(pdev, ADF_DEVICE_LEGFUSE_OFFSET, &legfuses);
@@ -228,10 +229,15 @@ u32 adf_gen2_get_accel_cap(struct adf_accel_dev *accel_dev)
 		capabilities &= ~ICP_ACCEL_CAPABILITIES_AUTHENTICATION;
 		capabilities &= ~ICP_ACCEL_CAPABILITIES_CIPHER;
 	}
+	if (legfuses & ICP_ACCEL_MASK_COMPRESS_SLICE)
+		capabilities &= ~ICP_ACCEL_CAPABILITIES_COMPRESSION;
 
 	if ((straps | fuses) & ADF_POWERGATE_PKE)
 		capabilities &= ~ICP_ACCEL_CAPABILITIES_CRYPTO_ASYMMETRIC;
 
+	if ((straps | fuses) & ADF_POWERGATE_DC)
+		capabilities &= ~ICP_ACCEL_CAPABILITIES_COMPRESSION;
+
 	return capabilities;
 }
 EXPORT_SYMBOL_GPL(adf_gen2_get_accel_cap);
diff --git a/drivers/crypto/qat/qat_common/adf_gen2_hw_data.h b/drivers/crypto/qat/qat_common/adf_gen2_hw_data.h
index 448c97f740e7..7c2c17366460 100644
--- a/drivers/crypto/qat/qat_common/adf_gen2_hw_data.h
+++ b/drivers/crypto/qat/qat_common/adf_gen2_hw_data.h
@@ -113,6 +113,7 @@ do { \
 	(ADF_ARB_REG_SLOT * (index)), value)
 
 /* Power gating */
+#define ADF_POWERGATE_DC		BIT(23)
 #define ADF_POWERGATE_PKE		BIT(24)
 
 /* WDT timers
diff --git a/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c b/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
index 27d4cab65dd8..2d18279191d7 100644
--- a/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
+++ b/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
@@ -69,6 +69,8 @@ static u32 get_accel_cap(struct adf_accel_dev *accel_dev)
 		capabilities &= ~ICP_ACCEL_CAPABILITIES_CRYPTO_ASYMMETRIC;
 	if (legfuses & ICP_ACCEL_MASK_AUTH_SLICE)
 		capabilities &= ~ICP_ACCEL_CAPABILITIES_AUTHENTICATION;
+	if (legfuses & ICP_ACCEL_MASK_COMPRESS_SLICE)
+		capabilities &= ~ICP_ACCEL_CAPABILITIES_COMPRESSION;
 
 	return capabilities;
 }
-- 
2.31.1

