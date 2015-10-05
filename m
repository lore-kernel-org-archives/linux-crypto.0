From: Daniel Thompson <daniel.thompson@linaro.org>
Subject: Re: [PATCH 2/3] hwrng: stm32 - add support for STM32 HW RNG
Date: Mon, 5 Oct 2015 10:22:30 +0100
Message-ID: <CAMTL27G9j8tR4WKQgj6HbVCTd-5Xx0HYs40Rij91GgT4D8PevA@mail.gmail.com>
References: <1443904519-24012-1-git-send-email-daniel.thompson@linaro.org>
	<1443904519-24012-3-git-send-email-daniel.thompson@linaro.org>
	<CACRpkdaCBUnFMYMSdjF4bHwQH3zxu2ou7b54E4FzgH9UbNQEHw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Lee Jones <lee.jones@linaro.org>, Matt Mackall <mpm@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Patch Tracking <patches@linaro.org>,
	Linaro Kernel Mailman List <linaro-kernel@lists.linaro.org>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Rob Herring <robh+dt@kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>
To: Linus Walleij <linus.walleij@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ig0-f171.google.com ([209.85.213.171]:34166 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752053AbbJEJWb (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 5 Oct 2015 05:22:31 -0400
Received: by igcpb10 with SMTP id pb10so58257015igc.1
        for <linux-crypto@vger.kernel.org>; Mon, 05 Oct 2015 02:22:31 -0700 (PDT)
In-Reply-To: <CACRpkdaCBUnFMYMSdjF4bHwQH3zxu2ou7b54E4FzgH9UbNQEHw@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 4 October 2015 at 11:32, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Sat, Oct 3, 2015 at 10:35 PM, Daniel Thompson
> <daniel.thompson@linaro.org> wrote:
>
>> Add support for STMicroelectronics STM32 random number generator.
>>
>> The config value defaults to N, reflecting the fact that STM32 is a
>> very low resource microcontroller platform and unlikely to be targeted
>> by any "grown up" defconfigs.
>>
>> Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
>
> Incidentally both you and Lee Jones submitted similar RNG drivers from
> the same company (ST) recent weeks:
>
> Lee's ST thing:
> http://marc.info/?l=linux-crypto-vger&m=144249760524971&w=2
>
> Daniel's ST thing:
> http://marc.info/?l=linux-crypto-vger&m=144390463810134&w=2
>
> And we also have from old ST:
> drivers/char/hw_random/nomadik-rng.c
>
> 1. Are these similar IPs that could be unified in a driver, just different
> offsets in memory?

I don't think so. I can't see any commonality of register structure or
data transfer approach (neither PIO nor DMA).

There have been exceptions but, in general, STM32 microcontrollers
seem to have very little in common with ST SoC/ASIC devices except for
the manufacturers id.


> 2. Could you at least cross-review each others drivers because both
> tight loops to read bytes seem to contain similar semantics.

I'll take a look although, as above, I suspect any similarities in
structure will be based on the problem domain rather than shared
heritage in the hardware design.


> 3. I took out the datasheet for Nomadik STn8820 and it seems that
> the hardware is very similar to what this driver is trying to drive.
> CR, SR and DR are in the same place, can you check if you also even
> have the PrimeCell magic in the words at offset 0xfe0 thru 0xffc?

The register window for the STM32 RNG is only 0x400 (and I'll fix the
DT for v2 ;-) ) so the STM32 version isn't primecell-like.


> In any case it seems likely that this driver should supercede and replace
> drivers/char/hw_random/nomadik-rng.c
> still using the PrimeCell bus, and if it doesn't have the PrimeCell
> IDs in hardware, this can be specified in the device tree using
> arm,primecell-periphid = <0x000805e1>; in the node if need be.
> The in-tree driver is dangerously simple and assume too much IMO.

Not sure about this, but I'll take a closer look. There is a certain
family resemblance in the register set but there are significant
differences in data transfer between the Nomadik and STM32 hardware.


>
> Now the rest:
>
>> +       /* enable random number generation */
>> +       clk_enable(priv->clk);
>> +       cr = readl(priv->base + RNG_CR);
>> +       writel(cr | RNG_CR_RNGEN, priv->base + RNG_CR);
>
> The Nomadik datasheet says this works the inverse way: setting
> bit 2 to 1 *disables* the RNG. Can you double-check this?

Nomadik driver doesn't seem to have to set anything to enable the RNG,
so assuming the CR is resets to zero on nomadik I guess the bit
meaning is inverted on the two platforms.


> The Nomadik version also has a TSTCLK bit 3, that should
> always be set and loop-back checked in SR bit 1 to see that the block
> is properly clocked. (Read data will hang on an AHB stall if it's
> unclocked) Is this missing from STM32?

Bit 3 is reserved on STM32. I don't think the STM32 has logic to hang
the bus if the cell doesn't have data ready (it's not mentioned in the
datasheet but I've not verified what happens if we read when things
are not ready).


