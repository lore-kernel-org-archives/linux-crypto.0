Return-Path: <SRS0=WlNz=3A=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A6F4C33CA4
	for <linux-crypto@archiver.kernel.org>; Sat, 11 Jan 2020 02:45:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4A68420721
	for <linux-crypto@archiver.kernel.org>; Sat, 11 Jan 2020 02:45:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728203AbgAKCpy (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 10 Jan 2020 21:45:54 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:45454 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728198AbgAKCpx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 10 Jan 2020 21:45:53 -0500
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 5ED6A5DD1941BF34EB48;
        Sat, 11 Jan 2020 10:45:49 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.439.0; Sat, 11 Jan 2020 10:45:43 +0800
From:   Zaibo Xu <xuzaibo@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <linuxarm@huawei.com>,
        <jonathan.cameron@huawei.com>, <wangzhou1@hisilicon.com>,
        <tanghui20@huawei.com>, <yekai13@huawei.com>,
        <liulongfang@huawei.com>, <qianweili@huawei.com>,
        <zhangwei375@huawei.com>, <fanghao11@huawei.com>,
        <forest.zhouchang@huawei.com>
Subject: [PATCH v2 7/9] crypto: hisilicon - Add branch prediction macro
Date:   Sat, 11 Jan 2020 10:41:54 +0800
Message-ID: <1578710516-40535-8-git-send-email-xuzaibo@huawei.com>
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

After adding branch prediction for skcipher hot path,
a little bit income of performance is gotten.

Signed-off-by: Zaibo Xu <xuzaibo@huawei.com>
---
 drivers/crypto/hisilicon/sec2/sec_crypto.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/crypto/hisilicon/sec2/sec_crypto.c b/drivers/crypto/hisilicon/sec2/sec_crypto.c
index 568c174..521bab8 100644
--- a/drivers/crypto/hisilicon/sec2/sec_crypto.c
+++ b/drivers/crypto/hisilicon/sec2/sec_crypto.c
@@ -69,7 +69,7 @@ static int sec_alloc_req_id(struct sec_req *req, struct sec_qp_ctx *qp_ctx)
 	req_id = idr_alloc_cyclic(&qp_ctx->req_idr, NULL,
 				  0, QM_Q_DEPTH, GFP_ATOMIC);
 	mutex_unlock(&qp_ctx->req_lock);
-	if (req_id < 0) {
+	if (unlikely(req_id < 0)) {
 		dev_err(SEC_CTX_DEV(req->ctx), "alloc req id fail!\n");
 		return req_id;
 	}
@@ -84,7 +84,7 @@ static void sec_free_req_id(struct sec_req *req)
 	struct sec_qp_ctx *qp_ctx = req->qp_ctx;
 	int req_id = req->req_id;
 
-	if (req_id < 0 || req_id >= QM_Q_DEPTH) {
+	if (unlikely(req_id < 0 || req_id >= QM_Q_DEPTH)) {
 		dev_err(SEC_CTX_DEV(req->ctx), "free request id invalid!\n");
 		return;
 	}
@@ -108,7 +108,7 @@ static void sec_req_cb(struct hisi_qp *qp, void *resp)
 	u8 type;
 
 	type = bd->type_cipher_auth & SEC_TYPE_MASK;
-	if (type != SEC_BD_TYPE2) {
+	if (unlikely(type != SEC_BD_TYPE2)) {
 		pr_err("err bd type [%d]\n", type);
 		return;
 	}
@@ -144,7 +144,7 @@ static int sec_bd_send(struct sec_ctx *ctx, struct sec_req *req)
 	mutex_unlock(&qp_ctx->req_lock);
 	atomic64_inc(&ctx->sec->debug.dfx.send_cnt);
 
-	if (ret == -EBUSY)
+	if (unlikely(ret == -EBUSY))
 		return -ENOBUFS;
 
 	if (!ret) {
@@ -526,13 +526,13 @@ static int sec_request_transfer(struct sec_ctx *ctx, struct sec_req *req)
 	int ret;
 
 	ret = ctx->req_op->buf_map(ctx, req);
-	if (ret)
+	if (unlikely(ret))
 		return ret;
 
 	ctx->req_op->do_transfer(ctx, req);
 
 	ret = ctx->req_op->bd_fill(ctx, req);
-	if (ret)
+	if (unlikely(ret))
 		goto unmap_req_buf;
 
 	return ret;
@@ -617,7 +617,7 @@ static void sec_update_iv(struct sec_req *req)
 
 	sz = sg_pcopy_to_buffer(sgl, sg_nents(sgl), sk_req->iv,
 				iv_size, sk_req->cryptlen - iv_size);
-	if (sz != iv_size)
+	if (unlikely(sz != iv_size))
 		dev_err(SEC_CTX_DEV(req->ctx), "copy output iv error!\n");
 }
 
@@ -659,7 +659,7 @@ static int sec_request_init(struct sec_ctx *ctx, struct sec_req *req)
 	qp_ctx = &ctx->qp_ctx[queue_id];
 
 	req->req_id = sec_alloc_req_id(req, qp_ctx);
-	if (req->req_id < 0) {
+	if (unlikely(req->req_id < 0)) {
 		sec_free_queue_id(ctx, req);
 		return req->req_id;
 	}
@@ -677,11 +677,11 @@ static int sec_process(struct sec_ctx *ctx, struct sec_req *req)
 	int ret;
 
 	ret = sec_request_init(ctx, req);
-	if (ret)
+	if (unlikely(ret))
 		return ret;
 
 	ret = sec_request_transfer(ctx, req);
-	if (ret)
+	if (unlikely(ret))
 		goto err_uninit_req;
 
 	/* Output IV as decrypto */
@@ -689,7 +689,7 @@ static int sec_process(struct sec_ctx *ctx, struct sec_req *req)
 		sec_update_iv(req);
 
 	ret = ctx->req_op->bd_send(ctx, req);
-	if (ret != -EBUSY && ret != -EINPROGRESS) {
+	if (unlikely(ret != -EBUSY && ret != -EINPROGRESS)) {
 		dev_err_ratelimited(SEC_CTX_DEV(ctx), "send sec request failed!\n");
 		goto err_send_req;
 	}
@@ -740,19 +740,19 @@ static int sec_skcipher_param_check(struct sec_ctx *ctx, struct sec_req *sreq)
 	struct device *dev = SEC_CTX_DEV(ctx);
 	u8 c_alg = ctx->c_ctx.c_alg;
 
-	if (!sk_req->src || !sk_req->dst) {
+	if (unlikely(!sk_req->src || !sk_req->dst)) {
 		dev_err(dev, "skcipher input param error!\n");
 		return -EINVAL;
 	}
 	sreq->c_req.c_len = sk_req->cryptlen;
 	if (c_alg == SEC_CALG_3DES) {
-		if (sk_req->cryptlen & (DES3_EDE_BLOCK_SIZE - 1)) {
+		if (unlikely(sk_req->cryptlen & (DES3_EDE_BLOCK_SIZE - 1))) {
 			dev_err(dev, "skcipher 3des input length error!\n");
 			return -EINVAL;
 		}
 		return 0;
 	} else if (c_alg == SEC_CALG_AES || c_alg == SEC_CALG_SM4) {
-		if (sk_req->cryptlen & (AES_BLOCK_SIZE - 1)) {
+		if (unlikely(sk_req->cryptlen & (AES_BLOCK_SIZE - 1))) {
 			dev_err(dev, "skcipher aes input length error!\n");
 			return -EINVAL;
 		}
-- 
2.8.1

