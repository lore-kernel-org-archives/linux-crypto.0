Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE3D849B5B4
	for <linux-crypto@vger.kernel.org>; Mon, 19 Oct 2026 11:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792408074; cv=none; b=tDKGw8dZ004sj3IDRe7b489jxyxPm+eSgrd2s0F5J+u7AhjM0KFsOc5U9QZKLl1GR1lXHLSTCo7oKWKad6EdrvFhnT6AWbB4aCaKnIQlfIm6f/3ZAiK7dIp2OF6cydtThXYzeFnxhocCA/UmeJjc/CAGsW++D2MadCpiehWA+Wc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792408074; c=relaxed/simple;
	bh=6W0kBwd4uaMe84EL+OPefNcI4PD4qddXTPXbMcrNO5I=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UrqeHnx0lAGRcHJcj7xS1mW4Lz9Al36EPYQ0HzeinIeG434UIkXg/O1hs9c1h6rn53c4Q1oxNCE7W1vAan1xtLCJ/QydtlrrZ5GtMlpJ+s+RL08vSnAsYLhxMSnvnrI30HUKW5NnIeedsGYStkDdQWqrlYPH87262kfVlPNLtPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fcVirRAD; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fcVirRAD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792408072; x=1823944072;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6W0kBwd4uaMe84EL+OPefNcI4PD4qddXTPXbMcrNO5I=;
  b=fcVirRADiOrNTfKoEnEqy1j8iDHL71uSudDr05WHBngGBRhErqu5j5Yy
   eAsnN6Jz/WNIMk+wot1FV1IV0QRdUCzqrTCilJheJYkPIHnoUMBoN3amj
   WrvqmgKT5aUPtBC9JbWa7XkLmmxVcGjpes3izm4EMFuWSH+pIGtIwxRh+
   FeTqXsUGqy5lgbwn1gLG23QThEqII9QL3Lto7tJrSbEvmLvrYZ9wOWzVz
   zxk+hEU57oFeTwZ7bbOgZbx07mjva3iwdaRFx6Afyu/EO3tyy+JfXgrCP
   gaBs3B//K3lSP+ipvc7whhiWdQuISSHCY5cRDNIOkCFWXuWNBeqMer6yJ
   A==;
X-CSE-ConnectionGUID: qIzZSHceRqyHvP+z+3jQ8Q==
X-CSE-MsgGUID: cQhfWF+mRwyChWv4v+9RYg==
X-IronPort-AV: E=McAfee;i="6800,10657,11939"; a="1088257"
X-IronPort-AV: E=Sophos;i="6.27,167,1787036400"; 
   d="scan'208";a="1088257"
Received: from fmviesa012.fm.intel.com ([10.60.135.152])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2026 04:07:52 -0700
X-CSE-ConnectionGUID: Cvy55Z3uTLCgWHznIfIz6A==
X-CSE-MsgGUID: Xvm1nrtaRZWFxR6g4mSUpQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,167,1787036400"; 
   d="scan'208";a="4267872"
Received: from indlpbc065983.iind.intel.com ([10.49.120.87])
  by fmviesa012.fm.intel.com with ESMTP; 19 Oct 2026 04:07:50 -0700
From: George Abraham P <george.abraham.p@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	George Abraham P <george.abraham.p@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Ahsan Atta <ahsan.atta@intel.com>
Subject: [PATCH 3/3] crypto: qat - fix telemetry command queue counts
Date: Mon, 19 Oct 2026 16:33:56 +0530
Message-Id: <20261019110356.3781949-4-george.abraham.p@intel.com>
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

QAT GEN6 telemetry derives the number of command queues for each slice
type by multiplying the slice count reported by firmware by a per-slice
multiplier. However, the number of command queues for a slice type is
fixed and does not scale with the number of slices. For example, WAT
(wireless auth) and WCP (wireless cipher) slices have 18 command queues
across four slices. In addition, the per-slice queue counts for the PKE
(public key encryption), WAT, WCP, UCS (crypto) and ATH (auth) slices do
not match the hardware (for example, PKE has 18 command queues, not 1).
This results in an incorrect number of command queue counters being
reported.

Replace the per-slice multipliers with the total number of command
queues for each slice type, and report that count only when the
corresponding slice type is present. Update the PKE, WAT, WCP, UCS and
ATH queue count constants, rename the multiplier field in struct
adf_tl_hw_data to cmdq_cnt, and fix the USC_QUEUE_COUNT typo to
UCS_QUEUE_COUNT.

Fixes: 3ed63344657a ("crypto: qat - add command queue telemetry counters for GEN6")
Signed-off-by: George Abraham P <george.abraham.p@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Ahsan Atta <ahsan.atta@intel.com>
---
 .../crypto/intel/qat/qat_common/adf_gen6_tl.c | 24 +++++++++----------
 .../intel/qat/qat_common/adf_telemetry.c      | 14 +++++------
 .../intel/qat/qat_common/adf_telemetry.h      |  2 +-
 3 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_gen6_tl.c b/drivers/crypto/intel/qat/qat_common/adf_gen6_tl.c
index faa60b04c406..2e5d909a3e3e 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_gen6_tl.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_gen6_tl.c
@@ -34,11 +34,11 @@
 
 #define CPR_QUEUE_COUNT		5
 #define DCPR_QUEUE_COUNT	3
