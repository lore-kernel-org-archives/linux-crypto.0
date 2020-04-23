Return-Path: <SRS0=jAnl=6H=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D028C54FD0
	for <linux-crypto@archiver.kernel.org>; Thu, 23 Apr 2020 07:18:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 61E5B215A4
	for <linux-crypto@archiver.kernel.org>; Thu, 23 Apr 2020 07:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1587626309;
	bh=0iyz3mpVReiWaG+oNcaNP6x3d3ACaosPBWbGDC8HypU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=zXPuz3YbysFbBWUSw0Ht0KGwC/66T092zwoUW3oGzcKxRn2OEqfTAFJ9TKIUGyYI4
	 IZAw1sCfR2v0qDVNS+G3Je43imCazE5+mMjaOePLkf2pMd7Rav2YrzETd3xq4K4+Tf
	 pKhSOCVmJu7T6ekjWGgl5nbPErITD3gtreTE0kf4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725863AbgDWHS2 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 23 Apr 2020 03:18:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:57296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725562AbgDWHS2 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 23 Apr 2020 03:18:28 -0400
Received: from mail-il1-f180.google.com (mail-il1-f180.google.com [209.85.166.180])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 66D4821655;
        Thu, 23 Apr 2020 07:18:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587626307;
        bh=0iyz3mpVReiWaG+oNcaNP6x3d3ACaosPBWbGDC8HypU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=i2hHMH0SQGsGIJ1CzB0ZqdY6soahcQX0RaJ7R4mnmg5sCmheuh3I+eFhb2peGpnOq
         yBllFT18Jqo8IMgeGQ+3enhMcS6nLVkzQmq1/coJB+L0d/VubJdoth9RREHaRqmXAV
         9GQ1rS/l/VZ5Kpmu3+lFw4qHueXyE+4aIyUv5NxY=
Received: by mail-il1-f180.google.com with SMTP id i16so4572451ils.12;
        Thu, 23 Apr 2020 00:18:27 -0700 (PDT)
X-Gm-Message-State: AGi0Puae3sbPylBEXezC2U4TRxwq4GbXA+fh6reIFOHPLCzQ8rl/oV7r
        8WePsad2V38DP5nN12JAPQNWheDoIzg9y3vJBgs=
X-Google-Smtp-Source: APiQypK6ybgyCg+HeEB8tLs1DDsdqKgs3skyxt4iNWWfhPCJfw+PcaqZZ8O/nwFGQkip9Q/VtK7Uj8lODrczfKa68RY=
X-Received: by 2002:a92:39dd:: with SMTP id h90mr2176332ilf.80.1587626306703;
 Thu, 23 Apr 2020 00:18:26 -0700 (PDT)
MIME-Version: 1.0
References: <20200422200344.239462-1-Jason@zx2c4.com> <20200422231854.675965-1-Jason@zx2c4.com>
In-Reply-To: <20200422231854.675965-1-Jason@zx2c4.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Thu, 23 Apr 2020 09:18:15 +0200
X-Gmail-Original-Message-ID: <CAMj1kXHV=ryaFmj0jhQVGBd31nfHs7q5RtSyu7dY6GdEJJsr7A@mail.gmail.com>
Message-ID: <CAMj1kXHV=ryaFmj0jhQVGBd31nfHs7q5RtSyu7dY6GdEJJsr7A@mail.gmail.com>
Subject: Re: [PATCH crypto-stable v3 1/2] crypto: arch/lib - limit simd usage
 to 4k chunks
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-rt-users@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

FYI: you shouldn't cc stable@vger.kernel.org directly on your patches,
or add the cc: line. Only patches that are already in Linus' tree
should be sent there.

Also, the fixes tags are really quite sufficient. In fact, it is
actually rather difficult these days to prevent something from being
taken into -stable if the bots notice that it applies cleanly.

