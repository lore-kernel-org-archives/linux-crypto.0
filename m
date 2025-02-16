Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C87A6179A3
	for <linux-crypto@vger.kernel.org>; Sun, 16 Feb 2025 19:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739735491; cv=none; b=ZIFk7Cx9GW63n+aRMrwnhq3gDP1khpCF+ledoFG5Nypy57YCd0tIxwO4eQqQ2DwYWqfEKqjAhsTie3dFOIHp1WN0xFC6R7+gocaly3Ild6EVV5p1lghXJIxCNcEs8FpjVWsXb839Hx4HZVukzrzNoJlZtA7v+K4VcGamZzLWCvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739735491; c=relaxed/simple;
	bh=1hBQwnDsIBVBB3OG+j7Sc9xkUPWjklD42Afi4XMHbY0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a3OagONseMp0GMo+rl82qNPkjHTZBErwbb/SLT02m+vLkAVltBVfHO+MX8suvqE/30yoWdTXtd9ElS60biejMr8UbAfu96CQLr6NOQLhqSCmiCt3kDVR3oC96MQv6425R4szL9lmBzWwhirT6cYQ1gAzeNrKJuqfC8JZSIHQsWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PbCxRDgb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PbCxRDgb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A3AFC4CEDD;
	Sun, 16 Feb 2025 19:51:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739735491;
	bh=1hBQwnDsIBVBB3OG+j7Sc9xkUPWjklD42Afi4XMHbY0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PbCxRDgba8DiOQd5mmfKG6IWPCNSuHfwDMKAC813L2AwittQvPkroZDjkVV9J1omP
	 vbdhCygMnyOhmOeL9+8XsK7HyvZTtoMs64OAh5QVfDGqa9JuTOva/2YisZAK8voGAm
	 6ch6SVS0GkLhD/dFmmaYrK49vXA69FyHcEEe+Wla1uQi9hIrA1n43iORRO0PbeU+sf
	 ZrLAEXE+eoO8F+KM7rggMEh+d7k1hyhmGw1Na6iu8v8J51yLFq7m/d7iO+Hi+zRPZe
	 jdtfuHGu9seO9Gj+Cmzq5ceHTRNPAHna1G2gGctME3jzlpemVYFzvaxewlQk/EV5xr
	 sI/4XUBSrLVLQ==
Date: Sun, 16 Feb 2025 11:51:29 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Megha Dey <megha.dey@linux.intel.com>,
	Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: [v2 PATCH 00/11] Multibuffer hashing take two
Message-ID: <20250216195129.GB2404@sol.localdomain>
References: <cover.1739674648.git.herbert@gondor.apana.org.au>
 <20250216033816.GB90952@quark.localdomain>
 <Z7HHhWZI4Nb_-sJh@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z7HHhWZI4Nb_-sJh@gondor.apana.org.au>

On Sun, Feb 16, 2025 at 07:09:57PM +0800, Herbert Xu wrote:
> On Sat, Feb 15, 2025 at 07:38:16PM -0800, Eric Biggers wrote:
> > 
> > This new version hasn't fundamentally changed anything.  It's still a much
> > worse, unnecessarily complex and still incomplete implementation compared to my
> > patchset which has been ready to go for nearly a year already.  Please refer to
> > all the previous feedback that I've given.
> 
> FWIW, my interface is a lot simpler than yours to implement, since
> it doesn't deal with the partial buffer non-sense in assembly.  In
> fact that was a big mistake with the original API, the partial data
> handling should've been moved to the API layer a long time ago.

We've already discussed this.  It is part of the multibuffer optimization, as
instruction interleaving is applicable to partial block handling and
finalization too.  It also makes those parts able to use SIMD.  Both of those
improve performance.  But more importantly it eliminates the need for a separate
descriptor for each message.  That results in massive simplifications up the
stack.  The per-algorithm C glue code is much simpler, the API is much simpler
and has fewer edge cases, and with only one descriptor being needed it becomes
feasible to allocate it on the stack.  Overall it's just much more streamlined.

For all these reasons my version ends up with a much smaller diffstat, despite
the assembly code being longer and more optimized.

I see that you didn't even bother to include any tests for all the edge cases in
your API where descriptors and/or scatterlists aren't synced up.  As I've
explained before, these cases would be a huge pain to get right.

But of course, there is no need to go there in the first place.  Cryptographic
APIs should be simple and not include unnecessary edge cases.  It seems you
still have a misconception that your more complex API would make my work useful
for IPsec, but again that is still incorrect, as I've explained many times.  The
latest bogus claims that you've been making, like that GHASH is not
parallelizable, don't exactly inspire confidence either.

- Eric
