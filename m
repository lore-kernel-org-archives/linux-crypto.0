Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66BF523B611;
	Thu, 10 Jul 2025 12:25:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752150305; cv=none; b=e+5dMZ6HHM7dh1Iiq8rg2eIDgj42L3r8ujF2rcEbXOrBi9uasareYVOESpiZS353IVSeLJ7X9B8sKBXeFdhr1q8NlUG5zhIIWc5c78Si7rq75txq5H9iXKRiQ+K8GrFkvQOoVQvKddRdHaqbtZKGHb697O9Ad0+t1VydOHmvvG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752150305; c=relaxed/simple;
	bh=PAC7V7yj3yhqif/2VKGAfzxzQAqORxdI80vLoRgP8/s=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=h7swMkk3+/TjIFmdOHD97u4qY8EkmBp+ZJHNcsYm+VYVDdmkV1YA1ImtOhenyUHh/go494/M7dfyb9shYViwcb42lXx9jAkOvGbxdU01rL60tFnxJ+OjKqaTdaf4Ix3RBuInqLZ3TMMR1uZAO+ZCl2jJaR4njuA7ew/G3uOsdEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4bdDWp3HF8z2FbNK;
	Thu, 10 Jul 2025 20:23:02 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id B9856140143;
	Thu, 10 Jul 2025 20:24:58 +0800 (CST)
