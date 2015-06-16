From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH RFC 03/11] crypto: caam - Enable and disable clocks on
 Freescale i.MX platforms
Date: Tue, 16 Jun 2015 12:32:04 +0800
Message-ID: <20150616043204.GA21005@gondor.apana.org.au>
References: <1434412379-11623-1-git-send-email-vicki.milhoan@freescale.com>
 <1434412379-11623-4-git-send-email-vicki.milhoan@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, horia.geanta@freescale.com,
	ruchika.gupta@freescale.com
To: Victoria Milhoan <vicki.milhoan@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:46282 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873AbbFPEcH (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 16 Jun 2015 00:32:07 -0400
Content-Disposition: inline
In-Reply-To: <1434412379-11623-4-git-send-email-vicki.milhoan@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jun 15, 2015 at 04:52:51PM -0700, Victoria Milhoan wrote:
>
> +	ret = clk_prepare_enable(ctrlpriv->caam_ipg);
> +	if (ret < 0) {
> +		dev_err(&pdev->dev, "can't enable CAAM ipg clock: %d\n", ret);
> +		return -ENODEV;
> +	}
> +
> +	ret = clk_prepare_enable(ctrlpriv->caam_mem);
> +	if (ret < 0) {
> +		dev_err(&pdev->dev, "can't enable CAAM secure mem clock: %d\n",
> +			ret);
> +		return -ENODEV;
> +	}

Shouldn't this disable caam_ipg?

> +	ret = clk_prepare_enable(ctrlpriv->caam_aclk);
> +	if (ret < 0) {
> +		dev_err(&pdev->dev, "can't enable CAAM aclk clock: %d\n", ret);
> +		return -ENODEV;
> +	}
> +
> +	ret = clk_prepare_enable(ctrlpriv->caam_emi_slow);
> +	if (ret < 0) {
> +		dev_err(&pdev->dev, "can't enable CAAM emi slow clock: %d\n",
> +			ret);
> +		return -ENODEV;
> +	}

And these two as well.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
