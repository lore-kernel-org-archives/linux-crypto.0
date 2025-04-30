Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7908525A2D5
	for <linux-crypto@vger.kernel.org>; Wed, 30 Apr 2025 11:35:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746012906; cv=none; b=FuTAMNkZtz3tM0l2aPrLcyy2Mtl/R0tGoMALXEz2VE79Eh1LYjkSuPHaQvecP1TeUYTG+iLiDuZRyKx6xiHRrIWMaEdrCJrYuwiGrjP/G7ldABgNeOFzdkql+akAJVcvGBnJ0VemlvfgHlXpU4xpg5uTpyWbBfrFP0MmTGy8QaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746012906; c=relaxed/simple;
	bh=N9RUB1MDGzwBCeWkiryBl8d8kEaV9FW93f6nyYo5vDc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=EtnywcOEIfk9wxXm4B8Vmfnx7qKmBmqdhR7Ar4eYcJo5pgvbawbb7UgJy19TDiG4LCibezNRoFwbA2rsB2QGVUYp4IvEEABsSYPpAe1hWIGrRLpxHeG+z8z+MZURvo64O8DUxANWhSWtaPZrT1fggjAMhnBaI63wLXMRDshVTWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=a78nIYn7; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="a78nIYn7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746012904; x=1777548904;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=N9RUB1MDGzwBCeWkiryBl8d8kEaV9FW93f6nyYo5vDc=;
  b=a78nIYn7E1XeAFDIl2+SI6c55Xbk3smIe4GERJ4thaD5MjyZCy7ck2E+
   VWVsvBS3vsUAX9svGfAPlgKon9eMYE8UUwWz321AiFPfNvwM5zexhH/Gj
   A3nClSD4G/V6dIjLwSn3fPqXBZKHDrDyIJyp6wiCQSA50/eqwOINLC/dd
   0awWcDCj+UlOylBISGOMCHnwSxuuLPIJgtl3ij+F8uaQqy0saI3/SoNlG
   xPYZoH80e+HI/8zMQImMWL5RNba6YcLUPftFRMT0MroyTWCE/LsovIriQ
   8tuXTEsGM3NPVMqZ3ylKNY28GQVqujeztuHgW+b1md0ZnjPh781Ay/5Gm
   w==;
X-CSE-ConnectionGUID: ys+9br5YSIm+rKHWQ6kLFQ==
X-CSE-MsgGUID: pWpz+d1FQcyQGueref7giw==
X-IronPort-AV: E=McAfee;i="6700,10204,11418"; a="51331133"
X-IronPort-AV: E=Sophos;i="6.15,251,1739865600"; 
   d="scan'208";a="51331133"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2025 04:35:04 -0700
X-CSE-ConnectionGUID: nSHs2EARQumdVRBDRffofA==
X-CSE-MsgGUID: QskSHKkTT9G4eXyn2MYglQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,251,1739865600"; 
   d="scan'208";a="133812509"
Received: from t21-qat.iind.intel.com ([10.49.15.35])
  by orviesa009.jf.intel.com with ESMTP; 30 Apr 2025 04:35:02 -0700
From: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com
Subject: [PATCH 01/11] crypto: qat - rename and relocate timer logic
Date: Wed, 30 Apr 2025 12:34:43 +0100
Message-Id: <20250430113453.1587497-2-suman.kumar.chakraborty@intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20250430113453.1587497-1-suman.kumar.chakraborty@intel.com>
References: <20250430113453.1587497-1-suman.kumar.chakraborty@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: George Abraham P <george.abraham.p@intel.com>

Rename adf_gen4_timer.c to adf_timer.c and adf_gen4_timer.h to
adf_timer.h to make the files generation-agnostic. This includes
renaming the start() and stop() timer APIs and macro definitions
to be generic, allowing for reuse across different device
generations.
This does not introduce any functional changes.

Signed-off-by: George Abraham P <george.abraham.p@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 .../intel/qat/qat_420xx/adf_420xx_hw_data.c    |  6 +++---
 .../intel/qat/qat_4xxx/adf_4xxx_hw_data.c      |  6 +++---
 drivers/crypto/intel/qat/qat_common/Makefile   |  2 +-
 .../{adf_gen4_timer.c => adf_timer.c}          | 18 +++++++++---------
 .../{adf_gen4_timer.h => adf_timer.h}          | 10 +++++-----
 5 files changed, 21 insertions(+), 21 deletions(-)
 rename drivers/crypto/intel/qat/qat_common/{adf_gen4_timer.c => adf_timer.c} (78%)
 rename drivers/crypto/intel/qat/qat_common/{adf_gen4_timer.h => adf_timer.h} (58%)

