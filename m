From: Fabio Estevam <festevam@gmail.com>
Subject: Re: [PATCH v2 1/3] crypto: caam: ctrl: Fix the error handling
Date: Fri, 21 Aug 2015 13:43:16 -0300
Message-ID: <CAOMZO5A-GOLLvZsEQDR5f1vyi52jPnfDAByTLqpwQmsqGr3_Qg@mail.gmail.com>
References: <1440173804-26780-1-git-send-email-festevam@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: vicki.milhoan@freescale.com,
	=?UTF-8?Q?Horia_Geant=C4=83?= <horia.geanta@freescale.com>,
	linux-crypto@vger.kernel.org,
	Fabio Estevam <fabio.estevam@freescale.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ob0-f177.google.com ([209.85.214.177]:34973 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344AbbHUQnR (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 21 Aug 2015 12:43:17 -0400
Received: by obbwr7 with SMTP id wr7so63393348obb.2
        for <linux-crypto@vger.kernel.org>; Fri, 21 Aug 2015 09:43:16 -0700 (PDT)
In-Reply-To: <1440173804-26780-1-git-send-email-festevam@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Aug 21, 2015 at 1:16 PM, Fabio Estevam <festevam@gmail.com> wrote:
> From: Fabio Estevam <fabio.estevam@freescale.com>
>
> In the error path we should disable the resources that were previously
> acquired, so fix the error handling accordingly.
>
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
> ---
> Changes since v1:
> - None
>
>  drivers/crypto/caam/ctrl.c | 35 ++++++++++++++++++++++++-----------
>  1 file changed, 24 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
> index 81b552d..9c5ca46 100644
> --- a/drivers/crypto/caam/ctrl.c
> +++ b/drivers/crypto/caam/ctrl.c
> @@ -474,27 +474,27 @@ static int caam_probe(struct platform_device *pdev)
>         ret = clk_prepare_enable(ctrlpriv->caam_ipg);
>         if (ret < 0) {
>                 dev_err(&pdev->dev, "can't enable CAAM ipg clock: %d\n", ret);
> -               return -ENODEV;
> +               return ret;
>         }
>
>         ret = clk_prepare_enable(ctrlpriv->caam_mem);
>         if (ret < 0) {
>                 dev_err(&pdev->dev, "can't enable CAAM secure mem clock: %d\n",
>                         ret);
> -               return -ENODEV;
> +               goto disable_caam_ipg;
>         }
>
>         ret = clk_prepare_enable(ctrlpriv->caam_aclk);
>         if (ret < 0) {
>                 dev_err(&pdev->dev, "can't enable CAAM aclk clock: %d\n", ret);
> -               return -ENODEV;
> +               goto disable_caam_mem;
>         }
>
>         ret = clk_prepare_enable(ctrlpriv->caam_emi_slow);
>         if (ret < 0) {
>                 dev_err(&pdev->dev, "can't enable CAAM emi slow clock: %d\n",
>                         ret);
> -               return -ENODEV;
> +               goto disable_caam_aclk;
>         }
>
>         /* Get configuration properties from device tree */
> @@ -502,7 +502,7 @@ static int caam_probe(struct platform_device *pdev)
>         ctrl = of_iomap(nprop, 0);
>         if (ctrl == NULL) {
>                 dev_err(dev, "caam: of_iomap() failed\n");
> -               return -ENOMEM;
> +               goto disable_caam_emi_slow;

Ops, I missed a 'ret = -ENOMEM' here.

Will send a v3.
