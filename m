Received: from canpmsgout12.his.huawei.com (canpmsgout12.his.huawei.com [113.46.200.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 334663E120D;
	Thu, 28 May 2026 11:57:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779969428; cv=none; b=sX9rjlO2C8KV4zVOL49+KnhsKX969VX9HlZWLVMZUY1Gfr/tTFrEb51hAJv/Fprf2ygrGeJkZj59fWC71SrXVNdQ8UdXIbywILpc42PM9iq4SXtmXhMpji3RFbGymeeNUHg4Tfa/rG+5O0yeZBSCVTbdk8P/JHswiuehLuYNglk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779969428; c=relaxed/simple;
	bh=Kq7Jhc7sY6IWnEPiN9ZM8FDbf6iXNUP8WHHQxnxQ+mA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JW0iAwyjNnQJM8wdoyJaXZhXMvCIHfB+BgOk8P2mKxX4721bhNk7OOnLrouWN8Baf6Ys55x/g+AYbm35CDnav7OocWhk8+d6w38IkQCiNf38a5HR1V/rMYgNotvILzjtUFT0MtHCBO6QnF41LTuOB4DWSPWTs76nhUffT5to6B8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=LObiiKfO; arc=none smtp.client-ip=113.46.200.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="LObiiKfO"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=fbf7Hj3PIukobsWSY9514/dVnqMJTTqdf0sVvSUGSbk=;
	b=LObiiKfOiXnnyf84BBNodtE/inh07mxr9Q0GdjyQxniePDWO/yL98vvXn7WNOMc5V9a4Ce2UT
	CosICgvaOSVs/j2WSdz80QOhgGsQ5r5N2xgVRoyBsudA7XrCD73YiLTauVRSLdndlx5byaZNzxF
	rQnTc96YjZU+xBblJVJjGww=
Received: from mail.maildlp.com (unknown [172.19.163.214])
	by canpmsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4gR4X03LYlznTc6;
	Thu, 28 May 2026 19:49:04 +0800 (CST)
Received: from kwepemr100008.china.huawei.com (unknown [7.202.195.119])
	by mail.maildlp.com (Postfix) with ESMTPS id EBAEC4056C;
	Thu, 28 May 2026 19:57:00 +0800 (CST)
Received: from localhost.localdomain (10.50.163.32) by
 kwepemr100008.china.huawei.com (7.202.195.119) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Thu, 28 May 2026 19:57:00 +0800
From: ZongYu Wu <wuzongyu1@huawei.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<fanghao11@huawei.com>, <liulongfang@huawei.com>, <qianweili@huawei.com>,
	<wangzhou1@hisilicon.com>, <huangchenghai2@huawei.com>,
	<linwenkai6@hisilicon.com>
Subject: [PATCH v2 3/5] crypto: hisilicon/hpre - implement full backlog support for hpre driver
Date: Thu, 28 May 2026 19:55:29 +0800
Message-ID: <20260528115531.174593-4-wuzongyu1@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20260528115531.174593-1-wuzongyu1@huawei.com>
References: <20260528115531.174593-1-wuzongyu1@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemr100008.china.huawei.com (7.202.195.119)

From: lizhi <lizhi206@huawei.com>

When the hardware queue returns -EBUSY, requests are queued instead of
being failed immediately. The driver retries queued requests from the
completion path after earlier requests have finished.

This reduces request failures caused by temporary hardware congestion and
improves throughput and stability under high load.

Signed-off-by: lizhi <lizhi206@huawei.com>
Signed-off-by: Zongyu Wu <wuzongyu1@huawei.com>
---
 drivers/crypto/hisilicon/hpre/hpre_crypto.c | 223 +++++++++++++++-----
 1 file changed, 166 insertions(+), 57 deletions(-)

diff --git a/drivers/crypto/hisilicon/hpre/hpre_crypto.c b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
index 09077abbf6ad..5d5c4d5a9fbc 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_crypto.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
@@ -30,6 +30,7 @@ struct hpre_ctx;
 #define HPRE_DH_G_FLAG		0x02
 #define HPRE_TRY_SEND_TIMES	100
 #define HPRE_INVLD_REQ_ID		(-1)
+#define HPRE_ALG_TYPE_MASK	0x1F
 
 #define HPRE_SQE_ALG_BITS	5
 #define HPRE_SQE_DONE_SHIFT	30
@@ -39,6 +40,7 @@ struct hpre_ctx;
 #define HPRE_DFX_US_TO_NS	1000
 
 #define HPRE_ENABLE_HPCORE_SHIFT	7
+#define HPRE_ECDH_CLR_DATA_SHIFT	2
 
 /* due to nist p521  */
 #define HPRE_ECC_MAX_KSZ	66
@@ -138,6 +140,8 @@ struct hpre_asym_request {
 	int err;
 	hpre_cb cb;
 	struct timespec64 req_time;
+	struct crypto_async_request *base;
+	struct list_head list;
 };
 
 static inline unsigned int hpre_align_sz(void)
@@ -241,8 +245,8 @@ static void hpre_hw_data_clr_all(struct hpre_ctx *ctx,
 				 struct scatterlist *dst,
 				 struct scatterlist *src)
 {
-	struct device *dev = ctx->dev;
 	struct hpre_sqe *sqe = &req->req;
+	struct device *dev = ctx->dev;
 	dma_addr_t tmp;
 
 	tmp = le64_to_cpu(sqe->in);
@@ -270,6 +274,34 @@ static void hpre_hw_data_clr_all(struct hpre_ctx *ctx,
 	}
 }
 
+static void hpre_ecdh_hw_data_clr_all(struct hpre_ctx *ctx,
+				      struct hpre_asym_request *req,
+				      struct scatterlist *dst,
+				      struct scatterlist *src)
+{
+	struct hpre_sqe *sqe = &req->req;
+	struct device *dev = ctx->dev;
+	dma_addr_t dma;
+
+	dma = le64_to_cpu(sqe->in);
+	if (unlikely(dma_mapping_error(dev, dma)))
+		return;
+
+	/* req->src may contain garbage value, check both src and req->src before freeing */
+	if (src && req->src)
+		dma_free_coherent(dev, ctx->key_sz << HPRE_ECDH_CLR_DATA_SHIFT,
+				  req->src, dma);
+
+	dma = le64_to_cpu(sqe->out);
+	if (unlikely(dma_mapping_error(dev, dma)))
+		return;
+
+	if (req->dst)
+		dma_free_coherent(dev, ctx->key_sz << 1, req->dst, dma);
+	if (dst)
+		dma_unmap_single(dev, dma, ctx->key_sz << 1, DMA_FROM_DEVICE);
+}
+
 static int hpre_alg_res_post_hf(struct hpre_ctx *ctx, struct hpre_sqe *sqe,
 				void **kreq)
 {
@@ -323,6 +355,94 @@ static bool hpre_is_bd_timeout(struct hpre_asym_request *req,
 	return true;
 }
 
+static int hpre_send(struct hpre_ctx *ctx, struct hpre_sqe *msg)
+{
+	struct hpre_dfx *dfx = ctx->hpre->debug.dfx;
+	int cnt = 0;
+	int ret;
+
+	do {
+		ret = hisi_qp_send(ctx->qp, msg);
+		if (ret != -EBUSY)
+			break;
+		atomic64_inc(&dfx[HPRE_SEND_BUSY_CNT].value);
+	} while (cnt++ < HPRE_TRY_SEND_TIMES);
+
+	if (likely(!ret)) {
+		atomic64_inc(&dfx[HPRE_SEND_CNT].value);
+		return ret;
+	}
+
+	if (ret != -EBUSY)
+		atomic64_inc(&dfx[HPRE_SEND_FAIL_CNT].value);
+
+	return ret;
+}
+
+static int hpre_send_backlog(struct hpre_ctx *ctx, struct hpre_sqe *msg)
+{
+	struct hpre_dfx *dfx = ctx->hpre->debug.dfx;
+	int ret;
+
+	ret = hisi_qp_send(ctx->qp, msg);
+	if (likely(!ret))
+		atomic64_inc(&dfx[HPRE_SEND_CNT].value);
+	else if (unlikely(ret != -EBUSY))
+		atomic64_inc(&dfx[HPRE_SEND_FAIL_CNT].value);
+	else
+		atomic64_inc(&dfx[HPRE_SEND_BUSY_CNT].value);
+
+	return ret;
+}
+
+static void hpre_alg_hw_data_clr_all(struct hpre_ctx *ctx, struct hpre_asym_request *h_req)
+{
+	switch (le32_to_cpu(h_req->req.dw0) & HPRE_ALG_TYPE_MASK) {
+	case HPRE_ALG_DH_G2:
+	case HPRE_ALG_DH:
+		hpre_hw_data_clr_all(ctx, h_req, h_req->areq.dh->dst, h_req->areq.dh->src);
+		break;
+	case HPRE_ALG_NC_NCRT:
+	case HPRE_ALG_NC_CRT:
+		hpre_hw_data_clr_all(ctx, h_req, h_req->areq.rsa->dst, h_req->areq.rsa->src);
+		break;
+	case HPRE_ALG_ECC_MUL:
+		hpre_ecdh_hw_data_clr_all(ctx, h_req, h_req->areq.ecdh->dst, h_req->areq.ecdh->src);
+		break;
+	default:
+		break;
+	}
+}
+
+static void hpre_alg_send_backlog(struct hisi_qp *qp)
+{
+	struct hpre_asym_request *req, *tmp;
+	int ret;
+
+	spin_lock_bh(&qp->backlog.lock);
+	list_for_each_entry_safe(req, tmp, &qp->backlog.list, list) {
+		ret = hpre_send_backlog(req->ctx, &req->req);
+		switch (ret) {
+		case 0:
+			list_del(&req->list);
+			crypto_request_complete(req->base, -EINPROGRESS);
+			break;
+		case -EBUSY:
+			/* Device is busy and stop send any request. */
+			goto unlock;
+		default:
+			/* Current no fallback for any send error. */
+			list_del(&req->list);
+			hpre_alg_hw_data_clr_all(req->ctx, req);
+			crypto_request_complete(req->base, -EIO);
+			break;
+		}
+	}
+
+unlock:
+	spin_unlock_bh(&qp->backlog.lock);
+}
+
 static void hpre_dh_cb(struct hpre_ctx *ctx, void *resp)
 {
 	struct hpre_dfx *dfx = ctx->hpre->debug.dfx;
@@ -377,6 +497,7 @@ static void hpre_alg_cb(struct hisi_qp *qp, void *resp)
 	}
 
 	h_req->cb(h_req->ctx, resp);
+	hpre_alg_send_backlog(qp);
 }
 
 static int hpre_ctx_init(struct hpre_ctx *ctx, u8 type)
@@ -450,25 +571,39 @@ static int hpre_msg_request_set(struct hpre_ctx *ctx, void *req, bool is_rsa)
 	return 0;
 }
 
-static int hpre_send(struct hpre_ctx *ctx, struct hpre_sqe *msg)
+static int hpre_alg_try_enqueue(struct hpre_asym_request *hpre_req)
 {
-	struct hpre_dfx *dfx = ctx->hpre->debug.dfx;
-	int ctr = 0;
+	struct hisi_qp *qp = hpre_req->ctx->qp;
+
+	/* Check if any request is already backlogged */
+	if (!list_empty(&qp->backlog.list))
+		return -EBUSY;
+
+	/* Try to enqueue to HW ring */
+	return hpre_send_backlog(hpre_req->ctx, &hpre_req->req);
+}
+
+static int hpre_alg_send_message(struct hpre_asym_request *hpre_req)
+{
+	struct hisi_qp *qp = hpre_req->ctx->qp;
 	int ret;
 
-	do {
-		atomic64_inc(&dfx[HPRE_SEND_CNT].value);
-		ret = hisi_qp_send(ctx->qp, msg);
-		if (ret != -EBUSY)
-			break;
-		atomic64_inc(&dfx[HPRE_SEND_BUSY_CNT].value);
-	} while (ctr++ < HPRE_TRY_SEND_TIMES);
+	if (!(hpre_req->base->flags & CRYPTO_TFM_REQ_MAY_BACKLOG)) {
+		ret = hpre_send(hpre_req->ctx, &hpre_req->req);
+		if (ret == -EBUSY)
+			return -ENOSPC;
+	} else {
+		ret = hpre_alg_try_enqueue(hpre_req);
+		if (ret == -EBUSY) {
+			spin_lock_bh(&qp->backlog.lock);
+			list_add_tail(&hpre_req->list, &qp->backlog.list);
+			spin_unlock_bh(&qp->backlog.lock);
+			return -EBUSY;
+		}
+	}
 
 	if (likely(!ret))
-		return ret;
-
-	if (ret != -EBUSY)
-		atomic64_inc(&dfx[HPRE_SEND_FAIL_CNT].value);
+		return -EINPROGRESS;
 
 	return ret;
 }
@@ -482,6 +617,7 @@ static int hpre_dh_compute_value(struct kpp_request *req)
 	struct hpre_sqe *msg = &hpre_req->req;
 	int ret;
 
+	hpre_req->base = &req->base;
 	ret = hpre_msg_request_set(ctx, req, false);
 	if (unlikely(ret))
 		return ret;
@@ -503,14 +639,12 @@ static int hpre_dh_compute_value(struct kpp_request *req)
 	else
 		msg->dw0 = cpu_to_le32(le32_to_cpu(msg->dw0) | HPRE_ALG_DH);
 
-	/* success */
-	ret = hpre_send(ctx, msg);
-	if (likely(!ret))
-		return -EINPROGRESS;
+	ret = hpre_alg_send_message(hpre_req);
+	if (likely(ret == -EINPROGRESS || ret == -EBUSY))
+		return ret;
 
 clear_all:
 	hpre_hw_data_clr_all(ctx, hpre_req, req->dst, req->src);
-
 	return ret;
 }
 
