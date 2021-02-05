Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61305C433E0
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Feb 2021 10:32:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1FF9464F3B
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Feb 2021 10:32:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230172AbhBEKc2 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 5 Feb 2021 05:32:28 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:12857 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231264AbhBEKQD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 5 Feb 2021 05:16:03 -0500
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4DXB8l5wGPz7hW5;
        Fri,  5 Feb 2021 18:13:59 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.498.0; Fri, 5 Feb 2021 18:15:12 +0800
From:   Weili Qian <qianweili@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <xuzaibo@huawei.com>, <wangzhou1@hisilicon.com>
Subject: [PATCH 1/6] crypto: hisilicon/qm - removing driver after reset
Date:   Fri, 5 Feb 2021 18:12:53 +0800
Message-ID: <1612519978-33340-2-git-send-email-qianweili@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1612519978-33340-1-git-send-email-qianweili@huawei.com>
References: <1612519978-33340-1-git-send-email-qianweili@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add waiting logic for resetting as removing driver,
otherwise call trace will occur due to releasing resource.

Signed-off-by: Weili Qian <qianweili@huawei.com>
Reviewed-by: Zaibo Xu <xuzaibo@huawei.com>
---
 drivers/crypto/hisilicon/hpre/hpre_main.c |  2 +-
 drivers/crypto/hisilicon/qm.c             | 48 ++++++++++++++++++++-----------
 drivers/crypto/hisilicon/qm.h             |  2 +-
 drivers/crypto/hisilicon/sec2/sec_main.c  |  2 +-
 drivers/crypto/hisilicon/zip/zip_main.c   |  2 +-
 5 files changed, 36 insertions(+), 20 deletions(-)

