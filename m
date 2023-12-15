Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0235619456
	for <linux-crypto@vger.kernel.org>; Fri, 15 Dec 2023 10:03:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="a54aieq0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1702634603; x=1734170603;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=j/fNOc9Zztm0usVxAUcBuq7cfxEs1jN47ZAq7Jrlbi4=;
  b=a54aieq0NGkiRKrd/x0DF0YFXCSWnq40tkBm0MX3uEXTB1/LTyfciXDI
   jYp2Ezai4x5COUwTQ8WJT7iEV+GYumV2LB0CApi/iHPCnG7Yp5X7j5BJf
   Sy5nUADkA+1SQ5DUCA2rHqB1qpTtH5WFB803BjFlap4QzKBm6lsvVEfLE
   HE4tDrpmAzZCcqUXk/DEiMYD4CNQ/nT3NyYjgQg3Kduyp3owbm6WMZj86
   JiZZ7vJs1Bx10jPB/qP70y4zHnUUUbvFp/1A66GeOc+ih+u46wOB1K/1L
   iSdZieO9ChbOYAJzh8eKTDvDaq46+ZPp3oUZbYLxLz1yvkVevBqmsHXxn
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10924"; a="374759852"
X-IronPort-AV: E=Sophos;i="6.04,278,1695711600"; 
   d="scan'208";a="374759852"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Dec 2023 02:03:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10924"; a="845074084"
X-IronPort-AV: E=Sophos;i="6.04,278,1695711600"; 
   d="scan'208";a="845074084"
Received: from qat-wangjie-342.sh.intel.com ([10.67.115.171])
  by fmsmga004.fm.intel.com with ESMTP; 15 Dec 2023 02:03:22 -0800
From: Jie Wang <jie.wang@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com
Subject: [PATCH 1/5] crypto: qat - relocate and rename get_service_enabled()
Date: Fri, 15 Dec 2023 05:01:44 -0500
Message-Id: <20231215100147.1703641-2-jie.wang@intel.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20231215100147.1703641-1-jie.wang@intel.com>
References: <20231215100147.1703641-1-jie.wang@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Asia-Pacific Research & Development Ltd. - No. 880, Zi Xing, Road, Shanghai Zizhu Science Park, Shanghai, 200241, PRC
Content-Transfer-Encoding: 8bit

Move the function get_service_enabled() from adf_4xxx_hw_data.c to
adf_cfg_services.c and rename it as adf_get_service_enabled().
This function is not specific to the 4xxx and will be used by
other QAT drivers.

This does not introduce any functional change.

Signed-off-by: Jie Wang <jie.wang@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 .../intel/qat/qat_4xxx/adf_4xxx_hw_data.c     | 29 ++-----------------
 .../intel/qat/qat_common/adf_cfg_services.c   | 27 +++++++++++++++++
 .../intel/qat/qat_common/adf_cfg_services.h   |  4 +++
 3 files changed, 34 insertions(+), 26 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c b/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
index 0faedb5b2eb5..9763402cd486 100644
--- a/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
@@ -120,29 +120,6 @@ static struct adf_hw_device_class adf_4xxx_class = {
 	.instances = 0,
 };
 
-static int get_service_enabled(struct adf_accel_dev *accel_dev)
-{
-	char services[ADF_CFG_MAX_VAL_LEN_IN_BYTES] = {0};
-	int ret;
-
-	ret = adf_cfg_get_param_value(accel_dev, ADF_GENERAL_SEC,
-				      ADF_SERVICES_ENABLED, services);
-	if (ret) {
-		dev_err(&GET_DEV(accel_dev),
-			ADF_SERVICES_ENABLED " param not found\n");
-		return ret;
-	}
-
-	ret = match_string(adf_cfg_services, ARRAY_SIZE(adf_cfg_services),
-			   services);
-	if (ret < 0)
-		dev_err(&GET_DEV(accel_dev),
-			"Invalid value of " ADF_SERVICES_ENABLED " param: %s\n",
-			services);
-
-	return ret;
-}
-
 static u32 get_accel_mask(struct adf_hw_device_data *self)
 {
 	return ADF_4XXX_ACCELERATORS_MASK;
@@ -275,7 +252,7 @@ static u32 get_accel_cap(struct adf_accel_dev *accel_dev)
 		capabilities_dc &= ~ICP_ACCEL_CAPABILITIES_CNV_INTEGRITY64;
 	}
 
