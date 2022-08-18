Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7370CC32772
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Aug 2022 18:02:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344050AbiHRSB6 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 18 Aug 2022 14:01:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244629AbiHRSBw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Aug 2022 14:01:52 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAA29C6CFA
        for <linux-crypto@vger.kernel.org>; Thu, 18 Aug 2022 11:01:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660845710; x=1692381710;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HJS1dh1XUHqq7LHWERS6JYf4IfUghKA/GKkSxKbWxvc=;
  b=S83O3+kRfc+XjjA+QrFXb6Ts/JpncmDLyaILIUrKi27l4odLlfOLNMml
   vVYw8eo9Af1iF7REksXm5bHxvF3MszVFB6ciYY7X2L3/o9w+p1au093/R
   4vjhcf+weG8EoMlVrFDVM7P0iCUocTIuzr/43J8pRdw/6SCyuswJz9fHo
   UljtYRytxpX8uSBaOunzbrmLgsbwCmgmHinV+XFs3NhzG9g0zszgQmpjI
   bboy0TZHEvIbpA9WvUt7t0lEBSRpPIbnzCwTyM/Ea02VO+mfZvfH2OaAC
   ytKwI4k2gjwygWQBs/GO8NSswblGBwfrI0HCA2mwVgGRdjOJ1IJC/BYqY
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10443"; a="294109472"
X-IronPort-AV: E=Sophos;i="5.93,247,1654585200"; 
   d="scan'208";a="294109472"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2022 11:01:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,247,1654585200"; 
   d="scan'208";a="607919608"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.76])
  by orsmga002.jf.intel.com with ESMTP; 18 Aug 2022 11:01:49 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Vlad Dronov <vdronov@redhat.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>,
        Adam Guerin <adam.guerin@intel.com>
Subject: [PATCH 7/9] crypto: qat - rename and relocate GEN2 config function
Date:   Thu, 18 Aug 2022 19:01:18 +0100
Message-Id: <20220818180120.63452-8-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220818180120.63452-1-giovanni.cabiddu@intel.com>
References: <20220818180120.63452-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Rename qat_crypto_dev_config() in adf_gen2_dev_config() and relocate it
to the newly created file adf_gen2_config.c.
This function is specific to QAT GEN2 devices and will be used also to
configure the compression service.

In addition change the drivers to use the dev_config() in the hardware
data structure (which for GEN2 devices now points to
adf_gen2_dev_config()), for consistency.

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Wojciech Ziemba <wojciech.ziemba@intel.com>
Reviewed-by: Adam Guerin <adam.guerin@intel.com>
---
 .../crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c  |   2 +
 drivers/crypto/qat/qat_c3xxx/adf_drv.c        |   2 +-
 .../qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.c     |   2 +
 .../crypto/qat/qat_c62x/adf_c62x_hw_data.c    |   2 +
 drivers/crypto/qat/qat_c62x/adf_drv.c         |   2 +-
 .../qat/qat_c62xvf/adf_c62xvf_hw_data.c       |   2 +
 drivers/crypto/qat/qat_common/Makefile        |   1 +
 .../crypto/qat/qat_common/adf_common_drv.h    |   1 -
 .../crypto/qat/qat_common/adf_gen2_config.c   | 131 ++++++++++++++++++
 .../crypto/qat/qat_common/adf_gen2_config.h   |  10 ++
 drivers/crypto/qat/qat_common/qat_crypto.c    | 120 +---------------
 .../qat/qat_dh895xcc/adf_dh895xcc_hw_data.c   |   2 +
 drivers/crypto/qat/qat_dh895xcc/adf_drv.c     |   2 +-
 .../qat_dh895xccvf/adf_dh895xccvf_hw_data.c   |   2 +
 14 files changed, 158 insertions(+), 123 deletions(-)
 create mode 100644 drivers/crypto/qat/qat_common/adf_gen2_config.c
 create mode 100644 drivers/crypto/qat/qat_common/adf_gen2_config.h

