Return-Path: <SRS0=aDvo=PQ=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-it1-f196.google.com ([209.85.166.196]:55519 "EHLO
        mail-it1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726333AbfAHIVi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 8 Jan 2019 03:21:38 -0500
Received: by mail-it1-f196.google.com with SMTP id m62so5086407ith.5
        for <linux-crypto@vger.kernel.org>; Tue, 08 Jan 2019 00:21:37 -0800 (PST)
MIME-Version: 1.0
References: <20190107231559.13357-1-ebiggers@kernel.org>
In-Reply-To: <20190107231559.13357-1-ebiggers@kernel.org>
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Tue, 8 Jan 2019 09:21:24 +0100
Message-ID: <CAKv+Gu-ZMiyXfG_mkdbQh7Mh=J1XG+k-jrtDZ_2S2F5_JaXRSA@mail.gmail.com>
Subject: Re: [PATCH 4.9,4.4] crypto: x86/chacha20 - avoid sleeping with
 preemption disabled
To: Eric Biggers <ebiggers@kernel.org>
Cc: stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>,
        Martin Willi <martin@strongswan.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, 8 Jan 2019 at 00:16, Eric Biggers <ebiggers@kernel.org> wrote:
>
> From: Eric Biggers <ebiggers@google.com>
>
> Hi Greg, please consider applying this to 4.9-stable and 4.4-stable.
> It's a minimal fix for a bug that was fixed incidentally by a large
> refactoring in v4.11.
>
> >8------------------------------------------------------8<
>
> In chacha20-simd, clear the MAY_SLEEP flag in the blkcipher_desc to
> prevent sleeping with preemption disabled, under kernel_fpu_begin().
>
> This was fixed upstream incidentally by a large refactoring,
> commit 9ae433bc79f9 ("crypto: chacha20 - convert generic and x86
> versions to skcipher").  But syzkaller easily trips over this when
> running on older kernels, as it's easily reachable via AF_ALG.
> Therefore, this patch makes the minimal fix for older kernels.
>
> Fixes: c9320b6dcb89 ("crypto: chacha20 - Add a SSSE3 SIMD variant for x86_64")
> Cc: linux-crypto@vger.kernel.org
> Cc: Martin Willi <martin@strongswan.org>
> Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

> ---
>  arch/x86/crypto/chacha20_glue.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/arch/x86/crypto/chacha20_glue.c b/arch/x86/crypto/chacha20_glue.c
> index f910d1d449f00..0a5fedf43bdc8 100644
> --- a/arch/x86/crypto/chacha20_glue.c
> +++ b/arch/x86/crypto/chacha20_glue.c
> @@ -77,6 +77,7 @@ static int chacha20_simd(struct blkcipher_desc *desc, struct scatterlist *dst,
>
>         blkcipher_walk_init(&walk, dst, src, nbytes);
>         err = blkcipher_walk_virt_block(desc, &walk, CHACHA20_BLOCK_SIZE);
> +       desc->flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
>
>         crypto_chacha20_init(state, crypto_blkcipher_ctx(desc->tfm), walk.iv);
>
> --
> 2.20.1.97.g81188d93c3-goog
>
