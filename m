Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53B17391841
	for <linux-crypto@vger.kernel.org>; Fri,  8 May 2026 09:19:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778231960; cv=none; b=L3wLpL85Z15Y8bKDsGgCyTmSjBvJEsyigFSnNG//siyocCACqu732EaLY69mZVhRl1GbTo3qV1s1hJSi/PaaOVQqvZbqOhgaSdVazDzqCA40JukBoeoy3AlSWmyuxA+7EqNQl12jlp2frRClU17G6Cb8f8NE75yryAdFwOlawfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778231960; c=relaxed/simple;
	bh=VY+hF2GB4PYTwHtJtktYHKfdj/kbNHWf9kBvXuFRvi4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RdlXViVRGa/o5K20Wkn1DA1dvI03rmpYzWdgJRPw/CfFnR8Ztz7O8NcQ6AS/2bgcMNhZqNpOc1R8jY32Y+4njD76rzqvAPN+6WhgwHZUDtOlyH8ke7XFy2xSWCLaR1yTFObmgK18rCZ3iHTcdvYomstmrO4X5y/l3CxhDagFxPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jQCCV+US; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jQCCV+US"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778231957; x=1809767957;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=VY+hF2GB4PYTwHtJtktYHKfdj/kbNHWf9kBvXuFRvi4=;
  b=jQCCV+USg/o09X+H0bK2PMZM21sJqiCSLJzXma84L1Ei7jJGcj2iyLmR
   XKV9UaPY5/uQhnxM3+Yzb+DqkKuPkyJqaBGvwlaOdmIjaRmwAZcciQ77e
   d+97cLPwsHK2P6+ab5nIyeBa/+yL+KvfDTPjWPATWb2kP4EfJhb7z/Mx8
   oJ7ao57rAxsMvR5NPwOYB5UGUoMy2eFi51LtH6KtBCjuSH4d7wHU8EyM3
   tBfSe9fSz1XAsli+Mo06GwqcnslX4mEC+rusmnPDxRfFcCB8JKCOvuTgW
   J+jQwiiW+cTV8broK3zeHzWZNwaquZmG/GApviOrMf0MtM1DF94TbqFm6
   w==;
X-CSE-ConnectionGUID: aFZ6euawRf+okBo/OIxj0Q==
X-CSE-MsgGUID: S/Ku4gjjSAqe+qTuOwvquQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11779"; a="79238666"
X-IronPort-AV: E=Sophos;i="6.23,223,1770624000"; 
   d="scan'208";a="79238666"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2026 02:19:17 -0700
X-CSE-ConnectionGUID: 9JS9xCcPQhCjlMFWsbT9sA==
X-CSE-MsgGUID: EwOBn+m0SkOrnD+IbalweQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,223,1770624000"; 
   d="scan'208";a="240712885"
Received: from silpixa00401971.ir.intel.com ([10.20.226.106])
  by orviesa003.jf.intel.com with ESMTP; 08 May 2026 02:19:15 -0700
From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	wangzhi@stu.xidian.edu.cn,
	byu@xidian.edu.cn,
	w15303746062@163.com,
	vdronov@redhat.com,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH 0/2] crypto: qat - remove unused ioctl interface
Date: Fri,  8 May 2026 10:18:22 +0100
Message-ID: <20260508091912.206913-1-giovanni.cabiddu@intel.com>
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

Giovanni Cabiddu (2):
  crypto: qat - remove unused character device and IOCTLs
  crypto: qat - rename adf_ctl_drv.c to adf_module.c

 .../userspace-api/ioctl/ioctl-number.rst      |   1 -
 drivers/crypto/intel/qat/qat_common/Makefile  |   2 +-
 .../intel/qat/qat_common/adf_cfg_common.h     |  27 -
 .../intel/qat/qat_common/adf_cfg_user.h       |  38 --
 .../crypto/intel/qat/qat_common/adf_ctl_drv.c | 466 ------------------
 .../crypto/intel/qat/qat_common/adf_module.c  |  64 +++
 6 files changed, 65 insertions(+), 533 deletions(-)
 delete mode 100644 drivers/crypto/intel/qat/qat_common/adf_cfg_user.h
 delete mode 100644 drivers/crypto/intel/qat/qat_common/adf_ctl_drv.c
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_module.c


base-commit: c9e14a7f54e4552968e3103fa871b1380ca23208
-- 
2.54.0

