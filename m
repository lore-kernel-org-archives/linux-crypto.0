Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D07B43F4AA;
	Wed, 16 Sep 2026 07:55:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789545360; cv=none; b=VrWxI3OZTX40K/OrImwx6UO5vBNv3cL/iTPypUwWdtYYi7uno4mMyeSFrPH2CsYzLyev+INq/46sfgsdv2ITShSL24DxNfzLk5mIJQ+D/9OQhs/7PR7qiP62woTR/qSdddFchadkygkdu03AAEBjn+Qerw0hAj3u5j4fU68P76c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789545360; c=relaxed/simple;
	bh=XBBONHfl4IjnRSNasfx5ax9/pFvU396KZ3iIK2ZniTc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bnlr4KZDOfRNQ4kK9G2Aim3l9JL8ELntEgp8LyZdJ2tkc/XVowT0m41Hv2KIly37CEc2g+1rr8TMW1+v++lkEZFa99mvOdp/Vs+TXBs82fRQ17cLa8Kpw/FXiCgWWx+MV0YXhbx9O0taG+9wERCIwczB1/BOvnYx2SxwfiENrZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FgGzJaBj; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FgGzJaBj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789545346; x=1821081346;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=XBBONHfl4IjnRSNasfx5ax9/pFvU396KZ3iIK2ZniTc=;
  b=FgGzJaBjC77prA7Ez6tiv22MRnrCwLW6biLnslC/VMpPIhboae1ouRCP
   U7gy2hiVLuW55aCO8/j7Uv7sR40j3lWbKV1zWXdfcn1z0ftpDriax6Y6e
   QTFrO/xwO+m5GrIQoifAoigBXLJLS/1e8Kv+QYbgpDFY+3BPvU9P1bt9K
   iEZxVX8uE6eoS4+KYj2HA5AwXHEmtjF+n2gSfrkQZSGhaCKB5LtNiaFGW
   w79YYPzTg1iq00jl0kmP8XG2ESZYxaSVuz6GKhKjvgixH/+9fdOhiwebG
   dwO02wH0aNDNiIDr1pufCDNAuM6v1A9YCGAjVz7V3TSdFn15A3UOmORDx
   Q==;
X-CSE-ConnectionGUID: 28HwBOK+ToSAfXzEjA8oSA==
X-CSE-MsgGUID: 4GnQOwFKRl6mtJr9cuRjEg==
X-IronPort-AV: E=McAfee;i="6800,10657,11905"; a="90128060"
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="90128060"
Received: from fmviesa011.fm.intel.com ([10.60.135.151])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2026 00:55:42 -0700
X-CSE-ConnectionGUID: cN0I8x6jQaO/kUIVZ02JUw==
X-CSE-MsgGUID: yPZ5olTpSMefGlUy4ZzjYQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="1491290"
Received: from dmr-bkc.iind.intel.com ([10.49.111.58])
  by fmviesa011.fm.intel.com with ESMTP; 16 Sep 2026 00:55:40 -0700
From: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>,
	stable@vger.kernel.org,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Ahsan Atta <ahsan.atta@intel.com>
Subject: [PATCH] crypto: qat - fix error source for QAT GEN6 transmit interface faults
Date: Wed, 16 Sep 2026 07:55:36 +0000
Message-ID: <20260916075536.1361895-1-suman.kumar.chakraborty@intel.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

TI_CD_PAR_STS faults were being decoded under ERRSOU1, which is
incorrect for QAT GEN6 devices. They are actually raised on ERRSOU3.

Move the handling of TI_CD_PAR_STS faults as part of the ERRSOU3 logic
and split the status bits by their actual source:

 - Bits 0-18 (TI_INT_ERR_DEVHALT) handled when a DEVHALT is signalled
   and are counted once as ADF_RAS_FATAL.
 - Bit 19 (TIMISCSTS) handled separately and counted as ADF_RAS_UNCORR.

Previously, a TI_INT_ERR_DEVHALT fault also incremented ADF_RAS_UNCORR
in addition to ADF_RAS_FATAL. Since a DEVHALT is already fatal, remove
the redundant increment.

Bits 20-25 of TI_CD_PAR_STS are unused/reserved on QAT GEN6. Remove them
from the mask.

Cc: stable@vger.kernel.org
Fixes: 7f3401d0a506 ("crypto: qat - enable RAS support for GEN6 devices")
Signed-off-by: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Ahsan Atta <ahsan.atta@intel.com>
---
 .../intel/qat/qat_common/adf_gen6_ras.c       | 20 +++++++++++++---
 .../intel/qat/qat_common/adf_gen6_ras.h       | 24 ++++++++++---------
 2 files changed, 30 insertions(+), 14 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_gen6_ras.c b/drivers/crypto/intel/qat/qat_common/adf_gen6_ras.c
index 967253082a98..902c4b1a23e3 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_gen6_ras.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_gen6_ras.c
@@ -323,14 +323,26 @@ static void adf_handle_ti_cd_par_sts(struct adf_accel_dev *accel_dev, void __iom
 	u32 ti_cd_par_sts;
 
 	ti_cd_par_sts = ADF_CSR_RD(csr, ADF_GEN6_TI_CD_PAR_STS);
-	ti_cd_par_sts &= ADF_GEN6_TI_CD_PAR_STS_MASK;
+	ti_cd_par_sts &= ADF_GEN6_TI_CD_PAR_STS_TI_INT_ERR_DEVHALT_MASK;
 	if (ti_cd_par_sts) {
 		dev_err(&GET_DEV(accel_dev), "TI CD parity error: %#x\n", ti_cd_par_sts);
-		ADF_RAS_ERR_CTR_INC(accel_dev->ras_errors, ADF_RAS_UNCORR);
 		ADF_CSR_WR(csr, ADF_GEN6_TI_CD_PAR_STS, ti_cd_par_sts);
 	}
 }
 
