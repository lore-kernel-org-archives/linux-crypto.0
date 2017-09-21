From: Christophe Leroy <christophe.leroy@c-s.fr>
Subject: [PATCH 5/6] crypto: talitos - use kzalloc instead of kmalloc
Date: Thu, 21 Sep 2017 09:19:55 +0200 (CEST)
Message-ID: <0ef5b121c6d362b20d30c8eb37739287a2ee4905.1575825623.git.christophe.leroy@c-s.fr>
References: <cover.1575825623.git.christophe.leroy@c-s.fr>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pegase1.c-s.fr ([93.17.236.30]:13817 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751676AbdIUHT5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Sep 2017 03:19:57 -0400
Received: from localhost (mailhub1-int [192.168.12.234])
        by localhost (Postfix) with ESMTP id 3xySfl13N2z9ttBj
        for <linux-crypto@vger.kernel.org>; Thu, 21 Sep 2017 09:19:43 +0200 (CEST)
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [192.168.12.234]) (amavisd-new, port 10024)
        with ESMTP id IoYbAuxWIZky for <linux-crypto@vger.kernel.org>;
        Thu, 21 Sep 2017 09:19:43 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase1.c-s.fr (Postfix) with ESMTP id 3xySfl0YSpz9ttBh
        for <linux-crypto@vger.kernel.org>; Thu, 21 Sep 2017 09:19:43 +0200 (CEST)
