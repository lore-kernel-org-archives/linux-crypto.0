Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09923E7B5E1
	for <linux-crypto@archiver.kernel.org>; Wed,  4 Oct 2023 10:11:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242095AbjJDKLO (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 4 Oct 2023 06:11:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241906AbjJDKLM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 4 Oct 2023 06:11:12 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D210EA9
        for <linux-crypto@vger.kernel.org>; Wed,  4 Oct 2023 03:11:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696414270; x=1727950270;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nOpnjYO8cnHiXkmLkpb3bPewKEwhboyBzwsk8IQ/mok=;
  b=VyDU9vhGy2FDRYQRswSnRwoqaCGdlkVaztMr8FpBq1MoMNYQ+nmUZMQ3
   n1ATWJMJ4ggO1oM1CwL++rCua0fmbr5hjtuQRBCwPfMLJh/EJBedyXlk5
   i60e8dOiVSJVuaeJGZIBf/vPEm0tFAfVZXv/+LHBwxr2jcQbED2+nXT3l
   7P1WdSke9uLlN+TrSZHuDa76tQ/rUWFR5H92nLN3126DsUnTlL4DfvDOG
   pHnPiBV8ZOHM16H/UBmEKGEQm1rQYl3lQkvcQi+DWiw+HoAH3AYADJT+S
   12PzQxTf6mXCSCXyDtkxYLXpBSLVv5yNPzy4vTpk8PS+sE9VepM5vJnZx
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10852"; a="414036979"
X-IronPort-AV: E=Sophos;i="6.03,199,1694761200"; 
   d="scan'208";a="414036979"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Oct 2023 03:11:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10852"; a="894873110"
X-IronPort-AV: E=Sophos;i="6.03,199,1694761200"; 
   d="scan'208";a="894873110"
Received: from r007s007_zp31l10c01.deacluster.intel.com (HELO fedora.deacluster.intel.com) ([10.219.171.169])
  by fmsmga001.fm.intel.com with ESMTP; 04 Oct 2023 03:09:33 -0700
From:   Lucas Segarra Fernandez <lucas.segarra.fernandez@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Lucas Segarra Fernandez <lucas.segarra.fernandez@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH v6 1/2] crypto: qat - refactor included headers
Date:   Wed,  4 Oct 2023 12:09:19 +0200
Message-ID: <20231004100920.33705-2-lucas.segarra.fernandez@intel.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231004100920.33705-1-lucas.segarra.fernandez@intel.com>
References: <20231004100920.33705-1-lucas.segarra.fernandez@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Include kernel.h for GENMASK(), kstrtobool() and types.

Add forward declaration for struct adf_accel_dev. Remove unneeded
include.

This change doesn't introduce any function change.

Signed-off-by: Lucas Segarra Fernandez <lucas.segarra.fernandez@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/intel/qat/qat_common/adf_gen4_pm.c | 2 ++
 drivers/crypto/intel/qat/qat_common/adf_gen4_pm.h | 4 +++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_gen4_pm.c b/drivers/crypto/intel/qat/qat_common/adf_gen4_pm.c
index 34c6cd8e27c0..b0e60471163c 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_gen4_pm.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_gen4_pm.c
@@ -2,6 +2,8 @@
 /* Copyright(c) 2022 Intel Corporation */
 #include <linux/bitfield.h>
 #include <linux/iopoll.h>
+#include <linux/kernel.h>
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

