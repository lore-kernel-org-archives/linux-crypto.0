Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21719C433FE
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Dec 2021 09:11:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232527AbhLPJL4 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 16 Dec 2021 04:11:56 -0500
Received: from mga12.intel.com ([192.55.52.136]:9692 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232985AbhLPJLv (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Dec 2021 04:11:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639645911; x=1671181911;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pqUsmbGbYRtaG5ydcqhs+rbnDjkYxnIIcJf/Uzfu6Sk=;
  b=T2Yu250N5Eo79wl3EEZDUR9GSVzHf4JJAqNLeqvL1NV6Y6rYVa5uwgs1
   WaAkFy6JXQUzAp8M3eCOML2hNoUoegbWx9yp1/UBmilEKuesHGOA73Wx0
   VAYCjR4hJNUZ9iw0SLOcUz390VW/tfLs3mVgK75DxwyUqIuOEs9+prbK6
   NdF/0Ow7jgQ42+1LckGWCw48Bc5AJLk9IrKwYEEjytjUVx51wkBtYcfmU
   mqMz58XxYeEEcU0VGlTAcJqAgtXyabOE8tzgumJt/EhZ9MlrUtmDJ5EDE
   3NH/SApIVGxtoHsT8YtcQi/ZwKT5W/3Yzyp7phFIw3HShAr/nh9+eZnK9
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10199"; a="219458467"
X-IronPort-AV: E=Sophos;i="5.88,211,1635231600"; 
   d="scan'208";a="219458467"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2021 01:11:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,211,1635231600"; 
   d="scan'208";a="465968584"
Received: from silpixa00393544.ir.intel.com ([10.237.213.118])
  by orsmga006.jf.intel.com with ESMTP; 16 Dec 2021 01:11:42 -0800
From:   Marco Chiappero <marco.chiappero@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        giovanni.cabiddu@intel.com, marco.chiappero@intel.com,
        Fiona Trahe <fiona.trahe@intel.com>
Subject: [PATCH 17/24] crypto: qat - exchange device capabilities over PFVF
Date:   Thu, 16 Dec 2021 09:13:27 +0000
Message-Id: <20211216091334.402420-18-marco.chiappero@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211216091334.402420-1-marco.chiappero@intel.com>
References: <20211216091334.402420-1-marco.chiappero@intel.com>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Allow the VF driver to get the supported device capabilities through PFVF,
by adding a new block message, the Capability Summary.

This messages allows to exchange the capability through masks, which
report, depending on the Capability Summary version, up to the following
information:
- algorithms and/or services that are supported by the device (e.g.
  symmetric crypto, data compression, etc.)
- (extended) compression capabilities, with details about the compression
  service (e.g. if compress and verify is supported by this device)
- the frequency of the device

This patch supports the latest Capabilities Summary version 3 for VFs,
but will limit support for the PF driver to version 2. This change also
increases the PFVF protocol to version 2.

Signed-off-by: Marco Chiappero <marco.chiappero@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Fiona Trahe <fiona.trahe@intel.com>
---
 .../crypto/qat/qat_common/adf_accel_devices.h |  1 +
 drivers/crypto/qat/qat_common/adf_pfvf_msg.h  | 35 ++++++++++++--
 .../crypto/qat/qat_common/adf_pfvf_pf_msg.c   | 18 ++++++++
 .../crypto/qat/qat_common/adf_pfvf_pf_msg.h   |  3 ++
 .../crypto/qat/qat_common/adf_pfvf_pf_proto.c |  1 +
 .../crypto/qat/qat_common/adf_pfvf_vf_msg.c   | 46 +++++++++++++++++++
 .../crypto/qat/qat_common/adf_pfvf_vf_msg.h   |  1 +
 .../crypto/qat/qat_common/adf_pfvf_vf_proto.c | 11 ++++-
 8 files changed, 112 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_accel_devices.h b/drivers/crypto/qat/qat_common/adf_accel_devices.h
index 59f06e53d316..55e8948a8c5e 100644
--- a/drivers/crypto/qat/qat_common/adf_accel_devices.h
+++ b/drivers/crypto/qat/qat_common/adf_accel_devices.h
@@ -203,6 +203,7 @@ struct adf_hw_device_data {
 	u32 straps;
 	u32 accel_capabilities_mask;
 	u32 extended_dc_capabilities;
+	u32 clock_frequency;
 	u32 instance_id;
 	u16 accel_mask;
 	u32 ae_mask;
diff --git a/drivers/crypto/qat/qat_common/adf_pfvf_msg.h b/drivers/crypto/qat/qat_common/adf_pfvf_msg.h
index 6abbb5e05809..f418dd26a742 100644
--- a/drivers/crypto/qat/qat_common/adf_pfvf_msg.h
+++ b/drivers/crypto/qat/qat_common/adf_pfvf_msg.h
@@ -87,8 +87,10 @@ enum vf2pf_msgtype {
 
 /* VF/PF compatibility version. */
 enum pfvf_compatibility_version {
-	/* Reference to the current version */
-	ADF_PFVF_COMPAT_THIS_VERSION		= 0x01,
+	/* Support for extended capabilities */
+	ADF_PFVF_COMPAT_CAPABILITIES		= 0x02,
+	/* Reference to the latest version */
+	ADF_PFVF_COMPAT_THIS_VERSION		= 0x02,
 };
 
 /* PF->VF Version Response */
@@ -133,7 +135,9 @@ enum pf2vf_blkmsg_error {
  * 16..23 - 64 byte message
  * 24..27 - 128 byte message
  */
-/* No block messages as of yet */
+enum vf2pf_blkmsg_req_type {
+	ADF_VF2PF_BLKMSG_REQ_CAP_SUMMARY	= 0x02,
+};
 
 #define ADF_VF2PF_SMALL_BLOCK_TYPE_MAX \
 		(FIELD_MAX(ADF_VF2PF_SMALL_BLOCK_TYPE_MASK))
@@ -171,4 +175,29 @@ struct pfvf_blkmsg_header {
 #define ADF_PFVF_BLKMSG_VER_BYTE		0
 #define ADF_PFVF_BLKMSG_LEN_BYTE		1
 
+/* PF/VF Capabilities message values */
+enum blkmsg_capabilities_versions {
+	ADF_PFVF_CAPABILITIES_V1_VERSION	= 0x01,
+	ADF_PFVF_CAPABILITIES_V2_VERSION	= 0x02,
+	ADF_PFVF_CAPABILITIES_V3_VERSION	= 0x03,
+};
+
+struct capabilities_v1 {
+	struct pfvf_blkmsg_header hdr;
+	u32 ext_dc_caps;
+} __packed;
+
+struct capabilities_v2 {
+	struct pfvf_blkmsg_header hdr;
+	u32 ext_dc_caps;
+	u32 capabilities;
+} __packed;
+
+struct capabilities_v3 {
+	struct pfvf_blkmsg_header hdr;
+	u32 ext_dc_caps;
+	u32 capabilities;
+	u32 frequency;
+} __packed;
+
 #endif /* ADF_PFVF_MSG_H */
diff --git a/drivers/crypto/qat/qat_common/adf_pfvf_pf_msg.c b/drivers/crypto/qat/qat_common/adf_pfvf_pf_msg.c
index ad198b624098..5732cea1c7ca 100644
--- a/drivers/crypto/qat/qat_common/adf_pfvf_pf_msg.c
+++ b/drivers/crypto/qat/qat_common/adf_pfvf_pf_msg.c
@@ -18,3 +18,21 @@ void adf_pf2vf_notify_restarting(struct adf_accel_dev *accel_dev)
 				"Failed to send restarting msg to VF%d\n", i);
 	}
 }
+
+int adf_pf_capabilities_msg_provider(struct adf_accel_dev *accel_dev,
+				     u8 *buffer, u8 compat)
+{
+	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
+	struct capabilities_v2 caps_msg;
+
+	caps_msg.ext_dc_caps = hw_data->extended_dc_capabilities;
+	caps_msg.capabilities = hw_data->accel_capabilities_mask;
+
+	caps_msg.hdr.version = ADF_PFVF_CAPABILITIES_V2_VERSION;
+	caps_msg.hdr.payload_size =
+			ADF_PFVF_BLKMSG_PAYLOAD_SIZE(struct capabilities_v2);
+
+	memcpy(buffer, &caps_msg, sizeof(caps_msg));
+
+	return 0;
+}
diff --git a/drivers/crypto/qat/qat_common/adf_pfvf_pf_msg.h b/drivers/crypto/qat/qat_common/adf_pfvf_pf_msg.h
index 5c669f1de6e4..401450bd30b0 100644
--- a/drivers/crypto/qat/qat_common/adf_pfvf_pf_msg.h
+++ b/drivers/crypto/qat/qat_common/adf_pfvf_pf_msg.h
@@ -10,4 +10,7 @@ void adf_pf2vf_notify_restarting(struct adf_accel_dev *accel_dev);
 typedef int (*adf_pf2vf_blkmsg_provider)(struct adf_accel_dev *accel_dev,
 					 u8 *buffer, u8 compat);
 
+int adf_pf_capabilities_msg_provider(struct adf_accel_dev *accel_dev,
+				     u8 *buffer, u8 comapt);
+
 #endif /* ADF_PFVF_PF_MSG_H */
diff --git a/drivers/crypto/qat/qat_common/adf_pfvf_pf_proto.c b/drivers/crypto/qat/qat_common/adf_pfvf_pf_proto.c
index 850b5f4414a6..1256d68c3efd 100644
--- a/drivers/crypto/qat/qat_common/adf_pfvf_pf_proto.c
+++ b/drivers/crypto/qat/qat_common/adf_pfvf_pf_proto.c
@@ -15,6 +15,7 @@ typedef u8 (*pf2vf_blkmsg_data_getter_fn)(u8 const *blkmsg, u8 byte);
 static const adf_pf2vf_blkmsg_provider pf2vf_blkmsg_providers[] = {
 	NULL,				  /* no message type defined for value 0 */
 	NULL,				  /* no message type defined for value 1 */
+	adf_pf_capabilities_msg_provider, /* ADF_VF2PF_BLKMSG_REQ_CAP_SUMMARY */
 };
 
 /**
diff --git a/drivers/crypto/qat/qat_common/adf_pfvf_vf_msg.c b/drivers/crypto/qat/qat_common/adf_pfvf_vf_msg.c
index 307d593042f3..b08f8544991a 100644
--- a/drivers/crypto/qat/qat_common/adf_pfvf_vf_msg.c
+++ b/drivers/crypto/qat/qat_common/adf_pfvf_vf_msg.c
@@ -92,3 +92,49 @@ int adf_vf2pf_request_version(struct adf_accel_dev *accel_dev)
 	accel_dev->vf.pf_compat_ver = pf_version;
 	return 0;
 }
+
+int adf_vf2pf_get_capabilities(struct adf_accel_dev *accel_dev)
+{
+	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
+	struct capabilities_v3 cap_msg = { { 0 }, };
+	unsigned int len = sizeof(cap_msg);
+
+	if (accel_dev->vf.pf_compat_ver < ADF_PFVF_COMPAT_CAPABILITIES)
+		/* The PF is too old to support the extended capabilities */
+		return 0;
+
+	if (adf_send_vf2pf_blkmsg_req(accel_dev, ADF_VF2PF_BLKMSG_REQ_CAP_SUMMARY,
+				      (u8 *)&cap_msg, &len)) {
+		dev_err(&GET_DEV(accel_dev),
+			"QAT: Failed to get block message response\n");
+		return -EFAULT;
+	}
+
+	switch (cap_msg.hdr.version) {
+	default:
+		/* Newer version received, handle only the know parts */
+		fallthrough;
+	case ADF_PFVF_CAPABILITIES_V3_VERSION:
+		if (likely(len >= sizeof(struct capabilities_v3)))
+			hw_data->clock_frequency = cap_msg.frequency;
+		else
+			dev_info(&GET_DEV(accel_dev), "Could not get frequency");
+		fallthrough;
+	case ADF_PFVF_CAPABILITIES_V2_VERSION:
+		if (likely(len >= sizeof(struct capabilities_v2)))
+			hw_data->accel_capabilities_mask = cap_msg.capabilities;
+		else
+			dev_info(&GET_DEV(accel_dev), "Could not get capabilities");
+		fallthrough;
+	case ADF_PFVF_CAPABILITIES_V1_VERSION:
+		if (likely(len >= sizeof(struct capabilities_v1))) {
+			hw_data->extended_dc_capabilities = cap_msg.ext_dc_caps;
+		} else {
+			dev_err(&GET_DEV(accel_dev),
+				"Capabilities message truncated to %d bytes\n", len);
+			return -EFAULT;
+		}
+	}
+
+	return 0;
+}
diff --git a/drivers/crypto/qat/qat_common/adf_pfvf_vf_msg.h b/drivers/crypto/qat/qat_common/adf_pfvf_vf_msg.h
index 5091b5b2fd8f..c1f31354c138 100644
--- a/drivers/crypto/qat/qat_common/adf_pfvf_vf_msg.h
+++ b/drivers/crypto/qat/qat_common/adf_pfvf_vf_msg.h
@@ -7,6 +7,7 @@
 int adf_vf2pf_notify_init(struct adf_accel_dev *accel_dev);
 void adf_vf2pf_notify_shutdown(struct adf_accel_dev *accel_dev);
 int adf_vf2pf_request_version(struct adf_accel_dev *accel_dev);
+int adf_vf2pf_get_capabilities(struct adf_accel_dev *accel_dev);
 #else
 static inline int adf_vf2pf_notify_init(struct adf_accel_dev *accel_dev)
 {
diff --git a/drivers/crypto/qat/qat_common/adf_pfvf_vf_proto.c b/drivers/crypto/qat/qat_common/adf_pfvf_vf_proto.c
index 0fdd6b9892d3..a85bd6dcb62a 100644
--- a/drivers/crypto/qat/qat_common/adf_pfvf_vf_proto.c
+++ b/drivers/crypto/qat/qat_common/adf_pfvf_vf_proto.c
@@ -341,8 +341,17 @@ bool adf_recv_and_handle_pf2vf_msg(struct adf_accel_dev *accel_dev)
  */
 int adf_enable_vf2pf_comms(struct adf_accel_dev *accel_dev)
 {
+	int ret;
+
 	adf_pfvf_crc_init();
 	adf_enable_pf2vf_interrupts(accel_dev);
-	return adf_vf2pf_request_version(accel_dev);
+
+	ret = adf_vf2pf_request_version(accel_dev);
+	if (ret)
+		return ret;
+
+	ret = adf_vf2pf_get_capabilities(accel_dev);
+
+	return ret;
 }
 EXPORT_SYMBOL_GPL(adf_enable_vf2pf_comms);
-- 
2.31.1

