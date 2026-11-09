Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=113.46.200.218
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794209776;
	b=R3f10ZPDQaEo4/Rw3zEyYwJjeOSXK8OWNcgeJ6YkcZqaSZ3qnmSayK2xGjvEQXYYgx3L
	 QghO+itDLGEFtzeCi3Y1kbv5OyIkgxsDGGbrraBE6kukIzu59GYdsIZ14eudhdk/ASoWy
	 1f9HFAHONI4pzBQmmWRIs/pq/sZEBPIGFIu6mXJkHFx7qXUFJbg+cbib1gxEMwQWJx9Z+
	 +RNutiMZqUe8SBAFucZDt3vKTObATZOXXcbYeXpyhhNOLqK3Xeo77atTS/VvIvnJIiN/a
	 tUzDKdE62CyfsOII8+coFj7h0s7AILZgQmGWf/2vx/50Kt9h8vRq7jfT+gCEnYoNaDg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794209776;
	h=DMARC-Filter:dkim-signature:Received:Received:Received:From:To:CC:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:Content-Type:X-Originating-IP:
	 X-ClientProxiedBy;
	bh=JrE1urhyimzsBsbq6jal/ceecDzYz/k0gH0/3+1yvMQ=;
	b=gJN9eWxSKwonx1A9F7kvb5PUl+N95WQLweZ970Wfw2fGFMyVaOwBphNeYULLod05MMxf
	 PUMpzIQ8LBNFkDLG8ajlMGal/e8q5nswq3uQGXKrXzy5xHLTGIVlP5SgwEEMz2A08ulgd
	 qJ9elecPiwc2gcnL4MnUXY246+LcwpiISGrYIIkIjBYei+rq051gOvVOKVjDlGi2uditN
	 LQ8R9A+BS19xO/wyyn/l7ChRUx5g0DLdAV1NAzA89Fq2qqJjxGZ15NJDj0bTZb8s2R6wu
	 zGLsLqJ2gK28u2u/2wVDPOiOn2ktisZ8YoBwZO6+tK7C3AmUnS+CCVtWktT6Y+kTVRw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=huawei.com;
	spf=pass smtp.mailfrom=huawei.com;
	dkim=pass header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=B6xWF8oi;
	arc=none smtp.remote-ip=113.46.200.218
Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D991606A331;
	Mon,  9 Nov 2026 07:36:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8D991606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=B6xWF8oi
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=JrE1urhyimzsBsbq6jal/ceecDzYz/k0gH0/3+1yvMQ=;
	b=B6xWF8oiMmwE49uX6os1/yzNURmdD1MdmCR1yBiDhMKQMWUtjTyeqph0svJD2sJk674PeyDIF
	oY645baPGQc9u1rPqwEVnsahxWp92fa6eeyhm/pkLYLvrjoeva0JnXwoqkhXcamXJ0TRma9tD+x
	5oTGMnlZzHYVJ/8EOAWN4l8=
Received: from mail.maildlp.com (unknown [172.19.162.140])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4jNM5Q29VNzpTJ3;
	Mon,  9 Nov 2026 15:35:38 +0800 (CST)
Received: from whupemk200001.china.huawei.com (unknown [7.152.184.93])
	by mail.maildlp.com (Postfix) with ESMTPS id 0F9FB202E6;
	Mon,  9 Nov 2026 15:36:12 +0800 (CST)
Received: from localhost.localdomain (10.50.163.32) by
 whupemk200001.china.huawei.com (7.152.184.93) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Mon, 9 Nov 2026 15:36:10 +0800
From: Chenghai Huang <huangchenghai2@huawei.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<liulongfang@huawei.com>, <qianweili@huawei.com>, <wangzhou1@hisilicon.com>,
	<linwenkai6@hisilicon.com>
Subject: [PATCH 4/4] crypto: hisilicon/zip - adapt to use crypto engine
Date: Mon, 9 Nov 2026 15:35:56 +0800
Message-ID: <20261109073556.2517351-5-huangchenghai2@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261109073556.2517351-1-huangchenghai2@huawei.com>
References: <20261109073556.2517351-1-huangchenghai2@huawei.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 whupemk200001.china.huawei.com (7.152.184.93)

