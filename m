Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794088981;
	b=Op0JubQhMqEByoaBwGlDHxv4rMFzZ09hWjMAgbDY+d6eIiJ1xz8qZ6t6smTfFGHU89GO
	 SKNa0hOVCjJ9PP/Vhl+C4H7I+ZilD5O8c3B6vuR8vMnGTVBKeQrF4nCYjQxeQ/aPD4RhV
	 QVBfMD/ZLqTzw4MevOSUe8WNEmBq0TwIAPGh4Wvus4pGS7cGQGWXJ4Zf2cjPvrRT7GPIo
	 mGaqgw+LVdCPk/YV2d/FDUEVfvFfMMCkg/e3Zo7hPFoPnppFBmC3dWGNmmQwuA0KvFT6u
	 jfRCVwOkmrCKYKHqXk3NAj6l5K4Zvah1V16Wu0uS2UPuuI78/4I3Qy9tXjHAiKrWK0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794088981;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=napSKAHK/BkTTFwEBLJzzobupTqyLZOJD2VGqPOPLSg=;
	b=oVQvmU7KcEIcAxj6Nx8EGQ1hu79cjFzNnvXKKQKZ9cfedq73Y+yoJjiZ5hPVTNwPNVzN
	 FIQwYyKyOiSs1TT48P910HCNJU1f818tZDLv3o5mXE5ExNQZve+azoLIzU1a1+SOZTFg3
	 v4gYjKiuAcTTbWU7rz5CA3jDmdZPBeB8XSBJUYFZQr2tY12qm5knhi2Eh8fRN/nZXIqF6
	 0voJUyBzzUnUoqxGAXa79l5hfH5WenJdl5tI4g0Qe3xrXjNjbN+QZcKvqqCFZBRV9Q38q
	 HjThEUz3lwuQawGoG+WWXzz60bEmHfnistwaclfJ4bM3KJSM5zOkHpiFGazwBYD+PLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DvJO4Vgi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DACB5606A326
	for <linux-crypto@vger.kernel.org>; Sat,  7 Nov 2026 22:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DvJO4Vgi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BD651F0089F;
	Sat,  7 Nov 2026 22:03:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794088980;
	bh=napSKAHK/BkTTFwEBLJzzobupTqyLZOJD2VGqPOPLSg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=DvJO4Vgizd44PscIkpJT6b6MTbA9KTtr2ZVX9Kx9RBjZp89/SyhCnTyVpDh/r0vwN
	 eJtemFn0WdYqkJoAKyf8+TIk2PJRRm6wG4JvWZW0f61ifGzNMdknT/eAufpKbL2FhS
	 8lj6Lfs+PwoY1U8Lv975c1Qts0qoSEQXcD+JHgrEiwYYMnn9eCwVG0xjYZhBpDTln/
	 gC9++aPiN+zvZUOzUA8kkPTioBnQYAC1s/17DWITmRQMhFjfwI7t/8kX2PgYGZRH3T
	 MG26Zog/DMYIXihS0eAVBLW7g5zkV45BAxgCyuBGDFIlm/BpfvJO7wCyPcy5rLTwC2
	 1CwzYfDIPJY9A==
Date: Sat, 7 Nov 2026 14:02:59 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] lib/crypto: x86/nh: Optimize nh_avx2()
Message-ID: <20261107220259.GM137269@quark>
References: <20261105042442.308062-1-ebiggers@kernel.org>
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
In-Reply-To: <20261105042442.308062-1-ebiggers@kernel.org>

On Wed, Nov 04, 2026 at 08:24:42PM -0800, Eric Biggers wrote:
> Various microoptimizations for nh_avx2().  Nothing too exciting:
> 
> - Instead of adding the message words to the key words and then
>   permuting both, do the following: permute both when loading, add the
>   permuted words, and multiply together adjacent pairs.  This saves one
>   vpshufd instruction per 32 bytes processed, and the ones that remain
>   are now better separated in the flow.
> 
> - Reassign register aliases to put the most frequently used variables in
>   %ymm0-%ymm7, which take fewer bytes to encode in many instructions.
> 
> - Update the registers used in _nh_2xstride() to match nh_sse2() and
>   eliminate the need for T7.
> 
> - Replace the initial 'add $0x20, KEY' with base+displacement
>   addressing, which was already being used anyway in most cases.
> 
> - Update the horizontal sum algorithm at the end of the function to save
>   a couple instructions.
> 
> nh_avx2() shrinks from 664 bytes to 518 bytes, and a quick benchmark
> shows 1% faster Adiantum encryption on x86_64.
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>  lib/crypto/x86/nh-avx2.S | 116 +++++++++++++++++++--------------------
>  1 file changed, 57 insertions(+), 59 deletions(-)

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-next

- Eric
