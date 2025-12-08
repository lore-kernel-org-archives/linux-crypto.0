Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F7CF1FF7C8
	for <linux-crypto@vger.kernel.org>; Mon,  8 Dec 2025 23:24:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765236264; cv=none; b=m447m5ktlQzvTviG9Dj2xKcuVRHqv8c8kLK2uDQsB9fO1qhtJAZ8sXW+gIqr+sv7b/JmHZmoYYcx9E5LQzk5yuTYpFQH0JWJZtESm2kArMQt0OkQ30F6E7Tu+HU6MB+w5nCQaoZg3nJ0xXtcLZ6o35ItUxoluabxdKnyhC+VcMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765236264; c=relaxed/simple;
	bh=daj4a+uPh2c3Xc1peJSyoolEr/C456XKe1rbcDZ5X1M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q+upqn1Vtdx9mMx+zLy6mzWJb0QmAPRF07JsKJbnEkgiQq+Ko8/Lz206o4DlltzavstuubvGI20g7w116w1pDCoV7YIrv8D84CMjY5naMImfjmtjE96DSmmToH7jhbt0Dj5Bq29aBum8jZ2oRDvJfTebcWQr2dSqS00FIymFAto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qXVkIrQD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qXVkIrQD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2066C4CEF1;
	Mon,  8 Dec 2025 23:24:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765236264;
	bh=daj4a+uPh2c3Xc1peJSyoolEr/C456XKe1rbcDZ5X1M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qXVkIrQDnUiIaSTr2epUv+ZU7vnvWAdFM2RqZEJBw/22zwN+jZrKlW0fFRPxXpJra
	 RiDd5jxWnpd+3M3yIegWiH1x++iYyzhIpLb9ZYyzIMp00ppL9+RsJX/8WLncIBkNmp
	 eJxlvyaH1MFTqnrgFy1L4jXlWdTG97zRN5vAZPzHMIA5ZDalB8EG3FtzCL4lv/bqeV
	 fG+3fUC4hnptJDxbrKj5rmcUiAm7mHazHoyoYhTK3wTsNTXa8FIf4UopZzX0YltFYA
	 IDUxdUuS9w8CgxPf/rh/CpwaTyxdaOa843UlrF54U70PPAqACa/1Eg/pyuasA1Q/eo
	 kh6xgeuY2zi9A==
Date: Mon, 8 Dec 2025 15:24:22 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Kees Cook <keescook@chromium.org>,
	Justin Stitt <justinstitt@google.com>
Subject: Re: [PATCH] arm64/simd: Avoid pointless clearing of FP/SIMD buffer
Message-ID: <20251208232422.GD1853@quark>
References: <20251204162815.522879-2-ardb@kernel.org>
 <20251205064809.GA26371@sol>
 <CAMj1kXE8qn7MSY1A31CrHRSxw+NXqNGLo=FLo4D-COMhxPAMiw@mail.gmail.com>
 <20251207013004.GA143349@sol>
 <CAMj1kXEWYQYW92=yRG6sJmmrjc8MBz-fdauxX2pq+P2rKhcxmg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXEWYQYW92=yRG6sJmmrjc8MBz-fdauxX2pq+P2rKhcxmg@mail.gmail.com>

