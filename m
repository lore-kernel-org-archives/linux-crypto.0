Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CB7725CC74
	for <linux-crypto@vger.kernel.org>; Thu, 10 Jul 2025 13:33:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752154439; cv=none; b=cgCOjntzskFGP0Yxv7pBCZ6P36eL9LcFvkYUbA1t/OIK6WfLPu5blQRLxD1HfqN0BoBgLRT4Y6zI/8hMQG6sB73l4u7ScpXlxm1WXWSy5Vh8k+sT8BhSQAVEsf/tJKq0ZoWjz9mf3pC5XQHcBoEn8wN0L2C4+7JzfHZCr5OtL+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752154439; c=relaxed/simple;
	bh=ARcAyTrEBT3Hdm4oSWxa/m5vNPOi4Uqab3yu2EF3mi4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=bn+g7Y8wWX+W3KBOYVpaWV3758xqodnnA2RfNd1rUL2ZZ8342d+0u2S54QjoH9GyIfcXnkDMmdNJN8T0QTFH5LnrvvLI4OxKrtdDfr1SpVMBXa/z12OLYFz1oricil+UBmDYc9S2Es39qU3cQ/kdSHeTxhD5QmAD+pzEYxP2O+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MjLPqvpg; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MjLPqvpg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752154437; x=1783690437;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ARcAyTrEBT3Hdm4oSWxa/m5vNPOi4Uqab3yu2EF3mi4=;
  b=MjLPqvpgNmV36PUEdmOOXfHSurcC9C7PHkrmK8h6LB08YLDBh6MzSH7m
   4E2R/Vkz6N35suQb/Us5Fi22oKhwQimIaLDFfdHGbJxJV2mNnWELSOGiD
   SM7/yoL7v3nqlM+iIYyyFEHSPBFZ8x43TcBFPcr7Y1ZLikZn6kJ4D8w7B
   YkQJsZ3sz9rhOul4oiK9kpLtP6cRYEryhDvUd/+JdreIc9X9+aQKOt2rJ
   upJDd1Dt5WXo7lJbfBb11u58NDVMmvl8iFGk9Qc/WAVgkkIGs4zi5c/ym
   Loui8YiaXz1cEcfZaxS3muqix3FrEfYMzrO514yd1J8D4J7M3+tIjjuPo
   w==;
X-CSE-ConnectionGUID: AUcbP0ptRcWzMV6reG+AXQ==
X-CSE-MsgGUID: 1VaUcs4hRaGZ6G1icO9PCA==
X-IronPort-AV: E=McAfee;i="6800,10657,11490"; a="58241837"
X-IronPort-AV: E=Sophos;i="6.16,300,1744095600"; 
   d="scan'208";a="58241837"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2025 06:33:57 -0700
X-CSE-ConnectionGUID: W9P3rKBgRCGIyUQ2tK39mg==
X-CSE-MsgGUID: F/2b9FKjQqmqnuZww8EKdw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,300,1744095600"; 
   d="scan'208";a="155494649"
Received: from t21-qat.iind.intel.com ([10.49.15.35])
  by orviesa006.jf.intel.com with ESMTP; 10 Jul 2025 06:33:56 -0700
From: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com
Subject: [PATCH 3/8] crypto: qat - consolidate service enums
Date: Thu, 10 Jul 2025 14:33:42 +0100
Message-Id: <20250710133347.566310-4-suman.kumar.chakraborty@intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20250710133347.566310-1-suman.kumar.chakraborty@intel.com>
References: <20250710133347.566310-1-suman.kumar.chakraborty@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The enums `adf_base_services` (used in rate limiting) and `adf_services`
define the same values, resulting in code duplication.

To improve consistency across the QAT driver: (1) rename `adf_services`
to `adf_base_services` in adf_cfg_services.c to better reflect its role
in defining core services (those with dedicated accelerators),
(2) introduce a new `adf_extended_services` enum starting from
`SVC_BASE_COUNT`, and move `SVC_DCC` into it, as it represents an
extended service (DC with chaining), and (3) remove the redundant
`adf_base_services` enum from the rate limiting implementation.

This does not introduce any functional change.

