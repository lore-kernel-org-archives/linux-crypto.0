Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F31A31D2F42
	for <linux-crypto@vger.kernel.org>; Mon, 11 Aug 2025 17:59:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754935175; cv=none; b=LJezrT9k3MpzTgIlgjyGweDWD/vKKbyJ+214a+M+Nlu30cjybfxmZXzKleB1Evp8LNKdy7nce9MomF552pQNDOCbTK7BMhOFIQ0B46m1OPBiuRfPTlM31da1UaQFvLppZKaUO7MjxOsRyVwZxxZH/le1zcWVLb0yQoY0ZfHSNo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754935175; c=relaxed/simple;
	bh=O36XC/9T/0nUNSaZaQSg5co3SZptxIWDslq4s9Yy6Wg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JbFYPLGsEnMOBl+MglYwHiB0YKAzPaH5d9vQ7oI2WE5p4vhcOSHsVzv9v53oO6vR4oXZjOcVA7jUvAdyn5FfAIfG+8Ttdbaq2Cub0HeHQsJm59f2LCX3vaQwjERoLzW/uSkoTvZqU4rw+WRlrC2AK2PSXSnyS6IpSqdnacfZm0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QpgsL80z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QpgsL80z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CE44C4CEED;
	Mon, 11 Aug 2025 17:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754935173;
	bh=O36XC/9T/0nUNSaZaQSg5co3SZptxIWDslq4s9Yy6Wg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QpgsL80zfAWC9Q7wUtwGVXWf09/smmj5mEe8GWsf5YTbUjAqb1H2Wt4HFoZfAv5NO
	 BDRJ3wO6hMDWThearbyS+BG8a7kFVP78/2v3qzXdmwZSIYBbMIYm8Dhx5KfivtSGMg
	 ofWLMknobkQhjHnkbQDNGbT2DDchlQrlk+pkX/i76pGVRdWzEGl2VXYg4eaXwNApne
	 hTMZu21BjoE+QTwUrlt2fA58YHLa8iO3NyjHoxZ5r6NWfPNMGK/VPJNICKSbJ5d4YT
	 NCHufIgUaAApdjN+052AiTTqpMtKOJjT1CfRsiYTxunavNqRjE728WYAoBJ+WhDKE2
	 kDx6D3kbHABiA==
Date: Mon, 11 Aug 2025 10:58:32 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	linux-arm-kernel@lists.infradead.org, x86@kernel.org
Subject: Re: [PATCH] lib/crypto: sha512: Use underlying functions instead of
 crypto_simd_usable()
Message-ID: <20250811175832.GE1268@sol>
References: <20250731223651.136939-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250731223651.136939-1-ebiggers@kernel.org>

On Thu, Jul 31, 2025 at 03:36:51PM -0700, Eric Biggers wrote:
> Since sha512_kunit tests the fallback code paths without using
> crypto_simd_disabled_for_test, make the SHA-512 code just use the
> underlying may_use_simd() and irq_fpu_usable() functions directly
> instead of crypto_simd_usable().  This eliminates an unnecessary layer.
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>  lib/crypto/arm/sha512.h   | 5 ++---
>  lib/crypto/arm64/sha512.h | 5 ++---
>  lib/crypto/riscv/sha512.h | 4 +---
>  lib/crypto/x86/sha512.h   | 4 +---
>  4 files changed, 6 insertions(+), 12 deletions(-)

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-next

- Eric
