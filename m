Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A01345016
	for <linux-crypto@vger.kernel.org>; Sat,  2 Nov 2024 10:25:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730543140; cv=none; b=OKVBu2B+pNHAab/8kmBoppYJbv6ZQqDELisT6XG9Lkdp8xiuU094bkBVuTDiXYnQj4hy1mBUHLq/+Q+DufA0QECJfir5LEoTeMasIJrPK8FNSxFxiSoeed7aGV4fkWY+JyNqerfY4loUzTbT+JJHhiWhSWDHxvdREtwXOjs72JM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730543140; c=relaxed/simple;
	bh=o8VHykK9vYx3bdI8FsAd7zlHCai9QslylBRrKlVE4yI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BWuORRMCl3EzqjJFzTzFIn05t4007S+i2tOrRGXb2YMEImzJSak6hR4LMTTDoYEzZrM6sh54GlEfAwOzsI0qS9wq2gwUWSuEawT+LRg4vD6Fz9vEIHhxk8ol/QsFs+v0lvdDOZrw1H7gcGtCWGYyRJoY8mp9kF8BIDwA4hpWGiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=ADQPWn4w; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="ADQPWn4w"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=dkH0qn6q6d3l0iuWD1udV68BfcKwoL7AO2p3JDE9LQk=; b=ADQPWn4w2Wmoxy0ZTcIaCjtbui
	vElPXhXdMW45XIY3Bk3lwGFDN9U2Gahz5WNaUpEXnpUVgR/X8Sr+8cgSABc7qNgNrToJlofQOegWi
	CUVnsrLvtx+nTBAQjo/XFJeoRUrrqKazwcNwXxBTQNA5EuMT6vwCPKW3tLJw4JmgpxnxsqNZZaNJn
	/3j38fejkWTsOD/v3eNFsEha167T6yuG0srhw2Fg1rhKobp8NRnPGZTQkO+78ms6BNKsJgobYlA2I
	wTCw4RN2MgQ1nzz5d1QlUnjBC2SRfqpAEC/jIMRsGNxKG1XVDVqaoNJaN4CalfbFq0y8tj4zJZ5VB
	X9Y0LGvQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1t7BJv-00Dy2G-2J;
	Sat, 02 Nov 2024 18:25:28 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 02 Nov 2024 18:25:27 +0800
Date: Sat, 2 Nov 2024 18:25:27 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <u.kleine-koenig@baylibre.com>
Cc: Olivia Mackall <olivia@selenic.com>, linux-crypto@vger.kernel.org
Subject: Re: [PATCH] hwrng - Switch back to struct platform_driver::remove()
Message-ID: <ZyX-F1c77hfUSDVu@gondor.apana.org.au>
References: <20241021104854.411313-2-u.kleine-koenig@baylibre.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20241021104854.411313-2-u.kleine-koenig@baylibre.com>

On Mon, Oct 21, 2024 at 12:48:55PM +0200, Uwe Kleine-König wrote:
> After commit 0edb555a65d1 ("platform: Make platform_driver::remove()
> return void") .remove() is (again) the right callback to implement for
> platform drivers.
> 
> Convert all platform drivers below drivers/char/hw_random to use
> .remove(), with the eventual goal to drop struct
> platform_driver::remove_new(). As .remove() and .remove_new() have the
> same prototypes, conversion is done by just changing the structure
> member name in the driver initializer.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
> ---
> Hello,
> 
> given the simplicity of the individual changes I do this all in a single
> patch. I you don't agree, please tell and I will happily split it.
> 
> It's based on today's next, feel free to drop changes that result in a
> conflict when you come around to apply this. I'll care for the fallout
> at a later time then. (Having said that, if you use b4 am -3 and git am
> -3, there should be hardly any conflict.)
> 
> Note I didn't Cc: all the individual driver maintainers to not trigger
> sending limits and spam filters.
> 
> Best regards
> Uwe
> 
>  drivers/char/hw_random/atmel-rng.c      | 2 +-
>  drivers/char/hw_random/cctrng.c         | 2 +-
>  drivers/char/hw_random/exynos-trng.c    | 2 +-
>  drivers/char/hw_random/ingenic-rng.c    | 2 +-
>  drivers/char/hw_random/ks-sa-rng.c      | 2 +-
>  drivers/char/hw_random/mxc-rnga.c       | 2 +-
>  drivers/char/hw_random/n2-drv.c         | 2 +-
>  drivers/char/hw_random/npcm-rng.c       | 2 +-
>  drivers/char/hw_random/omap-rng.c       | 2 +-
>  drivers/char/hw_random/stm32-rng.c      | 2 +-
>  drivers/char/hw_random/timeriomem-rng.c | 2 +-
>  drivers/char/hw_random/xgene-rng.c      | 2 +-
>  12 files changed, 12 insertions(+), 12 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
