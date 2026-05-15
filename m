Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 908A8480340;
	Fri, 15 May 2026 11:47:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.218
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778845655; cv=none; b=NQxNK67LOoG4LlrkTeD40eGyhcMq2TrUdIycFwzpYnS//Iy90FF55jse1tFSHh9olDdDzy3xmXgd8iW8DuH1eNPZK7fpbAqLQ6qaP/ktH0AeH0A5QiYZX+2GlP0rF2B4pnocZEWQpsKvxQ+DQ70CGOujLjQBi7iD/8zC1tgjDEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778845655; c=relaxed/simple;
	bh=yNjyEOa01z/Ohnd87fDVpZuMG/DRDsFApX0oCwlVkD4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fYCVMH7hKCAJsmLDnTO8OkobDu/RXjja7om+k3MH+hmBVBpJEOk2mJkIdm2T/bvVTL3FodZ1Hqs5ehpywF1jDrXuuGGP6w50VJy9yh5fWnuQZJzAnzN+epU9u9SalHeEbQSr8KgEvexkq/yCPVmeUvM2a4QjVyeza6ED52eHagA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=qGSV1yof; arc=none smtp.client-ip=113.46.200.218
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="qGSV1yof"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=6ZcA8T3DZRqSLPYgddyA/JtWgUgkayMJh6YovlBnK10=;
	b=qGSV1yofdUjSeIN2yjtcgPD6eaH5UpA75kvbKjwvSA3Sio4kovHrG6uwNQZHst9WKIbV4R/yR
	oOYfUD5jmocBS08JSGVgqTenh+Yt7sehkrPsi23DtILPquJIrzWxRyVHQs4is00ESrTsA1Cz4pb
	JCzchkSEkOZ47A8/HSvj+dk=
Received: from mail.maildlp.com (unknown [172.19.162.223])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4gH4xv6Y5WzpSwC;
	Fri, 15 May 2026 19:40:19 +0800 (CST)
Received: from kwepemr100008.china.huawei.com (unknown [7.202.195.119])
	by mail.maildlp.com (Postfix) with ESMTPS id 13FAE40571;
	Fri, 15 May 2026 19:47:25 +0800 (CST)
Received: from localhost.localdomain (10.50.163.32) by
 kwepemr100008.china.huawei.com (7.202.195.119) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Fri, 15 May 2026 19:47:24 +0800
From: ZongYu Wu <wuzongyu1@huawei.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<fanghao11@huawei.com>, <liulongfang@huawei.com>, <qianweili@huawei.com>,
	<wangzhou1@hisilicon.com>
Subject: [PATCH] crypto: hisilicon/zip - add backlog support for zip
Date: Fri, 15 May 2026 19:45:59 +0800
Message-ID: <20260515114601.2492524-2-wuzongyu1@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20260515114601.2492524-1-wuzongyu1@huawei.com>
References: <20260515114601.2492524-1-wuzongyu1@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemr100008.china.huawei.com (7.202.195.119)

From: Chenghai Huang <huangchenghai2@huawei.com>

When the hardware queue is busy, requests are now queued instead of
being failed immediately. Queued requests are retried when earlier
requests complete, which prevents transient failures under heavy load.

The backlog path also provides a fallback mechanism while the hardware
is temporarily unavailable, such as during device reset.

Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
Signed-off-by: Zongyu Wu <wuzongyu1@huawei.com>
---
 drivers/crypto/hisilicon/zip/zip_crypto.c | 284 ++++++++++++++--------
 1 file changed, 180 insertions(+), 104 deletions(-)

diff --git a/drivers/crypto/hisilicon/zip/zip_crypto.c b/drivers/crypto/hisilicon/zip/zip_crypto.c
index 70adde049b53..ff287251218e 100644
--- a/drivers/crypto/hisilicon/zip/zip_crypto.c
+++ b/drivers/crypto/hisilicon/zip/zip_crypto.c
@@ -28,6 +28,7 @@
 
 #define HZIP_ALG_DEFLATE			GENMASK(5, 4)
 #define HZIP_ALG_LZ4				BIT(8)
+#define HZIP_INVAL_REQ_ID			((u16)0xFFFF)
 
 static DEFINE_MUTEX(zip_algs_lock);
 static unsigned int zip_available_devs;
