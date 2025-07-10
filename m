Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 705D221D3E8
	for <linux-crypto@vger.kernel.org>; Thu, 10 Jul 2025 06:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752129596; cv=none; b=GVEbVq++5dxIUWqjQA103X6yNf8mVC8S7+qA+Ceq9Vb+lfObcp1Kr/U06Iuz6XIPVdilP8VemJ8I4Q317TFarQIoi/6M/bKiakeUdf6c2eOukTwauCV7b5uXVbO2Sq+HuPLb5sp+yma0lO22pBdWytBUF2Sz41TiaFebPBWI5xA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752129596; c=relaxed/simple;
	bh=utfwYJFRy9kxDSC5ui6uyPfxK3yf/jKyZOi/kGm+3r8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=sSQSqnayGoWbYbonSOpCRX0GRWIOdBnP8UTApOVSXYMZblxg07eYQqTOgpce7q7X7VznlOjExGOONgpQ3BunkrR4LTIOSHCE4cOUq1I2xknsY1Rg1puCPLpRXLeQtYCBgLHg3Ib/ZzDZnTv+dXkLC080b9B4IEAztgW2uhvmgVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=co8FZ+nG; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="co8FZ+nG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752129595; x=1783665595;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=utfwYJFRy9kxDSC5ui6uyPfxK3yf/jKyZOi/kGm+3r8=;
  b=co8FZ+nGZFupMKb7fG4n6Z8JmVkIT1jcWQqftMLJvuZJyFZ6v7gmgmFr
   QUBdHTuE4AvgGt1/AKm0CBV/YLpVfWtN7WDOosTx2raRi9I5w10xn1XQA
   VGzwfA1rhFUc7I9lh03PbNLnqAcJI/HbqbBgC/tFNhEvV3/YEr4YsbVcq
   zOUvjGevcCGE0JLKpkLKhaOVPlyCN3y4k2b+cpAdUo7b1NMNlpcwjWkLA
   vp8vR/uNnaJ6Proxmex+J5kTJIgFAFS6tzr+adaFynfX7czfjUNorcj37
   ZfB3z5VATUS2EvZfVLswNciIGChWiIwllq746t5g4oCc9lY2YABz8VulJ
   w==;
X-CSE-ConnectionGUID: 0WGmUnqPRlaCclCuj1QH+A==
X-CSE-MsgGUID: sZ1a7tP1RY+vZRi7The7Ag==
X-IronPort-AV: E=McAfee;i="6800,10657,11489"; a="53512240"
X-IronPort-AV: E=Sophos;i="6.16,300,1744095600"; 
   d="scan'208";a="53512240"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2025 23:39:54 -0700
X-CSE-ConnectionGUID: Wx1rNneySr6I4e2rsK1fCQ==
X-CSE-MsgGUID: TngBhdgPSZ6Lm78k20lUYA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,300,1744095600"; 
   d="scan'208";a="155632192"
Received: from t21-qat.iind.intel.com ([10.49.15.35])
  by fmviesa007.fm.intel.com with ESMTP; 09 Jul 2025 23:39:52 -0700
From: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com
Subject: [PATCH 0/3] crypto: qat - enable telemetry for GEN6 devices
Date: Thu, 10 Jul 2025 07:39:42 +0100
Message-Id: <20250710063945.516678-1-suman.kumar.chakraborty@intel.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch set enables telemetry for QAT GEN6 devices and adds handling
for DECOMP service.

Vijay Sundar Selvamani (3):
  crypto: qat - add decompression service to telemetry
  crypto: qat - enable telemetry for GEN6 devices
  Documentation: qat: update debugfs-driver-qat_telemetry for GEN6
    devices

 .../ABI/testing/debugfs-driver-qat_telemetry  |  10 +-
 .../intel/qat/qat_6xxx/adf_6xxx_hw_data.c     |   3 +
 drivers/crypto/intel/qat/qat_common/Makefile  |   1 +
 .../crypto/intel/qat/qat_common/adf_gen6_tl.c | 146 +++++++++++++
 .../crypto/intel/qat/qat_common/adf_gen6_tl.h | 198 ++++++++++++++++++
 .../intel/qat/qat_common/adf_tl_debugfs.c     |   3 +
 6 files changed, 358 insertions(+), 3 deletions(-)
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_gen6_tl.c
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_gen6_tl.h


base-commit: d1d2ba1cebb7cf113f7ad3fd3eb8089a0cb2bd46
-- 
2.40.1

