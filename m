From: Tudor Ambarus <tudor.ambarus@freescale.com>
Subject: [PATCH 1/2] crypto: caam - add support for gcm(aes)
Date: Thu, 9 Oct 2014 17:54:09 +0300
Message-ID: <1412866450-22587-1-git-send-email-tudor.ambarus@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <herbert@gondor.apana.org.au>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1bon0118.outbound.protection.outlook.com ([157.56.111.118]:63424
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755604AbaJIP05 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 9 Oct 2014 11:26:57 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add support for AES working in Galois Counter Mode.

There is a limitation related to IV size, similar to the one present in
SW implementation (crypto/gcm.c):
The only IV size allowed is 12 bytes. It will be padded by HW to the right
with 0x0000_0001 (up to 16 bytes - AES block size), according to the GCM
specification.

Signed-off-by: Tudor Ambarus <tudor.ambarus@freescale.com>
Signed-off-by: Horia Geanta <horia.geanta@freescale.com>
---
 drivers/crypto/caam/caamalg.c | 330 ++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 320 insertions(+), 10 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index a80ea85..6178e95 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -74,6 +74,10 @@
 #define DESC_AEAD_NULL_ENC_LEN		(DESC_AEAD_NULL_BASE + 14 * CAAM_CMD_SZ)
 #define DESC_AEAD_NULL_DEC_LEN		(DESC_AEAD_NULL_BASE + 17 * CAAM_CMD_SZ)
 
+#define DESC_GCM_BASE			(3 * CAAM_CMD_SZ)
+#define DESC_GCM_ENC_LEN		(DESC_GCM_BASE + 23 * CAAM_CMD_SZ)
+#define DESC_GCM_DEC_LEN		(DESC_GCM_BASE + 19 * CAAM_CMD_SZ)
+
 #define DESC_ABLKCIPHER_BASE		(3 * CAAM_CMD_SZ)
 #define DESC_ABLKCIPHER_ENC_LEN		(DESC_ABLKCIPHER_BASE + \
 					 20 * CAAM_CMD_SZ)
@@ -630,6 +634,235 @@ static int aead_setauthsize(struct crypto_aead *authenc,
 	return 0;
 }
 
