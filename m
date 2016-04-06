From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH v2] crypto: qat - adf_dev_stop should not be called in
 atomic context
Date: Wed, 06 Apr 2016 11:01:54 -0700
Message-ID: <20160406180154.8645.94988.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, tadeusz.struk@intel.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:40456 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751751AbcDFSH6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 6 Apr 2016 14:07:58 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

VFs call adf_dev_stop() from a PF to VF interrupt bottom half.
This causes an oops "scheduling while atomic", because it tries
to acquire a mutex to un-register crypto algorithms.
This patch fixes the issue by calling adf_dev_stop() asynchronously.

Changes in v2:
 - change kthread to a work queue.

Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 drivers/crypto/qat/qat_common/adf_common_drv.h |    2 +
 drivers/crypto/qat/qat_common/adf_ctl_drv.c    |    6 ++
 drivers/crypto/qat/qat_common/adf_vf_isr.c     |   59 +++++++++++++++++++++++-
 3 files changed, 64 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_common_drv.h b/drivers/crypto/qat/qat_common/adf_common_drv.h
index c9e4d46..fd096ed 100644
--- a/drivers/crypto/qat/qat_common/adf_common_drv.h
+++ b/drivers/crypto/qat/qat_common/adf_common_drv.h
@@ -144,6 +144,8 @@ void adf_disable_aer(struct adf_accel_dev *accel_dev);
 void adf_dev_restore(struct adf_accel_dev *accel_dev);
 int adf_init_aer(void);
 void adf_exit_aer(void);
+int adf_init_vf_wq(void);
+void adf_exit_vf_wq(void);
 int adf_init_admin_comms(struct adf_accel_dev *accel_dev);
 void adf_exit_admin_comms(struct adf_accel_dev *accel_dev);
 int adf_send_admin_init(struct adf_accel_dev *accel_dev);
diff --git a/drivers/crypto/qat/qat_common/adf_ctl_drv.c b/drivers/crypto/qat/qat_common/adf_ctl_drv.c
index 48a1248..116ddda 100644
--- a/drivers/crypto/qat/qat_common/adf_ctl_drv.c
+++ b/drivers/crypto/qat/qat_common/adf_ctl_drv.c
@@ -471,12 +471,17 @@ static int __init adf_register_ctl_device_driver(void)
 	if (adf_init_aer())
 		goto err_aer;
 
+	if (adf_init_vf_wq())
+		goto err_vf_wq;
+
 	if (qat_crypto_register())
 		goto err_crypto_register;
 
 	return 0;
 
 err_crypto_register:
+	adf_exit_vf_wq();
+err_vf_wq:
 	adf_exit_aer();
 err_aer:
 	adf_chr_drv_destroy();
@@ -489,6 +494,7 @@ static void __exit adf_unregister_ctl_device_driver(void)
 {
 	adf_chr_drv_destroy();
 	adf_exit_aer();
+	adf_exit_vf_wq();
 	qat_crypto_unregister();
 	adf_clean_vf_map(false);
 	mutex_destroy(&adf_ctl_lock);
diff --git a/drivers/crypto/qat/qat_common/adf_vf_isr.c b/drivers/crypto/qat/qat_common/adf_vf_isr.c
index 09427b3..c3d5016 100644
--- a/drivers/crypto/qat/qat_common/adf_vf_isr.c
+++ b/drivers/crypto/qat/qat_common/adf_vf_isr.c
@@ -51,6 +51,7 @@
 #include <linux/slab.h>
 #include <linux/errno.h>
 #include <linux/interrupt.h>
+#include <linux/workqueue.h>
 #include "adf_accel_devices.h"
 #include "adf_common_drv.h"
 #include "adf_cfg.h"
@@ -64,6 +65,13 @@
 #define ADF_VINTSOU_BUN		BIT(0)
 #define ADF_VINTSOU_PF2VF	BIT(1)
 
+static struct workqueue_struct *adf_vf_stop_wq;
+
+struct adf_vf_stop_data {
+	struct adf_accel_dev *accel_dev;
+	struct work_struct work;
+};
+
 static int adf_enable_msi(struct adf_accel_dev *accel_dev)
 {
 	struct adf_accel_pci *pci_dev_info = &accel_dev->accel_pci_dev;
@@ -90,6 +98,20 @@ static void adf_disable_msi(struct adf_accel_dev *accel_dev)
 	pci_disable_msi(pdev);
 }
 
+static void adf_dev_stop_async(struct work_struct *work)
+{
+	struct adf_vf_stop_data *stop_data =
+		container_of(work, struct adf_vf_stop_data, work);
+	struct adf_accel_dev *accel_dev = stop_data->accel_dev;
+
+	adf_dev_stop(accel_dev);
+	adf_dev_shutdown(accel_dev);
+
+	/* Re-enable PF2VF interrupts */
+	adf_enable_pf2vf_interrupts(accel_dev);
+	kfree(stop_data);
+}
+
 static void adf_pf2vf_bh_handler(void *data)
 {
 	struct adf_accel_dev *accel_dev = data;
@@ -107,11 +129,27 @@ static void adf_pf2vf_bh_handler(void *data)
 		goto err;
 
 	switch ((msg & ADF_PF2VF_MSGTYPE_MASK) >> ADF_PF2VF_MSGTYPE_SHIFT) {
-	case ADF_PF2VF_MSGTYPE_RESTARTING:
+	case ADF_PF2VF_MSGTYPE_RESTARTING: {
+		struct adf_vf_stop_data *stop_data;
+
 		dev_dbg(&GET_DEV(accel_dev),
 			"Restarting msg received from PF 0x%x\n", msg);
-		adf_dev_stop(accel_dev);
-		break;
+
+		stop_data = kzalloc(sizeof(*stop_data), GFP_ATOMIC);
+		if (!stop_data) {
+			dev_err(&GET_DEV(accel_dev),
+				"Couldn't schedule stop for vf_%d\n",
+				accel_dev->accel_id);
+			return;
+		}
+		stop_data->accel_dev = accel_dev;
+		INIT_WORK(&stop_data->work, adf_dev_stop_async);
+		queue_work(adf_vf_stop_wq, &stop_data->work);
+		/* To ack, clear the PF2VFINT bit */
+		msg &= ~BIT(0);
+		ADF_CSR_WR(pmisc_bar_addr, hw_data->get_pf2vf_offset(0), msg);
+		return;
+	}
 	case ADF_PF2VF_MSGTYPE_VERSION_RESP:
 		dev_dbg(&GET_DEV(accel_dev),
 			"Version resp received from PF 0x%x\n", msg);
@@ -278,3 +316,18 @@ err_out:
 	return -EFAULT;
 }
 EXPORT_SYMBOL_GPL(adf_vf_isr_resource_alloc);
+
+int __init adf_init_vf_wq(void)
+{
+	adf_vf_stop_wq = create_workqueue("adf_vf_stop_wq");
+
+	return !adf_vf_stop_wq ? -EFAULT : 0;
+}
+
+void __exit adf_exit_vf_wq(void)
+{
+	if (adf_vf_stop_wq)
+		destroy_workqueue(adf_vf_stop_wq);
+
+	adf_vf_stop_wq = NULL;
+}
