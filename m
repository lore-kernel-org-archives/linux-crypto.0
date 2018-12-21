Return-Path: <SRS0=edWn=O6=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from inva020.nxp.com ([92.121.34.13]:51726 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387770AbeLUP7u (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Dec 2018 10:59:50 -0500
From: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        linux-crypto@vger.kernel.org, linux-imx@nxp.com,
        Iuliana Prodan <Iuliana.Prodan@nxp.com>
Subject: [PATCH 3/3] crypto: caam - add support for xcbc(aes)
Date: Fri, 21 Dec 2018 17:59:10 +0200
Message-Id: <20181221155910.6235-4-horia.geanta@nxp.com>
In-Reply-To: <20181221155910.6235-1-horia.geanta@nxp.com>
References: <20181221155910.6235-1-horia.geanta@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Iuliana Prodan <Iuliana.Prodan@nxp.com>

Add xcbc(aes) offloading support.

Due to xcbc algorithm design and HW implementation in CAAM,
driver must still have some bytes to send to the crypto engine when
ahash_final() is called - such that HW correctly uses either K2 or K3
for the last block.

Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>
Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
---
 drivers/crypto/caam/caamhash.c      | 189 +++++++++++++++++++++++++++++++++---
 drivers/crypto/caam/caamhash_desc.c |  58 ++++++++++-
 drivers/crypto/caam/caamhash_desc.h |   2 +
 3 files changed, 232 insertions(+), 17 deletions(-)

diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index 179981f44807..24e73bcda602 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -98,13 +98,14 @@ struct caam_hash_ctx {
 	u32 sh_desc_update_first[DESC_HASH_MAX_USED_LEN] ____cacheline_aligned;
 	u32 sh_desc_fin[DESC_HASH_MAX_USED_LEN] ____cacheline_aligned;
 	u32 sh_desc_digest[DESC_HASH_MAX_USED_LEN] ____cacheline_aligned;
+	u8 key[CAAM_MAX_HASH_KEY_SIZE] ____cacheline_aligned;
 	dma_addr_t sh_desc_update_dma ____cacheline_aligned;
 	dma_addr_t sh_desc_update_first_dma;
 	dma_addr_t sh_desc_fin_dma;
 	dma_addr_t sh_desc_digest_dma;
+	dma_addr_t key_dma;
 	enum dma_data_direction dir;
 	struct device *jrdev;
-	u8 key[CAAM_MAX_HASH_KEY_SIZE];
 	int ctx_len;
 	struct alginfo adata;
 };
@@ -158,6 +159,12 @@ static inline int *alt_buflen(struct caam_hash_state *state)
 	return state->current_buf ? &state->buflen_0 : &state->buflen_1;
 }
 
+static inline bool is_xcbc_aes(u32 algtype)
+{
+	return (algtype & (OP_ALG_ALGSEL_MASK | OP_ALG_AAI_MASK)) ==
+	       (OP_ALG_ALGSEL_AES | OP_ALG_AAI_XCBC_MAC);
+}
+
 /* Common job descriptor seq in/out ptr routines */
 
 /* Map state->caam_ctx, and append seq_out_ptr command that points to it */
@@ -292,6 +299,62 @@ static int ahash_set_sh_desc(struct crypto_ahash *ahash)
 	return 0;
 }
 
