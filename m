From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 3/8] crypto: caam - Convert authenc to new AEAD interface
Date: Thu, 30 Jul 2015 17:53:17 +0800
Message-ID: <E1ZKkWb-0004BH-7g@gondolin.me.apana.org.au>
References: <20150730094138.GA15941@gondor.apana.org.au>
Cc: horia.geanta@freescale.com, ruchika.gupta@freescale.com,
	cristian.stoica@freescale.com, NiteshNarayanLal@freescale.com,
	jinyanjiang@gmail.com, Kim Phillips <kim.phillips@freescale.com>,
	Tudor Ambarus <tudor.ambarus@freescale.com>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:60696 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405AbbG3JxX (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 30 Jul 2015 05:53:23 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch converts the authenc implementations in caam to the
new AEAD interface.  The biggest change is that seqiv no longer
generates a random IV.  Instead the IPsec sequence number is used
as the IV.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/crypto/caam/caamalg.c | 2603 +++++++++++++++++++++---------------------
 1 file changed, 1337 insertions(+), 1266 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index 3c50a50..26f34ef 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -68,19 +68,21 @@
 #define AEAD_DESC_JOB_IO_LEN		(DESC_JOB_IO_LEN + CAAM_CMD_SZ * 2)
 #define GCM_DESC_JOB_IO_LEN		(AEAD_DESC_JOB_IO_LEN + \
 					 CAAM_CMD_SZ * 4)
+#define AUTHENC_DESC_JOB_IO_LEN		(AEAD_DESC_JOB_IO_LEN + \
+					 CAAM_CMD_SZ * 5)
 
 /* length of descriptors text */
 #define DESC_AEAD_BASE			(4 * CAAM_CMD_SZ)
-#define DESC_AEAD_ENC_LEN		(DESC_AEAD_BASE + 15 * CAAM_CMD_SZ)
-#define DESC_AEAD_DEC_LEN		(DESC_AEAD_BASE + 18 * CAAM_CMD_SZ)
-#define DESC_AEAD_GIVENC_LEN		(DESC_AEAD_ENC_LEN + 7 * CAAM_CMD_SZ)
+#define DESC_AEAD_ENC_LEN		(DESC_AEAD_BASE + 11 * CAAM_CMD_SZ)
+#define DESC_AEAD_DEC_LEN		(DESC_AEAD_BASE + 15 * CAAM_CMD_SZ)
+#define DESC_AEAD_GIVENC_LEN		(DESC_AEAD_ENC_LEN + 9 * CAAM_CMD_SZ)
 
 /* Note: Nonce is counted in enckeylen */
-#define DESC_AEAD_CTR_RFC3686_LEN	(6 * CAAM_CMD_SZ)
+#define DESC_AEAD_CTR_RFC3686_LEN	(4 * CAAM_CMD_SZ)
 
 #define DESC_AEAD_NULL_BASE		(3 * CAAM_CMD_SZ)
-#define DESC_AEAD_NULL_ENC_LEN		(DESC_AEAD_NULL_BASE + 14 * CAAM_CMD_SZ)
-#define DESC_AEAD_NULL_DEC_LEN		(DESC_AEAD_NULL_BASE + 17 * CAAM_CMD_SZ)
+#define DESC_AEAD_NULL_ENC_LEN		(DESC_AEAD_NULL_BASE + 11 * CAAM_CMD_SZ)
+#define DESC_AEAD_NULL_DEC_LEN		(DESC_AEAD_NULL_BASE + 13 * CAAM_CMD_SZ)
 
 #define DESC_GCM_BASE			(3 * CAAM_CMD_SZ)
 #define DESC_GCM_ENC_LEN		(DESC_GCM_BASE + 16 * CAAM_CMD_SZ)
@@ -111,6 +113,20 @@
 #endif
 static struct list_head alg_list;
 
+struct caam_alg_entry {
+	int class1_alg_type;
+	int class2_alg_type;
+	int alg_op;
+	bool rfc3686;
+	bool geniv;
+};
+
+struct caam_aead_alg {
+	struct aead_alg aead;
+	struct caam_alg_entry caam;
+	bool registered;
+};
+
 /* Set DK bit in class 1 operation if shared */
 static inline void append_dec_op1(u32 *desc, u32 type)
 {
@@ -145,18 +161,6 @@ static inline void aead_append_src_dst(u32 *desc, u32 msg_type)
 }
 
 /*
- * For aead encrypt and decrypt, read iv for both classes
- */
-static inline void aead_append_ld_iv(u32 *desc, int ivsize, int ivoffset)
-{
-	append_seq_load(desc, ivsize, LDST_CLASS_1_CCB |
-			LDST_SRCDST_BYTE_CONTEXT |
-			(ivoffset << LDST_OFFSET_SHIFT));
-	append_move(desc, MOVE_SRC_CLASS1CTX | MOVE_DEST_CLASS2INFIFO |
-		    (ivoffset << MOVE_OFFSET_SHIFT) | ivsize);
-}
-
-/*
  * For ablkcipher encrypt and decrypt, read from req->src and
  * write to req->dst
  */
