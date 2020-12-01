Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E352C64E7A
	for <linux-crypto@archiver.kernel.org>; Tue,  1 Dec 2020 14:26:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 51B0720758
	for <linux-crypto@archiver.kernel.org>; Tue,  1 Dec 2020 14:26:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729083AbgLAO0X (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 1 Dec 2020 09:26:23 -0500
Received: from mga18.intel.com ([134.134.136.126]:7384 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728702AbgLAO0X (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 1 Dec 2020 09:26:23 -0500
IronPort-SDR: cByg4gO4aCF4DO1HZvC8mBR7lJwcCwq767obyqpucIcs3rt935ZbTqWGcwu9M6/llIHdXBRaiT
 w8dZ19US5Qmg==
X-IronPort-AV: E=McAfee;i="6000,8403,9821"; a="160603458"
X-IronPort-AV: E=Sophos;i="5.78,384,1599548400"; 
   d="scan'208";a="160603458"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2020 06:25:01 -0800
IronPort-SDR: MMB5rW1VtvkBi5tLKNLNBIPzBuBpO/P7Pr961uoovNfuiTIPh7WtImo7ooKWBpuKQtaZa4hCps
 hgvHd1Gafv4g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,384,1599548400"; 
   d="scan'208";a="345478662"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.51])
  by orsmga002.jf.intel.com with ESMTP; 01 Dec 2020 06:24:59 -0800
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Marco Chiappero <marco.chiappero@intel.com>,
        Tomaszx Kowalik <tomaszx.kowalik@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH 3/3] crypto: qat - add capability detection logic in qat_4xxx
Date:   Tue,  1 Dec 2020 14:24:51 +0000
Message-Id: <20201201142451.138221-4-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201201142451.138221-1-giovanni.cabiddu@intel.com>
References: <20201201142451.138221-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Marco Chiappero <marco.chiappero@intel.com>

Add logic to detect device capabilities in qat_4xxx driver.

Read fuses and build the device capabilities mask. This will enable
services and handling specific to QAT 4xxx devices.

Co-developed-by: Tomaszx Kowalik <tomaszx.kowalik@intel.com>
Signed-off-by: Tomaszx Kowalik <tomaszx.kowalik@intel.com>
Signed-off-by: Marco Chiappero <marco.chiappero@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 .../crypto/qat/qat_4xxx/adf_4xxx_hw_data.c    | 24 +++++++++++++++++++
 .../crypto/qat/qat_4xxx/adf_4xxx_hw_data.h    | 11 +++++++++
 drivers/crypto/qat/qat_4xxx/adf_drv.c         |  3 +++
 3 files changed, 38 insertions(+)

diff --git a/drivers/crypto/qat/qat_4xxx/adf_4xxx_hw_data.c b/drivers/crypto/qat/qat_4xxx/adf_4xxx_hw_data.c
index e7a7c1e3da28..344bfae45bff 100644
--- a/drivers/crypto/qat/qat_4xxx/adf_4xxx_hw_data.c
+++ b/drivers/crypto/qat/qat_4xxx/adf_4xxx_hw_data.c
@@ -5,6 +5,7 @@
 #include <adf_pf2vf_msg.h>
 #include <adf_gen4_hw_data.h>
 #include "adf_4xxx_hw_data.h"
+#include "icp_qat_hw.h"
 
 struct adf_fw_config {
 	u32 ae_mask;
@@ -91,6 +92,28 @@ static void set_msix_default_rttable(struct adf_accel_dev *accel_dev)
 		ADF_CSR_WR(csr, ADF_4XXX_MSIX_RTTABLE_OFFSET(i), i);
 }
 
