Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07357C43217
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Dec 2021 09:12:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232948AbhLPJMN (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 16 Dec 2021 04:12:13 -0500
Received: from mga12.intel.com ([192.55.52.136]:9714 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232977AbhLPJMJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Dec 2021 04:12:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639645929; x=1671181929;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=z2sxZ2uQnoq1fsaRVTMa61/aLH0uOj6CDLNU41ztM24=;
  b=K+k7lOWAu48n1bGDubr7xJGQjakmwlxYssjHWRrGG2ruWn6OEj26ssLj
   Eye++RWmWxz/O7kwMV7KcJIan8kNhH9FGyUFXjPrYlQUin0wBNHX2vUZI
   xKehmL4d3PHz/Xm7Z7VN7oqNHGL3xPzIg/amyHJZ3J/icI9TM3sxBmICd
   HkyxwocWQNj6luLAImXBC4WPyTgI1eLatu8wT40QyBV2BMXIBrD5Hg0SK
   xQokTHwY8GOHPI4Gj+ENgC2F4SPAAzOdTs3dUvPqWti6Cu0BDPex/MOTJ
   Nm15uZeHImlAS2cu41QuZuTvN3fbmOOqDFhinPPvmA+K3BfEVGLDYEHhz
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10199"; a="219458497"
X-IronPort-AV: E=Sophos;i="5.88,211,1635231600"; 
   d="scan'208";a="219458497"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2021 01:11:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,211,1635231600"; 
   d="scan'208";a="465968699"
Received: from silpixa00393544.ir.intel.com ([10.237.213.118])
  by orsmga006.jf.intel.com with ESMTP; 16 Dec 2021 01:11:56 -0800
From:   Marco Chiappero <marco.chiappero@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        giovanni.cabiddu@intel.com, marco.chiappero@intel.com,
        Tomasz Kowalik <tomaszx.kowalik@intel.com>,
        Mateuszx Potrola <mateuszx.potrola@intel.com>,
        Fiona Trahe <fiona.trahe@intel.com>
Subject: [PATCH 24/24] crypto: qat - add support for compression for 4xxx
Date:   Thu, 16 Dec 2021 09:13:34 +0000
Message-Id: <20211216091334.402420-25-marco.chiappero@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211216091334.402420-1-marco.chiappero@intel.com>
References: <20211216091334.402420-1-marco.chiappero@intel.com>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Tomasz Kowalik <tomaszx.kowalik@intel.com>

Add the logic required to enable the compression service for 4xxx devices.
This allows to load the compression firmware image and report
the appropriate compression capabilities.

The firmware image selection for a given device is based on the
'ServicesEnabled' key stored in the internal configuration, which is
added statically at the probe of the device according to the following
rule, by default:
- odd numbered devices assigned to compression services
- even numbered devices assigned to crypto services

In addition, restore the 'ServicesEnabled' key, if present, when SRIOV
is enabled on the device.

Signed-off-by: Tomasz Kowalik <tomaszx.kowalik@intel.com>
Co-developed-by: Mateuszx Potrola <mateuszx.potrola@intel.com>
Signed-off-by: Mateuszx Potrola <mateuszx.potrola@intel.com>
Co-developed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Marco Chiappero <marco.chiappero@intel.com>
Reviewed-by: Fiona Trahe <fiona.trahe@intel.com>
Reviewed-by: Marco Chiappero <marco.chiappero@intel.com>
---
 .../crypto/qat/qat_4xxx/adf_4xxx_hw_data.c    | 79 +++++++++++++++++--
 .../crypto/qat/qat_4xxx/adf_4xxx_hw_data.h    |  1 +
 drivers/crypto/qat/qat_4xxx/adf_drv.c         | 33 ++++++++
 .../crypto/qat/qat_common/adf_accel_devices.h |  4 +-
 .../crypto/qat/qat_common/adf_accel_engine.c  |  8 +-
 drivers/crypto/qat/qat_common/adf_cfg.c       |  1 +
 .../crypto/qat/qat_common/adf_cfg_strings.h   |  3 +
 drivers/crypto/qat/qat_common/adf_sriov.c     | 31 +++++++-
 8 files changed, 147 insertions(+), 13 deletions(-)

diff --git a/drivers/crypto/qat/qat_4xxx/adf_4xxx_hw_data.c b/drivers/crypto/qat/qat_4xxx/adf_4xxx_hw_data.c
index 40f684103b29..6d10edc40aca 100644
--- a/drivers/crypto/qat/qat_4xxx/adf_4xxx_hw_data.c
+++ b/drivers/crypto/qat/qat_4xxx/adf_4xxx_hw_data.c
@@ -2,6 +2,7 @@
 /* Copyright(c) 2020 - 2021 Intel Corporation */
 #include <linux/iopoll.h>
 #include <adf_accel_devices.h>
+#include <adf_cfg.h>
 #include <adf_common_drv.h>
 #include <adf_gen4_hw_data.h>
 #include <adf_gen4_pfvf.h>
@@ -13,12 +14,18 @@ struct adf_fw_config {
 	char *obj_name;
 };
 
-static struct adf_fw_config adf_4xxx_fw_config[] = {
+static struct adf_fw_config adf_4xxx_fw_cy_config[] = {
 	{0xF0, ADF_4XXX_SYM_OBJ},
 	{0xF, ADF_4XXX_ASYM_OBJ},
 	{0x100, ADF_4XXX_ADMIN_OBJ},
 };
 
+static struct adf_fw_config adf_4xxx_fw_dc_config[] = {
+	{0xF0, ADF_4XXX_DC_OBJ},
+	{0xF, ADF_4XXX_DC_OBJ},
+	{0x100, ADF_4XXX_ADMIN_OBJ},
+};
+
 /* Worker thread to service arbiter mappings */
 static const u32 thrd_to_arb_map[ADF_4XXX_MAX_ACCELENGINES] = {
 	0x5555555, 0x5555555, 0x5555555, 0x5555555,
@@ -32,6 +39,39 @@ static struct adf_hw_device_class adf_4xxx_class = {
 	.instances = 0,
 };
 
+enum dev_services {
+	SVC_CY = 0,
+	SVC_DC,
+};
+
+static const char *const dev_cfg_services[] = {
+	[SVC_CY] = ADF_CFG_CY,
+	[SVC_DC] = ADF_CFG_DC,
+};
+
+static int get_service_enabled(struct adf_accel_dev *accel_dev)
+{
+	char services[ADF_CFG_MAX_VAL_LEN_IN_BYTES] = {0};
+	u32 ret;
+
+	ret = adf_cfg_get_param_value(accel_dev, ADF_GENERAL_SEC,
+				      ADF_SERVICES_ENABLED, services);
+	if (ret) {
+		dev_err(&GET_DEV(accel_dev),
+			ADF_SERVICES_ENABLED " param not found\n");
+		return ret;
+	}
+
+	ret = match_string(dev_cfg_services, ARRAY_SIZE(dev_cfg_services),
+			   services);
+	if (ret < 0)
+		dev_err(&GET_DEV(accel_dev),
+			"Invalid value of " ADF_SERVICES_ENABLED " param: %s\n",
+			services);
+
+	return ret;
+}
+
 static u32 get_accel_mask(struct adf_hw_device_data *self)
 {
 	return ADF_4XXX_ACCELERATORS_MASK;
@@ -149,7 +189,14 @@ static u32 get_accel_cap(struct adf_accel_dev *accel_dev)
 		capabilities_dc &= ~ICP_ACCEL_CAPABILITIES_CNV_INTEGRITY64;
 	}
 
-	return capabilities_cy;
+	switch (get_service_enabled(accel_dev)) {
+	case SVC_CY:
+		return capabilities_cy;
+	case SVC_DC:
+		return capabilities_dc;
+	}
+
+	return 0;
 }
 
 static enum dev_sku_info get_sku(struct adf_hw_device_data *self)
@@ -230,17 +277,35 @@ static int adf_init_device(struct adf_accel_dev *accel_dev)
 
 static u32 uof_get_num_objs(void)
 {
-	return ARRAY_SIZE(adf_4xxx_fw_config);
+	BUILD_BUG_ON_MSG(ARRAY_SIZE(adf_4xxx_fw_cy_config) !=
+			 ARRAY_SIZE(adf_4xxx_fw_dc_config),
+			 "Size mismatch between adf_4xxx_fw_*_config arrays");
+
+	return ARRAY_SIZE(adf_4xxx_fw_cy_config);
 }
 
-static char *uof_get_name(u32 obj_num)
+static char *uof_get_name(struct adf_accel_dev *accel_dev, u32 obj_num)
 {
-	return adf_4xxx_fw_config[obj_num].obj_name;
+	switch (get_service_enabled(accel_dev)) {
+	case SVC_CY:
+		return adf_4xxx_fw_cy_config[obj_num].obj_name;
+	case SVC_DC:
+		return adf_4xxx_fw_dc_config[obj_num].obj_name;
+	}
+
+	return NULL;
 }
 
-static u32 uof_get_ae_mask(u32 obj_num)
+static u32 uof_get_ae_mask(struct adf_accel_dev *accel_dev, u32 obj_num)
 {
-	return adf_4xxx_fw_config[obj_num].ae_mask;
+	switch (get_service_enabled(accel_dev)) {
+	case SVC_CY:
+		return adf_4xxx_fw_cy_config[obj_num].ae_mask;
+	case SVC_DC:
+		return adf_4xxx_fw_dc_config[obj_num].ae_mask;
+	}
+
+	return 0;
 }
 
 void adf_init_hw_data_4xxx(struct adf_hw_device_data *hw_data)
diff --git a/drivers/crypto/qat/qat_4xxx/adf_4xxx_hw_data.h b/drivers/crypto/qat/qat_4xxx/adf_4xxx_hw_data.h
index a0c67752317f..12e4fb9b40ce 100644
--- a/drivers/crypto/qat/qat_4xxx/adf_4xxx_hw_data.h
+++ b/drivers/crypto/qat/qat_4xxx/adf_4xxx_hw_data.h
@@ -77,6 +77,7 @@
 #define ADF_4XXX_FW		"qat_4xxx.bin"
 #define ADF_4XXX_MMP		"qat_4xxx_mmp.bin"
 #define ADF_4XXX_SYM_OBJ	"qat_4xxx_sym.bin"
+#define ADF_4XXX_DC_OBJ		"qat_4xxx_dc.bin"
 #define ADF_4XXX_ASYM_OBJ	"qat_4xxx_asym.bin"
 #define ADF_4XXX_ADMIN_OBJ	"qat_4xxx_admin.bin"
 
diff --git a/drivers/crypto/qat/qat_4xxx/adf_drv.c b/drivers/crypto/qat/qat_4xxx/adf_drv.c
index 71ef065914b2..a6c78b9c730b 100644
--- a/drivers/crypto/qat/qat_4xxx/adf_drv.c
+++ b/drivers/crypto/qat/qat_4xxx/adf_drv.c
@@ -29,6 +29,29 @@ static void adf_cleanup_accel(struct adf_accel_dev *accel_dev)
 	adf_devmgr_rm_dev(accel_dev, NULL);
 }
 
+static int adf_cfg_dev_init(struct adf_accel_dev *accel_dev)
+{
+	const char *config;
+	int ret;
+
+	config = accel_dev->accel_id % 2 ? ADF_CFG_DC : ADF_CFG_CY;
+
+	ret = adf_cfg_section_add(accel_dev, ADF_GENERAL_SEC);
+	if (ret)
+		return ret;
+
+	/* Default configuration is crypto only for even devices
+	 * and compression for odd devices
+	 */
+	ret = adf_cfg_add_key_value_param(accel_dev, ADF_GENERAL_SEC,
+					  ADF_SERVICES_ENABLED, config,
+					  ADF_STR);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
 static int adf_crypto_dev_config(struct adf_accel_dev *accel_dev)
 {
 	char key[ADF_CFG_MAX_KEY_LEN_IN_BYTES];
@@ -227,8 +250,18 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto out_err;
 	}
 
+	ret = adf_cfg_dev_init(accel_dev);
+	if (ret) {
+		dev_err(&pdev->dev, "Failed to initialize configuration.\n");
+		goto out_err;
+	}
+
 	/* Get accelerator capabilities mask */
 	hw_data->accel_capabilities_mask = hw_data->get_accel_cap(accel_dev);
+	if (!hw_data->accel_capabilities_mask) {
+		dev_err(&pdev->dev, "Failed to get capabilities mask.\n");
+		goto out_err;
+	}
 
 	/* Find and map all the device's BARS */
 	bar_mask = pci_select_bars(pdev, IORESOURCE_MEM) & ADF_4XXX_BAR_MASK;
diff --git a/drivers/crypto/qat/qat_common/adf_accel_devices.h b/drivers/crypto/qat/qat_common/adf_accel_devices.h
index 1b9d4ed03dd0..2d4cd7c7cf33 100644
--- a/drivers/crypto/qat/qat_common/adf_accel_devices.h
+++ b/drivers/crypto/qat/qat_common/adf_accel_devices.h
@@ -192,9 +192,9 @@ struct adf_hw_device_data {
 	int (*ring_pair_reset)(struct adf_accel_dev *accel_dev, u32 bank_nr);
 	void (*reset_device)(struct adf_accel_dev *accel_dev);
 	void (*set_msix_rttable)(struct adf_accel_dev *accel_dev);
-	char *(*uof_get_name)(u32 obj_num);
+	char *(*uof_get_name)(struct adf_accel_dev *accel_dev, u32 obj_num);
 	u32 (*uof_get_num_objs)(void);
-	u32 (*uof_get_ae_mask)(u32 obj_num);
+	u32 (*uof_get_ae_mask)(struct adf_accel_dev *accel_dev, u32 obj_num);
 	struct adf_pfvf_ops pfvf_ops;
 	struct adf_hw_csr_ops csr_ops;
 	const char *fw_name;
diff --git a/drivers/crypto/qat/qat_common/adf_accel_engine.c b/drivers/crypto/qat/qat_common/adf_accel_engine.c
index ca4eae8cdd0b..4ce2b666929e 100644
--- a/drivers/crypto/qat/qat_common/adf_accel_engine.c
+++ b/drivers/crypto/qat/qat_common/adf_accel_engine.c
@@ -22,8 +22,12 @@ static int adf_ae_fw_load_images(struct adf_accel_dev *accel_dev, void *fw_addr,
 	num_objs = hw_device->uof_get_num_objs();
 
 	for (i = 0; i < num_objs; i++) {
-		obj_name = hw_device->uof_get_name(i);
-		ae_mask = hw_device->uof_get_ae_mask(i);
+		obj_name = hw_device->uof_get_name(accel_dev, i);
+		ae_mask = hw_device->uof_get_ae_mask(accel_dev, i);
+		if (!obj_name || !ae_mask) {
+			dev_err(&GET_DEV(accel_dev), "Invalid UOF image\n");
+			goto out_err;
+		}
 
 		if (qat_uclo_set_cfg_ae_mask(loader, ae_mask)) {
 			dev_err(&GET_DEV(accel_dev),
diff --git a/drivers/crypto/qat/qat_common/adf_cfg.c b/drivers/crypto/qat/qat_common/adf_cfg.c
index 575b6f002303..b5b208cbe5a1 100644
--- a/drivers/crypto/qat/qat_common/adf_cfg.c
+++ b/drivers/crypto/qat/qat_common/adf_cfg.c
@@ -297,3 +297,4 @@ int adf_cfg_get_param_value(struct adf_accel_dev *accel_dev,
 	up_read(&cfg->lock);
 	return ret;
 }
+EXPORT_SYMBOL_GPL(adf_cfg_get_param_value);
diff --git a/drivers/crypto/qat/qat_common/adf_cfg_strings.h b/drivers/crypto/qat/qat_common/adf_cfg_strings.h
index 09651e1f937a..655248dbf962 100644
--- a/drivers/crypto/qat/qat_common/adf_cfg_strings.h
+++ b/drivers/crypto/qat/qat_common/adf_cfg_strings.h
@@ -22,6 +22,9 @@
 #define ADF_RING_ASYM_BANK_NUM "BankAsymNumber"
 #define ADF_CY "Cy"
 #define ADF_DC "Dc"
+#define ADF_CFG_DC "dc"
+#define ADF_CFG_CY "sym;asym"
+#define ADF_SERVICES_ENABLED "ServicesEnabled"
 #define ADF_ETRMGR_COALESCING_ENABLED "InterruptCoalescingEnabled"
 #define ADF_ETRMGR_COALESCING_ENABLED_FORMAT \
 	ADF_ETRMGR_BANK "%d" ADF_ETRMGR_COALESCING_ENABLED
diff --git a/drivers/crypto/qat/qat_common/adf_sriov.c b/drivers/crypto/qat/qat_common/adf_sriov.c
index 971a05d62418..b960bca1f9d2 100644
--- a/drivers/crypto/qat/qat_common/adf_sriov.c
+++ b/drivers/crypto/qat/qat_common/adf_sriov.c
@@ -126,6 +126,32 @@ void adf_disable_sriov(struct adf_accel_dev *accel_dev)
 }
 EXPORT_SYMBOL_GPL(adf_disable_sriov);
 
+static int adf_sriov_prepare_restart(struct adf_accel_dev *accel_dev)
+{
+	char services[ADF_CFG_MAX_VAL_LEN_IN_BYTES] = {0};
+	int ret;
+
+	ret = adf_cfg_get_param_value(accel_dev, ADF_GENERAL_SEC,
+				      ADF_SERVICES_ENABLED, services);
+
+	adf_dev_stop(accel_dev);
+	adf_dev_shutdown(accel_dev);
+
+	if (!ret) {
+		ret = adf_cfg_section_add(accel_dev, ADF_GENERAL_SEC);
+		if (ret)
+			return ret;
+
+		ret = adf_cfg_add_key_value_param(accel_dev, ADF_GENERAL_SEC,
+						  ADF_SERVICES_ENABLED,
+						  services, ADF_STR);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
 /**
  * adf_sriov_configure() - Enable SRIOV for the device
  * @pdev:  Pointer to PCI device.
@@ -165,8 +191,9 @@ int adf_sriov_configure(struct pci_dev *pdev, int numvfs)
 			return -EBUSY;
 		}
 
-		adf_dev_stop(accel_dev);
-		adf_dev_shutdown(accel_dev);
+		ret = adf_sriov_prepare_restart(accel_dev);
+		if (ret)
+			return ret;
 	}
 
 	if (adf_cfg_section_add(accel_dev, ADF_KERNEL_SEC))
-- 
2.31.1

