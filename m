Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22D5DC678D4
	for <linux-crypto@archiver.kernel.org>; Mon,  6 Mar 2023 10:57:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230076AbjCFK53 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 6 Mar 2023 05:57:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229758AbjCFK52 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 6 Mar 2023 05:57:28 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D08925E08
        for <linux-crypto@vger.kernel.org>; Mon,  6 Mar 2023 02:57:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678100247; x=1709636247;
  h=from:to:cc:subject:date:message-id;
  bh=gv6iOitMj2eEizWrrIa2pCAkzzlX7BEDNdJdIDa6LvU=;
  b=mE/Lspn/zHFiL6R09MANTl83rJUgONDlNu5RzotUSbJrHXTtJX8+qTFc
   1SzifIiG8zIjWoJfMQMcvH5HHBxPF9YypyZfyoz0h5VwoXbbsOj5XgArt
   dY+OvBBUqSrNdLDdFDzGT3hj/1p7OBuph6uLxp0m6zxBgquqtjPONBDJM
   QiW9XRySGRjea5rHVgXx42wlqGJf5yPMdPOfCzqagHkG0FpIjM2NGn8qU
   ISYM64CHHTaI53WJTBcGN2zaHEX95EDO53k3b+WtagINUucYzpZW7khZJ
   J3DJITIRIthyEQyobdTE9cIqNE5icPXSiRJgf0AByi+4nPYyLGGGhbv7+
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10640"; a="323833308"
X-IronPort-AV: E=Sophos;i="5.98,236,1673942400"; 
   d="scan'208";a="323833308"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2023 02:57:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10640"; a="706399099"
X-IronPort-AV: E=Sophos;i="5.98,236,1673942400"; 
   d="scan'208";a="706399099"
Received: from linux-gr8q.igk.intel.com ([10.102.16.18])
  by orsmga008.jf.intel.com with ESMTP; 06 Mar 2023 02:57:25 -0800
From:   Shashank Gupta <shashank.gupta@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Shashank Gupta <shashank.gupta@intel.com>
Subject: [PATCH] crypto: qat - fix apply custom thread-service mapping for dc service
Date:   Mon,  6 Mar 2023 11:09:23 -0500
Message-Id: <20230306160923.11962-1-shashank.gupta@intel.com>
X-Mailer: git-send-email 2.16.4
Organization: Intel Technology Poland sp. z o.o. - ul. Slowackiego 173, 80-298 Gdansk - KRS 101882 - NIP 957-07-52-316
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The thread to arbiter mapping for 4xxx devices does not allow to
achieve optimal performance for the compression service as it makes
all the engines to compete for the same resources.

Update the logic so that a custom optimal mapping is used for the
compression service.

Signed-off-by: Shashank Gupta <shashank.gupta@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/qat/qat_4xxx/adf_4xxx_hw_data.c        | 19 ++++++++++++++++---
 drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c      |  2 +-
 drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.c        |  2 +-
 drivers/crypto/qat/qat_common/adf_accel_devices.h     |  2 +-
 drivers/crypto/qat/qat_common/adf_hw_arbiter.c        |  2 +-
 .../crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c    |  2 +-
 6 files changed, 21 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/qat/qat_4xxx/adf_4xxx_hw_data.c b/drivers/crypto/qat/qat_4xxx/adf_4xxx_hw_data.c
index 2fb904800145..7324b86a4f40 100644
--- a/drivers/crypto/qat/qat_4xxx/adf_4xxx_hw_data.c
+++ b/drivers/crypto/qat/qat_4xxx/adf_4xxx_hw_data.c
@@ -41,12 +41,18 @@ static struct adf_fw_config adf_402xx_fw_dc_config[] = {
 };
 
 /* Worker thread to service arbiter mappings */
