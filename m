From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH v3 1/3] crypto: hw_random - Add new Exynos RNG driver
Date: Sun, 26 Mar 2017 19:11:28 +0200
Message-ID: <2736911.EcZSki4vB1@positron.chronox.de>
References: <20170325162654.3827-1-krzk@kernel.org> <20170325162654.3827-2-krzk@kernel.org>
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
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:58566 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751455AbdCZRLe (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 26 Mar 2017 13:11:34 -0400
In-Reply-To: <20170325162654.3827-2-krzk@kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Samstag, 25. März 2017, 17:26:52 CEST schrieb Krzysztof Kozlowski:

Hi Krzysztof,

> +static int exynos_rng_set_seed(struct exynos_rng_dev *rng,
> +			       const u8 *seed, unsigned int slen)
> +{
> +	u32 val;
> +	int i;
> +
> +	dev_dbg(rng->dev, "Seeding with %u bytes\n", slen);
> +
> +	if (slen < EXYNOS_RNG_SEED_SIZE) {
> +		dev_warn(rng->dev, "Seed too short (only %u bytes)\n", slen);
> +		return -EINVAL;
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

Would it make sense to add another outer loop here to allow all of slen to be 
injected into the DRNG? Note, in some cases, a user wants to add more seed 
into the DRNG than the actual seed size. In this case, the DRNG acts as a 
compression operation of entropy. This is used when the entropy-to-data ratio 
is not 1:1. In a lot of cases, users have a seed which has less entropy in 
bits per data bit.

Ciao
Stephan
