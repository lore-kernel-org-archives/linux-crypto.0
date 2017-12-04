From: Krzysztof Kozlowski <krzk@kernel.org>
Subject: Re: [PATCH v3 1/3] dt-bindings: hwrng: Add Samsung Exynos 5250+ True
 RNG bindings
Date: Mon, 4 Dec 2017 14:13:49 +0100
Message-ID: <CAJKOXPej1G6npvNSr9TP8DmWubtZpn6ONeNMN4Ax_RaafMiT7g@mail.gmail.com>
References: <CGME20171204125414eucas1p1233c2c8ef5b637c3a4565af875515524@eucas1p1.samsung.com>
 <20171204125351.26805-1-l.stelmach@samsung.com> <20171204125351.26805-2-l.stelmach@samsung.com>
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
Return-path: <linux-samsung-soc-owner@vger.kernel.org>
In-Reply-To: <20171204125351.26805-2-l.stelmach@samsung.com>
Sender: linux-samsung-soc-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Dec 4, 2017 at 1:53 PM, Łukasz Stelmach <l.stelmach@samsung.com> wrote:
> Add binding documentation for the True Random Number Generator
> found on Samsung Exynos 5250+ SoCs.
>
> Signed-off-by: Łukasz Stelmach <l.stelmach@samsung.com>
> ---
>  .../devicetree/bindings/rng/samsung,exynos5250-trng.txt | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/rng/samsung,exynos5250-trng.txt
>
> diff --git a/Documentation/devicetree/bindings/rng/samsung,exynos5250-trng.txt b/Documentation/devicetree/bindings/rng/samsung,exynos5250-trng.txt
> new file mode 100644
> index 000000000000..5a613a4ec780
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/rng/samsung,exynos5250-trng.txt
> @@ -0,0 +1,17 @@
> +Exynos True Random Number Generator
> +
> +Required properties:
> +
> +- compatible  : Should be "samsung,exynos5250-trng".
> +- reg         : Specifies base physical address and size of the registers map.
> +- clocks      : Phandle to clock-controller plus clock-specifier pair.
> +- clock-names : "secss" as a clock name.
> +
> +Example:
> +
> +       rng@10830600 {
> +               compatible = "samsung,exynos5250-trng";
> +               reg = <0x10830600 0x100>;
> +               clocks = <&clock CLK_SSS>;
> +               clock-names = "secss";
> +       };
> --
> 2.11.0

Mine and Rob's tags disappeared and I think you did not introduce any
major changes here, right?

Best regards,
Krzysztof
