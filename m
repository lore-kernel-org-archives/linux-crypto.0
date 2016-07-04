From: Salvatore Benedetto <salvatore.benedetto@intel.com>
Subject: [PATCH 3/3] crypto: qat - Add RSA CRT mode
Date: Mon,  4 Jul 2016 17:21:40 +0100
Message-ID: <1467649300-8951-4-git-send-email-salvatore.benedetto@intel.com>
References: <1467649300-8951-1-git-send-email-salvatore.benedetto@intel.com>
Cc: salvatore.benedetto@intel.com, linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:14995 "EHLO mga04.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752829AbcGDQWQ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 4 Jul 2016 12:22:16 -0400
In-Reply-To: <1467649300-8951-1-git-send-email-salvatore.benedetto@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Extend qat driver to use RSA CRT mode when all CRT related components are
present in the private key. Simplify code in qat_rsa_setkey by adding
qat_rsa_clear_ctx.

Signed-off-by: Salvatore Benedetto <salvatore.benedetto@intel.com>
---
 drivers/crypto/qat/qat_common/qat_asym_algs.c | 234 +++++++++++++++++++++++---
 1 file changed, 209 insertions(+), 25 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/qat_asym_algs.c b/drivers/crypto/qat/qat_common/qat_asym_algs.c
index 04b0ef8..eaff02a 100644
--- a/drivers/crypto/qat/qat_common/qat_asym_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_asym_algs.c
@@ -73,6 +73,14 @@ struct qat_rsa_input_params {
 			dma_addr_t d;
 			dma_addr_t n;
 		} dec;
+		struct {
+			dma_addr_t c;
+			dma_addr_t p;
+			dma_addr_t q;
+			dma_addr_t dp;
+			dma_addr_t dq;
+			dma_addr_t qinv;
+		} dec_crt;
 		u64 in_tab[8];
 	};
 } __packed __aligned(64);
@@ -93,10 +101,21 @@ struct qat_rsa_ctx {
 	char *n;
 	char *e;
 	char *d;
+	char *p;
+	char *q;
+	char *dp;
+	char *dq;
+	char *qinv;
 	dma_addr_t dma_n;
 	dma_addr_t dma_e;
 	dma_addr_t dma_d;
+	dma_addr_t dma_p;
+	dma_addr_t dma_q;
+	dma_addr_t dma_dp;
+	dma_addr_t dma_dq;
+	dma_addr_t dma_qinv;
 	unsigned int key_sz;
+	bool crt_mode;
 	struct qat_crypto_instance *inst;
 } __packed __aligned(64);
 
@@ -235,6 +254,35 @@ static unsigned long qat_rsa_dec_fn_id(unsigned int len)
 	};
 }
 
