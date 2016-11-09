From: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
Subject: [PATCH 10/14] crypto: caam - fix DMA API mapping leak in ablkcipher code
Date: Wed, 9 Nov 2016 10:46:20 +0200
Message-ID: <1478681184-9442-11-git-send-email-horia.geanta@nxp.com>
References: <1478681184-9442-1-git-send-email-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: "David S. Miller" <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bl2nam02on0069.outbound.protection.outlook.com ([104.47.38.69]:12531
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752537AbcKIJD3 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 9 Nov 2016 04:03:29 -0500
In-Reply-To: <1478681184-9442-1-git-send-email-horia.geanta@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

alkcipher_edesc_alloc() and ablkcipher_giv_edesc_alloc() don't
free / unmap resources on error path:
- dmap_map_sg() could fail, thus make sure the return value is checked
- unmap DMA mappings in case of error

Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
---
 drivers/crypto/caam/caamalg.c | 44 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index 34dfcdb7ff84..8db54b090d39 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -2600,16 +2600,33 @@ static struct ablkcipher_edesc *ablkcipher_edesc_alloc(struct ablkcipher_request
 	if (likely(req->src == req->dst)) {
 		sgc = dma_map_sg(jrdev, req->src, src_nents ? : 1,
 				 DMA_BIDIRECTIONAL);
+		if (unlikely(!sgc)) {
+			dev_err(jrdev, "unable to map source\n");
+			return ERR_PTR(-ENOMEM);
+		}
 	} else {
 		sgc = dma_map_sg(jrdev, req->src, src_nents ? : 1,
 				 DMA_TO_DEVICE);
+		if (unlikely(!sgc)) {
+			dev_err(jrdev, "unable to map source\n");
+			return ERR_PTR(-ENOMEM);
+		}
+
 		sgc = dma_map_sg(jrdev, req->dst, dst_nents ? : 1,
 				 DMA_FROM_DEVICE);
+		if (unlikely(!sgc)) {
+			dev_err(jrdev, "unable to map destination\n");
+			dma_unmap_sg(jrdev, req->src, src_nents ? : 1,
+				     DMA_TO_DEVICE);
+			return ERR_PTR(-ENOMEM);
+		}
 	}
 
 	iv_dma = dma_map_single(jrdev, req->info, ivsize, DMA_TO_DEVICE);
 	if (dma_mapping_error(jrdev, iv_dma)) {
 		dev_err(jrdev, "unable to map IV\n");
+		caam_unmap(jrdev, req->src, req->dst, src_nents, dst_nents, 0,
+			   0, 0, 0);
 		return ERR_PTR(-ENOMEM);
 	}
 
@@ -2629,6 +2646,8 @@ static struct ablkcipher_edesc *ablkcipher_edesc_alloc(struct ablkcipher_request
 			GFP_DMA | flags);
 	if (!edesc) {
 		dev_err(jrdev, "could not allocate extended descriptor\n");
+		caam_unmap(jrdev, req->src, req->dst, src_nents, dst_nents,
+			   iv_dma, ivsize, 0, 0);
 		return ERR_PTR(-ENOMEM);
 	}
 
@@ -2655,6 +2674,9 @@ static struct ablkcipher_edesc *ablkcipher_edesc_alloc(struct ablkcipher_request
 					    sec4_sg_bytes, DMA_TO_DEVICE);
 	if (dma_mapping_error(jrdev, edesc->sec4_sg_dma)) {
 		dev_err(jrdev, "unable to map S/G table\n");
+		caam_unmap(jrdev, req->src, req->dst, src_nents, dst_nents,
+			   iv_dma, ivsize, 0, 0);
+		kfree(edesc);
 		return ERR_PTR(-ENOMEM);
 	}
 
@@ -2776,11 +2798,26 @@ static struct ablkcipher_edesc *ablkcipher_giv_edesc_alloc(
 	if (likely(req->src == req->dst)) {
 		sgc = dma_map_sg(jrdev, req->src, src_nents ? : 1,
 				 DMA_BIDIRECTIONAL);
+		if (unlikely(!sgc)) {
+			dev_err(jrdev, "unable to map source\n");
+			return ERR_PTR(-ENOMEM);
+		}
 	} else {
 		sgc = dma_map_sg(jrdev, req->src, src_nents ? : 1,
 				 DMA_TO_DEVICE);
+		if (unlikely(!sgc)) {
+			dev_err(jrdev, "unable to map source\n");
+			return ERR_PTR(-ENOMEM);
+		}
+
 		sgc = dma_map_sg(jrdev, req->dst, dst_nents ? : 1,
 				 DMA_FROM_DEVICE);
+		if (unlikely(!sgc)) {
+			dev_err(jrdev, "unable to map destination\n");
+			dma_unmap_sg(jrdev, req->src, src_nents ? : 1,
+				     DMA_TO_DEVICE);
+			return ERR_PTR(-ENOMEM);
+		}
 	}
 
 	/*
@@ -2790,6 +2827,8 @@ static struct ablkcipher_edesc *ablkcipher_giv_edesc_alloc(
 	iv_dma = dma_map_single(jrdev, greq->giv, ivsize, DMA_TO_DEVICE);
 	if (dma_mapping_error(jrdev, iv_dma)) {
 		dev_err(jrdev, "unable to map IV\n");
+		caam_unmap(jrdev, req->src, req->dst, src_nents, dst_nents, 0,
+			   0, 0, 0);
 		return ERR_PTR(-ENOMEM);
 	}
 
@@ -2805,6 +2844,8 @@ static struct ablkcipher_edesc *ablkcipher_giv_edesc_alloc(
 			GFP_DMA | flags);
 	if (!edesc) {
 		dev_err(jrdev, "could not allocate extended descriptor\n");
+		caam_unmap(jrdev, req->src, req->dst, src_nents, dst_nents,
+			   iv_dma, ivsize, 0, 0);
 		return ERR_PTR(-ENOMEM);
 	}
 
@@ -2832,6 +2873,9 @@ static struct ablkcipher_edesc *ablkcipher_giv_edesc_alloc(
 					    sec4_sg_bytes, DMA_TO_DEVICE);
 	if (dma_mapping_error(jrdev, edesc->sec4_sg_dma)) {
 		dev_err(jrdev, "unable to map S/G table\n");
+		caam_unmap(jrdev, req->src, req->dst, src_nents, dst_nents,
+			   iv_dma, ivsize, 0, 0);
+		kfree(edesc);
 		return ERR_PTR(-ENOMEM);
 	}
 	edesc->iv_dma = iv_dma;
-- 
2.4.4
