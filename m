From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH 0/6] crypto: arm64 - big endian fixes
Date: Mon, 10 Oct 2016 12:26:00 +0100
Message-ID: <CAKv+Gu9Nj5ccpRpgqg9Ohif4=k5+dAVuP8tKtNEj9_z7BQ_jjQ@mail.gmail.com>
References: <1476034945-9186-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-it0-f48.google.com ([209.85.214.48]:37403 "EHLO
        mail-it0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751387AbcJJL0B (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 10 Oct 2016 07:26:01 -0400
Received: by mail-it0-f48.google.com with SMTP id z65so67303932itc.0
        for <linux-crypto@vger.kernel.org>; Mon, 10 Oct 2016 04:26:01 -0700 (PDT)
In-Reply-To: <1476034945-9186-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 9 October 2016 at 18:42, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> As it turns out, none of the accelerated crypto routines under arch/arm64/crypto
> currently work, or have ever worked correctly when built for big endian. So this
> series fixes all of them.
>
> Each of these patches carries a fixes tag, and could be backported to stable.
> However, for patches #1 and #5, the fixes tag denotes the oldest commit that the
> fix is compatible with, not the patch that introduced the algorithm. This is due
> to the fact that the key schedules are incompatible between generic AES and the
> arm64 Crypto Extensions implementation (but only when building for big endian)
> This is not a problem in practice, but it does mean that the AES-CCM and AES in
> EBC/CBC/CTR/XTS mode implementations before v3.19 require a different fix, i.e.,
> one that is compatible with the generic AES key schedule generation code (which
> it currently no longer uses)
>
> In any case, please apply with cc to stable.
>

Herbert,

I have an additional fix to add to this series, and a couple for
32-bit ARM as well. They escaped my attention due to this code (in
algboss.c:250)

/* This piece of crap needs to disappear into per-type test hooks. */
if (!((type ^ CRYPTO_ALG_TYPE_BLKCIPHER) &
     CRYPTO_ALG_TYPE_BLKCIPHER_MASK) && !(type & CRYPTO_ALG_GENIV) &&
   ((alg->cra_flags & CRYPTO_ALG_TYPE_MASK) ==
    CRYPTO_ALG_TYPE_BLKCIPHER ? alg->cra_blkcipher.ivsize :
alg->cra_ablkcipher.ivsize))
type |= CRYPTO_ALG_TESTED;

This causes cbc(aes), ctr(aes) and xts(aes) to remain untested, unless
I add CRYPTO_ALG_GENIV to their cra_flags. Is this expected behavior?
What would be your recommended way to ensure these algos are covered
by the boottime tests?

Thanks,
Ard.
