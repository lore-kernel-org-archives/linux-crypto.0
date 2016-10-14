From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH 6/6] Add support for AEAD algos.
Date: Fri, 14 Oct 2016 16:24:09 +0200
Message-ID: <1610250.DL5oKfbMjq@positron.chronox.de>
References: <cover.1476263960.git.harsh@chelsio.com> <6a957e083297221dc2810a3efd17f936dad2475e.1476263960.git.harsh@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: dan.carpenter@oracle.com, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, jlulla@chelsio.com,
        atul.gupta@chelsio.com, yeshaswi@chelsio.com,
        hariprasad@chelsio.com
To: Harsh Jain <harsh@chelsio.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:49898 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752057AbcJNOYP (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 14 Oct 2016 10:24:15 -0400
In-Reply-To: <6a957e083297221dc2810a3efd17f936dad2475e.1476263960.git.harsh@chelsio.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 13. Oktober 2016, 16:39:39 CEST schrieb Harsh Jain:

Hi Harsh,

> Add support for following AEAD algos.
>  GCM,CCM,RFC4106,RFC4309,authenc(hmac(shaXXX),cbc(aes)).
> 
> Signed-off-by: Harsh Jain <harsh@chelsio.com>
> ---
>  drivers/crypto/chelsio/Kconfig       |    1 +
>  drivers/crypto/chelsio/chcr_algo.c   | 1466
> +++++++++++++++++++++++++++++++++- drivers/crypto/chelsio/chcr_algo.h   |  
> 16 +-
>  drivers/crypto/chelsio/chcr_core.c   |    8 +-
>  drivers/crypto/chelsio/chcr_core.h   |    2 -
>  drivers/crypto/chelsio/chcr_crypto.h |   90 ++-
>  6 files changed, 1541 insertions(+), 42 deletions(-)
> 
> diff --git a/drivers/crypto/chelsio/Kconfig b/drivers/crypto/chelsio/Kconfig
> index 4ce67fb..3e104f5 100644
> --- a/drivers/crypto/chelsio/Kconfig
> +++ b/drivers/crypto/chelsio/Kconfig
> @@ -4,6 +4,7 @@ config CRYPTO_DEV_CHELSIO
>  	select CRYPTO_SHA1
>  	select CRYPTO_SHA256
>  	select CRYPTO_SHA512
> +	select CRYPTO_AUTHENC
>  	---help---
>  	  The Chelsio Crypto Co-processor driver for T6 adapters.
> 
> diff --git a/drivers/crypto/chelsio/chcr_algo.c
> b/drivers/crypto/chelsio/chcr_algo.c index 18385d6..cffc38f 100644
> --- a/drivers/crypto/chelsio/chcr_algo.c
> +++ b/drivers/crypto/chelsio/chcr_algo.c
> @@ -54,6 +54,12 @@
>  #include <crypto/algapi.h>
>  #include <crypto/hash.h>
>  #include <crypto/sha.h>
> +#include <crypto/authenc.h>
> +#include <crypto/internal/aead.h>
> +#include <crypto/null.h>
> +#include <crypto/internal/skcipher.h>
> +#include <crypto/aead.h>
> +#include <crypto/scatterwalk.h>
>  #include <crypto/internal/hash.h>
> 
>  #include "t4fw_api.h"
> @@ -62,6 +68,11 @@
>  #include "chcr_algo.h"
>  #include "chcr_crypto.h"
> 
> +static inline  struct chcr_aead_ctx *AEAD_CTX(struct chcr_context *ctx)
> +{
> +	return ctx->crypto_ctx->aeadctx;
> +}
> +
>  static inline struct ablk_ctx *ABLK_CTX(struct chcr_context *ctx)
>  {
>  	return ctx->crypto_ctx->ablkctx;
> @@ -72,6 +83,16 @@ static inline struct hmac_ctx *HMAC_CTX(struct
> chcr_context *ctx) return ctx->crypto_ctx->hmacctx;
>  }
> 
> +static inline struct chcr_gcm_ctx *GCM_CTX(struct chcr_aead_ctx *gctx)
> +{
> +	return gctx->ctx->gcm;
> +}
> +
> +static inline struct chcr_authenc_ctx *AUTHENC_CTX(struct chcr_aead_ctx
> *gctx) +{
> +	return gctx->ctx->authenc;
> +}
> +
>  static inline struct uld_ctx *ULD_CTX(struct chcr_context *ctx)
>  {
>  	return ctx->dev->u_ctx;
> @@ -94,12 +115,37 @@ static inline unsigned int sgl_len(unsigned int n)
>  	return (3 * n) / 2 + (n & 1) + 2;
>  }
> 
> +static void chcr_verify_tag(struct aead_request *req, u8 *input, int *err)
> +{
> +	u8 temp[SHA512_DIGEST_SIZE];
> +	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
> +	int authsize = crypto_aead_authsize(tfm);
> +	struct cpl_fw6_pld *fw6_pld;
> +	int cmp = 0;
> +
> +	fw6_pld = (struct cpl_fw6_pld *)input;
> +	if ((get_aead_subtype(tfm) == CRYPTO_ALG_SUB_TYPE_AEAD_RFC4106) ||
> +	    (get_aead_subtype(tfm) == CRYPTO_ALG_SUB_TYPE_AEAD_GCM)) {
> +		cmp = memcmp(&fw6_pld->data[2], (fw6_pld + 1), authsize);
> +	} else {
> +
> +		sg_pcopy_to_buffer(req->src, sg_nents(req->src), temp,
> +				authsize, req->assoclen +
> +				req->cryptlen - authsize);

I am wondering whether the math is correct here in any case. It is permissible 
that we have an AAD size of 0 and even a zero-sized ciphertext. How is such 
scenario covered here?

> +		cmp = memcmp(temp, (fw6_pld + 1), authsize);

I would guess in both cases memcmp should be replaced with crypto_memneq

> +	}
> +	if (cmp)
> +		*err = -EBADMSG;
> +	else
> +		*err = 0;

What do you think about memzero_explicit(tmp)?

> +}
> +
>  /*
>   *	chcr_handle_resp - Unmap the DMA buffers associated with the request
>   *	@req: crypto request
>   */
>  int chcr_handle_resp(struct crypto_async_request *req, unsigned char
> *input, -		     int error_status)
> +			 int err)
>  {
>  	struct crypto_tfm *tfm = req->tfm;
>  	struct chcr_context *ctx = crypto_tfm_ctx(tfm);
> @@ -109,11 +155,27 @@ int chcr_handle_resp(struct crypto_async_request *req,
> unsigned char *input, unsigned int digestsize, updated_digestsize;
> 
>  	switch (tfm->__crt_alg->cra_flags & CRYPTO_ALG_TYPE_MASK) {
> +	case CRYPTO_ALG_TYPE_AEAD:
> +		ctx_req.req.aead_req = (struct aead_request *)req;
> +		ctx_req.ctx.reqctx = aead_request_ctx(ctx_req.req.aead_req);
> +		dma_unmap_sg(&u_ctx->lldi.pdev->dev, ctx_req.req.aead_req->dst,
> +			     ctx_req.ctx.reqctx->dst_nents, DMA_FROM_DEVICE);
> +		if (ctx_req.ctx.reqctx->skb) {
> +			kfree_skb(ctx_req.ctx.reqctx->skb);
> +			ctx_req.ctx.reqctx->skb = NULL;
> +		}
> +		if (ctx_req.ctx.reqctx->verify == VERIFY_SW) {
> +			chcr_verify_tag(ctx_req.req.aead_req, input,
> +					&err);
> +			ctx_req.ctx.reqctx->verify = VERIFY_HW;
> +		}
> +		break;
> +
>  	case CRYPTO_ALG_TYPE_BLKCIPHER:
>  		ctx_req.req.ablk_req = (struct ablkcipher_request *)req;
>  		ctx_req.ctx.ablk_ctx =
>  			ablkcipher_request_ctx(ctx_req.req.ablk_req);
> -		if (!error_status) {
> +		if (!err) {
>  			fw6_pld = (struct cpl_fw6_pld *)input;
>  			memcpy(ctx_req.req.ablk_req->info, &fw6_pld->data[2],
>  			       AES_BLOCK_SIZE);
> @@ -154,7 +216,7 @@ int chcr_handle_resp(struct crypto_async_request *req,
> unsigned char *input, }
>  		break;
>  	}
> -	return 0;
> +	return err;
>  }
> 
>  /*
> @@ -380,6 +442,14 @@ static inline int map_writesg_phys_cpl(struct device
> *dev, return 0;
>  }
> 
> +static inline int get_aead_subtype(struct crypto_aead *aead)
> +{
> +	struct aead_alg *alg = crypto_aead_alg(aead);
> +	struct chcr_alg_template *chcr_crypto_alg =
> +		container_of(alg, struct chcr_alg_template, alg.aead);
> +	return chcr_crypto_alg->type & CRYPTO_ALG_SUB_TYPE_MASK;
> +}
> +
>  static inline int get_cryptoalg_subtype(struct crypto_tfm *tfm)
>  {
>  	struct crypto_alg *alg = tfm->__crt_alg;
> @@ -447,7 +517,8 @@ static inline void create_wreq(struct chcr_context *ctx,
> struct chcr_wr *chcr_req,
>  			       void *req, struct sk_buff *skb,
>  			       int kctx_len, int hash_sz,
> -			       unsigned int phys_dsgl)
> +			       int is_iv,
> +			       unsigned int sc_len)
>  {
>  	struct uld_ctx *u_ctx = ULD_CTX(ctx);
>  	int iv_loc = IV_DSGL;
> @@ -472,7 +543,7 @@ static inline void create_wreq(struct chcr_context *ctx,
> chcr_req->wreq.cookie = cpu_to_be64((uintptr_t)req);
>  	chcr_req->wreq.rx_chid_to_rx_q_id =
>  		FILL_WR_RX_Q_ID(ctx->dev->tx_channel_id, qid,
> -				(hash_sz) ? IV_NOP : iv_loc);
> +				is_iv ? iv_loc : IV_NOP);
> 
>  	chcr_req->ulptx.cmd_dest = FILL_ULPTX_CMD_DEST(ctx->dev->tx_channel_id);
>  	chcr_req->ulptx.len = htonl((DIV_ROUND_UP((calc_tx_flits_ofld(skb) * 8),
> @@ -481,10 +552,7 @@ static inline void create_wreq(struct chcr_context
> *ctx, chcr_req->sc_imm.cmd_more = FILL_CMD_MORE(immdatalen);
>  	chcr_req->sc_imm.len = cpu_to_be32(sizeof(struct cpl_tx_sec_pdu) +
>  				   sizeof(chcr_req->key_ctx) +
> -				   kctx_len +
> -				  ((hash_sz) ? DUMMY_BYTES :
> -				  (sizeof(struct cpl_rx_phys_dsgl) +
> -				   phys_dsgl)) + immdatalen);
> +				   kctx_len + sc_len + immdatalen);
>  }
> 
>  /**
> @@ -582,7 +650,8 @@ static struct sk_buff
>  	memcpy(reqctx->iv, req->info, ivsize);
>  	write_buffer_to_skb(skb, &frags, reqctx->iv, ivsize);
>  	write_sg_to_skb(skb, &frags, req->src, req->nbytes);
> -	create_wreq(ctx, chcr_req, req, skb, kctx_len, 0, phys_dsgl);
> +	create_wreq(ctx, chcr_req, req, skb, kctx_len, 0, 1,
> +			sizeof(struct cpl_rx_phys_dsgl) + phys_dsgl);
>  	reqctx->skb = skb;
>  	skb_get(skb);
>  	return skb;
> @@ -706,11 +775,11 @@ static int chcr_device_init(struct chcr_context *ctx)
>  		}
>  		u_ctx = ULD_CTX(ctx);
>  		rxq_perchan = u_ctx->lldi.nrxq / u_ctx->lldi.nchan;
> -		ctx->dev->tx_channel_id = 0;
>  		rxq_idx = ctx->dev->tx_channel_id * rxq_perchan;
>  		rxq_idx += id % rxq_perchan;
>  		spin_lock(&ctx->dev->lock_chcr_dev);
>  		ctx->tx_channel_id = rxq_idx;
> +		ctx->dev->tx_channel_id = !ctx->dev->tx_channel_id;
>  		spin_unlock(&ctx->dev->lock_chcr_dev);
>  	}
>  out:
> @@ -769,7 +838,7 @@ static inline void chcr_free_shash(struct crypto_shash
> *base_hash) *	@req - Cipher req base
>   */
>  static struct sk_buff *create_hash_wr(struct ahash_request *req,
> -					    struct hash_wr_param *param)
> +				      struct hash_wr_param *param)
>  {
>  	struct chcr_ahash_req_ctx *req_ctx = ahash_request_ctx(req);
>  	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
> @@ -840,8 +909,8 @@ static struct sk_buff *create_hash_wr(struct
> ahash_request *req, if (param->sg_len != 0)
>  		write_sg_to_skb(skb, &frags, req->src, param->sg_len);
> 
> -	create_wreq(ctx, chcr_req, req, skb, kctx_len, hash_size_in_response,
> -		    0);
> +	create_wreq(ctx, chcr_req, req, skb, kctx_len, hash_size_in_response, 0,
> +			DUMMY_BYTES);
>  	req_ctx->skb = skb;
>  	skb_get(skb);
>  	return skb;
> @@ -1249,6 +1318,1149 @@ static void chcr_hmac_cra_exit(struct crypto_tfm
> *tfm) }
>  }
> 
> +static int chcr_copy_assoc(struct aead_request *req,
> +				struct chcr_aead_ctx *ctx)
> +{
> +	SKCIPHER_REQUEST_ON_STACK(skreq, ctx->null);
> +
> +	skcipher_request_set_tfm(skreq, ctx->null);
> +	skcipher_request_set_callback(skreq, aead_request_flags(req),
> +			NULL, NULL);
> +	skcipher_request_set_crypt(skreq, req->src, req->dst, req->assoclen,
> +			NULL);
> +
> +	return crypto_skcipher_encrypt(skreq);
> +}
> +
> +static unsigned char get_hmac(unsigned int authsize)
> +{
> +	switch (authsize) {
> +	case ICV_8:
> +		return CHCR_SCMD_HMAC_CTRL_PL1;
> +	case ICV_10:
> +		return CHCR_SCMD_HMAC_CTRL_TRUNC_RFC4366;
> +	case ICV_12:
> +		return CHCR_SCMD_HMAC_CTRL_IPSEC_96BIT;
> +	}
> +	return CHCR_SCMD_HMAC_CTRL_NO_TRUNC;
> +}
> +
> +
> +static struct sk_buff *create_authenc_wr(struct aead_request *req,
> +					 unsigned short qid,
> +					 int size,
> +					 unsigned short op_type)
> +{
> +	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
> +	struct chcr_context *ctx = crypto_aead_ctx(tfm);
> +	struct uld_ctx *u_ctx = ULD_CTX(ctx);
> +	struct chcr_aead_ctx *aeadctx = AEAD_CTX(ctx);
> +	struct chcr_authenc_ctx *actx = AUTHENC_CTX(aeadctx);
> +	struct chcr_aead_reqctx *reqctx = aead_request_ctx(req);
> +	struct sk_buff *skb = NULL;
> +	struct chcr_wr *chcr_req;
> +	struct cpl_rx_phys_dsgl *phys_cpl;
> +	struct phys_sge_parm sg_param;
> +	struct scatterlist *src, *dst;
> +	struct scatterlist src_sg[2], dst_sg[2];
> +	unsigned int frags = 0, transhdr_len;
> +	unsigned int ivsize = crypto_aead_ivsize(tfm), dst_size = 0;
> +	unsigned int   kctx_len = 0;
> +	unsigned short stop_offset = 0;
> +	unsigned int  assoclen = req->assoclen;
> +	unsigned int  authsize = crypto_aead_authsize(tfm);
> +	int err = 0;
> +	int null = 0;
> +	gfp_t flags = req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP ? GFP_KERNEL :
> +		GFP_ATOMIC;
> +
> +	if (aeadctx->enckey_len == 0 || (req->cryptlen <= 0))
> +		goto err;
> +	src = scatterwalk_ffwd(src_sg, req->src, req->assoclen);
> +	dst = src;
> +	if (req->src != req->dst) {
> +		err = chcr_copy_assoc(req, aeadctx);
> +		if (err)
> +			return ERR_PTR(err);
> +		dst = scatterwalk_ffwd(dst_sg, req->dst, req->assoclen);
> +	}
> +	if (get_aead_subtype(tfm) == CRYPTO_ALG_SUB_TYPE_AEAD_NULL) {
> +		null = 1;
> +		assoclen = 0;
> +	}
> +	reqctx->dst_nents = sg_nents_for_len(dst, req->cryptlen +
> +					     (op_type ? -authsize : authsize));
> +	if (reqctx->dst_nents <= 0) {
> +		pr_err("AUTHENC:Invalid Destination sg entries\n");
> +		goto err;
> +	}
> +	dst_size = get_space_for_phys_dsgl(reqctx->dst_nents);
> +	kctx_len = (ntohl(KEY_CONTEXT_CTX_LEN_V(aeadctx->key_ctx_hdr)) << 4)
> +		- sizeof(chcr_req->key_ctx);
> +	transhdr_len = CIPHER_TRANSHDR_SIZE(kctx_len, dst_size);
> +	skb = alloc_skb((transhdr_len + sizeof(struct sge_opaque_hdr)), flags);
> +	if (!skb)
> +		goto err;
> +
> +	/* LLD is going to write the sge hdr. */
> +	skb_reserve(skb, sizeof(struct sge_opaque_hdr));
> +
> +	/* Write WR */
> +	chcr_req = (struct chcr_wr *) __skb_put(skb, transhdr_len);
> +	memset(chcr_req, 0, transhdr_len);
> +
> +	stop_offset = (op_type == CHCR_ENCRYPT_OP) ? 0 : authsize;
> +
> +	/*
> +	 * Input order	is AAD,IV and Payload. where IV should be included as
> +	 * the part of authdata. All other fields should be filled according
> +	 * to the hardware spec
> +	 */
> +	chcr_req->sec_cpl.op_ivinsrtofst =
> +		FILL_SEC_CPL_OP_IVINSR(ctx->dev->tx_channel_id, 2,
> +				       (ivsize ? (assoclen + 1) : 0));
> +	chcr_req->sec_cpl.pldlen = htonl(assoclen + ivsize + req->cryptlen);
> +	chcr_req->sec_cpl.aadstart_cipherstop_hi = FILL_SEC_CPL_CIPHERSTOP_HI(
> +					assoclen ? 1 : 0, assoclen,
> +					assoclen + ivsize + 1,
> +					(stop_offset & 0x1F0) >> 4);
> +	chcr_req->sec_cpl.cipherstop_lo_authinsert = FILL_SEC_CPL_AUTHINSERT(
> +					stop_offset & 0xF,
> +					null ? 0 : assoclen + ivsize + 1,
> +					stop_offset, stop_offset);
> +	chcr_req->sec_cpl.seqno_numivs = FILL_SEC_CPL_SCMD0_SEQNO(op_type,
> +					(op_type == CHCR_ENCRYPT_OP) ? 1 : 0,
> +					CHCR_SCMD_CIPHER_MODE_AES_CBC,
> +					actx->auth_mode, aeadctx->hmac_ctrl,
> +					ivsize >> 1);
> +	chcr_req->sec_cpl.ivgen_hdrlen =  FILL_SEC_CPL_IVGEN_HDRLEN(0, 0, 1,
> +					 0, 1, dst_size);
> +
> +	chcr_req->key_ctx.ctx_hdr = aeadctx->key_ctx_hdr;
> +	if (op_type == CHCR_ENCRYPT_OP)
> +		memcpy(chcr_req->key_ctx.key, aeadctx->key,
> +		       aeadctx->enckey_len);
> +	else
> +		memcpy(chcr_req->key_ctx.key, actx->dec_rrkey,
> +		       aeadctx->enckey_len);
> +
> +	memcpy(chcr_req->key_ctx.key + (DIV_ROUND_UP(aeadctx->enckey_len, 16) <<
> +					4), actx->h_iopad, kctx_len -
> +				(DIV_ROUND_UP(aeadctx->enckey_len, 16) << 4));
> +
> +	phys_cpl = (struct cpl_rx_phys_dsgl *)((u8 *)(chcr_req + 1) + kctx_len);
> +	sg_param.nents = reqctx->dst_nents;
> +	sg_param.obsize = req->cryptlen + (op_type ? -authsize : authsize);

Just like above: is it ensured that we cannot have negative results here in 
case cryptlen is less than authsize?


Ciao
Stephan
