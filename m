Return-Path: <SRS0=WlNz=3A=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82A9EC33CA2
	for <linux-crypto@archiver.kernel.org>; Sat, 11 Jan 2020 02:45:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4F82120721
	for <linux-crypto@archiver.kernel.org>; Sat, 11 Jan 2020 02:45:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728200AbgAKCpv (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 10 Jan 2020 21:45:51 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:45380 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728195AbgAKCpv (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 10 Jan 2020 21:45:51 -0500
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 56A80761319FBECDECC4;
        Sat, 11 Jan 2020 10:45:49 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.439.0; Sat, 11 Jan 2020 10:45:41 +0800
From:   Zaibo Xu <xuzaibo@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <linuxarm@huawei.com>,
        <jonathan.cameron@huawei.com>, <wangzhou1@hisilicon.com>,
        <tanghui20@huawei.com>, <yekai13@huawei.com>,
        <liulongfang@huawei.com>, <qianweili@huawei.com>,
        <zhangwei375@huawei.com>, <fanghao11@huawei.com>,
        <forest.zhouchang@huawei.com>
Subject: [PATCH v2 1/9] crypto: hisilicon - Update debugfs usage of SEC V2
Date:   Sat, 11 Jan 2020 10:41:48 +0800
Message-ID: <1578710516-40535-2-git-send-email-xuzaibo@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1578710516-40535-1-git-send-email-xuzaibo@huawei.com>
References: <1578710516-40535-1-git-send-email-xuzaibo@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Applied some advices of Marco Elver on atomic usage of Debugfs,
which is carried out by basing on Arnd Bergmann's fixing patch.

Reported-by: Arnd Bergmann <arnd@arndb.de>
Reported-by: Marco Elver <elver@google.com>
Signed-off-by: Zaibo Xu <xuzaibo@huawei.com>
---
 drivers/crypto/hisilicon/sec2/sec.h        |  2 +-
 drivers/crypto/hisilicon/sec2/sec_crypto.c |  8 ++++----
 drivers/crypto/hisilicon/sec2/sec_main.c   | 18 +++++++++---------
 3 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/crypto/hisilicon/sec2/sec.h b/drivers/crypto/hisilicon/sec2/sec.h
index b846d73..841f4c5 100644
--- a/drivers/crypto/hisilicon/sec2/sec.h
+++ b/drivers/crypto/hisilicon/sec2/sec.h
@@ -40,7 +40,7 @@ struct sec_req {
 	int req_id;
 
 	/* Status of the SEC request */
-	atomic_t fake_busy;
+	bool fake_busy;
 };
 
 /**
diff --git a/drivers/crypto/hisilicon/sec2/sec_crypto.c b/drivers/crypto/hisilicon/sec2/sec_crypto.c
index 0a5391f..2475aaf 100644
--- a/drivers/crypto/hisilicon/sec2/sec_crypto.c
+++ b/drivers/crypto/hisilicon/sec2/sec_crypto.c
@@ -141,7 +141,7 @@ static int sec_bd_send(struct sec_ctx *ctx, struct sec_req *req)
 		return -ENOBUFS;
 
 	if (!ret) {
-		if (atomic_read(&req->fake_busy))
+		if (req->fake_busy)
 			ret = -EBUSY;
 		else
 			ret = -EINPROGRESS;
@@ -641,7 +641,7 @@ static void sec_skcipher_callback(struct sec_ctx *ctx, struct sec_req *req)
 	if (ctx->c_ctx.c_mode == SEC_CMODE_CBC && req->c_req.encrypt)
 		sec_update_iv(req);
 
-	if (atomic_cmpxchg(&req->fake_busy, 1, 0) != 1)
+	if (req->fake_busy)
 		sk_req->base.complete(&sk_req->base, -EINPROGRESS);
 
 	sk_req->base.complete(&sk_req->base, req->err_type);
@@ -672,9 +672,9 @@ static int sec_request_init(struct sec_ctx *ctx, struct sec_req *req)
 	}
 
 	if (ctx->fake_req_limit <= atomic_inc_return(&qp_ctx->pending_reqs))
-		atomic_set(&req->fake_busy, 1);
+		req->fake_busy = true;
 	else
-		atomic_set(&req->fake_busy, 0);
+		req->fake_busy = false;
 
 	ret = ctx->req_op->get_res(ctx, req);
 	if (ret) {
diff --git a/drivers/crypto/hisilicon/sec2/sec_main.c b/drivers/crypto/hisilicon/sec2/sec_main.c
index ab742df..d40e2da 100644
--- a/drivers/crypto/hisilicon/sec2/sec_main.c
+++ b/drivers/crypto/hisilicon/sec2/sec_main.c
@@ -608,13 +608,13 @@ static const struct file_operations sec_dbg_fops = {
 	.write = sec_debug_write,
 };
 
-static int debugfs_atomic64_t_get(void *data, u64 *val)
+static int sec_debugfs_atomic64_get(void *data, u64 *val)
 {
-        *val = atomic64_read((atomic64_t *)data);
-        return 0;
+	*val = atomic64_read((atomic64_t *)data);
+	return 0;
 }
-DEFINE_DEBUGFS_ATTRIBUTE(fops_atomic64_t_ro, debugfs_atomic64_t_get, NULL,
-                        "%lld\n");
+DEFINE_DEBUGFS_ATTRIBUTE(sec_atomic64_ops, sec_debugfs_atomic64_get,
+			 NULL, "%lld\n");
 
 static int sec_core_debug_init(struct sec_dev *sec)
 {
@@ -636,11 +636,11 @@ static int sec_core_debug_init(struct sec_dev *sec)
 
 	debugfs_create_regset32("regs", 0444, tmp_d, regset);
 
-	debugfs_create_file("send_cnt", 0444, tmp_d, &dfx->send_cnt,
-			    &fops_atomic64_t_ro);
+	debugfs_create_file("send_cnt", 0444, tmp_d,
+			    &dfx->send_cnt, &sec_atomic64_ops);
 
-	debugfs_create_file("recv_cnt", 0444, tmp_d, &dfx->recv_cnt,
-			    &fops_atomic64_t_ro);
+	debugfs_create_file("recv_cnt", 0444, tmp_d,
+			    &dfx->recv_cnt, &sec_atomic64_ops);
 
 	return 0;
 }
-- 
2.8.1

