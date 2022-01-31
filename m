Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91537C433F5
	for <linux-crypto@archiver.kernel.org>; Mon, 31 Jan 2022 18:16:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239574AbiAaSQi (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 31 Jan 2022 13:16:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236914AbiAaSQi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 31 Jan 2022 13:16:38 -0500
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CEE5C061714
        for <linux-crypto@vger.kernel.org>; Mon, 31 Jan 2022 10:16:38 -0800 (PST)
Received: by mail-lj1-x236.google.com with SMTP id z20so20585442ljo.6
        for <linux-crypto@vger.kernel.org>; Mon, 31 Jan 2022 10:16:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gyEQrK489u7hChy2E+c7sGCUR0+nczU4u5IQ7M/S6eI=;
        b=IeLNj0bcyA05XSywkBjL/WClby7sJbn4LuVShqHglERWo7vx2pnu9yahaxWMYX+Ea+
         mg91pJC+aCBulku1EXIUZzA2+Mt5z1daB5WuYdGyFTXavP3zchbwpt04h9Jspd5jkb/I
         Q1IcwHxjSH3dIamV0OSOa4uHZxlcPBDUSD0F4MMa1Ay+iXTuTzvyYt99YQjagOE8OEw7
         Zt6daGwzAPE/xk/vvcKdEwtjixoTAy+UDP4CcFkSIdodQNUMC0TSJWwAfgaXzrQRdTXv
         zPKrjthznH1nY82Z5h8sxWJiiAk72taUfmP/GKfWoaHioaHgYjuOLZaFjci/uyzQmfAY
         +u4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gyEQrK489u7hChy2E+c7sGCUR0+nczU4u5IQ7M/S6eI=;
        b=EVR+rYcQOQw34SngF++8GUyDRfn58f/Ly4ufw22x3uYsoXP3JCM4yM1b83FbASw6JG
         HlYvNn1ixpUcxSQm9Ne7bcAwdHIYfUFXSv6J8UsMiOr9EpLMWu9/0GrxaX3oRYumnIGJ
         HKKGTVUvb+vj265SlthdbABg4+KQu7FNyaDGqsV5XaUBsl/wxz0KeH/5w7uopY419u98
         2GHtTJeqJayza5KLxjPB1mzIhMn04AlqOWAwsGF06WO3fCCvVr8L18/4/ye0hYgYFLxv
         QqdPqhuszOGDxInI2e1H9GwpAATq4ny0KAAM2wrioF1mHNkyNR+0UIvayHkXXxOY37+3
         is6Q==
X-Gm-Message-State: AOAM531xJAmCi+SdLtHZTPiCLdJbRzAGAMcfarF+gH3cHYNf2uJr5u34
        aDI7F4Ztwl6252s4z9mB3I4s2EllGSH1rvKK12w5sQ==
X-Google-Smtp-Source: ABdhPJzH84MwpkHA2HN+vOIOoHnhFkHIWI0RceFo+cQkKMT/mab9EGYET9WgOo96gb1d5ZvHau481t8aKxNvOI5syAo=
X-Received: by 2002:a2e:b6d0:: with SMTP id m16mr6852861ljo.128.1643652996400;
 Mon, 31 Jan 2022 10:16:36 -0800 (PST)
MIME-Version: 1.0
References: <20220129224529.76887-1-ardb@kernel.org> <20220129224529.76887-3-ardb@kernel.org>
In-Reply-To: <20220129224529.76887-3-ardb@kernel.org>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Mon, 31 Jan 2022 10:16:24 -0800
Message-ID: <CAKwvOdmX1_qBUS-PnWFHrAU3usTTeYsMnfv5cfpp42Hmwmkzmg@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] crypto: arm/xor - make vectorized C code Clang-friendly
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        Nathan Chancellor <nathan@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Jan 29, 2022 at 2:45 PM Ard Biesheuvel <ardb@kernel.org> wrote:
>
> The ARM version of the accelerated XOR routines are simply the 8-way C
> routines passed through the auto-vectorizer with SIMD codegen enabled.
> This used to require GCC version 4.6 at least, but given that 5.1 is now
> the baseline, this check is no longer necessary, and actually
> misidentifies Clang as GCC < 4.6 as Clang defines the GCC major/minor as
> well, but makes no attempt at doing this in a way that conveys feature
> parity with a certain version of GCC (which would not be a great idea in
> the first place).
>
> So let's drop the version check, and make the auto-vectorize pragma
> (which is based on a GCC-specific command line option) GCC-only. Since
> Clang performs SIMD auto-vectorization by default at -O2, no pragma is
> necessary here.
>
> Tested-by: Nathan Chancellor <nathan@kernel.org>
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>

Thanks for the patch!
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Link: https://github.com/ClangBuiltLinux/linux/issues/496
Link: https://github.com/ClangBuiltLinux/linux/issues/503

> ---
>  arch/arm/lib/xor-neon.c | 12 +++---------
>  1 file changed, 3 insertions(+), 9 deletions(-)
>
> diff --git a/arch/arm/lib/xor-neon.c b/arch/arm/lib/xor-neon.c
> index b99dd8e1c93f..522510baed49 100644
> --- a/arch/arm/lib/xor-neon.c
> +++ b/arch/arm/lib/xor-neon.c
> @@ -17,17 +17,11 @@ MODULE_LICENSE("GPL");
>  /*
>   * Pull in the reference implementations while instructing GCC (through
>   * -ftree-vectorize) to attempt to exploit implicit parallelism and emit
> - * NEON instructions.
> + * NEON instructions. Clang does this by default at O2 so no pragma is
> + * needed.
>   */
> -#if __GNUC__ > 4 || (__GNUC__ == 4 && __GNUC_MINOR__ >= 6)
> +#ifdef CONFIG_CC_IS_GCC
>  #pragma GCC optimize "tree-vectorize"
> -#else
> -/*
> - * While older versions of GCC do not generate incorrect code, they fail to
> - * recognize the parallel nature of these functions, and emit plain ARM code,
> - * which is known to be slower than the optimized ARM code in asm-arm/xor.h.
> - */
> -#warning This code requires at least version 4.6 of GCC
>  #endif
>
>  #pragma GCC diagnostic ignored "-Wunused-variable"
> --
> 2.30.2
>


-- 
Thanks,
~Nick Desaulniers
