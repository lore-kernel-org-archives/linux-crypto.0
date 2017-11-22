From: Alex Matveev <alxmtvv@gmail.com>
Subject: Re: [PATCH] crypto/arm64: aes-ce-cipher - move assembler code to .S
 file
Date: Wed, 22 Nov 2017 10:05:58 +0000
Message-ID: <20171122100558.717b7973@delmar.localdomain>
References: <20171121134017.21247-1-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        mark.rutland@arm.com, samitolvanen@google.com, ak@linux.intel.com,
        ghackmann@google.com, keescook@chromium.org,
        michal.lkml@markovi.net, ndesaulniers@google.com,
        ynorov@caviumnetworks.com, mka@chromium.org, will.deacon@arm.com,
        herbert@gondor.apana.org.au
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:35848 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751723AbdKVKGC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 22 Nov 2017 05:06:02 -0500
Received: by mail-wm0-f67.google.com with SMTP id r68so9004702wmr.1
        for <linux-crypto@vger.kernel.org>; Wed, 22 Nov 2017 02:06:01 -0800 (PST)
In-Reply-To: <20171121134017.21247-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This is better than my simple fix, thank you.

Out of curiosity, why doesn't NEON code use barrier() to prevent
reordering?

On Tue, 21 Nov 2017 13:40:17 +0000
Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:

