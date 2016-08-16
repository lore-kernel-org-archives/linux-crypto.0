From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v5 3/4] crypto: kdf - SP800-108 Key Derivation Function
Date: Tue, 16 Aug 2016 16:57:45 +0800
Message-ID: <20160816085745.GA26547@gondor.apana.org.au>
References: <2808589.gm6f519sFh@positron.chronox.de>
 <1734150.tKo42fLWeE@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: mathew.j.martineau@linux.intel.com, dhowells@redhat.com,
	linux-crypto@vger.kernel.org, keyrings@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:55044 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753123AbcHPI55 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 16 Aug 2016 04:57:57 -0400
Content-Disposition: inline
In-Reply-To: <1734150.tKo42fLWeE@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Aug 09, 2016 at 02:28:37PM +0200, Stephan Mueller wrote:
> The SP800-108 compliant Key Derivation Function is implemented as a
> random number generator considering that it behaves like a deterministic
> RNG.
> 
> All three KDF types specified in SP800-108 are implemented.
> 
> The code comments provide details about how to invoke the different KDF
> types.
> 
> Signed-off-by: Stephan Mueller <smueller@chronox.de>

So I have no problems with this functionality existing in the kernel,
assuming that the keys patch using it is accepted.

However, I'm still at a loss as to why this has to be done as
an RNG.  IOW what benefit does implementing this as an RNG give
us compared to just using the underlying hash directly from the
keys subsystem?

In general the crypto API caters to algorithms that carry more
than one implementation, especially if one of them is hardware-
dependent.  I really can't see how KDF would fit this criterion.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