Received: from kwepemq200001.china.huawei.com (7.202.195.16) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 10 Jul 2025 20:24:58 +0800
Received: from localhost.huawei.com (10.90.31.46) by
 kwepemq200001.china.huawei.com (7.202.195.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 10 Jul 2025 20:24:57 +0800
From: Chenghai Huang <huangchenghai2@huawei.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<liulongfang@huawei.com>, <qianweili@huawei.com>, <linwenkai6@hisilicon.com>,
	<wangzhou1@hisilicon.com>
Subject: [PATCH] crypto: hisilicon/sec2 - implement full backlog mode for sec
Date: Thu, 10 Jul 2025 20:24:57 +0800
Message-ID: <20250710122457.2295119-1-huangchenghai2@huawei.com>
X-Mailer: git-send-email 2.33.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemq200001.china.huawei.com (7.202.195.16)

From: Wenkai Lin <linwenkai6@hisilicon.com>

This patch introduces a hierarchical backlog mechanism to cache
user data in high-throughput encryption/decryption scenarios,
the implementation addresses packet loss issues when hardware
queues overflow during peak loads.

First, we use sec_alloc_req_id to obtain an exclusive resource
from the pre-allocated resource pool of each queue, if no resource
is allocated, perform the DMA map operation on the request memory.

When the task is ready, we will attempt to send it to the hardware,
if the hardware queue is already full, we cache the request into
the backlog list, then return an EBUSY status to the upper layer
and instruct the packet-sending thread to pause transmission.
Simultaneously, when the hardware completes a task, it triggers
the sec callback function, within this function, reattempt to send
the requests from the backlog list and wake up the sending thread
until the hardware queue becomes fully occupied again.

In addition, it handles such exceptions like the hardware is reset
when packets are sent, it will switch to the software computing
and release occupied resources.

Signed-off-by: Wenkai Lin <linwenkai6@hisilicon.com>
Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
---
 drivers/crypto/hisilicon/sec2/sec.h        |  63 ++-
 drivers/crypto/hisilicon/sec2/sec_crypto.c | 574 ++++++++++++++-------
 2 files changed, 457 insertions(+), 180 deletions(-)

diff --git a/drivers/crypto/hisilicon/sec2/sec.h b/drivers/crypto/hisilicon/sec2/sec.h
index 703920b49c7c..81d0beda93b2 100644
--- a/drivers/crypto/hisilicon/sec2/sec.h
+++ b/drivers/crypto/hisilicon/sec2/sec.h
@@ -7,6 +7,12 @@
 #include <linux/hisi_acc_qm.h>
 #include "sec_crypto.h"
 
+#define SEC_PBUF_SZ		512
+#define SEC_MAX_MAC_LEN		64
+#define SEC_IV_SIZE		24
+#define SEC_SGE_NR_NUM		4
+#define SEC_SGL_ALIGN_SIZE	64
+
 /* Algorithm resource per hardware SEC queue */
 struct sec_alg_res {
 	u8 *pbuf;
@@ -20,6 +26,40 @@ struct sec_alg_res {
 	u16 depth;
 };
 
+struct sec_hw_sge {
+	dma_addr_t buf;
+	void *page_ctrl;
+	__le32 len;
+	__le32 pad;
+	__le32 pad0;
+	__le32 pad1;
+};
+
+struct sec_hw_sgl {
+	dma_addr_t next_dma;
+	__le16 entry_sum_in_chain;
+	__le16 entry_sum_in_sgl;
+	__le16 entry_length_in_sgl;
+	__le16 pad0;
+	__le64 pad1[5];
+	struct sec_hw_sgl *next;
+	struct sec_hw_sge sge_entries[SEC_SGE_NR_NUM];
+} __aligned(SEC_SGL_ALIGN_SIZE);
+
+struct sec_src_dst_buf {
+	struct sec_hw_sgl in;
+	struct sec_hw_sgl out;
+};
+
+struct sec_request_buf {
+	union {
+		struct sec_src_dst_buf data_buf;
+		__u8 pbuf[SEC_PBUF_SZ];
+	};
+	dma_addr_t in_dma;
+	dma_addr_t out_dma;
+};
+
 /* Cipher request of SEC private */
 struct sec_cipher_req {
 	struct hisi_acc_hw_sgl *c_out;
@@ -29,6 +69,7 @@ struct sec_cipher_req {
 	struct skcipher_request *sk_req;
 	u32 c_len;
 	bool encrypt;
+	__u8 c_ivin_buf[SEC_IV_SIZE];
 };
 
 struct sec_aead_req {
@@ -37,6 +78,13 @@ struct sec_aead_req {
 	u8 *a_ivin;
 	dma_addr_t a_ivin_dma;
 	struct aead_request *aead_req;
+	__u8 a_ivin_buf[SEC_IV_SIZE];
+	__u8 out_mac_buf[SEC_MAX_MAC_LEN];
+};
+
+struct sec_instance_backlog {
+	struct list_head list;
+	spinlock_t lock;
 };
 
 /* SEC request of Crypto */
@@ -55,15 +103,17 @@ struct sec_req {
 	dma_addr_t in_dma;
 	struct sec_cipher_req c_req;
 	struct sec_aead_req aead_req;
-	struct list_head backlog_head;
+	struct crypto_async_request *base;
 
 	int err_type;
 	int req_id;
 	u32 flag;
 
-	/* Status of the SEC request */
-	bool fake_busy;
 	bool use_pbuf;
+
+	struct list_head list;
+	struct sec_instance_backlog *backlog;
+	struct sec_request_buf buf;
 };
 
 /**
@@ -119,9 +169,11 @@ struct sec_qp_ctx {
 	struct sec_alg_res *res;
 	struct sec_ctx *ctx;
 	spinlock_t req_lock;
-	struct list_head backlog;
+	spinlock_t id_lock;
 	struct hisi_acc_sgl_pool *c_in_pool;
 	struct hisi_acc_sgl_pool *c_out_pool;
+	struct sec_instance_backlog backlog;
+	u16 send_head;
 };
 
 enum sec_alg_type {
@@ -139,9 +191,6 @@ struct sec_ctx {
 	/* Half queues for encipher, and half for decipher */
 	u32 hlf_q_num;
 
-	/* Threshold for fake busy, trigger to return -EBUSY to user */
-	u32 fake_req_limit;
-
 	/* Current cyclic index to select a queue for encipher */
 	atomic_t enc_qcyclic;
 
diff --git a/drivers/crypto/hisilicon/sec2/sec_crypto.c b/drivers/crypto/hisilicon/sec2/sec_crypto.c
index 7d04e770a8c2..d044ded0f290 100644
--- a/drivers/crypto/hisilicon/sec2/sec_crypto.c
+++ b/drivers/crypto/hisilicon/sec2/sec_crypto.c
@@ -67,7 +67,6 @@
 #define SEC_MAX_CCM_AAD_LEN	65279
 #define SEC_TOTAL_MAC_SZ(depth) (SEC_MAX_MAC_LEN * (depth))
 
-#define SEC_PBUF_SZ			512
 #define SEC_PBUF_IV_OFFSET		SEC_PBUF_SZ
 #define SEC_PBUF_MAC_OFFSET		(SEC_PBUF_SZ + SEC_IV_SIZE)
 #define SEC_PBUF_PKG		(SEC_PBUF_SZ + SEC_IV_SIZE +	\
@@ -102,6 +101,8 @@
 #define IV_LAST_BYTE_MASK	0xFF
 #define IV_CTR_INIT		0x1
 #define IV_BYTE_OFFSET		0x8
+#define SEC_GCM_MIN_AUTH_SZ	0x8
+#define SEC_RETRY_MAX_CNT	5U
 
 static DEFINE_MUTEX(sec_algs_lock);
 static unsigned int sec_available_devs;
@@ -116,40 +117,19 @@ struct sec_aead {
 	struct aead_alg alg;
 };
 
-/* Get an en/de-cipher queue cyclically to balance load over queues of TFM */
-static inline u32 sec_alloc_queue_id(struct sec_ctx *ctx, struct sec_req *req)
-{
-	if (req->c_req.encrypt)
-		return (u32)atomic_inc_return(&ctx->enc_qcyclic) %
-				 ctx->hlf_q_num;
-
-	return (u32)atomic_inc_return(&ctx->dec_qcyclic) % ctx->hlf_q_num +
-				 ctx->hlf_q_num;
-}
-
-static inline void sec_free_queue_id(struct sec_ctx *ctx, struct sec_req *req)
-{
-	if (req->c_req.encrypt)
-		atomic_dec(&ctx->enc_qcyclic);
-	else
-		atomic_dec(&ctx->dec_qcyclic);
-}
+static int sec_aead_soft_crypto(struct sec_ctx *ctx,
+				struct aead_request *aead_req,
+				bool encrypt);
+static int sec_skcipher_soft_crypto(struct sec_ctx *ctx,
+				    struct skcipher_request *sreq, bool encrypt);
 
 static int sec_alloc_req_id(struct sec_req *req, struct sec_qp_ctx *qp_ctx)
 {
 	int req_id;
 
-	spin_lock_bh(&qp_ctx->req_lock);
+	spin_lock_bh(&qp_ctx->id_lock);
 	req_id = idr_alloc_cyclic(&qp_ctx->req_idr, NULL, 0, qp_ctx->qp->sq_depth, GFP_ATOMIC);
-	spin_unlock_bh(&qp_ctx->req_lock);
-	if (unlikely(req_id < 0)) {
-		dev_err(req->ctx->dev, "alloc req id fail!\n");
-		return req_id;
-	}
-
-	req->qp_ctx = qp_ctx;
-	qp_ctx->req_list[req_id] = req;
-
+	spin_unlock_bh(&qp_ctx->id_lock);
 	return req_id;
 }
 
@@ -163,12 +143,9 @@ static void sec_free_req_id(struct sec_req *req)
 		return;
 	}
 
-	qp_ctx->req_list[req_id] = NULL;
-	req->qp_ctx = NULL;
-
-	spin_lock_bh(&qp_ctx->req_lock);
+	spin_lock_bh(&qp_ctx->id_lock);
 	idr_remove(&qp_ctx->req_idr, req_id);
-	spin_unlock_bh(&qp_ctx->req_lock);
+	spin_unlock_bh(&qp_ctx->id_lock);
 }
 
 static u8 pre_parse_finished_bd(struct bd_status *status, void *resp)
@@ -229,6 +206,90 @@ static int sec_cb_status_check(struct sec_req *req,
 	return 0;
 }
 
+static int qp_send_message(struct sec_req *req)
+{
+	struct sec_qp_ctx *qp_ctx = req->qp_ctx;
+	int ret;
+
+	if (atomic_read(&qp_ctx->qp->qp_status.used) == qp_ctx->qp->sq_depth - 1)
+		return -EBUSY;
+
+	spin_lock_bh(&qp_ctx->req_lock);
+	if (atomic_read(&qp_ctx->qp->qp_status.used) == qp_ctx->qp->sq_depth - 1) {
+		spin_unlock_bh(&qp_ctx->req_lock);
+		return -EBUSY;
+	}
+
+	if (qp_ctx->ctx->type_supported == SEC_BD_TYPE2) {
+		req->sec_sqe.type2.tag = cpu_to_le16((u16)qp_ctx->send_head);
+		qp_ctx->req_list[qp_ctx->send_head] = req;
+	}
+
+	ret = hisi_qp_send(qp_ctx->qp, &req->sec_sqe);
+	if (ret) {
+		spin_unlock_bh(&qp_ctx->req_lock);
+		return ret;
+	}
+	if (qp_ctx->ctx->type_supported == SEC_BD_TYPE2)
+		qp_ctx->send_head = (qp_ctx->send_head + 1) % qp_ctx->qp->sq_depth;
+
+	spin_unlock_bh(&qp_ctx->req_lock);
+
+	atomic64_inc(&req->ctx->sec->debug.dfx.send_cnt);
+	return -EINPROGRESS;
+}
+
+static void sec_alg_send_backlog_soft(struct sec_ctx *ctx, struct sec_qp_ctx *qp_ctx)
+{
+	struct sec_req *req, *tmp;
+	int ret;
+
+	list_for_each_entry_safe(req, tmp, &qp_ctx->backlog.list, list) {
+		list_del(&req->list);
+		ctx->req_op->buf_unmap(ctx, req);
+		if (req->req_id >= 0)
+			sec_free_req_id(req);
+
+		if (ctx->alg_type == SEC_AEAD)
+			ret = sec_aead_soft_crypto(ctx, req->aead_req.aead_req,
+						   req->c_req.encrypt);
+		else
+			ret = sec_skcipher_soft_crypto(ctx, req->c_req.sk_req,
+						       req->c_req.encrypt);
+
+		/* Wake up the busy thread first, then return the errno. */
+		crypto_request_complete(req->base, -EINPROGRESS);
+		crypto_request_complete(req->base, ret);
+	}
+}
+
+static void sec_alg_send_backlog(struct sec_ctx *ctx, struct sec_qp_ctx *qp_ctx)
+{
+	struct sec_req *req, *tmp;
+	int ret;
+
+	spin_lock_bh(&qp_ctx->backlog.lock);
+	list_for_each_entry_safe(req, tmp, &qp_ctx->backlog.list, list) {
+		ret = qp_send_message(req);
+		switch (ret) {
+		case -EINPROGRESS:
+			list_del(&req->list);
+			crypto_request_complete(req->base, -EINPROGRESS);
+			break;
+		case -EBUSY:
+			/* Device is busy and stop send any request. */
+			goto unlock;
+		default:
+			/* Release memory resources and send all requests through software. */
+			sec_alg_send_backlog_soft(ctx, qp_ctx);
+			goto unlock;
+		}
+	}
+
+unlock:
+	spin_unlock_bh(&qp_ctx->backlog.lock);
+}
+
 static void sec_req_cb(struct hisi_qp *qp, void *resp)
 {
 	struct sec_qp_ctx *qp_ctx = qp->qp_ctx;
@@ -273,40 +334,54 @@ static void sec_req_cb(struct hisi_qp *qp, void *resp)
 	ctx->req_op->callback(ctx, req, err);
 }
 
-static int sec_bd_send(struct sec_ctx *ctx, struct sec_req *req)
+static int sec_alg_send_message_retry(struct sec_req *req)
 {
-	struct sec_qp_ctx *qp_ctx = req->qp_ctx;
+	int ctr = 0;
 	int ret;
 
-	if (ctx->fake_req_limit <=
-	    atomic_read(&qp_ctx->qp->qp_status.used) &&
-	    !(req->flag & CRYPTO_TFM_REQ_MAY_BACKLOG))
-		return -EBUSY;
+	do {
+		ret = qp_send_message(req);
+	} while (ret == -EBUSY && ctr++ < SEC_RETRY_MAX_CNT);
 
-	spin_lock_bh(&qp_ctx->req_lock);
-	ret = hisi_qp_send(qp_ctx->qp, &req->sec_sqe);
-	if (ctx->fake_req_limit <=
-	    atomic_read(&qp_ctx->qp->qp_status.used) && !ret) {
-		list_add_tail(&req->backlog_head, &qp_ctx->backlog);
-		atomic64_inc(&ctx->sec->debug.dfx.send_cnt);
-		atomic64_inc(&ctx->sec->debug.dfx.send_busy_cnt);
-		spin_unlock_bh(&qp_ctx->req_lock);
+	return ret;
+}
+
+static int sec_alg_try_enqueue(struct sec_req *req)
+{
+	/* Check if any request is already backlogged */
+	if (!list_empty(&req->backlog->list))
 		return -EBUSY;
-	}
-	spin_unlock_bh(&qp_ctx->req_lock);
 
-	if (unlikely(ret == -EBUSY))
-		return -ENOBUFS;
+	/* Try to enqueue to HW ring */
+	return qp_send_message(req);
+}
 
-	if (likely(!ret)) {
-		ret = -EINPROGRESS;
-		atomic64_inc(&ctx->sec->debug.dfx.send_cnt);
-	}
+
+static int sec_alg_send_message_maybacklog(struct sec_req *req)
+{
+	int ret;
+
+	ret = sec_alg_try_enqueue(req);
+	if (ret != -EBUSY)
+		return ret;
+
+	spin_lock_bh(&req->backlog->lock);
+	ret = sec_alg_try_enqueue(req);
+	if (ret == -EBUSY)
+		list_add_tail(&req->list, &req->backlog->list);
+	spin_unlock_bh(&req->backlog->lock);
 
 	return ret;
 }
 
-/* Get DMA memory resources */
+static int sec_bd_send(struct sec_ctx *ctx, struct sec_req *req)
+{
+	if (req->flag & CRYPTO_TFM_REQ_MAY_BACKLOG)
+		return sec_alg_send_message_maybacklog(req);
+
+	return sec_alg_send_message_retry(req);
+}
+
 static int sec_alloc_civ_resource(struct device *dev, struct sec_alg_res *res)
 {
 	u16 q_depth = res->depth;
@@ -558,7 +633,10 @@ static int sec_create_qp_ctx(struct sec_ctx *ctx, int qp_ctx_id)
 
 	spin_lock_init(&qp_ctx->req_lock);
 	idr_init(&qp_ctx->req_idr);
-	INIT_LIST_HEAD(&qp_ctx->backlog);
+	spin_lock_init(&qp_ctx->backlog.lock);
+	spin_lock_init(&qp_ctx->id_lock);
+	INIT_LIST_HEAD(&qp_ctx->backlog.list);
+	qp_ctx->send_head = 0;
 
 	ret = sec_alloc_qp_ctx_resource(ctx, qp_ctx);
 	if (ret)
@@ -602,9 +680,6 @@ static int sec_ctx_base_init(struct sec_ctx *ctx)
 	ctx->hlf_q_num = sec->ctx_q_num >> 1;
 
 	ctx->pbuf_supported = ctx->sec->iommu_used;
-
-	/* Half of queue depth is taken as fake requests limit in the queue. */
-	ctx->fake_req_limit = ctx->qps[0]->sq_depth >> 1;
 	ctx->qp_ctx = kcalloc(sec->ctx_q_num, sizeof(struct sec_qp_ctx),
 			      GFP_KERNEL);
 	if (!ctx->qp_ctx) {
@@ -706,7 +781,7 @@ static int sec_skcipher_init(struct crypto_skcipher *tfm)
 	int ret;
 
 	ctx->alg_type = SEC_SKCIPHER;
-	crypto_skcipher_set_reqsize(tfm, sizeof(struct sec_req));
+	crypto_skcipher_set_reqsize_dma(tfm, sizeof(struct sec_req));
 	ctx->c_ctx.ivsize = crypto_skcipher_ivsize(tfm);
 	if (ctx->c_ctx.ivsize > SEC_IV_SIZE) {
 		pr_err("get error skcipher iv size!\n");
@@ -883,24 +958,25 @@ GEN_SEC_SETKEY_FUNC(sm4_ctr, SEC_CALG_SM4, SEC_CMODE_CTR)
 static int sec_cipher_pbuf_map(struct sec_ctx *ctx, struct sec_req *req,
 			struct scatterlist *src)
 {
-	struct sec_aead_req *a_req = &req->aead_req;
-	struct aead_request *aead_req = a_req->aead_req;
+	struct aead_request *aead_req = req->aead_req.aead_req;
 	struct sec_cipher_req *c_req = &req->c_req;
 	struct sec_qp_ctx *qp_ctx = req->qp_ctx;
+	struct sec_request_buf *buf = &req->buf;
 	struct device *dev = ctx->dev;
 	int copy_size, pbuf_length;
 	int req_id = req->req_id;
 	struct crypto_aead *tfm;
+	u8 *mac_offset, *pbuf;
 	size_t authsize;
-	u8 *mac_offset;
 
 	if (ctx->alg_type == SEC_AEAD)
 		copy_size = aead_req->cryptlen + aead_req->assoclen;
 	else
 		copy_size = c_req->c_len;
 
-	pbuf_length = sg_copy_to_buffer(src, sg_nents(src),
-			qp_ctx->res[req_id].pbuf, copy_size);
+
+	pbuf = req->req_id < 0 ? buf->pbuf : qp_ctx->res[req_id].pbuf;
+	pbuf_length = sg_copy_to_buffer(src, sg_nents(src), pbuf, copy_size);
 	if (unlikely(pbuf_length != copy_size)) {
 		dev_err(dev, "copy src data to pbuf error!\n");
 		return -EINVAL;
@@ -908,8 +984,17 @@ static int sec_cipher_pbuf_map(struct sec_ctx *ctx, struct sec_req *req,
 	if (!c_req->encrypt && ctx->alg_type == SEC_AEAD) {
 		tfm = crypto_aead_reqtfm(aead_req);
 		authsize = crypto_aead_authsize(tfm);
-		mac_offset = qp_ctx->res[req_id].pbuf + copy_size - authsize;
-		memcpy(a_req->out_mac, mac_offset, authsize);
+		mac_offset = pbuf + copy_size - authsize;
+		memcpy(req->aead_req.out_mac, mac_offset, authsize);
+	}
+
+	if (req->req_id < 0) {
+		buf->in_dma = dma_map_single(dev, buf->pbuf, SEC_PBUF_SZ, DMA_BIDIRECTIONAL);
+		if (unlikely(dma_mapping_error(dev, buf->in_dma)))
+			return -ENOMEM;
+
+		buf->out_dma = buf->in_dma;
+		return 0;
 	}
 
 	req->in_dma = qp_ctx->res[req_id].pbuf_dma;
@@ -924,6 +1009,7 @@ static void sec_cipher_pbuf_unmap(struct sec_ctx *ctx, struct sec_req *req,
 	struct aead_request *aead_req = req->aead_req.aead_req;
 	struct sec_cipher_req *c_req = &req->c_req;
 	struct sec_qp_ctx *qp_ctx = req->qp_ctx;
+	struct sec_request_buf *buf = &req->buf;
 	int copy_size, pbuf_length;
 	int req_id = req->req_id;
 
@@ -932,10 +1018,16 @@ static void sec_cipher_pbuf_unmap(struct sec_ctx *ctx, struct sec_req *req,
 	else
 		copy_size = c_req->c_len;
 
-	pbuf_length = sg_copy_from_buffer(dst, sg_nents(dst),
-			qp_ctx->res[req_id].pbuf, copy_size);
+	if (req->req_id < 0)
+		pbuf_length = sg_copy_from_buffer(dst, sg_nents(dst), buf->pbuf, copy_size);
+	else
+		pbuf_length = sg_copy_from_buffer(dst, sg_nents(dst), qp_ctx->res[req_id].pbuf,
+						  copy_size);
 	if (unlikely(pbuf_length != copy_size))
 		dev_err(ctx->dev, "copy pbuf data to dst error!\n");
+
+	if (req->req_id < 0)
+		dma_unmap_single(ctx->dev, buf->in_dma, SEC_PBUF_SZ, DMA_BIDIRECTIONAL);
 }
 
 static int sec_aead_mac_init(struct sec_aead_req *req)
@@ -957,8 +1049,88 @@ static int sec_aead_mac_init(struct sec_aead_req *req)
 	return 0;
 }
 
-static int sec_cipher_map(struct sec_ctx *ctx, struct sec_req *req,
-			  struct scatterlist *src, struct scatterlist *dst)
+static void fill_sg_to_hw_sge(struct scatterlist *sgl, struct sec_hw_sge *hw_sge)
+{
+	hw_sge->buf = sg_dma_address(sgl);
+	hw_sge->len = cpu_to_le32(sg_dma_len(sgl));
+	hw_sge->page_ctrl = sg_virt(sgl);
+}
+
+static int sec_cipher_to_hw_sgl(struct device *dev, struct scatterlist *src,
+				struct sec_hw_sgl *src_in, dma_addr_t *hw_sgl_dma,
+				int dma_dir)
+{
+	struct sec_hw_sge *curr_hw_sge = src_in->sge_entries;
+	u32 i, sg_n, sg_n_mapped;
+	struct scatterlist *sg;
+	u32 sge_var = 0;
+
+	sg_n = sg_nents(src);
+	sg_n_mapped = dma_map_sg(dev, src, sg_n, dma_dir);
+	if (unlikely(!sg_n_mapped)) {
+		dev_err(dev, "dma mapping for SG error!\n");
+		return -EINVAL;
+	} else if (unlikely(sg_n_mapped > SEC_SGE_NR_NUM)) {
+		dev_err(dev, "the number of entries in input scatterlist error!\n");
+		dma_unmap_sg(dev, src, sg_n, dma_dir);
+		return -EINVAL;
+	}
+
+	for_each_sg(src, sg, sg_n_mapped, i) {
+		fill_sg_to_hw_sge(sg, curr_hw_sge);
+		curr_hw_sge++;
+		sge_var++;
+	}
+
+	src_in->entry_sum_in_sgl = cpu_to_le16(sge_var);
+	src_in->entry_sum_in_chain = cpu_to_le16(SEC_SGE_NR_NUM);
+	src_in->entry_length_in_sgl = cpu_to_le16(SEC_SGE_NR_NUM);
+	*hw_sgl_dma = dma_map_single(dev, src_in, sizeof(struct sec_hw_sgl), dma_dir);
+	if (unlikely(dma_mapping_error(dev, *hw_sgl_dma))) {
+		dma_unmap_sg(dev, src, sg_n, dma_dir);
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+static void sec_cipher_put_hw_sgl(struct device *dev, struct scatterlist *src,
+				  dma_addr_t src_in, int dma_dir)
+{
+	dma_unmap_single(dev, src_in, sizeof(struct sec_hw_sgl), dma_dir);
+	dma_unmap_sg(dev, src, sg_nents(src), dma_dir);
+}
+
+static int sec_cipher_map_sgl(struct device *dev, struct sec_req *req,
+			      struct scatterlist *src, struct scatterlist *dst)
+{
+	struct sec_hw_sgl *src_in = &req->buf.data_buf.in;
+	struct sec_hw_sgl *dst_out = &req->buf.data_buf.out;
+	int ret;
+
+	if (dst == src) {
+		ret = sec_cipher_to_hw_sgl(dev, src, src_in, &req->buf.in_dma,
+					    DMA_BIDIRECTIONAL);
+		req->buf.out_dma = req->buf.in_dma;
+		return ret;
+	}
+
+	ret = sec_cipher_to_hw_sgl(dev, src, src_in, &req->buf.in_dma, DMA_TO_DEVICE);
+	if (unlikely(ret))
+		return ret;
+
+	ret = sec_cipher_to_hw_sgl(dev, dst, dst_out, &req->buf.out_dma,
+				   DMA_FROM_DEVICE);
+	if (unlikely(ret)) {
+		sec_cipher_put_hw_sgl(dev, src, req->buf.in_dma, DMA_TO_DEVICE);
+		return ret;
+	}
+
+	return 0;
+}
+
+static int sec_cipher_map_inner(struct sec_ctx *ctx, struct sec_req *req,
+				struct scatterlist *src, struct scatterlist *dst)
 {
 	struct sec_cipher_req *c_req = &req->c_req;
 	struct sec_aead_req *a_req = &req->aead_req;
@@ -978,10 +1150,9 @@ static int sec_cipher_map(struct sec_ctx *ctx, struct sec_req *req,
 			a_req->out_mac_dma = res->pbuf_dma +
 					SEC_PBUF_MAC_OFFSET;
 		}
-		ret = sec_cipher_pbuf_map(ctx, req, src);
-
-		return ret;
+		return sec_cipher_pbuf_map(ctx, req, src);
 	}
+
 	c_req->c_ivin = res->c_ivin;
 	c_req->c_ivin_dma = res->c_ivin_dma;
 	if (ctx->alg_type == SEC_AEAD) {
@@ -1030,22 +1201,109 @@ static int sec_cipher_map(struct sec_ctx *ctx, struct sec_req *req,
 	return 0;
 }
 
+static int sec_cipher_map(struct sec_ctx *ctx, struct sec_req *req,
+			  struct scatterlist *src, struct scatterlist *dst)
+{
+	struct sec_aead_req *a_req = &req->aead_req;
+	struct sec_cipher_req *c_req = &req->c_req;
+	bool is_aead = (ctx->alg_type == SEC_AEAD);
+	struct device *dev = ctx->dev;
+	int ret = -ENOMEM;
+
+	if (req->req_id >= 0)
+		return sec_cipher_map_inner(ctx, req, src, dst);
+
+	c_req->c_ivin = c_req->c_ivin_buf;
+	c_req->c_ivin_dma = dma_map_single(dev, c_req->c_ivin,
+					   SEC_IV_SIZE, DMA_TO_DEVICE);
+	if (unlikely(dma_mapping_error(dev, c_req->c_ivin_dma)))
+		return -ENOMEM;
+
+	if (is_aead) {
+		a_req->a_ivin = a_req->a_ivin_buf;
+		a_req->out_mac = a_req->out_mac_buf;
+		a_req->a_ivin_dma = dma_map_single(dev, a_req->a_ivin,
+						   SEC_IV_SIZE, DMA_TO_DEVICE);
+		if (unlikely(dma_mapping_error(dev, a_req->a_ivin_dma)))
+			goto free_c_ivin_dma;
+
+		a_req->out_mac_dma = dma_map_single(dev, a_req->out_mac,
+						    SEC_MAX_MAC_LEN, DMA_BIDIRECTIONAL);
+		if (unlikely(dma_mapping_error(dev, a_req->out_mac_dma)))
+			goto free_a_ivin_dma;
+	}
+	if (req->use_pbuf) {
+		ret = sec_cipher_pbuf_map(ctx, req, src);
+		if (unlikely(ret))
+			goto free_out_mac_dma;
+
+		return 0;
+	}
+
+	if (!c_req->encrypt && is_aead) {
+		ret = sec_aead_mac_init(a_req);
+		if (unlikely(ret)) {
+			dev_err(dev, "fail to init mac data for ICV!\n");
+			goto free_out_mac_dma;
+		}
+	}
+
+	ret = sec_cipher_map_sgl(dev, req, src, dst);
+	if (unlikely(ret)) {
+		dev_err(dev, "fail to dma map input sgl buffers!\n");
+		goto free_out_mac_dma;
+	}
+
+	return 0;
+
+free_out_mac_dma:
+	if (is_aead)
+		dma_unmap_single(dev, a_req->out_mac_dma, SEC_MAX_MAC_LEN, DMA_BIDIRECTIONAL);
+free_a_ivin_dma:
+	if (is_aead)
+		dma_unmap_single(dev, a_req->a_ivin_dma, SEC_IV_SIZE, DMA_TO_DEVICE);
+free_c_ivin_dma:
+	dma_unmap_single(dev, c_req->c_ivin_dma, SEC_IV_SIZE, DMA_TO_DEVICE);
+	return ret;
+}
+
 static void sec_cipher_unmap(struct sec_ctx *ctx, struct sec_req *req,
 			     struct scatterlist *src, struct scatterlist *dst)
 {
+	struct sec_aead_req *a_req = &req->aead_req;
 	struct sec_cipher_req *c_req = &req->c_req;
 	struct device *dev = ctx->dev;
 
+	if (req->req_id >= 0) {
+		if (req->use_pbuf) {
+			sec_cipher_pbuf_unmap(ctx, req, dst);
+		} else {
+			if (dst != src) {
+				hisi_acc_sg_buf_unmap(dev, dst, c_req->c_out, DMA_FROM_DEVICE);
+				hisi_acc_sg_buf_unmap(dev, src, req->in, DMA_TO_DEVICE);
+			} else {
+				hisi_acc_sg_buf_unmap(dev, src, req->in, DMA_BIDIRECTIONAL);
+			}
+		}
+		return;
+	}
+
 	if (req->use_pbuf) {
 		sec_cipher_pbuf_unmap(ctx, req, dst);
 	} else {
 		if (dst != src) {
-			hisi_acc_sg_buf_unmap(dev, dst, c_req->c_out, DMA_FROM_DEVICE);
-			hisi_acc_sg_buf_unmap(dev, src, req->in, DMA_TO_DEVICE);
+			sec_cipher_put_hw_sgl(dev, dst, req->buf.out_dma, DMA_FROM_DEVICE);
+			sec_cipher_put_hw_sgl(dev, src, req->buf.in_dma, DMA_TO_DEVICE);
 		} else {
-			hisi_acc_sg_buf_unmap(dev, src, req->in, DMA_BIDIRECTIONAL);
+			sec_cipher_put_hw_sgl(dev, src, req->buf.in_dma, DMA_BIDIRECTIONAL);
 		}
 	}
+
+	dma_unmap_single(dev, c_req->c_ivin_dma, SEC_IV_SIZE, DMA_TO_DEVICE);
+	if (ctx->alg_type == SEC_AEAD) {
+		dma_unmap_single(dev, a_req->a_ivin_dma, SEC_IV_SIZE, DMA_TO_DEVICE);
+		dma_unmap_single(dev, a_req->out_mac_dma, SEC_MAX_MAC_LEN, DMA_BIDIRECTIONAL);
+	}
 }
 
 static int sec_skcipher_sgl_map(struct sec_ctx *ctx, struct sec_req *req)
@@ -1262,8 +1520,15 @@ static int sec_skcipher_bd_fill(struct sec_ctx *ctx, struct sec_req *req)
 
 	sec_sqe->type2.c_key_addr = cpu_to_le64(c_ctx->c_key_dma);
 	sec_sqe->type2.c_ivin_addr = cpu_to_le64(c_req->c_ivin_dma);
-	sec_sqe->type2.data_src_addr = cpu_to_le64(req->in_dma);
-	sec_sqe->type2.data_dst_addr = cpu_to_le64(c_req->c_out_dma);
+	if (req->req_id < 0) {
+		sec_sqe->type2.data_src_addr = cpu_to_le64(req->buf.in_dma);
+		sec_sqe->type2.data_dst_addr = cpu_to_le64(req->buf.out_dma);
+	} else {
+		sec_sqe->type2.data_src_addr = cpu_to_le64(req->in_dma);
+		sec_sqe->type2.data_dst_addr = cpu_to_le64(c_req->c_out_dma);
+	}
+	if (sec_sqe->type2.data_src_addr != sec_sqe->type2.data_dst_addr)
+		de = 0x1 << SEC_DE_OFFSET;
 
 	sec_sqe->type2.icvw_kmode |= cpu_to_le16(((u16)c_ctx->c_mode) <<
 						SEC_CMODE_OFFSET);
@@ -1289,13 +1554,10 @@ static int sec_skcipher_bd_fill(struct sec_ctx *ctx, struct sec_req *req)
 
 	sec_sqe->sdm_addr_type |= da_type;
 	scene = SEC_COMM_SCENE << SEC_SCENE_OFFSET;
-	if (req->in_dma != c_req->c_out_dma)
-		de = 0x1 << SEC_DE_OFFSET;
 
 	sec_sqe->sds_sa_type = (de | scene | sa_type);
 
 	sec_sqe->type2.clen_ivhlen |= cpu_to_le32(c_req->c_len);
-	sec_sqe->type2.tag = cpu_to_le16((u16)req->req_id);
 
 	return 0;
 }
@@ -1312,8 +1574,15 @@ static int sec_skcipher_bd_fill_v3(struct sec_ctx *ctx, struct sec_req *req)
 
 	sec_sqe3->c_key_addr = cpu_to_le64(c_ctx->c_key_dma);
 	sec_sqe3->no_scene.c_ivin_addr = cpu_to_le64(c_req->c_ivin_dma);
-	sec_sqe3->data_src_addr = cpu_to_le64(req->in_dma);
-	sec_sqe3->data_dst_addr = cpu_to_le64(c_req->c_out_dma);
+	if (req->req_id < 0) {
+		sec_sqe3->data_src_addr = cpu_to_le64(req->buf.in_dma);
+		sec_sqe3->data_dst_addr = cpu_to_le64(req->buf.out_dma);
+	} else {
+		sec_sqe3->data_src_addr = cpu_to_le64(req->in_dma);
+		sec_sqe3->data_dst_addr = cpu_to_le64(c_req->c_out_dma);
+	}
+	if (sec_sqe3->data_src_addr != sec_sqe3->data_dst_addr)
+		bd_param |= 0x1 << SEC_DE_OFFSET_V3;
 
 	sec_sqe3->c_mode_alg = ((u8)c_ctx->c_alg << SEC_CALG_OFFSET_V3) |
 						c_ctx->c_mode;
@@ -1339,8 +1608,6 @@ static int sec_skcipher_bd_fill_v3(struct sec_ctx *ctx, struct sec_req *req)
 	}
 
 	bd_param |= SEC_COMM_SCENE << SEC_SCENE_OFFSET_V3;
-	if (req->in_dma != c_req->c_out_dma)
-		bd_param |= 0x1 << SEC_DE_OFFSET_V3;
 
 	bd_param |= SEC_BD_TYPE3;
 	sec_sqe3->bd_param = cpu_to_le32(bd_param);
@@ -1372,15 +1639,12 @@ static void sec_update_iv(struct sec_req *req, enum sec_alg_type alg_type)
 	size_t sz;
 	u8 *iv;
 
-	if (req->c_req.encrypt)
-		sgl = alg_type == SEC_SKCIPHER ? sk_req->dst : aead_req->dst;
-	else
-		sgl = alg_type == SEC_SKCIPHER ? sk_req->src : aead_req->src;
-
 	if (alg_type == SEC_SKCIPHER) {
+		sgl = req->c_req.encrypt ? sk_req->dst : sk_req->src;
 		iv = sk_req->iv;
 		cryptlen = sk_req->cryptlen;
 	} else {
+		sgl = req->c_req.encrypt ? aead_req->dst : aead_req->src;
 		iv = aead_req->iv;
 		cryptlen = aead_req->cryptlen;
 	}
@@ -1391,57 +1655,26 @@ static void sec_update_iv(struct sec_req *req, enum sec_alg_type alg_type)
 		if (unlikely(sz != iv_size))
 			dev_err(req->ctx->dev, "copy output iv error!\n");
 	} else {
-		sz = cryptlen / iv_size;
-		if (cryptlen % iv_size)
-			sz += 1;
+		sz = (cryptlen + iv_size - 1) / iv_size;
 		ctr_iv_inc(iv, iv_size, sz);
 	}
 }
 
-static struct sec_req *sec_back_req_clear(struct sec_ctx *ctx,
-				struct sec_qp_ctx *qp_ctx)
-{
-	struct sec_req *backlog_req = NULL;
-
-	spin_lock_bh(&qp_ctx->req_lock);
-	if (ctx->fake_req_limit >=
-	    atomic_read(&qp_ctx->qp->qp_status.used) &&
-	    !list_empty(&qp_ctx->backlog)) {
-		backlog_req = list_first_entry(&qp_ctx->backlog,
-				typeof(*backlog_req), backlog_head);
-		list_del(&backlog_req->backlog_head);
-	}
-	spin_unlock_bh(&qp_ctx->req_lock);
-
-	return backlog_req;
-}
-
 static void sec_skcipher_callback(struct sec_ctx *ctx, struct sec_req *req,
 				  int err)
 {
-	struct skcipher_request *sk_req = req->c_req.sk_req;
 	struct sec_qp_ctx *qp_ctx = req->qp_ctx;
-	struct skcipher_request *backlog_sk_req;
-	struct sec_req *backlog_req;
 
-	sec_free_req_id(req);
+	if (req->req_id >= 0)
+		sec_free_req_id(req);
 
 	/* IV output at encrypto of CBC/CTR mode */
 	if (!err && (ctx->c_ctx.c_mode == SEC_CMODE_CBC ||
 	    ctx->c_ctx.c_mode == SEC_CMODE_CTR) && req->c_req.encrypt)
 		sec_update_iv(req, SEC_SKCIPHER);
 
-	while (1) {
-		backlog_req = sec_back_req_clear(ctx, qp_ctx);
-		if (!backlog_req)
-			break;
-
-		backlog_sk_req = backlog_req->c_req.sk_req;
-		skcipher_request_complete(backlog_sk_req, -EINPROGRESS);
-		atomic64_inc(&ctx->sec->debug.dfx.recv_busy_cnt);
-	}
-
-	skcipher_request_complete(sk_req, err);
+	crypto_request_complete(req->base, err);
+	sec_alg_send_backlog(ctx, qp_ctx);
 }
 
 static void set_aead_auth_iv(struct sec_ctx *ctx, struct sec_req *req)
@@ -1680,21 +1913,14 @@ static void sec_aead_callback(struct sec_ctx *c, struct sec_req *req, int err)
 	struct aead_request *a_req = req->aead_req.aead_req;
 	struct crypto_aead *tfm = crypto_aead_reqtfm(a_req);
 	size_t authsize = crypto_aead_authsize(tfm);
-	struct sec_aead_req *aead_req = &req->aead_req;
-	struct sec_cipher_req *c_req = &req->c_req;
 	struct sec_qp_ctx *qp_ctx = req->qp_ctx;
-	struct aead_request *backlog_aead_req;
-	struct sec_req *backlog_req;
 	size_t sz;
 
-	if (!err && c->c_ctx.c_mode == SEC_CMODE_CBC && c_req->encrypt)
-		sec_update_iv(req, SEC_AEAD);
-
-	/* Copy output mac */
-	if (!err && c_req->encrypt) {
-		struct scatterlist *sgl = a_req->dst;
+	if (!err && req->c_req.encrypt) {
+		if (c->c_ctx.c_mode == SEC_CMODE_CBC)
+			sec_update_iv(req, SEC_AEAD);
 
-		sz = sg_pcopy_from_buffer(sgl, sg_nents(sgl), aead_req->out_mac,
+		sz = sg_pcopy_from_buffer(a_req->dst, sg_nents(a_req->dst), req->aead_req.out_mac,
 					  authsize, a_req->cryptlen + a_req->assoclen);
 		if (unlikely(sz != authsize)) {
 			dev_err(c->dev, "copy out mac err!\n");
@@ -1702,48 +1928,39 @@ static void sec_aead_callback(struct sec_ctx *c, struct sec_req *req, int err)
 		}
 	}
 
-	sec_free_req_id(req);
+	if (req->req_id >= 0)
+		sec_free_req_id(req);
 
-	while (1) {
-		backlog_req = sec_back_req_clear(c, qp_ctx);
-		if (!backlog_req)
-			break;
-
-		backlog_aead_req = backlog_req->aead_req.aead_req;
-		aead_request_complete(backlog_aead_req, -EINPROGRESS);
-		atomic64_inc(&c->sec->debug.dfx.recv_busy_cnt);
-	}
-
-	aead_request_complete(a_req, err);
+	crypto_request_complete(req->base, err);
+	sec_alg_send_backlog(c, qp_ctx);
 }
 
-static void sec_request_uninit(struct sec_ctx *ctx, struct sec_req *req)
+static void sec_request_uninit(struct sec_req *req)
 {
-	sec_free_req_id(req);
-	sec_free_queue_id(ctx, req);
+	if (req->req_id >= 0)
+		sec_free_req_id(req);
 }
 
 static int sec_request_init(struct sec_ctx *ctx, struct sec_req *req)
 {
 	struct sec_qp_ctx *qp_ctx;
-	int queue_id;
-
-	/* To load balance */
-	queue_id = sec_alloc_queue_id(ctx, req);
-	qp_ctx = &ctx->qp_ctx[queue_id];
+	int i;
 
-	req->req_id = sec_alloc_req_id(req, qp_ctx);
-	if (unlikely(req->req_id < 0)) {
-		sec_free_queue_id(ctx, req);
-		return req->req_id;
+	for (i = 0; i < ctx->sec->ctx_q_num; i++) {
+		qp_ctx = &ctx->qp_ctx[i];
+		req->req_id = sec_alloc_req_id(req, qp_ctx);
+		if (req->req_id >= 0)
+			break;
 	}
 
+	req->qp_ctx = qp_ctx;
+	req->backlog = &qp_ctx->backlog;
+
 	return 0;
 }
 
 static int sec_process(struct sec_ctx *ctx, struct sec_req *req)
 {
-	struct sec_cipher_req *c_req = &req->c_req;
 	int ret;
 
 	ret = sec_request_init(ctx, req);
@@ -1760,8 +1977,7 @@ static int sec_process(struct sec_ctx *ctx, struct sec_req *req)
 		sec_update_iv(req, ctx->alg_type);
 
 	ret = ctx->req_op->bd_send(ctx, req);
-	if (unlikely((ret != -EBUSY && ret != -EINPROGRESS) ||
-		(ret == -EBUSY && !(req->flag & CRYPTO_TFM_REQ_MAY_BACKLOG)))) {
+	if (unlikely((ret != -EBUSY && ret != -EINPROGRESS))) {
 		dev_err_ratelimited(ctx->dev, "send sec request failed!\n");
 		goto err_send_req;
 	}
@@ -1772,16 +1988,23 @@ static int sec_process(struct sec_ctx *ctx, struct sec_req *req)
 	/* As failing, restore the IV from user */
 	if (ctx->c_ctx.c_mode == SEC_CMODE_CBC && !req->c_req.encrypt) {
 		if (ctx->alg_type == SEC_SKCIPHER)
-			memcpy(req->c_req.sk_req->iv, c_req->c_ivin,
+			memcpy(req->c_req.sk_req->iv, req->c_req.c_ivin,
 			       ctx->c_ctx.ivsize);
 		else
-			memcpy(req->aead_req.aead_req->iv, c_req->c_ivin,
+			memcpy(req->aead_req.aead_req->iv, req->c_req.c_ivin,
 			       ctx->c_ctx.ivsize);
 	}
 
 	sec_request_untransfer(ctx, req);
+
 err_uninit_req:
-	sec_request_uninit(ctx, req);
+	sec_request_uninit(req);
+	if (ctx->alg_type == SEC_AEAD)
+		ret = sec_aead_soft_crypto(ctx, req->aead_req.aead_req,
+					   req->c_req.encrypt);
+	else
+		ret = sec_skcipher_soft_crypto(ctx, req->c_req.sk_req,
+					       req->c_req.encrypt);
 	return ret;
 }
 
@@ -1855,7 +2078,7 @@ static int sec_aead_init(struct crypto_aead *tfm)
 	struct sec_ctx *ctx = crypto_aead_ctx(tfm);
 	int ret;
 
-	crypto_aead_set_reqsize(tfm, sizeof(struct sec_req));
+	crypto_aead_set_reqsize_dma(tfm, sizeof(struct sec_req));
 	ctx->alg_type = SEC_AEAD;
 	ctx->c_ctx.ivsize = crypto_aead_ivsize(tfm);
 	if (ctx->c_ctx.ivsize < SEC_AIV_SIZE ||
@@ -2092,7 +2315,7 @@ static int sec_skcipher_soft_crypto(struct sec_ctx *ctx,
 static int sec_skcipher_crypto(struct skcipher_request *sk_req, bool encrypt)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(sk_req);
-	struct sec_req *req = skcipher_request_ctx(sk_req);
+	struct sec_req *req = skcipher_request_ctx_dma(sk_req);
 	struct sec_ctx *ctx = crypto_skcipher_ctx(tfm);
 	bool need_fallback = false;
 	int ret;
@@ -2107,6 +2330,7 @@ static int sec_skcipher_crypto(struct skcipher_request *sk_req, bool encrypt)
 	req->c_req.sk_req = sk_req;
 	req->c_req.encrypt = encrypt;
 	req->ctx = ctx;
+	req->base = &sk_req->base;
 
 	ret = sec_skcipher_param_check(ctx, req, &need_fallback);
 	if (unlikely(ret))
@@ -2241,6 +2465,9 @@ static int sec_aead_spec_check(struct sec_ctx *ctx, struct sec_req *sreq)
 			return -EINVAL;
 		if (unlikely(ctx->a_ctx.a_key_len & WORD_MASK))
 			return -EINVAL;
+	} else if (c_mode == SEC_CMODE_GCM) {
+		if (unlikely(sz < SEC_GCM_MIN_AUTH_SZ))
+			return -EINVAL;
 	}
 
 	return 0;
@@ -2314,7 +2541,7 @@ static int sec_aead_soft_crypto(struct sec_ctx *ctx,
 static int sec_aead_crypto(struct aead_request *a_req, bool encrypt)
 {
 	struct crypto_aead *tfm = crypto_aead_reqtfm(a_req);
-	struct sec_req *req = aead_request_ctx(a_req);
+	struct sec_req *req = aead_request_ctx_dma(a_req);
 	struct sec_ctx *ctx = crypto_aead_ctx(tfm);
 	size_t sz = crypto_aead_authsize(tfm);
 	bool need_fallback = false;
@@ -2324,6 +2551,7 @@ static int sec_aead_crypto(struct aead_request *a_req, bool encrypt)
 	req->aead_req.aead_req = a_req;
 	req->c_req.encrypt = encrypt;
 	req->ctx = ctx;
+	req->base = &a_req->base;
 	req->c_req.c_len = a_req->cryptlen - (req->c_req.encrypt ? 0 : sz);
 
 	ret = sec_aead_param_check(ctx, req, &need_fallback);
-- 
2.33.0

