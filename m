From: Stephan Mueller <smueller@chronox.de>
Subject: Re: DRBG seeding
Date: Fri, 17 Apr 2015 15:22:56 +0200
Message-ID: <2278042.JS7c5BLrbA@myon.chronox.de>
References: <20150416143617.GA17178@gondor.apana.org.au> <2956307.5uMbChcz7z@myon.chronox.de> <20150417131137.GA27060@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Andreas Steffen <andreas.steffen@strongswan.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34167 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932459AbbDQNYh (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 17 Apr 2015 09:24:37 -0400
In-Reply-To: <20150417131137.GA27060@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Freitag, 17. April 2015, 21:11:37 schrieb Herbert Xu:

Hi Herbert,

> On Fri, Apr 17, 2015 at 02:48:51PM +0200, Stephan Mueller wrote:
> > Do you really think that this is possible? If the DRBG becomes the stdrng,
> > you would imply that those callers (e.g. IPSEC) may suffer from a long
> > block (and with long I mean not just seconds, but minutes).
> 
> It's only 49 bytes for every 64K so I think it's reasonable.

Just an FYI on a test I did once: on a headless PPC (POWER6), we drained 
/dev/random (simply do a cat /dev/random). Then it took more than 20 hours(!) 
to get 48 bytes to seed OpenSSL from /dev/random. This test was done on some 
2.6.32 kernel.

That issue should be better now considering that interrupts are used as noise 
source by /dev/random.

Furthermore, it gets worse again considering that there is work underway to 
disable SSDs to feed /dev/random. Thus, on a server that is headless but has 
SSDs we only have interrupts feeding into /dev/random.

Thus, getting a full seed of 384 bits is minutes on a headless system will 
definitely be a challenge in a worst case.

> The only reason someone would use this is to comply with the
> standard and this is what the standard requires so I don't see
> how we can do anything else.

I do not see a definite quality requirement of the seed source in SP800-90A. 
In user space, FIPS validations happily used /dev/urandom where NIST has no 
concern.

Currently, there is a draft interpretation that tightens the issue around 
/dev/urandom significantly. Therefore, looking into the issue is definitely 
important. But still, blocking the DRBG right from the start until we have 
data from /dev/random does not seem helpful either.
> 
> > Furthermore, I fail to see the difference between the current default
> > stdrng (krng -- which is just get_random_bytes in disguise). Thus, the
> > current situation with the DRBG seeding is not different from the
> > non-DRBG use case.
> The difference is that krng doesn't have to satisfy any standard.
> 
> Cheers,


-- 
Ciao
Stephan
