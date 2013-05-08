From: Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH 1/8] crypto: ux500/hash - Prepare clock before enabling it
Date: Wed, 8 May 2013 15:57:26 +0200
Message-ID: <CAPDyKFrJsGhB9yRtF2a09Ob5_4Jz-gaBQxeuriCGaXqYwkSyeg@mail.gmail.com>
References: <1367491790-9727-1-git-send-email-lee.jones@linaro.org>
	<1367491790-9727-2-git-send-email-lee.jones@linaro.org>
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
Received: from mail-vb0-f42.google.com ([209.85.212.42]:34185 "EHLO
	mail-vb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754851Ab3EHN51 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 8 May 2013 09:57:27 -0400
Received: by mail-vb0-f42.google.com with SMTP id w16so1583541vbf.15
        for <linux-crypto@vger.kernel.org>; Wed, 08 May 2013 06:57:27 -0700 (PDT)
In-Reply-To: <1367491790-9727-2-git-send-email-lee.jones@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 2 May 2013 12:49, Lee Jones <lee.jones@linaro.org> wrote:
> If we fail to prepare the ux500-hash clock before enabling it the
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
>  drivers/crypto/ux500/hash/hash_core.c |   12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/crypto/ux500/hash/hash_core.c b/drivers/crypto/ux500/hash/hash_core.c
> index 632c333..1e8b2f3 100644
> --- a/drivers/crypto/ux500/hash/hash_core.c
> +++ b/drivers/crypto/ux500/hash/hash_core.c
> @@ -1727,11 +1727,17 @@ static int ux500_hash_probe(struct platform_device *pdev)
>                 goto out_regulator;
>         }
>
> +       ret = clk_prepare(device_data->clk);
> +       if (ret) {
> +               dev_err(dev, "[%s] clk_prepare() failed!", __func__);
> +               goto out_clk;
> +       }
> +
>         /* Enable device power (and clock) */
>         ret = hash_enable_power(device_data, false);
>         if (ret) {
>                 dev_err(dev, "[%s]: hash_enable_power() failed!", __func__);
> -               goto out_clk;
> +               goto out_clk_unprepare;
>         }
>
>         ret = hash_check_hw(device_data);
> @@ -1763,6 +1769,9 @@ static int ux500_hash_probe(struct platform_device *pdev)
>  out_power:
>         hash_disable_power(device_data, false);
>
> +out_clk_unprepare:
> +       clk_unprepare(device_data->clk);
> +
>  out_clk:
>         clk_put(device_data->clk);
>
> @@ -1827,6 +1836,7 @@ static int ux500_hash_remove(struct platform_device *pdev)
>                 dev_err(dev, "[%s]: hash_disable_power() failed",
>                         __func__);
>
> +       clk_unprepare(device_data->clk);
>         clk_put(device_data->clk);
>         regulator_put(device_data->regulator);
>
> --
> 1.7.10.4
>

Acked-by: Ulf Hansson <ulf.hansson@linaro.org>
