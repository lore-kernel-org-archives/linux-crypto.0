Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAA6E32ED25;
	Tue,  4 Nov 2025 17:39:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762277970; cv=none; b=GH0bJLhb9/TPcDP63UeD3UxuraUl6qTqqGGBmInvGX6GnfaLQmGSijKiFsA5J0qs/TEbkvZFMrS6uW7wr+n7UtzUe3tH1EV7NvTB3ZW5Euooac6EqIqYV2qKaLwhrtLzhxLpKEsUkaoSW/RPUtwrsC3PVp9NJxK85GlqjHetLbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762277970; c=relaxed/simple;
	bh=dFzXmIcBVlOGJZ/dA9ocxVm/GMTXIf6nZ4evM0sDxuA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EHLmhFtWgrrWEY/uceTMNJXY1qsd8NAkjumDfpPDHIHE+OL3eR2sIPOByXrVonSRUt2YRXtRUW5ulACVp8xakrMrILf9qHdYYhZH0nbtI0Dsb1enQ/FdvledoJQR+UGRaYSh3J9LXs0aFA34hbkUTTWGv77YlmEnEhL0W4W8+do=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=os7nvEy1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="os7nvEy1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14414C4CEF7;
	Tue,  4 Nov 2025 17:39:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762277970;
	bh=dFzXmIcBVlOGJZ/dA9ocxVm/GMTXIf6nZ4evM0sDxuA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=os7nvEy1/d3dzd2cJwR05Bti4sEOxgANxbGmOd9Yx2rsUDSsFAQ+qsZjTzAhbTaVP
	 nY1NXejKptIuqUc0mdWD68OjE667k55JI0s83nphDygfBrlUb8P93QJ8LOMK6HyCCh
	 xnLS0q2bEMpVIQFRWhlTkmJ9q0YCySOsLr/I3frvkerAp0h12MzExYtQoIGtUVzzHX
	 3HPpNjZSua69NZswC6eUjOTFDkoNSmPceETGRkgZECW0U0p+AMGXiDahJBQgsB68IO
	 FY9g1Uj2zVJyh4CrdkPrG7hzEEmzVdLfUHB/ELA7QHN1IMvDfNr3+CPiauXanXFasN
	 2fAdfYr/a97XQ==
Date: Tue, 4 Nov 2025 09:37:49 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org
Subject: Re: [PATCH] lib/crypto: arm/curve25519: Disable on CPU_BIG_ENDIAN
Message-ID: <20251104173749.GA1780@sol>
References: <20251104054906.716914-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251104054906.716914-1-ebiggers@kernel.org>

On Mon, Nov 03, 2025 at 09:49:06PM -0800, Eric Biggers wrote:
> On big endian arm kernels, the arm optimized Curve25519 code produces
> incorrect outputs and fails the Curve25519 test.  This has been true
> ever since this code was added.
> 
> It seems that hardly anyone (or even no one?) actually uses big endian
> arm kernels.  But as long as they're ostensibly supported, we should
> disable this code on them so that it's not accidentally used.
> 
> Note: for future-proofing, use !CPU_BIG_ENDIAN instead of
> CPU_LITTLE_ENDIAN.  Both of these are arch-specific options that could
> get removed in the future if big endian support gets dropped.
> 
> Fixes: d8f1308a025f ("crypto: arm/curve25519 - wire up NEON implementation")
> Cc: stable@vger.kernel.org
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
> 
> This patch is targeting libcrypto-fixes
> 
>  lib/crypto/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/lib/crypto/Kconfig b/lib/crypto/Kconfig
> index 8886055e938f..16859c6226dd 100644
> --- a/lib/crypto/Kconfig
> +++ b/lib/crypto/Kconfig
> @@ -62,11 +62,11 @@ config CRYPTO_LIB_CURVE25519
>  	  of the functions from <crypto/curve25519.h>.
>  
>  config CRYPTO_LIB_CURVE25519_ARCH
>  	bool
>  	depends on CRYPTO_LIB_CURVE25519 && !UML && !KMSAN
> -	default y if ARM && KERNEL_MODE_NEON
> +	default y if ARM && KERNEL_MODE_NEON && !CPU_BIG_ENDIAN
>  	default y if PPC64 && CPU_LITTLE_ENDIAN
>  	default y if X86_64
>  
>  config CRYPTO_LIB_CURVE25519_GENERIC
>  	bool
> 
> base-commit: 1af424b15401d2be789c4dc2279889514e7c5c94
> -- 
> 2.51.2
> 

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-fixes

- Eric
