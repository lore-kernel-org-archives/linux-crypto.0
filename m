Return-Path: <SRS0=JhzL=27=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED91DC33CA2
	for <linux-crypto@archiver.kernel.org>; Fri, 10 Jan 2020 07:53:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CDE1D2077C
	for <linux-crypto@archiver.kernel.org>; Fri, 10 Jan 2020 07:53:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726549AbgAJHx5 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 10 Jan 2020 02:53:57 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:42548 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726583AbgAJHx4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 10 Jan 2020 02:53:56 -0500
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 30D72648F64E3696AD26;
        Fri, 10 Jan 2020 15:53:52 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.439.0; Fri, 10 Jan 2020 15:53:42 +0800
From:   Zaibo Xu <xuzaibo@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <linuxarm@huawei.com>,
        <jonathan.cameron@huawei.com>, <wangzhou1@hisilicon.com>,
        <tanghui20@huawei.com>, <yekai13@huawei.com>,
        <liulongfang@huawei.com>, <qianweili@huawei.com>,
        <zhangwei375@huawei.com>, <fanghao11@huawei.com>,
        <forest.zhouchang@huawei.com>
Subject: [PATCH 1/9] crypto: hisilicon - fix debugfs usage of SEC V2
Date:   Fri, 10 Jan 2020 15:49:50 +0800
Message-ID: <1578642598-8584-2-git-send-email-xuzaibo@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1578642598-8584-1-git-send-email-xuzaibo@huawei.com>
References: <1578642598-8584-1-git-send-email-xuzaibo@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Applied some advices of Marco Elver on atomic usage of Debugfs.

Reported-by: Marco Elver <elver@google.com>
Signed-off-by: Zaibo Xu <xuzaibo@huawei.com>
---
 drivers/crypto/hisilicon/sec2/sec.h        |  6 +++---
 drivers/crypto/hisilicon/sec2/sec_crypto.c | 10 +++++-----
 drivers/crypto/hisilicon/sec2/sec_main.c   | 14 ++++++++++++--
 3 files changed, 20 insertions(+), 10 deletions(-)

diff --git a/drivers/crypto/hisilicon/sec2/sec.h b/drivers/crypto/hisilicon/sec2/sec.h
index 26754d0..841f4c5 100644
--- a/drivers/crypto/hisilicon/sec2/sec.h
+++ b/drivers/crypto/hisilicon/sec2/sec.h
@@ -40,7 +40,7 @@ struct sec_req {
 	int req_id;
 
 	/* Status of the SEC request */
-	int fake_busy;
+	bool fake_busy;
 };
 
 /**
@@ -132,8 +132,8 @@ struct sec_debug_file {
 };
 
 struct sec_dfx {
-	u64 send_cnt;
-	u64 recv_cnt;
+	atomic64_t send_cnt;
+	atomic64_t recv_cnt;
 };
 
 struct sec_debug {
diff --git a/drivers/crypto/hisilicon/sec2/sec_crypto.c b/drivers/crypto/hisilicon/sec2/sec_crypto.c
index 62b04e1..2475aaf 100644
--- a/drivers/crypto/hisilicon/sec2/sec_crypto.c
+++ b/drivers/crypto/hisilicon/sec2/sec_crypto.c
@@ -120,7 +120,7 @@ static void sec_req_cb(struct hisi_qp *qp, void *resp)
 		return;
 	}
 
-	__sync_add_and_fetch(&req->ctx->sec->debug.dfx.recv_cnt, 1);
+	atomic64_inc(&req->ctx->sec->debug.dfx.recv_cnt);
 
 	req->ctx->req_op->buf_unmap(req->ctx, req);
 
@@ -135,7 +135,7 @@ static int sec_bd_send(struct sec_ctx *ctx, struct sec_req *req)
 	mutex_lock(&qp_ctx->req_lock);
 	ret = hisi_qp_send(qp_ctx->qp, &req->sec_sqe);
 	mutex_unlock(&qp_ctx->req_lock);
-	__sync_add_and_fetch(&ctx->sec->debug.dfx.send_cnt, 1);
+	atomic64_inc(&ctx->sec->debug.dfx.send_cnt);
 
 	if (ret == -EBUSY)
 		return -ENOBUFS;
@@ -641,7 +641,7 @@ static void sec_skcipher_callback(struct sec_ctx *ctx, struct sec_req *req)
 	if (ctx->c_ctx.c_mode == SEC_CMODE_CBC && req->c_req.encrypt)
 		sec_update_iv(req);
 
-	if (__sync_bool_compare_and_swap(&req->fake_busy, 1, 0))
+	if (req->fake_busy)
 		sk_req->base.complete(&sk_req->base, -EINPROGRESS);
 
 	sk_req->base.complete(&sk_req->base, req->err_type);
@@ -672,9 +672,9 @@ static int sec_request_init(struct sec_ctx *ctx, struct sec_req *req)
 	}
 
 	if (ctx->fake_req_limit <= atomic_inc_return(&qp_ctx->pending_reqs))
-		req->fake_busy = 1;
+		req->fake_busy = true;
 	else
-		req->fake_busy = 0;
+		req->fake_busy = false;
 
 	ret = ctx->req_op->get_res(ctx, req);
 	if (ret) {
diff --git a/drivers/crypto/hisilicon/sec2/sec_main.c b/drivers/crypto/hisilicon/sec2/sec_main.c
index 74f0654..d40e2da 100644
--- a/drivers/crypto/hisilicon/sec2/sec_main.c
+++ b/drivers/crypto/hisilicon/sec2/sec_main.c
@@ -608,6 +608,14 @@ static const struct file_operations sec_dbg_fops = {
 	.write = sec_debug_write,
 };
 
+static int sec_debugfs_atomic64_get(void *data, u64 *val)
+{
+	*val = atomic64_read((atomic64_t *)data);
+	return 0;
+}
+DEFINE_DEBUGFS_ATTRIBUTE(sec_atomic64_ops, sec_debugfs_atomic64_get,
+			 NULL, "%lld\n");
+
 static int sec_core_debug_init(struct sec_dev *sec)
 {
 	struct hisi_qm *qm = &sec->qm;
@@ -628,9 +636,11 @@ static int sec_core_debug_init(struct sec_dev *sec)
 
 	debugfs_create_regset32("regs", 0444, tmp_d, regset);
 
-	debugfs_create_u64("send_cnt", 0444, tmp_d, &dfx->send_cnt);
+	debugfs_create_file("send_cnt", 0444, tmp_d,
+			    &dfx->send_cnt, &sec_atomic64_ops);
 
-	debugfs_create_u64("recv_cnt", 0444, tmp_d, &dfx->recv_cnt);
+	debugfs_create_file("recv_cnt", 0444, tmp_d,
+			    &dfx->recv_cnt, &sec_atomic64_ops);
 
 	return 0;
 }
-- 
2.8.1

