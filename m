Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E683D1E5B88
	for <linux-crypto@vger.kernel.org>; Tue, 24 Mar 2026 18:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774376382; cv=none; b=DLmx1ItTCSeq0KiO0E9CWOV3m6qDZ/aLIzRF++gvVqn8C+aK/F8a0qWEr/WjvmNcfIurLwwMHPDnT4o80CjF9avTlNeegN7ZiQbltu7H2JOEf22vMILEsGSPfZhoMcHdE4BWQaxn9SQM/2jn/NYxXKiJNZWEv4xw8dcK+82R7JU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774376382; c=relaxed/simple;
	bh=Oj4lXPFZ0HiWRJm+8pD9eAjKlKRhOMqQVaH49oIweU4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dUdaboWMHCVJBMwhZ9vl2CrMw/jDvRvsdVhVTuthcsFouwZj+SGlMbWA/qY5Q+WAehRvQmui8ecKQiStD3iz2WG8LDp4EEqYTl0YeJtIKZuhLKyMfrG1PI4RLqnixDYwSViSe9BOe30jns3Sd/9pDUJ8vNC4QvqzNZOO5jY0tLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hv5QGqGr; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hv5QGqGr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774376380; x=1805912380;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Oj4lXPFZ0HiWRJm+8pD9eAjKlKRhOMqQVaH49oIweU4=;
  b=hv5QGqGr5wkapTPtDZEWrARKoRhFILmNcZ5rGv+/N5FkBl8xpQTG/WHP
   MapFrrYvWxpRNoZH/jVfma0sWZtNO7tDOlU4Rd//UUPWf8+IJMovcvO/8
   6IvOuljxSKJnqziRd+QGBVlDlArGOSddT4Ve75jlSE09cg3fEyFAEkBm7
   PGmo9mka2SL179k0nLdzx1MiPM7ewSumZnKI9tKemJVAyCOq8sU9TeJwH
   dVnIKQ7FfUBdvEaz+L8wHp0M3qr3x8WaG4YuaYZl0LNzumBNEauM6Rg7b
   fhkH3xu85zC7NhLggpVeS0Qn6jafB90t0FepjETqo+cBwz08MW8Ytazuy
   Q==;
X-CSE-ConnectionGUID: +iGlj8ZkQ3a8dCJXwLdFbA==
X-CSE-MsgGUID: G5suhwOuQNeUS26eHcRDPg==
X-IronPort-AV: E=McAfee;i="6800,10657,11739"; a="86480275"
X-IronPort-AV: E=Sophos;i="6.23,138,1770624000"; 
   d="scan'208";a="86480275"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2026 11:19:39 -0700
X-CSE-ConnectionGUID: 8H+YoVe+RbKBtmUzh3YgBA==
X-CSE-MsgGUID: wllNoxSjQR+3mgwzJc0WhA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,138,1770624000"; 
   d="scan'208";a="247489422"
Received: from silpixa00401971.ir.intel.com ([10.20.226.106])
  by fmviesa002.fm.intel.com with ESMTP; 24 Mar 2026 11:19:39 -0700
From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	atharvd440@gmail.com,
	andriy.shevchenko@intel.com,
	ahsan.atta@intel.com,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH 0/2] crypto: qat - fix and cleanup RAS sysfs show functions
Date: Tue, 24 Mar 2026 18:17:22 +0000
Message-ID: <20260324181936.122027-1-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit

This small series fixes a type mismatch bug in the RAS error counter
sysfs interface of the Intel QAT driver and follows up with a cleanup to
use the recommended sysfs output API.

Patch #1 fixes a type mismatch in the RAS sysfs show callbacks: the
local counter variable was declared as 'unsigned long' while
atomic_read() returns int, causing an implicit conversion and a wrong
'%ld' format specifier. Patch #2 follows up by migrating the same
callbacks from scnprintf() to the recommended sysfs_emit() API.

Atharv Dubey (1):
  crypto: qat - replace scnprintf() with sysfs_emit()

Giovanni Cabiddu (1):
  crypto: qat - fix type mismatch in RAS sysfs show functions

 .../intel/qat/qat_common/adf_sysfs_ras_counters.c    | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)


base-commit: 8da773efcd2b505cca6bbd13aad4a28fda61cf37
-- 
2.53.0

