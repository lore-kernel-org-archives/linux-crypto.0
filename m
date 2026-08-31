Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80DCA357A25
	for <linux-crypto@vger.kernel.org>; Mon, 31 Aug 2026 06:35:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788158108; cv=none; b=B8beeO9DThCovvdD2OsdcRgRGdSW4cvxydCaj9ajeXC4A4RCq9+jehXBMmBnb/MmearX18As4I3KQeeewZ9YMTNMHc7T49FXHkxqbPfOXwX0Q4FYXfezLViwla6EXTH8O2KASOWteVCkNwhwrzLykoUBhRLN6wd5AWi32BaXqc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788158108; c=relaxed/simple;
	bh=TR3NMeAX3pBc+d1q6waxSmvMlGyeSd7QOUqOZRqdXvY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XIH+sLbcR+82zD0l/VehOUWS4IfWthWc60zy+OWWhaLALIPFKW0JzMi2700C3umqag0fd+WPEqUxjEQwIXyWtWopfZgvd+6K4DYqqgBb9T5alou5Bi890K7QHxzgcObvEuDwn9u1+1cz6y2WSAJXYISiwmqL0v6vaQ7zUC0xEAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IRV7rBz1; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IRV7rBz1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788158106; x=1819694106;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=TR3NMeAX3pBc+d1q6waxSmvMlGyeSd7QOUqOZRqdXvY=;
  b=IRV7rBz1vAVla2AVwRQFmI0+m+mIsctnD/VRfDK9oYTZPMPcGSx3iaVX
   UK8A7cgRg7UuBwf2BOcwxN/eomrZHHdG4fJ1tQB6k8TrhlnGim7cnp3xm
   0yDrDFZFc0NaryvBby1jvm2K2fBDvHEbZmAZK+a9HYa37WLb9PuGCITje
   IrBv9RE1OjB84GNNikS7VhEZgczxoWzoNQB3NSScJnpG0OYcbxTUrm7y5
   7LIxejxcQ8tgA/uorJvOCPeuNQ0UYX4REPfY/zz8cvQXLdH+7t/5SQZco
   dckPVUXoGIKp20B0CzHMTWtDvp8Vu3wmbLxG/ZzOCo/JrG+ad3AIUnM3u
   Q==;
X-CSE-ConnectionGUID: THrtT241Sei3yvewUDSLUQ==
X-CSE-MsgGUID: zuiYTIISRnCcKZY3kmUieQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11891"; a="105930207"
X-IronPort-AV: E=Sophos;i="6.25,252,1779174000"; 
   d="scan'208";a="105930207"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2026 23:35:06 -0700
X-CSE-ConnectionGUID: W12GUPauR4qTXdCiBUuTuA==
X-CSE-MsgGUID: GTIOIU6RQ6We19oAkM/atA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,252,1779174000"; 
   d="scan'208";a="267377666"
Received: from dmr-bkc.iind.intel.com ([10.49.111.53])
  by orviesa010.jf.intel.com with ESMTP; 30 Aug 2026 23:35:05 -0700
From: nitesh.venkatesh@intel.com
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	Nitesh Venkatesh <nitesh.venkatesh@intel.com>
Subject: [PATCH 0/2] crypto: qat - fix KPT disable and clarify ABI
Date: Mon, 31 Aug 2026 06:32:32 +0000
Message-ID: <20260831063355.668528-1-nitesh.venkatesh@intel.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Nitesh Venkatesh <nitesh.venkatesh@intel.com>

This small series fixes a recoverability issue in the QAT KPT (Key
Protection Technology) sysfs interface.

Patch 1 fixes the KPT enable sysfs attribute so that '0' writes are
always accepted when the device is down. The asym-service check
previously rejected disable writes when the service was not 'asym',
leaving KPT reported as enabled after switching services.

Patch 2 documents that the device must be in the down state before
the KPT enable attribute can be changed.

Nitesh Venkatesh (2):
  crypto: qat - allow KPT disable when service is not asym
  Documentation: qat: clarify KPT enable device-state requirement

 .../ABI/testing/sysfs-driver-qat_kpt          |  3 ++-
 .../intel/qat/qat_common/adf_sysfs_kpt.c      | 24 ++++++++++++-------
 2 files changed, 18 insertions(+), 9 deletions(-)


base-commit: 6f440283743bd408bfe95a3d1f77aac559130e39
-- 
2.52.0

