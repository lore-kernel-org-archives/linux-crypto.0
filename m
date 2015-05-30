From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH 10/10] crypto: aesni - Convert rfc4106 to new AEAD interface
Date: Sat, 30 May 2015 13:17:43 +0200
Message-ID: <3814289.kexBYB1orb@tachyon.chronox.de>
References: <20150528140311.GA8423@gondor.apana.org.au> <E1YxyTe-0002Le-1o@gondolin.me.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Adrian Hoban <adrian.hoban@intel.com>,
	Tadeusz Struk <tadeusz.struk@intel.com>,
	Timothy McCaffrey <timothy.mccaffrey@unisys.com>,
	Tim Chen <tim.c.chen@linux.intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:58371 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750871AbbE3LRw (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sat, 30 May 2015 07:17:52 -0400
In-Reply-To: <E1YxyTe-0002Le-1o@gondolin.me.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 28. Mai 2015, 22:08:06 schrieb Herbert Xu:

Hi Herbert,

> This patch converts the low-level __gcm-aes-aesni algorithm to
> the new AEAD interface.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> ---
> 
>  arch/x86/crypto/aesni-intel_glue.c |  246
> +++++++++++-------------------------- 1 file changed, 79 insertions(+), 167
> deletions(-)
> 
> diff --git a/arch/x86/crypto/aesni-intel_glue.c
> b/arch/x86/crypto/aesni-intel_glue.c index 5660a18..c5fa1e6 100644
> --- a/arch/x86/crypto/aesni-intel_glue.c
> +++ b/arch/x86/crypto/aesni-intel_glue.c
> @@ -44,13 +44,18 @@
>  #endif
> 
> 
> +#define AESNI_ALIGN	16
> +#define AES_BLOCK_MASK	(~(AES_BLOCK_SIZE - 1))
> +#define RFC4106_HASH_SUBKEY_SIZE 16
> +
>  /* This data is stored at the end of the crypto_tfm struct.
>   * It's a type of per "session" data storage location.
>   * This needs to be 16 byte aligned.
>   */
>  struct aesni_rfc4106_gcm_ctx {
> -	u8 hash_subkey[16];
> -	struct crypto_aes_ctx aes_key_expanded;
> +	u8 hash_subkey[16] __attribute__ ((__aligned__(AESNI_ALIGN)));
> +	struct crypto_aes_ctx aes_key_expanded
> +		__attribute__ ((__aligned__(AESNI_ALIGN)));
>  	u8 nonce[4];
>  };
> 
> @@ -65,10 +70,6 @@ struct aesni_hash_subkey_req_data {
>  	struct scatterlist sg;
>  };
> 
> -#define AESNI_ALIGN	(16)
> -#define AES_BLOCK_MASK	(~(AES_BLOCK_SIZE-1))
> -#define RFC4106_HASH_SUBKEY_SIZE 16
> -
>  struct aesni_lrw_ctx {
>  	struct lrw_table_ctx lrw_table;
>  	u8 raw_aes_ctx[sizeof(struct crypto_aes_ctx) + AESNI_ALIGN - 1];
> @@ -282,10 +283,11 @@ static void (*aesni_gcm_dec_tfm)(void *ctx, u8 *out,
>  static inline struct
>  aesni_rfc4106_gcm_ctx *aesni_rfc4106_gcm_ctx_get(struct crypto_aead *tfm)
>  {
> -	return
> -		(struct aesni_rfc4106_gcm_ctx *)
> -		PTR_ALIGN((u8 *)
> -		crypto_tfm_ctx(crypto_aead_tfm(tfm)), AESNI_ALIGN);
> +	unsigned long align = AESNI_ALIGN;
> +
> +	if (align <= crypto_tfm_ctx_alignment())
> +		align = 1;
> +	return PTR_ALIGN(crypto_aead_ctx(tfm), align);
>  }
>  #endif
> 
> @@ -838,8 +840,6 @@ rfc4106_set_hash_subkey(u8 *hash_subkey, const u8 *key,
> unsigned int key_len) if (IS_ERR(ctr_tfm))
>  		return PTR_ERR(ctr_tfm);
> 
> -	crypto_ablkcipher_clear_flags(ctr_tfm, ~0);
> -
>  	ret = crypto_ablkcipher_setkey(ctr_tfm, key, key_len);
>  	if (ret)
>  		goto out_free_ablkcipher;
> @@ -888,56 +888,20 @@ out_free_ablkcipher:
>  static int common_rfc4106_set_key(struct crypto_aead *aead, const u8 *key,
>  				  unsigned int key_len)
>  {
> -	int ret = 0;
> -	struct crypto_tfm *tfm = crypto_aead_tfm(aead);
>  	struct aesni_rfc4106_gcm_ctx *ctx = aesni_rfc4106_gcm_ctx_get(aead);
> -	u8 *new_key_align, *new_key_mem = NULL;
> 
>  	if (key_len < 4) {
> -		crypto_tfm_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
> +		crypto_aead_set_flags(aead, CRYPTO_TFM_RES_BAD_KEY_LEN);
>  		return -EINVAL;
>  	}
>  	/*Account for 4 byte nonce at the end.*/
>  	key_len -= 4;
> -	if (key_len != AES_KEYSIZE_128 && key_len != AES_KEYSIZE_192 &&
> -	    key_len != AES_KEYSIZE_256) {
> -		crypto_tfm_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
> -		return -EINVAL;
> -	}
> 
>  	memcpy(ctx->nonce, key + key_len, sizeof(ctx->nonce));
> -	/*This must be on a 16 byte boundary!*/
> -	if ((unsigned long)(&(ctx->aes_key_expanded.key_enc[0])) % 
AESNI_ALIGN)
> -		return -EINVAL;
> -
> -	if ((unsigned long)key % AESNI_ALIGN) {
> -		/*key is not aligned: use an auxuliar aligned pointer*/
> -		new_key_mem = kmalloc(key_len+AESNI_ALIGN, GFP_KERNEL);
> -		if (!new_key_mem)
> -			return -ENOMEM;
> -
> -		new_key_align = PTR_ALIGN(new_key_mem, AESNI_ALIGN);
> -		memcpy(new_key_align, key, key_len);
> -		key = new_key_align;
> -	}
> 
> -	if (!irq_fpu_usable())
> -		ret = crypto_aes_expand_key(&(ctx->aes_key_expanded),
> -		key, key_len);
> -	else {
> -		kernel_fpu_begin();
> -		ret = aesni_set_key(&(ctx->aes_key_expanded), key, key_len);
> -		kernel_fpu_end();
> -	}
> -	/*This must be on a 16 byte boundary!*/
> -	if ((unsigned long)(&(ctx->hash_subkey[0])) % AESNI_ALIGN) {
> -		ret = -EINVAL;
> -		goto exit;
> -	}
> -	ret = rfc4106_set_hash_subkey(ctx->hash_subkey, key, key_len);
> -exit:
> -	kfree(new_key_mem);
> -	return ret;
> +	return aes_set_key_common(crypto_aead_tfm(aead),
> +				  &ctx->aes_key_expanded, key, key_len) ?:
> +	       rfc4106_set_hash_subkey(ctx->hash_subkey, key, key_len);
>  }
> 
>  static int rfc4106_set_key(struct crypto_aead *parent, const u8 *key,
> @@ -960,7 +924,7 @@ static int common_rfc4106_set_authsize(struct
> crypto_aead *aead, default:
>  		return -EINVAL;
>  	}
> -	crypto_aead_crt(aead)->authsize = authsize;
> +
>  	return 0;
>  }
> 
> @@ -975,20 +939,17 @@ static int rfc4106_set_authsize(struct crypto_aead
> *parent, return crypto_aead_setauthsize(&cryptd_tfm->base, authsize);
>  }
> 
> -static int __driver_rfc4106_encrypt(struct aead_request *req)
> +static int helper_rfc4106_encrypt(struct aead_request *req)
>  {
>  	u8 one_entry_in_sg = 0;
>  	u8 *src, *dst, *assoc;
>  	__be32 counter = cpu_to_be32(1);
>  	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
>  	struct aesni_rfc4106_gcm_ctx *ctx = aesni_rfc4106_gcm_ctx_get(tfm);
> -	u32 key_len = ctx->aes_key_expanded.key_length;
>  	void *aes_ctx = &(ctx->aes_key_expanded);
>  	unsigned long auth_tag_len = crypto_aead_authsize(tfm);
> -	u8 iv_tab[16+AESNI_ALIGN];
> -	u8* iv = (u8 *) PTR_ALIGN((u8 *)iv_tab, AESNI_ALIGN);
> +	u8 iv[16] __attribute__ ((__aligned__(AESNI_ALIGN)));
>  	struct scatter_walk src_sg_walk;
> -	struct scatter_walk assoc_sg_walk;
>  	struct scatter_walk dst_sg_walk;
>  	unsigned int i;
> 
> @@ -997,12 +958,6 @@ static int __driver_rfc4106_encrypt(struct aead_request
> *req) /* to 8 or 12 bytes */
>  	if (unlikely(req->assoclen != 8 && req->assoclen != 12))
>  		return -EINVAL;
> -	if (unlikely(auth_tag_len != 8 && auth_tag_len != 12 && auth_tag_len 
!=
> 16)) -	        return -EINVAL;
> -	if (unlikely(key_len != AES_KEYSIZE_128 &&
> -	             key_len != AES_KEYSIZE_192 &&
> -	             key_len != AES_KEYSIZE_256))
> -	        return -EINVAL;
> 
>  	/* IV below built */
>  	for (i = 0; i < 4; i++)
> @@ -1011,55 +966,55 @@ static int __driver_rfc4106_encrypt(struct
> aead_request *req) *(iv+4+i) = req->iv[i];
>  	*((__be32 *)(iv+12)) = counter;
> 
> -	if ((sg_is_last(req->src)) && (sg_is_last(req->assoc))) {
> +	if (sg_is_last(req->src) &&
> +	    req->src->offset + req->src->length <= PAGE_SIZE &&
> +	    sg_is_last(req->dst) &&
> +	    req->dst->offset + req->dst->length <= PAGE_SIZE) {
>  		one_entry_in_sg = 1;
>  		scatterwalk_start(&src_sg_walk, req->src);
> -		scatterwalk_start(&assoc_sg_walk, req->assoc);
> -		src = scatterwalk_map(&src_sg_walk);
> -		assoc = scatterwalk_map(&assoc_sg_walk);
> +		assoc = scatterwalk_map(&src_sg_walk);
> +		src = assoc + req->assoclen;
>  		dst = src;
>  		if (unlikely(req->src != req->dst)) {
>  			scatterwalk_start(&dst_sg_walk, req->dst);
> -			dst = scatterwalk_map(&dst_sg_walk);
> +			dst = scatterwalk_map(&dst_sg_walk) + req->assoclen;
>  		}
> -
>  	} else {
>  		/* Allocate memory for src, dst, assoc */
> -		src = kmalloc(req->cryptlen + auth_tag_len + req->assoclen,
> +		assoc = kmalloc(req->cryptlen + auth_tag_len + req->assoclen,
>  			GFP_ATOMIC);
> -		if (unlikely(!src))
> +		if (unlikely(!assoc))
>  			return -ENOMEM;
> -		assoc = (src + req->cryptlen + auth_tag_len);
> -		scatterwalk_map_and_copy(src, req->src, 0, req->cryptlen, 0);
> -		scatterwalk_map_and_copy(assoc, req->assoc, 0,
> -					req->assoclen, 0);
> +		scatterwalk_map_and_copy(assoc, req->src, 0,
> +					 req->assoclen + req->cryptlen, 0);
> +		src = assoc + req->assoclen;
>  		dst = src;
>  	}
> 
> +	kernel_fpu_begin();
>  	aesni_gcm_enc_tfm(aes_ctx, dst, src, (unsigned long)req->cryptlen, iv,
>  		ctx->hash_subkey, assoc, (unsigned long)req->assoclen, dst
>  		+ ((unsigned long)req->cryptlen), auth_tag_len);
> +	kernel_fpu_end();
> 
>  	/* The authTag (aka the Integrity Check Value) needs to be written
>  	 * back to the packet. */
>  	if (one_entry_in_sg) {
>  		if (unlikely(req->src != req->dst)) {
> -			scatterwalk_unmap(dst);
> -			scatterwalk_done(&dst_sg_walk, 0, 0);
> +			scatterwalk_unmap(dst - req->assoclen);
> +			scatterwalk_done(&dst_sg_walk, 1, 0);
>  		}
> -		scatterwalk_unmap(src);
>  		scatterwalk_unmap(assoc);
> -		scatterwalk_done(&src_sg_walk, 0, 0);
> -		scatterwalk_done(&assoc_sg_walk, 0, 0);
> +		scatterwalk_done(&src_sg_walk, req->src == req->dst, 0);
>  	} else {
> -		scatterwalk_map_and_copy(dst, req->dst, 0,
> -			req->cryptlen + auth_tag_len, 1);
> -		kfree(src);
> +		scatterwalk_map_and_copy(dst, req->dst, req->assoclen,
> +					 req->cryptlen + auth_tag_len, 1);
> +		kfree(assoc);
>  	}
>  	return 0;
>  }
> 
> -static int __driver_rfc4106_decrypt(struct aead_request *req)
> +static int helper_rfc4106_decrypt(struct aead_request *req)
>  {
>  	u8 one_entry_in_sg = 0;
>  	u8 *src, *dst, *assoc;
> @@ -1068,26 +1023,16 @@ static int __driver_rfc4106_decrypt(struct
> aead_request *req) int retval = 0;
>  	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
>  	struct aesni_rfc4106_gcm_ctx *ctx = aesni_rfc4106_gcm_ctx_get(tfm);
> -	u32 key_len = ctx->aes_key_expanded.key_length;
>  	void *aes_ctx = &(ctx->aes_key_expanded);
>  	unsigned long auth_tag_len = crypto_aead_authsize(tfm);
> -	u8 iv_and_authTag[32+AESNI_ALIGN];
> -	u8 *iv = (u8 *) PTR_ALIGN((u8 *)iv_and_authTag, AESNI_ALIGN);
> -	u8 *authTag = iv + 16;
> +	u8 iv[16] __attribute__ ((__aligned__(AESNI_ALIGN)));
> +	u8 authTag[16];
>  	struct scatter_walk src_sg_walk;
> -	struct scatter_walk assoc_sg_walk;
>  	struct scatter_walk dst_sg_walk;
>  	unsigned int i;
> 
> -	if (unlikely((req->cryptlen < auth_tag_len) ||
> -		(req->assoclen != 8 && req->assoclen != 12)))
> +	if (unlikely(req->assoclen != 8 && req->assoclen != 12))
>  		return -EINVAL;
> -	if (unlikely(auth_tag_len != 8 && auth_tag_len != 12 && auth_tag_len 
!=
> 16)) -	        return -EINVAL;
> -	if (unlikely(key_len != AES_KEYSIZE_128 &&
> -	             key_len != AES_KEYSIZE_192 &&
> -	             key_len != AES_KEYSIZE_256))
> -	        return -EINVAL;
> 
>  	/* Assuming we are supporting rfc4106 64-bit extended */
>  	/* sequence numbers We need to have the AAD length */
> @@ -1101,33 +1046,36 @@ static int __driver_rfc4106_decrypt(struct
> aead_request *req) *(iv+4+i) = req->iv[i];
>  	*((__be32 *)(iv+12)) = counter;
> 
> -	if ((sg_is_last(req->src)) && (sg_is_last(req->assoc))) {
> +	if (sg_is_last(req->src) &&
> +	    req->src->offset + req->src->length <= PAGE_SIZE &&
> +	    sg_is_last(req->dst) &&
> +	    req->dst->offset + req->dst->length <= PAGE_SIZE) {
>  		one_entry_in_sg = 1;
>  		scatterwalk_start(&src_sg_walk, req->src);
> -		scatterwalk_start(&assoc_sg_walk, req->assoc);
> -		src = scatterwalk_map(&src_sg_walk);
> -		assoc = scatterwalk_map(&assoc_sg_walk);
> +		assoc = scatterwalk_map(&src_sg_walk);
> +		src = assoc + req->assoclen;
>  		dst = src;
>  		if (unlikely(req->src != req->dst)) {
>  			scatterwalk_start(&dst_sg_walk, req->dst);
> -			dst = scatterwalk_map(&dst_sg_walk);
> +			dst = scatterwalk_map(&dst_sg_walk) + req->assoclen;
>  		}
> 
>  	} else {
>  		/* Allocate memory for src, dst, assoc */
> -		src = kmalloc(req->cryptlen + req->assoclen, GFP_ATOMIC);
> -		if (!src)
> +		assoc = kmalloc(req->cryptlen + req->assoclen, GFP_ATOMIC);
> +		if (!assoc)
>  			return -ENOMEM;
> -		assoc = (src + req->cryptlen);
> -		scatterwalk_map_and_copy(src, req->src, 0, req->cryptlen, 0);
> -		scatterwalk_map_and_copy(assoc, req->assoc, 0,
> -			req->assoclen, 0);
> +		scatterwalk_map_and_copy(assoc, req->src, 0,
> +					 req->assoclen + req->cryptlen, 0);
> +		src = assoc + req->assoclen;
>  		dst = src;
>  	}
> 
> +	kernel_fpu_begin();
>  	aesni_gcm_dec_tfm(aes_ctx, dst, src, tempCipherLen, iv,
>  		ctx->hash_subkey, assoc, (unsigned long)req->assoclen,
>  		authTag, auth_tag_len);
> +	kernel_fpu_end();
> 
>  	/* Compare generated tag with passed in tag. */
>  	retval = crypto_memneq(src + tempCipherLen, authTag, auth_tag_len) ?
> @@ -1135,16 +1083,15 @@ static int __driver_rfc4106_decrypt(struct
> aead_request *req)
> 
>  	if (one_entry_in_sg) {
>  		if (unlikely(req->src != req->dst)) {
> -			scatterwalk_unmap(dst);
> -			scatterwalk_done(&dst_sg_walk, 0, 0);
> +			scatterwalk_unmap(dst - req->assoclen);
> +			scatterwalk_done(&dst_sg_walk, 1, 0);

The bug mentioned for patch 8 happens exactly at this spot.

>  		}
> -		scatterwalk_unmap(src);
>  		scatterwalk_unmap(assoc);
> -		scatterwalk_done(&src_sg_walk, 0, 0);
> -		scatterwalk_done(&assoc_sg_walk, 0, 0);
> +		scatterwalk_done(&src_sg_walk, req->src == req->dst, 0);
>  	} else {
> -		scatterwalk_map_and_copy(dst, req->dst, 0, tempCipherLen, 1);
> -		kfree(src);
> +		scatterwalk_map_and_copy(dst, req->dst, req->assoclen,
> +					 tempCipherLen, 1);
> +		kfree(assoc);
>  	}
>  	return retval;
>  }
> @@ -1188,36 +1135,6 @@ static int rfc4106_decrypt(struct aead_request *req)
> 
>  	return crypto_aead_decrypt(subreq);
>  }
> -
> -static int helper_rfc4106_encrypt(struct aead_request *req)
> -{
> -	int ret;
> -
> -	if (unlikely(!irq_fpu_usable())) {
> -		WARN_ONCE(1, "__gcm-aes-aesni alg used in invalid context");
> -		ret = -EINVAL;
> -	} else {
> -		kernel_fpu_begin();
> -		ret = __driver_rfc4106_encrypt(req);
> -		kernel_fpu_end();
> -	}
> -	return ret;
> -}
> -
> -static int helper_rfc4106_decrypt(struct aead_request *req)
> -{
> -	int ret;
> -
> -	if (unlikely(!irq_fpu_usable())) {
> -		WARN_ONCE(1, "__gcm-aes-aesni alg used in invalid context");
> -		ret = -EINVAL;
> -	} else {
> -		kernel_fpu_begin();
> -		ret = __driver_rfc4106_decrypt(req);
> -		kernel_fpu_end();
> -	}
> -	return ret;
> -}
>  #endif
> 
>  static struct crypto_alg aesni_algs[] = { {
> @@ -1389,27 +1306,6 @@ static struct crypto_alg aesni_algs[] = { {
>  			.geniv		= "chainiv",
>  		},
>  	},
> -}, {
> -	.cra_name		= "__gcm-aes-aesni",
> -	.cra_driver_name	= "__driver-gcm-aes-aesni",
> -	.cra_priority		= 0,
> -	.cra_flags		= CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_INTERNAL,
> -	.cra_blocksize		= 1,
> -	.cra_ctxsize		= sizeof(struct aesni_rfc4106_gcm_ctx) +
> -				  AESNI_ALIGN,
> -	.cra_alignmask		= 0,
> -	.cra_type		= &crypto_aead_type,
> -	.cra_module		= THIS_MODULE,
> -	.cra_u = {
> -		.aead = {
> -			.setkey		= common_rfc4106_set_key,
> -			.setauthsize	= common_rfc4106_set_authsize,
> -			.encrypt	= helper_rfc4106_encrypt,
> -			.decrypt	= helper_rfc4106_decrypt,
> -			.ivsize		= 8,
> -			.maxauthsize	= 16,
> -		},
> -	},
>  #endif
>  #if IS_ENABLED(CONFIG_CRYPTO_PCBC)
>  }, {
> @@ -1526,6 +1422,22 @@ static struct crypto_alg aesni_algs[] = { {
> 
>  #ifdef CONFIG_X86_64
>  static struct aead_alg aesni_aead_algs[] = { {
> +	.setkey			= common_rfc4106_set_key,
> +	.setauthsize		= common_rfc4106_set_authsize,
> +	.encrypt		= helper_rfc4106_encrypt,
> +	.decrypt		= helper_rfc4106_decrypt,
> +	.ivsize			= 8,
> +	.maxauthsize		= 16,
> +	.base = {
> +		.cra_name		= "__gcm-aes-aesni",
> +		.cra_driver_name	= "__driver-gcm-aes-aesni",
> +		.cra_flags		= CRYPTO_ALG_INTERNAL,
> +		.cra_blocksize		= 1,
> +		.cra_ctxsize		= sizeof(struct 
aesni_rfc4106_gcm_ctx),
> +		.cra_alignmask		= AESNI_ALIGN - 1,
> +		.cra_module		= THIS_MODULE,
> +	},
> +}, {
>  	.init			= rfc4106_init,
>  	.exit			= rfc4106_exit,
>  	.setkey			= rfc4106_set_key,
> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Ciao
Stephan
