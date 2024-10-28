Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA99B17B50E
	for <linux-crypto@vger.kernel.org>; Mon, 28 Oct 2024 19:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730142047; cv=none; b=rqyVYu1d9wclu86Wu/tQnP1JJhLJHR3imZPTb3DLOcQ3lcd6TQEyaK1CDj/E3fuEG4pO/XSXsM/ZpOzNybKdmsp+zvg4aMLO3WgsN1FqQll2Wo9FfpwDT5IZxdGUrEYgkkQXESLybc1x87nttVWTJaNX1nzb//FR+89DJi//V8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730142047; c=relaxed/simple;
	bh=GMEyItmwdi+RYoqDwOJTEcixmRkfvjmCzu6D50t3VSw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Its9UcZ63J66pTSxvMxhjsv1O/FWYNFgUDYkKBFOex4C+DZBRUXs9qgpn/4y+ZSzMgEhjKXd96S3jCxYfulJCGBWIKhagMeKYhYXBF708YSpFB8cEiOw04wvH78n4fQCsspFGApAm7V/kwVQc/ebG2mw8hEk1FfHQZn8X3Bdqqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H1jnuIfK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H1jnuIfK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16E71C4CEE4;
	Mon, 28 Oct 2024 19:00:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730142047;
	bh=GMEyItmwdi+RYoqDwOJTEcixmRkfvjmCzu6D50t3VSw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=H1jnuIfK+YtzSsJ+hHDkPZNqfrDIs4JHUTMi8fjPtrd5FqtqMR4Iz7mH3wMR/dYwT
	 NuWVnY+PIQrt6OZajs/LuD8zhowLWXueRcKmf1BowN5TuwzTf4rFVouSQmoAPhdGQT
	 PwS/n2L2nCqKWpQ8fyRkIyjKfv17hu3G4sf2j/RZABiQsBGyhRc3Dbv1v/7nFu8ERm
	 W0kT8bw8Hba1EkksjLXvSCqaJ6wrCetr7cLz+h5gXkKB5gIJNqACGP55K/GRqEsPVX
	 NYPGXFCamnf1dEKBLWQrXp1Vtyrr9RIt7ih0YslO38i0M3v9KozUvMZWdpOe5UCAsO
	 fCkIlbc7RJpwQ==
Date: Mon, 28 Oct 2024 12:00:45 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Megha Dey <megha.dey@linux.intel.com>,
	Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: [PATCH 0/6] Multibuffer hashing take two
Message-ID: <20241028190045.GA1408@sol.localdomain>
References: <cover.1730021644.git.herbert@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1730021644.git.herbert@gondor.apana.org.au>

Hi Herbert,

On Sun, Oct 27, 2024 at 05:45:28PM +0800, Herbert Xu wrote:
> Multibuffer hashing was a constant sore while it was part of the
> kernel.  It was very buggy and unnecessarily complex.  Finally
> it was removed when it had been broken for a while without anyone
> noticing.
> 
> Peace reigned in its absence, until Eric Biggers made a proposal
> for its comeback :)
> 
> Link: https://lore.kernel.org/all/20240415213719.120673-1-ebiggers@kernel.org/
> 
> The issue is that the SHA algorithm (and possibly others) is
> inherently not parallelisable.  Therefore the only way to exploit
> parallelism on modern CPUs is to hash multiple indendent streams
> of data.
> 
> Eric's proposal is a simple interface bolted onto shash that takes
> two streams of data of identical length.  I thought the limitation
> of two was too small, and Eric addressed that in his latest version:
> 
> Link: https://lore.kernel.org/all/20241001153718.111665-2-ebiggers@kernel.org/
> 
> However, I still disliked the addition of this to shash as it meant
> that users would have to spend extra effort in order to accumulate
> and maintain multiple streams of data.
> 
> My preference is to use ahash as the basis of multibuffer, because
> its request object interface is perfectly suited to chaining.

As I've explained before, I think your proposed approach is much too complex,
inefficient, and broken compared to my much simpler patchset
https://lore.kernel.org/linux-crypto/20241001153718.111665-1-ebiggers@kernel.org/.
If this is really going to be the API for multibuffer hashing, then I'm not very
interested in using or contributing to it.

The much larger positive diffstat in your patchset alone should speak for
itself, especially when it doesn't include essential pieces that were included
in my smaller patchset, such as self-tests, dm-verity and fs-verity support,
SHA-NI and ARMv8 CE support.  Note that due to the complexity of your API, it
would require far more updates to the tests in order to cover all the new edge
cases.  This patchset also removes the shash support for sha256-avx2, which is
not realistic, as there are still ~100 users of shash in the kernel.

You say that your API is needed so that users don't need to "spend extra effort
in order to accumulate and maintain multiple streams of data."  That's
incorrect, though.  The users, e.g. {dm,fs}-verity, will need to do that anyway
even with your API.  I think this would have been clear if you had tried to
update them to use your API.

With this patchset I am also seeing random crashes in the x86 sha256 glue code,
and all multibuffer SHA256 hashes come back as all-zeroes.  Bugs like this were
predictable, of course.  There's a high amount of complexity inherent in the
ahash request chaining approach, both at the API layer and in the per-algorithm
glue code.  It will be hard to get everything right.  And I am just submitting 8
equal-length requests, so I haven't even tried any of the edge cases that your
proposed API allows, like submitting requests that aren't synced up properly.

I don't think it's worth the time for me to try to debug and fix your code and
add the missing pieces, when we could just choose a much simpler design that
would result in far fewer bugs.  Especially for cryptographic code, choosing
sound designs that minimize the number of bugs should be the highest priority.

I understand that you're trying to contribute something useful, and perhaps
solve a wider set of problems than I set out to solve.  The reality, though, is
that this patchset is creating more problems than it's solving.  Compared to my
patchset, it makes things harder, more error-prone, and less efficient for the
users who actually want the multibuffer hashing, and likewise for wiring it up
to the low-level algorithms.  It also doesn't bring us meaningfully closer to
applying multibuffer crypto in other applications like IPsec where it will be
very difficult to apply, is irrelevant for the most common algorithm used, and
would at best provide less benefit than other easier-to-implement optimizations.

The virtual address to support in ahash is a somewhat nice addition, but it
could go in independently, and ultimately it seems not that useful, given that
users could just use shash or lib/crypto/ instead.  shash will still have less
overhead, and lib/crypto/ even less, despite ahash getting slightly better.
Also, users who actually care about old-school style crypto accelerators need
pages + async processing anyway for optimal performance, especially given this
patchset's proposed approach of handling virtual addresses using a bounce page.

If you're really interested in the AVX2 multibuffer SHA256 for some reason, I'd
be willing to clean up that assembly code and wire it up to the much simpler API
that I proposed.  Despite the favorable microbenchmark result, this would be of
limited use, for various reasons that I've explained before.  But it could be
done if desired, and it would be much simpler than what you have.

- Eric 
