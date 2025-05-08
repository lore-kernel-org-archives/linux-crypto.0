Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FD831E3DDB
	for <linux-crypto@vger.kernel.org>; Thu,  8 May 2025 16:05:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746720329; cv=none; b=DQNzAprpstTI6/xFGCZ1R7fXASJMDCfyK5A4AsJAaTyG/8aJ5BoBrhVJu0Jle1t5HcgDM75hPs5yNEC93M3OguPrO9TcSMXoFpjYTLY+B43YxQb1Q6+OiuoL8ldj9KAKCWSzBgAXCpF6E1C3HXJkBFLgJHypImq0mPv16PcMj2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746720329; c=relaxed/simple;
	bh=J0X9z5gm3wvXLSCUikMhZwi6A4FiSBZCE2jsWgwUZ6g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HzVWS+ncOBAoTTzq5mzoUTtFM932747qLP62OaxRgpPKsvoLrHlzNEQJkd6zf4WT+443bkwTrwqcvcsFv91V0azC/vWBkcItXI5gTXcAOaRkvNXZgdWUWpsbdRTHj2TRUjPnTBco4iKm2GnkgMI0QlReBtD9CTJ+NPWR//tTVew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p4BRA9kj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p4BRA9kj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5404BC4CEE7;
	Thu,  8 May 2025 16:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746720328;
	bh=J0X9z5gm3wvXLSCUikMhZwi6A4FiSBZCE2jsWgwUZ6g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=p4BRA9kjBZ2Yr8JFJ2Zxt9LQJ/16p0h//TN9xBYFBkFBzKBlU72GmrBqo7PMncvQO
	 dfqJhQ99KMH86ehTzXEwQl3XP3qaXtied0RcBCOblyGuoRidodB6+JzE9fZZaZXnb4
	 AuxBUeEicUnB53y/3d9RYoeD2ZcFs/zrN2YCOWg+41bd7KT88JwNrMDryiQizP0Lvv
	 hA1w30YJA1/8IUkLE3Ei3pMUQOe1HfuePHQIVQyG0he0Z2mtqs59Lo4lNdB1oR2Z/D
	 86wiNCY6l09iRnln6z4IBVDv+Wne+7HO7vCih0o71kzqLeDrmoXm1+7+g9P1KC2ULj
	 iFVYxozQLoiHQ==
Date: Thu, 8 May 2025 09:05:23 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	Thorsten Leemhuis <linux@leemhuis.info>,
	kernel test robot <lkp@intel.com>
Subject: Re: [PATCH] crypto: arm64/sha256 - fix build when
 CONFIG_PREEMPT_VOLUNTARY=y
Message-ID: <20250508160523.GA1218@sol>
References: <20250507170901.151548-1-ebiggers@kernel.org>
 <CAMj1kXEPvPKg3i9NkaYN+m4pGfw6P05g-H6_Dmb3AsQyRmU7MA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXEPvPKg3i9NkaYN+m4pGfw6P05g-H6_Dmb3AsQyRmU7MA@mail.gmail.com>

On Thu, May 08, 2025 at 01:12:28PM +0200, Ard Biesheuvel wrote:
> On Wed, 7 May 2025 at 19:09, Eric Biggers <ebiggers@kernel.org> wrote:
> >
> > From: Eric Biggers <ebiggers@google.com>
> >
> > Fix the build of sha256-ce.S when CONFIG_PREEMPT_VOLUNTARY=y by passing
> > the correct label to the cond_yield macro.  Also adjust the code to
> > execute only one branch instruction when CONFIG_PREEMPT_VOLUNTARY=n.
> >
> > Fixes: 6e36be511d28 ("crypto: arm64/sha256 - implement library instead of shash")
> > Reported-by: kernel test robot <lkp@intel.com>
> > Closes: https://lore.kernel.org/oe-kbuild-all/202505071811.yYpLUbav-lkp@intel.com/
> > Signed-off-by: Eric Biggers <ebiggers@google.com>
> > ---
> >  arch/arm64/lib/crypto/sha256-ce.S | 7 ++++---
> >  1 file changed, 4 insertions(+), 3 deletions(-)
> >
> > diff --git a/arch/arm64/lib/crypto/sha256-ce.S b/arch/arm64/lib/crypto/sha256-ce.S
> > index a8461d6dad634..f3e21c6d87d2e 100644
> > --- a/arch/arm64/lib/crypto/sha256-ce.S
> > +++ b/arch/arm64/lib/crypto/sha256-ce.S
> > @@ -121,14 +121,15 @@ CPU_LE(   rev32           v19.16b, v19.16b        )
> >
> >         /* update state */
> >         add             dgav.4s, dgav.4s, dg0v.4s
> >         add             dgbv.4s, dgbv.4s, dg1v.4s
> >
> > +       /* return early if voluntary preemption is needed */
> > +       cond_yield      1f, x5, x6
> > +
> 
> This will yield needlessly when the condition hits during the final iteration.
> 
> >         /* handled all input blocks? */
> > -       cbz             x2, 1f
> > -       cond_yield      3f, x5, x6
> > -       b               0b
> > +       cbnz            x2, 0b

cond_yield doesn't actually yield, though.  It just checks whether yielding is
needed.  So the behavior is the same: on the last iteration this function
returns 0 (i.e. 0 blocks remaining), regardless of whether it gets to the end by
jumping there due to TSK_TI_PREEMPT being set or by falling through after seeing
nblocks==0.  We could keep the nblocks==0 check first, but the cond_yield check
is lightweight and it's probably better to avoid the extra branch instruction on
every other iteration.

- Eric
