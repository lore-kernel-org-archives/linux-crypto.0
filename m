Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFF3DC433FE
	for <linux-crypto@archiver.kernel.org>; Wed, 17 Nov 2021 14:31:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A6A8062F90
	for <linux-crypto@archiver.kernel.org>; Wed, 17 Nov 2021 14:31:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238594AbhKQOei (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 17 Nov 2021 09:34:38 -0500
Received: from mga01.intel.com ([192.55.52.88]:57939 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238589AbhKQOec (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 17 Nov 2021 09:34:32 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10170"; a="257722648"
X-IronPort-AV: E=Sophos;i="5.87,241,1631602800"; 
   d="scan'208";a="257722648"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2021 06:31:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,241,1631602800"; 
   d="scan'208";a="735829771"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.76])
  by fmsmga006.fm.intel.com with ESMTP; 17 Nov 2021 06:31:33 -0800
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        marco.chiappero@intel.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH v3 15/25] crypto: qat - differentiate between pf2vf and vf2pf offset
Date:   Wed, 17 Nov 2021 14:30:48 +0000
Message-Id: <20211117143058.211550-16-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211117143058.211550-1-giovanni.cabiddu@intel.com>
References: <20211117143058.211550-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Marco Chiappero <marco.chiappero@intel.com>

Add the function get_vf2pf_offset() to adf_pfvf_ops to differentiate the
CSRs used for pf2vf and vf2pf.

Offsets may or may not be direction specific depending on QAT
generation. Since in QAT GEN2 the CSR is not direction specific, i.e.
there is a single mailbox register shared for pf2vf and vf2pf, both
get_vf2pf_offset() and get_vf2pf_offset() will return the same offset.

This change is to make the direction explicit, so it is easier to
understand and debug and also in preparation for the introduction of
PFVF support in the qat_4xxx driver since QAT GEN4 devices have a
separate CSR for pf2vf and vf2pf communications.

Signed-off-by: Marco Chiappero <marco.chiappero@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/qat/qat_common/adf_accel_devices.h |  1 +
 drivers/crypto/qat/qat_common/adf_gen2_pfvf.c     | 10 ++++++----
 drivers/crypto/qat/qat_common/adf_pf2vf_msg.c     |  6 +++---
 3 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_accel_devices.h b/drivers/crypto/qat/qat_common/adf_accel_devices.h
