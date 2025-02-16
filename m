Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06E6EBE4A
	for <linux-crypto@vger.kernel.org>; Sun, 16 Feb 2025 03:38:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739677099; cv=none; b=a6VhhIEQezH9sk9JizIR3UtGTsN3rf3fiBG2fFdHo8wnwkfgIg75EOrjyiBwonsv8eMxUbaGQjZ9NN1pjrB7dvyIPduRPu1jMoAdrL4QMASD7uLwKsC/469GC8j/L8Ob8jewp3KlEjw8ww0cZh1VAXVJzRCv6Cae1o9uKpa6MC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739677099; c=relaxed/simple;
	bh=e8VfBOxlNkbHylfCQE0pHuG93Xez19I1W1sQi1AvjhU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rg86O62WlwQfj1TvRSgzKJQxRGr1+6DRM4xROkamxfocmhq+TMV/X9JqzY50gHCpXN6V+2SMd6bdXMlSbbzmzapvAMjUdaFq4trQSK4+vrflWq+VUiWoEKqjdkrEVTzvQsY8FkF4aMusJZffP2BXJJs/jOVpWg9P00AYkSqzCEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E47xu/kU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E47xu/kU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42BEFC4CEDD;
	Sun, 16 Feb 2025 03:38:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739677098;
	bh=e8VfBOxlNkbHylfCQE0pHuG93Xez19I1W1sQi1AvjhU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=E47xu/kUn3T6IE8qJP+vOFdUePhddKJS6Zmqz1HtXi/0uZ5vU3wYy5L3BVnvhpUoe
	 BbmOcCisEqICAlbvUWblYsvK9xh9SCrul0VV2BLQP1+B9L2u9iHGDkLyJTvziiHkHU
	 GojIL27b5G6oLRUIO4US42H7uk86XXj5c9zXIjf4b5KaasIVfR5Lpw6IGT8Y+ZtoP2
	 QB9ZJdhX62wuXQlzORZHEUjHJ01kXndJBP8SbBnoerYSLPoc77OUyJ4QTMne7/G0W0
	 7aReV1BjgJahgWPTSntUaJ8177hbDnNtl1hxb9OTqkM1WLvRU7yFXsF07uL5bwzFeL
	 h/BTDjwanMTbg==
Date: Sat, 15 Feb 2025 19:38:16 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Megha Dey <megha.dey@linux.intel.com>,
	Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: [v2 PATCH 00/11] Multibuffer hashing take two
Message-ID: <20250216033816.GB90952@quark.localdomain>
References: <cover.1739674648.git.herbert@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1739674648.git.herbert@gondor.apana.org.au>

On Sun, Feb 16, 2025 at 11:07:10AM +0800, Herbert Xu wrote:
> This patch-set introduces two additions to the ahash interface.
> First of all request chaining is added so that an arbitrary number
> of requests can be submitted in one go.  Incidentally this also
> reduces the cost of indirect calls by amortisation.
> 
> It then adds virtual address support to ahash.  This allows the
> user to supply a virtual address as the input instead of an SG
> list.
> 
> This is assumed to be not DMA-capable so it is always copied
> before it's passed to an existing ahash driver.  New drivers can
> elect to take virtual addresses directly.  Of course existing shash
> algorithms are able to take virtual addresses without any copying.
> 
> The next patch resurrects the old SHA2 AVX2 muiltibuffer code as
> a proof of concept that this API works.  The result shows that with
> a full complement of 8 requests, this API is able to achieve parity
> with the more modern but single-threaded SHA-NI code.  This passes
> the multibuffer fuzz tests.
> 
> Finally introduce a sync hash interface that is similar to the sync
> skcipher interface.  This will replace the shash interface for users.
> Use it in fsverity and enable multibuffer hashing.
> 
> Eric Biggers (1):
>   fsverity: improve performance by using multibuffer hashing
> 
> Herbert Xu (10):
>   crypto: ahash - Only save callback and data in ahash_save_req
>   crypto: x86/ghash - Use proper helpers to clone request
>   crypto: hash - Add request chaining API
>   crypto: tcrypt - Restore multibuffer ahash tests
>   crypto: ahash - Add virtual address support
>   crypto: ahash - Set default reqsize from ahash_alg
>   crypto: testmgr - Add multibuffer hash testing
>   crypto: x86/sha2 - Restore multibuffer AVX2 support
>   crypto: hash - Add sync hash interface
>   fsverity: Use sync hash instead of shash
> 
>  arch/x86/crypto/Makefile                   |   2 +-
>  arch/x86/crypto/ghash-clmulni-intel_glue.c |  23 +-
>  arch/x86/crypto/sha256_mb_mgr_datastruct.S | 304 +++++++++++
>  arch/x86/crypto/sha256_ssse3_glue.c        | 540 ++++++++++++++++--
>  arch/x86/crypto/sha256_x8_avx2.S           | 598 ++++++++++++++++++++
>  crypto/ahash.c                             | 605 ++++++++++++++++++---
>  crypto/algapi.c                            |   2 +-
>  crypto/tcrypt.c                            | 231 ++++++++
>  crypto/testmgr.c                           | 132 ++++-
>  fs/verity/fsverity_private.h               |   4 +-
>  fs/verity/hash_algs.c                      |  41 +-
>  fs/verity/verify.c                         | 179 +++++-
>  include/crypto/algapi.h                    |  11 +
>  include/crypto/hash.h                      | 172 +++++-
>  include/crypto/internal/hash.h             |  17 +-
>  include/linux/crypto.h                     |  24 +
>  16 files changed, 2659 insertions(+), 226 deletions(-)
>  create mode 100644 arch/x86/crypto/sha256_mb_mgr_datastruct.S
>  create mode 100644 arch/x86/crypto/sha256_x8_avx2.S

Nacked-by: Eric Biggers <ebiggers@kernel.org>

This new version hasn't fundamentally changed anything.  It's still a much
worse, unnecessarily complex and still incomplete implementation compared to my
patchset which has been ready to go for nearly a year already.  Please refer to
all the previous feedback that I've given.

- Eric
