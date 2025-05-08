Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42E26253939
	for <linux-crypto@vger.kernel.org>; Thu,  8 May 2025 16:16:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746721013; cv=none; b=QUJgqR9eVZ9zhWQjdc4Mi4xoBwiqUcUndsGecy9L//AVelk1RTs56t14PqMi+m+GjUihhB0oVM41w5KkB5vg4Ty0/O+66eEZyqxcEBRu1Qbi8COWqCN88DF5W9ZJZul3YS2HiVbIMRSc20voS8uA+MX66KOX3utdpKPSavHNGEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746721013; c=relaxed/simple;
	bh=35IHPZXcocv+INe2DtbwMIQJtEhAwB7A8dA0hXmP7ZU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WV6r1n49SRPoZgzf0n82D9tIa+Kj71PlJGjgZTYCIZpgpXX8PNCj6SU6yyknudw3lm6+DIarJhCBFOwCWKyA2dAgufyZl9zIulxHhCJD0n6Er91AwFlM1hpLoGr6Ou1jSusEvGQjDI9vEoWRJIzXO1ACqUhjSUHKpXPAspT/JeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c1Yypr+S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c1Yypr+S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD8C3C4CEE7
	for <linux-crypto@vger.kernel.org>; Thu,  8 May 2025 16:16:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746721012;
	bh=35IHPZXcocv+INe2DtbwMIQJtEhAwB7A8dA0hXmP7ZU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=c1Yypr+SXFpXjPCoL+lIj05HB3FKq1nH4hrD90x3zoujZlSRsureyk3YUY5UUkbsS
	 e9sf0PlV77Ki1TrdpnHITuNQ4fePPVIbNAOfHpYo3I3gsx/Wxeee2lt/O43V5Z2Ang
	 jIMUQUa+H+jq0cFtftkb/ApwoAXraai0zLggeKekP3Oz8fudiASyZkwtB59IJkHesW
	 T1lo/WQXnQGsOwco4QThqKaYuk/NJAE4BjVcyzlGAX1OksK6SpSBT5nbJXLJnVJxy8
	 NZ88u92xCye20Wp6GaIhbBvQNF+H3pnT3imRdRNs+P2WBO8cqYwRszn0SQa5MmRwxU
	 ti+IHLqXHqqIg==
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-54298ec925bso1796863e87.3
        for <linux-crypto@vger.kernel.org>; Thu, 08 May 2025 09:16:52 -0700 (PDT)
X-Gm-Message-State: AOJu0YyeV7q41pa3uLIik90SGyWPcAhKFyuqRDO1KDtynyb4LzY98ab8
	JVGOhNoTYgxG8WF6Ef41L6A82PrK1TZUswr0jRMe443lRnavmyzQqefyWfRUW2nTSl5kp/0yxST
	o+b1T2sWYbItwKfVM0I7ur0JRo8I=
X-Google-Smtp-Source: AGHT+IFKz/ckT5Zb25NskasD9LKoDkkk10cz44ASE2I4Z+LtrM0t4fPT/Y/KGywhIG6AQHLqxj9ENJIrEaHfPC+fO6A=
X-Received: by 2002:ac2:4c4c:0:b0:54d:65cb:6c28 with SMTP id
 2adb3069b0e04-54fbfc0c942mr1515401e87.9.1746721011096; Thu, 08 May 2025
 09:16:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250507170901.151548-1-ebiggers@kernel.org> <CAMj1kXEPvPKg3i9NkaYN+m4pGfw6P05g-H6_Dmb3AsQyRmU7MA@mail.gmail.com>
 <20250508160523.GA1218@sol>
In-Reply-To: <20250508160523.GA1218@sol>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Thu, 8 May 2025 18:16:40 +0200
X-Gmail-Original-Message-ID: <CAMj1kXGH8mGbw8HtP_zW+JPHrV8vyk8N0hoaLTKChmsxz1qRvQ@mail.gmail.com>
X-Gm-Features: ATxdqUHiore7uw6Nb04dKvam7g-4ZOS_P4_x-pgXSnplyh0XT1bktUC_VERVSgQ
Message-ID: <CAMj1kXGH8mGbw8HtP_zW+JPHrV8vyk8N0hoaLTKChmsxz1qRvQ@mail.gmail.com>
Subject: Re: [PATCH] crypto: arm64/sha256 - fix build when CONFIG_PREEMPT_VOLUNTARY=y
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	Thorsten Leemhuis <linux@leemhuis.info>, kernel test robot <lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, 8 May 2025 at 18:05, Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Thu, May 08, 2025 at 01:12:28PM +0200, Ard Biesheuvel wrote:
> > On Wed, 7 May 2025 at 19:09, Eric Biggers <ebiggers@kernel.org> wrote:
> > >
> > > From: Eric Biggers <ebiggers@google.com>
> > >
> > > Fix the build of sha256-ce.S when CONFIG_PREEMPT_VOLUNTARY=y by passing
> > > the correct label to the cond_yield macro.  Also adjust the code to
> > > execute only one branch instruction when CONFIG_PREEMPT_VOLUNTARY=n.
> > >
> > > Fixes: 6e36be511d28 ("crypto: arm64/sha256 - implement library instead of shash")
> > > Reported-by: kernel test robot <lkp@intel.com>
> > > Closes: https://lore.kernel.org/oe-kbuild-all/202505071811.yYpLUbav-lkp@intel.com/
> > > Signed-off-by: Eric Biggers <ebiggers@google.com>
> > > ---
> > >  arch/arm64/lib/crypto/sha256-ce.S | 7 ++++---
> > >  1 file changed, 4 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/arch/arm64/lib/crypto/sha256-ce.S b/arch/arm64/lib/crypto/sha256-ce.S
> > > index a8461d6dad634..f3e21c6d87d2e 100644
> > > --- a/arch/arm64/lib/crypto/sha256-ce.S
> > > +++ b/arch/arm64/lib/crypto/sha256-ce.S
> > > @@ -121,14 +121,15 @@ CPU_LE(   rev32           v19.16b, v19.16b        )
> > >
> > >         /* update state */
> > >         add             dgav.4s, dgav.4s, dg0v.4s
> > >         add             dgbv.4s, dgbv.4s, dg1v.4s
> > >
> > > +       /* return early if voluntary preemption is needed */
> > > +       cond_yield      1f, x5, x6
> > > +
> >
> > This will yield needlessly when the condition hits during the final iteration.
> >
> > >         /* handled all input blocks? */
> > > -       cbz             x2, 1f
> > > -       cond_yield      3f, x5, x6
> > > -       b               0b
> > > +       cbnz            x2, 0b
>
> cond_yield doesn't actually yield, though.  It just checks whether yielding is
> needed.  So the behavior is the same: on the last iteration this function
> returns 0 (i.e. 0 blocks remaining), regardless of whether it gets to the end by
> jumping there due to TSK_TI_PREEMPT being set or by falling through after seeing
> nblocks==0.  We could keep the nblocks==0 check first, but the cond_yield check
> is lightweight and it's probably better to avoid the extra branch instruction on
> every other iteration.
>

Ah yes, you're right.

Hopefully we'll soon be able to get rid of it entirely.
