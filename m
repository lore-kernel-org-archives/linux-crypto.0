Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB1292DA771;
	Sat, 22 Nov 2025 07:49:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.216
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763797770; cv=none; b=h5Bg/zPi2wyHmNeLlrhxNABxuqcpFuotcIN2L0VEw9GULdkbLr+Fem6rqbA2HUPscgJJwO/0EEmUbSva1SStpcMuF7FXveqA/r8ibT3AXg0rVR5Z6QGc11CnaAOrMENZxa5TwSBmFqaneW9X0VhXB0Z99vS8euYb+SA/Fd3lCvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763797770; c=relaxed/simple;
	bh=gJ8erQE+7UFercg+aoPxAHJsyx438U7oaFkZ/uujdvk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YUB4DzGqTc8vvv2LSwFoUXt60PvzPLZX24gN9vfbgT5BVg07obO3xOW69NyvHqvi4uu1wfCFEK3rBDv++5n66k0EY2nRzGqa7v5Kif2Z7kovflQ38j5vjyW5kJ4My9jEjFgdrJ3V6z1LmrgEbZOBltqQmGgFdenlCs94Jd0QJU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=Opg585aq; arc=none smtp.client-ip=113.46.200.216
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="Opg585aq"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=L2DZEZZNjXARR9fq2af6gMmZk/w8TLtCp1W8YSaru8M=;
	b=Opg585aqdki2oUV6caKdZyIQM9s2yhyh001QdLpbx1gtrdmiIH852bQx9azqJeKRZYZZ5wVmY
	UPeB6lBDhicUW93VS8hzc+3XGQfjKRl8KEN/gZdDNY6L7YIQrfxnECFSVrS4tCMdxN0B7OzzW/m
	S0sLIbC+HkaKKXWsJJ1WFNA=
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4dD41q0Fz6z1T4Hl;
	Sat, 22 Nov 2025 15:47:43 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 29E74180479;
	Sat, 22 Nov 2025 15:49:20 +0800 (CST)