+static void adf_handle_ti_misc_cd_par_sts(struct adf_accel_dev *accel_dev, void __iomem *csr)
+{
+	u32 ti_misc_cd_par_sts;
+
+	ti_misc_cd_par_sts = ADF_CSR_RD(csr, ADF_GEN6_TI_CD_PAR_STS);
+	ti_misc_cd_par_sts &= ADF_GEN6_TI_CD_PAR_STS_TI_MISC_MASK;
+	if (ti_misc_cd_par_sts) {
+		dev_err(&GET_DEV(accel_dev), "TI MISC CD parity error: %#x\n", ti_misc_cd_par_sts);
+		ADF_RAS_ERR_CTR_INC(accel_dev->ras_errors, ADF_RAS_UNCORR);
+		ADF_CSR_WR(csr, ADF_GEN6_TI_CD_PAR_STS, ti_misc_cd_par_sts);
+	}
+}
+
 static void adf_handle_ti_trnsb_par_sts(struct adf_accel_dev *accel_dev, void __iomem *csr)
 {
 	u32 ti_trnsb_par_sts;
@@ -367,7 +379,6 @@ static void adf_handle_ti_err(struct adf_accel_dev *accel_dev, void __iomem *csr
 	adf_handle_ti_ci_par_sts(accel_dev, csr);
 	adf_handle_ti_pullfub_par_sts(accel_dev, csr);
 	adf_handle_ti_pushfub_par_sts(accel_dev, csr);
-	adf_handle_ti_cd_par_sts(accel_dev, csr);
 	adf_handle_ti_trnsb_par_sts(accel_dev, csr);
 	adf_handle_iosfp_cmd_parerr(accel_dev, csr);
 }
@@ -591,6 +602,8 @@ static void adf_handle_timiscsts(struct adf_accel_dev *accel_dev, void __iomem *
 	if (!(errsou & ADF_GEN6_ERRSOU3_TIMISCSTS_BIT))
 		return;
 
+	adf_handle_ti_misc_cd_par_sts(accel_dev, csr);
+
 	timiscsts = ADF_CSR_RD(csr, ADF_GEN6_TIMISCSTS);
 	if (timiscsts) {
 		dev_err(&GET_DEV(accel_dev), "Fatal error in transmit interface: %#x\n",
@@ -730,6 +743,7 @@ static void adf_handle_ti_int_err_devhalt(struct adf_accel_dev *accel_dev, void
 	if (!(errsou & ADF_GEN6_ERRSOU3_TI_INT_ERR_DEVHALT_BIT))
 		return;
 
+	adf_handle_ti_cd_par_sts(accel_dev, csr);
 	dev_err(&GET_DEV(accel_dev), "DEVHALT due to a TI internal memory error\n");
 	ADF_RAS_ERR_CTR_INC(accel_dev->ras_errors, ADF_RAS_FATAL);
 }
diff --git a/drivers/crypto/intel/qat/qat_common/adf_gen6_ras.h b/drivers/crypto/intel/qat/qat_common/adf_gen6_ras.h
index 66ced271d173..11f7b2986f56 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_gen6_ras.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_gen6_ras.h
@@ -170,23 +170,25 @@ struct adf_ras_ops;
 #define ADF_GEN6_TI_CD_PAR_ERR_MASK			0x500638
 
 /*
- * TI CD parity status mask
+ * TI CD parity status mask - TI_INT_ERR_DEVHALT bits
  * BIT(0) - BIT(15) - CtxMdRam[0:15]_sts parity status
  * BIT(16) - Leaf2ClusterRam_sts parity status
  * BIT(17) - BIT(18) - Ring2LeafRam[0:1]_sts parity status
- * BIT(19) - VirtualQ_sts parity status
- * BIT(20) - DtRdQ_sts parity status
- * BIT(21) - DtWrQ_sts parity status
- * BIT(22) - RiCmdQ_sts parity status
- * BIT(23) - BypassQ_sts parity status
- * BIT(24) - DtRdQ_sc_sts parity status
- * BIT(25) - DtWrQ_sc_sts parity status
  */
-#define ADF_GEN6_TI_CD_PAR_STS_MASK \
+#define ADF_GEN6_TI_CD_PAR_STS_TI_INT_ERR_DEVHALT_MASK \
 	(BIT(0) | BIT(1) | BIT(2) | BIT(3) | BIT(4) | BIT(5) | BIT(6) | \
 	 BIT(7) | BIT(8) | BIT(9) | BIT(10) | BIT(11) | BIT(12) | BIT(13) | \
-	 BIT(14) | BIT(15) | BIT(16) | BIT(17) | BIT(18) | BIT(19) | BIT(20) | \
-	 BIT(21) | BIT(22) | BIT(23) | BIT(24) | BIT(25))
+	 BIT(14) | BIT(15) | BIT(16) | BIT(17) | BIT(18))
+
+/*
+ * TI CD parity status mask - TIMISCSTS bit
+ * BIT(19) - VirtualQ_sts parity status
+ */
+#define ADF_GEN6_TI_CD_PAR_STS_TI_MISC_MASK		BIT(19)
+
+#define ADF_GEN6_TI_CD_PAR_STS_MASK \
+	(ADF_GEN6_TI_CD_PAR_STS_TI_INT_ERR_DEVHALT_MASK | \
+	 ADF_GEN6_TI_CD_PAR_STS_TI_MISC_MASK)
 
 /* TI TRNSB parity status */
 #define ADF_GEN6_TI_TRNSB_PAR_STS			0x500648

base-commit: af8be97e74cd57ea3a5699bc03a0c79096fd907b
-- 
2.52.0

