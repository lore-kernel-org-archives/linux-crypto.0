Received: from akranes.kaiser.cx (akranes.kaiser.cx [152.53.16.207])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF86E459ACC
	for <linux-crypto@vger.kernel.org>; Fri, 11 Sep 2026 07:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=152.53.16.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789113537; cv=none; b=s6778zwaztKkPq3icQWzxsHlei1J/pwrtDHesfjbkV2JEim5NLWW9VW4i0jGDnX8e0fHlKNtDD0orC8R+Wqv1EotA9O0XDQCJ1xbzO1zO5lOKq5G3YJz92PYNeg7l8IqqTPtD/Z8WNdK6jqqfiP1AaiOT/yGsmvYTOyduq0S5Ik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789113537; c=relaxed/simple;
	bh=YVwPmnANfRTZiL65G5zBgldSynfbsJJAuqkyQODaSuw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mBR6/+WWgmDkhoiVVOaLSjqjYAye+0s6S4dj4E2y7/0sSFBF5apvEDOHIWepDIwgtowXu/flIxTHkzizgPcLYypkXoRZYu69TO2MojV3SF+hnMG7veqBWrc2bxxNFEjEtv3OBD61jHE6+fAaDLr4rdBwQK2uzitVEcPLdrwlyJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kaiser.cx; spf=pass smtp.mailfrom=kaiser.cx; arc=none smtp.client-ip=152.53.16.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kaiser.cx
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kaiser.cx
Received: from martin by akranes.kaiser.cx with local (Exim 4.98.2)
	(envelope-from <martin@akranes.kaiser.cx>)
	id 1x4vQz-0000000269l-0NV4;
	Fri, 11 Sep 2026 09:12:29 +0200
Date: Fri, 11 Sep 2026 09:12:29 +0200
From: Martin Kaiser <lists@kaiser.cx>
To: Ma Yukun <0x4fe6@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, linux-crypto@vger.kernel.org
Subject: Re: [PATCH v2] hwrng: imx-rngc - check return value of
 clk_prepare_enable()
Message-ID: <aqOp3R0imhec2HnT@akranes.kaiser.cx>
References: <178869518976.1724.8613243679737914482@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178869518976.1724.8613243679737914482@gmail.com>
Sender: "Martin Kaiser,,," <martin@akranes.kaiser.cx>

Thus wrote Ma Yukun (0x4fe6@gmail.com):

> clk_prepare_enable() can fail here and its return value is currently
> ignored. If the clock fails to enable, the probe continues to read
> from the hardware registers without a clock, which can cause a bus
> hang or external abort.

> Check the return value and fail probe if the clock cannot be enabled.

> Fixes: 1d5449445bd0 ("hwrng: mx-rngc - add a driver for Freescale RNGC")
> Signed-off-by: Ma Yukun <0x4fe6@gmail.com>
> ---
> v2: fix patch formatting, add missing context line

>  drivers/char/hw_random/imx-rngc.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)

> diff --git a/drivers/char/hw_random/imx-rngc.c b/drivers/char/hw_random/imx-rngc.c
> index 7693328f1..58bdc7a6b 100644
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
> -- 
> 2.43.0

This has already been fixed.

https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git/commit/?id=8ba2b068e1b3607289ba5778e4c27c167fdbfee6
