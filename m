Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E83801917ED;
	Fri, 30 Aug 2024 10:39:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725014362; cv=none; b=tN2PqWwW+mhQ7PEDRgSkwBDlOaI3FXkqUFCNz98ujcJ6OIKjxhDW6KyXF8dmt4aliuidnF5xl+bJjMHyyLhjK8fpgsAf5PNnCbTaGdiZd/DPSPgzGAlrNrE6Z2/hmqAZsuuQiWeqJ8WqdSAAnnQ7+94dY8TxK4NuiwXcoGt5EVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725014362; c=relaxed/simple;
	bh=m+fLPyaYlS1twH8qQ8AV1VpgxFqc6IYa1hsdbPeQLy4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rcuCXCd0u7tbKN7gkXTB/nBOohcFv+rNbJVan85v+ZyD6k/wF1G9uaq+a+yE5xTcNu1o4LKF4GybIfdhik7qlMP2+xNGewWD/1ehFMLP1Vgoka38MBzgL0Xrc5CYl3H50hLw7Wk7NRWKU4F6ME2R4T4QSuF9BTylSY97NKGZI1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sjytQ-008UqR-0D;
	Fri, 30 Aug 2024 18:38:58 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 30 Aug 2024 18:38:57 +0800
Date: Fri, 30 Aug 2024 18:38:57 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Martin Kaiser <martin@kaiser.cx>
Cc: Aurelien Jarno <aurelien@aurel32.net>,
	Daniel Golle <daniel@makrotopia.org>, linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] hwrng: rockchip - two simple cleanups
Message-ID: <ZtGhQXIWB5uUN1pE@gondor.apana.org.au>
References: <20240821181235.22270-1-martin@kaiser.cx>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240821181235.22270-1-martin@kaiser.cx>

On Wed, Aug 21, 2024 at 08:12:33PM +0200, Martin Kaiser wrote:
> Two simple cleanups for the Rockchip RK3568 driver.
> 
> Martin Kaiser (2):
>   hwrng: rockchip - rst is used only during probe
>   hwrng: rockchip - handle devm_pm_runtime_enable errors
> 
>  drivers/char/hw_random/rockchip-rng.c | 17 +++++++++--------
>  1 file changed, 9 insertions(+), 8 deletions(-)
> 
> -- 
> 2.39.2

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
