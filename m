Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D2A227FD59;
	Sat,  6 Sep 2025 21:36:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757194617; cv=none; b=qIY0gWgI/yKFxEqYptjonFSYORRDOUYi7IybYubqkEHqTCeaTsfJa2jpczawe0s8TacwuTGIn+Oa+CnVMnmysxDKAScurpv7VZ72i/drQ4NYVLaabH7SkXD8nFkISdYpzyP+F7cL8iBbPTscxrBaUwZuLV7Yzii2wHMI0I8f2d0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757194617; c=relaxed/simple;
	bh=CFS9vz2j53OJuYoHCdlJXzd7e3S1AiCj+N0kF7V3qPc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GvJb/Hku2SBN8LNgphKb4TP6Z6OE0bMRfFVMJvUe3j3cQiXYGItKmO+ivjgcqyTHmsDmhvl4Y+08INERMvd8VtzHAVYb0lpHMisLnz2JXgLQXux5pwnWNYJ9UvhLIy9V7SVb0qwY0/vUWZ/WBuNWvxul3eo8u5H1YhzGjZTZV28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Zs5puN8p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Zs5puN8p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CE7CC4CEFA;
	Sat,  6 Sep 2025 21:36:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757194617;
	bh=CFS9vz2j53OJuYoHCdlJXzd7e3S1AiCj+N0kF7V3qPc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zs5puN8pqaOPgtrBfVXKlTfrEhUBE756cy4wCcnvWE7esCjF58CBQe7T9DGs6C+FN
	 NRjphBZ3jEA6uG7FN2xW/fJsPigCNpuARrU0qje0OiJBjicIhy0zG6yBxEly8GkNkD
	 AosRBrS3mviIH/RVdqWKomqs5vkBOXQAcfOgzYqyzKcS+i1fhFwXjKIVQhQi1O52dy
	 HgMkUyC6d6jfqRFfPbkXxy9nasSFJ810CUYgOhHlpBbRERqMXTg9ci01xNnqSoCpBz
	 67c2aSS2y7iu57N4Wpe3Qwkphkpzmydtp0wJ+EB7F9oBI7RtCT6i5qvqfzGgKv2XfM
	 eXQFYEQUK3g1Q==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Zhiqi Song <songzhiqi1@huawei.com>,
	Longfang Liu <liulongfang@huawei.com>,
	x86@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v2 01/12] crypto: hisilicon/hpre - Remove unused curve25519 kpp support
Date: Sat,  6 Sep 2025 14:35:12 -0700
Message-ID: <20250906213523.84915-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250906213523.84915-1-ebiggers@kernel.org>
References: <20250906213523.84915-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Curve25519 is used only via the library API, not the crypto_kpp API.  In
preparation for removing the unused crypto_kpp API for Curve25519,
remove the unused "hpre-curve25519" kpp algorithm.

Cc: Longfang Liu <liulongfang@huawei.com>
Cc: Zhiqi Song <songzhiqi1@huawei.com>
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 drivers/crypto/hisilicon/Kconfig            |   1 -
 drivers/crypto/hisilicon/hpre/hpre_crypto.c | 403 +-------------------
 2 files changed, 4 insertions(+), 400 deletions(-)

diff --git a/drivers/crypto/hisilicon/Kconfig b/drivers/crypto/hisilicon/Kconfig
index 4137a8bf131f0..4835bdebdbb38 100644
--- a/drivers/crypto/hisilicon/Kconfig
+++ b/drivers/crypto/hisilicon/Kconfig
@@ -67,11 +67,10 @@ config CRYPTO_DEV_HISI_HPRE
 	depends on ARM64 || (COMPILE_TEST && 64BIT)
 	depends on ACPI
 	select CRYPTO_DEV_HISI_QM
 	select CRYPTO_DH
 	select CRYPTO_RSA
-	select CRYPTO_CURVE25519
 	select CRYPTO_ECDH
 	help
 	  Support for HiSilicon HPRE(High Performance RSA Engine)
 	  accelerator, which can accelerate RSA and DH algorithms.
 
diff --git a/drivers/crypto/hisilicon/hpre/hpre_crypto.c b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
index 1550c3818383a..21ccf879f70c5 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_crypto.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
@@ -1,9 +1,8 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright (c) 2019 HiSilicon Limited. */
 #include <crypto/akcipher.h>