+static int axcbc_set_sh_desc(struct crypto_ahash *ahash)
+{
+	struct caam_hash_ctx *ctx = crypto_ahash_ctx(ahash);
+	int digestsize = crypto_ahash_digestsize(ahash);
+	struct device *jrdev = ctx->jrdev;
+	u32 *desc;
+
+	/* key is loaded from memory for UPDATE and FINALIZE states */
+	ctx->adata.key_dma = ctx->key_dma;
+
+	/* shared descriptor for ahash_update */
+	desc = ctx->sh_desc_update;
+	cnstr_shdsc_axcbc(desc, &ctx->adata, OP_ALG_AS_UPDATE, ctx->ctx_len,
+			  ctx->ctx_len, 0);
+	dma_sync_single_for_device(jrdev, ctx->sh_desc_update_dma,
+				   desc_bytes(desc), ctx->dir);
+	print_hex_dump_debug("axcbc update shdesc@" __stringify(__LINE__)" : ",
+			     DUMP_PREFIX_ADDRESS, 16, 4, desc, desc_bytes(desc),
+			     1);
+
+	/* shared descriptor for ahash_{final,finup} */
+	desc = ctx->sh_desc_fin;
+	cnstr_shdsc_axcbc(desc, &ctx->adata, OP_ALG_AS_FINALIZE, digestsize,
+			  ctx->ctx_len, 0);
+	dma_sync_single_for_device(jrdev, ctx->sh_desc_fin_dma,
+				   desc_bytes(desc), ctx->dir);
+	print_hex_dump_debug("axcbc finup shdesc@" __stringify(__LINE__)" : ",
+			     DUMP_PREFIX_ADDRESS, 16, 4, desc, desc_bytes(desc),
+			     1);
+
+	/* key is immediate data for INIT and INITFINAL states */
+	ctx->adata.key_virt = ctx->key;
+
+	/* shared descriptor for first invocation of ahash_update */
+	desc = ctx->sh_desc_update_first;
+	cnstr_shdsc_axcbc(desc, &ctx->adata, OP_ALG_AS_INIT, ctx->ctx_len,
+			  ctx->ctx_len, ctx->key_dma);
+	dma_sync_single_for_device(jrdev, ctx->sh_desc_update_first_dma,
+				   desc_bytes(desc), ctx->dir);
+	print_hex_dump_debug("axcbc update first shdesc@" __stringify(__LINE__)" : ",
+			     DUMP_PREFIX_ADDRESS, 16, 4, desc, desc_bytes(desc),
+			     1);
+
+	/* shared descriptor for ahash_digest */
+	desc = ctx->sh_desc_digest;
+	cnstr_shdsc_axcbc(desc, &ctx->adata, OP_ALG_AS_INITFINAL, digestsize,
+			  ctx->ctx_len, 0);
+	dma_sync_single_for_device(jrdev, ctx->sh_desc_digest_dma,
+				   desc_bytes(desc), ctx->dir);
+	print_hex_dump_debug("axcbc digest shdesc@" __stringify(__LINE__)" : ",
+			     DUMP_PREFIX_ADDRESS, 16, 4, desc, desc_bytes(desc),
+			     1);
+
+	return 0;
+}
+
 /* Digest hash size if it is too large */
 static int hash_digest_key(struct caam_hash_ctx *ctx, const u8 *key_in,
 			   u32 *keylen, u8 *key_out, u32 digestsize)
@@ -424,6 +487,21 @@ static int ahash_setkey(struct crypto_ahash *ahash,
 	return -EINVAL;
 }
 
