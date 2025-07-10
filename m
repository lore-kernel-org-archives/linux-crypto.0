Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD6DC25BEF0
	for <linux-crypto@vger.kernel.org>; Thu, 10 Jul 2025 13:34:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752154444; cv=none; b=hojE+7HJUJXDOPaIiEoBX6b2Dn7zaK7d6nu5iQq165jde9H2mQKNXZezS4QTexm45GueZ4dna3S24R/oyZiOwezrSKVLTtRkFm5xKKQN6wxaaEW+O4gk7rbgyi5tuDFTQmBwWax0GEmubrE9IafpJFpBXC1ORCzfnMB/Y+Hpi34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752154444; c=relaxed/simple;
	bh=zSBnuxCAy+NocoV5cmEw2q4gjj2T49IuEuk4b+qVLuI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=iYyd2WDQlphSxN67O4MoYDDlG+EDyHECSHG2hsgMPpZH7ZaerlPoxcoBkp9j13v42xK2eeGpVZb09jabGWWkQQStTQTwb3suvYvk4MMlaxtNjbvmDll6dvK3x9Cd2LrjgVnSvMFs2f+mTVRGtYFyyyxlXgbEuSWxdBRtBl94lSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TtSz6R4F; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TtSz6R4F"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752154443; x=1783690443;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zSBnuxCAy+NocoV5cmEw2q4gjj2T49IuEuk4b+qVLuI=;
  b=TtSz6R4FtIxhUhG+zS7yr7NOdTSFCFsc0ksK4AJkOIIY3PqSddONC4Sg
   4lGnNXjCVGoIIjX1LWLMv84n8z+87O2F+2DBsm4opbXgj2QKqj32wAJTY
   ZV6g1oeg9GNFxnaJanBZYRaYRNg6B0rcppHGceg6cE87rDN7fuYsTAdrj
   I3GIGyxQSTJQz2VpD4R/0537C3gWfUoIigjj0ryABx6cAIC5IszVejpXF
   JzcLqfY+jyctapmBithdsAeGqBsfD7ACxLlKKbjz2d/dpqyRXoGQiiIuk
   GEv7dqoX9GSkZWTb9LRBZiQvy2vy+73+e/Yw29tjGOkZJoYwfFojfNTOi
   A==;
X-CSE-ConnectionGUID: QJW56GbrS7ick6b8Ttr7xQ==
X-CSE-MsgGUID: puTs+wiWTsGtv0e6sAXtMg==
X-IronPort-AV: E=McAfee;i="6800,10657,11490"; a="58241846"
X-IronPort-AV: E=Sophos;i="6.16,300,1744095600"; 
   d="scan'208";a="58241846"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2025 06:34:02 -0700
X-CSE-ConnectionGUID: TKShfVWmTf2rpPdcfB6BCA==
X-CSE-MsgGUID: pAJ9DpLuTqGr+G7CMfSyQw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,300,1744095600"; 
   d="scan'208";a="155494661"
Received: from t21-qat.iind.intel.com ([10.49.15.35])
  by orviesa006.jf.intel.com with ESMTP; 10 Jul 2025 06:34:01 -0700
From: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com
Subject: [PATCH 6/8] crypto: qat - add get_svc_slice_cnt() in device data structure
Date: Thu, 10 Jul 2025 14:33:45 +0100
Message-Id: <20250710133347.566310-7-suman.kumar.chakraborty@intel.com>
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

Enhance the adf_hw_device_data structure by introducing a new callback
function get_svc_slice_cnt(), which provides a mechanism to query the
total number of accelerator available on the device for a specific
service.

Implement adf_gen4_get_svc_slice_cnt() for QAT GEN4 devices to support this
new interface. This function returns the total accelerator count for a
specific service.

Co-developed-by: George Abraham P <george.abraham.p@intel.com>
Signed-off-by: George Abraham P <george.abraham.p@intel.com>
Signed-off-by: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 .../intel/qat/qat_420xx/adf_420xx_hw_data.c    |  1 +
 .../intel/qat/qat_4xxx/adf_4xxx_hw_data.c      |  1 +
 .../intel/qat/qat_common/adf_accel_devices.h   |  2 ++
 .../intel/qat/qat_common/adf_gen4_hw_data.c    | 18 ++++++++++++++++++
 .../intel/qat/qat_common/adf_gen4_hw_data.h    |  2 ++
 drivers/crypto/intel/qat/qat_common/adf_rl.c   | 16 ++--------------
 6 files changed, 26 insertions(+), 14 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c b/drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c
index 67a1c1d8e23e..53fa91d577ed 100644
--- a/drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c
@@ -468,6 +468,7 @@ void adf_init_hw_data_420xx(struct adf_hw_device_data *hw_data, u32 dev_id)
 	hw_data->num_hb_ctrs = ADF_NUM_HB_CNT_PER_AE;
 	hw_data->clock_frequency = ADF_420XX_AE_FREQ;
 	hw_data->services_supported = adf_gen4_services_supported;