diff --git a/drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c b/drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c
index 50d5afa26a9b..c0519a79060a 100644
--- a/drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c
+++ b/drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c
@@ -2,6 +2,7 @@
 /* Copyright(c) 2014 - 2021 Intel Corporation */
 #include <adf_accel_devices.h>
 #include <adf_common_drv.h>
+#include <adf_gen2_config.h>
 #include <adf_gen2_hw_data.h>
 #include <adf_gen2_pfvf.h>
 #include "adf_c3xxx_hw_data.h"
@@ -124,6 +125,7 @@ void adf_init_hw_data_c3xxx(struct adf_hw_device_data *hw_data)
 	hw_data->reset_device = adf_reset_flr;
 	hw_data->set_ssm_wdtimer = adf_gen2_set_ssm_wdtimer;
 	hw_data->disable_iov = adf_disable_sriov;
+	hw_data->dev_config = adf_gen2_dev_config;
 
 	adf_gen2_init_pf_pfvf_ops(&hw_data->pfvf_ops);
 	adf_gen2_init_hw_csr_ops(&hw_data->csr_ops);
diff --git a/drivers/crypto/qat/qat_c3xxx/adf_drv.c b/drivers/crypto/qat/qat_c3xxx/adf_drv.c
index 2aef0bb791df..1f4fbf4562b2 100644
--- a/drivers/crypto/qat/qat_c3xxx/adf_drv.c
+++ b/drivers/crypto/qat/qat_c3xxx/adf_drv.c
@@ -201,7 +201,7 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto out_err_disable_aer;
 	}
 
-	ret = qat_crypto_dev_config(accel_dev);
+	ret = hw_data->dev_config(accel_dev);
 	if (ret)
 		goto out_err_disable_aer;
 
diff --git a/drivers/crypto/qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.c b/drivers/crypto/qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.c
index a9fbe57b32ae..6c37dda6da2e 100644
--- a/drivers/crypto/qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.c
+++ b/drivers/crypto/qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.c
@@ -2,6 +2,7 @@
 /* Copyright(c) 2015 - 2021 Intel Corporation */
 #include <adf_accel_devices.h>
 #include <adf_common_drv.h>
+#include <adf_gen2_config.h>
 #include <adf_gen2_hw_data.h>
 #include <adf_gen2_pfvf.h>
 #include <adf_pfvf_vf_msg.h>
@@ -86,6 +87,7 @@ void adf_init_hw_data_c3xxxiov(struct adf_hw_device_data *hw_data)
 	hw_data->get_sku = get_sku;
 	hw_data->enable_ints = adf_vf_void_noop;
 	hw_data->dev_class->instances++;
+	hw_data->dev_config = adf_gen2_dev_config;
 	adf_devmgr_update_class_index(hw_data);
 	adf_gen2_init_vf_pfvf_ops(&hw_data->pfvf_ops);
 	adf_gen2_init_hw_csr_ops(&hw_data->csr_ops);
diff --git a/drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.c b/drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.c
index c00386fe6587..689358cb7bb0 100644
--- a/drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.c
+++ b/drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.c
@@ -2,6 +2,7 @@
 /* Copyright(c) 2014 - 2021 Intel Corporation */
 #include <adf_accel_devices.h>
 #include <adf_common_drv.h>
+#include <adf_gen2_config.h>
 #include <adf_gen2_hw_data.h>
 #include <adf_gen2_pfvf.h>
 #include "adf_c62x_hw_data.h"
@@ -126,6 +127,7 @@ void adf_init_hw_data_c62x(struct adf_hw_device_data *hw_data)
 	hw_data->reset_device = adf_reset_flr;
 	hw_data->set_ssm_wdtimer = adf_gen2_set_ssm_wdtimer;
 	hw_data->disable_iov = adf_disable_sriov;
