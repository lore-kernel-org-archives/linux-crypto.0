Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F77D21ABD0;
	Thu,  2 Oct 2025 16:22:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759422159; cv=none; b=VqZpUA9KBex+LpMFK91dws+5vN+v/xmHqTuB/SpZHF2oj8UomqAwb6RCLPAjWqVedH8eelz5gs0FqayoqsYnlfZiBfZWXzyDqrOGusRFD/nXtQFFNWR7i6dWhDng6HBi1qyIX7G+kTBIZtoMco9SZHU4NFScWOqquC3OZLy5fcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759422159; c=relaxed/simple;
	bh=l9WPWBv5LEU7jTy0oYjT1qC7YlRew4lHrXzJr22cHlk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=usemrdTqdpN56aNAupWkNbN2U9eJACOux2/Ip2aEEX0CwapzvlEiMspJaZDAVVLa2nl+3el2AXsltJtGX6N4+K5qzP95AHKikrKVKrKFIssSqoAW3tkU/tCGFgiwiwtarOdMhAP4dw2LfTZj+Lb/2qigNemg3LtTeWqAiBED99E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c6oY0weU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c6oY0weU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C20C3C4CEF9;
	Thu,  2 Oct 2025 16:22:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759422158;
	bh=l9WPWBv5LEU7jTy0oYjT1qC7YlRew4lHrXzJr22cHlk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=c6oY0weUsmnibisRSgXf+q2hw0W0V/+mpe1HWu3Lbq15KgyY3PR2eha1UBxIQcoBS
	 2K2KOrgX+Kn+13PspoAoxLPV46aXl4GIo9j+b/clHq31pTVaSxEpGpkRSKlYIdQl2z
	 YlJrpja2qTqCyt/uXxVQSEA/+Zklt2ZVwOB4mupmAg26AJ0YoMdJ427jblWuo7NzVi
	 m4vIMrAloqvlq1r0hnKPaql61ecWjL6/WllGSYQOgOQp7RysIo1Tf0bZN7UPr6+QTu
	 8Xf/tUd68Se/UmRuF5ARv6Y2uVF3t9pTrKlvbSBQe48EiywtOERCq85s4Iel6d/qpw
	 UTCvuFSa/0ZSg==
Date: Thu, 2 Oct 2025 09:22:38 -0700
From: Kees Cook <kees@kernel.org>
To: Ard Biesheuvel <ardb+git@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, herbert@gondor.apana.org.au,
	linux@armlinux.org.uk, Ard Biesheuvel <ardb@kernel.org>,
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Mark Brown <broonie@kernel.org>, Eric Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH v2 20/20] arm64/fpsimd: Allocate kernel mode FP/SIMD
 buffers on the stack
Message-ID: <202510020920.2FE08A4F90@keescook>
References: <20251001210201.838686-22-ardb+git@google.com>
 <20251001210201.838686-42-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251001210201.838686-42-ardb+git@google.com>

On Wed, Oct 01, 2025 at 11:02:22PM +0200, Ard Biesheuvel wrote:
> [...]
> diff --git a/arch/arm64/include/asm/simd.h b/arch/arm64/include/asm/simd.h
> index d9f83c478736..7ddb25df5c98 100644
> --- a/arch/arm64/include/asm/simd.h
> +++ b/arch/arm64/include/asm/simd.h
> @@ -43,8 +43,11 @@ static __must_check inline bool may_use_simd(void) {
>  
>  #endif /* ! CONFIG_KERNEL_MODE_NEON */
>  
> -DEFINE_LOCK_GUARD_0(ksimd, kernel_neon_begin(), kernel_neon_end())
> +DEFINE_LOCK_GUARD_1(ksimd,
> +		    struct user_fpsimd_state,
> +		    kernel_neon_begin(_T->lock),
> +		    kernel_neon_end(_T->lock))
>  
> -#define scoped_ksimd()	scoped_guard(ksimd)
> +#define scoped_ksimd()	scoped_guard(ksimd, &(struct user_fpsimd_state){})

I love it!

> [...]
> -void kernel_neon_end(void)
> +void kernel_neon_end(struct user_fpsimd_state *s)
>  {
>  	if (!system_supports_fpsimd())
>  		return;
> @@ -1899,8 +1910,9 @@ void kernel_neon_end(void)
>  	if (!IS_ENABLED(CONFIG_PREEMPT_RT) && in_serving_softirq() &&
>  	    test_thread_flag(TIF_KERNEL_FPSTATE))
>  		fpsimd_load_kernel_state(current);
> -	else
> -		clear_thread_flag(TIF_KERNEL_FPSTATE);
> +	else if (test_and_clear_thread_flag(TIF_KERNEL_FPSTATE))
> +		if (cmpxchg(&current->thread.kernel_fpsimd_state, s, NULL) != s)
> +			BUG();

I always question BUG() uses -- is there a recoverable way to deal with
a mismatch here? I assume not and that this is the best we can do, but I
thought I'd just explicitly ask. :)

-Kees

-- 
Kees Cook
