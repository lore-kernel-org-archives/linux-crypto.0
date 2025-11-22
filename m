Received: from canpmsgout06.his.huawei.com (canpmsgout06.his.huawei.com [113.46.200.221])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22EAC2F49FD;
	Sat, 22 Nov 2025 07:49:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.221
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763797773; cv=none; b=D2mLgSISKttE+DJwmd2OpCwMptUqmjy7eRVyonyIQaS5ylkd8neVIJ/03Z0LXYJTc4Br367J3ViwATPS6ORh3wubdTfmzgCO4EIugzuGLvGw+l7BYePYqncwFkhdMS4ntQw6xfcgZ1Q1JLNKfF7SLO7gUPZL5RLTwNsB2YhqAhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763797773; c=relaxed/simple;
	bh=yr0ZXn13CINwy9rHCCcnJPrmodqcDnw4nR1KXqK8+6s=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UEe1A+HjHKsCjO+AwUwmk/wqLo4wBRaHvuUGp01g+U69LwE76JiQjzWripIO2uRwB76lcFQOF62e+MQcEp33PVZNjQTToI+xtRiRTF3H0eVFJfNstHj93LK6jo0wGiJceF7ixNM4e/1TWsLE69MLwfgdXl4kURZo6vAlFuqvvgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=WsgJUcHU; arc=none smtp.client-ip=113.46.200.221
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="WsgJUcHU"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=RvGsiRPrcfloe4O4c5Ztr1+tn4vf0Hnpkkn8mbqVKJ8=;
	b=WsgJUcHUTKBLjbVBIpH+Ogkhpa1psl+AN5TkKvNROYsSoXH0yoywOJux9+1WMmjhm5GDG//VV
	/KWdaEZ1K9UVMcZc67bJMs6hFePtqfX9zQbIVhuoW+29PQCJ/sAZvzZCl3QLUcE9voAvUfQj7Lb
	IfPnromUBOTQfKDscA07A44=
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by canpmsgout06.his.huawei.com (SkyGuard) with ESMTPS id 4dD41j1fNPzRhRN;
	Sat, 22 Nov 2025 15:47:37 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id 8F9D71401F2;
	Sat, 22 Nov 2025 15:49:22 +0800 (CST)
