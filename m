From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v5 3/4] crypto: kdf - SP800-108 Key Derivation Function
Date: Tue, 16 Aug 2016 11:11:47 +0200
Message-ID: <11427544.kWdLX5BMAt@tauon.atsec.com>
References: <2808589.gm6f519sFh@positron.chronox.de> <1734150.tKo42fLWeE@positron.chronox.de> <20160816085745.GA26547@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: mathew.j.martineau@linux.intel.com, dhowells@redhat.com,
	linux-crypto@vger.kernel.org, keyrings@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:36438 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750928AbcHPJLv (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 16 Aug 2016 05:11:51 -0400
In-Reply-To: <20160816085745.GA26547@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Dienstag, 16. August 2016, 16:57:45 CEST schrieb Herbert Xu:

Hi Herbert,

> On Tue, Aug 09, 2016 at 02:28:37PM +0200, Stephan Mueller wrote:
> > The SP800-108 compliant Key Derivation Function is implemented as a
> > random number generator considering that it behaves like a deterministic
> > RNG.
> > 
> > All three KDF types specified in SP800-108 are implemented.
> > 
> > The code comments provide details about how to invoke the different KDF
> > types.
> > 
> > Signed-off-by: Stephan Mueller <smueller@chronox.de>
> 
> So I have no problems with this functionality existing in the kernel,
> assuming that the keys patch using it is accepted.
> 
> However, I'm still at a loss as to why this has to be done as
> an RNG.  IOW what benefit does implementing this as an RNG give
> us compared to just using the underlying hash directly from the
> keys subsystem?
> 
> In general the crypto API caters to algorithms that carry more
> than one implementation, especially if one of them is hardware-
> dependent.  I really can't see how KDF would fit this criterion.

The KDF is logically equivalent to a block chaining mode. As the KDF can be 
applied to arbitrary hash types (keyed and non-keyed), I thought of how to 
integrate it with the existing framework. None of the template mechanisms seem 
to fit what the KDF does.

Conceptually, a KDF is a random number generator by generating arbitrarily 
sized strings from a fixed "seed". This lead me to add the RNG template 
handling. Even the existing DRBG is more or less a "block chaining mode" that 
is very similar to a KDF. Hence, the current plethora of 22 registered DRBGs 
could be elegantly eliminated if the DRBG is turned into template using the 
proposed RNG framework.

If you think that a KDF should not be a generic mechanism, then the KDF logic 
would need to move directly into the keys subsystem. But since TLS is 
something folks speak about, a TLS KDF would need to be considered eventually 
too which is yet again some form of RNG.

Ciao
Stephan
