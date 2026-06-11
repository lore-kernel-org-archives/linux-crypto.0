Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FB6A1A6806;
	Thu, 11 Jun 2026 08:49:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781167771; cv=none; b=sq2wZzyZey/QfldelN1fll0Zv2/mqKn/xEUlQJAEgfoolUD+htlJI7Xy5rwluHp8N+BGbBbK90jbBEwWKZuaaDnoHRytxjao0vE9FkIebBfa6oBiyDr+l03JKo5lgS+war6khgKBmoD6GuOoFbKwURZBCIu9Bw6qa+bVf4MeETQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781167771; c=relaxed/simple;
	bh=E1Gr1Id4w3mQ5K1sQxgzJR9XvmddJt0qNOu3eB+wJs8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MVROY3revT1IUFBrxzkMw9b0Rb/Fr4h+GuzKr0TmFtOme6iGZQu1CP5kohMl51pFfpPe6mZ9VHWJwPXu4l38N8VvWQ5KojUTU25oHR3pm8hz6xkdhZsnWyU47lMrQWiyLovKfrwidwMZsfchjGrBF690jmn9aeay4JmNOc4L4mw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=D+zVFGlY; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="D+zVFGlY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=mjrPPBq+iR4nnSkwtllKiL42WjmcB34JK/l+415Ki0c=; 
	b=D+zVFGlYVBiAlCc+qMJqwMjeeX27SaN7ui+bRf5XgLO1qdr5xH3LJ3PpF13CZDsMDT7cWQB4Yay
	PMcfuIrOC9tOyZzO4g74R52TPN9cWtkMi4Y6HpxITewMspw4xOVKyi4f0oS8dMXmjryrEKtJ8mwnN
	L96by4VuAvPAyIO+xzFFyVMn6Ynp/EBdq/dwUrv3mMejw1OEZgeZYbxcmMJ0EFO3wuqdZA+QehUwA
	M7nKdbxyMzkz3J0bJeXkUzhFu/w33VCFxD1goHWWxNN/6ujoIhxShyyksnwrt/6GFcxXXTaa9d+Df
	ig6MF0/i53VK2V9A6gS5fPN+rdqPp6FSppLg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wXb6N-00000004XVq-0UA2;
	Thu, 11 Jun 2026 16:49:28 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 11 Jun 2026 16:49:27 +0800
Date: Thu, 11 Jun 2026 16:49:27 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Mounika Botcha <mounika.botcha@amd.com>,
	Harsh Jain <h.jain@amd.com>, Olivia Mackall <olivia@selenic.com>,
	Michal Simek <michal.simek@amd.com>,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/4] Xilinx TRNG fix and simplification
Message-ID: <aip2l1pwMY4UDBdA@gondor.apana.org.au>
References: <20260531191738.55843-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260531191738.55843-1-ebiggers@kernel.org>

On Sun, May 31, 2026 at 12:17:34PM -0700, Eric Biggers wrote:
> This series fixes and greatly simplifies the Xilinx TRNG driver by:
> 
> - Removing the gratuitous crypto_rng interface, leaving just hwrng which
>   is the one that actually matters.
> 
> - Replacing the really complicated AES based entropy extraction
>   algorithm with a much simpler one.
> 
> Note that this mirrors similar changes in other drivers.
> 
> Eric Biggers (4):
>   crypto: xilinx-trng - Remove crypto_rng interface
>   crypto: xilinx-trng - Fix return value of xtrng_hwrng_trng_read()
>   crypto: xilinx-trng - Replace crypto_drbg_ctr_df() with HMAC-SHA512
>   hwrng: xilinx - Move xilinx-rng into drivers/char/hw_random/
> 
>  MAINTAINERS                                   |   2 +-
>  arch/arm64/configs/defconfig                  |   2 +-
>  crypto/Kconfig                                |   5 -
>  crypto/Makefile                               |   2 -
>  crypto/df_sp80090a.c                          | 222 ------------------
>  drivers/char/hw_random/Kconfig                |  11 +
>  drivers/char/hw_random/Makefile               |   1 +
>  .../xilinx => char/hw_random}/xilinx-trng.c   | 134 ++---------
>  drivers/crypto/Kconfig                        |  13 -
>  drivers/crypto/xilinx/Makefile                |   1 -
>  include/crypto/df_sp80090a.h                  |  53 -----
>  11 files changed, 37 insertions(+), 409 deletions(-)
>  delete mode 100644 crypto/df_sp80090a.c
>  rename drivers/{crypto/xilinx => char/hw_random}/xilinx-trng.c (75%)
>  delete mode 100644 include/crypto/df_sp80090a.h
> 
> 
> base-commit: 5624ea54f3ba5c83d2e5503411a31a8be0278c1e
> prerequisite-patch-id: 07e982b663ac3f8312ca524f6b91b5b38661df5e
> prerequisite-patch-id: 72064361a8f36e015ab0b7e1fa4d364b40d90506
> prerequisite-patch-id: 8978b8e0db7f47935e5f6f0aff14a97f55d3073c
> prerequisite-patch-id: 6aa0e3e93a008279d71e535a3d0cf48643f55e19
> -- 
> 2.54.0

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