+	hw_data->dev_config = adf_gen2_dev_config;
 
 	adf_gen2_init_pf_pfvf_ops(&hw_data->pfvf_ops);
 	adf_gen2_init_hw_csr_ops(&hw_data->csr_ops);
diff --git a/drivers/crypto/qat/qat_c62x/adf_drv.c b/drivers/crypto/qat/qat_c62x/adf_drv.c
index 56163083f161..4ccaf298250c 100644
--- a/drivers/crypto/qat/qat_c62x/adf_drv.c
+++ b/drivers/crypto/qat/qat_c62x/adf_drv.c
@@ -201,7 +201,7 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto out_err_disable_aer;
 	}
 
-	ret = qat_crypto_dev_config(accel_dev);
+	ret = hw_data->dev_config(accel_dev);
 	if (ret)
 		goto out_err_disable_aer;
 
diff --git a/drivers/crypto/qat/qat_c62xvf/adf_c62xvf_hw_data.c b/drivers/crypto/qat/qat_c62xvf/adf_c62xvf_hw_data.c
index 0282038fca54..521110ecd07f 100644
--- a/drivers/crypto/qat/qat_c62xvf/adf_c62xvf_hw_data.c
+++ b/drivers/crypto/qat/qat_c62xvf/adf_c62xvf_hw_data.c
@@ -2,6 +2,7 @@
 /* Copyright(c) 2015 - 2021 Intel Corporation */
 #include <adf_accel_devices.h>
 #include <adf_common_drv.h>
+#include <adf_gen2_config.h>
 #include <adf_gen2_hw_data.h>
 #include <adf_gen2_pfvf.h>
 #include <adf_pfvf_vf_msg.h>
@@ -86,6 +87,7 @@ void adf_init_hw_data_c62xiov(struct adf_hw_device_data *hw_data)
 	hw_data->get_sku = get_sku;
 	hw_data->enable_ints = adf_vf_void_noop;
 	hw_data->dev_class->instances++;
+	hw_data->dev_config = adf_gen2_dev_config;
 	adf_devmgr_update_class_index(hw_data);
 	adf_gen2_init_vf_pfvf_ops(&hw_data->pfvf_ops);
 	adf_gen2_init_hw_csr_ops(&hw_data->csr_ops);
diff --git a/drivers/crypto/qat/qat_common/Makefile b/drivers/crypto/qat/qat_common/Makefile
index b0587d03eac2..b59b6315134b 100644
--- a/drivers/crypto/qat/qat_common/Makefile
+++ b/drivers/crypto/qat/qat_common/Makefile
@@ -12,6 +12,7 @@ intel_qat-objs := adf_cfg.o \
 	adf_hw_arbiter.o \
 	adf_sysfs.o \
 	adf_gen2_hw_data.o \
+	adf_gen2_config.o \
 	adf_gen4_hw_data.o \
 	adf_gen4_pm.o \
 	qat_crypto.o \
diff --git a/drivers/crypto/qat/qat_common/adf_common_drv.h b/drivers/crypto/qat/qat_common/adf_common_drv.h
index 7bb477c3ce25..b8ec0268d2d2 100644
--- a/drivers/crypto/qat/qat_common/adf_common_drv.h
+++ b/drivers/crypto/qat/qat_common/adf_common_drv.h
@@ -110,7 +110,6 @@ int adf_init_etr_data(struct adf_accel_dev *accel_dev);
 void adf_cleanup_etr_data(struct adf_accel_dev *accel_dev);
 int qat_crypto_register(void);
 int qat_crypto_unregister(void);
-int qat_crypto_dev_config(struct adf_accel_dev *accel_dev);
 int qat_crypto_vf_dev_config(struct adf_accel_dev *accel_dev);
 struct qat_crypto_instance *qat_crypto_get_instance_node(int node);
 void qat_crypto_put_instance(struct qat_crypto_instance *inst);
