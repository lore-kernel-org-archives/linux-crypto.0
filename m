Received: from canpmsgout08.his.huawei.com (canpmsgout08.his.huawei.com [113.46.200.223])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5D4A335091;
	Thu, 18 Dec 2025 13:45:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.223
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766065512; cv=none; b=G2AnIkBYZK+nw6t9oRH+/8/FTz0zVboJq4pu+/FeDLhJzL05DKtyGOFqlJGtWN+hEBOXwAPxTDcS+rZOncasDfoEti28uqwWS6omLh6OLqcGKj2O+Y1+a7ymzO3FLgk6kMSRkc0vzEs54OicQjVaH5aBD2CezJFbcZlJyfxxrjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766065512; c=relaxed/simple;
	bh=PHa1BBmNXkvvWoCX5E2fMkyZ530E347NPCph/XPL3ww=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HJqhfGFQW5DYYMkbqKg546M0gEppvpi9BSSmCgjwcdkaXD2WyTHJ97TPW7n+gdys3pbZKzoXiFe9/ZX6+PBbC7a8yl1Fb3s0L9jFeLReMyhsW7S/oGXpmddivgzHyswIgEZIO+Xb868V5KOTJQMXGbJkqD4qOniCw1gXm60JnHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=5y3C8OTL; arc=none smtp.client-ip=113.46.200.223
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="5y3C8OTL"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=u7X7y1Ji0fl6SFK0ZJbZugm/l8jpX2u5YvmbprVRXbo=;
	b=5y3C8OTL/eJJOZAAz97R6n2WQV0x9M0N+YRNOl2nmOT7/yydAbl0MDigZ6ZHZDGk/LZRMLRYQ
	h0WR5oEl0DEaqsJNpZ19hr0E33xbEEAY2arshw9Lxdw8Ec1ahHjWMXRXxZLmw3vCucS6PAK4LV0
	GNHG5DNVjsFq4cM2DTybcmY=
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4dXBfX6lgYzmV69;
	Thu, 18 Dec 2025 21:41:56 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id EEE1B140392;
	Thu, 18 Dec 2025 21:45:00 +0800 (CST)
Received: from kwepemq200001.china.huawei.com (7.202.195.16) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 18 Dec 2025 21:44:56 +0800
Received: from localhost.huawei.com (10.90.31.46) by
 kwepemq200001.china.huawei.com (7.202.195.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 18 Dec 2025 21:44:55 +0800
From: Chenghai Huang <huangchenghai2@huawei.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<fanghao11@huawei.com>, <liulongfang@huawei.com>, <qianweili@huawei.com>,
	<linwenkai6@hisilicon.com>, <wangzhou1@hisilicon.com>, <lizhi206@huawei.com>,
	<taoqi10@huawei.com>
Subject: [PATCH v4 06/11] crypto: hisilicon - consolidate qp creation and start in hisi_qm_alloc_qps_node
Date: Thu, 18 Dec 2025 21:44:47 +0800
Message-ID: <20251218134452.1125469-7-huangchenghai2@huawei.com>
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

Consolidate the creation and start of qp into the function
hisi_qm_alloc_qps_node. This change eliminates the need for
each module to perform these steps in two separate phases
(creation and start).

Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
Signed-off-by: Weili Qian <qianweili@huawei.com>
---
 drivers/crypto/hisilicon/hpre/hpre_crypto.c | 40 ++----------
 drivers/crypto/hisilicon/qm.c               | 70 ++++++++++++++++-----
 drivers/crypto/hisilicon/sec2/sec_crypto.c  |  8 ---
 drivers/crypto/hisilicon/zip/zip_crypto.c   | 43 ++-----------
 include/linux/hisi_acc_qm.h                 |  1 -
 5 files changed, 66 insertions(+), 96 deletions(-)

diff --git a/drivers/crypto/hisilicon/hpre/hpre_crypto.c b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
index 220022ae7afb..f410e610eaba 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_crypto.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
@@ -156,27 +156,6 @@ static void hpre_dfx_add_req_time(struct hpre_asym_request *hpre_req)
 		ktime_get_ts64(&hpre_req->req_time);
 }
 
