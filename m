Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D171127B60
	for <linux-crypto@vger.kernel.org>; Tue, 16 Apr 2024 10:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713263846; cv=none; b=pzgJbQ5leBxQHDFId3PuTWRrPquLEEOHIXOphogJd4tLOch4BcqDgRbo7Ex2LlBHDdb1Y85DL6jCD4IIPx5S+2mkjC5lbzWlPx/35IOABhlmwRVa5FOPxgAxwlso0UPR/ozCLuF93nwnIKpp6LAQbHx46mbLDmhOtMieldq/2x0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713263846; c=relaxed/simple;
	bh=EjP1E5oS1GqC/jbG5mxq3fRnO5fboUsp2ytIY4c1Qww=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=WFQT2IhpKYUo3gp9X2m0QdX28UNuk9iR8lEaQ3Yl2Riu1HDsyvlujhDQsY1qqjxF7Lh4lIXLyOMuIqmPWEDel3IZswAftAxst68vi/uq9mvDa3teiQ0hjtr9KwrvmZCox4QoearJp3cmwRAEMWfHVEPjknOSy+RycPsyXhBm9XY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mXXi1IX5; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mXXi1IX5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713263844; x=1744799844;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=EjP1E5oS1GqC/jbG5mxq3fRnO5fboUsp2ytIY4c1Qww=;
  b=mXXi1IX5T/d7HqJP0e21JsjNFp5LcscZiV39wB7i5rA9/iOi2/9ecg8W
   XHd7DejiWVf8gk1rGZ0rjhyfyo/QZfCKUhN2kkM4HYmhXqfdNkbx3e5rq
   Dw1XcZSnl2RgHK/3PKuapBMF3ZqCiYedztOXzr2XJ9tTYKzn5KPGFLTlA
   rCDQJxWFG6ArDte9TlZfh3ltxRYMOgSD+kcFBjvioK2tdP9wyIF/v4yUw
   3Fss1Y9Ax9LNIJGoBxN6Kx1x0uljwSpQS+9ZEiI23r0jtUMjySpMF9Xdp
   N2ha3qRgljuqS8EahJCU1imMvJHK7k0dre8iET9opC3tFWCM5bG1vWXHI
   g==;
X-CSE-ConnectionGUID: 8yiDoA14QxetSFitVouuAA==
X-CSE-MsgGUID: ghNy7dRSSt+z/sBotKGoTw==
X-IronPort-AV: E=McAfee;i="6600,9927,11045"; a="8554682"
X-IronPort-AV: E=Sophos;i="6.07,205,1708416000"; 
   d="scan'208";a="8554682"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2024 03:37:23 -0700
X-CSE-ConnectionGUID: uoUuA4nZTcOiDhrRcarwuQ==
X-CSE-MsgGUID: aow3Q6FlTc6my1ZL7MVyZQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,205,1708416000"; 
   d="scan'208";a="26867771"
Received: from r007s007_zp31l10c01.deacluster.intel.com (HELO fedora.deacluster.intel.com) ([10.219.171.169])
  by fmviesa004.fm.intel.com with ESMTP; 16 Apr 2024 03:37:23 -0700
From: Lucas Segarra Fernandez <lucas.segarra.fernandez@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	Lucas Segarra Fernandez <lucas.segarra.fernandez@intel.com>,
	Damian Muszynski <damian.muszynski@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH] crypto: qat - validate slices count returned by FW
Date: Tue, 16 Apr 2024 12:33:37 +0200
Message-ID: <20240416103337.792676-1-lucas.segarra.fernandez@intel.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The function adf_send_admin_tl_start() enables the telemetry (TL)
feature on a QAT device by sending the ICP_QAT_FW_TL_START message to
the firmware. This triggers the FW to start writing TL data to a DMA
buffer in memory and returns an array containing the number of
accelerators of each type (slices) supported by this HW.
The pointer to this array is stored in the adf_tl_hw_data data
structure called slice_cnt.

