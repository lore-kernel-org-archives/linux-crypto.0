Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C88BC433F5
	for <linux-crypto@archiver.kernel.org>; Fri, 24 Dec 2021 11:05:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241734AbhLXLFi (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 24 Dec 2021 06:05:38 -0500
Received: from mga07.intel.com ([134.134.136.100]:21447 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241589AbhLXLFi (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 24 Dec 2021 06:05:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640343938; x=1671879938;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=/Tn4D2mdY+/zk7TMly4syNLb/qO9CFgsbAPMlZ+PJuo=;
  b=JgVVTKRBXlJsMo2Hzkag7wUoNGYznnnZ7LePZcEBhKunDoMyU+SE+1SX
   6yLAs00WcIcXiyzTTLhMGhdhYDJdkXltKWam9FA+1HxaqwTOAbPgcl8Pr
   pBIhP4m+MLFKJnVVLLY0YcUwmIuxV6R5At5YgCXcOszV+O0yGRmiJcTRP
   mDmXmqlERRbfrLeJmAlr/dOQvmqx+fuVT688AmjG8WQTb6eApn6PxKhKG
   Vjv0/RwMdU5zsQNp0pRqt2XVGQZEKz9VC0+hrAN8KmlpFZtcX5rU89IoE
   BMtIx+c4GjBh3zLhECyqK0Upqz5mus3X3CxyQJxRbY8/8Ck6pQE93wVsT
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10207"; a="304334489"
X-IronPort-AV: E=Sophos;i="5.88,232,1635231600"; 
   d="scan'208";a="304334489"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Dec 2021 03:05:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,232,1635231600"; 
   d="scan'208";a="685645379"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.76])
  by orsmga005.jf.intel.com with ESMTP; 24 Dec 2021 03:05:36 -0800
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Adam Guerin <adam.guerin@intel.com>,
        Marco Chiappero <marco.chiappero@intel.com>
Subject: [PATCH] crypto: qat - fix definition of ring reset results
Date:   Fri, 24 Dec 2021 11:05:32 +0000
Message-Id: <20211224110532.247754-1-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The ring reset result values are defined starting from 0x1 instead of 0.
This causes out-of-tree drivers that support this message to understand
that a ring reset failed even if the operation was successful.

Fix by starting the definition of ring reset result values from 0.

Fixes: 0bba03ce9739 ("crypto: qat - add PFVF support to enable the reset of ring pairs")
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reported-by: Adam Guerin <adam.guerin@intel.com>
Reviewed-by: Marco Chiappero <marco.chiappero@intel.com>
---
 drivers/crypto/qat/qat_common/adf_pfvf_msg.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_pfvf_msg.h b/drivers/crypto/qat/qat_common/adf_pfvf_msg.h
index 86b0e7baa4d3..9c37a2661392 100644
--- a/drivers/crypto/qat/qat_common/adf_pfvf_msg.h
+++ b/drivers/crypto/qat/qat_common/adf_pfvf_msg.h
@@ -139,10 +139,10 @@ enum pf2vf_compat_response {
 };
 
 enum ring_reset_result {
-	RPRESET_SUCCESS				= 0x01,
-	RPRESET_NOT_SUPPORTED			= 0x02,
-	RPRESET_INVAL_BANK			= 0x03,
-	RPRESET_TIMEOUT				= 0x04,
+	RPRESET_SUCCESS				= 0x00,
+	RPRESET_NOT_SUPPORTED			= 0x01,
+	RPRESET_INVAL_BANK			= 0x02,
+	RPRESET_TIMEOUT				= 0x03,
 };
 
 #define ADF_VF2PF_RNG_RESET_RP_MASK		GENMASK(1, 0)
-- 
2.33.1

