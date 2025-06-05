Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42739213E90
	for <linux-crypto@vger.kernel.org>; Thu,  5 Jun 2025 11:25:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749122745; cv=none; b=aIvUsKXakPKTWPN/6O0Ca7MVYCG7DhK6T2Qe8Exw8bfYkLX6g5SYE8VpwSSaspJCWX11bGMMxasbdIpjPc3q6Ul2TeDiUs77HPXCHEIZtRfPdtZPQpjZIpPGVcppE3rsI8sitsWWR4/XFzI+hFzLrIZ26F06jIWmiT/z3pUgiDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749122745; c=relaxed/simple;
	bh=8CFOU3CMIoNr38mglC61/K49YkUmQ6SaAaQxaouknG4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gMScHoW8ZAFE1E2EHacswP7HpRvt2L0cECW0J7QoEz6X2Yp9Y5GrBTSdJ9CdnhVGfgiNfottMpqyiNIKOmVBKggWVP8Pl90Tr6z1S2KPvUDs9S7pLFqaQJWLiEJyLe08H0hHQQSxUTmxDe6gSsbcaBhRf16/gdSWjb73CdiYB28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HeP6futK; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HeP6futK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749122745; x=1780658745;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8CFOU3CMIoNr38mglC61/K49YkUmQ6SaAaQxaouknG4=;
  b=HeP6futKtZIpSS/BXVbqd6E1fw28vfTk4EF0tolwHldUXumOxrgJViMj
   NzITEEqsOSW3uc5QLGtJtV+2CEDb1JVxA941B/5iHwqoujxKKYQSKHXCf
   2avNVWzKS3xZx+OL3TlyceaqLapkmjdjlKRRjhq6+ai40dw/IQfp15m+y
   oFps8PAYxyL4ZWSjoGnGvXUZEkNxFtalnKALmr19bT6K64oNfTrYpPkdR
   5TF3Kz3vw8Xdk5ccZnQ7dJo6jZNZXIe6mY6mdHDUiiGH7+HH0O38jqImc
   DOuaj/fuPcTltf35cOCM2JTw//fTy5YWf+dRfzfHkvass0AuAAyKuTLSX
   Q==;
X-CSE-ConnectionGUID: EpnYFohISjOJWMmBxGEEAw==
X-CSE-MsgGUID: EymJRDDoQ8KTjMpSZn3Ydw==
X-IronPort-AV: E=McAfee;i="6800,10657,11454"; a="51305197"
X-IronPort-AV: E=Sophos;i="6.16,211,1744095600"; 
   d="scan'208";a="51305197"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2025 04:25:43 -0700
X-CSE-ConnectionGUID: 17fIwWVLRwq0VGHztCXqNg==
X-CSE-MsgGUID: DfBM5ZjRTd6m7zWwhkuKSw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,211,1744095600"; 
   d="scan'208";a="145988340"
Received: from t21-qat.iind.intel.com ([10.49.15.35])
  by fmviesa010.fm.intel.com with ESMTP; 05 Jun 2025 04:25:41 -0700
From: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com
Subject: [PATCH 1/2] crypto: qat - add support for decompression service to GEN6 devices
Date: Thu,  5 Jun 2025 12:25:26 +0100
Message-Id: <20250605112527.1185116-2-suman.kumar.chakraborty@intel.com>
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

Add support to configure decompression as a separate service for QAT GEN6
devices. A new arbiter configuration has been added to map the hardware
decompression threads to all ring pairs.

The decompression service is enabled via sysfs by writing "decomp" to
"/sys/bus/pci/devices/<BDF>/qat/cfg_services".

The decompression service is not supported on QAT GEN2 and GEN4 devices,
and attempting it results in an invalid write error. The existing
compression service for QAT GEN2 and GEN4 devices remains unchanged and
supports both compression and decompression operations on the same ring
pair.

