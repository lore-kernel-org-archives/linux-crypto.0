From: Corentin LABBE <clabbe.montjoie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v5 4/4] crypto: Add Allwinner Security
 System crypto accelerator
Date: Tue, 21 Oct 2014 18:25:38 +0200
Message-ID: <54468902.1040802@gmail.com>
References: <1413728182-13569-1-git-send-email-clabbe.montjoie@gmail.com> <1413728182-13569-5-git-send-email-clabbe.montjoie@gmail.com> <54459AA5.2030705@mleia.com>
Reply-To: linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
To: Vladimir Zapolskiy <vz-ChpfBGZJDbMAvxtiuMwx3w@public.gmane.org>, robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org,
 pawel.moll-5wv7dgnIgG8@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org,
 galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, maxime.ripard-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org,
 linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org, herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org,
 davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org,
 gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org, mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org,
 crope-X3B1VOXEql0@public.gmane.org
Return-path: <linux-sunxi+bncBD7YLCN32UNBBBUSTKRAKGQE6NPXOOA-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
In-Reply-To: <54459AA5.2030705-ChpfBGZJDbMAvxtiuMwx3w@public.gmane.org>
List-Post: <http://groups.google.com/group/linux-sunxi/post>, <mailto:linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <http://groups.google.com/support/>, <mailto:linux-sunxi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <http://groups.google.com/group/linux-sunxi
Sender: linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Subscribe: <http://groups.google.com/group/linux-sunxi/subscribe>, <mailto:linux-sunxi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+1076902468213+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <http://groups.google.com/group/linux-sunxi/subscribe>
List-Id: linux-crypto.vger.kernel.org

On 10/21/14 01:28, Vladimir Zapolskiy wrote:
> Hello LABBE,
> 
> On 19.10.2014 17:16, LABBE Corentin wrote:
>> Add support for the Security System included in Allwinner SoC A20.
>> The Security System is a hardware cryptographic accelerator that support AES/MD5/SHA1/DES/3DES/PRNG algorithms.
>>
[]
>> +
>> +	/* If we have only one SG, we can use kmap_atomic */
>> +	if (sg_next(in_sg) == NULL && sg_next(out_sg) == NULL)
>> +		return sunxi_ss_aes_poll_atomic(areq);
> 
> for clarity it might be better to move all "mutex_unlock(&ss->lock)"
> calls from sunxi_ss_aes_poll_atomic() body right to here.
> 

Ok
I have moved all mutex_unlock/writel(0, SS_CTL) at the end of function, it is cleaner now.

