From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [PATCH 1/3] crypto: hw_random - Add new Exynos RNG driver
Date: Fri, 24 Mar 2017 16:26:47 +0100
Message-ID: <3940941.n3qdgn1RbN@amdc3058>
References: <20170324142446.31129-1-krzk@kernel.org>
 <20170324142446.31129-2-krzk@kernel.org>
 <CGME20170324152650epcas5p1fb48677d6b5ac7210d6df438a5e70ca3@epcas5p1.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Cc: linux-arm-kernel@lists.infradead.org,
        Kukjin Kim <kgene@kernel.org>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-crypto@vger.kernel.org, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>
To: Krzysztof Kozlowski <krzk@kernel.org>
Return-path: <linux-samsung-soc-owner@vger.kernel.org>
In-reply-to: <20170324142446.31129-2-krzk@kernel.org>
Sender: linux-samsung-soc-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


Hi,

Firstly, thanks for working on this.

The patch looks fine overall for me, some review comments below.

On Friday, March 24, 2017 05:24:44 PM Krzysztof Kozlowski wrote:
> Replace existing hw_ranndom/exynos-rng driver with a new, reworked one.
> This is a driver for pseudo random number generator block which on
> Exynos4 chipsets must be seeded with some value.  On newer Exynos5420
> chipsets it might seed itself from true random number generator block
> but this is not implemented yet.
> 
> New driver is a complete rework to use the crypto ALGAPI instead of
> hw_random API.  Rationale for the change:
> 1. hw_random interface is for true RNG devices.
> 2. The old driver was seeding itself with jiffies which is not a
>    reliable source for randomness.
> 3. Device generates five random numbers in each pass but old driver was
>    returning only one thus its performance was reduced.
> 
> Compatibility with DeviceTree bindings is preserved.
> 
> New driver does not use runtime power management but manually enables
> and disables the clock when needed.  This is preferred approach because
> using runtime PM just to toggle clock is huge overhead.  Another

I'm not entirely convinced that the new approach is better.

With the old approach exynos_rng_generate() can be called more
than once before PM autosuspend kicks in and thus clk_prepare_enable()/
clk_disable()_unprepare() operations will be done only once. This
would give better performance on the "burst" operations.

[ The above assumes that clock operations are more costly than
  going through PM core to check the current device state. ]

> +static int exynos_rng_get_random(struct exynos_rng_dev *rng,
> +				 u8 *dst, unsigned int dlen,
> +				 unsigned int *read)
> +{
> +	int retry = 100;

I know that this is copied verbatim from the old driver but please
use define for the maximum number of retries.

> +static int exynos_rng_probe(struct platform_device *pdev)
> +{
> +	struct exynos_rng_dev *rng;
> +	struct resource *res;
> +	int ret;
> +
> +	if (exynos_rng_dev)
> +		return -EEXIST;

How this condition could ever happen? 

The probe function will never be called twice.

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics
