From: Stefan Wahren <stefan.wahren@i2se.com>
Subject: Re: [PATCH 07/12] hwrng: bcm2835-rng: Manage an optional clock
Date: Sat, 4 Nov 2017 14:50:54 +0100 (CET)
Message-ID: <944505791.223880.1509803454887@email.1und1.de>
References: <20171102010408.27736-1-f.fainelli@gmail.com>
 <20171102010408.27736-8-f.fainelli@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Mark Rutland <mark.rutland@arm.com>,
 "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS"
 <devicetree@vger.kernel.org>, Sean Wang <sean.wang@mediatek.com>,
 Martin Kaiser <martin@kaiser.cx>, Herbert Xu <herbert@gondor.apana.org.au>,
 Scott Branden <sbranden@broadcom.com>, Ray Jui <rjui@broadcom.com>,
 Matt Mackall <mpm@selenic.com>, Russell King <rmk+kernel@armlinux.org.uk>,
 Krzysztof Kozlowski <krzk@kernel.org>, linux-kernel@vger.kernel.org,
 Eric Anholt <eric@anholt.net>,
 Harald Freudenberger <freude@linux.vnet.ibm.com>,
 Rob Herring <robh+dt@kernel.org>,
 "maintainer:BROADCOM BCM281XX/BCM11XXX/BCM216XX ARM ARCHITE..."
 <bcm-kernel-feedback-list@broadcom.com>,
 "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
 <linux-crypto@vger.kernel.org>,
 PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>,
 Steffen Trumtrar <s.trumtrar@pengutronix.de>,
 "moderated list:BROADCO
To: Florian Fainelli <f.fainelli@gmail.com>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20171102010408.27736-8-f.fainelli@gmail.com>
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

> Florian Fainelli <f.fainelli@gmail.com> hat am 2. November 2017 um 02:04 geschrieben:
> 
> 
> One of the last steps before bcm63xx-rng can be eliminated is to manage
> a clock during hwrng::init and hwrng::cleanup, so fetch it in the probe
> function, and manage it during these two steps when valid.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
>  drivers/char/hw_random/bcm2835-rng.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/drivers/char/hw_random/bcm2835-rng.c b/drivers/char/hw_random/bcm2835-rng.c
> index ed20e0b6b7ae..35928efb52e7 100644
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
> @@ -67,6 +69,11 @@ static int bcm2835_rng_init(struct hwrng *rng)
>  {
>  	struct bcm2835_rng_priv *priv = to_rng_priv(rng);
>  	u32 val;
> +	int ret;
> +
> +	ret = clk_prepare_enable(priv->clk);
> +	if (ret)
> +		return ret;
>  
>  	if (priv->mask_interrupts) {
>  		/* mask the interrupt */
> @@ -88,6 +95,8 @@ static void bcm2835_rng_cleanup(struct hwrng *rng)
>  
>  	/* disable rng hardware */
>  	__raw_writel(0, priv->base + RNG_CTRL);
> +
> +	clk_disable_unprepare(priv->clk);
>  }
>  
>  struct bcm2835_rng_of_data {
> @@ -130,6 +139,11 @@ static int bcm2835_rng_probe(struct platform_device *pdev)
>  		return PTR_ERR(priv->base);
>  	}
>  
> +	/* Clock is optional on most platforms */
> +	priv->clk = devm_clk_get(dev, NULL);
> +	if (IS_ERR(priv->clk))
> +		priv->clk = NULL;

at least in case of EPROBE_DEFERED this isn't the expected behavior. Maybe we should better trigger on non-existing clock?

> +
>  	priv->rng.name = "bcm2835-rng";
>  	priv->rng.init = bcm2835_rng_init;
>  	priv->rng.read = bcm2835_rng_read;
> -- 
> 2.9.3
>
