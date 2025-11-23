Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 558D91F30C3;
	Sun, 23 Nov 2025 04:02:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763870543; cv=none; b=pfn99+8DZhrm8HCaBgO3TSg7E+XRblHp+kMFAmwQRkbZH7+PwK02NbN8PeBDx5kKFkSih0v1Aa5opOT+/nU7GY/YqzJGCxhRKnCMS/fgHrSRKIle5inMCsbx/cWJhQeaibCT4/a6bF7hR+pvdYOnoduBVhu+p5d6MEF6SC7KBWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763870543; c=relaxed/simple;
	bh=OsF9dPiGydUb1fjm8xjTcrh4gguoIJyFvKzt3XGkjT4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N567lTQ4gstVcYj7PfL+CgBaoBGdJpGsHaC5syYTQlGF0iy/CdEloqUIte4ZuHhrP7k13yG90rH+C0IAGvwg5nEt5SiczQX4clmSUrpI99lLytzCmdiwpa2t4jv9KeUgktMadTZPAfGbEdjEi7XsQfnK1idjssjJtg3FMvunrtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VIxtWAUE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VIxtWAUE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90FCBC116B1;
	Sun, 23 Nov 2025 04:02:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763870542;
	bh=OsF9dPiGydUb1fjm8xjTcrh4gguoIJyFvKzt3XGkjT4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VIxtWAUE0gjcsPieb3q8t7lfBREh+8Q3CBXR8fHcLDvW7MLMsr6f9M9RYZmkNjRVv
	 gFNdnfuT6ydQoFIx2OmswbvDN8bmu+2BKYI5BoQIzwcHe1dkFQsmLrAqNNDVl2VXiM
	 GheFMboiOQctW8RwSRkAk/0GLPBbUARnLwC6ZsnBrZKoc0iM+1zH8j4x4fxOe1TJso
	 jQvVWGD2KaQ77rUINj63TusHzcv0oX7FrfjbZARL8CWrAShJbqXYTAcU4kpe6qFMcG
	 1C3I56VijXpGOinoPtCbtlK+8YTHIOfLcv79S5joQBjuMxg5zKO8tJ2z2s/TtGI/aI
	 mSztAOC48waoQ==
Date: Sat, 22 Nov 2025 20:00:37 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-hardening@vger.kernel.org, Kees Cook <kees@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 0/6] lib/crypto: More at_least decorations
Message-ID: <20251123040037.GA42791@sol>
References: <20251122194206.31822-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251122194206.31822-1-ebiggers@kernel.org>

On Sat, Nov 22, 2025 at 11:42:00AM -0800, Eric Biggers wrote:
> This series depends on the 'at_least' macro added by
> https://lore.kernel.org/r/20251122025510.1625066-4-Jason@zx2c4.com
> It can also be retrieved from
> 
>     git fetch https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git more-at-least-decorations-v1
> 
> Add the at_least (i.e. 'static') decoration to the fixed-size array
> parameters of more of the crypto library functions.  This causes clang
> to generate a warning if a too-small array of known size is passed.
> 
> Eric Biggers (6):
>   lib/crypto: chacha: Add at_least decoration to fixed-size array params
>   lib/crypto: curve25519: Add at_least decoration to fixed-size array
>     params
>   lib/crypto: md5: Add at_least decoration to fixed-size array params
>   lib/crypto: poly1305: Add at_least decoration to fixed-size array
>     params
>   lib/crypto: sha1: Add at_least decoration to fixed-size array params
>   lib/crypto: sha2: Add at_least decoration to fixed-size array params
> 
>  include/crypto/chacha.h     | 12 ++++-----
>  include/crypto/curve25519.h | 24 ++++++++++-------
>  include/crypto/md5.h        | 11 ++++----
>  include/crypto/poly1305.h   |  2 +-
>  include/crypto/sha1.h       | 12 +++++----
>  include/crypto/sha2.h       | 53 ++++++++++++++++++++++---------------

It turns out this causes a build error when <crypto/poly1305.h>,
<crypto/sha1.h>, or <crypto/sha2.h> is included before
<linux/compiler.h>.

Jason's patch to <crypto/chacha20poly1305.h> is okay, because that one
indirectly includes <linux/compiler.h> by chance.

I thought <linux/compiler.h> already got included in everything via the
-include compiler flag.  But it's actually <linux/compiler_types.h>
which works that way, not <linux/compiler.h> which is a regular header.

We can make these crypto headers include <linux/compiler.h>.  But before
we do that, should we perhaps consider putting the definition of
'at_least' in <linux/compiler_types.h> instead of in <linux/compiler.h>,
so that it becomes always available?  This is basically a core language
feature.  Maybe it belongs next to the definition of __counted_by, which
is another definition related to array bounds?

- Eric
