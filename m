From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 10/24] crypto: caam - Remove unnecessary reference to crt_aead
Date: Mon, 11 May 2015 17:47:50 +0800
Message-ID: <E1YrkJS-0001Bk-NU@gondolin.me.apana.org.au>
References: <20150511094444.GA4260@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:51549 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752992AbbEKJrz (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 11 May 2015 05:47:55 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1YrkJT-0000GT-Om
	for <linux-crypto@vger.kernel.org>; Mon, 11 May 2015 19:47:52 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

crt_aead is an internal implementation detail and must not be
used outside of the crypto API itself.  This patch replaces the
unnecessary uses of crt_aead with crypto_aead_ivsize.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/crypto/caam/caamalg.c |   96 +++++++++++++++++++++---------------------
 1 file changed, 48 insertions(+), 48 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index 3c025d4..a34fc95 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -258,7 +258,7 @@ static void init_sh_desc_key_aead(u32 *desc, struct caam_ctx *ctx,
 
 static int aead_null_set_sh_desc(struct crypto_aead *aead)
 {
-	struct aead_tfm *tfm = &aead->base.crt_aead;
+	unsigned int ivsize = crypto_aead_ivsize(aead);
 	struct caam_ctx *ctx = crypto_aead_ctx(aead);
 	struct device *jrdev = ctx->jrdev;
 	bool keys_fit_inline = false;
@@ -383,7 +383,7 @@ static int aead_null_set_sh_desc(struct crypto_aead *aead)
 
 	/* assoclen + cryptlen = seqinlen - ivsize - authsize */
 	append_math_sub_imm_u32(desc, REG3, SEQINLEN, IMM,
-				ctx->authsize + tfm->ivsize);
+				ctx->authsize + ivsize);
 	/* assoclen = (assoclen + cryptlen) - cryptlen */
 	append_math_sub(desc, REG2, SEQOUTLEN, REG0, CAAM_CMD_SZ);
 	append_math_sub(desc, VARSEQINLEN, REG3, REG2, CAAM_CMD_SZ);
@@ -449,7 +449,7 @@ static int aead_null_set_sh_desc(struct crypto_aead *aead)
 
 static int aead_set_sh_desc(struct crypto_aead *aead)
 {
-	struct aead_tfm *tfm = &aead->base.crt_aead;
+	unsigned int ivsize = crypto_aead_ivsize(aead);
 	struct caam_ctx *ctx = crypto_aead_ctx(aead);
 	struct crypto_tfm *ctfm = crypto_aead_tfm(aead);
 	const char *alg_name = crypto_tfm_alg_name(ctfm);
@@ -510,7 +510,7 @@ static int aead_set_sh_desc(struct crypto_aead *aead)
 	append_math_sub_imm_u32(desc, REG3, SEQOUTLEN, IMM, ctx->authsize);
 
 	/* assoclen + cryptlen = seqinlen - ivsize */
-	append_math_sub_imm_u32(desc, REG2, SEQINLEN, IMM, tfm->ivsize);
+	append_math_sub_imm_u32(desc, REG2, SEQINLEN, IMM, ivsize);
 
 	/* assoclen = (assoclen + cryptlen) - cryptlen */
 	append_math_sub(desc, VARSEQINLEN, REG2, REG3, CAAM_CMD_SZ);
@@ -518,7 +518,7 @@ static int aead_set_sh_desc(struct crypto_aead *aead)
 	/* read assoc before reading payload */
 	append_seq_fifo_load(desc, 0, FIFOLD_CLASS_CLASS2 | FIFOLD_TYPE_MSG |
 			     KEY_VLF);
-	aead_append_ld_iv(desc, tfm->ivsize, ctx1_iv_off);
+	aead_append_ld_iv(desc, ivsize, ctx1_iv_off);
 
 	/* Load Counter into CONTEXT1 reg */
 	if (is_rfc3686)
@@ -577,7 +577,7 @@ static int aead_set_sh_desc(struct crypto_aead *aead)
 
 	/* assoclen + cryptlen = seqinlen - ivsize - authsize */
 	append_math_sub_imm_u32(desc, REG3, SEQINLEN, IMM,
-				ctx->authsize + tfm->ivsize);
+				ctx->authsize + ivsize);
 	/* assoclen = (assoclen + cryptlen) - cryptlen */
 	append_math_sub(desc, REG2, SEQOUTLEN, REG0, CAAM_CMD_SZ);
 	append_math_sub(desc, VARSEQINLEN, REG3, REG2, CAAM_CMD_SZ);
@@ -586,7 +586,7 @@ static int aead_set_sh_desc(struct crypto_aead *aead)
 	append_seq_fifo_load(desc, 0, FIFOLD_CLASS_CLASS2 | FIFOLD_TYPE_MSG |
 			     KEY_VLF);
 
-	aead_append_ld_iv(desc, tfm->ivsize, ctx1_iv_off);
+	aead_append_ld_iv(desc, ivsize, ctx1_iv_off);
 
 	/* Load Counter into CONTEXT1 reg */
 	if (is_rfc3686)
@@ -645,20 +645,20 @@ static int aead_set_sh_desc(struct crypto_aead *aead)
 	/* Generate IV */
 	geniv = NFIFOENTRY_STYPE_PAD | NFIFOENTRY_DEST_DECO |
 		NFIFOENTRY_DTYPE_MSG | NFIFOENTRY_LC1 |
-		NFIFOENTRY_PTYPE_RND | (tfm->ivsize << NFIFOENTRY_DLEN_SHIFT);
+		NFIFOENTRY_PTYPE_RND | (ivsize << NFIFOENTRY_DLEN_SHIFT);
 	append_load_imm_u32(desc, geniv, LDST_CLASS_IND_CCB |
 			    LDST_SRCDST_WORD_INFO_FIFO | LDST_IMM);
 	append_cmd(desc, CMD_LOAD | DISABLE_AUTO_INFO_FIFO);
 	append_move(desc, MOVE_WAITCOMP |
 		    MOVE_SRC_INFIFO | MOVE_DEST_CLASS1CTX |
 		    (ctx1_iv_off << MOVE_OFFSET_SHIFT) |
-		    (tfm->ivsize << MOVE_LEN_SHIFT));
+		    (ivsize << MOVE_LEN_SHIFT));
 	append_cmd(desc, CMD_LOAD | ENABLE_AUTO_INFO_FIFO);
 
 	/* Copy IV to class 1 context */
 	append_move(desc, MOVE_SRC_CLASS1CTX | MOVE_DEST_OUTFIFO |
 		    (ctx1_iv_off << MOVE_OFFSET_SHIFT) |
-		    (tfm->ivsize << MOVE_LEN_SHIFT));
+		    (ivsize << MOVE_LEN_SHIFT));
 
 	/* Return to encryption */
 	append_operation(desc, ctx->class2_alg_type |
@@ -676,10 +676,10 @@ static int aead_set_sh_desc(struct crypto_aead *aead)
 
 	/* Copy iv from outfifo to class 2 fifo */
 	moveiv = NFIFOENTRY_STYPE_OFIFO | NFIFOENTRY_DEST_CLASS2 |
-		 NFIFOENTRY_DTYPE_MSG | (tfm->ivsize << NFIFOENTRY_DLEN_SHIFT);
+		 NFIFOENTRY_DTYPE_MSG | (ivsize << NFIFOENTRY_DLEN_SHIFT);
 	append_load_imm_u32(desc, moveiv, LDST_CLASS_IND_CCB |
 			    LDST_SRCDST_WORD_INFO_FIFO | LDST_IMM);
-	append_load_imm_u32(desc, tfm->ivsize, LDST_CLASS_2_CCB |
+	append_load_imm_u32(desc, ivsize, LDST_CLASS_2_CCB |
 			    LDST_SRCDST_WORD_DATASZ_REG | LDST_IMM);
 
 	/* Load Counter into CONTEXT1 reg */
@@ -698,7 +698,7 @@ static int aead_set_sh_desc(struct crypto_aead *aead)
 	append_math_add(desc, VARSEQOUTLEN, SEQINLEN, REG0, CAAM_CMD_SZ);
 
 	/* Not need to reload iv */
-	append_seq_fifo_load(desc, tfm->ivsize,
+	append_seq_fifo_load(desc, ivsize,
 			     FIFOLD_CLASS_SKIP);
 
 	/* Will read cryptlen */
@@ -738,7 +738,7 @@ static int aead_setauthsize(struct crypto_aead *authenc,
 
 static int gcm_set_sh_desc(struct crypto_aead *aead)
 {
-	struct aead_tfm *tfm = &aead->base.crt_aead;
+	unsigned int ivsize = crypto_aead_ivsize(aead);
 	struct caam_ctx *ctx = crypto_aead_ctx(aead);
 	struct device *jrdev = ctx->jrdev;
 	bool keys_fit_inline = false;
@@ -781,7 +781,7 @@ static int gcm_set_sh_desc(struct crypto_aead *aead)
 	append_math_sub_imm_u32(desc, REG3, SEQOUTLEN, IMM, ctx->authsize);
 
 	/* assoclen + cryptlen = seqinlen - ivsize */
-	append_math_sub_imm_u32(desc, REG2, SEQINLEN, IMM, tfm->ivsize);
+	append_math_sub_imm_u32(desc, REG2, SEQINLEN, IMM, ivsize);
 
 	/* assoclen = (assoclen + cryptlen) - cryptlen */
 	append_math_sub(desc, REG1, REG2, REG3, CAAM_CMD_SZ);
@@ -791,7 +791,7 @@ static int gcm_set_sh_desc(struct crypto_aead *aead)
 	zero_payload_jump_cmd = append_jump(desc, JUMP_TEST_ALL |
 					    JUMP_COND_MATH_Z);
 	/* read IV */
-	append_seq_fifo_load(desc, tfm->ivsize, FIFOLD_CLASS_CLASS1 |
+	append_seq_fifo_load(desc, ivsize, FIFOLD_CLASS_CLASS1 |
 			     FIFOLD_TYPE_IV | FIFOLD_TYPE_FLUSH1);
 
 	/* if assoclen is ZERO, skip reading the assoc data */
@@ -824,7 +824,7 @@ static int gcm_set_sh_desc(struct crypto_aead *aead)
 	zero_assoc_jump_cmd2 = append_jump(desc, JUMP_TEST_ALL |
 					   JUMP_COND_MATH_Z);
 	/* read IV */
-	append_seq_fifo_load(desc, tfm->ivsize, FIFOLD_CLASS_CLASS1 |
+	append_seq_fifo_load(desc, ivsize, FIFOLD_CLASS_CLASS1 |
 			     FIFOLD_TYPE_IV | FIFOLD_TYPE_FLUSH1);
 
 	/* read assoc data */
@@ -836,7 +836,7 @@ static int gcm_set_sh_desc(struct crypto_aead *aead)
 
 	/* read IV - is the only input data */
 	set_jump_tgt_here(desc, zero_assoc_jump_cmd2);
-	append_seq_fifo_load(desc, tfm->ivsize, FIFOLD_CLASS_CLASS1 |
+	append_seq_fifo_load(desc, ivsize, FIFOLD_CLASS_CLASS1 |
 			     FIFOLD_TYPE_IV | FIFOLD_TYPE_FLUSH1 |
 			     FIFOLD_TYPE_LAST1);
 
@@ -888,14 +888,14 @@ static int gcm_set_sh_desc(struct crypto_aead *aead)
 
 	/* assoclen + cryptlen = seqinlen - ivsize - icvsize */
 	append_math_sub_imm_u32(desc, REG3, SEQINLEN, IMM,
-				ctx->authsize + tfm->ivsize);
+				ctx->authsize + ivsize);
 
 	/* assoclen = (assoclen + cryptlen) - cryptlen */
 	append_math_sub(desc, REG2, SEQOUTLEN, REG0, CAAM_CMD_SZ);
 	append_math_sub(desc, REG1, REG3, REG2, CAAM_CMD_SZ);
 
 	/* read IV */
-	append_seq_fifo_load(desc, tfm->ivsize, FIFOLD_CLASS_CLASS1 |
+	append_seq_fifo_load(desc, ivsize, FIFOLD_CLASS_CLASS1 |
 			     FIFOLD_TYPE_IV | FIFOLD_TYPE_FLUSH1);
 
 	/* jump to zero-payload command if cryptlen is zero */
@@ -968,7 +968,7 @@ static int gcm_setauthsize(struct crypto_aead *authenc, unsigned int authsize)
 
 static int rfc4106_set_sh_desc(struct crypto_aead *aead)
 {
-	struct aead_tfm *tfm = &aead->base.crt_aead;
+	unsigned int ivsize = crypto_aead_ivsize(aead);
 	struct caam_ctx *ctx = crypto_aead_ctx(aead);
 	struct device *jrdev = ctx->jrdev;
 	bool keys_fit_inline = false;
@@ -1012,7 +1012,7 @@ static int rfc4106_set_sh_desc(struct crypto_aead *aead)
 	append_math_add(desc, VARSEQOUTLEN, ZERO, REG3, CAAM_CMD_SZ);
 
 	/* assoclen + cryptlen = seqinlen - ivsize */
-	append_math_sub_imm_u32(desc, REG2, SEQINLEN, IMM, tfm->ivsize);
+	append_math_sub_imm_u32(desc, REG2, SEQINLEN, IMM, ivsize);
 
 	/* assoclen = (assoclen + cryptlen) - cryptlen */
 	append_math_sub(desc, VARSEQINLEN, REG2, REG3, CAAM_CMD_SZ);
@@ -1021,7 +1021,7 @@ static int rfc4106_set_sh_desc(struct crypto_aead *aead)
 	append_fifo_load_as_imm(desc, (void *)(ctx->key + ctx->enckeylen),
 				4, FIFOLD_CLASS_CLASS1 | FIFOLD_TYPE_IV);
 	/* Read AES-GCM-ESP IV */
-	append_seq_fifo_load(desc, tfm->ivsize, FIFOLD_CLASS_CLASS1 |
+	append_seq_fifo_load(desc, ivsize, FIFOLD_CLASS_CLASS1 |
 			     FIFOLD_TYPE_IV | FIFOLD_TYPE_FLUSH1);
 
 	/* Read assoc data */
@@ -1085,7 +1085,7 @@ static int rfc4106_set_sh_desc(struct crypto_aead *aead)
 
 	/* assoclen + cryptlen = seqinlen - ivsize - icvsize */
 	append_math_sub_imm_u32(desc, REG3, SEQINLEN, IMM,
-				ctx->authsize + tfm->ivsize);
+				ctx->authsize + ivsize);
 
 	/* assoclen = (assoclen + cryptlen) - cryptlen */
 	append_math_sub(desc, REG2, SEQOUTLEN, REG0, CAAM_CMD_SZ);
@@ -1098,7 +1098,7 @@ static int rfc4106_set_sh_desc(struct crypto_aead *aead)
 	append_fifo_load_as_imm(desc, (void *)(ctx->key + ctx->enckeylen),
 				4, FIFOLD_CLASS_CLASS1 | FIFOLD_TYPE_IV);
 	/* Read AES-GCM-ESP IV */
-	append_seq_fifo_load(desc, tfm->ivsize, FIFOLD_CLASS_CLASS1 |
+	append_seq_fifo_load(desc, ivsize, FIFOLD_CLASS_CLASS1 |
 			     FIFOLD_TYPE_IV | FIFOLD_TYPE_FLUSH1);
 
 	/* Read assoc data */
@@ -1161,17 +1161,17 @@ static int rfc4106_set_sh_desc(struct crypto_aead *aead)
 	/* Generate IV */
 	geniv = NFIFOENTRY_STYPE_PAD | NFIFOENTRY_DEST_DECO |
 		NFIFOENTRY_DTYPE_MSG | NFIFOENTRY_LC1 |
-		NFIFOENTRY_PTYPE_RND | (tfm->ivsize << NFIFOENTRY_DLEN_SHIFT);
+		NFIFOENTRY_PTYPE_RND | (ivsize << NFIFOENTRY_DLEN_SHIFT);
 	append_load_imm_u32(desc, geniv, LDST_CLASS_IND_CCB |
 			    LDST_SRCDST_WORD_INFO_FIFO | LDST_IMM);
 	append_cmd(desc, CMD_LOAD | DISABLE_AUTO_INFO_FIFO);
 	move_cmd = append_move(desc, MOVE_SRC_INFIFO | MOVE_DEST_DESCBUF |
-			       (tfm->ivsize << MOVE_LEN_SHIFT));
+			       (ivsize << MOVE_LEN_SHIFT));
 	append_cmd(desc, CMD_LOAD | ENABLE_AUTO_INFO_FIFO);
 
 	/* Copy generated IV to OFIFO */
 	write_iv_cmd = append_move(desc, MOVE_SRC_DESCBUF | MOVE_DEST_OUTFIFO |
-				   (tfm->ivsize << MOVE_LEN_SHIFT));
+				   (ivsize << MOVE_LEN_SHIFT));
 
 	/* Class 1 operation */
 	append_operation(desc, ctx->class1_alg_type |
@@ -1199,7 +1199,7 @@ static int rfc4106_set_sh_desc(struct crypto_aead *aead)
 	/* End of blank commands */
 
 	/* No need to reload iv */
-	append_seq_fifo_load(desc, tfm->ivsize, FIFOLD_CLASS_SKIP);
+	append_seq_fifo_load(desc, ivsize, FIFOLD_CLASS_SKIP);
 
 	/* Read assoc data */
 	append_seq_fifo_load(desc, 0, FIFOLD_CLASS_CLASS1 | FIFOLDST_VLF |
@@ -1249,7 +1249,7 @@ static int rfc4106_setauthsize(struct crypto_aead *authenc,
 
 static int rfc4543_set_sh_desc(struct crypto_aead *aead)
 {
-	struct aead_tfm *tfm = &aead->base.crt_aead;
+	unsigned int ivsize = crypto_aead_ivsize(aead);
 	struct caam_ctx *ctx = crypto_aead_ctx(aead);
 	struct device *jrdev = ctx->jrdev;
 	bool keys_fit_inline = false;
@@ -1291,7 +1291,7 @@ static int rfc4543_set_sh_desc(struct crypto_aead *aead)
 
 	/* Load AES-GMAC ESP IV into Math1 register */
 	append_cmd(desc, CMD_SEQ_LOAD | LDST_SRCDST_WORD_DECO_MATH1 |
-		   LDST_CLASS_DECO | tfm->ivsize);
+		   LDST_CLASS_DECO | ivsize);
 
 	/* Wait the DMA transaction to finish */
 	append_jump(desc, JUMP_TEST_ALL | JUMP_COND_CALM |
@@ -1299,11 +1299,11 @@ static int rfc4543_set_sh_desc(struct crypto_aead *aead)
 
 	/* Overwrite blank immediate AES-GMAC ESP IV data */
 	write_iv_cmd = append_move(desc, MOVE_SRC_MATH1 | MOVE_DEST_DESCBUF |
-				   (tfm->ivsize << MOVE_LEN_SHIFT));
+				   (ivsize << MOVE_LEN_SHIFT));
 
 	/* Overwrite blank immediate AAD data */
 	write_aad_cmd = append_move(desc, MOVE_SRC_MATH1 | MOVE_DEST_DESCBUF |
-				    (tfm->ivsize << MOVE_LEN_SHIFT));
+				    (ivsize << MOVE_LEN_SHIFT));
 
 	/* cryptlen = seqoutlen - authsize */
 	append_math_sub_imm_u32(desc, REG3, SEQOUTLEN, IMM, ctx->authsize);
@@ -1313,7 +1313,7 @@ static int rfc4543_set_sh_desc(struct crypto_aead *aead)
 
 	/* Read Salt and AES-GMAC ESP IV */
 	append_cmd(desc, CMD_FIFO_LOAD | FIFOLD_CLASS_CLASS1 | IMMEDIATE |
-		   FIFOLD_TYPE_IV | FIFOLD_TYPE_FLUSH1 | (4 + tfm->ivsize));
+		   FIFOLD_TYPE_IV | FIFOLD_TYPE_FLUSH1 | (4 + ivsize));
 	/* Append Salt */
 	append_data(desc, (void *)(ctx->key + ctx->enckeylen), 4);
 	set_move_tgt_here(desc, write_iv_cmd);
@@ -1344,7 +1344,7 @@ static int rfc4543_set_sh_desc(struct crypto_aead *aead)
 
 	/* Authenticate AES-GMAC ESP IV  */
 	append_cmd(desc, CMD_FIFO_LOAD | FIFOLD_CLASS_CLASS1 | IMMEDIATE |
-		   FIFOLD_TYPE_AAD | tfm->ivsize);
+		   FIFOLD_TYPE_AAD | ivsize);
 	set_move_tgt_here(desc, write_aad_cmd);
 	/* Blank commands. Will be overwritten by AES-GMAC ESP IV. */
 	append_cmd(desc, 0x00000000);
@@ -1407,7 +1407,7 @@ static int rfc4543_set_sh_desc(struct crypto_aead *aead)
 
 	/* Load AES-GMAC ESP IV into Math1 register */
 	append_cmd(desc, CMD_SEQ_LOAD | LDST_SRCDST_WORD_DECO_MATH1 |
-		   LDST_CLASS_DECO | tfm->ivsize);
+		   LDST_CLASS_DECO | ivsize);
 
 	/* Wait the DMA transaction to finish */
 	append_jump(desc, JUMP_TEST_ALL | JUMP_COND_CALM |
@@ -1418,11 +1418,11 @@ static int rfc4543_set_sh_desc(struct crypto_aead *aead)
 
 	/* Overwrite blank immediate AES-GMAC ESP IV data */
 	write_iv_cmd = append_move(desc, MOVE_SRC_MATH1 | MOVE_DEST_DESCBUF |
-				   (tfm->ivsize << MOVE_LEN_SHIFT));
+				   (ivsize << MOVE_LEN_SHIFT));
 
 	/* Overwrite blank immediate AAD data */
 	write_aad_cmd = append_move(desc, MOVE_SRC_MATH1 | MOVE_DEST_DESCBUF |
-				    (tfm->ivsize << MOVE_LEN_SHIFT));
+				    (ivsize << MOVE_LEN_SHIFT));
 
 	/* assoclen = (assoclen + cryptlen) - cryptlen */
 	append_math_sub(desc, REG2, SEQOUTLEN, REG0, CAAM_CMD_SZ);
@@ -1440,7 +1440,7 @@ static int rfc4543_set_sh_desc(struct crypto_aead *aead)
 
 	/* Read Salt and AES-GMAC ESP IV */
 	append_cmd(desc, CMD_FIFO_LOAD | FIFOLD_CLASS_CLASS1 | IMMEDIATE |
-		   FIFOLD_TYPE_IV | FIFOLD_TYPE_FLUSH1 | (4 + tfm->ivsize));
+		   FIFOLD_TYPE_IV | FIFOLD_TYPE_FLUSH1 | (4 + ivsize));
 	/* Append Salt */
 	append_data(desc, (void *)(ctx->key + ctx->enckeylen), 4);
 	set_move_tgt_here(desc, write_iv_cmd);
@@ -1461,7 +1461,7 @@ static int rfc4543_set_sh_desc(struct crypto_aead *aead)
 
 	/* Authenticate AES-GMAC ESP IV  */
 	append_cmd(desc, CMD_FIFO_LOAD | FIFOLD_CLASS_CLASS1 | IMMEDIATE |
-		   FIFOLD_TYPE_AAD | tfm->ivsize);
+		   FIFOLD_TYPE_AAD | ivsize);
 	set_move_tgt_here(desc, write_aad_cmd);
 	/* Blank commands. Will be overwritten by AES-GMAC ESP IV. */
 	append_cmd(desc, 0x00000000);
@@ -1527,26 +1527,26 @@ static int rfc4543_set_sh_desc(struct crypto_aead *aead)
 	/* Generate IV */
 	geniv = NFIFOENTRY_STYPE_PAD | NFIFOENTRY_DEST_DECO |
 		NFIFOENTRY_DTYPE_MSG | NFIFOENTRY_LC1 |
-		NFIFOENTRY_PTYPE_RND | (tfm->ivsize << NFIFOENTRY_DLEN_SHIFT);
+		NFIFOENTRY_PTYPE_RND | (ivsize << NFIFOENTRY_DLEN_SHIFT);
 	append_load_imm_u32(desc, geniv, LDST_CLASS_IND_CCB |
 			    LDST_SRCDST_WORD_INFO_FIFO | LDST_IMM);
 	append_cmd(desc, CMD_LOAD | DISABLE_AUTO_INFO_FIFO);
 	/* Move generated IV to Math1 register */
 	append_move(desc, MOVE_SRC_INFIFO | MOVE_DEST_MATH1 |
-		    (tfm->ivsize << MOVE_LEN_SHIFT));
+		    (ivsize << MOVE_LEN_SHIFT));
 	append_cmd(desc, CMD_LOAD | ENABLE_AUTO_INFO_FIFO);
 
 	/* Overwrite blank immediate AES-GMAC IV data */
 	write_iv_cmd = append_move(desc, MOVE_SRC_MATH1 | MOVE_DEST_DESCBUF |
-				   (tfm->ivsize << MOVE_LEN_SHIFT));
+				   (ivsize << MOVE_LEN_SHIFT));
 
 	/* Overwrite blank immediate AAD data */
 	write_aad_cmd = append_move(desc, MOVE_SRC_MATH1 | MOVE_DEST_DESCBUF |
-				    (tfm->ivsize << MOVE_LEN_SHIFT));
+				    (ivsize << MOVE_LEN_SHIFT));
 
 	/* Copy generated IV to OFIFO */
 	append_move(desc, MOVE_SRC_MATH1 | MOVE_DEST_OUTFIFO |
-		    (tfm->ivsize << MOVE_LEN_SHIFT));
+		    (ivsize << MOVE_LEN_SHIFT));
 
 	/* Class 1 operation */
 	append_operation(desc, ctx->class1_alg_type |
@@ -1573,7 +1573,7 @@ static int rfc4543_set_sh_desc(struct crypto_aead *aead)
 
 	/* Read Salt and AES-GMAC generated IV */
 	append_cmd(desc, CMD_FIFO_LOAD | FIFOLD_CLASS_CLASS1 | IMMEDIATE |
-		   FIFOLD_TYPE_IV | FIFOLD_TYPE_FLUSH1 | (4 + tfm->ivsize));
+		   FIFOLD_TYPE_IV | FIFOLD_TYPE_FLUSH1 | (4 + ivsize));
 	/* Append Salt */
 	append_data(desc, (void *)(ctx->key + ctx->enckeylen), 4);
 	set_move_tgt_here(desc, write_iv_cmd);
@@ -1583,7 +1583,7 @@ static int rfc4543_set_sh_desc(struct crypto_aead *aead)
 	/* End of blank commands */
 
 	/* No need to reload iv */
-	append_seq_fifo_load(desc, tfm->ivsize, FIFOLD_CLASS_SKIP);
+	append_seq_fifo_load(desc, ivsize, FIFOLD_CLASS_SKIP);
 
 	/* Read assoc data */
 	append_seq_fifo_load(desc, 0, FIFOLD_CLASS_CLASS1 | FIFOLDST_VLF |
@@ -1594,7 +1594,7 @@ static int rfc4543_set_sh_desc(struct crypto_aead *aead)
 
 	/* Authenticate AES-GMAC IV  */
 	append_cmd(desc, CMD_FIFO_LOAD | FIFOLD_CLASS_CLASS1 | IMMEDIATE |
-		   FIFOLD_TYPE_AAD | tfm->ivsize);
+		   FIFOLD_TYPE_AAD | ivsize);
 	set_move_tgt_here(desc, write_aad_cmd);
 	/* Blank commands. Will be overwritten by AES-GMAC IV. */
 	append_cmd(desc, 0x00000000);
