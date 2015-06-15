From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6/8] crypto: caam - Convert GCM to new AEAD interface
Date: Mon, 15 Jun 2015 16:09:45 +0800
Message-ID: <E1Z4PSj-00084W-6B@gondolin.me.apana.org.au>
References: <20150615080716.GA30753@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Marcelo Henrique Cerri <mhcerri@linux.vnet.ibm.com>,
	Fionnuala Gunter <fin@linux.vnet.ibm.com>,
	horia.geanta@freescale.com, ruchika.gupta@freescale.com,
	cristian.stoica@freescale.com, NiteshNarayanLal@freescale.com,
	jinyanjiang@gmail.com, Kim Phillips <kim.phillips@freescale.com>,
	Tudor Ambarus <tudor.ambarus@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:50259 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753471AbbFOIJu (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 15 Jun 2015 04:09:50 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch converts the caam GCM implementations to the new AEAD
interface.  This is compile-tested only.

Note that all IV generation for GCM algorithms have been removed.
The reason is that the current generation uses purely random IVs
which is not appropriate for counter-based algorithms where we
first and foremost require uniqueness.

Of course there is no reason why you couldn't implement seqiv or
seqniv within caam since all they do is xor the sequence number
with a salt, but since I can't test this on actual hardware I'll
leave it alone for now.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/crypto/caam/caamalg.c | 1434 +++++++++++++++++++++---------------------
 1 file changed, 744 insertions(+), 690 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index 3c37fe6..95e8545 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -65,6 +65,10 @@
 /* max IV is max of AES_BLOCK_SIZE, DES3_EDE_BLOCK_SIZE */
 #define CAAM_MAX_IV_LENGTH		16
 
+#define AEAD_DESC_JOB_IO_LEN		(DESC_JOB_IO_LEN + CAAM_CMD_SZ * 2)
+#define GCM_DESC_JOB_IO_LEN		(AEAD_DESC_JOB_IO_LEN + \
+					 CAAM_CMD_SZ * 4)
+
 /* length of descriptors text */
 #define DESC_AEAD_BASE			(4 * CAAM_CMD_SZ)
 #define DESC_AEAD_ENC_LEN		(DESC_AEAD_BASE + 15 * CAAM_CMD_SZ)
@@ -79,18 +83,16 @@
 #define DESC_AEAD_NULL_DEC_LEN		(DESC_AEAD_NULL_BASE + 17 * CAAM_CMD_SZ)
 
 #define DESC_GCM_BASE			(3 * CAAM_CMD_SZ)
-#define DESC_GCM_ENC_LEN		(DESC_GCM_BASE + 23 * CAAM_CMD_SZ)
-#define DESC_GCM_DEC_LEN		(DESC_GCM_BASE + 19 * CAAM_CMD_SZ)
+#define DESC_GCM_ENC_LEN		(DESC_GCM_BASE + 16 * CAAM_CMD_SZ)
+#define DESC_GCM_DEC_LEN		(DESC_GCM_BASE + 12 * CAAM_CMD_SZ)
 
 #define DESC_RFC4106_BASE		(3 * CAAM_CMD_SZ)
-#define DESC_RFC4106_ENC_LEN		(DESC_RFC4106_BASE + 15 * CAAM_CMD_SZ)
-#define DESC_RFC4106_DEC_LEN		(DESC_RFC4106_BASE + 14 * CAAM_CMD_SZ)
-#define DESC_RFC4106_GIVENC_LEN		(DESC_RFC4106_BASE + 21 * CAAM_CMD_SZ)
+#define DESC_RFC4106_ENC_LEN		(DESC_RFC4106_BASE + 10 * CAAM_CMD_SZ)
+#define DESC_RFC4106_DEC_LEN		(DESC_RFC4106_BASE + 10 * CAAM_CMD_SZ)
 
 #define DESC_RFC4543_BASE		(3 * CAAM_CMD_SZ)
-#define DESC_RFC4543_ENC_LEN		(DESC_RFC4543_BASE + 25 * CAAM_CMD_SZ)
-#define DESC_RFC4543_DEC_LEN		(DESC_RFC4543_BASE + 27 * CAAM_CMD_SZ)
-#define DESC_RFC4543_GIVENC_LEN		(DESC_RFC4543_BASE + 30 * CAAM_CMD_SZ)
+#define DESC_RFC4543_ENC_LEN		(DESC_RFC4543_BASE + 11 * CAAM_CMD_SZ)
+#define DESC_RFC4543_DEC_LEN		(DESC_RFC4543_BASE + 12 * CAAM_CMD_SZ)
 
 #define DESC_ABLKCIPHER_BASE		(3 * CAAM_CMD_SZ)
 #define DESC_ABLKCIPHER_ENC_LEN		(DESC_ABLKCIPHER_BASE + \
@@ -98,9 +100,7 @@
 #define DESC_ABLKCIPHER_DEC_LEN		(DESC_ABLKCIPHER_BASE + \
 					 15 * CAAM_CMD_SZ)
 
-#define DESC_MAX_USED_BYTES		(DESC_RFC4543_GIVENC_LEN + \
-					 CAAM_MAX_KEY_SIZE)
-#define DESC_MAX_USED_LEN		(DESC_MAX_USED_BYTES / CAAM_CMD_SZ)
+#define DESC_MAX_USED_LEN		(CAAM_DESC_BYTES_MAX - DESC_JOB_IO_LEN)
 
 #ifdef DEBUG
 /* for print_hex_dumps with line references */
@@ -273,7 +273,7 @@ static int aead_null_set_sh_desc(struct crypto_aead *aead)
 	    ctx->split_key_pad_len <= CAAM_DESC_BYTES_MAX)
 		keys_fit_inline = true;
 
-	/* aead_encrypt shared descriptor */
+	/* old_aead_encrypt shared descriptor */
 	desc = ctx->sh_desc_enc;
 
 	init_sh_desc(desc, HDR_SHARE_SERIAL);
@@ -362,7 +362,7 @@ static int aead_null_set_sh_desc(struct crypto_aead *aead)
 
 	desc = ctx->sh_desc_dec;
 
-	/* aead_decrypt shared descriptor */
+	/* old_aead_decrypt shared descriptor */
 	init_sh_desc(desc, HDR_SHARE_SERIAL);
 
 	/* Skip if already shared */
@@ -496,7 +496,7 @@ static int aead_set_sh_desc(struct crypto_aead *aead)
 	    CAAM_DESC_BYTES_MAX)
 		keys_fit_inline = true;
 
-	/* aead_encrypt shared descriptor */
+	/* old_aead_encrypt shared descriptor */
 	desc = ctx->sh_desc_enc;
 
 	/* Note: Context registers are saved. */
@@ -565,7 +565,7 @@ static int aead_set_sh_desc(struct crypto_aead *aead)
 	    CAAM_DESC_BYTES_MAX)
 		keys_fit_inline = true;
 
-	/* aead_decrypt shared descriptor */
+	/* old_aead_decrypt shared descriptor */
 	desc = ctx->sh_desc_dec;
 
 	/* Note: Context registers are saved. */
