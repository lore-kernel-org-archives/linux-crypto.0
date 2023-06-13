Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB3E4C77B7A
	for <linux-crypto@archiver.kernel.org>; Tue, 13 Jun 2023 10:35:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241430AbjFMKfa (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 13 Jun 2023 06:35:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242097AbjFMKfG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 13 Jun 2023 06:35:06 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F301199A
        for <linux-crypto@vger.kernel.org>; Tue, 13 Jun 2023 03:34:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686652448; x=1718188448;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=HsUrglzc7HZJxd/lr5cCRuM2gkarevwXtZ2UhXP9MCk=;
  b=AEeEgL1WZ8CilqrPE4iIoDE8v1wJmxt95EHzwx1alBgXW7Dp/FClm8kP
   LrbbeQQzp6EVOD/EhYivxDXR69z5+ogAgnDlml7Jwpev99bjN96FrWPZb
   DZnZGzX1Ba7vA7WiAVKt/Yxy41YAA9qqOFngjCqzbwYKEr9oKQbsXxWOX
   +/gtO2hHf7J6hcxT7P66T+bzWbHr8ys+OhsGEuMr9JxsClPmx7mAKBNS+
   qfT3QyXw4SpM9k1zhMc7wfMHgCEqZpFnNLWH4Q4Wk4YhItT0NZd6SENVG
   DWvw+dTfJqkepZBv1RgYLJbDxtebiFlfgTbrIIl8FeE3t/UWkY9TmiAVq
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10739"; a="424174319"
X-IronPort-AV: E=Sophos;i="6.00,239,1681196400"; 
   d="scan'208";a="424174319"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2023 03:29:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10739"; a="835834834"
X-IronPort-AV: E=Sophos;i="6.00,239,1681196400"; 
   d="scan'208";a="835834834"
Received: from sdpcloudhostegs034.jf.intel.com ([10.165.126.39])
  by orsmga004.jf.intel.com with ESMTP; 13 Jun 2023 03:29:35 -0700
From:   Lucas Segarra Fernandez <lucas.segarra.fernandez@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Lucas Segarra Fernandez <lucas.segarra.fernandez@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH] crypto: qat - remove idle_filter setting
Date:   Tue, 13 Jun 2023 12:29:23 +0200
Message-Id: <20230613102923.109818-1-lucas.segarra.fernandez@intel.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Organization: Intel Technology Poland sp. z o.o. - ul. Slowackiego 173, 80-298 Gdansk - KRS 101882 - NIP 957-07-52-316
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The field `idle_filter` in the CPM_PM_FW_INIT CSR determines
after how much time the device will be transition to a low power
state if it is detected to be idle.

This value is managed by FW regardless of what SW sets.

Make the `idle_filter` field in the FW interface as reserved.

Signed-off-by: Lucas Segarra Fernandez <lucas.segarra.fernandez@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/intel/qat/qat_common/adf_admin.c      | 12 +-----------
 drivers/crypto/intel/qat/qat_common/adf_common_drv.h |  2 +-
 drivers/crypto/intel/qat/qat_common/adf_gen4_pm.c    |  2 +-
 .../intel/qat/qat_common/icp_qat_fw_init_admin.h     |  2 +-
 4 files changed, 4 insertions(+), 14 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_admin.c b/drivers/crypto/intel/qat/qat_common/adf_admin.c
index 4a671004cbcf..44c54321c8fe 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_admin.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_admin.c
@@ -284,22 +284,13 @@ EXPORT_SYMBOL_GPL(adf_send_admin_init);
 /**
  * adf_init_admin_pm() - Function sends PM init message to FW
  * @accel_dev: Pointer to acceleration device.
- * @idle_delay: QAT HW idle time before power gating is initiated.
- *		000 - 64us
- *		001 - 128us
- *		010 - 256us
- *		011 - 512us
- *		100 - 1ms
- *		101 - 2ms
- *		110 - 4ms
- *		111 - 8ms
  *
  * Function sends to the FW the admin init message for the PM state
  * configuration.
  *
  * Return: 0 on success, error code otherwise.
  */
-int adf_init_admin_pm(struct adf_accel_dev *accel_dev, u32 idle_delay)
+int adf_init_admin_pm(struct adf_accel_dev *accel_dev)
 {
 	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
 	struct icp_qat_fw_init_admin_resp resp = {0};
@@ -312,7 +303,6 @@ int adf_init_admin_pm(struct adf_accel_dev *accel_dev, u32 idle_delay)
 	}
 
 	req.cmd_id = ICP_QAT_FW_PM_STATE_CONFIG;
-	req.idle_filter = idle_delay;
 
 	return adf_send_admin(accel_dev, &req, &resp, ae_mask);
 }
diff --git a/drivers/crypto/intel/qat/qat_common/adf_common_drv.h b/drivers/crypto/intel/qat/qat_common/adf_common_drv.h
index 40e7ea95528b..15ef47958b2a 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_common_drv.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_common_drv.h
@@ -95,7 +95,7 @@ int adf_init_admin_comms(struct adf_accel_dev *accel_dev);
 void adf_exit_admin_comms(struct adf_accel_dev *accel_dev);
 int adf_send_admin_init(struct adf_accel_dev *accel_dev);
 int adf_get_ae_fw_counters(struct adf_accel_dev *accel_dev, u16 ae, u64 *reqs, u64 *resps);
-int adf_init_admin_pm(struct adf_accel_dev *accel_dev, u32 idle_delay);
+int adf_init_admin_pm(struct adf_accel_dev *accel_dev);
 int adf_send_admin_tim_sync(struct adf_accel_dev *accel_dev, u32 cnt);
 int adf_init_arb(struct adf_accel_dev *accel_dev);
 void adf_exit_arb(struct adf_accel_dev *accel_dev);
diff --git a/drivers/crypto/intel/qat/qat_common/adf_gen4_pm.c b/drivers/crypto/intel/qat/qat_common/adf_gen4_pm.c
index 34c6cd8e27c0..dd9d3b4ca8b1 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_gen4_pm.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_gen4_pm.c
@@ -125,7 +125,7 @@ int adf_gen4_enable_pm(struct adf_accel_dev *accel_dev)
 	int ret;
 	u32 val;
 
-	ret = adf_init_admin_pm(accel_dev, ADF_GEN4_PM_DEFAULT_IDLE_FILTER);
+	ret = adf_init_admin_pm(accel_dev);
 	if (ret)
 		return ret;
 
diff --git a/drivers/crypto/intel/qat/qat_common/icp_qat_fw_init_admin.h b/drivers/crypto/intel/qat/qat_common/icp_qat_fw_init_admin.h
index d853c9242acf..7233b62cfaa7 100644
--- a/drivers/crypto/intel/qat/qat_common/icp_qat_fw_init_admin.h
+++ b/drivers/crypto/intel/qat/qat_common/icp_qat_fw_init_admin.h
@@ -40,7 +40,7 @@ struct icp_qat_fw_init_admin_req {
 		struct {
 			__u32 int_timer_ticks;
 		};
-		__u32 idle_filter;
+		__u32 resrvd5;
 	};
 
 	__u32 resrvd4;

base-commit: c2c7c99da874ec3201aabdfe04be8e26a684b3f5
-- 
2.39.2