-#define PKE_QUEUE_COUNT		1
-#define WAT_QUEUE_COUNT		7
-#define WCP_QUEUE_COUNT		7
-#define USC_QUEUE_COUNT		3
-#define ATH_QUEUE_COUNT		2
+#define PKE_QUEUE_COUNT		18
+#define WAT_QUEUE_COUNT		18
+#define WCP_QUEUE_COUNT		18
+#define UCS_QUEUE_COUNT		6
+#define ATH_QUEUE_COUNT		8
 
 /* Device level counters. */
 static const struct adf_tl_dbg_counter dev_counters[] = {
@@ -247,12 +247,12 @@ void adf_gen6_init_tl_data(struct adf_tl_hw_data *tl_data)
 	tl_data->num_rp_counters = ARRAY_SIZE(rp_counters);
 	tl_data->max_sl_cnt = ADF_GEN6_TL_MAX_SLICES_PER_TYPE;
 
-	tl_data->multiplier.cpr_cnt = CPR_QUEUE_COUNT;
-	tl_data->multiplier.dcpr_cnt = DCPR_QUEUE_COUNT;
-	tl_data->multiplier.pke_cnt = PKE_QUEUE_COUNT;
-	tl_data->multiplier.wat_cnt = WAT_QUEUE_COUNT;
-	tl_data->multiplier.wcp_cnt = WCP_QUEUE_COUNT;
-	tl_data->multiplier.ucs_cnt = USC_QUEUE_COUNT;
-	tl_data->multiplier.ath_cnt = ATH_QUEUE_COUNT;
+	tl_data->cmdq_cnt.cpr_cnt = CPR_QUEUE_COUNT;
+	tl_data->cmdq_cnt.dcpr_cnt = DCPR_QUEUE_COUNT;
+	tl_data->cmdq_cnt.pke_cnt = PKE_QUEUE_COUNT;
+	tl_data->cmdq_cnt.wat_cnt = WAT_QUEUE_COUNT;
+	tl_data->cmdq_cnt.wcp_cnt = WCP_QUEUE_COUNT;
+	tl_data->cmdq_cnt.ucs_cnt = UCS_QUEUE_COUNT;
+	tl_data->cmdq_cnt.ath_cnt = ATH_QUEUE_COUNT;
 }
 EXPORT_SYMBOL_GPL(adf_gen6_init_tl_data);
diff --git a/drivers/crypto/intel/qat/qat_common/adf_telemetry.c b/drivers/crypto/intel/qat/qat_common/adf_telemetry.c
index 8c575113cbcd..44e26ea8cd7f 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_telemetry.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_telemetry.c
@@ -219,13 +219,13 @@ static void adf_set_cmdq_cnt(struct adf_accel_dev *accel_dev,
 	slice_cnt = &accel_dev->telemetry->slice_cnt;
 	cmdq_cnt = &accel_dev->telemetry->cmdq_cnt;
 
-	cmdq_cnt->cpr_cnt = slice_cnt->cpr_cnt * tl_data->multiplier.cpr_cnt;
-	cmdq_cnt->dcpr_cnt = slice_cnt->dcpr_cnt * tl_data->multiplier.dcpr_cnt;
-	cmdq_cnt->pke_cnt = slice_cnt->pke_cnt * tl_data->multiplier.pke_cnt;
-	cmdq_cnt->wat_cnt = slice_cnt->wat_cnt * tl_data->multiplier.wat_cnt;
-	cmdq_cnt->wcp_cnt = slice_cnt->wcp_cnt * tl_data->multiplier.wcp_cnt;
-	cmdq_cnt->ucs_cnt = slice_cnt->ucs_cnt * tl_data->multiplier.ucs_cnt;
-	cmdq_cnt->ath_cnt = slice_cnt->ath_cnt * tl_data->multiplier.ath_cnt;
+	cmdq_cnt->cpr_cnt = slice_cnt->cpr_cnt ? tl_data->cmdq_cnt.cpr_cnt : 0;
+	cmdq_cnt->dcpr_cnt = slice_cnt->dcpr_cnt ? tl_data->cmdq_cnt.dcpr_cnt : 0;
+	cmdq_cnt->pke_cnt = slice_cnt->pke_cnt ? tl_data->cmdq_cnt.pke_cnt : 0;
+	cmdq_cnt->wat_cnt = slice_cnt->wat_cnt ? tl_data->cmdq_cnt.wat_cnt : 0;
+	cmdq_cnt->wcp_cnt = slice_cnt->wcp_cnt ? tl_data->cmdq_cnt.wcp_cnt : 0;
+	cmdq_cnt->ucs_cnt = slice_cnt->ucs_cnt ? tl_data->cmdq_cnt.ucs_cnt : 0;
+	cmdq_cnt->ath_cnt = slice_cnt->ath_cnt ? tl_data->cmdq_cnt.ath_cnt : 0;
 }
 
 int adf_tl_run(struct adf_accel_dev *accel_dev, int state)
diff --git a/drivers/crypto/intel/qat/qat_common/adf_telemetry.h b/drivers/crypto/intel/qat/qat_common/adf_telemetry.h
index 02d75c3c214a..96879d02c4fa 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_telemetry.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_telemetry.h
@@ -44,7 +44,7 @@ struct adf_tl_hw_data {
 	u8 num_cmdq_counters;
 	u8 max_rp;
 	u8 max_sl_cnt;
-	struct icp_qat_fw_init_admin_slice_cnt multiplier;
+	struct icp_qat_fw_init_admin_slice_cnt cmdq_cnt;
 };
 
 struct adf_telemetry {
-- 
2.40.1

