Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45C3D22FAFD
	for <linux-crypto@vger.kernel.org>; Sun,  7 Dec 2025 01:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765071009; cv=none; b=l//kLrilwr2JB+6gaYnXA5nuAJP0Futr78HNca35r+9/bm8uah+mXOQ6a3qmJXsxaHFVK1q0PqYJ+JE2khllPgQHEGyIIM4O1r+SYe85owU+biFm2+jYmQZsyRTUTHf2ap9w7cmeT8AJBiTkykePDHoABg/rNbCCo+VwpuqPjMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765071009; c=relaxed/simple;
	bh=luTJ5lrLTRUh8Mfjm+oJVKFh1qmU0F2FUn5WlWr3gS4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S3KSj4FBH3yZ52wjai04VZxYBrKYeY0larzQLm5YP/46xvJm3ce+M0cMdWdKDi62qv8JTaaQxzXndFb0cLQwdFUzNuEQFPbwAe99sEpZvScf1VpJgdFuBpJEcLDJ7ApwJtZbORwnw5DEzhITHtmZY7KrGtbluwsTGcsxLvrAeNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ESfNk8VQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ESfNk8VQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AAF2C4CEF5;
	Sun,  7 Dec 2025 01:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765071008;
	bh=luTJ5lrLTRUh8Mfjm+oJVKFh1qmU0F2FUn5WlWr3gS4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ESfNk8VQ2zVdfYywnT2lDftMq6h97fdH/q3Kus1zm6VptRZgJNepqwzxwxXLquS2E
	 Flkdson3CAJIBWDQDeqY7o6QDjGAownr2asmipaCpBwZLfopGEHFX6EX5yZV8g8C+3
	 JJbT90yEKFLif+HzJ2fcyMu6BuzW+ApatZiy+ViJEtUXsbPFeceVg1NHoOCNquXyn3
	 yJfqrfa5VBebvOMNDYk/qkiig5EuCOj/kM3HIrw3k18vTIusI7Ivjre9Uc9O+aeUnc
	 qIrd1ZwonAdlNUrFs79dQv8t2abUvi5mUUavSUrorlwQqmPG7Kbg6X9e/DANz3KwcU
	 jipQ9m76RrJpg==
Date: Sat, 6 Dec 2025 17:30:04 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Kees Cook <keescook@chromium.org>,
	Justin Stitt <justinstitt@google.com>
Subject: Re: [PATCH] arm64/simd: Avoid pointless clearing of FP/SIMD buffer
Message-ID: <20251207013004.GA143349@sol>
References: <20251204162815.522879-2-ardb@kernel.org>
 <20251205064809.GA26371@sol>
 <CAMj1kXE8qn7MSY1A31CrHRSxw+NXqNGLo=FLo4D-COMhxPAMiw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXE8qn7MSY1A31CrHRSxw+NXqNGLo=FLo4D-COMhxPAMiw@mail.gmail.com>

On Fri, Dec 05, 2025 at 09:13:46AM +0100, Ard Biesheuvel wrote:
> On Fri, 5 Dec 2025 at 07:50, Eric Biggers <ebiggers@kernel.org> wrote:
> >
> > On Thu, Dec 04, 2025 at 05:28:15PM +0100, Ard Biesheuvel wrote:
> > > The buffer provided to kernel_neon_begin() is only used if the task is
> > > scheduled out while the FP/SIMD is in use by the kernel, or when such a
> > > section is interrupted by a softirq that also uses the FP/SIMD.
> > >
> > > IOW, this happens rarely, and even if it happened often, there is still
> > > no reason for this buffer to be cleared beforehand, which happens by
> > > default when using a compiler that supports -ftrivial-auto-var-init.
> > >
> > > So mark the buffer as __uninitialized. Given that this is a variable
> > > attribute not a type attribute, this requires that the expression is
> > > tweaked a bit.
> > >
> > > Cc: Will Deacon <will@kernel.org>,
> > > Cc: Catalin Marinas <catalin.marinas@arm.com>,
> > > Cc: Kees Cook <keescook@chromium.org>
> > > Cc: Eric Biggers <ebiggers@kernel.org>
> > > Cc: Justin Stitt <justinstitt@google.com>
> > > Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> > > ---
> > >  arch/arm64/include/asm/simd.h | 3 ++-
> > >  1 file changed, 2 insertions(+), 1 deletion(-)
> > >
> > > The issue here is that returning a pointer to an automatic variable as
> > > it goes out of scope is slightly dodgy, especially in the context of
> > > __attribute__((cleanup())), on which the scoped guard API relies
> > > heavily. However, in this case it should be safe, given that this
> > > expression is the input to the guarded variable type's constructor.
> > >
> > > It is definitely not pretty, though, so hopefully here is a better way
> > > to attach this.
> > >
> > > diff --git a/arch/arm64/include/asm/simd.h b/arch/arm64/include/asm/simd.h
> > > index 0941f6f58a14..825b7fe94003 100644
> > > --- a/arch/arm64/include/asm/simd.h
> > > +++ b/arch/arm64/include/asm/simd.h
> > > @@ -48,6 +48,7 @@ DEFINE_LOCK_GUARD_1(ksimd,
> > >                   kernel_neon_begin(_T->lock),
> > >                   kernel_neon_end(_T->lock))
> > >
> > > -#define scoped_ksimd()       scoped_guard(ksimd, &(struct user_fpsimd_state){})
> > > +#define scoped_ksimd()       \
> > > +     scoped_guard(ksimd, ({ struct user_fpsimd_state __uninitialized s; &s; }))
> >
> > Ick.  I should have looked at the generated code more closely.
> >
> > It's actually worse than you describe, because the zeroing is there even
> > without CONFIG_INIT_STACK_ALL_ZERO=y, simply because the
> > user_fpsimd_state struct is declared using a compound literal.
> >
> > I'm afraid that this patch probably isn't a good idea, as it relies on
> > undefined behavior.  Before this patch, the user_fpsimd_state is
> > declared using a compound literal, which takes on its enclosing scope,
> > i.e. the 'for' statement generated by scoped_guard().  After this patch,
> > it's in a new inner scope, and the pointer to it escapes from it.
> >
> > Unfortunately I don't think there's any way to solve this while keeping
> > the scoped_ksimd() API as-is.
> >
> 
> How about
> 
> --- a/arch/arm64/include/asm/simd.h
> +++ b/arch/arm64/include/asm/simd.h
> @@ -48,6 +48,8 @@ DEFINE_LOCK_GUARD_1(ksimd,
>                     kernel_neon_begin(_T->lock),
>                     kernel_neon_end(_T->lock))
> 
> -#define scoped_ksimd() scoped_guard(ksimd, &(struct user_fpsimd_state){})
> +#define scoped_ksimd()         __scoped_ksimd(__UNIQUE_ID(fpsimd_state))
> +#define __scoped_ksimd(id)     struct user_fpsimd_state __uninitialized id; \
> +                               scoped_guard(ksimd, &id)

I guess that will work.  It's not great that it will make scoped_ksimd()
expand into more than one statement, which is error-prone and not
normally allowed in macros.  But it looks okay for all the current users
of it.

- Eric
