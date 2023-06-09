Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6ED99C7EE45
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Jun 2023 16:49:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229683AbjFIQtA (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 9 Jun 2023 12:49:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229985AbjFIQsv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Jun 2023 12:48:51 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 637463A9C
        for <linux-crypto@vger.kernel.org>; Fri,  9 Jun 2023 09:48:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686329327; x=1717865327;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6E1Z+xr4GtuZJUiAXb9iB4AqJ1GpUNmBB/7x87Ovxy4=;
  b=bJapSSKuepbLRdKzUiJEEOOfZP981Xlf0Ail3zyELQKcpT4EEnDORpZU
   zUsfyZmfcHCfcOG5YuQd7Q9Vje9rrs0S1wCcQCenwBC/3teoQ6klON2YF
   GHAnbq3M1yS18Z9UwfpZJw19RIVgh5TAuZg7EArOtZgSzFR/Vgsobn8FI
   8Snf+wnf+577z9rJJTkOgzJxxZrXdY9582KdqduXVLghrLO8vYCjmDLjJ
   eGBo4RZZYKYJdkzggI61qHmaKfhHZLhmLK0FW50BZtJZNLMd1wpV03uYT
   GIQJ+mo7Sy3Wpi+qtZ83V5Yjsj90nnE8PE2Uu/uUjpmIzfiU6Z4Y4s5by
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10736"; a="337999093"
X-IronPort-AV: E=Sophos;i="6.00,229,1681196400"; 
   d="scan'208";a="337999093"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2023 09:48:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10736"; a="957214185"
X-IronPort-AV: E=Sophos;i="6.00,229,1681196400"; 
   d="scan'208";a="957214185"
Received: from silpixa00400295.ir.intel.com ([10.237.213.194])
  by fmsmga006.fm.intel.com with ESMTP; 09 Jun 2023 09:48:29 -0700
From:   Adam Guerin <adam.guerin@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Adam Guerin <adam.guerin@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 3/4] crypto: qat - refactor fw config logic for 4xxx
Date:   Fri,  9 Jun 2023 17:38:21 +0100
Message-Id: <20230609163821.6533-4-adam.guerin@intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230609163821.6533-1-adam.guerin@intel.com>
References: <20230609163821.6533-1-adam.guerin@intel.com>
MIME-Version: 1.0
Organisation: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare, Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

The data structure adf_fw_config is used to select which firmware image
is loaded on a certain set of accelerator engines.
When support for 402xx was added, the adf_fw_config arrays were
duplicated in order to select different firmware images.

Since the configurations are the same regardless of the QAT GEN4
flavour, in preparation for adding support for multiple configurations,
refactor the logic that retrieves the firmware names in the 4xxx driver.
The structure adf_fw_config has been changed to contain a firmware object
id that is then mapped to a firmware name depending of the device type.

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Adam Guerin <adam.guerin@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 .../intel/qat/qat_4xxx/adf_4xxx_hw_data.c     | 96 +++++++++++--------
 1 file changed, 58 insertions(+), 38 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c b/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
index 7a2f56567298..bd55c938f7eb 100644
--- a/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
@@ -12,35 +12,46 @@
 #include "adf_4xxx_hw_data.h"
 #include "icp_qat_hw.h"
 
