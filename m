Return-Path: <SRS0=Ym9l=UQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84F2AC31E54
	for <linux-crypto@archiver.kernel.org>; Mon, 17 Jun 2019 08:32:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5D7EB21EF2
	for <linux-crypto@archiver.kernel.org>; Mon, 17 Jun 2019 08:32:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="SUP0HB8C"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726405AbfFQIc1 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 17 Jun 2019 04:32:27 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:45524 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726355AbfFQIc1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 17 Jun 2019 04:32:27 -0400
Received: by mail-io1-f65.google.com with SMTP id e3so19236231ioc.12
        for <linux-crypto@vger.kernel.org>; Mon, 17 Jun 2019 01:32:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=e/UVFvSTOnQx2MdEwCsdbLMftAMFG5W38DFDRZnlaqE=;
        b=SUP0HB8CO812sk5oBxHZBrx0VmZ/7Tn8LPjsNe48JSOup+I9iNPzIepwpMxWQwOr8O
         KCDs4lKIm1EfJGd/e7NiKdRBd40qx2t0L8zAXk8Axh8jMohrGjO/7WmH0DyZbrv3yPcg
         ukGi6X2f6pJES1kiGjYUkc5VUfC8KxWn1Uh+eO9mWdXHT8KMx7OZKGZsl0ee0gWlMoxH
         xWLXjbPrRS55FFj7io0SM+hkIMfcctPC6L8oozNOzt/Hl/kZ7S9ZHAN4UXChXsyRexoL
         +2UA84C2ri0PpIj3SPhQkDxO9i0TOl4Q6HbwDq6pbMhMZNVJkuf3rntsQsYYRiDZklN2
         2hCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=e/UVFvSTOnQx2MdEwCsdbLMftAMFG5W38DFDRZnlaqE=;
        b=Mdgt9SRJX0yuEJTyIdf259rC6hCfUSmTiMqHRDLN7t+KHpEz/QI7pMTkzh7tqOCvAi
         usIJGVhGkajxUeUA5FCmeFNtjAHy5tMCrL0xLfK3RUyOljmJ2G4rA+gx1uO6figGE5Sc
         jslfrk27qOwAXgGAPmTOr+6LP21+iGPTZEO+GvQjGsJfL3W2QQ/GiVpJCm7QSaxdgYBn
         WCioM7VCjSfCfUzcLowI6XmX4sIZptpz8KXVuoQCq7UdTgoj1a2ol2oZNzsfdS1uvA+N
         TLwVD3tndp8uuulimsIzuP4c3iVTOCaPk993AnOpfcLnmHg+V5tpukN2iUeh0zfdZ964
         xzOQ==
X-Gm-Message-State: APjAAAWJgnb/LEgcRf1o/HTOiRyiKZGuJM7B2XpA3T0Ywg70/Jw56gTG
        5z6093OUSMDy9KMtEIwjwD0T3/+Iz+yWTefFxKPtWw==
X-Google-Smtp-Source: APXvYqyCvSdGF/kKkdQvExm0EaKRVOaiq6eSYb+tcdvLqnTy4SD4UKTQokJrBkDaNyi2JnJNn/7Nxkqwv5SAu6szY4k=
X-Received: by 2002:a5e:820a:: with SMTP id l10mr15338296iom.283.1560760346379;
 Mon, 17 Jun 2019 01:32:26 -0700 (PDT)
MIME-Version: 1.0
References: <20190614093603.22771-1-ard.biesheuvel@linaro.org>
 <20190616071206.GB698@sol.localdomain> <CAKv+Gu97xkz5qxycyjqmukFhWAD6p=eYbTqoPWt-ZNbBFDbNAw@mail.gmail.com>
 <20190616194322.GC923@sol.localdomain>
In-Reply-To: <20190616194322.GC923@sol.localdomain>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Mon, 17 Jun 2019 10:32:14 +0200
Message-ID: <CAKv+Gu8qgDgONkt0_2vpu3FacPbbFFMc=4tPrtnxqXt9gNexOw@mail.gmail.com>
Subject: Re: [PATCH] wireless: airo: switch to skcipher interface
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     "<linux-wireless@vger.kernel.org>" <linux-wireless@vger.kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>, linux@rainbow-software.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, 16 Jun 2019 at 21:43, Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Sun, Jun 16, 2019 at 09:03:58PM +0200, Ard Biesheuvel wrote:
> > >
> > > Otherwise this patch looks correct to me.
> > >
> > > The actual crypto in this driver, on the other hand, looks very outdated and
> > > broken.  Apparently it's implementing some Cisco proprietary extension to WEP
> > > that uses a universal hashing based MAC, where the hash key is generated from
> > > AES-CTR.  But the MAC is only 32 bits, and the universal hash (MMH) is
> > > implemented incorrectly: there's an off-by-one error in emmh32_final() in the
> > > code that is supposed to be an optimized version of 'sum % ((1ULL << 32) + 15)'.
> > >
> >
> > I stared at that code for a bit, and I don't see the problem.
> >
>
> I'm fairly certain that the line:
>
>         if (utmp > 0x10000000fLL)
>
> is supposed to be:
>
>         if (utmp >= 0x10000000fLL)
>

Ah yes, I see what you mean. 0x10000000f % 0x10000000f == 0 not 15
(after truncation). So yes, that is definitely a bug.

> Since it's doing mod 0x10000000f.  It's supposed to be an optimized
> implementation of 'val = (u32)(context->accum % 0x10000000f)' where 0x10000000f
> is the prime number 2^32 + 15.  It's meant to be the MMH algorithm: Section 3.2
> of https://link.springer.com/content/pdf/10.1007/BFb0052345.pdf.  But there are
> values of 'accum' where it gives the wrong result, e.g. 14137323879880455377.
>
> Possibly this is a bug in the Cisco MIC protocol itself so can't be fixed.
>

Highly unlikely. But also highly irrelevant :-)

> > > Do we know whether anyone is actually using this, or is this just another old
> > > driver that's sitting around unused?
> > >
> >
> > Excellent question. I take it this is pre-802.11b hardware, and so
> > even the OpenWRT people are unlikely to still be using this.
>

I'd be fine with dropping this driver. I am just trying to get rid of
(ab)use of the crypto cipher interface, so either we change it or we
drop it.