+#define PKE_RSA_DP2_512 0x1c131b57
+#define PKE_RSA_DP2_1024 0x26131c2d
+#define PKE_RSA_DP2_1536 0x45111d12
+#define PKE_RSA_DP2_2048 0x59121dfa
+#define PKE_RSA_DP2_3072 0x81121ed9
+#define PKE_RSA_DP2_4096 0xb1111fb2
+
+static unsigned long qat_rsa_dec_fn_id_crt(unsigned int len)
+{
+	unsigned int bitslen = len << 3;
+
+	switch (bitslen) {
+	case 512:
+		return PKE_RSA_DP2_512;
+	case 1024:
+		return PKE_RSA_DP2_1024;
+	case 1536:
+		return PKE_RSA_DP2_1536;
+	case 2048:
+		return PKE_RSA_DP2_2048;
+	case 3072:
+		return PKE_RSA_DP2_3072;
+	case 4096:
+		return PKE_RSA_DP2_4096;
+	default:
+		return 0;
+	};
+}
+
 static int qat_rsa_enc(struct akcipher_request *req)
 {
 	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
@@ -388,7 +436,9 @@ static int qat_rsa_dec(struct akcipher_request *req)
 	memset(msg, '\0', sizeof(*msg));
 	ICP_QAT_FW_PKE_HDR_VALID_FLAG_SET(msg->pke_hdr,
 					  ICP_QAT_FW_COMN_REQ_FLAG_SET);
-	msg->pke_hdr.cd_pars.func_id = qat_rsa_dec_fn_id(ctx->key_sz);
+	msg->pke_hdr.cd_pars.func_id = ctx->crt_mode ?
+		qat_rsa_dec_fn_id_crt(ctx->key_sz) :
+		qat_rsa_dec_fn_id(ctx->key_sz);
 	if (unlikely(!msg->pke_hdr.cd_pars.func_id))
 		return -EINVAL;
 
@@ -398,8 +448,16 @@ static int qat_rsa_dec(struct akcipher_request *req)
 		ICP_QAT_FW_COMN_FLAGS_BUILD(QAT_COMN_PTR_TYPE_FLAT,
 					    QAT_COMN_CD_FLD_TYPE_64BIT_ADR);
 
-	qat_req->in.dec.d = ctx->dma_d;
-	qat_req->in.dec.n = ctx->dma_n;
+	if (ctx->crt_mode) {
+		qat_req->in.dec_crt.p = ctx->dma_p;
+		qat_req->in.dec_crt.q = ctx->dma_q;
+		qat_req->in.dec_crt.dp = ctx->dma_dp;
+		qat_req->in.dec_crt.dq = ctx->dma_dq;
+		qat_req->in.dec_crt.qinv = ctx->dma_qinv;
+	} else {
+		qat_req->in.dec.d = ctx->dma_d;
+		qat_req->in.dec.n = ctx->dma_n;
+	}
 	ret = -ENOMEM;
 
 	/*
@@ -446,7 +504,10 @@ static int qat_rsa_dec(struct akcipher_request *req)
 
 	}
 
-	qat_req->in.in_tab[3] = 0;
+	if (ctx->crt_mode)
+		qat_req->in.in_tab[6] = 0;
+	else
+		qat_req->in.in_tab[3] = 0;
 	qat_req->out.out_tab[1] = 0;
 	qat_req->phy_in = dma_map_single(dev, &qat_req->in.dec.c,
 					 sizeof(struct qat_rsa_input_params),
@@ -463,7 +524,11 @@ static int qat_rsa_dec(struct akcipher_request *req)
 	msg->pke_mid.src_data_addr = qat_req->phy_in;
 	msg->pke_mid.dest_data_addr = qat_req->phy_out;
 	msg->pke_mid.opaque = (uint64_t)(__force long)req;
-	msg->input_param_count = 3;
+	if (ctx->crt_mode)
+		msg->input_param_count = 6;
+	else
+		msg->input_param_count = 3;
+
 	msg->output_param_count = 1;
 	do {
 		ret = adf_send_message(ctx->inst->pke_tx, (uint32_t *)msg);
@@ -583,13 +648,106 @@ err:
 	return ret;
 }
 
-static int qat_rsa_setkey(struct crypto_akcipher *tfm, const void *key,
-			  unsigned int keylen, bool private)
+static void qat_rsa_drop_leading_zeros(const char **ptr, unsigned int *len)
 {
-	struct qat_rsa_ctx *ctx = akcipher_tfm_ctx(tfm);
-	struct device *dev = &GET_DEV(ctx->inst->accel_dev);
-	struct rsa_key rsa_key;
-	int ret;
+	while (!**ptr && *len) {
+		(*ptr)++;
+		(*len)--;
+	}
+}
+
+static void qat_rsa_setkey_crt(struct qat_rsa_ctx *ctx, struct rsa_key *rsa_key)
+{
+	struct qat_crypto_instance *inst = ctx->inst;
+	struct device *dev = &GET_DEV(inst->accel_dev);
+	const char *ptr;
+	unsigned int len;
+	unsigned int half_key_sz = ctx->key_sz / 2;
+
+	/* p */
+	ptr = rsa_key->p;
+	len = rsa_key->p_sz;
+	qat_rsa_drop_leading_zeros(&ptr, &len);
+	if (!len)
+		goto err;
+	ctx->p = dma_zalloc_coherent(dev, half_key_sz, &ctx->dma_p, GFP_KERNEL);
+	if (!ctx->p)
+		goto err;
+	memcpy(ctx->p + (half_key_sz - len), ptr, len);
+
+	/* q */
+	ptr = rsa_key->q;
+	len = rsa_key->q_sz;
+	qat_rsa_drop_leading_zeros(&ptr, &len);
+	if (!len)
+		goto free_p;
+	ctx->q = dma_zalloc_coherent(dev, half_key_sz, &ctx->dma_q, GFP_KERNEL);
+	if (!ctx->q)
+		goto free_p;
+	memcpy(ctx->q + (half_key_sz - len), ptr, len);
+
+	/* dp */
+	ptr = rsa_key->dp;
+	len = rsa_key->dp_sz;
+	qat_rsa_drop_leading_zeros(&ptr, &len);
+	if (!len)
+		goto free_q;
+	ctx->dp = dma_zalloc_coherent(dev, half_key_sz, &ctx->dma_dp,
+				      GFP_KERNEL);
+	if (!ctx->dp)
+		goto free_q;
+	memcpy(ctx->dp + (half_key_sz - len), ptr, len);
+
+	/* dq */
+	ptr = rsa_key->dq;
+	len = rsa_key->dq_sz;
+	qat_rsa_drop_leading_zeros(&ptr, &len);
+	if (!len)
+		goto free_dp;
+	ctx->dq = dma_zalloc_coherent(dev, half_key_sz, &ctx->dma_dq,
+				      GFP_KERNEL);
+	if (!ctx->dq)
+		goto free_dp;
+	memcpy(ctx->dq + (half_key_sz - len), ptr, len);
+
+	/* qinv */
+	ptr = rsa_key->qinv;
+	len = rsa_key->qinv_sz;
+	qat_rsa_drop_leading_zeros(&ptr, &len);
+	if (!len)
+		goto free_dq;
+	ctx->qinv = dma_zalloc_coherent(dev, half_key_sz, &ctx->dma_qinv,
+					GFP_KERNEL);
+	if (!ctx->qinv)
+		goto free_dq;
+	memcpy(ctx->qinv + (half_key_sz - len), ptr, len);
+
+	ctx->crt_mode = true;
+	return;
+
+free_dq:
+	memset(ctx->dq, '\0', half_key_sz);
+	dma_free_coherent(dev, half_key_sz, ctx->dq, ctx->dma_dq);
+	ctx->dq = NULL;
+free_dp:
+	memset(ctx->dp, '\0', half_key_sz);
+	dma_free_coherent(dev, half_key_sz, ctx->dp, ctx->dma_dp);
+	ctx->dp = NULL;
+free_q:
+	memset(ctx->q, '\0', half_key_sz);
+	dma_free_coherent(dev, half_key_sz, ctx->q, ctx->dma_q);
+	ctx->q = NULL;
+free_p:
+	memset(ctx->p, '\0', half_key_sz);
+	dma_free_coherent(dev, half_key_sz, ctx->p, ctx->dma_p);
+	ctx->p = NULL;
+err:
+	ctx->crt_mode = false;
+}
+
+static void qat_rsa_clear_ctx(struct device *dev, struct qat_rsa_ctx *ctx)
+{
+	unsigned int half_key_sz = ctx->key_sz / 2;
 
 	/* Free the old key if any */
 	if (ctx->n)
@@ -600,10 +758,48 @@ static int qat_rsa_setkey(struct crypto_akcipher *tfm, const void *key,
 		memset(ctx->d, '\0', ctx->key_sz);
 		dma_free_coherent(dev, ctx->key_sz, ctx->d, ctx->dma_d);
 	}
+	if (ctx->p) {
+		memset(ctx->p, '\0', half_key_sz);
+		dma_free_coherent(dev, half_key_sz, ctx->p, ctx->dma_p);
+	}
+	if (ctx->q) {
+		memset(ctx->q, '\0', half_key_sz);
+		dma_free_coherent(dev, half_key_sz, ctx->q, ctx->dma_q);
+	}
+	if (ctx->dp) {
+		memset(ctx->dp, '\0', half_key_sz);
+		dma_free_coherent(dev, half_key_sz, ctx->dp, ctx->dma_dp);
+	}
+	if (ctx->dq) {
+		memset(ctx->dq, '\0', half_key_sz);
+		dma_free_coherent(dev, half_key_sz, ctx->dq, ctx->dma_dq);
+	}
+	if (ctx->qinv) {
+		memset(ctx->qinv, '\0', half_key_sz);
+		dma_free_coherent(dev, half_key_sz, ctx->qinv, ctx->dma_qinv);
+	}
 
 	ctx->n = NULL;
 	ctx->e = NULL;
 	ctx->d = NULL;
+	ctx->p = NULL;
+	ctx->q = NULL;
+	ctx->dp = NULL;
+	ctx->dq = NULL;
+	ctx->qinv = NULL;
+	ctx->crt_mode = false;
+	ctx->key_sz = 0;
+}
+
+static int qat_rsa_setkey(struct crypto_akcipher *tfm, const void *key,
+			  unsigned int keylen, bool private)
+{
+	struct qat_rsa_ctx *ctx = akcipher_tfm_ctx(tfm);
+	struct device *dev = &GET_DEV(ctx->inst->accel_dev);
+	struct rsa_key rsa_key;
+	int ret;
+
+	qat_rsa_clear_ctx(dev, ctx);
 
 	if (private)
 		ret = rsa_parse_priv_key(&rsa_key, key, keylen);
@@ -622,6 +818,7 @@ static int qat_rsa_setkey(struct crypto_akcipher *tfm, const void *key,
 		ret = qat_rsa_set_d(ctx, rsa_key.d, rsa_key.d_sz);
 		if (ret < 0)
 			goto free;
+		qat_rsa_setkey_crt(ctx, &rsa_key);
 	}
 
 	if (!ctx->n || !ctx->e) {
@@ -637,20 +834,7 @@ static int qat_rsa_setkey(struct crypto_akcipher *tfm, const void *key,
 
 	return 0;
 free:
-	if (ctx->d) {
-		memset(ctx->d, '\0', ctx->key_sz);
-		dma_free_coherent(dev, ctx->key_sz, ctx->d, ctx->dma_d);
-		ctx->d = NULL;
-	}
-	if (ctx->e) {
-		dma_free_coherent(dev, ctx->key_sz, ctx->e, ctx->dma_e);
-		ctx->e = NULL;
-	}
-	if (ctx->n) {
-		dma_free_coherent(dev, ctx->key_sz, ctx->n, ctx->dma_n);
-		ctx->n = NULL;
-		ctx->key_sz = 0;
-	}
+	qat_rsa_clear_ctx(dev, ctx);
 	return ret;
 }
 
-- 
2.7.4
