Return-Path: <SRS0=wb3S=BO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEDBCC433E0
	for <linux-crypto@archiver.kernel.org>; Tue,  4 Aug 2020 14:00:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B77892086A
	for <linux-crypto@archiver.kernel.org>; Tue,  4 Aug 2020 14:00:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728801AbgHDOAw (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 4 Aug 2020 10:00:52 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:60698 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728718AbgHDOAl (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 4 Aug 2020 10:00:41 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 9F1067CB2C4B1BD61EAE;
        Tue,  4 Aug 2020 22:00:38 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.487.0; Tue, 4 Aug 2020 22:00:31 +0800
From:   Yang Shen <shenyang39@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <xuzaibo@huawei.com>, <wangzhou1@hisilicon.com>
Subject: [PATCH v4 06/10] crypto: hisilicon/qm - fix no stop reason when use 'hisi_qm_stop'
Date:   Tue, 4 Aug 2020 21:58:26 +0800
Message-ID: <1596549510-2373-7-git-send-email-shenyang39@huawei.com>
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

Now, there are three reasons of stopping: 'NORMAL', 'SOFT_RESET' and 'FLR'.
In order to keep this, explicitly pass the stop reason as an input
parameter of 'hisi_qm_stop' function.

Fixes: b67202e8ed30("crypto: hisilicon/qm - add state machine for QM")
Signed-off-by: Shukun Tan <tanshukun1@huawei.com>
Signed-off-by: Yang Shen <shenyang39@huawei.com>
Reviewed-by: Zhou Wang <wangzhou1@hisilicon.com>
---
 drivers/crypto/hisilicon/hpre/hpre_main.c |  4 ++--
 drivers/crypto/hisilicon/qm.c             | 20 ++++++++++----------
 drivers/crypto/hisilicon/qm.h             |  2 +-
 drivers/crypto/hisilicon/sec2/sec_main.c  |  4 ++--
 drivers/crypto/hisilicon/zip/zip_main.c   |  4 ++--
 5 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/crypto/hisilicon/hpre/hpre_main.c b/drivers/crypto/hisilicon/hpre/hpre_main.c
index b135c74..b9e5214 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_main.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_main.c
@@ -886,7 +886,7 @@ static int hpre_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 err_with_qm_start:
 	hisi_qm_del_from_list(qm, &hpre_devices);
 	hpre_debugfs_exit(qm);
-	hisi_qm_stop(qm);
+	hisi_qm_stop(qm, QM_NORMAL);
 
 err_with_err_init:
 	hisi_qm_dev_err_uninit(qm);
@@ -918,7 +918,7 @@ static void hpre_remove(struct pci_dev *pdev)
 	}
 
 	hpre_debugfs_exit(qm);
-	hisi_qm_stop(qm);
+	hisi_qm_stop(qm, QM_NORMAL);
 	hisi_qm_dev_err_uninit(qm);
 	hisi_qm_uninit(qm);
 }
diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index 0f2a48a..427c3e0 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -2642,18 +2642,20 @@ static void qm_clear_queues(struct hisi_qm *qm)
 /**
  * hisi_qm_stop() - Stop a qm.
  * @qm: The qm which will be stopped.
+ * @r: The reason to stop qm.
  *
  * This function stops qm and its qps, then qm can not accept request.
  * Related resources are not released at this state, we can use hisi_qm_start
  * to let qm start again.
  */
