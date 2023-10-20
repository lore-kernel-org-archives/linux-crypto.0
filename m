Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54116CDB47E
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Oct 2023 10:35:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376746AbjJTKfG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Oct 2023 06:35:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376802AbjJTKfF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Oct 2023 06:35:05 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8FB91BF
        for <linux-crypto@vger.kernel.org>; Fri, 20 Oct 2023 03:35:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697798103; x=1729334103;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=x3aAmiDC8jWzMl4/DeOUdh7crlAiyQNc6SOAVj4z37Y=;
  b=ieesQeOrlpaZDKNw3P/izYPoB36tK/bjIujHk//OFfWue2hW1Gme+8P3
   rUumYF1/tLVXIV6xDhLFFC4aOnVEyCCxu0RqgN6NY/pcyEAYvwPj+Caau
   Yigzps509U4qM7IGg0Fr1JweeW5kh0KnXWvLOEDhlQCKL+1rfo086uiUJ
   BmKeqrva3yXTsS0jFMGUWzxX7B7SZWFLqPgNCERlVh7KUBM8nYu3612Tp
   9tn+QWvJWjNbF7sjKM9EWtSm4uMyUWiKSc7RU/5PjOYZb2BsHieKC6pFM
   /9UdrVJBbBnbQMnZm8oeWosUVNSkDWsP5UQK9dXZYJYFViWNVnO3dfFyX
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10868"; a="383686700"
X-IronPort-AV: E=Sophos;i="6.03,238,1694761200"; 
   d="scan'208";a="383686700"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2023 03:35:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10868"; a="792369918"
X-IronPort-AV: E=Sophos;i="6.03,238,1694761200"; 
   d="scan'208";a="792369918"
Received: from fl31ca105gs0706.deacluster.intel.com (HELO fl31ca105gs0706..) ([10.45.133.167])
  by orsmga001.jf.intel.com with ESMTP; 20 Oct 2023 03:35:02 -0700
From:   Shashank Gupta <shashank.gupta@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Shashank Gupta <shashank.gupta@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Tero Kristo <tero.kristo@linux.intel.com>
Subject: [PATCH 1/9] crypto: qat - add infrastructure for error reporting
Date:   Fri, 20 Oct 2023 11:32:45 +0100
Message-ID: <20231020103431.230671-2-shashank.gupta@intel.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231020103431.230671-1-shashank.gupta@intel.com>
References: <20231020103431.230671-1-shashank.gupta@intel.com>
MIME-Version: 1.0
Organization: Intel Technology Poland sp. z o.o. - ul. Slowackiego 173, 80-298 Gdansk - KRS 101882 - NIP 957-07-52-316
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add infrastructure for enabling, disabling and reporting errors in the QAT
driver. This adds a new structure, adf_ras_ops, to adf_hw_device_data that
contains the following methods:
  - enable_ras_errors(): allows to enable RAS errors at device
    initialization.
  - disable_ras_errors(): allows to disable RAS errors at device shutdown.
  - handle_interrupt(): allows to detect if there is an error and report if
    a reset is required. This is executed immediately after the error is
    reported, in the context of an ISR.

An initial, empty, implementation of the methods above is provided
for QAT GEN4.

Signed-off-by: Shashank Gupta <shashank.gupta@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Tero Kristo <tero.kristo@linux.intel.com>
---
 .../intel/qat/qat_4xxx/adf_4xxx_hw_data.c     |  2 ++
 drivers/crypto/intel/qat/qat_common/Makefile  |  1 +
 .../intel/qat/qat_common/adf_accel_devices.h  |  8 ++++++
 .../intel/qat/qat_common/adf_gen4_ras.c       | 26 +++++++++++++++++++
 .../intel/qat/qat_common/adf_gen4_ras.h       | 10 +++++++
 .../crypto/intel/qat/qat_common/adf_init.c    |  6 +++++
 drivers/crypto/intel/qat/qat_common/adf_isr.c | 18 +++++++++++++
 7 files changed, 71 insertions(+)
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_gen4_ras.c
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_gen4_ras.h

