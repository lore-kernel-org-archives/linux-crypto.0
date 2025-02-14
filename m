Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65354245002
	for <linux-crypto@vger.kernel.org>; Fri, 14 Feb 2025 16:50:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739551812; cv=none; b=TUO+j71lY+tTHflwms50XOMEUTOAIOqtFgATYn8xRaVIqJarBpLLFQpv+AZIF/KlNK1z8R15G9EJZB5k7PlruqmZ5LPy/tDxqkVGu9AQfNk+sRfOo12X8p9w9//ztMtKi6/fUrvbURvJzpjDFnr4SEBy6hGDMx37U5bdZqQjTEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739551812; c=relaxed/simple;
	bh=gPoxK90B3Kqc/vZW7WBculCQBSTvt/GSpX4CcAVf7Pw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=dA17LpF9VKbVNAu+hfie4ZKPLoZfiqJM2e4jYgrnDORhneiMcG3DpbiX2tRLcrzFqXjS+s1eey5CjhOzBg7oOpv3mm4S+fq0TqrSVI6N4JL0RodCrsCWpXNI0/h3X8jGNyCu4e61kfqMkUR8OFK27BOd2SceCxxkjtyWwEugGMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Yx/RAmga; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Yx/RAmga"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739551811; x=1771087811;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=gPoxK90B3Kqc/vZW7WBculCQBSTvt/GSpX4CcAVf7Pw=;
  b=Yx/RAmgaJ1QP8f7Ude3bCKBtniLFw3Y9ztHpFRkIt9qW47pVIYU+2VVl
   11EmAEDZhT+B1Z7o0BvzI43nJ7Oq1rbnjGXklPsOEvZTjY/YRxIVDeWAd
   IW32AcdZjy31+d2fRA5y2/ycdzHJybrJ9MHUbZKHfC4KPx+inll234qd+
   YTbtKuOYmebSipWVGeAEV6Oa+sxKV4cAHmfE1rSYdt3fFWrHH4cVg51Ab
   AZlsDKHDZaemy/gnHl0nRjVvq+VkJ20ucbME4ZEVWUJqFgvuazcH2CKFm
   vv5jNlrlgdIq34nH152cXAfYLY3a6yxXbJtJgVQrZxuSbKM5EqJxlZG4g
   w==;
X-CSE-ConnectionGUID: XJpqCs7yQ7i76fSf4uScew==
X-CSE-MsgGUID: oxIIFgspROmwvFHiaB6+og==
X-IronPort-AV: E=McAfee;i="6700,10204,11345"; a="43959785"
X-IronPort-AV: E=Sophos;i="6.13,286,1732608000"; 
   d="scan'208";a="43959785"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2025 08:50:10 -0800
X-CSE-ConnectionGUID: eXqy6qltQUmMeAyMvQMxfA==
X-CSE-MsgGUID: 9cZJbrWtSD2DkVfsl0y9Bg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="118126351"
Received: from unknown (HELO silpixa00400314.ger.corp.intel.com) ([10.237.223.156])
  by fmviesa005.fm.intel.com with ESMTP; 14 Feb 2025 08:49:20 -0800
From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	andriy.shevchenko@intel.com,
	qat-linux@intel.com,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH 0/2] crypto: qat - refactor service parsing logic
Date: Fri, 14 Feb 2025 16:40:41 +0000
Message-ID: <20250214164855.64851-2-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit

This small series refactors the service parsing logic in the QAT driver
by replacing hard-coded service strings with a more flexible approach.

The first patch removes an unnecessary export. The second patch reworks
the service parsing logic to allow being extended in future.

Giovanni Cabiddu (1):
  crypto: qat - do not export adf_cfg_services

Małgorzata Mielnik (1):
  crypto: qat - refactor service parsing logic

 .../intel/qat/qat_420xx/adf_420xx_hw_data.c   |  16 +-
 .../intel/qat/qat_4xxx/adf_4xxx_hw_data.c     |  11 +-
 .../intel/qat/qat_common/adf_accel_devices.h  |   1 +
 .../intel/qat/qat_common/adf_cfg_services.c   | 167 +++++++++++++++---
 .../intel/qat/qat_common/adf_cfg_services.h   |  26 ++-
 .../intel/qat/qat_common/adf_cfg_strings.h    |   6 +-
 .../intel/qat/qat_common/adf_gen4_config.c    |  15 +-
 .../intel/qat/qat_common/adf_gen4_hw_data.c   |  26 ++-
 .../intel/qat/qat_common/adf_gen4_hw_data.h   |   1 +
 .../crypto/intel/qat/qat_common/adf_sysfs.c   |  12 +-
 10 files changed, 202 insertions(+), 79 deletions(-)

-- 
2.48.1

