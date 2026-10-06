Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D0853B71C9
	for <linux-crypto@vger.kernel.org>; Tue,  6 Oct 2026 14:48:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791298109; cv=none; b=aCU0oA8fHxNJKI3NDTp+IMDEp90phfqsmighkivIp63QRkeyIt3YfhsJJvC3c/BkXzfFwwXE2oYpPK8W2UP1scakXE7WjU25uHNTNYBjN3g3JZJQq86ahFMSWHfLFcCA/NUxpdT4BoEYFHaK1nYNZZzb4VJB0+aLt+gv5Fbv/D0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791298109; c=relaxed/simple;
	bh=eEd5E651bVWokbPu/NBn8u+/tnPL85y2fs6alOAUnwc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mKX+FZxCwVlVloEzq64khH5q4X1kBkFvuVUnzlI7d+dKV7sfMRniDViDrld01DDx4phlf0CMbK2M6BaEXVDAXxGisOIkVJzR1y66xjo53hDnOWgr0LLThG1c6DkrweyfL6cKQxwkbGXHjEqEC0guvnNpKs2NjzeltyieiADKrMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bhbP8gl6; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bhbP8gl6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791298107; x=1822834107;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=eEd5E651bVWokbPu/NBn8u+/tnPL85y2fs6alOAUnwc=;
  b=bhbP8gl6+tMeJT2esmUdFg7xzg+DuqWRNsX7RREgtoy1urvuETeC1cqc
   vQVF/5sZyFBU/w/sL884T6dyI1YAtzail57bI5/diEHqVbMKcQOVqqDMp
   oBDGFoR08eYIqBj4yEGHt+9U34R8pmWlTXG2ye3UITAxXzLheVnEQy21B
   Qh3x8PQcQplIyqfBJTOxxFwKI+Fu/RyxjGApfDwMTajNFH3rt4z/zerZs
   9uZR3IGB/HNvCvBOuPVnwbyDekNeuCcKzvjADBe4bhxPWqTQncQQb8r6g
   JCMJbGwB+zBFdnWxiujgktgAIxxFEzM4l7fb3c5YYU+UzmYAL3MBgawTM
   g==;
X-CSE-ConnectionGUID: +KobVFXaSm+tB4eNlwOYtw==
X-CSE-MsgGUID: vGzDVWJIQFesaRX26xAQFA==
X-IronPort-AV: E=McAfee;i="6800,10657,11927"; a="117509895"
X-IronPort-AV: E=Sophos;i="6.27,143,1787036400"; 
   d="scan'208";a="117509895"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2026 07:48:27 -0700
X-CSE-ConnectionGUID: qXn4z1fEThCk4EvTyRgMnw==
X-CSE-MsgGUID: puzt1nzqRvWwU3H6tmPgFQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,143,1787036400"; 
   d="scan'208";a="305115551"
Received: from silpixa00401812.ir.intel.com ([10.20.226.90])
  by fmviesa001.fm.intel.com with ESMTP; 06 Oct 2026 07:48:26 -0700
From: Ahsan Atta <ahsan.atta@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	Ahsan Atta <ahsan.atta@intel.com>
Subject: [PATCH 0/2] crypto: qat - enable three-service mode for QAT GEN5
Date: Tue,  6 Oct 2026 15:48:38 +0100
Message-ID: <20261006144840.2514754-1-ahsan.atta@intel.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit

QAT GEN5 devices (qat_420xx) have enough accelerator engines to run
three services concurrently, but the driver currently only allows a
maximum of two to be configured at a time, matching the GEN4 limit.

This series lifts that restriction so that symmetric crypto, asymmetric
crypto and compression can be enabled together on GEN5, as is already
possible on GEN6 (qat_6xxx).

In summary:
Patch #1: Define the firmware object layout, ring-to-service mapping,
thread-to-arbiter mapping and service-to-accelerator-engine accounting
required for the sym;asym;dc configuration on GEN5, and register the
new service combination in adf_cfg_services so that it can be selected
through the cfg_services sysfs attribute.

Patch #2: Update the cfg_services ABI documentation to state that GEN5
devices (qat_420xx) support a maximum of three combined services,
alongside the existing GEN6 entry. Documentation only, no functional
change.

Bairavi Alagappan (2):
  crypto: qat - enable three-service mode for QAT GEN5 devices
  Documentation: qat: document three-service mode for QAT GEN5 devices

 Documentation/ABI/testing/sysfs-driver-qat    |   4 +-
 .../intel/qat/qat_420xx/adf_420xx_hw_data.c   | 104 +++++++++++++++++-
 .../intel/qat/qat_420xx/adf_420xx_hw_data.h   |   6 +
 .../intel/qat/qat_common/adf_cfg_services.c   |   3 +
 .../intel/qat/qat_common/adf_cfg_services.h   |   1 +
 5 files changed, 113 insertions(+), 5 deletions(-)


base-commit: 32117b78aa099e5991df76c34ffbe18260342ff6
-- 
2.50.1

