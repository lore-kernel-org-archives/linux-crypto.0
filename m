Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6850A1339A6
	for <linux-crypto@vger.kernel.org>; Fri, 16 Feb 2024 17:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708105547; cv=none; b=NiGMYE6KtV2kbGa7Q37byecl5qqxDQwZO0nRVGweYfyapfyAj3FsdZyhKHo/mnfUXOhZKKtt6xtl6ey1L5PlLlg47QIfNEjz7f6rKkyUsq08NqcCtFZ7cbipZVQx4uz1S49ru9njsDAdstatj5c1FR3PwvPVHF1pSOK9uKMxy1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708105547; c=relaxed/simple;
	bh=ygxJl04V/1ApxvBtY417OdAgezTMcNRJP4fM0M+MRg4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TVDydTOB9sIvDzA5wn0E/apUkkn5kxeqGwsRR0uhmBnNDzOImjIIZ2zxAecO5EHIz2CxJcC2fMVuStjRZt6NmD/0mlrc2h4noMlH0CSzblPNkwBIci/xtDB5JvNxhyEh4AOG6E/7a+/55VogIgwrxzxy0PwkTuz/L7aIBOQfNcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Y5cgAomX; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Y5cgAomX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708105546; x=1739641546;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ygxJl04V/1ApxvBtY417OdAgezTMcNRJP4fM0M+MRg4=;
  b=Y5cgAomXSF67xLKU1XN11+H3aA6AfTZeRJ4vSwVk0pJkGL0VF0IrHMc8
   pcdAohAQ2mDPLma7DiVRci6uzcMB7psFa/pX9bKssTs+OT/aFjdURgDcf
   YrGf+olZs1rofntPshTSWx8vsu3NaxjZmvXAByERn+AfNaYTKH8e2DOAB
   DPcagj3ddGovBAX5zE2IWq5ity1QAvLDnJN2cTSgVzFeu2TdePN34CT1z
   vBgqEj/ym9syVqBVuq+gJUAQOQLv6vxk86GxF1qi8n8BZeCfHWrfNfYUU
   oZibDJg/V7M0HTpHOtn0EPUaJ54siz7tdLm3JV93S+hnwpeQ0QDg5sozp
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10986"; a="2097847"
X-IronPort-AV: E=Sophos;i="6.06,165,1705392000"; 
   d="scan'208";a="2097847"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2024 09:45:46 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,165,1705392000"; 
   d="scan'208";a="8507306"
Received: from r031s002_zp31l10c01.deacluster.intel.com (HELO localhost.localdomain) ([10.219.171.29])
  by fmviesa003.fm.intel.com with ESMTP; 16 Feb 2024 09:45:45 -0800
From: Damian Muszynski <damian.muszynski@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	Damian Muszynski <damian.muszynski@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH 3/3] crypto: qat - make ring to service map common for QAT GEN4
Date: Fri, 16 Feb 2024 18:21:56 +0100
Message-ID: <20240216172545.177303-4-damian.muszynski@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240216172545.177303-1-damian.muszynski@intel.com>
References: <20240216172545.177303-1-damian.muszynski@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Technology Poland sp. z o.o. - ul. Slowackiego 173, 80-298 Gdansk - KRS 101882 - NIP 957-07-52-316
Content-Transfer-Encoding: 8bit

The function get_ring_to_svc_map() is present in both 420xx and
4xxx drivers. Rework the logic to make it generic to GEN4 devices
and move it to qat_common/adf_gen4_hw_data.c.

Signed-off-by: Damian Muszynski <damian.muszynski@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 .../intel/qat/qat_420xx/adf_420xx_hw_data.c   | 72 +++++--------------
 .../intel/qat/qat_4xxx/adf_4xxx_hw_data.c     | 72 +++++--------------
 .../intel/qat/qat_common/adf_accel_devices.h  |  1 +
 .../intel/qat/qat_common/adf_gen4_hw_data.c   | 56 +++++++++++++++
 .../intel/qat/qat_common/adf_gen4_hw_data.h   |  1 +
 5 files changed, 90 insertions(+), 112 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c b/drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c
index 7909b51e97c3..1102c47f8293 100644
--- a/drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c
@@ -361,61 +361,6 @@ static u32 get_ena_thd_mask(struct adf_accel_dev *accel_dev, u32 obj_num)
 	}
 }
 
