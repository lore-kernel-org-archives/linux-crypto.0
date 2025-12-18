Received: from canpmsgout09.his.huawei.com (canpmsgout09.his.huawei.com [113.46.200.224])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C64C530E854;
	Thu, 18 Dec 2025 13:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.224
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766065501; cv=none; b=u1JLKA9/hN+Jy/eafk5tqEqNnrK5UxmCZX4A3mTDJ4/GSyRlfCLx12CUEBlcl7i1wpwK2pnPp+LW7Awtd8OvxJImujgDi3WYh5xlbLeXlizf1NKFBSdyFX+gYUqpBxQxiM2j1hVTpX/0wRT/azF8m/gPtrmPTkwyyNsVmJeW2TQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766065501; c=relaxed/simple;
	bh=oWd+b1biUhr5+ZZe7pFkxU6fsYxi9jHmUJ5g0E0SlSg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=k9ciJo4IE70tM2fxZjU72YXXZIEJNTA1v5x6jfWJU5PFwxPiRVJ2OwOQLvwBcSNaAa84SxOlQDWqRgGlJQvACxrJgNSvV07oywmfbcQtZD7zHBqDd2uPxYhlZjQosb77saseDBvL3FYYcSGDWEKC8jyYRrdWruTrFyPvkQOZ07o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=YhzUe4y8; arc=none smtp.client-ip=113.46.200.224
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="YhzUe4y8"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=GXQ1eFoWjwuKcbWdnV+rMruIPun7+UFKdLNIdyMG4BU=;
	b=YhzUe4y84QdauGm0Pc7MtlTtlXt9kyDQjsyqnToA0dqTqV1NuZYCYNsWgGozCdBeYPJSghjBm
	agMiZsKz/dLqeGEMiWVZLoq65YuInzwGverus75MFTOP/EOeaESR+qASYUCek9bZmNRa9TvhYy8
	58l5al8iNJbHro7d7grTAyU=
Received: from mail.maildlp.com (unknown [172.19.88.163])
	by canpmsgout09.his.huawei.com (SkyGuard) with ESMTPS id 4dXBfT1M8Lz1cyPb;
	Thu, 18 Dec 2025 21:41:53 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 12C941800D0;
	Thu, 18 Dec 2025 21:44:56 +0800 (CST)
