From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH] crypto: qat - changed adf_dev_stop to void
Date: Tue, 29 Mar 2016 10:21:07 -0700
Message-ID: <20160329172107.2549.32379.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, tadeusz.struk@intel.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:51577 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753103AbcC2R0Q (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 29 Mar 2016 13:26:16 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

It returns always zero anyway.

Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 drivers/crypto/qat/qat_c3xxx/adf_drv.c         |    4 +---
 drivers/crypto/qat/qat_c3xxxvf/adf_drv.c       |    4 +---
 drivers/crypto/qat/qat_c62x/adf_drv.c          |    4 +---
 drivers/crypto/qat/qat_c62xvf/adf_drv.c        |    4 +---
 drivers/crypto/qat/qat_common/adf_common_drv.h |    2 +-
 drivers/crypto/qat/qat_common/adf_ctl_drv.c    |   18 ++++--------------
 drivers/crypto/qat/qat_common/adf_init.c       |   12 +++++-------
 drivers/crypto/qat/qat_common/adf_sriov.c      |    8 +-------
 drivers/crypto/qat/qat_dh895xcc/adf_drv.c      |    4 +---
 drivers/crypto/qat/qat_dh895xccvf/adf_drv.c    |    4 +---
 10 files changed, 17 insertions(+), 47 deletions(-)

diff --git a/drivers/crypto/qat/qat_c3xxx/adf_drv.c b/drivers/crypto/qat/qat_c3xxx/adf_drv.c
index e13bd08..640c3fc 100644
--- a/drivers/crypto/qat/qat_c3xxx/adf_drv.c
+++ b/drivers/crypto/qat/qat_c3xxx/adf_drv.c
@@ -300,9 +300,7 @@ static void adf_remove(struct pci_dev *pdev)
 		pr_err("QAT: Driver removal failed\n");
 		return;
 	}
-	if (adf_dev_stop(accel_dev))
-		dev_err(&GET_DEV(accel_dev), "Failed to stop QAT accel dev\n");
-
+	adf_dev_stop(accel_dev);
 	adf_dev_shutdown(accel_dev);
 	adf_disable_aer(accel_dev);
 	adf_cleanup_accel(accel_dev);
diff --git a/drivers/crypto/qat/qat_c3xxxvf/adf_drv.c b/drivers/crypto/qat/qat_c3xxxvf/adf_drv.c
index 1ac4ae9..a998981 100644
--- a/drivers/crypto/qat/qat_c3xxxvf/adf_drv.c
+++ b/drivers/crypto/qat/qat_c3xxxvf/adf_drv.c
@@ -270,9 +270,7 @@ static void adf_remove(struct pci_dev *pdev)
 		pr_err("QAT: Driver removal failed\n");
 		return;
 	}
-	if (adf_dev_stop(accel_dev))
-		dev_err(&GET_DEV(accel_dev), "Failed to stop QAT accel dev\n");
-
+	adf_dev_stop(accel_dev);
 	adf_dev_shutdown(accel_dev);
 	adf_cleanup_accel(accel_dev);
 	adf_cleanup_pci_dev(accel_dev);
diff --git a/drivers/crypto/qat/qat_c62x/adf_drv.c b/drivers/crypto/qat/qat_c62x/adf_drv.c
index 512c565..bc5cbc1 100644
--- a/drivers/crypto/qat/qat_c62x/adf_drv.c
+++ b/drivers/crypto/qat/qat_c62x/adf_drv.c
@@ -300,9 +300,7 @@ static void adf_remove(struct pci_dev *pdev)
 		pr_err("QAT: Driver removal failed\n");
 		return;
 	}
-	if (adf_dev_stop(accel_dev))
-		dev_err(&GET_DEV(accel_dev), "Failed to stop QAT accel dev\n");
-
+	adf_dev_stop(accel_dev);
 	adf_dev_shutdown(accel_dev);
 	adf_disable_aer(accel_dev);
 	adf_cleanup_accel(accel_dev);
