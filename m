Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-28.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9B58C43461
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Apr 2021 23:36:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 73E3A611BE
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Apr 2021 23:36:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235193AbhDIXgi (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 9 Apr 2021 19:36:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235096AbhDIXgh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Apr 2021 19:36:37 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA7B2C061762
        for <linux-crypto@vger.kernel.org>; Fri,  9 Apr 2021 16:36:22 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id u4so8341450ljo.6
        for <linux-crypto@vger.kernel.org>; Fri, 09 Apr 2021 16:36:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MQEhdxl+cSU7BC7XRTZDcCsNpOwQL3MJhJomrvmkJCY=;
        b=naXn5kfXgRlukFVoSCe/aS9mSub16qMDDnXU0x9NB9VvBXEc/nCg53QsttbiYYoOdy
         NvXp8jYd89b8HUaPN7fRNWO7pgHhHGs0K2z7HvJSpG4ldxCjcMZNSGLrjUXwkFVHREQu
         EkdeDYJ7eqF5tFBnfniDsngW17bsbFPd/pBe5DFNZhQSWnOUt41ATFBagvjygDaOpiYo
         62J7wMp79geIT6GRT+gjXifp+0VcR8gXSKkd4nk/0kY3pkxISXwVA86aOf+t+AdlrKRe
         U7Y/TWL9S15pzXqvCbz7Fo4iNaFjd0uAUUBxFrQUZ7BwZ3283l1O3CNk3bQetk5ztkO4
         RIrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MQEhdxl+cSU7BC7XRTZDcCsNpOwQL3MJhJomrvmkJCY=;
        b=SWcwUC405YZgPMNwW8sWttxJqeK+iUQz/vmK0PlJWXKbpDaevNTLtqn6L84G/CcN+q
         RUXLUcFnIx4nozuOn2FLNPvKWVZ+pQ+xfYa37OzN5+NgtzT06I3d4doIyoYzhNqsRmjJ
         g7jtaCWDcxVKfThXHcygccgRdKWutiPqp8c58hio80M9PA6qSzjeZnA6hjc9TkUFF17o
         FKPkc42yjRlqL/HkVoIgci/XagHgYSxuOOiXyT7PtP1GAG7qz1LD3v+9762iUcJCWYUs
         VLDZ7oKSqkr3zB961wvgwyZA+TR9tXiWnHM5cgYQM5dGKzoHmGtCBIpLks6nCfWwn5lc
         EPhQ==
X-Gm-Message-State: AOAM532KJ0woS3l+DHAmZky/TOBYkzJkz2Kp9wcSs8sA2voXhviTLuDC
        mvmz3DRYuzOruOInG+6jrJ28+OyL2uiCKgMRbhuDpfrxbbU2+8cb
X-Google-Smtp-Source: ABdhPJxPZM+yBj5h9pJP265DYko714wL+M/i9xL4wgwVQK69SoBcfbh2i4JxHFXtqH+bSlHJjvuHtaD+RYSUTCWwTuU=
X-Received: by 2002:a2e:3603:: with SMTP id d3mr10563594lja.495.1618011380903;
 Fri, 09 Apr 2021 16:36:20 -0700 (PDT)
MIME-Version: 1.0
References: <20210409221155.1113205-1-nathan@kernel.org>
In-Reply-To: <20210409221155.1113205-1-nathan@kernel.org>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Fri, 9 Apr 2021 16:36:09 -0700
Message-ID: <CAKwvOdnTFXPy29L5JhcMBJAP4STfZUMn6739Mc4J_2Qwu3efBw@mail.gmail.com>
Subject: Re: [PATCH] crypto: arm/curve25519 - Move '.fpu' after '.arch'
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Ard Biesheuvel <ardb@kernel.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        "# 3.4.x" <stable@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Jessica Clarke <jrtc27@jrtc27.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Apr 9, 2021 at 3:12 PM Nathan Chancellor <nathan@kernel.org> wrote:
>
> Debian's clang carries a patch that makes the default FPU mode
> 'vfp3-d16' instead of 'neon' for 'armv7-a' to avoid generating NEON
> instructions on hardware that does not support them:
>
> https://salsa.debian.org/pkg-llvm-team/llvm-toolchain/-/raw/5a61ca6f21b4ad8c6ac4970e5ea5a7b5b4486d22/debian/patches/clang-arm-default-vfp3-on-armv7a.patch
> https://bugs.debian.org/841474
> https://bugs.debian.org/842142
> https://bugs.debian.org/914268

Another good link would be the one from Jessica describing more
precisely what the ARM targets for Debian are:
https://wiki.debian.org/ArchitectureSpecificsMemo#armel

>
> This results in the following build error when clang's integrated
> assembler is used because the '.arch' directive overrides the '.fpu'
> directive:
>
> arch/arm/crypto/curve25519-core.S:25:2: error: instruction requires: NEON
>  vmov.i32 q0, #1
>  ^
> arch/arm/crypto/curve25519-core.S:26:2: error: instruction requires: NEON
>  vshr.u64 q1, q0, #7
>  ^
> arch/arm/crypto/curve25519-core.S:27:2: error: instruction requires: NEON
>  vshr.u64 q0, q0, #8
>  ^
> arch/arm/crypto/curve25519-core.S:28:2: error: instruction requires: NEON
>  vmov.i32 d4, #19
>  ^
>
> Shuffle the order of the '.arch' and '.fpu' directives so that the code
> builds regardless of the default FPU mode. This has been tested against
> both clang with and without Debian's patch and GCC.
>
> Cc: stable@vger.kernel.org
> Fixes: d8f1308a025f ("crypto: arm/curve25519 - wire up NEON implementation")
> Link: https://github.com/ClangBuiltLinux/continuous-integration2/issues/118
> Reported-by: Arnd Bergmann <arnd@arndb.de>
> Suggested-by: Arnd Bergmann <arnd@arndb.de>
> Suggested-by: Jessica Clarke <jrtc27@jrtc27.com>
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Great work tracking down that Debian was carrying patches! Thank you!
I've run this through the same 3 assemblers.

Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Tested-by: Nick Desaulniers <ndesaulniers@google.com>

> ---
>  arch/arm/crypto/curve25519-core.S | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/arm/crypto/curve25519-core.S b/arch/arm/crypto/curve25519-core.S
> index be18af52e7dc..b697fa5d059a 100644
> --- a/arch/arm/crypto/curve25519-core.S
> +++ b/arch/arm/crypto/curve25519-core.S
> @@ -10,8 +10,8 @@
>  #include <linux/linkage.h>
>
>  .text
> -.fpu neon
>  .arch armv7-a
> +.fpu neon
>  .align 4
>
>  ENTRY(curve25519_neon)
>
> base-commit: e49d033bddf5b565044e2abe4241353959bc9120
> --
> 2.31.1.189.g2e36527f23
>


-- 
Thanks,
~Nick Desaulniers