index a1baa65bd034..d9b2cc935b61 100644
--- a/drivers/crypto/qat/qat_common/adf_accel_devices.h
+++ b/drivers/crypto/qat/qat_common/adf_accel_devices.h
@@ -150,6 +150,7 @@ struct adf_etr_ring_data;
 struct adf_pfvf_ops {
 	int (*enable_comms)(struct adf_accel_dev *accel_dev);
 	u32 (*get_pf2vf_offset)(u32 i);
+	u32 (*get_vf2pf_offset)(u32 i);
 	u32 (*get_vf2pf_sources)(void __iomem *pmisc_addr);
 	void (*enable_vf2pf_interrupts)(void __iomem *pmisc_addr, u32 vf_mask);
 	void (*disable_vf2pf_interrupts)(void __iomem *pmisc_addr, u32 vf_mask);
diff --git a/drivers/crypto/qat/qat_common/adf_gen2_pfvf.c b/drivers/crypto/qat/qat_common/adf_gen2_pfvf.c
index 36c8ff009661..2f27146bb7c6 100644
--- a/drivers/crypto/qat/qat_common/adf_gen2_pfvf.c
+++ b/drivers/crypto/qat/qat_common/adf_gen2_pfvf.c
@@ -12,12 +12,12 @@
 #define ADF_GEN2_PF_PF2VF_OFFSET(i)	(0x3A000 + 0x280 + ((i) * 0x04))
 #define ADF_GEN2_VF_PF2VF_OFFSET	0x200
 
-static u32 adf_gen2_pf_get_pf2vf_offset(u32 i)
+static u32 adf_gen2_pf_get_pfvf_offset(u32 i)
 {
 	return ADF_GEN2_PF_PF2VF_OFFSET(i);
 }
 
-static u32 adf_gen2_vf_get_pf2vf_offset(u32 i)
+static u32 adf_gen2_vf_get_pfvf_offset(u32 i)
 {
 	return ADF_GEN2_VF_PF2VF_OFFSET;
 }
@@ -64,7 +64,8 @@ static void adf_gen2_disable_vf2pf_interrupts(void __iomem *pmisc_addr,
 void adf_gen2_init_pf_pfvf_ops(struct adf_pfvf_ops *pfvf_ops)
 {
 	pfvf_ops->enable_comms = adf_enable_pf2vf_comms;
-	pfvf_ops->get_pf2vf_offset = adf_gen2_pf_get_pf2vf_offset;
+	pfvf_ops->get_pf2vf_offset = adf_gen2_pf_get_pfvf_offset;
+	pfvf_ops->get_vf2pf_offset = adf_gen2_pf_get_pfvf_offset;
 	pfvf_ops->get_vf2pf_sources = adf_gen2_get_vf2pf_sources;
 	pfvf_ops->enable_vf2pf_interrupts = adf_gen2_enable_vf2pf_interrupts;
 	pfvf_ops->disable_vf2pf_interrupts = adf_gen2_disable_vf2pf_interrupts;
@@ -74,6 +75,7 @@ EXPORT_SYMBOL_GPL(adf_gen2_init_pf_pfvf_ops);
 void adf_gen2_init_vf_pfvf_ops(struct adf_pfvf_ops *pfvf_ops)
 {
 	pfvf_ops->enable_comms = adf_enable_vf2pf_comms;
-	pfvf_ops->get_pf2vf_offset = adf_gen2_vf_get_pf2vf_offset;
+	pfvf_ops->get_pf2vf_offset = adf_gen2_vf_get_pfvf_offset;
+	pfvf_ops->get_vf2pf_offset = adf_gen2_vf_get_pfvf_offset;
 }
 EXPORT_SYMBOL_GPL(adf_gen2_init_vf_pfvf_ops);
diff --git a/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c b/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
index 78dc8aea4866..c420ec03081b 100644
--- a/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
+++ b/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
@@ -29,7 +29,7 @@ static int adf_iov_putmsg(struct adf_accel_dev *accel_dev, u32 msg, u8 vf_nr)
 	int ret;
 
 	if (accel_dev->is_vf) {
-		pf2vf_offset = hw_data->pfvf_ops.get_pf2vf_offset(0);
+		pf2vf_offset = hw_data->pfvf_ops.get_vf2pf_offset(0);
 		lock = &accel_dev->vf.vf2pf_lock;
 		local_in_use_mask = ADF_VF2PF_IN_USE_BY_VF_MASK;
 		local_in_use_pattern = ADF_VF2PF_IN_USE_BY_VF;
@@ -258,7 +258,7 @@ bool adf_recv_and_handle_vf2pf_msg(struct adf_accel_dev *accel_dev, u32 vf_nr)
 	u32 msg, resp = 0;
 
 	/* Read message from the VF */
-	msg = ADF_CSR_RD(pmisc_addr, hw_data->pfvf_ops.get_pf2vf_offset(vf_nr));
+	msg = ADF_CSR_RD(pmisc_addr, hw_data->pfvf_ops.get_vf2pf_offset(vf_nr));
 	if (!(msg & ADF_VF2PF_INT)) {
 		dev_info(&GET_DEV(accel_dev),
 			 "Spurious VF2PF interrupt, msg %X. Ignored\n", msg);
@@ -275,7 +275,7 @@ bool adf_recv_and_handle_vf2pf_msg(struct adf_accel_dev *accel_dev, u32 vf_nr)
 
 	/* To ACK, clear the VF2PFINT bit */
 	msg &= ~ADF_VF2PF_INT;
-	ADF_CSR_WR(pmisc_addr, hw_data->pfvf_ops.get_pf2vf_offset(vf_nr), msg);
+	ADF_CSR_WR(pmisc_addr, hw_data->pfvf_ops.get_vf2pf_offset(vf_nr), msg);
 
 	if (adf_handle_vf2pf_msg(accel_dev, vf_nr, msg, &resp))
 		return false;
-- 
2.33.1

