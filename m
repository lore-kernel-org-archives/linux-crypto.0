From: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
Subject: Re: [PATCH v2 3/3] hwrng: mxc-fsl - add support for Freescale RNGC
Date: Fri, 11 Mar 2016 17:44:49 +0200
Message-ID: <56E2E7F1.6020501@mentor.com>
References: <1457705200-16951-1-git-send-email-s.trumtrar@pengutronix.de>
 <1457705200-16951-3-git-send-email-s.trumtrar@pengutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>,
	<devicetree@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>,
	<linux-crypto@vger.kernel.org>, <kernel@pengutronix.de>
To: Steffen Trumtrar <s.trumtrar@pengutronix.de>,
	Shawn Guo <shawnguo@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Matt Mackall <mpm@selenic.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from relay1.mentorg.com ([192.94.38.131]:46583 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932661AbcCKPo6 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 11 Mar 2016 10:44:58 -0500
In-Reply-To: <1457705200-16951-3-git-send-email-s.trumtrar@pengutronix.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 11.03.2016 16:06, Steffen Trumtrar wrote:
> The driver is ported from Freescales Linux git and can be
> found in the
> 
> 	vendor/freescale/imx_2.6.35_maintain
> 
> branch.
> 
> According to that code, the RNGC is found on Freescales i.MX3/5 SoCs.
> The i.MX2x actually has an RNGB, which has no driver implementation
> in Freescales kernel. However as it turns out, the driver for the RNGC
> works fine on the (at least) i.MX25. So, they seem to be somewhat
> compatible.
> 
> Signed-off-by: Steffen Trumtrar <s.trumtrar@pengutronix.de>
> ---
> Changes in v2:
>   - remove irq variable from private struct
>   - move devm_request_irq from mxc_rngc_init to probe
>   - return irq in case of error
>   - handle irq 0 as error
> 
>  drivers/char/hw_random/Kconfig    |  13 ++
>  drivers/char/hw_random/Makefile   |   1 +
>  drivers/char/hw_random/mxc-rngc.c | 398 ++++++++++++++++++++++++++++++++++++++
>  3 files changed, 412 insertions(+)
>  create mode 100644 drivers/char/hw_random/mxc-rngc.c
> 
> diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
> index dbf22719462f..9d6b5c42255b 100644
> --- a/drivers/char/hw_random/Kconfig
> +++ b/drivers/char/hw_random/Kconfig
> @@ -255,6 +255,19 @@ config HW_RANDOM_MXC_RNGA
>  
>  	  If unsure, say Y.
>  
> +config HW_RANDOM_MXC_RNGC
> +	tristate "Freescale i.MX RNGC Random Number Generator"
> +	depends on ARCH_MXC
> +	default HW_RANDOM
> +	---help---
> +	  This driver provides kernel-side support for the Random Number
> +	  Generator hardware found on some Freescale i.MX processors.
> +
> +	  To compile this driver as a module, choose M here: the
> +	  module will be called mxc-rngc.
> +
> +	  If unsure, say Y.
> +
>  config HW_RANDOM_NOMADIK
>  	tristate "ST-Ericsson Nomadik Random Number Generator support"
>  	depends on ARCH_NOMADIK
> diff --git a/drivers/char/hw_random/Makefile b/drivers/char/hw_random/Makefile
> index 5ad397635128..008463bcf662 100644
> --- a/drivers/char/hw_random/Makefile
> +++ b/drivers/char/hw_random/Makefile
> @@ -20,6 +20,7 @@ obj-$(CONFIG_HW_RANDOM_PASEMI) += pasemi-rng.o
>  obj-$(CONFIG_HW_RANDOM_VIRTIO) += virtio-rng.o
>  obj-$(CONFIG_HW_RANDOM_TX4939) += tx4939-rng.o
>  obj-$(CONFIG_HW_RANDOM_MXC_RNGA) += mxc-rnga.o
> +obj-$(CONFIG_HW_RANDOM_MXC_RNGC) += mxc-rngc.o
>  obj-$(CONFIG_HW_RANDOM_OCTEON) += octeon-rng.o
>  obj-$(CONFIG_HW_RANDOM_NOMADIK) += nomadik-rng.o
>  obj-$(CONFIG_HW_RANDOM_PPC4XX) += ppc4xx-rng.o
> diff --git a/drivers/char/hw_random/mxc-rngc.c b/drivers/char/hw_random/mxc-rngc.c
> new file mode 100644
> index 000000000000..3a2a9b2ad7db
> --- /dev/null
> +++ b/drivers/char/hw_random/mxc-rngc.c
> @@ -0,0 +1,398 @@
> +/*
> + * RNG driver for Freescale RNGC
> + *
> + * Copyright (C) 2008-2012 Freescale Semiconductor, Inc.
> + */
> +
> +/*
> + * The code contained herein is licensed under the GNU General Public
> + * License. You may obtain a copy of the GNU General Public License
> + * Version 2 or later at the following locations:
> + *
> + * http://www.opensource.org/licenses/gpl-license.html
> + * http://www.gnu.org/copyleft/gpl.html
> + */
> +
> +/*
> + * Hardware driver for the Intel/AMD/VIA Random Number Generators (RNG)
> + * (c) Copyright 2003 Red Hat Inc <jgarzik@redhat.com>
> + *
> + * derived from
> + *
> + * Hardware driver for the AMD 768 Random Number Generator (RNG)
> + * (c) Copyright 2001 Red Hat Inc <alan@redhat.com>
> + *
> + * derived from
> + *
> + * Hardware driver for Intel i810 Random Number Generator (RNG)
> + * Copyright 2000,2001 Jeff Garzik <jgarzik@pobox.com>
> + * Copyright 2000,2001 Philipp Rumpf <prumpf@mandrakesoft.com>
> + *
> + * This file is licensed under  the terms of the GNU General Public
> + * License version 2. This program is licensed "as is" without any
> + * warranty of any kind, whether express or implied.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/kernel.h>
> +#include <linux/clk.h>
> +#include <linux/err.h>
> +#include <linux/platform_device.h>
> +#include <linux/interrupt.h>
> +#include <linux/hw_random.h>
> +#include <linux/completion.h>
> +#include <linux/io.h>
> +
> +#define RNGC_VERSION_MAJOR3 3
> +
> +#define RNGC_VERSION_ID				0x0000
> +#define RNGC_COMMAND				0x0004
> +#define RNGC_CONTROL				0x0008
> +#define RNGC_STATUS				0x000C
> +#define RNGC_ERROR				0x0010
> +#define RNGC_FIFO				0x0014
> +#define RNGC_VERIF_CTRL				0x0020
> +#define RNGC_OSC_CTRL_COUNT			0x0028
> +#define RNGC_OSC_COUNT				0x002C
> +#define RNGC_OSC_COUNT_STATUS			0x0030
> +
> +#define RNGC_VERID_ZEROS_MASK			0x0f000000
> +#define RNGC_VERID_RNG_TYPE_MASK		0xf0000000
> +#define RNGC_VERID_RNG_TYPE_SHIFT		28
> +#define RNGC_VERID_CHIP_VERSION_MASK		0x00ff0000
> +#define RNGC_VERID_CHIP_VERSION_SHIFT		16
> +#define RNGC_VERID_VERSION_MAJOR_MASK		0x0000ff00
> +#define RNGC_VERID_VERSION_MAJOR_SHIFT		8
> +#define RNGC_VERID_VERSION_MINOR_MASK		0x000000ff
> +#define RNGC_VERID_VERSION_MINOR_SHIFT		0

All RNGC_VERID_* are not used. And actually quite many other
defined values are not used, e.g. all *_ZEROS_MASK etc.

> +
> +#define RNGC_CMD_ZEROS_MASK			0xffffff8c
> +#define RNGC_CMD_SW_RST				0x00000040
> +#define RNGC_CMD_CLR_ERR			0x00000020
> +#define RNGC_CMD_CLR_INT			0x00000010
> +#define RNGC_CMD_SEED				0x00000002
> +#define RNGC_CMD_SELF_TEST			0x00000001
> +
> +#define RNGC_CTRL_ZEROS_MASK			0xfffffc8c
> +#define RNGC_CTRL_CTL_ACC			0x00000200
> +#define RNGC_CTRL_VERIF_MODE			0x00000100
> +#define RNGC_CTRL_MASK_ERROR			0x00000040
> +
> +#define RNGC_CTRL_MASK_DONE			0x00000020
> +#define RNGC_CTRL_AUTO_SEED			0x00000010
> +#define RNGC_CTRL_FIFO_UFLOW_MASK		0x00000003
> +#define RNGC_CTRL_FIFO_UFLOW_SHIFT		0
> +
> +#define RNGC_CTRL_FIFO_UFLOW_ZEROS_ERROR	0
> +#define RNGC_CTRL_FIFO_UFLOW_ZEROS_ERROR2	1
> +#define RNGC_CTRL_FIFO_UFLOW_BUS_XFR		2
> +#define RNGC_CTRL_FIFO_UFLOW_ZEROS_INTR		3
> +
> +#define RNGC_STATUS_ST_PF_MASK			0x00c00000
> +#define RNGC_STATUS_ST_PF_SHIFT			22
> +#define RNGC_STATUS_ST_PF_TRNG			0x00800000
> +#define RNGC_STATUS_ST_PF_PRNG			0x00400000
> +#define RNGC_STATUS_ERROR			0x00010000
> +#define RNGC_STATUS_FIFO_SIZE_MASK		0x0000f000
> +#define RNGC_STATUS_FIFO_SIZE_SHIFT		12
> +#define RNGC_STATUS_FIFO_LEVEL_MASK		0x00000f00
> +#define RNGC_STATUS_FIFO_LEVEL_SHIFT		8
> +#define RNGC_STATUS_NEXT_SEED_DONE		0x00000040
> +#define RNGC_STATUS_SEED_DONE			0x00000020
> +#define RNGC_STATUS_ST_DONE			0x00000010
> +#define RNGC_STATUS_RESEED			0x00000008
> +#define RNGC_STATUS_SLEEP			0x00000004
> +#define RNGC_STATUS_BUSY			0x00000002
> +#define RNGC_STATUS_SEC_STATE			0x00000001
> +
> +#define RNGC_ERROR_STATUS_ZEROS_MASK		0xffffffc0
> +#define RNGC_ERROR_STATUS_BAD_KEY		0x00000040
> +#define RNGC_ERROR_STATUS_RAND_ERR		0x00000020
> +#define RNGC_ERROR_STATUS_FIFO_ERR		0x00000010
> +#define RNGC_ERROR_STATUS_STAT_ERR		0x00000008
> +#define RNGC_ERROR_STATUS_ST_ERR		0x00000004
> +#define RNGC_ERROR_STATUS_OSC_ERR		0x00000002
> +#define RNGC_ERROR_STATUS_LFSR_ERR		0x00000001
> +
> +#define RNG_ADDR_RANGE				0x34
> +
> +struct mxc_rngc {
> +	struct device		*dev;
> +	struct clk		*clk;
> +	void __iomem		*base;
> +	struct hwrng		rng;
> +	struct completion	rng_self_testing;
> +	struct completion	rng_seed_done;
> +};
> +
> +static int mxc_rngc_read(struct hwrng *rng, void *data, size_t max, bool wait)
> +{
> +	struct mxc_rngc *rngc = container_of(rng, struct mxc_rngc, rng);
> +	unsigned int status;
> +	unsigned int level;
> +	int retval = 0;
> +
> +	while (max > sizeof(u32)) {
> +		status = __raw_readl(rngc->base + RNGC_STATUS);
> +		/* how many random numbers are in FIFO? [0-16] */
> +		level = (status & RNGC_STATUS_FIFO_LEVEL_MASK) >>
> +			RNGC_STATUS_FIFO_LEVEL_SHIFT;
> +
> +		/* is there some error while reading this random number? */
> +		if (status & RNGC_STATUS_ERROR)
> +			break;
> +
> +		if (level) {
> +			/* retrieve a random number from FIFO */
> +			*(u32 *)data = __raw_readl(rngc->base + RNGC_FIFO);
> +
> +			retval += sizeof(u32);
> +			data += sizeof(u32);
> +			max -= sizeof(u32);
> +		}
> +	}
> +
> +	return retval ? retval : -EIO;
> +}
> +
> +static irqreturn_t rngc_irq(int irq, void *priv)
> +{
> +	struct mxc_rngc *rngc = (struct mxc_rngc *)priv;
> +	int handled = IRQ_NONE;
> +
> +	/* is the seed creation done? */
> +	if (__raw_readl(rngc->base + RNGC_STATUS) & RNGC_STATUS_SEED_DONE) {
> +		complete(&rngc->rng_seed_done);
> +		__raw_writel(RNGC_CMD_CLR_INT | RNGC_CMD_CLR_ERR,
> +			     rngc->base + RNGC_COMMAND);
> +		handled = IRQ_HANDLED;
> +	}
> +
> +	/* is the self test done? */
> +	if (__raw_readl(rngc->base + RNGC_STATUS) & RNGC_STATUS_ST_DONE) {
> +		complete(&rngc->rng_self_testing);
> +		__raw_writel(RNGC_CMD_CLR_INT | RNGC_CMD_CLR_ERR,
> +			     rngc->base + RNGC_COMMAND);
> +		handled = IRQ_HANDLED;
> +	}
> +
> +	/* is there any error? */
> +	if (__raw_readl(rngc->base + RNGC_STATUS) & RNGC_STATUS_ERROR) {
> +		/* clear interrupt */
> +		__raw_writel(RNGC_CMD_CLR_INT | RNGC_CMD_CLR_ERR,
> +			     rngc->base + RNGC_COMMAND);
> +		handled = IRQ_HANDLED;

For the code errors seem to be harmless, is it so? Does it make
sense to inform a user about errors?

> +	}
> +
> +	return handled;
> +}
> +
> +static int mxc_rngc_init(struct hwrng *rng)
> +{
> +	struct mxc_rngc *rngc = container_of(rng, struct mxc_rngc, rng);
> +	u32 cmd;
> +	u32 ctrl;
> +	u32 osc;
> +	int err;
> +
> +	err = __raw_readl(rngc->base + RNGC_STATUS) & RNGC_STATUS_ERROR;
> +	if (err) {
> +		/* is this a bad keys error ? */
> +		if (__raw_readl(rngc->base + RNGC_ERROR) &
> +		    RNGC_ERROR_STATUS_BAD_KEY) {
> +			dev_err(rngc->dev, "Can't start, Bad Keys.\n");
> +			return -EIO;
> +		}
> +	}
> +
> +	/* mask all interrupts, will be unmasked soon */
> +	ctrl = __raw_readl(rngc->base + RNGC_CONTROL);
> +	__raw_writel(ctrl | RNGC_CTRL_MASK_DONE | RNGC_CTRL_MASK_ERROR,
> +		     rngc->base + RNGC_CONTROL);
> +
> +	/* verify if oscillator is working */
> +	osc = __raw_readl(rngc->base + RNGC_ERROR);
> +	if (osc & RNGC_ERROR_STATUS_OSC_ERR) {
> +		dev_err(rngc->dev, "RNGC Oscillator is dead!\n");
> +		return -EIO;
> +	}
> +
> +	/* do self test, repeat until get success */
> +	do {
> +		/* clear error */
> +		cmd = __raw_readl(rngc->base + RNGC_COMMAND);
> +		__raw_writel(cmd | RNGC_CMD_CLR_ERR, rngc->base + RNGC_COMMAND);
> +
> +		/* unmask all interrupt */
> +		ctrl = __raw_readl(rngc->base + RNGC_CONTROL);
> +		__raw_writel(ctrl & ~(RNGC_CTRL_MASK_DONE |
> +				      RNGC_CTRL_MASK_ERROR),
> +			     rngc->base + RNGC_CONTROL);
> +
> +		/* run self test */
> +		cmd = __raw_readl(rngc->base + RNGC_COMMAND);
> +		__raw_writel(cmd | RNGC_CMD_SELF_TEST,
> +			     rngc->base + RNGC_COMMAND);
> +
> +		wait_for_completion(&rngc->rng_self_testing);

I would suggest to use wait_for_completion_timeout().

> +
> +	} while (__raw_readl(rngc->base + RNGC_ERROR) &
> +		 RNGC_ERROR_STATUS_ST_ERR);

Logic of running a self test until error condition is gone looks strange.

> +
> +	/* clear interrupt. Is it really necessary here? */
> +	__raw_writel(RNGC_CMD_CLR_INT | RNGC_CMD_CLR_ERR,
> +		     rngc->base + RNGC_COMMAND);

Answering the question above I believe it is not needed here.

> +	/* create seed, repeat while there is some statistical error */
> +	do {
> +		/* clear error */
> +		cmd = __raw_readl(rngc->base + RNGC_COMMAND);
> +		__raw_writel(cmd | RNGC_CMD_CLR_ERR, rngc->base + RNGC_COMMAND);
> +
> +		/* seed creation */
> +		cmd = __raw_readl(rngc->base + RNGC_COMMAND);
> +		__raw_writel(cmd | RNGC_CMD_SEED, rngc->base + RNGC_COMMAND);
> +
> +		wait_for_completion(&rngc->rng_seed_done);

I would suggest to use wait_for_completion_timeout().

> +
> +	} while (__raw_readl(rngc->base + RNGC_ERROR) &
> +		 RNGC_ERROR_STATUS_STAT_ERR);

Any chance to loop forever?

> +
> +	err = __raw_readl(rngc->base + RNGC_ERROR) &
> +		(RNGC_ERROR_STATUS_STAT_ERR |
> +		 RNGC_ERROR_STATUS_RAND_ERR |
> +		 RNGC_ERROR_STATUS_FIFO_ERR |
> +		 RNGC_ERROR_STATUS_ST_ERR |
> +		 RNGC_ERROR_STATUS_OSC_ERR |
> +		 RNGC_ERROR_STATUS_LFSR_ERR);
> +
> +	if (err) {
> +		dev_err(rngc->dev, "FSL RNGC appears inoperable.\n");
> +		return -EIO;
> +	}
> +
> +	return 0;
> +}
> +
> +static int mxc_rngc_probe(struct platform_device *pdev)
> +{
> +	struct mxc_rngc *rngc;
> +	struct resource *res;
> +	int ret;
> +	int irq;
> +
> +	rngc = devm_kzalloc(&pdev->dev, sizeof(*rngc), GFP_KERNEL);
> +	if (!rngc)
> +		return -ENOMEM;
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	rngc->base = devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(rngc->base))
> +		return PTR_ERR(rngc->base);
> +
> +	rngc->clk = devm_clk_get(&pdev->dev, NULL);
> +	if (IS_ERR(rngc->clk)) {
> +		dev_err(&pdev->dev, "Can not get rng_clk\n");
> +		return PTR_ERR(rngc->clk);
> +	}
> +
> +	ret = clk_prepare_enable(rngc->clk);
> +	if (ret)
> +		return ret;
> +
> +	irq = platform_get_irq(pdev, 0);
> +	if (irq <= 0) {
> +		dev_err(&pdev->dev, "Couldn't get irq %d\n", irq);
> +		clk_disable_unprepare(rngc->clk);
> +
> +		return irq;
> +	}
> +	ret = devm_request_irq(rngc->dev, irq, rngc_irq, 0, pdev->name,
> +			       (void *)rngc);
> +	if (ret) {
> +		dev_err(rngc->dev, "Can't get interrupt working.\n");
> +		return -EIO;

Leaked enabled rngc->clk clock on error path.

> +	}
> +
> +	init_completion(&rngc->rng_self_testing);
> +	init_completion(&rngc->rng_seed_done);
> +
> +	rngc->rng.name = pdev->name;
> +	rngc->rng.init = mxc_rngc_init;
> +	rngc->rng.read = mxc_rngc_read;
> +
> +	rngc->dev = &pdev->dev;
> +	platform_set_drvdata(pdev, rngc);
> +
> +	ret = hwrng_register(&rngc->rng);
> +	if (ret) {
> +		dev_err(&pdev->dev, "FSL RNGC registering failed (%d)\n", ret);
> +		clk_disable_unprepare(rngc->clk);
> +
> +		return ret;
> +	}
> +
> +	dev_info(&pdev->dev, "Freescale RNGC Registered.\n");
> +
> +	return 0;
> +}
> +
> +static int mxc_rngc_remove(struct platform_device *pdev)
> +{
> +	struct mxc_rngc *rngc = platform_get_drvdata(pdev);
> +
> +	hwrng_unregister(&rngc->rng);
> +
> +	clk_disable_unprepare(rngc->clk);
> +
> +	return 0;
> +}
> +
> +#ifdef CONFIG_PM
> +static int mxc_rngc_suspend(struct device *dev)
> +{
> +	struct mxc_rngc *rngc = dev_get_drvdata(dev);
> +
> +	clk_disable_unprepare(rngc->clk);
> +
> +	return 0;
> +}
> +
> +static int mxc_rngc_resume(struct device *dev)
> +{
> +	struct mxc_rngc *rngc = dev_get_drvdata(dev);
> +
> +	clk_prepare_enable(rngc->clk);
> +
> +	return 0;
> +}
> +
> +static const struct dev_pm_ops mxc_rngc_pm_ops = {
> +	.suspend	= mxc_rngc_suspend,
> +	.resume		= mxc_rngc_resume,
> +};
> +#endif
> +
> +static const struct of_device_id mxc_rngc_dt_ids[] = {
> +	{ .compatible = "fsl,imx25-rng", .data = NULL, },
> +	{ /* sentinel */ }
> +};
> +MODULE_DEVICE_TABLE(of, mxc_rngc_dt_ids);
> +
> +static struct platform_driver mxc_rngc_driver = {
> +	.probe = mxc_rngc_probe,
> +	.remove = mxc_rngc_remove,
> +	.driver = {
> +		.name = "mxc_rngc",
> +#ifdef CONFIG_PM
> +		.pm = &mxc_rngc_pm_ops,
> +#endif
> +		.of_match_table = mxc_rngc_dt_ids,
> +	},
> +};
> +
> +module_platform_driver(mxc_rngc_driver);
> +MODULE_AUTHOR("Freescale Semiconductor, Inc.");
> +MODULE_DESCRIPTION("H/W RNGC driver for i.MX");
> +MODULE_LICENSE("GPL");
> 

--
With best wishes,
Vladimir
