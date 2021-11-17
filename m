Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1780C43217
	for <linux-crypto@archiver.kernel.org>; Wed, 17 Nov 2021 14:31:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 908F061B54
	for <linux-crypto@archiver.kernel.org>; Wed, 17 Nov 2021 14:31:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235127AbhKQOeU (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 17 Nov 2021 09:34:20 -0500
Received: from mga01.intel.com ([192.55.52.88]:57918 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235076AbhKQOeS (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 17 Nov 2021 09:34:18 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10170"; a="257722603"
X-IronPort-AV: E=Sophos;i="5.87,241,1631602800"; 
   d="scan'208";a="257722603"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2021 06:31:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,241,1631602800"; 
   d="scan'208";a="735829675"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.76])
  by fmsmga006.fm.intel.com with ESMTP; 17 Nov 2021 06:31:18 -0800
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        marco.chiappero@intel.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH v3 06/25] crypto: qat - move interrupt code out of the PFVF handler
Date:   Wed, 17 Nov 2021 14:30:39 +0000
Message-Id: <20211117143058.211550-7-giovanni.cabiddu@intel.com>
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

Move the interrupt handling call from the PF specific protocol file,
adf_pf2vf_msg.c, to adf_sriov.c to maintain the PFVF files focused on
the protocol handling.

The function adf_vf2pf_req_hndl() has been renamed as
adf_recv_and_handle_vf2pf_msg() to reflect its actual purpose and
maintain consistency with the VF side. This function now returns a
boolean indicating to the caller if interrupts need to be re-enabled or
not.

Signed-off-by: Marco Chiappero <marco.chiappero@intel.com>
Co-developed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/qat/qat_common/adf_common_drv.h |  2 +-
 drivers/crypto/qat/qat_common/adf_pf2vf_msg.c  | 15 ++++++---------
 drivers/crypto/qat/qat_common/adf_sriov.c      | 10 +++++++++-
 3 files changed, 16 insertions(+), 11 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_common_drv.h b/drivers/crypto/qat/qat_common/adf_common_drv.h
index 050db8967983..120b2e26b20f 100644
--- a/drivers/crypto/qat/qat_common/adf_common_drv.h
+++ b/drivers/crypto/qat/qat_common/adf_common_drv.h
@@ -64,7 +64,6 @@ void adf_dev_shutdown(struct adf_accel_dev *accel_dev);
 
 void adf_pf2vf_notify_restarting(struct adf_accel_dev *accel_dev);
 int adf_enable_vf2pf_comms(struct adf_accel_dev *accel_dev);
-void adf_vf2pf_req_hndl(struct adf_accel_vf_info *vf_info);
 void adf_devmgr_update_class_index(struct adf_hw_device_data *hw_data);
 void adf_clean_vf_map(bool);
 
@@ -195,6 +194,7 @@ void adf_disable_vf2pf_interrupts(struct adf_accel_dev *accel_dev,
 void adf_enable_vf2pf_interrupts(struct adf_accel_dev *accel_dev,
 				 u32 vf_mask);
 bool adf_recv_and_handle_pf2vf_msg(struct adf_accel_dev *accel_dev);
+bool adf_recv_and_handle_vf2pf_msg(struct adf_accel_dev *accel_dev, u32 vf_nr);
 int adf_pf2vf_handle_pf_restarting(struct adf_accel_dev *accel_dev);
 int adf_enable_pf2vf_comms(struct adf_accel_dev *accel_dev);
 void adf_enable_pf2vf_interrupts(struct adf_accel_dev *accel_dev);
diff --git a/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c b/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
index d0492530c84a..796301e9fe5b 100644
--- a/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
+++ b/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
@@ -178,21 +178,21 @@ static int adf_send_vf2pf_req(struct adf_accel_dev *accel_dev, u32 msg)
 	return 0;
 }
 
-void adf_vf2pf_req_hndl(struct adf_accel_vf_info *vf_info)
+bool adf_recv_and_handle_vf2pf_msg(struct adf_accel_dev *accel_dev, u32 vf_nr)
 {
-	struct adf_accel_dev *accel_dev = vf_info->accel_dev;
+	struct adf_accel_vf_info *vf_info = &accel_dev->pf.vf_info[vf_nr];
 	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
 	int bar_id = hw_data->get_misc_bar_id(hw_data);
 	struct adf_bar *pmisc = &GET_BARS(accel_dev)[bar_id];
 	void __iomem *pmisc_addr = pmisc->virt_addr;
-	u32 msg, resp = 0, vf_nr = vf_info->vf_nr;
+	u32 msg, resp = 0;
 
 	/* Read message from the VF */
 	msg = ADF_CSR_RD(pmisc_addr, hw_data->get_pf2vf_offset(vf_nr));
 	if (!(msg & ADF_VF2PF_INT)) {
 		dev_info(&GET_DEV(accel_dev),
 			 "Spurious VF2PF interrupt, msg %X. Ignored\n", msg);
-		goto out;
+		return true;
 	}
 
 	/* To ACK, clear the VF2PFINT bit */
@@ -277,14 +277,11 @@ void adf_vf2pf_req_hndl(struct adf_accel_vf_info *vf_info)
 	if (resp && adf_send_pf2vf_msg(accel_dev, vf_nr, resp))
 		dev_err(&GET_DEV(accel_dev), "Failed to send response to VF\n");
 
-out:
-	/* re-enable interrupt on PF from this VF */
-	adf_enable_vf2pf_interrupts(accel_dev, (1 << vf_nr));
-
-	return;
+	return true;
 err:
 	dev_dbg(&GET_DEV(accel_dev), "Unknown message from VF%d (0x%x);\n",
 		vf_nr + 1, msg);
+	return false;
 }
 
 void adf_pf2vf_notify_restarting(struct adf_accel_dev *accel_dev)
diff --git a/drivers/crypto/qat/qat_common/adf_sriov.c b/drivers/crypto/qat/qat_common/adf_sriov.c
index 90ec057f9183..b1a814ac1d67 100644
--- a/drivers/crypto/qat/qat_common/adf_sriov.c
+++ b/drivers/crypto/qat/qat_common/adf_sriov.c
@@ -19,8 +19,16 @@ static void adf_iov_send_resp(struct work_struct *work)
 {
 	struct adf_pf2vf_resp *pf2vf_resp =
 		container_of(work, struct adf_pf2vf_resp, pf2vf_resp_work);
+	struct adf_accel_vf_info *vf_info = pf2vf_resp->vf_info;
+	struct adf_accel_dev *accel_dev = vf_info->accel_dev;
+	u32 vf_nr = vf_info->vf_nr;
+	bool ret;
+
+	ret = adf_recv_and_handle_vf2pf_msg(accel_dev, vf_nr);
+	if (ret)
+		/* re-enable interrupt on PF from this VF */
+		adf_enable_vf2pf_interrupts(accel_dev, 1 << vf_nr);
 
-	adf_vf2pf_req_hndl(pf2vf_resp->vf_info);
 	kfree(pf2vf_resp);
 }
 
-- 
2.33.1

