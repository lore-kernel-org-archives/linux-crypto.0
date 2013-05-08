From: Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH 4/8] crypto: ux500/cryp - Prepare clock before enabling it
Date: Wed, 8 May 2013 15:57:51 +0200
Message-ID: <CAPDyKFrZo7Eg4wmYVfD4MYr=Ae1Z1u6pJQOjv4X1QK+FKPH7FA@mail.gmail.com>
References: <1367491790-9727-1-git-send-email-lee.jones@linaro.org>
	<1367491790-9727-5-git-send-email-lee.jones@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	arnd@arndb.de, linus.walleij@stericsson.com,
	srinidhi.kasagar@stericsson.com,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Andreas Westin <andreas.westin@stericsson.com>,
	linux-crypto@vger.kernel.org
To: Lee Jones <lee.jones@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ve0-f173.google.com ([209.85.128.173]:49590 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755399Ab3EHN5v (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 8 May 2013 09:57:51 -0400
Received: by mail-ve0-f173.google.com with SMTP id ox1so1784248veb.32
        for <linux-crypto@vger.kernel.org>; Wed, 08 May 2013 06:57:51 -0700 (PDT)
In-Reply-To: <1367491790-9727-5-git-send-email-lee.jones@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 2 May 2013 12:49, Lee Jones <lee.jones@linaro.org> wrote:
> If we fail to prepare the ux500-cryp clock before enabling it the
> platform will fail to boot. Here we insure this happens.
>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Andreas Westin <andreas.westin@stericsson.com>
> Cc: Ulf Hansson <ulf.hansson@linaro.org>
> Cc: linux-crypto@vger.kernel.org
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  drivers/crypto/ux500/cryp/cryp_core.c |   12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/crypto/ux500/cryp/cryp_core.c b/drivers/crypto/ux500/cryp/cryp_core.c
> index 22c9063..bf78d60 100644
> --- a/drivers/crypto/ux500/cryp/cryp_core.c
> +++ b/drivers/crypto/ux500/cryp/cryp_core.c
> @@ -1459,11 +1459,17 @@ static int ux500_cryp_probe(struct platform_device *pdev)
>                 goto out_regulator;
>         }
>
> +       ret = clk_prepare(device_data->clk);
> +       if (ret) {
> +               dev_err(dev, "[%s]: clk_prepare() failed!", __func__);
> +               goto out_clk;
> +       }
> +
>         /* Enable device power (and clock) */
>         ret = cryp_enable_power(device_data->dev, device_data, false);
>         if (ret) {
>                 dev_err(dev, "[%s]: cryp_enable_power() failed!", __func__);
> -               goto out_clk;
> +               goto out_clk_unprepare;
>         }
>
>         cryp_error = cryp_check(device_data);
> @@ -1524,6 +1530,9 @@ static int ux500_cryp_probe(struct platform_device *pdev)
>  out_power:
>         cryp_disable_power(device_data->dev, device_data, false);
>
> +out_clk_unprepare:
> +       clk_unprepare(device_data->clk);
> +
>  out_clk:
>         clk_put(device_data->clk);
>
> @@ -1594,6 +1603,7 @@ static int ux500_cryp_remove(struct platform_device *pdev)
>                 dev_err(&pdev->dev, "[%s]: cryp_disable_power() failed",
>                         __func__);
>
> +       clk_unprepare(device_data->clk);
>         clk_put(device_data->clk);
>         regulator_put(device_data->pwr_regulator);
>
> --
> 1.7.10.4
>

Acked-by: Ulf Hansson <ulf.hansson@linaro.org>
