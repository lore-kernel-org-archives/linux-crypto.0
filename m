Return-Path: <SRS0=gCBe=74=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C491C433DF
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Jun 2020 23:18:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 024B32074D
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Jun 2020 23:18:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1592263099;
	bh=0lMLIkwl4w9/dfCEn9YTRLlXZ3qDJdU/d1GLx5TaHD4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=Bldhqq2YOjFTzYT1yz0ikbgxw5uypDHxGAELf9VvZpdyPqMYwOspxYzXovaShT8tv
	 tiDwyyIPxyk6PVa8e/dFTleLSCOMGu/xFnf3QL0+LxSfsT6as1Hs7IaeMBZQWvosN1
	 0LVeEVxMXmtnJQZECtZt1gztPgqs4TMghSqrCE3w=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726545AbgFOXSS (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 15 Jun 2020 19:18:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:39694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726452AbgFOXSQ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 15 Jun 2020 19:18:16 -0400
Received: from mail-ot1-f43.google.com (mail-ot1-f43.google.com [209.85.210.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4DCB32074D
        for <linux-crypto@vger.kernel.org>; Mon, 15 Jun 2020 23:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592263095;
        bh=0lMLIkwl4w9/dfCEn9YTRLlXZ3qDJdU/d1GLx5TaHD4=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=J8Eez3hNczkDFZt6sGTADbngomRfSk42P8tmSJ37/Z+8ixLYL7lz9VpkqxtFshUGl
         DhDLSIi7Jzlu1lfSzPqNhHXyZMQTc3elLxsEDLPbnQRnUgukDEiiwoaqODvcrIqNRr
         5/4bKc/rX8on0uPhgRoyznPqhXdOtAvpDuNIU4iM=
Received: by mail-ot1-f43.google.com with SMTP id e5so14487688ote.11
        for <linux-crypto@vger.kernel.org>; Mon, 15 Jun 2020 16:18:15 -0700 (PDT)
X-Gm-Message-State: AOAM530JGeJUACD6RKIe2WpPXRemF0E+SOTyjOFFyC3s6/rBKID/y/7R
        oLbgo8iqDvzJZnW3UExoQmZlfkOcGQDaCdlzUPE=
X-Google-Smtp-Source: ABdhPJz8VeBWh1W/iD20tHbET+xJZn0zhQ99dDqUxRvpW+FF5bGoFLVHv6i4KjWq/9i2MOOkB5xPqsuwAM4ccz2zrco=
X-Received: by 2002:a9d:42e:: with SMTP id 43mr317576otc.108.1592263094627;
 Mon, 15 Jun 2020 16:18:14 -0700 (PDT)
MIME-Version: 1.0
References: <20200612120643.GA15724@gondor.apana.org.au> <E1jjiTA-0005BO-9n@fornost.hmeau.com>
 <1688262.LSb4nGpegl@tauon.chronox.de> <20200612121651.GA15849@gondor.apana.org.au>
 <20200612122105.GA18892@gondor.apana.org.au> <CAMj1kXGg25JL7WCrspMwB1PVPX6vx-rOCesg08a_Fy26_ET7Sg@mail.gmail.com>
 <20200615073024.GA27015@gondor.apana.org.au> <CAMj1kXHQNHh4PTLmGKaL+sSyuU1AS4u5F=OyjV6XuAaD21e6yg@mail.gmail.com>
 <20200615185028.GB85413@gmail.com>
In-Reply-To: <20200615185028.GB85413@gmail.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Tue, 16 Jun 2020 01:18:03 +0200
X-Gmail-Original-Message-ID: <CAMj1kXFJj_X2WZ_ru5j2xC4fspdH_dnwxodSF-YF5FB+gYvk1w@mail.gmail.com>
Message-ID: <CAMj1kXFJj_X2WZ_ru5j2xC4fspdH_dnwxodSF-YF5FB+gYvk1w@mail.gmail.com>
Subject: Re: [v2 PATCH 0/3] crypto: skcipher - Add support for no chaining and
 partial chaining
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Stephan Mueller <smueller@chronox.de>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 15 Jun 2020 at 20:50, Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Mon, Jun 15, 2020 at 09:50:50AM +0200, Ard Biesheuvel wrote:
> > On Mon, 15 Jun 2020 at 09:30, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> > >
> > > On Fri, Jun 12, 2020 at 06:10:57PM +0200, Ard Biesheuvel wrote:
> > > >
> > > > First of all, the default fcsize for all existing XTS implementations
> > > > should be -1 as well, given that chaining is currently not supported
> > > > at all at the sckipher interface layer for any of them (due to the
> > > > fact that the IV gets encrypted with a different key at the start of
> > >
> > > Sure.  I was just too lazy to actually set the -1 everywhere.  I'll
> > > try to do that before I repost again.
> > >
> >
> > Fair enough
> >
> > > > the operation). This also means it is going to be rather tricky to
> > > > implement for h/w accelerated XTS implementations, and it seems to me
> > > > that the only way to deal with this is to decrypt the IV in software
> > > > before chaining the next operation, which is rather horrid and needs
> > > > to be implemented by all of them.
> > >
> > > I don't think we should support chaining for XTS at all so I don't
> > > see why we need to worry about the hardware accelerated XTS code.
> > >
> >
> > I would prefer that. But if it is fine to disallow chaining altogether
> > for XTS, why can't we do the same for cbc-cts? In both cases, user
> > space cannot be relying on it today, since the output is incorrect,
> > even for inputs that are a round multiple of the block size but are
> > broken up and chained.
> >
> > > > Given that
> > > >
> > > > a) this is wholly an AF_ALG issue, as there are no in-kernel users
> > > > currently suffering from this afaik,
> > > > b) using AF_ALG to get access to software implementations is rather
> > > > pointless in general, given that userspace can simply issue the same
> > > > instructions directly
> > > > c) fixing all XTS and CTS implementation on all arches and all
> > > > accelerators is not a small task
> > > >
> > > > wouldn't it be better to special case XTS and CBC-CTS in
> > > > algif_skcipher instead, rather than polluting the skipcher API this
> > > > way?
> > >
> > > As I said we need to be able to differentiate between the ones
> > > that can chain vs. the ones that can't.  Putting this knowledge
> > > directly into algif_skcipher is just too horrid.
> > >
> >
> > No disagreement on the horrid. But polluting the API for an issue that
> > only affects AF_ALG, which can't possibly be working as expected right
> > now is not a great thing either.
> >
> > > The alternative is to add this marker into the algorithms.  My
> > > point was that if you're going to do that you might as well go
> > > a step further and allow cts to chain as it is so straightforward.
> > >
> >
> > Given the fact that algos that require chaining are broken today and
> > nobody noticed until Stephan started relying on the skcipher request
> > object's IV field magically retaining its value on subsequent reuse, I
> > would prefer it if we could simply mark all of them as non-chainable
> > and be done with it. (Note that Stephan's case was invalid to begin
> > with)
>
> Wouldn't it make a lot more sense to make skcipher algorithms non-chainable by
> default, and only opt-in the ones where chaining is actually working?  At the
> moment we only test iv_out for CBC and CTR, so we can expect that all the others
> are broken.
>

