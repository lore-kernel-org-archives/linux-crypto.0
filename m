From: Krzysztof Kozlowski <krzk@kernel.org>
Subject: Re: [PATCH 1/3] dt-bindings: hwrng: Add Samsung Exynos 5250+ True RNG bindings
Date: Thu, 23 Nov 2017 17:17:00 +0100
Message-ID: <CAJKOXPcMDqTyjLfBkJPLBNRAYwDGhaS1UEZEh9KrPmxe8CC_Cw@mail.gmail.com>
References: <CGME20171123151002eucas1p207b8eb77fce5a2977a9f520e05dfe9f5@eucas1p2.samsung.com>
 <20171123150914.31462-1-l.stelmach@samsung.com> <20171123150914.31462-2-l.stelmach@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Cc: Rob Herring <robh+dt@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        devicetree@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: =?UTF-8?Q?=C5=81ukasz_Stelmach?= <l.stelmach@samsung.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171123150914.31462-2-l.stelmach@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Nov 23, 2017 at 4:09 PM, Łukasz Stelmach <l.stelmach@samsung.com> wrote:
> Add binding documentation for the True Random Number Generator
> found on Samsung Exynos 5250+ SoCs.
>
> Signed-off-by: Łukasz Stelmach <l.stelmach@samsung.com>
> ---
>  .../devicetree/bindings/rng/samsung,exynos5250-trng.txt | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/rng/samsung,exynos5250-trng.txt

Reviewed-by: Krzysztof Kozlowski <krzk@kernel.org>

Best regards,
Krzysztof
