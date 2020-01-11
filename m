Return-Path: <SRS0=WlNz=3A=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 932E5C33CA4
	for <linux-crypto@archiver.kernel.org>; Sat, 11 Jan 2020 02:45:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 70B9C2077C
	for <linux-crypto@archiver.kernel.org>; Sat, 11 Jan 2020 02:45:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728195AbgAKCpv (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 10 Jan 2020 21:45:51 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:49422 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728198AbgAKCpv (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 10 Jan 2020 21:45:51 -0500
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 7440387AB426A854BB47;
        Sat, 11 Jan 2020 10:45:49 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.439.0; Sat, 11 Jan 2020 10:45:42 +0800
From:   Zaibo Xu <xuzaibo@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <linuxarm@huawei.com>,
        <jonathan.cameron@huawei.com>, <wangzhou1@hisilicon.com>,
        <tanghui20@huawei.com>, <yekai13@huawei.com>,
        <liulongfang@huawei.com>, <qianweili@huawei.com>,
        <zhangwei375@huawei.com>, <fanghao11@huawei.com>,
        <forest.zhouchang@huawei.com>
Subject: [PATCH v2 5/9] crypto: hisilicon - Adjust some inner logic
Date:   Sat, 11 Jan 2020 10:41:52 +0800
Message-ID: <1578710516-40535-6-git-send-email-xuzaibo@huawei.com>
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

1.Adjust call back function.
2.Adjust parameter checking function.

Signed-off-by: Zaibo Xu <xuzaibo@huawei.com>
---
 drivers/crypto/hisilicon/sec2/sec_crypto.c | 54 ++++++++++++++++--------------
 1 file changed, 28 insertions(+), 26 deletions(-)

diff --git a/drivers/crypto/hisilicon/sec2/sec_crypto.c b/drivers/crypto/hisilicon/sec2/sec_crypto.c
index bef88c7..a6d5207 100644
--- a/drivers/crypto/hisilicon/sec2/sec_crypto.c
+++ b/drivers/crypto/hisilicon/sec2/sec_crypto.c
@@ -35,6 +35,8 @@
 #define SEC_TOTAL_IV_SZ		(SEC_IV_SIZE * QM_Q_DEPTH)
 #define SEC_SGL_SGE_NR		128
 #define SEC_CTX_DEV(ctx)	(&(ctx)->sec->qm.pdev->dev)
+#define SEC_SQE_CFLAG		2
+#define SEC_SQE_DONE		0x1
 
 static DEFINE_MUTEX(sec_algs_lock);
 static unsigned int sec_active_devs;
@@ -99,32 +101,34 @@ static void sec_req_cb(struct hisi_qp *qp, void *resp)
 {
 	struct sec_qp_ctx *qp_ctx = qp->qp_ctx;
 	struct sec_sqe *bd = resp;
+	struct sec_ctx *ctx;
+	struct sec_req *req;
 	u16 done, flag;
 	u8 type;
-	struct sec_req *req;
 
 	type = bd->type_cipher_auth & SEC_TYPE_MASK;
-	if (type == SEC_BD_TYPE2) {
-		req = qp_ctx->req_list[le16_to_cpu(bd->type2.tag)];
-		req->err_type = bd->type2.error_type;
-
-		done = le16_to_cpu(bd->type2.done_flag) & SEC_DONE_MASK;
-		flag = (le16_to_cpu(bd->type2.done_flag) &
-				   SEC_FLAG_MASK) >> SEC_FLAG_OFFSET;
-		if (req->err_type || done != 0x1 || flag != 0x2)
-			dev_err(SEC_CTX_DEV(req->ctx),
-				"err_type[%d],done[%d],flag[%d]\n",
-				req->err_type, done, flag);
-	} else {
+	if (type != SEC_BD_TYPE2) {
 		pr_err("err bd type [%d]\n", type);
 		return;
 	}
 
-	atomic64_inc(&req->ctx->sec->debug.dfx.recv_cnt);
+	req = qp_ctx->req_list[le16_to_cpu(bd->type2.tag)];
+	req->err_type = bd->type2.error_type;
+	ctx = req->ctx;
+	done = le16_to_cpu(bd->type2.done_flag) & SEC_DONE_MASK;
+	flag = (le16_to_cpu(bd->type2.done_flag) &
+		SEC_FLAG_MASK) >> SEC_FLAG_OFFSET;
+	if (req->err_type || done != SEC_SQE_DONE ||
+	    flag != SEC_SQE_CFLAG)
+		dev_err(SEC_CTX_DEV(ctx),
+			"err_type[%d],done[%d],flag[%d]\n",
+			req->err_type, done, flag);
 
-	req->ctx->req_op->buf_unmap(req->ctx, req);
+	atomic64_inc(&ctx->sec->debug.dfx.recv_cnt);
 
-	req->ctx->req_op->callback(req->ctx, req);
+	ctx->req_op->buf_unmap(ctx, req);
+
+	ctx->req_op->callback(ctx, req);
 }
 
 static int sec_bd_send(struct sec_ctx *ctx, struct sec_req *req)
@@ -545,9 +549,7 @@ static void sec_skcipher_copy_iv(struct sec_ctx *ctx, struct sec_req *req)
 {
 	struct skcipher_request *sk_req = req->c_req.sk_req;
 	u8 *c_ivin = req->qp_ctx->res[req->req_id].c_ivin;
-	struct sec_cipher_req *c_req = &req->c_req;
 
-	c_req->c_len = sk_req->cryptlen;
 	memcpy(c_ivin, sk_req->iv, ctx->c_ctx.ivsize);
 }
 
@@ -728,17 +730,17 @@ static void sec_skcipher_ctx_exit(struct crypto_skcipher *tfm)
 	sec_skcipher_uninit(tfm);
 }
 
-static int sec_skcipher_param_check(struct sec_ctx *ctx,
-				    struct skcipher_request *sk_req)
+static int sec_skcipher_param_check(struct sec_ctx *ctx, struct sec_req *sreq)
 {
-	u8 c_alg = ctx->c_ctx.c_alg;
+	struct skcipher_request *sk_req = sreq->c_req.sk_req;
 	struct device *dev = SEC_CTX_DEV(ctx);
+	u8 c_alg = ctx->c_ctx.c_alg;
 
 	if (!sk_req->src || !sk_req->dst) {
 		dev_err(dev, "skcipher input param error!\n");
 		return -EINVAL;
 	}
-
+	sreq->c_req.c_len = sk_req->cryptlen;
 	if (c_alg == SEC_CALG_3DES) {
 		if (sk_req->cryptlen & (DES3_EDE_BLOCK_SIZE - 1)) {
 			dev_err(dev, "skcipher 3des input length error!\n");
@@ -767,14 +769,14 @@ static int sec_skcipher_crypto(struct skcipher_request *sk_req, bool encrypt)
 	if (!sk_req->cryptlen)
 		return 0;
 
-	ret = sec_skcipher_param_check(ctx, sk_req);
-	if (ret)
-		return ret;
-
 	req->c_req.sk_req = sk_req;
 	req->c_req.encrypt = encrypt;
 	req->ctx = ctx;
 
+	ret = sec_skcipher_param_check(ctx, req);
+	if (unlikely(ret))
+		return -EINVAL;
+
 	return ctx->req_op->process(ctx, req);
 }
 
-- 
2.8.1

