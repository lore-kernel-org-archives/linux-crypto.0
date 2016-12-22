From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH] crypto: qat - increase number of supported devices
Date: Thu, 22 Dec 2016 15:01:02 +0000
Message-ID: <20161222150102.6376-1-giovanni.cabiddu@intel.com>
Cc: linux-crypto@vger.kernel.org, giovanni.cabiddu@gmail.com,
        Xin Zeng <xin.zeng@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:41605 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S941129AbcLVPBH (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 22 Dec 2016 10:01:07 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Xin Zeng <xin.zeng@intel.com>

The unsigned long type for init_status and start_status in
service_hndl are not long enough to represent more than 64
acceleration devices. Use an array instead.

Signed-off-by: Xin Zeng <xin.zeng@intel.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/qat/qat_common/adf_cfg_common.h |  1 +
 drivers/crypto/qat/qat_common/adf_common_drv.h |  4 ++--
 drivers/crypto/qat/qat_common/adf_init.c       | 28 +++++++++++++++-----------
 3 files changed, 19 insertions(+), 14 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_cfg_common.h b/drivers/crypto/qat/qat_common/adf_cfg_common.h
index 8c4f657..1211261 100644
--- a/drivers/crypto/qat/qat_common/adf_cfg_common.h
+++ b/drivers/crypto/qat/qat_common/adf_cfg_common.h
@@ -61,6 +61,7 @@
 #define ADF_CFG_AFFINITY_WHATEVER 0xFF
 #define MAX_DEVICE_NAME_SIZE 32
 #define ADF_MAX_DEVICES (32 * 32)
+#define ADF_DEVS_ARRAY_SIZE BITS_TO_LONGS(ADF_MAX_DEVICES)
 
 enum adf_cfg_val_type {
 	ADF_DEC,
diff --git a/drivers/crypto/qat/qat_common/adf_common_drv.h b/drivers/crypto/qat/qat_common/adf_common_drv.h
index 980e074..5c4c0a2 100644
--- a/drivers/crypto/qat/qat_common/adf_common_drv.h
+++ b/drivers/crypto/qat/qat_common/adf_common_drv.h
@@ -87,8 +87,8 @@ enum adf_event {
 struct service_hndl {
 	int (*event_hld)(struct adf_accel_dev *accel_dev,
 			 enum adf_event event);
-	unsigned long init_status;
-	unsigned long start_status;
+	unsigned long init_status[ADF_DEVS_ARRAY_SIZE];
+	unsigned long start_status[ADF_DEVS_ARRAY_SIZE];
 	char *name;
 	struct list_head list;
 };
diff --git a/drivers/crypto/qat/qat_common/adf_init.c b/drivers/crypto/qat/qat_common/adf_init.c
index 888c667..26556c7 100644
--- a/drivers/crypto/qat/qat_common/adf_init.c
+++ b/drivers/crypto/qat/qat_common/adf_init.c
@@ -64,8 +64,8 @@ static void adf_service_add(struct service_hndl *service)
 
 int adf_service_register(struct service_hndl *service)
 {
-	service->init_status = 0;
-	service->start_status = 0;
+	memset(service->init_status, 0, sizeof(service->init_status));
+	memset(service->start_status, 0, sizeof(service->start_status));
 	adf_service_add(service);
 	return 0;
 }
@@ -79,9 +79,13 @@ static void adf_service_remove(struct service_hndl *service)
 
 int adf_service_unregister(struct service_hndl *service)
 {
-	if (service->init_status || service->start_status) {
-		pr_err("QAT: Could not remove active service\n");
-		return -EFAULT;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(service->init_status); i++) {
+		if (service->init_status[i] || service->start_status[i]) {
+			pr_err("QAT: Could not remove active service\n");
+			return -EFAULT;
+		}
 	}
 	adf_service_remove(service);
 	return 0;
@@ -163,7 +167,7 @@ int adf_dev_init(struct adf_accel_dev *accel_dev)
 				service->name);
 			return -EFAULT;
 		}
-		set_bit(accel_dev->accel_id, &service->init_status);
+		set_bit(accel_dev->accel_id, service->init_status);
 	}
 
 	hw_data->enable_error_correction(accel_dev);
@@ -210,7 +214,7 @@ int adf_dev_start(struct adf_accel_dev *accel_dev)
 				service->name);
 			return -EFAULT;
 		}
-		set_bit(accel_dev->accel_id, &service->start_status);
+		set_bit(accel_dev->accel_id, service->start_status);
 	}
 
 	clear_bit(ADF_STATUS_STARTING, &accel_dev->status);
@@ -259,14 +263,14 @@ void adf_dev_stop(struct adf_accel_dev *accel_dev)
 
 	list_for_each(list_itr, &service_table) {
 		service = list_entry(list_itr, struct service_hndl, list);
-		if (!test_bit(accel_dev->accel_id, &service->start_status))
+		if (!test_bit(accel_dev->accel_id, service->start_status))
 			continue;
 		ret = service->event_hld(accel_dev, ADF_EVENT_STOP);
 		if (!ret) {
-			clear_bit(accel_dev->accel_id, &service->start_status);
+			clear_bit(accel_dev->accel_id, service->start_status);
 		} else if (ret == -EAGAIN) {
 			wait = true;
-			clear_bit(accel_dev->accel_id, &service->start_status);
+			clear_bit(accel_dev->accel_id, service->start_status);
 		}
 	}
 
@@ -317,14 +321,14 @@ void adf_dev_shutdown(struct adf_accel_dev *accel_dev)
 
 	list_for_each(list_itr, &service_table) {
 		service = list_entry(list_itr, struct service_hndl, list);
-		if (!test_bit(accel_dev->accel_id, &service->init_status))
+		if (!test_bit(accel_dev->accel_id, service->init_status))
 			continue;
 		if (service->event_hld(accel_dev, ADF_EVENT_SHUTDOWN))
 			dev_err(&GET_DEV(accel_dev),
 				"Failed to shutdown service %s\n",
 				service->name);
 		else
-			clear_bit(accel_dev->accel_id, &service->init_status);
+			clear_bit(accel_dev->accel_id, service->init_status);
 	}
 
 	hw_data->disable_iov(accel_dev);
-- 
2.9.3
