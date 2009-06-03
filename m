From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC] [PATCH 2/5] aead: Add generic aead wrapper interface
Date: Wed, 3 Jun 2009 19:40:50 +1000
Message-ID: <20090603094049.GA11356@gondor.apana.org.au>
References: <20090513130618.GD20366@secunet.com> <20090513130818.GF20366@secunet.com> <20090602035041.GB22831@gondor.apana.org.au> <20090602092151.GJ20366@secunet.com> <20090602092815.GA26832@gondor.apana.org.au> <20090603093216.GK20366@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Miller <davem@davemloft.net>, linux-crypto@vger.kernel.org
To: Steffen Klassert <steffen.klassert@secunet.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:37469 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756889AbZFCJkw (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 3 Jun 2009 05:40:52 -0400
Content-Disposition: inline
In-Reply-To: <20090603093216.GK20366@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jun 03, 2009 at 11:32:16AM +0200, Steffen Klassert wrote:
>
> > So what I suggest is that you make pcrypt take a higher priority
> > for now, so that it always is the default once instantiated.
> > After all if you instantiate it then you probably want to use it
> > as the default.
> 
> Yes, in fact the instantiating is my problem. E.g. esp asks for an
> authenc(...,...) algorithm, so the crypto manager tries to instantiate
> a template with name authenc. If I don't want to touch the network
> subsystem I can't change the name to pcrypt(authenc(...,...)) easy.
> So one solution was to add a default wrapper template arround authenc
> that will be instantiated along with authenc.

I see.  How about if we let tcrypt test algorithms by name, e.g.,
something like

	modprobe tcrypt alg='pcrypt(authenc(hmac(sha1),cbc(aes))'

which would simply call crypto_has_alg on the string alg?

That should instantiate alg, and test it too if there are vectors.

This is a new interface too, but at least it pretends to be
generic :)

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
