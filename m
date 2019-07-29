Return-Path: <SRS0=zv6R=V2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E72DC7618B
	for <linux-crypto@archiver.kernel.org>; Mon, 29 Jul 2019 08:02:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6431F2070B
	for <linux-crypto@archiver.kernel.org>; Mon, 29 Jul 2019 08:02:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="tfmVDVJT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727323AbfG2ICU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 29 Jul 2019 04:02:20 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:37665 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727341AbfG2ICQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 29 Jul 2019 04:02:16 -0400
Received: by mail-wr1-f65.google.com with SMTP id n9so35617944wrr.4
        for <linux-crypto@vger.kernel.org>; Mon, 29 Jul 2019 01:02:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fu43RUDcgdTM7ReEW3IylZ1wUHYdl8fUal8yK/BdOes=;
        b=tfmVDVJTObWOnEOmkLwcht8+JCWtE5B8FBrvvIRIg5+UkP/qMt3bBRG4tuKNQbGpDq
         oZ1Ne4lCyAKIdmBeSlZc3EhUfknI4hSRVsE/gdw2rVklPbNB12rn0W7nz+7ffRuh6kar
         mbAW7NEwNx5ZSOvYf3SBU+HcezzEcnEHmGKmOd7Wm/q58A8YToJNYztt7rgFKbjJ6JEp
         SdNU7WrPuUaQUPCu7qOkmJ5QfPlHMAMcIIwqcM09JTCsTerzmNvMNDJQ4nNy/ozg6Cj8
         iIpqlGp8q7NoFhHg2CUzwVxMBZFBXvRJ8FHNuAjhGE69pn5xzT+HKL1E5vk4CPrNyozj
         qMCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fu43RUDcgdTM7ReEW3IylZ1wUHYdl8fUal8yK/BdOes=;
        b=ctCHycW+lSny79GX8Nfc7u7pLftJj8ploz9JQR151Nhray4NHJbgtcMz0PUzb8tOZS
         BEcy5JvlRIUKQlPElN84pMJrsTmvv+hmfq4dROk2mygSgb+GpAeLfz0tbdg5XN+f/Hua
         fRqrPOocXSkIcV6T4+//KtlToJ1oNqPrPr70n6XB1Gic+L1Lz868TB7YwR2E1yM06V1O
         3UUfGouBPGJ+elKsySjq03QtYvufntgbUSq6FsyJtrcBh6+mNMVzAp9UvwqQ+8vAB/Ox
         I5dMgcEaEIZisvJd4iHM2RgZQLz+e6NzjwKJXygMZCavl7+J3WlPz+dMRAeuq4t24t88
         yOhQ==
X-Gm-Message-State: APjAAAVWI2HHD7vhCoHoPbGnFrPvrcN0WK2kzsf6PVbyWLhx1L/3lTKd
        F/tgO9r/QIHeNxAyfkeQRhXc+ryj0EkCSco++tNeQE2lrVU=
X-Google-Smtp-Source: APXvYqxp0tSBwK4spANeMEdOKHX0pEMpPgEuztfSl+Q8NtDFG29hfpsFOhA/F02fQXZgpGzQ1mzs8ld+d8qbgoAMRzI=
X-Received: by 2002:adf:e8c2:: with SMTP id k2mr28289515wrn.198.1564387334584;
 Mon, 29 Jul 2019 01:02:14 -0700 (PDT)
MIME-Version: 1.0
References: <20190729074434.21064-1-ard.biesheuvel@linaro.org> <CAMuHMdUr9jidASX3X15B7R9z0zhKFNTUxQZtXv4NO1N53uZGPg@mail.gmail.com>
In-Reply-To: <CAMuHMdUr9jidASX3X15B7R9z0zhKFNTUxQZtXv4NO1N53uZGPg@mail.gmail.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Mon, 29 Jul 2019 11:02:03 +0300
Message-ID: <CAKv+Gu--FoanVd66fn1e3QQ=dyuQsBwVeezOnpS9FNExXP-SFw@mail.gmail.com>
Subject: Re: [PATCH] crypto: aegis128 - deal with missing simd.h header on
 some architecures
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 29 Jul 2019 at 10:55, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>
> Hi Ard,
>
> On Mon, Jul 29, 2019 at 9:44 AM Ard Biesheuvel
> <ard.biesheuvel@linaro.org> wrote:
> > The generic aegis128 driver has been updated to support using SIMD
> > intrinsics to implement the core AES based transform, and this has
> > been wired up for ARM and arm64, which both provide a simd.h header.
> >
> > As it turns out, most architectures don't provide this header, even
> > though a version of it exists in include/asm-generic, and this is
> > not taken into account by the aegis128 driver, resulting in build
> > failures on those architectures.
> >
> > So update the aegis128 code to only import simd.h (and the related
> > header in internal/crypto) if the SIMD functionality is enabled for
> > this driver.
> >
> > Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
> > Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>
> Thanks for your patch!
>
> > --- a/crypto/aegis128-core.c
> > +++ b/crypto/aegis128-core.c
> > @@ -8,7 +8,6 @@
> >
> >  #include <crypto/algapi.h>
> >  #include <crypto/internal/aead.h>
> > -#include <crypto/internal/simd.h>
> >  #include <crypto/internal/skcipher.h>
> >  #include <crypto/scatterwalk.h>
> >  #include <linux/err.h>
> > @@ -16,7 +15,11 @@
> >  #include <linux/kernel.h>
> >  #include <linux/module.h>
> >  #include <linux/scatterlist.h>
> > +
> > +#ifdef CONFIG_CRYPTO_AEGIS128_SIMD
> > +#include <crypto/internal/simd.h>
> >  #include <asm/simd.h>
>
> Wouldn't including <crypto/internal/simd.h> unconditionally, and
> adding just
>
>     #else
>     static inline bool may_use_simd(void)
>     {
>             return false;
>     }
>
> and be done with it, work too?
>

I guess, but I felt it was more appropriate to include as little of
the SIMD infrastructure as possible when building this driver without
SIMD support. Also, I think it is slightly ugly to have a alternative
local implementation of something that is provided by a header file.



> > +#endif
> >
> >  #include "aegis.h"
> >
> > @@ -44,6 +47,15 @@ struct aegis128_ops {
> >
> >  static bool have_simd;
> >
> > +static bool aegis128_do_simd(void)
> > +{
> > +#ifdef CONFIG_CRYPTO_AEGIS128_SIMD
> > +       if (have_simd)
> > +               return crypto_simd_usable();
> > +#endif
> > +       return false;
> > +}
> > +
> >  bool crypto_aegis128_have_simd(void);
> >  void crypto_aegis128_update_simd(struct aegis_state *state, const void *msg);
> >  void crypto_aegis128_encrypt_chunk_simd(struct aegis_state *state, u8 *dst,
> > @@ -66,7 +78,7 @@ static void crypto_aegis128_update(struct aegis_state *state)
> >  static void crypto_aegis128_update_a(struct aegis_state *state,
> >                                      const union aegis_block *msg)
> >  {
> > -       if (have_simd && crypto_simd_usable()) {
> > +       if (aegis128_do_simd()) {
> >                 crypto_aegis128_update_simd(state, msg);
> >                 return;
> >         }
>
> [...]
>
> Gr{oetje,eeting}s,
>
>                         Geert
>
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
>
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                 -- Linus Torvalds
