Return-Path: <SRS0=r3Tc=N4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25B6DC43441
	for <linux-crypto@archiver.kernel.org>; Sat, 17 Nov 2018 00:30:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DF7062086B
	for <linux-crypto@archiver.kernel.org>; Sat, 17 Nov 2018 00:30:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="HvaNbR20"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DF7062086B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-crypto-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730014AbeKQKpG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 17 Nov 2018 05:45:06 -0500
Received: from mail-it1-f194.google.com ([209.85.166.194]:50642 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730013AbeKQKpG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 17 Nov 2018 05:45:06 -0500
Received: by mail-it1-f194.google.com with SMTP id k206-v6so500977ite.0
        for <linux-crypto@vger.kernel.org>; Fri, 16 Nov 2018 16:30:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7u/+cJXD0UoTG9d8nnFd74lsjEzPiwghOEk4XnxTyUs=;
        b=HvaNbR2076S4ij6ERJSss+iQzNftyGNTuh6niQnnNM0nIoABLcPWbwHOveYpqc8vVP
         Qe21ALl9jjTMk6G1XOwxhYIxexMdgvq/JHLog91KP1jxXvBlzPyC5jr6aBjLrKxW/O+C
         lLNSpFtefnqo60kIKFwsp5O0PZyHKo0GgywLw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7u/+cJXD0UoTG9d8nnFd74lsjEzPiwghOEk4XnxTyUs=;
        b=P95KYyGCESTIjBd7/36P/+ERCc3IK1QhSfYqQJGIOk7CrZmsi+K8xgSj9QEF4Zyqlo
         NHvsRiPe3y2y0atihKEYGJMT678TgWNvQ+4aODauP4/6fDgUSaxP+yW97wujg6h+coP1
         s+mXmlRZp2M8ckl0HBguRfiUQapHqyfRvNbaVw1i+zJFGIByCs4TvUjagOADHDSM+iOy
         3BmoYn/Rifak+h/cRLWlX7/BdQiVIMs07VUapN2Vvu3YrC5oZZ+8PZrX8uzbYoEZ+0tm
         gWejj7SlA+ovb7jI5JzLb9HMacwqdTXY668vqzYOk79PsQK0U6GFLNCOopVf/AbpSoXL
         macA==
X-Gm-Message-State: AA+aEWag+iPA4R7ZFftNPFLw8w42lDpBlGpzXUUqoTZvq8ZQyAjSW5xq
        26InPGvulqTN0NHx6W7po8RzaLuEOyHzvix9sDvyv8gkWEA=
X-Google-Smtp-Source: AFSGD/Xyo007+YIFpyDCZ2Mt0l/xBFEtr+Nx88hO6ZvURd5I9TuQLH/5YQ6A+cg2BHioatKqlpYgAbPgrNeUqL5TE+8=
X-Received: by 2002:a24:7d8d:: with SMTP id b135-v6mr369977itc.121.1542414632094;
 Fri, 16 Nov 2018 16:30:32 -0800 (PST)
MIME-Version: 1.0
References: <20181105232526.173947-1-ebiggers@kernel.org> <20181105232526.173947-11-ebiggers@kernel.org>
 <CAKv+Gu-o0khD5=0EOkv2PiczMs5uZ=XP9V=G2ogBNMK8Kb93sw@mail.gmail.com>
 <20181112185816.GA8663@gmail.com> <20181116060227.hwu4igi6bp26ddpi@gondor.apana.org.au>
 <20181117001718.GA175522@gmail.com>
In-Reply-To: <20181117001718.GA175522@gmail.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Fri, 16 Nov 2018 16:30:20 -0800
Message-ID:
 <CAKv+Gu9KU9pviBsmAJUoSdBDK6Sk-7TdM0avgFdz-0AaOwaD9Q@mail.gmail.com>
Subject: Re: [RFC PATCH v3 10/15] crypto: poly1305 - use structures for key
 and accumulator
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>, linux-fscrypt@vger.kernel.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Paul Crowley <paulcrowley@google.com>,
        Greg Kaiser <gkaiser@google.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Samuel Neves <samuel.c.p.neves@gmail.com>,
        Tomer Ashur <tomer.ashur@esat.kuleuven.be>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
Message-ID: <20181117003020.yIupdjno5WoCsTrsgSvnICCqTtXfPMJMQ8pC0JK1IB0@z>

On Fri, 16 Nov 2018 at 16:17, Eric Biggers <ebiggers@kernel.org> wrote:
>
> Hi Herbert,
>
> On Fri, Nov 16, 2018 at 02:02:27PM +0800, Herbert Xu wrote:
> > Hi Eric:
> >
> > On Mon, Nov 12, 2018 at 10:58:17AM -0800, Eric Biggers wrote:
> > >
> > > I prefer separate types so that the type system enforces that a key is never
> > > accidentally used as an accumulator, and vice versa.  Then the poly1305_core_*
> > > functions will be harder to misuse, and the Poly1305 MAC implementations harder
> > > to get wrong.
> > >
> > > The key also has certain bits clear whereas the accumulator does not.  In the
> > > future, the Poly1305 C implementation might use base 2^32 and take advantage of
> > > this.  In that case, the two inputs to each multiplication won't be
> > > interchangeable, so using the same type for both would be extra confusing.
> > >
> > > Having a poly1305_val nested inside poly1305_key and poly1305_state would work,
> > > but seemed excessive.
> >
> > So it looks like there are no more unresolved issues with this
> > patch series.  Please let me know when you want it to go in.
> >
>
> I believe it's ready to go in.  I'll need to rebase it onto cryptodev, to
> resolve some small conflicts with the recent ChaCha20-related changes.  Also
> I'll probably omit the fscrypt patch (patch 15/15) so that that patch can be
> taken through the fscrypt tree instead.
>
> Do you prefer that this be merged before or after Zinc?  It seems it may still
> be a while before the community is satisfied with Zinc (and Wireguard which is
> in the same patchset), and I don't want this blocked unnecessarily...  So on my
> part I'd prefer to just have this merged as-is.
>
> Of course, it's always possible to change the xchacha12 and xchacha20
> implementations later, whether that's to use "Zinc" or otherwise.  And
> NHPoly1305 and Adiantum itself will be the same either way, except that the
> Poly1305 helpers may change slightly.
>
> What do you think?
>

I think this is ready to go in. Most of Zinc itself will not be
blocked by this, only the changes to the crypto API ChaCha20
implementation will have to wait until the Zinc version gains support
for the reduced round variant, but that will not block WireGuard.
