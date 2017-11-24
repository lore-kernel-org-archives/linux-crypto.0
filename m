From: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Subject: Re: [PATCH 2/3] hwrng: exynos - add Samsung Exynos True RNG driver
Date: Fri, 24 Nov 2017 20:55:33 +0530
Message-ID: <CANc+2y4=Eas-i0jRwgTxqFeAngpPMKoUjVwsXWeU7G24g4252w@mail.gmail.com>
References: <CGME20171123151007eucas1p1cb231b31169771df3f9d57e515057413@eucas1p1.samsung.com>
 <20171123150914.31462-1-l.stelmach@samsung.com> <20171123150914.31462-3-l.stelmach@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Cc: Rob Herring <robh+dt@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        devicetree@vger.kernel.org,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>, linux-samsung-soc@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: =?UTF-8?Q?=C5=81ukasz_Stelmach?= <l.stelmach@samsung.com>
Return-path: <linux-samsung-soc-owner@vger.kernel.org>
In-Reply-To: <20171123150914.31462-3-l.stelmach@samsung.com>
Sender: linux-samsung-soc-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Lukasz,

Some minor comments below.

On 23 November 2017 at 20:39, =C5=81ukasz Stelmach <l.stelmach@samsung.com>=
 wrote:
> Add support for True Random Number Generator found in Samsung Exynos
> 5250+ SoCs.
>
> Signed-off-by: =C5=81ukasz Stelmach <l.stelmach@samsung.com>
> ---
>  MAINTAINERS                          |   7 +
>  drivers/char/hw_random/Kconfig       |  12 ++
>  drivers/char/hw_random/Makefile      |   1 +
>  drivers/char/hw_random/exynos-trng.c | 256 +++++++++++++++++++++++++++++=
++++++
>  4 files changed, 276 insertions(+)
>  create mode 100644 drivers/char/hw_random/exynos-trng.c
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 2811a211632c..992074cca612 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -11780,6 +11780,13 @@ S:     Maintained
>  F:     drivers/crypto/exynos-rng.c
>  F:     Documentation/devicetree/bindings/rng/samsung,exynos-rng4.txt
>
> +SAMSUNG EXYNOS TRUE RANDOM NUMBER GENERATOR (TRNG) DRIVER
> +M:     =C5=81ukasz Stelmach <l.stelmach@samsung.com>
> +L:     linux-samsung-soc@vger.kernel.org
> +S:     Maintained
> +F:     drivers/char/hw_random/exynos-trng.c
> +F:     Documentation/devicetree/bindings/rng/samsung,exynos5250-trng.txt
> +
>  SAMSUNG FRAMEBUFFER DRIVER
>  M:     Jingoo Han <jingoohan1@gmail.com>
>  L:     linux-fbdev@vger.kernel.org
> diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kcon=
fig
> index 95a031e9eced..a788ac07081b 100644
> --- a/drivers/char/hw_random/Kconfig
> +++ b/drivers/char/hw_random/Kconfig
> @@ -449,6 +449,18 @@ config HW_RANDOM_S390
>
>           If unsure, say Y.
>
> +config HW_RANDOM_EXYNOS
> +       tristate "Samsung Exynos True Random Number Generator support"
> +       depends on ARCH_EXYNOS || COMPILE_TEST
> +       default HW_RANDOM
> +       ---help---
> +         This driver provides support for the True Random Number
> +         Generator available in Exynos SoCs.
> +
> +        To compile this driver as a module, choose M here: the module
> +        will be called exynos-trng.
> +
> +        If unsure, say Y.
>  endif # HW_RANDOM
>
>  config UML_RANDOM
> diff --git a/drivers/char/hw_random/Makefile b/drivers/char/hw_random/Mak=
efile
> index f3728d008fff..5595df97da7a 100644
> --- a/drivers/char/hw_random/Makefile
> +++ b/drivers/char/hw_random/Makefile
> @@ -14,6 +14,7 @@ obj-$(CONFIG_HW_RANDOM_GEODE) +=3D geode-rng.o
>  obj-$(CONFIG_HW_RANDOM_N2RNG) +=3D n2-rng.o
>  n2-rng-y :=3D n2-drv.o n2-asm.o
>  obj-$(CONFIG_HW_RANDOM_VIA) +=3D via-rng.o
> +obj-$(CONFIG_HW_RANDOM_EXYNOS) +=3D exynos-trng.o
>  obj-$(CONFIG_HW_RANDOM_IXP4XX) +=3D ixp4xx-rng.o
>  obj-$(CONFIG_HW_RANDOM_OMAP) +=3D omap-rng.o
>  obj-$(CONFIG_HW_RANDOM_OMAP3_ROM) +=3D omap3-rom-rng.o
> diff --git a/drivers/char/hw_random/exynos-trng.c b/drivers/char/hw_rando=
m/exynos-trng.c
> new file mode 100644
> index 000000000000..340e106cae24
> --- /dev/null
> +++ b/drivers/char/hw_random/exynos-trng.c
> @@ -0,0 +1,256 @@
> +/*
> + * RNG driver for Exynos TRNGs
> + *
> + * Author: =C5=81ukasz Stelmach <l.stelmach@samsung.com>
> + *
> + * Copyright 2017 (c) Samsung Electronics Software, Inc.
> + *
> + * Based on the Exynos PRNG driver drivers/crypto/exynos-rng by
> + * Krzysztof Koz=C5=82owski <krzk@kernel.org>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation;
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <linux/clk.h>
> +#include <linux/crypto.h>
> +#include <linux/delay.h>
> +#include <linux/err.h>
> +#include <linux/hw_random.h>
> +#include <linux/io.h>
> +#include <linux/iopoll.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/platform_device.h>
> +#include <linux/pm_runtime.h>
> +
> +#define EXYNOS_TRNG_CLKDIV         (0x0)
> +#define EXYNOS_TRNG_CTRL           (0x20)
> +#define EXYNOS_TRNG_POST_CTRL      (0x30)
> +#define EXYNOS_TRNG_ONLINE_CTRL    (0x40)
> +#define EXYNOS_TRNG_ONLINE_STAT    (0x44)
> +#define EXYNOS_TRNG_ONLINE_MAXCHI2 (0x48)
> +#define EXYNOS_TRNG_FIFO_CTRL      (0x50)
> +#define EXYNOS_TRNG_FIFO_0         (0x80)
> +#define EXYNOS_TRNG_FIFO_1         (0x84)
> +#define EXYNOS_TRNG_FIFO_2         (0x88)
> +#define EXYNOS_TRNG_FIFO_3         (0x8c)
> +#define EXYNOS_TRNG_FIFO_4         (0x90)
> +#define EXYNOS_TRNG_FIFO_5         (0x94)
> +#define EXYNOS_TRNG_FIFO_6         (0x98)
> +#define EXYNOS_TRNG_FIFO_7         (0x9c)
> +#define EXYNOS_TRNG_FIFO_LEN       (8)
> +#define EXYNOS_TRNG_CLOCK_RATE     (500000)
> +
> +struct exynos_trng_dev {
> +       struct device    *dev;
> +       void __iomem     *mem;
> +       struct clk       *clk;
> +       struct hwrng rng;
> +};
> +
> +struct exynos_trng_dev *exynos_trng_dev;
> +
> +static inline void exynos_trng_set_reg(struct exynos_trng_dev *trng, u16=
 reg,
> +                                      u32 val)
> +{
> +       /* Check range of reg? */
> +       __raw_writel(val, trng->mem + reg);