diff --git a/drivers/crypto/qat/qat_c62xvf/adf_drv.c b/drivers/crypto/qat/qat_c62xvf/adf_drv.c
index d2e4b92..ccfb25e 100644
--- a/drivers/crypto/qat/qat_c62xvf/adf_drv.c
+++ b/drivers/crypto/qat/qat_c62xvf/adf_drv.c
@@ -270,9 +270,7 @@ static void adf_remove(struct pci_dev *pdev)
 		pr_err("QAT: Driver removal failed\n");
 		return;
 	}
-	if (adf_dev_stop(accel_dev))
-		dev_err(&GET_DEV(accel_dev), "Failed to stop QAT accel dev\n");
-
+	adf_dev_stop(accel_dev);
 	adf_dev_shutdown(accel_dev);
 	adf_cleanup_accel(accel_dev);
 	adf_cleanup_pci_dev(accel_dev);
diff --git a/drivers/crypto/qat/qat_common/adf_common_drv.h b/drivers/crypto/qat/qat_common/adf_common_drv.h
index 0e82ce3..c9e4d46 100644
--- a/drivers/crypto/qat/qat_common/adf_common_drv.h
+++ b/drivers/crypto/qat/qat_common/adf_common_drv.h
@@ -103,7 +103,7 @@ int adf_service_unregister(struct service_hndl *service);
 
 int adf_dev_init(struct adf_accel_dev *accel_dev);
 int adf_dev_start(struct adf_accel_dev *accel_dev);
-int adf_dev_stop(struct adf_accel_dev *accel_dev);
+void adf_dev_stop(struct adf_accel_dev *accel_dev);
 void adf_dev_shutdown(struct adf_accel_dev *accel_dev);
 
 int adf_iov_putmsg(struct adf_accel_dev *accel_dev, u32 msg, u8 vf_nr);
diff --git a/drivers/crypto/qat/qat_common/adf_ctl_drv.c b/drivers/crypto/qat/qat_common/adf_ctl_drv.c
index 7403356..48a1248 100644
--- a/drivers/crypto/qat/qat_common/adf_ctl_drv.c
+++ b/drivers/crypto/qat/qat_common/adf_ctl_drv.c
@@ -284,13 +284,8 @@ static int adf_ctl_stop_devices(uint32_t id)
 			if (!accel_dev->is_vf)
 				continue;
 
-			if (adf_dev_stop(accel_dev)) {
-				dev_err(&GET_DEV(accel_dev),
-					"Failed to stop qat_dev%d\n", id);
-				ret = -EFAULT;
-			} else {
-				adf_dev_shutdown(accel_dev);
-			}
+			adf_dev_stop(accel_dev);
+			adf_dev_shutdown(accel_dev);
 		}
 	}
 
@@ -299,13 +294,8 @@ static int adf_ctl_stop_devices(uint32_t id)
 			if (!adf_dev_started(accel_dev))
 				continue;
 
-			if (adf_dev_stop(accel_dev)) {
-				dev_err(&GET_DEV(accel_dev),
-					"Failed to stop qat_dev%d\n", id);
-				ret = -EFAULT;
-			} else {
-				adf_dev_shutdown(accel_dev);
-			}
+			adf_dev_stop(accel_dev);
+			adf_dev_shutdown(accel_dev);
 		}
 	}
 	return ret;
diff --git a/drivers/crypto/qat/qat_common/adf_init.c b/drivers/crypto/qat/qat_common/adf_init.c
index ef5575e..a29470b 100644
--- a/drivers/crypto/qat/qat_common/adf_init.c
+++ b/drivers/crypto/qat/qat_common/adf_init.c
@@ -236,9 +236,9 @@ EXPORT_SYMBOL_GPL(adf_dev_start);
  * is shuting down.
  * To be used by QAT device specific drivers.
  *
