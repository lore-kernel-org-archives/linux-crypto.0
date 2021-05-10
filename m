Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 483E6C433B4
	for <linux-crypto@archiver.kernel.org>; Mon, 10 May 2021 09:10:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 204A6613DE
	for <linux-crypto@archiver.kernel.org>; Mon, 10 May 2021 09:10:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230291AbhEJJLJ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 10 May 2021 05:11:09 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:2749 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230215AbhEJJLC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 10 May 2021 05:11:02 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FdwCZ5x3XzqV1Z;
        Mon, 10 May 2021 17:06:34 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.498.0; Mon, 10 May 2021 17:09:47 +0800
From:   Hui Tang <tanghui20@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <xuzaibo@huawei.com>,
        <wangzhou1@hisilicon.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/8] crypto: hisilicon/hpre - remove the macro of 'HPRE_DEV'
Date:   Mon, 10 May 2021 17:06:47 +0800
Message-ID: <1620637611-41643-5-git-send-email-tanghui20@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1620637611-41643-1-git-send-email-tanghui20@huawei.com>
References: <1620637611-41643-1-git-send-email-tanghui20@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Remove complex macro of 'HPRE_DEV' and replace with the initialized
device pointer.

Signed-off-by: Hui Tang <tanghui20@huawei.com>
---
 drivers/crypto/hisilicon/hpre/hpre_crypto.c | 53 ++++++++++++++---------------
 1 file changed, 26 insertions(+), 27 deletions(-)

diff --git a/drivers/crypto/hisilicon/hpre/hpre_crypto.c b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
index c07a7f5..b9197e9 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_crypto.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
@@ -30,7 +30,6 @@ struct hpre_ctx;
 #define HPRE_DH_G_FLAG		0x02
 #define HPRE_TRY_SEND_TIMES	100
 #define HPRE_INVLD_REQ_ID		(-1)
-#define HPRE_DEV(ctx)		(&((ctx)->qp->qm->pdev->dev))
 
 #define HPRE_SQE_ALG_BITS	5
 #define HPRE_SQE_DONE_SHIFT	30
