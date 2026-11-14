Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794630352;
	b=NBmEsPHbS9yKPvjRhhrHb1wO6+xzHQ1rFUhYHsyGYpgzpv6/HqqJCO9scjvvOC0i7KHF
	 sDalDEdN+/fYm8nhbbi9fD/SJuennzTSvISaoIMkVRDW67JVVEIIGE0KZNF4KzhJ//9M4
	 dmhGxm2NTgWJSOS/UbHrPTQ3wOoGuFap5+JczAgPLD6S7W4RM0pe0MY7AssJPp8kvU5YR
	 wCIWS31I5rzTk/bW3j9Fki68oW6DjEmJ7jyEtAfS2PekVEpWQ6/BgE9NSA7lAESTo6KIG
	 JqQPqBx3/Hbx7wJQE3jqQP8aqF6anqhDNfsn6I8pkLxL6o9CkpQf2c0eAtw5yMu9RbQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794630352;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=7HQJaLnDb14j4y4Gwr5jjrRIeSaDHYpcMUikcjEmqjw=;
	b=e2Obn4vaBSOq6W6FSDzq8YJIUMDIWU1lCa8Zo3uTu4W6vTfEWM9SZlL+cFZdFSPjJTpc
	 30DqyxmyFalPqChZjj9LhwGk0oVZ8RwFlzRCScgXzRFZdIy+AZX3Di15oGU5IhY5WidwH
	 cHbd1aJnFB04C1sxZrh7gwr9hEL9FhvlSQQOe0dbXpKk3hWdSTiLRuENRnXp8xZl4RVel
	 Nva9r8AiemFNE750mx/G0lI31CyvAAStvq/PmswyakTofpf1GetOfNYrRtK1QlwlwcHu3
	 KI0pODHVB8nTlueyyoPNCaCOxImjb3EfuKrB7uU5Vg/PAqCeZ/N+oTbuMIzIiVgp3Zg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TTNhTjJs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2C44606A323
	for <linux-crypto@vger.kernel.org>; Sat, 14 Nov 2026 04:25:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TTNhTjJs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51E061F000C4;
	Sat, 14 Nov 2026 04:25:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794630352;
	bh=7HQJaLnDb14j4y4Gwr5jjrRIeSaDHYpcMUikcjEmqjw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=TTNhTjJsOzt7FEwzvjpsi8J/uJ1fARzQQSFsgBpdGNm0rZzpb8nd34xEGEAyPIUu1
	 Pu07jxDxN4oqsIDHa6Tr4aeJjBaAWdGpDQotqTeShVEUF1k+ch1h/nPHtkHZaqv/uy
	 1SnIFtD51dTjSnidesZiXvmqKZ73q6stNK4BgkGI2LWu5nRIZmFiAHCPQF3FxdoPx7
	 ZnR20gR4ur3x1cbLJKTs5z53RMucrm7aQRpR+fFqt+wOAmx6Lcf+hHNSrLS050yM2f
	 BAXDcYoXrnMKG+WrfAW34fV1a9xSEUKNk6JbjG0DH+Tlk4RA3h1UJnPXG4o6/JVkRY
	 8eIkG6f0YswPQ==
Date: Fri, 13 Nov 2026 20:25:51 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>, x86@kernel.org
Subject: Re: [PATCH 0/2] lib/crypto: x86/sha512: Partially roll up loops
Message-ID: <20261114042551.GG2025@sol>
References: <20261112082839.414786-1-ebiggers@kernel.org>
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
In-Reply-To: <20261112082839.414786-1-ebiggers@kernel.org>

On Thu, Nov 12, 2026 at 12:28:37AM -0800, Eric Biggers wrote:
> Some freshly baked loop rolls in the SSSE3 and AVX optimized SHA-512
> code.
> 
> In each file, SHA-512 rounds 14 through 77 are rolled up into 8 groups
> of 8 rounds.  This saves 20.2 KB of text.  It's also likely to increase
> performance on the CPUs that actually run this code (i.e., CPUs without
> AVX2), due to the improved use of the cache, though the oldest I was
> able to confirm that on is Haswell which has AVX2 anyway.
> 
> Eric Biggers (2):
>   lib/crypto: x86/sha512: Partially roll up sha512_transform_avx()
>   lib/crypto: x86/sha512: Partially roll up sha512_transform_ssse3()
> 
>  lib/crypto/x86/sha512-avx-asm.S   | 124 +++++++++++++++--------------
>  lib/crypto/x86/sha512-ssse3-asm.S | 126 ++++++++++++++++--------------
>  2 files changed, 135 insertions(+), 115 deletions(-)

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-next

- Eric
