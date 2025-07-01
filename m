Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C4061F239B
	for <linux-crypto@vger.kernel.org>; Tue,  1 Jul 2025 09:47:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751363260; cv=none; b=NSF/h/DTzON/fPWVK/tjBRKgTzeJAedAm0RwhOj11gBd2kYH0CQUAil+3pD6JX/x3/2olVmNLLzq0ZjVymnHNUoLs2XOANEnF9sO9VAjWC/STorG2Cr/EhQEjp5j23KqNUJny8jDg7tgvOiwQrO1H79Ezinvk2pzeU2slooWoOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751363260; c=relaxed/simple;
	bh=+jTZ6zLEajSIYrQyP0lnzGQTvYYyXtsbRGoyl1KtW8I=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fUWaI1C4IaoG2w1X+wYJk5cp5Zl8RWQEZ2YZXNmiVL9akUBMZNZ0hoetZaz9Rmv6MPnW5BhhFhRM6mMHCxojkipFqf+8Isfui3ZMIlfMX/ldrArRB1jNIMc73wRHFO/wLt/nmOomM6yf+laN+p1SBvvEEvcdPDYrtN5M1vOjLj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gosMiqJw; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gosMiqJw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751363258; x=1782899258;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+jTZ6zLEajSIYrQyP0lnzGQTvYYyXtsbRGoyl1KtW8I=;
  b=gosMiqJwDXbZREtkgB+y4pzjN9jK3Zu6e4b/FK9nbrekR6cOnYuAJPiM
   Wn5z7Q4HfcR+1rJDI+W74xvLiUpDzgTDE22YQbXc5MAFqvFvzgrb9A8qS
   x7fFJs7sR8zGwPYU3wGl4xNwgVcJCzphDNifslVNlQyqiTuCwW2pSQodj
   o8V4wgE93pkf/M+LWVph/1oe0wbXsPk+TRx9AtwlrlItm6hHYHKX8ds3+
   iqK+9N2qst0qcIM0wGLJ7AIyc54+OZ55Kt2PfG+eOy7186wDePHXgG+RC
   5ygjMdQzeVTN8FNvACY8a2CQQf+/7S+2aI8m6LYTp+xyf4ToCENkqhNtp
   w==;
X-CSE-ConnectionGUID: wk0MN3LETMafXzfqw3omlQ==
X-CSE-MsgGUID: CW8/cMNIROKzw48EJWe4Hg==
X-IronPort-AV: E=McAfee;i="6800,10657,11480"; a="53483464"
X-IronPort-AV: E=Sophos;i="6.16,279,1744095600"; 
   d="scan'208";a="53483464"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2025 02:47:37 -0700
X-CSE-ConnectionGUID: KfLLRjQhRf2gr5FvsHoiYA==
X-CSE-MsgGUID: s+RpdpyoTOmqkrgmY4ShDQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,279,1744095600"; 
   d="scan'208";a="154030056"
Received: from t21-qat.iind.intel.com ([10.49.15.35])
  by fmviesa009.fm.intel.com with ESMTP; 01 Jul 2025 02:47:36 -0700
From: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com
Subject: [PATCH 1/5] crypto: qat - use pr_fmt() in adf_gen4_hw_data.c
Date: Tue,  1 Jul 2025 10:47:26 +0100
Message-Id: <20250701094730.227991-2-suman.kumar.chakraborty@intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20250701094730.227991-1-suman.kumar.chakraborty@intel.com>
References: <20250701094730.227991-1-suman.kumar.chakraborty@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add pr_fmt() to adf_gen4_hw_data.c logging and update the debug and error
messages to utilize it accordingly.

This does not introduce any functional changes.

Signed-off-by: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
---
 drivers/crypto/intel/qat/qat_common/adf_gen4_hw_data.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_gen4_hw_data.c b/drivers/crypto/intel/qat/qat_common/adf_gen4_hw_data.c
index 258adc0b49e0..e6a8954cbef1 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_gen4_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_gen4_hw_data.c
@@ -1,5 +1,8 @@
 // SPDX-License-Identifier: (BSD-3-Clause OR GPL-2.0-only)
 /* Copyright(c) 2020 Intel Corporation */
+
+#define pr_fmt(fmt)	"QAT: " fmt
+
 #include <linux/bitops.h>
 #include <linux/iopoll.h>
 #include <asm/div64.h>
@@ -523,7 +526,7 @@ static void bank_state_save(struct adf_hw_csr_ops *ops, void __iomem *base,
 	u32 __expect_val = (expect_val); \
 	u32 actual_val = op(args); \
 	(__expect_val == actual_val) ? 0 : \
-		(pr_err("QAT: Fail to restore %s register. Expected 0x%x, actual 0x%x\n", \
+		(pr_err("Fail to restore %s register. Expected 0x%x, actual 0x%x\n", \
 			name, __expect_val, actual_val), -EINVAL); \
 })
 
@@ -593,7 +596,7 @@ static int bank_state_restore(struct adf_hw_csr_ops *ops, void __iomem *base,
 	 */
 	val = state->ringexpstat;
 	if (val) {
-		pr_info("QAT: Bank %u state not fully restored due to exception in saved state (%#x)\n",
+		pr_info("Bank %u state not fully restored due to exception in saved state (%#x)\n",
 			bank, val);
 		return 0;
 	}
@@ -601,8 +604,7 @@ static int bank_state_restore(struct adf_hw_csr_ops *ops, void __iomem *base,
 	/* Ensure that the restoration process completed without exceptions */
 	tmp_val = ops->read_csr_exp_stat(base, bank);
 	if (tmp_val) {
-		pr_err("QAT: Bank %u restored with exception: %#x\n",
-		       bank, tmp_val);
+		pr_err("Bank %u restored with exception: %#x\n", bank, tmp_val);
 		return -EFAULT;
 	}
 
-- 
2.40.1

