From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH] crypto: qat: fix issue when mapping assoc to internal AD
 struct
Date: Fri, 05 Jun 2015 15:52:13 -0700
Message-ID: <20150605225213.4945.45404.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com,
	davem@davemloft.net, tadeusz.struk@intel.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:64649 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751411AbbFEWwE (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 5 Jun 2015 18:52:04 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch fixes an issue when building an internal AD representation.
We need to check assoclen and not only blindly loop over assoc sgl.

Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 drivers/crypto/qat/qat_common/qat_algs.c |   32 +++++++++++++++++++-----------
 1 file changed, 20 insertions(+), 12 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/qat_algs.c b/drivers/crypto/qat/qat_common/qat_algs.c
index dc231b8..067402c 100644
--- a/drivers/crypto/qat/qat_common/qat_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_algs.c
@@ -653,7 +653,7 @@ static void qat_alg_free_bufl(struct qat_crypto_instance *inst,
 }
 
 static int qat_alg_sgl_to_bufl(struct qat_crypto_instance *inst,
-			       struct scatterlist *assoc,
+			       struct scatterlist *assoc, int assoclen,
 			       struct scatterlist *sgl,
 			       struct scatterlist *sglout, uint8_t *iv,
 			       uint8_t ivlen,
@@ -685,15 +685,21 @@ static int qat_alg_sgl_to_bufl(struct qat_crypto_instance *inst,
 	for_each_sg(assoc, sg, assoc_n, i) {
 		if (!sg->length)
 			continue;
-		bufl->bufers[bufs].addr = dma_map_single(dev,
-							 sg_virt(sg),
-							 sg->length,
-							 DMA_BIDIRECTIONAL);
-		bufl->bufers[bufs].len = sg->length;
+
+		if (!(assoclen > 0))
+			break;
+
+		bufl->bufers[bufs].addr =
+			dma_map_single(dev, sg_virt(sg),
+				       min_t(int, assoclen, sg->length),
+				       DMA_BIDIRECTIONAL);
+		bufl->bufers[bufs].len = min_t(int, assoclen, sg->length);
 		if (unlikely(dma_mapping_error(dev, bufl->bufers[bufs].addr)))
 			goto err;
 		bufs++;
+		assoclen -= sg->length;
 	}
+
 	if (ivlen) {
 		bufl->bufers[bufs].addr = dma_map_single(dev, iv, ivlen,
 							 DMA_BIDIRECTIONAL);
@@ -845,8 +851,9 @@ static int qat_alg_aead_dec(struct aead_request *areq)
 	int digst_size = crypto_aead_crt(aead_tfm)->authsize;
 	int ret, ctr = 0;
 
-	ret = qat_alg_sgl_to_bufl(ctx->inst, areq->assoc, areq->src, areq->dst,
-				  areq->iv, AES_BLOCK_SIZE, qat_req);
+	ret = qat_alg_sgl_to_bufl(ctx->inst, areq->assoc, areq->assoclen,
+				  areq->src, areq->dst, areq->iv,
+				  AES_BLOCK_SIZE, qat_req);
 	if (unlikely(ret))
 		return ret;
 
@@ -889,8 +896,9 @@ static int qat_alg_aead_enc_internal(struct aead_request *areq, uint8_t *iv,
 	struct icp_qat_fw_la_bulk_req *msg;
 	int ret, ctr = 0;
 
-	ret = qat_alg_sgl_to_bufl(ctx->inst, areq->assoc, areq->src, areq->dst,
-				  iv, AES_BLOCK_SIZE, qat_req);
+	ret = qat_alg_sgl_to_bufl(ctx->inst, areq->assoc, areq->assoclen,
+				  areq->src, areq->dst, iv, AES_BLOCK_SIZE,
+				  qat_req);
 	if (unlikely(ret))
 		return ret;
 
@@ -1017,7 +1025,7 @@ static int qat_alg_ablkcipher_encrypt(struct ablkcipher_request *req)
 	struct icp_qat_fw_la_bulk_req *msg;
 	int ret, ctr = 0;
 
-	ret = qat_alg_sgl_to_bufl(ctx->inst, NULL, req->src, req->dst,
+	ret = qat_alg_sgl_to_bufl(ctx->inst, NULL, 0, req->src, req->dst,
 				  NULL, 0, qat_req);
 	if (unlikely(ret))
 		return ret;
@@ -1055,7 +1063,7 @@ static int qat_alg_ablkcipher_decrypt(struct ablkcipher_request *req)
 	struct icp_qat_fw_la_bulk_req *msg;
 	int ret, ctr = 0;
 
-	ret = qat_alg_sgl_to_bufl(ctx->inst, NULL, req->src, req->dst,
+	ret = qat_alg_sgl_to_bufl(ctx->inst, NULL, 0, req->src, req->dst,
 				  NULL, 0, qat_req);
 	if (unlikely(ret))
 		return ret;
