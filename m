Return-Path: <SRS0=UJZd=ST=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A15B8C282DC
	for <linux-crypto@archiver.kernel.org>; Wed, 17 Apr 2019 21:43:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 61AE621850
	for <linux-crypto@archiver.kernel.org>; Wed, 17 Apr 2019 21:43:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="tVFA7q38"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387797AbfDQVnX (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 17 Apr 2019 17:43:23 -0400
Received: from mail-it1-f193.google.com ([209.85.166.193]:36067 "EHLO
        mail-it1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387792AbfDQVnW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 17 Apr 2019 17:43:22 -0400
Received: by mail-it1-f193.google.com with SMTP id y10so220987itc.1
        for <linux-crypto@vger.kernel.org>; Wed, 17 Apr 2019 14:43:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Vj7CxloxlcVufAsUkWs/c66CTnAWrEgC8z8/84E1x0k=;
        b=tVFA7q380yABsNaOlIBJUMVcvCcAHyTFnAtUReKW1+z1Tm//P7hLZqhFbhDZkCJv0u
         E1kNY6VWFHtRmiALt0AnJeYpb2O2KhrWZA5o5/Vu9MX0TuLVqVDtFvv3C6asGJ9vTqtN
         xGlH4k1ALN5b2SIMgg0D0YyyaMcvJ39/qccQaxE/is5eCRNh9ugTv6TCTWFbufvoXqE0
         pZmc4crEYmslU+YS7Z+rQWAtGun7VIMBk0B7FeaHCZs7jsbZSYFYeIpzsHcIvLAqwlMw
         OcM9d8TE1jSYn8ml1yM0ies9j+drhqIXs3JmocsKMm/CwOoWNHg428AiAQwiMnhAUWIc
         dSkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Vj7CxloxlcVufAsUkWs/c66CTnAWrEgC8z8/84E1x0k=;
        b=sGyir5TkdE2nAWGfP6aangCTt9f7EO39T1+IpSL7IGJtHzrAaToZfVcBN+VJUHoS2H
         GNobxpB+DjjKstTocK0noDw0a06wA2epx+ypu0ANLbzyr9AdlYpYmYr+z8tRSR4PJn6+
         IjFDXbcOczRPAsfQc0WxYy4AxOsBbs3msaD/dV0G6W69u4xqaTrNnFcJXB1w9aS8MxIS
         anBRVcDYJu7lNNyBszSAUWHJzN/HbvF+MRpetbCCqwASiuFgNqVAU2cN+zirlV1gGX1+
         JYOl6uStVcdJwjBeccAo4wYEfzru2pXlfooRUYbGxY+7wQlMqcU29nASEv7M8nHAoMx4
         ZdZQ==
X-Gm-Message-State: APjAAAWdA0DikXfP8HSEj3qR///G7IjD+H4YyNWLTrsOTlyrEWMlDttT
        BAx3PgBkzlRYgAF5QsHHnGLRg/qOhVE+Pge6cTnLmw==
X-Google-Smtp-Source: APXvYqzVES8/xCQiB7Ss65nWhHoe905HspZYDglFq87hqwFEentCFru63ILkQY1WiIPcvZ4bV/8yT179GN7fJPaBy7M=
X-Received: by 2002:a24:1312:: with SMTP id 18mr589995itz.121.1555537401703;
 Wed, 17 Apr 2019 14:43:21 -0700 (PDT)
MIME-Version: 1.0
References: <AM6PR09MB352386B26E3F632D6FE2FDDDD2250@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <20190417202407.GA96242@gmail.com> <AM6PR09MB3523FD88FE64E10B78B555F4D2250@AM6PR09MB3523.eurprd09.prod.outlook.com>
In-Reply-To: <AM6PR09MB3523FD88FE64E10B78B555F4D2250@AM6PR09MB3523.eurprd09.prod.outlook.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Wed, 17 Apr 2019 14:43:10 -0700
Message-ID: <CAKv+Gu9AztOdP2GfR-DBTfTcgjJrjMJ7HbApWG-EpPjpSfn16A@mail.gmail.com>
Subject: Re: Question regarding crypto scatterlists / testmgr
To:     Pascal Van Leeuwen <pvanleeuwen@insidesecure.com>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, 17 Apr 2019 at 14:17, Pascal Van Leeuwen
<pvanleeuwen@insidesecure.com> wrote:
>
> > -----Original Message-----
> > From: Eric Biggers [mailto:ebiggers@kernel.org]
> > Sent: Wednesday, April 17, 2019 10:24 PM
> > To: Pascal Van Leeuwen <pvanleeuwen@insidesecure.com>
> > Cc: linux-crypto@vger.kernel.org; Herbert Xu
> > <herbert@gondor.apana.org.au>
> > Subject: Re: Question regarding crypto scatterlists / testmgr
> >
> > Hi Pascal,
> >
> > On Wed, Apr 17, 2019 at 07:51:08PM +0000, Pascal Van Leeuwen wrote:
> > > Hi,
> > >
> > > I'm trying to fix the inside-secure driver to pass all testmgr
> > > tests and I have one final issue remaining with the AEAD ciphers.
> > > As it was not clear at all what the exact problem was, I spent
> > > some time reverse engineering testmgr and I got the distinct
> > > impression that it is using scatter particles that cross page
> > > boundaries. On purpose, even.
> > >
> > > While the inside-secure driver is built on the premise that
> > > scatter particles are continuous in device space. As I can't
> > > think of any reason why you would want to scatter/gather other
> > > than to handle virtual-to-physical address translation ...
> > > In any case, this should affect all other other operations as
> > > well, but maybe those just got "lucky" by getting particles
> > > that were still contiguous in device space, despite the page
> > > crossing (to *really* verify this, you would have to fully
> > > randomize your page allocation!)
> > >
> > > Anyway, assuming that I *should* be able to handle particles
> > > that are *not* contiguous in device space, then there should
> > > probably already exist some function in the kernel API that
> > > converts a scatterlist with non-contiguous particles into a
> > > scatterlist with contiguous particles, taking into account the
> > > presence of an IOMMU? Considering pretty much every device
> > > driver would need to do that?
> > > Does anyone know which function(s) to use for that?
> > >
> > > Regards,
> > > Pascal van Leeuwen
> > > Silicon IP Architect, Multi-Protocol Engines @ Inside Secure
> > >
> >
> > Indeed, since v5.1, testmgr tests scatterlist elements that cross a
> > page.
> > However, the pages are guaranteed to be *physically* contiguous.  Does
> > dma_map_sg() not handle this?
> >
> I'm not entirely sure and the API documentation is not particularly
> clear on *what* dma_map_sg() actually does, but I highly doubt it
> considering the particle count is only an input parameter (i.e. it
> can't output an increase in particles that would be required).
> So I think it just ensures the pages are actually flushed to memory
> and accessible by the device (in case an IOMMU interferes) and not
> much than that.
>
> In any case, scatter particles to be used by hardware should *not*
> cross any physical page boundaries.
> But also see the thread I had on this with Ard - seems like the crypto
> API already has some mechanism for enforcing this but it's not enabled
> for AEAD ciphers?
>

It has simply never been implemented because nobody had a need for it.

> >
> > BTW, this isn't just a theoretical case.  Many crypto API users do
> > crypto on
> > kmalloced buffers, and those can cross a page boundary, especially if
> > they are
> > large.  All software crypto algorithms handle this case.
> >
> Software sits behind the CPU's MMU and sees virtual memory as
> contiguous. It does not need to "handle" anything, it gets it for free.
> Hardware does not have that luxury, unless you have a functioning IOMMU
> but that is still pretty rare.
> So for hardware, you need to break down your buffers until individual
> pages and stitch those together. That's the main use case of a scatter
> list and it requires the particles to NOT cross physical pages.
>

kmalloc() is guaranteed to return physically contiguous memory, but
assuming that this results in contiguous DMA memory requires the DMA
map call to cover the whole thing, or the IOMMU may end up mapping it
in some other way.

The safe approach (which the async walk seems to take) is just to
carve up each scatterlist entry so it does not cross any page
boundaries, and return it as discrete steps in the walk.

> > The fact that these types of issues are just being considered now
> > certainly
> > isn't raising my confidence in the hardware crypto drivers in the
> > kernel...
> >
> Actually, this is *not* a problem with the hardware drivers. It's a
> problem with the API and/or how you are trying to use it. Hardware
> does NOT see the nice contiguous virtual memory that SW sees.
>
> If the driver may expect to receive particles that cross page
> boundaries - if that's the spec - fine, but then it will have to
> break those down into individual pages by itself. However, whomever
> created the inside-secure driver was under the impression that this
> was not supposed to be the case. And I don't know who's right or
> wrong there, but from a side discussion with Ard I got the impression
> that the Crypto API should fix this up before it reaches the driver.
>

To be clear, is that driver upstream? And if so, where does it reside?