Co-developed-by: Karthikeyan Gopal <karthikeyan.gopal@intel.com>
Signed-off-by: Karthikeyan Gopal <karthikeyan.gopal@intel.com>
Signed-off-by: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 .../crypto/intel/qat/qat_6xxx/adf_6xxx_hw_data.c    | 13 ++++++++++++-
 .../crypto/intel/qat/qat_common/adf_cfg_common.h    |  1 +
 .../crypto/intel/qat/qat_common/adf_cfg_services.c  |  5 +++++
 .../crypto/intel/qat/qat_common/adf_cfg_services.h  |  1 +
 .../crypto/intel/qat/qat_common/adf_cfg_strings.h   |  1 +
 .../crypto/intel/qat/qat_common/adf_gen4_hw_data.c  |  3 +++
 drivers/crypto/intel/qat/qat_common/adf_sysfs.c     |  2 ++
 7 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/intel/qat/qat_6xxx/adf_6xxx_hw_data.c b/drivers/crypto/intel/qat/qat_6xxx/adf_6xxx_hw_data.c
index 359a6447ccb8..48a29a102dd0 100644
--- a/drivers/crypto/intel/qat/qat_6xxx/adf_6xxx_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_6xxx/adf_6xxx_hw_data.c
@@ -76,6 +76,10 @@ static const unsigned long thrd_mask_dcc[ADF_6XXX_MAX_ACCELENGINES] = {
 	0x00, 0x00, 0x00, 0x00, 0x07, 0x07, 0x03, 0x03, 0x00
 };
 
+static const unsigned long thrd_mask_dcpr[ADF_6XXX_MAX_ACCELENGINES] = {
+	0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x00
+};
+
 static const char *const adf_6xxx_fw_objs[] = {
 	[ADF_FW_CY_OBJ] = ADF_6XXX_CY_OBJ,
 	[ADF_FW_DC_OBJ] = ADF_6XXX_DC_OBJ,
@@ -126,6 +130,9 @@ static int get_service(unsigned long *mask)
 	if (test_and_clear_bit(SVC_DCC, mask))
 		return SVC_DCC;
 
+	if (test_and_clear_bit(SVC_DECOMP, mask))
+		return SVC_DECOMP;
+
 	return -EINVAL;
 }
 
@@ -139,6 +146,8 @@ static enum adf_cfg_service_type get_ring_type(enum adf_services service)
 	case SVC_DC:
 	case SVC_DCC:
 		return COMP;
+	case SVC_DECOMP:
+		return DECOMP;
 	default:
 		return UNUSED;
 	}
@@ -155,6 +164,8 @@ static const unsigned long *get_thrd_mask(enum adf_services service)
 		return thrd_mask_cpr;
 	case SVC_DCC:
 		return thrd_mask_dcc;
+	case SVC_DECOMP:
+		return thrd_mask_dcpr;
 	default:
 		return NULL;
 	}
@@ -648,7 +659,7 @@ static u32 get_accel_cap(struct adf_accel_dev *accel_dev)
 		caps |= capabilities_asym;
 	if (test_bit(SVC_SYM, &mask))
 		caps |= capabilities_sym;
