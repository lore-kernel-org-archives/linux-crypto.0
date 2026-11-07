Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794087697;
	b=T5rOoYGrXu4jRfe/Drn6loHiI4jtrmuuIGU90AvNjq9nY3oW1hGc7u5x7tnMH6nLNjh1
	 DxJdKLdp5XE3NhV3NGlqMOojv+V+c80kWzWRru6weD9aXm3flAxE756RcNKdT0pa6bah2
	 ILOZhoG9gybtqoMyLDiQ08jdol3TQUK/prnv2x413EqX6O0+QWOA91/0t1LJCe4wNih0E
	 9NznZ/rh2yAN1imfcqJron8ktArjixYipBIJv8+JDS/iTRxjEQ7D7pYyZYV/b0ZXJqFV/
	 4MmcRemOFi5AsaU3EBJpuEiJ76UAIUV+KBXoTvzb6z1Mu1w/ubTNbdxsizJqGdibptw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794087697;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=4+7aN4s6LnMZ63YOCI8/5amsps130q2UQ2MGoMQG5YI=;
	b=np+jErtEOoDIzT6lAseYWaTZLaJKte49zmkGIxO/WVN0u1UEEnwuwAaTcSTjk8vUF2gl
	 pOSYkW9V9LuhyOQDZfPlSwLFw56yfAuJJ8c4PNOGQymTd7iR12BiPkBMWQADMtt2GUVMn
	 mnh8cjQoX8SnS0AwKJkZsNSX3ujMgQ8aT8zC8cUoN276HXWeSDQ3LDdlxybmSvTSuNc4O
	 Ed8ANT0qeeRJStu43DncooHTqus+gEBkwfpKg9owxcudKfjfHbyo7+eUielXYiJQ30K3e
	 sgWztrfTacbh2Ar9VAvHtk4Gn5uCQ5VnkKKyD2Aw8Z9ySLrIHovkIq4P37fpanNJNGg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cPU3VkJN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCF60606A32D
	for <linux-crypto@vger.kernel.org>; Sat,  7 Nov 2026 21:41:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cPU3VkJN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 737661F0089F;
	Sat,  7 Nov 2026 21:41:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794087696;
	bh=4+7aN4s6LnMZ63YOCI8/5amsps130q2UQ2MGoMQG5YI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=cPU3VkJN/U45jKgqxTaHVO1UETNsfzTJ+ezxK6r9ObGLW7K6Vpn/fYHSzjaZBf9/0
	 cRPO7rpY3Xc9EKuf4rraPEH0uJIOASZg/b71HAHuTiDqkm2AWRc7yDMAHhJiHR/KhR
	 PpSO9RC+tlYpoY/IBEMNEbUtmP8rV3kfJ55EO9YxopEZKBrpSIW44oL0XV/0aLZrXV
	 xhsW6qc+QdWTR0I+mJ4OXx8/YSuGwS5k3NNRMkYOVuz7r26Q22gPFxwXGNSqHh/PvG
	 ZZPu06AepDtVySYKvxr47bmBMzRWsXcojQ9ujdAw3i1hZwrMhe9GwF79uI3ruamRav
	 nP18ujT+Re20A==
Date: Sat, 7 Nov 2026 13:41:34 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Martin Willi <martin@strongswan.org>,
	Antonio Quartulli <antonio@mandelbit.com>
Subject: Re: [PATCH] lib/crypto: x86/chacha: Remove vzeroupper at beginning
 of functions
Message-ID: <20261107214134.GE137269@quark>
References: <20261104053830.82604-1-ebiggers@kernel.org>
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
In-Reply-To: <20261104053830.82604-1-ebiggers@kernel.org>

On Tue, Nov 03, 2026 at 09:38:30PM -0800, Eric Biggers wrote:
> There's no point in executing vzeroupper at the beginning of the AVX2
> and AVX-512 optimized functions.  Remove it, leaving the vzeroupper at
> the end (where it is needed) only.
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>  lib/crypto/x86/chacha-avx2-x86_64.S   | 5 -----
>  lib/crypto/x86/chacha-avx512-x86_64.S | 6 ------
>  2 files changed, 11 deletions(-)

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-next

- Eric
