Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70ABF186284
	for <linux-crypto@vger.kernel.org>; Thu,  2 Oct 2025 16:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759423927; cv=none; b=tasO6lz1VEbClZXcO2vBPsjIqPxVycWZbH6h9NpNQmY7HIbfhOBuJuGLG9x8wQBR4RyfiqsRd9dOxgruDpnMmBOrr0q9A+Z4+GbsTDNN9gTHrMWGu9YMMnPtFVqzHBQAbbE/Fj94C/6KaddSnkd4bmV2Rb8YBTfuCwI3n3qAzR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759423927; c=relaxed/simple;
	bh=RYUS76VlN/7kvtmsPptlWYP5PD2siFaw/m/pPf6KKBg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=POe1STBAJelYLWasHjfAgn2Dx0wJ8jyn5YLGwReWoJ1V9oc1nj/xBQ3qpLvBilNDgV/QGpNYuJ9MRdWgwXFQxQ91oqVUv1/fGmSvaCTFx3f+zG6tB9JSbQyYDyFM6JaoywAG9VNo2yyuXut0GQB6e8s0B7B0w3wvnydkRhlYL/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jP3BgZuP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jP3BgZuP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0399DC4CEFF
	for <linux-crypto@vger.kernel.org>; Thu,  2 Oct 2025 16:52:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759423927;
	bh=RYUS76VlN/7kvtmsPptlWYP5PD2siFaw/m/pPf6KKBg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=jP3BgZuPIcSMnUcMZX+zGGOZ4bci9SkVBh6qAlossuJFuETqNIvy2fQkb/E6AOjG2
	 B6X4EyyQqk6tyj+k35Jl5fvMbbeCucLL89tO8oZ2nIrcjDkj/4zRObaeLd2GKId8xB
	 3ewdNfSDZCzpowgdhOEaCx1ig9j/TtysCtg4woD+tw4U9BGyP+TOG1OkdKGVQ3N794
	 EoyrG6R5WJJicuHK4twz7z1orRs2uDZ3OZwHENgdVlQIzOA1wzpQjMeQgvzwWG5f2K
	 4v8cRFImwrUPk9xDWzwl7bFaFCffNvkrBfUt5ffZWunvD0alfmOwrOJGC6HebPP6tf
	 dUEYVhdnABQTA==
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-362acd22c78so11329891fa.2
        for <linux-crypto@vger.kernel.org>; Thu, 02 Oct 2025 09:52:06 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCV3dKy37JX+c3hGeAiPhWQjoFlPAkQ08lTr5CsQKxCkZQTPCufjY7HusUS5aomjkn0CMa12kYfzGAkvHrY=@vger.kernel.org
X-Gm-Message-State: AOJu0YwinXnW4G46NOKXGT20EWzj2Od6lc2af6Ex3QqHEXyldA6ypvxr
	kVdchIyVP/Xndoy+BJeejVSS6xM6rd9SuFpTYtkyeAwP/cq0qrnbrVKhOtmdd6ZOJyOggmSuP6X
	R/C4CPxdhPWRimWamN7P8YMxqk+iCOU0=
X-Google-Smtp-Source: AGHT+IFwsRonoEO2SfC5D66SL4gG4kGhHTi4f1/UhGxnb1sNM7Q1481/usK34L0kehPsH9mUQeXsHIp2ebOr5kpnvaA=
X-Received: by 2002:a2e:a90e:0:b0:36c:47c8:b618 with SMTP id
 38308e7fff4ca-373a7126ca6mr26591461fa.18.1759423925284; Thu, 02 Oct 2025
 09:52:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251001210201.838686-22-ardb+git@google.com> <20251001210201.838686-42-ardb+git@google.com>
 <202510020920.2FE08A4F90@keescook>
In-Reply-To: <202510020920.2FE08A4F90@keescook>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Thu, 2 Oct 2025 18:51:54 +0200
X-Gmail-Original-Message-ID: <CAMj1kXFN0Q8Rba7gdh9AF2SAyyZcNjX89L-GtQs5kbfZtneQzA@mail.gmail.com>
X-Gm-Features: AS18NWCS21HK8p5zowe1aZSwsKe2CzfUTcnx8DtpF0yJN4O90o1GiG6ggpAwDNk
Message-ID: <CAMj1kXFN0Q8Rba7gdh9AF2SAyyZcNjX89L-GtQs5kbfZtneQzA@mail.gmail.com>
Subject: Re: [PATCH v2 20/20] arm64/fpsimd: Allocate kernel mode FP/SIMD
 buffers on the stack
To: Kees Cook <kees@kernel.org>
Cc: Ard Biesheuvel <ardb+git@google.com>, linux-arm-kernel@lists.infradead.org, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	herbert@gondor.apana.org.au, linux@armlinux.org.uk, 
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Mark Brown <broonie@kernel.org>, 
	Eric Biggers <ebiggers@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Thu, 2 Oct 2025 at 18:22, Kees Cook <kees@kernel.org> wrote:
>
> On Wed, Oct 01, 2025 at 11:02:22PM +0200, Ard Biesheuvel wrote:
> > [...]
> > diff --git a/arch/arm64/include/asm/simd.h b/arch/arm64/include/asm/simd.h
> > index d9f83c478736..7ddb25df5c98 100644
> > --- a/arch/arm64/include/asm/simd.h
> > +++ b/arch/arm64/include/asm/simd.h
> > @@ -43,8 +43,11 @@ static __must_check inline bool may_use_simd(void) {
> >
> >  #endif /* ! CONFIG_KERNEL_MODE_NEON */
> >
> > -DEFINE_LOCK_GUARD_0(ksimd, kernel_neon_begin(), kernel_neon_end())
> > +DEFINE_LOCK_GUARD_1(ksimd,
> > +                 struct user_fpsimd_state,
> > +                 kernel_neon_begin(_T->lock),
> > +                 kernel_neon_end(_T->lock))
> >
> > -#define scoped_ksimd()       scoped_guard(ksimd)
> > +#define scoped_ksimd()       scoped_guard(ksimd, &(struct user_fpsimd_state){})
>
> I love it!
>
> > [...]
> > -void kernel_neon_end(void)
> > +void kernel_neon_end(struct user_fpsimd_state *s)
> >  {
> >       if (!system_supports_fpsimd())
> >               return;
> > @@ -1899,8 +1910,9 @@ void kernel_neon_end(void)
> >       if (!IS_ENABLED(CONFIG_PREEMPT_RT) && in_serving_softirq() &&
> >           test_thread_flag(TIF_KERNEL_FPSTATE))
> >               fpsimd_load_kernel_state(current);
> > -     else
> > -             clear_thread_flag(TIF_KERNEL_FPSTATE);
> > +     else if (test_and_clear_thread_flag(TIF_KERNEL_FPSTATE))
> > +             if (cmpxchg(&current->thread.kernel_fpsimd_state, s, NULL) != s)
> > +                     BUG();
>
> I always question BUG() uses -- is there a recoverable way to deal with
> a mismatch here? I assume not and that this is the best we can do, but I
> thought I'd just explicitly ask. :)
>

So this fires when kernel_neon_end() passes a different buffer than
the preceding kernel_neon_begin(), but the only purpose of passing it
twice is this particular check.

So perhaps this one can be demoted to a WARN() instead. The preceding
one will fire if kernel_neon_begin() is called and the recorded buffer
pointer is still set from a previous NEON block. Perhaps the same
applies there too: the warning is about something that already
happened, and we can actually proceed as usual.

TL;DR yes let's WARN() instead in both cases.
