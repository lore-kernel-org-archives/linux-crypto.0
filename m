From: Horia Geanta <horia.geanta@freescale.com>
Subject: [PATCH v2 10/12] crypto: caam - refactor descriptor creation
Date: Thu, 14 Aug 2014 15:54:32 +0300
Message-ID: <1408020874-2211-11-git-send-email-horia.geanta@freescale.com>
References: <1408020874-2211-1-git-send-email-horia.geanta@freescale.com>
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
Received: from mail-bn1lp0139.outbound.protection.outlook.com ([207.46.163.139]:27887
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754677AbaHNM4M (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 14 Aug 2014 08:56:12 -0400
In-Reply-To: <1408020874-2211-1-git-send-email-horia.geanta@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Refactor descriptor creation in caamalg and caamhash, i.e.
create whole descriptors in the same place / function.
This makes the code more comprehensible and easier to maintain.

Signed-off-by: Horia Geanta <horia.geanta@freescale.com>
---
 drivers/crypto/caam/caamalg.c  | 244 +++++++++++++++------------
 drivers/crypto/caam/caamhash.c | 368 ++++++++++++++---------------------------
 2 files changed, 262 insertions(+), 350 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index cd1ba573c633..9090fc8c04e0 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -94,57 +94,6 @@
 static struct list_head alg_list;
 static const bool ps = (sizeof(dma_addr_t) == sizeof(u64));
 
-/* Set DK bit in class 1 operation if shared */
-static inline void append_dec_op1(struct program *p, u32 type)
-{
-	LABEL(jump_cmd);
-	REFERENCE(pjump_cmd);
-	LABEL(uncond_jump_cmd);
-	REFERENCE(puncond_jump_cmd);
-
-	/* DK bit is valid only for AES */
-	if ((type & OP_ALG_ALGSEL_MASK) != OP_ALG_ALGSEL_AES) {
-		ALG_OPERATION(p, type & OP_ALG_ALGSEL_MASK,
-			      type & OP_ALG_AAI_MASK, OP_ALG_AS_INITFINAL,
-			      ICV_CHECK_DISABLE, DIR_DEC);
-		return;
-	}
-
-	pjump_cmd = JUMP(p, jump_cmd, LOCAL_JUMP, ALL_TRUE, SHRD);
-	ALG_OPERATION(p, type & OP_ALG_ALGSEL_MASK, type & OP_ALG_AAI_MASK,
-		      OP_ALG_AS_INITFINAL, ICV_CHECK_DISABLE, DIR_DEC);
-	puncond_jump_cmd = JUMP(p, uncond_jump_cmd, LOCAL_JUMP, ALL_TRUE, 0);
-	SET_LABEL(p, jump_cmd);
-	ALG_OPERATION(p, type & OP_ALG_ALGSEL_MASK,
-		      (type & OP_ALG_AAI_MASK) | OP_ALG_AAI_DK,
-		      OP_ALG_AS_INITFINAL, ICV_CHECK_DISABLE, DIR_DEC);
-	SET_LABEL(p, uncond_jump_cmd);
-
-	PATCH_JUMP(p, pjump_cmd, jump_cmd);
-	PATCH_JUMP(p, puncond_jump_cmd, uncond_jump_cmd);
-}
-
-/*
- * For aead encrypt and decrypt, read iv for both classes
- */
-static inline void aead_append_ld_iv(struct program *p, u32 ivsize)
-{
-	SEQLOAD(p, CONTEXT1, 0, ivsize, 0);
-	MOVE(p, CONTEXT1, 0, IFIFOAB2, 0, ivsize, IMMED);
-}
-
-/*
- * For ablkcipher encrypt and decrypt, read from req->src and
- * write to req->dst
- */
-static inline void ablkcipher_append_src_dst(struct program *p)
-{
-	MATHB(p, SEQINSZ, ADD, MATH0, VSEQOUTSZ, 4, 0);
-	MATHB(p, SEQINSZ, ADD, MATH0, VSEQINSZ, 4, 0);
-	SEQFIFOLOAD(p, MSG1, 0, VLF | LAST1);
-	SEQFIFOSTORE(p, MSG, 0, 0, VLF);
-}
-
 /*
  * If all data, including src (with assoc and iv) or dst (with iv only) are
  * contiguous
@@ -173,39 +122,6 @@ struct caam_ctx {
 	unsigned int authsize;
 };
 
-static void append_key_aead(struct program *p, struct caam_ctx *ctx,
-			    int keys_fit_inline)
-{
-	if (keys_fit_inline) {
-		KEY(p, MDHA_SPLIT_KEY, ENC, (uintptr_t)ctx->key,
-		    ctx->split_key_len, IMMED | COPY);
-		KEY(p, KEY1, 0, (uintptr_t)(ctx->key + ctx->split_key_pad_len),
-		    ctx->enckeylen, IMMED | COPY);
-	} else {
-		KEY(p, MDHA_SPLIT_KEY, ENC, ctx->key_dma, ctx->split_key_len,
-		    0);
-		KEY(p, KEY1, 0, ctx->key_dma + ctx->split_key_pad_len,
-		    ctx->enckeylen, 0);
-	}
-}
-
-static void init_sh_desc_key_aead(struct program *p, struct caam_ctx *ctx,
-				  int keys_fit_inline)
-{
-	LABEL(key_jump_cmd);
-	REFERENCE(pkey_jump_cmd);
-
-	SHR_HDR(p, SHR_SERIAL, 1, 0);
-
-	/* Skip if already shared */
-	pkey_jump_cmd = JUMP(p, key_jump_cmd, LOCAL_JUMP, ALL_TRUE, SHRD);
-
-	append_key_aead(p, ctx, keys_fit_inline);
-
-	SET_LABEL(p, key_jump_cmd);
-	PATCH_JUMP(p, pkey_jump_cmd, key_jump_cmd);
-}
-
 static int aead_null_set_sh_desc(struct crypto_aead *aead)
 {
 	struct aead_tfm *tfm = &aead->base.crt_aead;
@@ -419,6 +335,12 @@ static int aead_set_sh_desc(struct crypto_aead *aead)
 	struct program prg;
 	struct program *p = &prg;
 	unsigned desc_bytes;
+	LABEL(skip_key_load);
+	REFERENCE(pskip_key_load);
+	LABEL(set_dk);
+	REFERENCE(pset_dk);
+	LABEL(skip_dk);
+	REFERENCE(pskip_dk);
 
 	if (!ctx->authsize)
 		return 0;
@@ -442,7 +364,24 @@ static int aead_set_sh_desc(struct crypto_aead *aead)
 	if (ps)
 		PROGRAM_SET_36BIT_ADDR(p);
 
-	init_sh_desc_key_aead(p, ctx, keys_fit_inline);
+	SHR_HDR(p, SHR_SERIAL, 1, 0);
+
+	/* Skip key loading if already shared */
+	pskip_key_load = JUMP(p, skip_key_load, LOCAL_JUMP, ALL_TRUE, SHRD);
+
+	if (keys_fit_inline) {
+		KEY(p, MDHA_SPLIT_KEY, ENC, (uintptr_t)ctx->key,
+		    ctx->split_key_len, IMMED | COPY);
+		KEY(p, KEY1, 0, (uintptr_t)(ctx->key + ctx->split_key_pad_len),
+		    ctx->enckeylen, IMMED | COPY);
+	} else {
+		KEY(p, MDHA_SPLIT_KEY, ENC, ctx->key_dma, ctx->split_key_len,
+		    0);
+		KEY(p, KEY1, 0, ctx->key_dma + ctx->split_key_pad_len,
+		    ctx->enckeylen, 0);
+	}
+
+	SET_LABEL(p, skip_key_load);
 
 	/* Class 2 operation */
 	ALG_OPERATION(p, ctx->class2_alg_type & OP_ALG_ALGSEL_MASK,
@@ -460,7 +399,10 @@ static int aead_set_sh_desc(struct crypto_aead *aead)
 
 	/* read assoc before reading payload */
 	SEQFIFOLOAD(p, MSG2, 0 , VLF);
-	aead_append_ld_iv(p, tfm->ivsize);
+
+	/* read iv for both classes */
+	SEQLOAD(p, CONTEXT1, 0, tfm->ivsize, 0);
+	MOVE(p, CONTEXT1, 0, IFIFOAB2, 0, tfm->ivsize, IMMED);
 
 	/* Class 1 operation */
 	ALG_OPERATION(p, ctx->class1_alg_type & OP_ALG_ALGSEL_MASK,
@@ -478,6 +420,8 @@ static int aead_set_sh_desc(struct crypto_aead *aead)
 	/* Write ICV */
 	SEQSTORE(p, CONTEXT2, 0, ctx->authsize, 0);
 
+	PATCH_JUMP(p, pskip_key_load, skip_key_load);
+
 	PROGRAM_FINALIZE(p);
 
 	desc_bytes = DESC_BYTES(desc);
@@ -508,7 +452,25 @@ static int aead_set_sh_desc(struct crypto_aead *aead)
 	if (ps)
 		PROGRAM_SET_36BIT_ADDR(p);
 
-	init_sh_desc_key_aead(p, ctx, keys_fit_inline);
+	/* aead_decrypt shared descriptor */
+	SHR_HDR(p, SHR_SERIAL, 1, 0);
+
+	/* Skip key loading if already shared */
+	pskip_key_load = JUMP(p, skip_key_load, LOCAL_JUMP, ALL_TRUE, SHRD);
+
+	if (keys_fit_inline) {
+		KEY(p, MDHA_SPLIT_KEY, ENC, (uintptr_t)ctx->key,
+		    ctx->split_key_len, IMMED | COPY);
+		KEY(p, KEY1, 0, (uintptr_t)(ctx->key + ctx->split_key_pad_len),
+		    ctx->enckeylen, IMMED | COPY);
+	} else {
+		KEY(p, MDHA_SPLIT_KEY, ENC, ctx->key_dma, ctx->split_key_len,
+		    0);
+		KEY(p, KEY1, 0, ctx->key_dma + ctx->split_key_pad_len,
+		    ctx->enckeylen, 0);
+	}
+
+	SET_LABEL(p, skip_key_load);
 
 	/* Class 2 operation */
 	ALG_OPERATION(p, ctx->class2_alg_type & OP_ALG_ALGSEL_MASK,
@@ -525,9 +487,28 @@ static int aead_set_sh_desc(struct crypto_aead *aead)
 	/* read assoc before reading payload */
 	SEQFIFOLOAD(p, MSG2, 0 , VLF);
 
-	aead_append_ld_iv(p, tfm->ivsize);
-
-	append_dec_op1(p, ctx->class1_alg_type);
+	/* read iv for both classes */
+	SEQLOAD(p, CONTEXT1, 0, tfm->ivsize, 0);
+	MOVE(p, CONTEXT1, 0, IFIFOAB2, 0, tfm->ivsize, IMMED);
+
+	/* Set DK bit in class 1 operation if shared (AES only) */
+	if ((ctx->class1_alg_type & OP_ALG_ALGSEL_MASK) == OP_ALG_ALGSEL_AES) {
+		pset_dk = JUMP(p, set_dk, LOCAL_JUMP, ALL_TRUE, SHRD);
+		ALG_OPERATION(p, ctx->class1_alg_type & OP_ALG_ALGSEL_MASK,
+			      ctx->class1_alg_type & OP_ALG_AAI_MASK,
+			      OP_ALG_AS_INITFINAL, ICV_CHECK_DISABLE, DIR_DEC);
+		pskip_dk = JUMP(p, skip_dk, LOCAL_JUMP, ALL_TRUE, 0);
+		SET_LABEL(p, set_dk);
+		ALG_OPERATION(p, ctx->class1_alg_type & OP_ALG_ALGSEL_MASK,
+			      (ctx->class1_alg_type & OP_ALG_AAI_MASK) |
+			       OP_ALG_AAI_DK, OP_ALG_AS_INITFINAL,
+			      ICV_CHECK_DISABLE, DIR_DEC);
+		SET_LABEL(p, skip_dk);
+	} else {
+		ALG_OPERATION(p, ctx->class1_alg_type & OP_ALG_ALGSEL_MASK,
+			      ctx->class1_alg_type & OP_ALG_AAI_MASK,
+			      OP_ALG_AS_INITFINAL, ICV_CHECK_DISABLE, DIR_DEC);
+	}
 
 	/* Read and write cryptlen bytes */
 	MATHB(p, ZERO, ADD, MATH2, VSEQINSZ, CAAM_CMD_SZ, 0);
@@ -540,6 +521,10 @@ static int aead_set_sh_desc(struct crypto_aead *aead)
 	/* Load ICV */
 	SEQFIFOLOAD(p, ICV2, ctx->authsize, LAST2);
 
+	PATCH_JUMP(p, pskip_key_load, skip_key_load);
+	PATCH_JUMP(p, pset_dk, set_dk);
+	PATCH_JUMP(p, pskip_dk, skip_dk);
+
 	PROGRAM_FINALIZE(p);
 
 	desc_bytes = DESC_BYTES(desc);
@@ -570,7 +555,25 @@ static int aead_set_sh_desc(struct crypto_aead *aead)
 	if (ps)
 		PROGRAM_SET_36BIT_ADDR(p);
 
-	init_sh_desc_key_aead(p, ctx, keys_fit_inline);
+	SHR_HDR(p, SHR_SERIAL, 1, 0);
+
+	/* Skip key loading if already shared */
+	pskip_key_load = JUMP(p, skip_key_load, LOCAL_JUMP, ALL_TRUE, SHRD);
+
+	if (keys_fit_inline) {
+		KEY(p, MDHA_SPLIT_KEY, ENC, (uintptr_t)ctx->key,
+		    ctx->split_key_len, IMMED | COPY);
+		KEY(p, KEY1, 0,
+		    (uintptr_t)(ctx->key + ctx->split_key_pad_len),
+		    ctx->enckeylen, IMMED | COPY);
+	} else {
+		KEY(p, MDHA_SPLIT_KEY, ENC, ctx->key_dma, ctx->split_key_len,
+		    0);
+		KEY(p, KEY1, 0, ctx->key_dma + ctx->split_key_pad_len,
+		    ctx->enckeylen, 0);
+	}
+
+	SET_LABEL(p, skip_key_load);
 
 	/* Generate IV */
 	geniv = NFIFOENTRY_STYPE_PAD | NFIFOENTRY_DEST_DECO |
@@ -625,6 +628,8 @@ static int aead_set_sh_desc(struct crypto_aead *aead)
 	/* Write ICV */
 	SEQSTORE(p, CONTEXT2, 0, ctx->authsize, 0);
 
+	PATCH_JUMP(p, pskip_key_load, skip_key_load);
+
 	PROGRAM_FINALIZE(p);
 
 	desc_bytes = DESC_BYTES(desc);
@@ -735,8 +740,12 @@ static int ablkcipher_setkey(struct crypto_ablkcipher *ablkcipher,
 	struct program prg;
 	struct program *p = &prg;
 	unsigned desc_bytes;
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
@@ -759,13 +768,14 @@ static int ablkcipher_setkey(struct crypto_ablkcipher *ablkcipher,
 		PROGRAM_SET_36BIT_ADDR(p);
 
 	SHR_HDR(p, SHR_SERIAL, 1, 0);
-	/* Skip if already shared */
-	pkey_jump_cmd = JUMP(p, key_jump_cmd, LOCAL_JUMP, ALL_TRUE, SHRD);
+
+	/* Skip key loading if already shared */
+	pskip_key_load = JUMP(p, skip_key_load, LOCAL_JUMP, ALL_TRUE, SHRD);
 
 	/* Load class1 key only */
 	KEY(p, KEY1, 0, (uintptr_t)ctx->key, ctx->enckeylen, IMMED | COPY);
 
-	SET_LABEL(p, key_jump_cmd);
+	SET_LABEL(p, skip_key_load);
 
 	/* Load IV */
 	SEQLOAD(p, CONTEXT1, 0, tfm->ivsize, 0);
@@ -776,9 +786,12 @@ static int ablkcipher_setkey(struct crypto_ablkcipher *ablkcipher,
 		      OP_ALG_AS_INITFINAL, ICV_CHECK_DISABLE, DIR_ENC);
 
 	/* Perform operation */
-	ablkcipher_append_src_dst(p);
+	MATHB(p, SEQINSZ, ADD, MATH0, VSEQOUTSZ, 4, 0);
+	MATHB(p, SEQINSZ, ADD, MATH0, VSEQINSZ, 4, 0);
+	SEQFIFOLOAD(p, MSG1, 0, VLF | LAST1);
+	SEQFIFOSTORE(p, MSG, 0, 0, VLF);
 
-	PATCH_JUMP(p, pkey_jump_cmd, key_jump_cmd);
+	PATCH_JUMP(p, pskip_key_load, skip_key_load);
 
 	PROGRAM_FINALIZE(p);
 
@@ -803,24 +816,45 @@ static int ablkcipher_setkey(struct crypto_ablkcipher *ablkcipher,
 
 	SHR_HDR(p, SHR_SERIAL, 1, 0);
 
-	/* Skip if already shared */
-	pkey_jump_cmd = JUMP(p, key_jump_cmd, LOCAL_JUMP, ALL_TRUE, SHRD);
+	/* Skip key loading if already shared */
+	pskip_key_load = JUMP(p, skip_key_load, LOCAL_JUMP, ALL_TRUE, SHRD);
 
 	/* Load class1 key only */
 	KEY(p, KEY1, 0, (uintptr_t)ctx->key, ctx->enckeylen, IMMED | COPY);
 
-	SET_LABEL(p, key_jump_cmd);
+	SET_LABEL(p, skip_key_load);
 
 	/* load IV */
 	SEQLOAD(p, CONTEXT1, 0, tfm->ivsize, 0);
 
-	/* Choose operation */
-	append_dec_op1(p, ctx->class1_alg_type);
+	/* Set DK bit in class 1 operation if shared (AES only) */
+	if ((ctx->class1_alg_type & OP_ALG_ALGSEL_MASK) == OP_ALG_ALGSEL_AES) {
+		pset_dk = JUMP(p, set_dk, LOCAL_JUMP, ALL_TRUE, SHRD);
+		ALG_OPERATION(p, ctx->class1_alg_type & OP_ALG_ALGSEL_MASK,
+			      ctx->class1_alg_type & OP_ALG_AAI_MASK,
+			      OP_ALG_AS_INITFINAL, ICV_CHECK_DISABLE, DIR_DEC);
+		pskip_dk = JUMP(p, skip_dk, LOCAL_JUMP, ALL_TRUE, 0);
+		SET_LABEL(p, set_dk);
+		ALG_OPERATION(p, ctx->class1_alg_type & OP_ALG_ALGSEL_MASK,
+			      (ctx->class1_alg_type & OP_ALG_AAI_MASK) |
+			       OP_ALG_AAI_DK, OP_ALG_AS_INITFINAL,
+			      ICV_CHECK_DISABLE, DIR_DEC);
+		SET_LABEL(p, skip_dk);
+	} else {
+		ALG_OPERATION(p, ctx->class1_alg_type & OP_ALG_ALGSEL_MASK,
+			      ctx->class1_alg_type & OP_ALG_AAI_MASK,
+			      OP_ALG_AS_INITFINAL, ICV_CHECK_DISABLE, DIR_DEC);
+	}
 
 	/* Perform operation */
-	ablkcipher_append_src_dst(p);
+	MATHB(p, SEQINSZ, ADD, MATH0, VSEQOUTSZ, 4, 0);
+	MATHB(p, SEQINSZ, ADD, MATH0, VSEQINSZ, 4, 0);
+	SEQFIFOLOAD(p, MSG1, 0, VLF | LAST1);
+	SEQFIFOSTORE(p, MSG, 0, 0, VLF);
 
-	PATCH_JUMP(p, pkey_jump_cmd, key_jump_cmd);
+	PATCH_JUMP(p, pskip_key_load, skip_key_load);
+	PATCH_JUMP(p, pset_dk, set_dk);
+	PATCH_JUMP(p, pskip_dk, skip_dk);
 
 	PROGRAM_FINALIZE(p);
 
diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index 529e3ca92406..0e5d7ef33ff8 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -137,36 +137,6 @@ struct caam_hash_state {
 
 /* Common job descriptor seq in/out ptr routines */
 
-/* Map state->caam_ctx, and append seq_out_ptr command that points to it */
-static inline int map_seq_out_ptr_ctx(struct program *p, struct device *jrdev,
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
-	SEQOUTPTR(p, state->ctx_dma, ctx_len, EXT);
-
-	return 0;
-}
-
-/* Map req->result, and append seq_out_ptr command that points to it */
-static inline dma_addr_t map_seq_out_ptr_result(struct program *p,
-						struct device *jrdev,
-						u8 *result, int digestsize)
-{
-	dma_addr_t dst_dma;
-
-	dst_dma = dma_map_single(jrdev, result, digestsize, DMA_FROM_DEVICE);
-	SEQOUTPTR(p, dst_dma, digestsize, EXT);
-
-	return dst_dma;
-}
-
 /* Map current buffer in state and put it in link table */
 static inline dma_addr_t buf_map_to_sec4_sg(struct device *jrdev,
 					    struct sec4_sg_entry *sec4_sg,
@@ -225,64 +195,46 @@ static inline int ctx_map_to_sec4_sg(u32 *desc, struct device *jrdev,
 	return 0;
 }
 
-/* Common shared descriptor commands */
-static inline void append_key_ahash(struct program *p,
-				    struct caam_hash_ctx *ctx)
+/*
+ * For ahash update, final and finup (import_ctx = true)
+ *     import context, read and write to seqout
+ * For ahash firsts and digest (import_ctx = false)
+ *     read and write to seqout
+ */
+static inline void ahash_gen_sh_desc(u32 *desc, u32 state, int digestsize,
+				     struct caam_hash_ctx *ctx, bool import_ctx)
 {
-	KEY(p, MDHA_SPLIT_KEY, ENC, (uintptr_t)ctx->key,
-	    ctx->split_key_len, IMMED | COPY);
-}
+	u32 op = ctx->alg_type;
+	struct program prg;
+	struct program *p = &prg;
+	LABEL(skip_key_load);
+	REFERENCE(pskip_key_load);
 
-/* Append key if it has been set */
-static inline void init_sh_desc_key_ahash(struct program *p,
-					  struct caam_hash_ctx *ctx)
-{
-	LABEL(key_jump_cmd);
-	REFERENCE(pkey_jump_cmd);
+	PROGRAM_CNTXT_INIT(p, desc, 0);
+	if (ps)
+		PROGRAM_SET_36BIT_ADDR(p);
 
 	SHR_HDR(p, SHR_SERIAL, 1, 0);
 
-	if (ctx->split_key_len) {
-		/* Skip if already shared */
-		pkey_jump_cmd = JUMP(p, key_jump_cmd, LOCAL_JUMP, ALL_TRUE,
-				     SHRD);
+	/* Append key if it has been set; ahash update excluded */
+	if ((state != OP_ALG_AS_UPDATE) && (ctx->split_key_len)) {
+		/* Skip key loading if already shared */
+		pskip_key_load = JUMP(p, skip_key_load, LOCAL_JUMP, ALL_TRUE,
+				      SHRD);
 
-		append_key_ahash(p, ctx);
+		KEY(p, MDHA_SPLIT_KEY, ENC, (uintptr_t)ctx->key,
+		    ctx->split_key_len, IMMED | COPY);
 
-		SET_LABEL(p, key_jump_cmd);
+		SET_LABEL(p, skip_key_load);
 
-		PATCH_JUMP(p, pkey_jump_cmd, key_jump_cmd);
-	}
-}
+		PATCH_JUMP(p, pskip_key_load, skip_key_load);
 
-/*
- * For ahash read data from seqin following state->caam_ctx,
- * and write resulting class2 context to seqout, which may be state->caam_ctx
- * or req->result
- */
-static inline void ahash_append_load_str(struct program *p, int digestsize)
-{
-	/* Calculate remaining bytes to read */
-	MATHB(p, SEQINSZ, ADD, MATH0, VSEQINSZ, CAAM_CMD_SZ, 0);
-
-	/* Read remaining bytes */
-	SEQFIFOLOAD(p, MSG2, 0, VLF | LAST2);
-
-	/* Store class2 context bytes */
-	SEQSTORE(p, CONTEXT2, 0, digestsize, 0);
-}
-
-/*
- * For ahash update, final and finup, import context, read and write to seqout
- */
-static inline void ahash_ctx_data_to_out(struct program *p, u32 op, u32 state,
-					 int digestsize,
-					 struct caam_hash_ctx *ctx)
-{
-	init_sh_desc_key_ahash(p, ctx);
+		op |= OP_ALG_AAI_HMAC_PRECOMP;
+	}
 
-	/* Import context from software */
-	SEQLOAD(p, CONTEXT2, 0, ctx->ctx_len, 0);
+	/* If needed, import context from software */
+	if (import_ctx)
+		SEQLOAD(p, CONTEXT2, 0, ctx->ctx_len, 0);
 
 	/* Class 2 operation */
 	ALG_OPERATION(p, op & OP_ALG_ALGSEL_MASK, op & OP_ALG_AAI_MASK, state,
@@ -290,24 +242,15 @@ static inline void ahash_ctx_data_to_out(struct program *p, u32 op, u32 state,
 
 	/*
 	 * Load from buf and/or src and write to req->result or state->context
+	 * Calculate remaining bytes to read
 	 */
-	ahash_append_load_str(p, digestsize);
-}
-
-/* For ahash firsts and digest, read and write to seqout */
-static inline void ahash_data_to_out(struct program *p, u32 op, u32 state,
-				     int digestsize, struct caam_hash_ctx *ctx)
-{
-	init_sh_desc_key_ahash(p, ctx);
-
-	/* Class 2 operation */
-	ALG_OPERATION(p, op & OP_ALG_ALGSEL_MASK, op & OP_ALG_AAI_MASK, state,
-		      ICV_CHECK_DISABLE, DIR_ENC);
+	MATHB(p, SEQINSZ, ADD, MATH0, VSEQINSZ, CAAM_CMD_SZ, 0);
+	/* Read remaining bytes */
+	SEQFIFOLOAD(p, MSG2, 0, VLF | LAST2);
+	/* Store class2 context bytes */
+	SEQSTORE(p, CONTEXT2, 0, digestsize, 0);
 
-	/*
-	 * Load from buf and/or src and write to req->result or state->context
-	 */
-	ahash_append_load_str(p, digestsize);
+	PROGRAM_FINALIZE(p);
 }
 
 static int ahash_set_sh_desc(struct crypto_ahash *ahash)
@@ -315,35 +258,11 @@ static int ahash_set_sh_desc(struct crypto_ahash *ahash)
 	struct caam_hash_ctx *ctx = crypto_ahash_ctx(ahash);
 	int digestsize = crypto_ahash_digestsize(ahash);
 	struct device *jrdev = ctx->jrdev;
-	u32 have_key = 0;
 	u32 *desc;
-	struct program prg;
-	struct program *p = &prg;
-
-	if (ctx->split_key_len)
-		have_key = OP_ALG_AAI_HMAC_PRECOMP;
 
 	/* ahash_update shared descriptor */
 	desc = ctx->sh_desc_update;
-	PROGRAM_CNTXT_INIT(p, desc, 0);
-	if (ps)
-		PROGRAM_SET_36BIT_ADDR(p);
-
-	SHR_HDR(p, SHR_SERIAL, 1, 0);
-
-	/* Import context from software */
-	SEQLOAD(p, CONTEXT2, 0, ctx->ctx_len, 0);
-
-	/* Class 2 operation */
-	ALG_OPERATION(p, ctx->alg_type & OP_ALG_ALGSEL_MASK,
-		      ctx->alg_type & OP_ALG_AAI_MASK, OP_ALG_AS_UPDATE,
-		      ICV_CHECK_DISABLE, DIR_ENC);
-
-	/* Load data and write to result or context */
-	ahash_append_load_str(p, ctx->ctx_len);
-
-	PROGRAM_FINALIZE(p);
-
+	ahash_gen_sh_desc(desc, OP_ALG_AS_UPDATE, ctx->ctx_len, ctx, true);
 	ctx->sh_desc_update_dma = dma_map_single(jrdev, desc, DESC_BYTES(desc),
 						 DMA_TO_DEVICE);
 	if (dma_mapping_error(jrdev, ctx->sh_desc_update_dma)) {
@@ -358,15 +277,7 @@ static int ahash_set_sh_desc(struct crypto_ahash *ahash)
 
 	/* ahash_update_first shared descriptor */
 	desc = ctx->sh_desc_update_first;
-	PROGRAM_CNTXT_INIT(p, desc, 0);
-	if (ps)
-		PROGRAM_SET_36BIT_ADDR(p);
-
-	ahash_data_to_out(p, have_key | ctx->alg_type, OP_ALG_AS_INIT,
-			  ctx->ctx_len, ctx);
-
-	PROGRAM_FINALIZE(p);
-
+	ahash_gen_sh_desc(desc,  OP_ALG_AS_INIT, ctx->ctx_len, ctx, false);
 	ctx->sh_desc_update_first_dma = dma_map_single(jrdev, desc,
 						       DESC_BYTES(desc),
 						       DMA_TO_DEVICE);
@@ -382,15 +293,7 @@ static int ahash_set_sh_desc(struct crypto_ahash *ahash)
 
 	/* ahash_final shared descriptor */
 	desc = ctx->sh_desc_fin;
-	PROGRAM_CNTXT_INIT(p, desc, 0);
-	if (ps)
-		PROGRAM_SET_36BIT_ADDR(p);
-
-	ahash_ctx_data_to_out(p, have_key | ctx->alg_type, OP_ALG_AS_FINALIZE,
-			      digestsize, ctx);
-
-	PROGRAM_FINALIZE(p);
-
+	ahash_gen_sh_desc(desc, OP_ALG_AS_FINALIZE, digestsize, ctx, true);
 	ctx->sh_desc_fin_dma = dma_map_single(jrdev, desc, DESC_BYTES(desc),
 					      DMA_TO_DEVICE);
 	if (dma_mapping_error(jrdev, ctx->sh_desc_fin_dma)) {
@@ -404,15 +307,7 @@ static int ahash_set_sh_desc(struct crypto_ahash *ahash)
 
 	/* ahash_finup shared descriptor */
 	desc = ctx->sh_desc_finup;
-	PROGRAM_CNTXT_INIT(p, desc, 0);
-	if (ps)
-		PROGRAM_SET_36BIT_ADDR(p);
-
-	ahash_ctx_data_to_out(p, have_key | ctx->alg_type, OP_ALG_AS_FINALIZE,
-			      digestsize, ctx);
-
-	PROGRAM_FINALIZE(p);
-
+	ahash_gen_sh_desc(desc, OP_ALG_AS_FINALIZE, digestsize, ctx, true);
 	ctx->sh_desc_finup_dma = dma_map_single(jrdev, desc, DESC_BYTES(desc),
 						DMA_TO_DEVICE);
 	if (dma_mapping_error(jrdev, ctx->sh_desc_finup_dma)) {
@@ -426,15 +321,7 @@ static int ahash_set_sh_desc(struct crypto_ahash *ahash)
 
 	/* ahash_digest shared descriptor */
 	desc = ctx->sh_desc_digest;
-	PROGRAM_CNTXT_INIT(p, desc, 0);
-	if (ps)
-		PROGRAM_SET_36BIT_ADDR(p);
-
-	ahash_data_to_out(p, have_key | ctx->alg_type, OP_ALG_AS_INITFINAL,
-			  digestsize, ctx);
-
-	PROGRAM_FINALIZE(p);
-
+	ahash_gen_sh_desc(desc, OP_ALG_AS_INITFINAL, digestsize, ctx, false);
 	ctx->sh_desc_digest_dma = dma_map_single(jrdev, desc, DESC_BYTES(desc),
 						 DMA_TO_DEVICE);
 	if (dma_mapping_error(jrdev, ctx->sh_desc_digest_dma)) {
@@ -891,7 +778,6 @@ static int ahash_update_ctx(struct ahash_request *req)
 		SEQINPTR(p, edesc->sec4_sg_dma, ctx->ctx_len + to_hash,
 			 SGF | EXT);
 		SEQOUTPTR(p, state->ctx_dma, ctx->ctx_len, EXT);
-
 		PROGRAM_FINALIZE(p);
 
 #ifdef DEBUG
@@ -956,17 +842,17 @@ static int ahash_final_ctx(struct ahash_request *req)
 		return -ENOMEM;
 	}
 
-	sh_len = DESC_LEN(sh_desc);
 	desc = edesc->hw_desc;
-	PROGRAM_CNTXT_INIT(p, desc, sh_len);
-	if (ps)
-		PROGRAM_SET_36BIT_ADDR(p);
-
-	JOB_HDR(p, SHR_DEFER, sh_len, ptr, REO | SHR);
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
@@ -979,6 +865,12 @@ static int ahash_final_ctx(struct ahash_request *req)
 						last_buflen);
 	(edesc->sec4_sg + sec4_sg_bytes - 1)->len |= SEC4_SG_LEN_FIN;
 
+	sh_len = DESC_LEN(sh_desc);
+	PROGRAM_CNTXT_INIT(p, desc, sh_len);
+	if (ps)
+		PROGRAM_SET_36BIT_ADDR(p);
+	JOB_HDR(p, SHR_DEFER, sh_len, ptr, REO | SHR);
+
 	edesc->sec4_sg_dma = dma_map_single(jrdev, edesc->sec4_sg,
 					    sec4_sg_bytes, DMA_TO_DEVICE);
 	if (dma_mapping_error(jrdev, edesc->sec4_sg_dma)) {
@@ -987,14 +879,7 @@ static int ahash_final_ctx(struct ahash_request *req)
 	}
 
 	SEQINPTR(p, edesc->sec4_sg_dma, ctx->ctx_len + buflen, SGF | EXT);
-
-	edesc->dst_dma = map_seq_out_ptr_result(p, jrdev, req->result,
-						digestsize);
-	if (dma_mapping_error(jrdev, edesc->dst_dma)) {
-		dev_err(jrdev, "unable to map dst\n");
-		return -ENOMEM;
-	}
-
+	SEQOUTPTR(p, edesc->dst_dma, digestsize, EXT);
 	PROGRAM_FINALIZE(p);
 
 #ifdef DEBUG
@@ -1050,19 +935,18 @@ static int ahash_finup_ctx(struct ahash_request *req)
 		return -ENOMEM;
 	}
 
-	sh_len = DESC_LEN(sh_desc);
 	desc = edesc->hw_desc;
-	PROGRAM_CNTXT_INIT(p, desc, sh_len);
-	if (ps)
-		PROGRAM_SET_36BIT_ADDR(p);
-
-	JOB_HDR(p, SHR_DEFER, sh_len, ptr, REO | SHR);
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
@@ -1076,6 +960,12 @@ static int ahash_finup_ctx(struct ahash_request *req)
 	src_map_to_sec4_sg(jrdev, req->src, src_nents, edesc->sec4_sg +
 			   sec4_sg_src_index, chained);
 
+	sh_len = DESC_LEN(sh_desc);
+	PROGRAM_CNTXT_INIT(p, desc, sh_len);
+	if (ps)
+		PROGRAM_SET_36BIT_ADDR(p);
+	JOB_HDR(p, SHR_DEFER, sh_len, ptr, REO | SHR);
+
 	edesc->sec4_sg_dma = dma_map_single(jrdev, edesc->sec4_sg,
 					    sec4_sg_bytes, DMA_TO_DEVICE);
 	if (dma_mapping_error(jrdev, edesc->sec4_sg_dma)) {
@@ -1085,14 +975,7 @@ static int ahash_finup_ctx(struct ahash_request *req)
 
 	SEQINPTR(p, edesc->sec4_sg_dma, ctx->ctx_len + buflen + req->nbytes,
 		 SGF | EXT);
-
-	edesc->dst_dma = map_seq_out_ptr_result(p, jrdev, req->result,
-						digestsize);
-	if (dma_mapping_error(jrdev, edesc->dst_dma)) {
-		dev_err(jrdev, "unable to map dst\n");
-		return -ENOMEM;
-	}
-
+	SEQOUTPTR(p, edesc->dst_dma, digestsize, EXT);
 	PROGRAM_FINALIZE(p);
 
 #ifdef DEBUG
@@ -1146,17 +1029,16 @@ static int ahash_digest(struct ahash_request *req)
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
-	PROGRAM_CNTXT_INIT(p, desc, sh_len);
-	if (ps)
-		PROGRAM_SET_36BIT_ADDR(p);
-
-	JOB_HDR(p, SHR_DEFER, sh_len, ptr, REO | SHR);
-
 	if (src_nents) {
 		sg_to_sec4_sg_last(req->src, src_nents, edesc->sec4_sg, 0);
 		edesc->sec4_sg_dma = dma_map_single(jrdev, edesc->sec4_sg,
@@ -1170,15 +1052,14 @@ static int ahash_digest(struct ahash_request *req)
 	} else {
 		src_dma = sg_dma_address(req->src);
 	}
-	SEQINPTR(p, src_dma, req->nbytes, options);
-
-	edesc->dst_dma = map_seq_out_ptr_result(p, jrdev, req->result,
-						digestsize);
-	if (dma_mapping_error(jrdev, edesc->dst_dma)) {
-		dev_err(jrdev, "unable to map dst\n");
-		return -ENOMEM;
-	}
 
+	sh_len = DESC_LEN(sh_desc);
+	PROGRAM_CNTXT_INIT(p, desc, sh_len);
+	if (ps)
+		PROGRAM_SET_36BIT_ADDR(p);
+	JOB_HDR(p, SHR_DEFER, sh_len, ptr, REO | SHR);
+	SEQINPTR(p, src_dma, req->nbytes, options);
+	SEQOUTPTR(p, edesc->dst_dma, digestsize, EXT);
 	PROGRAM_FINALIZE(p);
 
 #ifdef DEBUG
@@ -1225,33 +1106,30 @@ static int ahash_final_no_ctx(struct ahash_request *req)
 		return -ENOMEM;
 	}
 
-	sh_len = DESC_LEN(sh_desc);
+	edesc->src_nents = 0;
 	desc = edesc->hw_desc;
-	PROGRAM_CNTXT_INIT(p, desc, sh_len);
-	if (ps)
-		PROGRAM_SET_36BIT_ADDR(p);
-
-	JOB_HDR(p, SHR_DEFER, sh_len, ptr, REO | SHR);
-
 	state->buf_dma = dma_map_single(jrdev, buf, buflen, DMA_TO_DEVICE);
 	if (dma_mapping_error(jrdev, state->buf_dma)) {
 		dev_err(jrdev, "unable to map src\n");
 		return -ENOMEM;
 	}
 
-	SEQINPTR(p, state->buf_dma, buflen, EXT);
-
-	edesc->dst_dma = map_seq_out_ptr_result(p, jrdev, req->result,
-						digestsize);
+	edesc->dst_dma = dma_map_single(jrdev, req->result, digestsize,
+					DMA_FROM_DEVICE);
 	if (dma_mapping_error(jrdev, edesc->dst_dma)) {
 		dev_err(jrdev, "unable to map dst\n");
 		return -ENOMEM;
 	}
 
+	sh_len = DESC_LEN(sh_desc);
+	PROGRAM_CNTXT_INIT(p, desc, sh_len);
+	if (ps)
+		PROGRAM_SET_36BIT_ADDR(p);
+	JOB_HDR(p, SHR_DEFER, sh_len, ptr, REO | SHR);
+	SEQINPTR(p, state->buf_dma, buflen, EXT);
+	SEQOUTPTR(p, edesc->dst_dma, digestsize, EXT);
 	PROGRAM_FINALIZE(p);
 
-	edesc->src_nents = 0;
-
 #ifdef DEBUG
 	print_hex_dump(KERN_ERR, "jobdesc@"__stringify(__LINE__)": ",
 		       DUMP_PREFIX_ADDRESS, 16, 4, desc, DESC_BYTES(desc), 1);
@@ -1314,6 +1192,7 @@ static int ahash_update_no_ctx(struct ahash_request *req)
 			return -ENOMEM;
 		}
 
+		desc = edesc->hw_desc;
 		edesc->src_nents = src_nents;
 		edesc->chained = chained;
 		edesc->sec4_sg_bytes = sec4_sg_bytes;
@@ -1331,12 +1210,17 @@ static int ahash_update_no_ctx(struct ahash_request *req)
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
 		PROGRAM_CNTXT_INIT(p, desc, sh_len);
 		if (ps)
 			PROGRAM_SET_36BIT_ADDR(p);
-
 		JOB_HDR(p, SHR_DEFER, sh_len, ptr, REO | SHR);
 
 		edesc->sec4_sg_dma = dma_map_single(jrdev, edesc->sec4_sg,
@@ -1348,11 +1232,7 @@ static int ahash_update_no_ctx(struct ahash_request *req)
 		}
 
 		SEQINPTR(p, edesc->sec4_sg_dma, to_hash, SGF | EXT);
-
-		ret = map_seq_out_ptr_ctx(p, jrdev, state, ctx->ctx_len);
-		if (ret)
-			return ret;
-
+		SEQOUTPTR(p, state->ctx_dma, ctx->ctx_len, EXT);
 		PROGRAM_FINALIZE(p);
 
 #ifdef DEBUG
@@ -1425,19 +1305,18 @@ static int ahash_finup_no_ctx(struct ahash_request *req)
 		return -ENOMEM;
 	}
 
-	sh_len = DESC_LEN(sh_desc);
 	desc = edesc->hw_desc;
-	PROGRAM_CNTXT_INIT(p, desc, sh_len);
-	if (ps)
-		PROGRAM_SET_36BIT_ADDR(p);
-
-	JOB_HDR(p, SHR_DEFER, sh_len, ptr, REO | SHR);
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
@@ -1446,6 +1325,12 @@ static int ahash_finup_no_ctx(struct ahash_request *req)
 	src_map_to_sec4_sg(jrdev, req->src, src_nents, edesc->sec4_sg + 1,
 			   chained);
 
+	sh_len = DESC_LEN(sh_desc);
+	PROGRAM_CNTXT_INIT(p, desc, sh_len);
+	if (ps)
+		PROGRAM_SET_36BIT_ADDR(p);
+	JOB_HDR(p, SHR_DEFER, sh_len, ptr, REO | SHR);
+
 	edesc->sec4_sg_dma = dma_map_single(jrdev, edesc->sec4_sg,
 					    sec4_sg_bytes, DMA_TO_DEVICE);
 	if (dma_mapping_error(jrdev, edesc->sec4_sg_dma)) {
@@ -1454,14 +1339,7 @@ static int ahash_finup_no_ctx(struct ahash_request *req)
 	}
 
 	SEQINPTR(p, edesc->sec4_sg_dma, buflen + req->nbytes, SGF | EXT);
-
-	edesc->dst_dma = map_seq_out_ptr_result(p, jrdev, req->result,
-						digestsize);
-	if (dma_mapping_error(jrdev, edesc->dst_dma)) {
-		dev_err(jrdev, "unable to map dst\n");
-		return -ENOMEM;
-	}
-
+	SEQOUTPTR(p, edesc->dst_dma, digestsize, EXT);
 	PROGRAM_FINALIZE(p);
 
 #ifdef DEBUG
@@ -1528,12 +1406,19 @@ static int ahash_update_first(struct ahash_request *req)
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
@@ -1556,19 +1441,12 @@ static int ahash_update_first(struct ahash_request *req)
 			sg_copy_part(next_buf, req->src, to_hash, req->nbytes);
 
 		sh_len = DESC_LEN(sh_desc);
-		desc = edesc->hw_desc;
 		PROGRAM_CNTXT_INIT(p, desc, sh_len);
 		if (ps)
 			PROGRAM_SET_36BIT_ADDR(p);
-
 		JOB_HDR(p, SHR_DEFER, sh_len, ptr, REO | SHR);
-
 		SEQINPTR(p, src_dma, to_hash, options);
-
-		ret = map_seq_out_ptr_ctx(p, jrdev, state, ctx->ctx_len);
-		if (ret)
-			return ret;
-
+		SEQOUTPTR(p, state->ctx_dma, ctx->ctx_len, EXT);
 		PROGRAM_FINALIZE(p);
 
 #ifdef DEBUG
-- 
1.8.3.1
