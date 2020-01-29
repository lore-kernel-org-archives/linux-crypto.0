Return-Path: <SRS0=eQ+U=3S=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=3.0 tests=DATE_IN_PAST_03_06,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDC24C33CB2
	for <linux-crypto@archiver.kernel.org>; Wed, 29 Jan 2020 04:34:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B084E207FD
	for <linux-crypto@archiver.kernel.org>; Wed, 29 Jan 2020 04:34:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b="aKTYHo9w"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726487AbgA2Eeu (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 28 Jan 2020 23:34:50 -0500
Received: from mo4-p01-ob.smtp.rzone.de ([81.169.146.166]:21683 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726401AbgA2Eeu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Jan 2020 23:34:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1580272484;
        s=strato-dkim-0002; d=chronox.de;
        h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=2VPayVNGITV4ygmG0shnR19vCwSF4Xq607xo+3bjFQk=;
        b=aKTYHo9wDQ+xH8G+9JcnI2sCK9TawpH1rbE/uUppmsWNoiJ/o9BWzIEUoo+XSVFUlD
        oSGfm3W0sBg+Ff1pEUY0NX/Lj2vhser/jytK8p8RpeFwLDL69WsB2rVEGa/nUJ5lQweC
        AVgHdjE1za9DQwNKWdUoALWnjlVFnQBX3Y5K+NdJmJy0R/Ai6LbS3lG10wFpaQfrAjW4
        rqxwL2CWLRtLfe4ddIcIRpGZO9lCy9Os13egdjeN8M8uGSy9pgLwcN7PKuBLBrNmTEDD
        ou8LQzER/qZr/4zkz6PPZW95rFEG4N4eq3E71cIpXm/Fl5I/EkI2zFV22ul/ncJyL2nh
        wniw==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9ym4dPkYX6am8zHoI"
X-RZG-CLASS-ID: mo00
Received: from tauon.chronox.de
        by smtp.strato.de (RZmta 46.1.7 AUTH)
        with ESMTPSA id I05c44w0T4YXSCa
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Wed, 29 Jan 2020 05:34:33 +0100 (CET)
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
Date:   Wed, 29 Jan 2020 02:26:47 +0100
Message-ID: <5573296.77rzmo0hQ5@tauon.chronox.de>
In-Reply-To: <CY4PR0401MB3652A030115942389B57A8E3C3050@CY4PR0401MB3652.namprd04.prod.outlook.com>
References: <CAOtvUMcwLtwgigFE2mx7LVjhhEgcZsSS4WyR_SQ2gixTZxyBfg@mail.gmail.com> <b5a529fd1abd46ea881b18c387fcd4dc@MN2PR20MB2973.namprd20.prod.outlook.com> <CY4PR0401MB3652A030115942389B57A8E3C3050@CY4PR0401MB3652.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Mittwoch, 29. Januar 2020, 01:18:29 CET schrieb Van Leeuwen, Pascal:

Hi Pascal,

> > -----Original Message-----
> > From: linux-crypto-owner@vger.kernel.org
> > <linux-crypto-owner@vger.kernel.org> On Behalf Of Eric Biggers
 Sent:
> > Tuesday, January 28, 2020 10:13 PM
> > To: Gilad Ben-Yossef <gilad@benyossef.com>
> > Cc: Herbert Xu <herbert@gondor.apana.org.au>; Stephan Mueller
> > <smueller@chronox.de>; Linux Crypto Mailing List <linux-
> > crypto@vger.kernel.org>; Geert Uytterhoeven <geert@linux-m68k.org>; David
> > Miller <davem@davemloft.net>; Ofir Drang <Ofir.Drang@arm.com>
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
> > On Tue, Jan 28, 2020 at 09:24:25AM +0200, Gilad Ben-Yossef wrote:
> > 
> > > - The source is presumed to have enough room for both the associated
> > > data and the plaintext.
> > > - Unless it's in-place encryption, in which case, you also presume to
> > > have room for the authentication tag
> >
> >
> >
> > The authentication tag is part of the ciphertext, not the plaintext.  So
> > the
 rule is just that the ciphertext buffer needs to have room for it,
> > not the plaintext.
> >
> >
> >
> > Of course, when doing in-place encryption/decryption, the two buffers are
> > the
 same, so both will have room for it, even though the tag is only
> > meaningful on the ciphertext side.  That's just the logical consequence
> > of "in-place".>
> >
> >
> > > - The only way to tell if this is in-place encryption or not is to
> > > compare the pointers to the source and destination - there is no flag.
> >
> >
> >
> > Requiring users to remember to provide a flag to indicate in-place
> > encryption/decryption, in addition to passing the same scatterlist, would
> > make
 the API more complex.
> >
> >
> 
> Also, what would the benefit? You'd still have to compare the flag. The
> performance
 difference of comparing the flag vs comparing 2 pointers (that
> you need to read anyway) is likely completely negligible on most modern CPU
> architectures ... 
> 
> > > - You can count on the scattergather list not having  a first NULL
> > > buffer, *unless* the plaintext and associated data length are both
> > > zero AND it's not in place encryption.
> > > - You can count on not getting NULL as a scatterlist point, *unless*
> > > the plaintext and associated data length are both zero AND it's not in
> > > place encryption. (I'm actually unsure of this one?)
> >
> >
> >
> > If we consider that the input is not just a scatterlist, but rather a
> > scatterlist and a length, then these observations are really just "you
> > can
> > access the first byte, unless the length is 0" -- which is sort of
> > obvious.  And requiring a dereferencable pointer for length = 0 is
> > generally considered to be bad API design; see the memcpy() fiasco
> > (https://www.imperialviolet.org/2016/06/26/nonnull.html).
> >
> >
> >
> > The API could be simplified by only supporting full scatterlists, but it
> > seems that users are currently relying on being able to encrypt/decrypt
> > just a prefix.>
> >
> >
> > IMO, the biggest problems with the AEAD API are actually things you
> > didn't
> > mention, such as the fact that the AAD isn't given in a separate
> > scatterlist,
>
> >
> 
> While I can understand this may be beneficial in some cases, I believe they
> do not
> outweigh the downsides:
> - In many use cases, AAD+cipher text are stored as one contiguous string.

Then refer to that one linear buffer with one SGL entry.

> Requiring this
> string to be spit into seperate particles for AAD and
> ciphertext would be a burden.

There is no need to split a string. All that is said is that the SGL needs to 
point to memory that is AAD||PT or AAD||CT||TAG. There is no statement about 
the number of SGL entries to point to these buffer(s). So you could have one 
linear buffer for these components pointing to it with an SGL holding one 
entry.

> - For hardware accelerators, there is a cost
> associated with each additional particle, in terms of either bandwidth or
> performance or both. So less particles = better, generally. 
> The only thing that I find odd is that if you do a non-inplace operation you
> have this
> undefined(?) gap in the output data where the AAD would be for
> inplace. That makes little sense to me and requires extra effort to skip
> over in the driver. 
> 
> > and that the API only supports scatterlists and not virtual addresses
> > (which makes it difficult to use in some cases).
> >
> >
> 
> While I can understand that this is difficult if the API user just got this
> virtual address
 provided from somewhere else and needs to do the
> translation, the other side of the medal is that any hardware driver would
> otherwise have to do address translation and scatterlist building on the
> fly (as hardware needs to access contiguous physical memory), which would
> be real burden there. While many API users_are_ able to provide a nice
> scatterlist at negligible extra cost. So why burden those?
> 
> 
> > In any case we do need much better documentation.  I'm planning to improve
> > some
 of the crypto API documentation, but I'll probably do the hash and
> > skcipher algorithm types first before getting to AEAD.  So if you want to
> > improve the AEAD documentation in the mean time, please go ahead.
> >
> >
> >
> > - Eric
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