On Thu, 23 Apr 2020 at 01:19, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> The initial Zinc patchset, after some mailing list discussion, contained
> code to ensure that kernel_fpu_enable would not be kept on for more than
> a 4k chunk, since it disables preemption. The choice of 4k isn't totally
> scientific, but it's not a bad guess either, and it's what's used in
> both the x86 poly1305, blake2s, and nhpoly1305 code already (in the form
> of PAGE_SIZE, which this commit corrects to be explicitly 4k for the
> former two).
>
> Ard did some back of the envelope calculations and found that
> at 5 cycles/byte (overestimate) on a 1ghz processor (pretty slow), 4k
> means we have a maximum preemption disabling of 20us, which Sebastian
> confirmed was probably a good limit.
>
> Unfortunately the chunking appears to have been left out of the final
> patchset that added the glue code. So, this commit adds it back in.
>
> Fixes: 84e03fa39fbe ("crypto: x86/chacha - expose SIMD ChaCha routine as library function")
> Fixes: b3aad5bad26a ("crypto: arm64/chacha - expose arm64 ChaCha routine as library function")
> Fixes: a44a3430d71b ("crypto: arm/chacha - expose ARM ChaCha routine as library function")
> Fixes: d7d7b8535662 ("crypto: x86/poly1305 - wire up faster implementations for kernel")
> Fixes: f569ca164751 ("crypto: arm64/poly1305 - incorporate OpenSSL/CRYPTOGAMS NEON implementation")
> Fixes: a6b803b3ddc7 ("crypto: arm/poly1305 - incorporate OpenSSL/CRYPTOGAMS NEON implementation")
> Fixes: ed0356eda153 ("crypto: blake2s - x86_64 SIMD implementation")
> Cc: Eric Biggers <ebiggers@google.com>
> Cc: Ard Biesheuvel <ardb@kernel.org>
> Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Cc: stable@vger.kernel.org
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>

Reviewed-by: Ard Biesheuvel <ardb@kernel.org>

Thanks for cleaning this up