diff --git a/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c b/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
index 12b5d1819111..671e32c93160 100644
--- a/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
@@ -9,6 +9,7 @@
 #include <adf_gen4_hw_data.h>
 #include <adf_gen4_pfvf.h>
 #include <adf_gen4_pm.h>
+#include "adf_gen4_ras.h"
 #include <adf_gen4_timer.h>
 #include "adf_4xxx_hw_data.h"
 #include "adf_cfg_services.h"
@@ -541,6 +542,7 @@ void adf_init_hw_data_4xxx(struct adf_hw_device_data *hw_data, u32 dev_id)
 	adf_gen4_init_hw_csr_ops(&hw_data->csr_ops);
 	adf_gen4_init_pf_pfvf_ops(&hw_data->pfvf_ops);
 	adf_gen4_init_dc_ops(&hw_data->dc_ops);
+	adf_gen4_init_ras_ops(&hw_data->ras_ops);
 }
 
 void adf_clean_hw_data_4xxx(struct adf_hw_device_data *hw_data)
diff --git a/drivers/crypto/intel/qat/qat_common/Makefile b/drivers/crypto/intel/qat/qat_common/Makefile
index 204c7d0aa31e..151fd3c01f62 100644
--- a/drivers/crypto/intel/qat/qat_common/Makefile
+++ b/drivers/crypto/intel/qat/qat_common/Makefile
@@ -18,6 +18,7 @@ intel_qat-objs := adf_cfg.o \
 	adf_gen4_pm.o \
 	adf_gen2_dc.o \
 	adf_gen4_dc.o \
+	adf_gen4_ras.o \
 	adf_gen4_timer.o \
 	adf_clock.o \
 	qat_crypto.o \
diff --git a/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h b/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h
index 9677c8e0f180..a62419479184 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h
@@ -152,6 +152,13 @@ struct adf_accel_dev;
 struct adf_etr_data;
 struct adf_etr_ring_data;
 
+struct adf_ras_ops {
+	void (*enable_ras_errors)(struct adf_accel_dev *accel_dev);
+	void (*disable_ras_errors)(struct adf_accel_dev *accel_dev);
+	bool (*handle_interrupt)(struct adf_accel_dev *accel_dev,
+				 bool *reset_required);
+};
+
 struct adf_pfvf_ops {
 	int (*enable_comms)(struct adf_accel_dev *accel_dev);
 	u32 (*get_pf2vf_offset)(u32 i);
@@ -214,6 +221,7 @@ struct adf_hw_device_data {
 	struct adf_pfvf_ops pfvf_ops;
 	struct adf_hw_csr_ops csr_ops;
 	struct adf_dc_ops dc_ops;
+	struct adf_ras_ops ras_ops;
 	const char *fw_name;
 	const char *fw_mmp_name;
 	u32 fuses;
diff --git a/drivers/crypto/intel/qat/qat_common/adf_gen4_ras.c b/drivers/crypto/intel/qat/qat_common/adf_gen4_ras.c
new file mode 100644
index 000000000000..0bf243a51527
--- /dev/null
+++ b/drivers/crypto/intel/qat/qat_common/adf_gen4_ras.c
@@ -0,0 +1,26 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright(c) 2023 Intel Corporation */
+#include "adf_common_drv.h"
+#include "adf_gen4_ras.h"
+
+static void adf_gen4_enable_ras(struct adf_accel_dev *accel_dev)
+{
+}
+
+static void adf_gen4_disable_ras(struct adf_accel_dev *accel_dev)
+{
+}
+
+static bool adf_gen4_handle_interrupt(struct adf_accel_dev *accel_dev,
+				      bool *reset_required)
+{
+	return false;
+}
+
+void adf_gen4_init_ras_ops(struct adf_ras_ops *ras_ops)
+{
+	ras_ops->enable_ras_errors = adf_gen4_enable_ras;
+	ras_ops->disable_ras_errors = adf_gen4_disable_ras;
+	ras_ops->handle_interrupt = adf_gen4_handle_interrupt;
+}
+EXPORT_SYMBOL_GPL(adf_gen4_init_ras_ops);
diff --git a/drivers/crypto/intel/qat/qat_common/adf_gen4_ras.h b/drivers/crypto/intel/qat/qat_common/adf_gen4_ras.h
new file mode 100644
index 000000000000..2765d3529c0d
--- /dev/null
+++ b/drivers/crypto/intel/qat/qat_common/adf_gen4_ras.h
@@ -0,0 +1,10 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/* Copyright(c) 2023 Intel Corporation */
+#ifndef ADF_GEN4_RAS_H_
+#define ADF_GEN4_RAS_H_
+
+struct adf_ras_ops;
+
+void adf_gen4_init_ras_ops(struct adf_ras_ops *ras_ops);
+
+#endif /* ADF_GEN4_RAS_H_ */
diff --git a/drivers/crypto/intel/qat/qat_common/adf_init.c b/drivers/crypto/intel/qat/qat_common/adf_init.c
index bccd6bf8cf63..b3cf0720cf9a 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_init.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_init.c
@@ -116,6 +116,9 @@ static int adf_dev_init(struct adf_accel_dev *accel_dev)
 	}
 	set_bit(ADF_STATUS_IRQ_ALLOCATED, &accel_dev->status);
 
+	if (hw_data->ras_ops.enable_ras_errors)
+		hw_data->ras_ops.enable_ras_errors(accel_dev);
+
 	hw_data->enable_ints(accel_dev);
 	hw_data->enable_error_correction(accel_dev);
 
@@ -350,6 +353,9 @@ static void adf_dev_shutdown(struct adf_accel_dev *accel_dev)
 			clear_bit(accel_dev->accel_id, service->init_status);
 	}
 
+	if (hw_data->ras_ops.disable_ras_errors)
+		hw_data->ras_ops.disable_ras_errors(accel_dev);
+
 	adf_heartbeat_shutdown(accel_dev);
 
 	hw_data->disable_iov(accel_dev);
diff --git a/drivers/crypto/intel/qat/qat_common/adf_isr.c b/drivers/crypto/intel/qat/qat_common/adf_isr.c
index 2aba194a7c29..3557a0d6dea2 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_isr.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_isr.c
@@ -132,6 +132,21 @@ static bool adf_handle_pm_int(struct adf_accel_dev *accel_dev)
 	return false;
 }
 
+static bool adf_handle_ras_int(struct adf_accel_dev *accel_dev)
+{
+	struct adf_ras_ops *ras_ops = &accel_dev->hw_device->ras_ops;
+	bool reset_required;
+
+	if (ras_ops->handle_interrupt &&
+	    ras_ops->handle_interrupt(accel_dev, &reset_required)) {
+		if (reset_required)
+			dev_err(&GET_DEV(accel_dev), "Fatal error, reset required\n");
+		return true;
+	}
+
+	return false;
+}
+
 static irqreturn_t adf_msix_isr_ae(int irq, void *dev_ptr)
 {
 	struct adf_accel_dev *accel_dev = dev_ptr;
@@ -145,6 +160,9 @@ static irqreturn_t adf_msix_isr_ae(int irq, void *dev_ptr)
 	if (adf_handle_pm_int(accel_dev))
 		return IRQ_HANDLED;
 
+	if (adf_handle_ras_int(accel_dev))
+		return IRQ_HANDLED;
+
 	dev_dbg(&GET_DEV(accel_dev), "qat_dev%d spurious AE interrupt\n",
 		accel_dev->accel_id);
 
-- 
2.41.0

