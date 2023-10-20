Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0855C25B44
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Oct 2023 10:35:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376881AbjJTKfU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Oct 2023 06:35:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376882AbjJTKfN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Oct 2023 06:35:13 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A31ED61
        for <linux-crypto@vger.kernel.org>; Fri, 20 Oct 2023 03:35:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697798109; x=1729334109;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6Qzn5Vta1EwebGG+SfC3D7nZG2wIsxEk3WRxULB8l94=;
  b=Ankc4KxsNb7YU2byzu2kM+NZfRJ7FTL0lJxKubcXzT/W0kggmMB2M8LO
   DtrBLt7VOLrxeWsz8Wyeo5r0QjcykmogHWOQAqlC0hITfkgRh4xvBecUj
   81RYg5p8VVs/mkBuBOr4W6ZanA4wY3h1c5mlZNSGnXvTv3h9HsQrOe35s
   5FLCUY6zfx5Zuxy2xlvARScVeWUSvCXgrEusW3O1J9AFHoPU1fie3+w4W
   POZmCHIsAg85HNfVDCiv2ytZTHnegp7Ys0kvxJpzrqa70z+zA+6OEJufF
   Un5+NwapbMVLf8LjmI5u7z5TQKVmr4vTz/fHaalcrQdAuGwXPuEtoPQnt
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10868"; a="383686717"
X-IronPort-AV: E=Sophos;i="6.03,238,1694761200"; 
   d="scan'208";a="383686717"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2023 03:35:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10868"; a="792369944"
X-IronPort-AV: E=Sophos;i="6.03,238,1694761200"; 
   d="scan'208";a="792369944"
Received: from fl31ca105gs0706.deacluster.intel.com (HELO fl31ca105gs0706..) ([10.45.133.167])
  by orsmga001.jf.intel.com with ESMTP; 20 Oct 2023 03:35:02 -0700
From:   Shashank Gupta <shashank.gupta@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Shashank Gupta <shashank.gupta@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Tero Kristo <tero.kristo@linux.intel.com>
Subject: [PATCH 9/9] crypto: qat - count QAT GEN4 errors
Date:   Fri, 20 Oct 2023 11:32:53 +0100
Message-ID: <20231020103431.230671-10-shashank.gupta@intel.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231020103431.230671-1-shashank.gupta@intel.com>
References: <20231020103431.230671-1-shashank.gupta@intel.com>
MIME-Version: 1.0
Organization: Intel Technology Poland sp. z o.o. - ul. Slowackiego 173, 80-298 Gdansk - KRS 101882 - NIP 957-07-52-316
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add logic to count correctable, non fatal and fatal error for QAT GEN4
devices.
These counters are reported through sysfs attributes in the group
qat_ras.

Signed-off-by: Shashank Gupta <shashank.gupta@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Tero Kristo <tero.kristo@linux.intel.com>
---
 .../intel/qat/qat_common/adf_gen4_ras.c       | 182 ++++++++++++++++--
 1 file changed, 166 insertions(+), 16 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_gen4_ras.c b/drivers/crypto/intel/qat/qat_common/adf_gen4_ras.c
index 8ba9c9bdb89b..048c24607939 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_gen4_ras.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_gen4_ras.c
@@ -3,6 +3,9 @@
 #include "adf_common_drv.h"
 #include "adf_gen4_hw_data.h"
 #include "adf_gen4_ras.h"
+#include "adf_sysfs_ras_counters.h"
+
+#define BITS_PER_REG(_n_) (sizeof(_n_) * BITS_PER_BYTE)
 
 static void enable_errsou_reporting(void __iomem *csr)
 {
@@ -355,6 +358,8 @@ static void adf_gen4_process_errsou0(struct adf_accel_dev *accel_dev,
 		 "Correctable error detected in AE: 0x%x\n",
 		 aecorrerr);
 
+	ADF_RAS_ERR_CTR_INC(accel_dev->ras_errors, ADF_RAS_CORR);
+
 	/* Clear interrupt from ERRSOU0 */
 	ADF_CSR_WR(csr, ADF_GEN4_HIAECORERRLOG_CPP0, aecorrerr);
 }
@@ -374,6 +379,8 @@ static bool adf_handle_cpp_aeunc(struct adf_accel_dev *accel_dev,
 		"Uncorrectable error detected in AE: 0x%x\n",
 		aeuncorerr);
 
+	ADF_RAS_ERR_CTR_INC(accel_dev->ras_errors, ADF_RAS_UNCORR);
+
 	ADF_CSR_WR(csr, ADF_GEN4_HIAEUNCERRLOG_CPP0, aeuncorerr);
 
 	return false;
@@ -395,6 +402,8 @@ static bool adf_handle_cppcmdparerr(struct adf_accel_dev *accel_dev,
 		"HI CPP agent command parity error: 0x%x\n",
 		cmdparerr);
 
