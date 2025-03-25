Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1D98257AFD;
	Tue, 25 Mar 2025 15:25:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742916345; cv=none; b=Ti62CsQLd2X1KhDVunnSsDCChvWBP+WV8aiaEDALnEHzizl8HKk9gFe7a8txmX1m8e87Vb5e8XAkaPvZ0oNFnJSYzoW0vd4pjXDmI4DhMdYspO9iC16+prFzi1hlWsVuQhxp/j655V83bM7g6HoA+unEjh1+Efs2c9M+DB68fxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742916345; c=relaxed/simple;
	bh=uELpL5G8124+WMm8RMNSX8PwTjfyhgev6pYxUoaJln8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f6Do3wPCe0roZiw8L3vnejhZFXFhp21+puzzlAZuf6zGvEbdSUHCvTQq3+YP1y5j1mWec4XGS2iA6CiQObAdyhqlWWr63nDtLefpV4dGZxzGeNGGV75bTtnYODn7gRC6FtkKN/Jux0o0TmBgszHHT4fJYKQQd7UEnzaL7hYF+oQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mjFOhAO3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mjFOhAO3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D386C4CEEA;
	Tue, 25 Mar 2025 15:25:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742916343;
	bh=uELpL5G8124+WMm8RMNSX8PwTjfyhgev6pYxUoaJln8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mjFOhAO3aJD3ci+qTuAvkPRl+kQG1Rwl7KcONIdnlitGg9XVGGmTEOevae0M3v2xe
	 I2WFjnf6Ru398/VOJcrqqNBkB84ONjz/rsahCn/RDe0of3s+M1o5UFXrTGAmIeYx4f
	 a9+/hCrYKw+jTtD25AaRtIcCGJaJJ/MKfuV0JBEmteRtK+tVfPm7h3sktuDUU1uO16
	 pUZRElDemDw0/YaHxnIPK0oOOGMPZJzdaeHa1gad0L8eurMiBdma0d0OnCPg4NtIm2
	 Qk/oRhNMesurHtVFVGW0IJuCVvUbCwPYsAYpJAOk3ffTP4x+9XpEn7Zjmo7jKRW7uU
	 +uPA1/wO1xWrA==
Date: Tue, 25 Mar 2025 08:25:41 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [GIT PULL] Crypto Update for 6.15
Message-ID: <20250325152541.GA1661@sol.localdomain>
References: <ZOxnTFhchkTvKpZV@gondor.apana.org.au>
 <ZUNIBcBJ0VeZRmT9@gondor.apana.org.au>
 <ZZ3F/Pp1pxkdqfiD@gondor.apana.org.au>
 <ZfO6zKtvp2jSO4vF@gondor.apana.org.au>
 <ZkGN64ulwzPVvn6-@gondor.apana.org.au>
 <ZpkdZopjF9/9/Njx@gondor.apana.org.au>
 <ZuetBbpfq5X8BAwn@gondor.apana.org.au>
 <ZzqyAW2HKeIjGnKa@gondor.apana.org.au>
 <Z5Ijqi4uSDU9noZm@gondor.apana.org.au>
 <Z-JE2HNY-Tj8qwQw@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z-JE2HNY-Tj8qwQw@gondor.apana.org.au>

On Tue, Mar 25, 2025 at 01:53:28PM +0800, Herbert Xu wrote:
>
>       crypto: hash - Add request chaining API

Herbert didn't mention that I have nacked this patch, which he is insisting on
pushing for some reason instead of my original version that is much better.

Let me reiterate why "request chaining" is a bad idea and is going to cause
problems.

It makes it so that now a single hash request can now actually be a list of hash
requests.  It makes some of the crypto code operate on the whole list.  However,
most code still operates only on the first request in the list.  It's
undocumented and inconsistent which code is doing which, which is going to cause
bugs.  The first request in the list is also being treated specially in
undocumented ways, so submitting a list of requests is not necessarily
equivalent to submitting them all individually.  Another recipe for bugs.

Each hash request can also contain an entire scatterlist.  It's overkill for
what is actually needed for multibuffer hashing, which is a simple API that
hashes two buffers specified by virtual address.  Herbert's API creates lots of
unnecessary edge cases, most of which lack any testing.  It continues many of
the worst practices of the crypto API that we *know* are not working, like
requiring per-request memory allocations and optimizing for legacy hardware
offload rather than the CPU-based crypto that almost everyone actually uses.

In contrast, my patchset
https://lore.kernel.org/r/20250212154718.44255-1-ebiggers@kernel.org/ supports
multibuffer hashing in a much better way and has been ready for a year already.
It actually works; it has a smaller diffstat; it is faster; it has a much
simpler API; and it actually includes all needed pieces including x86 and arm64
support, dm-verity and fs-verity support, and full documentation and tests.

I've been spending a lot of time fixing the kernel's crypto code over the years.
I'm not looking forward to having another set of major issues to fix.

And this latest set of issues will be totally unnecessary.

We can do better than this, especially for cryptography code.

Nacked-by: Eric Biggers <ebiggers@kernel.org>

- Eric