The ZIP driver has no backlog queue: when the hardware queue is full,
requests fail immediately.

Migrate the ZIP driver to the crypto engine framework. Each QP context
borrows an engine from a per-device pool by its QP id, so compression
and decompression queue independently. Requests are sent to the
hardware when it has room; on -ENOSPC they are parked in the engine
queue and retried with their DMA mappings kept, so transient queue
pressure never fails a request. The per-request state moves into the
request context so the engine can retry queued requests, and the soft
fallback for QP allocation failures is kept.

Also make CRYPTO_DEV_HISI_ZIP select CRYPTO_ENGINE.

Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
---
 drivers/crypto/hisilicon/Kconfig          |   1 +
 drivers/crypto/hisilicon/zip/zip.h        |   5 +
 drivers/crypto/hisilicon/zip/zip_crypto.c | 358 +++++++++++++++-------
 3 files changed, 245 insertions(+), 119 deletions(-)

diff --git a/drivers/crypto/hisilicon/Kconfig b/drivers/crypto/hisilicon/Kconfig
index bd8390337d09..e280b264e427 100644
--- a/drivers/crypto/hisilicon/Kconfig
+++ b/drivers/crypto/hisilicon/Kconfig
@@ -45,6 +45,7 @@ config CRYPTO_DEV_HISI_ZIP
 	select CRYPTO_DEV_HISI_QM
 	select CRYPTO_DEFLATE
 	select CRYPTO_LZ4
+	select CRYPTO_ENGINE
 	help
 	  Support for HiSilicon ZIP Driver
 
diff --git a/drivers/crypto/hisilicon/zip/zip.h b/drivers/crypto/hisilicon/zip/zip.h
index b83f228281ab..9745703df03c 100644
--- a/drivers/crypto/hisilicon/zip/zip.h
+++ b/drivers/crypto/hisilicon/zip/zip.h
@@ -8,6 +8,9 @@
 
 #include <linux/list.h>
 #include <linux/hisi_acc_qm.h>
