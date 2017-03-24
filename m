From: Krzysztof Kozlowski <krzk@kernel.org>
Subject: Re: [PATCH 1/3] crypto: hw_random - Add new Exynos RNG driver
Date: Fri, 24 Mar 2017 17:51:56 +0300
Message-ID: <20170324145156.miqmxgkhn2v7rbcu@kozik-lap>
References: <20170324142446.31129-1-krzk@kernel.org>
 <2503592.nlbQnVP8UR@positron.chronox.de>
 <20170324144348.v4hegak7dffh5awh@kozik-lap>
 <3628768.ze2UxnIp5I@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Cc: Kukjin Kim <kgene@kernel.org>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-crypto@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>
To: Stephan =?utf-8?Q?M=C3=BCller?= <smueller@chronox.de>
Return-path: <linux-samsung-soc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3628768.ze2UxnIp5I@tauon.atsec.com>
Sender: linux-samsung-soc-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Mar 24, 2017 at 03:46:44PM +0100, Stephan Müller wrote:
> Am Freitag, 24. März 2017, 15:43:48 CET schrieb Krzysztof Kozlowski:
> 
> Hi Krzysztof,
> 
> > On Fri, Mar 24, 2017 at 03:37:59PM +0100, Stephan Müller wrote:
> > > Am Freitag, 24. März 2017, 15:24:44 CET schrieb Krzysztof Kozlowski:
> > > 
> > > Hi Krzysztof,
> > > 
> > > > +
> > > > +static int exynos_rng_set_seed(struct exynos_rng_dev *rng,
> > > > +			       const u8 *seed, unsigned int slen)
> > > > +{
> > > > +	int ret, i;
> > > > +	u32 val;
> > > > +
> > > > +	dev_dbg(rng->dev, "Seeding with %u bytes\n", slen);
> > > > +
> > > > +	ret = clk_prepare_enable(rng->clk);
> > > > +	if (ret)
> > > > +		return ret;
> > > > +
> > > > +	if (slen < EXYNOS_RNG_SEED_SIZE) {
> > > > +		dev_warn(rng->dev, "Seed too short (only %u bytes)\n", slen);
> > > > +		ret = -EINVAL;
> > > > +		goto out;
> > > > +	}
> > > > +
> > > > +	for (i = 0 ; i < EXYNOS_RNG_SEED_REGS ; i++) {
> > > > +		val = seed[i * 4] << 24;
> > > > +		val |= seed[i * 4 + 1] << 16;
> > > > +		val |= seed[i * 4 + 2] << 8;
> > > > +		val |= seed[i * 4 + 3] << 0;
> > > > +
> > > > +		exynos_rng_writel(rng, val, EXYNOS_RNG_SEED(i));
> > > > +	}
> > > > +
> > > > +	val = exynos_rng_readl(rng, EXYNOS_RNG_STATUS);
> > > > +	if (!(val & EXYNOS_RNG_STATUS_SEED_SETTING_DONE)) {
> > > > +		dev_warn(rng->dev, "Seed setting not finished\n");
> > > > +		ret = -EIO;
> > > > +		goto out;
> > > > +	}
> > > > +
> > > > +	ret = 0;
> > > > +	/* Save seed for suspend */
> > > > +	memcpy(rng->seed_save, seed, slen);
> > > 
> > > Is this really necessary? If you need to save some seed, shouldn't that be
> > > an output of the DRNG and not the real seed?
> > 
> > When suspended to RAM device will loose the contents of registers
> > (including SEED registers) so it has to be initialized with something on
> > resume.
> > 
> > The seed registers are write-only so I cannot read them and store
> > contents just before suspend.
> > 
> > I understand that real seed should not be stored... but then if I am not
> > able to re-seed it with same values, I will loose the continuous and
> > reproducible pseudo-random generation after suspend. Aren't this
> > expected out of PRNG?
> 
> An RNG has to be stateless from the perspective of the caller -- this is the 
> core implication of entropy.
> 
> Then, if you add the initial seed after the RNG lost its state implies that 
> the same sequence of random numbers starts again. I.e. where is the 
> randomness?

Ahhh, yes, you are right. The device would not continue on its random
generation because all state is lost anyway.

I'll use the generated random numbers.

> > > Besides, how do you know that slen is not larger than
> > > EXYNOS_RNG_SEED_SIZE?
> > 
> > Right, there is a overflow here. It should be sizeof(rng->seed_save);
> 
> shouldn't it be min(rng->seed_save, slen)?

Now it is irrelevant but anyway I am not allowing the seed to be less
then EXYNOS_RNG_SEED_SIZE (== sizeof(rng->seed_save)). The device
expects all five channels (registers) to be seeded.

Best regards,
Krzysztof
