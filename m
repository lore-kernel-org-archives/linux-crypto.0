Return-Path: <SRS0=K/JA=DT=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E2E3C43457
	for <linux-crypto@archiver.kernel.org>; Mon, 12 Oct 2020 20:39:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0E896208D5
	for <linux-crypto@archiver.kernel.org>; Mon, 12 Oct 2020 20:39:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730658AbgJLUje (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 12 Oct 2020 16:39:34 -0400
Received: from mga09.intel.com ([134.134.136.24]:34024 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730636AbgJLUje (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 12 Oct 2020 16:39:34 -0400
IronPort-SDR: ijrhTwIbkl8w0R4of9aI27psf2nCg22v3J20tfM2QvtRNwbEBTX9fDgtFBtZTvpErAnulqamP9
 Rq1k3XmdR16g==
X-IronPort-AV: E=McAfee;i="6000,8403,9772"; a="165913140"
X-IronPort-AV: E=Sophos;i="5.77,367,1596524400"; 
   d="scan'208";a="165913140"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2020 13:39:33 -0700
IronPort-SDR: QJmlpHjDpLIlS6uweWah16HJq7F+3xo4uqQm7CCUH1ZGIWnUYJMLuQANr32dZKzyK8TFe1+xoD
 0yhLZ9SM958Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,367,1596524400"; 
   d="scan'208";a="299328206"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.51])
  by fmsmga007.fm.intel.com with ESMTP; 12 Oct 2020 13:39:31 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Marco Chiappero <marco.chiappero@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>,
        Fiona Trahe <fiona.trahe@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 16/31] crypto: qat - add support for capability detection
Date:   Mon, 12 Oct 2020 21:38:32 +0100
Message-Id: <20201012203847.340030-17-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201012203847.340030-1-giovanni.cabiddu@intel.com>
References: <20201012203847.340030-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Marco Chiappero <marco.chiappero@intel.com>

Add logic to detect device capabilities for c62x, c3xxx and dh895xcc.

Read fuses, straps and legfuses CSRs and build the device capabilities
mask. This will be used to understand if a certain service is supported
by a device.

This patch is based on earlier work done by Conor McLoughlin.

Signed-off-by: Marco Chiappero <marco.chiappero@intel.com>
Co-developed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Wojciech Ziemba <wojciech.ziemba@intel.com>
Reviewed-by: Fiona Trahe <fiona.trahe@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 .../crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c  |  2 ++
 drivers/crypto/qat/qat_c3xxx/adf_drv.c        |  5 ++--
 .../crypto/qat/qat_c62x/adf_c62x_hw_data.c    |  2 ++
 drivers/crypto/qat/qat_c62x/adf_drv.c         |  5 ++--
 .../crypto/qat/qat_common/adf_accel_devices.h |  1 +
 .../crypto/qat/qat_common/adf_gen2_hw_data.c  | 30 +++++++++++++++++++
 .../crypto/qat/qat_common/adf_gen2_hw_data.h  |  4 +++
 drivers/crypto/qat/qat_common/icp_qat_hw.h    | 23 ++++++++++++++
 .../qat/qat_dh895xcc/adf_dh895xcc_hw_data.c   | 25 ++++++++++++++++
 drivers/crypto/qat/qat_dh895xcc/adf_drv.c     |  5 ++--
 10 files changed, 93 insertions(+), 9 deletions(-)

diff --git a/drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c b/drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c
index f3f33dc0c316..eb45f1b1ae3e 100644
--- a/drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c
+++ b/drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c
@@ -5,6 +5,7 @@
 #include <adf_pf2vf_msg.h>
 #include <adf_gen2_hw_data.h>
 #include "adf_c3xxx_hw_data.h"
+#include "icp_qat_hw.h"
 
 /* Worker thread to service arbiter mappings based on dev SKUs */
 static const u32 thrd_to_arb_map_6_me_sku[] = {
@@ -195,6 +196,7 @@ void adf_init_hw_data_c3xxx(struct adf_hw_device_data *hw_data)
 	hw_data->enable_error_correction = adf_enable_error_correction;
 	hw_data->get_accel_mask = get_accel_mask;
 	hw_data->get_ae_mask = get_ae_mask;
+	hw_data->get_accel_cap = adf_gen2_get_accel_cap;
 	hw_data->get_num_accels = get_num_accels;
 	hw_data->get_num_aes = get_num_aes;
 	hw_data->get_sram_bar_id = get_sram_bar_id;
diff --git a/drivers/crypto/qat/qat_c3xxx/adf_drv.c b/drivers/crypto/qat/qat_c3xxx/adf_drv.c
index da6e88026988..7fb3343ae8b0 100644
--- a/drivers/crypto/qat/qat_c3xxx/adf_drv.c
+++ b/drivers/crypto/qat/qat_c3xxx/adf_drv.c
@@ -177,9 +177,8 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto out_err_disable;
 	}
 
