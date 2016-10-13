From: Harsh Jain <harsh@chelsio.com>
Subject: [PATCH 6/6] Add support for AEAD algos.
Date: Thu, 13 Oct 2016 16:39:39 +0530
Message-ID: <6a957e083297221dc2810a3efd17f936dad2475e.1476263960.git.harsh@chelsio.com>
References: <cover.1476263960.git.harsh@chelsio.com>
Cc: jlulla@chelsio.com, atul.gupta@chelsio.com, yeshaswi@chelsio.com,
        hariprasad@chelsio.com, Harsh Jain <harsh@chelsio.com>
To: dan.carpenter@oracle.com, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([12.32.117.8]:42556 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754164AbcJMLNM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 13 Oct 2016 07:13:12 -0400
In-Reply-To: <cover.1476263960.git.harsh@chelsio.com>
In-Reply-To: <cover.1476263960.git.harsh@chelsio.com>
References: <cover.1476263960.git.harsh@chelsio.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add support for following AEAD algos.
 GCM,CCM,RFC4106,RFC4309,authenc(hmac(shaXXX),cbc(aes)).

Signed-off-by: Harsh Jain <harsh@chelsio.com>
---
 drivers/crypto/chelsio/Kconfig       |    1 +
 drivers/crypto/chelsio/chcr_algo.c   | 1466 +++++++++++++++++++++++++++++++++-
 drivers/crypto/chelsio/chcr_algo.h   |   16 +-
 drivers/crypto/chelsio/chcr_core.c   |    8 +-
 drivers/crypto/chelsio/chcr_core.h   |    2 -
 drivers/crypto/chelsio/chcr_crypto.h |   90 ++-
 6 files changed, 1541 insertions(+), 42 deletions(-)

diff --git a/drivers/crypto/chelsio/Kconfig b/drivers/crypto/chelsio/Kconfig
index 4ce67fb..3e104f5 100644
--- a/drivers/crypto/chelsio/Kconfig
+++ b/drivers/crypto/chelsio/Kconfig
@@ -4,6 +4,7 @@ config CRYPTO_DEV_CHELSIO
 	select CRYPTO_SHA1
 	select CRYPTO_SHA256
 	select CRYPTO_SHA512
+	select CRYPTO_AUTHENC
 	---help---
 	  The Chelsio Crypto Co-processor driver for T6 adapters.
 
diff --git a/drivers/crypto/chelsio/chcr_algo.c b/drivers/crypto/chelsio/chcr_algo.c
index 18385d6..cffc38f 100644
--- a/drivers/crypto/chelsio/chcr_algo.c
+++ b/drivers/crypto/chelsio/chcr_algo.c
@@ -54,6 +54,12 @@
 #include <crypto/algapi.h>
 #include <crypto/hash.h>
 #include <crypto/sha.h>
+#include <crypto/authenc.h>
+#include <crypto/internal/aead.h>
+#include <crypto/null.h>
+#include <crypto/internal/skcipher.h>
+#include <crypto/aead.h>
+#include <crypto/scatterwalk.h>
 #include <crypto/internal/hash.h>
 
 #include "t4fw_api.h"
@@ -62,6 +68,11 @@
 #include "chcr_algo.h"
 #include "chcr_crypto.h"
 
+static inline  struct chcr_aead_ctx *AEAD_CTX(struct chcr_context *ctx)
+{
+	return ctx->crypto_ctx->aeadctx;
+}
+
 static inline struct ablk_ctx *ABLK_CTX(struct chcr_context *ctx)
 {
 	return ctx->crypto_ctx->ablkctx;
@@ -72,6 +83,16 @@ static inline struct hmac_ctx *HMAC_CTX(struct chcr_context *ctx)
 	return ctx->crypto_ctx->hmacctx;
 }
 
+static inline struct chcr_gcm_ctx *GCM_CTX(struct chcr_aead_ctx *gctx)
+{
+	return gctx->ctx->gcm;
+}
+
+static inline struct chcr_authenc_ctx *AUTHENC_CTX(struct chcr_aead_ctx *gctx)
+{
+	return gctx->ctx->authenc;
+}
+
 static inline struct uld_ctx *ULD_CTX(struct chcr_context *ctx)
 {
 	return ctx->dev->u_ctx;
@@ -94,12 +115,37 @@ static inline unsigned int sgl_len(unsigned int n)
 	return (3 * n) / 2 + (n & 1) + 2;
 }
 
+static void chcr_verify_tag(struct aead_request *req, u8 *input, int *err)
+{
+	u8 temp[SHA512_DIGEST_SIZE];
+	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+	int authsize = crypto_aead_authsize(tfm);
+	struct cpl_fw6_pld *fw6_pld;
+	int cmp = 0;
+
+	fw6_pld = (struct cpl_fw6_pld *)input;
+	if ((get_aead_subtype(tfm) == CRYPTO_ALG_SUB_TYPE_AEAD_RFC4106) ||
+	    (get_aead_subtype(tfm) == CRYPTO_ALG_SUB_TYPE_AEAD_GCM)) {
+		cmp = memcmp(&fw6_pld->data[2], (fw6_pld + 1), authsize);
+	} else {
+
+		sg_pcopy_to_buffer(req->src, sg_nents(req->src), temp,
+				authsize, req->assoclen +
+				req->cryptlen - authsize);
+		cmp = memcmp(temp, (fw6_pld + 1), authsize);
+	}
+	if (cmp)
+		*err = -EBADMSG;
+	else
+		*err = 0;
+}
+
 /*
  *	chcr_handle_resp - Unmap the DMA buffers associated with the request
  *	@req: crypto request
  */
 int chcr_handle_resp(struct crypto_async_request *req, unsigned char *input,
-		     int error_status)
+			 int err)
 {
 	struct crypto_tfm *tfm = req->tfm;
 	struct chcr_context *ctx = crypto_tfm_ctx(tfm);
@@ -109,11 +155,27 @@ int chcr_handle_resp(struct crypto_async_request *req, unsigned char *input,
 	unsigned int digestsize, updated_digestsize;
 
 	switch (tfm->__crt_alg->cra_flags & CRYPTO_ALG_TYPE_MASK) {
+	case CRYPTO_ALG_TYPE_AEAD:
+		ctx_req.req.aead_req = (struct aead_request *)req;
+		ctx_req.ctx.reqctx = aead_request_ctx(ctx_req.req.aead_req);
+		dma_unmap_sg(&u_ctx->lldi.pdev->dev, ctx_req.req.aead_req->dst,
+			     ctx_req.ctx.reqctx->dst_nents, DMA_FROM_DEVICE);
+		if (ctx_req.ctx.reqctx->skb) {
+			kfree_skb(ctx_req.ctx.reqctx->skb);
+			ctx_req.ctx.reqctx->skb = NULL;
+		}
+		if (ctx_req.ctx.reqctx->verify == VERIFY_SW) {
+			chcr_verify_tag(ctx_req.req.aead_req, input,
+					&err);
+			ctx_req.ctx.reqctx->verify = VERIFY_HW;
+		}
+		break;
+
 	case CRYPTO_ALG_TYPE_BLKCIPHER:
 		ctx_req.req.ablk_req = (struct ablkcipher_request *)req;
 		ctx_req.ctx.ablk_ctx =
 			ablkcipher_request_ctx(ctx_req.req.ablk_req);
-		if (!error_status) {
+		if (!err) {
 			fw6_pld = (struct cpl_fw6_pld *)input;
 			memcpy(ctx_req.req.ablk_req->info, &fw6_pld->data[2],
 			       AES_BLOCK_SIZE);
@@ -154,7 +216,7 @@ int chcr_handle_resp(struct crypto_async_request *req, unsigned char *input,
 		}
 		break;
 	}
-	return 0;
+	return err;
 }
 
 /*
@@ -380,6 +442,14 @@ static inline int map_writesg_phys_cpl(struct device *dev,
 	return 0;
 }
 
+static inline int get_aead_subtype(struct crypto_aead *aead)
+{
+	struct aead_alg *alg = crypto_aead_alg(aead);
+	struct chcr_alg_template *chcr_crypto_alg =
+		container_of(alg, struct chcr_alg_template, alg.aead);
+	return chcr_crypto_alg->type & CRYPTO_ALG_SUB_TYPE_MASK;
+}
+
 static inline int get_cryptoalg_subtype(struct crypto_tfm *tfm)
 {
 	struct crypto_alg *alg = tfm->__crt_alg;
@@ -447,7 +517,8 @@ static inline void create_wreq(struct chcr_context *ctx,
 			       struct chcr_wr *chcr_req,
 			       void *req, struct sk_buff *skb,
 			       int kctx_len, int hash_sz,
-			       unsigned int phys_dsgl)
+			       int is_iv,
+			       unsigned int sc_len)
 {
 	struct uld_ctx *u_ctx = ULD_CTX(ctx);
 	int iv_loc = IV_DSGL;
@@ -472,7 +543,7 @@ static inline void create_wreq(struct chcr_context *ctx,
 	chcr_req->wreq.cookie = cpu_to_be64((uintptr_t)req);
 	chcr_req->wreq.rx_chid_to_rx_q_id =
 		FILL_WR_RX_Q_ID(ctx->dev->tx_channel_id, qid,
-				(hash_sz) ? IV_NOP : iv_loc);
+				is_iv ? iv_loc : IV_NOP);
 
 	chcr_req->ulptx.cmd_dest = FILL_ULPTX_CMD_DEST(ctx->dev->tx_channel_id);
 	chcr_req->ulptx.len = htonl((DIV_ROUND_UP((calc_tx_flits_ofld(skb) * 8),
@@ -481,10 +552,7 @@ static inline void create_wreq(struct chcr_context *ctx,
 	chcr_req->sc_imm.cmd_more = FILL_CMD_MORE(immdatalen);
 	chcr_req->sc_imm.len = cpu_to_be32(sizeof(struct cpl_tx_sec_pdu) +
 				   sizeof(chcr_req->key_ctx) +
-				   kctx_len +
-				  ((hash_sz) ? DUMMY_BYTES :
-				  (sizeof(struct cpl_rx_phys_dsgl) +
-				   phys_dsgl)) + immdatalen);
+				   kctx_len + sc_len + immdatalen);
 }
 
 /**
@@ -582,7 +650,8 @@ static struct sk_buff
 	memcpy(reqctx->iv, req->info, ivsize);
 	write_buffer_to_skb(skb, &frags, reqctx->iv, ivsize);
 	write_sg_to_skb(skb, &frags, req->src, req->nbytes);
-	create_wreq(ctx, chcr_req, req, skb, kctx_len, 0, phys_dsgl);
+	create_wreq(ctx, chcr_req, req, skb, kctx_len, 0, 1,
+			sizeof(struct cpl_rx_phys_dsgl) + phys_dsgl);
 	reqctx->skb = skb;
 	skb_get(skb);
 	return skb;
@@ -706,11 +775,11 @@ static int chcr_device_init(struct chcr_context *ctx)
 		}
 		u_ctx = ULD_CTX(ctx);
 		rxq_perchan = u_ctx->lldi.nrxq / u_ctx->lldi.nchan;
-		ctx->dev->tx_channel_id = 0;
 		rxq_idx = ctx->dev->tx_channel_id * rxq_perchan;
 		rxq_idx += id % rxq_perchan;
 		spin_lock(&ctx->dev->lock_chcr_dev);
 		ctx->tx_channel_id = rxq_idx;
+		ctx->dev->tx_channel_id = !ctx->dev->tx_channel_id;
 		spin_unlock(&ctx->dev->lock_chcr_dev);
 	}
 out:
@@ -769,7 +838,7 @@ static inline void chcr_free_shash(struct crypto_shash *base_hash)
  *	@req - Cipher req base
  */
 static struct sk_buff *create_hash_wr(struct ahash_request *req,
-					    struct hash_wr_param *param)
+				      struct hash_wr_param *param)
 {
 	struct chcr_ahash_req_ctx *req_ctx = ahash_request_ctx(req);
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
@@ -840,8 +909,8 @@ static struct sk_buff *create_hash_wr(struct ahash_request *req,
 	if (param->sg_len != 0)
 		write_sg_to_skb(skb, &frags, req->src, param->sg_len);
 
-	create_wreq(ctx, chcr_req, req, skb, kctx_len, hash_size_in_response,
-		    0);
+	create_wreq(ctx, chcr_req, req, skb, kctx_len, hash_size_in_response, 0,
+			DUMMY_BYTES);
 	req_ctx->skb = skb;
 	skb_get(skb);
 	return skb;
@@ -1249,6 +1318,1149 @@ static void chcr_hmac_cra_exit(struct crypto_tfm *tfm)
 	}
 }
 
+static int chcr_copy_assoc(struct aead_request *req,
+				struct chcr_aead_ctx *ctx)
+{
+	SKCIPHER_REQUEST_ON_STACK(skreq, ctx->null);
+
+	skcipher_request_set_tfm(skreq, ctx->null);
+	skcipher_request_set_callback(skreq, aead_request_flags(req),
+			NULL, NULL);
+	skcipher_request_set_crypt(skreq, req->src, req->dst, req->assoclen,
+			NULL);
+
+	return crypto_skcipher_encrypt(skreq);
+}
+
+static unsigned char get_hmac(unsigned int authsize)
+{
+	switch (authsize) {
+	case ICV_8:
+		return CHCR_SCMD_HMAC_CTRL_PL1;
+	case ICV_10:
+		return CHCR_SCMD_HMAC_CTRL_TRUNC_RFC4366;
+	case ICV_12:
+		return CHCR_SCMD_HMAC_CTRL_IPSEC_96BIT;
+	}
+	return CHCR_SCMD_HMAC_CTRL_NO_TRUNC;
+}
+
+
+static struct sk_buff *create_authenc_wr(struct aead_request *req,
+					 unsigned short qid,
+					 int size,
+					 unsigned short op_type)
+{
+	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+	struct chcr_context *ctx = crypto_aead_ctx(tfm);
+	struct uld_ctx *u_ctx = ULD_CTX(ctx);
+	struct chcr_aead_ctx *aeadctx = AEAD_CTX(ctx);
+	struct chcr_authenc_ctx *actx = AUTHENC_CTX(aeadctx);
+	struct chcr_aead_reqctx *reqctx = aead_request_ctx(req);
+	struct sk_buff *skb = NULL;
+	struct chcr_wr *chcr_req;
+	struct cpl_rx_phys_dsgl *phys_cpl;
+	struct phys_sge_parm sg_param;
+	struct scatterlist *src, *dst;
+	struct scatterlist src_sg[2], dst_sg[2];
+	unsigned int frags = 0, transhdr_len;
+	unsigned int ivsize = crypto_aead_ivsize(tfm), dst_size = 0;
+	unsigned int   kctx_len = 0;
+	unsigned short stop_offset = 0;
+	unsigned int  assoclen = req->assoclen;
+	unsigned int  authsize = crypto_aead_authsize(tfm);
+	int err = 0;
+	int null = 0;
+	gfp_t flags = req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP ? GFP_KERNEL :
+		GFP_ATOMIC;
+
+	if (aeadctx->enckey_len == 0 || (req->cryptlen <= 0))
+		goto err;
+	src = scatterwalk_ffwd(src_sg, req->src, req->assoclen);
+	dst = src;
+	if (req->src != req->dst) {
+		err = chcr_copy_assoc(req, aeadctx);
+		if (err)
+			return ERR_PTR(err);
+		dst = scatterwalk_ffwd(dst_sg, req->dst, req->assoclen);
+	}
+	if (get_aead_subtype(tfm) == CRYPTO_ALG_SUB_TYPE_AEAD_NULL) {
+		null = 1;
+		assoclen = 0;
+	}
+	reqctx->dst_nents = sg_nents_for_len(dst, req->cryptlen +
+					     (op_type ? -authsize : authsize));
+	if (reqctx->dst_nents <= 0) {
+		pr_err("AUTHENC:Invalid Destination sg entries\n");
+		goto err;
+	}
+	dst_size = get_space_for_phys_dsgl(reqctx->dst_nents);
+	kctx_len = (ntohl(KEY_CONTEXT_CTX_LEN_V(aeadctx->key_ctx_hdr)) << 4)
+		- sizeof(chcr_req->key_ctx);
+	transhdr_len = CIPHER_TRANSHDR_SIZE(kctx_len, dst_size);
+	skb = alloc_skb((transhdr_len + sizeof(struct sge_opaque_hdr)), flags);
+	if (!skb)
+		goto err;
+
+	/* LLD is going to write the sge hdr. */
+	skb_reserve(skb, sizeof(struct sge_opaque_hdr));
+
+	/* Write WR */
+	chcr_req = (struct chcr_wr *) __skb_put(skb, transhdr_len);
+	memset(chcr_req, 0, transhdr_len);
+
+	stop_offset = (op_type == CHCR_ENCRYPT_OP) ? 0 : authsize;
+
+	/*
+	 * Input order	is AAD,IV and Payload. where IV should be included as
+	 * the part of authdata. All other fields should be filled according
+	 * to the hardware spec
+	 */
+	chcr_req->sec_cpl.op_ivinsrtofst =
+		FILL_SEC_CPL_OP_IVINSR(ctx->dev->tx_channel_id, 2,
+				       (ivsize ? (assoclen + 1) : 0));
+	chcr_req->sec_cpl.pldlen = htonl(assoclen + ivsize + req->cryptlen);
+	chcr_req->sec_cpl.aadstart_cipherstop_hi = FILL_SEC_CPL_CIPHERSTOP_HI(
+					assoclen ? 1 : 0, assoclen,
+					assoclen + ivsize + 1,
+					(stop_offset & 0x1F0) >> 4);
+	chcr_req->sec_cpl.cipherstop_lo_authinsert = FILL_SEC_CPL_AUTHINSERT(
+					stop_offset & 0xF,
+					null ? 0 : assoclen + ivsize + 1,
+					stop_offset, stop_offset);
+	chcr_req->sec_cpl.seqno_numivs = FILL_SEC_CPL_SCMD0_SEQNO(op_type,
+					(op_type == CHCR_ENCRYPT_OP) ? 1 : 0,
+					CHCR_SCMD_CIPHER_MODE_AES_CBC,
+					actx->auth_mode, aeadctx->hmac_ctrl,
+					ivsize >> 1);
+	chcr_req->sec_cpl.ivgen_hdrlen =  FILL_SEC_CPL_IVGEN_HDRLEN(0, 0, 1,
+					 0, 1, dst_size);
+
+	chcr_req->key_ctx.ctx_hdr = aeadctx->key_ctx_hdr;
+	if (op_type == CHCR_ENCRYPT_OP)
+		memcpy(chcr_req->key_ctx.key, aeadctx->key,
+		       aeadctx->enckey_len);
+	else
+		memcpy(chcr_req->key_ctx.key, actx->dec_rrkey,
+		       aeadctx->enckey_len);
+
+	memcpy(chcr_req->key_ctx.key + (DIV_ROUND_UP(aeadctx->enckey_len, 16) <<
+					4), actx->h_iopad, kctx_len -
+				(DIV_ROUND_UP(aeadctx->enckey_len, 16) << 4));
+
+	phys_cpl = (struct cpl_rx_phys_dsgl *)((u8 *)(chcr_req + 1) + kctx_len);
+	sg_param.nents = reqctx->dst_nents;
+	sg_param.obsize = req->cryptlen + (op_type ? -authsize : authsize);
+	sg_param.qid = qid;
+	sg_param.align = 0;
+	if (map_writesg_phys_cpl(&u_ctx->lldi.pdev->dev, phys_cpl, dst,
+				  &sg_param))
+		goto dstmap_fail;
+
+	skb_set_transport_header(skb, transhdr_len);
+
+	if (assoclen) {
+		/* AAD buffer in */
+		write_sg_to_skb(skb, &frags, req->src, assoclen);
+
+	}
+	write_buffer_to_skb(skb, &frags, req->iv, ivsize);
+	write_sg_to_skb(skb, &frags, src, req->cryptlen);
+	create_wreq(ctx, chcr_req, req, skb, kctx_len, size, 1,
+		   sizeof(struct cpl_rx_phys_dsgl) + dst_size);
+	reqctx->skb = skb;
+	skb_get(skb);
+
+	return skb;
+dstmap_fail:
+	/* ivmap_fail: */
+	kfree_skb(skb);
+err:
+	return ERR_PTR(-EINVAL);
+}
+
+static void aes_gcm_empty_pld_pad(struct scatterlist *sg,
+				  unsigned short offset)
+{
+	struct page *spage;
+	unsigned char *addr;
+
+	spage = sg_page(sg);
+	get_page(spage); /* so that it is not freed by NIC */
+#ifdef KMAP_ATOMIC_ARGS
+	addr = kmap_atomic(spage, KM_SOFTIRQ0);
+#else
+	addr = kmap_atomic(spage);
+#endif
+	memset(addr + sg->offset, 0, offset + 1);
+
+	kunmap_atomic(addr);
+}
+
+static int set_msg_len(u8 *block, unsigned int msglen, int csize)
+{
+	__be32 data;
+
+	memset(block, 0, csize);
+	block += csize;
+
+	if (csize >= 4)
+		csize = 4;
+	else if (msglen > (unsigned int)(1 << (8 * csize)))
+		return -EOVERFLOW;
+
+	data = cpu_to_be32(msglen);
+	memcpy(block - csize, (u8 *)&data + 4 - csize, csize);
+
+	return 0;
+}
+
+static void generate_b0(struct aead_request *req,
+			struct chcr_aead_ctx *aeadctx,
+			unsigned short op_type)
+{
+	unsigned int l, lp, m;
+	int rc;
+	struct crypto_aead *aead = crypto_aead_reqtfm(req);
+	struct chcr_aead_reqctx *reqctx = aead_request_ctx(req);
+	u8 *b0 = reqctx->scratch_pad;
+
+	m = crypto_aead_authsize(aead);
+
+	memcpy(b0, reqctx->iv, 16);
+
+	lp = b0[0];
+	l = lp + 1;
+
+	/* set m, bits 3-5 */
+	*b0 |= (8 * ((m - 2) / 2));
+
+	/* set adata, bit 6, if associated data is used */
+	if (req->assoclen)
+		*b0 |= 64;
+	rc = set_msg_len(b0 + 16 - l,
+			 (op_type == CHCR_DECRYPT_OP) ?
+			 req->cryptlen - m : req->cryptlen, l);
+}
+
+static inline int crypto_ccm_check_iv(const u8 *iv)
+{
+	/* 2 <= L <= 8, so 1 <= L' <= 7. */
+	if (iv[0] < 1 || iv[0] > 7)
+		return -EINVAL;
+
+	return 0;
+}
+
+static int ccm_format_packet(struct aead_request *req,
+			     struct chcr_aead_ctx *aeadctx,
+			     unsigned int sub_type,
+			     unsigned short op_type)
+{
+	struct chcr_aead_reqctx *reqctx = aead_request_ctx(req);
+	int rc = 0;
+
+	if (req->assoclen > T5_MAX_AAD_SIZE) {
+		pr_err("CCM: Unsupported AAD data. It should be < %d\n",
+		       T5_MAX_AAD_SIZE);
+		return -EINVAL;
+	}
+	if (sub_type == CRYPTO_ALG_SUB_TYPE_AEAD_RFC4309) {
+		reqctx->iv[0] = 3;
+		memcpy(reqctx->iv + 1, &aeadctx->salt[0], 3);
+		memcpy(reqctx->iv + 4, req->iv, 8);
+		memset(reqctx->iv + 12, 0, 4);
+		*((unsigned short *)(reqctx->scratch_pad + 16)) =
+			htons(req->assoclen - 8);
+	} else {
+		memcpy(reqctx->iv, req->iv, 16);
+		*((unsigned short *)(reqctx->scratch_pad + 16)) =
+			htons(req->assoclen);
+	}
+	generate_b0(req, aeadctx, op_type);
+	/* zero the ctr value */
+	memset(reqctx->iv + 15 - reqctx->iv[0], 0, reqctx->iv[0] + 1);
+	return rc;
+}
+
+static void fill_sec_cpl_for_aead(struct cpl_tx_sec_pdu *sec_cpl,
+				  unsigned int dst_size,
+				  struct aead_request *req,
+				  unsigned short op_type,
+					  struct chcr_context *chcrctx)
+{
+	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+	unsigned int ivsize = AES_BLOCK_SIZE;
+	unsigned int cipher_mode = CHCR_SCMD_CIPHER_MODE_AES_CCM;
+	unsigned int mac_mode = CHCR_SCMD_AUTH_MODE_CBCMAC;
+	unsigned int c_id = chcrctx->dev->tx_channel_id;
+	unsigned int ccm_xtra;
+	unsigned char tag_offset = 0, auth_offset = 0;
+	unsigned char hmac_ctrl = get_hmac(crypto_aead_authsize(tfm));
+	unsigned int assoclen;
+
+	if (get_aead_subtype(tfm) == CRYPTO_ALG_SUB_TYPE_AEAD_RFC4309)
+		assoclen = req->assoclen - 8;
+	else
+		assoclen = req->assoclen;
+	ccm_xtra = CCM_B0_SIZE +
+		((assoclen) ? CCM_AAD_FIELD_SIZE : 0);
+
+	auth_offset = req->cryptlen ?
+		(assoclen + ivsize + 1 + ccm_xtra) : 0;
+	if (op_type == CHCR_DECRYPT_OP) {
+		if (crypto_aead_authsize(tfm) != req->cryptlen)
+			tag_offset = crypto_aead_authsize(tfm);
+		else
+			auth_offset = 0;
+	}
+
+
+	sec_cpl->op_ivinsrtofst = FILL_SEC_CPL_OP_IVINSR(c_id,
+					 2, (ivsize ?  (assoclen + 1) :  0) +
+					 ccm_xtra);
+	sec_cpl->pldlen =
+		htonl(assoclen + ivsize + req->cryptlen + ccm_xtra);
+	/* For CCM there wil be b0 always. So AAD start will be 1 always */
+	sec_cpl->aadstart_cipherstop_hi = FILL_SEC_CPL_CIPHERSTOP_HI(
+					1, assoclen + ccm_xtra, assoclen
+					+ ivsize + 1 + ccm_xtra, 0);
+
+	sec_cpl->cipherstop_lo_authinsert = FILL_SEC_CPL_AUTHINSERT(0,
+					auth_offset, tag_offset,
+					(op_type == CHCR_ENCRYPT_OP) ? 0 :
+					crypto_aead_authsize(tfm));
+	sec_cpl->seqno_numivs =  FILL_SEC_CPL_SCMD0_SEQNO(op_type,
+					(op_type == CHCR_ENCRYPT_OP) ? 0 : 1,
+					cipher_mode, mac_mode, hmac_ctrl,
+					ivsize >> 1);
+
+	sec_cpl->ivgen_hdrlen = FILL_SEC_CPL_IVGEN_HDRLEN(0, 0, 1, 0,
+					1, dst_size);
+}
+
+int aead_ccm_validate_input(unsigned short op_type,
+			    struct aead_request *req,
+			    struct chcr_aead_ctx *aeadctx,
+			    unsigned int sub_type)
+{
+	if (sub_type != CRYPTO_ALG_SUB_TYPE_AEAD_RFC4309) {
+		if (crypto_ccm_check_iv(req->iv)) {
+			pr_err("CCM: IV check fails\n");
+			return -EINVAL;
+		}
+	} else {
+		if (req->assoclen != 16 && req->assoclen != 20) {
+			pr_err("RFC4309: Invalid AAD length %d\n",
+			       req->assoclen);
+			return -EINVAL;
+		}
+	}
+	if (aeadctx->enckey_len == 0) {
+		pr_err("CCM: Encryption key not set\n");
+		return -EINVAL;
+	}
+	return 0;
+}
+
+unsigned int fill_aead_req_fields(struct sk_buff *skb,
+				  struct aead_request *req,
+				  struct scatterlist *src,
+				  unsigned int ivsize,
+				  struct chcr_aead_ctx *aeadctx)
+{
+	unsigned int frags = 0;
+	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+	struct chcr_aead_reqctx *reqctx = aead_request_ctx(req);
+	/* b0 and aad length(if available) */
+
+	write_buffer_to_skb(skb, &frags, reqctx->scratch_pad, CCM_B0_SIZE +
+				(req->assoclen ?  CCM_AAD_FIELD_SIZE : 0));
+	if (req->assoclen) {
+		if (get_aead_subtype(tfm) == CRYPTO_ALG_SUB_TYPE_AEAD_RFC4309)
+			write_sg_to_skb(skb, &frags, req->src,
+					req->assoclen - 8);
+		else
+			write_sg_to_skb(skb, &frags, req->src, req->assoclen);
+	}
+	write_buffer_to_skb(skb, &frags, reqctx->iv, ivsize);
+	if (req->cryptlen)
+		write_sg_to_skb(skb, &frags, src, req->cryptlen);
+
+	return frags;
+}
+
+static struct sk_buff *create_aead_ccm_wr(struct aead_request *req,
+					  unsigned short qid,
+					  int size,
+					  unsigned short op_type)
+{
+	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+	struct chcr_context *ctx = crypto_aead_ctx(tfm);
+	struct uld_ctx *u_ctx = ULD_CTX(ctx);
+	struct chcr_aead_ctx *aeadctx = AEAD_CTX(ctx);
+	struct chcr_aead_reqctx *reqctx = aead_request_ctx(req);
+	struct sk_buff *skb = NULL;
+	struct chcr_wr *chcr_req;
+	struct cpl_rx_phys_dsgl *phys_cpl;
+	struct phys_sge_parm sg_param;
+	struct scatterlist *src, *dst;
+	struct scatterlist src_sg[2], dst_sg[2];
+	unsigned int frags = 0, transhdr_len, ivsize = AES_BLOCK_SIZE;
+	unsigned int dst_size = 0, kctx_len;
+	unsigned int sub_type;
+	unsigned int authsize = crypto_aead_authsize(tfm);
+	int err = 0;
+	gfp_t flags = req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP ? GFP_KERNEL :
+		GFP_ATOMIC;
+
+	sub_type = get_aead_subtype(tfm);
+	src = scatterwalk_ffwd(src_sg, req->src, req->assoclen);
+	dst = src;
+	if (req->src != req->dst) {
+		err = chcr_copy_assoc(req, aeadctx);
+		if (err) {
+			pr_err("AAD copy to destination buffer fails\n");
+			return ERR_PTR(err);
+		}
+		dst = scatterwalk_ffwd(dst_sg, req->dst, req->assoclen);
+	}
+	reqctx->dst_nents = sg_nents_for_len(dst, req->cryptlen +
+					     (op_type ? -authsize : authsize));
+	if (reqctx->dst_nents <= 0) {
+		pr_err("CCM:Invalid Destination sg entries\n");
+		goto err;
+	}
+
+
+	if (aead_ccm_validate_input(op_type, req, aeadctx, sub_type))
+		goto err;
+
+	dst_size = get_space_for_phys_dsgl(reqctx->dst_nents);
+	kctx_len = ((DIV_ROUND_UP(aeadctx->enckey_len, 16)) << 4) * 2;
+	transhdr_len = CIPHER_TRANSHDR_SIZE(kctx_len, dst_size);
+	skb = alloc_skb((transhdr_len + sizeof(struct sge_opaque_hdr)),  flags);
+
+	if (!skb)
+		goto err;
+
+	skb_reserve(skb, sizeof(struct sge_opaque_hdr));
+
+	chcr_req = (struct chcr_wr *) __skb_put(skb, transhdr_len);
+	memset(chcr_req, 0, transhdr_len);
+
+	fill_sec_cpl_for_aead(&chcr_req->sec_cpl, dst_size, req, op_type, ctx);
+
+	chcr_req->key_ctx.ctx_hdr = aeadctx->key_ctx_hdr;
+	memcpy(chcr_req->key_ctx.key, aeadctx->key, aeadctx->enckey_len);
+	memcpy(chcr_req->key_ctx.key + (DIV_ROUND_UP(aeadctx->enckey_len, 16) *
+					16), aeadctx->key, aeadctx->enckey_len);
+
+	phys_cpl = (struct cpl_rx_phys_dsgl *)((u8 *)(chcr_req + 1) + kctx_len);
+	if (ccm_format_packet(req, aeadctx, sub_type, op_type))
+		goto dstmap_fail;
+
+	sg_param.nents = reqctx->dst_nents;
+	sg_param.obsize = req->cryptlen + (op_type ? -authsize : authsize);
+	sg_param.qid = qid;
+	sg_param.align = 0;
+	if (map_writesg_phys_cpl(&u_ctx->lldi.pdev->dev, phys_cpl, dst,
+				  &sg_param))
+		goto dstmap_fail;
+
+	skb_set_transport_header(skb, transhdr_len);
+	frags = fill_aead_req_fields(skb, req, src, ivsize, aeadctx);
+	create_wreq(ctx, chcr_req, req, skb, kctx_len, 0, 1,
+		    sizeof(struct cpl_rx_phys_dsgl) + dst_size);
+	reqctx->skb = skb;
+	skb_get(skb);
+	return skb;
+dstmap_fail:
+	kfree_skb(skb);
+	skb = NULL;
+err:
+	return ERR_PTR(-EINVAL);
+}
+
+static struct sk_buff *create_gcm_wr(struct aead_request *req,
+				     unsigned short qid,
+				     int size,
+				     unsigned short op_type)
+{
+	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+	struct chcr_context *ctx = crypto_aead_ctx(tfm);
+	struct uld_ctx *u_ctx = ULD_CTX(ctx);
+	struct chcr_aead_ctx *aeadctx = AEAD_CTX(ctx);
+	struct chcr_aead_reqctx  *reqctx = aead_request_ctx(req);
+	struct sk_buff *skb = NULL;
+	struct chcr_wr *chcr_req;
+	struct cpl_rx_phys_dsgl *phys_cpl;
+	struct phys_sge_parm sg_param;
+	struct scatterlist *src, *dst;
+	struct scatterlist src_sg[2], dst_sg[2];
+	unsigned int frags = 0, transhdr_len;
+	unsigned int ivsize = AES_BLOCK_SIZE;
+	unsigned int dst_size = 0, kctx_len;
+	unsigned char tag_offset = 0;
+	unsigned int crypt_len = 0;
+	unsigned int authsize = crypto_aead_authsize(tfm);
+	unsigned char hmac_ctrl = get_hmac(authsize);
+	int err = 0;
+	gfp_t flags = req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP ? GFP_KERNEL :
+		GFP_ATOMIC;
+
+	/* validate key size */
+	if (aeadctx->enckey_len == 0)
+		goto err;
+
+	src = scatterwalk_ffwd(src_sg, req->src, req->assoclen);
+	dst = src;
+	if (req->src != req->dst) {
+		err = chcr_copy_assoc(req, aeadctx);
+		if (err)
+			return	ERR_PTR(err);
+		dst = scatterwalk_ffwd(dst_sg, req->dst, req->assoclen);
+	}
+
+	if (!req->cryptlen)
+		/* null-payload is not supported in the hardware.
+		* software is sending block size
+		*/
+		crypt_len = AES_BLOCK_SIZE;
+	else
+		crypt_len = req->cryptlen;
+	reqctx->dst_nents = sg_nents_for_len(dst, req->cryptlen +
+					     (op_type ? -authsize : authsize));
+	if (reqctx->dst_nents <= 0) {
+		pr_err("GCM:Invalid Destination sg entries\n");
+		goto err;
+	}
+
+
+	dst_size = get_space_for_phys_dsgl(reqctx->dst_nents);
+	kctx_len = ((DIV_ROUND_UP(aeadctx->enckey_len, 16)) << 4) +
+		AEAD_H_SIZE;
+	transhdr_len = CIPHER_TRANSHDR_SIZE(kctx_len, dst_size);
+	skb = alloc_skb((transhdr_len + sizeof(struct sge_opaque_hdr)), flags);
+	if (!skb)
+		goto err;
+
+	/* NIC driver is going to write the sge hdr. */
+	skb_reserve(skb, sizeof(struct sge_opaque_hdr));
+
+	chcr_req = (struct chcr_wr *)__skb_put(skb, transhdr_len);
+	memset(chcr_req, 0, transhdr_len);
+
+	if (get_aead_subtype(tfm) == CRYPTO_ALG_SUB_TYPE_AEAD_RFC4106)
+		req->assoclen -= 8;
+
+	tag_offset = (op_type == CHCR_ENCRYPT_OP) ? 0 : authsize;
+	chcr_req->sec_cpl.op_ivinsrtofst = FILL_SEC_CPL_OP_IVINSR(
+					ctx->dev->tx_channel_id, 2, (ivsize ?
+					(req->assoclen + 1) : 0));
+	chcr_req->sec_cpl.pldlen = htonl(req->assoclen + ivsize + crypt_len);
+	chcr_req->sec_cpl.aadstart_cipherstop_hi = FILL_SEC_CPL_CIPHERSTOP_HI(
+					req->assoclen ? 1 : 0, req->assoclen,
+					req->assoclen + ivsize + 1, 0);
+	if (req->cryptlen) {
+		chcr_req->sec_cpl.cipherstop_lo_authinsert =
+			FILL_SEC_CPL_AUTHINSERT(0, req->assoclen + ivsize + 1,
+						tag_offset, tag_offset);
+		chcr_req->sec_cpl.seqno_numivs =
+			FILL_SEC_CPL_SCMD0_SEQNO(op_type, (op_type ==
+					CHCR_ENCRYPT_OP) ? 1 : 0,
+					CHCR_SCMD_CIPHER_MODE_AES_GCM,
+					CHCR_SCMD_AUTH_MODE_GHASH, hmac_ctrl,
+					ivsize >> 1);
+	} else {
+		chcr_req->sec_cpl.cipherstop_lo_authinsert =
+			FILL_SEC_CPL_AUTHINSERT(0, 0, 0, 0);
+		chcr_req->sec_cpl.seqno_numivs =
+			FILL_SEC_CPL_SCMD0_SEQNO(op_type,
+					(op_type ==  CHCR_ENCRYPT_OP) ?
+					1 : 0, CHCR_SCMD_CIPHER_MODE_AES_CBC,
+					0, 0, ivsize >> 1);
+	}
+	chcr_req->sec_cpl.ivgen_hdrlen =  FILL_SEC_CPL_IVGEN_HDRLEN(0, 0, 1,
+					0, 1, dst_size);
+	chcr_req->key_ctx.ctx_hdr = aeadctx->key_ctx_hdr;
+	memcpy(chcr_req->key_ctx.key, aeadctx->key, aeadctx->enckey_len);
+	memcpy(chcr_req->key_ctx.key + (DIV_ROUND_UP(aeadctx->enckey_len, 16) *
+				16), GCM_CTX(aeadctx)->ghash_h, AEAD_H_SIZE);
+
+	/* prepare a 16 byte iv */
+	/* S   A   L  T |  IV | 0x00000001 */
+	if (get_aead_subtype(tfm) ==
+	    CRYPTO_ALG_SUB_TYPE_AEAD_RFC4106) {
+		memcpy(reqctx->iv, aeadctx->salt, 4);
+		memcpy(reqctx->iv + 4, req->iv, 8);
+	} else {
+		memcpy(reqctx->iv, req->iv, 12);
+	}
+	*((unsigned int *)(reqctx->iv + 12)) = htonl(0x01);
+
+	phys_cpl = (struct cpl_rx_phys_dsgl *)((u8 *)(chcr_req + 1) + kctx_len);
+	sg_param.nents = reqctx->dst_nents;
+	sg_param.obsize = req->cryptlen + (op_type ? -authsize : authsize);
+	sg_param.qid = qid;
+	sg_param.align = 0;
+	if (map_writesg_phys_cpl(&u_ctx->lldi.pdev->dev, phys_cpl, dst,
+				  &sg_param))
+		goto dstmap_fail;
+
+	skb_set_transport_header(skb, transhdr_len);
+
+	write_sg_to_skb(skb, &frags, req->src, req->assoclen);
+
+	write_buffer_to_skb(skb, &frags, reqctx->iv, ivsize);
+
+	if (req->cryptlen) {
+		write_sg_to_skb(skb, &frags, src, req->cryptlen);
+	} else {
+		aes_gcm_empty_pld_pad(req->dst, authsize - 1);
+		write_sg_to_skb(skb, &frags, dst, crypt_len);
+	}
+
+	create_wreq(ctx, chcr_req, req, skb, kctx_len, size, 1,
+			sizeof(struct cpl_rx_phys_dsgl) + dst_size);
+	reqctx->skb = skb;
+	skb_get(skb);
+	return skb;
+
+dstmap_fail:
+	/* ivmap_fail: */
+	kfree_skb(skb);
+	skb = NULL;
+err:
+	return skb;
+}
+
+
+
+static int chcr_aead_cra_init(struct crypto_aead *tfm)
+{
+	struct chcr_context *ctx = crypto_aead_ctx(tfm);
+	struct chcr_aead_ctx *aeadctx = AEAD_CTX(ctx);
+
+	crypto_aead_set_reqsize(tfm, sizeof(struct chcr_aead_reqctx));
+	aeadctx->null = crypto_get_default_null_skcipher();
+	if (IS_ERR(aeadctx->null))
+		return PTR_ERR(aeadctx->null);
+	return chcr_device_init(ctx);
+}
+
+static void chcr_aead_cra_exit(struct crypto_aead *tfm)
+{
+	crypto_put_default_null_skcipher();
+}
+
+static int chcr_authenc_null_setauthsize(struct crypto_aead *tfm,
+					unsigned int authsize)
+{
+	struct chcr_aead_ctx *aeadctx = AEAD_CTX(crypto_aead_ctx(tfm));
+
+	aeadctx->hmac_ctrl = CHCR_SCMD_HMAC_CTRL_NOP;
+	aeadctx->mayverify = VERIFY_HW;
+	return 0;
+}
+static int chcr_authenc_setauthsize(struct crypto_aead *tfm,
+				    unsigned int authsize)
+{
+	struct chcr_aead_ctx *aeadctx = AEAD_CTX(crypto_aead_ctx(tfm));
+	u32 maxauth = crypto_aead_maxauthsize(tfm);
+
+	/*SHA1 authsize in ipsec is 12 instead of 10 i.e maxauthsize / 2 is not
+	 * true for sha1. authsize == 12 condition should be before
+	 * authsize == (maxauth >> 1)
+	 */
+	if (authsize == ICV_4) {
+		aeadctx->hmac_ctrl = CHCR_SCMD_HMAC_CTRL_PL1;
+		aeadctx->mayverify = VERIFY_HW;
+	} else if (authsize == ICV_6) {
+		aeadctx->hmac_ctrl = CHCR_SCMD_HMAC_CTRL_PL2;
+		aeadctx->mayverify = VERIFY_HW;
+	} else if (authsize == ICV_10) {
+		aeadctx->hmac_ctrl = CHCR_SCMD_HMAC_CTRL_TRUNC_RFC4366;
+		aeadctx->mayverify = VERIFY_HW;
+	} else if (authsize == ICV_12) {
+		aeadctx->hmac_ctrl = CHCR_SCMD_HMAC_CTRL_IPSEC_96BIT;
+		aeadctx->mayverify = VERIFY_HW;
+	} else if (authsize == ICV_14) {
+		aeadctx->hmac_ctrl = CHCR_SCMD_HMAC_CTRL_PL3;
+		aeadctx->mayverify = VERIFY_HW;
+	} else if (authsize == (maxauth >> 1)) {
+		aeadctx->hmac_ctrl = CHCR_SCMD_HMAC_CTRL_DIV2;
+		aeadctx->mayverify = VERIFY_HW;
+	} else if (authsize == maxauth) {
+		aeadctx->hmac_ctrl = CHCR_SCMD_HMAC_CTRL_NO_TRUNC;
+		aeadctx->mayverify = VERIFY_HW;
+	} else {
+		aeadctx->hmac_ctrl = CHCR_SCMD_HMAC_CTRL_NO_TRUNC;
+		aeadctx->mayverify = VERIFY_SW;
+	}
+	return 0;
+}
+
+
+static int chcr_gcm_setauthsize(struct crypto_aead *tfm, unsigned int authsize)
+{
+	struct chcr_aead_ctx *aeadctx = AEAD_CTX(crypto_aead_ctx(tfm));
+
+	switch (authsize) {
+	case ICV_4:
+		aeadctx->hmac_ctrl = CHCR_SCMD_HMAC_CTRL_PL1;
+		aeadctx->mayverify = VERIFY_HW;
+		break;
+	case ICV_8:
+		aeadctx->hmac_ctrl = CHCR_SCMD_HMAC_CTRL_DIV2;
+		aeadctx->mayverify = VERIFY_HW;
+		break;
+	case ICV_12:
+		 aeadctx->hmac_ctrl = CHCR_SCMD_HMAC_CTRL_IPSEC_96BIT;
+		 aeadctx->mayverify = VERIFY_HW;
+		break;
+	case ICV_14:
+		 aeadctx->hmac_ctrl = CHCR_SCMD_HMAC_CTRL_PL3;
+		 aeadctx->mayverify = VERIFY_HW;
+		break;
+	case ICV_16:
+		aeadctx->hmac_ctrl = CHCR_SCMD_HMAC_CTRL_NO_TRUNC;
+		aeadctx->mayverify = VERIFY_HW;
+		break;
+	case ICV_13:
+	case ICV_15:
+		aeadctx->hmac_ctrl = CHCR_SCMD_HMAC_CTRL_NO_TRUNC;
+		aeadctx->mayverify = VERIFY_SW;
+		break;
+	default:
+
+		  crypto_tfm_set_flags((struct crypto_tfm *) tfm,
+			CRYPTO_TFM_RES_BAD_KEY_LEN);
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static int chcr_4106_4309_setauthsize(struct crypto_aead *tfm,
+					  unsigned int authsize)
+{
+	struct chcr_aead_ctx *aeadctx = AEAD_CTX(crypto_aead_ctx(tfm));
+
+	switch (authsize) {
+	case ICV_8:
+		aeadctx->hmac_ctrl = CHCR_SCMD_HMAC_CTRL_DIV2;
+		aeadctx->mayverify = VERIFY_HW;
+		break;
+	case ICV_12:
+		aeadctx->hmac_ctrl = CHCR_SCMD_HMAC_CTRL_IPSEC_96BIT;
+		aeadctx->mayverify = VERIFY_HW;
+		break;
+	case ICV_16:
+		aeadctx->hmac_ctrl = CHCR_SCMD_HMAC_CTRL_NO_TRUNC;
+		aeadctx->mayverify = VERIFY_HW;
+		break;
+	default:
+		crypto_tfm_set_flags((struct crypto_tfm *)tfm,
+				     CRYPTO_TFM_RES_BAD_KEY_LEN);
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static int chcr_ccm_setauthsize(struct crypto_aead *tfm,
+				unsigned int authsize)
+{
+	struct chcr_aead_ctx *aeadctx = AEAD_CTX(crypto_aead_ctx(tfm));
+
+	switch (authsize) {
+	case ICV_4:
+		aeadctx->hmac_ctrl = CHCR_SCMD_HMAC_CTRL_PL1;
+		aeadctx->mayverify = VERIFY_HW;
+		break;
+	case ICV_6:
+		aeadctx->hmac_ctrl = CHCR_SCMD_HMAC_CTRL_PL2;
+		aeadctx->mayverify = VERIFY_HW;
+		break;
+	case ICV_8:
+		aeadctx->hmac_ctrl = CHCR_SCMD_HMAC_CTRL_DIV2;
+		aeadctx->mayverify = VERIFY_HW;
+		break;
+	case ICV_10:
+		aeadctx->hmac_ctrl = CHCR_SCMD_HMAC_CTRL_TRUNC_RFC4366;
+		aeadctx->mayverify = VERIFY_HW;
+		break;
+	case ICV_12:
+		aeadctx->hmac_ctrl = CHCR_SCMD_HMAC_CTRL_IPSEC_96BIT;
+		aeadctx->mayverify = VERIFY_HW;
+		break;
+	case ICV_14:
+		aeadctx->hmac_ctrl = CHCR_SCMD_HMAC_CTRL_PL3;
+		aeadctx->mayverify = VERIFY_HW;
+		break;
+	case ICV_16:
+		aeadctx->hmac_ctrl = CHCR_SCMD_HMAC_CTRL_NO_TRUNC;
+		aeadctx->mayverify = VERIFY_HW;
+		break;
+	default:
+		crypto_tfm_set_flags((struct crypto_tfm *)tfm,
+				     CRYPTO_TFM_RES_BAD_KEY_LEN);
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static int chcr_aead_ccm_setkey(struct crypto_aead *aead,
+				const u8 *key,
+				unsigned int keylen)
+{
+	struct chcr_context *ctx = crypto_aead_ctx(aead);
+	struct chcr_aead_ctx *aeadctx = AEAD_CTX(ctx);
+	unsigned char ck_size, mk_size;
+	int key_ctx_size = 0;
+
+	memcpy(aeadctx->key, key, keylen);
+	aeadctx->enckey_len = keylen;
+	key_ctx_size = sizeof(struct _key_ctx) +
+		((DIV_ROUND_UP(keylen, 16)) << 4)  * 2;
+	if (keylen == AES_KEYSIZE_128) {
+		mk_size = CHCR_KEYCTX_CIPHER_KEY_SIZE_128;
+		ck_size = CHCR_KEYCTX_CIPHER_KEY_SIZE_128;
+	} else if (keylen == AES_KEYSIZE_192) {
+		ck_size = CHCR_KEYCTX_CIPHER_KEY_SIZE_192;
+		mk_size = CHCR_KEYCTX_MAC_KEY_SIZE_192;
+	} else if (keylen == AES_KEYSIZE_256) {
+		ck_size = CHCR_KEYCTX_CIPHER_KEY_SIZE_256;
+		mk_size = CHCR_KEYCTX_MAC_KEY_SIZE_256;
+	} else {
+		crypto_tfm_set_flags((struct crypto_tfm *)aead,
+				     CRYPTO_TFM_RES_BAD_KEY_LEN);
+		aeadctx->enckey_len = 0;
+		return	-EINVAL;
+	}
+	aeadctx->key_ctx_hdr = FILL_KEY_CTX_HDR(ck_size, mk_size, 0, 0,
+						key_ctx_size >> 4);
+	return 0;
+}
+
+static int chcr_aead_rfc4309_setkey(struct crypto_aead *aead, const u8 *key,
+				    unsigned int keylen)
+{
+	struct chcr_context *ctx = crypto_aead_ctx(aead);
+	 struct chcr_aead_ctx *aeadctx = AEAD_CTX(ctx);
+
+	if (keylen < 3) {
+		crypto_tfm_set_flags((struct crypto_tfm *)aead,
+				     CRYPTO_TFM_RES_BAD_KEY_LEN);
+		aeadctx->enckey_len = 0;
+		return	-EINVAL;
+	}
+	keylen -= 3;
+	memcpy(aeadctx->salt, key + keylen, 3);
+	return chcr_aead_ccm_setkey(aead, key, keylen);
+}
+
+static int chcr_gcm_setkey(struct crypto_aead *aead, const u8 *key,
+			   unsigned int keylen)
+{
+	struct chcr_context *ctx = crypto_aead_ctx(aead);
+	struct chcr_aead_ctx *aeadctx = AEAD_CTX(ctx);
+	struct chcr_gcm_ctx *gctx = GCM_CTX(aeadctx);
+	struct blkcipher_desc h_desc;
+	struct scatterlist src[1];
+	unsigned int ck_size;
+	int ret = 0, key_ctx_size = 0;
+
+	if (get_aead_subtype(aead) ==
+	    CRYPTO_ALG_SUB_TYPE_AEAD_RFC4106) {
+		keylen -= 4;  /* nonce/salt is present in the last 4 bytes */
+		memcpy(aeadctx->salt, key + keylen, 4);
+	}
+	if (keylen == AES_KEYSIZE_128) {
+		ck_size = CHCR_KEYCTX_CIPHER_KEY_SIZE_128;
+	} else if (keylen == AES_KEYSIZE_192) {
+		ck_size = CHCR_KEYCTX_CIPHER_KEY_SIZE_192;
+	} else if (keylen == AES_KEYSIZE_256) {
+		ck_size = CHCR_KEYCTX_CIPHER_KEY_SIZE_256;
+	} else {
+		crypto_tfm_set_flags((struct crypto_tfm *)aead,
+				     CRYPTO_TFM_RES_BAD_KEY_LEN);
+		aeadctx->enckey_len = 0;
+		pr_err("GCM: Invalid key length %d", keylen);
+		ret = -EINVAL;
+		goto out;
+	}
+
+	memcpy(aeadctx->key, key, keylen);
+	aeadctx->enckey_len = keylen;
+	key_ctx_size = sizeof(struct _key_ctx) +
+		((DIV_ROUND_UP(keylen, 16)) << 4) +
+		AEAD_H_SIZE;
+		aeadctx->key_ctx_hdr = FILL_KEY_CTX_HDR(ck_size,
+						CHCR_KEYCTX_MAC_KEY_SIZE_128,
+						0, 0,
+						key_ctx_size >> 4);
+	/* Calculate the H = CIPH(K, 0 repeated 16 times) using sync aes
+	* blkcipher It will go on key context
+	*/
+	h_desc.tfm = crypto_alloc_blkcipher("cbc(aes-generic)", 0, 0);
+	if (IS_ERR(h_desc.tfm)) {
+		aeadctx->enckey_len = 0;
+		ret = -ENOMEM;
+		goto out;
+	}
+	h_desc.flags = 0;
+	ret = crypto_blkcipher_setkey(h_desc.tfm, key, keylen);
+	if (ret) {
+		aeadctx->enckey_len = 0;
+		goto out1;
+	}
+	memset(gctx->ghash_h, 0, AEAD_H_SIZE);
+	sg_init_one(&src[0], gctx->ghash_h, AEAD_H_SIZE);
+	ret = crypto_blkcipher_encrypt(&h_desc, &src[0], &src[0], AEAD_H_SIZE);
+
+out1:
+	crypto_free_blkcipher(h_desc.tfm);
+out:
+	return ret;
+}
+
+static int chcr_authenc_setkey(struct crypto_aead *authenc, const u8 *key,
+				   unsigned int keylen)
+{
+	struct chcr_context *ctx = crypto_aead_ctx(authenc);
+	struct chcr_aead_ctx *aeadctx = AEAD_CTX(ctx);
+	struct chcr_authenc_ctx *actx = AUTHENC_CTX(aeadctx);
+	/* it contains auth and cipher key both*/
+	struct crypto_authenc_keys keys;
+	unsigned int bs;
+	unsigned int max_authsize = crypto_aead_alg(authenc)->maxauthsize;
+	int err = 0, i, key_ctx_len = 0;
+	unsigned char ck_size = 0;
+	unsigned char pad[CHCR_HASH_MAX_BLOCK_SIZE_128] = { 0 };
+	struct crypto_shash *base_hash = NULL;
+	struct algo_param param;
+	int align;
+	u8 *o_ptr = NULL;
+
+	if (crypto_authenc_extractkeys(&keys, key, keylen) != 0) {
+		crypto_aead_set_flags(authenc, CRYPTO_TFM_RES_BAD_KEY_LEN);
+		goto out;
+	}
+
+	if (get_alg_config(&param, max_authsize)) {
+		pr_err("chcr : Unsupported digest size\n");
+		goto out;
+	}
+	if (keys.enckeylen == AES_KEYSIZE_128) {
+		ck_size = CHCR_KEYCTX_CIPHER_KEY_SIZE_128;
+	} else if (keys.enckeylen == AES_KEYSIZE_192) {
+		ck_size = CHCR_KEYCTX_CIPHER_KEY_SIZE_192;
+	} else if (keys.enckeylen == AES_KEYSIZE_256) {
+		ck_size = CHCR_KEYCTX_CIPHER_KEY_SIZE_256;
+	} else {
+		pr_err("chcr : Unsupported cipher key\n");
+		goto out;
+	}
+
+	/* Copy only encryption key. We use authkey to generate h(ipad) and
+	 * h(opad) so authkey is not needed again. authkeylen size have the
+	 * size of the hash digest size.
+	 */
+	memcpy(aeadctx->key, keys.enckey, keys.enckeylen);
+	aeadctx->enckey_len = keys.enckeylen;
+	get_aes_decrypt_key(actx->dec_rrkey, aeadctx->key,
+			    aeadctx->enckey_len << 3);
+
+	base_hash  = chcr_alloc_shash(max_authsize);
+	if (IS_ERR(base_hash)) {
+		pr_err("chcr : Base driver cannot be loaded\n");
+		goto out;
+	}
+	{
+		SHASH_DESC_ON_STACK(shash, base_hash);
+		shash->tfm = base_hash;
+		shash->flags = crypto_shash_get_flags(base_hash);
+		bs = crypto_shash_blocksize(base_hash);
+		align = KEYCTX_ALIGN_PAD(max_authsize);
+		o_ptr =  actx->h_iopad + param.result_size + align;
+
+		if (keys.authkeylen > bs) {
+			err = crypto_shash_digest(shash, keys.authkey,
+						  keys.authkeylen,
+						  o_ptr);
+			if (err) {
+				pr_err("chcr : Base driver cannot be loaded\n");
+				goto out;
+			}
+			keys.authkeylen = max_authsize;
+		} else
+			memcpy(o_ptr, keys.authkey, keys.authkeylen);
+
+		/* Compute the ipad-digest*/
+		memset(pad + keys.authkeylen, 0, bs - keys.authkeylen);
+		memcpy(pad, o_ptr, keys.authkeylen);
+		for (i = 0; i < bs >> 2; i++)
+			*((unsigned int *)pad + i) ^= IPAD_DATA;
+
+		if (chcr_compute_partial_hash(shash, pad, actx->h_iopad,
+					      max_authsize))
+			goto out;
+		/* Compute the opad-digest */
+		memset(pad + keys.authkeylen, 0, bs - keys.authkeylen);
+		memcpy(pad, o_ptr, keys.authkeylen);
+		for (i = 0; i < bs >> 2; i++)
+			*((unsigned int *)pad + i) ^= OPAD_DATA;
+
+		if (chcr_compute_partial_hash(shash, pad, o_ptr, max_authsize))
+			goto out;
+
+		/* convert the ipad and opad digest to network order */
+		chcr_change_order(actx->h_iopad, param.result_size);
+		chcr_change_order(o_ptr, param.result_size);
+		key_ctx_len = sizeof(struct _key_ctx) +
+			((DIV_ROUND_UP(keys.enckeylen, 16)) << 4) +
+			(param.result_size + align) * 2;
+		aeadctx->key_ctx_hdr = FILL_KEY_CTX_HDR(ck_size, param.mk_size,
+						0, 1, key_ctx_len >> 4);
+		actx->auth_mode = param.auth_mode;
+		chcr_free_shash(base_hash);
+
+		return 0;
+	}
+out:
+	aeadctx->enckey_len = 0;
+	if (base_hash)
+		chcr_free_shash(base_hash);
+	return -EINVAL;
+}
+
+static int chcr_aead_digest_null_setkey(struct crypto_aead *authenc,
+					const u8 *key, unsigned int keylen)
+{
+	struct chcr_context *ctx = crypto_aead_ctx(authenc);
+	struct chcr_aead_ctx *aeadctx = AEAD_CTX(ctx);
+	struct chcr_authenc_ctx *actx = AUTHENC_CTX(aeadctx);
+	struct crypto_authenc_keys keys;
+
+	/* it contains auth and cipher key both*/
+	int key_ctx_len = 0;
+	unsigned char ck_size = 0;
+
+	if (crypto_authenc_extractkeys(&keys, key, keylen) != 0) {
+		crypto_aead_set_flags(authenc, CRYPTO_TFM_RES_BAD_KEY_LEN);
+		goto out;
+	}
+	if (keys.enckeylen == AES_KEYSIZE_128) {
+		ck_size = CHCR_KEYCTX_CIPHER_KEY_SIZE_128;
+	} else if (keys.enckeylen == AES_KEYSIZE_192) {
+		ck_size = CHCR_KEYCTX_CIPHER_KEY_SIZE_192;
+	} else if (keys.enckeylen == AES_KEYSIZE_256) {
+		ck_size = CHCR_KEYCTX_CIPHER_KEY_SIZE_256;
+	} else {
+		pr_err("chcr : Unsupported cipher key\n");
+		goto out;
+	}
+	memcpy(aeadctx->key, keys.enckey, keys.enckeylen);
+	aeadctx->enckey_len = keys.enckeylen;
+	get_aes_decrypt_key(actx->dec_rrkey, aeadctx->key,
+				    aeadctx->enckey_len << 3);
+	key_ctx_len =  sizeof(struct _key_ctx)
+		+ ((DIV_ROUND_UP(keys.enckeylen, 16)) << 4);
+
+	aeadctx->key_ctx_hdr = FILL_KEY_CTX_HDR(ck_size, CHCR_KEYCTX_NO_KEY, 0,
+						0, key_ctx_len >> 4);
+	actx->auth_mode = CHCR_SCMD_AUTH_MODE_NOP;
+	return 0;
+out:
+	aeadctx->enckey_len = 0;
+	return -EINVAL;
+}
+static int chcr_aead_encrypt(struct aead_request *req)
+{
+	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+	struct chcr_aead_reqctx *reqctx = aead_request_ctx(req);
+
+	reqctx->verify = VERIFY_HW;
+
+	switch (get_aead_subtype(tfm)) {
+	case CRYPTO_ALG_SUB_TYPE_AEAD_AUTHENC:
+	case CRYPTO_ALG_SUB_TYPE_AEAD_NULL:
+		return chcr_aead_op(req, CHCR_ENCRYPT_OP, 0,
+				    create_authenc_wr);
+	case CRYPTO_ALG_SUB_TYPE_AEAD_CCM:
+	case CRYPTO_ALG_SUB_TYPE_AEAD_RFC4309:
+		return chcr_aead_op(req, CHCR_ENCRYPT_OP, 0,
+				    create_aead_ccm_wr);
+	default:
+		return chcr_aead_op(req, CHCR_ENCRYPT_OP, 0,
+				    create_gcm_wr);
+	}
+}
+
+static int chcr_aead_decrypt(struct aead_request *req)
+{
+	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+	struct chcr_aead_ctx *aeadctx = AEAD_CTX(crypto_aead_ctx(tfm));
+	struct chcr_aead_reqctx *reqctx = aead_request_ctx(req);
+	int size;
+
+	if (aeadctx->mayverify == VERIFY_SW) {
+		size = crypto_aead_maxauthsize(tfm);
+		reqctx->verify = VERIFY_SW;
+	} else {
+		size = 0;
+		reqctx->verify = VERIFY_HW;
+	}
+
+	switch (get_aead_subtype(tfm)) {
+	case CRYPTO_ALG_SUB_TYPE_AEAD_AUTHENC:
+	case CRYPTO_ALG_SUB_TYPE_AEAD_NULL:
+		return chcr_aead_op(req, CHCR_DECRYPT_OP, size,
+				    create_authenc_wr);
+	case CRYPTO_ALG_SUB_TYPE_AEAD_CCM:
+	case CRYPTO_ALG_SUB_TYPE_AEAD_RFC4309:
+		return chcr_aead_op(req, CHCR_DECRYPT_OP, size,
+				    create_aead_ccm_wr);
+	default:
+		return chcr_aead_op(req, CHCR_DECRYPT_OP, size,
+				    create_gcm_wr);
+	}
+}
+
+static int chcr_aead_op(struct aead_request *req,
+			  unsigned short op_type,
+			  int size,
+			  create_wr_t create_wr_fn)
+{
+	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
+	struct chcr_context *ctx = crypto_aead_ctx(tfm);
+	struct uld_ctx *u_ctx = ULD_CTX(ctx);
+	struct sk_buff *skb;
+
+	if (ctx && !ctx->dev) {
+		pr_err("chcr : %s : No crypto device.\n", __func__);
+		return -ENXIO;
+	}
+	if (cxgb4_is_crypto_q_full(u_ctx->lldi.ports[0],
+				   ctx->tx_channel_id)) {
+		if (!(req->base.flags & CRYPTO_TFM_REQ_MAY_BACKLOG))
+			return -EBUSY;
+	}
+
+	/* Form a WR from req */
+	skb = create_wr_fn(req, u_ctx->lldi.rxq_ids[ctx->tx_channel_id], size,
+			   op_type);
+
+	if (IS_ERR(skb) || skb == NULL) {
+		pr_err("chcr : %s : failed to form WR. No memory\n", __func__);
+		return PTR_ERR(skb);
+	}
+
+	skb->dev = u_ctx->lldi.ports[0];
+	set_wr_txq(skb, CPL_PRIORITY_DATA, ctx->tx_channel_id);
+	chcr_send_wr(skb);
+	return -EINPROGRESS;
+}
 static struct chcr_alg_template driver_algs[] = {
 	/* AES-CBC */
 	{
@@ -1256,7 +2468,7 @@ static struct chcr_alg_template driver_algs[] = {
 		.is_registered = 0,
 		.alg.crypto = {
 			.cra_name		= "cbc(aes)",
-			.cra_driver_name	= "cbc(aes-chcr)",
+			.cra_driver_name	= "cbc-aes-chcr",
 			.cra_priority		= CHCR_CRA_PRIORITY,
 			.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER |
 				CRYPTO_ALG_ASYNC,
@@ -1283,7 +2495,7 @@ static struct chcr_alg_template driver_algs[] = {
 		.is_registered = 0,
 		.alg.crypto =   {
 			.cra_name		= "xts(aes)",
-			.cra_driver_name	= "xts(aes-chcr)",
+			.cra_driver_name	= "xts-aes-chcr",
 			.cra_priority		= CHCR_CRA_PRIORITY,
 			.cra_flags		= CRYPTO_ALG_TYPE_BLKCIPHER |
 				CRYPTO_ALG_ASYNC,
@@ -1376,7 +2588,7 @@ static struct chcr_alg_template driver_algs[] = {
 			.halg.digestsize = SHA1_DIGEST_SIZE,
 			.halg.base = {
 				.cra_name = "hmac(sha1)",
-				.cra_driver_name = "hmac(sha1-chcr)",
+				.cra_driver_name = "hmac-sha1-chcr",
 				.cra_blocksize = SHA1_BLOCK_SIZE,
 			}
 		}
@@ -1388,7 +2600,7 @@ static struct chcr_alg_template driver_algs[] = {
 			.halg.digestsize = SHA224_DIGEST_SIZE,
 			.halg.base = {
 				.cra_name = "hmac(sha224)",
-				.cra_driver_name = "hmac(sha224-chcr)",
+				.cra_driver_name = "hmac-sha224-chcr",
 				.cra_blocksize = SHA224_BLOCK_SIZE,
 			}
 		}
@@ -1400,7 +2612,7 @@ static struct chcr_alg_template driver_algs[] = {
 			.halg.digestsize = SHA256_DIGEST_SIZE,
 			.halg.base = {
 				.cra_name = "hmac(sha256)",
-				.cra_driver_name = "hmac(sha256-chcr)",
+				.cra_driver_name = "hmac-sha256-chcr",
 				.cra_blocksize = SHA256_BLOCK_SIZE,
 			}
 		}
@@ -1412,7 +2624,7 @@ static struct chcr_alg_template driver_algs[] = {
 			.halg.digestsize = SHA384_DIGEST_SIZE,
 			.halg.base = {
 				.cra_name = "hmac(sha384)",
-				.cra_driver_name = "hmac(sha384-chcr)",
+				.cra_driver_name = "hmac-sha384-chcr",
 				.cra_blocksize = SHA384_BLOCK_SIZE,
 			}
 		}
@@ -1424,11 +2636,205 @@ static struct chcr_alg_template driver_algs[] = {
 			.halg.digestsize = SHA512_DIGEST_SIZE,
 			.halg.base = {
 				.cra_name = "hmac(sha512)",
-				.cra_driver_name = "hmac(sha512-chcr)",
+				.cra_driver_name = "hmac-sha512-chcr",
 				.cra_blocksize = SHA512_BLOCK_SIZE,
 			}
 		}
 	},
+	/* Add AEAD Algorithms */
+	{
+		.type = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_SUB_TYPE_AEAD_GCM,
+		.is_registered = 0,
+		.alg.aead = {
+			.base = {
+				.cra_name = "gcm(aes)",
+				.cra_driver_name = "gcm-aes-chcr",
+				.cra_blocksize	= 1,
+				.cra_ctxsize =	sizeof(struct chcr_context) +
+						sizeof(struct chcr_aead_ctx) +
+						sizeof(struct chcr_gcm_ctx),
+			},
+			.ivsize = AES_BLOCK_SIZE,
+			.maxauthsize = GHASH_DIGEST_SIZE,
+			.setkey = chcr_gcm_setkey,
+			.setauthsize = chcr_gcm_setauthsize,
+		}
+	},
+	{
+		.type = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_SUB_TYPE_AEAD_RFC4106,
+		.is_registered = 0,
+		.alg.aead = {
+			.base = {
+				.cra_name = "rfc4106(gcm(aes))",
+				.cra_driver_name = "rfc4106-gcm-aes-chcr",
+				.cra_blocksize	 = 1,
+				.cra_ctxsize =	sizeof(struct chcr_context) +
+						sizeof(struct chcr_aead_ctx) +
+						sizeof(struct chcr_gcm_ctx),
+
+			},
+			.ivsize = 8,
+			.maxauthsize	= GHASH_DIGEST_SIZE,
+			.setkey = chcr_gcm_setkey,
+			.setauthsize	= chcr_4106_4309_setauthsize,
+		}
+	},
+	{
+		.type = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_SUB_TYPE_AEAD_CCM,
+		.is_registered = 0,
+		.alg.aead = {
+			.base = {
+				.cra_name = "ccm(aes)",
+				.cra_driver_name = "ccm-aes-chcr",
+				.cra_blocksize	 = 1,
+				.cra_ctxsize =	sizeof(struct chcr_context) +
+						sizeof(struct chcr_aead_ctx),
+
+			},
+			.ivsize = AES_BLOCK_SIZE,
+			.maxauthsize	= GHASH_DIGEST_SIZE,
+			.setkey = chcr_aead_ccm_setkey,
+			.setauthsize	= chcr_ccm_setauthsize,
+		}
+	},
+	{
+		.type = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_SUB_TYPE_AEAD_RFC4309,
+		.is_registered = 0,
+		.alg.aead = {
+			.base = {
+				.cra_name = "rfc4309(ccm(aes))",
+				.cra_driver_name = "rfc4309-ccm-aes-chcr",
+				.cra_blocksize	 = 1,
+				.cra_ctxsize =	sizeof(struct chcr_context) +
+						sizeof(struct chcr_aead_ctx),
+
+			},
+			.ivsize = 8,
+			.maxauthsize	= GHASH_DIGEST_SIZE,
+			.setkey = chcr_aead_rfc4309_setkey,
+			.setauthsize = chcr_4106_4309_setauthsize,
+		}
+	},
+	{
+		.type = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_SUB_TYPE_AEAD_AUTHENC,
+		.is_registered = 0,
+		.alg.aead = {
+			.base = {
+				.cra_name = "authenc(hmac(sha1),cbc(aes))",
+				.cra_driver_name =
+					"authenc-hmac-sha1-cbc-aes-chcr",
+				.cra_blocksize	 = AES_BLOCK_SIZE,
+				.cra_ctxsize =	sizeof(struct chcr_context) +
+						sizeof(struct chcr_aead_ctx) +
+						sizeof(struct chcr_authenc_ctx),
+
+			},
+			.ivsize = AES_BLOCK_SIZE,
+			.maxauthsize = SHA1_DIGEST_SIZE,
+			.setkey = chcr_authenc_setkey,
+			.setauthsize = chcr_authenc_setauthsize,
+		}
+	},
+	{
+		.type = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_SUB_TYPE_AEAD_AUTHENC,
+		.is_registered = 0,
+		.alg.aead = {
+			.base = {
+
+				.cra_name = "authenc(hmac(sha256),cbc(aes))",
+				.cra_driver_name =
+					"authenc-hmac-sha256-cbc-aes-chcr",
+				.cra_blocksize	 = AES_BLOCK_SIZE,
+				.cra_ctxsize =	sizeof(struct chcr_context) +
+						sizeof(struct chcr_aead_ctx) +
+						sizeof(struct chcr_authenc_ctx),
+
+			},
+			.ivsize = AES_BLOCK_SIZE,
+			.maxauthsize	= SHA256_DIGEST_SIZE,
+			.setkey = chcr_authenc_setkey,
+			.setauthsize = chcr_authenc_setauthsize,
+		}
+	},
+	{
+		.type = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_SUB_TYPE_AEAD_AUTHENC,
+		.is_registered = 0,
+		.alg.aead = {
+			.base = {
+				.cra_name = "authenc(hmac(sha224),cbc(aes))",
+				.cra_driver_name =
+					"authenc-hmac-sha224-cbc-aes-chcr",
+				.cra_blocksize	 = AES_BLOCK_SIZE,
+				.cra_ctxsize =	sizeof(struct chcr_context) +
+						sizeof(struct chcr_aead_ctx) +
+						sizeof(struct chcr_authenc_ctx),
+			},
+			.ivsize = AES_BLOCK_SIZE,
+			.maxauthsize = SHA224_DIGEST_SIZE,
+			.setkey = chcr_authenc_setkey,
+			.setauthsize = chcr_authenc_setauthsize,
+		}
+	},
+	{
+		.type = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_SUB_TYPE_AEAD_AUTHENC,
+		.is_registered = 0,
+		.alg.aead = {
+			.base = {
+				.cra_name = "authenc(hmac(sha384),cbc(aes))",
+				.cra_driver_name =
+					"authenc-hmac-sha384-cbc-aes-chcr",
+				.cra_blocksize	 = AES_BLOCK_SIZE,
+				.cra_ctxsize =	sizeof(struct chcr_context) +
+						sizeof(struct chcr_aead_ctx) +
+						sizeof(struct chcr_authenc_ctx),
+
+			},
+			.ivsize = AES_BLOCK_SIZE,
+			.maxauthsize = SHA384_DIGEST_SIZE,
+			.setkey = chcr_authenc_setkey,
+			.setauthsize = chcr_authenc_setauthsize,
+		}
+	},
+	{
+		.type = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_SUB_TYPE_AEAD_AUTHENC,
+		.is_registered = 0,
+		.alg.aead = {
+			.base = {
+				.cra_name = "authenc(hmac(sha512),cbc(aes))",
+				.cra_driver_name =
+					"authenc-hmac-sha512-cbc-aes-chcr",
+				.cra_blocksize	 = AES_BLOCK_SIZE,
+				.cra_ctxsize =	sizeof(struct chcr_context) +
+						sizeof(struct chcr_aead_ctx) +
+						sizeof(struct chcr_authenc_ctx),
+
+			},
+			.ivsize = AES_BLOCK_SIZE,
+			.maxauthsize = SHA512_DIGEST_SIZE,
+			.setkey = chcr_authenc_setkey,
+			.setauthsize = chcr_authenc_setauthsize,
+		}
+	},
+	{
+		.type = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_SUB_TYPE_AEAD_NULL,
+		.is_registered = 0,
+		.alg.aead = {
+			.base = {
+				.cra_name = "authenc(digest_null,cbc(aes))",
+				.cra_driver_name =
+					"authenc-digest_null-cbc-aes-chcr",
+				.cra_blocksize	 = AES_BLOCK_SIZE,
+				.cra_ctxsize =	sizeof(struct chcr_context) +
+						sizeof(struct chcr_aead_ctx) +
+						sizeof(struct chcr_authenc_ctx),
+
+			},
+			.ivsize  = AES_BLOCK_SIZE,
+			.maxauthsize = 0,
+			.setkey  = chcr_aead_digest_null_setkey,
+			.setauthsize = chcr_authenc_null_setauthsize,
+		}
+	},
 };
 
 /*
@@ -1446,6 +2852,11 @@ static int chcr_unregister_alg(void)
 				crypto_unregister_alg(
 						&driver_algs[i].alg.crypto);
 			break;
+		case CRYPTO_ALG_TYPE_AEAD:
+			if (driver_algs[i].is_registered)
+				crypto_unregister_aead(
+						&driver_algs[i].alg.aead);
+			break;
 		case CRYPTO_ALG_TYPE_AHASH:
 			if (driver_algs[i].is_registered)
 				crypto_unregister_ahash(
@@ -1480,6 +2891,19 @@ static int chcr_register_alg(void)
 			err = crypto_register_alg(&driver_algs[i].alg.crypto);
 			name = driver_algs[i].alg.crypto.cra_driver_name;
 			break;
+		case CRYPTO_ALG_TYPE_AEAD:
+			driver_algs[i].alg.aead.base.cra_priority =
+				CHCR_CRA_PRIORITY;
+			driver_algs[i].alg.aead.base.cra_flags =
+				CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC;
+			driver_algs[i].alg.aead.encrypt = chcr_aead_encrypt;
+			driver_algs[i].alg.aead.decrypt = chcr_aead_decrypt;
+			driver_algs[i].alg.aead.init = chcr_aead_cra_init;
+			driver_algs[i].alg.aead.exit = chcr_aead_cra_exit;
+			driver_algs[i].alg.aead.base.cra_module = THIS_MODULE;
+			err = crypto_register_aead(&driver_algs[i].alg.aead);
+			name = driver_algs[i].alg.aead.base.cra_driver_name;
+			break;
 		case CRYPTO_ALG_TYPE_AHASH:
 			a_hash = &driver_algs[i].alg.hash;
 			a_hash->update = chcr_ahash_update;
diff --git a/drivers/crypto/chelsio/chcr_algo.h b/drivers/crypto/chelsio/chcr_algo.h
index f2a5905..3c7c51f 100644
--- a/drivers/crypto/chelsio/chcr_algo.h
+++ b/drivers/crypto/chelsio/chcr_algo.h
@@ -258,13 +258,15 @@ enum {
  * where they indicate the size of the integrity check value (ICV)
  */
 enum {
-	AES_CCM_ICV_4   = 4,
-	AES_CCM_ICV_6   = 6,
-	AES_CCM_ICV_8   = 8,
-	AES_CCM_ICV_10  = 10,
-	AES_CCM_ICV_12  = 12,
-	AES_CCM_ICV_14  = 14,
-	AES_CCM_ICV_16 = 16
+	ICV_4  = 4,
+	ICV_6  = 6,
+	ICV_8  = 8,
+	ICV_10 = 10,
+	ICV_12 = 12,
+	ICV_13 = 13,
+	ICV_14 = 14,
+	ICV_15 = 15,
+	ICV_16 = 16
 };
 
 struct hash_op_params {
diff --git a/drivers/crypto/chelsio/chcr_core.c b/drivers/crypto/chelsio/chcr_core.c
index 2f6156b..49e9975 100644
--- a/drivers/crypto/chelsio/chcr_core.c
+++ b/drivers/crypto/chelsio/chcr_core.c
@@ -111,14 +111,12 @@ static int cpl_fw6_pld_handler(struct chcr_dev *dev,
 	if (ack_err_status) {
 		if (CHK_MAC_ERR_BIT(ack_err_status) ||
 		    CHK_PAD_ERR_BIT(ack_err_status))
-			error_status = -EINVAL;
+			error_status = -EBADMSG;
 	}
 	/* call completion callback with failure status */
 	if (req) {
-		if (!chcr_handle_resp(req, input, error_status))
-			req->complete(req, error_status);
-		else
-			return -EINVAL;
+		error_status = chcr_handle_resp(req, input, error_status);
+		req->complete(req, error_status);
 	} else {
 		pr_err("Incorrect request address from the firmware\n");
 		return -EFAULT;
diff --git a/drivers/crypto/chelsio/chcr_core.h b/drivers/crypto/chelsio/chcr_core.h
index fc3cd77..c7088a4 100644
--- a/drivers/crypto/chelsio/chcr_core.h
+++ b/drivers/crypto/chelsio/chcr_core.h
@@ -72,9 +72,7 @@ struct chcr_wr {
 };
 
 struct chcr_dev {
-	/* Request submited to h/w and waiting for response. */
 	spinlock_t lock_chcr_dev;
-	struct crypto_queue pending_queue;
 	struct uld_ctx *u_ctx;
 	unsigned char tx_channel_id;
 };
diff --git a/drivers/crypto/chelsio/chcr_crypto.h b/drivers/crypto/chelsio/chcr_crypto.h
index 40a5182..d5af7d6 100644
--- a/drivers/crypto/chelsio/chcr_crypto.h
+++ b/drivers/crypto/chelsio/chcr_crypto.h
@@ -36,6 +36,14 @@
 #ifndef __CHCR_CRYPTO_H__
 #define __CHCR_CRYPTO_H__
 
+#define GHASH_BLOCK_SIZE    16
+#define GHASH_DIGEST_SIZE   16
+
+#define CCM_B0_SIZE             16
+#define CCM_AAD_FIELD_SIZE      2
+#define T5_MAX_AAD_SIZE 512
+
+
 /* Define following if h/w is not dropping the AAD and IV data before
  * giving the processed data
  */
@@ -63,22 +71,36 @@
 #define CHCR_SCMD_AUTH_CTRL_AUTH_CIPHER 0
 #define CHCR_SCMD_AUTH_CTRL_CIPHER_AUTH 1
 
-#define CHCR_SCMD_CIPHER_MODE_NOP           0
-#define CHCR_SCMD_CIPHER_MODE_AES_CBC       1
-#define CHCR_SCMD_CIPHER_MODE_GENERIC_AES   4
-#define CHCR_SCMD_CIPHER_MODE_AES_XTS       6
+#define CHCR_SCMD_CIPHER_MODE_NOP               0
+#define CHCR_SCMD_CIPHER_MODE_AES_CBC           1
+#define CHCR_SCMD_CIPHER_MODE_AES_GCM           2
+#define CHCR_SCMD_CIPHER_MODE_AES_CTR           3
+#define CHCR_SCMD_CIPHER_MODE_GENERIC_AES       4
+#define CHCR_SCMD_CIPHER_MODE_AES_XTS           6
+#define CHCR_SCMD_CIPHER_MODE_AES_CCM           7
 
 #define CHCR_SCMD_AUTH_MODE_NOP             0
 #define CHCR_SCMD_AUTH_MODE_SHA1            1
 #define CHCR_SCMD_AUTH_MODE_SHA224          2
 #define CHCR_SCMD_AUTH_MODE_SHA256          3
+#define CHCR_SCMD_AUTH_MODE_GHASH           4
 #define CHCR_SCMD_AUTH_MODE_SHA512_224      5
 #define CHCR_SCMD_AUTH_MODE_SHA512_256      6
 #define CHCR_SCMD_AUTH_MODE_SHA512_384      7
 #define CHCR_SCMD_AUTH_MODE_SHA512_512      8
+#define CHCR_SCMD_AUTH_MODE_CBCMAC          9
+#define CHCR_SCMD_AUTH_MODE_CMAC            10
 
 #define CHCR_SCMD_HMAC_CTRL_NOP             0
 #define CHCR_SCMD_HMAC_CTRL_NO_TRUNC        1
+#define CHCR_SCMD_HMAC_CTRL_TRUNC_RFC4366   2
+#define CHCR_SCMD_HMAC_CTRL_IPSEC_96BIT     3
+#define CHCR_SCMD_HMAC_CTRL_PL1		    4
+#define CHCR_SCMD_HMAC_CTRL_PL2		    5
+#define CHCR_SCMD_HMAC_CTRL_PL3		    6
+#define CHCR_SCMD_HMAC_CTRL_DIV2	    7
+#define VERIFY_HW 0
+#define VERIFY_SW 1
 
 #define CHCR_SCMD_IVGEN_CTRL_HW             0
 #define CHCR_SCMD_IVGEN_CTRL_SW             1
@@ -106,12 +128,20 @@
 #define IV_IMMEDIATE            1
 #define IV_DSGL			2
 
+#define AEAD_H_SIZE             16
+
 #define CRYPTO_ALG_SUB_TYPE_MASK            0x0f000000
 #define CRYPTO_ALG_SUB_TYPE_HASH_HMAC       0x01000000
+#define CRYPTO_ALG_SUB_TYPE_AEAD_RFC4106    0x02000000
+#define CRYPTO_ALG_SUB_TYPE_AEAD_GCM	    0x03000000
+#define CRYPTO_ALG_SUB_TYPE_AEAD_AUTHENC    0x04000000
+#define CRYPTO_ALG_SUB_TYPE_AEAD_CCM        0x05000000
+#define CRYPTO_ALG_SUB_TYPE_AEAD_RFC4309    0x06000000
+#define CRYPTO_ALG_SUB_TYPE_AEAD_NULL       0x07000000
+#define CRYPTO_ALG_SUB_TYPE_CTR             0x08000000
 #define CRYPTO_ALG_TYPE_HMAC (CRYPTO_ALG_TYPE_AHASH |\
 			      CRYPTO_ALG_SUB_TYPE_HASH_HMAC)
 
-#define MAX_SALT                4
 #define MAX_SCRATCH_PAD_SIZE    32
 
 #define CHCR_HASH_MAX_BLOCK_SIZE_64  64
@@ -126,6 +156,42 @@ struct ablk_ctx {
 	unsigned char ciph_mode;
 	u8 rrkey[AES_MAX_KEY_SIZE];
 };
+struct chcr_aead_reqctx {
+	struct	sk_buff	*skb;
+	short int dst_nents;
+	u16 verify;
+	u8 iv[CHCR_MAX_CRYPTO_IV_LEN];
+	unsigned char scratch_pad[MAX_SCRATCH_PAD_SIZE];
+};
+
+struct chcr_gcm_ctx {
+	u8 ghash_h[AEAD_H_SIZE];
+};
+
+struct chcr_authenc_ctx {
+	u8 dec_rrkey[AES_MAX_KEY_SIZE];
+	u8 h_iopad[2 * CHCR_HASH_MAX_DIGEST_SIZE];
+	unsigned char auth_mode;
+};
+
+struct __aead_ctx {
+	struct chcr_gcm_ctx gcm[0];
+	struct chcr_authenc_ctx authenc[0];
+};
+
+
+
+struct chcr_aead_ctx {
+	__be32 key_ctx_hdr;
+	unsigned int enckey_len;
+	struct crypto_skcipher *null;
+	u8 salt[MAX_SALT];
+	u8 key[CHCR_AES_MAX_KEY_LEN];
+	u16 hmac_ctrl;
+	u16 mayverify;
+	struct	__aead_ctx ctx[0];
+};
+
 
 
 struct hmac_ctx {
@@ -137,6 +203,7 @@ struct hmac_ctx {
 struct __crypto_ctx {
 	struct hmac_ctx hmacctx[0];
 	struct ablk_ctx ablkctx[0];
+	struct chcr_aead_ctx aeadctx[0];
 };
 
 struct chcr_context {
@@ -171,16 +238,19 @@ struct chcr_alg_template {
 	union {
 		struct crypto_alg crypto;
 		struct ahash_alg hash;
+		struct aead_alg aead;
 	} alg;
 };
 
 struct chcr_req_ctx {
 	union {
 		struct ahash_request *ahash_req;
+		struct aead_request *aead_req;
 		struct ablkcipher_request *ablk_req;
 	} req;
 	union {
 		struct chcr_ahash_req_ctx *ahash_ctx;
+		struct chcr_aead_reqctx *reqctx;
 		struct chcr_blkcipher_req_ctx *ablk_ctx;
 	} ctx;
 };
@@ -190,9 +260,15 @@ struct sge_opaque_hdr {
 	dma_addr_t addr[MAX_SKB_FRAGS + 1];
 };
 
-typedef struct sk_buff *(*create_wr_t)(struct crypto_async_request *req,
-				       struct chcr_context *ctx,
+typedef struct sk_buff *(*create_wr_t)(struct aead_request *req,
 				       unsigned short qid,
+				       int size,
 				       unsigned short op_type);
 
+static int chcr_aead_op(struct aead_request *req_base,
+			  unsigned short op_type,
+			  int size,
+			  create_wr_t create_wr_fn);
+static inline int get_aead_subtype(struct crypto_aead *aead);
+
 #endif /* __CHCR_CRYPTO_H__ */
-- 
1.8.2.3
