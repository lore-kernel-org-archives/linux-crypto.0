Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794630277;
	b=kguoIaENut+k4cK4dgnX7CED7TTvwYyRNV+N91gsHFmhn+rxeg6rMERWLkWRYZEdeN+p
	 J64LPaGw7umiFoqnBDKrYEXhDu8lX668kKz4z5g0WDfF7wg7/qvogwbxwIxVU2ndn/PJH
	 Ww5brHYkFGmrKY2iAIXL0q5KvDvjxP5rbS8EM9G7HIr2C+AwM9nhdJw0H0vjlPz6eXYdD
	 OZdktB4nqoaWMQrjiXm3VzQC0YuGXM4A3QsgqU86b0x9VWdUtBoNhuzvRNab3E21QNPUi
	 v4i0M0nzS+wZ6nN3Q+8QKq0NIaKTV1UT7HdcfE9s2GpE1T0uf/hlVqcMz1rcBlkwC9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794630277;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=KimncXAGnRvzBRGZ1Q+/4MnV0mL9Je+/FJvUVqmHAuo=;
	b=SRxAdg7vaxlqBUCPL1A5pgUBPaqGCHsn2e8auzyDinRdA8mZFxr4BQw7nss1NBD6TiCI
	 DLgv9KYyeDXOiIsCmfvAAh+ZKJdP/MOpT9slW+OkAXVwQ/+eIZfLlTNSxJkqo8fcOIg6R
	 nB3buIZ2LcVEQmd8qMl3SBmpBpvTlbSik77U3vGXoALEgryo0qO0tuJS0yWNS732Nr7Ua
	 /p0dvX6f9TswzBC5ip0JQ/x8S1/CthdTGI9XsLmviW3r2lAzjz/u+YpFTcWchszGEAzhz
	 nNjR2LdTCnVXHb4af/GrpZx2hPD8ERenLROnc5qbIs4JwnfUA8KdYB0kqUEfYf5c/hg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Qxgb1kBj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 382F0606A323
	for <linux-crypto@vger.kernel.org>; Sat, 14 Nov 2026 04:24:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Qxgb1kBj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A66B31F000C4;
	Sat, 14 Nov 2026 04:24:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794630276;
	bh=KimncXAGnRvzBRGZ1Q+/4MnV0mL9Je+/FJvUVqmHAuo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Qxgb1kBjSBrs3QlVpvl2Da9aDh97DhkYAE0BfOQf4jgN8KAFk2koUOHwmWSiu1jjc
	 ABRIogB4SrCIl2+AKH/8B1xxhodB4gpNIco9diXFBbibydQwOTES9Chx0zwYUynilA
	 xdhmZ8Dn0PfRJxDsyXDfWzusLuTRYFxqctF7pwC2QNQYh4hpVDy8LZIK8p+Ow58A6H
	 P+xNB1Gc8+ek7vBlKP+TRC4i7SC4XeHFv7hYJbfe8zTUU6GgmsStsLRg++2Q8O5Y+V
	 Iug7QffHaM66TNNm49NGJLzlNJLIXUG8JfuzrDhy1hYspT00vSa9hSajPm4aJIoU/N
	 1bsZyFXJUeCvA==
Date: Fri, 13 Nov 2026 20:24:35 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Martin Willi <martin@strongswan.org>,
	Antonio Quartulli <antonio@mandelbit.com>
Subject: Re: [PATCH] lib/crypto: x86/chacha: Drop redundant moves from AVX2
 code
Message-ID: <20261114042435.GD2025@sol>
References: <20261111223455.89467-1-ebiggers@kernel.org>
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
In-Reply-To: <20261111223455.89467-1-ebiggers@kernel.org>

On Wed, Nov 11, 2026 at 02:34:55PM -0800, Eric Biggers wrote:
> The AVX2 optimized ChaCha code has many instances of moving one register
> to another, then left-shifting the destination register with 'vpslld'.
> This pattern likely was copied from the SSSE3 code, which uses 'pslld'.
> However, like all the other AVX instructions, 'vpslld' has separate
> source and destination registers.  Just utilize that instead.
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>  lib/crypto/x86/chacha-avx2-x86_64.S | 36 ++++++++++-------------------
>  1 file changed, 12 insertions(+), 24 deletions(-)

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-next
                                                                         
- Eric                                                                   
