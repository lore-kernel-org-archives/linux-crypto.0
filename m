Return-Path: <SRS0=sLqA=CY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53302C43461
	for <linux-crypto@archiver.kernel.org>; Tue, 15 Sep 2020 18:51:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 11AC8206E6
	for <linux-crypto@archiver.kernel.org>; Tue, 15 Sep 2020 18:51:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="shIV9H0f"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727537AbgIOSvC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 15 Sep 2020 14:51:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727900AbgIOSun (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 15 Sep 2020 14:50:43 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E511C06174A
        for <linux-crypto@vger.kernel.org>; Tue, 15 Sep 2020 11:50:16 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id d6so2464263pfn.9
        for <linux-crypto@vger.kernel.org>; Tue, 15 Sep 2020 11:50:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ODy9rHkdZnLwIVksI2gu0nYU7zSOi3bLIQQhZWmEJ2s=;
        b=shIV9H0fpv3UWagnNEnsBZZ4AqyGwh81DOm8gRZLT1MFmAVNcX6nzOY7dznWF0ppY2
         2deOJObOu2v5Ysg59UqGnpCFlQW17yyfO3g4xZ63fqjdQ+6SPJR5rJzqGHboiQ6Uh3Wd
         +yYYeZ3L4Guq7lxLsixhP1KsKXzClxWwV+CSRSmAPyjM39Lupod/41IqIwerkses5dZh
         qkM1CrF6U0u+LtL1eC2YO0bwbv94MjgCN1FchYGx6+4ERKhs4U2EJIBPV+k0hJc8loac
         oO135CVotzusxX60jU7mPGngHU65FaoMWmAXt7un7+mspgqjGY7HKSFJeIj6HaxQCJpS
         fptA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ODy9rHkdZnLwIVksI2gu0nYU7zSOi3bLIQQhZWmEJ2s=;
        b=XLzdawBFupBrtneZmvzPpzL6Pc5yHHILTo0HCtV5VN6ZLKZKNtASwEj5HxrHJw/OKi
         RQi8zzwxmPs0nBjkvuoFYSsR3aXrKkPXIa0WzW9UUg9tApK3yBSN4MnlMvLl6yl/7V3P
         lLqzDyP2+EUladbGhrHtHYdXBeIIupnYf94e5s6hGsuhCcapsvy6d9vHy5s7utGd7iPC
         PA2r/YHAvSLqsGWj4d4+BiC6i9ELzASC9BfY+Wfrapk1VPGIhmG55JW6Vx/SVr2MW4SX
         U4bplDpjAxbYEZU0Opc42MiQdlcw8RxY6BW+5PY/LHvt3FCuvad6bnu6UgGagExpllF8
         0SXQ==
X-Gm-Message-State: AOAM531Hr/1t8WNTqKHmC01z0E7zIKLTf6kGA96Nx9030qmGmTjoPaN7
        3qTlkQ0fhzVtwOQ6ktdRuS7uULrnkWevVc8JY/y+3Ah/VEb6eA==
X-Google-Smtp-Source: ABdhPJwwajd5QosydCfiyB4FBl3SVwPliQPgMUI2oOrEG63kK5UiQB+cR7nb3cz3D3sUY3p16RxLvhZxqLMdPp79F5w=
X-Received: by 2002:a62:5586:0:b029:13e:d13d:a108 with SMTP id
 j128-20020a6255860000b029013ed13da108mr18966759pfb.36.1600195814868; Tue, 15
 Sep 2020 11:50:14 -0700 (PDT)
MIME-Version: 1.0
References: <20200915094619.32548-1-ardb@kernel.org>
In-Reply-To: <20200915094619.32548-1-ardb@kernel.org>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Tue, 15 Sep 2020 11:50:01 -0700
Message-ID: <CAKwvOdn90vs-K4gyi47nJOuwc_g0r3p_ytc9ChPEmunCQ1186w@mail.gmail.com>
Subject: Re: [PATCH] crypto: arm/sha256-neon - avoid ADRL pseudo instruction
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Stefan Agner <stefan@agner.ch>,
        Peter Smith <Peter.Smith@arm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Sep 15, 2020 at 2:46 AM Ard Biesheuvel <ardb@kernel.org> wrote:
>
> The ADRL pseudo instruction is not an architectural construct, but a
> convenience macro that was supported by the ARM proprietary assembler
> and adopted by binutils GAS as well, but only when assembling in 32-bit
> ARM mode. Therefore, it can only be used in assembler code that is known
> to assemble in ARM mode only, but as it turns out, the Clang assembler
> does not implement ADRL at all, and so it is better to get rid of it
> entirely.
>
> So replace the ADRL instruction with a ADR instruction that refers to
> a nearer symbol, and apply the delta explicitly using an additional
> instruction.
>
> Cc: Nick Desaulniers <ndesaulniers@google.com>
> Cc: Stefan Agner <stefan@agner.ch>
> Cc: Peter Smith <Peter.Smith@arm.com>
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
> I will leave it to the Clang folks to decide whether this needs to be
> backported and how far, but a Cc stable seems reasonable here.
>
>  arch/arm/crypto/sha256-armv4.pl       | 4 ++--
>  arch/arm/crypto/sha256-core.S_shipped | 4 ++--
>  2 files changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/arch/arm/crypto/sha256-armv4.pl b/arch/arm/crypto/sha256-armv4.pl
> index 9f96ff48e4a8..8aeb2e82f915 100644
> --- a/arch/arm/crypto/sha256-armv4.pl
> +++ b/arch/arm/crypto/sha256-armv4.pl
> @@ -175,7 +175,6 @@ $code=<<___;
>  #else
>  .syntax unified
>  # ifdef __thumb2__
> -#  define adrl adr
>  .thumb
>  # else
>  .code   32
> @@ -471,7 +470,8 @@ sha256_block_data_order_neon:
>         stmdb   sp!,{r4-r12,lr}
>
>         sub     $H,sp,#16*4+16
> -       adrl    $Ktbl,K256
> +       adr     $Ktbl,.Lsha256_block_data_order
> +       add     $Ktbl,$Ktbl,#K256-.Lsha256_block_data_order
>         bic     $H,$H,#15               @ align for 128-bit stores
>         mov     $t2,sp
>         mov     sp,$H                   @ alloca
> diff --git a/arch/arm/crypto/sha256-core.S_shipped b/arch/arm/crypto/sha256-core.S_shipped
> index ea04b2ab0c33..1861c4e8a5ba 100644
> --- a/arch/arm/crypto/sha256-core.S_shipped
> +++ b/arch/arm/crypto/sha256-core.S_shipped
> @@ -56,7 +56,6 @@
>  #else
>  .syntax unified
>  # ifdef __thumb2__
> -#  define adrl adr
>  .thumb
>  # else
>  .code   32
> @@ -1885,7 +1884,8 @@ sha256_block_data_order_neon:
>         stmdb   sp!,{r4-r12,lr}
>
>         sub     r11,sp,#16*4+16
> -       adrl    r14,K256
> +       adr     r14,.Lsha256_block_data_order
> +       add     r14,r14,#K256-.Lsha256_block_data_order

Hi Ard,
Thanks for the patch.  With this patch applied:

$ ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- make LLVM=1 LLVM_IAS=1
-j71 defconfig
$ ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- make LLVM=1 LLVM_IAS=1 -j71
...
arch/arm/crypto/sha256-core.S:2038:2: error: out of range immediate fixup value
 add r14,r14,#K256-.Lsha256_block_data_order
 ^

:(

Would the adr_l macro you wrote in
https://lore.kernel.org/linux-arm-kernel/nycvar.YSQ.7.78.906.2009141003360.4095746@knanqh.ubzr/T/#t
be helpful here?

>         bic     r11,r11,#15             @ align for 128-bit stores
>         mov     r12,sp
>         mov     sp,r11                  @ alloca
> --
> 2.17.1
>


-- 
Thanks,
~Nick Desaulniers
