Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97F211A8F97
	for <linux-crypto@vger.kernel.org>; Sat, 28 Mar 2026 22:35:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774737302; cv=none; b=uK1VO6W6jeF7uQ/tkUDyrugNBYRlzp9UKT17TbCZIw3IJl2YuUg6+4RUPc5LzPnRNSbbnwc1YOnhOB0Lbmoe42FM+R7z4qFIDb+FejPjv3kJ8L6r+tiewnWqcjy2js8q3RV/AgGm5TLg2g2a75h7HnjIl2Qg1wKing0W/k00dCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774737302; c=relaxed/simple;
	bh=FRBRzyvLEVHzqIkisrCMLmVBLazrYr8o9WpySEGMbgQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=snqsH6Q2PuiHwWmsFBnm0aIXp3AlacTsBh2CpZuk5MLW2RSLxTIQ8fswL/06zHTegJiB5j2gtFOKWsYX/VV4HJ1kPNmgH37gW82yKJ52EMzPZQ55HvskF5CLGmAIFzxiYCqTbM4becv7u5ONpR7GAh2A+mI958moK6hwZWLPVbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Fkadz8rK; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Fkadz8rK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774737301; x=1806273301;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FRBRzyvLEVHzqIkisrCMLmVBLazrYr8o9WpySEGMbgQ=;
  b=Fkadz8rKb5sF2xIs9RwbSZXWruNDzDgUeSYRy9k4qMoZnNKvf8h8iIPQ
   17N5mxRUjyXjng4Snujhg4Vq7beqB0Qd4mBvNjv1u/nf2km5xsnkSTpWG
   y2YDsuBLPm6fiQqRFYYQm/5/fZ0i+9JP4/2weOv/axINPeyUEYynrJDKz
   eo5p1eYQmLax2s9ByLk7b0ebexH8i8UxEsq3eYIjRBjKyMeVTp/OmwOd2
   nPRv1j00z8snFv/QHz1Xa0XToH3PH+PgecTB1JzFxQ40ClO5GxllkMv3u
   0kfzsvEqyJc4/1oMupAH+00MKyTpjIDhEsRbkQ/DvsEUjDFPmbrugLq4P
   w==;
X-CSE-ConnectionGUID: qbtRWEuIQvS5ucxNrUKbIA==
X-CSE-MsgGUID: sZPIrgYNTHSkEO6JkjWeWQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11742"; a="78372915"
X-IronPort-AV: E=Sophos;i="6.23,146,1770624000"; 
   d="scan'208";a="78372915"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2026 15:35:00 -0700
X-CSE-ConnectionGUID: tSSYfQu1QaaPnys0z7Dybw==
X-CSE-MsgGUID: kOzH4+Q8RR2g6vtE0zW9iw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,146,1770624000"; 
   d="scan'208";a="222339224"
Received: from silpixa00401971.ir.intel.com ([10.20.226.106])
  by fmviesa007.fm.intel.com with ESMTP; 28 Mar 2026 15:34:58 -0700
From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	kernel test robot <lkp@intel.com>
Subject: [PATCH v2 1/2] crypto: qat - use swab32 macro
Date: Sat, 28 Mar 2026 22:29:46 +0000
Message-ID: <20260328223445.39445-2-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260328223445.39445-1-giovanni.cabiddu@intel.com>
References: <20260328223445.39445-1-giovanni.cabiddu@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit

