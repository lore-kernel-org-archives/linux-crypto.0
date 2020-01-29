Return-Path: <SRS0=eQ+U=3S=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AABBC2D0DB
	for <linux-crypto@archiver.kernel.org>; Wed, 29 Jan 2020 12:55:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1FB3720716
	for <linux-crypto@archiver.kernel.org>; Wed, 29 Jan 2020 12:55:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b="RVIuNKXG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726140AbgA2MzH (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 29 Jan 2020 07:55:07 -0500
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.54]:30073 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726069AbgA2MzH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 29 Jan 2020 07:55:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1580302500;
        s=strato-dkim-0002; d=chronox.de;
        h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=kbBDQ/CFiNDzf1QmOXQP49xea+1FaRNOAwy0p+mDpt0=;
        b=RVIuNKXGDoiVWkXsKPmqCZr2hIaOOFBdwqdobc+aCkQmTHFXD+kW/AyTY/XRKTxLZ8
        B0v+QMq6Qk0+Tg2uEwczxSGMw3p9Pnd8qQEJb9Nl5cFo1W9nk1zPIsPrY0lxRbdscV/H
        o94xvOjQbigrAJafjXEAOevm59oPhBJ9xJKVv+jc+4egWyLeB1Z4WWbdRz6S32QAdUY+
        9/7cvc+rY78BNm5DPw6dcEiGggUL9GTE8JOUeT5y0+XDFwbF1oEGVCkmDI8XBsdynJQz
        iB5YjhUEbwmASWdPZJsPYI1jxfHB6VjIbR1+zEHkInemuJiYpXTt7tSOqxDbCR3klMAT
        qDOg==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9ym4dPkYX6am8zHoI"
X-RZG-CLASS-ID: mo00
Received: from tauon.chronox.de
        by smtp.strato.de (RZmta 46.1.7 AUTH)
        with ESMTPSA id I05c44w0TCsnVXQ
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Wed, 29 Jan 2020 13:54:49 +0100 (CET)
From:   Stephan Mueller <smueller@chronox.de>
To:     "Van Leeuwen, Pascal" <pvanleeuwen@rambus.com>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        David Miller <davem@davemloft.net>,
        Ofir Drang <Ofir.Drang@arm.com>
Subject: Re: Possible issue with new inauthentic AEAD in extended crypto tests
Date:   Wed, 29 Jan 2020 13:54:44 +0100
Message-ID: <5036173.rU9AjI9tPH@tauon.chronox.de>
In-Reply-To: <CY4PR0401MB365296BC605383E0C0506C04C3050@CY4PR0401MB3652.namprd04.prod.outlook.com>
References: <CAOtvUMcwLtwgigFE2mx7LVjhhEgcZsSS4WyR_SQ2gixTZxyBfg@mail.gmail.com> <11489dad16d64075939db69181b5ecbb@MN2PR20MB2973.namprd20.prod.outlook.com> <CY4PR0401MB365296BC605383E0C0506C04C3050@CY4PR0401MB3652.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Mittwoch, 29. Januar 2020, 09:40:28 CET schrieb Van Leeuwen, Pascal:

Hi Pascal,

> Hi Stephan,
> 
> 
> > -----Original Message-----
> > From: linux-crypto-owner@vger.kernel.org
> > <linux-crypto-owner@vger.kernel.org> On Behalf Of Stephan Mueller
 Sent:
> > Wednesday, January 29, 2020 2:27 AM
> > To: Van Leeuwen, Pascal <pvanleeuwen@rambus.com>
> > Cc: Eric Biggers <ebiggers@kernel.org>; Gilad Ben-Yossef
> > <gilad@benyossef.com>; Herbert Xu <herbert@gondor.apana.org.au>;
 Linux
