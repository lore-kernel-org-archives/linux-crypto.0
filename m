Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8C0EC433DB
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Jan 2021 07:14:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 79BEC2376F
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Jan 2021 07:14:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727062AbhAVHOT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 22 Jan 2021 02:14:19 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:11481 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727040AbhAVHNx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Jan 2021 02:13:53 -0500
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4DMVmH2TF2zjBlp;
        Fri, 22 Jan 2021 15:11:11 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.498.0; Fri, 22 Jan 2021 15:12:11 +0800
From:   Meng Yu <yumeng18@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <xuzaibo@huawei.com>,
        <wangzhou1@hisilicon.com>, <yumeng18@huawei.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v7 6/7] crypto: hisilicon/hpre - add 'ECDH' algorithm
Date:   Fri, 22 Jan 2021 15:09:54 +0800
Message-ID: <1611299395-675-7-git-send-email-yumeng18@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1611299395-675-1-git-send-email-yumeng18@huawei.com>
References: <1611299395-675-1-git-send-email-yumeng18@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

1. Enable 'ECDH' algorithm in Kunpeng 930;
2. HPRE ECDH Support ECC curve: P192, P224, P256, P384, P521.

Signed-off-by: Meng Yu <yumeng18@huawei.com>
Reviewed-by: Zaibo Xu <xuzaibo@huawei.com>
---
 drivers/crypto/hisilicon/hpre/hpre.h        |   2 +-
 drivers/crypto/hisilicon/hpre/hpre_crypto.c | 493 +++++++++++++++++++++++++++-
 drivers/crypto/hisilicon/hpre/hpre_main.c   |   1 +
 3 files changed, 491 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/hisilicon/hpre/hpre.h b/drivers/crypto/hisilicon/hpre/hpre.h
