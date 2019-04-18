Return-Path: <SRS0=uowK=SU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B774C282DA
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Apr 2019 03:30:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F0284217F4
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Apr 2019 03:30:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="QiD/qlHo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732737AbfDRDaM (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 17 Apr 2019 23:30:12 -0400
Received: from mail-it1-f196.google.com ([209.85.166.196]:40559 "EHLO
        mail-it1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732325AbfDRDaM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 17 Apr 2019 23:30:12 -0400
Received: by mail-it1-f196.google.com with SMTP id k64so1211261itb.5
        for <linux-crypto@vger.kernel.org>; Wed, 17 Apr 2019 20:30:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=h4rNPpX/j4GUK9ij0QO9lMdaE4KefH15AE6eaO3AjlI=;
        b=QiD/qlHoPh5LfnCD3MbBL5DIF9hJkxD4VC1u609WUCvZ26vcSc3Vv9PRDTT58TOfQk
         VIiizLVKFhaSpr5d4euocJ7lod085RAJwgyOUXm7g7zCWXPmzNa2YZIT5TZyWyj8bp2N
         4U5rALoG3zDPrrjwJPTZkX/h3L/+LdWDFRAf3atndmUevpWARLUpaDTxP43179MqKN61
         wa3SG3I/kKwSSYQsSVjcokNiy1endfivlpjzzb2dgabZjtDee8JtnC4JT8Ony2n1QzgM
         Hnft/WJFl2hZqnm16D5k2/92jIJtZlg5K13Qv0l7A1YB7wyA/cTizjdV+4aVSDLSWHCT
         afPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=h4rNPpX/j4GUK9ij0QO9lMdaE4KefH15AE6eaO3AjlI=;
        b=IU6pxphjybilAIfcXMBhhc9YUhdXzTR/H1kCMdDfDJw+VVSoFBObnqXzvqt2kW7QWV
         /iO7ZC2cGg9G8RReXIPQnBoOQ1jqMEH6JB8obhdSuLKr3R27Q+H+C2/6MTXPtLa+bNVc
         JNCvTkmWCdLt599sxK+Z40e1cck//7Pg6C589V83otoiyCk6zDAbagiK9A7xnqUcgMe5
         3MJkhwX8/KJqqxX2PXjAGSoZUm8tjVFq5Sh4QsH7YyPvYJa2cm6sXiSJswhGeiFoc9X3
         JQZsVHnheRYBRY5V6RPb4BQ0Ag60fY/8EnGThh9+MDXSfHLu3OoeAcUSR0jypoeb6hRE
         P6Gg==
X-Gm-Message-State: APjAAAVGfQhCswRrdpmN+g7vyRDkJ1G0UfEnSC1+xUHFA0lGZkDgqrPt
        CACzgDYKTntQkKZgEAqrb2Y1Tfg+bq3FAu9XL8ZhtQ==
X-Google-Smtp-Source: APXvYqx4AcwZ1CctbPkOCAa9dFMwC+r2ajN/eb2sutE/2D2BmT7z8mmVX12Uq1gzg8+2pzt77uutaVa7ZwKazqHuhO4=
X-Received: by 2002:a05:660c:4c2:: with SMTP id v2mr1722036itk.71.1555558211484;
 Wed, 17 Apr 2019 20:30:11 -0700 (PDT)
MIME-Version: 1.0
References: <AM6PR09MB352386B26E3F632D6FE2FDDDD2250@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <20190417202407.GA96242@gmail.com> <AM6PR09MB3523FD88FE64E10B78B555F4D2250@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <CAKv+Gu9AztOdP2GfR-DBTfTcgjJrjMJ7HbApWG-EpPjpSfn16A@mail.gmail.com> <AM6PR09MB3523EFFDD4FF6910B4AA12C3D2260@AM6PR09MB3523.eurprd09.prod.outlook.com>
In-Reply-To: <AM6PR09MB3523EFFDD4FF6910B4AA12C3D2260@AM6PR09MB3523.eurprd09.prod.outlook.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Wed, 17 Apr 2019 20:29:59 -0700
Message-ID: <CAKv+Gu9_8DgmNhzVqXbkrv7y-7++a-yYxXkaYNzV-yDArDtyZQ@mail.gmail.com>
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

On Wed, 17 Apr 2019 at 20:16, Pascal Van Leeuwen
<pvanleeuwen@insidesecure.com> wrote:
>
> > -----Original Message-----
> > From: Ard Biesheuvel [mailto:ard.biesheuvel@linaro.org]
> > Sent: Wednesday, April 17, 2019 11:43 PM
> > To: Pascal Van Leeuwen <pvanleeuwen@insidesecure.com>
> > Cc: Eric Biggers <ebiggers@kernel.org>; linux-crypto@vger.kernel.org;
> > Herbert Xu <herbert@gondor.apana.org.au>
> > Subject: Re: Question regarding crypto scatterlists / testmgr
> >
> > On Wed, 17 Apr 2019 at 14:17, Pascal Van Leeuwen
> > <pvanleeuwen@insidesecure.com> wrote:
> > >
> > > > -----Original Message-----
> > > > From: Eric Biggers [mailto:ebiggers@kernel.org]
> > > > Sent: Wednesday, April 17, 2019 10:24 PM
> > > > To: Pascal Van Leeuwen <pvanleeuwen@insidesecure.com>
> > > > Cc: linux-crypto@vger.kernel.org; Herbert Xu
> > > > <herbert@gondor.apana.org.au>
> > > > Subject: Re: Question regarding crypto scatterlists / testmgr
> > > >
> > > > Hi Pascal,
> > > >
> > > > On Wed, Apr 17, 2019 at 07:51:08PM +0000, Pascal Van Leeuwen wrote:
> > > > > Hi,
> > > > >
> > > > > I'm trying to fix the inside-secure driver to pass all testmgr
> > > > > tests and I have one final issue remaining with the AEAD ciphers.
> > > > > As it was not clear at all what the exact problem was, I spent
> > > > > some time reverse engineering testmgr and I got the distinct
> > > > > impression that it is using scatter particles that cross page
> > > > > boundaries. On purpose, even.
> > > > >
> > > > > While the inside-secure driver is built on the premise that
> > > > > scatter particles are continuous in device space. As I can't
> > > > > think of any reason why you would want to scatter/gather other
> > > > > than to handle virtual-to-physical address translation ...
> > > > > In any case, this should affect all other other operations as
> > > > > well, but maybe those just got "lucky" by getting particles
> > > > > that were still contiguous in device space, despite the page
> > > > > crossing (to *really* verify this, you would have to fully
> > > > > randomize your page allocation!)
> > > > >
> > > > > Anyway, assuming that I *should* be able to handle particles
> > > > > that are *not* contiguous in device space, then there should
> > > > > probably already exist some function in the kernel API that
> > > > > converts a scatterlist with non-contiguous particles into a
> > > > > scatterlist with contiguous particles, taking into account the
> > > > > presence of an IOMMU? Considering pretty much every device
> > > > > driver would need to do that?
> > > > > Does anyone know which function(s) to use for that?
> > > > >
> > > > > Regards,
> > > > > Pascal van Leeuwen
> > > > > Silicon IP Architect, Multi-Protocol Engines @ Inside Secure
> > > > >
> > > >
> > > > Indeed, since v5.1, testmgr tests scatterlist elements that cross a
> > > > page.
> > > > However, the pages are guaranteed to be *physically* contiguous.
> > Does
> > > > dma_map_sg() not handle this?
> > > >
> > > I'm not entirely sure and the API documentation is not particularly
> > > clear on *what* dma_map_sg() actually does, but I highly doubt it
> > > considering the particle count is only an input parameter (i.e. it
> > > can't output an increase in particles that would be required).
> > > So I think it just ensures the pages are actually flushed to memory
> > > and accessible by the device (in case an IOMMU interferes) and not
> > > much than that.
> > >
> > > In any case, scatter particles to be used by hardware should *not*
> > > cross any physical page boundaries.
> > > But also see the thread I had on this with Ard - seems like the
> > crypto
> > > API already has some mechanism for enforcing this but it's not
> > enabled
> > > for AEAD ciphers?
> > >
> >
> > It has simply never been implemented because nobody had a need for it.
> >
> > > >
> > > > BTW, this isn't just a theoretical case.  Many crypto API users do
> > > > crypto on
> > > > kmalloced buffers, and those can cross a page boundary, especially
> > if
> > > > they are
> > > > large.  All software crypto algorithms handle this case.
> > > >
> > > Software sits behind the CPU's MMU and sees virtual memory as
> > > contiguous. It does not need to "handle" anything, it gets it for
> > free.
> > > Hardware does not have that luxury, unless you have a functioning
> > IOMMU
> > > but that is still pretty rare.
> > > So for hardware, you need to break down your buffers until individual
> > > pages and stitch those together. That's the main use case of a
> > scatter
> > > list and it requires the particles to NOT cross physical pages.
> > >
> >
> > kmalloc() is guaranteed to return physically contiguous memory, but
> > assuming that this results in contiguous DMA memory requires the DMA
> > map call to cover the whole thing, or the IOMMU may end up mapping it
> > in some other way.
> >
> > The safe approach (which the async walk seems to take) is just to
> > carve up each scatterlist entry so it does not cross any page
> > boundaries, and return it as discrete steps in the walk.
> >
> That's interesting. Is that actually true though or just assumption?
> If the pages are guaranteed to be contiguous, then why break up the
> scatter chain further into individual pages?
> For our hardware, the number of particles may become a performance
> bottleneck, so the less particles the better. Also, the work to walk
> the chain and break it up would take up precious CPU cycles.
>

Seems like I was misreading the code: we have the following code in
skcipher_walk_next

if (!err && (walk->flags & SKCIPHER_WALK_PHYS)) {
    walk->src.phys.page = virt_to_page(walk->src.virt.addr);
    walk->dst.phys.page = virt_to_page(walk->dst.virt.addr);
    walk->src.phys.offset &= PAGE_SIZE - 1;
    walk->dst.phys.offset &= PAGE_SIZE - 1;
}

but all that does is normalize the offset. In fact, this code looks
slightly dodgy to me, given that, if the offset /does/ exceed
PAGE_SIZE, it normalizes the offset but does not advance the page
pointers accordingly.

The thing to be aware of is that struct pages are not guaranteed to be
mapped on the CPU, and so a lot of the virt handling deals with
mapping/unmapping on the *cpu* side rather than the device side. So a
phys walk gives you each physically contiguous entry in turn, and it
is up to the device driver to map it for DMA if needed.

To satisfy my curiosity, I looked at the existing async drivers, and
very few actually appear to be using any of this stuff. So perhaps my
attempt to clarify things ended up achieving the opposite, and we are
really only interested in whether dma_map_sg() does what you expect in
your driver.

> >
> > > > The fact that these types of issues are just being considered now
> > > > certainly
> > > > isn't raising my confidence in the hardware crypto drivers in the
> > > > kernel...
> > > >
> > > Actually, this is *not* a problem with the hardware drivers. It's a
> > > problem with the API and/or how you are trying to use it. Hardware
> > > does NOT see the nice contiguous virtual memory that SW sees.
> > >
> > > If the driver may expect to receive particles that cross page
> > > boundaries - if that's the spec - fine, but then it will have to
> > > break those down into individual pages by itself. However, whomever
> > > created the inside-secure driver was under the impression that this
> > > was not supposed to be the case. And I don't know who's right or
> > > wrong there, but from a side discussion with Ard I got the impression
> > > that the Crypto API should fix this up before it reaches the driver.
> > >
> >
> > To be clear, is that driver upstream? And if so, where does it reside?
> >
> FYI: the original driver I started with is upstream:
> drivers/crypto/inside-secure
>

OK, so indeed, you are using dma_map_sg(), which seems absolutely fine
if your hardware supports that model. So apologies for the noise ...
