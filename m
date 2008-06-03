From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] crypto: rmd128: make it work on my prefered architecture
Date: Tue, 3 Jun 2008 10:00:20 +1000
Message-ID: <20080603000020.GA31787@gondor.apana.org.au>
References: <20080517.020122.229980431.davem@davemloft.net> <20080517091451.GE19540@Chamillionaire.breakpoint.cc> <20080517095625.GA17878@gondor.apana.org.au> <20080520.194723.268247612.davem@davemloft.net> <20080526110508.GB14743@gondor.apana.org.au> <20080602201739.GA19706@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Miller <davem@davemloft.net>, linux-crypto@vger.kernel.org,
	rueegsegger@swiss-it.ch
To: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:55042 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753560AbYFCAA0 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 2 Jun 2008 20:00:26 -0400
Content-Disposition: inline
In-Reply-To: <20080602201739.GA19706@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Sebastian:

On Mon, Jun 02, 2008 at 10:17:39PM +0200, Sebastian Siewior wrote:
> 
> This is mpc8544 with gcc-4.1.1. The other powerpc machine I have
> available and could run a test is a ps3. Unfortunately I have to
> suspend this for two weeks.
> Arnd told me, that the powerpc folks were discussing an index field in
> their in/out macros. I check that once I'm back again.

Thanks for the results! There is no doubt that this results in
worse numbers on your platform.  However, on the balance of it
I would say that the pointer version is a plus when all factors
are considered.  As such I'm going to stick with it.

I agree with you that optimising those macros on powerpc would
be a good course of action.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
