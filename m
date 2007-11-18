From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: IV copy strategy
Date: Sun, 18 Nov 2007 14:52:37 +0800
Message-ID: <20071118065237.GA26456@gondor.apana.org.au>
References: <20071113231132.GA10680@Chamillionaire.breakpoint.cc> <20071114142253.GA15201@gondor.apana.org.au> <20071115211005.GA21159@Chamillionaire.breakpoint.cc> <20071116020851.GC32509@gondor.apana.org.au> <20071116111110.GB31765@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:1251 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750832AbXKRGwx (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 18 Nov 2007 01:52:53 -0500
Content-Disposition: inline
In-Reply-To: <20071116111110.GB31765@2ka.mipt.ru>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Nov 16, 2007 at 02:11:10PM +0300, Evgeniy Polyakov wrote:
>
> That's a question - should it copy IV back or not?
> Currently it is not required by crypto users.

OK I've changed my mind :)

The reason is CTR, or rather the CTR as used by IPsec.  CTR
itself should be able to chain, in fact one of the things I'll
do later is to move most of the current CTR code into a chainable
CTR with just the algorithm parameter, i.e., ctr(aes) which would
be what we currently call ctr(0,16,16).  We can then put a non-
chainable wrapper around that, perhaps ctr-ipsec(aes).

In any case, it is clear that some algorithms simply won't be
able to chain because the IV exposed to the outside is not the
complete IV.

So my plan is to add a new flag, CRYPTO_ALG_CIPHER_NOCHAIN that
you would set on algorithms that cannot be chained.  The semantics
is that everything else remains the same except that on encrypt
calls, the req->info after completion is undefined.

Users requiring chaining would then do

	crypto_alloc_blkcipher("foo", 0, CRYPTO_ALG_CIPHER_NOCHAIN)

For hardware offload devices such as yours where chaining does
not come naturally you could then elect to not implement chaining
and just set the flag.

Please let me know if you see any problems with this approach.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
