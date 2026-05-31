Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2378E1E520A
	for <linux-crypto@vger.kernel.org>; Sun, 31 May 2026 14:02:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780236162; cv=none; b=lwY1NOWU1qRyAP9WuaF77J5ZJ1yfHaQG0OxigmDfwTWVtTA2MHN89TOlDzNXybgd2xaA7Ofqw/BL45OoRGib+WXwxO8MS0bRMT+sFTIDAmfafTgqgAnvOjgeUlEbf6oRNcyagMsj8bqj8zjD//2LhzkPSp3JgQJEPVZ9ls3S/JM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780236162; c=relaxed/simple;
	bh=FrpQN1zxqZso2qH2fiyXN2G85G4vjUAo1PYk7vl56vk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LD4toMFEO6m8QuF/IdPqK4CH/CW90A3J7IuwJrUxUgIEaw4WPkKFGixtPZv9i+0xKIlC5ECRx0Obfmkfw4gucXta0xrgceBYIdhOiogUwznztDKXBX+gkImx3UWfAWeRfGnDImPigTq1cwwWlcZbNnK/H+h19qkFrmxluA1ks5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=nlF5srIY; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="nlF5srIY"
Date: Sun, 31 May 2026 16:02:29 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780236157;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Y82rbZe1VujLaE6CZRtDpj4MfmTk0fKLiDjnfPvTGnU=;
	b=nlF5srIYN0OpgAWi0UzF6jNR2GkjqvMg5wYsLz5KZ815XrvemkP6D7obso1gikYM8fYEQC
	rjVeJS+5CZdKnAMbztr4laJ1fpQUX4dAKkTrq1jgiCBlOrPSfwYf5Ci0QXChQbFB5cW5ZE
	pj3Qqs+uS8hzZeO5QKefF3ednkRF4po=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Lothar Rubusch <l.rubusch@gmail.com>
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
	nicolas.ferre@microchip.com, alexandre.belloni@bootlin.com,
	claudiu.beznea@tuxon.dev, ardb@kernel.org, krzk+dt@kernel.org,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] crypto: atmel-sha204a - fix heap info leak on I2C
 transfer failure
Message-ID: <ahw_ddfEdC742YRb@linux.dev>
References: <20260529094336.33809-1-l.rubusch@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260529094336.33809-1-l.rubusch@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Fri, May 29, 2026 at 09:43:36AM +0000, Lothar Rubusch wrote:
> When a non-blocking read operation is requested, the driver dynamically
> allocates memory to track asynchronous transfer status. If the underlying
> I2C transmission fails, atmel_sha204a_rng_done() logs a rate-limited
> warning but incorrectly proceeds to cache the pointer to this uninitialized
> buffer inside the rng->priv data field anyway.

The buffer is not necessarily uninitialized. cmd.data could also contain
a device error/status response or stale data from a previous request. An
uninitialized buffer is only one possibility.

Also, "rng->priv data field" is a bit confusing; maybe say that the
callback caches the work_data pointer in rng->priv instead?

> On subsequent execution passes, atmel_sha204a_rng_read_nonblocking()
> detects the stale rng->priv value, skips executing a hardware data read,

The cache-hit path still queues a new async read request and copies
invalid/stale data, but "skips a hardware data read" is probably not
correct. Did you mean the returned bytes aren't from a successful read?

> and copies up to 32 bytes of uninitialized kernel heap data from this
> garbage memory pool straight back into the system's hwrng data stream.

Same as above: it's not necessarily garbage or uninitialized data.

> Fix this information disclosure vector by immediately releasing the
> allocated asynchronous work data buffer and explicitly clearing the
> tracking pointer context whenever an I2C transaction returns a non-zero
> error status.
> 
> Additionally, duplicate the tfm counter decrement within the new error
> path to ensure the reference counter is properly released before executing
> the early return, maintaining the driver's availability for subsequent
> requests.
> 
> Fixes: da001fb651b0 ("crypto: atmel-i2c - add support for SHA204A random number generator")
> Signed-off-by: Lothar Rubusch <l.rubusch@gmail.com>
> ---
>  drivers/crypto/atmel-sha204a.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/crypto/atmel-sha204a.c b/drivers/crypto/atmel-sha204a.c
> index 4c9af737b33a..20cd915ea8a3 100644
> --- a/drivers/crypto/atmel-sha204a.c
> +++ b/drivers/crypto/atmel-sha204a.c
> @@ -31,10 +31,15 @@ static void atmel_sha204a_rng_done(struct atmel_i2c_work_data *work_data,
>  	struct atmel_i2c_client_priv *i2c_priv = work_data->ctx;
>  	struct hwrng *rng = areq;
>  
> -	if (status)
> +	if (status) {
>  		dev_warn_ratelimited(&i2c_priv->client->dev,
>  				     "i2c transaction failed (%d)\n",
>  				     status);
> +		kfree(work_data);
> +		rng->priv = 0;

Setting rng->priv = 0 is redundant here. rng_read_nonblocking() already
clears it before enqueuing new work, and the ->tfm_count gate prevents
others from setting it.

> +		atomic_dec(&i2c_priv->tfm_count);
> +		return;
> +	}
>  
>  	rng->priv = (unsigned long)work_data;
>  	atomic_dec(&i2c_priv->tfm_count);
> 
> base-commit: 5624ea54f3ba5c83d2e5503411a31a8be0278c1e

The fix itself looks good to me.

For a v2, could you please reword the commit message to be more precise,
and ideally drop the redundant rng->priv assignment? And feel free to
add a stable tag, as this should probably be backported.

With the above addressed, feel free to add:

Reviewed-by: Thorsten Blum <thorsten.blum@linux.dev>

Thanks,
Thorsten