-	switch (get_service_enabled(accel_dev)) {
+	switch (adf_get_service_enabled(accel_dev)) {
 	case SVC_CY:
 	case SVC_CY2:
 		return capabilities_sym | capabilities_asym;
@@ -311,7 +288,7 @@ static enum dev_sku_info get_sku(struct adf_hw_device_data *self)
 
 static const u32 *adf_get_arbiter_mapping(struct adf_accel_dev *accel_dev)
 {
-	switch (get_service_enabled(accel_dev)) {
+	switch (adf_get_service_enabled(accel_dev)) {
 	case SVC_DC:
 		return thrd_to_arb_map_dc;
 	case SVC_DCC:
@@ -420,7 +397,7 @@ static u32 uof_get_num_objs(void)
 
 static const struct adf_fw_config *get_fw_config(struct adf_accel_dev *accel_dev)
 {
-	switch (get_service_enabled(accel_dev)) {
+	switch (adf_get_service_enabled(accel_dev)) {
 	case SVC_CY:
 	case SVC_CY2:
 		return adf_fw_cy_config;
diff --git a/drivers/crypto/intel/qat/qat_common/adf_cfg_services.c b/drivers/crypto/intel/qat/qat_common/adf_cfg_services.c
index 8e13fe938959..268052294468 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_cfg_services.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_cfg_services.c
@@ -2,6 +2,9 @@
 /* Copyright(c) 2023 Intel Corporation */
 
 #include <linux/export.h>
+#include <linux/pci.h>
+#include <linux/string.h>
+#include "adf_cfg.h"
 #include "adf_cfg_services.h"
 #include "adf_cfg_strings.h"
 
@@ -18,3 +21,27 @@ const char *const adf_cfg_services[] = {
 	[SVC_SYM_DC] = ADF_CFG_SYM_DC,
 };
 EXPORT_SYMBOL_GPL(adf_cfg_services);
+
+int adf_get_service_enabled(struct adf_accel_dev *accel_dev)
+{
+	char services[ADF_CFG_MAX_VAL_LEN_IN_BYTES] = {0};
+	int ret;
+
+	ret = adf_cfg_get_param_value(accel_dev, ADF_GENERAL_SEC,
+				      ADF_SERVICES_ENABLED, services);
+	if (ret) {
+		dev_err(&GET_DEV(accel_dev),
+			ADF_SERVICES_ENABLED " param not found\n");
+		return ret;
+	}
+
+	ret = match_string(adf_cfg_services, ARRAY_SIZE(adf_cfg_services),
+			   services);
+	if (ret < 0)
+		dev_err(&GET_DEV(accel_dev),
+			"Invalid value of " ADF_SERVICES_ENABLED " param: %s\n",
+			services);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(adf_get_service_enabled);
diff --git a/drivers/crypto/intel/qat/qat_common/adf_cfg_services.h b/drivers/crypto/intel/qat/qat_common/adf_cfg_services.h
index f78fd697b4be..c6b0328b0f5b 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_cfg_services.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_cfg_services.h
@@ -5,6 +5,8 @@
 
 #include "adf_cfg_strings.h"
 
+struct adf_accel_dev;
+
 enum adf_services {
 	SVC_CY = 0,
 	SVC_CY2,
@@ -21,4 +23,6 @@ enum adf_services {
 
 extern const char *const adf_cfg_services[SVC_COUNT];
 
+int adf_get_service_enabled(struct adf_accel_dev *accel_dev);
+
 #endif
-- 
2.32.0

