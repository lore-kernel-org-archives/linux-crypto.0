Return-Path: <SRS0=chSI=24=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3507BC282DD
	for <linux-crypto@archiver.kernel.org>; Tue,  7 Jan 2020 20:10:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 10F1E2080A
	for <linux-crypto@archiver.kernel.org>; Tue,  7 Jan 2020 20:10:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728457AbgAGUK3 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 7 Jan 2020 15:10:29 -0500
Received: from mout.kundenserver.de ([212.227.17.10]:47025 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728358AbgAGUK3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 7 Jan 2020 15:10:29 -0500
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue107 [212.227.15.145]) with ESMTPA (Nemesis) id
 1M8xwu-1ijzDT3bJ0-0063Ph; Tue, 07 Jan 2020 21:09:29 +0100
From:   Arnd Bergmann <arnd@arndb.de>
To:     Zaibo Xu <xuzaibo@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Longfang Liu <liulongfang@huawei.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: hisilicon/sec2 - Use atomics instead of __sync
Date:   Tue,  7 Jan 2020 21:08:58 +0100
Message-Id: <20200107200926.3659010-1-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:w1wytbvXRZBmag8cVS6euN3xO5LlAwtVdiB6qobvrnXb9JgOjvs
 BuZfHilEI3cwS+6I6WJesu/xjz9bPmc83lbniFl3WwA5GUv3o6NEynaZf1ZLJYKoBXEMmbG
 WWb6wO//Ws1TQCYL6TEZSFOPivkGT8NJve2wBlirXR4waZvjaACN2rKG3urICG9i9YC2SMR
 U+iUhF+MfFL9JG3TKQO0Q==
X-UI-Out-Filterresults: notjunk:1;V03:K0:R6e4FEN+IIs=:OiG5rM7pOqLOs3ENAnBFzE
 3bTZmUWsn2LQfptAj6EEoW/a7lMr+xBvgWhFXJaQU5FVaZD5M+Pqp47NZ/Li/2Q6ds/k27zPH
 TKvPKsPpqY+4MbtDIe97oYSJ4JrEoqWEEeYc4HLr/V/0GXxPodKpbCK9/M5oBXbv75DNu4c5r
 svibHktol2V2gARTxpuabhcB138kc9a6XXidcwBa7ECbcgRWcbFYPf388Gc2px6QqiYNkl2Rt
 mWmpbRPkBN6led/V6hcAj0xthRk2EFPmHRGkmzvJtoSpuF8W+kSeg4LmFspWxbyO33Zf3eUHO
 4TGzxdhy5EJd7mI1V7Zjxa1t1HT66j7RJBUHmfgonYFI4bnOp3Ryx23yLfkIxVjovDjtfscR2
 OCCrAQ9sc7RoIVZmDSl4PmJujJTgkwAi4uHJ39bNNOpdWLq5W5q+obkQer+2P4EtBRr090unH
 z2W5+XE2SWYSYFCYhzrjQcSvOhMREU/rC4fRymMnf+dUcM2c02x8ETjKvvAe5A/LbNOQQpNu3
 sT1UqSRd2Df/cZlH/01iuXq+kjz+Nxu4cXVmCaduwjocQCenYjZTdE+dnSRrTppIlNRTbXUr+
 JPwzDkINrqDY6oiW4zlYt8J3xmBkJj9ZqLIFV28PKPqcIP56O4k5oZH9RG/g53SKaZVYlP67Q
 vpINfnhyp0ehnT72X/CW13PcqTIzXwGQbLPUqYfD54Rwvm8Y5JgElq47HQszBAkwnUDHxrWZM
 JhAoTz2JdoKaxZZzPcOJo0HBQPHEH8AwiCGWMg19WHQpOfxAC4NQELnTiu/0Bt9uOA2DTj3ze
 v49fifI9jOhfaeWVJ9812Bhk6we9jLlwh0aAFYTn54LE4zd9CqqylSjNRizUfIlSLmJygwxPC
 LOPGotTVGzPWx/A7KxSQ==
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The use of __sync functions for atomic memory access is not
supported in the kernel, and can result in a link error depending
on configuration:

ERROR: "__tsan_atomic32_compare_exchange_strong" [drivers/crypto/hisilicon/sec2/hisi_sec2.ko] undefined!
ERROR: "__tsan_atomic64_fetch_add" [drivers/crypto/hisilicon/sec2/hisi_sec2.ko] undefined!

Use the kernel's own atomic interfaces instead. This way the
debugfs interface actually reads the counter atomically.

Fixes: 416d82204df4 ("crypto: hisilicon - add HiSilicon SEC V2 driver")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/crypto/hisilicon/sec2/sec.h        |  6 +++---
 drivers/crypto/hisilicon/sec2/sec_crypto.c | 12 ++++++------
 drivers/crypto/hisilicon/sec2/sec_main.c   | 14 ++++++++++++--
 3 files changed, 21 insertions(+), 11 deletions(-)

