Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE03010E3;
	Sun, 15 Mar 2026 04:32:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773549131; cv=none; b=emt40jW6Umbn3gVdhqUtcUwqdKCZbklI1r+amNr3D0HUphiOcVcEdrhFf9mWSwQI3sZO735AKfXmwUZLEJJhrgRLAaem48C7VN11IlFSlQoUDJkkSZDuOgUvSU/PloZ/qnA6n8cthZXpsnMKPCm9TfGP2J6Bi2TCUbh7h5jBYzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773549131; c=relaxed/simple;
	bh=Hx/9Hg5JYp+T47UsmkalOOrPH07BQ56yARZhvpDrEw0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LVfAkZG75lJgJub5hxREktAYVW/LGS/gBmqYeB8B0lLDI3B7duIVrP2i7OiQ4syZyeGTRsh8gPHbNr6fluxxj3xo5wPIuR7vMq9beNEhDHzGB4XgC8XyJPb3VGMcv+Zxg/nF60uBpiEK21B3Ms55ZqTSB3TDn8FP5Tawy/gOvDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=bSWKC9mS; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="bSWKC9mS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=0a05xrtiPpxE3Z9dHfRgJgsJ67Benwi/QX1wvO2tNlM=; 
	b=bSWKC9mSKhFgB8Q6XBtwZybMpo/+6FxioY0v9UkSoWJ+EgcUC9qXR3EEioMSdIHffhEKHlnCi/T
	r6spL5KL1XNHSHl+AqMlN12IU98rQh4oxuyeih2Qq5aOusdn40KxzQkWHIEZUUeKinPmFSrSn5sG6
	H2kQwiiSgxUcXQ18otE0x4a0YNfpYJSjbzKGlEpUOYd7YREnSvLkFkDYTMrir6WqiqoKksdVD5h+v
	vF0WcfsiW45T6yx5kfwwG+UVpTfKm/36upzRn5xHXuWH/iuj0c4L9NbQWufFX0lw/oM+0LSkOn0s8
	lf5RolU1Zrwg2B48IpJ5QySxIkBBQZ9ST5zA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1w1d8P-00EXUJ-32;
	Sun, 15 Mar 2026 12:31:27 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 15 Mar 2026 13:31:25 +0900
Date: Sun, 15 Mar 2026 13:31:25 +0900
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: "David S. Miller" <davem@davemloft.net>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Linus Walleij <linusw@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
	stable@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] crypto: atmel-sha204a - Fix potential UAF and memory
 leak in remove path
Message-ID: <abY2HdOs0768G8G3@gondor.apana.org.au>
References: <20260314193627.728469-3-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260314193627.728469-3-thorsten.blum@linux.dev>

On Sat, Mar 14, 2026 at 08:36:29PM +0100, Thorsten Blum wrote:
>
> diff --git a/drivers/crypto/atmel-sha204a.c b/drivers/crypto/atmel-sha204a.c
> index 98d1023007e3..aeadbc9a2759 100644
> --- a/drivers/crypto/atmel-sha204a.c
> +++ b/drivers/crypto/atmel-sha204a.c
> @@ -191,10 +191,8 @@ static void atmel_sha204a_remove(struct i2c_client *client)
>  {
>  	struct atmel_i2c_client_priv *i2c_priv = i2c_get_clientdata(client);
>  
> -	if (atomic_read(&i2c_priv->tfm_count)) {
> -		dev_emerg(&client->dev, "Device is busy, will remove it anyhow\n");
> -		return;
> -	}
> +	devm_hwrng_unregister(&client->dev, &i2c_priv->hwrng);

Is it OK to explicitly call devm_hwrng_unregister?

Perhaps it's best to remove the devm management?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
