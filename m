From: Kim Phillips <kim.phillips@freescale.com>
Subject: Re: ABLKCIPHER
Date: Mon, 15 Mar 2010 12:00:06 -0500
Message-ID: <20100315120006.de14c3cc.kim.phillips@freescale.com>
References: <20100313123146.GA26376@gondor.apana.org.au>
	<4B9E50F8.9030109@siganos.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
To: Dimitrios Siganos <dimitris@siganos.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from az33egw02.freescale.net ([192.88.158.103]:33352 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965390Ab0COQyK (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 15 Mar 2010 12:54:10 -0400
Received: from de01smr01.freescale.net (de01smr01.freescale.net [10.208.0.31])
	by az33egw02.freescale.net (8.14.3/az33egw02) with ESMTP id o2FGrxFI024488
	for <linux-crypto@vger.kernel.org>; Mon, 15 Mar 2010 09:53:59 -0700 (MST)
Received: from az33exm22.fsl.freescale.net (az33exm22.am.freescale.net [10.64.32.10])
	by de01smr01.freescale.net (8.13.1/8.13.0) with ESMTP id o2FH21bE021655
	for <linux-crypto@vger.kernel.org>; Mon, 15 Mar 2010 12:02:01 -0500 (CDT)
In-Reply-To: <4B9E50F8.9030109@siganos.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, 15 Mar 2010 15:23:36 +0000
Dimitrios Siganos <dimitris@siganos.org> wrote:

> Herbert Xu wrote:
> > Dimitrios Siganos <dimitris@siganos.org> wrote:
> >   
> >> Hi,
> >>
> >> I am trying to write an ABLKCIPHER algorithm for my hardware crypto 
> >> engine and I have a few questions:
> >>
> >> 1) In struct ablkcipher_alg, what do these fields do? I see some 
> >> implementations use them and some not. Do I need to implement them?
> >>    int (*givencrypt)(struct skcipher_givcrypt_request *req);
> >>    int (*givdecrypt)(struct skcipher_givcrypt_request *req);
> >>    const char *geniv;
> >>     
> >
> > These do not have to be implemented, unless your hardware is
> > capable of generating initial IVs (e.g., through a secure RNG).
> >   
> My hardware (Freescale i.MX51) has a random number generator. I think I 

huh, I thought that part's crypto unit would have a lot in common with
the talitos block, but public documentation for Sahara leaves a lot to
be desired...

> am confused about the giv..crypt concept in general. How is it supposed 
> to work?
> 
> Let's say I want to do the classic cbc(aes). The steps are:
> 1) allocate a tfm object
> 2) set the key
> 3) set the iv
> 4) encrypt as many times as needed
> 5) cleanup
> 
> I can do this without the giv functions. Do the giv apply in this case?

I'm going to assume that aead matches ablkcipher in this regard:

If the h/w doesn't support generating IVs, specify a .geniv string so
that software will generate the IV before the driver's .encrypt() is
called.

If the h/w is going to generate the IV, omit the .geniv string,
and implement givencrypt() such that it instructs your h/w to generate
and place a new IV at the req->giv address.

But this is assuming Sahara h/w can generate random numbers that fast.
If it's anything like the talitos parts, it may have an IPsec-specific
descriptor that allows for a pseudo-IV generation specification.

hth,

Kim