> Most crypto drivers involving kernel mode NEON take care to put the
> code that actually touches the NEON register file in a separate
> compilation unit, to prevent the compiler from reordering code that
> preserves or restores the NEON context with code that may corrupt it.
> This is necessary because we currently have no way to express the
> restrictions imposed upon use of the NEON in kernel mode in a way
> that the compiler understands.
> 
> However, in the case of aes-ce-cipher, it did not seem unreasonable to
> deviate from this rule, given how it does not seem possible for the
> compiler to reorder cross object function calls with asm blocks whose
> in- and output constraints reflect that it reads from and writes to
> memory.
> 
> Now that LTO is being proposed for the arm64 kernel, it is time to
> revisit this. The link time optimization may replace the function
> calls to kernel_neon_begin() and kernel_neon_end() with instantiations
> of the IR that make up its implementation, allowing further reordering
> with the asm block.
> 
> So let's clean this up, and move the asm() blocks into a separate .S
> file.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>  arch/arm64/crypto/Makefile                         |   2 +-
>  arch/arm64/crypto/aes-ce-core.S                    |  87
> ++++++++++++++++ .../crypto/{aes-ce-cipher.c => aes-ce-glue.c}      |
> 115 +++------------------ 3 files changed, 100 insertions(+), 104
> deletions(-) create mode 100644 arch/arm64/crypto/aes-ce-core.S
>  rename arch/arm64/crypto/{aes-ce-cipher.c => aes-ce-glue.c} (62%)
> 
> diff --git a/arch/arm64/crypto/Makefile b/arch/arm64/crypto/Makefile
> index b5edc5918c28..f5e8295fd756 100644
> --- a/arch/arm64/crypto/Makefile
> +++ b/arch/arm64/crypto/Makefile
> @@ -24,7 +24,7 @@ obj-$(CONFIG_CRYPTO_CRC32_ARM64_CE) += crc32-ce.o
>  crc32-ce-y:= crc32-ce-core.o crc32-ce-glue.o
>  
>  obj-$(CONFIG_CRYPTO_AES_ARM64_CE) += aes-ce-cipher.o
> -CFLAGS_aes-ce-cipher.o += -march=armv8-a+crypto
> +aes-ce-cipher-y := aes-ce-core.o aes-ce-glue.o
>  
>  obj-$(CONFIG_CRYPTO_AES_ARM64_CE_CCM) += aes-ce-ccm.o
>  aes-ce-ccm-y := aes-ce-ccm-glue.o aes-ce-ccm-core.o
> diff --git a/arch/arm64/crypto/aes-ce-core.S
> b/arch/arm64/crypto/aes-ce-core.S new file mode 100644
> index 000000000000..8efdfdade393
> --- /dev/null
> +++ b/arch/arm64/crypto/aes-ce-core.S
> @@ -0,0 +1,87 @@
> +/*
> + * Copyright (C) 2013 - 2017 Linaro Ltd <ard.biesheuvel@linaro.org>
> + *
> + * This program is free software; you can redistribute it and/or
> modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/linkage.h>
> +#include <asm/assembler.h>
> +
> +	.arch		armv8-a+crypto
> +
> +ENTRY(__aes_ce_encrypt)
> +	sub		w3, w3, #2
> +	ld1		{v0.16b}, [x2]
> +	ld1		{v1.4s}, [x0], #16
> +	cmp		w3, #10
> +	bmi		0f
> +	bne		3f
> +	mov		v3.16b, v1.16b
> +	b		2f
> +0:	mov		v2.16b, v1.16b
> +	ld1		{v3.4s}, [x0], #16
> +1:	aese		v0.16b, v2.16b
> +	aesmc		v0.16b, v0.16b
> +2:	ld1		{v1.4s}, [x0], #16
> +	aese		v0.16b, v3.16b
> +	aesmc		v0.16b, v0.16b
> +3:	ld1		{v2.4s}, [x0], #16
> +	subs		w3, w3, #3
> +	aese		v0.16b, v1.16b
> +	aesmc		v0.16b, v0.16b
> +	ld1		{v3.4s}, [x0], #16
> +	bpl		1b
> +	aese		v0.16b, v2.16b
> +	eor		v0.16b, v0.16b, v3.16b
> +	st1		{v0.16b}, [x1]
> +	ret
> +ENDPROC(__aes_ce_encrypt)
> +
> +ENTRY(__aes_ce_decrypt)
> +	sub		w3, w3, #2
> +	ld1		{v0.16b}, [x2]
> +	ld1		{v1.4s}, [x0], #16
> +	cmp		w3, #10
> +	bmi		0f
> +	bne		3f
> +	mov		v3.16b, v1.16b
> +	b		2f
> +0:	mov		v2.16b, v1.16b
> +	ld1		{v3.4s}, [x0], #16
> +1:	aesd		v0.16b, v2.16b
> +	aesimc		v0.16b, v0.16b
> +2:	ld1		{v1.4s}, [x0], #16
> +	aesd		v0.16b, v3.16b
> +	aesimc		v0.16b, v0.16b
> +3:	ld1		{v2.4s}, [x0], #16
> +	subs		w3, w3, #3
> +	aesd		v0.16b, v1.16b
> +	aesimc		v0.16b, v0.16b
> +	ld1		{v3.4s}, [x0], #16
> +	bpl		1b
> +	aesd		v0.16b, v2.16b
> +	eor		v0.16b, v0.16b, v3.16b
> +	st1		{v0.16b}, [x1]
> +	ret
> +ENDPROC(__aes_ce_decrypt)
> +
> +/*
> + * __aes_ce_sub() - use the aese instruction to perform the AES sbox
> + *                  substitution on each byte in 'input'
> + */
> +ENTRY(__aes_ce_sub)
> +	dup		v1.4s, w0
> +	movi		v0.16b, #0
> +	aese		v0.16b, v1.16b
> +	umov		w0, v0.s[0]
> +	ret
> +ENDPROC(__aes_ce_sub)
> +
> +ENTRY(__aes_ce_invert)
> +	ld1		{v0.4s}, [x1]
> +	aesimc		v1.16b, v0.16b
> +	st1		{v1.4s}, [x0]
> +	ret
> +ENDPROC(__aes_ce_invert)
> diff --git a/arch/arm64/crypto/aes-ce-cipher.c
> b/arch/arm64/crypto/aes-ce-glue.c similarity index 62%
> rename from arch/arm64/crypto/aes-ce-cipher.c
> rename to arch/arm64/crypto/aes-ce-glue.c
> index 6a75cd75ed11..e6b3227bbf57 100644
> --- a/arch/arm64/crypto/aes-ce-cipher.c
> +++ b/arch/arm64/crypto/aes-ce-glue.c
> @@ -29,6 +29,13 @@ struct aes_block {
>  	u8 b[AES_BLOCK_SIZE];
>  };
>  
> +asmlinkage void __aes_ce_encrypt(u32 *rk, u8 *out, const u8 *in, int
> rounds); +asmlinkage void __aes_ce_decrypt(u32 *rk, u8 *out, const u8
> *in, int rounds); +
> +asmlinkage u32 __aes_ce_sub(u32 l);
> +asmlinkage void __aes_ce_invert(struct aes_block *out,
> +				const struct aes_block *in);
> +
>  static int num_rounds(struct crypto_aes_ctx *ctx)
>  {
>  	/*
> @@ -44,10 +51,6 @@ static int num_rounds(struct crypto_aes_ctx *ctx)
>  static void aes_cipher_encrypt(struct crypto_tfm *tfm, u8 dst[], u8
> const src[]) {
>  	struct crypto_aes_ctx *ctx = crypto_tfm_ctx(tfm);
> -	struct aes_block *out = (struct aes_block *)dst;
> -	struct aes_block const *in = (struct aes_block *)src;
> -	void *dummy0;
> -	int dummy1;
>  
>  	if (!may_use_simd()) {
>  		__aes_arm64_encrypt(ctx->key_enc, dst, src,
> num_rounds(ctx)); @@ -55,49 +58,13 @@ static void
> aes_cipher_encrypt(struct crypto_tfm *tfm, u8 dst[], u8 const src[]) }
>  
>  	kernel_neon_begin();
> -
> -	__asm__("	ld1	{v0.16b},
> %[in]			;"
> -		"	ld1	{v1.4s}, [%[key]],
> #16		;"
> -		"	cmp	%w[rounds],
> #10			;"
> -		"	bmi
> 0f				;"
> -		"	bne
> 3f				;"
> -		"	mov	v3.16b,
> v1.16b			;"
> -		"	b
> 2f				;"
> -		"0:	mov	v2.16b,
> v1.16b			;"
> -		"	ld1	{v3.4s}, [%[key]],
> #16		;"
> -		"1:	aese	v0.16b,
> v2.16b			;"
> -		"	aesmc	v0.16b,
> v0.16b			;"
> -		"2:	ld1	{v1.4s}, [%[key]],
> #16		;"
> -		"	aese	v0.16b,
> v3.16b			;"
> -		"	aesmc	v0.16b,
> v0.16b			;"
> -		"3:	ld1	{v2.4s}, [%[key]],
> #16		;"
> -		"	subs	%w[rounds], %w[rounds],
> #3	;"
> -		"	aese	v0.16b,
> v1.16b			;"
> -		"	aesmc	v0.16b,
> v0.16b			;"
> -		"	ld1	{v3.4s}, [%[key]],
> #16		;"
> -		"	bpl
> 1b				;"
> -		"	aese	v0.16b,
> v2.16b			;"
> -		"	eor	v0.16b, v0.16b,
> v3.16b		;"
> -		"	st1	{v0.16b},
> %[out]		;" -
> -	:	[out]		"=Q"(*out),
> -		[key]		"=r"(dummy0),
> -		[rounds]	"=r"(dummy1)
> -	:	[in]		"Q"(*in),
> -				"1"(ctx->key_enc),
> -				"2"(num_rounds(ctx) - 2)
> -	:	"cc");
> -
> +	__aes_ce_encrypt(ctx->key_enc, dst, src, num_rounds(ctx));
>  	kernel_neon_end();
>  }
>  
>  static void aes_cipher_decrypt(struct crypto_tfm *tfm, u8 dst[], u8
> const src[]) {
>  	struct crypto_aes_ctx *ctx = crypto_tfm_ctx(tfm);
> -	struct aes_block *out = (struct aes_block *)dst;
> -	struct aes_block const *in = (struct aes_block *)src;
> -	void *dummy0;
> -	int dummy1;
>  
>  	if (!may_use_simd()) {
>  		__aes_arm64_decrypt(ctx->key_dec, dst, src,
> num_rounds(ctx)); @@ -105,62 +72,10 @@ static void
> aes_cipher_decrypt(struct crypto_tfm *tfm, u8 dst[], u8 const src[]) }
>  
>  	kernel_neon_begin();
> -
> -	__asm__("	ld1	{v0.16b},
> %[in]			;"
> -		"	ld1	{v1.4s}, [%[key]],
> #16		;"
> -		"	cmp	%w[rounds],
> #10			;"
> -		"	bmi
> 0f				;"
> -		"	bne
> 3f				;"
> -		"	mov	v3.16b,
> v1.16b			;"
> -		"	b
> 2f				;"
> -		"0:	mov	v2.16b,
> v1.16b			;"
> -		"	ld1	{v3.4s}, [%[key]],
> #16		;"
> -		"1:	aesd	v0.16b,
> v2.16b			;"
> -		"	aesimc	v0.16b,
> v0.16b			;"
> -		"2:	ld1	{v1.4s}, [%[key]],
> #16		;"
> -		"	aesd	v0.16b,
> v3.16b			;"
> -		"	aesimc	v0.16b,
> v0.16b			;"
> -		"3:	ld1	{v2.4s}, [%[key]],
> #16		;"
> -		"	subs	%w[rounds], %w[rounds],
> #3	;"
> -		"	aesd	v0.16b,
> v1.16b			;"
> -		"	aesimc	v0.16b,
> v0.16b			;"
> -		"	ld1	{v3.4s}, [%[key]],
> #16		;"
> -		"	bpl
> 1b				;"
> -		"	aesd	v0.16b,
> v2.16b			;"
> -		"	eor	v0.16b, v0.16b,
> v3.16b		;"
> -		"	st1	{v0.16b},
> %[out]		;" -
> -	:	[out]		"=Q"(*out),
> -		[key]		"=r"(dummy0),
> -		[rounds]	"=r"(dummy1)
> -	:	[in]		"Q"(*in),
> -				"1"(ctx->key_dec),
> -				"2"(num_rounds(ctx) - 2)
> -	:	"cc");
> -
> +	__aes_ce_decrypt(ctx->key_dec, dst, src, num_rounds(ctx));
>  	kernel_neon_end();
>  }
>  
> -/*
> - * aes_sub() - use the aese instruction to perform the AES sbox
> substitution
> - *             on each byte in 'input'
> - */
> -static u32 aes_sub(u32 input)
> -{
> -	u32 ret;
> -
> -	__asm__("dup	v1.4s, %w[in]		;"
> -		"movi	v0.16b, #0		;"
> -		"aese	v0.16b, v1.16b		;"
> -		"umov	%w[out], v0.4s[0]	;"
> -
> -	:	[out]	"=r"(ret)
> -	:	[in]	"r"(input)
> -	:		"v0","v1");
> -
> -	return ret;
> -}
> -
>  int ce_aes_expandkey(struct crypto_aes_ctx *ctx, const u8 *in_key,
>  		     unsigned int key_len)
>  {
> @@ -189,7 +104,7 @@ int ce_aes_expandkey(struct crypto_aes_ctx *ctx,
> const u8 *in_key, u32 *rki = ctx->key_enc + (i * kwords);
>  		u32 *rko = rki + kwords;
>  
> -		rko[0] = ror32(aes_sub(rki[kwords - 1]), 8) ^
> rcon[i] ^ rki[0];
> +		rko[0] = ror32(__aes_ce_sub(rki[kwords - 1]), 8) ^
> rcon[i] ^ rki[0]; rko[1] = rko[0] ^ rki[1];
>  		rko[2] = rko[1] ^ rki[2];
>  		rko[3] = rko[2] ^ rki[3];
> @@ -202,7 +117,7 @@ int ce_aes_expandkey(struct crypto_aes_ctx *ctx,
> const u8 *in_key, } else if (key_len == AES_KEYSIZE_256) {
>  			if (i >= 6)
>  				break;
> -			rko[4] = aes_sub(rko[3]) ^ rki[4];
> +			rko[4] = __aes_ce_sub(rko[3]) ^ rki[4];
>  			rko[5] = rko[4] ^ rki[5];
>  			rko[6] = rko[5] ^ rki[6];
>  			rko[7] = rko[6] ^ rki[7];
> @@ -221,13 +136,7 @@ int ce_aes_expandkey(struct crypto_aes_ctx *ctx,
> const u8 *in_key, 
>  	key_dec[0] = key_enc[j];
>  	for (i = 1, j--; j > 0; i++, j--)
> -		__asm__("ld1	{v0.4s}, %[in]		;"
> -			"aesimc	v1.16b,
> v0.16b		;"
> -			"st1	{v1.4s}, %[out]	;"
> -
> -		:	[out]	"=Q"(key_dec[i])
> -		:	[in]	"Q"(key_enc[j])
> -		:		"v0","v1");
> +		__aes_ce_invert(key_dec + i, key_enc + j);
>  	key_dec[i] = key_enc[0];
>  
>  	kernel_neon_end();

Regards,
Alex
