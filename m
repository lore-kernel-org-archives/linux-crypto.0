Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EDB7EE57FA
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Sep 2023 11:18:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242806AbjIHLSG (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 8 Sep 2023 07:18:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236689AbjIHLSE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 8 Sep 2023 07:18:04 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED78B1BF6
        for <linux-crypto@vger.kernel.org>; Fri,  8 Sep 2023 04:18:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694171880; x=1725707880;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YoXWuaYmchbnKqdrpSHoQ3RHqPs7CPqcnrm4OomnS60=;
  b=Gok26rv/FZLVHKbAGF8I99d9RtfJ6M3QfpAUhmbzQYZgx1OIgvT0V4KO
   O5kt6fcu6hwGEfL/CVJH//cuKHncA/NGD+/rSVE2hLsYSOXjUDZ8hbryU
   BfVgU6RQ37zYeRhevklcDK3lutHyPvr1afwOfFUftu9/9MTi1HiJt4+vr
   T86gvgTQB8uunj9L6sJmoSyCzeRHf9zMqB5+0ApJs4XzdbHf6OiajZJsw
   A4L3eUHuXT+NbzC99xqh6kKhxX/YBYNeacsiOxFKrjAvOgjsINaAHHIJ/
   rp7gaJgIDUIsjH4FhG5kP6vs+gXCZuPQGUdhqDDF8wxDhD2Q9l4kOWGHF
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10826"; a="463998508"
X-IronPort-AV: E=Sophos;i="6.02,236,1688454000"; 
   d="scan'208";a="463998508"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2023 04:18:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10826"; a="777533222"
X-IronPort-AV: E=Sophos;i="6.02,236,1688454000"; 
   d="scan'208";a="777533222"
Received: from r007s007_zp31l10c01.deacluster.intel.com (HELO fedora.deacluster.intel.com) ([10.219.171.169])
  by orsmga001.jf.intel.com with ESMTP; 08 Sep 2023 04:17:59 -0700
From:   Lucas Segarra Fernandez <lucas.segarra.fernandez@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Lucas Segarra Fernandez <lucas.segarra.fernandez@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: [PATCH v3 1/2] crypto: qat - refactor included headers
Date:   Fri,  8 Sep 2023 13:16:06 +0200
Message-ID: <20230908111625.64762-2-lucas.segarra.fernandez@intel.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230908111625.64762-1-lucas.segarra.fernandez@intel.com>
References: <20230908111625.64762-1-lucas.segarra.fernandez@intel.com>
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

