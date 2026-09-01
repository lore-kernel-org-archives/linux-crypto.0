Received: from akranes.kaiser.cx (akranes.kaiser.cx [152.53.16.207])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 087613CF69C;
	Tue,  1 Sep 2026 14:38:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=152.53.16.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788273491; cv=none; b=mUISa1//q8vLkVMCoOQksoXwnkblL2T9Al2IzaabS6S0zJFsymJOUrp6Y+7A3Nd9RLQa1RyX/fq3vcyOwJElsaLcPxBa1Bfxc0cGHQrPnkqlSBm3fXIRrLQw4kjly79ay6wVe0n4ErsfejW6lNc7JtdRooagJPcrmj9gYGIlBNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788273491; c=relaxed/simple;
	bh=vRyNLazXP1e8ANoUtX3YW+HEjCG4akum5RZjtd9xnnA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uliM62a44c0hYacWstDZVAlgVIThx8CP/d54h3XPh4GfesZImgsWtJNqRJK+NL5JUABI+3+Qg1OvBzt7p9c34E9bNRUEBD27bywRnyTRE2Zu22NLun7e0Q0V2chI8UYT+SGKzyFgc4y7szCaSKXxlafofsrW5KwutZ1t6JmMaVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kaiser.cx; spf=pass smtp.mailfrom=kaiser.cx; arc=none smtp.client-ip=152.53.16.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kaiser.cx
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kaiser.cx
Received: from martin by akranes.kaiser.cx with local (Exim 4.98.2)
	(envelope-from <martin@akranes.kaiser.cx>)
	id 1x1Ofx-000000008HO-48hU;
	Tue, 01 Sep 2026 15:37:21 +0200
Date: Tue, 1 Sep 2026 15:37:21 +0200
From: Martin Kaiser <martin@kaiser.cx>
To: Li Youhong <dayou5941@163.com>
Cc: olivia@selenic.com, herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org, imx@lists.linux.dev,
	Li Youhong <liyouhong@kylinos.cn>
Subject: Re: [PATCH] hwrng: imx-rngc: check clk_prepare_enable() return value
Message-ID: <apbVER_TVhLLqA9X@akranes.kaiser.cx>
References: <20260828025423.2149304-1-dayou5941@163.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260828025423.2149304-1-dayou5941@163.com>
Sender: "Martin Kaiser,,," <martin@akranes.kaiser.cx>

Thus wrote Li Youhong (dayou5941@163.com):

> From: Li Youhong <liyouhong@kylinos.cn>

> The driver ignored clk_prepare_enable() failures during probe and
> resume.  If enabling the RNG clock fails, subsequent register accesses
> or resume after system sleep may not work while the driver still reports
> success.

> Signed-off-by: Li Youhong <liyouhong@kylinos.cn>
> ---
>  drivers/char/hw_random/imx-rngc.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)

> diff --git a/drivers/char/hw_random/imx-rngc.c b/drivers/char/hw_random/imx-rngc.c
> index 7693328f1056..0545a1870146 100644
> --- a/drivers/char/hw_random/imx-rngc.c
> +++ b/drivers/char/hw_random/imx-rngc.c
> @@ -266,7 +266,9 @@ static int __init imx_rngc_probe(struct platform_device *pdev)
>  	if (irq < 0)
>  		return irq;

> -	clk_prepare_enable(rngc->clk);
> +	ret = clk_prepare_enable(rngc->clk);
> +	if (ret)
> +		return dev_err_probe(&pdev->dev, ret, "Cannot enable rng_clk\n");

>  	ver_id = readl(rngc->base + RNGC_VER_ID);
>  	rng_type = FIELD_GET(RNG_TYPE, ver_id);
> @@ -338,9 +340,7 @@ static int imx_rngc_resume(struct device *dev)
>  {
>  	struct imx_rngc *rngc = dev_get_drvdata(dev);

> -	clk_prepare_enable(rngc->clk);
> -
> -	return 0;
> +	return clk_prepare_enable(rngc->clk);
>  }

>  static const struct dev_pm_ops imx_rngc_pm_ops = {
> -- 
> 2.25.1

Reviewed-by: Martin Kaiser <martin@kaiser.cx>
