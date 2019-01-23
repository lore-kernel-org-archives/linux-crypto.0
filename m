Return-Path: <SRS0=I8vn=P7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03424C282C0
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Jan 2019 08:13:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BBF3A217F5
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Jan 2019 08:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548231223;
	bh=ZN6CWeqhwfuLgxbwWQSMDDCYVZ184BC+vZXvvy9Bvaw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=IMmZqH9e379BAwcSVgt9/+zfl0rg7P2o6vO1N3wMjxSmbq6coAVZl3G0u0jRKPGAq
	 ivAK2tE6SuQsXLmtOKZBzwfeYlMGp8juNHwuF2YOhlPOzDiKXHEm1B/nBgmG6szHL7
	 Rx5+/fC6AI2xBz/fJSeZIJch7xoQT3fAuAtaaDsY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726000AbfAWINn (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Jan 2019 03:13:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:60622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725973AbfAWINn (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Jan 2019 03:13:43 -0500
Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 35B0A21841;
        Wed, 23 Jan 2019 08:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1548231221;
        bh=ZN6CWeqhwfuLgxbwWQSMDDCYVZ184BC+vZXvvy9Bvaw=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=efEQ68BCZrG1A5sjPocCMzI0lRuhsVIk2LrMyMCyVEHNzVfIx3CaHFnWZHdGoZNOE
         0p1+kHO0NWmt+r0nnnj6MDX7u4DEzl06VHPHL89B9mI1mCU3Z/Sw/myUzaatkuH9p1
         ZNpX11DvF5iqkUKSkDZb2Hgiiihs2o/wkM49X+CQ=
Received: by mail-lj1-f171.google.com with SMTP id c19-v6so1101014lja.5;
        Wed, 23 Jan 2019 00:13:41 -0800 (PST)
X-Gm-Message-State: AJcUukeKKeGTgvzkJ/c90a0+jthxQtJQ+JjB9QQEWorLSjwEdWbmkY+e
        1GrC4NK2I0/kDJdSySrXnYRhVoY2rZSrxeAUTwc=
X-Google-Smtp-Source: ALg8bN6UPLK1KJsaAlLnwyCcP75G/5EJgvZ6d3fCAIr0cBdeHzn0tUUupw/kXY1qp4k6FgMsPMH7Yf69Q6Vd8LzKGaE=
X-Received: by 2002:a2e:9a16:: with SMTP id o22-v6mr1098991lji.112.1548231219295;
 Wed, 23 Jan 2019 00:13:39 -0800 (PST)
MIME-Version: 1.0
References: <CGME20190122152609eucas1p287b83592af600dc080374a197e6dd917@eucas1p2.samsung.com>
 <20190122152553.1537-1-k.konieczny@partner.samsung.com> <20190122152553.1537-4-k.konieczny@partner.samsung.com>
In-Reply-To: <20190122152553.1537-4-k.konieczny@partner.samsung.com>
From:   Krzysztof Kozlowski <krzk@kernel.org>
Date:   Wed, 23 Jan 2019 09:13:28 +0100
X-Gmail-Original-Message-ID: <CAJKOXPdkDrwy2rSs-Fj1rq8rTOHvtQTrZTY5ER=pPWRPwx5qfA@mail.gmail.com>
Message-ID: <CAJKOXPdkDrwy2rSs-Fj1rq8rTOHvtQTrZTY5ER=pPWRPwx5qfA@mail.gmail.com>
Subject: Re: [PATCH v1 3/3] crypto: s5p: add AES support for Exynos5433
To:     Kamil Konieczny <k.konieczny@partner.samsung.com>
Cc:     Vladimir Zapolskiy <vz@mleia.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org,
        "linux-samsung-soc@vger.kernel.org" 
        <linux-samsung-soc@vger.kernel.org>, linux-kernel@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, 22 Jan 2019 at 16:26, Kamil Konieczny
<k.konieczny@partner.samsung.com> wrote:
>
> Add AES crypto HW acceleration for Exynos5433, with the help of SlimSSS IP.
>
> Signed-off-by: Kamil Konieczny <k.konieczny@partner.samsung.com>
> ---
>  drivers/crypto/s5p-sss.c | 50 ++++++++++++++++++++++++++++++++++++----
>  1 file changed, 46 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
> index 0064be0e3941..1ae570ad4391 100644
> --- a/drivers/crypto/s5p-sss.c
> +++ b/drivers/crypto/s5p-sss.c
> @@ -232,6 +232,7 @@
>   * struct samsung_aes_variant - platform specific SSS driver data
>   * @aes_offset: AES register offset from SSS module's base.
>   * @hash_offset: HASH register offset from SSS module's base.
> + * @clk_names: names of clocks needed to run SSS IP
>   *
>   * Specifies platform specific configuration of SSS module.
>   * Note: A structure for driver specific platform data is used for future
> @@ -240,6 +241,7 @@
>  struct samsung_aes_variant {
>         unsigned int                    aes_offset;
>         unsigned int                    hash_offset;
> +       char                            *clk_names[];
>  };
>
>  struct s5p_aes_reqctx {
> @@ -296,6 +298,7 @@ struct s5p_aes_ctx {
>  struct s5p_aes_dev {
>         struct device                   *dev;
>         struct clk                      *clk;
> +       struct clk                      *pclk;
>         void __iomem                    *ioaddr;
>         void __iomem                    *aes_ioaddr;
>         int                             irq_fc;
> @@ -384,11 +387,19 @@ struct s5p_hash_ctx {
>  static const struct samsung_aes_variant s5p_aes_data = {
>         .aes_offset     = 0x4000,
>         .hash_offset    = 0x6000,
> +       .clk_names      = { "secss", }

Put trailing comma so it can be extended without touching previous
line (just like old code).

>  };
>
>  static const struct samsung_aes_variant exynos_aes_data = {
>         .aes_offset     = 0x200,
>         .hash_offset    = 0x400,
> +       .clk_names      = { "secss", }

Ditto.

> +};
> +
> +static const struct samsung_aes_variant exynos5433_slim_aes_data = {
> +       .aes_offset     = 0x400,
> +       .hash_offset    = 0x800,
> +       .clk_names      = { "pclk", "aclk", }

Ditto.

>  };
>
>  static const struct of_device_id s5p_sss_dt_match[] = {
> @@ -400,6 +411,10 @@ static const struct of_device_id s5p_sss_dt_match[] = {
>                 .compatible = "samsung,exynos4210-secss",
>                 .data = &exynos_aes_data,
>         },
> +       {
> +               .compatible = "samsung,exynos5433-slim-sss",
> +               .data = &exynos5433_slim_aes_data,
> +       },
>         { },
>  };
>  MODULE_DEVICE_TABLE(of, s5p_sss_dt_match);
> @@ -2208,18 +2223,40 @@ static int s5p_aes_probe(struct platform_device *pdev)
>                         return PTR_ERR(pdata->ioaddr);
>         }
>
> -       pdata->clk = devm_clk_get(dev, "secss");
> +       pdata->clk = devm_clk_get(dev, variant->clk_names[0]);
>         if (IS_ERR(pdata->clk)) {
> -               dev_err(dev, "failed to find secss clock source\n");
> +               dev_err(dev, "failed to find secss clock %s\n",
> +                       variant->clk_names[0]);
>                 return -ENOENT;
>         }
>
>         err = clk_prepare_enable(pdata->clk);
>         if (err < 0) {
> -               dev_err(dev, "Enabling SSS clk failed, err %d\n", err);
> +               dev_err(dev, "Enabling clock %s failed, err %d\n",
> +                       variant->clk_names[0], err);
>                 return err;
>         }
>
> +       if (variant->clk_names[1]) {
> +               pdata->pclk = devm_clk_get(dev, variant->clk_names[1]);
> +               if (IS_ERR(pdata->pclk)) {
> +                       dev_err(dev, "failed to find clock %s\n",
> +                               variant->clk_names[1]);
> +                       clk_disable_unprepare(pdata->clk);
> +                       return -ENOENT;

goto err_irq (eventually rename the label)?

> +                       }

Indentation looks wrong here.

> +
> +               err = clk_prepare_enable(pdata->pclk);
> +               if (err < 0) {
> +                       dev_err(dev, "Enabling clock %s failed, err %d\n",
> +                               variant->clk_names[0], err);
> +                       clk_disable_unprepare(pdata->clk);
> +                       return err;

goto...

Best regards,
Krzysztof
