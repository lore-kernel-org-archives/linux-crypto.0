Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAE4425A2AB
	for <linux-crypto@vger.kernel.org>; Wed, 30 Apr 2025 11:35:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746012904; cv=none; b=d1e8JgSiaKmrPv/3gDANlgnqFI3XcWpr1b89fmPhZ4vt2g/N5zcQckq8thwM1D2DqYkn8SCq9NiITdn8XLp4rE/bUxgSZzjBw1gOo2/fSvUZmwtasKR/mSrJup1IHv4K8u61tw37B8OdxvW+quGpcvZGjrTRxUMtlGKrTzDIUqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746012904; c=relaxed/simple;
	bh=UaO3tkP9NyEuDDnE1zNKSB3BZUYFxB1IQmO8aQUgJBs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=cN/zg1wCVaUJQYPkUtcQcD1TU1TCr9q/t//FGkjYMkPZMQwJ4KE6S2vlHcPfKhqIZF2wZqkaKfqQE5FA7aE8IpnHBdCm+PpfIJXwvfEvlrxJAe5ECbI+slhq8Jnp4AqvosBDh0EEhlLN6oIM+N4279+poIB5AdrrnzsvxNOI3lY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=c1+mDYaR; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="c1+mDYaR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746012903; x=1777548903;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=UaO3tkP9NyEuDDnE1zNKSB3BZUYFxB1IQmO8aQUgJBs=;
  b=c1+mDYaRsZT7Pr/Ip4c7t9YlKowtmA3/jw9Q68J6M/mN9UjptYFUeU0V
   qwEy8LZ79xHjDtYYqZlVSp6U8gQn7yphGnBDVJCyf/V5IEDDzZdkyXHaC
   u85GhWR9RlXDwmkhuibZ7y+oU3qo4KZy7o4ZTZmkaAT1IwpfvboM8StgJ
   m6EMepUbKixFUn7DuvKhVa0kNix9/adfQeEry5Bg2LZZyhy7dxh/5kf5p
   +5UnMSHheHtDKeSF2EXyMQkFhVRu/MxEcq4eufQWLPt3AXWyyhLZVJ/D6
   WpLvmct6eB5xJwz+J3bet5tvAIPfUOF4g4c3lPANCNz9I0JaH8bb2a652
   A==;
X-CSE-ConnectionGUID: KjC6KNjLSwmHNbTYPJbLzQ==
X-CSE-MsgGUID: mYL6pyTDR4yXWOSHE6bLpg==
X-IronPort-AV: E=McAfee;i="6700,10204,11418"; a="51331130"
X-IronPort-AV: E=Sophos;i="6.15,251,1739865600"; 
   d="scan'208";a="51331130"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2025 04:35:02 -0700
X-CSE-ConnectionGUID: V/cQg9rYSZKHt1myW5S0vw==
X-CSE-MsgGUID: ij4SJ6w5RT+VeRQF6uRx9A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,251,1739865600"; 
   d="scan'208";a="133812499"
Received: from t21-qat.iind.intel.com ([10.49.15.35])
  by orviesa009.jf.intel.com with ESMTP; 30 Apr 2025 04:35:00 -0700
From: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com
Subject: [PATCH 00/11] crypto: qat - add support for QAT GEN6 devices
Date: Wed, 30 Apr 2025 12:34:42 +0100
Message-Id: <20250430113453.1587497-1-suman.kumar.chakraborty@intel.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patchset adds support for QAT GEN6 devices, the successor to QAT GEN4
devices, by introducing a new driver, qat_6xxx.
This initial implementation lays the groundwork for future enhancements that
will be introduced in subsequent patchsets.

