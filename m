From: Florian Fainelli <f.fainelli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 08/12] hwrng: bcm2835-rng: Abstract I/O accessors
Date: Fri, 3 Nov 2017 15:04:38 -0700
Message-ID: <58741f71-38f9-f81f-916e-aa14b6ea899b@gmail.com>
References: <20171102010408.27736-1-f.fainelli@gmail.com>
 <20171102010408.27736-9-f.fainelli@gmail.com> <874lqbru7i.fsf@anholt.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: Matt Mackall <mpm-VDJrAJ4Gl5ZBDgjK7y7TUQ@public.gmane.org>,
        Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
        Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
        Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>,
        Ray Jui <rjui-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>,
        Scott Branden <sbranden-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>,
        "maintainer:BROADCOM BCM281XX/BCM11XXX/BCM216XX ARM ARCHITE..."
        <bcm-kernel-feedback-list-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>,
        Stefan Wahren <stefan.wahren-eS4NqCHxEME@public.gmane.org>,
        PrasannaKumar Muralidharan <prasannatsmkumar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        Russell King <rmk+kernel-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org>,
        Krzysztof Kozlowski <krzk-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
        Harald Freudenberger <freude-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>,
        Sean Wang <sean.wang-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>,
        Martin Kaiser <martin-XxZfDwE/svGeZLLa646FqQ@public.gmane.org>,
        Steffen Trumtrar <s.trumtrar-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        "open
To: Eric Anholt <eric-WhKQ6XTQaPysTnJN9+BGXg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <874lqbru7i.fsf-WhKQ6XTQaPysTnJN9+BGXg@public.gmane.org>
Content-Language: en-US
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

On 11/03/2017 01:19 PM, Eric Anholt wrote:
> Florian Fainelli <f.fainelli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> writes:
> 
>> In preparation for allowing BCM63xx to use this driver, we abstract I/O
>> accessors such that we can easily change those later on.
>>
>> Signed-off-by: Florian Fainelli <f.fainelli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> ---
>>  drivers/char/hw_random/bcm2835-rng.c | 27 +++++++++++++++++++--------
>>  1 file changed, 19 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/char/hw_random/bcm2835-rng.c b/drivers/char/hw_random/bcm2835-rng.c
>> index 35928efb52e7..500275d55044 100644
>> --- a/drivers/char/hw_random/bcm2835-rng.c
>> +++ b/drivers/char/hw_random/bcm2835-rng.c
>> @@ -42,6 +42,17 @@ static inline struct bcm2835_rng_priv *to_rng_priv(struct hwrng *rng)
>>  	return container_of(rng, struct bcm2835_rng_priv, rng);
>>  }
>>  
>> +static inline u32 rng_readl(struct bcm2835_rng_priv *priv, u32 offset)
>> +{
>> +	return readl(priv->base + offset);
>> +}
>> +
>> +static inline void rng_writel(struct bcm2835_rng_priv *priv, u32 val,
>> +			      u32 offset)
>> +{
>> +	writel(val, priv->base + offset);
>> +}
>> +
>>  static int bcm2835_rng_read(struct hwrng *rng, void *buf, size_t max,
>>  			       bool wait)
>>  {
>> @@ -49,18 +60,18 @@ static int bcm2835_rng_read(struct hwrng *rng, void *buf, size_t max,
>>  	u32 max_words = max / sizeof(u32);
>>  	u32 num_words, count;
>>  
>> -	while ((__raw_readl(priv->base + RNG_STATUS) >> 24) == 0) {
>> +	while ((rng_readl(priv, RNG_STATUS) >> 24) == 0) {
>>  		if (!wait)
>>  			return 0;
>>  		cpu_relax();
>>  	}
> 
> What was the difference between the __raw_readl and readl that's now
> being done in the new call?  Is it important?

readl() on ARM contains a memory barrier, which has therefore stronger
ordering guarantees than __raw_readl() which does not.

In practice I don't think this makes a whole lot of difference in that
the above loop does not even have a barrier outside of it to try to have
any sort of ordering guarantee so it seems to me like this may be an
oversight.

I took the liberty to use the stronger operation here because it seems
to me like this is what is desired, or at least won't cause functional
problems, and because I am not intimately familiar with the 2835 busing
architecture. I know for a thing that the Broadcom STB and DSL busses
(named GISB and UBUS respectively) do not require such barriers since
they do not re-order transactions and are non-posted.

> 
>>  	/* set warm-up count & enable */
>> -	__raw_writel(RNG_WARMUP_COUNT, priv->base + RNG_STATUS);
>> -	__raw_writel(RNG_RBGEN, priv->base + RNG_CTRL);
>> +	rng_writel(priv, RNG_WARMUP_COUNT, RNG_STATUS);
>> +	rng_writel(priv, RNG_RBGEN, RNG_CTRL);
> 
> Similar question.

And here we definitively are not in a hot-path so the more "ordered"
variant is acceptable it seems.
-- 
Florian
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