+static u32 get_accel_cap(struct adf_accel_dev *accel_dev)
+{
+	struct pci_dev *pdev = accel_dev->accel_pci_dev.pci_dev;
+	u32 fusectl1;
+	u32 capabilities = ICP_ACCEL_CAPABILITIES_CRYPTO_SYMMETRIC |
+			   ICP_ACCEL_CAPABILITIES_CRYPTO_ASYMMETRIC |
+			   ICP_ACCEL_CAPABILITIES_AUTHENTICATION |
+			   ICP_ACCEL_CAPABILITIES_AES_V2;
+
+	/* Read accelerator capabilities mask */
+	pci_read_config_dword(pdev, ADF_4XXX_FUSECTL1_OFFSET, &fusectl1);
+
+	if (fusectl1 & ICP_ACCEL_4XXX_MASK_CIPHER_SLICE)
+		capabilities &= ~ICP_ACCEL_CAPABILITIES_CRYPTO_SYMMETRIC;
+	if (fusectl1 & ICP_ACCEL_4XXX_MASK_AUTH_SLICE)
+		capabilities &= ~ICP_ACCEL_CAPABILITIES_AUTHENTICATION;
+	if (fusectl1 & ICP_ACCEL_4XXX_MASK_PKE_SLICE)
+		capabilities &= ~ICP_ACCEL_CAPABILITIES_CRYPTO_ASYMMETRIC;
+
+	return capabilities;
+}
+
 static enum dev_sku_info get_sku(struct adf_hw_device_data *self)
 {
 	return DEV_SKU_1;
@@ -189,6 +212,7 @@ void adf_init_hw_data_4xxx(struct adf_hw_device_data *hw_data)
 	hw_data->get_misc_bar_id = get_misc_bar_id;
 	hw_data->get_arb_info = get_arb_info;
 	hw_data->get_admin_info = get_admin_info;
+	hw_data->get_accel_cap = get_accel_cap;
 	hw_data->get_sku = get_sku;
 	hw_data->fw_name = ADF_4XXX_FW;
 	hw_data->fw_mmp_name = ADF_4XXX_MMP;
diff --git a/drivers/crypto/qat/qat_4xxx/adf_4xxx_hw_data.h b/drivers/crypto/qat/qat_4xxx/adf_4xxx_hw_data.h
index cdde0be886bf..4fe2a776293c 100644
--- a/drivers/crypto/qat/qat_4xxx/adf_4xxx_hw_data.h
+++ b/drivers/crypto/qat/qat_4xxx/adf_4xxx_hw_data.h
@@ -69,6 +69,17 @@
 #define ADF_4XXX_ASYM_OBJ	"qat_4xxx_asym.bin"
 #define ADF_4XXX_ADMIN_OBJ	"qat_4xxx_admin.bin"
 
+/* qat_4xxx fuse bits are different from old GENs, redefine them */
+enum icp_qat_4xxx_slice_mask {
+	ICP_ACCEL_4XXX_MASK_CIPHER_SLICE = BIT(0),
+	ICP_ACCEL_4XXX_MASK_AUTH_SLICE = BIT(1),
+	ICP_ACCEL_4XXX_MASK_PKE_SLICE = BIT(2),
+	ICP_ACCEL_4XXX_MASK_COMPRESS_SLICE = BIT(3),
+	ICP_ACCEL_4XXX_MASK_UCS_SLICE = BIT(4),
+	ICP_ACCEL_4XXX_MASK_EIA3_SLICE = BIT(5),
+	ICP_ACCEL_4XXX_MASK_SMX_SLICE = BIT(6),
+};
+
 void adf_init_hw_data_4xxx(struct adf_hw_device_data *hw_data);
 void adf_clean_hw_data_4xxx(struct adf_hw_device_data *hw_data);
 
diff --git a/drivers/crypto/qat/qat_4xxx/adf_drv.c b/drivers/crypto/qat/qat_4xxx/adf_drv.c
index de5a955f406a..a8805c815d16 100644
--- a/drivers/crypto/qat/qat_4xxx/adf_drv.c
+++ b/drivers/crypto/qat/qat_4xxx/adf_drv.c
@@ -233,6 +233,9 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64));
 	}
 
+	/* Get accelerator capabilities mask */
+	hw_data->accel_capabilities_mask = hw_data->get_accel_cap(accel_dev);
+
 	/* Find and map all the device's BARS */
 	bar_mask = pci_select_bars(pdev, IORESOURCE_MEM) & ADF_4XXX_BAR_MASK;
 
-- 
2.28.0