+	hw_data->get_svc_slice_cnt = adf_gen4_get_svc_slice_cnt;
 
 	adf_gen4_set_err_mask(&hw_data->dev_err_mask);
 	adf_gen4_init_hw_csr_ops(&hw_data->csr_ops);
diff --git a/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c b/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
index 9b728dba048b..740f68a36ac5 100644
--- a/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
@@ -462,6 +462,7 @@ void adf_init_hw_data_4xxx(struct adf_hw_device_data *hw_data, u32 dev_id)
 	hw_data->num_hb_ctrs = ADF_NUM_HB_CNT_PER_AE;
 	hw_data->clock_frequency = ADF_4XXX_AE_FREQ;
 	hw_data->services_supported = adf_gen4_services_supported;
+	hw_data->get_svc_slice_cnt = adf_gen4_get_svc_slice_cnt;
 
 	adf_gen4_set_err_mask(&hw_data->dev_err_mask);
 	adf_gen4_init_hw_csr_ops(&hw_data->csr_ops);
diff --git a/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h b/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h
index f76e0f6c66ae..9fe3239f0114 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h
@@ -319,6 +319,8 @@ struct adf_hw_device_data {
 	u32 (*get_ena_thd_mask)(struct adf_accel_dev *accel_dev, u32 obj_num);
 	int (*dev_config)(struct adf_accel_dev *accel_dev);
 	bool (*services_supported)(unsigned long mask);
+	u32 (*get_svc_slice_cnt)(struct adf_accel_dev *accel_dev,
+				 enum adf_base_services svc);
 	struct adf_pfvf_ops pfvf_ops;
 	struct adf_hw_csr_ops csr_ops;
 	struct adf_dc_ops dc_ops;
diff --git a/drivers/crypto/intel/qat/qat_common/adf_gen4_hw_data.c b/drivers/crypto/intel/qat/qat_common/adf_gen4_hw_data.c
index 5e4b45c3fabe..349fdb323763 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_gen4_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_gen4_hw_data.c
@@ -580,3 +580,21 @@ void adf_gen4_init_num_svc_aes(struct adf_rl_hw_data *device_data)
 	device_data->svc_ae_mask[SVC_DECOMP] = 0;
 }
 EXPORT_SYMBOL_GPL(adf_gen4_init_num_svc_aes);
+
+u32 adf_gen4_get_svc_slice_cnt(struct adf_accel_dev *accel_dev,
+			       enum adf_base_services svc)
+{
+	struct adf_rl_hw_data *device_data = &accel_dev->hw_device->rl_data;
+
+	switch (svc) {
+	case SVC_SYM:
+		return device_data->slices.cph_cnt;
+	case SVC_ASYM:
+		return device_data->slices.pke_cnt;
+	case SVC_DC:
+		return device_data->slices.dcpr_cnt;
+	default:
+		return 0;
+	}
+}
+EXPORT_SYMBOL_GPL(adf_gen4_get_svc_slice_cnt);
diff --git a/drivers/crypto/intel/qat/qat_common/adf_gen4_hw_data.h b/drivers/crypto/intel/qat/qat_common/adf_gen4_hw_data.h
index 7fa203071c01..cd26b6724c43 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_gen4_hw_data.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_gen4_hw_data.h
@@ -176,5 +176,7 @@ void adf_gen4_bank_drain_finish(struct adf_accel_dev *accel_dev,
 bool adf_gen4_services_supported(unsigned long service_mask);
 void adf_gen4_init_dc_ops(struct adf_dc_ops *dc_ops);
 void adf_gen4_init_num_svc_aes(struct adf_rl_hw_data *device_data);
+u32 adf_gen4_get_svc_slice_cnt(struct adf_accel_dev *accel_dev,
+			       enum adf_base_services svc);
 
 #endif
diff --git a/drivers/crypto/intel/qat/qat_common/adf_rl.c b/drivers/crypto/intel/qat/qat_common/adf_rl.c
index 77465ab6702c..c6a54e465931 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_rl.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_rl.c
@@ -529,21 +529,9 @@ u32 adf_rl_calculate_slice_tokens(struct adf_accel_dev *accel_dev, u32 sla_val,
 	if (!sla_val)
 		return 0;
 
+	/* Handle generation specific slice count adjustment */
 	avail_slice_cycles = hw_data->clock_frequency;
-
-	switch (svc_type) {
-	case SVC_ASYM:
-		avail_slice_cycles *= device_data->slices.pke_cnt;
-		break;
-	case SVC_SYM:
-		avail_slice_cycles *= device_data->slices.cph_cnt;
-		break;
-	case SVC_DC:
-		avail_slice_cycles *= device_data->slices.dcpr_cnt;
-		break;
-	default:
-		break;
-	}
+	avail_slice_cycles *= hw_data->get_svc_slice_cnt(accel_dev, svc_type);
 
 	do_div(avail_slice_cycles, device_data->scan_interval);
 	allocated_tokens = avail_slice_cycles * sla_val;
-- 
2.40.1

