Return-Path: <SRS0=Ux5j=YQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B279CA9EAE
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Oct 2019 04:55:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 02A0721872
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Oct 2019 04:55:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1571806515;
	bh=8NH05dDT3eYNBoIIpPGFvDsgZMQzmpKZtWtmh7MTmHU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=baT5uOHWX/s6Wrt1cN/I7Rj2FFbLxd6ksA8LjRTWcmoVmT9qlmxAl+4ju+4dgz62x
	 hbPyaUWhhD2ROK9qPKIVxZR0PY5cu+85vz8Lgzmu77eD7MIVxjBCB42bU3ysHcx/84
	 PqSwS9pzRrc9xfXSszBydJVJ4+lMG0Gdtk1QymK8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733186AbfJWEzO (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Oct 2019 00:55:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:59910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732261AbfJWEzO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Oct 2019 00:55:14 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 917742173B;
        Wed, 23 Oct 2019 04:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571806512;
        bh=8NH05dDT3eYNBoIIpPGFvDsgZMQzmpKZtWtmh7MTmHU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UCyo+gUa2BBD7ABJxvnHqgclWwhlApBYITkBU3ezTydP9NkQ6D0lzSM0CLHk2RSd0
         LK+TmOsPyu651fNV050istYfS+iHhlUeyelc2CczpeUlnLUpcMpK64D2Rb4Ss988Ci
         GY2bTcHCfP8g4R4063qL7SiDhagtRdBTTiBwsQKM=
Date:   Tue, 22 Oct 2019 21:55:11 -0700
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
Subject: Re: [PATCH v4 25/35] crypto: BLAKE2s - x86_64 SIMD implementation
Message-ID: <20191023045511.GC361298@sol.localdomain>
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
 <20191017190932.1947-26-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191017190932.1947-26-ard.biesheuvel@linaro.org>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Oct 17, 2019 at 09:09:22PM +0200, Ard Biesheuvel wrote:
> From: "Jason A. Donenfeld" <Jason@zx2c4.com>
> 
> These implementations from Samuel Neves support AVX and AVX-512VL.
> Originally this used AVX-512F, but Skylake thermal throttling made
> AVX-512VL more attractive and possible to do with negligable difference.
> 
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> Signed-off-by: Samuel Neves <sneves@dei.uc.pt>
> Co-developed-by: Samuel Neves <sneves@dei.uc.pt>
> [ardb: move to arch/x86/crypto, wire into lib/crypto framework]
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>  arch/x86/crypto/Makefile       |   2 +
>  arch/x86/crypto/blake2s-core.S | 685 ++++++++++++++++++++
>  arch/x86/crypto/blake2s-glue.c | 235 +++++++
>  crypto/Kconfig                 |   6 +
>  4 files changed, 928 insertions(+)
> 
> diff --git a/arch/x86/crypto/Makefile b/arch/x86/crypto/Makefile
> index 759b1a927826..922c8ecfa00f 100644
> --- a/arch/x86/crypto/Makefile
> +++ b/arch/x86/crypto/Makefile
> @@ -48,6 +48,7 @@ ifeq ($(avx_supported),yes)
>  	obj-$(CONFIG_CRYPTO_CAST6_AVX_X86_64) += cast6-avx-x86_64.o
>  	obj-$(CONFIG_CRYPTO_TWOFISH_AVX_X86_64) += twofish-avx-x86_64.o
>  	obj-$(CONFIG_CRYPTO_SERPENT_AVX_X86_64) += serpent-avx-x86_64.o
> +	obj-$(CONFIG_CRYPTO_BLAKE2S_X86) += blake2s-x86_64.o
>  endif
>  
>  # These modules require assembler to support AVX2.
> @@ -70,6 +71,7 @@ serpent-sse2-x86_64-y := serpent-sse2-x86_64-asm_64.o serpent_sse2_glue.o
>  aegis128-aesni-y := aegis128-aesni-asm.o aegis128-aesni-glue.o
>  
>  nhpoly1305-sse2-y := nh-sse2-x86_64.o nhpoly1305-sse2-glue.o
> +blake2s-x86_64-y := blake2s-core.o blake2s-glue.o
>  
>  ifeq ($(avx_supported),yes)
>  	camellia-aesni-avx-x86_64-y := camellia-aesni-avx-asm_64.o \
> diff --git a/arch/x86/crypto/blake2s-core.S b/arch/x86/crypto/blake2s-core.S
> new file mode 100644
> index 000000000000..675288fa4cca
> --- /dev/null
> +++ b/arch/x86/crypto/blake2s-core.S
> @@ -0,0 +1,685 @@
> +/* SPDX-License-Identifier: GPL-2.0 OR MIT */
> +/*
> + * Copyright (C) 2015-2019 Jason A. Donenfeld <Jason@zx2c4.com>. All Rights Reserved.
> + * Copyright (C) 2017 Samuel Neves <sneves@dei.uc.pt>. All Rights Reserved.
> + */
> +
> +#include <linux/linkage.h>
> +
> +.section .rodata.cst32.BLAKE2S_IV, "aM", @progbits, 32
> +.align 32
> +IV:	.octa 0xA54FF53A3C6EF372BB67AE856A09E667
> +	.octa 0x5BE0CD191F83D9AB9B05688C510E527F
> +.section .rodata.cst16.ROT16, "aM", @progbits, 16
> +.align 16
> +ROT16:	.octa 0x0D0C0F0E09080B0A0504070601000302
> +.section .rodata.cst16.ROR328, "aM", @progbits, 16
> +.align 16
> +ROR328:	.octa 0x0C0F0E0D080B0A090407060500030201
> +#ifdef CONFIG_AS_AVX512
> +.section .rodata.cst64.BLAKE2S_SIGMA, "aM", @progbits, 640
> +.align 64
> +SIGMA:
> +.long 0, 2, 4, 6, 1, 3, 5, 7, 8, 10, 12, 14, 9, 11, 13, 15
> +.long 11, 2, 12, 14, 9, 8, 15, 3, 4, 0, 13, 6, 10, 1, 7, 5
> +.long 10, 12, 11, 6, 5, 9, 13, 3, 4, 15, 14, 2, 0, 7, 8, 1
> +.long 10, 9, 7, 0, 11, 14, 1, 12, 6, 2, 15, 3, 13, 8, 5, 4
> +.long 4, 9, 8, 13, 14, 0, 10, 11, 7, 3, 12, 1, 5, 6, 15, 2
> +.long 2, 10, 4, 14, 13, 3, 9, 11, 6, 5, 7, 12, 15, 1, 8, 0
> +.long 4, 11, 14, 8, 13, 10, 12, 5, 2, 1, 15, 3, 9, 7, 0, 6
> +.long 6, 12, 0, 13, 15, 2, 1, 10, 4, 5, 11, 14, 8, 3, 9, 7
> +.long 14, 5, 4, 12, 9, 7, 3, 10, 2, 0, 6, 15, 11, 1, 13, 8
> +.long 11, 7, 13, 10, 12, 14, 0, 15, 4, 5, 6, 9, 2, 1, 8, 3
> +#endif /* CONFIG_AS_AVX512 */
> +
> +.text
> +#ifdef CONFIG_AS_AVX
> +ENTRY(blake2s_compress_avx)
> +	movl		%ecx, %ecx
> +	testq		%rdx, %rdx
> +	je		.Lendofloop
> +	.align 32
> +.Lbeginofloop:
> +	addq		%rcx, 32(%rdi)
> +	vmovdqu		IV+16(%rip), %xmm1
> +	vmovdqu		(%rsi), %xmm4
> +	vpxor		32(%rdi), %xmm1, %xmm1
> +	vmovdqu		16(%rsi), %xmm3
> +	vshufps		$136, %xmm3, %xmm4, %xmm6
> +	vmovdqa		ROT16(%rip), %xmm7
> +	vpaddd		(%rdi), %xmm6, %xmm6
> +	vpaddd		16(%rdi), %xmm6, %xmm6
> +	vpxor		%xmm6, %xmm1, %xmm1
> +	vmovdqu		IV(%rip), %xmm8
> +	vpshufb		%xmm7, %xmm1, %xmm1
> +	vmovdqu		48(%rsi), %xmm5
> +	vpaddd		%xmm1, %xmm8, %xmm8
> +	vpxor		16(%rdi), %xmm8, %xmm9
> +	vmovdqu		32(%rsi), %xmm2
> +	vpblendw	$12, %xmm3, %xmm5, %xmm13
> +	vshufps		$221, %xmm5, %xmm2, %xmm12
> +	vpunpckhqdq	%xmm2, %xmm4, %xmm14
> +	vpslld		$20, %xmm9, %xmm0
> +	vpsrld		$12, %xmm9, %xmm9
> +	vpxor		%xmm0, %xmm9, %xmm0
> +	vshufps		$221, %xmm3, %xmm4, %xmm9
> +	vpaddd		%xmm9, %xmm6, %xmm9
> +	vpaddd		%xmm0, %xmm9, %xmm9
> +	vpxor		%xmm9, %xmm1, %xmm1
> +	vmovdqa		ROR328(%rip), %xmm6
> +	vpshufb		%xmm6, %xmm1, %xmm1
> +	vpaddd		%xmm1, %xmm8, %xmm8
> +	vpxor		%xmm8, %xmm0, %xmm0
> +	vpshufd		$147, %xmm1, %xmm1
> +	vpshufd		$78, %xmm8, %xmm8
> +	vpslld		$25, %xmm0, %xmm10
> +	vpsrld		$7, %xmm0, %xmm0
> +	vpxor		%xmm10, %xmm0, %xmm0
> +	vshufps		$136, %xmm5, %xmm2, %xmm10
> +	vpshufd		$57, %xmm0, %xmm0
> +	vpaddd		%xmm10, %xmm9, %xmm9
> +	vpaddd		%xmm0, %xmm9, %xmm9
> +	vpxor		%xmm9, %xmm1, %xmm1
> +	vpaddd		%xmm12, %xmm9, %xmm9
> +	vpblendw	$12, %xmm2, %xmm3, %xmm12
> +	vpshufb		%xmm7, %xmm1, %xmm1
> +	vpaddd		%xmm1, %xmm8, %xmm8
> +	vpxor		%xmm8, %xmm0, %xmm10
> +	vpslld		$20, %xmm10, %xmm0
> +	vpsrld		$12, %xmm10, %xmm10
> +	vpxor		%xmm0, %xmm10, %xmm0
> +	vpaddd		%xmm0, %xmm9, %xmm9
> +	vpxor		%xmm9, %xmm1, %xmm1
> +	vpshufb		%xmm6, %xmm1, %xmm1
> +	vpaddd		%xmm1, %xmm8, %xmm8
[...]

There are no comments in this 685-line assembly language file.
Is this the original version, or is it a generated/stripped version?

- Eric
