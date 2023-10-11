Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61A79CD6E64
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Oct 2023 12:36:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232195AbjJKMgQ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 11 Oct 2023 08:36:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234748AbjJKMgP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 11 Oct 2023 08:36:15 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C1C5B8
        for <linux-crypto@vger.kernel.org>; Wed, 11 Oct 2023 05:36:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697027774; x=1728563774;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SHBQLDGP87png2JLRZ8JwfphIGtP+vutEGu+EgD6mDw=;
  b=Sj+PCi9vnGBKKipovtakeg1eyEgmHQ6QZl1aD2B3Xdy88DMiwQCVtbxF
   iBq8R+yUML6sd1DC+nOV+ULSGshhCkM0YzgzEuygqrR4TKSwIaDAae8Yk
   Lc3tvo4W8nXRJkAHaQJSiQRgxQhAfe1M8lRQOuS0kPsb7SVCiD7uf2Fgf
   TDdFTVpQjjSQ89XkybROunf8k+g1dIc42vZQjLTYv3n4fd9G/ssxWVBSY
   dyP0hHcmRDKrb/56PEnVCixN9eej5Z2bEpDSmrMcoBrBCetSOudlBrniL
   tBLQuvM1UJkDmFQd8c56DcD/tXkzHzSvGNrVGVKCyiwkDmx5aC2mE2gnE
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10860"; a="374992852"
X-IronPort-AV: E=Sophos;i="6.03,216,1694761200"; 
   d="scan'208";a="374992852"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Oct 2023 05:36:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10860"; a="870124648"
X-IronPort-AV: E=Sophos;i="6.03,216,1694761200"; 
   d="scan'208";a="870124648"
Received: from r031s002_zp31l10c01.deacluster.intel.com (HELO localhost.localdomain) ([10.219.171.29])
  by fmsmga002.fm.intel.com with ESMTP; 11 Oct 2023 05:36:12 -0700
From:   Damian Muszynski <damian.muszynski@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Damian Muszynski <damian.muszynski@intel.com>
Subject: [PATCH 03/11] crypto: qat - fix ring to service map for QAT GEN4
Date:   Wed, 11 Oct 2023 14:15:01 +0200
Message-ID: <20231011121934.45255-4-damian.muszynski@intel.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231011121934.45255-1-damian.muszynski@intel.com>
References: <20231011121934.45255-1-damian.muszynski@intel.com>
MIME-Version: 1.0
Organization: Intel Technology Poland sp. z o.o. - ul. Slowackiego 173, 80-298 Gdansk - KRS 101882 - NIP 957-07-52-316
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

The 4xxx drivers hardcode the ring to service mapping. However, when
additional configurations where added to the driver, the mappings were
not updated. This implies that an incorrect mapping might be reported
through pfvf for certain configurations.

Add an algorithm that computes the correct ring to service mapping based
on the firmware loaded on the device.

Fixes: 0cec19c761e5 ("crypto: qat - add support for compression for 4xxx")
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Damian Muszynski <damian.muszynski@intel.com>
---
 .../intel/qat/qat_4xxx/adf_4xxx_hw_data.c     | 54 +++++++++++++++++++
 .../intel/qat/qat_common/adf_accel_devices.h  |  1 +
 .../crypto/intel/qat/qat_common/adf_init.c    |  3 ++
 3 files changed, 58 insertions(+)

diff --git a/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c b/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
index 44b732fb80bc..a5691ba0b724 100644
--- a/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
@@ -423,6 +423,59 @@ static const struct adf_fw_config *get_fw_config(struct adf_accel_dev *accel_dev
 	}
 }
 
