Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC1BC1DF73A
	for <linux-crypto@vger.kernel.org>; Tue,  1 Jul 2025 09:47:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751363261; cv=none; b=Db0j3DgfiS7dLT3ZuQtXDdGu5/gUXcl1hed3vuFO5+G3/Y3Qkd7ly29hvHXlGyHWg1r3sFrySMhCQZnmZgFek9NjR255n2mEthaayrK5XvofnKuPy7o/Ih8VnH1FrKjX20dVpqkwOPgCGAPHfCZBIKIK00+nRAWbJlQEIQIXd7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751363261; c=relaxed/simple;
	bh=176W9+KLY/S11HlRWzqCZtXCW6lJLG83Y8h64Rpa6dU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=YUjE5mRnG3k13xrb5jRPxxmmGg6yWHS6bVy+UO5YDxehZnzpNz7auf2uYYNpd+trw93AJc1sEBMOLSKHNNzeVH13sGpIH0eYSjaAnz7N7BR66H4cpLl3u3lexBZkrEO9fowJ6xeJ/t4f+m9eOoIXcwZf+3G8SghW03baf08iKyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aIZTsnTx; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aIZTsnTx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751363260; x=1782899260;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=176W9+KLY/S11HlRWzqCZtXCW6lJLG83Y8h64Rpa6dU=;
  b=aIZTsnTx5IS41/OByCZ6eZa5xi33WmMkHSph4lDGticRfHmmY7TuV7RF
   zcq/7gqiwl6yDSJzJNdriejrnVm55FAkCTBXzNj87i5Y75bxkZ3IM2OoM
   P++Gf08KYzD3/7yM+nprRb1ev8eOcCP5J8E7nDGCNfiuDw1ifLJWDOArB
   l+5Sb5inASE/jg/aiS8mKx3tf0scJCHYtYg5W5MQJ0yMeYjMftIbw9aJM
   4Y1Exs5pJCSiF/5VfPzZUqO4hYGCqD1dIUvRW5w33j/Upv+A4VmURjuOc
   EKD6rsqONV1ObKiPxIwL4iZMSQaT2aRZU7TI9BCnfN7l4pDOZbVpLQwDX
   w==;
X-CSE-ConnectionGUID: j/MUz5p/Rj66fd2mnbKGZg==
X-CSE-MsgGUID: spwDDvZdT9OpoQQm6K1+Wg==
X-IronPort-AV: E=McAfee;i="6800,10657,11480"; a="53483467"
X-IronPort-AV: E=Sophos;i="6.16,279,1744095600"; 
   d="scan'208";a="53483467"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2025 02:47:39 -0700
X-CSE-ConnectionGUID: euZo3Ro2QAWVQIVXk60Sxw==
X-CSE-MsgGUID: MXwM1XTuRM2AbxHotnYh9Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,279,1744095600"; 
   d="scan'208";a="154030064"
Received: from t21-qat.iind.intel.com ([10.49.15.35])
  by fmviesa009.fm.intel.com with ESMTP; 01 Jul 2025 02:47:37 -0700
From: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com
Subject: [PATCH 2/5] crypto: qat - replace CHECK_STAT macro with static inline function
Date: Tue,  1 Jul 2025 10:47:27 +0100
Message-Id: <20250701094730.227991-3-suman.kumar.chakraborty@intel.com>
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

The macro CHECK_STAT is used to check that all ring statuses match the
saved state during restoring the state of bank.

Replace the CHECK_STAT macro with the static inline function `check_stat()`
to improve type safety, readability, and debuggability.

This does not introduce any functional change.

Signed-off-by: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
---
 .../intel/qat/qat_common/adf_gen4_hw_data.c   | 33 +++++++++++--------
 1 file changed, 19 insertions(+), 14 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_gen4_hw_data.c b/drivers/crypto/intel/qat/qat_common/adf_gen4_hw_data.c
index e6a8954cbef1..b5eef5235b61 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_gen4_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_gen4_hw_data.c
@@ -521,14 +521,19 @@ static void bank_state_save(struct adf_hw_csr_ops *ops, void __iomem *base,
 	}
 }
 
-#define CHECK_STAT(op, expect_val, name, args...) \
-({ \
-	u32 __expect_val = (expect_val); \
-	u32 actual_val = op(args); \
-	(__expect_val == actual_val) ? 0 : \
-		(pr_err("Fail to restore %s register. Expected 0x%x, actual 0x%x\n", \
-			name, __expect_val, actual_val), -EINVAL); \
-})
+static inline int check_stat(u32 (*op)(void __iomem *, u32), u32 expect_val,
+			     const char *name, void __iomem *base, u32 bank)
+{
+	u32 actual_val = op(base, bank);
+
+	if (expect_val == actual_val)
+		return 0;
+
+	pr_err("Fail to restore %s register. Expected %#x, actual %#x\n",
+	       name, expect_val, actual_val);
+
+	return -EINVAL;
+}
 
 static int bank_state_restore(struct adf_hw_csr_ops *ops, void __iomem *base,
 			      u32 bank, struct bank_state *state, u32 num_rings,
@@ -611,32 +616,32 @@ static int bank_state_restore(struct adf_hw_csr_ops *ops, void __iomem *base,
 	ops->write_csr_ring_srv_arb_en(base, bank, state->ringsrvarben);
 
 	/* Check that all ring statuses match the saved state. */
-	ret = CHECK_STAT(ops->read_csr_stat, state->ringstat0, "ringstat",
+	ret = check_stat(ops->read_csr_stat, state->ringstat0, "ringstat",
 			 base, bank);
 	if (ret)
 		return ret;
 
-	ret = CHECK_STAT(ops->read_csr_e_stat, state->ringestat, "ringestat",
+	ret = check_stat(ops->read_csr_e_stat, state->ringestat, "ringestat",
 			 base, bank);
 	if (ret)
 		return ret;
 
-	ret = CHECK_STAT(ops->read_csr_ne_stat, state->ringnestat, "ringnestat",
+	ret = check_stat(ops->read_csr_ne_stat, state->ringnestat, "ringnestat",
 			 base, bank);
 	if (ret)
 		return ret;
 
-	ret = CHECK_STAT(ops->read_csr_nf_stat, state->ringnfstat, "ringnfstat",
+	ret = check_stat(ops->read_csr_nf_stat, state->ringnfstat, "ringnfstat",
 			 base, bank);
 	if (ret)
 		return ret;
 
-	ret = CHECK_STAT(ops->read_csr_f_stat, state->ringfstat, "ringfstat",
+	ret = check_stat(ops->read_csr_f_stat, state->ringfstat, "ringfstat",
 			 base, bank);
 	if (ret)
 		return ret;
 
-	ret = CHECK_STAT(ops->read_csr_c_stat, state->ringcstat0, "ringcstat",
+	ret = check_stat(ops->read_csr_c_stat, state->ringcstat0, "ringcstat",
 			 base, bank);
 	if (ret)
 		return ret;
-- 
2.40.1

