From: Heiko Stuebner <heiko-4mtYJXux2i+zQB+pC5nmwQ@public.gmane.org>
Subject: Re: [PATCH v3 3/4] Crypto: rockchip/crypto - add crypto driver for rk3288
Date: Thu, 12 Nov 2015 13:32:20 +0100
Message-ID: <2127222.Jhf4CFAOsX@phil>
References: <1447223759-20730-1-git-send-email-zain.wang@rock-chips.com> <1447223759-20730-4-git-send-email-zain.wang@rock-chips.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: zhengsq-TNX95d0MmH7DzftRWevZcw@public.gmane.org, hl-TNX95d0MmH7DzftRWevZcw@public.gmane.org,
	herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org,
	mturquette-rdvid1DuHRBWk0Htik3J/w@public.gmane.org, pawel.moll-5wv7dgnIgG8@public.gmane.org,
	ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org, robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org,
	galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-rockchip-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	eddie.cai-TNX95d0MmH7DzftRWevZcw@public.gmane.org
To: Zain Wang <zain.wang-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1447223759-20730-4-git-send-email-zain.wang-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

Hi Zain,

I was able to sucessfully test your crypto-driver, but have found some
improvements below that should probably get looked at:

Am Mittwoch, 11. November 2015, 14:35:58 schrieb Zain Wang:
> Crypto driver support:
>      ecb(aes) cbc(aes) ecb(des) cbc(des) ecb(des3_ede) cbc(des3_ede)
> You can alloc tags above in your case.
> 
> And other algorithms and platforms will be added later on.
> 
> Signed-off-by: Zain Wang <zain.wang-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
> ---

[...]

> diff --git a/drivers/crypto/rockchip/rk3288_crypto.c b/drivers/crypto/rockchip/rk3288_crypto.c
> new file mode 100644
> index 0000000..bb36baa
> --- /dev/null
> +++ b/drivers/crypto/rockchip/rk3288_crypto.c
> @@ -0,0 +1,392 @@

[...]

> +static irqreturn_t crypto_irq_handle(int irq, void *dev_id)

that function should probably also get a "rk_" prefix?

> +{
> +	struct rk_crypto_info *dev  = platform_get_drvdata(dev_id);
> +	u32 interrupt_status;
> +	int err = 0;
> +
> +	spin_lock(&dev->lock);
> +
> +	if (irq == dev->irq) {

I'm not sure I understand that line. Interrupt handlers are only
called for the interrupt they are registered for, which would be dev->irq
in any case, so that should always be true and therefore be unnecessary?


> +		interrupt_status = CRYPTO_READ(dev, RK_CRYPTO_INTSTS);
> +		CRYPTO_WRITE(dev, RK_CRYPTO_INTSTS, interrupt_status);
> +		if (interrupt_status & 0x0a) {
> +			dev_warn(dev->dev, "DMA Error\n");
> +			err = -EFAULT;
> +		} else if (interrupt_status & 0x05) {
> +			err = dev->update(dev);
> +		}
> +
> +		if (err)
> +			dev->complete(dev, err);
> +	}
> +	spin_unlock(&dev->lock);
> +	return IRQ_HANDLED;
> +}

[...]