@@ -738,7 +738,6 @@ static int aead_setauthsize(struct crypto_aead *authenc,
 
 static int gcm_set_sh_desc(struct crypto_aead *aead)
 {
-	unsigned int ivsize = crypto_aead_ivsize(aead);
 	struct caam_ctx *ctx = crypto_aead_ctx(aead);
 	struct device *jrdev = ctx->jrdev;
 	bool keys_fit_inline = false;
@@ -754,7 +753,7 @@ static int gcm_set_sh_desc(struct crypto_aead *aead)
 	 * Job Descriptor and Shared Descriptor
 	 * must fit into the 64-word Descriptor h/w Buffer
 	 */
-	if (DESC_GCM_ENC_LEN + DESC_JOB_IO_LEN +
+	if (DESC_GCM_ENC_LEN + GCM_DESC_JOB_IO_LEN +
 	    ctx->enckeylen <= CAAM_DESC_BYTES_MAX)
 		keys_fit_inline = true;
 
@@ -777,34 +776,34 @@ static int gcm_set_sh_desc(struct crypto_aead *aead)
 	append_operation(desc, ctx->class1_alg_type |
 			 OP_ALG_AS_INITFINAL | OP_ALG_ENCRYPT);
 
-	/* cryptlen = seqoutlen - authsize */
-	append_math_sub_imm_u32(desc, REG3, SEQOUTLEN, IMM, ctx->authsize);
+	/* if assoclen + cryptlen is ZERO, skip to ICV write */
+	append_math_sub(desc, NONE, SEQINLEN, REG0, CAAM_CMD_SZ);
+	zero_assoc_jump_cmd2 = append_jump(desc, JUMP_TEST_ALL |
+						 JUMP_COND_MATH_Z);
 
-	/* assoclen + cryptlen = seqinlen - ivsize */
-	append_math_sub_imm_u32(desc, REG2, SEQINLEN, IMM, ivsize);
+	/* if assoclen is ZERO, skip reading the assoc data */
+	append_math_add(desc, VARSEQINLEN, ZERO, REG3, CAAM_CMD_SZ);
+	zero_assoc_jump_cmd1 = append_jump(desc, JUMP_TEST_ALL |
+						 JUMP_COND_MATH_Z);
 
-	/* assoclen = (assoclen + cryptlen) - cryptlen */
-	append_math_sub(desc, REG1, REG2, REG3, CAAM_CMD_SZ);
+	append_math_add(desc, VARSEQOUTLEN, ZERO, REG3, CAAM_CMD_SZ);
+
+	/* skip assoc data */
+	append_seq_fifo_store(desc, 0, FIFOST_TYPE_SKIP | FIFOLDST_VLF);
+
+	/* cryptlen = seqinlen - assoclen */
+	append_math_sub(desc, VARSEQOUTLEN, SEQINLEN, REG3, CAAM_CMD_SZ);
 
 	/* if cryptlen is ZERO jump to zero-payload commands */
-	append_math_add(desc, VARSEQOUTLEN, ZERO, REG3, CAAM_CMD_SZ);
 	zero_payload_jump_cmd = append_jump(desc, JUMP_TEST_ALL |
 					    JUMP_COND_MATH_Z);
-	/* read IV */
-	append_seq_fifo_load(desc, ivsize, FIFOLD_CLASS_CLASS1 |
-			     FIFOLD_TYPE_IV | FIFOLD_TYPE_FLUSH1);
-
-	/* if assoclen is ZERO, skip reading the assoc data */
-	append_math_add(desc, VARSEQINLEN, ZERO, REG1, CAAM_CMD_SZ);
-	zero_assoc_jump_cmd1 = append_jump(desc, JUMP_TEST_ALL |
-					   JUMP_COND_MATH_Z);
 
 	/* read assoc data */
 	append_seq_fifo_load(desc, 0, FIFOLD_CLASS_CLASS1 | FIFOLDST_VLF |
 			     FIFOLD_TYPE_AAD | FIFOLD_TYPE_FLUSH1);
 	set_jump_tgt_here(desc, zero_assoc_jump_cmd1);
 
-	append_math_add(desc, VARSEQINLEN, ZERO, REG3, CAAM_CMD_SZ);
+	append_math_sub(desc, VARSEQINLEN, SEQINLEN, REG0, CAAM_CMD_SZ);
 
 	/* write encrypted data */
 	append_seq_fifo_store(desc, 0, FIFOST_TYPE_MESSAGE_DATA | FIFOLDST_VLF);
@@ -814,31 +813,17 @@ static int gcm_set_sh_desc(struct crypto_aead *aead)
 			     FIFOLD_TYPE_MSG | FIFOLD_TYPE_LAST1);
 
 	/* jump the zero-payload commands */
-	append_jump(desc, JUMP_TEST_ALL | 7);
+	append_jump(desc, JUMP_TEST_ALL | 2);
 
 	/* zero-payload commands */
 	set_jump_tgt_here(desc, zero_payload_jump_cmd);
 
-	/* if assoclen is ZERO, jump to IV reading - is the only input data */
-	append_math_add(desc, VARSEQINLEN, ZERO, REG1, CAAM_CMD_SZ);
-	zero_assoc_jump_cmd2 = append_jump(desc, JUMP_TEST_ALL |
-					   JUMP_COND_MATH_Z);
-	/* read IV */
-	append_seq_fifo_load(desc, ivsize, FIFOLD_CLASS_CLASS1 |
-			     FIFOLD_TYPE_IV | FIFOLD_TYPE_FLUSH1);
-
 	/* read assoc data */
 	append_seq_fifo_load(desc, 0, FIFOLD_CLASS_CLASS1 | FIFOLDST_VLF |
 			     FIFOLD_TYPE_AAD | FIFOLD_TYPE_LAST1);
 
-	/* jump to ICV writing */
-	append_jump(desc, JUMP_TEST_ALL | 2);
-
-	/* read IV - is the only input data */
+	/* There is no input data */
 	set_jump_tgt_here(desc, zero_assoc_jump_cmd2);
-	append_seq_fifo_load(desc, ivsize, FIFOLD_CLASS_CLASS1 |
-			     FIFOLD_TYPE_IV | FIFOLD_TYPE_FLUSH1 |
-			     FIFOLD_TYPE_LAST1);
 
 	/* write ICV */
 	append_seq_store(desc, ctx->authsize, LDST_CLASS_1_CCB |
@@ -862,7 +847,7 @@ static int gcm_set_sh_desc(struct crypto_aead *aead)
 	 * must all fit into the 64-word Descriptor h/w Buffer
 	 */
 	keys_fit_inline = false;
-	if (DESC_GCM_DEC_LEN + DESC_JOB_IO_LEN +
+	if (DESC_GCM_DEC_LEN + GCM_DESC_JOB_IO_LEN +
 	    ctx->enckeylen <= CAAM_DESC_BYTES_MAX)
 		keys_fit_inline = true;
 
@@ -886,33 +871,30 @@ static int gcm_set_sh_desc(struct crypto_aead *aead)
 	append_operation(desc, ctx->class1_alg_type |
 			 OP_ALG_AS_INITFINAL | OP_ALG_DECRYPT | OP_ALG_ICV_ON);
 
-	/* assoclen + cryptlen = seqinlen - ivsize - icvsize */
-	append_math_sub_imm_u32(desc, REG3, SEQINLEN, IMM,
-				ctx->authsize + ivsize);
-
-	/* assoclen = (assoclen + cryptlen) - cryptlen */
-	append_math_sub(desc, REG2, SEQOUTLEN, REG0, CAAM_CMD_SZ);
-	append_math_sub(desc, REG1, REG3, REG2, CAAM_CMD_SZ);
+	/* if assoclen is ZERO, skip reading the assoc data */
+	append_math_add(desc, VARSEQINLEN, ZERO, REG3, CAAM_CMD_SZ);
+	zero_assoc_jump_cmd1 = append_jump(desc, JUMP_TEST_ALL |
+						 JUMP_COND_MATH_Z);
 
-	/* read IV */
-	append_seq_fifo_load(desc, ivsize, FIFOLD_CLASS_CLASS1 |
-			     FIFOLD_TYPE_IV | FIFOLD_TYPE_FLUSH1);
+	append_math_add(desc, VARSEQOUTLEN, ZERO, REG3, CAAM_CMD_SZ);
 
-	/* jump to zero-payload command if cryptlen is zero */
-	append_math_add(desc, VARSEQOUTLEN, ZERO, REG2, CAAM_CMD_SZ);
-	zero_payload_jump_cmd = append_jump(desc, JUMP_TEST_ALL |
-					    JUMP_COND_MATH_Z);
+	/* skip assoc data */
+	append_seq_fifo_store(desc, 0, FIFOST_TYPE_SKIP | FIFOLDST_VLF);
 
-	append_math_add(desc, VARSEQINLEN, ZERO, REG1, CAAM_CMD_SZ);
-	/* if asoclen is ZERO, skip reading assoc data */
-	zero_assoc_jump_cmd1 = append_jump(desc, JUMP_TEST_ALL |
-					   JUMP_COND_MATH_Z);
 	/* read assoc data */
 	append_seq_fifo_load(desc, 0, FIFOLD_CLASS_CLASS1 | FIFOLDST_VLF |
 			     FIFOLD_TYPE_AAD | FIFOLD_TYPE_FLUSH1);
+
 	set_jump_tgt_here(desc, zero_assoc_jump_cmd1);
 
-	append_math_add(desc, VARSEQINLEN, ZERO, REG2, CAAM_CMD_SZ);
+	/* cryptlen = seqoutlen - assoclen */
+	append_math_sub(desc, VARSEQINLEN, SEQOUTLEN, REG0, CAAM_CMD_SZ);
+
+	/* jump to zero-payload command if cryptlen is zero */
+	zero_payload_jump_cmd = append_jump(desc, JUMP_TEST_ALL |
+					    JUMP_COND_MATH_Z);
+
+	append_math_sub(desc, VARSEQOUTLEN, SEQOUTLEN, REG0, CAAM_CMD_SZ);
 
 	/* store encrypted data */
 	append_seq_fifo_store(desc, 0, FIFOST_TYPE_MESSAGE_DATA | FIFOLDST_VLF);
@@ -921,21 +903,9 @@ static int gcm_set_sh_desc(struct crypto_aead *aead)
 	append_seq_fifo_load(desc, 0, FIFOLD_CLASS_CLASS1 | FIFOLDST_VLF |
 			     FIFOLD_TYPE_MSG | FIFOLD_TYPE_FLUSH1);
 
-	/* jump the zero-payload commands */
-	append_jump(desc, JUMP_TEST_ALL | 4);
-
 	/* zero-payload command */
 	set_jump_tgt_here(desc, zero_payload_jump_cmd);
 
-	/* if assoclen is ZERO, jump to ICV reading */
-	append_math_add(desc, VARSEQINLEN, ZERO, REG1, CAAM_CMD_SZ);
-	zero_assoc_jump_cmd2 = append_jump(desc, JUMP_TEST_ALL |
-					   JUMP_COND_MATH_Z);
-	/* read assoc data */
-	append_seq_fifo_load(desc, 0, FIFOLD_CLASS_CLASS1 | FIFOLDST_VLF |
-			     FIFOLD_TYPE_AAD | FIFOLD_TYPE_FLUSH1);
-	set_jump_tgt_here(desc, zero_assoc_jump_cmd2);
-
 	/* read ICV */
 	append_seq_fifo_load(desc, ctx->authsize, FIFOLD_CLASS_CLASS1 |
 			     FIFOLD_TYPE_ICV | FIFOLD_TYPE_LAST1);
@@ -968,13 +938,11 @@ static int gcm_setauthsize(struct crypto_aead *authenc, unsigned int authsize)
 
 static int rfc4106_set_sh_desc(struct crypto_aead *aead)
 {
-	unsigned int ivsize = crypto_aead_ivsize(aead);
 	struct caam_ctx *ctx = crypto_aead_ctx(aead);
 	struct device *jrdev = ctx->jrdev;
 	bool keys_fit_inline = false;
-	u32 *key_jump_cmd, *move_cmd, *write_iv_cmd;
+	u32 *key_jump_cmd;
 	u32 *desc;
-	u32 geniv;
 
 	if (!ctx->enckeylen || !ctx->authsize)
 		return 0;
@@ -984,7 +952,7 @@ static int rfc4106_set_sh_desc(struct crypto_aead *aead)
 	 * Job Descriptor and Shared Descriptor
 	 * must fit into the 64-word Descriptor h/w Buffer
 	 */
-	if (DESC_RFC4106_ENC_LEN + DESC_JOB_IO_LEN +
+	if (DESC_RFC4106_ENC_LEN + GCM_DESC_JOB_IO_LEN +
 	    ctx->enckeylen <= CAAM_DESC_BYTES_MAX)
 		keys_fit_inline = true;
 
@@ -1007,29 +975,21 @@ static int rfc4106_set_sh_desc(struct crypto_aead *aead)
 	append_operation(desc, ctx->class1_alg_type |
 			 OP_ALG_AS_INITFINAL | OP_ALG_ENCRYPT);
 
-	/* cryptlen = seqoutlen - authsize */
-	append_math_sub_imm_u32(desc, REG3, SEQOUTLEN, IMM, ctx->authsize);
+	append_math_add(desc, VARSEQINLEN, ZERO, REG3, CAAM_CMD_SZ);
 	append_math_add(desc, VARSEQOUTLEN, ZERO, REG3, CAAM_CMD_SZ);
 
-	/* assoclen + cryptlen = seqinlen - ivsize */
-	append_math_sub_imm_u32(desc, REG2, SEQINLEN, IMM, ivsize);
-
-	/* assoclen = (assoclen + cryptlen) - cryptlen */
-	append_math_sub(desc, VARSEQINLEN, REG2, REG3, CAAM_CMD_SZ);
-
-	/* Read Salt */
-	append_fifo_load_as_imm(desc, (void *)(ctx->key + ctx->enckeylen),
-				4, FIFOLD_CLASS_CLASS1 | FIFOLD_TYPE_IV);
-	/* Read AES-GCM-ESP IV */
-	append_seq_fifo_load(desc, ivsize, FIFOLD_CLASS_CLASS1 |
-			     FIFOLD_TYPE_IV | FIFOLD_TYPE_FLUSH1);
+	/* Skip assoc data */
+	append_seq_fifo_store(desc, 0, FIFOST_TYPE_SKIP | FIFOLDST_VLF);
 
 	/* Read assoc data */
 	append_seq_fifo_load(desc, 0, FIFOLD_CLASS_CLASS1 | FIFOLDST_VLF |
 			     FIFOLD_TYPE_AAD | FIFOLD_TYPE_FLUSH1);
 
+	/* cryptlen = seqoutlen - assoclen */
+	append_math_sub(desc, VARSEQOUTLEN, SEQOUTLEN, REG0, CAAM_CMD_SZ);
+
 	/* Will read cryptlen bytes */
-	append_math_add(desc, VARSEQINLEN, ZERO, REG3, CAAM_CMD_SZ);
+	append_math_add(desc, VARSEQINLEN, SEQOUTLEN, REG0, CAAM_CMD_SZ);
 
 	/* Write encrypted data */
 	append_seq_fifo_store(desc, 0, FIFOST_TYPE_MESSAGE_DATA | FIFOLDST_VLF);
@@ -1083,30 +1043,21 @@ static int rfc4106_set_sh_desc(struct crypto_aead *aead)
 	append_operation(desc, ctx->class1_alg_type |
 			 OP_ALG_AS_INITFINAL | OP_ALG_DECRYPT | OP_ALG_ICV_ON);
 
-	/* assoclen + cryptlen = seqinlen - ivsize - icvsize */
-	append_math_sub_imm_u32(desc, REG3, SEQINLEN, IMM,
-				ctx->authsize + ivsize);
-
-	/* assoclen = (assoclen + cryptlen) - cryptlen */
-	append_math_sub(desc, REG2, SEQOUTLEN, REG0, CAAM_CMD_SZ);
-	append_math_sub(desc, VARSEQINLEN, REG3, REG2, CAAM_CMD_SZ);
-
-	/* Will write cryptlen bytes */
-	append_math_sub(desc, VARSEQOUTLEN, SEQOUTLEN, REG0, CAAM_CMD_SZ);
+	append_math_add(desc, VARSEQINLEN, ZERO, REG3, CAAM_CMD_SZ);
+	append_math_add(desc, VARSEQOUTLEN, ZERO, REG3, CAAM_CMD_SZ);
 
-	/* Read Salt */
-	append_fifo_load_as_imm(desc, (void *)(ctx->key + ctx->enckeylen),
-				4, FIFOLD_CLASS_CLASS1 | FIFOLD_TYPE_IV);
-	/* Read AES-GCM-ESP IV */
-	append_seq_fifo_load(desc, ivsize, FIFOLD_CLASS_CLASS1 |
-			     FIFOLD_TYPE_IV | FIFOLD_TYPE_FLUSH1);
+	/* Skip assoc data */
+	append_seq_fifo_store(desc, 0, FIFOST_TYPE_SKIP | FIFOLDST_VLF);
 
 	/* Read assoc data */
 	append_seq_fifo_load(desc, 0, FIFOLD_CLASS_CLASS1 | FIFOLDST_VLF |
 			     FIFOLD_TYPE_AAD | FIFOLD_TYPE_FLUSH1);
 
+	/* Will write cryptlen bytes */
+	append_math_sub(desc, VARSEQOUTLEN, SEQINLEN, REG0, CAAM_CMD_SZ);
+
 	/* Will read cryptlen bytes */
-	append_math_add(desc, VARSEQINLEN, ZERO, REG2, CAAM_CMD_SZ);
+	append_math_sub(desc, VARSEQINLEN, SEQINLEN, REG0, CAAM_CMD_SZ);
 
 	/* Store payload data */
 	append_seq_fifo_store(desc, 0, FIFOST_TYPE_MESSAGE_DATA | FIFOLDST_VLF);
@@ -1132,107 +1083,6 @@ static int rfc4106_set_sh_desc(struct crypto_aead *aead)
 		       desc_bytes(desc), 1);
 #endif
 
-	/*
-	 * Job Descriptor and Shared Descriptors
-	 * must all fit into the 64-word Descriptor h/w Buffer
-	 */
-	keys_fit_inline = false;
-	if (DESC_RFC4106_GIVENC_LEN + DESC_JOB_IO_LEN +
-	    ctx->split_key_pad_len + ctx->enckeylen <=
-	    CAAM_DESC_BYTES_MAX)
-		keys_fit_inline = true;
-
-	/* rfc4106_givencrypt shared descriptor */
-	desc = ctx->sh_desc_givenc;
-
-	init_sh_desc(desc, HDR_SHARE_SERIAL);
-
-	/* Skip key loading if it is loaded due to sharing */
-	key_jump_cmd = append_jump(desc, JUMP_JSL | JUMP_TEST_ALL |
-				   JUMP_COND_SHRD);
-	if (keys_fit_inline)
-		append_key_as_imm(desc, (void *)ctx->key, ctx->enckeylen,
-				  ctx->enckeylen, CLASS_1 | KEY_DEST_CLASS_REG);
-	else
-		append_key(desc, ctx->key_dma, ctx->enckeylen,
-			   CLASS_1 | KEY_DEST_CLASS_REG);
-	set_jump_tgt_here(desc, key_jump_cmd);
-
-	/* Generate IV */
-	geniv = NFIFOENTRY_STYPE_PAD | NFIFOENTRY_DEST_DECO |
-		NFIFOENTRY_DTYPE_MSG | NFIFOENTRY_LC1 |
-		NFIFOENTRY_PTYPE_RND | (ivsize << NFIFOENTRY_DLEN_SHIFT);
-	append_load_imm_u32(desc, geniv, LDST_CLASS_IND_CCB |
-			    LDST_SRCDST_WORD_INFO_FIFO | LDST_IMM);
-	append_cmd(desc, CMD_LOAD | DISABLE_AUTO_INFO_FIFO);
-	move_cmd = append_move(desc, MOVE_SRC_INFIFO | MOVE_DEST_DESCBUF |
-			       (ivsize << MOVE_LEN_SHIFT));
-	append_cmd(desc, CMD_LOAD | ENABLE_AUTO_INFO_FIFO);
-
-	/* Copy generated IV to OFIFO */
-	write_iv_cmd = append_move(desc, MOVE_SRC_DESCBUF | MOVE_DEST_OUTFIFO |
-				   (ivsize << MOVE_LEN_SHIFT));
-
-	/* Class 1 operation */
-	append_operation(desc, ctx->class1_alg_type |
-			 OP_ALG_AS_INITFINAL | OP_ALG_ENCRYPT);
-
-	/* ivsize + cryptlen = seqoutlen - authsize */
-	append_math_sub_imm_u32(desc, REG3, SEQOUTLEN, IMM, ctx->authsize);
-
-	/* assoclen = seqinlen - (ivsize + cryptlen) */
-	append_math_sub(desc, VARSEQINLEN, SEQINLEN, REG3, CAAM_CMD_SZ);
-
-	/* Will write ivsize + cryptlen */
-	append_math_add(desc, VARSEQOUTLEN, REG3, REG0, CAAM_CMD_SZ);
-
-	/* Read Salt and generated IV */
-	append_cmd(desc, CMD_FIFO_LOAD | FIFOLD_CLASS_CLASS1 | FIFOLD_TYPE_IV |
-		   FIFOLD_TYPE_FLUSH1 | IMMEDIATE | 12);
-	/* Append Salt */
-	append_data(desc, (void *)(ctx->key + ctx->enckeylen), 4);
-	set_move_tgt_here(desc, move_cmd);
-	set_move_tgt_here(desc, write_iv_cmd);
-	/* Blank commands. Will be overwritten by generated IV. */
-	append_cmd(desc, 0x00000000);
-	append_cmd(desc, 0x00000000);
-	/* End of blank commands */
-
-	/* No need to reload iv */
-	append_seq_fifo_load(desc, ivsize, FIFOLD_CLASS_SKIP);
-
-	/* Read assoc data */
-	append_seq_fifo_load(desc, 0, FIFOLD_CLASS_CLASS1 | FIFOLDST_VLF |
-			     FIFOLD_TYPE_AAD | FIFOLD_TYPE_FLUSH1);
-
-	/* Will read cryptlen */
-	append_math_add(desc, VARSEQINLEN, SEQINLEN, REG0, CAAM_CMD_SZ);
-
-	/* Store generated IV and encrypted data */
-	append_seq_fifo_store(desc, 0, FIFOST_TYPE_MESSAGE_DATA | FIFOLDST_VLF);
-
-	/* Read payload data */
-	append_seq_fifo_load(desc, 0, FIFOLD_CLASS_CLASS1 | FIFOLDST_VLF |
-			     FIFOLD_TYPE_MSG | FIFOLD_TYPE_LAST1);
-
-	/* Write ICV */
-	append_seq_store(desc, ctx->authsize, LDST_CLASS_1_CCB |
-			 LDST_SRCDST_BYTE_CONTEXT);
-
-	ctx->sh_desc_givenc_dma = dma_map_single(jrdev, desc,
-						 desc_bytes(desc),
-						 DMA_TO_DEVICE);
-	if (dma_mapping_error(jrdev, ctx->sh_desc_givenc_dma)) {
-		dev_err(jrdev, "unable to map shared descriptor\n");
-		return -ENOMEM;
-	}
-#ifdef DEBUG
-	print_hex_dump(KERN_ERR,
-		       "rfc4106 givenc shdesc@"__stringify(__LINE__)": ",
-		       DUMP_PREFIX_ADDRESS, 16, 4, desc,
-		       desc_bytes(desc), 1);
-#endif
-
 	return 0;
 }
 
@@ -1249,14 +1099,12 @@ static int rfc4106_setauthsize(struct crypto_aead *authenc,
 
 static int rfc4543_set_sh_desc(struct crypto_aead *aead)
 {
-	unsigned int ivsize = crypto_aead_ivsize(aead);
 	struct caam_ctx *ctx = crypto_aead_ctx(aead);
 	struct device *jrdev = ctx->jrdev;
 	bool keys_fit_inline = false;
-	u32 *key_jump_cmd, *write_iv_cmd, *write_aad_cmd;
+	u32 *key_jump_cmd;
 	u32 *read_move_cmd, *write_move_cmd;
 	u32 *desc;
-	u32 geniv;
 
 	if (!ctx->enckeylen || !ctx->authsize)
 		return 0;
@@ -1266,7 +1114,7 @@ static int rfc4543_set_sh_desc(struct crypto_aead *aead)
 	 * Job Descriptor and Shared Descriptor
 	 * must fit into the 64-word Descriptor h/w Buffer
 	 */
-	if (DESC_RFC4543_ENC_LEN + DESC_JOB_IO_LEN +
+	if (DESC_RFC4543_ENC_LEN + GCM_DESC_JOB_IO_LEN +
 	    ctx->enckeylen <= CAAM_DESC_BYTES_MAX)
 		keys_fit_inline = true;
 
@@ -1289,48 +1137,8 @@ static int rfc4543_set_sh_desc(struct crypto_aead *aead)
 	append_operation(desc, ctx->class1_alg_type |
 			 OP_ALG_AS_INITFINAL | OP_ALG_ENCRYPT);
 
-	/* Load AES-GMAC ESP IV into Math1 register */
-	append_cmd(desc, CMD_SEQ_LOAD | LDST_SRCDST_WORD_DECO_MATH1 |
-		   LDST_CLASS_DECO | ivsize);
-
-	/* Wait the DMA transaction to finish */
-	append_jump(desc, JUMP_TEST_ALL | JUMP_COND_CALM |
-		    (1 << JUMP_OFFSET_SHIFT));
-
-	/* Overwrite blank immediate AES-GMAC ESP IV data */
-	write_iv_cmd = append_move(desc, MOVE_SRC_MATH1 | MOVE_DEST_DESCBUF |
-				   (ivsize << MOVE_LEN_SHIFT));
-
-	/* Overwrite blank immediate AAD data */
-	write_aad_cmd = append_move(desc, MOVE_SRC_MATH1 | MOVE_DEST_DESCBUF |
-				    (ivsize << MOVE_LEN_SHIFT));
-
-	/* cryptlen = seqoutlen - authsize */
-	append_math_sub_imm_u32(desc, REG3, SEQOUTLEN, IMM, ctx->authsize);
-
-	/* assoclen = (seqinlen - ivsize) - cryptlen */
-	append_math_sub(desc, VARSEQINLEN, SEQINLEN, REG3, CAAM_CMD_SZ);
-
-	/* Read Salt and AES-GMAC ESP IV */
-	append_cmd(desc, CMD_FIFO_LOAD | FIFOLD_CLASS_CLASS1 | IMMEDIATE |
-		   FIFOLD_TYPE_IV | FIFOLD_TYPE_FLUSH1 | (4 + ivsize));
-	/* Append Salt */
-	append_data(desc, (void *)(ctx->key + ctx->enckeylen), 4);
-	set_move_tgt_here(desc, write_iv_cmd);
-	/* Blank commands. Will be overwritten by AES-GMAC ESP IV. */
-	append_cmd(desc, 0x00000000);
-	append_cmd(desc, 0x00000000);
-	/* End of blank commands */
-
-	/* Read assoc data */
-	append_seq_fifo_load(desc, 0, FIFOLD_CLASS_CLASS1 | FIFOLDST_VLF |
-			     FIFOLD_TYPE_AAD);
-
-	/* Will read cryptlen bytes */
-	append_math_add(desc, VARSEQINLEN, ZERO, REG3, CAAM_CMD_SZ);
-
-	/* Will write cryptlen bytes */
-	append_math_add(desc, VARSEQOUTLEN, ZERO, REG3, CAAM_CMD_SZ);
+	/* assoclen + cryptlen = seqinlen */
+	append_math_add(desc, REG3, SEQINLEN, REG0, CAAM_CMD_SZ);
 
 	/*
 	 * MOVE_LEN opcode is not available in all SEC HW revisions,
@@ -1342,17 +1150,16 @@ static int rfc4543_set_sh_desc(struct crypto_aead *aead)
 	write_move_cmd = append_move(desc, MOVE_SRC_MATH3 | MOVE_DEST_DESCBUF |
 				     (0x8 << MOVE_LEN_SHIFT));
 
-	/* Authenticate AES-GMAC ESP IV  */
-	append_cmd(desc, CMD_FIFO_LOAD | FIFOLD_CLASS_CLASS1 | IMMEDIATE |
-		   FIFOLD_TYPE_AAD | ivsize);
-	set_move_tgt_here(desc, write_aad_cmd);
-	/* Blank commands. Will be overwritten by AES-GMAC ESP IV. */
-	append_cmd(desc, 0x00000000);
-	append_cmd(desc, 0x00000000);
-	/* End of blank commands */
+	/* Will read assoclen + cryptlen bytes */
+	append_math_add(desc, VARSEQINLEN, ZERO, REG3, CAAM_CMD_SZ);
 
-	/* Read and write cryptlen bytes */
-	aead_append_src_dst(desc, FIFOLD_TYPE_AAD);
+	/* Will write assoclen + cryptlen bytes */
+	append_math_add(desc, VARSEQOUTLEN, ZERO, REG3, CAAM_CMD_SZ);
+
+	/* Read and write assoclen + cryptlen bytes */
+	append_seq_fifo_store(desc, 0, FIFOST_TYPE_MESSAGE_DATA | KEY_VLF);
+	append_seq_fifo_load(desc, 0, FIFOLD_CLASS_BOTH | KEY_VLF |
+				      FIFOLD_TYPE_AAD | FIFOLD_TYPE_LASTBOTH);
 
 	set_move_tgt_here(desc, read_move_cmd);
 	set_move_tgt_here(desc, write_move_cmd);
@@ -1382,7 +1189,7 @@ static int rfc4543_set_sh_desc(struct crypto_aead *aead)
 	 * must all fit into the 64-word Descriptor h/w Buffer
 	 */
 	keys_fit_inline = false;
-	if (DESC_RFC4543_DEC_LEN + DESC_JOB_IO_LEN +
+	if (DESC_RFC4543_DEC_LEN + GCM_DESC_JOB_IO_LEN +
 	    ctx->enckeylen <= CAAM_DESC_BYTES_MAX)
 		keys_fit_inline = true;
 
@@ -1405,28 +1212,8 @@ static int rfc4543_set_sh_desc(struct crypto_aead *aead)
 	append_operation(desc, ctx->class1_alg_type |
 			 OP_ALG_AS_INITFINAL | OP_ALG_DECRYPT | OP_ALG_ICV_ON);
 
-	/* Load AES-GMAC ESP IV into Math1 register */
-	append_cmd(desc, CMD_SEQ_LOAD | LDST_SRCDST_WORD_DECO_MATH1 |
-		   LDST_CLASS_DECO | ivsize);
-
-	/* Wait the DMA transaction to finish */
-	append_jump(desc, JUMP_TEST_ALL | JUMP_COND_CALM |
-		    (1 << JUMP_OFFSET_SHIFT));
-
-	/* assoclen + cryptlen = (seqinlen - ivsize) - icvsize */
-	append_math_sub_imm_u32(desc, REG3, SEQINLEN, IMM, ctx->authsize);
-
-	/* Overwrite blank immediate AES-GMAC ESP IV data */
-	write_iv_cmd = append_move(desc, MOVE_SRC_MATH1 | MOVE_DEST_DESCBUF |
-				   (ivsize << MOVE_LEN_SHIFT));
-
-	/* Overwrite blank immediate AAD data */
-	write_aad_cmd = append_move(desc, MOVE_SRC_MATH1 | MOVE_DEST_DESCBUF |
-				    (ivsize << MOVE_LEN_SHIFT));
-
-	/* assoclen = (assoclen + cryptlen) - cryptlen */
-	append_math_sub(desc, REG2, SEQOUTLEN, REG0, CAAM_CMD_SZ);
-	append_math_sub(desc, VARSEQINLEN, REG3, REG2, CAAM_CMD_SZ);
+	/* assoclen + cryptlen = seqoutlen */
+	append_math_add(desc, REG3, SEQOUTLEN, REG0, CAAM_CMD_SZ);
 
 	/*
 	 * MOVE_LEN opcode is not available in all SEC HW revisions,
@@ -1438,40 +1225,16 @@ static int rfc4543_set_sh_desc(struct crypto_aead *aead)
 	write_move_cmd = append_move(desc, MOVE_SRC_MATH3 | MOVE_DEST_DESCBUF |
 				     (0x8 << MOVE_LEN_SHIFT));
 
-	/* Read Salt and AES-GMAC ESP IV */
-	append_cmd(desc, CMD_FIFO_LOAD | FIFOLD_CLASS_CLASS1 | IMMEDIATE |
-		   FIFOLD_TYPE_IV | FIFOLD_TYPE_FLUSH1 | (4 + ivsize));
-	/* Append Salt */
-	append_data(desc, (void *)(ctx->key + ctx->enckeylen), 4);
-	set_move_tgt_here(desc, write_iv_cmd);
-	/* Blank commands. Will be overwritten by AES-GMAC ESP IV. */
-	append_cmd(desc, 0x00000000);
-	append_cmd(desc, 0x00000000);
-	/* End of blank commands */
-
-	/* Read assoc data */
-	append_seq_fifo_load(desc, 0, FIFOLD_CLASS_CLASS1 | FIFOLDST_VLF |
-			     FIFOLD_TYPE_AAD);
-
-	/* Will read cryptlen bytes */
-	append_math_add(desc, VARSEQINLEN, ZERO, REG2, CAAM_CMD_SZ);
-
-	/* Will write cryptlen bytes */
-	append_math_add(desc, VARSEQOUTLEN, ZERO, REG2, CAAM_CMD_SZ);
+	/* Will read assoclen + cryptlen bytes */
+	append_math_add(desc, VARSEQINLEN, ZERO, REG3, CAAM_CMD_SZ);
 
-	/* Authenticate AES-GMAC ESP IV  */
-	append_cmd(desc, CMD_FIFO_LOAD | FIFOLD_CLASS_CLASS1 | IMMEDIATE |
-		   FIFOLD_TYPE_AAD | ivsize);
-	set_move_tgt_here(desc, write_aad_cmd);
-	/* Blank commands. Will be overwritten by AES-GMAC ESP IV. */
-	append_cmd(desc, 0x00000000);
-	append_cmd(desc, 0x00000000);
-	/* End of blank commands */
+	/* Will write assoclen + cryptlen bytes */
+	append_math_add(desc, VARSEQOUTLEN, ZERO, REG3, CAAM_CMD_SZ);
 
 	/* Store payload data */
 	append_seq_fifo_store(desc, 0, FIFOST_TYPE_MESSAGE_DATA | FIFOLDST_VLF);
 
-	/* In-snoop cryptlen data */
+	/* In-snoop assoclen + cryptlen data */
 	append_seq_fifo_load(desc, 0, FIFOLD_CLASS_BOTH | FIFOLDST_VLF |
 			     FIFOLD_TYPE_AAD | FIFOLD_TYPE_LAST2FLUSH1);
 
@@ -1499,148 +1262,19 @@ static int rfc4543_set_sh_desc(struct crypto_aead *aead)
 		       desc_bytes(desc), 1);
 #endif
 
-	/*
-	 * Job Descriptor and Shared Descriptors
-	 * must all fit into the 64-word Descriptor h/w Buffer
-	 */
-	keys_fit_inline = false;
-	if (DESC_RFC4543_GIVENC_LEN + DESC_JOB_IO_LEN +
-	    ctx->enckeylen <= CAAM_DESC_BYTES_MAX)
-		keys_fit_inline = true;
-
-	/* rfc4543_givencrypt shared descriptor */
-	desc = ctx->sh_desc_givenc;
+	return 0;
+}
 
-	init_sh_desc(desc, HDR_SHARE_SERIAL);
+static int rfc4543_setauthsize(struct crypto_aead *authenc,
+			       unsigned int authsize)
+{
+	struct caam_ctx *ctx = crypto_aead_ctx(authenc);
 
-	/* Skip key loading if it is loaded due to sharing */
-	key_jump_cmd = append_jump(desc, JUMP_JSL | JUMP_TEST_ALL |
-				   JUMP_COND_SHRD);
-	if (keys_fit_inline)
-		append_key_as_imm(desc, (void *)ctx->key, ctx->enckeylen,
-				  ctx->enckeylen, CLASS_1 | KEY_DEST_CLASS_REG);
-	else
-		append_key(desc, ctx->key_dma, ctx->enckeylen,
-			   CLASS_1 | KEY_DEST_CLASS_REG);
-	set_jump_tgt_here(desc, key_jump_cmd);
+	ctx->authsize = authsize;
+	rfc4543_set_sh_desc(authenc);
 
-	/* Generate IV */
-	geniv = NFIFOENTRY_STYPE_PAD | NFIFOENTRY_DEST_DECO |
-		NFIFOENTRY_DTYPE_MSG | NFIFOENTRY_LC1 |
-		NFIFOENTRY_PTYPE_RND | (ivsize << NFIFOENTRY_DLEN_SHIFT);
-	append_load_imm_u32(desc, geniv, LDST_CLASS_IND_CCB |
-			    LDST_SRCDST_WORD_INFO_FIFO | LDST_IMM);
-	append_cmd(desc, CMD_LOAD | DISABLE_AUTO_INFO_FIFO);
-	/* Move generated IV to Math1 register */
-	append_move(desc, MOVE_SRC_INFIFO | MOVE_DEST_MATH1 |
-		    (ivsize << MOVE_LEN_SHIFT));
-	append_cmd(desc, CMD_LOAD | ENABLE_AUTO_INFO_FIFO);
-
-	/* Overwrite blank immediate AES-GMAC IV data */
-	write_iv_cmd = append_move(desc, MOVE_SRC_MATH1 | MOVE_DEST_DESCBUF |
-				   (ivsize << MOVE_LEN_SHIFT));
-
-	/* Overwrite blank immediate AAD data */
-	write_aad_cmd = append_move(desc, MOVE_SRC_MATH1 | MOVE_DEST_DESCBUF |
-				    (ivsize << MOVE_LEN_SHIFT));
-
-	/* Copy generated IV to OFIFO */
-	append_move(desc, MOVE_SRC_MATH1 | MOVE_DEST_OUTFIFO |
-		    (ivsize << MOVE_LEN_SHIFT));
-
-	/* Class 1 operation */
-	append_operation(desc, ctx->class1_alg_type |
-			 OP_ALG_AS_INITFINAL | OP_ALG_ENCRYPT);
-
-	/* ivsize + cryptlen = seqoutlen - authsize */
-	append_math_sub_imm_u32(desc, REG3, SEQOUTLEN, IMM, ctx->authsize);
-
-	/* assoclen = seqinlen - (ivsize + cryptlen) */
-	append_math_sub(desc, VARSEQINLEN, SEQINLEN, REG3, CAAM_CMD_SZ);
-
-	/* Will write ivsize + cryptlen */
-	append_math_add(desc, VARSEQOUTLEN, REG3, REG0, CAAM_CMD_SZ);
-
-	/*
-	 * MOVE_LEN opcode is not available in all SEC HW revisions,
-	 * thus need to do some magic, i.e. self-patch the descriptor
-	 * buffer.
-	 */
-	read_move_cmd = append_move(desc, MOVE_SRC_DESCBUF | MOVE_DEST_MATH3 |
-				    (0x6 << MOVE_LEN_SHIFT));
-	write_move_cmd = append_move(desc, MOVE_SRC_MATH3 | MOVE_DEST_DESCBUF |
-				     (0x8 << MOVE_LEN_SHIFT));
-
-	/* Read Salt and AES-GMAC generated IV */
-	append_cmd(desc, CMD_FIFO_LOAD | FIFOLD_CLASS_CLASS1 | IMMEDIATE |
-		   FIFOLD_TYPE_IV | FIFOLD_TYPE_FLUSH1 | (4 + ivsize));
-	/* Append Salt */
-	append_data(desc, (void *)(ctx->key + ctx->enckeylen), 4);
-	set_move_tgt_here(desc, write_iv_cmd);
-	/* Blank commands. Will be overwritten by AES-GMAC generated IV. */
-	append_cmd(desc, 0x00000000);
-	append_cmd(desc, 0x00000000);
-	/* End of blank commands */
-
-	/* No need to reload iv */
-	append_seq_fifo_load(desc, ivsize, FIFOLD_CLASS_SKIP);
-
-	/* Read assoc data */
-	append_seq_fifo_load(desc, 0, FIFOLD_CLASS_CLASS1 | FIFOLDST_VLF |
-			     FIFOLD_TYPE_AAD);
-
-	/* Will read cryptlen */
-	append_math_add(desc, VARSEQINLEN, SEQINLEN, REG0, CAAM_CMD_SZ);
-
-	/* Authenticate AES-GMAC IV  */
-	append_cmd(desc, CMD_FIFO_LOAD | FIFOLD_CLASS_CLASS1 | IMMEDIATE |
-		   FIFOLD_TYPE_AAD | ivsize);
-	set_move_tgt_here(desc, write_aad_cmd);
-	/* Blank commands. Will be overwritten by AES-GMAC IV. */
-	append_cmd(desc, 0x00000000);
-	append_cmd(desc, 0x00000000);
-	/* End of blank commands */
-
-	/* Read and write cryptlen bytes */
-	aead_append_src_dst(desc, FIFOLD_TYPE_AAD);
-
-	set_move_tgt_here(desc, read_move_cmd);
-	set_move_tgt_here(desc, write_move_cmd);
-	append_cmd(desc, CMD_LOAD | DISABLE_AUTO_INFO_FIFO);
-	/* Move payload data to OFIFO */
-	append_move(desc, MOVE_SRC_INFIFO_CL | MOVE_DEST_OUTFIFO);
-
-	/* Write ICV */
-	append_seq_store(desc, ctx->authsize, LDST_CLASS_1_CCB |
-			 LDST_SRCDST_BYTE_CONTEXT);
-
-	ctx->sh_desc_givenc_dma = dma_map_single(jrdev, desc,
-						 desc_bytes(desc),
-						 DMA_TO_DEVICE);
-	if (dma_mapping_error(jrdev, ctx->sh_desc_givenc_dma)) {
-		dev_err(jrdev, "unable to map shared descriptor\n");
-		return -ENOMEM;
-	}
-#ifdef DEBUG
-	print_hex_dump(KERN_ERR,
-		       "rfc4543 givenc shdesc@"__stringify(__LINE__)": ",
-		       DUMP_PREFIX_ADDRESS, 16, 4, desc,
-		       desc_bytes(desc), 1);
-#endif
-
-	return 0;
-}
-
-static int rfc4543_setauthsize(struct crypto_aead *authenc,
-			       unsigned int authsize)
-{
-	struct caam_ctx *ctx = crypto_aead_ctx(authenc);
-
-	ctx->authsize = authsize;
-	rfc4543_set_sh_desc(authenc);
-
-	return 0;
-}
+	return 0;
+}
 
 static u32 gen_split_aead_key(struct caam_ctx *ctx, const u8 *key_in,
 			      u32 authkeylen)
@@ -2100,7 +1734,7 @@ struct aead_edesc {
 	int sec4_sg_bytes;
 	dma_addr_t sec4_sg_dma;
 	struct sec4_sg_entry *sec4_sg;
-	u32 hw_desc[0];
+	u32 hw_desc[];
 };
 
 /*
@@ -2154,6 +1788,16 @@ static void aead_unmap(struct device *dev,
 		       struct aead_edesc *edesc,
 		       struct aead_request *req)
 {
+	caam_unmap(dev, req->src, req->dst,
+		   edesc->src_nents, edesc->src_chained, edesc->dst_nents,
+		   edesc->dst_chained, 0, 0,
+		   edesc->sec4_sg_dma, edesc->sec4_sg_bytes);
+}
+
+static void old_aead_unmap(struct device *dev,
+			   struct aead_edesc *edesc,
+			   struct aead_request *req)
+{
 	struct crypto_aead *aead = crypto_aead_reqtfm(req);
 	int ivsize = crypto_aead_ivsize(aead);
 
@@ -2184,6 +1828,28 @@ static void aead_encrypt_done(struct device *jrdev, u32 *desc, u32 err,
 {
 	struct aead_request *req = context;
 	struct aead_edesc *edesc;
+
+#ifdef DEBUG
+	dev_err(jrdev, "%s %d: err 0x%x\n", __func__, __LINE__, err);
+#endif
+
+	edesc = container_of(desc, struct aead_edesc, hw_desc[0]);
+
+	if (err)
+		caam_jr_strstatus(jrdev, err);
+
+	aead_unmap(jrdev, edesc, req);
+
+	kfree(edesc);
+
+	aead_request_complete(req, err);
+}
+
+static void old_aead_encrypt_done(struct device *jrdev, u32 *desc, u32 err,
+				  void *context)
+{
+	struct aead_request *req = context;
+	struct aead_edesc *edesc;
 #ifdef DEBUG
 	struct crypto_aead *aead = crypto_aead_reqtfm(req);
 	struct caam_ctx *ctx = crypto_aead_ctx(aead);
@@ -2198,7 +1864,7 @@ static void aead_encrypt_done(struct device *jrdev, u32 *desc, u32 err,
 	if (err)
 		caam_jr_strstatus(jrdev, err);
 
-	aead_unmap(jrdev, edesc, req);
+	old_aead_unmap(jrdev, edesc, req);
 
 #ifdef DEBUG
 	print_hex_dump(KERN_ERR, "assoc  @"__stringify(__LINE__)": ",
@@ -2223,6 +1889,34 @@ static void aead_decrypt_done(struct device *jrdev, u32 *desc, u32 err,
 {
 	struct aead_request *req = context;
 	struct aead_edesc *edesc;
+
+#ifdef DEBUG
+	dev_err(jrdev, "%s %d: err 0x%x\n", __func__, __LINE__, err);
+#endif
+
+	edesc = container_of(desc, struct aead_edesc, hw_desc[0]);
+
+	if (err)
+		caam_jr_strstatus(jrdev, err);
+
+	aead_unmap(jrdev, edesc, req);
+
+	/*
+	 * verify hw auth check passed else return -EBADMSG
+	 */
+	if ((err & JRSTA_CCBERR_ERRID_MASK) == JRSTA_CCBERR_ERRID_ICVCHK)
+		err = -EBADMSG;
+
+	kfree(edesc);
+
+	aead_request_complete(req, err);
+}
+
+static void old_aead_decrypt_done(struct device *jrdev, u32 *desc, u32 err,
+				  void *context)
+{
+	struct aead_request *req = context;
+	struct aead_edesc *edesc;
 #ifdef DEBUG
 	struct crypto_aead *aead = crypto_aead_reqtfm(req);
 	struct caam_ctx *ctx = crypto_aead_ctx(aead);
@@ -2246,7 +1940,7 @@ static void aead_decrypt_done(struct device *jrdev, u32 *desc, u32 err,
 	if (err)
 		caam_jr_strstatus(jrdev, err);
 
-	aead_unmap(jrdev, edesc, req);
+	old_aead_unmap(jrdev, edesc, req);
 
 	/*
 	 * verify hw auth check passed else return -EBADMSG
@@ -2342,10 +2036,10 @@ static void ablkcipher_decrypt_done(struct device *jrdev, u32 *desc, u32 err,
 /*
  * Fill in aead job descriptor
  */
-static void init_aead_job(u32 *sh_desc, dma_addr_t ptr,
-			  struct aead_edesc *edesc,
-			  struct aead_request *req,
-			  bool all_contig, bool encrypt)
+static void old_init_aead_job(u32 *sh_desc, dma_addr_t ptr,
+			      struct aead_edesc *edesc,
+			      struct aead_request *req,
+			      bool all_contig, bool encrypt)
 {
 	struct crypto_aead *aead = crypto_aead_reqtfm(req);
 	struct caam_ctx *ctx = crypto_aead_ctx(aead);
@@ -2425,6 +2119,97 @@ static void init_aead_job(u32 *sh_desc, dma_addr_t ptr,
 }
 
 /*
+ * Fill in aead job descriptor
+ */
+static void init_aead_job(struct aead_request *req,
+			  struct aead_edesc *edesc,
+			  bool all_contig, bool encrypt)
+{
+	struct crypto_aead *aead = crypto_aead_reqtfm(req);
+	struct caam_ctx *ctx = crypto_aead_ctx(aead);
+	int authsize = ctx->authsize;
+	u32 *desc = edesc->hw_desc;
+	u32 out_options, in_options;
+	dma_addr_t dst_dma, src_dma;
+	int len, sec4_sg_index = 0;
+	dma_addr_t ptr;
+	u32 *sh_desc;
+
+	sh_desc = encrypt ? ctx->sh_desc_enc : ctx->sh_desc_dec;
+	ptr = encrypt ? ctx->sh_desc_enc_dma : ctx->sh_desc_dec_dma;
+
+	len = desc_len(sh_desc);
+	init_job_desc_shared(desc, ptr, len, HDR_SHARE_DEFER | HDR_REVERSE);
+
+	if (all_contig) {
+		src_dma = sg_dma_address(req->src);
+		in_options = 0;
+	} else {
+		src_dma = edesc->sec4_sg_dma;
+		sec4_sg_index += edesc->src_nents;
+		in_options = LDST_SGF;
+	}
+
+	append_seq_in_ptr(desc, src_dma, req->assoclen + req->cryptlen,
+			  in_options);
+
+	dst_dma = src_dma;
+	out_options = in_options;
+
+	if (unlikely(req->src != req->dst)) {
+		if (!edesc->dst_nents) {
+			dst_dma = sg_dma_address(req->dst);
+		} else {
+			dst_dma = edesc->sec4_sg_dma +
+				  sec4_sg_index *
+				  sizeof(struct sec4_sg_entry);
+			out_options = LDST_SGF;
+		}
+	}
+
+	if (encrypt)
+		append_seq_out_ptr(desc, dst_dma,
+				   req->assoclen + req->cryptlen + authsize,
+				   out_options);
+	else
+		append_seq_out_ptr(desc, dst_dma,
+				   req->assoclen + req->cryptlen - authsize,
+				   out_options);
+
+	/* REG3 = assoclen */
+	append_math_add_imm_u32(desc, REG3, ZERO, IMM, req->assoclen);
+}
+
+static void init_gcm_job(struct aead_request *req,
+			 struct aead_edesc *edesc,
+			 bool all_contig, bool encrypt)
+{
+	struct crypto_aead *aead = crypto_aead_reqtfm(req);
+	struct caam_ctx *ctx = crypto_aead_ctx(aead);
+	unsigned int ivsize = crypto_aead_ivsize(aead);
+	u32 *desc = edesc->hw_desc;
+	bool generic_gcm = (ivsize == 12);
+	unsigned int last;
+
+	init_aead_job(req, edesc, all_contig, encrypt);
+
+	/* BUG This should not be specific to generic GCM. */
+	last = 0;
+	if (encrypt && generic_gcm && !(req->assoclen + req->cryptlen))
+		last = FIFOLD_TYPE_LAST1;
+
+	/* Read GCM IV */
+	append_cmd(desc, CMD_FIFO_LOAD | FIFOLD_CLASS_CLASS1 | IMMEDIATE |
+			 FIFOLD_TYPE_IV | FIFOLD_TYPE_FLUSH1 | 12 | last);
+	/* Append Salt */
+	if (!generic_gcm)
+		append_data(desc, ctx->key + ctx->enckeylen, 4);
+	/* Append IV */
+	append_data(desc, req->iv, ivsize);
+	/* End of blank commands */
+}
+
+/*
  * Fill in aead givencrypt job descriptor
  */
 static void init_aead_giv_job(u32 *sh_desc, dma_addr_t ptr,
@@ -2608,9 +2393,10 @@ static void init_ablkcipher_giv_job(u32 *sh_desc, dma_addr_t ptr,
 /*
  * allocate and map the aead extended descriptor
  */
-static struct aead_edesc *aead_edesc_alloc(struct aead_request *req,
-					   int desc_bytes, bool *all_contig_ptr,
-					   bool encrypt)
+static struct aead_edesc *old_aead_edesc_alloc(struct aead_request *req,
+					       int desc_bytes,
+					       bool *all_contig_ptr,
+					       bool encrypt)
 {
 	struct crypto_aead *aead = crypto_aead_reqtfm(req);
 	struct caam_ctx *ctx = crypto_aead_ctx(aead);
@@ -2661,29 +2447,132 @@ static struct aead_edesc *aead_edesc_alloc(struct aead_request *req,
 		return ERR_PTR(-ENOMEM);
 	}
 
-	if (((ctx->class1_alg_type & OP_ALG_ALGSEL_MASK) ==
-	      OP_ALG_ALGSEL_AES) &&
-	    ((ctx->class1_alg_type & OP_ALG_AAI_MASK) == OP_ALG_AAI_GCM))
-		is_gcm = true;
+	if (((ctx->class1_alg_type & OP_ALG_ALGSEL_MASK) ==
+	      OP_ALG_ALGSEL_AES) &&
+	    ((ctx->class1_alg_type & OP_ALG_AAI_MASK) == OP_ALG_AAI_GCM))
+		is_gcm = true;
+
+	/*
+	 * Check if data are contiguous.
+	 * GCM expected input sequence: IV, AAD, text
+	 * All other - expected input sequence: AAD, IV, text
+	 */
+	if (is_gcm)
+		all_contig = (!assoc_nents &&
+			      iv_dma + ivsize == sg_dma_address(req->assoc) &&
+			      !src_nents && sg_dma_address(req->assoc) +
+			      req->assoclen == sg_dma_address(req->src));
+	else
+		all_contig = (!assoc_nents && sg_dma_address(req->assoc) +
+			      req->assoclen == iv_dma && !src_nents &&
+			      iv_dma + ivsize == sg_dma_address(req->src));
+	if (!all_contig) {
+		assoc_nents = assoc_nents ? : 1;
+		src_nents = src_nents ? : 1;
+		sec4_sg_len = assoc_nents + 1 + src_nents;
+	}
+
+	sec4_sg_len += dst_nents;
+
+	sec4_sg_bytes = sec4_sg_len * sizeof(struct sec4_sg_entry);
+
+	/* allocate space for base edesc and hw desc commands, link tables */
+	edesc = kmalloc(sizeof(struct aead_edesc) + desc_bytes +
+			sec4_sg_bytes, GFP_DMA | flags);
+	if (!edesc) {
+		dev_err(jrdev, "could not allocate extended descriptor\n");
+		return ERR_PTR(-ENOMEM);
+	}
+
+	edesc->assoc_nents = assoc_nents;
+	edesc->assoc_chained = assoc_chained;
+	edesc->src_nents = src_nents;
+	edesc->src_chained = src_chained;
+	edesc->dst_nents = dst_nents;
+	edesc->dst_chained = dst_chained;
+	edesc->iv_dma = iv_dma;
+	edesc->sec4_sg_bytes = sec4_sg_bytes;
+	edesc->sec4_sg = (void *)edesc + sizeof(struct aead_edesc) +
+			 desc_bytes;
+	*all_contig_ptr = all_contig;
+
+	sec4_sg_index = 0;
+	if (!all_contig) {
+		if (!is_gcm) {
+			sg_to_sec4_sg_len(req->assoc, req->assoclen,
+					  edesc->sec4_sg + sec4_sg_index);
+			sec4_sg_index += assoc_nents;
+		}
+
+		dma_to_sec4_sg_one(edesc->sec4_sg + sec4_sg_index,
+				   iv_dma, ivsize, 0);
+		sec4_sg_index += 1;
+
+		if (is_gcm) {
+			sg_to_sec4_sg_len(req->assoc, req->assoclen,
+					  edesc->sec4_sg + sec4_sg_index);
+			sec4_sg_index += assoc_nents;
+		}
+
+		sg_to_sec4_sg_last(req->src,
+				   src_nents,
+				   edesc->sec4_sg +
+				   sec4_sg_index, 0);
+		sec4_sg_index += src_nents;
+	}
+	if (dst_nents) {
+		sg_to_sec4_sg_last(req->dst, dst_nents,
+				   edesc->sec4_sg + sec4_sg_index, 0);
+	}
+	edesc->sec4_sg_dma = dma_map_single(jrdev, edesc->sec4_sg,
+					    sec4_sg_bytes, DMA_TO_DEVICE);
+	if (dma_mapping_error(jrdev, edesc->sec4_sg_dma)) {
+		dev_err(jrdev, "unable to map S/G table\n");
+		return ERR_PTR(-ENOMEM);
+	}
+
+	return edesc;
+}
+
+/*
+ * allocate and map the aead extended descriptor
+ */
+static struct aead_edesc *aead_edesc_alloc(struct aead_request *req,
+					   int desc_bytes, bool *all_contig_ptr,
+					   bool encrypt)
+{
+	struct crypto_aead *aead = crypto_aead_reqtfm(req);
+	struct caam_ctx *ctx = crypto_aead_ctx(aead);
+	struct device *jrdev = ctx->jrdev;
+	gfp_t flags = (req->base.flags & (CRYPTO_TFM_REQ_MAY_BACKLOG |
+		       CRYPTO_TFM_REQ_MAY_SLEEP)) ? GFP_KERNEL : GFP_ATOMIC;
+	int src_nents, dst_nents = 0;
+	struct aead_edesc *edesc;
+	int sgc;
+	bool all_contig = true;
+	bool src_chained = false, dst_chained = false;
+	int sec4_sg_index, sec4_sg_len = 0, sec4_sg_bytes;
+	unsigned int authsize = ctx->authsize;
+
+	if (unlikely(req->dst != req->src)) {
+		src_nents = sg_count(req->src, req->assoclen + req->cryptlen,
+				     &src_chained);
+		dst_nents = sg_count(req->dst,
+				     req->assoclen + req->cryptlen +
+					(encrypt ? authsize : (-authsize)),
+				     &dst_chained);
+	} else {
+		src_nents = sg_count(req->src,
+				     req->assoclen + req->cryptlen +
+					(encrypt ? authsize : 0),
+				     &src_chained);
+	}
 
-	/*
-	 * Check if data are contiguous.
-	 * GCM expected input sequence: IV, AAD, text
-	 * All other - expected input sequence: AAD, IV, text
-	 */
-	if (is_gcm)
-		all_contig = (!assoc_nents &&
-			      iv_dma + ivsize == sg_dma_address(req->assoc) &&
-			      !src_nents && sg_dma_address(req->assoc) +
-			      req->assoclen == sg_dma_address(req->src));
-	else
-		all_contig = (!assoc_nents && sg_dma_address(req->assoc) +
-			      req->assoclen == iv_dma && !src_nents &&
-			      iv_dma + ivsize == sg_dma_address(req->src));
+	/* Check if data are contiguous. */
+	all_contig = !src_nents;
 	if (!all_contig) {
-		assoc_nents = assoc_nents ? : 1;
 		src_nents = src_nents ? : 1;
-		sec4_sg_len = assoc_nents + 1 + src_nents;
+		sec4_sg_len = src_nents;
 	}
 
 	sec4_sg_len += dst_nents;
@@ -2691,64 +2580,78 @@ static struct aead_edesc *aead_edesc_alloc(struct aead_request *req,
 	sec4_sg_bytes = sec4_sg_len * sizeof(struct sec4_sg_entry);
 
 	/* allocate space for base edesc and hw desc commands, link tables */
-	edesc = kmalloc(sizeof(struct aead_edesc) + desc_bytes +
+	edesc = kzalloc(sizeof(struct aead_edesc) + desc_bytes +
 			sec4_sg_bytes, GFP_DMA | flags);
 	if (!edesc) {
 		dev_err(jrdev, "could not allocate extended descriptor\n");
 		return ERR_PTR(-ENOMEM);
 	}
 
-	edesc->assoc_nents = assoc_nents;
-	edesc->assoc_chained = assoc_chained;
+	if (likely(req->src == req->dst)) {
+		sgc = dma_map_sg_chained(jrdev, req->src, src_nents ? : 1,
+					 DMA_BIDIRECTIONAL, src_chained);
+		if (unlikely(!sgc)) {
+			dev_err(jrdev, "unable to map source\n");
+			kfree(edesc);
+			return ERR_PTR(-ENOMEM);
+		}
+	} else {
+		sgc = dma_map_sg_chained(jrdev, req->src, src_nents ? : 1,
+					 DMA_TO_DEVICE, src_chained);
+		if (unlikely(!sgc)) {
+			dev_err(jrdev, "unable to map source\n");
+			kfree(edesc);
+			return ERR_PTR(-ENOMEM);
+		}
+
+		sgc = dma_map_sg_chained(jrdev, req->dst, dst_nents ? : 1,
+					 DMA_FROM_DEVICE, dst_chained);
+		if (unlikely(!sgc)) {
+			dev_err(jrdev, "unable to map destination\n");
+			dma_unmap_sg_chained(jrdev, req->src, src_nents ? : 1,
+					     DMA_TO_DEVICE, src_chained);
+			kfree(edesc);
+			return ERR_PTR(-ENOMEM);
+		}
+	}
+
 	edesc->src_nents = src_nents;
 	edesc->src_chained = src_chained;
 	edesc->dst_nents = dst_nents;
 	edesc->dst_chained = dst_chained;
-	edesc->iv_dma = iv_dma;
-	edesc->sec4_sg_bytes = sec4_sg_bytes;
 	edesc->sec4_sg = (void *)edesc + sizeof(struct aead_edesc) +
 			 desc_bytes;
 	*all_contig_ptr = all_contig;
 
 	sec4_sg_index = 0;
 	if (!all_contig) {
-		if (!is_gcm) {
-			sg_to_sec4_sg_len(req->assoc, req->assoclen,
-					  edesc->sec4_sg + sec4_sg_index);
-			sec4_sg_index += assoc_nents;
-		}
-
-		dma_to_sec4_sg_one(edesc->sec4_sg + sec4_sg_index,
-				   iv_dma, ivsize, 0);
-		sec4_sg_index += 1;
-
-		if (is_gcm) {
-			sg_to_sec4_sg_len(req->assoc, req->assoclen,
-					  edesc->sec4_sg + sec4_sg_index);
-			sec4_sg_index += assoc_nents;
-		}
-
-		sg_to_sec4_sg_last(req->src,
-				   src_nents,
-				   edesc->sec4_sg +
-				   sec4_sg_index, 0);
+		sg_to_sec4_sg(req->src, src_nents,
+			      edesc->sec4_sg + sec4_sg_index, 0);
 		sec4_sg_index += src_nents;
 	}
 	if (dst_nents) {
 		sg_to_sec4_sg_last(req->dst, dst_nents,
 				   edesc->sec4_sg + sec4_sg_index, 0);
 	}
+
+	if (!sec4_sg_bytes)
+		return edesc;
+
 	edesc->sec4_sg_dma = dma_map_single(jrdev, edesc->sec4_sg,
 					    sec4_sg_bytes, DMA_TO_DEVICE);
 	if (dma_mapping_error(jrdev, edesc->sec4_sg_dma)) {
 		dev_err(jrdev, "unable to map S/G table\n");
+		aead_unmap(jrdev, edesc, req);
+		kfree(edesc);
 		return ERR_PTR(-ENOMEM);
 	}
 
+	edesc->sec4_sg_bytes = sec4_sg_bytes;
+
 	return edesc;
 }
 
-static int aead_encrypt(struct aead_request *req)
+static int gcm_encrypt(struct aead_request *req)
 {
 	struct aead_edesc *edesc;
 	struct crypto_aead *aead = crypto_aead_reqtfm(req);
@@ -2759,14 +2662,12 @@ static int aead_encrypt(struct aead_request *req)
 	int ret = 0;
 
 	/* allocate extended descriptor */
-	edesc = aead_edesc_alloc(req, DESC_JOB_IO_LEN *
-				 CAAM_CMD_SZ, &all_contig, true);
+	edesc = aead_edesc_alloc(req, GCM_DESC_JOB_IO_LEN, &all_contig, true);
 	if (IS_ERR(edesc))
 		return PTR_ERR(edesc);
 
 	/* Create and submit job descriptor */
-	init_aead_job(ctx->sh_desc_enc, ctx->sh_desc_enc_dma, edesc, req,
-		      all_contig, true);
+	init_gcm_job(req, edesc, all_contig, true);
 #ifdef DEBUG
 	print_hex_dump(KERN_ERR, "aead jobdesc@"__stringify(__LINE__)": ",
 		       DUMP_PREFIX_ADDRESS, 16, 4, edesc->hw_desc,
@@ -2785,7 +2686,79 @@ static int aead_encrypt(struct aead_request *req)
 	return ret;
 }
 
-static int aead_decrypt(struct aead_request *req)
+static int old_aead_encrypt(struct aead_request *req)
+{
+	struct aead_edesc *edesc;
+	struct crypto_aead *aead = crypto_aead_reqtfm(req);
+	struct caam_ctx *ctx = crypto_aead_ctx(aead);
+	struct device *jrdev = ctx->jrdev;
+	bool all_contig;
+	u32 *desc;
+	int ret = 0;
+
+	/* allocate extended descriptor */
+	edesc = old_aead_edesc_alloc(req, DESC_JOB_IO_LEN *
+				     CAAM_CMD_SZ, &all_contig, true);
+	if (IS_ERR(edesc))
+		return PTR_ERR(edesc);
+
+	/* Create and submit job descriptor */
+	old_init_aead_job(ctx->sh_desc_enc, ctx->sh_desc_enc_dma, edesc, req,
+			  all_contig, true);
+#ifdef DEBUG
+	print_hex_dump(KERN_ERR, "aead jobdesc@"__stringify(__LINE__)": ",
+		       DUMP_PREFIX_ADDRESS, 16, 4, edesc->hw_desc,
+		       desc_bytes(edesc->hw_desc), 1);
+#endif
+
+	desc = edesc->hw_desc;
+	ret = caam_jr_enqueue(jrdev, desc, old_aead_encrypt_done, req);
+	if (!ret) {
+		ret = -EINPROGRESS;
+	} else {
+		old_aead_unmap(jrdev, edesc, req);
+		kfree(edesc);
+	}
+
+	return ret;
+}
+
+static int gcm_decrypt(struct aead_request *req)
+{
+	struct aead_edesc *edesc;
+	struct crypto_aead *aead = crypto_aead_reqtfm(req);
+	struct caam_ctx *ctx = crypto_aead_ctx(aead);
+	struct device *jrdev = ctx->jrdev;
+	bool all_contig;
+	u32 *desc;
+	int ret = 0;
+
+	/* allocate extended descriptor */
+	edesc = aead_edesc_alloc(req, GCM_DESC_JOB_IO_LEN, &all_contig, false);
+	if (IS_ERR(edesc))
+		return PTR_ERR(edesc);
+
+	/* Create and submit job descriptor*/
+	init_gcm_job(req, edesc, all_contig, false);
+#ifdef DEBUG
+	print_hex_dump(KERN_ERR, "aead jobdesc@"__stringify(__LINE__)": ",
+		       DUMP_PREFIX_ADDRESS, 16, 4, edesc->hw_desc,
+		       desc_bytes(edesc->hw_desc), 1);
+#endif
+
+	desc = edesc->hw_desc;
+	ret = caam_jr_enqueue(jrdev, desc, aead_decrypt_done, req);
+	if (!ret) {
+		ret = -EINPROGRESS;
+	} else {
+		aead_unmap(jrdev, edesc, req);
+		kfree(edesc);
+	}
+
+	return ret;
+}
+
+static int old_aead_decrypt(struct aead_request *req)
 {
 	struct aead_edesc *edesc;
 	struct crypto_aead *aead = crypto_aead_reqtfm(req);
@@ -2796,8 +2769,8 @@ static int aead_decrypt(struct aead_request *req)
 	int ret = 0;
 
 	/* allocate extended descriptor */
-	edesc = aead_edesc_alloc(req, DESC_JOB_IO_LEN *
-				 CAAM_CMD_SZ, &all_contig, false);
+	edesc = old_aead_edesc_alloc(req, DESC_JOB_IO_LEN *
+				     CAAM_CMD_SZ, &all_contig, false);
 	if (IS_ERR(edesc))
 		return PTR_ERR(edesc);
 
@@ -2808,8 +2781,8 @@ static int aead_decrypt(struct aead_request *req)
 #endif
 
 	/* Create and submit job descriptor*/
-	init_aead_job(ctx->sh_desc_dec,
-		      ctx->sh_desc_dec_dma, edesc, req, all_contig, false);
+	old_init_aead_job(ctx->sh_desc_dec,
+			  ctx->sh_desc_dec_dma, edesc, req, all_contig, false);
 #ifdef DEBUG
 	print_hex_dump(KERN_ERR, "aead jobdesc@"__stringify(__LINE__)": ",
 		       DUMP_PREFIX_ADDRESS, 16, 4, edesc->hw_desc,
@@ -2817,11 +2790,11 @@ static int aead_decrypt(struct aead_request *req)
 #endif
 
 	desc = edesc->hw_desc;
-	ret = caam_jr_enqueue(jrdev, desc, aead_decrypt_done, req);
+	ret = caam_jr_enqueue(jrdev, desc, old_aead_decrypt_done, req);
 	if (!ret) {
 		ret = -EINPROGRESS;
 	} else {
-		aead_unmap(jrdev, edesc, req);
+		old_aead_unmap(jrdev, edesc, req);
 		kfree(edesc);
 	}
 
@@ -2995,7 +2968,7 @@ static struct aead_edesc *aead_giv_edesc_alloc(struct aead_givcrypt_request
 	return edesc;
 }
 
-static int aead_givencrypt(struct aead_givcrypt_request *areq)
+static int old_aead_givencrypt(struct aead_givcrypt_request *areq)
 {
 	struct aead_request *req = &areq->areq;
 	struct aead_edesc *edesc;
@@ -3029,11 +3002,11 @@ static int aead_givencrypt(struct aead_givcrypt_request *areq)
 #endif
 
 	desc = edesc->hw_desc;
-	ret = caam_jr_enqueue(jrdev, desc, aead_encrypt_done, req);
+	ret = caam_jr_enqueue(jrdev, desc, old_aead_encrypt_done, req);
 	if (!ret) {
 		ret = -EINPROGRESS;
 	} else {
-		aead_unmap(jrdev, edesc, req);
+		old_aead_unmap(jrdev, edesc, req);
 		kfree(edesc);
 	}
 
@@ -3042,7 +3015,7 @@ static int aead_givencrypt(struct aead_givcrypt_request *areq)
 
 static int aead_null_givencrypt(struct aead_givcrypt_request *areq)
 {
-	return aead_encrypt(&areq->areq);
+	return old_aead_encrypt(&areq->areq);
 }
 
 /*
@@ -3392,8 +3365,8 @@ static struct caam_alg_template driver_algs[] = {
 		.template_aead = {
 			.setkey = aead_setkey,
 			.setauthsize = aead_setauthsize,
-			.encrypt = aead_encrypt,
-			.decrypt = aead_decrypt,
+			.encrypt = old_aead_encrypt,
+			.decrypt = old_aead_decrypt,
 			.givencrypt = aead_null_givencrypt,
 			.geniv = "<built-in>",
 			.ivsize = NULL_IV_SIZE,
@@ -3411,8 +3384,8 @@ static struct caam_alg_template driver_algs[] = {
 		.template_aead = {
 			.setkey = aead_setkey,
 			.setauthsize = aead_setauthsize,
-			.encrypt = aead_encrypt,
-			.decrypt = aead_decrypt,
+			.encrypt = old_aead_encrypt,
+			.decrypt = old_aead_decrypt,
 			.givencrypt = aead_null_givencrypt,
 			.geniv = "<built-in>",
 			.ivsize = NULL_IV_SIZE,
@@ -3430,8 +3403,8 @@ static struct caam_alg_template driver_algs[] = {
 		.template_aead = {
 			.setkey = aead_setkey,
 			.setauthsize = aead_setauthsize,
-			.encrypt = aead_encrypt,
-			.decrypt = aead_decrypt,
+			.encrypt = old_aead_encrypt,
+			.decrypt = old_aead_decrypt,
 			.givencrypt = aead_null_givencrypt,
 			.geniv = "<built-in>",
 			.ivsize = NULL_IV_SIZE,
@@ -3450,8 +3423,8 @@ static struct caam_alg_template driver_algs[] = {
 		.template_aead = {
 			.setkey = aead_setkey,
 			.setauthsize = aead_setauthsize,
-			.encrypt = aead_encrypt,
-			.decrypt = aead_decrypt,
+			.encrypt = old_aead_encrypt,
+			.decrypt = old_aead_decrypt,
 			.givencrypt = aead_null_givencrypt,
 			.geniv = "<built-in>",
 			.ivsize = NULL_IV_SIZE,
@@ -3470,8 +3443,8 @@ static struct caam_alg_template driver_algs[] = {
 		.template_aead = {
 			.setkey = aead_setkey,
 			.setauthsize = aead_setauthsize,
-			.encrypt = aead_encrypt,
-			.decrypt = aead_decrypt,
+			.encrypt = old_aead_encrypt,
+			.decrypt = old_aead_decrypt,
 			.givencrypt = aead_null_givencrypt,
 			.geniv = "<built-in>",
 			.ivsize = NULL_IV_SIZE,
@@ -3490,8 +3463,8 @@ static struct caam_alg_template driver_algs[] = {
 		.template_aead = {
 			.setkey = aead_setkey,
 			.setauthsize = aead_setauthsize,
-			.encrypt = aead_encrypt,
-			.decrypt = aead_decrypt,
+			.encrypt = old_aead_encrypt,
+			.decrypt = old_aead_decrypt,
 			.givencrypt = aead_null_givencrypt,
 			.geniv = "<built-in>",
 			.ivsize = NULL_IV_SIZE,
@@ -3510,9 +3483,9 @@ static struct caam_alg_template driver_algs[] = {
 		.template_aead = {
 			.setkey = aead_setkey,
 			.setauthsize = aead_setauthsize,
-			.encrypt = aead_encrypt,
-			.decrypt = aead_decrypt,
-			.givencrypt = aead_givencrypt,
+			.encrypt = old_aead_encrypt,
+			.decrypt = old_aead_decrypt,
+			.givencrypt = old_aead_givencrypt,
 			.geniv = "<built-in>",
 			.ivsize = AES_BLOCK_SIZE,
 			.maxauthsize = MD5_DIGEST_SIZE,
@@ -3529,9 +3502,9 @@ static struct caam_alg_template driver_algs[] = {
 		.template_aead = {
 			.setkey = aead_setkey,
 			.setauthsize = aead_setauthsize,
-			.encrypt = aead_encrypt,
-			.decrypt = aead_decrypt,
-			.givencrypt = aead_givencrypt,
+			.encrypt = old_aead_encrypt,
+			.decrypt = old_aead_decrypt,
+			.givencrypt = old_aead_givencrypt,
 			.geniv = "<built-in>",
 			.ivsize = AES_BLOCK_SIZE,
 			.maxauthsize = SHA1_DIGEST_SIZE,
@@ -3548,9 +3521,9 @@ static struct caam_alg_template driver_algs[] = {
 		.template_aead = {
 			.setkey = aead_setkey,
 			.setauthsize = aead_setauthsize,
-			.encrypt = aead_encrypt,
-			.decrypt = aead_decrypt,
-			.givencrypt = aead_givencrypt,
+			.encrypt = old_aead_encrypt,
+			.decrypt = old_aead_decrypt,
+			.givencrypt = old_aead_givencrypt,
 			.geniv = "<built-in>",
 			.ivsize = AES_BLOCK_SIZE,
 			.maxauthsize = SHA224_DIGEST_SIZE,
@@ -3568,9 +3541,9 @@ static struct caam_alg_template driver_algs[] = {
 		.template_aead = {
 			.setkey = aead_setkey,
 			.setauthsize = aead_setauthsize,
-			.encrypt = aead_encrypt,
-			.decrypt = aead_decrypt,
-			.givencrypt = aead_givencrypt,
+			.encrypt = old_aead_encrypt,
+			.decrypt = old_aead_decrypt,
+			.givencrypt = old_aead_givencrypt,
 			.geniv = "<built-in>",
 			.ivsize = AES_BLOCK_SIZE,
 			.maxauthsize = SHA256_DIGEST_SIZE,
@@ -3588,9 +3561,9 @@ static struct caam_alg_template driver_algs[] = {
 		.template_aead = {
 			.setkey = aead_setkey,
 			.setauthsize = aead_setauthsize,
-			.encrypt = aead_encrypt,
-			.decrypt = aead_decrypt,
-			.givencrypt = aead_givencrypt,
+			.encrypt = old_aead_encrypt,
+			.decrypt = old_aead_decrypt,
+			.givencrypt = old_aead_givencrypt,
 			.geniv = "<built-in>",
 			.ivsize = AES_BLOCK_SIZE,
 			.maxauthsize = SHA384_DIGEST_SIZE,
@@ -3609,9 +3582,9 @@ static struct caam_alg_template driver_algs[] = {
 		.template_aead = {
 			.setkey = aead_setkey,
 			.setauthsize = aead_setauthsize,
-			.encrypt = aead_encrypt,
-			.decrypt = aead_decrypt,
-			.givencrypt = aead_givencrypt,
+			.encrypt = old_aead_encrypt,
+			.decrypt = old_aead_decrypt,
+			.givencrypt = old_aead_givencrypt,
 			.geniv = "<built-in>",
 			.ivsize = AES_BLOCK_SIZE,
 			.maxauthsize = SHA512_DIGEST_SIZE,
@@ -3629,9 +3602,9 @@ static struct caam_alg_template driver_algs[] = {
 		.template_aead = {
 			.setkey = aead_setkey,
 			.setauthsize = aead_setauthsize,
-			.encrypt = aead_encrypt,
-			.decrypt = aead_decrypt,
-			.givencrypt = aead_givencrypt,
+			.encrypt = old_aead_encrypt,
+			.decrypt = old_aead_decrypt,
+			.givencrypt = old_aead_givencrypt,
 			.geniv = "<built-in>",
 			.ivsize = DES3_EDE_BLOCK_SIZE,
 			.maxauthsize = MD5_DIGEST_SIZE,
@@ -3648,9 +3621,9 @@ static struct caam_alg_template driver_algs[] = {
 		.template_aead = {
 			.setkey = aead_setkey,
 			.setauthsize = aead_setauthsize,
-			.encrypt = aead_encrypt,
-			.decrypt = aead_decrypt,
-			.givencrypt = aead_givencrypt,
+			.encrypt = old_aead_encrypt,
+			.decrypt = old_aead_decrypt,
+			.givencrypt = old_aead_givencrypt,
 			.geniv = "<built-in>",
 			.ivsize = DES3_EDE_BLOCK_SIZE,
 			.maxauthsize = SHA1_DIGEST_SIZE,
@@ -3667,9 +3640,9 @@ static struct caam_alg_template driver_algs[] = {
 		.template_aead = {
 			.setkey = aead_setkey,
 			.setauthsize = aead_setauthsize,
-			.encrypt = aead_encrypt,
-			.decrypt = aead_decrypt,
-			.givencrypt = aead_givencrypt,
+			.encrypt = old_aead_encrypt,
+			.decrypt = old_aead_decrypt,
+			.givencrypt = old_aead_givencrypt,
 			.geniv = "<built-in>",
 			.ivsize = DES3_EDE_BLOCK_SIZE,
 			.maxauthsize = SHA224_DIGEST_SIZE,
@@ -3687,9 +3660,9 @@ static struct caam_alg_template driver_algs[] = {
 		.template_aead = {
 			.setkey = aead_setkey,
 			.setauthsize = aead_setauthsize,
-			.encrypt = aead_encrypt,
-			.decrypt = aead_decrypt,
-			.givencrypt = aead_givencrypt,
+			.encrypt = old_aead_encrypt,
+			.decrypt = old_aead_decrypt,
+			.givencrypt = old_aead_givencrypt,
 			.geniv = "<built-in>",
 			.ivsize = DES3_EDE_BLOCK_SIZE,
 			.maxauthsize = SHA256_DIGEST_SIZE,
@@ -3707,9 +3680,9 @@ static struct caam_alg_template driver_algs[] = {
 		.template_aead = {
 			.setkey = aead_setkey,
 			.setauthsize = aead_setauthsize,
-			.encrypt = aead_encrypt,
-			.decrypt = aead_decrypt,
-			.givencrypt = aead_givencrypt,
+			.encrypt = old_aead_encrypt,
+			.decrypt = old_aead_decrypt,
+			.givencrypt = old_aead_givencrypt,
 			.geniv = "<built-in>",
 			.ivsize = DES3_EDE_BLOCK_SIZE,
 			.maxauthsize = SHA384_DIGEST_SIZE,
@@ -3727,9 +3700,9 @@ static struct caam_alg_template driver_algs[] = {
 		.template_aead = {
 			.setkey = aead_setkey,
 			.setauthsize = aead_setauthsize,
-			.encrypt = aead_encrypt,
-			.decrypt = aead_decrypt,
-			.givencrypt = aead_givencrypt,
+			.encrypt = old_aead_encrypt,
+			.decrypt = old_aead_decrypt,
+			.givencrypt = old_aead_givencrypt,
 			.geniv = "<built-in>",
 			.ivsize = DES3_EDE_BLOCK_SIZE,
 			.maxauthsize = SHA512_DIGEST_SIZE,
@@ -3747,9 +3720,9 @@ static struct caam_alg_template driver_algs[] = {
 		.template_aead = {
 			.setkey = aead_setkey,
 			.setauthsize = aead_setauthsize,
-			.encrypt = aead_encrypt,
-			.decrypt = aead_decrypt,
-			.givencrypt = aead_givencrypt,
+			.encrypt = old_aead_encrypt,
+			.decrypt = old_aead_decrypt,
+			.givencrypt = old_aead_givencrypt,
 			.geniv = "<built-in>",
 			.ivsize = DES_BLOCK_SIZE,
 			.maxauthsize = MD5_DIGEST_SIZE,
@@ -3766,9 +3739,9 @@ static struct caam_alg_template driver_algs[] = {
 		.template_aead = {
 			.setkey = aead_setkey,
 			.setauthsize = aead_setauthsize,
-			.encrypt = aead_encrypt,
-			.decrypt = aead_decrypt,
-			.givencrypt = aead_givencrypt,
+			.encrypt = old_aead_encrypt,
+			.decrypt = old_aead_decrypt,
+			.givencrypt = old_aead_givencrypt,
 			.geniv = "<built-in>",
 			.ivsize = DES_BLOCK_SIZE,
 			.maxauthsize = SHA1_DIGEST_SIZE,
@@ -3785,9 +3758,9 @@ static struct caam_alg_template driver_algs[] = {
 		.template_aead = {
 			.setkey = aead_setkey,
 			.setauthsize = aead_setauthsize,
-			.encrypt = aead_encrypt,
-			.decrypt = aead_decrypt,
-			.givencrypt = aead_givencrypt,
+			.encrypt = old_aead_encrypt,
+			.decrypt = old_aead_decrypt,
+			.givencrypt = old_aead_givencrypt,
 			.geniv = "<built-in>",
 			.ivsize = DES_BLOCK_SIZE,
 			.maxauthsize = SHA224_DIGEST_SIZE,
@@ -3805,9 +3778,9 @@ static struct caam_alg_template driver_algs[] = {
 		.template_aead = {
 			.setkey = aead_setkey,
 			.setauthsize = aead_setauthsize,
-			.encrypt = aead_encrypt,
-			.decrypt = aead_decrypt,
-			.givencrypt = aead_givencrypt,
+			.encrypt = old_aead_encrypt,
+			.decrypt = old_aead_decrypt,
+			.givencrypt = old_aead_givencrypt,
 			.geniv = "<built-in>",
 			.ivsize = DES_BLOCK_SIZE,
 			.maxauthsize = SHA256_DIGEST_SIZE,
@@ -3825,9 +3798,9 @@ static struct caam_alg_template driver_algs[] = {
 		.template_aead = {
 			.setkey = aead_setkey,
 			.setauthsize = aead_setauthsize,
-			.encrypt = aead_encrypt,
-			.decrypt = aead_decrypt,
-			.givencrypt = aead_givencrypt,
+			.encrypt = old_aead_encrypt,
+			.decrypt = old_aead_decrypt,
+			.givencrypt = old_aead_givencrypt,
 			.geniv = "<built-in>",
 			.ivsize = DES_BLOCK_SIZE,
 			.maxauthsize = SHA384_DIGEST_SIZE,
@@ -3845,9 +3818,9 @@ static struct caam_alg_template driver_algs[] = {
 		.template_aead = {
 			.setkey = aead_setkey,
 			.setauthsize = aead_setauthsize,
-			.encrypt = aead_encrypt,
-			.decrypt = aead_decrypt,
-			.givencrypt = aead_givencrypt,
+			.encrypt = old_aead_encrypt,
+			.decrypt = old_aead_decrypt,
+			.givencrypt = old_aead_givencrypt,
 			.geniv = "<built-in>",
 			.ivsize = DES_BLOCK_SIZE,
 			.maxauthsize = SHA512_DIGEST_SIZE,
@@ -3865,9 +3838,9 @@ static struct caam_alg_template driver_algs[] = {
 		.template_aead = {
 			.setkey = aead_setkey,
 			.setauthsize = aead_setauthsize,
-			.encrypt = aead_encrypt,
-			.decrypt = aead_decrypt,
-			.givencrypt = aead_givencrypt,
+			.encrypt = old_aead_encrypt,
+			.decrypt = old_aead_decrypt,
+			.givencrypt = old_aead_givencrypt,
 			.geniv = "<built-in>",
 			.ivsize = CTR_RFC3686_IV_SIZE,
 			.maxauthsize = MD5_DIGEST_SIZE,
@@ -3884,9 +3857,9 @@ static struct caam_alg_template driver_algs[] = {
 		.template_aead = {
 			.setkey = aead_setkey,
 			.setauthsize = aead_setauthsize,
-			.encrypt = aead_encrypt,
-			.decrypt = aead_decrypt,
-			.givencrypt = aead_givencrypt,
+			.encrypt = old_aead_encrypt,
+			.decrypt = old_aead_decrypt,
+			.givencrypt = old_aead_givencrypt,
 			.geniv = "<built-in>",
 			.ivsize = CTR_RFC3686_IV_SIZE,
 			.maxauthsize = SHA1_DIGEST_SIZE,
@@ -3903,9 +3876,9 @@ static struct caam_alg_template driver_algs[] = {
 		.template_aead = {
 			.setkey = aead_setkey,
 			.setauthsize = aead_setauthsize,
-			.encrypt = aead_encrypt,
-			.decrypt = aead_decrypt,
-			.givencrypt = aead_givencrypt,
+			.encrypt = old_aead_encrypt,
+			.decrypt = old_aead_decrypt,
+			.givencrypt = old_aead_givencrypt,
 			.geniv = "<built-in>",
 			.ivsize = CTR_RFC3686_IV_SIZE,
 			.maxauthsize = SHA224_DIGEST_SIZE,
@@ -3923,9 +3896,9 @@ static struct caam_alg_template driver_algs[] = {
 		.template_aead = {
 			.setkey = aead_setkey,
 			.setauthsize = aead_setauthsize,
-			.encrypt = aead_encrypt,
-			.decrypt = aead_decrypt,
-			.givencrypt = aead_givencrypt,
+			.encrypt = old_aead_encrypt,
+			.decrypt = old_aead_decrypt,
+			.givencrypt = old_aead_givencrypt,
 			.geniv = "<built-in>",
 			.ivsize = CTR_RFC3686_IV_SIZE,
 			.maxauthsize = SHA256_DIGEST_SIZE,
@@ -3943,9 +3916,9 @@ static struct caam_alg_template driver_algs[] = {
 		.template_aead = {
 			.setkey = aead_setkey,
 			.setauthsize = aead_setauthsize,
-			.encrypt = aead_encrypt,
-			.decrypt = aead_decrypt,
-			.givencrypt = aead_givencrypt,
+			.encrypt = old_aead_encrypt,
+			.decrypt = old_aead_decrypt,
+			.givencrypt = old_aead_givencrypt,
 			.geniv = "<built-in>",
 			.ivsize = CTR_RFC3686_IV_SIZE,
 			.maxauthsize = SHA384_DIGEST_SIZE,
@@ -3963,9 +3936,9 @@ static struct caam_alg_template driver_algs[] = {
 		.template_aead = {
 			.setkey = aead_setkey,
 			.setauthsize = aead_setauthsize,
-			.encrypt = aead_encrypt,
-			.decrypt = aead_decrypt,
-			.givencrypt = aead_givencrypt,
+			.encrypt = old_aead_encrypt,
+			.decrypt = old_aead_decrypt,
+			.givencrypt = old_aead_givencrypt,
 			.geniv = "<built-in>",
 			.ivsize = CTR_RFC3686_IV_SIZE,
 			.maxauthsize = SHA512_DIGEST_SIZE,
@@ -3975,58 +3948,6 @@ static struct caam_alg_template driver_algs[] = {
 				   OP_ALG_AAI_HMAC_PRECOMP,
 		.alg_op = OP_ALG_ALGSEL_SHA512 | OP_ALG_AAI_HMAC,
 	},
-	{
-		.name = "rfc4106(gcm(aes))",
-		.driver_name = "rfc4106-gcm-aes-caam",
-		.blocksize = 1,
-		.type = CRYPTO_ALG_TYPE_AEAD,
-		.template_aead = {
-			.setkey = rfc4106_setkey,
-			.setauthsize = rfc4106_setauthsize,
-			.encrypt = aead_encrypt,
-			.decrypt = aead_decrypt,
-			.givencrypt = aead_givencrypt,
-			.geniv = "<built-in>",
-			.ivsize = 8,
-			.maxauthsize = AES_BLOCK_SIZE,
-			},
-		.class1_alg_type = OP_ALG_ALGSEL_AES | OP_ALG_AAI_GCM,
-	},
-	{
-		.name = "rfc4543(gcm(aes))",
-		.driver_name = "rfc4543-gcm-aes-caam",
-		.blocksize = 1,
-		.type = CRYPTO_ALG_TYPE_AEAD,
-		.template_aead = {
-			.setkey = rfc4543_setkey,
-			.setauthsize = rfc4543_setauthsize,
-			.encrypt = aead_encrypt,
-			.decrypt = aead_decrypt,
-			.givencrypt = aead_givencrypt,
-			.geniv = "<built-in>",
-			.ivsize = 8,
-			.maxauthsize = AES_BLOCK_SIZE,
-			},
-		.class1_alg_type = OP_ALG_ALGSEL_AES | OP_ALG_AAI_GCM,
-	},
-	/* Galois Counter Mode */
-	{
-		.name = "gcm(aes)",
-		.driver_name = "gcm-aes-caam",
-		.blocksize = 1,
-		.type = CRYPTO_ALG_TYPE_AEAD,
-		.template_aead = {
-			.setkey = gcm_setkey,
-			.setauthsize = gcm_setauthsize,
-			.encrypt = aead_encrypt,
-			.decrypt = aead_decrypt,
-			.givencrypt = NULL,
-			.geniv = "<built-in>",
-			.ivsize = 12,
-			.maxauthsize = AES_BLOCK_SIZE,
-			},
-		.class1_alg_type = OP_ALG_ALGSEL_AES | OP_ALG_AAI_GCM,
-	},
 	/* ablkcipher descriptor */
 	{
 		.name = "cbc(aes)",
@@ -4116,21 +4037,84 @@ static struct caam_alg_template driver_algs[] = {
 	}
 };
 
-struct caam_crypto_alg {
-	struct list_head entry;
+struct caam_alg_entry {
 	int class1_alg_type;
 	int class2_alg_type;
 	int alg_op;
+};
+
+struct caam_aead_alg {
+	struct aead_alg aead;
+	struct caam_alg_entry caam;
+	bool registered;
+};
+
+static struct caam_aead_alg driver_aeads[] = {
+	{
+		.aead = {
+			.base = {
+				.cra_name = "rfc4106(gcm(aes))",
+				.cra_driver_name = "rfc4106-gcm-aes-caam",
+				.cra_blocksize = 1,
+			},
+			.setkey = rfc4106_setkey,
+			.setauthsize = rfc4106_setauthsize,
+			.encrypt = gcm_encrypt,
+			.decrypt = gcm_decrypt,
+			.ivsize = 8,
+			.maxauthsize = AES_BLOCK_SIZE,
+		},
+		.caam = {
+			.class1_alg_type = OP_ALG_ALGSEL_AES | OP_ALG_AAI_GCM,
+		},
+	},
+	{
+		.aead = {
+			.base = {
+				.cra_name = "rfc4543(gcm(aes))",
+				.cra_driver_name = "rfc4543-gcm-aes-caam",
+				.cra_blocksize = 1,
+			},
+			.setkey = rfc4543_setkey,
+			.setauthsize = rfc4543_setauthsize,
+			.encrypt = gcm_encrypt,
+			.decrypt = gcm_decrypt,
+			.ivsize = 8,
+			.maxauthsize = AES_BLOCK_SIZE,
+		},
+		.caam = {
+			.class1_alg_type = OP_ALG_ALGSEL_AES | OP_ALG_AAI_GCM,
+		},
+	},
+	/* Galois Counter Mode */
+	{
+		.aead = {
+			.base = {
+				.cra_name = "gcm(aes)",
+				.cra_driver_name = "gcm-aes-caam",
+				.cra_blocksize = 1,
+			},
+			.setkey = gcm_setkey,
+			.setauthsize = gcm_setauthsize,
+			.encrypt = gcm_encrypt,
+			.decrypt = gcm_decrypt,
+			.ivsize = 12,
+			.maxauthsize = AES_BLOCK_SIZE,
+		},
+		.caam = {
+			.class1_alg_type = OP_ALG_ALGSEL_AES | OP_ALG_AAI_GCM,
+		},
+	},
+};
+
+struct caam_crypto_alg {
 	struct crypto_alg crypto_alg;
+	struct list_head entry;
+	struct caam_alg_entry caam;
 };
 
-static int caam_cra_init(struct crypto_tfm *tfm)
+static int caam_init_common(struct caam_ctx *ctx, struct caam_alg_entry *caam)
 {
-	struct crypto_alg *alg = tfm->__crt_alg;
-	struct caam_crypto_alg *caam_alg =
-		 container_of(alg, struct caam_crypto_alg, crypto_alg);
-	struct caam_ctx *ctx = crypto_tfm_ctx(tfm);
-
 	ctx->jrdev = caam_jr_alloc();
 	if (IS_ERR(ctx->jrdev)) {
 		pr_err("Job Ring Device allocation for transform failed\n");
@@ -4138,17 +4122,35 @@ static int caam_cra_init(struct crypto_tfm *tfm)
 	}
 
 	/* copy descriptor header template value */
-	ctx->class1_alg_type = OP_TYPE_CLASS1_ALG | caam_alg->class1_alg_type;
-	ctx->class2_alg_type = OP_TYPE_CLASS2_ALG | caam_alg->class2_alg_type;
-	ctx->alg_op = OP_TYPE_CLASS2_ALG | caam_alg->alg_op;
+	ctx->class1_alg_type = OP_TYPE_CLASS1_ALG | caam->class1_alg_type;
+	ctx->class2_alg_type = OP_TYPE_CLASS2_ALG | caam->class2_alg_type;
+	ctx->alg_op = OP_TYPE_CLASS2_ALG | caam->alg_op;
 
 	return 0;
 }
 
-static void caam_cra_exit(struct crypto_tfm *tfm)
+static int caam_cra_init(struct crypto_tfm *tfm)
 {
+	struct crypto_alg *alg = tfm->__crt_alg;
+	struct caam_crypto_alg *caam_alg =
+		 container_of(alg, struct caam_crypto_alg, crypto_alg);
 	struct caam_ctx *ctx = crypto_tfm_ctx(tfm);
 
+	return caam_init_common(ctx, &caam_alg->caam);
+}
+
+static int caam_aead_init(struct crypto_aead *tfm)
+{
+	struct aead_alg *alg = crypto_aead_alg(tfm);
+	struct caam_aead_alg *caam_alg =
+		 container_of(alg, struct caam_aead_alg, aead);
+	struct caam_ctx *ctx = crypto_aead_ctx(tfm);
+
+	return caam_init_common(ctx, &caam_alg->caam);
+}
+
+static void caam_exit_common(struct caam_ctx *ctx)
+{
 	if (ctx->sh_desc_enc_dma &&
 	    !dma_mapping_error(ctx->jrdev, ctx->sh_desc_enc_dma))
 		dma_unmap_single(ctx->jrdev, ctx->sh_desc_enc_dma,
@@ -4171,10 +4173,28 @@ static void caam_cra_exit(struct crypto_tfm *tfm)
 	caam_jr_free(ctx->jrdev);
 }
 
+static void caam_cra_exit(struct crypto_tfm *tfm)
+{
+	caam_exit_common(crypto_tfm_ctx(tfm));
+}
+
+static void caam_aead_exit(struct crypto_aead *tfm)
+{
+	caam_exit_common(crypto_aead_ctx(tfm));
+}
+
 static void __exit caam_algapi_exit(void)
 {
 
 	struct caam_crypto_alg *t_alg, *n;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(driver_aeads); i++) {
+		struct caam_aead_alg *t_alg = driver_aeads + i;
+
+		if (t_alg->registered)
+			crypto_unregister_aead(&t_alg->aead);
+	}
 
 	if (!alg_list.next)
 		return;
@@ -4227,13 +4247,26 @@ static struct caam_crypto_alg *caam_alg_alloc(struct caam_alg_template
 		break;
 	}
 
-	t_alg->class1_alg_type = template->class1_alg_type;
-	t_alg->class2_alg_type = template->class2_alg_type;
-	t_alg->alg_op = template->alg_op;
+	t_alg->caam.class1_alg_type = template->class1_alg_type;
+	t_alg->caam.class2_alg_type = template->class2_alg_type;
+	t_alg->caam.alg_op = template->alg_op;
 
 	return t_alg;
 }
 
+static void caam_aead_alg_init(struct caam_aead_alg *t_alg)
+{
+	struct aead_alg *alg = &t_alg->aead;
+
+	alg->base.cra_module = THIS_MODULE;
+	alg->base.cra_priority = CAAM_CRA_PRIORITY;
+	alg->base.cra_ctxsize = sizeof(struct caam_ctx);
+	alg->base.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_KERN_DRIVER_ONLY;
+
+	alg->init = caam_aead_init;
+	alg->exit = caam_aead_exit;
+}
+
 static int __init caam_algapi_init(void)
 {
 	struct device_node *dev_node;
@@ -4241,6 +4274,7 @@ static int __init caam_algapi_init(void)
 	struct device *ctrldev;
 	void *priv;
 	int i = 0, err = 0;
+	bool registered = false;
 
 	dev_node = of_find_compatible_node(NULL, NULL, "fsl,sec-v4.0");
 	if (!dev_node) {
@@ -4287,10 +4321,30 @@ static int __init caam_algapi_init(void)
 			pr_warn("%s alg registration failed\n",
 				t_alg->crypto_alg.cra_driver_name);
 			kfree(t_alg);
-		} else
-			list_add_tail(&t_alg->entry, &alg_list);
+			continue;
+		}
+
+		list_add_tail(&t_alg->entry, &alg_list);
+		registered = true;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(driver_aeads); i++) {
+		struct caam_aead_alg *t_alg = driver_aeads + i;
+
+		caam_aead_alg_init(t_alg);
+
+		err = crypto_register_aead(&t_alg->aead);
+		if (err) {
+			pr_warn("%s alg registration failed\n",
+				t_alg->aead.base.cra_driver_name);
+			continue;
+		}
+
+		t_alg->registered = true;
+		registered = true;
 	}
-	if (!list_empty(&alg_list))
+
+	if (registered)
 		pr_info("caam algorithms registered in /proc/crypto\n");
 
 	return err;
