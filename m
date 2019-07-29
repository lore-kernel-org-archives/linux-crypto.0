Return-Path: <SRS0=zv6R=V2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BF36C7618B
	for <linux-crypto@archiver.kernel.org>; Mon, 29 Jul 2019 08:26:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 05BEE206E0
	for <linux-crypto@archiver.kernel.org>; Mon, 29 Jul 2019 08:26:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726870AbfG2I0x (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 29 Jul 2019 04:26:53 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:35978 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726305AbfG2I0x (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 29 Jul 2019 04:26:53 -0400
Received: by mail-wr1-f66.google.com with SMTP id n4so60868040wrs.3
        for <linux-crypto@vger.kernel.org>; Mon, 29 Jul 2019 01:26:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=T7lLy0D5jk7fAEIU28JcsQaa7d7nkHawcDh0zCowpz4=;
        b=jZh9WgxXCLqjh2omToACojMJSyQWMihCUku+HSAMNUqvKWoUkeHCSUHfwd3L8m3cKG
         K+SiDh+eNJ1R43jzYTGtuEJesR5udmnmNs/TtIdwzp8tyOnTfSdyf+YmrL1znS67l1Ui
         mYH4m4TFUyUdukNFlcc1ZI5yu809BYp8gblwIYMk3x0GNlURW97gtGciQxa8KkNBkt/Z
         45UIioQESYlYSEAL32eqVm/pvXsOEtQh4IoeUmHTfw9SHidxwkfZ56gx9a0bQVya6hgr
         HysBsMUEkCc2Pj8RUgglR31bP4S3jvGTBXVoDx7rkHkMKCvF48A9Lc9BY5vbjP+F2wEZ
         q+UQ==
X-Gm-Message-State: APjAAAUa0S6gl8q5Yq08qfa7xUpaxXHQGjt25xP8nzZV6tOiNhcxIeWH
        YcZ8KNliB6PAAUt74PIBhlUEKNXbC+KBMg6yx5D8fw==
X-Google-Smtp-Source: APXvYqwOb4p8/Oar7WS7Mvf1kENq+jdLwbHrza0Cop9wxhPlscjbeANnrqotbzKKO3M1vkc0taS/BYNWBI2zKJMG9NE=
X-Received: by 2002:adf:ab51:: with SMTP id r17mr92532202wrc.95.1564388810936;
 Mon, 29 Jul 2019 01:26:50 -0700 (PDT)
MIME-Version: 1.0
References: <20190729074434.21064-1-ard.biesheuvel@linaro.org>
 <CAMuHMdUr9jidASX3X15B7R9z0zhKFNTUxQZtXv4NO1N53uZGPg@mail.gmail.com> <CAKv+Gu--FoanVd66fn1e3QQ=dyuQsBwVeezOnpS9FNExXP-SFw@mail.gmail.com>
In-Reply-To: <CAKv+Gu--FoanVd66fn1e3QQ=dyuQsBwVeezOnpS9FNExXP-SFw@mail.gmail.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 29 Jul 2019 10:26:38 +0200
Message-ID: <CAMuHMdWZ3R8YiWQ3F3yzJiDT_pWf_U_LRdS9LiTTLVz8CTvS9A@mail.gmail.com>
Subject: Re: [PATCH] crypto: aegis128 - deal with missing simd.h header on
 some architecures
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Ard,

On Mon, Jul 29, 2019 at 10:02 AM Ard Biesheuvel
<ard.biesheuvel@linaro.org> wrote:
> On Mon, 29 Jul 2019 at 10:55, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> > On Mon, Jul 29, 2019 at 9:44 AM Ard Biesheuvel
> > <ard.biesheuvel@linaro.org> wrote:
> > > The generic aegis128 driver has been updated to support using SIMD
> > > intrinsics to implement the core AES based transform, and this has
> > > been wired up for ARM and arm64, which both provide a simd.h header.
> > >
> > > As it turns out, most architectures don't provide this header, even
> > > though a version of it exists in include/asm-generic, and this is
> > > not taken into account by the aegis128 driver, resulting in build
> > > failures on those architectures.
> > >
> > > So update the aegis128 code to only import simd.h (and the related
> > > header in internal/crypto) if the SIMD functionality is enabled for
> > > this driver.
> > >
> > > Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
> > > Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> >
> > Thanks for your patch!
> >
> > > --- a/crypto/aegis128-core.c
> > > +++ b/crypto/aegis128-core.c
> > > @@ -8,7 +8,6 @@
> > >
> > >  #include <crypto/algapi.h>
> > >  #include <crypto/internal/aead.h>
> > > -#include <crypto/internal/simd.h>
> > >  #include <crypto/internal/skcipher.h>
> > >  #include <crypto/scatterwalk.h>
> > >  #include <linux/err.h>
> > > @@ -16,7 +15,11 @@
> > >  #include <linux/kernel.h>
> > >  #include <linux/module.h>
> > >  #include <linux/scatterlist.h>
> > > +
> > > +#ifdef CONFIG_CRYPTO_AEGIS128_SIMD
> > > +#include <crypto/internal/simd.h>
> > >  #include <asm/simd.h>
> >
> > Wouldn't including <crypto/internal/simd.h> unconditionally, and
> > adding just
> >
> >     #else
> >     static inline bool may_use_simd(void)
> >     {
> >             return false;
> >     }
> >
> > and be done with it, work too?
> >
>
> I guess, but I felt it was more appropriate to include as little of
> the SIMD infrastructure as possible when building this driver without
> SIMD support. Also, I think it is slightly ugly to have a alternative
> local implementation of something that is provided by a header file.

Alternatively, generic-y += simd.h on all architectures lacking asm/simd.h,
which is probably the best solution in the long run.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
