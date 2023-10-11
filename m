Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96A2ACD6E5D
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Oct 2023 12:36:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232134AbjJKMgK (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 11 Oct 2023 08:36:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232196AbjJKMgJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 11 Oct 2023 08:36:09 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C605491
        for <linux-crypto@vger.kernel.org>; Wed, 11 Oct 2023 05:36:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697027768; x=1728563768;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qx01Cy/3Dx2OJ2Acq0V8Q7tRBDuidK0vA5gkhLKGV/s=;
  b=YTE7RTdsm/CGeYvrEfOttnvzXDPEfWtzymP4zO6tbiuY3j4gj0+jie1b
   zLaNRcUFdTJuxeV8m0n8spCkAhRlJFswO0FncDhmtiDd0D4DLruTMNO76
   SU8uM4CgWJZPKpeaj98zTK8vXYqGKt+3lBTtqEvhDEpHjr4W4LAyw/NbC
   rEm1aJusl/l4jCMf8uOa/2wsmEwz91ADCrmw6AU0RIAmCQ4jqHOzYgI4a
   ldHor1Pmxnb0WD85xlun1Ebmol3+EiMJznFZ6gghU3xVjzE+qLIXt+92n
   DqqUptbQirZaFEDuhlKy+l6WoVuJejvOMa8w1VppgsXkuOSsuxf1JYNk/
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10860"; a="374992830"
X-IronPort-AV: E=Sophos;i="6.03,216,1694761200"; 
   d="scan'208";a="374992830"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Oct 2023 05:36:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10860"; a="870124630"
X-IronPort-AV: E=Sophos;i="6.03,216,1694761200"; 
   d="scan'208";a="870124630"
Received: from r031s002_zp31l10c01.deacluster.intel.com (HELO localhost.localdomain) ([10.219.171.29])
  by fmsmga002.fm.intel.com with ESMTP; 11 Oct 2023 05:36:07 -0700
From:   Damian Muszynski <damian.muszynski@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Damian Muszynski <damian.muszynski@intel.com>
Subject: [PATCH 01/11] crypto: qat - refactor fw config related functions
Date:   Wed, 11 Oct 2023 14:14:59 +0200
Message-ID: <20231011121934.45255-2-damian.muszynski@intel.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231011121934.45255-1-damian.muszynski@intel.com>
References: <20231011121934.45255-1-damian.muszynski@intel.com>
MIME-Version: 1.0
Organization: Intel Technology Poland sp. z o.o. - ul. Slowackiego 173, 80-298 Gdansk - KRS 101882 - NIP 957-07-52-316
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

The logic that selects the correct adf_fw_config structure based on the
configured service is replicated twice in the uof_get_name() and
uof_get_ae_mask() functions. Refactor the code so that there is no
replication.

This does not introduce any functional change.

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Damian Muszynski <damian.muszynski@intel.com>
---
 .../intel/qat/qat_4xxx/adf_4xxx_hw_data.c     | 69 ++++++++-----------
 1 file changed, 28 insertions(+), 41 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c b/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
index 12b5d1819111..10839269c4d3 100644
--- a/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
@@ -394,40 +394,42 @@ static u32 uof_get_num_objs(void)
 	return ARRAY_SIZE(adf_fw_cy_config);
 }
 
-static const char *uof_get_name(struct adf_accel_dev *accel_dev, u32 obj_num,
-				const char * const fw_objs[], int num_objs)
+static const struct adf_fw_config *get_fw_config(struct adf_accel_dev *accel_dev)
 {
-	int id;
-
 	switch (get_service_enabled(accel_dev)) {
 	case SVC_CY:
 	case SVC_CY2:
-		id = adf_fw_cy_config[obj_num].obj;
-		break;
+		return adf_fw_cy_config;
 	case SVC_DC:
-		id = adf_fw_dc_config[obj_num].obj;
-		break;
+		return adf_fw_dc_config;
 	case SVC_DCC:
-		id = adf_fw_dcc_config[obj_num].obj;
-		break;
+		return adf_fw_dcc_config;
 	case SVC_SYM:
-		id = adf_fw_sym_config[obj_num].obj;
-		break;
+		return adf_fw_sym_config;
 	case SVC_ASYM:
-		id =  adf_fw_asym_config[obj_num].obj;
-		break;
+		return adf_fw_asym_config;
 	case SVC_ASYM_DC:
 	case SVC_DC_ASYM:
-		id = adf_fw_asym_dc_config[obj_num].obj;
-		break;
+		return adf_fw_asym_dc_config;
 	case SVC_SYM_DC:
 	case SVC_DC_SYM:
-		id = adf_fw_sym_dc_config[obj_num].obj;
-		break;
+		return adf_fw_sym_dc_config;
 	default:
-		id = -EINVAL;
-		break;
+		return NULL;
 	}
+}
+
+static const char *uof_get_name(struct adf_accel_dev *accel_dev, u32 obj_num,
+				const char * const fw_objs[], int num_objs)
+{
+	const struct adf_fw_config *fw_config;
+	int id;
+
+	fw_config = get_fw_config(accel_dev);
+	if (fw_config)
+		id = fw_config[obj_num].obj;
+	else
+		id = -EINVAL;
 
 	if (id < 0 || id > num_objs)
 		return NULL;
@@ -451,28 +453,13 @@ static const char *uof_get_name_402xx(struct adf_accel_dev *accel_dev, u32 obj_n
 
 static u32 uof_get_ae_mask(struct adf_accel_dev *accel_dev, u32 obj_num)
 {
-	switch (get_service_enabled(accel_dev)) {
-	case SVC_CY:
-		return adf_fw_cy_config[obj_num].ae_mask;
-	case SVC_DC:
-		return adf_fw_dc_config[obj_num].ae_mask;
-	case SVC_DCC:
-		return adf_fw_dcc_config[obj_num].ae_mask;
-	case SVC_CY2:
-		return adf_fw_cy_config[obj_num].ae_mask;
-	case SVC_SYM:
-		return adf_fw_sym_config[obj_num].ae_mask;
-	case SVC_ASYM:
-		return adf_fw_asym_config[obj_num].ae_mask;
-	case SVC_ASYM_DC:
-	case SVC_DC_ASYM:
-		return adf_fw_asym_dc_config[obj_num].ae_mask;
-	case SVC_SYM_DC:
-	case SVC_DC_SYM:
-		return adf_fw_sym_dc_config[obj_num].ae_mask;
-	default:
+	const struct adf_fw_config *fw_config;
+
+	fw_config = get_fw_config(accel_dev);
+	if (!fw_config)
 		return 0;
-	}
+
+	return fw_config[obj_num].ae_mask;
 }
 
 void adf_init_hw_data_4xxx(struct adf_hw_device_data *hw_data, u32 dev_id)
-- 
2.41.0

