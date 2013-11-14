From: Jan Glauber <jan.glauber@gmail.com>
Subject: Re: crypto: s390 - Fix aes-cbc IV corruption
Date: Thu, 14 Nov 2013 17:10:20 +0100
Message-ID: <20131114161020.GA19229@hal>
References: <20131031032547.GA16528@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Jan Glauber <jang@linux.vnet.ibm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:64021 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752880Ab3KNQKY (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 14 Nov 2013 11:10:24 -0500
Received: by mail-wg0-f42.google.com with SMTP id k14so918711wgh.1
        for <linux-crypto@vger.kernel.org>; Thu, 14 Nov 2013 08:10:23 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20131031032547.GA16528@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Oct 31, 2013 at 11:25:47AM +0800, Herbert Xu wrote:
> Hi:

Hi Herbert,

just seen this as my old email address is dead... Your patch looks
fine as it keeps the iv and the key together as required by the instruction.

However, I'm curious how this could be racy with threads. The encryption must
be serialized because of the chaining. The decryption could in theory happen
in parallel, but is this the case here?

--Jan

> The cbc-aes-s390 algorithm incorrectly places the IV in the tfm
> data structure.  As the tfm is shared between multiple threads,
> this introduces a possibility of data corruption.
> 
> This patch fixes this by moving the parameter block containing
> the IV and key onto the stack (the block is 48 bytes long).
> 
> The same bug exists elsewhere in the s390 crypto system and they
> will be fixed in subsequent patches.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> 
> diff --git a/arch/s390/crypto/aes_s390.c b/arch/s390/crypto/aes_s390.c
> index b4dbade..2e4b5be 100644
> --- a/arch/s390/crypto/aes_s390.c
> +++ b/arch/s390/crypto/aes_s390.c
> @@ -35,7 +35,6 @@ static u8 *ctrblk;
>  static char keylen_flag;
>  
>  struct s390_aes_ctx {
> -	u8 iv[AES_BLOCK_SIZE];
>  	u8 key[AES_MAX_KEY_SIZE];
>  	long enc;
>  	long dec;
> @@ -441,30 +440,36 @@ static int cbc_aes_set_key(struct crypto_tfm *tfm, const u8 *in_key,
>  	return aes_set_key(tfm, in_key, key_len);
>  }
>  
> -static int cbc_aes_crypt(struct blkcipher_desc *desc, long func, void *param,
> +static int cbc_aes_crypt(struct blkcipher_desc *desc, long func,
>  			 struct blkcipher_walk *walk)
>  {
> +	struct s390_aes_ctx *sctx = crypto_blkcipher_ctx(desc->tfm);
>  	int ret = blkcipher_walk_virt(desc, walk);
>  	unsigned int nbytes = walk->nbytes;
> +	struct {
> +		u8 iv[AES_BLOCK_SIZE];
> +		u8 key[AES_MAX_KEY_SIZE];
> +	} param;
>  
>  	if (!nbytes)
>  		goto out;
>  
> -	memcpy(param, walk->iv, AES_BLOCK_SIZE);
> +	memcpy(param.iv, walk->iv, AES_BLOCK_SIZE);
> +	memcpy(param.key, sctx->key, sctx->key_len);
>  	do {
>  		/* only use complete blocks */
>  		unsigned int n = nbytes & ~(AES_BLOCK_SIZE - 1);
>  		u8 *out = walk->dst.virt.addr;
>  		u8 *in = walk->src.virt.addr;
>  
> -		ret = crypt_s390_kmc(func, param, out, in, n);
> +		ret = crypt_s390_kmc(func, &param, out, in, n);
>  		if (ret < 0 || ret != n)
>  			return -EIO;
>  
>  		nbytes &= AES_BLOCK_SIZE - 1;
>  		ret = blkcipher_walk_done(desc, walk, nbytes);
>  	} while ((nbytes = walk->nbytes));
> -	memcpy(walk->iv, param, AES_BLOCK_SIZE);
> +	memcpy(walk->iv, param.iv, AES_BLOCK_SIZE);
>  
>  out:
>  	return ret;
> @@ -481,7 +486,7 @@ static int cbc_aes_encrypt(struct blkcipher_desc *desc,
>  		return fallback_blk_enc(desc, dst, src, nbytes);
>  
>  	blkcipher_walk_init(&walk, dst, src, nbytes);
> -	return cbc_aes_crypt(desc, sctx->enc, sctx->iv, &walk);
> +	return cbc_aes_crypt(desc, sctx->enc, &walk);
>  }
>  
>  static int cbc_aes_decrypt(struct blkcipher_desc *desc,
> @@ -495,7 +500,7 @@ static int cbc_aes_decrypt(struct blkcipher_desc *desc,
>  		return fallback_blk_dec(desc, dst, src, nbytes);
>  
>  	blkcipher_walk_init(&walk, dst, src, nbytes);
> -	return cbc_aes_crypt(desc, sctx->dec, sctx->iv, &walk);
> +	return cbc_aes_crypt(desc, sctx->dec, &walk);
>  }
>  
>  static struct crypto_alg cbc_aes_alg = {
> 
> Cheers,
> -- 
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
