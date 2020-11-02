Return-Path: <SRS0=zLA1=EI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5004C388F2
	for <linux-crypto@archiver.kernel.org>; Mon,  2 Nov 2020 02:33:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 564B2221FC
	for <linux-crypto@archiver.kernel.org>; Mon,  2 Nov 2020 02:33:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727765AbgKBCdK (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 1 Nov 2020 21:33:10 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:6721 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727651AbgKBCdC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 1 Nov 2020 21:33:02 -0500
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4CPcQc52TPzkdND;
        Mon,  2 Nov 2020 10:32:56 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.487.0; Mon, 2 Nov 2020 10:32:51 +0800
From:   Meng Yu <yumeng18@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <xuzaibo@huawei.com>,
        <wangzhou1@hisilicon.com>, <yumeng18@huawei.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 5/5] crypto: hisilicon/hpre - add 'CURVE25519' algorithm
Date:   Mon, 2 Nov 2020 10:31:05 +0800
Message-ID: <1604284265-1271-6-git-send-email-yumeng18@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1604284265-1271-1-git-send-email-yumeng18@huawei.com>
References: <1604284265-1271-1-git-send-email-yumeng18@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Enable 'CURVE25519' algorithm in 'Kunpeng 930'.

Signed-off-by: Meng Yu <yumeng18@huawei.com>
Reviewed-by: Zaibo Xu <xuzaibo@huawei.com>
Reported-by: kernel test robot <lkp@intel.com>
---
 drivers/crypto/hisilicon/hpre/hpre.h        |   2 +
 drivers/crypto/hisilicon/hpre/hpre_crypto.c | 387 +++++++++++++++++++++++++++-
 2 files changed, 381 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/hisilicon/hpre/hpre.h b/drivers/crypto/hisilicon/hpre/hpre.h
