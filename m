Return-Path: <SRS0=2cET=YT=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EC73CA9EA0
	for <linux-crypto@archiver.kernel.org>; Sat, 26 Oct 2019 03:03:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 41C402084C
	for <linux-crypto@archiver.kernel.org>; Sat, 26 Oct 2019 03:03:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725996AbfJZDDo (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 25 Oct 2019 23:03:44 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:4768 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725957AbfJZDDo (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 25 Oct 2019 23:03:44 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id B5A84C3A69801D206578;
        Sat, 26 Oct 2019 11:03:42 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.439.0; Sat, 26 Oct 2019 11:03:35 +0800
From:   Zhou Wang <wangzhou1@hisilicon.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>,
        Zhou Wang <wangzhou1@hisilicon.com>,
        Shukun Tan <tanshukun1@huawei.com>
Subject: [PATCH] crypto: hisilicon - fix to return sub-optimal device when best device has no qps
Date:   Sat, 26 Oct 2019 11:00:16 +0800
Message-ID: <1572058816-185603-1-git-send-email-wangzhou1@hisilicon.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Currently find_zip_device() finds zip device which has the min NUMA
distance with current CPU.

This patch modifies find_zip_device to return sub-optimal device when best
device has no qps. This patch sorts all devices by NUMA distance, then
finds the best zip device which has free qp.

Signed-off-by: Zhou Wang <wangzhou1@hisilicon.com>
Signed-off-by: Shukun Tan <tanshukun1@huawei.com>
---
 drivers/crypto/hisilicon/qm.c           | 21 ++++++++++
 drivers/crypto/hisilicon/qm.h           |  2 +
 drivers/crypto/hisilicon/zip/zip_main.c | 74 ++++++++++++++++++++++++---------
 3 files changed, 77 insertions(+), 20 deletions(-)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index 4dc8825..ab0743c 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -1127,6 +1127,7 @@ struct hisi_qp *hisi_qm_create_qp(struct hisi_qm *qm, u8 alg_type)
 	}
 	set_bit(qp_id, qm->qp_bitmap);
 	qm->qp_array[qp_id] = qp;
+	qm->qp_in_used++;
 
 	write_unlock(&qm->qps_lock);
 
@@ -1191,6 +1192,7 @@ void hisi_qm_release_qp(struct hisi_qp *qp)
 	write_lock(&qm->qps_lock);
 	qm->qp_array[qp->qp_id] = NULL;
 	clear_bit(qp->qp_id, qm->qp_bitmap);
+	qm->qp_in_used--;
 	write_unlock(&qm->qps_lock);
 
 	kfree(qp);
@@ -1396,6 +1398,24 @@ static void hisi_qm_cache_wb(struct hisi_qm *qm)
 }
 
 /**
+ * hisi_qm_get_free_qp_num() - Get free number of qp in qm.
+ * @qm: The qm which want to get free qp.
+ *
+ * This function return free number of qp in qm.
+ */
+int hisi_qm_get_free_qp_num(struct hisi_qm *qm)
+{
+	int ret;
+
+	read_lock(&qm->qps_lock);
+	ret = qm->qp_num - qm->qp_in_used;
+	read_unlock(&qm->qps_lock);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(hisi_qm_get_free_qp_num);
+
+/**
  * hisi_qm_init() - Initialize configures about qm.
  * @qm: The qm needing init.
  *
@@ -1458,6 +1478,7 @@ int hisi_qm_init(struct hisi_qm *qm)
 	if (ret)
 		goto err_free_irq_vectors;
 
+	qm->qp_in_used = 0;
 	mutex_init(&qm->mailbox_lock);
 	rwlock_init(&qm->qps_lock);
 
diff --git a/drivers/crypto/hisilicon/qm.h b/drivers/crypto/hisilicon/qm.h
index 61064bd..078b8f1 100644
--- a/drivers/crypto/hisilicon/qm.h
+++ b/drivers/crypto/hisilicon/qm.h
@@ -134,6 +134,7 @@ struct hisi_qm {
 	u32 sqe_size;
 	u32 qp_base;
 	u32 qp_num;
+	u32 qp_in_used;
 	u32 ctrl_qp_num;
 
 	struct qm_dma qdma;
@@ -206,6 +207,7 @@ int hisi_qm_start_qp(struct hisi_qp *qp, unsigned long arg);
 int hisi_qm_stop_qp(struct hisi_qp *qp);
 void hisi_qm_release_qp(struct hisi_qp *qp);
 int hisi_qp_send(struct hisi_qp *qp, const void *msg);
+int hisi_qm_get_free_qp_num(struct hisi_qm *qm);
 int hisi_qm_get_vft(struct hisi_qm *qm, u32 *base, u32 *number);
 int hisi_qm_set_vft(struct hisi_qm *qm, u32 fun_num, u32 base, u32 number);
 int hisi_qm_debug_init(struct hisi_qm *qm);
diff --git a/drivers/crypto/hisilicon/zip/zip_main.c b/drivers/crypto/hisilicon/zip/zip_main.c
index 9f45bb5..255b63c 100644
--- a/drivers/crypto/hisilicon/zip/zip_main.c
+++ b/drivers/crypto/hisilicon/zip/zip_main.c
@@ -79,7 +79,6 @@
 #define HZIP_SOFT_CTRL_CNT_CLR_CE	0x301000
 #define SOFT_CTRL_CNT_CLR_CE_BIT	BIT(0)
 
-#define HZIP_NUMA_DISTANCE		100
 #define HZIP_BUF_SIZE			22
 
 static const char hisi_zip_name[] = "hisi_zip";
@@ -87,39 +86,74 @@ static struct dentry *hzip_debugfs_root;
 static LIST_HEAD(hisi_zip_list);
 static DEFINE_MUTEX(hisi_zip_list_lock);
 
-#ifdef CONFIG_NUMA
-static struct hisi_zip *find_zip_device_numa(int node)
+struct hisi_zip_resource {
+	struct hisi_zip *hzip;
+	int distance;
+	struct list_head list;
+};
+
+static void free_list(struct list_head *head)
 {
-	struct hisi_zip *zip = NULL;
+	struct hisi_zip_resource *res, *tmp;
+
+	list_for_each_entry_safe(res, tmp, head, list) {
+		list_del(&res->list);
+		kfree(res);
+	}
+}
+
+struct hisi_zip *find_zip_device(int node)
+{
+	struct hisi_zip *ret = NULL;
+#ifdef CONFIG_NUMA
+	struct hisi_zip_resource *res, *tmp;
 	struct hisi_zip *hisi_zip;
-	int min_distance = HZIP_NUMA_DISTANCE;
+	struct list_head *n;
 	struct device *dev;
+	LIST_HEAD(head);
+
+	mutex_lock(&hisi_zip_list_lock);
 
 	list_for_each_entry(hisi_zip, &hisi_zip_list, list) {
+		res = kzalloc(sizeof(*res), GFP_KERNEL);
+		if (!res)
+			goto err;
+
 		dev = &hisi_zip->qm.pdev->dev;
-		if (node_distance(dev->numa_node, node) < min_distance) {
-			zip = hisi_zip;
-			min_distance = node_distance(dev->numa_node, node);
+		res->hzip = hisi_zip;
+		res->distance = node_distance(dev->numa_node, node);
+
+		n = &head;
+		list_for_each_entry(tmp, &head, list) {
+			if (res->distance < tmp->distance) {
+				n = &tmp->list;
+				break;
+			}
 		}
+		list_add_tail(&res->list, n);
 	}
 
-	return zip;
-}
-#endif
-
-struct hisi_zip *find_zip_device(int node)
-{
-	struct hisi_zip *zip = NULL;
+	list_for_each_entry(tmp, &head, list) {
+		if (hisi_qm_get_free_qp_num(&tmp->hzip->qm)) {
+			ret = tmp->hzip;
+			break;
+		}
+	}
 
-	mutex_lock(&hisi_zip_list_lock);
-#ifdef CONFIG_NUMA
-	zip = find_zip_device_numa(node);
+	free_list(&head);
 #else
-	zip = list_first_entry(&hisi_zip_list, struct hisi_zip, list);
+	mutex_lock(&hisi_zip_list_lock);
+
+	ret = list_first_entry(&hisi_zip_list, struct hisi_zip, list);
 #endif
 	mutex_unlock(&hisi_zip_list_lock);
 
-	return zip;
+	return ret;
+
+err:
+	free_list(&head);
+	mutex_unlock(&hisi_zip_list_lock);
+	return NULL;
 }
 
 struct hisi_zip_hw_error {
-- 
2.8.1

