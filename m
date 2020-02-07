Return-Path: <SRS0=xktg=33=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD0A1C04EB5
	for <linux-crypto@archiver.kernel.org>; Fri,  7 Feb 2020 14:29:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E46EF20838
	for <linux-crypto@archiver.kernel.org>; Fri,  7 Feb 2020 14:29:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b="kvjHAFvv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727367AbgBGO3a (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 7 Feb 2020 09:29:30 -0500
Received: from mo4-p01-ob.smtp.rzone.de ([81.169.146.164]:32117 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727692AbgBGO33 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 7 Feb 2020 09:29:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1581085764;
        s=strato-dkim-0002; d=chronox.de;
        h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=sI8mQh2xsR/tmB1qUx5CgDfFCAYQroaTAzAvePeFLVs=;
        b=kvjHAFvv4zyjE9OX8ez9hwvkOlWpY4OdhNeY9tesZg4PA60P/RxOkvCZV0cEwgMnFl
        mrdSfVZ1lNyTNuKk433kk5TVq2WcC1lF0DWLFbxbAWFI2e+tLAZKzDO6bbbS9xmK7THY
        anB9RM1OPYkBYjotOEdptqUpqLYNbRgE1Wr7FO6gPX8qurpCerrbDPvfAJTZwtS+aJMh
        O9VD66H2aQO3DYvL7I4KvHVh2fYD1pK/+JXVaBoy0D8eiUnveFD8biXkZlMYWwq1S4jy
        kG5yWa7J3ZxDoKw54bYICbFE0btIoXtJyTLRpx0eJ3mPvWU5ParBknb1R88/PqkdeFt5
        8sZw==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPaIfScugJ3"
X-RZG-CLASS-ID: mo00
Received: from tauon.chronox.de
        by smtp.strato.de (RZmta 46.1.12 DYNA|AUTH)
        with ESMTPSA id 608a92w17ETFf62
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Fri, 7 Feb 2020 15:29:15 +0100 (CET)
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
Date:   Fri, 07 Feb 2020 15:29:14 +0100
Message-ID: <3122095.o01qsJJ3EY@tauon.chronox.de>
In-Reply-To: <SN4PR0401MB366399E54E5B7EE0E54A7E0BC31C0@SN4PR0401MB3663.namprd04.prod.outlook.com>
References: <CAOtvUMcwLtwgigFE2mx7LVjhhEgcZsSS4WyR_SQ2gixTZxyBfg@mail.gmail.com> <70156395ce424f41949feb13fd9f978b@MN2PR20MB2973.namprd20.prod.outlook.com> <SN4PR0401MB366399E54E5B7EE0E54A7E0BC31C0@SN4PR0401MB3663.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Freitag, 7. Februar 2020, 15:07:49 CET schrieb Van Leeuwen, Pascal:

Hi Pascal,

> Hi Stephan,
> 
> 
> > -----Original Message-----
> > From: linux-crypto-owner@vger.kernel.org
> > <linux-crypto-owner@vger.kernel.org> On Behalf Of Stephan Mueller
 Sent:
> > Friday, February 7, 2020 8:56 AM
> > To: Eric Biggers <ebiggers@kernel.org>
> > Cc: Gilad Ben-Yossef <gilad@benyossef.com>; Herbert Xu
> > <herbert@gondor.apana.org.au>; Linux Crypto Mailing List <linux-
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
> > Am Freitag, 7. Februar 2020, 08:27:09 CET schrieb Eric Biggers:
> >
> >
> >
> > Hi Eric,
> >
> >
> >
> > > On Wed, Feb 05, 2020 at 04:48:16PM +0200, Gilad Ben-Yossef wrote:
> > > 
> > > > Probably another issue with my driver, but just in case -
> > > >
> > > >
> > > >
> > > > include/crypot/aead.h says:
> > > > 
> > > >  * The scatter list pointing to the input data must contain:
> > > >  *
> > > >  * * for RFC4106 ciphers, the concatenation of
> > > >  *   associated authentication data || IV || plaintext or ciphertext.
> > > >  Note, the *   same IV (buffer) is also set with the
> > > >  aead_request_set_crypt call. Note, *   the API call of
> > > >  aead_request_set_ad must provide the length of the AAD and *   the
> > > >  IV.
> > > >  The API call of aead_request_set_crypt only points to the size of *
> > > >  the input plaintext or ciphertext.
> > > >
> > > >
> > > >
> > > > I seem to be missing the place where this is handled in
> > > > generate_random_aead_testvec()
> > > > and generate_aead_message()
> > > >
> > > >
> > > >
> > > > We seem to be generating a random IV for providing as the parameter
> > > > to
> > > > aead_request_set_crypt()
> > > > but than have other random bytes set in aead_request_set_ad() - or am
> > > > I'm missing something again?
> > >
> > >
> > >
> > > Yes, for rfc4106 the tests don't pass the same IV in both places.  This
> > > is
> > > because I wrote the tests from the perspective of a generic AEAD that
> > > doesn't have this weird IV quirk, and then I added the minimum quirks
> > > to
> > > get the weird algorithms like rfc4106 passing.
> > >
> > >
> > >
> > > Since the actual behavior of the generic implementation of rfc4106 is
> > > that
> > > the last 8 bytes of the AAD are ignored, that means that currently the
> > > tests just avoid mutating these bytes when generating inauthentic input
> > > tests.  They don't know that they're (apparently) meant to be another
> > > copy
> > > of the IV.
> > >
> > >
> > >
> > > So it seems we need to clearly define the behavior when the two IV
> > > copies
> > > don't match.  Should one or the other be used, should an error be
> > > returned,
 or should the behavior be unspecified (in which case the
> > > tests would need to be updated)?
> > >
> > >
> > >
> > > Unspecified behavior is bad, but it would be easiest for software to
> > > use
> > > req->iv, while hardware might want to use the IV in the scatterlist...
> > >
> > >
> > >
> > > Herbert and Stephan, any idea what was intended here?
> > >
> > >
> > >
> > > - Eric
> >
> >
> >
> > The full structure of RFC4106 is the following:
> >
> >
> >
> > - the key to be set is always 4 bytes larger than required for the
> > respective
 AES operation (i.e. the key is 20, 28 or 36 bytes
> > respectively). The key value contains the following information: key ||
> > first 4 bytes of the IV (note, the first 4 bytes of the IV are the bytes
> > derived from the KDF invoked by IKE - i.e. they come from user space and
> > are fixed)
> >
> >
> >
> > - data block contains AAD || trailing 8 bytes of IV || plaintext or
> > ciphertext
 - the trailing 8 bytes of the IV are the SPI which is updated
> > for each new IPSec package
> >
> >
> 
> By SPI you must mean sequence number?
> (The SPI is actually the SA index which certainly doesn't change per
> packet!)
> That would be one possible way of generating the explicit IV, but
> you certainly cannot count on that. Anything unique under the key would be
> fine for GCM. 

The IV actually is generated with an IV generator (I think it is the SEQIV 
generator from crypto/seqiv.c - it is set in the XFRM framework). It is a 
deterministic construction XORed with a random number from the SP800-90A DRBG.

> 
> > aead_request_set_ad points to the AAD plus the 8 bytes of IV in the use
> > case
 of rfc4106(gcm(aes)) as part of IPSec.
> >
> >
> >
> > Considering your question about the aead_request_set_ad vs
> > aead_request_set_crypt I think the RFC4106 gives the answer: the IV is
> > used in
 two locations considering that the IV is also the SPI in our
> > case. If you see RFC 4106 chapter 3 you see the trailing 8 bytes of the
> > IV as, well, the GCM IV (which is extended by the 4 byte salt as defined
> > in chapter 4 that we provide with the trailing 4 bytes of the key). The
> > kernel uses the SPI for this.>
> >
> 
> Again, by  SPI you must mean sequence number. The SPI itself is entirely
> seperate.

See above, it is actually not the SPI, or sequence number, it is what the IV 
generator provides.

> So the IV is not "used in two places", it is only used as IV for
> the AEAD operation, with the explicit part (8 bytes) inserted into the
> packet.
> [For GCM the IV, despite being in the AAD buffer,  is _not_ authenticated]
> The sequence number _may_ be used in two places (AAD and explicit part of
> the IV),
> but that is not a given and out of the scope of the crypto API. I
> would not make any assumptions there.
> 
> The "problem" Gilad was referring to is that the _explicit_ part of the  IV
> appears to be
> available  from both req->iv and from the AAD scatterbuffer.
> Which one should you use? API wise I would assume req->iv but from a (our)
> hardware perspective, it would be more efficient to extract it from the
> datastream. But is it allowed to assume there is a valid IV stored there?
> (which implies that it has to match req->iv, otherwise behaviour would
> deviate from implementations using that) 

req->iv is your IV.

The use of the IV as part of the AAD is just a use case for rfc4106. Although 
I doubt that the rfc4106 structure will change any time soon, I would not use 
the IV from the AAD but only look at the req->iv.

> 
> > In chapter 5 RFC4106 you see that the SP is however used as part of the
> > AAD as
 well.
> >
> >
> >
> > Bottom line: if you do not set the same IV value for both, the AAD and the
> > GCM
 IV, you deviate from the use case of rfc4106(gcm(aes)) in IPSec.
> > Yet, from a pure mathematical point of view and also from a cipher
> > implementation point of view, it does not matter whether the AAD and the
> > IV point to the same value - the implementation must always process that
> > data. The result however will not be identical to the IPSec use case.
> >
> >
> 
> For the IPsec use case, it's perfectly legal to have IV != sequence number
> as long
> as it is unique under the key.

Right, it is a perfectly legal way of doing it, but it is currently not done 
that way in the kernel. Thus, I would reiterate my suggestion from above to 
always use req->iv as your IV.

> So you should not assume the sequence number part of the AAD buffer to
> match
> the IV part (or req->iv), but it _would_ make sense if the IV part
> of the AAD matches req->iv. (then again, if this is not _required_ by the
> API the application might not bother providing it, which is my reason not
> to use in in the inside_secure driver) 

Precisely.

Ciao
Stephan


