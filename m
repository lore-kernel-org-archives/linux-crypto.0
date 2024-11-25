Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40508EED6;
	Mon, 25 Nov 2024 18:08:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732558096; cv=none; b=k3zIOOJv+SwDxW3hNHnF9D04fD6I5U0PCkaN51qJhE36CCW9LPbDhDZtiOej0a85or2jD/YOsDEZuqpMF9eE+80TEnHFWqDyGfwJ89tAMFhF6w+sdYRTzlRxxare3VejL7s40nWAxLmFFVyWvjBNVhEuMGiMTIhZqyZcy9EYbTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732558096; c=relaxed/simple;
	bh=hPRJO5qUSighf4RSKcpA9EnzqcP04owHjqaAy++/DkQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VPwhoZSijA2MWkZDfY5M1RVfnLkGArtDGPH2B0Y9EYBHhdc6BIAtnk+k4k+dtchZ9zaSiP0oC7qzUgbeeohUJkJVDw6vgVOpkbsf+aZdsRh70BpQn4DdQzzwNAs0W8x9B3Y22MTrkLTiG1gaT7acmGfbsv0Hzi1ym8xjezsr9uQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hL4WbXET; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hL4WbXET"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABDE3C4CECE;
	Mon, 25 Nov 2024 18:08:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732558095;
	bh=hPRJO5qUSighf4RSKcpA9EnzqcP04owHjqaAy++/DkQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hL4WbXETYhHXPbSyWGU6pQe8LAejsT0eBv5GcouxqoWpXvIaZ8WM/19ZPHndG9zPO
	 mzvK5728EVFGzfUuUJm5hLu7Z9AMCGC3M1fxHzEWJQkmywlwOKEXu6c/VGBufHvaP2
	 t1WYT1mo5NcaNIP/mgGgCAbINLubvCi5UJxwM+l0CtfEKAbk1xN3JFc+ArapTFAhyq
	 JU/fVjkRlPnW45o+jhGNUJQa0AYBjazPXH7k+3/wYNfwlEB8GDQpYMq7O4KWPIyFoo
	 xus4SGCn6ECubzrIUv5ms/ThAThJTcHSNMl/HVwvw0LeI1yfVTeYuYLJEkmbHDxwH+
	 7Yf8l376pSpFQ==
Date: Mon, 25 Nov 2024 18:08:14 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	x86@kernel.org, Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH 1/6] x86: move zmm exclusion list into CPU feature flag
Message-ID: <20241125180814.GA1242949@google.com>
References: <20241125041129.192999-1-ebiggers@kernel.org>
 <20241125041129.192999-2-ebiggers@kernel.org>
 <Z0Q2ali5rvtmj1z9@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z0Q2ali5rvtmj1z9@gmail.com>

On Mon, Nov 25, 2024 at 09:33:46AM +0100, Ingo Molnar wrote:
> 
> * Eric Biggers <ebiggers@kernel.org> wrote:
> 
> > From: Eric Biggers <ebiggers@google.com>
> > 
> > Lift zmm_exclusion_list in aesni-intel_glue.c into the x86 CPU setup
> > code, and add a new x86 CPU feature flag X86_FEATURE_PREFER_YMM that is
> > set when the CPU is on this list.
> > 
> > This allows other code in arch/x86/, such as the CRC library code, to
> > apply the same exclusion list when deciding whether to execute 256-bit
> > or 512-bit optimized functions.
> > 
> > Note that full AVX512 support including zmm registers is still exposed
> > to userspace and is still supported for in-kernel use.  This flag just
> > indicates whether in-kernel code should prefer to use ymm registers.
> > 
> > Signed-off-by: Eric Biggers <ebiggers@google.com>
> > ---
> >  arch/x86/crypto/aesni-intel_glue.c | 22 +---------------------
> >  arch/x86/include/asm/cpufeatures.h |  1 +
> >  arch/x86/kernel/cpu/intel.c        | 22 ++++++++++++++++++++++
> >  3 files changed, 24 insertions(+), 21 deletions(-)
> 
> Acked-by: Ingo Molnar <mingo@kernel.org>
> 
> I suppose you'd like to carry this in the crypto tree?

I am planning to carry CRC-related patches myself
(https://lore.kernel.org/lkml/20241117002244.105200-12-ebiggers@kernel.org/).

> 
> > +/*
> > + * This is a list of Intel CPUs that are known to suffer from downclocking when
> > + * zmm registers (512-bit vectors) are used.  On these CPUs, when the kernel
> > + * executes SIMD-optimized code such as cryptography functions or CRCs, it
> > + * should prefer 256-bit (ymm) code to 512-bit (zmm) code.
> > + */
> 
> One speling nit, could you please do:
> 
>   s/ymm/YMM
>   s/zmm/ZMM
> 
> ... to make it consistent with how the rest of the x86 code is 
> capitalizing the names of FPU vector register classes. Just like
> we are capitalizing CPU and CRC properly ;-)
> 

Will do, thanks.

- Eric
