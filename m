Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 406A2276041
	for <linux-crypto@vger.kernel.org>; Sat,  9 May 2026 07:03:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778310236; cv=none; b=eknS+zRNC2dYlV7Uor7X7odSWMSwZxaQKVhZ5ZlKtl0v1nhZ6vgYDG0VJzMn0WK2zvNvcQ/FPz2EZrHvQBMkCeDZCocO0l4IioYuQ7ojU7xuPZ54cgo83Mf+RLoblRx16FTzyzTp6Q7vZGMv36L2OZlgcqezoMQPhfBWScw0P0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778310236; c=relaxed/simple;
	bh=Df0jM4ti0Gmt+9VNfP3vmGu1/E/Hn8XS62U7guWKBeQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Q7O6oySUz4kIanbxIzPIxVn+L/lM6P2jnI64BM9vJMwM05TTBUGbp3guCg3rG+iBPUr7p28Ezrxr9PC+bYTSQ6+/21UvFYB5XoaFWADNLrEZ92r7wvVyt8GpYAiZ8kjGEOyCcD2uK+s7Xyidm6YsHfwvnMuM7CpYE54fF/71e3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kZqBUOBQ; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kZqBUOBQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778310235; x=1809846235;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Df0jM4ti0Gmt+9VNfP3vmGu1/E/Hn8XS62U7guWKBeQ=;
  b=kZqBUOBQSFTM4tu+diT+pnB8HG6a/1w3bll8UhTn4tsOl5dbpUyRvWFW
   bMH7piI9XiQmQSIL/rLhMgVov/oCHcjGgfQhwRaQ6Z76un/x2U9Fmh+Aa
   Bh9dkZGlDc6isQGnVLUKDjAidrbMaUcTfHYuAuJSjWzj9gYnjDns8q2Dg
   Pjt753trYsOx/Cl8jQskc9V2hQ5PbpIp7utk3KyNTg6tHwfFxvr2AS4av
   y2sNjDiBfJZJWdHMD0/pfWV8Ov9C3jYa6K08tiN8b1+u9q/luHlDCoy16
   AzRkUYEO00e5jzwSwzrV1fuLhijKZoYuQJv7rlmkD3xcb2tpYLVELcX+Q
   A==;
X-CSE-ConnectionGUID: xDiqvriVRAebmLOPBfHCGA==
X-CSE-MsgGUID: syRtcgv8TJ2X++ybfS5Kxw==
X-IronPort-AV: E=McAfee;i="6800,10657,11780"; a="90660184"
X-IronPort-AV: E=Sophos;i="6.23,225,1770624000"; 
   d="scan'208";a="90660184"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2026 00:03:54 -0700
X-CSE-ConnectionGUID: hX7f7uXsQYqqCPVCeIpe1Q==
X-CSE-MsgGUID: RXURSub2Toa3K79ANhpG4Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,225,1770624000"; 
   d="scan'208";a="234304141"
Received: from unknown (HELO fedora.iind.intel.com) ([10.49.0.89])
  by fmviesa008.fm.intel.com with ESMTP; 09 May 2026 00:03:52 -0700
From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	wangzhi@stu.xidian.edu.cn,
	byu@xidian.edu.cn,
	w15303746062@163.com,
	vdronov@redhat.com,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH v2 0/2] crypto: qat - remove unused ioctl interface
Date: Sat,  9 May 2026 08:00:11 +0100
Message-ID: <20260509070340.12201-1-giovanni.cabiddu@intel.com>
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

Giovanni Cabiddu (2):
  crypto: qat - remove unused character device and IOCTLs
  crypto: qat - rename adf_ctl_drv.c to adf_module.c

 .../userspace-api/ioctl/ioctl-number.rst      |   1 -
 drivers/crypto/intel/qat/qat_common/Makefile  |   2 +-
 drivers/crypto/intel/qat/qat_common/adf_cfg.c |  10 -
 drivers/crypto/intel/qat/qat_common/adf_cfg.h |   1 -
 .../intel/qat/qat_common/adf_cfg_common.h     |  29 --
 .../intel/qat/qat_common/adf_cfg_user.h       |  38 --
 .../intel/qat/qat_common/adf_common_drv.h     |   2 -
 .../crypto/intel/qat/qat_common/adf_ctl_drv.c | 466 ------------------
 .../crypto/intel/qat/qat_common/adf_dev_mgr.c |  32 --
 .../crypto/intel/qat/qat_common/adf_module.c  |  64 +++
 10 files changed, 65 insertions(+), 580 deletions(-)
 delete mode 100644 drivers/crypto/intel/qat/qat_common/adf_cfg_user.h
 delete mode 100644 drivers/crypto/intel/qat/qat_common/adf_ctl_drv.c
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_module.c


base-commit: f7dd32c5179d7755de18e21d5674b08f9e5cb180
-- 
2.54.0

