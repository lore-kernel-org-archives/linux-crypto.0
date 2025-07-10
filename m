Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE08E25B2FE
	for <linux-crypto@vger.kernel.org>; Thu, 10 Jul 2025 13:33:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752154435; cv=none; b=ekfxQzm1Y5lSMkp3GIL/fxdMK4gfeNTuqJsgkgL3oG9rS14xvzEkNZpaqte/vXfqP/vf71xRL647vBofFLCqmTpv2UIW8f+sPq4tK0v4/2yQ7QJ1zsWBS/7Fx86yjG7jE751683PhEiIxppTfSgR+jEPojHqiNP+JaWtT1+rmI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752154435; c=relaxed/simple;
	bh=w+5SNYhGT3NnWFV616HToReqsrh5JVJmWDmMCBCDdNc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=O/0jeDA/DwjIcAab8D3JC6tMV2g7opxv1fvXLgT1KqTdfBuq5BGWfjj4WSIvGvLyrXuMacYDoHafDYpFSdviqRSAX5zi6dNwThmv3Mb3ZyJSNqSXFynqtNuoKk0zddsyCk2UOemx7gUub/w52fO8CcHCCke77pzu9aMmNA5xqB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kfR/2yVm; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kfR/2yVm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752154434; x=1783690434;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=w+5SNYhGT3NnWFV616HToReqsrh5JVJmWDmMCBCDdNc=;
  b=kfR/2yVm+AWtPo+FyP8f2/BImzXYcEeGzUNQ+GjffzY++kdQhelFST62
   5TFukY8nM9+G0/BgFfb7himK81S+eKS8GgeZyOb1qcU8NpS1QXG4KH44U
   /vkBeUBLBbq9UX+JjJkBHng2M0Af1+gYsg0urfVqbRneQS7R1lJ8as2C6
   emra0SfkFJAH35U13Yb5QRmyvIZJJqUYvo2IG+jSkC4HMfuVrqinDH/xK
   fvqv9PlbQHe2AVk+7+HZ3oi1XboGMkqHkE5eGfPm6NHcS/0ECtlo3Q/ML
   X/ahDxhOUR1fNE3KCLj0g/kc9GbMc8ivSn222IhDQ5Ty+PODNGcrQWfVj
   A==;
X-CSE-ConnectionGUID: KwAnjtlfToe4e7XzLrHShg==
X-CSE-MsgGUID: RNBDDQLgR4meKNAhRc1jtQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11490"; a="58241829"
X-IronPort-AV: E=Sophos;i="6.16,300,1744095600"; 
   d="scan'208";a="58241829"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2025 06:33:52 -0700
X-CSE-ConnectionGUID: Ya8lv9XqSdSTtrzriDrRQw==
X-CSE-MsgGUID: rLlYnVXJTS2mroTmVMantQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,300,1744095600"; 
   d="scan'208";a="155494638"
Received: from t21-qat.iind.intel.com ([10.49.15.35])
  by orviesa006.jf.intel.com with ESMTP; 10 Jul 2025 06:33:50 -0700
From: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com
Subject: [PATCH 0/8] crypto: qat - add rate limiting (RL) support for GEN6 devices
Date: Thu, 10 Jul 2025 14:33:39 +0100
Message-Id: <20250710133347.566310-1-suman.kumar.chakraborty@intel.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch set introduces and extends the rate limiting (RL) infrastructure
in the Intel QAT (QuickAssist Technology) driver, with a focus on enabling
RL support for QAT GEN6 devices and enhancing support for decompression
service.

The series begins by enforcing service validation in the RL sysfs API to
prevent misconfiguration. It then adds decompression (DECOMP) service,
including its enumeration and visibility via sysfs. Subsequently, service
enums are refactored and consolidated to remove duplication and clearly
differentiate between base and extended services.

Further patches improve modularity by relocating is_service_enabled() into
the appropriate C file, introduce a flexible mechanism using
adf_rl_get_num_svc_aes() and get_svc_slice_cnt() APIs, and implement these
for both GEN4 and GEN6 platforms. Additionally, the compression slice count
(cpr_cnt) is now cached for use within the RL infrastructure.

Finally, the series enables full RL support for GEN6 by initializing the
rl_data and implementing platform-specific logic to query acceleration
engines and slice counts for QAT GEN6 hardware.

Summary of Changes:

Patch #1 Validates service in RL sysfs API.
Patch #2 Adds decompression (DECOMP) service to RL to enable SLA support for
	 DECOMP where supported (e.g., GEN6).
Patch #3 Consolidated the service enums.
Patch #4 Relocates the is_service_enabled() function to improve modularity and
	 aligns code structure.
Patch #5 Adds adf_rl_get_num_svc_aes() to enable querying number of engines per
	 service.
Patch #6 Adds get_svc_slice_cnt() to device data to generalizes AE count lookup.
Patch #7 Adds compression slice count tracking.
Patch #8 Enables RL for GEN6.

Suman Kumar Chakraborty (8):
  crypto: qat - validate service in rate limiting sysfs api
  crypto: qat - add decompression service for rate limiting
  crypto: qat - consolidate service enums
  crypto: qat - relocate service related functions
  crypto: qat - add adf_rl_get_num_svc_aes() in rate limiting
  crypto: qat - add get_svc_slice_cnt() in device data structure
  crypto: qat - add compression slice count for rate limiting
  crypto: qat - enable rate limiting feature for GEN6 devices

 Documentation/ABI/testing/sysfs-driver-qat_rl | 14 +--
 .../intel/qat/qat_420xx/adf_420xx_hw_data.c   |  9 +-
 .../intel/qat/qat_4xxx/adf_4xxx_hw_data.c     |  9 +-
 .../intel/qat/qat_6xxx/adf_6xxx_hw_data.c     | 77 ++++++++++++++++-
 .../intel/qat/qat_6xxx/adf_6xxx_hw_data.h     | 20 +++++
 .../intel/qat/qat_common/adf_accel_devices.h  |  2 +
 .../intel/qat/qat_common/adf_cfg_services.c   | 40 ++++++++-
 .../intel/qat/qat_common/adf_cfg_services.h   | 12 ++-
 .../intel/qat/qat_common/adf_gen4_hw_data.c   | 42 ++++++++-
 .../intel/qat/qat_common/adf_gen4_hw_data.h   |  3 +
 drivers/crypto/intel/qat/qat_common/adf_rl.c  | 86 ++++++-------------
 drivers/crypto/intel/qat/qat_common/adf_rl.h  | 11 +--
 .../intel/qat/qat_common/adf_rl_admin.c       |  1 +
 .../intel/qat/qat_common/adf_sysfs_rl.c       | 21 +++--
 14 files changed, 251 insertions(+), 96 deletions(-)


base-commit: db689623436f9f8b87c434285a4bdbf54b0f86d2
-- 
2.40.1

