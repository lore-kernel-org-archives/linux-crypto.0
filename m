Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA9704A3D55
	for <linux-crypto@vger.kernel.org>; Mon, 19 Oct 2026 11:07:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792408070; cv=none; b=qXSbBukn5xQGgtSpj+FZoRNGxmJTn3CVK6mkXEMVkUo/iUxM7HQsO3z/caByhZD8ul5f1ig7Ww9/JvOso5p2VP3teGE2BiSP+CMhDvnJeT5UOwKbhPw8wCaFCyRs/v/xU5RZUiopR3dOSLYTVB1t66uHjg3a5rnf9ZlpjppoCk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792408070; c=relaxed/simple;
	bh=m4rI8Ex3FZOpXU5eQ2JmBeHZTKaC2QzhRQ2pwsjdTjA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FNkOqLV52rG3gwoIAWdrMXEpKxgaFfglndGbkv5hGU1UrzNytvPsiY0mAGEW6/LtiyhGa9fdg6skWQCF3xo1HLCH4f5lGN49oYBDuihz4BAOtSY3ckSuDBD/Gv/LtkcwRCbkStKhwY18wtg+WEPFx6ihLsDbGEYVHfZLssPV7LY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FBM6HdCe; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FBM6HdCe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792408069; x=1823944069;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=m4rI8Ex3FZOpXU5eQ2JmBeHZTKaC2QzhRQ2pwsjdTjA=;
  b=FBM6HdCeVP1z4AaIDu9cOVTfdpo0yMjD2nWIpkRysVlKtHSGmTqYjT5g
   MpGXnYkoeP+AkZAJhd/1Ana7sx1tjBa6xiegtLqUBtWyThaT7wS74GJ3q
   dlrIn0V1/sPbCDzZkQs9mMTMjSvFZ1tY4KHnSNGYUeb2Uv9eQDV1a5RFa
   dQ95iENik4AmgPRQukWK82quyIRXiqABwwkcHu6/XH5gXZAfPiW1TjgI2
   XYOAw+HkfAFjicFM7pH38QmvF7MIhl/EbzD1/qACc1nOYJwxw3UVryXyQ
   Jn3fQ7SM57ySMBp3zj7RbE3ehRuQ3O8Ow773PwlYBZDb/ig8mWndVtlg/
   A==;
X-CSE-ConnectionGUID: bnQDvE42RPio36utZjqBkg==
X-CSE-MsgGUID: DiTG43XwTQW+EMaNQTVgaA==
X-IronPort-AV: E=McAfee;i="6800,10657,11939"; a="1088252"
X-IronPort-AV: E=Sophos;i="6.27,167,1787036400"; 
   d="scan'208";a="1088252"
Received: from fmviesa012.fm.intel.com ([10.60.135.152])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2026 04:07:49 -0700
X-CSE-ConnectionGUID: yeF2JfxiSHGTuGUvc7AxjA==
X-CSE-MsgGUID: yz2roeEDRyq4Prgp7U9Dqw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,167,1787036400"; 
   d="scan'208";a="4267862"
Received: from indlpbc065983.iind.intel.com ([10.49.120.87])
  by fmviesa012.fm.intel.com with ESMTP; 19 Oct 2026 04:07:47 -0700
From: George Abraham P <george.abraham.p@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	George Abraham P <george.abraham.p@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Ahsan Atta <ahsan.atta@intel.com>
Subject: [PATCH 2/3] crypto: qat - fix rate limiting for QAT GEN6 wireless
Date: Mon, 19 Oct 2026 16:33:55 +0530
Message-Id: <20261019110356.3781949-3-george.abraham.p@intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20261019110356.3781949-1-george.abraham.p@intel.com>
References: <20261019110356.3781949-1-george.abraham.p@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Rate limiting initializes QAT GEN6 wireless devices with the same
parameters used for the default configuration. Wireless mode supports
only the symmetric service, uses WCP (wireless ciphers) rather than CPH
(cipher) slices and loads firmware objects from adf_wcy_fw_config
instead of adf_default_fw_config. This results in incorrect rate
limiting parameters: the symmetric slice count is taken from the CPH
slices, and throughput limits are set for services that are not
available. In addition, init_num_svc_aes() derives the symmetric accel
engine count from adf_default_fw_config, where ADF_FW_CY_OBJ is loaded on
a single accel engine group, instead of the two groups used by
ADF_FW_WCY_OBJ in wireless mode, undercounting the AE cycle budget for
symmetric SLAs.

