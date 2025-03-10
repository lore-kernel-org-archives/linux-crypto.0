Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0851B1BCA1B
	for <linux-crypto@vger.kernel.org>; Mon, 10 Mar 2025 16:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741623405; cv=none; b=Hl4+Xuec+NF79fz8J01/tLMvj4+eNccZEBchZsKFf3T7zVRgZ7V9wSI1tuBLeZ2XNBR6dEYRhp5BmmMmbA0nkXdxGvggRdkJPeMEFqRNYj4XjiYN7JqSltk6zTyP0WXTnIOZTaXKjgOwTWVWNxxjM2406UI4Bbjcns8b4ug5ME0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741623405; c=relaxed/simple;
	bh=8qcXoxdiD1/XTYUcsjJUPmNwmIHfPWUFQ5lVcH9tTk4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=YyvRYIIYqc5QjRTwZD5lwsNvIjxeolQcBYTj498kKIaKE1/SZCICpkJswzvzGsO5QrlkYZQSEsCCJ+FfNT1TBQWtkcJ1QRhPWvh1PkHlh+tJmk6hIqDPt2keAnRXZXl3TQSFnTGlhqkMl3/WBcqfBZ67VqsRe0aYN63da5Bh0qo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JMrQUEps; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JMrQUEps"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741623404; x=1773159404;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=8qcXoxdiD1/XTYUcsjJUPmNwmIHfPWUFQ5lVcH9tTk4=;
  b=JMrQUEpssdVWApQtFsOmKqenwOgcq7bYWnzEyzaq9GvCrJXv7YuKx1Ou
   AuBuisSz587G0Bg/vEfd5t1faUaoxjUl3n4bF5CkiroYbtS+P8rjfJ4VI
   gqH3DlaKW5WrTVEtoAhoHRT0LKDPNgDzovleLxaUc3WDCCFczH0YXDLki
   iZNjKxYdjefvTzN4xmSRWLvnTS6Itt1BKGi+kU7n2CBLEmH9+l9Gj+Scm
   OUQB0ycewZsw9SXf0Jid7OUIcxIcp2kS8koEHwYXUZNHXxeTLd9ylox5l
   Zgs4lrtrUfeQ+dmmZiWU6Ea4bVZ7L0ZQYgqtOM16ILNMBV6Mcnev39YNr
   w==;
X-CSE-ConnectionGUID: NQiqnTz1Sjmol7il2bHDaA==
X-CSE-MsgGUID: 3IjzQqUKQ7SgeV6PIPjHKA==
X-IronPort-AV: E=McAfee;i="6700,10204,11369"; a="41795469"
X-IronPort-AV: E=Sophos;i="6.14,236,1736841600"; 
   d="scan'208";a="41795469"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2025 09:16:43 -0700
X-CSE-ConnectionGUID: X6lfS+dIR1ayBUUtEVslrQ==
X-CSE-MsgGUID: UkvMN+wGQmmsKTcRLrIb3A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,236,1736841600"; 
   d="scan'208";a="143237592"
Received: from t21-qat.iind.intel.com ([10.49.15.35])
  by fmviesa002.fm.intel.com with ESMTP; 10 Mar 2025 09:16:32 -0700
From: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH] crypto: qat - add macro to write 64-bit values to registers
Date: Mon, 10 Mar 2025 16:15:40 +0000
Message-Id: <20250310161540.510166-1-suman.kumar.chakraborty@intel.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Introduce the ADF_CSR_WR_LO_HI macro to simplify writing a 64-bit values
to hardware registers.

This macro works by splitting the 64-bit value into two 32-bit segments,
which are then written separately to the specified lower and upper
register offsets.

Update the adf_gen4_set_ssm_wdtimer() function to utilize this newly
introduced macro.

Signed-off-by: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 .../intel/qat/qat_common/adf_accel_devices.h  | 10 +++++++
 .../intel/qat/qat_common/adf_gen4_hw_data.c   | 30 ++++---------------
 2 files changed, 16 insertions(+), 24 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h b/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h
index 9c15c31ad134..0509174d6030 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h
@@ -10,6 +10,7 @@
 #include <linux/ratelimit.h>
 #include <linux/types.h>
 #include <linux/qat/qat_mig_dev.h>
