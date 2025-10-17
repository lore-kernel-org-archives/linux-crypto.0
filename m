Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49D521D5CC6;
	Fri, 17 Oct 2025 20:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760734210; cv=none; b=d5GZsi3by+A5ZJ+m2/eH09lbOHR0tIFPMAHc7AWKrvZtyaPVZBuIjrANwMGV5Tb6ScNQ1g3UY3USZFBGOXj94k3ThOk8DXXbDboycPC7pV2Qmq9FElD5ahhERfgpmEusCAbSH+2hGzSh83dclVl/TyuuI1+FGDkQdD4cVvZx25g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760734210; c=relaxed/simple;
	bh=y9filx/ib83dvzxxqQeg2wIADdpOLjMgN0KWwMwZ5HA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MVo0tJBZEDa1EhROx2px2S/Z6r9vsOzTX2CLi/eUHdHSiJAkcHiIBRUdXl2P5Jq/DOuVtPV2C3UzF676Trj8osxbesjlmQ2JrALxaHXJz9xcJVDzHid5j/VnF40iM94D2wGfCUinQf42QsSD3BTErfrzPqyLLSSbQIcJGQnZ/o0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OH6RqLIF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OH6RqLIF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EB53C4CEE7;
	Fri, 17 Oct 2025 20:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760734208;
	bh=y9filx/ib83dvzxxqQeg2wIADdpOLjMgN0KWwMwZ5HA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OH6RqLIF0YP0/mCOCZopecGrUTpGDNN7vuh2fsWyatq/fBcFC6+Qo35veXQ5TiHPq
	 4mAr9rEDV4L6Ipvo4AKEs5FuhmQCeXZdEAZ13mYMW0JCNcZDkwlCVF87JXbemaCXQ/
	 nI3kTqTDDz1FxnlKm/gC8ZcXJqV3YBCAkkthSSVFOzx4Xp5E37xclRRC67VuQtlVD6
	 ovyxIKUm105PSuLkgVTKNx/rIKg7Mx7lAwpWS3tgkhsVkZ8hWs3iytMsheNu3GxnKl
	 ggJF+tKI1VGM2CLNUTxzQPgjFdnDQvHSiOQtTdYI0CjVSeeCLj0E+vDE0HhrtQEP/U
	 827hcejm+bV0A==
Date: Fri, 17 Oct 2025 20:50:06 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	linux-kernel@vger.kernel.org, x86@kernel.org, Jason@zx2c4.com
Subject: Re: [PATCH 0/8] VAES+AVX2 optimized implementation of AES-GCM
Message-ID: <20251017205006.GA769943@google.com>
References: <20251014003123.GA2763@sol>
 <aPH9ZQP0m8Pq5Iy-@gondor.apana.org.au>
 <CAMj1kXGE6-xiUSyKa92=HWeywt=5-F2_G2H7V-UnVhKG65zwCA@mail.gmail.com>
 <20251017160437.GA1566@sol>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251017160437.GA1566@sol>

On Fri, Oct 17, 2025 at 09:04:37AM -0700, Eric Biggers wrote:
> On Fri, Oct 17, 2025 at 10:44:37AM +0200, Ard Biesheuvel wrote:
> > On Fri, 17 Oct 2025 at 10:25, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> > >
> > > Eric Biggers <ebiggers@kernel.org> wrote:
> > > > On Wed, Oct 01, 2025 at 07:31:09PM -0700, Eric Biggers wrote:
> > > >> This patchset replaces the 256-bit vector implementation of AES-GCM for
> > > >> x86_64 with one that requires AVX2 rather than AVX512.  This greatly
> > > >> improves AES-GCM performance on CPUs that have VAES but not AVX512, for
> > > >> example by up to 74% on AMD Zen 3.  For more details, see patch 1.
> > > >>
> > > >> This patchset also renames the 512-bit vector implementation of AES-GCM
> > > >> for x86_64 to be named after AVX512 rather than AVX10/512, then adds
> > > >> some additional optimizations to it.
> > > >>
> > > >> This patchset applies to next-20250929 and is targeting 6.19.  Herbert,
> > > >> I'd prefer to just apply this myself.  But let me know if you'd prefer
> > > >> to take it instead (considering that AES-GCM hasn't been librarified
> > > >> yet).  Either way, there's no hurry, since this is targeting 6.19.
> > > >>
> > > >> Eric Biggers (8):
> > > >>   crypto: x86/aes-gcm - add VAES+AVX2 optimized code
> > > >>   crypto: x86/aes-gcm - remove VAES+AVX10/256 optimized code
> > > >>   crypto: x86/aes-gcm - rename avx10 and avx10_512 to avx512
> > > >>   crypto: x86/aes-gcm - clean up AVX512 code to assume 512-bit vectors
> > > >>   crypto: x86/aes-gcm - reorder AVX512 precompute and aad_update
> > > >>     functions
> > > >>   crypto: x86/aes-gcm - revise some comments in AVX512 code
> > > >>   crypto: x86/aes-gcm - optimize AVX512 precomputation of H^2 from H^1
> > > >>   crypto: x86/aes-gcm - optimize long AAD processing with AVX512
> > > >>
> > > >>  arch/x86/crypto/Makefile                      |    5 +-
> > > >>  arch/x86/crypto/aes-gcm-aesni-x86_64.S        |   12 +-
> > > >>  arch/x86/crypto/aes-gcm-vaes-avx2.S           | 1150 +++++++++++++++++
> > > >>  ...m-avx10-x86_64.S => aes-gcm-vaes-avx512.S} |  722 +++++------
> > > >>  arch/x86/crypto/aesni-intel_glue.c            |  264 ++--
> > > >>  5 files changed, 1667 insertions(+), 486 deletions(-)
> > > >>  create mode 100644 arch/x86/crypto/aes-gcm-vaes-avx2.S
> > > >>  rename arch/x86/crypto/{aes-gcm-avx10-x86_64.S => aes-gcm-vaes-avx512.S} (69%)
> > > >>
> > > >> base-commit: 3b9b1f8df454caa453c7fb07689064edb2eda90a
> > > >
> > > > Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-next
> > >
> > > Oops, I didn't see this email until it was too late.  Since the
> > > patches should be identical I don't think it matters.
> 
> Well, it seems you didn't read the patchset (even the cover letter) or
> any of the replies to it.  So maybe I should just take it, as I already
> said I preferred, and later did do since you hadn't said you wanted to
> take it.  It would have been okay if you had volunteered to take this,
> but you need to actually read the patches and replies.
> 
> As for the patches being identical, besides correctly applying Ard's
> tags, I made a couple very minor changes that weren't worth sending a v2
> for: clarifying one of the commit messages, and correcting two comments
> and dropping some unused aliases from aes-gcm-vaes-avx2.S.

And to be clear, these aren't going to go through two trees.  That would
be silly.  If you really want to take them after all, then ask me to
drop them first, and make sure to apply them properly with Acked-by and
Tested-by tags.  Otherwise, please drop your duplicate copy.

Thanks,

- Eric
