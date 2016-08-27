From: Jason Cooper <jason@lakedaemon.net>
Subject: Re: [PATCH v3 6/8] hwrng: amd: Replace global variable with private
 struct
Date: Sat, 27 Aug 2016 14:43:31 +0000
Message-ID: <20160827144331.GK10637@io.lakedaemon.net>
References: <1472209896-17197-1-git-send-email-clabbe.montjoie@gmail.com>
 <1472209896-17197-7-git-send-email-clabbe.montjoie@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: mpm@selenic.com, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: LABBE Corentin <clabbe.montjoie@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pmta2.delivery5.ore.mailhop.org ([54.186.218.12]:36933 "EHLO
        pmta2.delivery5.ore.mailhop.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750746AbcH0On4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 27 Aug 2016 10:43:56 -0400
Content-Disposition: inline
In-Reply-To: <1472209896-17197-7-git-send-email-clabbe.montjoie@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Corentin,

On Fri, Aug 26, 2016 at 01:11:34PM +0200, LABBE Corentin wrote:
> Instead of having two global variable, it's better to use a
> private struct. This will permit to remove amd_pdev variable
> 
> Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
> ---
>  drivers/char/hw_random/amd-rng.c | 57 ++++++++++++++++++++++++++--------------
>  1 file changed, 38 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/char/hw_random/amd-rng.c b/drivers/char/hw_random/amd-rng.c
> index 383e197..4ef94e9 100644
> --- a/drivers/char/hw_random/amd-rng.c
> +++ b/drivers/char/hw_random/amd-rng.c
> @@ -47,15 +47,18 @@ static const struct pci_device_id pci_tbl[] = {
>  };
>  MODULE_DEVICE_TABLE(pci, pci_tbl);
>  
> -static struct pci_dev *amd_pdev;
> +struct amd768_priv {
> +	struct pci_dev *pcidev;
> +	u32 pmbase;
> +};
>  
>  static int amd_rng_data_present(struct hwrng *rng, int wait)
>  {
> -	u32 pmbase = (u32)rng->priv;
> +	struct amd768_priv *priv = (struct amd768_priv *)rng->priv;

Please remove unnecessary casts...

>  	int data, i;
>  
>  	for (i = 0; i < 20; i++) {
> -		data = !!(inl(pmbase + 0xF4) & 1);
> +		data = !!(inl(priv->pmbase + 0xF4) & 1);
>  		if (data || !wait)
>  			break;
>  		udelay(10);
> @@ -65,35 +68,37 @@ static int amd_rng_data_present(struct hwrng *rng, int wait)
>  
>  static int amd_rng_data_read(struct hwrng *rng, u32 *data)
>  {
> -	u32 pmbase = (u32)rng->priv;
> +	struct amd768_priv *priv = (struct amd768_priv *)rng->priv;

here,

>  
> -	*data = inl(pmbase + 0xF0);
> +	*data = inl(priv->pmbase + 0xF0);
>  
>  	return 4;
>  }
>  
>  static int amd_rng_init(struct hwrng *rng)
>  {
> +	struct amd768_priv *priv = (struct amd768_priv *)rng->priv;

here,

>  	u8 rnen;
>  
> -	pci_read_config_byte(amd_pdev, 0x40, &rnen);
> +	pci_read_config_byte(priv->pcidev, 0x40, &rnen);
>  	rnen |= BIT(7);	/* RNG on */
> -	pci_write_config_byte(amd_pdev, 0x40, rnen);
> +	pci_write_config_byte(priv->pcidev, 0x40, rnen);
>  
> -	pci_read_config_byte(amd_pdev, 0x41, &rnen);
> +	pci_read_config_byte(priv->pcidev, 0x41, &rnen);
>  	rnen |= BIT(7);	/* PMIO enable */
> -	pci_write_config_byte(amd_pdev, 0x41, rnen);
> +	pci_write_config_byte(priv->pcidev, 0x41, rnen);
>  
>  	return 0;
>  }
>  
>  static void amd_rng_cleanup(struct hwrng *rng)
>  {
> +	struct amd768_priv *priv = (struct amd768_priv *)rng->priv;

here,

>  	u8 rnen;
>  
> -	pci_read_config_byte(amd_pdev, 0x40, &rnen);
> +	pci_read_config_byte(priv->pcidev, 0x40, &rnen);
>  	rnen &= ~BIT(7);	/* RNG off */
> -	pci_write_config_byte(amd_pdev, 0x40, rnen);
> +	pci_write_config_byte(priv->pcidev, 0x40, rnen);
>  }
>  
>  static struct hwrng amd_rng = {
> @@ -110,6 +115,7 @@ static int __init mod_init(void)
>  	struct pci_dev *pdev = NULL;
>  	const struct pci_device_id *ent;
>  	u32 pmbase;
> +	struct amd768_priv *priv;
>  
>  	for_each_pci_dev(pdev) {
>  		ent = pci_match_id(pci_tbl, pdev);
> @@ -117,24 +123,30 @@ static int __init mod_init(void)
>  			goto found;
>  	}
>  	/* Device not found. */
> -	goto out;
> +	return -ENODEV;
>  
>  found:
>  	err = pci_read_config_dword(pdev, 0x58, &pmbase);
>  	if (err)
> -		goto out;
> -	err = -EIO;
> +		return err;
> +
>  	pmbase &= 0x0000FF00;
>  	if (pmbase == 0)
> -		goto out;
> +		return -EIO;
> +
> +	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
> +	if (!priv)
> +		return -ENOMEM;
> +
>  	if (!request_region(pmbase + 0xF0, 8, DRV_NAME)) {
>  		dev_err(&pdev->dev, DRV_NAME " region 0x%x already in use!\n",
>  			pmbase + 0xF0);
>  		err = -EBUSY;
>  		goto out;
>  	}
> -	amd_rng.priv = (unsigned long)pmbase;
> -	amd_pdev = pdev;
> +	amd_rng.priv = (unsigned long)priv;

here,

> +	priv->pmbase = pmbase;
> +	priv->pcidev = pdev;
>  
>  	pr_info(DRV_NAME " detected\n");
>  	err = hwrng_register(&amd_rng);
> @@ -143,17 +155,24 @@ found:
>  		release_region(pmbase + 0xF0, 8);
>  		goto out;
>  	}
> +	return 0;
> +
>  out:
> +	kfree(priv);
>  	return err;
>  }
>  
>  static void __exit mod_exit(void)
>  {
> -	u32 pmbase = (unsigned long)amd_rng.priv;
> +	struct amd768_priv *priv;
> +
> +	priv = (struct amd768_priv *)amd_rng.priv;

and here.

thx,

Jason.

>  
>  	hwrng_unregister(&amd_rng);
>  
> -	release_region(pmbase + 0xF0, 8);
> +	release_region(priv->pmbase + 0xF0, 8);
> +
> +	kfree(priv);
>  }
>  
>  module_init(mod_init);
> -- 
> 2.7.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
