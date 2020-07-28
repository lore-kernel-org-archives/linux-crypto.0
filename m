Return-Path: <SRS0=t+Y3=BH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BE3AC433DF
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Jul 2020 16:16:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 46EC02065C
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Jul 2020 16:16:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KxtAVUFF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730810AbgG1QQ2 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 28 Jul 2020 12:16:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730556AbgG1QQ2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Jul 2020 12:16:28 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 199EEC061794
        for <linux-crypto@vger.kernel.org>; Tue, 28 Jul 2020 09:16:28 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id g6so1745510ilc.7
        for <linux-crypto@vger.kernel.org>; Tue, 28 Jul 2020 09:16:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gc+GryM2NEU65ZC/SbbkbBgZ/JTXoDUe5MifWJuSVMk=;
        b=KxtAVUFFTxd6tArwAyIW8a5ZD8mzymmT57GH4NfSTosVKWniqlgecWlp9GcCNot5vG
         TzTQ6AopVUZ8sMzR2xXAOZHH8EbbaArgboxO+bfCe+9wGbO0KtE813vat0xMZdKTBtoG
         CuGPZIOFG7yQhGqDDfwoUs3bvOf8PZgLN9RlHZRUzxQf5XIbY7OgEm2Y20qKpZBosmqF
         uCcC8NwQ1L8lwdg74x9fJCq3zvNdhSfpsUaCX0Ly1um97XS8RIbksYOg7Y2kDigbMOS2
         zv2+fhvb4M2xqNZpuWAWvZuqWyypiYKgQZ3YOamoojwTuDaE/XEKDiInfUnYzgfw5KA5
         nZpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gc+GryM2NEU65ZC/SbbkbBgZ/JTXoDUe5MifWJuSVMk=;
        b=V9ecEdrYHNsFVjv4OteQVpA8737Vw8v7Y50c4Ed9p92+Qz/UAYFcJQCcvwvmyT0Fg8
         ZTBCSFUrc0Mr3DpANk4bz+EG3HYEwhFd/nEDh0NinXeH9RTGhDaxSGNS9N+hZ58Y+JuP
         ogIVcufUNKnZtXxUhLMz68K+MHJHmUfBuUq7JohTyro4GN+3yuIo0OdRrSfN13q6vB6F
         05fZ9zQ/+JeJPw0tHoXpxbkqnbx28IwGYueUm+J2H2JaFtYcjjE9nEOvglejGVBKHckb
         /at5uMA7xFJ2mwH3aHvCyOE1L+9hYOf6beHo+LFnwm3UJNFiJkzzS1ce/QhmT+GG/Vft
         KmUA==
X-Gm-Message-State: AOAM532Jt+YXfB3IMQ/H5lMtkZh9AskhQKMG0C+H8NooPQU1+e4RyirY
        lRRPScGAV+0sQPfEPQX5OO7OsIlCF8vScx6sfARha9s4cBA=
X-Google-Smtp-Source: ABdhPJxPzL4kPzUIoXW9an1Y94giLylqT+b6gGpZceSHVAt9dHKTmepHHaJ91CBB3f1guzg1Hw4Ay2yLBo7o5zrGYek=
X-Received: by 2002:a92:d84d:: with SMTP id h13mr31683484ilq.102.1595952987153;
 Tue, 28 Jul 2020 09:16:27 -0700 (PDT)
MIME-Version: 1.0
References: <CABvBcwY44BPa+TaDwxWaEogpg3Kdkq8o9cR5gSqNGF-o6d3jrw@mail.gmail.com>
 <13569541.ZYm5mLc6kN@tauon.chronox.de> <CABvBcwZ5mQPVFNpw=mY29cXo8oU8yviW5FZEFdKBNLvaudH6Ow@mail.gmail.com>
 <9149882.4vTCxPXJkl@tauon.chronox.de>
In-Reply-To: <9149882.4vTCxPXJkl@tauon.chronox.de>
From:   Elena Petrova <lenaptr@google.com>
Date:   Tue, 28 Jul 2020 17:16:16 +0100
Message-ID: <CABvBcwbDLsy+bQxsFwhjcZRkHz1jbP6VC7Mx8tgLMoUbmYBE_A@mail.gmail.com>
Subject: Re: [PATCH v2] crypto: af_alg - add extra parameters for DRBG interface
To:     Stephan Mueller <smueller@chronox.de>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>, Eric Biggers <ebiggers@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Jeffrey Vander Stoep <jeffv@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Stephan,

On Tue, 21 Jul 2020 at 14:19, Stephan Mueller <smueller@chronox.de> wrote:
>
> Am Dienstag, 21. Juli 2020, 14:55:14 CEST schrieb Elena Petrova:
>
> Hi Elena,
>
> > > > +#ifdef CONFIG_CRYPTO_CAVS_DRBG
> > > > +static int rng_setentropy(void *private, const u8 *entropy, unsigned
> > > > int
> > > > len) +{
> > > > +     struct rng_parent_ctx *pctx = private;
> > > > +     u8 *kentropy = NULL;
> > > > +
> > > > +     if (!capable(CAP_SYS_ADMIN))
> > > > +             return -EPERM;
> > > > +
> > > > +     if (pctx->entropy)
> > > > +             return -EINVAL;
> > > > +
> > > > +     if (len > MAXSIZE)
> > > > +             len = MAXSIZE;
> > > > +
> > > > +     if (len) {
> > > > +             kentropy = memdup_user(entropy, len);
> > > > +             if (IS_ERR(kentropy))
> > > > +                     return PTR_ERR(kentropy);
> > > > +     }
> > > > +
> > > > +     crypto_rng_alg(pctx->drng)->set_ent(pctx->drng, kentropy, len);
> > > > +     pctx->entropy = kentropy;
> > >
> > > Why do you need to keep kentropy around? For the check above whether
> > > entropy was set, wouldn't a boolean suffice?
> >
> > I need to keep the pointer to free it after use. Unlike the setting of
> > the key, DRBG saves the entropy pointer in one of its internal
> > structures, but doesn't do any memory
> > management. I had only two ideas on how to prevent memory leaks:
> > either change drbg code to deal with the memory, or save the pointer
> > somewhere inside the socket. I opted for the latter. But if you know a
> > better approach I'm happy to rework my code accordingly.
>
> I was thinking of calling crypto_rng_alg(pctx->drng)->seed() directly after
> set_ent. This call performs a DRBG instantatiate where the entropy buffer is
> used. See crypto_drbg_reset_test for the approach.
>
> But maybe you are right, the test "entropy" buffer inside the DRBG currently
> cannot be reset. So, for sanity purposes, you need to keep it around.

I looked into this, and afaik `->seed()` needs the seed buffer (a.k.a.
key); and seed() is also invoked on ALG_SET_KEY setsockopt. So we
would need both entropy and seed values at the same time. To avoid
complicating the matters, I decided to leave the code as is. I added a
comment in v3 [https://lore.kernel.org/linux-crypto/20200728155159.2156480-1-lenaptr@google.com/]
explaining why the `kentropy` pointer is saved.

> Ciao
> Stephan

Regards,
Elena