diff --git a/drivers/crypto/qat/qat_common/adf_gen2_config.c b/drivers/crypto/qat/qat_common/adf_gen2_config.c
new file mode 100644
index 000000000000..6b9870418f80
--- /dev/null
+++ b/drivers/crypto/qat/qat_common/adf_gen2_config.c
@@ -0,0 +1,131 @@
+// SPDX-License-Identifier: (BSD-3-Clause OR GPL-2.0-only)
+/* Copyright(c) 2022 Intel Corporation */
+#include "adf_accel_devices.h"
+#include "adf_cfg.h"
+#include "adf_cfg_strings.h"
+#include "adf_gen2_config.h"
+#include "adf_common_drv.h"
+#include "qat_crypto.h"
+#include "adf_transport_access_macros.h"
+
+static int adf_gen2_crypto_dev_config(struct adf_accel_dev *accel_dev)
+{
+	char key[ADF_CFG_MAX_KEY_LEN_IN_BYTES];
+	int banks = GET_MAX_BANKS(accel_dev);
+	int cpus = num_online_cpus();
+	unsigned long val;
+	int instances;
+	int ret;
+	int i;
+
+	if (adf_hw_dev_has_crypto(accel_dev))
+		instances = min(cpus, banks);
+	else
+		instances = 0;
+
+	ret = adf_cfg_section_add(accel_dev, ADF_KERNEL_SEC);
+	if (ret)
+		goto err;
+
+	ret = adf_cfg_section_add(accel_dev, "Accelerator0");
+	if (ret)
+		goto err;
+
+	for (i = 0; i < instances; i++) {
+		val = i;
+		snprintf(key, sizeof(key), ADF_CY "%d" ADF_RING_ASYM_BANK_NUM, i);
+		ret = adf_cfg_add_key_value_param(accel_dev, ADF_KERNEL_SEC,
+						  key, &val, ADF_DEC);
+		if (ret)
+			goto err;
+
+		snprintf(key, sizeof(key), ADF_CY "%d" ADF_RING_SYM_BANK_NUM, i);
+		ret = adf_cfg_add_key_value_param(accel_dev, ADF_KERNEL_SEC,
+						  key, &val, ADF_DEC);
+		if (ret)
+			goto err;
+
+		snprintf(key, sizeof(key), ADF_CY "%d" ADF_ETRMGR_CORE_AFFINITY,
+			 i);
+		ret = adf_cfg_add_key_value_param(accel_dev, ADF_KERNEL_SEC,
+						  key, &val, ADF_DEC);
+		if (ret)
+			goto err;
+
+		snprintf(key, sizeof(key), ADF_CY "%d" ADF_RING_ASYM_SIZE, i);
+		val = 128;
+		ret = adf_cfg_add_key_value_param(accel_dev, ADF_KERNEL_SEC,
+						  key, &val, ADF_DEC);
+		if (ret)
+			goto err;
+
+		val = 512;
+		snprintf(key, sizeof(key), ADF_CY "%d" ADF_RING_SYM_SIZE, i);
+		ret = adf_cfg_add_key_value_param(accel_dev, ADF_KERNEL_SEC,
+						  key, &val, ADF_DEC);
+		if (ret)
+			goto err;
+
+		val = 0;
+		snprintf(key, sizeof(key), ADF_CY "%d" ADF_RING_ASYM_TX, i);
+		ret = adf_cfg_add_key_value_param(accel_dev, ADF_KERNEL_SEC,
+						  key, &val, ADF_DEC);
+		if (ret)
+			goto err;
+
+		val = 2;
+		snprintf(key, sizeof(key), ADF_CY "%d" ADF_RING_SYM_TX, i);
+		ret = adf_cfg_add_key_value_param(accel_dev, ADF_KERNEL_SEC,
+						  key, &val, ADF_DEC);
+		if (ret)
+			goto err;
+
+		val = 8;
+		snprintf(key, sizeof(key), ADF_CY "%d" ADF_RING_ASYM_RX, i);
+		ret = adf_cfg_add_key_value_param(accel_dev, ADF_KERNEL_SEC,
+						  key, &val, ADF_DEC);
+		if (ret)
+			goto err;
+
+		val = 10;
+		snprintf(key, sizeof(key), ADF_CY "%d" ADF_RING_SYM_RX, i);
+		ret = adf_cfg_add_key_value_param(accel_dev, ADF_KERNEL_SEC,
+						  key, &val, ADF_DEC);
+		if (ret)
+			goto err;
+
+		val = ADF_COALESCING_DEF_TIME;
+		snprintf(key, sizeof(key), ADF_ETRMGR_COALESCE_TIMER_FORMAT, i);
+		ret = adf_cfg_add_key_value_param(accel_dev, "Accelerator0",
+						  key, &val, ADF_DEC);
+		if (ret)
+			goto err;
+	}
+
+	val = i;
+	ret = adf_cfg_add_key_value_param(accel_dev, ADF_KERNEL_SEC, ADF_NUM_CY,
+					  &val, ADF_DEC);
+	if (ret)
+		goto err;
+
+	set_bit(ADF_STATUS_CONFIGURED, &accel_dev->status);
+	return 0;
+err:
+	dev_err(&GET_DEV(accel_dev), "Failed to start QAT accel dev\n");
+	return ret;
+}
+
+/**
+ * adf_gen2_dev_config() - create dev config required to create instances
+ *
+ * @accel_dev: Pointer to acceleration device.
+ *
+ * Function creates device configuration required to create instances
+ *
+ * Return: 0 on success, error code otherwise.
+ */
+int adf_gen2_dev_config(struct adf_accel_dev *accel_dev)
+{
+	return adf_gen2_crypto_dev_config(accel_dev);
+}
+EXPORT_SYMBOL_GPL(adf_gen2_dev_config);
diff --git a/drivers/crypto/qat/qat_common/adf_gen2_config.h b/drivers/crypto/qat/qat_common/adf_gen2_config.h
new file mode 100644
index 000000000000..fe0c68c595d5
--- /dev/null
+++ b/drivers/crypto/qat/qat_common/adf_gen2_config.h
@@ -0,0 +1,10 @@
+/* SPDX-License-Identifier: (BSD-3-Clause OR GPL-2.0-only) */
+/* Copyright(c) 2022 Intel Corporation */
+#ifndef ADF_GEN2_CONFIG_H_
+#define ADF_GEN2_CONFIG_H_
+
+#include "adf_accel_devices.h"
+
+int adf_gen2_dev_config(struct adf_accel_dev *accel_dev);
+
+#endif
diff --git a/drivers/crypto/qat/qat_common/qat_crypto.c b/drivers/crypto/qat/qat_common/qat_crypto.c
index 9341d892533a..e31199eade5b 100644
--- a/drivers/crypto/qat/qat_common/qat_crypto.c
+++ b/drivers/crypto/qat/qat_common/qat_crypto.c
@@ -5,7 +5,6 @@
 #include "adf_accel_devices.h"
 #include "adf_common_drv.h"
 #include "adf_transport.h"
