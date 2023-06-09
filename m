Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CF82C7EE2E
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Jun 2023 19:43:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231909AbjFITnG (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 9 Jun 2023 15:43:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbjFITnG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Jun 2023 15:43:06 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5232E3590
        for <linux-crypto@vger.kernel.org>; Fri,  9 Jun 2023 12:43:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686339785; x=1717875785;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=5SPkKuxfdogB9ctfKopDJdpVKfbs8Lhl1I7Yqq+oaiY=;
  b=GJUOjjwInmBEKytiyWQbjhCejmtH17LCNHr08Zi6NOVl5IYiJBQbGwpU
   LxfQjgBn3v94VEHSVglE2T6gDn/9/FTC72BQ4NPTj2EES1IdRbluMzwd3
   jZ0LkJgD+Z7kbICjUnwRGpYzK8kHIs/4MIlZi16jPC5okm1LAm4U5fzD0
   HBJqUCxdkwn3npfCM2rSnONLAQgl8q5Jg8Hg9nmEB/zgwqK+4f/4BNVxq
   tW6bgyqvajGf11Iww3XtI9cotSSakPgP2+S3zdFvTWxfr7l69pUpYMhS5
   p9nv69fLD+r9uGKIeyT5Xf6X61IOIboKcCaK99yXGEEcQKF9jRqnLBtFt
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10736"; a="423555393"
X-IronPort-AV: E=Sophos;i="6.00,230,1681196400"; 
   d="scan'208";a="423555393"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2023 12:42:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10736"; a="713625776"
X-IronPort-AV: E=Sophos;i="6.00,230,1681196400"; 
   d="scan'208";a="713625776"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.175])
  by fmsmga007.fm.intel.com with ESMTP; 09 Jun 2023 12:42:49 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Damian Muszynski <damian.muszynski@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH] crypto: qat - do not export adf_init_admin_pm()
Date:   Fri,  9 Jun 2023 20:42:46 +0100
Message-Id: <20230609194246.12724-1-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The function adf_init_admin_pm() is not used outside of the intel_qat
module.
Do not export it.

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Damian Muszynski <damian.muszynski@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/crypto/intel/qat/qat_common/adf_admin.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_admin.c b/drivers/crypto/intel/qat/qat_common/adf_admin.c
index 3b6184c35081..118775ee02f2 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_admin.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_admin.c
@@ -286,7 +286,6 @@ int adf_init_admin_pm(struct adf_accel_dev *accel_dev, u32 idle_delay)
 
 	return adf_send_admin(accel_dev, &req, &resp, ae_mask);
 }
-EXPORT_SYMBOL_GPL(adf_init_admin_pm);
 
 int adf_init_admin_comms(struct adf_accel_dev *accel_dev)
 {
-- 
2.40.1

