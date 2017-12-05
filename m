From: Krzysztof Kozlowski <krzk@kernel.org>
Subject: Re: [PATCH 1/3] crypto: exynos - Support Exynos5250+ SoCs
Date: Tue, 5 Dec 2017 14:34:20 +0100
Message-ID: <CAJKOXPf9JpBkR_z4frT-knxSUv53K=94wHoJkqD2fzVz2K6mGA@mail.gmail.com>
References: <CGME20171205123602eucas1p2d3ee1e53adc35df7c52917d43bcdebfd@eucas1p2.samsung.com>
 <20171205123558.31087-1-l.stelmach@samsung.com> <20171205123558.31087-2-l.stelmach@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Cc: robh+dt@kernel.org, Stephan Mueller <smueller@chronox.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Kukjin Kim <kgene@kernel.org>, linux-crypto@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        =?UTF-8?B?QmFydMWCb21pZWogxbtvxYJuaWVya2lld2ljeg==?=
        <b.zolnierkie@samsung.com>
To: =?UTF-8?Q?=C5=81ukasz_Stelmach?= <l.stelmach@samsung.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:40396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752499AbdLENeX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 5 Dec 2017 08:34:23 -0500
In-Reply-To: <20171205123558.31087-2-l.stelmach@samsung.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Dec 5, 2017 at 1:35 PM, Łukasz Stelmach <l.stelmach@samsung.com> wrote:
> Add support for PRNG in Exynos5250+ SoCs.
>
> Signed-off-by: Łukasz Stelmach <l.stelmach@samsung.com>
> ---
>  .../bindings/crypto/samsung,exynos-rng4.txt        |  4 ++-
>  drivers/crypto/exynos-rng.c                        | 36 ++++++++++++++++++++--
>  2 files changed, 36 insertions(+), 4 deletions(-)
>
> diff --git a/Documentation/devicetree/bindings/crypto/samsung,exynos-rng4.txt b/Documentation/devicetree/bindings/crypto/samsung,exynos-rng4.txt
> index 4ca8dd4d7e66..a13fbdb4bd88 100644
> --- a/Documentation/devicetree/bindings/crypto/samsung,exynos-rng4.txt
> +++ b/Documentation/devicetree/bindings/crypto/samsung,exynos-rng4.txt
> @@ -2,7 +2,9 @@ Exynos Pseudo Random Number Generator
>
>  Required properties:
>
> -- compatible  : Should be "samsung,exynos4-rng".
> +- compatible  : One of:
> +                - "samsung,exynos4-rng" for Exynos4210 and Exynos4412
> +                - "samsung,exynos5250-prng" for Exynos5250+
>  - reg         : Specifies base physical address and size of the registers map.
>  - clocks      : Phandle to clock-controller plus clock-specifier pair.
>  - clock-names : "secss" as a clock name.
> diff --git a/drivers/crypto/exynos-rng.c b/drivers/crypto/exynos-rng.c
> index 451620b475a0..894ef93ef5ec 100644
> --- a/drivers/crypto/exynos-rng.c
> +++ b/drivers/crypto/exynos-rng.c
> @@ -22,12 +22,17 @@
>  #include <linux/err.h>
>  #include <linux/io.h>
>  #include <linux/module.h>
> +#include <linux/of_device.h>
>  #include <linux/platform_device.h>
>
>  #include <crypto/internal/rng.h>
>
>  #define EXYNOS_RNG_CONTROL             0x0
>  #define EXYNOS_RNG_STATUS              0x10
> +
> +#define EXYNOS_RNG_SEED_CONF           0x14
> +#define EXYNOS_RNG_GEN_PRNG            0x02

Use BIT(1) instead.