index 02193e1..50e6b2e 100644
--- a/drivers/crypto/hisilicon/hpre/hpre.h
+++ b/drivers/crypto/hisilicon/hpre/hpre.h
@@ -83,6 +83,7 @@ enum hpre_alg_type {
 	HPRE_ALG_KG_CRT = 0x3,
 	HPRE_ALG_DH_G2 = 0x4,
 	HPRE_ALG_DH = 0x5,
+	HPRE_ALG_ECC_MUL = 0xD,
 };
 
 struct hpre_sqe {
@@ -104,5 +105,4 @@ struct hisi_qp *hpre_create_qp(u8 type);
 int hpre_algs_register(struct hisi_qm *qm);
 void hpre_algs_unregister(struct hisi_qm *qm);
 
-
 #endif
diff --git a/drivers/crypto/hisilicon/hpre/hpre_crypto.c b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
index 712bea9..778a0057 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_crypto.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
@@ -2,6 +2,8 @@
 /* Copyright (c) 2019 HiSilicon Limited. */
 #include <crypto/akcipher.h>
 #include <crypto/dh.h>
+#include <crypto/ecc_curve.h>
+#include <crypto/ecdh.h>
 #include <crypto/internal/akcipher.h>
 #include <crypto/internal/kpp.h>
 #include <crypto/internal/rsa.h>
@@ -36,6 +38,20 @@ struct hpre_ctx;
 #define HPRE_DFX_SEC_TO_US	1000000
 #define HPRE_DFX_US_TO_NS	1000
 
+/* size in bytes of the n prime */
+#define HPRE_ECC_NIST_P192_N_SIZE	24
+#define HPRE_ECC_NIST_P224_N_SIZE	28
+#define HPRE_ECC_NIST_P256_N_SIZE	32
+#define HPRE_ECC_NIST_P384_N_SIZE	48
+#define HPRE_ECC_NIST_P521_N_SIZE	66
+
+/* size in bytes */
+#define HPRE_ECC_HW256_KSZ_B	32
+#define HPRE_ECC_HW384_KSZ_B	48
+#define HPRE_ECC_HW576_KSZ_B	72
+
+#define HPRE_ECDH_MAX_SZ	HPRE_ECC_HW576_KSZ_B
+
 typedef void (*hpre_cb)(struct hpre_ctx *ctx, void *sqe);
 
 struct hpre_rsa_ctx {
@@ -61,14 +77,25 @@ struct hpre_dh_ctx {
 	 * else if base if the counterpart public key we
 	 * compute the shared secret
 	 *	ZZ = yb^xa mod p; [RFC2631 sec 2.1.1]
+	 * low address: d--->n, please refer to Hisilicon HPRE UM
 	 */
-	char *xa_p; /* low address: d--->n, please refer to Hisilicon HPRE UM */
+	char *xa_p;
 	dma_addr_t dma_xa_p;
 
 	char *g; /* m */
 	dma_addr_t dma_g;
 };
 
+struct hpre_ecdh_ctx {
+	/* low address: p->a->k->b */
+	unsigned char *p;
+	dma_addr_t dma_p;
+
+	/* low address: x->y */
+	unsigned char *g;
+	dma_addr_t dma_g;
+};
+
 struct hpre_ctx {
 	struct hisi_qp *qp;
 	struct hpre_asym_request **req_list;
@@ -80,7 +107,10 @@ struct hpre_ctx {
 	union {
 		struct hpre_rsa_ctx rsa;
 		struct hpre_dh_ctx dh;
+		struct hpre_ecdh_ctx ecdh;
 	};
+	/* for ecc algorithms */
+	unsigned int curve_id;
 };
 
 struct hpre_asym_request {
@@ -91,6 +121,7 @@ struct hpre_asym_request {
 	union {
 		struct akcipher_request *rsa;
 		struct kpp_request *dh;
+		struct kpp_request *ecdh;
 	} areq;
 	int err;
 	int req_id;
@@ -1115,6 +1146,428 @@ static void hpre_rsa_exit_tfm(struct crypto_akcipher *tfm)
 	crypto_free_akcipher(ctx->rsa.soft_tfm);
 }
 
+static void hpre_key_to_big_end(u8 *data, int len)
+{
+	int i, j;
+	u8 tmp;
+
+	for (i = 0; i < len / 2; i++) {
+		j = len - i - 1;
+		tmp = data[j];
+		data[j] = data[i];
+		data[i] = tmp;
+	}
+}
+
+static void hpre_ecc_clear_ctx(struct hpre_ctx *ctx, bool is_clear_all,
+			       bool is_ecdh)
+{
+	struct device *dev = HPRE_DEV(ctx);
+	unsigned int sz = ctx->key_sz;
+	unsigned int shift = sz << 1;
+
+	if (is_clear_all)
+		hisi_qm_stop_qp(ctx->qp);
+
+	if (is_ecdh && ctx->ecdh.p) {
+		/* ecdh: p->a->k->b */
+		memzero_explicit(ctx->ecdh.p + shift, sz);
+		dma_free_coherent(dev, sz << 3, ctx->ecdh.p, ctx->ecdh.dma_p);
+		ctx->ecdh.p = NULL;
+	}
+
+	ctx->curve_id = 0;
+	hpre_ctx_clear(ctx, is_clear_all);
+}
+
+/*
+ * The bits of 192/224/256/384/521 are supported by HPRE,
+ * and convert the bits like:
+ * bits<=256, bits=256; 256<bits<=384, bits=384; 384<bits<=576, bits=576;
+ * If the parameter bit width is insufficient, then we fill in the
+ * high-order zeros by soft, so TASK_LENGTH1 is 0x3/0x5/0x8;
+ */
+static unsigned int hpre_ecdh_supported_curve(unsigned short id)
+{
+	switch (id) {
+	case ECC_CURVE_NIST_P192:
+	case ECC_CURVE_NIST_P224:
+	case ECC_CURVE_NIST_P256:
+		return HPRE_ECC_HW256_KSZ_B;
+	case ECC_CURVE_NIST_P384:
+		return HPRE_ECC_HW384_KSZ_B;
+	case ECC_CURVE_NIST_P521:
+		return HPRE_ECC_HW576_KSZ_B;
+	default:
+		break;
+	}
+
+	return 0;
+}
+
+static void fill_curve_param(void *addr, u64 *param, unsigned int cur_sz, u8 ndigits)
+{
+	unsigned int sz = cur_sz - (ndigits - 1) * sizeof(u64);
+	u8 i = 0;
+
+	while (i < ndigits - 1) {
+		memcpy(addr + sizeof(u64) * i, &param[i], sizeof(u64));
+		i++;
+	}
+
+	memcpy(addr + sizeof(u64) * i, &param[ndigits - 1], sz);
+	hpre_key_to_big_end((u8 *)addr, cur_sz);
+}
+
+static int hpre_ecdh_fill_curve(struct hpre_ctx *ctx, struct ecdh *params,
+				unsigned int cur_sz)
+{
+	unsigned int shifta = ctx->key_sz << 1;
+	unsigned int shiftb = ctx->key_sz << 2;
+	void *p = ctx->ecdh.p + ctx->key_sz - cur_sz;
+	void *a = ctx->ecdh.p + shifta - cur_sz;
+	void *b = ctx->ecdh.p + shiftb - cur_sz;
+	void *x = ctx->ecdh.g + ctx->key_sz - cur_sz;
+	void *y = ctx->ecdh.g + shifta - cur_sz;
+	const struct ecc_curve *curve;
+	char *n;
+
+	n = kzalloc(ctx->key_sz, GFP_KERNEL);
+	if (unlikely(!n))
+		return -ENOMEM;
+
+	curve = ecc_get_curve_by_id(params->curve_id);
+	if (unlikely(!curve))
+		goto free;
+
+	fill_curve_param(p, curve->p, cur_sz, curve->g.ndigits);
+	fill_curve_param(a, curve->a, cur_sz, curve->g.ndigits);
+	fill_curve_param(b, curve->b, cur_sz, curve->g.ndigits);
+	fill_curve_param(x, curve->g.x, cur_sz, curve->g.ndigits);
+	fill_curve_param(y, curve->g.y, cur_sz, curve->g.ndigits);
+	fill_curve_param(n, curve->n, cur_sz, curve->g.ndigits);
+
+	if (params->key_size == cur_sz && strcmp(params->key, n) >= 0)
+		goto free;
+
+	kfree(n);
+	return 0;
+
+free:
+	kfree(n);
+	return -EINVAL;
+}
+
+static unsigned int hpre_ecdh_get_curvesz(unsigned short id)
+{
+	switch (id) {
+	case ECC_CURVE_NIST_P192:
+		return HPRE_ECC_NIST_P192_N_SIZE;
+	case ECC_CURVE_NIST_P224:
+		return HPRE_ECC_NIST_P224_N_SIZE;
+	case ECC_CURVE_NIST_P256:
+		return HPRE_ECC_NIST_P256_N_SIZE;
+	case ECC_CURVE_NIST_P384:
+		return HPRE_ECC_NIST_P384_N_SIZE;
+	case ECC_CURVE_NIST_P521:
+		return HPRE_ECC_NIST_P521_N_SIZE;
+	default:
+		break;
+	}
+
+	return 0;
+}
+
+static int hpre_ecdh_set_param(struct hpre_ctx *ctx, struct ecdh *params)
+{
+	struct device *dev = HPRE_DEV(ctx);
+	unsigned int sz, shift, curve_sz;
+	int ret;
+
+	ctx->key_sz = hpre_ecdh_supported_curve(params->curve_id);
+	if (!ctx->key_sz)
+		return -EINVAL;
+
+	curve_sz = hpre_ecdh_get_curvesz(params->curve_id);
+	if (!curve_sz || params->key_size > curve_sz)
+		return -EINVAL;
+
+	sz = ctx->key_sz;
+	ctx->curve_id = params->curve_id;
+
+	if (!ctx->ecdh.p) {
+		ctx->ecdh.p = dma_alloc_coherent(dev, sz << 3, &ctx->ecdh.dma_p,
+						 GFP_KERNEL);
+		if (!ctx->ecdh.p)
+			return -ENOMEM;
+	}
+
+	shift = sz << 2;
+	ctx->ecdh.g = ctx->ecdh.p + shift;
+	ctx->ecdh.dma_g = ctx->ecdh.dma_p + shift;
+
+	ret = hpre_ecdh_fill_curve(ctx, params, curve_sz);
+	if (ret) {
+		dev_err(dev, "failed to fill curve_param, ret = %d!\n", ret);
+		dma_free_coherent(dev, sz << 3, ctx->ecdh.p, ctx->ecdh.dma_p);
+		ctx->ecdh.p = NULL;
+		return ret;
+	}
+
+	return 0;
+}
+
+static bool hpre_key_is_valid(char *key, unsigned short key_sz)
+{
+	int i;
+
+	for (i = 0; i < key_sz; i++)
+		if (key[i])
+			return true;
+
+	return false;
+}
+
+static int hpre_ecdh_set_secret(struct crypto_kpp *tfm, const void *buf,
+				unsigned int len)
+{
+	struct hpre_ctx *ctx = kpp_tfm_ctx(tfm);
+	struct device *dev = HPRE_DEV(ctx);
+	unsigned int sz, sz_shift;
+	struct ecdh params;
+	int ret;
+
+	if (crypto_ecdh_decode_key(buf, len, &params) < 0) {
+		dev_err(dev, "failed to decode ecdh key!\n");
+		return -EINVAL;
+	}
+
+	if (!hpre_key_is_valid(params.key, params.key_size)) {
+		dev_err(dev, "Invalid hpre key!\n");
+		return -EINVAL;
+	}
+
+	hpre_ecc_clear_ctx(ctx, false, true);
+
+	ret = hpre_ecdh_set_param(ctx, &params);
+	if (ret < 0) {
+		dev_err(dev, "failed to set hpre param, ret = %d!\n", ret);
+		return ret;
+	}
+
+	sz = ctx->key_sz;
+	sz_shift = (sz << 1) + sz - params.key_size;
+	memcpy(ctx->ecdh.p + sz_shift, params.key, params.key_size);
+
+	return 0;
+}
+
+static void hpre_ecdh_hw_data_clr_all(struct hpre_ctx *ctx,
+				      struct hpre_asym_request *req,
+				      struct scatterlist *dst,
+				      struct scatterlist *src)
+{
+	struct device *dev = HPRE_DEV(ctx);
+	struct hpre_sqe *sqe = &req->req;
+	dma_addr_t dma;
+
+	dma = le64_to_cpu(sqe->in);
+	if (unlikely(!dma))
+		return;
+
+	if (src && req->src)
+		dma_free_coherent(dev, ctx->key_sz << 2, req->src, dma);
+
+	dma = le64_to_cpu(sqe->out);
+	if (unlikely(!dma))
+		return;
+
+	if (req->dst)
+		dma_free_coherent(dev, ctx->key_sz << 1, req->dst, dma);
+	if (dst)
+		dma_unmap_single(dev, dma, ctx->key_sz << 1, DMA_FROM_DEVICE);
+}
+
+static void hpre_ecdh_cb(struct hpre_ctx *ctx, void *resp)
+{
+	unsigned int curve_sz = hpre_ecdh_get_curvesz(ctx->curve_id);
+	struct hpre_dfx *dfx = ctx->hpre->debug.dfx;
+	struct hpre_asym_request *req = NULL;
+	struct kpp_request *areq;
+	u64 overtime_thrhld;
+	char *p;
+	int ret;
+
+	ret = hpre_alg_res_post_hf(ctx, resp, (void **)&req);
+	areq = req->areq.ecdh;
+	areq->dst_len = ctx->key_sz << 1;
+
+	overtime_thrhld = atomic64_read(&dfx[HPRE_OVERTIME_THRHLD].value);
+	if (overtime_thrhld && hpre_is_bd_timeout(req, overtime_thrhld))
+		atomic64_inc(&dfx[HPRE_OVER_THRHLD_CNT].value);
+
+	p = sg_virt(areq->dst);
+	memmove(p, p + ctx->key_sz - curve_sz, curve_sz);
+	memmove(p + curve_sz, p + areq->dst_len - curve_sz, curve_sz);
+
+	hpre_ecdh_hw_data_clr_all(ctx, req, areq->dst, areq->src);
+	kpp_request_complete(areq, ret);
+
+	atomic64_inc(&dfx[HPRE_RECV_CNT].value);
+}
+
+static int hpre_ecdh_msg_request_set(struct hpre_ctx *ctx,
+				     struct kpp_request *req)
+{
+	struct hpre_asym_request *h_req;
+	struct hpre_sqe *msg;
+	int req_id;
+	void *tmp;
+
+	if (req->dst_len < ctx->key_sz << 1) {
+		req->dst_len = ctx->key_sz << 1;
+		return -EINVAL;
+	}
+
+	tmp = kpp_request_ctx(req);
+	h_req = PTR_ALIGN(tmp, HPRE_ALIGN_SZ);
+	h_req->cb = hpre_ecdh_cb;
+	h_req->areq.ecdh = req;
+	msg = &h_req->req;
+	memset(msg, 0, sizeof(*msg));
+	msg->key = cpu_to_le64(ctx->ecdh.dma_p);
+
+	msg->dw0 |= cpu_to_le32(0x1U << HPRE_SQE_DONE_SHIFT);
+	msg->task_len1 = (ctx->key_sz >> HPRE_BITS_2_BYTES_SHIFT) - 1;
+	h_req->ctx = ctx;
+
+	req_id = hpre_add_req_to_ctx(h_req);
+	if (req_id < 0)
+		return -EBUSY;
+
+	msg->tag = cpu_to_le16((u16)req_id);
+	return 0;
+}
+
+static int hpre_ecdh_src_data_init(struct hpre_asym_request *hpre_req,
+				   struct scatterlist *data, unsigned int len)
+{
+	struct hpre_sqe *msg = &hpre_req->req;
+	struct hpre_ctx *ctx = hpre_req->ctx;
+	struct device *dev = HPRE_DEV(ctx);
+	unsigned int tmpshift;
+	dma_addr_t dma = 0;
+	void *ptr;
+	int shift;
+
+	/* Src_data include gx and gy. */
+	shift = ctx->key_sz - (len >> 1);
+	if (unlikely(shift < 0))
+		return -EINVAL;
+
+	ptr = dma_alloc_coherent(dev, ctx->key_sz << 2, &dma, GFP_KERNEL);
+	if (unlikely(!ptr))
+		return -ENOMEM;
+
+	tmpshift = ctx->key_sz << 1;
+	scatterwalk_map_and_copy(ptr + tmpshift, data, 0, len, 0);
+	memcpy(ptr + shift, ptr + tmpshift, len >> 1);
+	memcpy(ptr + ctx->key_sz + shift, ptr + tmpshift + (len >> 1), len >> 1);
+
+	hpre_req->src = ptr;
+	msg->in = cpu_to_le64(dma);
+	return 0;
+}
+
+static int hpre_ecdh_dst_data_init(struct hpre_asym_request *hpre_req,
+				   struct scatterlist *data, unsigned int len)
+{
+	struct hpre_sqe *msg = &hpre_req->req;
+	struct hpre_ctx *ctx = hpre_req->ctx;
+	struct device *dev = HPRE_DEV(ctx);
+	dma_addr_t dma = 0;
+
+	if (unlikely(!data || !sg_is_last(data) || len != ctx->key_sz << 1)) {
+		dev_err(dev, "data or data length is illegal!\n");
+		return -EINVAL;
+	}
+
+	hpre_req->dst = NULL;
+	dma = dma_map_single(dev, sg_virt(data), len, DMA_FROM_DEVICE);
+	if (unlikely(dma_mapping_error(dev, dma))) {
+		dev_err(dev, "dma map data err!\n");
+		return -ENOMEM;
+	}
+
+	msg->out = cpu_to_le64(dma);
+	return 0;
+}
+
+static int hpre_ecdh_compute_value(struct kpp_request *req)
+{
+	struct crypto_kpp *tfm = crypto_kpp_reqtfm(req);
+	struct hpre_ctx *ctx = kpp_tfm_ctx(tfm);
+	struct device *dev = HPRE_DEV(ctx);
+	void *tmp = kpp_request_ctx(req);
+	struct hpre_asym_request *hpre_req = PTR_ALIGN(tmp, HPRE_ALIGN_SZ);
+	struct hpre_sqe *msg = &hpre_req->req;
+	int ret;
+
+	ret = hpre_ecdh_msg_request_set(ctx, req);
+	if (unlikely(ret)) {
+		dev_err(dev, "failed to set ecdh request, ret = %d!\n", ret);
+		return ret;
+	}
+
+	if (req->src) {
+		ret = hpre_ecdh_src_data_init(hpre_req, req->src, req->src_len);
+		if (unlikely(ret)) {
+			dev_err(dev, "failed to init src data, ret = %d!\n", ret);
+			goto clear_all;
+		}
+	} else {
+		msg->in = cpu_to_le64(ctx->ecdh.dma_g);
+	}
+
+	ret = hpre_ecdh_dst_data_init(hpre_req, req->dst, req->dst_len);
+	if (unlikely(ret)) {
+		dev_err(dev, "failed to init dst data, ret = %d!\n", ret);
+		goto clear_all;
+	}
+
+	msg->dw0 = cpu_to_le32(le32_to_cpu(msg->dw0) | HPRE_ALG_ECC_MUL);
+	ret = hpre_send(ctx, msg);
+	if (likely(!ret))
+		return -EINPROGRESS;
+
+clear_all:
+	hpre_rm_req_from_ctx(hpre_req);
+	hpre_ecdh_hw_data_clr_all(ctx, hpre_req, req->dst, req->src);
+	return ret;
+}
+
+static unsigned int hpre_ecdh_max_size(struct crypto_kpp *tfm)
+{
+	struct hpre_ctx *ctx = kpp_tfm_ctx(tfm);
+
+	/* max size is the pub_key_size, include x and y */
+	return ctx->key_sz << 1;
+}
+
+static int hpre_ecdh_init_tfm(struct crypto_kpp *tfm)
+{
+	struct hpre_ctx *ctx = kpp_tfm_ctx(tfm);
+
+	return hpre_ctx_init(ctx, HPRE_V3_ECC_ALG_TYPE);
+}
+
+static void hpre_ecdh_exit_tfm(struct crypto_kpp *tfm)
+{
+	struct hpre_ctx *ctx = kpp_tfm_ctx(tfm);
+
+	hpre_ecc_clear_ctx(ctx, true, true);
+}
+
 static struct akcipher_alg rsa = {
 	.sign = hpre_rsa_dec,
 	.verify = hpre_rsa_enc,
@@ -1154,6 +1607,22 @@ static struct kpp_alg dh = {
 };
 #endif
 
+static struct kpp_alg ecdh = {
+	.set_secret = hpre_ecdh_set_secret,
+	.generate_public_key = hpre_ecdh_compute_value,
+	.compute_shared_secret = hpre_ecdh_compute_value,
+	.max_size = hpre_ecdh_max_size,
+	.init = hpre_ecdh_init_tfm,
+	.exit = hpre_ecdh_exit_tfm,
+	.reqsize = sizeof(struct hpre_asym_request) + HPRE_ALIGN_SZ,
+	.base = {
+		.cra_ctxsize = sizeof(struct hpre_ctx),
+		.cra_priority = HPRE_CRYPTO_ALG_PRI,
+		.cra_name = "ecdh",
+		.cra_driver_name = "hpre-ecdh",
+		.cra_module = THIS_MODULE,
+	},
+};
 int hpre_algs_register(struct hisi_qm *qm)
 {
 	int ret;
@@ -1164,17 +1633,33 @@ int hpre_algs_register(struct hisi_qm *qm)
 		return ret;
 #ifdef CONFIG_CRYPTO_DH
 	ret = crypto_register_kpp(&dh);
-	if (ret)
+	if (ret) {
 		crypto_unregister_akcipher(&rsa);
+		return ret;
+	}
 #endif
 
-	return ret;
+	if (qm->ver >= QM_HW_V3) {
+		ret = crypto_register_kpp(&ecdh);
+		if (ret) {
+#ifdef CONFIG_CRYPTO_DH
+			crypto_unregister_kpp(&dh);
+#endif
+			crypto_unregister_akcipher(&rsa);
+			return ret;
+		}
+	}
+
+	return 0;
 }
 
 void hpre_algs_unregister(struct hisi_qm *qm)
 {
-	crypto_unregister_akcipher(&rsa);
+	if (qm->ver >= QM_HW_V3)
+		crypto_unregister_kpp(&ecdh);
+
 #ifdef CONFIG_CRYPTO_DH
 	crypto_unregister_kpp(&dh);
 #endif
+	crypto_unregister_akcipher(&rsa);
 }
diff --git a/drivers/crypto/hisilicon/hpre/hpre_main.c b/drivers/crypto/hisilicon/hpre/hpre_main.c
index d3ec3b4..a6c8dd2 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_main.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_main.c
@@ -1074,4 +1074,5 @@ module_exit(hpre_exit);
 
 MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR("Zaibo Xu <xuzaibo@huawei.com>");
+MODULE_AUTHOR("Meng Yu <yumeng18@huawei.com>");
 MODULE_DESCRIPTION("Driver for HiSilicon HPRE accelerator");
-- 
2.8.1

