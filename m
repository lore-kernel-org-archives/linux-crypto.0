Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AEA528151C
	for <linux-crypto@vger.kernel.org>; Sat, 13 Dec 2025 02:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765592976; cv=none; b=KwIl6oNJ+i49i+xTb2cYWRSEZUvK8o7l7KxyZjx7AZrzUbws5ZxFTsutu7lyL0Kk/Dkbe2enFCyXaGx6zjOuvw6kbrG4XPZ9p+2FEDKQoKDSDx0L+IeVyagcgSlCn0J1LzIygvkHewhnUlshwc8pR8Xj1fjme4CoiisnKhQWKrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765592976; c=relaxed/simple;
	bh=hwrLD6/9aUW+AN+NMnTthyh3GBbNp6m5w0xUFtT5iN8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cenQIJOxNNhV7acpJ5wH4vQvHFoBWc2aa7JDZAUF6A6ok3u9DQqwgaZiZ3qXaflSGvRSeP58sYqug/H9UBYb/X6LUtF/P1RDwWFThPfkL0Q9KbC76SCvzN+kym2QlIHCcjveGFxizEZWbhGNZb33Z4fk1+gBA7+9WRNI6j9vZZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Dk3WPyQf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Dk3WPyQf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A748BC4CEF1;
	Sat, 13 Dec 2025 02:29:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765592975;
	bh=hwrLD6/9aUW+AN+NMnTthyh3GBbNp6m5w0xUFtT5iN8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Dk3WPyQfFNYArSTDlkboK8jg23EenxvOPVLSRUoUNBBL/BaIflf8LkTIUhHRPKD+C
	 VUS/LwH9+UrTqgAozfKadLH1BnOVyM59M+XuZpq8nr0bQ6q4FPYvOFL6wmRXaG5PQ8
	 WH7d7F3gN3RIX/+g58VWMthAjx0QU5rl4v0hr3FIi/T/h26H5NWBnWLKUefO5MiKwg
	 t60lDNg45577jognGYyDXZPJx9ikYKc+y7q2ataxZrFO+A86Dc5UzQmY/5NekG86IN
	 JyiVSyuZH98oRT8XobOqKuLeGW1/7mSUFZlC2H6GxJcRz4SLWTdQA/Grj2snC/uYse
	 YwuGp0gocnSNQ==
Date: Fri, 12 Dec 2025 18:29:29 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v2] arm64/simd: Avoid pointless clearing of FP/SIMD buffer
Message-ID: <20251213022929.GA71695@sol>
References: <20251209054848.998878-2-ardb@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251209054848.998878-2-ardb@kernel.org>

On Tue, Dec 09, 2025 at 06:48:49AM +0100, Ard Biesheuvel wrote:
> The buffer provided to kernel_neon_begin() is only used if the task is
> scheduled out while the FP/SIMD is in use by the kernel, or when such a
> section is interrupted by a softirq that also uses the FP/SIMD.
> 
> IOW, this happens rarely, and even if it happened often, there is still
> no reason for this buffer to be cleared beforehand, which happens
> unconditionally, due to the use of a compound literal expression.
> 
> So define that buffer variable explicitly, and mark it as
> __uninitialized so that it will not get cleared, even when
> -ftrivial-auto-var-init is in effect.
> 
> This requires some preprocessor gymnastics, due to the fact that the
> variable must be defined throughout the entire guarded scope, and the
> expression
> 
>   ({ struct user_fpsimd_state __uninitialized st; &st; })
> 
> is problematic in that regard, even though the compilers seem to
> permit it. So instead, repeat for 'for ()' trick that is also used in
> the implementation of the guarded scope helpers.
> 
> Cc: Will Deacon <will@kernel.org>,
> Cc: Catalin Marinas <catalin.marinas@arm.com>,
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Eric Biggers <ebiggers@kernel.org>
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  arch/arm64/include/asm/simd.h | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/simd.h b/arch/arm64/include/asm/simd.h
> index 0941f6f58a14..69ecbd69ca8c 100644
> --- a/arch/arm64/include/asm/simd.h
> +++ b/arch/arm64/include/asm/simd.h
> @@ -48,6 +48,13 @@ DEFINE_LOCK_GUARD_1(ksimd,
>  		    kernel_neon_begin(_T->lock),
>  		    kernel_neon_end(_T->lock))
>  
> -#define scoped_ksimd()	scoped_guard(ksimd, &(struct user_fpsimd_state){})
> +#define __scoped_ksimd(_label)					\
> +	for (struct user_fpsimd_state __uninitialized __st;	\
> +	     true; ({ goto _label; }))				\
> +		if (0) {					\
> +_label:			break;					\
> +		} else scoped_guard(ksimd, &__st)
> +
> +#define scoped_ksimd()	__scoped_ksimd(__UNIQUE_ID(label))
>  
>  #endif
> 

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-fixes

I added:

    Fixes: 4fa617cc6851 ("arm64/fpsimd: Allocate kernel mode FP/SIMD buffers on the stack")

- Eric
