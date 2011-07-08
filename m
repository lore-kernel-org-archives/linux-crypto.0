From: Kim Phillips <kim.phillips@freescale.com>
Subject: [PATCH 7/8] crypto: caam - faster aead implementation
Date: Fri, 8 Jul 2011 17:57:28 -0500
Message-ID: <1310165849-22177-7-git-send-email-kim.phillips@freescale.com>
References: <1310165849-22177-1-git-send-email-kim.phillips@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Yuan Kang <Yuan.Kang@freescale.com>,
	Kim Phillips <kim.phillips@freescale.com>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:49768
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752512Ab1GHW6d (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 8 Jul 2011 18:58:33 -0400
Received: from mail146-va3 (localhost.localdomain [127.0.0.1])	by
 mail146-va3-R.bigfish.com (Postfix) with ESMTP id 24E6C3B84C7	for
 <linux-crypto@vger.kernel.org>; Fri,  8 Jul 2011 22:58:32 +0000 (UTC)
Received: from VA3EHSMHS016.bigfish.com (unknown [10.7.14.237])	by
 mail146-va3.bigfish.com (Postfix) with ESMTP id 7C4054A0046	for
 <linux-crypto@vger.kernel.org>; Fri,  8 Jul 2011 22:58:18 +0000 (UTC)
In-Reply-To: <1310165849-22177-1-git-send-email-kim.phillips@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Yuan Kang <Yuan.Kang@freescale.com>

Job descriptors only contain header and seq pointers.

Other commands are stored in separate shared descriptors
for encrypt, decrypt and givencrypt, stored as arrays
in caam_ctx.

This requires additional macros to create math commands
to calculate assoclen and cryptlen.

Signed-off-by: Yuan Kang <Yuan.Kang@freescale.com>
Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
---
 drivers/crypto/caam/caamalg.c     | 1104 ++++++++++++++++++++++++++-----------
 drivers/crypto/caam/desc_constr.h |   58 ++-
 2 files changed, 832 insertions(+), 330 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index 403b293..ed7d59d 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -62,10 +62,16 @@
 #define CAAM_MAX_IV_LENGTH		16
 
 /* length of descriptors text */
-#define DESC_AEAD_SHARED_TEXT_LEN	4
-#define DESC_AEAD_ENCRYPT_TEXT_LEN 	21
-#define DESC_AEAD_DECRYPT_TEXT_LEN 	24
-#define DESC_AEAD_GIVENCRYPT_TEXT_LEN 	27
+#define DESC_JOB_IO_LEN			(CAAM_CMD_SZ * 3 + CAAM_PTR_SZ * 3)
+
+#define DESC_AEAD_BASE			(4 * CAAM_CMD_SZ)
+#define DESC_AEAD_ENC_LEN		(DESC_AEAD_BASE + 16 * CAAM_CMD_SZ)
+#define DESC_AEAD_DEC_LEN		(DESC_AEAD_BASE + 21 * CAAM_CMD_SZ)
+#define DESC_AEAD_GIVENC_LEN		(DESC_AEAD_ENC_LEN + 7 * CAAM_CMD_SZ)
+
+#define DESC_MAX_USED_BYTES		(DESC_AEAD_GIVENC_LEN + \
+					 CAAM_MAX_KEY_SIZE)
+#define DESC_MAX_USED_LEN		(DESC_MAX_USED_BYTES / CAAM_CMD_SZ)
 
 #ifdef DEBUG
 /* for print_hex_dumps with line references */
@@ -76,17 +82,77 @@
 #define debug(format, arg...)
 #endif
 
