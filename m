Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794630322;
	b=Xt1qTZBhCAzTVz3K5UStovvfZH8ehEyuoPCDY6oJWGQ/qRBn3GWrpz8OcvIrOEVZf2kj
	 fVIXPzQzcDp/H5ptMvGFVhNbW/IC6cz81gEJawayM/z9+3Xn+2RdfBqls7OVPOgXL/xW/
	 1mAcz40llQRQS1RpggRGLYyh3H9ncQRybCP2Tf7YXrrah4/cGg5z+At11eT6rC/8StvUX
	 4kzVV6+MEWPGc+XYmkIViWbdAEfOr3rljFmV7dzf3o0FrtRAqCeIkpvWfDIhZzUVHOL3N
	 Edn8QIPcBeYCBjGUX5T30b6mti7YQY6flRdESKg826eNlhCnVlW9OFHwku2TgCVYyRg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794630322;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=SOTglEK1n//VilRTtXmeRUp24ns1hIk0y+N4KBvTdqM=;
	b=ROb8Ow0gbPk/mWz78WRMTjhbf1LfftEGUPyBCKptQM1Lx2DyiFEILv41gCs5YUCrCGXh
	 3c0pJSD/vYve43HM+PeS758wQxXNzAiLNCXTUYssotc4aY6bQ12ieyEONEdNtmTIziRSL
	 iv/0XFqQXAKHvAZhqNEIv7mVbtHTq2NEagaOaGFbylSdNfZfINiGNdsyn5GoKUH0rfiyz
	 Lcy+rRUR7rlxYPZBAj5V0a1zyWkrZ8YhQtik+JW1/zzpE4e6goGTCiQcYYWTOFFBPhbE1
	 /99o/ipOL/dr5FeGjw8PpZ/hrJ2FvStY4Xf2flfLTN0d5+ZS6boH+11hLmujpUSxx1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CR7ZW2Lm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1667606A329
	for <linux-crypto@vger.kernel.org>; Sat, 14 Nov 2026 04:25:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CR7ZW2Lm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F1A81F000C4;
	Sat, 14 Nov 2026 04:25:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794630321;
	bh=SOTglEK1n//VilRTtXmeRUp24ns1hIk0y+N4KBvTdqM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=CR7ZW2LmtFDjtnPu7wprvHCyoWhb5X4fwtgPn9eACVpdKvQxIddpoNJGVGrujetUi
	 XfTNFMsUkCstMEVFs0F7KzJmqQ/PfJKB8aNucMiYjni7igoj8voyY54z/IuX5pmWPL
	 2ikENUdkra81agmHHSv5dbcQiR6bmdIIF7dxJh/VD54/iVQCVYKypt4Jl/iSw15YNe
	 HLZPUt/YsVEhAy5nKT5iZQaKvZj07A+NCn3oJxgisgyqgi2YjfWakKoXeFnoQZ/mCY
	 d7rRYq0rXndwl3XolmReZh8Ude3/PehCY6uxRlXag6sSprFfJSN4PVKIxH/17A9y12
	 MlsupDHFtIQuQ==
Date: Fri, 13 Nov 2026 20:25:20 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] lib/crypto: x86/blake2s: Permute original message words
 in AVX-512 code
Message-ID: <20261114042520.GF2025@sol>
References: <20261112042513.59919-1-ebiggers@kernel.org>
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
In-Reply-To: <20261112042513.59919-1-ebiggers@kernel.org>

On Wed, Nov 11, 2026 at 08:25:13PM -0800, Eric Biggers wrote:
> Each round of BLAKE2s takes a different fixed permutation of the message
> words as an input.  For each round, blake2s_compress_avx512() applies
> that permutation on the message words in %ymm6-%ymm7, writing the
> permuted words to %ymm8-%ymm9 where they are used for the round.
> 
> Oddly, though, it also copies the permuted words back into %ymm6-%ymm7.
> That means the next round has to apply the previous round's inverse
> permutation, then the next round's permutation.  Which it does, by using
> the 'sigma2' table which has the permutations precomposed in this way.
> 
> However, this is not necessary at all, as we can simply do each round's
> permutation on the original message words, using the 'sigma' table which
> is already present in the file for blake2s_compress_ssse3().
> 
> Do that instead.  This eliminates 160 unnecessary bytes of rodata, two
> unnecessary instructions per round, and a loop-carried dependency.
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>  lib/crypto/x86/blake2s-core.S | 18 +-----------------
>  1 file changed, 1 insertion(+), 17 deletions(-)

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-next

- Eric