+enum adf_rp_groups {
+	RP_GROUP_0 = 0,
+	RP_GROUP_1,
+	RP_GROUP_COUNT
+};
+
+static u16 get_ring_to_svc_map(struct adf_accel_dev *accel_dev)
+{
+	enum adf_cfg_service_type rps[RP_GROUP_COUNT];
+	const struct adf_fw_config *fw_config;
+	u16 ring_to_svc_map;
+	int i, j;
+
+	fw_config = get_fw_config(accel_dev);
+	if (!fw_config)
+		return 0;
+
+	for (i = 0; i < RP_GROUP_COUNT; i++) {
+		switch (fw_config[i].ae_mask) {
+		case ADF_AE_GROUP_0:
+			j = RP_GROUP_0;
+			break;
+		case ADF_AE_GROUP_1:
+			j = RP_GROUP_1;
+			break;
+		default:
+			return 0;
+		}
+
+		switch (fw_config[i].obj) {
+		case ADF_FW_SYM_OBJ:
+			rps[j] = SYM;
+			break;
+		case ADF_FW_ASYM_OBJ:
+			rps[j] = ASYM;
+			break;
+		case ADF_FW_DC_OBJ:
+			rps[j] = COMP;
+			break;
+		default:
+			rps[j] = 0;
+			break;
+		}
+	}
+
+	ring_to_svc_map = rps[RP_GROUP_0] << ADF_CFG_SERV_RING_PAIR_0_SHIFT |
+			  rps[RP_GROUP_1] << ADF_CFG_SERV_RING_PAIR_1_SHIFT |
+			  rps[RP_GROUP_0] << ADF_CFG_SERV_RING_PAIR_2_SHIFT |
+			  rps[RP_GROUP_1] << ADF_CFG_SERV_RING_PAIR_3_SHIFT;
+
+	return ring_to_svc_map;
+}
+
 static const char *uof_get_name(struct adf_accel_dev *accel_dev, u32 obj_num,
 				const char * const fw_objs[], int num_objs)
 {
@@ -519,6 +572,7 @@ void adf_init_hw_data_4xxx(struct adf_hw_device_data *hw_data, u32 dev_id)
 	hw_data->uof_get_ae_mask = uof_get_ae_mask;
 	hw_data->set_msix_rttable = set_msix_default_rttable;
 	hw_data->set_ssm_wdtimer = adf_gen4_set_ssm_wdtimer;
+	hw_data->get_ring_to_svc_map = get_ring_to_svc_map;
 	hw_data->disable_iov = adf_disable_sriov;
 	hw_data->ring_pair_reset = adf_gen4_ring_pair_reset;
 	hw_data->enable_pm = adf_gen4_enable_pm;
diff --git a/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h b/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h
index 9677c8e0f180..3674904d0527 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h
@@ -182,6 +182,7 @@ struct adf_hw_device_data {
 	void (*get_arb_info)(struct arb_info *arb_csrs_info);
 	void (*get_admin_info)(struct admin_info *admin_csrs_info);
 	enum dev_sku_info (*get_sku)(struct adf_hw_device_data *self);
+	u16 (*get_ring_to_svc_map)(struct adf_accel_dev *accel_dev);
 	int (*alloc_irq)(struct adf_accel_dev *accel_dev);
 	void (*free_irq)(struct adf_accel_dev *accel_dev);
 	void (*enable_error_correction)(struct adf_accel_dev *accel_dev);
diff --git a/drivers/crypto/intel/qat/qat_common/adf_init.c b/drivers/crypto/intel/qat/qat_common/adf_init.c
index bccd6bf8cf63..b4cf605ccf3e 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_init.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_init.c
@@ -96,6 +96,9 @@ static int adf_dev_init(struct adf_accel_dev *accel_dev)
 		return -EFAULT;
 	}
 
+	if (hw_data->get_ring_to_svc_map)
+		hw_data->ring_to_svc_map = hw_data->get_ring_to_svc_map(accel_dev);
+
 	if (adf_ae_init(accel_dev)) {
 		dev_err(&GET_DEV(accel_dev),
 			"Failed to initialise Acceleration Engine\n");
-- 
2.41.0