In-Reply-To: <cover.1575825623.git.christophe.leroy@c-s.fr>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Use kzalloc() to zeroize the extended descriptor at allocation and
further zeorising

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
---
 drivers/crypto/talitos.c | 23 +----------------------
 drivers/crypto/talitos.h |  2 --
 2 files changed, 1 insertion(+), 24 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index cd8a37e60259..a5b608b54c74 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -75,7 +75,6 @@ static void to_talitos_ptr_len(struct talitos_ptr *ptr, unsigned int len,
 			       bool is_sec1)
 {
 	if (is_sec1) {
-		ptr->res = 0;
 		ptr->len1 = cpu_to_be16(len);
 	} else {
 		ptr->len = cpu_to_be16(len);
@@ -118,7 +117,6 @@ static void map_single_talitos_ptr(struct device *dev,
 
 	to_talitos_ptr_len(ptr, len, is_sec1);
 	to_talitos_ptr(ptr, dma_addr, is_sec1);
-	to_talitos_ptr_ext_set(ptr, 0, is_sec1);
 }
 
 /*
@@ -287,7 +285,6 @@ int talitos_submit(struct device *dev, int ch, struct talitos_desc *desc,
 	/* map descriptor and save caller data */
 	if (is_sec1) {
 		desc->hdr1 = desc->hdr;
-		desc->next_desc = 0;
 		request->dma_desc = dma_map_single(dev, &desc->hdr1,
 						   TALITOS_DESC_SIZE,
 						   DMA_BIDIRECTIONAL);
@@ -1099,7 +1096,6 @@ static int sg_to_link_tbl_offset(struct scatterlist *sg, int sg_count,
 		to_talitos_ptr(link_tbl_ptr + count,
 			       sg_dma_address(sg) + offset, 0);
 		to_talitos_ptr_len(link_tbl_ptr + count, len, 0);
-		to_talitos_ptr_ext_set(link_tbl_ptr + count, 0, 0);
 		count++;
 		cryptlen -= len;
 		offset = 0;
@@ -1125,7 +1121,6 @@ int talitos_sg_map(struct device *dev, struct scatterlist *src,
 	bool is_sec1 = has_ftr_sec1(priv);
 
 	to_talitos_ptr_len(ptr, len, is_sec1);
-	to_talitos_ptr_ext_set(ptr, 0, is_sec1);
 
 	if (sg_count == 1) {
 		to_talitos_ptr(ptr, sg_dma_address(src) + offset, is_sec1);
@@ -1197,11 +1192,9 @@ static int ipsec_esp(struct talitos_edesc *edesc, struct aead_request *areq,
 	if (desc->hdr & DESC_HDR_TYPE_IPSEC_ESP) {
 		to_talitos_ptr(&desc->ptr[2], edesc->iv_dma, is_sec1);
 		to_talitos_ptr_len(&desc->ptr[2], ivsize, is_sec1);
-		to_talitos_ptr_ext_set(&desc->ptr[2], 0, is_sec1);
 	} else {
 		to_talitos_ptr(&desc->ptr[3], edesc->iv_dma, is_sec1);
 		to_talitos_ptr_len(&desc->ptr[3], ivsize, is_sec1);
-		to_talitos_ptr_ext_set(&desc->ptr[3], 0, is_sec1);
 	}
 
 	/* cipher key */
@@ -1221,7 +1214,6 @@ static int ipsec_esp(struct talitos_edesc *edesc, struct aead_request *areq,
 	 * typically 12 for ipsec
 	 */
 	to_talitos_ptr_len(&desc->ptr[4], cryptlen, is_sec1);
-	to_talitos_ptr_ext_set(&desc->ptr[4], 0, is_sec1);
 
 	sg_link_tbl_len = cryptlen;
 
@@ -1275,8 +1267,6 @@ static int ipsec_esp(struct talitos_edesc *edesc, struct aead_request *areq,
 			to_talitos_ptr(tbl_ptr, edesc->dma_link_tbl + offset,
 				       is_sec1);
 		}
-	} else {
-		edesc->icv_ool = false;
 	}
 
 	/* ICV data */
@@ -1386,7 +1376,7 @@ static struct talitos_edesc *talitos_edesc_alloc(struct device *dev,
 		alloc_len += icv_stashing ? authsize : 0;
 	}
 
-	edesc = kmalloc(alloc_len, GFP_DMA | flags);
+	edesc = kzalloc(alloc_len, GFP_DMA | flags);
 	if (!edesc) {
 		dev_err(dev, "could not allocate edescriptor\n");
 		err = ERR_PTR(-ENOMEM);
@@ -1467,7 +1457,6 @@ static int aead_decrypt(struct aead_request *req)
 				  DESC_HDR_MODE1_MDEU_CICV;
 
 		/* reset integrity check result bits */
-		edesc->desc.hdr_lo = 0;
 
 		return ipsec_esp(edesc, req, ipsec_esp_decrypt_hwauth_done);
 	}
@@ -1554,12 +1543,10 @@ static int common_nonsnoop(struct talitos_edesc *edesc,
 	bool is_sec1 = has_ftr_sec1(priv);
 
 	/* first DWORD empty */
-	desc->ptr[0] = zero_entry;
 
 	/* cipher iv */
 	to_talitos_ptr(&desc->ptr[1], edesc->iv_dma, is_sec1);
 	to_talitos_ptr_len(&desc->ptr[1], ivsize, is_sec1);
-	to_talitos_ptr_ext_set(&desc->ptr[1], 0, is_sec1);
 
 	/* cipher key */
 	map_single_talitos_ptr(dev, &desc->ptr[2], ctx->keylen,
@@ -1598,7 +1585,6 @@ static int common_nonsnoop(struct talitos_edesc *edesc,
 			       DMA_FROM_DEVICE);
 
 	/* last DWORD empty */
-	desc->ptr[6] = zero_entry;
 
 	if (sync_needed)
 		dma_sync_single_for_device(dev, edesc->dma_link_tbl,
@@ -1744,7 +1730,6 @@ static int common_nonsnoop_hash(struct talitos_edesc *edesc,
 	int sg_count;
 
 	/* first DWORD empty */
-	desc->ptr[0] = zero_entry;
 
 	/* hash context in */
 	if (!req_ctx->first || req_ctx->swinit) {
@@ -1753,8 +1738,6 @@ static int common_nonsnoop_hash(struct talitos_edesc *edesc,
 				       (char *)req_ctx->hw_context,
 				       DMA_TO_DEVICE);
 		req_ctx->swinit = 0;
-	} else {
-		desc->ptr[1] = zero_entry;
 	}
 	/* Indicate next op is not the first. */
 	req_ctx->first = 0;
@@ -1763,8 +1746,6 @@ static int common_nonsnoop_hash(struct talitos_edesc *edesc,
 	if (ctx->keylen)
 		map_single_talitos_ptr(dev, &desc->ptr[2], ctx->keylen,
 				       (char *)&ctx->key, DMA_TO_DEVICE);
-	else
-		desc->ptr[2] = zero_entry;
 
 	sg_count = edesc->src_nents ?: 1;
 	if (is_sec1 && sg_count > 1)
@@ -1781,7 +1762,6 @@ static int common_nonsnoop_hash(struct talitos_edesc *edesc,
 		sync_needed = true;
 
 	/* fifth DWORD empty */
-	desc->ptr[4] = zero_entry;
 
 	/* hash/HMAC out -or- hash context out */
 	if (req_ctx->last)
@@ -1794,7 +1774,6 @@ static int common_nonsnoop_hash(struct talitos_edesc *edesc,
 				       req_ctx->hw_context, DMA_FROM_DEVICE);
 
 	/* last DWORD empty */
-	desc->ptr[6] = zero_entry;
 
 	if (is_sec1 && from_talitos_ptr_len(&desc->ptr[3], true) == 0)
 		talitos_handle_buggy_hash(ctx, edesc, &desc->ptr[3]);
diff --git a/drivers/crypto/talitos.h b/drivers/crypto/talitos.h
index 8dd8f40e2771..6112ff1fc334 100644
--- a/drivers/crypto/talitos.h
+++ b/drivers/crypto/talitos.h
@@ -52,8 +52,6 @@ struct talitos_ptr {
 	__be32 ptr;     /* address */
 };
 
-static const struct talitos_ptr zero_entry;
-
 /* descriptor */
 struct talitos_desc {
 	__be32 hdr;                     /* header high bits */
-- 
2.13.3
