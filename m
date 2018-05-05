From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 01/10] crypto: aead - allow to allocate AEAD requests on
 the stack
Date: Sat, 5 May 2018 14:18:55 +0800
Message-ID: <20180505061855.trmz34gsjfyi5xop@gondor.apana.org.au>
References: <20180502095725.31935-1-antoine.tenart@bootlin.com>
 <20180502095725.31935-2-antoine.tenart@bootlin.com>
 <02ad9eb93c494314a85db69886cf787a@AcuMS.aculab.com>
 <20180503122330.GB3324@kwain>
 <20180503230006.oq6vycplwsomfprw@gondor.apana.org.au>
 <20180504071841.GG3324@kwain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Laight <David.Laight@aculab.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        "maxime.chevallier@bootlin.com" <maxime.chevallier@bootlin.com>,
        "gregory.clement@bootlin.com" <gregory.clement@bootlin.com>,
        "miquel.raynal@bootlin.com" <miquel.raynal@bootlin.com>,
        "nadavh@marvell.com" <nadavh@marvell.com>,
        "oferh@marvell.com" <oferh@marvell.com>,
        "igall@marvell.com" <igall@marvell.com>
To: 'Antoine Tenart' <antoine.tenart@bootlin.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180504071841.GG3324@kwain>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, May 04, 2018 at 09:18:41AM +0200, 'Antoine Tenart' wrote:
>
> In this driver we need to perform in certain cases an invalidation,
> which is done thanks to invalidation requests. To do this we create
> dummy requests, using SKCIPHER_REQUEST_ON_STACK and
> AHASH_REQUEST_ON_STACK for ciphers and hashes. So when adding the AEAD
> algs support, in patch 8/10, AEAD_REQUEST_ON_STACK is used for the same
> reason.
> 
> Should we allocate this in a different way?

These are not uses intended for the ON_STACK macros.  They were
only ever meant for existing users of the synchonous crypto API.

I would suggest either allocating a new request on the spot or if
that is not convenient, pre-allocating it in the cra_init function.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
