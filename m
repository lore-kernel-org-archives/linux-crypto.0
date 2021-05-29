Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3ED50C47082
	for <linux-crypto@archiver.kernel.org>; Sat, 29 May 2021 14:18:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0EA7661157
	for <linux-crypto@archiver.kernel.org>; Sat, 29 May 2021 14:18:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229795AbhE2OUX (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 29 May 2021 10:20:23 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:2409 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbhE2OUV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 29 May 2021 10:20:21 -0400
Received: from dggeme768-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4Fsk8k3V1kz65pL;
        Sat, 29 May 2021 22:15:02 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 dggeme768-chm.china.huawei.com (10.3.19.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Sat, 29 May 2021 22:18:42 +0800
From:   Weili Qian <qianweili@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <wangzhou1@hisilicon.com>, <liulongfang@huawei.com>,
        Weili Qian <qianweili@huawei.com>
Subject: [PATCH 1/4] crypto: hisilicon/qm - adjust reset interface
Date:   Sat, 29 May 2021 22:15:34 +0800
Message-ID: <1622297737-46604-2-git-send-email-qianweili@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1622297737-46604-1-git-send-email-qianweili@huawei.com>
References: <1622297737-46604-1-git-send-email-qianweili@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggeme768-chm.china.huawei.com (10.3.19.114)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Kunpeng930 hardware supports PF/VF communications. When the device is
reset, PF can send message to VF to stop function and restart function.

This patch adjusts the reset interface to support sending message through
PF/VF communication.

Signed-off-by: Weili Qian <qianweili@huawei.com>
---
 drivers/crypto/hisilicon/qm.c | 140 +++++++++++++++++++++++++++---------------
 1 file changed, 89 insertions(+), 51 deletions(-)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index fe35ea9..9071dac 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -1803,6 +1803,11 @@ static int qm_check_dev_error(struct hisi_qm *qm)
 	       (dev_val & (~qm->err_info.dev_ce_mask));
 }
 
+static int qm_wait_vf_prepare_finish(struct hisi_qm *qm)
+{
+	return 0;
+}
+
 static int qm_stop_qp(struct hisi_qp *qp)
 {
 	return qm_mb(qp->qm, QM_MB_CMD_STOP_QP, 0, qp->qp_id, 0);
@@ -3813,14 +3818,27 @@ static int qm_vf_reset_prepare(struct hisi_qm *qm,
 	return ret;
 }
 
-static int qm_reset_prepare_ready(struct hisi_qm *qm)
+static int qm_try_stop_vfs(struct hisi_qm *qm, enum qm_stop_reason stop_reason)
 {
 	struct pci_dev *pdev = qm->pdev;
-	struct hisi_qm *pf_qm = pci_get_drvdata(pci_physfn(pdev));
+	int ret;
+
+	if (!qm->vfs_num)
+		return 0;
+
+	ret = qm_vf_reset_prepare(qm, stop_reason);
+	if (ret)
+		pci_err(pdev, "failed to prepare reset, ret = %d.\n", ret);
+
+	return ret;
+}
+
+static int qm_wait_reset_finish(struct hisi_qm *qm)
+{
 	int delay = 0;
 
 	/* All reset requests need to be queued for processing */
-	while (test_and_set_bit(QM_RESETTING, &pf_qm->misc_ctl)) {
+	while (test_and_set_bit(QM_RESETTING, &qm->misc_ctl)) {
 		msleep(++delay);
 		if (delay > QM_RESET_WAIT_TIMEOUT)
 			return -EBUSY;
@@ -3829,6 +3847,22 @@ static int qm_reset_prepare_ready(struct hisi_qm *qm)
 	return 0;
 }
 
+static int qm_reset_prepare_ready(struct hisi_qm *qm)
+{
+	struct pci_dev *pdev = qm->pdev;
+	struct hisi_qm *pf_qm = pci_get_drvdata(pci_physfn(pdev));
+
+	return qm_wait_reset_finish(pf_qm);
+}
+
+static void qm_reset_bit_clear(struct hisi_qm *qm)
+{
+	struct pci_dev *pdev = qm->pdev;
+	struct hisi_qm *pf_qm = pci_get_drvdata(pci_physfn(pdev));
+
+	clear_bit(QM_RESETTING, &pf_qm->misc_ctl);
+}
+
 static int qm_controller_reset_prepare(struct hisi_qm *qm)
 {
 	struct pci_dev *pdev = qm->pdev;
@@ -3840,22 +3874,21 @@ static int qm_controller_reset_prepare(struct hisi_qm *qm)
 		return ret;
 	}
 
-	if (qm->vfs_num) {
-		ret = qm_vf_reset_prepare(qm, QM_SOFT_RESET);
-		if (ret) {
-			pci_err(pdev, "Fails to stop VFs!\n");
-			clear_bit(QM_RESETTING, &qm->misc_ctl);
-			return ret;
-		}
-	}
+	ret = qm_try_stop_vfs(qm, QM_SOFT_RESET);
+	if (ret)
+		pci_err(pdev, "failed to stop vfs by pf in soft reset.\n");
 
 	ret = hisi_qm_stop(qm, QM_SOFT_RESET);
 	if (ret) {
 		pci_err(pdev, "Fails to stop QM!\n");
-		clear_bit(QM_RESETTING, &qm->misc_ctl);
+		qm_reset_bit_clear(qm);
 		return ret;
 	}
 
+	ret = qm_wait_vf_prepare_finish(qm);
+	if (ret)
+		pci_err(pdev, "failed to stop by vfs in soft reset!\n");
+
 	clear_bit(QM_RST_SCHED, &qm->misc_ctl);
 
 	return 0;
@@ -3990,6 +4023,27 @@ static int qm_vf_reset_done(struct hisi_qm *qm)
 	return ret;
 }
 
+static int qm_try_start_vfs(struct hisi_qm *qm)
+{
+	struct pci_dev *pdev = qm->pdev;
+	int ret;
+
+	if (!qm->vfs_num)
+		return 0;
+
+	ret = qm_vf_q_assign(qm, qm->vfs_num);
+	if (ret) {
+		pci_err(pdev, "failed to assign VFs, ret = %d.\n", ret);
+		return ret;
+	}
+
+	ret = qm_vf_reset_done(qm);
+	if (ret)
+		pci_warn(pdev, "failed to start vfs, ret = %d.\n", ret);
+
+	return ret;
+}
+
 static int qm_dev_hw_init(struct hisi_qm *qm)
 {
 	return qm->err_ini->hw_init(qm);
@@ -4089,23 +4143,17 @@ static int qm_controller_reset_done(struct hisi_qm *qm)
 		return ret;
 	}
 
-	if (qm->vfs_num) {
-		ret = qm_vf_q_assign(qm, qm->vfs_num);
-		if (ret) {
-			pci_err(pdev, "Failed to assign queue!\n");
-			return ret;
-		}
-	}
+	ret = qm_try_start_vfs(qm);
+	if (ret)
+		pci_err(pdev, "failed to start vfs by pf in soft reset.\n");
 
-	ret = qm_vf_reset_done(qm);
-	if (ret) {
-		pci_err(pdev, "Failed to start VFs!\n");
-		return -EPERM;
-	}
+	ret = qm_wait_vf_prepare_finish(qm);
+	if (ret)
+		pci_err(pdev, "failed to start by vfs in soft reset!\n");
 
 	qm_restart_done(qm);
 
-	clear_bit(QM_RESETTING, &qm->misc_ctl);
+	qm_reset_bit_clear(qm);
 
 	return 0;
 }
@@ -4126,13 +4174,13 @@ static int qm_controller_reset(struct hisi_qm *qm)
 	ret = qm_soft_reset(qm);
 	if (ret) {
 		pci_err(pdev, "Controller reset failed (%d)\n", ret);
-		clear_bit(QM_RESETTING, &qm->misc_ctl);
+		qm_reset_bit_clear(qm);
 		return ret;
 	}
 
 	ret = qm_controller_reset_done(qm);
 	if (ret) {
-		clear_bit(QM_RESETTING, &qm->misc_ctl);
+		qm_reset_bit_clear(qm);
 		return ret;
 	}
 
@@ -4194,14 +4242,9 @@ void hisi_qm_reset_prepare(struct pci_dev *pdev)
 		return;
 	}
 
-	if (qm->vfs_num) {
-		ret = qm_vf_reset_prepare(qm, QM_FLR);
-		if (ret) {
-			pci_err(pdev, "Failed to prepare reset, ret = %d.\n",
-				ret);
-			return;
-		}
-	}
+	ret = qm_try_stop_vfs(qm, QM_SOFT_RESET);
+	if (ret)
+		pci_err(pdev, "failed to stop vfs by pf in FLR.\n");
 
 	ret = hisi_qm_stop(qm, QM_FLR);
 	if (ret) {
@@ -4209,6 +4252,10 @@ void hisi_qm_reset_prepare(struct pci_dev *pdev)
 		return;
 	}
 
+	ret = qm_wait_vf_prepare_finish(qm);
+	if (ret)
+		pci_err(pdev, "failed to stop by vfs in FLR!\n");
+
 	pci_info(pdev, "FLR resetting...\n");
 }
 EXPORT_SYMBOL_GPL(hisi_qm_reset_prepare);