-#include "adf_transport_access_macros.h"
 #include "adf_cfg.h"
 #include "adf_cfg_strings.h"
 #include "adf_gen2_hw_data.h"
@@ -126,126 +125,9 @@ int qat_crypto_vf_dev_config(struct adf_accel_dev *accel_dev)
 		return -EFAULT;
 	}
 
-	return qat_crypto_dev_config(accel_dev);
+	return GET_HW_DATA(accel_dev)->dev_config(accel_dev);
 }
 
-/**
- * qat_crypto_dev_config() - create dev config required to create crypto inst.
- *
- * @accel_dev: Pointer to acceleration device.
- *
- * Function creates device configuration required to create crypto instances
- *
- * Return: 0 on success, error code otherwise.
- */
-int qat_crypto_dev_config(struct adf_accel_dev *accel_dev)
-{
-	char key[ADF_CFG_MAX_KEY_LEN_IN_BYTES];
-	int banks = GET_MAX_BANKS(accel_dev);
-	int cpus = num_online_cpus();
-	unsigned long val;
-	int instances;
-	int ret;
-	int i;
-
-	if (adf_hw_dev_has_crypto(accel_dev))
-		instances = min(cpus, banks);
-	else
-		instances = 0;
-
-	ret = adf_cfg_section_add(accel_dev, ADF_KERNEL_SEC);
-	if (ret)
-		goto err;
-
-	ret = adf_cfg_section_add(accel_dev, "Accelerator0");
-	if (ret)
-		goto err;
-
-	for (i = 0; i < instances; i++) {
-		val = i;
-		snprintf(key, sizeof(key), ADF_CY "%d" ADF_RING_ASYM_BANK_NUM, i);
-		ret = adf_cfg_add_key_value_param(accel_dev, ADF_KERNEL_SEC,
-						  key, &val, ADF_DEC);
-		if (ret)
-			goto err;
-
-		snprintf(key, sizeof(key), ADF_CY "%d" ADF_RING_SYM_BANK_NUM, i);
-		ret = adf_cfg_add_key_value_param(accel_dev, ADF_KERNEL_SEC,
-						  key, &val, ADF_DEC);
-		if (ret)
-			goto err;
-
-		snprintf(key, sizeof(key), ADF_CY "%d" ADF_ETRMGR_CORE_AFFINITY,
-			 i);
-		ret = adf_cfg_add_key_value_param(accel_dev, ADF_KERNEL_SEC,
-						  key, &val, ADF_DEC);
-		if (ret)
-			goto err;
-
-		snprintf(key, sizeof(key), ADF_CY "%d" ADF_RING_ASYM_SIZE, i);
-		val = 128;
-		ret = adf_cfg_add_key_value_param(accel_dev, ADF_KERNEL_SEC,
-						  key, &val, ADF_DEC);
-		if (ret)
-			goto err;
-
-		val = 512;
-		snprintf(key, sizeof(key), ADF_CY "%d" ADF_RING_SYM_SIZE, i);
-		ret = adf_cfg_add_key_value_param(accel_dev, ADF_KERNEL_SEC,
-						  key, &val, ADF_DEC);
-		if (ret)
-			goto err;
-
-		val = 0;
-		snprintf(key, sizeof(key), ADF_CY "%d" ADF_RING_ASYM_TX, i);
-		ret = adf_cfg_add_key_value_param(accel_dev, ADF_KERNEL_SEC,
-						  key, &val, ADF_DEC);
-		if (ret)
-			goto err;
-
-		val = 2;
-		snprintf(key, sizeof(key), ADF_CY "%d" ADF_RING_SYM_TX, i);
-		ret = adf_cfg_add_key_value_param(accel_dev, ADF_KERNEL_SEC,
-						  key, &val, ADF_DEC);
-		if (ret)
-			goto err;
-
-		val = 8;
-		snprintf(key, sizeof(key), ADF_CY "%d" ADF_RING_ASYM_RX, i);
-		ret = adf_cfg_add_key_value_param(accel_dev, ADF_KERNEL_SEC,
-						  key, &val, ADF_DEC);
-		if (ret)
-			goto err;
-
-		val = 10;
-		snprintf(key, sizeof(key), ADF_CY "%d" ADF_RING_SYM_RX, i);
-		ret = adf_cfg_add_key_value_param(accel_dev, ADF_KERNEL_SEC,
-						  key, &val, ADF_DEC);
-		if (ret)
-			goto err;
-
-		val = ADF_COALESCING_DEF_TIME;
-		snprintf(key, sizeof(key), ADF_ETRMGR_COALESCE_TIMER_FORMAT, i);
-		ret = adf_cfg_add_key_value_param(accel_dev, "Accelerator0",
-						  key, &val, ADF_DEC);
-		if (ret)
-			goto err;
-	}
-
-	val = i;
-	ret = adf_cfg_add_key_value_param(accel_dev, ADF_KERNEL_SEC, ADF_NUM_CY,
-					  &val, ADF_DEC);
-	if (ret)
-		goto err;
-
-	set_bit(ADF_STATUS_CONFIGURED, &accel_dev->status);
-	return 0;
-err:
-	dev_err(&GET_DEV(accel_dev), "Failed to start QAT accel dev\n");
-	return ret;
-}
-EXPORT_SYMBOL_GPL(qat_crypto_dev_config);
-
 static int qat_crypto_create_instances(struct adf_accel_dev *accel_dev)
 {
 	unsigned long num_inst, num_msg_sym, num_msg_asym;
diff --git a/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c b/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
index cb3bdd3618fb..baacf817abf6 100644
--- a/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
+++ b/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
@@ -2,6 +2,7 @@
 /* Copyright(c) 2014 - 2021 Intel Corporation */
 #include <adf_accel_devices.h>
 #include <adf_common_drv.h>
+#include <adf_gen2_config.h>
 #include <adf_gen2_hw_data.h>
 #include <adf_gen2_pfvf.h>
 #include "adf_dh895xcc_hw_data.h"
@@ -234,6 +235,7 @@ void adf_init_hw_data_dh895xcc(struct adf_hw_device_data *hw_data)
 	hw_data->enable_ints = adf_gen2_enable_ints;
 	hw_data->reset_device = adf_reset_sbr;
 	hw_data->disable_iov = adf_disable_sriov;
+	hw_data->dev_config = adf_gen2_dev_config;
 
 	adf_gen2_init_pf_pfvf_ops(&hw_data->pfvf_ops);
 	hw_data->pfvf_ops.enable_vf2pf_interrupts = enable_vf2pf_interrupts;
diff --git a/drivers/crypto/qat/qat_dh895xcc/adf_drv.c b/drivers/crypto/qat/qat_dh895xcc/adf_drv.c
index acca56752aa0..ebeb17b67fcd 100644
--- a/drivers/crypto/qat/qat_dh895xcc/adf_drv.c
+++ b/drivers/crypto/qat/qat_dh895xcc/adf_drv.c
@@ -201,7 +201,7 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto out_err_disable_aer;
 	}
 
