Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91657C04FE3
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Aug 2021 20:22:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6DE206103E
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Aug 2021 20:22:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236922AbhHLUW0 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 12 Aug 2021 16:22:26 -0400
Received: from mga03.intel.com ([134.134.136.65]:4154 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237118AbhHLUWY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Aug 2021 16:22:24 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10074"; a="215474034"
X-IronPort-AV: E=Sophos;i="5.84,316,1620716400"; 
   d="scan'208";a="215474034"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2021 13:21:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,316,1620716400"; 
   d="scan'208";a="517608621"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.51])
  by FMSMGA003.fm.intel.com with ESMTP; 12 Aug 2021 13:21:53 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Svyatoslav Pankratov <svyatoslav.pankratov@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Marco Chiappero <marco.chiappero@intel.com>,
        Fiona Trahe <fiona.trahe@intel.com>
Subject: [PATCH 09/20] crypto: qat - remove intermediate tasklet for vf2pf
Date:   Thu, 12 Aug 2021 21:21:18 +0100
Message-Id: <20210812202129.18831-10-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210812202129.18831-1-giovanni.cabiddu@intel.com>
References: <20210812202129.18831-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Svyatoslav Pankratov <svyatoslav.pankratov@intel.com>

The PF driver uses the tasklet vf2pf_bh_tasklet to schedule a workqueue
to handle the vf2vf protocol (pf2vf_resp_wq).
Since the tasklet is only used to schedule the workqueue, this patch
removes it and schedules the pf2vf_resp_wq workqueue directly for the
top half.

Signed-off-by: Svyatoslav Pankratov <svyatoslav.pankratov@intel.com>
Co-developed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Marco Chiappero <marco.chiappero@intel.com>
Reviewed-by: Fiona Trahe <fiona.trahe@intel.com>
---
 drivers/crypto/qat/qat_common/adf_accel_devices.h | 1 -
 drivers/crypto/qat/qat_common/adf_common_drv.h    | 1 +
 drivers/crypto/qat/qat_common/adf_isr.c           | 8 +++-----
 drivers/crypto/qat/qat_common/adf_sriov.c         | 8 +-------
 4 files changed, 5 insertions(+), 13 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_accel_devices.h b/drivers/crypto/qat/qat_common/adf_accel_devices.h
index 2ee11b4763cd..180c7dba3ff2 100644
--- a/drivers/crypto/qat/qat_common/adf_accel_devices.h
+++ b/drivers/crypto/qat/qat_common/adf_accel_devices.h
@@ -225,7 +225,6 @@ struct adf_fw_loader_data {
 
 struct adf_accel_vf_info {
 	struct adf_accel_dev *accel_dev;
-	struct tasklet_struct vf2pf_bh_tasklet;
 	struct mutex pf2vf_lock; /* protect CSR access for PF2VF messages */
 	struct ratelimit_state vf2pf_ratelimit;
 	u32 vf_nr;
diff --git a/drivers/crypto/qat/qat_common/adf_common_drv.h b/drivers/crypto/qat/qat_common/adf_common_drv.h
index c7deca7f0607..bd76b8a86b86 100644
--- a/drivers/crypto/qat/qat_common/adf_common_drv.h
+++ b/drivers/crypto/qat/qat_common/adf_common_drv.h
@@ -197,6 +197,7 @@ void adf_enable_vf2pf_interrupts(struct adf_accel_dev *accel_dev,
 				 u32 vf_mask);
 void adf_enable_pf2vf_interrupts(struct adf_accel_dev *accel_dev);
 void adf_disable_pf2vf_interrupts(struct adf_accel_dev *accel_dev);
+void adf_schedule_vf2pf_handler(struct adf_accel_vf_info *vf_info);
 
 int adf_vf2pf_init(struct adf_accel_dev *accel_dev);
 void adf_vf2pf_shutdown(struct adf_accel_dev *accel_dev);
diff --git a/drivers/crypto/qat/qat_common/adf_isr.c b/drivers/crypto/qat/qat_common/adf_isr.c
index a25b7845c9d3..2302e43dfaf4 100644
--- a/drivers/crypto/qat/qat_common/adf_isr.c
+++ b/drivers/crypto/qat/qat_common/adf_isr.c
@@ -106,9 +106,8 @@ static irqreturn_t adf_msix_isr_ae(int irq, void *dev_ptr)
 			adf_disable_vf2pf_interrupts(accel_dev, vf_mask);
 
 			/*
-			 * Schedule tasklets to handle VF2PF interrupt BHs
-			 * unless the VF is malicious and is attempting to
-			 * flood the host OS with VF2PF interrupts.
+			 * Handle VF2PF interrupt unless the VF is malicious and
+			 * is attempting to flood the host OS with VF2PF interrupts.
 			 */
 			for_each_set_bit(i, &vf_mask, ADF_MAX_NUM_VFS) {
 				vf_info = accel_dev->pf.vf_info + i;
@@ -120,8 +119,7 @@ static irqreturn_t adf_msix_isr_ae(int irq, void *dev_ptr)
 					continue;
 				}
 
-				/* Tasklet will re-enable ints from this VF */
-				tasklet_hi_schedule(&vf_info->vf2pf_bh_tasklet);
+				adf_schedule_vf2pf_handler(vf_info);
 				irq_handled = true;
 			}
 
diff --git a/drivers/crypto/qat/qat_common/adf_sriov.c b/drivers/crypto/qat/qat_common/adf_sriov.c
index 8c822c2861c2..90ec057f9183 100644
--- a/drivers/crypto/qat/qat_common/adf_sriov.c
+++ b/drivers/crypto/qat/qat_common/adf_sriov.c
@@ -24,9 +24,8 @@ static void adf_iov_send_resp(struct work_struct *work)
 	kfree(pf2vf_resp);
 }
 
-static void adf_vf2pf_bh_handler(void *data)
+void adf_schedule_vf2pf_handler(struct adf_accel_vf_info *vf_info)
 {
-	struct adf_accel_vf_info *vf_info = (struct adf_accel_vf_info *)data;
 	struct adf_pf2vf_resp *pf2vf_resp;
 
 	pf2vf_resp = kzalloc(sizeof(*pf2vf_resp), GFP_ATOMIC);
@@ -52,9 +51,6 @@ static int adf_enable_sriov(struct adf_accel_dev *accel_dev)
 		vf_info->accel_dev = accel_dev;
 		vf_info->vf_nr = i;
 
-		tasklet_init(&vf_info->vf2pf_bh_tasklet,
-			     (void *)adf_vf2pf_bh_handler,
-			     (unsigned long)vf_info);
 		mutex_init(&vf_info->pf2vf_lock);
 		ratelimit_state_init(&vf_info->vf2pf_ratelimit,
 				     DEFAULT_RATELIMIT_INTERVAL,
@@ -110,8 +106,6 @@ void adf_disable_sriov(struct adf_accel_dev *accel_dev)
 		hw_data->configure_iov_threads(accel_dev, false);
 
 	for (i = 0, vf = accel_dev->pf.vf_info; i < totalvfs; i++, vf++) {
-		tasklet_disable(&vf->vf2pf_bh_tasklet);
-		tasklet_kill(&vf->vf2pf_bh_tasklet);
 		mutex_destroy(&vf->pf2vf_lock);
 	}
 
-- 
2.31.1

