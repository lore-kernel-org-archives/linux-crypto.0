Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBDAD259CAF;
	Fri, 17 Oct 2025 16:06:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760717171; cv=none; b=BpEK77XCOpC7hUJH2rz8pJ0hX245gJv577AyB0S6GuLwhoDINXVCEFqntJHmimCbNMUBC8KR+UAFuaj64ei/mtBU5a7MKX1uxt9CrTZHDvHASUjYOTNAJ6SSCAPHCSswoluFIggc1k54PwnYkxzhvKTb3vx8M384oBEsJ9x1jzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760717171; c=relaxed/simple;
	bh=mMn+A5vb7WZSNlXsUJJR8RQuOL2xMgNRYtvTYr4tbcU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uwPlA7Vyg6mMR7apQP/oPX1xxAY2TGjVqZe3NPfAXNM9wXjQsSPlBKa8StLTMhbP08RAUzFqp3zrTozt7mUCWnpANEO6SGgv0USrZUANxeEbSM3aTKdTVS0bHRAcMCo2N6s7XqeIWC62Uqw0cZc+74NZB+qGsbLQDMTQGyOoCzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mNddrQRw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mNddrQRw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D8AFC116B1;
	Fri, 17 Oct 2025 16:06:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760717170;
	bh=mMn+A5vb7WZSNlXsUJJR8RQuOL2xMgNRYtvTYr4tbcU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mNddrQRwmWMwKIJRRUymDW+GQDQQ36AqFBPij4GsBxlB6yxHIfoLQbFr21sKzrM78
	 +Kmrg5zLFGnJwQgDIPpYkfh9EjxVvvYB6nBE4deMU65Wk0y5yQoOmtlDP/hUt8UNRU
	 EywzOkHUV/JfypodwDx3sjBjSsqwCeKC2psWM9HDQS6iEa1A1AO6vL54TVCl2P2E6c
	 mfykJmHxMqj7WX1C95bTgM0erQ/F5FJnelj6cNPAT6GeRhX7xX3HI2/wojlPN7VlJR
	 EvWUc4DlxbgFw8aRZZAKCGOv0Vw+02xsd5vOoQ6tLBMuWzaoKuNrkpuqYfvrrbsdSI
	 X0R03f0y5KQrQ==
Date: Fri, 17 Oct 2025 09:04:37 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, x86@kernel.org, Jason@zx2c4.com
Subject: Re: [PATCH 0/8] VAES+AVX2 optimized implementation of AES-GCM
Message-ID: <20251017160437.GA1566@sol>
References: <20251014003123.GA2763@sol>
 <aPH9ZQP0m8Pq5Iy-@gondor.apana.org.au>
 <CAMj1kXGE6-xiUSyKa92=HWeywt=5-F2_G2H7V-UnVhKG65zwCA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXGE6-xiUSyKa92=HWeywt=5-F2_G2H7V-UnVhKG65zwCA@mail.gmail.com>

On Fri, Oct 17, 2025 at 10:44:37AM +0200, Ard Biesheuvel wrote:
> On Fri, 17 Oct 2025 at 10:25, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> >
> > Eric Biggers <ebiggers@kernel.org> wrote:
> > > On Wed, Oct 01, 2025 at 07:31:09PM -0700, Eric Biggers wrote:
> > >> This patchset replaces the 256-bit vector implementation of AES-GCM for
> > >> x86_64 with one that requires AVX2 rather than AVX512.  This greatly
> > >> improves AES-GCM performance on CPUs that have VAES but not AVX512, for
> > >> example by up to 74% on AMD Zen 3.  For more details, see patch 1.
> > >>
> > >> This patchset also renames the 512-bit vector implementation of AES-GCM
> > >> for x86_64 to be named after AVX512 rather than AVX10/512, then adds
> > >> some additional optimizations to it.
> > >>
> > >> This patchset applies to next-20250929 and is targeting 6.19.  Herbert,
> > >> I'd prefer to just apply this myself.  But let me know if you'd prefer
> > >> to take it instead (considering that AES-GCM hasn't been librarified
> > >> yet).  Either way, there's no hurry, since this is targeting 6.19.
> > >>
> > >> Eric Biggers (8):
> > >>   crypto: x86/aes-gcm - add VAES+AVX2 optimized code
> > >>   crypto: x86/aes-gcm - remove VAES+AVX10/256 optimized code
> > >>   crypto: x86/aes-gcm - rename avx10 and avx10_512 to avx512
> > >>   crypto: x86/aes-gcm - clean up AVX512 code to assume 512-bit vectors
> > >>   crypto: x86/aes-gcm - reorder AVX512 precompute and aad_update
> > >>     functions
> > >>   crypto: x86/aes-gcm - revise some comments in AVX512 code
> > >>   crypto: x86/aes-gcm - optimize AVX512 precomputation of H^2 from H^1
> > >>   crypto: x86/aes-gcm - optimize long AAD processing with AVX512
> > >>
> > >>  arch/x86/crypto/Makefile                      |    5 +-
> > >>  arch/x86/crypto/aes-gcm-aesni-x86_64.S        |   12 +-
> > >>  arch/x86/crypto/aes-gcm-vaes-avx2.S           | 1150 +++++++++++++++++
> > >>  ...m-avx10-x86_64.S => aes-gcm-vaes-avx512.S} |  722 +++++------
> > >>  arch/x86/crypto/aesni-intel_glue.c            |  264 ++--
> > >>  5 files changed, 1667 insertions(+), 486 deletions(-)
> > >>  create mode 100644 arch/x86/crypto/aes-gcm-vaes-avx2.S
> > >>  rename arch/x86/crypto/{aes-gcm-avx10-x86_64.S => aes-gcm-vaes-avx512.S} (69%)
> > >>
> > >> base-commit: 3b9b1f8df454caa453c7fb07689064edb2eda90a
> > >
> > > Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-next
> >
> > Oops, I didn't see this email until it was too late.  Since the
> > patches should be identical I don't think it matters.

Well, it seems you didn't read the patchset (even the cover letter) or
any of the replies to it.  So maybe I should just take it, as I already
said I preferred, and later did do since you hadn't said you wanted to
take it.  It would have been okay if you had volunteered to take this,
but you need to actually read the patches and replies.

As for the patches being identical, besides correctly applying Ard's
tags, I made a couple very minor changes that weren't worth sending a v2
for: clarifying one of the commit messages, and correcting two comments
and dropping some unused aliases from aes-gcm-vaes-avx2.S.

- Eric