-static u16 get_ring_to_svc_map(struct adf_accel_dev *accel_dev)
-{
-	enum adf_cfg_service_type rps[RP_GROUP_COUNT] = { };
-	const struct adf_fw_config *fw_config;
-	u16 ring_to_svc_map;
-	int i, j;
-
-	fw_config = get_fw_config(accel_dev);
-	if (!fw_config)
-		return 0;
-
-	/* If dcc, all rings handle compression requests */
-	if (adf_get_service_enabled(accel_dev) == SVC_DCC) {
-		for (i = 0; i < RP_GROUP_COUNT; i++)
-			rps[i] = COMP;
-		goto set_mask;
-	}
-
-	for (i = 0; i < RP_GROUP_COUNT; i++) {
-		switch (fw_config[i].ae_mask) {
-		case ADF_AE_GROUP_0:
-			j = RP_GROUP_0;
-			break;
-		case ADF_AE_GROUP_1:
-			j = RP_GROUP_1;
-			break;
-		default:
-			return 0;
-		}
-
-		switch (fw_config[i].obj) {
-		case ADF_FW_SYM_OBJ:
-			rps[j] = SYM;
-			break;
-		case ADF_FW_ASYM_OBJ:
-			rps[j] = ASYM;
-			break;
-		case ADF_FW_DC_OBJ:
-			rps[j] = COMP;
-			break;
-		default:
-			rps[j] = 0;
-			break;
-		}
-	}
-
-set_mask:
-	ring_to_svc_map = rps[RP_GROUP_0] << ADF_CFG_SERV_RING_PAIR_0_SHIFT |
-			  rps[RP_GROUP_1] << ADF_CFG_SERV_RING_PAIR_1_SHIFT |
-			  rps[RP_GROUP_0] << ADF_CFG_SERV_RING_PAIR_2_SHIFT |
-			  rps[RP_GROUP_1] << ADF_CFG_SERV_RING_PAIR_3_SHIFT;
-
-	return ring_to_svc_map;
-}
-
 static const char *uof_get_name(struct adf_accel_dev *accel_dev, u32 obj_num,
 				const char * const fw_objs[], int num_objs)
 {
@@ -441,6 +386,20 @@ static const char *uof_get_name_420xx(struct adf_accel_dev *accel_dev, u32 obj_n
 	return uof_get_name(accel_dev, obj_num, adf_420xx_fw_objs, num_fw_objs);
 }
 
+static int uof_get_obj_type(struct adf_accel_dev *accel_dev, u32 obj_num)
+{
+	const struct adf_fw_config *fw_config;
+
+	if (obj_num >= uof_get_num_objs(accel_dev))
+		return -EINVAL;
+
+	fw_config = get_fw_config(accel_dev);
+	if (!fw_config)
+		return -EINVAL;
+
+	return fw_config[obj_num].obj;
+}
+
 static u32 uof_get_ae_mask(struct adf_accel_dev *accel_dev, u32 obj_num)
 {
 	const struct adf_fw_config *fw_config;
@@ -504,12 +463,13 @@ void adf_init_hw_data_420xx(struct adf_hw_device_data *hw_data, u32 dev_id)
 	hw_data->fw_mmp_name = ADF_420XX_MMP;
 	hw_data->uof_get_name = uof_get_name_420xx;
 	hw_data->uof_get_num_objs = uof_get_num_objs;
+	hw_data->uof_get_obj_type = uof_get_obj_type;
 	hw_data->uof_get_ae_mask = uof_get_ae_mask;
 	hw_data->get_rp_group = get_rp_group;
 	hw_data->get_ena_thd_mask = get_ena_thd_mask;
 	hw_data->set_msix_rttable = adf_gen4_set_msix_default_rttable;
 	hw_data->set_ssm_wdtimer = adf_gen4_set_ssm_wdtimer;
-	hw_data->get_ring_to_svc_map = get_ring_to_svc_map;
+	hw_data->get_ring_to_svc_map = adf_gen4_get_ring_to_svc_map;
 	hw_data->disable_iov = adf_disable_sriov;
 	hw_data->ring_pair_reset = adf_gen4_ring_pair_reset;
 	hw_data->enable_pm = adf_gen4_enable_pm;
diff --git a/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c b/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
index e171cddf6f02..927506cf271d 100644
--- a/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
@@ -320,61 +320,6 @@ static u32 get_ena_thd_mask_401xx(struct adf_accel_dev *accel_dev, u32 obj_num)
 	}
 }
 