+static int axcbc_setkey(struct crypto_ahash *ahash, const u8 *key,
+			unsigned int keylen)
+{
+	struct caam_hash_ctx *ctx = crypto_ahash_ctx(ahash);
+	struct device *jrdev = ctx->jrdev;
+
+	memcpy(ctx->key, key, keylen);
+	dma_sync_single_for_device(jrdev, ctx->key_dma, keylen, DMA_TO_DEVICE);
+	ctx->adata.keylen = keylen;
+
+	print_hex_dump_debug("axcbc ctx.key@" __stringify(__LINE__)" : ",
+			     DUMP_PREFIX_ADDRESS, 16, 4, ctx->key, keylen, 1);
+
+	return axcbc_set_sh_desc(ahash);
+}
 /*
  * ahash_edesc - s/w-extended ahash descriptor
  * @dst_dma: physical mapped address of req->result
@@ -688,6 +766,7 @@ static int ahash_update_ctx(struct ahash_request *req)
 	u8 *buf = current_buf(state);
 	int *buflen = current_buflen(state);
 	u8 *next_buf = alt_buf(state);
+	int blocksize = crypto_ahash_blocksize(ahash);
 	int *next_buflen = alt_buflen(state), last_buflen;
 	int in_len = *buflen + req->nbytes, to_hash;
 	u32 *desc;
@@ -696,9 +775,19 @@ static int ahash_update_ctx(struct ahash_request *req)
 	int ret = 0;
 
 	last_buflen = *next_buflen;
-	*next_buflen = in_len & (crypto_tfm_alg_blocksize(&ahash->base) - 1);
+	*next_buflen = in_len & (blocksize - 1);
 	to_hash = in_len - *next_buflen;
 
+	/*
+	 * For XCBC, if to_hash is multiple of block size,
+	 * keep last block in internal buffer
+	 */
+	if (is_xcbc_aes(ctx->adata.algtype) && to_hash >= blocksize &&
+	    (*next_buflen == 0)) {
+		*next_buflen = blocksize;
+		to_hash -= blocksize;
+	}
+
 	if (to_hash) {
 		src_nents = sg_nents_for_len(req->src,
 					     req->nbytes - (*next_buflen));
@@ -1119,6 +1208,7 @@ static int ahash_update_no_ctx(struct ahash_request *req)
 		       GFP_KERNEL : GFP_ATOMIC;
 	u8 *buf = current_buf(state);
 	int *buflen = current_buflen(state);
+	int blocksize = crypto_ahash_blocksize(ahash);
 	u8 *next_buf = alt_buf(state);
 	int *next_buflen = alt_buflen(state);
 	int in_len = *buflen + req->nbytes, to_hash;
@@ -1127,9 +1217,19 @@ static int ahash_update_no_ctx(struct ahash_request *req)
 	u32 *desc;
 	int ret = 0;
 
-	*next_buflen = in_len & (crypto_tfm_alg_blocksize(&ahash->base) - 1);
+	*next_buflen = in_len & (blocksize - 1);
 	to_hash = in_len - *next_buflen;
 
+	/*
+	 * For XCBC, if to_hash is multiple of block size,
+	 * keep last block in internal buffer
+	 */
+	if (is_xcbc_aes(ctx->adata.algtype) && to_hash >= blocksize &&
+	    (*next_buflen == 0)) {
+		*next_buflen = blocksize;
+		to_hash -= blocksize;
+	}
+
 	if (to_hash) {
 		src_nents = sg_nents_for_len(req->src,
 					     req->nbytes - *next_buflen);
@@ -1335,15 +1435,25 @@ static int ahash_update_first(struct ahash_request *req)
 	u8 *next_buf = alt_buf(state);
 	int *next_buflen = alt_buflen(state);
 	int to_hash;
+	int blocksize = crypto_ahash_blocksize(ahash);
 	u32 *desc;
 	int src_nents, mapped_nents;
 	struct ahash_edesc *edesc;
 	int ret = 0;
 
-	*next_buflen = req->nbytes & (crypto_tfm_alg_blocksize(&ahash->base) -
-				      1);
+	*next_buflen = req->nbytes & (blocksize - 1);
 	to_hash = req->nbytes - *next_buflen;
 
+	/*
+	 * For XCBC, if to_hash is multiple of block size,
+	 * keep last block in internal buffer
+	 */
+	if (is_xcbc_aes(ctx->adata.algtype) && to_hash >= blocksize &&
+	    (*next_buflen == 0)) {
+		*next_buflen = blocksize;
+		to_hash -= blocksize;
+	}
+
 	if (to_hash) {
 		src_nents = sg_nents_for_len(req->src,
 					     req->nbytes - *next_buflen);
@@ -1651,6 +1761,25 @@ static struct caam_hash_template driver_hash[] = {
 			},
 		},
 		.alg_type = OP_ALG_ALGSEL_MD5,
+	}, {
+		.hmac_name = "xcbc(aes)",
+		.hmac_driver_name = "xcbc-aes-caam",
+		.blocksize = AES_BLOCK_SIZE,
+		.template_ahash = {
+			.init = ahash_init,
+			.update = ahash_update,
+			.final = ahash_final,
+			.finup = ahash_finup,
+			.digest = ahash_digest,
+			.export = ahash_export,
+			.import = ahash_import,
+			.setkey = axcbc_setkey,
+			.halg = {
+				.digestsize = AES_BLOCK_SIZE,
+				.statesize = sizeof(struct caam_export_state),
+			},
+		 },
+		.alg_type = OP_ALG_ALGSEL_AES | OP_ALG_AAI_XCBC_MAC,
 	},
 };
 
@@ -1692,7 +1821,28 @@ static int caam_hash_cra_init(struct crypto_tfm *tfm)
 	}
 
 	priv = dev_get_drvdata(ctx->jrdev->parent);
