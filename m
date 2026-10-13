Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2181F486B9A;
	Tue, 13 Oct 2026 17:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791912921; cv=none; b=RVJcmA7Pe3O0wsSwDfN5zijxZWM+GdYYBy53G3uC/nivx3xLJrOcB4JuYYkpthlbOSWJWzckWFQFUOfvOdUxcnaP2xAA5Yi0gSnqBUowzOSQth6jvBtIEg34jBx396vqF7Ivdy3BTS0y4M6zEIHOrR5Hs+Bf4zoHlLxCm5easkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791912921; c=relaxed/simple;
	bh=4twf8Ig83j6rkVDnor3DhOBVrA0QW/ohTKWyuUpG2IU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=So/zJlpIlVWZr7llgGGcg5nq/KnJhp1hG65kb+X/QsaIWkrJ90HzLq74ZjDN1q2vk6TfuIdv2xCyy31IbA27hCNLyoIum5hH7VAj//VfrOt6vv/1r0J58CaixEm+jTIdz6KFGZsGrMWlkERjQwJw5HyrK31Jj88/345kDtZdmgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oMqQOCXC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oMqQOCXC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81A9A1F000FF;
	Tue, 13 Oct 2026 17:35:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791912919;
	bh=khTJvLKv/+vOyw+yWXKAIK2ePXBBTi6nmBmOdNZF1bE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=oMqQOCXCThSpiERo+J2ssNIxZSBPR/i04TI56b3HPg93nuwHeSySq6TcZ+W9B1BfO
	 9JQNaL3PM0yzxFAH99mc2X7kX0kSJpIO5Y3okHhq1lczj08fcEv+p2vf4JZLI1T1YO
	 lAmDVAze1RHqnVkLHe6WMw/h0GfYZSWLrzxk6DFWGF1Hg3CPMSvnzL99N9X+0H04Td
	 4oVhwjTzTiV/Qr649AhK3Km50FccntIee9ZJyRCBHtfZJv12rnAS+YujVVmsDf3Sbd
	 V210kbDPOhUDUexFzYUrkL75BsdSI7pTnaTPXm++NPfvhlhWKMZTwBjqAKJhVNEH8s
	 WRObtjnrJ5j8A==
Date: Tue, 13 Oct 2026 19:35:08 +0200
From: Eric Biggers <ebiggers@kernel.org>
To: vladimir@genproof.com
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org,
	linux-mips@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>
Subject: Re: [PATCH 0/5] lib/crypto: Handle large lengths in poly1305 and
 chacha20poly1305
Message-ID: <20261013173508.GB3830@quark>
References: <20261012-libcrypto-4gib-lengths-v1-0-ea566c129a2e@genproof.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261012-libcrypto-4gib-lengths-v1-0-ea566c129a2e@genproof.com>

On Mon, Oct 12, 2026 at 09:31:17PM +0000, Vladimir Kukharenko via B4 Relay wrote:
> This series makes the Poly1305 and ChaCha20-Poly1305 library code handle
> large lengths:
> 
> - poly1305_update() can write past its 16-byte buffer if it holds a
>   partial block and nbytes >= 2^32 - desc->buflen.
> - The chacha20poly1305 functions use only the low 32 bits of their
>   size_t message and associated data lengths.
> - On 64-bit MIPS and RISC-V, the poly1305 assembly reads past its input
>   for lengths of 2 GiB or more: these ABIs sign-extend its u32 length
>   argument, and the assembly uses all 64 bits.  arm64 has the same
>   prototype mismatch, with no known failure.
> 
> Patches 1-3 fix the assembly prototypes, one architecture per patch.
> The assembly already treats the length as 64-bit, so they declare it as
> size_t, as commit f3d6cb3dc039 ("lib/crypto: x86/sha1: Migrate
> optimized code into library") did for the x86 SHA-1 assembly.
> Patches 4 and 5 make poly1305_update() and chacha_crypt() take size_t
> lengths.  The patches apply independently, except that on 64-bit MIPS
> and RISC-V patch 4 relies on patches 1 and 2 for inputs of 2 GiB or more.
> 
> No in-tree caller passes inputs this large (WireGuard passes at most one
> packet, big_key at most 1 MiB), so I consider these ABI robustness
> improvements rather than fixes and have not added Fixes or Cc stable tags.
> 
> I tested with the lib/crypto KUnit suite on UML, x86_64, i386, arm64,
> riscv64 and mips64, with a temporary 2 GiB KUnit test on arm64, riscv64
> and mips64 (it oopses on riscv64 and mips64 without patches 1 and 2), and
> in userspace against OpenSSL for inputs above 4 GiB.
> 
> I found the bugs fixed by patches 4 and 5 while writing Coq/VST proofs of
> this code with LLM agents, and an LLM review of patch 4 found the one
> fixed by patches 1-3.  I used an LLM-based assistant to write the patches
> and descriptions, and reviewed its work.

Thanks!  Patches 1-3 look good.  I'm less sure about patches 4-5, since
they go through some trouble to work around (some implementations of)
poly1305_blocks() and chacha_crypt_arch() not taking size_t.  Wouldn't
it make sense to convert those to size_t at the same time?

- Eric
