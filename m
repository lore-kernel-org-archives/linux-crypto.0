Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A3D91C5D77
	for <linux-crypto@vger.kernel.org>; Fri,  5 Dec 2025 08:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764922440; cv=none; b=nc9/fh8hZOgozHx0IMY49WzSAgpahSx8L7Wko6KHqioQju4x8egHh+wZfDHlV2z9CpvAA0SvdNgc9vTwIzTa4bEEoC+QOi532sQFQw9W8DcfRGyYH0bk8RVIvOGcqAXyEWQ2pL8QN11doxH3sn8k2pduhpSLPqfxO8iG2BtcoCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764922440; c=relaxed/simple;
	bh=ju7JY4UeryL2eAre+8vh1xSEmLaVUzDSMO5aHr1fGik=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kvIJZrKgihqpPgvOzdn1iCP6xmAht/PUn7v0z3lJYUXDV4yth0JUTDZPukCH8yqMDPhjMToTBoQiU7dgwp4vpq3/0VAyCqDzM4Fc5S4dagBGi4IaZBgc/nNA3ppCxDx8+LpHn2ke4bavbxxHZMz9RRWT8qrGRY6n4oATdQp0U7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fnSiQ+iC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fnSiQ+iC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3125C4AF09
	for <linux-crypto@vger.kernel.org>; Fri,  5 Dec 2025 08:13:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764922438;
	bh=ju7JY4UeryL2eAre+8vh1xSEmLaVUzDSMO5aHr1fGik=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=fnSiQ+iCZojlF+XDj1m5+W8RbNDZ9YhevDC42uyADsI8BgxlBlJobX1erc7NfWh1S
	 0+DNcYeWuHjsILtI33zAsNZ/W5v8UOhzkP7mSGEa6676KOtIIr6XO3m/OWSpZarIbE
	 R3JUqcxYAqvXqLjlMa6prE0IbSOHFnrhbSwZpAOn8jwcPW2Asgp1JN53Ngp0/m8wp9
	 /lXBsShx7BD65HA63rcT+ugjQcgyJUy+N9q3qyMoGY17pfWOn31zNvnujyGkY9Itg6
	 rNObV/qBA1z7axrTAKcToEgySlvqH/vtlK64Yf/0XzxBfJ4iAvSwInpxuNntGe9Tnc
	 TQIPeHCbAFTjQ==
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-5957753e0efso1819077e87.1
        for <linux-crypto@vger.kernel.org>; Fri, 05 Dec 2025 00:13:58 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCV1GbF0TzXA0U+HufZaD/A+xmWCjIZnf1aGmpwYfgziGxyaUKMAoXU2SiFRfaV2Ocl0nAslPnMsgyGfOlg=@vger.kernel.org
X-Gm-Message-State: AOJu0YyuBt+qH27M7JJmGYVWmdNPgBuIFRa7N8e9i2asHdDLqkcciji+
	mqbCkXCXyOhPVkvHgD/r/V+Kq03AnmL+Yl0YtNSV+i/HUpTTBzRUlMoEyDS46Tv2uDK2We/6A7f
	pcNo7ZW/I3JWtMhreH30L8aWlbXJg31Y=
X-Google-Smtp-Source: AGHT+IHFr1pioy7T4dGDdvXbjllkJmwH7DYy8+khq+vuZNcLpr/IYp4ClSKWBYAqKOT4Hik4/6/FGWo2ye4F1a+U4g4=
X-Received: by 2002:a05:6512:e8a:b0:594:74f9:3b3 with SMTP id
 2adb3069b0e04-597d3fafdd8mr3496744e87.29.1764922437162; Fri, 05 Dec 2025
 00:13:57 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251204162815.522879-2-ardb@kernel.org> <20251205064809.GA26371@sol>
