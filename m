Return-Path: <SRS0=JhzL=27=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EC14C33CA3
	for <linux-crypto@archiver.kernel.org>; Fri, 10 Jan 2020 07:53:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4EC5C2073A
	for <linux-crypto@archiver.kernel.org>; Fri, 10 Jan 2020 07:53:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726383AbgAJHxy (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 10 Jan 2020 02:53:54 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:42462 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726508AbgAJHxy (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 10 Jan 2020 02:53:54 -0500
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 0C498CBAD7D7A72CD0A2;
        Fri, 10 Jan 2020 15:53:52 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.439.0; Fri, 10 Jan 2020 15:53:43 +0800
From:   Zaibo Xu <xuzaibo@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <linuxarm@huawei.com>,
        <jonathan.cameron@huawei.com>, <wangzhou1@hisilicon.com>,
        <tanghui20@huawei.com>, <yekai13@huawei.com>,
        <liulongfang@huawei.com>, <qianweili@huawei.com>,
        <zhangwei375@huawei.com>, <fanghao11@huawei.com>,
        <forest.zhouchang@huawei.com>
Subject: [PATCH 3/9] crypto: hisilicon - Update some names on SEC V2
Date:   Fri, 10 Jan 2020 15:49:52 +0800
Message-ID: <1578642598-8584-4-git-send-email-xuzaibo@huawei.com>
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

1.Adjust dma map function to be reused by AEAD algorithms;
2.Update some names of internal functions and variables to
  support AEAD algorithms;
3.Rename 'sec_skcipher_exit' as 'sec_skcipher_uninit';
4.Rename 'sec_get/put_queue_id' as 'sec_alloc/free_queue_id';

Signed-off-by: Zaibo Xu <xuzaibo@huawei.com>
---
 drivers/crypto/hisilicon/sec2/sec.h        |  4 +-
 drivers/crypto/hisilicon/sec2/sec_crypto.c | 61 +++++++++++++++++-------------
 2 files changed, 36 insertions(+), 29 deletions(-)

diff --git a/drivers/crypto/hisilicon/sec2/sec.h b/drivers/crypto/hisilicon/sec2/sec.h
index 841f4c5..40139ba 100644
--- a/drivers/crypto/hisilicon/sec2/sec.h
+++ b/drivers/crypto/hisilicon/sec2/sec.h
@@ -9,8 +9,8 @@
 #include "../qm.h"
 #include "sec_crypto.h"
 
-/* Cipher resource per hardware SEC queue */
-struct sec_cipher_res {
+/* Algorithm resource per hardware SEC queue */
+struct sec_alg_res {
 	u8 *c_ivin;
 	dma_addr_t c_ivin_dma;
 };
diff --git a/drivers/crypto/hisilicon/sec2/sec_crypto.c b/drivers/crypto/hisilicon/sec2/sec_crypto.c
index 9dca958..5ef11da 100644
--- a/drivers/crypto/hisilicon/sec2/sec_crypto.c
+++ b/drivers/crypto/hisilicon/sec2/sec_crypto.c
@@ -40,7 +40,7 @@ static DEFINE_MUTEX(sec_algs_lock);
 static unsigned int sec_active_devs;
 
 /* Get an en/de-cipher queue cyclically to balance load over queues of TFM */
-static inline int sec_get_queue_id(struct sec_ctx *ctx, struct sec_req *req)
+static inline int sec_alloc_queue_id(struct sec_ctx *ctx, struct sec_req *req)
 {
 	if (req->c_req.encrypt)
 		return (u32)atomic_inc_return(&ctx->enc_qcyclic) %
@@ -50,7 +50,7 @@ static inline int sec_get_queue_id(struct sec_ctx *ctx, struct sec_req *req)
 				 ctx->hlf_q_num;
 }
 
-static inline void sec_put_queue_id(struct sec_ctx *ctx, struct sec_req *req)
+static inline void sec_free_queue_id(struct sec_ctx *ctx, struct sec_req *req)
 {
 	if (req->c_req.encrypt)
 		atomic_dec(&ctx->enc_qcyclic);
@@ -290,7 +290,7 @@ static int sec_skcipher_init(struct crypto_skcipher *tfm)
 	return ret;
 }
 
-static void sec_skcipher_exit(struct crypto_skcipher *tfm)
+static void sec_skcipher_uninit(struct crypto_skcipher *tfm)
 {
 	struct sec_ctx *ctx = crypto_skcipher_ctx(tfm);
 	struct sec_cipher_ctx *c_ctx = &ctx->c_ctx;
@@ -424,7 +424,7 @@ static int sec_skcipher_get_res(struct sec_ctx *ctx,
 				struct sec_req *req)
 {
 	struct sec_qp_ctx *qp_ctx = req->qp_ctx;
-	struct sec_cipher_res *c_res = qp_ctx->alg_meta_data;
+	struct sec_alg_res *c_res = qp_ctx->alg_meta_data;
 	struct sec_cipher_req *c_req = &req->c_req;
 	int req_id = req->req_id;
 
@@ -438,10 +438,10 @@ static int sec_skcipher_resource_alloc(struct sec_ctx *ctx,
 				       struct sec_qp_ctx *qp_ctx)
 {
 	struct device *dev = SEC_CTX_DEV(ctx);
-	struct sec_cipher_res *res;
+	struct sec_alg_res *res;
 	int i;
 
-	res = kcalloc(QM_Q_DEPTH, sizeof(struct sec_cipher_res), GFP_KERNEL);
+	res = kcalloc(QM_Q_DEPTH, sizeof(*res), GFP_KERNEL);
 	if (!res)
 		return -ENOMEM;
 
@@ -464,7 +464,7 @@ static int sec_skcipher_resource_alloc(struct sec_ctx *ctx,
 static void sec_skcipher_resource_free(struct sec_ctx *ctx,
 				      struct sec_qp_ctx *qp_ctx)
 {
-	struct sec_cipher_res *res = qp_ctx->alg_meta_data;
+	struct sec_alg_res *res = qp_ctx->alg_meta_data;
 	struct device *dev = SEC_CTX_DEV(ctx);
 
 	if (!res)
@@ -474,8 +474,8 @@ static void sec_skcipher_resource_free(struct sec_ctx *ctx,
 	kfree(res);
 }
 
-static int sec_skcipher_map(struct device *dev, struct sec_req *req,
-			    struct scatterlist *src, struct scatterlist *dst)
+static int sec_cipher_map(struct device *dev, struct sec_req *req,
+			  struct scatterlist *src, struct scatterlist *dst)
 {
 	struct sec_cipher_req *c_req = &req->c_req;
 	struct sec_qp_ctx *qp_ctx = req->qp_ctx;
@@ -509,12 +509,20 @@ static int sec_skcipher_map(struct device *dev, struct sec_req *req,
 	return 0;
 }
 
+static void sec_cipher_unmap(struct device *dev, struct sec_cipher_req *req,
+			     struct scatterlist *src, struct scatterlist *dst)
+{
+	if (dst != src)
+		hisi_acc_sg_buf_unmap(dev, src, req->c_in);
+
+	hisi_acc_sg_buf_unmap(dev, dst, req->c_out);
+}
+
 static int sec_skcipher_sgl_map(struct sec_ctx *ctx, struct sec_req *req)
 {
-	struct sec_cipher_req *c_req = &req->c_req;
+	struct skcipher_request *sq = req->c_req.sk_req;
 
-	return sec_skcipher_map(SEC_CTX_DEV(ctx), req,
-				c_req->sk_req->src, c_req->sk_req->dst);
+	return sec_cipher_map(SEC_CTX_DEV(ctx), req, sq->src, sq->dst);
 }
 
 static void sec_skcipher_sgl_unmap(struct sec_ctx *ctx, struct sec_req *req)
@@ -523,10 +531,7 @@ static void sec_skcipher_sgl_unmap(struct sec_ctx *ctx, struct sec_req *req)
 	struct sec_cipher_req *c_req = &req->c_req;
 	struct skcipher_request *sk_req = c_req->sk_req;
 
-	if (sk_req->dst != sk_req->src)
-		hisi_acc_sg_buf_unmap(dev, sk_req->src, c_req->c_in);
-
-	hisi_acc_sg_buf_unmap(dev, sk_req->dst, c_req->c_out);
+	sec_cipher_unmap(dev, c_req, sk_req->src, sk_req->dst);
 }
 
 static int sec_request_transfer(struct sec_ctx *ctx, struct sec_req *req)
@@ -653,21 +658,21 @@ static void sec_request_uninit(struct sec_ctx *ctx, struct sec_req *req)
 
 	atomic_dec(&qp_ctx->pending_reqs);
 	sec_free_req_id(req);
-	sec_put_queue_id(ctx, req);
+	sec_free_queue_id(ctx, req);
 }
 
 static int sec_request_init(struct sec_ctx *ctx, struct sec_req *req)
 {
 	struct sec_qp_ctx *qp_ctx;
-	int issue_id, ret;
+	int queue_id, ret;
 
 	/* To load balance */
-	issue_id = sec_get_queue_id(ctx, req);
-	qp_ctx = &ctx->qp_ctx[issue_id];
+	queue_id = sec_alloc_queue_id(ctx, req);
+	qp_ctx = &ctx->qp_ctx[queue_id];
 
 	req->req_id = sec_alloc_req_id(req, qp_ctx);
 	if (req->req_id < 0) {
-		sec_put_queue_id(ctx, req);
+		sec_free_queue_id(ctx, req);
 		return req->req_id;
 	}
 
@@ -723,7 +728,7 @@ static int sec_process(struct sec_ctx *ctx, struct sec_req *req)
 	return ret;
 }
 
-static struct sec_req_op sec_req_ops_tbl = {
+static const struct sec_req_op sec_skcipher_req_ops = {
 	.get_res	= sec_skcipher_get_res,
 	.resource_alloc	= sec_skcipher_resource_alloc,
 	.resource_free	= sec_skcipher_resource_free,
@@ -740,14 +745,14 @@ static int sec_skcipher_ctx_init(struct crypto_skcipher *tfm)
 {
 	struct sec_ctx *ctx = crypto_skcipher_ctx(tfm);
 
-	ctx->req_op = &sec_req_ops_tbl;
+	ctx->req_op = &sec_skcipher_req_ops;
 
 	return sec_skcipher_init(tfm);
 }
 
 static void sec_skcipher_ctx_exit(struct crypto_skcipher *tfm)
 {
-	sec_skcipher_exit(tfm);
+	sec_skcipher_uninit(tfm);
 }
 
 static int sec_skcipher_param_check(struct sec_ctx *ctx,
@@ -837,7 +842,7 @@ static int sec_skcipher_decrypt(struct skcipher_request *sk_req)
 	SEC_SKCIPHER_GEN_ALG(name, key_func, min_key_size, max_key_size, \
 	sec_skcipher_ctx_init, sec_skcipher_ctx_exit, blk_size, iv_size)
 
-static struct skcipher_alg sec_algs[] = {
+static struct skcipher_alg sec_skciphers[] = {
 	SEC_SKCIPHER_ALG("ecb(aes)", sec_setkey_aes_ecb,
 			 AES_MIN_KEY_SIZE, AES_MAX_KEY_SIZE,
 			 AES_BLOCK_SIZE, 0)
@@ -874,7 +879,8 @@ int sec_register_to_crypto(void)
 	/* To avoid repeat register */
 	mutex_lock(&sec_algs_lock);
 	if (++sec_active_devs == 1)
-		ret = crypto_register_skciphers(sec_algs, ARRAY_SIZE(sec_algs));
+		ret = crypto_register_skciphers(sec_skciphers,
+						ARRAY_SIZE(sec_skciphers));
 	mutex_unlock(&sec_algs_lock);
 
 	return ret;
@@ -884,6 +890,7 @@ void sec_unregister_from_crypto(void)
 {
 	mutex_lock(&sec_algs_lock);
 	if (--sec_active_devs == 0)
-		crypto_unregister_skciphers(sec_algs, ARRAY_SIZE(sec_algs));
+		crypto_unregister_skciphers(sec_skciphers,
+					    ARRAY_SIZE(sec_skciphers));
 	mutex_unlock(&sec_algs_lock);
 }
-- 
2.8.1

