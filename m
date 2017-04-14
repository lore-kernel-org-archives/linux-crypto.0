From: Sean Wang <sean.wang-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 2/2] hwrng: mtk: Add driver for hardware random
 generator on MT7623 SoC
Date: Fri, 14 Apr 2017 11:38:45 +0800
Message-ID: <1492141125.6147.3.camel@mtkswgap22>
References: <1492067108-14748-1-git-send-email-sean.wang@mediatek.com>
         <1492067108-14748-3-git-send-email-sean.wang@mediatek.com>
         <20170413110643.GA413@Red>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>, <mpm-VDJrAJ4Gl5ZBDgjK7y7TUQ@public.gmane.org>,
        <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, <mark.rutland-5wv7dgnIgG8@public.gmane.org>,
        <prasannatsmkumar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, <romain.perier-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>,
        <shannon.nelson-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, <weiyongjun1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>,
        <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, <linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        <linux-mediatek-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>,
        <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>,
        <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, <keyhaede-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Corentin Labbe <clabbe.montjoie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170413110643.GA413@Red>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

Hi Corentin,

I all agree and appreciate your careful reviewing. 

They will be added into the next one.

	Sean

On Thu, 2017-04-13 at 13:06 +0200, Corentin Labbe wrote:
> Hello
> 
> I have some minor comment below:
> 
> On Thu, Apr 13, 2017 at 03:05:08PM +0800, sean.wang-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org wrote:
> > From: Sean Wang <sean.wang-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
> > 
> > This patch adds support for hardware random generator on MT7623 SoC
> > and should also work on other similar Mediatek SoCs. Currently,
> > the driver is already tested successfully with rng-tools.
> > 
> > Signed-off-by: Sean Wang <sean.wang-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
> > ---
> >  drivers/char/hw_random/Kconfig   |  16 +++-
> >  drivers/char/hw_random/Makefile  |   2 +-
> >  drivers/char/hw_random/mtk-rng.c | 174 +++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 190 insertions(+), 2 deletions(-)
> >  create mode 100644 drivers/char/hw_random/mtk-rng.c
> > 
> > diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
> > index 0cafe08..af782ce 100644
> > --- a/drivers/char/hw_random/Kconfig
> > +++ b/drivers/char/hw_random/Kconfig
> > @@ -419,10 +419,24 @@ config HW_RANDOM_CAVIUM
> >           Generator hardware found on Cavium SoCs.
> >  
> >           To compile this driver as a module, choose M here: the
> > -         module will be called cavium_rng.
> > +         module will be called mtk-rng.
> 
> Unwanted change
> 
> >  
> >           If unsure, say Y.
> >  
> > +config HW_RANDOM_MTK
> > +	tristate "Mediatek Random Number Generator support"
> > +	depends on HW_RANDOM
> > +	depends on ARCH_MEDIATEK || COMPILE_TEST
> > +	default y
> > +	---help---
> > +	  This driver provides kernel-side support for the Random Number
> > +	  Generator hardware found on Mediatek SoCs.
> > +
> > +	  To compile this driver as a module, choose M here. the
> > +	  module will be called mtk-rng.
> > +
> > +	  If unsure, say Y.
> > +
> >  endif # HW_RANDOM
> >  
> >  config UML_RANDOM
> > diff --git a/drivers/char/hw_random/Makefile b/drivers/char/hw_random/Makefile
> > index 5f52b1e..68be716 100644
> > --- a/drivers/char/hw_random/Makefile
> > +++ b/drivers/char/hw_random/Makefile
> > @@ -1,7 +1,6 @@
> >  #
> >  # Makefile for HW Random Number Generator (RNG) device drivers.
> >  #
> > -
> 
> Another unwanted change
> 
> >  obj-$(CONFIG_HW_RANDOM) += rng-core.o
> >  rng-core-y := core.o
> >  obj-$(CONFIG_HW_RANDOM_TIMERIOMEM) += timeriomem-rng.o
> > @@ -36,3 +35,4 @@ obj-$(CONFIG_HW_RANDOM_STM32) += stm32-rng.o
> >  obj-$(CONFIG_HW_RANDOM_PIC32) += pic32-rng.o
> >  obj-$(CONFIG_HW_RANDOM_MESON) += meson-rng.o
> >  obj-$(CONFIG_HW_RANDOM_CAVIUM) += cavium-rng.o cavium-rng-vf.o
> > +obj-$(CONFIG_HW_RANDOM_MTK)	+= mtk-rng.o
> > diff --git a/drivers/char/hw_random/mtk-rng.c b/drivers/char/hw_random/mtk-rng.c
> > new file mode 100644
> > index 0000000..6561ee0
> > --- /dev/null
> > +++ b/drivers/char/hw_random/mtk-rng.c
> > @@ -0,0 +1,174 @@
> > +/*
> > + * Driver for Mediatek Hardware Random Number Generator
> > + *
> > + * Copyright (C) 2017 Sean Wang <sean.wang-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
> > + *
> > + * This program is free software; you can redistribute it and/or
> > + * modify it under the terms of the GNU General Public License as
> > + * published by the Free Software Foundation; either version 2 of
> > + * the License, or (at your option) any later version.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
> > + * GNU General Public License for more details.
> > + */
> > +#define MTK_RNG_DEV KBUILD_MODNAME
> > +
> > +#include <linux/clk.h>
> > +#include <linux/delay.h>
> > +#include <linux/err.h>
> > +#include <linux/hw_random.h>
> > +#include <linux/io.h>
> > +#include <linux/iopoll.h>
> > +#include <linux/kernel.h>
> > +#include <linux/module.h>
> > +#include <linux/of.h>
> > +#include <linux/platform_device.h>
> > +
> > +#define USEC_POLL			2
> > +#define TIMEOUT_POLL			20
> > +
> > +#define RNG_CTRL			0x00
> > +#define  RNG_EN				BIT(0)
> > +#define  RNG_READY			BIT(31)
> 
> Keep only one space between define and name
> 
> > +
> > +#define RNG_DATA			0x08
> > +
> > +#define to_mtk_rng(p)	container_of(p, struct mtk_rng, rng)
> > +
> > +struct mtk_rng {
> > +	struct device	*dev;
> > +	void __iomem *base;
> > +	struct clk *clk;
> > +	struct hwrng rng;
> > +};
> > +
> > +static int mtk_rng_init(struct hwrng *rng)
> > +{
> > +	struct mtk_rng *priv = to_mtk_rng(rng);
> > +	u32 val;
> > +	int err;
> > +
> > +	err = clk_prepare_enable(priv->clk);
> > +	if (err)
> > +		return err;
> > +
> > +	val = readl(priv->base + RNG_CTRL);
> > +	val |= RNG_EN;
> > +	writel(val, priv->base + RNG_CTRL);
> > +
> > +	return 0;
> > +}
> > +
> > +static void mtk_rng_cleanup(struct hwrng *rng)
> > +{
> > +	struct mtk_rng *priv = to_mtk_rng(rng);
> > +	u32 val;
> > +
> > +	val = readl(priv->base + RNG_CTRL);
> > +	val &= ~RNG_EN;
> > +	writel(val, priv->base + RNG_CTRL);
> > +
> > +	clk_disable_unprepare(priv->clk);
> > +}
> > +
> > +static bool mtk_rng_wait_ready(struct hwrng *rng, bool wait)
> > +{
> > +	struct mtk_rng *priv = to_mtk_rng(rng);
> > +	int ready;
> > +
> > +	ready = readl(priv->base + RNG_CTRL) & RNG_READY;
> > +	if (!ready && wait)
> > +		readl_poll_timeout_atomic(priv->base + RNG_CTRL, ready,
> > +					  ready & RNG_READY, USEC_POLL,
> > +					  TIMEOUT_POLL);
> > +	return !!ready;
> > +}
> > +
> > +static int mtk_rng_read(struct hwrng *rng, void *buf, size_t max, bool wait)
> > +{
> > +	struct mtk_rng *priv = to_mtk_rng(rng);
> > +	int retval = 0;
> > +
> > +	while (max >= sizeof(u32)) {
> > +		if (!mtk_rng_wait_ready(rng, wait))
> > +			break;
> > +
> > +		*(u32 *)buf = readl(priv->base + RNG_DATA);
> > +		retval += sizeof(u32);
> > +		buf += sizeof(u32);
> > +		max -= sizeof(u32);
> > +	}
> > +
> > +	if (unlikely(wait && max))
> > +		dev_warn(priv->dev, "timeout might be not properly set\n");
> > +
> > +	return retval || !wait ? retval : -EIO;
> > +}
> > +
> > +static int mtk_rng_probe(struct platform_device *pdev)
> > +{
> > +	struct resource *res;
> > +	int ret;
> > +	struct mtk_rng *priv;
> > +
> > +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> > +	if (!res) {
> > +		dev_err(&pdev->dev, "no iomem resource\n");
> > +		return -ENXIO;
> > +	}
> > +
> > +	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
> > +	if (!priv)
> > +		return -ENOMEM;
> > +
> > +	priv->dev = &pdev->dev;
> > +	priv->rng.name = pdev->name;
> > +	priv->rng.init = mtk_rng_init;
> > +	priv->rng.cleanup = mtk_rng_cleanup;
> > +	priv->rng.read = mtk_rng_read;
> > +
> > +	priv->clk = devm_clk_get(&pdev->dev, "rng");
> > +	if (IS_ERR(priv->clk)) {
> > +		ret = PTR_ERR(priv->clk);
> > +		dev_err(&pdev->dev, "no clock for device: %d\n", ret);
> > +		return ret;
> > +	}
> > +
> > +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> 
> You get that resource twice
> 
> Regards
> Corentin Labbe


--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
