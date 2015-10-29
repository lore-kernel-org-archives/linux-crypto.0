From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: Re: [PATCH 0/3] ARM: dts: Enable Exynos RNG module
Date: Thu, 29 Oct 2015 15:24:54 +0900
Message-ID: <5631BBB6.9080204@samsung.com>
References: <1445230834-32689-1-git-send-email-k.kozlowski@samsung.com>
 <56251627.4050908@math.uni-bielefeld.de> <562581BD.3070609@samsung.com>
 <562C1B17.3080303@math.uni-bielefeld.de>
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
Return-path: <linux-clk-owner@vger.kernel.org>
In-reply-to: <562C1B17.3080303@math.uni-bielefeld.de>
Sender: linux-clk-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 25.10.2015 08:58, Tobias Jakobi wrote:
> Hello Krzysztof,
> 
> 
> Krzysztof Kozlowski wrote:
>> On 20.10.2015 01:11, Tobias Jakobi wrote:
>>> Hello Krzysztof,
>>>
>>> I can confirm that this also works on a Odroid-X2, so I guess it's safe
>>> to enable the PRNG for all Exynos4412-based Odroid devices.
>>
>> Sure, I can send a patch for that. I can test it later also on Odroid-U3.
> Thanks already!
> 
> 
> 
>>> Any chance that you might also take a look at the other hwcrypto stuff
>>> on the SoC ('samsung,exynos4210-secss' compatible)?
>>
>> What do you mean? The s5p-sss driver already supports Device Tree.
> The driver supports DT, but it doesn't really work.
> 
> I'm using the following DT entry to let the driver probe correctly:
> https://github.com/tobiasjakobi/linux-odroid/commit/82c00cddb5cbf89fad994784c28c8125beae8e13
> 
> But the crypto self-test fails on boot:
> alg: skcipher: encryption failed on test 1 for ecb-aes-s5p: ret=22
> 
> 
> Another problems is that SSS and PRNG can't be used at the same time,
> since they both use common hardware resources (I think it was IO).
> 

Thanks for explaining this. I added the issue to the long TODO list but
I don't know when I will be able to dig into this.

If anyone wants to look into this, please go ahead...

Best regards,
Krzysztof

