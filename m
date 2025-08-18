Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B85F279DDC;
	Mon, 18 Aug 2025 06:57:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755500242; cv=none; b=scS01knU9jGH54FiBIJG0O9DnuJGMeyP2qHltUHG9zDO6QQ9LgeijdTBTfIZyWUoTIFC7EjmthoyYI2bOp2MA5IPPGz2BtRjkJQyfABdXZehS+Jm6amV424GuQul2A5XqGcdyJEqI+1OjyKiwh74EgBWQxdaCI6aJEnzorD/PHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755500242; c=relaxed/simple;
	bh=IBxfXjVVwSqaw92wUvWBUkPEKBBI5AeWSyFFTLRvVeE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KVbu4YAg8CZBR8sBVlFL1bgsLzkxfA2vd1b1BDKQJ2cs4bjk0ey/w7qYs13d5m3+JDFdPCB74CIzWjPnSxTDdJfzDCWstiNTQqD2HmCF0vISYg07uCLy3BJ1w9xgGyJKeg0CRaMpj8Hha+wTWaUuzUqST6EM2jV6oCAhbOuc/4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4c53Mt2LP6z13NCY;
	Mon, 18 Aug 2025 14:53:46 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id D7898180B66;
	Mon, 18 Aug 2025 14:57:16 +0800 (CST)
