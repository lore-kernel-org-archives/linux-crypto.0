Return-Path: <SRS0=oD/a=4Q=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79A9DC3F2D2
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Feb 2020 12:41:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4D8BF246A3
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Feb 2020 12:41:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="H32BlYxS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725802AbgB1Mlf (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 28 Feb 2020 07:41:35 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:38143 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbgB1Mlf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Feb 2020 07:41:35 -0500
Received: by mail-wr1-f68.google.com with SMTP id e8so2797460wrm.5
        for <linux-crypto@vger.kernel.org>; Fri, 28 Feb 2020 04:41:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XBS4xJeronFByco7hvqXXCJEpIN3x2l+h2xMS+Qu5VY=;
        b=H32BlYxSp7yeOYKrV+18Kq0+YS+hSAOrzWo3T6WyqnHTkd0LkP8qZjWhS1n5//SwFO
         7yqusqGjdG8VA3A/7qaHEYn0+6hAzJjGiZP0lNj1456ePdSkYU7BMpxhz6GoBcLHXIwK
         gOzyaCW0Xns5tOdyob4OhuPjbYcfHcOq8e2QURnGhwq0UeBw+sOpJ/73uaprMNuuTXF2
         iLn1W4nYHLZRS1rRnPYzYVj4gQhwMs+x+nlNaP6uYErNFT5JWSv4K6IuZx8CbGFP59Z9
         7CKW+egRaz8fyaTmNtvzCa3R7Hm0PSt6mS5JhRgXArF0qCOJnOgLCizqVEszVt+wk5Y1
         gojA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XBS4xJeronFByco7hvqXXCJEpIN3x2l+h2xMS+Qu5VY=;
        b=OWIk7mz95JZ/HnS+rOcPxW33+YUTqZ80wSstyqSXw1cx+SQ6yx6Wg92Yk3ns9xrhjE
         j9l3OQSmTAxEZVyreZV0JCt2LBOgbPp3uD11Tm9ixgWellShcyylc6i/PYTR/3/S7io/
         Q9+RoZFw2G3Uv763Xan8x36e91iU/tTjV75ntFiuyEkG7qvM4tX1mJBIPi0XlQd8AEko
         N7quBOj8JJaRwXyIFaKQjNomp39W77jVjoQYrj9HKPo808U4Ef4vTBBPk8074vJ7riLd
         GJZlIjNCNxoxbmDIfBqJmEH8C9whCZ3oNYXXiUnFm9wPFVJl85cSRZ+MQhT11IRd/chQ
         AdWA==
X-Gm-Message-State: APjAAAXAzawsuIVUteNEtKqwAA3E9ydPugKZ4nBahJhi4LT+4CnnJx1C
        4jAO9hWzBGlEsQnq0HSuXSb7ascA69tQMBKWxqMZ5Q==
X-Google-Smtp-Source: APXvYqycHr5BpR7YsHapDHRDF5PvvknfNJGfaHFydphDQrJgW+V3mYRdB8mumbWLaqIy7fTmjqZ4VZ0ui5GjrBMPKsg=
X-Received: by 2002:adf:f84a:: with SMTP id d10mr4811332wrq.208.1582893691834;
 Fri, 28 Feb 2020 04:41:31 -0800 (PST)
MIME-Version: 1.0
References: <20200218195842.34156-1-broonie@kernel.org> <20200218195842.34156-13-broonie@kernel.org>
In-Reply-To: <20200218195842.34156-13-broonie@kernel.org>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Fri, 28 Feb 2020 13:41:21 +0100
Message-ID: <CAKv+Gu9Bt93hCaOUrgtfYWp+BU4gheVf2Y==PXVyMZcCssRLQg@mail.gmail.com>
Subject: Re: [PATCH 12/18] arm64: kernel: Convert to modern annotations for
 assembly functions
To:     Mark Brown <broonie@kernel.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kvmarm <kvmarm@lists.cs.columbia.edu>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Mark,

On Tue, 18 Feb 2020 at 21:02, Mark Brown <broonie@kernel.org> wrote:
>
> In an effort to clarify and simplify the annotation of assembly functions
> in the kernel new macros have been introduced. These replace ENTRY and
> ENDPROC and also add a new annotation for static functions which previously
> had no ENTRY equivalent. Update the annotations in the core kernel code to
> the new macros.
>
> Signed-off-by: Mark Brown <broonie@kernel.org>
> ---
>  arch/arm64/kernel/cpu-reset.S                 |  4 +-
>  arch/arm64/kernel/efi-entry.S                 |  4 +-
>  arch/arm64/kernel/efi-rt-wrapper.S            |  4 +-
>  arch/arm64/kernel/entry-fpsimd.S              | 20 ++++-----
>  arch/arm64/kernel/hibernate-asm.S             | 16 +++----
>  arch/arm64/kernel/hyp-stub.S                  | 20 ++++-----
>  arch/arm64/kernel/probes/kprobes_trampoline.S |  4 +-
>  arch/arm64/kernel/reloc_test_syms.S           | 44 +++++++++----------
>  arch/arm64/kernel/relocate_kernel.S           |  4 +-
>  arch/arm64/kernel/sleep.S                     | 12 ++---
>  arch/arm64/kernel/smccc-call.S                |  8 ++--
>  11 files changed, 70 insertions(+), 70 deletions(-)
>
...
> diff --git a/arch/arm64/kernel/efi-entry.S b/arch/arm64/kernel/efi-entry.S
> index 304d5b02ca67..de6ced92950e 100644
> --- a/arch/arm64/kernel/efi-entry.S
> +++ b/arch/arm64/kernel/efi-entry.S
> @@ -25,7 +25,7 @@
>          * we want to be. The kernel image wants to be placed at TEXT_OFFSET
>          * from start of RAM.
>          */
> -ENTRY(entry)
> +SYM_CODE_START(entry)
>         /*
>          * Create a stack frame to save FP/LR with extra space
>          * for image_addr variable passed to efi_entry().
> @@ -117,4 +117,4 @@ efi_load_fail:
>         ret
>
>  entry_end:
> -ENDPROC(entry)
> +SYM_CODE_END(entry)

This hunk is going to conflict badly with the EFI tree. I will
incorporate this change for v5.7, so could you please just drop it
from this patch?