Signed-off-by: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 .../intel/qat/qat_420xx/adf_420xx_hw_data.c   |  6 ++--
 .../intel/qat/qat_4xxx/adf_4xxx_hw_data.c     |  6 ++--
 .../intel/qat/qat_6xxx/adf_6xxx_hw_data.c     |  6 ++--
 .../intel/qat/qat_common/adf_cfg_services.c   |  8 ++---
 .../intel/qat/qat_common/adf_cfg_services.h   | 10 ++++--
 .../intel/qat/qat_common/adf_gen4_hw_data.c   |  2 +-
 drivers/crypto/intel/qat/qat_common/adf_rl.c  | 35 +++++++++----------
 drivers/crypto/intel/qat/qat_common/adf_rl.h  | 10 ++----
 .../intel/qat/qat_common/adf_sysfs_rl.c       | 14 ++++----
 9 files changed, 47 insertions(+), 50 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c b/drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c
index 8340b5e8a947..32bb9e1826d2 100644
--- a/drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c
@@ -296,9 +296,9 @@ static void adf_init_rl_data(struct adf_rl_hw_data *rl_data)
 	rl_data->pcie_scale_div = ADF_420XX_RL_PCIE_SCALE_FACTOR_DIV;
 	rl_data->pcie_scale_mul = ADF_420XX_RL_PCIE_SCALE_FACTOR_MUL;
 	rl_data->dcpr_correction = ADF_420XX_RL_DCPR_CORRECTION;
-	rl_data->max_tp[ADF_SVC_ASYM] = ADF_420XX_RL_MAX_TP_ASYM;
-	rl_data->max_tp[ADF_SVC_SYM] = ADF_420XX_RL_MAX_TP_SYM;
-	rl_data->max_tp[ADF_SVC_DC] = ADF_420XX_RL_MAX_TP_DC;
+	rl_data->max_tp[SVC_ASYM] = ADF_420XX_RL_MAX_TP_ASYM;
+	rl_data->max_tp[SVC_SYM] = ADF_420XX_RL_MAX_TP_SYM;
+	rl_data->max_tp[SVC_DC] = ADF_420XX_RL_MAX_TP_DC;
 	rl_data->scan_interval = ADF_420XX_RL_SCANS_PER_SEC;
 	rl_data->scale_ref = ADF_420XX_RL_SLICE_REF;
 }
diff --git a/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c b/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
index 4d4889533558..f917cc9db09d 100644
--- a/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
@@ -222,9 +222,9 @@ static void adf_init_rl_data(struct adf_rl_hw_data *rl_data)
 	rl_data->pcie_scale_div = ADF_4XXX_RL_PCIE_SCALE_FACTOR_DIV;
 	rl_data->pcie_scale_mul = ADF_4XXX_RL_PCIE_SCALE_FACTOR_MUL;
 	rl_data->dcpr_correction = ADF_4XXX_RL_DCPR_CORRECTION;
-	rl_data->max_tp[ADF_SVC_ASYM] = ADF_4XXX_RL_MAX_TP_ASYM;
-	rl_data->max_tp[ADF_SVC_SYM] = ADF_4XXX_RL_MAX_TP_SYM;
-	rl_data->max_tp[ADF_SVC_DC] = ADF_4XXX_RL_MAX_TP_DC;
+	rl_data->max_tp[SVC_ASYM] = ADF_4XXX_RL_MAX_TP_ASYM;
+	rl_data->max_tp[SVC_SYM] = ADF_4XXX_RL_MAX_TP_SYM;
+	rl_data->max_tp[SVC_DC] = ADF_4XXX_RL_MAX_TP_DC;
 	rl_data->scan_interval = ADF_4XXX_RL_SCANS_PER_SEC;
 	rl_data->scale_ref = ADF_4XXX_RL_SLICE_REF;
 }
diff --git a/drivers/crypto/intel/qat/qat_6xxx/adf_6xxx_hw_data.c b/drivers/crypto/intel/qat/qat_6xxx/adf_6xxx_hw_data.c
index d3f1034f33fb..28b7a7649bb6 100644
--- a/drivers/crypto/intel/qat/qat_6xxx/adf_6xxx_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_6xxx/adf_6xxx_hw_data.c
@@ -103,7 +103,7 @@ static bool services_supported(unsigned long mask)
 {
 	int num_svc;
 
-	if (mask >= BIT(SVC_BASE_COUNT))
+	if (mask >= BIT(SVC_COUNT))
 		return false;
 
 	num_svc = hweight_long(mask);
@@ -138,7 +138,7 @@ static int get_service(unsigned long *mask)
 	return -EINVAL;
 }
 
