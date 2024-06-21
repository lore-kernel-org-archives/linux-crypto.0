Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8F6016E860;
	Fri, 21 Jun 2024 09:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718963888; cv=none; b=JGeCeuFIblTemZXdrJpp5kFmPj68VjwvUAUzkQ9xMO7uhK0N1IMnfbKl3MpVH0cdhiuS6dnvexDHKLJZP/7IaUO3/SclsKdr92TlSMyInn5h5wg+SyydF+PQzvAyjCEUkoYUVkjknHlVfseoKZXt3mKzLa3HK35Z6mNNBM1+TAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718963888; c=relaxed/simple;
	bh=UnxwRbCuBhggYeSXiYfvMZrlDoEB2JpNNPUtYoo6gpw=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=cfiSYzIlPNsYK/qfLmVVwTk0pAubrU0wCtOO//v17P6U6BFUeEDsBGtj0o9/JnamCm03Se9/fD30RjO/MDAYVUz+JaYltEJVKwpDTyp4gqyuun/oD9rsWQ4pL8DtzzMZpPPmHbXvUZXkaIAz17xKW9oGWJ030pc7x2t4uGiUMyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=II8XZYHa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="II8XZYHa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AF1EC32781;
	Fri, 21 Jun 2024 09:58:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718963887;
	bh=UnxwRbCuBhggYeSXiYfvMZrlDoEB2JpNNPUtYoo6gpw=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=II8XZYHa0nSXcmJ4Au8CDk6LzP05gOlsjmoGueyBEacxmAA6OFXrlZ4blwktjqUj4
	 tNsmd7fHdZ5ruNO+L8LPcTUiXtxyuXIkbkHs7MKZdaT3WsQdfZAlYhc5w3H1Wj0fZZ
	 kvIr/aNYGwMJe+mW8PcyWtF0pGzKbjE3rHoic+eTAsA10gXGz8d/D0d2qSv5yt7v5X
	 qTNDQ7g/TuK7YBOKevFzx1hTAqj9f4jDps+MC31GizdyADRaY2gYd+3hYbkWbB1fKK
	 P6fhf86Oy1QUruF8upRVvWLEQRz/r56El1RWD1vLaLXwLNUh2INkDWI6CeWTFzIFTU
	 WmtzdZGz3LiMQ==
Message-ID: <f8e6b1b9-f8ff-42df-b1ef-bcc439c2e913@kernel.org>
Date: Fri, 21 Jun 2024 11:57:58 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/3] hwrng: add Rockchip SoC hwrng driver
To: Daniel Golle <daniel@makrotopia.org>,
 Aurelien Jarno <aurelien@aurel32.net>, Olivia Mackall <olivia@selenic.com>,
 Herbert Xu <herbert@gondor.apana.org.au>, Rob Herring <robh@kernel.org>,
 Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley
 <conor+dt@kernel.org>, Heiko Stuebner <heiko@sntech.de>,
 Philipp Zabel <p.zabel@pengutronix.de>,
 =?UTF-8?Q?Uwe_Kleine-K=C3=B6nig?= <ukleinek@debian.org>,
 Sebastian Reichel <sebastian.reichel@collabora.com>,
 Anand Moon <linux.amoon@gmail.com>, Dragan Simic <dsimic@manjaro.org>,
 Sascha Hauer <s.hauer@pengutronix.de>, Martin Kaiser <martin@kaiser.cx>,
 Ard Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org,
 devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org
References: <cover.1718921174.git.daniel@makrotopia.org>
 <57a7fb13451f066ddc8d1d9339d8f6c1e1946bf1.1718921174.git.daniel@makrotopia.org>
From: Krzysztof Kozlowski <krzk@kernel.org>
Content-Language: en-US
Autocrypt: addr=krzk@kernel.org; keydata=
 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 fv0=
In-Reply-To: <57a7fb13451f066ddc8d1d9339d8f6c1e1946bf1.1718921174.git.daniel@makrotopia.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 21/06/2024 03:25, Daniel Golle wrote:
> From: Aurelien Jarno <aurelien@aurel32.net>
> 

> +
> +static int rk_rng_init(struct hwrng *rng)
> +{
> +	struct rk_rng *rk_rng = container_of(rng, struct rk_rng, rng);
> +	int ret;
> +
> +	/* start clocks */
> +	ret = clk_bulk_prepare_enable(rk_rng->clk_num, rk_rng->clk_bulks);
> +	if (ret < 0) {
> +		dev_err((struct device *) rk_rng->rng.priv,
> +			"Failed to enable clks %d\n", ret);
> +		return ret;
> +	}
> +
> +	/* set the sample period */
> +	writel(RK_RNG_SAMPLE_CNT, rk_rng->base + TRNG_RNG_SAMPLE_CNT);
> +
> +	/* set osc ring speed and enable it */
> +	writel_relaxed(TRNG_RNG_CTL_LEN_256_BIT |
> +		       TRNG_RNG_CTL_OSC_RING_SPEED_0 |
> +		       TRNG_RNG_CTL_ENABLE,
> +		       rk_rng->base + TRNG_RNG_CTL);

I doubt relaxed write is here intentional. Enabling should be last
instruction, so this should be ordered write.

> +
> +	return 0;
> +}
> +
> +static void rk_rng_cleanup(struct hwrng *rng)
> +{
> +	struct rk_rng *rk_rng = container_of(rng, struct rk_rng, rng);
> +
> +	/* stop TRNG */
> +	writel_relaxed(0, rk_rng->base + TRNG_RNG_CTL);

This should not be relaxed. This might lead to very tricky to debug issues.

> +
> +	/* stop clocks */
> +	clk_bulk_disable_unprepare(rk_rng->clk_num, rk_rng->clk_bulks);
> +}
> +
> +static int rk_rng_read(struct hwrng *rng, void *buf, size_t max, bool wait)
> +{
> +	struct rk_rng *rk_rng = container_of(rng, struct rk_rng, rng);
> +	size_t to_read = min_t(size_t, max, RK_RNG_MAX_BYTE);
> +	u32 reg;
> +	int ret = 0;
> +
> +	ret = pm_runtime_get_sync((struct device *) rk_rng->rng.priv);

Why this cannot be just simpler pm_runtime_resume_and_get()?

> +	if (ret < 0)
> +		goto out;

This does not look like correct error path. Device was not busy here.

> +
> +	/* Start collecting random data */
> +	writel_relaxed(TRNG_RNG_CTL_START, rk_rng->base + TRNG_RNG_CTL);
> +
> +	ret = readl_poll_timeout(rk_rng->base + TRNG_RNG_CTL, reg,
> +				 !(reg & TRNG_RNG_CTL_START),
> +				 RK_RNG_POLL_PERIOD_US,
> +				 RK_RNG_POLL_TIMEOUT_US);
> +	if (ret < 0)
> +		goto out;
> +
> +	/* Read random data stored in the registers */
> +	memcpy_fromio(buf, rk_rng->base + TRNG_RNG_DOUT, to_read);
> +out:
> +	pm_runtime_mark_last_busy((struct device *) rk_rng->rng.priv);
> +	pm_runtime_put_sync_autosuspend((struct device *) rk_rng->rng.priv);
> +
> +	return to_read;
> +}
> +
> +static int rk_rng_probe(struct platform_device *pdev)
> +{
> +	struct device *dev = &pdev->dev;
> +	struct rk_rng *rk_rng;
> +	int ret;
> +
> +	rk_rng = devm_kzalloc(dev, sizeof(*rk_rng), GFP_KERNEL);
> +	if (!rk_rng)
> +		return -ENOMEM;
> +
> +	rk_rng->base = devm_platform_ioremap_resource(pdev, 0);
> +	if (IS_ERR(rk_rng->base))
> +		return PTR_ERR(rk_rng->base);
> +
> +	rk_rng->clk_num = devm_clk_bulk_get_all(dev, &rk_rng->clk_bulks);
> +	if (rk_rng->clk_num < 0)
> +		return dev_err_probe(dev, rk_rng->clk_num,
> +				     "Failed to get clks property\n");
> +
> +	rk_rng->rst = devm_reset_control_array_get(&pdev->dev, false, false);
> +	if (IS_ERR(rk_rng->rst))
> +		return dev_err_probe(dev, PTR_ERR(rk_rng->rst),
> +				     "Failed to get reset property\n");
> +
> +	reset_control_assert(rk_rng->rst);
> +	udelay(2);
> +	reset_control_deassert(rk_rng->rst);
> +
> +	platform_set_drvdata(pdev, rk_rng);
> +
> +	rk_rng->rng.name = dev_driver_string(dev);
> +#ifndef CONFIG_PM
> +	rk_rng->rng.init = rk_rng_init;
> +	rk_rng->rng.cleanup = rk_rng_cleanup;
> +#endif
> +	rk_rng->rng.read = rk_rng_read;
> +	rk_rng->rng.priv = (unsigned long) dev;
> +	rk_rng->rng.quality = 900;
> +
> +	pm_runtime_set_autosuspend_delay(dev, RK_RNG_AUTOSUSPEND_DELAY);
> +	pm_runtime_use_autosuspend(dev);
> +	pm_runtime_enable(dev);
> +
> +	ret = devm_hwrng_register(dev, &rk_rng->rng);
> +	if (ret)
> +		return dev_err_probe(&pdev->dev, ret, "Failed to register Rockchip hwrng\n");
> +
> +	dev_info(&pdev->dev, "Registered Rockchip hwrng\n");

Drop, driver should be silent on success.


Best regards,
Krzysztof