Store the firmware-reported WCP slice count in rl_slice_cnt and use it
as the symmetric slice count in wireless mode. In wireless mode, set
only the symmetric maximum throughput, using a wireless-specific value,
and compute the number of accel engines for the symmetric service with
the new function init_num_wcy_svc_aes(). This looks up ADF_FW_WCY_OBJ in
adf_wcy_fw_config and accumulates the ae_mask across all matching
entries, since that object is loaded on two accel engine groups
(ADF_AE_GROUP_0 and ADF_AE_GROUP_1).

Pass hw_data to adf_gen6_init_rl_data() so that it can detect wireless
mode, and report zero slices for services other than symmetric in that
mode.

Fixes: 464da0bf19fd ("crypto: qat - add wireless mode support for QAT GEN6")
Signed-off-by: George Abraham P <george.abraham.p@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Ahsan Atta <ahsan.atta@intel.com>
---
 .../intel/qat/qat_6xxx/adf_6xxx_hw_data.c     | 38 +++++++++++++++----
 .../intel/qat/qat_6xxx/adf_6xxx_hw_data.h     |  1 +
 drivers/crypto/intel/qat/qat_common/adf_rl.h  |  1 +
 .../intel/qat/qat_common/adf_rl_admin.c       |  1 +
 4 files changed, 33 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_6xxx/adf_6xxx_hw_data.c b/drivers/crypto/intel/qat/qat_6xxx/adf_6xxx_hw_data.c
index ca9bc5dccf67..27c813d1c6c3 100644
--- a/drivers/crypto/intel/qat/qat_6xxx/adf_6xxx_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_6xxx/adf_6xxx_hw_data.c
@@ -573,6 +573,19 @@ static int adf_gen6_init_thd2arb_map(struct adf_accel_dev *accel_dev)
 	return 0;
 }
 
