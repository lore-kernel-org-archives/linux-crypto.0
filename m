Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.14
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793370624;
	b=ehLETyNbm7vVtk2/JPKnc8Ngy07UgCzN0MJTEKo57ZUp+2emfeBlXLWSNIQBLGtOc6+u
	 9sQdH5yIIKlXibAYbUCWlX+/gp0iLbj5ax6OClT9Uxl5FrRAAHZLQG+e1F0xstoE5S27F
	 mS5m6OBOd2RYxI4alDgUaFQOe7CgbGWrGH+6XpyDTN9mrjmMabEuqR7k1cN0yCejg1Ryu
	 lCjYS8ds6M2KJZCGJHOesQ955zEnddobOyF75m/KUngrsVNtnnW4wRdGw4wYvZOIo6mVT
	 ZQ9UQhXVwdZiNHNpcmgS0ZcoepcUXqcwsjBvwDwcRbiFn3hR5fx8joFvVYhcNkkk4dw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793370624;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Organization:
	 Content-Transfer-Encoding;
	bh=KY7jQH29U7lTett9e6GfD7Ae8wdB/XJihc3TwONZVtI=;
	b=vkEUFCjoIEpNayBRJVFPl6jwwvz7dK+PXLizMTvknZfJD49IivsET+2mLv4bKhxat6aM
	 hCAvgbOqlD9cV9fhcUbSz0hjhzJyjDhTFvNwV+ipe87UsS7wzCFIQJhO2UdYnO716Plqp
	 QoZfX+PAGqH56Q/R2ZA5sO4xD/F98pyMQV+vjduG3XmolQqRGRPAI2swHGCxAhDDYaKvQ
	 H1zxdEQU3ro4V4wfaYZuSU4g0WinzFuEHhxe4t6d1O1wElT5bHDxxzpUpciwwpEudr+Za
	 wG8c7wA5y0T5xNMQlZXLgIxgulY5p6NyqsfSFW8vj9SHZ5QPXE5tNx42anjFbWWi6Ow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=VBOX0sdV;
	arc=none smtp.remote-ip=192.198.163.14
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61DA1606A31A
	for <linux-crypto@vger.kernel.org>; Fri, 30 Oct 2026 14:30:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 61DA1606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=VBOX0sdV
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793370623; x=1824906623;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=GXk9BmNrCliHWqsUnjbk0aaz8HQuK3uL3yCywXxu4EA=;
  b=VBOX0sdVOOzE+unrmm5dH6QMgSWVRRM4QYHPCD01tPRodlJRYpammpwK
   0odFpT33yTRN9jG3bVhigRT212Ud0vUHLHCIa3iOIYO9pBgMwZItbjbgF
   ZD6J38XfWpK6zXeTn/i52o8j326lDq03r5oQi5zfr4e+a9luDkGOpZW7Q
   V/x1a1LMEBZHGrTG3OMZC56ch01Z2N2aHwEiCMw9/68PsqBWQWFODFINO
   InepZo+ByzAM+gYXdwu2BgSKIBs1HaLh/Igu0bopMC6AwAd0Nwuopwzt6
   Vr7eKQuBbTW+Fe2jGRm/ygpJBPQf0GyKSGFmaMdZoKWSLehimRVTUXfYy
   w==;
X-CSE-ConnectionGUID: iT1W6U05TaSO860AkFYHMw==
X-CSE-MsgGUID: qD5sRweUQQy9ue8nITqgVA==
X-IronPort-AV: E=McAfee;i="6800,10657,11951"; a="2167040"
X-IronPort-AV: E=Sophos;i="6.27,186,1787036400"; 
   d="scan'208";a="2167040"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2026 07:30:23 -0700
X-CSE-ConnectionGUID: K4VlcxDJThGBS5jExDkB6g==
X-CSE-MsgGUID: a2iK6RpMTOKSGvx16TqYgA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,186,1787036400"; 
   d="scan'208";a="5417499"
Received: from silpixa00401812.ir.intel.com ([10.20.226.90])
  by orviesa001.jf.intel.com with ESMTP; 30 Oct 2026 07:30:22 -0700
From: Ahsan Atta <ahsan.atta@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	Ahsan Atta <ahsan.atta@intel.com>
Subject: [PATCH v2 0/2] crypto: qat - enable three-service mode for QAT GEN5
Date: Fri, 30 Oct 2026 14:30:17 +0000
Message-ID: <20261030143019.484280-1-ahsan.atta@intel.com>
X-Mailer: git-send-email 2.50.1
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
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
Patch #1: Define the firmware object layout, ring-to-service mapping
and thread-to-arbiter mapping required for the sym;asym;dc
configuration on GEN5, and register the new service combination in
adf_cfg_services so that it can be selected through the cfg_services
sysfs attribute.

Patch #2: Update the cfg_services ABI documentation to state that GEN5
devices (qat_420xx) support a maximum of three combined services,
alongside the existing GEN6 entry. Documentation only, no functional
change.

There is an existing issue opened by Sashiko regarding the AE count when
different services are configured on the device. That shall be addressed in
later commits if applicable.

Changes in v2:
- Dropped the per-service AE accounting for rate limiting in
  three-service mode; it now uses the same AE count as the other
  GEN4/GEN5 configurations. This also resolves the stale-count issue
  reported by Sashiko.
- Renamed ADF_GEN4_SYM_ASYM_DC_RING_TO_SRV_MAP to
  ADF_420XX_SYM_ASYM_DC_RING_TO_SRV_MAP.

Bairavi Alagappan (2):
  crypto: qat - enable three-service mode for QAT GEN5 devices
  Documentation: qat: document three-service mode for QAT GEN5 devices

 Documentation/ABI/testing/sysfs-driver-qat    |  4 +-
 .../intel/qat/qat_420xx/adf_420xx_hw_data.c   | 59 ++++++++++++++++++-
 .../intel/qat/qat_420xx/adf_420xx_hw_data.h   |  6 ++
 .../intel/qat/qat_common/adf_cfg_services.c   |  3 +
 .../intel/qat/qat_common/adf_cfg_services.h   |  1 +
 5 files changed, 69 insertions(+), 4 deletions(-)


base-commit: 9c5d66e1ea78912b8a43ce16a1c14db1357e0ae0
-- 
2.50.1

