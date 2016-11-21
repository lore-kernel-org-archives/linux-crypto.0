From: Harsh Jain <harsh@chelsio.com>
Subject: [PATCH v2 2/9]crypto/chcr: Added new structure chcr_wr to populate Work Request Header.
Date: Mon, 21 Nov 2016 21:30:48 +0530
Message-ID: <24d8442c629916714b2d3303e0aaad3b75ad6158.1479740559.git.harsh@chelsio.com>
References: <cover.1479740559.git.harsh@chelsio.com>
Cc: Harsh Jain <harsh@chelsio.com>, Jitendra Lulla <JLULLA@chelsio.com>
To: dan.carpenter@oracle.com, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, smueller@chronox.de,
        jlulla@chelsio.com, atul.gupta@chelsio.com, yeshaswi@chelsio.com,
        hariprasad@chelsio.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([12.32.117.8]:63759 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754380AbcKUQBg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Nov 2016 11:01:36 -0500
In-Reply-To: <cover.1479740559.git.harsh@chelsio.com>
In-Reply-To: <cover.1479740559.git.harsh@chelsio.com>
References: <cover.1479740559.git.harsh@chelsio.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Jitendra Lulla <JLULLA@chelsio.com>
---
 drivers/crypto/chelsio/chcr_algo.c   | 239 +++++++++++++++++------------------
 drivers/crypto/chelsio/chcr_algo.h   |  28 ++--
 drivers/crypto/chelsio/chcr_core.h   |  16 +++
 drivers/crypto/chelsio/chcr_crypto.h |   6 -
 4 files changed, 140 insertions(+), 149 deletions(-)

diff --git a/drivers/crypto/chelsio/chcr_algo.c b/drivers/crypto/chelsio/chcr_algo.c
index 944c11f..5918e1e 100644
--- a/drivers/crypto/chelsio/chcr_algo.c
+++ b/drivers/crypto/chelsio/chcr_algo.c
@@ -414,8 +414,23 @@ static inline int get_cryptoalg_subtype(struct crypto_tfm *tfm)
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
@@ -456,14 +471,12 @@ static int generate_copy_rrkey(struct ablk_ctx *ablkctx,
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
@@ -475,24 +488,27 @@ static inline void create_wreq(struct chcr_context *ctx,
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
@@ -506,23 +522,23 @@ static inline void create_wreq(struct chcr_context *ctx,
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
@@ -530,62 +546,57 @@ static inline void create_wreq(struct chcr_context *ctx,
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
@@ -593,9 +604,10 @@ static inline void create_wreq(struct chcr_context *ctx,
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
@@ -662,7 +674,6 @@ static int chcr_aes_encrypt(struct ablkcipher_request *req)
 {
 	struct crypto_ablkcipher *tfm = crypto_ablkcipher_reqtfm(req);
 	struct chcr_context *ctx = crypto_ablkcipher_ctx(tfm);
-	struct crypto_async_request *req_base = &req->base;
 	struct uld_ctx *u_ctx = ULD_CTX(ctx);
 	struct sk_buff *skb;
 
@@ -672,8 +683,7 @@ static int chcr_aes_encrypt(struct ablkcipher_request *req)
 			return -EBUSY;
 	}
 
-	skb = create_cipher_wr(req_base, ctx,
-			       u_ctx->lldi.rxq_ids[ctx->tx_channel_id],
+	skb = create_cipher_wr(req, u_ctx->lldi.rxq_ids[ctx->tx_channel_id],
 			       CHCR_ENCRYPT_OP);
 	if (IS_ERR(skb)) {
 		pr_err("chcr : %s : Failed to form WR. No memory\n", __func__);
@@ -689,7 +699,6 @@ static int chcr_aes_decrypt(struct ablkcipher_request *req)
 {
 	struct crypto_ablkcipher *tfm = crypto_ablkcipher_reqtfm(req);
 	struct chcr_context *ctx = crypto_ablkcipher_ctx(tfm);
-	struct crypto_async_request *req_base = &req->base;
 	struct uld_ctx *u_ctx = ULD_CTX(ctx);
 	struct sk_buff *skb;
 
@@ -699,7 +708,7 @@ static int chcr_aes_decrypt(struct ablkcipher_request *req)
 			return -EBUSY;
 	}
 
-	skb = create_cipher_wr(req_base, ctx, u_ctx->lldi.rxq_ids[0],
+	skb = create_cipher_wr(req, u_ctx->lldi.rxq_ids[0],
 			       CHCR_DECRYPT_OP);
 	if (IS_ERR(skb)) {
 		pr_err("chcr : %s : Failed to form WR. No memory\n", __func__);
@@ -779,33 +788,11 @@ static int get_alg_config(struct algo_param *params,
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
@@ -813,16 +800,16 @@ static struct sk_buff *create_final_hash_wr(struct ahash_request *req,
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
 
@@ -831,53 +818,53 @@ static struct sk_buff *create_final_hash_wr(struct ahash_request *req,
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
+		write_buffer_to_skb(skb, &frags, req_ctx->bfr,
 					    param->bfr_len);
 	if (param->sg_len != 0)
-		write_sg_data_page_desc(skb, &frags, req->src, param->sg_len);
+		write_sg_to_skb(skb, &frags, req->src, param->sg_len);
 
-	create_wreq(ctx, wreq, req, skb, kctx_len, hash_size_in_response,
+	create_wreq(ctx, chcr_req, req, skb, kctx_len, hash_size_in_response,
 		    0);
 	req_ctx->skb = skb;
 	skb_get(skb);
@@ -917,15 +904,11 @@ static int chcr_ahash_update(struct ahash_request *req)
 	params.opad_needed = 0;
 	params.more = 1;
 	params.last = 0;
-	params.sg_len = nbytes - req_ctx->bfr_len;
-	params.bfr_len = req_ctx->bfr_len;
 	params.scmd1 = 0;
 	get_alg_config(&params.alg_prm, crypto_ahash_digestsize(rtfm));
 	req_ctx->result = 0;
 	req_ctx->data_len += params.sg_len + params.bfr_len;
-	skb = create_final_hash_wr(req, &params);
-	if (!skb)
-		return -ENOMEM;
+	skb = create_hash_wr(req, &params);
 
 	req_ctx->bfr_len = remainder;
 	if (remainder)
@@ -981,7 +964,10 @@ static int chcr_ahash_final(struct ahash_request *req)
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
@@ -1029,9 +1015,10 @@ static int chcr_ahash_finup(struct ahash_request *req)
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
@@ -1079,9 +1066,9 @@ static int chcr_ahash_digest(struct ahash_request *req)
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
index d7d7560..acce367 100644
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
-- 
1.8.2.3
