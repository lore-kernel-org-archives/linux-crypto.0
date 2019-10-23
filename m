Return-Path: <SRS0=Ux5j=YQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F08ACA9EA0
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Oct 2019 03:21:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E5FD5207FC
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Oct 2019 03:21:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1571800894;
	bh=EtIuNPw5JYCnyRSkyjtqQ73cfojAVmVSCty0G8nOJy4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=etbljLBrygDCMS9Coox8rQLDJYfI3QWdQbIlTglrEoqCdhsumlHUJTT2SVxpoxSpJ
	 8Dml9rjTquqwQdSHtak8wKLmH1t4ApbxDHgyS9c0m3n7rk6kdJFXj9x0pJe9qf0QlH
	 I4vVnDrK0+QruUl/Nh8Y2gwwqlnhj0hZxxXG/p/A=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731769AbfJWDVd (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 22 Oct 2019 23:21:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:48476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727154AbfJWDVd (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Oct 2019 23:21:33 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 714B020700;
        Wed, 23 Oct 2019 03:21:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571800891;
        bh=EtIuNPw5JYCnyRSkyjtqQ73cfojAVmVSCty0G8nOJy4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LAicEpqD5nNJ5ZlI4KtSH6CcIGSefz76ngSdxQWFNXFHwt+jRlABMmo3aObcB+ouC
         BzpFimx+Wdt0j7ys0fMmrF7D/df4j/FmAarff/9YqldwqdRECO//vEMBhGpYWKEv2X
         NkgBlhda3NtyO37Bkrx812cj+huQdHEYi0vbUBgI=
Date:   Tue, 22 Oct 2019 20:21:30 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Samuel Neves <sneves@dei.uc.pt>, Arnd Bergmann <arnd@arndb.de>,
        Andy Lutomirski <luto@kernel.org>,
        Martin Willi <martin@strongswan.org>,
        Rene van Dorst <opensource@vdorst.com>,
        David Sterba <dsterba@suse.com>
Subject: Re: [PATCH v4 08/35] crypto: arm/chacha - remove dependency on
 generic ChaCha driver
Message-ID: <20191023032130.GF4278@sol.localdomain>
Mail-Followup-To: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Samuel Neves <sneves@dei.uc.pt>, Arnd Bergmann <arnd@arndb.de>,
        Andy Lutomirski <luto@kernel.org>,
        Martin Willi <martin@strongswan.org>,
        Rene van Dorst <opensource@vdorst.com>,
        David Sterba <dsterba@suse.com>
References: <20191017190932.1947-1-ard.biesheuvel@linaro.org>
 <20191017190932.1947-9-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191017190932.1947-9-ard.biesheuvel@linaro.org>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Oct 17, 2019 at 09:09:05PM +0200, Ard Biesheuvel wrote:
> Instead of falling back to the generic ChaCha skcipher driver for
> non-SIMD cases, use a fast scalar implementation for ARM authored
> by Eric Biggers. This removes the module dependency on chacha-generic
> altogether, which also simplifies things when we expose the ChaCha
> library interface from this module.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>  arch/arm/crypto/Kconfig              |   4 +-
>  arch/arm/crypto/Makefile             |   3 +-
>  arch/arm/crypto/chacha-glue.c        | 316 ++++++++++++++++++++
>  arch/arm/crypto/chacha-neon-glue.c   | 202 -------------
>  arch/arm/crypto/chacha-scalar-core.S |  65 ++--
>  5 files changed, 351 insertions(+), 239 deletions(-)
> 
> diff --git a/arch/arm/crypto/Kconfig b/arch/arm/crypto/Kconfig
> index b24df84a1d7a..a31b0b95548d 100644
> --- a/arch/arm/crypto/Kconfig
> +++ b/arch/arm/crypto/Kconfig
> @@ -126,10 +126,8 @@ config CRYPTO_CRC32_ARM_CE
>  	select CRYPTO_HASH
>  
>  config CRYPTO_CHACHA20_NEON
> -	tristate "NEON accelerated ChaCha stream cipher algorithms"
> -	depends on KERNEL_MODE_NEON
> +	tristate "NEON and scalar accelerated ChaCha stream cipher algorithms"
>  	select CRYPTO_BLKCIPHER
> -	select CRYPTO_CHACHA20
>  
>  config CRYPTO_NHPOLY1305_NEON
>  	tristate "NEON accelerated NHPoly1305 hash function (for Adiantum)"
> diff --git a/arch/arm/crypto/Makefile b/arch/arm/crypto/Makefile
> index 4180f3a13512..6b97dffcf90f 100644
> --- a/arch/arm/crypto/Makefile
> +++ b/arch/arm/crypto/Makefile
> @@ -53,7 +53,8 @@ aes-arm-ce-y	:= aes-ce-core.o aes-ce-glue.o
>  ghash-arm-ce-y	:= ghash-ce-core.o ghash-ce-glue.o
>  crct10dif-arm-ce-y	:= crct10dif-ce-core.o crct10dif-ce-glue.o
>  crc32-arm-ce-y:= crc32-ce-core.o crc32-ce-glue.o
> -chacha-neon-y := chacha-neon-core.o chacha-neon-glue.o
> +chacha-neon-y := chacha-scalar-core.o chacha-glue.o
> +chacha-neon-$(CONFIG_KERNEL_MODE_NEON) += chacha-neon-core.o
>  nhpoly1305-neon-y := nh-neon-core.o nhpoly1305-neon-glue.o
>  
>  ifdef REGENERATE_ARM_CRYPTO
> diff --git a/arch/arm/crypto/chacha-glue.c b/arch/arm/crypto/chacha-glue.c
> new file mode 100644
> index 000000000000..2c0f76bc08b2
> --- /dev/null
> +++ b/arch/arm/crypto/chacha-glue.c
> @@ -0,0 +1,316 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * ARM NEON accelerated ChaCha and XChaCha stream ciphers,
> + * including ChaCha20 (RFC7539)
> + *
> + * Copyright (C) 2016-2019 Linaro, Ltd. <ard.biesheuvel@linaro.org>
> + * Copyright (C) 2015 Martin Willi
> + */

Technically this file comment should be updated too:
"NEON" => "NEON and scalar"

> diff --git a/arch/arm/crypto/chacha-scalar-core.S b/arch/arm/crypto/chacha-scalar-core.S
> index 2140319b64a0..0970ae107590 100644
> --- a/arch/arm/crypto/chacha-scalar-core.S
> +++ b/arch/arm/crypto/chacha-scalar-core.S
> @@ -41,14 +41,6 @@
>  	X14	.req	r12
>  	X15	.req	r14
>  
> -.Lexpand_32byte_k:
> -	// "expand 32-byte k"
> -	.word	0x61707865, 0x3320646e, 0x79622d32, 0x6b206574
> -
> -#ifdef __thumb2__
> -#  define adrl adr
> -#endif
> -
>  .macro __rev		out, in,  t0, t1, t2
>  .if __LINUX_ARM_ARCH__ >= 6
>  	rev		\out, \in
> @@ -391,61 +383,65 @@
>  .endm	// _chacha
>  
>  /*
> - * void chacha20_arm(u8 *out, const u8 *in, size_t len, const u32 key[8],
> - *		     const u32 iv[4]);
> + * void chacha_doarm(u8 *dst, const u8 *src, unsigned int bytes,
> + *		     u32 *state, int nrounds);
>   */

The comment should say 'const u32 *state' instead of 'u32 *state', to match the
C prototype and to avoid confusion about whether the block counter is
incremented or not.

- Eric
