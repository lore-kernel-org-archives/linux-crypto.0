From: Bruce Allan <bruce.w.allan@intel.com>
Subject: [PATCH] crypto: qat - make error and info log messages more
 descriptive
Date: Thu, 19 Mar 2015 16:03:44 -0700
Message-ID: <20150319230344.2818.82688.stgit@bwallan-smackover2.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:59087 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751805AbbCSXEA (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 19 Mar 2015 19:04:00 -0400
Received: from bwallan-smackover2.jf.intel.com (localhost.localdomain [127.0.0.1])
	by bwallan-smackover2.jf.intel.com (8.14.8/8.14.8) with ESMTP id t2JN3iBn002867
	for <linux-crypto@vger.kernel.org>; Thu, 19 Mar 2015 16:03:44 -0700
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Convert pr_info() and pr_err() log messages to dev_info() and dev_err(),
respectively, where able.  This adds the module name and PCI B:D:F to
indicate which QAT device generated the log message.  The "QAT:" is removed
from these log messages as that is now unnecessary.  A few of these log
messages have additional spelling/contextual fixes.

Signed-off-by: Bruce Allan <bruce.w.allan@intel.com>
---
 drivers/crypto/qat/qat_common/adf_accel_engine.c   |   21 +++--
 drivers/crypto/qat/qat_common/adf_aer.c            |   19 +++--
 drivers/crypto/qat/qat_common/adf_cfg.c            |    5 +
 drivers/crypto/qat/qat_common/adf_ctl_drv.c        |   38 ++++++---
 drivers/crypto/qat/qat_common/adf_dev_mgr.c        |    3 -
 drivers/crypto/qat/qat_common/adf_init.c           |   83 ++++++++++++--------
 drivers/crypto/qat/qat_common/adf_transport.c      |   31 ++++---
 drivers/crypto/qat/qat_common/qat_crypto.c         |    5 +
 drivers/crypto/qat/qat_common/qat_hal.c            |    2 
 drivers/crypto/qat/qat_dh895xcc/adf_admin.c        |    3 -
 .../crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c |    3 -
 drivers/crypto/qat/qat_dh895xcc/adf_isr.c          |   15 ++--
 12 files changed, 137 insertions(+), 91 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_accel_engine.c b/drivers/crypto/qat/qat_common/adf_accel_engine.c
index c77453b..97e8ea5 100644
--- a/drivers/crypto/qat/qat_common/adf_accel_engine.c
+++ b/drivers/crypto/qat/qat_common/adf_accel_engine.c
@@ -60,18 +60,19 @@ int adf_ae_fw_load(struct adf_accel_dev *accel_dev)
 
 	if (request_firmware(&loader_data->uof_fw, hw_device->fw_name,
 			     &accel_dev->accel_pci_dev.pci_dev->dev)) {
-		pr_err("QAT: Failed to load firmware %s\n", hw_device->fw_name);
+		dev_err(&GET_DEV(accel_dev), "Failed to load firmware %s\n",
+			hw_device->fw_name);
 		return -EFAULT;
 	}
 
 	uof_size = loader_data->uof_fw->size;
 	uof_addr = (void *)loader_data->uof_fw->data;
 	if (qat_uclo_map_uof_obj(loader_data->fw_loader, uof_addr, uof_size)) {
-		pr_err("QAT: Failed to map UOF\n");
+		dev_err(&GET_DEV(accel_dev), "Failed to map UOF\n");
 		goto out_err;
 	}
 	if (qat_uclo_wr_all_uimage(loader_data->fw_loader)) {
-		pr_err("QAT: Failed to map UOF\n");
+		dev_err(&GET_DEV(accel_dev), "Failed to map UOF\n");
 		goto out_err;
 	}
 	return 0;
@@ -104,8 +105,9 @@ int adf_ae_start(struct adf_accel_dev *accel_dev)
 			ae_ctr++;
 		}
 	}
-	pr_info("QAT: qat_dev%d started %d acceleration engines\n",
-		accel_dev->accel_id, ae_ctr);
+	dev_info(&GET_DEV(accel_dev),
+		 "qat_dev%d started %d acceleration engines\n",
+		 accel_dev->accel_id, ae_ctr);
 	return 0;
 }
 
@@ -121,8 +123,9 @@ int adf_ae_stop(struct adf_accel_dev *accel_dev)
 			ae_ctr++;
 		}
 	}
-	pr_info("QAT: qat_dev%d stopped %d acceleration engines\n",
-		accel_dev->accel_id, ae_ctr);
+	dev_info(&GET_DEV(accel_dev),
+		 "qat_dev%d stopped %d acceleration engines\n",
+		 accel_dev->accel_id, ae_ctr);
 	return 0;
 }
 
