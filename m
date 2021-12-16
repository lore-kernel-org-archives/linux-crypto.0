Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A8B3C433EF
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Dec 2021 09:12:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232932AbhLPJMK (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 16 Dec 2021 04:12:10 -0500
Received: from mga12.intel.com ([192.55.52.136]:9714 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233020AbhLPJME (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Dec 2021 04:12:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639645924; x=1671181924;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=B8dblDQHwmC2tLTKguHb6fpvQ+cI//N1hj+Fdn/F2qc=;
  b=i+qq3rHD+kOm80EHEAaNeOJaVWemkDk/tyyeJE8FVG+b5t57H7AS2Z8y
   /JKafLxDF/82rAdnq4gd3IQiU+jaUyU7thx5Vxv9eVJJPYUdi7vTaOCbH
   xiL1pUG+bFDYHXo0464+eEZlWwdLWYbzOBUKnNTRM+2ToyyKBr5eeQgoH
   ANXISFLke+dGucmkOvuAkxLvt3rK7TA4Tz1iiG4Yqd9H54c1l5NPJKbp3
   ZpcRVl1lDcib5GK/XEAfJkFfQ7MsXXps+UWrrLz5qpmAcz4NoPpVpmFDj
   qzTSHjoPIRVq2jc55YOqxWXWMWdSq7TUawRWou5QGX2hXqid+mJtlqj5B
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10199"; a="219458482"
X-IronPort-AV: E=Sophos;i="5.88,211,1635231600"; 
   d="scan'208";a="219458482"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2021 01:11:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,211,1635231600"; 
   d="scan'208";a="465968623"
Received: from silpixa00393544.ir.intel.com ([10.237.213.118])
  by orsmga006.jf.intel.com with ESMTP; 16 Dec 2021 01:11:46 -0800
From:   Marco Chiappero <marco.chiappero@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        giovanni.cabiddu@intel.com, marco.chiappero@intel.com,
        Fiona Trahe <fiona.trahe@intel.com>
Subject: [PATCH 19/24] crypto: qat - exchange ring-to-service mappings over PFVF
Date:   Thu, 16 Dec 2021 09:13:29 +0000
Message-Id: <20211216091334.402420-20-marco.chiappero@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211216091334.402420-1-marco.chiappero@intel.com>
References: <20211216091334.402420-1-marco.chiappero@intel.com>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

In addition to retrieving the device capabilities, a VF may also need to
retrieve the mapping of its ring pairs to crypto and or compression
services in order to work properly.

Make the VF receive the ring-to-service mappings from the PF by means of a
new REQ_RING_SVC_MAP Block Message and add the request and response
logic on VF and PF respectively. This change requires to bump the PFVF
protocol to version 4.

Signed-off-by: Marco Chiappero <marco.chiappero@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Fiona Trahe <fiona.trahe@intel.com>
---
 drivers/crypto/qat/qat_common/adf_pfvf_msg.h  | 15 ++++++++++-
 .../crypto/qat/qat_common/adf_pfvf_pf_msg.c   | 14 ++++++++++
 .../crypto/qat/qat_common/adf_pfvf_pf_msg.h   |  2 ++
 .../crypto/qat/qat_common/adf_pfvf_pf_proto.c |  1 +
 .../crypto/qat/qat_common/adf_pfvf_vf_msg.c   | 27 +++++++++++++++++++
 .../crypto/qat/qat_common/adf_pfvf_vf_msg.h   |  1 +
 .../crypto/qat/qat_common/adf_pfvf_vf_proto.c |  4 +++
 7 files changed, 63 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/qat/qat_common/adf_pfvf_msg.h b/drivers/crypto/qat/qat_common/adf_pfvf_msg.h
index df052194ece7..1d3cad7d4999 100644
--- a/drivers/crypto/qat/qat_common/adf_pfvf_msg.h
+++ b/drivers/crypto/qat/qat_common/adf_pfvf_msg.h
@@ -91,8 +91,10 @@ enum pfvf_compatibility_version {
 	ADF_PFVF_COMPAT_CAPABILITIES		= 0x02,
 	/* In-use pattern cleared by receiver */
 	ADF_PFVF_COMPAT_FAST_ACK		= 0x03,
+	/* Ring to service mapping support for non-standard mappings */
+	ADF_PFVF_COMPAT_RING_TO_SVC_MAP		= 0x04,
 	/* Reference to the latest version */
-	ADF_PFVF_COMPAT_THIS_VERSION		= 0x03,
+	ADF_PFVF_COMPAT_THIS_VERSION		= 0x04,
 };
 
 /* PF->VF Version Response */
@@ -139,6 +141,7 @@ enum pf2vf_blkmsg_error {
  */
 enum vf2pf_blkmsg_req_type {
 	ADF_VF2PF_BLKMSG_REQ_CAP_SUMMARY	= 0x02,
+	ADF_VF2PF_BLKMSG_REQ_RING_SVC_MAP	= 0x03,
 };
 
 #define ADF_VF2PF_SMALL_BLOCK_TYPE_MAX \
@@ -202,4 +205,14 @@ struct capabilities_v3 {
 	u32 frequency;
 } __packed;
 
+/* PF/VF Ring to service mapping values */
+enum blkmsg_ring_to_svc_versions {
+	ADF_PFVF_RING_TO_SVC_VERSION		= 0x01,
+};
+
+struct ring_to_svc_map_v1 {
+	struct pfvf_blkmsg_header hdr;
+	u16 map;
+} __packed;
+
 #endif /* ADF_PFVF_MSG_H */
diff --git a/drivers/crypto/qat/qat_common/adf_pfvf_pf_msg.c b/drivers/crypto/qat/qat_common/adf_pfvf_pf_msg.c
index 5732cea1c7ca..14c069f0d71a 100644
--- a/drivers/crypto/qat/qat_common/adf_pfvf_pf_msg.c
+++ b/drivers/crypto/qat/qat_common/adf_pfvf_pf_msg.c
@@ -36,3 +36,17 @@ int adf_pf_capabilities_msg_provider(struct adf_accel_dev *accel_dev,
 
 	return 0;
 }
+
+int adf_pf_ring_to_svc_msg_provider(struct adf_accel_dev *accel_dev,
+				    u8 *buffer, u8 compat)
+{
+	struct ring_to_svc_map_v1 rts_map_msg;
+
+	rts_map_msg.map = accel_dev->hw_device->ring_to_svc_map;
+	rts_map_msg.hdr.version = ADF_PFVF_RING_TO_SVC_VERSION;
+	rts_map_msg.hdr.payload_size = ADF_PFVF_BLKMSG_PAYLOAD_SIZE(rts_map_msg);
+
+	memcpy(buffer, &rts_map_msg, sizeof(rts_map_msg));
+
+	return 0;
+}
diff --git a/drivers/crypto/qat/qat_common/adf_pfvf_pf_msg.h b/drivers/crypto/qat/qat_common/adf_pfvf_pf_msg.h
index 401450bd30b0..e8982d1ac896 100644
--- a/drivers/crypto/qat/qat_common/adf_pfvf_pf_msg.h
+++ b/drivers/crypto/qat/qat_common/adf_pfvf_pf_msg.h
@@ -12,5 +12,7 @@ typedef int (*adf_pf2vf_blkmsg_provider)(struct adf_accel_dev *accel_dev,
 
 int adf_pf_capabilities_msg_provider(struct adf_accel_dev *accel_dev,
 				     u8 *buffer, u8 comapt);
+int adf_pf_ring_to_svc_msg_provider(struct adf_accel_dev *accel_dev,
+				    u8 *buffer, u8 comapt);
 
 #endif /* ADF_PFVF_PF_MSG_H */
diff --git a/drivers/crypto/qat/qat_common/adf_pfvf_pf_proto.c b/drivers/crypto/qat/qat_common/adf_pfvf_pf_proto.c
index cd728d5ac9ab..84230aac67e6 100644
--- a/drivers/crypto/qat/qat_common/adf_pfvf_pf_proto.c
+++ b/drivers/crypto/qat/qat_common/adf_pfvf_pf_proto.c
@@ -16,6 +16,7 @@ static const adf_pf2vf_blkmsg_provider pf2vf_blkmsg_providers[] = {
 	NULL,				  /* no message type defined for value 0 */
 	NULL,				  /* no message type defined for value 1 */
 	adf_pf_capabilities_msg_provider, /* ADF_VF2PF_BLKMSG_REQ_CAP_SUMMARY */
+	adf_pf_ring_to_svc_msg_provider,  /* ADF_VF2PF_BLKMSG_REQ_RING_SVC_MAP */
 };
 
 /**
diff --git a/drivers/crypto/qat/qat_common/adf_pfvf_vf_msg.c b/drivers/crypto/qat/qat_common/adf_pfvf_vf_msg.c
index b08f8544991a..14b222691c9c 100644
--- a/drivers/crypto/qat/qat_common/adf_pfvf_vf_msg.c
+++ b/drivers/crypto/qat/qat_common/adf_pfvf_vf_msg.c
@@ -138,3 +138,30 @@ int adf_vf2pf_get_capabilities(struct adf_accel_dev *accel_dev)
 
 	return 0;
 }
+
+int adf_vf2pf_get_ring_to_svc(struct adf_accel_dev *accel_dev)
+{
+	struct ring_to_svc_map_v1 rts_map_msg = { { 0 }, };
+	unsigned int len = sizeof(rts_map_msg);
+
+	if (accel_dev->vf.pf_compat_ver < ADF_PFVF_COMPAT_RING_TO_SVC_MAP)
+		/* Use already set default mappings */
+		return 0;
+
+	if (adf_send_vf2pf_blkmsg_req(accel_dev, ADF_VF2PF_BLKMSG_REQ_RING_SVC_MAP,
+				      (u8 *)&rts_map_msg, &len)) {
+		dev_err(&GET_DEV(accel_dev),
+			"QAT: Failed to get block message response\n");
+		return -EFAULT;
+	}
+
+	if (unlikely(len < sizeof(struct ring_to_svc_map_v1))) {
+		dev_err(&GET_DEV(accel_dev),
+			"RING_TO_SVC message truncated to %d bytes\n", len);
+		return -EFAULT;
+	}
+
+	/* Only v1 at present */
+	accel_dev->hw_device->ring_to_svc_map = rts_map_msg.map;
+	return 0;
+}
diff --git a/drivers/crypto/qat/qat_common/adf_pfvf_vf_msg.h b/drivers/crypto/qat/qat_common/adf_pfvf_vf_msg.h
index c1f31354c138..71bc0e3f1d93 100644
--- a/drivers/crypto/qat/qat_common/adf_pfvf_vf_msg.h
+++ b/drivers/crypto/qat/qat_common/adf_pfvf_vf_msg.h
@@ -8,6 +8,7 @@ int adf_vf2pf_notify_init(struct adf_accel_dev *accel_dev);
 void adf_vf2pf_notify_shutdown(struct adf_accel_dev *accel_dev);
 int adf_vf2pf_request_version(struct adf_accel_dev *accel_dev);
 int adf_vf2pf_get_capabilities(struct adf_accel_dev *accel_dev);
+int adf_vf2pf_get_ring_to_svc(struct adf_accel_dev *accel_dev);
 #else
 static inline int adf_vf2pf_notify_init(struct adf_accel_dev *accel_dev)
 {
diff --git a/drivers/crypto/qat/qat_common/adf_pfvf_vf_proto.c b/drivers/crypto/qat/qat_common/adf_pfvf_vf_proto.c
index b9a1cf5d58a9..0e4b8397cbe3 100644
--- a/drivers/crypto/qat/qat_common/adf_pfvf_vf_proto.c
+++ b/drivers/crypto/qat/qat_common/adf_pfvf_vf_proto.c
@@ -357,6 +357,10 @@ int adf_enable_vf2pf_comms(struct adf_accel_dev *accel_dev)
 		return ret;
 
 	ret = adf_vf2pf_get_capabilities(accel_dev);
+	if (ret)
+		return ret;
+
+	ret = adf_vf2pf_get_ring_to_svc(accel_dev);
 
 	return ret;
 }
-- 
2.31.1