+static void init_num_wcy_svc_aes(struct adf_rl_hw_data *device_data)
+{
+	u32 ae_mask = 0;
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(adf_wcy_fw_config); i++) {
+		if (adf_wcy_fw_config[i].obj == ADF_FW_WCY_OBJ)
+			ae_mask |= adf_wcy_fw_config[i].ae_mask;
+	}
+
+	device_data->svc_ae_mask[SVC_SYM] = hweight32(ae_mask);
+}
+
 static void init_num_svc_aes(struct adf_rl_hw_data *device_data)
 {
 	enum adf_fw_objs obj_type, obj_iter;
@@ -608,6 +621,9 @@ static u32 adf_gen6_get_svc_slice_cnt(struct adf_accel_dev *accel_dev,
 {
 	struct adf_rl_hw_data *device_data = &accel_dev->hw_device->rl_data;
 
+	if (adf_6xxx_is_wcy(GET_HW_DATA(accel_dev)))
+		return (svc == SVC_SYM) ? device_data->slices.wcp_cnt : 0;
+
 	switch (svc) {
 	case SVC_SYM:
 		return device_data->slices.cph_cnt;
@@ -973,8 +989,10 @@ static void adf_gen6_init_kpt(struct adf_kpt_hw_data *kpt_data)
 	kpt_data->user_input.swk_cnt_per_pasid = ADF_6XXX_KPT_DEFAULT_SWK_CNT_PER_PASID;
 }
 
-static void adf_gen6_init_rl_data(struct adf_rl_hw_data *rl_data)
+static void adf_gen6_init_rl_data(struct adf_hw_device_data *hw_data)
 {
+	struct adf_rl_hw_data *rl_data = &hw_data->rl_data;
+
 	rl_data->pciout_tb_offset = ADF_GEN6_RL_TOKEN_PCIEOUT_BUCKET_OFFSET;
 	rl_data->pciin_tb_offset = ADF_GEN6_RL_TOKEN_PCIEIN_BUCKET_OFFSET;
 	rl_data->r2l_offset = ADF_GEN6_RL_R2L_OFFSET;
@@ -982,14 +1000,18 @@ static void adf_gen6_init_rl_data(struct adf_rl_hw_data *rl_data)
 	rl_data->c2s_offset = ADF_GEN6_RL_C2S_OFFSET;
 	rl_data->pcie_scale_div = ADF_6XXX_RL_PCIE_SCALE_FACTOR_DIV;
 	rl_data->pcie_scale_mul = ADF_6XXX_RL_PCIE_SCALE_FACTOR_MUL;
-	rl_data->max_tp[SVC_ASYM] = ADF_6XXX_RL_MAX_TP_ASYM;
-	rl_data->max_tp[SVC_SYM] = ADF_6XXX_RL_MAX_TP_SYM;
-	rl_data->max_tp[SVC_DC] = ADF_6XXX_RL_MAX_TP_DC;
-	rl_data->max_tp[SVC_DECOMP] = ADF_6XXX_RL_MAX_TP_DECOMP;
 	rl_data->scan_interval = ADF_6XXX_RL_SCANS_PER_SEC;
 	rl_data->scale_ref = ADF_6XXX_RL_SLICE_REF;
-
-	init_num_svc_aes(rl_data);
+	if (adf_6xxx_is_wcy(hw_data)) {
+		rl_data->max_tp[SVC_SYM] = ADF_6XXX_RL_MAX_TP_WCY_SYM;
+		init_num_wcy_svc_aes(rl_data);
+	} else {
+		rl_data->max_tp[SVC_ASYM] = ADF_6XXX_RL_MAX_TP_ASYM;
+		rl_data->max_tp[SVC_SYM] = ADF_6XXX_RL_MAX_TP_SYM;
+		rl_data->max_tp[SVC_DC] = ADF_6XXX_RL_MAX_TP_DC;
+		rl_data->max_tp[SVC_DECOMP] = ADF_6XXX_RL_MAX_TP_DECOMP;
+		init_num_svc_aes(rl_data);
+	}
 }
 
 static void adf_gen6_init_services_supported(struct adf_hw_device_data *hw_data)
@@ -1067,7 +1089,7 @@ void adf_init_hw_data_6xxx(struct adf_hw_device_data *hw_data)
 	adf_gen6_init_vf_mig_ops(&hw_data->vfmig_ops);
 	adf_gen6_init_ras_ops(&hw_data->ras_ops);
 	adf_gen6_init_tl_data(&hw_data->tl_data);
-	adf_gen6_init_rl_data(&hw_data->rl_data);
+	adf_gen6_init_rl_data(hw_data);
 	adf_gen6_init_anti_rb(&hw_data->anti_rb_data);
 	adf_gen6_init_kpt(&hw_data->kpt_data);
 }
diff --git a/drivers/crypto/intel/qat/qat_6xxx/adf_6xxx_hw_data.h b/drivers/crypto/intel/qat/qat_6xxx/adf_6xxx_hw_data.h
index 2719ddbc1e05..2bce8a3b0fcc 100644
--- a/drivers/crypto/intel/qat/qat_6xxx/adf_6xxx_hw_data.h
+++ b/drivers/crypto/intel/qat/qat_6xxx/adf_6xxx_hw_data.h
@@ -158,6 +158,7 @@
 #define ADF_6XXX_RL_SCANS_PER_SEC		954
 #define ADF_6XXX_RL_MAX_TP_ASYM			173750UL
 #define ADF_6XXX_RL_MAX_TP_SYM			95000UL
+#define ADF_6XXX_RL_MAX_TP_WCY_SYM		61000UL
 #define ADF_6XXX_RL_MAX_TP_DC			40000UL
 #define ADF_6XXX_RL_MAX_TP_DECOMP		40000UL
 #define ADF_6XXX_RL_SLICE_REF			1000UL
diff --git a/drivers/crypto/intel/qat/qat_common/adf_rl.h b/drivers/crypto/intel/qat/qat_common/adf_rl.h
index c1f3f9a51195..c8620c72cc97 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_rl.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_rl.h
@@ -69,6 +69,7 @@ struct rl_slice_cnt {
 	u8 pke_cnt;
 	u8 cph_cnt;
 	u8 cpr_cnt;
+	u8 wcp_cnt;
 };
 
 struct adf_rl_interface_data {
diff --git a/drivers/crypto/intel/qat/qat_common/adf_rl_admin.c b/drivers/crypto/intel/qat/qat_common/adf_rl_admin.c
index 4a3e0591fdba..d2bb4cc95ecf 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_rl_admin.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_rl_admin.c
@@ -64,6 +64,7 @@ int adf_rl_send_admin_init_msg(struct adf_accel_dev *accel_dev,
 	/* For symmetric crypto, slice tokens are relative to the UCS slice */
 	slices_int->cph_cnt = slices_resp.ucs_cnt;
 	slices_int->cpr_cnt = slices_resp.cpr_cnt;
+	slices_int->wcp_cnt = slices_resp.wcp_cnt;
 
 	return 0;
 }
-- 
2.40.1