The array slice_cnt is then used in the function tl_print_dev_data()
to report in debugfs only statistics about the supported accelerators.
An incorrect value of the elements in slice_cnt might lead to an out
of bounds memory read.
At the moment, there isn't an implementation of FW that returns a wrong
value, but for robustness validate the slice count array returned by FW.

Fixes: 69e7649f7cc2 ("crypto: qat - add support for device telemetry")
Signed-off-by: Lucas Segarra Fernandez <lucas.segarra.fernandez@intel.com>
Reviewed-by: Damian Muszynski <damian.muszynski@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 .../crypto/intel/qat/qat_common/adf_gen4_tl.c |  1 +
 .../intel/qat/qat_common/adf_telemetry.c      | 21 +++++++++++++++++++
 .../intel/qat/qat_common/adf_telemetry.h      |  1 +
 3 files changed, 23 insertions(+)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_gen4_tl.c b/drivers/crypto/intel/qat/qat_common/adf_gen4_tl.c
index 7fc7a77f6aed..c7ad8cf07863 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_gen4_tl.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_gen4_tl.c
@@ -149,5 +149,6 @@ void adf_gen4_init_tl_data(struct adf_tl_hw_data *tl_data)
 	tl_data->sl_exec_counters = sl_exec_counters;
 	tl_data->rp_counters = rp_counters;
 	tl_data->num_rp_counters = ARRAY_SIZE(rp_counters);
+	tl_data->max_sl_cnt = ADF_GEN4_TL_MAX_SLICES_PER_TYPE;
 }
 EXPORT_SYMBOL_GPL(adf_gen4_init_tl_data);
diff --git a/drivers/crypto/intel/qat/qat_common/adf_telemetry.c b/drivers/crypto/intel/qat/qat_common/adf_telemetry.c
index 2ff714d11bd2..74fb0c2ed241 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_telemetry.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_telemetry.c
@@ -41,6 +41,20 @@ static int validate_tl_data(struct adf_tl_hw_data *tl_data)
 	return 0;
 }
 
+static int validate_tl_slice_counters(struct icp_qat_fw_init_admin_slice_cnt *slice_count,
+				      u8 max_slices_per_type)
+{
+	u8 *sl_counter = (u8 *)slice_count;
+	int i;
+
+	for (i = 0; i < ADF_TL_SL_CNT_COUNT; i++) {
+		if (sl_counter[i] > max_slices_per_type)
+			return -EINVAL;
+	}
+
+	return 0;
+}
+
 static int adf_tl_alloc_mem(struct adf_accel_dev *accel_dev)
 {
 	struct adf_tl_hw_data *tl_data = &GET_TL_DATA(accel_dev);
@@ -214,6 +228,13 @@ int adf_tl_run(struct adf_accel_dev *accel_dev, int state)
 		return ret;
 	}
 
+	ret = validate_tl_slice_counters(&telemetry->slice_cnt, tl_data->max_sl_cnt);
+	if (ret) {
+		dev_err(dev, "invalid value returned by FW\n");
+		adf_send_admin_tl_stop(accel_dev);
+		return ret;
+	}
+
 	telemetry->hbuffs = state;
 	atomic_set(&telemetry->state, state);
 
diff --git a/drivers/crypto/intel/qat/qat_common/adf_telemetry.h b/drivers/crypto/intel/qat/qat_common/adf_telemetry.h
index 9be81cd3b886..e54a406cc1b4 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_telemetry.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_telemetry.h
@@ -40,6 +40,7 @@ struct adf_tl_hw_data {
 	u8 num_dev_counters;
 	u8 num_rp_counters;
 	u8 max_rp;
+	u8 max_sl_cnt;
 };
 
 struct adf_telemetry {

base-commit: a64466233e2ff45c846ea79c6ca4f2d50ef1244b
-- 
2.43.0

