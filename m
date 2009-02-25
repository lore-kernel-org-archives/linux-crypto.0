From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: compress - Add pcomp interface
Date: Wed, 25 Feb 2009 10:56:05 +0800
Message-ID: <20090225025605.GA30920@gondor.apana.org.au>
References: <20090114031613.GA7429@gondor.apana.org.au> <Pine.LNX.4.64.0901141528010.31703@vixen.sonytel.be> <20090115030526.GA27726@gondor.apana.org.au> <alpine.LRH.2.00.0902051703150.4290@vixen.sonytel.be> <20090210061822.GA19774@gondor.apana.org.au> <alpine.LRH.2.00.0902121613580.29413@vixen.sonytel.be> <20090219040847.GA973@gondor.apana.org.au> <alpine.LRH.2.00.0902191005110.27630@vixen.sonytel.be> <20090219104250.GA9633@gondor.apana.org.au> <alpine.LRH.2.00.0902231822080.22762@vixen.sonytel.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:54789 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753011AbZBYC4L (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 24 Feb 2009 21:56:11 -0500
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.0902231822080.22762@vixen.sonytel.be>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Feb 23, 2009 at 06:32:19PM +0100, Geert Uytterhoeven wrote:
>
> Is the below (on top of my last patch series) what you have in mind?

Looks great to me!

> Notes:
>   - I had to drop the `const' from the `params' pointers of
>     pcomp_alg.{,de}compress_setup().
>     Trying to make nla_parse() take const nlattr structures instead seems to
>     open a big can of worms...

I don't think that's a big deal.

>   - I should add a dependency of CONFIG_CRYPTO_ZLIB on CONFIG_NET (due to the
>     need for nla_parse()). However, I don't like that.

Dave has OKed it for the attribute stuff to be moved into lib.
So if you want to tackle that then be my guest :) Otherwise I'll
look into moving it.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
