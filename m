Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DD2625BEF0
	for <linux-crypto@vger.kernel.org>; Thu, 10 Jul 2025 13:33:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752154441; cv=none; b=OTvqZCA6LI/M0OgFoGbuPtdhwcF3X0RpkJkIQOx7P6J3tS8WZi0v7OEpdxOU5MGOycm9+ASQcaPaUBsZ69n5IQJuwOG3RQxuE8+Ya9o+KXwZ7frJQ+18Eazd6NcaKd9pLMy0dm7P2wcbToVDCxfV3WAB0MZfaygO78YpJcCCe80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752154441; c=relaxed/simple;
	bh=TQUKmNrhg6NtL2EzJMhoZzBlB2Gd+2070aJHcPYNiaE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Xkg3kkMPLNKM5qeDbqhBO/ny0051a4V8FV22wj48BZK5jLBlsnhxiaiZww6YX4BAsSYgLfE3oumqTIZcMhll+FDP2KqPwBTfYXTdv5EXjPrky7wVFDajKmUN2SruKvM+wgNQk0hVWbrvsiR8i7MxlwUsbYGplxoZ92KJ4AaZo1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CfQtMX9p; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CfQtMX9p"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752154439; x=1783690439;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TQUKmNrhg6NtL2EzJMhoZzBlB2Gd+2070aJHcPYNiaE=;
  b=CfQtMX9p+Mdt2NDEjULz5bijBzrZRdPRSA8XXm1Tw5VcW1mulB1XYsfX
   s4wejaRbxZEK1boLKC/4qxTb842sZOhUlsFLLVdEEAa+PWveXM4QMTrrF
   RCX2/8+4E4qw9bzw1KQYvaBiJCxY6jN/9+/6MOgE2i9FGZTFOm9u7b+dP
   74KAh5UpLPMqq1O7UOol3t6V14CA356D+XexI2ofo3zl6t2Ms4xxDIbST
   gNOZLX57I5RxvG6X6kOMYsTlmhIJSnaDQWVqqUrMUgvlQF/eXcQWXqBOs
   ++6fTgtuwgB/NblAEQGfRh5Ak7peOqY5eYkb5ohxvaGyWCmsHn+Lho/sm
   Q==;
X-CSE-ConnectionGUID: Io7HCOvjQK+2kBP6TI5A9Q==
X-CSE-MsgGUID: G6yCt2csThCHvvtbpcEB0A==
X-IronPort-AV: E=McAfee;i="6800,10657,11490"; a="58241840"
X-IronPort-AV: E=Sophos;i="6.16,300,1744095600"; 
   d="scan'208";a="58241840"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2025 06:33:59 -0700
X-CSE-ConnectionGUID: euR96EmxQZmw2vfMk1gPyw==
X-CSE-MsgGUID: MOqnTP6TTfKIxbbAkkstqw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,300,1744095600"; 
   d="scan'208";a="155494653"
Received: from t21-qat.iind.intel.com ([10.49.15.35])
  by orviesa006.jf.intel.com with ESMTP; 10 Jul 2025 06:33:58 -0700
From: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com
Subject: [PATCH 4/8] crypto: qat - relocate service related functions
Date: Thu, 10 Jul 2025 14:33:43 +0100
Message-Id: <20250710133347.566310-5-suman.kumar.chakraborty@intel.com>
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

Rename (1) is_service_enabled() to adf_is_service_enabled(), and
(2) srv_to_cfg_svc_type() to adf_srv_to_cfg_svc_type(), and move them to
adf_cfg_services.c which is the appropriate place for configuration-related
service logic. This improves code organization and modularity by grouping
related service configuration logic in a single location.