-	ctx->dir = priv->era >= 6 ? DMA_BIDIRECTIONAL : DMA_TO_DEVICE;
+
+	if (is_xcbc_aes(caam_hash->alg_type)) {
+		ctx->dir = DMA_TO_DEVICE;
+		ctx->adata.algtype = OP_TYPE_CLASS1_ALG | caam_hash->alg_type;
+		ctx->ctx_len = 48;
+
+		ctx->key_dma = dma_map_single_attrs(ctx->jrdev, ctx->key,
+						    ARRAY_SIZE(ctx->key),
+						    DMA_BIDIRECTIONAL,
+						    DMA_ATTR_SKIP_CPU_SYNC);
+		if (dma_mapping_error(ctx->jrdev, ctx->key_dma)) {
+			dev_err(ctx->jrdev, "unable to map key\n");
+			caam_jr_free(ctx->jrdev);
+			return -ENOMEM;
+		}
+	} else {
+		ctx->dir = priv->era >= 6 ? DMA_BIDIRECTIONAL : DMA_TO_DEVICE;
+		ctx->adata.algtype = OP_TYPE_CLASS2_ALG | caam_hash->alg_type;
+		ctx->ctx_len = runninglen[(ctx->adata.algtype &
+					   OP_ALG_ALGSEL_SUBMASK) >>
+					  OP_ALG_ALGSEL_SHIFT];
+	}
 
 	dma_addr = dma_map_single_attrs(ctx->jrdev, ctx->sh_desc_update,
 					offsetof(struct caam_hash_ctx,
@@ -1700,6 +1850,13 @@ static int caam_hash_cra_init(struct crypto_tfm *tfm)
 					ctx->dir, DMA_ATTR_SKIP_CPU_SYNC);
 	if (dma_mapping_error(ctx->jrdev, dma_addr)) {
 		dev_err(ctx->jrdev, "unable to map shared descriptors\n");
+
+		if (is_xcbc_aes(caam_hash->alg_type))
+			dma_unmap_single_attrs(ctx->jrdev, ctx->key_dma,
+					       ARRAY_SIZE(ctx->key),
+					       DMA_BIDIRECTIONAL,
+					       DMA_ATTR_SKIP_CPU_SYNC);
+
 		caam_jr_free(ctx->jrdev);
 		return -ENOMEM;
 	}
@@ -1713,13 +1870,6 @@ static int caam_hash_cra_init(struct crypto_tfm *tfm)
 	ctx->sh_desc_digest_dma = dma_addr + offsetof(struct caam_hash_ctx,
 						      sh_desc_digest);
 
-	/* copy descriptor header template value */
-	ctx->adata.algtype = OP_TYPE_CLASS2_ALG | caam_hash->alg_type;
-
-	ctx->ctx_len = runninglen[(ctx->adata.algtype &
-				   OP_ALG_ALGSEL_SUBMASK) >>
-				  OP_ALG_ALGSEL_SHIFT];
-
 	crypto_ahash_set_reqsize(__crypto_ahash_cast(tfm),
 				 sizeof(struct caam_hash_state));
 
@@ -1735,9 +1885,12 @@ static void caam_hash_cra_exit(struct crypto_tfm *tfm)
 	struct caam_hash_ctx *ctx = crypto_tfm_ctx(tfm);
 
 	dma_unmap_single_attrs(ctx->jrdev, ctx->sh_desc_update_dma,
-			       offsetof(struct caam_hash_ctx,
-					sh_desc_update_dma),
+			       offsetof(struct caam_hash_ctx, key),
 			       ctx->dir, DMA_ATTR_SKIP_CPU_SYNC);
+	if (is_xcbc_aes(ctx->adata.algtype))
+		dma_unmap_single_attrs(ctx->jrdev, ctx->key_dma,
+				       ARRAY_SIZE(ctx->key), DMA_BIDIRECTIONAL,
+				       DMA_ATTR_SKIP_CPU_SYNC);
 	caam_jr_free(ctx->jrdev);
 }
 
@@ -1868,7 +2021,8 @@ static int __init caam_algapi_hash_init(void)
 		struct caam_hash_template *alg = driver_hash + i;
 
 		/* If MD size is not supported by device, skip registration */
-		if (alg->template_ahash.halg.digestsize > md_limit)
+		if (is_mdha(alg->alg_type) &&
+		    alg->template_ahash.halg.digestsize > md_limit)
 			continue;
 
 		/* register hmac version */
@@ -1889,6 +2043,9 @@ static int __init caam_algapi_hash_init(void)
 		} else
 			list_add_tail(&t_alg->entry, &hash_list);
 
