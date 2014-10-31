From: Catalin Vasile <catalin.vasile@freescale.com>
Subject: [PATCH 3/4] crypto: caam - add support for rfc3686 with authenc md5, sha1 and sha2
Date: Fri, 31 Oct 2014 12:45:37 +0200
Message-ID: <1414752338-5711-3-git-send-email-catalin.vasile@freescale.com>
References: <1414752338-5711-1-git-send-email-catalin.vasile@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <herbert@gondor.apana.org.au>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bl2on0124.outbound.protection.outlook.com ([65.55.169.124]:45344
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932333AbaJaKqf (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 31 Oct 2014 06:46:35 -0400
In-Reply-To: <1414752338-5711-1-git-send-email-catalin.vasile@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add support for AES Counter Mode (CTR) compliant with RFC3686 to be
used along with authenc algorithms (md5, sha1, sha224, sha256, sha384,
sha512) as one-shot aead algorithms.

Signed-off-by: Catalin Vasile <catalin.vasile@freescale.com>
---
 drivers/crypto/caam/caamalg.c | 262 +++++++++++++++++++++++++++++++++++++-----
 1 file changed, 236 insertions(+), 26 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index 2909efc..cdcc6cb 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -60,6 +60,7 @@
 #define CAAM_CRA_PRIORITY		3000
 /* max key is sum of AES_MAX_KEY_SIZE, max split key size */
 #define CAAM_MAX_KEY_SIZE		(AES_MAX_KEY_SIZE + \
+					 CTR_RFC3686_NONCE_SIZE + \
 					 SHA512_DIGEST_SIZE * 2)
 /* max IV is max of AES_BLOCK_SIZE, DES3_EDE_BLOCK_SIZE */
 #define CAAM_MAX_IV_LENGTH		16
@@ -70,6 +71,9 @@
 #define DESC_AEAD_DEC_LEN		(DESC_AEAD_BASE + 18 * CAAM_CMD_SZ)
 #define DESC_AEAD_GIVENC_LEN		(DESC_AEAD_ENC_LEN + 7 * CAAM_CMD_SZ)
 
+/* Note: Nonce is counted in enckeylen */
+#define DESC_AEAD_CTR_RFC3686_LEN	(6 * CAAM_CMD_SZ)
+
 #define DESC_AEAD_NULL_BASE		(3 * CAAM_CMD_SZ)
 #define DESC_AEAD_NULL_ENC_LEN		(DESC_AEAD_NULL_BASE + 14 * CAAM_CMD_SZ)
 #define DESC_AEAD_NULL_DEC_LEN		(DESC_AEAD_NULL_BASE + 17 * CAAM_CMD_SZ)
@@ -137,11 +141,13 @@ static inline void aead_append_src_dst(u32 *desc, u32 msg_type)
 /*
  * For aead encrypt and decrypt, read iv for both classes
  */
-static inline void aead_append_ld_iv(u32 *desc, int ivsize)
+static inline void aead_append_ld_iv(u32 *desc, int ivsize, int ivoffset)
 {
-	append_cmd(desc, CMD_SEQ_LOAD | LDST_SRCDST_BYTE_CONTEXT |
-		   LDST_CLASS_1_CCB | ivsize);
-	append_move(desc, MOVE_SRC_CLASS1CTX | MOVE_DEST_CLASS2INFIFO | ivsize);
+	append_seq_load(desc, ivsize, LDST_CLASS_1_CCB |
+			LDST_SRCDST_BYTE_CONTEXT |
+			(ivoffset << LDST_OFFSET_SHIFT));
+	append_move(desc, MOVE_SRC_CLASS1CTX | MOVE_DEST_CLASS2INFIFO |
+		    (ivoffset << MOVE_OFFSET_SHIFT) | ivsize);
 }
 
 /*
@@ -187,35 +193,60 @@ struct caam_ctx {
 };
 
 static void append_key_aead(u32 *desc, struct caam_ctx *ctx,
-			    int keys_fit_inline)
+			    int keys_fit_inline, bool is_rfc3686)
 {
+	u32 *nonce;
+	unsigned int enckeylen = ctx->enckeylen;
+
+	/*
+	 * RFC3686 specific:
+	 *	| ctx->key = {AUTH_KEY, ENC_KEY, NONCE}
+	 *	| enckeylen = encryption key size + nonce size
+	 */
+	if (is_rfc3686)
+		enckeylen -= CTR_RFC3686_NONCE_SIZE;
+
 	if (keys_fit_inline) {
 		append_key_as_imm(desc, ctx->key, ctx->split_key_pad_len,
 				  ctx->split_key_len, CLASS_2 |
 				  KEY_DEST_MDHA_SPLIT | KEY_ENC);
 		append_key_as_imm(desc, (void *)ctx->key +
-				  ctx->split_key_pad_len, ctx->enckeylen,
-				  ctx->enckeylen, CLASS_1 | KEY_DEST_CLASS_REG);
+				  ctx->split_key_pad_len, enckeylen,
+				  enckeylen, CLASS_1 | KEY_DEST_CLASS_REG);
 	} else {
 		append_key(desc, ctx->key_dma, ctx->split_key_len, CLASS_2 |
 			   KEY_DEST_MDHA_SPLIT | KEY_ENC);
 		append_key(desc, ctx->key_dma + ctx->split_key_pad_len,
-			   ctx->enckeylen, CLASS_1 | KEY_DEST_CLASS_REG);
+			   enckeylen, CLASS_1 | KEY_DEST_CLASS_REG);
+	}
+
+	/* Load Counter into CONTEXT1 reg */
+	if (is_rfc3686) {
+		nonce = (u32 *)((void *)ctx->key + ctx->split_key_pad_len +
+			       enckeylen);
+		append_load_imm_u32(desc, *nonce, LDST_CLASS_IND_CCB |
+				    LDST_SRCDST_BYTE_OUTFIFO | LDST_IMM);
+		append_move(desc,
+			    MOVE_SRC_OUTFIFO |
+			    MOVE_DEST_CLASS1CTX |
+			    (16 << MOVE_OFFSET_SHIFT) |
+			    (CTR_RFC3686_NONCE_SIZE << MOVE_LEN_SHIFT));
 	}
 }
 
 static void init_sh_desc_key_aead(u32 *desc, struct caam_ctx *ctx,
-				  int keys_fit_inline)
+				  int keys_fit_inline, bool is_rfc3686)
 {
 	u32 *key_jump_cmd;
 
-	init_sh_desc(desc, HDR_SHARE_SERIAL);
+	/* Note: Context registers are saved. */
+	init_sh_desc(desc, HDR_SHARE_SERIAL | HDR_SAVECTX);
 
 	/* Skip if already shared */
 	key_jump_cmd = append_jump(desc, JUMP_JSL | JUMP_TEST_ALL |
 				   JUMP_COND_SHRD);
 
-	append_key_aead(desc, ctx, keys_fit_inline);
+	append_key_aead(desc, ctx, keys_fit_inline, is_rfc3686);
 
 	set_jump_tgt_here(desc, key_jump_cmd);
 }