> > Crypto Mailing List <linux-crypto@vger.kernel.org>; Geert Uytterhoeven
> > <geert@linux-m68k.org>; David Miller <davem@davemloft.net>; Ofir Drang
> > <Ofir.Drang@arm.com>
> > Subject: Re: Possible issue with new inauthentic AEAD in extended crypto
> > tests
>
> >
> >
> > <<< External Email >>>
> > CAUTION: This email originated from outside of the organization. Do not
> > click links or open attachments unless you recognize the
 sender/sender
> > address and know the content is safe.
> >
> >
> >
> >
> > Am Mittwoch, 29. Januar 2020, 01:18:29 CET schrieb Van Leeuwen, Pascal:
> >
> >
> >
> > Hi Pascal,
> >
> >
> >
> > > > -----Original Message-----
> > > > From: linux-crypto-owner@vger.kernel.org
> > > > <linux-crypto-owner@vger.kernel.org> On Behalf Of Eric Biggers
> >  
> >  Sent:
> >  
> > > > Tuesday, January 28, 2020 10:13 PM
> > > > To: Gilad Ben-Yossef <gilad@benyossef.com>
> > > > Cc: Herbert Xu <herbert@gondor.apana.org.au>; Stephan Mueller
> > > > <smueller@chronox.de>; Linux Crypto Mailing List <linux-
> > > > crypto@vger.kernel.org>; Geert Uytterhoeven <geert@linux-m68k.org>;
> > > > David
> > > > Miller <davem@davemloft.net>; Ofir Drang <Ofir.Drang@arm.com>
> > > > Subject: Re: Possible issue with new inauthentic AEAD in extended
> > > > crypto
> > > > tests
> > >
> > >
> > >
> > > >
> > > >
> > > >
> > > > <<< External Email >>>
> > > > CAUTION: This email originated from outside of the organization. Do
> > > > not
> > > > click links or open attachments unless you recognize the
> >  
> >  sender/sender
> >  
> > > > address and know the content is safe.
> > > >
> > > >
> > > >
> > > >
> > > >
> > > >
> > > > On Tue, Jan 28, 2020 at 09:24:25AM +0200, Gilad Ben-Yossef wrote:
> > > >
> > > >
> > > >
> > > > > - The source is presumed to have enough room for both the
> > > > > associated
> > > > > data and the plaintext.
> > > > > - Unless it's in-place encryption, in which case, you also presume
> > > > > to
> > > > > have room for the authentication tag
> > > >
> > > >
> > > >
> > > >
> > > >
> > > > The authentication tag is part of the ciphertext, not the plaintext. 
> > > > So
> > > > the
> >  
> >  rule is just that the ciphertext buffer needs to have room for it,
> >  
> > > > not the plaintext.
> > > >
> > > >
> > > >
> > > >
> > > >
> > > > Of course, when doing in-place encryption/decryption, the two buffers
> > > > are
> > > > the
> >  
> >  same, so both will have room for it, even though the tag is only
> >  
> > > > meaningful on the ciphertext side.  That's just the logical
> > > > consequence
> > > > of "in-place".>
> > > >
> > > >
> > > >
> > > >
> > > > > - The only way to tell if this is in-place encryption or not is to
> > > > > compare the pointers to the source and destination - there is no
> > > > > flag.
> > > >
> > > >
> > > >
> > > >
> > > >
> > > > Requiring users to remember to provide a flag to indicate in-place
> > > > encryption/decryption, in addition to passing the same scatterlist,
> > > > would
> > > > make
> >  
> >  the API more complex.
> >  
> > > >
> > > >
> > >
> > >
> > >
> > > Also, what would the benefit? You'd still have to compare the flag. The
> > > performance
> >  
> >  difference of comparing the flag vs comparing 2 pointers (that
> >  
> > > you need to read anyway) is likely completely negligible on most modern
> > > CPU
 architectures ...
