Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6EDEC43219
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Dec 2021 09:12:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232939AbhLPJMN (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 16 Dec 2021 04:12:13 -0500
Received: from mga12.intel.com ([192.55.52.136]:9729 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233056AbhLPJMH (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Dec 2021 04:12:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639645927; x=1671181927;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WkgYrnzQsehCwonEcUcwa2P0gUJBvST6b1WyofHFgmo=;
  b=QZTfB9z3XUaGPZ0JHg8QEshA8k2o8vFUnauWRpqz0CJNaz7f3tZhf6+I
   zcwzPbKCkIxF2OlsIZckDxVsNPSsKt1JPJGThwQfK5ydvJsdCq59+CRI+
   P6gkhzFV/Bxs7P/k149wQvQMAd98Ni+dZ4Pl8Jj1yEOy1GpsenLg8reVU
   ojQNCO42igADMDGWVJDD9kCc8MrcaEuk6MoI2QKAMdcFWbEZxunKANDhg
   Us2qN3xz7ibcK5g7vRa+wsfahrfkr6+vYz2xgOQXZyhR6uhoUUkzvi/OD
   qOb4YQUNekoKJjN9wz0JzJxvlkXHGH/22XwLfgknPjqkvVfYlNeV1H+Jx
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10199"; a="219458493"
X-IronPort-AV: E=Sophos;i="5.88,211,1635231600"; 
   d="scan'208";a="219458493"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2021 01:11:56 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,211,1635231600"; 
   d="scan'208";a="465968684"
Received: from silpixa00393544.ir.intel.com ([10.237.213.118])
  by orsmga006.jf.intel.com with ESMTP; 16 Dec 2021 01:11:54 -0800
From:   Marco Chiappero <marco.chiappero@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        giovanni.cabiddu@intel.com, marco.chiappero@intel.com,
        Fiona Trahe <fiona.trahe@intel.com>
Subject: [PATCH 23/24] crypto: qat - allow detection of dc capabilities for 4xxx
Date:   Thu, 16 Dec 2021 09:13:33 +0000
Message-Id: <20211216091334.402420-24-marco.chiappero@intel.com>
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

Add logic to allow the detection of data compression capabilities for
4xxx devices.
The capability detection logic has been refactored to separate the
crypto capabilities from the compression ones.

This patch is not updating the returned capability mask as, up to now,
4xxx devices are configured only to handle crypto operations.

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Marco Chiappero <marco.chiappero@intel.com>
Reviewed-by: Fiona Trahe <fiona.trahe@intel.com>
Reviewed-by: Marco Chiappero <marco.chiappero@intel.com>
---
 .../crypto/qat/qat_4xxx/adf_4xxx_hw_data.c    | 64 +++++++++++--------
 drivers/crypto/qat/qat_common/icp_qat_hw.h    |  6 +-
 2 files changed, 44 insertions(+), 26 deletions(-)

diff --git a/drivers/crypto/qat/qat_4xxx/adf_4xxx_hw_data.c b/drivers/crypto/qat/qat_4xxx/adf_4xxx_hw_data.c
index ef71aa4efd64..40f684103b29 100644
--- a/drivers/crypto/qat/qat_4xxx/adf_4xxx_hw_data.c
+++ b/drivers/crypto/qat/qat_4xxx/adf_4xxx_hw_data.c
@@ -96,46 +96,60 @@ static void set_msix_default_rttable(struct adf_accel_dev *accel_dev)
 static u32 get_accel_cap(struct adf_accel_dev *accel_dev)
 {
 	struct pci_dev *pdev = accel_dev->accel_pci_dev.pci_dev;
+	u32 capabilities_cy, capabilities_dc;
 	u32 fusectl1;
-	u32 capabilities = ICP_ACCEL_CAPABILITIES_CRYPTO_SYMMETRIC |
-			   ICP_ACCEL_CAPABILITIES_CRYPTO_ASYMMETRIC |
-			   ICP_ACCEL_CAPABILITIES_CIPHER |
-			   ICP_ACCEL_CAPABILITIES_AUTHENTICATION |
-			   ICP_ACCEL_CAPABILITIES_SHA3 |
-			   ICP_ACCEL_CAPABILITIES_SHA3_EXT |
-			   ICP_ACCEL_CAPABILITIES_HKDF |
-			   ICP_ACCEL_CAPABILITIES_ECEDMONT |
-			   ICP_ACCEL_CAPABILITIES_CHACHA_POLY |
-			   ICP_ACCEL_CAPABILITIES_AESGCM_SPC |
-			   ICP_ACCEL_CAPABILITIES_AES_V2;
 
 	/* Read accelerator capabilities mask */
 	pci_read_config_dword(pdev, ADF_4XXX_FUSECTL1_OFFSET, &fusectl1);
 
+	capabilities_cy = ICP_ACCEL_CAPABILITIES_CRYPTO_SYMMETRIC |
+			  ICP_ACCEL_CAPABILITIES_CRYPTO_ASYMMETRIC |
+			  ICP_ACCEL_CAPABILITIES_CIPHER |
+			  ICP_ACCEL_CAPABILITIES_AUTHENTICATION |
+			  ICP_ACCEL_CAPABILITIES_SHA3 |
+			  ICP_ACCEL_CAPABILITIES_SHA3_EXT |
+			  ICP_ACCEL_CAPABILITIES_HKDF |
+			  ICP_ACCEL_CAPABILITIES_ECEDMONT |
+			  ICP_ACCEL_CAPABILITIES_CHACHA_POLY |
+			  ICP_ACCEL_CAPABILITIES_AESGCM_SPC |
+			  ICP_ACCEL_CAPABILITIES_AES_V2;
+
 	/* A set bit in fusectl1 means the feature is OFF in this SKU */
 	if (fusectl1 & ICP_ACCEL_4XXX_MASK_CIPHER_SLICE) {
-		capabilities &= ~ICP_ACCEL_CAPABILITIES_CRYPTO_SYMMETRIC;
-		capabilities &= ~ICP_ACCEL_CAPABILITIES_HKDF;
-		capabilities &= ~ICP_ACCEL_CAPABILITIES_CIPHER;
+		capabilities_cy &= ~ICP_ACCEL_CAPABILITIES_CRYPTO_SYMMETRIC;
+		capabilities_cy &= ~ICP_ACCEL_CAPABILITIES_HKDF;
+		capabilities_cy &= ~ICP_ACCEL_CAPABILITIES_CIPHER;
 	}
 	if (fusectl1 & ICP_ACCEL_4XXX_MASK_UCS_SLICE) {
-		capabilities &= ~ICP_ACCEL_CAPABILITIES_CHACHA_POLY;
-		capabilities &= ~ICP_ACCEL_CAPABILITIES_AESGCM_SPC;
-		capabilities &= ~ICP_ACCEL_CAPABILITIES_AES_V2;
-		capabilities &= ~ICP_ACCEL_CAPABILITIES_CIPHER;
+		capabilities_cy &= ~ICP_ACCEL_CAPABILITIES_CHACHA_POLY;
+		capabilities_cy &= ~ICP_ACCEL_CAPABILITIES_AESGCM_SPC;
+		capabilities_cy &= ~ICP_ACCEL_CAPABILITIES_AES_V2;
+		capabilities_cy &= ~ICP_ACCEL_CAPABILITIES_CIPHER;
 	}
 	if (fusectl1 & ICP_ACCEL_4XXX_MASK_AUTH_SLICE) {
-		capabilities &= ~ICP_ACCEL_CAPABILITIES_AUTHENTICATION;
-		capabilities &= ~ICP_ACCEL_CAPABILITIES_SHA3;
-		capabilities &= ~ICP_ACCEL_CAPABILITIES_SHA3_EXT;
-		capabilities &= ~ICP_ACCEL_CAPABILITIES_CIPHER;
+		capabilities_cy &= ~ICP_ACCEL_CAPABILITIES_AUTHENTICATION;
+		capabilities_cy &= ~ICP_ACCEL_CAPABILITIES_SHA3;
+		capabilities_cy &= ~ICP_ACCEL_CAPABILITIES_SHA3_EXT;
+		capabilities_cy &= ~ICP_ACCEL_CAPABILITIES_CIPHER;
 	}
 	if (fusectl1 & ICP_ACCEL_4XXX_MASK_PKE_SLICE) {
-		capabilities &= ~ICP_ACCEL_CAPABILITIES_CRYPTO_ASYMMETRIC;
-		capabilities &= ~ICP_ACCEL_CAPABILITIES_ECEDMONT;
+		capabilities_cy &= ~ICP_ACCEL_CAPABILITIES_CRYPTO_ASYMMETRIC;
+		capabilities_cy &= ~ICP_ACCEL_CAPABILITIES_ECEDMONT;
+	}
+
+	capabilities_dc = ICP_ACCEL_CAPABILITIES_COMPRESSION |
+			  ICP_ACCEL_CAPABILITIES_LZ4_COMPRESSION |
+			  ICP_ACCEL_CAPABILITIES_LZ4S_COMPRESSION |
+			  ICP_ACCEL_CAPABILITIES_CNV_INTEGRITY64;
+
+	if (fusectl1 & ICP_ACCEL_4XXX_MASK_COMPRESS_SLICE) {
+		capabilities_dc &= ~ICP_ACCEL_CAPABILITIES_COMPRESSION;
+		capabilities_dc &= ~ICP_ACCEL_CAPABILITIES_LZ4_COMPRESSION;
+		capabilities_dc &= ~ICP_ACCEL_CAPABILITIES_LZ4S_COMPRESSION;
+		capabilities_dc &= ~ICP_ACCEL_CAPABILITIES_CNV_INTEGRITY64;
 	}
 
-	return capabilities;
+	return capabilities_cy;
 }
 
 static enum dev_sku_info get_sku(struct adf_hw_device_data *self)
diff --git a/drivers/crypto/qat/qat_common/icp_qat_hw.h b/drivers/crypto/qat/qat_common/icp_qat_hw.h
index 5770b2b2c09e..433304cad2ed 100644
--- a/drivers/crypto/qat/qat_common/icp_qat_hw.h
+++ b/drivers/crypto/qat/qat_common/icp_qat_hw.h
@@ -98,7 +98,11 @@ enum icp_qat_capabilities_mask {
 	ICP_ACCEL_CAPABILITIES_SHA3_EXT = BIT(15),
 	ICP_ACCEL_CAPABILITIES_AESGCM_SPC = BIT(16),
 	ICP_ACCEL_CAPABILITIES_CHACHA_POLY = BIT(17),
-	/* Bits 18-25 are currently reserved */
+	/* Bits 18-21 are currently reserved */
+	ICP_ACCEL_CAPABILITIES_CNV_INTEGRITY = BIT(22),
+	ICP_ACCEL_CAPABILITIES_CNV_INTEGRITY64 = BIT(23),
+	ICP_ACCEL_CAPABILITIES_LZ4_COMPRESSION = BIT(24),
+	ICP_ACCEL_CAPABILITIES_LZ4S_COMPRESSION = BIT(25),
 	ICP_ACCEL_CAPABILITIES_AES_V2 = BIT(26)
 };
 
-- 
2.31.1

