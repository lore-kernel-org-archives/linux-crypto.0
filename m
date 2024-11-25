Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2EA71474DA;
	Mon, 25 Nov 2024 20:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732566359; cv=none; b=dS85AYzqQEdis3xd1MGRMl4N6xqlMtwIZlEScsiasvBjWU6VS4K89UXADLCIxCJlpbig1uyqs1X2uKooVnYRVjD+A7KY6AnhKUyv+4Tt0LEryLVCVdISSAaPOtM0xksgnp0krxyb+k1f/bT6S7ggHRfLirovSkn1nYuMsT8WUb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732566359; c=relaxed/simple;
	bh=8jsQqV/JAdH/4WqNZPRszaS+d2oH+0cJL7Gbblyi89o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ksgTNrxB4vQ2cUGj8JQCCCoyDvLX4RCXLcmT0HNvf5akJQ7pk1lcB2O3ipQnidIm4Snm0IAEhm48ubiLqJBbCAf52mGJkJlDCvgIGgbN81yCn/9VvwLERJ78O+U4Dp/F/EwIvoTAGI3PAIDmXqgQ5YnxfetcTynqX7ml3hPlaJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LLj5/Q8H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LLj5/Q8H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05261C4CECE;
	Mon, 25 Nov 2024 20:25:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732566358;
	bh=8jsQqV/JAdH/4WqNZPRszaS+d2oH+0cJL7Gbblyi89o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LLj5/Q8HiDDzav6wNVFSx+UxySxy2c1VFzp3mEXgslUAteT+qPQYq1+jHB5B+gyXb
	 pLlcdKRxiqUQuhKrR48hn867jY0h3VS3I8zyntejYFKcPmXrnPnxeoIt2xCyuJ4zTu
	 Okg3pju0ZBzh3WmN4glU44eWxgke8Gi6ZB5/OYxCPLUlxxLSDdivepbUX5lJMlg3vn
	 LCSSWvbiyGnnxnp19URjM8N3OdEJRpDh0dHpM0BkP03PXbdrKMHkwUjIazGUIIDeTa
	 XPsTPWlpUMmSr6d2xtrWFLiDsPrbM+JiAGWZHaAgvxv1D2wgYQgI6zd0bspinRafdK
	 CeDS3t12KJhMw==
Date: Mon, 25 Nov 2024 21:25:53 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	x86@kernel.org, Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH 1/6] x86: move zmm exclusion list into CPU feature flag
Message-ID: <Z0TdUYCPJNzuPaaU@gmail.com>
References: <20241125041129.192999-1-ebiggers@kernel.org>
 <20241125041129.192999-2-ebiggers@kernel.org>
 <Z0Q2ali5rvtmj1z9@gmail.com>
 <20241125180814.GA1242949@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241125180814.GA1242949@google.com>


* Eric Biggers <ebiggers@kernel.org> wrote:

> On Mon, Nov 25, 2024 at 09:33:46AM +0100, Ingo Molnar wrote:
> > 
> > * Eric Biggers <ebiggers@kernel.org> wrote:
> > 
> > > From: Eric Biggers <ebiggers@google.com>
> > > 
> > > Lift zmm_exclusion_list in aesni-intel_glue.c into the x86 CPU setup
> > > code, and add a new x86 CPU feature flag X86_FEATURE_PREFER_YMM that is
> > > set when the CPU is on this list.
> > > 
> > > This allows other code in arch/x86/, such as the CRC library code, to
> > > apply the same exclusion list when deciding whether to execute 256-bit
> > > or 512-bit optimized functions.
> > > 
> > > Note that full AVX512 support including zmm registers is still exposed
> > > to userspace and is still supported for in-kernel use.  This flag just
> > > indicates whether in-kernel code should prefer to use ymm registers.
> > > 
> > > Signed-off-by: Eric Biggers <ebiggers@google.com>
> > > ---
> > >  arch/x86/crypto/aesni-intel_glue.c | 22 +---------------------
> > >  arch/x86/include/asm/cpufeatures.h |  1 +
> > >  arch/x86/kernel/cpu/intel.c        | 22 ++++++++++++++++++++++
> > >  3 files changed, 24 insertions(+), 21 deletions(-)
> > 
> > Acked-by: Ingo Molnar <mingo@kernel.org>
> > 
> > I suppose you'd like to carry this in the crypto tree?
> 
> I am planning to carry CRC-related patches myself
> (https://lore.kernel.org/lkml/20241117002244.105200-12-ebiggers@kernel.org/).

Sounds good!

> 
> > 
> > > +/*
> > > + * This is a list of Intel CPUs that are known to suffer from downclocking when
> > > + * zmm registers (512-bit vectors) are used.  On these CPUs, when the kernel
> > > + * executes SIMD-optimized code such as cryptography functions or CRCs, it
> > > + * should prefer 256-bit (ymm) code to 512-bit (zmm) code.
> > > + */
> > 
> > One speling nit, could you please do:
> > 
> >   s/ymm/YMM
> >   s/zmm/ZMM
> > 
> > ... to make it consistent with how the rest of the x86 code is 
> > capitalizing the names of FPU vector register classes. Just like
> > we are capitalizing CPU and CRC properly ;-)
> > 
> 
> Will do, thanks.

Thank you!

	Ingo
