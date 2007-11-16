From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: IV copy strategy
Date: Fri, 16 Nov 2007 21:47:56 +0800
Message-ID: <20071116134756.GA10472@gondor.apana.org.au>
References: <20071113231132.GA10680@Chamillionaire.breakpoint.cc> <20071114142253.GA15201@gondor.apana.org.au> <20071115211005.GA21159@Chamillionaire.breakpoint.cc> <20071116020851.GC32509@gondor.apana.org.au> <20071116111110.GB31765@2ka.mipt.ru> <20071116112530.GA9399@gondor.apana.org.au> <20071116114224.GC6441@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:3476 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757580AbXKPNr7 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 16 Nov 2007 08:47:59 -0500
Content-Disposition: inline
In-Reply-To: <20071116114224.GC6441@2ka.mipt.ru>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Nov 16, 2007 at 02:42:24PM +0300, Evgeniy Polyakov wrote:
>
> > Actually on second thought why don't we change the interface
> > for ablkcipher so that we allow the IV to be returned by either
> > copying it to req->info or replacing the req->info pointer?
> 
> Better copy I think, since otherwise it has to allocate (in interrupt
> context) and free iv for each packet. Even if it will be preallocated
> during packet setup (in setiv() for example) it is unneded additional
> overhead.

I think you misunderstood me.  I'm suggesting that for CBC
algorithms where the final IV is simply the last block of the
dst buffer, if the last block is in lowmem and contiguous, that
we simply put a pointer to it in place of the original IV.

There is no allocation involved.

If you can't (i.e., not CBC or if the last block isn't contiguous
or is highmem) then you just revert to copying.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