>> +
>> +};
>> +
>> +static int sunxi_ss_probe(struct platform_device *pdev)
>> +{
>> +	struct resource *res;
>> +	u32 v;
>> +	int err;
>> +	unsigned long cr;
>> +	const unsigned long cr_ahb = 24 * 1000 * 1000;
>> +	const unsigned long cr_mod = 150 * 1000 * 1000;
>> +
>> +	if (!pdev->dev.of_node)
>> +		return -ENODEV;
>> +
>> +	ss = devm_kzalloc(&pdev->dev, sizeof(*ss), GFP_KERNEL);
>> +	if (ss == NULL)
>> +		return -ENOMEM;
> 
> Why do you dynamically allocate memory for "struct sunxi_ss_ctx *ss"?
> Since you have a single global pointer, it makes sense to declare
> "struct sunxi_ss_ctx ss" statically instead.
> 
> And even a better solution is to remove a single global pointer.

All other crypto driver I have read use a global structure and it made things easy.
Thanks to M. Ripard that pointed to me the talitos driver that solve the global device pointer by using alg template and container_of().

But since I think there will never 2 Security System at the same time on the same SoC, I do not know if it is worth the cost to add more complexity just to remove a pointer.

> 
>> +
>> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> +	ss->base = devm_ioremap_resource(&pdev->dev, res);
>> +	if (IS_ERR(ss->base)) {
>> +		dev_err(&pdev->dev, "Cannot request MMIO\n");
>> +		return PTR_ERR(ss->base);
>> +	}
>> +
>> +	ss->ssclk = devm_clk_get(&pdev->dev, "mod");
>> +	if (IS_ERR(ss->ssclk)) {
>> +		err = PTR_ERR(ss->ssclk);
>> +		dev_err(&pdev->dev, "Cannot get SS clock err=%d\n", err);
>> +		return err;
>> +	}
>> +	dev_dbg(&pdev->dev, "clock ss acquired\n");
>> +
>> +	ss->busclk = devm_clk_get(&pdev->dev, "ahb");
>> +	if (IS_ERR(ss->busclk)) {
>> +		err = PTR_ERR(ss->busclk);
>> +		dev_err(&pdev->dev, "Cannot get AHB SS clock err=%d\n", err);
>> +		return err;
>> +	}
>> +	dev_dbg(&pdev->dev, "clock ahb_ss acquired\n");
>> +
>> +	/* Enable both clocks */
>> +	err = clk_prepare_enable(ss->busclk);
>> +	if (err != 0) {
>> +		dev_err(&pdev->dev, "Cannot prepare_enable busclk\n");
>> +		return err;
>> +	}
>> +	err = clk_prepare_enable(ss->ssclk);
>> +	if (err != 0) {
>> +		dev_err(&pdev->dev, "Cannot prepare_enable ssclk\n");
>> +		clk_disable_unprepare(ss->busclk);
> 
> goto somewhere to the end of the function?

OK

> 
>> +		return err;
>> +	}
>> +
>> +	/*
>> +	 * Check that clock have the correct rates gived in the datasheet
>> +	 * Try to set the clock to the maximum allowed
>> +	 */
>> +	err = clk_set_rate(ss->ssclk, cr_mod);
>> +	if (err != 0) {
>> +		dev_err(&pdev->dev, "Cannot set clock rate to ssclk\n");
>> +		clk_disable_unprepare(ss->ssclk);
>> +		clk_disable_unprepare(ss->busclk);
> 
> goto "error_md5"?

Ok

> 
>> +		return err;
>> +	}
>> +
>> +	cr = clk_get_rate(ss->busclk);
>> +	if (cr >= cr_ahb)
>> +		dev_dbg(&pdev->dev, "Clock bus %lu (%lu MHz) (must be >= %lu)\n",
>> +				cr, cr / 1000000, cr_ahb);
>> +	else
>> +		dev_warn(&pdev->dev, "Clock bus %lu (%lu MHz) (must be >= %lu)\n",
>> +				cr, cr / 1000000, cr_ahb);
> 
> See next comment.
> 
>> +	cr = clk_get_rate(ss->ssclk);
>> +	if (cr <= cr_mod)
>> +		if (cr < cr_mod)
>> +			dev_info(&pdev->dev, "Clock ss %lu (%lu MHz) (must be <= %lu)\n",
>> +					cr, cr / 1000000, cr_mod);
>> +		else
>> +			dev_dbg(&pdev->dev, "Clock ss %lu (%lu MHz) (must be <= %lu)\n",
>> +					cr, cr / 1000000, cr_mod);
>> +	else
>> +		dev_warn(&pdev->dev, "Clock ss is at %lu (%lu MHz) (must be <= %lu)\n",
>> +				cr, cr / 1000000, cr_mod);
> 
> The management of kernel log levels looks pretty strange. As far as I
> understand there is no error on any clock rate, I'd recommend to keep
> only one information message.
> 

If clock rate are below the recommended value, the only impact I found was bad performance.
So it explain the warn and no error. (yes the info must be warn, ...fixed)

But I will put comment for explain that.

>> +	/*
>> +	 * Datasheet named it "Die Bonding ID"
>> +	 * I expect to be a sort of Security System Revision number.
>> +	 * Since the A80 seems to have an other version of SS
>> +	 * this info could be useful
>> +	 */
>> +	writel(SS_ENABLED, ss->base + SS_CTL);
>> +	v = readl(ss->base + SS_CTL);
>> +	v >>= 16;
>> +	v &= 0x07;
>> +	dev_info(&pdev->dev, "Die ID %d\n", v);
>> +	writel(0, ss->base + SS_CTL);
>> +
>> +	ss->dev = &pdev->dev;
>> +
>> +	mutex_init(&ss->lock);
>> +	mutex_init(&ss->bufin_lock);
>> +	mutex_init(&ss->bufout_lock);
>> +
>> +	err = crypto_register_ahash(&sunxi_md5_alg);
>> +	if (err)
>> +		goto error_md5;
>> +	err = crypto_register_ahash(&sunxi_sha1_alg);
>> +	if (err)
>> +		goto error_sha1;
>> +	err = crypto_register_algs(sunxi_cipher_algs,
>> +			ARRAY_SIZE(sunxi_cipher_algs));
>> +	if (err)
>> +		goto error_ciphers;
>> +
>> +	return 0;
>> +error_ciphers:
>> +	crypto_unregister_ahash(&sunxi_sha1_alg);
>> +error_sha1:
>> +	crypto_unregister_ahash(&sunxi_md5_alg);
>> +error_md5:
>> +	clk_disable_unprepare(ss->ssclk);
>> +	clk_disable_unprepare(ss->busclk);
>> +	return err;
>> +}
>> +
>> +static int __exit sunxi_ss_remove(struct platform_device *pdev)
>> +{
>> +	if (!pdev->dev.of_node)
>> +		return 0;
> 
> Redundant check.
> 

Ok

> 
> 
> --
> With best wishes,
> Vladimir
> 

Thanks for the review
