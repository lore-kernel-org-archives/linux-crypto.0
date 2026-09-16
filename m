Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A95014B1B38;
	Wed, 16 Sep 2026 09:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789552739; cv=none; b=ihoTSu76gXsSU7vw920B9WUu60c1KLvOZhFPrDFoR9tztUd9TpZjnqItMgvd82ZdCgh3fEkg5baUZpzu3doU3xbdNPgmY7dW+gKJUYnZbluLcmYEADD44RgoovpO6/wLgiyG7sQGQxZEFZQqHvsgroi42aq2kf9DV4rLLUbJoNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789552739; c=relaxed/simple;
	bh=BaDvoADEk7NhvncuNIzYQnDIx5WcKPfabx66vRA+ryg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W6CZPp473Ke+dg6IOsyZSp4cmT5BOqDvabdZa35J55MSAtOJ4JGvsCLOgu6RQ1OXsWYSaKlTFPULDwRGdIreTmTZ9q3wpNomdH+8gCWJJlHvIOZoxk/EauMJjoyJPultoEltplewbAzs5gH74X/dpAZ5jbX6uPfQ6g2jdE9UZYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=Zmti8x/f; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="Zmti8x/f"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=t5cztt9MKZtPqdYlO4baTEO5Vle2tuGE6mKsXLkovOw=; 
	b=Zmti8x/f2YPXRY6k+t57/GEttI0I/6nuqJAo6/ZT9VXm8qbgNhmo1HsqrakIWi8UR4jTRnDDU64
	5EcQ9aaOyQrhz7wu8l4dKs+H/ScCEs2XosydmBhELkn4fmU8aqYonYPbx38V+tUCPHla+S/3Oz29c
	nPm35IgLKFZY7ObkM2zASsPSotJdqHb6Tc0SNSimOyS8ToqsFGH5ITy22pRMuGhNbX3phEz0xoyDb
	tJB7Yx/hJs15P+geDmgbV+D1bPlnuPbgvjeWOKa+QIzj7juafVEy/lddAG7ChYdOZBPshFKca+eU3
	dbDgyGuKPKt836HZpSqo6lin4+W8+DDaRbgQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x6mPd-0000000EZCZ-0sil;
	Wed, 16 Sep 2026 17:58:46 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 16 Sep 2026 19:58:45 +1000
Date: Wed, 16 Sep 2026 19:58:45 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Rosen Penev <rosenp@gmail.com>
Cc: linux-crypto@vger.kernel.org,
	Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
	Pankaj Gupta <pankaj.gupta@nxp.com>,
	Gaurav Jain <gaurav.jain@nxp.com>,
	"David S. Miller" <davem@davemloft.net>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crypto: caam: map job ring registers without claiming
 region
Message-ID: <aqpoVeecg-ObBUzQ@gondor.apana.org.au>
References: <20260901203736.13248-1-rosenp@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260901203736.13248-1-rosenp@gmail.com>

On Tue, Sep 01, 2026 at 01:37:36PM -0700, Rosen Penev wrote:
> devm_platform_ioremap_resource() ends up calling request_mem_region(),
> which fails with -EBUSY on i.MX SoCs:
> 
> There the job rings are modelled as sub-regions of their parent
> fsl,sec-v4.0 register window, and caam_probe() already reserves the
> whole window exclusively via devm_of_iomap() before the children are
> populated.  Every job ring therefore collides with its own parent and
> fails to probe, taking the hardware RNG offline (seen on i.MX6, i.MX7
> and i.MX8 boards such as colibri-imx7 and verdin-imx8mp).
> 
> Map the job ring registers with devm_ioremap() instead, which does not
> claim the (already owned) region.
> 
> Fixes: 9a955c0a7d11 ("crypto: caam - simplify probe resource and IRQ handling")
> Assisted-by: opencode:big-pickle
> Signed-off-by: Rosen Penev <rosenp@gmail.com>
> ---
>  drivers/crypto/caam/jr.c | 23 ++++++++++++++++++++---
>  1 file changed, 20 insertions(+), 3 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
