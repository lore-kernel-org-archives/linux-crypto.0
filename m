Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA373272E5C
	for <linux-crypto@vger.kernel.org>; Fri, 25 Jul 2025 09:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753434582; cv=none; b=rEyARy2k+mK+qs7D30CPptw8qHVUBKuU2ValWqydU0gLj51bZSMTFvIHQgvPcfwwy+xJJg0vRylINrEoU7mZIzcniX4IF0kaJCiumEQ2DxqdekV6wQlPCNlO8tS24i8A8RH/4jDiLVjJQGiqsFTNUhy7mcd9b4AlTpF9ELPpp6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753434582; c=relaxed/simple;
	bh=wz0mg6b+WwcozUVho21cG0uz2gWUIGTLDYjvGer3Jto=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Bt4JX21+yWgWRv/uOLaIEZy7n9DvKVUm97TbxPxeRDe8jhL2VMS99rkF+A8JGUJJNE5I7/FvzsdkLBziYs97AthJX0XNMdQnxUUBh0gSgH3bV8VCJ73HGQRBSSyNW4gNmfYdFfrihOeXkKiU0r5JqSAvyu3CxreKHj7wN0ysgYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WpXrfVDc; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WpXrfVDc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753434581; x=1784970581;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wz0mg6b+WwcozUVho21cG0uz2gWUIGTLDYjvGer3Jto=;
  b=WpXrfVDcgE/h5SdyMprc5W1CviQsKcaWHcRJ6RvCweyuz9GUol11vpL6
   enx76VYIXYnGx6r5IXrndrHpvnU1I8rsm+tMEeMmqT0HsWuGD3f02y0D6
   lJBAlAFg17WmRKOWduYSFMRMkOz8m8yduv6kVUhAZybtYgsgFMK99NO1v
   DSDgS0s3A1U//tVgh6UifLK2b0o3riG2pqyh+Fj4oIx610aYvoo3nhuFl
   feoniN19WHAWeMVZ34Mt5h2U6bD7BxEr9wM33qHb+B0jjLylO6in4tlgL
   K4yO3P3FFsnra9+PDUC3CjI8TDzoj2cVElLwjI6AWz4qDKfKhfgr0Q7Ej
   Q==;
X-CSE-ConnectionGUID: AVhD6IbbTr+VTVbKn4tPHg==
X-CSE-MsgGUID: +b6SCW7aRs2yeSw168RTOw==
X-IronPort-AV: E=McAfee;i="6800,10657,11501"; a="58388368"
X-IronPort-AV: E=Sophos;i="6.16,339,1744095600"; 
   d="scan'208";a="58388368"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2025 02:09:41 -0700
X-CSE-ConnectionGUID: kSpoxNRiQjao3T7qCKvFWg==
X-CSE-MsgGUID: mpnkw72eSZCvROe2WTAelA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,339,1744095600"; 
   d="scan'208";a="165316087"
Received: from t21-qat.iind.intel.com ([10.49.15.35])
  by orviesa004.jf.intel.com with ESMTP; 25 Jul 2025 02:09:39 -0700
From: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com
Subject: [PATCH 2/2] crypto: qat - add command queue telemetry counters for GEN6
Date: Fri, 25 Jul 2025 10:09:30 +0100
Message-Id: <20250725090930.96450-3-suman.kumar.chakraborty@intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20250725090930.96450-1-suman.kumar.chakraborty@intel.com>
References: <20250725090930.96450-1-suman.kumar.chakraborty@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Vijay Sundar Selvamani <vijay.sundar.selvamani@intel.com>

Add slice-specific command queue counters for QAT GEN6 devices to monitor
utilization metrics, including wait time, execution duration, and release
events.

Update the documentation to reflect the new command queue counter
functionality.

