Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2024C19441
	for <linux-crypto@vger.kernel.org>; Fri, 15 Dec 2023 10:03:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YgfAmpV2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1702634602; x=1734170602;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=ZWhNVHj2COz1GLO0rRuGKZX0PbiCsufTtRzl+bH9h98=;
  b=YgfAmpV2POzE5Xye2vFPS8Ha6ismp4leOEoMaXW6CrxZAcI4h9CuT5pf
   WHrtcdzimaQMRaGfQosQXbuEgec1BOoaCT5ESD/KzMaEiOeqLIJZwoUHM
   lzrbCg8thLc3L+ogAyi9GO77RMzHy8L4DBRDKpUJuvadjcjGvKkrOXNMj
   uqbu5c+3t2Y/NIrso8k9cB6H36euxolfKl3WT14lASf9j7ANiewoOxDgx
   9uFdvfnSWfWbYwLmC58g9eOL7M7F0JF0wXbZDsU7vHPkAXOlDur/4lmNO
   RyZ0mH+YHz5TOlPgYlgpJo7OgYe1o2hr1c2wj75/waVaHkNcRd3hNyIBA
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10924"; a="374759842"
X-IronPort-AV: E=Sophos;i="6.04,278,1695711600"; 
   d="scan'208";a="374759842"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Dec 2023 02:03:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10924"; a="845074075"
X-IronPort-AV: E=Sophos;i="6.04,278,1695711600"; 
   d="scan'208";a="845074075"
Received: from qat-wangjie-342.sh.intel.com ([10.67.115.171])
  by fmsmga004.fm.intel.com with ESMTP; 15 Dec 2023 02:03:19 -0800
From: Jie Wang <jie.wang@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com
Subject: [PATCH 0/5] crypto: qat - add support for 420xx devices
Date: Fri, 15 Dec 2023 05:01:43 -0500
Message-Id: <20231215100147.1703641-1-jie.wang@intel.com>
X-Mailer: git-send-email 2.32.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Asia-Pacific Research & Development Ltd. - No. 880, Zi Xing, Road, Shanghai Zizhu Science Park, Shanghai, 200241, PRC
Content-Transfer-Encoding: 8bit

This set adds support for 420xx devices.

Compared to 4xxx devices, 420xx devices have more acceleration engines
(16 service engines and 1 admin) and support the wireless cipher
algorithms ZUC and Snow 3G.

Here is a summary of the changes:
* Patch #1 relocates and renames get_service_enabled() since it is
  not specific to 4xxx.
* Patch #2 changes the signature of the function uof_get_num_objs()
  as it is required by the 420xx driver.
* Patch #3 moves the common logic between QAT GEN4 accelerators to
  the intel_qat folder.
* Patch #4 moves the fw config related structures to a newly created
  header file.
* Patch #5 implements the QAT 420xx driver.

The first 4 patches just refactor the code and do not introduce any
functional changes.

Jie Wang (5):
  crypto: qat - relocate and rename get_service_enabled()
  crypto: qat - change signature of uof_get_num_objs()
  crypto: qat - relocate portions of qat_4xxx code
  crypto: qat - move fw config related structures
  crypto: qat - add support for 420xx devices

 drivers/crypto/intel/qat/Kconfig              |  11 +
 drivers/crypto/intel/qat/Makefile             |   1 +
 drivers/crypto/intel/qat/qat_420xx/Makefile   |   4 +
 .../intel/qat/qat_420xx/adf_420xx_hw_data.c   | 552 ++++++++++++++++++
 .../intel/qat/qat_420xx/adf_420xx_hw_data.h   |  55 ++
 drivers/crypto/intel/qat/qat_420xx/adf_drv.c  | 202 +++++++
 .../intel/qat/qat_4xxx/adf_4xxx_hw_data.c     | 232 ++------
 .../intel/qat/qat_4xxx/adf_4xxx_hw_data.h     |  52 --
 drivers/crypto/intel/qat/qat_4xxx/adf_drv.c   | 277 +--------
 drivers/crypto/intel/qat/qat_common/Makefile  |   1 +
 .../intel/qat/qat_common/adf_accel_devices.h  |   5 +-
 .../intel/qat/qat_common/adf_accel_engine.c   |   2 +-
 .../intel/qat/qat_common/adf_cfg_common.h     |   1 +
 .../intel/qat/qat_common/adf_cfg_services.c   |  27 +
 .../intel/qat/qat_common/adf_cfg_services.h   |   4 +
 .../intel/qat/qat_common/adf_fw_config.h      |  18 +
 .../intel/qat/qat_common/adf_gen4_config.c    | 287 +++++++++
 .../intel/qat/qat_common/adf_gen4_config.h    |  11 +
 .../intel/qat/qat_common/adf_gen4_hw_data.c   | 148 +++++
 .../intel/qat/qat_common/adf_gen4_hw_data.h   |  74 +++
 .../crypto/intel/qat/qat_common/icp_qat_hw.h  |  14 +-
 .../intel/qat/qat_common/icp_qat_uclo.h       |   2 +-
 drivers/crypto/intel/qat/qat_common/qat_hal.c |   6 +-
 .../crypto/intel/qat/qat_common/qat_uclo.c    |   1 +
 24 files changed, 1457 insertions(+), 530 deletions(-)
 create mode 100644 drivers/crypto/intel/qat/qat_420xx/Makefile
 create mode 100644 drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c
 create mode 100644 drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.h
 create mode 100644 drivers/crypto/intel/qat/qat_420xx/adf_drv.c
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_fw_config.h
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_gen4_config.c
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_gen4_config.h


base-commit: 1ac058e8f5b5adc5e365d72361486922bfbd0cb9
-- 
2.32.0