- * Return: 0 on success, error code otherwise.
+ * Return: void
  */
-int adf_dev_stop(struct adf_accel_dev *accel_dev)
+void adf_dev_stop(struct adf_accel_dev *accel_dev)
 {
 	struct service_hndl *service;
 	struct list_head *list_itr;
@@ -246,9 +246,9 @@ int adf_dev_stop(struct adf_accel_dev *accel_dev)
 	int ret;
 
 	if (!adf_dev_started(accel_dev) &&
-	    !test_bit(ADF_STATUS_STARTING, &accel_dev->status)) {
-		return 0;
-	}
+	    !test_bit(ADF_STATUS_STARTING, &accel_dev->status))
+		return;
+
 	clear_bit(ADF_STATUS_STARTING, &accel_dev->status);
 	clear_bit(ADF_STATUS_STARTED, &accel_dev->status);
 
@@ -279,8 +279,6 @@ int adf_dev_stop(struct adf_accel_dev *accel_dev)
 		else
 			clear_bit(ADF_STATUS_AE_STARTED, &accel_dev->status);
 	}
-
-	return 0;
 }
 EXPORT_SYMBOL_GPL(adf_dev_stop);
 
diff --git a/drivers/crypto/qat/qat_common/adf_sriov.c b/drivers/crypto/qat/qat_common/adf_sriov.c
index 1117a8b..4479b0b 100644
--- a/drivers/crypto/qat/qat_common/adf_sriov.c
+++ b/drivers/crypto/qat/qat_common/adf_sriov.c
@@ -259,13 +259,7 @@ int adf_sriov_configure(struct pci_dev *pdev, int numvfs)
 			return -EBUSY;
 		}
 
-		if (adf_dev_stop(accel_dev)) {
-			dev_err(&GET_DEV(accel_dev),
-				"Failed to stop qat_dev%d\n",
-				accel_dev->accel_id);
-			return -EFAULT;
-		}
-
+		adf_dev_stop(accel_dev);
 		adf_dev_shutdown(accel_dev);
 	}
 
diff --git a/drivers/crypto/qat/qat_dh895xcc/adf_drv.c b/drivers/crypto/qat/qat_dh895xcc/adf_drv.c
index a8c4b92..4d2de28 100644
--- a/drivers/crypto/qat/qat_dh895xcc/adf_drv.c
+++ b/drivers/crypto/qat/qat_dh895xcc/adf_drv.c
@@ -302,9 +302,7 @@ static void adf_remove(struct pci_dev *pdev)
 		pr_err("QAT: Driver removal failed\n");
 		return;
 	}
-	if (adf_dev_stop(accel_dev))
-		dev_err(&GET_DEV(accel_dev), "Failed to stop QAT accel dev\n");
-
+	adf_dev_stop(accel_dev);
 	adf_dev_shutdown(accel_dev);
 	adf_disable_aer(accel_dev);
 	adf_cleanup_accel(accel_dev);
diff --git a/drivers/crypto/qat/qat_dh895xccvf/adf_drv.c b/drivers/crypto/qat/qat_dh895xccvf/adf_drv.c
index f8cc4bf..1bf75324 100644
--- a/drivers/crypto/qat/qat_dh895xccvf/adf_drv.c
+++ b/drivers/crypto/qat/qat_dh895xccvf/adf_drv.c
@@ -270,9 +270,7 @@ static void adf_remove(struct pci_dev *pdev)
 		pr_err("QAT: Driver removal failed\n");
 		return;
 	}
-	if (adf_dev_stop(accel_dev))
-		dev_err(&GET_DEV(accel_dev), "Failed to stop QAT accel dev\n");
-
+	adf_dev_stop(accel_dev);
 	adf_dev_shutdown(accel_dev);
 	adf_cleanup_accel(accel_dev);
 	adf_cleanup_pci_dev(accel_dev);
