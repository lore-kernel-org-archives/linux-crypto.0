Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C3CC2139C8
	for <linux-crypto@vger.kernel.org>; Thu,  5 Jun 2025 11:25:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749122745; cv=none; b=NgGeDTPB9qUkM0UTUrBWjDUTGawA5zghRGNdi6AWPIKKvAjm1/qEl7uNpIalxSmhDFWmGU4PmcGmYCfIRk0xK+/muZyaOBUwmOKnNdDjxC6uuflgMl9TI8g6TkwW2YKOYi+j01B/XXso83N3CQElMt47uVQIfj4BNq0sulWPdE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749122745; c=relaxed/simple;
	bh=Fj3ai4jsaGJjSTkFZh9vhbRKfJqQwKm6EMRITUOC/kg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=S+iLfkKxOXaOlkXQeeiisMsch4R2tHux2zNz+lFfyTbzaEnfyhzFfjJARvhyJLV2TinWgsQvIxT+Qs38l+rH6N5hQkE2AWcnPE/TgyrLsoGXNyvHOUDF+Rh/UcBMl0MpYT3egLU4BomUBRpWYAJJlv8tHRbtFEJCsol42GtAPY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=C4HHE4vy; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="C4HHE4vy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749122745; x=1780658745;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Fj3ai4jsaGJjSTkFZh9vhbRKfJqQwKm6EMRITUOC/kg=;
  b=C4HHE4vytoxOIp0c34RHze9DBeUIups0AgQzCoXUXELUUeg4+ZpvfGzZ
   cmXuN4gTHHomQYQA+qCpEHG4LnuqDBBat2uutVNKXrH6GiqZ9WaMsUepF
   9mnmEK4jzet1i1fnw0X+NuQG3vGjbt8ZG3EspzE0cmrmwUSkRzTMk1UwZ
   ykBHgqG2+Gk9F/dpiAxItTa88uvVq0EY2SnN3L3j4h4A6FdjY9jBKb6ul
   efGuuul2q1HyJLJ4IjS6yn9374EHt/85VMvzyTietg+E8pdKmO47VKVeM
   ugybzxuV43Z1DdozkvJWHGZAUQ43PZmViusjCqqtVyuRzjnXYQoBv/fWs
   w==;
X-CSE-ConnectionGUID: FfLFDnWQREa4pi2RcebX+w==
X-CSE-MsgGUID: cqkuf9W2RXKmixfele+dvg==
X-IronPort-AV: E=McAfee;i="6800,10657,11454"; a="51305201"
X-IronPort-AV: E=Sophos;i="6.16,211,1744095600"; 
   d="scan'208";a="51305201"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2025 04:25:44 -0700
X-CSE-ConnectionGUID: yuArTrXRTq2aWLDNPQ9XtQ==
X-CSE-MsgGUID: OHmSixHFQaWnIaPoRzsB7w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,211,1744095600"; 
   d="scan'208";a="145988347"
Received: from t21-qat.iind.intel.com ([10.49.15.35])
  by fmviesa010.fm.intel.com with ESMTP; 05 Jun 2025 04:25:42 -0700
From: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com
Subject: [PATCH 2/2] Documentation: qat: update sysfs-driver-qat for GEN6 devices
Date: Thu,  5 Jun 2025 12:25:27 +0100
Message-Id: <20250605112527.1185116-3-suman.kumar.chakraborty@intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20250605112527.1185116-1-suman.kumar.chakraborty@intel.com>
References: <20250605112527.1185116-1-suman.kumar.chakraborty@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Reorganize and expand documentation for service configurations. This
reworks the `cfg_services` section by removing explicit service
combinations (e.g., asym;sym, sym;asym) and clarifying that multiple
services can be configured in any order.

Update the documentation to reflect that the attribute previously limited
to qat_4xxx devices is also applicable to qat_6xxx devices.

Signed-off-by: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Fiona Trahe <fiona.trahe@intel.com>
---
 Documentation/ABI/testing/sysfs-driver-qat | 50 ++++++++++++----------
 1 file changed, 27 insertions(+), 23 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-driver-qat b/Documentation/ABI/testing/sysfs-driver-qat
index f290e77cd590..b0561b9fc4eb 100644
--- a/Documentation/ABI/testing/sysfs-driver-qat
+++ b/Documentation/ABI/testing/sysfs-driver-qat
@@ -14,7 +14,7 @@ Description:	(RW) Reports the current state of the QAT device. Write to
 		It is possible to transition the device from up to down only
 		if the device is up and vice versa.
 