Signed-off-by: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 .../intel/qat/qat_common/adf_cfg_services.c   | 32 ++++++++++++++++
 .../intel/qat/qat_common/adf_cfg_services.h   |  2 +
 drivers/crypto/intel/qat/qat_common/adf_rl.c  | 37 ++-----------------
 drivers/crypto/intel/qat/qat_common/adf_rl.h  |  1 -
 .../intel/qat/qat_common/adf_sysfs_rl.c       |  2 +-
 5 files changed, 38 insertions(+), 36 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_cfg_services.c b/drivers/crypto/intel/qat/qat_common/adf_cfg_services.c
index ab3cbce32dc4..7d00bcb41ce7 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_cfg_services.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_cfg_services.c
@@ -7,6 +7,7 @@
 #include <linux/pci.h>
 #include <linux/string.h>
 #include "adf_cfg.h"
+#include "adf_cfg_common.h"
 #include "adf_cfg_services.h"
 #include "adf_cfg_strings.h"
 
@@ -178,3 +179,34 @@ int adf_get_service_enabled(struct adf_accel_dev *accel_dev)
 	return -EINVAL;
 }
 EXPORT_SYMBOL_GPL(adf_get_service_enabled);
+
+enum adf_cfg_service_type adf_srv_to_cfg_svc_type(enum adf_base_services svc)
+{
+	switch (svc) {
+	case SVC_ASYM:
+		return ASYM;
+	case SVC_SYM:
+		return SYM;
+	case SVC_DC:
+		return COMP;
+	case SVC_DECOMP:
+		return DECOMP;
+	default:
+		return UNUSED;
+	}
+}
+
+bool adf_is_service_enabled(struct adf_accel_dev *accel_dev, enum adf_base_services svc)
+{
+	enum adf_cfg_service_type arb_srv = adf_srv_to_cfg_svc_type(svc);
+	struct adf_hw_device_data *hw_data = GET_HW_DATA(accel_dev);
+	u8 rps_per_bundle = hw_data->num_banks_per_vf;
+	int i;
+
+	for (i = 0; i < rps_per_bundle; i++) {
+		if (GET_SRV_TYPE(accel_dev, i) == arb_srv)
+			return true;
+	}
+
+	return false;
+}
diff --git a/drivers/crypto/intel/qat/qat_common/adf_cfg_services.h b/drivers/crypto/intel/qat/qat_common/adf_cfg_services.h
index b2dd62eabf26..913d717280af 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_cfg_services.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_cfg_services.h
@@ -38,5 +38,7 @@ int adf_parse_service_string(struct adf_accel_dev *accel_dev, const char *in,
 			     size_t in_len, char *out, size_t out_len);
 int adf_get_service_enabled(struct adf_accel_dev *accel_dev);
 int adf_get_service_mask(struct adf_accel_dev *accel_dev, unsigned long *mask);
+enum adf_cfg_service_type adf_srv_to_cfg_svc_type(enum adf_base_services svc);
+bool adf_is_service_enabled(struct adf_accel_dev *accel_dev, enum adf_base_services svc);
 
 #endif
diff --git a/drivers/crypto/intel/qat/qat_common/adf_rl.c b/drivers/crypto/intel/qat/qat_common/adf_rl.c
index 0d5f59bfa6a2..926975539740 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_rl.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_rl.c
@@ -169,22 +169,6 @@ static struct rl_sla *find_parent(struct adf_rl *rl_data,
 	return NULL;
 }
 