Received: from kwepemq200001.china.huawei.com (7.202.195.16) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 18 Aug 2025 14:57:16 +0800
Received: from localhost.huawei.com (10.90.31.46) by
 kwepemq200001.china.huawei.com (7.202.195.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 18 Aug 2025 14:57:15 +0800
From: Chenghai Huang <huangchenghai2@huawei.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<qianweili@huawei.com>, <linwenkai6@hisilicon.com>,
	<wangzhou1@hisilicon.com>, <taoqi10@huawei.com>
Subject: [PATCH v2 2/3] crypto: hisilicon/hpre - support the hpre algorithm fallback
Date: Mon, 18 Aug 2025 14:57:13 +0800
Message-ID: <20250818065714.1916898-3-huangchenghai2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20250818065714.1916898-1-huangchenghai2@huawei.com>
References: <20250818065714.1916898-1-huangchenghai2@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemq200001.china.huawei.com (7.202.195.16)

From: Weili Qian <qianweili@huawei.com>

There is an upper limit on the number of hardware queues.
When all hardware queues are busy, new processes fail to
apply for queues. To avoid affecting tasks, support fallback
mechanism when hardware queues are unavailable.

HPRE driver supports DH algorithm, limited to prime numbers up to 4K.
It supports prime numbers larger than 4K via fallback mechanism.

Fixes: 90274769cf79 ("crypto: hisilicon/hpre - add 'CURVE25519' algorithm")
Signed-off-by: Weili Qian <qianweili@huawei.com>
Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
---
 drivers/crypto/hisilicon/hpre/hpre_crypto.c | 314 +++++++++++++++++---
 drivers/crypto/hisilicon/qm.c               |   4 +-
 2 files changed, 269 insertions(+), 49 deletions(-)

diff --git a/drivers/crypto/hisilicon/hpre/hpre_crypto.c b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
index 1550c3818383..531cd59adbb6 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_crypto.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
@@ -94,6 +94,7 @@ struct hpre_dh_ctx {
 
 	char *g; /* m */
 	dma_addr_t dma_g;
+	struct crypto_kpp *soft_tfm;
 };
 
 struct hpre_ecdh_ctx {
@@ -104,6 +105,7 @@ struct hpre_ecdh_ctx {
 	/* low address: x->y */
 	unsigned char *g;
 	dma_addr_t dma_g;
+	struct crypto_kpp *soft_tfm;
 };
 
 struct hpre_curve25519_ctx {
@@ -114,6 +116,7 @@ struct hpre_curve25519_ctx {
 	/* gx coordinate */
 	unsigned char *g;
 	dma_addr_t dma_g;
+	struct crypto_kpp *soft_tfm;
 };
 
 struct hpre_ctx {
@@ -135,6 +138,7 @@ struct hpre_ctx {
 	unsigned int curve_id;
 	/* for high performance core */
 	u8 enable_hpcore;
+	bool fallback;
 };
 
 struct hpre_asym_request {
@@ -224,10 +228,8 @@ static struct hisi_qp *hpre_get_qp_and_start(u8 type)
 	int ret;
 
 	qp = hpre_create_qp(type);
-	if (!qp) {
-		pr_err("Can not create hpre qp!\n");
+	if (!qp)
 		return ERR_PTR(-ENODEV);
-	}
 
 	ret = hisi_qm_start_qp(qp, 0);
 	if (ret < 0) {
@@ -505,8 +507,10 @@ static int hpre_ctx_init(struct hpre_ctx *ctx, u8 type)
 	int ret;
 
 	qp = hpre_get_qp_and_start(type);
-	if (IS_ERR(qp))
-		return PTR_ERR(qp);
+	if (IS_ERR(qp)) {
+		ctx->qp = NULL;
+		return -ENODEV;
+	}
 
 	qp->qp_ctx = ctx;
 	qp->req_cb = hpre_alg_cb;
@@ -638,6 +642,48 @@ static int hpre_dh_compute_value(struct kpp_request *req)
 	return ret;
 }
 
+static struct kpp_request *hpre_dh_prepare_fb_req(struct kpp_request *req)
+{
+	struct kpp_request *fb_req = kpp_request_ctx(req);
+	struct crypto_kpp *tfm = crypto_kpp_reqtfm(req);
+	struct hpre_ctx *ctx = kpp_tfm_ctx(tfm);
+
+	kpp_request_set_tfm(fb_req, ctx->dh.soft_tfm);
+	kpp_request_set_callback(fb_req, req->base.flags, req->base.complete, req->base.data);
+	kpp_request_set_input(fb_req, req->src, req->src_len);
+	kpp_request_set_output(fb_req, req->dst, req->dst_len);
+
+	return fb_req;
+}
+
+static int hpre_dh_generate_public_key(struct kpp_request *req)
+{
+	struct crypto_kpp *tfm = crypto_kpp_reqtfm(req);
+	struct hpre_ctx *ctx = kpp_tfm_ctx(tfm);
+	struct kpp_request *fb_req;
+
+	if (ctx->fallback) {
+		fb_req = hpre_dh_prepare_fb_req(req);
+		return crypto_kpp_generate_public_key(fb_req);
+	}
+
+	return hpre_dh_compute_value(req);
+}
+
+static int hpre_dh_compute_shared_secret(struct kpp_request *req)
+{
+	struct crypto_kpp *tfm = crypto_kpp_reqtfm(req);
+	struct hpre_ctx *ctx = kpp_tfm_ctx(tfm);
+	struct kpp_request *fb_req;
+
+	if (ctx->fallback) {
+		fb_req = hpre_dh_prepare_fb_req(req);
+		return crypto_kpp_compute_shared_secret(fb_req);
+	}
+
+	return hpre_dh_compute_value(req);
+}
+
 static int hpre_is_dh_params_length_valid(unsigned int key_sz)
 {
 #define _HPRE_DH_GRP1		768
@@ -664,13 +710,6 @@ static int hpre_dh_set_params(struct hpre_ctx *ctx, struct dh *params)
 	struct device *dev = ctx->dev;
 	unsigned int sz;
 
-	if (params->p_size > HPRE_DH_MAX_P_SZ)
-		return -EINVAL;
-
-	if (hpre_is_dh_params_length_valid(params->p_size <<
-					   HPRE_BITS_2_BYTES_SHIFT))
-		return -EINVAL;
-
 	sz = ctx->key_sz = params->p_size;
 	ctx->dh.xa_p = dma_alloc_coherent(dev, sz << 1,
 					  &ctx->dh.dma_xa_p, GFP_KERNEL);
@@ -703,6 +742,9 @@ static void hpre_dh_clear_ctx(struct hpre_ctx *ctx, bool is_clear_all)
 	struct device *dev = ctx->dev;
 	unsigned int sz = ctx->key_sz;
 
+	if (!ctx->qp)
+		return;
+
 	if (is_clear_all)
 		hisi_qm_stop_qp(ctx->qp);
 
@@ -731,6 +773,13 @@ static int hpre_dh_set_secret(struct crypto_kpp *tfm, const void *buf,
 	if (crypto_dh_decode_key(buf, len, &params) < 0)
 		return -EINVAL;
 
+	if (!ctx->qp)
+		goto set_soft_secret;
+
+	if (hpre_is_dh_params_length_valid(params.p_size <<
+					   HPRE_BITS_2_BYTES_SHIFT))
+		goto set_soft_secret;
+
 	/* Free old secret if any */
 	hpre_dh_clear_ctx(ctx, false);
 
@@ -741,27 +790,55 @@ static int hpre_dh_set_secret(struct crypto_kpp *tfm, const void *buf,
 	memcpy(ctx->dh.xa_p + (ctx->key_sz - params.key_size), params.key,
 	       params.key_size);
 
+	ctx->fallback = false;
 	return 0;
 
 err_clear_ctx:
 	hpre_dh_clear_ctx(ctx, false);
 	return ret;
+set_soft_secret:
+	ctx->fallback = true;
+	return crypto_kpp_set_secret(ctx->dh.soft_tfm, buf, len);
 }
 
 static unsigned int hpre_dh_max_size(struct crypto_kpp *tfm)
 {
 	struct hpre_ctx *ctx = kpp_tfm_ctx(tfm);
 
+	if (ctx->fallback)
+		return crypto_kpp_maxsize(ctx->dh.soft_tfm);
+
 	return ctx->key_sz;
 }
 
 static int hpre_dh_init_tfm(struct crypto_kpp *tfm)
 {
 	struct hpre_ctx *ctx = kpp_tfm_ctx(tfm);
+	const char *alg = kpp_alg_name(tfm);
+	unsigned int reqsize;
+	int ret;
 
-	kpp_set_reqsize(tfm, sizeof(struct hpre_asym_request) + hpre_align_pd());
+	ctx->dh.soft_tfm = crypto_alloc_kpp(alg, 0, CRYPTO_ALG_NEED_FALLBACK);
+	if (IS_ERR(ctx->dh.soft_tfm)) {
+		pr_err("Failed to alloc dh tfm!\n");
+		return PTR_ERR(ctx->dh.soft_tfm);
+	}
 
-	return hpre_ctx_init(ctx, HPRE_V2_ALG_TYPE);
+	crypto_kpp_set_flags(ctx->dh.soft_tfm, crypto_kpp_get_flags(tfm));
+
+	reqsize = max(sizeof(struct hpre_asym_request) + hpre_align_pd(),
+		      sizeof(struct kpp_request) + crypto_kpp_reqsize(ctx->dh.soft_tfm));
+	kpp_set_reqsize(tfm, reqsize);
+
+	ret = hpre_ctx_init(ctx, HPRE_V2_ALG_TYPE);
+	if (ret && ret != -ENODEV) {
+		crypto_free_kpp(ctx->dh.soft_tfm);
+		return ret;
+	} else if (ret == -ENODEV) {
+		ctx->fallback = true;
+	}
+
+	return 0;
 }
 
 static void hpre_dh_exit_tfm(struct crypto_kpp *tfm)
@@ -769,6 +846,7 @@ static void hpre_dh_exit_tfm(struct crypto_kpp *tfm)
 	struct hpre_ctx *ctx = kpp_tfm_ctx(tfm);
 
 	hpre_dh_clear_ctx(ctx, true);
+	crypto_free_kpp(ctx->dh.soft_tfm);
 }
 
 static void hpre_rsa_drop_leading_zeros(const char **ptr, size_t *len)
@@ -808,9 +886,8 @@ static int hpre_rsa_enc(struct akcipher_request *req)
 	struct hpre_sqe *msg = &hpre_req->req;
 	int ret;
 
-	/* For 512 and 1536 bits key size, use soft tfm instead */
-	if (ctx->key_sz == HPRE_RSA_512BITS_KSZ ||
-	    ctx->key_sz == HPRE_RSA_1536BITS_KSZ) {
+	/* For unsupported key size and unavailable devices, use soft tfm instead */
+	if (ctx->fallback) {
 		akcipher_request_set_tfm(req, ctx->rsa.soft_tfm);
 		ret = crypto_akcipher_encrypt(req);
 		akcipher_request_set_tfm(req, tfm);
@@ -856,9 +933,8 @@ static int hpre_rsa_dec(struct akcipher_request *req)
 	struct hpre_sqe *msg = &hpre_req->req;
 	int ret;
 
-	/* For 512 and 1536 bits key size, use soft tfm instead */
-	if (ctx->key_sz == HPRE_RSA_512BITS_KSZ ||
-	    ctx->key_sz == HPRE_RSA_1536BITS_KSZ) {
+	/* For unsupported key size and unavailable devices, use soft tfm instead */
+	if (ctx->fallback) {
 		akcipher_request_set_tfm(req, ctx->rsa.soft_tfm);
 		ret = crypto_akcipher_decrypt(req);
 		akcipher_request_set_tfm(req, tfm);
@@ -912,8 +988,10 @@ static int hpre_rsa_set_n(struct hpre_ctx *ctx, const char *value,
 	ctx->key_sz = vlen;
 
 	/* if invalid key size provided, we use software tfm */
-	if (!hpre_rsa_key_size_is_support(ctx->key_sz))
+	if (!hpre_rsa_key_size_is_support(ctx->key_sz)) {
+		ctx->fallback = true;
 		return 0;
+	}
 
 	ctx->rsa.pubkey = dma_alloc_coherent(ctx->dev, vlen << 1,
 					     &ctx->rsa.dma_pubkey,
@@ -1048,6 +1126,9 @@ static void hpre_rsa_clear_ctx(struct hpre_ctx *ctx, bool is_clear_all)
 	unsigned int half_key_sz = ctx->key_sz >> 1;
 	struct device *dev = ctx->dev;
 
+	if (!ctx->qp)
+		return;
+
 	if (is_clear_all)
 		hisi_qm_stop_qp(ctx->qp);
 
@@ -1130,6 +1211,7 @@ static int hpre_rsa_setkey(struct hpre_ctx *ctx, const void *key,
 		goto free;
 	}
 
+	ctx->fallback = false;
 	return 0;
 
 free:
@@ -1147,6 +1229,9 @@ static int hpre_rsa_setpubkey(struct crypto_akcipher *tfm, const void *key,
 	if (ret)
 		return ret;
 
+	if (!ctx->qp)
+		return 0;
+
 	return hpre_rsa_setkey(ctx, key, keylen, false);
 }
 
@@ -1160,6 +1245,9 @@ static int hpre_rsa_setprivkey(struct crypto_akcipher *tfm, const void *key,
 	if (ret)
 		return ret;
 
+	if (!ctx->qp)
+		return 0;
+
 	return hpre_rsa_setkey(ctx, key, keylen, true);
 }
 
@@ -1167,9 +1255,8 @@ static unsigned int hpre_rsa_max_size(struct crypto_akcipher *tfm)
 {
 	struct hpre_ctx *ctx = akcipher_tfm_ctx(tfm);
 
-	/* For 512 and 1536 bits key size, use soft tfm instead */
-	if (ctx->key_sz == HPRE_RSA_512BITS_KSZ ||
-	    ctx->key_sz == HPRE_RSA_1536BITS_KSZ)
+	/* For unsupported key size and unavailable devices, use soft tfm instead */
+	if (ctx->fallback)
 		return crypto_akcipher_maxsize(ctx->rsa.soft_tfm);
 
 	return ctx->key_sz;
@@ -1190,10 +1277,14 @@ static int hpre_rsa_init_tfm(struct crypto_akcipher *tfm)
 				  hpre_align_pd());
 
 	ret = hpre_ctx_init(ctx, HPRE_V2_ALG_TYPE);
-	if (ret)
+	if (ret && ret != -ENODEV) {
 		crypto_free_akcipher(ctx->rsa.soft_tfm);
+		return ret;
+	} else if (ret == -ENODEV) {
+		ctx->fallback = true;
+	}
 
-	return ret;
+	return 0;
 }
 
 static void hpre_rsa_exit_tfm(struct crypto_akcipher *tfm)
@@ -1407,6 +1498,9 @@ static int hpre_ecdh_set_secret(struct crypto_kpp *tfm, const void *buf,
 	struct ecdh params;
 	int ret;
 
+	if (ctx->fallback)
+		return crypto_kpp_set_secret(ctx->ecdh.soft_tfm, buf, len);
+
 	if (crypto_ecdh_decode_key(buf, len, &params) < 0) {
 		dev_err(dev, "failed to decode ecdh key!\n");
 		return -EINVAL;
@@ -1637,23 +1731,82 @@ static int hpre_ecdh_compute_value(struct kpp_request *req)
 	return ret;
 }
 
+static int hpre_ecdh_generate_public_key(struct kpp_request *req)
+{
+	struct crypto_kpp *tfm = crypto_kpp_reqtfm(req);
+	struct hpre_ctx *ctx = kpp_tfm_ctx(tfm);
+	int ret;
+
+	if (ctx->fallback) {
+		kpp_request_set_tfm(req, ctx->ecdh.soft_tfm);
+		ret = crypto_kpp_generate_public_key(req);
+		kpp_request_set_tfm(req, tfm);
+		return ret;
+	}
+
+	return hpre_ecdh_compute_value(req);
+}
+
+static int hpre_ecdh_compute_shared_secret(struct kpp_request *req)
+{
+	struct crypto_kpp *tfm = crypto_kpp_reqtfm(req);
+	struct hpre_ctx *ctx = kpp_tfm_ctx(tfm);
+	int ret;
+
+	if (ctx->fallback) {
+		kpp_request_set_tfm(req, ctx->ecdh.soft_tfm);
+		ret = crypto_kpp_compute_shared_secret(req);
+		kpp_request_set_tfm(req, tfm);
+		return ret;
+	}
+
+	return hpre_ecdh_compute_value(req);
+}
+
 static unsigned int hpre_ecdh_max_size(struct crypto_kpp *tfm)
 {
 	struct hpre_ctx *ctx = kpp_tfm_ctx(tfm);
 
+	if (ctx->fallback)
+		return crypto_kpp_maxsize(ctx->ecdh.soft_tfm);
+
 	/* max size is the pub_key_size, include x and y */
 	return ctx->key_sz << 1;
 }
 
+static int hpre_ecdh_init_tfm(struct crypto_kpp *tfm)
+{
+	struct hpre_ctx *ctx = kpp_tfm_ctx(tfm);
+	const char *alg = kpp_alg_name(tfm);
+	int ret;
+
+	ret = hpre_ctx_init(ctx, HPRE_V3_ECC_ALG_TYPE);
+	if (!ret) {
+		kpp_set_reqsize(tfm, sizeof(struct hpre_asym_request) + hpre_align_pd());
+		return 0;
+	} else if (ret && ret != -ENODEV) {
+		return ret;
+	}
+
+	ctx->ecdh.soft_tfm = crypto_alloc_kpp(alg, 0, CRYPTO_ALG_NEED_FALLBACK);
+	if (IS_ERR(ctx->ecdh.soft_tfm)) {
+		pr_err("Failed to alloc %s tfm!\n", alg);
+		return PTR_ERR(ctx->ecdh.soft_tfm);
+	}
+
+	crypto_kpp_set_flags(ctx->ecdh.soft_tfm, crypto_kpp_get_flags(tfm));
+	ctx->fallback = true;
+
+	return 0;
+}
+
 static int hpre_ecdh_nist_p192_init_tfm(struct crypto_kpp *tfm)
 {
 	struct hpre_ctx *ctx = kpp_tfm_ctx(tfm);
 
 	ctx->curve_id = ECC_CURVE_NIST_P192;
 
-	kpp_set_reqsize(tfm, sizeof(struct hpre_asym_request) + hpre_align_pd());
-
-	return hpre_ctx_init(ctx, HPRE_V3_ECC_ALG_TYPE);
+	return hpre_ecdh_init_tfm(tfm);
 }
 
 static int hpre_ecdh_nist_p256_init_tfm(struct crypto_kpp *tfm)
@@ -1663,9 +1816,7 @@ static int hpre_ecdh_nist_p256_init_tfm(struct crypto_kpp *tfm)
 	ctx->curve_id = ECC_CURVE_NIST_P256;
 	ctx->enable_hpcore = 1;
 
-	kpp_set_reqsize(tfm, sizeof(struct hpre_asym_request) + hpre_align_pd());
-
-	return hpre_ctx_init(ctx, HPRE_V3_ECC_ALG_TYPE);
+	return hpre_ecdh_init_tfm(tfm);
 }
 
 static int hpre_ecdh_nist_p384_init_tfm(struct crypto_kpp *tfm)
@@ -1674,15 +1825,18 @@ static int hpre_ecdh_nist_p384_init_tfm(struct crypto_kpp *tfm)
 
 	ctx->curve_id = ECC_CURVE_NIST_P384;
 
-	kpp_set_reqsize(tfm, sizeof(struct hpre_asym_request) + hpre_align_pd());
-
-	return hpre_ctx_init(ctx, HPRE_V3_ECC_ALG_TYPE);
+	return hpre_ecdh_init_tfm(tfm);
 }
 
 static void hpre_ecdh_exit_tfm(struct crypto_kpp *tfm)
 {
 	struct hpre_ctx *ctx = kpp_tfm_ctx(tfm);
 
+	if (ctx->fallback) {
+		crypto_free_kpp(ctx->ecdh.soft_tfm);
+		return;
+	}
+
 	hpre_ecc_clear_ctx(ctx, true, true);
 }
 
@@ -1748,6 +1902,9 @@ static int hpre_curve25519_set_secret(struct crypto_kpp *tfm, const void *buf,
 	struct device *dev = ctx->dev;
 	int ret = -EINVAL;
 
+	if (ctx->fallback)
+		return crypto_kpp_set_secret(ctx->curve25519.soft_tfm, buf, len);
+
 	if (len != CURVE25519_KEY_SIZE ||
 	    !crypto_memneq(buf, curve25519_null_point, CURVE25519_KEY_SIZE)) {
 		dev_err(dev, "key is null or key len is not 32bytes!\n");
@@ -1993,26 +2150,83 @@ static int hpre_curve25519_compute_value(struct kpp_request *req)
 	return ret;
 }
 
+static int hpre_curve25519_generate_public_key(struct kpp_request *req)
+{
+	struct crypto_kpp *tfm = crypto_kpp_reqtfm(req);
+	struct hpre_ctx *ctx = kpp_tfm_ctx(tfm);
+	int ret;
+
+	if (ctx->fallback) {
+		kpp_request_set_tfm(req, ctx->curve25519.soft_tfm);
+		ret = crypto_kpp_generate_public_key(req);
+		kpp_request_set_tfm(req, tfm);
+		return ret;
+	}
+
+	return hpre_curve25519_compute_value(req);
+}
+
+static int hpre_curve25519_compute_shared_secret(struct kpp_request *req)
+{
+	struct crypto_kpp *tfm = crypto_kpp_reqtfm(req);
+	struct hpre_ctx *ctx = kpp_tfm_ctx(tfm);
+	int ret;
+
+	if (ctx->fallback) {
+		kpp_request_set_tfm(req, ctx->curve25519.soft_tfm);
+		ret = crypto_kpp_compute_shared_secret(req);
+		kpp_request_set_tfm(req, tfm);
+		return ret;
+	}
+
+	return hpre_curve25519_compute_value(req);
+}
+
 static unsigned int hpre_curve25519_max_size(struct crypto_kpp *tfm)
 {
 	struct hpre_ctx *ctx = kpp_tfm_ctx(tfm);
 
+	if (ctx->fallback)
+		return crypto_kpp_maxsize(ctx->curve25519.soft_tfm);
+
 	return ctx->key_sz;
 }
 
 static int hpre_curve25519_init_tfm(struct crypto_kpp *tfm)
 {
 	struct hpre_ctx *ctx = kpp_tfm_ctx(tfm);
+	const char *alg = kpp_alg_name(tfm);
+	int ret;
+
+	ret = hpre_ctx_init(ctx, HPRE_V3_ECC_ALG_TYPE);
+	if (!ret) {
+		kpp_set_reqsize(tfm, sizeof(struct hpre_asym_request) + hpre_align_pd());
+		return 0;
+	} else if (ret && ret != -ENODEV) {
+		return ret;
+	}
+
+	ctx->curve25519.soft_tfm = crypto_alloc_kpp(alg, 0, CRYPTO_ALG_NEED_FALLBACK);
+	if (IS_ERR(ctx->curve25519.soft_tfm)) {
+		pr_err("Failed to alloc curve25519 tfm!\n");
+		return PTR_ERR(ctx->curve25519.soft_tfm);
+	}
 
-	kpp_set_reqsize(tfm, sizeof(struct hpre_asym_request) + hpre_align_pd());
+	crypto_kpp_set_flags(ctx->curve25519.soft_tfm, crypto_kpp_get_flags(tfm));
+	ctx->fallback = true;
 
-	return hpre_ctx_init(ctx, HPRE_V3_ECC_ALG_TYPE);
+	return 0;
 }
 
 static void hpre_curve25519_exit_tfm(struct crypto_kpp *tfm)
 {
 	struct hpre_ctx *ctx = kpp_tfm_ctx(tfm);
 
+	if (ctx->fallback) {
+		crypto_free_kpp(ctx->curve25519.soft_tfm);
+		return;
+	}
+
 	hpre_ecc_clear_ctx(ctx, true, false);
 }
 
@@ -2030,13 +2244,14 @@ static struct akcipher_alg rsa = {
 		.cra_name = "rsa",
 		.cra_driver_name = "hpre-rsa",
 		.cra_module = THIS_MODULE,
+		.cra_flags = CRYPTO_ALG_NEED_FALLBACK,
 	},
 };
 
 static struct kpp_alg dh = {
 	.set_secret = hpre_dh_set_secret,
-	.generate_public_key = hpre_dh_compute_value,
-	.compute_shared_secret = hpre_dh_compute_value,
+	.generate_public_key = hpre_dh_generate_public_key,
+	.compute_shared_secret = hpre_dh_compute_shared_secret,
 	.max_size = hpre_dh_max_size,
 	.init = hpre_dh_init_tfm,
 	.exit = hpre_dh_exit_tfm,
@@ -2046,14 +2261,15 @@ static struct kpp_alg dh = {
 		.cra_name = "dh",
 		.cra_driver_name = "hpre-dh",
 		.cra_module = THIS_MODULE,
+		.cra_flags = CRYPTO_ALG_NEED_FALLBACK,
 	},
 };
 
 static struct kpp_alg ecdh_curves[] = {
 	{
 		.set_secret = hpre_ecdh_set_secret,
-		.generate_public_key = hpre_ecdh_compute_value,
-		.compute_shared_secret = hpre_ecdh_compute_value,
+		.generate_public_key = hpre_ecdh_generate_public_key,
+		.compute_shared_secret = hpre_ecdh_compute_shared_secret,
 		.max_size = hpre_ecdh_max_size,
 		.init = hpre_ecdh_nist_p192_init_tfm,
 		.exit = hpre_ecdh_exit_tfm,
@@ -2063,11 +2279,12 @@ static struct kpp_alg ecdh_curves[] = {
 			.cra_name = "ecdh-nist-p192",
 			.cra_driver_name = "hpre-ecdh-nist-p192",
 			.cra_module = THIS_MODULE,
+			.cra_flags = CRYPTO_ALG_NEED_FALLBACK,
 		},
 	}, {
 		.set_secret = hpre_ecdh_set_secret,
-		.generate_public_key = hpre_ecdh_compute_value,
-		.compute_shared_secret = hpre_ecdh_compute_value,
+		.generate_public_key = hpre_ecdh_generate_public_key,
+		.compute_shared_secret = hpre_ecdh_compute_shared_secret,
 		.max_size = hpre_ecdh_max_size,
 		.init = hpre_ecdh_nist_p256_init_tfm,
 		.exit = hpre_ecdh_exit_tfm,
@@ -2077,11 +2294,12 @@ static struct kpp_alg ecdh_curves[] = {
 			.cra_name = "ecdh-nist-p256",
 			.cra_driver_name = "hpre-ecdh-nist-p256",
 			.cra_module = THIS_MODULE,
+			.cra_flags = CRYPTO_ALG_NEED_FALLBACK,
 		},
 	}, {
 		.set_secret = hpre_ecdh_set_secret,
-		.generate_public_key = hpre_ecdh_compute_value,
-		.compute_shared_secret = hpre_ecdh_compute_value,
+		.generate_public_key = hpre_ecdh_generate_public_key,
+		.compute_shared_secret = hpre_ecdh_compute_shared_secret,
 		.max_size = hpre_ecdh_max_size,
 		.init = hpre_ecdh_nist_p384_init_tfm,
 		.exit = hpre_ecdh_exit_tfm,
@@ -2091,14 +2309,15 @@ static struct kpp_alg ecdh_curves[] = {
 			.cra_name = "ecdh-nist-p384",
 			.cra_driver_name = "hpre-ecdh-nist-p384",
 			.cra_module = THIS_MODULE,
+			.cra_flags = CRYPTO_ALG_NEED_FALLBACK,
 		},
 	}
 };
 
 static struct kpp_alg curve25519_alg = {
 	.set_secret = hpre_curve25519_set_secret,
-	.generate_public_key = hpre_curve25519_compute_value,
-	.compute_shared_secret = hpre_curve25519_compute_value,
+	.generate_public_key = hpre_curve25519_generate_public_key,
+	.compute_shared_secret = hpre_curve25519_compute_shared_secret,
 	.max_size = hpre_curve25519_max_size,
 	.init = hpre_curve25519_init_tfm,
 	.exit = hpre_curve25519_exit_tfm,
@@ -2108,6 +2327,7 @@ static struct kpp_alg curve25519_alg = {
 		.cra_name = "curve25519",
 		.cra_driver_name = "hpre-curve25519",
 		.cra_module = THIS_MODULE,
+		.cra_flags = CRYPTO_ALG_NEED_FALLBACK,
 	},
 };
 
diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index 2e4ee7ecfdfb..8d45febb98dd 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -3561,8 +3561,8 @@ int hisi_qm_alloc_qps_node(struct hisi_qm_list *qm_list, int qp_num,
 
 	mutex_unlock(&qm_list->lock);
 	if (ret)
-		pr_info("Failed to create qps, node[%d], alg[%u], qp[%d]!\n",
-			node, alg_type, qp_num);
+		pr_info_ratelimited("Too busy to create qps, node[%d], alg[%u], qp[%d]!\n",
+				     node, alg_type, qp_num);
 
 err:
 	free_list(&head);
-- 
2.33.0