@@ -415,10 +446,17 @@ static int aead_set_sh_desc(struct crypto_aead *aead)
 {
 	struct aead_tfm *tfm = &aead->base.crt_aead;
 	struct caam_ctx *ctx = crypto_aead_ctx(aead);
+	struct crypto_tfm *ctfm = crypto_aead_tfm(aead);
+	const char *alg_name = crypto_tfm_alg_name(ctfm);
 	struct device *jrdev = ctx->jrdev;
-	bool keys_fit_inline = false;
+	bool keys_fit_inline;
 	u32 geniv, moveiv;
+	u32 ctx1_iv_off = 0;
 	u32 *desc;
+	const bool ctr_mode = ((ctx->class1_alg_type & OP_ALG_AAI_MASK) ==
+			       OP_ALG_AAI_CTR_MOD128);
+	const bool is_rfc3686 = (ctr_mode &&
+				 (strstr(alg_name, "rfc3686") != NULL));
 
 	if (!ctx->authsize)
 		return 0;
@@ -428,18 +466,36 @@ static int aead_set_sh_desc(struct crypto_aead *aead)
 		return aead_null_set_sh_desc(aead);
 
 	/*
+	 * AES-CTR needs to load IV in CONTEXT1 reg
+	 * at an offset of 128bits (16bytes)
+	 * CONTEXT1[255:128] = IV
+	 */
+	if (ctr_mode)
+		ctx1_iv_off = 16;
+
+	/*
+	 * RFC3686 specific:
+	 *	CONTEXT1[255:128] = {NONCE, IV, COUNTER}
+	 */
+	if (is_rfc3686)
+		ctx1_iv_off = 16 + CTR_RFC3686_NONCE_SIZE;
+
+	/*
 	 * Job Descriptor and Shared Descriptors
 	 * must all fit into the 64-word Descriptor h/w Buffer
 	 */
+	keys_fit_inline = false;
 	if (DESC_AEAD_ENC_LEN + DESC_JOB_IO_LEN +
-	    ctx->split_key_pad_len + ctx->enckeylen <=
+	    ctx->split_key_pad_len + ctx->enckeylen +
+	    (is_rfc3686 ? DESC_AEAD_CTR_RFC3686_LEN : 0) <=
 	    CAAM_DESC_BYTES_MAX)
 		keys_fit_inline = true;
 
 	/* aead_encrypt shared descriptor */
 	desc = ctx->sh_desc_enc;
 
-	init_sh_desc_key_aead(desc, ctx, keys_fit_inline);
+	/* Note: Context registers are saved. */
+	init_sh_desc_key_aead(desc, ctx, keys_fit_inline, is_rfc3686);
 
 	/* Class 2 operation */
 	append_operation(desc, ctx->class2_alg_type |
@@ -457,7 +513,15 @@ static int aead_set_sh_desc(struct crypto_aead *aead)
 	/* read assoc before reading payload */
 	append_seq_fifo_load(desc, 0, FIFOLD_CLASS_CLASS2 | FIFOLD_TYPE_MSG |
 			     KEY_VLF);
-	aead_append_ld_iv(desc, tfm->ivsize);
+	aead_append_ld_iv(desc, tfm->ivsize, ctx1_iv_off);
+
+	/* Load Counter into CONTEXT1 reg */
+	if (is_rfc3686)
+		append_load_imm_u32(desc, be32_to_cpu(1), LDST_IMM |
+				    LDST_CLASS_1_CCB |
+				    LDST_SRCDST_BYTE_CONTEXT |
+				    ((ctx1_iv_off + CTR_RFC3686_IV_SIZE) <<
+				     LDST_OFFSET_SHIFT));
 
 	/* Class 1 operation */
 	append_operation(desc, ctx->class1_alg_type |
@@ -491,14 +555,16 @@ static int aead_set_sh_desc(struct crypto_aead *aead)
 	 */
 	keys_fit_inline = false;
 	if (DESC_AEAD_DEC_LEN + DESC_JOB_IO_LEN +
-	    ctx->split_key_pad_len + ctx->enckeylen <=
+	    ctx->split_key_pad_len + ctx->enckeylen +
+	    (is_rfc3686 ? DESC_AEAD_CTR_RFC3686_LEN : 0) <=
 	    CAAM_DESC_BYTES_MAX)
 		keys_fit_inline = true;
 
 	/* aead_decrypt shared descriptor */
 	desc = ctx->sh_desc_dec;
 
-	init_sh_desc_key_aead(desc, ctx, keys_fit_inline);
+	/* Note: Context registers are saved. */
+	init_sh_desc_key_aead(desc, ctx, keys_fit_inline, is_rfc3686);
 
 	/* Class 2 operation */
 	append_operation(desc, ctx->class2_alg_type |
@@ -515,9 +581,22 @@ static int aead_set_sh_desc(struct crypto_aead *aead)
 	append_seq_fifo_load(desc, 0, FIFOLD_CLASS_CLASS2 | FIFOLD_TYPE_MSG |
 			     KEY_VLF);
 
-	aead_append_ld_iv(desc, tfm->ivsize);
+	aead_append_ld_iv(desc, tfm->ivsize, ctx1_iv_off);
+
+	/* Load Counter into CONTEXT1 reg */
+	if (is_rfc3686)
+		append_load_imm_u32(desc, be32_to_cpu(1), LDST_IMM |
+				    LDST_CLASS_1_CCB |
+				    LDST_SRCDST_BYTE_CONTEXT |
+				    ((ctx1_iv_off + CTR_RFC3686_IV_SIZE) <<
+				     LDST_OFFSET_SHIFT));
 
-	append_dec_op1(desc, ctx->class1_alg_type);
+	/* Choose operation */
+	if (ctr_mode)
+		append_operation(desc, ctx->class1_alg_type |
+				 OP_ALG_AS_INITFINAL | OP_ALG_DECRYPT);
+	else
+		append_dec_op1(desc, ctx->class1_alg_type);
 
 	/* Read and write cryptlen bytes */
 	append_math_add(desc, VARSEQINLEN, ZERO, REG2, CAAM_CMD_SZ);
@@ -547,14 +626,16 @@ static int aead_set_sh_desc(struct crypto_aead *aead)
 	 */
 	keys_fit_inline = false;
 	if (DESC_AEAD_GIVENC_LEN + DESC_JOB_IO_LEN +
-	    ctx->split_key_pad_len + ctx->enckeylen <=
+	    ctx->split_key_pad_len + ctx->enckeylen +
+	    (is_rfc3686 ? DESC_AEAD_CTR_RFC3686_LEN : 0) <=
 	    CAAM_DESC_BYTES_MAX)
 		keys_fit_inline = true;
 
 	/* aead_givencrypt shared descriptor */
 	desc = ctx->sh_desc_givenc;
 
-	init_sh_desc_key_aead(desc, ctx, keys_fit_inline);
+	/* Note: Context registers are saved. */
+	init_sh_desc_key_aead(desc, ctx, keys_fit_inline, is_rfc3686);
 
 	/* Generate IV */
 	geniv = NFIFOENTRY_STYPE_PAD | NFIFOENTRY_DEST_DECO |
@@ -563,13 +644,16 @@ static int aead_set_sh_desc(struct crypto_aead *aead)
 	append_load_imm_u32(desc, geniv, LDST_CLASS_IND_CCB |
 			    LDST_SRCDST_WORD_INFO_FIFO | LDST_IMM);
 	append_cmd(desc, CMD_LOAD | DISABLE_AUTO_INFO_FIFO);
-	append_move(desc, MOVE_SRC_INFIFO |
-		    MOVE_DEST_CLASS1CTX | (tfm->ivsize << MOVE_LEN_SHIFT));
+	append_move(desc, MOVE_WAITCOMP |
+		    MOVE_SRC_INFIFO | MOVE_DEST_CLASS1CTX |
+		    (ctx1_iv_off << MOVE_OFFSET_SHIFT) |
+		    (tfm->ivsize << MOVE_LEN_SHIFT));
 	append_cmd(desc, CMD_LOAD | ENABLE_AUTO_INFO_FIFO);
 
 	/* Copy IV to class 1 context */
-	append_move(desc, MOVE_SRC_CLASS1CTX |
-		    MOVE_DEST_OUTFIFO | (tfm->ivsize << MOVE_LEN_SHIFT));
+	append_move(desc, MOVE_SRC_CLASS1CTX | MOVE_DEST_OUTFIFO |
+		    (ctx1_iv_off << MOVE_OFFSET_SHIFT) |
+		    (tfm->ivsize << MOVE_LEN_SHIFT));
 
 	/* Return to encryption */
 	append_operation(desc, ctx->class2_alg_type |
@@ -585,7 +669,7 @@ static int aead_set_sh_desc(struct crypto_aead *aead)
 	append_seq_fifo_load(desc, 0, FIFOLD_CLASS_CLASS2 | FIFOLD_TYPE_MSG |
 			     KEY_VLF);
 
-	/* Copy iv from class 1 ctx to class 2 fifo*/
+	/* Copy iv from outfifo to class 2 fifo */
 	moveiv = NFIFOENTRY_STYPE_OFIFO | NFIFOENTRY_DEST_CLASS2 |
 		 NFIFOENTRY_DTYPE_MSG | (tfm->ivsize << NFIFOENTRY_DLEN_SHIFT);
 	append_load_imm_u32(desc, moveiv, LDST_CLASS_IND_CCB |
@@ -593,6 +677,14 @@ static int aead_set_sh_desc(struct crypto_aead *aead)
 	append_load_imm_u32(desc, tfm->ivsize, LDST_CLASS_2_CCB |
 			    LDST_SRCDST_WORD_DATASZ_REG | LDST_IMM);
 
+	/* Load Counter into CONTEXT1 reg */
+	if (is_rfc3686)
+		append_load_imm_u32(desc, be32_to_cpu(1), LDST_IMM |
+				    LDST_CLASS_1_CCB |
+				    LDST_SRCDST_BYTE_CONTEXT |
+				    ((ctx1_iv_off + CTR_RFC3686_IV_SIZE) <<
+				     LDST_OFFSET_SHIFT));
+
 	/* Class 1 operation */
 	append_operation(desc, ctx->class1_alg_type |
 			 OP_ALG_AS_INITFINAL | OP_ALG_ENCRYPT);
@@ -3063,6 +3155,124 @@ static struct caam_alg_template driver_algs[] = {
 		.alg_op = OP_ALG_ALGSEL_SHA512 | OP_ALG_AAI_HMAC,
 	},
 	{
+		.name = "authenc(hmac(md5),rfc3686(ctr(aes)))",
+		.driver_name = "authenc-hmac-md5-rfc3686-ctr-aes-caam",
+		.blocksize = 1,
+		.type = CRYPTO_ALG_TYPE_AEAD,
+		.template_aead = {
+			.setkey = aead_setkey,
+			.setauthsize = aead_setauthsize,
+			.encrypt = aead_encrypt,
+			.decrypt = aead_decrypt,
+			.givencrypt = aead_givencrypt,
+			.geniv = "<built-in>",
+			.ivsize = CTR_RFC3686_IV_SIZE,
+			.maxauthsize = MD5_DIGEST_SIZE,
+			},
+		.class1_alg_type = OP_ALG_ALGSEL_AES | OP_ALG_AAI_CTR_MOD128,
+		.class2_alg_type = OP_ALG_ALGSEL_MD5 | OP_ALG_AAI_HMAC_PRECOMP,
+		.alg_op = OP_ALG_ALGSEL_MD5 | OP_ALG_AAI_HMAC,
+	},
+	{
+		.name = "authenc(hmac(sha1),rfc3686(ctr(aes)))",
+		.driver_name = "authenc-hmac-sha1-rfc3686-ctr-aes-caam",
+		.blocksize = 1,
+		.type = CRYPTO_ALG_TYPE_AEAD,
+		.template_aead = {
+			.setkey = aead_setkey,
+			.setauthsize = aead_setauthsize,
+			.encrypt = aead_encrypt,
+			.decrypt = aead_decrypt,
+			.givencrypt = aead_givencrypt,
+			.geniv = "<built-in>",
+			.ivsize = CTR_RFC3686_IV_SIZE,
+			.maxauthsize = SHA1_DIGEST_SIZE,
+			},
+		.class1_alg_type = OP_ALG_ALGSEL_AES | OP_ALG_AAI_CTR_MOD128,
+		.class2_alg_type = OP_ALG_ALGSEL_SHA1 | OP_ALG_AAI_HMAC_PRECOMP,
+		.alg_op = OP_ALG_ALGSEL_SHA1 | OP_ALG_AAI_HMAC,
+	},
+	{
+		.name = "authenc(hmac(sha224),rfc3686(ctr(aes)))",
+		.driver_name = "authenc-hmac-sha224-rfc3686-ctr-aes-caam",
+		.blocksize = 1,
+		.type = CRYPTO_ALG_TYPE_AEAD,
+		.template_aead = {
+			.setkey = aead_setkey,
+			.setauthsize = aead_setauthsize,
+			.encrypt = aead_encrypt,
+			.decrypt = aead_decrypt,
+			.givencrypt = aead_givencrypt,
+			.geniv = "<built-in>",
+			.ivsize = CTR_RFC3686_IV_SIZE,
+			.maxauthsize = SHA224_DIGEST_SIZE,
+			},
+		.class1_alg_type = OP_ALG_ALGSEL_AES | OP_ALG_AAI_CTR_MOD128,
+		.class2_alg_type = OP_ALG_ALGSEL_SHA224 |
+				   OP_ALG_AAI_HMAC_PRECOMP,
+		.alg_op = OP_ALG_ALGSEL_SHA224 | OP_ALG_AAI_HMAC,
+	},
+	{
+		.name = "authenc(hmac(sha256),rfc3686(ctr(aes)))",
+		.driver_name = "authenc-hmac-sha256-rfc3686-ctr-aes-caam",
+		.blocksize = 1,
+		.type = CRYPTO_ALG_TYPE_AEAD,
+		.template_aead = {
+			.setkey = aead_setkey,
+			.setauthsize = aead_setauthsize,
+			.encrypt = aead_encrypt,
+			.decrypt = aead_decrypt,
+			.givencrypt = aead_givencrypt,
+			.geniv = "<built-in>",
+			.ivsize = CTR_RFC3686_IV_SIZE,
+			.maxauthsize = SHA256_DIGEST_SIZE,
+			},
+		.class1_alg_type = OP_ALG_ALGSEL_AES | OP_ALG_AAI_CTR_MOD128,
+		.class2_alg_type = OP_ALG_ALGSEL_SHA256 |
+				   OP_ALG_AAI_HMAC_PRECOMP,
+		.alg_op = OP_ALG_ALGSEL_SHA256 | OP_ALG_AAI_HMAC,
+	},
+	{
+		.name = "authenc(hmac(sha384),rfc3686(ctr(aes)))",
+		.driver_name = "authenc-hmac-sha384-rfc3686-ctr-aes-caam",
+		.blocksize = 1,
+		.type = CRYPTO_ALG_TYPE_AEAD,
+		.template_aead = {
+			.setkey = aead_setkey,
+			.setauthsize = aead_setauthsize,
+			.encrypt = aead_encrypt,
+			.decrypt = aead_decrypt,
+			.givencrypt = aead_givencrypt,
+			.geniv = "<built-in>",
+			.ivsize = CTR_RFC3686_IV_SIZE,
+			.maxauthsize = SHA384_DIGEST_SIZE,
+			},
+		.class1_alg_type = OP_ALG_ALGSEL_AES | OP_ALG_AAI_CTR_MOD128,
+		.class2_alg_type = OP_ALG_ALGSEL_SHA384 |
+				   OP_ALG_AAI_HMAC_PRECOMP,
+		.alg_op = OP_ALG_ALGSEL_SHA384 | OP_ALG_AAI_HMAC,
+	},
+	{
+		.name = "authenc(hmac(sha512),rfc3686(ctr(aes)))",
+		.driver_name = "authenc-hmac-sha512-rfc3686-ctr-aes-caam",
+		.blocksize = 1,
+		.type = CRYPTO_ALG_TYPE_AEAD,
+		.template_aead = {
+			.setkey = aead_setkey,
+			.setauthsize = aead_setauthsize,
+			.encrypt = aead_encrypt,
+			.decrypt = aead_decrypt,
+			.givencrypt = aead_givencrypt,
+			.geniv = "<built-in>",
+			.ivsize = CTR_RFC3686_IV_SIZE,
+			.maxauthsize = SHA512_DIGEST_SIZE,
+			},
+		.class1_alg_type = OP_ALG_ALGSEL_AES | OP_ALG_AAI_CTR_MOD128,
+		.class2_alg_type = OP_ALG_ALGSEL_SHA512 |
+				   OP_ALG_AAI_HMAC_PRECOMP,
+		.alg_op = OP_ALG_ALGSEL_SHA512 | OP_ALG_AAI_HMAC,
+	},
+	{
 		.name = "rfc4106(gcm(aes))",
 		.driver_name = "rfc4106-gcm-aes-caam",
 		.blocksize = 1,
-- 
1.8.3.1