@@ -170,13 +174,6 @@ static inline void ablkcipher_append_src_dst(u32 *desc)
 }
 
 /*
- * If all data, including src (with assoc and iv) or dst (with iv only) are
- * contiguous
- */
-#define GIV_SRC_CONTIG		1
-#define GIV_DST_CONTIG		(1 << 1)
-
-/*
  * per-session context
  */
 struct caam_ctx {
@@ -259,7 +256,6 @@ static void init_sh_desc_key_aead(u32 *desc, struct caam_ctx *ctx,
 
 static int aead_null_set_sh_desc(struct crypto_aead *aead)
 {
-	unsigned int ivsize = crypto_aead_ivsize(aead);
 	struct caam_ctx *ctx = crypto_aead_ctx(aead);
 	struct device *jrdev = ctx->jrdev;
 	bool keys_fit_inline = false;
@@ -270,11 +266,11 @@ static int aead_null_set_sh_desc(struct crypto_aead *aead)
 	 * Job Descriptor and Shared Descriptors
 	 * must all fit into the 64-word Descriptor h/w Buffer
 	 */
-	if (DESC_AEAD_NULL_ENC_LEN + DESC_JOB_IO_LEN +
+	if (DESC_AEAD_NULL_ENC_LEN + AEAD_DESC_JOB_IO_LEN +
 	    ctx->split_key_pad_len <= CAAM_DESC_BYTES_MAX)
 		keys_fit_inline = true;
 
-	/* old_aead_encrypt shared descriptor */
+	/* aead_encrypt shared descriptor */
 	desc = ctx->sh_desc_enc;
 
 	init_sh_desc(desc, HDR_SHARE_SERIAL);
@@ -291,20 +287,10 @@ static int aead_null_set_sh_desc(struct crypto_aead *aead)
 			   KEY_DEST_MDHA_SPLIT | KEY_ENC);
 	set_jump_tgt_here(desc, key_jump_cmd);
 
-	/* cryptlen = seqoutlen - authsize */
-	append_math_sub_imm_u32(desc, REG3, SEQOUTLEN, IMM, ctx->authsize);
-
-	/*
-	 * NULL encryption; IV is zero
-	 * assoclen = (assoclen + cryptlen) - cryptlen
-	 */
-	append_math_sub(desc, VARSEQINLEN, SEQINLEN, REG3, CAAM_CMD_SZ);
-
-	/* read assoc before reading payload */
-	append_seq_fifo_load(desc, 0, FIFOLD_CLASS_CLASS2 | FIFOLD_TYPE_MSG |
-			     KEY_VLF);
+	/* assoclen + cryptlen = seqinlen */
+	append_math_sub(desc, REG3, SEQINLEN, REG0, CAAM_CMD_SZ);
 
-	/* Prepare to read and write cryptlen bytes */
+	/* Prepare to read and write cryptlen + assoclen bytes */
 	append_math_add(desc, VARSEQINLEN, ZERO, REG3, CAAM_CMD_SZ);
 	append_math_add(desc, VARSEQOUTLEN, ZERO, REG3, CAAM_CMD_SZ);
 
@@ -363,7 +349,7 @@ static int aead_null_set_sh_desc(struct crypto_aead *aead)
 
 	desc = ctx->sh_desc_dec;
 
-	/* old_aead_decrypt shared descriptor */
+	/* aead_decrypt shared descriptor */
 	init_sh_desc(desc, HDR_SHARE_SERIAL);
 
 	/* Skip if already shared */
@@ -382,18 +368,10 @@ static int aead_null_set_sh_desc(struct crypto_aead *aead)
 	append_operation(desc, ctx->class2_alg_type |
 			 OP_ALG_AS_INITFINAL | OP_ALG_DECRYPT | OP_ALG_ICV_ON);
 
-	/* assoclen + cryptlen = seqinlen - ivsize - authsize */
-	append_math_sub_imm_u32(desc, REG3, SEQINLEN, IMM,
-				ctx->authsize + ivsize);
-	/* assoclen = (assoclen + cryptlen) - cryptlen */
+	/* assoclen + cryptlen = seqoutlen */
 	append_math_sub(desc, REG2, SEQOUTLEN, REG0, CAAM_CMD_SZ);
-	append_math_sub(desc, VARSEQINLEN, REG3, REG2, CAAM_CMD_SZ);
 
-	/* read assoc before reading payload */
-	append_seq_fifo_load(desc, 0, FIFOLD_CLASS_CLASS2 | FIFOLD_TYPE_MSG |
-			     KEY_VLF);
-
-	/* Prepare to read and write cryptlen bytes */
+	/* Prepare to read and write cryptlen + assoclen bytes */
 	append_math_add(desc, VARSEQINLEN, ZERO, REG2, CAAM_CMD_SZ);
 	append_math_add(desc, VARSEQOUTLEN, ZERO, REG2, CAAM_CMD_SZ);
 
@@ -450,10 +428,10 @@ static int aead_null_set_sh_desc(struct crypto_aead *aead)
 
 static int aead_set_sh_desc(struct crypto_aead *aead)
 {
+	struct caam_aead_alg *alg = container_of(crypto_aead_alg(aead),
+						 struct caam_aead_alg, aead);
 	unsigned int ivsize = crypto_aead_ivsize(aead);
 	struct caam_ctx *ctx = crypto_aead_ctx(aead);
-	struct crypto_tfm *ctfm = crypto_aead_tfm(aead);
-	const char *alg_name = crypto_tfm_alg_name(ctfm);
 	struct device *jrdev = ctx->jrdev;
 	bool keys_fit_inline;
 	u32 geniv, moveiv;
@@ -461,11 +439,7 @@ static int aead_set_sh_desc(struct crypto_aead *aead)
 	u32 *desc;
 	const bool ctr_mode = ((ctx->class1_alg_type & OP_ALG_AAI_MASK) ==
 			       OP_ALG_AAI_CTR_MOD128);
-	const bool is_rfc3686 = (ctr_mode &&
-				 (strstr(alg_name, "rfc3686") != NULL));
-
-	if (!ctx->authsize)
-		return 0;
+	const bool is_rfc3686 = alg->caam.rfc3686;
 
 	/* NULL encryption / decryption */
 	if (!ctx->enckeylen)
@@ -486,18 +460,21 @@ static int aead_set_sh_desc(struct crypto_aead *aead)
 	if (is_rfc3686)
 		ctx1_iv_off = 16 + CTR_RFC3686_NONCE_SIZE;
 
+	if (alg->caam.geniv)
+		goto skip_enc;
+
 	/*
 	 * Job Descriptor and Shared Descriptors
 	 * must all fit into the 64-word Descriptor h/w Buffer
 	 */
 	keys_fit_inline = false;
-	if (DESC_AEAD_ENC_LEN + DESC_JOB_IO_LEN +
+	if (DESC_AEAD_ENC_LEN + AUTHENC_DESC_JOB_IO_LEN +
 	    ctx->split_key_pad_len + ctx->enckeylen +
 	    (is_rfc3686 ? DESC_AEAD_CTR_RFC3686_LEN : 0) <=
 	    CAAM_DESC_BYTES_MAX)
 		keys_fit_inline = true;
 
-	/* old_aead_encrypt shared descriptor */
+	/* aead_encrypt shared descriptor */
 	desc = ctx->sh_desc_enc;
 
 	/* Note: Context registers are saved. */
@@ -507,19 +484,16 @@ static int aead_set_sh_desc(struct crypto_aead *aead)
 	append_operation(desc, ctx->class2_alg_type |
 			 OP_ALG_AS_INITFINAL | OP_ALG_ENCRYPT);
 
-	/* cryptlen = seqoutlen - authsize */
-	append_math_sub_imm_u32(desc, REG3, SEQOUTLEN, IMM, ctx->authsize);
-
-	/* assoclen + cryptlen = seqinlen - ivsize */
-	append_math_sub_imm_u32(desc, REG2, SEQINLEN, IMM, ivsize);
+	/* Read and write assoclen bytes */
+	append_math_add(desc, VARSEQINLEN, ZERO, REG3, CAAM_CMD_SZ);
+	append_math_add(desc, VARSEQOUTLEN, ZERO, REG3, CAAM_CMD_SZ);
 
-	/* assoclen = (assoclen + cryptlen) - cryptlen */
-	append_math_sub(desc, VARSEQINLEN, REG2, REG3, CAAM_CMD_SZ);
+	/* Skip assoc data */
+	append_seq_fifo_store(desc, 0, FIFOST_TYPE_SKIP | FIFOLDST_VLF);
 
 	/* read assoc before reading payload */
 	append_seq_fifo_load(desc, 0, FIFOLD_CLASS_CLASS2 | FIFOLD_TYPE_MSG |
-			     KEY_VLF);
-	aead_append_ld_iv(desc, ivsize, ctx1_iv_off);
+				      FIFOLDST_VLF);
 
 	/* Load Counter into CONTEXT1 reg */
 	if (is_rfc3686)
@@ -534,8 +508,8 @@ static int aead_set_sh_desc(struct crypto_aead *aead)
 			 OP_ALG_AS_INITFINAL | OP_ALG_ENCRYPT);
 
 	/* Read and write cryptlen bytes */
-	append_math_add(desc, VARSEQINLEN, ZERO, REG3, CAAM_CMD_SZ);
-	append_math_add(desc, VARSEQOUTLEN, ZERO, REG3, CAAM_CMD_SZ);
+	append_math_add(desc, VARSEQINLEN, SEQINLEN, REG0, CAAM_CMD_SZ);
+	append_math_add(desc, VARSEQOUTLEN, SEQINLEN, REG0, CAAM_CMD_SZ);
 	aead_append_src_dst(desc, FIFOLD_TYPE_MSG1OUT2);
 
 	/* Write ICV */
@@ -555,18 +529,19 @@ static int aead_set_sh_desc(struct crypto_aead *aead)
 		       desc_bytes(desc), 1);
 #endif
 
+skip_enc:
 	/*
 	 * Job Descriptor and Shared Descriptors
 	 * must all fit into the 64-word Descriptor h/w Buffer
 	 */
 	keys_fit_inline = false;
-	if (DESC_AEAD_DEC_LEN + DESC_JOB_IO_LEN +
+	if (DESC_AEAD_DEC_LEN + AUTHENC_DESC_JOB_IO_LEN +
 	    ctx->split_key_pad_len + ctx->enckeylen +
 	    (is_rfc3686 ? DESC_AEAD_CTR_RFC3686_LEN : 0) <=
 	    CAAM_DESC_BYTES_MAX)
 		keys_fit_inline = true;
 
-	/* old_aead_decrypt shared descriptor */
+	/* aead_decrypt shared descriptor */
 	desc = ctx->sh_desc_dec;
 
 	/* Note: Context registers are saved. */
@@ -576,19 +551,17 @@ static int aead_set_sh_desc(struct crypto_aead *aead)
 	append_operation(desc, ctx->class2_alg_type |
 			 OP_ALG_AS_INITFINAL | OP_ALG_DECRYPT | OP_ALG_ICV_ON);
 
-	/* assoclen + cryptlen = seqinlen - ivsize - authsize */
-	append_math_sub_imm_u32(desc, REG3, SEQINLEN, IMM,
-				ctx->authsize + ivsize);
-	/* assoclen = (assoclen + cryptlen) - cryptlen */
-	append_math_sub(desc, REG2, SEQOUTLEN, REG0, CAAM_CMD_SZ);
-	append_math_sub(desc, VARSEQINLEN, REG3, REG2, CAAM_CMD_SZ);
+	/* Read and write assoclen bytes */
+	append_math_add(desc, VARSEQINLEN, ZERO, REG3, CAAM_CMD_SZ);
+	append_math_add(desc, VARSEQOUTLEN, ZERO, REG3, CAAM_CMD_SZ);
+
+	/* Skip assoc data */
+	append_seq_fifo_store(desc, 0, FIFOST_TYPE_SKIP | FIFOLDST_VLF);
 
 	/* read assoc before reading payload */
 	append_seq_fifo_load(desc, 0, FIFOLD_CLASS_CLASS2 | FIFOLD_TYPE_MSG |
 			     KEY_VLF);
 
-	aead_append_ld_iv(desc, ivsize, ctx1_iv_off);
-
 	/* Load Counter into CONTEXT1 reg */
 	if (is_rfc3686)
 		append_load_imm_u32(desc, be32_to_cpu(1), LDST_IMM |
@@ -605,8 +578,8 @@ static int aead_set_sh_desc(struct crypto_aead *aead)
 		append_dec_op1(desc, ctx->class1_alg_type);
 
 	/* Read and write cryptlen bytes */
-	append_math_add(desc, VARSEQINLEN, ZERO, REG2, CAAM_CMD_SZ);
-	append_math_add(desc, VARSEQOUTLEN, ZERO, REG2, CAAM_CMD_SZ);
+	append_math_add(desc, VARSEQINLEN, SEQOUTLEN, REG0, CAAM_CMD_SZ);
+	append_math_add(desc, VARSEQOUTLEN, SEQOUTLEN, REG0, CAAM_CMD_SZ);
 	aead_append_src_dst(desc, FIFOLD_TYPE_MSG);
 
 	/* Load ICV */
@@ -626,12 +599,15 @@ static int aead_set_sh_desc(struct crypto_aead *aead)
 		       desc_bytes(desc), 1);
 #endif
 
+	if (!alg->caam.geniv)
+		goto skip_givenc;
+
 	/*
 	 * Job Descriptor and Shared Descriptors
 	 * must all fit into the 64-word Descriptor h/w Buffer
 	 */
 	keys_fit_inline = false;
-	if (DESC_AEAD_GIVENC_LEN + DESC_JOB_IO_LEN +
+	if (DESC_AEAD_GIVENC_LEN + AUTHENC_DESC_JOB_IO_LEN +
 	    ctx->split_key_pad_len + ctx->enckeylen +
 	    (is_rfc3686 ? DESC_AEAD_CTR_RFC3686_LEN : 0) <=
 	    CAAM_DESC_BYTES_MAX)
@@ -643,6 +619,9 @@ static int aead_set_sh_desc(struct crypto_aead *aead)
 	/* Note: Context registers are saved. */
 	init_sh_desc_key_aead(desc, ctx, keys_fit_inline, is_rfc3686);
 
+	if (is_rfc3686)
+		goto copy_iv;
+
 	/* Generate IV */
 	geniv = NFIFOENTRY_STYPE_PAD | NFIFOENTRY_DEST_DECO |
 		NFIFOENTRY_DTYPE_MSG | NFIFOENTRY_LC1 |
@@ -656,6 +635,7 @@ static int aead_set_sh_desc(struct crypto_aead *aead)
 		    (ivsize << MOVE_LEN_SHIFT));
 	append_cmd(desc, CMD_LOAD | ENABLE_AUTO_INFO_FIFO);
 
+copy_iv:
 	/* Copy IV to class 1 context */
 	append_move(desc, MOVE_SRC_CLASS1CTX | MOVE_DEST_OUTFIFO |
 		    (ctx1_iv_off << MOVE_OFFSET_SHIFT) |
@@ -668,8 +648,12 @@ static int aead_set_sh_desc(struct crypto_aead *aead)
 	/* ivsize + cryptlen = seqoutlen - authsize */
 	append_math_sub_imm_u32(desc, REG3, SEQOUTLEN, IMM, ctx->authsize);
 
-	/* assoclen = seqinlen - (ivsize + cryptlen) */
-	append_math_sub(desc, VARSEQINLEN, SEQINLEN, REG3, CAAM_CMD_SZ);
+	/* Read and write assoclen bytes */
+	append_math_add(desc, VARSEQINLEN, ZERO, REG3, CAAM_CMD_SZ);
+	append_math_add(desc, VARSEQOUTLEN, ZERO, REG3, CAAM_CMD_SZ);
+
+	/* Skip assoc data */
+	append_seq_fifo_store(desc, 0, FIFOST_TYPE_SKIP | FIFOLDST_VLF);
 
 	/* read assoc before reading payload */
 	append_seq_fifo_load(desc, 0, FIFOLD_CLASS_CLASS2 | FIFOLD_TYPE_MSG |
@@ -710,9 +694,9 @@ static int aead_set_sh_desc(struct crypto_aead *aead)
 	append_seq_store(desc, ctx->authsize, LDST_CLASS_2_CCB |
 			 LDST_SRCDST_BYTE_CONTEXT);
 
-	ctx->sh_desc_givenc_dma = dma_map_single(jrdev, desc,
-						 desc_bytes(desc),
-						 DMA_TO_DEVICE);
+	ctx->sh_desc_enc_dma = dma_map_single(jrdev, desc,
+					      desc_bytes(desc),
+					      DMA_TO_DEVICE);
 	if (dma_mapping_error(jrdev, ctx->sh_desc_givenc_dma)) {
 		dev_err(jrdev, "unable to map shared descriptor\n");
 		return -ENOMEM;
@@ -723,6 +707,7 @@ static int aead_set_sh_desc(struct crypto_aead *aead)
 		       desc_bytes(desc), 1);
 #endif
 
+skip_givenc:
 	return 0;
 }
 
@@ -1799,22 +1784,6 @@ static void aead_unmap(struct device *dev,
 		   edesc->sec4_sg_dma, edesc->sec4_sg_bytes);
 }
 
-static void old_aead_unmap(struct device *dev,
-			   struct aead_edesc *edesc,
-			   struct aead_request *req)
-{
-	struct crypto_aead *aead = crypto_aead_reqtfm(req);
-	int ivsize = crypto_aead_ivsize(aead);
-
-	dma_unmap_sg_chained(dev, req->assoc, edesc->assoc_nents,
-			     DMA_TO_DEVICE, edesc->assoc_chained);
-
-	caam_unmap(dev, req->src, req->dst,
-		   edesc->src_nents, edesc->src_chained, edesc->dst_nents,
-		   edesc->dst_chained, edesc->iv_dma, ivsize,
-		   edesc->sec4_sg_dma, edesc->sec4_sg_bytes);
-}
-
 static void ablkcipher_unmap(struct device *dev,
 			     struct ablkcipher_edesc *edesc,
 			     struct ablkcipher_request *req)
@@ -1850,45 +1819,6 @@ static void aead_encrypt_done(struct device *jrdev, u32 *desc, u32 err,
 	aead_request_complete(req, err);
 }
 
-static void old_aead_encrypt_done(struct device *jrdev, u32 *desc, u32 err,
-				  void *context)
-{
-	struct aead_request *req = context;
-	struct aead_edesc *edesc;
-#ifdef DEBUG
-	struct crypto_aead *aead = crypto_aead_reqtfm(req);
-	struct caam_ctx *ctx = crypto_aead_ctx(aead);
-	int ivsize = crypto_aead_ivsize(aead);
-
-	dev_err(jrdev, "%s %d: err 0x%x\n", __func__, __LINE__, err);
-#endif
-
-	edesc = (struct aead_edesc *)((char *)desc -
-		 offsetof(struct aead_edesc, hw_desc));
-
-	if (err)
-		caam_jr_strstatus(jrdev, err);
-
-	old_aead_unmap(jrdev, edesc, req);
-
-#ifdef DEBUG
-	print_hex_dump(KERN_ERR, "assoc  @"__stringify(__LINE__)": ",
-		       DUMP_PREFIX_ADDRESS, 16, 4, sg_virt(req->assoc),
-		       req->assoclen , 1);
-	print_hex_dump(KERN_ERR, "dstiv  @"__stringify(__LINE__)": ",
-		       DUMP_PREFIX_ADDRESS, 16, 4, sg_virt(req->src) - ivsize,
-		       edesc->src_nents ? 100 : ivsize, 1);
-	print_hex_dump(KERN_ERR, "dst    @"__stringify(__LINE__)": ",
-		       DUMP_PREFIX_ADDRESS, 16, 4, sg_virt(req->src),
-		       edesc->src_nents ? 100 : req->cryptlen +
-		       ctx->authsize + 4, 1);
-#endif
-
-	kfree(edesc);
-
-	aead_request_complete(req, err);
-}
-
 static void aead_decrypt_done(struct device *jrdev, u32 *desc, u32 err,
 				   void *context)
 {
@@ -1917,62 +1847,6 @@ static void aead_decrypt_done(struct device *jrdev, u32 *desc, u32 err,
 	aead_request_complete(req, err);
 }
 
-static void old_aead_decrypt_done(struct device *jrdev, u32 *desc, u32 err,
-				  void *context)
-{
-	struct aead_request *req = context;
-	struct aead_edesc *edesc;
-#ifdef DEBUG
-	struct crypto_aead *aead = crypto_aead_reqtfm(req);
-	struct caam_ctx *ctx = crypto_aead_ctx(aead);
-	int ivsize = crypto_aead_ivsize(aead);
-
-	dev_err(jrdev, "%s %d: err 0x%x\n", __func__, __LINE__, err);
-#endif
-
-	edesc = (struct aead_edesc *)((char *)desc -
-		 offsetof(struct aead_edesc, hw_desc));
-
-#ifdef DEBUG
-	print_hex_dump(KERN_ERR, "dstiv  @"__stringify(__LINE__)": ",
-		       DUMP_PREFIX_ADDRESS, 16, 4, req->iv,
-		       ivsize, 1);
-	print_hex_dump(KERN_ERR, "dst    @"__stringify(__LINE__)": ",
-		       DUMP_PREFIX_ADDRESS, 16, 4, sg_virt(req->dst),
-		       req->cryptlen - ctx->authsize, 1);
-#endif
-
-	if (err)
-		caam_jr_strstatus(jrdev, err);
-
-	old_aead_unmap(jrdev, edesc, req);
-
-	/*
-	 * verify hw auth check passed else return -EBADMSG
-	 */
-	if ((err & JRSTA_CCBERR_ERRID_MASK) == JRSTA_CCBERR_ERRID_ICVCHK)
-		err = -EBADMSG;
-
-#ifdef DEBUG
-	print_hex_dump(KERN_ERR, "iphdrout@"__stringify(__LINE__)": ",
-		       DUMP_PREFIX_ADDRESS, 16, 4,
-		       ((char *)sg_virt(req->assoc) - sizeof(struct iphdr)),
-		       sizeof(struct iphdr) + req->assoclen +
-		       ((req->cryptlen > 1500) ? 1500 : req->cryptlen) +
-		       ctx->authsize + 36, 1);
-	if (!err && edesc->sec4_sg_bytes) {
-		struct scatterlist *sg = sg_last(req->src, edesc->src_nents);
-		print_hex_dump(KERN_ERR, "sglastout@"__stringify(__LINE__)": ",
-			       DUMP_PREFIX_ADDRESS, 16, 4, sg_virt(sg),
-			sg->length + ctx->authsize + 16, 1);
-	}
-#endif
-
-	kfree(edesc);
-
-	aead_request_complete(req, err);
-}
-
 static void ablkcipher_encrypt_done(struct device *jrdev, u32 *desc, u32 err,
 				   void *context)
 {
@@ -2041,91 +1915,6 @@ static void ablkcipher_decrypt_done(struct device *jrdev, u32 *desc, u32 err,
 /*
  * Fill in aead job descriptor
  */
-static void old_init_aead_job(u32 *sh_desc, dma_addr_t ptr,
-			      struct aead_edesc *edesc,
-			      struct aead_request *req,
-			      bool all_contig, bool encrypt)
-{
-	struct crypto_aead *aead = crypto_aead_reqtfm(req);
-	struct caam_ctx *ctx = crypto_aead_ctx(aead);
-	int ivsize = crypto_aead_ivsize(aead);
-	int authsize = ctx->authsize;
-	u32 *desc = edesc->hw_desc;
-	u32 out_options = 0, in_options;
-	dma_addr_t dst_dma, src_dma;
-	int len, sec4_sg_index = 0;
-	bool is_gcm = false;
-
-#ifdef DEBUG
-	debug("assoclen %d cryptlen %d authsize %d\n",
-	      req->assoclen, req->cryptlen, authsize);
-	print_hex_dump(KERN_ERR, "assoc  @"__stringify(__LINE__)": ",
-		       DUMP_PREFIX_ADDRESS, 16, 4, sg_virt(req->assoc),
-		       req->assoclen , 1);
-	print_hex_dump(KERN_ERR, "presciv@"__stringify(__LINE__)": ",
-		       DUMP_PREFIX_ADDRESS, 16, 4, req->iv,
-		       edesc->src_nents ? 100 : ivsize, 1);
-	print_hex_dump(KERN_ERR, "src    @"__stringify(__LINE__)": ",
-		       DUMP_PREFIX_ADDRESS, 16, 4, sg_virt(req->src),
-			edesc->src_nents ? 100 : req->cryptlen, 1);
-	print_hex_dump(KERN_ERR, "shrdesc@"__stringify(__LINE__)": ",
-		       DUMP_PREFIX_ADDRESS, 16, 4, sh_desc,
-		       desc_bytes(sh_desc), 1);
-#endif
-
-	if (((ctx->class1_alg_type & OP_ALG_ALGSEL_MASK) ==
-	      OP_ALG_ALGSEL_AES) &&
-	    ((ctx->class1_alg_type & OP_ALG_AAI_MASK) == OP_ALG_AAI_GCM))
-		is_gcm = true;
-
-	len = desc_len(sh_desc);
-	init_job_desc_shared(desc, ptr, len, HDR_SHARE_DEFER | HDR_REVERSE);
-
-	if (all_contig) {
-		if (is_gcm)
-			src_dma = edesc->iv_dma;
-		else
-			src_dma = sg_dma_address(req->assoc);
-		in_options = 0;
-	} else {
-		src_dma = edesc->sec4_sg_dma;
-		sec4_sg_index += (edesc->assoc_nents ? : 1) + 1 +
-				 (edesc->src_nents ? : 1);
-		in_options = LDST_SGF;
-	}
-
-	append_seq_in_ptr(desc, src_dma, req->assoclen + ivsize + req->cryptlen,
-			  in_options);
-
-	if (likely(req->src == req->dst)) {
-		if (all_contig) {
-			dst_dma = sg_dma_address(req->src);
-		} else {
-			dst_dma = src_dma + sizeof(struct sec4_sg_entry) *
-				  ((edesc->assoc_nents ? : 1) + 1);
-			out_options = LDST_SGF;
-		}
-	} else {
-		if (!edesc->dst_nents) {
-			dst_dma = sg_dma_address(req->dst);
-		} else {
-			dst_dma = edesc->sec4_sg_dma +
-				  sec4_sg_index *
-				  sizeof(struct sec4_sg_entry);
-			out_options = LDST_SGF;
-		}
-	}
-	if (encrypt)
-		append_seq_out_ptr(desc, dst_dma, req->cryptlen + authsize,
-				   out_options);
-	else
-		append_seq_out_ptr(desc, dst_dma, req->cryptlen - authsize,
-				   out_options);
-}
-
-/*
- * Fill in aead job descriptor
- */
 static void init_aead_job(struct aead_request *req,
 			  struct aead_edesc *edesc,
 			  bool all_contig, bool encrypt)
@@ -2214,80 +2003,43 @@ static void init_gcm_job(struct aead_request *req,
 	/* End of blank commands */
 }
 
-/*
- * Fill in aead givencrypt job descriptor
- */
-static void init_aead_giv_job(u32 *sh_desc, dma_addr_t ptr,
-			      struct aead_edesc *edesc,
-			      struct aead_request *req,
-			      int contig)
+static void init_authenc_job(struct aead_request *req,
+			     struct aead_edesc *edesc,
+			     bool all_contig, bool encrypt)
 {
 	struct crypto_aead *aead = crypto_aead_reqtfm(req);
+	struct caam_aead_alg *alg = container_of(crypto_aead_alg(aead),
+						 struct caam_aead_alg, aead);
+	unsigned int ivsize = crypto_aead_ivsize(aead);
 	struct caam_ctx *ctx = crypto_aead_ctx(aead);
-	int ivsize = crypto_aead_ivsize(aead);
-	int authsize = ctx->authsize;
+	const bool ctr_mode = ((ctx->class1_alg_type & OP_ALG_AAI_MASK) ==
+			       OP_ALG_AAI_CTR_MOD128);
+	const bool is_rfc3686 = alg->caam.rfc3686;
 	u32 *desc = edesc->hw_desc;
-	u32 out_options = 0, in_options;
-	dma_addr_t dst_dma, src_dma;
-	int len, sec4_sg_index = 0;
-	bool is_gcm = false;
+	u32 ivoffset = 0;
 
-#ifdef DEBUG
-	debug("assoclen %d cryptlen %d authsize %d\n",
-	      req->assoclen, req->cryptlen, authsize);
-	print_hex_dump(KERN_ERR, "assoc  @"__stringify(__LINE__)": ",
-		       DUMP_PREFIX_ADDRESS, 16, 4, sg_virt(req->assoc),
-		       req->assoclen , 1);
-	print_hex_dump(KERN_ERR, "presciv@"__stringify(__LINE__)": ",
-		       DUMP_PREFIX_ADDRESS, 16, 4, req->iv, ivsize, 1);
-	print_hex_dump(KERN_ERR, "src    @"__stringify(__LINE__)": ",
-		       DUMP_PREFIX_ADDRESS, 16, 4, sg_virt(req->src),
-			edesc->src_nents > 1 ? 100 : req->cryptlen, 1);
-	print_hex_dump(KERN_ERR, "shrdesc@"__stringify(__LINE__)": ",
-		       DUMP_PREFIX_ADDRESS, 16, 4, sh_desc,
-		       desc_bytes(sh_desc), 1);
-#endif
-
-	if (((ctx->class1_alg_type & OP_ALG_ALGSEL_MASK) ==
-	      OP_ALG_ALGSEL_AES) &&
-	    ((ctx->class1_alg_type & OP_ALG_AAI_MASK) == OP_ALG_AAI_GCM))
-		is_gcm = true;
-
-	len = desc_len(sh_desc);
-	init_job_desc_shared(desc, ptr, len, HDR_SHARE_DEFER | HDR_REVERSE);
+	/*
+	 * AES-CTR needs to load IV in CONTEXT1 reg
+	 * at an offset of 128bits (16bytes)
+	 * CONTEXT1[255:128] = IV
+	 */
+	if (ctr_mode)
+		ivoffset = 16;
 
-	if (contig & GIV_SRC_CONTIG) {
-		if (is_gcm)
-			src_dma = edesc->iv_dma;
-		else
-			src_dma = sg_dma_address(req->assoc);
-		in_options = 0;
-	} else {
-		src_dma = edesc->sec4_sg_dma;
-		sec4_sg_index += edesc->assoc_nents + 1 + edesc->src_nents;
-		in_options = LDST_SGF;
-	}
-	append_seq_in_ptr(desc, src_dma, req->assoclen + ivsize + req->cryptlen,
-			  in_options);
+	/*
+	 * RFC3686 specific:
+	 *	CONTEXT1[255:128] = {NONCE, IV, COUNTER}
+	 */
+	if (is_rfc3686)
+		ivoffset = 16 + CTR_RFC3686_NONCE_SIZE;
 
-	if (contig & GIV_DST_CONTIG) {
-		dst_dma = edesc->iv_dma;
-	} else {
-		if (likely(req->src == req->dst)) {
-			dst_dma = src_dma + sizeof(struct sec4_sg_entry) *
-				  (edesc->assoc_nents +
-				   (is_gcm ? 1 + edesc->src_nents : 0));
-			out_options = LDST_SGF;
-		} else {
-			dst_dma = edesc->sec4_sg_dma +
-				  sec4_sg_index *
-				  sizeof(struct sec4_sg_entry);
-			out_options = LDST_SGF;
-		}
-	}
+	init_aead_job(req, edesc, all_contig, encrypt);
 
-	append_seq_out_ptr(desc, dst_dma, ivsize + req->cryptlen + authsize,
-			   out_options);
+	if (ivsize && (is_rfc3686 || !(alg->caam.geniv && encrypt)))
+		append_load_as_imm(desc, req->iv, ivsize,
+				   LDST_CLASS_1_CCB |
+				   LDST_SRCDST_BYTE_CONTEXT |
+				   (ivoffset << LDST_OFFSET_SHIFT));
 }
 
 /*
@@ -2398,177 +2150,33 @@ static void init_ablkcipher_giv_job(u32 *sh_desc, dma_addr_t ptr,
 /*
  * allocate and map the aead extended descriptor
  */
-static struct aead_edesc *old_aead_edesc_alloc(struct aead_request *req,
-					       int desc_bytes,
-					       bool *all_contig_ptr,
-					       bool encrypt)
+static struct aead_edesc *aead_edesc_alloc(struct aead_request *req,
+					   int desc_bytes, bool *all_contig_ptr,
+					   bool encrypt)
 {
 	struct crypto_aead *aead = crypto_aead_reqtfm(req);
 	struct caam_ctx *ctx = crypto_aead_ctx(aead);
 	struct device *jrdev = ctx->jrdev;
 	gfp_t flags = (req->base.flags & (CRYPTO_TFM_REQ_MAY_BACKLOG |
 		       CRYPTO_TFM_REQ_MAY_SLEEP)) ? GFP_KERNEL : GFP_ATOMIC;
-	int assoc_nents, src_nents, dst_nents = 0;
+	int src_nents, dst_nents = 0;
 	struct aead_edesc *edesc;
-	dma_addr_t iv_dma = 0;
 	int sgc;
 	bool all_contig = true;
-	bool assoc_chained = false, src_chained = false, dst_chained = false;
-	int ivsize = crypto_aead_ivsize(aead);
+	bool src_chained = false, dst_chained = false;
 	int sec4_sg_index, sec4_sg_len = 0, sec4_sg_bytes;
 	unsigned int authsize = ctx->authsize;
-	bool is_gcm = false;
-
-	assoc_nents = sg_count(req->assoc, req->assoclen, &assoc_chained);
 
 	if (unlikely(req->dst != req->src)) {
-		src_nents = sg_count(req->src, req->cryptlen, &src_chained);
+		src_nents = sg_count(req->src, req->assoclen + req->cryptlen,
+				     &src_chained);
 		dst_nents = sg_count(req->dst,
-				     req->cryptlen +
+				     req->assoclen + req->cryptlen +
 					(encrypt ? authsize : (-authsize)),
 				     &dst_chained);
 	} else {
 		src_nents = sg_count(req->src,
-				     req->cryptlen +
-					(encrypt ? authsize : 0),
-				     &src_chained);
-	}
-
-	sgc = dma_map_sg_chained(jrdev, req->assoc, assoc_nents ? : 1,
-				 DMA_TO_DEVICE, assoc_chained);
-	if (likely(req->src == req->dst)) {
-		sgc = dma_map_sg_chained(jrdev, req->src, src_nents ? : 1,
-					 DMA_BIDIRECTIONAL, src_chained);
-	} else {
-		sgc = dma_map_sg_chained(jrdev, req->src, src_nents ? : 1,
-					 DMA_TO_DEVICE, src_chained);
-		sgc = dma_map_sg_chained(jrdev, req->dst, dst_nents ? : 1,
-					 DMA_FROM_DEVICE, dst_chained);
-	}
-
-	iv_dma = dma_map_single(jrdev, req->iv, ivsize, DMA_TO_DEVICE);
-	if (dma_mapping_error(jrdev, iv_dma)) {
-		dev_err(jrdev, "unable to map IV\n");
-		return ERR_PTR(-ENOMEM);
-	}
-
-	if (((ctx->class1_alg_type & OP_ALG_ALGSEL_MASK) ==
-	      OP_ALG_ALGSEL_AES) &&
-	    ((ctx->class1_alg_type & OP_ALG_AAI_MASK) == OP_ALG_AAI_GCM))
-		is_gcm = true;
-
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
-	if (!all_contig) {
-		assoc_nents = assoc_nents ? : 1;
-		src_nents = src_nents ? : 1;
-		sec4_sg_len = assoc_nents + 1 + src_nents;
-	}
-
-	sec4_sg_len += dst_nents;
-
-	sec4_sg_bytes = sec4_sg_len * sizeof(struct sec4_sg_entry);
-
-	/* allocate space for base edesc and hw desc commands, link tables */
-	edesc = kmalloc(sizeof(struct aead_edesc) + desc_bytes +
-			sec4_sg_bytes, GFP_DMA | flags);
-	if (!edesc) {
-		dev_err(jrdev, "could not allocate extended descriptor\n");
-		return ERR_PTR(-ENOMEM);
-	}
-
-	edesc->assoc_nents = assoc_nents;
-	edesc->assoc_chained = assoc_chained;
-	edesc->src_nents = src_nents;
-	edesc->src_chained = src_chained;
-	edesc->dst_nents = dst_nents;
-	edesc->dst_chained = dst_chained;
-	edesc->iv_dma = iv_dma;
-	edesc->sec4_sg_bytes = sec4_sg_bytes;
-	edesc->sec4_sg = (void *)edesc + sizeof(struct aead_edesc) +
-			 desc_bytes;
-	*all_contig_ptr = all_contig;
-
-	sec4_sg_index = 0;
-	if (!all_contig) {
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
-		sec4_sg_index += src_nents;
-	}
-	if (dst_nents) {
-		sg_to_sec4_sg_last(req->dst, dst_nents,
-				   edesc->sec4_sg + sec4_sg_index, 0);
-	}
-	edesc->sec4_sg_dma = dma_map_single(jrdev, edesc->sec4_sg,
-					    sec4_sg_bytes, DMA_TO_DEVICE);
-	if (dma_mapping_error(jrdev, edesc->sec4_sg_dma)) {
-		dev_err(jrdev, "unable to map S/G table\n");
-		return ERR_PTR(-ENOMEM);
-	}
-
-	return edesc;
-}
-
-/*
- * allocate and map the aead extended descriptor
- */
-static struct aead_edesc *aead_edesc_alloc(struct aead_request *req,
-					   int desc_bytes, bool *all_contig_ptr,
-					   bool encrypt)
-{
-	struct crypto_aead *aead = crypto_aead_reqtfm(req);
-	struct caam_ctx *ctx = crypto_aead_ctx(aead);
-	struct device *jrdev = ctx->jrdev;
-	gfp_t flags = (req->base.flags & (CRYPTO_TFM_REQ_MAY_BACKLOG |
-		       CRYPTO_TFM_REQ_MAY_SLEEP)) ? GFP_KERNEL : GFP_ATOMIC;
-	int src_nents, dst_nents = 0;
-	struct aead_edesc *edesc;
-	int sgc;
-	bool all_contig = true;
-	bool src_chained = false, dst_chained = false;
-	int sec4_sg_index, sec4_sg_len = 0, sec4_sg_bytes;
-	unsigned int authsize = ctx->authsize;
-
-	if (unlikely(req->dst != req->src)) {
-		src_nents = sg_count(req->src, req->assoclen + req->cryptlen,
-				     &src_chained);
-		dst_nents = sg_count(req->dst,
-				     req->assoclen + req->cryptlen +
-					(encrypt ? authsize : (-authsize)),
-				     &dst_chained);
-	} else {
-		src_nents = sg_count(req->src,
-				     req->assoclen + req->cryptlen +
+				     req->assoclen + req->cryptlen +
 					(encrypt ? authsize : 0),
 				     &src_chained);
 	}
@@ -2699,7 +2307,7 @@ static int ipsec_gcm_encrypt(struct aead_request *req)
 	return gcm_encrypt(req);
 }
 
-static int old_aead_encrypt(struct aead_request *req)
+static int aead_encrypt(struct aead_request *req)
 {
 	struct aead_edesc *edesc;
 	struct crypto_aead *aead = crypto_aead_reqtfm(req);
@@ -2710,14 +2318,13 @@ static int old_aead_encrypt(struct aead_request *req)
 	int ret = 0;
 
 	/* allocate extended descriptor */
-	edesc = old_aead_edesc_alloc(req, DESC_JOB_IO_LEN *
-				     CAAM_CMD_SZ, &all_contig, true);
+	edesc = aead_edesc_alloc(req, AUTHENC_DESC_JOB_IO_LEN,
+				 &all_contig, true);
 	if (IS_ERR(edesc))
 		return PTR_ERR(edesc);
 
 	/* Create and submit job descriptor */
-	old_init_aead_job(ctx->sh_desc_enc, ctx->sh_desc_enc_dma, edesc, req,
-			  all_contig, true);
+	init_authenc_job(req, edesc, all_contig, true);
 #ifdef DEBUG
 	print_hex_dump(KERN_ERR, "aead jobdesc@"__stringify(__LINE__)": ",
 		       DUMP_PREFIX_ADDRESS, 16, 4, edesc->hw_desc,
@@ -2725,11 +2332,11 @@ static int old_aead_encrypt(struct aead_request *req)
 #endif
 
 	desc = edesc->hw_desc;
-	ret = caam_jr_enqueue(jrdev, desc, old_aead_encrypt_done, req);
+	ret = caam_jr_enqueue(jrdev, desc, aead_encrypt_done, req);
 	if (!ret) {
 		ret = -EINPROGRESS;
 	} else {
-		old_aead_unmap(jrdev, edesc, req);
+		aead_unmap(jrdev, edesc, req);
 		kfree(edesc);
 	}
 
@@ -2779,7 +2386,7 @@ static int ipsec_gcm_decrypt(struct aead_request *req)
 	return gcm_decrypt(req);
 }
 
-static int old_aead_decrypt(struct aead_request *req)
+static int aead_decrypt(struct aead_request *req)
 {
 	struct aead_edesc *edesc;
 	struct crypto_aead *aead = crypto_aead_reqtfm(req);
@@ -2790,20 +2397,19 @@ static int old_aead_decrypt(struct aead_request *req)
 	int ret = 0;
 
 	/* allocate extended descriptor */
-	edesc = old_aead_edesc_alloc(req, DESC_JOB_IO_LEN *
-				     CAAM_CMD_SZ, &all_contig, false);
+	edesc = aead_edesc_alloc(req, AUTHENC_DESC_JOB_IO_LEN,
+				 &all_contig, false);
 	if (IS_ERR(edesc))
 		return PTR_ERR(edesc);
 
 #ifdef DEBUG
 	print_hex_dump(KERN_ERR, "dec src@"__stringify(__LINE__)": ",
 		       DUMP_PREFIX_ADDRESS, 16, 4, sg_virt(req->src),
-		       req->cryptlen, 1);
+		       req->assoclen + req->cryptlen, 1);
 #endif
 
 	/* Create and submit job descriptor*/
-	old_init_aead_job(ctx->sh_desc_dec,
-			  ctx->sh_desc_dec_dma, edesc, req, all_contig, false);
+	init_authenc_job(req, edesc, all_contig, false);
 #ifdef DEBUG
 	print_hex_dump(KERN_ERR, "aead jobdesc@"__stringify(__LINE__)": ",
 		       DUMP_PREFIX_ADDRESS, 16, 4, edesc->hw_desc,
@@ -2811,232 +2417,29 @@ static int old_aead_decrypt(struct aead_request *req)
 #endif
 
 	desc = edesc->hw_desc;
-	ret = caam_jr_enqueue(jrdev, desc, old_aead_decrypt_done, req);
+	ret = caam_jr_enqueue(jrdev, desc, aead_decrypt_done, req);
 	if (!ret) {
 		ret = -EINPROGRESS;
 	} else {
-		old_aead_unmap(jrdev, edesc, req);
+		aead_unmap(jrdev, edesc, req);
 		kfree(edesc);
 	}
 
 	return ret;
 }
 
-/*
- * allocate and map the aead extended descriptor for aead givencrypt
- */
-static struct aead_edesc *aead_giv_edesc_alloc(struct aead_givcrypt_request
-					       *greq, int desc_bytes,
-					       u32 *contig_ptr)
-{
-	struct aead_request *req = &greq->areq;
-	struct crypto_aead *aead = crypto_aead_reqtfm(req);
-	struct caam_ctx *ctx = crypto_aead_ctx(aead);
-	struct device *jrdev = ctx->jrdev;
-	gfp_t flags = (req->base.flags & (CRYPTO_TFM_REQ_MAY_BACKLOG |
-		       CRYPTO_TFM_REQ_MAY_SLEEP)) ? GFP_KERNEL : GFP_ATOMIC;
-	int assoc_nents, src_nents, dst_nents = 0;
-	struct aead_edesc *edesc;
-	dma_addr_t iv_dma = 0;
-	int sgc;
-	u32 contig = GIV_SRC_CONTIG | GIV_DST_CONTIG;
-	int ivsize = crypto_aead_ivsize(aead);
-	bool assoc_chained = false, src_chained = false, dst_chained = false;
-	int sec4_sg_index, sec4_sg_len = 0, sec4_sg_bytes;
-	bool is_gcm = false;
-
-	assoc_nents = sg_count(req->assoc, req->assoclen, &assoc_chained);
-	src_nents = sg_count(req->src, req->cryptlen, &src_chained);
-
-	if (unlikely(req->dst != req->src))
-		dst_nents = sg_count(req->dst, req->cryptlen + ctx->authsize,
-				     &dst_chained);
-
-	sgc = dma_map_sg_chained(jrdev, req->assoc, assoc_nents ? : 1,
-				 DMA_TO_DEVICE, assoc_chained);
-	if (likely(req->src == req->dst)) {
-		sgc = dma_map_sg_chained(jrdev, req->src, src_nents ? : 1,
-					 DMA_BIDIRECTIONAL, src_chained);
-	} else {
-		sgc = dma_map_sg_chained(jrdev, req->src, src_nents ? : 1,
-					 DMA_TO_DEVICE, src_chained);
-		sgc = dma_map_sg_chained(jrdev, req->dst, dst_nents ? : 1,
-					 DMA_FROM_DEVICE, dst_chained);
-	}
-
-	iv_dma = dma_map_single(jrdev, greq->giv, ivsize, DMA_TO_DEVICE);
-	if (dma_mapping_error(jrdev, iv_dma)) {
-		dev_err(jrdev, "unable to map IV\n");
-		return ERR_PTR(-ENOMEM);
-	}
-
-	if (((ctx->class1_alg_type & OP_ALG_ALGSEL_MASK) ==
-	      OP_ALG_ALGSEL_AES) &&
-	    ((ctx->class1_alg_type & OP_ALG_AAI_MASK) == OP_ALG_AAI_GCM))
-		is_gcm = true;
-
-	/*
-	 * Check if data are contiguous.
-	 * GCM expected input sequence: IV, AAD, text
-	 * All other - expected input sequence: AAD, IV, text
-	 */
-
-	if (is_gcm) {
-		if (assoc_nents || iv_dma + ivsize !=
-		    sg_dma_address(req->assoc) || src_nents ||
-		    sg_dma_address(req->assoc) + req->assoclen !=
-		    sg_dma_address(req->src))
-			contig &= ~GIV_SRC_CONTIG;
-	} else {
-		if (assoc_nents ||
-		    sg_dma_address(req->assoc) + req->assoclen != iv_dma ||
-		    src_nents || iv_dma + ivsize != sg_dma_address(req->src))
-			contig &= ~GIV_SRC_CONTIG;
-	}
-
-	if (dst_nents || iv_dma + ivsize != sg_dma_address(req->dst))
-		contig &= ~GIV_DST_CONTIG;
-
-	if (!(contig & GIV_SRC_CONTIG)) {
-		assoc_nents = assoc_nents ? : 1;
-		src_nents = src_nents ? : 1;
-		sec4_sg_len += assoc_nents + 1 + src_nents;
-		if (req->src == req->dst &&
-		    (src_nents || iv_dma + ivsize != sg_dma_address(req->src)))
-			contig &= ~GIV_DST_CONTIG;
-	}
-
-	/*
-	 * Add new sg entries for GCM output sequence.
-	 * Expected output sequence: IV, encrypted text.
-	 */
-	if (is_gcm && req->src == req->dst && !(contig & GIV_DST_CONTIG))
-		sec4_sg_len += 1 + src_nents;
-
-	if (unlikely(req->src != req->dst)) {
-		dst_nents = dst_nents ? : 1;
-		sec4_sg_len += 1 + dst_nents;
-	}
-
-	sec4_sg_bytes = sec4_sg_len * sizeof(struct sec4_sg_entry);
-
-	/* allocate space for base edesc and hw desc commands, link tables */
-	edesc = kmalloc(sizeof(struct aead_edesc) + desc_bytes +
-			sec4_sg_bytes, GFP_DMA | flags);
-	if (!edesc) {
-		dev_err(jrdev, "could not allocate extended descriptor\n");
-		return ERR_PTR(-ENOMEM);
-	}
-
-	edesc->assoc_nents = assoc_nents;
-	edesc->assoc_chained = assoc_chained;
-	edesc->src_nents = src_nents;
-	edesc->src_chained = src_chained;
-	edesc->dst_nents = dst_nents;
-	edesc->dst_chained = dst_chained;
-	edesc->iv_dma = iv_dma;
-	edesc->sec4_sg_bytes = sec4_sg_bytes;
-	edesc->sec4_sg = (void *)edesc + sizeof(struct aead_edesc) +
-			 desc_bytes;
-	*contig_ptr = contig;
-
-	sec4_sg_index = 0;
-	if (!(contig & GIV_SRC_CONTIG)) {
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
-		sg_to_sec4_sg_last(req->src, src_nents,
-				   edesc->sec4_sg +
-				   sec4_sg_index, 0);
-		sec4_sg_index += src_nents;
-	}
-
-	if (is_gcm && req->src == req->dst && !(contig & GIV_DST_CONTIG)) {
-		dma_to_sec4_sg_one(edesc->sec4_sg + sec4_sg_index,
-				   iv_dma, ivsize, 0);
-		sec4_sg_index += 1;
-		sg_to_sec4_sg_last(req->src, src_nents,
-				   edesc->sec4_sg + sec4_sg_index, 0);
-	}
-
-	if (unlikely(req->src != req->dst && !(contig & GIV_DST_CONTIG))) {
-		dma_to_sec4_sg_one(edesc->sec4_sg + sec4_sg_index,
-				   iv_dma, ivsize, 0);
-		sec4_sg_index += 1;
-		sg_to_sec4_sg_last(req->dst, dst_nents,
-				   edesc->sec4_sg + sec4_sg_index, 0);
-	}
-	edesc->sec4_sg_dma = dma_map_single(jrdev, edesc->sec4_sg,
-					    sec4_sg_bytes, DMA_TO_DEVICE);
-	if (dma_mapping_error(jrdev, edesc->sec4_sg_dma)) {
-		dev_err(jrdev, "unable to map S/G table\n");
-		return ERR_PTR(-ENOMEM);
-	}
-
-	return edesc;
-}
-
-static int old_aead_givencrypt(struct aead_givcrypt_request *areq)
+static int aead_givdecrypt(struct aead_request *req)
 {
-	struct aead_request *req = &areq->areq;
-	struct aead_edesc *edesc;
 	struct crypto_aead *aead = crypto_aead_reqtfm(req);
-	struct caam_ctx *ctx = crypto_aead_ctx(aead);
-	struct device *jrdev = ctx->jrdev;
-	u32 contig;
-	u32 *desc;
-	int ret = 0;
-
-	/* allocate extended descriptor */
-	edesc = aead_giv_edesc_alloc(areq, DESC_JOB_IO_LEN *
-				     CAAM_CMD_SZ, &contig);
-
-	if (IS_ERR(edesc))
-		return PTR_ERR(edesc);
-
-#ifdef DEBUG
-	print_hex_dump(KERN_ERR, "giv src@"__stringify(__LINE__)": ",
-		       DUMP_PREFIX_ADDRESS, 16, 4, sg_virt(req->src),
-		       req->cryptlen, 1);
-#endif
-
-	/* Create and submit job descriptor*/
-	init_aead_giv_job(ctx->sh_desc_givenc,
-			  ctx->sh_desc_givenc_dma, edesc, req, contig);
-#ifdef DEBUG
-	print_hex_dump(KERN_ERR, "aead jobdesc@"__stringify(__LINE__)": ",
-		       DUMP_PREFIX_ADDRESS, 16, 4, edesc->hw_desc,
-		       desc_bytes(edesc->hw_desc), 1);
-#endif
+	unsigned int ivsize = crypto_aead_ivsize(aead);
 
-	desc = edesc->hw_desc;
-	ret = caam_jr_enqueue(jrdev, desc, old_aead_encrypt_done, req);
-	if (!ret) {
-		ret = -EINPROGRESS;
-	} else {
-		old_aead_unmap(jrdev, edesc, req);
-		kfree(edesc);
-	}
+	if (req->cryptlen < ivsize)
+		return -EINVAL;
 
-	return ret;
-}
+	req->cryptlen -= ivsize;
+	req->assoclen += ivsize;
 
-static int aead_null_givencrypt(struct aead_givcrypt_request *areq)
-{
-	return old_aead_encrypt(&areq->areq);
+	return aead_decrypt(req);
 }
 
 /*
@@ -3369,7 +2772,6 @@ struct caam_alg_template {
 	u32 type;
 	union {
 		struct ablkcipher_alg ablkcipher;
-		struct old_aead_alg aead;
 	} template_u;
 	u32 class1_alg_type;
 	u32 class2_alg_type;
@@ -3377,753 +2779,1426 @@ struct caam_alg_template {
 };
 
 static struct caam_alg_template driver_algs[] = {
-	/* single-pass ipsec_esp descriptor */
-	{
-		.name = "authenc(hmac(md5),ecb(cipher_null))",
-		.driver_name = "authenc-hmac-md5-ecb-cipher_null-caam",
-		.blocksize = NULL_BLOCK_SIZE,
-		.type = CRYPTO_ALG_TYPE_AEAD,
-		.template_aead = {
-			.setkey = aead_setkey,
-			.setauthsize = aead_setauthsize,
-			.encrypt = old_aead_encrypt,
-			.decrypt = old_aead_decrypt,
-			.givencrypt = aead_null_givencrypt,
-			.geniv = "<built-in>",
-			.ivsize = NULL_IV_SIZE,
-			.maxauthsize = MD5_DIGEST_SIZE,
-			},
-		.class1_alg_type = 0,
-		.class2_alg_type = OP_ALG_ALGSEL_MD5 | OP_ALG_AAI_HMAC_PRECOMP,
-		.alg_op = OP_ALG_ALGSEL_MD5 | OP_ALG_AAI_HMAC,
-	},
+	/* ablkcipher descriptor */
 	{
-		.name = "authenc(hmac(sha1),ecb(cipher_null))",
-		.driver_name = "authenc-hmac-sha1-ecb-cipher_null-caam",
-		.blocksize = NULL_BLOCK_SIZE,
-		.type = CRYPTO_ALG_TYPE_AEAD,
-		.template_aead = {
-			.setkey = aead_setkey,
-			.setauthsize = aead_setauthsize,
-			.encrypt = old_aead_encrypt,
-			.decrypt = old_aead_decrypt,
-			.givencrypt = aead_null_givencrypt,
+		.name = "cbc(aes)",
+		.driver_name = "cbc-aes-caam",
+		.blocksize = AES_BLOCK_SIZE,
+		.type = CRYPTO_ALG_TYPE_GIVCIPHER,
+		.template_ablkcipher = {
+			.setkey = ablkcipher_setkey,
+			.encrypt = ablkcipher_encrypt,
+			.decrypt = ablkcipher_decrypt,
+			.givencrypt = ablkcipher_givencrypt,
+			.geniv = "<built-in>",
+			.min_keysize = AES_MIN_KEY_SIZE,
+			.max_keysize = AES_MAX_KEY_SIZE,
+			.ivsize = AES_BLOCK_SIZE,
+			},
+		.class1_alg_type = OP_ALG_ALGSEL_AES | OP_ALG_AAI_CBC,
+	},
+	{
+		.name = "cbc(des3_ede)",
+		.driver_name = "cbc-3des-caam",
+		.blocksize = DES3_EDE_BLOCK_SIZE,
+		.type = CRYPTO_ALG_TYPE_GIVCIPHER,
+		.template_ablkcipher = {
+			.setkey = ablkcipher_setkey,
+			.encrypt = ablkcipher_encrypt,
+			.decrypt = ablkcipher_decrypt,
+			.givencrypt = ablkcipher_givencrypt,
+			.geniv = "<built-in>",
+			.min_keysize = DES3_EDE_KEY_SIZE,
+			.max_keysize = DES3_EDE_KEY_SIZE,
+			.ivsize = DES3_EDE_BLOCK_SIZE,
+			},
+		.class1_alg_type = OP_ALG_ALGSEL_3DES | OP_ALG_AAI_CBC,
+	},
+	{
+		.name = "cbc(des)",
+		.driver_name = "cbc-des-caam",
+		.blocksize = DES_BLOCK_SIZE,
+		.type = CRYPTO_ALG_TYPE_GIVCIPHER,
+		.template_ablkcipher = {
+			.setkey = ablkcipher_setkey,
+			.encrypt = ablkcipher_encrypt,
+			.decrypt = ablkcipher_decrypt,
+			.givencrypt = ablkcipher_givencrypt,
+			.geniv = "<built-in>",
+			.min_keysize = DES_KEY_SIZE,
+			.max_keysize = DES_KEY_SIZE,
+			.ivsize = DES_BLOCK_SIZE,
+			},
+		.class1_alg_type = OP_ALG_ALGSEL_DES | OP_ALG_AAI_CBC,
+	},
+	{
+		.name = "ctr(aes)",
+		.driver_name = "ctr-aes-caam",
+		.blocksize = 1,
+		.type = CRYPTO_ALG_TYPE_ABLKCIPHER,
+		.template_ablkcipher = {
+			.setkey = ablkcipher_setkey,
+			.encrypt = ablkcipher_encrypt,
+			.decrypt = ablkcipher_decrypt,
+			.geniv = "chainiv",
+			.min_keysize = AES_MIN_KEY_SIZE,
+			.max_keysize = AES_MAX_KEY_SIZE,
+			.ivsize = AES_BLOCK_SIZE,
+			},
+		.class1_alg_type = OP_ALG_ALGSEL_AES | OP_ALG_AAI_CTR_MOD128,
+	},
+	{
+		.name = "rfc3686(ctr(aes))",
+		.driver_name = "rfc3686-ctr-aes-caam",
+		.blocksize = 1,
+		.type = CRYPTO_ALG_TYPE_GIVCIPHER,
+		.template_ablkcipher = {
+			.setkey = ablkcipher_setkey,
+			.encrypt = ablkcipher_encrypt,
+			.decrypt = ablkcipher_decrypt,
+			.givencrypt = ablkcipher_givencrypt,
 			.geniv = "<built-in>",
+			.min_keysize = AES_MIN_KEY_SIZE +
+				       CTR_RFC3686_NONCE_SIZE,
+			.max_keysize = AES_MAX_KEY_SIZE +
+				       CTR_RFC3686_NONCE_SIZE,
+			.ivsize = CTR_RFC3686_IV_SIZE,
+			},
+		.class1_alg_type = OP_ALG_ALGSEL_AES | OP_ALG_AAI_CTR_MOD128,
+	}
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
+			.encrypt = ipsec_gcm_encrypt,
+			.decrypt = ipsec_gcm_decrypt,
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
+			.encrypt = ipsec_gcm_encrypt,
+			.decrypt = ipsec_gcm_decrypt,
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
+	/* single-pass ipsec_esp descriptor */
+	{
+		.aead = {
+			.base = {
+				.cra_name = "authenc(hmac(md5),"
+					    "ecb(cipher_null))",
+				.cra_driver_name = "authenc-hmac-md5-"
+						   "ecb-cipher_null-caam",
+				.cra_blocksize = NULL_BLOCK_SIZE,
+			},
+			.setkey = aead_setkey,
+			.setauthsize = aead_setauthsize,
+			.encrypt = aead_encrypt,
+			.decrypt = aead_decrypt,
 			.ivsize = NULL_IV_SIZE,
-			.maxauthsize = SHA1_DIGEST_SIZE,
+			.maxauthsize = MD5_DIGEST_SIZE,
+		},
+		.caam = {
+			.class2_alg_type = OP_ALG_ALGSEL_MD5 |
+					   OP_ALG_AAI_HMAC_PRECOMP,
+			.alg_op = OP_ALG_ALGSEL_MD5 | OP_ALG_AAI_HMAC,
+		},
+	},
+	{
+		.aead = {
+			.base = {
+				.cra_name = "authenc(hmac(sha1),"
+					    "ecb(cipher_null))",
+				.cra_driver_name = "authenc-hmac-sha1-"
+						   "ecb-cipher_null-caam",
+				.cra_blocksize = NULL_BLOCK_SIZE,
 			},
-		.class1_alg_type = 0,
-		.class2_alg_type = OP_ALG_ALGSEL_SHA1 | OP_ALG_AAI_HMAC_PRECOMP,
-		.alg_op = OP_ALG_ALGSEL_SHA1 | OP_ALG_AAI_HMAC,
+			.setkey = aead_setkey,
+			.setauthsize = aead_setauthsize,
+			.encrypt = aead_encrypt,
+			.decrypt = aead_decrypt,
+			.ivsize = NULL_IV_SIZE,
+			.maxauthsize = SHA1_DIGEST_SIZE,
+		},
+		.caam = {
+			.class2_alg_type = OP_ALG_ALGSEL_SHA1 |
+					   OP_ALG_AAI_HMAC_PRECOMP,
+			.alg_op = OP_ALG_ALGSEL_SHA1 | OP_ALG_AAI_HMAC,
+		},
 	},
 	{
-		.name = "authenc(hmac(sha224),ecb(cipher_null))",
-		.driver_name = "authenc-hmac-sha224-ecb-cipher_null-caam",
-		.blocksize = NULL_BLOCK_SIZE,
-		.type = CRYPTO_ALG_TYPE_AEAD,
-		.template_aead = {
+		.aead = {
+			.base = {
+				.cra_name = "authenc(hmac(sha224),"
+					    "ecb(cipher_null))",
+				.cra_driver_name = "authenc-hmac-sha224-"
+						   "ecb-cipher_null-caam",
+				.cra_blocksize = NULL_BLOCK_SIZE,
+			},
 			.setkey = aead_setkey,
 			.setauthsize = aead_setauthsize,
-			.encrypt = old_aead_encrypt,
-			.decrypt = old_aead_decrypt,
-			.givencrypt = aead_null_givencrypt,
-			.geniv = "<built-in>",
+			.encrypt = aead_encrypt,
+			.decrypt = aead_decrypt,
 			.ivsize = NULL_IV_SIZE,
 			.maxauthsize = SHA224_DIGEST_SIZE,
-			},
-		.class1_alg_type = 0,
-		.class2_alg_type = OP_ALG_ALGSEL_SHA224 |
-				   OP_ALG_AAI_HMAC_PRECOMP,
-		.alg_op = OP_ALG_ALGSEL_SHA224 | OP_ALG_AAI_HMAC,
+		},
+		.caam = {
+			.class2_alg_type = OP_ALG_ALGSEL_SHA224 |
+					   OP_ALG_AAI_HMAC_PRECOMP,
+			.alg_op = OP_ALG_ALGSEL_SHA224 | OP_ALG_AAI_HMAC,
+		},
 	},
 	{
-		.name = "authenc(hmac(sha256),ecb(cipher_null))",
-		.driver_name = "authenc-hmac-sha256-ecb-cipher_null-caam",
-		.blocksize = NULL_BLOCK_SIZE,
-		.type = CRYPTO_ALG_TYPE_AEAD,
-		.template_aead = {
+		.aead = {
+			.base = {
+				.cra_name = "authenc(hmac(sha256),"
+					    "ecb(cipher_null))",
+				.cra_driver_name = "authenc-hmac-sha256-"
+						   "ecb-cipher_null-caam",
+				.cra_blocksize = NULL_BLOCK_SIZE,
+			},
 			.setkey = aead_setkey,
 			.setauthsize = aead_setauthsize,
-			.encrypt = old_aead_encrypt,
-			.decrypt = old_aead_decrypt,
-			.givencrypt = aead_null_givencrypt,
-			.geniv = "<built-in>",
+			.encrypt = aead_encrypt,
+			.decrypt = aead_decrypt,
 			.ivsize = NULL_IV_SIZE,
 			.maxauthsize = SHA256_DIGEST_SIZE,
-			},
-		.class1_alg_type = 0,
-		.class2_alg_type = OP_ALG_ALGSEL_SHA256 |
-				   OP_ALG_AAI_HMAC_PRECOMP,
-		.alg_op = OP_ALG_ALGSEL_SHA256 | OP_ALG_AAI_HMAC,
+		},
+		.caam = {
+			.class2_alg_type = OP_ALG_ALGSEL_SHA256 |
+					   OP_ALG_AAI_HMAC_PRECOMP,
+			.alg_op = OP_ALG_ALGSEL_SHA256 | OP_ALG_AAI_HMAC,
+		},
 	},
 	{
-		.name = "authenc(hmac(sha384),ecb(cipher_null))",
-		.driver_name = "authenc-hmac-sha384-ecb-cipher_null-caam",
-		.blocksize = NULL_BLOCK_SIZE,
-		.type = CRYPTO_ALG_TYPE_AEAD,
-		.template_aead = {
+		.aead = {
+			.base = {
+				.cra_name = "authenc(hmac(sha384),"
+					    "ecb(cipher_null))",
+				.cra_driver_name = "authenc-hmac-sha384-"
+						   "ecb-cipher_null-caam",
+				.cra_blocksize = NULL_BLOCK_SIZE,
+			},
 			.setkey = aead_setkey,
 			.setauthsize = aead_setauthsize,
-			.encrypt = old_aead_encrypt,
-			.decrypt = old_aead_decrypt,
-			.givencrypt = aead_null_givencrypt,
-			.geniv = "<built-in>",
+			.encrypt = aead_encrypt,
+			.decrypt = aead_decrypt,
 			.ivsize = NULL_IV_SIZE,
 			.maxauthsize = SHA384_DIGEST_SIZE,
-			},
-		.class1_alg_type = 0,
-		.class2_alg_type = OP_ALG_ALGSEL_SHA384 |
-				   OP_ALG_AAI_HMAC_PRECOMP,
-		.alg_op = OP_ALG_ALGSEL_SHA384 | OP_ALG_AAI_HMAC,
+		},
+		.caam = {
+			.class2_alg_type = OP_ALG_ALGSEL_SHA384 |
+					   OP_ALG_AAI_HMAC_PRECOMP,
+			.alg_op = OP_ALG_ALGSEL_SHA384 | OP_ALG_AAI_HMAC,
+		},
 	},
 	{
-		.name = "authenc(hmac(sha512),ecb(cipher_null))",
-		.driver_name = "authenc-hmac-sha512-ecb-cipher_null-caam",
-		.blocksize = NULL_BLOCK_SIZE,
-		.type = CRYPTO_ALG_TYPE_AEAD,
-		.template_aead = {
+		.aead = {
+			.base = {
+				.cra_name = "authenc(hmac(sha512),"
+					    "ecb(cipher_null))",
+				.cra_driver_name = "authenc-hmac-sha512-"
+						   "ecb-cipher_null-caam",
+				.cra_blocksize = NULL_BLOCK_SIZE,
+			},
 			.setkey = aead_setkey,
 			.setauthsize = aead_setauthsize,
-			.encrypt = old_aead_encrypt,
-			.decrypt = old_aead_decrypt,
-			.givencrypt = aead_null_givencrypt,
-			.geniv = "<built-in>",
+			.encrypt = aead_encrypt,
+			.decrypt = aead_decrypt,
 			.ivsize = NULL_IV_SIZE,
 			.maxauthsize = SHA512_DIGEST_SIZE,
+		},
+		.caam = {
+			.class2_alg_type = OP_ALG_ALGSEL_SHA512 |
+					   OP_ALG_AAI_HMAC_PRECOMP,
+			.alg_op = OP_ALG_ALGSEL_SHA512 | OP_ALG_AAI_HMAC,
+		},
+	},
+	{
+		.aead = {
+			.base = {
+				.cra_name = "authenc(hmac(md5),cbc(aes))",
+				.cra_driver_name = "authenc-hmac-md5-"
+						   "cbc-aes-caam",
+				.cra_blocksize = AES_BLOCK_SIZE,
 			},
-		.class1_alg_type = 0,
-		.class2_alg_type = OP_ALG_ALGSEL_SHA512 |
-				   OP_ALG_AAI_HMAC_PRECOMP,
-		.alg_op = OP_ALG_ALGSEL_SHA512 | OP_ALG_AAI_HMAC,
+			.setkey = aead_setkey,
+			.setauthsize = aead_setauthsize,
+			.encrypt = aead_encrypt,
+			.decrypt = aead_decrypt,
+			.ivsize = AES_BLOCK_SIZE,
+			.maxauthsize = MD5_DIGEST_SIZE,
+		},
+		.caam = {
+			.class1_alg_type = OP_ALG_ALGSEL_AES | OP_ALG_AAI_CBC,
+			.class2_alg_type = OP_ALG_ALGSEL_MD5 |
+					   OP_ALG_AAI_HMAC_PRECOMP,
+			.alg_op = OP_ALG_ALGSEL_MD5 | OP_ALG_AAI_HMAC,
+		},
 	},
 	{
-		.name = "authenc(hmac(md5),cbc(aes))",
-		.driver_name = "authenc-hmac-md5-cbc-aes-caam",
-		.blocksize = AES_BLOCK_SIZE,
-		.type = CRYPTO_ALG_TYPE_AEAD,
-		.template_aead = {
+		.aead = {
+			.base = {
+				.cra_name = "echainiv(authenc(hmac(md5),"
+					    "cbc(aes)))",
+				.cra_driver_name = "echainiv-authenc-hmac-md5-"
+						   "cbc-aes-caam",
+				.cra_blocksize = AES_BLOCK_SIZE,
+			},
 			.setkey = aead_setkey,
 			.setauthsize = aead_setauthsize,
-			.encrypt = old_aead_encrypt,
-			.decrypt = old_aead_decrypt,
-			.givencrypt = old_aead_givencrypt,
-			.geniv = "<built-in>",
+			.encrypt = aead_encrypt,
+			.decrypt = aead_givdecrypt,
 			.ivsize = AES_BLOCK_SIZE,
 			.maxauthsize = MD5_DIGEST_SIZE,
+		},
+		.caam = {
+			.class1_alg_type = OP_ALG_ALGSEL_AES | OP_ALG_AAI_CBC,
+			.class2_alg_type = OP_ALG_ALGSEL_MD5 |
+					   OP_ALG_AAI_HMAC_PRECOMP,
+			.alg_op = OP_ALG_ALGSEL_MD5 | OP_ALG_AAI_HMAC,
+			.geniv = true,
+		},
+	},
+	{
+		.aead = {
+			.base = {
+				.cra_name = "authenc(hmac(sha1),cbc(aes))",
+				.cra_driver_name = "authenc-hmac-sha1-"
+						   "cbc-aes-caam",
+				.cra_blocksize = AES_BLOCK_SIZE,
 			},
-		.class1_alg_type = OP_ALG_ALGSEL_AES | OP_ALG_AAI_CBC,
-		.class2_alg_type = OP_ALG_ALGSEL_MD5 | OP_ALG_AAI_HMAC_PRECOMP,
-		.alg_op = OP_ALG_ALGSEL_MD5 | OP_ALG_AAI_HMAC,
+			.setkey = aead_setkey,
+			.setauthsize = aead_setauthsize,
+			.encrypt = aead_encrypt,
+			.decrypt = aead_decrypt,
+			.ivsize = AES_BLOCK_SIZE,
+			.maxauthsize = SHA1_DIGEST_SIZE,
+		},
+		.caam = {
+			.class1_alg_type = OP_ALG_ALGSEL_AES | OP_ALG_AAI_CBC,
+			.class2_alg_type = OP_ALG_ALGSEL_SHA1 |
+					   OP_ALG_AAI_HMAC_PRECOMP,
+			.alg_op = OP_ALG_ALGSEL_SHA1 | OP_ALG_AAI_HMAC,
+		},
 	},
 	{
-		.name = "authenc(hmac(sha1),cbc(aes))",
-		.driver_name = "authenc-hmac-sha1-cbc-aes-caam",
-		.blocksize = AES_BLOCK_SIZE,
-		.type = CRYPTO_ALG_TYPE_AEAD,
-		.template_aead = {
+		.aead = {
+			.base = {
+				.cra_name = "echainiv(authenc(hmac(sha1),"
+					    "cbc(aes)))",
+				.cra_driver_name = "echainiv-authenc-"
+						   "hmac-sha1-cbc-aes-caam",
+				.cra_blocksize = AES_BLOCK_SIZE,
+			},
 			.setkey = aead_setkey,
 			.setauthsize = aead_setauthsize,
-			.encrypt = old_aead_encrypt,
-			.decrypt = old_aead_decrypt,
-			.givencrypt = old_aead_givencrypt,
-			.geniv = "<built-in>",
+			.encrypt = aead_encrypt,
+			.decrypt = aead_givdecrypt,
 			.ivsize = AES_BLOCK_SIZE,
 			.maxauthsize = SHA1_DIGEST_SIZE,
+		},
+		.caam = {
+			.class1_alg_type = OP_ALG_ALGSEL_AES | OP_ALG_AAI_CBC,
+			.class2_alg_type = OP_ALG_ALGSEL_SHA1 |
+					   OP_ALG_AAI_HMAC_PRECOMP,
+			.alg_op = OP_ALG_ALGSEL_SHA1 | OP_ALG_AAI_HMAC,
+			.geniv = true,
+		},
+	},
+	{
+		.aead = {
+			.base = {
+				.cra_name = "authenc(hmac(sha224),cbc(aes))",
+				.cra_driver_name = "authenc-hmac-sha224-"
+						   "cbc-aes-caam",
+				.cra_blocksize = AES_BLOCK_SIZE,
 			},
-		.class1_alg_type = OP_ALG_ALGSEL_AES | OP_ALG_AAI_CBC,
-		.class2_alg_type = OP_ALG_ALGSEL_SHA1 | OP_ALG_AAI_HMAC_PRECOMP,
-		.alg_op = OP_ALG_ALGSEL_SHA1 | OP_ALG_AAI_HMAC,
+			.setkey = aead_setkey,
+			.setauthsize = aead_setauthsize,
+			.encrypt = aead_encrypt,
+			.decrypt = aead_decrypt,
+			.ivsize = AES_BLOCK_SIZE,
+			.maxauthsize = SHA224_DIGEST_SIZE,
+		},
+		.caam = {
+			.class1_alg_type = OP_ALG_ALGSEL_AES | OP_ALG_AAI_CBC,
+			.class2_alg_type = OP_ALG_ALGSEL_SHA224 |
+					   OP_ALG_AAI_HMAC_PRECOMP,
+			.alg_op = OP_ALG_ALGSEL_SHA224 | OP_ALG_AAI_HMAC,
+		},
 	},
 	{
-		.name = "authenc(hmac(sha224),cbc(aes))",
-		.driver_name = "authenc-hmac-sha224-cbc-aes-caam",
-		.blocksize = AES_BLOCK_SIZE,
-		.type = CRYPTO_ALG_TYPE_AEAD,
-		.template_aead = {
+		.aead = {
+			.base = {
+				.cra_name = "echainiv(authenc(hmac(sha224),"
+					    "cbc(aes)))",
+				.cra_driver_name = "echainiv-authenc-"
+						   "hmac-sha224-cbc-aes-caam",
+				.cra_blocksize = AES_BLOCK_SIZE,
+			},
 			.setkey = aead_setkey,
 			.setauthsize = aead_setauthsize,
-			.encrypt = old_aead_encrypt,
-			.decrypt = old_aead_decrypt,
-			.givencrypt = old_aead_givencrypt,
-			.geniv = "<built-in>",
+			.encrypt = aead_encrypt,
+			.decrypt = aead_givdecrypt,
 			.ivsize = AES_BLOCK_SIZE,
 			.maxauthsize = SHA224_DIGEST_SIZE,
+		},
+		.caam = {
+			.class1_alg_type = OP_ALG_ALGSEL_AES | OP_ALG_AAI_CBC,
+			.class2_alg_type = OP_ALG_ALGSEL_SHA224 |
+					   OP_ALG_AAI_HMAC_PRECOMP,
+			.alg_op = OP_ALG_ALGSEL_SHA224 | OP_ALG_AAI_HMAC,
+			.geniv = true,
+		},
+	},
+	{
+		.aead = {
+			.base = {
+				.cra_name = "authenc(hmac(sha256),cbc(aes))",
+				.cra_driver_name = "authenc-hmac-sha256-"
+						   "cbc-aes-caam",
+				.cra_blocksize = AES_BLOCK_SIZE,
 			},
-		.class1_alg_type = OP_ALG_ALGSEL_AES | OP_ALG_AAI_CBC,
-		.class2_alg_type = OP_ALG_ALGSEL_SHA224 |
-				   OP_ALG_AAI_HMAC_PRECOMP,
-		.alg_op = OP_ALG_ALGSEL_SHA224 | OP_ALG_AAI_HMAC,
+			.setkey = aead_setkey,
+			.setauthsize = aead_setauthsize,
+			.encrypt = aead_encrypt,
+			.decrypt = aead_decrypt,
+			.ivsize = AES_BLOCK_SIZE,
+			.maxauthsize = SHA256_DIGEST_SIZE,
+		},
+		.caam = {
+			.class1_alg_type = OP_ALG_ALGSEL_AES | OP_ALG_AAI_CBC,
+			.class2_alg_type = OP_ALG_ALGSEL_SHA256 |
+					   OP_ALG_AAI_HMAC_PRECOMP,
+			.alg_op = OP_ALG_ALGSEL_SHA256 | OP_ALG_AAI_HMAC,
+		},
 	},
 	{
-		.name = "authenc(hmac(sha256),cbc(aes))",
-		.driver_name = "authenc-hmac-sha256-cbc-aes-caam",
-		.blocksize = AES_BLOCK_SIZE,
-		.type = CRYPTO_ALG_TYPE_AEAD,
-		.template_aead = {
+		.aead = {
+			.base = {
+				.cra_name = "echainiv(authenc(hmac(sha256),"
+					    "cbc(aes)))",
+				.cra_driver_name = "echainiv-authenc-"
+						   "hmac-sha256-cbc-aes-caam",
+				.cra_blocksize = AES_BLOCK_SIZE,
+			},
+			.setkey = aead_setkey,
+			.setauthsize = aead_setauthsize,
+			.encrypt = aead_encrypt,
+			.decrypt = aead_givdecrypt,
+			.ivsize = AES_BLOCK_SIZE,
+			.maxauthsize = SHA256_DIGEST_SIZE,
+		},
+		.caam = {
+			.class1_alg_type = OP_ALG_ALGSEL_AES | OP_ALG_AAI_CBC,
+			.class2_alg_type = OP_ALG_ALGSEL_SHA256 |
+					   OP_ALG_AAI_HMAC_PRECOMP,
+			.alg_op = OP_ALG_ALGSEL_SHA256 | OP_ALG_AAI_HMAC,
+			.geniv = true,
+		},
+	},
+	{
+		.aead = {
+			.base = {
+				.cra_name = "authenc(hmac(sha384),cbc(aes))",
+				.cra_driver_name = "authenc-hmac-sha384-"
+						   "cbc-aes-caam",
+				.cra_blocksize = AES_BLOCK_SIZE,
+			},
+			.setkey = aead_setkey,
+			.setauthsize = aead_setauthsize,
+			.encrypt = aead_encrypt,
+			.decrypt = aead_decrypt,
+			.ivsize = AES_BLOCK_SIZE,
+			.maxauthsize = SHA384_DIGEST_SIZE,
+		},
+		.caam = {
+			.class1_alg_type = OP_ALG_ALGSEL_AES | OP_ALG_AAI_CBC,
+			.class2_alg_type = OP_ALG_ALGSEL_SHA384 |
+					   OP_ALG_AAI_HMAC_PRECOMP,
+			.alg_op = OP_ALG_ALGSEL_SHA384 | OP_ALG_AAI_HMAC,
+		},
+	},
+	{
+		.aead = {
+			.base = {
+				.cra_name = "echainiv(authenc(hmac(sha384),"
+					    "cbc(aes)))",
+				.cra_driver_name = "echainiv-authenc-"
+						   "hmac-sha384-cbc-aes-caam",
+				.cra_blocksize = AES_BLOCK_SIZE,
+			},
 			.setkey = aead_setkey,
 			.setauthsize = aead_setauthsize,
-			.encrypt = old_aead_encrypt,
-			.decrypt = old_aead_decrypt,
-			.givencrypt = old_aead_givencrypt,
-			.geniv = "<built-in>",
+			.encrypt = aead_encrypt,
+			.decrypt = aead_givdecrypt,
 			.ivsize = AES_BLOCK_SIZE,
-			.maxauthsize = SHA256_DIGEST_SIZE,
-			},
-		.class1_alg_type = OP_ALG_ALGSEL_AES | OP_ALG_AAI_CBC,
-		.class2_alg_type = OP_ALG_ALGSEL_SHA256 |
-				   OP_ALG_AAI_HMAC_PRECOMP,
-		.alg_op = OP_ALG_ALGSEL_SHA256 | OP_ALG_AAI_HMAC,
+			.maxauthsize = SHA384_DIGEST_SIZE,
+		},
+		.caam = {
+			.class1_alg_type = OP_ALG_ALGSEL_AES | OP_ALG_AAI_CBC,
+			.class2_alg_type = OP_ALG_ALGSEL_SHA384 |
+					   OP_ALG_AAI_HMAC_PRECOMP,
+			.alg_op = OP_ALG_ALGSEL_SHA384 | OP_ALG_AAI_HMAC,
+			.geniv = true,
+		},
 	},
 	{
-		.name = "authenc(hmac(sha384),cbc(aes))",
-		.driver_name = "authenc-hmac-sha384-cbc-aes-caam",
-		.blocksize = AES_BLOCK_SIZE,
-		.type = CRYPTO_ALG_TYPE_AEAD,
-		.template_aead = {
+		.aead = {
+			.base = {
+				.cra_name = "authenc(hmac(sha512),cbc(aes))",
+				.cra_driver_name = "authenc-hmac-sha512-"
+						   "cbc-aes-caam",
+				.cra_blocksize = AES_BLOCK_SIZE,
+			},
 			.setkey = aead_setkey,
 			.setauthsize = aead_setauthsize,
-			.encrypt = old_aead_encrypt,
-			.decrypt = old_aead_decrypt,
-			.givencrypt = old_aead_givencrypt,
-			.geniv = "<built-in>",
+			.encrypt = aead_encrypt,
+			.decrypt = aead_decrypt,
 			.ivsize = AES_BLOCK_SIZE,
-			.maxauthsize = SHA384_DIGEST_SIZE,
-			},
-		.class1_alg_type = OP_ALG_ALGSEL_AES | OP_ALG_AAI_CBC,
-		.class2_alg_type = OP_ALG_ALGSEL_SHA384 |
-				   OP_ALG_AAI_HMAC_PRECOMP,
-		.alg_op = OP_ALG_ALGSEL_SHA384 | OP_ALG_AAI_HMAC,
+			.maxauthsize = SHA512_DIGEST_SIZE,
+		},
+		.caam = {
+			.class1_alg_type = OP_ALG_ALGSEL_AES | OP_ALG_AAI_CBC,
+			.class2_alg_type = OP_ALG_ALGSEL_SHA512 |
+					   OP_ALG_AAI_HMAC_PRECOMP,
+			.alg_op = OP_ALG_ALGSEL_SHA512 | OP_ALG_AAI_HMAC,
+		},
 	},
-
 	{
-		.name = "authenc(hmac(sha512),cbc(aes))",
-		.driver_name = "authenc-hmac-sha512-cbc-aes-caam",
-		.blocksize = AES_BLOCK_SIZE,
-		.type = CRYPTO_ALG_TYPE_AEAD,
-		.template_aead = {
+		.aead = {
+			.base = {
+				.cra_name = "echainiv(authenc(hmac(sha512),"
+					    "cbc(aes)))",
+				.cra_driver_name = "echainiv-authenc-"
+						   "hmac-sha512-cbc-aes-caam",
+				.cra_blocksize = AES_BLOCK_SIZE,
+			},
 			.setkey = aead_setkey,
 			.setauthsize = aead_setauthsize,
-			.encrypt = old_aead_encrypt,
-			.decrypt = old_aead_decrypt,
-			.givencrypt = old_aead_givencrypt,
-			.geniv = "<built-in>",
+			.encrypt = aead_encrypt,
+			.decrypt = aead_givdecrypt,
 			.ivsize = AES_BLOCK_SIZE,
 			.maxauthsize = SHA512_DIGEST_SIZE,
+		},
+		.caam = {
+			.class1_alg_type = OP_ALG_ALGSEL_AES | OP_ALG_AAI_CBC,
+			.class2_alg_type = OP_ALG_ALGSEL_SHA512 |
+					   OP_ALG_AAI_HMAC_PRECOMP,
+			.alg_op = OP_ALG_ALGSEL_SHA512 | OP_ALG_AAI_HMAC,
+			.geniv = true,
+		},
+	},
+	{
+		.aead = {
+			.base = {
+				.cra_name = "authenc(hmac(md5),cbc(des3_ede))",
+				.cra_driver_name = "authenc-hmac-md5-"
+						   "cbc-des3_ede-caam",
+				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 			},
-		.class1_alg_type = OP_ALG_ALGSEL_AES | OP_ALG_AAI_CBC,
-		.class2_alg_type = OP_ALG_ALGSEL_SHA512 |
-				   OP_ALG_AAI_HMAC_PRECOMP,
-		.alg_op = OP_ALG_ALGSEL_SHA512 | OP_ALG_AAI_HMAC,
+			.setkey = aead_setkey,
+			.setauthsize = aead_setauthsize,
+			.encrypt = aead_encrypt,
+			.decrypt = aead_decrypt,
+			.ivsize = DES3_EDE_BLOCK_SIZE,
+			.maxauthsize = MD5_DIGEST_SIZE,
+		},
+		.caam = {
+			.class1_alg_type = OP_ALG_ALGSEL_3DES | OP_ALG_AAI_CBC,
+			.class2_alg_type = OP_ALG_ALGSEL_MD5 |
+					   OP_ALG_AAI_HMAC_PRECOMP,
+			.alg_op = OP_ALG_ALGSEL_MD5 | OP_ALG_AAI_HMAC,
+		}
 	},
 	{
-		.name = "authenc(hmac(md5),cbc(des3_ede))",
-		.driver_name = "authenc-hmac-md5-cbc-des3_ede-caam",
-		.blocksize = DES3_EDE_BLOCK_SIZE,
-		.type = CRYPTO_ALG_TYPE_AEAD,
-		.template_aead = {
+		.aead = {
+			.base = {
+				.cra_name = "echainiv(authenc(hmac(md5),"
+					    "cbc(des3_ede)))",
+				.cra_driver_name = "echainiv-authenc-hmac-md5-"
+						   "cbc-des3_ede-caam",
+				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
+			},
 			.setkey = aead_setkey,
 			.setauthsize = aead_setauthsize,
-			.encrypt = old_aead_encrypt,
-			.decrypt = old_aead_decrypt,
-			.givencrypt = old_aead_givencrypt,
-			.geniv = "<built-in>",
+			.encrypt = aead_encrypt,
+			.decrypt = aead_givdecrypt,
 			.ivsize = DES3_EDE_BLOCK_SIZE,
 			.maxauthsize = MD5_DIGEST_SIZE,
+		},
+		.caam = {
+			.class1_alg_type = OP_ALG_ALGSEL_3DES | OP_ALG_AAI_CBC,
+			.class2_alg_type = OP_ALG_ALGSEL_MD5 |
+					   OP_ALG_AAI_HMAC_PRECOMP,
+			.alg_op = OP_ALG_ALGSEL_MD5 | OP_ALG_AAI_HMAC,
+			.geniv = true,
+		}
+	},
+	{
+		.aead = {
+			.base = {
+				.cra_name = "authenc(hmac(sha1),"
+					    "cbc(des3_ede))",
+				.cra_driver_name = "authenc-hmac-sha1-"
+						   "cbc-des3_ede-caam",
+				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 			},
-		.class1_alg_type = OP_ALG_ALGSEL_3DES | OP_ALG_AAI_CBC,
-		.class2_alg_type = OP_ALG_ALGSEL_MD5 | OP_ALG_AAI_HMAC_PRECOMP,
-		.alg_op = OP_ALG_ALGSEL_MD5 | OP_ALG_AAI_HMAC,
+			.setkey = aead_setkey,
+			.setauthsize = aead_setauthsize,
+			.encrypt = aead_encrypt,
+			.decrypt = aead_decrypt,
+			.ivsize = DES3_EDE_BLOCK_SIZE,
+			.maxauthsize = SHA1_DIGEST_SIZE,
+		},
+		.caam = {
+			.class1_alg_type = OP_ALG_ALGSEL_3DES | OP_ALG_AAI_CBC,
+			.class2_alg_type = OP_ALG_ALGSEL_SHA1 |
+					   OP_ALG_AAI_HMAC_PRECOMP,
+			.alg_op = OP_ALG_ALGSEL_SHA1 | OP_ALG_AAI_HMAC,
+		},
 	},
 	{
-		.name = "authenc(hmac(sha1),cbc(des3_ede))",
-		.driver_name = "authenc-hmac-sha1-cbc-des3_ede-caam",
-		.blocksize = DES3_EDE_BLOCK_SIZE,
-		.type = CRYPTO_ALG_TYPE_AEAD,
-		.template_aead = {
+		.aead = {
+			.base = {
+				.cra_name = "echainiv(authenc(hmac(sha1),"
+					    "cbc(des3_ede)))",
+				.cra_driver_name = "echainiv-authenc-"
+						   "hmac-sha1-"
+						   "cbc-des3_ede-caam",
+				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
+			},
 			.setkey = aead_setkey,
 			.setauthsize = aead_setauthsize,
-			.encrypt = old_aead_encrypt,
-			.decrypt = old_aead_decrypt,
-			.givencrypt = old_aead_givencrypt,
-			.geniv = "<built-in>",
+			.encrypt = aead_encrypt,
+			.decrypt = aead_givdecrypt,
 			.ivsize = DES3_EDE_BLOCK_SIZE,
 			.maxauthsize = SHA1_DIGEST_SIZE,
+		},
+		.caam = {
+			.class1_alg_type = OP_ALG_ALGSEL_3DES | OP_ALG_AAI_CBC,
+			.class2_alg_type = OP_ALG_ALGSEL_SHA1 |
+					   OP_ALG_AAI_HMAC_PRECOMP,
+			.alg_op = OP_ALG_ALGSEL_SHA1 | OP_ALG_AAI_HMAC,
+			.geniv = true,
+		},
+	},
+	{
+		.aead = {
+			.base = {
+				.cra_name = "authenc(hmac(sha224),"
+					    "cbc(des3_ede))",
+				.cra_driver_name = "authenc-hmac-sha224-"
+						   "cbc-des3_ede-caam",
+				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 			},
-		.class1_alg_type = OP_ALG_ALGSEL_3DES | OP_ALG_AAI_CBC,
-		.class2_alg_type = OP_ALG_ALGSEL_SHA1 | OP_ALG_AAI_HMAC_PRECOMP,
-		.alg_op = OP_ALG_ALGSEL_SHA1 | OP_ALG_AAI_HMAC,
+			.setkey = aead_setkey,
+			.setauthsize = aead_setauthsize,
+			.encrypt = aead_encrypt,
+			.decrypt = aead_decrypt,
+			.ivsize = DES3_EDE_BLOCK_SIZE,
+			.maxauthsize = SHA224_DIGEST_SIZE,
+		},
+		.caam = {
+			.class1_alg_type = OP_ALG_ALGSEL_3DES | OP_ALG_AAI_CBC,
+			.class2_alg_type = OP_ALG_ALGSEL_SHA224 |
+					   OP_ALG_AAI_HMAC_PRECOMP,
+			.alg_op = OP_ALG_ALGSEL_SHA224 | OP_ALG_AAI_HMAC,
+		},
 	},
 	{
-		.name = "authenc(hmac(sha224),cbc(des3_ede))",
-		.driver_name = "authenc-hmac-sha224-cbc-des3_ede-caam",
-		.blocksize = DES3_EDE_BLOCK_SIZE,
-		.type = CRYPTO_ALG_TYPE_AEAD,
-		.template_aead = {
+		.aead = {
+			.base = {
+				.cra_name = "echainiv(authenc(hmac(sha224),"
+					    "cbc(des3_ede)))",
+				.cra_driver_name = "echainiv-authenc-"
+						   "hmac-sha224-"
+						   "cbc-des3_ede-caam",
+				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
+			},
 			.setkey = aead_setkey,
 			.setauthsize = aead_setauthsize,
-			.encrypt = old_aead_encrypt,
-			.decrypt = old_aead_decrypt,
-			.givencrypt = old_aead_givencrypt,
-			.geniv = "<built-in>",
+			.encrypt = aead_encrypt,
+			.decrypt = aead_givdecrypt,
 			.ivsize = DES3_EDE_BLOCK_SIZE,
 			.maxauthsize = SHA224_DIGEST_SIZE,
+		},
+		.caam = {
+			.class1_alg_type = OP_ALG_ALGSEL_3DES | OP_ALG_AAI_CBC,
+			.class2_alg_type = OP_ALG_ALGSEL_SHA224 |
+					   OP_ALG_AAI_HMAC_PRECOMP,
+			.alg_op = OP_ALG_ALGSEL_SHA224 | OP_ALG_AAI_HMAC,
+			.geniv = true,
+		},
+	},
+	{
+		.aead = {
+			.base = {
+				.cra_name = "authenc(hmac(sha256),"
+					    "cbc(des3_ede))",
+				.cra_driver_name = "authenc-hmac-sha256-"
+						   "cbc-des3_ede-caam",
+				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 			},
-		.class1_alg_type = OP_ALG_ALGSEL_3DES | OP_ALG_AAI_CBC,
-		.class2_alg_type = OP_ALG_ALGSEL_SHA224 |
-				   OP_ALG_AAI_HMAC_PRECOMP,
-		.alg_op = OP_ALG_ALGSEL_SHA224 | OP_ALG_AAI_HMAC,
+			.setkey = aead_setkey,
+			.setauthsize = aead_setauthsize,
+			.encrypt = aead_encrypt,
+			.decrypt = aead_decrypt,
+			.ivsize = DES3_EDE_BLOCK_SIZE,
+			.maxauthsize = SHA256_DIGEST_SIZE,
+		},
+		.caam = {
+			.class1_alg_type = OP_ALG_ALGSEL_3DES | OP_ALG_AAI_CBC,
+			.class2_alg_type = OP_ALG_ALGSEL_SHA256 |
+					   OP_ALG_AAI_HMAC_PRECOMP,
+			.alg_op = OP_ALG_ALGSEL_SHA256 | OP_ALG_AAI_HMAC,
+		},
 	},
 	{
-		.name = "authenc(hmac(sha256),cbc(des3_ede))",
-		.driver_name = "authenc-hmac-sha256-cbc-des3_ede-caam",
-		.blocksize = DES3_EDE_BLOCK_SIZE,
-		.type = CRYPTO_ALG_TYPE_AEAD,
-		.template_aead = {
+		.aead = {
+			.base = {
+				.cra_name = "echainiv(authenc(hmac(sha256),"
+					    "cbc(des3_ede)))",
+				.cra_driver_name = "echainiv-authenc-"
+						   "hmac-sha256-"
+						   "cbc-des3_ede-caam",
+				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
+			},
 			.setkey = aead_setkey,
 			.setauthsize = aead_setauthsize,
-			.encrypt = old_aead_encrypt,
-			.decrypt = old_aead_decrypt,
-			.givencrypt = old_aead_givencrypt,
-			.geniv = "<built-in>",
+			.encrypt = aead_encrypt,
+			.decrypt = aead_givdecrypt,
 			.ivsize = DES3_EDE_BLOCK_SIZE,
 			.maxauthsize = SHA256_DIGEST_SIZE,
+		},
+		.caam = {
+			.class1_alg_type = OP_ALG_ALGSEL_3DES | OP_ALG_AAI_CBC,
+			.class2_alg_type = OP_ALG_ALGSEL_SHA256 |
+					   OP_ALG_AAI_HMAC_PRECOMP,
+			.alg_op = OP_ALG_ALGSEL_SHA256 | OP_ALG_AAI_HMAC,
+			.geniv = true,
+		},
+	},
+	{
+		.aead = {
+			.base = {
+				.cra_name = "authenc(hmac(sha384),"
+					    "cbc(des3_ede))",
+				.cra_driver_name = "authenc-hmac-sha384-"
+						   "cbc-des3_ede-caam",
+				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 			},
-		.class1_alg_type = OP_ALG_ALGSEL_3DES | OP_ALG_AAI_CBC,
-		.class2_alg_type = OP_ALG_ALGSEL_SHA256 |
-				   OP_ALG_AAI_HMAC_PRECOMP,
-		.alg_op = OP_ALG_ALGSEL_SHA256 | OP_ALG_AAI_HMAC,
+			.setkey = aead_setkey,
+			.setauthsize = aead_setauthsize,
+			.encrypt = aead_encrypt,
+			.decrypt = aead_decrypt,
+			.ivsize = DES3_EDE_BLOCK_SIZE,
+			.maxauthsize = SHA384_DIGEST_SIZE,
+		},
+		.caam = {
+			.class1_alg_type = OP_ALG_ALGSEL_3DES | OP_ALG_AAI_CBC,
+			.class2_alg_type = OP_ALG_ALGSEL_SHA384 |
+					   OP_ALG_AAI_HMAC_PRECOMP,
+			.alg_op = OP_ALG_ALGSEL_SHA384 | OP_ALG_AAI_HMAC,
+		},
 	},
 	{
-		.name = "authenc(hmac(sha384),cbc(des3_ede))",
-		.driver_name = "authenc-hmac-sha384-cbc-des3_ede-caam",
-		.blocksize = DES3_EDE_BLOCK_SIZE,
-		.type = CRYPTO_ALG_TYPE_AEAD,
-		.template_aead = {
+		.aead = {
+			.base = {
+				.cra_name = "echainiv(authenc(hmac(sha384),"
+					    "cbc(des3_ede)))",
+				.cra_driver_name = "echainiv-authenc-"
+						   "hmac-sha384-"
+						   "cbc-des3_ede-caam",
+				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
+			},
 			.setkey = aead_setkey,
 			.setauthsize = aead_setauthsize,
-			.encrypt = old_aead_encrypt,
-			.decrypt = old_aead_decrypt,
-			.givencrypt = old_aead_givencrypt,
-			.geniv = "<built-in>",
+			.encrypt = aead_encrypt,
+			.decrypt = aead_givdecrypt,
 			.ivsize = DES3_EDE_BLOCK_SIZE,
 			.maxauthsize = SHA384_DIGEST_SIZE,
+		},
+		.caam = {
+			.class1_alg_type = OP_ALG_ALGSEL_3DES | OP_ALG_AAI_CBC,
+			.class2_alg_type = OP_ALG_ALGSEL_SHA384 |
+					   OP_ALG_AAI_HMAC_PRECOMP,
+			.alg_op = OP_ALG_ALGSEL_SHA384 | OP_ALG_AAI_HMAC,
+			.geniv = true,
+		},
+	},
+	{
+		.aead = {
+			.base = {
+				.cra_name = "authenc(hmac(sha512),"
+					    "cbc(des3_ede))",
+				.cra_driver_name = "authenc-hmac-sha512-"
+						   "cbc-des3_ede-caam",
+				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 			},
-		.class1_alg_type = OP_ALG_ALGSEL_3DES | OP_ALG_AAI_CBC,
-		.class2_alg_type = OP_ALG_ALGSEL_SHA384 |
-				   OP_ALG_AAI_HMAC_PRECOMP,
-		.alg_op = OP_ALG_ALGSEL_SHA384 | OP_ALG_AAI_HMAC,
+			.setkey = aead_setkey,
+			.setauthsize = aead_setauthsize,
+			.encrypt = aead_encrypt,
+			.decrypt = aead_decrypt,
+			.ivsize = DES3_EDE_BLOCK_SIZE,
+			.maxauthsize = SHA512_DIGEST_SIZE,
+		},
+		.caam = {
+			.class1_alg_type = OP_ALG_ALGSEL_3DES | OP_ALG_AAI_CBC,
+			.class2_alg_type = OP_ALG_ALGSEL_SHA512 |
+					   OP_ALG_AAI_HMAC_PRECOMP,
+			.alg_op = OP_ALG_ALGSEL_SHA512 | OP_ALG_AAI_HMAC,
+		},
 	},
 	{
-		.name = "authenc(hmac(sha512),cbc(des3_ede))",
-		.driver_name = "authenc-hmac-sha512-cbc-des3_ede-caam",
-		.blocksize = DES3_EDE_BLOCK_SIZE,
-		.type = CRYPTO_ALG_TYPE_AEAD,
-		.template_aead = {
+		.aead = {
+			.base = {
+				.cra_name = "echainiv(authenc(hmac(sha512),"
+					    "cbc(des3_ede)))",
+				.cra_driver_name = "echainiv-authenc-"
+						   "hmac-sha512-"
+						   "cbc-des3_ede-caam",
+				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
+			},
 			.setkey = aead_setkey,
 			.setauthsize = aead_setauthsize,
-			.encrypt = old_aead_encrypt,
-			.decrypt = old_aead_decrypt,
-			.givencrypt = old_aead_givencrypt,
-			.geniv = "<built-in>",
+			.encrypt = aead_encrypt,
+			.decrypt = aead_givdecrypt,
 			.ivsize = DES3_EDE_BLOCK_SIZE,
 			.maxauthsize = SHA512_DIGEST_SIZE,
+		},
+		.caam = {
+			.class1_alg_type = OP_ALG_ALGSEL_3DES | OP_ALG_AAI_CBC,
+			.class2_alg_type = OP_ALG_ALGSEL_SHA512 |
+					   OP_ALG_AAI_HMAC_PRECOMP,
+			.alg_op = OP_ALG_ALGSEL_SHA512 | OP_ALG_AAI_HMAC,
+			.geniv = true,
+		},
+	},
+	{
+		.aead = {
+			.base = {
+				.cra_name = "authenc(hmac(md5),cbc(des))",
+				.cra_driver_name = "authenc-hmac-md5-"
+						   "cbc-des-caam",
+				.cra_blocksize = DES_BLOCK_SIZE,
 			},
-		.class1_alg_type = OP_ALG_ALGSEL_3DES | OP_ALG_AAI_CBC,
-		.class2_alg_type = OP_ALG_ALGSEL_SHA512 |
-				   OP_ALG_AAI_HMAC_PRECOMP,
-		.alg_op = OP_ALG_ALGSEL_SHA512 | OP_ALG_AAI_HMAC,
+			.setkey = aead_setkey,
+			.setauthsize = aead_setauthsize,
+			.encrypt = aead_encrypt,
+			.decrypt = aead_decrypt,
+			.ivsize = DES_BLOCK_SIZE,
+			.maxauthsize = MD5_DIGEST_SIZE,
+		},
+		.caam = {
+			.class1_alg_type = OP_ALG_ALGSEL_DES | OP_ALG_AAI_CBC,
+			.class2_alg_type = OP_ALG_ALGSEL_MD5 |
+					   OP_ALG_AAI_HMAC_PRECOMP,
+			.alg_op = OP_ALG_ALGSEL_MD5 | OP_ALG_AAI_HMAC,
+		},
 	},
 	{
-		.name = "authenc(hmac(md5),cbc(des))",
-		.driver_name = "authenc-hmac-md5-cbc-des-caam",
-		.blocksize = DES_BLOCK_SIZE,
-		.type = CRYPTO_ALG_TYPE_AEAD,
-		.template_aead = {
+		.aead = {
+			.base = {
+				.cra_name = "echainiv(authenc(hmac(md5),"
+					    "cbc(des)))",
+				.cra_driver_name = "echainiv-authenc-hmac-md5-"
+						   "cbc-des-caam",
+				.cra_blocksize = DES_BLOCK_SIZE,
+			},
 			.setkey = aead_setkey,
 			.setauthsize = aead_setauthsize,
-			.encrypt = old_aead_encrypt,
-			.decrypt = old_aead_decrypt,
-			.givencrypt = old_aead_givencrypt,
-			.geniv = "<built-in>",
+			.encrypt = aead_encrypt,
+			.decrypt = aead_givdecrypt,
 			.ivsize = DES_BLOCK_SIZE,
 			.maxauthsize = MD5_DIGEST_SIZE,
+		},
+		.caam = {
+			.class1_alg_type = OP_ALG_ALGSEL_DES | OP_ALG_AAI_CBC,
+			.class2_alg_type = OP_ALG_ALGSEL_MD5 |
+					   OP_ALG_AAI_HMAC_PRECOMP,
+			.alg_op = OP_ALG_ALGSEL_MD5 | OP_ALG_AAI_HMAC,
+			.geniv = true,
+		},
+	},
+	{
+		.aead = {
+			.base = {
+				.cra_name = "authenc(hmac(sha1),cbc(des))",
+				.cra_driver_name = "authenc-hmac-sha1-"
+						   "cbc-des-caam",
+				.cra_blocksize = DES_BLOCK_SIZE,
 			},
-		.class1_alg_type = OP_ALG_ALGSEL_DES | OP_ALG_AAI_CBC,
-		.class2_alg_type = OP_ALG_ALGSEL_MD5 | OP_ALG_AAI_HMAC_PRECOMP,
-		.alg_op = OP_ALG_ALGSEL_MD5 | OP_ALG_AAI_HMAC,
+			.setkey = aead_setkey,
+			.setauthsize = aead_setauthsize,
+			.encrypt = aead_encrypt,
+			.decrypt = aead_decrypt,
+			.ivsize = DES_BLOCK_SIZE,
+			.maxauthsize = SHA1_DIGEST_SIZE,
+		},
+		.caam = {
+			.class1_alg_type = OP_ALG_ALGSEL_DES | OP_ALG_AAI_CBC,
+			.class2_alg_type = OP_ALG_ALGSEL_SHA1 |
+					   OP_ALG_AAI_HMAC_PRECOMP,
+			.alg_op = OP_ALG_ALGSEL_SHA1 | OP_ALG_AAI_HMAC,
+		},
 	},
 	{
-		.name = "authenc(hmac(sha1),cbc(des))",
-		.driver_name = "authenc-hmac-sha1-cbc-des-caam",
-		.blocksize = DES_BLOCK_SIZE,
-		.type = CRYPTO_ALG_TYPE_AEAD,
-		.template_aead = {
+		.aead = {
+			.base = {
+				.cra_name = "echainiv(authenc(hmac(sha1),"
+					    "cbc(des)))",
+				.cra_driver_name = "echainiv-authenc-"
+						   "hmac-sha1-cbc-des-caam",
+				.cra_blocksize = DES_BLOCK_SIZE,
+			},
 			.setkey = aead_setkey,
 			.setauthsize = aead_setauthsize,
-			.encrypt = old_aead_encrypt,
-			.decrypt = old_aead_decrypt,
-			.givencrypt = old_aead_givencrypt,
-			.geniv = "<built-in>",
+			.encrypt = aead_encrypt,
+			.decrypt = aead_givdecrypt,
 			.ivsize = DES_BLOCK_SIZE,
 			.maxauthsize = SHA1_DIGEST_SIZE,
+		},
+		.caam = {
+			.class1_alg_type = OP_ALG_ALGSEL_DES | OP_ALG_AAI_CBC,
+			.class2_alg_type = OP_ALG_ALGSEL_SHA1 |
+					   OP_ALG_AAI_HMAC_PRECOMP,
+			.alg_op = OP_ALG_ALGSEL_SHA1 | OP_ALG_AAI_HMAC,
+			.geniv = true,
+		},
+	},
+	{
+		.aead = {
+			.base = {
+				.cra_name = "authenc(hmac(sha224),cbc(des))",
+				.cra_driver_name = "authenc-hmac-sha224-"
+						   "cbc-des-caam",
+				.cra_blocksize = DES_BLOCK_SIZE,
 			},
-		.class1_alg_type = OP_ALG_ALGSEL_DES | OP_ALG_AAI_CBC,
-		.class2_alg_type = OP_ALG_ALGSEL_SHA1 | OP_ALG_AAI_HMAC_PRECOMP,
-		.alg_op = OP_ALG_ALGSEL_SHA1 | OP_ALG_AAI_HMAC,
+			.setkey = aead_setkey,
+			.setauthsize = aead_setauthsize,
+			.encrypt = aead_encrypt,
+			.decrypt = aead_decrypt,
+			.ivsize = DES_BLOCK_SIZE,
+			.maxauthsize = SHA224_DIGEST_SIZE,
+		},
+		.caam = {
+			.class1_alg_type = OP_ALG_ALGSEL_DES | OP_ALG_AAI_CBC,
+			.class2_alg_type = OP_ALG_ALGSEL_SHA224 |
+					   OP_ALG_AAI_HMAC_PRECOMP,
+			.alg_op = OP_ALG_ALGSEL_SHA224 | OP_ALG_AAI_HMAC,
+		},
 	},
 	{
-		.name = "authenc(hmac(sha224),cbc(des))",
-		.driver_name = "authenc-hmac-sha224-cbc-des-caam",
-		.blocksize = DES_BLOCK_SIZE,
-		.type = CRYPTO_ALG_TYPE_AEAD,
-		.template_aead = {
+		.aead = {
+			.base = {
+				.cra_name = "echainiv(authenc(hmac(sha224),"
+					    "cbc(des)))",
+				.cra_driver_name = "echainiv-authenc-"
+						   "hmac-sha224-cbc-des-caam",
+				.cra_blocksize = DES_BLOCK_SIZE,
+			},
 			.setkey = aead_setkey,
 			.setauthsize = aead_setauthsize,
-			.encrypt = old_aead_encrypt,
-			.decrypt = old_aead_decrypt,
-			.givencrypt = old_aead_givencrypt,
-			.geniv = "<built-in>",
+			.encrypt = aead_encrypt,
+			.decrypt = aead_givdecrypt,
 			.ivsize = DES_BLOCK_SIZE,
 			.maxauthsize = SHA224_DIGEST_SIZE,
+		},
+		.caam = {
+			.class1_alg_type = OP_ALG_ALGSEL_DES | OP_ALG_AAI_CBC,
+			.class2_alg_type = OP_ALG_ALGSEL_SHA224 |
+					   OP_ALG_AAI_HMAC_PRECOMP,
+			.alg_op = OP_ALG_ALGSEL_SHA224 | OP_ALG_AAI_HMAC,
+			.geniv = true,
+		},
+	},
+	{
+		.aead = {
+			.base = {
+				.cra_name = "authenc(hmac(sha256),cbc(des))",
+				.cra_driver_name = "authenc-hmac-sha256-"
+						   "cbc-des-caam",
+				.cra_blocksize = DES_BLOCK_SIZE,
 			},
-		.class1_alg_type = OP_ALG_ALGSEL_DES | OP_ALG_AAI_CBC,
-		.class2_alg_type = OP_ALG_ALGSEL_SHA224 |
-				   OP_ALG_AAI_HMAC_PRECOMP,
-		.alg_op = OP_ALG_ALGSEL_SHA224 | OP_ALG_AAI_HMAC,
+			.setkey = aead_setkey,
+			.setauthsize = aead_setauthsize,
+			.encrypt = aead_encrypt,
+			.decrypt = aead_decrypt,
+			.ivsize = DES_BLOCK_SIZE,
+			.maxauthsize = SHA256_DIGEST_SIZE,
+		},
+		.caam = {
+			.class1_alg_type = OP_ALG_ALGSEL_DES | OP_ALG_AAI_CBC,
+			.class2_alg_type = OP_ALG_ALGSEL_SHA256 |
+					   OP_ALG_AAI_HMAC_PRECOMP,
+			.alg_op = OP_ALG_ALGSEL_SHA256 | OP_ALG_AAI_HMAC,
+		},
 	},
 	{
-		.name = "authenc(hmac(sha256),cbc(des))",
-		.driver_name = "authenc-hmac-sha256-cbc-des-caam",
-		.blocksize = DES_BLOCK_SIZE,
-		.type = CRYPTO_ALG_TYPE_AEAD,
-		.template_aead = {
+		.aead = {
+			.base = {
+				.cra_name = "echainiv(authenc(hmac(sha256),"
+					    "cbc(des)))",
+				.cra_driver_name = "echainiv-authenc-"
+						   "hmac-sha256-cbc-des-caam",
+				.cra_blocksize = DES_BLOCK_SIZE,
+			},
 			.setkey = aead_setkey,
 			.setauthsize = aead_setauthsize,
-			.encrypt = old_aead_encrypt,
-			.decrypt = old_aead_decrypt,
-			.givencrypt = old_aead_givencrypt,
-			.geniv = "<built-in>",
+			.encrypt = aead_encrypt,
+			.decrypt = aead_givdecrypt,
 			.ivsize = DES_BLOCK_SIZE,
 			.maxauthsize = SHA256_DIGEST_SIZE,
+		},
+		.caam = {
+			.class1_alg_type = OP_ALG_ALGSEL_DES | OP_ALG_AAI_CBC,
+			.class2_alg_type = OP_ALG_ALGSEL_SHA256 |
+					   OP_ALG_AAI_HMAC_PRECOMP,
+			.alg_op = OP_ALG_ALGSEL_SHA256 | OP_ALG_AAI_HMAC,
+			.geniv = true,
+		},
+	},
+	{
+		.aead = {
+			.base = {
+				.cra_name = "authenc(hmac(sha384),cbc(des))",
+				.cra_driver_name = "authenc-hmac-sha384-"
+						   "cbc-des-caam",
+				.cra_blocksize = DES_BLOCK_SIZE,
 			},
-		.class1_alg_type = OP_ALG_ALGSEL_DES | OP_ALG_AAI_CBC,
-		.class2_alg_type = OP_ALG_ALGSEL_SHA256 |
-				   OP_ALG_AAI_HMAC_PRECOMP,
-		.alg_op = OP_ALG_ALGSEL_SHA256 | OP_ALG_AAI_HMAC,
+			.setkey = aead_setkey,
+			.setauthsize = aead_setauthsize,
+			.encrypt = aead_encrypt,
+			.decrypt = aead_decrypt,
+			.ivsize = DES_BLOCK_SIZE,
+			.maxauthsize = SHA384_DIGEST_SIZE,
+		},
+		.caam = {
+			.class1_alg_type = OP_ALG_ALGSEL_DES | OP_ALG_AAI_CBC,
+			.class2_alg_type = OP_ALG_ALGSEL_SHA384 |
+					   OP_ALG_AAI_HMAC_PRECOMP,
+			.alg_op = OP_ALG_ALGSEL_SHA384 | OP_ALG_AAI_HMAC,
+		},
 	},
 	{
-		.name = "authenc(hmac(sha384),cbc(des))",
-		.driver_name = "authenc-hmac-sha384-cbc-des-caam",
-		.blocksize = DES_BLOCK_SIZE,
-		.type = CRYPTO_ALG_TYPE_AEAD,
-		.template_aead = {
+		.aead = {
+			.base = {
+				.cra_name = "echainiv(authenc(hmac(sha384),"
+					    "cbc(des)))",
+				.cra_driver_name = "echainiv-authenc-"
+						   "hmac-sha384-cbc-des-caam",
+				.cra_blocksize = DES_BLOCK_SIZE,
+			},
 			.setkey = aead_setkey,
 			.setauthsize = aead_setauthsize,
-			.encrypt = old_aead_encrypt,
-			.decrypt = old_aead_decrypt,
-			.givencrypt = old_aead_givencrypt,
-			.geniv = "<built-in>",
+			.encrypt = aead_encrypt,
+			.decrypt = aead_givdecrypt,
 			.ivsize = DES_BLOCK_SIZE,
 			.maxauthsize = SHA384_DIGEST_SIZE,
+		},
+		.caam = {
+			.class1_alg_type = OP_ALG_ALGSEL_DES | OP_ALG_AAI_CBC,
+			.class2_alg_type = OP_ALG_ALGSEL_SHA384 |
+					   OP_ALG_AAI_HMAC_PRECOMP,
+			.alg_op = OP_ALG_ALGSEL_SHA384 | OP_ALG_AAI_HMAC,
+			.geniv = true,
+		},
+	},
+	{
+		.aead = {
+			.base = {
+				.cra_name = "authenc(hmac(sha512),cbc(des))",
+				.cra_driver_name = "authenc-hmac-sha512-"
+						   "cbc-des-caam",
+				.cra_blocksize = DES_BLOCK_SIZE,
 			},
-		.class1_alg_type = OP_ALG_ALGSEL_DES | OP_ALG_AAI_CBC,
-		.class2_alg_type = OP_ALG_ALGSEL_SHA384 |
-				   OP_ALG_AAI_HMAC_PRECOMP,
-		.alg_op = OP_ALG_ALGSEL_SHA384 | OP_ALG_AAI_HMAC,
+			.setkey = aead_setkey,
+			.setauthsize = aead_setauthsize,
+			.encrypt = aead_encrypt,
+			.decrypt = aead_decrypt,
+			.ivsize = DES_BLOCK_SIZE,
+			.maxauthsize = SHA512_DIGEST_SIZE,
+		},
+		.caam = {
+			.class1_alg_type = OP_ALG_ALGSEL_DES | OP_ALG_AAI_CBC,
+			.class2_alg_type = OP_ALG_ALGSEL_SHA512 |
+					   OP_ALG_AAI_HMAC_PRECOMP,
+			.alg_op = OP_ALG_ALGSEL_SHA512 | OP_ALG_AAI_HMAC,
+		},
 	},
 	{
-		.name = "authenc(hmac(sha512),cbc(des))",
-		.driver_name = "authenc-hmac-sha512-cbc-des-caam",
-		.blocksize = DES_BLOCK_SIZE,
-		.type = CRYPTO_ALG_TYPE_AEAD,
-		.template_aead = {
+		.aead = {
+			.base = {
+				.cra_name = "echainiv(authenc(hmac(sha512),"
+					    "cbc(des)))",
+				.cra_driver_name = "echainiv-authenc-"
+						   "hmac-sha512-cbc-des-caam",
+				.cra_blocksize = DES_BLOCK_SIZE,
+			},
 			.setkey = aead_setkey,
 			.setauthsize = aead_setauthsize,
-			.encrypt = old_aead_encrypt,
-			.decrypt = old_aead_decrypt,
-			.givencrypt = old_aead_givencrypt,
-			.geniv = "<built-in>",
+			.encrypt = aead_encrypt,
+			.decrypt = aead_givdecrypt,
 			.ivsize = DES_BLOCK_SIZE,
 			.maxauthsize = SHA512_DIGEST_SIZE,
-			},
-		.class1_alg_type = OP_ALG_ALGSEL_DES | OP_ALG_AAI_CBC,
-		.class2_alg_type = OP_ALG_ALGSEL_SHA512 |
-				   OP_ALG_AAI_HMAC_PRECOMP,
-		.alg_op = OP_ALG_ALGSEL_SHA512 | OP_ALG_AAI_HMAC,
+		},
+		.caam = {
+			.class1_alg_type = OP_ALG_ALGSEL_DES | OP_ALG_AAI_CBC,
+			.class2_alg_type = OP_ALG_ALGSEL_SHA512 |
+					   OP_ALG_AAI_HMAC_PRECOMP,
+			.alg_op = OP_ALG_ALGSEL_SHA512 | OP_ALG_AAI_HMAC,
+			.geniv = true,
+		},
 	},
 	{
-		.name = "authenc(hmac(md5),rfc3686(ctr(aes)))",
-		.driver_name = "authenc-hmac-md5-rfc3686-ctr-aes-caam",
-		.blocksize = 1,
-		.type = CRYPTO_ALG_TYPE_AEAD,
-		.template_aead = {
+		.aead = {
+			.base = {
+				.cra_name = "authenc(hmac(md5),"
+					    "rfc3686(ctr(aes)))",
+				.cra_driver_name = "authenc-hmac-md5-"
+						   "rfc3686-ctr-aes-caam",
+				.cra_blocksize = 1,
+			},
 			.setkey = aead_setkey,
 			.setauthsize = aead_setauthsize,
-			.encrypt = old_aead_encrypt,
-			.decrypt = old_aead_decrypt,
-			.givencrypt = old_aead_givencrypt,
-			.geniv = "<built-in>",
+			.encrypt = aead_encrypt,
+			.decrypt = aead_decrypt,
 			.ivsize = CTR_RFC3686_IV_SIZE,
 			.maxauthsize = MD5_DIGEST_SIZE,
-			},
-		.class1_alg_type = OP_ALG_ALGSEL_AES | OP_ALG_AAI_CTR_MOD128,
-		.class2_alg_type = OP_ALG_ALGSEL_MD5 | OP_ALG_AAI_HMAC_PRECOMP,
-		.alg_op = OP_ALG_ALGSEL_MD5 | OP_ALG_AAI_HMAC,
+		},
+		.caam = {
+			.class1_alg_type = OP_ALG_ALGSEL_AES |
+					   OP_ALG_AAI_CTR_MOD128,
+			.class2_alg_type = OP_ALG_ALGSEL_MD5 |
+					   OP_ALG_AAI_HMAC_PRECOMP,
+			.alg_op = OP_ALG_ALGSEL_MD5 | OP_ALG_AAI_HMAC,
+			.rfc3686 = true,
+		},
 	},
 	{
-		.name = "authenc(hmac(sha1),rfc3686(ctr(aes)))",
-		.driver_name = "authenc-hmac-sha1-rfc3686-ctr-aes-caam",
-		.blocksize = 1,
-		.type = CRYPTO_ALG_TYPE_AEAD,
-		.template_aead = {
+		.aead = {
+			.base = {
+				.cra_name = "seqiv(authenc("
+					    "hmac(md5),rfc3686(ctr(aes))))",
+				.cra_driver_name = "seqiv-authenc-hmac-md5-"
+						   "rfc3686-ctr-aes-caam",
+				.cra_blocksize = 1,
+			},
 			.setkey = aead_setkey,
 			.setauthsize = aead_setauthsize,
-			.encrypt = old_aead_encrypt,
-			.decrypt = old_aead_decrypt,
-			.givencrypt = old_aead_givencrypt,
-			.geniv = "<built-in>",
+			.encrypt = aead_encrypt,
+			.decrypt = aead_givdecrypt,
 			.ivsize = CTR_RFC3686_IV_SIZE,
-			.maxauthsize = SHA1_DIGEST_SIZE,
-			},
-		.class1_alg_type = OP_ALG_ALGSEL_AES | OP_ALG_AAI_CTR_MOD128,
-		.class2_alg_type = OP_ALG_ALGSEL_SHA1 | OP_ALG_AAI_HMAC_PRECOMP,
-		.alg_op = OP_ALG_ALGSEL_SHA1 | OP_ALG_AAI_HMAC,
+			.maxauthsize = MD5_DIGEST_SIZE,
+		},
+		.caam = {
+			.class1_alg_type = OP_ALG_ALGSEL_AES |
+					   OP_ALG_AAI_CTR_MOD128,
+			.class2_alg_type = OP_ALG_ALGSEL_MD5 |
+					   OP_ALG_AAI_HMAC_PRECOMP,
+			.alg_op = OP_ALG_ALGSEL_MD5 | OP_ALG_AAI_HMAC,
+			.rfc3686 = true,
+			.geniv = true,
+		},
 	},
 	{
-		.name = "authenc(hmac(sha224),rfc3686(ctr(aes)))",
-		.driver_name = "authenc-hmac-sha224-rfc3686-ctr-aes-caam",
-		.blocksize = 1,
-		.type = CRYPTO_ALG_TYPE_AEAD,
-		.template_aead = {
+		.aead = {
+			.base = {
+				.cra_name = "authenc(hmac(sha1),"
+					    "rfc3686(ctr(aes)))",
+				.cra_driver_name = "authenc-hmac-sha1-"
+						   "rfc3686-ctr-aes-caam",
+				.cra_blocksize = 1,
+			},
 			.setkey = aead_setkey,
 			.setauthsize = aead_setauthsize,
-			.encrypt = old_aead_encrypt,
-			.decrypt = old_aead_decrypt,
-			.givencrypt = old_aead_givencrypt,
-			.geniv = "<built-in>",
+			.encrypt = aead_encrypt,
+			.decrypt = aead_decrypt,
 			.ivsize = CTR_RFC3686_IV_SIZE,
-			.maxauthsize = SHA224_DIGEST_SIZE,
-			},
-		.class1_alg_type = OP_ALG_ALGSEL_AES | OP_ALG_AAI_CTR_MOD128,
-		.class2_alg_type = OP_ALG_ALGSEL_SHA224 |
-				   OP_ALG_AAI_HMAC_PRECOMP,
-		.alg_op = OP_ALG_ALGSEL_SHA224 | OP_ALG_AAI_HMAC,
+			.maxauthsize = SHA1_DIGEST_SIZE,
+		},
+		.caam = {
+			.class1_alg_type = OP_ALG_ALGSEL_AES |
+					   OP_ALG_AAI_CTR_MOD128,
+			.class2_alg_type = OP_ALG_ALGSEL_SHA1 |
+					   OP_ALG_AAI_HMAC_PRECOMP,
+			.alg_op = OP_ALG_ALGSEL_SHA1 | OP_ALG_AAI_HMAC,
+			.rfc3686 = true,
+		},
 	},
 	{
-		.name = "authenc(hmac(sha256),rfc3686(ctr(aes)))",
-		.driver_name = "authenc-hmac-sha256-rfc3686-ctr-aes-caam",
-		.blocksize = 1,
-		.type = CRYPTO_ALG_TYPE_AEAD,
-		.template_aead = {
+		.aead = {
+			.base = {
+				.cra_name = "seqiv(authenc("
+					    "hmac(sha1),rfc3686(ctr(aes))))",
+				.cra_driver_name = "seqiv-authenc-hmac-sha1-"
+						   "rfc3686-ctr-aes-caam",
+				.cra_blocksize = 1,
+			},
 			.setkey = aead_setkey,
 			.setauthsize = aead_setauthsize,
-			.encrypt = old_aead_encrypt,
-			.decrypt = old_aead_decrypt,
-			.givencrypt = old_aead_givencrypt,
-			.geniv = "<built-in>",
+			.encrypt = aead_encrypt,
+			.decrypt = aead_givdecrypt,
 			.ivsize = CTR_RFC3686_IV_SIZE,
-			.maxauthsize = SHA256_DIGEST_SIZE,
-			},
-		.class1_alg_type = OP_ALG_ALGSEL_AES | OP_ALG_AAI_CTR_MOD128,
-		.class2_alg_type = OP_ALG_ALGSEL_SHA256 |
-				   OP_ALG_AAI_HMAC_PRECOMP,
-		.alg_op = OP_ALG_ALGSEL_SHA256 | OP_ALG_AAI_HMAC,
+			.maxauthsize = SHA1_DIGEST_SIZE,
+		},
+		.caam = {
+			.class1_alg_type = OP_ALG_ALGSEL_AES |
+					   OP_ALG_AAI_CTR_MOD128,
+			.class2_alg_type = OP_ALG_ALGSEL_SHA1 |
+					   OP_ALG_AAI_HMAC_PRECOMP,
+			.alg_op = OP_ALG_ALGSEL_SHA1 | OP_ALG_AAI_HMAC,
+			.rfc3686 = true,
+			.geniv = true,
+		},
 	},
 	{
-		.name = "authenc(hmac(sha384),rfc3686(ctr(aes)))",
-		.driver_name = "authenc-hmac-sha384-rfc3686-ctr-aes-caam",
-		.blocksize = 1,
-		.type = CRYPTO_ALG_TYPE_AEAD,
-		.template_aead = {
+		.aead = {
+			.base = {
+				.cra_name = "authenc(hmac(sha224),"
+					    "rfc3686(ctr(aes)))",
+				.cra_driver_name = "authenc-hmac-sha224-"
+						   "rfc3686-ctr-aes-caam",
+				.cra_blocksize = 1,
+			},
 			.setkey = aead_setkey,
 			.setauthsize = aead_setauthsize,
-			.encrypt = old_aead_encrypt,
-			.decrypt = old_aead_decrypt,
-			.givencrypt = old_aead_givencrypt,
-			.geniv = "<built-in>",
+			.encrypt = aead_encrypt,
+			.decrypt = aead_decrypt,
 			.ivsize = CTR_RFC3686_IV_SIZE,
-			.maxauthsize = SHA384_DIGEST_SIZE,
-			},
-		.class1_alg_type = OP_ALG_ALGSEL_AES | OP_ALG_AAI_CTR_MOD128,
-		.class2_alg_type = OP_ALG_ALGSEL_SHA384 |
-				   OP_ALG_AAI_HMAC_PRECOMP,
-		.alg_op = OP_ALG_ALGSEL_SHA384 | OP_ALG_AAI_HMAC,
+			.maxauthsize = SHA224_DIGEST_SIZE,
+		},
+		.caam = {
+			.class1_alg_type = OP_ALG_ALGSEL_AES |
+					   OP_ALG_AAI_CTR_MOD128,
+			.class2_alg_type = OP_ALG_ALGSEL_SHA224 |
+					   OP_ALG_AAI_HMAC_PRECOMP,
+			.alg_op = OP_ALG_ALGSEL_SHA224 | OP_ALG_AAI_HMAC,
+			.rfc3686 = true,
+		},
 	},
 	{
-		.name = "authenc(hmac(sha512),rfc3686(ctr(aes)))",
-		.driver_name = "authenc-hmac-sha512-rfc3686-ctr-aes-caam",
-		.blocksize = 1,
-		.type = CRYPTO_ALG_TYPE_AEAD,
-		.template_aead = {
+		.aead = {
+			.base = {
+				.cra_name = "seqiv(authenc("
+					    "hmac(sha224),rfc3686(ctr(aes))))",
+				.cra_driver_name = "seqiv-authenc-hmac-sha224-"
+						   "rfc3686-ctr-aes-caam",
+				.cra_blocksize = 1,
+			},
 			.setkey = aead_setkey,
 			.setauthsize = aead_setauthsize,
-			.encrypt = old_aead_encrypt,
-			.decrypt = old_aead_decrypt,
-			.givencrypt = old_aead_givencrypt,
-			.geniv = "<built-in>",
+			.encrypt = aead_encrypt,
+			.decrypt = aead_givdecrypt,
 			.ivsize = CTR_RFC3686_IV_SIZE,
-			.maxauthsize = SHA512_DIGEST_SIZE,
-			},
-		.class1_alg_type = OP_ALG_ALGSEL_AES | OP_ALG_AAI_CTR_MOD128,
-		.class2_alg_type = OP_ALG_ALGSEL_SHA512 |
-				   OP_ALG_AAI_HMAC_PRECOMP,
-		.alg_op = OP_ALG_ALGSEL_SHA512 | OP_ALG_AAI_HMAC,
-	},
-	/* ablkcipher descriptor */
-	{
-		.name = "cbc(aes)",
-		.driver_name = "cbc-aes-caam",
-		.blocksize = AES_BLOCK_SIZE,
-		.type = CRYPTO_ALG_TYPE_GIVCIPHER,
-		.template_ablkcipher = {
-			.setkey = ablkcipher_setkey,
-			.encrypt = ablkcipher_encrypt,
-			.decrypt = ablkcipher_decrypt,
-			.givencrypt = ablkcipher_givencrypt,
-			.geniv = "<built-in>",
-			.min_keysize = AES_MIN_KEY_SIZE,
-			.max_keysize = AES_MAX_KEY_SIZE,
-			.ivsize = AES_BLOCK_SIZE,
-			},
-		.class1_alg_type = OP_ALG_ALGSEL_AES | OP_ALG_AAI_CBC,
+			.maxauthsize = SHA224_DIGEST_SIZE,
+		},
+		.caam = {
+			.class1_alg_type = OP_ALG_ALGSEL_AES |
+					   OP_ALG_AAI_CTR_MOD128,
+			.class2_alg_type = OP_ALG_ALGSEL_SHA224 |
+					   OP_ALG_AAI_HMAC_PRECOMP,
+			.alg_op = OP_ALG_ALGSEL_SHA224 | OP_ALG_AAI_HMAC,
+			.rfc3686 = true,
+			.geniv = true,
+		},
 	},
 	{
-		.name = "cbc(des3_ede)",
-		.driver_name = "cbc-3des-caam",
-		.blocksize = DES3_EDE_BLOCK_SIZE,
-		.type = CRYPTO_ALG_TYPE_GIVCIPHER,
-		.template_ablkcipher = {
-			.setkey = ablkcipher_setkey,
-			.encrypt = ablkcipher_encrypt,
-			.decrypt = ablkcipher_decrypt,
-			.givencrypt = ablkcipher_givencrypt,
-			.geniv = "<built-in>",
-			.min_keysize = DES3_EDE_KEY_SIZE,
-			.max_keysize = DES3_EDE_KEY_SIZE,
-			.ivsize = DES3_EDE_BLOCK_SIZE,
+		.aead = {
+			.base = {
+				.cra_name = "authenc(hmac(sha256),"
+					    "rfc3686(ctr(aes)))",
+				.cra_driver_name = "authenc-hmac-sha256-"
+						   "rfc3686-ctr-aes-caam",
+				.cra_blocksize = 1,
 			},
-		.class1_alg_type = OP_ALG_ALGSEL_3DES | OP_ALG_AAI_CBC,
+			.setkey = aead_setkey,
+			.setauthsize = aead_setauthsize,
+			.encrypt = aead_encrypt,
+			.decrypt = aead_decrypt,
+			.ivsize = CTR_RFC3686_IV_SIZE,
+			.maxauthsize = SHA256_DIGEST_SIZE,
+		},
+		.caam = {
+			.class1_alg_type = OP_ALG_ALGSEL_AES |
+					   OP_ALG_AAI_CTR_MOD128,
+			.class2_alg_type = OP_ALG_ALGSEL_SHA256 |
+					   OP_ALG_AAI_HMAC_PRECOMP,
+			.alg_op = OP_ALG_ALGSEL_SHA256 | OP_ALG_AAI_HMAC,
+			.rfc3686 = true,
+		},
 	},
 	{
-		.name = "cbc(des)",
-		.driver_name = "cbc-des-caam",
-		.blocksize = DES_BLOCK_SIZE,
-		.type = CRYPTO_ALG_TYPE_GIVCIPHER,
-		.template_ablkcipher = {
-			.setkey = ablkcipher_setkey,
-			.encrypt = ablkcipher_encrypt,
-			.decrypt = ablkcipher_decrypt,
-			.givencrypt = ablkcipher_givencrypt,
-			.geniv = "<built-in>",
-			.min_keysize = DES_KEY_SIZE,
-			.max_keysize = DES_KEY_SIZE,
-			.ivsize = DES_BLOCK_SIZE,
+		.aead = {
+			.base = {
+				.cra_name = "seqiv(authenc(hmac(sha256),"
+					    "rfc3686(ctr(aes))))",
+				.cra_driver_name = "seqiv-authenc-hmac-sha256-"
+						   "rfc3686-ctr-aes-caam",
+				.cra_blocksize = 1,
 			},
-		.class1_alg_type = OP_ALG_ALGSEL_DES | OP_ALG_AAI_CBC,
+			.setkey = aead_setkey,
+			.setauthsize = aead_setauthsize,
+			.encrypt = aead_encrypt,
+			.decrypt = aead_givdecrypt,
+			.ivsize = CTR_RFC3686_IV_SIZE,
+			.maxauthsize = SHA256_DIGEST_SIZE,
+		},
+		.caam = {
+			.class1_alg_type = OP_ALG_ALGSEL_AES |
+					   OP_ALG_AAI_CTR_MOD128,
+			.class2_alg_type = OP_ALG_ALGSEL_SHA256 |
+					   OP_ALG_AAI_HMAC_PRECOMP,
+			.alg_op = OP_ALG_ALGSEL_SHA256 | OP_ALG_AAI_HMAC,
+			.rfc3686 = true,
+			.geniv = true,
+		},
 	},
 	{
-		.name = "ctr(aes)",
-		.driver_name = "ctr-aes-caam",
-		.blocksize = 1,
-		.type = CRYPTO_ALG_TYPE_ABLKCIPHER,
-		.template_ablkcipher = {
-			.setkey = ablkcipher_setkey,
-			.encrypt = ablkcipher_encrypt,
-			.decrypt = ablkcipher_decrypt,
-			.geniv = "chainiv",
-			.min_keysize = AES_MIN_KEY_SIZE,
-			.max_keysize = AES_MAX_KEY_SIZE,
-			.ivsize = AES_BLOCK_SIZE,
+		.aead = {
+			.base = {
+				.cra_name = "authenc(hmac(sha384),"
+					    "rfc3686(ctr(aes)))",
+				.cra_driver_name = "authenc-hmac-sha384-"
+						   "rfc3686-ctr-aes-caam",
+				.cra_blocksize = 1,
 			},
-		.class1_alg_type = OP_ALG_ALGSEL_AES | OP_ALG_AAI_CTR_MOD128,
-	},
-	{
-		.name = "rfc3686(ctr(aes))",
-		.driver_name = "rfc3686-ctr-aes-caam",
-		.blocksize = 1,
-		.type = CRYPTO_ALG_TYPE_GIVCIPHER,
-		.template_ablkcipher = {
-			.setkey = ablkcipher_setkey,
-			.encrypt = ablkcipher_encrypt,
-			.decrypt = ablkcipher_decrypt,
-			.givencrypt = ablkcipher_givencrypt,
-			.geniv = "<built-in>",
-			.min_keysize = AES_MIN_KEY_SIZE +
-				       CTR_RFC3686_NONCE_SIZE,
-			.max_keysize = AES_MAX_KEY_SIZE +
-				       CTR_RFC3686_NONCE_SIZE,
+			.setkey = aead_setkey,
+			.setauthsize = aead_setauthsize,
+			.encrypt = aead_encrypt,
+			.decrypt = aead_decrypt,
 			.ivsize = CTR_RFC3686_IV_SIZE,
-			},
-		.class1_alg_type = OP_ALG_ALGSEL_AES | OP_ALG_AAI_CTR_MOD128,
-	}
-};
-
-struct caam_alg_entry {
-	int class1_alg_type;
-	int class2_alg_type;
-	int alg_op;
-};
-
-struct caam_aead_alg {
-	struct aead_alg aead;
-	struct caam_alg_entry caam;
-	bool registered;
-};
-
-static struct caam_aead_alg driver_aeads[] = {
+			.maxauthsize = SHA384_DIGEST_SIZE,
+		},
+		.caam = {
+			.class1_alg_type = OP_ALG_ALGSEL_AES |
+					   OP_ALG_AAI_CTR_MOD128,
+			.class2_alg_type = OP_ALG_ALGSEL_SHA384 |
+					   OP_ALG_AAI_HMAC_PRECOMP,
+			.alg_op = OP_ALG_ALGSEL_SHA384 | OP_ALG_AAI_HMAC,
+			.rfc3686 = true,
+		},
+	},
 	{
 		.aead = {
 			.base = {
-				.cra_name = "rfc4106(gcm(aes))",
-				.cra_driver_name = "rfc4106-gcm-aes-caam",
+				.cra_name = "seqiv(authenc(hmac(sha384),"
+					    "rfc3686(ctr(aes))))",
+				.cra_driver_name = "seqiv-authenc-hmac-sha384-"
+						   "rfc3686-ctr-aes-caam",
 				.cra_blocksize = 1,
 			},
-			.setkey = rfc4106_setkey,
-			.setauthsize = rfc4106_setauthsize,
-			.encrypt = ipsec_gcm_encrypt,
-			.decrypt = ipsec_gcm_decrypt,
-			.ivsize = 8,
-			.maxauthsize = AES_BLOCK_SIZE,
+			.setkey = aead_setkey,
+			.setauthsize = aead_setauthsize,
+			.encrypt = aead_encrypt,
+			.decrypt = aead_givdecrypt,
+			.ivsize = CTR_RFC3686_IV_SIZE,
+			.maxauthsize = SHA384_DIGEST_SIZE,
 		},
 		.caam = {
-			.class1_alg_type = OP_ALG_ALGSEL_AES | OP_ALG_AAI_GCM,
+			.class1_alg_type = OP_ALG_ALGSEL_AES |
+					   OP_ALG_AAI_CTR_MOD128,
+			.class2_alg_type = OP_ALG_ALGSEL_SHA384 |
+					   OP_ALG_AAI_HMAC_PRECOMP,
+			.alg_op = OP_ALG_ALGSEL_SHA384 | OP_ALG_AAI_HMAC,
+			.rfc3686 = true,
+			.geniv = true,
 		},
 	},
 	{
 		.aead = {
 			.base = {
-				.cra_name = "rfc4543(gcm(aes))",
-				.cra_driver_name = "rfc4543-gcm-aes-caam",
+				.cra_name = "authenc(hmac(sha512),"
+					    "rfc3686(ctr(aes)))",
+				.cra_driver_name = "authenc-hmac-sha512-"
+						   "rfc3686-ctr-aes-caam",
 				.cra_blocksize = 1,
 			},
-			.setkey = rfc4543_setkey,
-			.setauthsize = rfc4543_setauthsize,
-			.encrypt = ipsec_gcm_encrypt,
-			.decrypt = ipsec_gcm_decrypt,
-			.ivsize = 8,
-			.maxauthsize = AES_BLOCK_SIZE,
+			.setkey = aead_setkey,
+			.setauthsize = aead_setauthsize,
+			.encrypt = aead_encrypt,
+			.decrypt = aead_decrypt,
+			.ivsize = CTR_RFC3686_IV_SIZE,
+			.maxauthsize = SHA512_DIGEST_SIZE,
 		},
 		.caam = {
-			.class1_alg_type = OP_ALG_ALGSEL_AES | OP_ALG_AAI_GCM,
+			.class1_alg_type = OP_ALG_ALGSEL_AES |
+					   OP_ALG_AAI_CTR_MOD128,
+			.class2_alg_type = OP_ALG_ALGSEL_SHA512 |
+					   OP_ALG_AAI_HMAC_PRECOMP,
+			.alg_op = OP_ALG_ALGSEL_SHA512 | OP_ALG_AAI_HMAC,
+			.rfc3686 = true,
 		},
 	},
-	/* Galois Counter Mode */
 	{
 		.aead = {
 			.base = {
-				.cra_name = "gcm(aes)",
-				.cra_driver_name = "gcm-aes-caam",
+				.cra_name = "seqiv(authenc(hmac(sha512),"
+					    "rfc3686(ctr(aes))))",
+				.cra_driver_name = "seqiv-authenc-hmac-sha512-"
+						   "rfc3686-ctr-aes-caam",
 				.cra_blocksize = 1,
 			},
-			.setkey = gcm_setkey,
-			.setauthsize = gcm_setauthsize,
-			.encrypt = gcm_encrypt,
-			.decrypt = gcm_decrypt,
-			.ivsize = 12,
-			.maxauthsize = AES_BLOCK_SIZE,
+			.setkey = aead_setkey,
+			.setauthsize = aead_setauthsize,
+			.encrypt = aead_encrypt,
+			.decrypt = aead_givdecrypt,
+			.ivsize = CTR_RFC3686_IV_SIZE,
+			.maxauthsize = SHA512_DIGEST_SIZE,
 		},
 		.caam = {
-			.class1_alg_type = OP_ALG_ALGSEL_AES | OP_ALG_AAI_GCM,
+			.class1_alg_type = OP_ALG_ALGSEL_AES |
+					   OP_ALG_AAI_CTR_MOD128,
+			.class2_alg_type = OP_ALG_ALGSEL_SHA512 |
+					   OP_ALG_AAI_HMAC_PRECOMP,
+			.alg_op = OP_ALG_ALGSEL_SHA512 | OP_ALG_AAI_HMAC,
+			.rfc3686 = true,
+			.geniv = true,
 		},
 	},
 };
@@ -4262,10 +4337,6 @@ static struct caam_crypto_alg *caam_alg_alloc(struct caam_alg_template
 		alg->cra_type = &crypto_ablkcipher_type;
 		alg->cra_ablkcipher = template->template_ablkcipher;
 		break;
-	case CRYPTO_ALG_TYPE_AEAD:
-		alg->cra_type = &crypto_aead_type;
-		alg->cra_aead = template->template_aead;
-		break;
 	}
 
 	t_alg->caam.class1_alg_type = template->class1_alg_type;
