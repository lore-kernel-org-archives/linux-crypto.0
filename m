From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH] crypto: qat - remove empty functions and turn qat_uregister
 fn to void
Date: Tue, 22 Sep 2015 11:57:47 -0700
Message-ID: <20150922185747.23055.52171.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com,
	tadeusz.struk@intel.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:55605 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934281AbbIVS7l (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 22 Sep 2015 14:59:41 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Some code cleanups after crypto API changes:
- Change qat_algs_unregister to a void function to keep it consistent
  with qat_asym_algs_unregister.
- Remove empty functions qat_algs_init & qat_algs_exit.

Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 drivers/crypto/qat/qat_common/adf_common_drv.h |    4 +---
 drivers/crypto/qat/qat_common/adf_ctl_drv.c    |    6 ------
 drivers/crypto/qat/qat_common/adf_init.c       |    8 +++-----
 drivers/crypto/qat/qat_common/qat_algs.c       |   12 +-----------
 4 files changed, 5 insertions(+), 25 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_common_drv.h b/drivers/crypto/qat/qat_common/adf_common_drv.h
index 7836dff..3f76bd4 100644
--- a/drivers/crypto/qat/qat_common/adf_common_drv.h
+++ b/drivers/crypto/qat/qat_common/adf_common_drv.h
@@ -163,10 +163,8 @@ struct qat_crypto_instance *qat_crypto_get_instance_node(int node);
 void qat_crypto_put_instance(struct qat_crypto_instance *inst);
 void qat_alg_callback(void *resp);
 void qat_alg_asym_callback(void *resp);
-int qat_algs_init(void);
-void qat_algs_exit(void);
 int qat_algs_register(void);
-int qat_algs_unregister(void);
+void qat_algs_unregister(void);
 int qat_asym_algs_register(void);
 void qat_asym_algs_unregister(void);
 
diff --git a/drivers/crypto/qat/qat_common/adf_ctl_drv.c b/drivers/crypto/qat/qat_common/adf_ctl_drv.c
index cd8a12a..03856ad 100644
--- a/drivers/crypto/qat/qat_common/adf_ctl_drv.c
+++ b/drivers/crypto/qat/qat_common/adf_ctl_drv.c
@@ -463,9 +463,6 @@ static int __init adf_register_ctl_device_driver(void)
 {
 	mutex_init(&adf_ctl_lock);
 
-	if (qat_algs_init())
-		goto err_algs_init;
-
 	if (adf_chr_drv_create())
 		goto err_chr_dev;
 
@@ -482,8 +479,6 @@ err_crypto_register:
 err_aer:
 	adf_chr_drv_destroy();
 err_chr_dev:
-	qat_algs_exit();
-err_algs_init:
 	mutex_destroy(&adf_ctl_lock);
 	return -EFAULT;
 }
@@ -493,7 +488,6 @@ static void __exit adf_unregister_ctl_device_driver(void)
 	adf_chr_drv_destroy();
 	adf_exit_aer();
 	qat_crypto_unregister();
-	qat_algs_exit();
 	adf_clean_vf_map(false);
 	mutex_destroy(&adf_ctl_lock);
 }
diff --git a/drivers/crypto/qat/qat_common/adf_init.c b/drivers/crypto/qat/qat_common/adf_init.c
index ac37a89..d873eee 100644
--- a/drivers/crypto/qat/qat_common/adf_init.c
+++ b/drivers/crypto/qat/qat_common/adf_init.c
@@ -272,12 +272,10 @@ int adf_dev_stop(struct adf_accel_dev *accel_dev)
 	clear_bit(ADF_STATUS_STARTING, &accel_dev->status);
 	clear_bit(ADF_STATUS_STARTED, &accel_dev->status);
 
-	if (!list_empty(&accel_dev->crypto_list) && qat_algs_unregister())
-		dev_err(&GET_DEV(accel_dev),
-			"Failed to unregister crypto algs\n");
-
-	if (!list_empty(&accel_dev->crypto_list))
+	if (!list_empty(&accel_dev->crypto_list)) {
+		qat_algs_unregister();
 		qat_asym_algs_unregister();
+	}
 
 	list_for_each(list_itr, &service_table) {
 		service = list_entry(list_itr, struct service_hndl, list);
diff --git a/drivers/crypto/qat/qat_common/qat_algs.c b/drivers/crypto/qat/qat_common/qat_algs.c
index 2bd913a..9ed7bd5 100644
--- a/drivers/crypto/qat/qat_common/qat_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_algs.c
@@ -1212,7 +1212,7 @@ unreg_algs:
 	goto unlock;
 }
 
-int qat_algs_unregister(void)
+void qat_algs_unregister(void)
 {
 	mutex_lock(&algs_lock);
 	if (--active_devs != 0)
@@ -1223,14 +1223,4 @@ int qat_algs_unregister(void)
 
 unlock:
 	mutex_unlock(&algs_lock);
-	return 0;
-}
-
-int qat_algs_init(void)
-{
-	return 0;
-}
-
-void qat_algs_exit(void)
-{
 }
