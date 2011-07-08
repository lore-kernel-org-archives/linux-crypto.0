From: Kim Phillips <kim.phillips@freescale.com>
Subject: [PATCH 8/8] crypto: caam - ablkcipher support
Date: Fri, 8 Jul 2011 17:57:29 -0500
Message-ID: <1310165849-22177-8-git-send-email-kim.phillips@freescale.com>
References: <1310165849-22177-1-git-send-email-kim.phillips@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Yuan Kang <Yuan.Kang@freescale.com>,
	Kim Phillips <kim.phillips@freescale.com>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from am1ehsobe006.messaging.microsoft.com ([213.199.154.209]:2066
	"EHLO AM1EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752512Ab1GHW6N (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 8 Jul 2011 18:58:13 -0400
Received: from mail111-am1 (localhost.localdomain [127.0.0.1])	by
 mail111-am1-R.bigfish.com (Postfix) with ESMTP id 0E2288B00C5	for
 <linux-crypto@vger.kernel.org>; Fri,  8 Jul 2011 22:58:12 +0000 (UTC)
Received: from AM1EHSMHS002.bigfish.com (unknown [10.3.201.241])	by
 mail111-am1.bigfish.com (Postfix) with ESMTP id 7F83F150004C	for
 <linux-crypto@vger.kernel.org>; Fri,  8 Jul 2011 22:58:11 +0000 (UTC)
In-Reply-To: <1310165849-22177-1-git-send-email-kim.phillips@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Yuan Kang <Yuan.Kang@freescale.com>

caam now supports encrypt and decrypt
for aes, des and 3des

Signed-off-by: Yuan Kang <Yuan.Kang@freescale.com>
Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
---
 drivers/crypto/caam/caamalg.c |  510 +++++++++++++++++++++++++++++++++++++++++
 drivers/crypto/caam/compat.h  |    1 +
 2 files changed, 511 insertions(+), 0 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index ed7d59d..4159265 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -69,6 +69,12 @@
 #define DESC_AEAD_DEC_LEN		(DESC_AEAD_BASE + 21 * CAAM_CMD_SZ)
 #define DESC_AEAD_GIVENC_LEN		(DESC_AEAD_ENC_LEN + 7 * CAAM_CMD_SZ)
 
+#define DESC_ABLKCIPHER_BASE		(3 * CAAM_CMD_SZ)
+#define DESC_ABLKCIPHER_ENC_LEN		(DESC_ABLKCIPHER_BASE + \
+					 20 * CAAM_CMD_SZ)
+#define DESC_ABLKCIPHER_DEC_LEN		(DESC_ABLKCIPHER_BASE + \
+					 15 * CAAM_CMD_SZ)
+
 #define DESC_MAX_USED_BYTES		(DESC_AEAD_GIVENC_LEN + \
 					 CAAM_MAX_KEY_SIZE)
 #define DESC_MAX_USED_LEN		(DESC_MAX_USED_BYTES / CAAM_CMD_SZ)
@@ -132,6 +138,19 @@ static inline void aead_append_ld_iv(u32 *desc, int ivsize)
 }
 
 /*
+ * For ablkcipher encrypt and decrypt, read from req->src and
+ * write to req->dst
+ */
+static inline void ablkcipher_append_src_dst(u32 *desc)
+{
+	append_math_add(desc, VARSEQOUTLEN, SEQINLEN, REG0, CAAM_CMD_SZ); \
+	append_math_add(desc, VARSEQINLEN, SEQINLEN, REG0, CAAM_CMD_SZ); \
+	append_seq_fifo_load(desc, 0, FIFOLD_CLASS_CLASS1 | \
+			     KEY_VLF | FIFOLD_TYPE_MSG | FIFOLD_TYPE_LAST1); \
+	append_seq_fifo_store(desc, 0, FIFOST_TYPE_MESSAGE_DATA | KEY_VLF); \
+}
+
+/*
  * If all data, including src (with assoc and iv) or dst (with iv only) are
  * contiguous
  */
@@ -625,6 +644,119 @@ badkey:
 	return -EINVAL;
 }
 
