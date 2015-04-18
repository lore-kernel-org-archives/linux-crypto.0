From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH 3/4] crypto: drbg - replace spinlock with mutex
Date: Sat, 18 Apr 2015 13:35:40 +0200
Message-ID: <1809889.qql3aDFiri@myon.chronox.de>
References: <1551177.C0RmlOO9iU@myon.chronox.de> <2415536.7nqArbGB13@myon.chronox.de> <20150418105523.GB5408@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34181 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752078AbbDRLft (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sat, 18 Apr 2015 07:35:49 -0400
In-Reply-To: <20150418105523.GB5408@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Samstag, 18. April 2015, 18:55:23 schrieb Herbert Xu:

Hi Herbert,

> 
> Incidentally the whole reset concept seems redundant as you could
> always free and allocate a new RNG instead.  So I'm planning on
> replacing it with a seed/reseed function instead.  IOW it will
> keep the existing state and just add in new data if it's already
> seeded.

Very good.

When you do that, may I ask you to also update the crypto_alloc_rng. This 
function has one major drawback at the moment: we are wasting precious 
entropy. The testmgr must allocate the RNG for performing its testing using 
crypto_alloc_rng. As the RNG implementation has no knowledge at allocation 
time that it will be used for testing, it will seed itself for the real work. 
Then comes testing: the seeded RNG is now reset with the test "entropy" and 
thereby wasting the initial seed.

IMHO such change in the allocation function must happen when you remove the 
reset function, because the reset function currently is the way to perform 
testing of the RNGs.

-- 
Ciao
Stephan
