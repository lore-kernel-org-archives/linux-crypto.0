From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH] crypto: qat - fix invalid pf2vf_resp_wq logic
Date: Mon, 25 Apr 2016 07:32:19 -0700
Message-ID: <1461594739-7616-1-git-send-email-tadeusz.struk@intel.com>
Cc: <linux-crypto@vger.kernel.org>, <stable@vger.kernel.org>,
	<tadeusz.struk@intel.com>, <sureshx.marikkannu@intel.com>
To: <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:44641 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754859AbcDYOiC (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 25 Apr 2016 10:38:02 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The pf2vf_resp_wq is a global so it has to be created at init
and destroyed at exit, instead of per device.

Cc: <stable@vger.kernel.org>

Tested-by: Suresh Marikkannu <sureshx.marikkannu@intel.com>
Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 drivers/crypto/qat/qat_common/adf_common_drv.h |  2 ++
 drivers/crypto/qat/qat_common/adf_ctl_drv.c    |  6 ++++++
 drivers/crypto/qat/qat_common/adf_sriov.c      | 26 ++++++++++++++++----------
 3 files changed, 24 insertions(+), 10 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_common_drv.h b/drivers/crypto/qat/qat_common/adf_common_drv.h
index 557ea36..ff0b37b 100644
--- a/drivers/crypto/qat/qat_common/adf_common_drv.h
+++ b/drivers/crypto/qat/qat_common/adf_common_drv.h
@@ -146,6 +146,8 @@ int adf_init_aer(void);
 void adf_exit_aer(void);
 int adf_init_vf_wq(void);
 void adf_exit_vf_wq(void);
+int adf_init_pf_wq(void);
+void adf_exit_pf_wq(void);
 int adf_init_admin_comms(struct adf_accel_dev *accel_dev);
 void adf_exit_admin_comms(struct adf_accel_dev *accel_dev);
 int adf_send_admin_init(struct adf_accel_dev *accel_dev);
diff --git a/drivers/crypto/qat/qat_common/adf_ctl_drv.c b/drivers/crypto/qat/qat_common/adf_ctl_drv.c
index 116ddda..db21b49 100644
--- a/drivers/crypto/qat/qat_common/adf_ctl_drv.c
+++ b/drivers/crypto/qat/qat_common/adf_ctl_drv.c
@@ -471,6 +471,9 @@ static int __init adf_register_ctl_device_driver(void)
 	if (adf_init_aer())
 		goto err_aer;
 
+	if (adf_init_pf_wq())
+		goto err_pf_wq;
+
 	if (adf_init_vf_wq())
 		goto err_vf_wq;
 
@@ -482,6 +485,8 @@ static int __init adf_register_ctl_device_driver(void)
 err_crypto_register:
 	adf_exit_vf_wq();
 err_vf_wq:
+	adf_exit_pf_wq();
+err_pf_wq:
 	adf_exit_aer();
 err_aer:
 	adf_chr_drv_destroy();
@@ -495,6 +500,7 @@ static void __exit adf_unregister_ctl_device_driver(void)
 	adf_chr_drv_destroy();
 	adf_exit_aer();
 	adf_exit_vf_wq();
+	adf_exit_pf_wq();
 	qat_crypto_unregister();
 	adf_clean_vf_map(false);
 	mutex_destroy(&adf_ctl_lock);
diff --git a/drivers/crypto/qat/qat_common/adf_sriov.c b/drivers/crypto/qat/qat_common/adf_sriov.c
index 4479b0b..4a526e2 100644
--- a/drivers/crypto/qat/qat_common/adf_sriov.c
+++ b/drivers/crypto/qat/qat_common/adf_sriov.c
@@ -119,11 +119,6 @@ static int adf_enable_sriov(struct adf_accel_dev *accel_dev)
 	int i;
 	u32 reg;
 
-	/* Workqueue for PF2VF responses */
-	pf2vf_resp_wq = create_workqueue("qat_pf2vf_resp_wq");
-	if (!pf2vf_resp_wq)
-		return -ENOMEM;
-
 	for (i = 0, vf_info = accel_dev->pf.vf_info; i < totalvfs;
 	     i++, vf_info++) {
 		/* This ptr will be populated when VFs will be created */
@@ -216,11 +211,6 @@ void adf_disable_sriov(struct adf_accel_dev *accel_dev)
 
 	kfree(accel_dev->pf.vf_info);
 	accel_dev->pf.vf_info = NULL;
-
-	if (pf2vf_resp_wq) {
-		destroy_workqueue(pf2vf_resp_wq);
-		pf2vf_resp_wq = NULL;
-	}
 }
 EXPORT_SYMBOL_GPL(adf_disable_sriov);
 
@@ -298,3 +288,19 @@ int adf_sriov_configure(struct pci_dev *pdev, int numvfs)
 	return numvfs;
 }
 EXPORT_SYMBOL_GPL(adf_sriov_configure);
+
+int __init adf_init_pf_wq(void)
+{
+	/* Workqueue for PF2VF responses */
+	pf2vf_resp_wq = create_workqueue("qat_pf2vf_resp_wq");
+
+	return !pf2vf_resp_wq ? -ENOMEM : 0;
+}
+
+void adf_exit_pf_wq(void)
+{
+	if (pf2vf_resp_wq) {
+		destroy_workqueue(pf2vf_resp_wq);
+		pf2vf_resp_wq = NULL;
+	}
+}
-- 
2.1.4
