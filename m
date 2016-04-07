From: Mathieu Poirier <mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 2/2] hwrng: hisi: Add support for Hisilicon SoC RNG
Date: Thu, 7 Apr 2016 08:55:22 -0600
Message-ID: <CANLsYkwRGm3oBWaoKki4Ge3A_-temOsdJcwby6ds_X5_XGYZtQ@mail.gmail.com>
References: <1460017397-30996-1-git-send-email-wangkefeng.wang@huawei.com>
	<1460017397-30996-3-git-send-email-wangkefeng.wang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	"linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org"
	<linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>,
	Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
	Xu Wei <xuwei5-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org>,
	Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>,
	linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>, guohanjun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
To: Kefeng Wang <wangkefeng.wang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1460017397-30996-3-git-send-email-wangkefeng.wang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

On 7 April 2016 at 02:23, Kefeng Wang <wangkefeng.wang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> wrote:
> This adds the Hisilicon Random Number Generator(RNG) support,
> which is found in Hip04 and Hip05 soc.
>
> Signed-off-by: Kefeng Wang <wangkefeng.wang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/char/hw_random/Kconfig    |  13 ++++
>  drivers/char/hw_random/Makefile   |   1 +
>  drivers/char/hw_random/hisi-rng.c | 121 ++++++++++++++++++++++++++++++++++++++
>  3 files changed, 135 insertions(+)
>  create mode 100644 drivers/char/hw_random/hisi-rng.c
>
> diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
> index 67ee8b0..088b1bf 100644
> --- a/drivers/char/hw_random/Kconfig
> +++ b/drivers/char/hw_random/Kconfig
> @@ -333,6 +333,19 @@ config HW_RANDOM_TPM
>
>           If unsure, say Y.
>
> +config HW_RANDOM_HISI
> +       tristate "Hisilicon Random Number Generator support"
> +       depends on HW_RANDOM && ARCH_HISI
> +       default HW_RANDOM
> +       ---help---
> +         This driver provides kernel-side support for the Random Number
> +         Generator hardware found on Hisilicon Hip04 and Hip05 SoC.
> +
> +         To compile this driver as a module, choose M here: the
> +         module will be called hisi-rng.
> +
> +         If unsure, say Y.
> +
>  config HW_RANDOM_MSM
>         tristate "Qualcomm SoCs Random Number Generator support"
>         depends on HW_RANDOM && ARCH_QCOM
> diff --git a/drivers/char/hw_random/Makefile b/drivers/char/hw_random/Makefile
> index f5a6fa7..e09305b 100644
> --- a/drivers/char/hw_random/Makefile
> +++ b/drivers/char/hw_random/Makefile
> @@ -26,6 +26,7 @@ obj-$(CONFIG_HW_RANDOM_PPC4XX) += ppc4xx-rng.o
>  obj-$(CONFIG_HW_RANDOM_PSERIES) += pseries-rng.o
>  obj-$(CONFIG_HW_RANDOM_POWERNV) += powernv-rng.o
>  obj-$(CONFIG_HW_RANDOM_EXYNOS) += exynos-rng.o
> +obj-$(CONFIG_HW_RANDOM_HISI)   += hisi-rng.o
>  obj-$(CONFIG_HW_RANDOM_TPM) += tpm-rng.o
>  obj-$(CONFIG_HW_RANDOM_BCM2835) += bcm2835-rng.o
>  obj-$(CONFIG_HW_RANDOM_IPROC_RNG200) += iproc-rng200.o
> diff --git a/drivers/char/hw_random/hisi-rng.c b/drivers/char/hw_random/hisi-rng.c
> new file mode 100644
> index 0000000..3e18e58
> --- /dev/null
> +++ b/drivers/char/hw_random/hisi-rng.c
> @@ -0,0 +1,121 @@
> +/*
> + * Copyright (C) 2016 HiSilicon Co., Ltd.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/err.h>
> +#include <linux/kernel.h>
> +#include <linux/hw_random.h>
> +#include <linux/io.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/platform_device.h>
> +
> +#define RNG_SEED       0x0
> +#define RNG_CTRL       0x4
> +  #define RNG_SEED_SEL BIT(2)
> +  #define RNG_RING_EN  BIT(1)
> +  #define RNG_EN       BIT(0)
> +#define RNG_RAN_NUM    0x10
> +#define RNG_PHY_SEED   0x14
> +#define RNG_RELOAD_ERR 0x84
> +
> +#define to_hisi_rng(p) container_of(p, struct hisi_rng, rng)
> +
> +static int seed_sel;
> +module_param(seed_sel, int, S_IRUGO);
> +MODULE_PARM_DESC(seed_sel, "Auto reload seed. 0, use LFSR(default); 1, use ring oscillator.");
> +
> +struct hisi_rng {
> +       void __iomem *base;
> +       struct hwrng rng;
> +};
> +
> +static int hisi_rng_init(struct hwrng *rng)
> +{
> +       struct hisi_rng *hrng = to_hisi_rng(rng);
> +       int val = RNG_EN;
> +       u32 seed;
> +
> +       /* get a random number as initial seed */
> +       get_random_bytes(&seed, sizeof(seed));
> +
> +       writel_relaxed(seed, hrng->base + RNG_SEED);
> +
> +       if (seed_sel == 1)
> +               val |= RNG_RING_EN | RNG_SEED_SEL;

