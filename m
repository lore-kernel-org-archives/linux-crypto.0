Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E4E0C433FE
	for <linux-crypto@archiver.kernel.org>; Thu,  7 Apr 2022 16:51:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232940AbiDGQxI (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 7 Apr 2022 12:53:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345833AbiDGQxG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 7 Apr 2022 12:53:06 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCC14BF7F
        for <linux-crypto@vger.kernel.org>; Thu,  7 Apr 2022 09:51:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649350266; x=1680886266;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OkER05QTztl9YMzLq2EfjnhlHZ5pE3LhH1CHc/xAeFQ=;
  b=WRPFJS664F2gkfBn5Q5KET4DEmI94na6HZzoSXSutWLIeiB7TZt35/3C
   2w2CalHShmWsVMu44WU94rQooHPM22FABis6aUbGAfxuz+MnkgeAhyYz9
   OYtSrgaZxR4HYvy7IOk/NHXRNE3QsPPQ7rF+eAiQqyHsAQQsxI7wW/g8k
   dWalcVHzCkyBy7EJDZWuGMB4NbXRtCQ83lvOxGWfNZLOmsR68iA0SjRbq
   01p1tRx0i4J/bvT6sSTckmJ8JFHDIQdlcBTfEeo/NmbIwpYHeZy8VGvG7
   T4iFndu5EonsZyjrJl4YHQWNLshpYfuJFoUkprqfso3T++WHuHgnymXjS
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10310"; a="241312006"
X-IronPort-AV: E=Sophos;i="5.90,242,1643702400"; 
   d="scan'208";a="241312006"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2022 09:51:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,242,1643702400"; 
   d="scan'208";a="652898287"
Received: from silpixa00393544.ir.intel.com ([10.237.213.118])
  by fmsmga002.fm.intel.com with ESMTP; 07 Apr 2022 09:51:05 -0700
From:   Marco Chiappero <marco.chiappero@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        giovanni.cabiddu@intel.com,
        Marco Chiappero <marco.chiappero@intel.com>
Subject: [PATCH v2 02/16] crypto: qat - set COMPRESSION capability for DH895XCC
Date:   Thu,  7 Apr 2022 17:54:41 +0100
Message-Id: <20220407165455.256777-3-marco.chiappero@intel.com>
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

The capability detection logic clears bits for the features that are
disabled in a certain SKU. For example, if the bit associate to
compression is not present in the LEGFUSE register, the correspondent
bit is cleared in the capability mask.
This change adds the compression capability to the mask as this was
missing in the commit that enhanced the capability detection logic.

Fixes: cfe4894eccdc ("crypto: qat - set COMPRESSION capability for QAT GEN2")
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Marco Chiappero <marco.chiappero@intel.com>
Reviewed-by: Marco Chiappero <marco.chiappero@intel.com>
---
 drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c b/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
index ff13047772e3..61d5467e0d92 100644
--- a/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
+++ b/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
@@ -59,7 +59,8 @@ static u32 get_accel_cap(struct adf_accel_dev *accel_dev)
 	capabilities = ICP_ACCEL_CAPABILITIES_CRYPTO_SYMMETRIC |
 		       ICP_ACCEL_CAPABILITIES_CRYPTO_ASYMMETRIC |
 		       ICP_ACCEL_CAPABILITIES_AUTHENTICATION |
-		       ICP_ACCEL_CAPABILITIES_CIPHER;
+		       ICP_ACCEL_CAPABILITIES_CIPHER |
+		       ICP_ACCEL_CAPABILITIES_COMPRESSION;
 
 	/* Read accelerator capabilities mask */
 	pci_read_config_dword(pdev, ADF_DEVICE_LEGFUSE_OFFSET, &legfuses);
-- 
2.34.1

