From: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Subject: Re: [PATCH 3/3] hwrng: mxc-fsl - add support for Freescale RNGC
Date: Tue, 18 Jul 2017 11:19:22 +0530
Message-ID: <CANc+2y7icNR3hJS0wCFd_-90X6bXkJYMEO6m53HDG8SBM0FZ2g@mail.gmail.com>
References: <1457705200-16951-1-git-send-email-s.trumtrar@pengutronix.de>
 <1500326163-4556-1-git-send-email-martin@kaiser.cx> <1500326163-4556-3-git-send-email-martin@kaiser.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Mark Rutland <mark.rutland@arm.com>,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        linux-crypto@vger.kernel.org, kernel@pengutronix.de,
        Fabio Estevam <festevam@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
To: Martin Kaiser <martin@kaiser.cx>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ua0-f195.google.com ([209.85.217.195]:33526 "EHLO
        mail-ua0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751026AbdGRFtY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Jul 2017 01:49:24 -0400
In-Reply-To: <1500326163-4556-3-git-send-email-martin@kaiser.cx>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Martin,

On 18 July 2017 at 02:46, Martin Kaiser <martin@kaiser.cx> wrote:
> From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
>
> The driver is ported from Freescales Linux git and can be
> found in the
>
>         vendor/freescale/imx_2.6.35_maintain
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
> Signed-off-by: Martin Kaiser <martin@kaiser.cx>
> ---
> Changes in v3:
>    - use pdev->dev to request the irq, rngc->dev is not yet initialized
>    - remove unused defines for registers and fields
>    - use module_platform_driver_probe()
>    - clean up the error handling in the probe function,
>      disable the clock if necessary
>    - self-test must succeed in the first run
>    - check for errors after seeding, exit for errors unrelated to
>      statistics
>    - set a timeout when waiting for a completion
>
> Changes in v2:
>   - remove irq variable from private struct
>   - move devm_request_irq from mxc_rngc_init to probe
>   - return irq in case of error
>   - handle irq 0 as error
>
>  drivers/char/hw_random/Kconfig    |  13 ++
>  drivers/char/hw_random/Makefile   |   1 +
>  drivers/char/hw_random/mxc-rngc.c | 351 ++++++++++++++++++++++++++++++++++++++
>  3 files changed, 365 insertions(+)
>  create mode 100644 drivers/char/hw_random/mxc-rngc.c
>
> diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
> index 1b223c3..ef057b7 100644
> --- a/drivers/char/hw_random/Kconfig
> +++ b/drivers/char/hw_random/Kconfig
> @@ -255,6 +255,19 @@ config HW_RANDOM_MXC_RNGA
>
>           If unsure, say Y.
>
> +config HW_RANDOM_MXC_RNGC
> +       tristate "Freescale i.MX RNGC Random Number Generator"
> +       depends on ARCH_MXC
> +       default HW_RANDOM
> +       ---help---
> +         This driver provides kernel-side support for the Random Number
> +         Generator hardware found on some Freescale i.MX processors.
> +
> +         To compile this driver as a module, choose M here: the
> +         module will be called mxc-rngc.
> +
> +         If unsure, say Y.
> +
>  config HW_RANDOM_NOMADIK
>         tristate "ST-Ericsson Nomadik Random Number Generator support"
>         depends on ARCH_NOMADIK
> diff --git a/drivers/char/hw_random/Makefile b/drivers/char/hw_random/Makefile
> index b085975..043b71d 100644
> --- a/drivers/char/hw_random/Makefile
> +++ b/drivers/char/hw_random/Makefile
> @@ -20,6 +20,7 @@ obj-$(CONFIG_HW_RANDOM_PASEMI) += pasemi-rng.o
>  obj-$(CONFIG_HW_RANDOM_VIRTIO) += virtio-rng.o
>  obj-$(CONFIG_HW_RANDOM_TX4939) += tx4939-rng.o
>  obj-$(CONFIG_HW_RANDOM_MXC_RNGA) += mxc-rnga.o
> +obj-$(CONFIG_HW_RANDOM_MXC_RNGC) += mxc-rngc.o
>  obj-$(CONFIG_HW_RANDOM_OCTEON) += octeon-rng.o
>  obj-$(CONFIG_HW_RANDOM_NOMADIK) += nomadik-rng.o
>  obj-$(CONFIG_HW_RANDOM_PSERIES) += pseries-rng.o
> diff --git a/drivers/char/hw_random/mxc-rngc.c b/drivers/char/hw_random/mxc-rngc.c
> new file mode 100644
> index 0000000..56175b1
> --- /dev/null
> +++ b/drivers/char/hw_random/mxc-rngc.c
> @@ -0,0 +1,351 @@
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

Please combine above 2 comments.

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

I feel this comment is because of copy paste. If that's the case please remove.

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
> +#define RNGC_COMMAND                   0x0004
> +#define RNGC_CONTROL                   0x0008
> +#define RNGC_STATUS                            0x000C
> +#define RNGC_ERROR                             0x0010
> +#define RNGC_FIFO                              0x0014
> +#define RNGC_VERIF_CTRL                        0x0020
> +#define RNGC_OSC_CTRL_COUNT            0x0028
> +#define RNGC_OSC_COUNT                 0x002C
> +#define RNGC_OSC_COUNT_STATUS  0x0030
> +
> +#define RNGC_CMD_CLR_ERR                       0x00000020
> +#define RNGC_CMD_CLR_INT                       0x00000010
> +#define RNGC_CMD_SEED                          0x00000002
> +#define RNGC_CMD_SELF_TEST                     0x00000001
> +
> +#define RNGC_CTRL_MASK_ERROR           0x00000040
> +
> +#define RNGC_CTRL_MASK_DONE                    0x00000020
> +
> +#define RNGC_STATUS_ERROR                      0x00010000
> +#define RNGC_STATUS_FIFO_LEVEL_MASK            0x00000f00
> +#define RNGC_STATUS_FIFO_LEVEL_SHIFT   8
> +#define RNGC_STATUS_SEED_DONE                  0x00000020
> +#define RNGC_STATUS_ST_DONE                    0x00000010
> +
> +#define RNGC_ERROR_STATUS_BAD_KEY              0x00000040
> +#define RNGC_ERROR_STATUS_STAT_ERR             0x00000008
> +#define RNGC_ERROR_STATUS_OSC_ERR              0x00000002
> +
> +#define RNGC_TIMEOUT  3000 /* 3 sec */
> +
> +struct mxc_rngc {
> +       struct device           *dev;
> +       struct clk              *clk;
> +       void __iomem            *base;
> +       struct hwrng            rng;
> +       struct completion       rng_self_testing;
> +       struct completion       rng_seed_done;
> +};
> +
> +static int mxc_rngc_read(struct hwrng *rng, void *data, size_t max, bool wait)
> +{
> +       struct mxc_rngc *rngc = container_of(rng, struct mxc_rngc, rng);
> +       unsigned int status;
> +       unsigned int level;
> +       int retval = 0;
> +
> +       while (max > sizeof(u32)) {

Should the condition be max >= sizeof(u32)?

> +               status = __raw_readl(rngc->base + RNGC_STATUS);

Is there any specific reason for using __raw_readl? Why not just readl?
If there is no specific reason for using __raw_readl please use readl
in all the places.

> +               /* how many random numbers are in FIFO? [0-16] */
> +               level = (status & RNGC_STATUS_FIFO_LEVEL_MASK) >>
> +                       RNGC_STATUS_FIFO_LEVEL_SHIFT;
> +
> +               /* is there some error while reading this random number? */
> +               if (status & RNGC_STATUS_ERROR)
> +                       break;

Before calculating level error check can be done.

> +
> +               if (level) {
> +                       /* retrieve a random number from FIFO */
> +                       *(u32 *)data = __raw_readl(rngc->base + RNGC_FIFO);
> +
> +                       retval += sizeof(u32);
> +                       data += sizeof(u32);
> +                       max -= sizeof(u32);
> +               }
> +       }
> +
> +       return retval ? retval : -EIO;
> +}
> +
> +static irqreturn_t rngc_irq(int irq, void *priv)
> +{
> +       struct mxc_rngc *rngc = (struct mxc_rngc *)priv;
> +       int handled = IRQ_NONE;
> +
> +       /* is the seed creation done? */
> +       if (__raw_readl(rngc->base + RNGC_STATUS) & RNGC_STATUS_SEED_DONE) {
> +               complete(&rngc->rng_seed_done);
> +               __raw_writel(RNGC_CMD_CLR_INT | RNGC_CMD_CLR_ERR,
> +                            rngc->base + RNGC_COMMAND);
> +               handled = IRQ_HANDLED;
> +       }
> +
> +       /* is the self test done? */
> +       if (__raw_readl(rngc->base + RNGC_STATUS) & RNGC_STATUS_ST_DONE) {
> +               complete(&rngc->rng_self_testing);
> +               __raw_writel(RNGC_CMD_CLR_INT | RNGC_CMD_CLR_ERR,
> +                            rngc->base + RNGC_COMMAND);
> +               handled = IRQ_HANDLED;
> +       }
> +
> +       /* is there any error? */
> +       if (__raw_readl(rngc->base + RNGC_STATUS) & RNGC_STATUS_ERROR) {
> +               /* clear interrupt */
> +               __raw_writel(RNGC_CMD_CLR_INT | RNGC_CMD_CLR_ERR,
> +                            rngc->base + RNGC_COMMAND);
> +               handled = IRQ_HANDLED;
> +       }
> +
> +       return handled;
> +}
> +
> +static int mxc_rngc_init(struct hwrng *rng)
> +{
> +       struct mxc_rngc *rngc = container_of(rng, struct mxc_rngc, rng);
> +       u32 cmd, ctrl, osc, err_stat, err_reg;
> +       int ret;
> +
> +       err_stat = __raw_readl(rngc->base + RNGC_STATUS) & RNGC_STATUS_ERROR;
> +       if (err_stat) {
> +               /* is this a bad keys error ? */
> +               if (__raw_readl(rngc->base + RNGC_ERROR) &
> +                   RNGC_ERROR_STATUS_BAD_KEY) {
> +                       dev_err(rngc->dev, "Can't start, Bad Keys.\n");
> +                       return -EIO;
> +               }
> +       }

What keys? What is the purpose of this check? At this point only clk
is enabled for RNGC so I am wondering why this check is required?

> +
> +       /* mask all interrupts, will be unmasked soon */
> +       ctrl = __raw_readl(rngc->base + RNGC_CONTROL);
> +       __raw_writel(ctrl | RNGC_CTRL_MASK_DONE | RNGC_CTRL_MASK_ERROR,
> +                    rngc->base + RNGC_CONTROL);
> +
> +       /* verify if oscillator is working */
> +       osc = __raw_readl(rngc->base + RNGC_ERROR);
> +       if (osc & RNGC_ERROR_STATUS_OSC_ERR) {
> +               dev_err(rngc->dev, "RNGC Oscillator is dead!\n");
> +               return -EIO;
> +       }

Is this check useful? If clock is initialised properly I do not think
this case will happen. May be I am missing something. Please add a
comment if this check is valid.

> +
> +       /* clear error */
> +       cmd = __raw_readl(rngc->base + RNGC_COMMAND);
> +       __raw_writel(cmd | RNGC_CMD_CLR_ERR, rngc->base + RNGC_COMMAND);
> +
> +       /* unmask all interrupt */
> +       ctrl = __raw_readl(rngc->base + RNGC_CONTROL);
> +       __raw_writel(ctrl & ~(RNGC_CTRL_MASK_DONE |
> +                               RNGC_CTRL_MASK_ERROR),
> +                       rngc->base + RNGC_CONTROL);
> +
> +       /* run self test */
> +       cmd = __raw_readl(rngc->base + RNGC_COMMAND);
> +       __raw_writel(cmd | RNGC_CMD_SELF_TEST,
> +                       rngc->base + RNGC_COMMAND);
> +
> +       ret = wait_for_completion_timeout(&rngc->rng_self_testing,
> +                       RNGC_TIMEOUT);
> +       if (!ret)
> +               return -ETIMEDOUT;

RNG core can call init every time this rng device is selected as
current random number provider. Is self test required on every RNG
init?

By default self test need not be run, a module parameter can be added
for enabling self test.

> +
> +       if (__raw_readl(rngc->base + RNGC_ERROR) != 0) {
> +               dev_err(rngc->dev, "FSL RNGC self test failed.\n");
> +               return -EIO;
> +       }
> +
> +       /* create seed, repeat while there is some statistical error */
> +       do {
> +               /* clear error */
> +               cmd = __raw_readl(rngc->base + RNGC_COMMAND);
> +               __raw_writel(cmd | RNGC_CMD_CLR_ERR, rngc->base + RNGC_COMMAND);
> +
> +               /* seed creation */
> +               cmd = __raw_readl(rngc->base + RNGC_COMMAND);
> +               __raw_writel(cmd | RNGC_CMD_SEED, rngc->base + RNGC_COMMAND);
> +
> +               ret = wait_for_completion_timeout(&rngc->rng_seed_done,
> +                               RNGC_TIMEOUT);
> +               if (!ret)
> +                       return -ETIMEDOUT;
> +
> +               err_reg = __raw_readl(rngc->base + RNGC_ERROR);
> +
> +               /* exit if there's a "non-statistical" error or no error */
> +       } while (err_reg == RNGC_ERROR_STATUS_STAT_ERR);
> +
> +       if (err_reg != 0) {
> +               dev_err(rngc->dev, "FSL RNGC random seed creation failed.\n");
> +               return -EIO;
> +       }
> +
> +       return 0;
> +}
> +
> +static int mxc_rngc_probe(struct platform_device *pdev)
> +{
> +       struct mxc_rngc *rngc;
> +       struct resource *res;
> +       int ret;
> +       int irq;
> +
> +       rngc = devm_kzalloc(&pdev->dev, sizeof(*rngc), GFP_KERNEL);
> +       if (!rngc)
> +               return -ENOMEM;
> +
> +       res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +       rngc->base = devm_ioremap_resource(&pdev->dev, res);
> +       if (IS_ERR(rngc->base))
> +               return PTR_ERR(rngc->base);
> +
> +       rngc->clk = devm_clk_get(&pdev->dev, NULL);
> +       if (IS_ERR(rngc->clk)) {
> +               dev_err(&pdev->dev, "Can not get rng_clk\n");
> +               return PTR_ERR(rngc->clk);
> +       }
> +
> +       irq = platform_get_irq(pdev, 0);
> +       if (irq <= 0) {
> +               dev_err(&pdev->dev, "Couldn't get irq %d\n", irq);
> +               return irq;
> +       }
> +
> +       ret = clk_prepare_enable(rngc->clk);
> +       if (ret)
> +               return ret;
> +
> +       ret = devm_request_irq(&pdev->dev, irq, rngc_irq, 0, pdev->name,
> +                              (void *)rngc);
> +       if (ret) {
> +               dev_err(rngc->dev, "Can't get interrupt working.\n");
> +               goto err;
> +       }
> +
> +       init_completion(&rngc->rng_self_testing);
> +       init_completion(&rngc->rng_seed_done);
> +
> +       rngc->rng.name = pdev->name;
> +       rngc->rng.init = mxc_rngc_init;
> +       rngc->rng.read = mxc_rngc_read;

Assiging a quality would be great. That will help in deciding which
rng device to use if there are mulitple rng devices.

> +
> +       rngc->dev = &pdev->dev;
> +       platform_set_drvdata(pdev, rngc);
> +
> +       ret = hwrng_register(&rngc->rng);
> +       if (ret) {
> +               dev_err(&pdev->dev, "FSL RNGC registering failed (%d)\n", ret);
> +               goto err;
> +       }
> +
> +       dev_info(&pdev->dev, "Freescale RNGC Registered.\n");
> +       return 0;
> +
> +err:
> +       clk_disable_unprepare(rngc->clk);
> +
> +       return ret;
> +}
> +
> +static int __exit mxc_rngc_remove(struct platform_device *pdev)
> +{
> +       struct mxc_rngc *rngc = platform_get_drvdata(pdev);
> +
> +       hwrng_unregister(&rngc->rng);
> +
> +       clk_disable_unprepare(rngc->clk);
> +
> +       return 0;
> +}
> +
> +#ifdef CONFIG_PM
> +static int mxc_rngc_suspend(struct device *dev)
> +{
> +       struct mxc_rngc *rngc = dev_get_drvdata(dev);
> +
> +       clk_disable_unprepare(rngc->clk);
> +
> +       return 0;
> +}
> +
> +static int mxc_rngc_resume(struct device *dev)
> +{
> +       struct mxc_rngc *rngc = dev_get_drvdata(dev);
> +
> +       clk_prepare_enable(rngc->clk);
> +
> +       return 0;
> +}
> +
> +static const struct dev_pm_ops mxc_rngc_pm_ops = {
> +       .suspend        = mxc_rngc_suspend,
> +       .resume         = mxc_rngc_resume,
> +};
> +#endif
> +
> +static const struct of_device_id mxc_rngc_dt_ids[] = {
> +       { .compatible = "fsl,imx25-rng", .data = NULL, },
> +       { /* sentinel */ }
> +};
> +MODULE_DEVICE_TABLE(of, mxc_rngc_dt_ids);
> +
> +static struct platform_driver mxc_rngc_driver = {
> +       .driver = {
> +               .name = "mxc_rngc",
> +#ifdef CONFIG_PM
> +               .pm = &mxc_rngc_pm_ops,
> +#endif
> +               .of_match_table = mxc_rngc_dt_ids,
> +       },
> +       .remove = __exit_p(mxc_rngc_remove),
> +};
> +
> +module_platform_driver_probe(mxc_rngc_driver, mxc_rngc_probe);
> +
> +MODULE_AUTHOR("Freescale Semiconductor, Inc.");
> +MODULE_DESCRIPTION("H/W RNGC driver for i.MX");
> +MODULE_LICENSE("GPL");
> --
> 2.1.4
>

Regards,
PrasannaKumar