The first part of the set (patches #1 to #3) reworks and relocates some of the
existing features from the GEN4 device driver to the qat_common folder so that
the implementation can be shared between GEN4 and GEN6 device drivers.

The second part (patches #4 and #5) reworks the firmware loader to support the
`dual signing method` used by GEN6 devices.

The third part (patches #6 to #8) exposes symbols that are needed by the
qat_6xxx driver.

The fourth part (patches #9 and #10) updates the firmware APIs for GEN6
devices.
 
The last patch (#11) introduces the qat_6xxx driver.

George Abraham P (1):
  crypto: qat - rename and relocate timer logic

Giovanni Cabiddu (1):
  crypto: qat - export adf_get_service_mask()

Jack Xu (2):
  crypto: qat - refactor FW signing algorithm
  crypto: qat - add GEN6 firmware loader

Laurent M Coquerel (1):
  crypto: qat - add qat_6xxx driver

Suman Kumar Chakraborty (6):
  crypto: qat - refactor compression template logic
  crypto: qat - use pr_fmt() in qat uclo.c
  crypto: qat - expose configuration functions
  crypto: qat - export adf_init_admin_pm()
  crypto: qat - update firmware api
  crypto: qat - add firmware headers for GEN6 devices

 drivers/crypto/intel/qat/Kconfig              |  12 +
 drivers/crypto/intel/qat/Makefile             |   1 +
 .../intel/qat/qat_420xx/adf_420xx_hw_data.c   |   7 +-
 .../intel/qat/qat_4xxx/adf_4xxx_hw_data.c     |   7 +-
 drivers/crypto/intel/qat/qat_6xxx/Makefile    |   3 +
 .../intel/qat/qat_6xxx/adf_6xxx_hw_data.c     | 843 ++++++++++++++++++
 .../intel/qat/qat_6xxx/adf_6xxx_hw_data.h     | 148 +++
 drivers/crypto/intel/qat/qat_6xxx/adf_drv.c   | 224 +++++
 .../intel/qat/qat_c3xxx/adf_c3xxx_hw_data.c   |   1 -
 .../qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.c     |   1 -
 .../intel/qat/qat_c62x/adf_c62x_hw_data.c     |   1 -
 .../intel/qat/qat_c62xvf/adf_c62xvf_hw_data.c |   1 -
 drivers/crypto/intel/qat/qat_common/Makefile  |   6 +-
 .../intel/qat/qat_common/adf_accel_devices.h  |   8 +-
 .../crypto/intel/qat/qat_common/adf_admin.c   |   1 +
 .../intel/qat/qat_common/adf_cfg_common.h     |   1 +
 .../intel/qat/qat_common/adf_cfg_services.c   |   3 +-
 .../intel/qat/qat_common/adf_cfg_services.h   |   1 +
 .../qat_common/{adf_gen2_dc.c => adf_dc.c}    |  50 +-
 drivers/crypto/intel/qat/qat_common/adf_dc.h  |  17 +
 .../intel/qat/qat_common/adf_fw_config.h      |   1 +
 .../crypto/intel/qat/qat_common/adf_gen2_dc.h |  10 -
 .../intel/qat/qat_common/adf_gen2_hw_data.c   |  57 ++
 .../intel/qat/qat_common/adf_gen2_hw_data.h   |   1 +
 .../intel/qat/qat_common/adf_gen4_config.c    |   6 +-
 .../intel/qat/qat_common/adf_gen4_config.h    |   3 +
 .../crypto/intel/qat/qat_common/adf_gen4_dc.c |  83 --
 .../crypto/intel/qat/qat_common/adf_gen4_dc.h |  10 -
 .../intel/qat/qat_common/adf_gen4_hw_data.c   |  70 ++
 .../intel/qat/qat_common/adf_gen4_hw_data.h   |   2 +
 .../crypto/intel/qat/qat_common/adf_gen6_pm.h |  28 +
 .../intel/qat/qat_common/adf_gen6_shared.c    |  49 +
 .../intel/qat/qat_common/adf_gen6_shared.h    |  15 +
 .../{adf_gen4_timer.c => adf_timer.c}         |  18 +-
 .../{adf_gen4_timer.h => adf_timer.h}         |  10 +-
 .../intel/qat/qat_common/icp_qat_fw_comp.h    |  23 +-
 .../qat/qat_common/icp_qat_fw_loader_handle.h |   1 +
 .../intel/qat/qat_common/icp_qat_hw_51_comp.h |  99 ++
 .../qat/qat_common/icp_qat_hw_51_comp_defs.h  | 318 +++++++
 .../intel/qat/qat_common/icp_qat_uclo.h       |  23 +
 .../intel/qat/qat_common/qat_comp_algs.c      |   5 +-
 .../intel/qat/qat_common/qat_compression.c    |   1 -
 .../intel/qat/qat_common/qat_compression.h    |   1 -
 drivers/crypto/intel/qat/qat_common/qat_hal.c |   3 +
 .../crypto/intel/qat/qat_common/qat_uclo.c    | 437 ++++++---
 .../qat/qat_dh895xcc/adf_dh895xcc_hw_data.c   |   1 -
 .../qat_dh895xccvf/adf_dh895xccvf_hw_data.c   |   1 -
 47 files changed, 2293 insertions(+), 319 deletions(-)
 create mode 100644 drivers/crypto/intel/qat/qat_6xxx/Makefile
 create mode 100644 drivers/crypto/intel/qat/qat_6xxx/adf_6xxx_hw_data.c
 create mode 100644 drivers/crypto/intel/qat/qat_6xxx/adf_6xxx_hw_data.h
 create mode 100644 drivers/crypto/intel/qat/qat_6xxx/adf_drv.c
 rename drivers/crypto/intel/qat/qat_common/{adf_gen2_dc.c => adf_dc.c} (59%)
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_dc.h
 delete mode 100644 drivers/crypto/intel/qat/qat_common/adf_gen2_dc.h
 delete mode 100644 drivers/crypto/intel/qat/qat_common/adf_gen4_dc.c
 delete mode 100644 drivers/crypto/intel/qat/qat_common/adf_gen4_dc.h
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_gen6_pm.h
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_gen6_shared.c
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_gen6_shared.h
 rename drivers/crypto/intel/qat/qat_common/{adf_gen4_timer.c => adf_timer.c} (78%)
 rename drivers/crypto/intel/qat/qat_common/{adf_gen4_timer.h => adf_timer.h} (58%)
 create mode 100644 drivers/crypto/intel/qat/qat_common/icp_qat_hw_51_comp.h
 create mode 100644 drivers/crypto/intel/qat/qat_common/icp_qat_hw_51_comp_defs.h


base-commit: fef208fd85f67ab4a4552d2d141b3f811ab22f00
-- 
2.40.1

