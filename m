From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH 3/6] crypto: jz4780-rng: Add Ingenic JZ4780 hardware PRNG driver
Date: Thu, 17 Aug 2017 20:52:49 +0200
Message-ID: <20325029.4QLNKKN8OS@tauon.chronox.de>
References: <20170817182520.20102-1-prasannatsmkumar@gmail.com> <20170817182520.20102-4-prasannatsmkumar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: herbert@gondor.apana.org.au, robh+dt@kernel.org,
        mark.rutland@arm.com, ralf@linux-mips.org, mturquette@baylibre.com,
        sboyd@codeaurora.org, davem@davemloft.net, paul@crapouillou.net,
        linux-crypto@vger.kernel.org, linux-mips@linux-mips.org
To: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:58976 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752236AbdHQSwv (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Aug 2017 14:52:51 -0400
In-Reply-To: <20170817182520.20102-4-prasannatsmkumar@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 17. August 2017, 20:25:17 CEST schrieb PrasannaKumar 
Muralidharan:

Hi PrasannaKumar,

> +
> +static int jz4780_rng_generate(struct crypto_rng *tfm,
> +			       const u8 *src, unsigned int slen,
> +			       u8 *dst, unsigned int dlen)
> +{
> +	struct jz4780_rng_ctx *ctx = crypto_rng_ctx(tfm);
> +	struct jz4780_rng *rng = ctx->rng;
> +	u32 data;
> +
> +	/*
> +	 * JZ4780 Programmers manual says the RNG should not run continuously
> +	 * for more than 1s. So enable RNG, read data and disable it.
> +	 * NOTE: No issue was observed with MIPS creator CI20 board even when
> +	 * RNG ran continuously for longer periods. This is just a precaution.
> +	 *
> +	 * A delay is required so that the current RNG data is not bit shifted
> +	 * version of previous RNG data which could happen if random data is
> +	 * read continuously from this device.
> +	 */
> +	jz4780_rng_writel(rng, 1, REG_RNG_CTRL);
> +	do {
> +		data = jz4780_rng_readl(rng, REG_RNG_DATA);
> +		memcpy((void *)dst, (void *)&data, 4);

How do you know that dst is a multiple of 4 bytes? When dlen is only 3, you 
overflow the buffer.

> +		dlen -= 4;
> +		dst += 4;
> +		udelay(20);
> +	} while (dlen >= 4);
> +
> +	if (dlen > 0) {
> +		data = jz4780_rng_readl(rng, REG_RNG_DATA);
> +		memcpy((void *)dst, (void *)&data, dlen);
> +	}
> +	jz4780_rng_writel(rng, 0, REG_RNG_CTRL);
> +
> +	return 0;
> +}

Ciao
Stephan
