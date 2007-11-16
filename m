From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: IV copy strategy
Date: Fri, 16 Nov 2007 14:42:24 +0300
Message-ID: <20071116114224.GC6441@2ka.mipt.ru>
References: <20071113231132.GA10680@Chamillionaire.breakpoint.cc> <20071114142253.GA15201@gondor.apana.org.au> <20071115211005.GA21159@Chamillionaire.breakpoint.cc> <20071116020851.GC32509@gondor.apana.org.au> <20071116111110.GB31765@2ka.mipt.ru> <20071116112530.GA9399@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from relay.2ka.mipt.ru ([194.85.82.65]:47029 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756046AbXKPLnR (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 16 Nov 2007 06:43:17 -0500
Content-Disposition: inline
In-Reply-To: <20071116112530.GA9399@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Nov 16, 2007 at 07:25:30PM +0800, Herbert Xu (herbert@gondor.apana.org.au) wrote:
> On Fri, Nov 16, 2007 at 02:11:10PM +0300, Evgeniy Polyakov wrote:
> >
> > That's a question - should it copy IV back or not?
> > Currently it is not required by crypto users.
> 
> Well currently we have exactly one crypto user of ablkcipher
> in the tree, and that's tcrypt :)

In acrypto days it was ipsec and dmcrypt too :)
I thought you converted dmcrypt to use ablkcipher already.

> However, looking at the sync crypto users it would seem that
> chaining while not popular is used by at least RXKAD.  So I'd
> like to preserve this functionality.  Although in light of the
> fact that on DMA devices touching the encrypted result to copy
> the IV may be expensive, we could make it conditional on a flag
> inside the request, i.e., something like
> 
> 	CRYPTO_TFM_REQ_COPY_IV

Well, it is doable to copy iv back after data has been processed just
before callback is invoked when this flag is set for tfm.

> But the point is that this is something that has to be done by
> the algorithm since only it knows in general what/where the IV
> is.  So if the algorithm doesn't do that then the user can't
> easily work around this.
> 
> Actually on second thought why don't we change the interface
> for ablkcipher so that we allow the IV to be returned by either
> copying it to req->info or replacing the req->info pointer?

Better copy I think, since otherwise it has to allocate (in interrupt
context) and free iv for each packet. Even if it will be preallocated
during packet setup (in setiv() for example) it is unneded additional
overhead.

> That way if the destination is linear and lowmem at the end we
> can just return a pointer to it without touching the data at all.
> 
> Cheers,
> -- 
> Visit Openswan at http://www.openswan.org/
> Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

-- 
	Evgeniy Polyakov
