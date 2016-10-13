From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH 4/6] crypto: ccp - Add RSA support for a v5 ccp
Date: Thu, 13 Oct 2016 16:23:00 -0500
Message-ID: <8e8b29ee-c7ff-1069-05ff-b2815543d1e3@amd.com>
References: <20161013144542.19759.6924.stgit@taos>
 <20161013145319.19759.70911.stgit@taos>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
To: Gary R Hook <gary.hook@amd.com>, <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn3nam01on0082.outbound.protection.outlook.com ([104.47.33.82]:52757
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1756869AbcJMVYJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 13 Oct 2016 17:24:09 -0400
In-Reply-To: <20161013145319.19759.70911.stgit@taos>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 10/13/2016 09:53 AM, Gary R Hook wrote:
> Take into account device implementation differences for
> RSA.
> 
> Signed-off-by: Gary R Hook <gary.hook@amd.com>
> ---
>  drivers/crypto/ccp/ccp-crypto-rsa.c |   14 +++--
>  drivers/crypto/ccp/ccp-crypto.h     |    3 -
>  drivers/crypto/ccp/ccp-dev.h        |    2 -
>  drivers/crypto/ccp/ccp-ops.c        |   97 +++++++++++++++++++++++------------
>  4 files changed, 73 insertions(+), 43 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/ccp-crypto-rsa.c b/drivers/crypto/ccp/ccp-crypto-rsa.c
> index 7dab43b..94411de 100644
> --- a/drivers/crypto/ccp/ccp-crypto-rsa.c
> +++ b/drivers/crypto/ccp/ccp-crypto-rsa.c
> @@ -125,7 +125,7 @@ static void ccp_rsa_free_key_bufs(struct ccp_ctx *ctx)
>  }
>  
>  static int ccp_rsa_setkey(struct crypto_akcipher *tfm, const void *key,
> -			  unsigned int keylen, bool public)
> +			  unsigned int keylen, bool private)
>  {
>  	struct ccp_ctx *ctx = akcipher_tfm_ctx(tfm);
>  	struct rsa_key raw_key;
> @@ -139,10 +139,10 @@ static int ccp_rsa_setkey(struct crypto_akcipher *tfm, const void *key,
>  	memset(&raw_key, 0, sizeof(raw_key));
>  
>  	/* Code borrowed from crypto/rsa.c */
> -	if (public)
> -		ret = rsa_parse_pub_key(&raw_key, key, keylen);
> -	else
> +	if (private)
>  		ret = rsa_parse_priv_key(&raw_key, key, keylen);
> +	else
> +		ret = rsa_parse_pub_key(&raw_key, key, keylen);
>  	if (ret)
>  		goto e_ret;
>  
> @@ -169,7 +169,7 @@ static int ccp_rsa_setkey(struct crypto_akcipher *tfm, const void *key,
>  		goto e_nkey;
>  	sg_init_one(&ctx->u.rsa.n_sg, ctx->u.rsa.n_buf, ctx->u.rsa.n_len);
>  
> -	if (!public) {
> +	if (private) {
>  		ctx->u.rsa.pkey.d = mpi_read_raw_data(raw_key.d, raw_key.d_sz);
>  		if (!ctx->u.rsa.pkey.d)
>  			goto e_nkey;
> @@ -196,13 +196,13 @@ e_ret:
>  static int ccp_rsa_setprivkey(struct crypto_akcipher *tfm, const void *key,
>  			      unsigned int keylen)
>  {
> -	return ccp_rsa_setkey(tfm, key, keylen, false);
> +	return ccp_rsa_setkey(tfm, key, keylen, true);
>  }
>  
>  static int ccp_rsa_setpubkey(struct crypto_akcipher *tfm, const void *key,
>  			     unsigned int keylen)
>  {
> -	return ccp_rsa_setkey(tfm, key, keylen, true);
> +	return ccp_rsa_setkey(tfm, key, keylen, false);
>  }
>  
>  static int ccp_rsa_init_tfm(struct crypto_akcipher *tfm)
> diff --git a/drivers/crypto/ccp/ccp-crypto.h b/drivers/crypto/ccp/ccp-crypto.h
> index 4a1d206..c6cf318 100644
> --- a/drivers/crypto/ccp/ccp-crypto.h
> +++ b/drivers/crypto/ccp/ccp-crypto.h
> @@ -138,8 +138,7 @@ struct ccp_aes_cmac_exp_ctx {
>  	u8 buf[AES_BLOCK_SIZE];
>  };
>  
> -/*
> - * SHA-related defines
> +/* SHA-related defines

Shouldn't be part of this patch.

>   * These values must be large enough to accommodate any variant
>   */
>  #define MAX_SHA_CONTEXT_SIZE	SHA512_DIGEST_SIZE
> diff --git a/drivers/crypto/ccp/ccp-dev.h b/drivers/crypto/ccp/ccp-dev.h
> index 0d996fe..143f00f 100644
> --- a/drivers/crypto/ccp/ccp-dev.h
> +++ b/drivers/crypto/ccp/ccp-dev.h
> @@ -193,6 +193,7 @@
>  #define CCP_SHA_SB_COUNT		1
>  
>  #define CCP_RSA_MAX_WIDTH		4096
> +#define CCP5_RSA_MAX_WIDTH		16384
>  
>  #define CCP_PASSTHRU_BLOCKSIZE		256
>  #define CCP_PASSTHRU_MASKSIZE		32
> @@ -515,7 +516,6 @@ struct ccp_op {
>  		struct ccp_passthru_op passthru;
>  		struct ccp_ecc_op ecc;
>  	} u;
> -	struct ccp_mem key;

This should probably be part of a cleanup patch.

>  };
>  
>  static inline u32 ccp_addr_lo(struct ccp_dma_info *info)
> diff --git a/drivers/crypto/ccp/ccp-ops.c b/drivers/crypto/ccp/ccp-ops.c
> index 826782d..07b8dfb 100644
> --- a/drivers/crypto/ccp/ccp-ops.c
> +++ b/drivers/crypto/ccp/ccp-ops.c
> @@ -1283,49 +1283,72 @@ static int ccp_run_rsa_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
>  	int i = 0;
>  	int ret = 0;
>  
> -	if (rsa->key_size > CCP_RSA_MAX_WIDTH)
> -		return -EINVAL;
> +	if (cmd_q->ccp->vdata->version < CCP_VERSION(4, 0)) {
> +		if (rsa->key_size > CCP_RSA_MAX_WIDTH)
> +			return -EINVAL;
> +	} else {
> +		if (rsa->key_size > CCP5_RSA_MAX_WIDTH)
> +			return -EINVAL;
> +	}

Might be able to actually add the max supported key size to the
version data and simplify the check here.

>  
>  	if (!rsa->exp || !rsa->mod || !rsa->src || !rsa->dst)
>  		return -EINVAL;
>  
> -	/* The RSA modulus must precede the message being acted upon, so
> -	 * it must be copied to a DMA area where the message and the
> -	 * modulus can be concatenated.  Therefore the input buffer
> -	 * length required is twice the output buffer length (which
> -	 * must be a multiple of 256-bits).
> -	 */
> -	o_len = ((rsa->key_size + 255) / 256) * 32;
> -	i_len = o_len * 2;
> -
> -	sb_count = o_len / CCP_SB_BYTES;
> -
>  	memset(&op, 0, sizeof(op));
>  	op.cmd_q = cmd_q;
> -	op.jobid = ccp_gen_jobid(cmd_q->ccp);
> -	op.sb_key = cmd_q->ccp->vdata->perform->sballoc(cmd_q, sb_count);
> +	op.jobid = CCP_NEW_JOBID(cmd_q->ccp);
>  
> -	if (!op.sb_key)
> -		return -EIO;
> +	if (cmd_q->ccp->vdata->version < CCP_VERSION(4, 0)) {
> +		/* The RSA modulus must precede the message being acted upon, so
> +		 * it must be copied to a DMA area where the message and the
> +		 * modulus can be concatenated.  Therefore the input buffer
> +		 * length required is twice the output buffer length (which
> +		 * must be a multiple of 256-bits).
> +		 */
> +		sb_count = (rsa->key_size + CCP_SB_BYTES - 1) / CCP_SB_BYTES;
> +		o_len = sb_count * 32; /* bytes */
> +		i_len = o_len * 2; /* bytes */
> +
> +		op.sb_key = cmd_q->ccp->vdata->perform->sballoc(cmd_q,
> +								sb_count);
> +		if (!op.sb_key)
> +			return -EIO;
> +	} else {
> +		/* A version 5 device allows the key to be in memory */
> +		o_len = rsa->mod_len;
> +		i_len = o_len * 2; /* bytes */
> +		op.sb_key = cmd_q->sb_key;
> +	}
>  
> -	/* The RSA exponent may span multiple (32-byte) SB entries and must
> -	 * be in little endian format. Reverse copy each 32-byte chunk
> -	 * of the exponent (En chunk to E0 chunk, E(n-1) chunk to E1 chunk)
> -	 * and each byte within that chunk and do not perform any byte swap
> -	 * operations on the passthru operation.
> -	 */
>  	ret = ccp_init_dm_workarea(&exp, cmd_q, o_len, DMA_TO_DEVICE);
>  	if (ret)
>  		goto e_sb;
>  
> -	ret = ccp_reverse_set_dm_area(&exp, 0, rsa->exp, 0, rsa->exp_len);
> +	if (rsa->mode == CCP_RSA_ENCRYPT)
> +		ret = ccp_reverse_set_dm_area(&exp, 0, rsa->exp, 0,
> +					      rsa->exp_len);
> +	else
> +		ret = ccp_reverse_set_dm_area(&exp, 0, rsa->d_sg, 0,
> +					      rsa->d_len);

This goes with the comment in the previous patch where you just need to
pass in one of these - the one to be used in the operation.

>  	if (ret)
>  		goto e_exp;
> -	ret = ccp_copy_to_sb(cmd_q, &exp, op.jobid, op.sb_key,
> -			     CCP_PASSTHRU_BYTESWAP_NOOP);
> -	if (ret) {
> -		cmd->engine_error = cmd_q->cmd_error;
> -		goto e_exp;
> +
> +	if (cmd_q->ccp->vdata->version < CCP_VERSION(4, 0)) {
> +		/* The RSA exponent may span multiple (32-byte) KSB entries and
> +		 * must be in little endian format. Reverse copy each 32-byte
> +		 * chunk of the exponent (En chunk to E0 chunk, E(n-1) chunk to
> +		 * E1 chunk) and each byte within that chunk and do not perform
> +		 * any byte swap operations on the passthru operation.
> +		 */
> +		ret = ccp_copy_to_sb(cmd_q, &exp, op.jobid, op.sb_key,
> +				     CCP_PASSTHRU_BYTESWAP_NOOP);
> +		if (ret) {
> +			cmd->engine_error = cmd_q->cmd_error;
> +			goto e_exp;
> +		}
> +	} else {
> +		op.exp.u.dma.address = exp.dma.address;
> +		op.exp.u.dma.offset = 0;
>  	}
>  
>  	/* Concatenate the modulus and the message. Both the modulus and
> @@ -1345,7 +1368,7 @@ static int ccp_run_rsa_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
>  	src.address -= o_len;	/* Reset the address to original value */
>  
>  	/* Prepare the output area for the operation */
> -	ret = ccp_init_data(&dst, cmd_q, rsa->dst, rsa->mod_len,
> +	ret = ccp_init_data(&dst, cmd_q, rsa->dst, rsa->dst_len,
>  			    o_len, DMA_FROM_DEVICE);
>  	if (ret)
>  		goto e_src;
> @@ -1358,7 +1381,10 @@ static int ccp_run_rsa_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
>  	op.dst.u.dma.offset = 0;
>  	op.dst.u.dma.length = o_len;
>  
> -	op.u.rsa.mod_size = rsa->key_size;
> +	if (cmd_q->ccp->vdata->version < CCP_VERSION(4, 0))
> +		op.u.rsa.mod_size = rsa->key_size * 8; /* In bits */
> +	else
> +		op.u.rsa.mod_size = rsa->key_size;
>  	op.u.rsa.input_len = i_len;
>  
>  	ret = cmd_q->ccp->vdata->perform->rsa(&op);
> @@ -1366,8 +1392,12 @@ static int ccp_run_rsa_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
>  		cmd->engine_error = cmd_q->cmd_error;
>  		goto e_dst;
>  	}
> +	/* Return the length of the result, too */
> +	for (i = o_len; !dst.dm_wa.address[--i]; )
> +		;
> +	rsa->d_len = i + 1;

The output length will always be o_len in size.  If the crypto api
requires the removal of leading zeroes you should do that at the
ccp crypto api layer.

Thanks,
Tom

>  
> -	ccp_reverse_get_dm_area(&dst.dm_wa, 0, rsa->dst, 0, rsa->mod_len);
> +	ccp_reverse_get_dm_area(&dst.dm_wa, 0, rsa->dst, 0, rsa->d_len);
>  
>  e_dst:
>  	ccp_free_data(&dst, cmd_q);
> @@ -1379,7 +1409,8 @@ e_exp:
>  	ccp_dm_free(&exp);
>  
>  e_sb:
> -	cmd_q->ccp->vdata->perform->sbfree(cmd_q, op.sb_key, sb_count);
> +	if (cmd_q->ccp->vdata->version < CCP_VERSION(4, 0))
> +		cmd_q->ccp->vdata->perform->sbfree(cmd_q, op.sb_key, sb_count);
>  
>  	return ret;
>  }
> 
