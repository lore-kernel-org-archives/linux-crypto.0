Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A347FC77B73
	for <linux-crypto@archiver.kernel.org>; Tue, 30 May 2023 15:58:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232706AbjE3P61 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 30 May 2023 11:58:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232821AbjE3P60 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 May 2023 11:58:26 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A154611A
        for <linux-crypto@vger.kernel.org>; Tue, 30 May 2023 08:58:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685462295; x=1716998295;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=ltM6s2rCv+GoZm09xs2DrngCLyv0eeKtjqNKECC13ac=;
  b=SZE1m5mAM+u5RCPxx0uCXcLOVaJM6wghWHp2g9KvdWIu+wFw3csKZ5ut
   zqjOsdQR/il91GUtIzuqZJmB6vYGs+s3ZMEOvn9qbZDoADzrgZQEU54ld
   GLh0cfB7g5hghx5pxaR3IYbOl6EDL/Io6sHNULtfX2W+kUzJ49OGpJ1ay
   9X665B2S6VuCveVWtCIpDJtizU28FNBtdAQyQr7He0HSPwj7Ys4jMeKP4
   Beh8YVHJeXSIipNRU+NhEGh9rzNQnd4zd7RIGL79a4LA5hjzC+7MWux6w
   DkxUJsanha5g6WyPgb/pjlXw1MRqxNO9XKMvnUxo7R4xUhRE3tArQWE+V
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10726"; a="383220145"
X-IronPort-AV: E=Sophos;i="6.00,204,1681196400"; 
   d="scan'208";a="383220145"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2023 08:58:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10726"; a="739562346"
X-IronPort-AV: E=Sophos;i="6.00,204,1681196400"; 
   d="scan'208";a="739562346"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.175])
  by orsmga001.jf.intel.com with ESMTP; 30 May 2023 08:58:13 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Karthikeyan Gopal <karthikeyan.gopal@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH] crypto: qat - set deprecated capabilities as reserved
Date:   Tue, 30 May 2023 16:58:11 +0100
Message-Id: <20230530155811.6554-1-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Karthikeyan Gopal <karthikeyan.gopal@intel.com>

The LZS and RAND features are no longer available on QAT.
Remove the definition of bit 6 (LZS) and bit 7 (RAND) in the enum that
represents the capabilities and replace them with a comment mentioning
that those bits are reserved.
Those bits shall not be used in future.

Signed-off-by: Karthikeyan Gopal <karthikeyan.gopal@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/intel/qat/qat_common/icp_qat_hw.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/icp_qat_hw.h b/drivers/crypto/intel/qat/qat_common/icp_qat_hw.h
index 4042739bb6fa..a65059e56248 100644
--- a/drivers/crypto/intel/qat/qat_common/icp_qat_hw.h
+++ b/drivers/crypto/intel/qat/qat_common/icp_qat_hw.h
@@ -87,8 +87,7 @@ enum icp_qat_capabilities_mask {
 	ICP_ACCEL_CAPABILITIES_AUTHENTICATION = BIT(3),
 	ICP_ACCEL_CAPABILITIES_RESERVED_1 = BIT(4),
 	ICP_ACCEL_CAPABILITIES_COMPRESSION = BIT(5),
-	ICP_ACCEL_CAPABILITIES_LZS_COMPRESSION = BIT(6),
-	ICP_ACCEL_CAPABILITIES_RAND = BIT(7),
+	/* Bits 6-7 are currently reserved */
 	ICP_ACCEL_CAPABILITIES_ZUC = BIT(8),
 	ICP_ACCEL_CAPABILITIES_SHA3 = BIT(9),
 	/* Bits 10-11 are currently reserved */
-- 
2.40.1