-	/* Read accelerator capabilities mask */
-	pci_read_config_dword(pdev, ADF_DEVICE_LEGFUSE_OFFSET,
-			      &hw_data->accel_capabilities_mask);
+	/* Get accelerator capabilities mask */
+	hw_data->accel_capabilities_mask = hw_data->get_accel_cap(accel_dev);
 
 	/* Find and map all the device's BARS */
 	i = 0;
diff --git a/drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.c b/drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.c
index 53c03b2f763f..babdffbcb846 100644
--- a/drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.c
+++ b/drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.c
@@ -5,6 +5,7 @@
 #include <adf_pf2vf_msg.h>
 #include <adf_gen2_hw_data.h>
 #include "adf_c62x_hw_data.h"
+#include "icp_qat_hw.h"
 
 /* Worker thread to service arbiter mappings based on dev SKUs */
 static const u32 thrd_to_arb_map_8_me_sku[] = {
@@ -205,6 +206,7 @@ void adf_init_hw_data_c62x(struct adf_hw_device_data *hw_data)
 	hw_data->enable_error_correction = adf_enable_error_correction;
 	hw_data->get_accel_mask = get_accel_mask;
 	hw_data->get_ae_mask = get_ae_mask;
+	hw_data->get_accel_cap = adf_gen2_get_accel_cap;
 	hw_data->get_num_accels = get_num_accels;
 	hw_data->get_num_aes = get_num_aes;
 	hw_data->get_sram_bar_id = get_sram_bar_id;
diff --git a/drivers/crypto/qat/qat_c62x/adf_drv.c b/drivers/crypto/qat/qat_c62x/adf_drv.c
index 3da697a566ad..1f5de442e1e6 100644
--- a/drivers/crypto/qat/qat_c62x/adf_drv.c
+++ b/drivers/crypto/qat/qat_c62x/adf_drv.c
@@ -177,9 +177,8 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto out_err_disable;
 	}
 
-	/* Read accelerator capabilities mask */
-	pci_read_config_dword(pdev, ADF_DEVICE_LEGFUSE_OFFSET,
-			      &hw_data->accel_capabilities_mask);
+	/* Get accelerator capabilities mask */
+	hw_data->accel_capabilities_mask = hw_data->get_accel_cap(accel_dev);
 
 	/* Find and map all the device's BARS */
 	i = (hw_data->fuses & ADF_DEVICE_FUSECTL_MASK) ? 1 : 0;
diff --git a/drivers/crypto/qat/qat_common/adf_accel_devices.h b/drivers/crypto/qat/qat_common/adf_accel_devices.h
index 951072feb176..692e39e5e878 100644
--- a/drivers/crypto/qat/qat_common/adf_accel_devices.h
+++ b/drivers/crypto/qat/qat_common/adf_accel_devices.h
@@ -143,6 +143,7 @@ struct adf_hw_device_data {
 	struct adf_hw_device_class *dev_class;
 	u32 (*get_accel_mask)(struct adf_hw_device_data *self);
 	u32 (*get_ae_mask)(struct adf_hw_device_data *self);
+	u32 (*get_accel_cap)(struct adf_accel_dev *accel_dev);
 	u32 (*get_sram_bar_id)(struct adf_hw_device_data *self);
 	u32 (*get_misc_bar_id)(struct adf_hw_device_data *self);
 	u32 (*get_etr_bar_id)(struct adf_hw_device_data *self);
diff --git a/drivers/crypto/qat/qat_common/adf_gen2_hw_data.c b/drivers/crypto/qat/qat_common/adf_gen2_hw_data.c
index b2f770cc29d8..d5560e714167 100644
--- a/drivers/crypto/qat/qat_common/adf_gen2_hw_data.c
+++ b/drivers/crypto/qat/qat_common/adf_gen2_hw_data.c
@@ -1,6 +1,8 @@
 // SPDX-License-Identifier: (BSD-3-Clause OR GPL-2.0-only)
 /* Copyright(c) 2020 Intel Corporation */
 #include "adf_gen2_hw_data.h"
+#include "icp_qat_hw.h"
+#include <linux/pci.h>
 
 void adf_gen2_cfg_iov_thds(struct adf_accel_dev *accel_dev, bool enable,
 			   int num_a_regs, int num_b_regs)
@@ -136,3 +138,31 @@ void adf_gen2_init_hw_csr_ops(struct adf_hw_csr_ops *csr_ops)
 	csr_ops->write_csr_int_flag_and_col = write_csr_int_flag_and_col;
 }
 EXPORT_SYMBOL_GPL(adf_gen2_init_hw_csr_ops);
