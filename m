Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73C9331AF2D;
	Mon,  3 Nov 2025 17:02:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762189338; cv=none; b=Wr3+WS+lH6D7upKYHMdhAjfK9FUjEW/9/ilCYQLk+cq4o73I7rY58u8hkXXDG54n5PZMazGLazJBnBodUjysiC9+Oakp24mhlE0zJ37uHvkBqzVQfFFom85ERinEdkSzx8i+Ex26kAkwpgw7Rci8a+/XoMj2JejZwj86Dxhi4k4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762189338; c=relaxed/simple;
	bh=yjR21Qom22HfQB8jvNamOtxWgim20V+YEqdhmK6D0uc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tsP2jhafMaiZ7zimC1UNf2azQ3M/Atc2qab3z8HaKIoU8USFNyDYtLpiFiIh0V6C5fHF2epSHbpa4MFWHIMI9RETIEAJeJ67hXWLIcaiVKvYRjSmX51IziEH69JY5wF5eJ/wIHbv34nSjxfa3HQhO15EiplSqFLm2jou58wL40Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nRYq8Q+F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nRYq8Q+F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDE8DC4CEE7;
	Mon,  3 Nov 2025 17:02:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762189338;
	bh=yjR21Qom22HfQB8jvNamOtxWgim20V+YEqdhmK6D0uc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nRYq8Q+F2KoYCg/lt/cnpSNNLOIu12w45BBFUcxWYT6opicphsMRkWjAeAl5RIMxc
	 hG0a2W9CDIYff+S7FWjxdiPWGjQuCyCUyNgtBgvdCd1mPeZfhRNFm1VrHfgSxNfO/U
	 FiUOZL7tBP6EjRMNmQlbQR+bCT6I4Cby9y8coDJjHUxfcSpT7C9fBZ2nsANq+gRmqi
	 KTbTm5ChK7wHHnvtgUMinzOMDD/gUXbZf8BM/Q3qmqXAL05+CZPsGpgistnuiSwxXh
	 +uyDI6BO3gSKoiEYvP0ipxfc1vzwqb/hd90EA8MYAukMb/rfpbF979uHIOXgauR4YP
	 6BZNmAf9VWpBg==
Date: Mon, 3 Nov 2025 09:00:36 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Nathan Chancellor <nathan@kernel.org>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] lib/crypto: curve25519-hacl64: Fix older clang KASAN
 workaround for GCC
Message-ID: <20251103170036.GD1735@sol>
References: <20251102-curve25519-hacl64-fix-kasan-workaround-v1-1-6ec6738f9741@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251102-curve25519-hacl64-fix-kasan-workaround-v1-1-6ec6738f9741@kernel.org>

On Sun, Nov 02, 2025 at 09:35:03PM -0500, Nathan Chancellor wrote:
> Commit 2f13daee2a72 ("lib/crypto/curve25519-hacl64: Disable KASAN with
> clang-17 and older") inadvertently disabled KASAN in curve25519-hacl64.o
> for GCC unconditionally because clang-min-version will always evaluate
> to nothing for GCC. Add a check for CONFIG_CC_IS_GCC to avoid the
> workaround, which is only needed for clang-17 and older.
> 
> Additionally, invert the 'ifeq (...,)' into 'ifneq (...,y)', as it is a
> little easier to read and understand the intention ("if not GCC or at
> least clang-18, disable KASAN").
> 
> Cc: stable@vger.kernel.org
> Fixes: 2f13daee2a72 ("lib/crypto/curve25519-hacl64: Disable KASAN with clang-17 and older")
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
>  lib/crypto/Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/lib/crypto/Makefile b/lib/crypto/Makefile
> index bded351aeace..372b7a12b371 100644
> --- a/lib/crypto/Makefile
> +++ b/lib/crypto/Makefile
> @@ -90,7 +90,7 @@ else
>  libcurve25519-$(CONFIG_CRYPTO_LIB_CURVE25519_GENERIC) += curve25519-fiat32.o
>  endif
>  # clang versions prior to 18 may blow out the stack with KASAN
> -ifeq ($(call clang-min-version, 180000),)
> +ifneq ($(CONFIG_CC_IS_GCC)$(call clang-min-version, 180000),y)
>  KASAN_SANITIZE_curve25519-hacl64.o := n
>  endif

Thanks for catching this!

Using CONFIG_CC_IS_GCC == "" to check for clang seems a bit odd when
there's already a CONFIG_CC_IS_CLANG available.

How about we do it like this?

    ifeq ($(CONFIG_CC_IS_CLANG)_$(call clang-min-version, 180000),y_)

- Eric