>> + sr = readl(priv->base + RNG_SR);
>
> I strongly recommend that you use readl_relaxed() for this and
> all other reads on the hotpath, the Nomadik uses __raw_readl()
> but that is just for the same reasons that readl_relaxed() should
> be used: we just wanna read, not clean buffers etc.

I'll fix this. Choosing writel/readl was deliberate (STM32 is a niche
platform so I *really* wanted COMPILE_TEST to work) but this reasons
is no longer relevant.


>> + /* Has h/ware error dection been triggered? */
>> + if (WARN_ON(sr & (RNG_SR_SEIS | RNG_SR_CEIS)))
>> +     break;
>> +
>> + /* No data ready... */
>> + if (!sr)
>> +     break;
>
> This assumes that only bits 6,5 and 0 are ever used in this hardware.
> Are you sure? On Nomadik DRDY bit 0 is the same, bit 1
> is the clock test bit mentioned above, bit 2 is FAULT set if an invalid
> bit sequence is detected and should definately be checked if
> the HW supports it. Please mask explicitly for DRDY at least.

There are also bits 1 and 2 but these are non-sticky versions of bits
5 and 6 so it should work... but I agree its not very conservative.

I plan to combine both branches into a simple "if (sr != RNG_SR_DRDY)"
since any other value indicates an error condition that we should warn
about anyway.

> The bit layout gives at hand that this is indeed a derived IP block,
> I wonder what bits 3 & 4 may be used for in some or all
> revisions?
>
> Then this construct:
>
>> +static int stm32_rng_read(struct hwrng *rng, void *data, size_t max, bool wait)
>> +{
> (...)
>> + /* enable random number generation */
>> + clk_enable(priv->clk);
>> + cr = readl(priv->base + RNG_CR);
>> + writel(cr | RNG_CR_RNGEN, priv->base + RNG_CR);
> (...)
>> + /* disable the generator */
>> + writel(cr, priv->base + RNG_CR);
>> + clk_disable(priv->clk);
>
> This is in the hotpath where megabytes of data may be read out
> by consecutive reads. I think it's wise to move the clock enable/disable
> and also the write to cr to enable/disable the block to runtime PM
> hooks, so that you can e.g. set some hysteresis around the disablement
> with pm_runtime_set_autosuspend_delay(&dev->dev, 50);
> pm_runtime_use_autosuspend(&dev->dev);pm_runtime_put_autosuspend().
> For a primecell check the usage in drivers/mmc/host/mmci.c
> for a complex usecase or e.g. drivers/hwtracing/coresight/coresight-tpiu.c
> for a simpler usecase.
>
> For the performance hints I guess you can even test whether
> what I'm saying makes sense or not by reading some megabytes
> of random and timing it.

I'll have to benchmark this. clk_enable/disable have pretty simple
implementations on STM32 so there might not be much in it.

Insisting on minimal power (which I think it important in
microcontroller platforms) does hurt bandwidth more than you might
expect because the framework does not pass big userspace reads to the
underlying driver. This means the costs of clock control are spread
over 32 bytes rather than over the whole of a big read.


Daniel.
