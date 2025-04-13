Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F24D442A8B
	for <linux-crypto@vger.kernel.org>; Sun, 13 Apr 2025 16:29:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744561776; cv=none; b=LqiRS+4AWYXesY1Pz3Cn+ndD8ZDCRWP1y5BYi553aOgaOPKJxZzxN/cKX+Jnuy0fb5CxwjGvLcSLKT9aPi/gKF7T5rbtmhKt1xOGe8+rodg6MmvRFA4KtyG7k/G7alNUnPYdLhdq2nD5roi2Feo4GFVuNdWJCxij8xkCpeg+RHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744561776; c=relaxed/simple;
	bh=xKMPAW9NMa7syf7Idg/oFNgkOHXxjJcIP5GmTEAmjz0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uqMaOUCfayDCl82Yw/aGZbpy9yKb5hvYbwc0tL9Gg2r57gqpkq3w+atncDa03bAvTsEVOg+tyWaeWsOz8yEIFk+L57EwQ8CPfwdJ0z2nrQcu5bCFERzNlN1e5UeWYkiIsr3cRI1dQe5849G4kQvFU2mGLz997T0s0Sgn9w1PIWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CMoOzICf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CMoOzICf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37679C4CEDD;
	Sun, 13 Apr 2025 16:29:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744561775;
	bh=xKMPAW9NMa7syf7Idg/oFNgkOHXxjJcIP5GmTEAmjz0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CMoOzICfAFF3EVI5JeEUO8qsSnQsnJQlayHw5NkEkqjPGoiY45j2GZ1rZw9OVGeb8
	 BJe07EW5eaLEE+kySJzZhq7jv/JdbUG0N1EFGnjSWo6+rm5g6GkX/J38gyYl+hVePx
	 daaahNUla+gGbICzaLUPeoJLijxM9XkfJ04aAu70GFmcZohyt9FCAaV+t861Yz4A9H
	 ZULNdXgN3ydvebr227SXS+pxBU1f1sS9KbM7Od9woearkxlpBYtWsQ0T5qU3gSjEnf
	 ecDA1Qz3SrZfZOD8cnupNSdRzLh4V2ZC3xtEXObtkPJ5c9x6oB2r+d+BEFKG6PtrY/
	 7LSLkZl1QICgA==
Date: Sun, 13 Apr 2025 09:29:33 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH 0/8] crypto: hash - Preparation for block-only shash
Message-ID: <20250413162933.GB16145@quark.localdomain>
References: <cover.1744455146.git.herbert@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1744455146.git.herbert@gondor.apana.org.au>

On Sat, Apr 12, 2025 at 06:57:17PM +0800, Herbert Xu wrote:
> This series is based on
> 
> 	https://lore.kernel.org/linux-crypto/cover.1744454589.git.herbert@gondor.apana.org.au
> 
> Add helpers to use stack requests with any ahash algorithm, with
> optional dynamic allocation when required for async.
> 
> THe rest of the series are miscellaneous fixes in preparation for
> the next series which will introduce block-only shash.

What is a "block-only shash" and why does it make sense?

Based on the name, the fact that patch 8 is fiddling with cra_blocksize for one
of the algorithms, and your general preference for trying to make the "Crypto
API" solve problems even when it's not the right solution, I'm assuming that
you're planning to make crypto/shash.c do the block buffering for all shash
algorithms "automatically" using cra_blocksize.

That doesn't actually make sense, though.  The more logical way to organize the
code, as I think my patchsets converting crc32, crc32c, and poly1305 make very
clear, is to have the shash API be implemented using the library API.  The
library API has to handle arbitrary length inputs anyway, so it has to implement
the block buffering anyway.  Thus, there's no need for shash to do it at all.

shash merely needs to know the block size and declare it in cra_blocksize for
users who want it for some reason (e.g. for padding salts to the block size).
shash should not care about the block size in any other way.

It's true that e.g. in the case of poly1305, each arch's library code implements
the block buffering.  So the redundancy that I think you're trying to solve does
exist in the library too.  But, the solution to that is to move the block
buffering up one level, to poly1305_update(), so that it's shared by all the
arches, just like what blake2s already does.  I am going to consider doing this,
especially as I get around to fixing the other hash algorithms.  (If we do this
for Poly1305, it would be an additional cleanup on top of my patch series
https://lore.kernel.org/linux-crypto/20250413045421.55100-1-ebiggers@kernel.org/)
But, this has nothing to do with shash; shash plays no role in the solution.

- Eric
