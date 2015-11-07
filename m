From: Heiko Stuebner <heiko-4mtYJXux2i+zQB+pC5nmwQ@public.gmane.org>
Subject: Re: [PATCH v2 1/4] Crypto: Crypto driver support aes/des/des3 for rk3288
Date: Sun, 08 Nov 2015 00:19:43 +0100
Message-ID: <29530953.Mr1LQyjF1I@phil>
References: <1446772644-2352-1-git-send-email-zain.wang@rock-chips.com> <1446772644-2352-2-git-send-email-zain.wang@rock-chips.com>
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
In-Reply-To: <1446772644-2352-2-git-send-email-zain.wang-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

Hi Zain,

looks like my comment on v1 came later than your v2 submission,
so here it is again :-)

Am Freitag, 6. November 2015, 09:17:21 schrieb Zain Wang:
> The names registered are:
>     ecb(aes) cbc(aes) ecb(des) cbc(des) ecb(des3_ede) cbc(des3_ede)
> You can alloc tags above in your case.
> 
> And other algorithms and platforms will be added later on.
> 
> Signed-off-by: Zain Wang <zain.wang-TNX95d0MmH7DzftRWevZcw@public.gmane.org>
> ---
> 

[...]

> diff --git a/drivers/crypto/rockchip/rk3288_crypto.c b/drivers/crypto/rockchip/rk3288_crypto.c
> new file mode 100644
> index 0000000..c2a419b
> --- /dev/null
> +++ b/drivers/crypto/rockchip/rk3288_crypto.c

[...]

> +static int rk_crypto_probe(struct platform_device *pdev)
> +{
> +	int err = 0;
> +	struct resource *res;
> +	struct device *dev = &pdev->dev;
> +	struct crypto_info_t *crypto_info;
> +

rk3288 chromebooks use the crypto-engine to validate the boot images and
seem to leave it in a half-on state. This results in an irq pending
during probe and thus a null-pointer dereference in the irq-handler, as
it runs before the crypto-device is fully initialized.

resetting the crypto block, successfull fixed that issue, so I did the
following change:

-------------------
diff --git a/arch/arm/boot/dts/rk3288.dtsi b/arch/arm/boot/dts/rk3288.dtsi
index 121b6d5..e978fb2 100644
--- a/arch/arm/boot/dts/rk3288.dtsi
+++ b/arch/arm/boot/dts/rk3288.dtsi
@@ -182,6 +182,8 @@
                              "hclk",
                              "sclk",
                              "apb_pclk";
+               resets = <&cru SRST_CRYPTO>;
+               reset-names = "crypto";
                status = "okay";
        };
 
diff --git a/drivers/crypto/rockchip/rk3288_crypto.c b/drivers/crypto/rockchip/rk3288_crypto.c
index 02830f2..2245d3d 100644
--- a/drivers/crypto/rockchip/rk3288_crypto.c
+++ b/drivers/crypto/rockchip/rk3288_crypto.c
@@ -18,6 +18,7 @@
 #include <linux/of.h>
 #include <linux/clk.h>
 #include <linux/crypto.h>
+#include <linux/reset.h>
 
 struct crypto_info_t *crypto_p;
 
@@ -266,6 +267,15 @@ static int rk_crypto_probe(struct platform_device *pdev)
        struct resource *res;
        struct device *dev = &pdev->dev;
        struct crypto_info_t *crypto_info;
+       struct reset_control *rst;
+
+       /* reset the block to remove any pending actions */
+       rst = devm_reset_control_get(dev, "crypto");
+       if (!IS_ERR(rst)) {
+               reset_control_assert(rst);
+               usleep_range(10, 20);
+               reset_control_deassert(rst);
+       }
 
        crypto_info = devm_kzalloc(&pdev->dev,
                        sizeof(*crypto_info), GFP_KERNEL);
-------------------


