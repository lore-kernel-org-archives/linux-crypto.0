Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795806496;
	b=JSnu5tfDHDUYxXeX3ubPdTrPXglXSc0iCHzegyZHHiDJaLWboCDu/BX5ZeihfwEvm+Ri
	 hCO6tfKJCwgOFP148mJtpA7s8rOSHzPXVjWTZnkQeQvuk1uym/iY7shynz2ia0CP9Y9Ev
	 ZxIJB01iKUd9nnb93GkfjlyyQTy9u0af+q14LJnf9YBrDUbWsL21I4twLJDW7NFJPsuw1
	 jE9IQtrQbDlTPlt9kML/aPvm4bq7ewUvpFa/pGcxEO2e3cM5G6qHFIMToeOJRLR+lmPEq
	 r7bZZDi4K7wjOXQsE8lFtEf5ofQeItK/7CCnbyVRRY4WwXzi+/0mQ7EyD2awambwAIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795806496;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=U3mQaDsF5KmCfpDZ9ggijBF36k70G7KWFW1BZAQojeY=;
	b=Y5n9Hxl5EkdTUo27ZzUcx6ASfjpGIZSUdK/ohaRJ1fRMqPFaQrcCIwPsAi1o9KuML20s
	 +JvuB7X3u4nOhDqBgDgYCqdSA239F85LD3Mt3smdFNZYCg64S5uRfzRMi//voYjz4mgiL
	 1c1z3pIVKvHf6h/QHMZTE25mZige9HAEXD9UrKk9XTpS03QofEkS0rYsFrWGjrwFQMD6I
	 k21C2V+heigfY/QezDbHkPrm4C4omaN4wNRMtzjBtvgoQEpyVXm9FBfQGTnN3wbvblA0X
	 YM3ov4IHksFV9cUPJX+scEPYjVlLpwjfl3gVpPIvdnaOXGNJ7O9NXP6vxv5Iko8iC8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HZYC63nq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB861606A31E
	for <linux-crypto@vger.kernel.org>; Fri, 27 Nov 2026 19:08:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HZYC63nq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DEF31F00897;
	Fri, 27 Nov 2026 19:08:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795806495;
	bh=U3mQaDsF5KmCfpDZ9ggijBF36k70G7KWFW1BZAQojeY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=HZYC63nqLCjdoR+tjHIGnTjBWn6baeS/NeyI9nVHLJHCovMU6koQGgrJzYe8mCLaW
	 IvDFGjyNvJ+DH5pe16rC1s3toWzAq9gLL/CL97A/xtNQzvpY0H4FDSov/a4Gf6+8Ck
	 NFUfdYD7KjaPAvVfvZQiBnfN875f7Us2zx0mi3ioE28Naa7Ooqgji0qYj4Ur3IBs89
	 /dxM3s6sXLX/6hhg7KRa74PIwmryBropUsHs3jw13d+PXEb0TvKsNA0DuX1WO878T8
	 Y3FCwaDcajaNZ2ogI/rx9F1o4PTIm4G7Dq0spevCzDGP9Z8j+Bk9nKFsBWHSVLQg+Y
	 fRCzy12I882oA==
Date: Fri, 27 Nov 2026 11:08:12 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Qingfang Deng <qingfang.deng@linux.dev>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org,
	linux-arm-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] lib/crypto: arm64/ghash: Aggregate 4 blocks per loop
Message-ID: <20261127190812.GB8300@quark>
References: <20261123095409.2518-1-qingfang.deng@linux.dev>
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
In-Reply-To: <20261123095409.2518-1-qingfang.deng@linux.dev>

On Mon, Nov 23, 2026 at 05:53:55PM +0800, Qingfang Deng wrote:
> The byte-PMULL GHASH implementation reconstructs and reduces a field
> product for every input block. Aggregate four blocks using precomputed
> powers of the hash key, which the ARM64 CE version already uses:
> 
>   (Y ^ X1) * H^4 ^ X2 * H^3 ^ X3 * H^2 ^ X4 * H
> 
> Split each polynomial multiplication into 32-bit Karatsuba products,
> pair them in SIMD lanes and accumulate them before reconstruction.
> Reconstruct three 128-bit products and perform one Montgomery reduction
> for the group. Use three byte PMULL instructions with 0xc2 for reduction
> modulo x^128 + x^127 + x^126 + x^121 + 1.
> 
> Retain the low and high halves of H^4 through H, and their XORs, in
> x4-x15. Use x16-x17 to construct the inner 32-bit cross operands while
> independent SIMD products retire. Prepare each next key operand in
> v9-v11. This avoids an expanded table of key rotations and needs no
> register spills. Use the existing single-block pmull_ghash_update_p8
> helper for tails.
> 
> Compare the single-block and this four-block path in the same userspace
> harness on a Cortex-A53 at 1.2 GHz. Median throughput in Gbit/s:
> 
>   Bytes   Baseline   4-block
>      16   0.850016   0.844973
>      64   1.015665   1.723762
>    1440   1.081407   1.968001
>   16384   1.085286   2.032019
>   65536   1.083460   2.025681
> 
> The four-block loop uses 296 instructions, and reaches about 0.980
> instructions per cycle in 64 KiB measurements on Cortex-A53.
> 
> Assisted-by: LLM
> Signed-off-by: Qingfang Deng <qingfang.deng@linux.dev>

Thanks.  I'd like to wait a bit before taking this, since this will
likely change when the arm64 AES-GCM code is migrated into lib/crypto/.
I am doing x86 first, but I'll look at arm64 afterwards.

- Eric
