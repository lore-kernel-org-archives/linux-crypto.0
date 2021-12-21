Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CFE4C433EF
	for <linux-crypto@archiver.kernel.org>; Tue, 21 Dec 2021 07:25:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233746AbhLUHZG (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 21 Dec 2021 02:25:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233600AbhLUHZG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 21 Dec 2021 02:25:06 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31665C061574
        for <linux-crypto@vger.kernel.org>; Mon, 20 Dec 2021 23:25:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6FE69CE12DA
        for <linux-crypto@vger.kernel.org>; Tue, 21 Dec 2021 07:25:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA97EC36AE2
        for <linux-crypto@vger.kernel.org>; Tue, 21 Dec 2021 07:25:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640071501;
        bh=/Dwo3UgZqHC3AKP+k7recjWl2j8S+tY0tL+KQ0/xFcc=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=nEJy9mJEEH3/LMeGCjoxJVh8rAjtCchtgm7UjLzfw6b64BtLrqY1PBk8UT+8RbYR1
         ANZTEoTRsmmgcX/jNI41aoJ8poRf9BGpYubOinIGbrsaBtpLvdJqaWf4sIBzyjPbmL
         9NhR2gjpTvJpuVUJA3vbkwt7D6zOeJ8gumhhTm1dtSBIUr1b5Tjfa/N6HxjGcMMoRa
         mPJw1OwRgatqM9Imr0LCDja9dUnY7rNhVWQZjJbFp84er41QMqxvr0nqySIji6Zl1M
         /sqo0wSe3vPgBhxsve6cgQmsjrXzd9PYZmaJ+6T9EzdC7kULtQYxz5Fd4iVhDdrBPO
         UjA5yypgJyUdQ==
Received: by mail-wm1-f54.google.com with SMTP id d198-20020a1c1dcf000000b0034569cdd2a2so1435284wmd.5
        for <linux-crypto@vger.kernel.org>; Mon, 20 Dec 2021 23:25:01 -0800 (PST)
X-Gm-Message-State: AOAM531deSW6rFydjdymv7K2EJ+N8KU4DaaGucoRBtnfzj7eEJcdkOO2
        badS+0disnd1reu+QMQNigCqb2dWC+Up9bd7Ync=
X-Google-Smtp-Source: ABdhPJz0vVzsnPgppIsgvFIT7FRwIsSaQWlK5/nksAmu70IriIGl9aE4FaVpN/pO1HzJG8//ehDZi48BP7jVbv7EiIA=
X-Received: by 2002:a1c:7e14:: with SMTP id z20mr1431705wmc.25.1640071500064;
 Mon, 20 Dec 2021 23:25:00 -0800 (PST)
MIME-Version: 1.0
References: <20211207113252.162701ed@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20211208044037.GA11399@gondor.apana.org.au> <20211207212907.6e91821b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20211220150343.4e12a4d2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20211220161125.78bc4d66@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20211220165251.400813dc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <CAMj1kXG+FGBHr=+vUwVz-u5n7oHpRxikLsOogVW0bOvNow3jHQ@mail.gmail.com>
In-Reply-To: <CAMj1kXG+FGBHr=+vUwVz-u5n7oHpRxikLsOogVW0bOvNow3jHQ@mail.gmail.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Tue, 21 Dec 2021 08:24:48 +0100
X-Gmail-Original-Message-ID: <CAMj1kXGV+DHZSOw7t8NgZojMsA6bq-VENz-WxQH+rb8yFj0zyA@mail.gmail.com>
Message-ID: <CAMj1kXGV+DHZSOw7t8NgZojMsA6bq-VENz-WxQH+rb8yFj0zyA@mail.gmail.com>
Subject: Re: x86 AES crypto alignment
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Sabrina Dubroca <sd@queasysnail.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, 21 Dec 2021 at 07:59, Ard Biesheuvel <ardb@kernel.org> wrote:
>
> On Tue, 21 Dec 2021 at 01:52, Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > On Mon, 20 Dec 2021 16:11:25 -0800 Jakub Kicinski wrote:
> > > On Mon, 20 Dec 2021 15:03:43 -0800 Jakub Kicinski wrote:
> > > > Hm, I'm benchmarking things now and it appears to be a regression
> > > > introduced somewhere around 5.11 / 5.12. I don't see the memcpy
> > > > eating 20% of performance on 5.10. Bisection time.
> > >
> > > 83c83e658863 ("crypto: aesni - refactor scatterlist processing")
> > >
> > > is what introduced the regression.
> >
> > Something like this?
> >
> > ---->8-----------
> >
> > From: Jakub Kicinski <kuba@kernel.org>
> > Date: Mon, 20 Dec 2021 16:29:26 -0800
> > Subject: [PATCH] x86/aesni: don't require alignment
> >
> > Looks like we take care of the meta-data (key, iv etc.) alignment
> > anyway and data can safely be unaligned. In fact we were feeding
> > unaligned data into crypto routines up until commit 83c83e658863
> > ("crypto: aesni - refactor scatterlist processing") switched to
> > use the full skcipher API.
> >
> > This fixes 21% performance regression in kTLS.
> >
> > Tested by booting with CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y
> > (and running thru various kTLS packets).
> >
> > Signed-off-by: Jakub Kicinski <kuba@kernel.org>
>
> Acked-by: Ard Biesheuvel <ardb@kernel.org>
>
> but it needs a Fixes tag.
>
> Could you check whether this means that gcm_context_data in
> gcmaes_crypt_by_sg() does not have to be aligned either? It would be
> nice if we could drop that horrible hack as well.
>

I guess you meant by "we take care of the meta-data (key, iv etc.)
alignment anyway" that we have these hacks for gcm_context_data (which
carries the key) and the IV, using oversized buffers on the stack and
open coded realignment.

It would be really nice if we could just get rid of all of that as
well, and just use {v}movdqu to load those items.




>
> > ---
> >  arch/x86/crypto/aesni-intel_glue.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
> > index e09f4672dd38..41901ba9d3a2 100644
> > --- a/arch/x86/crypto/aesni-intel_glue.c
> > +++ b/arch/x86/crypto/aesni-intel_glue.c
> > @@ -1107,7 +1107,7 @@ static struct aead_alg aesni_aeads[] = { {
> >                 .cra_flags              = CRYPTO_ALG_INTERNAL,
> >                 .cra_blocksize          = 1,
> >                 .cra_ctxsize            = sizeof(struct aesni_rfc4106_gcm_ctx),
> > -               .cra_alignmask          = AESNI_ALIGN - 1,
> > +               .cra_alignmask          = 0,
> >                 .cra_module             = THIS_MODULE,
> >         },
> >  }, {
> > @@ -1124,7 +1124,7 @@ static struct aead_alg aesni_aeads[] = { {
> >                 .cra_flags              = CRYPTO_ALG_INTERNAL,
> >                 .cra_blocksize          = 1,
> >                 .cra_ctxsize            = sizeof(struct generic_gcmaes_ctx),
> > -               .cra_alignmask          = AESNI_ALIGN - 1,
> > +               .cra_alignmask          = 0,
> >                 .cra_module             = THIS_MODULE,
> >         },
> >  } };
> > --
> > 2.31.1
> >