-static struct hisi_qp *hpre_get_qp_and_start(u8 type)
-{
-	struct hisi_qp *qp;
-	int ret;
-
-	qp = hpre_create_qp(type);
-	if (!qp) {
-		pr_err("Can not create hpre qp!\n");
-		return ERR_PTR(-ENODEV);
-	}
-
-	ret = hisi_qm_start_qp(qp, 0);
-	if (ret < 0) {
-		hisi_qm_free_qps(&qp, 1);
-		pci_err(qp->qm->pdev, "Can not start qp!\n");
-		return ERR_PTR(-EINVAL);
-	}
-
-	return qp;
-}
-
 static int hpre_get_data_dma_addr(struct hpre_asym_request *hpre_req,
 				  struct scatterlist *data, unsigned int len,
 				  int is_src, dma_addr_t *tmp)
@@ -316,9 +295,8 @@ static int hpre_alg_res_post_hf(struct hpre_ctx *ctx, struct hpre_sqe *sqe,
 
 static void hpre_ctx_clear(struct hpre_ctx *ctx, bool is_clear_all)
 {
-	if (is_clear_all) {
+	if (is_clear_all)
 		hisi_qm_free_qps(&ctx->qp, 1);
-	}
 
 	ctx->crt_g2_mode = false;
 	ctx->key_sz = 0;
@@ -403,11 +381,10 @@ static int hpre_ctx_init(struct hpre_ctx *ctx, u8 type)
 	struct hisi_qp *qp;
 	struct hpre *hpre;
 
-	qp = hpre_get_qp_and_start(type);
-	if (IS_ERR(qp))
-		return PTR_ERR(qp);
+	qp = hpre_create_qp(type);
+	if (!qp)
+		return -ENODEV;
 
-	qp->qp_ctx = ctx;
 	qp->req_cb = hpre_alg_cb;
 	ctx->qp = qp;
 	ctx->dev = &qp->qm->pdev->dev;
@@ -597,9 +574,6 @@ static void hpre_dh_clear_ctx(struct hpre_ctx *ctx, bool is_clear_all)
 	struct device *dev = ctx->dev;
 	unsigned int sz = ctx->key_sz;
 
-	if (is_clear_all)
-		hisi_qm_stop_qp(ctx->qp);
-
 	if (ctx->dh.g) {
 		dma_free_coherent(dev, sz, ctx->dh.g, ctx->dh.dma_g);
 		ctx->dh.g = NULL;
@@ -940,9 +914,6 @@ static void hpre_rsa_clear_ctx(struct hpre_ctx *ctx, bool is_clear_all)
 	unsigned int half_key_sz = ctx->key_sz >> 1;
 	struct device *dev = ctx->dev;
 
-	if (is_clear_all)
-		hisi_qm_stop_qp(ctx->qp);
-
 	if (ctx->rsa.pubkey) {
 		dma_free_coherent(dev, ctx->key_sz << 1,
 				  ctx->rsa.pubkey, ctx->rsa.dma_pubkey);
@@ -1112,9 +1083,6 @@ static void hpre_ecc_clear_ctx(struct hpre_ctx *ctx, bool is_clear_all)
 	unsigned int sz = ctx->key_sz;
 	unsigned int shift = sz << 1;
 
-	if (is_clear_all)
-		hisi_qm_stop_qp(ctx->qp);
-
 	if (ctx->ecdh.p) {
 		/* ecdh: p->a->k->b */
 		memzero_explicit(ctx->ecdh.p + shift, sz);
diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index 3965c8d0993c..4cdb443e2889 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -3528,6 +3528,14 @@ void hisi_qm_dev_err_uninit(struct hisi_qm *qm)
 }
 EXPORT_SYMBOL_GPL(hisi_qm_dev_err_uninit);
 
+static void qm_release_qp_nolock(struct hisi_qp *qp)
+{
+	struct hisi_qm *qm = qp->qm;
+
+	qm->qp_in_used--;
+	idr_remove(&qm->qp_idr, qp->qp_id);
+}
+
 /**
  * hisi_qm_free_qps() - free multiple queue pairs.
  * @qps: The queue pairs need to be freed.
@@ -3540,8 +3548,15 @@ void hisi_qm_free_qps(struct hisi_qp **qps, int qp_num)
 	if (!qps || qp_num <= 0)
 		return;
 
-	for (i = qp_num - 1; i >= 0; i--)
-		hisi_qm_release_qp(qps[i]);
+	down_write(&qps[0]->qm->qps_lock);
+
+	for (i = qp_num - 1; i >= 0; i--) {
+		qm_stop_qp_nolock(qps[i]);
+		qm_release_qp_nolock(qps[i]);
+	}
+
+	up_write(&qps[0]->qm->qps_lock);
+	qm_pm_put_sync(qps[0]->qm);
 }
 EXPORT_SYMBOL_GPL(hisi_qm_free_qps);
 
@@ -3555,6 +3570,43 @@ static void free_list(struct list_head *head)
 	}
 }
 
+static int qm_get_and_start_qp(struct hisi_qm *qm, int qp_num, struct hisi_qp **qps, u8 *alg_type)
+{
+	int i, ret;
+
+	ret = qm_pm_get_sync(qm);
+	if (ret)
+		return ret;
+
+	down_write(&qm->qps_lock);
+	for (i = 0; i < qp_num; i++) {
+		qps[i] = qm_create_qp_nolock(qm, alg_type[i]);
+		if (IS_ERR(qps[i])) {
+			ret = -ENODEV;
+			goto stop_and_free;
+		}
+
+		ret = qm_start_qp_nolock(qps[i], 0);
+		if (ret) {
+			qm_release_qp_nolock(qps[i]);
+			goto stop_and_free;
+		}
+	}
+	up_write(&qm->qps_lock);
+
+	return 0;
+
+stop_and_free:
+	for (i--; i >= 0; i--) {
+		qm_stop_qp_nolock(qps[i]);
+		qm_release_qp_nolock(qps[i]);
+	}
+	up_write(&qm->qps_lock);
+	qm_pm_put_sync(qm);
+
+	return ret;
+}
+
 static int hisi_qm_sort_devices(int node, struct list_head *head,
 				struct hisi_qm_list *qm_list)
 {
@@ -3608,7 +3660,6 @@ int hisi_qm_alloc_qps_node(struct hisi_qm_list *qm_list, int qp_num,
 	struct hisi_qm_resource *tmp;
 	int ret = -ENODEV;
 	LIST_HEAD(head);
-	int i;
 
 	if (!qps || !qm_list || qp_num <= 0)
 		return -EINVAL;
@@ -3620,18 +3671,9 @@ int hisi_qm_alloc_qps_node(struct hisi_qm_list *qm_list, int qp_num,
 	}
 
 	list_for_each_entry(tmp, &head, list) {
-		for (i = 0; i < qp_num; i++) {
-			qps[i] = hisi_qm_create_qp(tmp->qm, alg_type[i]);
-			if (IS_ERR(qps[i])) {
-				hisi_qm_free_qps(qps, i);
-				break;
-			}
-		}
-
-		if (i == qp_num) {
-			ret = 0;
+		ret = qm_get_and_start_qp(tmp->qm, qp_num, qps, alg_type);
+		if (!ret)
 			break;
-		}
 	}
 
 	mutex_unlock(&qm_list->lock);
diff --git a/drivers/crypto/hisilicon/sec2/sec_crypto.c b/drivers/crypto/hisilicon/sec2/sec_crypto.c
index 364bd69c6088..d09d081f42dc 100644
--- a/drivers/crypto/hisilicon/sec2/sec_crypto.c
+++ b/drivers/crypto/hisilicon/sec2/sec_crypto.c
@@ -626,7 +626,6 @@ static int sec_create_qp_ctx(struct sec_ctx *ctx, int qp_ctx_id)
 
 	qp_ctx = &ctx->qp_ctx[qp_ctx_id];
 	qp = ctx->qps[qp_ctx_id];
-	qp->qp_ctx = qp_ctx;
 	qp_ctx->qp = qp;
 	qp_ctx->ctx = ctx;
 
@@ -644,14 +643,8 @@ static int sec_create_qp_ctx(struct sec_ctx *ctx, int qp_ctx_id)
 	if (ret)
 		goto err_destroy_idr;
 
-	ret = hisi_qm_start_qp(qp, 0);
-	if (ret < 0)
-		goto err_resource_free;
-
 	return 0;
 
-err_resource_free:
-	sec_free_qp_ctx_resource(ctx, qp_ctx);
 err_destroy_idr:
 	idr_destroy(&qp_ctx->req_idr);
 	return ret;
@@ -660,7 +653,6 @@ static int sec_create_qp_ctx(struct sec_ctx *ctx, int qp_ctx_id)
 static void sec_release_qp_ctx(struct sec_ctx *ctx,
 			       struct sec_qp_ctx *qp_ctx)
 {
-	hisi_qm_stop_qp(qp_ctx->qp);
 	sec_free_qp_ctx_resource(ctx, qp_ctx);
 	idr_destroy(&qp_ctx->req_idr);
 }
diff --git a/drivers/crypto/hisilicon/zip/zip_crypto.c b/drivers/crypto/hisilicon/zip/zip_crypto.c
index 2f9035c016f3..108ab667131d 100644
--- a/drivers/crypto/hisilicon/zip/zip_crypto.c
+++ b/drivers/crypto/hisilicon/zip/zip_crypto.c
@@ -352,32 +352,6 @@ static int hisi_zip_adecompress(struct acomp_req *acomp_req)
 	return ret;
 }
 
-static int hisi_zip_start_qp(struct hisi_qp *qp, struct hisi_zip_qp_ctx *qp_ctx,
-			     int alg_type, int req_type)
-{
-	struct device *dev = &qp->qm->pdev->dev;
-	int ret;
-
-	qp->alg_type = alg_type;
-	qp->qp_ctx = qp_ctx;
-
-	ret = hisi_qm_start_qp(qp, 0);
-	if (ret < 0) {
-		dev_err(dev, "failed to start qp (%d)!\n", ret);
-		return ret;
-	}
-
-	qp_ctx->qp = qp;
-
-	return 0;
-}
-
-static void hisi_zip_release_qp(struct hisi_zip_qp_ctx *qp_ctx)
-{
-	hisi_qm_stop_qp(qp_ctx->qp);
-	hisi_qm_free_qps(&qp_ctx->qp, 1);
-}
-
 static const struct hisi_zip_sqe_ops hisi_zip_ops = {
 	.sqe_type		= 0x3,
 	.fill_addr		= hisi_zip_fill_addr,
@@ -396,7 +370,7 @@ static int hisi_zip_ctx_init(struct hisi_zip_ctx *hisi_zip_ctx, u8 req_type, int
 	struct hisi_zip_qp_ctx *qp_ctx;
 	u8 alg_type[HZIP_CTX_Q_NUM];
 	struct hisi_zip *hisi_zip;
-	int ret, i, j;
+	int ret, i;
 
 	/* alg_type = 0 for compress, 1 for decompress in hw sqe */
 	for (i = 0; i < HZIP_CTX_Q_NUM; i++)
@@ -413,17 +387,9 @@ static int hisi_zip_ctx_init(struct hisi_zip_ctx *hisi_zip_ctx, u8 req_type, int
 	for (i = 0; i < HZIP_CTX_Q_NUM; i++) {
 		qp_ctx = &hisi_zip_ctx->qp_ctx[i];
 		qp_ctx->ctx = hisi_zip_ctx;
-		ret = hisi_zip_start_qp(qps[i], qp_ctx, i, req_type);
-		if (ret) {
-			for (j = i - 1; j >= 0; j--)
-				hisi_qm_stop_qp(hisi_zip_ctx->qp_ctx[j].qp);
-
-			hisi_qm_free_qps(qps, HZIP_CTX_Q_NUM);
-			return ret;
-		}
-
 		qp_ctx->zip_dev = hisi_zip;
 		qp_ctx->req_type = req_type;
+		qp_ctx->qp = qps[i];
 	}
 
 	hisi_zip_ctx->ops = &hisi_zip_ops;
@@ -433,10 +399,13 @@ static int hisi_zip_ctx_init(struct hisi_zip_ctx *hisi_zip_ctx, u8 req_type, int
 
 static void hisi_zip_ctx_exit(struct hisi_zip_ctx *hisi_zip_ctx)
 {
+	struct hisi_qp *qps[HZIP_CTX_Q_NUM] = { NULL };
 	int i;
 
 	for (i = 0; i < HZIP_CTX_Q_NUM; i++)
-		hisi_zip_release_qp(&hisi_zip_ctx->qp_ctx[i]);
+		qps[i] = hisi_zip_ctx->qp_ctx[i].qp;
+
+	hisi_qm_free_qps(qps, HZIP_CTX_Q_NUM);
 }
 
 static int hisi_zip_create_req_q(struct hisi_zip_ctx *ctx)
diff --git a/include/linux/hisi_acc_qm.h b/include/linux/hisi_acc_qm.h
index 75ae01ddaa1a..4cf418a41fe4 100644
--- a/include/linux/hisi_acc_qm.h
+++ b/include/linux/hisi_acc_qm.h
@@ -463,7 +463,6 @@ struct hisi_qp {
 
 	struct hisi_qp_status qp_status;
 	struct hisi_qp_ops *hw_ops;
-	void *qp_ctx;
 	void (*req_cb)(struct hisi_qp *qp, void *data);
 	void (*event_cb)(struct hisi_qp *qp);
 
-- 
2.33.0

