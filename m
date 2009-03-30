From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [RFC] [PATCH 4/4] esp: add the pcrypt hooks to esp
Date: Mon, 30 Mar 2009 14:22:33 +0200
Message-ID: <20090330122233.GD6791@secunet.com>
References: <20090316114940.GN13998@secunet.com> <20090316115526.GR13998@secunet.com> <20090327084457.GC27903@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Miller <davem@davemloft.net>, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([213.68.205.161]:38565 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753567AbZC3MUm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 30 Mar 2009 08:20:42 -0400
Content-Disposition: inline
In-Reply-To: <20090327084457.GC27903@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Mar 27, 2009 at 04:44:57PM +0800, Herbert Xu wrote:
> On Mon, Mar 16, 2009 at 12:55:26PM +0100, Steffen Klassert wrote:
> >
> > @@ -447,7 +448,7 @@ static int esp_init_aead(struct xfrm_state *x)
> >  	struct crypto_aead *aead;
> >  	int err;
> >  
> > -	aead = crypto_alloc_aead(x->aead->alg_name, 0, 0);
> > +	aead = crypto_alloc_aead_tfm(x->aead->alg_name, 0, 0);
> 
> I'd like this to be configurable.  After all, there's not much
> point in doing this if your crypto is done through PCI.
> 

Indeed, it should be configurable. I was not sure what's the best way to     
make it configurable, so I decided to just make it the default to be
able to use it in this first version.

> The easiest way is to let the user specify pcrypt through the
> algorithm name.  In fact, as long as pcrypt has a higher priority
> than the default software algorithms, the user simply has to
> instantiate it in order for it to be the default for all uses
> of that algorithm.
> 

For IPsec I thought about something like 'pcrypt(authenc(...,...))' to
be able to process each crypto request with just one
parallelization/serialization call. Perhaps I'm missing something, but
actually I don't see how to choose for this from userspace through the
name without adding an entry for each possible combination of hmac and
blkcipher algorithm to the xfrm_aead_list. I'd appreciate any hint here.
My idea to make it configurable was to do it similar to the async
algorithms by

aead = crypto_alloc_aead_tfm(x->aead->alg_name, flags, CRYPTO_ALG_PCRYPT);

if CRYPTO_ALG_PCRYPT is set in flags, the crypto manager tries to choose
a parallel algorithm, if it is not set parallel algorithms will be ignored.
~    
