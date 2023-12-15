Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09ABE364C9
	for <linux-crypto@vger.kernel.org>; Fri, 15 Dec 2023 15:26:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="c7uMfNfX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1702653964; x=1734189964;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=6EsVvUu3K6OtZ/irpzF5FC3eLu2vIHVbzXi45aemFxw=;
  b=c7uMfNfXgoru6jbXpEI2/g3pGMQgnrjgkFGYX60YLRYfqNnid9nLe5Mp
   5j0956UKTWhYFC5SydJ2xS/qcvu/kBhBkv3wm+Y3tyEJFs9LiD6Tej8xh
   5aIOLlgd72qoqTDa86RZvtpDhE2RbZwappoFzi9ecNVzjAJvgOh9mr4fM
   nGrEl7U0muF5J3yL3sfmzVvGwwmagWvYTfFzxP3eb/L+mxpVrP9JDqW5N
   kDIDuwIk5MP0S605SO26s09Y6vS4fCx6I8SF87EsG+bkfXZnTkTrPFEux
   eSucvbY06PU1LGJSRi64jz5KYDnpPb3neVzAY73tGqFfuuU53jnrMrvbd
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10924"; a="385706764"
X-IronPort-AV: E=Sophos;i="6.04,279,1695711600"; 
   d="scan'208";a="385706764"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Dec 2023 07:26:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.04,279,1695711600"; 
   d="scan'208";a="22876699"
Received: from r007s007_zp31l10c01.deacluster.intel.com (HELO fedora.deacluster.intel.com) ([10.219.171.169])
  by orviesa001.jf.intel.com with ESMTP; 15 Dec 2023 07:26:05 -0800
From: Lucas Segarra Fernandez <lucas.segarra.fernandez@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	Lucas Segarra Fernandez <lucas.segarra.fernandez@intel.com>
Subject: [PATCH 0/5] crypto: qat - enable telemetry for QAT GEN 4
Date: Fri, 15 Dec 2023 16:23:34 +0100
Message-ID: <20231215152334.34524-1-lucas.segarra.fernandez@intel.com>
X-Mailer: git-send-email 2.41.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Expose through debugfs telemetry data for QAT GEN4 devices.

This allows to gather metrics about the performance and the utilization
of a QAT device and/or a group of ring pairs. In particular, statistics
on (1) the utilization of the PCIe channel, (2) address translation and
device TLB, when SVA is enabled and (3) the internal engines for crypto
and data compression.

The device periodically gathers telemetry data from hardware registers
and writes it into a DMA memory region which is sampled by the driver.
The driver then uses this data to compute basic metrics on the counters
and exposes them through debugfs attributes in the folder
/sys/kernel/debug/qat_<device>_<BDF>/telemetry.

Here is a summary of the changes:
 * Patch #1 adds an helper function to math.h to compute the average of
   values within an array.
 * Patch #2 includes a missing header in the file adf_accel_devices.h to
   allow to use the macro GET_DEV().
 * Patch #3 introduces device level telemetry and the associated documentation
   in /Documentation/ABI.
 * Patch #4 extends #3 by introducing ring pair level telemetry and
   documentation about it.

This set is based on earlier work done by Wojciech Ziemba.

Lucas Segarra Fernandez (5):
  math.h: Add avg_array()
  crypto: qat - include pci.h for GET_DEV()
  crypto: qat - add admin msgs for telemetry
  crypto: qat - add support for device telemetry
  crypto: qat - add support for ring pair level telemetry

 .../ABI/testing/debugfs-driver-qat_telemetry  | 227 ++++++
 .../intel/qat/qat_420xx/adf_420xx_hw_data.c   |   3 +
 .../intel/qat/qat_4xxx/adf_4xxx_hw_data.c     |   3 +
 drivers/crypto/intel/qat/qat_common/Makefile  |   3 +
 .../intel/qat/qat_common/adf_accel_devices.h  |   6 +
 .../crypto/intel/qat/qat_common/adf_admin.c   |  37 +
 .../crypto/intel/qat/qat_common/adf_admin.h   |   4 +
 .../crypto/intel/qat/qat_common/adf_dbgfs.c   |   3 +
 .../intel/qat/qat_common/adf_gen4_hw_data.h   |   1 +
 .../crypto/intel/qat/qat_common/adf_gen4_tl.c | 153 +++++
 .../crypto/intel/qat/qat_common/adf_gen4_tl.h | 158 +++++
 .../crypto/intel/qat/qat_common/adf_init.c    |  12 +
 .../intel/qat/qat_common/adf_telemetry.c      | 287 ++++++++
 .../intel/qat/qat_common/adf_telemetry.h      |  99 +++
 .../intel/qat/qat_common/adf_tl_debugfs.c     | 648 ++++++++++++++++++
 .../intel/qat/qat_common/adf_tl_debugfs.h     | 116 ++++
 .../qat/qat_common/icp_qat_fw_init_admin.h    |  10 +
 include/linux/math.h                          |  33 +
 18 files changed, 1803 insertions(+)
 create mode 100644 Documentation/ABI/testing/debugfs-driver-qat_telemetry
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_gen4_tl.c
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_gen4_tl.h
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_telemetry.c
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_telemetry.h
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_tl_debugfs.c
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_tl_debugfs.h


base-commit: a7f74e2fbf7ab0a3b1cb4aff1deb3de3d5e1c381
-- 
2.41.0

