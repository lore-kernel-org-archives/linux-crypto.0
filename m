Received: from canpmsgout09.his.huawei.com (canpmsgout09.his.huawei.com [113.46.200.224])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A077F337B9A;
	Thu, 18 Dec 2025 13:45:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.224
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766065506; cv=none; b=NvlJIHSZSvuV+qmtfMoVA/IYx+CTQFUjWUishRzCnjIIIILn4Upmok2bB1rquvh5Ur4i/kC2PIGQevxIGqwZ1QJnR3ZH4OI9Oba3uW7gWeuoL6wPgkFrdMwYm7NVswxRCMQ7aqMgmqGLQrwQt6NK+mQcnF3tRDkw5CWBqHig/bw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766065506; c=relaxed/simple;
	bh=ZNHCdJaA3afZTO4UAmrHRiw7G5rKI5FGEUItIxMSaww=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IN7ARafwElD5D761gmOS5k/79Vu/+IbyPZzfC+XrAZtrfiRxDateRyPbDG2B+N4S31jfRi7bKvY6TKlIlBagH0+frm5HmFBXBuZAJnqrtyFsIVoj7eyrGv/eCHJE4pSo+gZLZqCE0Sl9m/ej+lrxMpaY85uC98QAAayakjfh3OA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=cy/wPIol; arc=none smtp.client-ip=113.46.200.224
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="cy/wPIol"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=YAR4Mw5sArcxSPcXElFn5EAVOS+ZDvZEjvDw+TPN/Jo=;
	b=cy/wPIollasrRDWsRbvXju8fJ1JlEVXVPuvVn1V57VCpbyZMBPxTTxdm4VCu2QsM652TQfrz8
	eN0tNyR7E0CWJzEMgTWIGga5dJB9B5agClHxHF8pnMoUCsJiMbBOmChdT5yzO1RL/ifOdDHDSsn
	ErBHKwLp2zR0dfMGY3F5C00=
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by canpmsgout09.his.huawei.com (SkyGuard) with ESMTPS id 4dXBfZ0QPnz1cyPb;
	Thu, 18 Dec 2025 21:41:58 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id E703014033F;
	Thu, 18 Dec 2025 21:45:00 +0800 (CST)
Received: from kwepemq200001.china.huawei.com (7.202.195.16) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
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
Subject: [PATCH v4 03/11] crypto: hisilicon/hpre: extend tag field to 64 bits for better performance
Date: Thu, 18 Dec 2025 21:44:44 +0800
Message-ID: <20251218134452.1125469-4-huangchenghai2@huawei.com>
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

From: lizhi <lizhi206@huawei.com>

This commit expands the tag field in hpre_sqe structure from 16-bit
to 64-bit. The change enables storing request addresses directly
in the tag field, allowing callback functions to access request messages
without the previous indirection mechanism.

By eliminating the need for lookup tables, this modification reduces lock
contention and associated overhead, leading to improved efficiency and
simplified code.

Fixes: c8b4b477079d ("crypto: hisilicon - add HiSilicon HPRE accelerator")
Signed-off-by: lizhi <lizhi206@huawei.com>
Signed-off-by: Weili Qian <qianweili@huawei.com>
Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
---
 drivers/crypto/hisilicon/hpre/hpre.h        |   5 +-
 drivers/crypto/hisilicon/hpre/hpre_crypto.c | 142 ++++----------------
 2 files changed, 25 insertions(+), 122 deletions(-)

diff --git a/drivers/crypto/hisilicon/hpre/hpre.h b/drivers/crypto/hisilicon/hpre/hpre.h
index 0f3ddbadbcf9..021dbd9a1d48 100644
--- a/drivers/crypto/hisilicon/hpre/hpre.h
+++ b/drivers/crypto/hisilicon/hpre/hpre.h
@@ -94,9 +94,8 @@ struct hpre_sqe {
 	__le64 key;
 	__le64 in;
 	__le64 out;
-	__le16 tag;
-	__le16 resv2;
-#define _HPRE_SQE_ALIGN_EXT	7
+	__le64 tag;
+#define _HPRE_SQE_ALIGN_EXT	6
 	__le32 rsvd1[_HPRE_SQE_ALIGN_EXT];
 };
 
