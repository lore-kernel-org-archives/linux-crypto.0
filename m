From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: IV copy strategy
Date: Fri, 16 Nov 2007 19:25:30 +0800
Message-ID: <20071116112530.GA9399@gondor.apana.org.au>
References: <20071113231132.GA10680@Chamillionaire.breakpoint.cc> <20071114142253.GA15201@gondor.apana.org.au> <20071115211005.GA21159@Chamillionaire.breakpoint.cc> <20071116020851.GC32509@gondor.apana.org.au> <20071116111110.GB31765@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:2256 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756217AbXKPLZd (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 16 Nov 2007 06:25:33 -0500
Content-Disposition: inline
In-Reply-To: <20071116111110.GB31765@2ka.mipt.ru>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Nov 16, 2007 at 02:11:10PM +0300, Evgeniy Polyakov wrote:
>
> That's a question - should it copy IV back or not?
> Currently it is not required by crypto users.

Well currently we have exactly one crypto user of ablkcipher
in the tree, and that's tcrypt :)

However, looking at the sync crypto users it would seem that
chaining while not popular is used by at least RXKAD.  So I'd
like to preserve this functionality.  Although in light of the
fact that on DMA devices touching the encrypted result to copy
the IV may be expensive, we could make it conditional on a flag
inside the request, i.e., something like

	CRYPTO_TFM_REQ_COPY_IV

But the point is that this is something that has to be done by
the algorithm since only it knows in general what/where the IV
is.  So if the algorithm doesn't do that then the user can't
easily work around this.

Actually on second thought why don't we change the interface
for ablkcipher so that we allow the IV to be returned by either
copying it to req->info or replacing the req->info pointer?

That way if the destination is linear and lowmem at the end we
can just return a pointer to it without touching the data at all.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
