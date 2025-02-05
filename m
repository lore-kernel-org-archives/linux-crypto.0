Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9157E2139CB;
	Wed,  5 Feb 2025 03:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738727796; cv=none; b=eswerYOdb+4TH6AVK8PtxdnpDtJUCYEh8ZxvRDHrEfRJYs8/mtRHKAG2zgTzsetVNpWzPnbsMJV6le42RdKB6JOMmwchKU4pk46uM0XiiH0J1ueZPNJVl1E3mLtsUhkMzX2TvwnlLYAbu5iaW3knUK6P/NadDrX01u61qpk8beQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738727796; c=relaxed/simple;
	bh=9xDkvOAHcY5SWiCewkd+/YfFw7uIe/3NoERnqxPUFb0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=d/rYZBErkI4uZYoJbyK7Y1YWc/uWN6onD/L6PJHVMv/IgKaPFErC30J2tX5MP7HE12iq0xGTGeCnGQNqQl6+4aTjvqHEuMSVAXjjB+d2x7KajxZkiPyH6Zh5I/f4h458+HiIIsZcffMAEEfIMdB7rpo/x8MYnkpuiyS986VlfN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4YnmY550DjzgcSy;
	Wed,  5 Feb 2025 11:53:13 +0800 (CST)
Received: from kwepemd200024.china.huawei.com (unknown [7.221.188.85])
	by mail.maildlp.com (Postfix) with ESMTPS id 10A9A1401F3;
	Wed,  5 Feb 2025 11:56:31 +0800 (CST)
