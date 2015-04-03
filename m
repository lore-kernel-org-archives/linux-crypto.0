From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH] crypto: qat - fix double release_firmware on error path
Date: Fri, 03 Apr 2015 08:41:17 -0700
Message-ID: <20150403154117.1172.27874.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: davem@davemloft.net, ahsan.atta@intel.com,
	linux-crypto@vger.kernel.org, qat-linux@intel.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:22115 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752082AbbDCPoH (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 3 Apr 2015 11:44:07 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

release_firmware was called twice on error path causing an Oops.

Reported-by: Ahsan Atta  <ahsan.atta@intel.com>
Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 drivers/crypto/qat/qat_common/adf_accel_engine.c |   14 ++++++++++----
 drivers/crypto/qat/qat_common/adf_common_drv.h   |    2 +-
 drivers/crypto/qat/qat_common/adf_init.c         |    9 ++-------
 3 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_accel_engine.c b/drivers/crypto/qat/qat_common/adf_accel_engine.c
index 97e8ea5..7f8b66c 100644
--- a/drivers/crypto/qat/qat_common/adf_accel_engine.c
+++ b/drivers/crypto/qat/qat_common/adf_accel_engine.c
@@ -78,19 +78,22 @@ int adf_ae_fw_load(struct adf_accel_dev *accel_dev)
 	return 0;
 
 out_err:
-	release_firmware(loader_data->uof_fw);
+	adf_ae_fw_release(accel_dev);
 	return -EFAULT;
 }
 
-int adf_ae_fw_release(struct adf_accel_dev *accel_dev)
+void adf_ae_fw_release(struct adf_accel_dev *accel_dev)
 {
 	struct adf_fw_loader_data *loader_data = accel_dev->fw_loader;
 
-	release_firmware(loader_data->uof_fw);
 	qat_uclo_del_uof_obj(loader_data->fw_loader);
 	qat_hal_deinit(loader_data->fw_loader);
+
+	if (loader_data->uof_fw)
+		release_firmware(loader_data->uof_fw);
+
+	loader_data->uof_fw = NULL;
 	loader_data->fw_loader = NULL;
-	return 0;
 }
 
 int adf_ae_start(struct adf_accel_dev *accel_dev)
@@ -165,6 +168,9 @@ int adf_ae_init(struct adf_accel_dev *accel_dev)
 
 int adf_ae_shutdown(struct adf_accel_dev *accel_dev)
 {
+	struct adf_fw_loader_data *loader_data = accel_dev->fw_loader;
+
+	qat_hal_deinit(loader_data->fw_loader);
 	kfree(accel_dev->fw_loader);
 	accel_dev->fw_loader = NULL;
 	return 0;
diff --git a/drivers/crypto/qat/qat_common/adf_common_drv.h b/drivers/crypto/qat/qat_common/adf_common_drv.h
index a62e485..0666ee6 100644
--- a/drivers/crypto/qat/qat_common/adf_common_drv.h
+++ b/drivers/crypto/qat/qat_common/adf_common_drv.h
@@ -115,7 +115,7 @@ int adf_dev_restarted_notify(struct adf_accel_dev *accel_dev);
 int adf_ae_init(struct adf_accel_dev *accel_dev);
 int adf_ae_shutdown(struct adf_accel_dev *accel_dev);
 int adf_ae_fw_load(struct adf_accel_dev *accel_dev);
-int adf_ae_fw_release(struct adf_accel_dev *accel_dev);
+void adf_ae_fw_release(struct adf_accel_dev *accel_dev);
 int adf_ae_start(struct adf_accel_dev *accel_dev);
 int adf_ae_stop(struct adf_accel_dev *accel_dev);
 
diff --git a/drivers/crypto/qat/qat_common/adf_init.c b/drivers/crypto/qat/qat_common/adf_init.c
index da5793b..245f432 100644
--- a/drivers/crypto/qat/qat_common/adf_init.c
+++ b/drivers/crypto/qat/qat_common/adf_init.c
@@ -160,7 +160,6 @@ int adf_dev_init(struct adf_accel_dev *accel_dev)
 	if (adf_ae_fw_load(accel_dev)) {
 		dev_err(&GET_DEV(accel_dev),
 			"Failed to load acceleration FW\n");
-		adf_ae_fw_release(accel_dev);
 		return -EFAULT;
 	}
 	set_bit(ADF_STATUS_AE_UCODE_LOADED, &accel_dev->status);
@@ -359,12 +358,8 @@ void adf_dev_shutdown(struct adf_accel_dev *accel_dev)
 	}
 
 	if (test_bit(ADF_STATUS_AE_UCODE_LOADED, &accel_dev->status)) {
-		if (adf_ae_fw_release(accel_dev))
-			dev_err(&GET_DEV(accel_dev),
-				"Failed to release the ucode\n");
-		else
-			clear_bit(ADF_STATUS_AE_UCODE_LOADED,
-				  &accel_dev->status);
+		adf_ae_fw_release(accel_dev);
+		clear_bit(ADF_STATUS_AE_UCODE_LOADED, &accel_dev->status);
 	}
 
 	if (test_bit(ADF_STATUS_AE_INITIALISED, &accel_dev->status)) {