-int hisi_qm_stop(struct hisi_qm *qm)
+int hisi_qm_stop(struct hisi_qm *qm, enum qm_stop_reason r)
 {
 	struct device *dev = &qm->pdev->dev;
 	int ret = 0;
 
 	down_write(&qm->qps_lock);
 
+	qm->status.stop_reason = r;
 	if (!qm_avail_state(qm, QM_STOP)) {
 		ret = -EPERM;
 		goto err_unlock;
@@ -3299,10 +3301,10 @@ static int qm_set_msi(struct hisi_qm *qm, bool set)
 	return 0;
 }
 
-static int qm_vf_reset_prepare(struct hisi_qm *qm)
+static int qm_vf_reset_prepare(struct hisi_qm *qm,
+			       enum qm_stop_reason stop_reason)
 {
 	struct hisi_qm_list *qm_list = qm->qm_list;
-	int stop_reason = qm->status.stop_reason;
 	struct pci_dev *pdev = qm->pdev;
 	struct pci_dev *virtfn;
 	struct hisi_qm *vf_qm;
@@ -3315,8 +3317,7 @@ static int qm_vf_reset_prepare(struct hisi_qm *qm)
 			continue;
 
 		if (pci_physfn(virtfn) == pdev) {
-			vf_qm->status.stop_reason = stop_reason;
-			ret = hisi_qm_stop(vf_qm);
+			ret = hisi_qm_stop(vf_qm, stop_reason);
 			if (ret)
 				goto stop_fail;
 		}
@@ -3355,15 +3356,14 @@ static int qm_controller_reset_prepare(struct hisi_qm *qm)
 	}
 
 	if (qm->vfs_num) {
-		ret = qm_vf_reset_prepare(qm);
+		ret = qm_vf_reset_prepare(qm, QM_SOFT_RESET);
 		if (ret) {
 			pci_err(pdev, "Fails to stop VFs!\n");
 			return ret;
 		}
 	}
 
-	qm->status.stop_reason = QM_SOFT_RESET;
-	ret = hisi_qm_stop(qm);
+	ret = hisi_qm_stop(qm, QM_SOFT_RESET);
 	if (ret) {
 		pci_err(pdev, "Fails to stop QM!\n");
 		return ret;
@@ -3704,7 +3704,7 @@ void hisi_qm_reset_prepare(struct pci_dev *pdev)
 	}
 
 	if (qm->vfs_num) {
-		ret = qm_vf_reset_prepare(qm);
+		ret = qm_vf_reset_prepare(qm, QM_FLR);
 		if (ret) {
 			pci_err(pdev, "Failed to prepare reset, ret = %d.\n",
 				ret);
@@ -3712,7 +3712,7 @@ void hisi_qm_reset_prepare(struct pci_dev *pdev)
 		}
 	}
 
-	ret = hisi_qm_stop(qm);
+	ret = hisi_qm_stop(qm, QM_FLR);
 	if (ret) {
 		pci_err(pdev, "Failed to stop QM, ret = %d.\n", ret);
 		return;
diff --git a/drivers/crypto/hisilicon/qm.h b/drivers/crypto/hisilicon/qm.h
index 6c1d3c7..9d6cf1d 100644
--- a/drivers/crypto/hisilicon/qm.h
+++ b/drivers/crypto/hisilicon/qm.h
@@ -355,7 +355,7 @@ static inline void hisi_qm_del_from_list(struct hisi_qm *qm,
 int hisi_qm_init(struct hisi_qm *qm);
 void hisi_qm_uninit(struct hisi_qm *qm);
 int hisi_qm_start(struct hisi_qm *qm);
-int hisi_qm_stop(struct hisi_qm *qm);
+int hisi_qm_stop(struct hisi_qm *qm, enum qm_stop_reason r);
 struct hisi_qp *hisi_qm_create_qp(struct hisi_qm *qm, u8 alg_type);
 int hisi_qm_start_qp(struct hisi_qp *qp, unsigned long arg);
 int hisi_qm_stop_qp(struct hisi_qp *qp);
diff --git a/drivers/crypto/hisilicon/sec2/sec_main.c b/drivers/crypto/hisilicon/sec2/sec_main.c
index 2297425..5f1c870 100644
--- a/drivers/crypto/hisilicon/sec2/sec_main.c
+++ b/drivers/crypto/hisilicon/sec2/sec_main.c
@@ -901,7 +901,7 @@ static int sec_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 err_remove_from_list:
 	hisi_qm_del_from_list(qm, &sec_devices);
 	sec_debugfs_exit(qm);
-	hisi_qm_stop(qm);
+	hisi_qm_stop(qm, QM_NORMAL);
 
 err_probe_uninit:
 	sec_probe_uninit(qm);
@@ -926,7 +926,7 @@ static void sec_remove(struct pci_dev *pdev)
 
 	sec_debugfs_exit(qm);
 
-	(void)hisi_qm_stop(qm);
+	(void)hisi_qm_stop(qm, QM_NORMAL);
 
 	if (qm->fun_type == QM_HW_PF)
 		sec_debug_regs_clear(qm);
diff --git a/drivers/crypto/hisilicon/zip/zip_main.c b/drivers/crypto/hisilicon/zip/zip_main.c
index e2845b2..224041e 100644
--- a/drivers/crypto/hisilicon/zip/zip_main.c
+++ b/drivers/crypto/hisilicon/zip/zip_main.c
@@ -828,7 +828,7 @@ static int hisi_zip_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 err_remove_from_list:
 	hisi_qm_del_from_list(qm, &zip_devices);
 	hisi_zip_debugfs_exit(hisi_zip);
-	hisi_qm_stop(qm);
+	hisi_qm_stop(qm, QM_NORMAL);
 err_qm_uninit:
 	hisi_qm_uninit(qm);
 
@@ -844,7 +844,7 @@ static void hisi_zip_remove(struct pci_dev *pdev)
 		hisi_qm_sriov_disable(pdev);
 
 	hisi_zip_debugfs_exit(hisi_zip);
-	hisi_qm_stop(qm);
+	hisi_qm_stop(qm, QM_NORMAL);
 
 	hisi_qm_dev_err_uninit(qm);
 	hisi_qm_uninit(qm);
-- 
2.7.4

