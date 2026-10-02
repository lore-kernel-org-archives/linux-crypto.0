Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 350D433E34E;
	Fri,  2 Oct 2026 07:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790924544; cv=none; b=p5JVehj14fmnp66ImmlYwhAcmYCd8QSanwVckLuENmJVmDkm384IlBJphvcZOxVbW0c9GzrY4cP4pujwl3YG6kt39NMxkBXec6DvsCy2OKDiiCwczgFaJYJU0b+MhPa53LVenYOLtkd1IRtZZLaVwtQptIG4PBsy1ACiK9ADl6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790924544; c=relaxed/simple;
	bh=/A1j9BbrO4u2Y2+W9QnJf9AK6H8xr/DSJGU8MUjV/V0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IX+Zt1Xi/aScVltUwCwtgF9ELKBT/Ce3qKgWQNXbpXKiGyeBR1s00AWIJHa/MvsgGUNbPy82yfLFls551ZvbFMH0OImD+UuwvDalVocTADXWO/0VWLA2NyUbR8GgA22GtMeuxrcsiTxmPO/6g0s6K5MhEyfSMAmbq0uqW0nZxlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=NQn60Juk; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="NQn60Juk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=cor8xgh0lw+1k1nOlsjT1eCSx7Yhd8JvND/1iy2CPpI=; 
	b=NQn60Juk2p6GA4I+LMRNAgW3aWZUgT2Q5drBcFs7U+zby35l6T3QqyGnSf9HM9GMmOIbaa11xth
	PuVy5g29ahjAC/qszNVJJiZ7etI+ftmUG+E2tcisbKy+g8ttJB2yoffpWhFXflY1xUEUIYYZNn/B8
	tH1K7nlCfeHChzdeGXXLKLseuUYSQrcsPg7ny4MdY1WoQT6fBsTThj2xeJtdz/TtJdqXhinA02dDU
	jwzrYYek516kGLdZ+/MguITsaPQlji+aEpYB8tWeIxrYZmReJ9bgwiAPblGAvb36pdZKndsHunvQ5
	hCqWPsV1iTLAmXNbsfHazcIqCEZ8985aNz3g==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xCXHR-00000002kpW-3ikb;
	Fri, 02 Oct 2026 15:02:06 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 02 Oct 2026 17:02:05 +1000
Date: Fri, 2 Oct 2026 17:02:05 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Rosen Penev <rosenp@gmail.com>
Cc: linux-crypto@vger.kernel.org, Christian Marangi <ansuelsmth@gmail.com>,
	Antoine Tenart <atenart@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Richard van Schagen <vschagen@icloud.com>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2] crypto: eip93 - fix IRQ teardown ordering in remove
 path
Message-ID: <ar9W7bxnDVtT_OOI@gondor.apana.org.au>
References: <20260921231121.63342-1-rosenp@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260921231121.63342-1-rosenp@gmail.com>

On Mon, Sep 21, 2026 at 04:11:21PM -0700, Rosen Penev wrote:
>
> diff --git a/drivers/crypto/inside-secure/eip93/eip93-main.c b/drivers/crypto/inside-secure/eip93/eip93-main.c
> index e62785952b0d..cc504590fd0f 100644
> --- a/drivers/crypto/inside-secure/eip93/eip93-main.c
> +++ b/drivers/crypto/inside-secure/eip93/eip93-main.c
> @@ -395,9 +395,21 @@ static int eip93_desc_init(struct eip93_device *eip93)
>  
>  static void eip93_cleanup(struct eip93_device *eip93)
>  {
> +	/* Stop HW from asserting IRQ first */
> +	eip93_irq_clear(eip93, EIP93_INT_ALL);
> +	eip93_irq_disable(eip93, EIP93_INT_ALL);

What's the point of this since the tasklet can undo it at any time?
IOW why not just get rid of these two lines and only do them after
the tasklet_kill call?

> +
> +	/* Synchronize and unregister the IRQ handler */
> +	free_irq(eip93->irq, eip93);
> +
> +	/* Drain any tasklet scheduled before the IRQ was disabled */
>  	tasklet_kill(&eip93->ring->done_task);
>  
> -	/* Clear/ack all interrupts before disable all */
> +	/*
> +	 * The tasklet re-enables the RDR interrupt when it drains the
> +	 * result ring, so mask the device interrupts again before the
> +	 * hardware is switched off.
> +	 */
>  	eip93_irq_clear(eip93, EIP93_INT_ALL);
>  	eip93_irq_disable(eip93, EIP93_INT_ALL);
>  
> @@ -430,12 +442,6 @@ static int eip93_crypto_probe(struct platform_device *pdev)
>  	if (eip93->irq < 0)
>  		return eip93->irq;
>  
> -	ret = devm_request_threaded_irq(eip93->dev, eip93->irq, eip93_irq_handler,
> -					NULL, IRQF_ONESHOT,
> -					dev_name(eip93->dev), eip93);
> -	if (ret)
> -		return ret;
> -
>  	ret = eip93_desc_init(eip93);
>  	if (ret)
>  		return ret;
> @@ -448,6 +454,11 @@ static int eip93_crypto_probe(struct platform_device *pdev)
>  	spin_lock_init(&eip93->ring->idr_lock);
>  	idr_init(&eip93->ring->crypto_async_idr);
>  
> +	ret = request_irq(eip93->irq, eip93_irq_handler, 0,
> +			  dev_name(eip93->dev), eip93);
> +	if (ret)
> +		goto err_free_tasklet;

Going from a threaded handler to a legacy handler seems to be
a step backward, even if this driver didn't make use of the
threaded functionality.

What about getting rid of the tasklet altogether and just using
the threaded IRQ handler directly, that too would kill the race
condition, right?

> @@ -472,6 +483,12 @@ static int eip93_crypto_probe(struct platform_device *pdev)
>  		 readl(eip93->base + EIP93_REG_PE_OPTION_0));
>  
>  	return 0;
> +
> +err_free_tasklet:
> +	idr_destroy(&eip93->ring->crypto_async_idr);
> +	tasklet_kill(&eip93->ring->done_task);

This seems weird.  You can only get here if request_irq fails,
how can you schedule a tasklet in that case?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
