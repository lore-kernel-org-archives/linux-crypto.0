Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1FEFC4338F
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Aug 2021 20:22:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B79EA6101E
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Aug 2021 20:22:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237087AbhHLUWd (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 12 Aug 2021 16:22:33 -0400
Received: from mga03.intel.com ([134.134.136.65]:4154 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237075AbhHLUW2 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Aug 2021 16:22:28 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10074"; a="215474050"
X-IronPort-AV: E=Sophos;i="5.84,316,1620716400"; 
   d="scan'208";a="215474050"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2021 13:22:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,316,1620716400"; 
   d="scan'208";a="517608679"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.51])
  by FMSMGA003.fm.intel.com with ESMTP; 12 Aug 2021 13:22:01 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Marco Chiappero <marco.chiappero@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Fiona Trahe <fiona.trahe@intel.com>
Subject: [PATCH 13/20] crypto: qat - fix naming for init/shutdown VF to PF notifications
Date:   Thu, 12 Aug 2021 21:21:22 +0100
Message-Id: <20210812202129.18831-14-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210812202129.18831-1-giovanni.cabiddu@intel.com>
References: <20210812202129.18831-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Marco Chiappero <marco.chiappero@intel.com>

At start and shutdown, VFs notify the PF about their state. These
notifications are carried out through a message exchange using the PFVF
protocol.

Function names lead to believe they do perform init or shutdown logic.
This is to fix the naming to better reflect their purpose.

Signed-off-by: Marco Chiappero <marco.chiappero@intel.com>
Co-developed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Fiona Trahe <fiona.trahe@intel.com>
---
 drivers/crypto/qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.c |  4 ++--
 drivers/crypto/qat/qat_c62xvf/adf_c62xvf_hw_data.c   |  4 ++--
 drivers/crypto/qat/qat_common/adf_common_drv.h       |  8 ++++----
 drivers/crypto/qat/qat_common/adf_vf2pf_msg.c        | 12 ++++++------
 .../qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.c      |  4 ++--
 5 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/crypto/qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.c b/drivers/crypto/qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.c
index 476a4bf3de56..da0790f26574 100644
--- a/drivers/crypto/qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.c
+++ b/drivers/crypto/qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.c
@@ -81,10 +81,10 @@ void adf_init_hw_data_c3xxxiov(struct adf_hw_device_data *hw_data)
 	hw_data->enable_error_correction = adf_vf_void_noop;
 	hw_data->init_admin_comms = adf_vf_int_noop;
 	hw_data->exit_admin_comms = adf_vf_void_noop;
-	hw_data->send_admin_init = adf_vf2pf_init;
+	hw_data->send_admin_init = adf_vf2pf_notify_init;
 	hw_data->init_arb = adf_vf_int_noop;
 	hw_data->exit_arb = adf_vf_void_noop;
-	hw_data->disable_iov = adf_vf2pf_shutdown;
+	hw_data->disable_iov = adf_vf2pf_notify_shutdown;
 	hw_data->get_accel_mask = get_accel_mask;
 	hw_data->get_ae_mask = get_ae_mask;
 	hw_data->get_num_accels = get_num_accels;
diff --git a/drivers/crypto/qat/qat_c62xvf/adf_c62xvf_hw_data.c b/drivers/crypto/qat/qat_c62xvf/adf_c62xvf_hw_data.c
index 0c867208eb90..e8ed5970b2f2 100644
--- a/drivers/crypto/qat/qat_c62xvf/adf_c62xvf_hw_data.c
+++ b/drivers/crypto/qat/qat_c62xvf/adf_c62xvf_hw_data.c
@@ -81,10 +81,10 @@ void adf_init_hw_data_c62xiov(struct adf_hw_device_data *hw_data)
 	hw_data->enable_error_correction = adf_vf_void_noop;
 	hw_data->init_admin_comms = adf_vf_int_noop;
 	hw_data->exit_admin_comms = adf_vf_void_noop;
-	hw_data->send_admin_init = adf_vf2pf_init;
+	hw_data->send_admin_init = adf_vf2pf_notify_init;
 	hw_data->init_arb = adf_vf_int_noop;
 	hw_data->exit_arb = adf_vf_void_noop;
-	hw_data->disable_iov = adf_vf2pf_shutdown;
+	hw_data->disable_iov = adf_vf2pf_notify_shutdown;
 	hw_data->get_accel_mask = get_accel_mask;
 	hw_data->get_ae_mask = get_ae_mask;
 	hw_data->get_num_accels = get_num_accels;
diff --git a/drivers/crypto/qat/qat_common/adf_common_drv.h b/drivers/crypto/qat/qat_common/adf_common_drv.h
index 3f6277347278..4b18843f9845 100644
--- a/drivers/crypto/qat/qat_common/adf_common_drv.h
+++ b/drivers/crypto/qat/qat_common/adf_common_drv.h
@@ -201,8 +201,8 @@ void adf_enable_pf2vf_interrupts(struct adf_accel_dev *accel_dev);
 void adf_disable_pf2vf_interrupts(struct adf_accel_dev *accel_dev);
 void adf_schedule_vf2pf_handler(struct adf_accel_vf_info *vf_info);
 