+#include <crypto/engine.h>
+
+#define HZIP_MAX_CRYPTO_ENGINE	64
 
 enum hisi_zip_error_type {
 	/* negative compression */
@@ -27,6 +30,8 @@ struct hisi_zip {
 	struct hisi_qm qm;
 	struct hisi_zip_ctrl *ctrl;
 	struct hisi_zip_dfx dfx;
+	struct crypto_engine *engine[HZIP_MAX_CRYPTO_ENGINE];
+	u32 engine_num;
 };
 
 struct hisi_zip_sqe {
diff --git a/drivers/crypto/hisilicon/zip/zip_crypto.c b/drivers/crypto/hisilicon/zip/zip_crypto.c
index 70adde049b53..84951bc74a96 100644
--- a/drivers/crypto/hisilicon/zip/zip_crypto.c
+++ b/drivers/crypto/hisilicon/zip/zip_crypto.c
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright (c) 2019 HiSilicon Limited. */
+#include <crypto/engine.h>
 #include <crypto/internal/acompress.h>
 #include <linux/bitfield.h>
 #include <linux/bitmap.h>
@@ -25,6 +26,7 @@
 
 #define HZIP_ALG_PRIORITY			300
 #define HZIP_SGL_SGE_NR				10
+#define HZIP_INVAL_REQ_ID			((u16)0xFFFF)
 
 #define HZIP_ALG_DEFLATE			GENMASK(5, 4)
 #define HZIP_ALG_LZ4				BIT(8)
@@ -56,10 +58,11 @@ struct hisi_zip_req {
 	dma_addr_t dma_dst;
 	struct hisi_zip_qp_ctx *qp_ctx;
 	u16 req_id;
+	enum hisi_zip_alg_type alg_type;
+	bool buf_ready;
 };
 
 struct hisi_zip_req_q {
-	struct hisi_zip_req *q;
 	unsigned long *req_bitmap;
 	spinlock_t req_lock;
 	u16 size;
@@ -71,7 +74,7 @@ struct hisi_zip_qp_ctx {
 	struct hisi_acc_sgl_pool *sgl_pool;
 	struct hisi_zip *zip_dev;
 	struct hisi_zip_ctx *ctx;
-	u8 req_type;
+	struct crypto_engine *engine;
 };
 
 struct hisi_zip_sqe_ops {
@@ -91,6 +94,7 @@ struct hisi_zip_ctx {
 	struct hisi_zip_qp_ctx qp_ctx[HZIP_CTX_Q_NUM];
 	const struct hisi_zip_sqe_ops *ops;
 	bool fallback;
+	u8 req_type;
 };
 
 static int sgl_sge_nr_set(const char *val, const struct kernel_param *kp)
@@ -135,12 +139,10 @@ static int hisi_zip_fallback_do_work(struct acomp_req *acomp_req, bool is_decomp
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
 
 	spin_lock(&req_q->req_lock);
@@ -149,28 +151,26 @@ static struct hisi_zip_req *hisi_zip_create_req(struct hisi_zip_qp_ctx *qp_ctx,
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
@@ -232,7 +232,7 @@ static void hisi_zip_fill_sqe_type(struct hisi_zip_sqe *sqe, u8 sqe_type)
 }
 
 static void hisi_zip_fill_sqe(struct hisi_zip_ctx *ctx, struct hisi_zip_sqe *sqe,
-			      u8 req_type, struct hisi_zip_req *req)
+			      struct hisi_zip_req *req)
 {
 	const struct hisi_zip_sqe_ops *ops = ctx->ops;
 
@@ -241,25 +241,18 @@ static void hisi_zip_fill_sqe(struct hisi_zip_ctx *ctx, struct hisi_zip_sqe *sqe
 	ops->fill_addr(sqe, req);
 	ops->fill_buf_size(sqe, req);
 	ops->fill_buf_type(sqe, HZIP_SGL);
-	ops->fill_req_type(sqe, req_type);
+	ops->fill_req_type(sqe, ctx->req_type);
 	ops->fill_win_size(sqe, HZIP_16K_WINSZ);
 	ops->fill_tag(sqe, req);
 	ops->fill_sqe_type(sqe, ops->sqe_type);
 }
 
-static int hisi_zip_do_work(struct hisi_zip_qp_ctx *qp_ctx,
-			    struct hisi_zip_req *req)
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
@@ -274,30 +267,49 @@ static int hisi_zip_do_work(struct hisi_zip_qp_ctx *qp_ctx,
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
 
-	hisi_zip_fill_sqe(qp_ctx->ctx, &zip_sqe, qp_ctx->req_type, req);
+	req->buf_ready = true;
+
+	return 0;
+}
+
+static void hisi_zip_unmap_req_buffers(struct hisi_zip_req *req)
+{
+	struct hisi_zip_qp_ctx *qp_ctx = req->qp_ctx;
+	struct device *dev = &qp_ctx->qp->qm->pdev->dev;
+	struct acomp_req *a_req = req->req;
+
+	hisi_acc_sg_buf_unmap(dev, a_req->dst, req->hw_dst, DMA_FROM_DEVICE);
+	hisi_acc_sg_buf_unmap(dev, a_req->src, req->hw_src, DMA_TO_DEVICE);
+
+	req->buf_ready = false;
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
+	hisi_zip_fill_sqe(qp_ctx->ctx, &zip_sqe, req);
 
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
 
@@ -333,68 +345,111 @@ static void hisi_zip_acomp_cb(struct hisi_qp *qp, void *data)
 		err = -EIO;
 	}
 
-	hisi_acc_sg_buf_unmap(dev, acomp_req->dst, req->hw_dst, DMA_FROM_DEVICE);
-	hisi_acc_sg_buf_unmap(dev, acomp_req->src, req->hw_src, DMA_TO_DEVICE);
+	hisi_zip_unmap_req_buffers(req);
 
 	acomp_req->dlen = ops->get_dstlen(sqe);
+	hisi_zip_remove_req(req);
 
-	if (acomp_req->base.complete)
-		acomp_request_complete(acomp_req, err);
-
-	hisi_zip_remove_req(qp_ctx, req);
+	local_bh_disable();
+	crypto_finalize_acomp_request(qp_ctx->engine, acomp_req, err);
+	local_bh_enable();
 }
 
-static int hisi_zip_acompress(struct acomp_req *acomp_req)
+static int hisi_zip_do_comp(struct hisi_zip_req *req)
 {
-	struct hisi_zip_ctx *ctx = crypto_tfm_ctx(acomp_req->base.tfm);
-	struct hisi_zip_qp_ctx *qp_ctx = &ctx->qp_ctx[HZIP_QPC_COMP];
-	struct hisi_zip_req *req;
-	struct device *dev;
+	struct hisi_qp *qp = req->qp_ctx->qp;
+	struct device *dev = &qp->qm->pdev->dev;
 	int ret;
 
-	if (ctx->fallback)
-		return hisi_zip_fallback_do_work(acomp_req, 0);
+	if (!req->buf_ready) {
+		ret = hisi_zip_create_req(req);
+		if (unlikely(ret))
+			return -ENOSPC;
+
+		ret = hisi_zip_map_req_buffers(req);
+		if (unlikely(ret))
+			goto remove_req;
+	}
 
-	dev = &qp_ctx->qp->qm->pdev->dev;
+	ret = hisi_zip_do_work(req);
+	if (ret == -EINPROGRESS)
+		return -EINPROGRESS;
 
-	req = hisi_zip_create_req(qp_ctx, acomp_req);
-	if (IS_ERR(req))
-		return PTR_ERR(req);
+	if (ret == -EBUSY)
+		return -ENOSPC;
 
-	ret = hisi_zip_do_work(qp_ctx, req);
-	if (unlikely(ret != -EINPROGRESS)) {
-		dev_info_ratelimited(dev, "failed to do compress (%d)!\n", ret);
-		hisi_zip_remove_req(qp_ctx, req);
-	}
+	/* -EAGAIN or other unexpected errors */
+	dev_info_ratelimited(dev, "failed to do %scompress (%d)!\n",
+			     qp->alg_type ? "de" : "", ret);
+	hisi_zip_unmap_req_buffers(req);
+remove_req:
+	hisi_zip_remove_req(req);
+	return ret;
+}
+
+static int hisi_zip_do_one_request(struct crypto_engine *engine, void *areq)
+{
+	struct acomp_req *acomp_req = container_of(areq, struct acomp_req, base);
+	struct hisi_zip_req *req = acomp_request_ctx(acomp_req);
+	int ret;
+
+	ret = hisi_zip_do_comp(req);
+	if (ret == -EINPROGRESS)
+		return 0;
 
 	return ret;
 }
 
-static int hisi_zip_adecompress(struct acomp_req *acomp_req)
+static void hisi_zip_release_req_resource(struct hisi_zip_req *req)
+{
+	if (!req->buf_ready)
+		return;
+
+	hisi_zip_unmap_req_buffers(req);
+	hisi_zip_remove_req(req);
+}
+
+static int hisi_zip_do_acomp(struct acomp_req *acomp_req, u8 alg_type)
 {
 	struct hisi_zip_ctx *ctx = crypto_tfm_ctx(acomp_req->base.tfm);
-	struct hisi_zip_qp_ctx *qp_ctx = &ctx->qp_ctx[HZIP_QPC_DECOMP];
-	struct hisi_zip_req *req;
-	struct device *dev;
+	struct hisi_zip_qp_ctx *qp_ctx = &ctx->qp_ctx[alg_type];
+	struct hisi_zip_req *req = acomp_request_ctx(acomp_req);
 	int ret;
 
-	if (ctx->fallback)
-		return hisi_zip_fallback_do_work(acomp_req, 1);
+	if (unlikely(!acomp_req->src || !acomp_req->slen ||
+		     !acomp_req->dst || !acomp_req->dlen))
+		return -EINVAL;
+
+	req->req = acomp_req;
+	req->alg_type = alg_type;
+	req->qp_ctx = qp_ctx;
+	req->buf_ready = false;
 
-	dev = &qp_ctx->qp->qm->pdev->dev;
+	if (ctx->fallback)
+		return hisi_zip_fallback_do_work(acomp_req,
+						 req->alg_type == HZIP_ALG_TYPE_DECOMP);
 
-	req = hisi_zip_create_req(qp_ctx, acomp_req);
-	if (IS_ERR(req))
-		return PTR_ERR(req);
+	ret = hisi_zip_do_comp(req);
+	if (ret != -ENOSPC)
+		return ret;
 
-	ret = hisi_zip_do_work(qp_ctx, req);
-	if (unlikely(ret != -EINPROGRESS)) {
-		dev_info_ratelimited(dev, "failed to do decompress (%d)!\n",
-				     ret);
-		hisi_zip_remove_req(qp_ctx, req);
+	ret = crypto_transfer_acomp_request_to_engine(qp_ctx->engine, acomp_req);
+	if (ret != -EINPROGRESS && ret != -EBUSY) {
+		hisi_zip_release_req_resource(req);
+		return ret;
 	}
 
-	return ret;
+	return -EINPROGRESS;
+}
+
+static int hisi_zip_acompress(struct acomp_req *acomp_req)
+{
+	return hisi_zip_do_acomp(acomp_req, HZIP_ALG_TYPE_COMP);
+}
+
+static int hisi_zip_adecompress(struct acomp_req *acomp_req)
+{
+	return hisi_zip_do_acomp(acomp_req, HZIP_ALG_TYPE_DECOMP);
 }
 
 static int hisi_zip_decompress(struct acomp_req *acomp_req)
@@ -423,6 +478,8 @@ static int hisi_zip_ctx_init(struct hisi_zip_ctx *hisi_zip_ctx, u8 req_type, int
 	struct hisi_zip *hisi_zip;
 	int ret, i;
 
+	hisi_zip_ctx->req_type = req_type;
+
 	/* alg_type = 0 for compress, 1 for decompress in hw sqe */
 	for (i = 0; i < HZIP_CTX_Q_NUM; i++)
 		alg_type[i] = i;
@@ -434,13 +491,22 @@ static int hisi_zip_ctx_init(struct hisi_zip_ctx *hisi_zip_ctx, u8 req_type, int
 	}
 
 	hisi_zip = container_of(qps[0]->qm, struct hisi_zip, qm);
+	if (!hisi_zip->engine_num) {
+		hisi_qm_free_qps(qps, HZIP_CTX_Q_NUM);
+		return -ENODEV;
+	}
 
 	for (i = 0; i < HZIP_CTX_Q_NUM; i++) {
 		qp_ctx = &hisi_zip_ctx->qp_ctx[i];
 		qp_ctx->ctx = hisi_zip_ctx;
 		qp_ctx->zip_dev = hisi_zip;
-		qp_ctx->req_type = req_type;
 		qp_ctx->qp = qps[i];
+		qp_ctx->engine =
+			hisi_zip->engine[qps[i]->qp_id % hisi_zip->engine_num];
+		if (!qp_ctx->engine) {
+			hisi_qm_free_qps(qps, HZIP_CTX_Q_NUM);
+			return -ENODEV;
+		}
 	}
 
 	hisi_zip_ctx->ops = &hisi_zip_ops;
@@ -475,26 +541,13 @@ static int hisi_zip_create_req_q(struct hisi_zip_ctx *ctx)
 			if (i == 0)
 				return ret;
 
-			goto err_free_comp_q;
+			goto err_free_comp_bitmap;
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
 
-err_free_decomp_bitmap:
-	bitmap_free(ctx->qp_ctx[HZIP_QPC_DECOMP].req_q.req_bitmap);
-err_free_comp_q:
-	kfree(ctx->qp_ctx[HZIP_QPC_COMP].req_q.q);
 err_free_comp_bitmap:
 	bitmap_free(ctx->qp_ctx[HZIP_QPC_COMP].req_q.req_bitmap);
 	return ret;
@@ -504,10 +557,8 @@ static void hisi_zip_release_req_q(struct hisi_zip_ctx *ctx)
 {
 	int i;
 
-	for (i = 0; i < HZIP_CTX_Q_NUM; i++) {
-		kfree(ctx->qp_ctx[i].req_q.q);
+	for (i = 0; i < HZIP_CTX_Q_NUM; i++)
 		bitmap_free(ctx->qp_ctx[i].req_q.req_bitmap);
-	}
 }
 
 static int hisi_zip_create_sgl_pool(struct hisi_zip_ctx *ctx)
@@ -607,12 +658,12 @@ static void hisi_zip_acomp_exit(struct crypto_acomp *tfm)
 	hisi_zip_ctx_exit(ctx);
 }
 
-static struct acomp_alg hisi_zip_acomp_deflate = {
-	.init			= hisi_zip_acomp_init,
-	.exit			= hisi_zip_acomp_exit,
-	.compress		= hisi_zip_acompress,
-	.decompress		= hisi_zip_adecompress,
-	.base			= {
+static struct acomp_engine_alg hisi_zip_acomp_deflate = {
+	.base.init		= hisi_zip_acomp_init,
+	.base.exit		= hisi_zip_acomp_exit,
+	.base.compress		= hisi_zip_acompress,
+	.base.decompress	= hisi_zip_adecompress,
+	.base.base		= {
 		.cra_name		= "deflate",
 		.cra_driver_name	= "hisi-deflate-acomp",
 		.cra_flags		= CRYPTO_ALG_ASYNC |
@@ -620,7 +671,11 @@ static struct acomp_alg hisi_zip_acomp_deflate = {
 		.cra_module		= THIS_MODULE,
 		.cra_priority		= HZIP_ALG_PRIORITY,
 		.cra_ctxsize		= sizeof(struct hisi_zip_ctx),
-	}
+		.cra_reqsize		= sizeof(struct hisi_zip_req),
+	},
+	.op			= {
+		.do_one_request = hisi_zip_do_one_request,
+	},
 };
 
 static int hisi_zip_register_deflate(struct hisi_qm *qm)
@@ -630,7 +685,7 @@ static int hisi_zip_register_deflate(struct hisi_qm *qm)
 	if (!hisi_zip_alg_support(qm, HZIP_ALG_DEFLATE))
 		return 0;
 
-	ret = crypto_register_acomp(&hisi_zip_acomp_deflate);
+	ret = crypto_engine_register_acomp(&hisi_zip_acomp_deflate);
 	if (ret)
 		dev_err(&qm->pdev->dev, "failed to register to deflate (%d)!\n", ret);
 
@@ -642,15 +697,15 @@ static void hisi_zip_unregister_deflate(struct hisi_qm *qm)
 	if (!hisi_zip_alg_support(qm, HZIP_ALG_DEFLATE))
 		return;
 
-	crypto_unregister_acomp(&hisi_zip_acomp_deflate);
+	crypto_engine_unregister_acomp(&hisi_zip_acomp_deflate);
 }
 
-static struct acomp_alg hisi_zip_acomp_lz4 = {
-	.init			= hisi_zip_acomp_init,
-	.exit			= hisi_zip_acomp_exit,
-	.compress		= hisi_zip_acompress,
-	.decompress		= hisi_zip_decompress,
-	.base			= {
+static struct acomp_engine_alg hisi_zip_acomp_lz4 = {
+	.base.init		= hisi_zip_acomp_init,
+	.base.exit		= hisi_zip_acomp_exit,
+	.base.compress		= hisi_zip_acompress,
+	.base.decompress	= hisi_zip_decompress,
+	.base.base		= {
 		.cra_name		= "lz4",
 		.cra_driver_name	= "hisi-lz4-acomp",
 		.cra_flags		= CRYPTO_ALG_ASYNC |
@@ -658,7 +713,11 @@ static struct acomp_alg hisi_zip_acomp_lz4 = {
 		.cra_module		= THIS_MODULE,
 		.cra_priority		= HZIP_ALG_PRIORITY,
 		.cra_ctxsize		= sizeof(struct hisi_zip_ctx),
-	}
+		.cra_reqsize		= sizeof(struct hisi_zip_req),
+	},
+	.op			= {
+		.do_one_request = hisi_zip_do_one_request,
+	},
 };
 
 static int hisi_zip_register_lz4(struct hisi_qm *qm)
@@ -668,7 +727,7 @@ static int hisi_zip_register_lz4(struct hisi_qm *qm)
 	if (!hisi_zip_alg_support(qm, HZIP_ALG_LZ4))
 		return 0;
 
-	ret = crypto_register_acomp(&hisi_zip_acomp_lz4);
+	ret = crypto_engine_register_acomp(&hisi_zip_acomp_lz4);
 	if (ret)
 		dev_err(&qm->pdev->dev, "failed to register to LZ4 (%d)!\n", ret);
 
@@ -680,17 +739,75 @@ static void hisi_zip_unregister_lz4(struct hisi_qm *qm)
 	if (!hisi_zip_alg_support(qm, HZIP_ALG_LZ4))
 		return;
 
-	crypto_unregister_acomp(&hisi_zip_acomp_lz4);
+	crypto_engine_unregister_acomp(&hisi_zip_acomp_lz4);
+}
+
+static void hisi_zip_free_crypto_engine(struct hisi_qm *qm)
+{
+	struct hisi_zip *hisi_zip = container_of(qm, struct hisi_zip, qm);
+	u32 i;
+
+	for (i = 0; i < hisi_zip->engine_num; i++) {
+		if (hisi_zip->engine[i])
+			crypto_engine_exit(hisi_zip->engine[i]);
+	}
+
+	hisi_zip->engine_num = 0;
+}
+
+static int hisi_zip_alloc_crypto_engine(struct hisi_qm *qm)
+{
+	struct hisi_zip *hisi_zip = container_of(qm, struct hisi_zip, qm);
+	u32 engine_num = min_t(u32, qm->qp_num, HZIP_MAX_CRYPTO_ENGINE);
+	struct device *dev = &qm->pdev->dev;
+	u16 qlen = qm->qp_array[0].sq_depth;
+	int ret;
+	u32 i;
+
+	for (i = 0; i < engine_num; i++) {
+		hisi_zip->engine[i] = crypto_engine_alloc_init_and_set(dev, true,
+								       false, qlen);
+		if (!hisi_zip->engine[i]) {
+			dev_err(dev, "failed to alloc crypto engine.\n");
+			ret = -ENOMEM;
+			goto free_engine;
+		}
+
+		ret = crypto_engine_start(hisi_zip->engine[i]);
+		if (ret) {
+			dev_err(dev, "failed to start crypto engine.\n");
+			crypto_engine_exit(hisi_zip->engine[i]);
+			hisi_zip->engine[i] = NULL;
+			goto free_engine;
+		}
+	}
+
+	hisi_zip->engine_num = engine_num;
+
+	return 0;
+
+free_engine:
+	for (i = 0; i < engine_num; i++) {
+		if (hisi_zip->engine[i])
+			crypto_engine_exit(hisi_zip->engine[i]);
+	}
+
+	return ret;
 }
 
 int hisi_zip_register_to_crypto(struct hisi_qm *qm)
 {
-	int ret = 0;
+	int ret;
+
+	ret = hisi_zip_alloc_crypto_engine(qm);
+	if (ret)
+		return ret;
 
 	mutex_lock(&zip_algs_lock);
 	if (zip_available_devs) {
 		zip_available_devs++;
-		goto unlock;
+		mutex_unlock(&zip_algs_lock);
+		return 0;
 	}
 
 	ret = hisi_zip_register_deflate(qm);
@@ -710,6 +827,8 @@ int hisi_zip_register_to_crypto(struct hisi_qm *qm)
 	hisi_zip_unregister_deflate(qm);
 unlock:
 	mutex_unlock(&zip_algs_lock);
+	hisi_zip_free_crypto_engine(qm);
+
 	return ret;
 }
 
@@ -724,4 +843,5 @@ void hisi_zip_unregister_from_crypto(struct hisi_qm *qm)
 
 unlock:
 	mutex_unlock(&zip_algs_lock);
+	hisi_zip_free_crypto_engine(qm);
 }
-- 
2.43.0