Co-developed-by: George Abraham P <george.abraham.p@intel.com>
Signed-off-by: George Abraham P <george.abraham.p@intel.com>
Signed-off-by: Vijay Sundar Selvamani <vijay.sundar.selvamani@intel.com>
Signed-off-by: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 .../ABI/testing/debugfs-driver-qat_telemetry  |  26 +++++
 .../crypto/intel/qat/qat_common/adf_gen6_tl.c | 104 ++++++++++++++++++
 .../intel/qat/qat_common/adf_telemetry.c      |  19 ++++
 .../intel/qat/qat_common/adf_telemetry.h      |   5 +
 .../intel/qat/qat_common/adf_tl_debugfs.c     |  52 +++++++++
 .../intel/qat/qat_common/adf_tl_debugfs.h     |   4 +
 6 files changed, 210 insertions(+)

diff --git a/Documentation/ABI/testing/debugfs-driver-qat_telemetry b/Documentation/ABI/testing/debugfs-driver-qat_telemetry
index 53abf9275147..06097ee0f154 100644
--- a/Documentation/ABI/testing/debugfs-driver-qat_telemetry
+++ b/Documentation/ABI/testing/debugfs-driver-qat_telemetry
@@ -86,6 +86,32 @@ Description:	(RO) Reports device telemetry counters.
 		exec_cph<N>		execution count of Cipher slice N
 		util_ath<N>		utilization of Authentication slice N [%]
 		exec_ath<N>		execution count of Authentication slice N
+		cmdq_wait_cnv<N>	wait time for cmdq N to get Compression and verify
+					slice ownership
+		cmdq_exec_cnv<N>	Compression and verify slice execution time while
+					owned by cmdq N
+		cmdq_drain_cnv<N>	time taken for cmdq N to release Compression and
+					verify slice ownership
+		cmdq_wait_dcprz<N>	wait time for cmdq N to get Decompression
+					slice N ownership
+		cmdq_exec_dcprz<N>	Decompression slice execution time while
+					owned by cmdq N
+		cmdq_drain_dcprz<N>	time taken for cmdq N to release Decompression
+					slice ownership
+		cmdq_wait_pke<N>	wait time for cmdq N to get PKE slice ownership
+		cmdq_exec_pke<N>	PKE slice execution time while owned by cmdq N
+		cmdq_drain_pke<N>	time taken for cmdq N to release PKE slice
+					ownership
+		cmdq_wait_ucs<N>	wait time for cmdq N to get UCS slice ownership
+		cmdq_exec_ucs<N>	UCS slice execution time while owned by cmdq N
+		cmdq_drain_ucs<N>	time taken for cmdq N to release UCS slice
+					ownership
+		cmdq_wait_ath<N>	wait time for cmdq N to get Authentication slice
+					ownership
+		cmdq_exec_ath<N>	Authentication slice execution time while owned
+					by cmdq N
+		cmdq_drain_ath<N>	time taken for cmdq N to release Authentication
+					slice ownership
 		=======================	========================================
 
 		The telemetry report file can be read with the following command::
diff --git a/drivers/crypto/intel/qat/qat_common/adf_gen6_tl.c b/drivers/crypto/intel/qat/qat_common/adf_gen6_tl.c
index 633b0c05fbdb..faa60b04c406 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_gen6_tl.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_gen6_tl.c
@@ -21,6 +21,25 @@
 
 #define SLICE_IDX(sl) offsetof(struct icp_qat_fw_init_admin_slice_cnt, sl##_cnt)
 
