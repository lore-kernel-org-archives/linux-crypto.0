Return-Path: <SRS0=MAzA=AM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98434C433E1
	for <linux-crypto@archiver.kernel.org>; Wed,  1 Jul 2020 07:21:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 78A2D2070C
	for <linux-crypto@archiver.kernel.org>; Wed,  1 Jul 2020 07:21:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728130AbgGAHVr (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 1 Jul 2020 03:21:47 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:57376 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727836AbgGAHVq (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 1 Jul 2020 03:21:46 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id D8AF46C1A527A2B77E1A;
        Wed,  1 Jul 2020 15:21:41 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.487.0; Wed, 1 Jul 2020 15:21:33 +0800
From:   Yang Shen <shenyang39@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <xuzaibo@huawei.com>,
        <wangzhou1@hisilicon.com>
Subject: [Patch v2 8/9] crypto: hisilicon/qm - fix the process of register algorithms to crypto
Date:   Wed, 1 Jul 2020 15:19:54 +0800
Message-ID: <1593587995-7391-9-git-send-email-shenyang39@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1593587995-7391-1-git-send-email-shenyang39@huawei.com>
References: <1593587995-7391-1-git-send-email-shenyang39@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

When the devices are removed or not existing, the corresponding algorithms
which are registered by 'hisi-zip' driver can't be used.

Move 'hisi_zip_register_to_crypto' from 'hisi_zip_init' to
'hisi_zip_probe'. The algorithms will be registered to crypto only when
there is device bind on the driver. And when the devices are removed,
the algorithms will be unregistered.

In the previous process, the function 'xxx_register_to_crypto' need a lock
and a static variable to judge if the registration is the first time.
Move this action into the function 'hisi_qm_alg_register'. Each device
will call 'hisi_qm_alg_register' to add itself to qm list in probe process
and registering algs when the qm list is empty.

Signed-off-by: Yang Shen <shenyang39@huawei.com>
Reviewed-by: Zhou Wang <wangzhou1@hisilicon.com>
---
 drivers/crypto/hisilicon/hpre/hpre_crypto.c | 36 ++++++--------------
 drivers/crypto/hisilicon/hpre/hpre_main.c   | 21 ++++++------
 drivers/crypto/hisilicon/qm.c               | 52 +++++++++++++++++++++++++++++
 drivers/crypto/hisilicon/qm.h               | 20 +++--------
 drivers/crypto/hisilicon/sec2/sec_crypto.c  | 35 +++++++------------
 drivers/crypto/hisilicon/sec2/sec_main.c    | 25 +++++++-------
 drivers/crypto/hisilicon/zip/zip_crypto.c   |  2 +-
 drivers/crypto/hisilicon/zip/zip_main.c     | 39 ++++++++++++----------
 8 files changed, 125 insertions(+), 105 deletions(-)

diff --git a/drivers/crypto/hisilicon/hpre/hpre_crypto.c b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
index 7b5cb27..d685992 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_crypto.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
@@ -98,9 +98,6 @@ struct hpre_asym_request {
 	struct timespec64 req_time;
 };
 
-static DEFINE_MUTEX(hpre_alg_lock);
-static unsigned int hpre_active_devs;
-
 static int hpre_alloc_req_id(struct hpre_ctx *ctx)
 {
 	unsigned long flags;
@@ -1160,36 +1157,25 @@ static struct kpp_alg dh = {
 
 int hpre_algs_register(void)
 {
-	int ret = 0;
-
-	mutex_lock(&hpre_alg_lock);
-	if (++hpre_active_devs == 1) {
-		rsa.base.cra_flags = 0;
-		ret = crypto_register_akcipher(&rsa);
-		if (ret)
-			goto unlock;
+	int ret;
+
+	rsa.base.cra_flags = 0;
+	ret = crypto_register_akcipher(&rsa);
+	if (ret)
+		return ret;
 #ifdef CONFIG_CRYPTO_DH
-		ret = crypto_register_kpp(&dh);
-		if (ret) {
-			crypto_unregister_akcipher(&rsa);
-			goto unlock;
-		}
+	ret = crypto_register_kpp(&dh);
+	if (ret)
+		crypto_unregister_akcipher(&rsa);
 #endif
-	}
 
-unlock:
-	mutex_unlock(&hpre_alg_lock);
 	return ret;
 }
 
 void hpre_algs_unregister(void)
 {
-	mutex_lock(&hpre_alg_lock);
-	if (--hpre_active_devs == 0) {
-		crypto_unregister_akcipher(&rsa);
+	crypto_unregister_akcipher(&rsa);
 #ifdef CONFIG_CRYPTO_DH
-		crypto_unregister_kpp(&dh);
+	crypto_unregister_kpp(&dh);
 #endif
-	}
-	mutex_unlock(&hpre_alg_lock);
 }
diff --git a/drivers/crypto/hisilicon/hpre/hpre_main.c b/drivers/crypto/hisilicon/hpre/hpre_main.c
index 85bdfdf..aff2839 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_main.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_main.c
@@ -87,7 +87,6 @@
 #define HPRE_SQE_MASK_OFFSET		8
 #define HPRE_SQE_MASK_LEN		24
 
-static struct hisi_qm_list hpre_devices;
 static const char hpre_name[] = "hisi_hpre";
 static struct dentry *hpre_debugfs_root;
 static const struct pci_device_id hpre_dev_ids[] = {
@@ -103,6 +102,11 @@ struct hpre_hw_error {
 	const char *msg;
 };
 
+static struct hisi_qm_list hpre_devices = {
+	.register_to_crypto	= hpre_algs_register,
+	.unregister_from_crypto	= hpre_algs_unregister,
+};
+
 static const char * const hpre_debug_file_name[] = {
 	[HPRE_CURRENT_QM]   = "current_qm",
 	[HPRE_CLEAR_ENABLE] = "rdclr_en",
@@ -853,9 +857,7 @@ static int hpre_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (ret)
 		dev_warn(&pdev->dev, "init debugfs fail!\n");
 
-	hisi_qm_add_to_list(qm, &hpre_devices);
-
-	ret = hpre_algs_register();
+	ret = hisi_qm_alg_register(qm, &hpre_devices);
 	if (ret < 0) {
 		pci_err(pdev, "fail to register algs to crypto!\n");
 		goto err_with_qm_start;
@@ -864,16 +866,16 @@ static int hpre_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (qm->fun_type == QM_HW_PF && vfs_num) {
 		ret = hisi_qm_sriov_enable(pdev, vfs_num);
 		if (ret < 0)
-			goto err_with_crypto_register;
+			goto err_with_alg_register;
 	}
 
 	return 0;
 
-err_with_crypto_register:
-	hpre_algs_unregister();
+err_with_alg_register:
+	hisi_qm_alg_unregister(qm, &hpre_devices);
 
 err_with_qm_start:
-	hisi_qm_del_from_list(qm, &hpre_devices);
+	hpre_debugfs_exit(hpre);
 	hisi_qm_stop(qm, QM_NORMAL);
 
 err_with_err_init:
@@ -891,8 +893,7 @@ static void hpre_remove(struct pci_dev *pdev)
 	struct hisi_qm *qm = &hpre->qm;
 	int ret;
 
-	hpre_algs_unregister();
-	hisi_qm_del_from_list(qm, &hpre_devices);
+	hisi_qm_alg_unregister(qm, &hpre_devices);
 	if (qm->fun_type == QM_HW_PF && qm->vfs_num) {
 		ret = hisi_qm_sriov_disable(pdev);
 		if (ret) {
diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index a441b3d..8327365 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -3866,6 +3866,58 @@ static void hisi_qm_controller_reset(struct work_struct *rst_work)
 }
 
 /**
+ * hisi_qm_alg_register() - Register alg to crypto and add qm to qm_list.
+ * @qm: The qm needs add.
+ * @qm_list: The qm list.
+ *
+ * This function adds qm to qm list, and will register algorithm to
+ * crypto when the qm list is empty.
+ */
+int hisi_qm_alg_register(struct hisi_qm *qm, struct hisi_qm_list *qm_list)
+{
+	int flag = 0;
+	int ret = 0;
+
+	mutex_lock(&qm_list->lock);
+	if (list_empty(&qm_list->list))
+		flag = 1;
+	list_add_tail(&qm->list, &qm_list->list);
+	mutex_unlock(&qm_list->lock);
+
+	if (flag) {
+		ret = qm_list->register_to_crypto();
+		if (ret) {
+			mutex_lock(&qm_list->lock);
+			list_del(&qm->list);
+			mutex_unlock(&qm_list->lock);
+		}
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(hisi_qm_alg_register);
+
+/**
+ * hisi_qm_alg_unregister() - Unregister alg from crypto and delete qm from
+ * qm list.
+ * @qm: The qm needs delete.
+ * @qm_list: The qm list.
+ *
+ * This function deletes qm from qm list, and will unregister algorithm
+ * from crypto when the qm list is empty.
+ */
+void hisi_qm_alg_unregister(struct hisi_qm *qm, struct hisi_qm_list *qm_list)
+{
+	mutex_lock(&qm_list->lock);
+	list_del(&qm->list);
+	mutex_unlock(&qm_list->lock);
+
+	if (list_empty(&qm_list->list))
+		qm_list->unregister_from_crypto();
+}
+EXPORT_SYMBOL_GPL(hisi_qm_alg_unregister);
+
+/**
  * hisi_qm_init() - Initialize configures about qm.
  * @qm: The qm needing init.
  *
diff --git a/drivers/crypto/hisilicon/qm.h b/drivers/crypto/hisilicon/qm.h
index 9d6cf1d..bd00897 100644
--- a/drivers/crypto/hisilicon/qm.h
+++ b/drivers/crypto/hisilicon/qm.h
@@ -193,6 +193,8 @@ struct hisi_qm_err_ini {
 struct hisi_qm_list {
 	struct mutex lock;
 	struct list_head list;
+	int (*register_to_crypto)(void);
+	void (*unregister_from_crypto)(void);
 };
 
 struct hisi_qm {
@@ -336,22 +338,6 @@ static inline void hisi_qm_init_list(struct hisi_qm_list *qm_list)
 	mutex_init(&qm_list->lock);
 }
 
-static inline void hisi_qm_add_to_list(struct hisi_qm *qm,
-				       struct hisi_qm_list *qm_list)
-{
-	mutex_lock(&qm_list->lock);
-	list_add_tail(&qm->list, &qm_list->list);
-	mutex_unlock(&qm_list->lock);
-}
-
-static inline void hisi_qm_del_from_list(struct hisi_qm *qm,
-					 struct hisi_qm_list *qm_list)
-{
-	mutex_lock(&qm_list->lock);
-	list_del(&qm->list);
-	mutex_unlock(&qm_list->lock);
-}
-
 int hisi_qm_init(struct hisi_qm *qm);
 void hisi_qm_uninit(struct hisi_qm *qm);
 int hisi_qm_start(struct hisi_qm *qm);
@@ -390,4 +376,6 @@ void hisi_acc_free_sgl_pool(struct device *dev,
 int hisi_qm_alloc_qps_node(struct hisi_qm_list *qm_list, int qp_num,
 			   u8 alg_type, int node, struct hisi_qp **qps);
 void hisi_qm_free_qps(struct hisi_qp **qps, int qp_num);
+int hisi_qm_alg_register(struct hisi_qm *qm, struct hisi_qm_list *qm_list);
+void hisi_qm_alg_unregister(struct hisi_qm *qm, struct hisi_qm_list *qm_list);
 #endif
diff --git a/drivers/crypto/hisilicon/sec2/sec_crypto.c b/drivers/crypto/hisilicon/sec2/sec_crypto.c
index 85fcb4d..3c0c1d5 100644
--- a/drivers/crypto/hisilicon/sec2/sec_crypto.c
+++ b/drivers/crypto/hisilicon/sec2/sec_crypto.c
@@ -66,8 +66,6 @@
 #define SEC_SQE_AEAD_FLAG	3
 #define SEC_SQE_DONE		0x1
 
-static atomic_t sec_active_devs;
-
 /* Get an en/de-cipher queue cyclically to balance load over queues of TFM */
 static inline int sec_alloc_queue_id(struct sec_ctx *ctx, struct sec_req *req)
 {
@@ -1625,33 +1623,24 @@ static struct aead_alg sec_aeads[] = {
 
 int sec_register_to_crypto(void)
 {
-	int ret = 0;
+	int ret;
 
 	/* To avoid repeat register */
-	if (atomic_add_return(1, &sec_active_devs) == 1) {
-		ret = crypto_register_skciphers(sec_skciphers,
-						ARRAY_SIZE(sec_skciphers));
-		if (ret)
-			return ret;
-
-		ret = crypto_register_aeads(sec_aeads, ARRAY_SIZE(sec_aeads));
-		if (ret)
-			goto reg_aead_fail;
-	}
-
-	return ret;
-
-reg_aead_fail:
-	crypto_unregister_skciphers(sec_skciphers, ARRAY_SIZE(sec_skciphers));
+	ret = crypto_register_skciphers(sec_skciphers,
+					ARRAY_SIZE(sec_skciphers));
+	if (ret)
+		return ret;
 
+	ret = crypto_register_aeads(sec_aeads, ARRAY_SIZE(sec_aeads));
+	if (ret)
+		crypto_unregister_skciphers(sec_skciphers,
+					    ARRAY_SIZE(sec_skciphers));
 	return ret;
 }
 
 void sec_unregister_from_crypto(void)
 {
-	if (atomic_sub_return(1, &sec_active_devs) == 0) {
-		crypto_unregister_skciphers(sec_skciphers,
-					    ARRAY_SIZE(sec_skciphers));
-		crypto_unregister_aeads(sec_aeads, ARRAY_SIZE(sec_aeads));
-	}
+	crypto_unregister_skciphers(sec_skciphers,
+				    ARRAY_SIZE(sec_skciphers));
+	crypto_unregister_aeads(sec_aeads, ARRAY_SIZE(sec_aeads));
 }
diff --git a/drivers/crypto/hisilicon/sec2/sec_main.c b/drivers/crypto/hisilicon/sec2/sec_main.c
index 091ba5a..d9c162d2 100644
--- a/drivers/crypto/hisilicon/sec2/sec_main.c
+++ b/drivers/crypto/hisilicon/sec2/sec_main.c
@@ -99,7 +99,11 @@ struct sec_dfx_item {
 
 static const char sec_name[] = "hisi_sec2";
 static struct dentry *sec_debugfs_root;
-static struct hisi_qm_list sec_devices;
+
+static struct hisi_qm_list sec_devices = {
+	.register_to_crypto	= sec_register_to_crypto,
+	.unregister_from_crypto	= sec_unregister_from_crypto,
+};
 
 static const struct sec_hw_error sec_hw_errors[] = {
 	{.int_msk = BIT(0), .msg = "sec_axi_rresp_err_rint"},
@@ -879,27 +883,24 @@ static int sec_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (ret)
 		pci_warn(pdev, "Failed to init debugfs!\n");
 
-	hisi_qm_add_to_list(qm, &sec_devices);
-
-	ret = sec_register_to_crypto();
+	ret = hisi_qm_alg_register(qm, &sec_devices);
 	if (ret < 0) {
 		pr_err("Failed to register driver to crypto.\n");
-		goto err_remove_from_list;
+		goto err_qm_stop;
 	}
 
 	if (qm->fun_type == QM_HW_PF && vfs_num) {
 		ret = hisi_qm_sriov_enable(pdev, vfs_num);
 		if (ret < 0)
-			goto err_crypto_unregister;
+			goto err_alg_unregister;
 	}
 
 	return 0;
 
-err_crypto_unregister:
-	sec_unregister_from_crypto();
+err_alg_unregister:
+	hisi_qm_alg_unregister(qm, &sec_devices);
 
-err_remove_from_list:
-	hisi_qm_del_from_list(qm, &sec_devices);
+err_qm_stop:
 	sec_debugfs_exit(qm);
 	hisi_qm_stop(qm, QM_NORMAL);
 
@@ -917,9 +918,7 @@ static void sec_remove(struct pci_dev *pdev)
 	struct sec_dev *sec = pci_get_drvdata(pdev);
 	struct hisi_qm *qm = &sec->qm;
 
-	sec_unregister_from_crypto();
-
-	hisi_qm_del_from_list(qm, &sec_devices);
+	hisi_qm_alg_unregister(qm, &sec_devices);
 
 	if (qm->fun_type == QM_HW_PF && qm->vfs_num)
 		hisi_qm_sriov_disable(pdev);
diff --git a/drivers/crypto/hisilicon/zip/zip_crypto.c b/drivers/crypto/hisilicon/zip/zip_crypto.c
index c73707c..2ef5155 100644
--- a/drivers/crypto/hisilicon/zip/zip_crypto.c
+++ b/drivers/crypto/hisilicon/zip/zip_crypto.c
@@ -611,7 +611,7 @@ static struct acomp_alg hisi_zip_acomp_gzip = {
 
 int hisi_zip_register_to_crypto(void)
 {
-	int ret = 0;
+	int ret;
 
 	ret = crypto_register_acomp(&hisi_zip_acomp_zlib);
 	if (ret) {
diff --git a/drivers/crypto/hisilicon/zip/zip_main.c b/drivers/crypto/hisilicon/zip/zip_main.c
index 5bf722a..72e2cc0 100644
--- a/drivers/crypto/hisilicon/zip/zip_main.c
+++ b/drivers/crypto/hisilicon/zip/zip_main.c
@@ -94,7 +94,6 @@
 
 static const char hisi_zip_name[] = "hisi_zip";
 static struct dentry *hzip_debugfs_root;
-static struct hisi_qm_list zip_devices;
 
 struct hisi_zip_hw_error {
 	u32 int_msk;
@@ -106,6 +105,11 @@ struct zip_dfx_item {
 	u32 offset;
 };
 
+static struct hisi_qm_list zip_devices = {
+	.register_to_crypto	= hisi_zip_register_to_crypto,
+	.unregister_from_crypto	= hisi_zip_unregister_from_crypto,
+};
+
 static struct zip_dfx_item zip_dfx_files[] = {
 	{"send_cnt", offsetof(struct hisi_zip_dfx, send_cnt)},
 	{"recv_cnt", offsetof(struct hisi_zip_dfx, recv_cnt)},
@@ -802,32 +806,42 @@ static int hisi_zip_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	ret = hisi_qm_start(qm);
 	if (ret)
-		goto err_qm_uninit;
+		goto err_dev_err_uninit;
 
 	ret = hisi_zip_debugfs_init(hisi_zip);
 	if (ret)
 		dev_err(&pdev->dev, "Failed to init debugfs (%d)!\n", ret);
 
-	hisi_qm_add_to_list(qm, &zip_devices);
+	ret = hisi_qm_alg_register(qm, &zip_devices);
+	if (ret < 0) {
+		pci_err(pdev, "Failed to register driver to crypto.\n");
+		goto err_qm_stop;
+	}
 
 	if (qm->uacce) {
 		ret = uacce_register(qm->uacce);
 		if (ret)
-			goto err_qm_uninit;
+			goto err_qm_alg_unregister;
 	}
 
 	if (qm->fun_type == QM_HW_PF && vfs_num > 0) {
 		ret = hisi_qm_sriov_enable(pdev, vfs_num);
 		if (ret < 0)
-			goto err_remove_from_list;
+			goto err_qm_alg_unregister;
 	}
 
 	return 0;
 
-err_remove_from_list:
-	hisi_qm_del_from_list(qm, &zip_devices);
+err_qm_alg_unregister:
+	hisi_qm_alg_unregister(qm, &zip_devices);
+
+err_qm_stop:
 	hisi_zip_debugfs_exit(hisi_zip);
 	hisi_qm_stop(qm, QM_NORMAL);
+
+err_dev_err_uninit:
+	hisi_qm_dev_err_uninit(qm);
+
 err_qm_uninit:
 	hisi_qm_uninit(qm);
 
@@ -847,7 +861,7 @@ static void hisi_zip_remove(struct pci_dev *pdev)
 
 	hisi_qm_dev_err_uninit(qm);
 	hisi_qm_uninit(qm);
-	hisi_qm_del_from_list(qm, &zip_devices);
+	hisi_qm_alg_unregister(qm, &zip_devices);
 }
 
 static const struct pci_error_handlers hisi_zip_err_handler = {
@@ -893,16 +907,8 @@ static int __init hisi_zip_init(void)
 		goto err_pci;
 	}
 
-	ret = hisi_zip_register_to_crypto();
-	if (ret < 0) {
-		pr_err("Failed to register driver to crypto.\n");
-		goto err_crypto;
-	}
-
 	return 0;
 
-err_crypto:
-	pci_unregister_driver(&hisi_zip_pci_driver);
 err_pci:
 	hisi_zip_unregister_debugfs();
 
@@ -911,7 +917,6 @@ static int __init hisi_zip_init(void)
 
 static void __exit hisi_zip_exit(void)
 {
-	hisi_zip_unregister_from_crypto();
 	pci_unregister_driver(&hisi_zip_pci_driver);
 	hisi_zip_unregister_debugfs();
 }
-- 
2.7.4

