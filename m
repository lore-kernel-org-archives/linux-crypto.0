Received: from mta0.migadu.com (out-131.mta0.migadu.com [91.218.175.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98B1A472559
	for <linux-crypto@vger.kernel.org>; Mon,  7 Sep 2026 15:35:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788795355; cv=none; b=U/4xO+53JMJ6W6FkxIaqsyraV6lm/L2+hMoM2o8E7N7E0Y4wm3VVw4b8vU1hasMC/DoWk9taRzwmhjCS/695NfDnztnSc+LaP7u1moaVcn0pnysTJ/MqbZiY/0VnmrW3EeMIAvBMQEYQlfp+NQARrnxCe/Vqtnqm7JZgGfrWkOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788795355; c=relaxed/simple;
	bh=4OTPXHDiuNNuf93mp8+p2+oWYW7epD7qLYESXNMzU6w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SSdp+unqC/CBxEZn+YVf/b0cc7I4DctNAVG9RtYbGqbIcVvCnLOPa/nQvLgu0FTeGyXhdkCfiB+SG/b29ujj1PxLTQJY7L6txo7A88BA0wWSxwA9xvPDCP3xDPamcij4go8oYaBqMeDHDgh7edBkP099lTFPEMHAlUKZBqBxCz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Lz8ST9Yx; arc=none smtp.client-ip=91.218.175.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Lz8ST9Yx"
X-Envelope-To: linux-crypto@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=4OTPXHDiuNNuf93mp8+p2+oWYW7epD7qLYESXNMzU6w=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788795351; v=1; x=1789400151;
 b=Lz8ST9YxfJTIfAc4UA7y0QoGvqmzL15tR7+8OrsgpU7Qy0cQbm+xXfr8DAY6SgRj2S/pLKF/
 wSckMbK0ZEiVccgixZl67NdHsQM5g040UzYRXzzTKh1Fix/tSVozGa216C5lyyMozYTfux1J24T
 VQ9e2T3osKYKsxznrNLfcC+A=
X-Envelope-To: linux-crypto@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id f56cf53ea85e6c77;
	Mon, 07 Sep 2026 15:35:51 +0000
X-Mizu-Trace-ID: f56cf53ea85e6c77
X-Migadu-Flow: FLOW_OUT
Date: Mon, 7 Sep 2026 17:35:48 +0200
From: Richard Leitner <richard.leitner@linux.dev>
To: Rosen Penev <rosenp@gmail.com>
Cc: linux-crypto@vger.kernel.org, 
	Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>, Pankaj Gupta <pankaj.gupta@nxp.com>, 
	Gaurav Jain <gaurav.jain@nxp.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S. Miller" <davem@davemloft.net>, open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crypto: caam: map job ring registers without claiming
 region
Message-ID: <ap7ZnqCqpfRTLfUF@bombadil>
References: <20260901203736.13248-1-rosenp@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260901203736.13248-1-rosenp@gmail.com>

Hi Rosen,

On Tue, Sep 01, 2026 at 01:37:36PM -0700, Rosen Penev wrote:
> devm_platform_ioremap_resource() ends up calling request_mem_region(),
> which fails with -EBUSY on i.MX SoCs:
> 
> There the job rings are modelled as sub-regions of their parent
> fsl,sec-v4.0 register window, and caam_probe() already reserves the
> whole window exclusively via devm_of_iomap() before the children are
> populated.  Every job ring therefore collides with its own parent and
> fails to probe, taking the hardware RNG offline (seen on i.MX6, i.MX7
> and i.MX8 boards such as colibri-imx7 and verdin-imx8mp).
> 
> Map the job ring registers with devm_ioremap() instead, which does not
> claim the (already owned) region.
> 
> Fixes: 9a955c0a7d11 ("crypto: caam - simplify probe resource and IRQ handling")
> Assisted-by: opencode:big-pickle
> Signed-off-by: Rosen Penev <rosenp@gmail.com>

thanks for that fix!

Tested-by: Richard Leitner <richard.leitner@linux.dev> # i.MX8MP

regards;rl

> ---
>  drivers/crypto/caam/jr.c | 23 ++++++++++++++++++++---
>  1 file changed, 20 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/crypto/caam/jr.c b/drivers/crypto/caam/jr.c
> index f9e029945b51..2ed8229d4733 100644
> --- a/drivers/crypto/caam/jr.c
> +++ b/drivers/crypto/caam/jr.c
> @@ -583,12 +583,29 @@ static int caam_jr_probe(struct platform_device *pdev)
>  	struct caam_drv_private_jr *jrpriv;
>  	static int total_jobrs;
>  	void __iomem *ctrl;
> +	struct resource *r;
>  	int error;
>  	int irq;
>  
> -	ctrl = devm_platform_ioremap_resource(pdev, 0);
> -	if (IS_ERR(ctrl))
> -		return PTR_ERR(ctrl);
> +	/*
> +	 * The job rings live inside the register window of their parent
> +	 * fsl,sec-v4.0 node, which caam_probe() already reserves (and maps)
> +	 * via devm_of_iomap().  A requested region that overlaps that
> +	 * reservation, e.g. from devm_platform_ioremap_resource(), would
> +	 * therefore fail with -EBUSY, so map the registers without claiming
> +	 * the region here.
> +	 */
> +	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (!r) {
> +		dev_err(&pdev->dev, "platform_get_resource() failed\n");
> +		return -EINVAL;
> +	}
> +
> +	ctrl = devm_ioremap(&pdev->dev, r->start, resource_size(r));
> +	if (!ctrl) {
> +		dev_err(&pdev->dev, "devm_ioremap() failed\n");
> +		return -ENOMEM;
> +	}
>  
>  	irq = platform_get_irq(pdev, 0);
>  	if (irq < 0)
> -- 
> 2.55.0
> 
> 
