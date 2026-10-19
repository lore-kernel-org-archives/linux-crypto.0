Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 610E8368D46
	for <linux-crypto@vger.kernel.org>; Mon, 19 Oct 2026 11:07:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792408067; cv=none; b=UtXYWbmAESMPXaKPDkSbN3lWfhgE6g2VCDjvu5OQQORjeXpDAU54GQuAhq5zOE8SJzim5mQUQDf8oRM6GJSeZVYSOFHdi2jG+heA0XazaSAOp7HyQLFlg/AGv6Tt0X41f3Afx42hWz9GBZQFOaGhofPywbZu0u/d2JXmPbW7XHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792408067; c=relaxed/simple;
	bh=w0NZJZ1lgJMCL+3vY6/1RmF05SMJNGwtvbJZzx5bYPc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ClsgYhGJw9YuYOge3EqC2A5321c2/0VlDTmLxrkMMbxvISQBuqKBZ+vhi1jvOGlcNqrS+ywBk4ZNuiMalDh6MwlBOsJwAwdLN4ksXEOdcogz2i8ShL2owl/hlkA4S1zKuJ2DB0i10RhVCSXxCw8nXNENatp3prkLafU23iw/2hQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CbjIbGpC; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CbjIbGpC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792408066; x=1823944066;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=w0NZJZ1lgJMCL+3vY6/1RmF05SMJNGwtvbJZzx5bYPc=;
  b=CbjIbGpCLN105pwDDefhpq/3antwfIZqIeV1nRyS39493xbbfsaLnDhu
   KpitIH3avgSa8kVVL7WZfR7y1emtVCk9EsVvimBgPrtE6mRSrYKd/IsVD
   uuC0UYuh94aSPcNYH2FZyuv8Jh0eRr/l+1XlBMQuRx1VTF25mq11ek1d6
   KeOCBsuCl+1r2u3QxxBibjlCANvPElMdG26tCZTt7T+BswzHgiELwWC0U
   TaZUYiQeRJX319R9NYXBPI+4nDP0gDlrCqSRkjq4qhz2KYadTbBYDwGL+
   AErcpYVdQ4GiF+q8Enjo6qJ3g5DMzaWMRztXoJtcmCjd0r+kMfa7Dxk4a
   Q==;
X-CSE-ConnectionGUID: xGRcpUBBQpqqZVYgchNSSg==
X-CSE-MsgGUID: WYT0qqZIQjeX9loTdxTA5Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11939"; a="1088246"
X-IronPort-AV: E=Sophos;i="6.27,167,1787036400"; 
   d="scan'208";a="1088246"
Received: from fmviesa012.fm.intel.com ([10.60.135.152])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2026 04:07:42 -0700
X-CSE-ConnectionGUID: kwvcgRjJREKP1s/LBpMTyQ==
X-CSE-MsgGUID: P6Z7yDOZT+auGOfjL/HjJA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,167,1787036400"; 
   d="scan'208";a="4267833"
Received: from indlpbc065983.iind.intel.com ([10.49.120.87])
  by fmviesa012.fm.intel.com with ESMTP; 19 Oct 2026 04:07:40 -0700
From: George Abraham P <george.abraham.p@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	George Abraham P <george.abraham.p@intel.com>
Subject: [PATCH 0/3] crypto: qat - fix rate limiting and telemetry for QAT GEN6 wireless
Date: Mon, 19 Oct 2026 16:33:53 +0530
Message-Id: <20261019110356.3781949-1-george.abraham.p@intel.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This set contains fixes for the QAT GEN6 driver (qat_6xxx), mostly
affecting devices running in wireless mode, where only the symmetric
service is available and the firmware uses WCP (wireless cipher) slices
and the adf_wcy_fw_config object layout.

Patch 1 relaxes the rate limiting initialization so that throughput
limits are validated only for enabled services. Without it, devices that
support only a subset of services fail to initialize rate limiting.

Patch 2 fixes the rate limiting parameters for wireless mode: it uses
the firmware-reported WCP slice count as the symmetric slice count,
sets only the symmetric maximum throughput (with a wireless-specific
value) and computes the symmetric accel engine count from
adf_wcy_fw_config, where the wireless object is loaded on two accel
engine groups. It depends on patch 1.

Patch 3 fixes the number of command queue counters reported by
telemetry on QAT GEN6. The per-slice multipliers are replaced with the
total number of command queues for each slice type, reported only when
the slice type is present, and the queue count constants are corrected.
It is independent of patches 1 and 2.

George Abraham P (3):
  crypto: qat - validate rate limiting only for enabled services
  crypto: qat - fix rate limiting for QAT GEN6 wireless
  crypto: qat - fix telemetry command queue counts

 .../intel/qat/qat_6xxx/adf_6xxx_hw_data.c     | 38 +++++++++++++++----
 .../intel/qat/qat_6xxx/adf_6xxx_hw_data.h     |  1 +
 .../crypto/intel/qat/qat_common/adf_gen6_tl.c | 24 ++++++------
 drivers/crypto/intel/qat/qat_common/adf_rl.c  | 15 +++++---
 drivers/crypto/intel/qat/qat_common/adf_rl.h  |  1 +
 .../intel/qat/qat_common/adf_rl_admin.c       |  1 +
 .../intel/qat/qat_common/adf_telemetry.c      | 14 +++----
 .../intel/qat/qat_common/adf_telemetry.h      |  2 +-
 8 files changed, 63 insertions(+), 33 deletions(-)


base-commit: 19a2e99ff8eb57bd3d5cb5d52f9eb77bf3b1540a
-- 
2.40.1

