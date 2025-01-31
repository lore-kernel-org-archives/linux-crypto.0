Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5A504683;
	Fri, 31 Jan 2025 08:34:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738312451; cv=none; b=fYkMi1aKbeoTQyQ/B2yNAeLGF6mKpkYoc97rxSasWNZoR4S6Km82sGxTsWDJokKGnAUnd7Qwis93GLLqpRci2SjfilHbZKZuB1d5X1A5M/nB2qCsUpDFWMt2gLUYvQDvJjlHMiFacNnjL9EofzCzS3NkFTXCy0itB7FDY+YXUoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738312451; c=relaxed/simple;
	bh=8zc6yBsAaJwfFYLXrwfQvFexqnj+mY5XmiFIpp8Hebw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KDOCODa7Jpa/wMp1YN+cgVnC3eC8q4DCLGngy1js1de6PzCHgQuvO6HdVYjJEhokChBSO/wUP9m11zJelfksbgTZAu7OjRvQM/AgEYghKs/e/jjXZmbYAQG/jor84HUnRMRjoR/pOnQH3RBHE0FLokeCPRk28G8+0vn5KVbbXew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z1/8PE5n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z1/8PE5n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 530C6C4CED1;
	Fri, 31 Jan 2025 08:34:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738312449;
	bh=8zc6yBsAaJwfFYLXrwfQvFexqnj+mY5XmiFIpp8Hebw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Z1/8PE5nHVhItfgy2FsiZzSUx6yyyu4UXNRWRDcSjluPCMk9G/nDxzTbE5xeFNUkq
	 hjVgsE23h34LD77rjkUgLFI4wabgYN9jzTBA/HdVtrqrGuKWh5L0hw9Urxsk1eDyij
	 +1dT0Fb+35gQ69faNmzvmb0O+REkK/79MzSmZJHoUU92uTpTDn9rGt3UU6/HVEs7rO
	 qdqhNg9vHeneVNaYHdPjd0VUETOErDwJWfYx8GBW+HFAHehHZbNc7NaD7DF81qhv5p
	 mDxWTzXpO3XgooYl1hTopR7HAg/HxQpj+4wkC0IlomVaaMF2GA0CdkeFKQz/qOYoST
	 kPfdbzTU6+JOA==
Message-ID: <c32d8455-1bf6-44de-acf8-34fe00ae2868@kernel.org>
Date: Fri, 31 Jan 2025 09:34:02 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/7] hwrng: rockchip: add support for rk3588's standalone
 TRNG
To: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>,
 Philipp Zabel <p.zabel@pengutronix.de>, Rob Herring <robh@kernel.org>,
 Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley
 <conor+dt@kernel.org>, Heiko Stuebner <heiko@sntech.de>,
 Olivia Mackall <olivia@selenic.com>, Herbert Xu
 <herbert@gondor.apana.org.au>, Daniel Golle <daniel@makrotopia.org>,
 Aurelien Jarno <aurelien@aurel32.net>
Cc: Sebastian Reichel <sebastian.reichel@collabora.com>,
 devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, Lin Jinhan <troy.lin@rock-chips.com>
References: <20250130-rk3588-trng-submission-v1-0-97ff76568e49@collabora.com>
 <20250130-rk3588-trng-submission-v1-5-97ff76568e49@collabora.com>
From: Krzysztof Kozlowski <krzk@kernel.org>
Content-Language: en-US
Autocrypt: addr=krzk@kernel.org; keydata=
 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 fv0=
