Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BA15C433FE
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Dec 2021 09:11:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232629AbhLPJL3 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 16 Dec 2021 04:11:29 -0500
Received: from mga12.intel.com ([192.55.52.136]:9675 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232971AbhLPJL0 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Dec 2021 04:11:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639645886; x=1671181886;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8fw1/SMP6K/M9KVhfpSaIj7VQtnYVbSI7od1Q+eBp0g=;
  b=Lry3oIY57dTEbJ7Zq4EQJq8foO+yy58HHUu0CKFZ8F6WIii1ttQsJGXY
   TScC6gzNZCilr4KBBIgAsLLyuU2/YMiXf5qUH0YfXmUEUCvNRV6U55b5y
   JO2fFsRTX5jykT9uoV64fwbhPwLhHAnDfPRFa4DvALmnwvZ3TTfVDIblK
   cFnax/sNf0/Gg2EJR8t27FQEZcGPW0fr0Q8K1aWHRj/aQ08OnKYKLL69O
   EXN15vwwMTBaGZlYjjJkipTXWivxmqALsDIozdVRjEJSrdRek5zZa7oaL
   HoEPMY3ZweQPINtCl6lHBe1M79asLSBAKEUpdb8eQ/L6pMH5WtRTfpqRe
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10199"; a="219458394"
X-IronPort-AV: E=Sophos;i="5.88,211,1635231600"; 
   d="scan'208";a="219458394"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2021 01:11:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,211,1635231600"; 
   d="scan'208";a="465968460"
Received: from silpixa00393544.ir.intel.com ([10.237.213.118])
  by orsmga006.jf.intel.com with ESMTP; 16 Dec 2021 01:11:24 -0800
From:   Marco Chiappero <marco.chiappero@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        giovanni.cabiddu@intel.com, marco.chiappero@intel.com,
        Fiona Trahe <fiona.trahe@intel.com>
Subject: [PATCH 08/24] crypto: qat - make PFVF send and receive direction agnostic
Date:   Thu, 16 Dec 2021 09:13:18 +0000
Message-Id: <20211216091334.402420-9-marco.chiappero@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211216091334.402420-1-marco.chiappero@intel.com>
References: <20211216091334.402420-1-marco.chiappero@intel.com>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Currently PF and VF share the same send and receive logic for the PFVF
protocol. However, the inner behaviour still depends on the specific
direction, requiring a test to determine the if the sender is a PF or a
VF. Moreover the vf_nr parameter is only required for PF2VF messages and
ignored for the opposite direction.

Make the GEN2 send and recv completely direction agnostic, by calculating
and determining any direction specific input in the caller instead, and
feeding the send and the receive functions with the same arguments for
both PF and VF. In order to accommodate for this change, the API of the
pfvf_ops send and recv has been modified to remove any reference to vf_nr.

Signed-off-by: Marco Chiappero <marco.chiappero@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Fiona Trahe <fiona.trahe@intel.com>
---
 .../crypto/qat/qat_common/adf_accel_devices.h |  5 +-
 drivers/crypto/qat/qat_common/adf_gen2_pfvf.c | 99 +++++++++++++------
 .../crypto/qat/qat_common/adf_pfvf_pf_proto.c | 11 ++-
 .../crypto/qat/qat_common/adf_pfvf_vf_proto.c | 11 ++-
 4 files changed, 89 insertions(+), 37 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_accel_devices.h b/drivers/crypto/qat/qat_common/adf_accel_devices.h
index cc8b10b23145..d65d8dda8fda 100644
--- a/drivers/crypto/qat/qat_common/adf_accel_devices.h
+++ b/drivers/crypto/qat/qat_common/adf_accel_devices.h
@@ -154,8 +154,9 @@ struct adf_pfvf_ops {
 	u32 (*get_vf2pf_sources)(void __iomem *pmisc_addr);
 	void (*enable_vf2pf_interrupts)(void __iomem *pmisc_addr, u32 vf_mask);
 	void (*disable_vf2pf_interrupts)(void __iomem *pmisc_addr, u32 vf_mask);
-	int (*send_msg)(struct adf_accel_dev *accel_dev, u32 msg, u8 vf_nr);
-	u32 (*recv_msg)(struct adf_accel_dev *accel_dev, u8 vf_nr);
+	int (*send_msg)(struct adf_accel_dev *accel_dev, u32 msg,
+			u32 pfvf_offset, struct mutex *csr_lock);
+	u32 (*recv_msg)(struct adf_accel_dev *accel_dev, u32 pfvf_offset);
 };
 
 struct adf_hw_device_data {
diff --git a/drivers/crypto/qat/qat_common/adf_gen2_pfvf.c b/drivers/crypto/qat/qat_common/adf_gen2_pfvf.c
index 2e0b9ac27393..1e45f3230c19 100644
--- a/drivers/crypto/qat/qat_common/adf_gen2_pfvf.c
+++ b/drivers/crypto/qat/qat_common/adf_gen2_pfvf.c
@@ -115,15 +115,22 @@ static bool is_legacy_user_pfvf_message(u32 msg)
 	return !(msg & ADF_PFVF_MSGORIGIN_SYSTEM);
 }
 
+struct pfvf_gen2_params {
+	u32 pfvf_offset;
+	struct mutex *csr_lock; /* lock preventing concurrent access of CSR */
+	enum gen2_csr_pos local_offset;
+	enum gen2_csr_pos remote_offset;
+};
+
 static int adf_gen2_pfvf_send(struct adf_accel_dev *accel_dev, u32 msg,
-			      u8 vf_nr)
+			      struct pfvf_gen2_params *params)
 {
 	void __iomem *pmisc_addr = adf_get_pmisc_base(accel_dev);
+	enum gen2_csr_pos remote_offset = params->remote_offset;
+	enum gen2_csr_pos local_offset = params->local_offset;
 	unsigned int retries = ADF_PFVF_MSG_MAX_RETRIES;
-	enum gen2_csr_pos remote_offset;
-	enum gen2_csr_pos local_offset;
-	struct mutex *lock;	/* lock preventing concurrent acces of CSR */
-	u32 pfvf_offset;
+	struct mutex *lock = params->csr_lock;
+	u32 pfvf_offset = params->pfvf_offset;
 	u32 count = 0;
 	u32 int_bit;
 	u32 csr_val;
@@ -136,17 +143,6 @@ static int adf_gen2_pfvf_send(struct adf_accel_dev *accel_dev, u32 msg,
 	 * it and after encoding it. Which one to shift depends on the
 	 * direction.
 	 */
-	if (accel_dev->is_vf) {
-		pfvf_offset = GET_PFVF_OPS(accel_dev)->get_vf2pf_offset(0);
-		lock = &accel_dev->vf.vf2pf_lock;
-		local_offset = ADF_GEN2_CSR_VF2PF_OFFSET;
-		remote_offset = ADF_GEN2_CSR_PF2VF_OFFSET;
-	} else {
-		pfvf_offset = GET_PFVF_OPS(accel_dev)->get_pf2vf_offset(vf_nr);
-		lock = &accel_dev->pf.vf_info[vf_nr].pf2vf_lock;
-		local_offset = ADF_GEN2_CSR_PF2VF_OFFSET;
-		remote_offset = ADF_GEN2_CSR_VF2PF_OFFSET;
-	}
 
 	int_bit = gen2_csr_get_int_bit(local_offset);
 
@@ -208,23 +204,16 @@ static int adf_gen2_pfvf_send(struct adf_accel_dev *accel_dev, u32 msg,
 	}
 }
 
-static u32 adf_gen2_pfvf_recv(struct adf_accel_dev *accel_dev, u8 vf_nr)
+static u32 adf_gen2_pfvf_recv(struct adf_accel_dev *accel_dev,
+			      struct pfvf_gen2_params *params)
 {
 	void __iomem *pmisc_addr = adf_get_pmisc_base(accel_dev);
-	enum gen2_csr_pos local_offset;
-	u32 pfvf_offset;
+	enum gen2_csr_pos local_offset = params->local_offset;
+	u32 pfvf_offset = params->pfvf_offset;
 	u32 int_bit;
 	u32 csr_val;
 	u32 msg;
 
-	if (accel_dev->is_vf) {
-		pfvf_offset = GET_PFVF_OPS(accel_dev)->get_pf2vf_offset(0);
-		local_offset = ADF_GEN2_CSR_PF2VF_OFFSET;
-	} else {
-		pfvf_offset = GET_PFVF_OPS(accel_dev)->get_vf2pf_offset(vf_nr);
-		local_offset = ADF_GEN2_CSR_VF2PF_OFFSET;
-	}
-
 	int_bit = gen2_csr_get_int_bit(local_offset);
 
 	/* Read message */
@@ -252,6 +241,54 @@ static u32 adf_gen2_pfvf_recv(struct adf_accel_dev *accel_dev, u8 vf_nr)
 	return msg;
 }
 
+static int adf_gen2_pf2vf_send(struct adf_accel_dev *accel_dev, u32 msg,
+			       u32 pfvf_offset, struct mutex *csr_lock)
+{
+	struct pfvf_gen2_params params = {
+		.csr_lock = csr_lock,
+		.pfvf_offset = pfvf_offset,
+		.local_offset = ADF_GEN2_CSR_PF2VF_OFFSET,
+		.remote_offset = ADF_GEN2_CSR_VF2PF_OFFSET,
+	};
+
+	return adf_gen2_pfvf_send(accel_dev, msg, &params);
+}
+
+static int adf_gen2_vf2pf_send(struct adf_accel_dev *accel_dev, u32 msg,
+			       u32 pfvf_offset, struct mutex *csr_lock)
+{
+	struct pfvf_gen2_params params = {
+		.csr_lock = csr_lock,
+		.pfvf_offset = pfvf_offset,
+		.local_offset = ADF_GEN2_CSR_VF2PF_OFFSET,
+		.remote_offset = ADF_GEN2_CSR_PF2VF_OFFSET,
+	};
+
+	return adf_gen2_pfvf_send(accel_dev, msg, &params);
+}
+
+static u32 adf_gen2_pf2vf_recv(struct adf_accel_dev *accel_dev, u32 pfvf_offset)
+{
+	struct pfvf_gen2_params params = {
+		.pfvf_offset = pfvf_offset,
+		.local_offset = ADF_GEN2_CSR_PF2VF_OFFSET,
+		.remote_offset = ADF_GEN2_CSR_VF2PF_OFFSET,
+	};
+
+	return adf_gen2_pfvf_recv(accel_dev, &params);
+}
+
+static u32 adf_gen2_vf2pf_recv(struct adf_accel_dev *accel_dev, u32 pfvf_offset)
+{
+	struct pfvf_gen2_params params = {
+		.pfvf_offset = pfvf_offset,
+		.local_offset = ADF_GEN2_CSR_VF2PF_OFFSET,
+		.remote_offset = ADF_GEN2_CSR_PF2VF_OFFSET,
+	};
+
+	return adf_gen2_pfvf_recv(accel_dev, &params);
+}
+
 void adf_gen2_init_pf_pfvf_ops(struct adf_pfvf_ops *pfvf_ops)
 {
 	pfvf_ops->enable_comms = adf_enable_pf2vf_comms;
@@ -260,8 +297,8 @@ void adf_gen2_init_pf_pfvf_ops(struct adf_pfvf_ops *pfvf_ops)
 	pfvf_ops->get_vf2pf_sources = adf_gen2_get_vf2pf_sources;
 	pfvf_ops->enable_vf2pf_interrupts = adf_gen2_enable_vf2pf_interrupts;
 	pfvf_ops->disable_vf2pf_interrupts = adf_gen2_disable_vf2pf_interrupts;
-	pfvf_ops->send_msg = adf_gen2_pfvf_send;
-	pfvf_ops->recv_msg = adf_gen2_pfvf_recv;
+	pfvf_ops->send_msg = adf_gen2_pf2vf_send;
+	pfvf_ops->recv_msg = adf_gen2_vf2pf_recv;
 }
 EXPORT_SYMBOL_GPL(adf_gen2_init_pf_pfvf_ops);
 
@@ -270,7 +307,7 @@ void adf_gen2_init_vf_pfvf_ops(struct adf_pfvf_ops *pfvf_ops)
 	pfvf_ops->enable_comms = adf_enable_vf2pf_comms;
 	pfvf_ops->get_pf2vf_offset = adf_gen2_vf_get_pfvf_offset;
 	pfvf_ops->get_vf2pf_offset = adf_gen2_vf_get_pfvf_offset;
-	pfvf_ops->send_msg = adf_gen2_pfvf_send;
-	pfvf_ops->recv_msg = adf_gen2_pfvf_recv;
+	pfvf_ops->send_msg = adf_gen2_vf2pf_send;
+	pfvf_ops->recv_msg = adf_gen2_pf2vf_recv;
 }
 EXPORT_SYMBOL_GPL(adf_gen2_init_vf_pfvf_ops);
