Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29A4ACDB474
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Oct 2023 10:35:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376775AbjJTKfO (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Oct 2023 06:35:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376802AbjJTKfH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Oct 2023 06:35:07 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44F2BD53
        for <linux-crypto@vger.kernel.org>; Fri, 20 Oct 2023 03:35:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697798105; x=1729334105;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Um+NXEdNGpBsL0CiYYVnDLTaJwkQ9Apcxd2HZFthMTs=;
  b=e7a8U3pov0kYZgJXhhe9sIJEb5uTXS3aYZi5+jsRdlYTLF1tW54g8D0E
   GdQnk83JVB5CUJOguG1rysGIE7htMbNCZXL4tseZXEPpiX23k3HyXbG5E
   eKzvNZ667YoTca4Fc/ZDUb/Ha4n2VncDMQu9j+FDv6IWjQ0sl9F0rlJGw
   fz5H8AoiGAe3ZV4o2ecSDUxSvR/yJyqOcCOfRj5ftnZnUmQc5XolfIPj8
   H3A2hTlhBshTgfe6GqR7I+ouwP1J8bS8GLK7ymdel0E31ipmH/AvJP693
   rF+bXtrltNggfjcWKLyKq4x/jGb1BI1fcpDGBHKTuHnaeiz8qU6mcwB+Y
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10868"; a="383686709"
X-IronPort-AV: E=Sophos;i="6.03,238,1694761200"; 
   d="scan'208";a="383686709"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2023 03:35:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10868"; a="792369930"
X-IronPort-AV: E=Sophos;i="6.03,238,1694761200"; 
   d="scan'208";a="792369930"
Received: from fl31ca105gs0706.deacluster.intel.com (HELO fl31ca105gs0706..) ([10.45.133.167])
  by orsmga001.jf.intel.com with ESMTP; 20 Oct 2023 03:35:02 -0700
From:   Shashank Gupta <shashank.gupta@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Shashank Gupta <shashank.gupta@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Tero Kristo <tero.kristo@linux.intel.com>
Subject: [PATCH 5/9] crypto: qat - add handling of compression related errors for QAT GEN4
Date:   Fri, 20 Oct 2023 11:32:49 +0100
Message-ID: <20231020103431.230671-6-shashank.gupta@intel.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231020103431.230671-1-shashank.gupta@intel.com>
References: <20231020103431.230671-1-shashank.gupta@intel.com>
MIME-Version: 1.0
Organization: Intel Technology Poland sp. z o.o. - ul. Slowackiego 173, 80-298 Gdansk - KRS 101882 - NIP 957-07-52-316
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add logic to detect, report and handle correctable and uncorrectable
errors related to the compression hardware.
These are detected through the EXPRPSSMXLT, EXPRPSSMCPR and EXPRPSSMDCPR
registers.

Signed-off-by: Shashank Gupta <shashank.gupta@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Tero Kristo <tero.kristo@linux.intel.com>
---
 .../intel/qat/qat_common/adf_gen4_ras.c       | 76 ++++++++++++++++++-
 .../intel/qat/qat_common/adf_gen4_ras.h       | 76 +++++++++++++++++++
 2 files changed, 151 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_gen4_ras.c b/drivers/crypto/intel/qat/qat_common/adf_gen4_ras.c
index 877abed683d8..285b755e13be 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_gen4_ras.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_gen4_ras.c
@@ -996,13 +996,87 @@ static bool adf_handle_iaintstatssm(struct adf_accel_dev *accel_dev,
 	return reset_required;
 }
 
+static bool adf_handle_exprpssmcmpr(struct adf_accel_dev *accel_dev,
+				    void __iomem *csr)
+{
+	u32 reg = ADF_CSR_RD(csr, ADF_GEN4_EXPRPSSMCPR);
+
+	reg &= ADF_GEN4_EXPRPSSMCPR_UNCERR_BITMASK;
+	if (!reg)
+		return false;
+
+	dev_err(&GET_DEV(accel_dev),
+		"Uncorrectable error exception in SSM CMP: 0x%x", reg);
+
+	ADF_CSR_WR(csr, ADF_GEN4_EXPRPSSMCPR, reg);
+
+	return false;
+}
+
+static bool adf_handle_exprpssmxlt(struct adf_accel_dev *accel_dev,
+				   void __iomem *csr)
+{
+	u32 reg = ADF_CSR_RD(csr, ADF_GEN4_EXPRPSSMXLT);
+
+	reg &= ADF_GEN4_EXPRPSSMXLT_UNCERR_BITMASK |
+	       ADF_GEN4_EXPRPSSMXLT_CERR_BIT;
+	if (!reg)
+		return false;
+
+	if (reg & ADF_GEN4_EXPRPSSMXLT_UNCERR_BITMASK)
+		dev_err(&GET_DEV(accel_dev),
+			"Uncorrectable error exception in SSM XLT: 0x%x", reg);
+
+	if (reg & ADF_GEN4_EXPRPSSMXLT_CERR_BIT)
+		dev_warn(&GET_DEV(accel_dev),
+			 "Correctable error exception in SSM XLT: 0x%x", reg);
+
+	ADF_CSR_WR(csr, ADF_GEN4_EXPRPSSMXLT, reg);
+
+	return false;
+}
+
+static bool adf_handle_exprpssmdcpr(struct adf_accel_dev *accel_dev,
+				    void __iomem *csr)
+{
+	u32 reg;
+	int i;
+
+	for (i = 0; i < ADF_GEN4_DCPR_SLICES_NUM; i++) {
+		reg = ADF_CSR_RD(csr, ADF_GEN4_EXPRPSSMDCPR(i));
+		reg &= ADF_GEN4_EXPRPSSMDCPR_UNCERR_BITMASK |
+		       ADF_GEN4_EXPRPSSMDCPR_CERR_BITMASK;
+		if (!reg)
+			continue;
+
+		if (reg & ADF_GEN4_EXPRPSSMDCPR_UNCERR_BITMASK)
+			dev_err(&GET_DEV(accel_dev),
+				"Uncorrectable error exception in SSM DCMP: 0x%x", reg);
+
+		if (reg & ADF_GEN4_EXPRPSSMDCPR_CERR_BITMASK)
+			dev_warn(&GET_DEV(accel_dev),
+				 "Correctable error exception in SSM DCMP: 0x%x", reg);
+
+		ADF_CSR_WR(csr, ADF_GEN4_EXPRPSSMDCPR(i), reg);
+	}
+
+	return false;
+}
+
 static bool adf_handle_ssm(struct adf_accel_dev *accel_dev, void __iomem *csr,
 			   u32 errsou)
 {
+	bool reset_required;
+
 	if (!(errsou & ADF_GEN4_ERRSOU2_SSM_ERR_BIT))
 		return false;
 
-	return adf_handle_iaintstatssm(accel_dev, csr);
+	reset_required = adf_handle_iaintstatssm(accel_dev, csr);
+	reset_required |= adf_handle_exprpssmcmpr(accel_dev, csr);
+	reset_required |= adf_handle_exprpssmxlt(accel_dev, csr);
+	reset_required |= adf_handle_exprpssmdcpr(accel_dev, csr);
+
+	return reset_required;
 }
 
 static bool adf_handle_cpp_cfc_err(struct adf_accel_dev *accel_dev,
diff --git a/drivers/crypto/intel/qat/qat_common/adf_gen4_ras.h b/drivers/crypto/intel/qat/qat_common/adf_gen4_ras.h
index 65c1b7925444..e3583c3ed827 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_gen4_ras.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_gen4_ras.h
@@ -523,6 +523,82 @@ struct adf_ras_ops;
 #define ADF_GEN4_CPP_CFC_ERR_PPID_LO			0x640C0C
 #define ADF_GEN4_CPP_CFC_ERR_PPID_HI			0x640C10
 
+/* Exception reporting in QAT SSM CMP */
+#define ADF_GEN4_EXPRPSSMCPR				0x2000
+
+/*
+ * Uncorrectable error mask in EXPRPSSMCPR
+ * BIT(2) - Hard fatal error
+ * BIT(16) - Parity error detected in CPR Push FIFO
+ * BIT(17) - Parity error detected in CPR Pull FIFO
+ * BIT(18) - Parity error detected in CPR Hash Table
+ * BIT(19) - Parity error detected in CPR History Buffer Copy 0
+ * BIT(20) - Parity error detected in CPR History Buffer Copy 1
+ * BIT(21) - Parity error detected in CPR History Buffer Copy 2
+ * BIT(22) - Parity error detected in CPR History Buffer Copy 3
+ * BIT(23) - Parity error detected in CPR History Buffer Copy 4
+ * BIT(24) - Parity error detected in CPR History Buffer Copy 5
+ * BIT(25) - Parity error detected in CPR History Buffer Copy 6
+ * BIT(26) - Parity error detected in CPR History Buffer Copy 7
+ */
+#define ADF_GEN4_EXPRPSSMCPR_UNCERR_BITMASK \
+	(BIT(2) | BIT(16) | BIT(17) | BIT(18) | BIT(19) | BIT(20) | \
+	 BIT(21) | BIT(22) | BIT(23) | BIT(24) | BIT(25) | BIT(26))
+
+/* Exception reporting in QAT SSM XLT */
+#define ADF_GEN4_EXPRPSSMXLT				0xA000
+
+/*
+ * Uncorrectable error mask in EXPRPSSMXLT
+ * BIT(2) - If set, an Uncorrectable Error event occurred
+ * BIT(16) - Parity error detected in XLT Push FIFO
+ * BIT(17) - Parity error detected in XLT Pull FIFO
+ * BIT(18) - Parity error detected in XLT HCTB0
+ * BIT(19) - Parity error detected in XLT HCTB1
+ * BIT(20) - Parity error detected in XLT HCTB2
+ * BIT(21) - Parity error detected in XLT HCTB3
+ * BIT(22) - Parity error detected in XLT CBCL
+ * BIT(23) - Parity error detected in XLT LITPTR
+ */
+#define ADF_GEN4_EXPRPSSMXLT_UNCERR_BITMASK \
+	(BIT(2) | BIT(16) | BIT(17) | BIT(18) | BIT(19) | BIT(20) | BIT(21) | \
+	 BIT(22) | BIT(23))
+
+/*
+ * Correctable error mask in EXPRPSSMXLT
+ * BIT(3) - Correctable error event occurred.
+ */
+#define ADF_GEN4_EXPRPSSMXLT_CERR_BIT			BIT(3)
+
+/* Exception reporting in QAT SSM DCMP */
+#define ADF_GEN4_EXPRPSSMDCPR(_n_) (0x12000 + (_n_) * 0x80)
+
+/*
+ * Uncorrectable error mask in EXPRPSSMDCPR
+ * BIT(2) - Even hard fatal error
+ * BIT(4) - Odd hard fatal error
+ * BIT(6) - decode soft error
+ * BIT(16) - Parity error detected in CPR Push FIFO
+ * BIT(17) - Parity error detected in CPR Pull FIFO
+ * BIT(18) - Parity error detected in the Input Buffer
+ * BIT(19) - symbuf0parerr
+ *	     Parity error detected in CPR Push FIFO
+ * BIT(20) - symbuf1parerr
+ *	     Parity error detected in CPR Push FIFO
+ */
+#define ADF_GEN4_EXPRPSSMDCPR_UNCERR_BITMASK \
+	(BIT(2) | BIT(4) | BIT(6) | BIT(16) | BIT(17) | \
+	 BIT(18) | BIT(19) | BIT(20))
+
+/*
+ * Correctable error mask in EXPRPSSMDCPR
+ * BIT(3) - Even ecc correctable error
+ * BIT(5) - Odd ecc correctable error
+ */
+#define ADF_GEN4_EXPRPSSMDCPR_CERR_BITMASK		(BIT(3) | BIT(5))
+
+#define ADF_GEN4_DCPR_SLICES_NUM			3
+
 /* Command Parity error detected on IOSFP Command to QAT */
 #define ADF_GEN4_RIMISCSTS_BIT				BIT(0)
 
-- 
2.41.0