Received: from kwepemq200001.china.huawei.com (7.202.195.16) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 18 Dec 2025 21:44:55 +0800
Received: from localhost.huawei.com (10.90.31.46) by
 kwepemq200001.china.huawei.com (7.202.195.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 18 Dec 2025 21:44:54 +0800
From: Chenghai Huang <huangchenghai2@huawei.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<fanghao11@huawei.com>, <liulongfang@huawei.com>, <qianweili@huawei.com>,
	<linwenkai6@hisilicon.com>, <wangzhou1@hisilicon.com>, <lizhi206@huawei.com>,
	<taoqi10@huawei.com>
Subject: [PATCH v4 04/11] crypto: hisilicon/qm - enhance the configuration of req_type in queue attributes
Date: Thu, 18 Dec 2025 21:44:45 +0800
Message-ID: <20251218134452.1125469-5-huangchenghai2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20251218134452.1125469-1-huangchenghai2@huawei.com>
References: <20251218134452.1125469-1-huangchenghai2@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemq200001.china.huawei.com (7.202.195.16)

Originally, when a queue was requested, it could only be configured
with the default algorithm type of 0. Now, when multiple tfms use
the same queue, the queue must be selected based on its attributes
to meet the requirements of tfm tasks. So the algorithm type
attribute of queue need to be distinguished. Just like a queue used
for compression in ZIP cannot be used for decompression tasks.

Fixes: 3f1ec97aacf1 ("crypto: hisilicon/qm - Put device finding logic into QM")
Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
Signed-off-by: Weili Qian <qianweili@huawei.com>
---
 drivers/crypto/hisilicon/hpre/hpre_main.c  |  2 +-
 drivers/crypto/hisilicon/qm.c              |  8 ++++----
 drivers/crypto/hisilicon/sec2/sec_crypto.c |  1 -
 drivers/crypto/hisilicon/sec2/sec_main.c   | 21 ++++++++++++++++-----
 drivers/crypto/hisilicon/zip/zip.h         |  2 +-
 drivers/crypto/hisilicon/zip/zip_crypto.c  | 13 +++++++++----
 drivers/crypto/hisilicon/zip/zip_main.c    |  4 ++--
 include/linux/hisi_acc_qm.h                |  3 +--
 8 files changed, 34 insertions(+), 20 deletions(-)

diff --git a/drivers/crypto/hisilicon/hpre/hpre_main.c b/drivers/crypto/hisilicon/hpre/hpre_main.c
index b94fecd765ee..884d5d0afaf4 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_main.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_main.c
@@ -465,7 +465,7 @@ struct hisi_qp *hpre_create_qp(u8 type)
 	 * type: 0 - RSA/DH. algorithm supported in V2,
 	 *       1 - ECC algorithm in V3.
 	 */
-	ret = hisi_qm_alloc_qps_node(&hpre_devices, 1, type, node, &qp);
+	ret = hisi_qm_alloc_qps_node(&hpre_devices, 1, &type, node, &qp);
 	if (!ret)
 		return qp;
 
diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index 4760551d4fa3..50c32e69bd28 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -3595,7 +3595,7 @@ static int hisi_qm_sort_devices(int node, struct list_head *head,
  * not meet the requirements will return error.
  */
 int hisi_qm_alloc_qps_node(struct hisi_qm_list *qm_list, int qp_num,
-			   u8 alg_type, int node, struct hisi_qp **qps)
+			   u8 *alg_type, int node, struct hisi_qp **qps)
 {
 	struct hisi_qm_resource *tmp;
 	int ret = -ENODEV;
@@ -3613,7 +3613,7 @@ int hisi_qm_alloc_qps_node(struct hisi_qm_list *qm_list, int qp_num,
 
 	list_for_each_entry(tmp, &head, list) {
 		for (i = 0; i < qp_num; i++) {
-			qps[i] = hisi_qm_create_qp(tmp->qm, alg_type);
+			qps[i] = hisi_qm_create_qp(tmp->qm, alg_type[i]);
 			if (IS_ERR(qps[i])) {
 				hisi_qm_free_qps(qps, i);
 				break;
@@ -3628,8 +3628,8 @@ int hisi_qm_alloc_qps_node(struct hisi_qm_list *qm_list, int qp_num,
 
 	mutex_unlock(&qm_list->lock);
 	if (ret)
-		pr_info("Failed to create qps, node[%d], alg[%u], qp[%d]!\n",
-			node, alg_type, qp_num);
+		pr_info("Failed to create qps, node[%d], qp[%d]!\n",
+			node, qp_num);
 
 err:
 	free_list(&head);
diff --git a/drivers/crypto/hisilicon/sec2/sec_crypto.c b/drivers/crypto/hisilicon/sec2/sec_crypto.c
index 4e41235116e1..364bd69c6088 100644
--- a/drivers/crypto/hisilicon/sec2/sec_crypto.c
+++ b/drivers/crypto/hisilicon/sec2/sec_crypto.c
@@ -626,7 +626,6 @@ static int sec_create_qp_ctx(struct sec_ctx *ctx, int qp_ctx_id)
 
 	qp_ctx = &ctx->qp_ctx[qp_ctx_id];
 	qp = ctx->qps[qp_ctx_id];
-	qp->req_type = 0;
 	qp->qp_ctx = qp_ctx;
 	qp_ctx->qp = qp;
 	qp_ctx->ctx = ctx;
diff --git a/drivers/crypto/hisilicon/sec2/sec_main.c b/drivers/crypto/hisilicon/sec2/sec_main.c
index 5eb2d6820742..7dd125f5f511 100644
--- a/drivers/crypto/hisilicon/sec2/sec_main.c
+++ b/drivers/crypto/hisilicon/sec2/sec_main.c
@@ -417,18 +417,29 @@ struct hisi_qp **sec_create_qps(void)
 	int node = cpu_to_node(raw_smp_processor_id());
 	u32 ctx_num = ctx_q_num;
 	struct hisi_qp **qps;
+	u8 *type;
 	int ret;
 
 	qps = kcalloc(ctx_num, sizeof(struct hisi_qp *), GFP_KERNEL);
 	if (!qps)
 		return NULL;
 
-	ret = hisi_qm_alloc_qps_node(&sec_devices, ctx_num, 0, node, qps);
-	if (!ret)
-		return qps;
+	/* The type of SEC is all 0, so just allocated by kcalloc */
+	type = kcalloc(ctx_num, sizeof(u8), GFP_KERNEL);
+	if (!type) {
+		kfree(qps);
+		return NULL;
+	}
 
-	kfree(qps);
-	return NULL;
+	ret = hisi_qm_alloc_qps_node(&sec_devices, ctx_num, type, node, qps);
+	if (ret) {
+		kfree(type);
+		kfree(qps);
+		return NULL;
+	}
+
+	kfree(type);
+	return qps;
 }
 
 u64 sec_get_alg_bitmap(struct hisi_qm *qm, u32 high, u32 low)
diff --git a/drivers/crypto/hisilicon/zip/zip.h b/drivers/crypto/hisilicon/zip/zip.h
index 9fb2a9c01132..b83f228281ab 100644
--- a/drivers/crypto/hisilicon/zip/zip.h
+++ b/drivers/crypto/hisilicon/zip/zip.h
@@ -99,7 +99,7 @@ enum zip_cap_table_type {
 	ZIP_CORE5_BITMAP,
 };
 
-int zip_create_qps(struct hisi_qp **qps, int qp_num, int node);
+int zip_create_qps(struct hisi_qp **qps, int qp_num, int node, u8 *alg_type);
 int hisi_zip_register_to_crypto(struct hisi_qm *qm);
 void hisi_zip_unregister_from_crypto(struct hisi_qm *qm);
 bool hisi_zip_alg_support(struct hisi_qm *qm, u32 alg);
diff --git a/drivers/crypto/hisilicon/zip/zip_crypto.c b/drivers/crypto/hisilicon/zip/zip_crypto.c
index b4a656e0177d..8250a33ba586 100644
--- a/drivers/crypto/hisilicon/zip/zip_crypto.c
+++ b/drivers/crypto/hisilicon/zip/zip_crypto.c
@@ -66,6 +66,7 @@ struct hisi_zip_qp_ctx {
 	struct hisi_acc_sgl_pool *sgl_pool;
 	struct hisi_zip *zip_dev;
 	struct hisi_zip_ctx *ctx;
+	u8 req_type;
 };
 
 struct hisi_zip_sqe_ops {
@@ -245,7 +246,7 @@ static int hisi_zip_do_work(struct hisi_zip_qp_ctx *qp_ctx,
 		goto err_unmap_input;
 	}
 
-	hisi_zip_fill_sqe(qp_ctx->ctx, &zip_sqe, qp->req_type, req);
+	hisi_zip_fill_sqe(qp_ctx->ctx, &zip_sqe, qp_ctx->req_type, req);
 
 	/* send command to start a task */
 	atomic64_inc(&dfx->send_cnt);
@@ -360,7 +361,6 @@ static int hisi_zip_start_qp(struct hisi_qp *qp, struct hisi_zip_qp_ctx *qp_ctx,
 	struct device *dev = &qp->qm->pdev->dev;
 	int ret;
 
-	qp->req_type = req_type;
 	qp->alg_type = alg_type;
 	qp->qp_ctx = qp_ctx;
 
@@ -397,10 +397,15 @@ static int hisi_zip_ctx_init(struct hisi_zip_ctx *hisi_zip_ctx, u8 req_type, int
 {
 	struct hisi_qp *qps[HZIP_CTX_Q_NUM] = { NULL };
 	struct hisi_zip_qp_ctx *qp_ctx;
+	u8 alg_type[HZIP_CTX_Q_NUM];
 	struct hisi_zip *hisi_zip;
 	int ret, i, j;
 
-	ret = zip_create_qps(qps, HZIP_CTX_Q_NUM, node);
+	/* alg_type = 0 for compress, 1 for decompress in hw sqe */
+	for (i = 0; i < HZIP_CTX_Q_NUM; i++)
+		alg_type[i] = i;
+
+	ret = zip_create_qps(qps, HZIP_CTX_Q_NUM, node, alg_type);
 	if (ret) {
 		pr_err("failed to create zip qps (%d)!\n", ret);
 		return -ENODEV;
@@ -409,7 +414,6 @@ static int hisi_zip_ctx_init(struct hisi_zip_ctx *hisi_zip_ctx, u8 req_type, int
 	hisi_zip = container_of(qps[0]->qm, struct hisi_zip, qm);
 
 	for (i = 0; i < HZIP_CTX_Q_NUM; i++) {
-		/* alg_type = 0 for compress, 1 for decompress in hw sqe */
 		qp_ctx = &hisi_zip_ctx->qp_ctx[i];
 		qp_ctx->ctx = hisi_zip_ctx;
 		ret = hisi_zip_start_qp(qps[i], qp_ctx, i, req_type);
@@ -422,6 +426,7 @@ static int hisi_zip_ctx_init(struct hisi_zip_ctx *hisi_zip_ctx, u8 req_type, int
 		}
 
 		qp_ctx->zip_dev = hisi_zip;
+		qp_ctx->req_type = req_type;
 	}
 
 	hisi_zip_ctx->ops = &hisi_zip_ops;
diff --git a/drivers/crypto/hisilicon/zip/zip_main.c b/drivers/crypto/hisilicon/zip/zip_main.c
index 4fcbe6bada06..85b26ef17548 100644
--- a/drivers/crypto/hisilicon/zip/zip_main.c
+++ b/drivers/crypto/hisilicon/zip/zip_main.c
@@ -446,12 +446,12 @@ static const struct pci_device_id hisi_zip_dev_ids[] = {
 };
 MODULE_DEVICE_TABLE(pci, hisi_zip_dev_ids);
 
-int zip_create_qps(struct hisi_qp **qps, int qp_num, int node)
+int zip_create_qps(struct hisi_qp **qps, int qp_num, int node, u8 *alg_type)
 {
 	if (node == NUMA_NO_NODE)
 		node = cpu_to_node(raw_smp_processor_id());
 
-	return hisi_qm_alloc_qps_node(&zip_devices, qp_num, 0, node, qps);
+	return hisi_qm_alloc_qps_node(&zip_devices, qp_num, alg_type, node, qps);
 }
 
 bool hisi_zip_alg_support(struct hisi_qm *qm, u32 alg)
diff --git a/include/linux/hisi_acc_qm.h b/include/linux/hisi_acc_qm.h
index 2d0cc61ed886..4f83f0700990 100644
--- a/include/linux/hisi_acc_qm.h
+++ b/include/linux/hisi_acc_qm.h
@@ -454,7 +454,6 @@ struct hisi_qp {
 	u16 sq_depth;
 	u16 cq_depth;
 	u8 alg_type;
-	u8 req_type;
 
 	struct qm_dma qdma;
 	void *sqe;
@@ -580,7 +579,7 @@ struct hisi_acc_sgl_pool *hisi_acc_create_sgl_pool(struct device *dev,
 void hisi_acc_free_sgl_pool(struct device *dev,
 			    struct hisi_acc_sgl_pool *pool);
 int hisi_qm_alloc_qps_node(struct hisi_qm_list *qm_list, int qp_num,
-			   u8 alg_type, int node, struct hisi_qp **qps);
+			   u8 *alg_type, int node, struct hisi_qp **qps);
 void hisi_qm_free_qps(struct hisi_qp **qps, int qp_num);
 void hisi_qm_dev_shutdown(struct pci_dev *pdev);
 void hisi_qm_wait_task_finish(struct hisi_qm *qm, struct hisi_qm_list *qm_list);
-- 
2.33.0

