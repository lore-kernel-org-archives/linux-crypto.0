From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: DRBG seeding
Date: Sat, 18 Apr 2015 10:16:24 +0800
Message-ID: <20150418021624.GA2653@gondor.apana.org.au>
References: <20150416143617.GA17178@gondor.apana.org.au>
 <3151046.CNv2ChE2Gl@myon.chronox.de>
 <20150418013618.GC1329@gondor.apana.org.au>
 <1590899.I1kIJmAce0@myon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Steffen <andreas.steffen@strongswan.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1590899.I1kIJmAce0@myon.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sat, Apr 18, 2015 at 04:04:14AM +0200, Stephan Mueller wrote:
> 
> However, the only serious solution I can offer to not block is to use my 
> Jitter RNG which delivers entropy in (almost all) use cases. See [1]. The code 
> is relatively small and does not have any dependencies. In this case, we could 
> perform the initialization of the DRBG as follows:
> 
> 1. pull buffer of size entropy + nonce from get_random_bytes
> 
> 2. pull another buffer of size entropy + nonce from my Jitter RNG
> 
> 3. XOR both

Don't xor them.  Just provide them both as input to the seed
function.

> 4. seed the DRBG with it
> 
> 5. trigger the async invocation of the in-kernel /dev/random
> 
> 6. return the DRBG instance to the caller without waiting for the completion 
> of step 5
> 
> This way, we will get entropy during the first initialization without 
> blocking. After speaking with mathematicians at NIST, that Jitter RNG approach 
> would be accepted. Note, I personally think that the Jitter RNG has sufficient 
> entropy in almost all circumstances (see the massive testing I conducted on 
> all more widely used CPUs).
> 
> [1] http://www.chronox.de/jent.html

OK this sounds like it should satisfy everybody.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