Hello Kefeng,

Please explain what this mode does.  Otherwise reviewers have to make
a guess based on the description of the module parameter.

> +
> +       writel_relaxed(val, hrng->base + RNG_CTRL);
> +       return 0;
> +}
> +
> +static void hisi_rng_cleanup(struct hwrng *rng)
> +{
> +       struct hisi_rng *hrng = to_hisi_rng(rng);
> +
> +       writel_relaxed(0, hrng->base + RNG_CTRL);
> +}
> +
> +static int hisi_rng_read(struct hwrng *rng, void *buf, size_t max,
> +                          bool wait)

What are variable 'max' and 'wait' used for?  As far as I can tell
they can be removed.

> +{
> +       struct hisi_rng *hrng = to_hisi_rng(rng);
> +       u32 *data = buf;
> +
> +       *data = readl_relaxed(hrng->base + RNG_RAN_NUM);
> +       return 4;

Why not simply doing the readl_relaxed() in the the code rather than
introducing a new function?

> +}
> +
> +static int hisi_rng_probe(struct platform_device *pdev)
> +{
> +       struct hisi_rng *rng;
> +       struct resource *res;
> +       int ret;
> +
> +       rng = devm_kzalloc(&pdev->dev, sizeof(*rng), GFP_KERNEL);
> +       if (!rng)
> +               return -ENOMEM;
> +
> +       platform_set_drvdata(pdev, rng);
> +
> +       res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +       rng->base = devm_ioremap_resource(&pdev->dev, res);
> +       if (IS_ERR(rng->base))
> +               return PTR_ERR(rng->base);
> +
> +       rng->rng.name = pdev->name;
> +       rng->rng.init = hisi_rng_init;
> +       rng->rng.cleanup = hisi_rng_cleanup;
> +       rng->rng.read = hisi_rng_read;
> +
> +       ret = devm_hwrng_register(&pdev->dev, &rng->rng);
> +       if (ret) {
> +               dev_err(&pdev->dev, "failed to register hwrng\n");
> +               return ret;
> +       }
> +
> +       return 0;
> +}
> +
> +static const struct of_device_id hisi_rng_dt_ids[] = {
> +       { .compatible = "hisilicon,rng" },
> +       { }
> +};
> +MODULE_DEVICE_TABLE(of, hisi_rng_dt_ids);
> +
> +static struct platform_driver hisi_rng_driver = {
> +       .probe          = hisi_rng_probe,
> +       .driver         = {
> +               .name   = "hisi-rng",
> +               .of_match_table = of_match_ptr(hisi_rng_dt_ids),
> +       },
> +};
> +
> +module_platform_driver(hisi_rng_driver);
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Kefeng Wang <wangkefeng.wang@huawei>");
> +MODULE_DESCRIPTION("Hisilicon random number generator driver");
> --
> 2.6.0.GIT
>
> --
> To unsubscribe from this list: send the line "unsubscribe devicetree" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
