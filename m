Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0427CD6E63
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Oct 2023 12:36:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234809AbjJKMg2 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 11 Oct 2023 08:36:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232235AbjJKMgX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 11 Oct 2023 08:36:23 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9158C98
        for <linux-crypto@vger.kernel.org>; Wed, 11 Oct 2023 05:36:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697027781; x=1728563781;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=cXfs487pSJOrqfGdfqOio9uWlDdKlChQoRN+ItQtUy0=;
  b=EOJAbA+1g8K29XcabFSBzfi+t+2yYT2wT3+ANndVFF4Tk5a3gRR6WDD7
   jsmXVAOTF/A3d7/ONjEuVAPV5orNJT5iWy8oNryNFY0DRJ2SYy7Re8m3o
   3bH2jXQHOoHNjkcnL8BAJFMlpe8Wi6WfttRF3jzouJ1FQLLPUbdirjbQG
   toldmqiMheT4nRno5RiNZYw0a2fs1cMtJ7qZB8/NMGg27NOW061/gg66D
   k4H+drpsY5kPOq3VZv8yCZCkHh4WTmcp83bERrYrUTKE2xHTtauOQBNuT
   Yh76GYYlA6CRVLSjmwJIO1GJp7nj7H5c81XapvQxkmJ1YT2oPLkfkKTIr
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10860"; a="374992894"
X-IronPort-AV: E=Sophos;i="6.03,216,1694761200"; 
   d="scan'208";a="374992894"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Oct 2023 05:36:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10860"; a="870124673"
X-IronPort-AV: E=Sophos;i="6.03,216,1694761200"; 
   d="scan'208";a="870124673"
Received: from r031s002_zp31l10c01.deacluster.intel.com (HELO localhost.localdomain) ([10.219.171.29])
  by fmsmga002.fm.intel.com with ESMTP; 11 Oct 2023 05:36:20 -0700
From:   Damian Muszynski <damian.muszynski@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Damian Muszynski <damian.muszynski@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH 07/11] crypto: qat - add retrieval of fw capabilities
Date:   Wed, 11 Oct 2023 14:15:05 +0200
Message-ID: <20231011121934.45255-8-damian.muszynski@intel.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231011121934.45255-1-damian.muszynski@intel.com>
References: <20231011121934.45255-1-damian.muszynski@intel.com>
MIME-Version: 1.0
Organization: Intel Technology Poland sp. z o.o. - ul. Slowackiego 173, 80-298 Gdansk - KRS 101882 - NIP 957-07-52-316
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The QAT firmware provides a mechanism to retrieve its capabilities
through the init admin interface.

Add logic to retrieve the firmware capability mask from the firmware
through the init/admin channel. This mask reports if the
power management, telemetry and rate limiting features are supported.

The fw capabilities are stored in the accel_dev structure and are used
to detect if a certain feature is supported by the firmware loaded
in the device.

This is supported only by devices which have an admin AE.

Signed-off-by: Damian Muszynski <damian.muszynski@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 .../intel/qat/qat_common/adf_accel_devices.h  |  1 +
 .../crypto/intel/qat/qat_common/adf_admin.c   | 25 +++++++++++++++++++
 .../qat/qat_common/icp_qat_fw_init_admin.h    |  3 +++
 3 files changed, 29 insertions(+)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h b/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h
index 3674904d0527..45742226a96f 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h
@@ -221,6 +221,7 @@ struct adf_hw_device_data {
 	u32 straps;
 	u32 accel_capabilities_mask;
 	u32 extended_dc_capabilities;
+	u16 fw_capabilities;
 	u32 clock_frequency;
 	u32 instance_id;
 	u16 accel_mask;
diff --git a/drivers/crypto/intel/qat/qat_common/adf_admin.c b/drivers/crypto/intel/qat/qat_common/adf_admin.c
index 15ffda582334..9ff00eb4cc67 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_admin.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_admin.c
@@ -310,6 +310,26 @@ static bool is_dcc_enabled(struct adf_accel_dev *accel_dev)
 	return !strcmp(services, "dcc");
 }
 
+static int adf_get_fw_capabilities(struct adf_accel_dev *accel_dev, u16 *caps)
+{
+	u32 ae_mask = accel_dev->hw_device->admin_ae_mask;
+	struct icp_qat_fw_init_admin_resp resp = { };
+	struct icp_qat_fw_init_admin_req req = { };
+	int ret;
+
+	if (!ae_mask)
+		return 0;
+
+	req.cmd_id = ICP_QAT_FW_CAPABILITIES_GET;
+	ret = adf_send_admin(accel_dev, &req, &resp, ae_mask);
+	if (ret)
+		return ret;
+
+	*caps = resp.fw_capabilities;
+
+	return 0;
+}
+
 /**
  * adf_send_admin_init() - Function sends init message to FW
  * @accel_dev: Pointer to acceleration device.
@@ -321,6 +341,7 @@ static bool is_dcc_enabled(struct adf_accel_dev *accel_dev)
 int adf_send_admin_init(struct adf_accel_dev *accel_dev)
 {
 	u32 dc_capabilities = 0;
+	u16 fw_capabilities = 0;
 	int ret;
 
 	ret = adf_set_fw_constants(accel_dev);
@@ -340,6 +361,10 @@ int adf_send_admin_init(struct adf_accel_dev *accel_dev)
 	}
 	accel_dev->hw_device->extended_dc_capabilities = dc_capabilities;
 
+	ret = adf_get_fw_capabilities(accel_dev, &fw_capabilities);
+	if (!ret)
+		accel_dev->hw_device->fw_capabilities = fw_capabilities;
+
 	return adf_init_ae(accel_dev);
 }
 EXPORT_SYMBOL_GPL(adf_send_admin_init);
diff --git a/drivers/crypto/intel/qat/qat_common/icp_qat_fw_init_admin.h b/drivers/crypto/intel/qat/qat_common/icp_qat_fw_init_admin.h
index 9e5ce419d875..e4de9a30e0bd 100644
--- a/drivers/crypto/intel/qat/qat_common/icp_qat_fw_init_admin.h
+++ b/drivers/crypto/intel/qat/qat_common/icp_qat_fw_init_admin.h
@@ -16,6 +16,7 @@ enum icp_qat_fw_init_admin_cmd_id {
 	ICP_QAT_FW_HEARTBEAT_SYNC = 7,
 	ICP_QAT_FW_HEARTBEAT_GET = 8,
 	ICP_QAT_FW_COMP_CAPABILITY_GET = 9,
+	ICP_QAT_FW_CRYPTO_CAPABILITY_GET = 10,
 	ICP_QAT_FW_DC_CHAIN_INIT = 11,
 	ICP_QAT_FW_HEARTBEAT_TIMER_SET = 13,
 	ICP_QAT_FW_TIMER_GET = 19,
@@ -109,10 +110,12 @@ struct icp_qat_fw_init_admin_resp {
 			__u32 unsuccessful_count;
 			__u64 resrvd8;
 		};
+		__u16 fw_capabilities;
 	};
 } __packed;
 
 #define ICP_QAT_FW_SYNC ICP_QAT_FW_HEARTBEAT_SYNC
+#define ICP_QAT_FW_CAPABILITIES_GET ICP_QAT_FW_CRYPTO_CAPABILITY_GET
 
 #define ICP_QAT_NUMBER_OF_PM_EVENTS 8
 
-- 
2.41.0

