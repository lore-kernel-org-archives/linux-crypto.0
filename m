Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E72A6C001DF
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Oct 2023 10:35:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376831AbjJTKfG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Oct 2023 06:35:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376746AbjJTKfF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Oct 2023 06:35:05 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEC71D46
        for <linux-crypto@vger.kernel.org>; Fri, 20 Oct 2023 03:35:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697798103; x=1729334103;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PHz9bR4d13rT7tF5KACY8luME29AcW5e9bzGR8uupEI=;
  b=i0sqyxm0MSEYKeXWoZYwdgnirny0XtWz5I8RrdDfksnyWKGQwX2VVUPX
   i2CfySvhy0I3xVIMS1RpkxeOAg4UWfYarLk7BIG+UExY6KbI8+hphHsEd
   DUfd6y79Z8+bxxJKkjBA2O9OMWX0pVmKH0TYI9A4JmSj/QTJ5FGhmVS8l
   b3xYwWaDsiFFrKhEGssAuR7YTW7qtzExFNbu8KWkgJYKatYoAutouQgBV
   qrdyYMl+Thf7gf948tfJ97ouFskqKDCWCpiGAt8tJJDmzPZ99DnNR2NB/
   KXlsiwiAk/Ff7Ocr9+8mTMHp0M9Sub6MYrmfTzMna77agNKtlmmzm/LDM
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10868"; a="383686701"
X-IronPort-AV: E=Sophos;i="6.03,238,1694761200"; 
   d="scan'208";a="383686701"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2023 03:35:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10868"; a="792369921"
X-IronPort-AV: E=Sophos;i="6.03,238,1694761200"; 
   d="scan'208";a="792369921"
Received: from fl31ca105gs0706.deacluster.intel.com (HELO fl31ca105gs0706..) ([10.45.133.167])
  by orsmga001.jf.intel.com with ESMTP; 20 Oct 2023 03:35:02 -0700
From:   Shashank Gupta <shashank.gupta@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Shashank Gupta <shashank.gupta@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Tero Kristo <tero.kristo@linux.intel.com>
Subject: [PATCH 2/9] crypto: qat - add reporting of correctable errors for QAT GEN4
Date:   Fri, 20 Oct 2023 11:32:46 +0100
Message-ID: <20231020103431.230671-3-shashank.gupta@intel.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231020103431.230671-1-shashank.gupta@intel.com>
References: <20231020103431.230671-1-shashank.gupta@intel.com>
MIME-Version: 1.0
Organization: Intel Technology Poland sp. z o.o. - ul. Slowackiego 173, 80-298 Gdansk - KRS 101882 - NIP 957-07-52-316
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add logic to detect and report correctable errors in QAT GEN4
devices.
This includes (1) enabling, disabling and handling error reported
through the ERRSOU0 register and (2) logic to log the errors
in the system log.

Signed-off-by: Shashank Gupta <shashank.gupta@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Tero Kristo <tero.kristo@linux.intel.com>
---
 .../intel/qat/qat_common/adf_gen4_ras.c       | 64 ++++++++++++++++++-
 .../intel/qat/qat_common/adf_gen4_ras.h       | 11 ++++
 2 files changed, 74 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_gen4_ras.c b/drivers/crypto/intel/qat/qat_common/adf_gen4_ras.c
index 0bf243a51527..4fbaadbe480e 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_gen4_ras.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_gen4_ras.c
@@ -1,20 +1,82 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /* Copyright(c) 2023 Intel Corporation */
 #include "adf_common_drv.h"
+#include "adf_gen4_hw_data.h"
 #include "adf_gen4_ras.h"
 
