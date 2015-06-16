From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH RFC 03/11] crypto: caam - Enable and disable clocks on
 Freescale i.MX platforms
Date: Tue, 16 Jun 2015 12:30:28 +0800
Message-ID: <20150616043028.GB20116@gondor.apana.org.au>
References: <1434412379-11623-1-git-send-email-vicki.milhoan@freescale.com>
 <1434412379-11623-4-git-send-email-vicki.milhoan@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, horia.geanta@freescale.com,
	ruchika.gupta@freescale.com
To: Victoria Milhoan <vicki.milhoan@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:45915 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873AbbFPEae (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 16 Jun 2015 00:30:34 -0400
Content-Disposition: inline
In-Reply-To: <1434412379-11623-4-git-send-email-vicki.milhoan@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jun 15, 2015 at 04:52:51PM -0700, Victoria Milhoan wrote:
>
> +#ifdef CONFIG_ARM
> +	/* shut clocks off before finalizing shutdown */
> +	clk_disable_unprepare(ctrlpriv->caam_ipg);
> +	clk_disable_unprepare(ctrlpriv->caam_mem);
> +	clk_disable_unprepare(ctrlpriv->caam_aclk);
> +	clk_disable_unprepare(ctrlpriv->caam_emi_slow);
> +#endif

Can we restructure this so that it is always compiled regardless
of architecture? This will reduce the chance of build errors.

You could do this by first of all hiding ctrlpriv->caam_XXX behind
accessor functions, e.g.:

#ifdef CONFIG_ARM
static inline struct clk *caam_drv_get_ipg(struct caam_drv_private *drv)
{
	return drv->caam_ipg;
}
static inline void caam_drv_set_ipg(struct caam_drv_private *drv,
				    struct clk *clk)
{
	drv->caam_ipg = clk;
}
#else
static inline struct clk *caam_drv_get_ipg(struct caam_drv_private *drv)
{
	return NULL;
}
static inline void caam_drv_set_ipg(struct caam_drv_private *drv,
				    struct clk *clk)
{
}
#endif

Then you could do

	clk_disable_unprepare(caam_drv_get_ipg(ctrlpriv));

> +/*
> + * ARM targets tend to have clock control subsystems that can
> + * enable/disable clocking to our device. Turn clocking on to proceed
> + */
> +#ifdef CONFIG_ARM
> +	ctrlpriv->caam_ipg = devm_clk_get(&pdev->dev, "caam_ipg");
> +	if (IS_ERR(ctrlpriv->caam_ipg)) {
> +		ret = PTR_ERR(ctrlpriv->caam_ipg);
> +		dev_err(&pdev->dev,
> +			"can't identify CAAM ipg clk: %d\n", ret);
> +		return -ENODEV;
> +	}

This then becomes:

	struct clk *clk;

	clk = devm_clk_get(&pdev->dev, "caam_ipg");
	if (IS_ERR(clk))
		ret = PTR_ERR(clk);
		dev_err(&pdev->dev,
			"can't identify CAAM ipg clk: %d\n", ret);
		return -ENODEV;
	}
	caam_drv_set_ipg(ctrlpriv, clk);

And it should all compile away on powerpc.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
