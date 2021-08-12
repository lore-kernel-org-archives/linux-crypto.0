Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2F77C4338F
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Aug 2021 20:22:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE65A60EB2
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Aug 2021 20:22:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237163AbhHLUWr (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 12 Aug 2021 16:22:47 -0400
Received: from mga03.intel.com ([134.134.136.65]:4154 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237192AbhHLUWi (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Aug 2021 16:22:38 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10074"; a="215474072"
X-IronPort-AV: E=Sophos;i="5.84,316,1620716400"; 
   d="scan'208";a="215474072"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2021 13:22:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,316,1620716400"; 
   d="scan'208";a="517608735"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.51])
  by FMSMGA003.fm.intel.com with ESMTP; 12 Aug 2021 13:22:10 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Ahsan Atta <ahsan.atta@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Fiona Trahe <fiona.trahe@intel.com>
Subject: [PATCH 18/20] crypto: qat - flush vf workqueue at driver removal
Date:   Thu, 12 Aug 2021 21:21:27 +0100
Message-Id: <20210812202129.18831-19-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210812202129.18831-1-giovanni.cabiddu@intel.com>
References: <20210812202129.18831-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Ahsan Atta <ahsan.atta@intel.com>

There is a race condition during shutdown in adf_disable_sriov() where
both the PF and the VF drivers are loaded on the host system.
The PF notifies a VF with a "RESTARTING" message due to which the VF
starts an asynchronous worker to stop and shutdown itself.
At the same time the PF calls pci_disable_sriov() which invokes the
remove() routine on the VF device driver triggering the shutdown flow
again.

This change fixes the problem by ensuring that the VF flushes the worker
that performs stop()/shutdown() before these two functions are called in
the remove(). To make sure that no additional PV/VF messages are
processed by the VF, interrupts are disabled before flushing the
workqueue.

Signed-off-by: Ahsan Atta <ahsan.atta@intel.com>
Co-developed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Fiona Trahe <fiona.trahe@intel.com>
---
 drivers/crypto/qat/qat_c3xxxvf/adf_drv.c      |  1 +
 drivers/crypto/qat/qat_c62xvf/adf_drv.c       |  1 +
 .../crypto/qat/qat_common/adf_common_drv.h    |  5 ++++
 drivers/crypto/qat/qat_common/adf_vf_isr.c    | 25 +++++++++++++++++++
 drivers/crypto/qat/qat_dh895xccvf/adf_drv.c   |  1 +
 5 files changed, 33 insertions(+)

diff --git a/drivers/crypto/qat/qat_c3xxxvf/adf_drv.c b/drivers/crypto/qat/qat_c3xxxvf/adf_drv.c
index 067ca5e17d38..6ff216c6aa39 100644
--- a/drivers/crypto/qat/qat_c3xxxvf/adf_drv.c
+++ b/drivers/crypto/qat/qat_c3xxxvf/adf_drv.c
@@ -218,6 +218,7 @@ static void adf_remove(struct pci_dev *pdev)
 		pr_err("QAT: Driver removal failed\n");
 		return;
 	}
+	adf_flush_vf_wq(accel_dev);
 	adf_dev_stop(accel_dev);
 	adf_dev_shutdown(accel_dev);
 	adf_cleanup_accel(accel_dev);
diff --git a/drivers/crypto/qat/qat_c62xvf/adf_drv.c b/drivers/crypto/qat/qat_c62xvf/adf_drv.c
index 51ea88c0b17d..7c9826002ce6 100644
--- a/drivers/crypto/qat/qat_c62xvf/adf_drv.c
+++ b/drivers/crypto/qat/qat_c62xvf/adf_drv.c
@@ -218,6 +218,7 @@ static void adf_remove(struct pci_dev *pdev)
 		pr_err("QAT: Driver removal failed\n");
 		return;
 	}
+	adf_flush_vf_wq(accel_dev);
 	adf_dev_stop(accel_dev);
 	adf_dev_shutdown(accel_dev);
 	adf_cleanup_accel(accel_dev);
