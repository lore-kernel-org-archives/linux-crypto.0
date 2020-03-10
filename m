Return-Path: <SRS0=U1Ok=43=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40417C3F2D0
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Mar 2020 08:43:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1E4A8208E4
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Mar 2020 08:43:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726610AbgCJInf (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 10 Mar 2020 04:43:35 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:11201 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726605AbgCJInf (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 10 Mar 2020 04:43:35 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 376AB93A6E238E0CE9B3;
        Tue, 10 Mar 2020 16:43:30 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.487.0; Tue, 10 Mar 2020 16:43:22 +0800
From:   Shukun Tan <tanshukun1@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <wangzhou1@hisilicon.com>,
        <xuzaibo@huawei.com>
Subject: [PATCH v2 4/4] crypto: hisilicon/sec2 - Add new create qp process
Date:   Tue, 10 Mar 2020 16:42:52 +0800
Message-ID: <1583829772-53372-5-git-send-email-tanshukun1@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1583829772-53372-1-git-send-email-tanshukun1@huawei.com>
References: <1583829772-53372-1-git-send-email-tanshukun1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Kai Ye <yekai13@huawei.com>

Combine found device and created qp into one operation instead of found
device and create qp both are independent operations. when execute
multiple tasks, the different threads may find same device at the same
time, but the number of queues is insufficient on the device. causing
one of threads fail to create a qp. Now fix this, First find device then
create qp, if result failure. the current thread will find next device.

Signed-off-by: Kai Ye <yekai13@huawei.com>
Signed-off-by: Shukun Tan <tanshukun1@huawei.com>
Reviewed-by: Zhou Wang <wangzhou1@hisilicon.com>
Reviewed-by: Zaibo Xu <xuzaibo@huawei.com>
---
 drivers/crypto/hisilicon/sec2/sec.h        |  5 +-
 drivers/crypto/hisilicon/sec2/sec_crypto.c | 17 +++----
 drivers/crypto/hisilicon/sec2/sec_main.c   | 81 ++++++++++++------------------
 3 files changed, 42 insertions(+), 61 deletions(-)

diff --git a/drivers/crypto/hisilicon/sec2/sec.h b/drivers/crypto/hisilicon/sec2/sec.h
index a73d82c..3598fa1 100644
--- a/drivers/crypto/hisilicon/sec2/sec.h
+++ b/drivers/crypto/hisilicon/sec2/sec.h
@@ -119,6 +119,7 @@ struct sec_ctx {
 	struct sec_qp_ctx *qp_ctx;
 	struct sec_dev *sec;
 	const struct sec_req_op *req_op;
+	struct hisi_qp **qps;
 
 	/* Half queues for encipher, and half for decipher */
 	u32 hlf_q_num;
@@ -168,7 +169,6 @@ struct sec_debug {
 
 struct sec_dev {
 	struct hisi_qm qm;
-	struct list_head list;
 	struct sec_debug debug;
 	u32 ctx_q_num;
 	bool iommu_used;
@@ -176,7 +176,8 @@ struct sec_dev {
 	unsigned long status;
 };
 
-struct sec_dev *sec_find_device(int node);
+void sec_destroy_qps(struct hisi_qp **qps, int qp_num);
+struct hisi_qp **sec_create_qps(void);
 int sec_register_to_crypto(void);
 void sec_unregister_from_crypto(void);
 #endif
diff --git a/drivers/crypto/hisilicon/sec2/sec_crypto.c b/drivers/crypto/hisilicon/sec2/sec_crypto.c
index b2557431..7f1c6a3 100644
--- a/drivers/crypto/hisilicon/sec2/sec_crypto.c
+++ b/drivers/crypto/hisilicon/sec2/sec_crypto.c
@@ -355,11 +355,8 @@ static int sec_create_qp_ctx(struct hisi_qm *qm, struct sec_ctx *ctx,
 	struct hisi_qp *qp;
 	int ret = -ENOMEM;
 
-	qp = hisi_qm_create_qp(qm, alg_type);
-	if (IS_ERR(qp))
-		return PTR_ERR(qp);
-
 	qp_ctx = &ctx->qp_ctx[qp_ctx_id];
+	qp = ctx->qps[qp_ctx_id];
 	qp->req_type = 0;
 	qp->qp_ctx = qp_ctx;
 	qp->req_cb = sec_req_cb;
@@ -402,7 +399,6 @@ static int sec_create_qp_ctx(struct hisi_qm *qm, struct sec_ctx *ctx,
 	hisi_acc_free_sgl_pool(dev, qp_ctx->c_in_pool);
 err_destroy_idr:
 	idr_destroy(&qp_ctx->req_idr);
-	hisi_qm_release_qp(qp);
 
 	return ret;
 }
@@ -419,7 +415,6 @@ static void sec_release_qp_ctx(struct sec_ctx *ctx,
 	hisi_acc_free_sgl_pool(dev, qp_ctx->c_in_pool);
 
 	idr_destroy(&qp_ctx->req_idr);
-	hisi_qm_release_qp(qp_ctx->qp);
 }
 
 static int sec_ctx_base_init(struct sec_ctx *ctx)
@@ -427,11 +422,13 @@ static int sec_ctx_base_init(struct sec_ctx *ctx)
 	struct sec_dev *sec;
 	int i, ret;
 
-	sec = sec_find_device(cpu_to_node(smp_processor_id()));
-	if (!sec) {
-		pr_err("Can not find proper Hisilicon SEC device!\n");
+	ctx->qps = sec_create_qps();
+	if (!ctx->qps) {
+		pr_err("Can not create sec qps!\n");
 		return -ENODEV;
 	}
+
+	sec = container_of(ctx->qps[0]->qm, struct sec_dev, qm);
 	ctx->sec = sec;
 	ctx->hlf_q_num = sec->ctx_q_num >> 1;
 
@@ -455,6 +452,7 @@ static int sec_ctx_base_init(struct sec_ctx *ctx)
 	for (i = i - 1; i >= 0; i--)
 		sec_release_qp_ctx(ctx, &ctx->qp_ctx[i]);
 
+	sec_destroy_qps(ctx->qps, sec->ctx_q_num);
 	kfree(ctx->qp_ctx);
 	return ret;
 }
@@ -466,6 +464,7 @@ static void sec_ctx_base_uninit(struct sec_ctx *ctx)
 	for (i = 0; i < ctx->sec->ctx_q_num; i++)
 		sec_release_qp_ctx(ctx, &ctx->qp_ctx[i]);
 
+	sec_destroy_qps(ctx->qps, ctx->sec->ctx_q_num);
 	kfree(ctx->qp_ctx);
 }
 
diff --git a/drivers/crypto/hisilicon/sec2/sec_main.c b/drivers/crypto/hisilicon/sec2/sec_main.c
index 4f354d7..1f54ebe 100644
--- a/drivers/crypto/hisilicon/sec2/sec_main.c
+++ b/drivers/crypto/hisilicon/sec2/sec_main.c
@@ -90,8 +90,7 @@ struct sec_hw_error {
 
 static const char sec_name[] = "hisi_sec2";
 static struct dentry *sec_debugfs_root;
-static LIST_HEAD(sec_list);
-static DEFINE_MUTEX(sec_list_lock);
+static struct hisi_qm_list sec_devices;
 
 static const struct sec_hw_error sec_hw_errors[] = {
 	{.int_msk = BIT(0), .msg = "sec_axi_rresp_err_rint"},
@@ -106,37 +105,6 @@ static const struct sec_hw_error sec_hw_errors[] = {
 	{ /* sentinel */ }
 };
 
-struct sec_dev *sec_find_device(int node)
-{
-#define SEC_NUMA_MAX_DISTANCE	100
-	int min_distance = SEC_NUMA_MAX_DISTANCE;
-	int dev_node = 0, free_qp_num = 0;
-	struct sec_dev *sec, *ret = NULL;
-	struct hisi_qm *qm;
-	struct device *dev;
-
-	mutex_lock(&sec_list_lock);
-	list_for_each_entry(sec, &sec_list, list) {
-		qm = &sec->qm;
-		dev = &qm->pdev->dev;
-#ifdef CONFIG_NUMA
-		dev_node = dev->numa_node;
-		if (dev_node < 0)
-			dev_node = 0;
-#endif
-		if (node_distance(dev_node, node) < min_distance) {
-			free_qp_num = hisi_qm_get_free_qp_num(qm);
-			if (free_qp_num >= sec->ctx_q_num) {
-				ret = sec;
-				min_distance = node_distance(dev_node, node);
-			}
-		}
-	}
-	mutex_unlock(&sec_list_lock);
-
-	return ret;
-}
-
 static const char * const sec_dbg_file_name[] = {
 	[SEC_CURRENT_QM] = "current_qm",
 	[SEC_CLEAR_ENABLE] = "clear_enable",
@@ -239,6 +207,32 @@ static u32 ctx_q_num = SEC_CTX_Q_NUM_DEF;
 module_param_cb(ctx_q_num, &sec_ctx_q_num_ops, &ctx_q_num, 0444);
 MODULE_PARM_DESC(ctx_q_num, "Queue num in ctx (24 default, 2, 4, ..., 32)");
 
+void sec_destroy_qps(struct hisi_qp **qps, int qp_num)
+{
+	hisi_qm_free_qps(qps, qp_num);
+	kfree(qps);
+}
+
+struct hisi_qp **sec_create_qps(void)
+{
+	int node = cpu_to_node(smp_processor_id());
+	u32 ctx_num = ctx_q_num;
+	struct hisi_qp **qps;
+	int ret;
+
+	qps = kcalloc(ctx_num, sizeof(struct hisi_qp *), GFP_KERNEL);
+	if (!qps)
+		return NULL;
+
+	ret = hisi_qm_alloc_qps_node(&sec_devices, ctx_num, 0, node, qps);
+	if (!ret)
+		return qps;
+
+	kfree(qps);
+	return NULL;
+}
+
+
 static const struct pci_device_id sec_dev_ids[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_HUAWEI, SEC_PF_PCI_DEVICE_ID) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_HUAWEI, SEC_VF_PCI_DEVICE_ID) },
@@ -246,20 +240,6 @@ static const struct pci_device_id sec_dev_ids[] = {
 };
 MODULE_DEVICE_TABLE(pci, sec_dev_ids);
 
-static inline void sec_add_to_list(struct sec_dev *sec)
-{
-	mutex_lock(&sec_list_lock);
-	list_add_tail(&sec->list, &sec_list);
-	mutex_unlock(&sec_list_lock);
-}
-
-static inline void sec_remove_from_list(struct sec_dev *sec)
-{
-	mutex_lock(&sec_list_lock);
-	list_del(&sec->list);
-	mutex_unlock(&sec_list_lock);
-}
-
 static u8 sec_get_endian(struct sec_dev *sec)
 {
 	struct hisi_qm *qm = &sec->qm;
@@ -889,7 +869,7 @@ static int sec_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (ret)
 		pci_warn(pdev, "Failed to init debugfs!\n");
 
-	sec_add_to_list(sec);
+	hisi_qm_add_to_list(qm, &sec_devices);
 
 	ret = sec_register_to_crypto();
 	if (ret < 0) {
@@ -900,7 +880,7 @@ static int sec_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	return 0;
 
 err_remove_from_list:
-	sec_remove_from_list(sec);
+	hisi_qm_del_from_list(qm, &sec_devices);
 	sec_debugfs_exit(sec);
 	hisi_qm_stop(qm);
 
@@ -1024,7 +1004,7 @@ static void sec_remove(struct pci_dev *pdev)
 
 	sec_unregister_from_crypto();
 
-	sec_remove_from_list(sec);
+	hisi_qm_del_from_list(qm, &sec_devices);
 
 	if (qm->fun_type == QM_HW_PF && sec->num_vfs)
 		(void)sec_sriov_disable(pdev);
@@ -1071,6 +1051,7 @@ static int __init sec_init(void)
 {
 	int ret;
 
+	hisi_qm_init_list(&sec_devices);
 	sec_register_debugfs();
 
 	ret = pci_register_driver(&sec_pci_driver);
-- 
2.7.4

