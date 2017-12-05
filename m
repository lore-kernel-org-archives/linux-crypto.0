From: Krzysztof Kozlowski <krzk@kernel.org>
Subject: Re: [PATCH 2/3] crypto: exynos - Improve performance of PRNG
Date: Tue, 5 Dec 2017 14:49:29 +0100
Message-ID: <CAJKOXPc3CxnSY8166vdqrBS7+eKGOO4SvnxJzM+rjqy7sOzwFA@mail.gmail.com>
References: <CGME20171205123603eucas1p177cceb022e3a5c0a9d13ca437c05b669@eucas1p1.samsung.com>
 <20171205123558.31087-1-l.stelmach@samsung.com> <20171205123558.31087-3-l.stelmach@samsung.com>
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
Received: from mail.kernel.org ([198.145.29.99]:42448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752635AbdLENtc (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 5 Dec 2017 08:49:32 -0500
In-Reply-To: <20171205123558.31087-3-l.stelmach@samsung.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Dec 5, 2017 at 1:35 PM, Łukasz Stelmach <l.stelmach@samsung.com> wrote:
> Use memcpy_fromio() instead of custom exynos_rng_copy_random() function
> to retrieve generated numbers from the registers of PRNG.
>
> Remove unnecessary invocation of cpu_relax().
>
> Signed-off-by: Łukasz Stelmach <l.stelmach@samsung.com>
> ---
>  drivers/crypto/exynos-rng.c | 36 +++++-------------------------------
>  1 file changed, 5 insertions(+), 31 deletions(-)
>
> diff --git a/drivers/crypto/exynos-rng.c b/drivers/crypto/exynos-rng.c
> index 894ef93ef5ec..002e9d2a83cc 100644
> --- a/drivers/crypto/exynos-rng.c
> +++ b/drivers/crypto/exynos-rng.c
> @@ -130,34 +130,6 @@ static int exynos_rng_set_seed(struct exynos_rng_dev *rng,
>  }
>
>  /*
> - * Read from output registers and put the data under 'dst' array,
> - * up to dlen bytes.
> - *
> - * Returns number of bytes actually stored in 'dst' (dlen
> - * or EXYNOS_RNG_SEED_SIZE).
> - */
> -static unsigned int exynos_rng_copy_random(struct exynos_rng_dev *rng,
> -                                          u8 *dst, unsigned int dlen)
> -{
> -       unsigned int cnt = 0;
> -       int i, j;
> -       u32 val;
> -
> -       for (j = 0; j < EXYNOS_RNG_SEED_REGS; j++) {
> -               val = exynos_rng_readl(rng, EXYNOS_RNG_OUT(j));
> -
> -               for (i = 0; i < 4; i++) {
> -                       dst[cnt] = val & 0xff;
> -                       val >>= 8;
> -                       if (++cnt >= dlen)
> -                               return cnt;
> -               }
> -       }
> -
> -       return cnt;
> -}
> -
> -/*
>   * Start the engine and poll for finish.  Then read from output registers
>   * filling the 'dst' buffer up to 'dlen' bytes or up to size of generated
>   * random data (EXYNOS_RNG_SEED_SIZE).
> @@ -171,6 +143,8 @@ static int exynos_rng_get_random(struct exynos_rng_dev *rng,
>  {
>         int retry = EXYNOS_RNG_WAIT_RETRIES;
>
> +       *read = min_t(size_t, dlen, EXYNOS_RNG_SEED_SIZE);
> +

Do not set *read on error path. Only on success. Although now it will
not matter but that is the expected behavior - if possible, do not
affect state outside of a block in case of error.

>         if (rng->type == EXYNOS_PRNG_TYPE4) {
>                 exynos_rng_writel(rng, EXYNOS_RNG_CONTROL_START,
>                                   EXYNOS_RNG_CONTROL);
> @@ -180,8 +154,8 @@ static int exynos_rng_get_random(struct exynos_rng_dev *rng,
>         }
>
>         while (!(exynos_rng_readl(rng,
> -                       EXYNOS_RNG_STATUS) & EXYNOS_RNG_STATUS_RNG_DONE) && --retry)
> -               cpu_relax();
> +                       EXYNOS_RNG_STATUS) & EXYNOS_RNG_STATUS_RNG_DONE) &&
> +              --retry);

It looks like unrelated change so split it into separate commit with
explanation why you are changing the common busy-loop pattern.
exynos_rng_readl() uses relaxed versions of readl() so I would expect
here cpu_relax().

Best regards,
Krzysztof
