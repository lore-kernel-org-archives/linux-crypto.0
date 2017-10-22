From: Krzysztof Kozlowski <krzk@kernel.org>
Subject: Re: [PATCH] crypto/s5p-sss: Use common error handling code in
 s5p_aes_probe()
Date: Sun, 22 Oct 2017 21:03:27 +0200
Message-ID: <20171022190327.mfndyyr4b4iinv2d@kozik-lap>
References: <791df15e-3a35-d270-0acf-1661bd89adad@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Vladimir Zapolskiy <vz@mleia.com>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
To: SF Markus Elfring <elfring@users.sourceforge.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <791df15e-3a35-d270-0acf-1661bd89adad@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sun, Oct 22, 2017 at 03:05:05PM +0200, SF Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Sun, 22 Oct 2017 15:00:27 +0200
> 
> Add a jump target so that a bit of exception handling can be better reused
> at the end of this function.
> 
> This issue was detected by using the Coccinelle software.
> 
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---
>  drivers/crypto/s5p-sss.c | 13 +++++++------
>  1 file changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
> index 7ac657f46d15..ea59e184c199 100644
> --- a/drivers/crypto/s5p-sss.c
> +++ b/drivers/crypto/s5p-sss.c
> @@ -863,16 +863,13 @@ static int s5p_aes_probe(struct platform_device *pdev)
>  	pdata->irq_fc = platform_get_irq(pdev, 0);
>  	if (pdata->irq_fc < 0) {
>  		err = pdata->irq_fc;
> -		dev_warn(dev, "feed control interrupt is not available.\n");
> -		goto err_irq;
> +		goto report_failure;
>  	}
>  	err = devm_request_threaded_irq(dev, pdata->irq_fc, NULL,
>  					s5p_aes_interrupt, IRQF_ONESHOT,
>  					pdev->name, pdev);
> -	if (err < 0) {
> -		dev_warn(dev, "feed control interrupt is not available.\n");
> -		goto err_irq;
> -	}
> +	if (err < 0)
> +		goto report_failure;

No, one exit path just to report error does not seem to be more
readable. Instead, printing error after the code causing it looks to me
as common pattern, easy to maintain.

This patch does not bring improvement, in my opinion.

Best regards,
Krzysztof


>  
>  	pdata->busy = false;
>  	pdata->dev = dev;
> @@ -906,6 +903,10 @@ static int s5p_aes_probe(struct platform_device *pdev)
>  	s5p_dev = NULL;
>  
>  	return err;
> +
> +report_failure:
> +	dev_warn(dev, "feed control interrupt is not available.\n");
> +	goto err_irq;
>  }
>  
>  static int s5p_aes_remove(struct platform_device *pdev)
> -- 
> 2.14.2
> 
