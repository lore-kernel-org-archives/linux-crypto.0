Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F55D41C71
	for <linux-crypto@vger.kernel.org>; Thu, 15 May 2025 19:03:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747335834; cv=none; b=ksSK8lJCBgtzdKop9vEjnulCuv5QPTdLcYrxTDltZ+igdXwZ0A1w6FO+zsh3huUufmMoeDSRbBzGMZUS2Ipaq5Vu2gt7drUF6O4+xtOrCjm/Pl3NJMTRvurZXUYOseUsCTjM8UCpP1MHUh/a0apFtEpvNZPFh7CV1XyE4cWIrjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747335834; c=relaxed/simple;
	bh=VRagaSXsAIeqVRRt2t467sjr8Yeh2sZcXNEljQZBvMw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qG790LFm1sOpOD2PRmwDA1nNjLQplzDT/QF2t2BThuOvLAu1/ZXT7RaZSCQ1wSFrLL6nGDjpekg7le1mde6O31R2ZMn3vTHz9igL/bm0VIB4OM35adCmqAh5KPJezBjvc7aGML30OT4XtQKliHUlUQtlwmPcl6wWHCRwe7PIFiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OHcQZoZo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OHcQZoZo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4796DC4CEED;
	Thu, 15 May 2025 19:03:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747335832;
	bh=VRagaSXsAIeqVRRt2t467sjr8Yeh2sZcXNEljQZBvMw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OHcQZoZoih1+JodqxsZE/ed3QeB7hprD3wT8BXY6az9msb/0XaXtL3/tJ7gny1yxY
	 lpa10rv5j0h/05KyFtj8S7wr/jDVelySWK3ncdEizHTxSiRKzdxFIdFpxOGjOn09r8
	 Kcah5X7qsHgrqXhiMJXXANEbR03jWO0C/HRxNiwtSvl1faUOSwDDCoUmbNOgdW4sxJ
	 N894zZvMFCIJMk+JrEVpGJIv45FmbEYV7I/RU5Kn+54t7mPpOTn+N7ck9SBC0Apso0
	 3HHe3IaaL6v9d/UM1ghjKFH1DKYZxhUIinhBUXqnCLEc0VVedWJmJ7bMPLBWRu7pIB
	 PVAyX0iIN2Tsw==
Date: Thu, 15 May 2025 12:03:50 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Ard Biesheuvel <ardb+git@google.com>
Cc: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	herbert@gondor.apana.org.au, Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH] crypto: arm64 - Drop asm fallback macros for older
 binutils
Message-ID: <20250515190350.GF1411@quark>
References: <20250515142702.2592942-2-ardb+git@google.com>
 <20250515185254.GE1411@quark>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250515185254.GE1411@quark>

On Thu, May 15, 2025 at 11:52:54AM -0700, Eric Biggers wrote:
> On Thu, May 15, 2025 at 04:27:03PM +0200, Ard Biesheuvel wrote:
> > diff --git a/arch/arm64/crypto/sha512-ce-core.S b/arch/arm64/crypto/sha512-ce-core.S
> > index 91ef68b15fcc..deb2469ab631 100644
> > --- a/arch/arm64/crypto/sha512-ce-core.S
> > +++ b/arch/arm64/crypto/sha512-ce-core.S
> > @@ -12,26 +12,7 @@
> >  #include <linux/linkage.h>
> >  #include <asm/assembler.h>
> >  
> > -	.irp		b,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19
> > -	.set		.Lq\b, \b
> > -	.set		.Lv\b\().2d, \b
> > -	.endr
> > -
> > -	.macro		sha512h, rd, rn, rm
> > -	.inst		0xce608000 | .L\rd | (.L\rn << 5) | (.L\rm << 16)
> > -	.endm
> > -
> > -	.macro		sha512h2, rd, rn, rm
> > -	.inst		0xce608400 | .L\rd | (.L\rn << 5) | (.L\rm << 16)
> > -	.endm
> > -
> > -	.macro		sha512su0, rd, rn
> > -	.inst		0xcec08000 | .L\rd | (.L\rn << 5)
> > -	.endm
> > -
> > -	.macro		sha512su1, rd, rn, rm
> > -	.inst		0xce608800 | .L\rd | (.L\rn << 5) | (.L\rm << 16)
> > -	.endm
> > +	.arch	armv8-a+sha3
> 
> This looked like a mistake: SHA-512 is part of SHA-2, not SHA-3.  However, the
> current versions of binutils and clang do indeed put it under sha3.  There
> should be a comment that mentions this unfortunate quirk.
> 
> However, there's also the following commit which went into binutils 2.43:
> 
>     commit 0aac62aa3256719c37be9e0ce6af8b190f45c928
>     Author: Andrew Carlotti <andrew.carlotti@arm.com>
>     Date:   Fri Jan 19 13:01:40 2024 +0000
> 
>         aarch64: move SHA512 instructions to +sha3
> 
>         SHA512 instructions were added to the architecture at the same time as SHA3
>         instructions, but later than the SHA1 and SHA256 instructions.  Furthermore,
>         implementations must support either both or neither of the SHA512 and SHA3
>         instruction sets.  However, SHA512 instructions were originally (and
>         incorrectly) added to Binutils under the +sha2 flag.
> 
>         This patch moves SHA512 instructions under the +sha3 flag, which matches the
>         architecture constraints and existing GCC and LLVM behaviour.
> 
> So probably we need ".arch armv8-a+sha2+sha3" to support binutils 2.30 through
> 2.42, as well as clang and the latest version of binutils?  (I didn't test it
> yet, but it seems likely...)

I see there's also a similar quirk where "sm4" enables the SM3 instructions.
The use of that in sm3-ce-core.S could use a comment as well...

Fortunately at least in that case it looks like the instructions were always
under "sm4" in both binutils and clang.

- Eric
