Return-Path: <SRS0=WH6x=DO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3ECDC4363C
	for <linux-crypto@archiver.kernel.org>; Wed,  7 Oct 2020 06:34:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6ED922083B
	for <linux-crypto@archiver.kernel.org>; Wed,  7 Oct 2020 06:34:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602052447;
	bh=57lD1FaZkxIswf9nw9qmot16OW3C5eH025NjTSR6etw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=AQwSPmirrCE/slS2s63u/SC6AsnDMPpfp5DoLhZa6WWWAdviYN5XqGO5TMUBZOsgk
	 gAH/inUrrzRFZMy/SeMMEfHavxglvfOwhLvtoKHYggAuyKptHRPYfkZIm4R3Hjo7zl
	 +zvJ31j89VpZpQo/Yb5RwhUZlm27vOU0G4RXDGik=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727414AbgJGGeG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 7 Oct 2020 02:34:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:47352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726564AbgJGGeG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 7 Oct 2020 02:34:06 -0400
Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com [209.85.210.50])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B5C1C206F0;
        Wed,  7 Oct 2020 06:34:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602052445;
        bh=57lD1FaZkxIswf9nw9qmot16OW3C5eH025NjTSR6etw=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=V8Vno4xaNfPqcyU1XXvzewSArFHy6HmVCnvCaYY4buEz7MYlWnyeRc48TBMDwnnQO
         ajf91RIfDI5Y5R1TD4cGWz4riX5hoOM0kQ0E5qSC8d0n91kUcnCxQYrDoAde3frgRb
         lLRChpih2//N1y01leEgHFeLgJTR96ZFX4KlxtYE=
Received: by mail-ot1-f50.google.com with SMTP id f10so1242069otb.6;
        Tue, 06 Oct 2020 23:34:05 -0700 (PDT)
X-Gm-Message-State: AOAM5323sJXLKAnNM4nOGAtneltOciQTlHO8ZrgxYzOCakbs9z1yWUqF
        1GQ3tqe6+bCvf+A9ZIiYs9dDxsU9FsBN451pYzQ=
X-Google-Smtp-Source: ABdhPJwoNaV0JzQhoW48TaTK8MNncrUvscs4Ob4zYJYKje9Q1h7b7KEggoW3RAha6k6DVNhrC03OM9e/Gq6NdfTTcL0=
X-Received: by 2002:a9d:335:: with SMTP id 50mr921206otv.90.1602052444976;
 Tue, 06 Oct 2020 23:34:04 -0700 (PDT)
MIME-Version: 1.0
References: <20201006195848.707504-1-natechancellor@gmail.com>
In-Reply-To: <20201006195848.707504-1-natechancellor@gmail.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Wed, 7 Oct 2020 08:33:54 +0200
X-Gmail-Original-Message-ID: <CAMj1kXF0L03+pOEyvZXpfxdd=FRyQia7k-tf9XZ4sSpwEpLmnQ@mail.gmail.com>
Message-ID: <CAMj1kXF0L03+pOEyvZXpfxdd=FRyQia7k-tf9XZ4sSpwEpLmnQ@mail.gmail.com>
Subject: Re: [PATCH] crypto: xor - Remove unused variable count in do_xor_speed
To:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Douglas Anderson <dianders@chromium.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, 6 Oct 2020 at 21:59, Nathan Chancellor <natechancellor@gmail.com> wrote:
>
> Clang warns:
>
> crypto/xor.c:101:4: warning: variable 'count' is uninitialized when used
> here [-Wuninitialized]
>                         count++;
>                         ^~~~~
> crypto/xor.c:86:17: note: initialize the variable 'count' to silence
> this warning
>         int i, j, count;
>                        ^
>                         = 0
> 1 warning generated.
>
> After the refactoring to use ktime that happened in this function, count
> is only assigned, never read. Just remove the variable to get rid of the
> warning.
>
> Fixes: c055e3eae0f1 ("crypto: xor - use ktime for template benchmarking")
> Link: https://github.com/ClangBuiltLinux/linux/issues/1171
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>

Acked-by: Ard Biesheuvel <ardb@kernel.org>

> ---
>  crypto/xor.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>
> diff --git a/crypto/xor.c b/crypto/xor.c
> index a0badbc03577..eacbf4f93990 100644
> --- a/crypto/xor.c
> +++ b/crypto/xor.c
> @@ -83,7 +83,7 @@ static void __init
>  do_xor_speed(struct xor_block_template *tmpl, void *b1, void *b2)
>  {
>         int speed;
> -       int i, j, count;
> +       int i, j;
>         ktime_t min, start, diff;
>
>         tmpl->next = template_list;
> @@ -98,8 +98,6 @@ do_xor_speed(struct xor_block_template *tmpl, void *b1, void *b2)
>                         mb(); /* prevent loop optimzation */
>                         tmpl->do_2(BENCH_SIZE, b1, b2);
>                         mb();
> -                       count++;
> -                       mb();
>                 }
>                 diff = ktime_sub(ktime_get(), start);
>                 if (diff < min)
>
> base-commit: ed4424f2fb02497b0ea92bf58c533c598c0da1d3
> --
> 2.29.0.rc0
>