-struct adf_fw_config {
-	u32 ae_mask;
-	const char *obj_name;
+enum adf_fw_objs {
+	ADF_FW_SYM_OBJ,
+	ADF_FW_ASYM_OBJ,
+	ADF_FW_DC_OBJ,
+	ADF_FW_ADMIN_OBJ,
+};
+
+static const char * const adf_4xxx_fw_objs[] = {
+	[ADF_FW_SYM_OBJ] =  ADF_4XXX_SYM_OBJ,
+	[ADF_FW_ASYM_OBJ] =  ADF_4XXX_ASYM_OBJ,
+	[ADF_FW_DC_OBJ] =  ADF_4XXX_DC_OBJ,
+	[ADF_FW_ADMIN_OBJ] = ADF_4XXX_ADMIN_OBJ,
 };
 
-static struct adf_fw_config adf_4xxx_fw_cy_config[] = {
-	{0xF0, ADF_4XXX_SYM_OBJ},
-	{0xF, ADF_4XXX_ASYM_OBJ},
-	{0x100, ADF_4XXX_ADMIN_OBJ},
+static const char * const adf_402xx_fw_objs[] = {
+	[ADF_FW_SYM_OBJ] =  ADF_402XX_SYM_OBJ,
+	[ADF_FW_ASYM_OBJ] =  ADF_402XX_ASYM_OBJ,
+	[ADF_FW_DC_OBJ] =  ADF_402XX_DC_OBJ,
+	[ADF_FW_ADMIN_OBJ] = ADF_402XX_ADMIN_OBJ,
 };
 
-static struct adf_fw_config adf_4xxx_fw_dc_config[] = {
-	{0xF0, ADF_4XXX_DC_OBJ},
-	{0xF, ADF_4XXX_DC_OBJ},
-	{0x100, ADF_4XXX_ADMIN_OBJ},
+struct adf_fw_config {
+	u32 ae_mask;
+	enum adf_fw_objs obj;
 };
 
-static struct adf_fw_config adf_402xx_fw_cy_config[] = {
-	{0xF0, ADF_402XX_SYM_OBJ},
-	{0xF, ADF_402XX_ASYM_OBJ},
-	{0x100, ADF_402XX_ADMIN_OBJ},
+static const struct adf_fw_config adf_fw_cy_config[] = {
+	{0xF0, ADF_FW_SYM_OBJ},
+	{0xF, ADF_FW_ASYM_OBJ},
+	{0x100, ADF_FW_ADMIN_OBJ},
 };
 
-static struct adf_fw_config adf_402xx_fw_dc_config[] = {
-	{0xF0, ADF_402XX_DC_OBJ},
-	{0xF, ADF_402XX_DC_OBJ},
-	{0x100, ADF_402XX_ADMIN_OBJ},
+static const struct adf_fw_config adf_fw_dc_config[] = {
+	{0xF0, ADF_FW_DC_OBJ},
+	{0xF, ADF_FW_DC_OBJ},
+	{0x100, ADF_FW_ADMIN_OBJ},
 };
 
+static_assert(ARRAY_SIZE(adf_fw_cy_config) == ARRAY_SIZE(adf_fw_dc_config));
+
 /* Worker thread to service arbiter mappings */
 static const u32 thrd_to_arb_map_cy[ADF_4XXX_MAX_ACCELENGINES] = {
 	0x5555555, 0x5555555, 0x5555555, 0x5555555,
@@ -305,44 +316,53 @@ static int adf_init_device(struct adf_accel_dev *accel_dev)
 
 static u32 uof_get_num_objs(void)
 {
-	BUILD_BUG_ON_MSG(ARRAY_SIZE(adf_4xxx_fw_cy_config) !=
-			 ARRAY_SIZE(adf_4xxx_fw_dc_config),
-			 "Size mismatch between adf_4xxx_fw_*_config arrays");
-
-	return ARRAY_SIZE(adf_4xxx_fw_cy_config);
+	return ARRAY_SIZE(adf_fw_cy_config);
 }
 
-static const char *uof_get_name_4xxx(struct adf_accel_dev *accel_dev, u32 obj_num)
+static const char *uof_get_name(struct adf_accel_dev *accel_dev, u32 obj_num,
+				const char * const fw_objs[], int num_objs)
 {
+	int id;
+
 	switch (get_service_enabled(accel_dev)) {
 	case SVC_CY:
-		return adf_4xxx_fw_cy_config[obj_num].obj_name;
+		id = adf_fw_cy_config[obj_num].obj;
+		break;
 	case SVC_DC:
-		return adf_4xxx_fw_dc_config[obj_num].obj_name;
+		id = adf_fw_dc_config[obj_num].obj;
+		break;
 	default:
-		return NULL;
+		id = -EINVAL;
+		break;
 	}
+
+	if (id < 0 || id > num_objs)
+		return NULL;
+
+	return fw_objs[id];
+}
+
+static const char *uof_get_name_4xxx(struct adf_accel_dev *accel_dev, u32 obj_num)
+{
+	int num_fw_objs = ARRAY_SIZE(adf_4xxx_fw_objs);
+
+	return uof_get_name(accel_dev, obj_num, adf_4xxx_fw_objs, num_fw_objs);
 }
 
 static const char *uof_get_name_402xx(struct adf_accel_dev *accel_dev, u32 obj_num)
 {
-	switch (get_service_enabled(accel_dev)) {
-	case SVC_CY:
-		return adf_402xx_fw_cy_config[obj_num].obj_name;
-	case SVC_DC:
-		return adf_402xx_fw_dc_config[obj_num].obj_name;
-	default:
-		return NULL;
-	}
+	int num_fw_objs = ARRAY_SIZE(adf_402xx_fw_objs);
+
+	return uof_get_name(accel_dev, obj_num, adf_402xx_fw_objs, num_fw_objs);
 }
 
 static u32 uof_get_ae_mask(struct adf_accel_dev *accel_dev, u32 obj_num)
 {
 	switch (get_service_enabled(accel_dev)) {
 	case SVC_CY:
-		return adf_4xxx_fw_cy_config[obj_num].ae_mask;
+		return adf_fw_cy_config[obj_num].ae_mask;
 	case SVC_DC:
-		return adf_4xxx_fw_dc_config[obj_num].ae_mask;
+		return adf_fw_dc_config[obj_num].ae_mask;
 	default:
 		return 0;
 	}
-- 
2.40.1