diff --git a/drivers/crypto/qat/qat_common/adf_common_drv.h b/drivers/crypto/qat/qat_common/adf_common_drv.h
index 4b18843f9845..4261749fae8d 100644
--- a/drivers/crypto/qat/qat_common/adf_common_drv.h
+++ b/drivers/crypto/qat/qat_common/adf_common_drv.h
@@ -207,6 +207,7 @@ int adf_init_pf_wq(void);
 void adf_exit_pf_wq(void);
 int adf_init_vf_wq(void);
 void adf_exit_vf_wq(void);
+void adf_flush_vf_wq(struct adf_accel_dev *accel_dev);
 #else
 #define adf_sriov_configure NULL
 
@@ -249,5 +250,9 @@ static inline void adf_exit_vf_wq(void)
 {
 }
 
+static inline void adf_flush_vf_wq(struct adf_accel_dev *accel_dev)
+{
+}
+
 #endif
 #endif
diff --git a/drivers/crypto/qat/qat_common/adf_vf_isr.c b/drivers/crypto/qat/qat_common/adf_vf_isr.c
index 078f33d583e8..7828a6573f3e 100644
--- a/drivers/crypto/qat/qat_common/adf_vf_isr.c
+++ b/drivers/crypto/qat/qat_common/adf_vf_isr.c
@@ -48,6 +48,7 @@ void adf_disable_pf2vf_interrupts(struct adf_accel_dev *accel_dev)
 
 	ADF_CSR_WR(pmisc_bar_addr, ADF_VINTMSK_OFFSET, 0x2);
 }
+EXPORT_SYMBOL_GPL(adf_disable_pf2vf_interrupts);
 
 static int adf_enable_msi(struct adf_accel_dev *accel_dev)
 {
@@ -316,6 +317,30 @@ int adf_vf_isr_resource_alloc(struct adf_accel_dev *accel_dev)
 }
 EXPORT_SYMBOL_GPL(adf_vf_isr_resource_alloc);
 
+/**
+ * adf_flush_vf_wq() - Flush workqueue for VF
+ * @accel_dev:  Pointer to acceleration device.
+ *
+ * Function disables the PF/VF interrupts on the VF so that no new messages
+ * are received and flushes the workqueue 'adf_vf_stop_wq'.
+ *
+ * Return: void.
+ */
+void adf_flush_vf_wq(struct adf_accel_dev *accel_dev)
+{
+	adf_disable_pf2vf_interrupts(accel_dev);
+
+	flush_workqueue(adf_vf_stop_wq);
+}
+EXPORT_SYMBOL_GPL(adf_flush_vf_wq);
+
+/**
+ * adf_init_vf_wq() - Init workqueue for VF
+ *
+ * Function init workqueue 'adf_vf_stop_wq' for VF.
+ *
+ * Return: 0 on success, error code otherwise.
+ */
 int __init adf_init_vf_wq(void)
 {
 	adf_vf_stop_wq = alloc_workqueue("adf_vf_stop_wq", WQ_MEM_RECLAIM, 0);
diff --git a/drivers/crypto/qat/qat_dh895xccvf/adf_drv.c b/drivers/crypto/qat/qat_dh895xccvf/adf_drv.c
index 29999da716cc..b131cfe8dcfc 100644
--- a/drivers/crypto/qat/qat_dh895xccvf/adf_drv.c
+++ b/drivers/crypto/qat/qat_dh895xccvf/adf_drv.c
@@ -218,6 +218,7 @@ static void adf_remove(struct pci_dev *pdev)
 		pr_err("QAT: Driver removal failed\n");
 		return;
 	}
+	adf_flush_vf_wq(accel_dev);
 	adf_dev_stop(accel_dev);
 	adf_dev_shutdown(accel_dev);
 	adf_cleanup_accel(accel_dev);
-- 
2.31.1

