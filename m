Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFA29199BC;
	Wed, 26 Mar 2025 03:20:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742959241; cv=none; b=jYHUuWYLnGO83yEUBGCkcDOoT2WwvGY+EHpFOIIBUSn65eBjByBsq0HOg/jhvAm7QGlS6V/FKx3el3MFXaPuSlbg2wKifaG8PRrazjjxMWMyOEGF21qzEGcC17wsBvUJBiS6X6pu82Kq/Msy0apKkOIDh+AMjEqLSQQEdtudYLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742959241; c=relaxed/simple;
	bh=AEfTpgYqz7rbvkoQLqqzMr/kEwROFLPRB/7sfHUJZn8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qDzX1IaejFv59Hem7bAzkXYrAn4/IsrC6STqCzsWZa5AkV39Bpk/uPn3FTC/KRqxJZVaNuv5QcGe/dRujAVjg+Si6mwH/Lw9QbyZ8xH47hMScm9cMTwP6nRMiOT0sZHo+6Ab4Cp/dsbrx7zS+V+9X/bR1SzRT+kGJ+jtmrlum88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TlaUKX45; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TlaUKX45"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CE8DC4CEE2;
	Wed, 26 Mar 2025 03:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742959240;
	bh=AEfTpgYqz7rbvkoQLqqzMr/kEwROFLPRB/7sfHUJZn8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TlaUKX45TkpooZBUAIcKyrfesQJ8YOrHoip6qelVgCbe73v9KGB7AMkWSesHNKzIe
	 oZ4gWnOPGCh+nveRrjBgKBApFxixhqLLPr9g72zO9kzALr4GSKxLMmCTYoNrdCl5ge
	 C3294vzO3FIT14N7GRaK1E8UgPDoQFYx7s/4y/JENT5Cy3TwhBpxuLm4X1eK0tk48a
	 +9whsePnuW3LjQJqXeDnAfLAyBlaekKiI7dH96D0GF2P/aTyQcUGUX9JUVqAB+zUOn
	 G/EQlIxpYYTKJ9VtHtdF2yBRtVA9DMMhDTslv3eSQItfHWAiU3OgJp152oJGFKRLyu
	 bW7743bkQv7Eg==
Date: Tue, 25 Mar 2025 20:20:38 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [GIT PULL] Crypto Update for 6.15
Message-ID: <20250326032038.GC1661@sol.localdomain>
References: <ZZ3F/Pp1pxkdqfiD@gondor.apana.org.au>
 <ZfO6zKtvp2jSO4vF@gondor.apana.org.au>
 <ZkGN64ulwzPVvn6-@gondor.apana.org.au>
 <ZpkdZopjF9/9/Njx@gondor.apana.org.au>
 <ZuetBbpfq5X8BAwn@gondor.apana.org.au>
 <ZzqyAW2HKeIjGnKa@gondor.apana.org.au>
 <Z5Ijqi4uSDU9noZm@gondor.apana.org.au>
 <Z-JE2HNY-Tj8qwQw@gondor.apana.org.au>
 <20250325152541.GA1661@sol.localdomain>
 <Z-NdGvErMGS5OT7X@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z-NdGvErMGS5OT7X@gondor.apana.org.au>

On Wed, Mar 26, 2025 at 09:49:14AM +0800, Herbert Xu wrote:
> On Tue, Mar 25, 2025 at 08:25:41AM -0700, Eric Biggers wrote:
> > 
> > Herbert didn't mention that I have nacked this patch, which he is insisting on
> > pushing for some reason instead of my original version that is much better.
> 
> Let's see how your version is so much better:
> 
> https://lore.kernel.org/all/20250212154718.44255-6-ebiggers@kernel.org/
> 
> -	/* Up to 1 + FS_VERITY_MAX_LEVELS pages may be mapped at once */
> -	BUILD_BUG_ON(1 + FS_VERITY_MAX_LEVELS > KM_MAX_IDX);
> +	/*
> +	 * Up to FS_VERITY_MAX_PENDING_DATA_BLOCKS + FS_VERITY_MAX_LEVELS pages
> +	 * may be mapped at once.
> +	 */
> +	BUILD_BUG_ON(FS_VERITY_MAX_PENDING_DATA_BLOCKS +
> +		     FS_VERITY_MAX_LEVELS > KM_MAX_IDX);
> 
> This arbitrary limit is a direct result of your welded-on commitment
> to an API that supports virtually mapped addresses only.  Make no
> mistake, virtual addresses are simple and easy to use, but the kernel
> added more complicated constructs for real reasons.

