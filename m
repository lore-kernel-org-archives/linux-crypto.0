From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/2] crypto: arm/sha512 - accelerated SHA-512 using ARM
 generic ASM and NEON
Date: Mon, 11 May 2015 14:59:52 +0800
Message-ID: <20150511065952.GB2598@gondor.apana.org.au>
References: <1431074782-22141-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:36438 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751870AbbEKG77 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 11 May 2015 02:59:59 -0400
Content-Disposition: inline
In-Reply-To: <1431074782-22141-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, May 08, 2015 at 10:46:21AM +0200, Ard Biesheuvel wrote:
>
> diff --git a/arch/arm/crypto/Kconfig b/arch/arm/crypto/Kconfig
> index 8da2207b0072..08b5fb85bff5 100644
> --- a/arch/arm/crypto/Kconfig
> +++ b/arch/arm/crypto/Kconfig
> @@ -53,20 +53,14 @@ config CRYPTO_SHA256_ARM
>  	  SHA-256 secure hash standard (DFIPS 180-2) implemented
>  	  using optimized ARM assembler and NEON, when available.
>  
> -config CRYPTO_SHA512_ARM_NEON
> -	tristate "SHA384 and SHA512 digest algorithm (ARM NEON)"
> -	depends on KERNEL_MODE_NEON
> -	select CRYPTO_SHA512
> +config CRYPTO_SHA512_ARM
> +	tristate "SHA-384/512 digest algorithm (ARM-asm and NEON)"
> +	depends on !CPU_V7M
>  	select CRYPTO_HASH
> +	depends on !CPU_V7M

This looks like a duplicate, no?
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
