Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB873259C85
	for <linux-crypto@vger.kernel.org>; Thu, 10 Jul 2025 13:34:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752154442; cv=none; b=tmKrNeFvLARI6wur2Phv8CoNxbbdPdGqVF4bS9H5PK2JfGOebQ415/Sg4+KfHo+boZIuilmVVJk5PyeYxqQOlpwhCmYa+lgLVFV7R6FgqUx4Mw5877Fk/yxC0sGTxscLkALpZbE3l0Z2eLuu5cPzD6MK2R9pnP+u0NCXzwJTG5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752154442; c=relaxed/simple;
	bh=pyOzco7SKcnSbyggZW+0wUWwJXF287JJgoyZ5KfXipc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=XyzdqlS7G1YxHNv6uPb/lCa/47VE9RRTBV+VBrTA2F9UnMPVRlWBCyBMd9KRKvf5o1ZKa5jPubXxjIcLJOCXYNFXwn5cJWEHsl5uQzB0zHQIG6rOvHAYRWUmOrf6PZ4bpB3SlG28JQPBQSgIYveqvKl6mU85z/TPZUb2NTscYFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=H7TZRYNt; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="H7TZRYNt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752154441; x=1783690441;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pyOzco7SKcnSbyggZW+0wUWwJXF287JJgoyZ5KfXipc=;
  b=H7TZRYNtaR/oTPKHJDPcVzkoSzhyHxTd2zgmLkxa7nG7E0IGaObqy6UU
   CXmIx0v4oOTBKHlpzqLCYyUDui9sYu7E2G+6OyQXgD7IcN1hwcyU/7zY3
   RHWR73vkG9RdpjwWE3+sBLYYguKgqn0YT4dj6lk8GoJtMwF0I54/oiJEM
   RnZ60FCyUWjRVXw9cotfPRpS/wD2GpBDZ9K0/v2XMUw5rtTAekiUZlZMo
   SDakd02PrUaEVsZqrrhpPhqtWXguWEEp6aiCuSwoLbmRUgKJdl43f4zu/
   YeimLK8W/0EY99bJF79Gs6VYT/sDVvH5Av16BoeRbLAyfEX/b10VqrU0Y
   w==;
X-CSE-ConnectionGUID: XHfbZeLDT1u1V5qMvlJiog==
X-CSE-MsgGUID: FJSjoJEAQLu8118Y4s+KiQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11490"; a="58241844"
X-IronPort-AV: E=Sophos;i="6.16,300,1744095600"; 
   d="scan'208";a="58241844"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2025 06:34:00 -0700
X-CSE-ConnectionGUID: R0QylnRvTDSX+d5HOz7pqA==
X-CSE-MsgGUID: NMkA10RCTdKDWTZuR+sapw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,300,1744095600"; 
   d="scan'208";a="155494657"
Received: from t21-qat.iind.intel.com ([10.49.15.35])
  by orviesa006.jf.intel.com with ESMTP; 10 Jul 2025 06:33:59 -0700
From: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com
Subject: [PATCH 5/8] crypto: qat - add adf_rl_get_num_svc_aes() in rate limiting
Date: Thu, 10 Jul 2025 14:33:44 +0100
Message-Id: <20250710133347.566310-6-suman.kumar.chakraborty@intel.com>
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

Enhance the rate limiting (RL) infrastructure by adding
adf_rl_get_num_svc_aes() which can be used to fetch the number of engines
associated with the service type. Expand the structure adf_rl_hw_data
with an array that contains the number of AEs per service.

Implement adf_gen4_init_num_svc_aes() for QAT GEN4 devices to calculate
the total number of acceleration engines dedicated to a specific service.

Signed-off-by: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 .../intel/qat/qat_420xx/adf_420xx_hw_data.c   |  2 ++
 .../intel/qat/qat_4xxx/adf_4xxx_hw_data.c     |  2 ++
 .../intel/qat/qat_common/adf_gen4_hw_data.c   | 22 +++++++++++++++++++
 .../intel/qat/qat_common/adf_gen4_hw_data.h   |  1 +
 drivers/crypto/intel/qat/qat_common/adf_rl.c  | 13 ++++++++++-
 drivers/crypto/intel/qat/qat_common/adf_rl.h  |  1 +
 6 files changed, 40 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c b/drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c
index 32bb9e1826d2..67a1c1d8e23e 100644
--- a/drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c
@@ -301,6 +301,8 @@ static void adf_init_rl_data(struct adf_rl_hw_data *rl_data)
 	rl_data->max_tp[SVC_DC] = ADF_420XX_RL_MAX_TP_DC;
 	rl_data->scan_interval = ADF_420XX_RL_SCANS_PER_SEC;
 	rl_data->scale_ref = ADF_420XX_RL_SLICE_REF;
+
+	adf_gen4_init_num_svc_aes(rl_data);
 }
 
 static int get_rp_group(struct adf_accel_dev *accel_dev, u32 ae_mask)
