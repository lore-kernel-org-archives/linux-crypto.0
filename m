From: Stephan Mueller <smueller@chronox.de>
Subject: Re: DRBG seeding
Date: Fri, 17 Apr 2015 14:48:51 +0200
Message-ID: <2956307.5uMbChcz7z@myon.chronox.de>
References: <20150416143617.GA17178@gondor.apana.org.au> <3303782.1Fl4anZ2PL@myon.chronox.de> <20150417021430.GA22835@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Andreas Steffen <andreas.steffen@strongswan.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34150 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751148AbbDQMs6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 17 Apr 2015 08:48:58 -0400
In-Reply-To: <20150417021430.GA22835@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Freitag, 17. April 2015, 10:14:30 schrieb Herbert Xu:

Hi Herbert,

> On Fri, Apr 17, 2015 at 03:19:17AM +0200, Stephan Mueller wrote:
> > 1. during initialization of a DRBG instance, seed from get_random_bytes to
> > have a DRBG state that is seeded and usable.
> 
> I think we either need to use real entropy and block, or mark
> the DRBG unusable until such a time that it has been seeded
> with real entropy.

Do you really think that this is possible? If the DRBG becomes the stdrng, you 
would imply that those callers (e.g. IPSEC) may suffer from a long block (and 
with long I mean not just seconds, but minutes).

Furthermore, I fail to see the difference between the current default stdrng 
(krng -- which is just get_random_bytes in disguise). Thus, the current 
situation with the DRBG seeding is not different from the non-DRBG use case.

Therefore, I still think we:

- need to satisfy users with an immediate need for random numbers immediately 
after instantiating the DRBG

- need to obtain "/dev/random"-like entropy as we can get hold of it.

Just as a side note, about 2 years ago, I offered a solution that also 
provides instant entropy at the time you need it -- see [1]. Unfortunately, it 
was rejected based on grounds I cannot fully comprehend

[1] https://lkml.org/lkml/2013/10/11/582
-- 
Ciao
Stephan
