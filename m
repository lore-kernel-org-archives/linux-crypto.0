Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 592C7C43214
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Aug 2021 09:41:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 434DF61151
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Aug 2021 09:41:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239717AbhHMJl7 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 13 Aug 2021 05:41:59 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:8018 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239319AbhHMJl5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 Aug 2021 05:41:57 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4GmJTg4fN9zYpBJ;
        Fri, 13 Aug 2021 17:41:11 +0800 (CST)
Received: from dggpeml500012.china.huawei.com (7.185.36.15) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 13 Aug 2021 17:41:28 +0800
Received: from huawei.com (10.69.192.56) by dggpeml500012.china.huawei.com
 (7.185.36.15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Fri, 13 Aug
 2021 17:41:28 +0800
From:   Kai Ye <yekai13@huawei.com>
To:     <herbert@gondor.apana.org.au>
CC:     <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <wangzhou1@hisilicon.com>, <yekai13@huawei.com>
Subject: [PATCH 5/5] crypto: hisilicon/sec - add fallback tfm supporting for ahash
Date:   Fri, 13 Aug 2021 17:40:26 +0800
Message-ID: <1628847626-24383-6-git-send-email-yekai13@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1628847626-24383-1-git-send-email-yekai13@huawei.com>
References: <1628847626-24383-1-git-send-email-yekai13@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpeml500012.china.huawei.com (7.185.36.15)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

1. The Kunpeng920 hardware not support 0 packet size for digest mode.
2. The hardware only supports 4-byte alignment key inputing.
Due to the above hardware limitations, So the driver needs
to setting the soft fallback hash tfm for user.

Signed-off-by: Kai Ye <yekai13@huawei.com>
---
 drivers/crypto/hisilicon/sec2/sec.h        |   2 +
 drivers/crypto/hisilicon/sec2/sec_crypto.c | 105 +++++++++++++++++++++++++++++
 2 files changed, 107 insertions(+)

diff --git a/drivers/crypto/hisilicon/sec2/sec.h b/drivers/crypto/hisilicon/sec2/sec.h
index a68f7a4..7a81dcc 100644
--- a/drivers/crypto/hisilicon/sec2/sec.h
+++ b/drivers/crypto/hisilicon/sec2/sec.h
@@ -129,6 +129,8 @@ struct sec_auth_ctx {
 	 */
 	char metamac_idx[SEC_MAX_STREAMS];
 	struct crypto_shash *hash_tfm;
+	/* alloc soft hash tfm for not support parameter */
+	struct crypto_shash *fallback_ahash_tfm;
 	struct shash_desc *desc;
 	struct crypto_aead *fallback_aead_tfm;
 };
diff --git a/drivers/crypto/hisilicon/sec2/sec_crypto.c b/drivers/crypto/hisilicon/sec2/sec_crypto.c
index 85defc1..91853f8 100644
--- a/drivers/crypto/hisilicon/sec2/sec_crypto.c
+++ b/drivers/crypto/hisilicon/sec2/sec_crypto.c
@@ -1224,6 +1224,17 @@ static int sec_ahash_set_key(struct crypto_ahash *tfm, const u8 *key,
 	struct crypto_shash *shash_tfm = a_ctx->hash_tfm;
 	int blocksize, ret, digestsize;
 
+	ret = crypto_shash_setkey(a_ctx->fallback_ahash_tfm, key, keylen);
+	if (ret) {
+		pr_err("hisi_sec2: fallback shash set key error!\n");
+		return ret;
+	}
+
+	if (keylen & WORD_ALIGNMENT_MASK) {
+		a_ctx->fallback = true;
+		return 0;
+	}
+
 	blocksize = crypto_shash_blocksize(shash_tfm);
 	digestsize = crypto_shash_digestsize(shash_tfm);
 	if (keylen > blocksize) {
@@ -2575,6 +2586,8 @@ static int sec_ahash_req_init(struct ahash_request *req)
 	int sid;
 
 	sreq->ctx = ctx;
+	if (unlikely(a_ctx->fallback))
+		return crypto_shash_init(a_ctx->desc);
 
 	tfm_alg_name = tfm->base.__crt_alg->cra_name;
 	a_ctx->mac_len = crypto_ahash_digestsize(tfm);
@@ -2746,6 +2759,27 @@ static int sec_ahash_process(struct ahash_request *req)
 	return ctx->req_op->process(ctx, sreq);
 }
 
+static int sec_shash_update(struct ahash_request *req, struct sec_auth_ctx *ctx)
+{
+	int nents = sg_nents(req->src);
+	int total_sgl_len = 0;
+	struct scatterlist *sg;
+	int ret, i;
+
+	for_each_sg(req->src, sg, nents, i) {
+		ret = crypto_shash_update(ctx->desc, sg_virt(sg), sg->length);
+		if (ret) {
+			pr_err("ahash use fallback ahash is error!\n");
+			return ret;
+		}
+		total_sgl_len += sg->length;
+		if (total_sgl_len == req->nbytes)
+			break;
+	}
+
+	return 0;
+}
+
 static int sec_ahash_update(struct ahash_request *req)
 {
 	struct sec_req *sreq = ahash_request_ctx(req);
@@ -2757,6 +2791,9 @@ static int sec_ahash_update(struct ahash_request *req)
 	u32 data_len;
 	u8 idx;
 
+	if (unlikely(a_ctx->fallback))
+		return sec_shash_update(req, a_ctx);
+
 	if (unlikely(req->nbytes > SEC_HW_MAX_LEN)) {
 		dev_err_ratelimited(ctx->dev, "too long input for updating!\n");
 		return -EINVAL;
@@ -2800,6 +2837,9 @@ static int sec_ahash_final(struct ahash_request *req)
 	u32 sid = sareq->sid;
 	u8 idx;
 
+	if (unlikely(a_ctx->fallback))
+		return crypto_shash_final(a_ctx->desc, req->result);
+
 	sareq->op = SEC_SHA_FINAL;
 	if (sareq->is_stream_mode) {
 		idx = ctx->pingpong_idx[sid];
@@ -2826,6 +2866,20 @@ static int sec_ahash_finup(struct ahash_request *req)
 	int i = 0;
 	int ret;
 
+	if (unlikely(a_ctx->fallback)) {
+		for_each_sg(req->src, sg, nents, i) {
+			if (i + 1 == sg_nents(req->src))
+				return crypto_shash_finup(a_ctx->desc, sg_virt(sg),
+							sg->length, req->result);
+
+			ret = crypto_shash_update(a_ctx->desc, sg_virt(sg), sg->length);
+			if (ret) {
+				pr_err("ahash use fallback ahash is error!\n");
+				return ret;
+			}
+		}
+	}
+
 	if (sareq->op == SEC_SHA_UPDATE) {
 		if (unlikely(req->nbytes > SEC_HW_MAX_LEN)) {
 			dev_err_ratelimited(ctx->dev, "too long input for update+finup!\n");
@@ -2940,6 +2994,23 @@ static int sec_ahash_digest(struct ahash_request *req)
 	if (req->nbytes > SEC_HW_MAX_LEN)
 		return sec_ahash_larger_digest(req);
 
+	/* kunpeng 920, digest mode not support input 0 size */
+	if (unlikely(ctx->type_supported == SEC_BD_TYPE2 && !req->nbytes))
+		return crypto_shash_digest(a_ctx->desc, sg_virt(req->src), 0,
+								req->result);
+
+	if (unlikely(a_ctx->fallback)) {
+		for_each_sg(req->src, sg, nents, i) {
+			ret = crypto_shash_update(a_ctx->desc, sg_virt(sg),
+						  sg->length);
+			if (ret) {
+				pr_err("ahash use fallback ahash is error!\n");
+				return ret;
+			}
+		}
+
+		return crypto_shash_final(a_ctx->desc, req->result);
+	}
 	sareq->op = SEC_SHA_DIGEST;
 
 	return sec_ahash_finup(req);
@@ -2971,6 +3042,40 @@ static int sec_ahash_import(struct ahash_request *req, const void *in)
 	return 0;
 }
 
+static void sec_release_fallback_shash(struct crypto_shash *tfm,
+				       struct shash_desc *desc)
+{
+	crypto_free_shash(tfm);
+	kfree(desc);
+}
+
+static int sec_alloc_fallback_shash(const char *driver,
+				    struct crypto_shash **tfm_ret,
+				    struct shash_desc **desc_ret)
+{
+	struct crypto_shash *tfm;
+	struct shash_desc *desc;
+	int ret;
+
+	tfm = crypto_alloc_shash(driver, 0, CRYPTO_ALG_NEED_FALLBACK);
+	if (IS_ERR(tfm)) {
+		pr_err("ahash driver alloc hmac shash error!\n");
+		ret = PTR_ERR(tfm);
+		return ret;
+	}
+	desc = kmalloc(sizeof(*desc) + crypto_shash_descsize(tfm), GFP_KERNEL);
+	if (!desc) {
+		crypto_free_shash(tfm);
+		return -ENOMEM;
+	}
+	desc->tfm = tfm;
+
+	*tfm_ret = tfm;
+	*desc_ret = desc;
+
+	return 0;
+}
+
 static void sec_ahash_tfm_uninit(struct crypto_tfm *tfm)
 {
 	struct sec_ctx *ctx = crypto_tfm_ctx(tfm);
-- 
2.7.4

