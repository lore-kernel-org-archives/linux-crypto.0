From: Horia Geanta <horia.geanta@freescale.com>
Subject: [PATCH 6/9] crypto: caam - use RTA instead of inline append
Date: Fri, 18 Jul 2014 19:37:23 +0300
Message-ID: <1405701446-13656-7-git-send-email-horia.geanta@freescale.com>
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
Received: from mail-bn1lp0142.outbound.protection.outlook.com ([207.46.163.142]:57279
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934945AbaGRQjQ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 18 Jul 2014 12:39:16 -0400
In-Reply-To: <1405701446-13656-1-git-send-email-horia.geanta@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Update the following components:
caamalg, caamhash, caamrng, keygen, ctrl

Include path is updated accordingly in the Makefile.

Descriptors rewritten using RTA were tested to be bit-exact
(i.e. exact hex dump) with the ones being replaced, with
the following exceptions:
-shared descriptors - start index is 1 instead of 0; this has
no functional effect
-MDHA split keys are different - since the keys are the pre-computed
IPAD | OPAD HMAC keys encrypted with JDKEK (Job Descriptor
Key-Encryption Key); JDKEK changes at device POR.

Signed-off-by: Horia Geanta <horia.geanta@freescale.com>
---
 drivers/crypto/caam/Makefile   |   4 +-
 drivers/crypto/caam/caamalg.c  | 664 +++++++++++++++++++++++------------------
 drivers/crypto/caam/caamhash.c | 390 +++++++++++++++---------
 drivers/crypto/caam/caamrng.c  |  46 ++-
 drivers/crypto/caam/compat.h   |   1 +
 drivers/crypto/caam/ctrl.c     |  90 ++++--
 drivers/crypto/caam/ctrl.h     |   2 +-
 drivers/crypto/caam/error.c    |   2 +-
 drivers/crypto/caam/jr.c       |   2 +-
 drivers/crypto/caam/key_gen.c  |  36 +--
 drivers/crypto/caam/key_gen.h  |   2 +-
 11 files changed, 727 insertions(+), 512 deletions(-)

diff --git a/drivers/crypto/caam/Makefile b/drivers/crypto/caam/Makefile
index 550758a333e7..10a97a8a8391 100644
--- a/drivers/crypto/caam/Makefile
+++ b/drivers/crypto/caam/Makefile
@@ -2,9 +2,11 @@
 # Makefile for the CAAM backend and dependent components
 #
 ifeq ($(CONFIG_CRYPTO_DEV_FSL_CAAM_DEBUG), y)
-	EXTRA_CFLAGS := -DDEBUG
+	ccflags-y := -DDEBUG
 endif
 
+ccflags-y += -I$(src)
+
 obj-$(CONFIG_CRYPTO_DEV_FSL_CAAM) += caam.o
 obj-$(CONFIG_CRYPTO_DEV_FSL_CAAM_JR) += caam_jr.o
 obj-$(CONFIG_CRYPTO_DEV_FSL_CAAM_CRYPTO_API) += caamalg.o
diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index c3a845856cd0..ad5ef8c0c179 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -48,7 +48,7 @@
 
 #include "regs.h"
 #include "intern.h"
-#include "desc_constr.h"
+#include "flib/rta.h"
 #include "jr.h"
 #include "error.h"
 #include "sg_sw_sec4.h"
@@ -93,59 +93,56 @@
 static struct list_head alg_list;
 
 /* Set DK bit in class 1 operation if shared */
-static inline void append_dec_op1(u32 *desc, u32 type)
+static inline void append_dec_op1(struct program *program, uint32_t type)
 {
-	u32 *jump_cmd, *uncond_jump_cmd;
+	LABEL(jump_cmd);
+	REFERENCE(pjump_cmd);
+	LABEL(uncond_jump_cmd);
+	REFERENCE(puncond_jump_cmd);
 
 	/* DK bit is valid only for AES */
 	if ((type & OP_ALG_ALGSEL_MASK) != OP_ALG_ALGSEL_AES) {
-		append_operation(desc, type | OP_ALG_AS_INITFINAL |
-				 OP_ALG_DECRYPT);
+		ALG_OPERATION(type & OP_ALG_ALGSEL_MASK, type & OP_ALG_AAI_MASK,
+			      OP_ALG_AS_INITFINAL, ICV_CHECK_DISABLE,
+			      OP_ALG_DECRYPT);
 		return;
 	}
 
-	jump_cmd = append_jump(desc, JUMP_TEST_ALL | JUMP_COND_SHRD);
-	append_operation(desc, type | OP_ALG_AS_INITFINAL |
-			 OP_ALG_DECRYPT);
-	uncond_jump_cmd = append_jump(desc, JUMP_TEST_ALL);
-	set_jump_tgt_here(desc, jump_cmd);
-	append_operation(desc, type | OP_ALG_AS_INITFINAL |
-			 OP_ALG_DECRYPT | OP_ALG_AAI_DK);
-	set_jump_tgt_here(desc, uncond_jump_cmd);
-}
-
-/*
- * For aead functions, read payload and write payload,
- * both of which are specified in req->src and req->dst
- */
-static inline void aead_append_src_dst(u32 *desc, u32 msg_type)
-{
-	append_seq_fifo_store(desc, 0, FIFOST_TYPE_MESSAGE_DATA | KEY_VLF);
-	append_seq_fifo_load(desc, 0, FIFOLD_CLASS_BOTH |
-			     KEY_VLF | msg_type | FIFOLD_TYPE_LASTBOTH);
+	pjump_cmd = JUMP(IMM(jump_cmd), LOCAL_JUMP, ALL_TRUE, SHRD);
+	ALG_OPERATION(type & OP_ALG_ALGSEL_MASK, type & OP_ALG_AAI_MASK,
+		      OP_ALG_AS_INITFINAL, ICV_CHECK_DISABLE,
+		      OP_ALG_DECRYPT);
+	puncond_jump_cmd = JUMP(IMM(uncond_jump_cmd), LOCAL_JUMP, ALL_TRUE, 0);
+	SET_LABEL(jump_cmd);
+	ALG_OPERATION(type & OP_ALG_ALGSEL_MASK,
+		      (type & OP_ALG_AAI_MASK) | OP_ALG_AAI_DK,
+		      OP_ALG_AS_INITFINAL, ICV_CHECK_DISABLE,
+		      OP_ALG_DECRYPT);
+	SET_LABEL(uncond_jump_cmd);
+
+	PATCH_JUMP(pjump_cmd, jump_cmd);
+	PATCH_JUMP(puncond_jump_cmd, uncond_jump_cmd);
 }
 
 /*
  * For aead encrypt and decrypt, read iv for both classes
  */
-static inline void aead_append_ld_iv(u32 *desc, int ivsize)
+static inline void aead_append_ld_iv(struct program *program, uint32_t ivsize)
 {
-	append_cmd(desc, CMD_SEQ_LOAD | LDST_SRCDST_BYTE_CONTEXT |
-		   LDST_CLASS_1_CCB | ivsize);
-	append_move(desc, MOVE_SRC_CLASS1CTX | MOVE_DEST_CLASS2INFIFO | ivsize);
+	SEQLOAD(CONTEXT1, 0, ivsize, 0);
+	MOVE(CONTEXT1, 0, IFIFOAB2, 0, IMM(ivsize), 0);
 }
 
 /*
  * For ablkcipher encrypt and decrypt, read from req->src and
  * write to req->dst
  */
-static inline void ablkcipher_append_src_dst(u32 *desc)
+static inline void ablkcipher_append_src_dst(struct program *program)
 {
-	append_math_add(desc, VARSEQOUTLEN, SEQINLEN, REG0, CAAM_CMD_SZ);
-	append_math_add(desc, VARSEQINLEN, SEQINLEN, REG0, CAAM_CMD_SZ);
-	append_seq_fifo_load(desc, 0, FIFOLD_CLASS_CLASS1 |
-			     KEY_VLF | FIFOLD_TYPE_MSG | FIFOLD_TYPE_LAST1);
-	append_seq_fifo_store(desc, 0, FIFOST_TYPE_MESSAGE_DATA | KEY_VLF);
+	MATHB(SEQINSZ, ADD, MATH0, VSEQOUTSZ, 4, 0);
+	MATHB(SEQINSZ, ADD, MATH0, VSEQINSZ, 4, 0);
+	SEQFIFOLOAD(MSG1, 0, VLF | LAST1);
+	SEQFIFOSTORE(MSG, 0, 0, VLF);
 }
 
 /*
@@ -160,15 +157,15 @@ static inline void ablkcipher_append_src_dst(u32 *desc)
  */
 struct caam_ctx {
 	struct device *jrdev;
-	u32 sh_desc_enc[DESC_MAX_USED_LEN];
-	u32 sh_desc_dec[DESC_MAX_USED_LEN];
-	u32 sh_desc_givenc[DESC_MAX_USED_LEN];
+	uint32_t sh_desc_enc[DESC_MAX_USED_LEN];
+	uint32_t sh_desc_dec[DESC_MAX_USED_LEN];
+	uint32_t sh_desc_givenc[DESC_MAX_USED_LEN];
 	dma_addr_t sh_desc_enc_dma;
 	dma_addr_t sh_desc_dec_dma;
 	dma_addr_t sh_desc_givenc_dma;
-	u32 class1_alg_type;
-	u32 class2_alg_type;
-	u32 alg_op;
+	uint32_t class1_alg_type;
+	uint32_t class2_alg_type;
+	uint32_t alg_op;
 	u8 key[CAAM_MAX_KEY_SIZE];
 	dma_addr_t key_dma;
 	unsigned int enckeylen;
@@ -177,38 +174,38 @@ struct caam_ctx {
 	unsigned int authsize;
 };
 
-static void append_key_aead(u32 *desc, struct caam_ctx *ctx,
+static void append_key_aead(struct program *program, struct caam_ctx *ctx,
 			    int keys_fit_inline)
 {
 	if (keys_fit_inline) {
-		append_key_as_imm(desc, ctx->key, ctx->split_key_pad_len,
-				  ctx->split_key_len, CLASS_2 |
-				  KEY_DEST_MDHA_SPLIT | KEY_ENC);
-		append_key_as_imm(desc, (void *)ctx->key +
-				  ctx->split_key_pad_len, ctx->enckeylen,
-				  ctx->enckeylen, CLASS_1 | KEY_DEST_CLASS_REG);
+		KEY(MDHA_SPLIT_KEY, ENC, PTR((uintptr_t)ctx->key),
+		    ctx->split_key_len, IMMED);
+		KEY(KEY1, 0,
+		    PTR((uintptr_t)(ctx->key + ctx->split_key_pad_len)),
+		    ctx->enckeylen, IMMED);
 	} else {
-		append_key(desc, ctx->key_dma, ctx->split_key_len, CLASS_2 |
-			   KEY_DEST_MDHA_SPLIT | KEY_ENC);
-		append_key(desc, ctx->key_dma + ctx->split_key_pad_len,
-			   ctx->enckeylen, CLASS_1 | KEY_DEST_CLASS_REG);
+		KEY(MDHA_SPLIT_KEY, ENC, PTR(ctx->key_dma), ctx->split_key_len,
+		    0);
+		KEY(KEY1, 0, PTR(ctx->key_dma + ctx->split_key_pad_len),
+		    ctx->enckeylen, 0);
 	}
 }
 
-static void init_sh_desc_key_aead(u32 *desc, struct caam_ctx *ctx,
+static void init_sh_desc_key_aead(struct program *program, struct caam_ctx *ctx,
 				  int keys_fit_inline)
 {
-	u32 *key_jump_cmd;
+	LABEL(key_jump_cmd);
+	REFERENCE(pkey_jump_cmd);
 
-	init_sh_desc(desc, HDR_SHARE_SERIAL);
+	SHR_HDR(SHR_SERIAL, 1, 0);
 
 	/* Skip if already shared */
-	key_jump_cmd = append_jump(desc, JUMP_JSL | JUMP_TEST_ALL |
-				   JUMP_COND_SHRD);
+	pkey_jump_cmd = JUMP(IMM(key_jump_cmd), LOCAL_JUMP, ALL_TRUE, SHRD);
 
-	append_key_aead(desc, ctx, keys_fit_inline);
+	append_key_aead(program, ctx, keys_fit_inline);
 
-	set_jump_tgt_here(desc, key_jump_cmd);
+	SET_LABEL(key_jump_cmd);
+	PATCH_JUMP(pkey_jump_cmd, key_jump_cmd);
 }
 
 static int aead_null_set_sh_desc(struct crypto_aead *aead)
@@ -217,8 +214,19 @@ static int aead_null_set_sh_desc(struct crypto_aead *aead)
 	struct caam_ctx *ctx = crypto_aead_ctx(aead);
 	struct device *jrdev = ctx->jrdev;
 	bool keys_fit_inline = false;
-	u32 *key_jump_cmd, *jump_cmd, *read_move_cmd, *write_move_cmd;
-	u32 *desc;
+	uint32_t *desc;
+	struct program prg;
+	struct program *program = &prg;
+	unsigned desc_bytes;
+	bool ps = (sizeof(dma_addr_t) == sizeof(u64));
+	LABEL(skip_key_load);
+	REFERENCE(pskip_key_load);
+	LABEL(nop_cmd);
+	REFERENCE(pnop_cmd);
+	LABEL(read_move_cmd);
+	REFERENCE(pread_move_cmd);
+	LABEL(write_move_cmd);
+	REFERENCE(pwrite_move_cmd);
 
 	/*
 	 * Job Descriptor and Shared Descriptors
@@ -230,70 +238,72 @@ static int aead_null_set_sh_desc(struct crypto_aead *aead)
 
 	/* aead_encrypt shared descriptor */
 	desc = ctx->sh_desc_enc;
+	PROGRAM_CNTXT_INIT(desc, 0);
+	if (ps)
+		PROGRAM_SET_36BIT_ADDR();
 
-	init_sh_desc(desc, HDR_SHARE_SERIAL);
+	SHR_HDR(SHR_SERIAL, 1, 0);
 
 	/* Skip if already shared */
-	key_jump_cmd = append_jump(desc, JUMP_JSL | JUMP_TEST_ALL |
-				   JUMP_COND_SHRD);
+	pskip_key_load = JUMP(IMM(skip_key_load), LOCAL_JUMP, ALL_TRUE, SHRD);
 	if (keys_fit_inline)
-		append_key_as_imm(desc, ctx->key, ctx->split_key_pad_len,
-				  ctx->split_key_len, CLASS_2 |
-				  KEY_DEST_MDHA_SPLIT | KEY_ENC);
+		KEY(MDHA_SPLIT_KEY, ENC, PTR((uintptr_t)ctx->key),
+		    ctx->split_key_len, IMMED);
 	else
-		append_key(desc, ctx->key_dma, ctx->split_key_len, CLASS_2 |
-			   KEY_DEST_MDHA_SPLIT | KEY_ENC);
-	set_jump_tgt_here(desc, key_jump_cmd);
+		KEY(MDHA_SPLIT_KEY, ENC, PTR(ctx->key_dma), ctx->split_key_len,
+		    0);
+	SET_LABEL(skip_key_load);
 
 	/* cryptlen = seqoutlen - authsize */
-	append_math_sub_imm_u32(desc, REG3, SEQOUTLEN, IMM, ctx->authsize);
+	MATHB(SEQOUTSZ, SUB, IMM(ctx->authsize), MATH3, CAAM_CMD_SZ, 0);
 
 	/*
 	 * NULL encryption; IV is zero
 	 * assoclen = (assoclen + cryptlen) - cryptlen
 	 */
-	append_math_sub(desc, VARSEQINLEN, SEQINLEN, REG3, CAAM_CMD_SZ);
+	MATHB(SEQINSZ, SUB, MATH3, VSEQINSZ, CAAM_CMD_SZ, 0);
 
 	/* read assoc before reading payload */
-	append_seq_fifo_load(desc, 0, FIFOLD_CLASS_CLASS2 | FIFOLD_TYPE_MSG |
-			     KEY_VLF);
+	SEQFIFOLOAD(MSG2, 0 , VLF);
 
 	/* Prepare to read and write cryptlen bytes */
-	append_math_add(desc, VARSEQINLEN, ZERO, REG3, CAAM_CMD_SZ);
-	append_math_add(desc, VARSEQOUTLEN, ZERO, REG3, CAAM_CMD_SZ);
+	MATHB(ZERO, ADD, MATH3, VSEQINSZ, CAAM_CMD_SZ, 0);
+	MATHB(ZERO, ADD, MATH3, VSEQOUTSZ, CAAM_CMD_SZ, 0);
 
 	/*
 	 * MOVE_LEN opcode is not available in all SEC HW revisions,
 	 * thus need to do some magic, i.e. self-patch the descriptor
 	 * buffer.
 	 */
-	read_move_cmd = append_move(desc, MOVE_SRC_DESCBUF |
-				    MOVE_DEST_MATH3 |
-				    (0x6 << MOVE_LEN_SHIFT));
-	write_move_cmd = append_move(desc, MOVE_SRC_MATH3 |
-				     MOVE_DEST_DESCBUF |
-				     MOVE_WAITCOMP |
-				     (0x8 << MOVE_LEN_SHIFT));
+	pread_move_cmd = MOVE(DESCBUF, 0, MATH3, 0, IMM(6), 0);
+	pwrite_move_cmd = MOVE(MATH3, 0, DESCBUF, 0, IMM(8), WAITCOMP);
 
 	/* Class 2 operation */
-	append_operation(desc, ctx->class2_alg_type |
-			 OP_ALG_AS_INITFINAL | OP_ALG_ENCRYPT);
+	ALG_OPERATION(ctx->class2_alg_type & OP_ALG_ALGSEL_MASK,
+		      ctx->class2_alg_type & OP_ALG_AAI_MASK,
+		      OP_ALG_AS_INITFINAL, ICV_CHECK_DISABLE,
+		      OP_ALG_ENCRYPT);
 
 	/* Read and write cryptlen bytes */
-	aead_append_src_dst(desc, FIFOLD_TYPE_MSG | FIFOLD_TYPE_FLUSH1);
+	SEQFIFOSTORE(MSG, 0, 0, VLF);
+	SEQFIFOLOAD(MSGINSNOOP, 0, VLF | LAST1 | LAST2 | FLUSH1);
 
-	set_move_tgt_here(desc, read_move_cmd);
-	set_move_tgt_here(desc, write_move_cmd);
-	append_cmd(desc, CMD_LOAD | DISABLE_AUTO_INFO_FIFO);
-	append_move(desc, MOVE_SRC_INFIFO_CL | MOVE_DEST_OUTFIFO |
-		    MOVE_AUX_LS);
+	SET_LABEL(read_move_cmd);
+	SET_LABEL(write_move_cmd);
+	LOAD(IMM(0), DCTRL, LDOFF_DISABLE_AUTO_NFIFO, 0, 0);
+	MOVE(IFIFOAB1, 0, OFIFO, 0, IMM(0), 0);
 
 	/* Write ICV */
-	append_seq_store(desc, ctx->authsize, LDST_CLASS_2_CCB |
-			 LDST_SRCDST_BYTE_CONTEXT);
+	SEQSTORE(CONTEXT2, 0, ctx->authsize, 0);
+
+	PATCH_JUMP(pskip_key_load, skip_key_load);
+	PATCH_MOVE(pread_move_cmd, read_move_cmd);
+	PATCH_MOVE(pwrite_move_cmd, write_move_cmd);
 
-	ctx->sh_desc_enc_dma = dma_map_single(jrdev, desc,
-					      desc_bytes(desc),
+	PROGRAM_FINALIZE();
+
+	desc_bytes = DESC_BYTES(desc);
+	ctx->sh_desc_enc_dma = dma_map_single(jrdev, desc, desc_bytes,
 					      DMA_TO_DEVICE);
 	if (dma_mapping_error(jrdev, ctx->sh_desc_enc_dma)) {
 		dev_err(jrdev, "unable to map shared descriptor\n");
@@ -302,8 +312,7 @@ static int aead_null_set_sh_desc(struct crypto_aead *aead)
 #ifdef DEBUG
 	print_hex_dump(KERN_ERR,
 		       "aead null enc shdesc@"__stringify(__LINE__)": ",
-		       DUMP_PREFIX_ADDRESS, 16, 4, desc,
-		       desc_bytes(desc), 1);
+		       DUMP_PREFIX_ADDRESS, 16, 4, desc, desc_bytes, 1);
 #endif
 
 	/*
@@ -315,78 +324,81 @@ static int aead_null_set_sh_desc(struct crypto_aead *aead)
 	    ctx->split_key_pad_len <= CAAM_DESC_BYTES_MAX)
 		keys_fit_inline = true;
 
+	/* aead_decrypt shared descriptor */
 	desc = ctx->sh_desc_dec;
+	PROGRAM_CNTXT_INIT(desc, 0);
+	if (ps)
+		PROGRAM_SET_36BIT_ADDR();
 
-	/* aead_decrypt shared descriptor */
-	init_sh_desc(desc, HDR_SHARE_SERIAL);
+	SHR_HDR(SHR_SERIAL, 1, 0);
 
 	/* Skip if already shared */
-	key_jump_cmd = append_jump(desc, JUMP_JSL | JUMP_TEST_ALL |
-				   JUMP_COND_SHRD);
+	pskip_key_load = JUMP(IMM(skip_key_load), LOCAL_JUMP, ALL_TRUE, SHRD);
 	if (keys_fit_inline)
-		append_key_as_imm(desc, ctx->key, ctx->split_key_pad_len,
-				  ctx->split_key_len, CLASS_2 |
-				  KEY_DEST_MDHA_SPLIT | KEY_ENC);
+		KEY(MDHA_SPLIT_KEY, ENC, PTR((uintptr_t)ctx->key),
+		    ctx->split_key_len, IMMED);
 	else
-		append_key(desc, ctx->key_dma, ctx->split_key_len, CLASS_2 |
-			   KEY_DEST_MDHA_SPLIT | KEY_ENC);
-	set_jump_tgt_here(desc, key_jump_cmd);
+		KEY(MDHA_SPLIT_KEY, ENC, PTR(ctx->key_dma), ctx->split_key_len,
+		    0);
+	SET_LABEL(skip_key_load);
 
 	/* Class 2 operation */
-	append_operation(desc, ctx->class2_alg_type |
-			 OP_ALG_AS_INITFINAL | OP_ALG_DECRYPT | OP_ALG_ICV_ON);
+	ALG_OPERATION(ctx->class2_alg_type & OP_ALG_ALGSEL_MASK,
+		      ctx->class2_alg_type & OP_ALG_AAI_MASK,
+		      OP_ALG_AS_INITFINAL, ICV_CHECK_ENABLE,
+		      OP_ALG_DECRYPT);
 
 	/* assoclen + cryptlen = seqinlen - ivsize - authsize */
-	append_math_sub_imm_u32(desc, REG3, SEQINLEN, IMM,
-				ctx->authsize + tfm->ivsize);
+	MATHB(SEQINSZ, SUB, IMM(ctx->authsize + tfm->ivsize), MATH3,
+	      CAAM_CMD_SZ, 0);
 	/* assoclen = (assoclen + cryptlen) - cryptlen */
-	append_math_sub(desc, REG2, SEQOUTLEN, REG0, CAAM_CMD_SZ);
-	append_math_sub(desc, VARSEQINLEN, REG3, REG2, CAAM_CMD_SZ);
+	MATHB(SEQOUTSZ, SUB, MATH0, MATH2, CAAM_CMD_SZ, 0);
+	MATHB(MATH3, SUB, MATH2, VSEQINSZ, CAAM_CMD_SZ, 0);
 
 	/* read assoc before reading payload */
-	append_seq_fifo_load(desc, 0, FIFOLD_CLASS_CLASS2 | FIFOLD_TYPE_MSG |
-			     KEY_VLF);
+	SEQFIFOLOAD(MSG2, 0 , VLF);
 
 	/* Prepare to read and write cryptlen bytes */
-	append_math_add(desc, VARSEQINLEN, ZERO, REG2, CAAM_CMD_SZ);
-	append_math_add(desc, VARSEQOUTLEN, ZERO, REG2, CAAM_CMD_SZ);
+	MATHB(ZERO, ADD, MATH2, VSEQINSZ, CAAM_CMD_SZ, 0);
+	MATHB(ZERO, ADD, MATH2, VSEQOUTSZ, CAAM_CMD_SZ, 0);
 
 	/*
 	 * MOVE_LEN opcode is not available in all SEC HW revisions,
 	 * thus need to do some magic, i.e. self-patch the descriptor
 	 * buffer.
 	 */
-	read_move_cmd = append_move(desc, MOVE_SRC_DESCBUF |
-				    MOVE_DEST_MATH2 |
-				    (0x6 << MOVE_LEN_SHIFT));
-	write_move_cmd = append_move(desc, MOVE_SRC_MATH2 |
-				     MOVE_DEST_DESCBUF |
-				     MOVE_WAITCOMP |
-				     (0x8 << MOVE_LEN_SHIFT));
+	pread_move_cmd = MOVE(DESCBUF, 0, MATH2, 0, IMM(6), 0);
+	pwrite_move_cmd = MOVE(MATH2, 0, DESCBUF, 0, IMM(8), WAITCOMP);
 
 	/* Read and write cryptlen bytes */
-	aead_append_src_dst(desc, FIFOLD_TYPE_MSG | FIFOLD_TYPE_FLUSH1);
+	SEQFIFOSTORE(MSG, 0, 0, VLF);
+	SEQFIFOLOAD(MSGINSNOOP, 0, VLF | LAST1 | LAST2 | FLUSH1);
 
 	/*
 	 * Insert a NOP here, since we need at least 4 instructions between
 	 * code patching the descriptor buffer and the location being patched.
 	 */
-	jump_cmd = append_jump(desc, JUMP_TEST_ALL);
-	set_jump_tgt_here(desc, jump_cmd);
+	pnop_cmd = JUMP(IMM(nop_cmd), LOCAL_JUMP, ALL_TRUE, 0);
+	SET_LABEL(nop_cmd);
 
-	set_move_tgt_here(desc, read_move_cmd);
-	set_move_tgt_here(desc, write_move_cmd);
-	append_cmd(desc, CMD_LOAD | DISABLE_AUTO_INFO_FIFO);
-	append_move(desc, MOVE_SRC_INFIFO_CL | MOVE_DEST_OUTFIFO |
-		    MOVE_AUX_LS);
-	append_cmd(desc, CMD_LOAD | ENABLE_AUTO_INFO_FIFO);
+	SET_LABEL(read_move_cmd);
+	SET_LABEL(write_move_cmd);
+	LOAD(IMM(0), DCTRL, LDOFF_DISABLE_AUTO_NFIFO, 0, 0);
+	MOVE(IFIFOAB1, 0, OFIFO, 0, IMM(0), 0);
+	LOAD(IMM(0), DCTRL, LDOFF_ENABLE_AUTO_NFIFO, 0, 0);
 
 	/* Load ICV */
-	append_seq_fifo_load(desc, ctx->authsize, FIFOLD_CLASS_CLASS2 |
-			     FIFOLD_TYPE_LAST2 | FIFOLD_TYPE_ICV);
+	SEQFIFOLOAD(ICV2, ctx->authsize, LAST2);
+
+	PATCH_JUMP(pskip_key_load, skip_key_load);
+	PATCH_JUMP(pnop_cmd, nop_cmd);
+	PATCH_MOVE(pread_move_cmd, read_move_cmd);
+	PATCH_MOVE(pwrite_move_cmd, write_move_cmd);
 
-	ctx->sh_desc_dec_dma = dma_map_single(jrdev, desc,
-					      desc_bytes(desc),
+	PROGRAM_FINALIZE();
+
+	desc_bytes = DESC_BYTES(desc);
+	ctx->sh_desc_dec_dma = dma_map_single(jrdev, desc, desc_bytes,
 					      DMA_TO_DEVICE);
 	if (dma_mapping_error(jrdev, ctx->sh_desc_dec_dma)) {
 		dev_err(jrdev, "unable to map shared descriptor\n");
@@ -395,8 +407,7 @@ static int aead_null_set_sh_desc(struct crypto_aead *aead)
 #ifdef DEBUG
 	print_hex_dump(KERN_ERR,
 		       "aead null dec shdesc@"__stringify(__LINE__)": ",
-		       DUMP_PREFIX_ADDRESS, 16, 4, desc,
-		       desc_bytes(desc), 1);
+		       DUMP_PREFIX_ADDRESS, 16, 4, desc, desc_bytes, 1);
 #endif
 
 	return 0;
@@ -408,8 +419,12 @@ static int aead_set_sh_desc(struct crypto_aead *aead)
 	struct caam_ctx *ctx = crypto_aead_ctx(aead);
 	struct device *jrdev = ctx->jrdev;
 	bool keys_fit_inline = false;
-	u32 geniv, moveiv;
-	u32 *desc;
+	uint32_t geniv, moveiv;
+	uint32_t *desc;
+	struct program prg;
+	struct program *program = &prg;
+	unsigned desc_bytes;
+	bool ps = (sizeof(dma_addr_t) == sizeof(u64));
 
 	if (!ctx->authsize)
 		return 0;
@@ -429,42 +444,52 @@ static int aead_set_sh_desc(struct crypto_aead *aead)
 
 	/* aead_encrypt shared descriptor */
 	desc = ctx->sh_desc_enc;
+	PROGRAM_CNTXT_INIT(desc, 0);
+	if (ps)
+		PROGRAM_SET_36BIT_ADDR();
 
-	init_sh_desc_key_aead(desc, ctx, keys_fit_inline);
+	init_sh_desc_key_aead(program, ctx, keys_fit_inline);
 
 	/* Class 2 operation */
-	append_operation(desc, ctx->class2_alg_type |
-			 OP_ALG_AS_INITFINAL | OP_ALG_ENCRYPT);
+	ALG_OPERATION(ctx->class2_alg_type & OP_ALG_ALGSEL_MASK,
+		      ctx->class2_alg_type & OP_ALG_AAI_MASK,
+		      OP_ALG_AS_INITFINAL, ICV_CHECK_DISABLE,
+		      OP_ALG_ENCRYPT);
 
 	/* cryptlen = seqoutlen - authsize */
-	append_math_sub_imm_u32(desc, REG3, SEQOUTLEN, IMM, ctx->authsize);
+	MATHB(SEQOUTSZ, SUB, IMM(ctx->authsize), MATH3, CAAM_CMD_SZ, 0);
 
 	/* assoclen + cryptlen = seqinlen - ivsize */
-	append_math_sub_imm_u32(desc, REG2, SEQINLEN, IMM, tfm->ivsize);
+	MATHB(SEQINSZ, SUB, IMM(tfm->ivsize), MATH2, CAAM_CMD_SZ, 0);
 
 	/* assoclen = (assoclen + cryptlen) - cryptlen */
-	append_math_sub(desc, VARSEQINLEN, REG2, REG3, CAAM_CMD_SZ);
+	MATHB(MATH2, SUB, MATH3, VSEQINSZ, CAAM_CMD_SZ, 0);
 
 	/* read assoc before reading payload */
-	append_seq_fifo_load(desc, 0, FIFOLD_CLASS_CLASS2 | FIFOLD_TYPE_MSG |
-			     KEY_VLF);
-	aead_append_ld_iv(desc, tfm->ivsize);
+	SEQFIFOLOAD(MSG2, 0 , VLF);
+	aead_append_ld_iv(program, tfm->ivsize);
 
 	/* Class 1 operation */
-	append_operation(desc, ctx->class1_alg_type |
-			 OP_ALG_AS_INITFINAL | OP_ALG_ENCRYPT);
+	ALG_OPERATION(ctx->class1_alg_type & OP_ALG_ALGSEL_MASK,
+		      ctx->class1_alg_type & OP_ALG_AAI_MASK,
+		      OP_ALG_AS_INITFINAL, ICV_CHECK_DISABLE,
+		      OP_ALG_ENCRYPT);
 
 	/* Read and write cryptlen bytes */
-	append_math_add(desc, VARSEQINLEN, ZERO, REG3, CAAM_CMD_SZ);
-	append_math_add(desc, VARSEQOUTLEN, ZERO, REG3, CAAM_CMD_SZ);
-	aead_append_src_dst(desc, FIFOLD_TYPE_MSG1OUT2);
+	MATHB(ZERO, ADD, MATH3, VSEQINSZ, CAAM_CMD_SZ, 0);
+	MATHB(ZERO, ADD, MATH3, VSEQOUTSZ, CAAM_CMD_SZ, 0);
+
+	/* Read and write payload */
+	SEQFIFOSTORE(MSG, 0, 0, VLF);
+	SEQFIFOLOAD(MSGOUTSNOOP, 0, VLF | LAST1 | LAST2);
 
 	/* Write ICV */
-	append_seq_store(desc, ctx->authsize, LDST_CLASS_2_CCB |
-			 LDST_SRCDST_BYTE_CONTEXT);
+	SEQSTORE(CONTEXT2, 0, ctx->authsize, 0);
+
+	PROGRAM_FINALIZE();
 
-	ctx->sh_desc_enc_dma = dma_map_single(jrdev, desc,
-					      desc_bytes(desc),
+	desc_bytes = DESC_BYTES(desc);
+	ctx->sh_desc_enc_dma = dma_map_single(jrdev, desc, desc_bytes,
 					      DMA_TO_DEVICE);
 	if (dma_mapping_error(jrdev, ctx->sh_desc_enc_dma)) {
 		dev_err(jrdev, "unable to map shared descriptor\n");
@@ -472,8 +497,7 @@ static int aead_set_sh_desc(struct crypto_aead *aead)
 	}
 #ifdef DEBUG
 	print_hex_dump(KERN_ERR, "aead enc shdesc@"__stringify(__LINE__)": ",
-		       DUMP_PREFIX_ADDRESS, 16, 4, desc,
-		       desc_bytes(desc), 1);
+		       DUMP_PREFIX_ADDRESS, 16, 4, desc, desc_bytes, 1);
 #endif
 
 	/*
@@ -488,39 +512,47 @@ static int aead_set_sh_desc(struct crypto_aead *aead)
 
 	/* aead_decrypt shared descriptor */
 	desc = ctx->sh_desc_dec;
+	PROGRAM_CNTXT_INIT(desc, 0);
+	if (ps)
+		PROGRAM_SET_36BIT_ADDR();
 
-	init_sh_desc_key_aead(desc, ctx, keys_fit_inline);
+	init_sh_desc_key_aead(program, ctx, keys_fit_inline);
 
 	/* Class 2 operation */
-	append_operation(desc, ctx->class2_alg_type |
-			 OP_ALG_AS_INITFINAL | OP_ALG_DECRYPT | OP_ALG_ICV_ON);
+	ALG_OPERATION(ctx->class2_alg_type & OP_ALG_ALGSEL_MASK,
+		      ctx->class2_alg_type & OP_ALG_AAI_MASK,
+		      OP_ALG_AS_INITFINAL, ICV_CHECK_ENABLE,
+		      OP_ALG_DECRYPT);
 
 	/* assoclen + cryptlen = seqinlen - ivsize - authsize */
-	append_math_sub_imm_u32(desc, REG3, SEQINLEN, IMM,
-				ctx->authsize + tfm->ivsize);
+	MATHB(SEQINSZ, SUB, IMM(ctx->authsize + tfm->ivsize), MATH3,
+	      CAAM_CMD_SZ, 0);
 	/* assoclen = (assoclen + cryptlen) - cryptlen */
-	append_math_sub(desc, REG2, SEQOUTLEN, REG0, CAAM_CMD_SZ);
-	append_math_sub(desc, VARSEQINLEN, REG3, REG2, CAAM_CMD_SZ);
+	MATHB(SEQOUTSZ, SUB, MATH0, MATH2, CAAM_CMD_SZ, 0);
+	MATHB(MATH3, SUB, MATH2, VSEQINSZ, CAAM_CMD_SZ, 0);
 
 	/* read assoc before reading payload */
-	append_seq_fifo_load(desc, 0, FIFOLD_CLASS_CLASS2 | FIFOLD_TYPE_MSG |
-			     KEY_VLF);
+	SEQFIFOLOAD(MSG2, 0 , VLF);
 
-	aead_append_ld_iv(desc, tfm->ivsize);
+	aead_append_ld_iv(program, tfm->ivsize);
 
-	append_dec_op1(desc, ctx->class1_alg_type);
+	append_dec_op1(program, ctx->class1_alg_type);
 
 	/* Read and write cryptlen bytes */
-	append_math_add(desc, VARSEQINLEN, ZERO, REG2, CAAM_CMD_SZ);
-	append_math_add(desc, VARSEQOUTLEN, ZERO, REG2, CAAM_CMD_SZ);
-	aead_append_src_dst(desc, FIFOLD_TYPE_MSG);
+	MATHB(ZERO, ADD, MATH2, VSEQINSZ, CAAM_CMD_SZ, 0);
+	MATHB(ZERO, ADD, MATH2, VSEQOUTSZ, CAAM_CMD_SZ, 0);
+
+	/* Read and write payload */
+	SEQFIFOSTORE(MSG, 0, 0, VLF);
+	SEQFIFOLOAD(MSGINSNOOP, 0, VLF | LAST1 | LAST2);
 
 	/* Load ICV */
-	append_seq_fifo_load(desc, ctx->authsize, FIFOLD_CLASS_CLASS2 |
-			     FIFOLD_TYPE_LAST2 | FIFOLD_TYPE_ICV);
+	SEQFIFOLOAD(ICV2, ctx->authsize, LAST2);
+
+	PROGRAM_FINALIZE();
 
-	ctx->sh_desc_dec_dma = dma_map_single(jrdev, desc,
-					      desc_bytes(desc),
+	desc_bytes = DESC_BYTES(desc);
+	ctx->sh_desc_dec_dma = dma_map_single(jrdev, desc, desc_bytes,
 					      DMA_TO_DEVICE);
 	if (dma_mapping_error(jrdev, ctx->sh_desc_dec_dma)) {
 		dev_err(jrdev, "unable to map shared descriptor\n");
@@ -528,8 +560,7 @@ static int aead_set_sh_desc(struct crypto_aead *aead)
 	}
 #ifdef DEBUG
 	print_hex_dump(KERN_ERR, "aead dec shdesc@"__stringify(__LINE__)": ",
-		       DUMP_PREFIX_ADDRESS, 16, 4, desc,
-		       desc_bytes(desc), 1);
+		       DUMP_PREFIX_ADDRESS, 16, 4, desc, desc_bytes, 1);
 #endif
 
 	/*
@@ -544,67 +575,71 @@ static int aead_set_sh_desc(struct crypto_aead *aead)
 
 	/* aead_givencrypt shared descriptor */
 	desc = ctx->sh_desc_givenc;
+	PROGRAM_CNTXT_INIT(desc, 0);
+	if (ps)
+		PROGRAM_SET_36BIT_ADDR();
 
-	init_sh_desc_key_aead(desc, ctx, keys_fit_inline);
+	init_sh_desc_key_aead(program, ctx, keys_fit_inline);
 
 	/* Generate IV */
 	geniv = NFIFOENTRY_STYPE_PAD | NFIFOENTRY_DEST_DECO |
 		NFIFOENTRY_DTYPE_MSG | NFIFOENTRY_LC1 |
 		NFIFOENTRY_PTYPE_RND | (tfm->ivsize << NFIFOENTRY_DLEN_SHIFT);
-	append_load_imm_u32(desc, geniv, LDST_CLASS_IND_CCB |
-			    LDST_SRCDST_WORD_INFO_FIFO | LDST_IMM);
-	append_cmd(desc, CMD_LOAD | DISABLE_AUTO_INFO_FIFO);
-	append_move(desc, MOVE_SRC_INFIFO |
-		    MOVE_DEST_CLASS1CTX | (tfm->ivsize << MOVE_LEN_SHIFT));
-	append_cmd(desc, CMD_LOAD | ENABLE_AUTO_INFO_FIFO);
+	LOAD(IMM(geniv), NFIFO, 0, CAAM_CMD_SZ, 0);
+	LOAD(IMM(0), DCTRL, LDOFF_DISABLE_AUTO_NFIFO, 0, 0);
+	MOVE(IFIFOABD, 0, CONTEXT1, 0, IMM(tfm->ivsize), 0);
+	LOAD(IMM(0), DCTRL, LDOFF_ENABLE_AUTO_NFIFO, 0, 0);
 
 	/* Copy IV to class 1 context */
-	append_move(desc, MOVE_SRC_CLASS1CTX |
-		    MOVE_DEST_OUTFIFO | (tfm->ivsize << MOVE_LEN_SHIFT));
+	MOVE(CONTEXT1, 0, OFIFO, 0, IMM(tfm->ivsize), 0);
 
 	/* Return to encryption */
-	append_operation(desc, ctx->class2_alg_type |
-			 OP_ALG_AS_INITFINAL | OP_ALG_ENCRYPT);
+	ALG_OPERATION(ctx->class2_alg_type & OP_ALG_ALGSEL_MASK,
+		      ctx->class2_alg_type & OP_ALG_AAI_MASK,
+		      OP_ALG_AS_INITFINAL, ICV_CHECK_DISABLE,
+		      OP_ALG_ENCRYPT);
 
 	/* ivsize + cryptlen = seqoutlen - authsize */
-	append_math_sub_imm_u32(desc, REG3, SEQOUTLEN, IMM, ctx->authsize);
+	MATHB(SEQOUTSZ, SUB, IMM(ctx->authsize), MATH3, CAAM_CMD_SZ, 0);
 
 	/* assoclen = seqinlen - (ivsize + cryptlen) */
-	append_math_sub(desc, VARSEQINLEN, SEQINLEN, REG3, CAAM_CMD_SZ);
+	MATHB(SEQINSZ, SUB, MATH3, VSEQINSZ, CAAM_CMD_SZ, 0);
 
 	/* read assoc before reading payload */
-	append_seq_fifo_load(desc, 0, FIFOLD_CLASS_CLASS2 | FIFOLD_TYPE_MSG |
-			     KEY_VLF);
+	SEQFIFOLOAD(MSG2, 0, VLF);
 
 	/* Copy iv from class 1 ctx to class 2 fifo*/
 	moveiv = NFIFOENTRY_STYPE_OFIFO | NFIFOENTRY_DEST_CLASS2 |
 		 NFIFOENTRY_DTYPE_MSG | (tfm->ivsize << NFIFOENTRY_DLEN_SHIFT);
-	append_load_imm_u32(desc, moveiv, LDST_CLASS_IND_CCB |
-			    LDST_SRCDST_WORD_INFO_FIFO | LDST_IMM);
-	append_load_imm_u32(desc, tfm->ivsize, LDST_CLASS_2_CCB |
-			    LDST_SRCDST_WORD_DATASZ_REG | LDST_IMM);
+	LOAD(IMM(moveiv), NFIFO, 0, CAAM_CMD_SZ, 0);
+	LOAD(IMM(tfm->ivsize), DATA2SZ, 0, CAAM_CMD_SZ, 0);
 
 	/* Class 1 operation */
-	append_operation(desc, ctx->class1_alg_type |
-			 OP_ALG_AS_INITFINAL | OP_ALG_ENCRYPT);
+	ALG_OPERATION(ctx->class1_alg_type & OP_ALG_ALGSEL_MASK,
+		      ctx->class1_alg_type & OP_ALG_AAI_MASK,
+		      OP_ALG_AS_INITFINAL, ICV_CHECK_DISABLE,
+		      OP_ALG_ENCRYPT);
 
 	/* Will write ivsize + cryptlen */
-	append_math_add(desc, VARSEQOUTLEN, SEQINLEN, REG0, CAAM_CMD_SZ);
+	MATHB(SEQINSZ, ADD, MATH0, VSEQOUTSZ, CAAM_CMD_SZ, 0);
 
 	/* Not need to reload iv */
-	append_seq_fifo_load(desc, tfm->ivsize,
-			     FIFOLD_CLASS_SKIP);
+	SEQFIFOLOAD(SKIP, tfm->ivsize, 0);
 
 	/* Will read cryptlen */
-	append_math_add(desc, VARSEQINLEN, SEQINLEN, REG0, CAAM_CMD_SZ);
-	aead_append_src_dst(desc, FIFOLD_TYPE_MSG1OUT2);
+	MATHB(SEQINSZ, ADD, MATH0, VSEQINSZ, CAAM_CMD_SZ, 0);
+
+	/* Read and write payload */
+	SEQFIFOSTORE(MSG, 0, 0, VLF);
+	SEQFIFOLOAD(MSGOUTSNOOP, 0, VLF | LAST1 | LAST2);
 
 	/* Write ICV */
-	append_seq_store(desc, ctx->authsize, LDST_CLASS_2_CCB |
-			 LDST_SRCDST_BYTE_CONTEXT);
+	SEQSTORE(CONTEXT2, 0, ctx->authsize, 0);
+
+	PROGRAM_FINALIZE();
 
-	ctx->sh_desc_givenc_dma = dma_map_single(jrdev, desc,
-						 desc_bytes(desc),
+	desc_bytes = DESC_BYTES(desc);
+	ctx->sh_desc_givenc_dma = dma_map_single(jrdev, desc, desc_bytes,
 						 DMA_TO_DEVICE);
 	if (dma_mapping_error(jrdev, ctx->sh_desc_givenc_dma)) {
 		dev_err(jrdev, "unable to map shared descriptor\n");
@@ -612,8 +647,7 @@ static int aead_set_sh_desc(struct crypto_aead *aead)
 	}
 #ifdef DEBUG
 	print_hex_dump(KERN_ERR, "aead givenc shdesc@"__stringify(__LINE__)": ",
-		       DUMP_PREFIX_ADDRESS, 16, 4, desc,
-		       desc_bytes(desc), 1);
+		       DUMP_PREFIX_ADDRESS, 16, 4, desc, desc_bytes, 1);
 #endif
 
 	return 0;
@@ -710,8 +744,13 @@ static int ablkcipher_setkey(struct crypto_ablkcipher *ablkcipher,
 	struct ablkcipher_tfm *tfm = &ablkcipher->base.crt_ablkcipher;
 	struct device *jrdev = ctx->jrdev;
 	int ret = 0;
-	u32 *key_jump_cmd;
-	u32 *desc;
+	uint32_t *desc;
+	struct program prg;
+	struct program *program = &prg;
+	unsigned desc_bytes;
+	bool ps = (sizeof(dma_addr_t) == sizeof(u64));
+	LABEL(key_jump_cmd);
+	REFERENCE(pkey_jump_cmd);
 
 #ifdef DEBUG
 	print_hex_dump(KERN_ERR, "key in @"__stringify(__LINE__)": ",
@@ -729,31 +768,37 @@ static int ablkcipher_setkey(struct crypto_ablkcipher *ablkcipher,
 
 	/* ablkcipher_encrypt shared descriptor */
 	desc = ctx->sh_desc_enc;
-	init_sh_desc(desc, HDR_SHARE_SERIAL);
+	PROGRAM_CNTXT_INIT(desc, 0);
+	if (ps)
+		PROGRAM_SET_36BIT_ADDR();
+
+	SHR_HDR(SHR_SERIAL, 1, 0);
 	/* Skip if already shared */
-	key_jump_cmd = append_jump(desc, JUMP_JSL | JUMP_TEST_ALL |
-				   JUMP_COND_SHRD);
+	pkey_jump_cmd = JUMP(IMM(key_jump_cmd), LOCAL_JUMP, ALL_TRUE, SHRD);
 
 	/* Load class1 key only */
-	append_key_as_imm(desc, (void *)ctx->key, ctx->enckeylen,
-			  ctx->enckeylen, CLASS_1 |
-			  KEY_DEST_CLASS_REG);
+	KEY(KEY1, 0, PTR((uintptr_t)ctx->key), ctx->enckeylen, IMMED);
 
-	set_jump_tgt_here(desc, key_jump_cmd);
+	SET_LABEL(key_jump_cmd);
 
-	/* Load iv */
-	append_cmd(desc, CMD_SEQ_LOAD | LDST_SRCDST_BYTE_CONTEXT |
-		   LDST_CLASS_1_CCB | tfm->ivsize);
+	/* Load IV */
+	SEQLOAD(CONTEXT1, 0, tfm->ivsize, 0);
 
 	/* Load operation */
-	append_operation(desc, ctx->class1_alg_type |
-			 OP_ALG_AS_INITFINAL | OP_ALG_ENCRYPT);
+	ALG_OPERATION(ctx->class1_alg_type & OP_ALG_ALGSEL_MASK,
+		      ctx->class1_alg_type & OP_ALG_AAI_MASK,
+		      OP_ALG_AS_INITFINAL, ICV_CHECK_DISABLE,
+		      OP_ALG_ENCRYPT);
 
 	/* Perform operation */
-	ablkcipher_append_src_dst(desc);
+	ablkcipher_append_src_dst(program);
+
+	PATCH_JUMP(pkey_jump_cmd, key_jump_cmd);
 
-	ctx->sh_desc_enc_dma = dma_map_single(jrdev, desc,
-					      desc_bytes(desc),
+	PROGRAM_FINALIZE();
+
+	desc_bytes = DESC_BYTES(desc);
+	ctx->sh_desc_enc_dma = dma_map_single(jrdev, desc, desc_bytes,
 					      DMA_TO_DEVICE);
 	if (dma_mapping_error(jrdev, ctx->sh_desc_enc_dma)) {
 		dev_err(jrdev, "unable to map shared descriptor\n");
@@ -762,36 +807,40 @@ static int ablkcipher_setkey(struct crypto_ablkcipher *ablkcipher,
 #ifdef DEBUG
 	print_hex_dump(KERN_ERR,
 		       "ablkcipher enc shdesc@"__stringify(__LINE__)": ",
-		       DUMP_PREFIX_ADDRESS, 16, 4, desc,
-		       desc_bytes(desc), 1);
+		       DUMP_PREFIX_ADDRESS, 16, 4, desc, desc_bytes, 1);
 #endif
+
 	/* ablkcipher_decrypt shared descriptor */
 	desc = ctx->sh_desc_dec;
+	PROGRAM_CNTXT_INIT(desc, 0);
+	if (ps)
+		PROGRAM_SET_36BIT_ADDR();
+
+	SHR_HDR(SHR_SERIAL, 1, 0);
 
-	init_sh_desc(desc, HDR_SHARE_SERIAL);
 	/* Skip if already shared */
-	key_jump_cmd = append_jump(desc, JUMP_JSL | JUMP_TEST_ALL |
-				   JUMP_COND_SHRD);
+	pkey_jump_cmd = JUMP(IMM(key_jump_cmd), LOCAL_JUMP, ALL_TRUE, SHRD);
 
 	/* Load class1 key only */
-	append_key_as_imm(desc, (void *)ctx->key, ctx->enckeylen,
-			  ctx->enckeylen, CLASS_1 |
-			  KEY_DEST_CLASS_REG);
+	KEY(KEY1, 0, PTR((uintptr_t)ctx->key), ctx->enckeylen, IMMED);
 
-	set_jump_tgt_here(desc, key_jump_cmd);
+	SET_LABEL(key_jump_cmd);
 
 	/* load IV */
-	append_cmd(desc, CMD_SEQ_LOAD | LDST_SRCDST_BYTE_CONTEXT |
-		   LDST_CLASS_1_CCB | tfm->ivsize);
+	SEQLOAD(CONTEXT1, 0, tfm->ivsize, 0);
 
 	/* Choose operation */
-	append_dec_op1(desc, ctx->class1_alg_type);
+	append_dec_op1(program, ctx->class1_alg_type);
 
 	/* Perform operation */
-	ablkcipher_append_src_dst(desc);
+	ablkcipher_append_src_dst(program);
+
+	PATCH_JUMP(pkey_jump_cmd, key_jump_cmd);
 
-	ctx->sh_desc_dec_dma = dma_map_single(jrdev, desc,
-					      desc_bytes(desc),
+	PROGRAM_FINALIZE();
+
+	desc_bytes = DESC_BYTES(desc);
+	ctx->sh_desc_dec_dma = dma_map_single(jrdev, desc, desc_bytes,
 					      DMA_TO_DEVICE);
 	if (dma_mapping_error(jrdev, ctx->sh_desc_dec_dma)) {
 		dev_err(jrdev, "unable to map shared descriptor\n");
@@ -801,8 +850,7 @@ static int ablkcipher_setkey(struct crypto_ablkcipher *ablkcipher,
 #ifdef DEBUG
 	print_hex_dump(KERN_ERR,
 		       "ablkcipher dec shdesc@"__stringify(__LINE__)": ",
-		       DUMP_PREFIX_ADDRESS, 16, 4, desc,
-		       desc_bytes(desc), 1);
+		       DUMP_PREFIX_ADDRESS, 16, 4, desc, desc_bytes, 1);
 #endif
 
 	return ret;
@@ -1071,7 +1119,7 @@ static void ablkcipher_decrypt_done(struct device *jrdev, u32 *desc, u32 err,
 /*
  * Fill in aead job descriptor
  */
-static void init_aead_job(u32 *sh_desc, dma_addr_t ptr,
+static void init_aead_job(uint32_t *sh_desc, dma_addr_t ptr,
 			  struct aead_edesc *edesc,
 			  struct aead_request *req,
 			  bool all_contig, bool encrypt)
@@ -1081,9 +1129,12 @@ static void init_aead_job(u32 *sh_desc, dma_addr_t ptr,
 	int ivsize = crypto_aead_ivsize(aead);
 	int authsize = ctx->authsize;
 	u32 *desc = edesc->hw_desc;
-	u32 out_options = 0, in_options;
+	uint32_t out_options = EXT, in_options = EXT;
 	dma_addr_t dst_dma, src_dma;
-	int len, sec4_sg_index = 0;
+	unsigned len, sec4_sg_index = 0;
+	struct program prg;
+	struct program *program = &prg;
+	bool ps = (sizeof(dma_addr_t) == sizeof(u64));
 
 #ifdef DEBUG
 	debug("assoclen %d cryptlen %d authsize %d\n",
@@ -1098,25 +1149,27 @@ static void init_aead_job(u32 *sh_desc, dma_addr_t ptr,
 		       DUMP_PREFIX_ADDRESS, 16, 4, sg_virt(req->src),
 			edesc->src_nents ? 100 : req->cryptlen, 1);
 	print_hex_dump(KERN_ERR, "shrdesc@"__stringify(__LINE__)": ",
-		       DUMP_PREFIX_ADDRESS, 16, 4, sh_desc,
-		       desc_bytes(sh_desc), 1);
+		       DUMP_PREFIX_ADDRESS, 16, 4, sh_desc, DESC_BYTES(sh_desc),
+		       1);
 #endif
 
-	len = desc_len(sh_desc);
-	init_job_desc_shared(desc, ptr, len, HDR_SHARE_DEFER | HDR_REVERSE);
+	len = DESC_LEN(sh_desc);
+	PROGRAM_CNTXT_INIT(desc, len);
+	if (ps)
+		PROGRAM_SET_36BIT_ADDR();
+
+	JOB_HDR(SHR_DEFER, len, ptr, REO | SHR);
 
 	if (all_contig) {
 		src_dma = sg_dma_address(req->assoc);
-		in_options = 0;
 	} else {
 		src_dma = edesc->sec4_sg_dma;
 		sec4_sg_index += (edesc->assoc_nents ? : 1) + 1 +
 				 (edesc->src_nents ? : 1);
-		in_options = LDST_SGF;
+		in_options |= SGF;
 	}
 
-	append_seq_in_ptr(desc, src_dma, req->assoclen + ivsize + req->cryptlen,
-			  in_options);
+	SEQINPTR(src_dma, req->assoclen + ivsize + req->cryptlen, in_options);
 
 	if (likely(req->src == req->dst)) {
 		if (all_contig) {
@@ -1124,7 +1177,7 @@ static void init_aead_job(u32 *sh_desc, dma_addr_t ptr,
 		} else {
 			dst_dma = src_dma + sizeof(struct sec4_sg_entry) *
 				  ((edesc->assoc_nents ? : 1) + 1);
-			out_options = LDST_SGF;
+			out_options |= SGF;
 		}
 	} else {
 		if (!edesc->dst_nents) {
@@ -1133,15 +1186,15 @@ static void init_aead_job(u32 *sh_desc, dma_addr_t ptr,
 			dst_dma = edesc->sec4_sg_dma +
 				  sec4_sg_index *
 				  sizeof(struct sec4_sg_entry);
-			out_options = LDST_SGF;
+			out_options |= SGF;
 		}
 	}
 	if (encrypt)
-		append_seq_out_ptr(desc, dst_dma, req->cryptlen + authsize,
-				   out_options);
+		SEQOUTPTR(dst_dma, req->cryptlen + authsize, out_options);
 	else
-		append_seq_out_ptr(desc, dst_dma, req->cryptlen - authsize,
-				   out_options);
+		SEQOUTPTR(dst_dma, req->cryptlen - authsize, out_options);
+
+	PROGRAM_FINALIZE();
 }
 
 /*
@@ -1157,9 +1210,12 @@ static void init_aead_giv_job(u32 *sh_desc, dma_addr_t ptr,
 	int ivsize = crypto_aead_ivsize(aead);
 	int authsize = ctx->authsize;
 	u32 *desc = edesc->hw_desc;
-	u32 out_options = 0, in_options;
+	uint32_t out_options = EXT, in_options = EXT;
 	dma_addr_t dst_dma, src_dma;
-	int len, sec4_sg_index = 0;
+	unsigned len, sec4_sg_index = 0;
+	struct program prg;
+	struct program *program = &prg;
+	bool ps = (sizeof(dma_addr_t) == sizeof(u64));
 
 #ifdef DEBUG
 	debug("assoclen %d cryptlen %d authsize %d\n",
@@ -1173,23 +1229,25 @@ static void init_aead_giv_job(u32 *sh_desc, dma_addr_t ptr,
 		       DUMP_PREFIX_ADDRESS, 16, 4, sg_virt(req->src),
 			edesc->src_nents > 1 ? 100 : req->cryptlen, 1);
 	print_hex_dump(KERN_ERR, "shrdesc@"__stringify(__LINE__)": ",
-		       DUMP_PREFIX_ADDRESS, 16, 4, sh_desc,
-		       desc_bytes(sh_desc), 1);
+		       DUMP_PREFIX_ADDRESS, 16, 4, sh_desc, DESC_BYTES(sh_desc),
+		       1);
 #endif
 
-	len = desc_len(sh_desc);
-	init_job_desc_shared(desc, ptr, len, HDR_SHARE_DEFER | HDR_REVERSE);
+	len = DESC_LEN(sh_desc);
+	PROGRAM_CNTXT_INIT(desc, len);
+	if (ps)
+		PROGRAM_SET_36BIT_ADDR();
+
+	JOB_HDR(SHR_DEFER, len, ptr, REO | SHR);
 
 	if (contig & GIV_SRC_CONTIG) {
 		src_dma = sg_dma_address(req->assoc);
-		in_options = 0;
 	} else {
 		src_dma = edesc->sec4_sg_dma;
 		sec4_sg_index += edesc->assoc_nents + 1 + edesc->src_nents;
-		in_options = LDST_SGF;
+		in_options |= SGF;
 	}
-	append_seq_in_ptr(desc, src_dma, req->assoclen + ivsize + req->cryptlen,
-			  in_options);
+	SEQINPTR(src_dma, req->assoclen + ivsize + req->cryptlen, in_options);
 
 	if (contig & GIV_DST_CONTIG) {
 		dst_dma = edesc->iv_dma;
@@ -1197,17 +1255,18 @@ static void init_aead_giv_job(u32 *sh_desc, dma_addr_t ptr,
 		if (likely(req->src == req->dst)) {
 			dst_dma = src_dma + sizeof(struct sec4_sg_entry) *
 				  edesc->assoc_nents;
-			out_options = LDST_SGF;
+			out_options |= SGF;
 		} else {
 			dst_dma = edesc->sec4_sg_dma +
 				  sec4_sg_index *
 				  sizeof(struct sec4_sg_entry);
-			out_options = LDST_SGF;
+			out_options |= SGF;
 		}
 	}
 
-	append_seq_out_ptr(desc, dst_dma, ivsize + req->cryptlen + authsize,
-			   out_options);
+	SEQOUTPTR(dst_dma, ivsize + req->cryptlen + authsize, out_options);
+
+	PROGRAM_FINALIZE();
 }
 
 /*
@@ -1221,9 +1280,12 @@ static void init_ablkcipher_job(u32 *sh_desc, dma_addr_t ptr,
 	struct crypto_ablkcipher *ablkcipher = crypto_ablkcipher_reqtfm(req);
 	int ivsize = crypto_ablkcipher_ivsize(ablkcipher);
 	u32 *desc = edesc->hw_desc;
-	u32 out_options = 0, in_options;
+	uint32_t out_options = EXT, in_options = EXT;
 	dma_addr_t dst_dma, src_dma;
-	int len, sec4_sg_index = 0;
+	unsigned len, sec4_sg_index = 0;
+	struct program prg;
+	struct program *program = &prg;
+	bool ps = (sizeof(dma_addr_t) == sizeof(u64));
 
 #ifdef DEBUG
 	print_hex_dump(KERN_ERR, "presciv@"__stringify(__LINE__)": ",
@@ -1234,18 +1296,21 @@ static void init_ablkcipher_job(u32 *sh_desc, dma_addr_t ptr,
 		       edesc->src_nents ? 100 : req->nbytes, 1);
 #endif
 
-	len = desc_len(sh_desc);
-	init_job_desc_shared(desc, ptr, len, HDR_SHARE_DEFER | HDR_REVERSE);
+	len = DESC_LEN(sh_desc);
+	PROGRAM_CNTXT_INIT(desc, len);
+	if (ps)
+		PROGRAM_SET_36BIT_ADDR();
+
+	JOB_HDR(SHR_DEFER, len, ptr, REO | SHR);
 
 	if (iv_contig) {
 		src_dma = edesc->iv_dma;
-		in_options = 0;
 	} else {
 		src_dma = edesc->sec4_sg_dma;
 		sec4_sg_index += (iv_contig ? 0 : 1) + edesc->src_nents;
-		in_options = LDST_SGF;
+		in_options |= SGF;
 	}
-	append_seq_in_ptr(desc, src_dma, req->nbytes + ivsize, in_options);
+	SEQINPTR(src_dma, req->nbytes + ivsize, in_options);
 
 	if (likely(req->src == req->dst)) {
 		if (!edesc->src_nents && iv_contig) {
@@ -1253,7 +1318,7 @@ static void init_ablkcipher_job(u32 *sh_desc, dma_addr_t ptr,
 		} else {
 			dst_dma = edesc->sec4_sg_dma +
 				sizeof(struct sec4_sg_entry);
-			out_options = LDST_SGF;
+			out_options |= SGF;
 		}
 	} else {
 		if (!edesc->dst_nents) {
@@ -1261,10 +1326,13 @@ static void init_ablkcipher_job(u32 *sh_desc, dma_addr_t ptr,
 		} else {
 			dst_dma = edesc->sec4_sg_dma +
 				sec4_sg_index * sizeof(struct sec4_sg_entry);
-			out_options = LDST_SGF;
+			out_options |= SGF;
 		}
 	}
-	append_seq_out_ptr(desc, dst_dma, req->nbytes, out_options);
+
+	SEQOUTPTR(dst_dma, req->nbytes, out_options);
+
+	PROGRAM_FINALIZE();
 }
 
 /*
@@ -1406,7 +1474,7 @@ static int aead_encrypt(struct aead_request *req)
 #ifdef DEBUG
 	print_hex_dump(KERN_ERR, "aead jobdesc@"__stringify(__LINE__)": ",
 		       DUMP_PREFIX_ADDRESS, 16, 4, edesc->hw_desc,
-		       desc_bytes(edesc->hw_desc), 1);
+		       DESC_BYTES(edesc->hw_desc), 1);
 #endif
 
 	desc = edesc->hw_desc;
@@ -1449,7 +1517,7 @@ static int aead_decrypt(struct aead_request *req)
 #ifdef DEBUG
 	print_hex_dump(KERN_ERR, "aead jobdesc@"__stringify(__LINE__)": ",
 		       DUMP_PREFIX_ADDRESS, 16, 4, edesc->hw_desc,
-		       desc_bytes(edesc->hw_desc), 1);
+		       DESC_BYTES(edesc->hw_desc), 1);
 #endif
 
 	desc = edesc->hw_desc;
@@ -1612,7 +1680,7 @@ static int aead_givencrypt(struct aead_givcrypt_request *areq)
 #ifdef DEBUG
 	print_hex_dump(KERN_ERR, "aead jobdesc@"__stringify(__LINE__)": ",
 		       DUMP_PREFIX_ADDRESS, 16, 4, edesc->hw_desc,
-		       desc_bytes(edesc->hw_desc), 1);
+		       DESC_BYTES(edesc->hw_desc), 1);
 #endif
 
 	desc = edesc->hw_desc;
@@ -1755,7 +1823,7 @@ static int ablkcipher_encrypt(struct ablkcipher_request *req)
 #ifdef DEBUG
 	print_hex_dump(KERN_ERR, "ablkcipher jobdesc@"__stringify(__LINE__)": ",
 		       DUMP_PREFIX_ADDRESS, 16, 4, edesc->hw_desc,
-		       desc_bytes(edesc->hw_desc), 1);
+		       DESC_BYTES(edesc->hw_desc), 1);
 #endif
 	desc = edesc->hw_desc;
 	ret = caam_jr_enqueue(jrdev, desc, ablkcipher_encrypt_done, req);
@@ -1793,7 +1861,7 @@ static int ablkcipher_decrypt(struct ablkcipher_request *req)
 #ifdef DEBUG
 	print_hex_dump(KERN_ERR, "ablkcipher jobdesc@"__stringify(__LINE__)": ",
 		       DUMP_PREFIX_ADDRESS, 16, 4, edesc->hw_desc,
-		       desc_bytes(edesc->hw_desc), 1);
+		       DESC_BYTES(edesc->hw_desc), 1);
 #endif
 
 	ret = caam_jr_enqueue(jrdev, desc, ablkcipher_decrypt_done, req);
@@ -1822,9 +1890,9 @@ struct caam_alg_template {
 		struct compress_alg compress;
 		struct rng_alg rng;
 	} template_u;
-	u32 class1_alg_type;
-	u32 class2_alg_type;
-	u32 alg_op;
+	uint32_t class1_alg_type;
+	uint32_t class2_alg_type;
+	uint32_t alg_op;
 };
 
 static struct caam_alg_template driver_algs[] = {
@@ -2389,15 +2457,15 @@ static void caam_cra_exit(struct crypto_tfm *tfm)
 	if (ctx->sh_desc_enc_dma &&
 	    !dma_mapping_error(ctx->jrdev, ctx->sh_desc_enc_dma))
 		dma_unmap_single(ctx->jrdev, ctx->sh_desc_enc_dma,
-				 desc_bytes(ctx->sh_desc_enc), DMA_TO_DEVICE);
+				 DESC_BYTES(ctx->sh_desc_enc), DMA_TO_DEVICE);
 	if (ctx->sh_desc_dec_dma &&
 	    !dma_mapping_error(ctx->jrdev, ctx->sh_desc_dec_dma))
 		dma_unmap_single(ctx->jrdev, ctx->sh_desc_dec_dma,
-				 desc_bytes(ctx->sh_desc_dec), DMA_TO_DEVICE);
+				 DESC_BYTES(ctx->sh_desc_dec), DMA_TO_DEVICE);
 	if (ctx->sh_desc_givenc_dma &&
 	    !dma_mapping_error(ctx->jrdev, ctx->sh_desc_givenc_dma))
 		dma_unmap_single(ctx->jrdev, ctx->sh_desc_givenc_dma,
-				 desc_bytes(ctx->sh_desc_givenc),
+				 DESC_BYTES(ctx->sh_desc_givenc),
 				 DMA_TO_DEVICE);
 	if (ctx->key_dma &&
 	    !dma_mapping_error(ctx->jrdev, ctx->key_dma))
diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index 386efb9e192c..ec66e715d825 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -57,7 +57,7 @@
 
 #include "regs.h"
 #include "intern.h"
-#include "desc_constr.h"
+#include "flib/rta.h"
 #include "jr.h"
 #include "error.h"
 #include "sg_sw_sec4.h"
@@ -137,7 +137,8 @@ struct caam_hash_state {
 /* Common job descriptor seq in/out ptr routines */
 
 /* Map state->caam_ctx, and append seq_out_ptr command that points to it */
-static inline int map_seq_out_ptr_ctx(u32 *desc, struct device *jrdev,
+static inline int map_seq_out_ptr_ctx(struct program *program,
+				      struct device *jrdev,
 				      struct caam_hash_state *state,
 				      int ctx_len)
 {
@@ -148,19 +149,20 @@ static inline int map_seq_out_ptr_ctx(u32 *desc, struct device *jrdev,
 		return -ENOMEM;
 	}
 
-	append_seq_out_ptr(desc, state->ctx_dma, ctx_len, 0);
+	SEQOUTPTR(state->ctx_dma, ctx_len, EXT);
 
 	return 0;
 }
 
 /* Map req->result, and append seq_out_ptr command that points to it */
-static inline dma_addr_t map_seq_out_ptr_result(u32 *desc, struct device *jrdev,
+static inline dma_addr_t map_seq_out_ptr_result(struct program *program,
+						struct device *jrdev,
 						u8 *result, int digestsize)
 {
 	dma_addr_t dst_dma;
 
 	dst_dma = dma_map_single(jrdev, result, digestsize, DMA_FROM_DEVICE);
-	append_seq_out_ptr(desc, dst_dma, digestsize, 0);
+	SEQOUTPTR(dst_dma, digestsize, EXT);
 
 	return dst_dma;
 }
@@ -224,28 +226,32 @@ static inline int ctx_map_to_sec4_sg(u32 *desc, struct device *jrdev,
 }
 
 /* Common shared descriptor commands */
-static inline void append_key_ahash(u32 *desc, struct caam_hash_ctx *ctx)
+static inline void append_key_ahash(struct program *program,
+				    struct caam_hash_ctx *ctx)
 {
-	append_key_as_imm(desc, ctx->key, ctx->split_key_pad_len,
-			  ctx->split_key_len, CLASS_2 |
-			  KEY_DEST_MDHA_SPLIT | KEY_ENC);
+	KEY(MDHA_SPLIT_KEY, ENC, PTR((uintptr_t)ctx->key),
+	    ctx->split_key_len, IMMED);
 }
 
 /* Append key if it has been set */
-static inline void init_sh_desc_key_ahash(u32 *desc, struct caam_hash_ctx *ctx)
+static inline void init_sh_desc_key_ahash(struct program *program,
+					  struct caam_hash_ctx *ctx)
 {
-	u32 *key_jump_cmd;
+	LABEL(key_jump_cmd);
+	REFERENCE(pkey_jump_cmd);
 
-	init_sh_desc(desc, HDR_SHARE_SERIAL);
+	SHR_HDR(SHR_SERIAL, 1, 0);
 
 	if (ctx->split_key_len) {
 		/* Skip if already shared */
-		key_jump_cmd = append_jump(desc, JUMP_JSL | JUMP_TEST_ALL |
-					   JUMP_COND_SHRD);
+		pkey_jump_cmd = JUMP(IMM(key_jump_cmd), LOCAL_JUMP, ALL_TRUE,
+				     SHRD);
 
-		append_key_ahash(desc, ctx);
+		append_key_ahash(program, ctx);
 
-		set_jump_tgt_here(desc, key_jump_cmd);
+		SET_LABEL(key_jump_cmd);
+
+		PATCH_JUMP(pkey_jump_cmd, key_jump_cmd);
 	}
 }
 
@@ -254,55 +260,55 @@ static inline void init_sh_desc_key_ahash(u32 *desc, struct caam_hash_ctx *ctx)
  * and write resulting class2 context to seqout, which may be state->caam_ctx
  * or req->result
  */
-static inline void ahash_append_load_str(u32 *desc, int digestsize)
+static inline void ahash_append_load_str(struct program *program,
+					 int digestsize)
 {
 	/* Calculate remaining bytes to read */
-	append_math_add(desc, VARSEQINLEN, SEQINLEN, REG0, CAAM_CMD_SZ);
+	MATHB(SEQINSZ, ADD, MATH0, VSEQINSZ, CAAM_CMD_SZ, 0);
 
 	/* Read remaining bytes */
-	append_seq_fifo_load(desc, 0, FIFOLD_CLASS_CLASS2 | FIFOLD_TYPE_LAST2 |
-			     FIFOLD_TYPE_MSG | KEY_VLF);
+	SEQFIFOLOAD(MSG2, 0, VLF | LAST2);
 
 	/* Store class2 context bytes */
-	append_seq_store(desc, digestsize, LDST_CLASS_2_CCB |
-			 LDST_SRCDST_BYTE_CONTEXT);
+	SEQSTORE(CONTEXT2, 0, digestsize, 0);
 }
 
 /*
  * For ahash update, final and finup, import context, read and write to seqout
  */
-static inline void ahash_ctx_data_to_out(u32 *desc, u32 op, u32 state,
-					 int digestsize,
+static inline void ahash_ctx_data_to_out(struct program *program, u32 op,
+					 u32 state, int digestsize,
 					 struct caam_hash_ctx *ctx)
 {
-	init_sh_desc_key_ahash(desc, ctx);
+	init_sh_desc_key_ahash(program, ctx);
 
 	/* Import context from software */
-	append_cmd(desc, CMD_SEQ_LOAD | LDST_SRCDST_BYTE_CONTEXT |
-		   LDST_CLASS_2_CCB | ctx->ctx_len);
+	SEQLOAD(CONTEXT2, 0, ctx->ctx_len, 0);
 
 	/* Class 2 operation */
-	append_operation(desc, op | state | OP_ALG_ENCRYPT);
+	ALG_OPERATION(op & OP_ALG_ALGSEL_MASK, op & OP_ALG_AAI_MASK, state,
+		      ICV_CHECK_DISABLE, OP_ALG_ENCRYPT);
 
 	/*
 	 * Load from buf and/or src and write to req->result or state->context
 	 */
-	ahash_append_load_str(desc, digestsize);
+	ahash_append_load_str(program, digestsize);
 }
 
 /* For ahash firsts and digest, read and write to seqout */
-static inline void ahash_data_to_out(u32 *desc, u32 op, u32 state,
+static inline void ahash_data_to_out(struct program *program, u32 op, u32 state,
 				     int digestsize, struct caam_hash_ctx *ctx)
 {
-	init_sh_desc_key_ahash(desc, ctx);
+	init_sh_desc_key_ahash(program, ctx);
 
 	/* Class 2 operation */
-	append_operation(desc, op | state | OP_ALG_ENCRYPT);
+	ALG_OPERATION(op & OP_ALG_ALGSEL_MASK, op & OP_ALG_AAI_MASK, state,
+		      ICV_CHECK_DISABLE, OP_ALG_ENCRYPT);
 
 	/*
 	 * Load from buf and/or src and write to req->result or state->context
 	 */
-	ahash_append_load_str(desc, digestsize);
+	ahash_append_load_str(program, digestsize);
 }
 
 static int ahash_set_sh_desc(struct crypto_ahash *ahash)
@@ -311,28 +317,36 @@ static int ahash_set_sh_desc(struct crypto_ahash *ahash)
 	int digestsize = crypto_ahash_digestsize(ahash);
 	struct device *jrdev = ctx->jrdev;
 	u32 have_key = 0;
-	u32 *desc;
+	uint32_t *desc;
+	struct program prg;
+	struct program *program = &prg;
+	bool ps = (sizeof(dma_addr_t) == sizeof(u64));
 
 	if (ctx->split_key_len)
 		have_key = OP_ALG_AAI_HMAC_PRECOMP;
 
 	/* ahash_update shared descriptor */
 	desc = ctx->sh_desc_update;
+	PROGRAM_CNTXT_INIT(desc, 0);
+	if (ps)
+		PROGRAM_SET_36BIT_ADDR();
 
-	init_sh_desc(desc, HDR_SHARE_SERIAL);
+	SHR_HDR(SHR_SERIAL, 1, 0);
 
 	/* Import context from software */
-	append_cmd(desc, CMD_SEQ_LOAD | LDST_SRCDST_BYTE_CONTEXT |
-		   LDST_CLASS_2_CCB | ctx->ctx_len);
+	SEQLOAD(CONTEXT2, 0, ctx->ctx_len, 0);
 
 	/* Class 2 operation */
-	append_operation(desc, ctx->alg_type | OP_ALG_AS_UPDATE |
-			 OP_ALG_ENCRYPT);
+	ALG_OPERATION(ctx->alg_type & OP_ALG_ALGSEL_MASK,
+		      ctx->alg_type & OP_ALG_AAI_MASK, OP_ALG_AS_UPDATE,
+		      ICV_CHECK_DISABLE, OP_ALG_ENCRYPT);
 
 	/* Load data and write to result or context */
-	ahash_append_load_str(desc, ctx->ctx_len);
+	ahash_append_load_str(program, ctx->ctx_len);
+
+	PROGRAM_FINALIZE();
 
-	ctx->sh_desc_update_dma = dma_map_single(jrdev, desc, desc_bytes(desc),
+	ctx->sh_desc_update_dma = dma_map_single(jrdev, desc, DESC_BYTES(desc),
 						 DMA_TO_DEVICE);
 	if (dma_mapping_error(jrdev, ctx->sh_desc_update_dma)) {
 		dev_err(jrdev, "unable to map shared descriptor\n");
@@ -341,17 +355,22 @@ static int ahash_set_sh_desc(struct crypto_ahash *ahash)
 #ifdef DEBUG
 	print_hex_dump(KERN_ERR,
 		       "ahash update shdesc@"__stringify(__LINE__)": ",
-		       DUMP_PREFIX_ADDRESS, 16, 4, desc, desc_bytes(desc), 1);
+		       DUMP_PREFIX_ADDRESS, 16, 4, desc, DESC_BYTES(desc), 1);
 #endif
 
 	/* ahash_update_first shared descriptor */
 	desc = ctx->sh_desc_update_first;
+	PROGRAM_CNTXT_INIT(desc, 0);
+	if (ps)
+		PROGRAM_SET_36BIT_ADDR();
 
-	ahash_data_to_out(desc, have_key | ctx->alg_type, OP_ALG_AS_INIT,
+	ahash_data_to_out(program, have_key | ctx->alg_type, OP_ALG_AS_INIT,
 			  ctx->ctx_len, ctx);
 
+	PROGRAM_FINALIZE();
+
 	ctx->sh_desc_update_first_dma = dma_map_single(jrdev, desc,
-						       desc_bytes(desc),
+						       DESC_BYTES(desc),
 						       DMA_TO_DEVICE);
 	if (dma_mapping_error(jrdev, ctx->sh_desc_update_first_dma)) {
 		dev_err(jrdev, "unable to map shared descriptor\n");
@@ -360,16 +379,21 @@ static int ahash_set_sh_desc(struct crypto_ahash *ahash)
 #ifdef DEBUG
 	print_hex_dump(KERN_ERR,
 		       "ahash update first shdesc@"__stringify(__LINE__)": ",
-		       DUMP_PREFIX_ADDRESS, 16, 4, desc, desc_bytes(desc), 1);
+		       DUMP_PREFIX_ADDRESS, 16, 4, desc, DESC_BYTES(desc), 1);
 #endif
 
 	/* ahash_final shared descriptor */
 	desc = ctx->sh_desc_fin;
+	PROGRAM_CNTXT_INIT(desc, 0);
+	if (ps)
+		PROGRAM_SET_36BIT_ADDR();
 
-	ahash_ctx_data_to_out(desc, have_key | ctx->alg_type,
+	ahash_ctx_data_to_out(program, have_key | ctx->alg_type,
 			      OP_ALG_AS_FINALIZE, digestsize, ctx);
 
-	ctx->sh_desc_fin_dma = dma_map_single(jrdev, desc, desc_bytes(desc),
+	PROGRAM_FINALIZE();
+
+	ctx->sh_desc_fin_dma = dma_map_single(jrdev, desc, DESC_BYTES(desc),
 					      DMA_TO_DEVICE);
 	if (dma_mapping_error(jrdev, ctx->sh_desc_fin_dma)) {
 		dev_err(jrdev, "unable to map shared descriptor\n");
@@ -377,17 +401,21 @@ static int ahash_set_sh_desc(struct crypto_ahash *ahash)
 	}
 #ifdef DEBUG
 	print_hex_dump(KERN_ERR, "ahash final shdesc@"__stringify(__LINE__)": ",
-		       DUMP_PREFIX_ADDRESS, 16, 4, desc,
-		       desc_bytes(desc), 1);
+		       DUMP_PREFIX_ADDRESS, 16, 4, desc, DESC_BYTES(desc), 1);
 #endif
 
 	/* ahash_finup shared descriptor */
 	desc = ctx->sh_desc_finup;
+	PROGRAM_CNTXT_INIT(desc, 0);
+	if (ps)
+		PROGRAM_SET_36BIT_ADDR();
 
-	ahash_ctx_data_to_out(desc, have_key | ctx->alg_type,
+	ahash_ctx_data_to_out(program, have_key | ctx->alg_type,
 			      OP_ALG_AS_FINALIZE, digestsize, ctx);
 
-	ctx->sh_desc_finup_dma = dma_map_single(jrdev, desc, desc_bytes(desc),
+	PROGRAM_FINALIZE();
+
+	ctx->sh_desc_finup_dma = dma_map_single(jrdev, desc, DESC_BYTES(desc),
 						DMA_TO_DEVICE);
 	if (dma_mapping_error(jrdev, ctx->sh_desc_finup_dma)) {
 		dev_err(jrdev, "unable to map shared descriptor\n");
@@ -395,18 +423,21 @@ static int ahash_set_sh_desc(struct crypto_ahash *ahash)
 	}
 #ifdef DEBUG
 	print_hex_dump(KERN_ERR, "ahash finup shdesc@"__stringify(__LINE__)": ",
-		       DUMP_PREFIX_ADDRESS, 16, 4, desc,
-		       desc_bytes(desc), 1);
+		       DUMP_PREFIX_ADDRESS, 16, 4, desc, DESC_BYTES(desc), 1);
 #endif
 
 	/* ahash_digest shared descriptor */
 	desc = ctx->sh_desc_digest;
+	PROGRAM_CNTXT_INIT(desc, 0);
+	if (ps)
+		PROGRAM_SET_36BIT_ADDR();
+
+	ahash_data_to_out(program, have_key | ctx->alg_type,
+			  OP_ALG_AS_INITFINAL, digestsize, ctx);
 
-	ahash_data_to_out(desc, have_key | ctx->alg_type, OP_ALG_AS_INITFINAL,
-			  digestsize, ctx);
+	PROGRAM_FINALIZE();
 
-	ctx->sh_desc_digest_dma = dma_map_single(jrdev, desc,
-						 desc_bytes(desc),
+	ctx->sh_desc_digest_dma = dma_map_single(jrdev, desc, DESC_BYTES(desc),
 						 DMA_TO_DEVICE);
 	if (dma_mapping_error(jrdev, ctx->sh_desc_digest_dma)) {
 		dev_err(jrdev, "unable to map shared descriptor\n");
@@ -415,8 +446,7 @@ static int ahash_set_sh_desc(struct crypto_ahash *ahash)
 #ifdef DEBUG
 	print_hex_dump(KERN_ERR,
 		       "ahash digest shdesc@"__stringify(__LINE__)": ",
-		       DUMP_PREFIX_ADDRESS, 16, 4, desc,
-		       desc_bytes(desc), 1);
+		       DUMP_PREFIX_ADDRESS, 16, 4, desc, DESC_BYTES(desc), 1);
 #endif
 
 	return 0;
@@ -435,10 +465,13 @@ static int hash_digest_key(struct caam_hash_ctx *ctx, const u8 *key_in,
 			   u32 *keylen, u8 *key_out, u32 digestsize)
 {
 	struct device *jrdev = ctx->jrdev;
-	u32 *desc;
+	uint32_t *desc;
 	struct split_key_result result;
 	dma_addr_t src_dma, dst_dma;
 	int ret = 0;
+	struct program prg;
+	struct program *program = &prg;
+	bool ps = (sizeof(dma_addr_t) == sizeof(u64));
 
 	desc = kmalloc(CAAM_CMD_SZ * 8 + CAAM_PTR_SZ * 2, GFP_KERNEL | GFP_DMA);
 	if (!desc) {
@@ -446,7 +479,11 @@ static int hash_digest_key(struct caam_hash_ctx *ctx, const u8 *key_in,
 		return -ENOMEM;
 	}
 
-	init_job_desc(desc, 0);
+	PROGRAM_CNTXT_INIT(desc, 0);
+	if (ps)
+		PROGRAM_SET_36BIT_ADDR();
+
+	JOB_HDR(SHR_NEVER, 0, 0, 0);
 
 	src_dma = dma_map_single(jrdev, (void *)key_in, *keylen,
 				 DMA_TO_DEVICE);
@@ -465,20 +502,21 @@ static int hash_digest_key(struct caam_hash_ctx *ctx, const u8 *key_in,
 	}
 
 	/* Job descriptor to perform unkeyed hash on key_in */
-	append_operation(desc, ctx->alg_type | OP_ALG_ENCRYPT |
-			 OP_ALG_AS_INITFINAL);
-	append_seq_in_ptr(desc, src_dma, *keylen, 0);
-	append_seq_fifo_load(desc, *keylen, FIFOLD_CLASS_CLASS2 |
-			     FIFOLD_TYPE_LAST2 | FIFOLD_TYPE_MSG);
-	append_seq_out_ptr(desc, dst_dma, digestsize, 0);
-	append_seq_store(desc, digestsize, LDST_CLASS_2_CCB |
-			 LDST_SRCDST_BYTE_CONTEXT);
+	ALG_OPERATION(ctx->alg_type & OP_ALG_ALGSEL_MASK,
+		      ctx->alg_type & OP_ALG_AAI_MASK, OP_ALG_AS_INITFINAL,
+		      ICV_CHECK_DISABLE, OP_ALG_ENCRYPT);
+	SEQINPTR(src_dma, *keylen, EXT);
+	SEQFIFOLOAD(MSG2, *keylen, LAST2);
+	SEQOUTPTR(dst_dma, digestsize, EXT);
+	SEQSTORE(CONTEXT2, 0, digestsize, 0);
+
+	PROGRAM_FINALIZE();
 
 #ifdef DEBUG
 	print_hex_dump(KERN_ERR, "key_in@"__stringify(__LINE__)": ",
 		       DUMP_PREFIX_ADDRESS, 16, 4, key_in, *keylen, 1);
 	print_hex_dump(KERN_ERR, "jobdesc@"__stringify(__LINE__)": ",
-		       DUMP_PREFIX_ADDRESS, 16, 4, desc, desc_bytes(desc), 1);
+		       DUMP_PREFIX_ADDRESS, 16, 4, desc, DESC_BYTES(desc), 1);
 #endif
 
 	result.err = 0;
@@ -777,13 +815,16 @@ static int ahash_update_ctx(struct ahash_request *req)
 	int *next_buflen = state->current_buf ? &state->buflen_0 :
 			   &state->buflen_1, last_buflen;
 	int in_len = *buflen + req->nbytes, to_hash;
-	u32 *sh_desc = ctx->sh_desc_update, *desc;
+	uint32_t *sh_desc = ctx->sh_desc_update, *desc;
 	dma_addr_t ptr = ctx->sh_desc_update_dma;
 	int src_nents, sec4_sg_bytes, sec4_sg_src_index;
 	struct ahash_edesc *edesc;
 	bool chained = false;
 	int ret = 0;
-	int sh_len;
+	unsigned sh_len;
+	struct program prg;
+	struct program *program = &prg;
+	bool ps = (sizeof(dma_addr_t) == sizeof(u64));
 
 	last_buflen = *next_buflen;
 	*next_buflen = in_len & (crypto_tfm_alg_blocksize(&ahash->base) - 1);
@@ -838,10 +879,13 @@ static int ahash_update_ctx(struct ahash_request *req)
 							SEC4_SG_LEN_FIN;
 		}
 
-		sh_len = desc_len(sh_desc);
+		sh_len = DESC_LEN(sh_desc);
 		desc = edesc->hw_desc;
-		init_job_desc_shared(desc, ptr, sh_len, HDR_SHARE_DEFER |
-				     HDR_REVERSE);
+		PROGRAM_CNTXT_INIT(desc, sh_len);
+		if (ps)
+			PROGRAM_SET_36BIT_ADDR();
+
+		JOB_HDR(SHR_DEFER, sh_len, ptr, REO | SHR);
 
 		edesc->sec4_sg_dma = dma_map_single(jrdev, edesc->sec4_sg,
 						     sec4_sg_bytes,
@@ -851,15 +895,15 @@ static int ahash_update_ctx(struct ahash_request *req)
 			return -ENOMEM;
 		}
 
-		append_seq_in_ptr(desc, edesc->sec4_sg_dma, ctx->ctx_len +
-				       to_hash, LDST_SGF);
+		SEQINPTR(edesc->sec4_sg_dma, ctx->ctx_len + to_hash, SGF | EXT);
+		SEQOUTPTR(state->ctx_dma, ctx->ctx_len, EXT);
 
-		append_seq_out_ptr(desc, state->ctx_dma, ctx->ctx_len, 0);
+		PROGRAM_FINALIZE();
 
 #ifdef DEBUG
 		print_hex_dump(KERN_ERR, "jobdesc@"__stringify(__LINE__)": ",
 			       DUMP_PREFIX_ADDRESS, 16, 4, desc,
-			       desc_bytes(desc), 1);
+			       DESC_BYTES(desc), 1);
 #endif
 
 		ret = caam_jr_enqueue(jrdev, desc, ahash_done_bi, req);
@@ -898,13 +942,16 @@ static int ahash_final_ctx(struct ahash_request *req)
 	int buflen = state->current_buf ? state->buflen_1 : state->buflen_0;
 	int last_buflen = state->current_buf ? state->buflen_0 :
 			  state->buflen_1;
-	u32 *sh_desc = ctx->sh_desc_fin, *desc;
+	uint32_t *sh_desc = ctx->sh_desc_fin, *desc;
 	dma_addr_t ptr = ctx->sh_desc_fin_dma;
 	int sec4_sg_bytes;
 	int digestsize = crypto_ahash_digestsize(ahash);
 	struct ahash_edesc *edesc;
 	int ret = 0;
-	int sh_len;
+	unsigned sh_len;
+	struct program prg;
+	struct program *program = &prg;
+	bool ps = (sizeof(dma_addr_t) == sizeof(u64));
 
 	sec4_sg_bytes = (1 + (buflen ? 1 : 0)) * sizeof(struct sec4_sg_entry);
 
@@ -916,9 +963,13 @@ static int ahash_final_ctx(struct ahash_request *req)
 		return -ENOMEM;
 	}
 
-	sh_len = desc_len(sh_desc);
+	sh_len = DESC_LEN(sh_desc);
 	desc = edesc->hw_desc;
-	init_job_desc_shared(desc, ptr, sh_len, HDR_SHARE_DEFER | HDR_REVERSE);
+	PROGRAM_CNTXT_INIT(desc, sh_len);
+	if (ps)
+		PROGRAM_SET_36BIT_ADDR();
+
+	JOB_HDR(SHR_DEFER, sh_len, ptr, REO | SHR);
 
 	edesc->sec4_sg_bytes = sec4_sg_bytes;
 	edesc->sec4_sg = (void *)edesc + sizeof(struct ahash_edesc) +
@@ -942,19 +993,20 @@ static int ahash_final_ctx(struct ahash_request *req)
 		return -ENOMEM;
 	}
 
-	append_seq_in_ptr(desc, edesc->sec4_sg_dma, ctx->ctx_len + buflen,
-			  LDST_SGF);
+	SEQINPTR(edesc->sec4_sg_dma, ctx->ctx_len + buflen, SGF | EXT);
 
-	edesc->dst_dma = map_seq_out_ptr_result(desc, jrdev, req->result,
+	edesc->dst_dma = map_seq_out_ptr_result(program, jrdev, req->result,
 						digestsize);
 	if (dma_mapping_error(jrdev, edesc->dst_dma)) {
 		dev_err(jrdev, "unable to map dst\n");
 		return -ENOMEM;
 	}
 
+	PROGRAM_FINALIZE();
+
 #ifdef DEBUG
 	print_hex_dump(KERN_ERR, "jobdesc@"__stringify(__LINE__)": ",
-		       DUMP_PREFIX_ADDRESS, 16, 4, desc, desc_bytes(desc), 1);
+		       DUMP_PREFIX_ADDRESS, 16, 4, desc, DESC_BYTES(desc), 1);
 #endif
 
 	ret = caam_jr_enqueue(jrdev, desc, ahash_done_ctx_src, req);
@@ -980,7 +1032,7 @@ static int ahash_finup_ctx(struct ahash_request *req)
 	int buflen = state->current_buf ? state->buflen_1 : state->buflen_0;
 	int last_buflen = state->current_buf ? state->buflen_0 :
 			  state->buflen_1;
-	u32 *sh_desc = ctx->sh_desc_finup, *desc;
+	uint32_t *sh_desc = ctx->sh_desc_finup, *desc;
 	dma_addr_t ptr = ctx->sh_desc_finup_dma;
 	int sec4_sg_bytes, sec4_sg_src_index;
 	int src_nents;
@@ -988,7 +1040,10 @@ static int ahash_finup_ctx(struct ahash_request *req)
 	struct ahash_edesc *edesc;
 	bool chained = false;
 	int ret = 0;
-	int sh_len;
+	unsigned sh_len;
+	struct program prg;
+	struct program *program = &prg;
+	bool ps = (sizeof(dma_addr_t) == sizeof(u64));
 
 	src_nents = __sg_count(req->src, req->nbytes, &chained);
 	sec4_sg_src_index = 1 + (buflen ? 1 : 0);
@@ -1003,9 +1058,13 @@ static int ahash_finup_ctx(struct ahash_request *req)
 		return -ENOMEM;
 	}
 
-	sh_len = desc_len(sh_desc);
+	sh_len = DESC_LEN(sh_desc);
 	desc = edesc->hw_desc;
-	init_job_desc_shared(desc, ptr, sh_len, HDR_SHARE_DEFER | HDR_REVERSE);
+	PROGRAM_CNTXT_INIT(desc, sh_len);
+	if (ps)
+		PROGRAM_SET_36BIT_ADDR();
+
+	JOB_HDR(SHR_DEFER, sh_len, ptr, REO | SHR);
 
 	edesc->src_nents = src_nents;
 	edesc->chained = chained;
@@ -1032,19 +1091,21 @@ static int ahash_finup_ctx(struct ahash_request *req)
 		return -ENOMEM;
 	}
 
-	append_seq_in_ptr(desc, edesc->sec4_sg_dma, ctx->ctx_len +
-			       buflen + req->nbytes, LDST_SGF);
+	SEQINPTR(edesc->sec4_sg_dma, ctx->ctx_len + buflen + req->nbytes,
+		 SGF | EXT);
 
-	edesc->dst_dma = map_seq_out_ptr_result(desc, jrdev, req->result,
+	edesc->dst_dma = map_seq_out_ptr_result(program, jrdev, req->result,
 						digestsize);
 	if (dma_mapping_error(jrdev, edesc->dst_dma)) {
 		dev_err(jrdev, "unable to map dst\n");
 		return -ENOMEM;
 	}
 
+	PROGRAM_FINALIZE();
+
 #ifdef DEBUG
 	print_hex_dump(KERN_ERR, "jobdesc@"__stringify(__LINE__)": ",
-		       DUMP_PREFIX_ADDRESS, 16, 4, desc, desc_bytes(desc), 1);
+		       DUMP_PREFIX_ADDRESS, 16, 4, desc, DESC_BYTES(desc), 1);
 #endif
 
 	ret = caam_jr_enqueue(jrdev, desc, ahash_done_ctx_src, req);
@@ -1065,7 +1126,7 @@ static int ahash_digest(struct ahash_request *req)
 	struct device *jrdev = ctx->jrdev;
 	gfp_t flags = (req->base.flags & (CRYPTO_TFM_REQ_MAY_BACKLOG |
 		       CRYPTO_TFM_REQ_MAY_SLEEP)) ? GFP_KERNEL : GFP_ATOMIC;
-	u32 *sh_desc = ctx->sh_desc_digest, *desc;
+	uint32_t *sh_desc = ctx->sh_desc_digest, *desc;
 	dma_addr_t ptr = ctx->sh_desc_digest_dma;
 	int digestsize = crypto_ahash_digestsize(ahash);
 	int src_nents, sec4_sg_bytes;
@@ -1073,8 +1134,11 @@ static int ahash_digest(struct ahash_request *req)
 	struct ahash_edesc *edesc;
 	bool chained = false;
 	int ret = 0;
-	u32 options;
-	int sh_len;
+	uint32_t options = EXT;
+	unsigned sh_len;
+	struct program prg;
+	struct program *program = &prg;
+	bool ps = (sizeof(dma_addr_t) == sizeof(u64));
 
 	src_nents = sg_count(req->src, req->nbytes, &chained);
 	dma_map_sg_chained(jrdev, req->src, src_nents ? : 1, DMA_TO_DEVICE,
@@ -1094,9 +1158,13 @@ static int ahash_digest(struct ahash_request *req)
 	edesc->src_nents = src_nents;
 	edesc->chained = chained;
 
-	sh_len = desc_len(sh_desc);
+	sh_len = DESC_LEN(sh_desc);
 	desc = edesc->hw_desc;
-	init_job_desc_shared(desc, ptr, sh_len, HDR_SHARE_DEFER | HDR_REVERSE);
+	PROGRAM_CNTXT_INIT(desc, sh_len);
+	if (ps)
+		PROGRAM_SET_36BIT_ADDR();
+
+	JOB_HDR(SHR_DEFER, sh_len, ptr, REO | SHR);
 
 	if (src_nents) {
 		sg_to_sec4_sg_last(req->src, src_nents, edesc->sec4_sg, 0);
@@ -1107,23 +1175,24 @@ static int ahash_digest(struct ahash_request *req)
 			return -ENOMEM;
 		}
 		src_dma = edesc->sec4_sg_dma;
-		options = LDST_SGF;
+		options |= SGF;
 	} else {
 		src_dma = sg_dma_address(req->src);
-		options = 0;
 	}
-	append_seq_in_ptr(desc, src_dma, req->nbytes, options);
+	SEQINPTR(src_dma, req->nbytes, options);
 
-	edesc->dst_dma = map_seq_out_ptr_result(desc, jrdev, req->result,
+	edesc->dst_dma = map_seq_out_ptr_result(program, jrdev, req->result,
 						digestsize);
 	if (dma_mapping_error(jrdev, edesc->dst_dma)) {
 		dev_err(jrdev, "unable to map dst\n");
 		return -ENOMEM;
 	}
 
+	PROGRAM_FINALIZE();
+
 #ifdef DEBUG
 	print_hex_dump(KERN_ERR, "jobdesc@"__stringify(__LINE__)": ",
-		       DUMP_PREFIX_ADDRESS, 16, 4, desc, desc_bytes(desc), 1);
+		       DUMP_PREFIX_ADDRESS, 16, 4, desc, DESC_BYTES(desc), 1);
 #endif
 
 	ret = caam_jr_enqueue(jrdev, desc, ahash_done, req);
@@ -1148,12 +1217,15 @@ static int ahash_final_no_ctx(struct ahash_request *req)
 		       CRYPTO_TFM_REQ_MAY_SLEEP)) ? GFP_KERNEL : GFP_ATOMIC;
 	u8 *buf = state->current_buf ? state->buf_1 : state->buf_0;
 	int buflen = state->current_buf ? state->buflen_1 : state->buflen_0;
-	u32 *sh_desc = ctx->sh_desc_digest, *desc;
+	uint32_t *sh_desc = ctx->sh_desc_digest, *desc;
 	dma_addr_t ptr = ctx->sh_desc_digest_dma;
 	int digestsize = crypto_ahash_digestsize(ahash);
 	struct ahash_edesc *edesc;
 	int ret = 0;
-	int sh_len;
+	unsigned sh_len;
+	struct program prg;
+	struct program *program = &prg;
+	bool ps = (sizeof(dma_addr_t) == sizeof(u64));
 
 	/* allocate space for base edesc and hw desc commands, link tables */
 	edesc = kmalloc(sizeof(struct ahash_edesc) + DESC_JOB_IO_LEN,
@@ -1163,9 +1235,13 @@ static int ahash_final_no_ctx(struct ahash_request *req)
 		return -ENOMEM;
 	}
 
-	sh_len = desc_len(sh_desc);
+	sh_len = DESC_LEN(sh_desc);
 	desc = edesc->hw_desc;
-	init_job_desc_shared(desc, ptr, sh_len, HDR_SHARE_DEFER | HDR_REVERSE);
+	PROGRAM_CNTXT_INIT(desc, sh_len);
+	if (ps)
+		PROGRAM_SET_36BIT_ADDR();
+
+	JOB_HDR(SHR_DEFER, sh_len, ptr, REO | SHR);
 
 	state->buf_dma = dma_map_single(jrdev, buf, buflen, DMA_TO_DEVICE);
 	if (dma_mapping_error(jrdev, state->buf_dma)) {
@@ -1173,19 +1249,22 @@ static int ahash_final_no_ctx(struct ahash_request *req)
 		return -ENOMEM;
 	}
 
-	append_seq_in_ptr(desc, state->buf_dma, buflen, 0);
+	SEQINPTR(state->buf_dma, buflen, EXT);
 
-	edesc->dst_dma = map_seq_out_ptr_result(desc, jrdev, req->result,
+	edesc->dst_dma = map_seq_out_ptr_result(program, jrdev, req->result,
 						digestsize);
 	if (dma_mapping_error(jrdev, edesc->dst_dma)) {
 		dev_err(jrdev, "unable to map dst\n");
 		return -ENOMEM;
 	}
+
+	PROGRAM_FINALIZE();
+
 	edesc->src_nents = 0;
 
 #ifdef DEBUG
 	print_hex_dump(KERN_ERR, "jobdesc@"__stringify(__LINE__)": ",
-		       DUMP_PREFIX_ADDRESS, 16, 4, desc, desc_bytes(desc), 1);
+		       DUMP_PREFIX_ADDRESS, 16, 4, desc, DESC_BYTES(desc), 1);
 #endif
 
 	ret = caam_jr_enqueue(jrdev, desc, ahash_done, req);
@@ -1216,11 +1295,14 @@ static int ahash_update_no_ctx(struct ahash_request *req)
 	int in_len = *buflen + req->nbytes, to_hash;
 	int sec4_sg_bytes, src_nents;
 	struct ahash_edesc *edesc;
-	u32 *desc, *sh_desc = ctx->sh_desc_update_first;
+	uint32_t *desc, *sh_desc = ctx->sh_desc_update_first;
 	dma_addr_t ptr = ctx->sh_desc_update_first_dma;
 	bool chained = false;
 	int ret = 0;
-	int sh_len;
+	unsigned sh_len;
+	struct program prg;
+	struct program *program = &prg;
+	bool ps = (sizeof(dma_addr_t) == sizeof(u64));
 
 	*next_buflen = in_len & (crypto_tfm_alg_blocksize(&ahash->base) - 1);
 	to_hash = in_len - *next_buflen;
@@ -1260,10 +1342,13 @@ static int ahash_update_no_ctx(struct ahash_request *req)
 			state->current_buf = !state->current_buf;
 		}
 
-		sh_len = desc_len(sh_desc);
+		sh_len = DESC_LEN(sh_desc);
 		desc = edesc->hw_desc;
-		init_job_desc_shared(desc, ptr, sh_len, HDR_SHARE_DEFER |
-				     HDR_REVERSE);
+		PROGRAM_CNTXT_INIT(desc, sh_len);
+		if (ps)
+			PROGRAM_SET_36BIT_ADDR();
+
+		JOB_HDR(SHR_DEFER, sh_len, ptr, REO | SHR);
 
 		edesc->sec4_sg_dma = dma_map_single(jrdev, edesc->sec4_sg,
 						    sec4_sg_bytes,
@@ -1273,16 +1358,18 @@ static int ahash_update_no_ctx(struct ahash_request *req)
 			return -ENOMEM;
 		}
 
-		append_seq_in_ptr(desc, edesc->sec4_sg_dma, to_hash, LDST_SGF);
+		SEQINPTR(edesc->sec4_sg_dma, to_hash, SGF | EXT);
 
-		ret = map_seq_out_ptr_ctx(desc, jrdev, state, ctx->ctx_len);
+		ret = map_seq_out_ptr_ctx(program, jrdev, state, ctx->ctx_len);
 		if (ret)
 			return ret;
 
+		PROGRAM_FINALIZE();
+
 #ifdef DEBUG
 		print_hex_dump(KERN_ERR, "jobdesc@"__stringify(__LINE__)": ",
 			       DUMP_PREFIX_ADDRESS, 16, 4, desc,
-			       desc_bytes(desc), 1);
+			       DESC_BYTES(desc), 1);
 #endif
 
 		ret = caam_jr_enqueue(jrdev, desc, ahash_done_ctx_dst, req);
@@ -1325,14 +1412,17 @@ static int ahash_finup_no_ctx(struct ahash_request *req)
 	int buflen = state->current_buf ? state->buflen_1 : state->buflen_0;
 	int last_buflen = state->current_buf ? state->buflen_0 :
 			  state->buflen_1;
-	u32 *sh_desc = ctx->sh_desc_digest, *desc;
+	uint32_t *sh_desc = ctx->sh_desc_digest, *desc;
 	dma_addr_t ptr = ctx->sh_desc_digest_dma;
 	int sec4_sg_bytes, sec4_sg_src_index, src_nents;
 	int digestsize = crypto_ahash_digestsize(ahash);
 	struct ahash_edesc *edesc;
 	bool chained = false;
-	int sh_len;
+	unsigned sh_len;
 	int ret = 0;
+	struct program prg;
+	struct program *program = &prg;
+	bool ps = (sizeof(dma_addr_t) == sizeof(u64));
 
 	src_nents = __sg_count(req->src, req->nbytes, &chained);
 	sec4_sg_src_index = 2;
@@ -1347,9 +1437,13 @@ static int ahash_finup_no_ctx(struct ahash_request *req)
 		return -ENOMEM;
 	}
 
-	sh_len = desc_len(sh_desc);
+	sh_len = DESC_LEN(sh_desc);
 	desc = edesc->hw_desc;
-	init_job_desc_shared(desc, ptr, sh_len, HDR_SHARE_DEFER | HDR_REVERSE);
+	PROGRAM_CNTXT_INIT(desc, sh_len);
+	if (ps)
+		PROGRAM_SET_36BIT_ADDR();
+
+	JOB_HDR(SHR_DEFER, sh_len, ptr, REO | SHR);
 
 	edesc->src_nents = src_nents;
 	edesc->chained = chained;
@@ -1371,19 +1465,20 @@ static int ahash_finup_no_ctx(struct ahash_request *req)
 		return -ENOMEM;
 	}
 
-	append_seq_in_ptr(desc, edesc->sec4_sg_dma, buflen +
-			       req->nbytes, LDST_SGF);
+	SEQINPTR(edesc->sec4_sg_dma, buflen + req->nbytes, SGF | EXT);
 
-	edesc->dst_dma = map_seq_out_ptr_result(desc, jrdev, req->result,
+	edesc->dst_dma = map_seq_out_ptr_result(program, jrdev, req->result,
 						digestsize);
 	if (dma_mapping_error(jrdev, edesc->dst_dma)) {
 		dev_err(jrdev, "unable to map dst\n");
 		return -ENOMEM;
 	}
 
+	PROGRAM_FINALIZE();
+
 #ifdef DEBUG
 	print_hex_dump(KERN_ERR, "jobdesc@"__stringify(__LINE__)": ",
-		       DUMP_PREFIX_ADDRESS, 16, 4, desc, desc_bytes(desc), 1);
+		       DUMP_PREFIX_ADDRESS, 16, 4, desc, DESC_BYTES(desc), 1);
 #endif
 
 	ret = caam_jr_enqueue(jrdev, desc, ahash_done, req);
@@ -1410,15 +1505,18 @@ static int ahash_update_first(struct ahash_request *req)
 		       CAAM_MAX_HASH_BLOCK_SIZE;
 	int *next_buflen = &state->buflen_0 + state->current_buf;
 	int to_hash;
-	u32 *sh_desc = ctx->sh_desc_update_first, *desc;
+	uint32_t *sh_desc = ctx->sh_desc_update_first, *desc;
 	dma_addr_t ptr = ctx->sh_desc_update_first_dma;
 	int sec4_sg_bytes, src_nents;
 	dma_addr_t src_dma;
-	u32 options;
+	uint32_t options = EXT;
 	struct ahash_edesc *edesc;
 	bool chained = false;
 	int ret = 0;
-	int sh_len;
+	unsigned sh_len;
+	struct program prg;
+	struct program *program = &prg;
+	bool ps = (sizeof(dma_addr_t) == sizeof(u64));
 
 	*next_buflen = req->nbytes & (crypto_tfm_alg_blocksize(&ahash->base) -
 				      1);
@@ -1462,30 +1560,34 @@ static int ahash_update_first(struct ahash_request *req)
 				return -ENOMEM;
 			}
 			src_dma = edesc->sec4_sg_dma;
-			options = LDST_SGF;
+			options |= SGF;
 		} else {
 			src_dma = sg_dma_address(req->src);
-			options = 0;
 		}
 
 		if (*next_buflen)
 			sg_copy_part(next_buf, req->src, to_hash, req->nbytes);
 
-		sh_len = desc_len(sh_desc);
+		sh_len = DESC_LEN(sh_desc);
 		desc = edesc->hw_desc;
-		init_job_desc_shared(desc, ptr, sh_len, HDR_SHARE_DEFER |
-				     HDR_REVERSE);
+		PROGRAM_CNTXT_INIT(desc, sh_len);
+		if (ps)
+			PROGRAM_SET_36BIT_ADDR();
+
+		JOB_HDR(SHR_DEFER, sh_len, ptr, REO | SHR);
 
-		append_seq_in_ptr(desc, src_dma, to_hash, options);
+		SEQINPTR(src_dma, to_hash, options);
 
-		ret = map_seq_out_ptr_ctx(desc, jrdev, state, ctx->ctx_len);
+		ret = map_seq_out_ptr_ctx(program, jrdev, state, ctx->ctx_len);
 		if (ret)
 			return ret;
 
+		PROGRAM_FINALIZE();
+
 #ifdef DEBUG
 		print_hex_dump(KERN_ERR, "jobdesc@"__stringify(__LINE__)": ",
 			       DUMP_PREFIX_ADDRESS, 16, 4, desc,
-			       desc_bytes(desc), 1);
+			       DESC_BYTES(desc), 1);
 #endif
 
 		ret = caam_jr_enqueue(jrdev, desc, ahash_done_ctx_dst,
@@ -1779,26 +1881,26 @@ static void caam_hash_cra_exit(struct crypto_tfm *tfm)
 	if (ctx->sh_desc_update_dma &&
 	    !dma_mapping_error(ctx->jrdev, ctx->sh_desc_update_dma))
 		dma_unmap_single(ctx->jrdev, ctx->sh_desc_update_dma,
-				 desc_bytes(ctx->sh_desc_update),
+				 DESC_BYTES(ctx->sh_desc_update),
 				 DMA_TO_DEVICE);
 	if (ctx->sh_desc_update_first_dma &&
 	    !dma_mapping_error(ctx->jrdev, ctx->sh_desc_update_first_dma))
 		dma_unmap_single(ctx->jrdev, ctx->sh_desc_update_first_dma,
-				 desc_bytes(ctx->sh_desc_update_first),
+				 DESC_BYTES(ctx->sh_desc_update_first),
 				 DMA_TO_DEVICE);
 	if (ctx->sh_desc_fin_dma &&
 	    !dma_mapping_error(ctx->jrdev, ctx->sh_desc_fin_dma))
 		dma_unmap_single(ctx->jrdev, ctx->sh_desc_fin_dma,
-				 desc_bytes(ctx->sh_desc_fin), DMA_TO_DEVICE);
+				 DESC_BYTES(ctx->sh_desc_fin), DMA_TO_DEVICE);
 	if (ctx->sh_desc_digest_dma &&
 	    !dma_mapping_error(ctx->jrdev, ctx->sh_desc_digest_dma))
 		dma_unmap_single(ctx->jrdev, ctx->sh_desc_digest_dma,
-				 desc_bytes(ctx->sh_desc_digest),
+				 DESC_BYTES(ctx->sh_desc_digest),
 				 DMA_TO_DEVICE);
 	if (ctx->sh_desc_finup_dma &&
 	    !dma_mapping_error(ctx->jrdev, ctx->sh_desc_finup_dma))
 		dma_unmap_single(ctx->jrdev, ctx->sh_desc_finup_dma,
-				 desc_bytes(ctx->sh_desc_finup), DMA_TO_DEVICE);
+				 DESC_BYTES(ctx->sh_desc_finup), DMA_TO_DEVICE);
 
 	caam_jr_free(ctx->jrdev);
 }
diff --git a/drivers/crypto/caam/caamrng.c b/drivers/crypto/caam/caamrng.c
index 5b288082e6ac..5bcfb1a1d584 100644
--- a/drivers/crypto/caam/caamrng.c
+++ b/drivers/crypto/caam/caamrng.c
@@ -39,7 +39,7 @@
 
 #include "regs.h"
 #include "intern.h"
-#include "desc_constr.h"
+#include "flib/rta.h"
 #include "jr.h"
 #include "error.h"
 
@@ -91,7 +91,7 @@ static inline void rng_unmap_ctx(struct caam_rng_ctx *ctx)
 
 	if (ctx->sh_desc_dma)
 		dma_unmap_single(jrdev, ctx->sh_desc_dma,
-				 desc_bytes(ctx->sh_desc), DMA_TO_DEVICE);
+				 DESC_BYTES(ctx->sh_desc), DMA_TO_DEVICE);
 	rng_unmap_buf(jrdev, &ctx->bufs[0]);
 	rng_unmap_buf(jrdev, &ctx->bufs[1]);
 }
@@ -188,17 +188,26 @@ static int caam_read(struct hwrng *rng, void *data, size_t max, bool wait)
 static inline int rng_create_sh_desc(struct caam_rng_ctx *ctx)
 {
 	struct device *jrdev = ctx->jrdev;
-	u32 *desc = ctx->sh_desc;
+	uint32_t *desc = ctx->sh_desc;
+	struct program prg;
+	struct program *program = &prg;
+	bool ps = (sizeof(dma_addr_t) == sizeof(u64));
 
-	init_sh_desc(desc, HDR_SHARE_SERIAL);
+	PROGRAM_CNTXT_INIT(desc, 0);
+	if (ps)
+		PROGRAM_SET_36BIT_ADDR();
+
+	SHR_HDR(SHR_SERIAL, 1, 0);
 
 	/* Generate random bytes */
-	append_operation(desc, OP_ALG_ALGSEL_RNG | OP_TYPE_CLASS1_ALG);
+	ALG_OPERATION(OP_ALG_ALGSEL_RNG, OP_ALG_AAI_RNG, 0, 0, 0);
 
 	/* Store bytes */
-	append_seq_fifo_store(desc, RN_BUF_SIZE, FIFOST_TYPE_RNGSTORE);
+	SEQFIFOSTORE(RNG, 0, RN_BUF_SIZE, 0);
+
+	PROGRAM_FINALIZE();
 
-	ctx->sh_desc_dma = dma_map_single(jrdev, desc, desc_bytes(desc),
+	ctx->sh_desc_dma = dma_map_single(jrdev, desc, DESC_BYTES(desc),
 					  DMA_TO_DEVICE);
 	if (dma_mapping_error(jrdev, ctx->sh_desc_dma)) {
 		dev_err(jrdev, "unable to map shared descriptor\n");
@@ -206,7 +215,7 @@ static inline int rng_create_sh_desc(struct caam_rng_ctx *ctx)
 	}
 #ifdef DEBUG
 	print_hex_dump(KERN_ERR, "rng shdesc@: ", DUMP_PREFIX_ADDRESS, 16, 4,
-		       desc, desc_bytes(desc), 1);
+		       desc, DESC_BYTES(desc), 1);
 #endif
 	return 0;
 }
@@ -215,11 +224,17 @@ static inline int rng_create_job_desc(struct caam_rng_ctx *ctx, int buf_id)
 {
 	struct device *jrdev = ctx->jrdev;
 	struct buf_data *bd = &ctx->bufs[buf_id];
-	u32 *desc = bd->hw_desc;
-	int sh_len = desc_len(ctx->sh_desc);
+	uint32_t *desc = bd->hw_desc;
+	unsigned sh_len = DESC_LEN(ctx->sh_desc);
+	struct program prg;
+	struct program *program = &prg;
+	bool ps = (sizeof(dma_addr_t) == sizeof(u64));
 
-	init_job_desc_shared(desc, ctx->sh_desc_dma, sh_len, HDR_SHARE_DEFER |
-			     HDR_REVERSE);
+	PROGRAM_CNTXT_INIT(desc, sh_len);
+	if (ps)
+		PROGRAM_SET_36BIT_ADDR();
+
+	JOB_HDR(SHR_DEFER, sh_len, ctx->sh_desc_dma, REO | SHR);
 
 	bd->addr = dma_map_single(jrdev, bd->buf, RN_BUF_SIZE, DMA_FROM_DEVICE);
 	if (dma_mapping_error(jrdev, bd->addr)) {
@@ -227,10 +242,13 @@ static inline int rng_create_job_desc(struct caam_rng_ctx *ctx, int buf_id)
 		return -ENOMEM;
 	}
 
-	append_seq_out_ptr_intlen(desc, bd->addr, RN_BUF_SIZE, 0);
+	SEQOUTPTR(bd->addr, RN_BUF_SIZE, 0);
+
+	PROGRAM_FINALIZE();
+
 #ifdef DEBUG
 	print_hex_dump(KERN_ERR, "rng job desc@: ", DUMP_PREFIX_ADDRESS, 16, 4,
-		       desc, desc_bytes(desc), 1);
+		       desc, DESC_BYTES(desc), 1);
 #endif
 	return 0;
 }
diff --git a/drivers/crypto/caam/compat.h b/drivers/crypto/caam/compat.h
index f227922cea38..8fe0f6993ab0 100644
--- a/drivers/crypto/caam/compat.h
+++ b/drivers/crypto/caam/compat.h
@@ -23,6 +23,7 @@
 #include <linux/types.h>
 #include <linux/debugfs.h>
 #include <linux/circ_buf.h>
+#include <linux/bitops.h>
 #include <net/xfrm.h>
 
 #include <crypto/algapi.h>
diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index be8c6c147395..155268ce9388 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -13,25 +13,34 @@
 #include "regs.h"
 #include "intern.h"
 #include "jr.h"
-#include "desc_constr.h"
+#include "flib/rta.h"
 #include "error.h"
 #include "ctrl.h"
 
+enum rta_sec_era rta_sec_era;
+EXPORT_SYMBOL(rta_sec_era);
+
 /*
  * Descriptor to instantiate RNG State Handle 0 in normal mode and
  * load the JDKEK, TDKEK and TDSK registers
  */
-static void build_instantiation_desc(u32 *desc, int handle, int do_sk)
+static void build_instantiation_desc(uint32_t *desc, int handle, int do_sk)
 {
-	u32 *jump_cmd, op_flags;
-
-	init_job_desc(desc, 0);
+	struct program prg;
+	struct program *program = &prg;
+	bool ps = (sizeof(uint32_t) == sizeof(dma_addr_t));
+	LABEL(jump_cmd);
+	REFERENCE(pjump_cmd);
 
-	op_flags = OP_TYPE_CLASS1_ALG | OP_ALG_ALGSEL_RNG |
-			(handle << OP_ALG_AAI_SHIFT) | OP_ALG_AS_INIT;
+	PROGRAM_CNTXT_INIT(desc, 0);
+	if (ps)
+		PROGRAM_SET_36BIT_ADDR();
 
 	/* INIT RNG in non-test mode */
-	append_operation(desc, op_flags);
+	ALG_OPERATION(OP_ALG_ALGSEL_RNG,
+		      (uint16_t)(OP_ALG_AAI_RNG |
+				 (handle << OP_ALG_AAI_RNG4_SH_SHIFT)),
+		      OP_ALG_AS_INIT, 0, 0);
 
 	if (!handle && do_sk) {
 		/*
@@ -39,33 +48,50 @@ static void build_instantiation_desc(u32 *desc, int handle, int do_sk)
 		 */
 
 		/* wait for done */
-		jump_cmd = append_jump(desc, JUMP_CLASS_CLASS1);
-		set_jump_tgt_here(desc, jump_cmd);
+		pjump_cmd = JUMP(IMM(jump_cmd), LOCAL_JUMP, ALL_TRUE, CLASS1);
+		SET_LABEL(jump_cmd);
 
 		/*
 		 * load 1 to clear written reg:
 		 * resets the done interrrupt and returns the RNG to idle.
 		 */
-		append_load_imm_u32(desc, 1, LDST_SRCDST_WORD_CLRW);
+		LOAD(IMM(CLRW_CLR_C1MODE), CLRW, 0, CAAM_CMD_SZ, 0);
 
 		/* Initialize State Handle  */
-		append_operation(desc, OP_TYPE_CLASS1_ALG | OP_ALG_ALGSEL_RNG |
-				 OP_ALG_AAI_RNG4_SK);
+		ALG_OPERATION(OP_ALG_ALGSEL_RNG, OP_ALG_AAI_RNG4_SK,
+			      OP_ALG_AS_UPDATE, 0, 0);
 	}
 
-	append_jump(desc, JUMP_CLASS_CLASS1 | JUMP_TYPE_HALT);
+	JUMP(IMM(0), HALT, ALL_TRUE, CLASS1);
+
+	PATCH_JUMP(pjump_cmd, jump_cmd);
+
+	PROGRAM_FINALIZE();
 }
 
 /* Descriptor for deinstantiation of State Handle 0 of the RNG block. */
-static void build_deinstantiation_desc(u32 *desc, int handle)
+static void build_deinstantiation_desc(uint32_t *desc, int handle)
 {
-	init_job_desc(desc, 0);
+	struct program prg;
+	struct program *program = &prg;
+	bool ps = (sizeof(uint32_t) == sizeof(dma_addr_t));
+
+
+	PROGRAM_CNTXT_INIT(desc, 0);
+	if (ps)
+		PROGRAM_SET_36BIT_ADDR();
+
+	JOB_HDR(SHR_NEVER, 1, 0, 0);
 
 	/* Uninstantiate State Handle 0 */
-	append_operation(desc, OP_TYPE_CLASS1_ALG | OP_ALG_ALGSEL_RNG |
-			 (handle << OP_ALG_AAI_SHIFT) | OP_ALG_AS_INITFINAL);
+	ALG_OPERATION(OP_ALG_ALGSEL_RNG,
+		      (uint16_t)(OP_ALG_AAI_RNG |
+				 (handle << OP_ALG_AAI_RNG4_SH_SHIFT)),
+		      OP_ALG_AS_INITFINAL, 0, 0);
+
+	JUMP(IMM(0), HALT, ALL_TRUE, CLASS1);
 
-	append_jump(desc, JUMP_CLASS_CLASS1 | JUMP_TYPE_HALT);
+	PROGRAM_FINALIZE();
 }
 
 /*
@@ -109,7 +135,7 @@ static inline int run_descriptor_deco0(struct device *ctrldev, u32 *desc,
 		return -ENODEV;
 	}
 
-	for (i = 0; i < desc_len(desc); i++)
+	for (i = 0; i < DESC_LEN(desc); i++)
 		wr_reg32(&topregs->deco.descbuf[i], *(desc + i));
 
 	flags = DECO_JQCR_WHL;
@@ -117,7 +143,7 @@ static inline int run_descriptor_deco0(struct device *ctrldev, u32 *desc,
 	 * If the descriptor length is longer than 4 words, then the
 	 * FOUR bit in JRCTRL register must be set.
 	 */
-	if (desc_len(desc) >= 4)
+	if (DESC_LEN(desc) >= 4)
 		flags |= DECO_JQCR_FOUR;
 
 	/* Instruct the DECO to execute it */
@@ -176,7 +202,8 @@ static int instantiate_rng(struct device *ctrldev, int state_handle_mask,
 	struct caam_drv_private *ctrlpriv = dev_get_drvdata(ctrldev);
 	struct caam_full __iomem *topregs;
 	struct rng4tst __iomem *r4tst;
-	u32 *desc, status, rdsta_val;
+	uint32_t *desc;
+	u32 status, rdsta_val;
 	int ret = 0, sh_idx;
 
 	topregs = (struct caam_full __iomem *)ctrlpriv->ctrl;
@@ -241,7 +268,8 @@ static int instantiate_rng(struct device *ctrldev, int state_handle_mask,
  */
 static int deinstantiate_rng(struct device *ctrldev, int state_handle_mask)
 {
-	u32 *desc, status;
+	uint32_t *desc;
+	u32 status;
 	int sh_idx, ret = 0;
 
 	desc = kmalloc(CAAM_CMD_SZ * 3, GFP_KERNEL);
@@ -362,8 +390,9 @@ static void kick_trng(struct platform_device *pdev, int ent_delay)
 /**
  * caam_get_era() - Return the ERA of the SEC on SoC, based
  * on "sec-era" propery in the DTS. This property is updated by u-boot.
+ * Returns the ERA number or -ENOTSUPP if the ERA is unknown.
  **/
-int caam_get_era(void)
+static int caam_get_era(void)
 {
 	struct device_node *caam_node;
 
@@ -378,7 +407,6 @@ int caam_get_era(void)
 
 	return -ENOTSUPP;
 }
-EXPORT_SYMBOL(caam_get_era);
 
 /* Probe routine for CAAM top (controller) level */
 static int caam_probe(struct platform_device *pdev)
@@ -579,8 +607,16 @@ static int caam_probe(struct platform_device *pdev)
 		  (u64)rd_reg32(&topregs->ctrl.perfmon.caam_id_ls);
 
 	/* Report "alive" for developer to see */
-	dev_info(dev, "device ID = 0x%016llx (Era %d)\n", caam_id,
-		 caam_get_era());
+	dev_info(dev, "device ID = 0x%016llx\n", caam_id);
+	ret = caam_get_era();
+	if (ret >= 0) {
+		dev_info(dev, "Era %d\n", ret);
+		rta_set_sec_era(INTL_SEC_ERA(ret));
+	} else {
+		dev_warn(dev, "Era property not found! Defaulting to era %d\n",
+			 USER_SEC_ERA(DEFAULT_SEC_ERA));
+		rta_set_sec_era(DEFAULT_SEC_ERA);
+	}
 	dev_info(dev, "job rings = %d, qi = %d\n",
 		 ctrlpriv->total_jobrs, ctrlpriv->qi_present);
 
diff --git a/drivers/crypto/caam/ctrl.h b/drivers/crypto/caam/ctrl.h
index cac5402a46eb..93680a9290db 100644
--- a/drivers/crypto/caam/ctrl.h
+++ b/drivers/crypto/caam/ctrl.h
@@ -8,6 +8,6 @@
 #define CTRL_H
 
 /* Prototypes for backend-level services exposed to APIs */
-int caam_get_era(void);
+extern enum rta_sec_era rta_sec_era;
 
 #endif /* CTRL_H */
diff --git a/drivers/crypto/caam/error.c b/drivers/crypto/caam/error.c
index 7d6ed4722345..5daa9cd4109a 100644
--- a/drivers/crypto/caam/error.c
+++ b/drivers/crypto/caam/error.c
@@ -7,7 +7,7 @@
 #include "compat.h"
 #include "regs.h"
 #include "intern.h"
-#include "desc.h"
+#include "flib/desc.h"
 #include "jr.h"
 #include "error.h"
 
diff --git a/drivers/crypto/caam/jr.c b/drivers/crypto/caam/jr.c
index ec3652d62e93..01d434e20ca4 100644
--- a/drivers/crypto/caam/jr.c
+++ b/drivers/crypto/caam/jr.c
@@ -11,7 +11,7 @@
 #include "compat.h"
 #include "regs.h"
 #include "jr.h"
-#include "desc.h"
+#include "flib/desc.h"
 #include "intern.h"
 
 struct jr_driver_data {
diff --git a/drivers/crypto/caam/key_gen.c b/drivers/crypto/caam/key_gen.c
index 871703c49d2c..bbd784cb9ce2 100644
--- a/drivers/crypto/caam/key_gen.c
+++ b/drivers/crypto/caam/key_gen.c
@@ -7,7 +7,7 @@
 #include "compat.h"
 #include "jr.h"
 #include "error.h"
-#include "desc_constr.h"
+#include "flib/desc/jobdesc.h"
 #include "key_gen.h"
 
 void split_key_done(struct device *dev, u32 *desc, u32 err,
@@ -43,12 +43,14 @@ Split key generation-----------------------------------------------
 */
 int gen_split_key(struct device *jrdev, u8 *key_out, int split_key_len,
 		  int split_key_pad_len, const u8 *key_in, u32 keylen,
-		  u32 alg_op)
+		  uint32_t alg_op)
 {
-	u32 *desc;
+	uint32_t *desc;
 	struct split_key_result result;
 	dma_addr_t dma_addr_in, dma_addr_out;
 	int ret = 0;
+	unsigned jd_len;
+	bool ps = (sizeof(dma_addr_t) == sizeof(u64));
 
 	desc = kmalloc(CAAM_CMD_SZ * 6 + CAAM_PTR_SZ * 2, GFP_KERNEL | GFP_DMA);
 	if (!desc) {
@@ -56,8 +58,6 @@ int gen_split_key(struct device *jrdev, u8 *key_out, int split_key_len,
 		return -ENOMEM;
 	}
 
-	init_job_desc(desc, 0);
-
 	dma_addr_in = dma_map_single(jrdev, (void *)key_in, keylen,
 				     DMA_TO_DEVICE);
 	if (dma_mapping_error(jrdev, dma_addr_in)) {
@@ -65,22 +65,7 @@ int gen_split_key(struct device *jrdev, u8 *key_out, int split_key_len,
 		kfree(desc);
 		return -ENOMEM;
 	}
-	append_key(desc, dma_addr_in, keylen, CLASS_2 | KEY_DEST_CLASS_REG);
-
-	/* Sets MDHA up into an HMAC-INIT */
-	append_operation(desc, alg_op | OP_ALG_DECRYPT | OP_ALG_AS_INIT);
-
-	/*
-	 * do a FIFO_LOAD of zero, this will trigger the internal key expansion
-	 * into both pads inside MDHA
-	 */
-	append_fifo_load_as_imm(desc, NULL, 0, LDST_CLASS_2_CCB |
-				FIFOLD_TYPE_MSG | FIFOLD_TYPE_LAST2);
-
-	/*
-	 * FIFO_STORE with the explicit split-key content store
-	 * (0x26 output type)
-	 */
+
 	dma_addr_out = dma_map_single(jrdev, key_out, split_key_pad_len,
 				      DMA_FROM_DEVICE);
 	if (dma_mapping_error(jrdev, dma_addr_out)) {
@@ -88,14 +73,17 @@ int gen_split_key(struct device *jrdev, u8 *key_out, int split_key_len,
 		kfree(desc);
 		return -ENOMEM;
 	}
-	append_fifo_store(desc, dma_addr_out, split_key_len,
-			  LDST_CLASS_2_CCB | FIFOST_TYPE_SPLIT_KEK);
+
+	/* keylen is expected to be less or equal block size (which is <=64) */
+	cnstr_jobdesc_mdsplitkey(desc, &jd_len, ps, dma_addr_in,
+				 (uint8_t)keylen, alg_op & OP_ALG_ALGSEL_MASK,
+				 dma_addr_out);
 
 #ifdef DEBUG
 	print_hex_dump(KERN_ERR, "ctx.key@"__stringify(__LINE__)": ",
 		       DUMP_PREFIX_ADDRESS, 16, 4, key_in, keylen, 1);
 	print_hex_dump(KERN_ERR, "jobdesc@"__stringify(__LINE__)": ",
-		       DUMP_PREFIX_ADDRESS, 16, 4, desc, desc_bytes(desc), 1);
+		       DUMP_PREFIX_ADDRESS, 16, 4, desc, DESC_BYTES(desc), 1);
 #endif
 
 	result.err = 0;
diff --git a/drivers/crypto/caam/key_gen.h b/drivers/crypto/caam/key_gen.h
index c5588f6d8109..2f719d80cdcd 100644
--- a/drivers/crypto/caam/key_gen.h
+++ b/drivers/crypto/caam/key_gen.h
@@ -14,4 +14,4 @@ void split_key_done(struct device *dev, u32 *desc, u32 err, void *context);
 
 int gen_split_key(struct device *jrdev, u8 *key_out, int split_key_len,
 		    int split_key_pad_len, const u8 *key_in, u32 keylen,
-		    u32 alg_op);
+		    uint32_t alg_op);
-- 
1.8.3.1