> +static int rk_crypto_probe(struct platform_device *pdev)
> +{
> +	struct resource *res;
> +	struct device *dev = &pdev->dev;
> +	struct rk_crypto_info *crypto_info;
> +	int err = 0;
> +
> +	crypto_info = devm_kzalloc(&pdev->dev,
> +				   sizeof(*crypto_info), GFP_KERNEL);
> +	if (!crypto_info) {
> +		err = -ENOMEM;
> +		goto err_crypto;
> +	}
> +
> +	crypto_info->rst = devm_reset_control_get(dev, "crypto-rst");
> +	if (IS_ERR(crypto_info->rst)) {
> +		err = PTR_ERR(crypto_info->rst);
> +		goto err_crypto;
> +	}
> +
> +	reset_control_assert(crypto_info->rst);
> +	usleep_range(10, 20);
> +	reset_control_deassert(crypto_info->rst);
> +
> +	spin_lock_init(&crypto_info->lock);
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	crypto_info->reg = devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(crypto_info->reg)) {
> +		err = PTR_ERR(crypto_info->reg);
> +		goto err_ioremap;
> +	}
> +
> +	crypto_info->aclk = devm_clk_get(&pdev->dev, "aclk");
> +	if (IS_ERR(crypto_info->aclk)) {
> +		err = PTR_ERR(crypto_info->aclk);
> +		goto err_ioremap;
> +	}
> +
> +	crypto_info->hclk = devm_clk_get(&pdev->dev, "hclk");
> +	if (IS_ERR(crypto_info->hclk)) {
> +		err = PTR_ERR(crypto_info->hclk);
> +		goto err_ioremap;
> +	}
> +
> +	crypto_info->sclk = devm_clk_get(&pdev->dev, "sclk");
> +	if (IS_ERR(crypto_info->sclk)) {
> +		err = PTR_ERR(crypto_info->sclk);
> +		goto err_ioremap;
> +	}
> +
> +	crypto_info->dmaclk = devm_clk_get(&pdev->dev, "apb_pclk");
> +	if (IS_ERR(crypto_info->dmaclk)) {
> +		err = PTR_ERR(crypto_info->dmaclk);
> +		goto err_ioremap;
> +	}
> +
> +	crypto_info->irq = platform_get_irq(pdev, 0);
> +	if (crypto_info->irq < 0) {
> +		dev_warn(crypto_info->dev,
> +			 "control Interrupt is not available.\n");
> +		err = crypto_info->irq;
> +		goto err_ioremap;
> +	}
> +
> +	err = devm_request_irq(&pdev->dev, crypto_info->irq, crypto_irq_handle,
> +			       IRQF_SHARED, "rk-crypto", pdev);

you are freeing the irq manually below and in _remove too. As it stands
with putting the ip block in reset again on remove this should either loose
the devm_ or you could add a devm_action that handles the reset assert
like in [0] - registering the devm_action above where the reset is done.
That way you could really use dev_request_irq and loose the free_irq
calls here and in remove.

[0] https://lkml.org/lkml/2015/11/8/159

[...]

> +static int rk_crypto_remove(struct platform_device *pdev)
> +{
> +	struct rk_crypto_info *crypto_tmp = platform_get_drvdata(pdev);
> +
> +	rk_crypto_unregister();
> +	reset_control_assert(crypto_tmp->rst);

mainly my comment from above applies, but in any case the reset-assert
should definitly happen _after_ the tasklet is killed and the irq freed,
to make sure nothing will want to access device-registers anymore.

[devm works sequentially, so the devm_action would solve that automatically]


> +	tasklet_kill(&crypto_tmp->crypto_tasklet);
> +	free_irq(crypto_tmp->irq, crypto_tmp);
> +
> +	return 0;
> +}

[...]

> diff --git a/drivers/crypto/rockchip/rk3288_crypto.h b/drivers/crypto/rockchip/rk3288_crypto.h
> new file mode 100644
> index 0000000..b5b949a
> --- /dev/null
> +++ b/drivers/crypto/rockchip/rk3288_crypto.h
> @@ -0,0 +1,220 @@
> +#define _SBF(v, f)			((v) << (f))

you are using that macro in this header for simple value shifts like
	#define RK_CYYPTO_HASHINSEL_BLOCK_CIPHER_INPUT		_SBF(0x01, 0)

Removing that macro and doing the shift regularly without any macro, like
	#define RK_CYYPTO_HASHINSEL_BLOCK_CIPHER_INPUT		(0x01 << 0)

 would improve future readability, because now you need to look up what
the macro actually does and the _SBF macro also does not simplify anything.
Also that name is quite generic so may conflict with something else easily.

 [...]

> +#define CRYPTO_READ(dev, offset)		  \
> +		readl_relaxed(((dev)->reg + (offset)))
> +#define CRYPTO_WRITE(dev, offset, val)	  \
> +		writel_relaxed((val), ((dev)->reg + (offset)))
> +/* get register virt address */
> +#define CRYPTO_GET_REG_VIRT(dev, offset)   ((dev)->reg + (offset))

same argument as above about readability of the code. What do these
macros improve from just doing the readl and writel calls normally?


Thanks
Heiko
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
