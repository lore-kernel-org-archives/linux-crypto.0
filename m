From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH] crypto: qat - fix leak on error path
Date: Wed, 10 Feb 2016 14:59:44 -0800
Message-ID: <1455145184-5610-1-git-send-email-tadeusz.struk@intel.com>
Cc: linux-crypto@vger.kernel.org,
	Tadeusz Struk <tadeusz.struk@intel.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:48292 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750828AbcBJXDy (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 10 Feb 2016 18:03:54 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Fix a leak on error path in qat asym

Reported-by: Salvatore Benedetto <salvatore.benedetto@intel.com>
Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 drivers/crypto/qat/qat_common/qat_asym_algs.c | 70 ++++++++++++++-------------
 1 file changed, 36 insertions(+), 34 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/qat_asym_algs.c b/drivers/crypto/qat/qat_common/qat_asym_algs.c
index 51c594f..e5c0727 100644
--- a/drivers/crypto/qat/qat_common/qat_asym_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_asym_algs.c
@@ -340,14 +340,16 @@ static int qat_rsa_enc(struct akcipher_request *req)
 
 	if (!ret)
 		return -EINPROGRESS;
-unmap_src:
-	if (qat_req->src_align)
-		dma_free_coherent(dev, ctx->key_sz, qat_req->src_align,
-				  qat_req->in.enc.m);
-	else
-		if (!dma_mapping_error(dev, qat_req->in.enc.m))
-			dma_unmap_single(dev, qat_req->in.enc.m, ctx->key_sz,
-					 DMA_TO_DEVICE);
+
+	if (!dma_mapping_error(dev, qat_req->phy_out))
+		dma_unmap_single(dev, qat_req->phy_out,
+				 sizeof(struct qat_rsa_output_params),
+				 DMA_TO_DEVICE);
+unmap_in_params:
+	if (!dma_mapping_error(dev, qat_req->phy_in))
+		dma_unmap_single(dev, qat_req->phy_in,
+				 sizeof(struct qat_rsa_input_params),
+				 DMA_TO_DEVICE);
 unmap_dst:
 	if (qat_req->dst_align)
 		dma_free_coherent(dev, ctx->key_sz, qat_req->dst_align,
@@ -356,15 +358,14 @@ unmap_dst:
 		if (!dma_mapping_error(dev, qat_req->out.enc.c))
 			dma_unmap_single(dev, qat_req->out.enc.c, ctx->key_sz,
 					 DMA_FROM_DEVICE);
-unmap_in_params:
-	if (!dma_mapping_error(dev, qat_req->phy_in))
-		dma_unmap_single(dev, qat_req->phy_in,
-				 sizeof(struct qat_rsa_input_params),
-				 DMA_TO_DEVICE);
-	if (!dma_mapping_error(dev, qat_req->phy_out))
-		dma_unmap_single(dev, qat_req->phy_out,
-				 sizeof(struct qat_rsa_output_params),
-				 DMA_TO_DEVICE);
+unmap_src:
+	if (qat_req->src_align)
+		dma_free_coherent(dev, ctx->key_sz, qat_req->src_align,
+				  qat_req->in.enc.m);
+	else
+		if (!dma_mapping_error(dev, qat_req->in.enc.m))
+			dma_unmap_single(dev, qat_req->in.enc.m, ctx->key_sz,
+					 DMA_TO_DEVICE);
 	return ret;
 }
 
@@ -472,14 +473,16 @@ static int qat_rsa_dec(struct akcipher_request *req)
 
 	if (!ret)
 		return -EINPROGRESS;
-unmap_src:
-	if (qat_req->src_align)
-		dma_free_coherent(dev, ctx->key_sz, qat_req->src_align,
-				  qat_req->in.dec.c);
-	else
-		if (!dma_mapping_error(dev, qat_req->in.dec.c))
-			dma_unmap_single(dev, qat_req->in.dec.c, ctx->key_sz,
-					 DMA_TO_DEVICE);
+
+	if (!dma_mapping_error(dev, qat_req->phy_out))
+		dma_unmap_single(dev, qat_req->phy_out,
+				 sizeof(struct qat_rsa_output_params),
+				 DMA_TO_DEVICE);
+unmap_in_params:
+	if (!dma_mapping_error(dev, qat_req->phy_in))
+		dma_unmap_single(dev, qat_req->phy_in,
+				 sizeof(struct qat_rsa_input_params),
+				 DMA_TO_DEVICE);
 unmap_dst:
 	if (qat_req->dst_align)
 		dma_free_coherent(dev, ctx->key_sz, qat_req->dst_align,
@@ -488,15 +491,14 @@ unmap_dst:
 		if (!dma_mapping_error(dev, qat_req->out.dec.m))
 			dma_unmap_single(dev, qat_req->out.dec.m, ctx->key_sz,
 					 DMA_FROM_DEVICE);
-unmap_in_params:
-	if (!dma_mapping_error(dev, qat_req->phy_in))
-		dma_unmap_single(dev, qat_req->phy_in,
-				 sizeof(struct qat_rsa_input_params),
-				 DMA_TO_DEVICE);
-	if (!dma_mapping_error(dev, qat_req->phy_out))
-		dma_unmap_single(dev, qat_req->phy_out,
-				 sizeof(struct qat_rsa_output_params),
-				 DMA_TO_DEVICE);
+unmap_src:
+	if (qat_req->src_align)
+		dma_free_coherent(dev, ctx->key_sz, qat_req->src_align,
+				  qat_req->in.dec.c);
+	else
+		if (!dma_mapping_error(dev, qat_req->in.dec.c))
+			dma_unmap_single(dev, qat_req->in.dec.c, ctx->key_sz,
+					 DMA_TO_DEVICE);
 	return ret;
 }
 
-- 
2.1.4
