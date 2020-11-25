Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 989D4C56201
	for <linux-crypto@archiver.kernel.org>; Wed, 25 Nov 2020 17:04:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F7B0206D8
	for <linux-crypto@archiver.kernel.org>; Wed, 25 Nov 2020 17:04:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="aa/D+A9o"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730921AbgKYREF (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 25 Nov 2020 12:04:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:36340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729631AbgKYREF (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 25 Nov 2020 12:04:05 -0500
Received: from mail-ot1-f43.google.com (mail-ot1-f43.google.com [209.85.210.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B0349206D8
        for <linux-crypto@vger.kernel.org>; Wed, 25 Nov 2020 17:04:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606323844;
        bh=1qS5/GFcSAGcRyrQazwOryzoBppMJH1xG1RxWlS8xuA=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=aa/D+A9o9A1eckdR5EjzlF4fyTVai6wVcuR/QG/gnpMnrWbiUM3T/hVDFeCzWqKDO
         g3Ix1s8ndjE/+5ceo1RSc9MT+L1KUfvdH9yrLhyoEjIZmFyOyk+DWxfNHtELdScR4S
         dcMsVK99IUfNxf7nj2wSteS5yNwDrGjeb7CAfaDw=
Received: by mail-ot1-f43.google.com with SMTP id k3so2831668otp.12
        for <linux-crypto@vger.kernel.org>; Wed, 25 Nov 2020 09:04:04 -0800 (PST)
X-Gm-Message-State: AOAM533r5p7utsctg5WOssVT6yyfV6Svp6uUucV2bu94+yfpBaqa5OLP
        QUZ2+kuEADs2PQvta3wUb4hBmd2XlVma8s+DEZQ=
X-Google-Smtp-Source: ABdhPJw/8Vkt6B+d2sBJM3V7plAChMIuU53To9UoB+GP+z736ngLsnTyZHaVYmaF9xB8jZGIAhQbL8gRr0ZSom283QI=
X-Received: by 2002:a9d:62c1:: with SMTP id z1mr3595302otk.108.1606323844051;
 Wed, 25 Nov 2020 09:04:04 -0800 (PST)
MIME-Version: 1.0
References: <20201125072216.892-1-ardb@kernel.org> <X76MuJmPvy6CeoBd@sol.localdomain>
In-Reply-To: <X76MuJmPvy6CeoBd@sol.localdomain>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Wed, 25 Nov 2020 18:03:52 +0100
X-Gmail-Original-Message-ID: <CAMj1kXFw7RVvyxpwD_D0T29u5zkTTs-ZYL4ci=8AzbM=qMbpVg@mail.gmail.com>
Message-ID: <CAMj1kXFw7RVvyxpwD_D0T29u5zkTTs-ZYL4ci=8AzbM=qMbpVg@mail.gmail.com>
Subject: Re: [PATCH] crypto: arm/aes-ce - work around Cortex-A72 erratum #1655431
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        James Morse <james.morse@arm.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, 25 Nov 2020 at 17:56, Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Wed, Nov 25, 2020 at 08:22:16AM +0100, Ard Biesheuvel wrote:
> > ARM Cortex-A72 cores running in 32-bit mode are affected by a silicon
> > erratum (1655431: ELR recorded incorrectly on interrupt taken between
> > cryptographic instructions in a sequence [0]) where the second instruction
> > of a AES instruction pair may execute twice if an interrupt is taken right
> > after the first instruction consumes an input register of which a single
> > 32-bit lane has been updated the last time it was modified.
> >
> > This is not such a rare occurrence as it may seem: in counter mode, only
> > the least significant 32-bit word is incremented in the absence of a
> > carry, which makes our counter mode implementation susceptible to the
> > erratum.
> >
> > So let's shuffle the counter assignments around a bit so that the most
> > recent updates when the AES instruction pair executes are 128-bit wide.
> >
> > [0] ARM-EPM-012079 v11.0 Cortex-A72 MPCore Software Developers Errata Notice
> >
> > Cc: <stable@vger.kernel.org> # v5.4+
> > Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> > ---
> >  arch/arm/crypto/aes-ce-core.S | 20 ++++++++++----------
> >  1 file changed, 10 insertions(+), 10 deletions(-)
> >
> > diff --git a/arch/arm/crypto/aes-ce-core.S b/arch/arm/crypto/aes-ce-core.S
> > index 4d1707388d94..c0ef9680d90b 100644
> > --- a/arch/arm/crypto/aes-ce-core.S
> > +++ b/arch/arm/crypto/aes-ce-core.S
> > @@ -386,20 +386,20 @@ ENTRY(ce_aes_ctr_encrypt)
> >  .Lctrloop4x:
> >       subs            r4, r4, #4
> >       bmi             .Lctr1x
> > -     add             r6, r6, #1
> > +     add             ip, r6, #1
> >       vmov            q0, q7
> > +     rev             ip, ip
> > +     add             lr, r6, #2
> > +     vmov            s31, ip
> > +     add             ip, r6, #3
> > +     rev             lr, lr
> >       vmov            q1, q7
> > -     rev             ip, r6
> > -     add             r6, r6, #1
> > +     vmov            s31, lr
> > +     rev             ip, ip
> >       vmov            q2, q7
> > -     vmov            s7, ip
> > -     rev             ip, r6
> > -     add             r6, r6, #1
> > +     vmov            s31, ip
> > +     add             r6, r6, #4
> >       vmov            q3, q7
> > -     vmov            s11, ip
> > -     rev             ip, r6
> > -     add             r6, r6, #1
> > -     vmov            s15, ip
> >       vld1.8          {q4-q5}, [r1]!
> >       vld1.8          {q6}, [r1]!
> >       vld1.8          {q15}, [r1]!
>
> Seems like this could use a comment that explains that things need to be done in
> a certain way to avoid an erratum.
>

Fair enough, I'll add that. Note that A57 is equally affected, so I
need to respin this anyway to add a mention of that.
