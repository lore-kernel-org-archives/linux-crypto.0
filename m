From: Krzysztof Kozlowski <krzk@kernel.org>
Subject: Re: [PATCH v3 1/3] dt-bindings: hwrng: Add Samsung Exynos 5250+ True
 RNG bindings
Date: Tue, 5 Dec 2017 11:04:27 +0100
Message-ID: <CAJKOXPdjrBX50f5mLG5k0eUPvRLeYwUZn-JEnLkjFqN-SF0D+g@mail.gmail.com>
References: <CGME20171205093028eucas1p1fb6d7b8bde6cd5e3a0bfca8ddafe8a31@eucas1p1.samsung.com>
 <CAJKOXPej1G6npvNSr9TP8DmWubtZpn6ONeNMN4Ax_RaafMiT7g@mail.gmail.com> <878tehbjyu.fsf%l.stelmach@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Cc: Rob Herring <robh+dt@kernel.org>, "Andrew F . Davis" <afd@ti.com>,
        PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kukjin Kim <kgene@kernel.org>, devicetree@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: =?UTF-8?Q?=C5=81ukasz_Stelmach?= <l.stelmach@samsung.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:49126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753179AbdLEKEb (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 5 Dec 2017 05:04:31 -0500
In-Reply-To: <878tehbjyu.fsf%l.stelmach@samsung.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Dec 5, 2017 at 10:30 AM, Łukasz Stelmach <l.stelmach@samsung.com> wrote:
> It was <2017-12-04 pon 14:13>, when Krzysztof Kozlowski wrote:
>> On Mon, Dec 4, 2017 at 1:53 PM, Łukasz Stelmach <l.stelmach@samsung.com> wrote:
>>> Add binding documentation for the True Random Number Generator
>>> found on Samsung Exynos 5250+ SoCs.
>>>
>>> Signed-off-by: Łukasz Stelmach <l.stelmach@samsung.com>
>>> ---
>>>  .../devicetree/bindings/rng/samsung,exynos5250-trng.txt | 17 +++++++++++++++++
>>>  1 file changed, 17 insertions(+)
>>>  create mode 100644 Documentation/devicetree/bindings/rng/samsung,exynos5250-trng.txt
>>>
>>> diff --git
>>> a/Documentation/devicetree/bindings/rng/samsung,exynos5250-trng.txt
>>> b/Documentation/devicetree/bindings/rng/samsung,exynos5250-trng.txt
>>> new file mode 100644
>>> index 000000000000..5a613a4ec780
>>> --- /dev/null
>>> +++ b/Documentation/devicetree/bindings/rng/samsung,exynos5250-trng.txt
>>> @@ -0,0 +1,17 @@
>>> +Exynos True Random Number Generator
>>> +
>>> +Required properties:
>>> +
>>> +- compatible  : Should be "samsung,exynos5250-trng".
>>> +- reg         : Specifies base physical address and size of the registers map.
>>> +- clocks      : Phandle to clock-controller plus clock-specifier pair.
>>> +- clock-names : "secss" as a clock name.
>>> +
>>> +Example:
>>> +
>>> +       rng@10830600 {
>>> +               compatible = "samsung,exynos5250-trng";
>>> +               reg = <0x10830600 0x100>;
>>> +               clocks = <&clock CLK_SSS>;
>>> +               clock-names = "secss";
>>> +       };
>>> --
>>> 2.11.0
>>
>> Mine and Rob's tags disappeared and I think you did not introduce any
>> major changes here, right?
>
> A very experienced kernel developer adviced me to remove them.

In that case:
Reviewed-by: Krzysztof Kozlowski <krzk@kernel.org>

BR,
Krzysztof
