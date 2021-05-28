Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2B3AC4708E
	for <linux-crypto@archiver.kernel.org>; Fri, 28 May 2021 11:45:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C6E736113D
	for <linux-crypto@archiver.kernel.org>; Fri, 28 May 2021 11:45:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235859AbhE1Lqt (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 28 May 2021 07:46:49 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:2516 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235632AbhE1Lqt (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 May 2021 07:46:49 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Fs2qC0m05zYqMw;
        Fri, 28 May 2021 19:42:31 +0800 (CST)
Received: from dggpeml500012.china.huawei.com (7.185.36.15) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 28 May 2021 19:45:11 +0800
Received: from huawei.com (10.67.165.24) by dggpeml500012.china.huawei.com
 (7.185.36.15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Fri, 28 May
 2021 19:45:11 +0800
From:   Kai Ye <yekai13@huawei.com>
To:     <herbert@gondor.apana.org.au>
CC:     <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <wangzhou1@hisilicon.com>, <yekai13@huawei.com>
Subject: [PATCH 2/3] crypto: hisilicon/sec - add fallback tfm supporting for XTS mode
Date:   Fri, 28 May 2021 19:42:05 +0800
Message-ID: <1622202126-19237-3-git-send-email-yekai13@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1622202126-19237-1-git-send-email-yekai13@huawei.com>
References: <1622202126-19237-1-git-send-email-yekai13@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500012.china.huawei.com (7.185.36.15)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add fallback tfm supporting for hisi_sec driver. Due to the hardware
not supports 192bit key length when using XTS mode. So the driver needs
to setting the soft fallback skcipher tfm for user.

Signed-off-by: Kai Ye <yekai13@huawei.com>
Signed-off-by: Longfang Liu <liulongfang@huawei.com>
---
 drivers/crypto/hisilicon/sec2/sec.h        |  4 ++
 drivers/crypto/hisilicon/sec2/sec_crypto.c | 85 ++++++++++++++++++++++++++++--
 2 files changed, 86 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/hisilicon/sec2/sec.h b/drivers/crypto/hisilicon/sec2/sec.h
index 14ba66d..935d8d9 100644
--- a/drivers/crypto/hisilicon/sec2/sec.h
+++ b/drivers/crypto/hisilicon/sec2/sec.h
@@ -97,6 +97,10 @@ struct sec_cipher_ctx {
 	u8 c_mode;
 	u8 c_alg;
 	u8 c_key_len;
+
+	/* add software support */
+	bool fallback;
+	struct crypto_sync_skcipher *fbtfm;
 };
 
 /* SEC queue context which defines queue's relatives */
diff --git a/drivers/crypto/hisilicon/sec2/sec_crypto.c b/drivers/crypto/hisilicon/sec2/sec_crypto.c
index b399315..25da33a 100644
--- a/drivers/crypto/hisilicon/sec2/sec_crypto.c
+++ b/drivers/crypto/hisilicon/sec2/sec_crypto.c
@@ -21,6 +21,7 @@
 
 #define SEC_PRIORITY		4001
 #define SEC_XTS_MIN_KEY_SIZE	(2 * AES_MIN_KEY_SIZE)
+#define SEC_XTS_MID_KEY_SIZE	(3 * AES_MIN_KEY_SIZE)
 #define SEC_XTS_MAX_KEY_SIZE	(2 * AES_MAX_KEY_SIZE)
 #define SEC_DES3_2KEY_SIZE	(2 * DES_KEY_SIZE)
 #define SEC_DES3_3KEY_SIZE	(3 * DES_KEY_SIZE)
@@ -81,6 +82,7 @@
 #define MAX_INPUT_DATA_LEN	0xFFFE00
 #define BITS_MASK		0xFF
 #define BYTE_BITS		0x8
+#define SEC_XTS_NAME_SZ		0x3
 
 /* Get an en/de-cipher queue cyclically to balance load over queues of TFM */
 static inline int sec_alloc_queue_id(struct sec_ctx *ctx, struct sec_req *req)
@@ -598,6 +600,26 @@ static void sec_auth_uninit(struct sec_ctx *ctx)
 			  a_ctx->a_key, a_ctx->a_key_dma);
 }
 
+static int sec_skcipher_fbtfm_init(struct crypto_skcipher *tfm)
+{
+	const char *alg = crypto_tfm_alg_name(&tfm->base);
+	struct sec_ctx *ctx = crypto_skcipher_ctx(tfm);
+	struct sec_cipher_ctx *c_ctx = &ctx->c_ctx;
+
+	c_ctx->fallback = false;
+	if (likely(strncmp(alg, "xts", SEC_XTS_NAME_SZ)))
+		return 0;
+
+	c_ctx->fbtfm = crypto_alloc_sync_skcipher(alg, 0,
+						  CRYPTO_ALG_NEED_FALLBACK);
+	if (IS_ERR(c_ctx->fbtfm)) {
+		pr_err("failed to alloc fallback tfm!\n");
+		return PTR_ERR(c_ctx->fbtfm);
+	}
+
+	return 0;
+}
+
 static int sec_skcipher_init(struct crypto_skcipher *tfm)
 {
 	struct sec_ctx *ctx = crypto_skcipher_ctx(tfm);
@@ -619,8 +641,14 @@ static int sec_skcipher_init(struct crypto_skcipher *tfm)
 	if (ret)
 		goto err_cipher_init;
 
+	ret = sec_skcipher_fbtfm_init(tfm);
+	if (ret)
+		goto err_fbtfm_init;
+
 	return 0;
 
+err_fbtfm_init:
+	sec_cipher_uninit(ctx);
 err_cipher_init:
 	sec_ctx_base_uninit(ctx);
 	return ret;
@@ -630,6 +658,9 @@ static void sec_skcipher_uninit(struct crypto_skcipher *tfm)
 {
 	struct sec_ctx *ctx = crypto_skcipher_ctx(tfm);
 
+	if (ctx->c_ctx.fbtfm)
+		crypto_free_sync_skcipher(ctx->c_ctx.fbtfm);
+
 	sec_cipher_uninit(ctx);
 	sec_ctx_base_uninit(ctx);
 }
@@ -669,6 +700,9 @@ static int sec_skcipher_aes_sm4_setkey(struct sec_cipher_ctx *c_ctx,
 		case SEC_XTS_MIN_KEY_SIZE:
 			c_ctx->c_key_len = SEC_CKEY_128BIT;
 			break;
+		case SEC_XTS_MID_KEY_SIZE:
+			c_ctx->fallback = true;
+			break;
 		case SEC_XTS_MAX_KEY_SIZE:
 			c_ctx->c_key_len = SEC_CKEY_256BIT;
 			break;
@@ -740,7 +774,13 @@ static int sec_skcipher_setkey(struct crypto_skcipher *tfm, const u8 *key,
 	}
 
 	memcpy(c_ctx->c_key, key, keylen);
-
+	if (c_ctx->fallback) {
+		ret = crypto_sync_skcipher_setkey(c_ctx->fbtfm, key, keylen);
+		if (ret) {
+			dev_err(dev, "failed to set fallback skcipher key!\n");
+			return ret;
+		}
+	}
 	return 0;
 }
 
@@ -1709,6 +1749,37 @@ static int sec_skcipher_param_check(struct sec_ctx *ctx, struct sec_req *sreq)
 	return -EINVAL;
 }
 
+static int sec_skcipher_soft_crypto(struct sec_ctx *ctx,
+				    struct skcipher_request *sreq, bool encrypt)
+{
+	struct sec_cipher_ctx *c_ctx = &ctx->c_ctx;
+	struct device *dev = ctx->dev;
+	int ret;
+
+	SYNC_SKCIPHER_REQUEST_ON_STACK(subreq, c_ctx->fbtfm);
+
+	if (!c_ctx->fbtfm) {
+		dev_err(dev, "failed to check fallback tfm\n");
+		return -EINVAL;
+	}
+
+	skcipher_request_set_sync_tfm(subreq, c_ctx->fbtfm);
+
+	/* software need sync mode to do crypto */
+	skcipher_request_set_callback(subreq, sreq->base.flags,
+				      NULL, NULL);
+	skcipher_request_set_crypt(subreq, sreq->src, sreq->dst,
+				   sreq->cryptlen, sreq->iv);
+	if (encrypt)
+		ret = crypto_skcipher_encrypt(subreq);
+	else
+		ret = crypto_skcipher_decrypt(subreq);
+
+	skcipher_request_zero(subreq);
+
+	return ret;
+}
+
 static int sec_skcipher_crypto(struct skcipher_request *sk_req, bool encrypt)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(sk_req);
@@ -1716,8 +1787,11 @@ static int sec_skcipher_crypto(struct skcipher_request *sk_req, bool encrypt)
 	struct sec_ctx *ctx = crypto_skcipher_ctx(tfm);
 	int ret;
 
-	if (!sk_req->cryptlen)
+	if (!sk_req->cryptlen) {
+		if (ctx->c_ctx.c_mode == SEC_CMODE_XTS)
+			return -EINVAL;
 		return 0;
+	}
 
 	req->flag = sk_req->base.flags;
 	req->c_req.sk_req = sk_req;
@@ -1728,6 +1802,9 @@ static int sec_skcipher_crypto(struct skcipher_request *sk_req, bool encrypt)
 	if (unlikely(ret))
 		return -EINVAL;
 
+	if (unlikely(ctx->c_ctx.fallback))
+		return sec_skcipher_soft_crypto(ctx, sk_req, encrypt);
+
 	return ctx->req_op->process(ctx, req);
 }
 
@@ -1748,7 +1825,9 @@ static int sec_skcipher_decrypt(struct skcipher_request *sk_req)
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
-- 
2.8.1