> ---
> Changes v2->v3:
>  - [Eric] Split nhpoly1305 changes into separate commit, since it's not
>    related to the library interface.
>
> Changes v1->v2:
>  - [Ard] Use explicit 4k chunks instead of PAGE_SIZE.
>  - [Eric] Prefer do-while over for (;;).
>
>  arch/arm/crypto/chacha-glue.c        | 14 +++++++++++---
>  arch/arm/crypto/poly1305-glue.c      | 15 +++++++++++----
>  arch/arm64/crypto/chacha-neon-glue.c | 14 +++++++++++---
>  arch/arm64/crypto/poly1305-glue.c    | 15 +++++++++++----
>  arch/x86/crypto/blake2s-glue.c       | 10 ++++------
>  arch/x86/crypto/chacha_glue.c        | 14 +++++++++++---
>  arch/x86/crypto/poly1305_glue.c      | 13 ++++++-------
>  7 files changed, 65 insertions(+), 30 deletions(-)
>
> diff --git a/arch/arm/crypto/chacha-glue.c b/arch/arm/crypto/chacha-glue.c
> index 6fdb0ac62b3d..59da6c0b63b6 100644
> --- a/arch/arm/crypto/chacha-glue.c
> +++ b/arch/arm/crypto/chacha-glue.c
> @@ -91,9 +91,17 @@ void chacha_crypt_arch(u32 *state, u8 *dst, const u8 *src, unsigned int bytes,
>                 return;
>         }
>
> -       kernel_neon_begin();
> -       chacha_doneon(state, dst, src, bytes, nrounds);
> -       kernel_neon_end();
> +       do {
> +               unsigned int todo = min_t(unsigned int, bytes, SZ_4K);
> +
> +               kernel_neon_begin();
> +               chacha_doneon(state, dst, src, todo, nrounds);
> +               kernel_neon_end();
> +
> +               bytes -= todo;
> +               src += todo;
> +               dst += todo;
> +       } while (bytes);
>  }
>  EXPORT_SYMBOL(chacha_crypt_arch);
>
> diff --git a/arch/arm/crypto/poly1305-glue.c b/arch/arm/crypto/poly1305-glue.c
> index ceec04ec2f40..13cfef4ae22e 100644
> --- a/arch/arm/crypto/poly1305-glue.c
> +++ b/arch/arm/crypto/poly1305-glue.c
> @@ -160,13 +160,20 @@ void poly1305_update_arch(struct poly1305_desc_ctx *dctx, const u8 *src,
>                 unsigned int len = round_down(nbytes, POLY1305_BLOCK_SIZE);
>
>                 if (static_branch_likely(&have_neon) && do_neon) {
> -                       kernel_neon_begin();
> -                       poly1305_blocks_neon(&dctx->h, src, len, 1);
> -                       kernel_neon_end();
> +                       do {
> +                               unsigned int todo = min_t(unsigned int, len, SZ_4K);
> +
> +                               kernel_neon_begin();
> +                               poly1305_blocks_neon(&dctx->h, src, todo, 1);
> +                               kernel_neon_end();
> +
> +                               len -= todo;
> +                               src += todo;
> +                       } while (len);
>                 } else {
>                         poly1305_blocks_arm(&dctx->h, src, len, 1);
> +                       src += len;
>                 }
> -               src += len;
>                 nbytes %= POLY1305_BLOCK_SIZE;
>         }
>
> diff --git a/arch/arm64/crypto/chacha-neon-glue.c b/arch/arm64/crypto/chacha-neon-glue.c
> index 37ca3e889848..af2bbca38e70 100644
> --- a/arch/arm64/crypto/chacha-neon-glue.c
> +++ b/arch/arm64/crypto/chacha-neon-glue.c
> @@ -87,9 +87,17 @@ void chacha_crypt_arch(u32 *state, u8 *dst, const u8 *src, unsigned int bytes,
>             !crypto_simd_usable())
>                 return chacha_crypt_generic(state, dst, src, bytes, nrounds);
>
> -       kernel_neon_begin();
> -       chacha_doneon(state, dst, src, bytes, nrounds);
> -       kernel_neon_end();
> +       do {
> +               unsigned int todo = min_t(unsigned int, bytes, SZ_4K);
> +
> +               kernel_neon_begin();
> +               chacha_doneon(state, dst, src, todo, nrounds);
> +               kernel_neon_end();
> +
> +               bytes -= todo;
> +               src += todo;
> +               dst += todo;
> +       } while (bytes);
>  }
>  EXPORT_SYMBOL(chacha_crypt_arch);
>
> diff --git a/arch/arm64/crypto/poly1305-glue.c b/arch/arm64/crypto/poly1305-glue.c
> index e97b092f56b8..f33ada70c4ed 100644
> --- a/arch/arm64/crypto/poly1305-glue.c
> +++ b/arch/arm64/crypto/poly1305-glue.c
> @@ -143,13 +143,20 @@ void poly1305_update_arch(struct poly1305_desc_ctx *dctx, const u8 *src,
>                 unsigned int len = round_down(nbytes, POLY1305_BLOCK_SIZE);
>
>                 if (static_branch_likely(&have_neon) && crypto_simd_usable()) {
> -                       kernel_neon_begin();
> -                       poly1305_blocks_neon(&dctx->h, src, len, 1);
> -                       kernel_neon_end();
> +                       do {
> +                               unsigned int todo = min_t(unsigned int, len, SZ_4K);
> +
> +                               kernel_neon_begin();
> +                               poly1305_blocks_neon(&dctx->h, src, todo, 1);
> +                               kernel_neon_end();
> +
> +                               len -= todo;
> +                               src += todo;
> +                       } while (len);
>                 } else {
>                         poly1305_blocks(&dctx->h, src, len, 1);
> +                       src += len;
>                 }
> -               src += len;
>                 nbytes %= POLY1305_BLOCK_SIZE;
>         }
>
> diff --git a/arch/x86/crypto/blake2s-glue.c b/arch/x86/crypto/blake2s-glue.c
> index 06ef2d4a4701..6737bcea1fa1 100644
> --- a/arch/x86/crypto/blake2s-glue.c
> +++ b/arch/x86/crypto/blake2s-glue.c
> @@ -32,16 +32,16 @@ void blake2s_compress_arch(struct blake2s_state *state,
>                            const u32 inc)
>  {
>         /* SIMD disables preemption, so relax after processing each page. */
> -       BUILD_BUG_ON(PAGE_SIZE / BLAKE2S_BLOCK_SIZE < 8);
> +       BUILD_BUG_ON(SZ_4K / BLAKE2S_BLOCK_SIZE < 8);
>
>         if (!static_branch_likely(&blake2s_use_ssse3) || !crypto_simd_usable()) {
>                 blake2s_compress_generic(state, block, nblocks, inc);
>                 return;
>         }
>
> -       for (;;) {
> +       do {
>                 const size_t blocks = min_t(size_t, nblocks,
> -                                           PAGE_SIZE / BLAKE2S_BLOCK_SIZE);
> +                                           SZ_4K / BLAKE2S_BLOCK_SIZE);
>
>                 kernel_fpu_begin();
>                 if (IS_ENABLED(CONFIG_AS_AVX512) &&
> @@ -52,10 +52,8 @@ void blake2s_compress_arch(struct blake2s_state *state,
>                 kernel_fpu_end();
>
>                 nblocks -= blocks;
> -               if (!nblocks)
> -                       break;
>                 block += blocks * BLAKE2S_BLOCK_SIZE;
> -       }
> +       } while (nblocks);
>  }
>  EXPORT_SYMBOL(blake2s_compress_arch);
>
> diff --git a/arch/x86/crypto/chacha_glue.c b/arch/x86/crypto/chacha_glue.c
> index b412c21ee06e..22250091cdbe 100644
> --- a/arch/x86/crypto/chacha_glue.c
> +++ b/arch/x86/crypto/chacha_glue.c
> @@ -153,9 +153,17 @@ void chacha_crypt_arch(u32 *state, u8 *dst, const u8 *src, unsigned int bytes,
>             bytes <= CHACHA_BLOCK_SIZE)
>                 return chacha_crypt_generic(state, dst, src, bytes, nrounds);
>
> -       kernel_fpu_begin();
> -       chacha_dosimd(state, dst, src, bytes, nrounds);
> -       kernel_fpu_end();
> +       do {
> +               unsigned int todo = min_t(unsigned int, bytes, SZ_4K);
> +
> +               kernel_fpu_begin();
> +               chacha_dosimd(state, dst, src, todo, nrounds);
> +               kernel_fpu_end();
> +
> +               bytes -= todo;
> +               src += todo;
> +               dst += todo;
> +       } while (bytes);
>  }
>  EXPORT_SYMBOL(chacha_crypt_arch);
>
> diff --git a/arch/x86/crypto/poly1305_glue.c b/arch/x86/crypto/poly1305_glue.c
> index 6dfec19f7d57..dfe921efa9b2 100644
> --- a/arch/x86/crypto/poly1305_glue.c
> +++ b/arch/x86/crypto/poly1305_glue.c
> @@ -91,8 +91,8 @@ static void poly1305_simd_blocks(void *ctx, const u8 *inp, size_t len,
>         struct poly1305_arch_internal *state = ctx;
>
>         /* SIMD disables preemption, so relax after processing each page. */
> -       BUILD_BUG_ON(PAGE_SIZE < POLY1305_BLOCK_SIZE ||
> -                    PAGE_SIZE % POLY1305_BLOCK_SIZE);
> +       BUILD_BUG_ON(SZ_4K < POLY1305_BLOCK_SIZE ||
> +                    SZ_4K % POLY1305_BLOCK_SIZE);
>
>         if (!static_branch_likely(&poly1305_use_avx) ||
>             (len < (POLY1305_BLOCK_SIZE * 18) && !state->is_base2_26) ||
> @@ -102,8 +102,8 @@ static void poly1305_simd_blocks(void *ctx, const u8 *inp, size_t len,
>                 return;
>         }
>
> -       for (;;) {
> -               const size_t bytes = min_t(size_t, len, PAGE_SIZE);
> +       do {
> +               const size_t bytes = min_t(size_t, len, SZ_4K);
>
>                 kernel_fpu_begin();
>                 if (IS_ENABLED(CONFIG_AS_AVX512) && static_branch_likely(&poly1305_use_avx512))
> @@ -113,11 +113,10 @@ static void poly1305_simd_blocks(void *ctx, const u8 *inp, size_t len,
>                 else
>                         poly1305_blocks_avx(ctx, inp, bytes, padbit);
>                 kernel_fpu_end();
> +
>                 len -= bytes;
> -               if (!len)
> -                       break;
>                 inp += bytes;
> -       }
> +       } while (len);
>  }
>
>  static void poly1305_simd_emit(void *ctx, u8 mac[POLY1305_DIGEST_SIZE],
> --
> 2.26.2
>
