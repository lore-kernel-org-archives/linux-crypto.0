Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59F3BC433EF
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Dec 2021 09:11:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232925AbhLPJLd (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 16 Dec 2021 04:11:33 -0500
Received: from mga12.intel.com ([192.55.52.136]:9675 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232968AbhLPJL2 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Dec 2021 04:11:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639645888; x=1671181888;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2mODlHRUUN/vxzeQir3uK/B7c1CqVcpSkAw5y7Os4kE=;
  b=YEgWFHlIgFeL77KurbOIDsBg+c7/9gZi5qLk/52z7XDRrbKQGxNVEM1j
   0WHE3xNR7Sec74EZVVnYA4JxAHf7hRwtpG00hyi/9ah0xsbSVG8mguUln
   cWOSwvrt+IG/KK/rFsBvqpgmgHMiKPuE1f0lMouk8ouvSL/ve9ZaDny2L
   bZSIRbql7mzHE1SByJRYzJK3yUy+Mmp1eqzsJFiHvBMqTdkoCWswO46pD
   9GaaskScC1/8V5lfDZAdWMgpH7yrM+7ZO3NIREWAlP4pcOXrS97LybinT
   kNUnt4+mw6oFWP2J6aQZmVOt2xZJ/G7ri/4JwBGgS0F6kZlECuzWSMoJt
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10199"; a="219458402"
X-IronPort-AV: E=Sophos;i="5.88,211,1635231600"; 
   d="scan'208";a="219458402"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2021 01:11:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,211,1635231600"; 
   d="scan'208";a="465968469"
Received: from silpixa00393544.ir.intel.com ([10.237.213.118])
  by orsmga006.jf.intel.com with ESMTP; 16 Dec 2021 01:11:26 -0800
From:   Marco Chiappero <marco.chiappero@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        giovanni.cabiddu@intel.com, marco.chiappero@intel.com,
        Fiona Trahe <fiona.trahe@intel.com>
Subject: [PATCH 09/24] crypto: qat - set PFVF_MSGORIGIN just before sending
Date:   Thu, 16 Dec 2021 09:13:19 +0000
Message-Id: <20211216091334.402420-10-marco.chiappero@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211216091334.402420-1-marco.chiappero@intel.com>
References: <20211216091334.402420-1-marco.chiappero@intel.com>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

In this implementation of the PFVF protocol every egressing message must
include the ADF_PFVF_MSGORIGIN_SYSTEM flag. However, this flag can be set
on all the outbound messages just before sending them rather than at
message build time, as currently done.

Remove the unnecessary code duplication by setting the
ADF_PFVF_MSGORIGIN_SYSTEM flag only once at send time in
adf_gen2_pfvf_send().

Signed-off-by: Marco Chiappero <marco.chiappero@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Fiona Trahe <fiona.trahe@intel.com>
---
 drivers/crypto/qat/qat_common/adf_gen2_pfvf.c     |  1 +
 drivers/crypto/qat/qat_common/adf_pfvf_pf_msg.c   |  3 +--
 drivers/crypto/qat/qat_common/adf_pfvf_pf_proto.c |  2 --
 drivers/crypto/qat/qat_common/adf_pfvf_vf_msg.c   | 12 +++++-------
 4 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_gen2_pfvf.c b/drivers/crypto/qat/qat_common/adf_gen2_pfvf.c
index 1e45f3230c19..97bef41ddc47 100644
--- a/drivers/crypto/qat/qat_common/adf_gen2_pfvf.c
+++ b/drivers/crypto/qat/qat_common/adf_gen2_pfvf.c
@@ -149,6 +149,7 @@ static int adf_gen2_pfvf_send(struct adf_accel_dev *accel_dev, u32 msg,
 	/* Pre-calculate message, shifting it in place and setting
 	 * the in use pattern
 	 */
+	msg |= ADF_PFVF_MSGORIGIN_SYSTEM;
 	msg = gen2_csr_msg_to_position(msg, local_offset);
 	gen2_csr_set_in_use(&msg, remote_offset);
 
diff --git a/drivers/crypto/qat/qat_common/adf_pfvf_pf_msg.c b/drivers/crypto/qat/qat_common/adf_pfvf_pf_msg.c
index 4057d7d74d62..f6d05cd29a82 100644
--- a/drivers/crypto/qat/qat_common/adf_pfvf_pf_msg.c
+++ b/drivers/crypto/qat/qat_common/adf_pfvf_pf_msg.c
@@ -9,8 +9,7 @@
 void adf_pf2vf_notify_restarting(struct adf_accel_dev *accel_dev)
 {
 	struct adf_accel_vf_info *vf;
-	u32 msg = (ADF_PFVF_MSGORIGIN_SYSTEM |
-		(ADF_PF2VF_MSGTYPE_RESTARTING << ADF_PFVF_MSGTYPE_SHIFT));
+	u32 msg = ADF_PF2VF_MSGTYPE_RESTARTING << ADF_PFVF_MSGTYPE_SHIFT;
 	int i, num_vfs = pci_num_vf(accel_to_pci_dev(accel_dev));
 
 	for (i = 0, vf = accel_dev->pf.vf_info; i < num_vfs; i++, vf++) {
diff --git a/drivers/crypto/qat/qat_common/adf_pfvf_pf_proto.c b/drivers/crypto/qat/qat_common/adf_pfvf_pf_proto.c
index 4e4daec2ae34..9f4baa9b14fc 100644
--- a/drivers/crypto/qat/qat_common/adf_pfvf_pf_proto.c
+++ b/drivers/crypto/qat/qat_common/adf_pfvf_pf_proto.c
@@ -64,7 +64,6 @@ static int adf_handle_vf2pf_msg(struct adf_accel_dev *accel_dev, u32 vf_nr,
 		else
 			compat = ADF_PF2VF_VF_COMPAT_UNKNOWN;
 
-		resp =  ADF_PFVF_MSGORIGIN_SYSTEM;
 		resp |= ADF_PF2VF_MSGTYPE_VERSION_RESP <<
 			ADF_PFVF_MSGTYPE_SHIFT;
 		resp |= ADF_PFVF_COMPAT_THIS_VERSION <<
@@ -83,7 +82,6 @@ static int adf_handle_vf2pf_msg(struct adf_accel_dev *accel_dev, u32 vf_nr,
 		/* PF always newer than legacy VF */
 		compat = ADF_PF2VF_VF_COMPATIBLE;
 
-		resp = ADF_PFVF_MSGORIGIN_SYSTEM;
 		resp |= ADF_PF2VF_MSGTYPE_VERSION_RESP <<
 			ADF_PFVF_MSGTYPE_SHIFT;
 		/* Set legacy major and minor version num */
diff --git a/drivers/crypto/qat/qat_common/adf_pfvf_vf_msg.c b/drivers/crypto/qat/qat_common/adf_pfvf_vf_msg.c
index c9e929651a7d..0463743a8d43 100644
--- a/drivers/crypto/qat/qat_common/adf_pfvf_vf_msg.c
+++ b/drivers/crypto/qat/qat_common/adf_pfvf_vf_msg.c
@@ -16,8 +16,7 @@
  */
 int adf_vf2pf_notify_init(struct adf_accel_dev *accel_dev)
 {
-	u32 msg = (ADF_PFVF_MSGORIGIN_SYSTEM |
-		(ADF_VF2PF_MSGTYPE_INIT << ADF_PFVF_MSGTYPE_SHIFT));
+	u32 msg = ADF_VF2PF_MSGTYPE_INIT << ADF_PFVF_MSGTYPE_SHIFT;
 
 	if (adf_send_vf2pf_msg(accel_dev, msg)) {
 		dev_err(&GET_DEV(accel_dev),
@@ -39,8 +38,7 @@ EXPORT_SYMBOL_GPL(adf_vf2pf_notify_init);
  */
 void adf_vf2pf_notify_shutdown(struct adf_accel_dev *accel_dev)
 {
-	u32 msg = (ADF_PFVF_MSGORIGIN_SYSTEM |
-	    (ADF_VF2PF_MSGTYPE_SHUTDOWN << ADF_PFVF_MSGTYPE_SHIFT));
+	u32 msg = ADF_VF2PF_MSGTYPE_SHUTDOWN << ADF_PFVF_MSGTYPE_SHIFT;
 
 	if (test_bit(ADF_STATUS_PF_RUNNING, &accel_dev->status))
 		if (adf_send_vf2pf_msg(accel_dev, msg))
@@ -57,9 +55,9 @@ int adf_vf2pf_request_version(struct adf_accel_dev *accel_dev)
 	u32 resp;
 	int ret;
 
-	msg = ADF_PFVF_MSGORIGIN_SYSTEM;
-	msg |= ADF_VF2PF_MSGTYPE_COMPAT_VER_REQ << ADF_PFVF_MSGTYPE_SHIFT;
-	msg |= ADF_PFVF_COMPAT_THIS_VERSION << ADF_VF2PF_COMPAT_VER_REQ_SHIFT;
+	msg = ADF_VF2PF_MSGTYPE_COMPAT_VER_REQ << ADF_PFVF_MSGTYPE_SHIFT |
+	      ADF_PFVF_COMPAT_THIS_VERSION << ADF_VF2PF_COMPAT_VER_REQ_SHIFT;
+
 	BUILD_BUG_ON(ADF_PFVF_COMPAT_THIS_VERSION > 255);
 
 	ret = adf_send_vf2pf_req(accel_dev, msg, &resp);
-- 
2.31.1

