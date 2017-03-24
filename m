From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH 1/3] crypto: hw_random - Add new Exynos RNG driver
Date: Fri, 24 Mar 2017 15:37:59 +0100
Message-ID: <2503592.nlbQnVP8UR@positron.chronox.de>
References: <20170324142446.31129-1-krzk@kernel.org> <20170324142446.31129-2-krzk@kernel.org>
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
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>
To: Krzysztof Kozlowski <krzk@kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:58304 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965353AbdCXOi2 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 24 Mar 2017 10:38:28 -0400
In-Reply-To: <20170324142446.31129-2-krzk@kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Freitag, 24. März 2017, 15:24:44 CET schrieb Krzysztof Kozlowski:

Hi Krzysztof,

> +
> +static int exynos_rng_set_seed(struct exynos_rng_dev *rng,
> +			       const u8 *seed, unsigned int slen)
> +{
> +	int ret, i;
> +	u32 val;
> +
> +	dev_dbg(rng->dev, "Seeding with %u bytes\n", slen);
> +
> +	ret = clk_prepare_enable(rng->clk);
> +	if (ret)
> +		return ret;
> +
> +	if (slen < EXYNOS_RNG_SEED_SIZE) {
> +		dev_warn(rng->dev, "Seed too short (only %u bytes)\n", slen);
> +		ret = -EINVAL;
> +		goto out;
> +	}
> +
> +	for (i = 0 ; i < EXYNOS_RNG_SEED_REGS ; i++) {
> +		val = seed[i * 4] << 24;
> +		val |= seed[i * 4 + 1] << 16;
> +		val |= seed[i * 4 + 2] << 8;
> +		val |= seed[i * 4 + 3] << 0;
> +
> +		exynos_rng_writel(rng, val, EXYNOS_RNG_SEED(i));
> +	}
> +
> +	val = exynos_rng_readl(rng, EXYNOS_RNG_STATUS);
> +	if (!(val & EXYNOS_RNG_STATUS_SEED_SETTING_DONE)) {
> +		dev_warn(rng->dev, "Seed setting not finished\n");
> +		ret = -EIO;
> +		goto out;
> +	}
> +
> +	ret = 0;
> +	/* Save seed for suspend */
> +	memcpy(rng->seed_save, seed, slen);

Is this really necessary? If you need to save some seed, shouldn't that be an 
output of the DRNG and not the real seed?

Besides, how do you know that slen is not larger than EXYNOS_RNG_SEED_SIZE?


Ciao
Stephan
