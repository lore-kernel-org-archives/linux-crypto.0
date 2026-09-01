Received: from akranes.kaiser.cx (akranes.kaiser.cx [152.53.16.207])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4552647F2ED;
	Tue,  1 Sep 2026 13:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=152.53.16.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788270018; cv=none; b=VDXuuxN2Ym4pDJTcl3G1DJ/JLM+sI9BtoI4p0QWyz8jbjzPQYJFnpskE/aQD2vHIC0CNLg1j6rvr9PwrJmg5Cx/mGHRteWwsdurub8FEgm59d1vMuyDlrZY8/BrAZNlcmu+oiy2kaZlMdbkgd+zotZWwUDhYD56cq4g27/lase8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788270018; c=relaxed/simple;
	bh=cu+WiGYVnnQEZqIqA53kwEuWAZg41Uqt2VsBUjNQ91E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g5DmXT7hPn5zhnRf03xqdzEj3BzjTObLBZsPmLRL4T3D7aETSXErPkYQfzMvPfgj49p7mLbF4n/Qm0ET6mb6jPhwq7Iwv6TU7v0AxiCUJaF0Pz7JN/0eRN0wCDOqPnhRyGH6hYiAIDqx6p8KkaDklieprxQeKqyZCY5+HySN3I8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kaiser.cx; spf=pass smtp.mailfrom=kaiser.cx; arc=none smtp.client-ip=152.53.16.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kaiser.cx
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kaiser.cx
Received: from martin by akranes.kaiser.cx with local (Exim 4.98.2)
	(envelope-from <martin@akranes.kaiser.cx>)
	id 1x1Oih-000000008Jv-2X2P;
	Tue, 01 Sep 2026 15:40:11 +0200
Date: Tue, 1 Sep 2026 15:40:11 +0200
From: Martin Kaiser <martin@kaiser.cx>
To: Pengpeng Hou <pengpeng@iscas.ac.cn>
Cc: Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Frank Li <Frank.Li@nxp.com>, Sascha Hauer <s.hauer@pengutronix.de>,
	Pengutronix Kernel Team <kernel@pengutronix.de>,
	Fabio Estevam <festevam@gmail.com>, linux-crypto@vger.kernel.org,
	imx@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hwrng: imx-rngc: propagate clock enable errors
Message-ID: <apbVu9mZpjslNi6k@akranes.kaiser.cx>
References: <20260830131253.2718-1-pengpeng@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260830131253.2718-1-pengpeng@iscas.ac.cn>
Sender: "Martin Kaiser,,," <martin@akranes.kaiser.cx>

Thus wrote Pengpeng Hou (pengpeng@iscas.ac.cn):

> imx_rngc_probe() reads hardware registers after enabling its clock without
> checking the result, and the runtime resume callback always reports success
> after the same unchecked operation.

> Propagate clock-enable errors before accessing the RNG and to the
> runtime-PM
> core on resume.

> Fixes: 1d5449445bd0 ("hwrng: mx-rngc - add a driver for Freescale RNGC")
> Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
> ---
>  drivers/char/hw_random/imx-rngc.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)

> diff --git a/drivers/char/hw_random/imx-rngc.c b/drivers/char/hw_random/imx-rngc.c
> index 7693328f10564..00a21d62c79c3 100644
> --- a/drivers/char/hw_random/imx-rngc.c
> +++ b/drivers/char/hw_random/imx-rngc.c
> @@ -266,7 +266,9 @@ static int __init imx_rngc_probe(struct platform_device *pdev)
>  	if (irq < 0)
>  		return irq;

> -	clk_prepare_enable(rngc->clk);
> +	ret = clk_prepare_enable(rngc->clk);
> +	if (ret)
> +		return ret;

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

> base-commit: 08dbfad3f5040f5bdb6c529da20d6d4e81fefd72
> -- 
> 2.50.1

The same patch was sent 2 days ago.

https://lore.kernel.org/linux-crypto/apHlIGM3_GHf86fK@SMW015318/T/#t