-static const u32 thrd_to_arb_map[ADF_4XXX_MAX_ACCELENGINES] = {
+static const u32 thrd_to_arb_map_cy[ADF_4XXX_MAX_ACCELENGINES] = {
 	0x5555555, 0x5555555, 0x5555555, 0x5555555,
 	0xAAAAAAA, 0xAAAAAAA, 0xAAAAAAA, 0xAAAAAAA,
 	0x0
 };
 
+static const u32 thrd_to_arb_map_dc[ADF_4XXX_MAX_ACCELENGINES] = {
+	0x000000FF, 0x000000FF, 0x000000FF, 0x000000FF,
+	0x000000FF, 0x000000FF, 0x000000FF, 0x000000FF,
+	0x0
+};
+
 static struct adf_hw_device_class adf_4xxx_class = {
 	.name = ADF_4XXX_DEVICE_NAME,
 	.type = DEV_4XXX,
@@ -218,9 +224,16 @@ static enum dev_sku_info get_sku(struct adf_hw_device_data *self)
 	return DEV_SKU_1;
 }
 
-static const u32 *adf_get_arbiter_mapping(void)
+static const u32 *adf_get_arbiter_mapping(struct adf_accel_dev *accel_dev)
 {
-	return thrd_to_arb_map;
+	switch (get_service_enabled(accel_dev)) {
+	case SVC_CY:
+		return thrd_to_arb_map_cy;
+	case SVC_DC:
+		return thrd_to_arb_map_dc;
+	}
+
+	return NULL;
 }
 
 static void get_arb_info(struct arb_info *arb_info)
diff --git a/drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c b/drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c
index c55c51a07677..475643654e64 100644
--- a/drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c
+++ b/drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c
@@ -75,7 +75,7 @@ static enum dev_sku_info get_sku(struct adf_hw_device_data *self)
 	return DEV_SKU_UNKNOWN;
 }
 
-static const u32 *adf_get_arbiter_mapping(void)
+static const u32 *adf_get_arbiter_mapping(struct adf_accel_dev *accel_dev)
 {
 	return thrd_to_arb_map;
 }
diff --git a/drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.c b/drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.c
index b7aa19d2fa80..e14270703670 100644
--- a/drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.c
+++ b/drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.c
@@ -77,7 +77,7 @@ static enum dev_sku_info get_sku(struct adf_hw_device_data *self)
 	return DEV_SKU_UNKNOWN;
 }
 
-static const u32 *adf_get_arbiter_mapping(void)
+static const u32 *adf_get_arbiter_mapping(struct adf_accel_dev *accel_dev)
 {
 	return thrd_to_arb_map;
 }
diff --git a/drivers/crypto/qat/qat_common/adf_accel_devices.h b/drivers/crypto/qat/qat_common/adf_accel_devices.h
index 134fc13c2210..bd19e6460899 100644
--- a/drivers/crypto/qat/qat_common/adf_accel_devices.h
+++ b/drivers/crypto/qat/qat_common/adf_accel_devices.h
@@ -190,7 +190,7 @@ struct adf_hw_device_data {
 	int (*send_admin_init)(struct adf_accel_dev *accel_dev);
 	int (*init_arb)(struct adf_accel_dev *accel_dev);
 	void (*exit_arb)(struct adf_accel_dev *accel_dev);
-	const u32 *(*get_arb_mapping)(void);
+	const u32 *(*get_arb_mapping)(struct adf_accel_dev *accel_dev);
 	int (*init_device)(struct adf_accel_dev *accel_dev);
 	int (*enable_pm)(struct adf_accel_dev *accel_dev);
 	bool (*handle_pm_interrupt)(struct adf_accel_dev *accel_dev);
diff --git a/drivers/crypto/qat/qat_common/adf_hw_arbiter.c b/drivers/crypto/qat/qat_common/adf_hw_arbiter.c
index 64e4596a24f4..da6956699246 100644
--- a/drivers/crypto/qat/qat_common/adf_hw_arbiter.c
+++ b/drivers/crypto/qat/qat_common/adf_hw_arbiter.c
@@ -36,7 +36,7 @@ int adf_init_arb(struct adf_accel_dev *accel_dev)
 		WRITE_CSR_ARB_SARCONFIG(csr, arb_off, arb, arb_cfg);
 
 	/* Map worker threads to service arbiters */
-	thd_2_arb_cfg = hw_data->get_arb_mapping();
+	thd_2_arb_cfg = hw_data->get_arb_mapping(accel_dev);
 
 	for_each_set_bit(i, &ae_mask, hw_data->num_engines)
 		WRITE_CSR_ARB_WT2SAM(csr, arb_off, wt_off, i, thd_2_arb_cfg[i]);
diff --git a/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c b/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
index bc80bb475118..1ebe0b351fae 100644
--- a/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
+++ b/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
@@ -106,7 +106,7 @@ static enum dev_sku_info get_sku(struct adf_hw_device_data *self)
 	return DEV_SKU_UNKNOWN;
 }
 
-static const u32 *adf_get_arbiter_mapping(void)
+static const u32 *adf_get_arbiter_mapping(struct adf_accel_dev *accel_dev)
 {
 	return thrd_to_arb_map;
 }
-- 
2.16.4