-	ret = qat_crypto_dev_config(accel_dev);
+	ret = hw_data->dev_config(accel_dev);
 	if (ret)
 		goto out_err_disable_aer;
 
diff --git a/drivers/crypto/qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.c b/drivers/crypto/qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.c
index 31c14d7e1c11..b933a00fb91b 100644
--- a/drivers/crypto/qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.c
+++ b/drivers/crypto/qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.c
@@ -2,6 +2,7 @@
 /* Copyright(c) 2015 - 2021 Intel Corporation */
 #include <adf_accel_devices.h>
 #include <adf_common_drv.h>
+#include <adf_gen2_config.h>
 #include <adf_gen2_hw_data.h>
 #include <adf_gen2_pfvf.h>
 #include <adf_pfvf_vf_msg.h>
@@ -86,6 +87,7 @@ void adf_init_hw_data_dh895xcciov(struct adf_hw_device_data *hw_data)
 	hw_data->get_sku = get_sku;
 	hw_data->enable_ints = adf_vf_void_noop;
 	hw_data->dev_class->instances++;
+	hw_data->dev_config = adf_gen2_dev_config;
 	adf_devmgr_update_class_index(hw_data);
 	adf_gen2_init_vf_pfvf_ops(&hw_data->pfvf_ops);
 	adf_gen2_init_hw_csr_ops(&hw_data->csr_ops);
-- 
2.37.1

