From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: Re: [PATCH 0/3] ARM: dts: Enable Exynos RNG module
Date: Tue, 20 Oct 2015 08:50:21 +0900
Message-ID: <562581BD.3070609@samsung.com>
References: <1445230834-32689-1-git-send-email-k.kozlowski@samsung.com>
 <56251627.4050908@math.uni-bielefeld.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Heiner Kallweit <hkallweit1@gmail.com>
To: Tobias Jakobi <tjakobi@math.uni-bielefeld.de>,
	Kukjin Kim <kgene@kernel.org>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Tomasz Figa <tomasz.figa@gmail.com>,
	Michael Turquette <mturquette@baylibre.com>,
	Stephen Boyd <sboyd@codeaurora.org>,
	devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-clk@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:20129 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876AbbJSXua (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 19 Oct 2015 19:50:30 -0400
In-reply-to: <56251627.4050908@math.uni-bielefeld.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 20.10.2015 01:11, Tobias Jakobi wrote:
> Hello Krzysztof,
> 
> I can confirm that this also works on a Odroid-X2, so I guess it's safe
> to enable the PRNG for all Exynos4412-based Odroid devices.

Sure, I can send a patch for that. I can test it later also on Odroid-U3.


> 
> Any chance that you might also take a look at the other hwcrypto stuff
> on the SoC ('samsung,exynos4210-secss' compatible)?

What do you mean? The s5p-sss driver already supports Device Tree.

Best regards,
Krzysztof

> 
> With best wishes,
> Tobias
> 
> 
> Krzysztof Kozlowski wrote:
>> Hi,
>>
>>
>> The patchset adds necessary clock from Security SubSystem (SSS)
>> and enables the PRNG module of Exynos for Trats2 board.
>>
>> The first patch (clock) is required for other ones so please
>> take everything in one step.
>>
>> The actual Device Tree support (and compatible) was sent in separate
>> patch:
>>  - https://patchwork.kernel.org/patch/7432891/
>>  - http://marc.info/?l=linux-crypto-vger&m=144522952725052&w=2
>>
>> The device can be tested (after applying both patchsets) with:
>> $ echo exynos > /sys/class/misc/hw_random/rng_current
>> $ dd if=/dev/hwrng of=/dev/null bs=1 count=16
>>
>>
>> Best regards,
>> Krzysztof
>>
>> Krzysztof Kozlowski (3):
>>   clk: samsung: exynos4: Add SSS gate clock
>>   ARM: dts: Add PRNG module for exynos4
>>   ARM: dts: Enable PRNG module on exynos4412-trats2
>>
>>  arch/arm/boot/dts/exynos4.dtsi          | 8 ++++++++
>>  arch/arm/boot/dts/exynos4412-trats2.dts | 4 ++++
>>  drivers/clk/samsung/clk-exynos4.c       | 1 +
>>  include/dt-bindings/clock/exynos4.h     | 1 +
>>  4 files changed, 14 insertions(+)
>>
> 
> 
