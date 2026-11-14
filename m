Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794630204;
	b=llT/KFiHlgoOiYx1uDD9mht9j3CTRVP3EIfBT36F4pysPKMRGYELqbelkt1/5VsXzCbQ
	 sDrQ7aX64Ip2xJ9oElOav9uHslnRadPpX+WzJRyKAZQ2SU/g//RJy31jZM5FvE8PT8rOl
	 pT87Faf5ufUuyL+8S+AMShxqk+GJjt9QvxKvOsfxIUY4kF+yeA2dFvaUk62Y1sIrU3jZh
	 m3mbbYMWMk5lZ8N2bNxBlO5dJGLe7B20curWmzRP2ak1S4ZGv1+ZqElu6nbTz5gFOwhy5
	 y6GN5vrA67gQsNxWI3Z4cHYFN7UJAgUAFMrBhIlnxB3rfr2yxaVljCD2dO+ww6/QVPg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794630204;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=uYdDC/IjN1oFk5DAcAmLbxdKG++q51yfoy8dVYuLVzs=;
	b=EB0IqfBZ4voLjCwTA9qU9xRBVUqGuKSErRBLHBgn1ccq6F8BLOF2mDed4B4h71pIS027
	 b0/waKT4X092EkXCPTDkRDb8v+prObCflh+I+/GW8p5sh+PHSig5cPnfvphRCU73x/uDT
	 H85QJRn13zmYY+fGKMINjpK4Uq5nlS75LyoI/YECoE86wKB381+XeTPTwdnyyKp90tA5f
	 tQR3nb784jVCZuQBvAz7yDjO7Eo7Zcq4ZqADUKEB7BhjMJ78CQ6u89dWG7V8+vBysTwFy
	 Ajt6i+7ewP3XPqTHartXM0j10/kFgJIjVpW4UcCp4/mAkFQgEo5UuR7xp89Mp+PCW7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NEOeDUMH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC5AA606A327
	for <linux-crypto@vger.kernel.org>; Sat, 14 Nov 2026 04:23:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NEOeDUMH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E3431F000C4;
	Sat, 14 Nov 2026 04:23:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794630203;
	bh=uYdDC/IjN1oFk5DAcAmLbxdKG++q51yfoy8dVYuLVzs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=NEOeDUMHM0UJUCzRkQkOA5V3gpC05A+pXMexcmpU83LHDq9RUUsUak0NE96PCuGc4
	 2RWK50ickSi/Z0x8JJswQ5r+CnEDOgvmL6lHqkw5TetlRHFjCWH03eGT7MesV/sWKY
	 kZOise3lyN3/Tkgt2S+9/9Atwe4pIPsyar/O3SSvQiwkruDb7o3eNlCb4IEauzwhiE
	 gqHc+/kNiT1SaP423pxzp2DJlmN6TeYAijVjCcuJfJp+tkIO5lCosga5u/80msh0b1
	 o8msv2RiaK9EMQdOkhE7fNjI1RV3CDO72eYscdelG3iP2Fgth7/6XIvLjWBmsoU7h1
	 e/rRRLPdp0hMA==
Date: Fri, 13 Nov 2026 20:23:22 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>, x86@kernel.org
Subject: Re: [PATCH] lib/crypto: x86/chacha: Drop redundant check for AVX
Message-ID: <20261114042322.GB2025@sol>
References: <20261111201517.39989-1-ebiggers@kernel.org>
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
In-Reply-To: <20261111201517.39989-1-ebiggers@kernel.org>

On Wed, Nov 11, 2026 at 12:15:17PM -0800, Eric Biggers wrote:
> X86_FEATURE_AVX2 implies X86_FEATURE_AVX.  Simplify
> chacha_mod_init_arch() accordingly.
> 
> (Note: as usual, arch/x86/kernel/cpu/cpuid-deps.c is non-enforcing: if a
> dependency isn't met, it warns and doesn't prevent booting.  However,
> that case doesn't occur in real CPUs and is unsupported.)
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>  lib/crypto/x86/chacha.h | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-next

- Eric
