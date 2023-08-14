Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D52CC001B0
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Aug 2023 16:16:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229723AbjHNQPm (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 14 Aug 2023 12:15:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232424AbjHNQPh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 14 Aug 2023 12:15:37 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA048F1
        for <linux-crypto@vger.kernel.org>; Mon, 14 Aug 2023 09:15:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692029736; x=1723565736;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=AEyunAH/E6DdwmVRTMX9+4wuVQe5/PGuYqA1Y7WHY/k=;
  b=jHBEd8C0YIqGhnbeLd6a8kF1cctgZR2yAVASUG/mujer8N7t8ncsXI4E
   DPcY4jXs2fNFc3DNIscOwtyc24c+KA3wM7CIhO3G2/n5Mfe63IIG77dv9
   RLqtmW8C3dd2sOVXlx7l/xkCuLMMZa1CJMCgxAjyyApoKE3WSX9t7fxKY
   0gLs30iilPph2n+osh40MHlv2H5/2BacuBBVwu8v6UTOjEYUpEjiOp1w3
   SH0aWN4VhyM8v7WaP86kl5TpWN/X3IjLKeTewF9caBmQkgrcotnVFHo+b
   urul0+GUdjbtayEJqDZ1Rhj0TDwbUo84vSrf6qIk3hLJfydVxPwoyxI7y
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10802"; a="369546386"
X-IronPort-AV: E=Sophos;i="6.01,173,1684825200"; 
   d="scan'208";a="369546386"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2023 09:07:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10802"; a="823499408"
X-IronPort-AV: E=Sophos;i="6.01,173,1684825200"; 
   d="scan'208";a="823499408"
Received: from silpixa00400295.ir.intel.com ([10.237.213.194])
  by FMSMGA003.fm.intel.com with ESMTP; 14 Aug 2023 09:07:44 -0700
From:   Adam Guerin <adam.guerin@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Adam Guerin <adam.guerin@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Fiona Trahe <fiona.trahe@intel.com>
Subject: [PATCH] crypto: qat - fix crypto capability detection for 4xxx
Date:   Mon, 14 Aug 2023 16:52:30 +0100
Message-Id: <20230814155230.232672-1-adam.guerin@intel.com>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Organisation: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare, Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

When extending the capability detection logic for 4xxx devices the
SMx algorithms were accidentally missed.
Enable these SMx capabilities by default for QAT GEN4 devices.

Check for device variants where the SMx algorithms are explicitly
disabled by the GEN4 hardware. This is indicated in fusectl1
register.
Mask out SM3 and SM4 based on a bit specific to those algorithms.
Mask out SM2 if the PKE slice is not present.

Fixes: 4b44d28c715d ("crypto: qat - extend crypto capability detection for 4xxx")
Signed-off-by: Adam Guerin <adam.guerin@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Fiona Trahe <fiona.trahe@intel.com>
---
 drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c | 9 +++++++++
 drivers/crypto/intel/qat/qat_common/icp_qat_hw.h     | 5 ++++-
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c b/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
index 268a1f7694fc..dd4464b7e00b 100644
--- a/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
@@ -225,6 +225,8 @@ static u32 get_accel_cap(struct adf_accel_dev *accel_dev)
 			  ICP_ACCEL_CAPABILITIES_HKDF |
 			  ICP_ACCEL_CAPABILITIES_CHACHA_POLY |
 			  ICP_ACCEL_CAPABILITIES_AESGCM_SPC |
+			  ICP_ACCEL_CAPABILITIES_SM3 |
+			  ICP_ACCEL_CAPABILITIES_SM4 |
 			  ICP_ACCEL_CAPABILITIES_AES_V2;
 
 	/* A set bit in fusectl1 means the feature is OFF in this SKU */
@@ -248,12 +250,19 @@ static u32 get_accel_cap(struct adf_accel_dev *accel_dev)
 		capabilities_sym &= ~ICP_ACCEL_CAPABILITIES_CIPHER;
 	}
 
+	if (fusectl1 & ICP_ACCEL_4XXX_MASK_SMX_SLICE) {
+		capabilities_sym &= ~ICP_ACCEL_CAPABILITIES_SM3;
+		capabilities_sym &= ~ICP_ACCEL_CAPABILITIES_SM4;
+	}
+
 	capabilities_asym = ICP_ACCEL_CAPABILITIES_CRYPTO_ASYMMETRIC |
 			  ICP_ACCEL_CAPABILITIES_CIPHER |
+			  ICP_ACCEL_CAPABILITIES_SM2 |
 			  ICP_ACCEL_CAPABILITIES_ECEDMONT;
 
 	if (fusectl1 & ICP_ACCEL_4XXX_MASK_PKE_SLICE) {
 		capabilities_asym &= ~ICP_ACCEL_CAPABILITIES_CRYPTO_ASYMMETRIC;
+		capabilities_asym &= ~ICP_ACCEL_CAPABILITIES_SM2;
 		capabilities_asym &= ~ICP_ACCEL_CAPABILITIES_ECEDMONT;
 	}
 
diff --git a/drivers/crypto/intel/qat/qat_common/icp_qat_hw.h b/drivers/crypto/intel/qat/qat_common/icp_qat_hw.h
index a65059e56248..0c8883e2ccc6 100644
--- a/drivers/crypto/intel/qat/qat_common/icp_qat_hw.h
+++ b/drivers/crypto/intel/qat/qat_common/icp_qat_hw.h
@@ -97,7 +97,10 @@ enum icp_qat_capabilities_mask {
 	ICP_ACCEL_CAPABILITIES_SHA3_EXT = BIT(15),
 	ICP_ACCEL_CAPABILITIES_AESGCM_SPC = BIT(16),
 	ICP_ACCEL_CAPABILITIES_CHACHA_POLY = BIT(17),
-	/* Bits 18-21 are currently reserved */
+	ICP_ACCEL_CAPABILITIES_SM2 = BIT(18),
+	ICP_ACCEL_CAPABILITIES_SM3 = BIT(19),
+	ICP_ACCEL_CAPABILITIES_SM4 = BIT(20),
+	/* Bit 21 is currently reserved */
 	ICP_ACCEL_CAPABILITIES_CNV_INTEGRITY = BIT(22),
 	ICP_ACCEL_CAPABILITIES_CNV_INTEGRITY64 = BIT(23),
 	ICP_ACCEL_CAPABILITIES_LZ4_COMPRESSION = BIT(24),

base-commit: 39d44d7baae3379954cefc4982939f5e2b61ca60
-- 
2.40.1

