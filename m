From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 4/4] crypto: arm/crct10dif - port x86 SSE implementation
 to ARM
Date: Mon, 28 Nov 2016 21:17:48 +0800
Message-ID: <20161128131748.GA2757@gondor.apana.org.au>
References: <1480002201-1427-1-git-send-email-ard.biesheuvel@linaro.org>
 <1480002201-1427-5-git-send-email-ard.biesheuvel@linaro.org>
 <CAKv+Gu8tPfX76ntdQmMz53waE73RHfB11oRs8w=Ufy7d=YqbGA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Steve Capper <steve.capper@linaro.org>,
        dingtinahong <dingtianhong@huawei.com>, yangshengkai@huawei.com,
        YueHaibing <yuehaibing@huawei.com>,
        Hanjun Guo <hanjun.guo@linaro.org>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:49976 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754756AbcK1NSI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 28 Nov 2016 08:18:08 -0500
Content-Disposition: inline
In-Reply-To: <CAKv+Gu8tPfX76ntdQmMz53waE73RHfB11oRs8w=Ufy7d=YqbGA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Nov 24, 2016 at 05:32:42PM +0000, Ard Biesheuvel wrote:
> On 24 November 2016 at 15:43, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> > This is a straight transliteration of the Intel algorithm implemented
> > using SSE and PCLMULQDQ instructions that resides under in the file
> > arch/x86/crypto/crct10dif-pcl-asm_64.S.
> >
> > Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> > ---
> >  arch/arm/crypto/Kconfig                        |   5 +
> >  arch/arm/crypto/Makefile                       |   2 +
> >  arch/{arm64 => arm}/crypto/crct10dif-ce-core.S | 457 +++++++++++---------
> >  arch/{arm64 => arm}/crypto/crct10dif-ce-glue.c |  23 +-
> >  4 files changed, 277 insertions(+), 210 deletions(-)
> >
> 
> This patch needs the following hunk folded in to avoid breaking the
> Thumb2 build:
> 
> """
> diff --git a/arch/arm/crypto/crct10dif-ce-core.S
> b/arch/arm/crypto/crct10dif-ce-core.S
> index 30168b0f8581..4fdbca94dd0c 100644
> --- a/arch/arm/crypto/crct10dif-ce-core.S
> +++ b/arch/arm/crypto/crct10dif-ce-core.S
> @@ -152,7 +152,8 @@ CPU_LE(     vrev64.8        q7, q7                  )
>         // XOR the initial_crc value
>         veor.8          q0, q0, q10
> 
> -       adrl            ip, rk3
> +ARM(   adrl            ip, rk3         )
> +THUMB( adr             ip, rk3         )
>         vld1.64         {q10}, [ip]     // xmm10 has rk3 and rk4
>                                         // type of pmull instruction
>                                         // will determine which constant to use
> """

I'm sorry but this patch doesn't apply on top of the other four.
So please resend the whole series.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
