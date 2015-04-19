From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH 3/4] crypto: drbg - replace spinlock with mutex
Date: Sun, 19 Apr 2015 17:37:21 +0200
Message-ID: <1695105.vT0DvueDZS@myon.chronox.de>
References: <1551177.C0RmlOO9iU@myon.chronox.de> <1809889.qql3aDFiri@myon.chronox.de> <20150419054803.GA11255@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34213 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751353AbbDSPh0 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 19 Apr 2015 11:37:26 -0400
In-Reply-To: <20150419054803.GA11255@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Sonntag, 19. April 2015, 13:48:03 schrieb Herbert Xu:

Hi Herbert,

> On Sat, Apr 18, 2015 at 01:35:40PM +0200, Stephan Mueller wrote:
> > When you do that, may I ask you to also update the crypto_alloc_rng. This
> > function has one major drawback at the moment: we are wasting precious
> > entropy. The testmgr must allocate the RNG for performing its testing
> > using
> > crypto_alloc_rng. As the RNG implementation has no knowledge at allocation
> > time that it will be used for testing, it will seed itself for the real
> > work. Then comes testing: the seeded RNG is now reset with the test
> > "entropy" and thereby wasting the initial seed.
> 
> Yes the DRBG will be unusable when first allocated and you must
> seed it to actually draw entropy and be able to use it.

I am not sure I understand you correctly: shall the DRBG have these 
precautions? If so, wouldn't we break the requirements in SP800-90A where the 
DRBG is intended to seed itself?

Or would you want to update the crypto_alloc_rng routine?
> 
> Cheers,


-- 
Ciao
Stephan
