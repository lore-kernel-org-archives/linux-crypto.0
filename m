From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v5 3/4] crypto: kdf - SP800-108 Key Derivation Function
Date: Tue, 16 Aug 2016 11:25:33 +0200
Message-ID: <1605606.kqFagSqufY@tauon.atsec.com>
References: <2808589.gm6f519sFh@positron.chronox.de> <11427544.kWdLX5BMAt@tauon.atsec.com> <20160816091347.GA26733@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: mathew.j.martineau@linux.intel.com, dhowells@redhat.com,
	linux-crypto@vger.kernel.org, keyrings@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:36460 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751123AbcHPJ0W (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 16 Aug 2016 05:26:22 -0400
In-Reply-To: <20160816091347.GA26733@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Dienstag, 16. August 2016, 17:13:47 CEST schrieb Herbert Xu:

Hi Herbert,

> On Tue, Aug 16, 2016 at 11:11:47AM +0200, Stephan Mueller wrote:
> > Conceptually, a KDF is a random number generator by generating arbitrarily
> > sized strings from a fixed "seed". This lead me to add the RNG template
> > handling. Even the existing DRBG is more or less a "block chaining mode"
> > that is very similar to a KDF. Hence, the current plethora of 22
> > registered DRBGs could be elegantly eliminated if the DRBG is turned into
> > template using the proposed RNG framework.
> 
> The point is that there is no alternative implementation for kdf,
> nor is there likely to be one.

I was thinking of the DRBG implementation: decouple it from the underlying 
ciphers. Though, I am not fully sure that will work as there are several 
specific settings that depend on the underlying ciphers (e.g. the state of a 
Hash DRBG with SHA-256 is 444 bits whereas a Hash DRBG with SHA-512 has 888 
bits).
> 
> > If you think that a KDF should not be a generic mechanism, then the KDF
> > logic would need to move directly into the keys subsystem. But since TLS
> > is something folks speak about, a TLS KDF would need to be considered
> > eventually too which is yet again some form of RNG.
> 
> If a TLS KDF comes with a hardware implementation then we could
> include it.  Otherwise the answer would be the same.

It is certainly not an issue to move the KDF logic into the keys subsystem. 
However, as it (may) resemble SP800-56A which is in line with FIPS 140-2, 
folks may ask for a FIPS stamp on it. If a FIPS stamp is asked for, the KDF 
itself must be subject to a self test (like what we have in testmgr.c). If we 
move the KDF to the keys subsystem, the self test would then need to be 
implemented there.

Ciao
Stephan
