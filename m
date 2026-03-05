Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E128372EF8
	for <linux-crypto@vger.kernel.org>; Thu,  5 Mar 2026 09:00:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772701202; cv=none; b=DpnwLXJ8z4vjhHY6dVfnJB5ld0nJtEtSqBYOwyqHjnXk1/0Kpl3UVNJptaniURzKve9fk1xd07xXTJJRyjl0kobye+lwTZOrgCOwxofuL4EusbWcjvzLdZ7L9GpZvPBaw9RnOuSbNrzSVCmA9irlVdDB7AiHsY7pQaj8Gqv7syA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772701202; c=relaxed/simple;
	bh=6WBVKSkP6jP4maGtZ9M0DLpZX2RxI5mkQM6QCNinV5U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EjzfvzBNOW8UpVlWvXv/Squ1V0dO9XxtsGzJox67GvmdSA18zuWLPa3jDXIf6whTPgldQy8pGFFR6L9PY3OflQv/YfWt06wNT2sihay4Ix3r4ffENYoAAq+35cm7QlUsUlbf6DZj9VJlyPqX5XKVLOZWkMiNucAC4+vaJL1Dj5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cTfjtUzy; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cTfjtUzy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772701201; x=1804237201;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6WBVKSkP6jP4maGtZ9M0DLpZX2RxI5mkQM6QCNinV5U=;
  b=cTfjtUzyxjWV3TOTzTrAcnKmypJ2OiU1U6YL0qg2AoiYkg9gJFhTxjz4
   PGA4qQsTNQPSbY0kU0UVJfWfu19ZJ/2NtArPK2Un85PJmCSUSwkWJnUGM
   ZlCA4YXxy7ZLSrUMuX2IowDb02caljJKfQii765CYXmdF73eEG4V97uO+
   wKRu7AllNHNl6Ga6o0U0WCt8FXfDS6xDvSklw0mq+EDeiwc4zbjsxSSxv
   ZxaHmM5JHLO2G3ZDSa/q2OtehTs79hQLhQI+rotVpkXROEUc8Oj5zV5J8
   NRFRpN1AOU0bB/h8e5VI3SA5iuxxVTYvsfNv5VRV5/aV/4KzaSe9FTXgB
   g==;
X-CSE-ConnectionGUID: QgWmv6OxSx69aV88BN4QiQ==
X-CSE-MsgGUID: 0EDFWW1ZTeeBmyAKO2WtJw==
X-IronPort-AV: E=McAfee;i="6800,10657,11719"; a="61354510"
X-IronPort-AV: E=Sophos;i="6.23,325,1770624000"; 
   d="scan'208";a="61354510"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2026 01:00:01 -0800
X-CSE-ConnectionGUID: GQpnDNVBROeed6jqX0oj3w==
X-CSE-MsgGUID: K6a7loGUS6Orf+n+qlWTgg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,325,1770624000"; 
   d="scan'208";a="215451036"
Received: from dmr-bkc.iind.intel.com ([10.49.14.189])
  by fmviesa006.fm.intel.com with ESMTP; 05 Mar 2026 00:59:59 -0800
From: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com
Subject: [PATCH 2/2] crypto: qat - fix firmware loading failure for GEN6 devices
Date: Thu,  5 Mar 2026 08:58:59 +0000
Message-ID: <20260305085955.66293-3-suman.kumar.chakraborty@intel.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260305085955.66293-1-suman.kumar.chakraborty@intel.com>
References: <20260305085955.66293-1-suman.kumar.chakraborty@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

QAT GEN6 hardware requires a minimum 3 us delay during the acceleration
engine reset sequence to ensure the hardware fully settles.
Without this delay, the firmware load may fail intermittently.

Add a delay after placing the AE into reset and before clearing the reset,
matching the hardware requirements and ensuring stable firmware loading.
Earlier generations remain unaffected.

