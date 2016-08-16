From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v5 3/4] crypto: kdf - SP800-108 Key Derivation Function
Date: Tue, 16 Aug 2016 17:13:47 +0800
Message-ID: <20160816091347.GA26733@gondor.apana.org.au>
References: <2808589.gm6f519sFh@positron.chronox.de>
 <1734150.tKo42fLWeE@positron.chronox.de>
 <20160816085745.GA26547@gondor.apana.org.au>
 <11427544.kWdLX5BMAt@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: mathew.j.martineau@linux.intel.com, dhowells@redhat.com,
	linux-crypto@vger.kernel.org, keyrings@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:45534 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928AbcHPJOC (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 16 Aug 2016 05:14:02 -0400
Content-Disposition: inline
In-Reply-To: <11427544.kWdLX5BMAt@tauon.atsec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Aug 16, 2016 at 11:11:47AM +0200, Stephan Mueller wrote:
>
> Conceptually, a KDF is a random number generator by generating arbitrarily 
> sized strings from a fixed "seed". This lead me to add the RNG template 
> handling. Even the existing DRBG is more or less a "block chaining mode" that 
> is very similar to a KDF. Hence, the current plethora of 22 registered DRBGs 
> could be elegantly eliminated if the DRBG is turned into template using the 
> proposed RNG framework.

The point is that there is no alternative implementation for kdf,
nor is there likely to be one.

> If you think that a KDF should not be a generic mechanism, then the KDF logic 
> would need to move directly into the keys subsystem. But since TLS is 
> something folks speak about, a TLS KDF would need to be considered eventually 
> too which is yet again some form of RNG.

If a TLS KDF comes with a hardware implementation then we could
include it.  Otherwise the answer would be the same.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
