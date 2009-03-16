From: Lee Nipper <lee.nipper@gmail.com>
Subject: [PATCH 3/3] crypto: talitos - Add ahash algorithms (1st cut, digest only)
Date: Sun, 15 Mar 2009 20:21:50 -0500
Message-ID: <1237166510-7312-4-git-send-email-lee.nipper@gmail.com>
References: <1237166510-7312-1-git-send-email-lee.nipper@gmail.com>
 <1237166510-7312-2-git-send-email-lee.nipper@gmail.com>
 <1237166510-7312-3-git-send-email-lee.nipper@gmail.com>
Cc: kim.phillips@freescale.com, Lee Nipper <lee.nipper@gmail.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.27]:5001 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755684AbZCPBWG (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 15 Mar 2009 21:22:06 -0400
Received: by qw-out-2122.google.com with SMTP id 5so2399726qwi.37
        for <linux-crypto@vger.kernel.org>; Sun, 15 Mar 2009 18:22:03 -0700 (PDT)
In-Reply-To: <1237166510-7312-3-git-send-email-lee.nipper@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch adds simple ahash algorithms for
sha1, hmac(sha1),
sha256, hmac(sha256),
sha384, hmac(sha384),
sha512. hmac(sha512).
md5, hmac(md5).

The implementation provides digest only,
as the update and final functions are omitted.

Signed-off-by: Lee Nipper <lee.nipper@gmail.com>
---
 drivers/crypto/talitos.c |  464 ++++++++++++++++++++++++++++++++++++++++++++-
 drivers/crypto/talitos.h |    5 +
 2 files changed, 458 insertions(+), 11 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 3338668..0c29785 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -46,6 +46,7 @@
 #include <crypto/authenc.h>
 #include <crypto/skcipher.h>
 #include <crypto/scatterwalk.h>
+#include <crypto/internal/hash.h>
 
 #include "talitos.h"
 
@@ -681,6 +682,7 @@ static void talitos_unregister_rng(struct device *dev)
 #define TALITOS_MAX_IV_LENGTH		16 /* max of AES_BLOCK_SIZE, DES3_EDE_BLOCK_SIZE */
 
 #define MD5_DIGEST_SIZE   16
+#define MD5_BLOCK_SIZE    64
 
 struct talitos_ctx {
 	struct device *dev;
@@ -809,10 +811,14 @@ static void talitos_sg_unmap(struct device *dev,
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
@@ -1112,6 +1118,7 @@ static int sg_count(struct scatterlist *sg_list, int nbytes, int *chained)
 static struct talitos_edesc *talitos_edesc_alloc(struct device *dev,
 						 struct scatterlist *src,
 						 struct scatterlist *dst,
+						 u8 *hash_result,
 						 unsigned int cryptlen,
 						 unsigned int authsize,
 						 int icv_stashing,
@@ -1131,11 +1138,15 @@ static struct talitos_edesc *talitos_edesc_alloc(struct device *dev,
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
+			dst_nents = sg_count(dst, cryptlen + authsize, &dst_chained);
+			dst_nents = (dst_nents == 1) ? 0 : dst_nents;
+		}
 	}
 
 	/*
@@ -1176,7 +1187,7 @@ static struct talitos_edesc *aead_edesc_alloc(struct aead_request *areq,
 	struct crypto_aead *authenc = crypto_aead_reqtfm(areq);
 	struct talitos_ctx *ctx = crypto_aead_ctx(authenc);
 
-	return talitos_edesc_alloc(ctx->dev, areq->src, areq->dst,
+	return talitos_edesc_alloc(ctx->dev, areq->src, areq->dst, NULL,
 				   areq->cryptlen, ctx->authsize, icv_stashing,
 				   areq->base.flags);
 }
@@ -1433,8 +1444,8 @@ static struct talitos_edesc *ablkcipher_edesc_alloc(struct ablkcipher_request *a
 	struct crypto_ablkcipher *cipher = crypto_ablkcipher_reqtfm(areq);
 	struct talitos_ctx *ctx = crypto_ablkcipher_ctx(cipher);
 
-	return talitos_edesc_alloc(ctx->dev, areq->src, areq->dst, areq->nbytes,
-				   0, 0, areq->base.flags);
+	return talitos_edesc_alloc(ctx->dev, areq->src, areq->dst, NULL,
+				   areq->nbytes, 0, 0, areq->base.flags);
 }
 
 static int ablkcipher_encrypt(struct ablkcipher_request *areq)
@@ -1470,6 +1481,246 @@ static int ablkcipher_decrypt(struct ablkcipher_request *areq)
 	return common_nonsnoop(edesc, areq, NULL, ablkcipher_done);
 }
 
+static void common_nonsnoop_hash_unmap(struct device *dev,
+				  struct talitos_edesc *edesc,
+				  struct ahash_request *areq)
+{
+	unmap_single_talitos_ptr(dev, &edesc->desc.ptr[5], DMA_FROM_DEVICE);
+
+	if (edesc->desc.ptr[2].len)
+		unmap_single_talitos_ptr(dev, &edesc->desc.ptr[2],
+					 DMA_TO_DEVICE);
+
+	talitos_sg_unmap(dev, edesc, areq->src, NULL);
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
+
+	common_nonsnoop_hash_unmap(dev, edesc, areq);
+
+	kfree(edesc);
+
+	areq->base.complete(&areq->base, err);
+}
+
+static int common_nonsnoop_hash(struct talitos_edesc *edesc,
+				struct ahash_request *areq,
+				void (*callback) (struct device *dev,
+						  struct talitos_desc *desc,
+						  void *context, int error))
+{
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
+	struct talitos_ctx *ctx = crypto_ahash_ctx(tfm);
+	struct device *dev = ctx->dev;
+	struct talitos_desc *desc = &edesc->desc;
+	unsigned int length = areq->nbytes;
+	int sg_count, ret;
+
+	/* first DWORD empty */
+	desc->ptr[0].len = 0;
+	desc->ptr[0].ptr = 0;
+	desc->ptr[0].j_extent = 0;
+
+	/* second DWORD empty */
+	desc->ptr[1].len = 0;
+	desc->ptr[1].ptr = 0;
+	desc->ptr[1].j_extent = 0;
+
+	/* cipher key */
+	if (ctx->keylen)
+		map_single_talitos_ptr(dev, &desc->ptr[2], ctx->keylen,
+				       (char *)&ctx->key, 0, DMA_TO_DEVICE);
+	else {
+		desc->ptr[2].len = 0;
+		desc->ptr[2].ptr = 0;
+		desc->ptr[2].j_extent = 0;
+	}
+
+	/*
+	 * data in
+	 */
+	desc->ptr[3].len = cpu_to_be16(length);
+	desc->ptr[3].j_extent = 0;
+
+	sg_count = talitos_map_sg(dev, areq->src,
+				  edesc->src_nents ? : 1,
+				  DMA_TO_DEVICE,
+				  edesc->src_is_chained);
+
+	if (sg_count == 1) {
+		desc->ptr[3].ptr = cpu_to_be32(sg_dma_address(areq->src));
+	} else {
+		sg_count = sg_to_link_tbl(areq->src, sg_count, length,
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
+	/* fifth DWORD empty */
+	desc->ptr[4].len = 0;
+	desc->ptr[4].ptr = 0;
+	desc->ptr[4].j_extent = 0;
+
+	/* hash/HMAC out */
+	map_single_talitos_ptr(dev, &desc->ptr[5], crypto_ahash_digestsize(tfm),
+			       areq->result, 0, DMA_FROM_DEVICE);
+
+	/* last DWORD empty */
+	desc->ptr[6].len = 0;
+	desc->ptr[6].ptr = 0;
+	desc->ptr[6].j_extent = 0;
+
+	ret = talitos_submit(dev, desc, callback, areq);
+	if (ret != -EINPROGRESS) {
+		common_nonsnoop_hash_unmap(dev, edesc, areq);
+		kfree(edesc);
+	}
+	return ret;
+}
+
+static struct talitos_edesc *ahash_edesc_alloc(struct ahash_request *areq)
+{
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
+	struct talitos_ctx *ctx = crypto_ahash_ctx(tfm);
+
+	return talitos_edesc_alloc(ctx->dev, areq->src, NULL, areq->result,
+				   areq->nbytes, 0, 0, areq->base.flags);
+}
+
+static int ahash_init(struct ahash_request *req)
+{
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct talitos_ctx *ctx = crypto_ahash_ctx(tfm);
+
+	/* Initialize the context */
+	ctx->keylen = 0;
+
+	return 0;
+}
+
+static int ahash_digest(struct ahash_request *areq)
+{
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
+	struct talitos_ctx *ctx = crypto_ahash_ctx(tfm);
+	struct talitos_edesc *edesc;
+
+
+	/* allocate extended descriptor */
+	edesc = ahash_edesc_alloc(areq);
+	if (IS_ERR(edesc))
+		return PTR_ERR(edesc);
+
+	/* We are using only one descriptor for digest op, so always pad */
+	edesc->desc.hdr = ctx->desc_hdr_template | DESC_HDR_MODE0_MDEU_PAD;
+
+	/* set hmac */
+	if (ctx->keylen)
+		edesc->desc.hdr |= DESC_HDR_MODE0_MDEU_HMAC;
+
+	return common_nonsnoop_hash(edesc, areq, ahash_done);
+}
+
+struct keyhash_result {
+	struct completion completion;
+	int err;
+};
+
+static void keyhash_complete(struct crypto_async_request *req, int err)
+{
+	struct keyhash_result *res = req->data;
+
+	if (err == -EINPROGRESS)
+		return;
+
+	res->err = err;
+	complete(&res->completion);
+}
+
+static int ahash_setkey(struct crypto_ahash *tfm, const u8 *key,
+			unsigned int keylen)
+{
+	struct talitos_ctx *ctx = crypto_tfm_ctx(crypto_ahash_tfm(tfm));
+	unsigned int blocksize = crypto_tfm_alg_blocksize(crypto_ahash_tfm(tfm));
+	unsigned int digestsize = crypto_ahash_digestsize(tfm);
+	unsigned int keysize = keylen;
+	u8 hash[64];
+
+	/* The code below for keylen > blocksize was an attempt
+	 * to do the correct thing for large hash keys.  However, it still
+	 * fails to help an HMAC work correctly with the test module which
+	 * checks a key larger than the block size. I leave it here
+	 * in case it is close to doing the right thing.
+	 */
+	if (keylen > blocksize) {
+		/* Must hash the key in separate operation */
+		struct scatterlist sg[1];
+		struct ahash_request *req;
+		struct keyhash_result hresult;
+		int ret;
+
+		init_completion(&hresult.completion);
+
+		req = ahash_request_alloc(tfm, GFP_KERNEL);
+		if (!req)
+			return -ENOMEM;
+		/* Keep keylen 0 during hash of the long key */
+		ctx->keylen = 0;
+		ahash_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
+				   keyhash_complete, &hresult);
+
+		sg_init_one(&sg[0], key, keylen);
+
+		ahash_request_set_crypt(req, sg, hash, keylen);
+		ret = crypto_ahash_digest(req);
+		switch (ret) {
+		case 0:
+			break;
+		case -EINPROGRESS:
+		case -EBUSY:
+			ret = wait_for_completion_interruptible(
+				&hresult.completion);
+			if (!ret)
+				ret = hresult.err;
+			break;
+		default:
+			break;
+		}
+		ahash_request_free(req);
+		if (ret)
+			goto badkey;
+		keysize = digestsize;
+		memcpy(ctx->key, hash, digestsize);
+	} else {
+		memcpy(ctx->key, key, keysize);
+	}
+
+	ctx->keylen = keysize;
+
+	return 0;
+
+badkey:
+	crypto_ahash_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
+	return -EINVAL;
+}
+
 struct talitos_alg_template {
 	struct crypto_alg alg;
 	__be32 desc_hdr_template;
@@ -1681,6 +1932,197 @@ static struct talitos_alg_template driver_algs[] = {
 			             DESC_HDR_SEL0_DEU |
 		                     DESC_HDR_MODE0_DEU_CBC |
 		                     DESC_HDR_MODE0_DEU_3DES,
+	},
+	/* AHASH algorithms. */
+	{
+		.alg = {
+			.cra_name = "sha1",
+			.cra_driver_name = "sha1-talitos",
+			.cra_blocksize = SHA1_BLOCK_SIZE,
+			.cra_flags = CRYPTO_ALG_TYPE_AHASH | CRYPTO_ALG_ASYNC,
+			.cra_type = &crypto_ahash_type,
+			.cra_ahash = {
+				.init = ahash_init,
+				.digest = ahash_digest,
+				.setkey = ahash_setkey,
+				.digestsize = SHA1_DIGEST_SIZE,
+			}
+		},
+		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
+			             DESC_HDR_SEL0_MDEUA |
+		                     DESC_HDR_MODE0_MDEU_INIT |
+		                     DESC_HDR_MODE0_MDEU_SHA1,
+	},
+	{
+		.alg = {
+			.cra_name = "sha256",
+			.cra_driver_name = "sha256-talitos",
+			.cra_blocksize = SHA256_BLOCK_SIZE,
+			.cra_flags = CRYPTO_ALG_TYPE_AHASH | CRYPTO_ALG_ASYNC,
+			.cra_type = &crypto_ahash_type,
+			.cra_ahash = {
+				.init = ahash_init,
+				.digest = ahash_digest,
+				.setkey = ahash_setkey,
+				.digestsize = SHA256_DIGEST_SIZE
+			}
+		},
+		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
+			             DESC_HDR_SEL0_MDEUA |
+		                     DESC_HDR_MODE0_MDEU_INIT |
+		                     DESC_HDR_MODE0_MDEU_SHA256,
+	},
+	{
+		.alg = {
+			.cra_name = "sha384",
+			.cra_driver_name = "sha384-talitos",
+			.cra_blocksize = SHA384_BLOCK_SIZE,
+			.cra_flags = CRYPTO_ALG_TYPE_AHASH | CRYPTO_ALG_ASYNC,
+			.cra_type = &crypto_ahash_type,
+			.cra_ahash = {
+				.init = ahash_init,
+				.digest = ahash_digest,
+				.setkey = ahash_setkey,
+				.digestsize = SHA384_DIGEST_SIZE,
+			}
+		},
+		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
+			             DESC_HDR_SEL0_MDEUB |
+		                     DESC_HDR_MODE0_MDEU_INIT |
+		                     DESC_HDR_MODE0_MDEU_SHA384,
+	},
+	{
+		.alg = {
+			.cra_name = "sha512",
+			.cra_driver_name = "sha512-talitos",
+			.cra_blocksize = SHA512_BLOCK_SIZE,
+			.cra_flags = CRYPTO_ALG_TYPE_AHASH | CRYPTO_ALG_ASYNC,
+			.cra_type = &crypto_ahash_type,
+			.cra_ahash = {
+				.init = ahash_init,
+				.digest = ahash_digest,
+				.setkey = ahash_setkey,
+				.digestsize = SHA512_DIGEST_SIZE
+			}
+		},
+		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
+			             DESC_HDR_SEL0_MDEUB |
+		                     DESC_HDR_MODE0_MDEU_INIT |
+		                     DESC_HDR_MODE0_MDEU_SHA512,
+	},
+	{
+		.alg = {
+			.cra_name = "hmac(sha1)",
+			.cra_driver_name = "hmac-sha1-talitos",
+			.cra_blocksize = SHA1_BLOCK_SIZE,
+			.cra_flags = CRYPTO_ALG_TYPE_AHASH | CRYPTO_ALG_ASYNC,
+			.cra_type = &crypto_ahash_type,
+			.cra_ahash = {
+				.init = ahash_init,
+				.digest = ahash_digest,
+				.setkey = ahash_setkey,
+				.digestsize = SHA1_DIGEST_SIZE,
+			}
+		},
+		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
+			             DESC_HDR_SEL0_MDEUA |
+		                     DESC_HDR_MODE0_MDEU_INIT |
+		                     DESC_HDR_MODE0_MDEU_SHA1,
+	},
+	{
+		.alg = {
+			.cra_name = "hmac(sha256)",
+			.cra_driver_name = "hmac-sha256-talitos",
+			.cra_blocksize = SHA256_BLOCK_SIZE,
+			.cra_flags = CRYPTO_ALG_TYPE_AHASH | CRYPTO_ALG_ASYNC,
+			.cra_type = &crypto_ahash_type,
+			.cra_ahash = {
+				.init = ahash_init,
+				.digest = ahash_digest,
+				.setkey = ahash_setkey,
+				.digestsize = SHA256_DIGEST_SIZE
+			}
+		},
+		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
+			             DESC_HDR_SEL0_MDEUA |
+		                     DESC_HDR_MODE0_MDEU_INIT |
+		                     DESC_HDR_MODE0_MDEU_SHA256,
+	},
+	{
+		.alg = {
+			.cra_name = "hmac(sha384)",
+			.cra_driver_name = "hmac-sha384-talitos",
+			.cra_blocksize = SHA384_BLOCK_SIZE,
+			.cra_flags = CRYPTO_ALG_TYPE_AHASH | CRYPTO_ALG_ASYNC,
+			.cra_type = &crypto_ahash_type,
+			.cra_ahash = {
+				.init = ahash_init,
+				.digest = ahash_digest,
+				.setkey = ahash_setkey,
+				.digestsize = SHA384_DIGEST_SIZE,
+			}
+		},
+		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
+			             DESC_HDR_SEL0_MDEUB |
+		                     DESC_HDR_MODE0_MDEU_INIT |
+		                     DESC_HDR_MODE0_MDEU_SHA384,
+	},
+	{
+		.alg = {
+			.cra_name = "hmac(sha512)",
+			.cra_driver_name = "hmac-sha512-talitos",
+			.cra_blocksize = SHA512_BLOCK_SIZE,
+			.cra_flags = CRYPTO_ALG_TYPE_AHASH | CRYPTO_ALG_ASYNC,
+			.cra_type = &crypto_ahash_type,
+			.cra_ahash = {
+				.init = ahash_init,
+				.digest = ahash_digest,
+				.setkey = ahash_setkey,
+				.digestsize = SHA512_DIGEST_SIZE
+			}
+		},
+		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
+			             DESC_HDR_SEL0_MDEUB |
+		                     DESC_HDR_MODE0_MDEU_INIT |
+		                     DESC_HDR_MODE0_MDEU_SHA512,
+	},
+	{
+		.alg = {
+			.cra_name = "md5",
+			.cra_driver_name = "md5-talitos",
+			.cra_blocksize = MD5_BLOCK_SIZE,
+			.cra_flags = CRYPTO_ALG_TYPE_AHASH | CRYPTO_ALG_ASYNC,
+			.cra_type = &crypto_ahash_type,
+			.cra_ahash = {
+				.init = ahash_init,
+				.digest = ahash_digest,
+				.setkey = ahash_setkey,
+				.digestsize = MD5_DIGEST_SIZE,
+			}
+		},
+		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
+			             DESC_HDR_SEL0_MDEUA |
+		                     DESC_HDR_MODE0_MDEU_INIT |
+		                     DESC_HDR_MODE0_MDEU_MD5,
+	},
+	{
+		.alg = {
+			.cra_name = "hmac(md5)",
+			.cra_driver_name = "hmac-md5-talitos",
+			.cra_blocksize = MD5_BLOCK_SIZE,
+			.cra_flags = CRYPTO_ALG_TYPE_AHASH | CRYPTO_ALG_ASYNC,
+			.cra_type = &crypto_ahash_type,
+			.cra_ahash = {
+				.init = ahash_init,
+				.digest = ahash_digest,
+				.setkey = ahash_setkey,
+				.digestsize = MD5_DIGEST_SIZE,
+			}
+		},
+		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
+			             DESC_HDR_SEL0_MDEUA |
+		                     DESC_HDR_MODE0_MDEU_INIT |
+		                     DESC_HDR_MODE0_MDEU_MD5,
 	}
 };
 
diff --git a/drivers/crypto/talitos.h b/drivers/crypto/talitos.h
index 575981f..85deb0a 100644
--- a/drivers/crypto/talitos.h
+++ b/drivers/crypto/talitos.h
@@ -162,6 +162,8 @@
 #define	DESC_HDR_MODE0_MDEU_MD5		cpu_to_be32(0x00200000)
 #define	DESC_HDR_MODE0_MDEU_SHA256	cpu_to_be32(0x00100000)
 #define	DESC_HDR_MODE0_MDEU_SHA1	cpu_to_be32(0x00000000)
+#define	DESC_HDR_MODE0_MDEU_SHA384	cpu_to_be32(0x00000000) /*MDEUB*/
+#define	DESC_HDR_MODE0_MDEU_SHA512	cpu_to_be32(0x00200000) /*MDEUB*/
 #define	DESC_HDR_MODE0_MDEU_MD5_HMAC	(DESC_HDR_MODE0_MDEU_MD5 | \
 					 DESC_HDR_MODE0_MDEU_HMAC)
 #define	DESC_HDR_MODE0_MDEU_SHA256_HMAC	(DESC_HDR_MODE0_MDEU_SHA256 | \
@@ -183,6 +185,9 @@
 #define	DESC_HDR_MODE1_MDEU_MD5		cpu_to_be32(0x00000200)
 #define	DESC_HDR_MODE1_MDEU_SHA256	cpu_to_be32(0x00000100)
 #define	DESC_HDR_MODE1_MDEU_SHA1	cpu_to_be32(0x00000000)
+#define	DESC_HDR_MODE1_MDEU_SHA384	cpu_to_be32(0x00000000) /*MDEUB*/
+#define	DESC_HDR_MODE1_MDEU_SHA512	cpu_to_be32(0x00000200) /*MDEUB*/
+
 #define	DESC_HDR_MODE1_MDEU_MD5_HMAC	(DESC_HDR_MODE1_MDEU_MD5 | \
 					 DESC_HDR_MODE1_MDEU_HMAC)
 #define	DESC_HDR_MODE1_MDEU_SHA256_HMAC	(DESC_HDR_MODE1_MDEU_SHA256 | \
-- 
1.5.6.3

