Return-Path: <SRS0=nVSz=XV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60BB9C4360C
	for <linux-crypto@archiver.kernel.org>; Thu, 26 Sep 2019 12:35:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2A884222BE
	for <linux-crypto@archiver.kernel.org>; Thu, 26 Sep 2019 12:35:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="gKZY6OH5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726077AbfIZMfK (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 26 Sep 2019 08:35:10 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:33818 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726001AbfIZMfK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 26 Sep 2019 08:35:10 -0400
Received: by mail-wr1-f68.google.com with SMTP id a11so2585923wrx.1
        for <linux-crypto@vger.kernel.org>; Thu, 26 Sep 2019 05:35:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ireY1yMCPk29SNDGqM5QiuQBHqF0oJp5y0+v+RNIhtA=;
        b=gKZY6OH5LIkgVMOtNK+O5JyGGQ8XxAbRa90jbbI0RFUyuVkx9+6rOCCjXPQ/WNQoGM
         ic+a9U03U5v8G5b9INspx9IF5jVh2l8UN8uoJEAKRRmILw+7XfSAMEAFMmFn06RbidLG
         8lXmYacZ13j/F4cMBnxTEtNwri7BuilbhmSmSMP1Mjl6y3QOKoU1J4BvOr1Lq2I4E3pF
         1X4ECecESJwu5ANhALxm64LejzMLeWTWXEJVYEh9up7PXTn3CHDjDOtlsM4BYy+uMrlI
         iQjsrv9u3P7j4W3BIRasmG4wiqNekFfnTD9DYrARfLLfYmwX2YlrMOOg1QTX6KsrB7Hm
         YUJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ireY1yMCPk29SNDGqM5QiuQBHqF0oJp5y0+v+RNIhtA=;
        b=UaZpK6BZ+Vs/Sr+vgATpY55lLtPz+/MSHsiKIsBfr4jV+vBG8p5khGCSpZHvLrtcQe
         00xAmilZxaq//pC+cGkzMIAVpdf5Zj1hA0nrr5nvomaKdjJW8Z9NuzYQ/ccOx2TcpiCX
         Ze1OH8yf/5sSgvfaUvecr4gNrK4iROqwCroAWCzX75GtVZRG9JaBIEPbkK3+zkkmxv3j
         O0jp7YulmLfX8lJlTpnpC4cLtEo01sjxrUI8cdv5Nlngsj+pQ0C3o1tNvs1aEOnzHJQS
         l7KUhOUhn3ifbIYysDph/ziC0uIRwJq5M2lUGWK4WnPLz5gKMcYnzO3bolTZoXwfpGKH
         49HA==
X-Gm-Message-State: APjAAAV04nfL9r3UVaZusu5dGa/6QhjVYyEfTyZge1COP5YZu6qIBkW4
        NhRvsC8BIv4bpi1sCnamibovq7unGrw1MqJQW2N1rA==
X-Google-Smtp-Source: APXvYqxSAFn3hpu7g5o1mCuFFiuYM++BftjSOklvARmfgvUNocjxi4xwNIC60YPTkP9aTyIb9AE1yukHr0va/jLxvMk=
X-Received: by 2002:a5d:6a81:: with SMTP id s1mr2392154wru.246.1569501307760;
 Thu, 26 Sep 2019 05:35:07 -0700 (PDT)
MIME-Version: 1.0
References: <20190925161255.1871-1-ard.biesheuvel@linaro.org>
 <20190925161255.1871-19-ard.biesheuvel@linaro.org> <CAHk-=wjYsbxSiV_XKWV3BwGvau_hUvQiQHLOoc7vLUZt0Wqzfw@mail.gmail.com>
 <CAKv+Gu_YOqvqJ4YC=ixBh-v4fiFTFNpEagHiTRU7Oq4PrhJPkw@mail.gmail.com>
In-Reply-To: <CAKv+Gu_YOqvqJ4YC=ixBh-v4fiFTFNpEagHiTRU7Oq4PrhJPkw@mail.gmail.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Thu, 26 Sep 2019 14:34:56 +0200
Message-ID: <CAKv+Gu8JxmU_8byEun17B2d9LjQpR0wRJktUfr-Oax0q4if6Dg@mail.gmail.com>
Subject: Re: [RFC PATCH 18/18] net: wireguard - switch to crypto API for
 packet encryption
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Samuel Neves <sneves@dei.uc.pt>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 26 Sep 2019 at 13:06, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
>
> On Thu, 26 Sep 2019 at 00:15, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > On Wed, Sep 25, 2019 at 9:14 AM Ard Biesheuvel
> > <ard.biesheuvel@linaro.org> wrote:
> > >
> > > Replace the chacha20poly1305() library calls with invocations of the
> > > RFC7539 AEAD, as implemented by the generic chacha20poly1305 template.
> >
> > Honestly, the other patches look fine to me from what I've seen (with
> > the small note I had in a separate email for 11/18), but this one I
> > consider just nasty, and a prime example of why people hate those
> > crypto lookup routines.
> >
> > Some of it is just the fundamental and pointless silly indirection,
> > that just makes things harder to read, less efficient, and less
> > straightforward.
> >
> > That's exemplified by this part of the patch:
> >
> > >  struct noise_symmetric_key {
> > > -       u8 key[NOISE_SYMMETRIC_KEY_LEN];
> > > +       struct crypto_aead *tfm;
> >
> > which is just one of those "we know what we want and we just want to
> > use it directly" things, and then the crypto indirection comes along
> > and makes that simple inline allocation of a small constant size
> > (afaik it is CHACHA20POLY1305_KEY_SIZE, which is 32) be another
> > allocation entirely.
> >
> > And it's some random odd non-typed thing too, so then you have that
> > silly and stupid dynamic allocation using a name lookup:
> >
> >    crypto_alloc_aead("rfc7539(chacha20,poly1305)", 0, CRYPTO_ALG_ASYNC);
> >
> > to create what used to be (and should be) a simple allocation that was
> > has a static type and was just part of the code.
> >
>
> That crypto_alloc_aead() call does a lot of things under the hood:
> - use an existing instantiation of rfc7539(chacha20,poly1305) if available,
> - look for modules that implement the whole transformation directly,
> - if none are found, instantiate the rfc7539 template, which will
> essentially do the above for chacha20 and poly1305, potentially using
> per-arch accelerated implementations if available (for either), or
> otherwise, fall back to the generic versions.
>
> What *I* see as the issue here is not that we need to do this at all,
> but that we have to do it for each value of the key. IMO, it would be
> much better to instantiate this thing only once, and have a way of
> passing a per-request key into it, permitting us to hide the whole
> thing behind the existing library interface.
>

Note that we don't have to do the whole dance for each new value of
the key: subsequent invocations will all succeed at step #1, and grab
the existing instantiation, but allocate a new TFM structure that
refers to it. It is this step that we should be able to omit as well
if the API is changed to allow per-request keys to be passed in via
the request structure.
