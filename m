From: Kieran Bingham <kieranbingham@gmail.com>
Subject: Re: [PATCH v2 5/7] hwrng: st: Add support for ST's HW Random Number Generator
Date: Fri, 18 Sep 2015 11:44:34 +0100
Message-ID: <CAB3z_RoWfH65O2MrcMRMoJXUf=gvkn5JpiEWtoKE72Td_YNinw@mail.gmail.com>
References: <1442497557-9271-1-git-send-email-lee.jones@linaro.org>
	<1442497557-9271-6-git-send-email-lee.jones@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org, peter@korsgaard.com,
	festevam@gmail.com, kernel@stlinux.com,
	Pankaj Dev <pankaj.dev@st.com>
To: Lee Jones <lee.jones@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-la0-f43.google.com ([209.85.215.43]:33552 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853AbbIRKog (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 18 Sep 2015 06:44:36 -0400
In-Reply-To: <1442497557-9271-6-git-send-email-lee.jones@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 17 September 2015 at 14:45, Lee Jones <lee.jones@linaro.org> wrote:
> Signed-off-by: Pankaj Dev <pankaj.dev@st.com>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Comments addressed, Also LGTM.
Acked-by: Kieran Bingham <kieranbingham@gmail.com>


> ---
>  drivers/char/hw_random/Kconfig  |  10 +++
>  drivers/char/hw_random/Makefile |   1 +
>  drivers/char/hw_random/st-rng.c | 144 ++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 155 insertions(+)
>  create mode 100644 drivers/char/hw_random/st-rng.c
>
> diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
> index 8998108..ba5406b 100644
> --- a/drivers/char/hw_random/Kconfig
> +++ b/drivers/char/hw_random/Kconfig
> @@ -346,6 +346,16 @@ config HW_RANDOM_MSM
>
>           If unsure, say Y.
>
> +config HW_RANDOM_ST
> +       tristate "ST Microelectronics HW Random Number Generator support"
> +       depends on HW_RANDOM && ARCH_STI
> +       ---help---
> +         This driver provides kernel-side support for the Random Number
> +         Generator hardware found on STi series of SoCs.
> +
> +         To compile this driver as a module, choose M here: the
> +         module will be called st-rng.
> +
>  config HW_RANDOM_XGENE
>         tristate "APM X-Gene True Random Number Generator (TRNG) support"
>         depends on HW_RANDOM && ARCH_XGENE
> diff --git a/drivers/char/hw_random/Makefile b/drivers/char/hw_random/Makefile
> index 055bb01..8bcfb45 100644
> --- a/drivers/char/hw_random/Makefile
> +++ b/drivers/char/hw_random/Makefile
> @@ -30,4 +30,5 @@ obj-$(CONFIG_HW_RANDOM_TPM) += tpm-rng.o
>  obj-$(CONFIG_HW_RANDOM_BCM2835) += bcm2835-rng.o
>  obj-$(CONFIG_HW_RANDOM_IPROC_RNG200) += iproc-rng200.o
>  obj-$(CONFIG_HW_RANDOM_MSM) += msm-rng.o
> +obj-$(CONFIG_HW_RANDOM_ST) += st-rng.o
>  obj-$(CONFIG_HW_RANDOM_XGENE) += xgene-rng.o
> diff --git a/drivers/char/hw_random/st-rng.c b/drivers/char/hw_random/st-rng.c
> new file mode 100644
> index 0000000..8c8a435
> --- /dev/null
> +++ b/drivers/char/hw_random/st-rng.c
> @@ -0,0 +1,144 @@
> +/*
> + * ST Random Number Generator Driver ST's Platforms
> + *
> + * Author: Pankaj Dev: <pankaj.dev@st.com>
> + *         Lee Jones <lee.jones@linaro.org>
> + *
> + * Copyright (C) 2015 STMicroelectronics (R&D) Limited
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/clk.h>
> +#include <linux/delay.h>
> +#include <linux/hw_random.h>
> +#include <linux/io.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/platform_device.h>
> +#include <linux/slab.h>
> +
> +/* Registers */
> +#define ST_RNG_STATUS_REG              0x20
> +#define ST_RNG_DATA_REG                        0x24
> +
> +/* Registers fields */
> +#define ST_RNG_STATUS_BAD_SEQUENCE     BIT(0)
> +#define ST_RNG_STATUS_BAD_ALTERNANCE   BIT(1)
> +#define ST_RNG_STATUS_FIFO_FULL                BIT(5)
> +
> +#define ST_RNG_FIFO_SIZE               8
> +#define ST_RNG_SAMPLE_SIZE             2 /* 2 Byte (16bit) samples */
> +
> +/* Samples are available every 0.667us, which we round to 1us */
> +#define ST_RNG_FILL_FIFO_TIMEOUT   (1 * (ST_RNG_FIFO_SIZE / ST_RNG_SAMPLE_SIZE))
> +
> +struct st_rng_data {
> +       void __iomem    *base;
> +       struct clk      *clk;
> +       struct hwrng    ops;
> +};
> +
> +static int st_rng_read(struct hwrng *rng, void *data, size_t max, bool wait)
> +{
> +       struct st_rng_data *ddata = (struct st_rng_data *)rng->priv;
> +       u32 status;
> +       int i;
> +
> +       if (max < sizeof(u16))
> +               return -EINVAL;
> +
> +       /* Wait until FIFO is full - max 4uS*/
> +       for (i = 0; i < ST_RNG_FILL_FIFO_TIMEOUT; i++) {
> +               status = readl_relaxed(ddata->base + ST_RNG_STATUS_REG);
> +               if (status & ST_RNG_STATUS_FIFO_FULL)
> +                       break;
> +               udelay(1);
> +       }
> +
> +       if (i == ST_RNG_FILL_FIFO_TIMEOUT)
> +               return 0;
> +
> +       for (i = 0; i < ST_RNG_FIFO_SIZE && i < max; i += 2)
> +               *(u16 *)(data + i) =
> +                       readl_relaxed(ddata->base + ST_RNG_DATA_REG);
> +
> +       return i;       /* No of bytes read */
> +}
> +
> +static int st_rng_probe(struct platform_device *pdev)
> +{
> +       struct st_rng_data *ddata;
> +       struct resource *res;
> +       struct clk *clk;
> +       void __iomem *base;
> +       int ret;
> +
> +       ddata = devm_kzalloc(&pdev->dev, sizeof(*ddata), GFP_KERNEL);
> +       if (!ddata)
> +               return -ENOMEM;
> +
> +       res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +       base = devm_ioremap_resource(&pdev->dev, res);
> +       if (IS_ERR(base))
> +               return PTR_ERR(base);
> +
> +       clk = devm_clk_get(&pdev->dev, NULL);
> +       if (IS_ERR(clk))
> +               return PTR_ERR(clk);
> +
> +       ret = clk_prepare_enable(clk);
> +       if (ret)
> +               return ret;
> +
> +       ddata->ops.priv = (unsigned long)ddata;
> +       ddata->ops.read = st_rng_read;
> +       ddata->ops.name = pdev->name;
> +       ddata->base     = base;
> +       ddata->clk      = clk;
> +
> +       dev_set_drvdata(&pdev->dev, ddata);
> +
> +       ret = hwrng_register(&ddata->ops);
> +       if (ret) {
> +               dev_err(&pdev->dev, "Failed to register HW RNG\n");
> +               return ret;
> +       }
> +
> +       dev_info(&pdev->dev, "Successfully registered HW RNG\n");
> +
> +       return 0;
> +}
> +
> +static int st_rng_remove(struct platform_device *pdev)
> +{
> +       struct st_rng_data *ddata = dev_get_drvdata(&pdev->dev);
> +
> +       hwrng_unregister(&ddata->ops);
> +
> +       clk_disable_unprepare(ddata->clk);
> +
> +       return 0;
> +}
> +
> +static const struct of_device_id st_rng_match[] = {
> +       { .compatible = "st,rng" },
> +       {},
> +};
> +MODULE_DEVICE_TABLE(of, st_rng_match);
> +
> +static struct platform_driver st_rng_driver = {
> +       .driver = {
> +               .name = "st-hwrandom",
> +               .of_match_table = of_match_ptr(st_rng_match),
> +       },
> +       .probe = st_rng_probe,
> +       .remove = st_rng_remove
> +};
> +
> +module_platform_driver(st_rng_driver);
> +
> +MODULE_AUTHOR("Pankaj Dev <pankaj.dev@st.com>");
> +MODULE_LICENSE("GPL v2");
> --
> 1.9.1
>
