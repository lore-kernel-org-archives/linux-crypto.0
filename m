Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85A0F272E71
	for <linux-crypto@vger.kernel.org>; Fri, 25 Jul 2025 09:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753434581; cv=none; b=D++8+cYQkPrFK/D7bZoI8fh44DilS3vOz5Gci22n+PiT6b4h8sps0gIFZCmyVirXRr8OpaT1qmFQtmb6ipJzOo8kAzoxFiOi3UnB09cO7uJk9FsQcudj3kvu91kSVZQdFaTDfGRuSpj1KiwfkQsxki6VPsAmstmoCaZFxPMB3nc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753434581; c=relaxed/simple;
	bh=k6ppnibjszuAQAlr4MWCTb+i54D/3H45X+WH6U24WTQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Xi6XqRq4jrMXWgT43wgl3T1JX7TJ52FzxwOXpoWynpIBwA+j6vmvGa8NIA4EnjsFfyTyWYPqvDIOhLwF7UeK4ozXumvp96fspv93rEYdtU2Bju6D8g0gB/mvYABkdytIPrYnieNxBJ+uAcuVafOryWhCExSKql+7aS4JqbzitGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hTPQWk4A; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hTPQWk4A"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753434580; x=1784970580;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=k6ppnibjszuAQAlr4MWCTb+i54D/3H45X+WH6U24WTQ=;
  b=hTPQWk4AV2MaS1pLy03d+hCCpjM3nboqStu/lLyaPzztZaYfmAxBOYsQ
   9FpE3jilg6IQ71KjJ2GFst68hUhLoQI2kMgojv0bkYGgLi+6Af5TtIfTw
   f16PwEEkFWmgu15E+EwXrNSJ/ARBvnZOlDFN1fihlMLNLzdXQiBcIn/g4
   wUbgqv74r3lduDoXTIM+rfXNjSrd+DqsUmXytw+ALmAzlh0eG1+oMHJUm
   NYEdzawyyOb9t7GDPIHr4OUjOkpkopvSdnkPPUFp9wPMFoJyXG9PBIeoJ
   OT0ebhif3kAwc3KIZnzltBsmj2j8+SGgDGczaPm7mmgXRACSxKD21NxQz
   A==;
X-CSE-ConnectionGUID: tke13UTTSa2K5WGka82ugQ==
X-CSE-MsgGUID: aJ2wg7X4R1ikO8ZOQ+K80A==
X-IronPort-AV: E=McAfee;i="6800,10657,11501"; a="58388364"
X-IronPort-AV: E=Sophos;i="6.16,339,1744095600"; 
   d="scan'208";a="58388364"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2025 02:09:39 -0700
X-CSE-ConnectionGUID: gCbZJYmfSJmdFO1OdQo2dQ==
X-CSE-MsgGUID: 7PQttv0SSdem/B8xrjXTzg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,339,1744095600"; 
   d="scan'208";a="165316081"
Received: from t21-qat.iind.intel.com ([10.49.15.35])
  by orviesa004.jf.intel.com with ESMTP; 25 Jul 2025 02:09:37 -0700
From: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com
Subject: [PATCH 1/2] crypto: qat - add ring buffer idle telemetry counter for GEN6
Date: Fri, 25 Jul 2025 10:09:29 +0100
Message-Id: <20250725090930.96450-2-suman.kumar.chakraborty@intel.com>
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

Add a new performance counter that measures the average ring buffer idle
duration.

This metric is now included in the telemetry counters exposed via
debugfs for QAT GEN6 devices.

Update the documentation to reflect the new idle duration counter

Co-developed-by: George Abraham P <george.abraham.p@intel.com>
Signed-off-by: George Abraham P <george.abraham.p@intel.com>
Signed-off-by: Vijay Sundar Selvamani <vijay.sundar.selvamani@intel.com>
Signed-off-by: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 Documentation/ABI/testing/debugfs-driver-qat_telemetry | 1 +
 drivers/crypto/intel/qat/qat_common/adf_gen6_tl.c      | 8 ++++++++
 drivers/crypto/intel/qat/qat_common/adf_tl_debugfs.h   | 1 +
 3 files changed, 10 insertions(+)

