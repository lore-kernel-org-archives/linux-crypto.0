From: Zain <zain.wang@rock-chips.com>
Subject: Re: [PATCH v2 1/4] Crypto: Crypto driver support aes/des/des3 for
 rk3288
Date: Mon, 9 Nov 2015 11:46:52 +0800
Message-ID: <5640172C.9010706@rock-chips.com>
References: <1446772644-2352-1-git-send-email-zain.wang@rock-chips.com>
 <1446772644-2352-2-git-send-email-zain.wang@rock-chips.com>
 <29530953.Mr1LQyjF1I@phil>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: zhengsq@rock-chips.com, hl@rock-chips.com,
	herbert@gondor.apana.org.au, davem@davemloft.net,
	mturquette@baylibre.com, pawel.moll@arm.com,
	ijc+devicetree@hellion.org.uk, robh+dt@kernel.org,
	galak@codeaurora.org, linux@arm.linux.org.uk, mark.rutland@arm.com,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-rockchip@lists.infradead.org, devicetree@vger.kernel.org,
	eddie.cai@rock-chips.com
To: Heiko Stuebner <heiko@sntech.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from regular1.263xmail.com ([211.150.99.135]:56314 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401AbbKIDrK (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 8 Nov 2015 22:47:10 -0500
In-Reply-To: <29530953.Mr1LQyjF1I@phil>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Heiko,
Thanks for your serious comments always.

On 2015=E5=B9=B411=E6=9C=8808=E6=97=A5 07:19, Heiko Stuebner wrote:
> Hi Zain,
>
> looks like my comment on v1 came later than your v2 submission,
> so here it is again :-)
>
> Am Freitag, 6. November 2015, 09:17:21 schrieb Zain Wang:
>> The names registered are:
>>     ecb(aes) cbc(aes) ecb(des) cbc(des) ecb(des3_ede) cbc(des3_ede)
>> You can alloc tags above in your case.
>>
>> And other algorithms and platforms will be added later on.
>>
>> Signed-off-by: Zain Wang <zain.wang@rock-chips.com>
>> ---
>>
> [...]
>
>> diff --git a/drivers/crypto/rockchip/rk3288_crypto.c b/drivers/crypt=
o/rockchip/rk3288_crypto.c
>> new file mode 100644
>> index 0000000..c2a419b
>> --- /dev/null
>> +++ b/drivers/crypto/rockchip/rk3288_crypto.c
> [...]
>
>> +static int rk_crypto_probe(struct platform_device *pdev)
>> +{
>> +	int err =3D 0;
>> +	struct resource *res;
>> +	struct device *dev =3D &pdev->dev;
>> +	struct crypto_info_t *crypto_info;
>> +
> rk3288 chromebooks use the crypto-engine to validate the boot images =
and
> seem to leave it in a half-on state. This results in an irq pending
> during probe and thus a null-pointer dereference in the irq-handler, =
as
> it runs before the crypto-device is fully initialized.
>
> resetting the crypto block, successfull fixed that issue, so I did th=
e
> following change:
>
> -------------------
> diff --git a/arch/arm/boot/dts/rk3288.dtsi b/arch/arm/boot/dts/rk3288=
=2Edtsi
> index 121b6d5..e978fb2 100644
> --- a/arch/arm/boot/dts/rk3288.dtsi
> +++ b/arch/arm/boot/dts/rk3288.dtsi
> @@ -182,6 +182,8 @@
>                               "hclk",
>                               "sclk",
>                               "apb_pclk";
> +               resets =3D <&cru SRST_CRYPTO>;
> +               reset-names =3D "crypto";
>                 status =3D "okay";
>         };
> =20
> diff --git a/drivers/crypto/rockchip/rk3288_crypto.c b/drivers/crypto=
/rockchip/rk3288_crypto.c
> index 02830f2..2245d3d 100644
> --- a/drivers/crypto/rockchip/rk3288_crypto.c
> +++ b/drivers/crypto/rockchip/rk3288_crypto.c
> @@ -18,6 +18,7 @@
>  #include <linux/of.h>
>  #include <linux/clk.h>
>  #include <linux/crypto.h>
> +#include <linux/reset.h>
> =20
>  struct crypto_info_t *crypto_p;
> =20
> @@ -266,6 +267,15 @@ static int rk_crypto_probe(struct platform_devic=
e *pdev)
>         struct resource *res;
>         struct device *dev =3D &pdev->dev;
>         struct crypto_info_t *crypto_info;
> +       struct reset_control *rst;
> +
> +       /* reset the block to remove any pending actions */
> +       rst =3D devm_reset_control_get(dev, "crypto");
> +       if (!IS_ERR(rst)) {
> +               reset_control_assert(rst);
> +               usleep_range(10, 20);
> +               reset_control_deassert(rst);
> +       }
> =20
>         crypto_info =3D devm_kzalloc(&pdev->dev,
>                         sizeof(*crypto_info), GFP_KERNEL);
> -------------------
>
Ok! done!
>> +	crypto_info =3D devm_kzalloc(&pdev->dev,
>> +				   sizeof(*crypto_info), GFP_KERNEL);
>> +	if (!crypto_info)
>> +		return -ENOMEM;
>> +
>> +	spin_lock_init(&crypto_info->lock);
>> +
>> +	res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> +	crypto_info->reg =3D devm_ioremap_resource(&pdev->dev, res);
>> +	if (IS_ERR(crypto_info->reg)) {
>> +		err =3D PTR_ERR(crypto_info->reg);
>> +		goto err_ioremap;
>> +	}
>> +
>> +	crypto_info->aclk =3D devm_clk_get(&pdev->dev, "aclk");
>> +	if (IS_ERR(crypto_info->aclk)) {
>> +		err =3D PTR_ERR(crypto_info->aclk);
>> +		goto err_ioremap;
>> +	}
>> +
>> +	crypto_info->hclk =3D devm_clk_get(&pdev->dev, "hclk");
>> +	if (IS_ERR(crypto_info->hclk)) {
>> +		err =3D PTR_ERR(crypto_info->hclk);
>> +		goto err_ioremap;
>> +	}
>> +
>> +	crypto_info->sclk =3D devm_clk_get(&pdev->dev, "sclk");
>> +	if (IS_ERR(crypto_info->sclk)) {
>> +		err =3D PTR_ERR(crypto_info->sclk);
>> +		goto err_ioremap;
>> +	}
>> +
>> +	crypto_info->dmaclk =3D devm_clk_get(&pdev->dev, "apb_pclk");
>> +	if (IS_ERR(crypto_info->dmaclk)) {
>> +		err =3D PTR_ERR(crypto_info->dmaclk);
>> +		goto err_ioremap;
>> +	}
>> +
>> +	crypto_info->irq =3D platform_get_irq(pdev, 0);
>> +	if (crypto_info->irq < 0) {
>> +		dev_warn(crypto_info->dev,
>> +			 "control Interrupt is not available.\n");
>> +		err =3D crypto_info->irq;
>> +		goto err_ioremap;
>> +	}
>> +
>> +	err =3D devm_request_irq(&pdev->dev, crypto_info->irq, crypto_irq_=
handle,
>> +			       IRQF_SHARED, "rk-crypto", pdev);
>> +
>> +	if (err) {
>> +		dev_err(crypto_info->dev, "irq request failed.\n");
>> +		goto err_ioremap;
>> +	}
>> +
>> +	crypto_info->dev =3D &pdev->dev;
>> +	platform_set_drvdata(pdev, crypto_info);
>> +	crypto_p =3D crypto_info;
>> +
>> +	tasklet_init(&crypto_info->crypto_tasklet,
>> +		     rk_crypto_tasklet_cb, (unsigned long)crypto_info);
>> +	crypto_init_queue(&crypto_info->queue, 50);
>> +
>> +	crypto_info->enable_clk =3D rk_crypto_enable_clk;
>> +	crypto_info->disable_clk =3D rk_crypto_disable_clk;
>> +	crypto_info->load_data =3D rk_load_data;
>> +	crypto_info->unload_data =3D rk_unload_data;
>> +
>> +	err =3D rk_crypto_register();
>> +	if (err) {
>> +		dev_err(dev, "err in register alg");
>> +		goto err_reg_alg;
>> +	}
>> +
>> +	return 0;
>> +
>> +err_reg_alg:
>> +	free_irq(crypto_info->irq, crypto_info);
>> +err_ioremap:
>> +	crypto_p =3D NULL;
>> +
>> +	return err;
>> +}
>> +
> [...]
>
>> diff --git a/drivers/crypto/rockchip/rk3288_crypto.h b/drivers/crypt=
o/rockchip/rk3288_crypto.h
>> new file mode 100644
>> index 0000000..cf4cd18
>> --- /dev/null
>> +++ b/drivers/crypto/rockchip/rk3288_crypto.h
>> @@ -0,0 +1,222 @@
> [...]
>
>> +struct crypto_info_t {
> this is highly rockchip specific, so should probably be named
>         rk_crypto_info
> or similar instead of a generic sounding crypto_info_t
Ok! Done!
>
> [...]
>
>> +	struct device			*dev;
>> +	struct clk			*aclk;
>> +	struct clk			*hclk;
>> +	struct clk			*sclk;
>> +	struct clk			*dmaclk;
>> +	void __iomem			*reg;
>> +	int				irq;
>> +	struct crypto_queue		queue;
>> +	struct tasklet_struct		crypto_tasklet;
>> +	struct ablkcipher_request	*ablk_req;
>> +	/* device lock */
>> +	spinlock_t			lock;
>> +
>> +	/* the public variable */
>> +	struct scatterlist		*sg_src;
>> +	struct scatterlist		*sg_dst;
>> +	struct scatterlist		sg_tmp;
>> +	struct scatterlist		*first;
>> +	unsigned int			left_bytes;
>> +	void				*addr_vir;
>> +	int				aligned;
>> +	int				align_size;
>> +	size_t				nents;
>> +	unsigned int			total;
>> +	unsigned int			count;
>> +	u32				mode;
>> +	dma_addr_t			addr_in;
>> +	dma_addr_t			addr_out;
>> +	int (*start)(struct crypto_info_t *dev);
>> +	int (*update)(struct crypto_info_t *dev);
>> +	void (*complete)(struct crypto_info_t *dev, int err);
>> +	int (*enable_clk)(struct crypto_info_t *dev);
>> +	void (*disable_clk)(struct crypto_info_t *dev);
>> +	int (*load_data)(struct crypto_info_t *dev,
>> +			 struct scatterlist *sg_src,
>> +			 struct scatterlist *sg_dst);
>> +	void (*unload_data)(struct crypto_info_t *dev);
>> +};
>> +
>> +/* the private variable of cipher */
>> +struct rk_cipher_ctx {
>> +	struct crypto_info_t		*dev;
>> +	unsigned int			keylen;
>> +};
>> +
>> +extern struct crypto_info_t *crypto_p;
>> +
>> +extern struct crypto_alg rk_ecb_aes_alg;
>> +extern struct crypto_alg rk_cbc_aes_alg;
>> +extern struct crypto_alg rk_ecb_des_alg;
>> +extern struct crypto_alg rk_cbc_des_alg;
>> +extern struct crypto_alg rk_ecb_des3_ede_alg;
>> +extern struct crypto_alg rk_cbc_des3_ede_alg;
>> +
>> +#endif
>> diff --git a/drivers/crypto/rockchip/rk3288_crypto_ablkcipher.c b/dr=
ivers/crypto/rockchip/rk3288_crypto_ablkcipher.c
>> new file mode 100644
>> index 0000000..28b49c9
>> --- /dev/null
>> +++ b/drivers/crypto/rockchip/rk3288_crypto_ablkcipher.c
>> @@ -0,0 +1,511 @@
> [...]
>
>> +static int rk_ablk_cra_init(struct crypto_tfm *tfm)
>> +{
>> +	struct rk_cipher_ctx *ctx =3D crypto_tfm_ctx(tfm);
>> +
>> +	ctx->dev =3D crypto_p;
> please no static pointers for devices.
>
> For example, sunxi_ss does the following to transport the core device=
-data
> into the init function:
>
>         struct sun4i_tfm_ctx *op =3D crypto_tfm_ctx(tfm);
>         struct crypto_alg *alg =3D tfm->__crt_alg;
>         struct sun4i_ss_alg_template *algt;
>
>         algt =3D container_of(alg, struct sun4i_ss_alg_template, alg.=
crypto);
>         op->ss =3D algt->ss;
>
> so you could probably do something similar
>
> Same of course for the other crypto_p users.
Ok! Done!
>
>
> Thanks
> Heiko
>
>
>
Thanks
Zain
