Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A142156230
	for <linux-crypto@vger.kernel.org>; Fri, 28 Mar 2025 10:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743158019; cv=none; b=LkuJCDwV5TXgXGalJRWos/GiOnkHvtTjEoC3liIZEHd/JdJBsCIj0/y8uWqPswyobr1maKsSqVseFoNNMrVzJ8nGYyjkouF9w24x0TGyge8ie3SxYMMzwV9lW9ezZj2cL/3THFns/b8g2H29dImz/0JmKHqYrRwb1ZdJG0K0mh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743158019; c=relaxed/simple;
	bh=8POpZWBDsFjprsc5DYQcIQcgtLY10EsL6TnyPCwzLPI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=dUi+0SGG5L2TPK2PX7rFVBCSRnoVYavuDcbKQjmB6WXxrGBOet1ZxQd3wwc2UjK6iH4B70oLJCqYaGuslVEvfQI4yMNTUE1zikfTbMdyCEnaTBa6Yoz9Mec1jXlVdtgZtsf90alnyAloZm0z5qBS0VPi8/soLyNUaKU2iTy727Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lATo+wSm; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lATo+wSm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1743158018; x=1774694018;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=8POpZWBDsFjprsc5DYQcIQcgtLY10EsL6TnyPCwzLPI=;
  b=lATo+wSmRKfBGuj+ITfLllTgAJSa7tUAUDqnLbOtAnSvj7RcIR3A32Cg
   tiCEU2cOA7dxPhHHN3y86KH4dT8W81+MH+cNUyB0YUp0BEVcdS34WVYEV
   6qoeQ2mg9iZObWEcwRPSz8mBiyonOY0sExHQntMy55bjYHbALtHn52Zja
   vaEg9ndoCR6ouaMZDQYArNeMOtfHS2Bvx7SVc+RPQm+3VJbCLmw0fd202
   Xi/BHCstPwUYehZSTH73NGhN/Khjdi509ZAIxDrrM/3wSlhgQW5orpX32
   S53iFFOPVp0rbMIlVvUU7g9IByUipZC75fDyETfxmUpUDOmNl66wa7GGY
   Q==;
X-CSE-ConnectionGUID: uqlSWDmRRGOWQLa97fdE4A==
X-CSE-MsgGUID: SABkJ7ixSx+LcVJZzGSwMg==
X-IronPort-AV: E=McAfee;i="6700,10204,11385"; a="66988219"
X-IronPort-AV: E=Sophos;i="6.14,283,1736841600"; 
   d="scan'208";a="66988219"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2025 03:33:38 -0700
X-CSE-ConnectionGUID: 0a5pUoFuQj+wlkZ8WTs9GQ==
X-CSE-MsgGUID: oU+3kVwURIikZ3rZgA1Leg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,283,1736841600"; 
   d="scan'208";a="129556022"
Received: from t21-qat.iind.intel.com ([10.49.15.35])
  by fmviesa003.fm.intel.com with ESMTP; 28 Mar 2025 03:33:35 -0700
From: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH] crypto: qat - remove BITS_IN_DWORD()
Date: Fri, 28 Mar 2025 10:33:02 +0000
Message-Id: <20250328103302.571774-1-suman.kumar.chakraborty@intel.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The BITS_IN_DWORD() macro, which represents the number of bits in the
registers accessed by the firmware loader, is currently defined as 32.

For consistency and readability, replace this macro with the existing
BITS_PER_TYPE() macro, which serves the same purpose.

This does not introduce any functional change.

Signed-off-by: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 .../crypto/intel/qat/qat_common/qat_uclo.c    | 20 +++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/qat_uclo.c b/drivers/crypto/intel/qat/qat_common/qat_uclo.c
index 7678a93c6853..87e247ac1c9a 100644
--- a/drivers/crypto/intel/qat/qat_common/qat_uclo.c
+++ b/drivers/crypto/intel/qat/qat_common/qat_uclo.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: (BSD-3-Clause OR GPL-2.0-only)
 /* Copyright(c) 2014 - 2020 Intel Corporation */
 #include <linux/align.h>
+#include <linux/bitops.h>
 #include <linux/slab.h>
 #include <linux/ctype.h>
 #include <linux/kernel.h>
@@ -1205,7 +1206,6 @@ static int qat_uclo_map_suof(struct icp_qat_fw_loader_handle *handle,
 }
 
 #define ADD_ADDR(high, low)  ((((u64)high) << 32) + low)
-#define BITS_IN_DWORD 32
 
 static int qat_uclo_auth_fw(struct icp_qat_fw_loader_handle *handle,
 			    struct icp_qat_fw_auth_desc *desc)
