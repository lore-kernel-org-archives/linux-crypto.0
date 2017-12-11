From: Krzysztof Kozlowski <krzk@kernel.org>
Subject: Re: [PATCH v3 3/3] ARM: dts: exynos: Add nodes for True Random
 Number Generator
Date: Mon, 11 Dec 2017 19:49:13 +0100
Message-ID: <20171211184913.n67q7vbv2gzknjeb@kozik-lap>
References: <20171204125351.26805-1-l.stelmach@samsung.com>
 <CGME20171204125416eucas1p141878ea587d807a2559c90f590eab7fb@eucas1p1.samsung.com>
 <20171204125351.26805-4-l.stelmach@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
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
To: =?utf-8?Q?=C5=81ukasz?= Stelmach <l.stelmach@samsung.com>
Return-path: <linux-samsung-soc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171204125351.26805-4-l.stelmach@samsung.com>
Sender: linux-samsung-soc-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Dec 04, 2017 at 01:53:51PM +0100, Łukasz Stelmach wrote:
> Add nodes for the True Random Number Generator found in Samsung Exynos
> 5250+ SoCs.
> 
> Signed-off-by: Łukasz Stelmach <l.stelmach@samsung.com>
> ---
>  arch/arm/boot/dts/exynos5.dtsi    | 5 +++++
>  arch/arm/boot/dts/exynos5250.dtsi | 5 +++++
>  arch/arm/boot/dts/exynos5410.dtsi | 5 +++++
>  arch/arm/boot/dts/exynos5420.dtsi | 5 +++++
>  4 files changed, 20 insertions(+)
>

Unfortunately the same story as with your PRNG patch - does not apply on
top of my next/dt (after taking PRNG). Also did not apply on v4.15-rc1 +
PRNG.

Could you rebase on my next/dt?

Best regards,
Krzysztof
