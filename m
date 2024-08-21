Received: from akranes.kaiser.cx (akranes.kaiser.cx [152.53.16.207])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0450185B67;
	Wed, 21 Aug 2024 06:59:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=152.53.16.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724223596; cv=none; b=TIXcexpN8h58o5EWzkkZrvL/2ba9Am+wr+3VsTOHGbPhOjXA/WZicRYnh9tlHErt7VN7aN3xXBPylcHitSzvTYIGvH/vwDD1TgftRK4wlzh+gr8bAr97vVHxRDleOGBMtBYsWw1EkBBaEUKfFPTptO9MaosleCvRHT639KqwgKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724223596; c=relaxed/simple;
	bh=8cjkmKFsxDX/YLWmGFYfoAyPJVWnGwygJdAeY5YFv3Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sGNqBLUC6E6sZl3eFs5Xe5YUVsHuKPZyoURFpsew2tEnThMEGBeEeR3oOQUcVTnr7sZT0TtDqfEicLgfVLt0FYllyLpdYa4eStW3pXBMbzVBZ57mKIuHIpkRRTNX9XiBFe5aGqsRhiR3L/HUbjXoTSvqxlE0PxKuwEs9m1Ooqn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kaiser.cx; spf=pass smtp.mailfrom=kaiser.cx; arc=none smtp.client-ip=152.53.16.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kaiser.cx
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kaiser.cx
Received: from martin by akranes.kaiser.cx with local (Exim 4.96)
	(envelope-from <martin@akranes.kaiser.cx>)
	id 1sgf2s-001zDD-1p;
	Wed, 21 Aug 2024 08:42:14 +0200
Date: Wed, 21 Aug 2024 08:42:14 +0200
From: Martin Kaiser <martin@kaiser.cx>
To: Huan Yang <link@vivo.com>
Cc: Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <u.kleine-koenig@pengutronix.de>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	opensource.kernel@vivo.com
Subject: Re: [PATCH] char: mxc-rnga: Use devm_clk_get_enabled() helpers
Message-ID: <ZsWMRn1gPNnrdaRy@akranes.kaiser.cx>
References: <20240820094715.104998-1-link@vivo.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240820094715.104998-1-link@vivo.com>
Sender: "Martin Kaiser,,," <martin@akranes.kaiser.cx>

Thus wrote Huan Yang (link@vivo.com):

> The devm_clk_get_enabled() helpers:
>     - call devm_clk_get()
>     - call clk_prepare_enable() and register what is needed in order to
>      call clk_disable_unprepare() when needed, as a managed resource.

> This simplifies the code and avoids the calls to clk_disable_unprepare().

> Signed-off-by: Huan Yang <link@vivo.com>
> ---
>  drivers/char/hw_random/mxc-rnga.c | 16 +++-------------
>  1 file changed, 3 insertions(+), 13 deletions(-)

> diff --git a/drivers/char/hw_random/mxc-rnga.c b/drivers/char/hw_random/mxc-rnga.c
> index 94ee18a1120a..f01eb95bee31 100644
> --- a/drivers/char/hw_random/mxc-rnga.c
> +++ b/drivers/char/hw_random/mxc-rnga.c
> @@ -147,33 +147,25 @@ static int mxc_rnga_probe(struct platform_device *pdev)
>  	mxc_rng->rng.data_present = mxc_rnga_data_present;
>  	mxc_rng->rng.data_read = mxc_rnga_data_read;

> -	mxc_rng->clk = devm_clk_get(&pdev->dev, NULL);
> +	mxc_rng->clk = devm_clk_get_enabled(&pdev->dev, NULL);
>  	if (IS_ERR(mxc_rng->clk)) {
>  		dev_err(&pdev->dev, "Could not get rng_clk!\n");
>  		return PTR_ERR(mxc_rng->clk);
>  	}

> -	err = clk_prepare_enable(mxc_rng->clk);
> -	if (err)
> -		return err;
> -
>  	mxc_rng->mem = devm_platform_ioremap_resource(pdev, 0);
>  	if (IS_ERR(mxc_rng->mem)) {
>  		err = PTR_ERR(mxc_rng->mem);
> -		goto err_ioremap;
> +		return err;
>  	}

>  	err = hwrng_register(&mxc_rng->rng);
>  	if (err) {
>  		dev_err(&pdev->dev, "MXC RNGA registering failed (%d)\n", err);
> -		goto err_ioremap;
> +		return err;
>  	}

>  	return 0;
> -
> -err_ioremap:
> -	clk_disable_unprepare(mxc_rng->clk);
> -	return err;
>  }

>  static void mxc_rnga_remove(struct platform_device *pdev)
> @@ -181,8 +173,6 @@ static void mxc_rnga_remove(struct platform_device *pdev)
>  	struct mxc_rng *mxc_rng = platform_get_drvdata(pdev);

>  	hwrng_unregister(&mxc_rng->rng);
> -
> -	clk_disable_unprepare(mxc_rng->clk);
>  }

>  static const struct of_device_id mxc_rnga_of_match[] = {
> -- 
> 2.45.2

looks good to me

Reviewed-by: Martin Kaiser <martin@kaiser.cx>