@@ -102,6 +101,7 @@ struct hpre_curve25519_ctx {
 
 struct hpre_ctx {
 	struct hisi_qp *qp;
+	struct device *dev;
 	struct hpre_asym_request **req_list;
 	struct hpre *hpre;
 	spinlock_t req_lock;
@@ -214,8 +214,7 @@ static int hpre_get_data_dma_addr(struct hpre_asym_request *hpre_req,
 				  struct scatterlist *data, unsigned int len,
 				  int is_src, dma_addr_t *tmp)
 {
-	struct hpre_ctx *ctx = hpre_req->ctx;
-	struct device *dev = HPRE_DEV(ctx);
+	struct device *dev = hpre_req->ctx->dev;
 	enum dma_data_direction dma_dir;
 
 	if (is_src) {
@@ -239,7 +238,7 @@ static int hpre_prepare_dma_buf(struct hpre_asym_request *hpre_req,
 				int is_src, dma_addr_t *tmp)
 {
 	struct hpre_ctx *ctx = hpre_req->ctx;
-	struct device *dev = HPRE_DEV(ctx);
+	struct device *dev = ctx->dev;
 	void *ptr;
 	int shift;
 
@@ -293,7 +292,7 @@ static void hpre_hw_data_clr_all(struct hpre_ctx *ctx,
 				 struct scatterlist *dst,
 				 struct scatterlist *src)
 {
-	struct device *dev = HPRE_DEV(ctx);
+	struct device *dev = ctx->dev;
 	struct hpre_sqe *sqe = &req->req;
 	dma_addr_t tmp;
 
@@ -321,7 +320,6 @@ static void hpre_hw_data_clr_all(struct hpre_ctx *ctx,
 static int hpre_alg_res_post_hf(struct hpre_ctx *ctx, struct hpre_sqe *sqe,
 				void **kreq)
 {
-	struct device *dev = HPRE_DEV(ctx);
 	struct hpre_asym_request *req;
 	unsigned int err, done, alg;
 	int id;
@@ -346,7 +344,7 @@ static int hpre_alg_res_post_hf(struct hpre_ctx *ctx, struct hpre_sqe *sqe,
 		return 0;
 
 	alg = le32_to_cpu(sqe->dw0) & HREE_ALG_TYPE_MASK;
-	dev_err_ratelimited(dev, "alg[0x%x] error: done[0x%x], etype[0x%x]\n",
+	dev_err_ratelimited(ctx->dev, "alg[0x%x] error: done[0x%x], etype[0x%x]\n",
 		alg, done, err);
 
 	return -EINVAL;
@@ -361,6 +359,7 @@ static int hpre_ctx_set(struct hpre_ctx *ctx, struct hisi_qp *qp, int qlen)
 
 	spin_lock_init(&ctx->req_lock);
 	ctx->qp = qp;
+	ctx->dev = &qp->qm->pdev->dev;
 
 	hpre = container_of(ctx->qp->qm, struct hpre, qm);
 	ctx->hpre = hpre;
@@ -625,7 +624,7 @@ static int hpre_is_dh_params_length_valid(unsigned int key_sz)
 
 static int hpre_dh_set_params(struct hpre_ctx *ctx, struct dh *params)
 {
-	struct device *dev = HPRE_DEV(ctx);
+	struct device *dev = ctx->dev;
 	unsigned int sz;
 
 	if (params->p_size > HPRE_DH_MAX_P_SZ)
@@ -664,7 +663,7 @@ static int hpre_dh_set_params(struct hpre_ctx *ctx, struct dh *params)
 
 static void hpre_dh_clear_ctx(struct hpre_ctx *ctx, bool is_clear_all)
 {
-	struct device *dev = HPRE_DEV(ctx);
+	struct device *dev = ctx->dev;
 	unsigned int sz = ctx->key_sz;
 
 	if (is_clear_all)
@@ -877,18 +876,18 @@ static int hpre_rsa_set_n(struct hpre_ctx *ctx, const char *value,
 	if (!hpre_rsa_key_size_is_support(ctx->key_sz))
 		return 0;
 
-	ctx->rsa.pubkey = dma_alloc_coherent(HPRE_DEV(ctx), vlen << 1,
+	ctx->rsa.pubkey = dma_alloc_coherent(ctx->dev, vlen << 1,
 					     &ctx->rsa.dma_pubkey,
 					     GFP_KERNEL);
 	if (!ctx->rsa.pubkey)
 		return -ENOMEM;
 
 	if (private) {
-		ctx->rsa.prikey = dma_alloc_coherent(HPRE_DEV(ctx), vlen << 1,
+		ctx->rsa.prikey = dma_alloc_coherent(ctx->dev, vlen << 1,
 						     &ctx->rsa.dma_prikey,
 						     GFP_KERNEL);
 		if (!ctx->rsa.prikey) {
-			dma_free_coherent(HPRE_DEV(ctx), vlen << 1,
+			dma_free_coherent(ctx->dev, vlen << 1,
 					  ctx->rsa.pubkey,
 					  ctx->rsa.dma_pubkey);
 			ctx->rsa.pubkey = NULL;
@@ -950,7 +949,7 @@ static int hpre_crt_para_get(char *para, size_t para_sz,
 static int hpre_rsa_setkey_crt(struct hpre_ctx *ctx, struct rsa_key *rsa_key)
 {
 	unsigned int hlf_ksz = ctx->key_sz >> 1;
-	struct device *dev = HPRE_DEV(ctx);
+	struct device *dev = ctx->dev;
 	u64 offset;
 	int ret;
 
@@ -1008,7 +1007,7 @@ static int hpre_rsa_setkey_crt(struct hpre_ctx *ctx, struct rsa_key *rsa_key)
 static void hpre_rsa_clear_ctx(struct hpre_ctx *ctx, bool is_clear_all)
 {
 	unsigned int half_key_sz = ctx->key_sz >> 1;
-	struct device *dev = HPRE_DEV(ctx);
+	struct device *dev = ctx->dev;
 
 	if (is_clear_all)
 		hisi_qm_stop_qp(ctx->qp);
@@ -1179,7 +1178,7 @@ static void hpre_key_to_big_end(u8 *data, int len)
 static void hpre_ecc_clear_ctx(struct hpre_ctx *ctx, bool is_clear_all,
 			       bool is_ecdh)
 {
-	struct device *dev = HPRE_DEV(ctx);
+	struct device *dev = ctx->dev;
 	unsigned int sz = ctx->key_sz;
 	unsigned int shift = sz << 1;
 
@@ -1281,7 +1280,7 @@ static unsigned int hpre_ecdh_get_curvesz(unsigned short id)
 
 static int hpre_ecdh_set_param(struct hpre_ctx *ctx, struct ecdh *params)
 {
-	struct device *dev = HPRE_DEV(ctx);
+	struct device *dev = ctx->dev;
 	unsigned int sz, shift, curve_sz;
 	int ret;
 
@@ -1332,7 +1331,7 @@ static int hpre_ecdh_set_secret(struct crypto_kpp *tfm, const void *buf,
 				unsigned int len)
 {
 	struct hpre_ctx *ctx = kpp_tfm_ctx(tfm);
-	struct device *dev = HPRE_DEV(ctx);
+	struct device *dev = ctx->dev;
 	unsigned int sz, sz_shift;
 	struct ecdh params;
 	int ret;
@@ -1367,7 +1366,7 @@ static void hpre_ecdh_hw_data_clr_all(struct hpre_ctx *ctx,
 				      struct scatterlist *dst,
 				      struct scatterlist *src)
 {
-	struct device *dev = HPRE_DEV(ctx);
+	struct device *dev = ctx->dev;
 	struct hpre_sqe *sqe = &req->req;
 	dma_addr_t dma;
 
@@ -1450,7 +1449,7 @@ static int hpre_ecdh_src_data_init(struct hpre_asym_request *hpre_req,
 {
 	struct hpre_sqe *msg = &hpre_req->req;
 	struct hpre_ctx *ctx = hpre_req->ctx;
-	struct device *dev = HPRE_DEV(ctx);
+	struct device *dev = ctx->dev;
 	unsigned int tmpshift;
 	dma_addr_t dma = 0;
 	void *ptr;
@@ -1480,7 +1479,7 @@ static int hpre_ecdh_dst_data_init(struct hpre_asym_request *hpre_req,
 {
 	struct hpre_sqe *msg = &hpre_req->req;
 	struct hpre_ctx *ctx = hpre_req->ctx;
-	struct device *dev = HPRE_DEV(ctx);
+	struct device *dev = ctx->dev;
 	dma_addr_t dma = 0;
 
 	if (unlikely(!data || !sg_is_last(data) || len != ctx->key_sz << 1)) {
@@ -1503,7 +1502,7 @@ static int hpre_ecdh_compute_value(struct kpp_request *req)
 {
 	struct crypto_kpp *tfm = crypto_kpp_reqtfm(req);
 	struct hpre_ctx *ctx = kpp_tfm_ctx(tfm);
-	struct device *dev = HPRE_DEV(ctx);
+	struct device *dev = ctx->dev;
 	void *tmp = kpp_request_ctx(req);
 	struct hpre_asym_request *hpre_req = PTR_ALIGN(tmp, HPRE_ALIGN_SZ);
 	struct hpre_sqe *msg = &hpre_req->req;
@@ -1609,7 +1608,7 @@ static void hpre_curve25519_fill_curve(struct hpre_ctx *ctx, const void *buf,
 static int hpre_curve25519_set_param(struct hpre_ctx *ctx, const void *buf,
 				     unsigned int len)
 {
-	struct device *dev = HPRE_DEV(ctx);
+	struct device *dev = ctx->dev;
 	unsigned int sz = ctx->key_sz;
 	unsigned int shift = sz << 1;
 
@@ -1634,7 +1633,7 @@ static int hpre_curve25519_set_secret(struct crypto_kpp *tfm, const void *buf,
 				      unsigned int len)
 {
 	struct hpre_ctx *ctx = kpp_tfm_ctx(tfm);
-	struct device *dev = HPRE_DEV(ctx);
+	struct device *dev = ctx->dev;
 	int ret = -EINVAL;
 
 	if (len != CURVE25519_KEY_SIZE ||
@@ -1662,7 +1661,7 @@ static void hpre_curve25519_hw_data_clr_all(struct hpre_ctx *ctx,
 					    struct scatterlist *dst,
 					    struct scatterlist *src)
 {
-	struct device *dev = HPRE_DEV(ctx);
+	struct device *dev = ctx->dev;
 	struct hpre_sqe *sqe = &req->req;
 	dma_addr_t dma;
 
@@ -1752,7 +1751,7 @@ static int hpre_curve25519_src_init(struct hpre_asym_request *hpre_req,
 {
 	struct hpre_sqe *msg = &hpre_req->req;
 	struct hpre_ctx *ctx = hpre_req->ctx;
-	struct device *dev = HPRE_DEV(ctx);
+	struct device *dev = ctx->dev;
 	u8 p[CURVE25519_KEY_SIZE] = { 0 };
 	const struct ecc_curve *curve;
 	dma_addr_t dma = 0;
@@ -1807,7 +1806,7 @@ static int hpre_curve25519_dst_init(struct hpre_asym_request *hpre_req,
 {
 	struct hpre_sqe *msg = &hpre_req->req;
 	struct hpre_ctx *ctx = hpre_req->ctx;
-	struct device *dev = HPRE_DEV(ctx);
+	struct device *dev = ctx->dev;
 	dma_addr_t dma = 0;
 
 	if (!data || !sg_is_last(data) || len != ctx->key_sz) {
@@ -1830,7 +1829,7 @@ static int hpre_curve25519_compute_value(struct kpp_request *req)
 {
 	struct crypto_kpp *tfm = crypto_kpp_reqtfm(req);
 	struct hpre_ctx *ctx = kpp_tfm_ctx(tfm);
-	struct device *dev = HPRE_DEV(ctx);
+	struct device *dev = ctx->dev;
 	void *tmp = kpp_request_ctx(req);
 	struct hpre_asym_request *hpre_req = PTR_ALIGN(tmp, HPRE_ALIGN_SZ);
 	struct hpre_sqe *msg = &hpre_req->req;
-- 
2.8.1

