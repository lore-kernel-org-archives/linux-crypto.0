From: Tudor Ambarus <tudor-dan.ambarus@nxp.com>
Subject: [PATCH 07/10] crypto: qat - remove duplicate ASN.1 parser
Date: Fri, 18 Mar 2016 20:32:04 +0200
Message-ID: <1458325927-14737-7-git-send-email-tudor-dan.ambarus@nxp.com>
References: <1458325927-14737-1-git-send-email-tudor-dan.ambarus@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>, <smueller@chronox.de>,
	<horia.geanta@nxp.com>, Tudor Ambarus <tudor-dan.ambarus@nxp.com>
To: <herbert@gondor.apana.org.au>, <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1bon0071.outbound.protection.outlook.com ([157.56.111.71]:30807
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753404AbcCRScd (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 18 Mar 2016 14:32:33 -0400
In-Reply-To: <1458325927-14737-1-git-send-email-tudor-dan.ambarus@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Use the RSA's software implementation parser with
raw integer actions.

Compile-tested only.

Signed-off-by: Tudor Ambarus <tudor-dan.ambarus@nxp.com>
---
 drivers/crypto/qat/Kconfig                        |   3 +-
 drivers/crypto/qat/qat_common/Makefile            |  10 +-
 drivers/crypto/qat/qat_common/qat_asym_algs.c     | 265 +++++++---------------
 drivers/crypto/qat/qat_common/qat_rsaprivkey.asn1 |  11 -
 drivers/crypto/qat/qat_common/qat_rsapubkey.asn1  |   4 -
 5 files changed, 83 insertions(+), 210 deletions(-)
 delete mode 100644 drivers/crypto/qat/qat_common/qat_rsaprivkey.asn1
 delete mode 100644 drivers/crypto/qat/qat_common/qat_rsapubkey.asn1

diff --git a/drivers/crypto/qat/Kconfig b/drivers/crypto/qat/Kconfig
index 85b44e5..59314e6 100644
--- a/drivers/crypto/qat/Kconfig
+++ b/drivers/crypto/qat/Kconfig
@@ -3,13 +3,12 @@ config CRYPTO_DEV_QAT
 	select CRYPTO_AEAD
 	select CRYPTO_AUTHENC
 	select CRYPTO_BLKCIPHER
-	select CRYPTO_AKCIPHER
 	select CRYPTO_HMAC
 	select CRYPTO_SHA1
 	select CRYPTO_SHA256
 	select CRYPTO_SHA512
 	select FW_LOADER
-	select ASN1
+	select CRYPTO_RSA_HELPER
 
 config CRYPTO_DEV_QAT_DH895xCC
 	tristate "Support for Intel(R) DH895xCC"
diff --git a/drivers/crypto/qat/qat_common/Makefile b/drivers/crypto/qat/qat_common/Makefile
index 29c7c53..dd62918 100644
--- a/drivers/crypto/qat/qat_common/Makefile
+++ b/drivers/crypto/qat/qat_common/Makefile
@@ -1,10 +1,4 @@
-$(obj)/qat_rsapubkey-asn1.o: $(obj)/qat_rsapubkey-asn1.c \
-			     $(obj)/qat_rsapubkey-asn1.h
-$(obj)/qat_rsaprivkey-asn1.o: $(obj)/qat_rsaprivkey-asn1.c \
-			      $(obj)/qat_rsaprivkey-asn1.h
-
-clean-files += qat_rsapubkey-asn1.c qat_rsapubkey-asn1.h
-clean-files += qat_rsaprivkey-asn1.c qat_rsaprivkey-asn1.h
+ccflags-y += -I$(srctree)/crypto
 
 obj-$(CONFIG_CRYPTO_DEV_QAT) += intel_qat.o
 intel_qat-objs := adf_cfg.o \
@@ -20,8 +14,6 @@ intel_qat-objs := adf_cfg.o \
 	adf_hw_arbiter.o \
 	qat_crypto.o \
 	qat_algs.o \
-	qat_rsapubkey-asn1.o \
-	qat_rsaprivkey-asn1.o \
 	qat_asym_algs.o \
 	qat_uclo.o \
 	qat_hal.o
diff --git a/drivers/crypto/qat/qat_common/qat_asym_algs.c b/drivers/crypto/qat/qat_common/qat_asym_algs.c
index 05f49d4..196269c5 100644
--- a/drivers/crypto/qat/qat_common/qat_asym_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_asym_algs.c
@@ -52,8 +52,8 @@
 #include <linux/dma-mapping.h>
 #include <linux/fips.h>
 #include <crypto/scatterwalk.h>
-#include "qat_rsapubkey-asn1.h"
-#include "qat_rsaprivkey-asn1.h"
+#include "rsapubkey-asn1.h"
+#include "rsaprivkey-asn1.h"
 #include "icp_qat_fw_pke.h"
 #include "adf_accel_devices.h"
 #include "adf_transport.h"
@@ -92,13 +92,7 @@ struct qat_rsa_output_params {
 } __packed __aligned(64);
 
 struct qat_rsa_ctx {
-	char *n;
-	char *e;
-	char *d;
-	dma_addr_t dma_n;
-	dma_addr_t dma_e;
-	dma_addr_t dma_d;
-	unsigned int key_sz;
+	struct rsa_raw_ctx raw_key_ctx;
 	struct qat_crypto_instance *inst;
 } __packed __aligned(64);
 
@@ -118,6 +112,7 @@ static void qat_rsa_cb(struct icp_qat_fw_pke_resp *resp)
 {
 	struct akcipher_request *areq = (void *)(__force long)resp->opaque;
 	struct qat_rsa_request *req = PTR_ALIGN(akcipher_request_ctx(areq), 64);
+	struct rsa_raw_key *key = &req->ctx->raw_key_ctx.key;
 	struct device *dev = &GET_DEV(req->ctx->inst->accel_dev);
 	int err = ICP_QAT_FW_PKE_RESP_PKE_STAT_GET(
 				resp->pke_resp_hdr.comn_resp_flags);
@@ -125,13 +120,12 @@ static void qat_rsa_cb(struct icp_qat_fw_pke_resp *resp)
 	err = (err == ICP_QAT_FW_COMN_STATUS_FLAG_OK) ? 0 : -EINVAL;
 
 	if (req->src_align)
-		dma_free_coherent(dev, req->ctx->key_sz, req->src_align,
+		dma_free_coherent(dev, key->n_sz, req->src_align,
 				  req->in.enc.m);
 	else
-		dma_unmap_single(dev, req->in.enc.m, req->ctx->key_sz,
-				 DMA_TO_DEVICE);
+		dma_unmap_single(dev, req->in.enc.m, key->n_sz, DMA_TO_DEVICE);
 
-	areq->dst_len = req->ctx->key_sz;
+	areq->dst_len = key->n_sz;
 	if (req->dst_align) {
 		char *ptr = req->dst_align;
 
@@ -140,13 +134,13 @@ static void qat_rsa_cb(struct icp_qat_fw_pke_resp *resp)
 			ptr++;
 		}
 
-		if (areq->dst_len != req->ctx->key_sz)
+		if (areq->dst_len != key->n_sz)
 			memmove(req->dst_align, ptr, areq->dst_len);
 
 		scatterwalk_map_and_copy(req->dst_align, areq->dst, 0,
 					 areq->dst_len, 1);
 
-		dma_free_coherent(dev, req->ctx->key_sz, req->dst_align,
+		dma_free_coherent(dev, key->n_sz, req->dst_align,
 				  req->out.enc.c);
 	} else {
 		char *ptr = sg_virt(areq->dst);
@@ -159,7 +153,7 @@ static void qat_rsa_cb(struct icp_qat_fw_pke_resp *resp)
 		if (sg_virt(areq->dst) != ptr && areq->dst_len)
 			memmove(sg_virt(areq->dst), ptr, areq->dst_len);
 
-		dma_unmap_single(dev, req->out.enc.c, req->ctx->key_sz,
+		dma_unmap_single(dev, req->out.enc.c, key->n_sz,
 				 DMA_FROM_DEVICE);
 	}
 
@@ -241,6 +235,7 @@ static int qat_rsa_enc(struct akcipher_request *req)
 {
 	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
 	struct qat_rsa_ctx *ctx = akcipher_tfm_ctx(tfm);
+	struct rsa_raw_key *key = &ctx->raw_key_ctx.key;
 	struct qat_crypto_instance *inst = ctx->inst;
 	struct device *dev = &GET_DEV(inst->accel_dev);
 	struct qat_rsa_request *qat_req =
@@ -248,17 +243,17 @@ static int qat_rsa_enc(struct akcipher_request *req)
 	struct icp_qat_fw_pke_request *msg = &qat_req->req;
 	int ret, ctr = 0;
 
-	if (unlikely(!ctx->n || !ctx->e))
+	if (unlikely(!key->n || !key->e))
 		return -EINVAL;
 
-	if (req->dst_len < ctx->key_sz) {
-		req->dst_len = ctx->key_sz;
+	if (req->dst_len < key->n_sz) {
+		req->dst_len = key->n_sz;
 		return -EOVERFLOW;
 	}
 	memset(msg, '\0', sizeof(*msg));
 	ICP_QAT_FW_PKE_HDR_VALID_FLAG_SET(msg->pke_hdr,
 					  ICP_QAT_FW_COMN_REQ_FLAG_SET);
-	msg->pke_hdr.cd_pars.func_id = qat_rsa_enc_fn_id(ctx->key_sz);
+	msg->pke_hdr.cd_pars.func_id = qat_rsa_enc_fn_id(key->n_sz);
 	if (unlikely(!msg->pke_hdr.cd_pars.func_id))
 		return -EINVAL;
 
@@ -268,8 +263,8 @@ static int qat_rsa_enc(struct akcipher_request *req)
 		ICP_QAT_FW_COMN_FLAGS_BUILD(QAT_COMN_PTR_TYPE_FLAT,
 					    QAT_COMN_CD_FLD_TYPE_64BIT_ADR);
 
-	qat_req->in.enc.e = ctx->dma_e;
-	qat_req->in.enc.n = ctx->dma_n;
+	qat_req->in.enc.e = key->dma_e;
+	qat_req->in.enc.n = key->dma_n;
 	ret = -ENOMEM;
 
 	/*
@@ -279,7 +274,7 @@ static int qat_rsa_enc(struct akcipher_request *req)
 	 * In other case we just need to map the user provided buffer.
 	 * Also need to make sure that it is in contiguous buffer.
 	 */
-	if (sg_is_last(req->src) && req->src_len == ctx->key_sz) {
+	if (sg_is_last(req->src) && req->src_len == key->n_sz) {
 		qat_req->src_align = NULL;
 		qat_req->in.enc.m = dma_map_single(dev, sg_virt(req->src),
 						   req->src_len, DMA_TO_DEVICE);
@@ -287,9 +282,9 @@ static int qat_rsa_enc(struct akcipher_request *req)
 			return ret;
 
 	} else {
-		int shift = ctx->key_sz - req->src_len;
+		int shift = key->n_sz - req->src_len;
 
-		qat_req->src_align = dma_zalloc_coherent(dev, ctx->key_sz,
+		qat_req->src_align = dma_zalloc_coherent(dev, key->n_sz,
 							 &qat_req->in.enc.m,
 							 GFP_KERNEL);
 		if (unlikely(!qat_req->src_align))
@@ -298,7 +293,7 @@ static int qat_rsa_enc(struct akcipher_request *req)
 		scatterwalk_map_and_copy(qat_req->src_align + shift, req->src,
 					 0, req->src_len, 0);
 	}
-	if (sg_is_last(req->dst) && req->dst_len == ctx->key_sz) {
+	if (sg_is_last(req->dst) && req->dst_len == key->n_sz) {
 		qat_req->dst_align = NULL;
 		qat_req->out.enc.c = dma_map_single(dev, sg_virt(req->dst),
 						    req->dst_len,
@@ -308,7 +303,7 @@ static int qat_rsa_enc(struct akcipher_request *req)
 			goto unmap_src;
 
 	} else {
-		qat_req->dst_align = dma_zalloc_coherent(dev, ctx->key_sz,
+		qat_req->dst_align = dma_zalloc_coherent(dev, key->n_sz,
 							 &qat_req->out.enc.c,
 							 GFP_KERNEL);
 		if (unlikely(!qat_req->dst_align))
@@ -352,19 +347,19 @@ unmap_in_params:
 				 DMA_TO_DEVICE);
 unmap_dst:
 	if (qat_req->dst_align)
-		dma_free_coherent(dev, ctx->key_sz, qat_req->dst_align,
+		dma_free_coherent(dev, key->n_sz, qat_req->dst_align,
 				  qat_req->out.enc.c);
 	else
 		if (!dma_mapping_error(dev, qat_req->out.enc.c))
-			dma_unmap_single(dev, qat_req->out.enc.c, ctx->key_sz,
+			dma_unmap_single(dev, qat_req->out.enc.c, key->n_sz,
 					 DMA_FROM_DEVICE);
 unmap_src:
 	if (qat_req->src_align)
-		dma_free_coherent(dev, ctx->key_sz, qat_req->src_align,
+		dma_free_coherent(dev, key->n_sz, qat_req->src_align,
 				  qat_req->in.enc.m);
 	else
 		if (!dma_mapping_error(dev, qat_req->in.enc.m))
-			dma_unmap_single(dev, qat_req->in.enc.m, ctx->key_sz,
+			dma_unmap_single(dev, qat_req->in.enc.m, key->n_sz,
 					 DMA_TO_DEVICE);
 	return ret;
 }
@@ -373,6 +368,7 @@ static int qat_rsa_dec(struct akcipher_request *req)
 {
 	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
 	struct qat_rsa_ctx *ctx = akcipher_tfm_ctx(tfm);
+	struct rsa_raw_key *key = &ctx->raw_key_ctx.key;
 	struct qat_crypto_instance *inst = ctx->inst;
 	struct device *dev = &GET_DEV(inst->accel_dev);
 	struct qat_rsa_request *qat_req =
@@ -380,17 +376,17 @@ static int qat_rsa_dec(struct akcipher_request *req)
 	struct icp_qat_fw_pke_request *msg = &qat_req->req;
 	int ret, ctr = 0;
 
-	if (unlikely(!ctx->n || !ctx->d))
+	if (unlikely(!key->n || !key->d))
 		return -EINVAL;
 
-	if (req->dst_len < ctx->key_sz) {
-		req->dst_len = ctx->key_sz;
+	if (req->dst_len < key->n_sz) {
+		req->dst_len = key->n_sz;
 		return -EOVERFLOW;
 	}
 	memset(msg, '\0', sizeof(*msg));
 	ICP_QAT_FW_PKE_HDR_VALID_FLAG_SET(msg->pke_hdr,
 					  ICP_QAT_FW_COMN_REQ_FLAG_SET);
-	msg->pke_hdr.cd_pars.func_id = qat_rsa_dec_fn_id(ctx->key_sz);
+	msg->pke_hdr.cd_pars.func_id = qat_rsa_dec_fn_id(key->n_sz);
 	if (unlikely(!msg->pke_hdr.cd_pars.func_id))
 		return -EINVAL;
 
@@ -400,8 +396,8 @@ static int qat_rsa_dec(struct akcipher_request *req)
 		ICP_QAT_FW_COMN_FLAGS_BUILD(QAT_COMN_PTR_TYPE_FLAT,
 					    QAT_COMN_CD_FLD_TYPE_64BIT_ADR);
 
-	qat_req->in.dec.d = ctx->dma_d;
-	qat_req->in.dec.n = ctx->dma_n;
+	qat_req->in.dec.d = key->dma_d;
+	qat_req->in.dec.n = key->dma_n;
 	ret = -ENOMEM;
 
 	/*
@@ -411,7 +407,7 @@ static int qat_rsa_dec(struct akcipher_request *req)
 	 * In other case we just need to map the user provided buffer.
 	 * Also need to make sure that it is in contiguous buffer.
 	 */
-	if (sg_is_last(req->src) && req->src_len == ctx->key_sz) {
+	if (sg_is_last(req->src) && req->src_len == key->n_sz) {
 		qat_req->src_align = NULL;
 		qat_req->in.dec.c = dma_map_single(dev, sg_virt(req->src),
 						   req->dst_len, DMA_TO_DEVICE);
@@ -419,9 +415,9 @@ static int qat_rsa_dec(struct akcipher_request *req)
 			return ret;
 
 	} else {
-		int shift = ctx->key_sz - req->src_len;
+		int shift = key->n_sz - req->src_len;
 
-		qat_req->src_align = dma_zalloc_coherent(dev, ctx->key_sz,
+		qat_req->src_align = dma_zalloc_coherent(dev, key->n_sz,
 							 &qat_req->in.dec.c,
 							 GFP_KERNEL);
 		if (unlikely(!qat_req->src_align))
@@ -430,7 +426,7 @@ static int qat_rsa_dec(struct akcipher_request *req)
 		scatterwalk_map_and_copy(qat_req->src_align + shift, req->src,
 					 0, req->src_len, 0);
 	}
-	if (sg_is_last(req->dst) && req->dst_len == ctx->key_sz) {
+	if (sg_is_last(req->dst) && req->dst_len == key->n_sz) {
 		qat_req->dst_align = NULL;
 		qat_req->out.dec.m = dma_map_single(dev, sg_virt(req->dst),
 						    req->dst_len,
@@ -440,7 +436,7 @@ static int qat_rsa_dec(struct akcipher_request *req)
 			goto unmap_src;
 
 	} else {
-		qat_req->dst_align = dma_zalloc_coherent(dev, ctx->key_sz,
+		qat_req->dst_align = dma_zalloc_coherent(dev, key->n_sz,
 							 &qat_req->out.dec.m,
 							 GFP_KERNEL);
 		if (unlikely(!qat_req->dst_align))
@@ -485,160 +481,71 @@ unmap_in_params:
 				 DMA_TO_DEVICE);
 unmap_dst:
 	if (qat_req->dst_align)
-		dma_free_coherent(dev, ctx->key_sz, qat_req->dst_align,
+		dma_free_coherent(dev, key->n_sz, qat_req->dst_align,
 				  qat_req->out.dec.m);
 	else
 		if (!dma_mapping_error(dev, qat_req->out.dec.m))
-			dma_unmap_single(dev, qat_req->out.dec.m, ctx->key_sz,
+			dma_unmap_single(dev, qat_req->out.dec.m, key->n_sz,
 					 DMA_FROM_DEVICE);
 unmap_src:
 	if (qat_req->src_align)
-		dma_free_coherent(dev, ctx->key_sz, qat_req->src_align,
+		dma_free_coherent(dev, key->n_sz, qat_req->src_align,
 				  qat_req->in.dec.c);
 	else
 		if (!dma_mapping_error(dev, qat_req->in.dec.c))
-			dma_unmap_single(dev, qat_req->in.dec.c, ctx->key_sz,
+			dma_unmap_single(dev, qat_req->in.dec.c, key->n_sz,
 					 DMA_TO_DEVICE);
 	return ret;
 }
 
-int qat_rsa_get_n(void *context, size_t hdrlen, unsigned char tag,
-		  const void *value, size_t vlen)
+static void qat_free_rsa_key(struct rsa_raw_ctx *ctx)
 {
-	struct qat_rsa_ctx *ctx = context;
-	struct qat_crypto_instance *inst = ctx->inst;
-	struct device *dev = &GET_DEV(inst->accel_dev);
-	const char *ptr = value;
-	int ret;
+	struct rsa_raw_key *key = &ctx->key;
+	struct device *dev = ctx->dev;
 
-	while (!*ptr && vlen) {
-		ptr++;
-		vlen--;
+	if (key->d) {
+		memset(key->d, '\0', key->n_sz);
+		dma_free_coherent(dev, key->n_sz, key->d, key->dma_d);
+		key->d = NULL;
 	}
 
-	ctx->key_sz = vlen;
-	ret = -EINVAL;
-	/* In FIPS mode only allow key size 2K & 3K */
-	if (fips_enabled && (ctx->key_sz != 256 && ctx->key_sz != 384)) {
-		pr_err("QAT: RSA: key size not allowed in FIPS mode\n");
-		goto err;
+	if (key->e) {
+		dma_free_coherent(dev, key->n_sz, key->e, key->dma_e);
+		key->e = NULL;
 	}
-	/* invalid key size provided */
-	if (!qat_rsa_enc_fn_id(ctx->key_sz))
-		goto err;
 
-	ret = -ENOMEM;
-	ctx->n = dma_zalloc_coherent(dev, ctx->key_sz, &ctx->dma_n, GFP_KERNEL);
-	if (!ctx->n)
-		goto err;
-
-	memcpy(ctx->n, ptr, ctx->key_sz);
-	return 0;
-err:
-	ctx->key_sz = 0;
-	ctx->n = NULL;
-	return ret;
-}
-
-int qat_rsa_get_e(void *context, size_t hdrlen, unsigned char tag,
-		  const void *value, size_t vlen)
-{
-	struct qat_rsa_ctx *ctx = context;
-	struct qat_crypto_instance *inst = ctx->inst;
-	struct device *dev = &GET_DEV(inst->accel_dev);
-	const char *ptr = value;
-
-	while (!*ptr && vlen) {
-		ptr++;
-		vlen--;
-	}
-
-	if (!ctx->key_sz || !vlen || vlen > ctx->key_sz) {
-		ctx->e = NULL;
-		return -EINVAL;
-	}
-
-	ctx->e = dma_zalloc_coherent(dev, ctx->key_sz, &ctx->dma_e, GFP_KERNEL);
-	if (!ctx->e) {
-		ctx->e = NULL;
-		return -ENOMEM;
+	if (key->n) {
+		dma_free_coherent(dev, key->n_sz, key->n, key->dma_n);
+		key->n = NULL;
 	}
-	memcpy(ctx->e + (ctx->key_sz - vlen), ptr, vlen);
-	return 0;
-}
-
-int qat_rsa_get_d(void *context, size_t hdrlen, unsigned char tag,
-		  const void *value, size_t vlen)
-{
-	struct qat_rsa_ctx *ctx = context;
-	struct qat_crypto_instance *inst = ctx->inst;
-	struct device *dev = &GET_DEV(inst->accel_dev);
-	const char *ptr = value;
-	int ret;
-
-	while (!*ptr && vlen) {
-		ptr++;
-		vlen--;
-	}
-
-	ret = -EINVAL;
-	if (!ctx->key_sz || !vlen || vlen > ctx->key_sz)
-		goto err;
-
-	/* In FIPS mode only allow key size 2K & 3K */
-	if (fips_enabled && (vlen != 256 && vlen != 384)) {
-		pr_err("QAT: RSA: key size not allowed in FIPS mode\n");
-		goto err;
-	}
-
-	ret = -ENOMEM;
-	ctx->d = dma_zalloc_coherent(dev, ctx->key_sz, &ctx->dma_d, GFP_KERNEL);
-	if (!ctx->d)
-		goto err;
-
-	memcpy(ctx->d + (ctx->key_sz - vlen), ptr, vlen);
-	return 0;
-err:
-	ctx->d = NULL;
-	return ret;
 }
 
 static int qat_rsa_setkey(struct crypto_akcipher *tfm, const void *key,
 			  unsigned int keylen, bool private)
 {
 	struct qat_rsa_ctx *ctx = akcipher_tfm_ctx(tfm);
-	struct device *dev = &GET_DEV(ctx->inst->accel_dev);
+	struct rsa_raw_ctx *raw_ctx = &ctx->raw_key_ctx;
+	struct rsa_raw_key *raw_key = &raw_ctx->key;
 	int ret;
 
 	/* Free the old key if any */
-	if (ctx->n)
-		dma_free_coherent(dev, ctx->key_sz, ctx->n, ctx->dma_n);
-	if (ctx->e)
-		dma_free_coherent(dev, ctx->key_sz, ctx->e, ctx->dma_e);
-	if (ctx->d) {
-		memset(ctx->d, '\0', ctx->key_sz);
-		dma_free_coherent(dev, ctx->key_sz, ctx->d, ctx->dma_d);
-	}
-
-	ctx->n = NULL;
-	ctx->e = NULL;
-	ctx->d = NULL;
+	qat_free_rsa_key(raw_ctx);
 
 	if (private)
-		ret = asn1_ber_decoder(&qat_rsaprivkey_decoder, ctx, key,
+		ret = asn1_ber_decoder(&rsaprivkey_decoder, raw_ctx, key,
 				       keylen);
 	else
-		ret = asn1_ber_decoder(&qat_rsapubkey_decoder, ctx, key,
+		ret = asn1_ber_decoder(&rsapubkey_decoder, raw_ctx, key,
 				       keylen);
 	if (ret < 0)
 		goto free;
 
-	if (!ctx->n || !ctx->e) {
+	if (!raw_key->n || !raw_key->e) {
 		/* invalid key provided */
 		ret = -EINVAL;
 		goto free;
 	}
-	if (private && !ctx->d) {
+	if (private && !raw_key->d) {
 		/* invalid private key provided */
 		ret = -EINVAL;
 		goto free;
@@ -646,73 +553,63 @@ static int qat_rsa_setkey(struct crypto_akcipher *tfm, const void *key,
 
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
+	qat_free_rsa_key(raw_ctx);
 	return ret;
 }
 
 static int qat_rsa_setpubkey(struct crypto_akcipher *tfm, const void *key,
 			     unsigned int keylen)
 {
+	struct qat_rsa_ctx *ctx = akcipher_tfm_ctx(tfm);
+
+	set_raw_rsa_pub_action(&ctx->raw_key_ctx.action);
 	return qat_rsa_setkey(tfm, key, keylen, false);
 }
 
 static int qat_rsa_setprivkey(struct crypto_akcipher *tfm, const void *key,
 			      unsigned int keylen)
 {
+	struct qat_rsa_ctx *ctx = akcipher_tfm_ctx(tfm);
+
+	set_raw_rsa_priv_action(&ctx->raw_key_ctx.action);
 	return qat_rsa_setkey(tfm, key, keylen, true);
 }
 
 static int qat_rsa_max_size(struct crypto_akcipher *tfm)
 {
 	struct qat_rsa_ctx *ctx = akcipher_tfm_ctx(tfm);
+	struct rsa_raw_key *key = &ctx->raw_key_ctx.key;
 
-	return (ctx->n) ? ctx->key_sz : -EINVAL;
+	return (key->n) ? key->n_sz : -EINVAL;
 }
 
 static int qat_rsa_init_tfm(struct crypto_akcipher *tfm)
 {
 	struct qat_rsa_ctx *ctx = akcipher_tfm_ctx(tfm);
+	struct rsa_raw_key *key = &ctx->raw_key_ctx.key;
 	struct qat_crypto_instance *inst =
 			qat_crypto_get_instance_node(get_current_node());
 
 	if (!inst)
 		return -EINVAL;
 
-	ctx->key_sz = 0;
+	key->n_sz = 0;
 	ctx->inst = inst;
+	ctx->raw_key_ctx.dev = &GET_DEV(ctx->inst->accel_dev);
+
+	/* alloc coherent key buffers */
+	key->is_coherent = false;
+	key->flags = GFP_KERNEL;
+
 	return 0;
 }
 
 static void qat_rsa_exit_tfm(struct crypto_akcipher *tfm)
 {
 	struct qat_rsa_ctx *ctx = akcipher_tfm_ctx(tfm);
-	struct device *dev = &GET_DEV(ctx->inst->accel_dev);
-
-	if (ctx->n)
-		dma_free_coherent(dev, ctx->key_sz, ctx->n, ctx->dma_n);
-	if (ctx->e)
-		dma_free_coherent(dev, ctx->key_sz, ctx->e, ctx->dma_e);
-	if (ctx->d) {
-		memset(ctx->d, '\0', ctx->key_sz);
-		dma_free_coherent(dev, ctx->key_sz, ctx->d, ctx->dma_d);
-	}
+
+	qat_free_rsa_key(&ctx->raw_key_ctx);
 	qat_crypto_put_instance(ctx->inst);
-	ctx->n = NULL;
-	ctx->e = NULL;
-	ctx->d = NULL;
 }
 
 static struct akcipher_alg rsa = {
diff --git a/drivers/crypto/qat/qat_common/qat_rsaprivkey.asn1 b/drivers/crypto/qat/qat_common/qat_rsaprivkey.asn1
deleted file mode 100644
index f0066ad..0000000
--- a/drivers/crypto/qat/qat_common/qat_rsaprivkey.asn1
+++ /dev/null
@@ -1,11 +0,0 @@
-RsaPrivKey ::= SEQUENCE {
-	version		INTEGER,
-	n		INTEGER ({ qat_rsa_get_n }),
-	e		INTEGER ({ qat_rsa_get_e }),
-	d		INTEGER ({ qat_rsa_get_d }),
-	prime1		INTEGER,
-	prime2		INTEGER,
-	exponent1	INTEGER,
-	exponent2	INTEGER,
-	coefficient	INTEGER
-}
diff --git a/drivers/crypto/qat/qat_common/qat_rsapubkey.asn1 b/drivers/crypto/qat/qat_common/qat_rsapubkey.asn1
deleted file mode 100644
index bd667b3..0000000
--- a/drivers/crypto/qat/qat_common/qat_rsapubkey.asn1
+++ /dev/null
@@ -1,4 +0,0 @@
-RsaPubKey ::= SEQUENCE {
-	n INTEGER ({ qat_rsa_get_n }),
-	e INTEGER ({ qat_rsa_get_e })
-}
-- 
1.8.3.1
