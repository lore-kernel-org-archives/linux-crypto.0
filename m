From: Krzysztof Kozlowski <krzk@kernel.org>
Subject: Re: [PATCH v2 1/4] crypto: exynos - Support Exynos5250+ SoCs
Date: Mon, 11 Dec 2017 15:36:35 +0100
Message-ID: <CAJKOXPf68VT+cw7U6gFUC3WEB=pfQnixkyEL2+H_Rv==6iQrMA@mail.gmail.com>
References: <CGME20171211140636eucas1p26abbf1220ed98fc86ecbd2cd1a9b99c7@eucas1p2.samsung.com>
 <20171211140623.7673-1-l.stelmach@samsung.com> <20171211140623.7673-2-l.stelmach@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Cc: robh+dt@kernel.org, Stephan Mueller <smueller@chronox.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Kukjin Kim <kgene@kernel.org>, linux-crypto@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: =?UTF-8?Q?=C5=81ukasz_Stelmach?= <l.stelmach@samsung.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752699AbdLKOgi (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 11 Dec 2017 09:36:38 -0500
In-Reply-To: <20171211140623.7673-2-l.stelmach@samsung.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Dec 11, 2017 at 3:06 PM, Łukasz Stelmach <l.stelmach@samsung.com> wrote:
> Cc: Marek Szyprowski <m.szyprowski@samsung.com>, Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
>
> Add support for PRNG in Exynos5250+ SoCs.
>
> Signed-off-by: Łukasz Stelmach <l.stelmach@samsung.com>
> ---
>  .../bindings/crypto/samsung,exynos-rng4.txt        |  4 ++-
>  drivers/crypto/exynos-rng.c                        | 32 ++++++++++++++++++++--
>  2 files changed, 33 insertions(+), 3 deletions(-)
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
> index ed6ba796ad71..2f554b82f49f 100644
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
> +#define EXYNOS_RNG_GEN_PRNG            BIT(1)
> +
>  #define EXYNOS_RNG_SEED_BASE           0x140
>  #define EXYNOS_RNG_SEED(n)             (EXYNOS_RNG_SEED_BASE + (n * 0x4))
>  #define EXYNOS_RNG_OUT_BASE            0x160
> @@ -43,6 +48,12 @@
>  #define EXYNOS_RNG_SEED_REGS           5
>  #define EXYNOS_RNG_SEED_SIZE           (EXYNOS_RNG_SEED_REGS * 4)
>
> +enum exynos_prng_type {
> +       EXYNOS_PRNG_UNKNOWN = 0,
> +       EXYNOS_PRNG_EXYNOS4,
> +       EXYNOS_PRNG_EXYNOS5,
> +};
> +
>  /*
>   * Driver re-seeds itself with generated random numbers to increase
>   * the randomness.
> @@ -63,6 +74,7 @@ struct exynos_rng_ctx {
>  /* Device associated memory */
>  struct exynos_rng_dev {
>         struct device                   *dev;
> +       enum exynos_prng_type           type;
>         void __iomem                    *mem;
>         struct clk                      *clk;
>         /* Generated numbers stored for seeding during resume */
> @@ -160,8 +172,13 @@ static int exynos_rng_get_random(struct exynos_rng_dev *rng,
>  {
>         int retry = EXYNOS_RNG_WAIT_RETRIES;
>
> -       exynos_rng_writel(rng, EXYNOS_RNG_CONTROL_START,
> -                         EXYNOS_RNG_CONTROL);
> +       if (rng->type == EXYNOS_PRNG_EXYNOS4) {
> +               exynos_rng_writel(rng, EXYNOS_RNG_CONTROL_START,
> +                                 EXYNOS_RNG_CONTROL);
> +       } else if (rng->type == EXYNOS_PRNG_EXYNOS5) {
> +               exynos_rng_writel(rng, EXYNOS_RNG_GEN_PRNG,
> +                                 EXYNOS_RNG_SEED_CONF);
> +       }
>
>         while (!(exynos_rng_readl(rng,
>                         EXYNOS_RNG_STATUS) & EXYNOS_RNG_STATUS_RNG_DONE) && --retry)
> @@ -279,6 +296,13 @@ static int exynos_rng_probe(struct platform_device *pdev)
>         if (!rng)
>                 return -ENOMEM;
>
> +       rng->type = (enum exynos_prng_type)of_device_get_match_data(&pdev->dev);
> +       if (rng->type != EXYNOS_PRNG_EXYNOS4 &&
> +           rng->type != EXYNOS_PRNG_EXYNOS5) {
> +               dev_err(&pdev->dev, "Unsupported PRNG type: %d", rng->type);
> +               return -ENOTSUPP;
> +       }
> +

This cannot happen. Device will be matched only on matching compatible
thus rng->type will be always correct.

Best regards,
Krzysztof
