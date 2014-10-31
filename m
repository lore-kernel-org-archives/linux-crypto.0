From: Catalin Vasile <catalin.vasile@freescale.com>
Subject: [PATCH 4/4] crypto: caam - add support for givencrypt cbc(aes) and rfc3686(ctr(aes))
Date: Fri, 31 Oct 2014 12:45:38 +0200
Message-ID: <1414752338-5711-4-git-send-email-catalin.vasile@freescale.com>
References: <1414752338-5711-1-git-send-email-catalin.vasile@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <herbert@gondor.apana.org.au>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1bon0143.outbound.protection.outlook.com ([157.56.111.143]:20192
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757608AbaJaLAy (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 31 Oct 2014 07:00:54 -0400
In-Reply-To: <1414752338-5711-1-git-send-email-catalin.vasile@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add support for one-shot givencrypt algorithms.
Givencrypt algorithms will generate their IV and encrypt data
within the same shared job descriptors.
Current algorithms merged from ablkcipher to givencrypt are:
 - AES Cipher Block Chaining (CBC)
 - AES Counter Mode (CTR) compliant with RFC3686

Signed-off-by: Catalin Vasile <catalin.vasile@freescale.com>
---
 drivers/crypto/caam/caamalg.c | 285 +++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 281 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index cdcc6cb..3e0492c 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -1396,6 +1396,7 @@ static int ablkcipher_setkey(struct crypto_ablkcipher *ablkcipher,
 	u32 *key_jump_cmd;
 	u32 *desc;
 	u32 *nonce;
+	u32 geniv;
 	u32 ctx1_iv_off = 0;
 	const bool ctr_mode = ((ctx->class1_alg_type & OP_ALG_AAI_MASK) ==
 			       OP_ALG_AAI_CTR_MOD128);
@@ -1554,6 +1555,83 @@ static int ablkcipher_setkey(struct crypto_ablkcipher *ablkcipher,
 		       DUMP_PREFIX_ADDRESS, 16, 4, desc,
 		       desc_bytes(desc), 1);
 #endif
+	/* ablkcipher_givencrypt shared descriptor */
+	desc = ctx->sh_desc_givenc;
+
+	init_sh_desc(desc, HDR_SHARE_SERIAL | HDR_SAVECTX);
+	/* Skip if already shared */
+	key_jump_cmd = append_jump(desc, JUMP_JSL | JUMP_TEST_ALL |
+				   JUMP_COND_SHRD);
+
+	/* Load class1 key only */
+	append_key_as_imm(desc, (void *)ctx->key, ctx->enckeylen,
+			  ctx->enckeylen, CLASS_1 |
+			  KEY_DEST_CLASS_REG);
+
+	/* Load Nonce into CONTEXT1 reg */
+	if (is_rfc3686) {
+		nonce = (u32 *)(key + keylen);
+		append_load_imm_u32(desc, *nonce, LDST_CLASS_IND_CCB |
+				    LDST_SRCDST_BYTE_OUTFIFO | LDST_IMM);
+		append_move(desc, MOVE_WAITCOMP |
+			    MOVE_SRC_OUTFIFO |
+			    MOVE_DEST_CLASS1CTX |
+			    (16 << MOVE_OFFSET_SHIFT) |
+			    (CTR_RFC3686_NONCE_SIZE << MOVE_LEN_SHIFT));
+	}
+	set_jump_tgt_here(desc, key_jump_cmd);
+
+	/* Generate IV */
+	geniv = NFIFOENTRY_STYPE_PAD | NFIFOENTRY_DEST_DECO |
+		NFIFOENTRY_DTYPE_MSG | NFIFOENTRY_LC1 |
+		NFIFOENTRY_PTYPE_RND | (crt->ivsize << NFIFOENTRY_DLEN_SHIFT);
+	append_load_imm_u32(desc, geniv, LDST_CLASS_IND_CCB |
+			    LDST_SRCDST_WORD_INFO_FIFO | LDST_IMM);
+	append_cmd(desc, CMD_LOAD | DISABLE_AUTO_INFO_FIFO);
+	append_move(desc, MOVE_WAITCOMP |
+		    MOVE_SRC_INFIFO |
+		    MOVE_DEST_CLASS1CTX |
+		    (crt->ivsize << MOVE_LEN_SHIFT) |
+		    (ctx1_iv_off << MOVE_OFFSET_SHIFT));
+	append_cmd(desc, CMD_LOAD | ENABLE_AUTO_INFO_FIFO);
+
+	/* Copy generated IV to memory */
+	append_seq_store(desc, crt->ivsize,
+			 LDST_SRCDST_BYTE_CONTEXT | LDST_CLASS_1_CCB |
+			 (ctx1_iv_off << LDST_OFFSET_SHIFT));
+
+	/* Load Counter into CONTEXT1 reg */
+	if (is_rfc3686)
+		append_load_imm_u32(desc, (u32)1, LDST_IMM |
+				    LDST_CLASS_1_CCB |
+				    LDST_SRCDST_BYTE_CONTEXT |
+				    ((ctx1_iv_off + CTR_RFC3686_IV_SIZE) <<
+				     LDST_OFFSET_SHIFT));
+
+	if (ctx1_iv_off)
+		append_jump(desc, JUMP_JSL | JUMP_TEST_ALL | JUMP_COND_NCP |
+			    (1 << JUMP_OFFSET_SHIFT));
+
+	/* Load operation */
+	append_operation(desc, ctx->class1_alg_type |
+			 OP_ALG_AS_INITFINAL | OP_ALG_ENCRYPT);
+
+	/* Perform operation */
+	ablkcipher_append_src_dst(desc);
+
+	ctx->sh_desc_givenc_dma = dma_map_single(jrdev, desc,
+						 desc_bytes(desc),
+						 DMA_TO_DEVICE);
+	if (dma_mapping_error(jrdev, ctx->sh_desc_givenc_dma)) {
+		dev_err(jrdev, "unable to map shared descriptor\n");
+		return -ENOMEM;
+	}
+#ifdef DEBUG
+	print_hex_dump(KERN_ERR,
+		       "ablkcipher givenc shdesc@" __stringify(__LINE__) ": ",
+		       DUMP_PREFIX_ADDRESS, 16, 4, desc,
+		       desc_bytes(desc), 1);
+#endif
 
 	return ret;
 }
@@ -2041,6 +2119,54 @@ static void init_ablkcipher_job(u32 *sh_desc, dma_addr_t ptr,
 }
 
 /*
+ * Fill in ablkcipher givencrypt job descriptor
+ */
+static void init_ablkcipher_giv_job(u32 *sh_desc, dma_addr_t ptr,
+				    struct ablkcipher_edesc *edesc,
+				    struct ablkcipher_request *req,
+				    bool iv_contig)
+{
+	struct crypto_ablkcipher *ablkcipher = crypto_ablkcipher_reqtfm(req);
+	int ivsize = crypto_ablkcipher_ivsize(ablkcipher);
+	u32 *desc = edesc->hw_desc;
+	u32 out_options, in_options;
+	dma_addr_t dst_dma, src_dma;
+	int len, sec4_sg_index = 0;
+
+#ifdef DEBUG
+	print_hex_dump(KERN_ERR, "presciv@" __stringify(__LINE__) ": ",
+		       DUMP_PREFIX_ADDRESS, 16, 4, req->info,
+		       ivsize, 1);
+	print_hex_dump(KERN_ERR, "src    @" __stringify(__LINE__) ": ",
+		       DUMP_PREFIX_ADDRESS, 16, 4, sg_virt(req->src),
+		       edesc->src_nents ? 100 : req->nbytes, 1);
+#endif
+
+	len = desc_len(sh_desc);
+	init_job_desc_shared(desc, ptr, len, HDR_SHARE_DEFER | HDR_REVERSE);
+
+	if (!edesc->src_nents) {
+		src_dma = sg_dma_address(req->src);
+		in_options = 0;
+	} else {
+		src_dma = edesc->sec4_sg_dma;
+		sec4_sg_index += edesc->src_nents;
+		in_options = LDST_SGF;
+	}
+	append_seq_in_ptr(desc, src_dma, req->nbytes, in_options);
+
+	if (iv_contig) {
+		dst_dma = edesc->iv_dma;
+		out_options = 0;
+	} else {
+		dst_dma = edesc->sec4_sg_dma +
+			  sec4_sg_index * sizeof(struct sec4_sg_entry);
+		out_options = LDST_SGF;
+	}
+	append_seq_out_ptr(desc, dst_dma, req->nbytes + ivsize, out_options);
+}
+
+/*
  * allocate and map the aead extended descriptor
  */
 static struct aead_edesc *aead_edesc_alloc(struct aead_request *req,
@@ -2659,6 +2785,151 @@ static int ablkcipher_decrypt(struct ablkcipher_request *req)
 	return ret;
 }
 
+/*
+ * allocate and map the ablkcipher extended descriptor
+ * for ablkcipher givencrypt
+ */
+static struct ablkcipher_edesc *ablkcipher_giv_edesc_alloc(
+				struct skcipher_givcrypt_request *greq,
+				int desc_bytes,
+				bool *iv_contig_out)
+{
+	struct ablkcipher_request *req = &greq->creq;
+	struct crypto_ablkcipher *ablkcipher = crypto_ablkcipher_reqtfm(req);
+	struct caam_ctx *ctx = crypto_ablkcipher_ctx(ablkcipher);
+	struct device *jrdev = ctx->jrdev;
+	gfp_t flags = (req->base.flags & (CRYPTO_TFM_REQ_MAY_BACKLOG |
+					  CRYPTO_TFM_REQ_MAY_SLEEP)) ?
+		       GFP_KERNEL : GFP_ATOMIC;
+	int src_nents, dst_nents = 0, sec4_sg_bytes;
+	struct ablkcipher_edesc *edesc;
+	dma_addr_t iv_dma = 0;
+	bool iv_contig = false;
+	int sgc;
+	int ivsize = crypto_ablkcipher_ivsize(ablkcipher);
+	bool src_chained = false, dst_chained = false;
+	int sec4_sg_index;
+
+	src_nents = sg_count(req->src, req->nbytes, &src_chained);
+
+	if (unlikely(req->dst != req->src))
+		dst_nents = sg_count(req->dst, req->nbytes, &dst_chained);
+
+	if (likely(req->src == req->dst)) {
+		sgc = dma_map_sg_chained(jrdev, req->src, src_nents ? : 1,
+					 DMA_BIDIRECTIONAL, src_chained);
+	} else {
+		sgc = dma_map_sg_chained(jrdev, req->src, src_nents ? : 1,
+					 DMA_TO_DEVICE, src_chained);
+		sgc = dma_map_sg_chained(jrdev, req->dst, dst_nents ? : 1,
+					 DMA_FROM_DEVICE, dst_chained);
+	}
+
+	/*
+	 * Check if iv can be contiguous with source and destination.
+	 * If so, include it. If not, create scatterlist.
+	 */
+	iv_dma = dma_map_single(jrdev, greq->giv, ivsize, DMA_TO_DEVICE);
+	if (dma_mapping_error(jrdev, iv_dma)) {
+		dev_err(jrdev, "unable to map IV\n");
+		return ERR_PTR(-ENOMEM);
+	}
+
+	if (!dst_nents && iv_dma + ivsize == sg_dma_address(req->dst))
+		iv_contig = true;
+	else
+		dst_nents = dst_nents ? : 1;
+	sec4_sg_bytes = ((iv_contig ? 0 : 1) + src_nents + dst_nents) *
+			sizeof(struct sec4_sg_entry);
+
+	/* allocate space for base edesc and hw desc commands, link tables */
+	edesc = kmalloc(sizeof(*edesc) + desc_bytes +
+			sec4_sg_bytes, GFP_DMA | flags);
+	if (!edesc) {
+		dev_err(jrdev, "could not allocate extended descriptor\n");
+		return ERR_PTR(-ENOMEM);
+	}
+
+	edesc->src_nents = src_nents;
+	edesc->src_chained = src_chained;
+	edesc->dst_nents = dst_nents;
+	edesc->dst_chained = dst_chained;
+	edesc->sec4_sg_bytes = sec4_sg_bytes;
+	edesc->sec4_sg = (void *)edesc + sizeof(struct ablkcipher_edesc) +
+			 desc_bytes;
+
+	sec4_sg_index = 0;
+	if (src_nents) {
+		sg_to_sec4_sg_last(req->src, src_nents, edesc->sec4_sg, 0);
+		sec4_sg_index += src_nents;
+	}
+
+	if (!iv_contig) {
+		dma_to_sec4_sg_one(edesc->sec4_sg + sec4_sg_index,
+				   iv_dma, ivsize, 0);
+		sec4_sg_index += 1;
+		sg_to_sec4_sg_last(req->dst, dst_nents,
+				   edesc->sec4_sg + sec4_sg_index, 0);
+	}
+
+	edesc->sec4_sg_dma = dma_map_single(jrdev, edesc->sec4_sg,
+					    sec4_sg_bytes, DMA_TO_DEVICE);
+	if (dma_mapping_error(jrdev, edesc->sec4_sg_dma)) {
+		dev_err(jrdev, "unable to map S/G table\n");
+		return ERR_PTR(-ENOMEM);
+	}
+	edesc->iv_dma = iv_dma;
+
+#ifdef DEBUG
+	print_hex_dump(KERN_ERR,
+		       "ablkcipher sec4_sg@" __stringify(__LINE__) ": ",
+		       DUMP_PREFIX_ADDRESS, 16, 4, edesc->sec4_sg,
+		       sec4_sg_bytes, 1);
+#endif
+
+	*iv_contig_out = iv_contig;
+	return edesc;
+}
+
+static int ablkcipher_givencrypt(struct skcipher_givcrypt_request *creq)
+{
+	struct ablkcipher_request *req = &creq->creq;
+	struct ablkcipher_edesc *edesc;
+	struct crypto_ablkcipher *ablkcipher = crypto_ablkcipher_reqtfm(req);
+	struct caam_ctx *ctx = crypto_ablkcipher_ctx(ablkcipher);
+	struct device *jrdev = ctx->jrdev;
+	bool iv_contig;
+	u32 *desc;
+	int ret = 0;
+
+	/* allocate extended descriptor */
+	edesc = ablkcipher_giv_edesc_alloc(creq, DESC_JOB_IO_LEN *
+				       CAAM_CMD_SZ, &iv_contig);
+	if (IS_ERR(edesc))
+		return PTR_ERR(edesc);
+
+	/* Create and submit job descriptor*/
+	init_ablkcipher_giv_job(ctx->sh_desc_givenc, ctx->sh_desc_givenc_dma,
+				edesc, req, iv_contig);
+#ifdef DEBUG
+	print_hex_dump(KERN_ERR,
+		       "ablkcipher jobdesc@" __stringify(__LINE__) ": ",
+		       DUMP_PREFIX_ADDRESS, 16, 4, edesc->hw_desc,
+		       desc_bytes(edesc->hw_desc), 1);
+#endif
+	desc = edesc->hw_desc;
+	ret = caam_jr_enqueue(jrdev, desc, ablkcipher_encrypt_done, req);
+
+	if (!ret) {
+		ret = -EINPROGRESS;
+	} else {
+		ablkcipher_unmap(jrdev, edesc, req);
+		kfree(edesc);
+	}
+
+	return ret;
+}
+
 #define template_aead		template_u.aead
 #define template_ablkcipher	template_u.ablkcipher
 struct caam_alg_template {
@@ -3312,12 +3583,13 @@ static struct caam_alg_template driver_algs[] = {
 		.name = "cbc(aes)",
 		.driver_name = "cbc-aes-caam",
 		.blocksize = AES_BLOCK_SIZE,
-		.type = CRYPTO_ALG_TYPE_ABLKCIPHER,
+		.type = CRYPTO_ALG_TYPE_GIVCIPHER,
 		.template_ablkcipher = {
 			.setkey = ablkcipher_setkey,
 			.encrypt = ablkcipher_encrypt,
 			.decrypt = ablkcipher_decrypt,
-			.geniv = "eseqiv",
+			.givencrypt = ablkcipher_givencrypt,
+			.geniv = "<built-in>",
 			.min_keysize = AES_MIN_KEY_SIZE,
 			.max_keysize = AES_MAX_KEY_SIZE,
 			.ivsize = AES_BLOCK_SIZE,
@@ -3376,12 +3648,13 @@ static struct caam_alg_template driver_algs[] = {
 		.name = "rfc3686(ctr(aes))",
 		.driver_name = "rfc3686-ctr-aes-caam",
 		.blocksize = 1,
-		.type = CRYPTO_ALG_TYPE_ABLKCIPHER,
+		.type = CRYPTO_ALG_TYPE_GIVCIPHER,
 		.template_ablkcipher = {
 			.setkey = ablkcipher_setkey,
 			.encrypt = ablkcipher_encrypt,
 			.decrypt = ablkcipher_decrypt,
-			.geniv = "seqiv",
+			.givencrypt = ablkcipher_givencrypt,
+			.geniv = "<built-in>",
 			.min_keysize = AES_MIN_KEY_SIZE +
 				       CTR_RFC3686_NONCE_SIZE,
 			.max_keysize = AES_MAX_KEY_SIZE +
@@ -3489,6 +3762,10 @@ static struct caam_crypto_alg *caam_alg_alloc(struct caam_alg_template
 	alg->cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_KERN_DRIVER_ONLY |
 			 template->type;
 	switch (template->type) {
+	case CRYPTO_ALG_TYPE_GIVCIPHER:
+		alg->cra_type = &crypto_givcipher_type;
+		alg->cra_ablkcipher = template->template_ablkcipher;
+		break;
 	case CRYPTO_ALG_TYPE_ABLKCIPHER:
 		alg->cra_type = &crypto_ablkcipher_type;
 		alg->cra_ablkcipher = template->template_ablkcipher;
-- 
1.8.3.1
