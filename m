Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BEF523C519
	for <linux-crypto@vger.kernel.org>; Tue, 13 May 2025 10:25:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747131936; cv=none; b=W7F0uZwxVuUiFHN31r0Bw28vor1XC9yxttRdLoElwGHpsywyUtRfKo2+5jFnQsyMR09dFvRdxHF8XZ0bPZcRO+2Wb2ugiFmpPgUBg9RjJHvIX9qodtf4bVkNj3Mu+9xOb0WTXVlr/60Ee3YI1iNxb0XekEycmwYYsISXmi2tuDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747131936; c=relaxed/simple;
	bh=vPtMQcwwRObnaL74iAW+TMnh8G5RNmYVImDD6ulHa6I=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=QNJfWMhpwJQHXqql6oNCx951AUu4JgrLwQhiTNWHeL9y1tKPJuIVipK3KgSKKkGrcSCcQtZRGAb9QOtYbtVajRD31aQbkjwd6ekuPXazeHuFPX70InrNc82qVKWPVWT8losnnRdCnVtiu4msjxn1cVGE0z4UnvRvqkmtn5YJyLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iVrbALRe; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iVrbALRe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747131934; x=1778667934;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=vPtMQcwwRObnaL74iAW+TMnh8G5RNmYVImDD6ulHa6I=;
  b=iVrbALRe5iVPDswxVHO3fgwCf9lLLmrP3f6OhDcuwNtFTMuL+/y2UeTH
   4Gyd5rij+Iqd4W2DnDKyl1S7c9hvn9apPIYBCZ3ZK0vDLn9DkwDDWPkLl
   Kv7erDv7N8voGYxvuh4lCSFMT2NIo71R2gmln4Yt9Fu6zkyMXRcH9tWZ1
   tkTHgJ9C+uHnk9xsm7/kcGRuKUTUv2Gt89yI7RekmMKysWSxnNoqEPduh
   91mzwP5hgE+dKG833YMyKoS9eGzymCUdsYsQNaWJO5LgUYAwOoXj7cN8i
   ayvaS07uHAnCAtzNrzgkSpVHWnM2112LcBzubI726F+RswV8d30AlOquu
   A==;
X-CSE-ConnectionGUID: tCX2FkKjRTCFxrlvg7WcRQ==
X-CSE-MsgGUID: nWgkRTMtS2qJ8x8b5pNLRA==
X-IronPort-AV: E=McAfee;i="6700,10204,11431"; a="48076410"
X-IronPort-AV: E=Sophos;i="6.15,284,1739865600"; 
   d="scan'208";a="48076410"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2025 03:25:33 -0700
X-CSE-ConnectionGUID: WSZgmRdYTwiy7WSGi6slUg==
X-CSE-MsgGUID: N6fIEDLXQbi2tT/kWvV38w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,284,1739865600"; 
   d="scan'208";a="142786391"
Received: from t21-qat.iind.intel.com ([10.49.15.35])
  by orviesa005.jf.intel.com with ESMTP; 13 May 2025 03:25:32 -0700
From: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com
Subject: [PATCH 0/2] crypto: qat - enable RAS for GEN6 devices
Date: Tue, 13 May 2025 11:25:25 +0100
Message-Id: <20250513102527.1181096-1-suman.kumar.chakraborty@intel.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch set enables the reporting and handling of errors for
QAT GEN6 devices. It also enables the reporting of error counters
through sysfs and updates the ABI documentation. 

Suman Kumar Chakraborty (2):
  crypto: qat - enable RAS support for GEN6 devices
  crypto: qat - enable reporting of error counters for GEN6 devices

 .../ABI/testing/sysfs-driver-qat_ras          |   8 +-
 .../intel/qat/qat_6xxx/adf_6xxx_hw_data.c     |   2 +
 drivers/crypto/intel/qat/qat_6xxx/adf_drv.c   |   2 +
 drivers/crypto/intel/qat/qat_common/Makefile  |   1 +
 .../intel/qat/qat_common/adf_gen6_ras.c       | 818 ++++++++++++++++++
 .../intel/qat/qat_common/adf_gen6_ras.h       | 504 +++++++++++
 6 files changed, 1331 insertions(+), 4 deletions(-)
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_gen6_ras.c
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_gen6_ras.h


base-commit: 3e9254bcf48fb7e387209be7cec96f0de6d2d37f
-- 
2.40.1

