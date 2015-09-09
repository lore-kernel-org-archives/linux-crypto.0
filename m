From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH 7/8] crypto: qat - update accoring to akcipher API changes
Date: Wed, 09 Sep 2015 09:15:38 -0700
Message-ID: <20150909161538.2828.17383.stgit@tstruk-mobl1>
References: <20150909161454.2828.70445.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com,
	tadeusz.struk@intel.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:61142 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754578AbbIIQRb (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 9 Sep 2015 12:17:31 -0400
In-Reply-To: <20150909161454.2828.70445.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

QAT updates to reflect akcipher API changes.

Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 drivers/crypto/qat/qat_common/Makefile            |   12 +
 drivers/crypto/qat/qat_common/qat_asym_algs.c     |  225 +++++++++++++++------
 drivers/crypto/qat/qat_common/qat_rsakey.asn1     |    5 
 drivers/crypto/qat/qat_common/qat_rsaprivkey.asn1 |   11 +
 drivers/crypto/qat/qat_common/qat_rsapubkey.asn1  |    4 
 5 files changed, 189 insertions(+), 68 deletions(-)
 delete mode 100644 drivers/crypto/qat/qat_common/qat_rsakey.asn1
 create mode 100644 drivers/crypto/qat/qat_common/qat_rsaprivkey.asn1
 create mode 100644 drivers/crypto/qat/qat_common/qat_rsapubkey.asn1

diff --git a/drivers/crypto/qat/qat_common/Makefile b/drivers/crypto/qat/qat_common/Makefile
index ba5abdb..9e9e196 100644
--- a/drivers/crypto/qat/qat_common/Makefile
+++ b/drivers/crypto/qat/qat_common/Makefile
@@ -1,5 +1,10 @@
-$(obj)/qat_rsakey-asn1.o: $(obj)/qat_rsakey-asn1.c $(obj)/qat_rsakey-asn1.h
-clean-files += qat_rsakey-asn1.c qat_rsakey-asn1.h
+$(obj)/qat_rsapubkey-asn1.o: $(obj)/qat_rsapubkey-asn1.c \
+			     $(obj)/qat_rsapubkey-asn1.h
+$(obj)/qat_rsaprivkey-asn1.o: $(obj)/qat_rsaprivkey-asn1.c \
+			      $(obj)/qat_rsaprivkey-asn1.h
+
+clean-files += qat_rsapubkey-asn1.c qat_rsapubkey-asn1.h
+clean-files += qat_rsaprivkey-asn1.c qat_rsapvivkey-asn1.h
 
 obj-$(CONFIG_CRYPTO_DEV_QAT) += intel_qat.o
 intel_qat-objs := adf_cfg.o \
@@ -13,6 +18,9 @@ intel_qat-objs := adf_cfg.o \
 	adf_hw_arbiter.o \
 	qat_crypto.o \
 	qat_algs.o \
+	qat_rsapubkey-asn1.o \
+	qat_rsaprivkey-asn1.o \
+	qat_asym_algs.o \
 	qat_uclo.o \
 	qat_hal.o
 
diff --git a/drivers/crypto/qat/qat_common/qat_asym_algs.c b/drivers/crypto/qat/qat_common/qat_asym_algs.c
index 7de765d..d0c6e9c 100644
--- a/drivers/crypto/qat/qat_common/qat_asym_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_asym_algs.c
@@ -51,7 +51,9 @@
 #include <crypto/akcipher.h>
 #include <linux/dma-mapping.h>
 #include <linux/fips.h>
-#include "qat_rsakey-asn1.h"
+#include <crypto/scatterwalk.h>
+#include "qat_rsapubkey-asn1.h"
+#include "qat_rsaprivkey-asn1.h"
 #include "icp_qat_fw_pke.h"
 #include "adf_accel_devices.h"
 #include "adf_transport.h"
@@ -106,6 +108,7 @@ struct qat_rsa_request {
 	dma_addr_t phy_in;
 	dma_addr_t phy_out;
 	char *src_align;
+	char *dst_align;
 	struct icp_qat_fw_pke_request req;
 	struct qat_rsa_ctx *ctx;
 	int err;
@@ -118,7 +121,6 @@ static void qat_rsa_cb(struct icp_qat_fw_pke_resp *resp)
 	struct device *dev = &GET_DEV(req->ctx->inst->accel_dev);
 	int err = ICP_QAT_FW_PKE_RESP_PKE_STAT_GET(
 				resp->pke_resp_hdr.comn_resp_flags);
-	char *ptr = areq->dst;
 
 	err = (err == ICP_QAT_FW_COMN_STATUS_FLAG_OK) ? 0 : -EINVAL;
 
@@ -129,24 +131,44 @@ static void qat_rsa_cb(struct icp_qat_fw_pke_resp *resp)
 		dma_unmap_single(dev, req->in.enc.m, req->ctx->key_sz,
 				 DMA_TO_DEVICE);
 
-	dma_unmap_single(dev, req->out.enc.c, req->ctx->key_sz,
-			 DMA_FROM_DEVICE);
+	areq->out_len = req->ctx->key_sz;
+	if (req->dst_align) {
+		char *ptr = req->dst_align;
+
+		while (!(*ptr) && areq->out_len) {
+			areq->out_len--;
+			ptr++;
+		}
+
+		if (areq->out_len != req->ctx->key_sz)
+			memmove(req->dst_align, ptr, areq->out_len);
+
+		scatterwalk_map_and_copy(req->dst_align, areq->dst, 0,
+					 areq->out_len, 1);
+
+		dma_free_coherent(dev, req->ctx->key_sz, req->dst_align,
+				  req->out.enc.c);
+	} else {
+		char *ptr = sg_virt(areq->dst);
+
+		while (!(*ptr) && areq->out_len) {
+			areq->out_len--;
+			ptr++;
+		}
+
+		if (sg_virt(areq->dst) != ptr && areq->out_len)
+			memmove(sg_virt(areq->dst), ptr, areq->out_len);
+
+		dma_unmap_single(dev, req->out.enc.c, req->ctx->key_sz,
+				 DMA_FROM_DEVICE);
+	}
+
 	dma_unmap_single(dev, req->phy_in, sizeof(struct qat_rsa_input_params),
 			 DMA_TO_DEVICE);
 	dma_unmap_single(dev, req->phy_out,
 			 sizeof(struct qat_rsa_output_params),
 			 DMA_TO_DEVICE);
 
-	areq->dst_len = req->ctx->key_sz;
-	/* Need to set the corect length of the output */
-	while (!(*ptr) && areq->dst_len) {
-		areq->dst_len--;
-		ptr++;
-	}
-
-	if (areq->dst_len != req->ctx->key_sz)
-		memmove(areq->dst, ptr, areq->dst_len);
-
 	akcipher_request_complete(areq, err);
 }
 
@@ -224,13 +246,14 @@ static int qat_rsa_enc(struct akcipher_request *req)
 	struct qat_rsa_request *qat_req =
 			PTR_ALIGN(akcipher_request_ctx(req), 64);
 	struct icp_qat_fw_pke_request *msg = &qat_req->req;
+	int src_len = sg_len(req->src), dst_len = sg_len(req->dst);
 	int ret, ctr = 0;
 
 	if (unlikely(!ctx->n || !ctx->e))
 		return -EINVAL;
 
-	if (req->dst_len < ctx->key_sz) {
-		req->dst_len = ctx->key_sz;
+	if (dst_len < ctx->key_sz) {
+		req->out_len = ctx->key_sz;
 		return -EOVERFLOW;
 	}
 	memset(msg, '\0', sizeof(*msg));
@@ -255,9 +278,17 @@ static int qat_rsa_enc(struct akcipher_request *req)
 	 * same as modulo n so in case it is different we need to allocate a
 	 * new buf and copy src data.
 	 * In other case we just need to map the user provided buffer.
+	 * Also need to make sure that it is in contiguous buffer.
 	 */
-	if (req->src_len < ctx->key_sz) {
-		int shift = ctx->key_sz - req->src_len;
+	if (sg_is_last(req->src) && src_len == ctx->key_sz) {
+		qat_req->src_align = NULL;
+		qat_req->in.enc.m = dma_map_single(dev, sg_virt(req->src),
+						   src_len, DMA_TO_DEVICE);
+		if (unlikely(dma_mapping_error(dev, qat_req->in.enc.m)))
+			return ret;
+
+	} else {
+		int shift = ctx->key_sz - src_len;
 
 		qat_req->src_align = dma_zalloc_coherent(dev, ctx->key_sz,
 							 &qat_req->in.enc.m,
@@ -265,29 +296,38 @@ static int qat_rsa_enc(struct akcipher_request *req)
 		if (unlikely(!qat_req->src_align))
 			return ret;
 
-		memcpy(qat_req->src_align + shift, req->src, req->src_len);
+		scatterwalk_map_and_copy(qat_req->src_align + shift, req->src,
+					 0, src_len, 0);
+	}
+	if (sg_is_last(req->dst) && dst_len == ctx->key_sz) {
+		qat_req->dst_align = NULL;
+		qat_req->out.enc.c = dma_map_single(dev, sg_virt(req->dst),
+						     dst_len, DMA_FROM_DEVICE);
+
+		if (unlikely(dma_mapping_error(dev, qat_req->out.enc.c)))
+			goto unmap_src;
+
 	} else {
-		qat_req->src_align = NULL;
-		qat_req->in.enc.m = dma_map_single(dev, req->src, req->src_len,
-					   DMA_TO_DEVICE);
+		qat_req->dst_align = dma_zalloc_coherent(dev, ctx->key_sz,
+							 &qat_req->out.enc.c,
+							 GFP_KERNEL);
+		if (unlikely(!qat_req->dst_align))
+			goto unmap_src;
+
 	}
 	qat_req->in.in_tab[3] = 0;
-	qat_req->out.enc.c = dma_map_single(dev, req->dst, req->dst_len,
-					    DMA_FROM_DEVICE);
 	qat_req->out.out_tab[1] = 0;
 	qat_req->phy_in = dma_map_single(dev, &qat_req->in.enc.m,
 					 sizeof(struct qat_rsa_input_params),
 					 DMA_TO_DEVICE);
+	if (unlikely(dma_mapping_error(dev, qat_req->phy_in)))
+		goto unmap_dst;
+
 	qat_req->phy_out = dma_map_single(dev, &qat_req->out.enc.c,
 					  sizeof(struct qat_rsa_output_params),
-					    DMA_TO_DEVICE);
-
-	if (unlikely((!qat_req->src_align &&
-		      dma_mapping_error(dev, qat_req->in.enc.m)) ||
-		     dma_mapping_error(dev, qat_req->out.enc.c) ||
-		     dma_mapping_error(dev, qat_req->phy_in) ||
-		     dma_mapping_error(dev, qat_req->phy_out)))
-		goto unmap;
+					  DMA_TO_DEVICE);
+	if (unlikely(dma_mapping_error(dev, qat_req->phy_out)))
+		goto unmap_in_params;
 
 	msg->pke_mid.src_data_addr = qat_req->phy_in;
 	msg->pke_mid.dest_data_addr = qat_req->phy_out;
@@ -300,7 +340,7 @@ static int qat_rsa_enc(struct akcipher_request *req)
 
 	if (!ret)
 		return -EINPROGRESS;
-unmap:
+unmap_src:
 	if (qat_req->src_align)
 		dma_free_coherent(dev, ctx->key_sz, qat_req->src_align,
 				  qat_req->in.enc.m);
@@ -308,9 +348,15 @@ unmap:
 		if (!dma_mapping_error(dev, qat_req->in.enc.m))
 			dma_unmap_single(dev, qat_req->in.enc.m, ctx->key_sz,
 					 DMA_TO_DEVICE);
-	if (!dma_mapping_error(dev, qat_req->out.enc.c))
-		dma_unmap_single(dev, qat_req->out.enc.c, ctx->key_sz,
-				 DMA_FROM_DEVICE);
+unmap_dst:
+	if (qat_req->dst_align)
+		dma_free_coherent(dev, ctx->key_sz, qat_req->dst_align,
+				  qat_req->out.enc.c);
+	else
+		if (!dma_mapping_error(dev, qat_req->out.enc.c))
+			dma_unmap_single(dev, qat_req->out.enc.c, ctx->key_sz,
+					 DMA_FROM_DEVICE);
+unmap_in_params:
 	if (!dma_mapping_error(dev, qat_req->phy_in))
 		dma_unmap_single(dev, qat_req->phy_in,
 				 sizeof(struct qat_rsa_input_params),
@@ -331,13 +377,14 @@ static int qat_rsa_dec(struct akcipher_request *req)
 	struct qat_rsa_request *qat_req =
 			PTR_ALIGN(akcipher_request_ctx(req), 64);
 	struct icp_qat_fw_pke_request *msg = &qat_req->req;
+	int src_len = sg_len(req->src), dst_len = sg_len(req->dst);
 	int ret, ctr = 0;
 
 	if (unlikely(!ctx->n || !ctx->d))
 		return -EINVAL;
 
-	if (req->dst_len < ctx->key_sz) {
-		req->dst_len = ctx->key_sz;
+	if (dst_len < ctx->key_sz) {
+		req->out_len = ctx->key_sz;
 		return -EOVERFLOW;
 	}
 	memset(msg, '\0', sizeof(*msg));
@@ -362,9 +409,17 @@ static int qat_rsa_dec(struct akcipher_request *req)
 	 * same as modulo n so in case it is different we need to allocate a
 	 * new buf and copy src data.
 	 * In other case we just need to map the user provided buffer.
+	 * Also need to make sure that it is in contiguous buffer.
 	 */
-	if (req->src_len < ctx->key_sz) {
-		int shift = ctx->key_sz - req->src_len;
+	if (sg_is_last(req->src) && src_len == ctx->key_sz) {
+		qat_req->src_align = NULL;
+		qat_req->in.dec.c = dma_map_single(dev, sg_virt(req->src),
+						   dst_len, DMA_TO_DEVICE);
+		if (unlikely(dma_mapping_error(dev, qat_req->in.dec.c)))
+			return ret;
+
+	} else {
+		int shift = ctx->key_sz - src_len;
 
 		qat_req->src_align = dma_zalloc_coherent(dev, ctx->key_sz,
 							 &qat_req->in.dec.c,
@@ -372,29 +427,39 @@ static int qat_rsa_dec(struct akcipher_request *req)
 		if (unlikely(!qat_req->src_align))
 			return ret;
 
-		memcpy(qat_req->src_align + shift, req->src, req->src_len);
+		scatterwalk_map_and_copy(qat_req->src_align + shift, req->src,
+					 0, src_len, 0);
+	}
+	if (sg_is_last(req->dst) && dst_len == ctx->key_sz) {
+		qat_req->dst_align = NULL;
+		qat_req->out.dec.m = dma_map_single(dev, sg_virt(req->dst),
+						    dst_len, DMA_FROM_DEVICE);
+
+		if (unlikely(dma_mapping_error(dev, qat_req->out.dec.m)))
+			goto unmap_src;
+
 	} else {
-		qat_req->src_align = NULL;
-		qat_req->in.dec.c = dma_map_single(dev, req->src, req->src_len,
-						   DMA_TO_DEVICE);
+		qat_req->dst_align = dma_zalloc_coherent(dev, ctx->key_sz,
+							 &qat_req->out.dec.m,
+							 GFP_KERNEL);
+		if (unlikely(!qat_req->dst_align))
+			goto unmap_src;
+
 	}
+
 	qat_req->in.in_tab[3] = 0;
-	qat_req->out.dec.m = dma_map_single(dev, req->dst, req->dst_len,
-					    DMA_FROM_DEVICE);
 	qat_req->out.out_tab[1] = 0;
 	qat_req->phy_in = dma_map_single(dev, &qat_req->in.dec.c,
 					 sizeof(struct qat_rsa_input_params),
 					 DMA_TO_DEVICE);
+	if (unlikely(dma_mapping_error(dev, qat_req->phy_in)))
+		goto unmap_dst;
+
 	qat_req->phy_out = dma_map_single(dev, &qat_req->out.dec.m,
 					  sizeof(struct qat_rsa_output_params),
-					    DMA_TO_DEVICE);
-
-	if (unlikely((!qat_req->src_align &&
-		      dma_mapping_error(dev, qat_req->in.dec.c)) ||
-		     dma_mapping_error(dev, qat_req->out.dec.m) ||
-		     dma_mapping_error(dev, qat_req->phy_in) ||
-		     dma_mapping_error(dev, qat_req->phy_out)))
-		goto unmap;
+					  DMA_TO_DEVICE);
+	if (unlikely(dma_mapping_error(dev, qat_req->phy_out)))
+		goto unmap_in_params;
 
 	msg->pke_mid.src_data_addr = qat_req->phy_in;
 	msg->pke_mid.dest_data_addr = qat_req->phy_out;
@@ -407,7 +472,7 @@ static int qat_rsa_dec(struct akcipher_request *req)
 
 	if (!ret)
 		return -EINPROGRESS;
-unmap:
+unmap_src:
 	if (qat_req->src_align)
 		dma_free_coherent(dev, ctx->key_sz, qat_req->src_align,
 				  qat_req->in.dec.c);
@@ -415,9 +480,15 @@ unmap:
 		if (!dma_mapping_error(dev, qat_req->in.dec.c))
 			dma_unmap_single(dev, qat_req->in.dec.c, ctx->key_sz,
 					 DMA_TO_DEVICE);
-	if (!dma_mapping_error(dev, qat_req->out.dec.m))
-		dma_unmap_single(dev, qat_req->out.dec.m, ctx->key_sz,
-				 DMA_FROM_DEVICE);
+unmap_dst:
+	if (qat_req->dst_align)
+		dma_free_coherent(dev, ctx->key_sz, qat_req->dst_align,
+				  qat_req->out.dec.m);
+	else
+		if (!dma_mapping_error(dev, qat_req->out.dec.m))
+			dma_unmap_single(dev, qat_req->out.dec.m, ctx->key_sz,
+					 DMA_FROM_DEVICE);
+unmap_in_params:
 	if (!dma_mapping_error(dev, qat_req->phy_in))
 		dma_unmap_single(dev, qat_req->phy_in,
 				 sizeof(struct qat_rsa_input_params),
@@ -531,7 +602,7 @@ err:
 }
 
 static int qat_rsa_setkey(struct crypto_akcipher *tfm, const void *key,
-			  unsigned int keylen)
+			  unsigned int keylen, bool private)
 {
 	struct qat_rsa_ctx *ctx = akcipher_tfm_ctx(tfm);
 	struct device *dev = &GET_DEV(ctx->inst->accel_dev);
@@ -550,7 +621,13 @@ static int qat_rsa_setkey(struct crypto_akcipher *tfm, const void *key,
 	ctx->n = NULL;
 	ctx->e = NULL;
 	ctx->d = NULL;
-	ret = asn1_ber_decoder(&qat_rsakey_decoder, ctx, key, keylen);
+
+	if (private)
+		ret = asn1_ber_decoder(&qat_rsaprivkey_decoder, ctx, key,
+				       keylen);
+	else
+		ret = asn1_ber_decoder(&qat_rsapubkey_decoder, ctx, key,
+				       keylen);
 	if (ret < 0)
 		goto free;
 
@@ -559,6 +636,11 @@ static int qat_rsa_setkey(struct crypto_akcipher *tfm, const void *key,
 		ret = -EINVAL;
 		goto free;
 	}
+	if (private && !ctx->d) {
+		/* invalid private key provided */
+		ret = -EINVAL;
+		goto free;
+	}
 
 	return 0;
 free:
@@ -579,6 +661,25 @@ free:
 	return ret;
 }
 
+static int qat_rsa_setpubkey(struct crypto_akcipher *tfm, const void *key,
+			     unsigned int keylen)
+{
+	return qat_rsa_setkey(tfm, key, keylen, false);
+}
+
+static int qat_rsa_setprivkey(struct crypto_akcipher *tfm, const void *key,
+			      unsigned int keylen)
+{
+	return qat_rsa_setkey(tfm, key, keylen, true);
+}
+
+static int qat_rsa_get_len(struct crypto_akcipher *tfm)
+{
+	struct qat_rsa_ctx *ctx = akcipher_tfm_ctx(tfm);
+
+	return (ctx->n) ? ctx->key_sz : -EINVAL;
+}
+
 static int qat_rsa_init_tfm(struct crypto_akcipher *tfm)
 {
 	struct qat_rsa_ctx *ctx = akcipher_tfm_ctx(tfm);
@@ -617,7 +718,9 @@ static struct akcipher_alg rsa = {
 	.decrypt = qat_rsa_dec,
 	.sign = qat_rsa_dec,
 	.verify = qat_rsa_enc,
-	.setkey = qat_rsa_setkey,
+	.set_pub_key = qat_rsa_setpubkey,
+	.set_priv_key = qat_rsa_setprivkey,
+	.get_len = qat_rsa_get_len,
 	.init = qat_rsa_init_tfm,
 	.exit = qat_rsa_exit_tfm,
 	.reqsize = sizeof(struct qat_rsa_request) + 64,
diff --git a/drivers/crypto/qat/qat_common/qat_rsakey.asn1 b/drivers/crypto/qat/qat_common/qat_rsakey.asn1
deleted file mode 100644
index 97b0e02..0000000
--- a/drivers/crypto/qat/qat_common/qat_rsakey.asn1
+++ /dev/null
@@ -1,5 +0,0 @@
-RsaKey ::= SEQUENCE {
-	n INTEGER ({ qat_rsa_get_n }),
-	e INTEGER ({ qat_rsa_get_e }),
-	d INTEGER ({ qat_rsa_get_d })
-}
diff --git a/drivers/crypto/qat/qat_common/qat_rsaprivkey.asn1 b/drivers/crypto/qat/qat_common/qat_rsaprivkey.asn1
new file mode 100644
index 0000000..f0066ad
--- /dev/null
+++ b/drivers/crypto/qat/qat_common/qat_rsaprivkey.asn1
@@ -0,0 +1,11 @@
+RsaPrivKey ::= SEQUENCE {
+	version		INTEGER,
+	n		INTEGER ({ qat_rsa_get_n }),
+	e		INTEGER ({ qat_rsa_get_e }),
+	d		INTEGER ({ qat_rsa_get_d }),
+	prime1		INTEGER,
+	prime2		INTEGER,
+	exponent1	INTEGER,
+	exponent2	INTEGER,
+	coefficient	INTEGER
+}
diff --git a/drivers/crypto/qat/qat_common/qat_rsapubkey.asn1 b/drivers/crypto/qat/qat_common/qat_rsapubkey.asn1
new file mode 100644
index 0000000..bd667b3
--- /dev/null
+++ b/drivers/crypto/qat/qat_common/qat_rsapubkey.asn1
@@ -0,0 +1,4 @@
+RsaPubKey ::= SEQUENCE {
+	n INTEGER ({ qat_rsa_get_n }),
+	e INTEGER ({ qat_rsa_get_e })
+}
