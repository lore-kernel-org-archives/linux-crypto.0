Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5223C4332F
	for <linux-crypto@archiver.kernel.org>; Thu,  7 Apr 2022 16:51:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345838AbiDGQxH (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 7 Apr 2022 12:53:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244193AbiDGQxG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 7 Apr 2022 12:53:06 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 855A95FA2
        for <linux-crypto@vger.kernel.org>; Thu,  7 Apr 2022 09:51:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649350266; x=1680886266;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=m2r0N6cjT2YMCTdugYcr941LY0lFcIhBV2ONAbTW6FE=;
  b=oG3o6k50NmlZgM6hjoaTW3JMWq9VUH1f23wh4/7yhgcYceEFaf++NITq
   yjsVTGMu31KyxKlp2bJYjOdcfvTyBoDM7bopd6ZEoMir2Bn0KZGS91XIW
   S/ASkc2vVvf2CZvizBlO1fPvcmNb3s69FuEv0hCnngn6gMajx6al5kmT3
   zSmBi2zz7B3EdpubysiIIhU1h+5GzmqyfrTcpGyogoAu6K9NLEKJwKPJc
   gJy33HFwteoz8LfCcCH5ohOESHObmCHch02AMYp4FOFRECuCC7OjPnARv
   vrdT9BCcZTgXIajDPSaYBjxs6PsJIIGwp+iLfGlBokcOZbcrawkUWPpP7
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10310"; a="241312000"
X-IronPort-AV: E=Sophos;i="5.90,242,1643702400"; 
   d="scan'208";a="241312000"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2022 09:51:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,242,1643702400"; 
   d="scan'208";a="652898278"
Received: from silpixa00393544.ir.intel.com ([10.237.213.118])
  by fmsmga002.fm.intel.com with ESMTP; 07 Apr 2022 09:51:03 -0700
From:   Marco Chiappero <marco.chiappero@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        giovanni.cabiddu@intel.com,
        Marco Chiappero <marco.chiappero@intel.com>
Subject: [PATCH v2 01/16] crypto: qat - set CIPHER capability for DH895XCC
Date:   Thu,  7 Apr 2022 17:54:40 +0100
Message-Id: <20220407165455.256777-2-marco.chiappero@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220407165455.256777-1-marco.chiappero@intel.com>
References: <20220407165455.256777-1-marco.chiappero@intel.com>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

Set the CIPHER capability for QAT DH895XCC devices if the hardware supports
it. This is done if both the CIPHER and the AUTHENTICATION engines are
available on the device.

Fixes: ad1332aa67ec ("crypto: qat - add support for capability detection")
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Marco Chiappero <marco.chiappero@intel.com>
Reviewed-by: Marco Chiappero <marco.chiappero@intel.com>
---
 .../crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c   | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c b/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
index 09599fe4d2f3..ff13047772e3 100644
--- a/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
+++ b/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
@@ -58,17 +58,23 @@ static u32 get_accel_cap(struct adf_accel_dev *accel_dev)
 
 	capabilities = ICP_ACCEL_CAPABILITIES_CRYPTO_SYMMETRIC |
 		       ICP_ACCEL_CAPABILITIES_CRYPTO_ASYMMETRIC |
-		       ICP_ACCEL_CAPABILITIES_AUTHENTICATION;
+		       ICP_ACCEL_CAPABILITIES_AUTHENTICATION |
+		       ICP_ACCEL_CAPABILITIES_CIPHER;
 
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
 	if (legfuses & ICP_ACCEL_MASK_COMPRESS_SLICE)
 		capabilities &= ~ICP_ACCEL_CAPABILITIES_COMPRESSION;
 
-- 
2.34.1

