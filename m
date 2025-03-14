Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08A8C28DB3
	for <linux-crypto@vger.kernel.org>; Fri, 14 Mar 2025 15:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741964992; cv=none; b=HAgnKvzIBnwUiGln9Peq9Hgu0Zd4GfbYN5iUphEOL49TJ49va2J61cs/eNyiUtfZQbhZRPaDoCMdjR74sC7xHFZNJE99MXq3PgHxa3PopUpX4q98nIRe4JLpIdZzNQPU5waxlR3vNykArITKc4IyGbyXuKtr1xdh5ey+IR67qBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741964992; c=relaxed/simple;
	bh=ixcoz+LM35EJ5nCQYJJz9a6BLDUKaeNeB/3QG3/WIcg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DhzdlJIJ73KFa+Hiper7Kl71o/1lr377/zdbXXIu4rI+XIM6tos/HTJc58a/hKWu72KO8E2AFpRZyFxQ8Ew+fxJEFuWqm6ooCVoZf/80diyN5g7IBcs6A7pi02+0DkLptyDObjEi54nzG9Pef+kqJT+B0M6vQ3ikvgGpF+03NHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BEEtB7sP; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BEEtB7sP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741964990; x=1773500990;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=ixcoz+LM35EJ5nCQYJJz9a6BLDUKaeNeB/3QG3/WIcg=;
  b=BEEtB7sPMy59iZeusk54E0T27UBBJpUNm9WG8uhW68RphKPID4pi3ChG
   qDmGZuC0BGRMMZ1nV2kpRWpFY9zqC4w/n21oHgn4ey0x2vPOk0pBoHR1D
   ZP9vxmyX+kdlAaY0slzmb/eIAB85IfKTVjW8MI3bZp/8AafATQIka7Oy3
   sDizG6nbNI8scPZTAT7G2+SNgfDI08GmE3fI0fv9S9CangMYx9huytd2H
   73dSCubvnj9x/duayxTIeXNOmXG+hfKSpZKKPS+PrNqdR1zUkBG/6n9Og
   3WhUMVt7yaNf+OYgHjSWaI5YdFJrLIYwYJ09OepTqFNiMBMysiaXDOBi5
   g==;
X-CSE-ConnectionGUID: Q3/DHvsjREuuqaUZO1whhA==
X-CSE-MsgGUID: f0LHh77iRl6giMMlm4pGaA==
X-IronPort-AV: E=McAfee;i="6700,10204,11373"; a="43027235"
X-IronPort-AV: E=Sophos;i="6.14,246,1736841600"; 
   d="scan'208";a="43027235"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2025 08:09:49 -0700
X-CSE-ConnectionGUID: qZ70fqzoRlOzR9Osgbjh9Q==
X-CSE-MsgGUID: tRDqfemNSZG2EcTiSjipAg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,246,1736841600"; 
   d="scan'208";a="144487635"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.223.204])
  by fmviesa002.fm.intel.com with ESMTP; 14 Mar 2025 08:09:47 -0700
From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	Bairavi Alagappan <bairavix.alagappan@intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH] crypto: qat - remove access to parity register for QAT GEN4
Date: Fri, 14 Mar 2025 15:09:31 +0000
Message-ID: <20250314150943.30404-1-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit

From: Bairavi Alagappan <bairavix.alagappan@intel.com>

The firmware already handles parity errors reported by the accelerators
by clearing them through the corresponding SSMSOFTERRORPARITY register.
To ensure consistent behavior and prevent race conditions between the
driver and firmware, remove the logic that checks the SSMSOFTERRORPARITY
registers.

Additionally, change the return type of the function
adf_handle_rf_parr_err() to void, as it consistently returns false.
Parity errors are recoverable and do not necessitate a device reset.

Fixes: 895f7d532c84 ("crypto: qat - add handling of errors from ERRSOU2 for QAT GEN4")
Signed-off-by: Bairavi Alagappan <bairavix.alagappan@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 .../intel/qat/qat_common/adf_gen4_ras.c       | 57 ++-----------------
 1 file changed, 5 insertions(+), 52 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_gen4_ras.c b/drivers/crypto/intel/qat/qat_common/adf_gen4_ras.c
index bf0ea09faa65..0f7f00a19e7d 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_gen4_ras.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_gen4_ras.c
@@ -1043,63 +1043,16 @@ static bool adf_handle_ssmcpppar_err(struct adf_accel_dev *accel_dev,
 	return reset_required;
 }
 