Received: from localhost.huawei.com (10.90.30.45) by
 kwepemd200024.china.huawei.com (7.221.188.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 5 Feb 2025 11:56:30 +0800
From: Chenghai Huang <huangchenghai2@huawei.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<liulongfang@huawei.com>, <shenyang39@huawei.com>, <qianweili@huawei.com>,
	<linwenkai6@hisilicon.com>, <wangzhou1@hisilicon.com>
Subject: [PATCH 3/3] crypto: hisilicon/sec2 - fix for sec spec check
Date: Wed, 5 Feb 2025 11:56:28 +0800
Message-ID: <20250205035628.845962-4-huangchenghai2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20250205035628.845962-1-huangchenghai2@huawei.com>
References: <20250205035628.845962-1-huangchenghai2@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemd200024.china.huawei.com (7.221.188.85)

From: Wenkai Lin <linwenkai6@hisilicon.com>

During encryption and decryption, user requests
must be checked first, if the specifications that
are not supported by the hardware are used, the
software computing is used for processing.

Fixes: 2f072d75d1ab ("crypto: hisilicon - Add aead support on SEC2")
Signed-off-by: Wenkai Lin <linwenkai6@hisilicon.com>
Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
---
 drivers/crypto/hisilicon/sec2/sec.h        |   1 -
 drivers/crypto/hisilicon/sec2/sec_crypto.c | 101 ++++++++-------------
 2 files changed, 39 insertions(+), 63 deletions(-)

diff --git a/drivers/crypto/hisilicon/sec2/sec.h b/drivers/crypto/hisilicon/sec2/sec.h
index 4b9970230..703920b49 100644
--- a/drivers/crypto/hisilicon/sec2/sec.h
+++ b/drivers/crypto/hisilicon/sec2/sec.h
@@ -37,7 +37,6 @@ struct sec_aead_req {
 	u8 *a_ivin;
 	dma_addr_t a_ivin_dma;
 	struct aead_request *aead_req;
-	bool fallback;
 };
 
 /* SEC request of Crypto */
diff --git a/drivers/crypto/hisilicon/sec2/sec_crypto.c b/drivers/crypto/hisilicon/sec2/sec_crypto.c
index 23e98a21b..8ea5305bc 100644
--- a/drivers/crypto/hisilicon/sec2/sec_crypto.c
+++ b/drivers/crypto/hisilicon/sec2/sec_crypto.c
@@ -690,14 +690,10 @@ static int sec_skcipher_fbtfm_init(struct crypto_skcipher *tfm)
 
 	c_ctx->fallback = false;
 
-	/* Currently, only XTS mode need fallback tfm when using 192bit key */
-	if (likely(strncmp(alg, "xts", SEC_XTS_NAME_SZ)))
-		return 0;
-
 	c_ctx->fbtfm = crypto_alloc_sync_skcipher(alg, 0,
 						  CRYPTO_ALG_NEED_FALLBACK);
 	if (IS_ERR(c_ctx->fbtfm)) {
-		pr_err("failed to alloc xts mode fallback tfm!\n");
+		pr_err("failed to alloc fallback tfm for %s!\n", alg);
 		return PTR_ERR(c_ctx->fbtfm);
 	}
 
@@ -857,7 +853,7 @@ static int sec_skcipher_setkey(struct crypto_skcipher *tfm, const u8 *key,
 	}
 
 	memcpy(c_ctx->c_key, key, keylen);
-	if (c_ctx->fallback && c_ctx->fbtfm) {
+	if (c_ctx->fbtfm) {
 		ret = crypto_sync_skcipher_setkey(c_ctx->fbtfm, key, keylen);
 		if (ret) {
 			dev_err(dev, "failed to set fallback skcipher key!\n");
@@ -1155,8 +1151,10 @@ static int sec_aead_setkey(struct crypto_aead *tfm, const u8 *key,
 	}
 
 	ret = crypto_authenc_extractkeys(&keys, key, keylen);
-	if (ret)
+	if (ret) {
+		dev_err(dev, "sec extract aead keys err!\n");
 		goto bad_key;
+	}
 
 	ret = sec_aead_aes_set_key(c_ctx, &keys);
 	if (ret) {
@@ -1170,12 +1168,6 @@ static int sec_aead_setkey(struct crypto_aead *tfm, const u8 *key,
 		goto bad_key;
 	}
 
-	if (ctx->a_ctx.a_key_len & WORD_MASK) {
-		ret = -EINVAL;
-		dev_err(dev, "AUTH key length error!\n");
-		goto bad_key;
-	}
-
 	ret = sec_aead_fallback_setkey(a_ctx, tfm, key, keylen);
 	if (ret) {
 		dev_err(dev, "set sec fallback key err!\n");
@@ -1995,8 +1987,7 @@ static int sec_aead_sha512_ctx_init(struct crypto_aead *tfm)
 	return sec_aead_ctx_init(tfm, "sha512");
 }
 
-static int sec_skcipher_cryptlen_check(struct sec_ctx *ctx,
-	struct sec_req *sreq)
+static int sec_skcipher_cryptlen_check(struct sec_ctx *ctx, struct sec_req *sreq)
 {
 	u32 cryptlen = sreq->c_req.sk_req->cryptlen;
 	struct device *dev = ctx->dev;
@@ -2018,10 +2009,6 @@ static int sec_skcipher_cryptlen_check(struct sec_ctx *ctx,
 		}
 		break;
 	case SEC_CMODE_CTR:
-		if (unlikely(ctx->sec->qm.ver < QM_HW_V3)) {
-			dev_err(dev, "skcipher HW version error!\n");
-			ret = -EINVAL;
-		}
 		break;
 	default:
 		ret = -EINVAL;
@@ -2030,17 +2017,21 @@ static int sec_skcipher_cryptlen_check(struct sec_ctx *ctx,
 	return ret;
 }
 
-static int sec_skcipher_param_check(struct sec_ctx *ctx, struct sec_req *sreq)
+static int sec_skcipher_param_check(struct sec_ctx *ctx,
+				    struct sec_req *sreq, bool *need_fallback)
 {
 	struct skcipher_request *sk_req = sreq->c_req.sk_req;
 	struct device *dev = ctx->dev;
 	u8 c_alg = ctx->c_ctx.c_alg;
 
-	if (unlikely(!sk_req->src || !sk_req->dst ||
-		     sk_req->cryptlen > MAX_INPUT_DATA_LEN)) {
+	if (unlikely(!sk_req->src || !sk_req->dst)) {
 		dev_err(dev, "skcipher input param error!\n");
 		return -EINVAL;
 	}
+
+	if (sk_req->cryptlen > MAX_INPUT_DATA_LEN)
+		*need_fallback = true;
+
 	sreq->c_req.c_len = sk_req->cryptlen;
 
 	if (ctx->pbuf_supported && sk_req->cryptlen <= SEC_PBUF_SZ)
@@ -2098,6 +2089,7 @@ static int sec_skcipher_crypto(struct skcipher_request *sk_req, bool encrypt)
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(sk_req);
 	struct sec_req *req = skcipher_request_ctx(sk_req);
 	struct sec_ctx *ctx = crypto_skcipher_ctx(tfm);
+	bool need_fallback = false;
 	int ret;
 
 	if (!sk_req->cryptlen) {
@@ -2111,11 +2103,11 @@ static int sec_skcipher_crypto(struct skcipher_request *sk_req, bool encrypt)
 	req->c_req.encrypt = encrypt;
 	req->ctx = ctx;
 
-	ret = sec_skcipher_param_check(ctx, req);
+	ret = sec_skcipher_param_check(ctx, req, &need_fallback);
 	if (unlikely(ret))
 		return -EINVAL;
 
-	if (unlikely(ctx->c_ctx.fallback))
+	if (unlikely(ctx->c_ctx.fallback || need_fallback))
 		return sec_skcipher_soft_crypto(ctx, sk_req, encrypt);
 
 	return ctx->req_op->process(ctx, req);
@@ -2223,52 +2215,35 @@ static int sec_aead_spec_check(struct sec_ctx *ctx, struct sec_req *sreq)
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
 	size_t sz = crypto_aead_authsize(tfm);
 	u8 c_mode = ctx->c_ctx.c_mode;
-	struct device *dev = ctx->dev;
 	int ret;
 
-	/* Hardware does not handle cases where authsize is not 4 bytes aligned */
-	if (c_mode == SEC_CMODE_CBC && (sz & WORD_MASK)) {
-		sreq->aead_req.fallback = true;
+	if (unlikely(ctx->sec->qm.ver == QM_HW_V2 && !sreq->c_req.c_len))
 		return -EINVAL;
-	}
 
 	if (unlikely(req->cryptlen + req->assoclen > MAX_INPUT_DATA_LEN ||
-	    req->assoclen > SEC_MAX_AAD_LEN)) {
-		dev_err(dev, "aead input spec error!\n");
+		     req->assoclen > SEC_MAX_AAD_LEN))
 		return -EINVAL;
-	}
 
 	if (c_mode == SEC_CMODE_CCM) {
-		if (unlikely(req->assoclen > SEC_MAX_CCM_AAD_LEN)) {
-			dev_err_ratelimited(dev, "CCM input aad parameter is too long!\n");
+		if (unlikely(req->assoclen > SEC_MAX_CCM_AAD_LEN))
 			return -EINVAL;
-		}
-		ret = aead_iv_demension_check(req);
-		if (ret) {
-			dev_err(dev, "aead input iv param error!\n");
-			return ret;
-		}
-	}
 
-	if (sreq->c_req.encrypt)
-		sreq->c_req.c_len = req->cryptlen;
-	else
-		sreq->c_req.c_len = req->cryptlen - sz;
-	if (c_mode == SEC_CMODE_CBC) {
-		if (unlikely(sreq->c_req.c_len & (AES_BLOCK_SIZE - 1))) {
-			dev_err(dev, "aead crypto length error!\n");
+		ret = aead_iv_demension_check(req);
+		if (unlikely(ret))
+			return -EINVAL;
+	} else if (c_mode == SEC_CMODE_CBC) {
+		if (unlikely(sz & WORD_MASK))
+			return -EINVAL;
+		if (unlikely(ctx->a_ctx.a_key_len & WORD_MASK))
 			return -EINVAL;
-		}
 	}
 
 	return 0;
 }
 
-static int sec_aead_param_check(struct sec_ctx *ctx, struct sec_req *sreq)
+static int sec_aead_param_check(struct sec_ctx *ctx, struct sec_req *sreq, bool *need_fallback)
 {
 	struct aead_request *req = sreq->aead_req.aead_req;
-	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
-	size_t authsize = crypto_aead_authsize(tfm);
 	struct device *dev = ctx->dev;
 	u8 c_alg = ctx->c_ctx.c_alg;
 
@@ -2277,12 +2252,10 @@ static int sec_aead_param_check(struct sec_ctx *ctx, struct sec_req *sreq)
 		return -EINVAL;
 	}
 
-	if (ctx->sec->qm.ver == QM_HW_V2) {
-		if (unlikely(!req->cryptlen || (!sreq->c_req.encrypt &&
-			     req->cryptlen <= authsize))) {
-			sreq->aead_req.fallback = true;
-			return -EINVAL;
-		}
+	if (unlikely(ctx->c_ctx.c_mode == SEC_CMODE_CBC &&
+		     sreq->c_req.c_len & (AES_BLOCK_SIZE - 1))) {
+		dev_err(dev, "aead cbc mode input data length error!\n");
+		return -EINVAL;
 	}
 
 	/* Support AES or SM4 */
@@ -2291,8 +2264,10 @@ static int sec_aead_param_check(struct sec_ctx *ctx, struct sec_req *sreq)
 		return -EINVAL;
 	}
 
-	if (unlikely(sec_aead_spec_check(ctx, sreq)))
+	if (unlikely(sec_aead_spec_check(ctx, sreq))) {
+		*need_fallback = true;
 		return -EINVAL;
+	}
 
 	if (ctx->pbuf_supported && (req->cryptlen + req->assoclen) <=
 		SEC_PBUF_SZ)
@@ -2336,17 +2311,19 @@ static int sec_aead_crypto(struct aead_request *a_req, bool encrypt)
 	struct crypto_aead *tfm = crypto_aead_reqtfm(a_req);
 	struct sec_req *req = aead_request_ctx(a_req);
 	struct sec_ctx *ctx = crypto_aead_ctx(tfm);
+	size_t sz = crypto_aead_authsize(tfm);
+	bool need_fallback = false;
 	int ret;
 
 	req->flag = a_req->base.flags;
 	req->aead_req.aead_req = a_req;
 	req->c_req.encrypt = encrypt;
 	req->ctx = ctx;
-	req->aead_req.fallback = false;
+	req->c_req.c_len = a_req->cryptlen - (req->c_req.encrypt ? 0 : sz);
 
-	ret = sec_aead_param_check(ctx, req);
+	ret = sec_aead_param_check(ctx, req, &need_fallback);
 	if (unlikely(ret)) {
-		if (req->aead_req.fallback)
+		if (need_fallback)
 			return sec_aead_soft_crypto(ctx, a_req, encrypt);
 		return -EINVAL;
 	}
-- 
2.33.0

