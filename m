Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5172028467B;
	Sat, 20 Sep 2025 06:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758350555; cv=none; b=eN2z1+SAGU4i7TefmSG3A0PkpkNQs3qrVUgMwGPcueJgxx2RgBTq/NceZhv1rNQxM2dfQAg3fS9ASLrF+fAW7qzaRKq1yP4MHMRPioSIYCvYh9LOMqnemwn63QPceyFQ/ZyYWcbTV0Nzdop2oX3ZO/9UW1Oq5iDAu4HXL+WYTMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758350555; c=relaxed/simple;
	bh=5e3PO9sm0kwZZFFmVI0IYn8SvQHCwKEdjnXvKF3BC1w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Jrmspa82sxoTdZ+mAeC0oisn5sBdQqjFgznRCtaxRHFFZ44od0facHpSsR6jj+RtU0SoOtP9lu7bpsV/RyejmqzLGW5tJpPU7lx+ZGj+UBUtsZVTqcCPM2Ot4PyJmKaQbX5zZE4WEvu0BN0T0APjuV6a5C8jksvoNuKb/ZM8nB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eiOL+rYt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eiOL+rYt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD0AAC4CEEB;
	Sat, 20 Sep 2025 06:42:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758350554;
	bh=5e3PO9sm0kwZZFFmVI0IYn8SvQHCwKEdjnXvKF3BC1w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eiOL+rYtzseHizgBdLkpV2WcDHnv5fPjcfRCjLBfHzSWkBN2a3KsMopc9Fd3QCDyS
	 hyC2JVsFh17sKWtgyDvpZilU1KS5EoWJWJjBh/m0H3YNZcNN+7JTqO8doM3uZY1sGF
	 jtvXkUyHtqjGr6GycW2lX6PRYTtfh+UlTo0sAxQeTdhwXbUJZOY/DeScAgZjvg73Fp
	 6GUx0bpmnmzhEFVOWVZY5BOsXxnjhBYIVbucc46xNnKMimf3wovh53geDfnK4Le472
	 tWR0FsvSzrcktUaOuDdqBrho02HmoWK5pvp8Fzn4zntrrZJ/GV7y68PKj6X+LWkZCf
	 yZz/w3g0W0egg==
Date: Fri, 19 Sep 2025 23:42:34 -0700
From: Kees Cook <kees@kernel.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Ard Biesheuvel <ardb+git@google.com>,
	linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, herbert@gondor.apana.org.au,
	Ard Biesheuvel <ardb@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH 0/5] arm64: Move kernel mode FPSIMD buffer to the stack
Message-ID: <202509192219.E69A1FDA5@keescook>
References: <20250918063539.2640512-7-ardb+git@google.com>
 <20250919193221.GB2249@quark>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250919193221.GB2249@quark>

On Fri, Sep 19, 2025 at 02:32:21PM -0500, Eric Biggers wrote:
> On Thu, Sep 18, 2025 at 08:35:40AM +0200, Ard Biesheuvel wrote:
> > From: Ard Biesheuvel <ardb@kernel.org>
> > 
> > Move the buffer for preserving/restoring the kernel mode FPSIMD state on a
> > context switch out of struct thread_struct, and onto the stack, so that
> > the memory cost is not imposed needlessly on all tasks in the system.
> > 
> > Patches #1 - #3 contains some prepwork so that patch #4 can tighten the
> > rules around permitted usage patterns of kernel_neon_begin() and
> > kernel_neon_end(). This permits #5 to provide a stack buffer to
> > kernel_neon_begin() transparently, in a manner that ensures that it will
> > remain available until after the associated call to kernel_neon_end()
> > returns.
> > 
> > Cc: Marc Zyngier <maz@kernel.org>
> > Cc: Will Deacon <will@kernel.org>
> > Cc: Mark Rutland <mark.rutland@arm.com>
> > Cc: Kees Cook <keescook@chromium.org>
> > Cc: Catalin Marinas <catalin.marinas@arm.com>
> > Cc: Mark Brown <broonie@kernel.org>
> > 
> > Ard Biesheuvel (5):
> >   crypto/arm64: aes-ce-ccm - Avoid pointless yield of the NEON unit
> >   crypto/arm64: sm4-ce-ccm - Avoid pointless yield of the NEON unit
> >   crypto/arm64: sm4-ce-gcm - Avoid pointless yield of the NEON unit
> >   arm64/fpsimd: Require kernel NEON begin/end calls from the same scope
> >   arm64/fpsimd: Allocate kernel mode FP/SIMD buffers on the stack
> > 
> >  arch/arm64/crypto/aes-ce-ccm-glue.c |  5 +--
> >  arch/arm64/crypto/sm4-ce-ccm-glue.c | 10 ++----
> >  arch/arm64/crypto/sm4-ce-gcm-glue.c | 10 ++----
> >  arch/arm64/include/asm/neon.h       |  7 ++--
> >  arch/arm64/include/asm/processor.h  |  2 +-
> >  arch/arm64/kernel/fpsimd.c          | 34 +++++++++++++-------
> >  6 files changed, 34 insertions(+), 34 deletions(-)
> 
> This looks like the right decision: saving 528 bytes per task is
> significant.  528 bytes is a lot to allocate on the stack too, but
> functions that use the NEON registers are either leaf functions or very
> close to being leaf functions, so it should be okay.
> 
> The implementation is a bit unusual, though:
> 
>    #define kernel_neon_begin()	do { __kernel_neon_begin(&(struct user_fpsimd_state){})
>    #define kernel_neon_end()	__kernel_neon_end(); } while (0)
> 
> It works, but normally macros don't start or end code blocks behind the
> scenes like this.  Perhaps it should be more like s390's
> kernel_fpu_begin(), where the caller provides the buffer that the
> registers are stored in?  

We've done stuff like this in the past, but I did wonder if we could use
any of the cleanup.h style logic to do this instead of the split
do/while? I think this would work, totally untested:

DEFINE_LOCK_GUARD_0(neon,
		    __kernel_neon_begin(&(struct user_fpsimd_state){}),
		    __kernel_neon_end())
...
scoped_guard(neon) {
	do neon things
}

It would require a fair bit of refactoring to replace the existing
begin/end code, though...

-- 
Kees Cook
