Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47FDBC433DB
	for <linux-crypto@archiver.kernel.org>; Mon,  4 Jan 2021 16:56:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 16594224DF
	for <linux-crypto@archiver.kernel.org>; Mon,  4 Jan 2021 16:56:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726789AbhADQ4b (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 4 Jan 2021 11:56:31 -0500
Received: from mga03.intel.com ([134.134.136.65]:2587 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726616AbhADQ4b (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 4 Jan 2021 11:56:31 -0500
IronPort-SDR: M9ia/6P1w/03zkg6QQywZYbpMzyPlgDljFRSaxNwg3OB/LUIOW5Y9LwmXu6L0v3MunOpFzxczi
 J0cb40gLjDnA==
X-IronPort-AV: E=McAfee;i="6000,8403,9854"; a="177080566"
X-IronPort-AV: E=Sophos;i="5.78,474,1599548400"; 
   d="scan'208";a="177080566"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jan 2021 08:55:50 -0800
IronPort-SDR: LsuMkwIKaICY45jlFeq6q1MDyCxwrxArd9MIwX/1aBaD862v+6M84kfX/sTw7q3P2C8EjHpIl8
 btdApyEgGrbQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,474,1599548400"; 
   d="scan'208";a="360832916"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.51])
  by orsmga002.jf.intel.com with ESMTP; 04 Jan 2021 08:55:48 -0800
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Wojciech Ziemba <wojciech.ziemba@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH] crypto: qat - configure arbiter mapping based on engines enabled
Date:   Mon,  4 Jan 2021 16:55:46 +0000
Message-Id: <20210104165546.6686-1-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Wojciech Ziemba <wojciech.ziemba@intel.com>

The hardware specific function adf_get_arbiter_mapping() modifies
the static array thrd_to_arb_map to disable mappings for AEs
that are disabled. This static array is used for each device
of the same type. If the ae mask is not identical for all devices
of the same type then the arbiter mapping returned by
adf_get_arbiter_mapping() may be wrong.

This patch fixes this problem by ensuring the static arbiter
mapping is unchanged and the device arbiter mapping is re-calculated
each time based on the static mapping.

Signed-off-by: Wojciech Ziemba <wojciech.ziemba@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 .../crypto/qat/qat_4xxx/adf_4xxx_hw_data.c    | 14 ++--------
 .../crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c  | 17 +++--------
 .../crypto/qat/qat_c62x/adf_c62x_hw_data.c    | 27 ++++--------------
 .../crypto/qat/qat_common/adf_accel_devices.h |  3 +-
 .../crypto/qat/qat_common/adf_hw_arbiter.c    |  8 ++----
 .../qat/qat_dh895xcc/adf_dh895xcc_hw_data.c   | 28 +++----------------
 6 files changed, 20 insertions(+), 77 deletions(-)

diff --git a/drivers/crypto/qat/qat_4xxx/adf_4xxx_hw_data.c b/drivers/crypto/qat/qat_4xxx/adf_4xxx_hw_data.c
index 344bfae45bff..6a9be01fdf33 100644
--- a/drivers/crypto/qat/qat_4xxx/adf_4xxx_hw_data.c
+++ b/drivers/crypto/qat/qat_4xxx/adf_4xxx_hw_data.c
@@ -19,7 +19,7 @@ static struct adf_fw_config adf_4xxx_fw_config[] = {
 };
 
 /* Worker thread to service arbiter mappings */