In-Reply-To: <20250130-rk3588-trng-submission-v1-5-97ff76568e49@collabora.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 30/01/2025 17:31, Nicolas Frattaroli wrote:
> +MODULE_DEVICE_TABLE(of, rk_rng_dt_match);
> +
>  static int rk_rng_probe(struct platform_device *pdev)
>  {
>  	struct device *dev = &pdev->dev;
> +	const struct of_device_id *match;
>  	struct reset_control *rst;
>  	struct rk_rng *rk_rng;
>  	int ret;
> @@ -139,6 +333,8 @@ static int rk_rng_probe(struct platform_device *pdev)
>  	if (!rk_rng)
>  		return -ENOMEM;
>  
> +	match = of_match_node(rk_rng_dt_match, dev->of_node);
> +	rk_rng->soc_data = (struct rk_rng_soc_data *)match->data;

Don't open code getting match data.

>  	rk_rng->base = devm_platform_ioremap_resource(pdev, 0);
>  	if (IS_ERR(rk_rng->base))
>  		return PTR_ERR(rk_rng->base);
> @@ -148,24 +344,30 @@ static int rk_rng_probe(struct platform_device *pdev)
>  		return dev_err_probe(dev, rk_rng->clk_num,
>  				     "Failed to get clks property\n");
>  
> -	rst = devm_reset_control_array_get_exclusive(dev);
> -	if (IS_ERR(rst))
> -		return dev_err_probe(dev, PTR_ERR(rst), "Failed to get reset property\n");
> +	if (rk_rng->soc_data->reset_optional)
> +		rst = devm_reset_control_array_get_optional_exclusive(dev);
> +	else
> +		rst = devm_reset_control_array_get_exclusive(dev);
> +
> +	if (rst) {
> +		if (IS_ERR(rst))
> +			return dev_err_probe(dev, PTR_ERR(rst), "Failed to get reset property\n");
>  
> -	reset_control_assert(rst);
> -	udelay(2);
> -	reset_control_deassert(rst);
> +		reset_control_assert(rst);
> +		udelay(2);
> +		reset_control_deassert(rst);
> +	}
>  
>  	platform_set_drvdata(pdev, rk_rng);
>  
>  	rk_rng->rng.name = dev_driver_string(dev);
>  	if (!IS_ENABLED(CONFIG_PM)) {
> -		rk_rng->rng.init = rk_rng_init;
> -		rk_rng->rng.cleanup = rk_rng_cleanup;
> +		rk_rng->rng.init = rk_rng->soc_data->rk_rng_init;
> +		rk_rng->rng.cleanup = rk_rng->soc_data->rk_rng_cleanup;
>  	}
> -	rk_rng->rng.read = rk_rng_read;
> +	rk_rng->rng.read = rk_rng->soc_data->rk_rng_read;
>  	rk_rng->dev = dev;
> -	rk_rng->rng.quality = 900;
> +	rk_rng->rng.quality = rk_rng->soc_data->quality;
>  
>  	pm_runtime_set_autosuspend_delay(dev, RK_RNG_AUTOSUSPEND_DELAY);
>  	pm_runtime_use_autosuspend(dev);
> @@ -184,7 +386,7 @@ static int __maybe_unused rk_rng_runtime_suspend(struct device *dev)
>  {
>  	struct rk_rng *rk_rng = dev_get_drvdata(dev);
>  
> -	rk_rng_cleanup(&rk_rng->rng);
> +	rk_rng->soc_data->rk_rng_cleanup(&rk_rng->rng);
>  
>  	return 0;
>  }
> @@ -193,7 +395,7 @@ static int __maybe_unused rk_rng_runtime_resume(struct device *dev)
>  {
>  	struct rk_rng *rk_rng = dev_get_drvdata(dev);
>  
> -	return rk_rng_init(&rk_rng->rng);
> +	return rk_rng->soc_data->rk_rng_init(&rk_rng->rng);
>  }
>  
>  static const struct dev_pm_ops rk_rng_pm_ops = {
> @@ -203,13 +405,6 @@ static const struct dev_pm_ops rk_rng_pm_ops = {
>  				pm_runtime_force_resume)
>  };
>  
> -static const struct of_device_id rk_rng_dt_match[] = {
> -	{ .compatible = "rockchip,rk3568-rng", },
> -	{ /* sentinel */ },
> -};


No, don't move it. Not necessary and not expected to be in other place.

Best regards,
Krzysztof
