Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB66B187329;
	Fri,  7 Jun 2024 11:54:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717761253; cv=none; b=Oc40nNe80BzYVvnm5ifdyi98kOdiv9JoTikJMJgo5jHGJev18dhG7qlKtrrEW79+QbvXGPBUhaAvRaRxGOwIv0O+FTwNkksfKGTdOGVahiJpD7DaeRvATENVpmS79QqEoHH1EUVDqyFNTLTtWULqxKuAXikk/0QmZRUSJLWJPFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717761253; c=relaxed/simple;
	bh=qqO7q0Mldl9tBen4Fca7wCIwFXvyn/PO6UGGUykd1ms=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EbqbljQzoAeQQHrZLP9YjVzfOeIGO+OYZhL6N9EeodVeF59U8BZuogKQd51MuHfvOeu1n8AJOe73qidIfhH+PeJlohOjqfOUp9Pqq6chc6rCEvfjscKw6wCL746++xgUugoN57GyVp5xJvEwLoPvkw7i8LTVNrQ/TUhFPu3b2MU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sFYAG-006p9u-2X;
	Fri, 07 Jun 2024 19:53:49 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 07 Jun 2024 19:53:51 +0800
Date: Fri, 7 Jun 2024 19:53:51 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Maxime MERE <maxime.mere@foss.st.com>
Cc: "David S . Miller" <davem@davemloft.net>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <u.kleine-koenig@pengutronix.de>,
	Rob Herring <robh@kernel.org>, linux-crypto@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/4] crypto: stm32/cryp - Improve stm32-cryp driver
Message-ID: <ZmL0zynFM2RgA0RM@gondor.apana.org.au>
References: <20240528140548.1632562-1-maxime.mere@foss.st.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240528140548.1632562-1-maxime.mere@foss.st.com>

On Tue, May 28, 2024 at 04:05:44PM +0200, Maxime MERE wrote:
> From: Maxime Méré <maxime.mere@foss.st.com>
> 
> This series of patches mainly aims to improve the usage of DMA with the
> CRYP peripheral of the STM32 MPU series. The other two patches are
> needed to enhance the driver's visibility for ST platforms.
> 
> This patchset version 3 addresses the issues identified by Herbert.
> The code that raised a warning was in fact useless as there is already
> an overflow check in the "stm32_cryp_dma_check" function so I removed
> it.
> 
> I've also added a new patch that correct a spinlock recursion warning.
> 
> Maxime Méré (4):
>   crypto: stm32/cryp - use dma when possible.
>   crypto: stm32/cryp - increase priority
>   crypto: stm32/cryp - add CRYPTO_ALG_KERN_DRIVER_ONLY flag
>   crypto: stm32/cryp - call finalize with bh disabled
> 
>  drivers/crypto/stm32/stm32-cryp.c | 719 ++++++++++++++++++++++++++++--
>  1 file changed, 674 insertions(+), 45 deletions(-)
> 
> -- 
> 2.25.1

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
