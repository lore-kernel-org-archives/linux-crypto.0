Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D237831D38E;
	Mon,  3 Nov 2025 18:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762196102; cv=none; b=NvPdYGWvcSJ4ZSsPkl05mHK/oSkCQpcXG0/8vPaRna/M3qXPWWDuIi7N6xGTTvYd0lR1xxmLcLxXqXJRyq2WNl/vp6z/P76YUO5gkV96eqNghy2q5goH9EQGgTQ4mbl5/hO+OCr5N1UzfA+LfX721hOcgW5QZtLrjGcnHemOEjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762196102; c=relaxed/simple;
	bh=aw8ObmXZNduPQmQUrUChN4M1KdT751Q0ihiiVsS19JU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YWlflpSWyRHr8ZKkaqnLZnKAE9Xz9fov9bFCed2OX0s9zCxOkWqxRYYzouVEEx2CJaSg1Tghtqg1vZbX2y7XrloiPi32Xhkug96cYDOcpT3kHW8zl+j6ZaSnvNS2FaMUB/tKo9mOF8kLKHtcdGe7JqmDD3s4ij5HG2XlWDtOzVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SSNeJWv1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SSNeJWv1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 203E4C4CEE7;
	Mon,  3 Nov 2025 18:55:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762196102;
	bh=aw8ObmXZNduPQmQUrUChN4M1KdT751Q0ihiiVsS19JU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SSNeJWv1o3cfi20PnDObB6XC/Azw0OFWtgIF61Opd4jSN42K0a0/sgRPiwnHb/7ml
	 WLFe1TVuIdXzbcLWjYaQ6y9UXhTsDeW9yldoLMn2qFHftZWAqAoOxOydW3Fb/dljrK
	 9SCcZecd2QwZuvGm5aZ9soQinKRfRe4/oPQKmk/bpULis+BEi4VmOWMys1nyCvcgGb
	 GqrSRoMrzdMXnAUqRrM6XPkTCSU+Jl2kSGFoQJVTyZMbMeUn/EAMGyVbRb0e88LcM9
	 j5opEPaM5rR6tkP65IEGsYb6kq79qKySVeIqXv7Qrc/PlA9mY+MKifd3y9q92sD9sB
	 moDQiuScEfllg==
Date: Mon, 3 Nov 2025 18:55:00 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Nathan Chancellor <nathan@kernel.org>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] lib/crypto: curve25519-hacl64: Fix older clang KASAN
 workaround for GCC
Message-ID: <20251103185500.GA3953783@google.com>
References: <20251102-curve25519-hacl64-fix-kasan-workaround-v1-1-6ec6738f9741@kernel.org>
 <20251103170036.GD1735@sol>
 <20251103184846.GA672460@ax162>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251103184846.GA672460@ax162>

On Mon, Nov 03, 2025 at 11:48:46AM -0700, Nathan Chancellor wrote:
> On Mon, Nov 03, 2025 at 09:00:36AM -0800, Eric Biggers wrote:
> > On Sun, Nov 02, 2025 at 09:35:03PM -0500, Nathan Chancellor wrote:
> > > Commit 2f13daee2a72 ("lib/crypto/curve25519-hacl64: Disable KASAN with
> > > clang-17 and older") inadvertently disabled KASAN in curve25519-hacl64.o
> > > for GCC unconditionally because clang-min-version will always evaluate
> > > to nothing for GCC. Add a check for CONFIG_CC_IS_GCC to avoid the
> > > workaround, which is only needed for clang-17 and older.
> > > 
> > > Additionally, invert the 'ifeq (...,)' into 'ifneq (...,y)', as it is a
> > > little easier to read and understand the intention ("if not GCC or at
> > > least clang-18, disable KASAN").
> > > 
> > > Cc: stable@vger.kernel.org
> > > Fixes: 2f13daee2a72 ("lib/crypto/curve25519-hacl64: Disable KASAN with clang-17 and older")
> > > Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> > > ---
> > >  lib/crypto/Makefile | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/lib/crypto/Makefile b/lib/crypto/Makefile
> > > index bded351aeace..372b7a12b371 100644
> > > --- a/lib/crypto/Makefile
> > > +++ b/lib/crypto/Makefile
> > > @@ -90,7 +90,7 @@ else
> > >  libcurve25519-$(CONFIG_CRYPTO_LIB_CURVE25519_GENERIC) += curve25519-fiat32.o
> > >  endif
> > >  # clang versions prior to 18 may blow out the stack with KASAN
> > > -ifeq ($(call clang-min-version, 180000),)
> > > +ifneq ($(CONFIG_CC_IS_GCC)$(call clang-min-version, 180000),y)
> > >  KASAN_SANITIZE_curve25519-hacl64.o := n
> > >  endif
> > 
> > Thanks for catching this!
> > 
> > Using CONFIG_CC_IS_GCC == "" to check for clang seems a bit odd when
> > there's already a CONFIG_CC_IS_CLANG available.
> > 
> > How about we do it like this?
> > 
> >     ifeq ($(CONFIG_CC_IS_CLANG)_$(call clang-min-version, 180000),y_)
> 
> Yeah, I am not really sure why I was being so cryptic with the original
> way it was written :) I think it made a little more sense when it was
> 'ifeq'. Technically we could do without the _ but would you prefer that
> I keep it? I can send a v2 with whatever you prefer and an updated
> commit message.

While it shouldn't be possible to have a y just from the second part, I
think I'd prefer still having the separator so that it's clear which
part the y is coming from.

- Eric
