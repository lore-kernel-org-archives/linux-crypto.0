Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792875560;
	b=R4fhgRppTpIr6xjt4boO8do7UDFyzj08WiNs62a4wlOuuYmEOF7Be5gl9yviIziM7JQt
	 uoMu8MGg6cmZzM9I+FtfYZbuL92L0pY7E0foermwG+eO0KuH/WonTMgquIMlqMnJk54/S
	 jglYopXYAm7SFnTCG7dm2Hs9SO4Xx44f53vGisbquIm31jkEsIfEFHoS/8buZoDNUw6qi
	 ouyRmmb89+zJzg4fuL692vZmgr2NnYWH/mDEIlgCmPPTtMGaVdjevLtJEPI7lC3O2dSsU
	 AycpPqAvLn8UXjTcydJwmroKeP3ENcvCbrQWrwNsMvp/jVTwOKY83PVGnaLQP198R1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792875560;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=aj1pmGSFR41i0yUmiYdf6JOvV7D1V8L2rLzAm7aLi0Q=;
	b=bfJM+JKpsvfkDTMz3IJPvIMJCOommu+PRVCt6s2mvcMq0h8Vr1GO8VglvLmeqbzIjpyN
	 ZOtCAd6Mkeo2nvSJuIX3R5Me9Ye1NU9yNDFqbu2J+p0Vfddq1zm+o1j176IwrMLjvsNlE
	 UVqeJBmybzrJKWNnXcVuDcA1os9SB4uzY/B1mzogdTRYjke/7mejcGiSKGKJ7ZRjlxlQ7
	 6VAPpx0tgWWyhX8pElYs3GiSMFfPnDjTHyNZdlEtgBNvNZt9PBWdJnLu8kgmJbN+Fy7fj
	 hnNNKA/O0F+KQlpKmJTMq8b7mh++LLBsy+IGLA20kwN7J9zsCAToWnjM0TQH070bT+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hbpS1zRI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBA0F606A31A;
	Sat, 24 Oct 2026 20:59:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hbpS1zRI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48AAC1F01825;
	Sat, 24 Oct 2026 20:59:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792875559;
	bh=aj1pmGSFR41i0yUmiYdf6JOvV7D1V8L2rLzAm7aLi0Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hbpS1zRIkWeGaUgZ2QUq8Cq16NfYsw8rR0m4jKt+Gr8//cdvnW0gQoGUAm3cqd+ID
	 /ScXu8oQp4kB+car+Vr89j2n/QdwuZctbgQUfzLcYNOjEZyuPo0JROoMdE413k7/da
	 lQGKcFJ4GIwNQOK2Rk+CorOcqja7THo2VsCp9fbl0kcubbKlwMTwPOArCXa3IFRggG
	 LXSZZ+iqNUzxIl+6M6w74wOe4G9xLVaasLTZLCI3wDhzSuupxcilU7E9YT09P4K4si
	 kMfE0X2cu5kp+lS/CkOZmGRxobqzUoRAiKWBZ3L0YzTMut2pvt9Y9/mS3K9qsFdQeN
	 MgT/ixeXfVUAQ==
Date: Sat, 24 Oct 2026 13:59:17 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-mips@vger.kernel.org,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Aaro Koskinen <aaro.koskinen@iki.fi>, stable@vger.kernel.org
Subject: Re: [PATCH] lib/crypto: mips: Disable Octeon SHA code on
 little-endian kernels
Message-ID: <20261024205917.GA27348@quark>
References: <20261022054450.20746-1-ebiggers@kernel.org>
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
In-Reply-To: <20261022054450.20746-1-ebiggers@kernel.org>

On Wed, Oct 21, 2026 at 10:44:50PM -0700, Eric Biggers wrote:
> Therefore, disable the Octeon SHA-1, SHA-256, and SHA-512 code in
> little-endian kernels.  This causes the generic code that actually
> computes hash values correctly to be used instead.
> 
> Fixes: 82be2dcfa6a1 ("crypto: octeon - add SHA1 module")
> Fixes: c3d0def62001 ("crypto: octeon - add SHA256 module")
> Fixes: fbaa4dfd51a0 ("crypto: octeon - add SHA512 module")
> Cc: stable@vger.kernel.org
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
> 
> This patch is intended to be taken through libcrypto-fixes.

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-fixes

- Eric
