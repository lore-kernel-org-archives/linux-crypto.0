From: Daniel Thompson <daniel.thompson@linaro.org>
Subject: Re: [PATCH 2/3] hwrng: stm32 - add support for STM32 HW RNG
Date: Sun, 11 Oct 2015 20:24:08 +0100
Message-ID: <CAMTL27EoZRFBk+A5TA-knpmRoaqfyDD=L=+yqEXYX=ntR46xkw@mail.gmail.com>
References: <1443904519-24012-1-git-send-email-daniel.thompson@linaro.org>
	<1443904519-24012-3-git-send-email-daniel.thompson@linaro.org>
	<CACRpkdaCBUnFMYMSdjF4bHwQH3zxu2ou7b54E4FzgH9UbNQEHw@mail.gmail.com>
	<CAMTL27G9j8tR4WKQgj6HbVCTd-5Xx0HYs40Rij91GgT4D8PevA@mail.gmail.com>
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
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAMTL27G9j8tR4WKQgj6HbVCTd-5Xx0HYs40Rij91GgT4D8PevA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 5 October 2015 at 10:22, Daniel Thompson <daniel.thompson@linaro.org> wrote:
> On 4 October 2015 at 11:32, Linus Walleij <linus.walleij@linaro.org> wrote:
>> On Sat, Oct 3, 2015 at 10:35 PM, Daniel Thompson
>> <daniel.thompson@linaro.org> wrote:
>> Then this construct:
>>
>>> +static int stm32_rng_read(struct hwrng *rng, void *data, size_t max, bool wait)
>>> +{
>> (...)
>>> + /* enable random number generation */
>>> + clk_enable(priv->clk);
>>> + cr = readl(priv->base + RNG_CR);
>>> + writel(cr | RNG_CR_RNGEN, priv->base + RNG_CR);
>> (...)
>>> + /* disable the generator */
>>> + writel(cr, priv->base + RNG_CR);
>>> + clk_disable(priv->clk);
>>
>> This is in the hotpath where megabytes of data may be read out
>> by consecutive reads. I think it's wise to move the clock enable/disable
>> and also the write to cr to enable/disable the block to runtime PM
>> hooks, so that you can e.g. set some hysteresis around the disablement
>> with pm_runtime_set_autosuspend_delay(&dev->dev, 50);
>> pm_runtime_use_autosuspend(&dev->dev);pm_runtime_put_autosuspend().
>> For a primecell check the usage in drivers/mmc/host/mmci.c
>> for a complex usecase or e.g. drivers/hwtracing/coresight/coresight-tpiu.c
>> for a simpler usecase.
>>
>> For the performance hints I guess you can even test whether
>> what I'm saying makes sense or not by reading some megabytes
>> of random and timing it.
>
> I'll have to benchmark this. clk_enable/disable have pretty simple
> implementations on STM32 so there might not be much in it.

Well... I was extremely wrong about that!

Switching the driver over to autosuspend yielded a very significant
performance boost: ~1.1MiB/s to ~1.5MiB/s .

Very pleased with that!


Daniel.
