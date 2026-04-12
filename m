Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36156309F19;
	Sun, 12 Apr 2026 08:41:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775983292; cv=none; b=iuIPDzx4q46AVkjsGj0M+AIp9xSxza3ZIK5oixNFr+32Qd+kQ8ZoOmUuLU7m64KdNQ2mQQ+d8pZGB/9D5fyOwv3owEQ1lEg/R5UzsD1GUgjviJlLXtEU0MM17z8Ci1TdLlkSeUxuErZlJGyPuH51A/rudP6fraKQdMVK3O+EVOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775983292; c=relaxed/simple;
	bh=oQAEvTJgHms6g9wIHlgei9I45CaNjIPrE2vJ8uq/F20=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fxeSlGcqQC7kaT2oq8e9xOR4shRvjp0EhCFGWEvUEUy7BtxKuEwuskhrnXSkzQuQg89yPI5HXlyTUGjfkOtwiqREc/+ssilGNXXjgT9yU+qBKLdaUHqkswk8EnsSVj3UJQJ1mh9TdWjVAY54s1/QDjBjEY6OXN81Cf705z/nkJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=SE09pf7/; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="SE09pf7/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=nAz8Z4Vd4S+N7HdZJMZc4HMb1LyZQJySdWx6FshsIBM=; 
	b=SE09pf7/HX05JKPsXaHx2yBsUsfdXVNpi72qWGwLOh89cv3xZaiYcnay6h6YSwMUGTrwgla19zf
	DoxBOupL7Bqq8i9lSWwBRxZMfDTFJVIj5chjwNmiJ3+lzdUYDzVHUXAlO8KwfkbiOA81nS+GrNAoK
	yj8PrBG6zo5VaDJlH3/UMqGts6q00yAtTTWRKmWUOjrk/Ig/V+YUwZ7pJhPVjxeBfzpiiZQ12gcLt
	EsXISu41skE+C8GwIVfbgxZGvl9rW1wnw7AUKA8kuE04Dlo7czGTJ1vcrboQHcAX61KTdEoqcVMz7
	omcI2RSEodaqPnN5QAnwdE733un5T/FrW/fQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wBpxv-005UCq-2q;
	Sun, 12 Apr 2026 16:41:07 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 12 Apr 2026 16:41:06 +0800
Date: Sun, 12 Apr 2026 16:41:06 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: "David S. Miller" <davem@davemloft.net>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Tudor Ambarus <tudor.ambarus@linaro.org>, stable@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: atmel-ecc - fix potential use-after-free in
 remove path
Message-ID: <adtaojnrwm9Bclln@gondor.apana.org.au>
References: <20260402130536.892838-3-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260402130536.892838-3-thorsten.blum@linux.dev>

On Thu, Apr 02, 2026 at 03:05:38PM +0200, Thorsten Blum wrote:
> Flush the Atmel I2C workqueue before teardown to prevent a potential
> use-after-free if a queued callback runs while the device is being
> removed.
> 
> Drop the early return to ensure the driver always unregisters the KPP
> algorithm and removes the client from the global list instead of
> aborting teardown when the device is busy.
> 
> Fixes: 11105693fa05 ("crypto: atmel-ecc - introduce Microchip / Atmel ECC driver")
> Cc: stable@vger.kernel.org
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  drivers/crypto/atmel-ecc.c | 15 +--------------
>  1 file changed, 1 insertion(+), 14 deletions(-)
> 
> diff --git a/drivers/crypto/atmel-ecc.c b/drivers/crypto/atmel-ecc.c
> index b6a77c8d439c..6dbd0f70dd84 100644
> --- a/drivers/crypto/atmel-ecc.c
> +++ b/drivers/crypto/atmel-ecc.c
> @@ -346,21 +346,8 @@ static void atmel_ecc_remove(struct i2c_client *client)
>  {
>  	struct atmel_i2c_client_priv *i2c_priv = i2c_get_clientdata(client);
>  
> -	/* Return EBUSY if i2c client already allocated. */
> -	if (atomic_read(&i2c_priv->tfm_count)) {
> -		/*
> -		 * After we return here, the memory backing the device is freed.
> -		 * That happens no matter what the return value of this function
> -		 * is because in the Linux device model there is no error
> -		 * handling for unbinding a driver.
> -		 * If there is still some action pending, it probably involves
> -		 * accessing the freed memory.
> -		 */
> -		dev_emerg(&client->dev, "Device is busy, expect memory corruption.\n");
> -		return;
> -	}
> -
>  	crypto_unregister_kpp(&atmel_ecdh_nist_p256);
> +	atmel_i2c_flush_queue();

I don't think this works.  Even if you unregister the algorithm,
existing tfm's can still access the driver.

You'll need something a bit fancier than this to deal with it by
failing any calls to existing tfm's gracefully.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
