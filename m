From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 3/4] crypto: drbg - replace spinlock with mutex
Date: Sun, 19 Apr 2015 13:48:03 +0800
Message-ID: <20150419054803.GA11255@gondor.apana.org.au>
References: <1551177.C0RmlOO9iU@myon.chronox.de>
 <2415536.7nqArbGB13@myon.chronox.de>
 <20150418105523.GB5408@gondor.apana.org.au>
 <1809889.qql3aDFiri@myon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:35934 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300AbbDSFsI (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 19 Apr 2015 01:48:08 -0400
Content-Disposition: inline
In-Reply-To: <1809889.qql3aDFiri@myon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Apr 18, 2015 at 01:35:40PM +0200, Stephan Mueller wrote:
>
> When you do that, may I ask you to also update the crypto_alloc_rng. This 
> function has one major drawback at the moment: we are wasting precious 
> entropy. The testmgr must allocate the RNG for performing its testing using 
> crypto_alloc_rng. As the RNG implementation has no knowledge at allocation 
> time that it will be used for testing, it will seed itself for the real work. 
> Then comes testing: the seeded RNG is now reset with the test "entropy" and 
> thereby wasting the initial seed.

Yes the DRBG will be unusable when first allocated and you must
seed it to actually draw entropy and be able to use it.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
