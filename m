From: Bruce Allan <bruce.w.allan@intel.com>
Subject: [PATCH] crypto: qat - fix device reset flow
Date: Fri, 09 Jan 2015 11:54:58 -0800
Message-ID: <20150109195457.28205.23092.stgit@gitlad.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:39582 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751625AbbAITyc (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 9 Jan 2015 14:54:32 -0500
Received: from gitlad.jf.intel.com (gitlad.jf.intel.com [127.0.0.1])
	by gitlad.jf.intel.com (8.14.2/8.14.2) with ESMTP id t09Jsw75028238
	for <linux-crypto@vger.kernel.org>; Fri, 9 Jan 2015 11:54:58 -0800
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

When the device needs a reset, e.g. when an uncorrectable PCIe AER event
occurs, various services/data structures need to be cleaned up, the
hardware reset and the services/data structures initialized and started.
The code to perform the cleanup and initialization was not performed when
a device reset was done.

This patch moves some of the initialization code out of the .probe entry-
point into a separate function that is now called during probe as well as
after the hardware has been reset.  Similarly, a new function is added for
first cleaning up these services/data structures prior to resetting.  The
new functions are adf_dev_init() and adf_dev_shutdown(), respectively, for
which there are already prototypes but no actual functions just yet and are
now called when the device is reset and during probe/cleanup of the driver.
The down and up flows via ioctl calls has similarly been updated.

In addition, there are two other bugs in the reset flow - one in the logic
for determining whether to schedule a device reset upon receiving an
uncorrectable AER event which prevents the reset flow from being initiated,
and another with clearing the status bit indicating a device is configured
(when resetting the device the configuration remains across the reset so
the bit should not be cleared, otherwise, the necessary services will not
be re-started in adf_dev_start() after the reset - clear the bit only when
actually deleting the configuration).

Signed-off-by: Bruce Allan <bruce.w.allan@intel.com>
---

 drivers/crypto/qat/qat_common/adf_accel_devices.h  |    5 +
 drivers/crypto/qat/qat_common/adf_aer.c            |    7 +-
 drivers/crypto/qat/qat_common/adf_cfg.c            |    2 
 drivers/crypto/qat/qat_common/adf_common_drv.h     |    2 
 drivers/crypto/qat/qat_common/adf_ctl_drv.c        |    7 +-
 drivers/crypto/qat/qat_common/adf_init.c           |   91 ++++++++++++++++++--
 .../crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c |   19 ++++
 drivers/crypto/qat/qat_dh895xcc/adf_drv.c          |   42 ++-------
 8 files changed, 128 insertions(+), 47 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_accel_devices.h b/drivers/crypto/qat/qat_common/adf_accel_devices.h
index 2ed4256..ed226ce 100644
--- a/drivers/crypto/qat/qat_common/adf_accel_devices.h
+++ b/drivers/crypto/qat/qat_common/adf_accel_devices.h
@@ -148,6 +148,11 @@ struct adf_hw_device_data {
 	int (*alloc_irq)(struct adf_accel_dev *accel_dev);
 	void (*free_irq)(struct adf_accel_dev *accel_dev);
 	void (*enable_error_correction)(struct adf_accel_dev *accel_dev);
+	int (*init_admin_comms)(struct adf_accel_dev *accel_dev);
+	void (*exit_admin_comms)(struct adf_accel_dev *accel_dev);
+	int (*init_arb)(struct adf_accel_dev *accel_dev);
+	void (*exit_arb)(struct adf_accel_dev *accel_dev);
+	void (*enable_ints)(struct adf_accel_dev *accel_dev);
 	const char *fw_name;
 	uint32_t pci_dev_id;
 	uint32_t fuses;
diff --git a/drivers/crypto/qat/qat_common/adf_aer.c b/drivers/crypto/qat/qat_common/adf_aer.c
index 10ce4a2..740dc9e 100644
--- a/drivers/crypto/qat/qat_common/adf_aer.c
+++ b/drivers/crypto/qat/qat_common/adf_aer.c
@@ -125,8 +125,9 @@ static void adf_device_reset_worker(struct work_struct *work)
 
 	adf_dev_restarting_notify(accel_dev);
 	adf_dev_stop(accel_dev);
+	adf_dev_shutdown(accel_dev);
 	adf_dev_restore(accel_dev);
-	if (adf_dev_start(accel_dev)) {
+	if (adf_dev_init(accel_dev) || adf_dev_start(accel_dev)) {
 		/* The device hanged and we can't restart it so stop here */
 		dev_err(&GET_DEV(accel_dev), "Restart device failed\n");
 		kfree(reset_data);
@@ -148,8 +149,8 @@ static int adf_dev_aer_schedule_reset(struct adf_accel_dev *accel_dev,
 {
 	struct adf_reset_dev_data *reset_data;
 
-	if (adf_dev_started(accel_dev) &&
-	    !test_bit(ADF_STATUS_RESTARTING, &accel_dev->status))
+	if (!adf_dev_started(accel_dev) ||
+	    test_bit(ADF_STATUS_RESTARTING, &accel_dev->status))
 		return 0;
 
 	set_bit(ADF_STATUS_RESTARTING, &accel_dev->status);
diff --git a/drivers/crypto/qat/qat_common/adf_cfg.c b/drivers/crypto/qat/qat_common/adf_cfg.c
index aba7f1d..de16da9 100644
--- a/drivers/crypto/qat/qat_common/adf_cfg.c
+++ b/drivers/crypto/qat/qat_common/adf_cfg.c
@@ -50,6 +50,7 @@
 #include <linux/seq_file.h>
 #include "adf_accel_devices.h"
 #include "adf_cfg.h"
+#include "adf_common_drv.h"
 
 static DEFINE_MUTEX(qat_cfg_read_lock);
 
@@ -159,6 +160,7 @@ void adf_cfg_del_all(struct adf_accel_dev *accel_dev)
 	down_write(&dev_cfg_data->lock);
 	adf_cfg_section_del_all(&dev_cfg_data->sec_list);
 	up_write(&dev_cfg_data->lock);
+	clear_bit(ADF_STATUS_CONFIGURED, &accel_dev->status);
 }
 
 /**
diff --git a/drivers/crypto/qat/qat_common/adf_common_drv.h b/drivers/crypto/qat/qat_common/adf_common_drv.h
index 5e8f9d4..a62e485 100644
--- a/drivers/crypto/qat/qat_common/adf_common_drv.h
+++ b/drivers/crypto/qat/qat_common/adf_common_drv.h
@@ -93,7 +93,7 @@ int adf_service_unregister(struct service_hndl *service);
 int adf_dev_init(struct adf_accel_dev *accel_dev);
 int adf_dev_start(struct adf_accel_dev *accel_dev);
 int adf_dev_stop(struct adf_accel_dev *accel_dev);
-int adf_dev_shutdown(struct adf_accel_dev *accel_dev);
+void adf_dev_shutdown(struct adf_accel_dev *accel_dev);
 
 int adf_ctl_dev_register(void);
 void adf_ctl_dev_unregister(void);
diff --git a/drivers/crypto/qat/qat_common/adf_ctl_drv.c b/drivers/crypto/qat/qat_common/adf_ctl_drv.c
index 7ee93f8..74207a6 100644
--- a/drivers/crypto/qat/qat_common/adf_ctl_drv.c
+++ b/drivers/crypto/qat/qat_common/adf_ctl_drv.c
@@ -282,6 +282,8 @@ static int adf_ctl_stop_devices(uint32_t id)
 			if (adf_dev_stop(accel_dev)) {
 				pr_err("QAT: Failed to stop qat_dev%d\n", id);
 				ret = -EFAULT;
+			} else {
+				adf_dev_shutdown(accel_dev);
 			}
 		}
 	}
@@ -343,7 +345,9 @@ static int adf_ctl_ioctl_dev_start(struct file *fp, unsigned int cmd,
 	if (!adf_dev_started(accel_dev)) {
 		pr_info("QAT: Starting acceleration device qat_dev%d.\n",
 			ctl_data->device_id);
-		ret = adf_dev_start(accel_dev);
+		ret = adf_dev_init(accel_dev);
+		if (!ret)
+			ret = adf_dev_start(accel_dev);
 	} else {
 		pr_info("QAT: Acceleration device qat_dev%d already started.\n",
 			ctl_data->device_id);
@@ -351,6 +355,7 @@ static int adf_ctl_ioctl_dev_start(struct file *fp, unsigned int cmd,
 	if (ret) {
 		pr_err("QAT: Failed to start qat_dev%d\n", ctl_data->device_id);
 		adf_dev_stop(accel_dev);
+		adf_dev_shutdown(accel_dev);
 	}
 out:
 	kfree(ctl_data);
diff --git a/drivers/crypto/qat/qat_common/adf_init.c b/drivers/crypto/qat/qat_common/adf_init.c
index 5c0e47a..a3afa0f 100644
--- a/drivers/crypto/qat/qat_common/adf_init.c
+++ b/drivers/crypto/qat/qat_common/adf_init.c
@@ -108,26 +108,47 @@ int adf_service_unregister(struct service_hndl *service)
 EXPORT_SYMBOL_GPL(adf_service_unregister);
 
 /**
- * adf_dev_start() - Start acceleration service for the given accel device
- * @accel_dev:    Pointer to acceleration device.
+ * adf_dev_init() - Init data structures and services for the given accel device
+ * @accel_dev: Pointer to acceleration device.
  *
- * Function notifies all the registered services that the acceleration device
- * is ready to be used.
- * To be used by QAT device specific drivers.
+ * Initialize the ring data structures and the admin comms and arbitration
+ * services.
  *
  * Return: 0 on success, error code othewise.
  */
-int adf_dev_start(struct adf_accel_dev *accel_dev)
+int adf_dev_init(struct adf_accel_dev *accel_dev)
 {
 	struct service_hndl *service;
 	struct list_head *list_itr;
 	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
 
+	if (!hw_data) {
+		dev_err(&GET_DEV(accel_dev),
+			"QAT: Failed to init device - hw_data not set\n");
+		return -EFAULT;
+	}
+
 	if (!test_bit(ADF_STATUS_CONFIGURED, &accel_dev->status)) {
 		pr_info("QAT: Device not configured\n");
 		return -EFAULT;
 	}
-	set_bit(ADF_STATUS_STARTING, &accel_dev->status);
+
+	if (adf_init_etr_data(accel_dev)) {
+		dev_err(&GET_DEV(accel_dev), "Failed initialize etr\n");
+		return -EFAULT;
+	}
+
+	if (hw_data->init_admin_comms && hw_data->init_admin_comms(accel_dev)) {
+		dev_err(&GET_DEV(accel_dev), "Failed initialize admin comms\n");
+		return -EFAULT;
+	}
+
+	if (hw_data->init_arb && hw_data->init_arb(accel_dev)) {
+		dev_err(&GET_DEV(accel_dev), "Failed initialize hw arbiter\n");
+		return -EFAULT;
+	}
+
+	hw_data->enable_ints(accel_dev);
 
 	if (adf_ae_init(accel_dev)) {
 		pr_err("QAT: Failed to initialise Acceleration Engine\n");
@@ -178,6 +199,27 @@ int adf_dev_start(struct adf_accel_dev *accel_dev)
 
 	hw_data->enable_error_correction(accel_dev);
 
+	return 0;
+}
+EXPORT_SYMBOL_GPL(adf_dev_init);
+
+/**
+ * adf_dev_start() - Start acceleration service for the given accel device
+ * @accel_dev:    Pointer to acceleration device.
+ *
+ * Function notifies all the registered services that the acceleration device
+ * is ready to be used.
+ * To be used by QAT device specific drivers.
+ *
+ * Return: 0 on success, error code othewise.
+ */
+int adf_dev_start(struct adf_accel_dev *accel_dev)
+{
+	struct service_hndl *service;
+	struct list_head *list_itr;
+
+	set_bit(ADF_STATUS_STARTING, &accel_dev->status);
+
 	if (adf_ae_start(accel_dev)) {
 		pr_err("QAT: AE Start Failed\n");
 		return -EFAULT;
@@ -232,7 +274,6 @@ EXPORT_SYMBOL_GPL(adf_dev_start);
  */
 int adf_dev_stop(struct adf_accel_dev *accel_dev)
 {
-	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
 	struct service_hndl *service;
 	struct list_head *list_itr;
 	int ret, wait = 0;
@@ -241,7 +282,6 @@ int adf_dev_stop(struct adf_accel_dev *accel_dev)
 	    !test_bit(ADF_STATUS_STARTING, &accel_dev->status)) {
 		return 0;
 	}
-	clear_bit(ADF_STATUS_CONFIGURED, &accel_dev->status);
 	clear_bit(ADF_STATUS_STARTING, &accel_dev->status);
 	clear_bit(ADF_STATUS_STARTED, &accel_dev->status);
 
@@ -285,6 +325,29 @@ int adf_dev_stop(struct adf_accel_dev *accel_dev)
 			clear_bit(ADF_STATUS_AE_STARTED, &accel_dev->status);
 	}
 
+	return 0;
+}
+EXPORT_SYMBOL_GPL(adf_dev_stop);
+
+/**
+ * adf_dev_shutdown() - shutdown acceleration services and data strucutures
+ * @accel_dev: Pointer to acceleration device
+ *
+ * Cleanup the ring data structures and the admin comms and arbitration
+ * services.
+ */
+void adf_dev_shutdown(struct adf_accel_dev *accel_dev)
+{
+	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
+	struct service_hndl *service;
+	struct list_head *list_itr;
+
+	if (!hw_data) {
+		dev_err(&GET_DEV(accel_dev),
+			"QAT: Failed to shutdown device - hw_data not set\n");
+		return;
+	}
+
 	if (test_bit(ADF_STATUS_AE_UCODE_LOADED, &accel_dev->status)) {
 		if (adf_ae_fw_release(accel_dev))
 			pr_err("QAT: Failed to release the ucode\n");
@@ -335,9 +398,15 @@ int adf_dev_stop(struct adf_accel_dev *accel_dev)
 	if (!test_bit(ADF_STATUS_RESTARTING, &accel_dev->status))
 		adf_cfg_del_all(accel_dev);
 
-	return 0;
+	if (hw_data->exit_arb)
+		hw_data->exit_arb(accel_dev);
+
+	if (hw_data->exit_admin_comms)
+		hw_data->exit_admin_comms(accel_dev);
+
+	adf_cleanup_etr_data(accel_dev);
 }
-EXPORT_SYMBOL_GPL(adf_dev_stop);
+EXPORT_SYMBOL_GPL(adf_dev_shutdown);
 
 int adf_dev_restarting_notify(struct adf_accel_dev *accel_dev)
 {
diff --git a/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c b/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
index ef05825..6a735d5 100644
--- a/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
+++ b/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
@@ -46,6 +46,7 @@
 */
 #include <adf_accel_devices.h>
 #include "adf_dh895xcc_hw_data.h"
+#include "adf_common_drv.h"
 #include "adf_drv.h"
 
 /* Worker thread to service arbiter mappings based on dev SKUs */
@@ -182,6 +183,19 @@ static void adf_enable_error_correction(struct adf_accel_dev *accel_dev)
 	}
 }
 
+static void adf_enable_ints(struct adf_accel_dev *accel_dev)
+{
+	void __iomem *addr;
+
+	addr = (&GET_BARS(accel_dev)[ADF_DH895XCC_PMISC_BAR])->virt_addr;
+
+	/* Enable bundle and misc interrupts */
+	ADF_CSR_WR(addr, ADF_DH895XCC_SMIAPF0_MASK_OFFSET,
+		   ADF_DH895XCC_SMIA0_MASK);
+	ADF_CSR_WR(addr, ADF_DH895XCC_SMIAPF1_MASK_OFFSET,
+		   ADF_DH895XCC_SMIA1_MASK);
+}
+
 void adf_init_hw_data_dh895xcc(struct adf_hw_device_data *hw_data)
 {
 	hw_data->dev_class = &dh895xcc_class;
@@ -206,6 +220,11 @@ void adf_init_hw_data_dh895xcc(struct adf_hw_device_data *hw_data)
 	hw_data->get_misc_bar_id = get_misc_bar_id;
 	hw_data->get_sku = get_sku;
 	hw_data->fw_name = ADF_DH895XCC_FW;
+	hw_data->init_admin_comms = adf_init_admin_comms;
+	hw_data->exit_admin_comms = adf_exit_admin_comms;
+	hw_data->init_arb = adf_init_arb;
+	hw_data->exit_arb = adf_exit_arb;
+	hw_data->enable_ints = adf_enable_ints;
 }
 
 void adf_clean_hw_data_dh895xcc(struct adf_hw_device_data *hw_data)
diff --git a/drivers/crypto/qat/qat_dh895xcc/adf_drv.c b/drivers/crypto/qat/qat_dh895xcc/adf_drv.c
index 948f66b..8ffdb95 100644
--- a/drivers/crypto/qat/qat_dh895xcc/adf_drv.c
+++ b/drivers/crypto/qat/qat_dh895xcc/adf_drv.c
@@ -90,9 +90,7 @@ static void adf_cleanup_accel(struct adf_accel_dev *accel_dev)
 	struct adf_accel_pci *accel_pci_dev = &accel_dev->accel_pci_dev;
 	int i;
 
-	adf_exit_admin_comms(accel_dev);
-	adf_exit_arb(accel_dev);
-	adf_cleanup_etr_data(accel_dev);
+	adf_dev_shutdown(accel_dev);
 
 	for (i = 0; i < ADF_PCI_MAX_BARS; i++) {
 		struct adf_bar *bar = &accel_pci_dev->pci_bars[i];
@@ -119,7 +117,7 @@ static void adf_cleanup_accel(struct adf_accel_dev *accel_dev)
 	kfree(accel_dev);
 }
 
-static int qat_dev_start(struct adf_accel_dev *accel_dev)
+static int adf_dev_configure(struct adf_accel_dev *accel_dev)
 {
 	int cpus = num_online_cpus();
 	int banks = GET_MAX_BANKS(accel_dev);
@@ -206,7 +204,7 @@ static int qat_dev_start(struct adf_accel_dev *accel_dev)
 		goto err;
 
 	set_bit(ADF_STATUS_CONFIGURED, &accel_dev->status);
-	return adf_dev_start(accel_dev);
+	return 0;
 err:
 	dev_err(&GET_DEV(accel_dev), "Failed to start QAT accel dev\n");
 	return -EINVAL;
@@ -217,7 +215,6 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	struct adf_accel_dev *accel_dev;
 	struct adf_accel_pci *accel_pci_dev;
 	struct adf_hw_device_data *hw_data;
-	void __iomem *pmisc_bar_addr = NULL;
 	char name[ADF_DEVICE_NAME_LENGTH];
 	unsigned int i, bar_nr;
 	int ret;
@@ -347,8 +344,6 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 			ret = -EFAULT;
 			goto out_err;
 		}
-		if (i == ADF_DH895XCC_PMISC_BAR)
-			pmisc_bar_addr = bar->virt_addr;
 	}
 	pci_set_master(pdev);
 
@@ -358,36 +353,21 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto out_err;
 	}
 
-	if (adf_init_etr_data(accel_dev)) {
-		dev_err(&pdev->dev, "Failed initialize etr\n");
-		ret = -EFAULT;
-		goto out_err;
-	}
-
-	if (adf_init_admin_comms(accel_dev)) {
-		dev_err(&pdev->dev, "Failed initialize admin comms\n");
-		ret = -EFAULT;
-		goto out_err;
-	}
-
-	if (adf_init_arb(accel_dev)) {
-		dev_err(&pdev->dev, "Failed initialize hw arbiter\n");
-		ret = -EFAULT;
-		goto out_err;
-	}
 	if (pci_save_state(pdev)) {
 		dev_err(&pdev->dev, "Failed to save pci state\n");
 		ret = -ENOMEM;
 		goto out_err;
 	}
 
-	/* Enable bundle and misc interrupts */
-	ADF_CSR_WR(pmisc_bar_addr, ADF_DH895XCC_SMIAPF0_MASK_OFFSET,
-		   ADF_DH895XCC_SMIA0_MASK);
-	ADF_CSR_WR(pmisc_bar_addr, ADF_DH895XCC_SMIAPF1_MASK_OFFSET,
-		   ADF_DH895XCC_SMIA1_MASK);
+	ret = adf_dev_configure(accel_dev);
+	if (ret)
+		goto out_err;
+
+	ret = adf_dev_init(accel_dev);
+	if (ret)
+		goto out_err;
 
-	ret = qat_dev_start(accel_dev);
+	ret = adf_dev_start(accel_dev);
 	if (ret) {
 		adf_dev_stop(accel_dev);
 		goto out_err;