diff --git a/drivers/crypto/hisilicon/hpre/hpre_main.c b/drivers/crypto/hisilicon/hpre/hpre_main.c
index 3b3481e..ef2fe4d 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_main.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_main.c
@@ -961,7 +961,7 @@ static void hpre_remove(struct pci_dev *pdev)
 	hisi_qm_wait_task_finish(qm, &hpre_devices);
 	hisi_qm_alg_unregister(qm, &hpre_devices);
 	if (qm->fun_type == QM_HW_PF && qm->vfs_num) {
-		ret = hisi_qm_sriov_disable(pdev, qm->is_frozen);
+		ret = hisi_qm_sriov_disable(pdev, true);
 		if (ret) {
 			pci_err(pdev, "Disable SRIOV fail!\n");
 			return;
diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index 904b99a..e659436 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -147,7 +147,6 @@
 #define QM_RAS_CE_TIMES_PER_IRQ		1
 #define QM_RAS_MSI_INT_SEL		0x1040f4
 
-#define QM_DEV_RESET_FLAG		0
 #define QM_RESET_WAIT_TIMEOUT		400
 #define QM_PEH_VENDOR_ID		0x1000d8
 #define ACC_VENDOR_ID_VALUE		0x5a5a
@@ -185,6 +184,10 @@
 #define QM_SQE_ADDR_MASK		GENMASK(7, 0)
 #define QM_EQ_DEPTH			(1024 * 2)
 
+#define QM_DRIVER_REMOVING		0
+#define QM_RST_SCHED			1
+#define QM_RESETTING			2
+
 #define QM_MK_CQC_DW3_V1(hop_num, pg_sz, buf_sz, cqe_sz) \
 	(((hop_num) << QM_CQ_HOP_NUM_SHIFT)	| \
 	((pg_sz) << QM_CQ_PAGE_SIZE_SHIFT)	| \
@@ -2248,17 +2251,15 @@ static int qm_alloc_uacce(struct hisi_qm *qm)
  */
 static int qm_frozen(struct hisi_qm *qm)
 {
-	down_write(&qm->qps_lock);
-
-	if (qm->is_frozen) {
-		up_write(&qm->qps_lock);
+	if (test_bit(QM_DRIVER_REMOVING, &qm->misc_ctl))
 		return 0;
-	}
+
+	down_write(&qm->qps_lock);
 
 	if (!qm->qp_in_used) {
 		qm->qp_in_used = qm->qp_num;
-		qm->is_frozen = true;
 		up_write(&qm->qps_lock);
+		set_bit(QM_DRIVER_REMOVING, &qm->misc_ctl);
 		return 0;
 	}
 
@@ -2311,6 +2312,10 @@ void hisi_qm_wait_task_finish(struct hisi_qm *qm, struct hisi_qm_list *qm_list)
 		msleep(WAIT_PERIOD);
 	}
 
+	while (test_bit(QM_RST_SCHED, &qm->misc_ctl) ||
+	       test_bit(QM_RESETTING, &qm->misc_ctl))
+		msleep(WAIT_PERIOD);
+
 	udelay(REMOVE_WAIT_DELAY);
 }
 EXPORT_SYMBOL_GPL(hisi_qm_wait_task_finish);
@@ -2439,7 +2444,7 @@ static void hisi_qm_pre_init(struct hisi_qm *qm)
 	mutex_init(&qm->mailbox_lock);
 	init_rwsem(&qm->qps_lock);
 	qm->qp_in_used = 0;
-	qm->is_frozen = false;
+	qm->misc_ctl = false;
 }
 
 static void hisi_qm_pci_uninit(struct hisi_qm *qm)
@@ -3248,7 +3253,7 @@ EXPORT_SYMBOL_GPL(hisi_qm_sriov_disable);
 int hisi_qm_sriov_configure(struct pci_dev *pdev, int num_vfs)
 {
 	if (num_vfs == 0)
-		return hisi_qm_sriov_disable(pdev, 0);
+		return hisi_qm_sriov_disable(pdev, false);
 	else
 		return hisi_qm_sriov_enable(pdev, num_vfs);
 }
@@ -3465,7 +3470,7 @@ static int qm_reset_prepare_ready(struct hisi_qm *qm)
 	int delay = 0;
 
 	/* All reset requests need to be queued for processing */
-	while (test_and_set_bit(QM_DEV_RESET_FLAG, &pf_qm->reset_flag)) {
+	while (test_and_set_bit(QM_RESETTING, &pf_qm->misc_ctl)) {
 		msleep(++delay);
 		if (delay > QM_RESET_WAIT_TIMEOUT)
 			return -EBUSY;
@@ -3489,6 +3494,7 @@ static int qm_controller_reset_prepare(struct hisi_qm *qm)
 		ret = qm_vf_reset_prepare(qm, QM_SOFT_RESET);
 		if (ret) {
 			pci_err(pdev, "Fails to stop VFs!\n");
+			clear_bit(QM_RESETTING, &qm->misc_ctl);
 			return ret;
 		}
 	}
@@ -3496,9 +3502,12 @@ static int qm_controller_reset_prepare(struct hisi_qm *qm)
 	ret = hisi_qm_stop(qm, QM_SOFT_RESET);
 	if (ret) {
 		pci_err(pdev, "Fails to stop QM!\n");
+		clear_bit(QM_RESETTING, &qm->misc_ctl);
 		return ret;
 	}
 
+	clear_bit(QM_RST_SCHED, &qm->misc_ctl);
+
 	return 0;
 }
 
@@ -3736,7 +3745,7 @@ static int qm_controller_reset_done(struct hisi_qm *qm)
 	hisi_qm_dev_err_init(qm);
 	qm_restart_done(qm);
 
-	clear_bit(QM_DEV_RESET_FLAG, &qm->reset_flag);
+	clear_bit(QM_RESETTING, &qm->misc_ctl);
 
 	return 0;
 }
@@ -3749,18 +3758,23 @@ static int qm_controller_reset(struct hisi_qm *qm)
 	pci_info(pdev, "Controller resetting...\n");
 
 	ret = qm_controller_reset_prepare(qm);
-	if (ret)
+	if (ret) {
+		clear_bit(QM_RST_SCHED, &qm->misc_ctl);
 		return ret;
+	}
 
 	ret = qm_soft_reset(qm);
 	if (ret) {
 		pci_err(pdev, "Controller reset failed (%d)\n", ret);
+		clear_bit(QM_RESETTING, &qm->misc_ctl);
 		return ret;
 	}
 
 	ret = qm_controller_reset_done(qm);