+/* Set DK bit in class 1 operation if shared */
+static inline void append_dec_op1(u32 *desc, u32 type)
+{
+	u32 *jump_cmd, *uncond_jump_cmd;
+
+	jump_cmd = append_jump(desc, JUMP_TEST_ALL | JUMP_COND_SHRD);
+	append_operation(desc, type | OP_ALG_AS_INITFINAL |
+			 OP_ALG_DECRYPT);
+	uncond_jump_cmd = append_jump(desc, JUMP_TEST_ALL);
+	set_jump_tgt_here(desc, jump_cmd);
+	append_operation(desc, type | OP_ALG_AS_INITFINAL |
+			 OP_ALG_DECRYPT | OP_ALG_AAI_DK);
+	set_jump_tgt_here(desc, uncond_jump_cmd);
+}
+
+/*
+ * Wait for completion of class 1 key loading before allowing
+ * error propagation
+ */
+static inline void append_dec_shr_done(u32 *desc)
+{
+	u32 *jump_cmd;
+
+	jump_cmd = append_jump(desc, JUMP_CLASS_CLASS1 | JUMP_TEST_ALL);
+	set_jump_tgt_here(desc, jump_cmd);
+	append_cmd(desc, SET_OK_PROP_ERRORS | CMD_LOAD);
+}
+
+/*
+ * For aead functions, read payload and write payload,
+ * both of which are specified in req->src and req->dst
+ */
+static inline void aead_append_src_dst(u32 *desc, u32 msg_type)
+{
+	append_seq_fifo_load(desc, 0, FIFOLD_CLASS_BOTH |
+			     KEY_VLF | msg_type | FIFOLD_TYPE_LASTBOTH);
+	append_seq_fifo_store(desc, 0, FIFOST_TYPE_MESSAGE_DATA | KEY_VLF);
+}
+
+/*
+ * For aead encrypt and decrypt, read iv for both classes
+ */
+static inline void aead_append_ld_iv(u32 *desc, int ivsize)
+{
+	append_cmd(desc, CMD_SEQ_LOAD | LDST_SRCDST_BYTE_CONTEXT |
+		   LDST_CLASS_1_CCB | ivsize);
+	append_move(desc, MOVE_SRC_CLASS1CTX | MOVE_DEST_CLASS2INFIFO | ivsize);
+}
+
+/*
+ * If all data, including src (with assoc and iv) or dst (with iv only) are
+ * contiguous
+ */
+#define GIV_SRC_CONTIG		1
+#define GIV_DST_CONTIG		(1 << 1)
+
 /*
  * per-session context
  */
 struct caam_ctx {
 	struct device *jrdev;
-	u32 *sh_desc;
-	dma_addr_t shared_desc_phys;
+	u32 sh_desc_enc[DESC_MAX_USED_LEN];
+	u32 sh_desc_dec[DESC_MAX_USED_LEN];
+	u32 sh_desc_givenc[DESC_MAX_USED_LEN];
+	dma_addr_t sh_desc_enc_dma;
+	dma_addr_t sh_desc_dec_dma;
+	dma_addr_t sh_desc_givenc_dma;
 	u32 class1_alg_type;
 	u32 class2_alg_type;
 	u32 alg_op;
-	u8 *key;
+	u8 key[CAAM_MAX_KEY_SIZE];
 	dma_addr_t key_dma;
 	unsigned int enckeylen;
 	unsigned int split_key_len;
@@ -94,12 +160,275 @@ struct caam_ctx {
 	unsigned int authsize;
 };
 
+static void append_key_aead(u32 *desc, struct caam_ctx *ctx,
+			    int keys_fit_inline)
+{
+	if (keys_fit_inline) {
+		append_key_as_imm(desc, ctx->key, ctx->split_key_pad_len,
+				  ctx->split_key_len, CLASS_2 |
+				  KEY_DEST_MDHA_SPLIT | KEY_ENC);
+		append_key_as_imm(desc, (void *)ctx->key +
+				  ctx->split_key_pad_len, ctx->enckeylen,
+				  ctx->enckeylen, CLASS_1 | KEY_DEST_CLASS_REG);
+	} else {
+		append_key(desc, ctx->key_dma, ctx->split_key_len, CLASS_2 |
+			   KEY_DEST_MDHA_SPLIT | KEY_ENC);
+		append_key(desc, ctx->key_dma + ctx->split_key_pad_len,
+			   ctx->enckeylen, CLASS_1 | KEY_DEST_CLASS_REG);
+	}
+}
+
+static void init_sh_desc_key_aead(u32 *desc, struct caam_ctx *ctx,
+				  int keys_fit_inline)
+{
+	u32 *key_jump_cmd;
+
+	init_sh_desc(desc, HDR_SHARE_WAIT);
+
+	/* Skip if already shared */
+	key_jump_cmd = append_jump(desc, JUMP_JSL | JUMP_TEST_ALL |
+				   JUMP_COND_SHRD);
+
+	append_key_aead(desc, ctx, keys_fit_inline);
+
+	set_jump_tgt_here(desc, key_jump_cmd);
+
+	/* Propagate errors from shared to job descriptor */
+	append_cmd(desc, SET_OK_PROP_ERRORS | CMD_LOAD);
+}
+
+static int aead_set_sh_desc(struct crypto_aead *aead)
+{
+	struct aead_tfm *tfm = &aead->base.crt_aead;
+	struct caam_ctx *ctx = crypto_aead_ctx(aead);
+	struct device *jrdev = ctx->jrdev;
+	bool keys_fit_inline = 0;
+	u32 *key_jump_cmd, *jump_cmd;
+	u32 geniv, moveiv;
+	u32 *desc;
+
+	if (!ctx->enckeylen || !ctx->authsize)
+		return 0;
+
+	/*
+	 * Job Descriptor and Shared Descriptors
+	 * must all fit into the 64-word Descriptor h/w Buffer
+	 */
+	if (DESC_AEAD_ENC_LEN + DESC_JOB_IO_LEN +
+	    ctx->split_key_pad_len + ctx->enckeylen <=
+	    CAAM_DESC_BYTES_MAX)
+		keys_fit_inline = 1;
+
+	/* aead_encrypt shared descriptor */
+	desc = ctx->sh_desc_enc;
+
+	init_sh_desc_key_aead(desc, ctx, keys_fit_inline);
+
+	/* Class 2 operation */
+	append_operation(desc, ctx->class2_alg_type |
+			 OP_ALG_AS_INITFINAL | OP_ALG_ENCRYPT);
+
+	/* cryptlen = seqoutlen - authsize */
+	append_math_sub_imm_u32(desc, REG3, SEQOUTLEN, IMM, ctx->authsize);
+
+	/* assoclen + cryptlen = seqinlen - ivsize */
+	append_math_sub_imm_u32(desc, REG2, SEQINLEN, IMM, tfm->ivsize);
+
+	/* assoclen + cryptlen = (assoclen + cryptlen) - cryptlen */
+	append_math_sub(desc, VARSEQINLEN, REG2, REG3, CAAM_CMD_SZ);
+
+	/* read assoc before reading payload */
+	append_seq_fifo_load(desc, 0, FIFOLD_CLASS_CLASS2 | FIFOLD_TYPE_MSG |
+			     KEY_VLF);
+	aead_append_ld_iv(desc, tfm->ivsize);
+
+	/* Class 1 operation */
+	append_operation(desc, ctx->class1_alg_type |
+			 OP_ALG_AS_INITFINAL | OP_ALG_ENCRYPT);
+
+	/* Read and write cryptlen bytes */
+	append_math_add(desc, VARSEQINLEN, ZERO, REG3, CAAM_CMD_SZ);
+	append_math_add(desc, VARSEQOUTLEN, ZERO, REG3, CAAM_CMD_SZ);
+	aead_append_src_dst(desc, FIFOLD_TYPE_MSG1OUT2);
+
+	/* Write ICV */
+	append_seq_store(desc, ctx->authsize, LDST_CLASS_2_CCB |
+			 LDST_SRCDST_BYTE_CONTEXT);
+
+	ctx->sh_desc_enc_dma = dma_map_single(jrdev, desc,
+					      desc_bytes(desc),
+					      DMA_TO_DEVICE);
+	if (dma_mapping_error(jrdev, ctx->sh_desc_enc_dma)) {
+		dev_err(jrdev, "unable to map shared descriptor\n");
+		return -ENOMEM;
+	}
+#ifdef DEBUG
+	print_hex_dump(KERN_ERR, "aead enc shdesc@"xstr(__LINE__)": ",
+		       DUMP_PREFIX_ADDRESS, 16, 4, desc,
+		       desc_bytes(desc), 1);
+#endif
+
+	/*
+	 * Job Descriptor and Shared Descriptors
+	 * must all fit into the 64-word Descriptor h/w Buffer
+	 */
+	if (DESC_AEAD_DEC_LEN + DESC_JOB_IO_LEN +
+	    ctx->split_key_pad_len + ctx->enckeylen <=
+	    CAAM_DESC_BYTES_MAX)
+		keys_fit_inline = 1;
+
+	desc = ctx->sh_desc_dec;
+
+	/* aead_decrypt shared descriptor */
+	init_sh_desc(desc, HDR_SHARE_WAIT);
+
+	/* Skip if already shared */
+	key_jump_cmd = append_jump(desc, JUMP_JSL | JUMP_TEST_ALL |
+				   JUMP_COND_SHRD);
+
+	append_key_aead(desc, ctx, keys_fit_inline);
+
+	/* Only propagate error immediately if shared */
+	jump_cmd = append_jump(desc, JUMP_TEST_ALL);
+	set_jump_tgt_here(desc, key_jump_cmd);
+	append_cmd(desc, SET_OK_PROP_ERRORS | CMD_LOAD);
+	set_jump_tgt_here(desc, jump_cmd);
+
+	/* Class 2 operation */
+	append_operation(desc, ctx->class2_alg_type |
+			 OP_ALG_AS_INITFINAL | OP_ALG_DECRYPT | OP_ALG_ICV_ON);
+
+	/* assoclen + cryptlen = seqinlen - ivsize */
+	append_math_sub_imm_u32(desc, REG3, SEQINLEN, IMM,
+				ctx->authsize + tfm->ivsize)
+	/* assoclen = (assoclen + cryptlen) - cryptlen */
+	append_math_sub(desc, REG2, SEQOUTLEN, REG0, CAAM_CMD_SZ);
+	append_math_sub(desc, VARSEQINLEN, REG3, REG2, CAAM_CMD_SZ);
+
+	/* read assoc before reading payload */
+	append_seq_fifo_load(desc, 0, FIFOLD_CLASS_CLASS2 | FIFOLD_TYPE_MSG |
+			     KEY_VLF);
+
+	aead_append_ld_iv(desc, tfm->ivsize);
+
+	append_dec_op1(desc, ctx->class1_alg_type);
+
+	/* Read and write cryptlen bytes */
+	append_math_add(desc, VARSEQINLEN, ZERO, REG2, CAAM_CMD_SZ);
+	append_math_add(desc, VARSEQOUTLEN, ZERO, REG2, CAAM_CMD_SZ);
+	aead_append_src_dst(desc, FIFOLD_TYPE_MSG);
+
+	/* Load ICV */
+	append_seq_fifo_load(desc, ctx->authsize, FIFOLD_CLASS_CLASS2 |
+			     FIFOLD_TYPE_LAST2 | FIFOLD_TYPE_ICV);
+	append_dec_shr_done(desc);
+
+	ctx->sh_desc_dec_dma = dma_map_single(jrdev, desc,
+					      desc_bytes(desc),
+					      DMA_TO_DEVICE);
+	if (dma_mapping_error(jrdev, ctx->sh_desc_dec_dma)) {
+		dev_err(jrdev, "unable to map shared descriptor\n");
+		return -ENOMEM;
+	}
+#ifdef DEBUG
+	print_hex_dump(KERN_ERR, "aead dec shdesc@"xstr(__LINE__)": ",
+		       DUMP_PREFIX_ADDRESS, 16, 4, desc,
+		       desc_bytes(desc), 1);
+#endif
+
+	/*
+	 * Job Descriptor and Shared Descriptors
+	 * must all fit into the 64-word Descriptor h/w Buffer
+	 */
+	if (DESC_AEAD_GIVENC_LEN + DESC_JOB_IO_LEN +
+	    ctx->split_key_pad_len + ctx->enckeylen <=
+	    CAAM_DESC_BYTES_MAX)
+		keys_fit_inline = 1;
+
+	/* aead_givencrypt shared descriptor */
+	desc = ctx->sh_desc_givenc;
+
+	init_sh_desc_key_aead(desc, ctx, keys_fit_inline);
+
+	/* Generate IV */
+	geniv = NFIFOENTRY_STYPE_PAD | NFIFOENTRY_DEST_DECO |
+		NFIFOENTRY_DTYPE_MSG | NFIFOENTRY_LC1 |
+		NFIFOENTRY_PTYPE_RND | (tfm->ivsize << NFIFOENTRY_DLEN_SHIFT);
+	append_load_imm_u32(desc, geniv, LDST_CLASS_IND_CCB |
+			    LDST_SRCDST_WORD_INFO_FIFO | LDST_IMM);
+	append_cmd(desc, CMD_LOAD | DISABLE_AUTO_INFO_FIFO);
+	append_move(desc, MOVE_SRC_INFIFO |
+		    MOVE_DEST_CLASS1CTX | (tfm->ivsize << MOVE_LEN_SHIFT));
+	append_cmd(desc, CMD_LOAD | ENABLE_AUTO_INFO_FIFO);
+
+	/* Copy IV to class 1 context */
+	append_move(desc, MOVE_SRC_CLASS1CTX |
+		    MOVE_DEST_OUTFIFO | (tfm->ivsize << MOVE_LEN_SHIFT));
+
+	/* Return to encryption */
+	append_operation(desc, ctx->class2_alg_type |
+			 OP_ALG_AS_INITFINAL | OP_ALG_ENCRYPT);
+
+	/* ivsize + cryptlen = seqoutlen - authsize */
+	append_math_sub_imm_u32(desc, REG3, SEQOUTLEN, IMM, ctx->authsize);
+
+	/* assoclen = seqinlen - (ivsize + cryptlen) */
+	append_math_sub(desc, VARSEQINLEN, SEQINLEN, REG3, CAAM_CMD_SZ);
+
+	/* read assoc before reading payload */
+	append_seq_fifo_load(desc, 0, FIFOLD_CLASS_CLASS2 | FIFOLD_TYPE_MSG |
+			     KEY_VLF);
+
+	/* Copy iv from class 1 ctx to class 2 fifo*/
+	moveiv = NFIFOENTRY_STYPE_OFIFO | NFIFOENTRY_DEST_CLASS2 |
+		 NFIFOENTRY_DTYPE_MSG | (tfm->ivsize << NFIFOENTRY_DLEN_SHIFT);
+	append_load_imm_u32(desc, moveiv, LDST_CLASS_IND_CCB |
+			    LDST_SRCDST_WORD_INFO_FIFO | LDST_IMM);
+	append_load_imm_u32(desc, tfm->ivsize, LDST_CLASS_2_CCB |
+			    LDST_SRCDST_WORD_DATASZ_REG | LDST_IMM);
+
+	/* Class 1 operation */
+	append_operation(desc, ctx->class1_alg_type |
+			 OP_ALG_AS_INITFINAL | OP_ALG_ENCRYPT);
+
+	/* Will write ivsize + cryptlen */
+	append_math_add(desc, VARSEQOUTLEN, SEQINLEN, REG0, CAAM_CMD_SZ);
+
+	/* Not need to reload iv */
+	append_seq_fifo_load(desc, tfm->ivsize,
+			     FIFOLD_CLASS_SKIP);
+
+	/* Will read cryptlen */
+	append_math_add(desc, VARSEQINLEN, SEQINLEN, REG0, CAAM_CMD_SZ);
+	aead_append_src_dst(desc, FIFOLD_TYPE_MSG1OUT2);
+
+	/* Write ICV */
+	append_seq_store(desc, ctx->authsize, LDST_CLASS_2_CCB |
+			 LDST_SRCDST_BYTE_CONTEXT);
+
+	ctx->sh_desc_givenc_dma = dma_map_single(jrdev, desc,
+						 desc_bytes(desc),
+						 DMA_TO_DEVICE);
+	if (dma_mapping_error(jrdev, ctx->sh_desc_givenc_dma)) {
+		dev_err(jrdev, "unable to map shared descriptor\n");
+		return -ENOMEM;
+	}
+#ifdef DEBUG
+	print_hex_dump(KERN_ERR, "aead givenc shdesc@"xstr(__LINE__)": ",
+		       DUMP_PREFIX_ADDRESS, 16, 4, desc,
+		       desc_bytes(desc), 1);
+#endif
+
+	return 0;
+}
+
 static int aead_setauthsize(struct crypto_aead *authenc,
 				    unsigned int authsize)
 {
 	struct caam_ctx *ctx = crypto_aead_ctx(authenc);
 
 	ctx->authsize = authsize;
+	aead_set_sh_desc(authenc);
 
 	return 0;
 }
@@ -117,6 +446,7 @@ static void split_key_done(struct device *dev, u32 *desc, u32 err,
 #ifdef DEBUG
 	dev_err(dev, "%s %d: err 0x%x\n", __func__, __LINE__, err);
 #endif
+
 	if (err) {
 		char tmp[CAAM_ERROR_STR_MAX];
 
@@ -220,72 +550,6 @@ static u32 gen_split_key(struct caam_ctx *ctx, const u8 *key_in, u32 authkeylen)
 	return ret;
 }
 
-static int build_sh_desc_ipsec(struct caam_ctx *ctx)
-{
-	struct device *jrdev = ctx->jrdev;
-	u32 *sh_desc;
-	u32 *jump_cmd;
-	bool keys_fit_inline = 0;
-
-	/*
-	 * largest Job Descriptor and its Shared Descriptor
-	 * must both fit into the 64-word Descriptor h/w Buffer
-	 */
-	if ((DESC_AEAD_GIVENCRYPT_TEXT_LEN +
-	     DESC_AEAD_SHARED_TEXT_LEN) * CAAM_CMD_SZ +
-	    ctx->split_key_pad_len + ctx->enckeylen <= CAAM_DESC_BYTES_MAX)
-		keys_fit_inline = 1;
-
-	/* build shared descriptor for this session */
-	sh_desc = kmalloc(CAAM_CMD_SZ * DESC_AEAD_SHARED_TEXT_LEN +
-			  (keys_fit_inline ?
-			   ctx->split_key_pad_len + ctx->enckeylen :
-			   CAAM_PTR_SZ * 2), GFP_DMA | GFP_KERNEL);
-	if (!sh_desc) {
-		dev_err(jrdev, "could not allocate shared descriptor\n");
-		return -ENOMEM;
-	}
-
-	init_sh_desc(sh_desc, HDR_SAVECTX | HDR_SHARE_SERIAL);
-
-	jump_cmd = append_jump(sh_desc, CLASS_BOTH | JUMP_TEST_ALL |
-			       JUMP_COND_SHRD | JUMP_COND_SELF);
-
-	/*
-	 * process keys, starting with class 2/authentication.
-	 */
-	if (keys_fit_inline) {
-		append_key_as_imm(sh_desc, ctx->key, ctx->split_key_pad_len,
-				  ctx->split_key_len,
-				  CLASS_2 | KEY_DEST_MDHA_SPLIT | KEY_ENC);
-
-		append_key_as_imm(sh_desc, (void *)ctx->key +
-				  ctx->split_key_pad_len, ctx->enckeylen,
-				  ctx->enckeylen, CLASS_1 | KEY_DEST_CLASS_REG);
-	} else {
-		append_key(sh_desc, ctx->key_dma, ctx->split_key_len, CLASS_2 |
-			   KEY_DEST_MDHA_SPLIT | KEY_ENC);
-		append_key(sh_desc, ctx->key_dma + ctx->split_key_pad_len,
-			   ctx->enckeylen, CLASS_1 | KEY_DEST_CLASS_REG);
-	}
-
-	/* update jump cmd now that we are at the jump target */
-	set_jump_tgt_here(sh_desc, jump_cmd);
-
-	ctx->shared_desc_phys = dma_map_single(jrdev, sh_desc,
-					       desc_bytes(sh_desc),
-					       DMA_TO_DEVICE);
-	if (dma_mapping_error(jrdev, ctx->shared_desc_phys)) {
-		dev_err(jrdev, "unable to map shared descriptor\n");
-		kfree(sh_desc);
-		return -ENOMEM;
-	}
-
-	ctx->sh_desc = sh_desc;
-
-	return 0;
-}
-
 static int aead_setkey(struct crypto_aead *aead,
 			       const u8 *key, unsigned int keylen)
 {
@@ -326,16 +590,9 @@ static int aead_setkey(struct crypto_aead *aead,
 	print_hex_dump(KERN_ERR, "key in @"xstr(__LINE__)": ",
 		       DUMP_PREFIX_ADDRESS, 16, 4, key, keylen, 1);
 #endif
-	ctx->key = kmalloc(ctx->split_key_pad_len + enckeylen,
-			   GFP_KERNEL | GFP_DMA);
-	if (!ctx->key) {
-		dev_err(jrdev, "could not allocate key output memory\n");
-		return -ENOMEM;
-	}
 
 	ret = gen_split_key(ctx, key, authkeylen);
 	if (ret) {
-		kfree(ctx->key);
 		goto badkey;
 	}
 
@@ -346,7 +603,6 @@ static int aead_setkey(struct crypto_aead *aead,
 				       enckeylen, DMA_TO_DEVICE);
 	if (dma_mapping_error(jrdev, ctx->key_dma)) {
 		dev_err(jrdev, "unable to map key i/o memory\n");
-		kfree(ctx->key);
 		return -ENOMEM;
 	}
 #ifdef DEBUG
@@ -357,11 +613,10 @@ static int aead_setkey(struct crypto_aead *aead,
 
 	ctx->enckeylen = enckeylen;
 
-	ret = build_sh_desc_ipsec(ctx);
+	ret = aead_set_sh_desc(aead);
 	if (ret) {
 		dma_unmap_single(jrdev, ctx->key_dma, ctx->split_key_pad_len +
 				 enckeylen, DMA_TO_DEVICE);
-		kfree(ctx->key);
 	}
 
 	return ret;
@@ -379,10 +634,11 @@ struct link_tbl_entry {
 };
 
 /*
- * aead_edesc - s/w-extended ipsec_esp descriptor
+ * aead_edesc - s/w-extended aead descriptor
+ * @assoc_nents: number of segments in associated data (SPI+Seq) scatterlist
  * @src_nents: number of segments in input scatterlist
  * @dst_nents: number of segments in output scatterlist
- * @assoc_nents: number of segments in associated data (SPI+Seq) scatterlist
+ * @iv_dma: dma address of iv for checking continuity and link table
  * @desc: h/w descriptor (variable length; must not exceed MAX_CAAM_DESCSIZE)
  * @link_tbl_bytes: length of dma mapped link_tbl space
  * @link_tbl_dma: bus physical mapped address of h/w link table
@@ -392,37 +648,47 @@ struct aead_edesc {
 	int assoc_nents;
 	int src_nents;
 	int dst_nents;
+	dma_addr_t iv_dma;
 	int link_tbl_bytes;
 	dma_addr_t link_tbl_dma;
 	struct link_tbl_entry *link_tbl;
 	u32 hw_desc[0];
 };
 
-static void aead_unmap(struct device *dev,
-			    struct aead_edesc *edesc,
-			    struct aead_request *req)
+static void caam_unmap(struct device *dev, struct scatterlist *src,
+		       struct scatterlist *dst, int src_nents, int dst_nents,
+		       dma_addr_t iv_dma, int ivsize, dma_addr_t link_tbl_dma,
+		       int link_tbl_bytes)
 {
-	dma_unmap_sg(dev, req->assoc, edesc->assoc_nents, DMA_TO_DEVICE);
-
-	if (unlikely(req->dst != req->src)) {
-		dma_unmap_sg(dev, req->src, edesc->src_nents,
-			     DMA_TO_DEVICE);
-		dma_unmap_sg(dev, req->dst, edesc->dst_nents,
-			     DMA_FROM_DEVICE);
+	if (unlikely(dst != src)) {
+		dma_unmap_sg(dev, src, src_nents, DMA_TO_DEVICE);
+		dma_unmap_sg(dev, dst, dst_nents, DMA_FROM_DEVICE);
 	} else {
-		dma_unmap_sg(dev, req->src, edesc->src_nents,
-			     DMA_BIDIRECTIONAL);
+		dma_unmap_sg(dev, src, src_nents, DMA_BIDIRECTIONAL);
 	}
 
-	if (edesc->link_tbl_bytes)
-		dma_unmap_single(dev, edesc->link_tbl_dma,
-				 edesc->link_tbl_bytes,
+	if (iv_dma)
+		dma_unmap_single(dev, iv_dma, ivsize, DMA_TO_DEVICE);
+	if (link_tbl_bytes)
+		dma_unmap_single(dev, link_tbl_dma, link_tbl_bytes,
 				 DMA_TO_DEVICE);
 }
 
-/*
- * ipsec_esp descriptor callbacks
- */
+static void aead_unmap(struct device *dev,
+		       struct aead_edesc *edesc,
+		       struct aead_request *req)
+{
+	struct crypto_aead *aead = crypto_aead_reqtfm(req);
+	int ivsize = crypto_aead_ivsize(aead);
+
+	dma_unmap_sg(dev, req->assoc, edesc->assoc_nents, DMA_TO_DEVICE);
+
+	caam_unmap(dev, req->src, req->dst,
+		   edesc->src_nents, edesc->dst_nents,
+		   edesc->iv_dma, ivsize, edesc->link_tbl_dma,
+		   edesc->link_tbl_bytes);
+}
+
 static void aead_encrypt_done(struct device *jrdev, u32 *desc, u32 err,
 				   void *context)
 {
@@ -430,11 +696,12 @@ static void aead_encrypt_done(struct device *jrdev, u32 *desc, u32 err,
 	struct aead_edesc *edesc;
 #ifdef DEBUG
 	struct crypto_aead *aead = crypto_aead_reqtfm(req);
-	int ivsize = crypto_aead_ivsize(aead);
 	struct caam_ctx *ctx = crypto_aead_ctx(aead);
+	int ivsize = crypto_aead_ivsize(aead);
 
 	dev_err(jrdev, "%s %d: err 0x%x\n", __func__, __LINE__, err);
 #endif
+
 	edesc = (struct aead_edesc *)((char *)desc -
 		 offsetof(struct aead_edesc, hw_desc));
 
@@ -472,12 +739,23 @@ static void aead_decrypt_done(struct device *jrdev, u32 *desc, u32 err,
 #ifdef DEBUG
 	struct crypto_aead *aead = crypto_aead_reqtfm(req);
 	struct caam_ctx *ctx = crypto_aead_ctx(aead);
+	int ivsize = crypto_aead_ivsize(aead);
 
 	dev_err(jrdev, "%s %d: err 0x%x\n", __func__, __LINE__, err);
 #endif
+
 	edesc = (struct aead_edesc *)((char *)desc -
 		 offsetof(struct aead_edesc, hw_desc));
 
+#ifdef DEBUG
+	print_hex_dump(KERN_ERR, "dstiv  @"xstr(__LINE__)": ",
+		       DUMP_PREFIX_ADDRESS, 16, 4, req->iv,
+		       ivsize, 1);
+	print_hex_dump(KERN_ERR, "dst    @"xstr(__LINE__)": ",
+		       DUMP_PREFIX_ADDRESS, 16, 4, sg_virt(req->dst),
+		       req->cryptlen, 1);
+#endif
+
 	if (err) {
 		char tmp[CAAM_ERROR_STR_MAX];
 
@@ -506,241 +784,271 @@ static void aead_decrypt_done(struct device *jrdev, u32 *desc, u32 err,
 			sg->length + ctx->authsize + 16, 1);
 	}
 #endif
+
 	kfree(edesc);
 
 	aead_request_complete(req, err);
 }
 
+static void sg_to_link_tbl_one(struct link_tbl_entry *link_tbl_ptr,
+			       dma_addr_t dma, u32 len, u32 offset)
+{
+	link_tbl_ptr->ptr = dma;
+	link_tbl_ptr->len = len;
+	link_tbl_ptr->reserved = 0;
+	link_tbl_ptr->buf_pool_id = 0;
+	link_tbl_ptr->offset = offset;
+#ifdef DEBUG
+	print_hex_dump(KERN_ERR, "link_tbl_ptr@"xstr(__LINE__)": ",
+		       DUMP_PREFIX_ADDRESS, 16, 4, link_tbl_ptr,
+		       sizeof(struct link_tbl_entry), 1);
+#endif
+}
+
 /*
  * convert scatterlist to h/w link table format
- * scatterlist must have been previously dma mapped
+ * but does not have final bit; instead, returns last entry
  */
-static void sg_to_link_tbl(struct scatterlist *sg, int sg_count,
-			   struct link_tbl_entry *link_tbl_ptr, u32 offset)
+static struct link_tbl_entry *sg_to_link_tbl(struct scatterlist *sg,
+					     int sg_count, struct link_tbl_entry
+					     *link_tbl_ptr, u32 offset)
 {
 	while (sg_count) {
-		link_tbl_ptr->ptr = sg_dma_address(sg);
-		link_tbl_ptr->len = sg_dma_len(sg);
-		link_tbl_ptr->reserved = 0;
-		link_tbl_ptr->buf_pool_id = 0;
-		link_tbl_ptr->offset = offset;
+		sg_to_link_tbl_one(link_tbl_ptr, sg_dma_address(sg),
+				   sg_dma_len(sg), offset);
 		link_tbl_ptr++;
 		sg = sg_next(sg);
 		sg_count--;
 	}
+	return link_tbl_ptr - 1;
+}
 
-	/* set Final bit (marks end of link table) */
-	link_tbl_ptr--;
+/*
+ * convert scatterlist to h/w link table format
+ * scatterlist must have been previously dma mapped
+ */
+static void sg_to_link_tbl_last(struct scatterlist *sg, int sg_count,
+				struct link_tbl_entry *link_tbl_ptr, u32 offset)
+{
+	link_tbl_ptr = sg_to_link_tbl(sg, sg_count, link_tbl_ptr, offset);
 	link_tbl_ptr->len |= 0x40000000;
 }
 
 /*
- * fill in and submit ipsec_esp job descriptor
+ * Fill in aead job descriptor
  */
-static int init_aead_job(struct aead_edesc *edesc, struct aead_request *req,
-		     u32 encrypt,
-		     void (*callback) (struct device *dev, u32 *desc,
-				       u32 err, void *context))
+static void init_aead_job(u32 *sh_desc, dma_addr_t ptr,
+			  struct aead_edesc *edesc,
+			  struct aead_request *req,
+			  bool all_contig, bool encrypt)
 {
 	struct crypto_aead *aead = crypto_aead_reqtfm(req);
 	struct caam_ctx *ctx = crypto_aead_ctx(aead);
-	struct device *jrdev = ctx->jrdev;
-	u32 *desc = edesc->hw_desc, options;
-	int ret, sg_count, assoc_sg_count;
 	int ivsize = crypto_aead_ivsize(aead);
 	int authsize = ctx->authsize;
-	dma_addr_t ptr, dst_dma, src_dma;
-#ifdef DEBUG
-	u32 *sh_desc = ctx->sh_desc;
+	u32 *desc = edesc->hw_desc;
+	u32 out_options = 0, in_options;
+	dma_addr_t dst_dma, src_dma;
+	int len, link_tbl_index = 0;
 
+#ifdef DEBUG
 	debug("assoclen %d cryptlen %d authsize %d\n",
 	      req->assoclen, req->cryptlen, authsize);
 	print_hex_dump(KERN_ERR, "assoc  @"xstr(__LINE__)": ",
 		       DUMP_PREFIX_ADDRESS, 16, 4, sg_virt(req->assoc),
 		       req->assoclen , 1);
 	print_hex_dump(KERN_ERR, "presciv@"xstr(__LINE__)": ",
-		       DUMP_PREFIX_ADDRESS, 16, 4, sg_virt(req->src) - ivsize,
+		       DUMP_PREFIX_ADDRESS, 16, 4, req->iv,
 		       edesc->src_nents ? 100 : ivsize, 1);
 	print_hex_dump(KERN_ERR, "src    @"xstr(__LINE__)": ",
 		       DUMP_PREFIX_ADDRESS, 16, 4, sg_virt(req->src),
-			edesc->src_nents ? 100 : req->cryptlen + authsize, 1);
+			edesc->src_nents ? 100 : req->cryptlen, 1);
 	print_hex_dump(KERN_ERR, "shrdesc@"xstr(__LINE__)": ",
 		       DUMP_PREFIX_ADDRESS, 16, 4, sh_desc,
 		       desc_bytes(sh_desc), 1);
 #endif
-	assoc_sg_count = dma_map_sg(jrdev, req->assoc, edesc->assoc_nents ?: 1,
-				    DMA_TO_DEVICE);
-	if (req->src == req->dst)
-		sg_count = dma_map_sg(jrdev, req->src, edesc->src_nents ? : 1,
-				      DMA_BIDIRECTIONAL);
-	else
-		sg_count = dma_map_sg(jrdev, req->src, edesc->src_nents ? : 1,
-				      DMA_TO_DEVICE);
 
-	/* start auth operation */
-	append_operation(desc, ctx->class2_alg_type | OP_ALG_AS_INITFINAL |
-			 (encrypt ? : OP_ALG_ICV_ON));
+	len = desc_len(sh_desc);
+	init_job_desc_shared(desc, ptr, len, HDR_SHARE_DEFER | HDR_REVERSE);
 
-	/* Load FIFO with data for Class 2 CHA */
-	options = FIFOLD_CLASS_CLASS2 | FIFOLD_TYPE_MSG;
-	if (!edesc->assoc_nents) {
-		ptr = sg_dma_address(req->assoc);
+	if (all_contig) {
+		src_dma = sg_dma_address(req->assoc);
+		in_options = 0;
 	} else {
-		sg_to_link_tbl(req->assoc, edesc->assoc_nents,
-			       edesc->link_tbl, 0);
-		ptr = edesc->link_tbl_dma;
-		options |= LDST_SGF;
+		src_dma = edesc->link_tbl_dma;
+		link_tbl_index += (edesc->assoc_nents ? : 1) + 1 +
+				  (edesc->src_nents ? : 1);
+		in_options = LDST_SGF;
 	}
-	append_fifo_load(desc, ptr, req->assoclen, options);
-
-	/* copy iv from cipher/class1 input context to class2 infifo */
-	append_move(desc, MOVE_SRC_CLASS1CTX | MOVE_DEST_CLASS2INFIFO | ivsize);
-
-	if (!encrypt) {
-		u32 *jump_cmd, *uncond_jump_cmd;
-
-		/* JUMP if shared */
-		jump_cmd = append_jump(desc, JUMP_TEST_ALL | JUMP_COND_SHRD);
-
-		/* start class 1 (cipher) operation, non-shared version */
-		append_operation(desc, ctx->class1_alg_type |
-				 OP_ALG_AS_INITFINAL);
-
-		uncond_jump_cmd = append_jump(desc, 0);
-
-		set_jump_tgt_here(desc, jump_cmd);
-
-		/* start class 1 (cipher) operation, shared version */
-		append_operation(desc, ctx->class1_alg_type |
-				 OP_ALG_AS_INITFINAL | OP_ALG_AAI_DK);
-		set_jump_tgt_here(desc, uncond_jump_cmd);
-	} else
-		append_operation(desc, ctx->class1_alg_type |
-				 OP_ALG_AS_INITFINAL | encrypt);
+	if (encrypt)
+		append_seq_in_ptr(desc, src_dma, req->assoclen + ivsize +
+				  req->cryptlen - authsize, in_options);
+	else
+		append_seq_in_ptr(desc, src_dma, req->assoclen + ivsize +
+				  req->cryptlen, in_options);
 
-	/* load payload & instruct to class2 to snoop class 1 if encrypting */
-	options = 0;
-	if (!edesc->src_nents) {
-		src_dma = sg_dma_address(req->src);
-	} else {
-		sg_to_link_tbl(req->src, edesc->src_nents, edesc->link_tbl +
-			       edesc->assoc_nents, 0);
-		src_dma = edesc->link_tbl_dma + edesc->assoc_nents *
-			  sizeof(struct link_tbl_entry);
-		options |= LDST_SGF;
-	}
-	append_seq_in_ptr(desc, src_dma, req->cryptlen + authsize, options);
-	append_seq_fifo_load(desc, req->cryptlen, FIFOLD_CLASS_BOTH |
-			     FIFOLD_TYPE_LASTBOTH |
-			     (encrypt ? FIFOLD_TYPE_MSG1OUT2
-				      : FIFOLD_TYPE_MSG));
-
-	/* specify destination */
-	if (req->src == req->dst) {
-		dst_dma = src_dma;
+	if (likely(req->src == req->dst)) {
+		if (all_contig) {
+			dst_dma = sg_dma_address(req->src);
+		} else {
+			dst_dma = src_dma + sizeof(struct link_tbl_entry) *
+				  ((edesc->assoc_nents ? : 1) + 1);
+			out_options = LDST_SGF;
+		}
 	} else {
-		sg_count = dma_map_sg(jrdev, req->dst, edesc->dst_nents ? : 1,
-				      DMA_FROM_DEVICE);
 		if (!edesc->dst_nents) {
 			dst_dma = sg_dma_address(req->dst);
-			options = 0;
 		} else {
-			sg_to_link_tbl(req->dst, edesc->dst_nents,
-				       edesc->link_tbl + edesc->assoc_nents +
-				       edesc->src_nents, 0);
-			dst_dma = edesc->link_tbl_dma + (edesc->assoc_nents +
-				  edesc->src_nents) *
+			dst_dma = edesc->link_tbl_dma +
+				  link_tbl_index *
 				  sizeof(struct link_tbl_entry);
-			options = LDST_SGF;
+			out_options = LDST_SGF;
 		}
 	}
-	append_seq_out_ptr(desc, dst_dma, req->cryptlen + authsize, options);
-	append_seq_fifo_store(desc, req->cryptlen, FIFOST_TYPE_MESSAGE_DATA);
-
-	/* ICV */
 	if (encrypt)
-		append_seq_store(desc, authsize, LDST_CLASS_2_CCB |
-				 LDST_SRCDST_BYTE_CONTEXT);
+		append_seq_out_ptr(desc, dst_dma, req->cryptlen, out_options);
 	else
-		append_seq_fifo_load(desc, authsize, FIFOLD_CLASS_CLASS2 |
-				     FIFOLD_TYPE_LAST2 | FIFOLD_TYPE_ICV);
+		append_seq_out_ptr(desc, dst_dma, req->cryptlen - authsize,
+				   out_options);
+}
+
+/*
+ * Fill in aead givencrypt job descriptor
+ */
+static void init_aead_giv_job(u32 *sh_desc, dma_addr_t ptr,
+			      struct aead_edesc *edesc,
+			      struct aead_request *req,
+			      int contig)
+{
+	struct crypto_aead *aead = crypto_aead_reqtfm(req);
+	struct caam_ctx *ctx = crypto_aead_ctx(aead);
+	int ivsize = crypto_aead_ivsize(aead);
+	int authsize = ctx->authsize;
+	u32 *desc = edesc->hw_desc;
+	u32 out_options = 0, in_options;
+	dma_addr_t dst_dma, src_dma;
+	int len, link_tbl_index = 0;
 
 #ifdef DEBUG
-	debug("job_desc_len %d\n", desc_len(desc));
-	print_hex_dump(KERN_ERR, "jobdesc@"xstr(__LINE__)": ",
-		       DUMP_PREFIX_ADDRESS, 16, 4, desc, desc_bytes(desc) , 1);
-	print_hex_dump(KERN_ERR, "jdlinkt@"xstr(__LINE__)": ",
-		       DUMP_PREFIX_ADDRESS, 16, 4, edesc->link_tbl,
-			edesc->link_tbl_bytes, 1);
+	debug("assoclen %d cryptlen %d authsize %d\n",
+	      req->assoclen, req->cryptlen, authsize);
+	print_hex_dump(KERN_ERR, "assoc  @"xstr(__LINE__)": ",
+		       DUMP_PREFIX_ADDRESS, 16, 4, sg_virt(req->assoc),
+		       req->assoclen , 1);
+	print_hex_dump(KERN_ERR, "presciv@"xstr(__LINE__)": ",
+		       DUMP_PREFIX_ADDRESS, 16, 4, req->iv, ivsize, 1);
+	print_hex_dump(KERN_ERR, "src    @"xstr(__LINE__)": ",
+		       DUMP_PREFIX_ADDRESS, 16, 4, sg_virt(req->src),
+			edesc->src_nents > 1 ? 100 : req->cryptlen, 1);
+	print_hex_dump(KERN_ERR, "shrdesc@"xstr(__LINE__)": ",
+		       DUMP_PREFIX_ADDRESS, 16, 4, sh_desc,
+		       desc_bytes(sh_desc), 1);
 #endif
 
-	ret = caam_jr_enqueue(jrdev, desc, callback, req);
-	if (!ret)
-		ret = -EINPROGRESS;
-	else {
-		aead_unmap(jrdev, edesc, req);
-		kfree(edesc);
+	len = desc_len(sh_desc);
+	init_job_desc_shared(desc, ptr, len, HDR_SHARE_DEFER | HDR_REVERSE);
+
+	if (contig & GIV_SRC_CONTIG) {
+		src_dma = sg_dma_address(req->assoc);
+		in_options = 0;
+	} else {
+		src_dma = edesc->link_tbl_dma;
+		link_tbl_index += edesc->assoc_nents + 1 + edesc->src_nents;
+		in_options = LDST_SGF;
 	}
+	append_seq_in_ptr(desc, src_dma, req->assoclen + ivsize +
+			  req->cryptlen - authsize, in_options);
 
-	return ret;
+	if (contig & GIV_DST_CONTIG) {
+		dst_dma = edesc->iv_dma;
+	} else {
+		if (likely(req->src == req->dst)) {
+			dst_dma = src_dma + sizeof(struct link_tbl_entry) *
+				  edesc->assoc_nents;
+			out_options = LDST_SGF;
+		} else {
+			dst_dma = edesc->link_tbl_dma +
+				  link_tbl_index *
+				  sizeof(struct link_tbl_entry);
+			out_options = LDST_SGF;
+		}
+	}
+
+	append_seq_out_ptr(desc, dst_dma, ivsize + req->cryptlen, out_options);
 }
 
 /*
  * derive number of elements in scatterlist
  */
-static int sg_count(struct scatterlist *sg_list, int nbytes, int *chained)
+static int sg_count(struct scatterlist *sg_list, int nbytes)
 {
 	struct scatterlist *sg = sg_list;
 	int sg_nents = 0;
 
-	*chained = 0;
 	while (nbytes > 0) {
 		sg_nents++;
 		nbytes -= sg->length;
 		if (!sg_is_last(sg) && (sg + 1)->length == 0)
-			*chained = 1;
+			BUG(); /* Not support chaining */
 		sg = scatterwalk_sg_next(sg);
 	}
 
+	if (likely(sg_nents == 1))
+		return 0;
+
 	return sg_nents;
 }
 
 /*
- * allocate and map the ipsec_esp extended descriptor
+ * allocate and map the aead extended descriptor
  */
 static struct aead_edesc *aead_edesc_alloc(struct aead_request *req,
-						     int desc_bytes)
+					   int desc_bytes, bool *all_contig_ptr)
 {
 	struct crypto_aead *aead = crypto_aead_reqtfm(req);
 	struct caam_ctx *ctx = crypto_aead_ctx(aead);
 	struct device *jrdev = ctx->jrdev;
-	gfp_t flags = req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP ? GFP_KERNEL :
-		      GFP_ATOMIC;
-	int assoc_nents, src_nents, dst_nents = 0, chained, link_tbl_bytes;
+	gfp_t flags = (req->base.flags & (CRYPTO_TFM_REQ_MAY_BACKLOG |
+		       CRYPTO_TFM_REQ_MAY_SLEEP)) ? GFP_KERNEL : GFP_ATOMIC;
+	int assoc_nents, src_nents, dst_nents = 0;
 	struct aead_edesc *edesc;
+	dma_addr_t iv_dma = 0;
+	int sgc;
+	bool all_contig = true;
+	int ivsize = crypto_aead_ivsize(aead);
+	int link_tbl_index, link_tbl_len = 0, link_tbl_bytes;
 
-	assoc_nents = sg_count(req->assoc, req->assoclen, &chained);
-	BUG_ON(chained);
-	if (likely(assoc_nents == 1))
-		assoc_nents = 0;
-
-	src_nents = sg_count(req->src, req->cryptlen + ctx->authsize,
-			     &chained);
-	BUG_ON(chained);
-	if (src_nents == 1)
-		src_nents = 0;
-
-	if (unlikely(req->dst != req->src)) {
-		dst_nents = sg_count(req->dst, req->cryptlen + ctx->authsize,
-				     &chained);
-		BUG_ON(chained);
-		if (dst_nents == 1)
-			dst_nents = 0;
+	assoc_nents = sg_count(req->assoc, req->assoclen);
+	src_nents = sg_count(req->src, req->cryptlen);
+
+	if (unlikely(req->dst != req->src))
+		dst_nents = sg_count(req->dst, req->cryptlen);
+
+	sgc = dma_map_sg(jrdev, req->assoc, assoc_nents ? : 1,
+			 DMA_BIDIRECTIONAL);
+	if (likely(req->src == req->dst)) {
+		sgc = dma_map_sg(jrdev, req->src, src_nents ? : 1,
+				 DMA_BIDIRECTIONAL);
+	} else {
+		sgc = dma_map_sg(jrdev, req->src, src_nents ? : 1,
+				 DMA_TO_DEVICE);
+		sgc = dma_map_sg(jrdev, req->dst, dst_nents ? : 1,
+				 DMA_FROM_DEVICE);
+	}
+
+	/* Check if data are contiguous */
+	iv_dma = dma_map_single(jrdev, req->iv, ivsize, DMA_TO_DEVICE);
+	if (assoc_nents || sg_dma_address(req->assoc) + req->assoclen !=
+	    iv_dma || src_nents || iv_dma + ivsize !=
+	    sg_dma_address(req->src)) {
+		all_contig = false;
+		assoc_nents = assoc_nents ? : 1;
+		src_nents = src_nents ? : 1;
+		link_tbl_len = assoc_nents + 1 + src_nents;
 	}
+	link_tbl_len += dst_nents;
 
-	link_tbl_bytes = (assoc_nents + src_nents + dst_nents) *
-			 sizeof(struct link_tbl_entry);
-	debug("link_tbl_bytes %d\n", link_tbl_bytes);
+	link_tbl_bytes = link_tbl_len * sizeof(struct link_tbl_entry);
 
 	/* allocate space for base edesc and hw desc commands, link tables */
 	edesc = kmalloc(sizeof(struct aead_edesc) + desc_bytes +
@@ -753,11 +1061,34 @@ static struct aead_edesc *aead_edesc_alloc(struct aead_request *req,
 	edesc->assoc_nents = assoc_nents;
 	edesc->src_nents = src_nents;
 	edesc->dst_nents = dst_nents;
+	edesc->iv_dma = iv_dma;
+	edesc->link_tbl_bytes = link_tbl_bytes;
 	edesc->link_tbl = (void *)edesc + sizeof(struct aead_edesc) +
 			  desc_bytes;
 	edesc->link_tbl_dma = dma_map_single(jrdev, edesc->link_tbl,
 					     link_tbl_bytes, DMA_TO_DEVICE);
-	edesc->link_tbl_bytes = link_tbl_bytes;
+	*all_contig_ptr = all_contig;
+
+	link_tbl_index = 0;
+	if (!all_contig) {
+		sg_to_link_tbl(req->assoc,
+			       (assoc_nents ? : 1),
+			       edesc->link_tbl +
+			       link_tbl_index, 0);
+		link_tbl_index += assoc_nents ? : 1;
+		sg_to_link_tbl_one(edesc->link_tbl + link_tbl_index,
+				   iv_dma, ivsize, 0);
+		link_tbl_index += 1;
+		sg_to_link_tbl_last(req->src,
+				    (src_nents ? : 1),
+				    edesc->link_tbl +
+				    link_tbl_index, 0);
+		link_tbl_index += src_nents ? : 1;
+	}
+	if (dst_nents) {
+		sg_to_link_tbl_last(req->dst, dst_nents,
+				    edesc->link_tbl + link_tbl_index, 0);
+	}
 
 	return edesc;
 }
@@ -768,62 +1099,185 @@ static int aead_encrypt(struct aead_request *req)
 	struct crypto_aead *aead = crypto_aead_reqtfm(req);
 	struct caam_ctx *ctx = crypto_aead_ctx(aead);
 	struct device *jrdev = ctx->jrdev;
-	int ivsize = crypto_aead_ivsize(aead);
+	bool all_contig;
 	u32 *desc;
-	dma_addr_t iv_dma;
+	int ret = 0;
+
+	req->cryptlen += ctx->authsize;
 
 	/* allocate extended descriptor */
-	edesc = aead_edesc_alloc(req, DESC_AEAD_ENCRYPT_TEXT_LEN *
-				      CAAM_CMD_SZ);
+	edesc = aead_edesc_alloc(req, DESC_JOB_IO_LEN *
+				 CAAM_CMD_SZ, &all_contig);
 	if (IS_ERR(edesc))
 		return PTR_ERR(edesc);
 
-	desc = edesc->hw_desc;
-
-	/* insert shared descriptor pointer */
-	init_job_desc_shared(desc, ctx->shared_desc_phys,
-			     desc_len(ctx->sh_desc), HDR_SHARE_DEFER);
-
-	iv_dma = dma_map_single(jrdev, req->iv, ivsize, DMA_TO_DEVICE);
-	/* check dma error */
+	/* Create and submit job descriptor */
+	init_aead_job(ctx->sh_desc_enc, ctx->sh_desc_enc_dma, edesc, req,
+		      all_contig, true);
+#ifdef DEBUG
+	print_hex_dump(KERN_ERR, "aead jobdesc@"xstr(__LINE__)": ",
+		       DUMP_PREFIX_ADDRESS, 16, 4, edesc->hw_desc,
+		       desc_bytes(edesc->hw_desc), 1);
+#endif
 
-	append_load(desc, iv_dma, ivsize,
-		    LDST_CLASS_1_CCB | LDST_SRCDST_BYTE_CONTEXT);
+	desc = edesc->hw_desc;
+	ret = caam_jr_enqueue(jrdev, desc, aead_encrypt_done, req);
+	if (!ret) {
+		ret = -EINPROGRESS;
+	} else {
+		aead_unmap(jrdev, edesc, req);
+		kfree(edesc);
+	}
 
-	return init_aead_job(edesc, req, OP_ALG_ENCRYPT, aead_encrypt_done);
+	return ret;
 }
 
 static int aead_decrypt(struct aead_request *req)
 {
+	struct aead_edesc *edesc;
 	struct crypto_aead *aead = crypto_aead_reqtfm(req);
-	int ivsize = crypto_aead_ivsize(aead);
 	struct caam_ctx *ctx = crypto_aead_ctx(aead);
 	struct device *jrdev = ctx->jrdev;
-	struct aead_edesc *edesc;
+	bool all_contig;
 	u32 *desc;
-	dma_addr_t iv_dma;
-
-	req->cryptlen -= ctx->authsize;
+	int ret = 0;
 
 	/* allocate extended descriptor */
-	edesc = aead_edesc_alloc(req, DESC_AEAD_DECRYPT_TEXT_LEN *
-				      CAAM_CMD_SZ);
+	edesc = aead_edesc_alloc(req, DESC_JOB_IO_LEN *
+				 CAAM_CMD_SZ, &all_contig);
 	if (IS_ERR(edesc))
 		return PTR_ERR(edesc);
 
+#ifdef DEBUG
+	print_hex_dump(KERN_ERR, "dec src@"xstr(__LINE__)": ",
+		       DUMP_PREFIX_ADDRESS, 16, 4, sg_virt(req->src),
+		       req->cryptlen, 1);
+#endif
+
+	/* Create and submit job descriptor*/
+	init_aead_job(ctx->sh_desc_dec,
+		      ctx->sh_desc_dec_dma, edesc, req, all_contig, false);
+#ifdef DEBUG
+	print_hex_dump(KERN_ERR, "aead jobdesc@"xstr(__LINE__)": ",
+		       DUMP_PREFIX_ADDRESS, 16, 4, edesc->hw_desc,
+		       desc_bytes(edesc->hw_desc), 1);
+#endif
+
 	desc = edesc->hw_desc;
+	ret = caam_jr_enqueue(jrdev, desc, aead_decrypt_done, req);
+	if (!ret) {
+		ret = -EINPROGRESS;
+	} else {
+		aead_unmap(jrdev, edesc, req);
+		kfree(edesc);
+	}
 
-	/* insert shared descriptor pointer */
-	init_job_desc_shared(desc, ctx->shared_desc_phys,
-			     desc_len(ctx->sh_desc), HDR_SHARE_DEFER);
+	return ret;
+}
 
-	iv_dma = dma_map_single(jrdev, req->iv, ivsize, DMA_TO_DEVICE);
-	/* check dma error */
+/*
+ * allocate and map the aead extended descriptor for aead givencrypt
+ */
+static struct aead_edesc *aead_giv_edesc_alloc(struct aead_givcrypt_request
+					       *greq, int desc_bytes,
+					       u32 *contig_ptr)
+{
+	struct aead_request *req = &greq->areq;
+	struct crypto_aead *aead = crypto_aead_reqtfm(req);
+	struct caam_ctx *ctx = crypto_aead_ctx(aead);
+	struct device *jrdev = ctx->jrdev;
+	gfp_t flags = (req->base.flags & (CRYPTO_TFM_REQ_MAY_BACKLOG |
+		       CRYPTO_TFM_REQ_MAY_SLEEP)) ? GFP_KERNEL : GFP_ATOMIC;
+	int assoc_nents, src_nents, dst_nents = 0;
+	struct aead_edesc *edesc;
+	dma_addr_t iv_dma = 0;
+	int sgc;
+	u32 contig = GIV_SRC_CONTIG | GIV_DST_CONTIG;
+	int ivsize = crypto_aead_ivsize(aead);
+	int link_tbl_index, link_tbl_len = 0, link_tbl_bytes;
 
-	append_load(desc, iv_dma, ivsize,
-		    LDST_CLASS_1_CCB | LDST_SRCDST_BYTE_CONTEXT);
+	assoc_nents = sg_count(req->assoc, req->assoclen);
+	src_nents = sg_count(req->src, req->cryptlen);
 
-	return init_aead_job(edesc, req, !OP_ALG_ENCRYPT, aead_decrypt_done);
+	if (unlikely(req->dst != req->src))
+		dst_nents = sg_count(req->dst, req->cryptlen);
+
+	sgc = dma_map_sg(jrdev, req->assoc, assoc_nents ? : 1,
+			 DMA_BIDIRECTIONAL);
+	if (likely(req->src == req->dst)) {
+		sgc = dma_map_sg(jrdev, req->src, src_nents ? : 1,
+				 DMA_BIDIRECTIONAL);
+	} else {
+		sgc = dma_map_sg(jrdev, req->src, src_nents ? : 1,
+				 DMA_TO_DEVICE);
+		sgc = dma_map_sg(jrdev, req->dst, dst_nents ? : 1,
+				 DMA_FROM_DEVICE);
+	}
+
+	/* Check if data are contiguous */
+	iv_dma = dma_map_single(jrdev, greq->giv, ivsize, DMA_TO_DEVICE);
+	if (assoc_nents || sg_dma_address(req->assoc) + req->assoclen !=
+	    iv_dma || src_nents || iv_dma + ivsize != sg_dma_address(req->src))
+		contig &= ~GIV_SRC_CONTIG;
+	if (dst_nents || iv_dma + ivsize != sg_dma_address(req->dst))
+		contig &= ~GIV_DST_CONTIG;
+		if (unlikely(req->src != req->dst)) {
+			dst_nents = dst_nents ? : 1;
+			link_tbl_len += 1;
+		}
+	if (!(contig & GIV_SRC_CONTIG)) {
+		assoc_nents = assoc_nents ? : 1;
+		src_nents = src_nents ? : 1;
+		link_tbl_len += assoc_nents + 1 + src_nents;
+		if (likely(req->src == req->dst))
+			contig &= ~GIV_DST_CONTIG;
+	}
+	link_tbl_len += dst_nents;
+
+	link_tbl_bytes = link_tbl_len * sizeof(struct link_tbl_entry);
+
+	/* allocate space for base edesc and hw desc commands, link tables */
+	edesc = kmalloc(sizeof(struct aead_edesc) + desc_bytes +
+			link_tbl_bytes, GFP_DMA | flags);
+	if (!edesc) {
+		dev_err(jrdev, "could not allocate extended descriptor\n");
+		return ERR_PTR(-ENOMEM);
+	}
+
+	edesc->assoc_nents = assoc_nents;
+	edesc->src_nents = src_nents;
+	edesc->dst_nents = dst_nents;
+	edesc->iv_dma = iv_dma;
+	edesc->link_tbl_bytes = link_tbl_bytes;
+	edesc->link_tbl = (void *)edesc + sizeof(struct aead_edesc) +
+			  desc_bytes;
+	edesc->link_tbl_dma = dma_map_single(jrdev, edesc->link_tbl,
+					     link_tbl_bytes, DMA_TO_DEVICE);
+	*contig_ptr = contig;
+
+	link_tbl_index = 0;
+	if (!(contig & GIV_SRC_CONTIG)) {
+		sg_to_link_tbl(req->assoc, assoc_nents,
+			       edesc->link_tbl +
+			       link_tbl_index, 0);
+		link_tbl_index += assoc_nents;
+		sg_to_link_tbl_one(edesc->link_tbl + link_tbl_index,
+				   iv_dma, ivsize, 0);
+		link_tbl_index += 1;
+		sg_to_link_tbl_last(req->src, src_nents,
+				    edesc->link_tbl +
+				    link_tbl_index, 0);
+		link_tbl_index += src_nents;
+	}
+	if (unlikely(req->src != req->dst && !(contig & GIV_DST_CONTIG))) {
+		sg_to_link_tbl_one(edesc->link_tbl + link_tbl_index,
+				   iv_dma, ivsize, 0);
+		link_tbl_index += 1;
+		sg_to_link_tbl_last(req->dst, dst_nents,
+				    edesc->link_tbl + link_tbl_index, 0);
+	}
+
+	return edesc;
 }
 
 static int aead_givencrypt(struct aead_givcrypt_request *areq)
@@ -833,55 +1287,44 @@ static int aead_givencrypt(struct aead_givcrypt_request *areq)
 	struct crypto_aead *aead = crypto_aead_reqtfm(req);
 	struct caam_ctx *ctx = crypto_aead_ctx(aead);
 	struct device *jrdev = ctx->jrdev;
-	int ivsize = crypto_aead_ivsize(aead);
-	dma_addr_t iv_dma;
+	u32 contig;
 	u32 *desc;
+	int ret = 0;
 
-	iv_dma = dma_map_single(jrdev, areq->giv, ivsize, DMA_FROM_DEVICE);
-
-	debug("%s: giv %p\n", __func__, areq->giv);
+	req->cryptlen += ctx->authsize;
 
 	/* allocate extended descriptor */
-	edesc = aead_edesc_alloc(req, DESC_AEAD_GIVENCRYPT_TEXT_LEN *
-				      CAAM_CMD_SZ);
+	edesc = aead_giv_edesc_alloc(areq, DESC_JOB_IO_LEN *
+				     CAAM_CMD_SZ, &contig);
+
 	if (IS_ERR(edesc))
 		return PTR_ERR(edesc);
 
-	desc = edesc->hw_desc;
-
-	/* insert shared descriptor pointer */
-	init_job_desc_shared(desc, ctx->shared_desc_phys,
-			     desc_len(ctx->sh_desc), HDR_SHARE_DEFER);
-
-	/*
-	 * LOAD IMM Info FIFO
-	 * to DECO, Last, Padding, Random, Message, 16 bytes
-	 */
-	append_load_imm_u32(desc, NFIFOENTRY_DEST_DECO | NFIFOENTRY_LC1 |
-			    NFIFOENTRY_STYPE_PAD | NFIFOENTRY_DTYPE_MSG |
-			    NFIFOENTRY_PTYPE_RND | ivsize,
-			    LDST_SRCDST_WORD_INFO_FIFO);
-
-	/*
-	 * disable info fifo entries since the above serves as the entry
-	 * this way, the MOVE command won't generate an entry.
-	 * Note that this isn't required in more recent versions of
-	 * SEC as a MOVE that doesn't do info FIFO entries is available.
-	 */
-	append_cmd(desc, CMD_LOAD | DISABLE_AUTO_INFO_FIFO);
-
-	/* MOVE DECO Alignment -> C1 Context 16 bytes */
-	append_move(desc, MOVE_SRC_INFIFO | MOVE_DEST_CLASS1CTX | ivsize);
-
-	/* re-enable info fifo entries */
-	append_cmd(desc, CMD_LOAD | ENABLE_AUTO_INFO_FIFO);
+#ifdef DEBUG
+	print_hex_dump(KERN_ERR, "giv src@"xstr(__LINE__)": ",
+		       DUMP_PREFIX_ADDRESS, 16, 4, sg_virt(req->src),
+		       req->cryptlen, 1);
+#endif
 
-	/* MOVE C1 Context -> OFIFO 16 bytes */
-	append_move(desc, MOVE_SRC_CLASS1CTX | MOVE_DEST_OUTFIFO | ivsize);
+	/* Create and submit job descriptor*/
+	init_aead_giv_job(ctx->sh_desc_givenc,
+			  ctx->sh_desc_givenc_dma, edesc, req, contig);
+#ifdef DEBUG
+	print_hex_dump(KERN_ERR, "aead jobdesc@"xstr(__LINE__)": ",
+		       DUMP_PREFIX_ADDRESS, 16, 4, edesc->hw_desc,
+		       desc_bytes(edesc->hw_desc), 1);
+#endif
 
-	append_fifo_store(desc, iv_dma, ivsize, FIFOST_TYPE_MESSAGE_DATA);
+	desc = edesc->hw_desc;
+	ret = caam_jr_enqueue(jrdev, desc, aead_encrypt_done, req);
+	if (!ret) {
+		ret = -EINPROGRESS;
+	} else {
+		aead_unmap(jrdev, edesc, req);
+		kfree(edesc);
+	}
 
-	return init_aead_job(edesc, req, OP_ALG_ENCRYPT, aead_encrypt_done);
+	return ret;
 }
 
 #define template_aead		template_u.aead
@@ -1120,16 +1563,19 @@ static void caam_cra_exit(struct crypto_tfm *tfm)
 {
 	struct caam_ctx *ctx = crypto_tfm_ctx(tfm);
 
-	if (!dma_mapping_error(ctx->jrdev, ctx->shared_desc_phys))
-		dma_unmap_single(ctx->jrdev, ctx->shared_desc_phys,
-				 desc_bytes(ctx->sh_desc), DMA_TO_DEVICE);
-	kfree(ctx->sh_desc);
-
-	if (!dma_mapping_error(ctx->jrdev, ctx->key_dma))
-		dma_unmap_single(ctx->jrdev, ctx->key_dma,
-				 ctx->split_key_pad_len + ctx->enckeylen,
+	if (ctx->sh_desc_enc_dma &&
+	    !dma_mapping_error(ctx->jrdev, ctx->sh_desc_enc_dma))
+		dma_unmap_single(ctx->jrdev, ctx->sh_desc_enc_dma,
+				 desc_bytes(ctx->sh_desc_enc), DMA_TO_DEVICE);
+	if (ctx->sh_desc_dec_dma &&
+	    !dma_mapping_error(ctx->jrdev, ctx->sh_desc_dec_dma))
+		dma_unmap_single(ctx->jrdev, ctx->sh_desc_dec_dma,
+				 desc_bytes(ctx->sh_desc_dec), DMA_TO_DEVICE);
+	if (ctx->sh_desc_givenc_dma &&
+	    !dma_mapping_error(ctx->jrdev, ctx->sh_desc_givenc_dma))
+		dma_unmap_single(ctx->jrdev, ctx->sh_desc_givenc_dma,
+				 desc_bytes(ctx->sh_desc_givenc),
 				 DMA_TO_DEVICE);
-	kfree(ctx->key);
 }
 
 static void __exit caam_algapi_exit(void)
diff --git a/drivers/crypto/caam/desc_constr.h b/drivers/crypto/caam/desc_constr.h
index 4691580..0991323 100644
--- a/drivers/crypto/caam/desc_constr.h
+++ b/drivers/crypto/caam/desc_constr.h
@@ -9,7 +9,7 @@
 #define IMMEDIATE (1 << 23)
 #define CAAM_CMD_SZ sizeof(u32)
 #define CAAM_PTR_SZ sizeof(dma_addr_t)
-#define CAAM_DESC_BYTES_MAX (CAAM_CMD_SZ * 64)
+#define CAAM_DESC_BYTES_MAX (CAAM_CMD_SZ * MAX_CAAM_DESCSIZE)
 
 #ifdef DEBUG
 #define PRINT_POS do { printk(KERN_DEBUG "%02d: %s\n", desc_len(desc),\
@@ -18,6 +18,9 @@
 #define PRINT_POS
 #endif
 
+#define SET_OK_PROP_ERRORS (IMMEDIATE | LDST_CLASS_DECO | \
+			    LDST_SRCDST_WORD_DECOCTRL | \
+			    (LDOFF_CHG_SHARE_OK_PROP << LDST_OFFSET_SHIFT))
 #define DISABLE_AUTO_INFO_FIFO (IMMEDIATE | LDST_CLASS_DECO | \
 				LDST_SRCDST_WORD_DECOCTRL | \
 				(LDOFF_DISABLE_AUTO_NFIFO << LDST_OFFSET_SHIFT))
@@ -203,3 +206,56 @@ static inline void append_##cmd##_imm_##type(u32 *desc, type immediate, \
 	append_cmd(desc, immediate); \
 }
 APPEND_CMD_RAW_IMM(load, LOAD, u32);
+
+/*
+ * Append math command. Only the last part of destination and source need to
+ * be specified
+ */
+#define APPEND_MATH(op, desc, dest, src_0, src_1, len) \
+append_cmd(desc, CMD_MATH | MATH_FUN_##op | MATH_DEST_##dest | \
+	   MATH_SRC0_##src_0 | MATH_SRC1_##src_1 | (u32) (len & MATH_LEN_MASK));
+
+#define append_math_add(desc, dest, src0, src1, len) \
+	APPEND_MATH(ADD, desc, dest, src0, src1, len)
+#define append_math_sub(desc, dest, src0, src1, len) \
+	APPEND_MATH(SUB, desc, dest, src0, src1, len)
+#define append_math_add_c(desc, dest, src0, src1, len) \
+	APPEND_MATH(ADDC, desc, dest, src0, src1, len)
+#define append_math_sub_b(desc, dest, src0, src1, len) \
+	APPEND_MATH(SUBB, desc, dest, src0, src1, len)
+#define append_math_and(desc, dest, src0, src1, len) \
+	APPEND_MATH(AND, desc, dest, src0, src1, len)
+#define append_math_or(desc, dest, src0, src1, len) \
+	APPEND_MATH(OR, desc, dest, src0, src1, len)
+#define append_math_xor(desc, dest, src0, src1, len) \
+	APPEND_MATH(XOR, desc, dest, src0, src1, len)
+#define append_math_lshift(desc, dest, src0, src1, len) \
+	APPEND_MATH(LSHIFT, desc, dest, src0, src1, len)
+#define append_math_rshift(desc, dest, src0, src1, len) \
+	APPEND_MATH(RSHIFT, desc, dest, src0, src1, len)
+
+/* Exactly one source is IMM. Data is passed in as u32 value */
+#define APPEND_MATH_IMM_u32(op, desc, dest, src_0, src_1, data) \
+do { \
+	APPEND_MATH(op, desc, dest, src_0, src_1, CAAM_CMD_SZ); \
+	append_cmd(desc, data); \
+} while (0);
+
+#define append_math_add_imm_u32(desc, dest, src0, src1, data) \
+	APPEND_MATH_IMM_u32(ADD, desc, dest, src0, src1, data)
+#define append_math_sub_imm_u32(desc, dest, src0, src1, data) \
+	APPEND_MATH_IMM_u32(SUB, desc, dest, src0, src1, data)
+#define append_math_add_c_imm_u32(desc, dest, src0, src1, data) \
+	APPEND_MATH_IMM_u32(ADDC, desc, dest, src0, src1, data)
+#define append_math_sub_b_imm_u32(desc, dest, src0, src1, data) \
+	APPEND_MATH_IMM_u32(SUBB, desc, dest, src0, src1, data)
+#define append_math_and_imm_u32(desc, dest, src0, src1, data) \
+	APPEND_MATH_IMM_u32(AND, desc, dest, src0, src1, data)
+#define append_math_or_imm_u32(desc, dest, src0, src1, data) \
+	APPEND_MATH_IMM_u32(OR, desc, dest, src0, src1, data)
+#define append_math_xor_imm_u32(desc, dest, src0, src1, data) \
+	APPEND_MATH_IMM_u32(XOR, desc, dest, src0, src1, data)
+#define append_math_lshift_imm_u32(desc, dest, src0, src1, data) \
+	APPEND_MATH_IMM_u32(LSHIFT, desc, dest, src0, src1, data)
+#define append_math_rshift_imm_u32(desc, dest, src0, src1, data) \
+	APPEND_MATH_IMM_u32(RSHIFT, desc, dest, src0, src1, data)
-- 
1.7.6
