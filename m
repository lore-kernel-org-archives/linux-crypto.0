Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02C59C433F5
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Dec 2021 09:11:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232874AbhLPJLN (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 16 Dec 2021 04:11:13 -0500
Received: from mga12.intel.com ([192.55.52.136]:9653 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232918AbhLPJLM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Dec 2021 04:11:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639645872; x=1671181872;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=oRzaw12IvoUAxq2hBwVd5TkUfAa36ZjPFxN6j28n7lE=;
  b=gsYM+wxR7H8Xh+ji3aZoGYWRIUjxO551sHIbhMB6GSL3J9QWYDDxf4mR
   p67h746uxW03bEXdOSHJvpYmVVm+5fbe6dGmnpaqTLtQ/uf2UxVpHgMpp
   27aZeyXIGr0657g+IjK+v2e6N4g8AlIQ6FxhJnepMJ46u6MzWtgGg5F31
   VCq3eQPG+s0DPt3QapgCMyoMo5NUGg32Qk3iBb3UVDm+8H215evhyuY4M
   Epp4kQxOr7QwKnuApl6eBf6b5gdjKORoGAE2bFk0ivRmRD77eCNQU1pbs
   GSv8xNowZmur6qqXvlujufjMCtRTv9ytsj5Lb+rKGRt47PLUCItl5YEtQ
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10199"; a="219458334"
X-IronPort-AV: E=Sophos;i="5.88,211,1635231600"; 
   d="scan'208";a="219458334"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2021 01:11:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,211,1635231600"; 
   d="scan'208";a="465968399"
Received: from silpixa00393544.ir.intel.com ([10.237.213.118])
  by orsmga006.jf.intel.com with ESMTP; 16 Dec 2021 01:11:10 -0800
From:   Marco Chiappero <marco.chiappero@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        giovanni.cabiddu@intel.com, marco.chiappero@intel.com,
        Fiona Trahe <fiona.trahe@intel.com>
Subject: [PATCH 01/24] crypto: qat - get compression extended capabilities
Date:   Thu, 16 Dec 2021 09:13:11 +0000
Message-Id: <20211216091334.402420-2-marco.chiappero@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211216091334.402420-1-marco.chiappero@intel.com>
References: <20211216091334.402420-1-marco.chiappero@intel.com>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

Get compression extended capabilities mask from firmware through the
init/admin channel.
These capabilities are stored in the accel_dev structure and will be
communicated to VF through the PFVF channel.

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Marco Chiappero <marco.chiappero@intel.com>
Reviewed-by: Fiona Trahe <fiona.trahe@intel.com>
Reviewed-by: Marco Chiappero <marco.chiappero@intel.com>
---
 .../crypto/qat/qat_common/adf_accel_devices.h |  1 +
 drivers/crypto/qat/qat_common/adf_admin.c     | 37 +++++++++++++++++++
 .../qat/qat_common/icp_qat_fw_init_admin.h    |  4 +-
 3 files changed, 41 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/qat/qat_common/adf_accel_devices.h b/drivers/crypto/qat/qat_common/adf_accel_devices.h
index a1809a7d1c90..2c380fa10a09 100644
--- a/drivers/crypto/qat/qat_common/adf_accel_devices.h
+++ b/drivers/crypto/qat/qat_common/adf_accel_devices.h
@@ -198,6 +198,7 @@ struct adf_hw_device_data {
 	u32 fuses;
 	u32 straps;
 	u32 accel_capabilities_mask;
+	u32 extended_dc_capabilities;
 	u32 instance_id;
 	u16 accel_mask;
 	u32 ae_mask;
diff --git a/drivers/crypto/qat/qat_common/adf_admin.c b/drivers/crypto/qat/qat_common/adf_admin.c
index 43680e178242..c381b89d548d 100644
--- a/drivers/crypto/qat/qat_common/adf_admin.c
+++ b/drivers/crypto/qat/qat_common/adf_admin.c
@@ -194,6 +194,35 @@ static int adf_set_fw_constants(struct adf_accel_dev *accel_dev)
 	return adf_send_admin(accel_dev, &req, &resp, ae_mask);
 }
 
+static int adf_get_dc_capabilities(struct adf_accel_dev *accel_dev,
+				   u32 *capabilities)
+{
+	struct adf_hw_device_data *hw_device = accel_dev->hw_device;
+	struct icp_qat_fw_init_admin_resp resp;
+	struct icp_qat_fw_init_admin_req req;
+	unsigned long ae_mask;
+	unsigned long ae;
+	int ret;
+
+	/* Target only service accelerator engines */
+	ae_mask = hw_device->ae_mask & ~hw_device->admin_ae_mask;
+
+	memset(&req, 0, sizeof(req));
+	memset(&resp, 0, sizeof(resp));
+	req.cmd_id = ICP_QAT_FW_COMP_CAPABILITY_GET;
+
+	*capabilities = 0;
+	for_each_set_bit(ae, &ae_mask, GET_MAX_ACCELENGINES(accel_dev)) {
+		ret = adf_send_admin(accel_dev, &req, &resp, 1ULL << ae);
+		if (ret)
+			return ret;
+
+		*capabilities |= resp.extended_features;
+	}
+
+	return 0;
+}
+
 /**
  * adf_send_admin_init() - Function sends init message to FW
  * @accel_dev: Pointer to acceleration device.
@@ -204,8 +233,16 @@ static int adf_set_fw_constants(struct adf_accel_dev *accel_dev)
  */
 int adf_send_admin_init(struct adf_accel_dev *accel_dev)
 {
+	u32 dc_capabilities = 0;
 	int ret;
 
+	ret = adf_get_dc_capabilities(accel_dev, &dc_capabilities);
+	if (ret) {
+		dev_err(&GET_DEV(accel_dev), "Cannot get dc capabilities\n");
+		return ret;
+	}
+	accel_dev->hw_device->extended_dc_capabilities = dc_capabilities;
+
 	ret = adf_set_fw_constants(accel_dev);
 	if (ret)
 		return ret;
diff --git a/drivers/crypto/qat/qat_common/icp_qat_fw_init_admin.h b/drivers/crypto/qat/qat_common/icp_qat_fw_init_admin.h
index f05ad17fbdd6..afe59a7684ac 100644
--- a/drivers/crypto/qat/qat_common/icp_qat_fw_init_admin.h
+++ b/drivers/crypto/qat/qat_common/icp_qat_fw_init_admin.h
@@ -14,7 +14,8 @@ enum icp_qat_fw_init_admin_cmd_id {
 	ICP_QAT_FW_COUNTERS_GET = 5,
 	ICP_QAT_FW_LOOPBACK = 6,
 	ICP_QAT_FW_HEARTBEAT_SYNC = 7,
-	ICP_QAT_FW_HEARTBEAT_GET = 8
+	ICP_QAT_FW_HEARTBEAT_GET = 8,
+	ICP_QAT_FW_COMP_CAPABILITY_GET = 9,
 };
 
 enum icp_qat_fw_init_admin_resp_status {
@@ -52,6 +53,7 @@ struct icp_qat_fw_init_admin_resp {
 			__u16 version_minor_num;
 			__u16 version_major_num;
 		};
+		__u32 extended_features;
 	};
 	__u64 opaque_data;
 	union {
-- 
2.31.1