> > >
> > >
> > >
> > > > > - You can count on the scattergather list not having  a first NULL
> > > > > buffer, *unless* the plaintext and associated data length are both
> > > > > zero AND it's not in place encryption.
> > > > > - You can count on not getting NULL as a scatterlist point,
> > > > > *unless*
> > > > > the plaintext and associated data length are both zero AND it's not
> > > > > in
> > > > > place encryption. (I'm actually unsure of this one?)
> > > >
> > > >
> > > >
> > > >
> > > >
> > > > If we consider that the input is not just a scatterlist, but rather a
> > > > scatterlist and a length, then these observations are really just
> > > > "you
> > > > can
> > > > access the first byte, unless the length is 0" -- which is sort of
> > > > obvious.  And requiring a dereferencable pointer for length = 0 is
> > > > generally considered to be bad API design; see the memcpy() fiasco
> > > > (https://www.imperialviolet.org/2016/06/26/nonnull.html).
> > > >
> > > >
> > > >
> > > >
> > > >
> > > > The API could be simplified by only supporting full scatterlists, but
> > > > it
> > > > seems that users are currently relying on being able to
> > > > encrypt/decrypt
> > > > just a prefix.>
> > > >
> > > >
> > > >
> > > >
> > > > IMO, the biggest problems with the AEAD API are actually things you
> > > > didn't
> > > > mention, such as the fact that the AAD isn't given in a separate
> > > > scatterlist,
> > >
> > >
> > >
> > > >
> > >
> > >
> > >
> > > While I can understand this may be beneficial in some cases, I believe
> > > they
 do not
> > > outweigh the downsides:
> > > - In many use cases, AAD+cipher text are stored as one contiguous
> > > string.
> >
> >
> >
> > Then refer to that one linear buffer with one SGL entry.
> >
> >
> 
> Hmm ... I believe having a seperate scatter list for AAD would imply that
> you have
 seperate scatter entries for AAD (in that list) and Crypto[+TAG]
> (in the other list).

Who says that we need a separate SGL entry for the AAD?

> So you still have the burden of constructing 2
> scatterlists instead of one, figuring out where the second one starts.


I do not see the requirement that the caller must have at least two SGL 
entries.

In fact, for the AF_ALG interface, af_alg_get_rsgl creates the destination SGL 
and creates one SGL entry per user-space IOVEC. If user space provides a 
linear buffer with one IOVEC holding the AAD, CT, Tag, only one SGL entry is 
created.

For the source SGL, af_alg_sendmsg tries to be efficient to put as much as 
possible into one page referenced by one SGL entry. So, if user space provides 
AAD||PT which is less than a page in size, you get one SGL entry for the 
entire input data.

> Plus
> the burden of any hardware accelerator having to handle 2 particles instead
> of one.

Well, the cipher implementation must be capable of processing any SGL 
structure. It is not given that the SGL with the source data has exactly 2 
entries. It can have one entry with AAD||PT. It can have two entries where the 
split is between AAD and PT. But it can have 2 entries where the split is in 
the middle of, say, AAD. Or it can have more SGL entries.

Please do not mix up the structure of the data to be contained in the SGL 
(say, AAD||PT) with the physical memory structure (e.g. how many SGL entries 
there are).

> 
> Note that even with one scatterlist you can still have the AAD data coming
> from
 some specific AAD-only buffer(s). Just put it it its own (set of)
> particle(s), seperate from the crypto data particles. So that is not a
> reason to have seperate *lists*. 
> The only advantage of having AAD seperate I can think of is for software
> crypto implementations, not having to skip over the AAD for the scatterlist
> they
 send to the parallel encryption part. Which IMHO is only a minor
> inconvenience that you shouldn't push to all the users of the API.
> 
> 
> > > Requiring this
> > > string to be spit into seperate particles for AAD and
> > > ciphertext would be a burden.
> >
> >
> >
> > There is no need to split a string. All that is said is that the SGL needs
> > to
 point to memory that is AAD||PT or AAD||CT||TAG. There is no
> > statement about the number of SGL entries to point to these buffer(s). So
> > you could have one linear buffer for these components pointing to it with
> > an SGL holding one entry.
> >
> >
> 
> The remark I responded to was about having a seperate scatterlist for AAD
> data.
 Which, in my world, implies that the *other* scatterlist does NOT
> include the AAD data. So that one would then need to be only PT or CT||TAG.
> Which does require "splitting the string" (virtually, anyway) between AAD
> and PT/CT. 
> It's not about splitting the data physically (i.e. moving it). It's about
> splitting the
 particles, creating 2 particles (in 2 lists) where you would
> now only need 1. 
> 
> > > - For hardware accelerators, there is a cost
> > > associated with each additional particle, in terms of either bandwidth
> > > or
> > > performance or both. So less particles = better, generally.
> > > The only thing that I find odd is that if you do a non-inplace operation
> > > you
 have this
> > > undefined(?) gap in the output data where the AAD would be for
> > > inplace. That makes little sense to me and requires extra effort to
> > > skip
> > > over in the driver.
> > >
> > >
> > >
> > > > and that the API only supports scatterlists and not virtual addresses
> > > > (which makes it difficult to use in some cases).
> > > >
> > > >
> > > >
> > >
> > >
> > >
> > > While I can understand that this is difficult if the API user just got
> > > this
 virtual address
> >  
> >  provided from somewhere else and needs to do the
> >  
> > > translation, the other side of the medal is that any hardware driver
> > > would
> > > otherwise have to do address translation and scatterlist building on
> > > the
> > > fly (as hardware needs to access contiguous physical memory), which
> > > would
> > > be real burden there. While many API users_are_ able to provide a nice
> > > scatterlist at negligible extra cost. So why burden those?
> > >
> > >
> > >
> > >
> > > > In any case we do need much better documentation.  I'm planning to
> > > > improve
> > > > some
> >  
> >  of the crypto API documentation, but I'll probably do the hash and
> >  
> > > > skcipher algorithm types first before getting to AEAD.  So if you want
> > > > to
> > > > improve the AEAD documentation in the mean time, please go ahead.
> > > >
> > > >
> > > >
> > > >
> > > >
> > > > - Eric
> > >
> > >
> > >
> > >
> > > Regards,
> > > Pascal van Leeuwen
> > > Silicon IP Architect Multi-Protocol Engines, Rambus Security
> > > Rambus ROTW Holding BV
> > > +31-73 6581953
> > >
> > >
> > >
> > > Note: The Inside Secure/Verimatrix Silicon IP team was recently acquired
> > > by
 Rambus.
> >  
> >  Please be so kind to update your e-mail address book with my new
> >  
> > > e-mail address.
> > >
> > >
> > >
> > > ** This message and any attachments are for the sole use of the
> > > intended
> > > recipient(s). It may contain information that is confidential and
> > > privileged. If you are not the intended recipient of this message, you
> > > are
> > > prohibited from printing, copying, forwarding or saving it. Please
> > > delete
> > > the message and attachments and notify the sender immediately. **
> >
> >
> >
> > > Rambus Inc.<http://www.rambus.com>
> >
> >
> >
> >
> >
> > Ciao
> > Stephan
> 
> 
> Regards,
> Pascal van Leeuwen
> Silicon IP Architect Multi-Protocol Engines, Rambus Security
> Rambus ROTW Holding BV
> +31-73 6581953
> 
> Note: The Inside Secure/Verimatrix Silicon IP team was recently acquired by
> Rambus.
 Please be so kind to update your e-mail address book with my new
> e-mail address. 
> 
> ** This message and any attachments are for the sole use of the intended
> recipient(s). It may contain information that is confidential and
> privileged. If you are not the intended recipient of this message, you are
> prohibited from printing, copying, forwarding or saving it. Please delete
> the message and attachments and notify the sender immediately. **
 
> Rambus Inc.<http://www.rambus.com>



Ciao
Stephan


