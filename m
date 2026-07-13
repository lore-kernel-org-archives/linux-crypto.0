Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C3BA2E88BD;
	Mon, 13 Jul 2026 02:17:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783909049; cv=none; b=mq3kNMr5P28g0givzNZovWocHITT+B3LIhHej3mZwXwNGPMAqftNcPEoEkaeo9VoqPwoGDBBS/EbYZNJczLK9YMGgBlZqvN98m58ATRQVvySrkD2Fb7bDH8aI4Xapc+o8vc/jtu2BlhnW46tHdRzskBCM8WB9p0MCf7CIJNzb/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783909049; c=relaxed/simple;
	bh=Vo6qXaWIgYI3ZRUQbU2cnuu7EWkNnP5CnTfZKKKxX5U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AepDrZ2dFhQ7j/T/Vi37ngFW8GCYzXXZszlo5Bjoo28yiH8gfNf9ErwWICX0SlwX9EJBDRyBWqoCMLHz9ZojybwmMdgw6Celyyam6cnkYQWmqUuEk+Zn9x2Zf7dISQE9GXx+3qoYRrPjDeaf4gF3Cux2Spx0XdG0GNCv5Ug/rQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=ITF/MhAH; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="ITF/MhAH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=CsPnhuG7mLz7rW6biY+1V2wsrMAO4aQiJoxry/qq97Y=; 
	b=ITF/MhAHfKQsoKmbobGBmZtyLXKyyS7w/71188mMyV17Ui8w1mElfR+fN1FdRcNlDdPfPwZSter
	uEh25YHEJh3/8I3EWJV2VcZqU/5+FNJoOVZ7y2nZNsUGNZ6XsURPKBCdISsyZvLrY+4q/dAkUKVEf
	XMIg/g89nValMIkWf+PalE7HtvIrqO5bq48Vp46q69qTHetVOKU49quFKD5afYTSd9tnuO1l3EBNb
	7UL39ASx5JMJnbt4n6JSAiEeVgDSmLCD6AVWAVgrlEen4i7SA3f7zWZtNylFNMdDdQHst6JsXVFi9
	w1lspcToDKZT5BzsPpL0a0fmCJ/ZQNDOdAwA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wj6EL-0000000CxI6-3AF6;
	Mon, 13 Jul 2026 10:17:14 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 13 Jul 2026 12:17:13 +1000
Date: Mon, 13 Jul 2026 12:17:13 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "lianfeng.ouyang" <lianfeng.ouyang@starfivetech.com>
Cc: Olivia Mackall <olivia@selenic.com>, Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 2/2] hwrng: starfive: rework clk/reset teardown order
 for JHB100
Message-ID: <alRKqXXaEJBvx2Dv@gondor.apana.org.au>
References: <20260629083658.300191-1-lianfeng.ouyang@starfivetech.com>
 <20260629083658.300191-3-lianfeng.ouyang@starfivetech.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260629083658.300191-3-lianfeng.ouyang@starfivetech.com>

On Mon, Jun 29, 2026 at 04:36:58PM +0800, lianfeng.ouyang wrote:
> From: Lianfeng Ouyang <lianfeng.ouyang@starfivetech.com>
> 
> Rework the StarFive TRNG driver to address hardware-specific requirements
>   for JHB100 SoC. To avoid reset-domain crossing glitches, the driver now
>   ensures clocks are gated before asserting reset during teardown for
>   JHB100, while JH7110 retains the original reset-first sequence.
> 
> Add per-compatible match data (struct starfive_trng_data) describing the
>   clock/reset teardown order, a new "starfive,jhb100-trng" compatible, and
>   select the ordering from it.
> 
> Fix the runtime-PM get/put balancing across the init/read/reseed/cleanup
>   paths, manage PM and the clk/reset teardown via devm so all error paths
>   unwind correctly, run the SEU-triggered reseed from a workqueue instead
>   of hard IRQ, and serialise the command sequences with a mutex.
> 
> Signed-off-by: Lianfeng Ouyang <lianfeng.ouyang@starfivetech.com>
> ---
>  MAINTAINERS                          |   2 +-
>  drivers/char/hw_random/jh7110-trng.c | 312 +++++++++++++++++++++------
>  2 files changed, 245 insertions(+), 69 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index d3a6b3f6b6a0..729b20ecc697 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -25280,7 +25280,7 @@ F:	Documentation/devicetree/bindings/perf/starfive,jh8100-starlink-pmu.yaml
>  F:	drivers/perf/starfive_starlink_pmu.c
>  
>  STARFIVE TRNG DRIVER
> -M:	Jia Jie Ho <jiajie.ho@starfivetech.com>
> +M:	Lianfeng Ouyang <lianfeng.ouyang@starfivetech.com>
>  S:	Supported
>  F:	Documentation/devicetree/bindings/rng/starfive*
>  F:	drivers/char/hw_random/jh7110-trng.c
> diff --git a/drivers/char/hw_random/jh7110-trng.c b/drivers/char/hw_random/jh7110-trng.c
> index 9776f4daa044..1434dcb6efed 100644
> --- a/drivers/char/hw_random/jh7110-trng.c
> +++ b/drivers/char/hw_random/jh7110-trng.c
> @@ -92,22 +92,44 @@ enum mode {
>  	PRNG_256BIT,
>  };
>  
> +/*
> + * For JHB100, assert reset after disabling clocks to avoid
> + * reset-domain crossing (RDC) induced glitches that can affect
> + * downstream IPs.
> + */
> +enum seq_rst_clk {
> +	SEQ_RST_FIRST,
> +	SEQ_CLK_FIRST,
> +};
> +
> +struct starfive_trng_data {
> +	enum seq_rst_clk	seq_rst_clk;
> +};
> +
>  struct starfive_trng {
> -	struct device		*dev;
> -	void __iomem		*base;
> -	struct clk		*hclk;
> -	struct clk		*ahb;
> -	struct reset_control	*rst;
> -	struct hwrng		rng;
> -	struct completion	random_done;
> -	struct completion	reseed_done;
> -	u32			mode;
> -	u32			mission;
> -	u32			reseed;
> -	/* protects against concurrent write to ctrl register */
> -	spinlock_t		write_lock;
> +	struct device			*dev;
> +	void __iomem			*base;
> +	int				irq;
> +	struct clk			*hclk;
> +	struct clk			*ahb;
> +	struct reset_control		*rst;
> +	struct hwrng			rng;
> +	struct completion		random_done;
> +	struct completion		reseed_done;
> +	struct work_struct		work;
> +	const struct starfive_trng_data *data;
> +	u32				mode;
> +	u32				mission;
> +	u32				reseed;
> +	u32				cleanup;
> +	struct mutex			lock; /* protect trng cmd seq */

Doing a white-space change at the same time as a substantial change
makes things hard to review.  Please split this up or just drop the
white-space change until later.
  
>  static int starfive_trng_read(struct hwrng *rng, void *buf, size_t max, bool wait)
> @@ -247,7 +358,13 @@ static int starfive_trng_read(struct hwrng *rng, void *buf, size_t max, bool wai
>  	struct starfive_trng *trng = to_trng(rng);
>  	int ret;
>  
> -	pm_runtime_get_sync(trng->dev);
> +	ret = pm_runtime_resume_and_get(trng->dev);
> +	if (ret < 0) {
> +		dev_warn(trng->dev, "Failed to wake device for read: %d\n", ret);
> +		return ret;
> +	}
> +
> +	mutex_lock(&trng->lock);

What happens when a non-waiting read call ends up spinning here
waiting for a wait read call?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
