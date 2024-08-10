Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA8564409;
	Sat, 10 Aug 2024 06:22:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723270974; cv=none; b=kY8vLOrTeUAizLvkFls9fHmSzqjbhyKel7tASb6QVfRtMN1KxXGAHlZJGySbElfZbPjG47T6fCIyYAnsmchep7DW1si8L2jqg5qKKRCpUcNGFQc+FzipfwQ8XDimDLDcPwosNhHE4HYEHNaTHvp9chBBFjgj5fN1MF2QcD/3Qeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723270974; c=relaxed/simple;
	bh=ITcP6ZtzLHctCqAQCYxDVUrqZzTaMG4OUPO76xSRRnE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XeCPE1G/dtXjZETlpJigtSuanM9R+XRvV1uBqLB5uxTtLJVhXDixeseMS0WtjcNtQ511Jo0CaUbAw+XLpKziGYFpvEa6Xbbzm47yWtz6hOffDPdqFfH11scki2OtFEwd3+2hjo8ghev+mbELhUB5bI7FuXp35DU3DehpTMvIbCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1scfML-003iqt-2N;
	Sat, 10 Aug 2024 14:22:35 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 10 Aug 2024 14:22:34 +0800
Date: Sat, 10 Aug 2024 14:22:34 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Francesco Dolcini <francesco@dolcini.it>
Cc: Olivia Mackall <olivia@selenic.com>,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Bharat Bhushan <bbhushan2@marvell.com>
Subject: Re: [PATCH v1] hwrng: Kconfig - Enable by default CN10K driver if
 Thunder SoC is enabled
Message-ID: <ZrcHKl9eUYeQjrsN@gondor.apana.org.au>
References: <20240729113640.36031-1-francesco@dolcini.it>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240729113640.36031-1-francesco@dolcini.it>

On Mon, Jul 29, 2024 at 01:36:40PM +0200, Francesco Dolcini wrote:
> From: Francesco Dolcini <francesco.dolcini@toradex.com>
> 
> Before commit addea5858b66 ("hwrng: Kconfig - Do not enable by default
> CN10K driver") the Marvell CN10K Random Number Generator was always
> enabled when HW_RANDOM was enabled.
> 
> This was changed with that commit to prevent having this driver being
> always enabled on arm64. To prevent introducing regression with some old
> defconfig enable the driver when ARCH_THUNDER is enabled.
> 
> Fixes: addea5858b66 ("hwrng: Kconfig - Do not enable by default CN10K driver")
> Closes: https://lore.kernel.org/all/SN7PR18MB53144B37B82ADEEC5D35AE0CE3AC2@SN7PR18MB5314.namprd18.prod.outlook.com/
> Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>
> ---
>  drivers/char/hw_random/Kconfig | 1 +
>  1 file changed, 1 insertion(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
