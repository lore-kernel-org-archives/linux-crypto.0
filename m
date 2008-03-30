From: Stefan Hellermann <stefan@the2masters.de>
Subject: Re: [RFC] [crypto] padlock-aes loadkey ondemand
Date: Sun, 30 Mar 2008 21:03:18 +0200
Message-ID: <47EFE3F6.4060704@the2masters.de>
References: <20080328223333.GB24018@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp11.unit.tiscali.de ([213.205.33.47]:41034 "EHLO
	smtp11.unit.tiscali.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752103AbYC3TDg (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 30 Mar 2008 15:03:36 -0400
In-Reply-To: <20080328223333.GB24018@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Sebastian Siewior schrieb:
> Signed-off-by: Sebastian Siewior <sebastian@breakpoint.cc>
> ---
> Stefan, if you have some spare time could you please look if this patch
> improves padlock + xts performance somehow?

Hi,

I tested this patch with success, "512 bit key, 8192 byte blocks" is 29% faster!
Thanks for this work!

Tested-By: Stefan Hellermann

(Or what is the appropriate line here?)


Here's tcrypt mode=200 output for xts without this patch
testing speed of xts(aes) decryption
test 0 (256 bit key, 16 byte blocks): 1 operation in 947 cycles (16 bytes)
test 1 (256 bit key, 64 byte blocks): 1 operation in 1645 cycles (64 bytes)
test 2 (256 bit key, 256 byte blocks): 1 operation in 4393 cycles (256 bytes)
test 3 (256 bit key, 1024 byte blocks): 1 operation in 15385 cycles (1024 bytes)
test 4 (256 bit key, 8192 byte blocks): 1 operation in 118990 cycles (8192 bytes)
test 5 (384 bit key, 16 byte blocks): 1 operation in 962 cycles (16 bytes)
test 6 (384 bit key, 64 byte blocks): 1 operation in 1688 cycles (64 bytes)
test 7 (384 bit key, 256 byte blocks): 1 operation in 4532 cycles (256 bytes)
test 8 (384 bit key, 1024 byte blocks): 1 operation in 15908 cycles (1024 bytes)
test 9 (384 bit key, 8192 byte blocks): 1 operation in 123097 cycles (8192 bytes)
test 10 (512 bit key, 16 byte blocks): 1 operation in 974 cycles (16 bytes)
test 11 (512 bit key, 64 byte blocks): 1 operation in 1710 cycles (64 bytes)
test 12 (512 bit key, 256 byte blocks): 1 operation in 4664 cycles (256 bytes)
test 13 (512 bit key, 1024 byte blocks): 1 operation in 16424 cycles (1024 bytes)
test 14 (512 bit key, 8192 byte blocks): 1 operation in 127197 cycles (8192 bytes)

and here's the output with this patch:
testing speed of xts(aes) decryption
test 0 (256 bit key, 16 byte blocks): 1 operation in 952 cycles (16 bytes)
test 1 (256 bit key, 64 byte blocks): 1 operation in 1462 cycles (64 bytes)
test 2 (256 bit key, 256 byte blocks): 1 operation in 3454 cycles (256 bytes)
test 3 (256 bit key, 1024 byte blocks): 1 operation in 11422 cycles (1024 bytes)
test 4 (256 bit key, 8192 byte blocks): 1 operation in 86779 cycles (8192 bytes)
test 5 (384 bit key, 16 byte blocks): 1 operation in 967 cycles (16 bytes)
test 6 (384 bit key, 64 byte blocks): 1 operation in 1467 cycles (64 bytes)
test 7 (384 bit key, 256 byte blocks): 1 operation in 3473 cycles (256 bytes)
test 8 (384 bit key, 1024 byte blocks): 1 operation in 11441 cycles (1024 bytes)
test 9 (384 bit key, 8192 byte blocks): 1 operation in 86798 cycles (8192 bytes)
test 10 (512 bit key, 16 byte blocks): 1 operation in 979 cycles (16 bytes)
test 11 (512 bit key, 64 byte blocks): 1 operation in 1503 cycles (64 bytes)
test 12 (512 bit key, 256 byte blocks): 1 operation in 3605 cycles (256 bytes)
test 13 (512 bit key, 1024 byte blocks): 1 operation in 11957 cycles (1024 bytes)
test 14 (512 bit key, 8192 byte blocks): 1 operation in 90898 cycles (8192 bytes)

But it's far away from aes(cbc)
test 14 (256 bit key, 8192 byte blocks): 1 operation in 8912 cycles (8192 bytes)
... cbc is now only 10 times faster, not 14 times :)

Stefan

> 
>  drivers/crypto/padlock-aes.c |   35 +++++++++++++++++++++++++++++------
>  1 files changed, 29 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/crypto/padlock-aes.c b/drivers/crypto/padlock-aes.c
> index bb30eb9..1ebbe8c 100644
> --- a/drivers/crypto/padlock-aes.c
> +++ b/drivers/crypto/padlock-aes.c
> @@ -48,6 +48,8 @@ struct aes_ctx {
>  	u32 *D;
>  };
>  
> +static struct aes_ctx *last_key;
> +
>  /* Tells whether the ACE is capable to generate
>     the extended key for a given key_len. */
>  static inline int
> @@ -115,6 +117,7 @@ static int aes_set_key(struct crypto_tfm *tfm, const u8 *in_key,
>  	ctx->cword.encrypt.ksize = (key_len - 16) / 8;
>  	ctx->cword.decrypt.ksize = ctx->cword.encrypt.ksize;
>  
> +	last_key  = ctx;
>  	/* Don't generate extended keys if the hardware can do it. */
>  	if (aes_hw_extkey_available(key_len))
>  		return 0;
> @@ -205,14 +208,22 @@ static inline u8 *padlock_xcrypt_cbc(const u8 *input, u8 *output, void *key,
>  static void aes_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
>  {
>  	struct aes_ctx *ctx = aes_ctx(tfm);
> -	padlock_reset_key();
> +
> +	if (last_key != ctx) {
> +		last_key = ctx;
> +		padlock_reset_key();
> +	}
>  	aes_crypt(in, out, ctx->E, &ctx->cword.encrypt);
>  }
>  
>  static void aes_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
>  {
>  	struct aes_ctx *ctx = aes_ctx(tfm);
> -	padlock_reset_key();
> +
> +	if (last_key != ctx) {
> +		last_key = ctx;
> +		padlock_reset_key();
> +	}
>  	aes_crypt(in, out, ctx->D, &ctx->cword.decrypt);
>  }
>  
> @@ -245,7 +256,10 @@ static int ecb_aes_encrypt(struct blkcipher_desc *desc,
>  	struct blkcipher_walk walk;
>  	int err;
>  
> -	padlock_reset_key();
> +	if (last_key != ctx) {
> +		last_key = ctx;
> +		padlock_reset_key();
> +	}
>  
>  	blkcipher_walk_init(&walk, dst, src, nbytes);
>  	err = blkcipher_walk_virt(desc, &walk);
> @@ -269,7 +283,10 @@ static int ecb_aes_decrypt(struct blkcipher_desc *desc,
>  	struct blkcipher_walk walk;
>  	int err;
>  
> -	padlock_reset_key();
> +	if (last_key != ctx) {
> +		last_key = ctx;
> +		padlock_reset_key();
> +	}
>  
>  	blkcipher_walk_init(&walk, dst, src, nbytes);
>  	err = blkcipher_walk_virt(desc, &walk);
> @@ -315,7 +332,10 @@ static int cbc_aes_encrypt(struct blkcipher_desc *desc,
>  	struct blkcipher_walk walk;
>  	int err;
>  
> -	padlock_reset_key();
> +	if (last_key != ctx) {
> +		last_key = ctx;
> +		padlock_reset_key();
> +	}
>  
>  	blkcipher_walk_init(&walk, dst, src, nbytes);
>  	err = blkcipher_walk_virt(desc, &walk);
> @@ -341,7 +361,10 @@ static int cbc_aes_decrypt(struct blkcipher_desc *desc,
>  	struct blkcipher_walk walk;
>  	int err;
>  
> -	padlock_reset_key();
> +	if (last_key != ctx) {
> +		last_key = ctx;
> +		padlock_reset_key();
> +	}
>  
>  	blkcipher_walk_init(&walk, dst, src, nbytes);
>  	err = blkcipher_walk_virt(desc, &walk);
