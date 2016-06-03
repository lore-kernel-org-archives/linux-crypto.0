From: LABBE Corentin <clabbe.montjoie@gmail.com>
Subject: Re: [PATCH 1/3] char: hw_random: Add Amlogic Meson Hardware Random
 Generator
Date: Fri, 3 Jun 2016 11:07:58 +0200
Message-ID: <20160603090758.GA7299@Red>
References: <1464943621-18278-1-git-send-email-narmstrong@baylibre.com>
 <1464943621-18278-2-git-send-email-narmstrong@baylibre.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Matt Mackall <mpm@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-arm-kernel@lists.infradead.org,
	linux-amlogic@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: Neil Armstrong <narmstrong@baylibre.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1464943621-18278-2-git-send-email-narmstrong@baylibre.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hello

I have some minor comments below

> +config HW_RANDOM_MESON
> +	tristate "Amlogic Meson Random Number Generator support"
> +	depends on HW_RANDOM && ARCH_MESON

Perhaps you could change to:
depends on HW_RANDOM
depends on ARCH_MESON || COMPILE_TEST

> +
> +static int meson_rng_read(struct hwrng *rng, void *buf, size_t max, bool wait)
> +{
> +	struct meson_rng_data *data =
> +			container_of(rng, struct meson_rng_data, rng);
> +
> +	*(u32 *)buf = readl_relaxed(data->base + RNG_DATA);
> +
> +	return sizeof(u32);
> +}

I think you need a test for max < sizeof(u32)

Regards

LABBE Corentin