Agreed. But there is a difference, though. XTS and CBC-CTS are
guaranteed not to be used in a chaining manner today, given that there
is no possible way you could get the right output for a AF_ALG request
that has been split into several skcipher requests: XTS has the IV
encryption that occurs only once, and CBC-CTS has the unconditional
swapping of the last two blocks, which occurs even if the output is a
whole multiple of the block size. Doing either of these more than once
will necessarily result in corrupt output.

For cases where chaining is more straight-forward, we may have users
that we are unaware of, so it is trickier. But that only means that we
may need to require iv_out support for other modes than CBC and CTR,
not that we need to add complexity like this series is doing.

For now, I would prefer to simply introduce a 'permits chaining' flag
that only gets set for CBC and CTR, and without any special handling
to support chaining for modes where doing so is non-trivial and known
to be broken and thus unused anyway. algif_skcipher can then attempt
to allocate the skcipher with the 'permits chaining' flag, and fall
back to allocating without, and deal with the difference accordingly.
Then, we can start adding support for this where necessary, i.e.,
start with any generic skcipher templates that are needed for chaining
support, and add support to other implementations gradually. We should
also start adding iv_out test cases and conditionalize the test on
whether the skcipher has the 'permits chaining' flag set.


> Note that wide-block modes such as Adiantum don't support chaining either.
>
> Also, please use a better name than "fcsize".
>

I don't think we need this at all.