@@ -147,12 +150,12 @@ int adf_ae_init(struct adf_accel_dev *accel_dev)
 
 	accel_dev->fw_loader = loader_data;
 	if (qat_hal_init(accel_dev)) {
-		pr_err("QAT: Failed to init the AEs\n");
+		dev_err(&GET_DEV(accel_dev), "Failed to init the AEs\n");
 		kfree(loader_data);
 		return -EFAULT;
 	}
 	if (adf_ae_reset(accel_dev, 0)) {
-		pr_err("QAT: Failed to reset the AEs\n");
+		dev_err(&GET_DEV(accel_dev), "Failed to reset the AEs\n");
 		qat_hal_deinit(loader_data->fw_loader);
 		kfree(loader_data);
 		return -EFAULT;
diff --git a/drivers/crypto/qat/qat_common/adf_aer.c b/drivers/crypto/qat/qat_common/adf_aer.c
index fa1fef8..82e23b8 100644
--- a/drivers/crypto/qat/qat_common/adf_aer.c
+++ b/drivers/crypto/qat/qat_common/adf_aer.c
@@ -60,14 +60,14 @@ static pci_ers_result_t adf_error_detected(struct pci_dev *pdev,
 {
 	struct adf_accel_dev *accel_dev = adf_devmgr_pci_to_accel_dev(pdev);
 
-	pr_info("QAT: Acceleration driver hardware error detected.\n");
+	dev_info(&pdev->dev, "Acceleration driver hardware error detected.\n");
 	if (!accel_dev) {
-		pr_err("QAT: Can't find acceleration device\n");
+		dev_err(&pdev->dev, "Can't find acceleration device\n");
 		return PCI_ERS_RESULT_DISCONNECT;
 	}
 
 	if (state == pci_channel_io_perm_failure) {
-		pr_err("QAT: Can't recover from device error\n");
+		dev_err(&pdev->dev, "Can't recover from device error\n");
 		return PCI_ERS_RESULT_DISCONNECT;
 	}
 
@@ -88,10 +88,12 @@ static void adf_dev_restore(struct adf_accel_dev *accel_dev)
 	struct pci_dev *parent = pdev->bus->self;
 	uint16_t bridge_ctl = 0;
 
-	pr_info("QAT: Resetting device qat_dev%d\n", accel_dev->accel_id);
+	dev_info(&GET_DEV(accel_dev), "Resetting device qat_dev%d\n",
+		 accel_dev->accel_id);
 
 	if (!pci_wait_for_pending_transaction(pdev))
-		pr_info("QAT: Transaction still in progress. Proceeding\n");
+		dev_info(&GET_DEV(accel_dev),
+			 "Transaction still in progress. Proceeding\n");
 
 	pci_read_config_word(parent, PCI_BRIDGE_CONTROL, &bridge_ctl);
 	bridge_ctl |= PCI_BRIDGE_CTL_BUS_RESET;
@@ -158,7 +160,8 @@ static int adf_dev_aer_schedule_reset(struct adf_accel_dev *accel_dev,
 		unsigned long timeout = wait_for_completion_timeout(
 				   &reset_data->compl, wait_jiffies);
 		if (!timeout) {
-			pr_err("QAT: Reset device timeout expired\n");
+			dev_err(&GET_DEV(accel_dev),
+				"Reset device timeout expired\n");
 			ret = -EFAULT;
 		}
 		kfree(reset_data);
@@ -184,8 +187,8 @@ static pci_ers_result_t adf_slot_reset(struct pci_dev *pdev)
 
 static void adf_resume(struct pci_dev *pdev)
 {
-	pr_info("QAT: Acceleration driver reset completed\n");
-	pr_info("QAT: Device is up and runnig\n");
+	dev_info(&pdev->dev, "Acceleration driver reset completed\n");
+	dev_info(&pdev->dev, "Device is up and runnig\n");
 }
 
 static struct pci_error_handlers adf_err_handler = {
diff --git a/drivers/crypto/qat/qat_common/adf_cfg.c b/drivers/crypto/qat/qat_common/adf_cfg.c
index de16da9..ab65bc2 100644
--- a/drivers/crypto/qat/qat_common/adf_cfg.c
+++ b/drivers/crypto/qat/qat_common/adf_cfg.c
@@ -142,7 +142,8 @@ int adf_cfg_dev_add(struct adf_accel_dev *accel_dev)
 						  dev_cfg_data,
 						  &qat_dev_cfg_fops);
 	if (!dev_cfg_data->debug) {
-		pr_err("QAT: Failed to create qat cfg debugfs entry.\n");
+		dev_err(&GET_DEV(accel_dev),
+			"Failed to create qat cfg debugfs entry.\n");
 		kfree(dev_cfg_data);
 		accel_dev->cfg = NULL;
 		return -EFAULT;
@@ -305,7 +306,7 @@ int adf_cfg_add_key_value_param(struct adf_accel_dev *accel_dev,
 		snprintf(key_val->val, ADF_CFG_MAX_VAL_LEN_IN_BYTES,
 			 "0x%lx", (unsigned long)val);
 	} else {
-		pr_err("QAT: Unknown type given.\n");
+		dev_err(&GET_DEV(accel_dev), "Unknown type given.\n");
 		kfree(key_val);
 		return -1;
 	}
diff --git a/drivers/crypto/qat/qat_common/adf_ctl_drv.c b/drivers/crypto/qat/qat_common/adf_ctl_drv.c
index 74207a6..731538a 100644
--- a/drivers/crypto/qat/qat_common/adf_ctl_drv.c
+++ b/drivers/crypto/qat/qat_common/adf_ctl_drv.c
@@ -159,14 +159,16 @@ static int adf_add_key_value_data(struct adf_accel_dev *accel_dev,
 		if (adf_cfg_add_key_value_param(accel_dev, section,
 						key_val->key, (void *)val,
 						key_val->type)) {
-			pr_err("QAT: failed to add keyvalue.\n");
+			dev_err(&GET_DEV(accel_dev),
+				"failed to add hex keyvalue.\n");
 			return -EFAULT;
 		}
 	} else {
 		if (adf_cfg_add_key_value_param(accel_dev, section,
 						key_val->key, key_val->val,
 						key_val->type)) {
-			pr_err("QAT: failed to add keyvalue.\n");
+			dev_err(&GET_DEV(accel_dev),
+				"failed to add keyvalue.\n");
 			return -EFAULT;
 		}
 	}
@@ -185,12 +187,14 @@ static int adf_copy_key_value_data(struct adf_accel_dev *accel_dev,
 	while (section_head) {
 		if (copy_from_user(&section, (void __user *)section_head,
 				   sizeof(*section_head))) {
-			pr_err("QAT: failed to copy section info\n");
+			dev_err(&GET_DEV(accel_dev),
+				"failed to copy section info\n");
 			goto out_err;
 		}
 
 		if (adf_cfg_section_add(accel_dev, section.name)) {
-			pr_err("QAT: failed to add section.\n");
+			dev_err(&GET_DEV(accel_dev),
+				"failed to add section.\n");
 			goto out_err;
 		}
 
@@ -199,7 +203,8 @@ static int adf_copy_key_value_data(struct adf_accel_dev *accel_dev,
 		while (params_head) {
 			if (copy_from_user(&key_val, (void __user *)params_head,
 					   sizeof(key_val))) {
-				pr_err("QAT: Failed to copy keyvalue.\n");
+				dev_err(&GET_DEV(accel_dev),
+					"Failed to copy keyvalue.\n");
 				goto out_err;
 			}
 			if (adf_add_key_value_data(accel_dev, section.name,
@@ -258,8 +263,9 @@ static int adf_ctl_is_device_in_use(int id)
 
 		if (id == dev->accel_id || id == ADF_CFG_ALL_DEVICES) {
 			if (adf_devmgr_in_reset(dev) || adf_dev_in_use(dev)) {
-				pr_info("QAT: device qat_dev%d is busy\n",
-					dev->accel_id);
+				dev_info(&GET_DEV(dev),
+					 "device qat_dev%d is busy\n",
+					 dev->accel_id);
 				return -EBUSY;
 			}
 		}
@@ -280,7 +286,8 @@ static int adf_ctl_stop_devices(uint32_t id)
 				continue;
 
 			if (adf_dev_stop(accel_dev)) {
-				pr_err("QAT: Failed to stop qat_dev%d\n", id);
+				dev_err(&GET_DEV(accel_dev),
+					"Failed to stop qat_dev%d\n", id);
 				ret = -EFAULT;
 			} else {
 				adf_dev_shutdown(accel_dev);
@@ -343,17 +350,20 @@ static int adf_ctl_ioctl_dev_start(struct file *fp, unsigned int cmd,
 	}
 
 	if (!adf_dev_started(accel_dev)) {
-		pr_info("QAT: Starting acceleration device qat_dev%d.\n",
-			ctl_data->device_id);
+		dev_info(&GET_DEV(accel_dev),
+			 "Starting acceleration device qat_dev%d.\n",
+			 ctl_data->device_id);
 		ret = adf_dev_init(accel_dev);
 		if (!ret)
 			ret = adf_dev_start(accel_dev);
 	} else {
-		pr_info("QAT: Acceleration device qat_dev%d already started.\n",
-			ctl_data->device_id);
+		dev_info(&GET_DEV(accel_dev),
+			 "Acceleration device qat_dev%d already started.\n",
+			 ctl_data->device_id);
 	}
 	if (ret) {
-		pr_err("QAT: Failed to start qat_dev%d\n", ctl_data->device_id);
+		dev_err(&GET_DEV(accel_dev), "Failed to start qat_dev%d\n",
+			ctl_data->device_id);
 		adf_dev_stop(accel_dev);
 		adf_dev_shutdown(accel_dev);
 	}
@@ -408,7 +418,7 @@ static int adf_ctl_ioctl_get_status(struct file *fp, unsigned int cmd,
 
 	if (copy_to_user((void __user *)arg, &dev_info,
 			 sizeof(struct adf_dev_status_info))) {
-		pr_err("QAT: failed to copy status.\n");
+		dev_err(&GET_DEV(accel_dev), "failed to copy status.\n");
 		return -EFAULT;
 	}
 	return 0;
diff --git a/drivers/crypto/qat/qat_common/adf_dev_mgr.c b/drivers/crypto/qat/qat_common/adf_dev_mgr.c
index 4a0a829d..3f0ff9e 100644
--- a/drivers/crypto/qat/qat_common/adf_dev_mgr.c
+++ b/drivers/crypto/qat/qat_common/adf_dev_mgr.c
@@ -67,7 +67,8 @@ int adf_devmgr_add_dev(struct adf_accel_dev *accel_dev)
 	struct list_head *itr;
 
 	if (num_devices == ADF_MAX_DEVICES) {
-		pr_err("QAT: Only support up to %d devices\n", ADF_MAX_DEVICES);
+		dev_err(&GET_DEV(accel_dev), "Only support up to %d devices\n",
+			ADF_MAX_DEVICES);
 		return -EFAULT;
 	}
 
diff --git a/drivers/crypto/qat/qat_common/adf_init.c b/drivers/crypto/qat/qat_common/adf_init.c
index 8f0ca49..da5793b 100644
--- a/drivers/crypto/qat/qat_common/adf_init.c
+++ b/drivers/crypto/qat/qat_common/adf_init.c
@@ -124,12 +124,12 @@ int adf_dev_init(struct adf_accel_dev *accel_dev)
 
 	if (!hw_data) {
 		dev_err(&GET_DEV(accel_dev),
-			"QAT: Failed to init device - hw_data not set\n");
+			"Failed to init device - hw_data not set\n");
 		return -EFAULT;
 	}
 
 	if (!test_bit(ADF_STATUS_CONFIGURED, &accel_dev->status)) {
-		pr_info("QAT: Device not configured\n");
+		dev_err(&GET_DEV(accel_dev), "Device not configured\n");
 		return -EFAULT;
 	}
 
@@ -151,20 +151,22 @@ int adf_dev_init(struct adf_accel_dev *accel_dev)
 	hw_data->enable_ints(accel_dev);
 
 	if (adf_ae_init(accel_dev)) {
-		pr_err("QAT: Failed to initialise Acceleration Engine\n");
+		dev_err(&GET_DEV(accel_dev),
+			"Failed to initialise Acceleration Engine\n");
 		return -EFAULT;
 	}
 	set_bit(ADF_STATUS_AE_INITIALISED, &accel_dev->status);
 
 	if (adf_ae_fw_load(accel_dev)) {
-		pr_err("QAT: Failed to load acceleration FW\n");
+		dev_err(&GET_DEV(accel_dev),
+			"Failed to load acceleration FW\n");
 		adf_ae_fw_release(accel_dev);
 		return -EFAULT;
 	}
 	set_bit(ADF_STATUS_AE_UCODE_LOADED, &accel_dev->status);
 
 	if (hw_data->alloc_irq(accel_dev)) {
-		pr_err("QAT: Failed to allocate interrupts\n");
+		dev_err(&GET_DEV(accel_dev), "Failed to allocate interrupts\n");
 		return -EFAULT;
 	}
 	set_bit(ADF_STATUS_IRQ_ALLOCATED, &accel_dev->status);
@@ -179,8 +181,9 @@ int adf_dev_init(struct adf_accel_dev *accel_dev)
 		if (!service->admin)
 			continue;
 		if (service->event_hld(accel_dev, ADF_EVENT_INIT)) {
-			pr_err("QAT: Failed to initialise service %s\n",
-			       service->name);
+			dev_err(&GET_DEV(accel_dev),
+				"Failed to initialise service %s\n",
+				service->name);
 			return -EFAULT;
 		}
 		set_bit(accel_dev->accel_id, &service->init_status);
@@ -190,8 +193,9 @@ int adf_dev_init(struct adf_accel_dev *accel_dev)
 		if (service->admin)
 			continue;
 		if (service->event_hld(accel_dev, ADF_EVENT_INIT)) {
-			pr_err("QAT: Failed to initialise service %s\n",
-			       service->name);
+			dev_err(&GET_DEV(accel_dev),
+				"Failed to initialise service %s\n",
+				service->name);
 			return -EFAULT;
 		}
 		set_bit(accel_dev->accel_id, &service->init_status);
@@ -221,7 +225,7 @@ int adf_dev_start(struct adf_accel_dev *accel_dev)
 	set_bit(ADF_STATUS_STARTING, &accel_dev->status);
 
 	if (adf_ae_start(accel_dev)) {
-		pr_err("QAT: AE Start Failed\n");
+		dev_err(&GET_DEV(accel_dev), "AE Start Failed\n");
 		return -EFAULT;
 	}
 	set_bit(ADF_STATUS_AE_STARTED, &accel_dev->status);
@@ -231,8 +235,9 @@ int adf_dev_start(struct adf_accel_dev *accel_dev)
 		if (!service->admin)
 			continue;
 		if (service->event_hld(accel_dev, ADF_EVENT_START)) {
-			pr_err("QAT: Failed to start service %s\n",
-			       service->name);
+			dev_err(&GET_DEV(accel_dev),
+				"Failed to start service %s\n",
+				service->name);
 			return -EFAULT;
 		}
 		set_bit(accel_dev->accel_id, &service->start_status);
@@ -242,8 +247,9 @@ int adf_dev_start(struct adf_accel_dev *accel_dev)
 		if (service->admin)
 			continue;
 		if (service->event_hld(accel_dev, ADF_EVENT_START)) {
-			pr_err("QAT: Failed to start service %s\n",
-			       service->name);
+			dev_err(&GET_DEV(accel_dev),
+				"Failed to start service %s\n",
+				service->name);
 			return -EFAULT;
 		}
 		set_bit(accel_dev->accel_id, &service->start_status);
@@ -253,7 +259,8 @@ int adf_dev_start(struct adf_accel_dev *accel_dev)
 	set_bit(ADF_STATUS_STARTED, &accel_dev->status);
 
 	if (qat_algs_register()) {
-		pr_err("QAT: Failed to register crypto algs\n");
+		dev_err(&GET_DEV(accel_dev),
+			"Failed to register crypto algs\n");
 		set_bit(ADF_STATUS_STARTING, &accel_dev->status);
 		clear_bit(ADF_STATUS_STARTED, &accel_dev->status);
 		return -EFAULT;
@@ -287,7 +294,8 @@ int adf_dev_stop(struct adf_accel_dev *accel_dev)
 	clear_bit(ADF_STATUS_STARTED, &accel_dev->status);
 
 	if (qat_algs_unregister())
-		pr_err("QAT: Failed to unregister crypto algs\n");
+		dev_err(&GET_DEV(accel_dev),
+			"Failed to unregister crypto algs\n");
 
 	list_for_each(list_itr, &service_table) {
 		service = list_entry(list_itr, struct service_hndl, list);
@@ -310,8 +318,9 @@ int adf_dev_stop(struct adf_accel_dev *accel_dev)
 		if (!test_bit(accel_dev->accel_id, &service->start_status))
 			continue;
 		if (service->event_hld(accel_dev, ADF_EVENT_STOP))
-			pr_err("QAT: Failed to shutdown service %s\n",
-			       service->name);
+			dev_err(&GET_DEV(accel_dev),
+				"Failed to shutdown service %s\n",
+				service->name);
 		else
 			clear_bit(accel_dev->accel_id, &service->start_status);
 	}
@@ -321,7 +330,7 @@ int adf_dev_stop(struct adf_accel_dev *accel_dev)
 
 	if (test_bit(ADF_STATUS_AE_STARTED, &accel_dev->status)) {
 		if (adf_ae_stop(accel_dev))
-			pr_err("QAT: failed to stop AE\n");
+			dev_err(&GET_DEV(accel_dev), "failed to stop AE\n");
 		else
 			clear_bit(ADF_STATUS_AE_STARTED, &accel_dev->status);
 	}
@@ -351,7 +360,8 @@ void adf_dev_shutdown(struct adf_accel_dev *accel_dev)
 
 	if (test_bit(ADF_STATUS_AE_UCODE_LOADED, &accel_dev->status)) {
 		if (adf_ae_fw_release(accel_dev))
-			pr_err("QAT: Failed to release the ucode\n");
+			dev_err(&GET_DEV(accel_dev),
+				"Failed to release the ucode\n");
 		else
 			clear_bit(ADF_STATUS_AE_UCODE_LOADED,
 				  &accel_dev->status);
@@ -359,7 +369,8 @@ void adf_dev_shutdown(struct adf_accel_dev *accel_dev)
 
 	if (test_bit(ADF_STATUS_AE_INITIALISED, &accel_dev->status)) {
 		if (adf_ae_shutdown(accel_dev))
-			pr_err("QAT: Failed to shutdown Accel Engine\n");
+			dev_err(&GET_DEV(accel_dev),
+				"Failed to shutdown Accel Engine\n");
 		else
 			clear_bit(ADF_STATUS_AE_INITIALISED,
 				  &accel_dev->status);
@@ -372,8 +383,9 @@ void adf_dev_shutdown(struct adf_accel_dev *accel_dev)
 		if (!test_bit(accel_dev->accel_id, &service->init_status))
 			continue;
 		if (service->event_hld(accel_dev, ADF_EVENT_SHUTDOWN))
-			pr_err("QAT: Failed to shutdown service %s\n",
-			       service->name);
+			dev_err(&GET_DEV(accel_dev),
+				"Failed to shutdown service %s\n",
+				service->name);
 		else
 			clear_bit(accel_dev->accel_id, &service->init_status);
 	}
@@ -384,8 +396,9 @@ void adf_dev_shutdown(struct adf_accel_dev *accel_dev)
 		if (!test_bit(accel_dev->accel_id, &service->init_status))
 			continue;
 		if (service->event_hld(accel_dev, ADF_EVENT_SHUTDOWN))
-			pr_err("QAT: Failed to shutdown service %s\n",
-			       service->name);
+			dev_err(&GET_DEV(accel_dev),
+				"Failed to shutdown service %s\n",
+				service->name);
 		else
 			clear_bit(accel_dev->accel_id, &service->init_status);
 	}
@@ -419,16 +432,18 @@ int adf_dev_restarting_notify(struct adf_accel_dev *accel_dev)
 		if (service->admin)
 			continue;
 		if (service->event_hld(accel_dev, ADF_EVENT_RESTARTING))
-			pr_err("QAT: Failed to restart service %s.\n",
-			       service->name);
+			dev_err(&GET_DEV(accel_dev),
+				"Failed to restart service %s.\n",
+				service->name);
 	}
 	list_for_each(list_itr, &service_table) {
 		service = list_entry(list_itr, struct service_hndl, list);
 		if (!service->admin)
 			continue;
 		if (service->event_hld(accel_dev, ADF_EVENT_RESTARTING))
-			pr_err("QAT: Failed to restart service %s.\n",
-			       service->name);
+			dev_err(&GET_DEV(accel_dev),
+				"Failed to restart service %s.\n",
+				service->name);
 	}
 	return 0;
 }
@@ -443,16 +458,18 @@ int adf_dev_restarted_notify(struct adf_accel_dev *accel_dev)
 		if (service->admin)
 			continue;
 		if (service->event_hld(accel_dev, ADF_EVENT_RESTARTED))
-			pr_err("QAT: Failed to restart service %s.\n",
-			       service->name);
+			dev_err(&GET_DEV(accel_dev),
+				"Failed to restart service %s.\n",
+				service->name);
 	}
 	list_for_each(list_itr, &service_table) {
 		service = list_entry(list_itr, struct service_hndl, list);
 		if (!service->admin)
 			continue;
 		if (service->event_hld(accel_dev, ADF_EVENT_RESTARTED))
-			pr_err("QAT: Failed to restart service %s.\n",
-			       service->name);
+			dev_err(&GET_DEV(accel_dev),
+				"Failed to restart service %s.\n",
+				service->name);
 	}
 	return 0;
 }
diff --git a/drivers/crypto/qat/qat_common/adf_transport.c b/drivers/crypto/qat/qat_common/adf_transport.c
index 7dd54aa..ccec3274 100644
--- a/drivers/crypto/qat/qat_common/adf_transport.c
+++ b/drivers/crypto/qat/qat_common/adf_transport.c
@@ -195,7 +195,7 @@ static int adf_init_ring(struct adf_etr_ring_data *ring)
 	memset(ring->base_addr, 0x7F, ring_size_bytes);
 	/* The base_addr has to be aligned to the size of the buffer */
 	if (adf_check_ring_alignment(ring->dma_addr, ring_size_bytes)) {
-		pr_err("QAT: Ring address not aligned\n");
+		dev_err(&GET_DEV(accel_dev), "Ring address not aligned\n");
 		dma_free_coherent(&GET_DEV(accel_dev), ring_size_bytes,
 				  ring->base_addr, ring->dma_addr);
 		return -EFAULT;
@@ -242,32 +242,33 @@ int adf_create_ring(struct adf_accel_dev *accel_dev, const char *section,
 	int ret;
 
 	if (bank_num >= GET_MAX_BANKS(accel_dev)) {
-		pr_err("QAT: Invalid bank number\n");
+		dev_err(&GET_DEV(accel_dev), "Invalid bank number\n");
 		return -EFAULT;
 	}
 	if (msg_size > ADF_MSG_SIZE_TO_BYTES(ADF_MAX_MSG_SIZE)) {
-		pr_err("QAT: Invalid msg size\n");
+		dev_err(&GET_DEV(accel_dev), "Invalid msg size\n");
 		return -EFAULT;
 	}
 	if (ADF_MAX_INFLIGHTS(adf_verify_ring_size(msg_size, num_msgs),
 			      ADF_BYTES_TO_MSG_SIZE(msg_size)) < 2) {
-		pr_err("QAT: Invalid ring size for given msg size\n");
+		dev_err(&GET_DEV(accel_dev),
+			"Invalid ring size for given msg size\n");
 		return -EFAULT;
 	}
 	if (adf_cfg_get_param_value(accel_dev, section, ring_name, val)) {
-		pr_err("QAT: Section %s, no such entry : %s\n",
-		       section, ring_name);
+		dev_err(&GET_DEV(accel_dev), "Section %s, no such entry : %s\n",
+			section, ring_name);
 		return -EFAULT;
 	}
 	if (kstrtouint(val, 10, &ring_num)) {
-		pr_err("QAT: Can't get ring number\n");
+		dev_err(&GET_DEV(accel_dev), "Can't get ring number\n");
 		return -EFAULT;
 	}
 
 	bank = &transport_data->banks[bank_num];
 	if (adf_reserve_ring(bank, ring_num)) {
-		pr_err("QAT: Ring %d, %s already exists.\n",
-		       ring_num, ring_name);
+		dev_err(&GET_DEV(accel_dev), "Ring %d, %s already exists.\n",
+			ring_num, ring_name);
 		return -EFAULT;
 	}
 	ring = &bank->rings[ring_num];
@@ -287,7 +288,8 @@ int adf_create_ring(struct adf_accel_dev *accel_dev, const char *section,
 	accel_dev->hw_device->hw_arb_ring_enable(ring);
 
 	if (adf_ring_debugfs_add(ring, ring_name)) {
-		pr_err("QAT: Couldn't add ring debugfs entry\n");
+		dev_err(&GET_DEV(accel_dev),
+			"Couldn't add ring debugfs entry\n");
 		ret = -EFAULT;
 		goto err;
 	}
@@ -428,7 +430,8 @@ static int adf_init_bank(struct adf_accel_dev *accel_dev,
 				goto err;
 		} else {
 			if (i < hw_data->tx_rx_gap) {
-				pr_err("QAT: Invalid tx rings mask config\n");
+				dev_err(&GET_DEV(accel_dev),
+					"Invalid tx rings mask config\n");
 				goto err;
 			}
 			tx_ring = &bank->rings[i - hw_data->tx_rx_gap];
@@ -436,7 +439,8 @@ static int adf_init_bank(struct adf_accel_dev *accel_dev,
 		}
 	}
 	if (adf_bank_debugfs_add(bank)) {
-		pr_err("QAT: Failed to add bank debugfs entry\n");
+		dev_err(&GET_DEV(accel_dev),
+			"Failed to add bank debugfs entry\n");
 		goto err;
 	}
 
@@ -492,7 +496,8 @@ int adf_init_etr_data(struct adf_accel_dev *accel_dev)
 	etr_data->debug = debugfs_create_dir("transport",
 					     accel_dev->debugfs_dir);
 	if (!etr_data->debug) {
-		pr_err("QAT: Unable to create transport debugfs entry\n");
+		dev_err(&GET_DEV(accel_dev),
+			"Unable to create transport debugfs entry\n");
 		ret = -ENOENT;
 		goto err_bank_debug;
 	}
diff --git a/drivers/crypto/qat/qat_common/qat_crypto.c b/drivers/crypto/qat/qat_common/qat_crypto.c
index 828f2a6..f064a9f 100644
--- a/drivers/crypto/qat/qat_common/qat_crypto.c
+++ b/drivers/crypto/qat/qat_common/qat_crypto.c
@@ -116,7 +116,7 @@ struct qat_crypto_instance *qat_crypto_get_instance_node(int node)
 		accel_dev = NULL;
 	}
 	if (!accel_dev) {
-		pr_err("QAT: Could not find device on node %d\n", node);
+		pr_err("QAT: Could not find a device on node %d\n", node);
 		accel_dev = adf_devmgr_get_first();
 	}
 	if (!accel_dev || !adf_dev_started(accel_dev))
@@ -137,7 +137,8 @@ struct qat_crypto_instance *qat_crypto_get_instance_node(int node)
 		if (atomic_add_return(1, &inst_best->refctr) == 1) {
 			if (adf_dev_get(accel_dev)) {
 				atomic_dec(&inst_best->refctr);
-				pr_err("QAT: Could increment dev refctr\n");
+				dev_err(&GET_DEV(accel_dev),
+					"Could not increment dev refctr\n");
 				return NULL;
 			}
 		}
diff --git a/drivers/crypto/qat/qat_common/qat_hal.c b/drivers/crypto/qat/qat_common/qat_hal.c
index b818c19..8a02d51 100644
--- a/drivers/crypto/qat/qat_common/qat_hal.c
+++ b/drivers/crypto/qat/qat_common/qat_hal.c
@@ -718,7 +718,7 @@ int qat_hal_init(struct adf_accel_dev *accel_dev)
 	handle->hal_handle->ae_max_num = max_en_ae_id + 1;
 	/* take all AEs out of reset */
 	if (qat_hal_clr_reset(handle)) {
-		pr_err("QAT: qat_hal_clr_reset error\n");
+		dev_err(&GET_DEV(accel_dev), "qat_hal_clr_reset error\n");
 		goto out_err;
 	}
 	if (qat_hal_clear_gpr(handle))
diff --git a/drivers/crypto/qat/qat_dh895xcc/adf_admin.c b/drivers/crypto/qat/qat_dh895xcc/adf_admin.c
index 53c491b..e466606 100644
--- a/drivers/crypto/qat/qat_dh895xcc/adf_admin.c
+++ b/drivers/crypto/qat/qat_dh895xcc/adf_admin.c
@@ -93,7 +93,8 @@ int adf_put_admin_msg_sync(struct adf_accel_dev *accel_dev,
 		memcpy(out, admin->virt_addr + offset +
 		       ADF_ADMINMSG_LEN, ADF_ADMINMSG_LEN);
 	else
-		pr_err("QAT: Failed to send admin msg to accelerator\n");
+		dev_err(&GET_DEV(accel_dev),
+			"Failed to send admin msg to accelerator\n");
 
 	mutex_unlock(&admin->lock);
 	return received ? 0 : -EFAULT;
diff --git a/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c b/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
index 6a735d5..b138692 100644
--- a/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
+++ b/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
@@ -150,7 +150,8 @@ void adf_get_arbiter_mapping(struct adf_accel_dev *accel_dev,
 		*arb_map_config = thrd_to_arb_map_sku6;
 		break;
 	default:
-		pr_err("QAT: The configuration doesn't match any SKU");
+		dev_err(&GET_DEV(accel_dev),
+			"The configuration doesn't match any SKU");
 		*arb_map_config = NULL;
 	}
 }
diff --git a/drivers/crypto/qat/qat_dh895xcc/adf_isr.c b/drivers/crypto/qat/qat_dh895xcc/adf_isr.c
index fe8f896..0d03c10 100644
--- a/drivers/crypto/qat/qat_dh895xcc/adf_isr.c
+++ b/drivers/crypto/qat/qat_dh895xcc/adf_isr.c
@@ -73,7 +73,7 @@ static int adf_enable_msix(struct adf_accel_dev *accel_dev)
 	if (pci_enable_msix_exact(pci_dev_info->pci_dev,
 				  pci_dev_info->msix_entries.entries,
 				  msix_num_entries)) {
-		pr_err("QAT: Failed to enable MSIX IRQ\n");
+		dev_err(&GET_DEV(accel_dev), "Failed to enable MSIX IRQ\n");
 		return -EFAULT;
 	}
 	return 0;
@@ -97,7 +97,8 @@ static irqreturn_t adf_msix_isr_ae(int irq, void *dev_ptr)
 {
 	struct adf_accel_dev *accel_dev = dev_ptr;
 
-	pr_info("QAT: qat_dev%d spurious AE interrupt\n", accel_dev->accel_id);
+	dev_info(&GET_DEV(accel_dev), "qat_dev%d spurious AE interrupt\n",
+		 accel_dev->accel_id);
 	return IRQ_HANDLED;
 }
 
@@ -121,8 +122,9 @@ static int adf_request_irqs(struct adf_accel_dev *accel_dev)
 		ret = request_irq(msixe[i].vector,
 				  adf_msix_isr_bundle, 0, name, bank);
 		if (ret) {
-			pr_err("QAT: failed to enable irq %d for %s\n",
-			       msixe[i].vector, name);
+			dev_err(&GET_DEV(accel_dev),
+				"failed to enable irq %d for %s\n",
+				msixe[i].vector, name);
 			return ret;
 		}
 
@@ -136,8 +138,9 @@ static int adf_request_irqs(struct adf_accel_dev *accel_dev)
 		 "qat%d-ae-cluster", accel_dev->accel_id);
 	ret = request_irq(msixe[i].vector, adf_msix_isr_ae, 0, name, accel_dev);
 	if (ret) {
-		pr_err("QAT: failed to enable irq %d, for %s\n",
-		       msixe[i].vector, name);
+		dev_err(&GET_DEV(accel_dev),
+			"failed to enable irq %d, for %s\n",
+			msixe[i].vector, name);
 		return ret;
 	}
 	return ret;
