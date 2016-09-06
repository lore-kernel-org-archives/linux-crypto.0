From: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Subject: Re: [PATCH 4/9] hwrng: omap - Use the managed device resource API for registration
Date: Tue, 6 Sep 2016 22:01:39 +0530
Message-ID: <CANc+2y6LeOqSy37x=vXaLPkGM3C5Wh6Yq11ybO+-0DU19wLBUQ@mail.gmail.com>
References: <20160906153857.5503-1-romain.perier@free-electrons.com> <20160906153857.5503-5-romain.perier@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: dsaxena@plexity.net, mpm@selenic.com,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Nadav Haklai <nadavh@marvell.com>,
        Omri Itach <omrii@marvell.com>,
        Shadi Ammouri <shadi@marvell.com>,
        Yahuda Yitschak <yehuday@marvell.com>,
        Hanna Hawa <hannah@marvell.com>,
        Neta Zur Hershkovits <neta@marvell.com>,
        Igal Liberman <igall@marvell.com>,
        Marcin Wojtas <mw@semihalf.com>, linux-crypto@vger.kernel.org
To: Romain Perier <romain.perier@free-electrons.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-yw0-f193.google.com ([209.85.161.193]:33589 "EHLO
        mail-yw0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753676AbcIFQbk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 6 Sep 2016 12:31:40 -0400
Received: by mail-yw0-f193.google.com with SMTP id g192so4980410ywh.0
        for <linux-crypto@vger.kernel.org>; Tue, 06 Sep 2016 09:31:40 -0700 (PDT)
In-Reply-To: <20160906153857.5503-5-romain.perier@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

> Use devm_hwrng_register instead of hwrng_register. It avoids the need
> to handle unregistration explicitly from the remove function.
>
> Signed-off-by: Romain Perier <romain.perier@free-electrons.com>
> ---
>  drivers/char/hw_random/omap-rng.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>
> diff --git a/drivers/char/hw_random/omap-rng.c b/drivers/char/hw_random/omap-rng.c
> index d47b24d..171c3e8 100644
> --- a/drivers/char/hw_random/omap-rng.c
> +++ b/drivers/char/hw_random/omap-rng.c
> @@ -381,7 +381,7 @@ static int omap_rng_probe(struct platform_device *pdev)
>         if (ret)
>                 goto err_ioremap;
>
> -       ret = hwrng_register(&omap_rng_ops);
> +       ret = devm_hwrng_register(dev, &omap_rng_ops);
>         if (ret)
>                 goto err_register;
>
> @@ -402,8 +402,6 @@ static int omap_rng_remove(struct platform_device *pdev)
>  {
>         struct omap_rng_dev *priv = platform_get_drvdata(pdev);
>
> -       hwrng_unregister(&omap_rng_ops);
> -
>         priv->pdata->cleanup(priv);
>
>         pm_runtime_put_sync(&pdev->dev);
> --

If devm_hwrng_register is used hwrng_unregister will be called after
pm_runtime_disable is called. If RNG device is in use calling
omap_rng_remove may not work properly.