+		if ((alg->alg_type & OP_ALG_ALGSEL_MASK) == OP_ALG_ALGSEL_AES)
+			continue;
+
 		/* register unkeyed version */
 		t_alg = caam_hash_alloc(alg, false);
 		if (IS_ERR(t_alg)) {
diff --git a/drivers/crypto/caam/caamhash_desc.c b/drivers/crypto/caam/caamhash_desc.c
index a12f7959a2c3..053d3a15ef3c 100644
--- a/drivers/crypto/caam/caamhash_desc.c
+++ b/drivers/crypto/caam/caamhash_desc.c
@@ -2,7 +2,7 @@
 /*
  * Shared descriptors for ahash algorithms
  *
- * Copyright 2017 NXP
+ * Copyright 2017-2018 NXP
  */
 
 #include "compat.h"
@@ -75,6 +75,62 @@ void cnstr_shdsc_ahash(u32 * const desc, struct alginfo *adata, u32 state,
 }
 EXPORT_SYMBOL(cnstr_shdsc_ahash);
 
+/**
+ * cnstr_shdsc_axcbc - axcbc shared descriptor
+ * @desc: pointer to buffer used for descriptor construction
+ * @adata: pointer to authentication transform definitions.
+ * @state: algorithm state OP_ALG_AS_{INIT, FINALIZE, INITFINALIZE, UPDATE}
+ * @digestsize: algorithm's digest size
+ * @ctx_len: size of Context Register
+ * @key_dma: I/O Virtual Address of the key
+ */
+void cnstr_shdsc_axcbc(u32 * const desc, struct alginfo *adata, u32 state,
+		       int digestsize, int ctx_len, dma_addr_t key_dma)
+{
+	u32 *skip_key_load;
+
+	init_sh_desc(desc, HDR_SHARE_SERIAL | HDR_SAVECTX);
+
+	/* Skip loading of key, context if already shared */
+	skip_key_load = append_jump(desc, JUMP_TEST_ALL | JUMP_COND_SHRD);
+
+	if (state == OP_ALG_AS_INIT || state == OP_ALG_AS_INITFINAL) {
+		append_key_as_imm(desc, adata->key_virt, adata->keylen,
+				  adata->keylen, CLASS_1 | KEY_DEST_CLASS_REG);
+	} else { /* UPDATE, FINALIZE */
+		/* Load K1 */
+		append_key(desc, adata->key_dma, adata->keylen,
+			   CLASS_1 | KEY_DEST_CLASS_REG | KEY_ENC);
+		/* Restore context */
+		append_seq_load(desc, ctx_len, LDST_CLASS_1_CCB |
+				LDST_SRCDST_BYTE_CONTEXT);
+	}
+
+	set_jump_tgt_here(desc, skip_key_load);
+
+	/* Class 1 operation */
+	append_operation(desc, adata->algtype | state | OP_ALG_ENCRYPT);
+
+	/*
+	 * Load from buf and/or src and write to req->result or state->context
+	 * Calculate remaining bytes to read
+	 */
+	append_math_add(desc, VARSEQINLEN, SEQINLEN, REG0, CAAM_CMD_SZ);
+
+	/* Read remaining bytes */
+	append_seq_fifo_load(desc, 0, FIFOLD_CLASS_CLASS1 | FIFOLD_TYPE_LAST1 |
+			     FIFOLD_TYPE_MSG | FIFOLDST_VLF);
+
+	/* Save context (partial hash, K2, K3) */
+	append_seq_store(desc, digestsize, LDST_CLASS_1_CCB |
+			 LDST_SRCDST_BYTE_CONTEXT);
+	if (state == OP_ALG_AS_INIT)
+		/* Save K1 */
+		append_fifo_store(desc, key_dma, adata->keylen,
+				  LDST_CLASS_1_CCB | FIFOST_TYPE_KEY_KEK);
+}
+EXPORT_SYMBOL(cnstr_shdsc_axcbc);
+
 MODULE_LICENSE("Dual BSD/GPL");
 MODULE_DESCRIPTION("FSL CAAM ahash descriptors support");
 MODULE_AUTHOR("NXP Semiconductors");
diff --git a/drivers/crypto/caam/caamhash_desc.h b/drivers/crypto/caam/caamhash_desc.h
index 631fc1ac312c..cf4a437d4c02 100644
--- a/drivers/crypto/caam/caamhash_desc.h
+++ b/drivers/crypto/caam/caamhash_desc.h
@@ -18,4 +18,6 @@
 void cnstr_shdsc_ahash(u32 * const desc, struct alginfo *adata, u32 state,
 		       int digestsize, int ctx_len, bool import_ctx, int era);
 
+void cnstr_shdsc_axcbc(u32 * const desc, struct alginfo *adata, u32 state,
+		       int digestsize, int ctx_len, dma_addr_t key_dma);
 #endif /* _CAAMHASH_DESC_H_ */
-- 
2.16.2
