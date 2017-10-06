From: Christophe Leroy <christophe.leroy@c-s.fr>
Subject: [PATCH 14/18] crypto: talitos - simplify tests in ipsec_esp()
Date: Fri,  6 Oct 2017 15:04:59 +0200 (CEST)
Message-ID: <f69ca0d61b63cb08fb4de833a4254cf9ed279f69.1507284818.git.christophe.leroy@c-s.fr>
References: <cover.1507284818.git.christophe.leroy@c-s.fr>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1507284818.git.christophe.leroy@c-s.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Do (desc->hdr & DESC_HDR_TYPE_IPSEC_ESP) only once.
Limit number of if/else paths

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
---
 drivers/crypto/talitos.c | 42 ++++++++++++++++++++----------------------
 1 file changed, 20 insertions(+), 22 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 7e96db75347a..307d534a0f2f 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -938,12 +938,15 @@ static void ipsec_esp_unmap(struct device *dev,
 	struct crypto_aead *aead = crypto_aead_reqtfm(areq);
 	struct talitos_ctx *ctx = crypto_aead_ctx(aead);
 	unsigned int ivsize = crypto_aead_ivsize(aead);
+	bool is_ipsec_esp = edesc->desc.hdr & DESC_HDR_TYPE_IPSEC_ESP;
+	struct talitos_ptr *civ_ptr = &edesc->desc.ptr[is_ipsec_esp ? 2 : 3];
+	struct talitos_ptr *ckey_ptr = &edesc->desc.ptr[is_ipsec_esp ? 3 : 2];
 
-	if (edesc->desc.hdr & DESC_HDR_TYPE_IPSEC_ESP)
+	if (is_ipsec_esp)
 		unmap_single_talitos_ptr(dev, &edesc->desc.ptr[6],
 					 DMA_FROM_DEVICE);
-	unmap_single_talitos_ptr(dev, &edesc->desc.ptr[3], DMA_TO_DEVICE);
-	unmap_single_talitos_ptr(dev, &edesc->desc.ptr[2], DMA_TO_DEVICE);
+	unmap_single_talitos_ptr(dev, ckey_ptr, DMA_TO_DEVICE);
+	unmap_single_talitos_ptr(dev, civ_ptr, DMA_TO_DEVICE);
 	unmap_single_talitos_ptr(dev, &edesc->desc.ptr[0], DMA_TO_DEVICE);
 
 	talitos_sg_unmap(dev, edesc, areq->src, areq->dst, areq->cryptlen,
@@ -953,7 +956,7 @@ static void ipsec_esp_unmap(struct device *dev,
 		dma_unmap_single(dev, edesc->dma_link_tbl, edesc->dma_len,
 				 DMA_BIDIRECTIONAL);
 
-	if (!(edesc->desc.hdr & DESC_HDR_TYPE_IPSEC_ESP)) {
+	if (!is_ipsec_esp) {
 		unsigned int dst_nents = edesc->dst_nents ? : 1;
 
 		sg_pcopy_to_buffer(areq->dst, dst_nents, ctx->iv, ivsize,
@@ -1156,6 +1159,9 @@ static int ipsec_esp(struct talitos_edesc *edesc, struct aead_request *areq,
 	bool sync_needed = false;
 	struct talitos_private *priv = dev_get_drvdata(dev);
 	bool is_sec1 = has_ftr_sec1(priv);
+	bool is_ipsec_esp = desc->hdr & DESC_HDR_TYPE_IPSEC_ESP;
+	struct talitos_ptr *civ_ptr = &desc->ptr[is_ipsec_esp ? 2 : 3];
+	struct talitos_ptr *ckey_ptr = &desc->ptr[is_ipsec_esp ? 3 : 2];
 
 	/* hmac key */
 	map_single_talitos_ptr(dev, &desc->ptr[0], ctx->authkeylen, &ctx->key,
@@ -1180,20 +1186,12 @@ static int ipsec_esp(struct talitos_edesc *edesc, struct aead_request *areq,
 	}
 
 	/* cipher iv */
-	if (desc->hdr & DESC_HDR_TYPE_IPSEC_ESP)
-		to_talitos_ptr(&desc->ptr[2], edesc->iv_dma, ivsize, is_sec1);
-	else
-		to_talitos_ptr(&desc->ptr[3], edesc->iv_dma, ivsize, is_sec1);
+	to_talitos_ptr(civ_ptr, edesc->iv_dma, ivsize, is_sec1);
 
 	/* cipher key */
-	if (desc->hdr & DESC_HDR_TYPE_IPSEC_ESP)
-		map_single_talitos_ptr(dev, &desc->ptr[3], ctx->enckeylen,
-				       (char *)&ctx->key + ctx->authkeylen,
-				       DMA_TO_DEVICE);
-	else
-		map_single_talitos_ptr(dev, &desc->ptr[2], ctx->enckeylen,
-				       (char *)&ctx->key + ctx->authkeylen,
-				       DMA_TO_DEVICE);
+	map_single_talitos_ptr(dev, ckey_ptr, ctx->enckeylen,
+			       (char *)&ctx->key + ctx->authkeylen,
+			       DMA_TO_DEVICE);
 
 	/*
 	 * cipher in
@@ -1203,10 +1201,10 @@ static int ipsec_esp(struct talitos_edesc *edesc, struct aead_request *areq,
 	 */
 	sg_link_tbl_len = cryptlen;
 
-	if (desc->hdr & DESC_HDR_TYPE_IPSEC_ESP) {
+	if (is_ipsec_esp) {
 		to_talitos_ptr_ext_set(&desc->ptr[4], authsize, is_sec1);
 
-		if (edesc->desc.hdr & DESC_HDR_MODE1_MDEU_CICV)
+		if (desc->hdr & DESC_HDR_MODE1_MDEU_CICV)
 			sg_link_tbl_len += authsize;
 	}
 
@@ -1228,7 +1226,7 @@ static int ipsec_esp(struct talitos_edesc *edesc, struct aead_request *areq,
 	ret = talitos_sg_map(dev, areq->dst, cryptlen, edesc, &desc->ptr[5],
 			     sg_count, areq->assoclen, tbl_off);
 
-	if (desc->hdr & DESC_HDR_TYPE_IPSEC_ESP)
+	if (is_ipsec_esp)
 		to_talitos_ptr_ext_or(&desc->ptr[5], authsize, is_sec1);
 
 	/* ICV data */
@@ -1237,7 +1235,7 @@ static int ipsec_esp(struct talitos_edesc *edesc, struct aead_request *areq,
 		edesc->icv_ool = true;
 		sync_needed = true;
 
-		if (desc->hdr & DESC_HDR_TYPE_IPSEC_ESP) {
+		if (is_ipsec_esp) {
 			struct talitos_ptr *tbl_ptr = &edesc->link_tbl[tbl_off];
 			int offset = (edesc->src_nents + edesc->dst_nents + 2) *
 				     sizeof(struct talitos_ptr) + authsize;
@@ -1260,7 +1258,7 @@ static int ipsec_esp(struct talitos_edesc *edesc, struct aead_request *areq,
 
 			to_talitos_ptr(&desc->ptr[6], addr, authsize, is_sec1);
 		}
-	} else if (!(desc->hdr & DESC_HDR_TYPE_IPSEC_ESP)) {
+	} else if (!is_ipsec_esp) {
 		ret = talitos_sg_map(dev, areq->dst, authsize, edesc,
 				     &desc->ptr[6], sg_count, areq->assoclen +
 							      cryptlen,
@@ -1277,7 +1275,7 @@ static int ipsec_esp(struct talitos_edesc *edesc, struct aead_request *areq,
 	}
 
 	/* iv out */
-	if (desc->hdr & DESC_HDR_TYPE_IPSEC_ESP)
+	if (is_ipsec_esp)
 		map_single_talitos_ptr(dev, &desc->ptr[6], ivsize, ctx->iv,
 				       DMA_FROM_DEVICE);
 
-- 
2.13.3
