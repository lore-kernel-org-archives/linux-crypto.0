Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98AA73438BF
	for <linux-crypto@vger.kernel.org>; Mon,  1 Jun 2026 21:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780350185; cv=none; b=j4ADvb3Q5owGTcnRKbyDPLPDshscc4IFrLq9o+2qIiT8weIVnCQjTL+Sv6F7BubcPehXBDTl5TI6lzoTGV4p66dJ5gLzx6C1D3/vj5ufisaa5OdhQJmr378zGaCtI/rwQC/K+pehzZ9nrL09VWbT1+CxcRBQGtM+qW3JumV+CZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780350185; c=relaxed/simple;
	bh=vKC36Ha6Gml96K9KtWRfNbUPb1WRIRoZzsf2cx+lLlk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cB6oqiiMYVbMyQGr7xfupcA2uP6YNuLq64exblexroUYSKidiT4qVqjesSopkKLszblTOns6Z9ndJnm/5qQFcs7HPWyGuj96teqY/+O6pt9mfwpNT1oYxJ1QmxTD3A3vkPr1fJ8pzp6Uy2rNow+SHn9IyJelVHQcI4zjxqIIdfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=pwWujJDs; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="pwWujJDs"
Date: Mon, 1 Jun 2026 23:42:45 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780350171;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KbRRQ6UrReGZ9CEz+b0Ya6nhw8Mi+MGNVxgZl4wtQvY=;
	b=pwWujJDscJ+QSlmOJpum5zso1mLfyH+KmNwql+rQJRpqJ+35ngOvk3Z9RaSaTH29CHYxOU
	MA4dHIg6zZdSRpHbEL+igqopQNyip9C4dFzFG0n1W+NtymSYJ9T5RQg9ZNPlmonJpG7DRT
	OhK+uv3GXcUOg4zzh8fpbOTkLU0T6mE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Lothar Rubusch <l.rubusch@gmail.com>
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
	nicolas.ferre@microchip.com, alexandre.belloni@bootlin.com,
	claudiu.beznea@tuxon.dev, tudor.ambarus@linaro.org,
	krzk+dt@kernel.org, linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] crypto: atmel-ecc - fix use after free situation
Message-ID: <ah381bcuVfN8PQr0@linux.dev>
References: <20260529092703.33086-1-l.rubusch@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260529092703.33086-1-l.rubusch@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Fri, May 29, 2026 at 09:27:03AM +0000, Lothar Rubusch wrote:
> Fixes a possible race condition, when having multiple of such devices
> attached (identified by sashiko feedback).
> 
> The Scenario:
>     Thread A (Device 1 Probe): Successfully adds i2c_priv to the global
>              list (Line 324). The lock is released.
>     Thread B (An active crypto request): Concurrently calls
>               atmel_ecc_i2c_client_alloc(). It scans the global list, sees
>               Device 1, and assigns a crypto job to it.
>     Thread A: Moves to line 332. crypto_register_kpp() fails (e.g., out of
>               memory or name clash).
>     Thread A: Enters the error path. It removes Device 1 from the list and
>               frees the i2c_priv memory.
>     Thread B: Is still actively trying to talk to the I2C hardware using
>               the i2c_priv pointer it grabbed in Step 2. The memory is now
>               gone. Result: Kernel crash (Use-After-Free).
> 
> Fixes: 11105693fa05 ("crypto: atmel-ecc - introduce Microchip / Atmel ECC driver")
> Signed-off-by: Lothar Rubusch <l.rubusch@gmail.com>
> ---
>  drivers/crypto/atmel-ecc.c | 10 ++++++++++
>  drivers/crypto/atmel-i2c.h |  2 ++
>  2 files changed, 12 insertions(+)
> 
> diff --git a/drivers/crypto/atmel-ecc.c b/drivers/crypto/atmel-ecc.c
> index 0ca02995a1de..d391fe1462f6 100644
> --- a/drivers/crypto/atmel-ecc.c
> +++ b/drivers/crypto/atmel-ecc.c
> @@ -218,6 +218,8 @@ static struct i2c_client *atmel_ecc_i2c_client_alloc(void)
>  
>  	list_for_each_entry(i2c_priv, &driver_data.i2c_client_list,
>  			    i2c_client_list_node) {
> +		if (!i2c_priv->ready)
> +			continue;
>  		tfm_cnt = atomic_read(&i2c_priv->tfm_count);
>  		if (tfm_cnt < min_tfm_cnt) {
>  			min_tfm_cnt = tfm_cnt;
> @@ -322,20 +324,24 @@ static int atmel_ecc_probe(struct i2c_client *client)
>  		return ret;
>  
>  	i2c_priv = i2c_get_clientdata(client);
> +	i2c_priv->ready = false;
>  
>  	spin_lock(&driver_data.i2c_list_lock);
>  	list_add_tail(&i2c_priv->i2c_client_list_node,
>  		      &driver_data.i2c_client_list);
> +	i2c_priv->ready = true;
>  	spin_unlock(&driver_data.i2c_list_lock);
>  
>  	ret = crypto_register_kpp(&atmel_ecdh_nist_p256);
>  	if (ret) {
>  		spin_lock(&driver_data.i2c_list_lock);
> +		i2c_priv->ready = false;
>  		list_del(&i2c_priv->i2c_client_list_node);
>  		spin_unlock(&driver_data.i2c_list_lock);
>  
>  		dev_err(&client->dev, "%s alg registration failed\n",
>  			atmel_ecdh_nist_p256.base.cra_driver_name);
> +		return ret;
>  	} else {
>  		dev_info(&client->dev, "atmel ecc algorithms registered in /proc/crypto\n");
>  	}
> @@ -347,6 +353,10 @@ static void atmel_ecc_remove(struct i2c_client *client)
>  {
>  	struct atmel_i2c_client_priv *i2c_priv = i2c_get_clientdata(client);
>  
> +	spin_lock(&driver_data.i2c_list_lock);
> +	i2c_priv->ready = false;
> +	spin_unlock(&driver_data.i2c_list_lock);
> +
>  	/* Return EBUSY if i2c client already allocated. */
>  	if (atomic_read(&i2c_priv->tfm_count)) {
>  		/*
> diff --git a/drivers/crypto/atmel-i2c.h b/drivers/crypto/atmel-i2c.h
> index 72f04c15682f..e3b12030f9c4 100644
> --- a/drivers/crypto/atmel-i2c.h
> +++ b/drivers/crypto/atmel-i2c.h
> @@ -129,6 +129,7 @@ struct atmel_ecc_driver_data {
>   * @wake_token_sz       : size in bytes of the wake_token
>   * @tfm_count           : number of active crypto transformations on i2c client
>   * @hwrng               : hold the hardware generated rng
> + * @ready               : hw client is ready to use
>   *
>   * Reads and writes from/to the i2c client are sequential. The first byte
>   * transmitted to the device is treated as the byte size. Any attempt to send
> @@ -145,6 +146,7 @@ struct atmel_i2c_client_priv {
>  	size_t wake_token_sz;
>  	atomic_t tfm_count ____cacheline_aligned;
>  	struct hwrng hwrng;
> +	bool ready;
>  };

I don't think the ready flag fixes the race. A concurrent tfm can still
bind to the shared I2C client after atmel_ecc_probe() adds it to the
global list and marks it as ready, but before crypto_register_kpp()
fails.

Thanks,
Thorsten
