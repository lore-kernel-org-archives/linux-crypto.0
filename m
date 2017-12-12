From: Krzysztof Kozlowski <krzk@kernel.org>
Subject: Re: [PATCH v3 3/3] ARM: dts: exynos: Add nodes for True Random Number Generator
Date: Tue, 12 Dec 2017 11:49:22 +0100
Message-ID: <CAJKOXPdfftuniLA=N5+5NRAO9jU0wicCUVPJ0zzfd_X--KHSyg@mail.gmail.com>
References: <CGME20171212103557eucas1p202966a9335d52149ce69ef122f1758d8@eucas1p2.samsung.com>
 <20171211184913.n67q7vbv2gzknjeb@kozik-lap> <87k1xs6xo3.fsf%l.stelmach@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Cc: "Andrew F . Davis" <afd@ti.com>,
        PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kukjin Kim <kgene@kernel.org>, devicetree@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: =?UTF-8?Q?=C5=81ukasz_Stelmach?= <l.stelmach@samsung.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87k1xs6xo3.fsf%l.stelmach@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Dec 12, 2017 at 11:35 AM, Łukasz Stelmach
<l.stelmach@samsung.com> wrote:
> It was <2017-12-11 pon 19:49>, when Krzysztof Kozlowski wrote:
>> On Mon, Dec 04, 2017 at 01:53:51PM +0100, Łukasz Stelmach wrote:
>>> Add nodes for the True Random Number Generator found in Samsung Exynos
>>> 5250+ SoCs.
>>>
>>> Signed-off-by: Łukasz Stelmach <l.stelmach@samsung.com>
>>> ---
>>>  arch/arm/boot/dts/exynos5.dtsi    | 5 +++++
>>>  arch/arm/boot/dts/exynos5250.dtsi | 5 +++++
>>>  arch/arm/boot/dts/exynos5410.dtsi | 5 +++++
>>>  arch/arm/boot/dts/exynos5420.dtsi | 5 +++++
>>>  4 files changed, 20 insertions(+)
>>>
>>
>> Unfortunately the same story as with your PRNG patch - does not apply on
>> top of my next/dt (after taking PRNG). Also did not apply on v4.15-rc1 +
>> PRNG.
>>
>> Could you rebase on my next/dt?
>
> Sure. Should I send it as along with the other two patches, if there were
> no changes in them since?

It is fine to resend just this one as it will go through different tree anyway.

Best regards,
Krzysztof
