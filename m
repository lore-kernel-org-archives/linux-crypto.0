Return-Path: <SRS0=WWUc=4V=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D582C3F2D1
	for <linux-crypto@archiver.kernel.org>; Wed,  4 Mar 2020 07:50:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 60732215A4
	for <linux-crypto@archiver.kernel.org>; Wed,  4 Mar 2020 07:50:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728515AbgCDHuF (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 4 Mar 2020 02:50:05 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:36688 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728486AbgCDHuF (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 4 Mar 2020 02:50:05 -0500
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 5FA3C340407BAE123579;
        Wed,  4 Mar 2020 15:50:02 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.439.0; Wed, 4 Mar 2020 15:49:51 +0800
From:   Shukun Tan <tanshukun1@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <xuzaibo@huawei.com>,
        <wangzhou1@hisilicon.com>, <jonathan.cameron@huawei.com>
Subject: [PATCH 1/4] crypto: hisilicon/qm - Put device finding logic into QM
Date:   Wed, 4 Mar 2020 15:49:22 +0800
Message-ID: <1583308165-16800-2-git-send-email-tanshukun1@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1583308165-16800-1-git-send-email-tanshukun1@huawei.com>
References: <1583308165-16800-1-git-send-email-tanshukun1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Weili Qian <qianweili@huawei.com>

Use struct hisi_qm to maintain device list. Meanwhile, add two external
interface into qm, merge find proper device and create qp into QP alloc
logic, merge release qps into QP free logic.

Signed-off-by: Weili Qian <qianweili@huawei.com>
Signed-off-by: Shukun Tan <tanshukun1@huawei.com>
Reviewed-by: Zhou Wang <wangzhou1@hisilicon.com>
Reviewed-by: Zaibo Xu <xuzaibo@huawei.com>
---
 drivers/crypto/hisilicon/qm.c | 125 ++++++++++++++++++++++++++++++++++++++++++
 drivers/crypto/hisilicon/qm.h |  31 +++++++++++
 2 files changed, 156 insertions(+)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index ad7146a..f610c1a 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -272,6 +272,12 @@ struct qm_doorbell {
 	__le16 priority;
 };
 
+struct hisi_qm_resource {
+	struct hisi_qm *qm;
+	int distance;
+	struct list_head list;
+};
+
 struct hisi_qm_hw_ops {
 	int (*get_vft)(struct hisi_qm *qm, u32 *base, u32 *number);
 	void (*qm_db)(struct hisi_qm *qm, u16 qn,
@@ -2181,6 +2187,125 @@ void hisi_qm_dev_err_uninit(struct hisi_qm *qm)
 }
 EXPORT_SYMBOL_GPL(hisi_qm_dev_err_uninit);
 
+/**
+ * hisi_qm_free_qps() - free multiple queue pairs.
+ * @qps: The queue pairs need to be freed.
+ * @qp_num: The num of queue pairs.
+ */
+void hisi_qm_free_qps(struct hisi_qp **qps, int qp_num)
+{
+	int i;
+
+	if (!qps || qp_num <= 0)
+		return;
+
+	for (i = qp_num - 1; i >= 0; i--)
+		hisi_qm_release_qp(qps[i]);
+}
+EXPORT_SYMBOL_GPL(hisi_qm_free_qps);
+
+static void free_list(struct list_head *head)
+{
+	struct hisi_qm_resource *res, *tmp;
+
+	list_for_each_entry_safe(res, tmp, head, list) {
+		list_del(&res->list);
+		kfree(res);
+	}
+}
+
+static int hisi_qm_sort_devices(int node, struct list_head *head,
+				struct hisi_qm_list *qm_list)
+{
+	struct hisi_qm_resource *res, *tmp;
+	struct hisi_qm *qm;
+	struct list_head *n;
+	struct device *dev;
+	int dev_node = 0;
+
+	list_for_each_entry(qm, &qm_list->list, list) {
+		dev = &qm->pdev->dev;
+
+		if (IS_ENABLED(CONFIG_NUMA)) {
+			dev_node = dev->numa_node;
+			if (dev_node < 0)
+				dev_node = 0;
+		}
+
+		res = kzalloc(sizeof(*res), GFP_KERNEL);
+		if (!res)
+			return -ENOMEM;
+
+		res->qm = qm;
+		res->distance = node_distance(dev_node, node);
+		n = head;
+		list_for_each_entry(tmp, head, list) {
+			if (res->distance < tmp->distance) {
+				n = &tmp->list;
+				break;
+			}
+		}
+		list_add_tail(&res->list, n);
+	}
+
+	return 0;
+}
+
+/**
+ * hisi_qm_alloc_qps_node() - Create multiple queue pairs.
+ * @qm_list: The list of all available devices.
+ * @qp_num: The number of queue pairs need created.
+ * @alg_type: The algorithm type.
+ * @node: The numa node.
+ * @qps: The queue pairs need created.
+ *
+ * This function will sort all available device according to numa distance.
+ * Then try to create all queue pairs from one device, if all devices do
+ * not meet the requirements will return error.
+ */
+int hisi_qm_alloc_qps_node(struct hisi_qm_list *qm_list, int qp_num,
+			   u8 alg_type, int node, struct hisi_qp **qps)
+{
+	struct hisi_qm_resource *tmp;
+	int ret = -ENODEV;
+	LIST_HEAD(head);
+	int i;
+
+	if (!qps || !qm_list || qp_num <= 0)
+		return -EINVAL;
+
+	mutex_lock(&qm_list->lock);
+	if (hisi_qm_sort_devices(node, &head, qm_list)) {
+		mutex_unlock(&qm_list->lock);
+		goto err;
+	}
+
+	list_for_each_entry(tmp, &head, list) {
+		for (i = 0; i < qp_num; i++) {
+			qps[i] = hisi_qm_create_qp(tmp->qm, alg_type);
+			if (IS_ERR(qps[i])) {
+				hisi_qm_free_qps(qps, i);
+				break;
+			}
+		}
+
+		if (i == qp_num) {
+			ret = 0;
+			break;
+		}
+	}
+
+	mutex_unlock(&qm_list->lock);
+	if (ret)
+		pr_info("Failed to create qps, node[%d], alg[%d], qp[%d]!\n",
+			node, alg_type, qp_num);
+
+err:
+	free_list(&head);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(hisi_qm_alloc_qps_node);
+
 static pci_ers_result_t qm_dev_err_handle(struct hisi_qm *qm)
 {
 	u32 err_sts;
diff --git a/drivers/crypto/hisilicon/qm.h b/drivers/crypto/hisilicon/qm.h
index 1a4f208..a29c856 100644
--- a/drivers/crypto/hisilicon/qm.h
+++ b/drivers/crypto/hisilicon/qm.h
@@ -145,6 +145,11 @@ struct hisi_qm_err_ini {
 	struct hisi_qm_err_info err_info;
 };
 
+struct hisi_qm_list {
+	struct mutex lock;
+	struct list_head list;
+};
+
 struct hisi_qm {
 	enum qm_hw_ver ver;
 	enum qm_fun_type fun_type;
@@ -156,6 +161,7 @@ struct hisi_qm {
 	u32 qp_num;
 	u32 qp_in_used;
 	u32 ctrl_qp_num;
+	struct list_head list;
 
 	struct qm_dma qdma;
 	struct qm_sqc *sqc;
@@ -227,6 +233,28 @@ struct hisi_qp {
 	struct uacce_queue *uacce_q;
 };
 
+static inline void hisi_qm_init_list(struct hisi_qm_list *qm_list)
+{
+	INIT_LIST_HEAD(&qm_list->list);
+	mutex_init(&qm_list->lock);
+}
+
+static inline void hisi_qm_add_to_list(struct hisi_qm *qm,
+				       struct hisi_qm_list *qm_list)
+{
+	mutex_lock(&qm_list->lock);
+	list_add_tail(&qm->list, &qm_list->list);
+	mutex_unlock(&qm_list->lock);
+}
+
+static inline void hisi_qm_del_from_list(struct hisi_qm *qm,
+					 struct hisi_qm_list *qm_list)
+{
+	mutex_lock(&qm_list->lock);
+	list_del(&qm->list);
+	mutex_unlock(&qm_list->lock);
+}
+
 int hisi_qm_init(struct hisi_qm *qm);
 void hisi_qm_uninit(struct hisi_qm *qm);
 int hisi_qm_start(struct hisi_qm *qm);
@@ -257,4 +285,7 @@ struct hisi_acc_sgl_pool *hisi_acc_create_sgl_pool(struct device *dev,
 						   u32 count, u32 sge_nr);
 void hisi_acc_free_sgl_pool(struct device *dev,
 			    struct hisi_acc_sgl_pool *pool);
+int hisi_qm_alloc_qps_node(struct hisi_qm_list *qm_list, int qp_num,
+			   u8 alg_type, int node, struct hisi_qp **qps);
+void hisi_qm_free_qps(struct hisi_qp **qps, int qp_num);
 #endif
-- 
2.7.4

