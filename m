Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 473B623741
	for <linux-crypto@vger.kernel.org>; Sat, 28 Mar 2026 22:34:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774737301; cv=none; b=flpuFBoGzoaA6Na9LIpSLxEy5WToK9W9R3tdi2j2iv6gdDODAaBGTqg9JSGDBLCwamH3bNRD+7LFNsZy+ld1T/N+LmGPDn9xJmJ1KkMr1huN/7YCNx5O1FyMrcZ8EscfSmzzSIlWzfJwKecnuni9T9ERnoQpdvzlB8v7n+sdY0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774737301; c=relaxed/simple;
	bh=5Hg1iZN3fp9eX9wKeHe0mI/PRsfoP0/EAtDJjldBaU0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PVbyZ7dyjFtoI5HKHqwKZFsbuHhCzPY/qnfQ05bL72cXdcrV52xuICA05f3FOW1toIdSxJxFee8bhgdmbczoMbs/tQAxV3SYHZIL7myBQdHjg9idKFFV7rKcyj9YPTld8SqidP+2pjf72Df2SgtkIEYuFT1Z+eKJ1cnvxvO28Rc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VbZ7ydm0; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VbZ7ydm0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774737299; x=1806273299;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=5Hg1iZN3fp9eX9wKeHe0mI/PRsfoP0/EAtDJjldBaU0=;
  b=VbZ7ydm0JZMRlv9c7ldumYiwAF3bP+G/zHMTQD94wCmCLfd33V/0AQyf
   krSuLD21kX4HQKeBVucq2XEydNEnrqKM7VJy5X6VaXfOXtd/oVDuw2IRa
   fLjZHSuteH+DRIRHY8F/r6xvH5IVJrh9u98DzRGKYLKC6xHjRNZsCfkrB
   zlmJ7CCqj1kvtlhqLxniTMmJPq8vBhE9a2z2H6fOgp+CkWVPkvC8pL5P5
   0sOqAllzCOB8AGZfLsrWKZmnN3aYRXGy6ICYmBYSKCyRp8KI+uus/DOB9
   IXMUGiGBotPfuKTJYcR2lLp+Mb21cJK12kCIXfScfwuwF77SUKL0FimJN
   w==;
X-CSE-ConnectionGUID: 4r8PGI9JShaWKufvA4nruw==
X-CSE-MsgGUID: Z8NjrojBREu+tdGpK2ydiQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11742"; a="78372913"
X-IronPort-AV: E=Sophos;i="6.23,146,1770624000"; 
   d="scan'208";a="78372913"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2026 15:34:59 -0700
X-CSE-ConnectionGUID: cJMezhCmSpyMEtmMiTJD0Q==
X-CSE-MsgGUID: Pm+pWXCLQyCkJPkx2Vd+YA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,146,1770624000"; 
   d="scan'208";a="222339205"
Received: from silpixa00401971.ir.intel.com ([10.20.226.106])
  by fmviesa007.fm.intel.com with ESMTP; 28 Mar 2026 15:34:57 -0700
From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH v2 0/2] crypto: qat - add support for zstd
Date: Sat, 28 Mar 2026 22:29:45 +0000
Message-ID: <20260328223445.39445-1-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit

The Intel QuickAssist Technology (QAT) driver currently supports deflate
compression via the acomp API, but lacks support for the ZSTD algorithm.

This series adds ZSTD compression support for QAT GEN4, QAT GEN5 and QAT
GEN6 devices.

On GEN4 and GEN5, hardware compresses data using LZ4s (a QAT-specific
variant of LZ4). The LZ4s output is then parsed and passed to the kernel
zstd library via zstd_compress_sequences_and_literals() to produce a
standard ZSTD stream. The post-processing step uses per-CPU scratch
buffers managed via the acomp stream infrastructure.

On GEN6, both compression and decompression are natively offloaded to
the accelerator. Decompression of frames with a history window exceeding
the 64 KB hardware limit falls back to software.

A filtering mechanism is also introduced to prevent GEN2 plug-in cards,
which do not support ZSTD or LZ4s, from being selected for these
algorithms when a GEN4, GEN5 or GEN6 embedded device is also present on
the system.

In summary:
- Patch #1 fixes a build error on architectures without a native
  byte-swap instruction
- Patch #2 exposes the ZSTD algorithm through the acomp API for QAT
  GEN4, GEN5 and GEN6 accelerators

Changes since v1:
- Add a patch to fix a build error on architectures without a native
  byte-swap instruction

Giovanni Cabiddu (2):
  crypto: qat - use swab32 macro
  crypto: qat - add support for zstd

 drivers/crypto/intel/qat/Kconfig              |   1 +
 .../intel/qat/qat_420xx/adf_420xx_hw_data.c   |   1 +
 .../intel/qat/qat_4xxx/adf_4xxx_hw_data.c     |   1 +
 .../intel/qat/qat_6xxx/adf_6xxx_hw_data.c     |  17 +
 drivers/crypto/intel/qat/qat_common/Makefile  |   1 +
 .../intel/qat/qat_common/adf_accel_devices.h  |   6 +
 .../intel/qat/qat_common/adf_common_drv.h     |   6 +-
 .../intel/qat/qat_common/adf_gen4_hw_data.c   |  18 +-
 .../crypto/intel/qat/qat_common/adf_init.c    |   6 +-
 .../crypto/intel/qat/qat_common/icp_qat_fw.h  |   7 +
 .../intel/qat/qat_common/icp_qat_fw_comp.h    |   2 +
 .../crypto/intel/qat/qat_common/icp_qat_hw.h  |   3 +-
 .../intel/qat/qat_common/icp_qat_hw_20_comp.h |  10 +-
 .../intel/qat/qat_common/qat_comp_algs.c      | 524 +++++++++++++++++-
 .../intel/qat/qat_common/qat_comp_req.h       |   9 +
 .../qat/qat_common/qat_comp_zstd_utils.c      | 165 ++++++
 .../qat/qat_common/qat_comp_zstd_utils.h      |  13 +
 .../intel/qat/qat_common/qat_compression.c    |  23 +-
 18 files changed, 779 insertions(+), 34 deletions(-)
 create mode 100644 drivers/crypto/intel/qat/qat_common/qat_comp_zstd_utils.c
 create mode 100644 drivers/crypto/intel/qat/qat_common/qat_comp_zstd_utils.h


base-commit: 93e03a16c015b8e55e2ec97865f67d9bf1ec1921
-- 
2.53.0