@@ -55,11 +56,11 @@ struct hisi_zip_req {
 	dma_addr_t dma_src;
 	dma_addr_t dma_dst;
 	struct hisi_zip_qp_ctx *qp_ctx;
+	struct list_head list;
 	u16 req_id;
 };
 
 struct hisi_zip_req_q {
-	struct hisi_zip_req *q;
 	unsigned long *req_bitmap;
 	spinlock_t req_lock;
 	u16 size;
@@ -135,42 +136,42 @@ static int hisi_zip_fallback_do_work(struct acomp_req *acomp_req, bool is_decomp
 	return ret;
 }
 
-static struct hisi_zip_req *hisi_zip_create_req(struct hisi_zip_qp_ctx *qp_ctx,
-						struct acomp_req *req)
+static int hisi_zip_create_req(struct hisi_zip_req *req)
 {
+	struct hisi_zip_qp_ctx *qp_ctx = req->qp_ctx;
 	struct hisi_zip_req_q *req_q = &qp_ctx->req_q;
-	struct hisi_zip_req *q = req_q->q;
-	struct hisi_zip_req *req_cache;
 	int req_id;
 
+	/* Check whether any request is being queued */
+	if (!list_empty(&qp_ctx->qp->backlog.list))
+		return -EBUSY;
+
 	spin_lock(&req_q->req_lock);
 
 	req_id = find_first_zero_bit(req_q->req_bitmap, req_q->size);
 	if (req_id >= req_q->size) {
 		spin_unlock(&req_q->req_lock);
 		dev_dbg(&qp_ctx->qp->qm->pdev->dev, "req cache is full!\n");
-		return ERR_PTR(-EAGAIN);
+		return -EBUSY;
 	}
 	set_bit(req_id, req_q->req_bitmap);
 
 	spin_unlock(&req_q->req_lock);
 
-	req_cache = q + req_id;
-	req_cache->req_id = req_id;
-	req_cache->req = req;
-	req_cache->qp_ctx = qp_ctx;
+	req->req_id = req_id;
 
-	return req_cache;
+	return 0;
 }
 
-static void hisi_zip_remove_req(struct hisi_zip_qp_ctx *qp_ctx,
-				struct hisi_zip_req *req)
+static void hisi_zip_remove_req(struct hisi_zip_req *req)
 {
-	struct hisi_zip_req_q *req_q = &qp_ctx->req_q;
+	struct hisi_zip_req_q *req_q = &req->qp_ctx->req_q;
 
 	spin_lock(&req_q->req_lock);
 	clear_bit(req->req_id, req_q->req_bitmap);
 	spin_unlock(&req_q->req_lock);
+
+	req->req_id = HZIP_INVAL_REQ_ID;
 }
 
 static void hisi_zip_fill_addr(struct hisi_zip_sqe *sqe, struct hisi_zip_req *req)
@@ -247,19 +248,21 @@ static void hisi_zip_fill_sqe(struct hisi_zip_ctx *ctx, struct hisi_zip_sqe *sqe
 	ops->fill_sqe_type(sqe, ops->sqe_type);
 }
 
-static int hisi_zip_do_work(struct hisi_zip_qp_ctx *qp_ctx,
-			    struct hisi_zip_req *req)
+static void hisi_zip_enqueue_backlog(struct hisi_zip_req *req)
+{
+	struct hisi_qp *qp = req->qp_ctx->qp;
+
+	spin_lock_bh(&qp->backlog.lock);
+	list_add_tail(&req->list, &qp->backlog.list);
+	spin_unlock_bh(&qp->backlog.lock);
+}
+
+static int hisi_zip_map_req_buffers(struct hisi_zip_req *req)
 {
+	struct hisi_zip_qp_ctx *qp_ctx = req->qp_ctx;
 	struct hisi_acc_sgl_pool *pool = qp_ctx->sgl_pool;
-	struct hisi_zip_dfx *dfx = &qp_ctx->zip_dev->dfx;
+	struct device *dev = &qp_ctx->qp->qm->pdev->dev;
 	struct acomp_req *a_req = req->req;
-	struct hisi_qp *qp = qp_ctx->qp;
-	struct device *dev = &qp->qm->pdev->dev;
-	struct hisi_zip_sqe zip_sqe;
-	int ret;
-
-	if (unlikely(!a_req->src || !a_req->slen || !a_req->dst || !a_req->dlen))
-		return -EINVAL;
 
 	req->hw_src = hisi_acc_sg_buf_map_to_hw_sgl(dev, a_req->src, pool,
 						    req->req_id << 1, &req->dma_src,
@@ -274,33 +277,110 @@ static int hisi_zip_do_work(struct hisi_zip_qp_ctx *qp_ctx,
 						    (req->req_id << 1) + 1,
 						    &req->dma_dst, DMA_FROM_DEVICE);
 	if (IS_ERR(req->hw_dst)) {
-		ret = PTR_ERR(req->hw_dst);
-		dev_err(dev, "failed to map the dst buffer to hw sgl (%d)!\n",
-			ret);
-		goto err_unmap_input;
+		dev_err(dev, "failed to map the dst buffer to hw sgl (%ld)!\n",
+			PTR_ERR(req->hw_dst));
+		hisi_acc_sg_buf_unmap(dev, a_req->src, req->hw_src, DMA_TO_DEVICE);
+		return PTR_ERR(req->hw_dst);
 	}
 
+	return 0;
+}
+
+static void hisi_zip_unmap_req_buffers(struct hisi_zip_req *req)
+{
+	struct device *dev = &req->qp_ctx->qp->qm->pdev->dev;
+	struct acomp_req *a_req = req->req;
+
+	hisi_acc_sg_buf_unmap(dev, a_req->dst, req->hw_dst, DMA_FROM_DEVICE);
+	hisi_acc_sg_buf_unmap(dev, a_req->src, req->hw_src, DMA_TO_DEVICE);
+}
+
+static int hisi_zip_do_work(struct hisi_zip_req *req)
+{
+	struct hisi_zip_qp_ctx *qp_ctx = req->qp_ctx;
+	struct hisi_zip_dfx *dfx = &qp_ctx->zip_dev->dfx;
+	struct hisi_qp *qp = qp_ctx->qp;
+	struct hisi_zip_sqe zip_sqe;
+	int ret;
+
 	hisi_zip_fill_sqe(qp_ctx->ctx, &zip_sqe, qp_ctx->req_type, req);
 
 	/* send command to start a task */
-	atomic64_inc(&dfx->send_cnt);
 	ret = hisi_qp_send(qp, &zip_sqe);
-	if (unlikely(ret < 0)) {
-		atomic64_inc(&dfx->send_busy_cnt);
-		ret = -EAGAIN;
-		dev_dbg_ratelimited(dev, "failed to send request!\n");
-		goto err_unmap_output;
+	if (likely(!ret)) {
+		atomic64_inc(&dfx->send_cnt);
+		return -EINPROGRESS;
 	}
 
-	return -EINPROGRESS;
+	if (ret == -EBUSY)
+		atomic64_inc(&dfx->send_busy_cnt);
 
-err_unmap_output:
-	hisi_acc_sg_buf_unmap(dev, a_req->dst, req->hw_dst, DMA_FROM_DEVICE);
-err_unmap_input:
-	hisi_acc_sg_buf_unmap(dev, a_req->src, req->hw_src, DMA_TO_DEVICE);
 	return ret;
 }
 
+static void hisi_zip_send_backlog_soft(struct hisi_zip_qp_ctx *qp_ctx)
+{
+	bool is_decomp = qp_ctx->qp->alg_type;
+	struct hisi_zip_req *req, *tmp;
+	int ret;
+
+	list_for_each_entry_safe(req, tmp, &qp_ctx->qp->backlog.list, list) {
+		list_del(&req->list);
+
+		if (req->req_id != HZIP_INVAL_REQ_ID) {
+			hisi_zip_unmap_req_buffers(req);
+			hisi_zip_remove_req(req);
+		}
+
+		ret = hisi_zip_fallback_do_work(req->req, is_decomp);
+
+		/* Wake up the busy thread first, then return the errno. */
+		if (req->req->base.complete) {
+			acomp_request_complete(req->req, -EINPROGRESS);
+			acomp_request_complete(req->req, ret);
+		}
+	}
+}
+
+static void hisi_zip_send_backlog(struct hisi_qp *qp)
+{
+	struct  hisi_zip_req *req, *tmp;
+	int ret;
+
+	spin_lock_bh(&qp->backlog.lock);
+	list_for_each_entry_safe(req, tmp, &qp->backlog.list, list) {
+		if (req->req_id == HZIP_INVAL_REQ_ID) {
+			ret = hisi_zip_create_req(req);
+			if (ret)
+				continue;
+
+			ret = hisi_zip_map_req_buffers(req);
+			if (unlikely(ret)) {
+				hisi_zip_remove_req(req);
+				hisi_zip_send_backlog_soft(req->qp_ctx);
+				goto unlock;
+			}
+		}
+
+		ret = hisi_zip_do_work(req);
+		switch (ret) {
+		case -EINPROGRESS:
+			list_del(&req->list);
+			if (req->req->base.complete)
+				acomp_request_complete(req->req, -EINPROGRESS);
+			break;
+		case -EBUSY:
+			goto unlock;
+		default:
+			hisi_zip_send_backlog_soft(req->qp_ctx);
+			goto unlock;
+		}
+	}
+
+unlock:
+	spin_unlock_bh(&qp->backlog.lock);
+}
+
 static u32 hisi_zip_get_status(struct hisi_zip_sqe *sqe)
 {
 	return sqe->dw3 & HZIP_BD_STATUS_M;
@@ -333,73 +413,89 @@ static void hisi_zip_acomp_cb(struct hisi_qp *qp, void *data)
 		err = -EIO;
 	}
 
-	hisi_acc_sg_buf_unmap(dev, acomp_req->dst, req->hw_dst, DMA_FROM_DEVICE);
-	hisi_acc_sg_buf_unmap(dev, acomp_req->src, req->hw_src, DMA_TO_DEVICE);
+	hisi_zip_unmap_req_buffers(req);
 
 	acomp_req->dlen = ops->get_dstlen(sqe);
+	hisi_zip_remove_req(req);
 
 	if (acomp_req->base.complete)
 		acomp_request_complete(acomp_req, err);
 
-	hisi_zip_remove_req(qp_ctx, req);
+	hisi_zip_send_backlog(qp);
 }
 
-static int hisi_zip_acompress(struct acomp_req *acomp_req)
+static int hisi_zip_do_comp(struct hisi_zip_req *req)
 {
+	struct acomp_req *acomp_req = req->req;
 	struct hisi_zip_ctx *ctx = crypto_tfm_ctx(acomp_req->base.tfm);
-	struct hisi_zip_qp_ctx *qp_ctx = &ctx->qp_ctx[HZIP_QPC_COMP];
-	struct hisi_zip_req *req;
-	struct device *dev;
+	struct hisi_qp *qp = req->qp_ctx->qp;
 	int ret;
 
-	if (ctx->fallback)
-		return hisi_zip_fallback_do_work(acomp_req, 0);
-
-	dev = &qp_ctx->qp->qm->pdev->dev;
+	if (unlikely(!acomp_req->src || !acomp_req->slen ||
+		     !acomp_req->dst || !acomp_req->dlen))
+		return -EINVAL;
 
-	req = hisi_zip_create_req(qp_ctx, acomp_req);
-	if (IS_ERR(req))
-		return PTR_ERR(req);
+	if (ctx->fallback)
+		return hisi_zip_fallback_do_work(acomp_req, qp->alg_type);
+
+	ret = hisi_zip_create_req(req);
+	if (ret && (acomp_req->base.flags & CRYPTO_TFM_REQ_MAY_BACKLOG)) {
+		/* all req bitmaps are used add to backlog list */
+		req->req_id = HZIP_INVAL_REQ_ID;
+		hisi_zip_enqueue_backlog(req);
+		return -EBUSY;
+	} else if (unlikely(ret)) {
+		return -ENOSPC;
+	}
 
-	ret = hisi_zip_do_work(qp_ctx, req);
-	if (unlikely(ret != -EINPROGRESS)) {
-		dev_info_ratelimited(dev, "failed to do compress (%d)!\n", ret);
-		hisi_zip_remove_req(qp_ctx, req);
+	ret = hisi_zip_map_req_buffers(req);
+	if (unlikely(ret))
+		goto remove_req;
+
+	ret = hisi_zip_do_work(req);
+	if (ret == -EBUSY && (acomp_req->base.flags & CRYPTO_TFM_REQ_MAY_BACKLOG)) {
+		/* hardwre busy add to backlog list */
+		hisi_zip_enqueue_backlog(req);
+	} else if (unlikely(ret != -EINPROGRESS)) {
+		dev_info_ratelimited(&qp->qm->pdev->dev,
+				     "failed to do %scompress (%d)!\n",
+				     qp->alg_type ? "de" : "", ret);
+		ret = -ENOSPC;
+		goto unmap_req;
 	}
 
 	return ret;
+
+unmap_req:
+	hisi_zip_unmap_req_buffers(req);
+remove_req:
+	hisi_zip_remove_req(req);
+	return ret;
 }
 
-static int hisi_zip_adecompress(struct acomp_req *acomp_req)
+static int hisi_zip_acompress(struct acomp_req *acomp_req)
 {
 	struct hisi_zip_ctx *ctx = crypto_tfm_ctx(acomp_req->base.tfm);
-	struct hisi_zip_qp_ctx *qp_ctx = &ctx->qp_ctx[HZIP_QPC_DECOMP];
-	struct hisi_zip_req *req;
-	struct device *dev;
-	int ret;
-
-	if (ctx->fallback)
-		return hisi_zip_fallback_do_work(acomp_req, 1);
+	struct hisi_zip_req *req = acomp_request_ctx(acomp_req);
 
-	dev = &qp_ctx->qp->qm->pdev->dev;
-
-	req = hisi_zip_create_req(qp_ctx, acomp_req);
-	if (IS_ERR(req))
-		return PTR_ERR(req);
+	req->req = acomp_req;
+	req->qp_ctx = &ctx->qp_ctx[HZIP_QPC_COMP];
+	return hisi_zip_do_comp(req);
+}
 
-	ret = hisi_zip_do_work(qp_ctx, req);
-	if (unlikely(ret != -EINPROGRESS)) {
-		dev_info_ratelimited(dev, "failed to do decompress (%d)!\n",
-				     ret);
-		hisi_zip_remove_req(qp_ctx, req);
-	}
+static int hisi_zip_adecompress(struct acomp_req *acomp_req)
+{
+	struct hisi_zip_ctx *ctx = crypto_tfm_ctx(acomp_req->base.tfm);
+	struct hisi_zip_req *req = acomp_request_ctx(acomp_req);
 
-	return ret;
+	req->req = acomp_req;
+	req->qp_ctx = &ctx->qp_ctx[HZIP_QPC_DECOMP];
+	return hisi_zip_do_comp(req);
 }
 
 static int hisi_zip_decompress(struct acomp_req *acomp_req)
 {
-	return hisi_zip_fallback_do_work(acomp_req, 1);
+	return hisi_zip_fallback_do_work(acomp_req, HZIP_ALG_TYPE_DECOMP);
 }
 
 static const struct hisi_zip_sqe_ops hisi_zip_ops = {
@@ -463,7 +559,7 @@ static int hisi_zip_create_req_q(struct hisi_zip_ctx *ctx)
 {
 	u16 q_depth = ctx->qp_ctx[0].qp->sq_depth;
 	struct hisi_zip_req_q *req_q;
-	int i, ret;
+	int i;
 
 	for (i = 0; i < HZIP_CTX_Q_NUM; i++) {
 		req_q = &ctx->qp_ctx[i].req_q;
@@ -471,43 +567,21 @@ static int hisi_zip_create_req_q(struct hisi_zip_ctx *ctx)
 
 		req_q->req_bitmap = bitmap_zalloc(req_q->size, GFP_KERNEL);
 		if (!req_q->req_bitmap) {
-			ret = -ENOMEM;
-			if (i == 0)
-				return ret;
-
-			goto err_free_comp_q;
+			bitmap_free(ctx->qp_ctx[HZIP_QPC_COMP].req_q.req_bitmap);
+			return -ENOMEM;
 		}
 		spin_lock_init(&req_q->req_lock);
-
-		req_q->q = kzalloc_objs(struct hisi_zip_req, req_q->size);
-		if (!req_q->q) {
-			ret = -ENOMEM;
-			if (i == 0)
-				goto err_free_comp_bitmap;
-			else
-				goto err_free_decomp_bitmap;
-		}
 	}
 
 	return 0;
-
-err_free_decomp_bitmap:
-	bitmap_free(ctx->qp_ctx[HZIP_QPC_DECOMP].req_q.req_bitmap);
-err_free_comp_q:
-	kfree(ctx->qp_ctx[HZIP_QPC_COMP].req_q.q);
-err_free_comp_bitmap:
-	bitmap_free(ctx->qp_ctx[HZIP_QPC_COMP].req_q.req_bitmap);
-	return ret;
 }
 
 static void hisi_zip_release_req_q(struct hisi_zip_ctx *ctx)
 {
 	int i;
 
-	for (i = 0; i < HZIP_CTX_Q_NUM; i++) {
-		kfree(ctx->qp_ctx[i].req_q.q);
+	for (i = 0; i < HZIP_CTX_Q_NUM; i++)
 		bitmap_free(ctx->qp_ctx[i].req_q.req_bitmap);
-	}
 }
 
 static int hisi_zip_create_sgl_pool(struct hisi_zip_ctx *ctx)
@@ -620,6 +694,7 @@ static struct acomp_alg hisi_zip_acomp_deflate = {
 		.cra_module		= THIS_MODULE,
 		.cra_priority		= HZIP_ALG_PRIORITY,
 		.cra_ctxsize		= sizeof(struct hisi_zip_ctx),
+		.cra_reqsize		= sizeof(struct hisi_zip_req),
 	}
 };
 
@@ -658,6 +733,7 @@ static struct acomp_alg hisi_zip_acomp_lz4 = {
 		.cra_module		= THIS_MODULE,
 		.cra_priority		= HZIP_ALG_PRIORITY,
 		.cra_ctxsize		= sizeof(struct hisi_zip_ctx),
+		.cra_reqsize		= sizeof(struct hisi_zip_req),
 	}
 };
 
-- 
2.43.0

