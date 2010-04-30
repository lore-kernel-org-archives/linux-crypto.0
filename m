From: Lee Nipper <lee.nipper@gmail.com>
Subject: [PATCHv2 3/3] crypto: talitos - add hash algorithms
Date: Fri, 30 Apr 2010 07:21:23 -0500
Message-ID: <1272630083-5705-1-git-send-email-lee.nipper@gmail.com>
Cc: Lee Nipper <lee.nipper@gmail.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-yw0-f194.google.com ([209.85.211.194]:64377 "EHLO
	mail-yw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757912Ab0D3Rsu (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 30 Apr 2010 13:48:50 -0400
Received: by ywh32 with SMTP id 32so281246ywh.33
        for <linux-crypto@vger.kernel.org>; Fri, 30 Apr 2010 10:48:49 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add the following alorithms to talitos:
    md5,
    sha1,
    sha256,
    sha384,
    sha512.
These are all type ahash.

Signed-off-by: Lee Nipper <lee.nipper@gmail.com>
---
This is v2 of this patch.
It incorporates changes made after Kim's review.

 drivers/crypto/talitos.c |  544 ++++++++++++++++++++++++++++++++++++++++++++--
 drivers/crypto/talitos.h |    8 +
 2 files changed, 534 insertions(+), 18 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 9d52d43..4ab22bc 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -42,6 +42,7 @@
 #include <crypto/aes.h>
 #include <crypto/des.h>
 #include <crypto/sha.h>
+#include <crypto/md5.h>
 #include <crypto/aead.h>
 #include <crypto/authenc.h>
 #include <crypto/skcipher.h>
@@ -66,6 +67,13 @@ struct talitos_ptr {
 	__be32 ptr;	/* address */
 };
 
+static const struct talitos_ptr zero_entry = {
+	.len = 0,
+	.j_extent = 0,
+	.eptr = 0,
+	.ptr = 0
+};
+
 /* descriptor */
 struct talitos_desc {
 	__be32 hdr;			/* header high bits */
@@ -693,7 +701,7 @@ static void talitos_unregister_rng(struct device *dev)
 #define TALITOS_MAX_KEY_SIZE		64
 #define TALITOS_MAX_IV_LENGTH		16 /* max of AES_BLOCK_SIZE, DES3_EDE_BLOCK_SIZE */
 
-#define MD5_DIGEST_SIZE   16
+#define MD5_BLOCK_SIZE    64
 
 struct talitos_ctx {
 	struct device *dev;
@@ -706,6 +714,22 @@ struct talitos_ctx {
 	unsigned int authsize;
 };
 
+#define HASH_MAX_BLOCK_SIZE		SHA512_BLOCK_SIZE
+#define TALITOS_MDEU_MAX_CONTEXT_SIZE	TALITOS_MDEU_CONTEXT_SIZE_SHA384_SHA512
+
+struct talitos_ahash_req_ctx {
+	u64 count;
+	u8 hw_context[TALITOS_MDEU_MAX_CONTEXT_SIZE];
+	unsigned int hw_context_size;
+	u8 buf[HASH_MAX_BLOCK_SIZE];
+	u8 bufnext[HASH_MAX_BLOCK_SIZE];
+	unsigned int first;
+	unsigned int last;
+	unsigned int to_hash_later;
+	struct scatterlist bufsl[2];
+	struct scatterlist *psrc;
+};
+
 static int aead_setauthsize(struct crypto_aead *authenc,
 			    unsigned int authsize)
 {
@@ -822,10 +846,14 @@ static void talitos_sg_unmap(struct device *dev,
 		else
 			dma_unmap_sg(dev, src, src_nents, DMA_TO_DEVICE);
 
-		if (edesc->dst_is_chained)
-			talitos_unmap_sg_chain(dev, dst, DMA_FROM_DEVICE);
-		else
-			dma_unmap_sg(dev, dst, dst_nents, DMA_FROM_DEVICE);
+		if (dst) {
+			if (edesc->dst_is_chained)
+				talitos_unmap_sg_chain(dev, dst,
+						       DMA_FROM_DEVICE);
+			else
+				dma_unmap_sg(dev, dst, dst_nents,
+					     DMA_FROM_DEVICE);
+		}
 	} else
 		if (edesc->src_is_chained)
 			talitos_unmap_sg_chain(dev, src, DMA_BIDIRECTIONAL);
@@ -1115,12 +1143,67 @@ static int sg_count(struct scatterlist *sg_list, int nbytes, int *chained)
 	return sg_nents;
 }
 
+/**
+ * sg_copy_end_to_buffer - Copy end data from SG list to a linear buffer
+ * @sgl:		 The SG list
+ * @nents:		 Number of SG entries
+ * @buf:		 Where to copy to
+ * @buflen:		 The number of bytes to copy
+ * @skip:		 The number of bytes to skip before copying.
+ *                       Note: skip + buflen should equal SG total size.
+ *
+ * Returns the number of copied bytes.
+ *
+ **/
+static size_t sg_copy_end_to_buffer(struct scatterlist *sgl, unsigned int nents,
+				    void *buf, size_t buflen, unsigned int skip)
+{
+	unsigned int offset = 0;
+	unsigned int boffset = 0;
+	struct sg_mapping_iter miter;
+	unsigned long flags;
+	unsigned int sg_flags = SG_MITER_ATOMIC;
+	size_t total_buffer = buflen + skip;
+
+	sg_flags |= SG_MITER_FROM_SG;
+
+	sg_miter_start(&miter, sgl, nents, sg_flags);
+
+	local_irq_save(flags);
+
+	while (sg_miter_next(&miter) && offset < total_buffer) {
+		unsigned int len;
+		unsigned int ignore;
+
+		if ((offset + miter.length) > skip) {
+			if (offset < skip) {
+				/* Copy part of this segment */
+				ignore = skip - offset;
+				len = miter.length - ignore;
+				memcpy(buf + boffset, miter.addr + ignore, len);
+			} else {
+				/* Copy all of this segment */
+				len = miter.length;
+				memcpy(buf + boffset, miter.addr, len);
+			}
+			boffset += len;
+		}
+		offset += miter.length;
+	}
+
+	sg_miter_stop(&miter);
+
+	local_irq_restore(flags);
+	return boffset;
+}
+
 /*
  * allocate and map the extended descriptor
  */
 static struct talitos_edesc *talitos_edesc_alloc(struct device *dev,
 						 struct scatterlist *src,
 						 struct scatterlist *dst,
+						 int hash_result,
 						 unsigned int cryptlen,
 						 unsigned int authsize,
 						 int icv_stashing,
@@ -1140,11 +1223,16 @@ static struct talitos_edesc *talitos_edesc_alloc(struct device *dev,
 	src_nents = sg_count(src, cryptlen + authsize, &src_chained);
 	src_nents = (src_nents == 1) ? 0 : src_nents;
 
-	if (dst == src) {
-		dst_nents = src_nents;
+	if (hash_result) {
+		dst_nents = 0;
 	} else {
-		dst_nents = sg_count(dst, cryptlen + authsize, &dst_chained);
-		dst_nents = (dst_nents == 1) ? 0 : dst_nents;
+		if (dst == src) {
+			dst_nents = src_nents;
+		} else {
+			dst_nents = sg_count(dst, cryptlen + authsize,
+					     &dst_chained);
+			dst_nents = (dst_nents == 1) ? 0 : dst_nents;
+		}
 	}
 
 	/*
@@ -1173,8 +1261,10 @@ static struct talitos_edesc *talitos_edesc_alloc(struct device *dev,
 	edesc->src_is_chained = src_chained;
 	edesc->dst_is_chained = dst_chained;
 	edesc->dma_len = dma_len;
-	edesc->dma_link_tbl = dma_map_single(dev, &edesc->link_tbl[0],
-					     edesc->dma_len, DMA_BIDIRECTIONAL);
+	if (dma_len)
+		edesc->dma_link_tbl = dma_map_single(dev, &edesc->link_tbl[0],
+						     edesc->dma_len,
+						     DMA_BIDIRECTIONAL);
 
 	return edesc;
 }
@@ -1185,7 +1275,7 @@ static struct talitos_edesc *aead_edesc_alloc(struct aead_request *areq,
 	struct crypto_aead *authenc = crypto_aead_reqtfm(areq);
 	struct talitos_ctx *ctx = crypto_aead_ctx(authenc);
 
-	return talitos_edesc_alloc(ctx->dev, areq->src, areq->dst,
+	return talitos_edesc_alloc(ctx->dev, areq->src, areq->dst, 0,
 				   areq->cryptlen, ctx->authsize, icv_stashing,
 				   areq->base.flags);
 }
@@ -1442,8 +1532,8 @@ static struct talitos_edesc *ablkcipher_edesc_alloc(struct ablkcipher_request *
 	struct crypto_ablkcipher *cipher = crypto_ablkcipher_reqtfm(areq);
 	struct talitos_ctx *ctx = crypto_ablkcipher_ctx(cipher);
 
-	return talitos_edesc_alloc(ctx->dev, areq->src, areq->dst, areq->nbytes,
-				   0, 0, areq->base.flags);
+	return talitos_edesc_alloc(ctx->dev, areq->src, areq->dst, 0,
+				   areq->nbytes, 0, 0, areq->base.flags);
 }
 
 static int ablkcipher_encrypt(struct ablkcipher_request *areq)
@@ -1479,6 +1569,286 @@ static int ablkcipher_decrypt(struct ablkcipher_request *areq)
 	return common_nonsnoop(edesc, areq, NULL, ablkcipher_done);
 }
 
+static void common_nonsnoop_hash_unmap(struct device *dev,
+				       struct talitos_edesc *edesc,
+				       struct ahash_request *areq)
+{
+	struct talitos_ahash_req_ctx *req_ctx = ahash_request_ctx(areq);
+
+	unmap_single_talitos_ptr(dev, &edesc->desc.ptr[5], DMA_FROM_DEVICE);
+
+	/* When using hashctx-in, must unmap it. */
+	if (edesc->desc.ptr[1].len)
+		unmap_single_talitos_ptr(dev, &edesc->desc.ptr[1],
+					 DMA_TO_DEVICE);
+
+	if (edesc->desc.ptr[2].len)
+		unmap_single_talitos_ptr(dev, &edesc->desc.ptr[2],
+					 DMA_TO_DEVICE);
+
+	talitos_sg_unmap(dev, edesc, req_ctx->psrc, NULL);
+
+	if (edesc->dma_len)
+		dma_unmap_single(dev, edesc->dma_link_tbl, edesc->dma_len,
+				 DMA_BIDIRECTIONAL);
+
+}
+
+static void ahash_done(struct device *dev,
+		       struct talitos_desc *desc, void *context,
+		       int err)
+{
+	struct ahash_request *areq = context;
+	struct talitos_edesc *edesc =
+		 container_of(desc, struct talitos_edesc, desc);
+	struct talitos_ahash_req_ctx *req_ctx = ahash_request_ctx(areq);
+
+	if (!req_ctx->last && req_ctx->to_hash_later) {
+		/* Position any partial block for next update/final/finup */
+		memcpy(req_ctx->buf, req_ctx->bufnext, req_ctx->to_hash_later);
+	}
+	common_nonsnoop_hash_unmap(dev, edesc, areq);
+
+	kfree(edesc);
+
+	areq->base.complete(&areq->base, err);
+}
+
+static int common_nonsnoop_hash(struct talitos_edesc *edesc,
+				struct ahash_request *areq, unsigned int length,
+				void (*callback) (struct device *dev,
+						  struct talitos_desc *desc,
+						  void *context, int error))
+{
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
+	struct talitos_ctx *ctx = crypto_ahash_ctx(tfm);
+	struct talitos_ahash_req_ctx *req_ctx = ahash_request_ctx(areq);
+	struct device *dev = ctx->dev;
+	struct talitos_desc *desc = &edesc->desc;
+	int sg_count, ret;
+
+	/* first DWORD empty */
+	desc->ptr[0] = zero_entry;
+
+	/* hash context in (if not first) */
+	if (!req_ctx->first) {
+		map_single_talitos_ptr(dev, &desc->ptr[1],
+				       req_ctx->hw_context_size,
+				       (char *)req_ctx->hw_context, 0,
+				       DMA_TO_DEVICE);
+	} else {
+		desc->ptr[1] = zero_entry;
+		/* Indicate next op is not the first. */
+		req_ctx->first = 0;
+	}
+
+	/* HMAC key */
+	if (ctx->keylen)
+		map_single_talitos_ptr(dev, &desc->ptr[2], ctx->keylen,
+				       (char *)&ctx->key, 0, DMA_TO_DEVICE);
+	else
+		desc->ptr[2] = zero_entry;
+
+	/*
+	 * data in
+	 */
+	desc->ptr[3].len = cpu_to_be16(length);
+	desc->ptr[3].j_extent = 0;
+
+	sg_count = talitos_map_sg(dev, req_ctx->psrc,
+				  edesc->src_nents ? : 1,
+				  DMA_TO_DEVICE,
+				  edesc->src_is_chained);
+
+	if (sg_count == 1) {
+		to_talitos_ptr(&desc->ptr[3], sg_dma_address(req_ctx->psrc));
+	} else {
+		sg_count = sg_to_link_tbl(req_ctx->psrc, sg_count, length,
+					  &edesc->link_tbl[0]);
+		if (sg_count > 1) {
+			desc->ptr[3].j_extent |= DESC_PTR_LNKTBL_JUMP;
+			to_talitos_ptr(&desc->ptr[3], edesc->dma_link_tbl);
+			dma_sync_single_for_device(ctx->dev,
+						   edesc->dma_link_tbl,
+						   edesc->dma_len,
+						   DMA_BIDIRECTIONAL);
+		} else {
+			/* Only one segment now, so no link tbl needed */
+			to_talitos_ptr(&desc->ptr[3],
+				       sg_dma_address(req_ctx->psrc));
+		}
+	}
+
+	/* fifth DWORD empty */
+	desc->ptr[4] = zero_entry;
+
+	/* hash/HMAC out -or- hash context out */
+	if (req_ctx->last)
+		map_single_talitos_ptr(dev, &desc->ptr[5],
+				       crypto_ahash_digestsize(tfm),
+				       areq->result, 0, DMA_FROM_DEVICE);
+	else
+		map_single_talitos_ptr(dev, &desc->ptr[5],
+				       req_ctx->hw_context_size,
+				       req_ctx->hw_context, 0, DMA_FROM_DEVICE);
+
+	/* last DWORD empty */
+	desc->ptr[6] = zero_entry;
+
+	ret = talitos_submit(dev, desc, callback, areq);
+	if (ret != -EINPROGRESS) {
+		common_nonsnoop_hash_unmap(dev, edesc, areq);
+		kfree(edesc);
+	}
+	return ret;
+}
+
+static struct talitos_edesc *ahash_edesc_alloc(struct ahash_request *areq,
+					       unsigned int nbytes)
+{
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
+	struct talitos_ctx *ctx = crypto_ahash_ctx(tfm);
+	struct talitos_ahash_req_ctx *req_ctx = ahash_request_ctx(areq);
+
+	return talitos_edesc_alloc(ctx->dev, req_ctx->psrc, NULL, 1,
+				   nbytes, 0, 0, areq->base.flags);
+}
+
+static int ahash_init(struct ahash_request *areq)
+{
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
+	struct talitos_ahash_req_ctx *req_ctx = ahash_request_ctx(areq);
+
+	/* Initialize the context */
+	req_ctx->count = 0;
+	req_ctx->first = 1; /* first indicates h/w must init it's context */
+	req_ctx->hw_context_size =
+		(crypto_ahash_digestsize(tfm) <= SHA256_DIGEST_SIZE)
+			? TALITOS_MDEU_CONTEXT_SIZE_MD5_SHA1_SHA256
+			: TALITOS_MDEU_CONTEXT_SIZE_SHA384_SHA512;
+
+	return 0;
+}
+
+static int ahash_process_req(struct ahash_request *areq, unsigned int nbytes)
+{
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
+	struct talitos_ctx *ctx = crypto_ahash_ctx(tfm);
+	struct talitos_ahash_req_ctx *req_ctx = ahash_request_ctx(areq);
+	struct talitos_edesc *edesc;
+	unsigned int blocksize =
+			crypto_tfm_alg_blocksize(crypto_ahash_tfm(tfm));
+	unsigned int nbytes_to_hash;
+	unsigned int to_hash_later;
+	unsigned int index;
+	int chained;
+
+	index = req_ctx->count & (blocksize - 1);
+	req_ctx->count += nbytes;
+
+	if (!req_ctx->last && (index + nbytes) < blocksize) {
+		/* Buffer the partial block */
+		sg_copy_to_buffer(areq->src,
+				  sg_count(areq->src, nbytes, &chained),
+				  req_ctx->buf + index, nbytes);
+		return 0;
+	}
+
+	if (index) {
+		/* partial block from previous update; chain it in. */
+		sg_init_table(req_ctx->bufsl, (nbytes) ? 2 : 1);
+		sg_set_buf(req_ctx->bufsl, req_ctx->buf, index);
+		if (nbytes)
+			scatterwalk_sg_chain(req_ctx->bufsl, 2,
+					     areq->src);
+		req_ctx->psrc = req_ctx->bufsl;
+	} else {
+		req_ctx->psrc = areq->src;
+	}
+	nbytes_to_hash =  index + nbytes;
+	if (!req_ctx->last) {
+		to_hash_later = (nbytes_to_hash & (blocksize - 1));
+		if (to_hash_later) {
+			int nents;
+			/* Must copy to_hash_later bytes from the end
+			 * to bufnext (a partial block) for later.
+			 */
+			nents = sg_count(areq->src, nbytes, &chained);
+			sg_copy_end_to_buffer(areq->src, nents,
+					      req_ctx->bufnext,
+					      to_hash_later,
+					      nbytes - to_hash_later);
+
+			/* Adjust count for what will be hashed now */
+			nbytes_to_hash -= to_hash_later;
+		}
+		req_ctx->to_hash_later = to_hash_later;
+	}
+
+	/* allocate extended descriptor */
+	edesc = ahash_edesc_alloc(areq, nbytes_to_hash);
+	if (IS_ERR(edesc))
+		return PTR_ERR(edesc);
+
+	edesc->desc.hdr = ctx->desc_hdr_template;
+
+	/* On last one, request SEC to pad; otherwise continue */
+	if (req_ctx->last)
+		edesc->desc.hdr |= DESC_HDR_MODE0_MDEU_PAD;
+	else
+		edesc->desc.hdr |= DESC_HDR_MODE0_MDEU_CONT;
+
+	/* On first one, request SEC to INIT hash. */
+	if (req_ctx->first)
+		edesc->desc.hdr |= DESC_HDR_MODE0_MDEU_INIT;
+
+	/* When the tfm context has a keylen, it's an HMAC.
+	 * A first or last (ie. not middle) descriptor must request HMAC.
+	 */
+	if (ctx->keylen && (req_ctx->first || req_ctx->last))
+		edesc->desc.hdr |= DESC_HDR_MODE0_MDEU_HMAC;
+
+	return common_nonsnoop_hash(edesc, areq, nbytes_to_hash,
+				    ahash_done);
+}
+
+static int ahash_update(struct ahash_request *areq)
+{
+	struct talitos_ahash_req_ctx *req_ctx = ahash_request_ctx(areq);
+
+	req_ctx->last = 0;
+
+	return ahash_process_req(areq, areq->nbytes);
+}
+
+static int ahash_final(struct ahash_request *areq)
+{
+	struct talitos_ahash_req_ctx *req_ctx = ahash_request_ctx(areq);
+
+	req_ctx->last = 1;
+
+	return ahash_process_req(areq, 0);
+}
+
+static int ahash_finup(struct ahash_request *areq)
+{
+	struct talitos_ahash_req_ctx *req_ctx = ahash_request_ctx(areq);
+
+	req_ctx->last = 1;
+
+	return ahash_process_req(areq, areq->nbytes);
+}
+
+static int ahash_digest(struct ahash_request *areq)
+{
+	struct talitos_ahash_req_ctx *req_ctx = ahash_request_ctx(areq);
+
+	ahash_init(areq);
+	req_ctx->last = 1;
+
+	return ahash_process_req(areq, areq->nbytes);
+}
+
 struct talitos_alg_template {
 	u32 type;
 	union {
@@ -1694,7 +2064,113 @@ static struct talitos_alg_template driver_algs[] = {
 			             DESC_HDR_SEL0_DEU |
 		                     DESC_HDR_MODE0_DEU_CBC |
 		                     DESC_HDR_MODE0_DEU_3DES,
-	}
+	},
+	/* AHASH algorithms. */
+	{	.type = CRYPTO_ALG_TYPE_AHASH,
+		.alg.hash = {
+			.init = ahash_init,
+			.update = ahash_update,
+			.final = ahash_final,
+			.finup = ahash_finup,
+			.digest = ahash_digest,
+			.halg.digestsize = MD5_DIGEST_SIZE,
+			.halg.base = {
+				.cra_name = "md5",
+				.cra_driver_name = "md5-talitos",
+				.cra_blocksize = MD5_BLOCK_SIZE,
+				.cra_flags = CRYPTO_ALG_TYPE_AHASH |
+					     CRYPTO_ALG_ASYNC,
+				.cra_type = &crypto_ahash_type
+			}
+		},
+		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
+				     DESC_HDR_SEL0_MDEUA |
+				     DESC_HDR_MODE0_MDEU_MD5,
+	},
+	{	.type = CRYPTO_ALG_TYPE_AHASH,
+		.alg.hash = {
+			.init = ahash_init,
+			.update = ahash_update,
+			.final = ahash_final,
+			.finup = ahash_finup,
+			.digest = ahash_digest,
+			.halg.digestsize = SHA1_DIGEST_SIZE,
+			.halg.base = {
+				.cra_name = "sha1",
+				.cra_driver_name = "sha1-talitos",
+				.cra_blocksize = SHA1_BLOCK_SIZE,
+				.cra_flags = CRYPTO_ALG_TYPE_AHASH |
+					     CRYPTO_ALG_ASYNC,
+				.cra_type = &crypto_ahash_type
+			}
+		},
+		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
+				     DESC_HDR_SEL0_MDEUA |
+				     DESC_HDR_MODE0_MDEU_SHA1,
+	},
+	{	.type = CRYPTO_ALG_TYPE_AHASH,
+		.alg.hash = {
+			.init = ahash_init,
+			.update = ahash_update,
+			.final = ahash_final,
+			.finup = ahash_finup,
+			.digest = ahash_digest,
+			.halg.digestsize = SHA256_DIGEST_SIZE,
+			.halg.base = {
+				.cra_name = "sha256",
+				.cra_driver_name = "sha256-talitos",
+				.cra_blocksize = SHA256_BLOCK_SIZE,
+				.cra_flags = CRYPTO_ALG_TYPE_AHASH |
+					     CRYPTO_ALG_ASYNC,
+				.cra_type = &crypto_ahash_type
+			}
+		},
+		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
+				     DESC_HDR_SEL0_MDEUA |
+				     DESC_HDR_MODE0_MDEU_SHA256,
+	},
+	{	.type = CRYPTO_ALG_TYPE_AHASH,
+		.alg.hash = {
+			.init = ahash_init,
+			.update = ahash_update,
+			.final = ahash_final,
+			.finup = ahash_finup,
+			.digest = ahash_digest,
+			.halg.digestsize = SHA384_DIGEST_SIZE,
+			.halg.base = {
+				.cra_name = "sha384",
+				.cra_driver_name = "sha384-talitos",
+				.cra_blocksize = SHA384_BLOCK_SIZE,
+				.cra_flags = CRYPTO_ALG_TYPE_AHASH |
+					     CRYPTO_ALG_ASYNC,
+				.cra_type = &crypto_ahash_type
+			}
+		},
+		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
+				     DESC_HDR_SEL0_MDEUB |
+				     DESC_HDR_MODE0_MDEUB_SHA384,
+	},
+	{	.type = CRYPTO_ALG_TYPE_AHASH,
+		.alg.hash = {
+			.init = ahash_init,
+			.update = ahash_update,
+			.final = ahash_final,
+			.finup = ahash_finup,
+			.digest = ahash_digest,
+			.halg.digestsize = SHA512_DIGEST_SIZE,
+			.halg.base = {
+				.cra_name = "sha512",
+				.cra_driver_name = "sha512-talitos",
+				.cra_blocksize = SHA512_BLOCK_SIZE,
+				.cra_flags = CRYPTO_ALG_TYPE_AHASH |
+					     CRYPTO_ALG_ASYNC,
+				.cra_type = &crypto_ahash_type
+			}
+		},
+		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
+				     DESC_HDR_SEL0_MDEUB |
+				     DESC_HDR_MODE0_MDEUB_SHA512,
+	},
 };
 
 struct talitos_crypto_alg {
@@ -1709,8 +2185,13 @@ static int talitos_cra_init(struct crypto_tfm *tfm)
 	struct talitos_crypto_alg *talitos_alg;
 	struct talitos_ctx *ctx = crypto_tfm_ctx(tfm);
 
-	talitos_alg =  container_of(alg, struct talitos_crypto_alg,
-				    algt.alg.crypto);
+	if ((alg->cra_flags & CRYPTO_ALG_TYPE_MASK) == CRYPTO_ALG_TYPE_AHASH)
+		talitos_alg = container_of(__crypto_ahash_alg(alg),
+					   struct talitos_crypto_alg,
+					   algt.alg.hash);
+	else
+		talitos_alg = container_of(alg, struct talitos_crypto_alg,
+					   algt.alg.crypto);
 
 	/* update context with ptr to dev */
 	ctx->dev = talitos_alg->dev;
@@ -1718,12 +2199,34 @@ static int talitos_cra_init(struct crypto_tfm *tfm)
 	/* copy descriptor header template value */
 	ctx->desc_hdr_template = talitos_alg->algt.desc_hdr_template;
 
+	return 0;
+}
+
+static int talitos_cra_init_aead(struct crypto_tfm *tfm)
+{
+	struct talitos_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	talitos_cra_init(tfm);
+
 	/* random first IV */
 	get_random_bytes(ctx->iv, TALITOS_MAX_IV_LENGTH);
 
 	return 0;
 }
 
+static int talitos_cra_init_ahash(struct crypto_tfm *tfm)
+{
+	struct talitos_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	talitos_cra_init(tfm);
+
+	ctx->keylen = 0;
+	crypto_ahash_set_reqsize(__crypto_ahash_cast(tfm),
+				 sizeof(struct talitos_ahash_req_ctx));
+
+	return 0;
+}
+
 /*
  * given the alg's descriptor header template, determine whether descriptor
  * type and primary/secondary execution units required match the hw
@@ -1805,15 +2308,20 @@ static struct talitos_crypto_alg *talitos_alg_alloc(struct device *dev,
 
 	switch (t_alg->algt.type) {
 	case CRYPTO_ALG_TYPE_ABLKCIPHER:
+		alg = &t_alg->algt.alg.crypto;
+		alg->cra_init = talitos_cra_init;
+		break;
 	case CRYPTO_ALG_TYPE_AEAD:
 		alg = &t_alg->algt.alg.crypto;
+		alg->cra_init = talitos_cra_init_aead;
 		break;
 	case CRYPTO_ALG_TYPE_AHASH:
 		alg = &t_alg->algt.alg.hash.halg.base;
+		alg->cra_init = talitos_cra_init_ahash;
+		break;
 	}
 
 	alg->cra_module = THIS_MODULE;
-	alg->cra_init = talitos_cra_init;
 	alg->cra_priority = TALITOS_CRA_PRIORITY;
 	alg->cra_alignmask = 0;
 	alg->cra_ctxsize = sizeof(struct talitos_ctx);
diff --git a/drivers/crypto/talitos.h b/drivers/crypto/talitos.h
index ff5a145..05c57b7 100644
--- a/drivers/crypto/talitos.h
+++ b/drivers/crypto/talitos.h
@@ -130,6 +130,9 @@
 #define TALITOS_CRCUISR			0xf030 /* cyclic redundancy check unit*/
 #define TALITOS_CRCUISR_LO		0xf034
 
+#define TALITOS_MDEU_CONTEXT_SIZE_MD5_SHA1_SHA256	0x28
+#define TALITOS_MDEU_CONTEXT_SIZE_SHA384_SHA512		0x48
+
 /*
  * talitos descriptor header (hdr) bits
  */
@@ -157,12 +160,15 @@
 #define	DESC_HDR_MODE0_AESU_CBC		cpu_to_be32(0x00200000)
 #define	DESC_HDR_MODE0_DEU_CBC		cpu_to_be32(0x00400000)
 #define	DESC_HDR_MODE0_DEU_3DES		cpu_to_be32(0x00200000)
+#define	DESC_HDR_MODE0_MDEU_CONT	cpu_to_be32(0x08000000)
 #define	DESC_HDR_MODE0_MDEU_INIT	cpu_to_be32(0x01000000)
 #define	DESC_HDR_MODE0_MDEU_HMAC	cpu_to_be32(0x00800000)
 #define	DESC_HDR_MODE0_MDEU_PAD		cpu_to_be32(0x00400000)
 #define	DESC_HDR_MODE0_MDEU_MD5		cpu_to_be32(0x00200000)
 #define	DESC_HDR_MODE0_MDEU_SHA256	cpu_to_be32(0x00100000)
 #define	DESC_HDR_MODE0_MDEU_SHA1	cpu_to_be32(0x00000000)
+#define	DESC_HDR_MODE0_MDEUB_SHA384	cpu_to_be32(0x00000000)
+#define	DESC_HDR_MODE0_MDEUB_SHA512	cpu_to_be32(0x00200000)
 #define	DESC_HDR_MODE0_MDEU_MD5_HMAC	(DESC_HDR_MODE0_MDEU_MD5 | \
 					 DESC_HDR_MODE0_MDEU_HMAC)
 #define	DESC_HDR_MODE0_MDEU_SHA256_HMAC	(DESC_HDR_MODE0_MDEU_SHA256 | \
@@ -184,6 +190,8 @@
 #define	DESC_HDR_MODE1_MDEU_MD5		cpu_to_be32(0x00000200)
 #define	DESC_HDR_MODE1_MDEU_SHA256	cpu_to_be32(0x00000100)
 #define	DESC_HDR_MODE1_MDEU_SHA1	cpu_to_be32(0x00000000)
+#define	DESC_HDR_MODE1_MDEUB_SHA384	cpu_to_be32(0x00000000)
+#define	DESC_HDR_MODE1_MDEUB_SHA512	cpu_to_be32(0x00000200)
 #define	DESC_HDR_MODE1_MDEU_MD5_HMAC	(DESC_HDR_MODE1_MDEU_MD5 | \
 					 DESC_HDR_MODE1_MDEU_HMAC)
 #define	DESC_HDR_MODE1_MDEU_SHA256_HMAC	(DESC_HDR_MODE1_MDEU_SHA256 | \
-- 
1.6.0.4

