Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6621376;
	Mon, 25 Nov 2024 08:33:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732523630; cv=none; b=nd23e0UWxAgXpQXYnPjR3xmijYNoUizTMvg66N05+5zVKHpRNpL8tzjBWiik7AahQ+KGlBcPBFHy4ny32lxgLtXffHm/bcJQUnCfJcW7+9IpTJh+JXKcqE4XuMfVBCAgJyGf7iucsm1mH8EWgrKjSXJv5xFA4R3tyO3AUa14/T8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732523630; c=relaxed/simple;
	bh=08DLoC9gIqHmyOBgl7jHMULOalLwkCwvTDOcF94qBdg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oNw317NIyUPeLBfEtypCVBCP3RReTPviSNjUr2NfCxM6NV+J5TFwymGbhgB5Y3RnJ6KBZgEENcnpIMPy6HbQB9K7VhELf6kUDL2qW/kT86044sF3yK8Fd0RRjz/GmV1cWGtChGRedcQ1JwP7cry401mIzQsN/ajYo5MhBquojio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T5Qp4EWi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T5Qp4EWi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D572FC4CECE;
	Mon, 25 Nov 2024 08:33:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732523630;
	bh=08DLoC9gIqHmyOBgl7jHMULOalLwkCwvTDOcF94qBdg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=T5Qp4EWi0GOIezR4tVR1dV7E88YhZE3wnDREXsupKxrAlMMQ3MXT6/U3+zj+0Wups
	 d5c198JrpnFhF91ZirynSYZrrx3SBhttZHhD9xGy6weDOWcuo8Wrf4eR4H4o9rc1Ok
	 vbmZ5+dGCsfQkLkeV/Hly69KTKlMg7abnf2DdELiQxltWc4bpPTbmGMLi6C1tJlbXN
	 3h1JLODlac6A23YBp1Gv/Hxd93JC9CHvnfmBvB/PwVfcS66AaL2Hwn+8lQ1yjXQ2sG
	 F2wtFPvFMn13794OjiHRlZVvhQjMMYGa/1+GgJRvncwMX37bZRE2WIA9Pwvgs7EqOe
	 nnJZEsdTfNTUA==
Date: Mon, 25 Nov 2024 09:33:46 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	x86@kernel.org, Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH 1/6] x86: move zmm exclusion list into CPU feature flag
Message-ID: <Z0Q2ali5rvtmj1z9@gmail.com>
References: <20241125041129.192999-1-ebiggers@kernel.org>
 <20241125041129.192999-2-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241125041129.192999-2-ebiggers@kernel.org>


* Eric Biggers <ebiggers@kernel.org> wrote:

> From: Eric Biggers <ebiggers@google.com>
> 
> Lift zmm_exclusion_list in aesni-intel_glue.c into the x86 CPU setup
> code, and add a new x86 CPU feature flag X86_FEATURE_PREFER_YMM that is
> set when the CPU is on this list.
> 
> This allows other code in arch/x86/, such as the CRC library code, to
> apply the same exclusion list when deciding whether to execute 256-bit
> or 512-bit optimized functions.
> 
> Note that full AVX512 support including zmm registers is still exposed
> to userspace and is still supported for in-kernel use.  This flag just
> indicates whether in-kernel code should prefer to use ymm registers.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  arch/x86/crypto/aesni-intel_glue.c | 22 +---------------------
>  arch/x86/include/asm/cpufeatures.h |  1 +
>  arch/x86/kernel/cpu/intel.c        | 22 ++++++++++++++++++++++
>  3 files changed, 24 insertions(+), 21 deletions(-)

Acked-by: Ingo Molnar <mingo@kernel.org>

I suppose you'd like to carry this in the crypto tree?

> +/*
> + * This is a list of Intel CPUs that are known to suffer from downclocking when
> + * zmm registers (512-bit vectors) are used.  On these CPUs, when the kernel
> + * executes SIMD-optimized code such as cryptography functions or CRCs, it
> + * should prefer 256-bit (ymm) code to 512-bit (zmm) code.
> + */

One speling nit, could you please do:

  s/ymm/YMM
  s/zmm/ZMM

... to make it consistent with how the rest of the x86 code is 
capitalizing the names of FPU vector register classes. Just like
we are capitalizing CPU and CRC properly ;-)

Thanks,

	Ingo