> +	crypto_info = devm_kzalloc(&pdev->dev,
> +				   sizeof(*crypto_info), GFP_KERNEL);
> +	if (!crypto_info)
> +		return -ENOMEM;
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
> +
> +	if (err) {
> +		dev_err(crypto_info->dev, "irq request failed.\n");
> +		goto err_ioremap;
> +	}
> +
> +	crypto_info->dev = &pdev->dev;
> +	platform_set_drvdata(pdev, crypto_info);
> +	crypto_p = crypto_info;
> +
> +	tasklet_init(&crypto_info->crypto_tasklet,
> +		     rk_crypto_tasklet_cb, (unsigned long)crypto_info);
> +	crypto_init_queue(&crypto_info->queue, 50);
> +
> +	crypto_info->enable_clk = rk_crypto_enable_clk;
> +	crypto_info->disable_clk = rk_crypto_disable_clk;
> +	crypto_info->load_data = rk_load_data;
> +	crypto_info->unload_data = rk_unload_data;
> +
> +	err = rk_crypto_register();
> +	if (err) {
> +		dev_err(dev, "err in register alg");
> +		goto err_reg_alg;
> +	}
> +
> +	return 0;
> +
> +err_reg_alg:
> +	free_irq(crypto_info->irq, crypto_info);
> +err_ioremap:
> +	crypto_p = NULL;
> +
> +	return err;
> +}
> +

[...]

> diff --git a/drivers/crypto/rockchip/rk3288_crypto.h b/drivers/crypto/rockchip/rk3288_crypto.h
> new file mode 100644
> index 0000000..cf4cd18
> --- /dev/null
> +++ b/drivers/crypto/rockchip/rk3288_crypto.h
> @@ -0,0 +1,222 @@

[...]

> +struct crypto_info_t {

this is highly rockchip specific, so should probably be named
        rk_crypto_info
or similar instead of a generic sounding crypto_info_t

[...]

> +	struct device			*dev;
> +	struct clk			*aclk;
> +	struct clk			*hclk;
> +	struct clk			*sclk;
> +	struct clk			*dmaclk;
> +	void __iomem			*reg;
> +	int				irq;
> +	struct crypto_queue		queue;
> +	struct tasklet_struct		crypto_tasklet;
> +	struct ablkcipher_request	*ablk_req;
> +	/* device lock */
> +	spinlock_t			lock;
> +
> +	/* the public variable */
> +	struct scatterlist		*sg_src;
> +	struct scatterlist		*sg_dst;
> +	struct scatterlist		sg_tmp;
> +	struct scatterlist		*first;
> +	unsigned int			left_bytes;
> +	void				*addr_vir;
> +	int				aligned;
> +	int				align_size;
> +	size_t				nents;
> +	unsigned int			total;
> +	unsigned int			count;
> +	u32				mode;
> +	dma_addr_t			addr_in;
> +	dma_addr_t			addr_out;
> +	int (*start)(struct crypto_info_t *dev);
> +	int (*update)(struct crypto_info_t *dev);
> +	void (*complete)(struct crypto_info_t *dev, int err);
> +	int (*enable_clk)(struct crypto_info_t *dev);
> +	void (*disable_clk)(struct crypto_info_t *dev);
> +	int (*load_data)(struct crypto_info_t *dev,
> +			 struct scatterlist *sg_src,
> +			 struct scatterlist *sg_dst);
> +	void (*unload_data)(struct crypto_info_t *dev);
> +};
> +
> +/* the private variable of cipher */
> +struct rk_cipher_ctx {
> +	struct crypto_info_t		*dev;
> +	unsigned int			keylen;
> +};
> +
> +extern struct crypto_info_t *crypto_p;
> +
> +extern struct crypto_alg rk_ecb_aes_alg;
> +extern struct crypto_alg rk_cbc_aes_alg;
> +extern struct crypto_alg rk_ecb_des_alg;
> +extern struct crypto_alg rk_cbc_des_alg;
> +extern struct crypto_alg rk_ecb_des3_ede_alg;
> +extern struct crypto_alg rk_cbc_des3_ede_alg;
> +
> +#endif
> diff --git a/drivers/crypto/rockchip/rk3288_crypto_ablkcipher.c b/drivers/crypto/rockchip/rk3288_crypto_ablkcipher.c
> new file mode 100644
> index 0000000..28b49c9
> --- /dev/null
> +++ b/drivers/crypto/rockchip/rk3288_crypto_ablkcipher.c
> @@ -0,0 +1,511 @@

[...]

> +static int rk_ablk_cra_init(struct crypto_tfm *tfm)
> +{
> +	struct rk_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
> +
> +	ctx->dev = crypto_p;

please no static pointers for devices.

For example, sunxi_ss does the following to transport the core device-data
into the init function:

        struct sun4i_tfm_ctx *op = crypto_tfm_ctx(tfm);
        struct crypto_alg *alg = tfm->__crt_alg;
        struct sun4i_ss_alg_template *algt;

        algt = container_of(alg, struct sun4i_ss_alg_template, alg.crypto);
        op->ss = algt->ss;

so you could probably do something similar

Same of course for the other crypto_p users.


Thanks
Heiko
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
