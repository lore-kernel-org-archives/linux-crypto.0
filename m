Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793748374;
	b=Xs43gKNEbygYc4vT5U9p2XdT7dxsvLrMlQ1IIU60IUKxSDhGGIkmZ2pkulCAmm3kHKAQ
	 73bENGiixjVkROWOI7ix4G6PZ+/+MK2n+FzxhbxRCD8S5kPqSbz2hxG5k9DoP9uTuM8bl
	 z4IlFUovHt97n61B+xi1h0eZi3q3JiQy/0yy5O1DkIhJti2iljSzjcBbWvttLm+BAujVs
	 Rd8sZz2rQ/W2s53Fs3YOS/f5n/Ae+eWL/Lcvjg7L0q3eGmNG13Nx1zvvbf4GSaj361BN4
	 yVSaDMLB7wb8Lhlq6Ut6DGgAV3/mCahSiCmZJt/J94nM/i9hhsHlYW03zHJukeGZy3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793748374;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=a2HSfSPgf9NaCTt4G+ji84x3KpqIbwOOtGbhHXN9F1g=;
	b=qFnU0P36nDSzppf0PT3NoJBUgZ8GKgIxdMOLHqhFAi2gTVy0WpTOHqGVl6urndnZUcFe
	 JIQsGygT9dvk8+O6nCjlpwfVtfaW1/HFljQRtLJQJ/qdCLL7AC5bNowbwkEIoOVGqnv3j
	 rK0DB3gooeU/q1ARFlOvq/W4PeD7+E7WI1uZuES5xkVCQy9bwuZAPuA/svRBpUOjC4bfv
	 XCLx3AvTlLme+xUbRE2Uazkym1N+Pg1uipspbNrAbi0bkhvy15cJJOSZgWnTaMCusvgWO
	 X79G2cpYEiPQ7iQm2SPVEOYyfwKg0snYrlqr6WY0eVfnyrvZBsI1mC9qz1Zerqn+IbA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VYyM4G53;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2FC3606A32C
	for <linux-crypto@vger.kernel.org>; Tue,  3 Nov 2026 23:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VYyM4G53
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 257BF1F0093A;
	Tue,  3 Nov 2026 23:26:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793748373;
	bh=a2HSfSPgf9NaCTt4G+ji84x3KpqIbwOOtGbhHXN9F1g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=VYyM4G53lWze9hqCTBDUCnJIHR9VPZtKOzTE/7mhLozJkCoRtJWd06ykfXGja7INv
	 dOCRIojLJRJlooI+3Y9jQZgXFbADGKUqRTvGooGObTvyyXCGj12y8lSuCMiZtruVfZ
	 Q63NkS/ydcW6Ayd0QuVwSZI7o66GQPTMGZmhTlM6pnfjtDKzM0eM+TMLHmBSOCORXC
	 GYTXxr//Pwbor1MXWlMssoh4d8wQLjSH51MLdwbLtrMqA6S3l8i2QBNSzDTKf1YVCg
	 7/uH+W5v59/al8ZRASTRJ4f4mjcjRoJg3b+qUmFGIggsEPJzb3ICOPjj7wXIVj8Ew7
	 xcXBEhXiunvTQ==
Date: Tue, 3 Nov 2026 15:26:11 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] lib/crypto: poly1305: Hide the mask value from compilers
Message-ID: <20261103232611.GG2281@quark>
References: <20261031042637.68815-1-ebiggers@kernel.org>
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
In-Reply-To: <20261031042637.68815-1-ebiggers@kernel.org>

On Fri, Oct 30, 2026 at 09:26:37PM -0700, Eric Biggers wrote:
> poly1305_core_emit() does a constant-time select between h and h - p,
> where h is the accumulator and p is the Poly1305 prime of 2^130 - 5.
> 
> The mask used in this select isn't hidden from the compiler, though, so
> the compiler can infer that it's either all 0's or all 1's.
> 
> In theory, the compiler could then use that to recognize the select, and
> "optimize" it with a branch.
> 
> Fortunately, in practice, I couldn't find any gcc or clang options that
> made that happen.
> 
> Regardless, add OPTIMIZER_HIDE_VAR() to "hide" the value of the mask for
> safety against any future compiler optimizations.
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>  lib/crypto/poly1305-donna32.c | 1 +
>  lib/crypto/poly1305-donna64.c | 1 +
>  2 files changed, 2 insertions(+)

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-next

- Eric
