Return-Path: <SRS0=wb3S=BO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD753C433E3
	for <linux-crypto@archiver.kernel.org>; Tue,  4 Aug 2020 14:05:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A5B082086A
	for <linux-crypto@archiver.kernel.org>; Tue,  4 Aug 2020 14:05:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726948AbgHDOFA (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 4 Aug 2020 10:05:00 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:60924 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728774AbgHDOAu (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 4 Aug 2020 10:00:50 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 957443E8E38E39619461;
        Tue,  4 Aug 2020 22:00:43 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.487.0; Tue, 4 Aug 2020 22:00:32 +0800
From:   Yang Shen <shenyang39@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <xuzaibo@huawei.com>, <wangzhou1@hisilicon.com>
Subject: [PATCH v4 10/10] crypto: hisilicon/qm - fix the process of register algorithms to crypto
Date:   Tue, 4 Aug 2020 21:58:30 +0800
Message-ID: <1596549510-2373-11-git-send-email-shenyang39@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1596549510-2373-1-git-send-email-shenyang39@huawei.com>
References: <1596549510-2373-1-git-send-email-shenyang39@huawei.com>
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
 drivers/crypto/hisilicon/hpre/hpre_main.c   | 20 +++++------
 drivers/crypto/hisilicon/qm.c               | 52 +++++++++++++++++++++++++++++
 drivers/crypto/hisilicon/qm.h               | 20 +++--------
 drivers/crypto/hisilicon/sec2/sec_crypto.c  | 35 +++++++------------
 drivers/crypto/hisilicon/sec2/sec_main.c    | 26 +++++++--------
 drivers/crypto/hisilicon/zip/zip_crypto.c   |  2 +-
 drivers/crypto/hisilicon/zip/zip_main.c     | 41 +++++++++++++----------
 8 files changed, 125 insertions(+), 107 deletions(-)

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
index fc06770..45741d2 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_main.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_main.c
@@ -90,7 +90,6 @@
 #define HPRE_SQE_MASK_OFFSET		8
 #define HPRE_SQE_MASK_LEN		24
 
-static struct hisi_qm_list hpre_devices;
 static const char hpre_name[] = "hisi_hpre";
 static struct dentry *hpre_debugfs_root;
 static const struct pci_device_id hpre_dev_ids[] = {
@@ -106,6 +105,11 @@ struct hpre_hw_error {
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
@@ -864,9 +868,7 @@ static int hpre_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (ret)
 		dev_warn(&pdev->dev, "init debugfs fail!\n");
 
-	hisi_qm_add_to_list(qm, &hpre_devices);
-
-	ret = hpre_algs_register();
+	ret = hisi_qm_alg_register(qm, &hpre_devices);
 	if (ret < 0) {
 		pci_err(pdev, "fail to register algs to crypto!\n");
 		goto err_with_qm_start;
@@ -875,16 +877,15 @@ static int hpre_probe(struct pci_dev *pdev, const struct pci_device_id *id)
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
 	hpre_debugfs_exit(qm);
 	hisi_qm_stop(qm, QM_NORMAL);
 
@@ -904,8 +905,7 @@ static void hpre_remove(struct pci_dev *pdev)
 	int ret;
 
 	hisi_qm_wait_task_finish(qm, &hpre_devices);
-	hpre_algs_unregister();
-	hisi_qm_del_from_list(qm, &hpre_devices);
+	hisi_qm_alg_unregister(qm, &hpre_devices);
 	if (qm->fun_type == QM_HW_PF && qm->vfs_num) {
 		ret = hisi_qm_sriov_disable(pdev, qm->is_frozen);
 		if (ret) {
diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index 9ee973a..0724474 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -3951,6 +3951,58 @@ static void hisi_qm_controller_reset(struct work_struct *rst_work)
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
index 5c07cfe..6773f44 100644
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
@@ -337,22 +339,6 @@ static inline void hisi_qm_init_list(struct hisi_qm_list *qm_list)
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
@@ -393,4 +379,6 @@ int hisi_qm_alloc_qps_node(struct hisi_qm_list *qm_list, int qp_num,
 void hisi_qm_free_qps(struct hisi_qp **qps, int qp_num);
 void hisi_qm_dev_shutdown(struct pci_dev *pdev);
 void hisi_qm_wait_task_finish(struct hisi_qm *qm, struct hisi_qm_list *qm_list);
+int hisi_qm_alg_register(struct hisi_qm *qm, struct hisi_qm_list *qm_list);
+void hisi_qm_alg_unregister(struct hisi_qm *qm, struct hisi_qm_list *qm_list);
 #endif
diff --git a/drivers/crypto/hisilicon/sec2/sec_crypto.c b/drivers/crypto/hisilicon/sec2/sec_crypto.c
index 497969a..543d9ee 100644
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
@@ -1633,33 +1631,24 @@ static struct aead_alg sec_aeads[] = {
 
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
index 629344c..f912e57 100644
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
 
@@ -918,10 +919,7 @@ static void sec_remove(struct pci_dev *pdev)
 	struct hisi_qm *qm = &sec->qm;
 
 	hisi_qm_wait_task_finish(qm, &sec_devices);
-	sec_unregister_from_crypto();
-
-	hisi_qm_del_from_list(qm, &sec_devices);
-
+	hisi_qm_alg_unregister(qm, &sec_devices);
 	if (qm->fun_type == QM_HW_PF && qm->vfs_num)
 		hisi_qm_sriov_disable(pdev, qm->is_frozen);
 
diff --git a/drivers/crypto/hisilicon/zip/zip_crypto.c b/drivers/crypto/hisilicon/zip/zip_crypto.c
index 01fd6a7..aba1600 100644
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
index f13e520..7e86b0f 100644
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
@@ -803,32 +807,42 @@ static int hisi_zip_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
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
 
@@ -841,15 +855,15 @@ static void hisi_zip_remove(struct pci_dev *pdev)
 	struct hisi_qm *qm = &hisi_zip->qm;
 
 	hisi_qm_wait_task_finish(qm, &zip_devices);
+	hisi_qm_alg_unregister(qm, &zip_devices);
+
 	if (qm->fun_type == QM_HW_PF && qm->vfs_num)
 		hisi_qm_sriov_disable(pdev, qm->is_frozen);
 
 	hisi_zip_debugfs_exit(hisi_zip);
 	hisi_qm_stop(qm, QM_NORMAL);
-
 	hisi_qm_dev_err_uninit(qm);
 	hisi_qm_uninit(qm);
-	hisi_qm_del_from_list(qm, &zip_devices);
 }
 
 static const struct pci_error_handlers hisi_zip_err_handler = {
@@ -896,16 +910,8 @@ static int __init hisi_zip_init(void)
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
 
@@ -914,7 +920,6 @@ static int __init hisi_zip_init(void)
 
 static void __exit hisi_zip_exit(void)
 {
-	hisi_zip_unregister_from_crypto();
 	pci_unregister_driver(&hisi_zip_pci_driver);
 	hisi_zip_unregister_debugfs();
 }
-- 
2.7.4

