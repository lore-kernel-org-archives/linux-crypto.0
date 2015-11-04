From: Zain <zain.wang@rock-chips.com>
Subject: Re: [PATCH v1 1/4] Crypto: Crypto driver support aes/des/des3 for
 rk3288
Date: Wed, 4 Nov 2015 13:50:08 +0800
Message-ID: <56399C90.4020503@rock-chips.com>
References: <1446529928-12521-1-git-send-email-zain.wang@rock-chips.com>
 <1446529928-12521-2-git-send-email-zain.wang@rock-chips.com>
 <20151103085951.GA10189@Red>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: zhengsq@rock-chips.com, hl@rock-chips.com,
	herbert@gondor.apana.org.au, davem@davemloft.net,
	mturquette@baylibre.com, heiko@sntech.de, pawel.moll@arm.com,
	ijc+devicetree@hellion.org.uk, robh+dt@kernel.org,
	galak@codeaurora.org, linux@arm.linux.org.uk, mark.rutland@arm.com,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-rockchip@lists.infradead.org, devicetree@vger.kernel.org,
	eddie.cai@rock-chips.com
To: LABBE Corentin <clabbe.montjoie@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from regular1.263xmail.com ([211.150.99.139]:41655 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354AbbKDFuw (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 4 Nov 2015 00:50:52 -0500
In-Reply-To: <20151103085951.GA10189@Red>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi LABBE,

On 2015=E5=B9=B411=E6=9C=8803=E6=97=A5 16:59, LABBE Corentin wrote:
> On Tue, Nov 03, 2015 at 01:52:05PM +0800, Zain Wang wrote:
>> Crypto driver support cbc/ecb two chainmode, and aes/des/des3 three =
cipher
>> mode.
>> The names registered are:
>>     ecb(aes) cbc(aes) ecb(des) cbc(des) ecb(des3_ede) cbc(des3_ede)
>> You can alloc tags above in your case.
>>
>> And other algorithms and platforms will be added later on.
>>
>> Signed-off-by: Zain Wang <zain.wang@rock-chips.com>
>> ---
>>  drivers/crypto/Kconfig                             |  11 +
>>  drivers/crypto/Makefile                            |   1 +
>>  drivers/crypto/rockchip/Makefile                   |   3 +
>>  drivers/crypto/rockchip/rk3288_crypto.c            | 383 ++++++++++=
++++++
>>  drivers/crypto/rockchip/rk3288_crypto.h            | 290 ++++++++++=
++
>>  drivers/crypto/rockchip/rk3288_crypto_ablkcipher.c | 501 ++++++++++=
+++++++++++
>>  6 files changed, 1189 insertions(+)
>>  create mode 100644 drivers/crypto/rockchip/Makefile
>>  create mode 100644 drivers/crypto/rockchip/rk3288_crypto.c
>>  create mode 100644 drivers/crypto/rockchip/rk3288_crypto.h
>>  create mode 100644 drivers/crypto/rockchip/rk3288_crypto_ablkcipher=
=2Ec
>>
>> diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
>> index 2569e04..d1e42cf 100644
>> --- a/drivers/crypto/Kconfig
>> +++ b/drivers/crypto/Kconfig
>> @@ -498,4 +498,15 @@ config CRYPTO_DEV_SUN4I_SS
>>  	  To compile this driver as a module, choose M here: the module
>>  	  will be called sun4i-ss.
>> =20
>> +config CRYPTO_DEV_ROCKCHIP
>> +	tristate "Rockchip's Cryptographic Engine driver"
>> +
>> +	select CRYPTO_AES
>> +	select CRYPTO_DES
>> +	select CRYPTO_BLKCIPHER
>> +
>> +	help
>> +	  This driver interfaces with the hardware crypto accelerator.
>> +	  Supporting cbc/ecb chainmode, and aes/des/des3_ede cipher mode.
>> +
>>  endif # CRYPTO_HW
>> diff --git a/drivers/crypto/Makefile b/drivers/crypto/Makefile
>> index c3ced6f..713de9d 100644
>> --- a/drivers/crypto/Makefile
>> +++ b/drivers/crypto/Makefile
>> @@ -29,3 +29,4 @@ obj-$(CONFIG_CRYPTO_DEV_QAT) +=3D qat/
>>  obj-$(CONFIG_CRYPTO_DEV_QCE) +=3D qce/
>>  obj-$(CONFIG_CRYPTO_DEV_VMX) +=3D vmx/
>>  obj-$(CONFIG_CRYPTO_DEV_SUN4I_SS) +=3D sunxi-ss/
>> +obj-$(CONFIG_CRYPTO_DEV_ROCKCHIP) +=3D rockchip/
>> diff --git a/drivers/crypto/rockchip/Makefile b/drivers/crypto/rockc=
hip/Makefile
>> new file mode 100644
>> index 0000000..7051c6c
>> --- /dev/null
>> +++ b/drivers/crypto/rockchip/Makefile
>> @@ -0,0 +1,3 @@
>> +obj-$(CONFIG_CRYPTO_DEV_ROCKCHIP) +=3D rk_crypto.o
>> +rk_crypto-objs :=3D rk3288_crypto.o \
>> +		  rk3288_crypto_ablkcipher.o \
>> diff --git a/drivers/crypto/rockchip/rk3288_crypto.c b/drivers/crypt=
o/rockchip/rk3288_crypto.c
>> new file mode 100644
>> index 0000000..02830f2
>> --- /dev/null
>> +++ b/drivers/crypto/rockchip/rk3288_crypto.c
>> @@ -0,0 +1,383 @@
>> +/*
>> + *Crypto acceleration support for Rockchip RK3288
>> + *
>> + * Copyright (c) 2015, Fuzhou Rockchip Electronics Co., Ltd
>> + *
>> + * Author: Zain Wang <zain.wang@rock-chips.com>
>> + *
>> + * This program is free software; you can redistribute it and/or mo=
dify it
>> + * under the terms and conditions of the GNU General Public License=
,
>> + * version 2, as published by the Free Software Foundation.
>> + *
>> + * Some ideas are from marvell-cesa.c and s5p-sss.c driver.
>> + */
>> +
>> +#include "rk3288_crypto.h"
>> +#include <linux/module.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/of.h>
>> +#include <linux/clk.h>
>> +#include <linux/crypto.h>
>> +
>> +struct crypto_info_t *crypto_p;
>> +
>> +static int rk_crypto_enable_clk(struct crypto_info_t *dev)
>> +{
>> +	int err;
>> +
>> +	err =3D clk_prepare_enable(dev->sclk);
>> +	if (err) {
>> +		dev_err(dev->dev, "[%s:%d], Couldn't enable clock 'sclk'\n",
>> +						__func__, __LINE__);
>> +		goto err_return;
>> +	}
>> +	err =3D clk_prepare_enable(dev->aclk);
>> +	if (err) {
>> +		dev_err(dev->dev, "[%s:%d], Couldn't enable clock 'aclk'\n",
>> +						__func__, __LINE__);
>> +		goto err_aclk;
>> +	}
>> +	err =3D clk_prepare_enable(dev->hclk);
>> +	if (err) {
>> +		dev_err(dev->dev, "[%s:%d], Couldn't enable clock 'hclk'\n",
>> +						__func__, __LINE__);
>> +		goto err_hclk;
>> +	}
>> +
>> +	err =3D clk_prepare_enable(dev->dmaclk);
>> +	if (err) {
>> +		dev_err(dev->dev, "[%s:%d], Couldn't enable clock 'dmaclk'\n",
>> +						__func__, __LINE__);
>> +		goto err_dmaclk;
>> +	}
>> +	return err;
>> +err_dmaclk:
>> +	clk_disable_unprepare(dev->hclk);
>> +err_hclk:
>> +	clk_disable_unprepare(dev->aclk);
>> +err_aclk:
>> +	clk_disable_unprepare(dev->sclk);
>> +err_return:
>> +	return err;
>> +}
>> +
>> +static void rk_crypto_disable_clk(struct crypto_info_t *dev)
>> +{
>> +	clk_disable_unprepare(dev->dmaclk);
>> +	clk_disable_unprepare(dev->hclk);
>> +	clk_disable_unprepare(dev->aclk);
>> +	clk_disable_unprepare(dev->sclk);
>> +}
>> +
>> +static int check_alignment(struct scatterlist *sg_src,
>> +			   struct scatterlist *sg_dst,
>> +			   int align_mask)
>> +{
>> +	int in, out, align;
>> +
>> +	in =3D IS_ALIGNED((uint32_t)sg_src->offset, 4) &&
>> +	     IS_ALIGNED(sg_src->length, align_mask);
>> +	if (sg_dst =3D=3D NULL)
>> +		return in;
>> +	out =3D IS_ALIGNED((uint32_t)sg_dst->offset, 4) &&
>> +	      IS_ALIGNED(sg_dst->length, align_mask);
>> +	align =3D in && out;
>> +
>> +	return (align && (sg_src->length =3D=3D sg_dst->length));
>> +}
> You have missed some uint32_t/u32 conversion
ok! done!
>
>> +
>> +static int rk_load_data(struct crypto_info_t *dev,
>> +			      struct scatterlist *sg_src,
>> +			      struct scatterlist *sg_dst)
>> +{
>> +	uint32_t count;
> It seems that count could be unsigned int (left_bytes, sg->length, et=
c... are all unsigned int)
ok! done!
>
>> +
>> +	dev->aligned =3D dev->aligned ?
>> +		check_alignment(sg_src, sg_dst, dev->align_size) :
>> +		dev->aligned;
>> +	if (dev->aligned) {
>> +		count =3D min(dev->left_bytes, sg_src->length);
>> +		dev->left_bytes -=3D count;
>> +
>> +		if (!dma_map_sg(dev->dev, sg_src, 1, DMA_TO_DEVICE)) {
>> +			dev_err(dev->dev, "[%s:%d] dma_map_sg(src)  error\n",
>> +							__func__, __LINE__);
>> +			return -EINVAL;
>> +		}
>> +		dev->addr_in =3D sg_dma_address(sg_src);
>> +
>> +		if (sg_dst !=3D NULL) {
>> +			if (!dma_map_sg(dev->dev, sg_dst, 1, DMA_FROM_DEVICE)) {
>> +				dev_err(dev->dev,
>> +					"[%s:%d] dma_map_sg(dst)  error\n",
>> +					__func__, __LINE__);
>> +				dma_unmap_sg(dev->dev, sg_src, 1,
>> +						DMA_TO_DEVICE);
>> +				return -EINVAL;
>> +			}
>> +			dev->addr_out =3D sg_dma_address(sg_dst);
>> +		}
>> +	} else {
>> +		count =3D (dev->left_bytes > PAGE_SIZE) ?
>> +			PAGE_SIZE : dev->left_bytes;
>> +
>> +		if (!sg_pcopy_to_buffer(dev->first, dev->nents,
>> +					 dev->addr_vir, count,
>> +					 dev->total - dev->left_bytes)) {
>> +			dev_err(dev->dev, "[%s:%d] pcopy err\n",
>> +						__func__, __LINE__);
>> +			return -EINVAL;
>> +		}
>> +		dev->left_bytes -=3D count;
>> +		sg_init_one(&dev->sg_tmp, dev->addr_vir, count);
>> +		if (!dma_map_sg(dev->dev, &dev->sg_tmp, 1, DMA_TO_DEVICE)) {
>> +			dev_err(dev->dev, "[%s:%d] dma_map_sg(sg_tmp)  error\n",
>> +							__func__, __LINE__);
>> +			return -ENOMEM;
>> +		}
>> +		dev->addr_in =3D sg_dma_address(&dev->sg_tmp);
>> +
>> +		if (sg_dst !=3D NULL) {
>> +
>> +			if (!dma_map_sg(dev->dev, &dev->sg_tmp, 1,
>> +					 DMA_FROM_DEVICE)) {
>> +				dev_err(dev->dev,
>> +					"[%s:%d] dma_map_sg(sg_tmp)  error\n",
>> +					__func__, __LINE__);
>> +				dma_unmap_sg(dev->dev, &dev->sg_tmp, 1,
>> +					     DMA_TO_DEVICE);
>> +				return -ENOMEM;
>> +			}
>> +			dev->addr_out =3D sg_dma_address(&dev->sg_tmp);
>> +		}
>> +	}
>> +	dev->count =3D count;
>> +	return 0;
>> +}
>> +
>> +static void rk_unload_data(struct crypto_info_t *dev)
>> +{
>> +	struct scatterlist *sg_in, *sg_out;
>> +
>> +	sg_in =3D dev->aligned ? dev->sg_src : &dev->sg_tmp;
>> +	dma_unmap_sg(dev->dev, sg_in, 1, DMA_TO_DEVICE);
>> +
>> +	if (dev->sg_dst !=3D NULL) {
>> +		sg_out =3D dev->aligned ? dev->sg_dst : &dev->sg_tmp;
>> +		dma_unmap_sg(dev->dev, sg_out, 1, DMA_FROM_DEVICE);
>> +	}
>> +}
>> +
>> +static irqreturn_t crypto_irq_handle(int irq, void *dev_id)
>> +{
>> +	struct crypto_info_t *dev  =3D platform_get_drvdata(dev_id);
>> +	uint32_t interrupt_status;
>> +	int err =3D 0;
>> +
>> +	spin_lock(&dev->lock);
>> +
>> +	if (irq =3D=3D dev->irq) {
>> +		interrupt_status =3D CRYPTO_READ(dev, RK_CRYPTO_INTSTS);
>> +		CRYPTO_WRITE(dev, RK_CRYPTO_INTSTS, interrupt_status);
>> +		if (interrupt_status & 0x0a) {
>> +			dev_warn(dev->dev, "DMA Error\n");
>> +			err =3D -EFAULT;
>> +		} else if (interrupt_status & 0x05)
>> +			err =3D dev->update(dev);
>> +
>> +		if (err)
>> +			dev->complete(dev, err);
>> +	}
>> +	spin_unlock(&dev->lock);
>> +	return IRQ_HANDLED;
>> +}
>> +
>> +static void rk_crypto_tasklet_cb(unsigned long data)
>> +{
>> +	struct crypto_info_t *dev =3D (struct crypto_info_t *)data;
>> +	struct crypto_async_request *async_req, *backlog;
>> +	struct rk_ahash_reqctx *hash_reqctx;
>> +	struct rk_cipher_reqctx *ablk_reqctx;
>> +	int err =3D 0;
>> +
>> +	spin_lock(&dev->lock);
>> +	backlog   =3D crypto_get_backlog(&dev->queue);
>> +	async_req =3D crypto_dequeue_request(&dev->queue);
>> +	spin_unlock(&dev->lock);
>> +	if (!async_req) {
>> +		dev_err(dev->dev, "async_req is NULL !!\n");
>> +		return;
>> +	}
>> +	if (backlog) {
>> +		backlog->complete(backlog, -EINPROGRESS);
>> +		backlog =3D NULL;
>> +	}
>> +
>> +	if (crypto_tfm_alg_type(async_req->tfm) =3D=3D CRYPTO_ALG_TYPE_AHA=
SH) {
>> +		dev->ahash_req =3D ahash_request_cast(async_req);
>> +		hash_reqctx =3D ahash_request_ctx(dev->ahash_req);
>> +	} else {
>> +		dev->ablk_req =3D ablkcipher_request_cast(async_req);
>> +		ablk_reqctx   =3D ablkcipher_request_ctx(dev->ablk_req);
>> +	}
>> +	err =3D dev->start(dev);
>> +	if (err)
>> +		dev->complete(dev, err);
>> +}
>> +
>> +static struct crypto_alg *rk_cipher_algs[] =3D {
>> +	&rk_ecb_aes_alg,
>> +	&rk_cbc_aes_alg,
>> +	&rk_ecb_des_alg,
>> +	&rk_cbc_des_alg,
>> +	&rk_ecb_des3_ede_alg,
>> +	&rk_cbc_des3_ede_alg,
>> +};
>> +
>> +static int rk_crypto_register(void)
>> +{
>> +	int i, k;
>> +	int err =3D 0;
>> +
>> +	for (i =3D 0; i < ARRAY_SIZE(rk_cipher_algs); i++) {
>> +		err =3D crypto_register_alg(rk_cipher_algs[i]);
>> +		if (err)
>> +			goto err_cipher_algs;
>> +	}
>> +	return err;
>> +
>> +err_cipher_algs:
>> +	for (k =3D 0; k < i; k++)
>> +		crypto_unregister_alg(rk_cipher_algs[k]);
>> +	return err;
> i> +}
> Setting i and k to unsigned will remove a warning with W=3D1
ok! done!
>> +
>> +static void rk_crypto_unregister(void)
>> +{
>> +	unsigned int i;
>> +
>> +	for (i =3D 0; i < ARRAY_SIZE(rk_cipher_algs); i++)
>> +		crypto_unregister_alg(rk_cipher_algs[i]);
>> +}
>> +
>> +static int rk_crypto_probe(struct platform_device *pdev)
>> +{
>> +	int err =3D 0;
>> +	struct resource *res;
>> +	struct device *dev =3D &pdev->dev;
>> +	struct crypto_info_t *crypto_info;
>> +
>> +	crypto_info =3D devm_kzalloc(&pdev->dev,
>> +			sizeof(*crypto_info), GFP_KERNEL);
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
>> +				"control Interrupt is not available.\n");
>> +		err =3D crypto_info->irq;
>> +		goto err_ioremap;
>> +	}
>> +
>> +	err =3D devm_request_irq(&pdev->dev, crypto_info->irq, crypto_irq_=
handle,
>> +				IRQF_SHARED, "rk-crypto", pdev);
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
>> +			rk_crypto_tasklet_cb, (unsigned long)crypto_info);
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
>> +static int rk_crypto_remove(struct platform_device *pdev)
>> +{
>> +	struct crypto_info_t *crypto_tmp =3D platform_get_drvdata(pdev);
>> +
>> +	rk_crypto_unregister();
>> +	tasklet_kill(&crypto_tmp->crypto_tasklet);
>> +	free_irq(crypto_tmp->irq, crypto_tmp);
>> +	crypto_p =3D NULL;
>> +
>> +	return 0;
>> +}
>> +#ifdef CONFIG_OF
>> +static const struct of_device_id crypto_of_id_table[] =3D {
>> +	{ .compatible =3D "rockchip,rk3288-crypto" },
>> +	{}
>> +};
>> +#endif /* CONFIG_OF */
>> +
>> +static struct platform_driver crypto_driver =3D {
>> +	.probe		=3D rk_crypto_probe,
>> +	.remove		=3D rk_crypto_remove,
>> +	.driver		=3D {
>> +		.name	=3D "rockchip,rk3288-crypto",
>> +		.of_match_table	=3D of_match_ptr(crypto_of_id_table),
>> +	},
>> +};
>> +
>> +module_platform_driver(crypto_driver);
>> +
>> +MODULE_LICENSE("GPL");
>> +MODULE_AUTHOR("Zain Wang");
>> diff --git a/drivers/crypto/rockchip/rk3288_crypto.h b/drivers/crypt=
o/rockchip/rk3288_crypto.h
>> new file mode 100644
>> index 0000000..153aafb
>> --- /dev/null
>> +++ b/drivers/crypto/rockchip/rk3288_crypto.h
>> @@ -0,0 +1,290 @@
>> +#ifndef __RK3288_CRYPTO_H__
>> +#define __RK3288_CRYPTO_H__
>> +
>> +#include <crypto/sha.h>
>> +#include <crypto/internal/hash.h>
>> +#include <crypto/aes.h>
>> +#include <crypto/des.h>
>> +#include <crypto/ctr.h>
>> +#include <crypto/algapi.h>
>> +#include <linux/interrupt.h>
>> +#include <linux/delay.h>
>> +
>> +#define _SBF(s, v)			((v) << (s))
> It will be more helpful to declare it _SBF(v, s) (you keep the order =
of parameter in the operation)
ok! done!
>> +#define _BIT(b)				_SBF(b, 1)
> Ouch, it seems that you redefined the official BIT() macro
ok! it will be removed and  BIT will take the place of _BIT.
>> +
>> +#define FLAGS_HASH_SHA1			_SBF(2, 0x00)
>> +#define FLAGS_HASH_MD5			_SBF(2, 0x01)
>> +#define FLAGS_HASH_SHA256		_SBF(2, 0x02)
>> +#define FLAGS_HASH_PRNG			_SBF(2, 0x03)
>> +
>> +/* Crypto control registers*/
>> +#define RK_CRYPTO_INTSTS		0x0000
>> +#define RK_CRYPTO_PKA_DONE_INT		_BIT(5)
>> +#define RK_CRYPTO_HASH_DONE_INT		_BIT(4)
>> +#define RK_CRYPTO_HRDMA_ERR_INT		_BIT(3)
>> +#define RK_CRYPTO_HRDMA_DONE_INT	_BIT(2)
>> +#define RK_CRYPTO_BCDMA_ERR_INT		_BIT(1)
>> +#define RK_CRYPTO_BCDMA_DONE_INT	_BIT(0)
>> +
>> +#define RK_CRYPTO_INTENA		0x0004
>> +#define RK_CRYPTO_PKA_DONE_ENA		_BIT(5)
>> +#define RK_CRYPTO_HASH_DONE_ENA		_BIT(4)
>> +#define RK_CRYPTO_HRDMA_ERR_ENA		_BIT(3)
>> +#define RK_CRYPTO_HRDMA_DONE_ENA	_BIT(2)
>> +#define RK_CRYPTO_BCDMA_ERR_ENA		_BIT(1)
>> +#define RK_CRYPTO_BCDMA_DONE_ENA	_BIT(0)
>> +
>> +#define RK_CRYPTO_CTRL			0x0008
>> +#define RK_CRYPTO_WRITE_MASK		(0xFFFF<<16)
>> +#define RK_CRYPTO_TRNG_FLUSH		_BIT(9)
>> +#define RK_CRYPTO_TRNG_START		_BIT(8)
>> +#define RK_CRYPTO_PKA_FLUSH		_BIT(7)
>> +#define RK_CRYPTO_HASH_FLUSH		_BIT(6)
>> +#define RK_CRYPTO_BLOCK_FLUSH		_BIT(5)
>> +#define RK_CRYPTO_PKA_START		_BIT(4)
>> +#define RK_CRYPTO_HASH_START		_BIT(3)
>> +#define RK_CRYPTO_BLOCK_START		_BIT(2)
>> +#define RK_CRYPTO_TDES_START		_BIT(1)
>> +#define RK_CRYPTO_AES_START		_BIT(0)
>> +
>> +#define RK_CRYPTO_CONF			0x000c
>> +/* HASH Receive DMA Address Mode:   fix | increment */
>> +#define RK_CRYPTO_HR_ADDR_MODE		_BIT(8)
>> +/* Block Transmit DMA Address Mode: fix | increment */
>> +#define RK_CRYPTO_BT_ADDR_MODE		_BIT(7)
>> +/* Block Receive DMA Address Mode:  fix | increment */
>> +#define RK_CRYPTO_BR_ADDR_MODE		_BIT(6)
>> +#define RK_CRYPTO_BYTESWAP_HRFIFO	_BIT(5)
>> +#define RK_CRYPTO_BYTESWAP_BTFIFO	_BIT(4)
>> +#define RK_CRYPTO_BYTESWAP_BRFIFO	_BIT(3)
>> +/* AES =3D 0 OR DES =3D 1 */
>> +#define RK_CRYPTO_DESSEL				_BIT(2)
>> +#define RK_CYYPTO_HASHINSEL_INDEPENDENT_SOURCE		_SBF(0, 0x00)
>> +#define RK_CYYPTO_HASHINSEL_BLOCK_CIPHER_INPUT		_SBF(0, 0x01)
>> +#define RK_CYYPTO_HASHINSEL_BLOCK_CIPHER_OUTPUT		_SBF(0, 0x02)
>> +
>> +/* Block Receiving DMA Start Address Register */
>> +#define RK_CRYPTO_BRDMAS		0x0010
>> +/* Block Transmitting DMA Start Address Register */
>> +#define RK_CRYPTO_BTDMAS		0x0014
>> +/* Block Receiving DMA Length Register */
>> +#define RK_CRYPTO_BRDMAL		0x0018
>> +/* Hash Receiving DMA Start Address Register */
>> +#define RK_CRYPTO_HRDMAS		0x001c
>> +/* Hash Receiving DMA Length Register */
>> +#define RK_CRYPTO_HRDMAL		0x0020
>> +
>> +/* AES registers */
>> +#define RK_CRYPTO_AES_CTRL			  0x0080
>> +#define RK_CRYPTO_AES_BYTESWAP_CNT	_BIT(11)
>> +#define RK_CRYPTO_AES_BYTESWAP_KEY	_BIT(10)
>> +#define RK_CRYPTO_AES_BYTESWAP_IV	_BIT(9)
>> +#define RK_CRYPTO_AES_BYTESWAP_DO	_BIT(8)
>> +#define RK_CRYPTO_AES_BYTESWAP_DI	_BIT(7)
>> +#define RK_CRYPTO_AES_KEY_CHANGE	_BIT(6)
>> +#define RK_CRYPTO_AES_ECB_MODE		_SBF(4, 0x00)
>> +#define RK_CRYPTO_AES_CBC_MODE		_SBF(4, 0x01)
>> +#define RK_CRYPTO_AES_CTR_MODE		_SBF(4, 0x02)
>> +#define RK_CRYPTO_AES_128_bit_key	_SBF(2, 0x00)
>> +#define RK_CRYPTO_AES_192_bit_key	_SBF(2, 0x01)
>> +#define RK_CRYPTO_AES_256_bit_key	_SBF(2, 0x02)
>> +/* Slave =3D 0 / fifo =3D 1 */
>> +#define RK_CRYPTO_AES_FIFO_MODE		_BIT(1)
>> +/* Encryption =3D 0 , Decryption =3D 1 */
>> +#define RK_CRYPTO_AES_DEC		_BIT(0)
>> +
>> +#define RK_CRYPTO_AES_STS		0x0084
>> +#define RK_CRYPTO_AES_DONE		_BIT(0)
>> +
>> +/* AES Input Data 0-3 Register */
>> +#define RK_CRYPTO_AES_DIN_0		0x0088
>> +#define RK_CRYPTO_AES_DIN_1		0x008c
>> +#define RK_CRYPTO_AES_DIN_2		0x0090
>> +#define RK_CRYPTO_AES_DIN_3		0x0094
>> +
>> +/* AES output Data 0-3 Register */
>> +#define RK_CRYPTO_AES_DOUT_0		0x0098
>> +#define RK_CRYPTO_AES_DOUT_1		0x009c
>> +#define RK_CRYPTO_AES_DOUT_2		0x00a0
>> +#define RK_CRYPTO_AES_DOUT_3		0x00a4
>> +
>> +/* AES IV Data 0-3 Register */
>> +#define RK_CRYPTO_AES_IV_0		0x00a8
>> +#define RK_CRYPTO_AES_IV_1		0x00ac
>> +#define RK_CRYPTO_AES_IV_2		0x00b0
>> +#define RK_CRYPTO_AES_IV_3		0x00b4
>> +
>> +/* AES Key Data 0-3 Register */
>> +#define RK_CRYPTO_AES_KEY_0		0x00b8
>> +#define RK_CRYPTO_AES_KEY_1		0x00bc
>> +#define RK_CRYPTO_AES_KEY_2		0x00c0
>> +#define RK_CRYPTO_AES_KEY_3		0x00c4
>> +#define RK_CRYPTO_AES_KEY_4		0x00c8
>> +#define RK_CRYPTO_AES_KEY_5		0x00cc
>> +#define RK_CRYPTO_AES_KEY_6		0x00d0
>> +#define RK_CRYPTO_AES_KEY_7		0x00d4
>> +
>> +/* AES Input Counter 0-3 Register */
>> +#define RK_CRYPTO_AES_CNT_0		0x00d8
>> +#define RK_CRYPTO_AES_CNT_1		0x00dc
>> +#define RK_CRYPTO_AES_CNT_2		0x00e0
>> +#define RK_CRYPTO_AES_CNT_3		0x00e4
>> +
>> +/* des/tdes */
>> +#define RK_CRYPTO_TDES_CTRL		0x0100
>> +#define RK_CRYPTO_TDES_BYTESWAP_KEY	_BIT(8)
>> +#define RK_CRYPTO_TDES_BYTESWAP_IV	_BIT(7)
>> +#define RK_CRYPTO_TDES_BYTESWAP_DO	_BIT(6)
>> +#define RK_CRYPTO_TDES_BYTESWAP_DI	_BIT(5)
>> +/* 0: ECB, 1: CBC */
>> +#define RK_CRYPTO_TDES_CHAINMODE	_BIT(4)
>> +/* TDES Key Mode, 0 : EDE, 1 : EEE */
>> +#define RK_CRYPTO_TDES_EEE		_BIT(3)
>> +/* 0: DES, 1:TDES */
>> +#define RK_CRYPTO_TDES_SELECT		_BIT(2)
>> +/* 0: Slave, 1:Fifo */
>> +#define RK_CRYPTO_TDES_FIFO_MODE	_BIT(1)
>> +/* Encryption =3D 0 , Decryption =3D 1 */
>> +#define RK_CRYPTO_TDES_DEC		_BIT(0)
>> +
>> +#define RK_CRYPTO_TDES_STS		0x0104
>> +#define RK_CRYPTO_TDES_DONE		_BIT(0)
>> +
>> +#define RK_CRYPTO_TDES_DIN_0		0x0108
>> +#define RK_CRYPTO_TDES_DIN_1		0x010c
>> +#define RK_CRYPTO_TDES_DOUT_0		0x0110
>> +#define RK_CRYPTO_TDES_DOUT_1		0x0114
>> +#define RK_CRYPTO_TDES_IV_0		0x0118
>> +#define RK_CRYPTO_TDES_IV_1		0x011c
>> +#define RK_CRYPTO_TDES_KEY1_0		0x0120
>> +#define RK_CRYPTO_TDES_KEY1_1		0x0124
>> +#define RK_CRYPTO_TDES_KEY2_0		0x0128
>> +#define RK_CRYPTO_TDES_KEY2_1		0x012c
>> +#define RK_CRYPTO_TDES_KEY3_0		0x0130
>> +#define RK_CRYPTO_TDES_KEY3_1		0x0134
>> +
>> +/* HASH */
>> +#define RK_CRYPTO_HASH_CTRL		0x0180
>> +#define RK_CRYPTO_HASH_SWAP_DO		_BIT(3)
>> +#define RK_CRYPTO_HASH_SWAP_DI		_BIT(2)
>> +#define RK_CRYPTO_HASH_SHA1		_SBF(0, 0x00)
>> +#define RK_CRYPTO_HASH_MD5		_SBF(0, 0x01)
>> +#define RK_CRYPTO_HASH_SHA256		_SBF(0, 0x02)
>> +#define RK_CRYPTO_HASH_PRNG		_SBF(0, 0x03)
>> +
>> +#define RK_CRYPTO_HASH_STS		0x0184
>> +#define RK_CRYPTO_HASH_DONE		_BIT(0)
>> +
>> +#define RK_CRYPTO_HASH_MSG_LEN		0x0188
>> +#define RK_CRYPTO_HASH_DOUT_0		0x018c
>> +#define RK_CRYPTO_HASH_DOUT_1		0x0190
>> +#define RK_CRYPTO_HASH_DOUT_2		0x0194
>> +#define RK_CRYPTO_HASH_DOUT_3		0x0198
>> +#define RK_CRYPTO_HASH_DOUT_4		0x019c
>> +#define RK_CRYPTO_HASH_DOUT_5		0x01a0
>> +#define RK_CRYPTO_HASH_DOUT_6		0x01a4
>> +#define RK_CRYPTO_HASH_DOUT_7		0x01a8
>> +#define RK_CRYPTO_HASH_SEED_0		0x01ac
>> +#define RK_CRYPTO_HASH_SEED_1		0x01b0
>> +#define RK_CRYPTO_HASH_SEED_2		0x01b4
>> +#define RK_CRYPTO_HASH_SEED_3		0x01b8
>> +#define RK_CRYPTO_HASH_SEED_4		0x01bc
>> +
>> +/* TRNG */
>> +#define RK_CRYPTO_TRNG_CTRL		0x0200
>> +#define RK_CRYPTO_OSC_ENABLE		_BIT(16)
>> +
>> +#define RK_CRYPTO_TRNG_DOUT_0		0x0204
>> +#define RK_CRYPTO_TRNG_DOUT_1		0x0208
>> +#define RK_CRYPTO_TRNG_DOUT_2		0x020c
>> +#define RK_CRYPTO_TRNG_DOUT_3		0x0210
>> +#define RK_CRYPTO_TRNG_DOUT_4		0x0214
>> +#define RK_CRYPTO_TRNG_DOUT_5		0x0218
>> +#define RK_CRYPTO_TRNG_DOUT_6		0x021c
>> +#define RK_CRYPTO_TRNG_DOUT_7		0x0220
>> +
>> +/* PAK OR RSA */
>> +#define RK_CRYPTO_PKA_CTRL			0x0280
>> +#define RK_CRYPTO_PKA_BLOCK_SIZE_512BIT		_SBF(0, 0x00)
>> +#define RK_CRYPTO_PKA_BLOCK_SIZE_1024BIT	_SBF(0, 0x01)
>> +#define RK_CRYPTO_PKA_BLOCK_SIZE_2048BIT	_SBF(0, 0x02)
>> +
>> +/* result =3D (M ^ E) mod N */
>> +#define RK_CRYPTO_PKA_M			0x0400
>> +/* C =3D 2 ^ (2n+2) mod N */
>> +#define RK_CRYPTO_PKA_C			0x0500
>> +#define RK_CRYPTO_PKA_N			0x0600
>> +#define RK_CRYPTO_PKA_E			0x0700
> You do not use thoses define anywhere
ok! it will be removed.
>> +
>> +#define CRYPTO_READ(dev, offset)		  \
>> +		__raw_readl(((dev)->reg + (offset)))
>> +#define CRYPTO_WRITE(dev, offset, val)	  \
>> +		__raw_writel((val), ((dev)->reg + (offset)))
> Why do you use __raw_readl/__raw_writel ?