index 50e6b2e..92892e3 100644
--- a/drivers/crypto/hisilicon/hpre/hpre.h
+++ b/drivers/crypto/hisilicon/hpre/hpre.h
@@ -84,6 +84,8 @@ enum hpre_alg_type {
 	HPRE_ALG_DH_G2 = 0x4,
 	HPRE_ALG_DH = 0x5,
 	HPRE_ALG_ECC_MUL = 0xD,
+	/* shared by x25519 and x448, but x448 is not supported now */
+	HPRE_ALG_CURVE25519_MUL = 0x10,
 };
 
 struct hpre_sqe {
diff --git a/drivers/crypto/hisilicon/hpre/hpre_crypto.c b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
index b7814ce..668a2a2 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_crypto.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright (c) 2019 HiSilicon Limited. */
 #include <crypto/akcipher.h>
+#include <crypto/curve25519.h>
 #include <crypto/dh.h>
 #include <crypto/ecdh.h>
 #include <crypto/internal/akcipher.h>
@@ -70,6 +71,25 @@ struct curve_param_desc {
 	const unsigned char *n;
 };
 
+/* curve25519 CURVE PARAMS, in big-endian order */
+/* p = (2 ^ 255 - 19) */
+static const unsigned char curve25519_p[] = {
+	0x7f, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
+	0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
+	0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xed
+};
+ /* a = (486662 - 2) / 4 = 121665 */
+static const unsigned char curve25519_a[] = {
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0xDB, 0x41
+};
+static const unsigned char curve25519_x[] = {
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x09
+};
+
 /* ECC CURVE PARAMS */
 /* 128 bits */
 static const unsigned char ecdh_p128_p[] = {
@@ -417,6 +437,16 @@ struct hpre_ecdh_ctx {
 	dma_addr_t dma_g;
 };
 
+struct hpre_curve25519_ctx {
+	/* low address: p->a->k */
+	unsigned char *p;
+	dma_addr_t dma_p;
+
+	/* gx coordinate */
+	unsigned char *g;
+	dma_addr_t dma_g;
+};
+
 struct hpre_ctx {
 	struct hisi_qp *qp;
 	struct hpre_asym_request **req_list;
@@ -429,6 +459,7 @@ struct hpre_ctx {
 		struct hpre_rsa_ctx rsa;
 		struct hpre_dh_ctx dh;
 		struct hpre_ecdh_ctx ecdh;
+		struct hpre_curve25519_ctx curve25519;
 	};
 	/* for ecc algorithms */
 	unsigned int curve_id;
@@ -443,6 +474,7 @@ struct hpre_asym_request {
 		struct akcipher_request *rsa;
 		struct kpp_request *dh;
 		struct kpp_request *ecdh;
+		struct kpp_request *curve25519;
 	} areq;
 	int err;
 	int req_id;
@@ -1877,6 +1909,318 @@ static void hpre_ecdh_exit_tfm(struct crypto_kpp *tfm)
 	hpre_ecc_clear_ctx(ctx, true, true);
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
+static void hpre_curve25519_fill_curve(struct hpre_ctx *ctx, const void *buf,
+				       unsigned int len)
+{
+	u8 secret[CURVE25519_KEY_SIZE] = { 0 };
+	unsigned int sz = ctx->key_sz;
+	unsigned int shift = sz << 1;
+	void *p;
+
+	/**
+	 * The key from 'buf' is in little-endian, we should preprocess it as
+	 * the description in rfc7748: "k[0] &= 248, k[31] &= 127, k[31] |= 64",
+	 * then convert it to big endian. Only in this way, the result can be
+	 * the same as the software curve-25519 that exists in crypto.
+	 */
+	memcpy(secret, buf, len);
+	curve25519_clamp_secret(secret);
+	hpre_key_to_big_end(secret, CURVE25519_KEY_SIZE);
+
+	p = ctx->curve25519.p + sz - len;
+
+	/* fill curve parameters */
+	memcpy(p, curve25519_p, len);
+	memcpy(p + sz, curve25519_a, len);
+	memcpy(p + shift, secret, len);
+	memcpy(p + shift + sz, curve25519_x, len);
+	memzero_explicit(secret, CURVE25519_KEY_SIZE);
+}
+
+static int hpre_curve25519_set_param(struct hpre_ctx *ctx, const void *buf,
+				     unsigned int len)
+{
+	struct device *dev = HPRE_DEV(ctx);
+	unsigned int sz = ctx->key_sz;
+	unsigned int shift = sz << 1;
+
+	/* p->a->k->gx */
+	if (!ctx->curve25519.p) {
+		ctx->curve25519.p = dma_alloc_coherent(dev, sz << 2,
+						       &ctx->curve25519.dma_p,
+						       GFP_KERNEL);
+		if (!ctx->curve25519.p)
+			return -ENOMEM;
+	}
+
+	ctx->curve25519.g = ctx->curve25519.p + shift + sz;
+	ctx->curve25519.dma_g = ctx->curve25519.dma_p + shift + sz;
+
+	hpre_curve25519_fill_curve(ctx, buf, len);
+
+	return 0;
+}
+
+static int hpre_curve25519_set_secret(struct crypto_kpp *tfm, const void *buf,
+				      unsigned int len)
+{
+	struct hpre_ctx *ctx = kpp_tfm_ctx(tfm);
+	struct device *dev = HPRE_DEV(ctx);
+	int ret = -EINVAL;
+
+	if (len != CURVE25519_KEY_SIZE ||
+	    !crypto_memneq(buf, curve25519_null_point, CURVE25519_KEY_SIZE)) {
+		dev_err(dev, "key is null or key len is not 32bytes!\n");
+		return ret;
+	}
+
+	/* Free old secret if any */
+	hpre_ecc_clear_ctx(ctx, false, false);
+
+	ctx->key_sz = CURVE25519_KEY_SIZE;
+	ret = hpre_curve25519_set_param(ctx, buf, CURVE25519_KEY_SIZE);
+	if (ret) {
+		dev_err(dev, "failed to set curve25519 param, ret = %d!\n", ret);
+		hpre_ecc_clear_ctx(ctx, false, false);
+		return ret;
+	}
+
+	return 0;
+}
+
+static void hpre_curve25519_hw_data_clr_all(struct hpre_ctx *ctx,
+					    struct hpre_asym_request *req,
+					    struct scatterlist *dst,
+					    struct scatterlist *src)
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
+		dma_free_coherent(dev, ctx->key_sz, req->src, dma);
+
+	dma = le64_to_cpu(sqe->out);
+	if (unlikely(!dma))
+		return;
+
+	if (req->dst)
+		dma_free_coherent(dev, ctx->key_sz, req->dst, dma);
+	if (dst)
+		dma_unmap_single(dev, dma, ctx->key_sz, DMA_FROM_DEVICE);
+}
+
+static void hpre_curve25519_cb(struct hpre_ctx *ctx, void *resp)
+{
+	struct hpre_dfx *dfx = ctx->hpre->debug.dfx;
+	struct hpre_asym_request *req = NULL;
+	struct kpp_request *areq;
+	u64 overtime_thrhld;
+	int ret;
+
+	ret = hpre_alg_res_post_hf(ctx, resp, (void **)&req);
+	areq = req->areq.curve25519;
+	areq->dst_len = ctx->key_sz;
+
+	overtime_thrhld = atomic64_read(&dfx[HPRE_OVERTIME_THRHLD].value);
+	if (overtime_thrhld && hpre_is_bd_timeout(req, overtime_thrhld))
+		atomic64_inc(&dfx[HPRE_OVER_THRHLD_CNT].value);
+
+	hpre_curve25519_hw_data_clr_all(ctx, req, areq->dst, areq->src);
+	kpp_request_complete(areq, ret);
+
+	atomic64_inc(&dfx[HPRE_RECV_CNT].value);
+}
+
+static int hpre_curve25519_msg_request_set(struct hpre_ctx *ctx,
+					   struct kpp_request *req)
+{
+	struct hpre_asym_request *h_req;
+	struct hpre_sqe *msg;
+	int req_id;
+	void *tmp;
+
+	if (unlikely(req->dst_len < ctx->key_sz)) {
+		req->dst_len = ctx->key_sz;
+		return -EINVAL;
+	}
+
+	tmp = kpp_request_ctx(req);
+	h_req = PTR_ALIGN(tmp, HPRE_ALIGN_SZ);
+	h_req->cb = hpre_curve25519_cb;
+	h_req->areq.curve25519 = req;
+	msg = &h_req->req;
+	memset(msg, 0, sizeof(*msg));
+	msg->key = cpu_to_le64(ctx->curve25519.dma_p);
+
+	msg->dw0 |= (0x1U << HPRE_SQE_DONE_SHIFT);
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
+static int hpre_curve25519_src_init(struct hpre_asym_request *hpre_req,
+				    struct scatterlist *data, unsigned int len)
+{
+	struct hpre_sqe *msg = &hpre_req->req;
+	struct hpre_ctx *ctx = hpre_req->ctx;
+	struct device *dev = HPRE_DEV(ctx);
+	dma_addr_t dma = 0;
+	u8 *ptr;
+
+	if (len != CURVE25519_KEY_SIZE) {
+		dev_err(dev, "sourc_data len is not 32bytes, len = %u!\n", len);
+		return -EINVAL;
+	}
+
+	ptr = dma_alloc_coherent(dev, ctx->key_sz, &dma, GFP_KERNEL);
+	if (unlikely(!ptr))
+		return -ENOMEM;
+
+	scatterwalk_map_and_copy(ptr, data, 0, len, 0);
+
+	if (!crypto_memneq(ptr, curve25519_null_point, CURVE25519_KEY_SIZE)) {
+		dev_err(dev, "gx is null!\n");
+		goto err;
+	}
+
+	/**
+	 * Src_data(gx) is in little-endian order, MSB in the final byte should
+	 * be masked as discribed in RFC7748, then transform it to big-endian
+	 * form, then hisi_hpre can use the data.
+	 */
+	ptr[31] &= 0x7f;
+	hpre_key_to_big_end(ptr, CURVE25519_KEY_SIZE);
+
+	if (strcmp(ptr, curve25519_p) >= 0) {
+		dev_err(dev, "gx is out of p!\n");
+		goto err;
+	}
+
+	hpre_req->src = ptr;
+	msg->in = cpu_to_le64(dma);
+	return 0;
+
+err:
+	dma_free_coherent(dev, ctx->key_sz, ptr, dma);
+	return -EINVAL;
+}
+
+static int hpre_curve25519_dst_init(struct hpre_asym_request *hpre_req,
+				    struct scatterlist *data, unsigned int len)
+{
+	struct hpre_sqe *msg = &hpre_req->req;
+	struct hpre_ctx *ctx = hpre_req->ctx;
+	struct device *dev = HPRE_DEV(ctx);
+	dma_addr_t dma = 0;
+	void *ptr;
+
+	if (sg_is_last(data)) {
+		hpre_req->dst = NULL;
+		dma = dma_map_single(dev, sg_virt(data), len, DMA_FROM_DEVICE);
+		if (unlikely(dma_mapping_error(dev, dma))) {
+			dev_err(dev, "dma map data err!\n");
+			return -ENOMEM;
+		}
+	} else {
+		ptr = dma_alloc_coherent(dev, ctx->key_sz, &dma, GFP_KERNEL);
+		if (unlikely(!ptr))
+			return -ENOMEM;
+		hpre_req->dst = ptr;
+	}
+
+	msg->out = cpu_to_le64(dma);
+	return 0;
+}
+
+static int hpre_curve25519_compute_value(struct kpp_request *req)
+{
+	struct crypto_kpp *tfm = crypto_kpp_reqtfm(req);
+	struct hpre_ctx *ctx = kpp_tfm_ctx(tfm);
+	struct device *dev = HPRE_DEV(ctx);
+	void *tmp = kpp_request_ctx(req);
+	struct hpre_asym_request *hpre_req = PTR_ALIGN(tmp, HPRE_ALIGN_SZ);
+	struct hpre_sqe *msg = &hpre_req->req;
+	int ret;
+
+	ret = hpre_curve25519_msg_request_set(ctx, req);
+	if (unlikely(ret)) {
+		dev_err(dev, "failed to set curve25519 request, ret = %d!\n", ret);
+		return ret;
+	}
+
+	if (req->src) {
+		ret = hpre_curve25519_src_init(hpre_req, req->src, req->src_len);
+		if (unlikely(ret)) {
+			dev_err(dev, "failed to init src data, ret = %d!\n",
+				ret);
+			goto clear_all;
+		}
+	} else {
+		msg->in = cpu_to_le64(ctx->curve25519.dma_g);
+	}
+
+	ret = hpre_curve25519_dst_init(hpre_req, req->dst, req->dst_len);
+	if (unlikely(ret)) {
+		dev_err(dev, "failed to init dst data, ret = %d!\n", ret);
+		goto clear_all;
+	}
+
+	msg->dw0 = cpu_to_le32(msg->dw0 | HPRE_ALG_CURVE25519_MUL);
+	ret = hpre_send(ctx, msg);
+	if (likely(!ret))
+		return -EINPROGRESS;
+
+clear_all:
+	hpre_rm_req_from_ctx(hpre_req);
+	hpre_curve25519_hw_data_clr_all(ctx, hpre_req, req->dst, req->src);
+	return ret;
+}
+
+static unsigned int hpre_curve25519_max_size(struct crypto_kpp *tfm)
+{
+	struct hpre_ctx *ctx = kpp_tfm_ctx(tfm);
+
+	return ctx->key_sz;
+}
+
+static int hpre_curve25519_init_tfm(struct crypto_kpp *tfm)
+{
+	struct hpre_ctx *ctx = kpp_tfm_ctx(tfm);
+
+	return hpre_ctx_init(ctx, HPRE_V3_ECC_ALG_TYPE);
+}
+
+static void hpre_curve25519_exit_tfm(struct crypto_kpp *tfm)
+{
+	struct hpre_ctx *ctx = kpp_tfm_ctx(tfm);
+
+	hpre_ecc_clear_ctx(ctx, true, false);
+}
+
 static struct akcipher_alg rsa = {
 	.sign = hpre_rsa_dec,
 	.verify = hpre_rsa_enc,
@@ -1932,6 +2276,24 @@ static struct kpp_alg ecdh = {
 		.cra_module = THIS_MODULE,
 	},
 };
+
+static struct kpp_alg curve25519_alg = {
+	.set_secret = hpre_curve25519_set_secret,
+	.generate_public_key = hpre_curve25519_compute_value,
+	.compute_shared_secret = hpre_curve25519_compute_value,
+	.max_size = hpre_curve25519_max_size,
+	.init = hpre_curve25519_init_tfm,
+	.exit = hpre_curve25519_exit_tfm,
+	.reqsize = sizeof(struct hpre_asym_request) + HPRE_ALIGN_SZ,
+	.base = {
+		.cra_ctxsize = sizeof(struct hpre_ctx),
+		.cra_priority = HPRE_CRYPTO_ALG_PRI,
+		.cra_name = "curve25519",
+		.cra_driver_name = "hpre-curve25519",
+		.cra_module = THIS_MODULE,
+	},
+};
+
 int hpre_algs_register(struct hisi_qm *qm)
 {
 	int ret;
@@ -1946,26 +2308,35 @@ int hpre_algs_register(struct hisi_qm *qm)
 		crypto_unregister_akcipher(&rsa);
 		return ret;
 	}
-#endif
 
+#endif
 	if (qm->ver >= QM_HW_V3) {
 		ret = crypto_register_kpp(&ecdh);
+		if (ret)
+			goto reg_err;
+
+		ret = crypto_register_kpp(&curve25519_alg);
 		if (ret) {
-#ifdef CONFIG_CRYPTO_DH
-			crypto_unregister_kpp(&dh);
-#endif
-			crypto_unregister_akcipher(&rsa);
-			return ret;
+			crypto_unregister_kpp(&ecdh);
+			goto reg_err;
 		}
 	}
-
 	return 0;
+
+reg_err:
+#ifdef CONFIG_CRYPTO_DH
+	crypto_unregister_kpp(&dh);
+#endif
+	crypto_unregister_akcipher(&rsa);
+	return ret;
 }
 
 void hpre_algs_unregister(struct hisi_qm *qm)
 {
-	if (qm->ver >= QM_HW_V3)
+	if (qm->ver >= QM_HW_V3) {
+		crypto_unregister_kpp(&curve25519_alg);
 		crypto_unregister_kpp(&ecdh);
+	}
 
 #ifdef CONFIG_CRYPTO_DH
 	crypto_unregister_kpp(&dh);
-- 
2.8.1

