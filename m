Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794088564;
	b=nDHyHPeiARDhGO1Czham3n+v6uPzKyauG2yN6ah90AqNKTKBm/ARsUgUshpwx5R3qS7v
	 YPR1p67gTVVcFur4CKOmuYX8EewZKeAID3/F6Jouln9DM8HvJ/qIr710piO2yflAwRjps
	 /4HJNVJ85+1hg6I4zRXmBdbBA32GR888Zgs7QLr11yfHBT2yasHKOv4ffTl2EUVLl5Rh0
	 4hiftOVv/K9HWDfZoYkvOtwltodb2jFFQ2XHy9THs936dC/Zc4TwV5W3jwK4hHwyy7eVs
	 hMtTZjxmP0n58AWsi52vEGaVZnGzZsYJOH9xyQq7ik4iU2dregILsoySihk9d6nlefg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794088564;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=GAXt+gB49McI0nwQHHJW1Y2EfO3QNGnxsgrwkzL5pHU=;
	b=i7MfDiD6hfdNURAfcmqkAXVmVUIQeQ+q0ex1DirIZ1PnHsoUp5jRQXpl90inZYt/5KXX
	 nWCDXqihmie1h06OLzuLsW8CdXl5TVx4Ivr+96ffisndzgHnFN4XNZJt2oeG8zZXkce1Z
	 s9ZBdXs9JhdmI52UnYpcIWhonP1z88v2o+4/SL2ywWcqbM0i06ApotvB01MQHXgvvOmgm
	 DSwN3+PNZJ8qKUdzIU7SEF4JzRhjbP5w6xsqZwIZyP5o7xJYxJAWRdT+0eVCYX+8Le9WD
	 /hnIPFvSIUC8/QoCR/2XlfVKtvw37Hq/FgVQTFol6MiQHFTV912vvyPI3aNwq/OudNQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=C3gQeTGQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68C0C606A326
	for <linux-crypto@vger.kernel.org>; Sat,  7 Nov 2026 21:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=C3gQeTGQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 930901F0089F;
	Sat,  7 Nov 2026 21:56:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794088564;
	bh=GAXt+gB49McI0nwQHHJW1Y2EfO3QNGnxsgrwkzL5pHU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=C3gQeTGQmKhTRlrxYh8mCqOy41Gb5th4byfvnkEA4tNnS/580WA4Dp5psr8Fi80dA
	 Goa0YUDIx6nMquuDu91b1HKB189NQXrOPPhIQd67iN7YaCF5mxWqyvZzKBaiysO9bX
	 oR9E9NZcJDLZNHIGAqI72FSwOj/ADqURJybgQacZfbSQX56SlZtmK9XEubTqtF0gkg
	 yfn5nqMYtiHTyV+mTmmBlPofixktq9V5XmMXIXSbu4ntdDPOcLSBAKVhLiPtNzIFbK
	 uuqxhE7Ot5Aa661MZon4x+OzVq2OgQRohmMbh/8JOhsNe0Q2p0LyM1BOfL3UAkrQeY
	 fcua0xBqrTRvg==
Date: Sat, 7 Nov 2026 13:56:02 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>, x86@kernel.org
Subject: Re: [PATCH 2/3] lib/crypto: x86: Opt out of initializing MXCSR and
 387 state
Message-ID: <20261107215602.GJ137269@quark>
References: <20261105005523.84925-1-ebiggers@kernel.org>
 <20261105005523.84925-3-ebiggers@kernel.org>
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
In-Reply-To: <20261105005523.84925-3-ebiggers@kernel.org>

On Wed, Nov 04, 2026 at 04:55:22PM -0800, Eric Biggers wrote:
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
>  lib/crypto/x86/aes.h       | 24 ++++++++++++------------
>  lib/crypto/x86/blake2s.h   |  2 +-
>  lib/crypto/x86/chacha.h    |  4 ++--
>  lib/crypto/x86/gf128hash.h |  8 ++++----
>  lib/crypto/x86/nh.h        |  2 +-
>  lib/crypto/x86/poly1305.h  |  2 +-
>  lib/crypto/x86/sha1.h      |  4 ++--
>  lib/crypto/x86/sha256.h    |  4 ++--
>  lib/crypto/x86/sha512.h    |  2 +-
>  lib/crypto/x86/sm3.h       |  2 +-
>  10 files changed, 27 insertions(+), 27 deletions(-)

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-next

Reviews and acks appreciated!

- Eric
