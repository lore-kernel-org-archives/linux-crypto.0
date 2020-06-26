Return-Path: <SRS0=PFiu=AH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BD45C433DF
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jun 2020 10:32:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D72F2076E
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jun 2020 10:32:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727799AbgFZKcv (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 26 Jun 2020 06:32:51 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:6833 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727932AbgFZKcu (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Jun 2020 06:32:50 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 9C0B67A6A4A48521D8AC
        for <linux-crypto@vger.kernel.org>; Fri, 26 Jun 2020 18:32:43 +0800 (CST)
Received: from huawei.com (10.67.165.24) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.487.0; Fri, 26 Jun 2020
 18:32:39 +0800
From:   Longfang Liu <liulongfang@huawei.com>
To:     <herbert@gondor.apana.org.au>
CC:     <linux-crypto@vger.kernel.org>
Subject: [PATCH 2/5] crypto:hisilicon/sec2 - update busy processing logic
Date:   Fri, 26 Jun 2020 18:32:06 +0800
Message-ID: <1593167529-22463-3-git-send-email-liulongfang@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1593167529-22463-1-git-send-email-liulongfang@huawei.com>
References: <1593167529-22463-1-git-send-email-liulongfang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Kai Ye <yekai13@huawei.com>

As before, if a SEC queue is at the 'fake busy' status,
the request with a 'fake busy' flag will be sent into hardware
and the sending function returns busy. After the request is
finished, SEC driver's call back will identify the 'fake busy' flag,
and notifies the user that hardware is not busy now by calling
user's call back function.

Now, a request sent into busy hardware will be cached in the
SEC queue's backlog, return '-EBUSY' to user.
After the request being finished, the cached requests will
be processed in the call back function. to notify the
corresponding user that SEC queue can process more requests.

Signed-off-by: Kai Ye <yekai13@huawei.com>
Reviewed-by: Longfang Liu <liulongfang@huawei.com>
---
 drivers/crypto/hisilicon/sec2/sec.h        |  3 ++
 drivers/crypto/hisilicon/sec2/sec_crypto.c | 81 +++++++++++++++++++++---------
 drivers/crypto/hisilicon/sec2/sec_main.c   |  1 +
 3 files changed, 61 insertions(+), 24 deletions(-)

diff --git a/drivers/crypto/hisilicon/sec2/sec.h b/drivers/crypto/hisilicon/sec2/sec.h
index 7b64aca..ce91c4d 100644
--- a/drivers/crypto/hisilicon/sec2/sec.h
+++ b/drivers/crypto/hisilicon/sec2/sec.h
@@ -46,6 +46,7 @@ struct sec_req {
 
 	struct sec_cipher_req c_req;
 	struct sec_aead_req aead_req;
+	struct list_head backlog_head;
 
 	int err_type;
 	int req_id;
@@ -104,6 +105,7 @@ struct sec_qp_ctx {
 	struct sec_alg_res res[QM_Q_DEPTH];
 	struct sec_ctx *ctx;
 	struct mutex req_lock;
+	struct list_head backlog;
 	struct hisi_acc_sgl_pool *c_in_pool;
 	struct hisi_acc_sgl_pool *c_out_pool;
 	atomic_t pending_reqs;
@@ -161,6 +163,7 @@ struct sec_dfx {
 	atomic64_t send_cnt;
 	atomic64_t recv_cnt;
 	atomic64_t send_busy_cnt;
+	atomic64_t recv_busy_cnt;
 	atomic64_t err_bd_cnt;
 	atomic64_t invalid_req_cnt;
 	atomic64_t done_flag_cnt;
diff --git a/drivers/crypto/hisilicon/sec2/sec_crypto.c b/drivers/crypto/hisilicon/sec2/sec_crypto.c
index 64614a9..85fcb4d 100644
--- a/drivers/crypto/hisilicon/sec2/sec_crypto.c
+++ b/drivers/crypto/hisilicon/sec2/sec_crypto.c
@@ -166,6 +166,7 @@ static void sec_req_cb(struct hisi_qp *qp, void *resp)
 	req = qp_ctx->req_list[le16_to_cpu(bd->type2.tag)];
 	if (unlikely(!req)) {
 		atomic64_inc(&dfx->invalid_req_cnt);
+		atomic_inc(&qp->qp_status.used);
 		return;
 	}
 	req->err_type = bd->type2.error_type;
@@ -200,19 +201,23 @@ static int sec_bd_send(struct sec_ctx *ctx, struct sec_req *req)
 
 	mutex_lock(&qp_ctx->req_lock);
 	ret = hisi_qp_send(qp_ctx->qp, &req->sec_sqe);
+
+	if (ctx->fake_req_limit <=
+	    atomic_read(&qp_ctx->qp->qp_status.used) && !ret) {
+		list_add_tail(&req->backlog_head, &qp_ctx->backlog);
+		atomic64_inc(&ctx->sec->debug.dfx.send_cnt);
+		atomic64_inc(&ctx->sec->debug.dfx.send_busy_cnt);
+		mutex_unlock(&qp_ctx->req_lock);
+		return -EBUSY;
+	}
 	mutex_unlock(&qp_ctx->req_lock);
-	atomic64_inc(&ctx->sec->debug.dfx.send_cnt);
 
 	if (unlikely(ret == -EBUSY))
 		return -ENOBUFS;
 
-	if (!ret) {
-		if (req->fake_busy) {
-			atomic64_inc(&ctx->sec->debug.dfx.send_busy_cnt);
-			ret = -EBUSY;
-		} else {
-			ret = -EINPROGRESS;
-		}
+	if (likely(!ret)) {
+		ret = -EINPROGRESS;
+		atomic64_inc(&ctx->sec->debug.dfx.send_cnt);
 	}
 
 	return ret;
@@ -373,8 +378,8 @@ static int sec_create_qp_ctx(struct hisi_qm *qm, struct sec_ctx *ctx,
 	qp_ctx->ctx = ctx;
 
 	mutex_init(&qp_ctx->req_lock);
-	atomic_set(&qp_ctx->pending_reqs, 0);
 	idr_init(&qp_ctx->req_idr);
+	INIT_LIST_HEAD(&qp_ctx->backlog);
 
 	qp_ctx->c_in_pool = hisi_acc_create_sgl_pool(dev, QM_Q_DEPTH,
 						     SEC_SGL_SGE_NR);
@@ -1048,21 +1053,49 @@ static void sec_update_iv(struct sec_req *req, enum sec_alg_type alg_type)
 		dev_err(SEC_CTX_DEV(req->ctx), "copy output iv error!\n");
 }
 
+static struct sec_req *sec_back_req_clear(struct sec_ctx *ctx,
+				struct sec_qp_ctx *qp_ctx)
+{
+	struct sec_req *backlog_req = NULL;
+
+	mutex_lock(&qp_ctx->req_lock);
+	if (ctx->fake_req_limit >=
+	    atomic_read(&qp_ctx->qp->qp_status.used) &&
+	    !list_empty(&qp_ctx->backlog)) {
+		backlog_req = list_first_entry(&qp_ctx->backlog,
+				typeof(*backlog_req), backlog_head);
+		list_del(&backlog_req->backlog_head);
+	}
+	mutex_unlock(&qp_ctx->req_lock);
+
+	return backlog_req;
+}
+
 static void sec_skcipher_callback(struct sec_ctx *ctx, struct sec_req *req,
 				  int err)
 {
 	struct skcipher_request *sk_req = req->c_req.sk_req;
 	struct sec_qp_ctx *qp_ctx = req->qp_ctx;
+	struct skcipher_request *backlog_sk_req;
+	struct sec_req *backlog_req;
 
-	atomic_dec(&qp_ctx->pending_reqs);
 	sec_free_req_id(req);
 
 	/* IV output at encrypto of CBC mode */
 	if (!err && ctx->c_ctx.c_mode == SEC_CMODE_CBC && req->c_req.encrypt)
 		sec_update_iv(req, SEC_SKCIPHER);
 
-	if (req->fake_busy)
-		sk_req->base.complete(&sk_req->base, -EINPROGRESS);
+	while (1) {
+		backlog_req = sec_back_req_clear(ctx, qp_ctx);
+		if (!backlog_req)
+			break;
+
+		backlog_sk_req = backlog_req->c_req.sk_req;
+		backlog_sk_req->base.complete(&backlog_sk_req->base,
+						-EINPROGRESS);
+		atomic64_inc(&ctx->sec->debug.dfx.recv_busy_cnt);
+	}
+
 
 	sk_req->base.complete(&sk_req->base, err);
 }
@@ -1133,10 +1166,10 @@ static void sec_aead_callback(struct sec_ctx *c, struct sec_req *req, int err)
 	struct sec_cipher_req *c_req = &req->c_req;
 	size_t authsize = crypto_aead_authsize(tfm);
 	struct sec_qp_ctx *qp_ctx = req->qp_ctx;
+	struct aead_request *backlog_aead_req;
+	struct sec_req *backlog_req;
 	size_t sz;
 
-	atomic_dec(&qp_ctx->pending_reqs);
-
 	if (!err && c->c_ctx.c_mode == SEC_CMODE_CBC && c_req->encrypt)
 		sec_update_iv(req, SEC_AEAD);
 
@@ -1157,17 +1190,22 @@ static void sec_aead_callback(struct sec_ctx *c, struct sec_req *req, int err)
 
 	sec_free_req_id(req);
 
-	if (req->fake_busy)
-		a_req->base.complete(&a_req->base, -EINPROGRESS);
+	while (1) {
+		backlog_req = sec_back_req_clear(c, qp_ctx);
+		if (!backlog_req)
+			break;
+
+		backlog_aead_req = backlog_req->aead_req.aead_req;
+		backlog_aead_req->base.complete(&backlog_aead_req->base,
+						-EINPROGRESS);
+		atomic64_inc(&c->sec->debug.dfx.recv_busy_cnt);
+	}
 
 	a_req->base.complete(&a_req->base, err);
 }
 
 static void sec_request_uninit(struct sec_ctx *ctx, struct sec_req *req)
 {
-	struct sec_qp_ctx *qp_ctx = req->qp_ctx;
-
-	atomic_dec(&qp_ctx->pending_reqs);
 	sec_free_req_id(req);
 	sec_free_queue_id(ctx, req);
 }
@@ -1187,11 +1225,6 @@ static int sec_request_init(struct sec_ctx *ctx, struct sec_req *req)
 		return req->req_id;
 	}
 
-	if (ctx->fake_req_limit <= atomic_inc_return(&qp_ctx->pending_reqs))
-		req->fake_busy = true;
-	else
-		req->fake_busy = false;
-
 	return 0;
 }
 
diff --git a/drivers/crypto/hisilicon/sec2/sec_main.c b/drivers/crypto/hisilicon/sec2/sec_main.c
index c2567cc..f9c1b7d 100644
--- a/drivers/crypto/hisilicon/sec2/sec_main.c
+++ b/drivers/crypto/hisilicon/sec2/sec_main.c
@@ -122,6 +122,7 @@ static struct sec_dfx_item sec_dfx_labels[] = {
 	{"send_cnt", offsetof(struct sec_dfx, send_cnt)},
 	{"recv_cnt", offsetof(struct sec_dfx, recv_cnt)},
 	{"send_busy_cnt", offsetof(struct sec_dfx, send_busy_cnt)},
+	{"recv_busy_cnt", offsetof(struct sec_dfx, recv_busy_cnt)},
 	{"err_bd_cnt", offsetof(struct sec_dfx, err_bd_cnt)},
 	{"invalid_req_cnt", offsetof(struct sec_dfx, invalid_req_cnt)},
 	{"done_flag_cnt", offsetof(struct sec_dfx, done_flag_cnt)},
-- 
2.8.1