@@ -1223,7 +1223,7 @@ static int qat_uclo_auth_fw(struct icp_qat_fw_loader_handle *handle,
 	fcu_dram_hi_csr = handle->chip_info->fcu_dram_addr_hi;
 	fcu_dram_lo_csr = handle->chip_info->fcu_dram_addr_lo;
 
-	SET_CAP_CSR(handle, fcu_dram_hi_csr, (bus_addr >> BITS_IN_DWORD));
+	SET_CAP_CSR(handle, fcu_dram_hi_csr, bus_addr >> BITS_PER_TYPE(u32));
 	SET_CAP_CSR(handle, fcu_dram_lo_csr, bus_addr);
 	SET_CAP_CSR(handle, fcu_ctl_csr, FCU_CTRL_CMD_AUTH);
 
@@ -1438,7 +1438,7 @@ static int qat_uclo_map_auth_fw(struct icp_qat_fw_loader_handle *handle,
 	virt_base = (uintptr_t)img_desc.dram_base_addr_v + simg_offset;
 	bus_addr  = img_desc.dram_bus_addr + simg_offset;
 	auth_desc = img_desc.dram_base_addr_v;
-	auth_desc->css_hdr_high = (unsigned int)(bus_addr >> BITS_IN_DWORD);
+	auth_desc->css_hdr_high = (unsigned int)(bus_addr >> BITS_PER_TYPE(u32));
 	auth_desc->css_hdr_low = (unsigned int)bus_addr;
 	virt_addr = virt_base;
 
@@ -1448,7 +1448,7 @@ static int qat_uclo_map_auth_fw(struct icp_qat_fw_loader_handle *handle,
 			   sizeof(*css_hdr);
 	virt_addr = virt_addr + sizeof(*css_hdr);
 
-	auth_desc->fwsk_pub_high = (unsigned int)(bus_addr >> BITS_IN_DWORD);
+	auth_desc->fwsk_pub_high = (unsigned int)(bus_addr >> BITS_PER_TYPE(u32));
 	auth_desc->fwsk_pub_low = (unsigned int)bus_addr;
 
 	memcpy((void *)(uintptr_t)virt_addr,
@@ -1470,7 +1470,7 @@ static int qat_uclo_map_auth_fw(struct icp_qat_fw_loader_handle *handle,
 			    auth_desc->fwsk_pub_low) +
 		   ICP_QAT_CSS_FWSK_PUB_LEN(handle);
 	virt_addr = virt_addr + ICP_QAT_CSS_FWSK_PUB_LEN(handle);
-	auth_desc->signature_high = (unsigned int)(bus_addr >> BITS_IN_DWORD);
+	auth_desc->signature_high = (unsigned int)(bus_addr >> BITS_PER_TYPE(u32));
 	auth_desc->signature_low = (unsigned int)bus_addr;
 
 	memcpy((void *)(uintptr_t)virt_addr,
@@ -1484,7 +1484,7 @@ static int qat_uclo_map_auth_fw(struct icp_qat_fw_loader_handle *handle,
 		   ICP_QAT_CSS_SIGNATURE_LEN(handle);
 	virt_addr += ICP_QAT_CSS_SIGNATURE_LEN(handle);
 
-	auth_desc->img_high = (unsigned int)(bus_addr >> BITS_IN_DWORD);
+	auth_desc->img_high = (unsigned int)(bus_addr >> BITS_PER_TYPE(u32));
 	auth_desc->img_low = (unsigned int)bus_addr;
 	auth_desc->img_len = size - ICP_QAT_AE_IMG_OFFSET(handle);
 	if (bus_addr + auth_desc->img_len > img_desc.dram_bus_addr +
@@ -1507,12 +1507,12 @@ static int qat_uclo_map_auth_fw(struct icp_qat_fw_loader_handle *handle,
 				    auth_desc->img_ae_mode_data_low) +
 			   sizeof(struct icp_qat_simg_ae_mode);
 
-		auth_desc->img_ae_init_data_high = (unsigned int)
-						 (bus_addr >> BITS_IN_DWORD);
+		auth_desc->img_ae_init_data_high =
+			(unsigned int)(bus_addr >> BITS_PER_TYPE(u32));
 		auth_desc->img_ae_init_data_low = (unsigned int)bus_addr;
 		bus_addr += ICP_QAT_SIMG_AE_INIT_SEQ_LEN;
-		auth_desc->img_ae_insts_high = (unsigned int)
-					     (bus_addr >> BITS_IN_DWORD);
+		auth_desc->img_ae_insts_high =
+			(unsigned int)(bus_addr >> BITS_PER_TYPE(u32));
 		auth_desc->img_ae_insts_low = (unsigned int)bus_addr;
 		virt_addr += sizeof(struct icp_qat_css_hdr);
 		virt_addr += ICP_QAT_CSS_FWSK_PUB_LEN(handle);

base-commit: ee4196b649445942c9a05b388ee9f02f73feeb86
-- 
2.40.1

