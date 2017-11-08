From: Stefan Wahren <stefan.wahren@i2se.com>
Subject: Re: [PATCH v2 07/12] hwrng: bcm2835-rng: Manage an optional clock
Date: Wed, 8 Nov 2017 20:19:57 +0100 (CET)
Message-ID: <1065382783.63901.1510168797132@email.1und1.de>
References: <20171108004449.32730-1-f.fainelli@gmail.com>
 <20171108004449.32730-8-f.fainelli@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
 Sean Wang <sean.wang@mediatek.com>, Martin Kaiser <martin@kaiser.cx>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 Scott Branden <sbranden@broadcom.com>, Ray Jui <rjui@broadcom.com>,
 Matt Mackall <mpm@selenic.com>, Russell King <rmk+kernel@armlinux.org.uk>,
 Krzysztof Kozlowski <krzk@kernel.org>, linux-kernel@vger.kernel.org,
 Eric Anholt <eric@anholt.net>,
 Harald Freudenberger <freude@linux.vnet.ibm.com>,
 Rob Herring <robh+dt@kernel.org>, bcm-kernel-feedback-list@broadcom.com,
 linux-crypto@vger.kernel.org,
 PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>,
 Steffen Trumtrar <s.trumtrar@pengutronix.de>,
 linux-arm-kernel@lists.infradead.org, linux-rpi-kernel@lists.infradead.org
To: Florian Fainelli <f.fainelli@gmail.com>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20171108004449.32730-8-f.fainelli@gmail.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
List-Id: linux-crypto.vger.kernel.org

Hi Florian,

> Florian Fainelli <f.fainelli@gmail.com> hat am 8. November 2017 um 01:44 geschrieben:
> 
> 
> One of the last steps before bcm63xx-rng can be eliminated is to manage
> a clock during hwrng::init and hwrng::cleanup, so fetch it in the probe
> function, and manage it during these two steps when valid.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
>  drivers/char/hw_random/bcm2835-rng.c | 17 ++++++++++++++++-
>  1 file changed, 16 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/char/hw_random/bcm2835-rng.c b/drivers/char/hw_random/bcm2835-rng.c
> index ed20e0b6b7ae..99b56fd5482c 100644
> --- a/drivers/char/hw_random/bcm2835-rng.c
> +++ b/drivers/char/hw_random/bcm2835-rng.c
> @@ -15,6 +15,7 @@
>  #include <linux/of_platform.h>
>  #include <linux/platform_device.h>
>  #include <linux/printk.h>
> +#include <linux/clk.h>
>  
>  #define RNG_CTRL	0x0
>  #define RNG_STATUS	0x4
> @@ -33,6 +34,7 @@ struct bcm2835_rng_priv {
>  	struct hwrng rng;
>  	void __iomem *base;
>  	bool mask_interrupts;
> +	struct clk *clk;
>  };
>  
>  static inline struct bcm2835_rng_priv *to_rng_priv(struct hwrng *rng)
> @@ -66,8 +68,15 @@ static int bcm2835_rng_read(struct hwrng *rng, void *buf, size_t max,
>  static int bcm2835_rng_init(struct hwrng *rng)
>  {
>  	struct bcm2835_rng_priv *priv = to_rng_priv(rng);
> +	int ret = 0;
>  	u32 val;
>  
> +	if (!IS_ERR(priv->clk)) {
> +		ret = clk_prepare_enable(priv->clk);
> +		if (ret)
> +			return ret;
> +	}
> +

the clocks are optional to the binding, but not for the proper function of all RNG. So shouldn't we catch the case that we cannot get the clock during probe, but the clock is required for a specific SoC?

>  	if (priv->mask_interrupts) {
>  		/* mask the interrupt */
>  		val = readl(priv->base + RNG_INT_MASK);
> @@ -79,7 +88,7 @@ static int bcm2835_rng_init(struct hwrng *rng)
>  	__raw_writel(RNG_WARMUP_COUNT, priv->base + RNG_STATUS);
>  	__raw_writel(RNG_RBGEN, priv->base + RNG_CTRL);
>  
> -	return 0;
> +	return ret;
>  }
>  
>  static void bcm2835_rng_cleanup(struct hwrng *rng)
> @@ -88,6 +97,9 @@ static void bcm2835_rng_cleanup(struct hwrng *rng)
>  
>  	/* disable rng hardware */
>  	__raw_writel(0, priv->base + RNG_CTRL);
> +
> +	if (!IS_ERR(priv->clk))
> +		clk_disable_unprepare(priv->clk);
>  }
>  
>  struct bcm2835_rng_of_data {
> @@ -130,6 +142,9 @@ static int bcm2835_rng_probe(struct platform_device *pdev)
>  		return PTR_ERR(priv->base);
>  	}
>  
> +	/* Clock is optional on most platforms */
> +	priv->clk = devm_clk_get(dev, NULL);
> +

At least EPROBE_DEFER should be handled here:

if (IS_ERR(priv->clk) && PTR_ERR(priv->clk) == -EPROBE_DEFER)
	return -EPROBE_DEFER;

Regards
Stefan
