Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43B3D1847
	for <linux-crypto@vger.kernel.org>; Fri,  7 Jun 2024 11:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717761447; cv=none; b=Wn3j8wPIUA+lmBtE8lI1TqWAv0uDV3UWSWJIG2xNxd8io5kRekZJTA9xpWZXUwZncaK63etff4iuii7vYvGcqM7oS21IjjC0d5mdJ+at0FD8JG1Dq+GJhZ6J5t8zOuN+CDKXwK2Ep4DyqbFdre7ze0/8vx1O329BPoqwP0aRqOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717761447; c=relaxed/simple;
	bh=cqxQb3r/Gmg5ET4c6Do2PWaJw07WzZwt4ZNFF9AbvMY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YYw8OFQKfVwrRTvEWqds6RfMMBj93/lLfuqmUrYZE0CAcYyRMFf/JFVa39f1/4aukRlYO2vEg2TCpCkgCbvQCANXGYxagCojcuFyCcYFPmn6aagHhQhplHcANvckWPM7qrAFNg8pSz+zxjc73vwJ6VjjU2c0IXGnyOEPSToEWLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sFYDf-006pHx-1Z;
	Fri, 07 Jun 2024 19:57:20 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 07 Jun 2024 19:57:22 +0800
Date: Fri, 7 Jun 2024 19:57:22 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Marek Vasut <marex@denx.de>
Cc: linux-crypto@vger.kernel.org,
	Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <u.kleine-koenig@pengutronix.de>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Gatien Chevallier <gatien.chevallier@foss.st.com>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Olivia Mackall <olivia@selenic.com>, Rob Herring <robh@kernel.org>,
	Yang Yingliang <yangyingliang@huawei.com>,
	kernel@dh-electronics.com, linux-arm-kernel@lists.infradead.org,
	linux-stm32@st-md-mailman.stormreply.com
Subject: Re: [PATCH] hwrng: stm32 - use sizeof(*priv) instead of
 sizeof(struct stm32_rng_private)
Message-ID: <ZmL1oolKG_qSZ7r9@gondor.apana.org.au>
References: <20240531085749.42863-1-marex@denx.de>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240531085749.42863-1-marex@denx.de>

On Fri, May 31, 2024 at 10:57:34AM +0200, Marek Vasut wrote:
> Use sizeof(*priv) instead of sizeof(struct stm32_rng_private), the
> former makes renaming of struct stm32_rng_private easier if necessary,
> as it removes one site where such rename has to happen. No functional
> change.
> 
> Signed-off-by: Marek Vasut <marex@denx.de>
> ---
> Cc: "Uwe Kleine-König" <u.kleine-koenig@pengutronix.de>
> Cc: Alexandre Torgue <alexandre.torgue@foss.st.com>
> Cc: Gatien Chevallier <gatien.chevallier@foss.st.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: Marek Vasut <marex@denx.de>
> Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
> Cc: Olivia Mackall <olivia@selenic.com>
> Cc: Rob Herring <robh@kernel.org>
> Cc: Yang Yingliang <yangyingliang@huawei.com>
> Cc: kernel@dh-electronics.com
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-crypto@vger.kernel.org
> Cc: linux-stm32@st-md-mailman.stormreply.com
> ---
>  drivers/char/hw_random/stm32-rng.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