+
+u32 adf_gen2_get_accel_cap(struct adf_accel_dev *accel_dev)
+{
+	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
+	struct pci_dev *pdev = accel_dev->accel_pci_dev.pci_dev;
+	u32 straps = hw_data->straps;
+	u32 fuses = hw_data->fuses;
+	u32 legfuses;
+	u32 capabilities = ICP_ACCEL_CAPABILITIES_CRYPTO_SYMMETRIC |
+			   ICP_ACCEL_CAPABILITIES_CRYPTO_ASYMMETRIC |
+			   ICP_ACCEL_CAPABILITIES_AUTHENTICATION;
+
+	/* Read accelerator capabilities mask */
+	pci_read_config_dword(pdev, ADF_DEVICE_LEGFUSE_OFFSET, &legfuses);
+
+	if (legfuses & ICP_ACCEL_MASK_CIPHER_SLICE)
+		capabilities &= ~ICP_ACCEL_CAPABILITIES_CRYPTO_SYMMETRIC;
+	if (legfuses & ICP_ACCEL_MASK_PKE_SLICE)
+		capabilities &= ~ICP_ACCEL_CAPABILITIES_CRYPTO_ASYMMETRIC;
+	if (legfuses & ICP_ACCEL_MASK_AUTH_SLICE)
+		capabilities &= ~ICP_ACCEL_CAPABILITIES_AUTHENTICATION;
+
+	if ((straps | fuses) & ADF_POWERGATE_PKE)
+		capabilities &= ~ICP_ACCEL_CAPABILITIES_CRYPTO_ASYMMETRIC;
+
+	return capabilities;
+}
+EXPORT_SYMBOL_GPL(adf_gen2_get_accel_cap);
diff --git a/drivers/crypto/qat/qat_common/adf_gen2_hw_data.h b/drivers/crypto/qat/qat_common/adf_gen2_hw_data.h
index fe4ea3220bca..6c860aedb301 100644
--- a/drivers/crypto/qat/qat_common/adf_gen2_hw_data.h
+++ b/drivers/crypto/qat/qat_common/adf_gen2_hw_data.h
@@ -102,10 +102,14 @@ do { \
 #define ADF_ARB_WRK_2_SER_MAP_OFFSET	0x180
 #define ADF_ARB_CONFIG			(BIT(31) | BIT(6) | BIT(0))
 
+/* Power gating */
+#define ADF_POWERGATE_PKE		BIT(24)
+
 void adf_gen2_cfg_iov_thds(struct adf_accel_dev *accel_dev, bool enable,
 			   int num_a_regs, int num_b_regs);
 void adf_gen2_init_hw_csr_ops(struct adf_hw_csr_ops *csr_ops);
 void adf_gen2_get_admin_info(struct admin_info *admin_csrs_info);
 void adf_gen2_get_arb_info(struct arb_info *arb_info);
+u32 adf_gen2_get_accel_cap(struct adf_accel_dev *accel_dev);
 
 #endif
diff --git a/drivers/crypto/qat/qat_common/icp_qat_hw.h b/drivers/crypto/qat/qat_common/icp_qat_hw.h
index c4b6ef1506ab..4aa5d724e11b 100644
--- a/drivers/crypto/qat/qat_common/icp_qat_hw.h
+++ b/drivers/crypto/qat/qat_common/icp_qat_hw.h
@@ -65,6 +65,29 @@ struct icp_qat_hw_auth_config {
 	__u32 reserved;
 };
 
+enum icp_qat_slice_mask {
+	ICP_ACCEL_MASK_CIPHER_SLICE = BIT(0),
+	ICP_ACCEL_MASK_AUTH_SLICE = BIT(1),
+	ICP_ACCEL_MASK_PKE_SLICE = BIT(2),
+	ICP_ACCEL_MASK_COMPRESS_SLICE = BIT(3),
+	ICP_ACCEL_MASK_LZS_SLICE = BIT(4),
+	ICP_ACCEL_MASK_EIA3_SLICE = BIT(5),
+	ICP_ACCEL_MASK_SHA3_SLICE = BIT(6),
+};
+
+enum icp_qat_capabilities_mask {
+	ICP_ACCEL_CAPABILITIES_CRYPTO_SYMMETRIC = BIT(0),
+	ICP_ACCEL_CAPABILITIES_CRYPTO_ASYMMETRIC = BIT(1),
+	ICP_ACCEL_CAPABILITIES_CIPHER = BIT(2),
+	ICP_ACCEL_CAPABILITIES_AUTHENTICATION = BIT(3),
+	ICP_ACCEL_CAPABILITIES_RESERVED_1 = BIT(4),
+	ICP_ACCEL_CAPABILITIES_COMPRESSION = BIT(5),
+	ICP_ACCEL_CAPABILITIES_LZS_COMPRESSION = BIT(6),
+	ICP_ACCEL_CAPABILITIES_RAND = BIT(7),
+	ICP_ACCEL_CAPABILITIES_ZUC = BIT(8),
+	ICP_ACCEL_CAPABILITIES_SHA3 = BIT(9),
+};
+
 #define QAT_AUTH_MODE_BITPOS 4
 #define QAT_AUTH_MODE_MASK 0xF
 #define QAT_AUTH_ALGO_BITPOS 0
diff --git a/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c b/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
index 2e7017a3ad46..7970ebb67f28 100644
--- a/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
+++ b/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
@@ -5,6 +5,7 @@
 #include <adf_common_drv.h>
 #include <adf_gen2_hw_data.h>
 #include "adf_dh895xcc_hw_data.h"
+#include "icp_qat_hw.h"
 
 /* Worker thread to service arbiter mappings based on dev SKUs */
 static const u32 thrd_to_arb_map_sku4[] = {
@@ -83,6 +84,29 @@ static u32 get_sram_bar_id(struct adf_hw_device_data *self)
 	return ADF_DH895XCC_SRAM_BAR;
 }
 
+static u32 get_accel_cap(struct adf_accel_dev *accel_dev)
+{
+	struct pci_dev *pdev = accel_dev->accel_pci_dev.pci_dev;
+	u32 capabilities;
+	u32 legfuses;
+
+	capabilities = ICP_ACCEL_CAPABILITIES_CRYPTO_SYMMETRIC |
+		       ICP_ACCEL_CAPABILITIES_CRYPTO_ASYMMETRIC |
+		       ICP_ACCEL_CAPABILITIES_AUTHENTICATION;
+
+	/* Read accelerator capabilities mask */
+	pci_read_config_dword(pdev, ADF_DEVICE_LEGFUSE_OFFSET, &legfuses);
+
+	if (legfuses & ICP_ACCEL_MASK_CIPHER_SLICE)
+		capabilities &= ~ICP_ACCEL_CAPABILITIES_CRYPTO_SYMMETRIC;
+	if (legfuses & ICP_ACCEL_MASK_PKE_SLICE)
+		capabilities &= ~ICP_ACCEL_CAPABILITIES_CRYPTO_ASYMMETRIC;
+	if (legfuses & ICP_ACCEL_MASK_AUTH_SLICE)
+		capabilities &= ~ICP_ACCEL_CAPABILITIES_AUTHENTICATION;
+
+	return capabilities;
+}
+
 static enum dev_sku_info get_sku(struct adf_hw_device_data *self)
 {
 	int sku = (self->fuses & ADF_DH895XCC_FUSECTL_SKU_MASK)
@@ -204,6 +228,7 @@ void adf_init_hw_data_dh895xcc(struct adf_hw_device_data *hw_data)
 	hw_data->enable_error_correction = adf_enable_error_correction;
 	hw_data->get_accel_mask = get_accel_mask;
 	hw_data->get_ae_mask = get_ae_mask;
+	hw_data->get_accel_cap = get_accel_cap;
 	hw_data->get_num_accels = get_num_accels;
 	hw_data->get_num_aes = get_num_aes;
 	hw_data->get_etr_bar_id = get_etr_bar_id;
diff --git a/drivers/crypto/qat/qat_dh895xcc/adf_drv.c b/drivers/crypto/qat/qat_dh895xcc/adf_drv.c
index d7941bc2bafd..a9ec4357144c 100644
--- a/drivers/crypto/qat/qat_dh895xcc/adf_drv.c
+++ b/drivers/crypto/qat/qat_dh895xcc/adf_drv.c
@@ -177,9 +177,8 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto out_err_disable;
 	}
 
-	/* Read accelerator capabilities mask */
-	pci_read_config_dword(pdev, ADF_DEVICE_LEGFUSE_OFFSET,
-			      &hw_data->accel_capabilities_mask);
+	/* Get accelerator capabilities mask */
+	hw_data->accel_capabilities_mask = hw_data->get_accel_cap(accel_dev);
 
 	/* Find and map all the device's BARS */
 	i = 0;
-- 
2.26.2

