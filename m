Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22270325486;
	Tue,  4 Nov 2025 17:40:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762278021; cv=none; b=IPPT6j529e6m6X+fq7T7wVNqwKCpfrlWehAN36Rk2b8pinqUGBDbZ4PhI11BuQbouLcNdv11zezpPurwu9llZSt5a0T+yPPTkkfRvEVg9F2K2CQe8fmP0O33Vwvsfs6jUQ/NMbmIRa2qXv2E6JSyCMR3GzRZgPhOF2v+iPqE0As=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762278021; c=relaxed/simple;
	bh=jLFk4Y6OFpoA5DN16cKx2h4QGnpJhrmi2KNJb1Q4CLo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aXPVo5VjTQW7PygvA5rB6uQY5Oc4oAHV5Y91qWqTNVtLEHw0PI27i7/eym29PX18UHWRmFa6LSzOuEKF247gITelvNbKzTjldm6jgfcW+68fFRZlde6uUf8SKrSd6k3pKxVKIhx+b+n7SLbnfZNcfT0t4dDNNQPsM7trfG1Gv18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m+52d2y0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m+52d2y0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E8F9C4CEF7;
	Tue,  4 Nov 2025 17:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762278020;
	bh=jLFk4Y6OFpoA5DN16cKx2h4QGnpJhrmi2KNJb1Q4CLo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=m+52d2y0+SLRgcKqq0nPEk4wqR/uLJ7ZFXMfJWoqbdTiTJpy3X8yxWugI/H6QMocH
	 KgQIN5YjoODp3vVdm4WsXhdJTdIcNbM6vn0E90gHMnYkwrRSiMHRKIEXJIyYI2wgdd
	 dmZvxRnH07MTVq/KjiEbaBhfda83FcM6WpXGgU4HpH3Sdkmo3woZdW0yPVdSjI2ZJZ
	 tUx4SdWW2Qbds1vvSv7lPJsoDb16HTY/VzlV5NW5OnOn6zuGYp0cLlHR13nHhNtagM
	 o7kTVoiuTkrlmXfHpkBjwewNOXLEiEQ0QRb0nnVceIeMv+86W8LjZJnMNYadgumtX5
	 aBh3vKWc1aDhw==
Date: Tue, 4 Nov 2025 09:38:40 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Nathan Chancellor <nathan@kernel.org>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] lib/crypto: curve25519-hacl64: Fix older clang KASAN
 workaround for GCC
Message-ID: <20251104173840.GB1780@sol>
References: <20251103-curve25519-hacl64-fix-kasan-workaround-v2-1-ab581cbd8035@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251103-curve25519-hacl64-fix-kasan-workaround-v2-1-ab581cbd8035@kernel.org>

On Mon, Nov 03, 2025 at 12:11:24PM -0700, Nathan Chancellor wrote:
> Commit 2f13daee2a72 ("lib/crypto/curve25519-hacl64: Disable KASAN with
> clang-17 and older") inadvertently disabled KASAN in curve25519-hacl64.o
> for GCC unconditionally because clang-min-version will always evaluate
> to nothing for GCC. Add a check for CONFIG_CC_IS_CLANG to avoid applying
> the workaround for GCC, which is only needed for clang-17 and older.
> 
> Cc: stable@vger.kernel.org
> Fixes: 2f13daee2a72 ("lib/crypto/curve25519-hacl64: Disable KASAN with clang-17 and older")
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
> Changes in v2:
> - Check for CONFIG_CC_IS_CLANG explicitly instead of using
>   CONFIG_CC_IS_GCC as "not clang" (Eric).
> - Link to v1: https://patch.msgid.link/20251102-curve25519-hacl64-fix-kasan-workaround-v1-1-6ec6738f9741@kernel.org
> ---
>  lib/crypto/Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/lib/crypto/Makefile b/lib/crypto/Makefile
> index bded351aeace..d2845b214585 100644
> --- a/lib/crypto/Makefile
> +++ b/lib/crypto/Makefile
> @@ -90,7 +90,7 @@ else
>  libcurve25519-$(CONFIG_CRYPTO_LIB_CURVE25519_GENERIC) += curve25519-fiat32.o
>  endif
>  # clang versions prior to 18 may blow out the stack with KASAN
> -ifeq ($(call clang-min-version, 180000),)
> +ifeq ($(CONFIG_CC_IS_CLANG)_$(call clang-min-version, 180000),y_)
>  KASAN_SANITIZE_curve25519-hacl64.o := n
>  endif

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-fixes

- Eric
