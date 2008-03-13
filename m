From: Stefan Hellermann <stefan@the2masters.de>
Subject: Re: [RFC] generic_aes: export generic setkey
Date: Thu, 13 Mar 2008 22:40:51 +0100
Message-ID: <47D99F63.3080707@the2masters.de>
References: <1203850864-16681-1-git-send-email-sebastian@breakpoint.cc> <1203850864-16681-2-git-send-email-sebastian@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
To: Sebastian Siewior <sebastian@breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp11.unit.tiscali.de ([213.205.33.47]:46822 "EHLO
	smtp11.unit.tiscali.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754073AbYCMVlt (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 13 Mar 2008 17:41:49 -0400
In-Reply-To: <1203850864-16681-2-git-send-email-sebastian@breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Sebastian Siewior schrieb:
> The key expansion routine could be get little more generic, become
> a kernel doc entry and then get exported.

I tested this and "[RFC] [crypto] padlock-AES, use generic setkey function" on a
padlock-enabled Via board, and did the following test:

Create, open, write to, read from and close a linux dm-crypt device with aes-cbc-essiv,
aes-lrw-benbi and aes-xts-plain.

Then I took a huge encrypted disk-image (encrypted without this patches), opened it with
cryptsetup-luks, booted the OS from the disc over iscsi, started a filesystem-check. The
check completed successful.

So I think this and the other patch are save.

> 
> Signed-off-by: Sebastian Siewior <sebastian@breakpoint.cc>

Tested-by: Stefan Hellermann <stefan@the2masters.de>

> ---
>  crypto/aes_generic.c |   56 +++++++++++++++++++++++++++++++++++++++++--------
>  include/crypto/aes.h |    8 +++++-
>  2 files changed, 53 insertions(+), 11 deletions(-)
> 
> diff --git a/crypto/aes_generic.c b/crypto/aes_generic.c
> index f33a99c..9322531 100644
> --- a/crypto/aes_generic.c
> +++ b/crypto/aes_generic.c
> @@ -229,18 +229,29 @@ static void __init gen_tabs(void)
>  	ctx->key_enc[8 * i + 15] = t;			\
>  } while (0)
>  
> -int crypto_aes_set_key(struct crypto_tfm *tfm, const u8 *in_key,
> +/**
> + * crypto_aes_expand_key - Expands the AES key as described in FIPS-197
> + * @ctx:	The location where the computed key will be stored.
> + * @in_key:	The supplied key.
> + * @key_len:	The length of the supplied key.
> + *
> + * Returns 0 on success. The function fails only if an invalid key size (or
> + * pointer) is supplied.
> + * The expanded key size is 240 bytes (max of 14 rounds with a unique 16 bytes
> + * key schedule plus a 16 bytes key which is used before the first round).
> + * The decryption key is prepared for the "Equivalent Inverse Cipher" as
> + * described in FIPS-197. The first slot (16 bytes) of each key (enc or dec) is
> + * for the initial combination, the second slot for the first round and so on.
> + */
> +int crypto_aes_expand_key(struct crypto_aes_ctx *ctx, const u8 *in_key,
>  		unsigned int key_len)
>  {
> -	struct crypto_aes_ctx *ctx = crypto_tfm_ctx(tfm);
>  	const __le32 *key = (const __le32 *)in_key;
> -	u32 *flags = &tfm->crt_flags;
>  	u32 i, t, u, v, w, j;
>  
> -	if (key_len % 8) {
> -		*flags |= CRYPTO_TFM_RES_BAD_KEY_LEN;
> +	if (key_len != AES_KEYSIZE_128 && key_len != AES_KEYSIZE_192 &&
> +			key_len != AES_KEYSIZE_256)
>  		return -EINVAL;
> -	}
>  
>  	ctx->key_length = key_len;
>  
> @@ -250,20 +261,20 @@ int crypto_aes_set_key(struct crypto_tfm *tfm, const u8 *in_key,
>  	ctx->key_dec[key_len + 27] = ctx->key_enc[3] = le32_to_cpu(key[3]);
>  
>  	switch (key_len) {
> -	case 16:
> +	case AES_KEYSIZE_128:
>  		t = ctx->key_enc[3];
>  		for (i = 0; i < 10; ++i)
>  			loop4(i);
>  		break;
>  
> -	case 24:
> +	case AES_KEYSIZE_192:
>  		ctx->key_enc[4] = le32_to_cpu(key[4]);
>  		t = ctx->key_enc[5] = le32_to_cpu(key[5]);
>  		for (i = 0; i < 8; ++i)
>  			loop6(i);
>  		break;
>  
> -	case 32:
> +	case AES_KEYSIZE_256:
>  		ctx->key_enc[4] = le32_to_cpu(key[4]);
>  		ctx->key_enc[5] = le32_to_cpu(key[5]);
>  		ctx->key_enc[6] = le32_to_cpu(key[6]);
> @@ -284,6 +295,33 @@ int crypto_aes_set_key(struct crypto_tfm *tfm, const u8 *in_key,
>  	}
>  	return 0;
>  }
> +EXPORT_SYMBOL_GPL(crypto_aes_expand_key);
> +
> +/**
> + * crypto_aes_set_key - Set the AES key.
> + * @tfm:	The %crypto_tfm that is used in the context.
> + * @in_key:	The input key.
> + * @key_len:	The size of the key.
> + *
> + * Returns 0 on success, on failure the %CRYPTO_TFM_RES_BAD_KEY_LEN flag in tfm
> + * is set. The function uses crypto_aes_expand_key() to expand the key.
> + * &crypto_aes_ctx _must_ be the private data embedded in @tfm which is
> + * retrieved with crypto_tfm_ctx().
> + */
> +int crypto_aes_set_key(struct crypto_tfm *tfm, const u8 *in_key,
> +		unsigned int key_len)
> +{
> +	struct crypto_aes_ctx *ctx = crypto_tfm_ctx(tfm);
> +	u32 *flags = &tfm->crt_flags;
> +	int ret;
> +
> +	ret = crypto_aes_expand_key(ctx, in_key, key_len);
> +	if (!ret)
> +		return 0;
> +
> +	*flags |= CRYPTO_TFM_RES_BAD_KEY_LEN;
> +	return -EINVAL;
> +}
>  EXPORT_SYMBOL_GPL(crypto_aes_set_key);
>  
>  /* encrypt a block of text */
> diff --git a/include/crypto/aes.h b/include/crypto/aes.h
> index d480b76..40008d6 100644
> --- a/include/crypto/aes.h
> +++ b/include/crypto/aes.h
> @@ -14,11 +14,13 @@
>  #define AES_KEYSIZE_192		24
>  #define AES_KEYSIZE_256		32
>  #define AES_BLOCK_SIZE		16
> +#define AES_MAX_KEYLENGTH	(15 * 16)
> +#define AES_MAX_KEYLENGTH_U32	(AES_MAX_KEYLENGTH / sizeof(u32))
>  
>  struct crypto_aes_ctx {
>  	u32 key_length;
> -	u32 key_enc[60];
> -	u32 key_dec[60];
> +	u32 key_enc[AES_MAX_KEYLENGTH_U32];
> +	u32 key_dec[AES_MAX_KEYLENGTH_U32];
>  };
>  
>  extern u32 crypto_ft_tab[4][256];
> @@ -28,4 +30,6 @@ extern u32 crypto_il_tab[4][256];
>  
>  int crypto_aes_set_key(struct crypto_tfm *tfm, const u8 *in_key,
>  		unsigned int key_len);
> +int crypto_aes_expand_key(struct crypto_aes_ctx *ctx, const u8 *in_key,
> +		unsigned int key_len);
>  #endif