-	if (ret)
+	if (ret) {
+		clear_bit(QM_RESETTING, &qm->misc_ctl);
 		return ret;
+	}
 
 	pci_info(pdev, "Controller reset complete\n");
 
@@ -3867,8 +3881,6 @@ static bool qm_flr_reset_complete(struct pci_dev *pdev)
 		return false;
 	}
 
-	clear_bit(QM_DEV_RESET_FLAG, &qm->reset_flag);
-
 	return true;
 }
 
@@ -3912,6 +3924,8 @@ void hisi_qm_reset_done(struct pci_dev *pdev)
 flr_done:
 	if (qm_flr_reset_complete(pdev))
 		pci_info(pdev, "FLR reset complete\n");
+
+	clear_bit(QM_RESETTING, &qm->misc_ctl);
 }
 EXPORT_SYMBOL_GPL(hisi_qm_reset_done);
 
@@ -3922,7 +3936,9 @@ static irqreturn_t qm_abnormal_irq(int irq, void *data)
 
 	atomic64_inc(&qm->debug.dfx.abnormal_irq_cnt);
 	ret = qm_process_dev_error(qm);
-	if (ret == ACC_ERR_NEED_RESET)
+	if (ret == ACC_ERR_NEED_RESET &&
+	    !test_bit(QM_DRIVER_REMOVING, &qm->misc_ctl) &&
+	    !test_and_set_bit(QM_RST_SCHED, &qm->misc_ctl))
 		schedule_work(&qm->rst_work);
 
 	return IRQ_HANDLED;
diff --git a/drivers/crypto/hisilicon/qm.h b/drivers/crypto/hisilicon/qm.h
index c1dd0fc..c08ffe3 100644
--- a/drivers/crypto/hisilicon/qm.h
+++ b/drivers/crypto/hisilicon/qm.h
@@ -230,7 +230,7 @@ struct hisi_qm {
 	struct hisi_qm_status status;
 	const struct hisi_qm_err_ini *err_ini;
 	struct hisi_qm_err_status err_status;
-	unsigned long reset_flag;
+	unsigned long misc_ctl; /* driver removing and reset sched */
 
 	struct rw_semaphore qps_lock;
 	struct idr qp_idr;
diff --git a/drivers/crypto/hisilicon/sec2/sec_main.c b/drivers/crypto/hisilicon/sec2/sec_main.c
index 4809c19..7db0e86 100644
--- a/drivers/crypto/hisilicon/sec2/sec_main.c
+++ b/drivers/crypto/hisilicon/sec2/sec_main.c
@@ -949,7 +949,7 @@ static void sec_remove(struct pci_dev *pdev)
 	hisi_qm_wait_task_finish(qm, &sec_devices);
 	hisi_qm_alg_unregister(qm, &sec_devices);
 	if (qm->fun_type == QM_HW_PF && qm->vfs_num)
-		hisi_qm_sriov_disable(pdev, qm->is_frozen);
+		hisi_qm_sriov_disable(pdev, true);
 
 	sec_debugfs_exit(qm);
 
diff --git a/drivers/crypto/hisilicon/zip/zip_main.c b/drivers/crypto/hisilicon/zip/zip_main.c
index 9cdecff..c5609f4 100644
--- a/drivers/crypto/hisilicon/zip/zip_main.c
+++ b/drivers/crypto/hisilicon/zip/zip_main.c
@@ -901,7 +901,7 @@ static void hisi_zip_remove(struct pci_dev *pdev)
 	hisi_qm_alg_unregister(qm, &zip_devices);
 
 	if (qm->fun_type == QM_HW_PF && qm->vfs_num)
-		hisi_qm_sriov_disable(pdev, qm->is_frozen);
+		hisi_qm_sriov_disable(pdev, true);
 
 	hisi_zip_debugfs_exit(qm);
 	hisi_qm_stop(qm, QM_NORMAL);
-- 
2.8.1

