Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9110A19449
	for <linux-crypto@vger.kernel.org>; Fri, 15 Dec 2023 10:03:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="P9HhGm9F"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1702634613; x=1734170613;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=odBB7OBGYdkTPnDr36LdJ6adGf9OjZBdp4N89v48JlQ=;
  b=P9HhGm9FQfa2Bb4MT4zFcj1VQaGALZWowt4kt5BBbH6Fklx+swbQMq5V
   muw2qmYEr0MrvpPjN8TxRRdOBfXLVZHfm16hmOW9kDz5NQO/yL6Y7rbgF
   LVX3Ycyx3uw6HeBGVbbx/qjiv5TimK4u7DOad2DmsbFew3YOIsVnyBHxt
   ratp74ylHPjoOa/cemwrg4R54rL0N1OKimLRHSWCamkdyRB6VfQ3WCg3B
   UD76VhMp1RIaCsxeArRD0zcg2aF9YF70M2DrXMuY1QuSNNDoanaIhd1oQ
   M2TQ7jBvvOklpTLW+R5yj+drnbh7cxiYZEH2Ru5jFyqOTNDFCskYy0OV8
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10924"; a="374759866"
X-IronPort-AV: E=Sophos;i="6.04,278,1695711600"; 
   d="scan'208";a="374759866"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Dec 2023 02:03:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10924"; a="845074113"
X-IronPort-AV: E=Sophos;i="6.04,278,1695711600"; 
   d="scan'208";a="845074113"
Received: from qat-wangjie-342.sh.intel.com ([10.67.115.171])
  by fmsmga004.fm.intel.com with ESMTP; 15 Dec 2023 02:03:31 -0800
From: Jie Wang <jie.wang@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com
Subject: [PATCH 4/5] crypto: qat - move fw config related structures
Date: Fri, 15 Dec 2023 05:01:47 -0500
Message-Id: <20231215100147.1703641-5-jie.wang@intel.com>
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

Relocate the structures adf_fw_objs and adf_fw_config from the file
adf_4xxx_hw_data.c to the newly created adf_fw_config.h.

These structures will be used by new device drivers.

This does not introduce any functional change.

Signed-off-by: Jie Wang <jie.wang@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 .../intel/qat/qat_4xxx/adf_4xxx_hw_data.c      | 13 +------------
 .../intel/qat/qat_common/adf_fw_config.h       | 18 ++++++++++++++++++
 2 files changed, 19 insertions(+), 12 deletions(-)
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_fw_config.h

diff --git a/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c b/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
index ee0ffeec491b..f133126932c1 100644
--- a/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
@@ -7,6 +7,7 @@
 #include <adf_cfg_services.h>
 #include <adf_clock.h>
 #include <adf_common_drv.h>
+#include <adf_fw_config.h>
 #include <adf_gen4_config.h>
 #include <adf_gen4_dc.h>
 #include <adf_gen4_hw_data.h>
@@ -21,13 +22,6 @@
 #define ADF_AE_GROUP_1		GENMASK(7, 4)
 #define ADF_AE_GROUP_2		BIT(8)
 
-enum adf_fw_objs {
-	ADF_FW_SYM_OBJ,
-	ADF_FW_ASYM_OBJ,
-	ADF_FW_DC_OBJ,
-	ADF_FW_ADMIN_OBJ,
-};
-
 static const char * const adf_4xxx_fw_objs[] = {
 	[ADF_FW_SYM_OBJ] =  ADF_4XXX_SYM_OBJ,
 	[ADF_FW_ASYM_OBJ] =  ADF_4XXX_ASYM_OBJ,
@@ -42,11 +36,6 @@ static const char * const adf_402xx_fw_objs[] = {
 	[ADF_FW_ADMIN_OBJ] = ADF_402XX_ADMIN_OBJ,
 };
 
-struct adf_fw_config {
-	u32 ae_mask;
-	enum adf_fw_objs obj;
-};
-
 static const struct adf_fw_config adf_fw_cy_config[] = {
 	{ADF_AE_GROUP_1, ADF_FW_SYM_OBJ},
 	{ADF_AE_GROUP_0, ADF_FW_ASYM_OBJ},
diff --git a/drivers/crypto/intel/qat/qat_common/adf_fw_config.h b/drivers/crypto/intel/qat/qat_common/adf_fw_config.h
new file mode 100644
index 000000000000..4f86696800c9
--- /dev/null
+++ b/drivers/crypto/intel/qat/qat_common/adf_fw_config.h
@@ -0,0 +1,18 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/* Copyright(c) 2023 Intel Corporation */
+#ifndef ADF_FW_CONFIG_H_
+#define ADF_FW_CONFIG_H_
+
+enum adf_fw_objs {
+	ADF_FW_SYM_OBJ,
+	ADF_FW_ASYM_OBJ,
+	ADF_FW_DC_OBJ,
+	ADF_FW_ADMIN_OBJ,
+};
+
+struct adf_fw_config {
+	u32 ae_mask;
+	enum adf_fw_objs obj;
+};
+
+#endif
-- 
2.32.0

