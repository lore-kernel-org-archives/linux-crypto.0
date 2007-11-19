From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: IV copy strategy
Date: Mon, 19 Nov 2007 13:38:41 +0300
Message-ID: <20071119103840.GC2048@2ka.mipt.ru>
References: <20071113231132.GA10680@Chamillionaire.breakpoint.cc> <20071114142253.GA15201@gondor.apana.org.au> <20071115211005.GA21159@Chamillionaire.breakpoint.cc> <20071116020851.GC32509@gondor.apana.org.au> <20071116111110.GB31765@2ka.mipt.ru> <20071118065237.GA26456@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from relay.2ka.mipt.ru ([194.85.82.65]:50046 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750971AbXKSKjd (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 19 Nov 2007 05:39:33 -0500
Content-Disposition: inline
In-Reply-To: <20071118065237.GA26456@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sun, Nov 18, 2007 at 02:52:37PM +0800, Herbert Xu (herbert@gondor.apana.org.au) wrote:
> On Fri, Nov 16, 2007 at 02:11:10PM +0300, Evgeniy Polyakov wrote:
> >
> > That's a question - should it copy IV back or not?
> > Currently it is not required by crypto users.
> 
> OK I've changed my mind :)
> 
> The reason is CTR, or rather the CTR as used by IPsec.  CTR
> itself should be able to chain, in fact one of the things I'll
> do later is to move most of the current CTR code into a chainable
> CTR with just the algorithm parameter, i.e., ctr(aes) which would
> be what we currently call ctr(0,16,16).  We can then put a non-
> chainable wrapper around that, perhaps ctr-ipsec(aes).
> 
> In any case, it is clear that some algorithms simply won't be
> able to chain because the IV exposed to the outside is not the
> complete IV.
> 
> So my plan is to add a new flag, CRYPTO_ALG_CIPHER_NOCHAIN that
> you would set on algorithms that cannot be chained.  The semantics
> is that everything else remains the same except that on encrypt
> calls, the req->info after completion is undefined.
> 
> Users requiring chaining would then do
> 
> 	crypto_alloc_blkcipher("foo", 0, CRYPTO_ALG_CIPHER_NOCHAIN)

Hmm, users who want chaining will set flag _NOCHAIN :)
I would call it something more informative...

> For hardware offload devices such as yours where chaining does
> not come naturally you could then elect to not implement chaining
> and just set the flag.
> 
> Please let me know if you see any problems with this approach.

I'm not sure what user will do, when it request chaining, but driver
will set CRYPTO_ALG_CIPHER_NOCHAIN itself and return wrong/old in
req->info?
For IPsec it is not an issue though, but I can not say that for all.

-- 
	Evgeniy Polyakov