@@ -4250,28 +4297,19 @@ void hisi_qm_reset_done(struct pci_dev *pdev)
 		goto flr_done;
 	}
 
-	if (qm->fun_type == QM_HW_PF) {
-		if (!qm->vfs_num)
-			goto flr_done;
-
-		ret = qm_vf_q_assign(qm, qm->vfs_num);
-		if (ret) {
-			pci_err(pdev, "Failed to assign VFs, ret = %d.\n", ret);
-			goto flr_done;
-		}
+	ret = qm_try_start_vfs(qm);
+	if (ret)
+		pci_err(pdev, "failed to start vfs by pf in FLR.\n");
 
-		ret = qm_vf_reset_done(qm);
-		if (ret) {
-			pci_err(pdev, "Failed to start VFs, ret = %d.\n", ret);
-			goto flr_done;
-		}
-	}
+	ret = qm_wait_vf_prepare_finish(qm);
+	if (ret)
+		pci_err(pdev, "failed to start by vfs in FLR!\n");
 
 flr_done:
 	if (qm_flr_reset_complete(pdev))
 		pci_info(pdev, "FLR reset complete\n");
 
-	clear_bit(QM_RESETTING, &pf_qm->misc_ctl);
+	qm_reset_bit_clear(qm);
 }
 EXPORT_SYMBOL_GPL(hisi_qm_reset_done);
 
-- 
2.8.1

