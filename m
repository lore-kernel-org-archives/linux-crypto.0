From: Stephan Mueller <smueller@chronox.de>
Subject: Re: DRBG seeding
Date: Sat, 18 Apr 2015 03:32:03 +0200
Message-ID: <3151046.CNv2ChE2Gl@myon.chronox.de>
References: <20150416143617.GA17178@gondor.apana.org.au> <2278042.JS7c5BLrbA@myon.chronox.de> <20150418012744.GA1329@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Andreas Steffen <andreas.steffen@strongswan.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34176 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751494AbbDRBcJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 17 Apr 2015 21:32:09 -0400
In-Reply-To: <20150418012744.GA1329@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Samstag, 18. April 2015, 09:27:44 schrieb Herbert Xu:

Hi Herbert,

> On Fri, Apr 17, 2015 at 03:22:56PM +0200, Stephan Mueller wrote:
> > > The only reason someone would use this is to comply with the
> > > standard and this is what the standard requires so I don't see
> > > how we can do anything else.
> > 
> > I do not see a definite quality requirement of the seed source in
> > SP800-90A.
> Section 8.6.5 "Source of Entropy Input" explicitly requires this.
> 
> TBH whether /dev/random even satisfies 8.6.5 is also debatable.
> But it agrees with the specification at least in spirit.

Ok, if I re-read that one and consider our discussion, I would agree. But it 
was handled differently up to now.

In any case, I am almost ready with the patch for an async seeding. Though, I 
want to give it a thorough testing.

-- 
Ciao
Stephan
