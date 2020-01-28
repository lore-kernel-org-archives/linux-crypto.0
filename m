Return-Path: <SRS0=0bM2=3R=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 080C9C33CB3
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Jan 2020 07:24:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C15012467B
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Jan 2020 07:24:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=benyossef-com.20150623.gappssmtp.com header.i=@benyossef-com.20150623.gappssmtp.com header.b="flSoyp+6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725810AbgA1HYj (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 28 Jan 2020 02:24:39 -0500
Received: from mail-ua1-f52.google.com ([209.85.222.52]:37702 "EHLO
        mail-ua1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725776AbgA1HYi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Jan 2020 02:24:38 -0500
Received: by mail-ua1-f52.google.com with SMTP id h32so4482633uah.4
        for <linux-crypto@vger.kernel.org>; Mon, 27 Jan 2020 23:24:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=benyossef-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=3M0Y0OxUxSpnyNP07Aeh+9Qp+lQNPHi9BIyAgVeoMDI=;
        b=flSoyp+6HpmakEdKKmMOjF5GlrSZ4ktxXCEr7QIV/qZKacO4dsWuXVUkAJwnA572D9
         0LowFBZ6PEHxhBeybx1VyPRCM2O41PRY6ieN43OdOrABEyayXCUruUSS5IQw0TFRDJLl
         mkcEdPfE6l0GXfNbGXqRsC9w/lRj3wvD7diCL4B0ujud9A6XzpEErbephr/EfJEu+ixV
         5wNClP2EWIrxVEbWrunhtSOevqGlMlEkuU87kaISpryA2UeA3qElKZdmso7tR89veb47
         Wv7P+RJptxMecoEhIwDW5QqTjDpcat2TmTocA1WCfMyCb9lgvcZ3mlIHArhzL8itX4zr
         4aKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=3M0Y0OxUxSpnyNP07Aeh+9Qp+lQNPHi9BIyAgVeoMDI=;
        b=OO53pfvrNueTu6fZLu+JYdzavr6yf568GK83bqFPt7xVdcG/N2AzSrJDY28MZNBvjM
         8BeSRMACb37AE7BZ7AL9D/+UJqUZi13g0bGAHo/tvVwTJSd9q4Aoylji7FXvFEz4Tl31
         s6+SclazeS/movbsTNBe+MNvLkqeCxn4KbeisCgQegorm4uVt+aYm5I/B6w5FmlVIo4d
         49Bn8chVvsCTVBmhDdKCIQI0J9zgFAeKW41aWxsA6rRS0lymvn+Cmr9ZUNDZTdl0kYYL
         zK7CIFF3X/1qAjih4HKB3SM905BME5/QxcJ9yKpV2zPf8dk7GsulFAPPrCd20iBOySSA
         phjQ==
X-Gm-Message-State: APjAAAUf+mowQ/+bbRb3TD2oezn0wa1J3Q7PkV0NYaA6CxdtlQqV0VG6
        VFj+dCKVl/tYg7yyx7dHpU40N+55+41YsIJP//MQGcI0SbY4Rw==
X-Google-Smtp-Source: APXvYqy8s8uadb9n7fFigrRbhzFZUT8TOvEWgXOOr9lzJVC+9Ou0dqlUTG0uz0EeG2eHeW141UVUq0PNqUSvv6NgO3M=
X-Received: by 2002:ab0:77d7:: with SMTP id y23mr11807813uar.4.1580196277483;
 Mon, 27 Jan 2020 23:24:37 -0800 (PST)
MIME-Version: 1.0
References: <CAOtvUMcwLtwgigFE2mx7LVjhhEgcZsSS4WyR_SQ2gixTZxyBfg@mail.gmail.com>
 <20200128023455.GC960@sol.localdomain> <20200128033824.p3z3jhc7mp7wlikp@gondor.apana.org.au>
In-Reply-To: <20200128033824.p3z3jhc7mp7wlikp@gondor.apana.org.au>
From:   Gilad Ben-Yossef <gilad@benyossef.com>
Date:   Tue, 28 Jan 2020 09:24:25 +0200
Message-ID: <CAOtvUMeJmhXL2V74e+LGxDEUJcDy5=f+x0MH86eyHq0u=HvKXw@mail.gmail.com>
Subject: Re: Possible issue with new inauthentic AEAD in extended crypto tests
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        Stephan Mueller <smueller@chronox.de>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        David Miller <davem@davemloft.net>,
        Ofir Drang <Ofir.Drang@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jan 28, 2020 at 5:39 AM Herbert Xu <herbert@gondor.apana.org.au> wr=
ote:
>
> On Mon, Jan 27, 2020 at 06:34:55PM -0800, Eric Biggers wrote:
> >
> > My understanding is that all crypto API functions that take scatterlist=
s only
> > forbid zero-length scatterlist elements in the part of the scatterlist =
that's
> > actually passed to the API call.  The input to these functions is never=
 simply a
> > scatterlist, but rather a (scatterlist, length) pair.  Algorithms shoul=
dn't look
> > beyond 'length', so in the case of 'length =3D=3D 0', they shouldn't lo=
ok at the
> > scatterlist at all -- which may be just a NULL pointer.
> >
> > If that's the case, there's no problem with this test code.
> >
> > I'm not sure the comment in aead.h is relevant here.  It sounds like it=
's
> > warning about not providing an empty scatterlist element for the AAD wh=
en it's
> > followed by a nonempty scatterlist element for the plaintext.  I'm not =
sure it's
> > meant to also cover the case where both are empty.
> >
> > Herbert and Stephan, any thoughts on what was intended?
>
> I agree.  I think this is a bug in the driver.
>

Yes, I agree. After debugging it yesterday along with a similar but
not identical issue with the help of Geert it's a bug in the driver
and will send a fix to the root cause shortly.

<rant>
However while working on debugging this it became obvious to me how
convoluted are the requirements for what to expect from the source
scatterlist of an AEAD request from the transformation provider driver
point of view:

- The source is presumed to have enough room for both the associated
data and the plaintext.
- Unless it's in-place encryption, in which case, you also presume to
have room for the authentication tag
- The only way to tell if this is in-place encryption or not is to
compare the pointers to the source and destination - there is no flag.
- Also, if we happen to be dealing with RFC 4106, you also need to
presume to have room for the IV.
- You can count on the scattergather list not having  a first NULL
buffer, *unless* the plaintext and associated data length are both
zero AND it's not in place encryption.
- You can count on not getting NULL as a scatterlist point, *unless*
the plaintext and associated data length are both zero AND it's not in
place encryption. (I'm actually unsure of this one?)
- The behavior of mapping scattergather lists is dependent on the
architecture, platform and configuration - e.g. even turning on
scatterlist DMA mapping debug option did not detect the issue that
Geert is seeing on his arm64 board that do not appear in mine...

So it's no wonder in a sense we got it wrong and judging from some of
the commits for the other driver maintainer I'm not the only one.

I'm not sure there is something actionable here, maybe just clearer
documentation' but it is feel a somewhat brittle API to implement from
a security hardware driver perspective.

Oh well...
</rant>

Thank you all for your help!
Gilad



 --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt



--=20
Gilad Ben-Yossef
Chief Coffee Drinker

values of =CE=B2 will give rise to dom!
