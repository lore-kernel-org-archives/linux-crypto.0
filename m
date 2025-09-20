Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E34E4188CB1
	for <linux-crypto@vger.kernel.org>; Sat, 20 Sep 2025 13:20:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758374447; cv=none; b=AE/QQmVdesQ6IDWXth5mLDmJ6F/0OM3qkCrW42TmCtfmGOGIzmWHcG7+K+SkqqjKxXbAroU1iRS7qLunVIbsufSHxEfLymsVqIj3xiMZVO2glsY7Ptb4tW/fTlyi2QrvvKXDwSH7j257lx0tsrRfhttJ4OopnhZyNNN9cMFGEDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758374447; c=relaxed/simple;
	bh=TVKtdkDW5Bx9jo1qL5cjANuXuZINMtgj+qFgRNRgkrA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EwiRPW3mv7JOX8uqc1HHE+uDTO3MElUdOl7nZjBKOlVuMcWjWV2ItKqFiWalKmjh4TaE82OTzYV28Z0RV1a8SM0zPHlpoXlgJLlKfSH7V9Bm2lo3YHSvX7Xfuhn24vQTkCIBgkGX4hQwHB+kEdf1T3NdJSuNsrGqJGxB4Zllv54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Wq5e436H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Wq5e436H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88E47C113CF
	for <linux-crypto@vger.kernel.org>; Sat, 20 Sep 2025 13:20:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758374446;
	bh=TVKtdkDW5Bx9jo1qL5cjANuXuZINMtgj+qFgRNRgkrA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=Wq5e436H04RL6eIWDHxcufFHAJuaWfqpAzlKmc3eqM6yC/AlbnYkfdrkCmBYZeLI6
	 /QjLa0xTf88xp/wzEbevNrpcpiCOeMAfu7f8c+y5Ak3Azd3R26r445RTyu95eygZoE
	 R7ODanSAjN0ywnYFE6F/DctWH0HPHCKht8suixoxdf31bCLdVrvnvV9ON5EC5GMEed
	 RZWC4hP4muHVN2sJzQeG7wbs0Nho8nucBHdpC/nA4xOQI9Cpjrc8zDkttV237h2LpV
	 8i/ZzvvnKpce06XtzkhJVDM13FkNCKmFhZTRVT+5HRspuJdbaFXzaxAOU2Gu4k1P0k
	 RdZ0IyGaiL3jg==
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-578ecc56235so2331353e87.0
        for <linux-crypto@vger.kernel.org>; Sat, 20 Sep 2025 06:20:46 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCV5d2AUopRsDiAg67egk2ceygYdNCsL9cjZ1uaHLEFR9DJckRIPRfYTAvMco5l7H3aE5MXG/4+mqVA+6+c=@vger.kernel.org
X-Gm-Message-State: AOJu0YymBuX/4QoxHTNYJsRrTo2LaoEYozsE5tcuglUWfwKLoet1siB1
	D1XYyp0icyQpsK6dGwUn1cBeP7QSvyO3bsfbqW29/tKOraNNdDB82Ub5tWskpVZoi3sVmtzpNRZ
	wTZ0JgXOuNVyp+aCRGs4LRp61DiKAhlU=
X-Google-Smtp-Source: AGHT+IG1LfUXkrYBNfv5ScoJ3gEzekTWk3ybLBFirhAG7Q4onP+VqcdCQaeYnlnFTAzL/cIlQNiaBfKJ1gXwB5SZmOk=
X-Received: by 2002:a05:6512:6189:b0:571:369a:68bd with SMTP id
 2adb3069b0e04-579e0cb7047mr2382978e87.3.1758374444801; Sat, 20 Sep 2025
 06:20:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250918063539.2640512-7-ardb+git@google.com> <20250919193221.GB2249@quark>
 <202509192219.E69A1FDA5@keescook>
