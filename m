Return-Path: <SRS0=UIra=5S=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBCC3C43331
	for <linux-crypto@archiver.kernel.org>; Thu,  2 Apr 2020 06:54:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A3B6C2078B
	for <linux-crypto@archiver.kernel.org>; Thu,  2 Apr 2020 06:54:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387501AbgDBGyL (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 2 Apr 2020 02:54:11 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:12601 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728585AbgDBGyL (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 2 Apr 2020 02:54:11 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id C06FCB546B54FDC32DD8;
        Thu,  2 Apr 2020 14:54:03 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.487.0; Thu, 2 Apr 2020 14:53:56 +0800
From:   Shukun Tan <tanshukun1@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <xuzaibo@huawei.com>,
        <wangzhou1@hisilicon.com>, <fanghao11@huawei.com>,
        Shukun Tan <tanshukun1@huawei.com>
Subject: [PATCH 2/3] crypto: hisilicon - unify SR-IOV related codes into QM
Date:   Thu, 2 Apr 2020 14:53:02 +0800
Message-ID: <1585810383-49392-3-git-send-email-tanshukun1@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1585810383-49392-1-git-send-email-tanshukun1@huawei.com>
References: <1585810383-49392-1-git-send-email-tanshukun1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Clean the duplicate SR-IOV related codes, put all into qm.c.

Signed-off-by: Shukun Tan <tanshukun1@huawei.com>
Reviewed-by: Zhou Wang <wangzhou1@hisilicon.com>
Reviewed-by: Zaibo Xu <xuzaibo@huawei.com>
---
 drivers/crypto/hisilicon/hpre/hpre_main.c | 105 +----------------------
 drivers/crypto/hisilicon/qm.c             | 136 ++++++++++++++++++++++++++++--
 drivers/crypto/hisilicon/qm.h             |   4 +-
 drivers/crypto/hisilicon/sec2/sec_main.c  | 108 +-----------------------
 drivers/crypto/hisilicon/zip/zip_main.c   | 109 +-----------------------
 5 files changed, 138 insertions(+), 324 deletions(-)

diff --git a/drivers/crypto/hisilicon/hpre/hpre_main.c b/drivers/crypto/hisilicon/hpre/hpre_main.c
index 5269e5b..4e41d30 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_main.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_main.c
@@ -792,107 +792,6 @@ static int hpre_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	return ret;
 }
 
-static int hpre_vf_q_assign(struct hpre *hpre, int num_vfs)
-{
-	struct hisi_qm *qm = &hpre->qm;
-	u32 qp_num = qm->qp_num;
-	int q_num, remain_q_num, i;
-	u32 q_base = qp_num;
-	int ret;
-
-	if (!num_vfs)
-		return -EINVAL;
-
-	remain_q_num = qm->ctrl_qp_num - qp_num;
-
-	/* If remaining queues are not enough, return error. */
-	if (remain_q_num < num_vfs)
-		return -EINVAL;
-
-	q_num = remain_q_num / num_vfs;
-	for (i = 1; i <= num_vfs; i++) {
-		if (i == num_vfs)
-			q_num += remain_q_num % num_vfs;
-		ret = hisi_qm_set_vft(qm, i, q_base, (u32)q_num);
-		if (ret)
-			return ret;
-		q_base += q_num;
-	}
-
-	return 0;
-}
-
-static int hpre_clear_vft_config(struct hpre *hpre)
-{
-	struct hisi_qm *qm = &hpre->qm;
-	u32 num_vfs = qm->vfs_num;
-	int ret;
-	u32 i;
-
-	for (i = 1; i <= num_vfs; i++) {
-		ret = hisi_qm_set_vft(qm, i, 0, 0);
-		if (ret)
-			return ret;
-	}
-	qm->vfs_num = 0;
-
-	return 0;
-}
-
-static int hpre_sriov_enable(struct pci_dev *pdev, int max_vfs)
-{
-	struct hpre *hpre = pci_get_drvdata(pdev);
-	int pre_existing_vfs, num_vfs, ret;
-
-	pre_existing_vfs = pci_num_vf(pdev);
-	if (pre_existing_vfs) {
-		pci_err(pdev,
-			"Can't enable VF. Please disable pre-enabled VFs!\n");
-		return 0;
-	}
-
-	num_vfs = min_t(int, max_vfs, HPRE_VF_NUM);
-	ret = hpre_vf_q_assign(hpre, num_vfs);
-	if (ret) {
-		pci_err(pdev, "Can't assign queues for VF!\n");
-		return ret;
-	}
-
-	hpre->qm.vfs_num = num_vfs;
-
-	ret = pci_enable_sriov(pdev, num_vfs);
-	if (ret) {
-		pci_err(pdev, "Can't enable VF!\n");
-		hpre_clear_vft_config(hpre);
-		return ret;
-	}
-
-	return num_vfs;
-}
-
-static int hpre_sriov_disable(struct pci_dev *pdev)
-{
-	struct hpre *hpre = pci_get_drvdata(pdev);
-
-	if (pci_vfs_assigned(pdev)) {
-		pci_err(pdev, "Failed to disable VFs while VFs are assigned!\n");
-		return -EPERM;
-	}
-
-	/* remove in hpre_pci_driver will be called to free VF resources */
-	pci_disable_sriov(pdev);
-
-	return hpre_clear_vft_config(hpre);
-}
-
-static int hpre_sriov_configure(struct pci_dev *pdev, int num_vfs)
-{
-	if (num_vfs)
-		return hpre_sriov_enable(pdev, num_vfs);
-	else
-		return hpre_sriov_disable(pdev);
-}
-
 static void hpre_remove(struct pci_dev *pdev)
 {
 	struct hpre *hpre = pci_get_drvdata(pdev);
@@ -902,7 +801,7 @@ static void hpre_remove(struct pci_dev *pdev)
 	hpre_algs_unregister();
 	hisi_qm_del_from_list(qm, &hpre_devices);
 	if (qm->fun_type == QM_HW_PF && qm->vfs_num) {
-		ret = hpre_sriov_disable(pdev);
+		ret = hisi_qm_sriov_disable(pdev);
 		if (ret) {
 			pci_err(pdev, "Disable SRIOV fail!\n");
 			return;
@@ -929,7 +828,7 @@ static struct pci_driver hpre_pci_driver = {
 	.id_table		= hpre_dev_ids,
 	.probe			= hpre_probe,
 	.remove			= hpre_remove,
-	.sriov_configure	= hpre_sriov_configure,
+	.sriov_configure	= hisi_qm_sriov_configure,
 	.err_handler		= &hpre_err_handler,
 };
 
diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index f795fb5..7c2dedc 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -1781,12 +1781,6 @@ int hisi_qm_get_vft(struct hisi_qm *qm, u32 *base, u32 *number)
 EXPORT_SYMBOL_GPL(hisi_qm_get_vft);
 
 /**
- * hisi_qm_set_vft() - Set "virtual function table" for a qm.
- * @fun_num: Number of operated function.
- * @qm: The qm in which to set vft, alway in a PF.
- * @base: The base number of queue in vft.
- * @number: The number of queues in vft. 0 means invalid vft.
- *
  * This function is alway called in PF driver, it is used to assign queues
  * among PF and VFs.
  *
@@ -1794,7 +1788,7 @@ EXPORT_SYMBOL_GPL(hisi_qm_get_vft);
  * Assign queues A~B to VF: hisi_qm_set_vft(qm, 2, A, B - A + 1)
  * (VF function number 0x2)
  */
-int hisi_qm_set_vft(struct hisi_qm *qm, u32 fun_num, u32 base,
+static int hisi_qm_set_vft(struct hisi_qm *qm, u32 fun_num, u32 base,
 		    u32 number)
 {
 	u32 max_q_num = qm->ctrl_qp_num;
@@ -1805,7 +1799,6 @@ int hisi_qm_set_vft(struct hisi_qm *qm, u32 fun_num, u32 base,
 
 	return qm_set_sqc_cqc_vft(qm, fun_num, base, number);
 }
-EXPORT_SYMBOL_GPL(hisi_qm_set_vft);
 
 static void qm_init_eq_aeq_status(struct hisi_qm *qm)
 {
@@ -2299,6 +2292,133 @@ int hisi_qm_alloc_qps_node(struct hisi_qm_list *qm_list, int qp_num,
 }
 EXPORT_SYMBOL_GPL(hisi_qm_alloc_qps_node);
 
+static int qm_vf_q_assign(struct hisi_qm *qm, u32 num_vfs)
+{
+	u32 remain_q_num, q_num, i, j;
+	u32 q_base = qm->qp_num;
+	int ret;
+
+	if (!num_vfs)
+		return -EINVAL;
+
+	remain_q_num = qm->ctrl_qp_num - qm->qp_num;
+
+	/* If remain queues not enough, return error. */
+	if (qm->ctrl_qp_num < qm->qp_num || remain_q_num < num_vfs)
+		return -EINVAL;
+
+	q_num = remain_q_num / num_vfs;
+	for (i = 1; i <= num_vfs; i++) {
+		if (i == num_vfs)
+			q_num += remain_q_num % num_vfs;
+		ret = hisi_qm_set_vft(qm, i, q_base, q_num);
+		if (ret) {
+			for (j = i; j > 0; j--)
+				hisi_qm_set_vft(qm, j, 0, 0);
+			return ret;
+		}
+		q_base += q_num;
+	}
+
+	return 0;
+}
+
+static int qm_clear_vft_config(struct hisi_qm *qm)
+{
+	int ret;
+	u32 i;
+
+	for (i = 1; i <= qm->vfs_num; i++) {
+		ret = hisi_qm_set_vft(qm, i, 0, 0);
+		if (ret)
+			return ret;
+	}
+	qm->vfs_num = 0;
+
+	return 0;
+}
+
+/**
+ * hisi_qm_sriov_enable() - enable virtual functions
+ * @pdev: the PCIe device
+ * @max_vfs: the number of virtual functions to enable
+ *
+ * Returns the number of enabled VFs. If there are VFs enabled already or
+ * max_vfs is more than the total number of device can be enabled, returns
+ * failure.
+ */
+int hisi_qm_sriov_enable(struct pci_dev *pdev, int max_vfs)
+{
+	struct hisi_qm *qm = pci_get_drvdata(pdev);
+	int pre_existing_vfs, num_vfs, total_vfs, ret;
+
+	total_vfs = pci_sriov_get_totalvfs(pdev);
+	pre_existing_vfs = pci_num_vf(pdev);
+	if (pre_existing_vfs) {
+		pci_err(pdev, "%d VFs already enabled. Please disable pre-enabled VFs!\n",
+			pre_existing_vfs);
+		return 0;
+	}
+
+	num_vfs = min_t(int, max_vfs, total_vfs);
+	ret = qm_vf_q_assign(qm, num_vfs);
+	if (ret) {
+		pci_err(pdev, "Can't assign queues for VF!\n");
+		return ret;
+	}
+
+	qm->vfs_num = num_vfs;
+
+	ret = pci_enable_sriov(pdev, num_vfs);
+	if (ret) {
+		pci_err(pdev, "Can't enable VF!\n");
+		qm_clear_vft_config(qm);
+		return ret;
+	}
+
+	pci_info(pdev, "VF enabled, vfs_num(=%d)!\n", num_vfs);
+
+	return num_vfs;
+}
+EXPORT_SYMBOL_GPL(hisi_qm_sriov_enable);
+
+/**
+ * hisi_qm_sriov_disable - disable virtual functions
+ * @pdev: the PCI device
+ *
+ * Return failure if there are VFs assigned already.
+ */
+int hisi_qm_sriov_disable(struct pci_dev *pdev)
+{
+	struct hisi_qm *qm = pci_get_drvdata(pdev);
+
+	if (pci_vfs_assigned(pdev)) {
+		pci_err(pdev, "Failed to disable VFs as VFs are assigned!\n");
+		return -EPERM;
+	}
+
+	/* remove in hpre_pci_driver will be called to free VF resources */
+	pci_disable_sriov(pdev);
+	return qm_clear_vft_config(qm);
+}
+EXPORT_SYMBOL_GPL(hisi_qm_sriov_disable);
+
+/**
+ * hisi_qm_sriov_configure - configure the number of VFs
+ * @pdev: The PCI device
+ * @num_vfs: The number of VFs need enabled
+ *
+ * Enable SR-IOV according to num_vfs, 0 means disable.
+ */
+int hisi_qm_sriov_configure(struct pci_dev *pdev, int num_vfs)
+{
+	if (num_vfs == 0)
+		return hisi_qm_sriov_disable(pdev);
+	else
+		return hisi_qm_sriov_enable(pdev, num_vfs);
+}
+EXPORT_SYMBOL_GPL(hisi_qm_sriov_configure);
+
 static pci_ers_result_t qm_dev_err_handle(struct hisi_qm *qm)
 {
 	u32 err_sts;
diff --git a/drivers/crypto/hisilicon/qm.h b/drivers/crypto/hisilicon/qm.h
index 33c5a8e..665e53d 100644
--- a/drivers/crypto/hisilicon/qm.h
+++ b/drivers/crypto/hisilicon/qm.h
@@ -268,10 +268,12 @@ void hisi_qm_release_qp(struct hisi_qp *qp);
 int hisi_qp_send(struct hisi_qp *qp, const void *msg);
 int hisi_qm_get_free_qp_num(struct hisi_qm *qm);
 int hisi_qm_get_vft(struct hisi_qm *qm, u32 *base, u32 *number);
-int hisi_qm_set_vft(struct hisi_qm *qm, u32 fun_num, u32 base, u32 number);
 int hisi_qm_debug_init(struct hisi_qm *qm);
 enum qm_hw_ver hisi_qm_get_hw_version(struct pci_dev *pdev);
 void hisi_qm_debug_regs_clear(struct hisi_qm *qm);
+int hisi_qm_sriov_enable(struct pci_dev *pdev, int max_vfs);
+int hisi_qm_sriov_disable(struct pci_dev *pdev);
+int hisi_qm_sriov_configure(struct pci_dev *pdev, int num_vfs);
 void hisi_qm_dev_err_init(struct hisi_qm *qm);
 void hisi_qm_dev_err_uninit(struct hisi_qm *qm);
 pci_ers_result_t hisi_qm_dev_err_detected(struct pci_dev *pdev,
diff --git a/drivers/crypto/hisilicon/sec2/sec_main.c b/drivers/crypto/hisilicon/sec2/sec_main.c
index ef26239..129648a 100644
--- a/drivers/crypto/hisilicon/sec2/sec_main.c
+++ b/drivers/crypto/hisilicon/sec2/sec_main.c
@@ -892,110 +892,6 @@ static int sec_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	return ret;
 }
 
-/* now we only support equal assignment */
-static int sec_vf_q_assign(struct sec_dev *sec, u32 num_vfs)
-{
-	struct hisi_qm *qm = &sec->qm;
-	u32 qp_num = qm->qp_num;
-	u32 q_base = qp_num;
-	u32 q_num, remain_q_num;
-	int i, j, ret;
-
-	if (!num_vfs)
-		return -EINVAL;
-
-	remain_q_num = qm->ctrl_qp_num - qp_num;
-	q_num = remain_q_num / num_vfs;
-
-	for (i = 1; i <= num_vfs; i++) {
-		if (i == num_vfs)
-			q_num += remain_q_num % num_vfs;
-		ret = hisi_qm_set_vft(qm, i, q_base, q_num);
-		if (ret) {
-			for (j = i; j > 0; j--)
-				hisi_qm_set_vft(qm, j, 0, 0);
-			return ret;
-		}
-		q_base += q_num;
-	}
-
-	return 0;
-}
-
-static int sec_clear_vft_config(struct sec_dev *sec)
-{
-	struct hisi_qm *qm = &sec->qm;
-	u32 num_vfs = qm->vfs_num;
-	int ret;
-	u32 i;
-
-	for (i = 1; i <= num_vfs; i++) {
-		ret = hisi_qm_set_vft(qm, i, 0, 0);
-		if (ret)
-			return ret;
-	}
-
-	qm->vfs_num = 0;
-
-	return 0;
-}
-
-static int sec_sriov_enable(struct pci_dev *pdev, int max_vfs)
-{
-	struct sec_dev *sec = pci_get_drvdata(pdev);
-	int pre_existing_vfs, ret;
-	u32 num_vfs;
-
-	pre_existing_vfs = pci_num_vf(pdev);
-
-	if (pre_existing_vfs) {
-		pci_err(pdev, "Can't enable VF. Please disable at first!\n");
-		return 0;
-	}
-
-	num_vfs = min_t(u32, max_vfs, SEC_VF_NUM);
-
-	ret = sec_vf_q_assign(sec, num_vfs);
-	if (ret) {
-		pci_err(pdev, "Can't assign queues for VF!\n");
-		return ret;
-	}
-
-	sec->qm.vfs_num = num_vfs;
-
-	ret = pci_enable_sriov(pdev, num_vfs);
-	if (ret) {
-		pci_err(pdev, "Can't enable VF!\n");
-		sec_clear_vft_config(sec);
-		return ret;
-	}
-
-	return num_vfs;
-}
-
-static int sec_sriov_disable(struct pci_dev *pdev)
-{
-	struct sec_dev *sec = pci_get_drvdata(pdev);
-
-	if (pci_vfs_assigned(pdev)) {
-		pci_err(pdev, "Can't disable VFs while VFs are assigned!\n");
-		return -EPERM;
-	}
-
-	/* remove in sec_pci_driver will be called to free VF resources */
-	pci_disable_sriov(pdev);
-
-	return sec_clear_vft_config(sec);
-}
-
-static int sec_sriov_configure(struct pci_dev *pdev, int num_vfs)
-{
-	if (num_vfs)
-		return sec_sriov_enable(pdev, num_vfs);
-	else
-		return sec_sriov_disable(pdev);
-}
-
 static void sec_remove(struct pci_dev *pdev)
 {
 	struct sec_dev *sec = pci_get_drvdata(pdev);
@@ -1006,7 +902,7 @@ static void sec_remove(struct pci_dev *pdev)
 	hisi_qm_del_from_list(qm, &sec_devices);
 
 	if (qm->fun_type == QM_HW_PF && qm->vfs_num)
-		(void)sec_sriov_disable(pdev);
+		hisi_qm_sriov_disable(pdev);
 
 	sec_debugfs_exit(sec);
 
@@ -1030,7 +926,7 @@ static struct pci_driver sec_pci_driver = {
 	.probe = sec_probe,
 	.remove = sec_remove,
 	.err_handler = &sec_err_handler,
-	.sriov_configure = sec_sriov_configure,
+	.sriov_configure = hisi_qm_sriov_configure,
 };
 
 static void sec_register_debugfs(void)
diff --git a/drivers/crypto/hisilicon/zip/zip_main.c b/drivers/crypto/hisilicon/zip/zip_main.c
index f5ffa02..5dcda7b 100644
--- a/drivers/crypto/hisilicon/zip/zip_main.c
+++ b/drivers/crypto/hisilicon/zip/zip_main.c
@@ -653,101 +653,6 @@ static int hisi_zip_pf_probe_init(struct hisi_zip *hisi_zip)
 	return 0;
 }
 
-/* Currently we only support equal assignment */
-static int hisi_zip_vf_q_assign(struct hisi_zip *hisi_zip, int num_vfs)
-{
-	struct hisi_qm *qm = &hisi_zip->qm;
-	u32 qp_num = qm->qp_num;
-	u32 q_base = qp_num;
-	u32 q_num, remain_q_num, i;
-	int ret;
-
-	if (!num_vfs)
-		return -EINVAL;
-
-	remain_q_num = qm->ctrl_qp_num - qp_num;
-	if (remain_q_num < num_vfs)
-		return -EINVAL;
-
-	q_num = remain_q_num / num_vfs;
-	for (i = 1; i <= num_vfs; i++) {
-		if (i == num_vfs)
-			q_num += remain_q_num % num_vfs;
-		ret = hisi_qm_set_vft(qm, i, q_base, q_num);
-		if (ret)
-			return ret;
-		q_base += q_num;
-	}
-
-	return 0;
-}
-
-static int hisi_zip_clear_vft_config(struct hisi_zip *hisi_zip)
-{
-	struct hisi_qm *qm = &hisi_zip->qm;
-	u32 i, num_vfs = qm->vfs_num;
-	int ret;
-
-	for (i = 1; i <= num_vfs; i++) {
-		ret = hisi_qm_set_vft(qm, i, 0, 0);
-		if (ret)
-			return ret;
-	}
-
-	qm->vfs_num = 0;
-
-	return 0;
-}
-
-static int hisi_zip_sriov_enable(struct pci_dev *pdev, int max_vfs)
-{
-	struct hisi_zip *hisi_zip = pci_get_drvdata(pdev);
-	int pre_existing_vfs, num_vfs, ret;
-
-	pre_existing_vfs = pci_num_vf(pdev);
-
-	if (pre_existing_vfs) {
-		dev_err(&pdev->dev,
-			"Can't enable VF. Please disable pre-enabled VFs!\n");
-		return 0;
-	}
-
-	num_vfs = min_t(int, max_vfs, HZIP_VF_NUM);
-
-	ret = hisi_zip_vf_q_assign(hisi_zip, num_vfs);
-	if (ret) {
-		dev_err(&pdev->dev, "Can't assign queues for VF!\n");
-		return ret;
-	}
-
-	hisi_zip->qm.vfs_num = num_vfs;
-
-	ret = pci_enable_sriov(pdev, num_vfs);
-	if (ret) {
-		dev_err(&pdev->dev, "Can't enable VF!\n");
-		hisi_zip_clear_vft_config(hisi_zip);
-		return ret;
-	}
-
-	return num_vfs;
-}
-
-static int hisi_zip_sriov_disable(struct pci_dev *pdev)
-{
-	struct hisi_zip *hisi_zip = pci_get_drvdata(pdev);
-
-	if (pci_vfs_assigned(pdev)) {
-		dev_err(&pdev->dev,
-			"Can't disable VFs while VFs are assigned!\n");
-		return -EPERM;
-	}
-
-	/* remove in hisi_zip_pci_driver will be called to free VF resources */
-	pci_disable_sriov(pdev);
-
-	return hisi_zip_clear_vft_config(hisi_zip);
-}
-
 static int hisi_zip_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	struct hisi_zip *hisi_zip;
@@ -820,7 +725,7 @@ static int hisi_zip_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	}
 
 	if (qm->fun_type == QM_HW_PF && vfs_num > 0) {
-		ret = hisi_zip_sriov_enable(pdev, vfs_num);
+		ret = hisi_qm_sriov_enable(pdev, vfs_num);
 		if (ret < 0)
 			goto err_remove_from_list;
 	}
@@ -836,21 +741,13 @@ static int hisi_zip_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	return ret;
 }
 
-static int hisi_zip_sriov_configure(struct pci_dev *pdev, int num_vfs)
-{
-	if (num_vfs == 0)
-		return hisi_zip_sriov_disable(pdev);
-	else
-		return hisi_zip_sriov_enable(pdev, num_vfs);
-}
-
 static void hisi_zip_remove(struct pci_dev *pdev)
 {
 	struct hisi_zip *hisi_zip = pci_get_drvdata(pdev);
 	struct hisi_qm *qm = &hisi_zip->qm;
 
 	if (qm->fun_type == QM_HW_PF && qm->vfs_num)
-		hisi_zip_sriov_disable(pdev);
+		hisi_qm_sriov_disable(pdev);
 
 	hisi_zip_debugfs_exit(hisi_zip);
 	hisi_qm_stop(qm);
@@ -870,7 +767,7 @@ static struct pci_driver hisi_zip_pci_driver = {
 	.probe			= hisi_zip_probe,
 	.remove			= hisi_zip_remove,
 	.sriov_configure	= IS_ENABLED(CONFIG_PCI_IOV) ?
-					hisi_zip_sriov_configure : NULL,
+					hisi_qm_sriov_configure : NULL,
 	.err_handler		= &hisi_zip_err_handler,
 };
 
-- 
2.7.4