diff --git a/drivers/crypto/hisilicon/sec2/sec.h b/drivers/crypto/hisilicon/sec2/sec.h
index 26754d0570ba..b846d73d9a85 100644
--- a/drivers/crypto/hisilicon/sec2/sec.h
+++ b/drivers/crypto/hisilicon/sec2/sec.h
@@ -40,7 +40,7 @@ struct sec_req {
 	int req_id;
 
 	/* Status of the SEC request */
-	int fake_busy;
+	atomic_t fake_busy;
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
index 62b04e19067c..0a5391fff485 100644
--- a/drivers/crypto/hisilicon/sec2/sec_crypto.c
+++ b/drivers/crypto/hisilicon/sec2/sec_crypto.c
@@ -120,7 +120,7 @@ static void sec_req_cb(struct hisi_qp *qp, void *resp)
 		return;
 	}
 
-	__sync_add_and_fetch(&req->ctx->sec->debug.dfx.recv_cnt, 1);
+	atomic64_inc(&req->ctx->sec->debug.dfx.recv_cnt);
 
 	req->ctx->req_op->buf_unmap(req->ctx, req);
 
@@ -135,13 +135,13 @@ static int sec_bd_send(struct sec_ctx *ctx, struct sec_req *req)
 	mutex_lock(&qp_ctx->req_lock);
 	ret = hisi_qp_send(qp_ctx->qp, &req->sec_sqe);
 	mutex_unlock(&qp_ctx->req_lock);
-	__sync_add_and_fetch(&ctx->sec->debug.dfx.send_cnt, 1);
+	atomic64_inc(&ctx->sec->debug.dfx.send_cnt);
 
 	if (ret == -EBUSY)
 		return -ENOBUFS;
 
 	if (!ret) {
-		if (req->fake_busy)
+		if (atomic_read(&req->fake_busy))
 			ret = -EBUSY;
 		else
 			ret = -EINPROGRESS;
@@ -641,7 +641,7 @@ static void sec_skcipher_callback(struct sec_ctx *ctx, struct sec_req *req)
 	if (ctx->c_ctx.c_mode == SEC_CMODE_CBC && req->c_req.encrypt)
 		sec_update_iv(req);
 
-	if (__sync_bool_compare_and_swap(&req->fake_busy, 1, 0))
+	if (atomic_cmpxchg(&req->fake_busy, 1, 0) != 1)
 		sk_req->base.complete(&sk_req->base, -EINPROGRESS);
 
 	sk_req->base.complete(&sk_req->base, req->err_type);
@@ -672,9 +672,9 @@ static int sec_request_init(struct sec_ctx *ctx, struct sec_req *req)
 	}
 
 	if (ctx->fake_req_limit <= atomic_inc_return(&qp_ctx->pending_reqs))
-		req->fake_busy = 1;
+		atomic_set(&req->fake_busy, 1);
 	else
-		req->fake_busy = 0;
+		atomic_set(&req->fake_busy, 0);
 
 	ret = ctx->req_op->get_res(ctx, req);
 	if (ret) {
diff --git a/drivers/crypto/hisilicon/sec2/sec_main.c b/drivers/crypto/hisilicon/sec2/sec_main.c
index 74f0654028c9..ab742dfbab99 100644
--- a/drivers/crypto/hisilicon/sec2/sec_main.c
+++ b/drivers/crypto/hisilicon/sec2/sec_main.c
@@ -608,6 +608,14 @@ static const struct file_operations sec_dbg_fops = {
 	.write = sec_debug_write,
 };
 
+static int debugfs_atomic64_t_get(void *data, u64 *val)
+{
+        *val = atomic64_read((atomic64_t *)data);
+        return 0;
+}
+DEFINE_DEBUGFS_ATTRIBUTE(fops_atomic64_t_ro, debugfs_atomic64_t_get, NULL,
+                        "%lld\n");
+
 static int sec_core_debug_init(struct sec_dev *sec)
 {
 	struct hisi_qm *qm = &sec->qm;
@@ -628,9 +636,11 @@ static int sec_core_debug_init(struct sec_dev *sec)
 
 	debugfs_create_regset32("regs", 0444, tmp_d, regset);
 
-	debugfs_create_u64("send_cnt", 0444, tmp_d, &dfx->send_cnt);
+	debugfs_create_file("send_cnt", 0444, tmp_d, &dfx->send_cnt,
+			    &fops_atomic64_t_ro);
 
-	debugfs_create_u64("recv_cnt", 0444, tmp_d, &dfx->recv_cnt);
+	debugfs_create_file("recv_cnt", 0444, tmp_d, &dfx->recv_cnt,
+			    &fops_atomic64_t_ro);
 
 	return 0;
 }
-- 
2.20.0