+	ADF_RAS_ERR_CTR_INC(accel_dev->ras_errors, ADF_RAS_FATAL);
+
 	ADF_CSR_WR(csr, ADF_GEN4_HICPPAGENTCMDPARERRLOG, cmdparerr);
 
 	return true;
@@ -413,15 +422,18 @@ static bool adf_handle_ri_mem_par_err(struct adf_accel_dev *accel_dev,
 	rimem_parerr_sts &= ADF_GEN4_RIMEM_PARERR_STS_UNCERR_BITMASK |
 			    ADF_GEN4_RIMEM_PARERR_STS_FATAL_BITMASK;
 
-	if (rimem_parerr_sts & ADF_GEN4_RIMEM_PARERR_STS_UNCERR_BITMASK)
+	if (rimem_parerr_sts & ADF_GEN4_RIMEM_PARERR_STS_UNCERR_BITMASK) {
 		dev_err(&GET_DEV(accel_dev),
 			"RI Memory Parity uncorrectable error: 0x%x\n",
 			rimem_parerr_sts);
+		ADF_RAS_ERR_CTR_INC(accel_dev->ras_errors, ADF_RAS_UNCORR);
+	}
 
 	if (rimem_parerr_sts & ADF_GEN4_RIMEM_PARERR_STS_FATAL_BITMASK) {
 		dev_err(&GET_DEV(accel_dev),
 			"RI Memory Parity fatal error: 0x%x\n",
 			rimem_parerr_sts);
+		ADF_RAS_ERR_CTR_INC(accel_dev->ras_errors, ADF_RAS_FATAL);
 		reset_required = true;
 	}
 
@@ -445,6 +457,7 @@ static bool adf_handle_ti_ci_par_sts(struct adf_accel_dev *accel_dev,
 		dev_err(&GET_DEV(accel_dev),
 			"TI Memory Parity Error: 0x%x\n", ti_ci_par_sts);
 		ADF_CSR_WR(csr, ADF_GEN4_TI_CI_PAR_STS, ti_ci_par_sts);
+		ADF_RAS_ERR_CTR_INC(accel_dev->ras_errors, ADF_RAS_UNCORR);
 	}
 
 	return false;
@@ -467,6 +480,8 @@ static bool adf_handle_ti_pullfub_par_sts(struct adf_accel_dev *accel_dev,
 
 		ADF_CSR_WR(csr, ADF_GEN4_TI_PULL0FUB_PAR_STS,
 			   ti_pullfub_par_sts);
+
+		ADF_RAS_ERR_CTR_INC(accel_dev->ras_errors, ADF_RAS_UNCORR);
 	}
 
 	return false;
@@ -487,6 +502,8 @@ static bool adf_handle_ti_pushfub_par_sts(struct adf_accel_dev *accel_dev,
 		dev_err(&GET_DEV(accel_dev),
 			"TI Push Parity Error: 0x%x\n", ti_pushfub_par_sts);
 
+		ADF_RAS_ERR_CTR_INC(accel_dev->ras_errors, ADF_RAS_UNCORR);
+
 		ADF_CSR_WR(csr, ADF_GEN4_TI_PUSHFUB_PAR_STS,
 			   ti_pushfub_par_sts);
 	}
@@ -509,6 +526,8 @@ static bool adf_handle_ti_cd_par_sts(struct adf_accel_dev *accel_dev,
 		dev_err(&GET_DEV(accel_dev),
 			"TI CD Parity Error: 0x%x\n", ti_cd_par_sts);
 
+		ADF_RAS_ERR_CTR_INC(accel_dev->ras_errors, ADF_RAS_UNCORR);
+
 		ADF_CSR_WR(csr, ADF_GEN4_TI_CD_PAR_STS, ti_cd_par_sts);
 	}
 
@@ -530,6 +549,8 @@ static bool adf_handle_ti_trnsb_par_sts(struct adf_accel_dev *accel_dev,
 		dev_err(&GET_DEV(accel_dev),
 			"TI TRNSB Parity Error: 0x%x\n", ti_trnsb_par_sts);
 
+		ADF_RAS_ERR_CTR_INC(accel_dev->ras_errors, ADF_RAS_UNCORR);
+
 		ADF_CSR_WR(csr, ADF_GEN4_TI_TRNSB_PAR_STS, ti_trnsb_par_sts);
 	}
 
@@ -551,6 +572,8 @@ static bool adf_handle_iosfp_cmd_parerr(struct adf_accel_dev *accel_dev,
 		"Command Parity error detected on IOSFP: 0x%x\n",
 		rimiscsts);
 
+	ADF_RAS_ERR_CTR_INC(accel_dev->ras_errors, ADF_RAS_FATAL);
+
 	ADF_CSR_WR(csr, ADF_GEN4_RIMISCSTS, rimiscsts);
 
 	return true;
@@ -586,6 +609,8 @@ static bool adf_handle_uerrssmsh(struct adf_accel_dev *accel_dev,
 		"Uncorrectable error on ssm shared memory: 0x%x\n",
 		reg);
 
+	ADF_RAS_ERR_CTR_INC(accel_dev->ras_errors, ADF_RAS_UNCORR);
+
 	ADF_CSR_WR(csr, ADF_GEN4_UERRSSMSH, reg);
 
 	return false;
@@ -606,6 +631,8 @@ static bool adf_handle_cerrssmsh(struct adf_accel_dev *accel_dev,
 		 "Correctable error on ssm shared memory: 0x%x\n",
 		 reg);
 
+	ADF_RAS_ERR_CTR_INC(accel_dev->ras_errors, ADF_RAS_CORR);
+
 	ADF_CSR_WR(csr, ADF_GEN4_CERRSSMSH, reg);
 
 	return false;
@@ -626,6 +653,8 @@ static bool adf_handle_pperr_err(struct adf_accel_dev *accel_dev,
 		"Uncorrectable error CPP transaction on memory target: 0x%x\n",
 		reg);
 
+	ADF_RAS_ERR_CTR_INC(accel_dev->ras_errors, ADF_RAS_UNCORR);
+
 	ADF_CSR_WR(csr, ADF_GEN4_PPERR, reg);
 
 	return false;
@@ -642,6 +671,8 @@ static void adf_poll_slicehang_csr(struct adf_accel_dev *accel_dev,
 
 	dev_err(&GET_DEV(accel_dev),
 		"Slice %s hang error encountered\n", slice_name);
+
+	ADF_RAS_ERR_CTR_INC(accel_dev->ras_errors, ADF_RAS_UNCORR);
 }
 
 static bool adf_handle_slice_hang_error(struct adf_accel_dev *accel_dev,
@@ -682,6 +713,8 @@ static bool adf_handle_spp_pullcmd_err(struct adf_accel_dev *accel_dev,
 		dev_err(&GET_DEV(accel_dev),
 			"SPP pull command fatal error ATH_CPH: 0x%x\n", reg);
 
+		ADF_RAS_ERR_CTR_INC(accel_dev->ras_errors, ADF_RAS_FATAL);
+
 		ADF_CSR_WR(csr, ADF_GEN4_SPPPULLCMDPARERR_ATH_CPH, reg);
 
 		reset_required = true;
@@ -693,6 +726,8 @@ static bool adf_handle_spp_pullcmd_err(struct adf_accel_dev *accel_dev,
 		dev_err(&GET_DEV(accel_dev),
 			"SPP pull command fatal error CPR_XLT: 0x%x\n", reg);
 
+		ADF_RAS_ERR_CTR_INC(accel_dev->ras_errors, ADF_RAS_FATAL);
+
 		ADF_CSR_WR(csr, ADF_GEN4_SPPPULLCMDPARERR_CPR_XLT, reg);
 
 		reset_required = true;
@@ -704,6 +739,8 @@ static bool adf_handle_spp_pullcmd_err(struct adf_accel_dev *accel_dev,
 		dev_err(&GET_DEV(accel_dev),
 			"SPP pull command fatal error DCPR_UCS: 0x%x\n", reg);
 
+		ADF_RAS_ERR_CTR_INC(accel_dev->ras_errors, ADF_RAS_FATAL);
+
 		ADF_CSR_WR(csr, ADF_GEN4_SPPPULLCMDPARERR_DCPR_UCS, reg);
 
 		reset_required = true;
@@ -715,6 +752,8 @@ static bool adf_handle_spp_pullcmd_err(struct adf_accel_dev *accel_dev,
 		dev_err(&GET_DEV(accel_dev),
 			"SPP pull command fatal error PKE: 0x%x\n", reg);
 
+		ADF_RAS_ERR_CTR_INC(accel_dev->ras_errors, ADF_RAS_FATAL);
+
 		ADF_CSR_WR(csr, ADF_GEN4_SPPPULLCMDPARERR_PKE, reg);
 
 		reset_required = true;
@@ -727,6 +766,8 @@ static bool adf_handle_spp_pullcmd_err(struct adf_accel_dev *accel_dev,
 			dev_err(&GET_DEV(accel_dev),
 				"SPP pull command fatal error WAT_WCP: 0x%x\n", reg);
 
+			ADF_RAS_ERR_CTR_INC(accel_dev->ras_errors, ADF_RAS_FATAL);
+
 			ADF_CSR_WR(csr, ADF_GEN4_SPPPULLCMDPARERR_WAT_WCP, reg);
 
 			reset_required = true;
@@ -748,6 +789,8 @@ static bool adf_handle_spp_pulldata_err(struct adf_accel_dev *accel_dev,
 		dev_err(&GET_DEV(accel_dev),
 			"SPP pull data err ATH_CPH: 0x%x\n", reg);
 
+		ADF_RAS_ERR_CTR_INC(accel_dev->ras_errors, ADF_RAS_UNCORR);
+
 		ADF_CSR_WR(csr, ADF_GEN4_SPPPULLDATAPARERR_ATH_CPH, reg);
 	}
 
@@ -757,6 +800,8 @@ static bool adf_handle_spp_pulldata_err(struct adf_accel_dev *accel_dev,
 		dev_err(&GET_DEV(accel_dev),
 			"SPP pull data err CPR_XLT: 0x%x\n", reg);
 
+		ADF_RAS_ERR_CTR_INC(accel_dev->ras_errors, ADF_RAS_UNCORR);
+
 		ADF_CSR_WR(csr, ADF_GEN4_SPPPULLDATAPARERR_CPR_XLT, reg);
 	}
 
@@ -766,6 +811,8 @@ static bool adf_handle_spp_pulldata_err(struct adf_accel_dev *accel_dev,
 		dev_err(&GET_DEV(accel_dev),
 			"SPP pull data err DCPR_UCS: 0x%x\n", reg);
 
+		ADF_RAS_ERR_CTR_INC(accel_dev->ras_errors, ADF_RAS_UNCORR);
+
 		ADF_CSR_WR(csr, ADF_GEN4_SPPPULLDATAPARERR_DCPR_UCS, reg);
 	}
 
@@ -775,6 +822,8 @@ static bool adf_handle_spp_pulldata_err(struct adf_accel_dev *accel_dev,
 		dev_err(&GET_DEV(accel_dev),
 			"SPP pull data err PKE: 0x%x\n", reg);
 
+		ADF_RAS_ERR_CTR_INC(accel_dev->ras_errors, ADF_RAS_UNCORR);
+
 		ADF_CSR_WR(csr, ADF_GEN4_SPPPULLDATAPARERR_PKE, reg);
 	}
 
@@ -785,6 +834,8 @@ static bool adf_handle_spp_pulldata_err(struct adf_accel_dev *accel_dev,
 			dev_err(&GET_DEV(accel_dev),
 				"SPP pull data err WAT_WCP: 0x%x\n", reg);
 
+			ADF_RAS_ERR_CTR_INC(accel_dev->ras_errors, ADF_RAS_UNCORR);
+
 			ADF_CSR_WR(csr, ADF_GEN4_SPPPULLDATAPARERR_WAT_WCP, reg);
 		}
 	}
@@ -805,6 +856,8 @@ static bool adf_handle_spp_pushcmd_err(struct adf_accel_dev *accel_dev,
 		dev_err(&GET_DEV(accel_dev),
 			"SPP push command fatal error ATH_CPH: 0x%x\n", reg);
 
+		ADF_RAS_ERR_CTR_INC(accel_dev->ras_errors, ADF_RAS_FATAL);
+
 		ADF_CSR_WR(csr, ADF_GEN4_SPPPUSHCMDPARERR_ATH_CPH, reg);
 
 		reset_required = true;
@@ -816,6 +869,8 @@ static bool adf_handle_spp_pushcmd_err(struct adf_accel_dev *accel_dev,
 		dev_err(&GET_DEV(accel_dev),
 			"SPP push command fatal error CPR_XLT: 0x%x\n", reg);
 
+		ADF_RAS_ERR_CTR_INC(accel_dev->ras_errors, ADF_RAS_FATAL);
+
 		ADF_CSR_WR(csr, ADF_GEN4_SPPPUSHCMDPARERR_CPR_XLT, reg);
 
 		reset_required = true;
@@ -827,6 +882,8 @@ static bool adf_handle_spp_pushcmd_err(struct adf_accel_dev *accel_dev,
 		dev_err(&GET_DEV(accel_dev),
 			"SPP push command fatal error DCPR_UCS: 0x%x\n", reg);
 
+		ADF_RAS_ERR_CTR_INC(accel_dev->ras_errors, ADF_RAS_FATAL);
+
 		ADF_CSR_WR(csr, ADF_GEN4_SPPPUSHCMDPARERR_DCPR_UCS, reg);
 
 		reset_required = true;
@@ -839,6 +896,8 @@ static bool adf_handle_spp_pushcmd_err(struct adf_accel_dev *accel_dev,
 			"SPP push command fatal error PKE: 0x%x\n",
 			reg);
 
+		ADF_RAS_ERR_CTR_INC(accel_dev->ras_errors, ADF_RAS_FATAL);
+
 		ADF_CSR_WR(csr, ADF_GEN4_SPPPUSHCMDPARERR_PKE, reg);
 
 		reset_required = true;
@@ -851,6 +910,8 @@ static bool adf_handle_spp_pushcmd_err(struct adf_accel_dev *accel_dev,
 			dev_err(&GET_DEV(accel_dev),
 				"SPP push command fatal error WAT_WCP: 0x%x\n", reg);
 
+			ADF_RAS_ERR_CTR_INC(accel_dev->ras_errors, ADF_RAS_FATAL);
+
 			ADF_CSR_WR(csr, ADF_GEN4_SPPPUSHCMDPARERR_WAT_WCP, reg);
 
 			reset_required = true;
@@ -872,6 +933,8 @@ static bool adf_handle_spp_pushdata_err(struct adf_accel_dev *accel_dev,
 		dev_err(&GET_DEV(accel_dev),
 			"SPP push data err ATH_CPH: 0x%x\n", reg);
 
+		ADF_RAS_ERR_CTR_INC(accel_dev->ras_errors, ADF_RAS_UNCORR);
+
 		ADF_CSR_WR(csr, ADF_GEN4_SPPPUSHDATAPARERR_ATH_CPH, reg);
 	}
 
@@ -881,6 +944,8 @@ static bool adf_handle_spp_pushdata_err(struct adf_accel_dev *accel_dev,
 		dev_err(&GET_DEV(accel_dev),
 			"SPP push data err CPR_XLT: 0x%x\n", reg);
 
+		ADF_RAS_ERR_CTR_INC(accel_dev->ras_errors, ADF_RAS_UNCORR);
+
 		ADF_CSR_WR(csr, ADF_GEN4_SPPPUSHDATAPARERR_CPR_XLT, reg);
 	}
 
@@ -890,6 +955,8 @@ static bool adf_handle_spp_pushdata_err(struct adf_accel_dev *accel_dev,
 		dev_err(&GET_DEV(accel_dev),
 			"SPP push data err DCPR_UCS: 0x%x\n", reg);
 
+		ADF_RAS_ERR_CTR_INC(accel_dev->ras_errors, ADF_RAS_UNCORR);
+
 		ADF_CSR_WR(csr, ADF_GEN4_SPPPUSHDATAPARERR_DCPR_UCS, reg);
 	}
 
@@ -899,6 +966,8 @@ static bool adf_handle_spp_pushdata_err(struct adf_accel_dev *accel_dev,
 		dev_err(&GET_DEV(accel_dev),
 			"SPP push data err PKE: 0x%x\n", reg);
 
+		ADF_RAS_ERR_CTR_INC(accel_dev->ras_errors, ADF_RAS_UNCORR);
+
 		ADF_CSR_WR(csr, ADF_GEN4_SPPPUSHDATAPARERR_PKE, reg);
 	}
 
@@ -909,6 +978,8 @@ static bool adf_handle_spp_pushdata_err(struct adf_accel_dev *accel_dev,
 			dev_err(&GET_DEV(accel_dev),
 				"SPP push data err WAT_WCP: 0x%x\n", reg);
 
+			ADF_RAS_ERR_CTR_INC(accel_dev->ras_errors, ADF_RAS_UNCORR);
+
 			ADF_CSR_WR(csr, ADF_GEN4_SPPPUSHDATAPARERR_WAT_WCP,
 				   reg);
 		}
@@ -936,8 +1007,11 @@ static bool adf_handle_spppar_err(struct adf_accel_dev *accel_dev,
 static bool adf_handle_ssmcpppar_err(struct adf_accel_dev *accel_dev,
 				     void __iomem *csr, u32 iastatssm)
 {
+	u32 reg = ADF_CSR_RD(csr, ADF_GEN4_SSMCPPERR);
+	u32 bits_num = BITS_PER_REG(reg);
 	bool reset_required = false;
-	u32 reg;
+	unsigned long errs_bits;
+	u32 bit_iterator;
 
 	if (!(iastatssm & ADF_GEN4_IAINTSTATSSM_SSMCPPERR_BIT))
 		return false;
@@ -948,12 +1022,22 @@ static bool adf_handle_ssmcpppar_err(struct adf_accel_dev *accel_dev,
 		dev_err(&GET_DEV(accel_dev),
 			"Fatal SSM CPP parity error: 0x%x\n", reg);
 
+		errs_bits = reg & ADF_GEN4_SSMCPPERR_FATAL_BITMASK;
+		for_each_set_bit(bit_iterator, &errs_bits, bits_num) {
+			ADF_RAS_ERR_CTR_INC(accel_dev->ras_errors, ADF_RAS_FATAL);
+		}
 		reset_required = true;
 	}
 
-	if (reg & ADF_GEN4_SSMCPPERR_UNCERR_BITMASK)
+	if (reg & ADF_GEN4_SSMCPPERR_UNCERR_BITMASK) {
 		dev_err(&GET_DEV(accel_dev),
 			"non-Fatal SSM CPP parity error: 0x%x\n", reg);
+		errs_bits = reg & ADF_GEN4_SSMCPPERR_UNCERR_BITMASK;
+
+		for_each_set_bit(bit_iterator, &errs_bits, bits_num) {
+			ADF_RAS_ERR_CTR_INC(accel_dev->ras_errors, ADF_RAS_UNCORR);
+		}
+	}
 
 	ADF_CSR_WR(csr, ADF_GEN4_SSMCPPERR, reg);
 
@@ -971,35 +1055,47 @@ static bool adf_handle_rf_parr_err(struct adf_accel_dev *accel_dev,
 
 	reg = ADF_CSR_RD(csr, ADF_GEN4_SSMSOFTERRORPARITY_SRC);
 	reg &= ADF_GEN4_SSMSOFTERRORPARITY_SRC_BIT;
-	if (reg)
+	if (reg) {
+		ADF_RAS_ERR_CTR_INC(accel_dev->ras_errors, ADF_RAS_UNCORR);
 		ADF_CSR_WR(csr, ADF_GEN4_SSMSOFTERRORPARITY_SRC, reg);
+	}
 
 	reg = ADF_CSR_RD(csr, ADF_GEN4_SSMSOFTERRORPARITY_ATH_CPH);
 	reg &= err_mask->parerr_ath_cph_mask;
-	if (reg)
+	if (reg) {
+		ADF_RAS_ERR_CTR_INC(accel_dev->ras_errors, ADF_RAS_UNCORR);
 		ADF_CSR_WR(csr, ADF_GEN4_SSMSOFTERRORPARITY_ATH_CPH, reg);
+	}
 
 	reg = ADF_CSR_RD(csr, ADF_GEN4_SSMSOFTERRORPARITY_CPR_XLT);
 	reg &= err_mask->parerr_cpr_xlt_mask;
-	if (reg)
+	if (reg) {
+		ADF_RAS_ERR_CTR_INC(accel_dev->ras_errors, ADF_RAS_UNCORR);
 		ADF_CSR_WR(csr, ADF_GEN4_SSMSOFTERRORPARITY_CPR_XLT, reg);
+	}
 
 	reg = ADF_CSR_RD(csr, ADF_GEN4_SSMSOFTERRORPARITY_DCPR_UCS);
 	reg &= err_mask->parerr_dcpr_ucs_mask;
-	if (reg)
+	if (reg) {
+		ADF_RAS_ERR_CTR_INC(accel_dev->ras_errors, ADF_RAS_UNCORR);
 		ADF_CSR_WR(csr, ADF_GEN4_SSMSOFTERRORPARITY_DCPR_UCS, reg);
+	}
 
 	reg = ADF_CSR_RD(csr, ADF_GEN4_SSMSOFTERRORPARITY_PKE);
 	reg &= err_mask->parerr_pke_mask;
-	if (reg)
+	if (reg) {
+		ADF_RAS_ERR_CTR_INC(accel_dev->ras_errors, ADF_RAS_UNCORR);
 		ADF_CSR_WR(csr, ADF_GEN4_SSMSOFTERRORPARITY_PKE, reg);
+	}
 
 	if (err_mask->parerr_wat_wcp_mask) {
 		reg = ADF_CSR_RD(csr, ADF_GEN4_SSMSOFTERRORPARITY_WAT_WCP);
 		reg &= err_mask->parerr_wat_wcp_mask;
-		if (reg)
+		if (reg) {
+			ADF_RAS_ERR_CTR_INC(accel_dev->ras_errors, ADF_RAS_UNCORR);
 			ADF_CSR_WR(csr, ADF_GEN4_SSMSOFTERRORPARITY_WAT_WCP,
 				   reg);
+		}
 	}
 
 	dev_err(&GET_DEV(accel_dev), "Slice ssm soft parity error reported");
@@ -1010,8 +1106,11 @@ static bool adf_handle_rf_parr_err(struct adf_accel_dev *accel_dev,
 static bool adf_handle_ser_err_ssmsh(struct adf_accel_dev *accel_dev,
 				     void __iomem *csr, u32 iastatssm)
 {
+	u32 reg = ADF_CSR_RD(csr, ADF_GEN4_SER_ERR_SSMSH);
+	u32 bits_num = BITS_PER_REG(reg);
 	bool reset_required = false;
-	u32 reg;
+	unsigned long errs_bits;
+	u32 bit_iterator;
 
 	if (!(iastatssm & (ADF_GEN4_IAINTSTATSSM_SER_ERR_SSMSH_CERR_BIT |
 			 ADF_GEN4_IAINTSTATSSM_SER_ERR_SSMSH_UNCERR_BIT)))
@@ -1025,17 +1124,34 @@ static bool adf_handle_ser_err_ssmsh(struct adf_accel_dev *accel_dev,
 		dev_err(&GET_DEV(accel_dev),
 			"Fatal SER_SSMSH_ERR: 0x%x\n", reg);
 
+		errs_bits = reg & ADF_GEN4_SER_ERR_SSMSH_FATAL_BITMASK;
+		for_each_set_bit(bit_iterator, &errs_bits, bits_num) {
+			ADF_RAS_ERR_CTR_INC(accel_dev->ras_errors, ADF_RAS_FATAL);
+		}
+
 		reset_required = true;
 	}
 
-	if (reg & ADF_GEN4_SER_ERR_SSMSH_UNCERR_BITMASK)
+	if (reg & ADF_GEN4_SER_ERR_SSMSH_UNCERR_BITMASK) {
 		dev_err(&GET_DEV(accel_dev),
 			"non-fatal SER_SSMSH_ERR: 0x%x\n", reg);
 
-	if (reg & ADF_GEN4_SER_ERR_SSMSH_CERR_BITMASK)
+		errs_bits = reg & ADF_GEN4_SER_ERR_SSMSH_UNCERR_BITMASK;
+		for_each_set_bit(bit_iterator, &errs_bits, bits_num) {
+			ADF_RAS_ERR_CTR_INC(accel_dev->ras_errors, ADF_RAS_UNCORR);
+		}
+	}
+
+	if (reg & ADF_GEN4_SER_ERR_SSMSH_CERR_BITMASK) {
 		dev_warn(&GET_DEV(accel_dev),
 			 "Correctable SER_SSMSH_ERR: 0x%x\n", reg);
 
+		errs_bits = reg & ADF_GEN4_SER_ERR_SSMSH_CERR_BITMASK;
+		for_each_set_bit(bit_iterator, &errs_bits, bits_num) {
+			ADF_RAS_ERR_CTR_INC(accel_dev->ras_errors, ADF_RAS_CORR);
+		}
+	}
+
 	ADF_CSR_WR(csr, ADF_GEN4_SER_ERR_SSMSH, reg);
 
 	return reset_required;
@@ -1077,6 +1193,8 @@ static bool adf_handle_exprpssmcmpr(struct adf_accel_dev *accel_dev,
 	dev_err(&GET_DEV(accel_dev),
 		"Uncorrectable error exception in SSM CMP: 0x%x", reg);
 
+	ADF_RAS_ERR_CTR_INC(accel_dev->ras_errors, ADF_RAS_UNCORR);
+
 	ADF_CSR_WR(csr, ADF_GEN4_EXPRPSSMCPR, reg);
 
 	return false;
@@ -1092,14 +1210,20 @@ static bool adf_handle_exprpssmxlt(struct adf_accel_dev *accel_dev,
 	if (!reg)
 		return false;
 
-	if (reg & ADF_GEN4_EXPRPSSMXLT_UNCERR_BITMASK)
+	if (reg & ADF_GEN4_EXPRPSSMXLT_UNCERR_BITMASK) {
 		dev_err(&GET_DEV(accel_dev),
 			"Uncorrectable error exception in SSM XLT: 0x%x", reg);
 
-	if (reg & ADF_GEN4_EXPRPSSMXLT_CERR_BIT)
+		ADF_RAS_ERR_CTR_INC(accel_dev->ras_errors, ADF_RAS_UNCORR);
+	}
+
+	if (reg & ADF_GEN4_EXPRPSSMXLT_CERR_BIT) {
 		dev_warn(&GET_DEV(accel_dev),
 			 "Correctable error exception in SSM XLT: 0x%x", reg);
 
+		ADF_RAS_ERR_CTR_INC(accel_dev->ras_errors, ADF_RAS_CORR);
+	}
+
 	ADF_CSR_WR(csr, ADF_GEN4_EXPRPSSMXLT, reg);
 
 	return false;
@@ -1118,14 +1242,20 @@ static bool adf_handle_exprpssmdcpr(struct adf_accel_dev *accel_dev,
 		if (!reg)
 			continue;
 
-		if (reg & ADF_GEN4_EXPRPSSMDCPR_UNCERR_BITMASK)
+		if (reg & ADF_GEN4_EXPRPSSMDCPR_UNCERR_BITMASK) {
 			dev_err(&GET_DEV(accel_dev),
 				"Uncorrectable error exception in SSM DCMP: 0x%x", reg);
 
-		if (reg & ADF_GEN4_EXPRPSSMDCPR_CERR_BITMASK)
+			ADF_RAS_ERR_CTR_INC(accel_dev->ras_errors, ADF_RAS_UNCORR);
+		}
+
+		if (reg & ADF_GEN4_EXPRPSSMDCPR_CERR_BITMASK) {
 			dev_warn(&GET_DEV(accel_dev),
 				 "Correctable error exception in SSM DCMP: 0x%x", reg);
 
+			ADF_RAS_ERR_CTR_INC(accel_dev->ras_errors, ADF_RAS_CORR);
+		}
+
 		ADF_CSR_WR(csr, ADF_GEN4_EXPRPSSMDCPR(i), reg);
 	}
 
@@ -1161,11 +1291,13 @@ static bool adf_handle_cpp_cfc_err(struct adf_accel_dev *accel_dev,
 	if (reg & ADF_GEN4_CPP_CFC_ERR_STATUS_DATAPAR_BIT) {
 		dev_err(&GET_DEV(accel_dev),
 			"CPP_CFC_ERR: data parity: 0x%x", reg);
+		ADF_RAS_ERR_CTR_INC(accel_dev->ras_errors, ADF_RAS_UNCORR);
 	}
 
 	if (reg & ADF_GEN4_CPP_CFC_ERR_STATUS_CMDPAR_BIT) {
 		dev_err(&GET_DEV(accel_dev),
 			"CPP_CFC_ERR: command parity: 0x%x", reg);
+		ADF_RAS_ERR_CTR_INC(accel_dev->ras_errors, ADF_RAS_FATAL);
 
 		reset_required = true;
 	}
@@ -1173,6 +1305,7 @@ static bool adf_handle_cpp_cfc_err(struct adf_accel_dev *accel_dev,
 	if (reg & ADF_GEN4_CPP_CFC_ERR_STATUS_MERR_BIT) {
 		dev_err(&GET_DEV(accel_dev),
 			"CPP_CFC_ERR: multiple errors: 0x%x", reg);
+		ADF_RAS_ERR_CTR_INC(accel_dev->ras_errors, ADF_RAS_FATAL);
 
 		reset_required = true;
 	}
@@ -1204,6 +1337,8 @@ static bool adf_handle_timiscsts(struct adf_accel_dev *accel_dev,
 	dev_err(&GET_DEV(accel_dev),
 		"Fatal error in Transmit Interface: 0x%x\n", timiscsts);
 
+	ADF_RAS_ERR_CTR_INC(accel_dev->ras_errors, ADF_RAS_FATAL);
+
 	return true;
 }
 
@@ -1221,6 +1356,8 @@ static bool adf_handle_ricppintsts(struct adf_accel_dev *accel_dev,
 	dev_err(&GET_DEV(accel_dev),
 		"RI CPP Uncorrectable Error: 0x%x\n", ricppintsts);
 
+	ADF_RAS_ERR_CTR_INC(accel_dev->ras_errors, ADF_RAS_UNCORR);
+
 	ADF_CSR_WR(csr, ADF_GEN4_RICPPINTSTS, ricppintsts);
 
 	return false;
@@ -1240,6 +1377,8 @@ static bool adf_handle_ticppintsts(struct adf_accel_dev *accel_dev,
 	dev_err(&GET_DEV(accel_dev),
 		"TI CPP Uncorrectable Error: 0x%x\n", ticppintsts);
 
+	ADF_RAS_ERR_CTR_INC(accel_dev->ras_errors, ADF_RAS_UNCORR);
+
 	ADF_CSR_WR(csr, ADF_GEN4_TICPPINTSTS, ticppintsts);
 
 	return false;
@@ -1259,6 +1398,8 @@ static bool adf_handle_aramcerr(struct adf_accel_dev *accel_dev,
 	dev_warn(&GET_DEV(accel_dev),
 		 "ARAM correctable error : 0x%x\n", aram_cerr);
 
+	ADF_RAS_ERR_CTR_INC(accel_dev->ras_errors, ADF_RAS_CORR);
+
 	aram_cerr |= ADF_GEN4_REG_ARAMCERR_EN_BITMASK;
 
 	ADF_CSR_WR(csr, ADF_GEN4_REG_ARAMCERR, aram_cerr);
@@ -1286,10 +1427,14 @@ static bool adf_handle_aramuerr(struct adf_accel_dev *accel_dev,
 		dev_err(&GET_DEV(accel_dev),
 			"ARAM multiple uncorrectable errors: 0x%x\n", aramuerr);
 
+		ADF_RAS_ERR_CTR_INC(accel_dev->ras_errors, ADF_RAS_FATAL);
+
 		reset_required = true;
 	} else {
 		dev_err(&GET_DEV(accel_dev),
 			"ARAM uncorrectable error: 0x%x\n", aramuerr);
+
+		ADF_RAS_ERR_CTR_INC(accel_dev->ras_errors, ADF_RAS_UNCORR);
 	}
 
 	aramuerr |= ADF_GEN4_REG_ARAMUERR_EN_BITMASK;
@@ -1319,10 +1464,13 @@ static bool adf_handle_reg_cppmemtgterr(struct adf_accel_dev *accel_dev,
 			"Misc memory target multiple uncorrectable errors: 0x%x\n",
 			cppmemtgterr);
 
+		ADF_RAS_ERR_CTR_INC(accel_dev->ras_errors, ADF_RAS_FATAL);
+
 		reset_required = true;
 	} else {
 		dev_err(&GET_DEV(accel_dev),
 			"Misc memory target uncorrectable error: 0x%x\n", cppmemtgterr);
+		ADF_RAS_ERR_CTR_INC(accel_dev->ras_errors, ADF_RAS_UNCORR);
 	}
 
 	cppmemtgterr |= ADF_GEN4_REG_CPPMEMTGTERR_EN_BITMASK;
@@ -1351,6 +1499,8 @@ static bool adf_handle_atufaultstatus(struct adf_accel_dev *accel_dev,
 				"Ring Pair (%u) ATU detected fault: 0x%x\n", i,
 				atufaultstatus);
 
+			ADF_RAS_ERR_CTR_INC(accel_dev->ras_errors, ADF_RAS_UNCORR);
+
 			ADF_CSR_WR(csr, ADF_GEN4_ATUFAULTSTATUS(i), atufaultstatus);
 		}
 	}
-- 
2.41.0

