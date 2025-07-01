Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C3B81DF73A
	for <linux-crypto@vger.kernel.org>; Tue,  1 Jul 2025 09:47:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751363259; cv=none; b=u05796aIepLGqixM6ID1ZloRRDshtYdS1Z7vZfZLX69d5XLhBJFtHT194HXEMPgK3l8yCbAIDBpsLAJOOnsH8G/K4lgqRzoTC/h4MsTcpMybKvG+poVqXYJj04egFui/dkayKkrhbZahdiTPMdI3aMHy6CkpRcmLdcVKJ1cpx8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751363259; c=relaxed/simple;
	bh=eB3SMAxLw88teVb2YTbxy7MMWXKx8JY5e4gtUt+0zh4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=kvpEjxHbGjcsJuk9sbviPb3+f4xTg9jVwsT+0bJU0LDzrwVRKP3UouPl9aIPJdUAAbdgH8nCNXuI8ujB3aVc2WvgPhHdqHAaPia+3gUAQfPvrQc8yu40LV4RcNuTMwRSln4hz35OL04j0Fr7X3otPym8jSpABC4GEBcwnw1b490=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mhpkR2h2; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mhpkR2h2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751363258; x=1782899258;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=eB3SMAxLw88teVb2YTbxy7MMWXKx8JY5e4gtUt+0zh4=;
  b=mhpkR2h24DfNODmy1ztZ6Pw138yBIDi4tHhxbu2oALLnz35Iq9geC3Dx
   m7Tg2KwEoUi+z5fAJM3MH8DK8hdyeBAnscQ8NSSHZXsYX+jdLow60XDJE
   Qh+Lpd5yCureWNP3vWbd1vyiDLomYOGttLU+rf6w0vT4jP7Qg1jnc6Z5j
   k2WyODRuOU4Bu+kSeBfXFFHX16lCvs+Z7NWcGWHHdkPnz8mQ5+BuiOw/X
   OCT8OhURWokIxLDm8dZvBvGfRldxGI4ba2kcp3Q97bz7W/QzRN/kOMTxj
   nmsd2RXFZJ1GB2ULEgrkphCfiU8rco2G+qsAO9LWa6AZ0DScqNM3ulqst
   Q==;
X-CSE-ConnectionGUID: iEVsXI/bQTCXCZLElRKJ/g==
X-CSE-MsgGUID: 91fF7KF4SYuKj9W6V6n9Rw==
X-IronPort-AV: E=McAfee;i="6800,10657,11480"; a="53483462"
X-IronPort-AV: E=Sophos;i="6.16,279,1744095600"; 
   d="scan'208";a="53483462"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2025 02:47:36 -0700
X-CSE-ConnectionGUID: Jfmr5MfkQxy0PJnKajxe3Q==
X-CSE-MsgGUID: mYwt3ObTQomDHlybCGLpvA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,279,1744095600"; 
   d="scan'208";a="154030051"
Received: from t21-qat.iind.intel.com ([10.49.15.35])
  by fmviesa009.fm.intel.com with ESMTP; 01 Jul 2025 02:47:34 -0700
From: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com
Subject: [PATCH 0/5] crypto: qat - refactor and add live migration enablers for GEN6 devices
Date: Tue,  1 Jul 2025 10:47:25 +0100
Message-Id: <20250701094730.227991-1-suman.kumar.chakraborty@intel.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This patch series focuses on adding enablers required for live migration
for QAT GEN6 devices and improving code reuse and maintainability across
different QAT generations. The changes include refactoring shared logic,
relocating reusable functionality, and improving code clarity and debugging
support.

In detail:
Patch #1 improves logging consistency.
Patch #2 improves state checking logic.
Patch #3 relocates bank state helper functions to a new file.
Patch #4 relocates and renames the bank state structure
Patch #5 add enablers for live migration for QAT GEN6 devices.

Małgorzata Mielnik (2):
  crypto: qat - relocate bank state helper functions
  crypto: qat - add live migration enablers for GEN6 devices

Suman Kumar Chakraborty (3):
  crypto: qat - use pr_fmt() in adf_gen4_hw_data.c
  crypto: qat - replace CHECK_STAT macro with static inline function
  crypto: qat - relocate and rename bank state structure definition

 .../intel/qat/qat_4xxx/adf_4xxx_hw_data.c     |   5 +-
 .../intel/qat/qat_6xxx/adf_6xxx_hw_data.c     |   4 +
 drivers/crypto/intel/qat/qat_common/Makefile  |   1 +
 .../intel/qat/qat_common/adf_accel_devices.h  |  38 +--
 .../intel/qat/qat_common/adf_bank_state.c     | 238 ++++++++++++++++++
 .../intel/qat/qat_common/adf_bank_state.h     |  49 ++++
 .../intel/qat/qat_common/adf_gen4_hw_data.c   | 199 +--------------
 .../intel/qat/qat_common/adf_gen4_hw_data.h   |   7 -
 .../intel/qat/qat_common/adf_gen4_vf_mig.c    |   7 +-
 .../intel/qat/qat_common/adf_gen6_shared.c    |   7 +
 .../intel/qat/qat_common/adf_gen6_shared.h    |   2 +
 11 files changed, 314 insertions(+), 243 deletions(-)
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_bank_state.c
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_bank_state.h


base-commit: 65433cdeb0bdd0ebd8d59edd3c2e6d5cbef787c3
-- 
2.40.1

