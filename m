From: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
Subject: [RFC PATCH] crypto: caam - convert from ablkcipher -> skcipher
Date: Mon, 29 Aug 2016 17:11:24 +0300
Message-ID: <1472479884-1887-1-git-send-email-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: <linux-crypto@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2nam01on0042.outbound.protection.outlook.com ([104.47.34.42]:45312
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1757376AbcH2O2y (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 29 Aug 2016 10:28:54 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

(a)blkcipher is being deprecated in favcur of skcipher.
The main difference is that IV generation is moved out
of crypto algorithms.

Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
---

Herbert,

The handling of IV generation is blindly following the lines of
previous commit:
479bcc7c5b9e "crypto: caam - Convert authenc to new AEAD interface"

but I am not sure block ciphers with IV generation - for e.g.
seqiv(rfc3686(ctr(aes))) - make any sense and/or are useful.

Comments appreciated.

Thanks,
Horia

 drivers/crypto/caam/caamalg.c | 898 +++++++++++++++++-------------------------
 drivers/crypto/caam/compat.h  |   1 +
 2 files changed, 370 insertions(+), 529 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index b3044219772c..787f6595fd67 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -111,7 +111,6 @@
 #else
 #define debug(format, arg...)
 #endif
-static struct list_head alg_list;
 
 struct caam_alg_entry {
 	int class1_alg_type;
@@ -127,6 +126,12 @@ struct caam_aead_alg {
 	bool registered;
 };
 
+struct caam_skcipher_alg {
+	struct skcipher_alg skcipher;
+	struct caam_alg_entry caam;
+	bool registered;
+};
+
 /* Set DK bit in class 1 operation if shared */
 static inline void append_dec_op1(u32 *desc, u32 type)
 {
@@ -161,10 +166,10 @@ static inline void aead_append_src_dst(u32 *desc, u32 msg_type)
 }
 
 /*
- * For ablkcipher encrypt and decrypt, read from req->src and
+ * For skcipher encrypt and decrypt, read from req->src and
  * write to req->dst
  */
-static inline void ablkcipher_append_src_dst(u32 *desc)
+static inline void skcipher_append_src_dst(u32 *desc)
 {
 	append_math_add(desc, VARSEQOUTLEN, SEQINLEN, REG0, CAAM_CMD_SZ);
 	append_math_add(desc, VARSEQINLEN, SEQINLEN, REG0, CAAM_CMD_SZ);
@@ -1467,13 +1472,13 @@ static int rfc4543_setkey(struct crypto_aead *aead,
 	return ret;
 }
 
-static int ablkcipher_setkey(struct crypto_ablkcipher *ablkcipher,
-			     const u8 *key, unsigned int keylen)
+static int skcipher_setkey(struct crypto_skcipher *skcipher, const u8 *key,
+			   unsigned int keylen)
 {
-	struct caam_ctx *ctx = crypto_ablkcipher_ctx(ablkcipher);
-	struct ablkcipher_tfm *crt = &ablkcipher->base.crt_ablkcipher;
-	struct crypto_tfm *tfm = crypto_ablkcipher_tfm(ablkcipher);
-	const char *alg_name = crypto_tfm_alg_name(tfm);
+	struct caam_skcipher_alg *alg =
+		container_of(crypto_skcipher_alg(skcipher),
+			     struct caam_skcipher_alg, skcipher);
+	struct caam_ctx *ctx = crypto_skcipher_ctx(skcipher);
 	struct device *jrdev = ctx->jrdev;
 	int ret = 0;
 	u32 *key_jump_cmd;
@@ -1481,10 +1486,10 @@ static int ablkcipher_setkey(struct crypto_ablkcipher *ablkcipher,
 	u32 *nonce;
 	u32 geniv;
 	u32 ctx1_iv_off = 0;
+	unsigned int ivsize = crypto_skcipher_ivsize(skcipher);
 	const bool ctr_mode = ((ctx->class1_alg_type & OP_ALG_AAI_MASK) ==
 			       OP_ALG_AAI_CTR_MOD128);
-	const bool is_rfc3686 = (ctr_mode &&
-				 (strstr(alg_name, "rfc3686") != NULL));
+	const bool is_rfc3686 = alg->caam.rfc3686;
 
 #ifdef DEBUG
 	print_hex_dump(KERN_ERR, "key in @"__stringify(__LINE__)": ",
@@ -1517,7 +1522,10 @@ static int ablkcipher_setkey(struct crypto_ablkcipher *ablkcipher,
 	}
 	ctx->enckeylen = keylen;
 
-	/* ablkcipher_encrypt shared descriptor */
+	if (alg->caam.geniv)
+		goto skip_enc;
+
+	/* skcipher_encrypt shared descriptor */
 	desc = ctx->sh_desc_enc;
 	init_sh_desc(desc, HDR_SHARE_SERIAL | HDR_SAVECTX);
 	/* Skip if already shared */
@@ -1543,10 +1551,6 @@ static int ablkcipher_setkey(struct crypto_ablkcipher *ablkcipher,
 
 	set_jump_tgt_here(desc, key_jump_cmd);
 
-	/* Load iv */
-	append_seq_load(desc, crt->ivsize, LDST_SRCDST_BYTE_CONTEXT |
-			LDST_CLASS_1_CCB | (ctx1_iv_off << LDST_OFFSET_SHIFT));
-
 	/* Load counter into CONTEXT1 reg */
 	if (is_rfc3686)
 		append_load_imm_u32(desc, be32_to_cpu(1), LDST_IMM |
@@ -1560,7 +1564,7 @@ static int ablkcipher_setkey(struct crypto_ablkcipher *ablkcipher,
 			 OP_ALG_AS_INITFINAL | OP_ALG_ENCRYPT);
 
 	/* Perform operation */
-	ablkcipher_append_src_dst(desc);
+	skcipher_append_src_dst(desc);
 
 	ctx->sh_desc_enc_dma = dma_map_single(jrdev, desc,
 					      desc_bytes(desc),
@@ -1571,11 +1575,13 @@ static int ablkcipher_setkey(struct crypto_ablkcipher *ablkcipher,
 	}
 #ifdef DEBUG
 	print_hex_dump(KERN_ERR,
-		       "ablkcipher enc shdesc@"__stringify(__LINE__)": ",
+		       "skcipher enc shdesc@"__stringify(__LINE__)": ",
 		       DUMP_PREFIX_ADDRESS, 16, 4, desc,
 		       desc_bytes(desc), 1);
 #endif
-	/* ablkcipher_decrypt shared descriptor */
+
+skip_enc:
+	/* skcipher_decrypt shared descriptor */
 	desc = ctx->sh_desc_dec;
 
 	init_sh_desc(desc, HDR_SHARE_SERIAL | HDR_SAVECTX);
@@ -1602,10 +1608,6 @@ static int ablkcipher_setkey(struct crypto_ablkcipher *ablkcipher,
 
 	set_jump_tgt_here(desc, key_jump_cmd);
 
-	/* load IV */
-	append_seq_load(desc, crt->ivsize, LDST_SRCDST_BYTE_CONTEXT |
-			LDST_CLASS_1_CCB | (ctx1_iv_off << LDST_OFFSET_SHIFT));
-
 	/* Load counter into CONTEXT1 reg */
 	if (is_rfc3686)
 		append_load_imm_u32(desc, be32_to_cpu(1), LDST_IMM |
@@ -1622,7 +1624,7 @@ static int ablkcipher_setkey(struct crypto_ablkcipher *ablkcipher,
 		append_dec_op1(desc, ctx->class1_alg_type);
 
 	/* Perform operation */
-	ablkcipher_append_src_dst(desc);
+	skcipher_append_src_dst(desc);
 
 	ctx->sh_desc_dec_dma = dma_map_single(jrdev, desc,
 					      desc_bytes(desc),
@@ -1634,12 +1636,16 @@ static int ablkcipher_setkey(struct crypto_ablkcipher *ablkcipher,
 
 #ifdef DEBUG
 	print_hex_dump(KERN_ERR,
-		       "ablkcipher dec shdesc@"__stringify(__LINE__)": ",
+		       "skcipher dec shdesc@"__stringify(__LINE__)": ",
 		       DUMP_PREFIX_ADDRESS, 16, 4, desc,
 		       desc_bytes(desc), 1);
 #endif
-	/* ablkcipher_givencrypt shared descriptor */
-	desc = ctx->sh_desc_givenc;
+
+	if (!alg->caam.geniv)
+		goto skip_givenc;
+
+	/* skcipher_givencrypt shared descriptor */
+	desc = ctx->sh_desc_enc;
 
 	init_sh_desc(desc, HDR_SHARE_SERIAL | HDR_SAVECTX);
 	/* Skip if already shared */
@@ -1664,24 +1670,27 @@ static int ablkcipher_setkey(struct crypto_ablkcipher *ablkcipher,
 	}
 	set_jump_tgt_here(desc, key_jump_cmd);
 
+	if (is_rfc3686)
+		goto copy_iv;
+
 	/* Generate IV */
 	geniv = NFIFOENTRY_STYPE_PAD | NFIFOENTRY_DEST_DECO |
 		NFIFOENTRY_DTYPE_MSG | NFIFOENTRY_LC1 |
-		NFIFOENTRY_PTYPE_RND | (crt->ivsize << NFIFOENTRY_DLEN_SHIFT);
+		NFIFOENTRY_PTYPE_RND | (ivsize << NFIFOENTRY_DLEN_SHIFT);
 	append_load_imm_u32(desc, geniv, LDST_CLASS_IND_CCB |
 			    LDST_SRCDST_WORD_INFO_FIFO | LDST_IMM);
 	append_cmd(desc, CMD_LOAD | DISABLE_AUTO_INFO_FIFO);
 	append_move(desc, MOVE_WAITCOMP |
 		    MOVE_SRC_INFIFO |
 		    MOVE_DEST_CLASS1CTX |
-		    (crt->ivsize << MOVE_LEN_SHIFT) |
+		    (ivsize << MOVE_LEN_SHIFT) |
 		    (ctx1_iv_off << MOVE_OFFSET_SHIFT));
 	append_cmd(desc, CMD_LOAD | ENABLE_AUTO_INFO_FIFO);
 
+copy_iv:
 	/* Copy generated IV to memory */
-	append_seq_store(desc, crt->ivsize,
-			 LDST_SRCDST_BYTE_CONTEXT | LDST_CLASS_1_CCB |
-			 (ctx1_iv_off << LDST_OFFSET_SHIFT));
+	append_seq_store(desc, ivsize, LDST_SRCDST_BYTE_CONTEXT |
+			 LDST_CLASS_1_CCB | (ctx1_iv_off << LDST_OFFSET_SHIFT));
 
 	/* Load Counter into CONTEXT1 reg */
 	if (is_rfc3686)
@@ -1700,36 +1709,35 @@ static int ablkcipher_setkey(struct crypto_ablkcipher *ablkcipher,
 			 OP_ALG_AS_INITFINAL | OP_ALG_ENCRYPT);
 
 	/* Perform operation */
-	ablkcipher_append_src_dst(desc);
+	skcipher_append_src_dst(desc);
 
-	ctx->sh_desc_givenc_dma = dma_map_single(jrdev, desc,
-						 desc_bytes(desc),
-						 DMA_TO_DEVICE);
-	if (dma_mapping_error(jrdev, ctx->sh_desc_givenc_dma)) {
+	ctx->sh_desc_enc_dma = dma_map_single(jrdev, desc, desc_bytes(desc),
+					      DMA_TO_DEVICE);
+	if (dma_mapping_error(jrdev, ctx->sh_desc_enc_dma)) {
 		dev_err(jrdev, "unable to map shared descriptor\n");
 		return -ENOMEM;
 	}
 #ifdef DEBUG
 	print_hex_dump(KERN_ERR,
-		       "ablkcipher givenc shdesc@" __stringify(__LINE__) ": ",
+		       "skcipher givenc shdesc@" __stringify(__LINE__) ": ",
 		       DUMP_PREFIX_ADDRESS, 16, 4, desc,
 		       desc_bytes(desc), 1);
 #endif
 
+skip_givenc:
 	return ret;
 }
 
-static int xts_ablkcipher_setkey(struct crypto_ablkcipher *ablkcipher,
-				 const u8 *key, unsigned int keylen)
+static int xts_skcipher_setkey(struct crypto_skcipher *skcipher,
+			       const u8 *key, unsigned int keylen)
 {
-	struct caam_ctx *ctx = crypto_ablkcipher_ctx(ablkcipher);
+	struct caam_ctx *ctx = crypto_skcipher_ctx(skcipher);
 	struct device *jrdev = ctx->jrdev;
 	u32 *key_jump_cmd, *desc;
 	__be64 sector_size = cpu_to_be64(512);
 
 	if (keylen != 2 * AES_MIN_KEY_SIZE  && keylen != 2 * AES_MAX_KEY_SIZE) {
-		crypto_ablkcipher_set_flags(ablkcipher,
-					    CRYPTO_TFM_RES_BAD_KEY_LEN);
+		crypto_skcipher_set_flags(skcipher, CRYPTO_TFM_RES_BAD_KEY_LEN);
 		dev_err(jrdev, "key size mismatch\n");
 		return -EINVAL;
 	}
@@ -1742,7 +1750,7 @@ static int xts_ablkcipher_setkey(struct crypto_ablkcipher *ablkcipher,
 	}
 	ctx->enckeylen = keylen;
 
-	/* xts_ablkcipher_encrypt shared descriptor */
+	/* xts_skcipher_encrypt shared descriptor */
 	desc = ctx->sh_desc_enc;
 	init_sh_desc(desc, HDR_SHARE_SERIAL | HDR_SAVECTX);
 	/* Skip if already shared */
@@ -1760,21 +1768,12 @@ static int xts_ablkcipher_setkey(struct crypto_ablkcipher *ablkcipher,
 
 	set_jump_tgt_here(desc, key_jump_cmd);
 
-	/*
-	 * create sequence for loading the sector index
-	 * Upper 8B of IV - will be used as sector index
-	 * Lower 8B of IV - will be discarded
-	 */
-	append_cmd(desc, CMD_SEQ_LOAD | LDST_SRCDST_BYTE_CONTEXT |
-		   LDST_CLASS_1_CCB | (0x20 << LDST_OFFSET_SHIFT) | 8);
-	append_seq_fifo_load(desc, 8, FIFOLD_CLASS_SKIP);
-
 	/* Load operation */
 	append_operation(desc, ctx->class1_alg_type | OP_ALG_AS_INITFINAL |
 			 OP_ALG_ENCRYPT);
 
 	/* Perform operation */
-	ablkcipher_append_src_dst(desc);
+	skcipher_append_src_dst(desc);
 
 	ctx->sh_desc_enc_dma = dma_map_single(jrdev, desc, desc_bytes(desc),
 					      DMA_TO_DEVICE);
@@ -1784,11 +1783,11 @@ static int xts_ablkcipher_setkey(struct crypto_ablkcipher *ablkcipher,
 	}
 #ifdef DEBUG
 	print_hex_dump(KERN_ERR,
-		       "xts ablkcipher enc shdesc@" __stringify(__LINE__) ": ",
+		       "xts skcipher enc shdesc@" __stringify(__LINE__) ": ",
 		       DUMP_PREFIX_ADDRESS, 16, 4, desc, desc_bytes(desc), 1);
 #endif
 
-	/* xts_ablkcipher_decrypt shared descriptor */
+	/* xts_skcipher_decrypt shared descriptor */
 	desc = ctx->sh_desc_dec;
 
 	init_sh_desc(desc, HDR_SHARE_SERIAL | HDR_SAVECTX);
@@ -1807,20 +1806,11 @@ static int xts_ablkcipher_setkey(struct crypto_ablkcipher *ablkcipher,
 
 	set_jump_tgt_here(desc, key_jump_cmd);
 
-	/*
-	 * create sequence for loading the sector index
-	 * Upper 8B of IV - will be used as sector index
-	 * Lower 8B of IV - will be discarded
-	 */
-	append_cmd(desc, CMD_SEQ_LOAD | LDST_SRCDST_BYTE_CONTEXT |
-		   LDST_CLASS_1_CCB | (0x20 << LDST_OFFSET_SHIFT) | 8);
-	append_seq_fifo_load(desc, 8, FIFOLD_CLASS_SKIP);
-
 	/* Load operation */
 	append_dec_op1(desc, ctx->class1_alg_type);
 
 	/* Perform operation */
-	ablkcipher_append_src_dst(desc);
+	skcipher_append_src_dst(desc);
 
 	ctx->sh_desc_dec_dma = dma_map_single(jrdev, desc, desc_bytes(desc),
 					      DMA_TO_DEVICE);
@@ -1832,7 +1822,7 @@ static int xts_ablkcipher_setkey(struct crypto_ablkcipher *ablkcipher,
 	}
 #ifdef DEBUG
 	print_hex_dump(KERN_ERR,
-		       "xts ablkcipher dec shdesc@" __stringify(__LINE__) ": ",
+		       "xts skcipher dec shdesc@" __stringify(__LINE__) ": ",
 		       DUMP_PREFIX_ADDRESS, 16, 4, desc, desc_bytes(desc), 1);
 #endif
 
@@ -1862,7 +1852,7 @@ struct aead_edesc {
 };
 
 /*
- * ablkcipher_edesc - s/w-extended ablkcipher descriptor
+ * skcipher_edesc - s/w-extended skcipher descriptor
  * @src_nents: number of segments in input scatterlist
  * @dst_nents: number of segments in output scatterlist
  * @iv_dma: dma address of iv for checking continuity and link table
@@ -1871,7 +1861,7 @@ struct aead_edesc {
  * @sec4_sg_dma: bus physical mapped address of h/w link table
  * @hw_desc: the h/w job descriptor followed by any referenced link tables
  */
-struct ablkcipher_edesc {
+struct skcipher_edesc {
 	int src_nents;
 	int dst_nents;
 	dma_addr_t iv_dma;
@@ -1910,16 +1900,11 @@ static void aead_unmap(struct device *dev,
 		   edesc->sec4_sg_dma, edesc->sec4_sg_bytes);
 }
 
-static void ablkcipher_unmap(struct device *dev,
-			     struct ablkcipher_edesc *edesc,
-			     struct ablkcipher_request *req)
+static void skcipher_unmap(struct device *dev, struct skcipher_edesc *edesc,
+			   struct skcipher_request *req)
 {
-	struct crypto_ablkcipher *ablkcipher = crypto_ablkcipher_reqtfm(req);
-	int ivsize = crypto_ablkcipher_ivsize(ablkcipher);
-
 	caam_unmap(dev, req->src, req->dst,
-		   edesc->src_nents, edesc->dst_nents,
-		   edesc->iv_dma, ivsize,
+		   edesc->src_nents, edesc->dst_nents, 0, 0,
 		   edesc->sec4_sg_dma, edesc->sec4_sg_bytes);
 }
 
@@ -1973,69 +1958,69 @@ static void aead_decrypt_done(struct device *jrdev, u32 *desc, u32 err,
 	aead_request_complete(req, err);
 }
 
-static void ablkcipher_encrypt_done(struct device *jrdev, u32 *desc, u32 err,
-				   void *context)
+static void skcipher_encrypt_done(struct device *jrdev, u32 *desc, u32 err,
+				  void *context)
 {
-	struct ablkcipher_request *req = context;
-	struct ablkcipher_edesc *edesc;
+	struct skcipher_request *req = context;
+	struct skcipher_edesc *edesc;
 #ifdef DEBUG
-	struct crypto_ablkcipher *ablkcipher = crypto_ablkcipher_reqtfm(req);
-	int ivsize = crypto_ablkcipher_ivsize(ablkcipher);
+	struct crypto_skcipher *skcipher = crypto_skcipher_reqtfm(req);
+	int ivsize = crypto_skcipher_ivsize(skcipher);
 
 	dev_err(jrdev, "%s %d: err 0x%x\n", __func__, __LINE__, err);
 #endif
 
-	edesc = (struct ablkcipher_edesc *)((char *)desc -
-		 offsetof(struct ablkcipher_edesc, hw_desc));
+	edesc = (struct skcipher_edesc *)((char *)desc -
+		 offsetof(struct skcipher_edesc, hw_desc));
 
 	if (err)
 		caam_jr_strstatus(jrdev, err);
 
 #ifdef DEBUG
 	print_hex_dump(KERN_ERR, "dstiv  @"__stringify(__LINE__)": ",
-		       DUMP_PREFIX_ADDRESS, 16, 4, req->info,
+		       DUMP_PREFIX_ADDRESS, 16, 4, req->iv,
 		       edesc->src_nents > 1 ? 100 : ivsize, 1);
 	print_hex_dump(KERN_ERR, "dst    @"__stringify(__LINE__)": ",
 		       DUMP_PREFIX_ADDRESS, 16, 4, sg_virt(req->src),
-		       edesc->dst_nents > 1 ? 100 : req->nbytes, 1);
+		       edesc->dst_nents > 1 ? 100 : req->cryptlen, 1);
 #endif
 
-	ablkcipher_unmap(jrdev, edesc, req);
+	skcipher_unmap(jrdev, edesc, req);
 	kfree(edesc);
 
-	ablkcipher_request_complete(req, err);
+	skcipher_request_complete(req, err);
 }
 
-static void ablkcipher_decrypt_done(struct device *jrdev, u32 *desc, u32 err,
-				    void *context)
+static void skcipher_decrypt_done(struct device *jrdev, u32 *desc, u32 err,
+				  void *context)
 {
-	struct ablkcipher_request *req = context;
-	struct ablkcipher_edesc *edesc;
+	struct skcipher_request *req = context;
+	struct skcipher_edesc *edesc;
 #ifdef DEBUG
-	struct crypto_ablkcipher *ablkcipher = crypto_ablkcipher_reqtfm(req);
-	int ivsize = crypto_ablkcipher_ivsize(ablkcipher);
+	struct crypto_skcipher *skcipher = crypto_skcipher_reqtfm(req);
+	int ivsize = crypto_skcipher_ivsize(skcipher);
 
 	dev_err(jrdev, "%s %d: err 0x%x\n", __func__, __LINE__, err);
 #endif
 
-	edesc = (struct ablkcipher_edesc *)((char *)desc -
-		 offsetof(struct ablkcipher_edesc, hw_desc));
+	edesc = (struct skcipher_edesc *)((char *)desc -
+		 offsetof(struct skcipher_edesc, hw_desc));
 	if (err)
 		caam_jr_strstatus(jrdev, err);
 
 #ifdef DEBUG
 	print_hex_dump(KERN_ERR, "dstiv  @"__stringify(__LINE__)": ",
-		       DUMP_PREFIX_ADDRESS, 16, 4, req->info,
+		       DUMP_PREFIX_ADDRESS, 16, 4, req->iv,
 		       ivsize, 1);
 	print_hex_dump(KERN_ERR, "dst    @"__stringify(__LINE__)": ",
 		       DUMP_PREFIX_ADDRESS, 16, 4, sg_virt(req->src),
-		       edesc->dst_nents > 1 ? 100 : req->nbytes, 1);
+		       edesc->dst_nents > 1 ? 100 : req->cryptlen, 1);
 #endif
 
-	ablkcipher_unmap(jrdev, edesc, req);
+	skcipher_unmap(jrdev, edesc, req);
 	kfree(edesc);
 
-	ablkcipher_request_complete(req, err);
+	skcipher_request_complete(req, err);
 }
 
 /*
@@ -2169,85 +2154,36 @@ static void init_authenc_job(struct aead_request *req,
 }
 
 /*
- * Fill in ablkcipher job descriptor
+ * Fill in skcipher job descriptor
  */
-static void init_ablkcipher_job(u32 *sh_desc, dma_addr_t ptr,
-				struct ablkcipher_edesc *edesc,
-				struct ablkcipher_request *req,
-				bool iv_contig)
+static void init_skcipher_job(struct skcipher_request *req,
+			      struct skcipher_edesc *edesc,
+			      const bool encrypt)
 {
-	struct crypto_ablkcipher *ablkcipher = crypto_ablkcipher_reqtfm(req);
-	int ivsize = crypto_ablkcipher_ivsize(ablkcipher);
+	struct crypto_skcipher *skcipher = crypto_skcipher_reqtfm(req);
+	struct caam_ctx *ctx = crypto_skcipher_ctx(skcipher);
+	struct caam_skcipher_alg *alg =
+		container_of(crypto_skcipher_alg(skcipher),
+			     struct caam_skcipher_alg, skcipher);
+	int ivsize = crypto_skcipher_ivsize(skcipher);
 	u32 *desc = edesc->hw_desc;
-	u32 out_options = 0, in_options;
-	dma_addr_t dst_dma, src_dma;
+	u32 out_options, in_options;
+	dma_addr_t dst_dma, src_dma, ptr;
 	int len, sec4_sg_index = 0;
+	u32 *sh_desc;
+	const bool is_rfc3686 = alg->caam.rfc3686;
 
 #ifdef DEBUG
 	print_hex_dump(KERN_ERR, "presciv@"__stringify(__LINE__)": ",
-		       DUMP_PREFIX_ADDRESS, 16, 4, req->info,
+		       DUMP_PREFIX_ADDRESS, 16, 4, req->iv,
 		       ivsize, 1);
 	print_hex_dump(KERN_ERR, "src    @"__stringify(__LINE__)": ",
 		       DUMP_PREFIX_ADDRESS, 16, 4, sg_virt(req->src),
-		       edesc->src_nents ? 100 : req->nbytes, 1);
+		       edesc->src_nents ? 100 : req->cryptlen, 1);
 #endif
 
-	len = desc_len(sh_desc);
-	init_job_desc_shared(desc, ptr, len, HDR_SHARE_DEFER | HDR_REVERSE);
-
-	if (iv_contig) {
-		src_dma = edesc->iv_dma;
-		in_options = 0;
-	} else {
-		src_dma = edesc->sec4_sg_dma;
-		sec4_sg_index += edesc->src_nents + 1;
-		in_options = LDST_SGF;
-	}
-	append_seq_in_ptr(desc, src_dma, req->nbytes + ivsize, in_options);
-
-	if (likely(req->src == req->dst)) {
-		if (!edesc->src_nents && iv_contig) {
-			dst_dma = sg_dma_address(req->src);
-		} else {
-			dst_dma = edesc->sec4_sg_dma +
-				sizeof(struct sec4_sg_entry);
-			out_options = LDST_SGF;
-		}
-	} else {
-		if (!edesc->dst_nents) {
-			dst_dma = sg_dma_address(req->dst);
-		} else {
-			dst_dma = edesc->sec4_sg_dma +
-				sec4_sg_index * sizeof(struct sec4_sg_entry);
-			out_options = LDST_SGF;
-		}
-	}
-	append_seq_out_ptr(desc, dst_dma, req->nbytes, out_options);
-}
-
-/*
- * Fill in ablkcipher givencrypt job descriptor
- */
-static void init_ablkcipher_giv_job(u32 *sh_desc, dma_addr_t ptr,
-				    struct ablkcipher_edesc *edesc,
-				    struct ablkcipher_request *req,
-				    bool iv_contig)
-{
-	struct crypto_ablkcipher *ablkcipher = crypto_ablkcipher_reqtfm(req);
-	int ivsize = crypto_ablkcipher_ivsize(ablkcipher);
-	u32 *desc = edesc->hw_desc;
-	u32 out_options, in_options;
-	dma_addr_t dst_dma, src_dma;
-	int len, sec4_sg_index = 0;
-
-#ifdef DEBUG
-	print_hex_dump(KERN_ERR, "presciv@" __stringify(__LINE__) ": ",
-		       DUMP_PREFIX_ADDRESS, 16, 4, req->info,
-		       ivsize, 1);
-	print_hex_dump(KERN_ERR, "src    @" __stringify(__LINE__) ": ",
-		       DUMP_PREFIX_ADDRESS, 16, 4, sg_virt(req->src),
-		       edesc->src_nents ? 100 : req->nbytes, 1);
-#endif
+	sh_desc = encrypt ? ctx->sh_desc_enc : ctx->sh_desc_dec;
+	ptr = encrypt ? ctx->sh_desc_enc_dma : ctx->sh_desc_dec_dma;
 
 	len = desc_len(sh_desc);
 	init_job_desc_shared(desc, ptr, len, HDR_SHARE_DEFER | HDR_REVERSE);
@@ -2260,17 +2196,46 @@ static void init_ablkcipher_giv_job(u32 *sh_desc, dma_addr_t ptr,
 		sec4_sg_index += edesc->src_nents;
 		in_options = LDST_SGF;
 	}
-	append_seq_in_ptr(desc, src_dma, req->nbytes, in_options);
+	append_seq_in_ptr(desc, src_dma, req->cryptlen, in_options);
 
-	if (iv_contig) {
-		dst_dma = edesc->iv_dma;
+	if (likely(req->src == req->dst)) {
+		dst_dma = src_dma;
+		out_options = in_options;
+	} else if (!edesc->dst_nents) {
+		dst_dma = sg_dma_address(req->dst);
 		out_options = 0;
 	} else {
 		dst_dma = edesc->sec4_sg_dma +
 			  sec4_sg_index * sizeof(struct sec4_sg_entry);
 		out_options = LDST_SGF;
 	}
-	append_seq_out_ptr(desc, dst_dma, req->nbytes + ivsize, out_options);
+	append_seq_out_ptr(desc, dst_dma, req->cryptlen, out_options);
+
+	if (ivsize && (is_rfc3686 || !(alg->caam.geniv && encrypt))) {
+		u32 ivoffset = 0;
+		u32 alg_aai = ctx->class1_alg_type & OP_ALG_AAI_MASK;
+
+		if (alg_aai == OP_ALG_AAI_CTR_MOD128) {
+			/*
+			 * CONTEXT1[31:16] = IV
+			 * RFC3686: CONTEXT1[31:16] = {NONCE, IV, COUNTER}
+			 */
+			ivoffset = 16 +
+				   (is_rfc3686 ? CTR_RFC3686_NONCE_SIZE : 0);
+		} else if (alg_aai == OP_ALG_AAI_XTS) {
+			/*
+			 * CONTEXT1[39:32] = upper 8B of IV (sector index)
+			 * Lower (last) 8B of IV will be discarded
+			 */
+			ivoffset = 32;
+			ivsize -= 8;
+		}
+
+		append_load_as_imm(desc, req->iv, ivsize,
+				   LDST_CLASS_1_CCB |
+				   LDST_SRCDST_BYTE_CONTEXT |
+				   (ivoffset << LDST_OFFSET_SHIFT));
+	}
 }
 
 /*
@@ -2549,30 +2514,26 @@ static int aead_decrypt(struct aead_request *req)
 }
 
 /*
- * allocate and map the ablkcipher extended descriptor for ablkcipher
+ * allocate and map the skcipher extended descriptor for skcipher
  */
-static struct ablkcipher_edesc *ablkcipher_edesc_alloc(struct ablkcipher_request
-						       *req, int desc_bytes,
-						       bool *iv_contig_out)
+static struct skcipher_edesc *skcipher_edesc_alloc(struct skcipher_request *req,
+						   int desc_bytes)
 {
-	struct crypto_ablkcipher *ablkcipher = crypto_ablkcipher_reqtfm(req);
-	struct caam_ctx *ctx = crypto_ablkcipher_ctx(ablkcipher);
+	struct crypto_skcipher *skcipher = crypto_skcipher_reqtfm(req);
+	struct caam_ctx *ctx = crypto_skcipher_ctx(skcipher);
 	struct device *jrdev = ctx->jrdev;
 	gfp_t flags = (req->base.flags & (CRYPTO_TFM_REQ_MAY_BACKLOG |
 					  CRYPTO_TFM_REQ_MAY_SLEEP)) ?
 		       GFP_KERNEL : GFP_ATOMIC;
 	int src_nents, dst_nents = 0, sec4_sg_bytes;
-	struct ablkcipher_edesc *edesc;
-	dma_addr_t iv_dma = 0;
-	bool iv_contig = false;
+	struct skcipher_edesc *edesc;
 	int sgc;
-	int ivsize = crypto_ablkcipher_ivsize(ablkcipher);
 	int sec4_sg_index;
 
-	src_nents = sg_count(req->src, req->nbytes);
+	src_nents = sg_count(req->src, req->cryptlen);
 
 	if (req->dst != req->src)
-		dst_nents = sg_count(req->dst, req->nbytes);
+		dst_nents = sg_count(req->dst, req->cryptlen);
 
 	if (likely(req->src == req->dst)) {
 		sgc = dma_map_sg(jrdev, req->src, src_nents ? : 1,
@@ -2584,22 +2545,7 @@ static struct ablkcipher_edesc *ablkcipher_edesc_alloc(struct ablkcipher_request
 				 DMA_FROM_DEVICE);
 	}
 
-	iv_dma = dma_map_single(jrdev, req->info, ivsize, DMA_TO_DEVICE);
-	if (dma_mapping_error(jrdev, iv_dma)) {
-		dev_err(jrdev, "unable to map IV\n");
-		return ERR_PTR(-ENOMEM);
-	}
-
-	/*
-	 * Check if iv can be contiguous with source and destination.
-	 * If so, include it. If not, create scatterlist.
-	 */
-	if (!src_nents && iv_dma + ivsize == sg_dma_address(req->src))
-		iv_contig = true;
-	else
-		src_nents = src_nents ? : 1;
-	sec4_sg_bytes = ((iv_contig ? 0 : 1) + src_nents + dst_nents) *
-			sizeof(struct sec4_sg_entry);
+	sec4_sg_bytes = (src_nents + dst_nents) * sizeof(struct sec4_sg_entry);
 
 	/* allocate space for base edesc and hw desc commands, link tables */
 	edesc = kzalloc(sizeof(*edesc) + desc_bytes + sec4_sg_bytes,
@@ -2612,15 +2558,13 @@ static struct ablkcipher_edesc *ablkcipher_edesc_alloc(struct ablkcipher_request
 	edesc->src_nents = src_nents;
 	edesc->dst_nents = dst_nents;
 	edesc->sec4_sg_bytes = sec4_sg_bytes;
-	edesc->sec4_sg = (void *)edesc + sizeof(struct ablkcipher_edesc) +
+	edesc->sec4_sg = (void *)edesc + sizeof(struct skcipher_edesc) +
 			 desc_bytes;
 
 	sec4_sg_index = 0;
-	if (!iv_contig) {
-		dma_to_sec4_sg_one(edesc->sec4_sg, iv_dma, ivsize, 0);
-		sg_to_sec4_sg_last(req->src, src_nents,
-				   edesc->sec4_sg + 1, 0);
-		sec4_sg_index += 1 + src_nents;
+	if (src_nents) {
+		sg_to_sec4_sg_last(req->src, src_nents, edesc->sec4_sg, 0);
+		sec4_sg_index += src_nents;
 	}
 
 	if (dst_nents) {
@@ -2635,352 +2579,299 @@ static struct ablkcipher_edesc *ablkcipher_edesc_alloc(struct ablkcipher_request
 		return ERR_PTR(-ENOMEM);
 	}
 
-	edesc->iv_dma = iv_dma;
-
 #ifdef DEBUG
-	print_hex_dump(KERN_ERR, "ablkcipher sec4_sg@"__stringify(__LINE__)": ",
+	print_hex_dump(KERN_ERR, "skcipher sec4_sg@"__stringify(__LINE__)": ",
 		       DUMP_PREFIX_ADDRESS, 16, 4, edesc->sec4_sg,
 		       sec4_sg_bytes, 1);
 #endif
 
-	*iv_contig_out = iv_contig;
 	return edesc;
 }
 
-static int ablkcipher_encrypt(struct ablkcipher_request *req)
+static int skcipher_encrypt(struct skcipher_request *req)
 {
-	struct ablkcipher_edesc *edesc;
-	struct crypto_ablkcipher *ablkcipher = crypto_ablkcipher_reqtfm(req);
-	struct caam_ctx *ctx = crypto_ablkcipher_ctx(ablkcipher);
+	struct skcipher_edesc *edesc;
+	struct crypto_skcipher *skcipher = crypto_skcipher_reqtfm(req);
+	struct caam_ctx *ctx = crypto_skcipher_ctx(skcipher);
 	struct device *jrdev = ctx->jrdev;
-	bool iv_contig;
 	u32 *desc;
 	int ret = 0;
 
 	/* allocate extended descriptor */
-	edesc = ablkcipher_edesc_alloc(req, DESC_JOB_IO_LEN *
-				       CAAM_CMD_SZ, &iv_contig);
+	edesc = skcipher_edesc_alloc(req, DESC_JOB_IO_LEN * CAAM_CMD_SZ);
 	if (IS_ERR(edesc))
 		return PTR_ERR(edesc);
 
 	/* Create and submit job descriptor*/
-	init_ablkcipher_job(ctx->sh_desc_enc,
-		ctx->sh_desc_enc_dma, edesc, req, iv_contig);
+	init_skcipher_job(req, edesc, true);
 #ifdef DEBUG
-	print_hex_dump(KERN_ERR, "ablkcipher jobdesc@"__stringify(__LINE__)": ",
+	print_hex_dump(KERN_ERR, "skcipher jobdesc@"__stringify(__LINE__)": ",
 		       DUMP_PREFIX_ADDRESS, 16, 4, edesc->hw_desc,
 		       desc_bytes(edesc->hw_desc), 1);
 #endif
 	desc = edesc->hw_desc;
-	ret = caam_jr_enqueue(jrdev, desc, ablkcipher_encrypt_done, req);
+	ret = caam_jr_enqueue(jrdev, desc, skcipher_encrypt_done, req);
 
 	if (!ret) {
 		ret = -EINPROGRESS;
 	} else {
-		ablkcipher_unmap(jrdev, edesc, req);
+		skcipher_unmap(jrdev, edesc, req);
 		kfree(edesc);
 	}
 
 	return ret;
 }
 
-static int ablkcipher_decrypt(struct ablkcipher_request *req)
+static int skcipher_decrypt(struct skcipher_request *req)
 {
-	struct ablkcipher_edesc *edesc;
-	struct crypto_ablkcipher *ablkcipher = crypto_ablkcipher_reqtfm(req);
-	struct caam_ctx *ctx = crypto_ablkcipher_ctx(ablkcipher);
+	struct skcipher_edesc *edesc;
+	struct crypto_skcipher *skcipher = crypto_skcipher_reqtfm(req);
+	struct caam_ctx *ctx = crypto_skcipher_ctx(skcipher);
 	struct device *jrdev = ctx->jrdev;
-	bool iv_contig;
 	u32 *desc;
 	int ret = 0;
 
 	/* allocate extended descriptor */
-	edesc = ablkcipher_edesc_alloc(req, DESC_JOB_IO_LEN *
-				       CAAM_CMD_SZ, &iv_contig);
+	edesc = skcipher_edesc_alloc(req, DESC_JOB_IO_LEN * CAAM_CMD_SZ);
 	if (IS_ERR(edesc))
 		return PTR_ERR(edesc);
 
 	/* Create and submit job descriptor*/
-	init_ablkcipher_job(ctx->sh_desc_dec,
-		ctx->sh_desc_dec_dma, edesc, req, iv_contig);
+	init_skcipher_job(req, edesc, false);
 	desc = edesc->hw_desc;
 #ifdef DEBUG
-	print_hex_dump(KERN_ERR, "ablkcipher jobdesc@"__stringify(__LINE__)": ",
+	print_hex_dump(KERN_ERR, "skcipher jobdesc@"__stringify(__LINE__)": ",
 		       DUMP_PREFIX_ADDRESS, 16, 4, edesc->hw_desc,
 		       desc_bytes(edesc->hw_desc), 1);
 #endif
 
-	ret = caam_jr_enqueue(jrdev, desc, ablkcipher_decrypt_done, req);
+	ret = caam_jr_enqueue(jrdev, desc, skcipher_decrypt_done, req);
 	if (!ret) {
 		ret = -EINPROGRESS;
 	} else {
-		ablkcipher_unmap(jrdev, edesc, req);
+		skcipher_unmap(jrdev, edesc, req);
 		kfree(edesc);
 	}
 
 	return ret;
 }
 
-/*
- * allocate and map the ablkcipher extended descriptor
- * for ablkcipher givencrypt
- */
-static struct ablkcipher_edesc *ablkcipher_giv_edesc_alloc(
-				struct skcipher_givcrypt_request *greq,
-				int desc_bytes,
-				bool *iv_contig_out)
-{
-	struct ablkcipher_request *req = &greq->creq;
-	struct crypto_ablkcipher *ablkcipher = crypto_ablkcipher_reqtfm(req);
-	struct caam_ctx *ctx = crypto_ablkcipher_ctx(ablkcipher);
-	struct device *jrdev = ctx->jrdev;
-	gfp_t flags = (req->base.flags & (CRYPTO_TFM_REQ_MAY_BACKLOG |
-					  CRYPTO_TFM_REQ_MAY_SLEEP)) ?
-		       GFP_KERNEL : GFP_ATOMIC;
-	int src_nents, dst_nents = 0, sec4_sg_bytes;
-	struct ablkcipher_edesc *edesc;
-	dma_addr_t iv_dma = 0;
-	bool iv_contig = false;
-	int sgc;
-	int ivsize = crypto_ablkcipher_ivsize(ablkcipher);
-	int sec4_sg_index;
-
-	src_nents = sg_count(req->src, req->nbytes);
-
-	if (unlikely(req->dst != req->src))
-		dst_nents = sg_count(req->dst, req->nbytes);
-
-	if (likely(req->src == req->dst)) {
-		sgc = dma_map_sg(jrdev, req->src, src_nents ? : 1,
-				 DMA_BIDIRECTIONAL);
-	} else {
-		sgc = dma_map_sg(jrdev, req->src, src_nents ? : 1,
-				 DMA_TO_DEVICE);
-		sgc = dma_map_sg(jrdev, req->dst, dst_nents ? : 1,
-				 DMA_FROM_DEVICE);
-	}
-
-	/*
-	 * Check if iv can be contiguous with source and destination.
-	 * If so, include it. If not, create scatterlist.
-	 */
-	iv_dma = dma_map_single(jrdev, greq->giv, ivsize, DMA_TO_DEVICE);
-	if (dma_mapping_error(jrdev, iv_dma)) {
-		dev_err(jrdev, "unable to map IV\n");
-		return ERR_PTR(-ENOMEM);
-	}
-
-	if (!dst_nents && iv_dma + ivsize == sg_dma_address(req->dst))
-		iv_contig = true;
-	else
-		dst_nents = dst_nents ? : 1;
-	sec4_sg_bytes = ((iv_contig ? 0 : 1) + src_nents + dst_nents) *
-			sizeof(struct sec4_sg_entry);
-
-	/* allocate space for base edesc and hw desc commands, link tables */
-	edesc = kzalloc(sizeof(*edesc) + desc_bytes + sec4_sg_bytes,
-			GFP_DMA | flags);
-	if (!edesc) {
-		dev_err(jrdev, "could not allocate extended descriptor\n");
-		return ERR_PTR(-ENOMEM);
-	}
-
-	edesc->src_nents = src_nents;
-	edesc->dst_nents = dst_nents;
-	edesc->sec4_sg_bytes = sec4_sg_bytes;
-	edesc->sec4_sg = (void *)edesc + sizeof(struct ablkcipher_edesc) +
-			 desc_bytes;
-
-	sec4_sg_index = 0;
-	if (src_nents) {
-		sg_to_sec4_sg_last(req->src, src_nents, edesc->sec4_sg, 0);
-		sec4_sg_index += src_nents;
-	}
-
-	if (!iv_contig) {
-		dma_to_sec4_sg_one(edesc->sec4_sg + sec4_sg_index,
-				   iv_dma, ivsize, 0);
-		sec4_sg_index += 1;
-		sg_to_sec4_sg_last(req->dst, dst_nents,
-				   edesc->sec4_sg + sec4_sg_index, 0);
-	}
-
-	edesc->sec4_sg_dma = dma_map_single(jrdev, edesc->sec4_sg,
-					    sec4_sg_bytes, DMA_TO_DEVICE);
-	if (dma_mapping_error(jrdev, edesc->sec4_sg_dma)) {
-		dev_err(jrdev, "unable to map S/G table\n");
-		return ERR_PTR(-ENOMEM);
-	}
-	edesc->iv_dma = iv_dma;
-
-#ifdef DEBUG
-	print_hex_dump(KERN_ERR,
-		       "ablkcipher sec4_sg@" __stringify(__LINE__) ": ",
-		       DUMP_PREFIX_ADDRESS, 16, 4, edesc->sec4_sg,
-		       sec4_sg_bytes, 1);
-#endif
-
-	*iv_contig_out = iv_contig;
-	return edesc;
-}
-
-static int ablkcipher_givencrypt(struct skcipher_givcrypt_request *creq)
+static int skcipher_givdecrypt(struct skcipher_request *req)
 {
-	struct ablkcipher_request *req = &creq->creq;
-	struct ablkcipher_edesc *edesc;
-	struct crypto_ablkcipher *ablkcipher = crypto_ablkcipher_reqtfm(req);
-	struct caam_ctx *ctx = crypto_ablkcipher_ctx(ablkcipher);
-	struct device *jrdev = ctx->jrdev;
-	bool iv_contig;
-	u32 *desc;
-	int ret = 0;
+	struct crypto_skcipher *skcipher = crypto_skcipher_reqtfm(req);
+	int ivsize = crypto_skcipher_ivsize(skcipher);
 
-	/* allocate extended descriptor */
-	edesc = ablkcipher_giv_edesc_alloc(creq, DESC_JOB_IO_LEN *
-				       CAAM_CMD_SZ, &iv_contig);
-	if (IS_ERR(edesc))
-		return PTR_ERR(edesc);
-
-	/* Create and submit job descriptor*/
-	init_ablkcipher_giv_job(ctx->sh_desc_givenc, ctx->sh_desc_givenc_dma,
-				edesc, req, iv_contig);
-#ifdef DEBUG
-	print_hex_dump(KERN_ERR,
-		       "ablkcipher jobdesc@" __stringify(__LINE__) ": ",
-		       DUMP_PREFIX_ADDRESS, 16, 4, edesc->hw_desc,
-		       desc_bytes(edesc->hw_desc), 1);
-#endif
-	desc = edesc->hw_desc;
-	ret = caam_jr_enqueue(jrdev, desc, ablkcipher_encrypt_done, req);
+	if (req->cryptlen < ivsize)
+		return -EINVAL;
 
-	if (!ret) {
-		ret = -EINPROGRESS;
-	} else {
-		ablkcipher_unmap(jrdev, edesc, req);
-		kfree(edesc);
-	}
+	req->cryptlen -= ivsize;
 
-	return ret;
+	return skcipher_decrypt(req);
 }
 
-#define template_aead		template_u.aead
-#define template_ablkcipher	template_u.ablkcipher
-struct caam_alg_template {
-	char name[CRYPTO_MAX_ALG_NAME];
-	char driver_name[CRYPTO_MAX_ALG_NAME];
-	unsigned int blocksize;
-	u32 type;
-	union {
-		struct ablkcipher_alg ablkcipher;
-	} template_u;
-	u32 class1_alg_type;
-	u32 class2_alg_type;
-	u32 alg_op;
-};
-
-static struct caam_alg_template driver_algs[] = {
-	/* ablkcipher descriptor */
+static struct caam_skcipher_alg driver_algs[] = {
 	{
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
+		.skcipher = {
+			.base = {
+				.cra_name = "cbc(aes)",
+				.cra_driver_name = "cbc-aes-caam",
+				.cra_blocksize = AES_BLOCK_SIZE,
+			},
+			.setkey = skcipher_setkey,
+			.encrypt = skcipher_encrypt,
+			.decrypt = skcipher_decrypt,
 			.min_keysize = AES_MIN_KEY_SIZE,
 			.max_keysize = AES_MAX_KEY_SIZE,
 			.ivsize = AES_BLOCK_SIZE,
+			.chunksize = AES_BLOCK_SIZE,
+		},
+		.caam = {
+			.class1_alg_type = OP_ALG_ALGSEL_AES | OP_ALG_AAI_CBC,
+		},
+	},
+	{
+		.skcipher = {
+			.base = {
+				.cra_name = "echainiv(cbc(aes))",
+				.cra_driver_name = "echainiv-cbc-aes-caam",
+				.cra_blocksize = AES_BLOCK_SIZE,
 			},
-		.class1_alg_type = OP_ALG_ALGSEL_AES | OP_ALG_AAI_CBC,
+			.setkey = skcipher_setkey,
+			.encrypt = skcipher_encrypt,
+			.decrypt = skcipher_givdecrypt,
+			.min_keysize = AES_MIN_KEY_SIZE,
+			.max_keysize = AES_MAX_KEY_SIZE,
+			.ivsize = AES_BLOCK_SIZE,
+			.chunksize = AES_BLOCK_SIZE,
+		},
+		.caam = {
+			.class1_alg_type = OP_ALG_ALGSEL_AES | OP_ALG_AAI_CBC,
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
+		.skcipher = {
+			.base = {
+				.cra_name = "cbc(des3_ede)",
+				.cra_driver_name = "cbc-3des-caam",
+				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
+			},
+			.setkey = skcipher_setkey,
+			.encrypt = skcipher_encrypt,
+			.decrypt = skcipher_decrypt,
 			.min_keysize = DES3_EDE_KEY_SIZE,
 			.max_keysize = DES3_EDE_KEY_SIZE,
 			.ivsize = DES3_EDE_BLOCK_SIZE,
+			.chunksize = DES3_EDE_BLOCK_SIZE,
+		},
+		.caam = {
+			.class1_alg_type = OP_ALG_ALGSEL_3DES | OP_ALG_AAI_CBC,
+		}
+	},
+	{
+		.skcipher = {
+			.base = {
+				.cra_name = "echainiv(cbc(des3_ede))",
+				.cra_driver_name = "echainiv-cbc-3des-caam",
+				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
 			},
-		.class1_alg_type = OP_ALG_ALGSEL_3DES | OP_ALG_AAI_CBC,
+			.setkey = skcipher_setkey,
+			.encrypt = skcipher_encrypt,
+			.decrypt = skcipher_givdecrypt,
+			.min_keysize = DES3_EDE_KEY_SIZE,
+			.max_keysize = DES3_EDE_KEY_SIZE,
+			.ivsize = DES3_EDE_BLOCK_SIZE,
+			.chunksize = DES3_EDE_BLOCK_SIZE,
+		},
+		.caam = {
+			.class1_alg_type = OP_ALG_ALGSEL_3DES | OP_ALG_AAI_CBC,
+			.geniv = true,
+		}
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
+		.skcipher = {
+			.base = {
+				.cra_name = "cbc(des)",
+				.cra_driver_name = "cbc-des-caam",
+				.cra_blocksize = DES_BLOCK_SIZE,
+			},
+			.setkey = skcipher_setkey,
+			.encrypt = skcipher_encrypt,
+			.decrypt = skcipher_decrypt,
 			.min_keysize = DES_KEY_SIZE,
 			.max_keysize = DES_KEY_SIZE,
 			.ivsize = DES_BLOCK_SIZE,
+			.chunksize = DES_BLOCK_SIZE,
+		},
+		.caam = {
+			.class1_alg_type = OP_ALG_ALGSEL_DES | OP_ALG_AAI_CBC,
+		},
+	},
+	{
+		.skcipher = {
+			.base = {
+				.cra_name = "echainiv(cbc(des))",
+				.cra_driver_name = "echainiv-cbc-des-caam",
+				.cra_blocksize = DES_BLOCK_SIZE,
 			},
-		.class1_alg_type = OP_ALG_ALGSEL_DES | OP_ALG_AAI_CBC,
+			.setkey = skcipher_setkey,
+			.encrypt = skcipher_encrypt,
+			.decrypt = skcipher_givdecrypt,
+			.min_keysize = DES_KEY_SIZE,
+			.max_keysize = DES_KEY_SIZE,
+			.ivsize = DES_BLOCK_SIZE,
+			.chunksize = DES_BLOCK_SIZE,
+		},
+		.caam = {
+			.class1_alg_type = OP_ALG_ALGSEL_DES | OP_ALG_AAI_CBC,
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
+		.skcipher = {
+			.base = {
+				.cra_name = "ctr(aes)",
+				.cra_driver_name = "ctr-aes-caam",
+				.cra_blocksize = 1,
+			},
+			.setkey = skcipher_setkey,
+			.encrypt = skcipher_encrypt,
+			.decrypt = skcipher_decrypt,
 			.min_keysize = AES_MIN_KEY_SIZE,
 			.max_keysize = AES_MAX_KEY_SIZE,
 			.ivsize = AES_BLOCK_SIZE,
-			},
-		.class1_alg_type = OP_ALG_ALGSEL_AES | OP_ALG_AAI_CTR_MOD128,
+			.chunksize = 1,
+		},
+		.caam = {
+			.class1_alg_type = OP_ALG_ALGSEL_AES |
+					   OP_ALG_AAI_CTR_MOD128,
+		},
 	},
 	{
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
+		.skcipher = {
+			.base = {
+				.cra_name = "rfc3686(ctr(aes))",
+				.cra_driver_name = "rfc3686-ctr-aes-caam",
+				.cra_blocksize = 1,
+			},
+			.setkey = skcipher_setkey,
+			.encrypt = skcipher_encrypt,
+			.decrypt = skcipher_decrypt,
 			.min_keysize = AES_MIN_KEY_SIZE +
 				       CTR_RFC3686_NONCE_SIZE,
 			.max_keysize = AES_MAX_KEY_SIZE +
 				       CTR_RFC3686_NONCE_SIZE,
 			.ivsize = CTR_RFC3686_IV_SIZE,
+			.chunksize = 1,
+		},
+		.caam = {
+			.class1_alg_type = OP_ALG_ALGSEL_AES |
+					   OP_ALG_AAI_CTR_MOD128,
+			.rfc3686 = true,
+		},
+	},
+	{
+		.skcipher = {
+			.base = {
+				.cra_name = "seqiv(rfc3686(ctr(aes)))",
+				.cra_driver_name = "seqiv-rfc3686-ctr-aes-caam",
+				.cra_blocksize = 1,
 			},
-		.class1_alg_type = OP_ALG_ALGSEL_AES | OP_ALG_AAI_CTR_MOD128,
+			.setkey = skcipher_setkey,
+			.encrypt = skcipher_encrypt,
+			.decrypt = skcipher_givdecrypt,
+			.min_keysize = AES_MIN_KEY_SIZE +
+				       CTR_RFC3686_NONCE_SIZE,
+			.max_keysize = AES_MAX_KEY_SIZE +
+				       CTR_RFC3686_NONCE_SIZE,
+			.ivsize = CTR_RFC3686_IV_SIZE,
+			.chunksize = 1,
+		},
+		.caam = {
+			.class1_alg_type = OP_ALG_ALGSEL_AES |
+					   OP_ALG_AAI_CTR_MOD128,
+			.rfc3686 = true,
+			.geniv = true,
+		},
 	},
 	{
-		.name = "xts(aes)",
-		.driver_name = "xts-aes-caam",
-		.blocksize = AES_BLOCK_SIZE,
-		.type = CRYPTO_ALG_TYPE_ABLKCIPHER,
-		.template_ablkcipher = {
-			.setkey = xts_ablkcipher_setkey,
-			.encrypt = ablkcipher_encrypt,
-			.decrypt = ablkcipher_decrypt,
-			.geniv = "eseqiv",
+		.skcipher = {
+			.base = {
+				.cra_name = "xts(aes)",
+				.cra_driver_name = "xts-aes-caam",
+				.cra_blocksize = AES_BLOCK_SIZE,
+			},
+			.setkey = xts_skcipher_setkey,
+			.encrypt = skcipher_encrypt,
+			.decrypt = skcipher_decrypt,
 			.min_keysize = 2 * AES_MIN_KEY_SIZE,
 			.max_keysize = 2 * AES_MAX_KEY_SIZE,
 			.ivsize = AES_BLOCK_SIZE,
-			},
-		.class1_alg_type = OP_ALG_ALGSEL_AES | OP_ALG_AAI_XTS,
+			.chunksize = AES_BLOCK_SIZE,
+		},
+		.caam = {
+			.class1_alg_type = OP_ALG_ALGSEL_AES | OP_ALG_AAI_XTS,
+		},
 	},
 };
 
@@ -4319,12 +4210,6 @@ static struct caam_aead_alg driver_aeads[] = {
 	},
 };
 
-struct caam_crypto_alg {
-	struct crypto_alg crypto_alg;
-	struct list_head entry;
-	struct caam_alg_entry caam;
-};
-
 static int caam_init_common(struct caam_ctx *ctx, struct caam_alg_entry *caam)
 {
 	ctx->jrdev = caam_jr_alloc();
@@ -4341,12 +4226,12 @@ static int caam_init_common(struct caam_ctx *ctx, struct caam_alg_entry *caam)
 	return 0;
 }
 
-static int caam_cra_init(struct crypto_tfm *tfm)
+static int caam_cra_init(struct crypto_skcipher *tfm)
 {
-	struct crypto_alg *alg = tfm->__crt_alg;
-	struct caam_crypto_alg *caam_alg =
-		 container_of(alg, struct caam_crypto_alg, crypto_alg);
-	struct caam_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct skcipher_alg *alg = crypto_skcipher_alg(tfm);
+	struct caam_skcipher_alg *caam_alg =
+		 container_of(alg, struct caam_skcipher_alg, skcipher);
+	struct caam_ctx *ctx = crypto_skcipher_ctx(tfm);
 
 	return caam_init_common(ctx, &caam_alg->caam);
 }
@@ -4385,9 +4270,9 @@ static void caam_exit_common(struct caam_ctx *ctx)
 	caam_jr_free(ctx->jrdev);
 }
 
-static void caam_cra_exit(struct crypto_tfm *tfm)
+static void caam_cra_exit(struct crypto_skcipher *tfm)
 {
-	caam_exit_common(crypto_tfm_ctx(tfm));
+	caam_exit_common(crypto_skcipher_ctx(tfm));
 }
 
 static void caam_aead_exit(struct crypto_aead *tfm)
@@ -4397,8 +4282,6 @@ static void caam_aead_exit(struct crypto_aead *tfm)
 
 static void __exit caam_algapi_exit(void)
 {
-
-	struct caam_crypto_alg *t_alg, *n;
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(driver_aeads); i++) {
@@ -4408,58 +4291,25 @@ static void __exit caam_algapi_exit(void)
 			crypto_unregister_aead(&t_alg->aead);
 	}
 
-	if (!alg_list.next)
-		return;
+	for (i = 0; i < ARRAY_SIZE(driver_algs); i++) {
+		struct caam_skcipher_alg *t_alg = driver_algs + i;
 
-	list_for_each_entry_safe(t_alg, n, &alg_list, entry) {
-		crypto_unregister_alg(&t_alg->crypto_alg);
-		list_del(&t_alg->entry);
-		kfree(t_alg);
+		if (t_alg->registered)
+			crypto_unregister_skcipher(&t_alg->skcipher);
 	}
 }
 
-static struct caam_crypto_alg *caam_alg_alloc(struct caam_alg_template
-					      *template)
+static void caam_skcipher_alg_init(struct caam_skcipher_alg *t_alg)
 {
-	struct caam_crypto_alg *t_alg;
-	struct crypto_alg *alg;
-
-	t_alg = kzalloc(sizeof(*t_alg), GFP_KERNEL);
-	if (!t_alg) {
-		pr_err("failed to allocate t_alg\n");
-		return ERR_PTR(-ENOMEM);
-	}
-
-	alg = &t_alg->crypto_alg;
-
-	snprintf(alg->cra_name, CRYPTO_MAX_ALG_NAME, "%s", template->name);
-	snprintf(alg->cra_driver_name, CRYPTO_MAX_ALG_NAME, "%s",
-		 template->driver_name);
-	alg->cra_module = THIS_MODULE;
-	alg->cra_init = caam_cra_init;
-	alg->cra_exit = caam_cra_exit;
-	alg->cra_priority = CAAM_CRA_PRIORITY;
-	alg->cra_blocksize = template->blocksize;
-	alg->cra_alignmask = 0;
-	alg->cra_ctxsize = sizeof(struct caam_ctx);
-	alg->cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_KERN_DRIVER_ONLY |
-			 template->type;
-	switch (template->type) {
-	case CRYPTO_ALG_TYPE_GIVCIPHER:
-		alg->cra_type = &crypto_givcipher_type;
-		alg->cra_ablkcipher = template->template_ablkcipher;
-		break;
-	case CRYPTO_ALG_TYPE_ABLKCIPHER:
-		alg->cra_type = &crypto_ablkcipher_type;
-		alg->cra_ablkcipher = template->template_ablkcipher;
-		break;
-	}
+	struct skcipher_alg *alg = &t_alg->skcipher;
 
-	t_alg->caam.class1_alg_type = template->class1_alg_type;
-	t_alg->caam.class2_alg_type = template->class2_alg_type;
-	t_alg->caam.alg_op = template->alg_op;
+	alg->base.cra_module = THIS_MODULE;
+	alg->base.cra_priority = CAAM_CRA_PRIORITY;
+	alg->base.cra_ctxsize = sizeof(struct caam_ctx);
+	alg->base.cra_flags = CRYPTO_ALG_ASYNC | CRYPTO_ALG_KERN_DRIVER_ONLY;
 
-	return t_alg;
+	alg->init = caam_cra_init;
+	alg->exit = caam_cra_exit;
 }
 
 static void caam_aead_alg_init(struct caam_aead_alg *t_alg)
@@ -4510,9 +4360,6 @@ static int __init caam_algapi_init(void)
 	if (!priv)
 		return -ENODEV;
 
-
-	INIT_LIST_HEAD(&alg_list);
-
 	/*
 	 * Register crypto algorithms the device supports.
 	 * First, detect presence and attributes of DES, AES, and MD blocks.
@@ -4528,9 +4375,8 @@ static int __init caam_algapi_init(void)
 		md_limit = SHA256_DIGEST_SIZE;
 
 	for (i = 0; i < ARRAY_SIZE(driver_algs); i++) {
-		struct caam_crypto_alg *t_alg;
-		struct caam_alg_template *alg = driver_algs + i;
-		u32 alg_sel = alg->class1_alg_type & OP_ALG_ALGSEL_MASK;
+		struct caam_skcipher_alg *t_alg = driver_algs + i;
+		u32 alg_sel = t_alg->caam.class1_alg_type & OP_ALG_ALGSEL_MASK;
 
 		/* Skip DES algorithms if not supported by device */
 		if (!des_inst &&
@@ -4542,22 +4388,16 @@ static int __init caam_algapi_init(void)
 		if (!aes_inst && (alg_sel == OP_ALG_ALGSEL_AES))
 				continue;
 
-		t_alg = caam_alg_alloc(alg);
-		if (IS_ERR(t_alg)) {
-			err = PTR_ERR(t_alg);
-			pr_warn("%s alg allocation failed\n", alg->driver_name);
-			continue;
-		}
+		caam_skcipher_alg_init(t_alg);
 
-		err = crypto_register_alg(&t_alg->crypto_alg);
+		err = crypto_register_skcipher(&t_alg->skcipher);
 		if (err) {
 			pr_warn("%s alg registration failed\n",
-				t_alg->crypto_alg.cra_driver_name);
-			kfree(t_alg);
+				t_alg->skcipher.base.cra_driver_name);
 			continue;
 		}
 
-		list_add_tail(&t_alg->entry, &alg_list);
+		t_alg->registered = true;
 		registered = true;
 	}
 
diff --git a/drivers/crypto/caam/compat.h b/drivers/crypto/caam/compat.h
index 7149cd2492e0..6db76a198cfd 100644
--- a/drivers/crypto/caam/compat.h
+++ b/drivers/crypto/caam/compat.h
@@ -37,6 +37,7 @@
 #include <crypto/authenc.h>
 #include <crypto/akcipher.h>
 #include <crypto/scatterwalk.h>
+#include <crypto/skcipher.h>
 #include <crypto/internal/skcipher.h>
 #include <crypto/internal/hash.h>
 #include <crypto/internal/rsa.h>
-- 
2.4.4
