From: Harsh Jain <harsh@chelsio.com>
Subject: [PATCH 2/6] chcr: Remove malloc/free
Date: Thu, 13 Oct 2016 16:39:35 +0530
Message-ID: <67f49fab047b0b97bac20493dc4414e27c637ab0.1476263960.git.harsh@chelsio.com>
References: <cover.1476263960.git.harsh@chelsio.com>
Cc: jlulla@chelsio.com, atul.gupta@chelsio.com, yeshaswi@chelsio.com,
        hariprasad@chelsio.com, Harsh Jain <harsh@chelsio.com>,
        Jitendra Lulla <JLULLA@chelsio.com>
To: dan.carpenter@oracle.com, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([12.32.117.8]:43035 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753878AbcJMLNM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 13 Oct 2016 07:13:12 -0400
In-Reply-To: <cover.1476263960.git.harsh@chelsio.com>
In-Reply-To: <cover.1476263960.git.harsh@chelsio.com>
References: <cover.1476263960.git.harsh@chelsio.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Remove malloc/free in crypto operation and allocate memory via cra_ctxsize.
Added new structure chcr_wr to populate Work Request Header.
Fixes: 324429d74127 (chcr: Support for Chelsio's Crypto Hardware)

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Jitendra Lulla <JLULLA@chelsio.com>
---
 drivers/crypto/chelsio/chcr_algo.c   | 361 +++++++++++++++++------------------
 drivers/crypto/chelsio/chcr_algo.h   |  28 ++-
 drivers/crypto/chelsio/chcr_core.h   |  16 ++
 drivers/crypto/chelsio/chcr_crypto.h |  16 +-
 4 files changed, 210 insertions(+), 211 deletions(-)

diff --git a/drivers/crypto/chelsio/chcr_algo.c b/drivers/crypto/chelsio/chcr_algo.c
index 944c11f..d5e0066 100644
--- a/drivers/crypto/chelsio/chcr_algo.c
+++ b/drivers/crypto/chelsio/chcr_algo.c
@@ -150,8 +150,6 @@ int chcr_handle_resp(struct crypto_async_request *req, unsigned char *input,
 			       sizeof(struct cpl_fw6_pld),
 			       updated_digestsize);
 		}
-		kfree(ctx_req.ctx.ahash_ctx->dummy_payload_ptr);
-		ctx_req.ctx.ahash_ctx->dummy_payload_ptr = NULL;
 		break;
 	}
 	return 0;
@@ -414,8 +412,23 @@ static inline int get_cryptoalg_subtype(struct crypto_tfm *tfm)
 	return chcr_crypto_alg->type & CRYPTO_ALG_SUB_TYPE_MASK;
 }
 
+static inline void write_buffer_to_skb(struct sk_buff *skb,
+					unsigned int *frags,
+					char *bfr,
+					u8 bfr_len)
+{
+	skb->len += bfr_len;
+	skb->data_len += bfr_len;
+	skb->truesize += bfr_len;
+	get_page(virt_to_page(bfr));
+	skb_fill_page_desc(skb, *frags, virt_to_page(bfr),
+			   offset_in_page(bfr), bfr_len);
+	(*frags)++;
+}
+
+
 static inline void
