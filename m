Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13DF3272E5C
	for <linux-crypto@vger.kernel.org>; Fri, 25 Jul 2025 09:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753434579; cv=none; b=gbAWhYpJ+aiV2g2yTkoEsQem5E+vi9In8bQ3Y8cZ9Z2xpcYski2R7zOiEpO7/5OkU7NEE9GIvIc+7pjcbbYN6uz/mrbVXFgq56DhuETkW38hhRl0xn09zJ6idDYgRI/MZIQ3VE5eZHmWmaFtPOXwxt0rykQRvFbSMOmj2hDaKpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753434579; c=relaxed/simple;
	bh=Ek8gPMrrUut/pfrbl3SV8ZABRSAoNDSAwTd8ikX/ieo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=rI1ul810uCwm0lsDdAdT3k6xW0sUw2KMnf3yaam6bdkuZPEhHxrh8VtjmhIY5MpS9LrALafR+PHOzighIppVgnDxKu2/6XbBD28tbnbt2e/9Vqs/1jkMXWMvSvGGLZQukb5L6r3W0cv3ZGYnhc3xjfCf+Nir5pGMSEpcsfKxDrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lM+AuSnF; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lM+AuSnF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753434578; x=1784970578;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Ek8gPMrrUut/pfrbl3SV8ZABRSAoNDSAwTd8ikX/ieo=;
  b=lM+AuSnFDVzbgG1ndbrVJexfvttBsRJR0z3cTj/PIxvz29dT2doMg7ie
   k+47lVbjbORopbya01KADenoj2qKp3HG8WuqnZvzaWIp16MZSpZP6SQLX
   unFq8iX4PKLPWhX5ukf+ffZfCWytHBmXi0seWDQA6wsDNA6kDT10hGuLo
   VJi5Y+yEd3eSqAC0A/1QtJymwKaMEvhcj3SJ7DJo+7h/fBL0XX95VgSc2
   iQ1MjNTh9tr6/Ym+YmfXaMC8Y4sys6Rn4Z6nYqYCXKsadtIw/APy/Oz8a
   F2Cs/QGwNWdIT54Eh8OQEN+qYcCMcoZ2+ESbVvYW8rXC3y7jPQkCbddJH
   g==;
X-CSE-ConnectionGUID: 8EROVI72RB+NaH95ISKmkQ==
X-CSE-MsgGUID: yzDZf6xrStyAa5vSoV1xXQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11501"; a="58388361"
X-IronPort-AV: E=Sophos;i="6.16,339,1744095600"; 
   d="scan'208";a="58388361"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2025 02:09:37 -0700
X-CSE-ConnectionGUID: IPik5bNLTwCVwsLLuImCpg==
X-CSE-MsgGUID: aZHFPFskRdy9hrR+WUr6VA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,339,1744095600"; 
   d="scan'208";a="165316064"
Received: from t21-qat.iind.intel.com ([10.49.15.35])
  by orviesa004.jf.intel.com with ESMTP; 25 Jul 2025 02:09:36 -0700
From: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com
Subject: [PATCH 0/2] crypto: qat - add additional telemetry counter for GEN6 devices
Date: Fri, 25 Jul 2025 10:09:28 +0100
Message-Id: <20250725090930.96450-1-suman.kumar.chakraborty@intel.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch set adds support for telemetry command queue counters for QAT
GEN6 devices.

Vijay Sundar Selvamani (2):
  crypto: qat - add ring buffer idle telemetry counter for GEN6
  crypto: qat - add command queue telemetry counters for GEN6

 .../ABI/testing/debugfs-driver-qat_telemetry  |  27 +++++
 .../crypto/intel/qat/qat_common/adf_gen6_tl.c | 112 ++++++++++++++++++
 .../intel/qat/qat_common/adf_telemetry.c      |  19 +++
 .../intel/qat/qat_common/adf_telemetry.h      |   5 +
 .../intel/qat/qat_common/adf_tl_debugfs.c     |  52 ++++++++
 .../intel/qat/qat_common/adf_tl_debugfs.h     |   5 +
 6 files changed, 220 insertions(+)


base-commit: 035a6a74c627b300b5e23448c42c05830a525b6a
-- 
2.40.1