+#include <linux/wordpart.h>
 #include "adf_cfg_common.h"
 #include "adf_rl.h"
 #include "adf_telemetry.h"
@@ -371,6 +372,15 @@ struct adf_hw_device_data {
 /* CSR write macro */
 #define ADF_CSR_WR(csr_base, csr_offset, val) \
 	__raw_writel(val, csr_base + csr_offset)
+/*
+ * CSR write macro to handle cases where the high and low
+ * offsets are sparsely located.
+ */
+#define ADF_CSR_WR64_LO_HI(csr_base, csr_low_offset, csr_high_offset, val)	\
+do {										\
+	ADF_CSR_WR(csr_base, csr_low_offset, lower_32_bits(val));		\
+	ADF_CSR_WR(csr_base, csr_high_offset, upper_32_bits(val));		\
+} while (0)
 
 /* CSR read macro */
 #define ADF_CSR_RD(csr_base, csr_offset) __raw_readl(csr_base + csr_offset)
diff --git a/drivers/crypto/intel/qat/qat_common/adf_gen4_hw_data.c b/drivers/crypto/intel/qat/qat_common/adf_gen4_hw_data.c
index ade279e48010..099949a2421c 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_gen4_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_gen4_hw_data.c
@@ -135,36 +135,18 @@ int adf_gen4_init_device(struct adf_accel_dev *accel_dev)
 }
 EXPORT_SYMBOL_GPL(adf_gen4_init_device);
 
-static inline void adf_gen4_unpack_ssm_wdtimer(u64 value, u32 *upper,
-					       u32 *lower)
-{
-	*lower = lower_32_bits(value);
-	*upper = upper_32_bits(value);
-}
-
 void adf_gen4_set_ssm_wdtimer(struct adf_accel_dev *accel_dev)
 {
 	void __iomem *pmisc_addr = adf_get_pmisc_base(accel_dev);
 	u64 timer_val_pke = ADF_SSM_WDT_PKE_DEFAULT_VALUE;
 	u64 timer_val = ADF_SSM_WDT_DEFAULT_VALUE;
-	u32 ssm_wdt_pke_high = 0;
-	u32 ssm_wdt_pke_low = 0;
-	u32 ssm_wdt_high = 0;
-	u32 ssm_wdt_low = 0;
 
-	/* Convert 64bit WDT timer value into 32bit values for
-	 * mmio write to 32bit CSRs.
-	 */
-	adf_gen4_unpack_ssm_wdtimer(timer_val, &ssm_wdt_high, &ssm_wdt_low);
-	adf_gen4_unpack_ssm_wdtimer(timer_val_pke, &ssm_wdt_pke_high,
-				    &ssm_wdt_pke_low);
-
-	/* Enable WDT for sym and dc */
-	ADF_CSR_WR(pmisc_addr, ADF_SSMWDTL_OFFSET, ssm_wdt_low);
-	ADF_CSR_WR(pmisc_addr, ADF_SSMWDTH_OFFSET, ssm_wdt_high);
-	/* Enable WDT for pke */
-	ADF_CSR_WR(pmisc_addr, ADF_SSMWDTPKEL_OFFSET, ssm_wdt_pke_low);
-	ADF_CSR_WR(pmisc_addr, ADF_SSMWDTPKEH_OFFSET, ssm_wdt_pke_high);
+	/* Enable watchdog timer for sym and dc */
+	ADF_CSR_WR64_LO_HI(pmisc_addr, ADF_SSMWDTL_OFFSET, ADF_SSMWDTH_OFFSET, timer_val);
+
+	/* Enable watchdog timer for pke */
+	ADF_CSR_WR64_LO_HI(pmisc_addr, ADF_SSMWDTPKEL_OFFSET, ADF_SSMWDTPKEH_OFFSET,
+			   timer_val_pke);
 }
 EXPORT_SYMBOL_GPL(adf_gen4_set_ssm_wdtimer);
 

base-commit: 4d9c16a296d6ae3931422232f35836753ddf09ef
-- 
2.40.1

