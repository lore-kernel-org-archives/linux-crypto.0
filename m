From: Heiko Stuebner <heiko@sntech.de>
Subject: Re: [PATCH v1 1/4] Crypto: Crypto driver support aes/des/des3 for rk3288
Date: Fri, 06 Nov 2015 11:38:13 +0100
Message-ID: <42555092.2WGsqrpJvE@phil>
References: <1446529928-12521-1-git-send-email-zain.wang@rock-chips.com> <1446529928-12521-2-git-send-email-zain.wang@rock-chips.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: zhengsq@rock-chips.com, hl@rock-chips.com,
	herbert@gondor.apana.org.au, davem@davemloft.net,
	mturquette@baylibre.com, pawel.moll@arm.com,
	ijc+devicetree@hellion.org.uk, robh+dt@kernel.org,
	galak@codeaurora.org, linux@arm.linux.org.uk, mark.rutland@arm.com,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-rockchip@lists.infradead.org, devicetree@vger.kernel.org,
	eddie.cai@rock-chips.com
To: Zain Wang <zain.wang@rock-chips.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from gloria.sntech.de ([95.129.55.99]:47567 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1033156AbbKFKif (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 6 Nov 2015 05:38:35 -0500
In-Reply-To: <1446529928-12521-2-git-send-email-zain.wang@rock-chips.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Zain,

Am Dienstag, 3. November 2015, 13:52:05 schrieb Zain Wang:
> Crypto driver support cbc/ecb two chainmode, and aes/des/des3 three cipher
> mode.
> The names registered are:
>     ecb(aes) cbc(aes) ecb(des) cbc(des) ecb(des3_ede) cbc(des3_ede)
> You can alloc tags above in your case.
> 
> And other algorithms and platforms will be added later on.
> 
> Signed-off-by: Zain Wang <zain.wang@rock-chips.com>
> ---
>  drivers/crypto/Kconfig                             |  11 +
>  drivers/crypto/Makefile                            |   1 +
>  drivers/crypto/rockchip/Makefile                   |   3 +
>  drivers/crypto/rockchip/rk3288_crypto.c            | 383 ++++++++++++++++
>  drivers/crypto/rockchip/rk3288_crypto.h            | 290 ++++++++++++
>  drivers/crypto/rockchip/rk3288_crypto_ablkcipher.c | 501 +++++++++++++++++++++
>  6 files changed, 1189 insertions(+)
>  create mode 100644 drivers/crypto/rockchip/Makefile
>  create mode 100644 drivers/crypto/rockchip/rk3288_crypto.c
>  create mode 100644 drivers/crypto/rockchip/rk3288_crypto.h
>  create mode 100644 drivers/crypto/rockchip/rk3288_crypto_ablkcipher.c
> 
> diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
> index 2569e04..d1e42cf 100644
> --- a/drivers/crypto/Kconfig
> +++ b/drivers/crypto/Kconfig
> @@ -498,4 +498,15 @@ config CRYPTO_DEV_SUN4I_SS
>  	  To compile this driver as a module, choose M here: the module
>  	  will be called sun4i-ss.
>  
> +config CRYPTO_DEV_ROCKCHIP
> +	tristate "Rockchip's Cryptographic Engine driver"
> +
> +	select CRYPTO_AES
> +	select CRYPTO_DES
> +	select CRYPTO_BLKCIPHER
> +
> +	help
> +	  This driver interfaces with the hardware crypto accelerator.
> +	  Supporting cbc/ecb chainmode, and aes/des/des3_ede cipher mode.
> +
>  endif # CRYPTO_HW
> diff --git a/drivers/crypto/Makefile b/drivers/crypto/Makefile
> index c3ced6f..713de9d 100644
> --- a/drivers/crypto/Makefile
> +++ b/drivers/crypto/Makefile
> @@ -29,3 +29,4 @@ obj-$(CONFIG_CRYPTO_DEV_QAT) += qat/
>  obj-$(CONFIG_CRYPTO_DEV_QCE) += qce/
>  obj-$(CONFIG_CRYPTO_DEV_VMX) += vmx/
>  obj-$(CONFIG_CRYPTO_DEV_SUN4I_SS) += sunxi-ss/
> +obj-$(CONFIG_CRYPTO_DEV_ROCKCHIP) += rockchip/
> diff --git a/drivers/crypto/rockchip/Makefile b/drivers/crypto/rockchip/Makefile
> new file mode 100644
> index 0000000..7051c6c
> --- /dev/null
> +++ b/drivers/crypto/rockchip/Makefile
> @@ -0,0 +1,3 @@
> +obj-$(CONFIG_CRYPTO_DEV_ROCKCHIP) += rk_crypto.o
> +rk_crypto-objs := rk3288_crypto.o \
> +		  rk3288_crypto_ablkcipher.o \
> diff --git a/drivers/crypto/rockchip/rk3288_crypto.c b/drivers/crypto/rockchip/rk3288_crypto.c
> new file mode 100644
> index 0000000..02830f2
> --- /dev/null
> +++ b/drivers/crypto/rockchip/rk3288_crypto.c
> @@ -0,0 +1,383 @@

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
+		resets = <&cru SRST_CRYPTO>;
+		reset-names = "crypto";
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
+	struct reset_control *rst;
+
+	/* reset the block to remove any pending actions */
+	rst = devm_reset_control_get(dev, "crypto");
+	if (!IS_ERR(rst)) {
+		reset_control_assert(rst);
+		usleep_range(10, 20);
+		reset_control_deassert(rst);
+	}
 
 	crypto_info = devm_kzalloc(&pdev->dev,
 			sizeof(*crypto_info), GFP_KERNEL);
-------------------


> +	crypto_info = devm_kzalloc(&pdev->dev,
> +			sizeof(*crypto_info), GFP_KERNEL);
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
> +				"control Interrupt is not available.\n");
> +		err = crypto_info->irq;
> +		goto err_ioremap;
> +	}
> +
> +	err = devm_request_irq(&pdev->dev, crypto_info->irq, crypto_irq_handle,
> +				IRQF_SHARED, "rk-crypto", pdev);
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
> +			rk_crypto_tasklet_cb, (unsigned long)crypto_info);
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
> index 0000000..153aafb
> --- /dev/null
> +++ b/drivers/crypto/rockchip/rk3288_crypto.h

