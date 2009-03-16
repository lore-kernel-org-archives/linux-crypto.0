From: Lee Nipper <lee.nipper@gmail.com>
Subject: [PATCH 2/3] crypto: talitos - Add ablkcipher algorithms
Date: Sun, 15 Mar 2009 20:21:49 -0500
Message-ID: <1237166510-7312-3-git-send-email-lee.nipper@gmail.com>
References: <1237166510-7312-1-git-send-email-lee.nipper@gmail.com>
 <1237166510-7312-2-git-send-email-lee.nipper@gmail.com>
Cc: kim.phillips@freescale.com, Lee Nipper <lee.nipper@gmail.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.27]:4988 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756396AbZCPBWC (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 15 Mar 2009 21:22:02 -0400
Received: by qw-out-2122.google.com with SMTP id 5so2399696qwi.37
        for <linux-crypto@vger.kernel.org>; Sun, 15 Mar 2009 18:22:00 -0700 (PDT)
In-Reply-To: <1237166510-7312-2-git-send-email-lee.nipper@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add these ablkcipher algorithms:
cbc(aes),
cbc(des3_ede).

ipsec_esp_edesc is renamed to talitos_edesc
to use it in ablkcipher routines.
Added handling of chained scatterlists with zero length entry
because eseqiv uses it.
Added new map and unmap routines.

Signed-off-by: Lee Nipper <lee.nipper@gmail.com>
---
 drivers/crypto/talitos.c |  393 +++++++++++++++++++++++++++++++++++++++++-----
 1 files changed, 355 insertions(+), 38 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index d53e2eb..3338668 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -44,9 +44,14 @@
 #include <crypto/sha.h>
 #include <crypto/aead.h>
 #include <crypto/authenc.h>
+#include <crypto/skcipher.h>
+#include <crypto/scatterwalk.h>
 
 #include "talitos.h"
 
+static int testablkcipher = 0;
+module_param(testablkcipher, int, 0);
+
 #define TALITOS_TIMEOUT 100000
 #define TALITOS_MAX_DATA_LEN 65535
 
@@ -759,12 +764,62 @@ badkey:
 struct talitos_edesc {
 	int src_nents;
 	int dst_nents;
+	int src_is_chained;
+	int dst_is_chained;
 	int dma_len;
 	dma_addr_t dma_link_tbl;
 	struct talitos_desc desc;
 	struct talitos_ptr link_tbl[0];
 };
 
+static int talitos_map_sg(struct device *dev, struct scatterlist *sg,
+			  unsigned int nents, enum dma_data_direction dir,
+			  int chained)
+{
+	if (unlikely(chained))
+		while (sg) {
+			dma_map_sg(dev, sg, 1, dir);
+			sg = scatterwalk_sg_next(sg);
+		}
+	else
+		dma_map_sg(dev, sg, nents, dir);
+	return nents;
+}
+
+static void talitos_unmap_sg_chain(struct device *dev, struct scatterlist *sg,
+				   enum dma_data_direction dir)
+{
+	while (sg) {
+		dma_unmap_sg(dev, sg, 1, dir);
+		sg = scatterwalk_sg_next(sg);
+	}
+}
+
+static void talitos_sg_unmap(struct device *dev,
+			     struct talitos_edesc *edesc,
+			     struct scatterlist *src,
+			     struct scatterlist *dst)
+{
+	unsigned int src_nents = edesc->src_nents ? : 1;
+	unsigned int dst_nents = edesc->dst_nents ? : 1;
+
+	if (src != dst) {
+		if (edesc->src_is_chained)
+			talitos_unmap_sg_chain(dev, src, DMA_TO_DEVICE);
+		else
+			dma_unmap_sg(dev, src, src_nents, DMA_TO_DEVICE);
+
+		if (edesc->dst_is_chained)
+			talitos_unmap_sg_chain(dev, dst, DMA_FROM_DEVICE);
+		else
+			dma_unmap_sg(dev, dst, dst_nents, DMA_FROM_DEVICE);
+	} else
+		if (edesc->src_is_chained)
+			talitos_unmap_sg_chain(dev, src, DMA_BIDIRECTIONAL);
+		else
+			dma_unmap_sg(dev, src, src_nents, DMA_BIDIRECTIONAL);
+}
+
 static void ipsec_esp_unmap(struct device *dev,
 			    struct talitos_edesc *edesc,
 			    struct aead_request *areq)
@@ -776,15 +831,7 @@ static void ipsec_esp_unmap(struct device *dev,
 
 	dma_unmap_sg(dev, areq->assoc, 1, DMA_TO_DEVICE);
 
-	if (areq->src != areq->dst) {
-		dma_unmap_sg(dev, areq->src, edesc->src_nents ? : 1,
-			     DMA_TO_DEVICE);
-		dma_unmap_sg(dev, areq->dst, edesc->dst_nents ? : 1,
-			     DMA_FROM_DEVICE);
-	} else {
-		dma_unmap_sg(dev, areq->src, edesc->src_nents ? : 1,
-			     DMA_BIDIRECTIONAL);
-	}
+	talitos_sg_unmap(dev, edesc, areq->src, areq->dst);
 
 	if (edesc->dma_len)
 		dma_unmap_single(dev, edesc->dma_link_tbl, edesc->dma_len,
@@ -890,7 +937,7 @@ static int sg_to_link_tbl(struct scatterlist *sg, int sg_count,
 		link_tbl_ptr->j_extent = 0;
 		link_tbl_ptr++;
 		cryptlen -= sg_dma_len(sg);
-		sg = sg_next(sg);
+		sg = scatterwalk_sg_next(sg);
 	}
 
 	/* adjust (decrease) last one (or two) entry's len to cryptlen */
@@ -956,12 +1003,11 @@ static int ipsec_esp(struct talitos_edesc *edesc, struct aead_request *areq,
 	desc->ptr[4].len = cpu_to_be16(cryptlen);
 	desc->ptr[4].j_extent = authsize;
 
-	if (areq->src == areq->dst)
-		sg_count = dma_map_sg(dev, areq->src, edesc->src_nents ? : 1,
-				      DMA_BIDIRECTIONAL);
-	else
-		sg_count = dma_map_sg(dev, areq->src, edesc->src_nents ? : 1,
-				      DMA_TO_DEVICE);
+	sg_count = talitos_map_sg(dev, areq->src,
+				  edesc->src_nents ? : 1,
+				  (areq->src == areq->dst) ? DMA_BIDIRECTIONAL :
+				      DMA_TO_DEVICE,
+				  edesc->src_is_chained);
 
 	if (sg_count == 1) {
 		desc->ptr[4].ptr = cpu_to_be32(sg_dma_address(areq->src));
@@ -990,8 +1036,10 @@ static int ipsec_esp(struct talitos_edesc *edesc, struct aead_request *areq,
 	desc->ptr[5].j_extent = authsize;
 
 	if (areq->src != areq->dst) {
-		sg_count = dma_map_sg(dev, areq->dst, edesc->dst_nents ? : 1,
-				      DMA_FROM_DEVICE);
+		sg_count = talitos_map_sg(dev, areq->dst,
+					  edesc->dst_nents ? : 1,
+					  DMA_FROM_DEVICE,
+					  edesc->dst_is_chained);
 	}
 
 	if (sg_count == 1) {
@@ -1041,15 +1089,18 @@ static int ipsec_esp(struct talitos_edesc *edesc, struct aead_request *areq,
 /*
  * derive number of elements in scatterlist
  */
-static int sg_count(struct scatterlist *sg_list, int nbytes)
+static int sg_count(struct scatterlist *sg_list, int nbytes, int *chained)
 {
 	struct scatterlist *sg = sg_list;
 	int sg_nents = 0;
 
-	while (nbytes) {
+	*chained = 0;
+	while (nbytes > 0) {
 		sg_nents++;
 		nbytes -= sg->length;
-		sg = sg_next(sg);
+		if (!sg_is_last(sg) && (sg + 1)->length == 0)
+			*chained = 1;
+		sg = scatterwalk_sg_next(sg);
 	}
 
 	return sg_nents;
@@ -1058,28 +1109,32 @@ static int sg_count(struct scatterlist *sg_list, int nbytes)
 /*
  * allocate and map the extended descriptor
  */
-static struct talitos_edesc *ipsec_esp_edesc_alloc(struct aead_request *areq,
-						     int icv_stashing)
+static struct talitos_edesc *talitos_edesc_alloc(struct device *dev,
+						 struct scatterlist *src,
+						 struct scatterlist *dst,
+						 unsigned int cryptlen,
+						 unsigned int authsize,
+						 int icv_stashing,
+						 u32 cryptoflags)
 {
-	struct crypto_aead *authenc = crypto_aead_reqtfm(areq);
-	struct talitos_ctx *ctx = crypto_aead_ctx(authenc);
 	struct talitos_edesc *edesc;
 	int src_nents, dst_nents, alloc_len, dma_len;
-	gfp_t flags = areq->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP ? GFP_KERNEL :
+	int src_chained, dst_chained = 0;
+	gfp_t flags = cryptoflags & CRYPTO_TFM_REQ_MAY_SLEEP ? GFP_KERNEL :
 		      GFP_ATOMIC;
 
-	if (areq->cryptlen + ctx->authsize > TALITOS_MAX_DATA_LEN) {
-		dev_err(ctx->dev, "cryptlen exceeds h/w max limit\n");
+	if (cryptlen + authsize > TALITOS_MAX_DATA_LEN) {
+		dev_err(dev, "length exceeds h/w max limit\n");
 		return ERR_PTR(-EINVAL);
 	}
 
-	src_nents = sg_count(areq->src, areq->cryptlen + ctx->authsize);
+	src_nents = sg_count(src, cryptlen + authsize, &src_chained);
 	src_nents = (src_nents == 1) ? 0 : src_nents;
 
-	if (areq->dst == areq->src) {
+	if (dst == src) {
 		dst_nents = src_nents;
 	} else {
-		dst_nents = sg_count(areq->dst, areq->cryptlen + ctx->authsize);
+		dst_nents = sg_count(dst, cryptlen + authsize, &dst_chained);
 		dst_nents = (dst_nents == 1) ? 0 : dst_nents;
 	}
 
@@ -1091,28 +1146,41 @@ static struct talitos_edesc *ipsec_esp_edesc_alloc(struct aead_request *areq,
 	alloc_len = sizeof(struct talitos_edesc);
 	if (src_nents || dst_nents) {
 		dma_len = (src_nents + dst_nents + 2) *
-				 sizeof(struct talitos_ptr) + ctx->authsize;
+				 sizeof(struct talitos_ptr) + authsize;
 		alloc_len += dma_len;
 	} else {
 		dma_len = 0;
-		alloc_len += icv_stashing ? ctx->authsize : 0;
+		alloc_len += icv_stashing ? authsize : 0;
 	}
 
 	edesc = kmalloc(alloc_len, GFP_DMA | flags);
 	if (!edesc) {
-		dev_err(ctx->dev, "could not allocate edescriptor\n");
+		dev_err(dev, "could not allocate edescriptor\n");
 		return ERR_PTR(-ENOMEM);
 	}
 
 	edesc->src_nents = src_nents;
 	edesc->dst_nents = dst_nents;
+	edesc->src_is_chained = src_chained;
+	edesc->dst_is_chained = dst_chained;
 	edesc->dma_len = dma_len;
-	edesc->dma_link_tbl = dma_map_single(ctx->dev, &edesc->link_tbl[0],
+	edesc->dma_link_tbl = dma_map_single(dev, &edesc->link_tbl[0],
 					     edesc->dma_len, DMA_BIDIRECTIONAL);
 
 	return edesc;
 }
 
+static struct talitos_edesc *aead_edesc_alloc(struct aead_request *areq,
+					      int icv_stashing)
+{
+	struct crypto_aead *authenc = crypto_aead_reqtfm(areq);
+	struct talitos_ctx *ctx = crypto_aead_ctx(authenc);
+
+	return talitos_edesc_alloc(ctx->dev, areq->src, areq->dst,
+				   areq->cryptlen, ctx->authsize, icv_stashing,
+				   areq->base.flags);
+}
+
 static int aead_encrypt(struct aead_request *req)
 {
 	struct crypto_aead *authenc = crypto_aead_reqtfm(req);
@@ -1120,7 +1188,7 @@ static int aead_encrypt(struct aead_request *req)
 	struct talitos_edesc *edesc;
 
 	/* allocate extended descriptor */
-	edesc = ipsec_esp_edesc_alloc(req, 0);
+	edesc = aead_edesc_alloc(req, 0);
 	if (IS_ERR(edesc))
 		return PTR_ERR(edesc);
 
@@ -1145,7 +1213,7 @@ static int aead_decrypt(struct aead_request *req)
 	req->cryptlen -= authsize;
 
 	/* allocate extended descriptor */
-	edesc = ipsec_esp_edesc_alloc(req, 1);
+	edesc = aead_edesc_alloc(req, 1);
 	if (IS_ERR(edesc))
 		return PTR_ERR(edesc);
 
@@ -1192,7 +1260,7 @@ static int aead_givencrypt(struct aead_givcrypt_request *req)
 	struct talitos_edesc *edesc;
 
 	/* allocate extended descriptor */
-	edesc = ipsec_esp_edesc_alloc(areq, 0);
+	edesc = aead_edesc_alloc(areq, 0);
 	if (IS_ERR(edesc))
 		return PTR_ERR(edesc);
 
@@ -1207,6 +1275,201 @@ static int aead_givencrypt(struct aead_givcrypt_request *req)
 			 ipsec_esp_encrypt_done);
 }
 
+static int ablkcipher_setkey(struct crypto_ablkcipher *cipher,
+			     const u8 *key, unsigned int keylen)
+{
+	struct talitos_ctx *ctx = crypto_ablkcipher_ctx(cipher);
+	struct ablkcipher_alg *alg = crypto_ablkcipher_alg(cipher);
+
+	if (keylen > TALITOS_MAX_KEY_SIZE)
+		goto badkey;
+
+	if (keylen < alg->min_keysize || keylen > alg->max_keysize)
+		goto badkey;
+
+	memcpy(&ctx->key, key, keylen);
+	ctx->keylen = keylen;
+
+	return 0;
+
+badkey:
+	crypto_ablkcipher_set_flags(cipher, CRYPTO_TFM_RES_BAD_KEY_LEN);
+	return -EINVAL;
+}
+
+static void common_nonsnoop_unmap(struct device *dev,
+				  struct talitos_edesc *edesc,
+				  struct ablkcipher_request *areq)
+{
+	unmap_single_talitos_ptr(dev, &edesc->desc.ptr[5], DMA_FROM_DEVICE);
+	unmap_single_talitos_ptr(dev, &edesc->desc.ptr[2], DMA_TO_DEVICE);
+	unmap_single_talitos_ptr(dev, &edesc->desc.ptr[1], DMA_TO_DEVICE);
+
+	talitos_sg_unmap(dev, edesc, areq->src, areq->dst);
+
+	if (edesc->dma_len)
+		dma_unmap_single(dev, edesc->dma_link_tbl, edesc->dma_len,
+				 DMA_BIDIRECTIONAL);
+}
+
+static void ablkcipher_done(struct device *dev,
+			    struct talitos_desc *desc, void *context,
+			    int err)
+{
+	struct ablkcipher_request *areq = context;
+	struct talitos_edesc *edesc =
+		 container_of(desc, struct talitos_edesc, desc);
+
+	common_nonsnoop_unmap(dev, edesc, areq);
+
+	kfree(edesc);
+
+	areq->base.complete(&areq->base, err);
+}
+
+static int common_nonsnoop(struct talitos_edesc *edesc,
+			   struct ablkcipher_request *areq,
+			   u8 *giv,
+			   void (*callback) (struct device *dev,
+					     struct talitos_desc *desc,
+					     void *context, int error))
+{
+	struct crypto_ablkcipher *cipher = crypto_ablkcipher_reqtfm(areq);
+	struct talitos_ctx *ctx = crypto_ablkcipher_ctx(cipher);
+	struct device *dev = ctx->dev;
+	struct talitos_desc *desc = &edesc->desc;
+	unsigned int cryptlen = areq->nbytes;
+	unsigned int ivsize;
+	int sg_count, ret;
+
+	/* first DWORD empty */
+	desc->ptr[0].len = 0;
+	desc->ptr[0].ptr = 0;
+	desc->ptr[0].j_extent = 0;
+
+	/* cipher iv */
+	ivsize = crypto_ablkcipher_ivsize(cipher);
+	map_single_talitos_ptr(dev, &desc->ptr[1], ivsize, giv ?: areq->info, 0,
+			       DMA_TO_DEVICE);
+
+	/* cipher key */
+	map_single_talitos_ptr(dev, &desc->ptr[2], ctx->keylen,
+			       (char *)&ctx->key, 0, DMA_TO_DEVICE);
+
+	/*
+	 * cipher in
+	 */
+	desc->ptr[3].len = cpu_to_be16(cryptlen);
+	desc->ptr[3].j_extent = 0;
+
+	sg_count = talitos_map_sg(dev, areq->src,
+				  edesc->src_nents ? : 1,
+				  (areq->src == areq->dst) ? DMA_BIDIRECTIONAL :
+				      DMA_TO_DEVICE,
+				  edesc->src_is_chained);
+
+	if (sg_count == 1) {
+		desc->ptr[3].ptr = cpu_to_be32(sg_dma_address(areq->src));
+	} else {
+		sg_count = sg_to_link_tbl(areq->src, sg_count, cryptlen,
+					  &edesc->link_tbl[0]);
+		if (sg_count > 1) {
+			desc->ptr[3].j_extent |= DESC_PTR_LNKTBL_JUMP;
+			desc->ptr[3].ptr = cpu_to_be32(edesc->dma_link_tbl);
+			dma_sync_single_for_device(ctx->dev, edesc->dma_link_tbl,
+						   edesc->dma_len, DMA_BIDIRECTIONAL);
+		} else {
+			/* Only one segment now, so no link tbl needed */
+			desc->ptr[3].ptr = cpu_to_be32(sg_dma_address(areq->src));
+		}
+	}
+
+	/* cipher out */
+	desc->ptr[4].len = cpu_to_be16(cryptlen);
+	desc->ptr[4].j_extent = 0;
+
+	if (areq->src != areq->dst) {
+		sg_count = talitos_map_sg(dev, areq->dst,
+					  edesc->dst_nents ? : 1,
+					  DMA_FROM_DEVICE,
+					  edesc->dst_is_chained);
+	}
+
+	if (sg_count == 1) {
+		desc->ptr[4].ptr = cpu_to_be32(sg_dma_address(areq->dst));
+	} else {
+		struct talitos_ptr *link_tbl_ptr =
+			&edesc->link_tbl[edesc->src_nents + 1];
+
+		desc->ptr[4].j_extent |= DESC_PTR_LNKTBL_JUMP;
+		desc->ptr[4].ptr = cpu_to_be32((struct talitos_ptr *)
+					       edesc->dma_link_tbl +
+					       edesc->src_nents + 1);
+		sg_count = sg_to_link_tbl(areq->dst, sg_count, cryptlen,
+					  link_tbl_ptr);
+		dma_sync_single_for_device(ctx->dev, edesc->dma_link_tbl,
+					   edesc->dma_len, DMA_BIDIRECTIONAL);
+	}
+
+	/* iv out */
+	map_single_talitos_ptr(dev, &desc->ptr[5], ivsize, ctx->iv, 0,
+			       DMA_FROM_DEVICE);
+
+	/* last DWORD empty */
+	desc->ptr[6].len = 0;
+	desc->ptr[6].ptr = 0;
+	desc->ptr[6].j_extent = 0;
+
+	ret = talitos_submit(dev, desc, callback, areq);
+	if (ret != -EINPROGRESS) {
+		common_nonsnoop_unmap(dev, edesc, areq);
+		kfree(edesc);
+	}
+	return ret;
+}
+
+static struct talitos_edesc *ablkcipher_edesc_alloc(struct ablkcipher_request *areq)
+{
+	struct crypto_ablkcipher *cipher = crypto_ablkcipher_reqtfm(areq);
+	struct talitos_ctx *ctx = crypto_ablkcipher_ctx(cipher);
+
+	return talitos_edesc_alloc(ctx->dev, areq->src, areq->dst, areq->nbytes,
+				   0, 0, areq->base.flags);
+}
+
+static int ablkcipher_encrypt(struct ablkcipher_request *areq)
+{
+	struct crypto_ablkcipher *cipher = crypto_ablkcipher_reqtfm(areq);
+	struct talitos_ctx *ctx = crypto_ablkcipher_ctx(cipher);
+	struct talitos_edesc *edesc;
+
+	/* allocate extended descriptor */
+	edesc = ablkcipher_edesc_alloc(areq);
+	if (IS_ERR(edesc))
+		return PTR_ERR(edesc);
+
+	/* set encrypt */
+	edesc->desc.hdr = ctx->desc_hdr_template | DESC_HDR_MODE0_ENCRYPT;
+
+	return common_nonsnoop(edesc, areq, NULL, ablkcipher_done);
+}
+
+static int ablkcipher_decrypt(struct ablkcipher_request *areq)
+{
+	struct crypto_ablkcipher *cipher = crypto_ablkcipher_reqtfm(areq);
+	struct talitos_ctx *ctx = crypto_ablkcipher_ctx(cipher);
+	struct talitos_edesc *edesc;
+
+	/* allocate extended descriptor */
+	edesc = ablkcipher_edesc_alloc(areq);
+	if (IS_ERR(edesc))
+		return PTR_ERR(edesc);
+
+	edesc->desc.hdr = ctx->desc_hdr_template | DESC_HDR_DIR_INBOUND;
+
+	return common_nonsnoop(edesc, areq, NULL, ablkcipher_done);
+}
+
 struct talitos_alg_template {
 	struct crypto_alg alg;
 	__be32 desc_hdr_template;
@@ -1372,6 +1635,52 @@ static struct talitos_alg_template driver_algs[] = {
 		                     DESC_HDR_MODE1_MDEU_INIT |
 		                     DESC_HDR_MODE1_MDEU_PAD |
 		                     DESC_HDR_MODE1_MDEU_MD5_HMAC,
+	},
+	/* ABLKCIPHER algorithms. */
+	{
+		.alg = {
+			.cra_name = "cbc(aes)",
+			.cra_driver_name = "cbc-aes-talitos",
+			.cra_blocksize = AES_BLOCK_SIZE,
+			.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER |
+                                     CRYPTO_ALG_ASYNC,
+			.cra_type = &crypto_ablkcipher_type,
+			.cra_ablkcipher = {
+				.setkey = ablkcipher_setkey,
+				.encrypt = ablkcipher_encrypt,
+				.decrypt = ablkcipher_decrypt,
+				.geniv = "eseqiv",
+				.min_keysize = AES_MIN_KEY_SIZE,
+				.max_keysize = AES_MAX_KEY_SIZE,
+				.ivsize = AES_BLOCK_SIZE,
+			}
+		},
+		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
+				     DESC_HDR_SEL0_AESU |
+				     DESC_HDR_MODE0_AESU_CBC,
+	},
+	{
+		.alg = {
+			.cra_name = "cbc(des3_ede)",
+			.cra_driver_name = "cbc-3des-talitos",
+			.cra_blocksize = DES3_EDE_BLOCK_SIZE,
+			.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER |
+                                     CRYPTO_ALG_ASYNC,
+			.cra_type = &crypto_ablkcipher_type,
+			.cra_ablkcipher = {
+				.setkey = ablkcipher_setkey,
+				.encrypt = ablkcipher_encrypt,
+				.decrypt = ablkcipher_decrypt,
+				.geniv = "eseqiv",
+				.min_keysize = DES3_EDE_KEY_SIZE,
+				.max_keysize = DES3_EDE_KEY_SIZE,
+				.ivsize = DES3_EDE_BLOCK_SIZE,
+			}
+		},
+		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
+			             DESC_HDR_SEL0_DEU |
+		                     DESC_HDR_MODE0_DEU_CBC |
+		                     DESC_HDR_MODE0_DEU_3DES,
 	}
 };
 
@@ -1641,6 +1950,14 @@ static int talitos_probe(struct of_device *ofdev,
 		if (hw_supports(dev, driver_algs[i].desc_hdr_template)) {
 			struct talitos_crypto_alg *t_alg;
 
+			/* For testing, we can omit the AEAD algorithms
+			 * and use the ABLKCIPHER algorithms for IPsec.
+			 */
+			if (testablkcipher &&
+			    ((driver_algs[i].alg.cra_flags & CRYPTO_ALG_TYPE_MASK)
+					== CRYPTO_ALG_TYPE_AEAD))
+				continue;
+
 			t_alg = talitos_alg_alloc(dev, &driver_algs[i]);
 			if (IS_ERR(t_alg)) {
 				err = PTR_ERR(t_alg);
-- 
1.5.6.3

