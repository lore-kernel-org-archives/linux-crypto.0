From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: DRBG seeding
Date: Sat, 18 Apr 2015 09:27:44 +0800
Message-ID: <20150418012744.GA1329@gondor.apana.org.au>
References: <20150416143617.GA17178@gondor.apana.org.au>
 <2956307.5uMbChcz7z@myon.chronox.de>
 <20150417131137.GA27060@gondor.apana.org.au>
 <2278042.JS7c5BLrbA@myon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Steffen <andreas.steffen@strongswan.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:59689 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751757AbbDRB1x (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 17 Apr 2015 21:27:53 -0400
Content-Disposition: inline
In-Reply-To: <2278042.JS7c5BLrbA@myon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Apr 17, 2015 at 03:22:56PM +0200, Stephan Mueller wrote:
>
> > The only reason someone would use this is to comply with the
> > standard and this is what the standard requires so I don't see
> > how we can do anything else.
> 
> I do not see a definite quality requirement of the seed source in SP800-90A. 

Section 8.6.5 "Source of Entropy Input" explicitly requires this.

TBH whether /dev/random even satisfies 8.6.5 is also debatable.
But it agrees with the specification at least in spirit.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