-static enum adf_cfg_service_type srv_to_cfg_svc_type(enum adf_base_services rl_srv)
-{
-	switch (rl_srv) {
-	case SVC_ASYM:
-		return ASYM;
-	case SVC_SYM:
-		return SYM;
-	case SVC_DC:
-		return COMP;
-	case SVC_DECOMP:
-		return DECOMP;
-	default:
-		return UNUSED;
-	}
-}
-
 /**
  * adf_rl_get_sla_arr_of_type() - Returns a pointer to SLA type specific array
  * @rl_data: pointer to ratelimiting data
@@ -212,21 +196,6 @@ u32 adf_rl_get_sla_arr_of_type(struct adf_rl *rl_data, enum rl_node_type type,
 	}
 }
 
-bool is_service_enabled(struct adf_accel_dev *accel_dev, enum adf_base_services rl_srv)
-{
-	enum adf_cfg_service_type arb_srv = srv_to_cfg_svc_type(rl_srv);
-	struct adf_hw_device_data *hw_data = GET_HW_DATA(accel_dev);
-	u8 rps_per_bundle = hw_data->num_banks_per_vf;
-	int i;
-
-	for (i = 0; i < rps_per_bundle; i++) {
-		if (GET_SRV_TYPE(accel_dev, i) == arb_srv)
-			return true;
-	}
-
-	return false;
-}
-
 /**
  * prepare_rp_ids() - Creates an array of ring pair IDs from bitmask
  * @accel_dev: pointer to acceleration device structure
@@ -245,7 +214,7 @@ bool is_service_enabled(struct adf_accel_dev *accel_dev, enum adf_base_services
 static int prepare_rp_ids(struct adf_accel_dev *accel_dev, struct rl_sla *sla,
 			  const unsigned long rp_mask)
 {
-	enum adf_cfg_service_type arb_srv = srv_to_cfg_svc_type(sla->srv);
+	enum adf_cfg_service_type arb_srv = adf_srv_to_cfg_svc_type(sla->srv);
 	u16 rps_per_bundle = GET_HW_DATA(accel_dev)->num_banks_per_vf;
 	bool *rp_in_use = accel_dev->rate_limiting->rp_in_use;
 	size_t rp_cnt_max = ARRAY_SIZE(sla->ring_pairs_ids);
@@ -661,7 +630,7 @@ static int add_new_sla_entry(struct adf_accel_dev *accel_dev,
 	}
 	*sla_out = sla;
 
-	if (!is_service_enabled(accel_dev, sla_in->srv)) {
+	if (!adf_is_service_enabled(accel_dev, sla_in->srv)) {
 		dev_notice(&GET_DEV(accel_dev),
 			   "Provided service is not enabled\n");
 		ret = -EINVAL;
@@ -732,7 +701,7 @@ static int initialize_default_nodes(struct adf_accel_dev *accel_dev)
 	sla_in.parent_id = RL_PARENT_DEFAULT_ID;
 
 	for (i = 0; i < SVC_BASE_COUNT; i++) {
-		if (!is_service_enabled(accel_dev, i))
+		if (!adf_is_service_enabled(accel_dev, i))
 			continue;
 
 		sla_in.cir = device_data->scale_ref;
diff --git a/drivers/crypto/intel/qat/qat_common/adf_rl.h b/drivers/crypto/intel/qat/qat_common/adf_rl.h
index f2393bdb8ccc..dee7f0c81906 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_rl.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_rl.h
@@ -170,6 +170,5 @@ u32 adf_rl_calculate_ae_cycles(struct adf_accel_dev *accel_dev, u32 sla_val,
 			       enum adf_base_services svc_type);
 u32 adf_rl_calculate_slice_tokens(struct adf_accel_dev *accel_dev, u32 sla_val,
 				  enum adf_base_services svc_type);
-bool is_service_enabled(struct adf_accel_dev *accel_dev, enum adf_base_services rl_srv);
 
 #endif /* ADF_RL_H_ */
diff --git a/drivers/crypto/intel/qat/qat_common/adf_sysfs_rl.c b/drivers/crypto/intel/qat/qat_common/adf_sysfs_rl.c
index 9d439df6d9ad..f31556beed8b 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_sysfs_rl.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_sysfs_rl.c
@@ -305,7 +305,7 @@ static ssize_t srv_store(struct device *dev, struct device_attribute *attr,
 		return ret;
 
 	val = ret;
-	if (!is_service_enabled(accel_dev, val))
+	if (!adf_is_service_enabled(accel_dev, val))
 		return -EINVAL;
 
 	ret = set_param_u(dev, SRV, val);
-- 
2.40.1

