Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E7261F2384
	for <linux-crypto@vger.kernel.org>; Tue, 11 Feb 2025 10:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739268009; cv=none; b=aG07xZpfZgl/vpKyHXK0mxkpiMd7KipuBr9Ioa0/ByDKPWBlJ6qVHF5F+/UzTQvh53U6kp53QE6zAlutvKXFkqV3G5Pou6F+X3gGL/Vd3l63Xl23IgG/cP9zhMT2yxOpLG6Q1dcaDp3swcm86iHibT/CM5aGlsdSIC4LOHzUmpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739268009; c=relaxed/simple;
	bh=70N/4Gd/UEwHlgWGqTeJ/RrtPQOF9D7C89JuAu6XQOQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bsHNlYVntAdUt2fvhvvaYAveUP8tbqnwU9L0rQ16BCPKC8MWl8xwcVc6RgHojrhBwr964RVTCB3SHUdetkFM0e9Nlc8wvt8ZJpmoxOrW1GwkNSG1iMz7qlLzVk0t95J9vjR7MONaG+KF3LNRXtMd9ODWRsDgFpi1Yh6E6fYD5ig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mCMBOSJ2; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mCMBOSJ2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739268007; x=1770804007;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=70N/4Gd/UEwHlgWGqTeJ/RrtPQOF9D7C89JuAu6XQOQ=;
  b=mCMBOSJ2PVc0ISKhPcbznOuOxb8ds/TaBxmWw7psqPqfvccJNZxGO2S0
   2/f3QiZFKkevTnUJPKWpGwGfiztJNTiUVza62yUWLRWY0tXzQ74UQfDVJ
   0JSqva4xAuJDg7kwMLQJL4dRBgK8dPXfzeNmFmTeQp91yWaAiZCkqjC54
   5mDJ9mOA8boAbCfPAaO/RHwCp82A09AQLNMqZ2GtoU18ru3Rm2aGUWvP4
   q7YG9WK2+50TC3qhHmqBs2U8QLm0uKqLV/NdfHR3f6rUwswNClT/Cr++e
   vNBSkBQvNjeyPxoUuyKECUHhflFS7qLMzbT9vcLTwuBxDWtpOY/EB0Kic
   A==;
X-CSE-ConnectionGUID: nr9/2DLYQaeRVfbidP9NGA==
X-CSE-MsgGUID: 6njcnW4YQuu4ktE1nypYJQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11341"; a="27477121"
X-IronPort-AV: E=Sophos;i="6.13,277,1732608000"; 
   d="scan'208";a="27477121"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2025 02:00:07 -0800
X-CSE-ConnectionGUID: ZmimcONdSP+0ll30fTOE5A==
X-CSE-MsgGUID: UDEuRFY8SjyqMzHUEIotmQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="112321327"
Received: from unknown (HELO silpixa00400314.ger.corp.intel.com) ([10.237.223.156])
  by orviesa010.jf.intel.com with ESMTP; 11 Feb 2025 02:00:05 -0800
From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	andriy.shevchenko@intel.com,
	qat-linux@intel.com,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH 0/2] crypto: qat - improvements to Makefiles
Date: Tue, 11 Feb 2025 09:58:51 +0000
Message-ID: <20250211095952.14442-1-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit

This small series aligns the Makefiles in the QAT driver to the kbuild
documentation, by fixing the object goals, and reorders the objects in
the qat_common Makefile for making it easier to maintain.

Patch #1 does not have an explicit Fixes tag as there isn't any
outstanding issue caused by the current Makefiles.

Giovanni Cabiddu (2):
  crypto: qat - fix object goals in Makefiles
  crypto: qat - reorder objects in qat_common Makefile

 drivers/crypto/intel/qat/qat_420xx/Makefile   |  2 +-
 drivers/crypto/intel/qat/qat_4xxx/Makefile    |  2 +-
 drivers/crypto/intel/qat/qat_c3xxx/Makefile   |  2 +-
 drivers/crypto/intel/qat/qat_c3xxxvf/Makefile |  2 +-
 drivers/crypto/intel/qat/qat_c62x/Makefile    |  2 +-
 drivers/crypto/intel/qat/qat_c62xvf/Makefile  |  2 +-
 drivers/crypto/intel/qat/qat_common/Makefile  | 66 +++++++++----------
 .../crypto/intel/qat/qat_dh895xcc/Makefile    |  2 +-
 .../crypto/intel/qat/qat_dh895xccvf/Makefile  |  2 +-
 9 files changed, 41 insertions(+), 41 deletions(-)

-- 
2.48.1