Fixes: 17fd7514ae68 ("crypto: qat - add qat_6xxx driver")
Signed-off-by: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
Cc: stable@vger.kernel.org
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
---
 drivers/crypto/intel/qat/qat_common/adf_accel_engine.c     | 7 +++++++
 .../crypto/intel/qat/qat_common/icp_qat_fw_loader_handle.h | 1 +
 drivers/crypto/intel/qat/qat_common/qat_hal.c              | 5 ++++-
 3 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_accel_engine.c b/drivers/crypto/intel/qat/qat_common/adf_accel_engine.c
index f9f1018a2823..09d4f547e082 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_accel_engine.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_accel_engine.c
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: (BSD-3-Clause OR GPL-2.0-only)
 /* Copyright(c) 2014 - 2020 Intel Corporation */
+#include <linux/delay.h>
 #include <linux/firmware.h>
 #include <linux/pci.h>
 #include "adf_cfg.h"
@@ -162,8 +163,14 @@ int adf_ae_stop(struct adf_accel_dev *accel_dev)
 static int adf_ae_reset(struct adf_accel_dev *accel_dev, int ae)
 {
 	struct adf_fw_loader_data *loader_data = accel_dev->fw_loader;
+	unsigned long reset_delay;
 
 	qat_hal_reset(loader_data->fw_loader);
+
+	reset_delay = loader_data->fw_loader->chip_info->reset_delay_us;
+	if (reset_delay)
+		fsleep(reset_delay);
+
 	if (qat_hal_clr_reset(loader_data->fw_loader))
 		return -EFAULT;
 
diff --git a/drivers/crypto/intel/qat/qat_common/icp_qat_fw_loader_handle.h b/drivers/crypto/intel/qat/qat_common/icp_qat_fw_loader_handle.h
index 6887930c7995..e74cafa95f1c 100644
--- a/drivers/crypto/intel/qat/qat_common/icp_qat_fw_loader_handle.h
+++ b/drivers/crypto/intel/qat/qat_common/icp_qat_fw_loader_handle.h
@@ -27,6 +27,7 @@ struct icp_qat_fw_loader_chip_info {
 	int mmp_sram_size;
 	bool nn;
 	bool lm2lm3;
+	u16 reset_delay_us;
 	u32 lm_size;
 	u32 icp_rst_csr;
 	u32 icp_rst_mask;
diff --git a/drivers/crypto/intel/qat/qat_common/qat_hal.c b/drivers/crypto/intel/qat/qat_common/qat_hal.c
index 0f5a2690690a..1c3d1311f1c7 100644
--- a/drivers/crypto/intel/qat/qat_common/qat_hal.c
+++ b/drivers/crypto/intel/qat/qat_common/qat_hal.c
@@ -20,6 +20,7 @@
 #define RST_CSR_QAT_LSB			20
 #define RST_CSR_AE_LSB			0
 #define MC_TIMESTAMP_ENABLE		(0x1 << 7)
+#define MIN_RESET_DELAY_US		3
 
 #define IGNORE_W1C_MASK ((~(1 << CE_BREAKPOINT_BITPOS)) & \
 	(~(1 << CE_CNTL_STORE_PARITY_ERROR_BITPOS)) & \
@@ -713,8 +714,10 @@ static int qat_hal_chip_init(struct icp_qat_fw_loader_handle *handle,
 		handle->chip_info->wakeup_event_val = 0x80000000;
 		handle->chip_info->fw_auth = true;
 		handle->chip_info->css_3k = true;
-		if (handle->pci_dev->device == PCI_DEVICE_ID_INTEL_QAT_6XXX)
+		if (handle->pci_dev->device == PCI_DEVICE_ID_INTEL_QAT_6XXX) {
 			handle->chip_info->dual_sign = true;
+			handle->chip_info->reset_delay_us = MIN_RESET_DELAY_US;
+		}
 		handle->chip_info->tgroup_share_ustore = true;
 		handle->chip_info->fcu_ctl_csr = FCU_CONTROL_4XXX;
 		handle->chip_info->fcu_sts_csr = FCU_STATUS_4XXX;
-- 
2.52.0

