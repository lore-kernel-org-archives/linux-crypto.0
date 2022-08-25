Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9FB6C28D13
	for <linux-crypto@archiver.kernel.org>; Thu, 25 Aug 2022 10:32:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240440AbiHYKcc (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 25 Aug 2022 06:32:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237172AbiHYKcb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 25 Aug 2022 06:32:31 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 758A08B985
        for <linux-crypto@vger.kernel.org>; Thu, 25 Aug 2022 03:32:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661423550; x=1692959550;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=YFMKL3A9FZiSSZl4SwTSLPicEgXkkv+e+Gw6iS1mfWk=;
  b=kUFLbUIMKJkL3/Jcce5790BET/bMIas9RYqSp8SRqjEswj5GVKjY1/jT
   XqdrcHuQtw+0am1pVXtKDPpvNDUxPHC0m3Uk3rlUSTMHNjihfNc/KQNkc
   oFBnuWGS0HHEJJKifzQc/6R7iel5ZkL6wyILfI3CBY/vDzZ+gv844rt/J
   7o/AmyonbZbtY5ZirWa1xlLb0N0O36ISzv4PHb9W2BE1l2l46e4U1e0ab
   wUT5ChslrkHLN3/hliG25lSVLADgYM456/HZwA/fByt5qvxsZ3c6hhWnP
   uKu0hKQsW9HnSjAGGtXTQudIiWm6fkJOVIa/3/kqMMeJwEQPz+K5MzHK5
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10449"; a="358174797"
X-IronPort-AV: E=Sophos;i="5.93,262,1654585200"; 
   d="scan'208";a="358174797"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2022 03:32:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,262,1654585200"; 
   d="scan'208";a="670927529"
Received: from sdpcloudhostegs034.jf.intel.com ([10.165.126.39])
  by fmsmga008.fm.intel.com with ESMTP; 25 Aug 2022 03:32:29 -0700
From:   Lucas Segarra Fernandez <lucas.segarra.fernandez@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Lucas Segarra Fernandez <lucas.segarra.fernandez@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH] crypto: qat - fix default value of WDT timer
Date:   Thu, 25 Aug 2022 12:32:16 +0200
Message-Id: <20220825103216.4948-1-lucas.segarra.fernandez@intel.com>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Organization: Intel Technology Poland sp. z o.o. - ul. Slowackiego 173, 80-298 Gdansk - KRS 101882 - NIP 957-07-52-316
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The QAT HW supports an hardware mechanism to detect an accelerator hang.
The reporting of a hang occurs after a watchdog timer (WDT) expires.

The value of the WDT set previously was too small and was causing false
positives.
Change the default value of the WDT to 0x7000000ULL to avoid this.

Fixes: 1c4d9d5bbb5a ("crypto: qat - enable detection of accelerators hang")
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Lucas Segarra Fernandez <lucas.segarra.fernandez@intel.com>
---
 drivers/crypto/qat/qat_common/adf_gen4_hw_data.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/qat/qat_common/adf_gen4_hw_data.h b/drivers/crypto/qat/qat_common/adf_gen4_hw_data.h
index 43b8f864806b..4fb4b3df5a18 100644
--- a/drivers/crypto/qat/qat_common/adf_gen4_hw_data.h
+++ b/drivers/crypto/qat/qat_common/adf_gen4_hw_data.h
@@ -107,7 +107,7 @@ do { \
  * Timeout is in cycles. Clock speed may vary across products but this
  * value should be a few milli-seconds.
  */
-#define ADF_SSM_WDT_DEFAULT_VALUE	0x200000
+#define ADF_SSM_WDT_DEFAULT_VALUE	0x7000000ULL
 #define ADF_SSM_WDT_PKE_DEFAULT_VALUE	0x8000000
 #define ADF_SSMWDTL_OFFSET		0x54
 #define ADF_SSMWDTH_OFFSET		0x5C

base-commit: 5e2735272b1e6045cb95cf3db863dbcebfa3d771
-- 
2.37.1