+static void enable_errsou_reporting(void __iomem *csr)
+{
+	/* Enable correctable error reporting in ERRSOU0 */
+	ADF_CSR_WR(csr, ADF_GEN4_ERRMSK0, 0);
+}
+
+static void disable_errsou_reporting(void __iomem *csr)
+{
+	/* Disable correctable error reporting in ERRSOU0 */
+	ADF_CSR_WR(csr, ADF_GEN4_ERRMSK0, ADF_GEN4_ERRSOU0_BIT);
+}
+
+static void enable_ae_error_reporting(struct adf_accel_dev *accel_dev,
+				      void __iomem *csr)
+{
+	u32 ae_mask = GET_HW_DATA(accel_dev)->ae_mask;
+
+	/* Enable Acceleration Engine correctable error reporting */
+	ADF_CSR_WR(csr, ADF_GEN4_HIAECORERRLOGENABLE_CPP0, ae_mask);
+}
+
+static void disable_ae_error_reporting(void __iomem *csr)
+{
+	/* Disable Acceleration Engine correctable error reporting */
+	ADF_CSR_WR(csr, ADF_GEN4_HIAECORERRLOGENABLE_CPP0, 0);
+}
+
 static void adf_gen4_enable_ras(struct adf_accel_dev *accel_dev)
 {
+	void __iomem *csr = adf_get_pmisc_base(accel_dev);
+
+	enable_errsou_reporting(csr);
+	enable_ae_error_reporting(accel_dev, csr);
 }
 
 static void adf_gen4_disable_ras(struct adf_accel_dev *accel_dev)
 {
+	void __iomem *csr = adf_get_pmisc_base(accel_dev);
+
+	disable_errsou_reporting(csr);
+	disable_ae_error_reporting(csr);
+}
+
+static void adf_gen4_process_errsou0(struct adf_accel_dev *accel_dev,
+				     void __iomem *csr)
+{
+	u32 aecorrerr = ADF_CSR_RD(csr, ADF_GEN4_HIAECORERRLOG_CPP0);
+
+	aecorrerr &= GET_HW_DATA(accel_dev)->ae_mask;
+
+	dev_warn(&GET_DEV(accel_dev),
+		 "Correctable error detected in AE: 0x%x\n",
+		 aecorrerr);
+
+	/* Clear interrupt from ERRSOU0 */
+	ADF_CSR_WR(csr, ADF_GEN4_HIAECORERRLOG_CPP0, aecorrerr);
 }
 
 static bool adf_gen4_handle_interrupt(struct adf_accel_dev *accel_dev,
 				      bool *reset_required)
 {
-	return false;
+	void __iomem *csr = adf_get_pmisc_base(accel_dev);
+	u32 errsou = ADF_CSR_RD(csr, ADF_GEN4_ERRSOU0);
+	bool handled = false;
+
+	*reset_required = false;
+
+	if (errsou & ADF_GEN4_ERRSOU0_BIT) {
+		adf_gen4_process_errsou0(accel_dev, csr);
+		handled = true;
+	}
+
+	return handled;
 }
 
 void adf_gen4_init_ras_ops(struct adf_ras_ops *ras_ops)
diff --git a/drivers/crypto/intel/qat/qat_common/adf_gen4_ras.h b/drivers/crypto/intel/qat/qat_common/adf_gen4_ras.h
index 2765d3529c0d..e6c4dfbb2389 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_gen4_ras.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_gen4_ras.h
@@ -3,8 +3,19 @@
 #ifndef ADF_GEN4_RAS_H_
 #define ADF_GEN4_RAS_H_
 
+#include <linux/bits.h>
+
 struct adf_ras_ops;
 
+/* ERRSOU0 Correctable error mask*/
+#define ADF_GEN4_ERRSOU0_BIT				BIT(0)
+
+/* HI AE Correctable error log */
+#define ADF_GEN4_HIAECORERRLOG_CPP0			0x41A308
+
+/* HI AE Correctable error log enable */
+#define ADF_GEN4_HIAECORERRLOGENABLE_CPP0		0x41A318
+
 void adf_gen4_init_ras_ops(struct adf_ras_ops *ras_ops);
 
 #endif /* ADF_GEN4_RAS_H_ */
-- 
2.41.0

