Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794630184;
	b=DXgujs3POpqsap02PeqINV6rZYnZhKKMokrbnMzwFTRh4v/ZnNlkBywR7AdHR727FFuS
	 R7qJ6FWKrJ3l0sb0C62jaeteXBoRkRyjU5tOogf7UCzEfqiMO32le4zTEkNq3aBjvwdZN
	 /vYIzsGrcGFfBEykuO0mGNMs46pwC4gsP40BuKHviMoYGBS4VTmmsHFAQjTzwS4uT7wyR
	 KkgN0RgdFOueHl5hiQVAYPUA4U6yQ6ghvXJA+mnm43ip4QxZiFMXsX74nJEuW7kUKPcR6
	 SDepAgZfMwip9mW00acer67DZ5n/7Eb+yhRAmmIyNzGya6QsyQJxVnWtKvDL5bHQjng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794630184;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=ITcp2Z6xKZfFjjw5FIQwKrQy0t0rZxOevF/qJsewC+g=;
	b=e1A5AMti4ELHwoGwm8VPrpXcDgQjP0UIgNohzVfN3QSTNM9uFnmMg4+2BvwS5ggoIISC
	 434GIrqBZoAX6wkyFzNdKRqlFXp7U6hISzF04egaydFEypEc/XMQM8jgqFDky+CeIXC61
	 AfK+T/Gb2RfPltNz+ij1rzmcEQj5yGVcY/yxmm9yC1SLDLpHNPd+5+8Td+tBMCGMLhj++
	 n9nmpv2UwVGtH55kqQPfmL+rthieryWddwTaPQpmRRnFj5T8mjy6HTfR9yxcwmiO2pr1U
	 5kcbehxzYsxRyM8vhLLwQxr7imHiOVAp69FtxhJ+tfIun58cRGflKhbc8UuqAzWA4tg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=evSWnLwc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA413606A323
	for <linux-crypto@vger.kernel.org>; Sat, 14 Nov 2026 04:23:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=evSWnLwc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C3991F000C4;
	Sat, 14 Nov 2026 04:23:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794630184;
	bh=ITcp2Z6xKZfFjjw5FIQwKrQy0t0rZxOevF/qJsewC+g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=evSWnLwcWcbMgoUA6pWGPxwHQGgXI2NXW6uJF6FP52JLqDx3Ml99NW15HhJL/dNbD
	 4Ry8xzZsWzJCBsOyhvs/LMED1oCOm8YjHYpTBfw1ZxI0qhCMbh3mVnJi9/EXoscAWS
	 Qk6oE8NBOUG4HqBrk+Zy5fxIUlVlEOzJjKmBVWxwZ+w4MGz1LImMVjeFUoosrSYrFB
	 r2lDUYSnVVufSowjZ/eRqOoqBmswf+lG+RsHfoBnSBQO05Xumiq44ZPyMQCZiEqXhH
	 O1iQrWzWmDhRxpJa+49qXqVv8ygBaPi5eZ6RqZRNtt4zxdDap9ahW4vFF/xmGVXs8i
	 CF6ps1Xq/2T2A==
Date: Fri, 13 Nov 2026 20:23:02 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>, x86@kernel.org
Subject: Re: [PATCH] lib/crypto: x86/blake2s: Drop redundant checks for AVX
 and AVX512F
Message-ID: <20261114042302.GA2025@sol>
References: <20261111201436.39855-1-ebiggers@kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261111201436.39855-1-ebiggers@kernel.org>

On Wed, Nov 11, 2026 at 12:14:36PM -0800, Eric Biggers wrote:
> X86_FEATURE_AVX2 implies X86_FEATURE_AVX.  Similarly,
> X86_FEATURE_AVX512VL implies X86_FEATURE_AVX512F (and X86_FEATURE_AVX).
> 
> Simplify blake2s_mod_init_arch() accordingly.  Also nest these checks
> under the block that sets the static key for blake2s_use_ssse3,
> mirroring the code that uses these static keys.
> 
> (Note: as usual, arch/x86/kernel/cpu/cpuid-deps.c is non-enforcing: if a
> dependency isn't met, it warns and doesn't prevent booting.  However,
> that case doesn't occur in real CPUs and is unsupported.)
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>  lib/crypto/x86/blake2s.h | 12 +++++-------
>  1 file changed, 5 insertions(+), 7 deletions(-)

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-next

- Eric
