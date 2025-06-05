Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA4E61F4606
	for <linux-crypto@vger.kernel.org>; Thu,  5 Jun 2025 11:25:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749122743; cv=none; b=pKvmiamHM9khnSP+z3x7V6Tf9DUNYNVhOgM8kVOpOmJArar47AsDHYoJTFraxulEebh6b/ZDTPcA8lugQZCYqsdRhGKGVfA0XlYblrDj5cHo6DGRMNF6Zoi/lz963FTDv2DHIaVcNJChHZOl8RHlysGHD8nmyQKNnoPFZSDinew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749122743; c=relaxed/simple;
	bh=DUqr3Tyk6wtvGDQxqTEJRfs/AZdH8kIWQB31D9ochvU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=d+jk+Ix1AC13o796vYVwxnqmXR750yTec0RhpCW2Fbb8SNdwBPOxDAobHV8/Fejqn1UVbfcgBr3cEhtBlbg1xbTQNsdXVB9GTJVkasyUpb0d0pe6YotvG4V8tyLmL4m1zipDSOlHjs4oicK5X5WGQLbGoTJnCbHh7wZ7GLC6low=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=R1ReyaX7; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="R1ReyaX7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749122742; x=1780658742;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=DUqr3Tyk6wtvGDQxqTEJRfs/AZdH8kIWQB31D9ochvU=;
  b=R1ReyaX7nc3A4NFki82PQ6zrVJgmDHMh/02evYLiZtWb8jznez+yt490
   cnlnlC56G0sMjVK1ixeg9MmoLvNAeade4XTLsRbMvE36qN/QeKdolCjbC
   HtJ99iUo12oIK61hGlSOulKjBIBrUL8alU0cILgqmo+9hSTrxlb3yyd5V
   hlybdO+3b6klrpjMbeQwEccILJPcAU+dfzUBVZO54Ss+4lVVqXsgfRzQc
   ZV5g49pTDOlSyDlIt4MMwYu2ertziYPZ2jS9Tgr4fOKk93P6MyRJoqboy
   CSUK21jR9Mpijh3/1NGQgzDeN/x9KbMwDwl7L7GcPwwe/qcABPb4PrmC0
   Q==;
X-CSE-ConnectionGUID: pF/myLSpS+CqlLnI75klSQ==
X-CSE-MsgGUID: 9zwWWQgvSseyRtyeFTaD0w==
X-IronPort-AV: E=McAfee;i="6800,10657,11454"; a="51305195"
X-IronPort-AV: E=Sophos;i="6.16,211,1744095600"; 
   d="scan'208";a="51305195"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2025 04:25:42 -0700
X-CSE-ConnectionGUID: SGlbCFw1QO6I2gjvsf8Etw==
X-CSE-MsgGUID: vTmkmOkER4q4afN3AILjBg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,211,1744095600"; 
   d="scan'208";a="145988323"
Received: from t21-qat.iind.intel.com ([10.49.15.35])
  by fmviesa010.fm.intel.com with ESMTP; 05 Jun 2025 04:25:40 -0700
From: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com
Subject: [PATCH 0/2] crypto: qat - enable decompression service for GEN6 devices
Date: Thu,  5 Jun 2025 12:25:25 +0100
Message-Id: <20250605112527.1185116-1-suman.kumar.chakraborty@intel.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch set enables the decompression service for QAT GEN6 devices
and updates the ABI documentation.

Suman Kumar Chakraborty (2):
  crypto: qat - add support for decompression service to GEN6 devices
  Documentation: qat: update sysfs-driver-qat for GEN6 devices

 Documentation/ABI/testing/sysfs-driver-qat    | 50 ++++++++++---------
 .../intel/qat/qat_6xxx/adf_6xxx_hw_data.c     | 13 ++++-
 .../intel/qat/qat_common/adf_cfg_common.h     |  1 +
 .../intel/qat/qat_common/adf_cfg_services.c   |  5 ++
 .../intel/qat/qat_common/adf_cfg_services.h   |  1 +
 .../intel/qat/qat_common/adf_cfg_strings.h    |  1 +
 .../intel/qat/qat_common/adf_gen4_hw_data.c   |  3 ++
 .../crypto/intel/qat/qat_common/adf_sysfs.c   |  2 +
 8 files changed, 52 insertions(+), 24 deletions(-)


base-commit: bc952a652f56cf45027b68f4de57f4182b2975dc
-- 
2.40.1