@@ -755,6 +889,7 @@ static int hpre_rsa_enc(struct akcipher_request *req)
 	struct hpre_sqe *msg = &hpre_req->req;
 	int ret;
 
+	hpre_req->base = &req->base;
 	/* For unsupported key size and unavailable devices, use soft tfm instead */
 	if (ctx->fallback) {
 		akcipher_request_set_tfm(req, ctx->rsa.soft_tfm);
@@ -781,10 +916,9 @@ static int hpre_rsa_enc(struct akcipher_request *req)
 	if (unlikely(ret))
 		goto clear_all;
 
-	/* success */
-	ret = hpre_send(ctx, msg);
-	if (likely(!ret))
-		return -EINPROGRESS;
+	ret = hpre_alg_send_message(hpre_req);
+	if (likely(ret == -EINPROGRESS || ret == -EBUSY))
+		return ret;
 
 clear_all:
 	hpre_hw_data_clr_all(ctx, hpre_req, req->dst, req->src);
@@ -801,6 +935,7 @@ static int hpre_rsa_dec(struct akcipher_request *req)
 	struct hpre_sqe *msg = &hpre_req->req;
 	int ret;
 
+	hpre_req->base = &req->base;
 	/* For unsupported key size and unavailable devices, use soft tfm instead */
 	if (ctx->fallback) {
 		akcipher_request_set_tfm(req, ctx->rsa.soft_tfm);
@@ -834,10 +969,9 @@ static int hpre_rsa_dec(struct akcipher_request *req)
 	if (unlikely(ret))
 		goto clear_all;
 
-	/* success */
-	ret = hpre_send(ctx, msg);
-	if (likely(!ret))
-		return -EINPROGRESS;
+	ret = hpre_alg_send_message(hpre_req);
+	if (likely(ret == -EINPROGRESS || ret == -EBUSY))
+		return ret;
 
 clear_all:
 	hpre_hw_data_clr_all(ctx, hpre_req, req->dst, req->src);
@@ -1387,32 +1521,6 @@ static int hpre_ecdh_set_secret(struct crypto_kpp *tfm, const void *buf,
 	return 0;
 }
 
-static void hpre_ecdh_hw_data_clr_all(struct hpre_ctx *ctx,
-				      struct hpre_asym_request *req,
-				      struct scatterlist *dst,
-				      struct scatterlist *src)
-{
-	struct device *dev = ctx->dev;
-	struct hpre_sqe *sqe = &req->req;
-	dma_addr_t dma;
-
-	dma = le64_to_cpu(sqe->in);
-	if (unlikely(dma_mapping_error(dev, dma)))
-		return;
-
-	if (src && req->src)
-		dma_free_coherent(dev, ctx->key_sz << 2, req->src, dma);
-
-	dma = le64_to_cpu(sqe->out);
-	if (unlikely(dma_mapping_error(dev, dma)))
-		return;
-
-	if (req->dst)
-		dma_free_coherent(dev, ctx->key_sz << 1, req->dst, dma);
-	if (dst)
-		dma_unmap_single(dev, dma, ctx->key_sz << 1, DMA_FROM_DEVICE);
-}
-
 static void hpre_ecdh_cb(struct hpre_ctx *ctx, void *resp)
 {
 	unsigned int curve_sz = hpre_ecdh_get_curvesz(ctx->curve_id);
@@ -1538,6 +1646,7 @@ static int hpre_ecdh_compute_value(struct kpp_request *req)
 	struct hpre_sqe *msg = &hpre_req->req;
 	int ret;
 
+	hpre_req->base = &req->base;
 	ret = hpre_ecdh_msg_request_set(ctx, req);
 	if (unlikely(ret)) {
 		dev_err(dev, "failed to set ecdh request, ret = %d!\n", ret);
@@ -1563,9 +1672,9 @@ static int hpre_ecdh_compute_value(struct kpp_request *req)
 	msg->dw0 = cpu_to_le32(le32_to_cpu(msg->dw0) | HPRE_ALG_ECC_MUL);
 	msg->resv1 = ctx->enable_hpcore << HPRE_ENABLE_HPCORE_SHIFT;
 
-	ret = hpre_send(ctx, msg);
-	if (likely(!ret))
-		return -EINPROGRESS;
+	ret = hpre_alg_send_message(hpre_req);
+	if (likely(ret == -EINPROGRESS || ret == -EBUSY))
+		return ret;
 
 clear_all:
 	hpre_ecdh_hw_data_clr_all(ctx, hpre_req, req->dst, req->src);
-- 
2.33.0

