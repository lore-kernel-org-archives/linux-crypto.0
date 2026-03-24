Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75D723A3E69
	for <linux-crypto@vger.kernel.org>; Tue, 24 Mar 2026 18:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774376961; cv=none; b=dmNKqmJJ9StJn51R5Oi1+2LVLvVE9/3VXw4l1ws/D1EwpSIzDB8yPwcEZvt1hq3EAFxBKated2QSj80yNL8xIdmhKZaARkzeB/d+q3VBBMXxc12FAZv2O2HTqITa9Oh7xWprc61bUwXgnRKfEmgQ0H8JsCHFWyJMl0RKqS3D/To=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774376961; c=relaxed/simple;
	bh=CSOzL48peOt1Ul9PHLo64FCrVIrnooxqRYiSe08+skc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cNdFPmZ62yY3n0i+WiIxXcIrmjQJupcq9klGuJQ5YOD8LUUiVMcp8b88udziekSrxoxwopcLrVEM4MdcPy8BBv4XX0tPeGacohpi2WzDPs/jECn8727T5Wpx08Nre2SFKEMr3m6BMQ91PN2L8Q9PHgswjqQ3KuPqLGuRxgKB3Ps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eow2nQHu; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eow2nQHu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774376961; x=1805912961;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=CSOzL48peOt1Ul9PHLo64FCrVIrnooxqRYiSe08+skc=;
  b=eow2nQHuCVZvDAwJ96JDe4yWsgvd3Gn25U2G0vCM4JkAB4j/5gDPO30C
   tX5SYGx3HWZqm7TgaGYsiRy0hLl1gdaP+5fwyiHCaJ4V089abtxq8Yqf6
   iUDd8S8/J5sw4acvpcYbmY4I20fV9SRtSCB9i5ABM5rzICHNraqq+ha1j
   yrFU9hiMGoqpQz1RYhzsI73GLGwaktGtcUkI7fSULH8MMMIxw471fb4sH
   dzGwahVU9aMQ7F8W2dqV4WwgXngei/RKjcza6x3PWmu2PGOYW3pcY1a1I
   mc72U8ndP/Aw5HVSVULV5GK9znppg+I6X9+onQ5dmiAqdxCcICe/Ks/11
   Q==;
X-CSE-ConnectionGUID: Lrr/cP6eSTmPdOAL53Ms1Q==
X-CSE-MsgGUID: eVZHndkQQsyave7K+GsIrw==
X-IronPort-AV: E=McAfee;i="6800,10657,11739"; a="86881267"
X-IronPort-AV: E=Sophos;i="6.23,138,1770624000"; 
   d="scan'208";a="86881267"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2026 11:29:20 -0700
X-CSE-ConnectionGUID: YVScqp44T9CwCBbz4IDIrA==
X-CSE-MsgGUID: jFQ4+JHRTPqxb9d7dj5VWw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,138,1770624000"; 
   d="scan'208";a="219563023"
Received: from silpixa00401971.ir.intel.com ([10.20.226.106])
  by fmviesa006.fm.intel.com with ESMTP; 24 Mar 2026 11:29:18 -0700
From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: herbert@gondor.apana.org.au,
	vinicius.gomes@intel.com,
	kristen.c.accardi@intel.com
Cc: linux-crypto@vger.kernel.org,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH] crypto: iaa - fix per-node CPU counter reset in rebalance_wq_table()
Date: Tue, 24 Mar 2026 18:29:05 +0000
Message-ID: <20260324182912.123665-1-giovanni.cabiddu@intel.com>
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
-- 
2.53.0

