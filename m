From: Heiner Kallweit <hkallweit1-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 3/3] hwrng: meson: add clock handling to driver
Date: Tue, 21 Feb 2017 22:53:14 +0100
Message-ID: <887d5ec7-d568-f304-1f4d-e201e3c32e12@gmail.com>
References: <daf765e2-1a60-8dea-fee0-8af6ddecdf8e@gmail.com>
 <989cf7bf-b7ea-0b41-510b-6eab403f0185@gmail.com>
 <afe93bb2-30de-233d-ed58-d77c018a6d33@baylibre.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: linux-clk-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Neil Armstrong <narmstrong-rdvid1DuHRBWk0Htik3J/w@public.gmane.org>,
        Jerome Brunet <jbrunet-rdvid1DuHRBWk0Htik3J/w@public.gmane.org>,
        Kevin Hilman <khilman-rdvid1DuHRBWk0Htik3J/w@public.gmane.org>,
        Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
        linux-amlogic-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        Stephen Boyd <sboyd-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>,
        Michael Turquette <mturquette-rdvid1DuHRBWk0Htik3J/w@public.gmane.org>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <afe93bb2-30de-233d-ed58-d77c018a6d33-rdvid1DuHRBWk0Htik3J/w@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

Am 21.02.2017 um 22:21 schrieb Neil Armstrong:
> On 02/21/2017 12:26 PM, Heiner Kallweit wrote:
>> Add handling of RNG0 clock to the driver.
>>
>> Signed-off-by: Heiner Kallweit <hkallweit1-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> ---
>> v2:
>> - consider that clock is optional
>> - use managed call to clk_disable_unprepare to ensure that
>>   cleaning up is done in the right order if driver is removed
>> ---
>>  drivers/char/hw_random/meson-rng.c | 22 ++++++++++++++++++++++
>>  1 file changed, 22 insertions(+)
>>
>> diff --git a/drivers/char/hw_random/meson-rng.c b/drivers/char/hw_random/meson-rng.c
>> index 119d6984..2e23be80 100644
>> --- a/drivers/char/hw_random/meson-rng.c
>> +++ b/drivers/char/hw_random/meson-rng.c
>> @@ -62,6 +62,7 @@
>>  #include <linux/slab.h>
>>  #include <linux/types.h>
>>  #include <linux/of.h>
>> +#include <linux/clk.h>
>>  
>>  #define RNG_DATA 0x00
>>  
>> @@ -69,6 +70,7 @@ struct meson_rng_data {
>>  	void __iomem *base;
>>  	struct platform_device *pdev;
>>  	struct hwrng rng;
>> +	struct clk *core_clk;
>>  };
>>  
>>  static int meson_rng_read(struct hwrng *rng, void *buf, size_t max, bool wait)
>> @@ -81,11 +83,17 @@ static int meson_rng_read(struct hwrng *rng, void *buf, size_t max, bool wait)
>>  	return sizeof(u32);
>>  }
>>  
>> +static void meson_rng_clk_disable(void *clk)
>> +{
>> +	clk_disable_unprepare(clk);
>> +}
>> +
>>  static int meson_rng_probe(struct platform_device *pdev)
>>  {
>>  	struct device *dev = &pdev->dev;
>>  	struct meson_rng_data *data;
>>  	struct resource *res;
>> +	int ret;
>>  
>>  	data = devm_kzalloc(dev, sizeof(*data), GFP_KERNEL);
>>  	if (!data)
>> @@ -98,6 +106,20 @@ static int meson_rng_probe(struct platform_device *pdev)
>>  	if (IS_ERR(data->base))
>>  		return PTR_ERR(data->base);
>>  
>> +	data->core_clk = devm_clk_get(dev, "core");
>> +	if (IS_ERR(data->core_clk))
>> +		data->core_clk = NULL;
>> +
>> +	if (data->core_clk) {
> 
> This "if" is useless, if core_clk is NULL, this will work also.
> 
Regarding clk_prepare_enable you're right. However we need this "if" for
the call to devm_add_action_or_reset because we can't provide a NULL
pointer as data argument.
And including clk_prepare_enable in the if clause creates no overhead
and is clearer IMHO.

>> +		ret = clk_prepare_enable(data->core_clk);
>> +		if (ret)
>> +			return ret;
>> +		ret = devm_add_action_or_reset(dev, meson_rng_clk_disable,
>> +					       data->core_clk);
>> +		if (ret)
>> +			return ret;
>> +	}
>> +
>>  	data->rng.name = pdev->name;
>>  	data->rng.read = meson_rng_read;
>>  
>>
> 
> 

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
