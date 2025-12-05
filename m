Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 784A1398F97
	for <linux-crypto@vger.kernel.org>; Fri,  5 Dec 2025 06:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764917403; cv=none; b=VboJwQ6z9mKrZrURVytPup8ZeV+cN0w4CsCbtBYdN7KOes2IbB0MVNnJ0G7q18onfXxrKZGbNo2fwEj/T+QMPEIGIzlgJZqW5ywFu/Taz1R/COW7CG9U0vUT6Y+Kqd7HNaulPAuKZHNyl/ox+TX7kMfMLgk8qTHjXwoX8fIOehQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764917403; c=relaxed/simple;
	bh=8aDf/vibDSHxCUkdQ9C98faaNXbC8BlaxlUd+loxUFc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nigaY7Wl8ZZgnaDdIbsT7WfaxT9oyaF54eDq/GpeyD6V5/s3xMH+6uvVffPycBKd4vT8AOsfeZsAYkDDIaYFe6vmKL4y6h7qTVBQUPc/CXK3KxaCdNIpDswCRiGSyVNjvmMPczcQQ5nO7LlEr8Vmdt5IZ3rfX14zPXVhoQiKINU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j1wlC/C/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j1wlC/C/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3D9BC4CEF1;
	Fri,  5 Dec 2025 06:50:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764917403;
	bh=8aDf/vibDSHxCUkdQ9C98faaNXbC8BlaxlUd+loxUFc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=j1wlC/C/r2z4XDKAk81naayn2F7xuj+JAxD8IRNaFn916/aFnI1qxuqaQ6sbo9gi0
	 N1Wb4WpgfTAVfGa0AKq4NqnPr33yB29WPlHRJaYngUt3Q6VBLHq5XiZhebKtqS78Nk
	 9VgeStuzidbhdTtMfX5rUjPXnwOv93GTZnnG941nI3zAMjNe0h8TJSuxCK2OlHV0ES
	 3hYydzxTPNSzTjMfoAQ5TAtCddqrFR/0BBOX2O4mM4hk9ZIoH9g6r/bFERktqi4lLf
	 k78xt0DLmvZDGxHvdngMHSdbFc7ZrNIqrHUrUgVZtgbGlYDlB80NByz1yhux3qFqD+
	 g1KyhyuozXUGg==
Date: Thu, 4 Dec 2025 22:48:09 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Kees Cook <keescook@chromium.org>,
	Justin Stitt <justinstitt@google.com>
Subject: Re: [PATCH] arm64/simd: Avoid pointless clearing of FP/SIMD buffer
Message-ID: <20251205064809.GA26371@sol>
References: <20251204162815.522879-2-ardb@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251204162815.522879-2-ardb@kernel.org>

On Thu, Dec 04, 2025 at 05:28:15PM +0100, Ard Biesheuvel wrote:
> The buffer provided to kernel_neon_begin() is only used if the task is
> scheduled out while the FP/SIMD is in use by the kernel, or when such a
> section is interrupted by a softirq that also uses the FP/SIMD.
> 
> IOW, this happens rarely, and even if it happened often, there is still
> no reason for this buffer to be cleared beforehand, which happens by
> default when using a compiler that supports -ftrivial-auto-var-init.
> 
> So mark the buffer as __uninitialized. Given that this is a variable
> attribute not a type attribute, this requires that the expression is
> tweaked a bit.
> 
> Cc: Will Deacon <will@kernel.org>,
> Cc: Catalin Marinas <catalin.marinas@arm.com>,
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Eric Biggers <ebiggers@kernel.org>
> Cc: Justin Stitt <justinstitt@google.com>
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  arch/arm64/include/asm/simd.h | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> The issue here is that returning a pointer to an automatic variable as
> it goes out of scope is slightly dodgy, especially in the context of
> __attribute__((cleanup())), on which the scoped guard API relies
> heavily. However, in this case it should be safe, given that this
> expression is the input to the guarded variable type's constructor.
> 
> It is definitely not pretty, though, so hopefully here is a better way
> to attach this.
> 
> diff --git a/arch/arm64/include/asm/simd.h b/arch/arm64/include/asm/simd.h
> index 0941f6f58a14..825b7fe94003 100644
> --- a/arch/arm64/include/asm/simd.h
> +++ b/arch/arm64/include/asm/simd.h
> @@ -48,6 +48,7 @@ DEFINE_LOCK_GUARD_1(ksimd,
>  		    kernel_neon_begin(_T->lock),
>  		    kernel_neon_end(_T->lock))
>  
> -#define scoped_ksimd()	scoped_guard(ksimd, &(struct user_fpsimd_state){})
> +#define scoped_ksimd()	\
> +	scoped_guard(ksimd, ({ struct user_fpsimd_state __uninitialized s; &s; }))

Ick.  I should have looked at the generated code more closely.

It's actually worse than you describe, because the zeroing is there even
without CONFIG_INIT_STACK_ALL_ZERO=y, simply because the
user_fpsimd_state struct is declared using a compound literal.

I'm afraid that this patch probably isn't a good idea, as it relies on
undefined behavior.  Before this patch, the user_fpsimd_state is
declared using a compound literal, which takes on its enclosing scope,
i.e. the 'for' statement generated by scoped_guard().  After this patch,
it's in a new inner scope, and the pointer to it escapes from it.

Unfortunately I don't think there's any way to solve this while keeping
the scoped_ksimd() API as-is.

Best I can come up with is to leave it to the callers to allocate the
state, and then use scoped_guard() similar to a regular lock:

        struct user_fpsimd_state __uninitialized fpsimd_state;                   
                                                                                 
        scoped_guard(ksimd, &fpsimd_state)                                       
                foo_neon(...)

Maybe wrap the state declaration with a macro:
DECLARE_FPSIMD_STATE_ONSTACK(fpsimd_state);

- Eric