-static u16 get_ring_to_svc_map(struct adf_accel_dev *accel_dev)
-{
-	enum adf_cfg_service_type rps[RP_GROUP_COUNT];
-	const struct adf_fw_config *fw_config;
-	u16 ring_to_svc_map;
-	int i, j;
-
-	fw_config = get_fw_config(accel_dev);
-	if (!fw_config)
-		return 0;
-
-	/* If dcc, all rings handle compression requests */
-	if (adf_get_service_enabled(accel_dev) == SVC_DCC) {
-		for (i = 0; i < RP_GROUP_COUNT; i++)
-			rps[i] = COMP;
-		goto set_mask;
-	}
-
-	for (i = 0; i < RP_GROUP_COUNT; i++) {
-		switch (fw_config[i].ae_mask) {
-		case ADF_AE_GROUP_0:
-			j = RP_GROUP_0;
-			break;
-		case ADF_AE_GROUP_1:
-			j = RP_GROUP_1;
-			break;
-		default:
-			return 0;
-		}
-
-		switch (fw_config[i].obj) {
-		case ADF_FW_SYM_OBJ:
-			rps[j] = SYM;
-			break;
-		case ADF_FW_ASYM_OBJ:
-			rps[j] = ASYM;
-			break;
-		case ADF_FW_DC_OBJ:
-			rps[j] = COMP;
-			break;
-		default:
-			rps[j] = 0;
-			break;
-		}
-	}
-
-set_mask:
-	ring_to_svc_map = rps[RP_GROUP_0] << ADF_CFG_SERV_RING_PAIR_0_SHIFT |
-			  rps[RP_GROUP_1] << ADF_CFG_SERV_RING_PAIR_1_SHIFT |
-			  rps[RP_GROUP_0] << ADF_CFG_SERV_RING_PAIR_2_SHIFT |
-			  rps[RP_GROUP_1] << ADF_CFG_SERV_RING_PAIR_3_SHIFT;
-
-	return ring_to_svc_map;
-}
-
 static const char *uof_get_name(struct adf_accel_dev *accel_dev, u32 obj_num,
 				const char * const fw_objs[], int num_objs)
 {
@@ -407,6 +352,20 @@ static const char *uof_get_name_402xx(struct adf_accel_dev *accel_dev, u32 obj_n
 	return uof_get_name(accel_dev, obj_num, adf_402xx_fw_objs, num_fw_objs);
 }
 
+static int uof_get_obj_type(struct adf_accel_dev *accel_dev, u32 obj_num)
+{
+	const struct adf_fw_config *fw_config;
+
+	if (obj_num >= uof_get_num_objs(accel_dev))
+		return -EINVAL;
+
+	fw_config = get_fw_config(accel_dev);
+	if (!fw_config)
+		return -EINVAL;
+
+	return fw_config[obj_num].obj;
+}
+
 static u32 uof_get_ae_mask(struct adf_accel_dev *accel_dev, u32 obj_num)
 {
 	const struct adf_fw_config *fw_config;
@@ -487,11 +446,12 @@ void adf_init_hw_data_4xxx(struct adf_hw_device_data *hw_data, u32 dev_id)
 		break;
 	}
 	hw_data->uof_get_num_objs = uof_get_num_objs;
+	hw_data->uof_get_obj_type = uof_get_obj_type;
 	hw_data->uof_get_ae_mask = uof_get_ae_mask;
 	hw_data->get_rp_group = get_rp_group;
 	hw_data->set_msix_rttable = adf_gen4_set_msix_default_rttable;
 	hw_data->set_ssm_wdtimer = adf_gen4_set_ssm_wdtimer;
-	hw_data->get_ring_to_svc_map = get_ring_to_svc_map;
+	hw_data->get_ring_to_svc_map = adf_gen4_get_ring_to_svc_map;
 	hw_data->disable_iov = adf_disable_sriov;
 	hw_data->ring_pair_reset = adf_gen4_ring_pair_reset;
 	hw_data->enable_pm = adf_gen4_enable_pm;
diff --git a/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h b/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h
index 0f26aa976c8c..08658c3a01e9 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h
@@ -248,6 +248,7 @@ struct adf_hw_device_data {
 	void (*set_msix_rttable)(struct adf_accel_dev *accel_dev);
 	const char *(*uof_get_name)(struct adf_accel_dev *accel_dev, u32 obj_num);
 	u32 (*uof_get_num_objs)(struct adf_accel_dev *accel_dev);
+	int (*uof_get_obj_type)(struct adf_accel_dev *accel_dev, u32 obj_num);
 	u32 (*uof_get_ae_mask)(struct adf_accel_dev *accel_dev, u32 obj_num);
 	int (*get_rp_group)(struct adf_accel_dev *accel_dev, u32 ae_mask);
 	u32 (*get_ena_thd_mask)(struct adf_accel_dev *accel_dev, u32 obj_num);
diff --git a/drivers/crypto/intel/qat/qat_common/adf_gen4_hw_data.c b/drivers/crypto/intel/qat/qat_common/adf_gen4_hw_data.c
index f752653ccb47..d28e1921940a 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_gen4_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_gen4_hw_data.c
@@ -4,6 +4,7 @@
 #include "adf_accel_devices.h"
 #include "adf_cfg_services.h"
 #include "adf_common_drv.h"
+#include "adf_fw_config.h"
 #include "adf_gen4_hw_data.h"
 #include "adf_gen4_pm.h"
 
@@ -433,3 +434,58 @@ int adf_gen4_init_thd2arb_map(struct adf_accel_dev *accel_dev)
 	return 0;
 }
 EXPORT_SYMBOL_GPL(adf_gen4_init_thd2arb_map);
+
+u16 adf_gen4_get_ring_to_svc_map(struct adf_accel_dev *accel_dev)
+{
+	struct adf_hw_device_data *hw_data = GET_HW_DATA(accel_dev);
+	enum adf_cfg_service_type rps[RP_GROUP_COUNT] = { };
+	unsigned int ae_mask, start_id, worker_obj_cnt, i;
+	u16 ring_to_svc_map;
+	int rp_group;
+
+	if (!hw_data->get_rp_group || !hw_data->uof_get_ae_mask ||
+	    !hw_data->uof_get_obj_type || !hw_data->uof_get_num_objs)
+		return 0;
+
+	/* If dcc, all rings handle compression requests */
+	if (adf_get_service_enabled(accel_dev) == SVC_DCC) {
+		for (i = 0; i < RP_GROUP_COUNT; i++)
+			rps[i] = COMP;
+		goto set_mask;
+	}
+
+	worker_obj_cnt = hw_data->uof_get_num_objs(accel_dev) -
+			 ADF_GEN4_ADMIN_ACCELENGINES;
+	start_id = worker_obj_cnt - RP_GROUP_COUNT;
+
+	for (i = start_id; i < worker_obj_cnt; i++) {
+		ae_mask = hw_data->uof_get_ae_mask(accel_dev, i);
+		rp_group = hw_data->get_rp_group(accel_dev, ae_mask);
+		if (rp_group >= RP_GROUP_COUNT || rp_group < RP_GROUP_0)
+			return 0;
+
+		switch (hw_data->uof_get_obj_type(accel_dev, i)) {
+		case ADF_FW_SYM_OBJ:
+			rps[rp_group] = SYM;
+			break;
+		case ADF_FW_ASYM_OBJ:
+			rps[rp_group] = ASYM;
+			break;
+		case ADF_FW_DC_OBJ:
+			rps[rp_group] = COMP;
+			break;
+		default:
+			rps[rp_group] = 0;
+			break;
+		}
+	}
+
+set_mask:
+	ring_to_svc_map = rps[RP_GROUP_0] << ADF_CFG_SERV_RING_PAIR_0_SHIFT |
+			  rps[RP_GROUP_1] << ADF_CFG_SERV_RING_PAIR_1_SHIFT |
+			  rps[RP_GROUP_0] << ADF_CFG_SERV_RING_PAIR_2_SHIFT |
+			  rps[RP_GROUP_1] << ADF_CFG_SERV_RING_PAIR_3_SHIFT;
+
+	return ring_to_svc_map;
+}
+EXPORT_SYMBOL_GPL(adf_gen4_get_ring_to_svc_map);
diff --git a/drivers/crypto/intel/qat/qat_common/adf_gen4_hw_data.h b/drivers/crypto/intel/qat/qat_common/adf_gen4_hw_data.h
index 7d8a774cadc8..c6e80df5a85a 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_gen4_hw_data.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_gen4_hw_data.h
@@ -235,5 +235,6 @@ int adf_gen4_ring_pair_reset(struct adf_accel_dev *accel_dev, u32 bank_number);
 void adf_gen4_set_msix_default_rttable(struct adf_accel_dev *accel_dev);
 void adf_gen4_set_ssm_wdtimer(struct adf_accel_dev *accel_dev);
 int adf_gen4_init_thd2arb_map(struct adf_accel_dev *accel_dev);
+u16 adf_gen4_get_ring_to_svc_map(struct adf_accel_dev *accel_dev);
 
 #endif
-- 
2.43.0

