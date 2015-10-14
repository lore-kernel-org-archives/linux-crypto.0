From: Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 2/3] hwrng: stm32 - add support for STM32 HW RNG
Date: Wed, 14 Oct 2015 09:39:03 +0200
Message-ID: <CACRpkdZgHv+1w2Toj-JBk6WA+1q-wU7BCuZi2b_QWB2kq3K=Ng@mail.gmail.com>
References: <1443904519-24012-1-git-send-email-daniel.thompson@linaro.org>
	<1444638090-22886-1-git-send-email-daniel.thompson@linaro.org>
	<1444638090-22886-3-git-send-email-daniel.thompson@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Matt Mackall <mpm@selenic.com>,
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
To: Daniel Thompson <daniel.thompson@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ob0-f175.google.com ([209.85.214.175]:34575 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753121AbbJNHjE (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 14 Oct 2015 03:39:04 -0400
Received: by obbda8 with SMTP id da8so33191739obb.1
        for <linux-crypto@vger.kernel.org>; Wed, 14 Oct 2015 00:39:03 -0700 (PDT)
In-Reply-To: <1444638090-22886-3-git-send-email-daniel.thompson@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Oct 12, 2015 at 10:21 AM, Daniel Thompson
<daniel.thompson@linaro.org> wrote:

> Add support for STMicroelectronics STM32 random number generator.
>
> The config value defaults to N, reflecting the fact that STM32 is a
> very low resource microcontroller platform and unlikely to be targeted
> by any "grown up" defconfigs.
>
> Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>

This is a fine driver, love the performance boost you reported
and stand corrected on the likeness of the other Nomadik driver.
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

> +static int stm32_rng_read(struct hwrng *rng, void *data, size_t max, bool wait)

Now this read() function is so nice that I feel obliged to
go in and tidy up the Nomadik driver to be as nice.

Yours,
Linus Walleij
