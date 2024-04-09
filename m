Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CE11384
	for <linux-crypto@vger.kernel.org>; Tue,  9 Apr 2024 12:32:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712665963; cv=none; b=aZ1A3Ue3wWfzLvc9xrDyKcfqThPAdYDRgdWNh2LxCI12wV45xWKFOTjtva6BwDveJmH4+tqZng/lf7IJw92mH8GioNIfOrmNtHqI9zjqslWHhtP70UxOWBe2uka+hcIQBoxYc4w4KYDJSGfRVcCtSsf6MZ7nFCjtMnzorrSmF10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712665963; c=relaxed/simple;
	bh=OYzrSH6gOKQ8E0kTM41Cgv1bhn+oYp9uGxA/OBPTEUM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pD37sKdcXNWzSiF+X+6Vd+bAhWnj1V/L2B6fLkHZVJeBwxXc1Q8p0caYt9FwxM/iPVlSaOPUDN2z+yQKhpX7N+I9fK9Ly1l36g/+twyVvKkxhA+pcSO+g1mW55Om9wvvwtV2G9pM8DxUU/CAgGGD+J5kFy555bfps8dYSEHmzSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R5bQfe+p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R5bQfe+p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A433C433F1;
	Tue,  9 Apr 2024 12:32:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712665962;
	bh=OYzrSH6gOKQ8E0kTM41Cgv1bhn+oYp9uGxA/OBPTEUM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=R5bQfe+pOC3+gjmckCtYmUdnASIR//yR7sx8goczbev71ilYIbi4OGSfXe/tmam0z
	 /peFSOTH4e/srzb05Xd21+TwMbIhisY9dX3NVBZ2bU9qWa5BWs6xRK5QnnrflVB71U
	 vI99Q1ED/87N3dzciTcXFAy0N6lQcGMep2x9CFC1ZTZbgxGGUa4SfXPec3I+6gPEg5
	 9GuG2dn3NJN1TuOUkUYM7fU1l213tFBPoZSk6rsyRnQ0SVTEvcr4MOz73c/gKLfbIA
	 FRgJYSBOiBXlVxQQD7oVnCqpXzuOV3beE++38tcEMtQFuNwDmiFRwR8/WNxlV+6BNH
	 N83PV83xt8GIQ==
Date: Tue, 9 Apr 2024 08:32:40 -0400
From: Eric Biggers <ebiggers@kernel.org>
To: Stefan Kanthak <stefan.kanthak@nexgo.de>
Cc: ardb@kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH 1/2] crypto: s(h)aving 40+ bytes off
 arch/x86/crypto/sha256_ni_asm.S
Message-ID: <20240409123240.GB717@quark.localdomain>
References: <5EEE09A9021540A5AAD8BFEEE915512D@H270>
 <20240408123734.GB732@quark.localdomain>
 <9088939CC5454139901CEDD97DAFB004@H270>
 <20240408151832.GE732@quark.localdomain>
 <4D8C090A8BD54C05A97F57A0F640E94F@H270>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D8C090A8BD54C05A97F57A0F640E94F@H270>

On Tue, Apr 09, 2024 at 12:23:13PM +0200, Stefan Kanthak wrote:
> "Eric Biggers" <ebiggers@kernel.org> wrote:
> 
> > [+Cc linux-crypto]
> > 
> > Please use reply-all so that the list gets included.
> > 
> > On Mon, Apr 08, 2024 at 04:15:32PM +0200, Stefan Kanthak wrote:
> >> Hi Eric,
> >> 
> >> > On Mon, Apr 08, 2024 at 11:26:52AM +0200, Stefan Kanthak wrote:
> >> >> Use shorter SSE2 instructions instead of some SSE4.1
> >> >> use short displacements into K256
> >> >> 
> >> >> --- -/arch/x86/crypto/sha256_ni_asm.S
> >> >> +++ +/arch/x86/crypto/sha256_ni_asm.S
> >> > 
> >> > Thanks!  I'd like to benchmark this to see how it affects performance,
> >> 
> >> Performance is NOT affected: if CPUs weren't superscalar, the patch might
> >> save 2 to 4 processor cycles as it replaces palignr/pblendw (slow) with
> >> punpck*qdq (fast and shorter)
> >> 
> >> > but unfortunately this patch doesn't apply.  It looks your email client
> >> > corrupted your patch by replacing tabs with spaces.  Can you please use
> >> > 'git send-email' to send patches?
> >> 
> >> I don't use git at all; I'll use cURL instead.
> 
> [...]
> 
> >> > Please make sure to run the crypto self-tests too.
> >> 
> >> I can't, I don't use Linux at all; I just noticed that this function uses
> >> 4-byte displacements and palignr/pblendw instead of punpck?qdq after pshufd 
> >> 
> >> > The above is storing the two halves of the state in the wrong order.
> >> 
> >> ARGH, you are right; I recognized it too, wanted to correct it, but was
> >> interrupted and forgot it after returning to the patch. Sorry.
> > 
> > I'm afraid that if you don't submit a probably formatted and tested patch, your
> > patch can't be accepted.  We can treat it as a suggestion, though since you're
> > sending actual code it would really help if it had your Signed-off-by.
> 
> Treat is as suggestion.

All right.  I'll send out a properly formatted and tested patch then.  I'd also
like to convert the SHA-256 rounds to use macros, which would make the source
150 lines shorter (without changing the output).  I'll probably do that first.

> I but wonder that in the past 9 years since Tim Chen submitted the SHA-NI code
> (which was copied umpteen times by others and included in their own code bases)
> nobody noticed/questioned (or if so, bothered to submit a patch like mine, that
> reduces the code size by 5%, upstream) why he used 16x "pshufd $14, %xmm0, %xmm0"
> instead of the 1 byte shorter "punpckhqdq %xmm0, %xmm0" or "psrldq $8, %xmm0"
> (which both MAY execute on more ports or faster than the shuffle instructions,
> depending on the micro-architecture), why he used 8x a 4-byte instead of a 1-byte
> displacement, or why he used "palignr/pblendw" instead of the shorter "punpck?qdq".

Not many people work on crypto assembly code, and x86 SIMD is especially
difficult because there are often multiple ways to do things that differ in
subtle ways such as instruction length and the execution ports used on different
models of CPU.  I think your suggestions are good, so thanks for them.

> 
> regards
> Stefan
> 
> PS: aaaahhhh, you picked my suggestion up and applied it to the AES routine.

Yes, I realized that a similar optimization can apply to AES round keys, as they
can be indexed them from -112 through 112 instead of 0 through 224.

- Eric
