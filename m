Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 064BFC433EF
	for <linux-crypto@archiver.kernel.org>; Mon,  4 Apr 2022 14:34:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241508AbiDDOgo (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 4 Apr 2022 10:36:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356413AbiDDOgo (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 4 Apr 2022 10:36:44 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FD33140C0
        for <linux-crypto@vger.kernel.org>; Mon,  4 Apr 2022 07:34:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649082888; x=1680618888;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=m2r0N6cjT2YMCTdugYcr941LY0lFcIhBV2ONAbTW6FE=;
  b=RsC3lH6/nlpXQ7TtOuHPEIXvF1XQiBDGGCmmwuzjm743VXK1gd3WbV3j
   VthR7UZtOZXx5pFkCnFrw79/MOO1AjPbTmQKcpCKFWFhkoDHfsUjrALzB
   BMrIHZC41uRTfcp72w1NBAEnzXspX+cemwX2lufEjy9W2mO49eEMqUBfC
   WtH0kJuxvXlF5DGF0Cm5VXk+NeeQ3UxhIQDwPo58/QCo4zCIvtmi+qwBm
   Vz+u7hlkRRSZSG8/r7dxZHguprIvkMKp/4gcAsGVMtemvTEd009kjcB6Q
   v5SL4VHhivaSW94P3MLcj6VHkjuZLEbDrwpvBODrwmcwJYq9I9nrca9kv
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10307"; a="260704465"
X-IronPort-AV: E=Sophos;i="5.90,234,1643702400"; 
   d="scan'208";a="260704465"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Apr 2022 07:34:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,234,1643702400"; 
   d="scan'208";a="657521394"
Received: from silpixa00393544.ir.intel.com ([10.237.213.118])
  by orsmga004.jf.intel.com with ESMTP; 04 Apr 2022 07:34:46 -0700
From:   Marco Chiappero <marco.chiappero@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        giovanni.cabiddu@intel.com,
        Marco Chiappero <marco.chiappero@intel.com>
Subject: [PATCH 1/8] crypto: qat - set CIPHER capability for DH895XCC
Date:   Mon,  4 Apr 2022 15:38:22 +0100
Message-Id: <20220404143829.147404-2-marco.chiappero@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220404143829.147404-1-marco.chiappero@intel.com>
References: <20220404143829.147404-1-marco.chiappero@intel.com>
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

