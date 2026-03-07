Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F1441F4615
	for <linux-crypto@vger.kernel.org>; Fri,  6 Mar 2026 22:08:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772834941; cv=none; b=tiuQKG9d0YzaAM0o7CegAcN4gAJr10SjMW6GIPmQ1nqq0YA1mdcH6M+7AtU/1Z4zgoejJyj2WcF71Un/iMjeIDX63IPeme11d0pSPLa0FZfwf9oTgbcfJ9Wh/uoswbCxQ7ZASzW6XnIR2l1+H+OxjVYxbO+D6WbBhBEO7fIKNW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772834941; c=relaxed/simple;
	bh=WPEhKQmsV5Iyry/qGkL0+CGFFzMLg/imLmfAHIEGhWY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Xw2U1/7cKPWjj3XUEVxv/KkIYiQFS7AiipM5UetRR22GiploCQAnTMl++ePzT9oVNeoAs/lHjW0fE+7muh+JDd962PBRKlKR8Xgp8pP2sNbL5li8DDVmZ0A/cjG1ezRhCwKgduFCGwoFdqY4RFjURF/3Nw68zJbzLMe2/gl+B+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gIQJYEcq; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gIQJYEcq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772834940; x=1804370940;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=WPEhKQmsV5Iyry/qGkL0+CGFFzMLg/imLmfAHIEGhWY=;
  b=gIQJYEcqPVhUP50FQQF5drn2N2PW3dzpMLGtpRcv1S08AZquhG5VQwvk
   QmAuiwKGIFxWcy7fg/qDCq/PsSW0K13UfQZ2R0kiiK+BdrehsNphiZWUD
   W9T+rlRwEEeIHqGrLqLtO/xgZRlkKSCWSZg922dI0eul8GLYEeTD9SErZ
   uiYA1pPpxhz+14Yw1FmWyqbMrOeCAHLDRN4iHujuh5GenoLrLoht2JM1b
   1wX4S0DGT8GxUfyLp8WCRlsarNWYtrOPxumEoRK/tUvYPdNUEBUnjexn7
   Oia1DOcBMv3jLLhEuonh1HfMNxzEfI7n0qlL16BZVEMlFl+Kk93n3+dfe
   Q==;
X-CSE-ConnectionGUID: ACD4iXuIQ1eiYNhhiELgeg==
X-CSE-MsgGUID: oXP7q/6RQWCpBqlg4fDoeA==
X-IronPort-AV: E=McAfee;i="6800,10657,11721"; a="73649682"
X-IronPort-AV: E=Sophos;i="6.23,105,1770624000"; 
   d="scan'208";a="73649682"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2026 14:09:00 -0800
X-CSE-ConnectionGUID: TkMLw01aQoefQ7AiNoQ3Zw==
X-CSE-MsgGUID: TPAqlWTJSgOXU2pVrtr1dg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,105,1770624000"; 
   d="scan'208";a="219074850"
Received: from silpixa00401971.ir.intel.com ([10.20.226.106])
  by orviesa009.jf.intel.com with ESMTP; 06 Mar 2026 14:08:59 -0800
From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH 1/8] crypto: iaa - fix per-node CPU counter reset in rebalance_wq_table()
Date: Sat,  7 Mar 2026 03:09:56 +0000
Message-ID: <20260307031003.28499-1-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit

The cpu counter used to compute the IAA device index is reset to zero
at the start of each NUMA node iteration. This causes CPUs on every
node to map starting from IAA index 0 instead of continuing from the
previous node's last index. On multi-node systems, this results in all
nodes mapping their CPUs to the same initial set of IAA devices,
leaving higher-indexed devices unused.

Move the cpu counter initialization before the for_each_node_with_cpus()
loop so that the IAA index computation accumulates correctly across all
nodes.

Fixes: 714ca27e9bf4 ("crypto: iaa - Optimize rebalance_wq_table()")
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/intel/iaa/iaa_crypto_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/intel/iaa/iaa_crypto_main.c b/drivers/crypto/intel/iaa/iaa_crypto_main.c
index 547abf453d4a..f62b994e18e5 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -906,8 +906,8 @@ static void rebalance_wq_table(void)
 		return;
 	}
 
+	cpu = 0;
 	for_each_node_with_cpus(node) {
-		cpu = 0;
 		node_cpus = cpumask_of_node(node);
 
 		for_each_cpu(node_cpu, node_cpus) {

base-commit: a861d7b937a278f462a70311670ab1f13febb6d8
-- 
2.53.0