-write_sg_data_page_desc(struct sk_buff *skb, unsigned int *frags,
+write_sg_to_skb(struct sk_buff *skb, unsigned int *frags,
 			struct scatterlist *sg, unsigned int count)
 {
 	struct page *spage;
@@ -424,8 +437,9 @@ write_sg_data_page_desc(struct sk_buff *skb, unsigned int *frags,
 	skb->len += count;
 	skb->data_len += count;
 	skb->truesize += count;
+
 	while (count > 0) {
-		if (sg && (!(sg->length)))
+		if (!sg || (!(sg->length)))
 			break;
 		spage = sg_page(sg);
 		get_page(spage);
@@ -441,29 +455,24 @@ static int generate_copy_rrkey(struct ablk_ctx *ablkctx,
 			       struct _key_ctx *key_ctx)
 {
 	if (ablkctx->ciph_mode == CHCR_SCMD_CIPHER_MODE_AES_CBC) {
-		get_aes_decrypt_key(key_ctx->key, ablkctx->key,
-				    ablkctx->enckey_len << 3);
-		memset(key_ctx->key + ablkctx->enckey_len, 0,
-		       CHCR_AES_MAX_KEY_LEN - ablkctx->enckey_len);
+		memcpy(key_ctx->key, ablkctx->rrkey, ablkctx->enckey_len);
 	} else {
 		memcpy(key_ctx->key,
 		       ablkctx->key + (ablkctx->enckey_len >> 1),
 		       ablkctx->enckey_len >> 1);
-		get_aes_decrypt_key(key_ctx->key + (ablkctx->enckey_len >> 1),
-				    ablkctx->key, ablkctx->enckey_len << 2);
+		memcpy(key_ctx->key + (ablkctx->enckey_len >> 1),
+		       ablkctx->rrkey, ablkctx->enckey_len >> 1);
 	}
 	return 0;
 }
 
 static inline void create_wreq(struct chcr_context *ctx,
-			       struct fw_crypto_lookaside_wr *wreq,
+			       struct chcr_wr *chcr_req,
 			       void *req, struct sk_buff *skb,
 			       int kctx_len, int hash_sz,
 			       unsigned int phys_dsgl)
 {
 	struct uld_ctx *u_ctx = ULD_CTX(ctx);
-	struct ulp_txpkt *ulptx = (struct ulp_txpkt *)(wreq + 1);
-	struct ulptx_idata *sc_imm = (struct ulptx_idata *)(ulptx + 1);
 	int iv_loc = IV_DSGL;
 	int qid = u_ctx->lldi.rxq_ids[ctx->tx_channel_id];
 	unsigned int immdatalen = 0, nr_frags = 0;
@@ -475,24 +484,27 @@ static inline void create_wreq(struct chcr_context *ctx,
 		nr_frags = skb_shinfo(skb)->nr_frags;
 	}
 
-	wreq->op_to_cctx_size = FILL_WR_OP_CCTX_SIZE(immdatalen,
-						     (kctx_len >> 4));
-	wreq->pld_size_hash_size =
+	chcr_req->wreq.op_to_cctx_size = FILL_WR_OP_CCTX_SIZE(immdatalen,
+				((sizeof(chcr_req->key_ctx) + kctx_len) >> 4));
+	chcr_req->wreq.pld_size_hash_size =
 		htonl(FW_CRYPTO_LOOKASIDE_WR_PLD_SIZE_V(sgl_lengths[nr_frags]) |
 		      FW_CRYPTO_LOOKASIDE_WR_HASH_SIZE_V(hash_sz));
-	wreq->len16_pkd = htonl(FW_CRYPTO_LOOKASIDE_WR_LEN16_V(DIV_ROUND_UP(
+	chcr_req->wreq.len16_pkd =
+		htonl(FW_CRYPTO_LOOKASIDE_WR_LEN16_V(DIV_ROUND_UP(
 				    (calc_tx_flits_ofld(skb) * 8), 16)));
-	wreq->cookie = cpu_to_be64((uintptr_t)req);
-	wreq->rx_chid_to_rx_q_id =
+	chcr_req->wreq.cookie = cpu_to_be64((uintptr_t)req);
+	chcr_req->wreq.rx_chid_to_rx_q_id =
 		FILL_WR_RX_Q_ID(ctx->dev->tx_channel_id, qid,
 				(hash_sz) ? IV_NOP : iv_loc);
 
-	ulptx->cmd_dest = FILL_ULPTX_CMD_DEST(ctx->dev->tx_channel_id);
-	ulptx->len = htonl((DIV_ROUND_UP((calc_tx_flits_ofld(skb) * 8),
-					 16) - ((sizeof(*wreq)) >> 4)));
+	chcr_req->ulptx.cmd_dest = FILL_ULPTX_CMD_DEST(ctx->dev->tx_channel_id);
+	chcr_req->ulptx.len = htonl((DIV_ROUND_UP((calc_tx_flits_ofld(skb) * 8),
+					16) - ((sizeof(chcr_req->wreq)) >> 4)));
 
-	sc_imm->cmd_more = FILL_CMD_MORE(immdatalen);
-	sc_imm->len = cpu_to_be32(sizeof(struct cpl_tx_sec_pdu) + kctx_len +
+	chcr_req->sc_imm.cmd_more = FILL_CMD_MORE(immdatalen);
+	chcr_req->sc_imm.len = cpu_to_be32(sizeof(struct cpl_tx_sec_pdu) +
+				   sizeof(chcr_req->key_ctx) +
+				   kctx_len +
 				  ((hash_sz) ? DUMMY_BYTES :
 				  (sizeof(struct cpl_rx_phys_dsgl) +
 				   phys_dsgl)) + immdatalen);
@@ -506,23 +518,23 @@ static inline void create_wreq(struct chcr_context *ctx,
  *	@op_type:	encryption or decryption
  */
 static struct sk_buff
-*create_cipher_wr(struct crypto_async_request *req_base,
-		  struct chcr_context *ctx, unsigned short qid,
+*create_cipher_wr(struct ablkcipher_request *req,
+		  unsigned short qid,
 		  unsigned short op_type)
 {
-	struct ablkcipher_request *req = (struct ablkcipher_request *)req_base;
 	struct crypto_ablkcipher *tfm = crypto_ablkcipher_reqtfm(req);
+	struct chcr_context *ctx = crypto_ablkcipher_ctx(tfm);
 	struct uld_ctx *u_ctx = ULD_CTX(ctx);
 	struct ablk_ctx *ablkctx = ABLK_CTX(ctx);
 	struct sk_buff *skb = NULL;
-	struct _key_ctx *key_ctx;
-	struct fw_crypto_lookaside_wr *wreq;
-	struct cpl_tx_sec_pdu *sec_cpl;
+	struct chcr_wr *chcr_req;
 	struct cpl_rx_phys_dsgl *phys_cpl;
 	struct chcr_blkcipher_req_ctx *req_ctx = ablkcipher_request_ctx(req);
 	struct phys_sge_parm sg_param;
 	unsigned int frags = 0, transhdr_len, phys_dsgl, dst_bufsize = 0;
 	unsigned int ivsize = crypto_ablkcipher_ivsize(tfm), kctx_len;
+	gfp_t flags = req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP ? GFP_KERNEL :
+			GFP_ATOMIC;
 
 	if (!req->info)
 		return ERR_PTR(-EINVAL);
@@ -530,62 +542,57 @@ static struct sk_buff
 	ablkctx->enc = op_type;
 
 	if ((ablkctx->enckey_len == 0) || (ivsize > AES_BLOCK_SIZE) ||
-	    (req->nbytes <= 0) || (req->nbytes % AES_BLOCK_SIZE))
+	    (req->nbytes <= 0) || (req->nbytes % AES_BLOCK_SIZE)) {
+		pr_err("AES: Invalid value of Key Len %d nbytes %d IV Len %d\n",
+		       ablkctx->enckey_len, req->nbytes, ivsize);
 		return ERR_PTR(-EINVAL);
+	}
 
 	phys_dsgl = get_space_for_phys_dsgl(ablkctx->dst_nents);
 
-	kctx_len = sizeof(*key_ctx) +
-		(DIV_ROUND_UP(ablkctx->enckey_len, 16) * 16);
+	kctx_len = (DIV_ROUND_UP(ablkctx->enckey_len, 16) * 16);
 	transhdr_len = CIPHER_TRANSHDR_SIZE(kctx_len, phys_dsgl);
-	skb = alloc_skb((transhdr_len + sizeof(struct sge_opaque_hdr)),
-			GFP_ATOMIC);
+	skb = alloc_skb((transhdr_len + sizeof(struct sge_opaque_hdr)), flags);
 	if (!skb)
 		return ERR_PTR(-ENOMEM);
 	skb_reserve(skb, sizeof(struct sge_opaque_hdr));
-	wreq = (struct fw_crypto_lookaside_wr *)__skb_put(skb, transhdr_len);
-
-	sec_cpl = (struct cpl_tx_sec_pdu *)((u8 *)wreq + SEC_CPL_OFFSET);
-	sec_cpl->op_ivinsrtofst =
-		FILL_SEC_CPL_OP_IVINSR(ctx->dev->tx_channel_id, 2, 1, 1);
-
-	sec_cpl->pldlen = htonl(ivsize + req->nbytes);
-	sec_cpl->aadstart_cipherstop_hi = FILL_SEC_CPL_CIPHERSTOP_HI(0, 0,
-								ivsize + 1, 0);
-
-	sec_cpl->cipherstop_lo_authinsert =  FILL_SEC_CPL_AUTHINSERT(0, 0,
-								     0, 0);
-	sec_cpl->seqno_numivs = FILL_SEC_CPL_SCMD0_SEQNO(op_type, 0,
+	chcr_req = (struct chcr_wr *)__skb_put(skb, transhdr_len);
+	memset(chcr_req, 0, transhdr_len);
+	chcr_req->sec_cpl.op_ivinsrtofst =
+		FILL_SEC_CPL_OP_IVINSR(ctx->dev->tx_channel_id, 2, 1);
+
+	chcr_req->sec_cpl.pldlen = htonl(ivsize + req->nbytes);
+	chcr_req->sec_cpl.aadstart_cipherstop_hi =
+			FILL_SEC_CPL_CIPHERSTOP_HI(0, 0, ivsize + 1, 0);
+
+	chcr_req->sec_cpl.cipherstop_lo_authinsert =
+			FILL_SEC_CPL_AUTHINSERT(0, 0, 0, 0);
+	chcr_req->sec_cpl.seqno_numivs = FILL_SEC_CPL_SCMD0_SEQNO(op_type, 0,
 							 ablkctx->ciph_mode,
-							 0, 0, ivsize >> 1, 1);
-	sec_cpl->ivgen_hdrlen = FILL_SEC_CPL_IVGEN_HDRLEN(0, 0, 0,
+							 0, 0, ivsize >> 1);
+	chcr_req->sec_cpl.ivgen_hdrlen = FILL_SEC_CPL_IVGEN_HDRLEN(0, 0, 0,
 							  0, 1, phys_dsgl);
 
-	key_ctx = (struct _key_ctx *)((u8 *)sec_cpl + sizeof(*sec_cpl));
-	key_ctx->ctx_hdr = ablkctx->key_ctx_hdr;
+	chcr_req->key_ctx.ctx_hdr = ablkctx->key_ctx_hdr;
 	if (op_type == CHCR_DECRYPT_OP) {
-		if (generate_copy_rrkey(ablkctx, key_ctx))
-			goto map_fail1;
+		generate_copy_rrkey(ablkctx, &chcr_req->key_ctx);
 	} else {
 		if (ablkctx->ciph_mode == CHCR_SCMD_CIPHER_MODE_AES_CBC) {
-			memcpy(key_ctx->key, ablkctx->key, ablkctx->enckey_len);
+			memcpy(chcr_req->key_ctx.key, ablkctx->key,
+			       ablkctx->enckey_len);
 		} else {
-			memcpy(key_ctx->key, ablkctx->key +
+			memcpy(chcr_req->key_ctx.key, ablkctx->key +
 			       (ablkctx->enckey_len >> 1),
 			       ablkctx->enckey_len >> 1);
-			memcpy(key_ctx->key +
+			memcpy(chcr_req->key_ctx.key +
 			       (ablkctx->enckey_len >> 1),
 			       ablkctx->key,
 			       ablkctx->enckey_len >> 1);
 		}
 	}
-	phys_cpl = (struct cpl_rx_phys_dsgl *)((u8 *)key_ctx + kctx_len);
-
-	memcpy(ablkctx->iv, req->info, ivsize);
-	sg_init_table(&ablkctx->iv_sg, 1);
-	sg_set_buf(&ablkctx->iv_sg, ablkctx->iv, ivsize);
+	phys_cpl = (struct cpl_rx_phys_dsgl *)((u8 *)(chcr_req + 1) + kctx_len);
 	sg_param.nents = ablkctx->dst_nents;
-	sg_param.obsize = dst_bufsize;
+	sg_param.obsize = req->nbytes;
 	sg_param.qid = qid;
 	sg_param.align = 1;
 	if (map_writesg_phys_cpl(&u_ctx->lldi.pdev->dev, phys_cpl, req->dst,
@@ -593,9 +600,10 @@ static struct sk_buff
 		goto map_fail1;
 
 	skb_set_transport_header(skb, transhdr_len);
-	write_sg_data_page_desc(skb, &frags, &ablkctx->iv_sg, ivsize);
-	write_sg_data_page_desc(skb, &frags, req->src, req->nbytes);
-	create_wreq(ctx, wreq, req, skb, kctx_len, 0, phys_dsgl);
+	memcpy(ablkctx->iv, req->info, ivsize);
+	write_buffer_to_skb(skb, &frags, ablkctx->iv, ivsize);
+	write_sg_to_skb(skb, &frags, req->src, req->nbytes);
+	create_wreq(ctx, chcr_req, req, skb, kctx_len, 0, phys_dsgl);
 	req_ctx->skb = skb;
 	skb_get(skb);
 	return skb;
@@ -609,15 +617,9 @@ static int chcr_aes_cbc_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
 {
 	struct chcr_context *ctx = crypto_ablkcipher_ctx(tfm);
 	struct ablk_ctx *ablkctx = ABLK_CTX(ctx);
-	struct ablkcipher_alg *alg = crypto_ablkcipher_alg(tfm);
 	unsigned int ck_size, context_size;
 	u16 alignment = 0;
 
-	if ((keylen < alg->min_keysize) || (keylen > alg->max_keysize))
-		goto badkey_err;
-
-	memcpy(ablkctx->key, key, keylen);
-	ablkctx->enckey_len = keylen;
 	if (keylen == AES_KEYSIZE_128) {
 		ck_size = CHCR_KEYCTX_CIPHER_KEY_SIZE_128;
 	} else if (keylen == AES_KEYSIZE_192) {
@@ -628,7 +630,9 @@ static int chcr_aes_cbc_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
 	} else {
 		goto badkey_err;
 	}
-
+	memcpy(ablkctx->key, key, keylen);
+	ablkctx->enckey_len = keylen;
+	get_aes_decrypt_key(ablkctx->rrkey, ablkctx->key, keylen << 3);
 	context_size = (KEY_CONTEXT_HDR_SALT_AND_PAD +
 			keylen + alignment) >> 4;
 
@@ -662,7 +666,6 @@ static int chcr_aes_encrypt(struct ablkcipher_request *req)
 {
 	struct crypto_ablkcipher *tfm = crypto_ablkcipher_reqtfm(req);
 	struct chcr_context *ctx = crypto_ablkcipher_ctx(tfm);
-	struct crypto_async_request *req_base = &req->base;
 	struct uld_ctx *u_ctx = ULD_CTX(ctx);
 	struct sk_buff *skb;
 
@@ -672,8 +675,7 @@ static int chcr_aes_encrypt(struct ablkcipher_request *req)
 			return -EBUSY;
 	}
 
-	skb = create_cipher_wr(req_base, ctx,
-			       u_ctx->lldi.rxq_ids[ctx->tx_channel_id],
+	skb = create_cipher_wr(req, u_ctx->lldi.rxq_ids[ctx->tx_channel_id],
 			       CHCR_ENCRYPT_OP);
 	if (IS_ERR(skb)) {
 		pr_err("chcr : %s : Failed to form WR. No memory\n", __func__);
@@ -689,7 +691,6 @@ static int chcr_aes_decrypt(struct ablkcipher_request *req)
 {
 	struct crypto_ablkcipher *tfm = crypto_ablkcipher_reqtfm(req);
 	struct chcr_context *ctx = crypto_ablkcipher_ctx(tfm);
-	struct crypto_async_request *req_base = &req->base;
 	struct uld_ctx *u_ctx = ULD_CTX(ctx);
 	struct sk_buff *skb;
 
@@ -699,7 +700,7 @@ static int chcr_aes_decrypt(struct ablkcipher_request *req)
 			return -EBUSY;
 	}
 
-	skb = create_cipher_wr(req_base, ctx, u_ctx->lldi.rxq_ids[0],
+	skb = create_cipher_wr(req, u_ctx->lldi.rxq_ids[0],
 			       CHCR_DECRYPT_OP);
 	if (IS_ERR(skb)) {
 		pr_err("chcr : %s : Failed to form WR. No memory\n", __func__);
@@ -779,33 +780,11 @@ static int get_alg_config(struct algo_param *params,
 	return 0;
 }
 
-static inline int
-write_buffer_data_page_desc(struct chcr_ahash_req_ctx *req_ctx,
-			    struct sk_buff *skb, unsigned int *frags, char *bfr,
-			    u8 bfr_len)
-{
-	void *page_ptr = NULL;
-
-	skb->len += bfr_len;
-	skb->data_len += bfr_len;
-	skb->truesize += bfr_len;
-	page_ptr = kmalloc(CHCR_HASH_MAX_BLOCK_SIZE_128, GFP_ATOMIC | GFP_DMA);
-	if (!page_ptr)
-		return -ENOMEM;
-	get_page(virt_to_page(page_ptr));
-	req_ctx->dummy_payload_ptr = page_ptr;
-	memcpy(page_ptr, bfr, bfr_len);
-	skb_fill_page_desc(skb, *frags, virt_to_page(page_ptr),
-			   offset_in_page(page_ptr), bfr_len);
-	(*frags)++;
-	return 0;
-}
-
 /**
- *	create_final_hash_wr - Create hash work request
+ *	create_hash_wr - Create hash work request
  *	@req - Cipher req base
  */
-static struct sk_buff *create_final_hash_wr(struct ahash_request *req,
+static struct sk_buff *create_hash_wr(struct ahash_request *req,
 					    struct hash_wr_param *param)
 {
 	struct chcr_ahash_req_ctx *req_ctx = ahash_request_ctx(req);
@@ -813,16 +792,16 @@ static struct sk_buff *create_final_hash_wr(struct ahash_request *req,
 	struct chcr_context *ctx = crypto_tfm_ctx(crypto_ahash_tfm(tfm));
 	struct hmac_ctx *hmacctx = HMAC_CTX(ctx);
 	struct sk_buff *skb = NULL;
-	struct _key_ctx *key_ctx;
-	struct fw_crypto_lookaside_wr *wreq;
-	struct cpl_tx_sec_pdu *sec_cpl;
+	struct chcr_wr *chcr_req;
 	unsigned int frags = 0, transhdr_len, iopad_alignment = 0;
 	unsigned int digestsize = crypto_ahash_digestsize(tfm);
-	unsigned int kctx_len = sizeof(*key_ctx);
+	unsigned int kctx_len = 0;
 	u8 hash_size_in_response = 0;
+	gfp_t flags = req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP ? GFP_KERNEL :
+		GFP_ATOMIC;
 
 	iopad_alignment = KEYCTX_ALIGN_PAD(digestsize);
-	kctx_len += param->alg_prm.result_size + iopad_alignment;
+	kctx_len = param->alg_prm.result_size + iopad_alignment;
 	if (param->opad_needed)
 		kctx_len += param->alg_prm.result_size + iopad_alignment;
 
@@ -831,53 +810,53 @@ static struct sk_buff *create_final_hash_wr(struct ahash_request *req,
 	else
 		hash_size_in_response = param->alg_prm.result_size;
 	transhdr_len = HASH_TRANSHDR_SIZE(kctx_len);
-	skb = alloc_skb((transhdr_len + sizeof(struct sge_opaque_hdr)),
-			GFP_ATOMIC);
+	skb = alloc_skb((transhdr_len + sizeof(struct sge_opaque_hdr)), flags);
 	if (!skb)
 		return skb;
 
 	skb_reserve(skb, sizeof(struct sge_opaque_hdr));
-	wreq = (struct fw_crypto_lookaside_wr *)__skb_put(skb, transhdr_len);
-	memset(wreq, 0, transhdr_len);
+	chcr_req = (struct chcr_wr *)__skb_put(skb, transhdr_len);
+	memset(chcr_req, 0, transhdr_len);
 
-	sec_cpl = (struct cpl_tx_sec_pdu *)((u8 *)wreq + SEC_CPL_OFFSET);
-	sec_cpl->op_ivinsrtofst =
-		FILL_SEC_CPL_OP_IVINSR(ctx->dev->tx_channel_id, 2, 0, 0);
-	sec_cpl->pldlen = htonl(param->bfr_len + param->sg_len);
+	chcr_req->sec_cpl.op_ivinsrtofst =
+		FILL_SEC_CPL_OP_IVINSR(ctx->dev->tx_channel_id, 2, 0);
+	chcr_req->sec_cpl.pldlen = htonl(param->bfr_len + param->sg_len);
 
-	sec_cpl->aadstart_cipherstop_hi =
+	chcr_req->sec_cpl.aadstart_cipherstop_hi =
 		FILL_SEC_CPL_CIPHERSTOP_HI(0, 0, 0, 0);
-	sec_cpl->cipherstop_lo_authinsert =
+	chcr_req->sec_cpl.cipherstop_lo_authinsert =
 		FILL_SEC_CPL_AUTHINSERT(0, 1, 0, 0);
-	sec_cpl->seqno_numivs =
+	chcr_req->sec_cpl.seqno_numivs =
 		FILL_SEC_CPL_SCMD0_SEQNO(0, 0, 0, param->alg_prm.auth_mode,
-					 param->opad_needed, 0, 0);
+					 param->opad_needed, 0);
 
-	sec_cpl->ivgen_hdrlen =
+	chcr_req->sec_cpl.ivgen_hdrlen =
 		FILL_SEC_CPL_IVGEN_HDRLEN(param->last, param->more, 0, 1, 0, 0);
 
-	key_ctx = (struct _key_ctx *)((u8 *)sec_cpl + sizeof(*sec_cpl));
-	memcpy(key_ctx->key, req_ctx->partial_hash, param->alg_prm.result_size);
+	memcpy(chcr_req->key_ctx.key, req_ctx->partial_hash,
+	       param->alg_prm.result_size);
 
 	if (param->opad_needed)
-		memcpy(key_ctx->key + ((param->alg_prm.result_size <= 32) ? 32 :
-				       CHCR_HASH_MAX_DIGEST_SIZE),
+		memcpy(chcr_req->key_ctx.key +
+		       ((param->alg_prm.result_size <= 32) ? 32 :
+			CHCR_HASH_MAX_DIGEST_SIZE),
 		       hmacctx->opad, param->alg_prm.result_size);
 
-	key_ctx->ctx_hdr = FILL_KEY_CTX_HDR(CHCR_KEYCTX_NO_KEY,
+	chcr_req->key_ctx.ctx_hdr = FILL_KEY_CTX_HDR(CHCR_KEYCTX_NO_KEY,
 					    param->alg_prm.mk_size, 0,
 					    param->opad_needed,
-					    (kctx_len >> 4));
-	sec_cpl->scmd1 = cpu_to_be64((u64)param->scmd1);
+					    ((kctx_len +
+					     sizeof(chcr_req->key_ctx)) >> 4));
+	chcr_req->sec_cpl.scmd1 = cpu_to_be64((u64)param->scmd1);
 
 	skb_set_transport_header(skb, transhdr_len);
 	if (param->bfr_len != 0)
-		write_buffer_data_page_desc(req_ctx, skb, &frags, req_ctx->bfr,
-					    param->bfr_len);
+		write_buffer_to_skb(skb, &frags, req_ctx->reqbfr,
+				    param->bfr_len);
 	if (param->sg_len != 0)
-		write_sg_data_page_desc(skb, &frags, req->src, param->sg_len);
+		write_sg_to_skb(skb, &frags, req->src, param->sg_len);
 
-	create_wreq(ctx, wreq, req, skb, kctx_len, hash_size_in_response,
+	create_wreq(ctx, chcr_req, req, skb, kctx_len, hash_size_in_response,
 		    0);
 	req_ctx->skb = skb;
 	skb_get(skb);
@@ -904,34 +883,41 @@ static int chcr_ahash_update(struct ahash_request *req)
 			return -EBUSY;
 	}
 
-	if (nbytes + req_ctx->bfr_len >= bs) {
-		remainder = (nbytes + req_ctx->bfr_len) % bs;
-		nbytes = nbytes + req_ctx->bfr_len - remainder;
+	if (nbytes + req_ctx->reqlen >= bs) {
+		remainder = (nbytes + req_ctx->reqlen) % bs;
+		nbytes = nbytes + req_ctx->reqlen - remainder;
 	} else {
-		sg_pcopy_to_buffer(req->src, sg_nents(req->src), req_ctx->bfr +
-				   req_ctx->bfr_len, nbytes, 0);
-		req_ctx->bfr_len += nbytes;
+		sg_pcopy_to_buffer(req->src, sg_nents(req->src), req_ctx->reqbfr
+				   + req_ctx->reqlen, nbytes, 0);
+		req_ctx->reqlen += nbytes;
 		return 0;
 	}
 
 	params.opad_needed = 0;
 	params.more = 1;
 	params.last = 0;
-	params.sg_len = nbytes - req_ctx->bfr_len;
-	params.bfr_len = req_ctx->bfr_len;
+	params.sg_len = nbytes - req_ctx->reqlen;
+	params.bfr_len = req_ctx->reqlen;
 	params.scmd1 = 0;
 	get_alg_config(&params.alg_prm, crypto_ahash_digestsize(rtfm));
 	req_ctx->result = 0;
 	req_ctx->data_len += params.sg_len + params.bfr_len;
-	skb = create_final_hash_wr(req, &params);
-	if (!skb)
-		return -ENOMEM;
+	skb = create_hash_wr(req, &params);
+
+	if (IS_ERR(skb))
+		return PTR_ERR(skb);
 
-	req_ctx->bfr_len = remainder;
-	if (remainder)
+	if (remainder) {
+		u8 *temp;
+		/* Swap buffers */
+		temp = req_ctx->reqbfr;
+		req_ctx->reqbfr = req_ctx->skbfr;
+		req_ctx->skbfr = temp;
 		sg_pcopy_to_buffer(req->src, sg_nents(req->src),
-				   req_ctx->bfr, remainder, req->nbytes -
+				   req_ctx->reqbfr, remainder, req->nbytes -
 				   remainder);
+	}
+	req_ctx->reqlen = remainder;
 	skb->dev = u_ctx->lldi.ports[0];
 	set_wr_txq(skb, CPL_PRIORITY_DATA, ctx->tx_channel_id);
 	chcr_send_wr(skb);
@@ -967,10 +953,10 @@ static int chcr_ahash_final(struct ahash_request *req)
 	params.sg_len = 0;
 	get_alg_config(&params.alg_prm, crypto_ahash_digestsize(rtfm));
 	req_ctx->result = 1;
-	params.bfr_len = req_ctx->bfr_len;
+	params.bfr_len = req_ctx->reqlen;
 	req_ctx->data_len += params.bfr_len + params.sg_len;
-	if (req_ctx->bfr && (req_ctx->bfr_len == 0)) {
-		create_last_hash_block(req_ctx->bfr, bs, req_ctx->data_len);
+	if (req_ctx->reqlen == 0) {
+		create_last_hash_block(req_ctx->reqbfr, bs, req_ctx->data_len);
 		params.last = 0;
 		params.more = 1;
 		params.scmd1 = 0;
@@ -981,7 +967,10 @@ static int chcr_ahash_final(struct ahash_request *req)
 		params.last = 1;
 		params.more = 0;
 	}
-	skb = create_final_hash_wr(req, &params);
+	skb = create_hash_wr(req, &params);
+	if (IS_ERR(skb))
+		return PTR_ERR(skb);
+
 	skb->dev = u_ctx->lldi.ports[0];
 	set_wr_txq(skb, CPL_PRIORITY_DATA, ctx->tx_channel_id);
 	chcr_send_wr(skb);
@@ -1013,12 +1002,12 @@ static int chcr_ahash_finup(struct ahash_request *req)
 		params.opad_needed = 0;
 
 	params.sg_len = req->nbytes;
-	params.bfr_len = req_ctx->bfr_len;
+	params.bfr_len = req_ctx->reqlen;
 	get_alg_config(&params.alg_prm, crypto_ahash_digestsize(rtfm));
 	req_ctx->data_len += params.bfr_len + params.sg_len;
 	req_ctx->result = 1;
-	if (req_ctx->bfr && (req_ctx->bfr_len + req->nbytes) == 0) {
-		create_last_hash_block(req_ctx->bfr, bs, req_ctx->data_len);
+	if ((req_ctx->reqlen + req->nbytes) == 0) {
+		create_last_hash_block(req_ctx->reqbfr, bs, req_ctx->data_len);
 		params.last = 0;
 		params.more = 1;
 		params.scmd1 = 0;
@@ -1029,9 +1018,10 @@ static int chcr_ahash_finup(struct ahash_request *req)
 		params.more = 0;
 	}
 
-	skb = create_final_hash_wr(req, &params);
-	if (!skb)
-		return -ENOMEM;
+	skb = create_hash_wr(req, &params);
+	if (IS_ERR(skb))
+		return PTR_ERR(skb);
+
 	skb->dev = u_ctx->lldi.ports[0];
 	set_wr_txq(skb, CPL_PRIORITY_DATA, ctx->tx_channel_id);
 	chcr_send_wr(skb);
@@ -1073,15 +1063,15 @@ static int chcr_ahash_digest(struct ahash_request *req)
 	req_ctx->result = 1;
 	req_ctx->data_len += params.bfr_len + params.sg_len;
 
-	if (req_ctx->bfr && req->nbytes == 0) {
-		create_last_hash_block(req_ctx->bfr, bs, 0);
+	if (req->nbytes == 0) {
+		create_last_hash_block(req_ctx->reqbfr, bs, 0);
 		params.more = 1;
 		params.bfr_len = bs;
 	}
 
-	skb = create_final_hash_wr(req, &params);
-	if (!skb)
-		return -ENOMEM;
+	skb = create_hash_wr(req, &params);
+	if (IS_ERR(skb))
+		return PTR_ERR(skb);
 
 	skb->dev = u_ctx->lldi.ports[0];
 	set_wr_txq(skb, CPL_PRIORITY_DATA, ctx->tx_channel_id);
@@ -1094,12 +1084,12 @@ static int chcr_ahash_export(struct ahash_request *areq, void *out)
 	struct chcr_ahash_req_ctx *req_ctx = ahash_request_ctx(areq);
 	struct chcr_ahash_req_ctx *state = out;
 
-	state->bfr_len = req_ctx->bfr_len;
+	state->reqlen = req_ctx->reqlen;
 	state->data_len = req_ctx->data_len;
-	memcpy(state->bfr, req_ctx->bfr, CHCR_HASH_MAX_BLOCK_SIZE_128);
+	memcpy(state->bfr1, req_ctx->reqbfr, req_ctx->reqlen);
 	memcpy(state->partial_hash, req_ctx->partial_hash,
 	       CHCR_HASH_MAX_DIGEST_SIZE);
-	return 0;
+		return 0;
 }
 
 static int chcr_ahash_import(struct ahash_request *areq, const void *in)
@@ -1107,10 +1097,11 @@ static int chcr_ahash_import(struct ahash_request *areq, const void *in)
 	struct chcr_ahash_req_ctx *req_ctx = ahash_request_ctx(areq);
 	struct chcr_ahash_req_ctx *state = (struct chcr_ahash_req_ctx *)in;
 
-	req_ctx->bfr_len = state->bfr_len;
+	req_ctx->reqlen = state->reqlen;
 	req_ctx->data_len = state->data_len;
-	req_ctx->dummy_payload_ptr = NULL;
-	memcpy(req_ctx->bfr, state->bfr, CHCR_HASH_MAX_BLOCK_SIZE_128);
+	req_ctx->reqbfr = req_ctx->bfr1;
+	req_ctx->skbfr = req_ctx->bfr2;
+	memcpy(req_ctx->bfr1, state->bfr1, CHCR_HASH_MAX_BLOCK_SIZE_128);
 	memcpy(req_ctx->partial_hash, state->partial_hash,
 	       CHCR_HASH_MAX_DIGEST_SIZE);
 	return 0;
@@ -1174,28 +1165,29 @@ static int chcr_aes_xts_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
 {
 	struct chcr_context *ctx = crypto_ablkcipher_ctx(tfm);
 	struct ablk_ctx *ablkctx = ABLK_CTX(ctx);
-	int status = 0;
 	unsigned short context_size = 0;
 
-	if ((key_len == (AES_KEYSIZE_128 << 1)) ||
-	    (key_len == (AES_KEYSIZE_256 << 1))) {
-		memcpy(ablkctx->key, key, key_len);
-		ablkctx->enckey_len = key_len;
-		context_size = (KEY_CONTEXT_HDR_SALT_AND_PAD + key_len) >> 4;
-		ablkctx->key_ctx_hdr =
-			FILL_KEY_CTX_HDR((key_len == AES_KEYSIZE_256) ?
-					 CHCR_KEYCTX_CIPHER_KEY_SIZE_128 :
-					 CHCR_KEYCTX_CIPHER_KEY_SIZE_256,
-					 CHCR_KEYCTX_NO_KEY, 1,
-					 0, context_size);
-		ablkctx->ciph_mode = CHCR_SCMD_CIPHER_MODE_AES_XTS;
-	} else {
+	if ((key_len != (AES_KEYSIZE_128 << 1)) &&
+	    (key_len != (AES_KEYSIZE_256 << 1))) {
 		crypto_tfm_set_flags((struct crypto_tfm *)tfm,
 				     CRYPTO_TFM_RES_BAD_KEY_LEN);
 		ablkctx->enckey_len = 0;
-		status = -EINVAL;
+		return -EINVAL;
+
 	}
-	return status;
+
+	memcpy(ablkctx->key, key, key_len);
+	ablkctx->enckey_len = key_len;
+	get_aes_decrypt_key(ablkctx->rrkey, ablkctx->key, key_len << 2);
+	context_size = (KEY_CONTEXT_HDR_SALT_AND_PAD + key_len) >> 4;
+	ablkctx->key_ctx_hdr =
+		FILL_KEY_CTX_HDR((key_len == AES_KEYSIZE_256) ?
+				 CHCR_KEYCTX_CIPHER_KEY_SIZE_128 :
+				 CHCR_KEYCTX_CIPHER_KEY_SIZE_256,
+				 CHCR_KEYCTX_NO_KEY, 1,
+				 0, context_size);
+	ablkctx->ciph_mode = CHCR_SCMD_CIPHER_MODE_AES_XTS;
+	return 0;
 }
 
 static int chcr_sha_init(struct ahash_request *areq)
@@ -1205,8 +1197,9 @@ static int chcr_sha_init(struct ahash_request *areq)
 	int digestsize =  crypto_ahash_digestsize(tfm);
 
 	req_ctx->data_len = 0;
-	req_ctx->dummy_payload_ptr = NULL;
-	req_ctx->bfr_len = 0;
+	req_ctx->reqlen = 0;
+	req_ctx->reqbfr = req_ctx->bfr1;
+	req_ctx->skbfr = req_ctx->bfr2;
 	req_ctx->skb = NULL;
 	req_ctx->result = 0;
 	copy_hash_init_values(req_ctx->partial_hash, digestsize);
diff --git a/drivers/crypto/chelsio/chcr_algo.h b/drivers/crypto/chelsio/chcr_algo.h
index f34bc91..f2a5905 100644
--- a/drivers/crypto/chelsio/chcr_algo.h
+++ b/drivers/crypto/chelsio/chcr_algo.h
@@ -108,30 +108,24 @@
 #define IPAD_DATA 0x36363636
 #define OPAD_DATA 0x5c5c5c5c
 
-#define TRANSHDR_SIZE(alignedkctx_len)\
-	(sizeof(struct ulptx_idata) +\
-	 sizeof(struct ulp_txpkt) +\
-	 sizeof(struct fw_crypto_lookaside_wr) +\
-	 sizeof(struct cpl_tx_sec_pdu) +\
-	 (alignedkctx_len))
-#define CIPHER_TRANSHDR_SIZE(alignedkctx_len, sge_pairs) \
-	(TRANSHDR_SIZE(alignedkctx_len) + sge_pairs +\
+#define TRANSHDR_SIZE(kctx_len)\
+	(sizeof(struct chcr_wr) +\
+	 kctx_len)
+#define CIPHER_TRANSHDR_SIZE(kctx_len, sge_pairs) \
+	(TRANSHDR_SIZE((kctx_len)) + (sge_pairs) +\
 	 sizeof(struct cpl_rx_phys_dsgl))
-#define HASH_TRANSHDR_SIZE(alignedkctx_len)\
-	(TRANSHDR_SIZE(alignedkctx_len) + DUMMY_BYTES)
+#define HASH_TRANSHDR_SIZE(kctx_len)\
+	(TRANSHDR_SIZE(kctx_len) + DUMMY_BYTES)
 
-#define SEC_CPL_OFFSET (sizeof(struct fw_crypto_lookaside_wr) + \
-			sizeof(struct ulp_txpkt) + \
-			sizeof(struct ulptx_idata))
 
-#define FILL_SEC_CPL_OP_IVINSR(id, len, hldr, ofst)      \
+#define FILL_SEC_CPL_OP_IVINSR(id, len, ofst)      \
 	htonl( \
 	       CPL_TX_SEC_PDU_OPCODE_V(CPL_TX_SEC_PDU) | \
 	       CPL_TX_SEC_PDU_RXCHID_V((id)) | \
 	       CPL_TX_SEC_PDU_ACKFOLLOWS_V(0) | \
 	       CPL_TX_SEC_PDU_ULPTXLPBK_V(1) | \
 	       CPL_TX_SEC_PDU_CPLLEN_V((len)) | \
-	       CPL_TX_SEC_PDU_PLACEHOLDER_V((hldr)) | \
+	       CPL_TX_SEC_PDU_PLACEHOLDER_V(0) | \
 	       CPL_TX_SEC_PDU_IVINSRTOFST_V((ofst)))
 
 #define  FILL_SEC_CPL_CIPHERSTOP_HI(a_start, a_stop, c_start, c_stop_hi) \
@@ -148,7 +142,7 @@
 		CPL_TX_SEC_PDU_AUTHSTOP_V((a_stop)) | \
 		CPL_TX_SEC_PDU_AUTHINSERT_V((a_inst)))
 
-#define  FILL_SEC_CPL_SCMD0_SEQNO(ctrl, seq, cmode, amode, opad, size, nivs)  \
+#define  FILL_SEC_CPL_SCMD0_SEQNO(ctrl, seq, cmode, amode, opad, size)  \
 		htonl( \
 		SCMD_SEQ_NO_CTRL_V(0) | \
 		SCMD_STATUS_PRESENT_V(0) | \
@@ -159,7 +153,7 @@
 		SCMD_AUTH_MODE_V((amode)) | \
 		SCMD_HMAC_CTRL_V((opad)) | \
 		SCMD_IV_SIZE_V((size)) | \
-		SCMD_NUM_IVS_V((nivs)))
+		SCMD_NUM_IVS_V(0))
 
 #define FILL_SEC_CPL_IVGEN_HDRLEN(last, more, ctx_in, mac, ivdrop, len) htonl( \
 		SCMD_ENB_DBGID_V(0) | \
diff --git a/drivers/crypto/chelsio/chcr_core.h b/drivers/crypto/chelsio/chcr_core.h
index 2a5c671..fc3cd77 100644
--- a/drivers/crypto/chelsio/chcr_core.h
+++ b/drivers/crypto/chelsio/chcr_core.h
@@ -52,9 +52,25 @@
 
 #define MAC_ERROR_BIT		0
 #define CHK_MAC_ERR_BIT(x)	(((x) >> MAC_ERROR_BIT) & 1)
+#define MAX_SALT                4
 
 struct uld_ctx;
 
+struct _key_ctx {
+	__be32 ctx_hdr;
+	u8 salt[MAX_SALT];
+	__be64 reserverd;
+	unsigned char key[0];
+};
+
+struct chcr_wr {
+	struct fw_crypto_lookaside_wr wreq;
+	struct ulp_txpkt ulptx;
+	struct ulptx_idata sc_imm;
+	struct cpl_tx_sec_pdu sec_cpl;
+	struct _key_ctx key_ctx;
+};
+
 struct chcr_dev {
 	/* Request submited to h/w and waiting for response. */
 	spinlock_t lock_chcr_dev;
diff --git a/drivers/crypto/chelsio/chcr_crypto.h b/drivers/crypto/chelsio/chcr_crypto.h
index d7d7560..7ed6d2b 100644
--- a/drivers/crypto/chelsio/chcr_crypto.h
+++ b/drivers/crypto/chelsio/chcr_crypto.h
@@ -118,12 +118,6 @@
 #define CHCR_HASH_MAX_BLOCK_SIZE_128 128
 
 /* Aligned to 128 bit boundary */
-struct _key_ctx {
-	__be32 ctx_hdr;
-	u8 salt[MAX_SALT];
-	__be64 reserverd;
-	unsigned char key[0];
-};
 
 struct ablk_ctx {
 	u8 enc;
@@ -131,8 +125,8 @@ struct ablk_ctx {
 	__be32 key_ctx_hdr;
 	unsigned int enckey_len;
 	unsigned int dst_nents;
-	struct scatterlist iv_sg;
 	u8 key[CHCR_AES_MAX_KEY_LEN];
+	u8 rrkey[AES_MAX_KEY_SIZE];
 	u8 iv[CHCR_MAX_CRYPTO_IV_LEN];
 	unsigned char ciph_mode;
 };
@@ -156,12 +150,14 @@ struct chcr_context {
 
 struct chcr_ahash_req_ctx {
 	u32 result;
-	char bfr[CHCR_HASH_MAX_BLOCK_SIZE_128];
-	u8 bfr_len;
+	u8 bfr1[CHCR_HASH_MAX_BLOCK_SIZE_128];
+	u8 bfr2[CHCR_HASH_MAX_BLOCK_SIZE_128];
+	u8 *reqbfr;
+	u8 *skbfr;
+	u8 reqlen;
 	/* DMA the partial hash in it */
 	u8 partial_hash[CHCR_HASH_MAX_DIGEST_SIZE];
 	u64 data_len;  /* Data len till time */
-	void *dummy_payload_ptr;
 	/* SKB which is being sent to the hardware for processing */
 	struct sk_buff *skb;
 };
-- 
1.8.2.3