diff --git a/drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c b/drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c
index 795f4598400b..5817b3164185 100644
--- a/drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c
@@ -15,9 +15,9 @@
 #include <adf_gen4_pfvf.h>
 #include <adf_gen4_pm.h>
 #include <adf_gen4_ras.h>
-#include <adf_gen4_timer.h>
 #include <adf_gen4_tl.h>
 #include <adf_gen4_vf_mig.h>
+#include <adf_timer.h>
 #include "adf_420xx_hw_data.h"
 #include "icp_qat_hw.h"
 
@@ -468,8 +468,8 @@ void adf_init_hw_data_420xx(struct adf_hw_device_data *hw_data, u32 dev_id)
 	hw_data->enable_pm = adf_gen4_enable_pm;
 	hw_data->handle_pm_interrupt = adf_gen4_handle_pm_interrupt;
 	hw_data->dev_config = adf_gen4_dev_config;
-	hw_data->start_timer = adf_gen4_timer_start;
-	hw_data->stop_timer = adf_gen4_timer_stop;
+	hw_data->start_timer = adf_timer_start;
+	hw_data->stop_timer = adf_timer_stop;
 	hw_data->get_hb_clock = adf_gen4_get_heartbeat_clock;
 	hw_data->num_hb_ctrs = ADF_NUM_HB_CNT_PER_AE;
 	hw_data->clock_frequency = ADF_420XX_AE_FREQ;
diff --git a/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c b/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
index 7d4c366aa8b2..2d89d4a3a7b9 100644
--- a/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
@@ -15,9 +15,9 @@
 #include <adf_gen4_pfvf.h>
 #include <adf_gen4_pm.h>
 #include "adf_gen4_ras.h"
-#include <adf_gen4_timer.h>
 #include <adf_gen4_tl.h>
 #include <adf_gen4_vf_mig.h>
+#include <adf_timer.h>
 #include "adf_4xxx_hw_data.h"
 #include "icp_qat_hw.h"
 
@@ -454,8 +454,8 @@ void adf_init_hw_data_4xxx(struct adf_hw_device_data *hw_data, u32 dev_id)
 	hw_data->enable_pm = adf_gen4_enable_pm;
 	hw_data->handle_pm_interrupt = adf_gen4_handle_pm_interrupt;
 	hw_data->dev_config = adf_gen4_dev_config;
-	hw_data->start_timer = adf_gen4_timer_start;
-	hw_data->stop_timer = adf_gen4_timer_stop;
+	hw_data->start_timer = adf_timer_start;
+	hw_data->stop_timer = adf_timer_stop;
 	hw_data->get_hb_clock = adf_gen4_get_heartbeat_clock;
 	hw_data->num_hb_ctrs = ADF_NUM_HB_CNT_PER_AE;
 	hw_data->clock_frequency = ADF_4XXX_AE_FREQ;
diff --git a/drivers/crypto/intel/qat/qat_common/Makefile b/drivers/crypto/intel/qat/qat_common/Makefile
index af5df29fd2e3..0370eaad42b1 100644
--- a/drivers/crypto/intel/qat/qat_common/Makefile
+++ b/drivers/crypto/intel/qat/qat_common/Makefile
@@ -19,7 +19,6 @@ intel_qat-y := adf_accel_engine.o \
 	adf_gen4_hw_data.o \
 	adf_gen4_pm.o \
 	adf_gen4_ras.o \
-	adf_gen4_timer.o \
 	adf_gen4_vf_mig.o \
 	adf_hw_arbiter.o \
 	adf_init.o \
@@ -30,6 +29,7 @@ intel_qat-y := adf_accel_engine.o \
 	adf_sysfs.o \
 	adf_sysfs_ras_counters.o \
 	adf_sysfs_rl.o \
+	adf_timer.o \
 	adf_transport.o \
 	qat_algs.o \
 	qat_algs_send.o \