-	if (test_bit(SVC_DC, &mask))
+	if (test_bit(SVC_DC, &mask) || test_bit(SVC_DECOMP, &mask))
 		caps |= capabilities_dc;
 	if (test_bit(SVC_DCC, &mask)) {
 		/*
diff --git a/drivers/crypto/intel/qat/qat_common/adf_cfg_common.h b/drivers/crypto/intel/qat/qat_common/adf_cfg_common.h
index 15fdf9854b81..81e9e9d7eccd 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_cfg_common.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_cfg_common.h
@@ -29,6 +29,7 @@ enum adf_cfg_service_type {
 	COMP,
 	SYM,
 	ASYM,
+	DECOMP,
 	USED
 };
 
diff --git a/drivers/crypto/intel/qat/qat_common/adf_cfg_services.c b/drivers/crypto/intel/qat/qat_common/adf_cfg_services.c
index c39871291da7..f49227b10064 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_cfg_services.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_cfg_services.c
@@ -15,6 +15,7 @@ static const char *const adf_cfg_services[] = {
 	[SVC_SYM] = ADF_CFG_SYM,
 	[SVC_DC] = ADF_CFG_DC,
 	[SVC_DCC] = ADF_CFG_DCC,
+	[SVC_DECOMP] = ADF_CFG_DECOMP,
 };
 
 /*
@@ -43,6 +44,7 @@ static_assert(BITS_PER_LONG >= SVC_BASE_COUNT);
 static_assert(sizeof(ADF_CFG_SYM ADF_SERVICES_DELIMITER
 		     ADF_CFG_ASYM ADF_SERVICES_DELIMITER
 		     ADF_CFG_DC ADF_SERVICES_DELIMITER
+		     ADF_CFG_DECOMP ADF_SERVICES_DELIMITER
 		     ADF_CFG_DCC) < ADF_CFG_MAX_VAL_LEN_IN_BYTES);
 
 static int adf_service_string_to_mask(struct adf_accel_dev *accel_dev, const char *buf,
@@ -167,6 +169,9 @@ int adf_get_service_enabled(struct adf_accel_dev *accel_dev)
 	if (test_bit(SVC_DC, &mask))
 		return SVC_DC;
 
+	if (test_bit(SVC_DECOMP, &mask))
+		return SVC_DECOMP;
+
 	if (test_bit(SVC_DCC, &mask))
 		return SVC_DCC;
 
diff --git a/drivers/crypto/intel/qat/qat_common/adf_cfg_services.h b/drivers/crypto/intel/qat/qat_common/adf_cfg_services.h
index 3742c450878f..8709b7a52907 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_cfg_services.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_cfg_services.h
@@ -11,6 +11,7 @@ enum adf_services {
 	SVC_ASYM = 0,
 	SVC_SYM,
 	SVC_DC,
+	SVC_DECOMP,
 	SVC_DCC,
 	SVC_BASE_COUNT
 };
diff --git a/drivers/crypto/intel/qat/qat_common/adf_cfg_strings.h b/drivers/crypto/intel/qat/qat_common/adf_cfg_strings.h
index b79982c4a856..30107a02ee7f 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_cfg_strings.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_cfg_strings.h
@@ -24,6 +24,7 @@
 #define ADF_CY "Cy"
 #define ADF_DC "Dc"
 #define ADF_CFG_DC "dc"
+#define ADF_CFG_DECOMP "decomp"
 #define ADF_CFG_CY "sym;asym"
 #define ADF_CFG_SYM "sym"
 #define ADF_CFG_ASYM "asym"
diff --git a/drivers/crypto/intel/qat/qat_common/adf_gen4_hw_data.c b/drivers/crypto/intel/qat/qat_common/adf_gen4_hw_data.c
index 14d0fdd66a4b..258adc0b49e0 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_gen4_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_gen4_hw_data.c
@@ -262,6 +262,9 @@ bool adf_gen4_services_supported(unsigned long mask)
 	if (mask >= BIT(SVC_BASE_COUNT))
 		return false;
 
+	if (test_bit(SVC_DECOMP, &mask))
+		return false;
+
 	switch (num_svc) {
 	case ADF_ONE_SERVICE:
 		return true;
diff --git a/drivers/crypto/intel/qat/qat_common/adf_sysfs.c b/drivers/crypto/intel/qat/qat_common/adf_sysfs.c
index 6c39194647f0..79c63dfa8ff3 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_sysfs.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_sysfs.c
@@ -269,6 +269,8 @@ static ssize_t rp2srv_show(struct device *dev, struct device_attribute *attr,
 		return sysfs_emit(buf, "%s\n", ADF_CFG_SYM);
 	case ASYM:
 		return sysfs_emit(buf, "%s\n", ADF_CFG_ASYM);
+	case DECOMP:
+		return sysfs_emit(buf, "%s\n", ADF_CFG_DECOMP);
 	default:
 		break;
 	}
-- 
2.40.1