In-Reply-To: <202509192219.E69A1FDA5@keescook>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Sat, 20 Sep 2025 15:20:33 +0200
X-Gmail-Original-Message-ID: <CAMj1kXFtnDj-kDMPKfbj2hJ9FqVt17EstNSHbzfcmAAYZneS6g@mail.gmail.com>
X-Gm-Features: AS18NWAFCY8dWxTtxlBneqEoZTFZeASnTt4i57qY4hP6cK5XTVyGvIZt8tkXyfU
Message-ID: <CAMj1kXFtnDj-kDMPKfbj2hJ9FqVt17EstNSHbzfcmAAYZneS6g@mail.gmail.com>
Subject: Re: [PATCH 0/5] arm64: Move kernel mode FPSIMD buffer to the stack
To: Kees Cook <kees@kernel.org>
Cc: Eric Biggers <ebiggers@kernel.org>, Ard Biesheuvel <ardb+git@google.com>, 
	linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, herbert@gondor.apana.org.au, 
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Mark Brown <broonie@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Sat, 20 Sept 2025 at 08:42, Kees Cook <kees@kernel.org> wrote:
>
> On Fri, Sep 19, 2025 at 02:32:21PM -0500, Eric Biggers wrote:
> > On Thu, Sep 18, 2025 at 08:35:40AM +0200, Ard Biesheuvel wrote:
> > > From: Ard Biesheuvel <ardb@kernel.org>
> > >
> > > Move the buffer for preserving/restoring the kernel mode FPSIMD state on a
> > > context switch out of struct thread_struct, and onto the stack, so that
> > > the memory cost is not imposed needlessly on all tasks in the system.
> > >
> > > Patches #1 - #3 contains some prepwork so that patch #4 can tighten the
> > > rules around permitted usage patterns of kernel_neon_begin() and
> > > kernel_neon_end(). This permits #5 to provide a stack buffer to
> > > kernel_neon_begin() transparently, in a manner that ensures that it will
> > > remain available until after the associated call to kernel_neon_end()
> > > returns.
> > >
> > > Cc: Marc Zyngier <maz@kernel.org>
> > > Cc: Will Deacon <will@kernel.org>
> > > Cc: Mark Rutland <mark.rutland@arm.com>
> > > Cc: Kees Cook <keescook@chromium.org>
> > > Cc: Catalin Marinas <catalin.marinas@arm.com>
> > > Cc: Mark Brown <broonie@kernel.org>
> > >
> > > Ard Biesheuvel (5):
> > >   crypto/arm64: aes-ce-ccm - Avoid pointless yield of the NEON unit
> > >   crypto/arm64: sm4-ce-ccm - Avoid pointless yield of the NEON unit
> > >   crypto/arm64: sm4-ce-gcm - Avoid pointless yield of the NEON unit
> > >   arm64/fpsimd: Require kernel NEON begin/end calls from the same scope
> > >   arm64/fpsimd: Allocate kernel mode FP/SIMD buffers on the stack
> > >
> > >  arch/arm64/crypto/aes-ce-ccm-glue.c |  5 +--
> > >  arch/arm64/crypto/sm4-ce-ccm-glue.c | 10 ++----
> > >  arch/arm64/crypto/sm4-ce-gcm-glue.c | 10 ++----
> > >  arch/arm64/include/asm/neon.h       |  7 ++--
> > >  arch/arm64/include/asm/processor.h  |  2 +-
> > >  arch/arm64/kernel/fpsimd.c          | 34 +++++++++++++-------
> > >  6 files changed, 34 insertions(+), 34 deletions(-)
> >
> > This looks like the right decision: saving 528 bytes per task is
> > significant.  528 bytes is a lot to allocate on the stack too, but
> > functions that use the NEON registers are either leaf functions or very
> > close to being leaf functions, so it should be okay.
> >
> > The implementation is a bit unusual, though:
> >
> >    #define kernel_neon_begin()        do { __kernel_neon_begin(&(struct user_fpsimd_state){})
> >    #define kernel_neon_end()  __kernel_neon_end(); } while (0)
> >
> > It works, but normally macros don't start or end code blocks behind the
> > scenes like this.  Perhaps it should be more like s390's
> > kernel_fpu_begin(), where the caller provides the buffer that the
> > registers are stored in?
>
> We've done stuff like this in the past, but I did wonder if we could use
> any of the cleanup.h style logic to do this instead of the split
> do/while? I think this would work, totally untested:
>
> DEFINE_LOCK_GUARD_0(neon,
>                     __kernel_neon_begin(&(struct user_fpsimd_state){}),
>                     __kernel_neon_end())
> ...
> scoped_guard(neon) {
>         do neon things
> }
>
> It would require a fair bit of refactoring to replace the existing
> begin/end code, though...
>

Yeah, but I think it's worth it. And let's call it simd and reuse that
on other architectures as well.

The problem with the above, though, is that the temporary stack
variable goes out of scope when the constructor function returns. So
probably better to do something like

DEFINE_LOCK_GUARD_1(simd,
                    struct user_fpsimd_state,
                    __kernel_neon_begin(_T->lock),
                    __kernel_neon_end(_T->lock));

#define scoped_simd() scoped_guard(simd, &(struct user_fpsimd_state){})

leaving the possibility for callers to use scoped_guard() directly and
pass their own user_fpsimd_state pointer.

We'd need to add some debug checks in __kernel_neon_end() to ensure
that the provided pointer matches the one that was passed to
__kernel_neon_begin().
