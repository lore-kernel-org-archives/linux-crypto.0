From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC] [PATCH 2/5] aead: Add generic aead wrapper interface
Date: Wed, 3 Jun 2009 21:59:31 +1000
Message-ID: <20090603115931.GA13361@gondor.apana.org.au>
References: <20090513130618.GD20366@secunet.com> <20090513130818.GF20366@secunet.com> <20090602035041.GB22831@gondor.apana.org.au> <20090602092151.GJ20366@secunet.com> <20090602092815.GA26832@gondor.apana.org.au> <20090603093216.GK20366@secunet.com> <20090603094049.GA11356@gondor.apana.org.au> <20090603112353.GL20366@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Miller <davem@davemloft.net>, linux-crypto@vger.kernel.org
To: Steffen Klassert <steffen.klassert@secunet.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:42332 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753382AbZFCL7f (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 3 Jun 2009 07:59:35 -0400
Content-Disposition: inline
In-Reply-To: <20090603112353.GL20366@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jun 03, 2009 at 01:23:53PM +0200, Steffen Klassert wrote:
> On Wed, Jun 03, 2009 at 07:40:50PM +1000, Herbert Xu wrote:
> > 
> > I see.  How about if we let tcrypt test algorithms by name, e.g.,
> > something like
> > 
> > 	modprobe tcrypt alg='pcrypt(authenc(hmac(sha1),cbc(aes))'
> > 
> 
> I'm not that sure whether this does what I want.
> 
> If pcrypt has cra_name = pcrypt(authenc(hmac(sha1),cbc(aes))) this
> would instatiate this algorithm, but esp wants an algorithm with
> cra_name = authenc(hmac(sha1),cbc(aes)). 
> These names are not matching, so __crypto_alg_lookup() will not
> choose for the pcrypt version regardless of the higher priority.

When pcrypt instantiates an algorithm, it should set cra_name to
%s and cra_driver_name to pcrypt(%s).  So as long as the pcrypt
priority is higher than the underlying algorithm, it should all
work.

See for instance how cryptd does it.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
