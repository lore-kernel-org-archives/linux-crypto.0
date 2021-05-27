Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05500C4707F
	for <linux-crypto@archiver.kernel.org>; Thu, 27 May 2021 19:13:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E38D86135F
	for <linux-crypto@archiver.kernel.org>; Thu, 27 May 2021 19:13:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234775AbhE0TPM (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 May 2021 15:15:12 -0400
Received: from mga06.intel.com ([134.134.136.31]:7489 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234786AbhE0TPJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 May 2021 15:15:09 -0400
IronPort-SDR: 3IwHbtp1SeJDFuvx3VNkyW7y6Wp1TkV4ajOXfHpGNMqvk4ze+IN5sedLugrClyn3NIaG35Q1uT
 vE3wuEOkrDJw==
X-IronPort-AV: E=McAfee;i="6200,9189,9997"; a="264012469"
X-IronPort-AV: E=Sophos;i="5.83,228,1616482800"; 
   d="scan'208";a="264012469"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2021 12:13:35 -0700
IronPort-SDR: dl5NkTJ8qvzf4sfV7Npl3HEHLQ2P7Jam53CCTZhr3uqgpw3jekQQus0zX6/6ABrXQ50RhjYVAj
 nGrVe+BICMww==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,228,1616482800"; 
   d="scan'208";a="480717805"
Received: from silpixa00393544.ir.intel.com ([10.237.213.118])
  by fmsmga002.fm.intel.com with ESMTP; 27 May 2021 12:13:33 -0700
From:   Marco Chiappero <marco.chiappero@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Svyatoslav Pankratov <svyatoslav.pankratov@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Marco Chiappero <marco.chiappero@intel.com>
Subject: [PATCH 09/10] crypto: qat - remove intermediate tasklet for vf2pf
Date:   Thu, 27 May 2021 20:12:50 +0100
Message-Id: <20210527191251.6317-10-marco.chiappero@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210527191251.6317-1-marco.chiappero@intel.com>
References: <20210527191251.6317-1-marco.chiappero@intel.com>
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
index 0150fce09600..62f25a307000 100644
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
index 403d2fc00a7d..fdd65771248b 100644
--- a/drivers/crypto/qat/qat_common/adf_isr.c
+++ b/drivers/crypto/qat/qat_common/adf_isr.c
@@ -108,9 +108,8 @@ static irqreturn_t adf_msix_isr_ae(int irq, void *dev_ptr)
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
@@ -122,8 +121,7 @@ static irqreturn_t adf_msix_isr_ae(int irq, void *dev_ptr)
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
2.26.2

