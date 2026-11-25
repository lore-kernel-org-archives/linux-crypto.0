Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795565371;
	b=0mz0wAnsZy8rD+O9ZtLk27fe0Bmq2TK2gK9ake8KGpOHJq854SrwXr5hOVZrLz4ms9Xz
	 mCjq+kEu1+0q0U5UWPVY1g9y0H5m/bveOixmnrDV2VNMDK/8SKM34hstN+BgbR1Sdr0hr
	 yYSiN3cEqbwaZLXsLjHhqhk/Qkril6dl9agXmz50tIS+w+UGS+lPOjsK2jAxxCTbvMKpY
	 xEG2x+PhZhI3XVl8wVz/rcZpRR0gRqVLzzWZpdeVr0UeR+q/7pEFRH+H9/JCJVI/22lVK
	 s7GQeLwIXzafCp2qBgGsrcvLwD7rIXC7bcKmVGyvqcikg2jSjCIlhg3uQSOV6iFLpqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795565371;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=sAykxnp6MJGYtOr9Cul3hpby6os+dDNl+bt1a08BeQ0=;
	b=gyfdmkBi0QDwOjtPwVjAxgOU1GbdpMr2RV4f7QDj7AUk4dlm0JXDHs7SLOnTyNVZVXjA
	 6LdO18VzgC4FWoJw1NXEWDeyrNUdC6mn0v+7pj4yh3rHbGLlDT3/KSGxncCeO5cQvBQW6
	 ewudGIN8mPcYC1YSs5onjRuyBJKLBgSfnUntAlSaaxhsr6I44Qyyn8+1PTPY5NM37JSlM
	 EXu7lu2wnTx5q2ZFD3e1fKIAcNfFKYM7fleiiZ2se0NCIIgLDIJuywwRUo8aDR/M0vmpg
	 cw5y7Fj1M9UYht4uYcKTaKpClxJ+CvvDpUKlO/CjVgmMbOf+3uBp1BVNQJhOxZXIzcw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hahffI1W;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D61B2606A321
	for <linux-crypto@vger.kernel.org>; Wed, 25 Nov 2026 00:09:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hahffI1W
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C924D1F000C0;
	Wed, 25 Nov 2026 00:09:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795565370;
	bh=sAykxnp6MJGYtOr9Cul3hpby6os+dDNl+bt1a08BeQ0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hahffI1WWuYtQneWeWzBjUsHKK5oNuLr+cnYw/iFZ3VsOHKJfV6rA+iOf4ARuXUZ9
	 cxfyVBAb3BgC6NnnMxMYs38rMLxE1IhOrQFmFNOvwkceVAKKWHtd+wuypCDOGcS2nd
	 fg5j4s2DtXIQ1jT1GGixz1jSq3mmfPvXGspenre05jH5d0m8x+GwVNrONcdgn4Htph
	 SmOr9Cn8lGVoinf9ALYotGkKmgGKvjlm3fB2LYqLzE1fk+4pzku6+hq4RMrcd4nRaQ
	 0yBzV1JfoKSx6Y00vOY4yzIfYQTtM4SgsPVg/CuoKNAtoUBNLYFn2SVNWsIBQahLse
	 MldmkQIKQjqZA==
Date: Tue, 24 Nov 2026 16:09:29 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Shreesh Adiga <16567adigashreesh@gmail.com>
Cc: Ard Biesheuvel <ardb@kernel.org>, Demian Shulhan <demyansh@gmail.com>,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH v3] lib/crc: Add 4-way folding in NEON crc64_nvme
 implementation
Message-ID: <20261125000929.GG2001@quark>
References: <20261124060006.862167-1-16567adigashreesh@gmail.com>
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
In-Reply-To: <20261124060006.862167-1-16567adigashreesh@gmail.com>

On Tue, Nov 24, 2026 at 11:29:51AM +0530, Shreesh Adiga wrote:
> Use 4-way folding in the shared NEON crc64_nvme for AArch64
> as well as AArch32. This improves performance by about 2x for 512 byte
> data size on Cortex-X925, as measured with a userspace benchmark.
> 
> Add similar optimizations from x86 implementation like reducing
> the 4x to 2x and doing a tail (len >= 32) 2x fold as well as partial
> block handling to process lengths which are not multiple of 16 bytes.
> 
> The partial block handling uses vqtbl1q_u8(), which AArch32 does not
> provide, so implement it for AArch32 using two vtbl2_u8() lookups, the
> same emulation used by lib/raid/raid6/arm/recov_neon_inner.c.
> 
> crc64_nvme_neon() therefore accepts any len >= 128 on both
> architectures. The AArch64 dispatch code now passes the full length, and
> the AArch32 dispatch code no longer rounds chunks down to a multiple of
> 16 bytes: each chunk is 4 KiB, or the whole remaining length if less
> than 4 KiB + 128 bytes remains, so no tail is left for the generic
> implementation.
> 
> On AArch64, check for PMULL with a static key, and implement the PMULL
> helpers with inline asm. With the vmull_p64() intrinsics, compilers
> build the fold constants in general purpose registers with mov/movk and
> transfer them with fmov/dup, up to 10 instructions per constant pair,
> instead of loading them from memory.
> 
> Tested for correctness with the CRC KUnit tests under QEMU on both
> AArch64 and AArch32.
> 
> Signed-off-by: Shreesh Adiga <16567adigashreesh@gmail.com>
> ---
> Changes in v3:
> - Make the partial_block logic more readable as per suggestion by Ard.
>   Mark the helper functions __always_inline inside the crc64-neon.c
>   file.
> 
> Changes in v2:
> - Squash in the follow-up requested by Eric: AArch32 partial block
>   support, AArch32 chunking without rounding to 16 bytes, and comments
>   explaining the inline asm and partial block handling.
> - Use uint64_t for fold_consts_4x_val and fold_consts_2x_val, fixing the
>   build failure reported.
> - Rebase onto v7.4-rc4
> 
> v1: https://lore.kernel.org/all/20261118160110.1662470-1-16567adigashreesh@gmail.com/
> 
>  lib/crc/arm/crc64-neon.h   |  16 ++++++
>  lib/crc/arm/crc64.h        |   4 +-
>  lib/crc/arm64/crc64-neon.h |  27 +++++++---
>  lib/crc/arm64/crc64.h      |  18 ++++---
>  lib/crc/crc64-neon.c       | 106 ++++++++++++++++++++++++++++++++++---
>  5 files changed, 150 insertions(+), 21 deletions(-)

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=crc-next

- Eric
