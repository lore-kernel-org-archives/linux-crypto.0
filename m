Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2BE7C56201
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Nov 2020 09:36:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 82B08221FC
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Nov 2020 09:36:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cwM47uyO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727210AbgKLJgf (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 12 Nov 2020 04:36:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725928AbgKLJgd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Nov 2020 04:36:33 -0500
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03E0CC0613D1;
        Thu, 12 Nov 2020 01:36:33 -0800 (PST)
Received: by mail-yb1-xb30.google.com with SMTP id v92so4726143ybi.4;
        Thu, 12 Nov 2020 01:36:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sTS5WgslFCC2reGOH2FyGvABtQkS4qb5R30Fuulj5m8=;
        b=cwM47uyOFGAIz3TUSqUCwRt/vNtGWcwvTqq4zBDmSgSMpSkLdOsZ+mZ10Nx60VFE/7
         GENk2IdkTw2OQgeor8LXrH2bgWBC3CLe5NGxD9Y33YTNcJwedWPd7VMuraQN2vsTjJvc
         U4wmlovFlNKoAlaMUPTUQHuIuu9zf6thn9m6i2YNYr8tFdBn42kCerj3TQdToVPJ8JvC
         NpSBewleknloYUEQHe+sIetwiL+WQasePGRjbhokK/Ywivq+IQ3t2jliW4UcqdSBdY4d
         ed3tP3GMXwS39jnxpCYG3g7Jn10pOXasZ2S2/LpR4ojff8wUl/a2wP62wqBHQwxVGFrU
         s+gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sTS5WgslFCC2reGOH2FyGvABtQkS4qb5R30Fuulj5m8=;
        b=nvUzoJbGvqHKE35SXJrGPg4W9YMXVXh0WEGsiumoRt6LPD5cpENKPiIHcqfaO8hDxj
         Nbh2kDcTPtIl7i2GuCX8LUo3a57ICr7yN5UXCtzC7qmvwPKuKNgy4XjA86l/zy4dgCA0
         jal0PhM1ygFWQ+injLrgb0nUVYuVOOxm5NkX6rtgyI01hysCHczVULeuqAPqKyteUQow
         UBKbaw2xM49jdCIRJCL9WIaq2du8PJBNxnM2LEtnZRhxtlH6jzEa90ZSq/QOdkFqAk83
         MElBHv6n/dVftowGRJuIcbnTQJLlfW4W7CePN4rEl7YSFoB1ytIUeQWRWuW1mPZqsqzU
         411w==
X-Gm-Message-State: AOAM530IDqInPaqz5Yi1XTs09HojMbdcjlMJyCdg9fyFVqSNgFWMlGRu
        Pkc5ekuwuxIo3OIuQjbsBL7vTOdvdLwy8Bs51Bs=
X-Google-Smtp-Source: ABdhPJw+DSBsjOzzy6fUdz00vxTSW1vYI1rXcO6XgtQgLKtgyEK76EAKOWdWYqXlPG9i9d5sRjN0rAFnbbhHMcnLXIM=
X-Received: by 2002:a25:61c5:: with SMTP id v188mr34927594ybb.422.1605173792160;
 Thu, 12 Nov 2020 01:36:32 -0800 (PST)
MIME-Version: 1.0
References: <e9b1ba517f06b81bd24e54c84f5e44d81c27c566.camel@perches.com>
 <20201022073307.GP2628@hirez.programming.kicks-ass.net> <133aa0c8c5e2cbc862df109200b982e89046dbc0.camel@perches.com>
 <CAMj1kXF_0_bu0nbJyUU-yBDCOAirRvGkX-V8kQPVh_GHO2WM-g@mail.gmail.com>
In-Reply-To: <CAMj1kXF_0_bu0nbJyUU-yBDCOAirRvGkX-V8kQPVh_GHO2WM-g@mail.gmail.com>
From:   Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date:   Thu, 12 Nov 2020 10:36:21 +0100
Message-ID: <CANiq72k9y-sh1fUyxdvXgYEfZOS_CSwRK+LyR6nVtRaOjYJbwQ@mail.gmail.com>
Subject: Re: [PATCH -next] treewide: Remove stringification from __alias macro definition
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Joe Perches <joe@perches.com>,
        Russell King <linux@armlinux.org.uk>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, X86 ML <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Marco Elver <elver@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Alexander Potapenko <glider@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-efi <linux-efi@vger.kernel.org>,
        kasan-dev <kasan-dev@googlegroups.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Nov 11, 2020 at 8:19 AM Ard Biesheuvel <ardb@kernel.org> wrote:
>
> I am still not convinced we need this change, as I don't see how the
> concerns regarding __section apply to __alias. But if we do, can we
> please use the same approach, i.e., revert the current patch, and
> queue it again after v5.11-rc1 with all new occurrences covered as
> well?

In general, it would be nice to move all compiler attributes to use
the `__` syntax, which is independent of compiler vendor, gives us a
level of indirection to modify behavior between compilers and is
shorter/nicer for users.

But it is low priority, so it should go in whenever it causes the
least amount of trouble.

Cheers,
Miguel
