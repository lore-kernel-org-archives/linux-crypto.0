Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFBED16411
	for <linux-crypto@vger.kernel.org>; Wed,  3 Jan 2024 04:08:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mLcMualv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1704254935; x=1735790935;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=gL8PNc7UX1Ihfr6zd2VLwkqFMWTEGULO2tEaZ4SoE8w=;
  b=mLcMualvh7JMY1ckHuHjNXfMy6VcvwT14/l1QU6DxBfy/0xMTQmowptw
   3Fle/FS+Idch+SdRv5maiFGaD2ydV0ntKVJ/70+6/YsNVB497H4bcy7+X
   ftmREYPXqTv6uQ5b64BrLoFtEjJfG6fl/RfBN+8xFsyiRGZOxwaOzClmz
   N+N03rrBv4bCNtqQ3YkzCBloa2QWCKv2NXD6ni5gntCox2icT8BbsFuJx
   Fg9t1xlhuWVa8o6kEQw7qw5/x48B7Ecu+CcIdhQqhAeXO8bt8HKLN79c1
   xd1XY6c6tUwPDzJHr1EvejLyStis+Gp4DrWeAsO/pcyiM4HirbsRTLVBo
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10941"; a="3725450"
X-IronPort-AV: E=Sophos;i="6.04,326,1695711600"; 
   d="scan'208";a="3725450"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jan 2024 20:08:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10941"; a="1111241837"
X-IronPort-AV: E=Sophos;i="6.04,326,1695711600"; 
   d="scan'208";a="1111241837"
Received: from myep-mobl1.png.intel.com ([10.107.5.97])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jan 2024 20:08:50 -0800
From: Mun Chun Yep <mun.chun.yep@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	Mun Chun Yep <mun.chun.yep@intel.com>
Subject: [PATCH 0/9] crypto: qat - improve recovery flows
Date: Wed,  3 Jan 2024 12:07:13 +0800
Message-Id: <20240103040722.14467-1-mun.chun.yep@intel.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This set improves the error recovery flows in the QAT drivers and
adds a mechanism to test it through an heartbeat simulator.

When a QAT device reports either a fatal error, or an AER fatal error,
or fails an heartbeat check, the PF driver sends an error notification to
the VFs through PFVF comms and if `auto_reset` is enabled then
the device goes through reset flows for error recovery.
If SRIOV is enabled when an error is encountered, this is re-enabled after
the reset cycle is done.

Damian Muszynski (2):
  crypto: qat - add heartbeat error simulator
  crypto: qat - add auto reset on error

Furong Zhou (3):
  crypto: qat - add fatal error notify method
  crypto: qat - disable arbitration before reset
  crypto: qat - limit heartbeat notifications

Mun Chun Yep (4):
  crypto: qat - update PFVF protocol for recovery
  crypto: qat - re-enable sriov after pf reset
  crypto: qat - add fatal error notification
  crypto: qat - improve aer error reset handling

 Documentation/ABI/testing/debugfs-driver-qat  |  26 +++++
 Documentation/ABI/testing/sysfs-driver-qat    |  20 ++++
 drivers/crypto/intel/qat/Kconfig              |  15 +++
 drivers/crypto/intel/qat/qat_common/Makefile  |   3 +
 .../intel/qat/qat_common/adf_accel_devices.h  |   2 +
 drivers/crypto/intel/qat/qat_common/adf_aer.c | 107 +++++++++++++++++-
 .../intel/qat/qat_common/adf_cfg_strings.h    |   1 +
 .../intel/qat/qat_common/adf_common_drv.h     |  10 ++
 .../intel/qat/qat_common/adf_heartbeat.c      |  20 +++-
 .../intel/qat/qat_common/adf_heartbeat.h      |  21 ++++
 .../qat/qat_common/adf_heartbeat_dbgfs.c      |  52 +++++++++
 .../qat/qat_common/adf_heartbeat_inject.c     |  76 +++++++++++++
 .../intel/qat/qat_common/adf_hw_arbiter.c     |  25 ++++
 .../crypto/intel/qat/qat_common/adf_init.c    |  12 ++
 drivers/crypto/intel/qat/qat_common/adf_isr.c |   7 +-
 .../intel/qat/qat_common/adf_pfvf_msg.h       |   7 +-
 .../intel/qat/qat_common/adf_pfvf_pf_msg.c    |  64 ++++++++++-
 .../intel/qat/qat_common/adf_pfvf_pf_msg.h    |  21 ++++
 .../intel/qat/qat_common/adf_pfvf_pf_proto.c  |   8 ++
 .../intel/qat/qat_common/adf_pfvf_vf_proto.c  |   6 +
 .../crypto/intel/qat/qat_common/adf_sriov.c   |  38 ++++++-
 .../crypto/intel/qat/qat_common/adf_sysfs.c   |  37 ++++++
 22 files changed, 565 insertions(+), 13 deletions(-)
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_heartbeat_inject.c

-- 
2.34.1