-#include <crypto/curve25519.h>
 #include <crypto/dh.h>
 #include <crypto/ecc_curve.h>
 #include <crypto/ecdh.h>
 #include <crypto/rng.h>
 #include <crypto/internal/akcipher.h>
@@ -104,20 +103,10 @@ struct hpre_ecdh_ctx {
 	/* low address: x->y */
 	unsigned char *g;
 	dma_addr_t dma_g;
 };
 
-struct hpre_curve25519_ctx {
-	/* low address: p->a->k */
-	unsigned char *p;
-	dma_addr_t dma_p;
-
-	/* gx coordinate */
-	unsigned char *g;
-	dma_addr_t dma_g;
-};
-
 struct hpre_ctx {
 	struct hisi_qp *qp;
 	struct device *dev;
 	struct hpre_asym_request **req_list;
 	struct hpre *hpre;
@@ -127,11 +116,10 @@ struct hpre_ctx {
 	struct idr req_idr;
 	union {
 		struct hpre_rsa_ctx rsa;
 		struct hpre_dh_ctx dh;
 		struct hpre_ecdh_ctx ecdh;
-		struct hpre_curve25519_ctx curve25519;
 	};
 	/* for ecc algorithms */
 	unsigned int curve_id;
 	/* for high performance core */
 	u8 enable_hpcore;
@@ -144,11 +132,10 @@ struct hpre_asym_request {
 	struct hpre_ctx *ctx;
 	union {
 		struct akcipher_request *rsa;
 		struct kpp_request *dh;
 		struct kpp_request *ecdh;
-		struct kpp_request *curve25519;
 	} areq;
 	int err;
 	int req_id;
 	hpre_cb cb;
 	struct timespec64 req_time;
@@ -1212,31 +1199,24 @@ static void hpre_key_to_big_end(u8 *data, int len)
 		j = len - i - 1;
 		swap(data[j], data[i]);
 	}
 }
 
-static void hpre_ecc_clear_ctx(struct hpre_ctx *ctx, bool is_clear_all,
-			       bool is_ecdh)
+static void hpre_ecc_clear_ctx(struct hpre_ctx *ctx, bool is_clear_all)
 {
 	struct device *dev = ctx->dev;
 	unsigned int sz = ctx->key_sz;
 	unsigned int shift = sz << 1;
 
 	if (is_clear_all)
 		hisi_qm_stop_qp(ctx->qp);
 
-	if (is_ecdh && ctx->ecdh.p) {
+	if (ctx->ecdh.p) {
 		/* ecdh: p->a->k->b */
 		memzero_explicit(ctx->ecdh.p + shift, sz);
 		dma_free_coherent(dev, sz << 3, ctx->ecdh.p, ctx->ecdh.dma_p);
 		ctx->ecdh.p = NULL;
-	} else if (!is_ecdh && ctx->curve25519.p) {
-		/* curve25519: p->a->k */
-		memzero_explicit(ctx->curve25519.p + shift, sz);
-		dma_free_coherent(dev, sz << 2, ctx->curve25519.p,
-				  ctx->curve25519.dma_p);
-		ctx->curve25519.p = NULL;
 	}
 
 	hpre_ctx_clear(ctx, is_clear_all);
 }
 
@@ -1430,11 +1410,11 @@ static int hpre_ecdh_set_secret(struct crypto_kpp *tfm, const void *buf,
 	if (hpre_key_is_zero(params.key, params.key_size)) {
 		dev_err(dev, "Invalid hpre key!\n");
 		return -EINVAL;
 	}
 
-	hpre_ecc_clear_ctx(ctx, false, true);
+	hpre_ecc_clear_ctx(ctx, false);
 
 	ret = hpre_ecdh_set_param(ctx, &params);
 	if (ret < 0) {
 		dev_err(dev, "failed to set hpre param, ret = %d!\n", ret);
 		return ret;
@@ -1681,341 +1661,11 @@ static int hpre_ecdh_nist_p384_init_tfm(struct crypto_kpp *tfm)
 
 static void hpre_ecdh_exit_tfm(struct crypto_kpp *tfm)
 {
 	struct hpre_ctx *ctx = kpp_tfm_ctx(tfm);
 
-	hpre_ecc_clear_ctx(ctx, true, true);
-}
-
-static void hpre_curve25519_fill_curve(struct hpre_ctx *ctx, const void *buf,
-				       unsigned int len)
-{
-	u8 secret[CURVE25519_KEY_SIZE] = { 0 };
-	unsigned int sz = ctx->key_sz;
-	const struct ecc_curve *curve;
-	unsigned int shift = sz << 1;
-	void *p;
-
-	/*
-	 * The key from 'buf' is in little-endian, we should preprocess it as
-	 * the description in rfc7748: "k[0] &= 248, k[31] &= 127, k[31] |= 64",
-	 * then convert it to big endian. Only in this way, the result can be
-	 * the same as the software curve-25519 that exists in crypto.
-	 */
-	memcpy(secret, buf, len);
-	curve25519_clamp_secret(secret);
-	hpre_key_to_big_end(secret, CURVE25519_KEY_SIZE);
-
-	p = ctx->curve25519.p + sz - len;
-
-	curve = ecc_get_curve25519();
-
-	/* fill curve parameters */
-	fill_curve_param(p, curve->p, len, curve->g.ndigits);
-	fill_curve_param(p + sz, curve->a, len, curve->g.ndigits);
-	memcpy(p + shift, secret, len);
-	fill_curve_param(p + shift + sz, curve->g.x, len, curve->g.ndigits);
-	memzero_explicit(secret, CURVE25519_KEY_SIZE);
-}
-
-static int hpre_curve25519_set_param(struct hpre_ctx *ctx, const void *buf,
-				     unsigned int len)
-{
-	struct device *dev = ctx->dev;
-	unsigned int sz = ctx->key_sz;
-	unsigned int shift = sz << 1;
-
-	/* p->a->k->gx */
-	if (!ctx->curve25519.p) {
-		ctx->curve25519.p = dma_alloc_coherent(dev, sz << 2,
-						       &ctx->curve25519.dma_p,
-						       GFP_KERNEL);
-		if (!ctx->curve25519.p)
-			return -ENOMEM;
-	}
-
-	ctx->curve25519.g = ctx->curve25519.p + shift + sz;
-	ctx->curve25519.dma_g = ctx->curve25519.dma_p + shift + sz;
-
-	hpre_curve25519_fill_curve(ctx, buf, len);
-
-	return 0;
-}
-
-static int hpre_curve25519_set_secret(struct crypto_kpp *tfm, const void *buf,
-				      unsigned int len)
-{
-	struct hpre_ctx *ctx = kpp_tfm_ctx(tfm);
-	struct device *dev = ctx->dev;
-	int ret = -EINVAL;
-
-	if (len != CURVE25519_KEY_SIZE ||
-	    !crypto_memneq(buf, curve25519_null_point, CURVE25519_KEY_SIZE)) {
-		dev_err(dev, "key is null or key len is not 32bytes!\n");
-		return ret;
-	}
-
-	/* Free old secret if any */
-	hpre_ecc_clear_ctx(ctx, false, false);
-
-	ctx->key_sz = CURVE25519_KEY_SIZE;
-	ret = hpre_curve25519_set_param(ctx, buf, CURVE25519_KEY_SIZE);
-	if (ret) {
-		dev_err(dev, "failed to set curve25519 param, ret = %d!\n", ret);
-		hpre_ecc_clear_ctx(ctx, false, false);
-		return ret;
-	}
-
-	return 0;
-}
-
-static void hpre_curve25519_hw_data_clr_all(struct hpre_ctx *ctx,
-					    struct hpre_asym_request *req,
-					    struct scatterlist *dst,
-					    struct scatterlist *src)
-{
-	struct device *dev = ctx->dev;
-	struct hpre_sqe *sqe = &req->req;
-	dma_addr_t dma;
-
-	dma = le64_to_cpu(sqe->in);
-	if (unlikely(dma_mapping_error(dev, dma)))
-		return;
-
-	if (src && req->src)
-		dma_free_coherent(dev, ctx->key_sz, req->src, dma);
-
-	dma = le64_to_cpu(sqe->out);
-	if (unlikely(dma_mapping_error(dev, dma)))
-		return;
-
-	if (req->dst)
-		dma_free_coherent(dev, ctx->key_sz, req->dst, dma);
-	if (dst)
-		dma_unmap_single(dev, dma, ctx->key_sz, DMA_FROM_DEVICE);
-}
-
-static void hpre_curve25519_cb(struct hpre_ctx *ctx, void *resp)
-{
-	struct hpre_dfx *dfx = ctx->hpre->debug.dfx;
-	struct hpre_asym_request *req = NULL;
-	struct kpp_request *areq;
-	u64 overtime_thrhld;
-	int ret;
-
-	ret = hpre_alg_res_post_hf(ctx, resp, (void **)&req);
-	areq = req->areq.curve25519;
-	areq->dst_len = ctx->key_sz;
-
-	overtime_thrhld = atomic64_read(&dfx[HPRE_OVERTIME_THRHLD].value);
-	if (overtime_thrhld && hpre_is_bd_timeout(req, overtime_thrhld))
-		atomic64_inc(&dfx[HPRE_OVER_THRHLD_CNT].value);
-
-	/* Do unmap before data processing */
-	hpre_curve25519_hw_data_clr_all(ctx, req, areq->dst, areq->src);
-
-	hpre_key_to_big_end(sg_virt(areq->dst), CURVE25519_KEY_SIZE);
-
-	kpp_request_complete(areq, ret);
-
-	atomic64_inc(&dfx[HPRE_RECV_CNT].value);
-}
-
-static int hpre_curve25519_msg_request_set(struct hpre_ctx *ctx,
-					   struct kpp_request *req)
-{
-	struct hpre_asym_request *h_req;
-	struct hpre_sqe *msg;
-	int req_id;
-	void *tmp;
-
-	if (unlikely(req->dst_len < ctx->key_sz)) {
-		req->dst_len = ctx->key_sz;
-		return -EINVAL;
-	}
-
-	tmp = kpp_request_ctx(req);
-	h_req = PTR_ALIGN(tmp, hpre_align_sz());
-	h_req->cb = hpre_curve25519_cb;
-	h_req->areq.curve25519 = req;
-	msg = &h_req->req;
-	memset(msg, 0, sizeof(*msg));
-	msg->in = cpu_to_le64(DMA_MAPPING_ERROR);
-	msg->out = cpu_to_le64(DMA_MAPPING_ERROR);
-	msg->key = cpu_to_le64(ctx->curve25519.dma_p);
-
-	msg->dw0 |= cpu_to_le32(0x1U << HPRE_SQE_DONE_SHIFT);
-	msg->task_len1 = (ctx->key_sz >> HPRE_BITS_2_BYTES_SHIFT) - 1;
-	h_req->ctx = ctx;
-
-	req_id = hpre_add_req_to_ctx(h_req);
-	if (req_id < 0)
-		return -EBUSY;
-
-	msg->tag = cpu_to_le16((u16)req_id);
-	return 0;
-}
-
-static void hpre_curve25519_src_modulo_p(u8 *ptr)
-{
-	int i;
-
-	for (i = 0; i < CURVE25519_KEY_SIZE - 1; i++)
-		ptr[i] = 0;
-
-	/* The modulus is ptr's last byte minus '0xed'(last byte of p) */
-	ptr[i] -= 0xed;
-}
-
-static int hpre_curve25519_src_init(struct hpre_asym_request *hpre_req,
-				    struct scatterlist *data, unsigned int len)
-{
-	struct hpre_sqe *msg = &hpre_req->req;
-	struct hpre_ctx *ctx = hpre_req->ctx;
-	struct device *dev = ctx->dev;
-	u8 p[CURVE25519_KEY_SIZE] = { 0 };
-	const struct ecc_curve *curve;
-	dma_addr_t dma = 0;
-	u8 *ptr;
-
-	if (len != CURVE25519_KEY_SIZE) {
-		dev_err(dev, "sourc_data len is not 32bytes, len = %u!\n", len);
-		return -EINVAL;
-	}
-
-	ptr = dma_alloc_coherent(dev, ctx->key_sz, &dma, GFP_KERNEL);
-	if (unlikely(!ptr))
-		return -ENOMEM;
-
-	scatterwalk_map_and_copy(ptr, data, 0, len, 0);
-
-	if (!crypto_memneq(ptr, curve25519_null_point, CURVE25519_KEY_SIZE)) {
-		dev_err(dev, "gx is null!\n");
-		goto err;
-	}
-
-	/*
-	 * Src_data(gx) is in little-endian order, MSB in the final byte should
-	 * be masked as described in RFC7748, then transform it to big-endian
-	 * form, then hisi_hpre can use the data.
-	 */
-	ptr[31] &= 0x7f;
-	hpre_key_to_big_end(ptr, CURVE25519_KEY_SIZE);
-
-	curve = ecc_get_curve25519();
-
-	fill_curve_param(p, curve->p, CURVE25519_KEY_SIZE, curve->g.ndigits);
-
-	/*
-	 * When src_data equals (2^255 - 19) ~  (2^255 - 1), it is out of p,
-	 * we get its modulus to p, and then use it.
-	 */
-	if (memcmp(ptr, p, ctx->key_sz) == 0) {
-		dev_err(dev, "gx is p!\n");
-		goto err;
-	} else if (memcmp(ptr, p, ctx->key_sz) > 0) {
-		hpre_curve25519_src_modulo_p(ptr);
-	}
-
-	hpre_req->src = ptr;
-	msg->in = cpu_to_le64(dma);
-	return 0;
-
-err:
-	dma_free_coherent(dev, ctx->key_sz, ptr, dma);
-	return -EINVAL;
-}
-
-static int hpre_curve25519_dst_init(struct hpre_asym_request *hpre_req,
-				    struct scatterlist *data, unsigned int len)
-{
-	struct hpre_sqe *msg = &hpre_req->req;
-	struct hpre_ctx *ctx = hpre_req->ctx;
-	struct device *dev = ctx->dev;
-	dma_addr_t dma;
-
-	if (!data || !sg_is_last(data) || len != ctx->key_sz) {
-		dev_err(dev, "data or data length is illegal!\n");
-		return -EINVAL;
-	}
-
-	hpre_req->dst = NULL;
-	dma = dma_map_single(dev, sg_virt(data), len, DMA_FROM_DEVICE);
-	if (unlikely(dma_mapping_error(dev, dma))) {
-		dev_err(dev, "dma map data err!\n");
-		return -ENOMEM;
-	}
-
-	msg->out = cpu_to_le64(dma);
-	return 0;
-}
-
-static int hpre_curve25519_compute_value(struct kpp_request *req)
-{
-	struct crypto_kpp *tfm = crypto_kpp_reqtfm(req);
-	struct hpre_ctx *ctx = kpp_tfm_ctx(tfm);
-	struct device *dev = ctx->dev;
-	void *tmp = kpp_request_ctx(req);
-	struct hpre_asym_request *hpre_req = PTR_ALIGN(tmp, hpre_align_sz());
-	struct hpre_sqe *msg = &hpre_req->req;
-	int ret;
-
-	ret = hpre_curve25519_msg_request_set(ctx, req);
-	if (unlikely(ret)) {
-		dev_err(dev, "failed to set curve25519 request, ret = %d!\n", ret);
-		return ret;
-	}
-
-	if (req->src) {
-		ret = hpre_curve25519_src_init(hpre_req, req->src, req->src_len);
-		if (unlikely(ret)) {
-			dev_err(dev, "failed to init src data, ret = %d!\n",
-				ret);
-			goto clear_all;
-		}
-	} else {
-		msg->in = cpu_to_le64(ctx->curve25519.dma_g);
-	}
-
-	ret = hpre_curve25519_dst_init(hpre_req, req->dst, req->dst_len);
-	if (unlikely(ret)) {
-		dev_err(dev, "failed to init dst data, ret = %d!\n", ret);
-		goto clear_all;
-	}
-
-	msg->dw0 = cpu_to_le32(le32_to_cpu(msg->dw0) | HPRE_ALG_CURVE25519_MUL);
-	ret = hpre_send(ctx, msg);
-	if (likely(!ret))
-		return -EINPROGRESS;
-
-clear_all:
-	hpre_rm_req_from_ctx(hpre_req);
-	hpre_curve25519_hw_data_clr_all(ctx, hpre_req, req->dst, req->src);
-	return ret;
-}
-
-static unsigned int hpre_curve25519_max_size(struct crypto_kpp *tfm)
-{
-	struct hpre_ctx *ctx = kpp_tfm_ctx(tfm);
-
-	return ctx->key_sz;
-}
-
-static int hpre_curve25519_init_tfm(struct crypto_kpp *tfm)
-{
-	struct hpre_ctx *ctx = kpp_tfm_ctx(tfm);
-
-	kpp_set_reqsize(tfm, sizeof(struct hpre_asym_request) + hpre_align_pd());
-
-	return hpre_ctx_init(ctx, HPRE_V3_ECC_ALG_TYPE);
-}
-
-static void hpre_curve25519_exit_tfm(struct crypto_kpp *tfm)
-{
-	struct hpre_ctx *ctx = kpp_tfm_ctx(tfm);
-
-	hpre_ecc_clear_ctx(ctx, true, false);
+	hpre_ecc_clear_ctx(ctx, true);
 }
 
 static struct akcipher_alg rsa = {
 	.encrypt = hpre_rsa_enc,
 	.decrypt = hpre_rsa_dec,
@@ -2093,26 +1743,10 @@ static struct kpp_alg ecdh_curves[] = {
 			.cra_module = THIS_MODULE,
 		},
 	}
 };
 
-static struct kpp_alg curve25519_alg = {
-	.set_secret = hpre_curve25519_set_secret,
-	.generate_public_key = hpre_curve25519_compute_value,
-	.compute_shared_secret = hpre_curve25519_compute_value,
-	.max_size = hpre_curve25519_max_size,
-	.init = hpre_curve25519_init_tfm,
-	.exit = hpre_curve25519_exit_tfm,
-	.base = {
-		.cra_ctxsize = sizeof(struct hpre_ctx),
-		.cra_priority = HPRE_CRYPTO_ALG_PRI,
-		.cra_name = "curve25519",
-		.cra_driver_name = "hpre-curve25519",
-		.cra_module = THIS_MODULE,
-	},
-};
-
 static int hpre_register_rsa(struct hisi_qm *qm)
 {
 	int ret;
 
 	if (!hpre_check_alg_support(qm, HPRE_DRV_RSA_MASK_CAP))
@@ -2190,32 +1824,10 @@ static void hpre_unregister_ecdh(struct hisi_qm *qm)
 
 	for (i = ARRAY_SIZE(ecdh_curves) - 1; i >= 0; --i)
 		crypto_unregister_kpp(&ecdh_curves[i]);
 }
 
-static int hpre_register_x25519(struct hisi_qm *qm)
-{
-	int ret;
-
-	if (!hpre_check_alg_support(qm, HPRE_DRV_X25519_MASK_CAP))
-		return 0;
-
-	ret = crypto_register_kpp(&curve25519_alg);
-	if (ret)
-		dev_err(&qm->pdev->dev, "failed to register x25519 (%d)!\n", ret);
-
-	return ret;
-}
-
-static void hpre_unregister_x25519(struct hisi_qm *qm)
-{
-	if (!hpre_check_alg_support(qm, HPRE_DRV_X25519_MASK_CAP))
-		return;
-
-	crypto_unregister_kpp(&curve25519_alg);
-}
-
 int hpre_algs_register(struct hisi_qm *qm)
 {
 	int ret = 0;
 
 	mutex_lock(&hpre_algs_lock);
@@ -2234,21 +1846,15 @@ int hpre_algs_register(struct hisi_qm *qm)
 
 	ret = hpre_register_ecdh(qm);
 	if (ret)
 		goto unreg_dh;
 
-	ret = hpre_register_x25519(qm);
-	if (ret)
-		goto unreg_ecdh;
-
 	hpre_available_devs++;
 	mutex_unlock(&hpre_algs_lock);
 
 	return ret;
 
-unreg_ecdh:
-	hpre_unregister_ecdh(qm);
 unreg_dh:
 	hpre_unregister_dh(qm);
 unreg_rsa:
 	hpre_unregister_rsa(qm);
 unlock:
@@ -2260,11 +1866,10 @@ void hpre_algs_unregister(struct hisi_qm *qm)
 {
 	mutex_lock(&hpre_algs_lock);
 	if (--hpre_available_devs)
 		goto unlock;
 
-	hpre_unregister_x25519(qm);
 	hpre_unregister_ecdh(qm);
 	hpre_unregister_dh(qm);
 	hpre_unregister_rsa(qm);
 
 unlock:
-- 
2.50.1