Replace __builtin_bswap32() with swab32 in icp_qat_hw_20_comp.h to fix
the following build errors on architectures without native byte-swap
support:

   alpha-linux-ld: drivers/crypto/intel/qat/qat_common/adf_gen4_hw_data.o: in function `adf_gen4_build_decomp_block':
   drivers/crypto/intel/qat/qat_common/icp_qat_hw_20_comp.h:141:(.text+0xeec): undefined reference to `__bswapsi2'
   alpha-linux-ld: drivers/crypto/intel/qat/qat_common/icp_qat_hw_20_comp.h:141:(.text+0xef8): undefined reference to `__bswapsi2'
   alpha-linux-ld: drivers/crypto/intel/qat/qat_common/adf_gen4_hw_data.o: in function `adf_gen4_build_comp_block':
   drivers/crypto/intel/qat/qat_common/icp_qat_hw_20_comp.h:57:(.text+0xf64): undefined reference to `__bswapsi2'
   alpha-linux-ld: drivers/crypto/intel/qat/qat_common/icp_qat_hw_20_comp.h:57:(.text+0xf7c): undefined reference to `__bswapsi2'

Fixes: 5b14b2b307e4 ("crypto: qat - enable deflate for QAT GEN4")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202603290259.Ig9kDOmI-lkp@intel.com/
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 .../crypto/intel/qat/qat_common/icp_qat_hw_20_comp.h   | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/icp_qat_hw_20_comp.h b/drivers/crypto/intel/qat/qat_common/icp_qat_hw_20_comp.h
index 7ea8962272f2..d28732225c9e 100644
--- a/drivers/crypto/intel/qat/qat_common/icp_qat_hw_20_comp.h
+++ b/drivers/crypto/intel/qat/qat_common/icp_qat_hw_20_comp.h
@@ -3,6 +3,8 @@
 #ifndef _ICP_QAT_HW_20_COMP_H_
 #define _ICP_QAT_HW_20_COMP_H_
 
+#include <linux/swab.h>
+
 #include "icp_qat_hw_20_comp_defs.h"
 #include "icp_qat_fw.h"
 
@@ -54,7 +56,7 @@ ICP_QAT_FW_COMP_20_BUILD_CONFIG_LOWER(struct icp_qat_hw_comp_20_config_csr_lower
 	QAT_FIELD_SET(val32, csr.abd, ICP_QAT_HW_COMP_20_CONFIG_CSR_ABD_BITPOS,
 		      ICP_QAT_HW_COMP_20_CONFIG_CSR_ABD_MASK);
 
-	return __builtin_bswap32(val32);
+	return swab32(val32);
 }
 
 struct icp_qat_hw_comp_20_config_csr_upper {
@@ -106,7 +108,7 @@ ICP_QAT_FW_COMP_20_BUILD_CONFIG_UPPER(struct icp_qat_hw_comp_20_config_csr_upper
 		      ICP_QAT_HW_COMP_20_CONFIG_CSR_NICE_PARAM_BITPOS,
 		      ICP_QAT_HW_COMP_20_CONFIG_CSR_NICE_PARAM_MASK);
 
-	return __builtin_bswap32(val32);
+	return swab32(val32);
 }
 
 struct icp_qat_hw_decomp_20_config_csr_lower {
@@ -138,7 +140,7 @@ ICP_QAT_FW_DECOMP_20_BUILD_CONFIG_LOWER(struct icp_qat_hw_decomp_20_config_csr_l
 		      ICP_QAT_HW_DECOMP_20_CONFIG_CSR_LZ4_BLOCK_CHECKSUM_PRESENT_BITPOS,
 		      ICP_QAT_HW_DECOMP_20_CONFIG_CSR_LZ4_BLOCK_CHECKSUM_PRESENT_MASK);
 
-	return __builtin_bswap32(val32);
+	return swab32(val32);
 }
 
 struct icp_qat_hw_decomp_20_config_csr_upper {
@@ -158,7 +160,7 @@ ICP_QAT_FW_DECOMP_20_BUILD_CONFIG_UPPER(struct icp_qat_hw_decomp_20_config_csr_u
 		      ICP_QAT_HW_DECOMP_20_CONFIG_CSR_MINI_CAM_CONTROL_BITPOS,
 		      ICP_QAT_HW_DECOMP_20_CONFIG_CSR_MINI_CAM_CONTROL_MASK);
 
-	return __builtin_bswap32(val32);
+	return swab32(val32);
 }
 
 #endif
-- 
2.53.0

