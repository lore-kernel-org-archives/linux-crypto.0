From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH v2 1/3] crypto: hw_random - Add new Exynos RNG driver
Date: Fri, 24 Mar 2017 21:41:59 +0100
Message-ID: <4248691.8fGIDmasva@tauon.atsec.com>
References: <20170324182606.23339-1-krzk@kernel.org> <20170324182606.23339-2-krzk@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Cc: Kukjin Kim <kgene@kernel.org>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-crypto@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>
To: Krzysztof Kozlowski <krzk@kernel.org>
Return-path: <linux-samsung-soc-owner@vger.kernel.org>
In-Reply-To: <20170324182606.23339-2-krzk@kernel.org>
Sender: linux-samsung-soc-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Am Freitag, 24. März 2017, 19:26:04 CET schrieb Krzysztof Kozlowski:

Hi Krzysztof,

> +static unsigned int exynos_rng_copy_random(struct exynos_rng_dev *rng,
> +					   u8 *dst, unsigned int dlen)
> +{
> +	unsigned int cnt = 0;
> +	int i, j;
> +	u32 val;
> +
> +	for (j = 0; j < EXYNOS_RNG_SEED_REGS; j++) {
> +		val = exynos_rng_readl(rng, EXYNOS_RNG_OUT(j));
> +
> +		for (i = 0; i < 4; i++) {
> +			dst[cnt] = val & 0xff;
> +			val >>= 8;
> +			if (++cnt >= dlen)
> +				return cnt;
> +		}
> +		rng->seed_save[j] = val;

Just to clarify: is this call right? Shouldn't that be removed? Any RNG that 
is given to a caller is tainted and should not serve as seed.
> +	}
> +
> +	/*
> +	 * Engine filled all output registers, so read the remaining registers
> +	 * for storing data as future seed.
> +	 */
> +	for (; j < EXYNOS_RNG_SEED_REGS; j++)
> +		rng->seed_save[j] = exynos_rng_readl(rng, EXYNOS_RNG_OUT(j));

With this call, I guess the questioned line above could go away, right?


Ciao
Stephan
