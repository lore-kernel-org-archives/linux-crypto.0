Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C6161AACF
	for <linux-crypto@vger.kernel.org>; Fri,  2 Feb 2024 10:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706871304; cv=none; b=bcQoVf487c3N9YetjYjEKT/v/vPoQPFfqdht3hiCfxYX/GhZTibic30J+XETCTsjDDQqYmcCKFe12v+9aH9vH09vp3enF7h2x653qJcPtoYY8JrpMnkJyShIE7661lCW/h5CkbuT751IZfUiQZdlCrLTqvPkQjn6f0uXGnbElu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706871304; c=relaxed/simple;
	bh=CJnDU+jiHxj4jvIhyUbPU/t2yLvRX0Qm3/3N541wuqo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=LhKL0D4Sj6qA7IzQ/hRRdJjLxefSEyQWTsZQc7lF65ICB/J/qfu4Ecbm5I7NcNCBdIJ0qune+Z1Vmo33IWuGZzeCg3Dq0lOozYf2YU7fuaK3oDqwHm+CoNdDHKB1kyMX2ctxBrlxj26EJOkdOLJSMt6+jufkn+A9F6zLdkOFHX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=djXzAnbH; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="djXzAnbH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706871302; x=1738407302;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=CJnDU+jiHxj4jvIhyUbPU/t2yLvRX0Qm3/3N541wuqo=;
  b=djXzAnbHnFaJdEngqJ/jduI1qmSCyrzlmn+M3yB0A8rKh2uX1JhB4gas
   2i6Wmg5SUrS+pnX/QFL1MQhWAodCDaz+N9I2ceiFPFbGotI2nmCJYGvlc
   8cZUjiUf/ISfamuzKMW70UeLfahFXJmUItRSjHzDFnO+EtVU7WhhU4LM+
   ZRErQSyxFM+xaYD1WJcoBx5wCGm3XpNlO8tBlTLONJid7StoVjynMYzMV
   ZHBNEPK1v3nSbcyE6s4VcaXrYD06iNTwL5lCd/yzJKE5vJqFg5WC8JJQE
   33+KoRWQmdKf7jC7mEIZTp2miF5fEil+zUl0e3bijwYTuMSVUYsx+QLC+
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10971"; a="10787275"
X-IronPort-AV: E=Sophos;i="6.05,237,1701158400"; 
   d="scan'208";a="10787275"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2024 02:55:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,237,1701158400"; 
   d="scan'208";a="53511"
Received: from myep-mobl1.png.intel.com ([10.107.10.166])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2024 02:55:00 -0800
From: Mun Chun Yep <mun.chun.yep@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	Mun Chun Yep <mun.chun.yep@intel.com>
Subject: [PATCH v2 0/9] crypto: qat - improve recovery flows
Date: Fri,  2 Feb 2024 18:53:15 +0800
Message-Id: <20240202105324.50391-1-mun.chun.yep@intel.com>
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

Changed in v2:
- Removed redundant default value in Kconfig
- Removed ccflags define, use the CONFIG option directly in the code
- Reworked the AER reset and recovery flow

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

 Documentation/ABI/testing/debugfs-driver-qat  |  26 ++++
 Documentation/ABI/testing/sysfs-driver-qat    |  20 +++
 drivers/crypto/intel/qat/Kconfig              |  14 +++
 drivers/crypto/intel/qat/qat_common/Makefile  |   2 +
 .../intel/qat/qat_common/adf_accel_devices.h  |   2 +
 drivers/crypto/intel/qat/qat_common/adf_aer.c | 116 +++++++++++++++++-
 .../intel/qat/qat_common/adf_cfg_strings.h    |   1 +
 .../intel/qat/qat_common/adf_common_drv.h     |  10 ++
 .../intel/qat/qat_common/adf_heartbeat.c      |  20 ++-
 .../intel/qat/qat_common/adf_heartbeat.h      |  21 ++++
 .../qat/qat_common/adf_heartbeat_dbgfs.c      |  52 ++++++++
 .../qat/qat_common/adf_heartbeat_inject.c     |  76 ++++++++++++
 .../intel/qat/qat_common/adf_hw_arbiter.c     |  25 ++++
 .../crypto/intel/qat/qat_common/adf_init.c    |  12 ++
 drivers/crypto/intel/qat/qat_common/adf_isr.c |   7 +-
 .../intel/qat/qat_common/adf_pfvf_msg.h       |   7 +-
 .../intel/qat/qat_common/adf_pfvf_pf_msg.c    |  64 +++++++++-
 .../intel/qat/qat_common/adf_pfvf_pf_msg.h    |  21 ++++
 .../intel/qat/qat_common/adf_pfvf_pf_proto.c  |   8 ++
 .../intel/qat/qat_common/adf_pfvf_vf_proto.c  |   6 +
 .../crypto/intel/qat/qat_common/adf_sriov.c   |  38 +++++-
 .../crypto/intel/qat/qat_common/adf_sysfs.c   |  37 ++++++
 22 files changed, 571 insertions(+), 14 deletions(-)
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_heartbeat_inject.c

-- 
2.34.1

