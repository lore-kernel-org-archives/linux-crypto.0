Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B88D3624C9;
	Thu, 11 Jun 2026 05:30:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781155806; cv=none; b=kYKLU95TjhR5TSEq0+CFv+2khv6Rq2yvW8cONwy2E0uIx9j1EzPzdsf+3+6lS5bsjSo5oHWOxOrgJZJPiEoo8x7INJcvfFdkQC0c1qn6jIpxQIuYogCF67UaxK/gFfY4DmGvJ8xoOWICmSMhKY2dcORXA59a+4IoYy44t3p/gnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781155806; c=relaxed/simple;
	bh=Ah3p2RmAW+d7wKNxWuQzCtSg/bT1wle1XBhQlZKSHSQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VbMOPU3tiWja7y+ZnfOU0PHp82YR4G6ubQTrdbql3POd4UPfiOGdXPwNNEuqrt9SBYjndL+l3vI1jY6lcpI4sN9jLfoN8wJqfEeSi0qTjVzYFU+XCUCn47KjwtA3GcP6CD5opqW7hrKEY9vjufEbtj8sPeU25HrDpvdoB/LZM50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=PyzZkSqH; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="PyzZkSqH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=PqVcGbH9wWwEBo3NBKFoaBwVVqPvH9y9tROxN8Pio5I=; 
	b=PyzZkSqHrvTn30hmR8guFbfKcTKXfDP+a0nVvEOHmDLxPERAex/PvuqZe4MWZ1UNYfUDQLsonCN
	D6DKVr94xRJ1P1qrTePhfIalkyD2zeqL+2e2BP+AXVHqS5Hia1twuE+LQgfIP7waqNLwJQHEHSHg0
	QIYobKVv1Sl03U+w8ykUY59AOOPYWEwElgp/N1d8QSTTKfdXuaSDwcWnKR4VecVR7m2d8ur2GuAXH
	p2bo9zAIiKCUmMnj4Ii6M/bfvgOBm3wj43UsNm7T/4Va0bYYvsgK9cl/eHGuLAYfLa1ylrjobpCng
	DqD1HQE3974XCplmWUyukPPL7YKWGy1XQgmg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wXXzE-00000004UDH-3vYu;
	Thu, 11 Jun 2026 13:29:54 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 11 Jun 2026 13:29:52 +0800
Date: Thu, 11 Jun 2026 13:29:52 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: "David S. Miller" <davem@davemloft.net>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: atmel-ecc - remove stale comments in
 atmel_ecc_remove
Message-ID: <aipH0NgL4Gbe7Oz1@gondor.apana.org.au>
References: <20260602165247.977197-3-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260602165247.977197-3-thorsten.blum@linux.dev>

On Tue, Jun 02, 2026 at 06:52:49PM +0200, Thorsten Blum wrote:
> atmel_ecc_remove() no longer returns -EBUSY since commit 7df7563b16aa
> ("crypto: atmel-ecc - Remove duplicated error reporting in .remove()")
> and is a void function since commit ed5c2f5fd10d ("i2c: Make remove
> callback return void").
> 
> Remove and update the outdated comments.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  drivers/crypto/atmel-ecc.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/crypto/atmel-ecc.c b/drivers/crypto/atmel-ecc.c
> index 9c380351d2f9..e6068dc0a0c1 100644
> --- a/drivers/crypto/atmel-ecc.c
> +++ b/drivers/crypto/atmel-ecc.c
> @@ -347,13 +347,11 @@ static void atmel_ecc_remove(struct i2c_client *client)
>  {
>  	struct atmel_i2c_client_priv *i2c_priv = i2c_get_clientdata(client);
>  
> -	/* Return EBUSY if i2c client already allocated. */
>  	if (atomic_read(&i2c_priv->tfm_count)) {
>  		/*
>  		 * After we return here, the memory backing the device is freed.
> -		 * That happens no matter what the return value of this function
> -		 * is because in the Linux device model there is no error
> -		 * handling for unbinding a driver.
> +		 * That happens because in the Linux device model there is no
> +		 * error handling for unbinding a driver.
>  		 * If there is still some action pending, it probably involves
>  		 * accessing the freed memory.
>  		 */

Please fix this properly rather than fiddling with the comments.

Drivers should always fail gracefully if the hardware disappears.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
