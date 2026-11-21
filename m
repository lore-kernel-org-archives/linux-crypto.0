Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795290745;
	b=tifnD6gBjOFA185gtKd5RXbCwawC5XS6FI1hqJ/heDvTQlpehrUdIPBTee3siwkG+Mx2
	 NYO0zFmcuLVyTKqLtJXbZBpsPqGjTr3cjQ82XPAZE15o0wLCi6AwjLBFfGTcv6AcRRj8q
	 lwUnLK4bZuQdehAcBjSq8lB99O9wMIsbkhrcoTkf9UtnhXTV+Ojj8Avi43eVxjiBnIQNd
	 kbVtvgiCqh03ouNgTaftMv8NMPNXdJbRqJwtVjBTQ+UFklimHGZfjZ49sIT0+GYxSY8P8
	 604fo6+PeSE+nExYWySu1V98ZSYXjygCuP8H9MGrYYan6I+9AmjB4nkNRqw++cV/Z0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795290745;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=b7afuApL2UfF6wmrMMD9w1auhoqHrp8X2PKQ6z+nS9o=;
	b=VpCg5/Nc6CXA+CVqWZ4LoSh8KKBT4RS/yxNmOmzAH7ESDUddau3PimoKjIUEeGOjdTbR
	 tHQTomOhyKZXiAssaDeZohWpTt8Swo1IuGN3LKFb1EMUpObTQ5GokTRMt36X920VCRIuE
	 D8cpyTuKwnDtAZ3Ylvi/sn0RUtRtlz80GQmoJOfrqlsaCD/1mtVkmonG5t8S0seTtJk9V
	 1kZ3yvIA0FReCR05fRQmGBrARpcpUgTgfd9pPd3VU4brqu2pcw70kKmHKM9gaOstDVTLj
	 rRsq3Yry+9Kd5ROI/IJPOOcyQrxo6ydkfjxjotatigyPVYB3dkOTiNe3t8ieirC2IGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kJmYjk9h;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FB53606A320;
	Sat, 21 Nov 2026 19:52:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kJmYjk9h
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBCFF1F000C4;
	Sat, 21 Nov 2026 19:52:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795290745;
	bh=b7afuApL2UfF6wmrMMD9w1auhoqHrp8X2PKQ6z+nS9o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kJmYjk9hC4WgZ3IWBhopTc2hQUviPchJ+3aQj2y0Ti41aKpKlVsQmXIQV/Kgxtx5k
	 9ezO9tY0OAUJsAoZP0KO8rAfa2eMiGj5d2HyKabNo+j4/DveV+KZPRUAHUPysWfiNX
	 DIrlEUogvAP+bYrSpejEqEuCI3AV5SANnGmr40aeExb+0N/eQ5Yo+6Q3EMKc2EtOF4
	 cY8nAsXLJooTBFQKGjUdLwE/DD9Hd4P7+Kw/ksPurRis7iy4GpKspbyTFk89OugpCc
	 4o3tr6eLRmOOEYW4pBNEJRfEWU5FIKPoK242xABxSB5CvuoY3kFcOTJb85v2+3zh5g
	 aUo0MOYPJ1NfQ==
Date: Sat, 21 Nov 2026 11:52:23 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	sparclinux@vger.kernel.org, Andreas Larsson <andreas@gaisler.com>,
	"David S . Miller" <davem@davemloft.net>,
	Stian Halseth <stian@itx.no>, Magnus Lindholm <linmag7@gmail.com>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Subject: Re: [PATCH 0/4] Migrate SPARC64 accelerated AES modes into library
Message-ID: <20261121195223.GD1975@quark>
References: <20261118041033.50014-1-ebiggers@kernel.org>
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
In-Reply-To: <20261118041033.50014-1-ebiggers@kernel.org>

On Tue, Nov 17, 2026 at 08:10:29PM -0800, Eric Biggers wrote:
> This series is targeting libcrypto-next.  It can also be retrieved from:
> 
>     git fetch https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git aes-sparc-v1
> 
> This series migrates the SPARC64 crypto opcodes accelerated
> implementations of AES-ECB, AES-CBC, and AES-CTR into lib/crypto/.
> 
> This makes the AES-ECB, AES-CBC, and AES-CTR library APIs be properly
> accelerated on SPARC64, while still being available in the
> crypto_skcipher API via crypto/aes.c.  As usual, the longstanding issue
> of acceleration being disabled by default is also fixed.
> 
> After this, the only thing left in arch/sparc/crypto/ is Camellia.
> 
> Tested in QEMU (specifically commit 97c88c61d45d, which has Stian
> Halseth's recent changes that added support for the AES, CRC32C, SHA1,
> SHA256, and SHA512 opcodes) with the new ECB, CBC, and CTR KUnit tests
> (https://lore.kernel.org/r/20261116062849.1071038-1-ebiggers@kernel.org/)
> and CONFIG_CRYPTO_SELFTESTS_FULL=y, using Stian Halseth's patch that
> makes the SPARC kernel detect QEMU's support for the crypto opcodes
> (https://lore.kernel.org/r/20261117112914.2300417-1-stian@itx.no/).
> 
> Eric Biggers (4):
>   lib/crypto: sparc/aes: Add and use round key load helper
>   lib/crypto: sparc/aes-ctr: Migrate optimized code into library
>   lib/crypto: sparc/aes-ecb: Migrate optimized code into library
>   lib/crypto: sparc/aes-cbc: Migrate optimized code into library
> 
>  arch/sparc/crypto/Kconfig    |  10 -
>  arch/sparc/crypto/Makefile   |   2 -
>  arch/sparc/crypto/aes_glue.c | 344 ----------------------------------
>  crypto/aes.c                 |  13 +-
>  include/crypto/aes.h         |  39 ----
>  lib/crypto/sparc/aes.h       | 348 +++++++++++++++++++++++++++++++----
>  lib/crypto/sparc/aes_asm.S   |  24 ++-
>  7 files changed, 334 insertions(+), 446 deletions(-)
>  delete mode 100644 arch/sparc/crypto/aes_glue.c

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-next

- Eric
