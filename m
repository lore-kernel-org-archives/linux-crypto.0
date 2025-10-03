Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92A98227B94;
	Fri,  3 Oct 2025 20:18:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759522701; cv=none; b=fyi+TNF4TKezztRMcTKIbpMCu1E7wpvwe6EOH6CpwLU23gW8S9Ai7jnuchmbHeH6dIxG0n+u6+3y3Gcrexlf0c1jAc6gclwywRA1hhD2gg8KtY9OdSrKPdBAYhsgnhHOGLb/uelHghQH586EQcwR3Xh/vtE1slatu3/5ZLMDAMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759522701; c=relaxed/simple;
	bh=vQfJ1cZDAVEbVC1Gj3v8LCP7wE5pMK3AJKqOpsdTy9E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tTW9YWvBZxfBzVdBe8P8xO2o9Vexv1C5pr8MWotJ3P53W5K8VpYU0LQPEt92kxt/VJYgSKbYm+DhpXnAWkkTgVWyQN3C+Ldo7ZP85exHqnOokX5GESgGMPFL1H3A1IBPsaHJglQRlBIDeuUm1DzTd3T4iQsYs7CBvKf0KX3kQ5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Rz8sa8+6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Rz8sa8+6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CAA5C4CEF5;
	Fri,  3 Oct 2025 20:18:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759522701;
	bh=vQfJ1cZDAVEbVC1Gj3v8LCP7wE5pMK3AJKqOpsdTy9E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Rz8sa8+6J/I9EXLjRDy1o2LsaKwDCofOgjcRebSS+auwNyowpfAMNiCi82JYJgIrM
	 6EWPiAj4p6Q2rD8rNH6/ImQbKfceqIEYCvGNi+7PSxB4CrZNZZcM6olq8ovuvr30F4
	 lbmUeU5js9KpKdJqgT4omBMAJdw1lW4cjn4/FGownvHWaJsBguPmS/jnw+Ow+RsGkR
	 2G/aQCxNIFq8jdysVToiGLalItNvxSskDKFv7iHDH4JN46Nmigzs3NFP+ns/EaOU5O
	 SD54/Wd4pvbtOfFwGap2CEOzmvDPks3OPfuUEhCjr1WIxQt8MSlaRpaNJGt5wIm8YR
	 Oe05/nANNK/Ig==
Date: Fri, 3 Oct 2025 13:18:18 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Ard Biesheuvel <ardb+git@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, herbert@gondor.apana.org.au,
	linux@armlinux.org.uk, Ard Biesheuvel <ardb@kernel.org>,
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Kees Cook <keescook@chromium.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v2 20/20] arm64/fpsimd: Allocate kernel mode FP/SIMD
 buffers on the stack
Message-ID: <20251003201818.GA24598@quark>
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
> diff --git a/arch/arm64/include/asm/processor.h b/arch/arm64/include/asm/processor.h
> index 4f8d677b73ee..93bca4d454d7 100644
> --- a/arch/arm64/include/asm/processor.h
> +++ b/arch/arm64/include/asm/processor.h
> @@ -172,7 +172,7 @@ struct thread_struct {
>  	unsigned long		fault_code;	/* ESR_EL1 value */
>  	struct debug_info	debug;		/* debugging */
>  
> -	struct user_fpsimd_state	kernel_fpsimd_state;
> +	struct user_fpsimd_state	*kernel_fpsimd_state;

Is TIF_KERNEL_FPSTATE redundant with kernel_fpsimd_state != NULL?  If
so, should we have both?

> +void kernel_neon_begin(struct user_fpsimd_state *s)
>  {
>  	if (WARN_ON(!system_supports_fpsimd()))
>  		return;
> @@ -1866,8 +1869,16 @@ void kernel_neon_begin(void)
>  		 * mode in task context. So in this case, setting the flag here
>  		 * is always appropriate.
>  		 */
> -		if (IS_ENABLED(CONFIG_PREEMPT_RT) || !in_serving_softirq())
> +		if (IS_ENABLED(CONFIG_PREEMPT_RT) || !in_serving_softirq()) {
> +			/*
> +			 * Record the caller provided buffer as the kernel mode
> +			 * FP/SIMD buffer for this task, so that the state can
> +			 * be preserved and restored on a context switch.
> +			 */
> +			if (cmpxchg(&current->thread.kernel_fpsimd_state, NULL, s))
> +				BUG();

Does this really need to be a cmpxchg, vs. a regular load and store?
It's just operating on current.

> +	else if (test_and_clear_thread_flag(TIF_KERNEL_FPSTATE))
> +		if (cmpxchg(&current->thread.kernel_fpsimd_state, s, NULL) != s)
> +			BUG();

Likewise.

- Eric
