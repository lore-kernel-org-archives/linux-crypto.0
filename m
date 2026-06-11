Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19B932EF64F;
	Thu, 11 Jun 2026 08:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781167823; cv=none; b=eVFjsg2NVE7OCKX+aA4OF2lNGGSdwNM6zyCehf2jzkoXD2eEkkrOuwrYcCLTN5wZzg84teYhw/eRuYN/LGujwb4sca4kr4CgS8lzSU5hZgs0wnD3l+O57CvL9PorJxu2vPRiUpZrZ9LHm9EyAgrR20SoFmOIi5u9WDitCTp88yM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781167823; c=relaxed/simple;
	bh=pu0/COHPP5xjppQgRCQiJJw1A2H5VoRVve7LGDMGC7Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FOU7vIGk/xChLANaIlj4Kkm+I1lJ1kNmdeZTQLFqV62n4gbPTiA5ocKHB6ev+EgAFsq2sjI22M5BgDWd9vKg4fQqw2zz+1Ky1O3QoPMZsGKuJHuctXLGNwqK0lkZm/1vDfSJCr3kfM7j4ZcaR5dYX2TLGX1XanVUfOEhIXHG/XA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=VIS8Haro; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="VIS8Haro"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=PjjBDYZgAOLy519yfjF2xCKXOfk72HnUEqbs8BnxJS0=; 
	b=VIS8HaroQpuYLrtH87PuT4FHco2zbtekpp4kSzsrnfHYWyT8Ci9BSSgvxUxV/ALZIZKQq/cGOrY
	sSTTphh/Ck/N8Oh695PxTHGroaqJhPMn8an1Fg3AmJ1d8nO9Exm2CkBfaB0XIbA22ofKkE5mqD1XE
	uAz5JCouT/DU14Sj+wCCx++mPBQT8xfWBKzdG8+NEHaE/N85jLvYOQf+ZiCYBKOkecjG116F5Eb/h
	Mik51+FhdSbaBXAf6uso2ZQloU/vZl7cym4wXZBLCMn3zepmUdxd/pAmhlv4AioxKs/AsozX73o0Z
	P8lT52kZCWM02wnUhahWs20Ywrpd92dOLdgA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wXb7B-00000004XW1-2BCk;
	Thu, 11 Jun 2026 16:50:18 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 11 Jun 2026 16:50:17 +0800
Date: Thu, 11 Jun 2026 16:50:17 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-sunxi@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Chen-Yu Tsai <wens@kernel.org>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Samuel Holland <samuel@sholland.org>,
	Corentin Labbe <clabbe.montjoie@gmail.com>, stable@vger.kernel.org,
	Tianchu Chen <flynnnchen@tencent.com>
Subject: Re: [PATCH v2] crypto: sun4i-ss - Remove insecure and unused rng_alg
Message-ID: <aip2yUWWUlUbdi8w@gondor.apana.org.au>
References: <20260601160757.79645-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260601160757.79645-1-ebiggers@kernel.org>

On Mon, Jun 01, 2026 at 04:07:57PM +0000, Eric Biggers wrote:
> Remove sun4i_ss_rng, as it is insecure and unused:
> 
> - It has multiple vulnerabilities.  sun4i_ss_prng_seed() is missing
>   locking and has a buffer overflow.  sun4i_ss_prng_generate() fails to
>   fill the entire buffer with cryptographic random bytes, because it
>   rounds the destination length down and also doesn't actually wait for
>   the hardware to be ready before pulling bytes from it.
> 
> - No user of this code is known.  It's usable only theoretically via the
>   "rng" algorithm type of AF_ALG.  But userspace actually just uses the
>   actual Linux RNG (/dev/random etc) instead.  And rng_algs don't
>   contribute entropy to the actual Linux RNG either.  (This may have
>   been confused with hwrng, which does contribute entropy.)
> 
> The sun4i_ss_prng_seed() buffer overflow was reported by Tianchu Chen
> and discovered by Atuin - Automated Vulnerability Discovery Engine
> 
> There's no point in fixing all these vulnerabilities individually when
> this is unused code, so let's just remove it.
> 
> Fixes: b8ae5c7387ad ("crypto: sun4i-ss - support the Security System PRNG")
> Cc: stable@vger.kernel.org
> Reported-by: Tianchu Chen <flynnnchen@tencent.com>
> Closes: https://lore.kernel.org/r/af749a8447bd7f0e9dd26ca6c87e9c6afecb09d9@linux.dev/
> Acked-by: Corentin LABBE <clabbe.montjoie@gmail.com>
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
> 
> This patch is targeting crypto/master
> 
> v2: rebased onto crypto/master, and added Acked-by and Reported-by
> 
>  arch/arm/configs/sunxi_defconfig              |  1 -
>  drivers/crypto/allwinner/Kconfig              |  8 ---
>  drivers/crypto/allwinner/sun4i-ss/Makefile    |  1 -
>  .../crypto/allwinner/sun4i-ss/sun4i-ss-core.c | 36 ----------
>  .../crypto/allwinner/sun4i-ss/sun4i-ss-prng.c | 69 -------------------
>  drivers/crypto/allwinner/sun4i-ss/sun4i-ss.h  | 20 ------
>  6 files changed, 135 deletions(-)
>  delete mode 100644 drivers/crypto/allwinner/sun4i-ss/sun4i-ss-prng.c

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