Umm, so you think someone is going to do multibuffer hashing with more buffers
than kmap_local supports (16)?  Why?  Regardless of the exact API, that case
would require kmap() to support.  It's hard to see how it would ever be worth
it, even if theoretically a CPU was capable of taking advantage of that much
instruction-level parallelism (this is implausible with SHA-256 instructions)
and ignoring the other issues like code size bloat and increased memory usage
that a very high interleaving factor would cause.

Of course, in practice this is just going to be used with 2x, which is what CPUs
can actually do with the SHA-256 instructions and avoids the various downsides
of overly-large interleaving factors.

> I've gone through your use-case in fsverity/dm-verity, and they
> never touch the data at all so the only reason for it to kmap the
> data at all is to feed it to the Crypto API, which is capable of
> doing its own kmap but you elected not to use that because you
> hate the interface.

Which is incorrect and just shows that you still haven't even read the code.
Take a look at cf715f4b7eb521a5bf67d391387b754c2fcde8d2.  Switching dm-verity to
always "map" the data blocks significantly simplified the dm-verity code (-138
line diffstat), *even before switching to shash*.  So we really want to just
pass virtual addresses to the crypto API too.  It's much simpler.

> In fact it's a recurring theme, the zswap code jumps through multiple
> hoops to map the data they're working on so that they can feed it to
> the Crypto API as a virtually mapped pointer, even though they never
> touch the mapped data at all.

Compression and hashing are not the same and use different APIs.  So this is a
straw man.  But I think you are on the wrong track for compression too.  What
zswap needs is relatively limited: only the compressed data (not the
uncompressed data) can be split across pages, and only 2 pages.  A complex API
with source and destination scatterlists isn't needed for this use case either,
even assuming that the best solution is to make all the compression algorithms
support this "natively" (most don't yet, or don't support it efficiently).
Other solutions that could be faster include just continuing to linearize the
data, or rethinking zswap to not create non-linear compressed data in the first
place, e.g. by putting compressed data only in large folios.

And yes, the zswap patchset is using request chaining, but that's because you
forced the zswap people to use it.  It wasn't their original proposal.  And
based on the discussions and various versions of the patchset, they've been
having quite a bit of trouble making sense of your API.

But again, this is compression, not hashing.  They don't use the same API.

> which I managed to simplify by switching away from kmapped pointers:
> 
> https://patchwork.kernel.org/project/linux-crypto/patch/99ae6a15afc1478bab201949dc3dbb2c7634b687.1742034499.git.herbert@gondor.apana.org.au/
> 

"Simplify" by a +90 line diffstat.  Sure.

> > Let me reiterate why "request chaining" is a bad idea and is going to cause
> > problems.
> 
> I'm more than willing to discuss with you the implementation details
> of how the chaining is done and improving it. However, if you proceed
> to only issue blanket nacks without providing any constructive feedback,
> then the only thing I can do is ignore you.

I've given you extensive constructive feedback over the past year, while you've
continued to nack my patches for inconsistent and bogus reasons.

> > In contrast, my patchset
> > https://lore.kernel.org/r/20250212154718.44255-1-ebiggers@kernel.org/ supports
> > multibuffer hashing in a much better way and has been ready for a year already.
> > It actually works; it has a smaller diffstat; it is faster; it has a much
> > simpler API; and it actually includes all needed pieces including x86 and arm64
> > support, dm-verity and fs-verity support, and full documentation and tests.
> 
> Everybody wants to sratch their itch but my job as the maintainer is
> to ensure that the subsystem doesn't collapse into an unmaintainable
> hodgepodge of individual contributions.

But when there is only one such contribution, why overengineer it with something
that is slower, more complex, more error-prone, and harder to maintain?
Especially when this is a kernel-internal API that we can change whenever we
want to suit what is actually being used in the kernel.

And your vague plan to use multibuffer hashing in IPsec doesn't count.  I keep
explaining why it doesn't actually make sense, and how I've *actually* been
optimizing IPsec in other ways that actually matter and actually work, but you
haven't been listening.

> This pull request doesn't even contain the meat of the hash changes
> since I've been busy with the compression work.  So this is simply
> a pre-emptive strike to stop further work from rendering your patches
> obsolete.

I'd love for your work to make my patches obsolete, but unfortunately your
version is just worse.  And besides it being very incomplete, the main issue is
fundamental with the design.  So it doesn't really make sense to use it,
especially when I'm going to get stuck cleaning up your mess again.

- Eric
