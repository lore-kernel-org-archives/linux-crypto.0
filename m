From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH 3/8] crypto: qat - check status returned from
 crypto_unregister_akcipher
Date: Wed, 09 Sep 2015 09:15:13 -0700
Message-ID: <20150909161513.2828.43757.stgit@tstruk-mobl1>
References: <20150909161454.2828.70445.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com,
	tadeusz.struk@intel.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:57523 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751957AbbIIQRD (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 9 Sep 2015 12:17:03 -0400
In-Reply-To: <20150909161454.2828.70445.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add status check returned from crypto_unregister_akcipher.

Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 drivers/crypto/qat/qat_common/adf_common_drv.h |    2 +-
 drivers/crypto/qat/qat_common/adf_init.c       |    6 ++----
 drivers/crypto/qat/qat_common/qat_asym_algs.c  |    7 +++++--
 3 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_common_drv.h b/drivers/crypto/qat/qat_common/adf_common_drv.h
index 7836dff..6882c52 100644
--- a/drivers/crypto/qat/qat_common/adf_common_drv.h
+++ b/drivers/crypto/qat/qat_common/adf_common_drv.h
@@ -168,7 +168,7 @@ void qat_algs_exit(void);
 int qat_algs_register(void);
 int qat_algs_unregister(void);
 int qat_asym_algs_register(void);
-void qat_asym_algs_unregister(void);
+int qat_asym_algs_unregister(void);
 
 int qat_hal_init(struct adf_accel_dev *accel_dev);
 void qat_hal_deinit(struct icp_qat_fw_loader_handle *handle);
diff --git a/drivers/crypto/qat/qat_common/adf_init.c b/drivers/crypto/qat/qat_common/adf_init.c
index ac37a89..e9d52a8 100644
--- a/drivers/crypto/qat/qat_common/adf_init.c
+++ b/drivers/crypto/qat/qat_common/adf_init.c
@@ -272,13 +272,11 @@ int adf_dev_stop(struct adf_accel_dev *accel_dev)
 	clear_bit(ADF_STATUS_STARTING, &accel_dev->status);
 	clear_bit(ADF_STATUS_STARTED, &accel_dev->status);
 
-	if (!list_empty(&accel_dev->crypto_list) && qat_algs_unregister())
+	if (!list_empty(&accel_dev->crypto_list) &&
+	    (qat_algs_unregister() || qat_asym_algs_unregister()))
 		dev_err(&GET_DEV(accel_dev),
 			"Failed to unregister crypto algs\n");
 
-	if (!list_empty(&accel_dev->crypto_list))
-		qat_asym_algs_unregister();
-
 	list_for_each(list_itr, &service_table) {
 		service = list_entry(list_itr, struct service_hndl, list);
 		if (!test_bit(accel_dev->accel_id, &service->start_status))
diff --git a/drivers/crypto/qat/qat_common/qat_asym_algs.c b/drivers/crypto/qat/qat_common/qat_asym_algs.c
index e87f510..7de765d 100644
--- a/drivers/crypto/qat/qat_common/qat_asym_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_asym_algs.c
@@ -643,10 +643,13 @@ int qat_asym_algs_register(void)
 	return ret;
 }
 
-void qat_asym_algs_unregister(void)
+int qat_asym_algs_unregister(void)
 {
+	int ret = 0;
+
 	mutex_lock(&algs_lock);
 	if (--active_devs == 0)
-		crypto_unregister_akcipher(&rsa);
+		ret = crypto_unregister_akcipher(&rsa);
 	mutex_unlock(&algs_lock);
+	return ret;
 }
