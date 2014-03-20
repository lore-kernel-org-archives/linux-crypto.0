From: Naveen Krishna Ch <naveenkrishna.ch@gmail.com>
Subject: Re: [PATCH 0/9 v7] crypto:s5p-sss: Add DT and Exynos support
Date: Thu, 20 Mar 2014 11:43:46 +0900
Message-ID: <CAHfPSqBeO1zoVd6H-r+ZBrKmQR-t6HgcbL4rmshuX_qhjR7JQw@mail.gmail.com>
References: <1392630275-8667-1-git-send-email-ch.naveen@samsung.com> <20140225061630.GA9934@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
	linux-crypto@vger.kernel.org,
	"linux-samsung-soc@vger.kernel.org"
	<linux-samsung-soc@vger.kernel.org>, linux-kernel@vger.kernel.org,
	Vladimir Zapolskiy <vzapolskiy@gmail.com>, cpgs@samsung.com,
	davem@davemloft.net
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-samsung-soc-owner@vger.kernel.org>
In-Reply-To: <20140225061630.GA9934@gondor.apana.org.au>
Sender: linux-samsung-soc-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hello Everyone,

On 25 February 2014 15:16, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Mon, Feb 17, 2014 at 03:14:26PM +0530, Naveen Krishna Chatradhi wrote:
>> SSS module on Exynos4210, Exynos5250 and Exynos5420 SoCs has added
>> features to the one on S5PV210. However with minor changes the s5p-sss.c
>> driver can be reused to support SSS modules on Exynos4 and 5 SoCs.
>>
>> This patch set
>> 1. Adds device tree support to the s5p-sss.c driver and Documentation
>> 2. Adds code to support SSS module on Exynos4 and 5 SoCs
>> 3. Adds device tree node to Exynos5250 and Exynos5420
>> 4. Adds variant struct to handle the differences in SSS modules
>> 5. Adds clk_prepare/clk_unprepare clocks to the s5p-sss.c driver
>>
>> Note: Compatible "exynos4210-secss" should work for Exynos4412 and
>>       Exynos5260 (Exynos5260, for which ARCH code is under review)
>> I couldn't test on Exynos4412 and Exynos4210 boards, Should be able to
>> test with addition of DT node and clocks support.
>>
>> Naveen Krishna Ch (7): [crypto-2.6.git]
>>   crypto:s5p-sss: Use platform_get_irq() instead of _byname()
>>   crypto:s5p-sss: Kconfig: Let Exynos SoCs select SSS driver
>>   crypto:s5p-sss: Look for the next request in the queue
>>   crypto:s5p-sss: Add device tree support
>>   crypto:s5p-sss: Add support for SSS module on Exynos
>>   crypto:s5p-sss: validate iv before memcpy
>>   crypto:s5p-sss: Use clk_prepare/clk_unprepare
>
> FWIW these patches are fine by me.
>
> Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
>
> Thanks,
Any update on this patchset. They are already reviewed by Tomasz
and Acked by Herbert.
Anything else to be done from my side.

> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt



-- 
Shine bright,
(: Nav :)
