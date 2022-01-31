Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D120DC433F5
	for <linux-crypto@archiver.kernel.org>; Mon, 31 Jan 2022 18:13:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241657AbiAaSNW (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 31 Jan 2022 13:13:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245456AbiAaSNU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 31 Jan 2022 13:13:20 -0500
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F3ECC06173B
        for <linux-crypto@vger.kernel.org>; Mon, 31 Jan 2022 10:13:15 -0800 (PST)
Received: by mail-lf1-x132.google.com with SMTP id u14so28547962lfo.11
        for <linux-crypto@vger.kernel.org>; Mon, 31 Jan 2022 10:13:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=myVUmF89IyejxpZ1wuYc9KoTpLj57AihCSWjTZY2Gao=;
        b=f9y2P+zsG8URx1PnXUc2/Z52tSNnIo1IZ8IsSecWirPlWbAcOkwiydoJmIpkvQWrHR
         OjOt5W38YV3j80ScjDh0YiKxBM6JDDzXtL0q4kRln6FC7GcJ6/In6R+1EXTswlEnaWyV
         0z7DjD1jkehm0KqWCq7BBXCc8n5ef1UR6BUZCHmurunxj942oA1vSkE8nznxmY2e6iLY
         AbQqPPARLLfkatFZu7NO2tOU3THBBtwAN8tQnbpQWaCV551dwRJeRNYcilnonVifJ8h7
         sb25676DAorHKTBkAJMbrXvB1oNqFo9aiKxGjv3Er3ZijjB1nvLJsMOv3jCxecDL3Bnb
         S8+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=myVUmF89IyejxpZ1wuYc9KoTpLj57AihCSWjTZY2Gao=;
        b=pjQ43Oqjd2KUqxKcee5/YGV96/ZkhoIrQA3oFTeDTTSXNmfNLwHROZRRCqcRBR7qOo
         9NTCOLRWRJs2gf7uyIlwXE9LTH6uBh4oMzeYa2m5BC+t/ddXtcsaBmWvUGH9kOXzmsoL
         pzk1xE0L0mcmQdSL1DDk9D4GG6P+Ck0N5cmEqPxzAx+P3WY8b2fZJyYACKW2LoHczP9D
         VZIwoC8yPYMpNUOzyjOP+2KzYK2anJGlP+6VJOX1E+79y5X2IpVu0YACWzxeWbecBHIg
         jPN8inc62Wn3kyPK/O2lY1ix6PMk+iH5VHheqJAupec4c+rVdYRGheuhgkqkrQ8QzswH
         pfoQ==
X-Gm-Message-State: AOAM532xTiLTKwnbcXJQ90jTBZzfrxw5bHbZeeyVXAwOJ0X0OyvYYePF
        tc1C23VdCDloPruLgnIoWAmvBr5IdSQjPTyoZswM+w==
X-Google-Smtp-Source: ABdhPJzCq8wMhnjTlPTUt/8qm8hZmTr3cXvTFe6YCNtf6QpitpcyIxnwI1ESQZfYRkD/rwjE5OQrt1E9oKX5D+/Wmoc=
X-Received: by 2002:a05:6512:3ba5:: with SMTP id g37mr16430871lfv.651.1643652793491;
 Mon, 31 Jan 2022 10:13:13 -0800 (PST)
MIME-Version: 1.0
References: <20220129224529.76887-1-ardb@kernel.org> <20220129224529.76887-2-ardb@kernel.org>
In-Reply-To: <20220129224529.76887-2-ardb@kernel.org>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Mon, 31 Jan 2022 10:13:02 -0800
Message-ID: <CAKwvOdmW6cxMT_X9T+O98x55MY_b0zCaJWArU4OfTay6Ceyovg@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] lib/xor: make xor prototypes more friendely to
 compiler vectorization
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        Nathan Chancellor <nathan@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Jan 29, 2022 at 2:45 PM Ard Biesheuvel <ardb@kernel.org> wrote:
>
> Modern compilers are perfectly capable of extracting parallelism from
> the XOR routines, provided that the prototypes reflect the nature of the
> input accurately, in particular, the fact that the input vectors are
> expected not to overlap. This is not documented explicitly, but is
> implied by the interchangeability of the various C routines, some of
> which use temporary variables while others don't: this means that these
> routines only behave identically for non-overlapping inputs.
>
> So let's decorate these input vectors with the __restrict modifier,
> which informs the compiler that there is no overlap. While at it, make
> the input-only vectors pointer-to-const as well.
>
> Tested-by: Nathan Chancellor <nathan@kernel.org>
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>

Thanks for the patch!
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>

I like how you renamed the parameters in
arch/powerpc/include/asm/xor_altivec.h, arch/powerpc/lib/xor_vmx.h,
and arch/powerpc/lib/xor_vmx_glue.c.  It's not befitting for the
suffix _in to be used when the first param is technically more of an
"inout" param.  Though, you might also want to update the parameter
names in arch/powerpc/lib/xor_vmx.c.
-- 
Thanks,
~Nick Desaulniers
