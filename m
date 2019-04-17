Return-Path: <SRS0=UJZd=ST=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C303C282DA
	for <linux-crypto@archiver.kernel.org>; Wed, 17 Apr 2019 21:43:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E1FA821850
	for <linux-crypto@archiver.kernel.org>; Wed, 17 Apr 2019 21:43:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1555537386;
	bh=ZDYF9MmkDwVXPLD9tGwvHjnwgVWR7XCwLmA+c6IwAYE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=qP/5ctsTGh2l+1ledGfD5SMhRRlIT5PYtAH1khUgNbTJHuCMni/uTbIzqv9KopbrV
	 tL4EDSylW125swh2eeHd8VOQxRKcdzHpGwst6H9GEkLnwwGL7jCDd/EoJiaLu4fGWl
	 rPPrsC4r2IAYCgEW3p44aWSag0rdSGjl5tLPh71w=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387577AbfDQVnE (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 17 Apr 2019 17:43:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:53042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387761AbfDQVnB (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 17 Apr 2019 17:43:01 -0400
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A1C9B2183F;
        Wed, 17 Apr 2019 21:43:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1555537380;
        bh=ZDYF9MmkDwVXPLD9tGwvHjnwgVWR7XCwLmA+c6IwAYE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bC02v1jMImpWuwZsb/JUm4KuO6p/F9JOo8dg77oQ9Mr/vuswvdDytQjRVHtdX0Oly
         uRE2jXHv0jGOBXwKF3OUNjxL4ejD8VMkXIG7aue9z2d8WrD41NU9pmUvCR9EmFCWkJ
         fZcXh5nRQXUn2+RqfQPhnNgQBjWALVYxYBkziwNE=
Date:   Wed, 17 Apr 2019 14:42:59 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Pascal Van Leeuwen <pvanleeuwen@insidesecure.com>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Question regarding crypto scatterlists / testmgr
Message-ID: <20190417214257.GB96242@gmail.com>
References: <AM6PR09MB352386B26E3F632D6FE2FDDDD2250@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <20190417202407.GA96242@gmail.com>
 <AM6PR09MB3523FD88FE64E10B78B555F4D2250@AM6PR09MB3523.eurprd09.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM6PR09MB3523FD88FE64E10B78B555F4D2250@AM6PR09MB3523.eurprd09.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Pascal,

On Wed, Apr 17, 2019 at 09:16:54PM +0000, Pascal Van Leeuwen wrote:
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
> > The fact that these types of issues are just being considered now
> > certainly
> > isn't raising my confidence in the hardware crypto drivers in the
> > kernel...
> >
> Actually, this is *not* a problem with the hardware drivers. It's a
> problem with the API and/or how you are trying to use it. Hardware
> does NOT see the nice contiguous virtual memory that SW sees.
> 

I don't understand why you keep talking about virtual memory.  The memory in
each scatterlist element is referenced by struct page, not by virtual address.
It may cross page boundaries; however, all pages referenced by each element are
guaranteed to be adjacent, i.e. physically contiguous.  Am I missing something?

Note that memory allocated by kmalloc() is both virtually and physically
contigious.  That's why it works to use sg_init_one() on a kmalloc()'ed buffer.

- Eric
