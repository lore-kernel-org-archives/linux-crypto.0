Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79B102877E2
	for <linux-crypto@vger.kernel.org>; Thu, 10 Jul 2025 06:39:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752129600; cv=none; b=nlhjWvzSaS/k0sTZYP15crgvz5OrnyMPjlcpf14xIL1NAfBsSNurVzoU5kD7fx3hU1cBIltaULKADIayUE77X3BzAPxyqniE3cplRDV7NfHtx11/2kv2IhLsNqC3FOv9WTR8PPc3KBs6+rAYbefYmXHZUlMxvrjGNWlv8egSeEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752129600; c=relaxed/simple;
	bh=0sR3XDfwwvhNiUcLP91nHHaNV0iIULpBPiGW2C+67rI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=iBY0IfHtT5cWMG5HXH3LOw1VB0lUUM6iLTyzQA6X9SsyezhvOyt+K8jyHzju4SlVoAIWpjCt5yY+LCDGg66j5sh960hTClpgUdxK7iHydCANhZQfBgNFfKun0Mj9vRZ2IqF3XIJxYDGC/p+41+1su3JfSv/ZCDRoOIbbdIpCuZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fepFGA2c; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fepFGA2c"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752129599; x=1783665599;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0sR3XDfwwvhNiUcLP91nHHaNV0iIULpBPiGW2C+67rI=;
  b=fepFGA2cFkZSDSWEO6hU3HDgPdZr/+B2EhZCsRw1CxbgYgZdq30FVVeU
   sOE766i9BfRdjuR/a7hKuv9SYJ+kIFxl9Gh8PjahbWKyPLrvvKJdm3Lbx
   oS6DWfk2miDIboy/OxjdIbfzkWW57bpjoCXwY6Hz+2Ahy+dhzT2xgxDub
   dDCFNPNDQuYyaEm2XwAyiXVKlbz5PUfFk/MBriMyXa58RdEzmCtfrRKHW
   cYcr+FZA19nIQ3s5NpWPv9DzTImbWndKzTpKxx4Ko9IYsHPnv9JLv2+pJ
   W2zPeURCD6z7FkBcqLs88CR2JpvbRaS9yTh/6OHf+6dfLhXoJ8FdLSnZG
   Q==;
X-CSE-ConnectionGUID: 91MvkkrSQwm4+ctV7x4HeQ==
X-CSE-MsgGUID: PyqxcrDTQWeRzgNXM25VBw==
X-IronPort-AV: E=McAfee;i="6800,10657,11489"; a="53512254"
X-IronPort-AV: E=Sophos;i="6.16,300,1744095600"; 
   d="scan'208";a="53512254"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2025 23:39:58 -0700
X-CSE-ConnectionGUID: Ee3yxfuWT8ari/HF30e2Xg==
X-CSE-MsgGUID: Q+6rN1nhS+ef9ymTlYcW0w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,300,1744095600"; 
   d="scan'208";a="155632201"
Received: from t21-qat.iind.intel.com ([10.49.15.35])
  by fmviesa007.fm.intel.com with ESMTP; 09 Jul 2025 23:39:57 -0700
From: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com
Subject: [PATCH 3/3] Documentation: qat: update debugfs-driver-qat_telemetry for GEN6 devices
Date: Thu, 10 Jul 2025 07:39:45 +0100
Message-Id: <20250710063945.516678-4-suman.kumar.chakraborty@intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20250710063945.516678-1-suman.kumar.chakraborty@intel.com>
References: <20250710063945.516678-1-suman.kumar.chakraborty@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Vijay Sundar Selvamani <vijay.sundar.selvamani@intel.com>

Expands telemetry documentation for supporting QAT GEN6 device. Introduces
new parameters to capture compression, decompression slice utilization and
execution count.

Co-developed-by: George Abraham P <george.abraham.p@intel.com>
Signed-off-by: George Abraham P <george.abraham.p@intel.com>
Signed-off-by: Vijay Sundar Selvamani <vijay.sundar.selvamani@intel.com>
Signed-off-by: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 Documentation/ABI/testing/debugfs-driver-qat_telemetry | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/Documentation/ABI/testing/debugfs-driver-qat_telemetry b/Documentation/ABI/testing/debugfs-driver-qat_telemetry
index eacee2072088..0dfd8d97e169 100644
--- a/Documentation/ABI/testing/debugfs-driver-qat_telemetry
+++ b/Documentation/ABI/testing/debugfs-driver-qat_telemetry
@@ -32,7 +32,7 @@ Description:	(RW) Enables/disables the reporting of telemetry metrics.
 
 		  echo 0 > /sys/kernel/debug/qat_4xxx_0000:6b:00.0/telemetry/control
 
-		This attribute is only available for qat_4xxx devices.
+		This attribute is only available for qat_4xxx and qat_6xxx devices.
 
 What:		/sys/kernel/debug/qat_<device>_<BDF>/telemetry/device_data
 Date:		March 2024
@@ -67,6 +67,10 @@ Description:	(RO) Reports device telemetry counters.
 		exec_xlt<N>		execution count of Translator slice N
 		util_dcpr<N>		utilization of Decompression slice N [%]
 		exec_dcpr<N>		execution count of Decompression slice N
+		util_cnv<N>		utilization of Compression and verify slice N [%]
+		exec_cnv<N>		execution count of Compression and verify slice N
+		util_dcprz<N>		utilization of Decompression slice N [%]
+		exec_dcprz<N>		execution count of Decompression slice N
 		util_pke<N>		utilization of PKE N [%]
 		exec_pke<N>		execution count of PKE N
 		util_ucs<N>		utilization of UCS slice N [%]
@@ -100,7 +104,7 @@ Description:	(RO) Reports device telemetry counters.
 		If a device lacks of a specific accelerator, the corresponding
 		attribute is not reported.
 
-		This attribute is only available for qat_4xxx devices.
+		This attribute is only available for qat_4xxx and qat_6xxx devices.
 
 What:		/sys/kernel/debug/qat_<device>_<BDF>/telemetry/rp_<A/B/C/D>_data
 Date:		March 2024
@@ -225,4 +229,4 @@ Description:	(RW) Selects up to 4 Ring Pairs (RP) to monitor, one per file,
 		``rp2srv`` from sysfs.
 		See Documentation/ABI/testing/sysfs-driver-qat for details.
 
-		This attribute is only available for qat_4xxx devices.
+		This attribute is only available for qat_4xxx and qat_6xxx devices.
-- 
2.40.1

