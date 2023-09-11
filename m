Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DE66CA0EC7
	for <linux-crypto@archiver.kernel.org>; Mon, 11 Sep 2023 21:56:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353858AbjIKVvM (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 11 Sep 2023 17:51:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236332AbjIKKVP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 11 Sep 2023 06:21:15 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3254D1AB
        for <linux-crypto@vger.kernel.org>; Mon, 11 Sep 2023 03:21:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694427671; x=1725963671;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YoXWuaYmchbnKqdrpSHoQ3RHqPs7CPqcnrm4OomnS60=;
  b=Zp5shK161JNN0yLV9x6CeoKBakRTmekHQRhw7ZySFhS9e0d3Kj0clkb7
   82Y3OivnJqDiF1AU2tLigbLqCHWJyY65TULgxPdhx8pKgGMLiMpKLi70S
   9wyJvxaw+7Om8txzoQzsgC3UCXNGMBQ3HrmIHxdNnWwwwJesQxew29c/m
   z3LTxUyoU95uUo1ZkL5TyAQvLjdq96j5vzxK6ACQXYE9JdLTrJMyXaC/7
   1NbSvPGOqTXybeLJsGG9X8/hTrmJlCLcohUlr303QhO2jmTEPoQ04vN7W
   Lo2gY/fp17pBCRakKVFke/6OnrBWNYpbczTaJIZoWj0be3knkz0vmyPLP
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10829"; a="409013526"
X-IronPort-AV: E=Sophos;i="6.02,243,1688454000"; 
   d="scan'208";a="409013526"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2023 03:21:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10829"; a="772533462"
X-IronPort-AV: E=Sophos;i="6.02,243,1688454000"; 
   d="scan'208";a="772533462"
Received: from r007s007_zp31l10c01.deacluster.intel.com (HELO fedora.deacluster.intel.com) ([10.219.171.169])
  by orsmga008.jf.intel.com with ESMTP; 11 Sep 2023 03:21:09 -0700
From:   Lucas Segarra Fernandez <lucas.segarra.fernandez@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Lucas Segarra Fernandez <lucas.segarra.fernandez@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: [PATCH v4 1/2] crypto: qat - refactor included headers
Date:   Mon, 11 Sep 2023 12:19:38 +0200
Message-ID: <20230911101939.86140-2-lucas.segarra.fernandez@intel.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230911101939.86140-1-lucas.segarra.fernandez@intel.com>
References: <20230911101939.86140-1-lucas.segarra.fernandez@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Include missing headers for GENMASK(), kstrtobool() and types.

Add forward declaration for struct adf_accel_dev. Remove unneeded
include.

This change doesn't introduce any function change.

Signed-off-by: Lucas Segarra Fernandez <lucas.segarra.fernandez@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
---
 drivers/crypto/intel/qat/qat_common/adf_gen4_pm.c | 3 +++
 drivers/crypto/intel/qat/qat_common/adf_gen4_pm.h | 4 +++-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_gen4_pm.c b/drivers/crypto/intel/qat/qat_common/adf_gen4_pm.c
index 34c6cd8e27c0..3bde8759c2a2 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_gen4_pm.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_gen4_pm.c
@@ -2,6 +2,9 @@
 /* Copyright(c) 2022 Intel Corporation */
 #include <linux/bitfield.h>
 #include <linux/iopoll.h>
+#include <linux/kstrtox.h>
+#include <linux/types.h>
+
 #include "adf_accel_devices.h"
 #include "adf_common_drv.h"
 #include "adf_gen4_pm.h"
diff --git a/drivers/crypto/intel/qat/qat_common/adf_gen4_pm.h b/drivers/crypto/intel/qat/qat_common/adf_gen4_pm.h
index c2768762cca3..39d37b352b45 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_gen4_pm.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_gen4_pm.h
@@ -3,7 +3,9 @@
 #ifndef ADF_GEN4_PM_H
 #define ADF_GEN4_PM_H
 
-#include "adf_accel_devices.h"
+#include <linux/bits.h>
+
+struct adf_accel_dev;
 
 /* Power management registers */
 #define ADF_GEN4_PM_HOST_MSG (0x50A01C)
-- 
2.41.0