Any specific reason to use __raw_writel? Why not just writel?

> +}
> +
> +static inline u32 exynos_trng_get_reg(struct exynos_trng_dev *trng, u16 =
reg)
> +{
> +       /* Check range of reg? */
> +       return __raw_readl(trng->mem + reg);

Same as above.

> +}
> +
> +static int exynos_trng_do_read(struct hwrng *rng, void *data, size_t max=
,
> +                              bool wait)
> +{
> +       struct exynos_trng_dev *trng;
> +       u32 val;
> +
> +       max =3D max > (EXYNOS_TRNG_FIFO_LEN * 4) ?
> +               (EXYNOS_TRNG_FIFO_LEN * 4) : max;

max is always > 32. This condition is not required.

> +
> +       trng =3D (struct exynos_trng_dev *)rng->priv;
> +
> +       exynos_trng_set_reg(trng, EXYNOS_TRNG_FIFO_CTRL, max * 8);
> +       val =3D readl_poll_timeout(trng->mem + EXYNOS_TRNG_FIFO_CTRL, val=
,
> +                                val =3D=3D 0, 200, 1000000);
> +       if (val < 0)
> +               return val;
> +
> +       memcpy_fromio(data, trng->mem + EXYNOS_TRNG_FIFO_0, max);
> +
> +       return max;
> +}
> +
> +static int exynos_trng_init(struct hwrng *rng)
> +{
> +       struct exynos_trng_dev *trng;
> +       unsigned long sss_rate;
> +       u32 val;
> +
> +       trng =3D (struct exynos_trng_dev *)rng->priv;
> +       sss_rate =3D clk_get_rate(trng->clk);
> +
> +       /* For most TRNG circuits the clock frequency of under 500 kHz
> +        * is safe.
> +        */
> +       val =3D sss_rate / (EXYNOS_TRNG_CLOCK_RATE * 2);
> +       if (val > 0x7fff) {
> +               dev_err(trng->dev, "clock divider too large: %d", val);
> +               return -ERANGE;
> +       }
> +       val =3D val << 1;
> +       exynos_trng_set_reg(trng, EXYNOS_TRNG_CLKDIV, val);
> +
> +       /* Enable the generator. */
> +       val =3D 1 << 31;
> +       exynos_trng_set_reg(trng, EXYNOS_TRNG_CTRL, val);
> +
> +       /* Disable post processing. /dev/hwrng is supposed to deliver
> +        * unprocessed data.
> +        */
> +       exynos_trng_set_reg(trng, EXYNOS_TRNG_POST_CTRL, 0);
> +
> +       return 0;
> +}
> +
> +static int exynos_trng_probe(struct platform_device *pdev)
> +{
> +       struct exynos_trng_dev *trng;
> +       struct resource *res;
> +       int ret =3D -ENOMEM;
> +
> +       if (exynos_trng_dev)
> +               return -EEXIST;
> +
> +       trng =3D devm_kzalloc(&pdev->dev, sizeof(*trng), GFP_KERNEL);
> +       if (!trng)
> +               goto err_ioremap;
> +
> +       trng->rng.name =3D devm_kstrdup(&pdev->dev, dev_name(&pdev->dev),
> +                                     GFP_KERNEL);
> +       if (!trng->rng.name)
> +               goto err_ioremap;
> +
> +       trng->rng.init =3D exynos_trng_init;
> +       trng->rng.read =3D exynos_trng_do_read;
> +       trng->rng.priv =3D (unsigned long) trng;
> +
> +       platform_set_drvdata(pdev, trng);
> +       trng->dev =3D &pdev->dev;
> +
> +       res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +       trng->mem =3D devm_ioremap_resource(&pdev->dev, res);
> +       if (IS_ERR(trng->mem)) {
> +               dev_err(&pdev->dev, "Couldn't map IO resources.\n");
> +               ret =3D PTR_ERR(trng->mem);
> +               goto err_ioremap;
> +       }
> +
> +       pm_runtime_enable(&pdev->dev);
> +       ret =3D pm_runtime_get_sync(&pdev->dev);
> +       if (ret < 0) {
> +               dev_err(&pdev->dev, "pm_runtime_get_sync() failed: %d.\n"=
, ret);
> +               goto err_ioremap;
> +       }
> +
> +       trng->clk =3D devm_clk_get(&pdev->dev, "secss");
> +       if (IS_ERR(trng->clk)) {
> +               /* XXX: EPROBE_DEFER ? */
> +               dev_err(&pdev->dev, "Couldn't get clock.\n");
> +               ret =3D PTR_ERR(trng->clk);
> +               goto err_clock;
> +       }
> +
> +       ret =3D clk_prepare_enable(trng->clk);
> +       if (ret) {
> +               dev_err(&pdev->dev, "Unable to enable the clk: %d.\n", re=
t);
> +               goto err_clock;
> +       }

Why not move clk_prepare_enable to init call? While at it please add a
cleanup callback as well.

> +
> +       ret =3D hwrng_register(&trng->rng);
> +       if (ret) {
> +               dev_err(&pdev->dev, "Couldn't register hwrng device.\n");
> +               goto err_register;
> +       }
> +
> +       dev_info(&pdev->dev, "Exynos True Random Number Generator.\n");
> +
> +       return 0;
> +
> +err_register:
> +       clk_disable_unprepare(trng->clk);
> +
> +err_clock:
> +       trng->mem =3D NULL;
> +       pm_runtime_put_sync(&pdev->dev);
> +       pm_runtime_disable(&pdev->dev);
> +
> +err_ioremap:
> +       dev_err(&pdev->dev, "Initialisation failed.\n");
> +       return ret;
> +}
> +
> +static int exynos_trng_remove(struct platform_device *pdev)
> +{
> +       exynos_trng_dev =3D NULL;
> +
> +       return 0;
> +}

