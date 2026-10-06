Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68BAC49C4AF
	for <linux-crypto@vger.kernel.org>; Tue,  6 Oct 2026 15:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791299198; cv=none; b=fzO+RlblDY8eonUp7xezimn6jqYPDA61bNGEXg4ZpZj9ZS+PysvxI6ZzVWC5mZKA6I4goSs9RsJz42DG/xE/qIUsNE0qoK5jl49FbGuov65RqgICqwGIykb7Rs9bjFlk0mxDvSGJeG7GlujwO31NaW6b6XTTnl5pnqMeClnxxts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791299198; c=relaxed/simple;
	bh=13XirGmV6dARQKUdgKZ1wEvJURknny1wkC0wTTJpOP4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=R8ZnG5337Tnr8k1Av6XdsF94kD6ZWnkc4Wc1Y0AIcW+MZog9WMtbWusye9qbu7Xg2kowMHOUMVxlO1uFqpN+JsN3NMaeLXGNHUG4gPlHEnLLKfcBnX/9Aa+JBOQPFSJB9uKEK1ti1EDSEuGdPLPn2X748ZXwl5ZnUZbBLz0AF1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=b3VNPZ6Z; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="b3VNPZ6Z"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791299197; x=1822835197;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=13XirGmV6dARQKUdgKZ1wEvJURknny1wkC0wTTJpOP4=;
  b=b3VNPZ6ZB7x/GMN7TQHiBUE0gDXpaQC7yBLrKqdFNwATx0hOdMifuGpD
   BQe2L4BKyKTwEjWaeoolU9QUBBL6qxd7Qqo7XpmODfVgt57pLGdOKfL1S
   JjWvkrXWZra1YTBUVxSwKH1aGZd7V5Gwn0GnyiNFCMCl8EGxbUBruHjYr
   kg+3hafchxciNifKF5RY0D2hOzH7Y+uUzhY4/jSiq1hl/SXfUpbmZv4xy
   ffWzFt+Ba9/jFSYWl1RDkRs9Pw2zbb1YV5EDILcQq6GuV8ku6F8axIuGj
   iG92Pyyd2EAE1CGg1tmN+3QqaWV2t+HmxYWFY/FQmrUJDFqOjQUxiZRT3
   g==;
X-CSE-ConnectionGUID: 0hqOD/IUSt6wCB8YAfO9tg==
X-CSE-MsgGUID: g4zc89AUTbSuSzEU6NpnTw==
X-IronPort-AV: E=McAfee;i="6800,10657,11927"; a="102513629"
X-IronPort-AV: E=Sophos;i="6.27,143,1787036400"; 
   d="scan'208";a="102513629"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2026 08:06:36 -0700
X-CSE-ConnectionGUID: 7JDjJIzhQgCEGi0t8g0/yw==
X-CSE-MsgGUID: wxquen0OQo+SjdFothHkPQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,143,1787036400"; 
   d="scan'208";a="285270236"
Received: from silpixa00401812.ir.intel.com ([10.20.226.90])
  by fmviesa005.fm.intel.com with ESMTP; 06 Oct 2026 08:06:35 -0700
From: Ahsan Atta <ahsan.atta@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	Ahsan Atta <ahsan.atta@intel.com>
Subject: [PATCH 0/2] crypto: qat - fix mutex lifetimes in the device manager
Date: Tue,  6 Oct 2026 16:06:46 +0100
Message-ID: <20261006150649.2517748-1-ahsan.atta@intel.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit

Two mutexes used by the QAT driver are initialised or destroyed on paths
that do not match their actual lifetime, so with CONFIG_DEBUG_MUTEXES
enabled both are reported on a dh895xcc with 32 host-bound VFs.

In summary:
Patch #1: state_lock is initialised at the end of adf_devmgr_add_dev(),
after the early return taken when an id mapping for the VF already
exists. Since that mapping outlives the VF, recreating VFs on the same
BDF leaves the lock uninitialised while adf_dev_up() and adf_dev_down()
take it. Move the initialisation up so it happens on every path.

Patch #2: vf2pf_lock is destroyed as part of the VF interrupt teardown
in adf_dev_down(), but adf_dev_stop_async() sends the RESTARTING_COMPLETE
message to the PF afterwards and takes that lock, so every PF restart
locks a destroyed mutex. The notification cannot be moved earlier, so
tie the lock lifetime to the accel device instead, next to state_lock in
adf_devmgr_add_dev()/adf_devmgr_rm_dev().

Both patches are fixes for stable.

Ahsan Atta (2):
  crypto: qat - initialise state_lock on every path in
    adf_devmgr_add_dev()
  crypto: qat - fix use of destroyed vf2pf_lock on VF restart

 drivers/crypto/intel/qat/qat_common/adf_dev_mgr.c | 10 +++++++++-
 drivers/crypto/intel/qat/qat_common/adf_vf_isr.c  |  2 --
 2 files changed, 9 insertions(+), 3 deletions(-)


base-commit: ee0454474a0f1b636dc96217b346e3571878b292
-- 
2.50.1