diff --git a/drivers/crypto/intel/qat/qat_common/adf_gen4_timer.c b/drivers/crypto/intel/qat/qat_common/adf_timer.c
similarity index 78%
rename from drivers/crypto/intel/qat/qat_common/adf_gen4_timer.c
rename to drivers/crypto/intel/qat/qat_common/adf_timer.c
index 35ccb91d6ec1..8962a49f145a 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_gen4_timer.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_timer.c
@@ -12,9 +12,9 @@
 #include "adf_admin.h"
 #include "adf_accel_devices.h"
 #include "adf_common_drv.h"
-#include "adf_gen4_timer.h"
+#include "adf_timer.h"
 
-#define ADF_GEN4_TIMER_PERIOD_MS 200
+#define ADF_DEFAULT_TIMER_PERIOD_MS 200
 
 /* This periodic update is used to trigger HB, RL & TL fw events */
 static void work_handler(struct work_struct *work)
@@ -27,16 +27,16 @@ static void work_handler(struct work_struct *work)
 	accel_dev = timer_ctx->accel_dev;
 
 	adf_misc_wq_queue_delayed_work(&timer_ctx->work_ctx,
-				       msecs_to_jiffies(ADF_GEN4_TIMER_PERIOD_MS));
+				       msecs_to_jiffies(ADF_DEFAULT_TIMER_PERIOD_MS));
 
 	time_periods = div_u64(ktime_ms_delta(ktime_get_real(), timer_ctx->initial_ktime),
-			       ADF_GEN4_TIMER_PERIOD_MS);
+			       ADF_DEFAULT_TIMER_PERIOD_MS);
 
 	if (adf_send_admin_tim_sync(accel_dev, time_periods))
 		dev_err(&GET_DEV(accel_dev), "Failed to synchronize qat timer\n");
 }
 
-int adf_gen4_timer_start(struct adf_accel_dev *accel_dev)
+int adf_timer_start(struct adf_accel_dev *accel_dev)
 {
 	struct adf_timer *timer_ctx;
 
@@ -50,13 +50,13 @@ int adf_gen4_timer_start(struct adf_accel_dev *accel_dev)
 
 	INIT_DELAYED_WORK(&timer_ctx->work_ctx, work_handler);
 	adf_misc_wq_queue_delayed_work(&timer_ctx->work_ctx,
-				       msecs_to_jiffies(ADF_GEN4_TIMER_PERIOD_MS));
+				       msecs_to_jiffies(ADF_DEFAULT_TIMER_PERIOD_MS));
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(adf_gen4_timer_start);
+EXPORT_SYMBOL_GPL(adf_timer_start);
 
-void adf_gen4_timer_stop(struct adf_accel_dev *accel_dev)
+void adf_timer_stop(struct adf_accel_dev *accel_dev)
 {
 	struct adf_timer *timer_ctx = accel_dev->timer;
 
@@ -68,4 +68,4 @@ void adf_gen4_timer_stop(struct adf_accel_dev *accel_dev)
 	kfree(timer_ctx);
 	accel_dev->timer = NULL;
 }
-EXPORT_SYMBOL_GPL(adf_gen4_timer_stop);
+EXPORT_SYMBOL_GPL(adf_timer_stop);
diff --git a/drivers/crypto/intel/qat/qat_common/adf_gen4_timer.h b/drivers/crypto/intel/qat/qat_common/adf_timer.h
similarity index 58%
rename from drivers/crypto/intel/qat/qat_common/adf_gen4_timer.h
rename to drivers/crypto/intel/qat/qat_common/adf_timer.h
index 66a709e7b358..68e5136d6ba1 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_gen4_timer.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_timer.h
@@ -1,8 +1,8 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
 /* Copyright(c) 2023 Intel Corporation */
 
-#ifndef ADF_GEN4_TIMER_H_
-#define ADF_GEN4_TIMER_H_
+#ifndef ADF_TIMER_H_
+#define ADF_TIMER_H_
 
 #include <linux/ktime.h>
 #include <linux/workqueue.h>
@@ -15,7 +15,7 @@ struct adf_timer {
 	ktime_t initial_ktime;
 };
 
-int adf_gen4_timer_start(struct adf_accel_dev *accel_dev);
-void adf_gen4_timer_stop(struct adf_accel_dev *accel_dev);
+int adf_timer_start(struct adf_accel_dev *accel_dev);
+void adf_timer_stop(struct adf_accel_dev *accel_dev);
 
-#endif /* ADF_GEN4_TIMER_H_ */
+#endif /* ADF_TIMER_H_ */
-- 
2.40.1