remove is not required as it does not do anything significant.

> +
> +static int __maybe_unused exynos_trng_suspend(struct device *dev)
> +{
> +       pm_runtime_put_sync(dev);
> +
> +       return 0;
> +}
> +
> +static int __maybe_unused exynos_trng_resume(struct device *dev)
> +{
> +       int ret;
> +
> +       ret =3D pm_runtime_get_sync(dev);
> +       if (ret < 0) {
> +               dev_err(dev, "pm_runtime_get_sync() failed: %d.\n", ret);
> +               pm_runtime_put_noidle(dev);
> +               return ret;
> +       }
> +
> +       return 0;
> +}
> +
> +static SIMPLE_DEV_PM_OPS(exynos_trng_pm_ops, exynos_trng_suspend,
> +                        exynos_trng_resume);
> +
> +static const struct of_device_id exynos_trng_dt_match[] =3D {
> +       {
> +               .compatible =3D "samsung,exynos5250-trng",
> +       },
> +       { },
> +};
> +MODULE_DEVICE_TABLE(of, exynos_rng_dt_match);
> +
> +static struct platform_driver exynos_trng_driver =3D {
> +       .driver =3D {
> +               .name =3D "exynos-trng",
> +               .pm =3D &exynos_trng_pm_ops,
> +               .of_match_table =3D exynos_trng_dt_match,
> +       },
> +       .probe =3D exynos_trng_probe,
> +       .remove =3D exynos_trng_remove,
> +};
> +
> +module_platform_driver(exynos_trng_driver);
> +MODULE_AUTHOR("=C5=81ukasz Stelmach");
> +MODULE_DESCRIPTION("H/W TRNG driver for Exynos chips");
> +MODULE_LICENSE("GPL");
> --
> 2.11.0
>

Regards,
PrasannaKumar