-static enum adf_cfg_service_type get_ring_type(enum adf_services service)
+static enum adf_cfg_service_type get_ring_type(unsigned int service)
 {
 	switch (service) {
 	case SVC_SYM:
@@ -155,7 +155,7 @@ static enum adf_cfg_service_type get_ring_type(enum adf_services service)
 	}
 }
 
-static const unsigned long *get_thrd_mask(enum adf_services service)
+static const unsigned long *get_thrd_mask(unsigned int service)
 {
 	switch (service) {
 	case SVC_SYM:
diff --git a/drivers/crypto/intel/qat/qat_common/adf_cfg_services.c b/drivers/crypto/intel/qat/qat_common/adf_cfg_services.c
index f49227b10064..ab3cbce32dc4 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_cfg_services.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_cfg_services.c
@@ -20,9 +20,9 @@ static const char *const adf_cfg_services[] = {
 
 /*
  * Ensure that the size of the array matches the number of services,
- * SVC_BASE_COUNT, that is used to size the bitmap.
+ * SVC_COUNT, that is used to size the bitmap.
  */
-static_assert(ARRAY_SIZE(adf_cfg_services) == SVC_BASE_COUNT);
+static_assert(ARRAY_SIZE(adf_cfg_services) == SVC_COUNT);
 
 /*
  * Ensure that the maximum number of concurrent services that can be
@@ -35,7 +35,7 @@ static_assert(ARRAY_SIZE(adf_cfg_services) >= MAX_NUM_CONCURR_SVC);
  * Ensure that the number of services fit a single unsigned long, as each
  * service is represented by a bit in the mask.
  */
-static_assert(BITS_PER_LONG >= SVC_BASE_COUNT);
+static_assert(BITS_PER_LONG >= SVC_COUNT);
 
 /*
  * Ensure that size of the concatenation of all service strings is smaller
@@ -90,7 +90,7 @@ static int adf_service_mask_to_string(unsigned long mask, char *buf, size_t len)
 	if (len < ADF_CFG_MAX_VAL_LEN_IN_BYTES)
 		return -ENOSPC;
 
-	for_each_set_bit(bit, &mask, SVC_BASE_COUNT) {
+	for_each_set_bit(bit, &mask, SVC_COUNT) {
 		if (offset)
 			offset += scnprintf(buf + offset, len - offset,
 					    ADF_SERVICES_DELIMITER);
diff --git a/drivers/crypto/intel/qat/qat_common/adf_cfg_services.h b/drivers/crypto/intel/qat/qat_common/adf_cfg_services.h
index 8709b7a52907..b2dd62eabf26 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_cfg_services.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_cfg_services.h
@@ -7,17 +7,21 @@
 
 struct adf_accel_dev;
 
-enum adf_services {
+enum adf_base_services {
 	SVC_ASYM = 0,
 	SVC_SYM,
 	SVC_DC,
 	SVC_DECOMP,
-	SVC_DCC,
 	SVC_BASE_COUNT
 };
 
+enum adf_extended_services {
+	SVC_DCC = SVC_BASE_COUNT,
+	SVC_COUNT
+};
+
 enum adf_composed_services {
-	SVC_SYM_ASYM = SVC_BASE_COUNT,
+	SVC_SYM_ASYM = SVC_COUNT,
 	SVC_SYM_DC,
 	SVC_ASYM_DC,
 };
diff --git a/drivers/crypto/intel/qat/qat_common/adf_gen4_hw_data.c b/drivers/crypto/intel/qat/qat_common/adf_gen4_hw_data.c
index 0dbf9cc2a858..3103755e416e 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_gen4_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_gen4_hw_data.c
@@ -262,7 +262,7 @@ bool adf_gen4_services_supported(unsigned long mask)
 {
 	unsigned long num_svc = hweight_long(mask);
 
-	if (mask >= BIT(SVC_BASE_COUNT))
+	if (mask >= BIT(SVC_COUNT))
 		return false;
 
 	if (test_bit(SVC_DECOMP, &mask))
diff --git a/drivers/crypto/intel/qat/qat_common/adf_rl.c b/drivers/crypto/intel/qat/qat_common/adf_rl.c
index 03c394d8c066..0d5f59bfa6a2 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_rl.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_rl.c
@@ -13,6 +13,7 @@
 #include <linux/units.h>
 
 #include "adf_accel_devices.h"
+#include "adf_cfg_services.h"
 #include "adf_common_drv.h"
 #include "adf_rl_admin.h"
 #include "adf_rl.h"
@@ -55,7 +56,7 @@ static int validate_user_input(struct adf_accel_dev *accel_dev,
 			}
 		}
 
-		if (sla_in->srv >= ADF_SVC_NONE) {
+		if (sla_in->srv >= SVC_BASE_COUNT) {
 			dev_notice(&GET_DEV(accel_dev),
 				   "Wrong service type\n");
 			return -EINVAL;
@@ -171,13 +172,13 @@ static struct rl_sla *find_parent(struct adf_rl *rl_data,
 static enum adf_cfg_service_type srv_to_cfg_svc_type(enum adf_base_services rl_srv)
 {
 	switch (rl_srv) {
-	case ADF_SVC_ASYM:
+	case SVC_ASYM:
 		return ASYM;
-	case ADF_SVC_SYM:
+	case SVC_SYM:
 		return SYM;
-	case ADF_SVC_DC:
+	case SVC_DC:
 		return COMP;
-	case ADF_SVC_DECOMP:
+	case SVC_DECOMP:
 		return DECOMP;
 	default:
 		return UNUSED;
@@ -562,13 +563,13 @@ u32 adf_rl_calculate_slice_tokens(struct adf_accel_dev *accel_dev, u32 sla_val,
 	avail_slice_cycles = hw_data->clock_frequency;
 
 	switch (svc_type) {
-	case ADF_SVC_ASYM:
+	case SVC_ASYM:
 		avail_slice_cycles *= device_data->slices.pke_cnt;
 		break;
-	case ADF_SVC_SYM:
+	case SVC_SYM:
 		avail_slice_cycles *= device_data->slices.cph_cnt;
 		break;
-	case ADF_SVC_DC:
+	case SVC_DC:
 		avail_slice_cycles *= device_data->slices.dcpr_cnt;
 		break;
 	default:
@@ -618,9 +619,8 @@ u32 adf_rl_calculate_pci_bw(struct adf_accel_dev *accel_dev, u32 sla_val,
 	sla_to_bytes *= device_data->max_tp[svc_type];
 	do_div(sla_to_bytes, device_data->scale_ref);
 
-	sla_to_bytes *= (svc_type == ADF_SVC_ASYM) ? RL_TOKEN_ASYM_SIZE :
-						     BYTES_PER_MBIT;
-	if (svc_type == ADF_SVC_DC && is_bw_out)
+	sla_to_bytes *= (svc_type == SVC_ASYM) ? RL_TOKEN_ASYM_SIZE : BYTES_PER_MBIT;
+	if (svc_type == SVC_DC && is_bw_out)
 		sla_to_bytes *= device_data->slices.dcpr_cnt -
 				device_data->dcpr_correction;
 
@@ -731,7 +731,7 @@ static int initialize_default_nodes(struct adf_accel_dev *accel_dev)
 	sla_in.type = RL_ROOT;
 	sla_in.parent_id = RL_PARENT_DEFAULT_ID;
 
-	for (i = 0; i < ADF_SVC_NONE; i++) {
+	for (i = 0; i < SVC_BASE_COUNT; i++) {
 		if (!is_service_enabled(accel_dev, i))
 			continue;
 
@@ -746,10 +746,9 @@ static int initialize_default_nodes(struct adf_accel_dev *accel_dev)
 
 	/* Init default cluster for each root */
 	sla_in.type = RL_CLUSTER;
-	for (i = 0; i < ADF_SVC_NONE; i++) {
+	for (i = 0; i < SVC_BASE_COUNT; i++) {
 		if (!rl_data->root[i])
 			continue;
-
 		sla_in.cir = rl_data->root[i]->cir;
 		sla_in.pir = sla_in.cir;
 		sla_in.srv = rl_data->root[i]->srv;
@@ -988,7 +987,7 @@ int adf_rl_get_capability_remaining(struct adf_accel_dev *accel_dev,
 	struct rl_sla *sla = NULL;
 	int i;
 
-	if (srv >= ADF_SVC_NONE)
+	if (srv >= SVC_BASE_COUNT)
 		return -EINVAL;
 
 	if (sla_id > RL_SLA_EMPTY_ID && !validate_sla_id(accel_dev, sla_id)) {
@@ -1087,9 +1086,9 @@ int adf_rl_init(struct adf_accel_dev *accel_dev)
 	int ret = 0;
 
 	/* Validate device parameters */
-	if (RL_VALIDATE_NON_ZERO(rl_hw_data->max_tp[ADF_SVC_ASYM]) ||
-	    RL_VALIDATE_NON_ZERO(rl_hw_data->max_tp[ADF_SVC_SYM]) ||
-	    RL_VALIDATE_NON_ZERO(rl_hw_data->max_tp[ADF_SVC_DC]) ||
+	if (RL_VALIDATE_NON_ZERO(rl_hw_data->max_tp[SVC_ASYM]) ||
+	    RL_VALIDATE_NON_ZERO(rl_hw_data->max_tp[SVC_SYM]) ||
+	    RL_VALIDATE_NON_ZERO(rl_hw_data->max_tp[SVC_DC]) ||
 	    RL_VALIDATE_NON_ZERO(rl_hw_data->scan_interval) ||
 	    RL_VALIDATE_NON_ZERO(rl_hw_data->pcie_scale_div) ||
 	    RL_VALIDATE_NON_ZERO(rl_hw_data->pcie_scale_mul) ||
diff --git a/drivers/crypto/intel/qat/qat_common/adf_rl.h b/drivers/crypto/intel/qat/qat_common/adf_rl.h
index 62cc47d1218a..f2393bdb8ccc 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_rl.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_rl.h
@@ -7,6 +7,8 @@
 #include <linux/mutex.h>
 #include <linux/types.h>
 
+#include "adf_cfg_services.h"
+
 struct adf_accel_dev;
 
 #define RL_ROOT_MAX		4
@@ -24,14 +26,6 @@ enum rl_node_type {
 	RL_LEAF,
 };
 
-enum adf_base_services {
-	ADF_SVC_ASYM = 0,
-	ADF_SVC_SYM,
-	ADF_SVC_DC,
-	ADF_SVC_DECOMP,
-	ADF_SVC_NONE,
-};
-
 /**
  * struct adf_rl_sla_input_data - ratelimiting user input data structure
  * @rp_mask: 64 bit bitmask of ring pair IDs which will be assigned to SLA.
diff --git a/drivers/crypto/intel/qat/qat_common/adf_sysfs_rl.c b/drivers/crypto/intel/qat/qat_common/adf_sysfs_rl.c
index 43df32df0dc5..9d439df6d9ad 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_sysfs_rl.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_sysfs_rl.c
@@ -32,10 +32,10 @@ enum rl_params {
 };
 
 static const char *const rl_services[] = {
-	[ADF_SVC_ASYM] = "asym",
-	[ADF_SVC_SYM] = "sym",
-	[ADF_SVC_DC] = "dc",
-	[ADF_SVC_DECOMP] = "decomp",
+	[SVC_ASYM] = "asym",
+	[SVC_SYM] = "sym",
+	[SVC_DC] = "dc",
+	[SVC_DECOMP] = "decomp",
 };
 
 static const char *const rl_operations[] = {
@@ -283,7 +283,7 @@ static ssize_t srv_show(struct device *dev, struct device_attribute *attr,
 	if (ret)
 		return ret;
 
-	if (get == ADF_SVC_NONE)
+	if (get == SVC_BASE_COUNT)
 		return -EINVAL;
 
 	return sysfs_emit(buf, "%s\n", rl_services[get]);
@@ -448,8 +448,8 @@ int adf_sysfs_rl_add(struct adf_accel_dev *accel_dev)
 		dev_err(&GET_DEV(accel_dev),
 			"Failed to create qat_rl attribute group\n");
 
-	data->cap_rem_srv = ADF_SVC_NONE;
-	data->input.srv = ADF_SVC_NONE;
+	data->cap_rem_srv = SVC_BASE_COUNT;
+	data->input.srv = SVC_BASE_COUNT;
 	data->sysfs_added = true;
 
 	return ret;
-- 
2.40.1