diff --git a/drivers/crypto/hisilicon/hpre/hpre_crypto.c b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
index 21ccf879f70c..4197281c8dff 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_crypto.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
@@ -108,12 +108,10 @@ struct hpre_ecdh_ctx {
 struct hpre_ctx {
 	struct hisi_qp *qp;
 	struct device *dev;
-	struct hpre_asym_request **req_list;
 	struct hpre *hpre;
 	spinlock_t req_lock;
 	unsigned int key_sz;
 	bool crt_g2_mode;
-	struct idr req_idr;
 	union {
 		struct hpre_rsa_ctx rsa;
 		struct hpre_dh_ctx dh;
@@ -136,7 +134,6 @@ struct hpre_asym_request {
 		struct kpp_request *ecdh;
 	} areq;
 	int err;
-	int req_id;
 	hpre_cb cb;
 	struct timespec64 req_time;
 };
@@ -151,58 +148,13 @@ static inline unsigned int hpre_align_pd(void)
 	return (hpre_align_sz() - 1) & ~(crypto_tfm_ctx_alignment() - 1);
 }
 
-static int hpre_alloc_req_id(struct hpre_ctx *ctx)
+static void hpre_dfx_add_req_time(struct hpre_asym_request *hpre_req)
 {
-	unsigned long flags;
-	int id;
-
-	spin_lock_irqsave(&ctx->req_lock, flags);
-	id = idr_alloc(&ctx->req_idr, NULL, 0, ctx->qp->sq_depth, GFP_ATOMIC);
-	spin_unlock_irqrestore(&ctx->req_lock, flags);
-
-	return id;
-}
-
-static void hpre_free_req_id(struct hpre_ctx *ctx, int req_id)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&ctx->req_lock, flags);
-	idr_remove(&ctx->req_idr, req_id);
-	spin_unlock_irqrestore(&ctx->req_lock, flags);
-}
-
-static int hpre_add_req_to_ctx(struct hpre_asym_request *hpre_req)
-{
-	struct hpre_ctx *ctx;
-	struct hpre_dfx *dfx;
-	int id;
-
-	ctx = hpre_req->ctx;
-	id = hpre_alloc_req_id(ctx);
-	if (unlikely(id < 0))
-		return -EINVAL;
-
-	ctx->req_list[id] = hpre_req;
-	hpre_req->req_id = id;
+	struct hpre_ctx *ctx = hpre_req->ctx;
+	struct hpre_dfx *dfx = ctx->hpre->debug.dfx;
 
-	dfx = ctx->hpre->debug.dfx;
 	if (atomic64_read(&dfx[HPRE_OVERTIME_THRHLD].value))
 		ktime_get_ts64(&hpre_req->req_time);
-
-	return id;
-}
-
-static void hpre_rm_req_from_ctx(struct hpre_asym_request *hpre_req)
-{
-	struct hpre_ctx *ctx = hpre_req->ctx;
-	int id = hpre_req->req_id;
-
-	if (hpre_req->req_id >= 0) {
-		hpre_req->req_id = HPRE_INVLD_REQ_ID;
-		ctx->req_list[id] = NULL;
-		hpre_free_req_id(ctx, id);
-	}
 }
 
 static struct hisi_qp *hpre_get_qp_and_start(u8 type)