[...]

> +
> +#define CRYPTO_READ(dev, offset)		  \
> +		__raw_readl(((dev)->reg + (offset)))
> +#define CRYPTO_WRITE(dev, offset, val)	  \
> +		__raw_writel((val), ((dev)->reg + (offset)))
> +/* get register virt address */
> +#define CRYPTO_GET_REG_VIRT(dev, offset)   ((dev)->reg + (offset))
> +
> +#define RK_ALIGN_MASK			(sizeof(u32)-1)
> +
> +struct crypto_info_t {

this is highly rockchip specific, so should probably be named
	rk_crypto_info
or similar instead of a generic sounding crypto_info_t

[...]

> diff --git a/drivers/crypto/rockchip/rk3288_crypto_ablkcipher.c b/drivers/crypto/rockchip/rk3288_crypto_ablkcipher.c
> new file mode 100644
> index 0000000..b3de229
> --- /dev/null
> +++ b/drivers/crypto/rockchip/rk3288_crypto_ablkcipher.c
> @@ -0,0 +1,501 @@

[...]

> +static int rk_ablk_cra_init(struct crypto_tfm *tfm)
> +{
> +	struct rk_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
> +
> +	ctx->dev = crypto_p;

as said above, please no static pointers for devices.

For example, sunxi_ss does the following to transport the core device-data
into the init function:

	struct sun4i_tfm_ctx *op = crypto_tfm_ctx(tfm);
	struct crypto_alg *alg = tfm->__crt_alg;
	struct sun4i_ss_alg_template *algt;

	algt = container_of(alg, struct sun4i_ss_alg_template, alg.crypto);
	op->ss = algt->ss;

so you could probably do something similar


Thanks
Heiko
