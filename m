Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DE953C5529
	for <linux-crypto@vger.kernel.org>; Mon, 11 May 2026 10:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778494142; cv=none; b=HxlKY/MnySysknAlr4yFQFpxPNjsrSZMcuR5Y8/AOT7CvnGk+PzupHvjlheqrawau/h30H3HMBRs1xx6bGfDHl0TX1jQzd2MzqxUQDP2vOE4pmZ0oNvIKikHbTUco1kiAY8ClCMFzOaQ65DZopF1OYfcQohuXBPC54e8WN0vSFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778494142; c=relaxed/simple;
	bh=qgqks0LvanrRq2X8TtLnoAreYNwZgHINq1WrwzvYsAQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=G+xYfbURz+tvy9C5W1DdpB9uZsSbo6sdHEyMlB7UcisK962sJNhcxu9hHl+4CUs0TT9d9B2nwU6bdeStN8lcEaIK9xfuS2dEZkJ2H27PPrnmdbvmmoCkZp3g05MyssVpEF/6srlhUL4xbc6E6ILn8UME6UlUT95jdCuURSWeLnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ISy3ZLuS; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ISy3ZLuS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778494141; x=1810030141;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=qgqks0LvanrRq2X8TtLnoAreYNwZgHINq1WrwzvYsAQ=;
  b=ISy3ZLuSLUjFeOcKja2kZKX3AUn+rwhG76adTXUk6ZkgSBy4yKk0MRiD
   1iEXX5LbF6+KPO6LBmihT7jIBwhM+/1NVxbOQBvjgw8HpBRehxdSdH4Sw
   ysv+to9xsIrY2HNmZ5xeHY0scA1HOb/dnTTJ3QgQIyIU4efILSFhcPrZB
   ZCnKreSueJd7/bA+t+hVGBU00sBxixxjfUNSLdCvWuEvIAwgwVJVNNRqL
   MyRkWtJfwgjarRcNmNgkMxPXaRIKYHYuDdMr71073E0oZCzBSNt3wze0Q
   R/Xvayr9jDEP2Kzvx2sUZPINqiLk3gyHulz3wcW5TsxO09Q2wkil8wzMa
   w==;
X-CSE-ConnectionGUID: GamY1pJsSU+E/urvEZu8Hw==
X-CSE-MsgGUID: 4AhYVRLrTm6V134lWBtEug==
X-IronPort-AV: E=McAfee;i="6800,10657,11782"; a="90478167"
X-IronPort-AV: E=Sophos;i="6.23,228,1770624000"; 
   d="scan'208";a="90478167"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2026 03:09:00 -0700
X-CSE-ConnectionGUID: kfZ33ua6RpSv1HuUl5/f8Q==
X-CSE-MsgGUID: cOF9kVwbSA++KzTFXsaikw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,228,1770624000"; 
   d="scan'208";a="232929468"
Received: from unknown (HELO fedora.iind.intel.com) ([10.49.0.89])
  by fmviesa006.fm.intel.com with ESMTP; 11 May 2026 03:08:58 -0700
From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	wangzhi@stu.xidian.edu.cn,
	byu@xidian.edu.cn,
	w15303746062@163.com,
	vdronov@redhat.com,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH v3 0/2] crypto: qat - remove unused ioctl interface
Date: Mon, 11 May 2026 11:04:07 +0100
Message-ID: <20260511100854.29474-1-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit

The QAT driver exposes a character device (qat_adf_ctl) with IOCTLs for
device configuration, start, stop, status query and enumeration. These
IOCTLs are not part of any public uAPI header and have no known in-tree
or out-of-tree users.

This ioctl interface increases the attack surface and is the subject of a
number of bug reports. Remove it entirely.

Patch 1 removes the character device, the IOCTL definitions, the related
data structures and headers. It strips adf_ctl_drv.c down to the
minimal module_init/module_exit hooks. This is marked for stable.

Patch 2 renames the now-minimal adf_ctl_drv.c to adf_module.c and
adjusts function names to match the new file name. This is not marked
for stable as it is a pure rename.

Changes since v1:
- Addressed comments from Sashiko: cleaned up leftover dead code
  https://sashiko.dev/#/patchset/20260508091912.206913-1-giovanni.cabiddu%40intel.com

Changes since v2:
- Removed additional dead code: adf_devmgr_get_dev_by_id(),
  adf_get_vf_real_id() and a few ADF_CFG unused macros

Giovanni Cabiddu (2):
  crypto: qat - remove unused character device and IOCTLs
  crypto: qat - rename adf_ctl_drv.c to adf_module.c

 .../userspace-api/ioctl/ioctl-number.rst      |   1 -
 drivers/crypto/intel/qat/qat_common/Makefile  |   2 +-
 drivers/crypto/intel/qat/qat_common/adf_cfg.c |  10 -
 drivers/crypto/intel/qat/qat_common/adf_cfg.h |   1 -
 .../intel/qat/qat_common/adf_cfg_common.h     |  32 --
 .../intel/qat/qat_common/adf_cfg_user.h       |  38 --
 .../intel/qat/qat_common/adf_common_drv.h     |   3 -
 .../crypto/intel/qat/qat_common/adf_ctl_drv.c | 466 ------------------
 .../crypto/intel/qat/qat_common/adf_dev_mgr.c |  70 ---
 .../crypto/intel/qat/qat_common/adf_module.c  |  64 +++
 10 files changed, 65 insertions(+), 622 deletions(-)
 delete mode 100644 drivers/crypto/intel/qat/qat_common/adf_cfg_user.h
 delete mode 100644 drivers/crypto/intel/qat/qat_common/adf_ctl_drv.c
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_module.c


base-commit: f7dd32c5179d7755de18e21d5674b08f9e5cb180
-- 
2.54.0