> +
>  #define EXYNOS_RNG_SEED_BASE           0x140
>  #define EXYNOS_RNG_SEED(n)             (EXYNOS_RNG_SEED_BASE + (n * 0x4))
>  #define EXYNOS_RNG_OUT_BASE            0x160
> @@ -43,6 +48,11 @@
>  #define EXYNOS_RNG_SEED_REGS           5
>  #define EXYNOS_RNG_SEED_SIZE           (EXYNOS_RNG_SEED_REGS * 4)
>
> +enum exynos_prng_type {
> +       EXYNOS_PRNG_TYPE4 = 4,
> +       EXYNOS_PRNG_TYPE5 = 5,

That's unusual numbering and naming, so just:
enum exynos_prng_type {
      EXYNOS_PRNG_EXYNOS4,
      EXYNOS_PRNG_EXYNOS5,
};

Especially that TYPE4 and TYPE5 suggest so kind of sub-type (like
versions of some IP blocks, e.g. MFC) but it is just the family of
Exynos.

> +};
> +
>  /*
>   * Driver re-seeds itself with generated random numbers to increase
>   * the randomness.
> @@ -63,6 +73,7 @@ struct exynos_rng_ctx {
>  /* Device associated memory */
>  struct exynos_rng_dev {
>         struct device                   *dev;
> +       enum exynos_prng_type           type;
>         void __iomem                    *mem;
>         struct clk                      *clk;
>         /* Generated numbers stored for seeding during resume */
> @@ -160,8 +171,13 @@ static int exynos_rng_get_random(struct exynos_rng_dev *rng,
>  {
>         int retry = EXYNOS_RNG_WAIT_RETRIES;
>
> -       exynos_rng_writel(rng, EXYNOS_RNG_CONTROL_START,
> -                         EXYNOS_RNG_CONTROL);
> +       if (rng->type == EXYNOS_PRNG_TYPE4) {
> +               exynos_rng_writel(rng, EXYNOS_RNG_CONTROL_START,
> +                                 EXYNOS_RNG_CONTROL);
> +       } else if (rng->type == EXYNOS_PRNG_TYPE5) {
> +               exynos_rng_writel(rng, EXYNOS_RNG_GEN_PRNG,
> +                                 EXYNOS_RNG_SEED_CONF);
> +       }
>
>         while (!(exynos_rng_readl(rng,
>                         EXYNOS_RNG_STATUS) & EXYNOS_RNG_STATUS_RNG_DONE) && --retry)
> @@ -279,6 +295,13 @@ static int exynos_rng_probe(struct platform_device *pdev)
>         if (!rng)
>                 return -ENOMEM;
>
> +       rng->type = (enum exynos_prng_type)of_device_get_match_data(&pdev->dev);
> +       if (rng->type != EXYNOS_PRNG_TYPE4 &&
> +           rng->type != EXYNOS_PRNG_TYPE5) {
> +               dev_err(&pdev->dev, "Unsupported PRNG type: %d", rng->type);
> +               return -ENOTSUPP;
> +       }
> +
>         rng->dev = &pdev->dev;
>         rng->clk = devm_clk_get(&pdev->dev, "secss");
>         if (IS_ERR(rng->clk)) {
> @@ -300,7 +323,10 @@ static int exynos_rng_probe(struct platform_device *pdev)
>                 dev_err(&pdev->dev,
>                         "Couldn't register rng crypto alg: %d\n", ret);
>                 exynos_rng_dev = NULL;
> -       }
> +       } else

Missing {} around else clause. Probably checkpatch should point it.

> +               dev_info(&pdev->dev,
> +                        "Exynos Pseudo Random Number Generator (type:%d)\n",

dev_dbg, this is not that important information to affect the boot time.

Best regards,
Krzysztof

> +                        rng->type);
>
>         return ret;
>  }
> @@ -367,6 +393,10 @@ static SIMPLE_DEV_PM_OPS(exynos_rng_pm_ops, exynos_rng_suspend,
>  static const struct of_device_id exynos_rng_dt_match[] = {
>         {
>                 .compatible = "samsung,exynos4-rng",
> +               .data = (const void *)EXYNOS_PRNG_TYPE4,
> +       }, {
> +               .compatible = "samsung,exynos5250-prng",
> +               .data = (const void *)EXYNOS_PRNG_TYPE5,
>         },
>         { },
>  };
> --
> 2.11.0
>
