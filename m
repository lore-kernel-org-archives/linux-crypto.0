From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH 2/3] crypto: qat - check if PF is running
Date: Fri, 15 Apr 2016 10:37:59 -0700
Message-ID: <1460741880-9479-2-git-send-email-tadeusz.struk@intel.com>
Cc: <tadeusz.struk@intel.com>,
	<sumanx.bangalore.sathyanarayana@intel.com>,
	<linux-crypto@vger.kernel.org>
To: <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:61146 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752596AbcDORnQ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 15 Apr 2016 13:43:16 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Before VF sends a signal to PF it should check if PF
is still running.

Tested-by: Suman Bangalore Sathyanarayana <sumanx.bangalore.sathyanarayana@intel.com>
Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 drivers/crypto/qat/qat_c3xxxvf/adf_drv.c       | 2 ++
 drivers/crypto/qat/qat_c62xvf/adf_drv.c        | 2 ++
 drivers/crypto/qat/qat_common/adf_common_drv.h | 2 +-
 drivers/crypto/qat/qat_common/adf_vf2pf_msg.c  | 8 +++++---
 drivers/crypto/qat/qat_common/adf_vf_isr.c     | 2 ++
 drivers/crypto/qat/qat_dh895xccvf/adf_drv.c    | 2 ++
 6 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/qat/qat_c3xxxvf/adf_drv.c b/drivers/crypto/qat/qat_c3xxxvf/adf_drv.c
index a998981..949d77b 100644
--- a/drivers/crypto/qat/qat_c3xxxvf/adf_drv.c
+++ b/drivers/crypto/qat/qat_c3xxxvf/adf_drv.c
@@ -238,6 +238,8 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (ret)
 		goto out_err_free_reg;
 
+	set_bit(ADF_STATUS_PF_RUNNING, &accel_dev->status);
+
 	ret = adf_dev_init(accel_dev);
 	if (ret)
 		goto out_err_dev_shutdown;
diff --git a/drivers/crypto/qat/qat_c62xvf/adf_drv.c b/drivers/crypto/qat/qat_c62xvf/adf_drv.c
index ccfb25e..7540ce1 100644
--- a/drivers/crypto/qat/qat_c62xvf/adf_drv.c
+++ b/drivers/crypto/qat/qat_c62xvf/adf_drv.c
@@ -238,6 +238,8 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (ret)
 		goto out_err_free_reg;
 
+	set_bit(ADF_STATUS_PF_RUNNING, &accel_dev->status);
+
 	ret = adf_dev_init(accel_dev);
 	if (ret)
 		goto out_err_dev_shutdown;
diff --git a/drivers/crypto/qat/qat_common/adf_common_drv.h b/drivers/crypto/qat/qat_common/adf_common_drv.h
index a8100a3..557ea36 100644
--- a/drivers/crypto/qat/qat_common/adf_common_drv.h
+++ b/drivers/crypto/qat/qat_common/adf_common_drv.h
@@ -67,7 +67,7 @@
 #define ADF_STATUS_AE_INITIALISED 4
 #define ADF_STATUS_AE_UCODE_LOADED 5
 #define ADF_STATUS_AE_STARTED 6
-#define ADF_STATUS_ORPHAN_TH_RUNNING 7
+#define ADF_STATUS_PF_RUNNING 7
 #define ADF_STATUS_IRQ_ALLOCATED 8
 
 enum adf_dev_reset_mode {
diff --git a/drivers/crypto/qat/qat_common/adf_vf2pf_msg.c b/drivers/crypto/qat/qat_common/adf_vf2pf_msg.c
index 5f1d863..cd5f37d 100644
--- a/drivers/crypto/qat/qat_common/adf_vf2pf_msg.c
+++ b/drivers/crypto/qat/qat_common/adf_vf2pf_msg.c
@@ -66,6 +66,7 @@ int adf_vf2pf_init(struct adf_accel_dev *accel_dev)
 			"Failed to send Init event to PF\n");
 		return -EFAULT;
 	}
+	set_bit(ADF_STATUS_PF_RUNNING, &accel_dev->status);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(adf_vf2pf_init);
@@ -83,8 +84,9 @@ void adf_vf2pf_shutdown(struct adf_accel_dev *accel_dev)
 	u32 msg = (ADF_VF2PF_MSGORIGIN_SYSTEM |
 	    (ADF_VF2PF_MSGTYPE_SHUTDOWN << ADF_VF2PF_MSGTYPE_SHIFT));
 
-	if (adf_iov_putmsg(accel_dev, msg, 0))
-		dev_err(&GET_DEV(accel_dev),
-			"Failed to send Shutdown event to PF\n");
+	if (test_bit(ADF_STATUS_PF_RUNNING, &accel_dev->status))
+		if (adf_iov_putmsg(accel_dev, msg, 0))
+			dev_err(&GET_DEV(accel_dev),
+				"Failed to send Shutdown event to PF\n");
 }
 EXPORT_SYMBOL_GPL(adf_vf2pf_shutdown);
diff --git a/drivers/crypto/qat/qat_common/adf_vf_isr.c b/drivers/crypto/qat/qat_common/adf_vf_isr.c
index c3d5016..5d45796 100644
--- a/drivers/crypto/qat/qat_common/adf_vf_isr.c
+++ b/drivers/crypto/qat/qat_common/adf_vf_isr.c
@@ -135,6 +135,8 @@ static void adf_pf2vf_bh_handler(void *data)
 		dev_dbg(&GET_DEV(accel_dev),
 			"Restarting msg received from PF 0x%x\n", msg);
 
+		clear_bit(ADF_STATUS_PF_RUNNING, &accel_dev->status);
+
 		stop_data = kzalloc(sizeof(*stop_data), GFP_ATOMIC);
 		if (!stop_data) {
 			dev_err(&GET_DEV(accel_dev),
diff --git a/drivers/crypto/qat/qat_dh895xccvf/adf_drv.c b/drivers/crypto/qat/qat_dh895xccvf/adf_drv.c
index 1bf75324..60df986 100644
--- a/drivers/crypto/qat/qat_dh895xccvf/adf_drv.c
+++ b/drivers/crypto/qat/qat_dh895xccvf/adf_drv.c
@@ -238,6 +238,8 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (ret)
 		goto out_err_free_reg;
 
+	set_bit(ADF_STATUS_PF_RUNNING, &accel_dev->status);
+
 	ret = adf_dev_init(accel_dev);
 	if (ret)
 		goto out_err_dev_shutdown;
-- 
2.1.4
