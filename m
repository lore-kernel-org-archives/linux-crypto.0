Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7279AC433EF
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Dec 2021 09:11:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232888AbhLPJLv (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 16 Dec 2021 04:11:51 -0500
Received: from mga12.intel.com ([192.55.52.136]:9692 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232596AbhLPJLi (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Dec 2021 04:11:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639645898; x=1671181898;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=m6vmzx024UB2uvhlh0srr97NoXKZYZPYpv/vWiidmCc=;
  b=Eznxk9qxZoXR1JCdWzApcdEA5Qv/CUiTRyHBByOeIj4UvpveZuLOXAsg
   2TQaAxpWtWjuW+y+LX0oDr/axrm/Y8AO4ilV6FZHLTmBxZc5Ek0alTl0l
   29UEBYtOOywcb88+U9g9wO0TmNRKuR+2aTjAgcKdIhNK04kHp9zsxxhLB
   8OCmSGb18bT2u5VONGl2CWfY6j4+RQX3FEhrIrhaENn/QGHk43L+qqyTF
   iJaTfPV4CiF4rncz3pLH+nV+mXuSiZtAn7Iwdg0ugjrg6iAIbKe1zrjmp
   hcdxpAs5gaV82e8nramQxO1sUL//Zn8BJnlE6eqR7TLrZFf7aSYs0L5+b
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10199"; a="219458453"
X-IronPort-AV: E=Sophos;i="5.88,211,1635231600"; 
   d="scan'208";a="219458453"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2021 01:11:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,211,1635231600"; 
   d="scan'208";a="465968524"
Received: from silpixa00393544.ir.intel.com ([10.237.213.118])
  by orsmga006.jf.intel.com with ESMTP; 16 Dec 2021 01:11:36 -0800
From:   Marco Chiappero <marco.chiappero@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        giovanni.cabiddu@intel.com, marco.chiappero@intel.com,
        Fiona Trahe <fiona.trahe@intel.com>
Subject: [PATCH 14/24] crypto: qat - store the PFVF protocol version of the endpoints
Date:   Thu, 16 Dec 2021 09:13:24 +0000
Message-Id: <20211216091334.402420-15-marco.chiappero@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211216091334.402420-1-marco.chiappero@intel.com>
References: <20211216091334.402420-1-marco.chiappero@intel.com>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch adds an entry for storing the PFVF protocol version for both
PF and VFs. While not currently used, knowing and storing the remote
protocol version enables more complex compatibility checks and/or newer
features for compatible PFVF endpoints in the future.

Signed-off-by: Marco Chiappero <marco.chiappero@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Fiona Trahe <fiona.trahe@intel.com>
---
 drivers/crypto/qat/qat_common/adf_accel_devices.h | 3 ++-
 drivers/crypto/qat/qat_common/adf_pfvf_pf_proto.c | 5 +++++
 drivers/crypto/qat/qat_common/adf_pfvf_vf_msg.c   | 2 +-
 drivers/crypto/qat/qat_common/adf_sriov.c         | 1 +
 4 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_accel_devices.h b/drivers/crypto/qat/qat_common/adf_accel_devices.h
index d5ccefc04153..1fb32f3e78df 100644
--- a/drivers/crypto/qat/qat_common/adf_accel_devices.h
+++ b/drivers/crypto/qat/qat_common/adf_accel_devices.h
@@ -249,6 +249,7 @@ struct adf_accel_vf_info {
 	struct ratelimit_state vf2pf_ratelimit;
 	u32 vf_nr;
 	bool init;
+	u8 vf_compat_ver;
 };
 
 struct adf_accel_dev {
@@ -278,7 +279,7 @@ struct adf_accel_dev {
 			struct mutex vf2pf_lock; /* protect CSR access */
 			struct completion msg_received;
 			struct pfvf_message response; /* temp field holding pf2vf response */
-			u8 pf_version;
+			u8 pf_compat_ver;
 		} vf;
 	};
 	bool is_vf;
diff --git a/drivers/crypto/qat/qat_common/adf_pfvf_pf_proto.c b/drivers/crypto/qat/qat_common/adf_pfvf_pf_proto.c
index 8785b9d1df91..f461aa0a95c7 100644
--- a/drivers/crypto/qat/qat_common/adf_pfvf_pf_proto.c
+++ b/drivers/crypto/qat/qat_common/adf_pfvf_pf_proto.c
@@ -64,6 +64,8 @@ static int adf_handle_vf2pf_msg(struct adf_accel_dev *accel_dev, u8 vf_nr,
 		else
 			compat = ADF_PF2VF_VF_COMPAT_UNKNOWN;
 
+		vf_info->vf_compat_ver = vf_compat_ver;
+
 		resp->type = ADF_PF2VF_MSGTYPE_VERSION_RESP;
 		resp->data = FIELD_PREP(ADF_PF2VF_VERSION_RESP_VERS_MASK,
 					ADF_PFVF_COMPAT_THIS_VERSION) |
@@ -78,6 +80,9 @@ static int adf_handle_vf2pf_msg(struct adf_accel_dev *accel_dev, u8 vf_nr,
 			"Legacy VersionRequest received from VF%d to PF (vers 1.1)\n",
 			vf_nr);
 
+		/* legacy driver, VF compat_ver is 0 */
+		vf_info->vf_compat_ver = 0;
+
 		/* PF always newer than legacy VF */
 		compat = ADF_PF2VF_VF_COMPATIBLE;
 
diff --git a/drivers/crypto/qat/qat_common/adf_pfvf_vf_msg.c b/drivers/crypto/qat/qat_common/adf_pfvf_vf_msg.c
index 130d7b9c12ea..307d593042f3 100644
--- a/drivers/crypto/qat/qat_common/adf_pfvf_vf_msg.c
+++ b/drivers/crypto/qat/qat_common/adf_pfvf_vf_msg.c
@@ -89,6 +89,6 @@ int adf_vf2pf_request_version(struct adf_accel_dev *accel_dev)
 		return -EINVAL;
 	}
 
-	accel_dev->vf.pf_version = pf_version;
+	accel_dev->vf.pf_compat_ver = pf_version;
 	return 0;
 }
diff --git a/drivers/crypto/qat/qat_common/adf_sriov.c b/drivers/crypto/qat/qat_common/adf_sriov.c
index 429990c5e0f3..6366622ff8fd 100644
--- a/drivers/crypto/qat/qat_common/adf_sriov.c
+++ b/drivers/crypto/qat/qat_common/adf_sriov.c
@@ -58,6 +58,7 @@ static int adf_enable_sriov(struct adf_accel_dev *accel_dev)
 		/* This ptr will be populated when VFs will be created */
 		vf_info->accel_dev = accel_dev;
 		vf_info->vf_nr = i;
+		vf_info->vf_compat_ver = 0;
 
 		mutex_init(&vf_info->pf2vf_lock);
 		ratelimit_state_init(&vf_info->vf2pf_ratelimit,
-- 
2.31.1

