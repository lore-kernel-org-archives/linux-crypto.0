Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F073C4709A
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Jun 2021 01:31:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1B119613FF
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Jun 2021 01:31:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230041AbhFDBda (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 3 Jun 2021 21:33:30 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:7099 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230025AbhFDBd3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 3 Jun 2021 21:33:29 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Fx4t05PgZzYpD7;
        Fri,  4 Jun 2021 09:28:56 +0800 (CST)
Received: from dggpeml500012.china.huawei.com (7.185.36.15) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 4 Jun 2021 09:31:42 +0800
Received: from huawei.com (10.69.192.56) by dggpeml500012.china.huawei.com
 (7.185.36.15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Fri, 4 Jun 2021
 09:31:42 +0800
From:   Kai Ye <yekai13@huawei.com>
To:     <herbert@gondor.apana.org.au>
CC:     <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <wangzhou1@hisilicon.com>, <yekai13@huawei.com>
Subject: [PATCH 2/4] crypto: hisilicon/sec - add fallback tfm supporting for aeads
Date:   Fri, 4 Jun 2021 09:31:27 +0800
Message-ID: <1622770289-21588-3-git-send-email-yekai13@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1622770289-21588-1-git-send-email-yekai13@huawei.com>
References: <1622770289-21588-1-git-send-email-yekai13@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500012.china.huawei.com (7.185.36.15)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add fallback tfm supporting for hisi_sec driver. Due to the Kunpeng920's
CCM/GCM algorithm not supports 0 byte src length. So the driver needs to
setting the soft fallback aead tfm.

Signed-off-by: Kai Ye <yekai13@huawei.com>
Signed-off-by: Longfang Liu <liulongfang@huawei.com>
---
 drivers/crypto/hisilicon/sec2/sec.h        |  2 +
 drivers/crypto/hisilicon/sec2/sec_crypto.c | 97 ++++++++++++++++++++++++++++--
 2 files changed, 94 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/hisilicon/sec2/sec.h b/drivers/crypto/hisilicon/sec2/sec.h
index 2960fae..3fe7875 100644
--- a/drivers/crypto/hisilicon/sec2/sec.h
+++ b/drivers/crypto/hisilicon/sec2/sec.h
@@ -88,7 +88,9 @@ struct sec_auth_ctx {
 	u8 a_key_len;
 	u8 mac_len;
 	u8 a_alg;
+	bool fallback;
 	struct crypto_shash *hash_tfm;
+	struct crypto_aead *fallback_aead_tfm;
 };
 
 /* SEC cipher context which cipher's relatives */
diff --git a/drivers/crypto/hisilicon/sec2/sec_crypto.c b/drivers/crypto/hisilicon/sec2/sec_crypto.c
index f2ab9ff..194a9bc 100644
--- a/drivers/crypto/hisilicon/sec2/sec_crypto.c
+++ b/drivers/crypto/hisilicon/sec2/sec_crypto.c
@@ -2,6 +2,7 @@
 /* Copyright (c) 2019 HiSilicon Limited. */
 
 #include <crypto/aes.h>
+#include <crypto/aead.h>
 #include <crypto/algapi.h>
 #include <crypto/authenc.h>
 #include <crypto/des.h>
@@ -853,12 +854,16 @@ GEN_SEC_SETKEY_FUNC(sm4_ctr, SEC_CALG_SM4, SEC_CMODE_CTR)
 static int sec_cipher_pbuf_map(struct sec_ctx *ctx, struct sec_req *req,
 			struct scatterlist *src)
 {
-	struct aead_request *aead_req = req->aead_req.aead_req;
+	struct sec_aead_req *a_req = &req->aead_req;
+	struct aead_request *aead_req = a_req->aead_req;
 	struct sec_cipher_req *c_req = &req->c_req;
 	struct sec_qp_ctx *qp_ctx = req->qp_ctx;
 	struct device *dev = ctx->dev;
 	int copy_size, pbuf_length;
 	int req_id = req->req_id;
+	struct crypto_aead *tfm;
+	size_t authsize;
+	u8 *mac_offset;
 
 	if (ctx->alg_type == SEC_AEAD)
 		copy_size = aead_req->cryptlen + aead_req->assoclen;
@@ -866,12 +871,17 @@ static int sec_cipher_pbuf_map(struct sec_ctx *ctx, struct sec_req *req,
 		copy_size = c_req->c_len;
 
 	pbuf_length = sg_copy_to_buffer(src, sg_nents(src),
-							qp_ctx->res[req_id].pbuf,
-							copy_size);
+			qp_ctx->res[req_id].pbuf, copy_size);
 	if (unlikely(pbuf_length != copy_size)) {
 		dev_err(dev, "copy src data to pbuf error!\n");
 		return -EINVAL;
 	}
+	if (!c_req->encrypt && ctx->alg_type == SEC_AEAD) {
+		tfm = crypto_aead_reqtfm(aead_req);
+		authsize = crypto_aead_authsize(tfm);
+		mac_offset = qp_ctx->res[req_id].pbuf + copy_size - authsize;
+		memcpy(a_req->out_mac, mac_offset, authsize);
+	}
 
 	c_req->c_in_dma = qp_ctx->res[req_id].pbuf_dma;
 	c_req->c_out_dma = c_req->c_in_dma;
@@ -1044,6 +1054,28 @@ static int sec_aead_auth_set_key(struct sec_auth_ctx *ctx,
 	return 0;
 }
 
+static int sec_aead_setauthsize(struct crypto_aead *aead, unsigned int authsize)
+{
+	struct crypto_tfm *tfm = crypto_aead_tfm(aead);
+	struct sec_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct sec_auth_ctx *a_ctx = &ctx->a_ctx;
+
+	if (unlikely(a_ctx->fallback_aead_tfm))
+		return crypto_aead_setauthsize(a_ctx->fallback_aead_tfm, authsize);
+
+	return 0;
+}
+
+static int sec_aead_fallback_setkey(struct sec_auth_ctx *a_ctx,
+				    struct crypto_aead *tfm, const u8 *key,
+				    unsigned int keylen)
+{
+	crypto_aead_clear_flags(a_ctx->fallback_aead_tfm, CRYPTO_TFM_REQ_MASK);
+	crypto_aead_set_flags(a_ctx->fallback_aead_tfm,
+			      crypto_aead_get_flags(tfm) & CRYPTO_TFM_REQ_MASK);
+	return crypto_aead_setkey(a_ctx->fallback_aead_tfm, key, keylen);
+}
+
 static int sec_aead_setkey(struct crypto_aead *tfm, const u8 *key,
 			   const u32 keylen, const enum sec_hash_alg a_alg,
 			   const enum sec_calg c_alg,
@@ -1052,6 +1084,7 @@ static int sec_aead_setkey(struct crypto_aead *tfm, const u8 *key,
 {
 	struct sec_ctx *ctx = crypto_aead_ctx(tfm);
 	struct sec_cipher_ctx *c_ctx = &ctx->c_ctx;
+	struct sec_auth_ctx *a_ctx = &ctx->a_ctx;
 	struct device *dev = ctx->dev;
 	struct crypto_authenc_keys keys;
 	int ret;
@@ -1069,6 +1102,12 @@ static int sec_aead_setkey(struct crypto_aead *tfm, const u8 *key,
 		}
 		memcpy(c_ctx->c_key, key, keylen);
 
+		if (unlikely(a_ctx->fallback_aead_tfm)) {
+			ret = sec_aead_fallback_setkey(a_ctx, tfm, key, keylen);
+			if (ret)
+				return ret;
+		}
+
 		return 0;
 	}
 
@@ -1857,7 +1896,10 @@ static void sec_aead_ctx_exit(struct crypto_aead *tfm)
 
 static int sec_aead_xcm_ctx_init(struct crypto_aead *tfm)
 {
+	struct aead_alg *alg = crypto_aead_alg(tfm);
 	struct sec_ctx *ctx = crypto_aead_ctx(tfm);
+	struct sec_auth_ctx *a_ctx = &ctx->a_ctx;
+	const char *aead_name = alg->base.cra_name;
 	int ret;
 
 	ret = sec_aead_init(tfm);
@@ -1866,11 +1908,24 @@ static int sec_aead_xcm_ctx_init(struct crypto_aead *tfm)
 		return ret;
 	}
 
+	a_ctx->fallback_aead_tfm = crypto_alloc_aead(aead_name, 0,
+						     CRYPTO_ALG_NEED_FALLBACK |
+						     CRYPTO_ALG_ASYNC);
+	if (IS_ERR(a_ctx->fallback_aead_tfm)) {
+		dev_err(ctx->dev, "aead driver alloc fallback tfm error!\n");
+		sec_aead_exit(tfm);
+		return PTR_ERR(a_ctx->fallback_aead_tfm);
+	}
+	a_ctx->fallback = false;
+
 	return 0;
 }
 
 static void sec_aead_xcm_ctx_exit(struct crypto_aead *tfm)
 {
+	struct sec_ctx *ctx = crypto_aead_ctx(tfm);
+
+	crypto_free_aead(ctx->a_ctx.fallback_aead_tfm);
 	sec_aead_exit(tfm);
 }
 
@@ -2189,6 +2244,7 @@ static int sec_aead_param_check(struct sec_ctx *ctx, struct sec_req *sreq)
 		if (unlikely(!req->cryptlen || (!sreq->c_req.encrypt &&
 		    req->cryptlen <= authsize))) {
 			dev_err(dev, "Kunpeng920 not support 0 length!\n");
+			ctx->a_ctx.fallback = true;
 			return -EINVAL;
 		}
 	}
@@ -2211,6 +2267,31 @@ static int sec_aead_param_check(struct sec_ctx *ctx, struct sec_req *sreq)
 	return 0;
 }
 
+static int sec_aead_soft_crypto(struct sec_ctx *ctx,
+				struct aead_request *aead_req,
+				bool encrypt)
+{
+	struct aead_request *subreq = aead_request_ctx(aead_req);
+	struct sec_auth_ctx *a_ctx = &ctx->a_ctx;
+	struct device *dev = ctx->dev;
+
+	/* Kunpeng920 aead mode not support input 0 size */
+	if (!a_ctx->fallback_aead_tfm) {
+		dev_err(dev, "aead fallbcak tfm is NULL!\n");
+		return -EINVAL;
+	}
+
+	aead_request_set_tfm(subreq, a_ctx->fallback_aead_tfm);
+	aead_request_set_callback(subreq, aead_req->base.flags,
+				  aead_req->base.complete, aead_req->base.data);
+	aead_request_set_crypt(subreq, aead_req->src, aead_req->dst,
+			       aead_req->cryptlen, aead_req->iv);
+	aead_request_set_ad(subreq, aead_req->assoclen);
+
+	return encrypt ? crypto_aead_encrypt(subreq) :
+		   crypto_aead_decrypt(subreq);
+}
+
 static int sec_aead_crypto(struct aead_request *a_req, bool encrypt)
 {
 	struct crypto_aead *tfm = crypto_aead_reqtfm(a_req);
@@ -2224,8 +2305,11 @@ static int sec_aead_crypto(struct aead_request *a_req, bool encrypt)
 	req->ctx = ctx;
 
 	ret = sec_aead_param_check(ctx, req);
-	if (unlikely(ret))
+	if (unlikely(ret)) {
+		if (ctx->a_ctx.fallback)
+			return sec_aead_soft_crypto(ctx, a_req, encrypt);
 		return -EINVAL;
+	}
 
 	return ctx->req_op->process(ctx, req);
 }
@@ -2247,7 +2331,9 @@ static int sec_aead_decrypt(struct aead_request *a_req)
 		.cra_name = sec_cra_name,\
 		.cra_driver_name = "hisi_sec_"sec_cra_name,\
 		.cra_priority = SEC_PRIORITY,\
-		.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY,\
+		.cra_flags = CRYPTO_ALG_ASYNC |\
+		 CRYPTO_ALG_ALLOCATES_MEMORY |\
+		 CRYPTO_ALG_NEED_FALLBACK,\
 		.cra_blocksize = blk_size,\
 		.cra_ctxsize = sizeof(struct sec_ctx),\
 		.cra_module = THIS_MODULE,\
@@ -2255,6 +2341,7 @@ static int sec_aead_decrypt(struct aead_request *a_req)
 	.init = ctx_init,\
 	.exit = ctx_exit,\
 	.setkey = sec_set_key,\
+	.setauthsize = sec_aead_setauthsize,\
 	.decrypt = sec_aead_decrypt,\
 	.encrypt = sec_aead_encrypt,\
 	.ivsize = iv_size,\
-- 
2.8.1

