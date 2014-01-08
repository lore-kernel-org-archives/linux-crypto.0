From: Tomasz Figa <tomasz.figa@gmail.com>
Subject: Re: [PATCH 1/5] crypto:s5p-sss: Use platform_get_irq() instead of _byname()
Date: Wed, 08 Jan 2014 01:14:36 +0100
Message-ID: <3711506.y7zYNNW8hU@flatron>
References: <1389095509-14357-1-git-send-email-ch.naveen@samsung.com> <1389095509-14357-2-git-send-email-ch.naveen@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	linux-kernel@vger.kernel.org, vzapolskiy@gmail.com,
	herbert@gondor.apana.org.au, naveenkrishna.ch@gmail.com,
	cpgs@samsung.com, "David S. Miller" <davem@davemloft.net>
To: Naveen Krishna Ch <ch.naveen@samsung.com>
Return-path: <linux-samsung-soc-owner@vger.kernel.org>
In-Reply-To: <1389095509-14357-2-git-send-email-ch.naveen@samsung.com>
Sender: linux-samsung-soc-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Naveen,

Please see my comments inline.

On Tuesday 07 of January 2014 17:21:45 Naveen Krishna Ch wrote:
> This patch uses the platform_get_irq() instead of the
> platform_get_irq_byname(). Making feeder control interrupt
> as resource "0" and hash interrupt as "1".
> 
> reasons for this change.
> 1. Cannot find any Arch which is currently using this driver
> 2. Samsung Exynos5 SoCs only use the feeder control interrupt
> 3. Patches adding support for DT and H/W version are in pipeline
> 
> Signed-off-by: Naveen Krishna Ch <ch.naveen@samsung.com>
> CC: Herbert Xu <herbert@gondor.apana.org.au>
> CC: David S. Miller <davem@davemloft.net>
> CC: Vladimir Zapolskiy <vzapolskiy@gmail.com>
> TO: <linux-crypto@vger.kernel.org>
> CC: <linux-samsung-soc@vger.kernel.org>
> ---
>  drivers/crypto/s5p-sss.c |   22 +++++++++++-----------
>  1 file changed, 11 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
> index cf149b1..dda4551 100644
> --- a/drivers/crypto/s5p-sss.c
> +++ b/drivers/crypto/s5p-sss.c
> @@ -592,29 +592,29 @@ static int s5p_aes_probe(struct platform_device *pdev)
>  	pdata->ioaddr = devm_ioremap(dev, res->start,
>  				     resource_size(res));
>  
> -	pdata->irq_hash = platform_get_irq_byname(pdev, "hash");
> -	if (pdata->irq_hash < 0) {
> +	pdata->irq_fc = platform_get_irq(pdev, 0);
> +	if (pdata->irq_fc < 0) {
>  		err = pdata->irq_hash;

Shouldn't this be also changed to err = pdata->irq_fc; ?

Best regards,
Tomasz
