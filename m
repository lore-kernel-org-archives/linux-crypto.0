Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE79126B975
	for <linux-crypto@vger.kernel.org>; Tue, 18 Feb 2025 17:48:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739900892; cv=none; b=gm1GQiGtH1JtZ8cbSTZo5Co05sVIp9Jm6HCiN+tm8DgUwHGh9Gaw8PcHqmI5rwhZheg0JZZmcXMFv548RtXuqgKGD0+Zya5oZ78W7Q3debN9IwztjfLv1qBLkB83gVZXqZQuDeKpaqNdYMAAN73Vqv04bozOmV3uVzqMTkwKFxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739900892; c=relaxed/simple;
	bh=8Xt3vLEV/Rk+UE7HBk85WSwUwGQB6/DZTYhjnWPQUYA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RIN0K7+nW1SJ0SKavjC64z1ntWM9U4ul7Byde88zm5jDxauP74aUtYk+qBZIhPEaAW+vp7d9rQxAI6FMoBox2sxqZYAflnWhLZ+ZVbDWObfibvuZLbDarxf47goN2RDv3FqeB4PKR0BAZ4b6BzE4kU1DUyHN5dgnDh7JzsHOckU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tDklhLXy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tDklhLXy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 203B3C4CEE2;
	Tue, 18 Feb 2025 17:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739900892;
	bh=8Xt3vLEV/Rk+UE7HBk85WSwUwGQB6/DZTYhjnWPQUYA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tDklhLXyG1Hy2GY6QcFjx+CoGRDcfTw8VNqeU443X6RHOgnx2xHmFIpS8KqEHZM3x
	 XXBnbSvY9huLyRLqHqfCxUstw94puhaO2s8s8mrhT6DZU4M26GsvEmn467//McSVzM
	 Q3vb2dOHSaSns6kvHxJB5x0U22ei6CTeCjGofVvgTAftija2pe4SqQXaX+exJj/hp3
	 Ja06cIB/U4nKuTHArKikkXLyGcw95EVJB83+Ho1wg7hPmvMWdrOJpI61e3HKSTlmC7
	 WTK8mfZKdrXZBXw/rADCnFWDNIr5aQX46RSMZC5/KQjYYAMzcVdA9xpGAHFdPFExS1
	 No6bam55zP0ZA==
Date: Tue, 18 Feb 2025 17:48:10 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Megha Dey <megha.dey@linux.intel.com>,
	Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: [v2 PATCH 00/11] Multibuffer hashing take two
Message-ID: <20250218174810.GA4100189@google.com>
References: <cover.1739674648.git.herbert@gondor.apana.org.au>
 <20250216033816.GB90952@quark.localdomain>
 <Z7HHhWZI4Nb_-sJh@gondor.apana.org.au>
 <20250216195129.GB2404@sol.localdomain>
 <Z7RcnKGNGP50mdb-@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z7RcnKGNGP50mdb-@gondor.apana.org.au>

On Tue, Feb 18, 2025 at 06:10:36PM +0800, Herbert Xu wrote:
> On Sun, Feb 16, 2025 at 11:51:29AM -0800, Eric Biggers wrote:
> >
> > But of course, there is no need to go there in the first place.  Cryptographic
> > APIs should be simple and not include unnecessary edge cases.  It seems you
> > still have a misconception that your more complex API would make my work useful
> > for IPsec, but again that is still incorrect, as I've explained many times.  The
> > latest bogus claims that you've been making, like that GHASH is not
> > parallelizable, don't exactly inspire confidence either.
> 
> Sure, everyone hates complexity.  But you're not removing it.

I'm avoiding adding it in the first place.

> You're simply pushing the complexity into the algorithm implementation
> and more importantly, the user.  With your interface the user has to
> jump through unnecessary hoops to get multiple requests going, which
> is probably why you limited it to just 2.
> 
> If anything we should be pushing the complexity into the API code
> itself and away from the algorithm implementation.  Why? Because
> it's shared and therefore the test coverage works much better.
> 
> Look over the years at how many buggy edge cases such as block
> left-overs we have had in arch crypto code.  Now if those edge
> cases were moved into shared API code it would be much better.
> Sure it could still be buggy, but it would affect everyone
> equally and that means it's much easier to catch.

You cannot ignore complexity in the API, as that is the worst kind.

In addition, your (slower) solution has a large amount of complexity in the
per-algorithm glue code, making it still more lines of code *per algorithm* than
my (faster) solution, which you're ignoring.

Also, users still have to queue up multiple requests anyway.  There are no
"unnecessary hoops" with my patches -- just a faster, simpler, easier to use and
less error-prone API.

>     Memory allocations can always fail, but they *rarely* do.  Resolve
>     the OOM case by using a stack request as a fallback.

Rarely executed fallbacks that are only executed in extremely rare OOM
situations that won't be covered by xfstests?  No thank you.  Why would you even
think that would be reasonable?

Anyway, I am getting tired of responding to all your weird arguments that don't
bring anything new to the table.  Please continue to treat your patches as
nacked and don't treat silence as agreement.  I am just tired of this.

- Eric
