From: Stephan Mueller <smueller@chronox.de>
Subject: Re: DRBG seeding
Date: Sat, 18 Apr 2015 04:04:14 +0200
Message-ID: <1590899.I1kIJmAce0@myon.chronox.de>
References: <20150416143617.GA17178@gondor.apana.org.au> <3151046.CNv2ChE2Gl@myon.chronox.de> <20150418013618.GC1329@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Andreas Steffen <andreas.steffen@strongswan.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34179 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751927AbbDRCFc (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 17 Apr 2015 22:05:32 -0400
In-Reply-To: <20150418013618.GC1329@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Samstag, 18. April 2015, 09:36:18 schrieb Herbert Xu:

Hi Herbert,

> On Sat, Apr 18, 2015 at 03:32:03AM +0200, Stephan Mueller wrote:
> > In any case, I am almost ready with the patch for an async seeding.
> > Though, I want to give it a thorough testing.
> 
> I don't see the point of async seeding, unless you're also making
> all generate calls block until the seeding is complete.

My plan is seeding first with /dev/urandom followed by the async /dev/random 
call. I.e. during the instantiation of the DRBG, the get_random_bytes is 
pulled for the initial seed. At the same time the async trigger to get data 
from /dev/random is made. Once that async call returns, the DRBG is re-seeded 
with that data.

Any immediate call to any in-kernel /dev/random and block really can cause the 
DRBG to stall. If the DRBG is the stdrng, we invite serious regressions if we 
block during initialization, especially in headless systems.

Furthermore, the DRBG is implemented to pull the nonce also from the seed 
source. As outlined in section 8.6.3 of SP800-90A, the nonce is used as a 
cushion if the entropy string does not have sufficient entropy.

However, the only serious solution I can offer to not block is to use my 
Jitter RNG which delivers entropy in (almost all) use cases. See [1]. The code 
is relatively small and does not have any dependencies. In this case, we could 
perform the initialization of the DRBG as follows:

1. pull buffer of size entropy + nonce from get_random_bytes

2. pull another buffer of size entropy + nonce from my Jitter RNG

3. XOR both

4. seed the DRBG with it

5. trigger the async invocation of the in-kernel /dev/random

6. return the DRBG instance to the caller without waiting for the completion 
of step 5

This way, we will get entropy during the first initialization without 
blocking. After speaking with mathematicians at NIST, that Jitter RNG approach 
would be accepted. Note, I personally think that the Jitter RNG has sufficient 
entropy in almost all circumstances (see the massive testing I conducted on 
all more widely used CPUs).

[1] http://www.chronox.de/jent.html

-- 
Ciao
Stephan
