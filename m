From: Harsh Jain <harsh@chelsio.com>
Subject: [PATCH v3 09/10] crypto/chcr: Move tfm ctx variable to request context
Date: Tue, 29 Nov 2016 19:00:42 +0530
Message-ID: <3c7a8c8404ff982604e9336117651d124e76500f.1480413079.git.harsh@chelsio.com>
References: <cover.1480413079.git.harsh@chelsio.com>
Cc: Harsh Jain <harsh@chelsio.com>
To: dan.carpenter@oracle.com, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, smueller@chronox.de,
        hariprasad@chelsio.com, jlulla@chelsio.com, atul.gupta@chelsio.com,
        yeshaswi@chelsio.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([12.32.117.8]:58753 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933635AbcK2NbZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 29 Nov 2016 08:31:25 -0500
In-Reply-To: <cover.1480413079.git.harsh@chelsio.com>
In-Reply-To: <cover.1480413079.git.harsh@chelsio.com>
References: <cover.1480413079.git.harsh@chelsio.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Move request specific data in request context.

Signed-off-by: Harsh Jain <harsh@chelsio.com>
---
 drivers/crypto/chelsio/chcr_algo.c   | 26 +++++++++++++-------------
 drivers/crypto/chelsio/chcr_crypto.h |  9 ++++-----
 2 files changed, 17 insertions(+), 18 deletions(-)

diff --git a/drivers/crypto/chelsio/chcr_algo.c b/drivers/crypto/chelsio/chcr_algo.c
index e19f7f4..8d677c7 100644
--- a/drivers/crypto/chelsio/chcr_algo.c
+++ b/drivers/crypto/chelsio/chcr_algo.c
@@ -119,7 +119,7 @@ int chcr_handle_resp(struct crypto_async_request *req, unsigned char *input,
 			       AES_BLOCK_SIZE);
 		}
 		dma_unmap_sg(&u_ctx->lldi.pdev->dev, ctx_req.req.ablk_req->dst,
-			     ABLK_CTX(ctx)->dst_nents, DMA_FROM_DEVICE);
+			     ctx_req.ctx.ablk_ctx->dst_nents, DMA_FROM_DEVICE);
 		if (ctx_req.ctx.ablk_ctx->skb) {
 			kfree_skb(ctx_req.ctx.ablk_ctx->skb);
 			ctx_req.ctx.ablk_ctx->skb = NULL;
@@ -138,8 +138,10 @@ int chcr_handle_resp(struct crypto_async_request *req, unsigned char *input,
 			updated_digestsize = SHA256_DIGEST_SIZE;
 		else if (digestsize == SHA384_DIGEST_SIZE)
 			updated_digestsize = SHA512_DIGEST_SIZE;
-		if (ctx_req.ctx.ahash_ctx->skb)
+		if (ctx_req.ctx.ahash_ctx->skb) {
+			kfree_skb(ctx_req.ctx.ahash_ctx->skb);
 			ctx_req.ctx.ahash_ctx->skb = NULL;
+		}
 		if (ctx_req.ctx.ahash_ctx->result == 1) {
 			ctx_req.ctx.ahash_ctx->result = 0;
 			memcpy(ctx_req.req.ahash_req->result, input +
@@ -318,8 +320,7 @@ static inline int is_hmac(struct crypto_tfm *tfm)
 	struct chcr_alg_template *chcr_crypto_alg =
 		container_of(__crypto_ahash_alg(alg), struct chcr_alg_template,
 			     alg.hash);
-	if ((chcr_crypto_alg->type & CRYPTO_ALG_SUB_TYPE_MASK) ==
-	    CRYPTO_ALG_SUB_TYPE_HASH_HMAC)
+	if (chcr_crypto_alg->type == CRYPTO_ALG_TYPE_HMAC)
 		return 1;
 	return 0;
 }
@@ -505,7 +506,7 @@ static inline void create_wreq(struct chcr_context *ctx,
 	struct sk_buff *skb = NULL;
 	struct chcr_wr *chcr_req;
 	struct cpl_rx_phys_dsgl *phys_cpl;
-	struct chcr_blkcipher_req_ctx *req_ctx = ablkcipher_request_ctx(req);
+	struct chcr_blkcipher_req_ctx *reqctx = ablkcipher_request_ctx(req);
 	struct phys_sge_parm sg_param;
 	unsigned int frags = 0, transhdr_len, phys_dsgl;
 	unsigned int ivsize = crypto_ablkcipher_ivsize(tfm), kctx_len;
@@ -514,12 +515,11 @@ static inline void create_wreq(struct chcr_context *ctx,
 
 	if (!req->info)
 		return ERR_PTR(-EINVAL);
-	ablkctx->dst_nents = sg_nents_for_len(req->dst, req->nbytes);
-	if (ablkctx->dst_nents <= 0) {
+	reqctx->dst_nents = sg_nents_for_len(req->dst, req->nbytes);
+	if (reqctx->dst_nents <= 0) {
 		pr_err("AES:Invalid Destination sg lists\n");
 		return ERR_PTR(-EINVAL);
 	}
-	ablkctx->enc = op_type;
 	if ((ablkctx->enckey_len == 0) || (ivsize > AES_BLOCK_SIZE) ||
 	    (req->nbytes <= 0) || (req->nbytes % AES_BLOCK_SIZE)) {
 		pr_err("AES: Invalid value of Key Len %d nbytes %d IV Len %d\n",
@@ -527,7 +527,7 @@ static inline void create_wreq(struct chcr_context *ctx,
 		return ERR_PTR(-EINVAL);
 	}
 
-	phys_dsgl = get_space_for_phys_dsgl(ablkctx->dst_nents);
+	phys_dsgl = get_space_for_phys_dsgl(reqctx->dst_nents);
 
 	kctx_len = (DIV_ROUND_UP(ablkctx->enckey_len, 16) * 16);
 	transhdr_len = CIPHER_TRANSHDR_SIZE(kctx_len, phys_dsgl);
@@ -570,7 +570,7 @@ static inline void create_wreq(struct chcr_context *ctx,
 		}
 	}
 	phys_cpl = (struct cpl_rx_phys_dsgl *)((u8 *)(chcr_req + 1) + kctx_len);
-	sg_param.nents = ablkctx->dst_nents;
+	sg_param.nents = reqctx->dst_nents;
 	sg_param.obsize = req->nbytes;
 	sg_param.qid = qid;
 	sg_param.align = 1;
@@ -579,11 +579,11 @@ static inline void create_wreq(struct chcr_context *ctx,
 		goto map_fail1;
 
 	skb_set_transport_header(skb, transhdr_len);
-	memcpy(ablkctx->iv, req->info, ivsize);
-	write_buffer_to_skb(skb, &frags, ablkctx->iv, ivsize);
+	memcpy(reqctx->iv, req->info, ivsize);
+	write_buffer_to_skb(skb, &frags, reqctx->iv, ivsize);
 	write_sg_to_skb(skb, &frags, req->src, req->nbytes);
 	create_wreq(ctx, chcr_req, req, skb, kctx_len, 0, phys_dsgl);
-	req_ctx->skb = skb;
+	reqctx->skb = skb;
 	skb_get(skb);
 	return skb;
 map_fail1:
diff --git a/drivers/crypto/chelsio/chcr_crypto.h b/drivers/crypto/chelsio/chcr_crypto.h
index 977d205..40a5182 100644
--- a/drivers/crypto/chelsio/chcr_crypto.h
+++ b/drivers/crypto/chelsio/chcr_crypto.h
@@ -120,17 +120,14 @@
 /* Aligned to 128 bit boundary */
 
 struct ablk_ctx {
-	u8 enc;
-	unsigned int processed_len;
 	__be32 key_ctx_hdr;
 	unsigned int enckey_len;
-	unsigned int dst_nents;
 	u8 key[CHCR_AES_MAX_KEY_LEN];
-	u8 rrkey[AES_MAX_KEY_SIZE];
-	u8 iv[CHCR_MAX_CRYPTO_IV_LEN];
 	unsigned char ciph_mode;
+	u8 rrkey[AES_MAX_KEY_SIZE];
 };
 
+
 struct hmac_ctx {
 	struct crypto_shash *base_hash;
 	u8 ipad[CHCR_HASH_MAX_BLOCK_SIZE_128];
@@ -164,6 +161,8 @@ struct chcr_ahash_req_ctx {
 
 struct chcr_blkcipher_req_ctx {
 	struct sk_buff *skb;
+	unsigned int dst_nents;
+	u8 iv[CHCR_MAX_CRYPTO_IV_LEN];
 };
 
 struct chcr_alg_template {
-- 
1.8.2.3
