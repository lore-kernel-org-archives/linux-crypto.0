Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF703125D9
	for <linux-crypto@vger.kernel.org>; Fri, 23 Feb 2024 06:39:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708670351; cv=none; b=BLasAhZT7omYxo1MZjO/ZVMnCPw7+lJZo3sIdHsEY+4UQRF31xBABQfdbvsMv4NTejlnAWGGzGfGb4cfY9zhfxIuusXl/7tdQ4UdLwuiH3JBw9QGJaeCoILfwIFtzqEL+MuDwWQvwqd3LGvtsNRQR5zpVFclWLJW4MUe4Ri+g4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708670351; c=relaxed/simple;
	bh=Ido/ALlExhvBWSYHLfwgDWpBxJbj/7ThOxFMW+Z0z7Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kKWoOQDirpkGLRbcGp1OR7JOVQYFii76dgUTjDMTe4FYoBHNfppK9mQprOwg6wQy/xpecyy6YjC9w7jC5C6ulIf3XNmmmnBU8PJ4GsFKEF56MUngBiM+gNFhp8cqBvtJh46oElWyqK+OT23KRFwrRhBiLi6eFFiD7sq0yM4m6cw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rYl5lut8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rYl5lut8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3426C43390;
	Fri, 23 Feb 2024 06:39:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708670350;
	bh=Ido/ALlExhvBWSYHLfwgDWpBxJbj/7ThOxFMW+Z0z7Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rYl5lut8AsgV4b2ITDnuecaqJ4KjWM4B2ZlLViMGFVt1IkigSa/YsOmHzhH4C5Pgx
	 6vnBtR83cpyIFYHLSpfYsmuiT7VDEY0Xm0CG356gXpzqovgxppUno9ypoN90PxgZPz
	 YayV9jl7LRU2fXdtfEmgixJF60jAy40M+O8VS90+O0qc+tbFaKVeqxa9ZR52O8z1zw
	 /gB690eFR2rIbC3GdL/QpvY9C9Fmfz3aSej87r+oQJvfmGAZDUeKPDv8vAbUyE9o6Q
	 0F3QA0kWtNsRPP247Je3mr29UmpDyLvaXRh3q+sHK5VFJbxfHghEQlWqnZlkHZmt62
	 4Zm1FZLGQgVHQ==
Date: Thu, 22 Feb 2024 22:39:09 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH 00/15] crypto: Add twopass lskcipher for adiantum
Message-ID: <20240223063909.GI25631@sol.localdomain>
References: <cover.1707815065.git.herbert@gondor.apana.org.au>
 <20240214233517.GD1638@sol.localdomain>
 <Zc3JUsRbtzNqMR0p@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zc3JUsRbtzNqMR0p@gondor.apana.org.au>

On Thu, Feb 15, 2024 at 04:20:34PM +0800, Herbert Xu wrote:
> On Wed, Feb 14, 2024 at 03:35:17PM -0800, Eric Biggers wrote:
> > 
> > Thanks.  Can you include an explanation of the high-level context and goals for
> > this work?  It's still not clear to me.  I'm guessing that the main goal is to
> > get rid of the vaddr => scatterlist => vaddr round trip for software
> > encryption/decryption, which hopefully will improve performance and make the API
> > easier to use?  And to do that, all software algorithms need to be converted to
> 
> The main goal is to remove the legacy cipher type, and replacing
> it with lskcipher.

What is the benefit of that change?

This series also goes way beyond that, so it seems like there's more going on
here.  I do like the support for vaddr; the scatterlist-based APIs have always
been one of the main pain points with the crypto API.  But you're claiming
that fixing that isn't actually the goal.  So I'm confused.

> > "lskcipher"?  Will skcipher API users actually be able to convert to lskcipher,
> > or will they be blocked by people expecting to be able to use hardware crypto
> > accelerators?  Would you accept lskcipher being used alongside skcipher?
> 
> That's a question for each user to decide.
> 
> > Previously you had said you don't want shash being used alongside ahash.
> 
> In general, if the amount of data being processed is large, then
> I would expect the use of hardware accelerators to be a possibility
> and therefore choose the SG-based interface.
> 
> I wouldn't consider 4K to be large though.  So it's really when you
> feed hundreds of kilobytes of data through the algorithm when I would
> recommend against using shash.

dm-verity usually hashes 4K at a time, but that was enough for people to want it
to support hardware accelerators, so it had to be switched to ahash.  But, you
objected to my patch that added shash support to dm-verity alongside ahash
(https://lore.kernel.org/dm-devel/20231030023351.6041-1-ebiggers@kernel.org).

That suggests that adding lskcipher support to dm-crypt and fscrypt alongside
skcipher would similarly not be "allowed".  Most users don't use off-CPU
hardware accelerators with those, but some do.

I did get away with (so far) switching fs/verity/ to shash.  I'm not sure I
could similarly get away with switching fs/crypto/ to lskcipher.  There are
people using the CAAM AES-CBC hardware accelerator with fscrypt.

Before we go through a big effort to convert all these algorithms to lskcipher,
or (more likely based on history) leave everything in a half-finished state, I'd
like to get a good sense that lskcipher will be useful.

- Eric