-static u32 thrd_to_arb_map[] = {
+static const u32 thrd_to_arb_map[ADF_4XXX_MAX_ACCELENGINES] = {
 	0x5555555, 0x5555555, 0x5555555, 0x5555555,
 	0xAAAAAAA, 0xAAAAAAA, 0xAAAAAAA, 0xAAAAAAA,
 	0x0
@@ -119,17 +119,9 @@ static enum dev_sku_info get_sku(struct adf_hw_device_data *self)
 	return DEV_SKU_1;
 }
 
-static void adf_get_arbiter_mapping(struct adf_accel_dev *accel_dev,
-				    u32 const **arb_map_config)
+static const u32 *adf_get_arbiter_mapping(void)
 {
-	struct adf_hw_device_data *hw_device = accel_dev->hw_device;
-	unsigned long ae_mask = hw_device->ae_mask;
-	int i;
-
-	for_each_clear_bit(i, &ae_mask, ADF_4XXX_MAX_ACCELENGINES)
-		thrd_to_arb_map[i] = 0;
-
-	*arb_map_config = thrd_to_arb_map;
+	return thrd_to_arb_map;
 }
 
 static void get_arb_info(struct arb_info *arb_info)
diff --git a/drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c b/drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c
index eb45f1b1ae3e..f5990d042c9a 100644
--- a/drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c
+++ b/drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c
@@ -7,8 +7,8 @@
 #include "adf_c3xxx_hw_data.h"
 #include "icp_qat_hw.h"
 
-/* Worker thread to service arbiter mappings based on dev SKUs */
-static const u32 thrd_to_arb_map_6_me_sku[] = {
+/* Worker thread to service arbiter mappings */
+static const u32 thrd_to_arb_map[ADF_C3XXX_MAX_ACCELENGINES] = {
 	0x12222AAA, 0x11222AAA, 0x12222AAA,
 	0x11222AAA, 0x12222AAA, 0x11222AAA
 };
@@ -101,18 +101,9 @@ static enum dev_sku_info get_sku(struct adf_hw_device_data *self)
 	return DEV_SKU_UNKNOWN;
 }
 
-static void adf_get_arbiter_mapping(struct adf_accel_dev *accel_dev,
-				    u32 const **arb_map_config)
+static const u32 *adf_get_arbiter_mapping(void)
 {
-	switch (accel_dev->accel_pci_dev.sku) {
-	case DEV_SKU_4:
-		*arb_map_config = thrd_to_arb_map_6_me_sku;
-		break;
-	default:
-		dev_err(&GET_DEV(accel_dev),
-			"The configuration doesn't match any SKU");
-		*arb_map_config = NULL;
-	}
+	return thrd_to_arb_map;
 }
 
 static u32 get_pf2vf_offset(u32 i)
diff --git a/drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.c b/drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.c
index babdffbcb846..cadcf12884c8 100644
--- a/drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.c
+++ b/drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.c
@@ -7,13 +7,8 @@
 #include "adf_c62x_hw_data.h"
 #include "icp_qat_hw.h"
 
-/* Worker thread to service arbiter mappings based on dev SKUs */
-static const u32 thrd_to_arb_map_8_me_sku[] = {
-	0x12222AAA, 0x11222AAA, 0x12222AAA, 0x11222AAA, 0x12222AAA,
-	0x11222AAA, 0x12222AAA, 0x11222AAA, 0, 0
-};
-
-static const u32 thrd_to_arb_map_10_me_sku[] = {
+/* Worker thread to service arbiter mappings */
+static const u32 thrd_to_arb_map[ADF_C62X_MAX_ACCELENGINES] = {
 	0x12222AAA, 0x11222AAA, 0x12222AAA, 0x11222AAA, 0x12222AAA,
 	0x11222AAA, 0x12222AAA, 0x11222AAA, 0x12222AAA, 0x11222AAA
 };
@@ -108,21 +103,9 @@ static enum dev_sku_info get_sku(struct adf_hw_device_data *self)
 	return DEV_SKU_UNKNOWN;
 }
 
-static void adf_get_arbiter_mapping(struct adf_accel_dev *accel_dev,
-				    u32 const **arb_map_config)
-{
-	switch (accel_dev->accel_pci_dev.sku) {
-	case DEV_SKU_2:
-		*arb_map_config = thrd_to_arb_map_8_me_sku;
-		break;
-	case DEV_SKU_4:
-		*arb_map_config = thrd_to_arb_map_10_me_sku;
-		break;
-	default:
-		dev_err(&GET_DEV(accel_dev),
-			"The configuration doesn't match any SKU");
-		*arb_map_config = NULL;
-	}
+static const u32 *adf_get_arbiter_mapping(void)
+{
+	return thrd_to_arb_map;
 }
 
 static u32 get_pf2vf_offset(u32 i)
diff --git a/drivers/crypto/qat/qat_common/adf_accel_devices.h b/drivers/crypto/qat/qat_common/adf_accel_devices.h
index c46a5805b294..5527344546e5 100644
--- a/drivers/crypto/qat/qat_common/adf_accel_devices.h
+++ b/drivers/crypto/qat/qat_common/adf_accel_devices.h
@@ -168,8 +168,7 @@ struct adf_hw_device_data {
 	int (*send_admin_init)(struct adf_accel_dev *accel_dev);
 	int (*init_arb)(struct adf_accel_dev *accel_dev);
 	void (*exit_arb)(struct adf_accel_dev *accel_dev);
-	void (*get_arb_mapping)(struct adf_accel_dev *accel_dev,
-				const u32 **cfg);
+	const u32 *(*get_arb_mapping)(void);
 	void (*disable_iov)(struct adf_accel_dev *accel_dev);
 	void (*configure_iov_threads)(struct adf_accel_dev *accel_dev,
 				      bool enable);
diff --git a/drivers/crypto/qat/qat_common/adf_hw_arbiter.c b/drivers/crypto/qat/qat_common/adf_hw_arbiter.c
index 9f5240d9488b..64e4596a24f4 100644
--- a/drivers/crypto/qat/qat_common/adf_hw_arbiter.c
+++ b/drivers/crypto/qat/qat_common/adf_hw_arbiter.c
@@ -19,6 +19,7 @@ int adf_init_arb(struct adf_accel_dev *accel_dev)
 {
 	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
 	void __iomem *csr = accel_dev->transport->banks[0].csr_addr;
+	unsigned long ae_mask = hw_data->ae_mask;
 	u32 arb_off, wt_off, arb_cfg;
 	const u32 *thd_2_arb_cfg;
 	struct arb_info info;
@@ -35,12 +36,9 @@ int adf_init_arb(struct adf_accel_dev *accel_dev)
 		WRITE_CSR_ARB_SARCONFIG(csr, arb_off, arb, arb_cfg);
 
 	/* Map worker threads to service arbiters */
-	hw_data->get_arb_mapping(accel_dev, &thd_2_arb_cfg);
+	thd_2_arb_cfg = hw_data->get_arb_mapping();
 
-	if (!thd_2_arb_cfg)
-		return -EFAULT;
-
-	for (i = 0; i < hw_data->num_engines; i++)
+	for_each_set_bit(i, &ae_mask, hw_data->num_engines)
 		WRITE_CSR_ARB_WT2SAM(csr, arb_off, wt_off, i, thd_2_arb_cfg[i]);
 
 	return 0;
diff --git a/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c b/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
index 1e83d9397b11..7dd7cd6c3ef8 100644
--- a/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
+++ b/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
@@ -7,14 +7,8 @@
 #include "adf_dh895xcc_hw_data.h"
 #include "icp_qat_hw.h"
 
-/* Worker thread to service arbiter mappings based on dev SKUs */
-static const u32 thrd_to_arb_map_sku4[] = {
-	0x12222AAA, 0x11666666, 0x12222AAA, 0x11666666,
-	0x12222AAA, 0x11222222, 0x12222AAA, 0x11222222,
-	0x00000000, 0x00000000, 0x00000000, 0x00000000
-};
-
-static const u32 thrd_to_arb_map_sku6[] = {
+/* Worker thread to service arbiter mappings */
+static const u32 thrd_to_arb_map[ADF_DH895XCC_MAX_ACCELENGINES] = {
 	0x12222AAA, 0x11666666, 0x12222AAA, 0x11666666,
 	0x12222AAA, 0x11222222, 0x12222AAA, 0x11222222,
 	0x12222AAA, 0x11222222, 0x12222AAA, 0x11222222
@@ -127,23 +121,9 @@ static enum dev_sku_info get_sku(struct adf_hw_device_data *self)
 	return DEV_SKU_UNKNOWN;
 }
 
-static void adf_get_arbiter_mapping(struct adf_accel_dev *accel_dev,
-				    u32 const **arb_map_config)
+static const u32 *adf_get_arbiter_mapping(void)
 {
-	switch (accel_dev->accel_pci_dev.sku) {
-	case DEV_SKU_1:
-		*arb_map_config = thrd_to_arb_map_sku4;
-		break;
-
-	case DEV_SKU_2:
-	case DEV_SKU_4:
-		*arb_map_config = thrd_to_arb_map_sku6;
-		break;
-	default:
-		dev_err(&GET_DEV(accel_dev),
-			"The configuration doesn't match any SKU");
-		*arb_map_config = NULL;
-	}
+	return thrd_to_arb_map;
 }
 
 static u32 get_pf2vf_offset(u32 i)
-- 
2.29.2

