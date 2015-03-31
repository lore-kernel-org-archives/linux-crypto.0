From: Bruce Allan <bruce.w.allan@intel.com>
Subject: [PATCH] crypto: qat - fix typo
Date: Tue, 31 Mar 2015 09:30:24 -0700
Message-ID: <20150331163024.6379.51821.stgit@bwallan-smackover2.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:28289 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751459AbbCaQaZ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 31 Mar 2015 12:30:25 -0400
Received: from bwallan-smackover2.jf.intel.com (localhost.localdomain [127.0.0.1])
	by bwallan-smackover2.jf.intel.com (8.14.8/8.14.8) with ESMTP id t2VGUOSp006425
	for <linux-crypto@vger.kernel.org>; Tue, 31 Mar 2015 09:30:24 -0700
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

adt_ctl_drv should be adf_ctl_drv

Signed-off-by: Bruce Allan <bruce.w.allan@intel.com>
---
 drivers/crypto/qat/qat_common/adf_ctl_drv.c |   28 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_ctl_drv.c b/drivers/crypto/qat/qat_common/adf_ctl_drv.c
index 731538a..cb5f066 100644
--- a/drivers/crypto/qat/qat_common/adf_ctl_drv.c
+++ b/drivers/crypto/qat/qat_common/adf_ctl_drv.c
@@ -77,14 +77,14 @@ struct adf_ctl_drv_info {
 	struct class *drv_class;
 };
 
-static struct adf_ctl_drv_info adt_ctl_drv;
+static struct adf_ctl_drv_info adf_ctl_drv;
 
 static void adf_chr_drv_destroy(void)
 {
-	device_destroy(adt_ctl_drv.drv_class, MKDEV(adt_ctl_drv.major, 0));
-	cdev_del(&adt_ctl_drv.drv_cdev);
-	class_destroy(adt_ctl_drv.drv_class);
-	unregister_chrdev_region(MKDEV(adt_ctl_drv.major, 0), 1);
+	device_destroy(adf_ctl_drv.drv_class, MKDEV(adf_ctl_drv.major, 0));
+	cdev_del(&adf_ctl_drv.drv_cdev);
+	class_destroy(adf_ctl_drv.drv_class);
+	unregister_chrdev_region(MKDEV(adf_ctl_drv.major, 0), 1);
 }
 
 static int adf_chr_drv_create(void)
@@ -97,20 +97,20 @@ static int adf_chr_drv_create(void)
 		return -EFAULT;
 	}
 
-	adt_ctl_drv.drv_class = class_create(THIS_MODULE, DEVICE_NAME);
-	if (IS_ERR(adt_ctl_drv.drv_class)) {
+	adf_ctl_drv.drv_class = class_create(THIS_MODULE, DEVICE_NAME);
+	if (IS_ERR(adf_ctl_drv.drv_class)) {
 		pr_err("QAT: class_create failed for adf_ctl\n");
 		goto err_chrdev_unreg;
 	}
-	adt_ctl_drv.major = MAJOR(dev_id);
-	cdev_init(&adt_ctl_drv.drv_cdev, &adf_ctl_ops);
-	if (cdev_add(&adt_ctl_drv.drv_cdev, dev_id, 1)) {
+	adf_ctl_drv.major = MAJOR(dev_id);
+	cdev_init(&adf_ctl_drv.drv_cdev, &adf_ctl_ops);
+	if (cdev_add(&adf_ctl_drv.drv_cdev, dev_id, 1)) {
 		pr_err("QAT: cdev add failed\n");
 		goto err_class_destr;
 	}
 
-	drv_device = device_create(adt_ctl_drv.drv_class, NULL,
-				   MKDEV(adt_ctl_drv.major, 0),
+	drv_device = device_create(adf_ctl_drv.drv_class, NULL,
+				   MKDEV(adf_ctl_drv.major, 0),
 				   NULL, DEVICE_NAME);
 	if (IS_ERR(drv_device)) {
 		pr_err("QAT: failed to create device\n");
@@ -118,9 +118,9 @@ static int adf_chr_drv_create(void)
 	}
 	return 0;
 err_cdev_del:
-	cdev_del(&adt_ctl_drv.drv_cdev);
+	cdev_del(&adf_ctl_drv.drv_cdev);
 err_class_destr:
-	class_destroy(adt_ctl_drv.drv_class);
+	class_destroy(adf_ctl_drv.drv_class);
 err_chrdev_unreg:
 	unregister_chrdev_region(dev_id, 1);
 	return -EFAULT;