+static int gcm_set_sh_desc(struct crypto_aead *aead)
+{
+	struct aead_tfm *tfm = &aead->base.crt_aead;
+	struct caam_ctx *ctx = crypto_aead_ctx(aead);
+	struct device *jrdev = ctx->jrdev;
+	bool keys_fit_inline = false;
+	u32 *key_jump_cmd, *zero_payload_jump_cmd,
+	    *zero_assoc_jump_cmd1, *zero_assoc_jump_cmd2;
+	u32 *desc;
+
+	if (!ctx->enckeylen || !ctx->authsize)
+		return 0;
+
+	/*
+	 * AES GCM encrypt shared descriptor
+	 * Job Descriptor and Shared Descriptor
+	 * must fit into the 64-word Descriptor h/w Buffer
+	 */
+	if (DESC_GCM_ENC_LEN + DESC_JOB_IO_LEN +
+	    ctx->enckeylen <= CAAM_DESC_BYTES_MAX)
+		keys_fit_inline = true;
+
+	desc = ctx->sh_desc_enc;
+
+	init_sh_desc(desc, HDR_SHARE_SERIAL);
+
+	/* skip key loading if they are loaded due to sharing */
+	key_jump_cmd = append_jump(desc, JUMP_JSL | JUMP_TEST_ALL |
+				   JUMP_COND_SHRD | JUMP_COND_SELF);
+	if (keys_fit_inline)
+		append_key_as_imm(desc, (void *)ctx->key, ctx->enckeylen,
+				  ctx->enckeylen, CLASS_1 | KEY_DEST_CLASS_REG);
+	else
+		append_key(desc, ctx->key_dma, ctx->enckeylen,
+			   CLASS_1 | KEY_DEST_CLASS_REG);
+	set_jump_tgt_here(desc, key_jump_cmd);
+
+	/* class 1 operation */
+	append_operation(desc, ctx->class1_alg_type |
+			 OP_ALG_AS_INITFINAL | OP_ALG_ENCRYPT);
+
+	/* cryptlen = seqoutlen - authsize */
+	append_math_sub_imm_u32(desc, REG3, SEQOUTLEN, IMM, ctx->authsize);
+
+	/* assoclen + cryptlen = seqinlen - ivsize */
+	append_math_sub_imm_u32(desc, REG2, SEQINLEN, IMM, tfm->ivsize);
+
+	/* assoclen = (assoclen + cryptlen) - cryptlen */
+	append_math_sub(desc, REG1, REG2, REG3, CAAM_CMD_SZ);
+
+	/* if cryptlen is ZERO jump to zero-payload commands */
+	append_math_add(desc, VARSEQOUTLEN, ZERO, REG3, CAAM_CMD_SZ);
+	zero_payload_jump_cmd = append_jump(desc, JUMP_TEST_ALL |
+					    JUMP_COND_MATH_Z);
+	/* read IV */
+	append_seq_fifo_load(desc, tfm->ivsize, FIFOLD_CLASS_CLASS1 |
+			     FIFOLD_TYPE_IV | FIFOLD_TYPE_FLUSH1);
+
+	/* if assoclen is ZERO, skip reading the assoc data */
+	append_math_add(desc, VARSEQINLEN, ZERO, REG1, CAAM_CMD_SZ);
+	zero_assoc_jump_cmd1 = append_jump(desc, JUMP_TEST_ALL |
+					   JUMP_COND_MATH_Z);
+
+	/* read assoc data */
+	append_seq_fifo_load(desc, 0, FIFOLD_CLASS_CLASS1 | FIFOLDST_VLF |
+			     FIFOLD_TYPE_AAD | FIFOLD_TYPE_FLUSH1);
+	set_jump_tgt_here(desc, zero_assoc_jump_cmd1);
+
+	append_math_add(desc, VARSEQINLEN, ZERO, REG3, CAAM_CMD_SZ);
+
+	/* write encrypted data */
+	append_seq_fifo_store(desc, 0, FIFOST_TYPE_MESSAGE_DATA | FIFOLDST_VLF);
+
+	/* read payload data */
+	append_seq_fifo_load(desc, 0, FIFOLD_CLASS_CLASS1 | FIFOLDST_VLF |
+			     FIFOLD_TYPE_MSG | FIFOLD_TYPE_LAST1);
+
+	/* jump the zero-payload commands */
+	append_jump(desc, JUMP_TEST_ALL | 7);
+
+	/* zero-payload commands */
+	set_jump_tgt_here(desc, zero_payload_jump_cmd);
+
+	/* if assoclen is ZERO, jump to IV reading - is the only input data */
+	append_math_add(desc, VARSEQINLEN, ZERO, REG1, CAAM_CMD_SZ);
+	zero_assoc_jump_cmd2 = append_jump(desc, JUMP_TEST_ALL |
+					   JUMP_COND_MATH_Z);
+	/* read IV */
+	append_seq_fifo_load(desc, tfm->ivsize, FIFOLD_CLASS_CLASS1 |
+			     FIFOLD_TYPE_IV | FIFOLD_TYPE_FLUSH1);
+
+	/* read assoc data */
+	append_seq_fifo_load(desc, 0, FIFOLD_CLASS_CLASS1 | FIFOLDST_VLF |
+			     FIFOLD_TYPE_AAD | FIFOLD_TYPE_LAST1);
+
+	/* jump to ICV writing */
+	append_jump(desc, JUMP_TEST_ALL | 2);
+
+	/* read IV - is the only input data */
+	set_jump_tgt_here(desc, zero_assoc_jump_cmd2);
+	append_seq_fifo_load(desc, tfm->ivsize, FIFOLD_CLASS_CLASS1 |
+			     FIFOLD_TYPE_IV | FIFOLD_TYPE_FLUSH1 |
+			     FIFOLD_TYPE_LAST1);
+
+	/* write ICV */
+	append_seq_store(desc, ctx->authsize, LDST_CLASS_1_CCB |
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
+	print_hex_dump(KERN_ERR, "gcm enc shdesc@"__stringify(__LINE__)": ",
+		       DUMP_PREFIX_ADDRESS, 16, 4, desc,
+		       desc_bytes(desc), 1);
+#endif
+
+	/*
+	 * Job Descriptor and Shared Descriptors
+	 * must all fit into the 64-word Descriptor h/w Buffer
+	 */
+	if (DESC_GCM_DEC_LEN + DESC_JOB_IO_LEN +
+	    ctx->enckeylen <= CAAM_DESC_BYTES_MAX)
+		keys_fit_inline = true;
+
+	desc = ctx->sh_desc_dec;
+
+	init_sh_desc(desc, HDR_SHARE_SERIAL);
+
+	/* skip key loading if they are loaded due to sharing */
+	key_jump_cmd = append_jump(desc, JUMP_JSL |
+				   JUMP_TEST_ALL | JUMP_COND_SHRD |
+				   JUMP_COND_SELF);
+	if (keys_fit_inline)
+		append_key_as_imm(desc, (void *)ctx->key, ctx->enckeylen,
+				  ctx->enckeylen, CLASS_1 | KEY_DEST_CLASS_REG);
+	else
+		append_key(desc, ctx->key_dma, ctx->enckeylen,
+			   CLASS_1 | KEY_DEST_CLASS_REG);
+	set_jump_tgt_here(desc, key_jump_cmd);
+
+	/* class 1 operation */
+	append_operation(desc, ctx->class1_alg_type |
+			 OP_ALG_AS_INITFINAL | OP_ALG_DECRYPT | OP_ALG_ICV_ON);
+
+	/* assoclen + cryptlen = seqinlen - ivsize - icvsize */
+	append_math_sub_imm_u32(desc, REG3, SEQINLEN, IMM,
+				ctx->authsize + tfm->ivsize);
+
+	/* assoclen = (assoclen + cryptlen) - cryptlen */
+	append_math_sub(desc, REG2, SEQOUTLEN, REG0, CAAM_CMD_SZ);
+	append_math_sub(desc, REG1, REG3, REG2, CAAM_CMD_SZ);
+
+	/* read IV */
+	append_seq_fifo_load(desc, tfm->ivsize, FIFOLD_CLASS_CLASS1 |
+			     FIFOLD_TYPE_IV | FIFOLD_TYPE_FLUSH1);
+
+	/* jump to zero-payload command if cryptlen is zero */
+	append_math_add(desc, VARSEQOUTLEN, ZERO, REG2, CAAM_CMD_SZ);
+	zero_payload_jump_cmd = append_jump(desc, JUMP_TEST_ALL |
+					    JUMP_COND_MATH_Z);
+
+	append_math_add(desc, VARSEQINLEN, ZERO, REG1, CAAM_CMD_SZ);
+	/* if asoclen is ZERO, skip reading assoc data */
+	zero_assoc_jump_cmd1 = append_jump(desc, JUMP_TEST_ALL |
+					   JUMP_COND_MATH_Z);
+	/* read assoc data */
+	append_seq_fifo_load(desc, 0, FIFOLD_CLASS_CLASS1 | FIFOLDST_VLF |
+			     FIFOLD_TYPE_AAD | FIFOLD_TYPE_FLUSH1);
+	set_jump_tgt_here(desc, zero_assoc_jump_cmd1);
+
+	append_math_add(desc, VARSEQINLEN, ZERO, REG2, CAAM_CMD_SZ);
+
+	/* store encrypted data */
+	append_seq_fifo_store(desc, 0, FIFOST_TYPE_MESSAGE_DATA | FIFOLDST_VLF);
+
+	/* read payload data */
+	append_seq_fifo_load(desc, 0, FIFOLD_CLASS_CLASS1 | FIFOLDST_VLF |
+			     FIFOLD_TYPE_MSG | FIFOLD_TYPE_FLUSH1);
+
+	/* jump the zero-payload commands */
+	append_jump(desc, JUMP_TEST_ALL | 4);
+
+	/* zero-payload command */
+	set_jump_tgt_here(desc, zero_payload_jump_cmd);
+
+	/* if assoclen is ZERO, jump to ICV reading */
+	append_math_add(desc, VARSEQINLEN, ZERO, REG1, CAAM_CMD_SZ);
+	zero_assoc_jump_cmd2 = append_jump(desc, JUMP_TEST_ALL |
+					   JUMP_COND_MATH_Z);
+	/* read assoc data */
+	append_seq_fifo_load(desc, 0, FIFOLD_CLASS_CLASS1 | FIFOLDST_VLF |
+			     FIFOLD_TYPE_AAD | FIFOLD_TYPE_FLUSH1);
+	set_jump_tgt_here(desc, zero_assoc_jump_cmd2);
+
+	/* read ICV */
+	append_seq_fifo_load(desc, ctx->authsize, FIFOLD_CLASS_CLASS1 |
+			     FIFOLD_TYPE_ICV | FIFOLD_TYPE_LAST1);
+
+	ctx->sh_desc_dec_dma = dma_map_single(jrdev, desc,
+					      desc_bytes(desc),
+					      DMA_TO_DEVICE);
+	if (dma_mapping_error(jrdev, ctx->sh_desc_dec_dma)) {
+		dev_err(jrdev, "unable to map shared descriptor\n");
+		return -ENOMEM;
+	}
+#ifdef DEBUG
+	print_hex_dump(KERN_ERR, "gcm dec shdesc@"__stringify(__LINE__)": ",
+		       DUMP_PREFIX_ADDRESS, 16, 4, desc,
+		       desc_bytes(desc), 1);
+#endif
+
+	return 0;
+}
+
+static int gcm_setauthsize(struct crypto_aead *authenc, unsigned int authsize)
+{
+	struct caam_ctx *ctx = crypto_aead_ctx(authenc);
+
+	ctx->authsize = authsize;
+	gcm_set_sh_desc(authenc);
+
+	return 0;
+}
+
 static u32 gen_split_aead_key(struct caam_ctx *ctx, const u8 *key_in,
 			      u32 authkeylen)
 {
@@ -703,6 +936,36 @@ badkey:
 	return -EINVAL;
 }
 
+static int gcm_setkey(struct crypto_aead *aead,
+		      const u8 *key, unsigned int keylen)
+{
+	struct caam_ctx *ctx = crypto_aead_ctx(aead);
+	struct device *jrdev = ctx->jrdev;
+	int ret = 0;
+
+#ifdef DEBUG
+	print_hex_dump(KERN_ERR, "key in @"__stringify(__LINE__)": ",
+		       DUMP_PREFIX_ADDRESS, 16, 4, key, keylen, 1);
+#endif
+
+	memcpy(ctx->key, key, keylen);
+	ctx->key_dma = dma_map_single(jrdev, ctx->key, keylen,
+				      DMA_TO_DEVICE);
+	if (dma_mapping_error(jrdev, ctx->key_dma)) {
+		dev_err(jrdev, "unable to map key i/o memory\n");
+		return -ENOMEM;
+	}
+	ctx->enckeylen = keylen;
+
+	ret = gcm_set_sh_desc(aead);
+	if (ret) {
+		dma_unmap_single(jrdev, ctx->key_dma, ctx->enckeylen,
+				 DMA_TO_DEVICE);
+	}
+
+	return ret;
+}
+
 static int ablkcipher_setkey(struct crypto_ablkcipher *ablkcipher,
 			     const u8 *key, unsigned int keylen)
 {
@@ -1292,6 +1555,7 @@ static struct aead_edesc *aead_edesc_alloc(struct aead_request *req,
 	int ivsize = crypto_aead_ivsize(aead);
 	int sec4_sg_index, sec4_sg_len = 0, sec4_sg_bytes;
 	unsigned int authsize = ctx->authsize;
+	bool is_gcm = false;
 
 	assoc_nents = sg_count(req->assoc, req->assoclen, &assoc_chained);
 
@@ -1326,15 +1590,31 @@ static struct aead_edesc *aead_edesc_alloc(struct aead_request *req,
 		return ERR_PTR(-ENOMEM);
 	}
 
-	/* Check if data are contiguous */
-	if (assoc_nents || sg_dma_address(req->assoc) + req->assoclen !=
-	    iv_dma || src_nents || iv_dma + ivsize !=
-	    sg_dma_address(req->src)) {
-		all_contig = false;
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
 		assoc_nents = assoc_nents ? : 1;
 		src_nents = src_nents ? : 1;
 		sec4_sg_len = assoc_nents + 1 + src_nents;
 	}
+
 	sec4_sg_len += dst_nents;
 
 	sec4_sg_bytes = sec4_sg_len * sizeof(struct sec4_sg_entry);
@@ -1361,14 +1641,26 @@ static struct aead_edesc *aead_edesc_alloc(struct aead_request *req,
 
 	sec4_sg_index = 0;
 	if (!all_contig) {
-		sg_to_sec4_sg(req->assoc,
-			      (assoc_nents ? : 1),
-			      edesc->sec4_sg +
-			      sec4_sg_index, 0);
-		sec4_sg_index += assoc_nents ? : 1;
+		if (!is_gcm) {
+			sg_to_sec4_sg(req->assoc,
+				      (assoc_nents ? : 1),
+				      edesc->sec4_sg +
+				      sec4_sg_index, 0);
+			sec4_sg_index += assoc_nents ? : 1;
+		}
+
 		dma_to_sec4_sg_one(edesc->sec4_sg + sec4_sg_index,
 				   iv_dma, ivsize, 0);
 		sec4_sg_index += 1;
+
+		if (is_gcm) {
+			sg_to_sec4_sg(req->assoc,
+				      (assoc_nents ? : 1),
+				      edesc->sec4_sg +
+				      sec4_sg_index, 0);
+			sec4_sg_index += assoc_nents ? : 1;
+		}
+
 		sg_to_sec4_sg_last(req->src,
 				   (src_nents ? : 1),
 				   edesc->sec4_sg +
@@ -2309,6 +2601,24 @@ static struct caam_alg_template driver_algs[] = {
 				   OP_ALG_AAI_HMAC_PRECOMP,
 		.alg_op = OP_ALG_ALGSEL_SHA512 | OP_ALG_AAI_HMAC,
 	},
+	/* Galois Counter Mode */
+	{
+		.name = "gcm(aes)",
+		.driver_name = "gcm-aes-caam",
+		.blocksize = 1,
+		.type = CRYPTO_ALG_TYPE_AEAD,
+		.template_aead = {
+			.setkey = gcm_setkey,
+			.setauthsize = gcm_setauthsize,
+			.encrypt = aead_encrypt,
+			.decrypt = aead_decrypt,
+			.givencrypt = NULL,
+			.geniv = "<built-in>",
+			.ivsize = 12,
+			.maxauthsize = 16,
+			},
+		.class1_alg_type = OP_ALG_ALGSEL_AES | OP_ALG_AAI_GCM,
+	},
 	/* ablkcipher descriptor */
 	{
 		.name = "cbc(aes)",
-- 
1.8.3.1
