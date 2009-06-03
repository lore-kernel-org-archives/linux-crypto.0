From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [RFC] [PATCH 2/5] aead: Add generic aead wrapper interface
Date: Wed, 3 Jun 2009 13:23:53 +0200
Message-ID: <20090603112353.GL20366@secunet.com>
References: <20090513130618.GD20366@secunet.com> <20090513130818.GF20366@secunet.com> <20090602035041.GB22831@gondor.apana.org.au> <20090602092151.GJ20366@secunet.com> <20090602092815.GA26832@gondor.apana.org.au> <20090603093216.GK20366@secunet.com> <20090603094049.GA11356@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Miller <davem@davemloft.net>, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([213.68.205.161]:52800 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753332AbZFCLV3 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 3 Jun 2009 07:21:29 -0400
Content-Disposition: inline
In-Reply-To: <20090603094049.GA11356@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jun 03, 2009 at 07:40:50PM +1000, Herbert Xu wrote:
> 
> I see.  How about if we let tcrypt test algorithms by name, e.g.,
> something like
> 
> 	modprobe tcrypt alg='pcrypt(authenc(hmac(sha1),cbc(aes))'
> 

I'm not that sure whether this does what I want.

If pcrypt has cra_name = pcrypt(authenc(hmac(sha1),cbc(aes))) this
would instatiate this algorithm, but esp wants an algorithm with
cra_name = authenc(hmac(sha1),cbc(aes)). 
These names are not matching, so __crypto_alg_lookup() will not
choose for the pcrypt version regardless of the higher priority.

Setting cra_name = authenc(hmac(sha1),cbc(aes)) for pcrypt seems to
be not possible too, because pcrypt needs authenc as an underlain 
algorithm and the system will not load two aead algorithms with the
same name. This was one of the reasons why I added a wrapper to
authenc that is instantiated along with authenc.

Is this the case or do I miss something?