@@ -340,26 +292,19 @@ static void hpre_hw_data_clr_all(struct hpre_ctx *ctx,
 static int hpre_alg_res_post_hf(struct hpre_ctx *ctx, struct hpre_sqe *sqe,
 				void **kreq)
 {
-	struct hpre_asym_request *req;
 	unsigned int err, done, alg;
-	int id;
 
 #define HPRE_NO_HW_ERR		0
 #define HPRE_HW_TASK_DONE	3
 #define HREE_HW_ERR_MASK	GENMASK(10, 0)
 #define HREE_SQE_DONE_MASK	GENMASK(1, 0)
 #define HREE_ALG_TYPE_MASK	GENMASK(4, 0)
-	id = (int)le16_to_cpu(sqe->tag);
-	req = ctx->req_list[id];
-	hpre_rm_req_from_ctx(req);
-	*kreq = req;
+	*kreq = (void *)le64_to_cpu(sqe->tag);
 
 	err = (le32_to_cpu(sqe->dw0) >> HPRE_SQE_ALG_BITS) &
 		HREE_HW_ERR_MASK;
-
 	done = (le32_to_cpu(sqe->dw0) >> HPRE_SQE_DONE_SHIFT) &
 		HREE_SQE_DONE_MASK;
-
 	if (likely(err == HPRE_NO_HW_ERR && done == HPRE_HW_TASK_DONE))
 		return 0;
 
@@ -370,34 +315,9 @@ static int hpre_alg_res_post_hf(struct hpre_ctx *ctx, struct hpre_sqe *sqe,
 	return -EINVAL;
 }
 
-static int hpre_ctx_set(struct hpre_ctx *ctx, struct hisi_qp *qp, int qlen)
-{
-	struct hpre *hpre;
-
-	if (!ctx || !qp || qlen < 0)
-		return -EINVAL;
-
-	spin_lock_init(&ctx->req_lock);
-	ctx->qp = qp;
-	ctx->dev = &qp->qm->pdev->dev;
-
-	hpre = container_of(ctx->qp->qm, struct hpre, qm);
-	ctx->hpre = hpre;
-	ctx->req_list = kcalloc(qlen, sizeof(void *), GFP_KERNEL);
-	if (!ctx->req_list)
-		return -ENOMEM;
-	ctx->key_sz = 0;
-	ctx->crt_g2_mode = false;
-	idr_init(&ctx->req_idr);
-
-	return 0;
-}
-
 static void hpre_ctx_clear(struct hpre_ctx *ctx, bool is_clear_all)
 {
 	if (is_clear_all) {
-		idr_destroy(&ctx->req_idr);
-		kfree(ctx->req_list);
 		hisi_qm_free_qps(&ctx->qp, 1);
 	}
 
@@ -467,29 +387,22 @@ static void hpre_rsa_cb(struct hpre_ctx *ctx, void *resp)
 
 static void hpre_alg_cb(struct hisi_qp *qp, void *resp)
 {
-	struct hpre_ctx *ctx = qp->qp_ctx;
-	struct hpre_dfx *dfx = ctx->hpre->debug.dfx;
+	struct hpre_asym_request *h_req;
 	struct hpre_sqe *sqe = resp;
-	struct hpre_asym_request *req = ctx->req_list[le16_to_cpu(sqe->tag)];
 
-	if (unlikely(!req)) {
-		atomic64_inc(&dfx[HPRE_INVALID_REQ_CNT].value);
+	h_req = (struct hpre_asym_request *)le64_to_cpu(sqe->tag);
+	if (unlikely(!h_req)) {
+		pr_err("Failed to get request, and qp_id is %u\n", qp->qp_id);
 		return;
 	}
 
-	req->cb(ctx, resp);
-}
-
-static void hpre_stop_qp_and_put(struct hisi_qp *qp)
-{
-	hisi_qm_stop_qp(qp);
-	hisi_qm_free_qps(&qp, 1);
+	h_req->cb(h_req->ctx, resp);
 }
 
 static int hpre_ctx_init(struct hpre_ctx *ctx, u8 type)
 {
 	struct hisi_qp *qp;
-	int ret;
+	struct hpre *hpre;
 
 	qp = hpre_get_qp_and_start(type);
 	if (IS_ERR(qp))
@@ -497,19 +410,21 @@ static int hpre_ctx_init(struct hpre_ctx *ctx, u8 type)
 
 	qp->qp_ctx = ctx;
 	qp->req_cb = hpre_alg_cb;
+	spin_lock_init(&ctx->req_lock);
+	ctx->qp = qp;
+	ctx->dev = &qp->qm->pdev->dev;
+	hpre = container_of(ctx->qp->qm, struct hpre, qm);
+	ctx->hpre = hpre;
+	ctx->key_sz = 0;
+	ctx->crt_g2_mode = false;
 
-	ret = hpre_ctx_set(ctx, qp, qp->sq_depth);
-	if (ret)
-		hpre_stop_qp_and_put(qp);
-
-	return ret;
+	return 0;
 }
 
 static int hpre_msg_request_set(struct hpre_ctx *ctx, void *req, bool is_rsa)
 {
 	struct hpre_asym_request *h_req;
 	struct hpre_sqe *msg;
-	int req_id;
 	void *tmp;
 
 	if (is_rsa) {
@@ -549,11 +464,8 @@ static int hpre_msg_request_set(struct hpre_ctx *ctx, void *req, bool is_rsa)
 	msg->task_len1 = (ctx->key_sz >> HPRE_BITS_2_BYTES_SHIFT) - 1;
 	h_req->ctx = ctx;
 
-	req_id = hpre_add_req_to_ctx(h_req);
-	if (req_id < 0)
-		return -EBUSY;
-
-	msg->tag = cpu_to_le16((u16)req_id);
+	hpre_dfx_add_req_time(h_req);
+	msg->tag = cpu_to_le64((uintptr_t)h_req);
 
 	return 0;
 }
@@ -619,7 +531,6 @@ static int hpre_dh_compute_value(struct kpp_request *req)
 		return -EINPROGRESS;
 
 clear_all:
-	hpre_rm_req_from_ctx(hpre_req);
 	hpre_hw_data_clr_all(ctx, hpre_req, req->dst, req->src);
 
 	return ret;
@@ -828,7 +739,6 @@ static int hpre_rsa_enc(struct akcipher_request *req)
 		return -EINPROGRESS;
 
 clear_all:
-	hpre_rm_req_from_ctx(hpre_req);
 	hpre_hw_data_clr_all(ctx, hpre_req, req->dst, req->src);
 
 	return ret;
@@ -883,7 +793,6 @@ static int hpre_rsa_dec(struct akcipher_request *req)
 		return -EINPROGRESS;
 
 clear_all:
-	hpre_rm_req_from_ctx(hpre_req);
 	hpre_hw_data_clr_all(ctx, hpre_req, req->dst, req->src);
 
 	return ret;
@@ -1346,7 +1255,7 @@ static int hpre_ecdh_set_param(struct hpre_ctx *ctx, struct ecdh *params)
 	return 0;
 }
 
-static bool hpre_key_is_zero(char *key, unsigned short key_sz)
+static bool hpre_key_is_zero(const char *key, unsigned short key_sz)
 {
 	int i;
 
@@ -1488,7 +1397,6 @@ static int hpre_ecdh_msg_request_set(struct hpre_ctx *ctx,
 {
 	struct hpre_asym_request *h_req;
 	struct hpre_sqe *msg;
-	int req_id;
 	void *tmp;
 
 	if (req->dst_len < ctx->key_sz << 1) {
@@ -1510,11 +1418,8 @@ static int hpre_ecdh_msg_request_set(struct hpre_ctx *ctx,
 	msg->task_len1 = (ctx->key_sz >> HPRE_BITS_2_BYTES_SHIFT) - 1;
 	h_req->ctx = ctx;
 
-	req_id = hpre_add_req_to_ctx(h_req);
-	if (req_id < 0)
-		return -EBUSY;
-
-	msg->tag = cpu_to_le16((u16)req_id);
+	hpre_dfx_add_req_time(h_req);
+	msg->tag = cpu_to_le64((uintptr_t)h_req);
 	return 0;
 }
 
@@ -1612,7 +1517,6 @@ static int hpre_ecdh_compute_value(struct kpp_request *req)
 		return -EINPROGRESS;
 
 clear_all:
-	hpre_rm_req_from_ctx(hpre_req);
 	hpre_ecdh_hw_data_clr_all(ctx, hpre_req, req->dst, req->src);
 	return ret;
 }
-- 
2.33.0

