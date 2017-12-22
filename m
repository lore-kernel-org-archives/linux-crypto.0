From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH v3 2/3] hwrng: exynos - add Samsung Exynos True RNG
 driver
Date: Fri, 22 Dec 2017 09:29:38 +0100
Message-ID: <916163bb-594b-779d-700c-de9fa15239dd@samsung.com>
References: <20171204125351.26805-1-l.stelmach@samsung.com>
        <CGME20171204125415eucas1p1f94e6996f08938f686c08c00247c62ce@eucas1p1.samsung.com>
        <20171204125351.26805-3-l.stelmach@samsung.com>
        <20171222082412.GB29663@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Cc: "Andrew F . Davis" <afd@ti.com>,
        PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Matt Mackall <mpm@selenic.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Kukjin Kim <kgene@kernel.org>, devicetree@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        =?UTF-8?Q?=c5=81ukasz_Stelmach?= <l.stelmach@samsung.com>
Return-path: <linux-samsung-soc-owner@vger.kernel.org>
In-reply-to: <20171222082412.GB29663@gondor.apana.org.au>
Content-language: en-US
Sender: linux-samsung-soc-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi,

On 2017-12-22 09:24, Herbert Xu wrote:
> On Mon, Dec 04, 2017 at 01:53:50PM +0100, Łukasz Stelmach wrote:
>> Add support for True Random Number Generator found in Samsung Exynos
>> 5250+ SoCs.
>>
>> Signed-off-by: Łukasz Stelmach <l.stelmach@samsung.com>
> This doesn't build for me:
>
>    CC [M]  drivers/char/hw_random/exynos-trng.o
> ../drivers/char/hw_random/exynos-trng.c:230:1: error: \u2018exynos_rng_dt_match\u2019 undeclared here (not in a function)
> ../drivers/char/hw_random/exynos-trng.c:230:1: error: \u2018__mod_of__exynos_rng_dt_match_device_table\u2019 aliased to undefined symbol \u2018exynos_rng_dt_match\u2019
> make[2]: *** [drivers/char/hw_random/exynos-trng.o] Error 1
> make[1]: *** [_module_drivers/char/hw_random] Error 2

This looks like a missing dependency on "OF" when "COMPILE_TEST" is 
selected.

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland
