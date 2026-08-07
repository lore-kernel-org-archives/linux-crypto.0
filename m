Received: from akranes.kaiser.cx (akranes.kaiser.cx [152.53.16.207])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B948385515;
	Fri,  7 Aug 2026 07:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=152.53.16.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786087561; cv=none; b=HL3B7zp0kP1c5LV52qVps0u/H+FqshW5pv3Lp+0KaWy9gCDhE/ROeZ/kSeWHwcHV/XyqLZHlbCQT21P56hr1x93wwqAfSfQRPDXr9KIe+EzAYb5Gl4ibtGl39SVrJHhuJkcyjJC89+9/Q28Kzvlvo6kfozlbL0nc6TnqHb3YzF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786087561; c=relaxed/simple;
	bh=HOJ+Rzu33em4qLSsQs+9Ux+GLbeWo3AHzpW4Zadq3iE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fvXoRZ0lszNgBwfOMV5HGcPw8pG31x/QTEIrjIrc/XyKWEYPkl7C8fhiGEbWXyaFoNDa4wU9ZZksbPrlXfSn7tpTTGUjO4JVM3Z2Hzv9xg+9NJ8MeDW+vdOJ50j+2sSrOQSqBs6YQJFP7bDgG365m/dGY/cq2udorqfnx8l3oPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kaiser.cx; spf=pass smtp.mailfrom=kaiser.cx; arc=none smtp.client-ip=152.53.16.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kaiser.cx
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kaiser.cx
Received: from martin by akranes.kaiser.cx with local (Exim 4.98.2)
	(envelope-from <martin@akranes.kaiser.cx>)
	id 1wsExQ-00000000lAz-3T2A;
	Fri, 07 Aug 2026 09:25:32 +0200
Date: Fri, 7 Aug 2026 09:25:32 +0200
From: Martin Kaiser <martin@kaiser.cx>
To: Yuho Choi <dbgh9129@gmail.com>
Cc: olivia@selenic.com, herbert@gondor.apana.org.au, Frank.Li@nxp.com,
	s.hauer@pengutronix.de, kernel@pengutronix.de, festevam@gmail.com,
	linux-crypto@vger.kernel.org, imx@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	dakr@kernel.org, o-takashi@sakamocchi.jp, bhelgaas@google.com
Subject: Re: [PATCH v1] hwrng: imx-rngc: Disable clock on registration failure
Message-ID: <anWIbJ_YNM8C-tu3@akranes.kaiser.cx>
References: <20260802222259.577200-1-dbgh9129@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260802222259.577200-1-dbgh9129@gmail.com>
Sender: "Martin Kaiser,,," <martin@akranes.kaiser.cx>

Thus wrote Yuho Choi (dbgh9129@gmail.com):

> The RNGC clock is enabled manually before runtime PM is configured. If
> devm_hwrng_register() fails, probe returns without disabling the clock.
> The devm_pm_runtime_enable() cleanup only disables runtime PM and does not
> call imx_rngc_suspend().

> Disable the clock before returning from this failure path.

> Fixes: 7a96a64e8689 ("hwrng: imx-rngc - add runtime pm")
> Signed-off-by: Yuho Choi <dbgh9129@gmail.com>
> ---
>  drivers/char/hw_random/imx-rngc.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)

> diff --git a/drivers/char/hw_random/imx-rngc.c b/drivers/char/hw_random/imx-rngc.c
> index 28c56c2d1bf6..a2db26d7f790 100644
> --- a/drivers/char/hw_random/imx-rngc.c
> +++ b/drivers/char/hw_random/imx-rngc.c
> @@ -313,8 +313,10 @@ static int __init imx_rngc_probe(struct platform_device *pdev)
>  	devm_pm_runtime_enable(&pdev->dev);

>  	ret = devm_hwrng_register(&pdev->dev, &rngc->rng);
> -	if (ret)
> +	if (ret) {
> +		clk_disable_unprepare(rngc->clk);
>  		return dev_err_probe(&pdev->dev, ret, "hwrng registration failed\n");
> +	}

>  	dev_info(&pdev->dev,
>  		"Freescale RNG%c registered (HW revision %d.%02d)\n",
> -- 
> 2.43.0

Good catch, thanks.

Reviewed-by: Martin Kaiser <martin@kaiser.cx>