+static int ablkcipher_setkey(struct crypto_ablkcipher *ablkcipher,
+			     const u8 *key, unsigned int keylen)
+{
+	struct caam_ctx *ctx = crypto_ablkcipher_ctx(ablkcipher);
+	struct ablkcipher_tfm *tfm = &ablkcipher->base.crt_ablkcipher;
+	struct device *jrdev = ctx->jrdev;
+	int ret = 0;
+	u32 *key_jump_cmd, *jump_cmd;
+	u32 *desc;
+
+#ifdef DEBUG
+	print_hex_dump(KERN_ERR, "key in @"xstr(__LINE__)": ",
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
+	/* ablkcipher_encrypt shared descriptor */
+	desc = ctx->sh_desc_enc;
+	init_sh_desc(desc, HDR_SHARE_WAIT);
+	/* Skip if already shared */
+	key_jump_cmd = append_jump(desc, JUMP_JSL | JUMP_TEST_ALL |
+				   JUMP_COND_SHRD);
+
+	/* Load class1 key only */
+	append_key_as_imm(desc, (void *)ctx->key, ctx->enckeylen,
+			  ctx->enckeylen, CLASS_1 |
+			  KEY_DEST_CLASS_REG);
+
+	set_jump_tgt_here(desc, key_jump_cmd);
+
+	/* Propagate errors from shared to job descriptor */
+	append_cmd(desc, SET_OK_PROP_ERRORS | CMD_LOAD);
+
+	/* Load iv */
+	append_cmd(desc, CMD_SEQ_LOAD | LDST_SRCDST_BYTE_CONTEXT |
+		   LDST_CLASS_1_CCB | tfm->ivsize);
+
+	/* Load operation */
+	append_operation(desc, ctx->class1_alg_type |
+			 OP_ALG_AS_INITFINAL | OP_ALG_ENCRYPT);
+
+	/* Perform operation */
+	ablkcipher_append_src_dst(desc);
+
+	ctx->sh_desc_enc_dma = dma_map_single(jrdev, desc,
+					      desc_bytes(desc),
+					      DMA_TO_DEVICE);
+	if (dma_mapping_error(jrdev, ctx->sh_desc_enc_dma)) {
+		dev_err(jrdev, "unable to map shared descriptor\n");
+		return -ENOMEM;
+	}
+#ifdef DEBUG
+	print_hex_dump(KERN_ERR, "ablkcipher enc shdesc@"xstr(__LINE__)": ",
+		       DUMP_PREFIX_ADDRESS, 16, 4, desc,
+		       desc_bytes(desc), 1);
+#endif
+	/* ablkcipher_decrypt shared descriptor */
+	desc = ctx->sh_desc_dec;
+
+	init_sh_desc(desc, HDR_SHARE_WAIT);
+	/* Skip if already shared */
+	key_jump_cmd = append_jump(desc, JUMP_JSL | JUMP_TEST_ALL |
+				   JUMP_COND_SHRD);
+
+	/* Load class1 key only */
+	append_key_as_imm(desc, (void *)ctx->key, ctx->enckeylen,
+			  ctx->enckeylen, CLASS_1 |
+			  KEY_DEST_CLASS_REG);
+
+	/* For aead, only propagate error immediately if shared */
+	jump_cmd = append_jump(desc, JUMP_TEST_ALL);
+	set_jump_tgt_here(desc, key_jump_cmd);
+	append_cmd(desc, SET_OK_PROP_ERRORS | CMD_LOAD);
+	set_jump_tgt_here(desc, jump_cmd);
+
+	/* load IV */
+	append_cmd(desc, CMD_SEQ_LOAD | LDST_SRCDST_BYTE_CONTEXT |
+		   LDST_CLASS_1_CCB | tfm->ivsize);
+
+	/* Choose operation */
+	append_dec_op1(desc, ctx->class1_alg_type);
+
+	/* Perform operation */
+	ablkcipher_append_src_dst(desc);
+
+	/* Wait for key to load before allowing propagating error */
+	append_dec_shr_done(desc);
+
+	ctx->sh_desc_dec_dma = dma_map_single(jrdev, desc,
+					      desc_bytes(desc),
+					      DMA_TO_DEVICE);
+	if (dma_mapping_error(jrdev, ctx->sh_desc_enc_dma)) {
+		dev_err(jrdev, "unable to map shared descriptor\n");
+		return -ENOMEM;
+	}
+
+#ifdef DEBUG
+	print_hex_dump(KERN_ERR, "ablkcipher dec shdesc@"xstr(__LINE__)": ",
+		       DUMP_PREFIX_ADDRESS, 16, 4, desc,
+		       desc_bytes(desc), 1);
+#endif
+
+	return ret;
+}
+
 struct link_tbl_entry {
 	u64 ptr;
 	u32 len;
@@ -655,6 +787,26 @@ struct aead_edesc {
 	u32 hw_desc[0];
 };
 
+/*
+ * ablkcipher_edesc - s/w-extended ablkcipher descriptor
+ * @src_nents: number of segments in input scatterlist
+ * @dst_nents: number of segments in output scatterlist
+ * @iv_dma: dma address of iv for checking continuity and link table
+ * @desc: h/w descriptor (variable length; must not exceed MAX_CAAM_DESCSIZE)
+ * @link_tbl_bytes: length of dma mapped link_tbl space
+ * @link_tbl_dma: bus physical mapped address of h/w link table
+ * @hw_desc: the h/w job descriptor followed by any referenced link tables
+ */
+struct ablkcipher_edesc {
+	int src_nents;
+	int dst_nents;
+	dma_addr_t iv_dma;
+	int link_tbl_bytes;
+	dma_addr_t link_tbl_dma;
+	struct link_tbl_entry *link_tbl;
+	u32 hw_desc[0];
+};
+
 static void caam_unmap(struct device *dev, struct scatterlist *src,
 		       struct scatterlist *dst, int src_nents, int dst_nents,
 		       dma_addr_t iv_dma, int ivsize, dma_addr_t link_tbl_dma,
@@ -689,6 +841,19 @@ static void aead_unmap(struct device *dev,
 		   edesc->link_tbl_bytes);
 }
 
+static void ablkcipher_unmap(struct device *dev,
+			     struct ablkcipher_edesc *edesc,
+			     struct ablkcipher_request *req)
+{
+	struct crypto_ablkcipher *ablkcipher = crypto_ablkcipher_reqtfm(req);
+	int ivsize = crypto_ablkcipher_ivsize(ablkcipher);
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
@@ -790,6 +955,77 @@ static void aead_decrypt_done(struct device *jrdev, u32 *desc, u32 err,
 	aead_request_complete(req, err);
 }
 
+static void ablkcipher_encrypt_done(struct device *jrdev, u32 *desc, u32 err,
+				   void *context)
+{
+	struct ablkcipher_request *req = context;
+	struct ablkcipher_edesc *edesc;
+#ifdef DEBUG
+	struct crypto_ablkcipher *ablkcipher = crypto_ablkcipher_reqtfm(req);
+	int ivsize = crypto_ablkcipher_ivsize(ablkcipher);
+
+	dev_err(jrdev, "%s %d: err 0x%x\n", __func__, __LINE__, err);
+#endif
+
+	edesc = (struct ablkcipher_edesc *)((char *)desc -
+		 offsetof(struct ablkcipher_edesc, hw_desc));
+
+	if (err) {
+		char tmp[CAAM_ERROR_STR_MAX];
+
+		dev_err(jrdev, "%08x: %s\n", err, caam_jr_strstatus(tmp, err));
+	}
+
+#ifdef DEBUG
+	print_hex_dump(KERN_ERR, "dstiv  @"xstr(__LINE__)": ",
+		       DUMP_PREFIX_ADDRESS, 16, 4, req->info,
+		       edesc->src_nents > 1 ? 100 : ivsize, 1);
+	print_hex_dump(KERN_ERR, "dst    @"xstr(__LINE__)": ",
+		       DUMP_PREFIX_ADDRESS, 16, 4, sg_virt(req->src),
+		       edesc->dst_nents > 1 ? 100 : req->nbytes, 1);
+#endif
+
+	ablkcipher_unmap(jrdev, edesc, req);
+	kfree(edesc);
+
+	ablkcipher_request_complete(req, err);
+}
+
+static void ablkcipher_decrypt_done(struct device *jrdev, u32 *desc, u32 err,
+				    void *context)
+{
+	struct ablkcipher_request *req = context;
+	struct ablkcipher_edesc *edesc;
+#ifdef DEBUG
+	struct crypto_ablkcipher *ablkcipher = crypto_ablkcipher_reqtfm(req);
+	int ivsize = crypto_ablkcipher_ivsize(ablkcipher);
+
+	dev_err(jrdev, "%s %d: err 0x%x\n", __func__, __LINE__, err);
+#endif
+
+	edesc = (struct ablkcipher_edesc *)((char *)desc -
+		 offsetof(struct ablkcipher_edesc, hw_desc));
+	if (err) {
+		char tmp[CAAM_ERROR_STR_MAX];
+
+		dev_err(jrdev, "%08x: %s\n", err, caam_jr_strstatus(tmp, err));
+	}
+
+#ifdef DEBUG
+	print_hex_dump(KERN_ERR, "dstiv  @"xstr(__LINE__)": ",
+		       DUMP_PREFIX_ADDRESS, 16, 4, req->info,
+		       ivsize, 1);
+	print_hex_dump(KERN_ERR, "dst    @"xstr(__LINE__)": ",
+		       DUMP_PREFIX_ADDRESS, 16, 4, sg_virt(req->src),
+		       edesc->dst_nents > 1 ? 100 : req->nbytes, 1);
+#endif
+
+	ablkcipher_unmap(jrdev, edesc, req);
+	kfree(edesc);
+
+	ablkcipher_request_complete(req, err);
+}
+
 static void sg_to_link_tbl_one(struct link_tbl_entry *link_tbl_ptr,
 			       dma_addr_t dma, u32 len, u32 offset)
 {
@@ -978,6 +1214,63 @@ static void init_aead_giv_job(u32 *sh_desc, dma_addr_t ptr,
 }
 
 /*
+ * Fill in ablkcipher job descriptor
+ */
+static void init_ablkcipher_job(u32 *sh_desc, dma_addr_t ptr,
+				struct ablkcipher_edesc *edesc,
+				struct ablkcipher_request *req,
+				bool iv_contig)
+{
+	struct crypto_ablkcipher *ablkcipher = crypto_ablkcipher_reqtfm(req);
+	int ivsize = crypto_ablkcipher_ivsize(ablkcipher);
+	u32 *desc = edesc->hw_desc;
+	u32 out_options = 0, in_options;
+	dma_addr_t dst_dma, src_dma;
+	int len, link_tbl_index = 0;
+
+#ifdef DEBUG
+	print_hex_dump(KERN_ERR, "presciv@"xstr(__LINE__)": ",
+		       DUMP_PREFIX_ADDRESS, 16, 4, req->info,
+		       ivsize, 1);
+	print_hex_dump(KERN_ERR, "src    @"xstr(__LINE__)": ",
+		       DUMP_PREFIX_ADDRESS, 16, 4, sg_virt(req->src),
+		       edesc->src_nents ? 100 : req->nbytes, 1);
+#endif
+
+	len = desc_len(sh_desc);
+	init_job_desc_shared(desc, ptr, len, HDR_SHARE_DEFER | HDR_REVERSE);
+
+	if (iv_contig) {
+		src_dma = edesc->iv_dma;
+		in_options = 0;
+	} else {
+		src_dma = edesc->link_tbl_dma;
+		link_tbl_index += (iv_contig ? 0 : 1) + edesc->src_nents;
+		in_options = LDST_SGF;
+	}
+	append_seq_in_ptr(desc, src_dma, req->nbytes + ivsize, in_options);
+
+	if (likely(req->src == req->dst)) {
+		if (!edesc->src_nents && iv_contig) {
+			dst_dma = sg_dma_address(req->src);
+		} else {
+			dst_dma = edesc->link_tbl_dma +
+				sizeof(struct link_tbl_entry);
+			out_options = LDST_SGF;
+		}
+	} else {
+		if (!edesc->dst_nents) {
+			dst_dma = sg_dma_address(req->dst);
+		} else {
+			dst_dma = edesc->link_tbl_dma +
+				link_tbl_index * sizeof(struct link_tbl_entry);
+			out_options = LDST_SGF;
+		}
+	}
+	append_seq_out_ptr(desc, dst_dma, req->nbytes, out_options);
+}
+
+/*
  * derive number of elements in scatterlist
  */
 static int sg_count(struct scatterlist *sg_list, int nbytes)
@@ -1327,7 +1620,171 @@ static int aead_givencrypt(struct aead_givcrypt_request *areq)
 	return ret;
 }
 
+/*
+ * allocate and map the ablkcipher extended descriptor for ablkcipher
+ */
+static struct ablkcipher_edesc *ablkcipher_edesc_alloc(struct ablkcipher_request
+						       *req, int desc_bytes,
+						       bool *iv_contig_out)
+{
+	struct crypto_ablkcipher *ablkcipher = crypto_ablkcipher_reqtfm(req);
+	struct caam_ctx *ctx = crypto_ablkcipher_ctx(ablkcipher);
+	struct device *jrdev = ctx->jrdev;
+	gfp_t flags = (req->base.flags & (CRYPTO_TFM_REQ_MAY_BACKLOG |
+					  CRYPTO_TFM_REQ_MAY_SLEEP)) ?
+		       GFP_KERNEL : GFP_ATOMIC;
+	int src_nents, dst_nents = 0, link_tbl_bytes;
+	struct ablkcipher_edesc *edesc;
+	dma_addr_t iv_dma = 0;
+	bool iv_contig = false;
+	int sgc;
+	int ivsize = crypto_ablkcipher_ivsize(ablkcipher);
+	int link_tbl_index;
+
+	src_nents = sg_count(req->src, req->nbytes);
+
+	if (unlikely(req->dst != req->src))
+		dst_nents = sg_count(req->dst, req->nbytes);
+
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
+	/*
+	 * Check if iv can be contiguous with source and destination.
+	 * If so, include it. If not, create scatterlist.
+	 */
+	iv_dma = dma_map_single(jrdev, req->info, ivsize, DMA_TO_DEVICE);
+	if (!src_nents && iv_dma + ivsize == sg_dma_address(req->src))
+		iv_contig = true;
+	else
+		src_nents = src_nents ? : 1;
+	link_tbl_bytes = ((iv_contig ? 0 : 1) + src_nents + dst_nents) *
+			 sizeof(struct link_tbl_entry);
+
+	/* allocate space for base edesc and hw desc commands, link tables */
+	edesc = kmalloc(sizeof(struct ablkcipher_edesc) + desc_bytes +
+			link_tbl_bytes, GFP_DMA | flags);
+	if (!edesc) {
+		dev_err(jrdev, "could not allocate extended descriptor\n");
+		return ERR_PTR(-ENOMEM);
+	}
+
+	edesc->src_nents = src_nents;
+	edesc->dst_nents = dst_nents;
+	edesc->link_tbl_bytes = link_tbl_bytes;
+	edesc->link_tbl = (void *)edesc + sizeof(struct ablkcipher_edesc) +
+			  desc_bytes;
+
+	link_tbl_index = 0;
+	if (!iv_contig) {
+		sg_to_link_tbl_one(edesc->link_tbl, iv_dma, ivsize, 0);
+		sg_to_link_tbl_last(req->src, src_nents,
+				    edesc->link_tbl + 1, 0);
+		link_tbl_index += 1 + src_nents;
+	}
+
+	if (unlikely(dst_nents)) {
+		sg_to_link_tbl_last(req->dst, dst_nents,
+			edesc->link_tbl + link_tbl_index, 0);
+	}
+
+	edesc->link_tbl_dma = dma_map_single(jrdev, edesc->link_tbl,
+					     link_tbl_bytes, DMA_TO_DEVICE);
+	edesc->iv_dma = iv_dma;
+
+#ifdef DEBUG
+	print_hex_dump(KERN_ERR, "ablkcipher link_tbl@"xstr(__LINE__)": ",
+		       DUMP_PREFIX_ADDRESS, 16, 4, edesc->link_tbl,
+		       link_tbl_bytes, 1);
+#endif
+
+	*iv_contig_out = iv_contig;
+	return edesc;
+}
+
+static int ablkcipher_encrypt(struct ablkcipher_request *req)
+{
+	struct ablkcipher_edesc *edesc;
+	struct crypto_ablkcipher *ablkcipher = crypto_ablkcipher_reqtfm(req);
+	struct caam_ctx *ctx = crypto_ablkcipher_ctx(ablkcipher);
+	struct device *jrdev = ctx->jrdev;
+	bool iv_contig;
+	u32 *desc;
+	int ret = 0;
+
+	/* allocate extended descriptor */
+	edesc = ablkcipher_edesc_alloc(req, DESC_JOB_IO_LEN *
+				       CAAM_CMD_SZ, &iv_contig);
+	if (IS_ERR(edesc))
+		return PTR_ERR(edesc);
+
+	/* Create and submit job descriptor*/
+	init_ablkcipher_job(ctx->sh_desc_enc,
+		ctx->sh_desc_enc_dma, edesc, req, iv_contig);
+#ifdef DEBUG
+	print_hex_dump(KERN_ERR, "ablkcipher jobdesc@"xstr(__LINE__)": ",
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
+static int ablkcipher_decrypt(struct ablkcipher_request *req)
+{
+	struct ablkcipher_edesc *edesc;
+	struct crypto_ablkcipher *ablkcipher = crypto_ablkcipher_reqtfm(req);
+	struct caam_ctx *ctx = crypto_ablkcipher_ctx(ablkcipher);
+	struct device *jrdev = ctx->jrdev;
+	bool iv_contig;
+	u32 *desc;
+	int ret = 0;
+
+	/* allocate extended descriptor */
+	edesc = ablkcipher_edesc_alloc(req, DESC_JOB_IO_LEN *
+				       CAAM_CMD_SZ, &iv_contig);
+	if (IS_ERR(edesc))
+		return PTR_ERR(edesc);
+
+	/* Create and submit job descriptor*/
+	init_ablkcipher_job(ctx->sh_desc_dec,
+		ctx->sh_desc_dec_dma, edesc, req, iv_contig);
+	desc = edesc->hw_desc;
+#ifdef DEBUG
+	print_hex_dump(KERN_ERR, "ablkcipher jobdesc@"xstr(__LINE__)": ",
+		       DUMP_PREFIX_ADDRESS, 16, 4, edesc->hw_desc,
+		       desc_bytes(edesc->hw_desc), 1);
+#endif
+
+	ret = caam_jr_enqueue(jrdev, desc, ablkcipher_decrypt_done, req);
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
+#define template_ablkcipher	template_u.ablkcipher
 struct caam_alg_template {
 	char name[CRYPTO_MAX_ALG_NAME];
 	char driver_name[CRYPTO_MAX_ALG_NAME];
@@ -1525,6 +1982,55 @@ static struct caam_alg_template driver_algs[] = {
 				   OP_ALG_AAI_HMAC_PRECOMP,
 		.alg_op = OP_ALG_ALGSEL_SHA512 | OP_ALG_AAI_HMAC,
 	},
+	/* ablkcipher descriptor */
+	{
+		.name = "cbc(aes)",
+		.driver_name = "cbc-aes-caam",
+		.blocksize = AES_BLOCK_SIZE,
+		.type = CRYPTO_ALG_TYPE_ABLKCIPHER,
+		.template_ablkcipher = {
+			.setkey = ablkcipher_setkey,
+			.encrypt = ablkcipher_encrypt,
+			.decrypt = ablkcipher_decrypt,
+			.geniv = "eseqiv",
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
+		.type = CRYPTO_ALG_TYPE_ABLKCIPHER,
+		.template_ablkcipher = {
+			.setkey = ablkcipher_setkey,
+			.encrypt = ablkcipher_encrypt,
+			.decrypt = ablkcipher_decrypt,
+			.geniv = "eseqiv",
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
+		.type = CRYPTO_ALG_TYPE_ABLKCIPHER,
+		.template_ablkcipher = {
+			.setkey = ablkcipher_setkey,
+			.encrypt = ablkcipher_encrypt,
+			.decrypt = ablkcipher_decrypt,
+			.geniv = "eseqiv",
+			.min_keysize = DES_KEY_SIZE,
+			.max_keysize = DES_KEY_SIZE,
+			.ivsize = DES_BLOCK_SIZE,
+			},
+		.class1_alg_type = OP_ALG_ALGSEL_DES | OP_ALG_AAI_CBC,
+	}
 };
 
 struct caam_crypto_alg {
@@ -1644,6 +2150,10 @@ static struct caam_crypto_alg *caam_alg_alloc(struct device *ctrldev,
 	alg->cra_ctxsize = sizeof(struct caam_ctx);
 	alg->cra_flags = CRYPTO_ALG_ASYNC | template->type;
 	switch (template->type) {
+	case CRYPTO_ALG_TYPE_ABLKCIPHER:
+		alg->cra_type = &crypto_ablkcipher_type;
+		alg->cra_ablkcipher = template->template_ablkcipher;
+		break;
 	case CRYPTO_ALG_TYPE_AEAD:
 		alg->cra_type = &crypto_aead_type;
 		alg->cra_aead = template->template_aead;
diff --git a/drivers/crypto/caam/compat.h b/drivers/crypto/caam/compat.h
index 9504503..d38f2af 100644
--- a/drivers/crypto/caam/compat.h
+++ b/drivers/crypto/caam/compat.h
@@ -31,5 +31,6 @@
 #include <crypto/aead.h>
 #include <crypto/authenc.h>
 #include <crypto/scatterwalk.h>
+#include <crypto/internal/skcipher.h>
 
 #endif /* !defined(CAAM_COMPAT_H) */
-- 
1.7.6
