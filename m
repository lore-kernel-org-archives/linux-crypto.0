Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3836E13F433
	for <linux-crypto@vger.kernel.org>; Fri, 26 Apr 2024 09:34:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714124074; cv=none; b=EpQEbdVc44vyXr9CYIuYqeElS8uwChvH90IhI4xvfhQetkuME42Jz3OFylbOQ+gycqjUfSF3ptdl4aMIfjsJaDgC3i/kyVTeNLJChuCxO5WKchSSnU9gK3KH6zuIUv1e2herFUCLPW34t2EKT5jOpJfzcpJS7ywfg1+2Hrck4hg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714124074; c=relaxed/simple;
	bh=nHhvKmohpsa7pOh9Nqv9wxs6cU1xr0Jt+UAgCuHp78E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kOF/6nkch9alwFp/Gf44nT02JPrG1/SD0FuH+mVfRB8cLvE9FTQj2co4fzK4C0DyWCxSUkwnMnTQy+qHA5Xh1nBLkEUp5RGYkLUNDLCiV3nVD8JezjrHuA0BGVPvdK+BCQ4b2lCKFLIEXdqht0DYVF+cgnJu+SHo8/wPpbI/nIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1s0HyK-006eSm-DS; Fri, 26 Apr 2024 17:34:25 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 26 Apr 2024 17:34:42 +0800
Date: Fri, 26 Apr 2024 17:34:42 +0800
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
Subject: Re: [PATCH 1/3] hwrng: stm32 - use logical OR in conditional
Message-ID: <Zit1MvGeHX8CFEQV@gondor.apana.org.au>
References: <20240419050201.181041-1-marex@denx.de>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240419050201.181041-1-marex@denx.de>

On Fri, Apr 19, 2024 at 07:01:12AM +0200, Marek Vasut wrote:
> The conditional is used to check whether err is non-zero OR whether
> reg variable is non-zero after clearing bits from it. This should be
> done using logical OR, not bitwise OR, fix it.
> 
> Fixes: 6b85a7e141cb ("hwrng: stm32 - implement STM32MP13x support")
> Signed-off-by: Marek Vasut <marex@denx.de>
> ---
> Cc: "Uwe Kleine-König" <u.kleine-koenig@pengutronix.de>
> Cc: Alexandre Torgue <alexandre.torgue@foss.st.com>
> Cc: Gatien Chevallier <gatien.chevallier@foss.st.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
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

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