Received: from kwepemq200001.china.huawei.com (7.202.195.16) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 22 Nov 2025 15:49:22 +0800
Received: from localhost.huawei.com (10.90.31.46) by
 kwepemq200001.china.huawei.com (7.202.195.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 22 Nov 2025 15:49:21 +0800
From: Chenghai Huang <huangchenghai2@huawei.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<fanghao11@huawei.com>, <liulongfang@huawei.com>, <qianweili@huawei.com>,
	<linwenkai6@hisilicon.com>, <wangzhou1@hisilicon.com>, <lizhi206@huawei.com>,
	<taoqi10@huawei.com>
Subject: [PATCH v3 10/11] crypto: hisilicon/hpre - support the hpre algorithm fallback
Date: Sat, 22 Nov 2025 15:49:15 +0800
Message-ID: <20251122074916.2793717-11-huangchenghai2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20251122074916.2793717-1-huangchenghai2@huawei.com>
References: <20251122074916.2793717-1-huangchenghai2@huawei.com>
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

When all hardware queues are busy and no shareable queue,
new processes fail to apply for queues. To avoid affecting
tasks, support fallback mechanism when hardware queues are
unavailable.

HPRE driver supports DH algorithm, limited to prime numbers up to 4K.
It supports prime numbers larger than 4K via fallback mechanism.

Fixes: 05e7b906aa7c ("crypto: hisilicon/hpre - add 'ECDH' algorithm")
Signed-off-by: Weili Qian <qianweili@huawei.com>
Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
---
 drivers/crypto/hisilicon/hpre/hpre_crypto.c | 238 ++++++++++++++++----
 1 file changed, 199 insertions(+), 39 deletions(-)

diff --git a/drivers/crypto/hisilicon/hpre/hpre_crypto.c b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
index f410e610eaba..839c1f677143 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_crypto.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
@@ -93,6 +93,7 @@ struct hpre_dh_ctx {
 
 	char *g; /* m */
 	dma_addr_t dma_g;
+	struct crypto_kpp *soft_tfm;
 };
 
 struct hpre_ecdh_ctx {
@@ -103,6 +104,7 @@ struct hpre_ecdh_ctx {
 	/* low address: x->y */
 	unsigned char *g;
 	dma_addr_t dma_g;
+	struct crypto_kpp *soft_tfm;
 };
 
 struct hpre_ctx {
@@ -120,6 +122,7 @@ struct hpre_ctx {
 	unsigned int curve_id;
 	/* for high performance core */
 	u8 enable_hpcore;
+	bool fallback;
 };
 
 struct hpre_asym_request {
@@ -382,8 +385,10 @@ static int hpre_ctx_init(struct hpre_ctx *ctx, u8 type)
 	struct hpre *hpre;
 
 	qp = hpre_create_qp(type);
-	if (!qp)
+	if (!qp) {
+		ctx->qp = NULL;
 		return -ENODEV;
+	}
 
 	qp->req_cb = hpre_alg_cb;
 	ctx->qp = qp;
@@ -509,6 +514,48 @@ static int hpre_dh_compute_value(struct kpp_request *req)
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
@@ -535,13 +582,6 @@ static int hpre_dh_set_params(struct hpre_ctx *ctx, struct dh *params)
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
@@ -574,6 +614,9 @@ static void hpre_dh_clear_ctx(struct hpre_ctx *ctx, bool is_clear_all)
 	struct device *dev = ctx->dev;
 	unsigned int sz = ctx->key_sz;
 
+	if (!ctx->qp)
+		return;
+
 	if (ctx->dh.g) {
 		dma_free_coherent(dev, sz, ctx->dh.g, ctx->dh.dma_g);
 		ctx->dh.g = NULL;
@@ -599,6 +642,13 @@ static int hpre_dh_set_secret(struct crypto_kpp *tfm, const void *buf,
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
 
@@ -609,27 +659,55 @@ static int hpre_dh_set_secret(struct crypto_kpp *tfm, const void *buf,
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
+
+	ctx->dh.soft_tfm = crypto_alloc_kpp(alg, 0, CRYPTO_ALG_NEED_FALLBACK);
+	if (IS_ERR(ctx->dh.soft_tfm)) {
+		pr_err("Failed to alloc dh tfm!\n");
+		return PTR_ERR(ctx->dh.soft_tfm);
+	}
+
+	crypto_kpp_set_flags(ctx->dh.soft_tfm, crypto_kpp_get_flags(tfm));
+
+	reqsize = max(sizeof(struct hpre_asym_request) + hpre_align_pd(),
+		      sizeof(struct kpp_request) + crypto_kpp_reqsize(ctx->dh.soft_tfm));
+	kpp_set_reqsize(tfm, reqsize);
 
-	kpp_set_reqsize(tfm, sizeof(struct hpre_asym_request) + hpre_align_pd());
+	ret = hpre_ctx_init(ctx, HPRE_V2_ALG_TYPE);
+	if (ret && ret != -ENODEV) {
+		crypto_free_kpp(ctx->dh.soft_tfm);
+		return ret;
+	} else if (ret == -ENODEV) {
+		ctx->fallback = true;
+	}
 
-	return hpre_ctx_init(ctx, HPRE_V2_ALG_TYPE);
+	return 0;
 }
 
 static void hpre_dh_exit_tfm(struct crypto_kpp *tfm)
@@ -637,6 +715,7 @@ static void hpre_dh_exit_tfm(struct crypto_kpp *tfm)
 	struct hpre_ctx *ctx = kpp_tfm_ctx(tfm);
 
 	hpre_dh_clear_ctx(ctx, true);
+	crypto_free_kpp(ctx->dh.soft_tfm);
 }
 
 static void hpre_rsa_drop_leading_zeros(const char **ptr, size_t *len)
@@ -676,9 +755,8 @@ static int hpre_rsa_enc(struct akcipher_request *req)
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
@@ -723,9 +801,8 @@ static int hpre_rsa_dec(struct akcipher_request *req)
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
@@ -778,8 +855,10 @@ static int hpre_rsa_set_n(struct hpre_ctx *ctx, const char *value,
 	ctx->key_sz = vlen;
 
 	/* if invalid key size provided, we use software tfm */
-	if (!hpre_rsa_key_size_is_support(ctx->key_sz))
+	if (!hpre_rsa_key_size_is_support(ctx->key_sz)) {
+		ctx->fallback = true;
 		return 0;
+	}
 
 	ctx->rsa.pubkey = dma_alloc_coherent(ctx->dev, vlen << 1,
 					     &ctx->rsa.dma_pubkey,
@@ -914,6 +993,9 @@ static void hpre_rsa_clear_ctx(struct hpre_ctx *ctx, bool is_clear_all)
 	unsigned int half_key_sz = ctx->key_sz >> 1;
 	struct device *dev = ctx->dev;
 
+	if (!ctx->qp)
+		return;
+
 	if (ctx->rsa.pubkey) {
 		dma_free_coherent(dev, ctx->key_sz << 1,
 				  ctx->rsa.pubkey, ctx->rsa.dma_pubkey);
@@ -993,6 +1075,7 @@ static int hpre_rsa_setkey(struct hpre_ctx *ctx, const void *key,
 		goto free;
 	}
 
+	ctx->fallback = false;
 	return 0;
 
 free:
@@ -1010,6 +1093,9 @@ static int hpre_rsa_setpubkey(struct crypto_akcipher *tfm, const void *key,
 	if (ret)
 		return ret;
 
+	if (!ctx->qp)
+		return 0;
+
 	return hpre_rsa_setkey(ctx, key, keylen, false);
 }
 
@@ -1023,6 +1109,9 @@ static int hpre_rsa_setprivkey(struct crypto_akcipher *tfm, const void *key,
 	if (ret)
 		return ret;
 
+	if (!ctx->qp)
+		return 0;
+
 	return hpre_rsa_setkey(ctx, key, keylen, true);
 }
 
@@ -1030,9 +1119,8 @@ static unsigned int hpre_rsa_max_size(struct crypto_akcipher *tfm)
 {
 	struct hpre_ctx *ctx = akcipher_tfm_ctx(tfm);
 
-	/* For 512 and 1536 bits key size, use soft tfm instead */
-	if (ctx->key_sz == HPRE_RSA_512BITS_KSZ ||
-	    ctx->key_sz == HPRE_RSA_1536BITS_KSZ)
+	/* For unsupported key size and unavailable devices, use soft tfm instead */
+	if (ctx->fallback)
 		return crypto_akcipher_maxsize(ctx->rsa.soft_tfm);
 
 	return ctx->key_sz;
@@ -1053,10 +1141,14 @@ static int hpre_rsa_init_tfm(struct crypto_akcipher *tfm)
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
@@ -1260,6 +1352,9 @@ static int hpre_ecdh_set_secret(struct crypto_kpp *tfm, const void *buf,
 	struct ecdh params;
 	int ret;
 
+	if (ctx->fallback)
+		return crypto_kpp_set_secret(ctx->ecdh.soft_tfm, buf, len);
+
 	if (crypto_ecdh_decode_key(buf, len, &params) < 0) {
 		dev_err(dev, "failed to decode ecdh key!\n");
 		return -EINVAL;
@@ -1485,23 +1580,82 @@ static int hpre_ecdh_compute_value(struct kpp_request *req)
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
@@ -1511,9 +1665,7 @@ static int hpre_ecdh_nist_p256_init_tfm(struct crypto_kpp *tfm)
 	ctx->curve_id = ECC_CURVE_NIST_P256;
 	ctx->enable_hpcore = 1;
 
-	kpp_set_reqsize(tfm, sizeof(struct hpre_asym_request) + hpre_align_pd());
-
-	return hpre_ctx_init(ctx, HPRE_V3_ECC_ALG_TYPE);
+	return hpre_ecdh_init_tfm(tfm);
 }
 
 static int hpre_ecdh_nist_p384_init_tfm(struct crypto_kpp *tfm)
@@ -1522,15 +1674,18 @@ static int hpre_ecdh_nist_p384_init_tfm(struct crypto_kpp *tfm)
 
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
 	hpre_ecc_clear_ctx(ctx, true);
 }
 
@@ -1548,13 +1703,14 @@ static struct akcipher_alg rsa = {
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
@@ -1564,14 +1720,15 @@ static struct kpp_alg dh = {
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
@@ -1581,11 +1738,12 @@ static struct kpp_alg ecdh_curves[] = {
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
@@ -1595,11 +1753,12 @@ static struct kpp_alg ecdh_curves[] = {
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
@@ -1609,6 +1768,7 @@ static struct kpp_alg ecdh_curves[] = {
 			.cra_name = "ecdh-nist-p384",
 			.cra_driver_name = "hpre-ecdh-nist-p384",
 			.cra_module = THIS_MODULE,
+			.cra_flags = CRYPTO_ALG_NEED_FALLBACK,
 		},
 	}
 };
-- 
2.33.0