-static bool adf_handle_rf_parr_err(struct adf_accel_dev *accel_dev,
+static void adf_handle_rf_parr_err(struct adf_accel_dev *accel_dev,
 				   void __iomem *csr, u32 iastatssm)
 {
-	struct adf_dev_err_mask *err_mask = GET_ERR_MASK(accel_dev);
-	u32 reg;
-
 	if (!(iastatssm & ADF_GEN4_IAINTSTATSSM_SSMSOFTERRORPARITY_BIT))
-		return false;
-
-	reg = ADF_CSR_RD(csr, ADF_GEN4_SSMSOFTERRORPARITY_SRC);
-	reg &= ADF_GEN4_SSMSOFTERRORPARITY_SRC_BIT;
-	if (reg) {
-		ADF_RAS_ERR_CTR_INC(accel_dev->ras_errors, ADF_RAS_UNCORR);
-		ADF_CSR_WR(csr, ADF_GEN4_SSMSOFTERRORPARITY_SRC, reg);
-	}
-
-	reg = ADF_CSR_RD(csr, ADF_GEN4_SSMSOFTERRORPARITY_ATH_CPH);
-	reg &= err_mask->parerr_ath_cph_mask;
-	if (reg) {
-		ADF_RAS_ERR_CTR_INC(accel_dev->ras_errors, ADF_RAS_UNCORR);
-		ADF_CSR_WR(csr, ADF_GEN4_SSMSOFTERRORPARITY_ATH_CPH, reg);
-	}
-
-	reg = ADF_CSR_RD(csr, ADF_GEN4_SSMSOFTERRORPARITY_CPR_XLT);
-	reg &= err_mask->parerr_cpr_xlt_mask;
-	if (reg) {
-		ADF_RAS_ERR_CTR_INC(accel_dev->ras_errors, ADF_RAS_UNCORR);
-		ADF_CSR_WR(csr, ADF_GEN4_SSMSOFTERRORPARITY_CPR_XLT, reg);
-	}
-
-	reg = ADF_CSR_RD(csr, ADF_GEN4_SSMSOFTERRORPARITY_DCPR_UCS);
-	reg &= err_mask->parerr_dcpr_ucs_mask;
-	if (reg) {
-		ADF_RAS_ERR_CTR_INC(accel_dev->ras_errors, ADF_RAS_UNCORR);
-		ADF_CSR_WR(csr, ADF_GEN4_SSMSOFTERRORPARITY_DCPR_UCS, reg);
-	}
-
-	reg = ADF_CSR_RD(csr, ADF_GEN4_SSMSOFTERRORPARITY_PKE);
-	reg &= err_mask->parerr_pke_mask;
-	if (reg) {
-		ADF_RAS_ERR_CTR_INC(accel_dev->ras_errors, ADF_RAS_UNCORR);
-		ADF_CSR_WR(csr, ADF_GEN4_SSMSOFTERRORPARITY_PKE, reg);
-	}
-
-	if (err_mask->parerr_wat_wcp_mask) {
-		reg = ADF_CSR_RD(csr, ADF_GEN4_SSMSOFTERRORPARITY_WAT_WCP);
-		reg &= err_mask->parerr_wat_wcp_mask;
-		if (reg) {
-			ADF_RAS_ERR_CTR_INC(accel_dev->ras_errors, ADF_RAS_UNCORR);
-			ADF_CSR_WR(csr, ADF_GEN4_SSMSOFTERRORPARITY_WAT_WCP,
-				   reg);
-		}
-	}
+		return;
 
+	ADF_RAS_ERR_CTR_INC(accel_dev->ras_errors, ADF_RAS_UNCORR);
 	dev_err(&GET_DEV(accel_dev), "Slice ssm soft parity error reported");
 
-	return false;
+	return;
 }
 
 static bool adf_handle_ser_err_ssmsh(struct adf_accel_dev *accel_dev,
@@ -1171,8 +1124,8 @@ static bool adf_handle_iaintstatssm(struct adf_accel_dev *accel_dev,
 	reset_required |= adf_handle_slice_hang_error(accel_dev, csr, iastatssm);
 	reset_required |= adf_handle_spppar_err(accel_dev, csr, iastatssm);
 	reset_required |= adf_handle_ssmcpppar_err(accel_dev, csr, iastatssm);
-	reset_required |= adf_handle_rf_parr_err(accel_dev, csr, iastatssm);
 	reset_required |= adf_handle_ser_err_ssmsh(accel_dev, csr, iastatssm);
+	adf_handle_rf_parr_err(accel_dev, csr, iastatssm);
 
 	ADF_CSR_WR(csr, ADF_GEN4_IAINTSTATSSM, iastatssm);
 

base-commit: d2027f0910322e7f850cec77a7634e7237684b06
-- 
2.48.1

