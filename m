Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795563051;
	b=Tj3LarcKtfe65sr+A1sTRhqKTg012nZcQYGsI/Sc5xUE0K2fhs8aZFrK7c6T3ukpcA0z
	 XNgb5p/KjHoeVaY2m1f7NLvNsn9GliwcI80gWniqx1mblUpv7csDuTLftxVgjuMihcJgh
	 OIoIGrYB5pD6Ff5QEk5oPk3hWQTOCzOuPElLygFKEFuT2eKzzlsYmIJ9gaKszZC7dnwCf
	 2NGD2Ij2uhbrtehxFiY2A3n7J4UvkIAqXWFdxCyz6hTI3k2KzBEojfqdF3Ch/Ruk1MVvl
	 JKXAEEnVrF12hb6LGZI1esEU1bVWgMWvsrZOCuMKBCsQwSnq84viM38mXmEKEFgYMqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795563051;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=xMatS/lIlITwEQBgbb/tZ1ycZplUyb2BM7MLbx2ep+g=;
	b=KY6TEXTsr0/RUGLv5uvbMi+6/Zwcyx4RRKfYbtLbhsQqM+R0Tthqs2mXchRL8N0Mkzre
	 60+l56MdjOD51elI9EVCHzB1BKN9I3RjqzxPTrs6I+V9e6pNnKZtR/w5iwL5unZLc4m6K
	 j/TF3cEcWcYEmgKCDOAUbkYIJPN1ltHM/ioxBbIrbgi/La351jcjEOBisJYIAx5Moplgh
	 oAmyLsu3ogo2GsC35FKxLctwbZNjnX9Ln4B+fO4wX1dWcctaI9Nfotyyh9qVPwXctMTEw
	 093/fnp2asbYufTWfG9kX+rOqR+diiWqArt7o6L7hBwY3uBCRrstu3yGt54zN8q29qQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BUpK1P3h;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F33B3606A338
	for <linux-crypto@vger.kernel.org>; Tue, 24 Nov 2026 23:30:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BUpK1P3h
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C5041F000F2;
	Tue, 24 Nov 2026 23:30:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795563050;
	bh=xMatS/lIlITwEQBgbb/tZ1ycZplUyb2BM7MLbx2ep+g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=BUpK1P3hxsk9PZSWrBBz4ljCIFDbjqV6e9ThyVz0G+MPh367U2LA7d2f5Gk3wth44
	 Dz2/RnBdvU2FO+nVIJ98wMV9JqyYu9XKszflBw08JlyqV5oH0dvXYjRgGfa7ZN4a0I
	 KHP10/OhL9Wy7mtiVtEtJC5hjVyjskNR5Ym7PAFxP40i5mcEPQCigWDDLLE1tCVBrw
	 R5psRblfiK7uUvDq8Qs+XVHNPio4ODtEGNzvm78GXPslLhQmP4q5Yw0+PXu2/Jm9XY
	 DotElNutbOXbw7jkMFF/p8/QtW8kD4JhhniTfPWsL2Ffngry2vsc2hy/tcIVbAIOm+
	 Ds0at1eta9z6g==
Date: Tue, 24 Nov 2026 15:30:48 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>, x86@kernel.org
Subject: Re: [PATCH 0/4] lib/crypto: Clean up and optimize sha512-avx2-asm.S
Message-ID: <20261124233048.GD2001@quark>
References: <20261123031321.403308-1-ebiggers@kernel.org>
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
In-Reply-To: <20261123031321.403308-1-ebiggers@kernel.org>

On Sun, Nov 22, 2026 at 07:13:17PM -0800, Eric Biggers wrote:
> A refresh for sha512-avx2-asm.S (the SHA-512 implementation that's used
> on all AVX2 capable CPUs), bringing the following small benefits:
> 
>   - 6% faster SHA-512 on AMD Ryzen 9 9950X (Zen 5) and
>     9% faster SHA-512 on Intel Sapphire Rapids.
> 
>   - Negative 288 line diffstat.
> 
>   - Slight reductions in text and rodata size.
> 
>   - Better comments.
> 
> Eric Biggers (4):
>   lib/crypto: x86/sha512-avx2: Clean up loading and byte-swapping the
>     data
>   lib/crypto: x86/sha512-avx2: Optimize message schedule
>   lib/crypto: x86/sha512-avx2: Factor out SHA512_Round
>   lib/crypto: x86/sha512-avx2: Optimize SHA512_Round
> 
>  lib/crypto/x86/sha512-avx2-asm.S | 550 ++++++++-----------------------
>  1 file changed, 131 insertions(+), 419 deletions(-)
> 
> 
> base-commit: b6a9fa34ce4187cb69d3c588a4bbffc31ce5db8f

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-next

- Eric