In-Reply-To: <20251205064809.GA26371@sol>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Fri, 5 Dec 2025 09:13:46 +0100
X-Gmail-Original-Message-ID: <CAMj1kXE8qn7MSY1A31CrHRSxw+NXqNGLo=FLo4D-COMhxPAMiw@mail.gmail.com>
X-Gm-Features: AWmQ_bkLvyxuy46AibQu26n751P_heeUmfYSPQbayiew0ssc4Yee2kk-EHyBaus
Message-ID: <CAMj1kXE8qn7MSY1A31CrHRSxw+NXqNGLo=FLo4D-COMhxPAMiw@mail.gmail.com>
Subject: Re: [PATCH] arm64/simd: Avoid pointless clearing of FP/SIMD buffer
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org, 
	Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Kees Cook <keescook@chromium.org>, Justin Stitt <justinstitt@google.com>
Content-Type: text/plain; charset="UTF-8"

On Fri, 5 Dec 2025 at 07:50, Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Thu, Dec 04, 2025 at 05:28:15PM +0100, Ard Biesheuvel wrote:
> > The buffer provided to kernel_neon_begin() is only used if the task is
> > scheduled out while the FP/SIMD is in use by the kernel, or when such a
> > section is interrupted by a softirq that also uses the FP/SIMD.
> >
> > IOW, this happens rarely, and even if it happened often, there is still
> > no reason for this buffer to be cleared beforehand, which happens by
> > default when using a compiler that supports -ftrivial-auto-var-init.
> >
> > So mark the buffer as __uninitialized. Given that this is a variable
> > attribute not a type attribute, this requires that the expression is
> > tweaked a bit.
> >
> > Cc: Will Deacon <will@kernel.org>,
> > Cc: Catalin Marinas <catalin.marinas@arm.com>,
> > Cc: Kees Cook <keescook@chromium.org>
> > Cc: Eric Biggers <ebiggers@kernel.org>
> > Cc: Justin Stitt <justinstitt@google.com>
> > Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> > ---
> >  arch/arm64/include/asm/simd.h | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > The issue here is that returning a pointer to an automatic variable as
> > it goes out of scope is slightly dodgy, especially in the context of
> > __attribute__((cleanup())), on which the scoped guard API relies
> > heavily. However, in this case it should be safe, given that this
> > expression is the input to the guarded variable type's constructor.
> >
> > It is definitely not pretty, though, so hopefully here is a better way
> > to attach this.
> >
> > diff --git a/arch/arm64/include/asm/simd.h b/arch/arm64/include/asm/simd.h
> > index 0941f6f58a14..825b7fe94003 100644
> > --- a/arch/arm64/include/asm/simd.h
> > +++ b/arch/arm64/include/asm/simd.h
> > @@ -48,6 +48,7 @@ DEFINE_LOCK_GUARD_1(ksimd,
> >                   kernel_neon_begin(_T->lock),
> >                   kernel_neon_end(_T->lock))
> >
> > -#define scoped_ksimd()       scoped_guard(ksimd, &(struct user_fpsimd_state){})
> > +#define scoped_ksimd()       \
> > +     scoped_guard(ksimd, ({ struct user_fpsimd_state __uninitialized s; &s; }))
>
> Ick.  I should have looked at the generated code more closely.
>
> It's actually worse than you describe, because the zeroing is there even
> without CONFIG_INIT_STACK_ALL_ZERO=y, simply because the
> user_fpsimd_state struct is declared using a compound literal.
>
> I'm afraid that this patch probably isn't a good idea, as it relies on
> undefined behavior.  Before this patch, the user_fpsimd_state is
> declared using a compound literal, which takes on its enclosing scope,
> i.e. the 'for' statement generated by scoped_guard().  After this patch,
> it's in a new inner scope, and the pointer to it escapes from it.
>
> Unfortunately I don't think there's any way to solve this while keeping
> the scoped_ksimd() API as-is.
>

How about

--- a/arch/arm64/include/asm/simd.h
+++ b/arch/arm64/include/asm/simd.h
@@ -48,6 +48,8 @@ DEFINE_LOCK_GUARD_1(ksimd,
                    kernel_neon_begin(_T->lock),
                    kernel_neon_end(_T->lock))

-#define scoped_ksimd() scoped_guard(ksimd, &(struct user_fpsimd_state){})
+#define scoped_ksimd()         __scoped_ksimd(__UNIQUE_ID(fpsimd_state))
+#define __scoped_ksimd(id)     struct user_fpsimd_state __uninitialized id; \
+                               scoped_guard(ksimd, &id)

 #endif
