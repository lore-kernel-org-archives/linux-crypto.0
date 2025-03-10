Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 670DB22D4C3;
	Mon, 10 Mar 2025 17:24:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627445; cv=none; b=Htd19FjAioumAfa3x3Qe/4edY1LEKLZ34PRxUlF+m3UvJDUZzGvI54yU0MyxVT5e96qC5vdPqOH/IEmARjTrRkAhiDSYJjNiejdJlrU2DbAsEmxskLtYJJyf+VpV1wQcOy8PWJsEVL1K/gZpiath2S401DJkpEDMhXE2Jg6+4K4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627445; c=relaxed/simple;
	bh=vgO6p1/iX1sD311S5rusvTmrKmd1302HPDYV0L8gTLo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ov4Gve8DR9sbFvM3jfaalfulOAxlHbYcyBwwxCeJK2VbYYjv38EvB27pzxf26gAGQOMtoKEi6DhA0+eer0t2z2B00iStwtY1Of9dsQNMVE1ZW3mcuCL22ZgJma3k9rMEBBdXJl4/sN1OHiDVjbDGHtObxpQ6tp0P4/2kG8Dg2/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y1feot6H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y1feot6H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB3CDC4CEEC;
	Mon, 10 Mar 2025 17:24:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741627445;
	bh=vgO6p1/iX1sD311S5rusvTmrKmd1302HPDYV0L8gTLo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Y1feot6HnbgmPnB940s6mPSzWLFcChSAFfajbWD5XtQPef5Pzhn7WjFjkwcaeQfFB
	 xZ5C4sRl5+f4ajBtt4r2SwQVRGFl1Z/2knI98Omnhw0YXhSnDXwCsSXdlf8fBiQqnL
	 LCZcYeExaoJOdqx6IwSDm9OPMqJe3kGNh25KCcVkGpzP8vEByMZNezB0GHXmPUk9mN
	 9DyIdmEljU1v402Yx6Ru+X2n8b1aKnpVci34v5Pp1jfSuPsIiRKUnQZpgKdX0GNxzT
	 IMowtnowj0TFB2nPg5pOyeWu28ht2uZG4gLWhhG5LhXnooecW/ypAIPL8Hxb/qY2mn
	 R2p4kVDr2kXwA==
Date: Mon, 10 Mar 2025 10:24:03 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Arnd Bergmann <arnd@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Arnd Bergmann <arnd@arndb.de>, Ard Biesheuvel <ardb@kernel.org>,
	Lukas Wunner <lukas@wunner.de>,
	Stephan Mueller <smueller@chronox.de>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] crypto: fix dependencies on lib/crypto modules
Message-ID: <20250310172403.GD1701@sol.localdomain>
References: <20250310132647.3256818-1-arnd@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250310132647.3256818-1-arnd@kernel.org>

On Mon, Mar 10, 2025 at 02:26:39PM +0100, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> The crypto subsystem helpers for chacha, poly1305 and curve25519 were
> changed to select the 'INTERNAL' Kconfig symbols, but the code references
> the generic implementation instead, which leads to a link failure when
> nothing else selects it.
> 
> ld.lld-21: error: undefined symbol: chacha_crypt_generic
> >>> referenced by chacha_generic.c
> >>>               crypto/chacha_generic.o:(chacha_stream_xor) in archive vmlinux.a
> 
> ld.lld-21: error: undefined symbol: poly1305_final_generic
> >>> referenced by poly1305_generic.c
> >>>               crypto/poly1305_generic.o:(crypto_poly1305_final) in archive vmlinux.a
> 
> The INTERNAL version turns on the architecture specific optimized cipher,
> which normally usually also enables the generic version, but this is not
> the case on all architectures. Selecting only the GENERIC version here is
> not sufficient since the architecture specific ones are now hidden symbols
> and are only built when the INTERNAL symbol is also available.
> 
> Fixes: 17ec3e71ba79 ("crypto: lib/Kconfig - Hide arch options from user")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  crypto/Kconfig | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/crypto/Kconfig b/crypto/Kconfig
> index aac27a4668fd..76693e3edff8 100644
> --- a/crypto/Kconfig
> +++ b/crypto/Kconfig
> @@ -317,6 +317,7 @@ config CRYPTO_ECRDSA
>  config CRYPTO_CURVE25519
>  	tristate "Curve25519"
>  	select CRYPTO_KPP
> +	select CRYPTO_LIB_CURVE25519_GENERIC
>  	select CRYPTO_LIB_CURVE25519_INTERNAL
>  	help
>  	  Curve25519 elliptic curve (RFC7748)
> @@ -615,6 +616,7 @@ config CRYPTO_ARC4
>  
>  config CRYPTO_CHACHA20
>  	tristate "ChaCha"
> +	select CRYPTO_LIB_CHACHA_GENERIC
>  	select CRYPTO_LIB_CHACHA_INTERNAL
>  	select CRYPTO_SKCIPHER
>  	help
> @@ -936,6 +938,7 @@ config CRYPTO_POLYVAL
>  config CRYPTO_POLY1305
>  	tristate "Poly1305"
>  	select CRYPTO_HASH
> +	select CRYPTO_LIB_POLY1305_GENERIC
>  	select CRYPTO_LIB_POLY1305_INTERNAL
>  	help
>  	  Poly1305 authenticator algorithm (RFC7539)

Looks the same as
https://lore.kernel.org/linux-crypto/Z8UdUoaKtDKzgPph@gondor.apana.org.au/ which
was already applied.

- Eric