On Sun, Dec 07, 2025 at 10:59:29AM +0100, Ard Biesheuvel wrote:
> On Sun, 7 Dec 2025 at 02:30, Eric Biggers <ebiggers@kernel.org> wrote:
> >
> > On Fri, Dec 05, 2025 at 09:13:46AM +0100, Ard Biesheuvel wrote:
> > > On Fri, 5 Dec 2025 at 07:50, Eric Biggers <ebiggers@kernel.org> wrote:
> > > >
> > > > On Thu, Dec 04, 2025 at 05:28:15PM +0100, Ard Biesheuvel wrote:
> > > > > The buffer provided to kernel_neon_begin() is only used if the task is
> > > > > scheduled out while the FP/SIMD is in use by the kernel, or when such a
> > > > > section is interrupted by a softirq that also uses the FP/SIMD.
> > > > >
> > > > > IOW, this happens rarely, and even if it happened often, there is still
> > > > > no reason for this buffer to be cleared beforehand, which happens by
> > > > > default when using a compiler that supports -ftrivial-auto-var-init.
> > > > >
> > > > > So mark the buffer as __uninitialized. Given that this is a variable
> > > > > attribute not a type attribute, this requires that the expression is
> > > > > tweaked a bit.
> > > > >
> > > > > Cc: Will Deacon <will@kernel.org>,
> > > > > Cc: Catalin Marinas <catalin.marinas@arm.com>,
> > > > > Cc: Kees Cook <keescook@chromium.org>
> > > > > Cc: Eric Biggers <ebiggers@kernel.org>
> > > > > Cc: Justin Stitt <justinstitt@google.com>
> > > > > Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> > > > > ---
> > > > >  arch/arm64/include/asm/simd.h | 3 ++-
> > > > >  1 file changed, 2 insertions(+), 1 deletion(-)
> > > > >
> > > > > The issue here is that returning a pointer to an automatic variable as
> > > > > it goes out of scope is slightly dodgy, especially in the context of
> > > > > __attribute__((cleanup())), on which the scoped guard API relies
> > > > > heavily. However, in this case it should be safe, given that this
> > > > > expression is the input to the guarded variable type's constructor.
> > > > >
> > > > > It is definitely not pretty, though, so hopefully here is a better way
> > > > > to attach this.
> > > > >
> > > > > diff --git a/arch/arm64/include/asm/simd.h b/arch/arm64/include/asm/simd.h
> > > > > index 0941f6f58a14..825b7fe94003 100644
> > > > > --- a/arch/arm64/include/asm/simd.h
> > > > > +++ b/arch/arm64/include/asm/simd.h
> > > > > @@ -48,6 +48,7 @@ DEFINE_LOCK_GUARD_1(ksimd,
> > > > >                   kernel_neon_begin(_T->lock),
> > > > >                   kernel_neon_end(_T->lock))
> > > > >
> > > > > -#define scoped_ksimd()       scoped_guard(ksimd, &(struct user_fpsimd_state){})
> > > > > +#define scoped_ksimd()       \
> > > > > +     scoped_guard(ksimd, ({ struct user_fpsimd_state __uninitialized s; &s; }))
> > > >
> > > > Ick.  I should have looked at the generated code more closely.
> > > >
> > > > It's actually worse than you describe, because the zeroing is there even
> > > > without CONFIG_INIT_STACK_ALL_ZERO=y, simply because the
> > > > user_fpsimd_state struct is declared using a compound literal.
> > > >
> > > > I'm afraid that this patch probably isn't a good idea, as it relies on
> > > > undefined behavior.  Before this patch, the user_fpsimd_state is
> > > > declared using a compound literal, which takes on its enclosing scope,
> > > > i.e. the 'for' statement generated by scoped_guard().  After this patch,
> > > > it's in a new inner scope, and the pointer to it escapes from it.
> > > >
> > > > Unfortunately I don't think there's any way to solve this while keeping
> > > > the scoped_ksimd() API as-is.
> > > >
> > >
> > > How about
> > >
> > > --- a/arch/arm64/include/asm/simd.h
> > > +++ b/arch/arm64/include/asm/simd.h
> > > @@ -48,6 +48,8 @@ DEFINE_LOCK_GUARD_1(ksimd,
> > >                     kernel_neon_begin(_T->lock),
> > >                     kernel_neon_end(_T->lock))
> > >
> > > -#define scoped_ksimd() scoped_guard(ksimd, &(struct user_fpsimd_state){})
> > > +#define scoped_ksimd()         __scoped_ksimd(__UNIQUE_ID(fpsimd_state))
> > > +#define __scoped_ksimd(id)     struct user_fpsimd_state __uninitialized id; \
> > > +                               scoped_guard(ksimd, &id)
> >
> > I guess that will work.  It's not great that it will make scoped_ksimd()
> > expand into more than one statement, which is error-prone and not
> > normally allowed in macros.  But it looks okay for all the current users
> > of it.
> >
> 
> We could always repeat the 'for()' trick that the cleanup helpers use, e.g.,
> 
> for (struct user_fpsimd_state __uninitialized __st; true; ({ goto label; }))
>     if (0) {
> label:    break;
>     } else scoped_guard(ksimd, &__st)
> 
> Would you prefer that?

Hmm, I didn't consider using nested 'for' statements.  It looks like
that should solve the problem.  It makes the implementation a bit harder
to understand, but at least the 'for' statement trick isn't new...
Could you send a patch?  Preferably with a clear comment that documents
why it's done this way.

- Eric
