From: Krzysztof Kozlowski <krzk@kernel.org>
Subject: Re: [PATCH 3/3] crypto: exynos - Reseed PRNG after generating 2^16
 random bytes
Date: Tue, 5 Dec 2017 14:55:37 +0100
Message-ID: <CAJKOXPd3jARFr=e2Pevdcg2_ePRLd7sEwyVyvdXZ3+QkOLcqdA@mail.gmail.com>
References: <CGME20171205123604eucas1p2a6a2738e3cf1f9c300e8d128362429ed@eucas1p2.samsung.com>
 <20171205123558.31087-1-l.stelmach@samsung.com> <20171205123558.31087-4-l.stelmach@samsung.com>
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
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171205123558.31087-4-l.stelmach@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Dec 5, 2017 at 1:35 PM, Łukasz Stelmach <l.stelmach@samsung.com> wrote:
> Reseed PRNG after reading 65 kB of randomness. Although this may reduce
> performance, in most casese the loss is not noticable.
s/casese/cases/
s/noticable/noticeable/

Please explain why you want to reseed after 65 kB (as opposite to
current implementation). Mention also why you are changing the time of
reseed.

>
> Signed-off-by: Łukasz Stelmach <l.stelmach@samsung.com>
> ---
>  drivers/crypto/exynos-rng.c | 18 ++++++++++++++----
>  1 file changed, 14 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/crypto/exynos-rng.c b/drivers/crypto/exynos-rng.c
> index 002e9d2a83cc..0bf07a655813 100644
> --- a/drivers/crypto/exynos-rng.c
> +++ b/drivers/crypto/exynos-rng.c
> @@ -54,12 +54,15 @@ enum exynos_prng_type {
>  };
>
>  /*
> - * Driver re-seeds itself with generated random numbers to increase
> - * the randomness.
> + * Driver re-seeds itself with generated random numbers to hinder
> + * backtracking of the original seed.
>   *
>   * Time for next re-seed in ms.
>   */
> -#define EXYNOS_RNG_RESEED_TIME         100
> +#define EXYNOS_RNG_RESEED_TIME         1000
> +#define EXYNOS_RNG_RESEED_BYTES                65536
> +
> +

Just one empty line.

>  /*
>   * In polling mode, do not wait infinitely for the engine to finish the work.
>   */
> @@ -81,6 +84,8 @@ struct exynos_rng_dev {
>         unsigned int                    seed_save_len;
>         /* Time of last seeding in jiffies */
>         unsigned long                   last_seeding;
> +       /* Bytes generated since last seeding */
> +       unsigned long                   bytes_seeding;
>  };
>
>  static struct exynos_rng_dev *exynos_rng_dev;
> @@ -125,6 +130,7 @@ static int exynos_rng_set_seed(struct exynos_rng_dev *rng,
>         }
>
>         rng->last_seeding = jiffies;
> +       rng->bytes_seeding = 0;
>
>         return 0;
>  }
> @@ -166,6 +172,8 @@ static int exynos_rng_get_random(struct exynos_rng_dev *rng,
>         memcpy_fromio(dst, rng->mem + EXYNOS_RNG_OUT_BASE, *read);
>
>         return 0;
> +
> +

No need for these lines.

Best regards,
Krzysztof
