Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 086632F7455;
	Fri, 17 Oct 2025 17:13:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760721237; cv=none; b=EPzmRL0/G5F5C2pR6rSmnDagFWvd5TZpjXbZ95sfCrPn7Nb63uhR0pHlKybWFqO+tJFhgkgc/bF7PmtNzdZNlI5tqqu9KAo5ivU3Z6tThaOtVvIAPYimx/cCmTA/by5HSkzkWMaPbbUTQEJVgoi4qwkwOXrVcXg9cNYoBMOPZ2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760721237; c=relaxed/simple;
	bh=Zc+ypsDehD+D6EjfX9MaxxSVOwS713BdXCX/6JkDy1w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LWyCdSAsqznyym06qIIzZyKfmx7XpKm6p0EWIpL7zy6OtfpiUhCcg5CFRFLwIsSP6P4lbiIWRY6ieGSBms0jLS/HQ8CxQaTScHsGOiaZP5GG4NxCQVPZurdRow9heNcabVFCV2upPB1J5HQdLM4Pn+1Krn/+pi7CBlb7O4jKrW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N3b3JcaV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N3b3JcaV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46650C4CEE7;
	Fri, 17 Oct 2025 17:13:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760721236;
	bh=Zc+ypsDehD+D6EjfX9MaxxSVOwS713BdXCX/6JkDy1w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=N3b3JcaVsGssqTSDliSQf4B8QRyePHJqsfnUBuurk8TnjaVSmZXKRjiQR36KHZOQ9
	 vckQglIOadTsS8LvFnioBKHfz91LE3sIhjQzxnzoiDoMqsiLRaCq2J6kItOxJ++788
	 OFNqc4WcskLOEo+Qg+kypMA6NrIB5zH5SM6wf3nRt55KexXQjcMd9/mHLn+u3cqtMx
	 0tgqmFeWm2Z0fLhGwRrG/6/Vkez5K7tecI43bJarRS9fCC02oWisB4B4THSMj1LO/k
	 xm/9MIsjNM3IvuCZ1ugzRVcA9X8oawlGvoxgFkY/YPMGOFteY3/u+bdtmaSeRn1G2A
	 JElBpSLx3c81Q==
Date: Fri, 17 Oct 2025 10:12:23 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Ard Biesheuvel <ardb+git@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
	Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH v3 21/21] arm64/fpsimd: Allocate kernel mode FP/SIMD
 buffers on the stack
Message-ID: <20251017171223.GF1566@sol>
References: <20251008154533.3089255-23-ardb+git@google.com>
 <20251008154533.3089255-44-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251008154533.3089255-44-ardb+git@google.com>

On Wed, Oct 08, 2025 at 05:45:55PM +0200, Ard Biesheuvel wrote:
> diff --git a/arch/arm64/include/asm/processor.h b/arch/arm64/include/asm/processor.h
> index 61d62bfd5a7b..226e635c53d9 100644
> --- a/arch/arm64/include/asm/processor.h
> +++ b/arch/arm64/include/asm/processor.h
> @@ -172,7 +172,7 @@ struct thread_struct {
>  	unsigned long		fault_code;	/* ESR_EL1 value */
>  	struct debug_info	debug;		/* debugging */
>  
> -	struct user_fpsimd_state	kernel_fpsimd_state;
> +	struct user_fpsimd_state	*kernel_fpsimd_state;

Perhaps this field deserves a comment?

> @@ -1834,7 +1837,7 @@ void fpsimd_save_and_flush_cpu_state(void)
>   * The caller may freely use the FPSIMD registers until kernel_neon_end() is
>   * called.
>   */
> -void kernel_neon_begin(void)
> +void kernel_neon_begin(struct user_fpsimd_state *state)

Similarly, the 'state' parameter to kernel_neon_begin() and
kernel_neon_end() could use documentation.

> -		if (IS_ENABLED(CONFIG_PREEMPT_RT) || !in_serving_softirq())
> +		if (IS_ENABLED(CONFIG_PREEMPT_RT) || !in_serving_softirq()) {
> +			/*
> +			 * Record the caller provided buffer as the kernel mode
> +			 * FP/SIMD buffer for this task, so that the state can
> +			 * be preserved and restored on a context switch.
> +			 */
> +			WARN_ON(current->thread.kernel_fpsimd_state != NULL);
> +			current->thread.kernel_fpsimd_state = state;
>  			set_thread_flag(TIF_KERNEL_FPSTATE);
> +		}

'state' can be NULL here, right?  So in that case we do set
TIF_KERNEL_FPSTATE, but we assume context switching cannot happen?

- Eric
