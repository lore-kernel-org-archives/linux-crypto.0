Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31A8F5695
	for <linux-crypto@vger.kernel.org>; Fri, 31 May 2024 05:06:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717131976; cv=none; b=jnfuyyBRFwEu4tQRq71WdP8fXtgci3H6Q/qjmLu4JzJS15vys17z/lr5vbI9kWtDWOxy2rYkJXH3f4rPZzwRYR7/wOGSkSWwQ0nKtgyvyMDH4Rtf7pleApv12YUa6/x6gAOXLIESwEAl4iKeXQ/6KUQl+GAfViF6L9B70jlS6Sg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717131976; c=relaxed/simple;
	bh=V+9aPi8jAe0EV88vN1wiCyoK2OPYLNTPqGaPXPHnxQs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Jrhz+3MLs9TLfN6GODLcaGSkEb5G29TgilFLIVma82DfzsE01BAziUh0LZyXcy+L28kCijzenW8qh88BijdqwMMph025UupJbbC2vDuDCuWXEx4fSr6JGR1yp6I4OngT/xztOJgiluvdBrsJAg5Uacl3nimYmkus/u+K23707oc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sCuSp-0044Zl-2K;
	Fri, 31 May 2024 13:06:04 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 31 May 2024 13:06:05 +0800
Date: Fri, 31 May 2024 13:06:05 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Marek Vasut <marex@denx.de>
Cc: linux-crypto@vger.kernel.org,
	Gatien Chevallier <gatien.chevallier@foss.st.com>,
	Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <u.kleine-koenig@pengutronix.de>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Olivia Mackall <olivia@selenic.com>, Rob Herring <robh@kernel.org>,
	Yang Yingliang <yangyingliang@huawei.com>,
	kernel@dh-electronics.com, linux-arm-kernel@lists.infradead.org,
	linux-stm32@st-md-mailman.stormreply.com
Subject: Re: [PATCH v2 2/2] hwrng: stm32 - cache device pointer in struct
 stm32_rng_private
Message-ID: <ZllavXc2lscS9TRc@gondor.apana.org.au>
References: <20240516193757.12458-1-marex@denx.de>
 <20240516193757.12458-2-marex@denx.de>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240516193757.12458-2-marex@denx.de>

On Thu, May 16, 2024 at 09:37:41PM +0200, Marek Vasut wrote:
> Place device pointer in struct stm32_rng_private and use it all over the
> place to get rid of the horrible type casts throughout the driver.
> 
> No functional change.
> 
> Acked-by: Gatien Chevallier <gatien.chevallier@foss.st.com>
> Signed-off-by: Marek Vasut <marex@denx.de>

I think you should remove the assignment of rng.priv too as nothing
should use it anymore after your patch.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
