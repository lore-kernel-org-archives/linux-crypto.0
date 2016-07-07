From: Salvatore Benedetto <salvatore.benedetto@intel.com>
Subject: [PATCH] crypto: qat - Add DH support
Date: Thu,  7 Jul 2016 15:27:29 +0100
Message-ID: <1467901649-7287-1-git-send-email-salvatore.benedetto@intel.com>
Cc: salvatore.benedetto@intel.com, linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:5549 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751635AbcGGO1q (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 7 Jul 2016 10:27:46 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add DH support under kpp api. Drop struct qat_rsa_request and
introduce a more generic struct qat_asym_request and share it
between RSA and DH requests.

Signed-off-by: Salvatore Benedetto <salvatore.benedetto@intel.com>
---
 drivers/crypto/qat/Kconfig                    |   1 +
 drivers/crypto/qat/qat_common/qat_asym_algs.c | 593 ++++++++++++++++++++++----
 2 files changed, 522 insertions(+), 72 deletions(-)

diff --git a/drivers/crypto/qat/Kconfig b/drivers/crypto/qat/Kconfig
index 571d04d..ce3cae4 100644
--- a/drivers/crypto/qat/Kconfig
+++ b/drivers/crypto/qat/Kconfig
@@ -4,6 +4,7 @@ config CRYPTO_DEV_QAT
 	select CRYPTO_AUTHENC
 	select CRYPTO_BLKCIPHER
 	select CRYPTO_AKCIPHER
+	select CRYPTO_DH
 	select CRYPTO_HMAC
 	select CRYPTO_RSA
 	select CRYPTO_SHA1
diff --git a/drivers/crypto/qat/qat_common/qat_asym_algs.c b/drivers/crypto/qat/qat_common/qat_asym_algs.c
index eaff02a..3d56fb8 100644
--- a/drivers/crypto/qat/qat_common/qat_asym_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_asym_algs.c
@@ -49,6 +49,9 @@
 #include <crypto/internal/rsa.h>
 #include <crypto/internal/akcipher.h>
 #include <crypto/akcipher.h>
+#include <crypto/kpp.h>
+#include <crypto/internal/kpp.h>
+#include <crypto/dh.h>
 #include <linux/dma-mapping.h>
 #include <linux/fips.h>
 #include <crypto/scatterwalk.h>
@@ -119,36 +122,454 @@ struct qat_rsa_ctx {
 	struct qat_crypto_instance *inst;
 } __packed __aligned(64);
 
-struct qat_rsa_request {
-	struct qat_rsa_input_params in;
-	struct qat_rsa_output_params out;
+struct qat_dh_input_params {
+	union {
+		struct {
+			dma_addr_t b;
+			dma_addr_t xa;
+			dma_addr_t p;
+		} in;
+		struct {
+			dma_addr_t xa;
+			dma_addr_t p;
+		} in_g2;
+		u64 in_tab[8];
+	};
+} __packed __aligned(64);
+
+struct qat_dh_output_params {
+	union {
+		dma_addr_t r;
+		u64 out_tab[8];
+	};
+} __packed __aligned(64);
+
+struct qat_dh_ctx {
+	char *g;
+	char *xa;
+	char *p;
+	dma_addr_t dma_g;
+	dma_addr_t dma_xa;
+	dma_addr_t dma_p;
+	unsigned int p_size;
+	bool g2;
+	struct qat_crypto_instance *inst;
+} __packed __aligned(64);
+
+struct qat_asym_request {
+	union {
+		struct qat_rsa_input_params rsa;
+		struct qat_dh_input_params dh;
+	} in;
+	union {
+		struct qat_rsa_output_params rsa;
+		struct qat_dh_output_params dh;
+	} out;
 	dma_addr_t phy_in;
 	dma_addr_t phy_out;
 	char *src_align;
 	char *dst_align;
 	struct icp_qat_fw_pke_request req;
-	struct qat_rsa_ctx *ctx;
+	union {
+		struct qat_rsa_ctx *rsa;
+		struct qat_dh_ctx *dh;
+	} ctx;
+	union {
+		struct akcipher_request *rsa;
+		struct kpp_request *dh;
+	} areq;
 	int err;
+	void (*cb)(struct icp_qat_fw_pke_resp *resp);
 } __aligned(64);
 
+static void qat_dh_cb(struct icp_qat_fw_pke_resp *resp)
+{
+	struct qat_asym_request *req = (void *)(__force long)resp->opaque;
+	struct kpp_request *areq = req->areq.dh;
+	struct device *dev = &GET_DEV(req->ctx.dh->inst->accel_dev);
+	int err = ICP_QAT_FW_PKE_RESP_PKE_STAT_GET(
+				resp->pke_resp_hdr.comn_resp_flags);
+
+	err = (err == ICP_QAT_FW_COMN_STATUS_FLAG_OK) ? 0 : -EINVAL;
+
+	if (areq->src) {
+		if (req->src_align)
+			dma_free_coherent(dev, req->ctx.dh->p_size,
+					  req->src_align, req->in.dh.in.b);
+		else
+			dma_unmap_single(dev, req->in.dh.in.b,
+					 req->ctx.dh->p_size, DMA_TO_DEVICE);
+	}
+
+	areq->dst_len = req->ctx.dh->p_size;
+	if (req->dst_align) {
+		scatterwalk_map_and_copy(req->dst_align, areq->dst, 0,
+					 areq->dst_len, 1);
+
+		dma_free_coherent(dev, req->ctx.dh->p_size, req->dst_align,
+				  req->out.dh.r);
+	} else {
+		dma_unmap_single(dev, req->out.dh.r, req->ctx.dh->p_size,
+				 DMA_FROM_DEVICE);
+	}
+
+	dma_unmap_single(dev, req->phy_in, sizeof(struct qat_dh_input_params),
+			 DMA_TO_DEVICE);
+	dma_unmap_single(dev, req->phy_out,
+			 sizeof(struct qat_dh_output_params),
+			 DMA_TO_DEVICE);
+
+	kpp_request_complete(areq, err);
+}
+
+#define PKE_DH_1536 0x390c1a49
+#define PKE_DH_G2_1536 0x2e0b1a3e
+#define PKE_DH_2048 0x4d0c1a60
+#define PKE_DH_G2_2048 0x3e0b1a55
+#define PKE_DH_3072 0x510c1a77
+#define PKE_DH_G2_3072 0x3a0b1a6c
+#define PKE_DH_4096 0x690c1a8e
+#define PKE_DH_G2_4096 0x4a0b1a83
+
+static unsigned long qat_dh_fn_id(unsigned int len, bool g2)
+{
+	unsigned int bitslen = len << 3;
+
+	switch (bitslen) {
+	case 1536:
+		return g2 ? PKE_DH_G2_1536 : PKE_DH_1536;
+	case 2048:
+		return g2 ? PKE_DH_G2_2048 : PKE_DH_2048;
+	case 3072:
+		return g2 ? PKE_DH_G2_3072 : PKE_DH_3072;
+	case 4096:
+		return g2 ? PKE_DH_G2_4096 : PKE_DH_4096;
+	default:
+		return 0;
+	};
+}
+
+static inline struct qat_dh_ctx *qat_dh_get_params(struct crypto_kpp *tfm)
+{
+	return kpp_tfm_ctx(tfm);
+}
+
+static int qat_dh_compute_value(struct kpp_request *req)
+{
+	struct crypto_kpp *tfm = crypto_kpp_reqtfm(req);
+	struct qat_dh_ctx *ctx = kpp_tfm_ctx(tfm);
+	struct qat_crypto_instance *inst = ctx->inst;
+	struct device *dev = &GET_DEV(inst->accel_dev);
+	struct qat_asym_request *qat_req =
+			PTR_ALIGN(kpp_request_ctx(req), 64);
+	struct icp_qat_fw_pke_request *msg = &qat_req->req;
+	int ret, ctr = 0;
+	int n_input_params = 0;
+
+	if (unlikely(!ctx->xa))
+		return -EINVAL;
+
+	if (req->dst_len < ctx->p_size) {
+		req->dst_len = ctx->p_size;
+		return -EOVERFLOW;
+	}
+	memset(msg, '\0', sizeof(*msg));
+	ICP_QAT_FW_PKE_HDR_VALID_FLAG_SET(msg->pke_hdr,
+					  ICP_QAT_FW_COMN_REQ_FLAG_SET);
+
+	msg->pke_hdr.cd_pars.func_id = qat_dh_fn_id(ctx->p_size,
+						    !req->src && ctx->g2);
+	if (unlikely(!msg->pke_hdr.cd_pars.func_id))
+		return -EINVAL;
+
+	qat_req->cb = qat_dh_cb;
+	qat_req->ctx.dh = ctx;
+	qat_req->areq.dh = req;
+	msg->pke_hdr.service_type = ICP_QAT_FW_COMN_REQ_CPM_FW_PKE;
+	msg->pke_hdr.comn_req_flags =
+		ICP_QAT_FW_COMN_FLAGS_BUILD(QAT_COMN_PTR_TYPE_FLAT,
+					    QAT_COMN_CD_FLD_TYPE_64BIT_ADR);
+
+	/*
+	 * If no source is provided use g as base
+	 */
+	if (req->src) {
+		qat_req->in.dh.in.xa = ctx->dma_xa;
+		qat_req->in.dh.in.p = ctx->dma_p;
+		n_input_params = 3;
+	} else {
+		if (ctx->g2) {
+			qat_req->in.dh.in_g2.xa = ctx->dma_xa;
+			qat_req->in.dh.in_g2.p = ctx->dma_p;
+			n_input_params = 2;
+		} else {
+			qat_req->in.dh.in.b = ctx->dma_g;
+			qat_req->in.dh.in.xa = ctx->dma_xa;
+			qat_req->in.dh.in.p = ctx->dma_p;
+			n_input_params = 3;
+		}
+	}
+
+	ret = -ENOMEM;
+	if (req->src) {
+		/*
+		 * src can be of any size in valid range, but HW expects it to
+		 * be the same as modulo p so in case it is different we need
+		 * to allocate a new buf and copy src data.
+		 * In other case we just need to map the user provided buffer.
+		 * Also need to make sure that it is in contiguous buffer.
+		 */
+		if (sg_is_last(req->src) && req->src_len == ctx->p_size) {
+			qat_req->src_align = NULL;
+			qat_req->in.dh.in.b = dma_map_single(dev,
+							     sg_virt(req->src),
+							     req->src_len,
+							     DMA_TO_DEVICE);
+			if (unlikely(dma_mapping_error(dev,
+						       qat_req->in.dh.in.b)))
+				return ret;
+
+		} else {
+			int shift = ctx->p_size - req->src_len;
+
+			qat_req->src_align = dma_zalloc_coherent(dev,
+								 ctx->p_size,
+								 &qat_req->in.dh.in.b,
+								 GFP_KERNEL);
+			if (unlikely(!qat_req->src_align))
+				return ret;
+
+			scatterwalk_map_and_copy(qat_req->src_align + shift,
+						 req->src, 0, req->src_len, 0);
+		}
+	}
+	/*
+	 * dst can be of any size in valid range, but HW expects it to be the
+	 * same as modulo m so in case it is different we need to allocate a
+	 * new buf and copy src data.
+	 * In other case we just need to map the user provided buffer.
+	 * Also need to make sure that it is in contiguous buffer.
+	 */
+	if (sg_is_last(req->dst) && req->dst_len == ctx->p_size) {
+		qat_req->dst_align = NULL;
+		qat_req->out.dh.r = dma_map_single(dev, sg_virt(req->dst),
+						   req->dst_len,
+						   DMA_FROM_DEVICE);
+
+		if (unlikely(dma_mapping_error(dev, qat_req->out.dh.r)))
+			goto unmap_src;
+
+	} else {
+		qat_req->dst_align = dma_zalloc_coherent(dev, ctx->p_size,
+							 &qat_req->out.dh.r,
+							 GFP_KERNEL);
+		if (unlikely(!qat_req->dst_align))
+			goto unmap_src;
+	}
+
+	qat_req->in.dh.in_tab[n_input_params] = 0;
+	qat_req->out.dh.out_tab[1] = 0;
+	/* Mapping in.in.b or in.in_g2.xa is the same */
+	qat_req->phy_in = dma_map_single(dev, &qat_req->in.dh.in.b,
+					 sizeof(struct qat_dh_input_params),
+					 DMA_TO_DEVICE);
+	if (unlikely(dma_mapping_error(dev, qat_req->phy_in)))
+		goto unmap_dst;
+
+	qat_req->phy_out = dma_map_single(dev, &qat_req->out.dh.r,
+					  sizeof(struct qat_dh_output_params),
+					  DMA_TO_DEVICE);
+	if (unlikely(dma_mapping_error(dev, qat_req->phy_out)))
+		goto unmap_in_params;
+
+	msg->pke_mid.src_data_addr = qat_req->phy_in;
+	msg->pke_mid.dest_data_addr = qat_req->phy_out;
+	msg->pke_mid.opaque = (uint64_t)(__force long)qat_req;
+	msg->input_param_count = n_input_params;
+	msg->output_param_count = 1;
+
+	do {
+		ret = adf_send_message(ctx->inst->pke_tx, (uint32_t *)msg);
+	} while (ret == -EBUSY && ctr++ < 100);
+
+	if (!ret)
+		return -EINPROGRESS;
+
+	if (!dma_mapping_error(dev, qat_req->phy_out))
+		dma_unmap_single(dev, qat_req->phy_out,
+				 sizeof(struct qat_dh_output_params),
+				 DMA_TO_DEVICE);
+unmap_in_params:
+	if (!dma_mapping_error(dev, qat_req->phy_in))
+		dma_unmap_single(dev, qat_req->phy_in,
+				 sizeof(struct qat_dh_input_params),
+				 DMA_TO_DEVICE);
+unmap_dst:
+	if (qat_req->dst_align)
+		dma_free_coherent(dev, ctx->p_size, qat_req->dst_align,
+				  qat_req->out.dh.r);
+	else
+		if (!dma_mapping_error(dev, qat_req->out.dh.r))
+			dma_unmap_single(dev, qat_req->out.dh.r, ctx->p_size,
+					 DMA_FROM_DEVICE);
+unmap_src:
+	if (req->src) {
+		if (qat_req->src_align)
+			dma_free_coherent(dev, ctx->p_size, qat_req->src_align,
+					  qat_req->in.dh.in.b);
+		else
+			if (!dma_mapping_error(dev, qat_req->in.dh.in.b))
+				dma_unmap_single(dev, qat_req->in.dh.in.b,
+						 ctx->p_size,
+						 DMA_TO_DEVICE);
+	}
+	return ret;
+}
+
+static int qat_dh_check_params_length(unsigned int p_len)
+{
+	switch (p_len) {
+	case 1536:
+	case 2048:
+	case 3072:
+	case 4096:
+		return 0;
+	}
+	return -EINVAL;
+}
+
+static int qat_dh_set_params(struct qat_dh_ctx *ctx, struct dh *params)
+{
+	struct qat_crypto_instance *inst = ctx->inst;
+	struct device *dev = &GET_DEV(inst->accel_dev);
+
+	if (unlikely(!params->p || !params->g))
+		return -EINVAL;
+
+	if (qat_dh_check_params_length(params->p_size << 3))
+		return -EINVAL;
+
+	ctx->p_size = params->p_size;
+	ctx->p = dma_zalloc_coherent(dev, ctx->p_size, &ctx->dma_p, GFP_KERNEL);
+	if (!ctx->p)
+		return -ENOMEM;
+	memcpy(ctx->p, params->p, ctx->p_size);
+
+	/* If g equals 2 don't copy it */
+	if (params->g_size == 1 && *(char *)params->g == 0x02) {
+		ctx->g2 = true;
+		return 0;
+	}
+
+	ctx->g = dma_zalloc_coherent(dev, ctx->p_size, &ctx->dma_g, GFP_KERNEL);
+	if (!ctx->g) {
+		dma_free_coherent(dev, ctx->p_size, ctx->p, ctx->dma_p);
+		ctx->p = NULL;
+		return -ENOMEM;
+	}
+	memcpy(ctx->g + (ctx->p_size - params->g_size), params->g,
+	       params->g_size);
+
+	return 0;
+}
+
+static void qat_dh_clear_ctx(struct device *dev, struct qat_dh_ctx *ctx)
+{
+	if (ctx->g) {
+		dma_free_coherent(dev, ctx->p_size, ctx->g, ctx->dma_g);
+		ctx->g = NULL;
+	}
+	if (ctx->xa) {
+		dma_free_coherent(dev, ctx->p_size, ctx->xa, ctx->dma_xa);
+		ctx->xa = NULL;
+	}
+	if (ctx->p) {
+		dma_free_coherent(dev, ctx->p_size, ctx->p, ctx->dma_p);
+		ctx->p = NULL;
+	}
+	ctx->p_size = 0;
+	ctx->g2 = false;
+}
+
+static int qat_dh_set_secret(struct crypto_kpp *tfm, void *buf,
+			     unsigned int len)
+{
+	struct qat_dh_ctx *ctx = kpp_tfm_ctx(tfm);
+	struct device *dev = &GET_DEV(ctx->inst->accel_dev);
+	struct dh params;
+	int ret;
+
+	if (crypto_dh_decode_key(buf, len, &params) < 0)
+		return -EINVAL;
+
+	/* Free old secret if any */
+	qat_dh_clear_ctx(dev, ctx);
+
+	ret = qat_dh_set_params(ctx, &params);
+	if (ret < 0)
+		return ret;
+
+	ctx->xa = dma_zalloc_coherent(dev, ctx->p_size, &ctx->dma_xa,
+				      GFP_KERNEL);
+	if (!ctx->xa) {
+		qat_dh_clear_ctx(dev, ctx);
+		return -ENOMEM;
+	}
+	memcpy(ctx->xa + (ctx->p_size - params.key_size), params.key,
+	       params.key_size);
+
+	return 0;
+}
+
+static int qat_dh_max_size(struct crypto_kpp *tfm)
+{
+	struct qat_dh_ctx *ctx = kpp_tfm_ctx(tfm);
+
+	return ctx->p ? ctx->p_size : -EINVAL;
+}
+
+static int qat_dh_init_tfm(struct crypto_kpp *tfm)
+{
+	struct qat_dh_ctx *ctx = kpp_tfm_ctx(tfm);
+	struct qat_crypto_instance *inst =
+			qat_crypto_get_instance_node(get_current_node());
+
+	if (!inst)
+		return -EINVAL;
+
+	ctx->p_size = 0;
+	ctx->g2 = false;
+	ctx->inst = inst;
+	return 0;
+}
+
+static void qat_dh_exit_tfm(struct crypto_kpp *tfm)
+{
+	struct qat_dh_ctx *ctx = kpp_tfm_ctx(tfm);
+	struct device *dev = &GET_DEV(ctx->inst->accel_dev);
+
+	qat_dh_clear_ctx(dev, ctx);
+	qat_crypto_put_instance(ctx->inst);
+}
+
 static void qat_rsa_cb(struct icp_qat_fw_pke_resp *resp)
 {
-	struct akcipher_request *areq = (void *)(__force long)resp->opaque;
-	struct qat_rsa_request *req = PTR_ALIGN(akcipher_request_ctx(areq), 64);
-	struct device *dev = &GET_DEV(req->ctx->inst->accel_dev);
+	struct qat_asym_request *req = (void *)(__force long)resp->opaque;
+	struct akcipher_request *areq = req->areq.rsa;
+	struct device *dev = &GET_DEV(req->ctx.rsa->inst->accel_dev);
 	int err = ICP_QAT_FW_PKE_RESP_PKE_STAT_GET(
 				resp->pke_resp_hdr.comn_resp_flags);
 
 	err = (err == ICP_QAT_FW_COMN_STATUS_FLAG_OK) ? 0 : -EINVAL;
 
 	if (req->src_align)
-		dma_free_coherent(dev, req->ctx->key_sz, req->src_align,
-				  req->in.enc.m);
+		dma_free_coherent(dev, req->ctx.rsa->key_sz, req->src_align,
+				  req->in.rsa.enc.m);
 	else
-		dma_unmap_single(dev, req->in.enc.m, req->ctx->key_sz,
+		dma_unmap_single(dev, req->in.rsa.enc.m, req->ctx.rsa->key_sz,
 				 DMA_TO_DEVICE);
 
-	areq->dst_len = req->ctx->key_sz;
+	areq->dst_len = req->ctx.rsa->key_sz;
 	if (req->dst_align) {
 		char *ptr = req->dst_align;
 
@@ -157,14 +578,14 @@ static void qat_rsa_cb(struct icp_qat_fw_pke_resp *resp)
 			ptr++;
 		}
 
-		if (areq->dst_len != req->ctx->key_sz)
+		if (areq->dst_len != req->ctx.rsa->key_sz)
 			memmove(req->dst_align, ptr, areq->dst_len);
 
 		scatterwalk_map_and_copy(req->dst_align, areq->dst, 0,
 					 areq->dst_len, 1);
 
-		dma_free_coherent(dev, req->ctx->key_sz, req->dst_align,
-				  req->out.enc.c);
+		dma_free_coherent(dev, req->ctx.rsa->key_sz, req->dst_align,
+				  req->out.rsa.enc.c);
 	} else {
 		char *ptr = sg_virt(areq->dst);
 
@@ -176,7 +597,7 @@ static void qat_rsa_cb(struct icp_qat_fw_pke_resp *resp)
 		if (sg_virt(areq->dst) != ptr && areq->dst_len)
 			memmove(sg_virt(areq->dst), ptr, areq->dst_len);
 
-		dma_unmap_single(dev, req->out.enc.c, req->ctx->key_sz,
+		dma_unmap_single(dev, req->out.rsa.enc.c, req->ctx.rsa->key_sz,
 				 DMA_FROM_DEVICE);
 	}
 
@@ -192,8 +613,9 @@ static void qat_rsa_cb(struct icp_qat_fw_pke_resp *resp)
 void qat_alg_asym_callback(void *_resp)
 {
 	struct icp_qat_fw_pke_resp *resp = _resp;
+	struct qat_asym_request *areq = (void *)(__force long)resp->opaque;
 
-	qat_rsa_cb(resp);
+	areq->cb(resp);
 }
 
 #define PKE_RSA_EP_512 0x1c161b21
@@ -289,7 +711,7 @@ static int qat_rsa_enc(struct akcipher_request *req)
 	struct qat_rsa_ctx *ctx = akcipher_tfm_ctx(tfm);
 	struct qat_crypto_instance *inst = ctx->inst;
 	struct device *dev = &GET_DEV(inst->accel_dev);
-	struct qat_rsa_request *qat_req =
+	struct qat_asym_request *qat_req =
 			PTR_ALIGN(akcipher_request_ctx(req), 64);
 	struct icp_qat_fw_pke_request *msg = &qat_req->req;
 	int ret, ctr = 0;
@@ -308,14 +730,16 @@ static int qat_rsa_enc(struct akcipher_request *req)
 	if (unlikely(!msg->pke_hdr.cd_pars.func_id))
 		return -EINVAL;
 
-	qat_req->ctx = ctx;
+	qat_req->cb = qat_rsa_cb;
+	qat_req->ctx.rsa = ctx;
+	qat_req->areq.rsa = req;
 	msg->pke_hdr.service_type = ICP_QAT_FW_COMN_REQ_CPM_FW_PKE;
 	msg->pke_hdr.comn_req_flags =
 		ICP_QAT_FW_COMN_FLAGS_BUILD(QAT_COMN_PTR_TYPE_FLAT,
 					    QAT_COMN_CD_FLD_TYPE_64BIT_ADR);
 
-	qat_req->in.enc.e = ctx->dma_e;
-	qat_req->in.enc.n = ctx->dma_n;
+	qat_req->in.rsa.enc.e = ctx->dma_e;
+	qat_req->in.rsa.enc.n = ctx->dma_n;
 	ret = -ENOMEM;
 
 	/*
@@ -327,16 +751,16 @@ static int qat_rsa_enc(struct akcipher_request *req)
 	 */
 	if (sg_is_last(req->src) && req->src_len == ctx->key_sz) {
 		qat_req->src_align = NULL;
-		qat_req->in.enc.m = dma_map_single(dev, sg_virt(req->src),
+		qat_req->in.rsa.enc.m = dma_map_single(dev, sg_virt(req->src),
 						   req->src_len, DMA_TO_DEVICE);
-		if (unlikely(dma_mapping_error(dev, qat_req->in.enc.m)))
+		if (unlikely(dma_mapping_error(dev, qat_req->in.rsa.enc.m)))
 			return ret;
 
 	} else {
 		int shift = ctx->key_sz - req->src_len;
 
 		qat_req->src_align = dma_zalloc_coherent(dev, ctx->key_sz,
-							 &qat_req->in.enc.m,
+							 &qat_req->in.rsa.enc.m,
 							 GFP_KERNEL);
 		if (unlikely(!qat_req->src_align))
 			return ret;
@@ -346,30 +770,30 @@ static int qat_rsa_enc(struct akcipher_request *req)
 	}
 	if (sg_is_last(req->dst) && req->dst_len == ctx->key_sz) {
 		qat_req->dst_align = NULL;
-		qat_req->out.enc.c = dma_map_single(dev, sg_virt(req->dst),
-						    req->dst_len,
-						    DMA_FROM_DEVICE);
+		qat_req->out.rsa.enc.c = dma_map_single(dev, sg_virt(req->dst),
+							req->dst_len,
+							DMA_FROM_DEVICE);
 
-		if (unlikely(dma_mapping_error(dev, qat_req->out.enc.c)))
+		if (unlikely(dma_mapping_error(dev, qat_req->out.rsa.enc.c)))
 			goto unmap_src;
 
 	} else {
 		qat_req->dst_align = dma_zalloc_coherent(dev, ctx->key_sz,
-							 &qat_req->out.enc.c,
+							 &qat_req->out.rsa.enc.c,
 							 GFP_KERNEL);
 		if (unlikely(!qat_req->dst_align))
 			goto unmap_src;
 
 	}
-	qat_req->in.in_tab[3] = 0;
-	qat_req->out.out_tab[1] = 0;
-	qat_req->phy_in = dma_map_single(dev, &qat_req->in.enc.m,
+	qat_req->in.rsa.in_tab[3] = 0;
+	qat_req->out.rsa.out_tab[1] = 0;
+	qat_req->phy_in = dma_map_single(dev, &qat_req->in.rsa.enc.m,
 					 sizeof(struct qat_rsa_input_params),
 					 DMA_TO_DEVICE);
 	if (unlikely(dma_mapping_error(dev, qat_req->phy_in)))
 		goto unmap_dst;
 
-	qat_req->phy_out = dma_map_single(dev, &qat_req->out.enc.c,
+	qat_req->phy_out = dma_map_single(dev, &qat_req->out.rsa.enc.c,
 					  sizeof(struct qat_rsa_output_params),
 					  DMA_TO_DEVICE);
 	if (unlikely(dma_mapping_error(dev, qat_req->phy_out)))
@@ -377,7 +801,7 @@ static int qat_rsa_enc(struct akcipher_request *req)
 
 	msg->pke_mid.src_data_addr = qat_req->phy_in;
 	msg->pke_mid.dest_data_addr = qat_req->phy_out;
-	msg->pke_mid.opaque = (uint64_t)(__force long)req;
+	msg->pke_mid.opaque = (uint64_t)(__force long)qat_req;
 	msg->input_param_count = 3;
 	msg->output_param_count = 1;
 	do {
@@ -399,19 +823,19 @@ unmap_in_params:
 unmap_dst:
 	if (qat_req->dst_align)
 		dma_free_coherent(dev, ctx->key_sz, qat_req->dst_align,
-				  qat_req->out.enc.c);
+				  qat_req->out.rsa.enc.c);
 	else
-		if (!dma_mapping_error(dev, qat_req->out.enc.c))
-			dma_unmap_single(dev, qat_req->out.enc.c, ctx->key_sz,
-					 DMA_FROM_DEVICE);
+		if (!dma_mapping_error(dev, qat_req->out.rsa.enc.c))
+			dma_unmap_single(dev, qat_req->out.rsa.enc.c,
+					 ctx->key_sz, DMA_FROM_DEVICE);
 unmap_src:
 	if (qat_req->src_align)
 		dma_free_coherent(dev, ctx->key_sz, qat_req->src_align,
-				  qat_req->in.enc.m);
+				  qat_req->in.rsa.enc.m);
 	else
-		if (!dma_mapping_error(dev, qat_req->in.enc.m))
-			dma_unmap_single(dev, qat_req->in.enc.m, ctx->key_sz,
-					 DMA_TO_DEVICE);
+		if (!dma_mapping_error(dev, qat_req->in.rsa.enc.m))
+			dma_unmap_single(dev, qat_req->in.rsa.enc.m,
+					 ctx->key_sz, DMA_TO_DEVICE);
 	return ret;
 }
 
@@ -421,7 +845,7 @@ static int qat_rsa_dec(struct akcipher_request *req)
 	struct qat_rsa_ctx *ctx = akcipher_tfm_ctx(tfm);
 	struct qat_crypto_instance *inst = ctx->inst;
 	struct device *dev = &GET_DEV(inst->accel_dev);
-	struct qat_rsa_request *qat_req =
+	struct qat_asym_request *qat_req =
 			PTR_ALIGN(akcipher_request_ctx(req), 64);
 	struct icp_qat_fw_pke_request *msg = &qat_req->req;
 	int ret, ctr = 0;
@@ -442,21 +866,23 @@ static int qat_rsa_dec(struct akcipher_request *req)
 	if (unlikely(!msg->pke_hdr.cd_pars.func_id))
 		return -EINVAL;
 
-	qat_req->ctx = ctx;
+	qat_req->cb = qat_rsa_cb;
+	qat_req->ctx.rsa = ctx;
+	qat_req->areq.rsa = req;
 	msg->pke_hdr.service_type = ICP_QAT_FW_COMN_REQ_CPM_FW_PKE;
 	msg->pke_hdr.comn_req_flags =
 		ICP_QAT_FW_COMN_FLAGS_BUILD(QAT_COMN_PTR_TYPE_FLAT,
 					    QAT_COMN_CD_FLD_TYPE_64BIT_ADR);
 
 	if (ctx->crt_mode) {
-		qat_req->in.dec_crt.p = ctx->dma_p;
-		qat_req->in.dec_crt.q = ctx->dma_q;
-		qat_req->in.dec_crt.dp = ctx->dma_dp;
-		qat_req->in.dec_crt.dq = ctx->dma_dq;
-		qat_req->in.dec_crt.qinv = ctx->dma_qinv;
+		qat_req->in.rsa.dec_crt.p = ctx->dma_p;
+		qat_req->in.rsa.dec_crt.q = ctx->dma_q;
+		qat_req->in.rsa.dec_crt.dp = ctx->dma_dp;
+		qat_req->in.rsa.dec_crt.dq = ctx->dma_dq;
+		qat_req->in.rsa.dec_crt.qinv = ctx->dma_qinv;
 	} else {
-		qat_req->in.dec.d = ctx->dma_d;
-		qat_req->in.dec.n = ctx->dma_n;
+		qat_req->in.rsa.dec.d = ctx->dma_d;
+		qat_req->in.rsa.dec.n = ctx->dma_n;
 	}
 	ret = -ENOMEM;
 
@@ -469,16 +895,16 @@ static int qat_rsa_dec(struct akcipher_request *req)
 	 */
 	if (sg_is_last(req->src) && req->src_len == ctx->key_sz) {
 		qat_req->src_align = NULL;
-		qat_req->in.dec.c = dma_map_single(dev, sg_virt(req->src),
+		qat_req->in.rsa.dec.c = dma_map_single(dev, sg_virt(req->src),
 						   req->dst_len, DMA_TO_DEVICE);
-		if (unlikely(dma_mapping_error(dev, qat_req->in.dec.c)))
+		if (unlikely(dma_mapping_error(dev, qat_req->in.rsa.dec.c)))
 			return ret;
 
 	} else {
 		int shift = ctx->key_sz - req->src_len;
 
 		qat_req->src_align = dma_zalloc_coherent(dev, ctx->key_sz,
-							 &qat_req->in.dec.c,
+							 &qat_req->in.rsa.dec.c,
 							 GFP_KERNEL);
 		if (unlikely(!qat_req->src_align))
 			return ret;
@@ -488,16 +914,16 @@ static int qat_rsa_dec(struct akcipher_request *req)
 	}
 	if (sg_is_last(req->dst) && req->dst_len == ctx->key_sz) {
 		qat_req->dst_align = NULL;
-		qat_req->out.dec.m = dma_map_single(dev, sg_virt(req->dst),
+		qat_req->out.rsa.dec.m = dma_map_single(dev, sg_virt(req->dst),
 						    req->dst_len,
 						    DMA_FROM_DEVICE);
 
-		if (unlikely(dma_mapping_error(dev, qat_req->out.dec.m)))
+		if (unlikely(dma_mapping_error(dev, qat_req->out.rsa.dec.m)))
 			goto unmap_src;
 
 	} else {
 		qat_req->dst_align = dma_zalloc_coherent(dev, ctx->key_sz,
-							 &qat_req->out.dec.m,
+							 &qat_req->out.rsa.dec.m,
 							 GFP_KERNEL);
 		if (unlikely(!qat_req->dst_align))
 			goto unmap_src;
@@ -505,17 +931,17 @@ static int qat_rsa_dec(struct akcipher_request *req)
 	}
 
 	if (ctx->crt_mode)
-		qat_req->in.in_tab[6] = 0;
+		qat_req->in.rsa.in_tab[6] = 0;
 	else
-		qat_req->in.in_tab[3] = 0;
-	qat_req->out.out_tab[1] = 0;
-	qat_req->phy_in = dma_map_single(dev, &qat_req->in.dec.c,
+		qat_req->in.rsa.in_tab[3] = 0;
+	qat_req->out.rsa.out_tab[1] = 0;
+	qat_req->phy_in = dma_map_single(dev, &qat_req->in.rsa.dec.c,
 					 sizeof(struct qat_rsa_input_params),
 					 DMA_TO_DEVICE);
 	if (unlikely(dma_mapping_error(dev, qat_req->phy_in)))
 		goto unmap_dst;
 
-	qat_req->phy_out = dma_map_single(dev, &qat_req->out.dec.m,
+	qat_req->phy_out = dma_map_single(dev, &qat_req->out.rsa.dec.m,
 					  sizeof(struct qat_rsa_output_params),
 					  DMA_TO_DEVICE);
 	if (unlikely(dma_mapping_error(dev, qat_req->phy_out)))
@@ -523,7 +949,7 @@ static int qat_rsa_dec(struct akcipher_request *req)
 
 	msg->pke_mid.src_data_addr = qat_req->phy_in;
 	msg->pke_mid.dest_data_addr = qat_req->phy_out;
-	msg->pke_mid.opaque = (uint64_t)(__force long)req;
+	msg->pke_mid.opaque = (uint64_t)(__force long)qat_req;
 	if (ctx->crt_mode)
 		msg->input_param_count = 6;
 	else
@@ -549,19 +975,19 @@ unmap_in_params:
 unmap_dst:
 	if (qat_req->dst_align)
 		dma_free_coherent(dev, ctx->key_sz, qat_req->dst_align,
-				  qat_req->out.dec.m);
+				  qat_req->out.rsa.dec.m);
 	else
-		if (!dma_mapping_error(dev, qat_req->out.dec.m))
-			dma_unmap_single(dev, qat_req->out.dec.m, ctx->key_sz,
-					 DMA_FROM_DEVICE);
+		if (!dma_mapping_error(dev, qat_req->out.rsa.dec.m))
+			dma_unmap_single(dev, qat_req->out.rsa.dec.m,
+					 ctx->key_sz, DMA_FROM_DEVICE);
 unmap_src:
 	if (qat_req->src_align)
 		dma_free_coherent(dev, ctx->key_sz, qat_req->src_align,
-				  qat_req->in.dec.c);
+				  qat_req->in.rsa.dec.c);
 	else
-		if (!dma_mapping_error(dev, qat_req->in.dec.c))
-			dma_unmap_single(dev, qat_req->in.dec.c, ctx->key_sz,
-					 DMA_TO_DEVICE);
+		if (!dma_mapping_error(dev, qat_req->in.rsa.dec.c))
+			dma_unmap_single(dev, qat_req->in.rsa.dec.c,
+					 ctx->key_sz, DMA_TO_DEVICE);
 	return ret;
 }
 
@@ -900,7 +1326,7 @@ static struct akcipher_alg rsa = {
 	.max_size = qat_rsa_max_size,
 	.init = qat_rsa_init_tfm,
 	.exit = qat_rsa_exit_tfm,
-	.reqsize = sizeof(struct qat_rsa_request) + 64,
+	.reqsize = sizeof(struct qat_asym_request) + 64,
 	.base = {
 		.cra_name = "rsa",
 		.cra_driver_name = "qat-rsa",
@@ -910,6 +1336,23 @@ static struct akcipher_alg rsa = {
 	},
 };
 
+static struct kpp_alg dh = {
+	.set_secret = qat_dh_set_secret,
+	.generate_public_key = qat_dh_compute_value,
+	.compute_shared_secret = qat_dh_compute_value,
+	.max_size = qat_dh_max_size,
+	.init = qat_dh_init_tfm,
+	.exit = qat_dh_exit_tfm,
+	.reqsize = sizeof(struct qat_asym_request) + 64,
+	.base = {
+		.cra_name = "dh",
+		.cra_driver_name = "qat-dh",
+		.cra_priority = 1000,
+		.cra_module = THIS_MODULE,
+		.cra_ctxsize = sizeof(struct qat_dh_ctx),
+	},
+};
+
 int qat_asym_algs_register(void)
 {
 	int ret = 0;
@@ -918,7 +1361,11 @@ int qat_asym_algs_register(void)
 	if (++active_devs == 1) {
 		rsa.base.cra_flags = 0;
 		ret = crypto_register_akcipher(&rsa);
+		if (ret)
+			goto unlock;
+		ret = crypto_register_kpp(&dh);
 	}
+unlock:
 	mutex_unlock(&algs_lock);
 	return ret;
 }
@@ -926,7 +1373,9 @@ int qat_asym_algs_register(void)
 void qat_asym_algs_unregister(void)
 {
 	mutex_lock(&algs_lock);
-	if (--active_devs == 0)
+	if (--active_devs == 0) {
 		crypto_unregister_akcipher(&rsa);
+		crypto_unregister_kpp(&dh);
+	}
 	mutex_unlock(&algs_lock);
 }
-- 
2.7.4