+#define ADF_GEN6_TL_CMDQ_WAIT_COUNTER(_name)                     \
+	ADF_TL_COUNTER("cmdq_wait_" #_name, ADF_TL_SIMPLE_COUNT, \
+		       ADF_TL_CMDQ_REG_OFF(_name, reg_tm_cmdq_wait_cnt, gen6))
+#define ADF_GEN6_TL_CMDQ_EXEC_COUNTER(_name)                     \
+	ADF_TL_COUNTER("cmdq_exec_" #_name, ADF_TL_SIMPLE_COUNT, \
+		       ADF_TL_CMDQ_REG_OFF(_name, reg_tm_cmdq_exec_cnt, gen6))
+#define ADF_GEN6_TL_CMDQ_DRAIN_COUNTER(_name)                            \
+	ADF_TL_COUNTER("cmdq_drain_" #_name, ADF_TL_SIMPLE_COUNT,        \
+		       ADF_TL_CMDQ_REG_OFF(_name, reg_tm_cmdq_drain_cnt, \
+					   gen6))
+
+#define CPR_QUEUE_COUNT		5
+#define DCPR_QUEUE_COUNT	3
+#define PKE_QUEUE_COUNT		1
+#define WAT_QUEUE_COUNT		7
+#define WCP_QUEUE_COUNT		7
+#define USC_QUEUE_COUNT		3
+#define ATH_QUEUE_COUNT		2
+
 /* Device level counters. */
 static const struct adf_tl_dbg_counter dev_counters[] = {
 	/* PCIe partial transactions. */
@@ -99,6 +118,80 @@ static const struct adf_tl_dbg_counter sl_exec_counters[ADF_TL_SL_CNT_COUNT] = {
 	[SLICE_IDX(ath)] = ADF_GEN6_TL_SL_EXEC_COUNTER(ath),
 };
 
+static const struct adf_tl_dbg_counter cnv_cmdq_counters[] = {
+	ADF_GEN6_TL_CMDQ_WAIT_COUNTER(cnv),
+	ADF_GEN6_TL_CMDQ_EXEC_COUNTER(cnv),
+	ADF_GEN6_TL_CMDQ_DRAIN_COUNTER(cnv)
+};
+
+#define NUM_CMDQ_COUNTERS ARRAY_SIZE(cnv_cmdq_counters)
+
+static const struct adf_tl_dbg_counter dcprz_cmdq_counters[] = {
+	ADF_GEN6_TL_CMDQ_WAIT_COUNTER(dcprz),
+	ADF_GEN6_TL_CMDQ_EXEC_COUNTER(dcprz),
+	ADF_GEN6_TL_CMDQ_DRAIN_COUNTER(dcprz)
+};
+
+static_assert(ARRAY_SIZE(dcprz_cmdq_counters) == NUM_CMDQ_COUNTERS);
+
+static const struct adf_tl_dbg_counter pke_cmdq_counters[] = {
+	ADF_GEN6_TL_CMDQ_WAIT_COUNTER(pke),
+	ADF_GEN6_TL_CMDQ_EXEC_COUNTER(pke),
+	ADF_GEN6_TL_CMDQ_DRAIN_COUNTER(pke)
+};
+
+static_assert(ARRAY_SIZE(pke_cmdq_counters) == NUM_CMDQ_COUNTERS);
+
+static const struct adf_tl_dbg_counter wat_cmdq_counters[] = {
+	ADF_GEN6_TL_CMDQ_WAIT_COUNTER(wat),
+	ADF_GEN6_TL_CMDQ_EXEC_COUNTER(wat),
+	ADF_GEN6_TL_CMDQ_DRAIN_COUNTER(wat)
+};
+
+static_assert(ARRAY_SIZE(wat_cmdq_counters) == NUM_CMDQ_COUNTERS);
+
+static const struct adf_tl_dbg_counter wcp_cmdq_counters[] = {
+	ADF_GEN6_TL_CMDQ_WAIT_COUNTER(wcp),
+	ADF_GEN6_TL_CMDQ_EXEC_COUNTER(wcp),
+	ADF_GEN6_TL_CMDQ_DRAIN_COUNTER(wcp)
+};
+
+static_assert(ARRAY_SIZE(wcp_cmdq_counters) == NUM_CMDQ_COUNTERS);
+
+static const struct adf_tl_dbg_counter ucs_cmdq_counters[] = {
+	ADF_GEN6_TL_CMDQ_WAIT_COUNTER(ucs),
+	ADF_GEN6_TL_CMDQ_EXEC_COUNTER(ucs),
+	ADF_GEN6_TL_CMDQ_DRAIN_COUNTER(ucs)
+};
+
+static_assert(ARRAY_SIZE(ucs_cmdq_counters) == NUM_CMDQ_COUNTERS);
+
+static const struct adf_tl_dbg_counter ath_cmdq_counters[] = {
+	ADF_GEN6_TL_CMDQ_WAIT_COUNTER(ath),
+	ADF_GEN6_TL_CMDQ_EXEC_COUNTER(ath),
+	ADF_GEN6_TL_CMDQ_DRAIN_COUNTER(ath)
+};
+
+static_assert(ARRAY_SIZE(ath_cmdq_counters) == NUM_CMDQ_COUNTERS);
+
+/* CMDQ drain counters. */
+static const struct adf_tl_dbg_counter *cmdq_counters[ADF_TL_SL_CNT_COUNT] = {
+	/* Compression accelerator execution count. */
+	[SLICE_IDX(cpr)] = cnv_cmdq_counters,
+	/* Decompression accelerator execution count. */
+	[SLICE_IDX(dcpr)] = dcprz_cmdq_counters,
+	/* PKE execution count. */
+	[SLICE_IDX(pke)] = pke_cmdq_counters,
+	/* Wireless Authentication accelerator execution count. */
+	[SLICE_IDX(wat)] = wat_cmdq_counters,
+	/* Wireless Cipher accelerator execution count. */
+	[SLICE_IDX(wcp)] = wcp_cmdq_counters,
+	/* UCS accelerator execution count. */
+	[SLICE_IDX(ucs)] = ucs_cmdq_counters,
+	/* Authentication accelerator execution count. */
+	[SLICE_IDX(ath)] = ath_cmdq_counters,
+};
+
 /* Ring pair counters. */
 static const struct adf_tl_dbg_counter rp_counters[] = {
 	/* PCIe partial transactions. */
@@ -136,6 +229,7 @@ void adf_gen6_init_tl_data(struct adf_tl_hw_data *tl_data)
 {
 	tl_data->layout_sz = ADF_GEN6_TL_LAYOUT_SZ;
 	tl_data->slice_reg_sz = ADF_GEN6_TL_SLICE_REG_SZ;
+	tl_data->cmdq_reg_sz = ADF_GEN6_TL_CMDQ_REG_SZ;
 	tl_data->rp_reg_sz = ADF_GEN6_TL_RP_REG_SZ;
 	tl_data->num_hbuff = ADF_GEN6_TL_NUM_HIST_BUFFS;
 	tl_data->max_rp = ADF_GEN6_TL_MAX_RP_NUM;
@@ -147,8 +241,18 @@ void adf_gen6_init_tl_data(struct adf_tl_hw_data *tl_data)
 	tl_data->num_dev_counters = ARRAY_SIZE(dev_counters);
 	tl_data->sl_util_counters = sl_util_counters;
 	tl_data->sl_exec_counters = sl_exec_counters;
+	tl_data->cmdq_counters = cmdq_counters;
+	tl_data->num_cmdq_counters = NUM_CMDQ_COUNTERS;
 	tl_data->rp_counters = rp_counters;
 	tl_data->num_rp_counters = ARRAY_SIZE(rp_counters);
 	tl_data->max_sl_cnt = ADF_GEN6_TL_MAX_SLICES_PER_TYPE;
+
+	tl_data->multiplier.cpr_cnt = CPR_QUEUE_COUNT;
+	tl_data->multiplier.dcpr_cnt = DCPR_QUEUE_COUNT;
+	tl_data->multiplier.pke_cnt = PKE_QUEUE_COUNT;
+	tl_data->multiplier.wat_cnt = WAT_QUEUE_COUNT;
+	tl_data->multiplier.wcp_cnt = WCP_QUEUE_COUNT;
+	tl_data->multiplier.ucs_cnt = USC_QUEUE_COUNT;
+	tl_data->multiplier.ath_cnt = ATH_QUEUE_COUNT;
 }
 EXPORT_SYMBOL_GPL(adf_gen6_init_tl_data);
diff --git a/drivers/crypto/intel/qat/qat_common/adf_telemetry.c b/drivers/crypto/intel/qat/qat_common/adf_telemetry.c
index 74fb0c2ed241..b64142db1f0d 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_telemetry.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_telemetry.c
@@ -212,6 +212,23 @@ int adf_tl_halt(struct adf_accel_dev *accel_dev)
 	return ret;
 }
 
+static void adf_set_cmdq_cnt(struct adf_accel_dev *accel_dev,
+			     struct adf_tl_hw_data *tl_data)
+{
+	struct icp_qat_fw_init_admin_slice_cnt *slice_cnt, *cmdq_cnt;
+
+	slice_cnt = &accel_dev->telemetry->slice_cnt;
+	cmdq_cnt = &accel_dev->telemetry->cmdq_cnt;
+
+	cmdq_cnt->cpr_cnt = slice_cnt->cpr_cnt * tl_data->multiplier.cpr_cnt;
+	cmdq_cnt->dcpr_cnt = slice_cnt->dcpr_cnt * tl_data->multiplier.dcpr_cnt;
+	cmdq_cnt->pke_cnt = slice_cnt->pke_cnt * tl_data->multiplier.pke_cnt;
+	cmdq_cnt->wat_cnt = slice_cnt->wat_cnt * tl_data->multiplier.wat_cnt;
+	cmdq_cnt->wcp_cnt = slice_cnt->wcp_cnt * tl_data->multiplier.wcp_cnt;
+	cmdq_cnt->ucs_cnt = slice_cnt->ucs_cnt * tl_data->multiplier.ucs_cnt;
+	cmdq_cnt->ath_cnt = slice_cnt->ath_cnt * tl_data->multiplier.ath_cnt;
+}
+
 int adf_tl_run(struct adf_accel_dev *accel_dev, int state)
 {
 	struct adf_tl_hw_data *tl_data = &GET_TL_DATA(accel_dev);
@@ -235,6 +252,8 @@ int adf_tl_run(struct adf_accel_dev *accel_dev, int state)
 		return ret;
 	}
 
+	adf_set_cmdq_cnt(accel_dev, tl_data);
+
 	telemetry->hbuffs = state;
 	atomic_set(&telemetry->state, state);
 
diff --git a/drivers/crypto/intel/qat/qat_common/adf_telemetry.h b/drivers/crypto/intel/qat/qat_common/adf_telemetry.h
index e54a406cc1b4..02d75c3c214a 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_telemetry.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_telemetry.h
@@ -28,19 +28,23 @@ struct dentry;
 struct adf_tl_hw_data {
 	size_t layout_sz;
 	size_t slice_reg_sz;
+	size_t cmdq_reg_sz;
 	size_t rp_reg_sz;
 	size_t msg_cnt_off;
 	const struct adf_tl_dbg_counter *dev_counters;
 	const struct adf_tl_dbg_counter *sl_util_counters;
 	const struct adf_tl_dbg_counter *sl_exec_counters;
+	const struct adf_tl_dbg_counter **cmdq_counters;
 	const struct adf_tl_dbg_counter *rp_counters;
 	u8 num_hbuff;
 	u8 cpp_ns_per_cycle;
 	u8 bw_units_to_bytes;
 	u8 num_dev_counters;
 	u8 num_rp_counters;
+	u8 num_cmdq_counters;
 	u8 max_rp;
 	u8 max_sl_cnt;
+	struct icp_qat_fw_init_admin_slice_cnt multiplier;
 };
 
 struct adf_telemetry {
@@ -69,6 +73,7 @@ struct adf_telemetry {
 	struct mutex wr_lock;
 	struct delayed_work work_ctx;
 	struct icp_qat_fw_init_admin_slice_cnt slice_cnt;
+	struct icp_qat_fw_init_admin_slice_cnt cmdq_cnt;
 };
 
 #ifdef CONFIG_DEBUG_FS
diff --git a/drivers/crypto/intel/qat/qat_common/adf_tl_debugfs.c b/drivers/crypto/intel/qat/qat_common/adf_tl_debugfs.c
index a32db273842a..b81f70576683 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_tl_debugfs.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_tl_debugfs.c
@@ -339,6 +339,48 @@ static int tl_calc_and_print_sl_counters(struct adf_accel_dev *accel_dev,
 	return 0;
 }
 
+static int tl_print_cmdq_counter(struct adf_telemetry *telemetry,
+				 const struct adf_tl_dbg_counter *ctr,
+				 struct seq_file *s, u8 cnt_id, u8 counter)
+{
+	size_t cmdq_regs_sz = GET_TL_DATA(telemetry->accel_dev).cmdq_reg_sz;
+	size_t offset_inc = cnt_id * cmdq_regs_sz;
+	struct adf_tl_dbg_counter slice_ctr;
+	char cnt_name[MAX_COUNT_NAME_SIZE];
+
+	slice_ctr = *(ctr + counter);
+	slice_ctr.offset1 += offset_inc;
+	snprintf(cnt_name, MAX_COUNT_NAME_SIZE, "%s%d", slice_ctr.name, cnt_id);
+
+	return tl_calc_and_print_counter(telemetry, s, &slice_ctr, cnt_name);
+}
+
+static int tl_calc_and_print_cmdq_counters(struct adf_accel_dev *accel_dev,
+					   struct seq_file *s, u8 cnt_type,
+					   u8 cnt_id)
+{
+	struct adf_tl_hw_data *tl_data = &GET_TL_DATA(accel_dev);
+	struct adf_telemetry *telemetry = accel_dev->telemetry;
+	const struct adf_tl_dbg_counter **cmdq_tl_counters;
+	const struct adf_tl_dbg_counter *ctr;
+	u8 counter;
+	int ret;
+
+	cmdq_tl_counters = tl_data->cmdq_counters;
+	ctr = cmdq_tl_counters[cnt_type];
+
+	for (counter = 0; counter < tl_data->num_cmdq_counters; counter++) {
+		ret = tl_print_cmdq_counter(telemetry, ctr, s, cnt_id, counter);
+		if (ret) {
+			dev_notice(&GET_DEV(accel_dev),
+				   "invalid slice utilization counter type\n");
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
 static void tl_print_msg_cnt(struct seq_file *s, u32 msg_cnt)
 {
 	seq_printf(s, "%-*s", TL_KEY_MIN_PADDING, SNAPSHOT_CNT_MSG);
@@ -352,6 +394,7 @@ static int tl_print_dev_data(struct adf_accel_dev *accel_dev,
 	struct adf_telemetry *telemetry = accel_dev->telemetry;
 	const struct adf_tl_dbg_counter *dev_tl_counters;
 	u8 num_dev_counters = tl_data->num_dev_counters;
+	u8 *cmdq_cnt = (u8 *)&telemetry->cmdq_cnt;
 	u8 *sl_cnt = (u8 *)&telemetry->slice_cnt;
 	const struct adf_tl_dbg_counter *ctr;
 	unsigned int i;
@@ -387,6 +430,15 @@ static int tl_print_dev_data(struct adf_accel_dev *accel_dev,
 		}
 	}
 
+	/* Print per command queue telemetry. */
+	for (i = 0; i < ADF_TL_SL_CNT_COUNT; i++) {
+		for (j = 0; j < cmdq_cnt[i]; j++) {
+			ret = tl_calc_and_print_cmdq_counters(accel_dev, s, i, j);
+			if (ret)
+				return ret;
+		}
+	}
+
 	return 0;
 }
 
diff --git a/drivers/crypto/intel/qat/qat_common/adf_tl_debugfs.h b/drivers/crypto/intel/qat/qat_common/adf_tl_debugfs.h
index 9efab3f76a3f..97c5eeaa1b17 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_tl_debugfs.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_tl_debugfs.h
@@ -44,6 +44,10 @@ struct adf_accel_dev;
 	(ADF_TL_DEV_REG_OFF(slice##_slices[0], qat_gen) +	\
 	offsetof(struct adf_##qat_gen##_tl_slice_data_regs, reg))
 
+#define ADF_TL_CMDQ_REG_OFF(slice, reg, qat_gen)        \
+	(ADF_TL_DEV_REG_OFF(slice##_cmdq[0], qat_gen) + \
+	 offsetof(struct adf_##qat_gen##_tl_cmdq_data_regs, reg))
+
 #define ADF_TL_RP_REG_OFF(reg, qat_gen)					\
 	(ADF_TL_DATA_REG_OFF(tl_ring_pairs_data_regs[0], qat_gen) +	\
 	offsetof(struct adf_##qat_gen##_tl_ring_pair_data_regs, reg))
-- 
2.40.1

