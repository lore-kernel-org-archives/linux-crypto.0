Return-Path: <SRS0=WWUc=4V=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3E36C3F2D7
	for <linux-crypto@archiver.kernel.org>; Wed,  4 Mar 2020 07:50:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D0D90215A4
	for <linux-crypto@archiver.kernel.org>; Wed,  4 Mar 2020 07:50:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728530AbgCDHuF (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 4 Mar 2020 02:50:05 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:36700 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728515AbgCDHuE (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 4 Mar 2020 02:50:04 -0500
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 695A4F088EA1DFB03776;
        Wed,  4 Mar 2020 15:50:02 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.439.0; Wed, 4 Mar 2020 15:49:52 +0800
From:   Shukun Tan <tanshukun1@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <xuzaibo@huawei.com>,
        <wangzhou1@hisilicon.com>, <jonathan.cameron@huawei.com>
Subject: [PATCH 2/4] crypto: hisilicon/zip - Use hisi_qm_alloc_qps_node() when init ctx
Date:   Wed, 4 Mar 2020 15:49:23 +0800
Message-ID: <1583308165-16800-3-git-send-email-tanshukun1@huawei.com>
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

Encapsulate hisi_qm_alloc_qps_node() to new interface to replace
find_zip_device(), which will fix the bug of creating QP failure
especially in multi-thread scenario.

Signed-off-by: Shukun Tan <tanshukun1@huawei.com>
Reviewed-by: Zhou Wang <wangzhou1@hisilicon.com>
Reviewed-by: Zaibo Xu <xuzaibo@huawei.com>
---
 drivers/crypto/hisilicon/zip/zip.h        |  2 +-
 drivers/crypto/hisilicon/zip/zip_crypto.c | 54 +++++++++---------
 drivers/crypto/hisilicon/zip/zip_main.c   | 92 +++----------------------------
 3 files changed, 34 insertions(+), 114 deletions(-)

diff --git a/drivers/crypto/hisilicon/zip/zip.h b/drivers/crypto/hisilicon/zip/zip.h
index bc1db26..82dc6f8 100644
--- a/drivers/crypto/hisilicon/zip/zip.h
+++ b/drivers/crypto/hisilicon/zip/zip.h
@@ -68,7 +68,7 @@ struct hisi_zip_sqe {
 	u32 rsvd1[4];
 };
 
-struct hisi_zip *find_zip_device(int node);
+int zip_create_qps(struct hisi_qp **qps, int ctx_num);
 int hisi_zip_register_to_crypto(void);
 void hisi_zip_unregister_from_crypto(void);
 #endif
diff --git a/drivers/crypto/hisilicon/zip/zip_crypto.c b/drivers/crypto/hisilicon/zip/zip_crypto.c
index 9815d5e..369ec32 100644
--- a/drivers/crypto/hisilicon/zip/zip_crypto.c
+++ b/drivers/crypto/hisilicon/zip/zip_crypto.c
@@ -132,29 +132,25 @@ static void hisi_zip_fill_sqe(struct hisi_zip_sqe *sqe, u8 req_type,
 	sqe->dest_addr_h = upper_32_bits(d_addr);
 }
 
-static int hisi_zip_create_qp(struct hisi_qm *qm, struct hisi_zip_qp_ctx *ctx,
-			      int alg_type, int req_type)
+static int hisi_zip_start_qp(struct hisi_qp *qp, struct hisi_zip_qp_ctx *ctx,
+			     int alg_type, int req_type)
 {
-	struct hisi_qp *qp;
+	struct device *dev = &qp->qm->pdev->dev;
 	int ret;
 
-	qp = hisi_qm_create_qp(qm, alg_type);
-	if (IS_ERR(qp))
-		return PTR_ERR(qp);
-
 	qp->req_type = req_type;
+	qp->alg_type = alg_type;
 	qp->qp_ctx = ctx;
-	ctx->qp = qp;
 
 	ret = hisi_qm_start_qp(qp, 0);
-	if (ret < 0)
-		goto err_release_qp;
+	if (ret < 0) {
+		dev_err(dev, "start qp failed!\n");
+		return ret;
+	}
 
-	return 0;
+	ctx->qp = qp;
 
-err_release_qp:
-	hisi_qm_release_qp(qp);
-	return ret;
+	return 0;
 }
 
 static void hisi_zip_release_qp(struct hisi_zip_qp_ctx *ctx)
@@ -165,34 +161,34 @@ static void hisi_zip_release_qp(struct hisi_zip_qp_ctx *ctx)
 
 static int hisi_zip_ctx_init(struct hisi_zip_ctx *hisi_zip_ctx, u8 req_type)
 {
+	struct hisi_qp *qps[HZIP_CTX_Q_NUM] = { NULL };
 	struct hisi_zip *hisi_zip;
-	struct hisi_qm *qm;
 	int ret, i, j;
 
-	/* find the proper zip device */
-	hisi_zip = find_zip_device(cpu_to_node(smp_processor_id()));
-	if (!hisi_zip) {
-		pr_err("Failed to find a proper ZIP device!\n");
+	ret = zip_create_qps(qps, HZIP_CTX_Q_NUM);
+	if (ret) {
+		pr_err("Can not create zip qps!\n");
 		return -ENODEV;
 	}
-	qm = &hisi_zip->qm;
+
+	hisi_zip = container_of(qps[0]->qm, struct hisi_zip, qm);
 
 	for (i = 0; i < HZIP_CTX_Q_NUM; i++) {
 		/* alg_type = 0 for compress, 1 for decompress in hw sqe */
-		ret = hisi_zip_create_qp(qm, &hisi_zip_ctx->qp_ctx[i], i,
-					 req_type);
-		if (ret)
-			goto err;
+		ret = hisi_zip_start_qp(qps[i], &hisi_zip_ctx->qp_ctx[i], i,
+					req_type);
+		if (ret) {
+			for (j = i - 1; j >= 0; j--)
+				hisi_qm_stop_qp(hisi_zip_ctx->qp_ctx[j].qp);
+
+			hisi_qm_free_qps(qps, HZIP_CTX_Q_NUM);
+			return ret;
+		}
 
 		hisi_zip_ctx->qp_ctx[i].zip_dev = hisi_zip;
 	}
 
 	return 0;
-err:
-	for (j = i - 1; j >= 0; j--)
-		hisi_zip_release_qp(&hisi_zip_ctx->qp_ctx[j]);
-
-	return ret;
 }
 
 static void hisi_zip_ctx_exit(struct hisi_zip_ctx *hisi_zip_ctx)
diff --git a/drivers/crypto/hisilicon/zip/zip_main.c b/drivers/crypto/hisilicon/zip/zip_main.c
index 25a3112..fcc85d2 100644
--- a/drivers/crypto/hisilicon/zip/zip_main.c
+++ b/drivers/crypto/hisilicon/zip/zip_main.c
@@ -88,77 +88,7 @@
 
 static const char hisi_zip_name[] = "hisi_zip";
 static struct dentry *hzip_debugfs_root;
-static LIST_HEAD(hisi_zip_list);
-static DEFINE_MUTEX(hisi_zip_list_lock);
-
-struct hisi_zip_resource {
-	struct hisi_zip *hzip;
-	int distance;
-	struct list_head list;
-};
-
-static void free_list(struct list_head *head)
-{
-	struct hisi_zip_resource *res, *tmp;
-
-	list_for_each_entry_safe(res, tmp, head, list) {
-		list_del(&res->list);
-		kfree(res);
-	}
-}
-
-struct hisi_zip *find_zip_device(int node)
-{
-	struct hisi_zip_resource *res, *tmp;
-	struct hisi_zip *ret = NULL;
-	struct hisi_zip *hisi_zip;
-	struct list_head *n;
-	struct device *dev;
-	LIST_HEAD(head);
-
-	mutex_lock(&hisi_zip_list_lock);
-
-	if (IS_ENABLED(CONFIG_NUMA)) {
-		list_for_each_entry(hisi_zip, &hisi_zip_list, list) {
-			res = kzalloc(sizeof(*res), GFP_KERNEL);
-			if (!res)
-				goto err;
-
-			dev = &hisi_zip->qm.pdev->dev;
-			res->hzip = hisi_zip;
-			res->distance = node_distance(dev_to_node(dev), node);
-
-			n = &head;
-			list_for_each_entry(tmp, &head, list) {
-				if (res->distance < tmp->distance) {
-					n = &tmp->list;
-					break;
-				}
-			}
-			list_add_tail(&res->list, n);
-		}
-
-		list_for_each_entry(tmp, &head, list) {
-			if (hisi_qm_get_free_qp_num(&tmp->hzip->qm)) {
-				ret = tmp->hzip;
-				break;
-			}
-		}
-
-		free_list(&head);
-	} else {
-		ret = list_first_entry(&hisi_zip_list, struct hisi_zip, list);
-	}
-
-	mutex_unlock(&hisi_zip_list_lock);
-
-	return ret;
-
-err:
-	free_list(&head);
-	mutex_unlock(&hisi_zip_list_lock);
-	return NULL;
-}
+static struct hisi_qm_list zip_devices;
 
 struct hisi_zip_hw_error {
 	u32 int_msk;
@@ -313,18 +243,11 @@ static const struct pci_device_id hisi_zip_dev_ids[] = {
 };
 MODULE_DEVICE_TABLE(pci, hisi_zip_dev_ids);
 
-static inline void hisi_zip_add_to_list(struct hisi_zip *hisi_zip)
+int zip_create_qps(struct hisi_qp **qps, int qp_num)
 {
-	mutex_lock(&hisi_zip_list_lock);
-	list_add_tail(&hisi_zip->list, &hisi_zip_list);
-	mutex_unlock(&hisi_zip_list_lock);
-}
+	int node = cpu_to_node(smp_processor_id());
 
-static inline void hisi_zip_remove_from_list(struct hisi_zip *hisi_zip)
-{
-	mutex_lock(&hisi_zip_list_lock);
-	list_del(&hisi_zip->list);
-	mutex_unlock(&hisi_zip_list_lock);
+	return hisi_qm_alloc_qps_node(&zip_devices, qp_num, 0, node, qps);
 }
 
 static void hisi_zip_set_user_domain_and_cache(struct hisi_zip *hisi_zip)
@@ -891,7 +814,7 @@ static int hisi_zip_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (ret)
 		dev_err(&pdev->dev, "Failed to init debugfs (%d)!\n", ret);
 
-	hisi_zip_add_to_list(hisi_zip);
+	hisi_qm_add_to_list(qm, &zip_devices);
 
 	if (qm->uacce) {
 		ret = uacce_register(qm->uacce);
@@ -908,7 +831,7 @@ static int hisi_zip_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	return 0;
 
 err_remove_from_list:
-	hisi_zip_remove_from_list(hisi_zip);
+	hisi_qm_del_from_list(qm, &zip_devices);
 	hisi_zip_debugfs_exit(hisi_zip);
 	hisi_qm_stop(qm);
 err_qm_uninit:
@@ -937,7 +860,7 @@ static void hisi_zip_remove(struct pci_dev *pdev)
 
 	hisi_qm_dev_err_uninit(qm);
 	hisi_qm_uninit(qm);
-	hisi_zip_remove_from_list(hisi_zip);
+	hisi_qm_del_from_list(qm, &zip_devices);
 }
 
 static const struct pci_error_handlers hisi_zip_err_handler = {
@@ -971,6 +894,7 @@ static int __init hisi_zip_init(void)
 {
 	int ret;
 
+	hisi_qm_init_list(&zip_devices);
 	hisi_zip_register_debugfs();
 
 	ret = pci_register_driver(&hisi_zip_pci_driver);
-- 
2.7.4

