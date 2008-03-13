From: Stefan Hellermann <stefan@the2masters.de>
Subject: Re: [RFC] [crypto] padlock-AES, use generic setkey function
Date: Thu, 13 Mar 2008 22:40:50 +0100
Message-ID: <47D99F62.7010100@the2masters.de>
References: <1203850864-16681-1-git-send-email-sebastian@breakpoint.cc> <1203850864-16681-3-git-send-email-sebastian@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org, Michal Ludvig <michal@logix.cz>
To: Sebastian Siewior <sebastian@breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp11.unit.tiscali.de ([213.205.33.47]:46825 "EHLO
	smtp11.unit.tiscali.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755151AbYCMVlt (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 13 Mar 2008 17:41:49 -0400
In-Reply-To: <1203850864-16681-3-git-send-email-sebastian@breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Sebastian Siewior schrieb:
> Padlock AES' setkey routine is the same as exported by the generic
> implementation. So we could use it.
> 

I tested this and "[RFC] generic_aes: export generic setkey" on a padlock-enabled Via
board, and did the following test:

Create, open, write to, read from and close a linux dm-crypt device with aes-cbc-essiv,
aes-lrw-benbi and aes-xts-plain.

Then I took a huge encrypted disk-image (encrypted without this patches), opened it with
cryptsetup-luks, booted the OS from the disc over iscsi, started a filesystem-check. The
check completed successful.

So I think this and the other patch are save.


Tested-by: Stefan Hellermann <stefan@the2masters.de>

> Cc: Michal Ludvig <michal@logix.cz>
> Signed-off-by: Sebastian Siewior <sebastian@breakpoint.cc>
> ---
>  drivers/crypto/Kconfig       |    1 +
>  drivers/crypto/padlock-aes.c |  320 +++---------------------------------------
>  2 files changed, 20 insertions(+), 301 deletions(-)
> 
> diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
> index 6b658d8..5647146 100644
> --- a/drivers/crypto/Kconfig
> +++ b/drivers/crypto/Kconfig
> @@ -27,6 +27,7 @@ config CRYPTO_DEV_PADLOCK_AES
>  	tristate "PadLock driver for AES algorithm"
>  	depends on CRYPTO_DEV_PADLOCK
>  	select CRYPTO_BLKCIPHER
> +	select CRYPTO_AES
>  	help
>  	  Use VIA PadLock for AES algorithm.
>  
> diff --git a/drivers/crypto/padlock-aes.c b/drivers/crypto/padlock-aes.c
> index 08fc240..36ec298 100644
> --- a/drivers/crypto/padlock-aes.c
> +++ b/drivers/crypto/padlock-aes.c
> @@ -5,42 +5,6 @@
>   *
>   * Copyright (c) 2004  Michal Ludvig <michal@logix.cz>
>   *
> - * Key expansion routine taken from crypto/aes_generic.c
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
> - *
> - * ---------------------------------------------------------------------------
> - * Copyright (c) 2002, Dr Brian Gladman <brg@gladman.me.uk>, Worcester, UK.
> - * All rights reserved.
> - *
> - * LICENSE TERMS
> - *
> - * The free distribution and use of this software in both source and binary
> - * form is allowed (with or without changes) provided that:
> - *
> - *   1. distributions of this source code include the above copyright
> - *      notice, this list of conditions and the following disclaimer;
> - *
> - *   2. distributions in binary form include the above copyright
> - *      notice, this list of conditions and the following disclaimer
> - *      in the documentation and/or other associated materials;
> - *
> - *   3. the copyright holder's name is not used to endorse products
> - *      built using this software without specific written permission.
> - *
> - * ALTERNATIVELY, provided that this notice is retained in full, this product
> - * may be distributed under the terms of the GNU General Public License (GPL),
> - * in which case the provisions of the GPL apply INSTEAD OF those given above.
> - *
> - * DISCLAIMER
> - *
> - * This software is provided 'as is' with no explicit or implied warranties
> - * in respect of its properties, including, but not limited to, correctness
> - * and/or fitness for purpose.
> - * ---------------------------------------------------------------------------
>   */
>  
>  #include <crypto/algapi.h>
> @@ -54,9 +18,6 @@
>  #include <asm/byteorder.h>
>  #include "padlock.h"
>  
> -#define AES_EXTENDED_KEY_SIZE	64	/* in uint32_t units */
> -#define AES_EXTENDED_KEY_SIZE_B	(AES_EXTENDED_KEY_SIZE * sizeof(uint32_t))
> -
>  /* Control word. */
>  struct cword {
>  	unsigned int __attribute__ ((__packed__))
> @@ -70,218 +31,23 @@ struct cword {
>  
>  /* Whenever making any changes to the following
>   * structure *make sure* you keep E, d_data
> - * and cword aligned on 16 Bytes boundaries!!! */
> + * and cword aligned on 16 Bytes boundaries and
> + * the Hardware can access 16 * 16 bytes of E and d_data
> + * (only the first 15 * 16 bytes matter but the HW reads
> + * more).
> + */
>  struct aes_ctx {
> +	u32 E[AES_MAX_KEYLENGTH_U32]
> +		__attribute__ ((__aligned__(PADLOCK_ALIGNMENT)));
> +	u32 d_data[AES_MAX_KEYLENGTH_U32]
> +		__attribute__ ((__aligned__(PADLOCK_ALIGNMENT)));
>  	struct {
>  		struct cword encrypt;
>  		struct cword decrypt;
>  	} cword;
>  	u32 *D;
> -	int key_length;
> -	u32 E[AES_EXTENDED_KEY_SIZE]
> -		__attribute__ ((__aligned__(PADLOCK_ALIGNMENT)));
> -	u32 d_data[AES_EXTENDED_KEY_SIZE]
> -		__attribute__ ((__aligned__(PADLOCK_ALIGNMENT)));
>  };
>  
> -/* ====== Key management routines ====== */
> -
> -static inline uint32_t
> -generic_rotr32 (const uint32_t x, const unsigned bits)
> -{
> -	const unsigned n = bits % 32;
> -	return (x >> n) | (x << (32 - n));
> -}
> -
> -static inline uint32_t
> -generic_rotl32 (const uint32_t x, const unsigned bits)
> -{
> -	const unsigned n = bits % 32;
> -	return (x << n) | (x >> (32 - n));
> -}
> -
> -#define rotl generic_rotl32
> -#define rotr generic_rotr32
> -
> -/*
> - * #define byte(x, nr) ((unsigned char)((x) >> (nr*8))) 
> - */
> -static inline uint8_t
> -byte(const uint32_t x, const unsigned n)
> -{
> -	return x >> (n << 3);
> -}
> -
> -#define E_KEY ctx->E
> -#define D_KEY ctx->D
> -
> -static uint8_t pow_tab[256];
> -static uint8_t log_tab[256];
> -static uint8_t sbx_tab[256];
> -static uint8_t isb_tab[256];
> -static uint32_t rco_tab[10];
> -static uint32_t ft_tab[4][256];
> -static uint32_t it_tab[4][256];
> -
> -static uint32_t fl_tab[4][256];
> -static uint32_t il_tab[4][256];
> -
> -static inline uint8_t
> -f_mult (uint8_t a, uint8_t b)
> -{
> -	uint8_t aa = log_tab[a], cc = aa + log_tab[b];
> -
> -	return pow_tab[cc + (cc < aa ? 1 : 0)];
> -}
> -
> -#define ff_mult(a,b)    (a && b ? f_mult(a, b) : 0)
> -
> -#define f_rn(bo, bi, n, k)					\
> -    bo[n] =  ft_tab[0][byte(bi[n],0)] ^				\
> -             ft_tab[1][byte(bi[(n + 1) & 3],1)] ^		\
> -             ft_tab[2][byte(bi[(n + 2) & 3],2)] ^		\
> -             ft_tab[3][byte(bi[(n + 3) & 3],3)] ^ *(k + n)
> -
> -#define i_rn(bo, bi, n, k)					\
> -    bo[n] =  it_tab[0][byte(bi[n],0)] ^				\
> -             it_tab[1][byte(bi[(n + 3) & 3],1)] ^		\
> -             it_tab[2][byte(bi[(n + 2) & 3],2)] ^		\
> -             it_tab[3][byte(bi[(n + 1) & 3],3)] ^ *(k + n)
> -
> -#define ls_box(x)				\
> -    ( fl_tab[0][byte(x, 0)] ^			\
> -      fl_tab[1][byte(x, 1)] ^			\
> -      fl_tab[2][byte(x, 2)] ^			\
> -      fl_tab[3][byte(x, 3)] )
> -
> -#define f_rl(bo, bi, n, k)					\
> -    bo[n] =  fl_tab[0][byte(bi[n],0)] ^				\
> -             fl_tab[1][byte(bi[(n + 1) & 3],1)] ^		\
> -             fl_tab[2][byte(bi[(n + 2) & 3],2)] ^		\
> -             fl_tab[3][byte(bi[(n + 3) & 3],3)] ^ *(k + n)
> -
> -#define i_rl(bo, bi, n, k)					\
> -    bo[n] =  il_tab[0][byte(bi[n],0)] ^				\
> -             il_tab[1][byte(bi[(n + 3) & 3],1)] ^		\
> -             il_tab[2][byte(bi[(n + 2) & 3],2)] ^		\
> -             il_tab[3][byte(bi[(n + 1) & 3],3)] ^ *(k + n)
> -
> -static void
> -gen_tabs (void)
> -{
> -	uint32_t i, t;
> -	uint8_t p, q;
> -
> -	/* log and power tables for GF(2**8) finite field with
> -	   0x011b as modular polynomial - the simplest prmitive
> -	   root is 0x03, used here to generate the tables */
> -
> -	for (i = 0, p = 1; i < 256; ++i) {
> -		pow_tab[i] = (uint8_t) p;
> -		log_tab[p] = (uint8_t) i;
> -
> -		p ^= (p << 1) ^ (p & 0x80 ? 0x01b : 0);
> -	}
> -
> -	log_tab[1] = 0;
> -
> -	for (i = 0, p = 1; i < 10; ++i) {
> -		rco_tab[i] = p;
> -
> -		p = (p << 1) ^ (p & 0x80 ? 0x01b : 0);
> -	}
> -
> -	for (i = 0; i < 256; ++i) {
> -		p = (i ? pow_tab[255 - log_tab[i]] : 0);
> -		q = ((p >> 7) | (p << 1)) ^ ((p >> 6) | (p << 2));
> -		p ^= 0x63 ^ q ^ ((q >> 6) | (q << 2));
> -		sbx_tab[i] = p;
> -		isb_tab[p] = (uint8_t) i;
> -	}
> -
> -	for (i = 0; i < 256; ++i) {
> -		p = sbx_tab[i];
> -
> -		t = p;
> -		fl_tab[0][i] = t;
> -		fl_tab[1][i] = rotl (t, 8);
> -		fl_tab[2][i] = rotl (t, 16);
> -		fl_tab[3][i] = rotl (t, 24);
> -
> -		t = ((uint32_t) ff_mult (2, p)) |
> -		    ((uint32_t) p << 8) |
> -		    ((uint32_t) p << 16) | ((uint32_t) ff_mult (3, p) << 24);
> -
> -		ft_tab[0][i] = t;
> -		ft_tab[1][i] = rotl (t, 8);
> -		ft_tab[2][i] = rotl (t, 16);
> -		ft_tab[3][i] = rotl (t, 24);
> -
> -		p = isb_tab[i];
> -
> -		t = p;
> -		il_tab[0][i] = t;
> -		il_tab[1][i] = rotl (t, 8);
> -		il_tab[2][i] = rotl (t, 16);
> -		il_tab[3][i] = rotl (t, 24);
> -
> -		t = ((uint32_t) ff_mult (14, p)) |
> -		    ((uint32_t) ff_mult (9, p) << 8) |
> -		    ((uint32_t) ff_mult (13, p) << 16) |
> -		    ((uint32_t) ff_mult (11, p) << 24);
> -
> -		it_tab[0][i] = t;
> -		it_tab[1][i] = rotl (t, 8);
> -		it_tab[2][i] = rotl (t, 16);
> -		it_tab[3][i] = rotl (t, 24);
> -	}
> -}
> -
> -#define star_x(x) (((x) & 0x7f7f7f7f) << 1) ^ ((((x) & 0x80808080) >> 7) * 0x1b)
> -
> -#define imix_col(y,x)       \
> -    u   = star_x(x);        \
> -    v   = star_x(u);        \
> -    w   = star_x(v);        \
> -    t   = w ^ (x);          \
> -   (y)  = u ^ v ^ w;        \
> -   (y) ^= rotr(u ^ t,  8) ^ \
> -          rotr(v ^ t, 16) ^ \
> -          rotr(t,24)
> -
> -/* initialise the key schedule from the user supplied key */
> -
> -#define loop4(i)                                    \
> -{   t = rotr(t,  8); t = ls_box(t) ^ rco_tab[i];    \
> -    t ^= E_KEY[4 * i];     E_KEY[4 * i + 4] = t;    \
> -    t ^= E_KEY[4 * i + 1]; E_KEY[4 * i + 5] = t;    \
> -    t ^= E_KEY[4 * i + 2]; E_KEY[4 * i + 6] = t;    \
> -    t ^= E_KEY[4 * i + 3]; E_KEY[4 * i + 7] = t;    \
> -}
> -
> -#define loop6(i)                                    \
> -{   t = rotr(t,  8); t = ls_box(t) ^ rco_tab[i];    \
> -    t ^= E_KEY[6 * i];     E_KEY[6 * i + 6] = t;    \
> -    t ^= E_KEY[6 * i + 1]; E_KEY[6 * i + 7] = t;    \
> -    t ^= E_KEY[6 * i + 2]; E_KEY[6 * i + 8] = t;    \
> -    t ^= E_KEY[6 * i + 3]; E_KEY[6 * i + 9] = t;    \
> -    t ^= E_KEY[6 * i + 4]; E_KEY[6 * i + 10] = t;   \
> -    t ^= E_KEY[6 * i + 5]; E_KEY[6 * i + 11] = t;   \
> -}
> -
> -#define loop8(i)                                    \
> -{   t = rotr(t,  8); ; t = ls_box(t) ^ rco_tab[i];  \
> -    t ^= E_KEY[8 * i];     E_KEY[8 * i + 8] = t;    \
> -    t ^= E_KEY[8 * i + 1]; E_KEY[8 * i + 9] = t;    \
> -    t ^= E_KEY[8 * i + 2]; E_KEY[8 * i + 10] = t;   \
> -    t ^= E_KEY[8 * i + 3]; E_KEY[8 * i + 11] = t;   \
> -    t  = E_KEY[8 * i + 4] ^ ls_box(t);    \
> -    E_KEY[8 * i + 12] = t;                \
> -    t ^= E_KEY[8 * i + 5]; E_KEY[8 * i + 13] = t;   \
> -    t ^= E_KEY[8 * i + 6]; E_KEY[8 * i + 14] = t;   \
> -    t ^= E_KEY[8 * i + 7]; E_KEY[8 * i + 15] = t;   \
> -}
> -
>  /* Tells whether the ACE is capable to generate
>     the extended key for a given key_len. */
>  static inline int
> @@ -321,17 +87,13 @@ static int aes_set_key(struct crypto_tfm *tfm, const u8 *in_key,
>  	struct aes_ctx *ctx = aes_ctx(tfm);
>  	const __le32 *key = (const __le32 *)in_key;
>  	u32 *flags = &tfm->crt_flags;
> -	uint32_t i, t, u, v, w;
> -	uint32_t P[AES_EXTENDED_KEY_SIZE];
> -	uint32_t rounds;
> +	struct crypto_aes_ctx gen_aes;
>  
>  	if (key_len % 8) {
>  		*flags |= CRYPTO_TFM_RES_BAD_KEY_LEN;
>  		return -EINVAL;
>  	}
>  
> -	ctx->key_length = key_len;
> -
>  	/*
>  	 * If the hardware is capable of generating the extended key
>  	 * itself we must supply the plain key for both encryption
> @@ -339,10 +101,10 @@ static int aes_set_key(struct crypto_tfm *tfm, const u8 *in_key,
>  	 */
>  	ctx->D = ctx->E;
>  
> -	E_KEY[0] = le32_to_cpu(key[0]);
> -	E_KEY[1] = le32_to_cpu(key[1]);
> -	E_KEY[2] = le32_to_cpu(key[2]);
> -	E_KEY[3] = le32_to_cpu(key[3]);
> +	ctx->E[0] = le32_to_cpu(key[0]);
> +	ctx->E[1] = le32_to_cpu(key[1]);
> +	ctx->E[2] = le32_to_cpu(key[2]);
> +	ctx->E[3] = le32_to_cpu(key[3]);
>  
>  	/* Prepare control words. */
>  	memset(&ctx->cword, 0, sizeof(ctx->cword));
> @@ -361,56 +123,13 @@ static int aes_set_key(struct crypto_tfm *tfm, const u8 *in_key,
>  	ctx->cword.encrypt.keygen = 1;
>  	ctx->cword.decrypt.keygen = 1;
>  
> -	switch (key_len) {
> -	case 16:
> -		t = E_KEY[3];
> -		for (i = 0; i < 10; ++i)
> -			loop4 (i);
> -		break;
> -
> -	case 24:
> -		E_KEY[4] = le32_to_cpu(key[4]);
> -		t = E_KEY[5] = le32_to_cpu(key[5]);
> -		for (i = 0; i < 8; ++i)
> -			loop6 (i);
> -		break;
> -
> -	case 32:
> -		E_KEY[4] = le32_to_cpu(key[4]);
> -		E_KEY[5] = le32_to_cpu(key[5]);
> -		E_KEY[6] = le32_to_cpu(key[6]);
> -		t = E_KEY[7] = le32_to_cpu(key[7]);
> -		for (i = 0; i < 7; ++i)
> -			loop8 (i);
> -		break;
> -	}
> -
> -	D_KEY[0] = E_KEY[0];
> -	D_KEY[1] = E_KEY[1];
> -	D_KEY[2] = E_KEY[2];
> -	D_KEY[3] = E_KEY[3];
> -
> -	for (i = 4; i < key_len + 24; ++i) {
> -		imix_col (D_KEY[i], E_KEY[i]);
> -	}
> -
> -	/* PadLock needs a different format of the decryption key. */
> -	rounds = 10 + (key_len - 16) / 4;
> -
> -	for (i = 0; i < rounds; i++) {
> -		P[((i + 1) * 4) + 0] = D_KEY[((rounds - i - 1) * 4) + 0];
> -		P[((i + 1) * 4) + 1] = D_KEY[((rounds - i - 1) * 4) + 1];
> -		P[((i + 1) * 4) + 2] = D_KEY[((rounds - i - 1) * 4) + 2];
> -		P[((i + 1) * 4) + 3] = D_KEY[((rounds - i - 1) * 4) + 3];
> +	if (crypto_aes_expand_key(&gen_aes, in_key, key_len)) {
> +		*flags |= CRYPTO_TFM_RES_BAD_KEY_LEN;
> +		return -EINVAL;
>  	}
>  
> -	P[0] = E_KEY[(rounds * 4) + 0];
> -	P[1] = E_KEY[(rounds * 4) + 1];
> -	P[2] = E_KEY[(rounds * 4) + 2];
> -	P[3] = E_KEY[(rounds * 4) + 3];
> -
> -	memcpy(D_KEY, P, AES_EXTENDED_KEY_SIZE_B);
> -
> +	memcpy(ctx->E, gen_aes.key_enc, AES_MAX_KEYLENGTH);
> +	memcpy(ctx->D, gen_aes.key_dec, AES_MAX_KEYLENGTH);
>  	return 0;
>  }
>  
> @@ -677,7 +396,6 @@ static int __init padlock_init(void)
>  		return -ENODEV;
>  	}
>  
> -	gen_tabs();
>  	if ((ret = crypto_register_alg(&aes_alg)))
>  		goto aes_err;
>  
