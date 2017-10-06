From: Christophe Leroy <christophe.leroy@c-s.fr>
Subject: [PATCH 07/18] crypto: talitos - zeroize the descriptor with memset()
Date: Fri,  6 Oct 2017 15:04:45 +0200 (CEST)
Message-ID: <96a79402d3d507f62c264f308b2d43e7cb902f6b.1507284818.git.christophe.leroy@c-s.fr>
References: <cover.1507284818.git.christophe.leroy@c-s.fr>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1507284818.git.christophe.leroy@c-s.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This patch zeroize the descriptor at allocation using memset().
This has two advantages:
- It reduces the number of places where data has to be set to 0
- It avoids reading memory and loading the cache with data that
will be entirely replaced.

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
---
 drivers/crypto/talitos.c | 19 +------------------
 drivers/crypto/talitos.h |  2 --
 2 files changed, 1 insertion(+), 20 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index a19b5d0300a9..266e7e626e12 100644
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
@@ -1125,7 +1122,6 @@ int talitos_sg_map(struct device *dev, struct scatterlist *src,
 	bool is_sec1 = has_ftr_sec1(priv);
 
 	to_talitos_ptr_len(ptr, len, is_sec1);
-	to_talitos_ptr_ext_set(ptr, 0, is_sec1);
 
 	if (sg_count == 1) {
 		to_talitos_ptr(ptr, sg_dma_address(src) + offset, is_sec1);
@@ -1197,11 +1193,9 @@ static int ipsec_esp(struct talitos_edesc *edesc, struct aead_request *areq,
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
@@ -1221,7 +1215,6 @@ static int ipsec_esp(struct talitos_edesc *edesc, struct aead_request *areq,
 	 * typically 12 for ipsec
 	 */
 	to_talitos_ptr_len(&desc->ptr[4], cryptlen, is_sec1);
-	to_talitos_ptr_ext_set(&desc->ptr[4], 0, is_sec1);
 
 	sg_link_tbl_len = cryptlen;
 
@@ -1406,6 +1399,7 @@ static struct talitos_edesc *talitos_edesc_alloc(struct device *dev,
 		err = ERR_PTR(-ENOMEM);
 		goto error_sg;
 	}
+	memset(&edesc->desc, 0, sizeof(edesc->desc));
 
 	edesc->src_nents = src_nents;
 	edesc->dst_nents = dst_nents;
@@ -1481,7 +1475,6 @@ static int aead_decrypt(struct aead_request *req)
 				  DESC_HDR_MODE1_MDEU_CICV;
 
 		/* reset integrity check result bits */
-		edesc->desc.hdr_lo = 0;
 
 		return ipsec_esp(edesc, req, ipsec_esp_decrypt_hwauth_done);
 	}
@@ -1576,12 +1569,10 @@ static int common_nonsnoop(struct talitos_edesc *edesc,
 	bool is_sec1 = has_ftr_sec1(priv);
 
 	/* first DWORD empty */
-	desc->ptr[0] = zero_entry;
 
 	/* cipher iv */
 	to_talitos_ptr(&desc->ptr[1], edesc->iv_dma, is_sec1);
 	to_talitos_ptr_len(&desc->ptr[1], ivsize, is_sec1);
-	to_talitos_ptr_ext_set(&desc->ptr[1], 0, is_sec1);
 
 	/* cipher key */
 	map_single_talitos_ptr(dev, &desc->ptr[2], ctx->keylen,
@@ -1620,7 +1611,6 @@ static int common_nonsnoop(struct talitos_edesc *edesc,
 			       DMA_FROM_DEVICE);
 
 	/* last DWORD empty */
-	desc->ptr[6] = zero_entry;
 
 	if (sync_needed)
 		dma_sync_single_for_device(dev, edesc->dma_link_tbl,
@@ -1766,7 +1756,6 @@ static int common_nonsnoop_hash(struct talitos_edesc *edesc,
 	int sg_count;
 
 	/* first DWORD empty */
-	desc->ptr[0] = zero_entry;
 
 	/* hash context in */
 	if (!req_ctx->first || req_ctx->swinit) {
@@ -1775,8 +1764,6 @@ static int common_nonsnoop_hash(struct talitos_edesc *edesc,
 				       (char *)req_ctx->hw_context,
 				       DMA_TO_DEVICE);
 		req_ctx->swinit = 0;
-	} else {
-		desc->ptr[1] = zero_entry;
 	}
 	/* Indicate next op is not the first. */
 	req_ctx->first = 0;
@@ -1785,8 +1772,6 @@ static int common_nonsnoop_hash(struct talitos_edesc *edesc,
 	if (ctx->keylen)
 		map_single_talitos_ptr(dev, &desc->ptr[2], ctx->keylen,
 				       (char *)&ctx->key, DMA_TO_DEVICE);
-	else
-		desc->ptr[2] = zero_entry;
 
 	sg_count = edesc->src_nents ?: 1;
 	if (is_sec1 && sg_count > 1)
@@ -1803,7 +1788,6 @@ static int common_nonsnoop_hash(struct talitos_edesc *edesc,
 		sync_needed = true;
 
 	/* fifth DWORD empty */
-	desc->ptr[4] = zero_entry;
 
 	/* hash/HMAC out -or- hash context out */
 	if (req_ctx->last)
@@ -1816,7 +1800,6 @@ static int common_nonsnoop_hash(struct talitos_edesc *edesc,
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
