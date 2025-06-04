Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4178D18E1F
	for <linux-crypto@vger.kernel.org>; Wed,  4 Jun 2025 16:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749052817; cv=none; b=npRcnp0XTQCVFbiNgJWg85ecux0u9xXYTmA9NpTsHTMlA1hRgRh7qF8AYTJ5DqnMV5aSG7VOnpVR4vGCZO+15A9vPzjV8VStfl7qvlBCyjqCTQLcsjMvi1hpW8y2qVUoO4DPbLo/R4mtVuOnofMJD/R9igkKpgayfOqLRz2LjJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749052817; c=relaxed/simple;
	bh=ztKV5dovRv6t9eKGojAmhhZV/rc0e0y8ab7nVS1tj70=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nBIUuBHW58MrhUsq44k9pkm8dbGgyQmxEzuqyfib14yzWQY+xLNUkomqWonhxj94Fncs7MMNx7LVNARCLHZZ8jweR5uJKYrUFr01MShV5Yl+WGQi4Dig5ErUlG9tXckCvzj9vvYS2gnMtSnCX1XwSelq1fQlwl91uYyMsBjT58g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bzQU9IyR; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bzQU9IyR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749052815; x=1780588815;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=ztKV5dovRv6t9eKGojAmhhZV/rc0e0y8ab7nVS1tj70=;
  b=bzQU9IyR8JypDXWtr3ILif+CieUnAam1o3lZmKUn+91cNYZ/c8GyO1Ib
   Zvpkr8+juq+zq0Ix3hoix9xc/5r89J06GuwLqQGdsKZKAvuofWjH3jizS
   zLisDc5grPd5VTBhx9TRbCMRV/nRkmfZn+m+ZycBKjrztplo9lJkSVWd3
   Jq9GCY0fEHSV+Nmgvw79+ALK6T2AlRDpQrsKICaClk4EVGfBCsAwJqg2o
   +FfKhCqwZTkPwIts8PTywi7NY4F5pfzr7GBkX73KAYczQXcFM7luROVFd
   gOHYhfWnFrdpVBxxmBTMBFxAY9UsLR6qdX12F7mJcVBV1NhvEsugDmJvk
   Q==;
X-CSE-ConnectionGUID: frMnc4E1RN26TgytslrvBg==
X-CSE-MsgGUID: YDtojGlrS8u6uEG+E4VjAQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11454"; a="62197308"
X-IronPort-AV: E=Sophos;i="6.16,209,1744095600"; 
   d="scan'208";a="62197308"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2025 09:00:15 -0700
X-CSE-ConnectionGUID: dmx5zy2yTQauo+uUMCdGVg==
X-CSE-MsgGUID: SIpZK0hATpucBPO28KJTWQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,209,1744095600"; 
   d="scan'208";a="176113777"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.223.204])
  by fmviesa001.fm.intel.com with ESMTP; 04 Jun 2025 09:00:14 -0700
From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	Svyatoslav Pankratov <svyatoslav.pankratov@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH] crypto: qat - fix state restore for banks with exceptions
Date: Wed,  4 Jun 2025 16:59:56 +0100
Message-ID: <20250604160006.56369-1-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit

From: Svyatoslav Pankratov <svyatoslav.pankratov@intel.com>

Change the logic in the restore function to properly handle bank
exceptions.

The check for exceptions in the saved state should be performed before
conducting any other ringstat register checks.
If a bank was saved with an exception, the ringstat will have the
appropriate rp_halt/rp_exception bits set, causing the driver to exit
the restore process with an error. Instead, the restore routine should
first check the ringexpstat register, and if any exception was raised,
it should stop further checks and return without any error. In other
words, if a ring pair is in an exception state at the source, it should
be restored the same way at the destination but without raising an error.

Even though this approach might lead to losing the exception state
during migration, the driver will log the exception from the saved state
during the restore process.

Signed-off-by: Svyatoslav Pankratov <svyatoslav.pankratov@intel.com>
Fixes: bbfdde7d195f ("crypto: qat - add bank save and restore flows")
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 .../intel/qat/qat_common/adf_gen4_hw_data.c   | 29 ++++++++++++++-----
 1 file changed, 22 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_gen4_hw_data.c b/drivers/crypto/intel/qat/qat_common/adf_gen4_hw_data.c
index 0406cb09c5bb..14d0fdd66a4b 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_gen4_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_gen4_hw_data.c
@@ -581,6 +581,28 @@ static int bank_state_restore(struct adf_hw_csr_ops *ops, void __iomem *base,
 	ops->write_csr_int_srcsel_w_val(base, bank, state->iaintflagsrcsel0);
 	ops->write_csr_exp_int_en(base, bank, state->ringexpintenable);
 	ops->write_csr_int_col_ctl(base, bank, state->iaintcolctl);
+
+	/*
+	 * Verify whether any exceptions were raised during the bank save process.
+	 * If exceptions occurred, the status and exception registers cannot
+	 * be directly restored. Consequently, further restoration is not
+	 * feasible, and the current state of the ring should be maintained.
+	 */
+	val = state->ringexpstat;
+	if (val) {
+		pr_info("QAT: Bank %u state not fully restored due to exception in saved state (%#x)\n",
+			bank, val);
+		return 0;
+	}
+
+	/* Ensure that the restoration process completed without exceptions */
+	tmp_val = ops->read_csr_exp_stat(base, bank);
+	if (tmp_val) {
+		pr_err("QAT: Bank %u restored with exception: %#x\n",
+		       bank, tmp_val);
+		return -EFAULT;
+	}
+
 	ops->write_csr_ring_srv_arb_en(base, bank, state->ringsrvarben);
 
 	/* Check that all ring statuses match the saved state. */
@@ -614,13 +636,6 @@ static int bank_state_restore(struct adf_hw_csr_ops *ops, void __iomem *base,
 	if (ret)
 		return ret;
 
-	tmp_val = ops->read_csr_exp_stat(base, bank);
-	val = state->ringexpstat;
-	if (tmp_val && !val) {
-		pr_err("QAT: Bank was restored with exception: 0x%x\n", val);
-		return -EINVAL;
-	}
-
 	return 0;
 }
 
-- 
2.49.0