diff --git a/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c b/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
index f917cc9db09d..9b728dba048b 100644
--- a/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
@@ -227,6 +227,8 @@ static void adf_init_rl_data(struct adf_rl_hw_data *rl_data)
 	rl_data->max_tp[SVC_DC] = ADF_4XXX_RL_MAX_TP_DC;
 	rl_data->scan_interval = ADF_4XXX_RL_SCANS_PER_SEC;
 	rl_data->scale_ref = ADF_4XXX_RL_SLICE_REF;
+
+	adf_gen4_init_num_svc_aes(rl_data);
 }
 
 static u32 uof_get_num_objs(struct adf_accel_dev *accel_dev)
diff --git a/drivers/crypto/intel/qat/qat_common/adf_gen4_hw_data.c b/drivers/crypto/intel/qat/qat_common/adf_gen4_hw_data.c
index 3103755e416e..5e4b45c3fabe 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_gen4_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_gen4_hw_data.c
@@ -558,3 +558,25 @@ void adf_gen4_init_dc_ops(struct adf_dc_ops *dc_ops)
 	dc_ops->build_decomp_block = adf_gen4_build_decomp_block;
 }
 EXPORT_SYMBOL_GPL(adf_gen4_init_dc_ops);
+
+void adf_gen4_init_num_svc_aes(struct adf_rl_hw_data *device_data)
+{
+	struct adf_hw_device_data *hw_data;
+	unsigned int i;
+	u32 ae_cnt;
+
+	hw_data = container_of(device_data, struct adf_hw_device_data, rl_data);
+	ae_cnt = hweight32(hw_data->get_ae_mask(hw_data));
+	if (!ae_cnt)
+		return;
+
+	for (i = 0; i < SVC_BASE_COUNT; i++)
+		device_data->svc_ae_mask[i] = ae_cnt - 1;
+
+	/*
+	 * The decompression service is not supported on QAT GEN4 devices.
+	 * Therefore, set svc_ae_mask to 0.
+	 */
+	device_data->svc_ae_mask[SVC_DECOMP] = 0;
+}
+EXPORT_SYMBOL_GPL(adf_gen4_init_num_svc_aes);
diff --git a/drivers/crypto/intel/qat/qat_common/adf_gen4_hw_data.h b/drivers/crypto/intel/qat/qat_common/adf_gen4_hw_data.h
index 7f2b9cb0fe60..7fa203071c01 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_gen4_hw_data.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_gen4_hw_data.h
@@ -175,5 +175,6 @@ void adf_gen4_bank_drain_finish(struct adf_accel_dev *accel_dev,
 				u32 bank_number);
 bool adf_gen4_services_supported(unsigned long service_mask);
 void adf_gen4_init_dc_ops(struct adf_dc_ops *dc_ops);
+void adf_gen4_init_num_svc_aes(struct adf_rl_hw_data *device_data);
 
 #endif
diff --git a/drivers/crypto/intel/qat/qat_common/adf_rl.c b/drivers/crypto/intel/qat/qat_common/adf_rl.c
index 926975539740..77465ab6702c 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_rl.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_rl.c
@@ -552,6 +552,17 @@ u32 adf_rl_calculate_slice_tokens(struct adf_accel_dev *accel_dev, u32 sla_val,
 	return allocated_tokens;
 }
 
+static u32 adf_rl_get_num_svc_aes(struct adf_accel_dev *accel_dev,
+				  enum adf_base_services svc)
+{
+	struct adf_rl_hw_data *device_data = &accel_dev->hw_device->rl_data;
+
+	if (svc >= SVC_BASE_COUNT)
+		return 0;
+
+	return device_data->svc_ae_mask[svc];
+}
+
 u32 adf_rl_calculate_ae_cycles(struct adf_accel_dev *accel_dev, u32 sla_val,
 			       enum adf_base_services svc_type)
 {
@@ -563,7 +574,7 @@ u32 adf_rl_calculate_ae_cycles(struct adf_accel_dev *accel_dev, u32 sla_val,
 		return 0;
 
 	avail_ae_cycles = hw_data->clock_frequency;
-	avail_ae_cycles *= hw_data->get_num_aes(hw_data) - 1;
+	avail_ae_cycles *= adf_rl_get_num_svc_aes(accel_dev, svc_type);
 	do_div(avail_ae_cycles, device_data->scan_interval);
 
 	sla_val *= device_data->max_tp[svc_type];
diff --git a/drivers/crypto/intel/qat/qat_common/adf_rl.h b/drivers/crypto/intel/qat/qat_common/adf_rl.h
index dee7f0c81906..59f885916157 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_rl.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_rl.h
@@ -89,6 +89,7 @@ struct adf_rl_hw_data {
 	u32 pcie_scale_div;
 	u32 dcpr_correction;
 	u32 max_tp[RL_ROOT_MAX];
+	u32 svc_ae_mask[SVC_BASE_COUNT];
 	struct rl_slice_cnt slices;
 };
 
-- 
2.40.1