-int adf_vf2pf_init(struct adf_accel_dev *accel_dev);
-void adf_vf2pf_shutdown(struct adf_accel_dev *accel_dev);
+int adf_vf2pf_notify_init(struct adf_accel_dev *accel_dev);
+void adf_vf2pf_notify_shutdown(struct adf_accel_dev *accel_dev);
 int adf_init_pf_wq(void);
 void adf_exit_pf_wq(void);
 int adf_init_vf_wq(void);
@@ -222,12 +222,12 @@ static inline void adf_disable_pf2vf_interrupts(struct adf_accel_dev *accel_dev)
 {
 }
 
-static inline int adf_vf2pf_init(struct adf_accel_dev *accel_dev)
+static inline int adf_vf2pf_notify_init(struct adf_accel_dev *accel_dev)
 {
 	return 0;
 }
 
-static inline void adf_vf2pf_shutdown(struct adf_accel_dev *accel_dev)
+static inline void adf_vf2pf_notify_shutdown(struct adf_accel_dev *accel_dev)
 {
 }
 
diff --git a/drivers/crypto/qat/qat_common/adf_vf2pf_msg.c b/drivers/crypto/qat/qat_common/adf_vf2pf_msg.c
index e85bd62d134a..3e25fac051b2 100644
--- a/drivers/crypto/qat/qat_common/adf_vf2pf_msg.c
+++ b/drivers/crypto/qat/qat_common/adf_vf2pf_msg.c
@@ -5,14 +5,14 @@
 #include "adf_pf2vf_msg.h"
 
 /**
- * adf_vf2pf_init() - send init msg to PF
+ * adf_vf2pf_notify_init() - send init msg to PF
  * @accel_dev:  Pointer to acceleration VF device.
  *
  * Function sends an init message from the VF to a PF
  *
  * Return: 0 on success, error code otherwise.
  */
-int adf_vf2pf_init(struct adf_accel_dev *accel_dev)
+int adf_vf2pf_notify_init(struct adf_accel_dev *accel_dev)
 {
 	u32 msg = (ADF_VF2PF_MSGORIGIN_SYSTEM |
 		(ADF_VF2PF_MSGTYPE_INIT << ADF_VF2PF_MSGTYPE_SHIFT));
@@ -25,17 +25,17 @@ int adf_vf2pf_init(struct adf_accel_dev *accel_dev)
 	set_bit(ADF_STATUS_PF_RUNNING, &accel_dev->status);
 	return 0;
 }
-EXPORT_SYMBOL_GPL(adf_vf2pf_init);
+EXPORT_SYMBOL_GPL(adf_vf2pf_notify_init);
 
 /**
- * adf_vf2pf_shutdown() - send shutdown msg to PF
+ * adf_vf2pf_notify_shutdown() - send shutdown msg to PF
  * @accel_dev:  Pointer to acceleration VF device.
  *
  * Function sends a shutdown message from the VF to a PF
  *
  * Return: void
  */
-void adf_vf2pf_shutdown(struct adf_accel_dev *accel_dev)
+void adf_vf2pf_notify_shutdown(struct adf_accel_dev *accel_dev)
 {
 	u32 msg = (ADF_VF2PF_MSGORIGIN_SYSTEM |
 	    (ADF_VF2PF_MSGTYPE_SHUTDOWN << ADF_VF2PF_MSGTYPE_SHIFT));
@@ -45,4 +45,4 @@ void adf_vf2pf_shutdown(struct adf_accel_dev *accel_dev)
 			dev_err(&GET_DEV(accel_dev),
 				"Failed to send Shutdown event to PF\n");
 }
-EXPORT_SYMBOL_GPL(adf_vf2pf_shutdown);
+EXPORT_SYMBOL_GPL(adf_vf2pf_notify_shutdown);
diff --git a/drivers/crypto/qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.c b/drivers/crypto/qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.c
index ac233a39a530..643a91f29e40 100644
--- a/drivers/crypto/qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.c
+++ b/drivers/crypto/qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.c
@@ -81,10 +81,10 @@ void adf_init_hw_data_dh895xcciov(struct adf_hw_device_data *hw_data)
 	hw_data->enable_error_correction = adf_vf_void_noop;
 	hw_data->init_admin_comms = adf_vf_int_noop;
 	hw_data->exit_admin_comms = adf_vf_void_noop;
-	hw_data->send_admin_init = adf_vf2pf_init;
+	hw_data->send_admin_init = adf_vf2pf_notify_init;
 	hw_data->init_arb = adf_vf_int_noop;
 	hw_data->exit_arb = adf_vf_void_noop;
-	hw_data->disable_iov = adf_vf2pf_shutdown;
+	hw_data->disable_iov = adf_vf2pf_notify_shutdown;
 	hw_data->get_accel_mask = get_accel_mask;
 	hw_data->get_ae_mask = get_ae_mask;
 	hw_data->get_num_accels = get_num_accels;
-- 
2.31.1

