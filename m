From: Horia Geanta <horia.geanta@freescale.com>
Subject: [PATCH 8/9] crypto: caam - refactor descriptor creation
Date: Fri, 18 Jul 2014 19:37:25 +0300
Message-ID: <1405701446-13656-9-git-send-email-horia.geanta@freescale.com>
References: <1405701446-13656-1-git-send-email-horia.geanta@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: "David S. Miller" <davem@davemloft.net>,
	Carmen Iorga <carmen.iorga@freescale.com>,
	Kim Phillips <kim.phillips@freescale.com>,
	Alexandru Porosanu <alexandru.porosanu@freescale.com>,
	Vakul Garg <vakul@freescale.com>,
	Ruchika Gupta <ruchika.gupta@freescale.com>,
	"Horia Geanta" <horia.geanta@freescale.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	<linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1blp0183.outbound.protection.outlook.com ([207.46.163.183]:15365
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1030280AbaGRQj3 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 18 Jul 2014 12:39:29 -0400
In-Reply-To: <1405701446-13656-1-git-send-email-horia.geanta@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Refactor descriptor creation in caamalg and caamhash, i.e.
create whole descriptors in the same place / function.
This makes the code more comprehensible and easier to maintain.

Signed-off-by: Horia Geanta <horia.geanta@freescale.com>
---
 drivers/crypto/caam/caamalg.c  | 251 +++++++++++++++-----------
 drivers/crypto/caam/caamhash.c | 391 ++++++++++++++---------------------------
 2 files changed, 278 insertions(+), 364 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index ad5ef8c0c179..927d6467eeba 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -92,59 +92,6 @@
 #endif
 static struct list_head alg_list;
 
-/* Set DK bit in class 1 operation if shared */
-static inline void append_dec_op1(struct program *program, uint32_t type)
-{
-	LABEL(jump_cmd);
-	REFERENCE(pjump_cmd);
-	LABEL(uncond_jump_cmd);
-	REFERENCE(puncond_jump_cmd);
-
-	/* DK bit is valid only for AES */
-	if ((type & OP_ALG_ALGSEL_MASK) != OP_ALG_ALGSEL_AES) {
-		ALG_OPERATION(type & OP_ALG_ALGSEL_MASK, type & OP_ALG_AAI_MASK,
-			      OP_ALG_AS_INITFINAL, ICV_CHECK_DISABLE,
-			      OP_ALG_DECRYPT);
-		return;
-	}
-
-	pjump_cmd = JUMP(IMM(jump_cmd), LOCAL_JUMP, ALL_TRUE, SHRD);
-	ALG_OPERATION(type & OP_ALG_ALGSEL_MASK, type & OP_ALG_AAI_MASK,
-		      OP_ALG_AS_INITFINAL, ICV_CHECK_DISABLE,
-		      OP_ALG_DECRYPT);
-	puncond_jump_cmd = JUMP(IMM(uncond_jump_cmd), LOCAL_JUMP, ALL_TRUE, 0);
-	SET_LABEL(jump_cmd);
-	ALG_OPERATION(type & OP_ALG_ALGSEL_MASK,
-		      (type & OP_ALG_AAI_MASK) | OP_ALG_AAI_DK,
-		      OP_ALG_AS_INITFINAL, ICV_CHECK_DISABLE,
-		      OP_ALG_DECRYPT);
-	SET_LABEL(uncond_jump_cmd);
-
-	PATCH_JUMP(pjump_cmd, jump_cmd);
-	PATCH_JUMP(puncond_jump_cmd, uncond_jump_cmd);
-}
-
-/*
- * For aead encrypt and decrypt, read iv for both classes
- */
-static inline void aead_append_ld_iv(struct program *program, uint32_t ivsize)
-{
-	SEQLOAD(CONTEXT1, 0, ivsize, 0);
-	MOVE(CONTEXT1, 0, IFIFOAB2, 0, IMM(ivsize), 0);
-}
-
-/*
- * For ablkcipher encrypt and decrypt, read from req->src and
- * write to req->dst
- */
-static inline void ablkcipher_append_src_dst(struct program *program)
-{
-	MATHB(SEQINSZ, ADD, MATH0, VSEQOUTSZ, 4, 0);
-	MATHB(SEQINSZ, ADD, MATH0, VSEQINSZ, 4, 0);
-	SEQFIFOLOAD(MSG1, 0, VLF | LAST1);
-	SEQFIFOSTORE(MSG, 0, 0, VLF);
-}
-
 /*
  * If all data, including src (with assoc and iv) or dst (with iv only) are
  * contiguous
@@ -174,40 +121,6 @@ struct caam_ctx {
 	unsigned int authsize;
 };
 
-static void append_key_aead(struct program *program, struct caam_ctx *ctx,
-			    int keys_fit_inline)
-{
-	if (keys_fit_inline) {
-		KEY(MDHA_SPLIT_KEY, ENC, PTR((uintptr_t)ctx->key),
-		    ctx->split_key_len, IMMED);
-		KEY(KEY1, 0,
-		    PTR((uintptr_t)(ctx->key + ctx->split_key_pad_len)),
-		    ctx->enckeylen, IMMED);
-	} else {
-		KEY(MDHA_SPLIT_KEY, ENC, PTR(ctx->key_dma), ctx->split_key_len,
-		    0);
-		KEY(KEY1, 0, PTR(ctx->key_dma + ctx->split_key_pad_len),
-		    ctx->enckeylen, 0);
-	}
-}
-
-static void init_sh_desc_key_aead(struct program *program, struct caam_ctx *ctx,
-				  int keys_fit_inline)
-{
-	LABEL(key_jump_cmd);
-	REFERENCE(pkey_jump_cmd);
-
-	SHR_HDR(SHR_SERIAL, 1, 0);
-
-	/* Skip if already shared */
-	pkey_jump_cmd = JUMP(IMM(key_jump_cmd), LOCAL_JUMP, ALL_TRUE, SHRD);
-
-	append_key_aead(program, ctx, keys_fit_inline);
-
-	SET_LABEL(key_jump_cmd);
-	PATCH_JUMP(pkey_jump_cmd, key_jump_cmd);
-}
-
 static int aead_null_set_sh_desc(struct crypto_aead *aead)
 {
 	struct aead_tfm *tfm = &aead->base.crt_aead;
@@ -425,6 +338,12 @@ static int aead_set_sh_desc(struct crypto_aead *aead)
 	struct program *program = &prg;
 	unsigned desc_bytes;
 	bool ps = (sizeof(dma_addr_t) == sizeof(u64));
+	LABEL(skip_key_load);
+	REFERENCE(pskip_key_load);
+	LABEL(set_dk);
+	REFERENCE(pset_dk);
+	LABEL(skip_dk);
+	REFERENCE(pskip_dk);
 
 	if (!ctx->authsize)
 		return 0;
@@ -448,7 +367,25 @@ static int aead_set_sh_desc(struct crypto_aead *aead)
 	if (ps)
 		PROGRAM_SET_36BIT_ADDR();
 
-	init_sh_desc_key_aead(program, ctx, keys_fit_inline);
+	SHR_HDR(SHR_SERIAL, 1, 0);
+
+	/* Skip key loading if already shared */
+	pskip_key_load = JUMP(IMM(skip_key_load), LOCAL_JUMP, ALL_TRUE, SHRD);
+
+	if (keys_fit_inline) {
+		KEY(MDHA_SPLIT_KEY, ENC, PTR((uintptr_t)ctx->key),
+		    ctx->split_key_len, IMMED);
+		KEY(KEY1, 0,
+		    PTR((uintptr_t)(ctx->key + ctx->split_key_pad_len)),
+		    ctx->enckeylen, IMMED);
+	} else {
+		KEY(MDHA_SPLIT_KEY, ENC, PTR(ctx->key_dma), ctx->split_key_len,
+		    0);
+		KEY(KEY1, 0, PTR(ctx->key_dma + ctx->split_key_pad_len),
+		    ctx->enckeylen, 0);
+	}
+
+	SET_LABEL(skip_key_load);
 
 	/* Class 2 operation */
 	ALG_OPERATION(ctx->class2_alg_type & OP_ALG_ALGSEL_MASK,
@@ -467,7 +404,10 @@ static int aead_set_sh_desc(struct crypto_aead *aead)
 
 	/* read assoc before reading payload */
 	SEQFIFOLOAD(MSG2, 0 , VLF);
-	aead_append_ld_iv(program, tfm->ivsize);
+
+	/* read iv for both classes */
+	SEQLOAD(CONTEXT1, 0, tfm->ivsize, 0);
+	MOVE(CONTEXT1, 0, IFIFOAB2, 0, IMM(tfm->ivsize), 0);
 
 	/* Class 1 operation */
 	ALG_OPERATION(ctx->class1_alg_type & OP_ALG_ALGSEL_MASK,
@@ -486,6 +426,8 @@ static int aead_set_sh_desc(struct crypto_aead *aead)
 	/* Write ICV */
 	SEQSTORE(CONTEXT2, 0, ctx->authsize, 0);
 
+	PATCH_JUMP(pskip_key_load, skip_key_load);
+
 	PROGRAM_FINALIZE();
 
 	desc_bytes = DESC_BYTES(desc);
@@ -516,7 +458,26 @@ static int aead_set_sh_desc(struct crypto_aead *aead)
 	if (ps)
 		PROGRAM_SET_36BIT_ADDR();
 
-	init_sh_desc_key_aead(program, ctx, keys_fit_inline);
+	/* aead_decrypt shared descriptor */
+	SHR_HDR(SHR_SERIAL, 1, 0);
+
+	/* Skip key loading if already shared */
+	pskip_key_load = JUMP(IMM(skip_key_load), LOCAL_JUMP, ALL_TRUE, SHRD);
+
+	if (keys_fit_inline) {
+		KEY(MDHA_SPLIT_KEY, ENC, PTR((uintptr_t)ctx->key),
+		    ctx->split_key_len, IMMED);
+		KEY(KEY1, 0,
+		    PTR((uintptr_t)(ctx->key + ctx->split_key_pad_len)),
+		    ctx->enckeylen, IMMED);
+	} else {
+		KEY(MDHA_SPLIT_KEY, ENC, PTR(ctx->key_dma), ctx->split_key_len,
+		    0);
+		KEY(KEY1, 0, PTR(ctx->key_dma + ctx->split_key_pad_len),
+		    ctx->enckeylen, 0);
+	}
+
+	SET_LABEL(skip_key_load);
 
 	/* Class 2 operation */
 	ALG_OPERATION(ctx->class2_alg_type & OP_ALG_ALGSEL_MASK,
@@ -534,9 +495,30 @@ static int aead_set_sh_desc(struct crypto_aead *aead)
 	/* read assoc before reading payload */
 	SEQFIFOLOAD(MSG2, 0 , VLF);
 
-	aead_append_ld_iv(program, tfm->ivsize);
+	/* read iv for both classes */
+	SEQLOAD(CONTEXT1, 0, tfm->ivsize, 0);
+	MOVE(CONTEXT1, 0, IFIFOAB2, 0, IMM(tfm->ivsize), 0);
 
-	append_dec_op1(program, ctx->class1_alg_type);
+	/* Set DK bit in class 1 operation if shared (AES only) */
+	if ((ctx->class1_alg_type & OP_ALG_ALGSEL_MASK) == OP_ALG_ALGSEL_AES) {
+		pset_dk = JUMP(IMM(set_dk), LOCAL_JUMP, ALL_TRUE, SHRD);
+		ALG_OPERATION(ctx->class1_alg_type & OP_ALG_ALGSEL_MASK,
+			      ctx->class1_alg_type & OP_ALG_AAI_MASK,
+			      OP_ALG_AS_INITFINAL, ICV_CHECK_DISABLE,
+			      OP_ALG_DECRYPT);
+		pskip_dk = JUMP(IMM(skip_dk), LOCAL_JUMP, ALL_TRUE, 0);
+		SET_LABEL(set_dk);
+		ALG_OPERATION(ctx->class1_alg_type & OP_ALG_ALGSEL_MASK,
+			      (ctx->class1_alg_type & OP_ALG_AAI_MASK) |
+			       OP_ALG_AAI_DK, OP_ALG_AS_INITFINAL,
+			      ICV_CHECK_DISABLE, OP_ALG_DECRYPT);
+		SET_LABEL(skip_dk);
+	} else {
+		ALG_OPERATION(ctx->class1_alg_type & OP_ALG_ALGSEL_MASK,
+			      ctx->class1_alg_type & OP_ALG_AAI_MASK,
+			      OP_ALG_AS_INITFINAL, ICV_CHECK_DISABLE,
+			      OP_ALG_DECRYPT);
+	}
 
 	/* Read and write cryptlen bytes */
 	MATHB(ZERO, ADD, MATH2, VSEQINSZ, CAAM_CMD_SZ, 0);
@@ -549,6 +531,10 @@ static int aead_set_sh_desc(struct crypto_aead *aead)
 	/* Load ICV */
 	SEQFIFOLOAD(ICV2, ctx->authsize, LAST2);
 
+	PATCH_JUMP(pskip_key_load, skip_key_load);
+	PATCH_JUMP(pset_dk, set_dk);
+	PATCH_JUMP(pskip_dk, skip_dk);
+
 	PROGRAM_FINALIZE();
 
 	desc_bytes = DESC_BYTES(desc);
@@ -579,7 +565,25 @@ static int aead_set_sh_desc(struct crypto_aead *aead)
 	if (ps)
 		PROGRAM_SET_36BIT_ADDR();
 
-	init_sh_desc_key_aead(program, ctx, keys_fit_inline);
+	SHR_HDR(SHR_SERIAL, 1, 0);
+
+	/* Skip key loading if already shared */
+	pskip_key_load = JUMP(IMM(skip_key_load), LOCAL_JUMP, ALL_TRUE, SHRD);
+
+	if (keys_fit_inline) {
+		KEY(MDHA_SPLIT_KEY, ENC, PTR((uintptr_t)ctx->key),
+		    ctx->split_key_len, IMMED);
+		KEY(KEY1, 0,
+		    PTR((uintptr_t)(ctx->key + ctx->split_key_pad_len)),
+		    ctx->enckeylen, IMMED);
+	} else {
+		KEY(MDHA_SPLIT_KEY, ENC, PTR(ctx->key_dma), ctx->split_key_len,
+		    0);
+		KEY(KEY1, 0, PTR(ctx->key_dma + ctx->split_key_pad_len),
+		    ctx->enckeylen, 0);
+	}
+
+	SET_LABEL(skip_key_load);
 
 	/* Generate IV */
 	geniv = NFIFOENTRY_STYPE_PAD | NFIFOENTRY_DEST_DECO |
@@ -636,6 +640,8 @@ static int aead_set_sh_desc(struct crypto_aead *aead)
 	/* Write ICV */
 	SEQSTORE(CONTEXT2, 0, ctx->authsize, 0);
 
+	PATCH_JUMP(pskip_key_load, skip_key_load);
+
 	PROGRAM_FINALIZE();
 
 	desc_bytes = DESC_BYTES(desc);
@@ -749,8 +755,12 @@ static int ablkcipher_setkey(struct crypto_ablkcipher *ablkcipher,
 	struct program *program = &prg;
 	unsigned desc_bytes;
 	bool ps = (sizeof(dma_addr_t) == sizeof(u64));
-	LABEL(key_jump_cmd);
-	REFERENCE(pkey_jump_cmd);
+	LABEL(skip_key_load);
+	REFERENCE(pskip_key_load);
+	LABEL(set_dk);
+	REFERENCE(pset_dk);
+	LABEL(skip_dk);
+	REFERENCE(pskip_dk);
 
 #ifdef DEBUG
 	print_hex_dump(KERN_ERR, "key in @"__stringify(__LINE__)": ",
@@ -773,13 +783,14 @@ static int ablkcipher_setkey(struct crypto_ablkcipher *ablkcipher,
 		PROGRAM_SET_36BIT_ADDR();
 
 	SHR_HDR(SHR_SERIAL, 1, 0);
-	/* Skip if already shared */
-	pkey_jump_cmd = JUMP(IMM(key_jump_cmd), LOCAL_JUMP, ALL_TRUE, SHRD);
+
+	/* Skip key loading if already shared */
+	pskip_key_load = JUMP(IMM(skip_key_load), LOCAL_JUMP, ALL_TRUE, SHRD);
 
 	/* Load class1 key only */
 	KEY(KEY1, 0, PTR((uintptr_t)ctx->key), ctx->enckeylen, IMMED);
 
-	SET_LABEL(key_jump_cmd);
+	SET_LABEL(skip_key_load);
 
 	/* Load IV */
 	SEQLOAD(CONTEXT1, 0, tfm->ivsize, 0);
@@ -791,9 +802,12 @@ static int ablkcipher_setkey(struct crypto_ablkcipher *ablkcipher,
 		      OP_ALG_ENCRYPT);
 
 	/* Perform operation */
-	ablkcipher_append_src_dst(program);
+	MATHB(SEQINSZ, ADD, MATH0, VSEQOUTSZ, 4, 0);
+	MATHB(SEQINSZ, ADD, MATH0, VSEQINSZ, 4, 0);
+	SEQFIFOLOAD(MSG1, 0, VLF | LAST1);
+	SEQFIFOSTORE(MSG, 0, 0, VLF);
 
-	PATCH_JUMP(pkey_jump_cmd, key_jump_cmd);
+	PATCH_JUMP(pskip_key_load, skip_key_load);
 
 	PROGRAM_FINALIZE();
 
@@ -818,24 +832,47 @@ static int ablkcipher_setkey(struct crypto_ablkcipher *ablkcipher,
 
 	SHR_HDR(SHR_SERIAL, 1, 0);
 
-	/* Skip if already shared */
-	pkey_jump_cmd = JUMP(IMM(key_jump_cmd), LOCAL_JUMP, ALL_TRUE, SHRD);
+	/* Skip key loading if already shared */
+	pskip_key_load = JUMP(IMM(skip_key_load), LOCAL_JUMP, ALL_TRUE, SHRD);
 
 	/* Load class1 key only */
 	KEY(KEY1, 0, PTR((uintptr_t)ctx->key), ctx->enckeylen, IMMED);
 
-	SET_LABEL(key_jump_cmd);
+	SET_LABEL(skip_key_load);
 
 	/* load IV */
 	SEQLOAD(CONTEXT1, 0, tfm->ivsize, 0);
 
-	/* Choose operation */
-	append_dec_op1(program, ctx->class1_alg_type);
+	/* Set DK bit in class 1 operation if shared (AES only) */
+	if ((ctx->class1_alg_type & OP_ALG_ALGSEL_MASK) == OP_ALG_ALGSEL_AES) {
+		pset_dk = JUMP(IMM(set_dk), LOCAL_JUMP, ALL_TRUE, SHRD);
+		ALG_OPERATION(ctx->class1_alg_type & OP_ALG_ALGSEL_MASK,
+			      ctx->class1_alg_type & OP_ALG_AAI_MASK,
+			      OP_ALG_AS_INITFINAL, ICV_CHECK_DISABLE,
+			      OP_ALG_DECRYPT);
+		pskip_dk = JUMP(IMM(skip_dk), LOCAL_JUMP, ALL_TRUE, 0);
+		SET_LABEL(set_dk);
+		ALG_OPERATION(ctx->class1_alg_type & OP_ALG_ALGSEL_MASK,
+			      (ctx->class1_alg_type & OP_ALG_AAI_MASK) |
+			       OP_ALG_AAI_DK, OP_ALG_AS_INITFINAL,
+			      ICV_CHECK_DISABLE, OP_ALG_DECRYPT);
+		SET_LABEL(skip_dk);
+	} else {
+		ALG_OPERATION(ctx->class1_alg_type & OP_ALG_ALGSEL_MASK,
+			      ctx->class1_alg_type & OP_ALG_AAI_MASK,
+			      OP_ALG_AS_INITFINAL, ICV_CHECK_DISABLE,
+			      OP_ALG_DECRYPT);
+	}
 
 	/* Perform operation */
-	ablkcipher_append_src_dst(program);
+	MATHB(SEQINSZ, ADD, MATH0, VSEQOUTSZ, 4, 0);
+	MATHB(SEQINSZ, ADD, MATH0, VSEQINSZ, 4, 0);
+	SEQFIFOLOAD(MSG1, 0, VLF | LAST1);
+	SEQFIFOSTORE(MSG, 0, 0, VLF);
 
-	PATCH_JUMP(pkey_jump_cmd, key_jump_cmd);
+	PATCH_JUMP(pskip_key_load, skip_key_load);
+	PATCH_JUMP(pset_dk, set_dk);
+	PATCH_JUMP(pskip_dk, skip_dk);
 
 	PROGRAM_FINALIZE();
 
diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index ec66e715d825..a7e90be9845c 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -100,18 +100,18 @@ static struct list_head hash_list;
 /* ahash per-session context */
 struct caam_hash_ctx {
 	struct device *jrdev;
-	u32 sh_desc_update[DESC_HASH_MAX_USED_LEN];
-	u32 sh_desc_update_first[DESC_HASH_MAX_USED_LEN];
-	u32 sh_desc_fin[DESC_HASH_MAX_USED_LEN];
-	u32 sh_desc_digest[DESC_HASH_MAX_USED_LEN];
-	u32 sh_desc_finup[DESC_HASH_MAX_USED_LEN];
+	uint32_t sh_desc_update[DESC_HASH_MAX_USED_LEN];
+	uint32_t sh_desc_update_first[DESC_HASH_MAX_USED_LEN];
+	uint32_t sh_desc_fin[DESC_HASH_MAX_USED_LEN];
+	uint32_t sh_desc_digest[DESC_HASH_MAX_USED_LEN];
+	uint32_t sh_desc_finup[DESC_HASH_MAX_USED_LEN];
 	dma_addr_t sh_desc_update_dma;
 	dma_addr_t sh_desc_update_first_dma;
 	dma_addr_t sh_desc_fin_dma;
 	dma_addr_t sh_desc_digest_dma;
 	dma_addr_t sh_desc_finup_dma;
-	u32 alg_type;
-	u32 alg_op;
+	uint32_t alg_type;
+	uint32_t alg_op;
 	u8 key[CAAM_MAX_HASH_KEY_SIZE];
 	dma_addr_t key_dma;
 	int ctx_len;
@@ -136,37 +136,6 @@ struct caam_hash_state {
 
 /* Common job descriptor seq in/out ptr routines */
 
-/* Map state->caam_ctx, and append seq_out_ptr command that points to it */
-static inline int map_seq_out_ptr_ctx(struct program *program,
-				      struct device *jrdev,
-				      struct caam_hash_state *state,
-				      int ctx_len)
-{
-	state->ctx_dma = dma_map_single(jrdev, state->caam_ctx,
-					ctx_len, DMA_FROM_DEVICE);
-	if (dma_mapping_error(jrdev, state->ctx_dma)) {
-		dev_err(jrdev, "unable to map ctx\n");
-		return -ENOMEM;
-	}
-
-	SEQOUTPTR(state->ctx_dma, ctx_len, EXT);
-
-	return 0;
-}
-
-/* Map req->result, and append seq_out_ptr command that points to it */
-static inline dma_addr_t map_seq_out_ptr_result(struct program *program,
-						struct device *jrdev,
-						u8 *result, int digestsize)
-{
-	dma_addr_t dst_dma;
-
-	dst_dma = dma_map_single(jrdev, result, digestsize, DMA_FROM_DEVICE);
-	SEQOUTPTR(dst_dma, digestsize, EXT);
-
-	return dst_dma;
-}
-
 /* Map current buffer in state and put it in link table */
 static inline dma_addr_t buf_map_to_sec4_sg(struct device *jrdev,
 					    struct sec4_sg_entry *sec4_sg,
@@ -225,90 +194,64 @@ static inline int ctx_map_to_sec4_sg(u32 *desc, struct device *jrdev,
 	return 0;
 }
 
-/* Common shared descriptor commands */
-static inline void append_key_ahash(struct program *program,
-				    struct caam_hash_ctx *ctx)
+/*
+ * For ahash update, final and finup (import_ctx = true)
+ *     import context, read and write to seqout
+ * For ahash firsts and digest (import_ctx = false)
+ *     read and write to seqout
+ */
+static inline void ahash_gen_sh_desc(uint32_t *desc, uint32_t state,
+				     int digestsize, struct caam_hash_ctx *ctx,
+				     bool import_ctx)
 {
-	KEY(MDHA_SPLIT_KEY, ENC, PTR((uintptr_t)ctx->key),
-	    ctx->split_key_len, IMMED);
-}
+	uint32_t op = ctx->alg_type;
+	struct program prg;
+	struct program *program = &prg;
+	bool ps = (sizeof(dma_addr_t) == sizeof(u64));
+	LABEL(skip_key_load);
+	REFERENCE(pskip_key_load);
 
-/* Append key if it has been set */
-static inline void init_sh_desc_key_ahash(struct program *program,
-					  struct caam_hash_ctx *ctx)
-{
-	LABEL(key_jump_cmd);
-	REFERENCE(pkey_jump_cmd);
+	PROGRAM_CNTXT_INIT(desc, 0);
+	if (ps)
+		PROGRAM_SET_36BIT_ADDR();
 
 	SHR_HDR(SHR_SERIAL, 1, 0);
 
-	if (ctx->split_key_len) {
-		/* Skip if already shared */
-		pkey_jump_cmd = JUMP(IMM(key_jump_cmd), LOCAL_JUMP, ALL_TRUE,
-				     SHRD);
-
-		append_key_ahash(program, ctx);
-
-		SET_LABEL(key_jump_cmd);
+	/* Append key if it has been set; ahash update excluded */
+	if ((state != OP_ALG_AS_UPDATE) && (ctx->split_key_len)) {
+		/* Skip key loading if already shared */
+		pskip_key_load = JUMP(IMM(skip_key_load), LOCAL_JUMP, ALL_TRUE,
+				      SHRD);
 
-		PATCH_JUMP(pkey_jump_cmd, key_jump_cmd);
-	}
-}
-
-/*
- * For ahash read data from seqin following state->caam_ctx,
- * and write resulting class2 context to seqout, which may be state->caam_ctx
- * or req->result
- */
-static inline void ahash_append_load_str(struct program *program,
-					 int digestsize)
-{
-	/* Calculate remaining bytes to read */
-	MATHB(SEQINSZ, ADD, MATH0, VSEQINSZ, CAAM_CMD_SZ, 0);
+		KEY(MDHA_SPLIT_KEY, ENC, PTR((uintptr_t)ctx->key),
+		    ctx->split_key_len, IMMED);
 
-	/* Read remaining bytes */
-	SEQFIFOLOAD(MSG2, 0, VLF | LAST2);
+		SET_LABEL(skip_key_load);
 
-	/* Store class2 context bytes */
-	SEQSTORE(CONTEXT2, 0, digestsize, 0);
-}
+		PATCH_JUMP(pskip_key_load, skip_key_load);
 
-/*
- * For ahash update, final and finup, import context, read and write to seqout
- */
-static inline void ahash_ctx_data_to_out(struct program *program, u32 op,
-					 u32 state, int digestsize,
-					 struct caam_hash_ctx *ctx)
-{
-	init_sh_desc_key_ahash(program, ctx);
+		op |= OP_ALG_AAI_HMAC_PRECOMP;
+	}
 
-	/* Import context from software */
-	SEQLOAD(CONTEXT2, 0, ctx->ctx_len, 0);
+	/* If needed, import context from software */
+	if (import_ctx)
+		SEQLOAD(CONTEXT2, 0, ctx->ctx_len, 0);
 
 	/* Class 2 operation */
-	ALG_OPERATION(op & OP_ALG_ALGSEL_MASK, op & OP_ALG_AAI_MASK, state,
-		      ICV_CHECK_DISABLE, OP_ALG_ENCRYPT);
+	ALG_OPERATION(op & OP_ALG_ALGSEL_MASK, op & OP_ALG_AAI_MASK,
+		      state, ICV_CHECK_DISABLE, OP_ALG_ENCRYPT);
 
 	/*
 	 * Load from buf and/or src and write to req->result or state->context
+	 * Calculate remaining bytes to read
 	 */
-	ahash_append_load_str(program, digestsize);
-}
-
-/* For ahash firsts and digest, read and write to seqout */
-static inline void ahash_data_to_out(struct program *program, u32 op, u32 state,
-				     int digestsize, struct caam_hash_ctx *ctx)
-{
-	init_sh_desc_key_ahash(program, ctx);
-
-	/* Class 2 operation */
-	ALG_OPERATION(op & OP_ALG_ALGSEL_MASK, op & OP_ALG_AAI_MASK, state,
-		      ICV_CHECK_DISABLE, OP_ALG_ENCRYPT);
+	MATHB(SEQINSZ, ADD, MATH0, VSEQINSZ, CAAM_CMD_SZ, 0);
+	/* Read remaining bytes */
+	SEQFIFOLOAD(MSG2, 0, VLF | LAST2);
+	/* Store class2 context bytes */
+	SEQSTORE(CONTEXT2, 0, digestsize, 0);
 
-	/*
-	 * Load from buf and/or src and write to req->result or state->context
-	 */
-	ahash_append_load_str(program, digestsize);
+	PROGRAM_FINALIZE();
 }
 
 static int ahash_set_sh_desc(struct crypto_ahash *ahash)
@@ -316,36 +259,11 @@ static int ahash_set_sh_desc(struct crypto_ahash *ahash)
 	struct caam_hash_ctx *ctx = crypto_ahash_ctx(ahash);
 	int digestsize = crypto_ahash_digestsize(ahash);
 	struct device *jrdev = ctx->jrdev;
-	u32 have_key = 0;
 	uint32_t *desc;
-	struct program prg;
-	struct program *program = &prg;
-	bool ps = (sizeof(dma_addr_t) == sizeof(u64));
-
-	if (ctx->split_key_len)
-		have_key = OP_ALG_AAI_HMAC_PRECOMP;
 
 	/* ahash_update shared descriptor */
 	desc = ctx->sh_desc_update;
-	PROGRAM_CNTXT_INIT(desc, 0);
-	if (ps)
-		PROGRAM_SET_36BIT_ADDR();
-
-	SHR_HDR(SHR_SERIAL, 1, 0);
-
-	/* Import context from software */
-	SEQLOAD(CONTEXT2, 0, ctx->ctx_len, 0);
-
-	/* Class 2 operation */
-	ALG_OPERATION(ctx->alg_type & OP_ALG_ALGSEL_MASK,
-		      ctx->alg_type & OP_ALG_AAI_MASK, OP_ALG_AS_UPDATE,
-		      ICV_CHECK_DISABLE, OP_ALG_ENCRYPT);
-
-	/* Load data and write to result or context */
-	ahash_append_load_str(program, ctx->ctx_len);
-
-	PROGRAM_FINALIZE();
-
+	ahash_gen_sh_desc(desc, OP_ALG_AS_UPDATE, ctx->ctx_len, ctx, true);
 	ctx->sh_desc_update_dma = dma_map_single(jrdev, desc, DESC_BYTES(desc),
 						 DMA_TO_DEVICE);
 	if (dma_mapping_error(jrdev, ctx->sh_desc_update_dma)) {
@@ -360,15 +278,7 @@ static int ahash_set_sh_desc(struct crypto_ahash *ahash)
 
 	/* ahash_update_first shared descriptor */
 	desc = ctx->sh_desc_update_first;
-	PROGRAM_CNTXT_INIT(desc, 0);
-	if (ps)
-		PROGRAM_SET_36BIT_ADDR();
-
-	ahash_data_to_out(program, have_key | ctx->alg_type, OP_ALG_AS_INIT,
-			  ctx->ctx_len, ctx);
-
-	PROGRAM_FINALIZE();
-
+	ahash_gen_sh_desc(desc,  OP_ALG_AS_INIT, ctx->ctx_len, ctx, false);
 	ctx->sh_desc_update_first_dma = dma_map_single(jrdev, desc,
 						       DESC_BYTES(desc),
 						       DMA_TO_DEVICE);
@@ -384,15 +294,7 @@ static int ahash_set_sh_desc(struct crypto_ahash *ahash)
 
 	/* ahash_final shared descriptor */
 	desc = ctx->sh_desc_fin;
-	PROGRAM_CNTXT_INIT(desc, 0);
-	if (ps)
-		PROGRAM_SET_36BIT_ADDR();
-
-	ahash_ctx_data_to_out(program, have_key | ctx->alg_type,
-			      OP_ALG_AS_FINALIZE, digestsize, ctx);
-
-	PROGRAM_FINALIZE();
-
+	ahash_gen_sh_desc(desc, OP_ALG_AS_FINALIZE, digestsize, ctx, true);
 	ctx->sh_desc_fin_dma = dma_map_single(jrdev, desc, DESC_BYTES(desc),
 					      DMA_TO_DEVICE);
 	if (dma_mapping_error(jrdev, ctx->sh_desc_fin_dma)) {
@@ -406,15 +308,7 @@ static int ahash_set_sh_desc(struct crypto_ahash *ahash)
 
 	/* ahash_finup shared descriptor */
 	desc = ctx->sh_desc_finup;
-	PROGRAM_CNTXT_INIT(desc, 0);
-	if (ps)
-		PROGRAM_SET_36BIT_ADDR();
-
-	ahash_ctx_data_to_out(program, have_key | ctx->alg_type,
-			      OP_ALG_AS_FINALIZE, digestsize, ctx);
-
-	PROGRAM_FINALIZE();
-
+	ahash_gen_sh_desc(desc, OP_ALG_AS_FINALIZE, digestsize, ctx, true);
 	ctx->sh_desc_finup_dma = dma_map_single(jrdev, desc, DESC_BYTES(desc),
 						DMA_TO_DEVICE);
 	if (dma_mapping_error(jrdev, ctx->sh_desc_finup_dma)) {
@@ -428,15 +322,7 @@ static int ahash_set_sh_desc(struct crypto_ahash *ahash)
 
 	/* ahash_digest shared descriptor */
 	desc = ctx->sh_desc_digest;
-	PROGRAM_CNTXT_INIT(desc, 0);
-	if (ps)
-		PROGRAM_SET_36BIT_ADDR();
-
-	ahash_data_to_out(program, have_key | ctx->alg_type,
-			  OP_ALG_AS_INITFINAL, digestsize, ctx);
-
-	PROGRAM_FINALIZE();
-
+	ahash_gen_sh_desc(desc, OP_ALG_AS_INITFINAL, digestsize, ctx, false);
 	ctx->sh_desc_digest_dma = dma_map_single(jrdev, desc, DESC_BYTES(desc),
 						 DMA_TO_DEVICE);
 	if (dma_mapping_error(jrdev, ctx->sh_desc_digest_dma)) {
@@ -897,7 +783,6 @@ static int ahash_update_ctx(struct ahash_request *req)
 
 		SEQINPTR(edesc->sec4_sg_dma, ctx->ctx_len + to_hash, SGF | EXT);
 		SEQOUTPTR(state->ctx_dma, ctx->ctx_len, EXT);
-
 		PROGRAM_FINALIZE();
 
 #ifdef DEBUG
@@ -963,17 +848,17 @@ static int ahash_final_ctx(struct ahash_request *req)
 		return -ENOMEM;
 	}
 
-	sh_len = DESC_LEN(sh_desc);
 	desc = edesc->hw_desc;
-	PROGRAM_CNTXT_INIT(desc, sh_len);
-	if (ps)
-		PROGRAM_SET_36BIT_ADDR();
-
-	JOB_HDR(SHR_DEFER, sh_len, ptr, REO | SHR);
-
 	edesc->sec4_sg_bytes = sec4_sg_bytes;
 	edesc->sec4_sg = (void *)edesc + sizeof(struct ahash_edesc) +
 			 DESC_JOB_IO_LEN;
+	edesc->dst_dma = dma_map_single(jrdev, req->result, digestsize,
+					DMA_FROM_DEVICE);
+	if (dma_mapping_error(jrdev, edesc->dst_dma)) {
+		dev_err(jrdev, "unable to map dst\n");
+		return -ENOMEM;
+	}
+
 	edesc->src_nents = 0;
 
 	ret = ctx_map_to_sec4_sg(desc, jrdev, state, ctx->ctx_len,
@@ -986,6 +871,12 @@ static int ahash_final_ctx(struct ahash_request *req)
 						last_buflen);
 	(edesc->sec4_sg + sec4_sg_bytes - 1)->len |= SEC4_SG_LEN_FIN;
 
+	sh_len = DESC_LEN(sh_desc);
+	PROGRAM_CNTXT_INIT(desc, sh_len);
+	if (ps)
+		PROGRAM_SET_36BIT_ADDR();
+	JOB_HDR(SHR_DEFER, sh_len, ptr, REO | SHR);
+
 	edesc->sec4_sg_dma = dma_map_single(jrdev, edesc->sec4_sg,
 					    sec4_sg_bytes, DMA_TO_DEVICE);
 	if (dma_mapping_error(jrdev, edesc->sec4_sg_dma)) {
@@ -994,14 +885,7 @@ static int ahash_final_ctx(struct ahash_request *req)
 	}
 
 	SEQINPTR(edesc->sec4_sg_dma, ctx->ctx_len + buflen, SGF | EXT);
-
-	edesc->dst_dma = map_seq_out_ptr_result(program, jrdev, req->result,
-						digestsize);
-	if (dma_mapping_error(jrdev, edesc->dst_dma)) {
-		dev_err(jrdev, "unable to map dst\n");
-		return -ENOMEM;
-	}
-
+	SEQOUTPTR(edesc->dst_dma, digestsize, EXT);
 	PROGRAM_FINALIZE();
 
 #ifdef DEBUG
@@ -1058,19 +942,18 @@ static int ahash_finup_ctx(struct ahash_request *req)
 		return -ENOMEM;
 	}
 
-	sh_len = DESC_LEN(sh_desc);
 	desc = edesc->hw_desc;
-	PROGRAM_CNTXT_INIT(desc, sh_len);
-	if (ps)
-		PROGRAM_SET_36BIT_ADDR();
-
-	JOB_HDR(SHR_DEFER, sh_len, ptr, REO | SHR);
-
 	edesc->src_nents = src_nents;
 	edesc->chained = chained;
 	edesc->sec4_sg_bytes = sec4_sg_bytes;
 	edesc->sec4_sg = (void *)edesc + sizeof(struct ahash_edesc) +
 			 DESC_JOB_IO_LEN;
+	edesc->dst_dma = dma_map_single(jrdev, req->result, digestsize,
+					DMA_FROM_DEVICE);
+	if (dma_mapping_error(jrdev, edesc->dst_dma)) {
+		dev_err(jrdev, "unable to map dst\n");
+		return -ENOMEM;
+	}
 
 	ret = ctx_map_to_sec4_sg(desc, jrdev, state, ctx->ctx_len,
 				 edesc->sec4_sg, DMA_TO_DEVICE);
@@ -1084,6 +967,12 @@ static int ahash_finup_ctx(struct ahash_request *req)
 	src_map_to_sec4_sg(jrdev, req->src, src_nents, edesc->sec4_sg +
 			   sec4_sg_src_index, chained);
 
+	sh_len = DESC_LEN(sh_desc);
+	PROGRAM_CNTXT_INIT(desc, sh_len);
+	if (ps)
+		PROGRAM_SET_36BIT_ADDR();
+	JOB_HDR(SHR_DEFER, sh_len, ptr, REO | SHR);
+
 	edesc->sec4_sg_dma = dma_map_single(jrdev, edesc->sec4_sg,
 					    sec4_sg_bytes, DMA_TO_DEVICE);
 	if (dma_mapping_error(jrdev, edesc->sec4_sg_dma)) {
@@ -1093,14 +982,7 @@ static int ahash_finup_ctx(struct ahash_request *req)
 
 	SEQINPTR(edesc->sec4_sg_dma, ctx->ctx_len + buflen + req->nbytes,
 		 SGF | EXT);
-
-	edesc->dst_dma = map_seq_out_ptr_result(program, jrdev, req->result,
-						digestsize);
-	if (dma_mapping_error(jrdev, edesc->dst_dma)) {
-		dev_err(jrdev, "unable to map dst\n");
-		return -ENOMEM;
-	}
-
+	SEQOUTPTR(edesc->dst_dma, digestsize, EXT);
 	PROGRAM_FINALIZE();
 
 #ifdef DEBUG
@@ -1155,17 +1037,16 @@ static int ahash_digest(struct ahash_request *req)
 	edesc->sec4_sg = (void *)edesc + sizeof(struct ahash_edesc) +
 			  DESC_JOB_IO_LEN;
 	edesc->sec4_sg_bytes = sec4_sg_bytes;
+	edesc->dst_dma = dma_map_single(jrdev, req->result, digestsize,
+					DMA_FROM_DEVICE);
+	if (dma_mapping_error(jrdev, edesc->dst_dma)) {
+		dev_err(jrdev, "unable to map dst\n");
+		return -ENOMEM;
+	}
+
 	edesc->src_nents = src_nents;
 	edesc->chained = chained;
-
-	sh_len = DESC_LEN(sh_desc);
 	desc = edesc->hw_desc;
-	PROGRAM_CNTXT_INIT(desc, sh_len);
-	if (ps)
-		PROGRAM_SET_36BIT_ADDR();
-
-	JOB_HDR(SHR_DEFER, sh_len, ptr, REO | SHR);
-
 	if (src_nents) {
 		sg_to_sec4_sg_last(req->src, src_nents, edesc->sec4_sg, 0);
 		edesc->sec4_sg_dma = dma_map_single(jrdev, edesc->sec4_sg,
@@ -1179,15 +1060,14 @@ static int ahash_digest(struct ahash_request *req)
 	} else {
 		src_dma = sg_dma_address(req->src);
 	}
-	SEQINPTR(src_dma, req->nbytes, options);
-
-	edesc->dst_dma = map_seq_out_ptr_result(program, jrdev, req->result,
-						digestsize);
-	if (dma_mapping_error(jrdev, edesc->dst_dma)) {
-		dev_err(jrdev, "unable to map dst\n");
-		return -ENOMEM;
-	}
 
+	sh_len = DESC_LEN(sh_desc);
+	PROGRAM_CNTXT_INIT(desc, sh_len);
+	if (ps)
+		PROGRAM_SET_36BIT_ADDR();
+	JOB_HDR(SHR_DEFER, sh_len, ptr, REO | SHR);
+	SEQINPTR(src_dma, req->nbytes, options);
+	SEQOUTPTR(edesc->dst_dma, digestsize, EXT);
 	PROGRAM_FINALIZE();
 
 #ifdef DEBUG
@@ -1235,33 +1115,30 @@ static int ahash_final_no_ctx(struct ahash_request *req)
 		return -ENOMEM;
 	}
 
-	sh_len = DESC_LEN(sh_desc);
+	edesc->src_nents = 0;
 	desc = edesc->hw_desc;
-	PROGRAM_CNTXT_INIT(desc, sh_len);
-	if (ps)
-		PROGRAM_SET_36BIT_ADDR();
-
-	JOB_HDR(SHR_DEFER, sh_len, ptr, REO | SHR);
-
 	state->buf_dma = dma_map_single(jrdev, buf, buflen, DMA_TO_DEVICE);
 	if (dma_mapping_error(jrdev, state->buf_dma)) {
 		dev_err(jrdev, "unable to map src\n");
 		return -ENOMEM;
 	}
 
-	SEQINPTR(state->buf_dma, buflen, EXT);
-
-	edesc->dst_dma = map_seq_out_ptr_result(program, jrdev, req->result,
-						digestsize);
+	edesc->dst_dma = dma_map_single(jrdev, req->result, digestsize,
+					DMA_FROM_DEVICE);
 	if (dma_mapping_error(jrdev, edesc->dst_dma)) {
 		dev_err(jrdev, "unable to map dst\n");
 		return -ENOMEM;
 	}
 
+	sh_len = DESC_LEN(sh_desc);
+	PROGRAM_CNTXT_INIT(desc, sh_len);
+	if (ps)
+		PROGRAM_SET_36BIT_ADDR();
+	JOB_HDR(SHR_DEFER, sh_len, ptr, REO | SHR);
+	SEQINPTR(state->buf_dma, buflen, EXT);
+	SEQOUTPTR(edesc->dst_dma, digestsize, EXT);
 	PROGRAM_FINALIZE();
 
-	edesc->src_nents = 0;
-
 #ifdef DEBUG
 	print_hex_dump(KERN_ERR, "jobdesc@"__stringify(__LINE__)": ",
 		       DUMP_PREFIX_ADDRESS, 16, 4, desc, DESC_BYTES(desc), 1);
@@ -1325,6 +1202,7 @@ static int ahash_update_no_ctx(struct ahash_request *req)
 			return -ENOMEM;
 		}
 
+		desc = edesc->hw_desc;
 		edesc->src_nents = src_nents;
 		edesc->chained = chained;
 		edesc->sec4_sg_bytes = sec4_sg_bytes;
@@ -1342,12 +1220,17 @@ static int ahash_update_no_ctx(struct ahash_request *req)
 			state->current_buf = !state->current_buf;
 		}
 
+		state->ctx_dma = dma_map_single(jrdev, state->caam_ctx,
+						ctx->ctx_len, DMA_FROM_DEVICE);
+		if (dma_mapping_error(jrdev, state->ctx_dma)) {
+			dev_err(jrdev, "unable to map ctx\n");
+			return -ENOMEM;
+		}
+
 		sh_len = DESC_LEN(sh_desc);
-		desc = edesc->hw_desc;
 		PROGRAM_CNTXT_INIT(desc, sh_len);
 		if (ps)
 			PROGRAM_SET_36BIT_ADDR();
-
 		JOB_HDR(SHR_DEFER, sh_len, ptr, REO | SHR);
 
 		edesc->sec4_sg_dma = dma_map_single(jrdev, edesc->sec4_sg,
@@ -1359,11 +1242,7 @@ static int ahash_update_no_ctx(struct ahash_request *req)
 		}
 
 		SEQINPTR(edesc->sec4_sg_dma, to_hash, SGF | EXT);
-
-		ret = map_seq_out_ptr_ctx(program, jrdev, state, ctx->ctx_len);
-		if (ret)
-			return ret;
-
+		SEQOUTPTR(state->ctx_dma, ctx->ctx_len, EXT);
 		PROGRAM_FINALIZE();
 
 #ifdef DEBUG
@@ -1437,19 +1316,18 @@ static int ahash_finup_no_ctx(struct ahash_request *req)
 		return -ENOMEM;
 	}
 
-	sh_len = DESC_LEN(sh_desc);
 	desc = edesc->hw_desc;
-	PROGRAM_CNTXT_INIT(desc, sh_len);
-	if (ps)
-		PROGRAM_SET_36BIT_ADDR();
-
-	JOB_HDR(SHR_DEFER, sh_len, ptr, REO | SHR);
-
 	edesc->src_nents = src_nents;
 	edesc->chained = chained;
 	edesc->sec4_sg_bytes = sec4_sg_bytes;
 	edesc->sec4_sg = (void *)edesc + sizeof(struct ahash_edesc) +
 			 DESC_JOB_IO_LEN;
+	edesc->dst_dma = dma_map_single(jrdev, req->result, digestsize,
+					DMA_FROM_DEVICE);
+	if (dma_mapping_error(jrdev, edesc->dst_dma)) {
+		dev_err(jrdev, "unable to map dst\n");
+		return -ENOMEM;
+	}
 
 	state->buf_dma = try_buf_map_to_sec4_sg(jrdev, edesc->sec4_sg, buf,
 						state->buf_dma, buflen,
@@ -1458,6 +1336,12 @@ static int ahash_finup_no_ctx(struct ahash_request *req)
 	src_map_to_sec4_sg(jrdev, req->src, src_nents, edesc->sec4_sg + 1,
 			   chained);
 
+	sh_len = DESC_LEN(sh_desc);
+	PROGRAM_CNTXT_INIT(desc, sh_len);
+	if (ps)
+		PROGRAM_SET_36BIT_ADDR();
+	JOB_HDR(SHR_DEFER, sh_len, ptr, REO | SHR);
+
 	edesc->sec4_sg_dma = dma_map_single(jrdev, edesc->sec4_sg,
 					    sec4_sg_bytes, DMA_TO_DEVICE);
 	if (dma_mapping_error(jrdev, edesc->sec4_sg_dma)) {
@@ -1466,14 +1350,7 @@ static int ahash_finup_no_ctx(struct ahash_request *req)
 	}
 
 	SEQINPTR(edesc->sec4_sg_dma, buflen + req->nbytes, SGF | EXT);
-
-	edesc->dst_dma = map_seq_out_ptr_result(program, jrdev, req->result,
-						digestsize);
-	if (dma_mapping_error(jrdev, edesc->dst_dma)) {
-		dev_err(jrdev, "unable to map dst\n");
-		return -ENOMEM;
-	}
-
+	SEQOUTPTR(edesc->dst_dma, digestsize, EXT);
 	PROGRAM_FINALIZE();
 
 #ifdef DEBUG
@@ -1541,12 +1418,19 @@ static int ahash_update_first(struct ahash_request *req)
 			return -ENOMEM;
 		}
 
+		desc = edesc->hw_desc;
 		edesc->src_nents = src_nents;
 		edesc->chained = chained;
 		edesc->sec4_sg_bytes = sec4_sg_bytes;
 		edesc->sec4_sg = (void *)edesc + sizeof(struct ahash_edesc) +
 				 DESC_JOB_IO_LEN;
 		edesc->dst_dma = 0;
+		state->ctx_dma = dma_map_single(jrdev, state->caam_ctx,
+						ctx->ctx_len, DMA_FROM_DEVICE);
+		if (dma_mapping_error(jrdev, state->ctx_dma)) {
+			dev_err(jrdev, "unable to map ctx\n");
+			return -ENOMEM;
+		}
 
 		if (src_nents) {
 			sg_to_sec4_sg_last(req->src, src_nents,
@@ -1569,19 +1453,12 @@ static int ahash_update_first(struct ahash_request *req)
 			sg_copy_part(next_buf, req->src, to_hash, req->nbytes);
 
 		sh_len = DESC_LEN(sh_desc);
-		desc = edesc->hw_desc;
 		PROGRAM_CNTXT_INIT(desc, sh_len);
 		if (ps)
 			PROGRAM_SET_36BIT_ADDR();
-
 		JOB_HDR(SHR_DEFER, sh_len, ptr, REO | SHR);
-
 		SEQINPTR(src_dma, to_hash, options);
-
-		ret = map_seq_out_ptr_ctx(program, jrdev, state, ctx->ctx_len);
-		if (ret)
-			return ret;
-
+		SEQOUTPTR(state->ctx_dma, ctx->ctx_len, EXT);
 		PROGRAM_FINALIZE();
 
 #ifdef DEBUG
-- 
1.8.3.1
