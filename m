From: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Subject: Re: [PATCH 2/2] hwrng: meson: add clock handling to driver
Date: Mon, 20 Feb 2017 17:07:23 +0530
Message-ID: <CANc+2y6hYB_raW0TigeMbBm8C3JXEUUnSOTjNLcSs9FESQNTXg@mail.gmail.com>
References: <00b2a4cc-686e-0cc0-43e8-552b70a1e868@gmail.com> <eff6bfbe-3257-5d74-35c7-226a29c61fcb@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Kevin Hilman <khilman@baylibre.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Neil Armstrong <narmstrong@baylibre.com>,
        linux-amlogic@lists.infradead.org, linux-crypto@vger.kernel.org
To: Heiner Kallweit <hkallweit1@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-yb0-f194.google.com ([209.85.213.194]:35325 "EHLO
        mail-yb0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752752AbdBTLhZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 20 Feb 2017 06:37:25 -0500
Received: by mail-yb0-f194.google.com with SMTP id u130so2100854ybb.2
        for <linux-crypto@vger.kernel.org>; Mon, 20 Feb 2017 03:37:24 -0800 (PST)
In-Reply-To: <eff6bfbe-3257-5d74-35c7-226a29c61fcb@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 20 February 2017 at 02:05, Heiner Kallweit <hkallweit1@gmail.com> wrote:
> Add handling of RNG0 clock to the driver.
>
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> ---
>  drivers/char/hw_random/meson-rng.c | 27 ++++++++++++++++++++++++++-
>  1 file changed, 26 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/char/hw_random/meson-rng.c b/drivers/char/hw_random/meson-rng.c
> index 119d6984..1f586e48 100644
> --- a/drivers/char/hw_random/meson-rng.c
> +++ b/drivers/char/hw_random/meson-rng.c
> @@ -62,6 +62,7 @@
>  #include <linux/slab.h>
>  #include <linux/types.h>
>  #include <linux/of.h>
> +#include <linux/clk.h>
>
>  #define RNG_DATA 0x00
>
> @@ -69,6 +70,7 @@ struct meson_rng_data {
>         void __iomem *base;
>         struct platform_device *pdev;
>         struct hwrng rng;
> +       struct clk *core_clk;
>  };
>
>  static int meson_rng_read(struct hwrng *rng, void *buf, size_t max, bool wait)
> @@ -86,6 +88,7 @@ static int meson_rng_probe(struct platform_device *pdev)
>         struct device *dev = &pdev->dev;
>         struct meson_rng_data *data;
>         struct resource *res;
> +       int ret;

Variable ret is not used. It can be removed.

>         data = devm_kzalloc(dev, sizeof(*data), GFP_KERNEL);
>         if (!data)
> @@ -98,12 +101,33 @@ static int meson_rng_probe(struct platform_device *pdev)
>         if (IS_ERR(data->base))
>                 return PTR_ERR(data->base);
>
> +       data->core_clk = devm_clk_get(dev, "core");
> +       if (IS_ERR(data->core_clk))
> +               return PTR_ERR(data->core_clk);
> +
> +       ret = clk_prepare_enable(data->core_clk);
> +       if (ret)
> +               return ret;
> +
>         data->rng.name = pdev->name;
>         data->rng.read = meson_rng_read;
>
>         platform_set_drvdata(pdev, data);
>
> -       return devm_hwrng_register(dev, &data->rng);
> +       ret = devm_hwrng_register(dev, &data->rng);
> +       if (ret)
> +               clk_disable_unprepare(data->core_clk);
> +
> +       return ret;
> +}
> +
> +static int meson_rng_remove(struct platform_device *pdev)
> +{
> +       struct meson_rng_data *data = platform_get_drvdata(pdev);
> +
> +       clk_disable_unprepare(data->core_clk);
> +
> +       return 0;
>  }

In .remove clock gets disabled before the hwrng_unregister is called.
The device node '/dev/hwrng' could be accessed while meson_rng_remove
is called which could lead to problems. Instead of devm_hwrng_register
use hwrng_register in .probe and call hwrng_unregister in .remove.

>  static const struct of_device_id meson_rng_of_match[] = {
> @@ -114,6 +138,7 @@ MODULE_DEVICE_TABLE(of, meson_rng_of_match);
>
>  static struct platform_driver meson_rng_driver = {
>         .probe  = meson_rng_probe,
> +       .remove = meson_rng_remove,
>         .driver = {
>                 .name = "meson-rng",
>                 .of_match_table = meson_rng_of_match,
> --
> 2.11.1
>
>
