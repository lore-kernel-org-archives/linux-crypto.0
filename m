From: Florian Fainelli <f.fainelli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 07/12] hwrng: bcm2835-rng: Manage an optional clock
Date: Sat, 4 Nov 2017 10:59:32 -0700
Message-ID: <e12063f9-86e4-e9ce-2a7f-f85fe2ce352f@gmail.com>
References: <20171102010408.27736-1-f.fainelli@gmail.com>
 <20171102010408.27736-8-f.fainelli@gmail.com>
 <944505791.223880.1509803454887@email.1und1.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: Krzysztof Kozlowski <krzk-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ray Jui <rjui-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>,
        Eric Anholt <eric-WhKQ6XTQaPysTnJN9+BGXg@public.gmane.org>,
        Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
        Steffen Trumtrar <s.trumtrar-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org>,
        Harald Freudenberger <freude-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>,
        Russell King <rmk+kernel-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org>,
        "moderated list:BROADCOM BCM2835 ARM ARCHITECTURE"
        <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>,
        PrasannaKumar Muralidharan <prasannatsmkumar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        Scott Branden <sbranden-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
        Martin Kaiser <martin-XxZfDwE/svGeZLLa646FqQ@public.gmane.org>,
        Matt Mackall <mpm-VDJrAJ4Gl5ZBDgjK7y7TUQ@public.gmane.org>,
        "maintainer:BROADCOM BCM281XX/BCM11XXX/BCM216XX ARM ARCHITE..."
        <bcm-kernel-feedback-list-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>,
        Mar
To: Stefan Wahren <stefan.wahren-eS4NqCHxEME@public.gmane.org>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <944505791.223880.1509803454887-7tX72C7vayboQLBSYMtkGA@public.gmane.org>
Content-Language: en-US
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

Hi Stefan,

On 11/04/2017 06:50 AM, Stefan Wahren wrote:
> Hi Florian,
> 
>> Florian Fainelli <f.fainelli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> hat am 2. November 2017 um 02:04 geschrieben:
>>
>>
>> One of the last steps before bcm63xx-rng can be eliminated is to manage
>> a clock during hwrng::init and hwrng::cleanup, so fetch it in the probe
>> function, and manage it during these two steps when valid.
>>
>> Signed-off-by: Florian Fainelli <f.fainelli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> ---
>>  drivers/char/hw_random/bcm2835-rng.c | 14 ++++++++++++++
>>  1 file changed, 14 insertions(+)
>>
>> diff --git a/drivers/char/hw_random/bcm2835-rng.c b/drivers/char/hw_random/bcm2835-rng.c
>> index ed20e0b6b7ae..35928efb52e7 100644
>> --- a/drivers/char/hw_random/bcm2835-rng.c
>> +++ b/drivers/char/hw_random/bcm2835-rng.c
>> @@ -15,6 +15,7 @@
>>  #include <linux/of_platform.h>
>>  #include <linux/platform_device.h>
>>  #include <linux/printk.h>
>> +#include <linux/clk.h>
>>  
>>  #define RNG_CTRL	0x0
>>  #define RNG_STATUS	0x4
>> @@ -33,6 +34,7 @@ struct bcm2835_rng_priv {
>>  	struct hwrng rng;
>>  	void __iomem *base;
>>  	bool mask_interrupts;
>> +	struct clk *clk;
>>  };
>>  
>>  static inline struct bcm2835_rng_priv *to_rng_priv(struct hwrng *rng)
>> @@ -67,6 +69,11 @@ static int bcm2835_rng_init(struct hwrng *rng)
>>  {
>>  	struct bcm2835_rng_priv *priv = to_rng_priv(rng);
>>  	u32 val;
>> +	int ret;
>> +
>> +	ret = clk_prepare_enable(priv->clk);
>> +	if (ret)
>> +		return ret;
>>  
>>  	if (priv->mask_interrupts) {
>>  		/* mask the interrupt */
>> @@ -88,6 +95,8 @@ static void bcm2835_rng_cleanup(struct hwrng *rng)
>>  
>>  	/* disable rng hardware */
>>  	__raw_writel(0, priv->base + RNG_CTRL);
>> +
>> +	clk_disable_unprepare(priv->clk);
>>  }
>>  
>>  struct bcm2835_rng_of_data {
>> @@ -130,6 +139,11 @@ static int bcm2835_rng_probe(struct platform_device *pdev)
>>  		return PTR_ERR(priv->base);
>>  	}
>>  
>> +	/* Clock is optional on most platforms */
>> +	priv->clk = devm_clk_get(dev, NULL);
>> +	if (IS_ERR(priv->clk))
>> +		priv->clk = NULL;
> 
> at least in case of EPROBE_DEFERED this isn't the expected behavior. Maybe we should better trigger on non-existing clock?

Good point, so more like:

if (IS_ERR(priv->clk) && PTR_ERR(priv->clk) == -ENODEV)?

-- 
Florian
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
