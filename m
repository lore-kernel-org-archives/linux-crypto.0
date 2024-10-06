Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F8B9191;
	Sun,  6 Oct 2024 00:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728176024; cv=none; b=OqKMQeQR1yF7KpS9urgfG3z+J37J4PC5/s16fhSVHuMRRJCoZNb/I+8mh1i0vN+H1294h7rC4YFA7C8QhBiYl1ops4hmVhUzQlsJE3aeeSFa92mebu1dAGB15o5/DxwXK14Tadx4HWiQFc9VYN/fWYj3cVbAt+csHMzf/rGnB5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728176024; c=relaxed/simple;
	bh=0lAY6hjfI1iHplLN8mg+B00aoRseXfHIdGSZ8nvDqsw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ps8zqC/io+KrdvE9+vvFNs3GkvHNy/YS0fyAoo/7wE9T8oeilf1HnPYtIaf4Yf5BiFR8mug2BI4HP4jv89MLiNPEzGvGZHSrk2kB4wuwJBJv56xR5gId2btC3dTWsczy+oem7T1pILVEBYQarC7zL4G4gnpZPelzrHvf/Em224A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=sGrCGQON; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="sGrCGQON"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=MgLp7O8qyabqY2WttHA2j+5INq2cuCIdKsU/gi4xZFI=; b=sGrCGQONWndTtHjekWdzInysfx
	nbSuTE1odM9K/bnARndZx4rnCXVKYQCDFKtbyC2I2OU88YdA2/U1YKrX9CYp7LRfPQtp3O3P0UaPV
	ZULTipmpDPFKwSLUKgSceALhxgtmfpmmPHu4VQ4zYa3hAfS0ZsRy1yYuzhWvCuQKBGJP7LC4yphx1
	CJWU7nvDjw+L3J26LHE3901GMe4y6JYmUUuj8OifSJjYPdkJgKBlxFNjUtdpruohYCCXTSCFK+I9v
	5KWoU4lAdE1izivb50TvTr1bpnIRwXsB7nr3KUnjrPOb2h3WCnQTKAmz22n66iS9RaF2GbTP4pBrf
	vTDgQNcg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sxFMg-007AZ7-1D;
	Sun, 06 Oct 2024 08:53:29 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 06 Oct 2024 08:53:28 +0800
Date: Sun, 6 Oct 2024 08:53:28 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: kernel test robot <oliver.sang@intel.com>, oe-lkp@lists.linux.dev,
	lkp@intel.com, linux-crypto@vger.kernel.org, ltp@lists.linux.it,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"Russell King (Oracle)" <linux@armlinux.org.uk>,
	Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	"David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] crypto: api - Fix generic algorithm self-test races
Message-ID: <ZwHfiNsP7fUvDwbH@gondor.apana.org.au>
References: <ZsBJs_C6GdO_qgV7@gondor.apana.org.au>
 <ZsBJ5H4JExArHGVw@gondor.apana.org.au>
 <ZsBKG0la0m69Dyq3@gondor.apana.org.au>
 <20240827184839.GD2049@sol.localdomain>
 <Zs6SiBOdasO9Thd1@gondor.apana.org.au>
 <20240830175154.GA48019@sol.localdomain>
 <ZtQgVOnK6WzdIDlU@gondor.apana.org.au>
 <20240902170554.GA77251@sol.localdomain>
 <ZtZFOgh3WylktM1E@gondor.apana.org.au>
 <20241005222448.GB10813@sol.localdomain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241005222448.GB10813@sol.localdomain>

On Sat, Oct 05, 2024 at 03:24:48PM -0700, Eric Biggers wrote:
>
> The tests are still failing on upstream:
> 
> [    0.343845] alg: self-tests for rfc4106(gcm(aes)) using rfc4106(gcm_base(ctr(aes-generic),ghash-generic)) failed (rc=-2)

You're right.  I only disabled the warnings at the point of
allocation, the overall self-test warning is still there.  Let
me get rid of them too.

> Besides the test failures, it looks like there's no longer any guarantee that
> algorithms are actually available now that their module is loaded.

That would indeed be a bug.  But I haven't seen it in practice.
Although the s390 folks were reporting some weird errors with
dm-crypt, they have recently disappeared.

If you do see an actual failure please report it and then I'll
consider reverting it until it's fixed.

> E.g. consider if someone does 'modprobe aesni-intel' and then immediately
> creates a dm-crypt device.  Now it sounds like the AES-NI algorithms might not
> have finished being tested yet and the generic algorithms can be used instead,
> resulting in a performance regression.

That is not the case.  After modprobe returns, the algorithm is
guaranteed to have been registered.  Yes it is untested, but that
should not be a problem because a test larval will have been created
and all users looking for that algorithm will be waiting on that
test larval.

> I understand that you want to try to fix the edge cases in "fallback" ciphers.
> But "fallback" ciphers have always seemed like a bad design due to how they use
> the crypto API recursively.  I think the algorithms that use them should
> generally be migrated off of them, e.g. as I did in commit f235bc11cc95
> ("crypto: arm/aes-neonbs - go back to using aes-arm directly").  That fixed the
> problem in aes-neonbs that seems to have triggered this work in the first place.

Yes getting rid of fallbacks is nice, but this it not the reason why
we're making self-test asynchronous.  The primary issue with synchronous
self-tests is the modprobe dead-lock.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