They were used in s5p-sss.c, I will use readl_relaxed/writel_relaxed in=
stead of them.

>
>> +/* get register virt address */
>> +#define CRYPTO_GET_REG_VIRT(dev, offset)   ((dev)->reg + (offset))
>> +
>> +#define RK_ALIGN_MASK			(sizeof(u32)-1)
> You do not use those define anywhere
Ok! It will be removed.
>> +
>> +struct crypto_info_t {
>> +	struct device			*dev;
>> +	struct clk			*aclk;
>> +	struct clk			*hclk;
>> +	struct clk			*sclk;
>> +	struct clk			*dmaclk;
>> +	void __iomem			*reg;
>> +	int				irq;
>> +	struct crypto_queue		queue;
>> +	struct tasklet_struct		crypto_tasklet;
>> +	struct ahash_request		*ahash_req;
>> +	struct ablkcipher_request	*ablk_req;
>> +	spinlock_t			lock;
> You need to put a comment for saying what "lock" lock ?
> This hint should be see when you have use checkpatch --strict
ok! done!
I am sorry that i used checkpatch without --strict suffix.
I will carry it next.
>> +
>> +	/* the public variable */
>> +	struct scatterlist		*sg_src;
>> +	struct scatterlist		*sg_dst;
>> +	struct scatterlist		sg_tmp;
>> +	struct scatterlist		*first;
>> +	unsigned int			left_bytes;
>> +	char				*addr_vir;
> void * ?
ok! done!
>> +	int				aligned;
>> +	int				align_size;
>> +	size_t				nents;
>> +	unsigned int			total;
>> +	uint32_t			count;
>> +	uint32_t			mode;
>> +	dma_addr_t			addr_in;
>> +	dma_addr_t			addr_out;
>> +	int (*start)(struct crypto_info_t *dev);
>> +	int (*update)(struct crypto_info_t *dev);
>> +	void (*complete)(struct crypto_info_t *dev, int err);
>> +	int (*enable_clk)(struct crypto_info_t *dev);
>> +	void (*disable_clk)(struct crypto_info_t *dev);
>> +	int (*load_data)(struct crypto_info_t *dev,
>> +			  struct scatterlist *sg_src,
>> +			  struct scatterlist *sg_dst);
>> +	void (*unload_data)(struct crypto_info_t *dev);
>> +};
>> +
>> +/* the private variable of hash */
>> +struct rk_ahash_ctx {
>> +	struct crypto_info_t		*dev;
>> +	int				FLAG_FINUP;
>> +	int				first_op;
>> +};
> You add lots of things for hash, but you do not handle them.
> You will have people objecting that you need to add support for them =
or not (no half support).
ok! I want to support hash acceleration at beginning, but some problem
make me give it up temporarily.
I will remove them about hash.
>
>> +
>> +/* the private variable of cipher */
>> +struct rk_cipher_ctx {
>> +	struct crypto_info_t		*dev;
>> +	int				keylen;
>> +};
> keylen is unsigned int everywhere
ok! It will be removed.
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
>> index 0000000..b3de229
>> --- /dev/null
>> +++ b/drivers/crypto/rockchip/rk3288_crypto_ablkcipher.c
>> @@ -0,0 +1,501 @@
>> +/*
>> + *Crypto acceleration support for Rockchip RK3288
>> + *
>> + * Copyright (c) 2015, Fuzhou Rockchip Electronics Co., Ltd
>> + *
>> + * Author: Zain Wang <zain.wang@rock-chips.com>
>> + *
>> + * This program is free software; you can redistribute it and/or mo=
dify it
>> + * under the terms and conditions of the GNU General Public License=
,
>> + * version 2, as published by the Free Software Foundation.
>> + *
>> + * Some ideas are from marvell-cesa.c and s5p-sss.c driver.
>> + */
>> +#include "rk3288_crypto.h"
>> +
>> +#define RK_CRYPTO_DEC			_BIT(0)
>> +#define AES	0
>> +#define TDES	_BIT(16)
>> +
>> +static void rk_crypto_complete(struct crypto_info_t *dev, int err)
>> +{
>> +	if (dev->ablk_req->base.complete !=3D NULL) {
>> +		if (err)
>> +			dev_warn(dev->dev, "[%s:%d] err =3D %d\n",
>> +						__func__, __LINE__, err);
>> +		dev->ablk_req->base.complete(&dev->ablk_req->base, err);
>> +	}
>> +}
>> +
>> +static int rk_handle_req(struct ablkcipher_request *req, int alig_b=
ytes)
>> +{
>> +	struct crypto_ablkcipher *tfm =3D crypto_ablkcipher_reqtfm(req);
>> +	struct rk_cipher_ctx *ctx =3D crypto_ablkcipher_ctx(tfm);
>> +	struct crypto_info_t *dev =3D ctx->dev;
>> +	int err;
>> +
>> +	if (!IS_ALIGNED(req->nbytes, alig_bytes))
>> +		return -EINVAL;
>> +
>> +	spin_lock(&dev->lock);
>> +	err =3D ablkcipher_enqueue_request(&dev->queue, req);
>> +	spin_unlock(&dev->lock);
>> +	tasklet_schedule(&dev->crypto_tasklet);
>> +	return err;
>> +}
>> +
>> +static void rk_ablk_init(struct crypto_info_t *dev,
>> +				struct ablkcipher_request *req)
>> +{
>> +	dev->left_bytes =3D req->nbytes;
>> +	dev->total =3D req->nbytes;
>> +	dev->sg_src =3D req->src;
>> +	dev->first =3D req->src;
>> +	dev->nents =3D sg_nents(req->src);
>> +	dev->sg_dst =3D req->dst;
>> +	dev->aligned =3D 1;
>> +	dev->ablk_req =3D req;
>> +}
>> +
>> +static int rk_aes_setkey(struct crypto_ablkcipher *cipher,
>> +			const uint8_t *key, unsigned int keylen)
>> +{
> Prefer u8 instead of uint8_t
ok! done!
>> +	struct crypto_tfm *tfm =3D crypto_ablkcipher_tfm(cipher);
>> +	struct rk_cipher_ctx *ctx =3D crypto_tfm_ctx(tfm);
>> +
>> +	if (key =3D=3D NULL) {
> Prefer if (!key)
> do you have used checkpatch --strict ?
ok! done!
I will carry it next.
>> +		dev_err(ctx->dev->dev, "[%s:%d] no key error\n",
>> +						__func__, __LINE__);
>> +		return -EINVAL;
>> +	}
>> +
>> +	if (keylen !=3D AES_KEYSIZE_128 && keylen !=3D AES_KEYSIZE_192 &&
>> +	    keylen !=3D AES_KEYSIZE_256) {
>> +		crypto_ablkcipher_set_flags(cipher, CRYPTO_TFM_RES_BAD_KEY_LEN);
>> +		dev_err(ctx->dev->dev, "[%s:%d] expect key len =3D %d\n",
>> +						__func__, __LINE__, keylen);
>> +		return -EINVAL;
>> +	}
>> +	ctx->keylen =3D keylen;
>> +	memcpy(ctx->dev->reg + RK_CRYPTO_AES_KEY_0, key, keylen);
>> +	return 0;
>> +}
>> +
>> +static int rk_tdes_setkey(struct crypto_ablkcipher *cipher,
>> +			const uint8_t *key, unsigned int keylen)
>> +{
>> +	struct crypto_tfm *tfm =3D crypto_ablkcipher_tfm(cipher);
>> +	struct rk_cipher_ctx *ctx =3D crypto_tfm_ctx(tfm);
>> +
>> +	if (key =3D=3D NULL) {
>> +		dev_err(ctx->dev->dev, "[%s:%d] no key error\n",
>> +						__func__, __LINE__);
>> +		return -EINVAL;
>> +	}
>> +
>> +	if (keylen !=3D DES_KEY_SIZE && keylen !=3D DES3_EDE_KEY_SIZE) {
>> +		crypto_ablkcipher_set_flags(cipher, CRYPTO_TFM_RES_BAD_KEY_LEN);
>> +		dev_err(ctx->dev->dev, "[%s:%d] expect key len =3D %d\n",
>> +						__func__, __LINE__, keylen);
>> +		return -EINVAL;
>> +	}
>> +	ctx->keylen =3D keylen;
>> +	memcpy(ctx->dev->reg + RK_CRYPTO_TDES_KEY1_0, key, keylen);
>> +	return 0;
>> +}
> I am surprised to not see any weak key test for DES.
> I believed that it was necessary to test with modprobe tcrypt succesf=
ully.
Ok! I will add this function with des_ekey() next.
>> +
>> +static int rk_aes_ecb_encrypt(struct ablkcipher_request *req)
>> +{
>> +	struct crypto_ablkcipher *tfm =3D crypto_ablkcipher_reqtfm(req);
>> +	struct rk_cipher_ctx *ctx =3D crypto_ablkcipher_ctx(tfm);
>> +	struct crypto_info_t *dev =3D ctx->dev;
>> +
>> +	dev->mode =3D RK_CRYPTO_AES_ECB_MODE | AES;
>> +	rk_ablk_init(dev, req);
>> +	return rk_handle_req(req, dev->align_size);
>> +}
>> +
>> +static int rk_aes_ecb_decrypt(struct ablkcipher_request *req)
>> +{
>> +	struct crypto_ablkcipher *tfm =3D crypto_ablkcipher_reqtfm(req);
>> +	struct rk_cipher_ctx *ctx =3D crypto_ablkcipher_ctx(tfm);
>> +	struct crypto_info_t *dev =3D ctx->dev;
>> +
>> +	dev->mode =3D RK_CRYPTO_AES_ECB_MODE | RK_CRYPTO_DEC | AES;
>> +	rk_ablk_init(dev, req);
>> +	return rk_handle_req(req, dev->align_size);
>> +}
>> +
>> +static int rk_aes_cbc_encrypt(struct ablkcipher_request *req)
>> +{
>> +
>> +	struct crypto_ablkcipher *tfm =3D crypto_ablkcipher_reqtfm(req);
>> +	struct rk_cipher_ctx *ctx =3D crypto_ablkcipher_ctx(tfm);
>> +	struct crypto_info_t *dev =3D ctx->dev;
>> +
>> +	dev->mode =3D RK_CRYPTO_AES_CBC_MODE | AES;
>> +	rk_ablk_init(dev, req);
>> +	return rk_handle_req(req, dev->align_size);
>> +}
>> +
>> +static int rk_aes_cbc_decrypt(struct ablkcipher_request *req)
>> +{
>> +	struct crypto_ablkcipher *tfm =3D crypto_ablkcipher_reqtfm(req);
>> +	struct rk_cipher_ctx *ctx =3D crypto_ablkcipher_ctx(tfm);
>> +	struct crypto_info_t *dev =3D ctx->dev;
>> +
>> +	dev->mode =3D RK_CRYPTO_AES_CBC_MODE | RK_CRYPTO_DEC | AES;
>> +	rk_ablk_init(dev, req);
>> +	return rk_handle_req(req, dev->align_size);
>> +}
>> +
>> +static int rk_des_ecb_encrypt(struct ablkcipher_request *req)
>> +{
>> +	struct crypto_ablkcipher *tfm =3D crypto_ablkcipher_reqtfm(req);
>> +	struct rk_cipher_ctx *ctx =3D crypto_ablkcipher_ctx(tfm);
>> +	struct crypto_info_t *dev =3D ctx->dev;
>> +
>> +	dev->mode =3D TDES;
>> +	rk_ablk_init(dev, req);
>> +	return rk_handle_req(req, dev->align_size);
>> +}
>> +
>> +static int rk_des_ecb_decrypt(struct ablkcipher_request *req)
>> +{
>> +	struct crypto_ablkcipher *tfm =3D crypto_ablkcipher_reqtfm(req);
>> +	struct rk_cipher_ctx *ctx =3D crypto_ablkcipher_ctx(tfm);
>> +	struct crypto_info_t *dev =3D ctx->dev;
>> +
>> +	dev->mode =3D RK_CRYPTO_DEC | TDES;
>> +	rk_ablk_init(dev, req);
>> +	return rk_handle_req(req, dev->align_size);
>> +}
>> +
>> +static int rk_des_cbc_encrypt(struct ablkcipher_request *req)
>> +{
>> +	struct crypto_ablkcipher *tfm =3D crypto_ablkcipher_reqtfm(req);
>> +	struct rk_cipher_ctx *ctx =3D crypto_ablkcipher_ctx(tfm);
>> +	struct crypto_info_t *dev =3D ctx->dev;
>> +
>> +	dev->mode =3D RK_CRYPTO_TDES_CHAINMODE | TDES;
>> +	rk_ablk_init(dev, req);
>> +	return rk_handle_req(req, dev->align_size);
>> +}
>> +
>> +static int rk_des_cbc_decrypt(struct ablkcipher_request *req)
>> +{
>> +	struct crypto_ablkcipher *tfm =3D crypto_ablkcipher_reqtfm(req);
>> +	struct rk_cipher_ctx *ctx =3D crypto_ablkcipher_ctx(tfm);
>> +	struct crypto_info_t *dev =3D ctx->dev;
>> +
>> +	dev->mode =3D RK_CRYPTO_TDES_CHAINMODE | RK_CRYPTO_DEC | TDES;
>> +	rk_ablk_init(dev, req);
>> +	return rk_handle_req(req, dev->align_size);
>> +}
>> +
>> +static int rk_des3_ede_ecb_encrypt(struct ablkcipher_request *req)
>> +{
>> +	struct crypto_ablkcipher *tfm =3D crypto_ablkcipher_reqtfm(req);
>> +	struct rk_cipher_ctx *ctx =3D crypto_ablkcipher_ctx(tfm);
>> +	struct crypto_info_t *dev =3D ctx->dev;
>> +
>> +	dev->mode =3D RK_CRYPTO_TDES_SELECT | TDES;
>> +	rk_ablk_init(dev, req);
>> +	return rk_handle_req(req, dev->align_size);
>> +}
>> +
>> +static int rk_des3_ede_ecb_decrypt(struct ablkcipher_request *req)
>> +{
>> +	struct crypto_ablkcipher *tfm =3D crypto_ablkcipher_reqtfm(req);
>> +	struct rk_cipher_ctx *ctx =3D crypto_ablkcipher_ctx(tfm);
>> +	struct crypto_info_t *dev =3D ctx->dev;
>> +
>> +	dev->mode =3D RK_CRYPTO_TDES_SELECT | RK_CRYPTO_DEC | TDES;
>> +	rk_ablk_init(dev, req);
>> +	return rk_handle_req(req, dev->align_size);
>> +}
>> +
>> +static int rk_des3_ede_cbc_encrypt(struct ablkcipher_request *req)
>> +{
>> +	struct crypto_ablkcipher *tfm =3D crypto_ablkcipher_reqtfm(req);
>> +	struct rk_cipher_ctx *ctx =3D crypto_ablkcipher_ctx(tfm);
>> +	struct crypto_info_t *dev =3D ctx->dev;
>> +
>> +	dev->mode =3D RK_CRYPTO_TDES_SELECT | RK_CRYPTO_TDES_CHAINMODE | T=
DES;
>> +	rk_ablk_init(dev, req);
>> +	return rk_handle_req(req, dev->align_size);
>> +}
>> +
>> +static int rk_des3_ede_cbc_decrypt(struct ablkcipher_request *req)
>> +{
>> +	struct crypto_ablkcipher *tfm =3D crypto_ablkcipher_reqtfm(req);
>> +	struct rk_cipher_ctx *ctx =3D crypto_ablkcipher_ctx(tfm);
>> +	struct crypto_info_t *dev =3D ctx->dev;
>> +
>> +	dev->mode =3D RK_CRYPTO_TDES_SELECT | RK_CRYPTO_TDES_CHAINMODE |
>> +		    RK_CRYPTO_DEC | TDES;
>> +	rk_ablk_init(dev, req);
>> +	return rk_handle_req(req, dev->align_size);
>> +}
>> +
>> +static void rk_ablk_hw_init(struct crypto_info_t *dev)
>> +{
>> +	struct crypto_ablkcipher *tfm =3D crypto_ablkcipher_reqtfm(dev->ab=
lk_req);
>> +	struct rk_cipher_ctx *ctx =3D crypto_ablkcipher_ctx(tfm);
>> +	uint32_t conf_reg =3D 0;
>> +
>> +	if (dev->mode & TDES) {
>> +		dev->mode &=3D ~TDES;
>> +		dev->mode |=3D RK_CRYPTO_TDES_FIFO_MODE |
>> +			     RK_CRYPTO_TDES_BYTESWAP_KEY |
>> +			     RK_CRYPTO_TDES_BYTESWAP_IV;
>> +		CRYPTO_WRITE(dev, RK_CRYPTO_TDES_CTRL, dev->mode);
>> +
>> +		memcpy(dev->reg + RK_CRYPTO_TDES_IV_0, dev->ablk_req->info, 8);
>> +		conf_reg =3D RK_CRYPTO_DESSEL;
>> +	} else {
>> +		dev->mode |=3D RK_CRYPTO_AES_FIFO_MODE |
>> +			     RK_CRYPTO_AES_KEY_CHANGE |
>> +			     RK_CRYPTO_AES_BYTESWAP_KEY |
>> +			     RK_CRYPTO_AES_BYTESWAP_IV;
>> +
>> +		if (ctx->keylen =3D=3D AES_KEYSIZE_192)
>> +			dev->mode |=3D RK_CRYPTO_AES_192_bit_key;
>> +		else if (ctx->keylen =3D=3D AES_KEYSIZE_256)
>> +			dev->mode |=3D RK_CRYPTO_AES_256_bit_key;
>> +
>> +		CRYPTO_WRITE(dev, RK_CRYPTO_AES_CTRL, dev->mode);
>> +
>> +		memcpy(dev->reg + RK_CRYPTO_AES_IV_0, dev->ablk_req->info, 16);
>> +	}
>> +	conf_reg |=3D RK_CRYPTO_BYTESWAP_BTFIFO |
>> +		    RK_CRYPTO_BYTESWAP_BRFIFO;
>> +	CRYPTO_WRITE(dev, RK_CRYPTO_CONF, conf_reg);
>> +	CRYPTO_WRITE(dev, RK_CRYPTO_INTENA,
>> +		     RK_CRYPTO_BCDMA_ERR_ENA | RK_CRYPTO_BCDMA_DONE_ENA);
>> +}
>> +
>> +static void crypto_dma_start(struct crypto_info_t *dev)
>> +{
>> +	CRYPTO_WRITE(dev, RK_CRYPTO_BRDMAS, dev->addr_in);
>> +	CRYPTO_WRITE(dev, RK_CRYPTO_BRDMAL, dev->count / 4);
>> +	CRYPTO_WRITE(dev, RK_CRYPTO_BTDMAS, dev->addr_out);
>> +	CRYPTO_WRITE(dev, RK_CRYPTO_CTRL, RK_CRYPTO_BLOCK_START |
>> +			(RK_CRYPTO_BLOCK_START << 16));
>> +}
>> +
>> +static int rk_set_data_start(struct crypto_info_t *dev)
>> +{
>> +	int err;
>> +
>> +	err =3D dev->load_data(dev, dev->sg_src, dev->sg_dst);
>> +	if (!err)
>> +		crypto_dma_start(dev);
>> +	return err;
>> +}
>> +
>> +static int rk_ablk_start(struct crypto_info_t *dev)
>> +{
>> +	int err;
>> +
>> +	spin_lock(&dev->lock);
>> +	rk_ablk_hw_init(dev);
>> +	err =3D rk_set_data_start(dev);
>> +	spin_unlock(&dev->lock);
>> +	return err;
>> +}
>> +/* return:
>> + *	true	some err was occurred
>> + *	fault	no err, please continue
>> + */
>> +static int rk_ablk_rx(struct crypto_info_t *dev)
>> +{
>> +	int err =3D 0;
>> +
>> +	dev->unload_data(dev);
>> +	if (!dev->aligned) {
>> +		if (!sg_pcopy_from_buffer(dev->ablk_req->dst, dev->nents,
>> +					  dev->addr_vir, dev->count,
>> +					  dev->total - dev->left_bytes -
>> +					  dev->count)) {
>> +			err =3D -EINVAL;
>> +			goto out_rx;
>> +		}
>> +	}
>> +	if (dev->left_bytes) {
>> +		if (dev->aligned) {
>> +			if (sg_is_last(dev->sg_src)) {
>> +				dev_warn(dev->dev, "[%s:%d], lack of data\n",
>> +							__func__, __LINE__);
>> +				err =3D -ENOMEM;
>> +				goto out_rx;
>> +			}
>> +			dev->sg_src =3D sg_next(dev->sg_src);
>> +			dev->sg_dst =3D sg_next(dev->sg_dst);
>> +		}
>> +		err =3D rk_set_data_start(dev);
>> +	} else {
>> +		/* here show the calculation is over without any err */
>> +		dev->complete(dev, 0);
>> +	}
>> +out_rx:
>> +	return err;
>> +}
>> +
>> +static int rk_ablk_cra_init(struct crypto_tfm *tfm)
>> +{
>> +	struct rk_cipher_ctx *ctx =3D crypto_tfm_ctx(tfm);
>> +
>> +	ctx->dev =3D crypto_p;
>> +	ctx->dev->align_size =3D crypto_tfm_alg_alignmask(tfm) + 1;
>> +	ctx->dev->start =3D rk_ablk_start;
>> +	ctx->dev->update =3D rk_ablk_rx;
>> +	ctx->dev->complete =3D rk_crypto_complete;
>> +	ctx->dev->addr_vir =3D (void *)__get_free_page(GFP_KERNEL);
>> +
>> +	return ctx->dev->addr_vir ? ctx->dev->enable_clk(ctx->dev) : -ENOM=
EM;
>> +}
>> +
>> +static void rk_ablk_cra_exit(struct crypto_tfm *tfm)
>> +{
>> +	struct rk_cipher_ctx *ctx =3D crypto_tfm_ctx(tfm);
>> +
>> +	free_page((unsigned long)ctx->dev->addr_vir);
>> +	ctx->dev->disable_clk(ctx->dev);
>> +}
>> +
>> +struct crypto_alg rk_ecb_aes_alg =3D {
>> +	.cra_name		=3D "ecb(aes)",
>> +	.cra_driver_name	=3D "ecb-aes-rk",
>> +	.cra_priority		=3D 300,
>> +	.cra_flags		=3D CRYPTO_ALG_TYPE_ABLKCIPHER |
>> +				  CRYPTO_ALG_ASYNC,
>> +	.cra_blocksize		=3D AES_BLOCK_SIZE,
>> +	.cra_ctxsize		=3D sizeof(struct rk_cipher_ctx),
>> +	.cra_alignmask		=3D 0x0f,
>> +	.cra_type		=3D &crypto_ablkcipher_type,
>> +	.cra_module		=3D THIS_MODULE,
>> +	.cra_init		=3D rk_ablk_cra_init,
>> +	.cra_exit		=3D rk_ablk_cra_exit,
>> +	.cra_u.ablkcipher	=3D {
>> +		.min_keysize	=3D AES_MIN_KEY_SIZE,
>> +		.max_keysize	=3D AES_MAX_KEY_SIZE,
>> +		.setkey		=3D rk_aes_setkey,
>> +		.encrypt	=3D rk_aes_ecb_encrypt,
>> +		.decrypt	=3D rk_aes_ecb_decrypt,
>> +	}
>> +};
>> +
>> +struct crypto_alg rk_cbc_aes_alg =3D {
>> +	.cra_name		=3D "cbc(aes)",
>> +	.cra_driver_name	=3D "cbc-aes-rk",
>> +	.cra_priority		=3D 300,
>> +	.cra_flags		=3D CRYPTO_ALG_TYPE_ABLKCIPHER |
>> +				  CRYPTO_ALG_ASYNC,
>> +	.cra_blocksize		=3D AES_BLOCK_SIZE,
>> +	.cra_ctxsize		=3D sizeof(struct rk_cipher_ctx),
>> +	.cra_alignmask		=3D 0x0f,
>> +	.cra_type		=3D &crypto_ablkcipher_type,
>> +	.cra_module		=3D THIS_MODULE,
>> +	.cra_init		=3D rk_ablk_cra_init,
>> +	.cra_exit		=3D rk_ablk_cra_exit,
>> +	.cra_u.ablkcipher	=3D {
>> +		.min_keysize	=3D AES_MIN_KEY_SIZE,
>> +		.max_keysize	=3D AES_MAX_KEY_SIZE,
>> +		.ivsize		=3D AES_BLOCK_SIZE,
>> +		.setkey		=3D rk_aes_setkey,
>> +		.encrypt	=3D rk_aes_cbc_encrypt,
>> +		.decrypt	=3D rk_aes_cbc_decrypt,
>> +	}
>> +};
>> +
>> +struct crypto_alg rk_ecb_des_alg =3D {
>> +	.cra_name		=3D "ecb(des)",
>> +	.cra_driver_name	=3D "ecb-des-rk",
>> +	.cra_priority		=3D 300,
>> +	.cra_flags		=3D CRYPTO_ALG_TYPE_ABLKCIPHER |
>> +				  CRYPTO_ALG_ASYNC,
>> +	.cra_blocksize		=3D DES_BLOCK_SIZE,
>> +	.cra_ctxsize		=3D sizeof(struct rk_cipher_ctx),
>> +	.cra_alignmask		=3D 0x07,
>> +	.cra_type		=3D &crypto_ablkcipher_type,
>> +	.cra_module		=3D THIS_MODULE,
>> +	.cra_init		=3D rk_ablk_cra_init,
>> +	.cra_exit		=3D rk_ablk_cra_exit,
>> +	.cra_u.ablkcipher	=3D {
>> +		.min_keysize	=3D DES_KEY_SIZE,
>> +		.max_keysize	=3D DES_KEY_SIZE,
>> +		.setkey		=3D rk_tdes_setkey,
>> +		.encrypt	=3D rk_des_ecb_encrypt,
>> +		.decrypt	=3D rk_des_ecb_decrypt,
>> +	}
>> +};
>> +
>> +struct crypto_alg rk_cbc_des_alg =3D {
>> +	.cra_name		=3D "cbc(des)",
>> +	.cra_driver_name	=3D "cbc-des-rk",
>> +	.cra_priority		=3D 300,
>> +	.cra_flags		=3D CRYPTO_ALG_TYPE_ABLKCIPHER |
>> +				  CRYPTO_ALG_ASYNC,
>> +	.cra_blocksize		=3D DES_BLOCK_SIZE,
>> +	.cra_ctxsize		=3D sizeof(struct rk_cipher_ctx),
>> +	.cra_alignmask		=3D 0x07,
>> +	.cra_type		=3D &crypto_ablkcipher_type,
>> +	.cra_module		=3D THIS_MODULE,
>> +	.cra_init		=3D rk_ablk_cra_init,
>> +	.cra_exit		=3D rk_ablk_cra_exit,
>> +	.cra_u.ablkcipher	=3D {
>> +		.min_keysize	=3D DES_KEY_SIZE,
>> +		.max_keysize	=3D DES_KEY_SIZE,
>> +		.ivsize		=3D DES_BLOCK_SIZE,
>> +		.setkey		=3D rk_tdes_setkey,
>> +		.encrypt	=3D rk_des_cbc_encrypt,
>> +		.decrypt	=3D rk_des_cbc_decrypt,
>> +	}
>> +};
>> +
>> +struct crypto_alg rk_ecb_des3_ede_alg =3D {
>> +	.cra_name		=3D "ecb(des3_ede)",
>> +	.cra_driver_name	=3D "ecb-des3-ede-rk",
>> +	.cra_priority		=3D 300,
>> +	.cra_flags		=3D CRYPTO_ALG_TYPE_ABLKCIPHER |
>> +				  CRYPTO_ALG_ASYNC,
>> +	.cra_blocksize		=3D DES_BLOCK_SIZE,
>> +	.cra_ctxsize		=3D sizeof(struct rk_cipher_ctx),
>> +	.cra_alignmask		=3D 0x07,
>> +	.cra_type		=3D &crypto_ablkcipher_type,
>> +	.cra_module		=3D THIS_MODULE,
>> +	.cra_init		=3D rk_ablk_cra_init,
>> +	.cra_exit		=3D rk_ablk_cra_exit,
>> +	.cra_u.ablkcipher	=3D {
>> +		.min_keysize	=3D DES3_EDE_KEY_SIZE,
>> +		.max_keysize	=3D DES3_EDE_KEY_SIZE,
>> +		.ivsize		=3D DES_BLOCK_SIZE,
>> +		.setkey		=3D rk_tdes_setkey,
>> +		.encrypt	=3D rk_des3_ede_ecb_encrypt,
>> +		.decrypt	=3D rk_des3_ede_ecb_decrypt,
>> +	}
>> +};
>> +
>> +struct crypto_alg rk_cbc_des3_ede_alg =3D {
>> +	.cra_name		=3D "cbc(des3_ede)",
>> +	.cra_driver_name	=3D "cbc-des3-ede-rk",
>> +	.cra_priority		=3D 300,
>> +	.cra_flags		=3D CRYPTO_ALG_TYPE_ABLKCIPHER |
>> +				  CRYPTO_ALG_ASYNC,
>> +	.cra_blocksize		=3D DES_BLOCK_SIZE,
>> +	.cra_ctxsize		=3D sizeof(struct rk_cipher_ctx),
>> +	.cra_alignmask		=3D 0x07,
>> +	.cra_type		=3D &crypto_ablkcipher_type,
>> +	.cra_module		=3D THIS_MODULE,
>> +	.cra_init		=3D rk_ablk_cra_init,
>> +	.cra_exit		=3D rk_ablk_cra_exit,
>> +	.cra_u.ablkcipher	=3D {
>> +		.min_keysize	=3D DES3_EDE_KEY_SIZE,
>> +		.max_keysize	=3D DES3_EDE_KEY_SIZE,
>> +		.ivsize		=3D DES_BLOCK_SIZE,
>> +		.setkey		=3D rk_tdes_setkey,
>> +		.encrypt	=3D rk_des3_ede_cbc_encrypt,
>> +		.decrypt	=3D rk_des3_ede_cbc_decrypt,
>> +	}
>> +};
>> --=20
>> 1.9.1
>>
>>
> Regards
>
> LABBE Corentin
>
>
>
Thanks
Zain
