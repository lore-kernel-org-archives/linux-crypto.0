Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24FE636A360;
	Sun,  5 Jul 2026 08:29:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783240175; cv=none; b=RYP6T3pymh5IYZUwq7FSTkTcRYLHBqEP8Pe4MMIvp9k3PEVaJpxbLDZkSQqWWcovAQ7FnccE8EUacTniMBrtLlUzKcUsLUzokIlSIgVjAJMqiLDE+v0ihJ5xnC6agmTldlpBMguCa3Afou2gOVB616wQNr9DMspc+uL9i7ol0fQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783240175; c=relaxed/simple;
	bh=E8ikyZzDZIxhOAox4gxnsPweNaDoww4xJF36XNFicsM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PNP2dDbx0OZz1kAnlLHoE6FdFawm66idYAdAplF5W/6BemrR6O3ret5zx7rkOmk2dCMkling7+xorYsYZ5nmxpqf8Ju79knnSENFAffAIH1UhfgxeZAkkUYgN4WdX28TTzfdMq4xNIMTe0oxQ2hOm3rKyW1Ig8vGRq4BxbKfgsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=HYX4uJvE; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="HYX4uJvE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=W66ZR94wfwnjZOMAZQ6UhAWUSRUCpXS+5HHe+V44JoU=; 
	b=HYX4uJvEL5g9aj3dwRVmbffMVYpPEi/WgRhJEFzNOIJccBLYP0sjG4/uZgpLOmxfqiQXYFid5yp
	C7FYd+iGx24HA9VMfrIc4XqP/bKbvG6fg86FFKbo9or3Yq5yiVGdiONtKVdccrYN5UOu3JVo9Okcx
	nDvYtxWLmKO+fChlZU3+d9P8VJF3fF7DScqfePpdAbiv+4DrfSWYwU9oeBwKCmFZxwdC1uejW442T
	3UQHdOatNcj1jykIAZe8amgks6NXtIsPhvWgTEbZ9kdsB1HjWkIfSHV5LaYL4mIeUm2KBCpmUxStw
	v9kufvu8o/0bl0N1894dehfa9Xe5y4h1obMw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wgIE8-0000000Akwo-2cJ3;
	Sun, 05 Jul 2026 16:29:25 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 05 Jul 2026 16:29:24 +0800
Date: Sun, 5 Jul 2026 16:29:24 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: "David S. Miller" <davem@davemloft.net>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Tudor Ambarus <tudor.ambarus@linaro.org>,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: atmel-ecc - reject hardware ECDH without a
 public key
Message-ID: <akoV5M1sXgMoUuEV@gondor.apana.org.au>
References: <20260611213617.463552-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260611213617.463552-2-thorsten.blum@linux.dev>

On Thu, Jun 11, 2026 at 11:36:17PM +0200, Thorsten Blum wrote:
> The hardware ECDH path in atmel_ecdh_compute_shared_secret() uses the
> private key stored in the device. However, the public key is cached only
> after atmel_ecdh_set_secret() successfully generated that private key
> for the current tfm.
> 
> atmel_ecdh_generate_public_key() already rejects requests when no public
> key is cached. Add the same check to atmel_ecdh_compute_shared_secret()
> to prevent the device from using a private key that was not generated
> for the current tfm.
> 
> Fixes: 11105693fa05 ("crypto: atmel-ecc - introduce Microchip / Atmel ECC driver")
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  drivers/crypto/atmel-ecc.c | 3 +++
>  1 file changed, 3 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
