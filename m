From: Linus Walleij <linus.walleij-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/3] hwrng: stm32 - add support for STM32 HW RNG
Date: Sun, 4 Oct 2015 12:32:15 +0200
Message-ID: <CACRpkdaCBUnFMYMSdjF4bHwQH3zxu2ou7b54E4FzgH9UbNQEHw@mail.gmail.com>
References: <1443904519-24012-1-git-send-email-daniel.thompson@linaro.org>
	<1443904519-24012-3-git-send-email-daniel.thompson@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Matt Mackall <mpm-VDJrAJ4Gl5ZBDgjK7y7TUQ@public.gmane.org>,
	Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
	"devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	"linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org"
	<linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>,
	"linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	"linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Patch Tracking <patches-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>,
	Linaro Kernel Mailman List <linaro-kernel-cunTk1MwBs8s++Sfvej+rw@public.gmane.org>,
	Maxime Coquelin <mcoquelin.stm32-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
	Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>,
	Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>,
	Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>,
	Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
To: Daniel Thompson <daniel.thompson-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>,
	Lee Jones <lee.jones-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1443904519-24012-3-git-send-email-daniel.thompson-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

On Sat, Oct 3, 2015 at 10:35 PM, Daniel Thompson
<daniel.thompson-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:

> Add support for STMicroelectronics STM32 random number generator.
>
> The config value defaults to N, reflecting the fact that STM32 is a
> very low resource microcontroller platform and unlikely to be targeted
> by any "grown up" defconfigs.
>
> Signed-off-by: Daniel Thompson <daniel.thompson-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

Incidentally both you and Lee Jones submitted similar RNG drivers from
the same company (ST) recent weeks:

Lee's ST thing:
http://marc.info/?l=linux-crypto-vger&m=144249760524971&w=2

Daniel's ST thing:
http://marc.info/?l=linux-crypto-vger&m=144390463810134&w=2

And we also have from old ST:
drivers/char/hw_random/nomadik-rng.c

1. Are these similar IPs that could be unified in a driver, just different
offsets in memory?

2. Could you at least cross-review each others drivers because both
tight loops to read bytes seem to contain similar semantics.

3. I took out the datasheet for Nomadik STn8820 and it seems that
the hardware is very similar to what this driver is trying to drive.
CR, SR and DR are in the same place, can you check if you also even
have the PrimeCell magic in the words at offset 0xfe0 thru 0xffc?

In any case it seems likely that this driver should supercede and replace
drivers/char/hw_random/nomadik-rng.c
still using the PrimeCell bus, and if it doesn't have the PrimeCell
IDs in hardware, this can be specified in the device tree using
arm,primecell-periphid = <0x000805e1>; in the node if need be.
The in-tree driver is dangerously simple and assume too much IMO.

Now the rest:

> +       /* enable random number generation */
> +       clk_enable(priv->clk);
> +       cr = readl(priv->base + RNG_CR);
> +       writel(cr | RNG_CR_RNGEN, priv->base + RNG_CR);

The Nomadik datasheet says this works the inverse way: setting
bit 2 to 1 *disables* the RNG. Can you double-check this?

The Nomadik version also has a TSTCLK bit 3, that should
always be set and loop-back checked in SR bit 1 to see that the block
is properly clocked. (Read data will hang on an AHB stall if it's
unclocked) Is this missing from STM32?

> + sr = readl(priv->base + RNG_SR);

I strongly recommend that you use readl_relaxed() for this and
all other reads on the hotpath, the Nomadik uses __raw_readl()
but that is just for the same reasons that readl_relaxed() should
be used: we just wanna read, not clean buffers etc.

> + /* Has h/ware error dection been triggered? */
> + if (WARN_ON(sr & (RNG_SR_SEIS | RNG_SR_CEIS)))
> +     break;
> +
> + /* No data ready... */
> + if (!sr)
> +     break;

This assumes that only bits 6,5 and 0 are ever used in this hardware.
Are you sure? On Nomadik DRDY bit 0 is the same, bit 1
is the clock test bit mentioned above, bit 2 is FAULT set if an invalid
bit sequence is detected and should definately be checked if
the HW supports it. Please mask explicitly for DRDY at least.

The bit layout gives at hand that this is indeed a derived IP block,
I wonder what bits 3 & 4 may be used for in some or all
revisions?

Then this construct:

> +static int stm32_rng_read(struct hwrng *rng, void *data, size_t max, bool wait)
> +{
(...)
> + /* enable random number generation */
> + clk_enable(priv->clk);
> + cr = readl(priv->base + RNG_CR);
> + writel(cr | RNG_CR_RNGEN, priv->base + RNG_CR);
(...)
> + /* disable the generator */
> + writel(cr, priv->base + RNG_CR);
> + clk_disable(priv->clk);

This is in the hotpath where megabytes of data may be read out
by consecutive reads. I think it's wise to move the clock enable/disable
and also the write to cr to enable/disable the block to runtime PM
hooks, so that you can e.g. set some hysteresis around the disablement
with pm_runtime_set_autosuspend_delay(&dev->dev, 50);
pm_runtime_use_autosuspend(&dev->dev);pm_runtime_put_autosuspend().
For a primecell check the usage in drivers/mmc/host/mmci.c
for a complex usecase or e.g. drivers/hwtracing/coresight/coresight-tpiu.c
for a simpler usecase.

For the performance hints I guess you can even test whether
what I'm saying makes sense or not by reading some megabytes
of random and timing it.

Yours,
Linus Walleij
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
