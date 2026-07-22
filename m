Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3F8B388860
	for <linux-crypto@vger.kernel.org>; Wed, 22 Jul 2026 23:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784762667; cv=none; b=BovOxZ3byCehUu9IONtsfvcJAcfvWFInduNT20iolYYNKbgOR57RVf/M830MYhFjuty+36Kd8GmZ2sehG2xiywiY0xSJfYJdOuG3sFG/wx3H/czHGkDBIbTL7nVLVspS5cHfQqdTqMa/sII2Ha+uUxYWxYEt1sCU8gCJ5wo9yLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784762667; c=relaxed/simple;
	bh=Ppk9//PNMPS/6IyhvGoNrqw3X7GQbvkiWZJOzoT+Ex8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pInZ4X1yENYhTTlc+gGzVs27TsJH1QwCbkyPlj5ZMww0tiT1nRbDyO+1mpr+OhzJ18GDHOBB+m373+LqGDhPDiIcFNs3pGoU6X0QGIp7RtKaZQOCTtEH0WZQAn0qWhi1VOPpG1FuOsbRFMuLJPwEfFWJcPIqTZo+sf8lqH9C8GU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QDFieK+W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QDFieK+W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B3611F000E9;
	Wed, 22 Jul 2026 23:24:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784762666;
	bh=5HxmojgeReYJCPUMO94p18lTzbD6fdZmB4BCUcigFIc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=QDFieK+WZeq+GDeaVyX45GoFAjkjjgZhe8gL+XSTMJi654aNEQwxFCXVPf0P2dd2c
	 mSyKEhfm6/GokwyI6tep9fJGe8mOAvL3qgLloyrkegQH/tkOk6/gF99XxuVElhOehP
	 vYAtK2Pl+AqytdLgRpLTAx0RJI4mylieNCruZMy/lCSGDLwY+u88UVM6cSBr0A4KwB
	 WWJyFKp2XuDqGLoqeqo80Mwvum6WjA5cJRkaLvYUENVvg63SvC5ZMKD1T/n9pcW8SC
	 ydL0NQuF/F+RkxPOow1Q7scXc2FTNeNcMI4ktQiE2LnTM0Wpk/ipgvGhN0kP5lZNKr
	 dH+/JWaj8PakQ==
Date: Wed, 22 Jul 2026 16:24:24 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Martin Willi <martin@strongswan.org>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org
Subject: Re: [PATCH] lib/crypto: x86/chacha: Add a 16-block AVX-512 variant
Message-ID: <20260722232424.GA50619@quark>
References: <20260722153247.630519-1-martin@strongswan.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260722153247.630519-1-martin@strongswan.org>

On Wed, Jul 22, 2026 at 05:32:47PM +0200, Martin Willi wrote:
> The existing AVX-512VL code processes at most eight blocks at a time
> using 256-bit ymm registers. This width was chosen deliberately to
> avoid the heavy core down-clocking that 512-bit zmm instructions
> triggered on Skylake-X.
> 
> That penalty is gone on more recent AVX-512 microarchitectures, where
> full 512-bit zmm registers can encrypt sixteen blocks per invocation
> and roughly double the data-level parallelism for bulk traffic. Add
> such a 16-block variant and dispatch to it for inputs larger than
> eight blocks, ahead of the AVX-512VL path which still handles the
> remainder.
> 
> On a Zen 5, the tcrypt speed test for chacha20 with 1024-byte blocks
> reports 7.5 GB/s with the new variant versus 4.2 GB/s for the
> AVX-512VL path, roughly a 1.8x improvement.
> 
> Enable it only on CPUs advertising AVX-512F with full zmm XSAVE state,
> and keep it disabled when X86_FEATURE_PREFER_YMM is set so
> down-clocking parts continue to use the ymm-based AVX-512VL path.
> 
> Signed-off-by: Martin Willi <martin@strongswan.org>

Thanks Martin!

This is very similar to the existing chacha_8block_xor_avx512vl(), just
with 512-bit vectors instead of 256-bit.  They even use the same CPU
instruction set extensions: there are actually no cases where a CPU can
run chacha_8block_xor_avx512vl() but not chacha_16block_xor_avx512()
(the choice of vector length is just going to be made by policy).

Given that, could we consolidate these implementations?  I'd suggest:

- Rename the existing chacha-avx512vl-x86_64.S to chacha-avx512-x86_64.S

- Add the CTR16BL rodata, overlapped with CTR8BL such that CTR8BL is
  simply the first 8 entries of CTR16BL.

- Add a macro that expands into either chacha_8block_xor_avx512vl() or
  chacha_16block_xor_avx512(), using a similar approach to
  arch/x86/crypto/aes-xts-avx-x86_64.S.  Use it to generate both.

Does that make sense?

> This will conflict with your cpu_has_xfeatures() removal [1]. Let me know
> if I shall drop the cpu_has_xfeatures(XFEATURE_MASK_AVX512) line.

Well, this is one of the cases where
cpu_has_xfeatures(XFEATURE_MASK_AVX512) was already required by the
existing code (since all AVX512 bits need to be enabled for any EVEX
coded instructions to work, even on xmm/ymm).  But it was never checked,
and no one ever noticed.  I would just continue to leave it out.

You can also drop the check of X86_FEATURE_AVX512F, which is implied by
X86_FEATURE_AVX512VL and X86_FEATURE_AVX512BW already.

- Eric