diff --git a/Documentation/ABI/testing/debugfs-driver-qat_telemetry b/Documentation/ABI/testing/debugfs-driver-qat_telemetry
index 0dfd8d97e169..53abf9275147 100644
--- a/Documentation/ABI/testing/debugfs-driver-qat_telemetry
+++ b/Documentation/ABI/testing/debugfs-driver-qat_telemetry
@@ -57,6 +57,7 @@ Description:	(RO) Reports device telemetry counters.
 		gp_lat_acc_avg		average get to put latency [ns]
 		bw_in			PCIe, write bandwidth [Mbps]
 		bw_out			PCIe, read bandwidth [Mbps]
+		re_acc_avg		average ring empty time [ns]
 		at_page_req_lat_avg	Address Translator(AT), average page
 					request latency [ns]
 		at_trans_lat_avg	AT, average page translation latency [ns]
diff --git a/drivers/crypto/intel/qat/qat_common/adf_gen6_tl.c b/drivers/crypto/intel/qat/qat_common/adf_gen6_tl.c
index cf804f95838a..633b0c05fbdb 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_gen6_tl.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_gen6_tl.c
@@ -57,6 +57,10 @@ static const struct adf_tl_dbg_counter dev_counters[] = {
 	/* Maximum uTLB used. */
 	ADF_TL_COUNTER(AT_MAX_UTLB_USED_NAME, ADF_TL_SIMPLE_COUNT,
 		       ADF_GEN6_TL_DEV_REG_OFF(reg_tl_at_max_utlb_used)),
+	/* Ring Empty average[ns] across all rings */
+	ADF_TL_COUNTER_LATENCY(RE_ACC_NAME, ADF_TL_COUNTER_NS_AVG,
+			       ADF_GEN6_TL_DEV_REG_OFF(reg_tl_re_acc),
+			       ADF_GEN6_TL_DEV_REG_OFF(reg_tl_re_cnt)),
 };
 
 /* Accelerator utilization counters */
@@ -122,6 +126,10 @@ static const struct adf_tl_dbg_counter rp_counters[] = {
 	/* Payload DevTLB miss rate. */
 	ADF_TL_COUNTER(AT_PAYLD_DTLB_MISS_NAME, ADF_TL_SIMPLE_COUNT,
 		       ADF_GEN6_TL_RP_REG_OFF(reg_tl_at_payld_devtlb_miss)),
+	/* Ring Empty average[ns]. */
+	ADF_TL_COUNTER_LATENCY(RE_ACC_NAME, ADF_TL_COUNTER_NS_AVG,
+			       ADF_GEN6_TL_RP_REG_OFF(reg_tl_re_acc),
+			       ADF_GEN6_TL_RP_REG_OFF(reg_tl_re_cnt)),
 };
 
 void adf_gen6_init_tl_data(struct adf_tl_hw_data *tl_data)
diff --git a/drivers/crypto/intel/qat/qat_common/adf_tl_debugfs.h b/drivers/crypto/intel/qat/qat_common/adf_tl_debugfs.h
index 11cc9eae19b3..9efab3f76a3f 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_tl_debugfs.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_tl_debugfs.h
@@ -17,6 +17,7 @@ struct adf_accel_dev;
 #define LAT_ACC_NAME		"gp_lat_acc_avg"
 #define BW_IN_NAME		"bw_in"
 #define BW_OUT_NAME		"bw_out"
+#define RE_ACC_NAME		"re_acc_avg"
 #define PAGE_REQ_LAT_NAME	"at_page_req_lat_avg"
 #define AT_TRANS_LAT_NAME	"at_trans_lat_avg"
 #define AT_MAX_UTLB_USED_NAME	"at_max_tlb_used"
-- 
2.40.1

