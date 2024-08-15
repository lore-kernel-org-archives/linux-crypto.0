Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B83821A4F3B
	for <linux-crypto@vger.kernel.org>; Thu, 15 Aug 2024 15:47:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723736867; cv=none; b=scEjQ2QWzrFHJWpLxhqcf0QZeFVlql77tX7sv+wsu/qNLjbdmQER3LxyFMzhqcmp8aZ9cSat03EYo8H4rkTUdbsUBjn8qtIltPtvys2re7m6pPlzwPTyj9uuWeTCvzfvoAbe79URZEj+0z1hGUsc2vKS3uijSUAMJrfeF51pHOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723736867; c=relaxed/simple;
	bh=SvhQpCNcs3mmMcG1e3L+tvHsMrvfKazmVV9jnz7bOr4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZhGbKSae8+MxKajtuJzSfW0bgvnn+ZQYUF2Gh6mTmeVj70Yc729GmxNPxIe6fC/E0BJGJJMnCJroQBcxdOJgumRVh7h7UhIjZWkzlFlDZ6ISrRz3ax75Al9a8GZR/5bsegGD57a8BoGjQ03ugCOjInAYNrL1cFvWu7O9YEtP88U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=he7tKCmG; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="he7tKCmG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723736865; x=1755272865;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=SvhQpCNcs3mmMcG1e3L+tvHsMrvfKazmVV9jnz7bOr4=;
  b=he7tKCmGkge1sHWWKdyEa91eohWllr0/hKBNnh4daG5TXOlyudQPT0Rm
   QeymZaAbJkxKQX4nEGhOYJ/4DFek8AqUZceybXYwwe9z7FXd7aW43mevV
   WObHOB6mmxI+gECc+iAcJBWXzGSrzr0u/fovWW4B7ChvUChSD3zvcFDLU
   JOcMDSb/Nd4s5cJcY1j5MRJ4dTmUPJnSGld1ou6vNjfobjS5igikvxgTb
   ZeEaHvHbvE1iJC+sKQ/uU6f3abaUGVQygKcGtQUOff+Y0bw87gPXWlcQZ
   34uwaru8IsxKYyQ0KY3EmzupuMKsC/YnUr2g7BktG8m3ZNcwTJkKLzFCR
   w==;
X-CSE-ConnectionGUID: TEI9DVAvTjepUbX1rzgEaA==
X-CSE-MsgGUID: e3n2y4L/REOvbrh15TvTuQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11165"; a="44521642"
X-IronPort-AV: E=Sophos;i="6.10,149,1719903600"; 
   d="scan'208";a="44521642"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2024 08:47:45 -0700
X-CSE-ConnectionGUID: AV7PPta5QcWi3wFaD1/sVw==
X-CSE-MsgGUID: 5Fbqc0J1S5WUcpEDUj5yrg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,149,1719903600"; 
   d="scan'208";a="64273974"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.223.156])
  by orviesa005.jf.intel.com with ESMTP; 15 Aug 2024 08:47:44 -0700
From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	Svyatoslav Pankratov <svyatoslav.pankratov@intel.com>,
	Xin Zeng <xin.zeng@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH] crypto: qat - fix "Full Going True" macro definition
Date: Thu, 15 Aug 2024 16:47:23 +0100
Message-ID: <20240815154736.58269-1-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit

From: Svyatoslav Pankratov <svyatoslav.pankratov@intel.com>

The macro `ADF_RP_INT_SRC_SEL_F_RISE_MASK` is currently set to the value
`0100b` which means "Empty Going False". This might cause an incorrect
restore of the bank state during live migration.

Fix the definition of the macro to properly represent the "Full Going
True" state which is encoded as `0011b`.

Fixes: bbfdde7d195f ("crypto: qat - add bank save and restore flows")
Signed-off-by: Svyatoslav Pankratov <svyatoslav.pankratov@intel.com>
Reviewed-by: Xin Zeng <xin.zeng@intel.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/intel/qat/qat_common/adf_gen4_hw_data.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_gen4_hw_data.h b/drivers/crypto/intel/qat/qat_common/adf_gen4_hw_data.h
index 8b10926cedba..e8c53bd76f1b 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_gen4_hw_data.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_gen4_hw_data.h
@@ -83,7 +83,7 @@
 #define ADF_WQM_CSR_RPRESETSTS(bank)	(ADF_WQM_CSR_RPRESETCTL(bank) + 4)
 
 /* Ring interrupt */
-#define ADF_RP_INT_SRC_SEL_F_RISE_MASK	BIT(2)
+#define ADF_RP_INT_SRC_SEL_F_RISE_MASK	GENMASK(1, 0)
 #define ADF_RP_INT_SRC_SEL_F_FALL_MASK	GENMASK(2, 0)
 #define ADF_RP_INT_SRC_SEL_RANGE_WIDTH	4
 #define ADF_COALESCED_POLL_TIMEOUT_US	(1 * USEC_PER_SEC)
-- 
2.46.0