-		This attribute is only available for qat_4xxx devices.
+		This attribute is available for qat_4xxx and qat_6xxx devices.
 
 What:		/sys/bus/pci/devices/<BDF>/qat/cfg_services
 Date:		June 2022
@@ -23,24 +23,28 @@ Contact:	qat-linux@intel.com
 Description:	(RW) Reports the current configuration of the QAT device.
 		Write to the file to change the configured services.
 
-		The values are:
+		One or more services can be enabled per device.
+		Certain configurations are restricted to specific device types;
+		where applicable this is explicitly indicated, for example
+		(qat_6xxx) denotes applicability exclusively to that device series.
 
-		* sym;asym: the device is configured for running crypto
-		  services
-		* asym;sym: identical to sym;asym
-		* dc: the device is configured for running compression services
-		* dcc: identical to dc but enables the dc chaining feature,
-		  hash then compression. If this is not required chose dc
-		* sym: the device is configured for running symmetric crypto
-		  services
-		* asym: the device is configured for running asymmetric crypto
-		  services
-		* asym;dc: the device is configured for running asymmetric
-		  crypto services and compression services
-		* dc;asym: identical to asym;dc
-		* sym;dc: the device is configured for running symmetric crypto
-		  services and compression services
-		* dc;sym: identical to sym;dc
+		The available services include:
+
+		* sym: Configures the device for symmetric cryptographic operations.
+		* asym: Configures the device for asymmetric cryptographic operations.
+		* dc: Configures the device for compression and decompression
+		  operations.
+		* dcc: Similar to dc, but with the additional dc chaining feature
+		  enabled, cipher then compress (qat_6xxx), hash then compression.
+		  If this is not required choose dc.
+		* decomp: Configures the device for decompression operations (qat_6xxx).
+
+		Service combinations are permitted for all services except dcc.
+		On QAT GEN4 devices (qat_4xxx driver) a maximum of two services can be
+		combined and on QAT GEN6 devices (qat_6xxx driver ) a maximum of three
+		services can be combined.
+		The order of services is not significant. For instance, sym;asym is
+		functionally equivalent to asym;sym.
 
 		It is possible to set the configuration only if the device
 		is in the `down` state (see /sys/bus/pci/devices/<BDF>/qat/state)
@@ -59,7 +63,7 @@ Description:	(RW) Reports the current configuration of the QAT device.
 			# cat /sys/bus/pci/devices/<BDF>/qat/cfg_services
 			dc
 
-		This attribute is only available for qat_4xxx devices.
+		This attribute is available for qat_4xxx and qat_6xxx devices.
 
 What:		/sys/bus/pci/devices/<BDF>/qat/pm_idle_enabled
 Date:		June 2023
@@ -94,7 +98,7 @@ Description:	(RW) This configuration option provides a way to force the device i
 			# cat /sys/bus/pci/devices/<BDF>/qat/pm_idle_enabled
 			0
 
-		This attribute is only available for qat_4xxx devices.
+		This attribute is available for qat_4xxx and qat_6xxx devices.
 
 What:		/sys/bus/pci/devices/<BDF>/qat/rp2srv
 Date:		January 2024
@@ -126,7 +130,7 @@ Description:
 			# cat /sys/bus/pci/devices/<BDF>/qat/rp2srv
 			sym
 
-		This attribute is only available for qat_4xxx devices.
+		This attribute is available for qat_4xxx and qat_6xxx devices.
 
 What:		/sys/bus/pci/devices/<BDF>/qat/num_rps
 Date:		January 2024
@@ -140,7 +144,7 @@ Description:
 			# cat /sys/bus/pci/devices/<BDF>/qat/num_rps
 			64
 
-		This attribute is only available for qat_4xxx devices.
+		This attribute is available for qat_4xxx and qat_6xxx devices.
 
 What:		/sys/bus/pci/devices/<BDF>/qat/auto_reset
 Date:		May 2024
@@ -160,4 +164,4 @@ Description:	(RW) Reports the current state of the autoreset feature
 		* 0/Nn/off: auto reset disabled. If the device encounters an
 		  unrecoverable error, it will not be reset.
 
-		This attribute is only available for qat_4xxx devices.
+		This attribute is available for qat_4xxx and qat_6xxx devices.
-- 
2.40.1