diff --git a/drivers/crypto/qat/qat_common/adf_pfvf_pf_proto.c b/drivers/crypto/qat/qat_common/adf_pfvf_pf_proto.c
index fb477eb89fef..4e4daec2ae34 100644
--- a/drivers/crypto/qat/qat_common/adf_pfvf_pf_proto.c
+++ b/drivers/crypto/qat/qat_common/adf_pfvf_pf_proto.c
@@ -19,7 +19,11 @@
  */
 int adf_send_pf2vf_msg(struct adf_accel_dev *accel_dev, u8 vf_nr, u32 msg)
 {
-	return GET_PFVF_OPS(accel_dev)->send_msg(accel_dev, msg, vf_nr);
+	struct adf_pfvf_ops *pfvf_ops = GET_PFVF_OPS(accel_dev);
+	u32 pfvf_offset = pfvf_ops->get_pf2vf_offset(vf_nr);
+
+	return pfvf_ops->send_msg(accel_dev, msg, pfvf_offset,
+				  &accel_dev->pf.vf_info[vf_nr].pf2vf_lock);
 }
 
 /**
@@ -33,7 +37,10 @@ int adf_send_pf2vf_msg(struct adf_accel_dev *accel_dev, u8 vf_nr, u32 msg)
  */
 static u32 adf_recv_vf2pf_msg(struct adf_accel_dev *accel_dev, u8 vf_nr)
 {
-	return GET_PFVF_OPS(accel_dev)->recv_msg(accel_dev, vf_nr);
+	struct adf_pfvf_ops *pfvf_ops = GET_PFVF_OPS(accel_dev);
+	u32 pfvf_offset = pfvf_ops->get_vf2pf_offset(vf_nr);
+
+	return pfvf_ops->recv_msg(accel_dev, pfvf_offset);
 }
 
 static int adf_handle_vf2pf_msg(struct adf_accel_dev *accel_dev, u32 vf_nr,
diff --git a/drivers/crypto/qat/qat_common/adf_pfvf_vf_proto.c b/drivers/crypto/qat/qat_common/adf_pfvf_vf_proto.c
index f8d1c7d0ec4e..56e8185a9630 100644
--- a/drivers/crypto/qat/qat_common/adf_pfvf_vf_proto.c
+++ b/drivers/crypto/qat/qat_common/adf_pfvf_vf_proto.c
@@ -27,7 +27,11 @@
  */
 int adf_send_vf2pf_msg(struct adf_accel_dev *accel_dev, u32 msg)
 {
-	return GET_PFVF_OPS(accel_dev)->send_msg(accel_dev, msg, 0);
+	struct adf_pfvf_ops *pfvf_ops = GET_PFVF_OPS(accel_dev);
+	u32 pfvf_offset = pfvf_ops->get_vf2pf_offset(0);
+
+	return pfvf_ops->send_msg(accel_dev, msg, pfvf_offset,
+				  &accel_dev->vf.vf2pf_lock);
 }
 
 /**
@@ -40,7 +44,10 @@ int adf_send_vf2pf_msg(struct adf_accel_dev *accel_dev, u32 msg)
  */
 static u32 adf_recv_pf2vf_msg(struct adf_accel_dev *accel_dev)
 {
-	return GET_PFVF_OPS(accel_dev)->recv_msg(accel_dev, 0);
+	struct adf_pfvf_ops *pfvf_ops = GET_PFVF_OPS(accel_dev);
+	u32 pfvf_offset = pfvf_ops->get_pf2vf_offset(0);
+
+	return pfvf_ops->recv_msg(accel_dev, pfvf_offset);
 }
 
 /**
-- 
2.31.1

