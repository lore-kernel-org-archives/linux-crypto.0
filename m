Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794088664;
	b=ndnPIB8cm6w9uMq7d/e4Q8VRvCcogRkxDwuxrkPA5+0HvxbQFJkzo4xaESoIEo9omot3
	 MVUWeCIlvtwOdRNLm+Q1vNEGNzX2M4kNQPENSkk6fpmYaIcyKtAaj7mNZVmY6cxWqNmtN
	 EH3YNPLbvDfoA53VWI0UruLgIZgtoSV8eR/S/earGdNcK7WVGkG+4yZZR0KZWrxisZpHo
	 7YC2FV3QcJIFTbPTq2Dnsl+9sWJ4ub6fUN/x4QTR5JtWXHQ77pmhc4Ec1eNF6IbKt1Gcv
	 VpJJ1FudKb0U3hPOyp0ymxsKb5jG6HoCQpA/f73Pq55sTsTLuqhvNaeT8r6dCr0OUhA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794088664;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=LzoLcyC2Y8RmWj72XVRho2AtJAKsnaGUGYCLrR4Z3n0=;
	b=IFMksG+aaaj16SLafLGzXbodVIwiqMc5hITCZw5ZuUW7xGVqinEvL4rRxI7m4uYuqwow
	 YgE8JL8VSsfFAaopX70llcYjvT0aZ74s37SgmhyhgmpoxRY2jFaf7aZN3DMIqxEMLRMus
	 kbcIGHnPVI8FopAEZpKt9u4yaxj8VUIWfS3TTfolvF5kuHFweDFR4ZhwGGrF91W3t4TNe
	 /eUXIKA1mtoWe3mxtFJBIL5YZm3IXWUdBF93q9d4TTlGFZVGySqXWHzVLtZJzu6N4vxpx
	 5drch9U61fFJHcB7Pgzza1HUMOsaJKU8SRdz9DvrRywS84HfzEWVUefSwTh8ytYltew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Y3oj9txi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE85A606A326
	for <linux-crypto@vger.kernel.org>; Sat,  7 Nov 2026 21:57:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Y3oj9txi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7012F1F0089F;
	Sat,  7 Nov 2026 21:57:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794088663;
	bh=LzoLcyC2Y8RmWj72XVRho2AtJAKsnaGUGYCLrR4Z3n0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Y3oj9txinZHt1LEEKIW0XJnp6Wgdan2xQH2FFdORgPbRTDyOExoU6ROyNafFjddiX
	 VVu1bl8u9BqE4rzx/ueDdyHk/akS5Aiax5mLwSmTkoxEV59Ioot5F8YBzGYjP5VbiU
	 bACLZsTOJ3jjWdUX+S/4yzky55v1NeP6JtEbzNhrjehpwxihvmCLSOv8RIof/gTeps
	 nmVaCmIWbI59upD4qJ5tzcIOTeam6guGORDTS7hPdMmydblZ7BCIJ5mxGTIjMoaQpI
	 0sE5nJZITlaxJVuMZIjxlaObFYCXy6xC1gUeYa+2nD5H67R4YMHXtsoqs10IgybnrZ
	 S9dKjnQeEX0Ig==
Date: Sat, 7 Nov 2026 13:57:42 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>, x86@kernel.org
Subject: Re: [PATCH 3/3] crypto: x86 - Opt out of initializing MXCSR and 387
 state
Message-ID: <20261107215742.GK137269@quark>
References: <20261105005523.84925-1-ebiggers@kernel.org>
 <20261105005523.84925-4-ebiggers@kernel.org>
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
In-Reply-To: <20261105005523.84925-4-ebiggers@kernel.org>

On Wed, Nov 04, 2026 at 04:55:23PM -0800, Eric Biggers wrote:
> The crypto code using "kernel-mode FPU" is integer code that does not
> use any MMX or x87 instructions.  To the extent that float-domain
> instructions are used at all, they are only moves and shuffles, neither
> of which raises SIMD floating-point exceptions or depends on MXCSR.
> 
> Therefore, there's no need to initialize MXCSR or the 387 FPU state.
> 
> Opt out of this initialization by using kernel_fpu_begin_mask(0) instead
> of kernel_fpu_begin().  This eliminates an 'ldmxcsr' instruction in
> every kernel-mode FPU section, reducing overhead, which matters most for
> short input lengths.  On 32-bit kernels it also eliminates 'fninit'.
> 
> A precedent for this optimization can be found in
> commit a58db7ad80e8 ("netfilter: nft_set_pipapo_avx2: Skip LDMXCSR, we
> don't need a valid MXCSR state").
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>  arch/x86/crypto/aegis128-aesni-glue.c   |  6 +++---
>  arch/x86/crypto/aesni-intel_glue.c      | 10 +++++-----
>  arch/x86/crypto/aria_aesni_avx2_glue.c  |  4 ++--
>  arch/x86/crypto/aria_aesni_avx_glue.c   |  2 +-
>  arch/x86/crypto/aria_gfni_avx512_glue.c |  6 +++---
>  arch/x86/crypto/ecb_cbc_helpers.h       |  2 +-
>  arch/x86/crypto/sm4_aesni_avx_glue.c    |  6 +++---
>  7 files changed, 18 insertions(+), 18 deletions(-)

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-next

Reviews and acks appreciated!

- Eric