Received: from kwepemq200001.china.huawei.com (7.202.195.16) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 22 Nov 2025 15:49:19 +0800
Received: from localhost.huawei.com (10.90.31.46) by
 kwepemq200001.china.huawei.com (7.202.195.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 22 Nov 2025 15:49:19 +0800
From: Chenghai Huang <huangchenghai2@huawei.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<fanghao11@huawei.com>, <liulongfang@huawei.com>, <qianweili@huawei.com>,
	<linwenkai6@hisilicon.com>, <wangzhou1@hisilicon.com>, <lizhi206@huawei.com>,
	<taoqi10@huawei.com>
Subject: [PATCH v3 05/11] crypto: hisilicon/qm - centralize the sending locks of each module into qm
Date: Sat, 22 Nov 2025 15:49:10 +0800
Message-ID: <20251122074916.2793717-6-huangchenghai2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20251122074916.2793717-1-huangchenghai2@huawei.com>
References: <20251122074916.2793717-1-huangchenghai2@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemq200001.china.huawei.com (7.202.195.16)

When a single queue used by multiple tfms, the protection of shared
resources by individual module driver programs is no longer
sufficient. The hisi_qp_send needs to be ensured by the lock in qp.

Fixes: 5fdb4b345cfb ("crypto: hisilicon - add a lock for the qp send operation")
Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
Signed-off-by: Weili Qian <qianweili@huawei.com>
---
 drivers/crypto/hisilicon/hpre/hpre_crypto.c |  4 ----
 drivers/crypto/hisilicon/qm.c               | 16 ++++++++++++----
 drivers/crypto/hisilicon/zip/zip_crypto.c   |  3 ---
 include/linux/hisi_acc_qm.h                 |  1 +
 4 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/crypto/hisilicon/hpre/hpre_crypto.c b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
index 4197281c8dff..220022ae7afb 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_crypto.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
@@ -109,7 +109,6 @@ struct hpre_ctx {
 	struct hisi_qp *qp;
 	struct device *dev;
 	struct hpre *hpre;
-	spinlock_t req_lock;
 	unsigned int key_sz;
 	bool crt_g2_mode;
 	union {
@@ -410,7 +409,6 @@ static int hpre_ctx_init(struct hpre_ctx *ctx, u8 type)
 
 	qp->qp_ctx = ctx;
 	qp->req_cb = hpre_alg_cb;
-	spin_lock_init(&ctx->req_lock);
 	ctx->qp = qp;
 	ctx->dev = &qp->qm->pdev->dev;
 	hpre = container_of(ctx->qp->qm, struct hpre, qm);
@@ -478,9 +476,7 @@ static int hpre_send(struct hpre_ctx *ctx, struct hpre_sqe *msg)
 
 	do {
 		atomic64_inc(&dfx[HPRE_SEND_CNT].value);
-		spin_lock_bh(&ctx->req_lock);
 		ret = hisi_qp_send(ctx->qp, msg);
-		spin_unlock_bh(&ctx->req_lock);
 		if (ret != -EBUSY)
 			break;
 		atomic64_inc(&dfx[HPRE_SEND_BUSY_CNT].value);
diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index 50c32e69bd28..3965c8d0993c 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -2369,26 +2369,33 @@ EXPORT_SYMBOL_GPL(hisi_qm_stop_qp);
 int hisi_qp_send(struct hisi_qp *qp, const void *msg)
 {
 	struct hisi_qp_status *qp_status = &qp->qp_status;
-	u16 sq_tail = qp_status->sq_tail;
-	u16 sq_tail_next = (sq_tail + 1) % qp->sq_depth;
-	void *sqe = qm_get_avail_sqe(qp);
+	u16 sq_tail, sq_tail_next;
+	void *sqe;
 
+	spin_lock_bh(&qp->qp_lock);
 	if (unlikely(atomic_read(&qp->qp_status.flags) == QP_STOP ||
 		     atomic_read(&qp->qm->status.flags) == QM_STOP ||
 		     qp->is_resetting)) {
+		spin_unlock_bh(&qp->qp_lock);
 		dev_info_ratelimited(&qp->qm->pdev->dev, "QP is stopped or resetting\n");
 		return -EAGAIN;
 	}
 
-	if (!sqe)
+	sqe = qm_get_avail_sqe(qp);
+	if (!sqe) {
+		spin_unlock_bh(&qp->qp_lock);
 		return -EBUSY;
+	}
 
+	sq_tail = qp_status->sq_tail;
+	sq_tail_next = (sq_tail + 1) % qp->sq_depth;
 	memcpy(sqe, msg, qp->qm->sqe_size);
 	qp->msg[sq_tail] = msg;
 
 	qm_db(qp->qm, qp->qp_id, QM_DOORBELL_CMD_SQ, sq_tail_next, 0);
 	atomic_inc(&qp->qp_status.used);
 	qp_status->sq_tail = sq_tail_next;
+	spin_unlock_bh(&qp->qp_lock);
 
 	return 0;
 }
@@ -2968,6 +2975,7 @@ static int hisi_qp_memory_init(struct hisi_qm *qm, size_t dma_size, int id,
 	qp->qm = qm;
 	qp->qp_id = id;
 
+	spin_lock_init(&qp->qp_lock);
 	spin_lock_init(&qp->backlog.lock);
 	INIT_LIST_HEAD(&qp->backlog.list);
 
diff --git a/drivers/crypto/hisilicon/zip/zip_crypto.c b/drivers/crypto/hisilicon/zip/zip_crypto.c
index 8250a33ba586..2f9035c016f3 100644
--- a/drivers/crypto/hisilicon/zip/zip_crypto.c
+++ b/drivers/crypto/hisilicon/zip/zip_crypto.c
@@ -217,7 +217,6 @@ static int hisi_zip_do_work(struct hisi_zip_qp_ctx *qp_ctx,
 {
 	struct hisi_acc_sgl_pool *pool = qp_ctx->sgl_pool;
 	struct hisi_zip_dfx *dfx = &qp_ctx->zip_dev->dfx;
-	struct hisi_zip_req_q *req_q = &qp_ctx->req_q;
 	struct acomp_req *a_req = req->req;
 	struct hisi_qp *qp = qp_ctx->qp;
 	struct device *dev = &qp->qm->pdev->dev;
@@ -250,9 +249,7 @@ static int hisi_zip_do_work(struct hisi_zip_qp_ctx *qp_ctx,
 
 	/* send command to start a task */
 	atomic64_inc(&dfx->send_cnt);
-	spin_lock_bh(&req_q->req_lock);
 	ret = hisi_qp_send(qp, &zip_sqe);
-	spin_unlock_bh(&req_q->req_lock);
 	if (unlikely(ret < 0)) {
 		atomic64_inc(&dfx->send_busy_cnt);
 		ret = -EAGAIN;
diff --git a/include/linux/hisi_acc_qm.h b/include/linux/hisi_acc_qm.h
index 4f83f0700990..75ae01ddaa1a 100644
--- a/include/linux/hisi_acc_qm.h
+++ b/include/linux/hisi_acc_qm.h
@@ -473,6 +473,7 @@ struct hisi_qp {
 	u16 pasid;
 	struct uacce_queue *uacce_q;
 
+	spinlock_t qp_lock;
 	struct instance_backlog backlog;
 	const void **msg;
 };
-- 
2.33.0

