From: Caesar Wang <caesar.upstream@gmail.com>
Subject: Re: [PATCH v2 1/4] Crypto: Crypto driver support aes/des/des3 for
 rk3288
Date: Fri, 6 Nov 2015 09:54:22 +0800
Message-ID: <563C084E.6070101@gmail.com>
References: <1446772644-2352-1-git-send-email-zain.wang@rock-chips.com>
 <1446772644-2352-2-git-send-email-zain.wang@rock-chips.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: zhengsq@rock-chips.com, hl@rock-chips.com,
	herbert@gondor.apana.org.au, davem@davemloft.net,
	mturquette@baylibre.com, heiko@sntech.de, pawel.moll@arm.com,
	ijc+devicetree@hellion.org.uk, robh+dt@kernel.org,
	galak@codeaurora.org, linux@arm.linux.org.uk, mark.rutland@arm.com,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-rockchip@lists.infradead.org, eddie.cai@rock-chips.com,
	linux-crypto@vger.kernel.org
To: Zain Wang <zain.wang@rock-chips.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pa0-f68.google.com ([209.85.220.68]:35738 "EHLO
	mail-pa0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965936AbbKFByn (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 5 Nov 2015 20:54:43 -0500
In-Reply-To: <1446772644-2352-2-git-send-email-zain.wang@rock-chips.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

I guess the subject:
"crypto: rockchip: ...."

Maybe better.

=E5=9C=A8 2015=E5=B9=B411=E6=9C=8806=E6=97=A5 09:17, Zain Wang =E5=86=99=
=E9=81=93:
> The names registered are:
>      ecb(aes) cbc(aes) ecb(des) cbc(des) ecb(des3_ede) cbc(des3_ede)
> You can alloc tags above in your case.
>
> And other algorithms and platforms will be added later on.
>
> Signed-off-by: Zain Wang <zain.wang@rock-chips.com>
> ---
>
> Changed in v2:
> - remove some part about hash
> - add weak key detection
> - changed some variate's type
>
> Changde in v1:
> - modify some variate's name
> - modify some variate's type
> - modify some return value
> - remove or modify some print info
> - use more dev_xxx in probe
> - modify the prio of cipher

[...]

> +static int rk_crypto_remove(struct platform_device *pdev)
> +{
> +	struct crypto_info_t *crypto_tmp =3D platform_get_drvdata(pdev);
> +
> +	rk_crypto_unregister();
> +	tasklet_kill(&crypto_tmp->crypto_tasklet);
> +	free_irq(crypto_tmp->irq, crypto_tmp);
> +	crypto_p =3D NULL;
> +
> +	return 0;
> +}
> +
> +#ifdef CONFIG_OF
> +static const struct of_device_id crypto_of_id_table[] =3D {
> +	{ .compatible =3D "rockchip,rk3288-crypto" },
> +	{}
> +};
> +#endif /* CONFIG_OF */

I see the rk3368/ rk32xx SoCs the crypto seem the same IP.
So,
I guess we should put the "of_device_id"  before the device probe since=
=20
we should can compatible for more SoCs.

Others, for example the commit need a bit change.

> +
> +static struct platform_driver crypto_driver =3D {
> +	.probe		=3D rk_crypto_probe,
> +	.remove		=3D rk_crypto_remove,
> +	.driver		=3D {
> +		.name	=3D "rockchip,rk3288-crypto",
> +		.of_match_table	=3D of_match_ptr(crypto_of_id_table),
> +	},
> +};
> +
> +module_platform_driver(crypto_driver);
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Zain Wang");
> diff --git a/drivers/crypto/rockchip/rk3288_crypto.h b/drivers/crypto=
/rockchip/rk3288_crypto.h
> new file mode 100644
> index 0000000..cf4cd18
> --- /dev/null
> +++ b/drivers/crypto/rockchip/rk3288_crypto.h
> @@ -0,0 +1,222 @@
> +#ifndef __RK3288_CRYPTO_H__
> +#define __RK3288_CRYPTO_H__
> +
> +#include <crypto/sha.h>
> +#include <crypto/aes.h>
> +#include <crypto/des.h>
> +#include <crypto/ctr.h>
> +#include <crypto/algapi.h>
> +#include <linux/interrupt.h>
> +#include <linux/delay.h>
> +
> +#define _SBF(v, f)			((v) << (f))
> +
> +/* Crypto control registers*/
> +#define RK_CRYPTO_INTSTS		0x0000
> +#define RK_CRYPTO_PKA_DONE_INT		BIT(5)
> +#define RK_CRYPTO_HASH_DONE_INT		BIT(4)
> +#define RK_CRYPTO_HRDMA_ERR_INT		BIT(3)
> +#define RK_CRYPTO_HRDMA_DONE_INT	BIT(2)
> +#define RK_CRYPTO_BCDMA_ERR_INT		BIT(1)
> +#define RK_CRYPTO_BCDMA_DONE_INT	BIT(0)
> +
> +#define RK_CRYPTO_INTENA		0x0004
> +#define RK_CRYPTO_PKA_DONE_ENA		BIT(5)
> +#define RK_CRYPTO_HASH_DONE_ENA		BIT(4)
> +#define RK_CRYPTO_HRDMA_ERR_ENA		BIT(3)
> +#define RK_CRYPTO_HRDMA_DONE_ENA	BIT(2)
> +#define RK_CRYPTO_BCDMA_ERR_ENA		BIT(1)
> +#define RK_CRYPTO_BCDMA_DONE_ENA	BIT(0)
> +
> +#define RK_CRYPTO_CTRL			0x0008
> +#define RK_CRYPTO_WRITE_MASK		(0xFFFF << 16)
> +#define RK_CRYPTO_TRNG_FLUSH		BIT(9)
> +#define RK_CRYPTO_TRNG_START		BIT(8)
> +#define RK_CRYPTO_PKA_FLUSH		BIT(7)
> +#define RK_CRYPTO_HASH_FLUSH		BIT(6)
> +#define RK_CRYPTO_BLOCK_FLUSH		BIT(5)
> +#define RK_CRYPTO_PKA_START		BIT(4)
> +#define RK_CRYPTO_HASH_START		BIT(3)
> +#define RK_CRYPTO_BLOCK_START		BIT(2)
> +#define RK_CRYPTO_TDES_START		BIT(1)
> +#define RK_CRYPTO_AES_START		BIT(0)
> +
> +#define RK_CRYPTO_CONF			0x000c
> +/* HASH Receive DMA Address Mode:   fix | increment */
> +#define RK_CRYPTO_HR_ADDR_MODE		BIT(8)
> +/* Block Transmit DMA Address Mode: fix | increment */
> +#define RK_CRYPTO_BT_ADDR_MODE		BIT(7)
> +/* Block Receive DMA Address Mode:  fix | increment */
> +#define RK_CRYPTO_BR_ADDR_MODE		BIT(6)
> +#define RK_CRYPTO_BYTESWAP_HRFIFO	BIT(5)
> +#define RK_CRYPTO_BYTESWAP_BTFIFO	BIT(4)
> +#define RK_CRYPTO_BYTESWAP_BRFIFO	BIT(3)
> +/* AES =3D 0 OR DES =3D 1 */
> +#define RK_CRYPTO_DESSEL				BIT(2)
> +#define RK_CYYPTO_HASHINSEL_INDEPENDENT_SOURCE		_SBF(0x00, 0)
> +#define RK_CYYPTO_HASHINSEL_BLOCK_CIPHER_INPUT		_SBF(0x01, 0)
> +#define RK_CYYPTO_HASHINSEL_BLOCK_CIPHER_OUTPUT		_SBF(0x02, 0)
> +
> +/* Block Receiving DMA Start Address Register */
> +#define RK_CRYPTO_BRDMAS		0x0010
> +/* Block Transmitting DMA Start Address Register */
> +#define RK_CRYPTO_BTDMAS		0x0014
> +/* Block Receiving DMA Length Register */
> +#define RK_CRYPTO_BRDMAL		0x0018
> +/* Hash Receiving DMA Start Address Register */
> +#define RK_CRYPTO_HRDMAS		0x001c
> +/* Hash Receiving DMA Length Register */
> +#define RK_CRYPTO_HRDMAL		0x0020
> +
> +/* AES registers */
> +#define RK_CRYPTO_AES_CTRL			  0x0080
> +#define RK_CRYPTO_AES_BYTESWAP_CNT	BIT(11)
> +#define RK_CRYPTO_AES_BYTESWAP_KEY	BIT(10)
> +#define RK_CRYPTO_AES_BYTESWAP_IV	BIT(9)
> +#define RK_CRYPTO_AES_BYTESWAP_DO	BIT(8)
> +#define RK_CRYPTO_AES_BYTESWAP_DI	BIT(7)
> +#define RK_CRYPTO_AES_KEY_CHANGE	BIT(6)
> +#define RK_CRYPTO_AES_ECB_MODE		_SBF(0x00, 4)
> +#define RK_CRYPTO_AES_CBC_MODE		_SBF(0x01, 4)
> +#define RK_CRYPTO_AES_CTR_MODE		_SBF(0x02, 4)
> +#define RK_CRYPTO_AES_128BIT_key	_SBF(0x00, 2)
> +#define RK_CRYPTO_AES_192BIT_key	_SBF(0x01, 2)
> +#define RK_CRYPTO_AES_256BIT_key	_SBF(0x02, 2)
> +/* Slave =3D 0 / fifo =3D 1 */
> +#define RK_CRYPTO_AES_FIFO_MODE		BIT(1)
> +/* Encryption =3D 0 , Decryption =3D 1 */
> +#define RK_CRYPTO_AES_DEC		BIT(0)
> +
> +#define RK_CRYPTO_AES_STS		0x0084
> +#define RK_CRYPTO_AES_DONE		BIT(0)
> +
> +/* AES Input Data 0-3 Register */
> +#define RK_CRYPTO_AES_DIN_0		0x0088
> +#define RK_CRYPTO_AES_DIN_1		0x008c
> +#define RK_CRYPTO_AES_DIN_2		0x0090
> +#define RK_CRYPTO_AES_DIN_3		0x0094
> +
> +/* AES output Data 0-3 Register */
> +#define RK_CRYPTO_AES_DOUT_0		0x0098
> +#define RK_CRYPTO_AES_DOUT_1		0x009c
> +#define RK_CRYPTO_AES_DOUT_2		0x00a0
> +#define RK_CRYPTO_AES_DOUT_3		0x00a4
> +
> +/* AES IV Data 0-3 Register */
> +#define RK_CRYPTO_AES_IV_0		0x00a8
> +#define RK_CRYPTO_AES_IV_1		0x00ac
> +#define RK_CRYPTO_AES_IV_2		0x00b0
> +#define RK_CRYPTO_AES_IV_3		0x00b4
> +
> +/* AES Key Data 0-3 Register */
> +#define RK_CRYPTO_AES_KEY_0		0x00b8
> +#define RK_CRYPTO_AES_KEY_1		0x00bc
> +#define RK_CRYPTO_AES_KEY_2		0x00c0
> +#define RK_CRYPTO_AES_KEY_3		0x00c4
> +#define RK_CRYPTO_AES_KEY_4		0x00c8
> +#define RK_CRYPTO_AES_KEY_5		0x00cc
> +#define RK_CRYPTO_AES_KEY_6		0x00d0
> +#define RK_CRYPTO_AES_KEY_7		0x00d4
> +
> +/* AES Input Counter 0-3 Register */
> +#define RK_CRYPTO_AES_CNT_0		0x00d8
> +#define RK_CRYPTO_AES_CNT_1		0x00dc
> +#define RK_CRYPTO_AES_CNT_2		0x00e0
> +#define RK_CRYPTO_AES_CNT_3		0x00e4
> +
> +/* des/tdes */
> +#define RK_CRYPTO_TDES_CTRL		0x0100
> +#define RK_CRYPTO_TDES_BYTESWAP_KEY	BIT(8)
> +#define RK_CRYPTO_TDES_BYTESWAP_IV	BIT(7)
> +#define RK_CRYPTO_TDES_BYTESWAP_DO	BIT(6)
> +#define RK_CRYPTO_TDES_BYTESWAP_DI	BIT(5)
> +/* 0: ECB, 1: CBC */
> +#define RK_CRYPTO_TDES_CHAINMODE	BIT(4)
> +/* TDES Key Mode, 0 : EDE, 1 : EEE */
> +#define RK_CRYPTO_TDES_EEE		BIT(3)
> +/* 0: DES, 1:TDES */
> +#define RK_CRYPTO_TDES_SELECT		BIT(2)
> +/* 0: Slave, 1:Fifo */
> +#define RK_CRYPTO_TDES_FIFO_MODE	BIT(1)
> +/* Encryption =3D 0 , Decryption =3D 1 */
> +#define RK_CRYPTO_TDES_DEC		BIT(0)
> +
> +#define RK_CRYPTO_TDES_STS		0x0104
> +#define RK_CRYPTO_TDES_DONE		BIT(0)
> +
> +#define RK_CRYPTO_TDES_DIN_0		0x0108
> +#define RK_CRYPTO_TDES_DIN_1		0x010c
> +#define RK_CRYPTO_TDES_DOUT_0		0x0110
> +#define RK_CRYPTO_TDES_DOUT_1		0x0114
> +#define RK_CRYPTO_TDES_IV_0		0x0118
> +#define RK_CRYPTO_TDES_IV_1		0x011c
> +#define RK_CRYPTO_TDES_KEY1_0		0x0120
> +#define RK_CRYPTO_TDES_KEY1_1		0x0124
> +#define RK_CRYPTO_TDES_KEY2_0		0x0128
> +#define RK_CRYPTO_TDES_KEY2_1		0x012c
> +#define RK_CRYPTO_TDES_KEY3_0		0x0130
> +#define RK_CRYPTO_TDES_KEY3_1		0x0134
> +
> +#define CRYPTO_READ(dev, offset)		  \
> +		readl_relaxed(((dev)->reg + (offset)))
> +#define CRYPTO_WRITE(dev, offset, val)	  \
> +		writel_relaxed((val), ((dev)->reg + (offset)))
> +/* get register virt address */
> +#define CRYPTO_GET_REG_VIRT(dev, offset)   ((dev)->reg + (offset))
> +
> +struct crypto_info_t {
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
> diff --git a/drivers/crypto/rockchip/rk3288_crypto_ablkcipher.c b/dri=
vers/crypto/rockchip/rk3288_crypto_ablkcipher.c
> new file mode 100644
> index 0000000..28b49c9
> --- /dev/null
> +++ b/drivers/crypto/rockchip/rk3288_crypto_ablkcipher.c
> @@ -0,0 +1,511 @@
> +/*
> + *Crypto acceleration support for Rockchip RK3288
> + *
> + * Copyright (c) 2015, Fuzhou Rockchip Electronics Co., Ltd
> + *
> + * Author: Zain Wang <zain.wang@rock-chips.com>
> + *
> + * This program is free software; you can redistribute it and/or mod=
ify it
> + * under the terms and conditions of the GNU General Public License,
> + * version 2, as published by the Free Software Foundation.
> + *
> + * Some ideas are from marvell-cesa.c and s5p-sss.c driver.
> + */
> +#include "rk3288_crypto.h"
> +
> +#define RK_CRYPTO_DEC			BIT(0)
> +#define AES	0
> +#define TDES	BIT(16)
> +
> +static void rk_crypto_complete(struct crypto_info_t *dev, int err)
> +{
> +	if (dev->ablk_req->base.complete) {
> +		if (err)
> +			dev_warn(dev->dev, "[%s:%d] err =3D %d\n",
> +				 __func__, __LINE__, err);
> +		dev->ablk_req->base.complete(&dev->ablk_req->base, err);
> +	}
> +}
> +
> +static int rk_handle_req(struct ablkcipher_request *req, int alig_by=
tes)
> +{
> +	struct crypto_ablkcipher *tfm =3D crypto_ablkcipher_reqtfm(req);
> +	struct rk_cipher_ctx *ctx =3D crypto_ablkcipher_ctx(tfm);
> +	struct crypto_info_t *dev =3D ctx->dev;
> +	int err;
> +
> +	if (!IS_ALIGNED(req->nbytes, alig_bytes))
> +		return -EINVAL;
> +
> +	spin_lock(&dev->lock);
> +	err =3D ablkcipher_enqueue_request(&dev->queue, req);
> +	spin_unlock(&dev->lock);
> +	tasklet_schedule(&dev->crypto_tasklet);
> +	return err;
> +}
> +
> +static void rk_ablk_init(struct crypto_info_t *dev,
> +			 struct ablkcipher_request *req)
> +{
> +	dev->left_bytes =3D req->nbytes;
> +	dev->total =3D req->nbytes;
> +	dev->sg_src =3D req->src;
> +	dev->first =3D req->src;
> +	dev->nents =3D sg_nents(req->src);
> +	dev->sg_dst =3D req->dst;
> +	dev->aligned =3D 1;
> +	dev->ablk_req =3D req;
> +}
> +
> +static int rk_aes_setkey(struct crypto_ablkcipher *cipher,
> +			 const u8 *key, unsigned int keylen)
> +{
> +	struct crypto_tfm *tfm =3D crypto_ablkcipher_tfm(cipher);
> +	struct rk_cipher_ctx *ctx =3D crypto_tfm_ctx(tfm);
> +
> +	if (!key) {
> +		dev_err(ctx->dev->dev, "[%s:%d] no key error\n",
> +			__func__, __LINE__);
> +		return -EINVAL;
> +	}
> +
> +	if (keylen !=3D AES_KEYSIZE_128 && keylen !=3D AES_KEYSIZE_192 &&
> +	    keylen !=3D AES_KEYSIZE_256) {
> +		crypto_ablkcipher_set_flags(cipher, CRYPTO_TFM_RES_BAD_KEY_LEN);
> +		dev_err(ctx->dev->dev, "[%s:%d] expect key len =3D %d\n",
> +			__func__, __LINE__, keylen);
> +		return -EINVAL;
> +	}
> +	ctx->keylen =3D keylen;
> +	memcpy(ctx->dev->reg + RK_CRYPTO_AES_KEY_0, key, keylen);
> +	return 0;
> +}
> +
> +static int rk_tdes_setkey(struct crypto_ablkcipher *cipher,
> +			  const u8 *key, unsigned int keylen)
> +{
> +	struct crypto_tfm *tfm =3D crypto_ablkcipher_tfm(cipher);
> +	struct rk_cipher_ctx *ctx =3D crypto_tfm_ctx(tfm);
> +	u32 tmp[DES_EXPKEY_WORDS];
> +
> +	if (!key) {
> +		dev_err(ctx->dev->dev, "[%s:%d] no key error\n",
> +			__func__, __LINE__);
> +		return -EINVAL;
> +	}
> +
> +	if (keylen !=3D DES_KEY_SIZE && keylen !=3D DES3_EDE_KEY_SIZE) {
> +		crypto_ablkcipher_set_flags(cipher, CRYPTO_TFM_RES_BAD_KEY_LEN);
> +		dev_err(ctx->dev->dev, "[%s:%d] expect key len =3D %d\n",
> +			__func__, __LINE__, keylen);
> +		return -EINVAL;
> +	}
> +
> +	if (keylen =3D=3D DES_KEY_SIZE) {
> +		if (!des_ekey(tmp, key) &&
> +		    (tfm->crt_flags & CRYPTO_TFM_REQ_WEAK_KEY)) {
> +			tfm->crt_flags |=3D CRYPTO_TFM_RES_WEAK_KEY;
> +			return -EINVAL;
> +		}
> +	}
> +
> +	ctx->keylen =3D keylen;
> +	memcpy(ctx->dev->reg + RK_CRYPTO_TDES_KEY1_0, key, keylen);
> +	return 0;
> +}
> +
> +static int rk_aes_ecb_encrypt(struct ablkcipher_request *req)
> +{
> +	struct crypto_ablkcipher *tfm =3D crypto_ablkcipher_reqtfm(req);
> +	struct rk_cipher_ctx *ctx =3D crypto_ablkcipher_ctx(tfm);
> +	struct crypto_info_t *dev =3D ctx->dev;
> +
> +	dev->mode =3D RK_CRYPTO_AES_ECB_MODE | AES;
> +	rk_ablk_init(dev, req);
> +	return rk_handle_req(req, dev->align_size);
> +}
> +
> +static int rk_aes_ecb_decrypt(struct ablkcipher_request *req)
> +{
> +	struct crypto_ablkcipher *tfm =3D crypto_ablkcipher_reqtfm(req);
> +	struct rk_cipher_ctx *ctx =3D crypto_ablkcipher_ctx(tfm);
> +	struct crypto_info_t *dev =3D ctx->dev;
> +
> +	dev->mode =3D RK_CRYPTO_AES_ECB_MODE | RK_CRYPTO_DEC | AES;
> +	rk_ablk_init(dev, req);
> +	return rk_handle_req(req, dev->align_size);
> +}
> +
> +static int rk_aes_cbc_encrypt(struct ablkcipher_request *req)
> +{
> +	struct crypto_ablkcipher *tfm =3D crypto_ablkcipher_reqtfm(req);
> +	struct rk_cipher_ctx *ctx =3D crypto_ablkcipher_ctx(tfm);
> +	struct crypto_info_t *dev =3D ctx->dev;
> +
> +	dev->mode =3D RK_CRYPTO_AES_CBC_MODE | AES;
> +	rk_ablk_init(dev, req);
> +	return rk_handle_req(req, dev->align_size);
> +}
> +
> +static int rk_aes_cbc_decrypt(struct ablkcipher_request *req)
> +{
> +	struct crypto_ablkcipher *tfm =3D crypto_ablkcipher_reqtfm(req);
> +	struct rk_cipher_ctx *ctx =3D crypto_ablkcipher_ctx(tfm);
> +	struct crypto_info_t *dev =3D ctx->dev;
> +
> +	dev->mode =3D RK_CRYPTO_AES_CBC_MODE | RK_CRYPTO_DEC | AES;
> +	rk_ablk_init(dev, req);
> +	return rk_handle_req(req, dev->align_size);
> +}
> +
> +static int rk_des_ecb_encrypt(struct ablkcipher_request *req)
> +{
> +	struct crypto_ablkcipher *tfm =3D crypto_ablkcipher_reqtfm(req);
> +	struct rk_cipher_ctx *ctx =3D crypto_ablkcipher_ctx(tfm);
> +	struct crypto_info_t *dev =3D ctx->dev;
> +
> +	dev->mode =3D TDES;
> +	rk_ablk_init(dev, req);
> +	return rk_handle_req(req, dev->align_size);
> +}
> +
> +static int rk_des_ecb_decrypt(struct ablkcipher_request *req)
> +{
> +	struct crypto_ablkcipher *tfm =3D crypto_ablkcipher_reqtfm(req);
> +	struct rk_cipher_ctx *ctx =3D crypto_ablkcipher_ctx(tfm);
> +	struct crypto_info_t *dev =3D ctx->dev;
> +
> +	dev->mode =3D RK_CRYPTO_DEC | TDES;
> +	rk_ablk_init(dev, req);
> +	return rk_handle_req(req, dev->align_size);
> +}
> +
> +static int rk_des_cbc_encrypt(struct ablkcipher_request *req)
> +{
> +	struct crypto_ablkcipher *tfm =3D crypto_ablkcipher_reqtfm(req);
> +	struct rk_cipher_ctx *ctx =3D crypto_ablkcipher_ctx(tfm);
> +	struct crypto_info_t *dev =3D ctx->dev;
> +
> +	dev->mode =3D RK_CRYPTO_TDES_CHAINMODE | TDES;
> +	rk_ablk_init(dev, req);
> +	return rk_handle_req(req, dev->align_size);
> +}
> +
> +static int rk_des_cbc_decrypt(struct ablkcipher_request *req)
> +{
> +	struct crypto_ablkcipher *tfm =3D crypto_ablkcipher_reqtfm(req);
> +	struct rk_cipher_ctx *ctx =3D crypto_ablkcipher_ctx(tfm);
> +	struct crypto_info_t *dev =3D ctx->dev;
> +
> +	dev->mode =3D RK_CRYPTO_TDES_CHAINMODE | RK_CRYPTO_DEC | TDES;
> +	rk_ablk_init(dev, req);
> +	return rk_handle_req(req, dev->align_size);
> +}
> +
> +static int rk_des3_ede_ecb_encrypt(struct ablkcipher_request *req)
> +{
> +	struct crypto_ablkcipher *tfm =3D crypto_ablkcipher_reqtfm(req);
> +	struct rk_cipher_ctx *ctx =3D crypto_ablkcipher_ctx(tfm);
> +	struct crypto_info_t *dev =3D ctx->dev;
> +
> +	dev->mode =3D RK_CRYPTO_TDES_SELECT | TDES;
> +	rk_ablk_init(dev, req);
> +	return rk_handle_req(req, dev->align_size);
> +}
> +
> +static int rk_des3_ede_ecb_decrypt(struct ablkcipher_request *req)
> +{
> +	struct crypto_ablkcipher *tfm =3D crypto_ablkcipher_reqtfm(req);
> +	struct rk_cipher_ctx *ctx =3D crypto_ablkcipher_ctx(tfm);
> +	struct crypto_info_t *dev =3D ctx->dev;
> +
> +	dev->mode =3D RK_CRYPTO_TDES_SELECT | RK_CRYPTO_DEC | TDES;
> +	rk_ablk_init(dev, req);
> +	return rk_handle_req(req, dev->align_size);
> +}
> +
> +static int rk_des3_ede_cbc_encrypt(struct ablkcipher_request *req)
> +{
> +	struct crypto_ablkcipher *tfm =3D crypto_ablkcipher_reqtfm(req);
> +	struct rk_cipher_ctx *ctx =3D crypto_ablkcipher_ctx(tfm);
> +	struct crypto_info_t *dev =3D ctx->dev;
> +
> +	dev->mode =3D RK_CRYPTO_TDES_SELECT | RK_CRYPTO_TDES_CHAINMODE | TD=
ES;
> +	rk_ablk_init(dev, req);
> +	return rk_handle_req(req, dev->align_size);
> +}
> +
> +static int rk_des3_ede_cbc_decrypt(struct ablkcipher_request *req)
> +{
> +	struct crypto_ablkcipher *tfm =3D crypto_ablkcipher_reqtfm(req);
> +	struct rk_cipher_ctx *ctx =3D crypto_ablkcipher_ctx(tfm);
> +	struct crypto_info_t *dev =3D ctx->dev;
> +
> +	dev->mode =3D RK_CRYPTO_TDES_SELECT | RK_CRYPTO_TDES_CHAINMODE |
> +		    RK_CRYPTO_DEC | TDES;
> +	rk_ablk_init(dev, req);
> +	return rk_handle_req(req, dev->align_size);
> +}
> +
> +static void rk_ablk_hw_init(struct crypto_info_t *dev)
> +{
> +	struct crypto_ablkcipher *tfm =3D crypto_ablkcipher_reqtfm(dev->abl=
k_req);
> +	struct rk_cipher_ctx *ctx =3D crypto_ablkcipher_ctx(tfm);
> +	u32 conf_reg =3D 0;
> +
> +	if (dev->mode & TDES) {
> +		dev->mode &=3D ~TDES;
> +		dev->mode |=3D RK_CRYPTO_TDES_FIFO_MODE |
> +			     RK_CRYPTO_TDES_BYTESWAP_KEY |
> +			     RK_CRYPTO_TDES_BYTESWAP_IV;
> +		CRYPTO_WRITE(dev, RK_CRYPTO_TDES_CTRL, dev->mode);
> +
> +		memcpy(dev->reg + RK_CRYPTO_TDES_IV_0, dev->ablk_req->info, 8);
> +		conf_reg =3D RK_CRYPTO_DESSEL;
> +	} else {
> +		dev->mode |=3D RK_CRYPTO_AES_FIFO_MODE |
> +			     RK_CRYPTO_AES_KEY_CHANGE |
> +			     RK_CRYPTO_AES_BYTESWAP_KEY |
> +			     RK_CRYPTO_AES_BYTESWAP_IV;
> +
> +		if (ctx->keylen =3D=3D AES_KEYSIZE_192)
> +			dev->mode |=3D RK_CRYPTO_AES_192BIT_key;
> +		else if (ctx->keylen =3D=3D AES_KEYSIZE_256)
> +			dev->mode |=3D RK_CRYPTO_AES_256BIT_key;
> +
> +		CRYPTO_WRITE(dev, RK_CRYPTO_AES_CTRL, dev->mode);
> +
> +		memcpy(dev->reg + RK_CRYPTO_AES_IV_0, dev->ablk_req->info, 16);
> +	}
> +	conf_reg |=3D RK_CRYPTO_BYTESWAP_BTFIFO |
> +		    RK_CRYPTO_BYTESWAP_BRFIFO;
> +	CRYPTO_WRITE(dev, RK_CRYPTO_CONF, conf_reg);
> +	CRYPTO_WRITE(dev, RK_CRYPTO_INTENA,
> +		     RK_CRYPTO_BCDMA_ERR_ENA | RK_CRYPTO_BCDMA_DONE_ENA);
> +}
> +
> +static void crypto_dma_start(struct crypto_info_t *dev)
> +{
> +	CRYPTO_WRITE(dev, RK_CRYPTO_BRDMAS, dev->addr_in);
> +	CRYPTO_WRITE(dev, RK_CRYPTO_BRDMAL, dev->count / 4);
> +	CRYPTO_WRITE(dev, RK_CRYPTO_BTDMAS, dev->addr_out);
> +	CRYPTO_WRITE(dev, RK_CRYPTO_CTRL, RK_CRYPTO_BLOCK_START |
> +			(RK_CRYPTO_BLOCK_START << 16));
> +}
> +
> +static int rk_set_data_start(struct crypto_info_t *dev)
> +{
> +	int err;
> +
> +	err =3D dev->load_data(dev, dev->sg_src, dev->sg_dst);
> +	if (!err)
> +		crypto_dma_start(dev);
> +	return err;
> +}
> +
> +static int rk_ablk_start(struct crypto_info_t *dev)
> +{
> +	int err;
> +
> +	spin_lock(&dev->lock);
> +	rk_ablk_hw_init(dev);
> +	err =3D rk_set_data_start(dev);
> +	spin_unlock(&dev->lock);
> +	return err;
> +}
> +
> +/* return:
> + *	true	some err was occurred
> + *	fault	no err, continue
> + */
> +static int rk_ablk_rx(struct crypto_info_t *dev)
> +{
> +	int err =3D 0;
> +
> +	dev->unload_data(dev);
> +	if (!dev->aligned) {
> +		if (!sg_pcopy_from_buffer(dev->ablk_req->dst, dev->nents,
> +					  dev->addr_vir, dev->count,
> +					  dev->total - dev->left_bytes -
> +					  dev->count)) {
> +			err =3D -EINVAL;
> +			goto out_rx;
> +		}
> +	}
> +	if (dev->left_bytes) {
> +		if (dev->aligned) {
> +			if (sg_is_last(dev->sg_src)) {
> +				dev_err(dev->dev, "[%s:%d], lack of data\n",
> +					__func__, __LINE__);
> +				err =3D -ENOMEM;
> +				goto out_rx;
> +			}
> +			dev->sg_src =3D sg_next(dev->sg_src);
> +			dev->sg_dst =3D sg_next(dev->sg_dst);
> +		}
> +		err =3D rk_set_data_start(dev);
> +	} else {
> +		/* here show the calculation is over without any err */
> +		dev->complete(dev, 0);
> +	}
> +out_rx:
> +	return err;
> +}
> +
> +static int rk_ablk_cra_init(struct crypto_tfm *tfm)
> +{
> +	struct rk_cipher_ctx *ctx =3D crypto_tfm_ctx(tfm);
> +
> +	ctx->dev =3D crypto_p;
> +	ctx->dev->align_size =3D crypto_tfm_alg_alignmask(tfm) + 1;
> +	ctx->dev->start =3D rk_ablk_start;
> +	ctx->dev->update =3D rk_ablk_rx;
> +	ctx->dev->complete =3D rk_crypto_complete;
> +	ctx->dev->addr_vir =3D (char *)__get_free_page(GFP_KERNEL);
> +
> +	return ctx->dev->addr_vir ? ctx->dev->enable_clk(ctx->dev) : -ENOME=
M;
> +}
> +
> +static void rk_ablk_cra_exit(struct crypto_tfm *tfm)
> +{
> +	struct rk_cipher_ctx *ctx =3D crypto_tfm_ctx(tfm);
> +
> +	free_page((unsigned long)ctx->dev->addr_vir);
> +	ctx->dev->disable_clk(ctx->dev);
> +}
> +
> +struct crypto_alg rk_ecb_aes_alg =3D {
> +	.cra_name		=3D "ecb(aes)",
> +	.cra_driver_name	=3D "ecb-aes-rk",
> +	.cra_priority		=3D 300,
> +	.cra_flags		=3D CRYPTO_ALG_TYPE_ABLKCIPHER |
> +				  CRYPTO_ALG_ASYNC,
> +	.cra_blocksize		=3D AES_BLOCK_SIZE,
> +	.cra_ctxsize		=3D sizeof(struct rk_cipher_ctx),
> +	.cra_alignmask		=3D 0x0f,
> +	.cra_type		=3D &crypto_ablkcipher_type,
> +	.cra_module		=3D THIS_MODULE,
> +	.cra_init		=3D rk_ablk_cra_init,
> +	.cra_exit		=3D rk_ablk_cra_exit,
> +	.cra_u.ablkcipher	=3D {
> +		.min_keysize	=3D AES_MIN_KEY_SIZE,
> +		.max_keysize	=3D AES_MAX_KEY_SIZE,
> +		.setkey		=3D rk_aes_setkey,
> +		.encrypt	=3D rk_aes_ecb_encrypt,
> +		.decrypt	=3D rk_aes_ecb_decrypt,
> +	}
> +};
> +
> +struct crypto_alg rk_cbc_aes_alg =3D {
> +	.cra_name		=3D "cbc(aes)",
> +	.cra_driver_name	=3D "cbc-aes-rk",
> +	.cra_priority		=3D 300,
> +	.cra_flags		=3D CRYPTO_ALG_TYPE_ABLKCIPHER |
> +				  CRYPTO_ALG_ASYNC,
> +	.cra_blocksize		=3D AES_BLOCK_SIZE,
> +	.cra_ctxsize		=3D sizeof(struct rk_cipher_ctx),
> +	.cra_alignmask		=3D 0x0f,
> +	.cra_type		=3D &crypto_ablkcipher_type,
> +	.cra_module		=3D THIS_MODULE,
> +	.cra_init		=3D rk_ablk_cra_init,
> +	.cra_exit		=3D rk_ablk_cra_exit,
> +	.cra_u.ablkcipher	=3D {
> +		.min_keysize	=3D AES_MIN_KEY_SIZE,
> +		.max_keysize	=3D AES_MAX_KEY_SIZE,
> +		.ivsize		=3D AES_BLOCK_SIZE,
> +		.setkey		=3D rk_aes_setkey,
> +		.encrypt	=3D rk_aes_cbc_encrypt,
> +		.decrypt	=3D rk_aes_cbc_decrypt,
> +	}
> +};
> +
> +struct crypto_alg rk_ecb_des_alg =3D {
> +	.cra_name		=3D "ecb(des)",
> +	.cra_driver_name	=3D "ecb-des-rk",
> +	.cra_priority		=3D 300,
> +	.cra_flags		=3D CRYPTO_ALG_TYPE_ABLKCIPHER |
> +				  CRYPTO_ALG_ASYNC,
> +	.cra_blocksize		=3D DES_BLOCK_SIZE,
> +	.cra_ctxsize		=3D sizeof(struct rk_cipher_ctx),
> +	.cra_alignmask		=3D 0x07,
> +	.cra_type		=3D &crypto_ablkcipher_type,
> +	.cra_module		=3D THIS_MODULE,
> +	.cra_init		=3D rk_ablk_cra_init,
> +	.cra_exit		=3D rk_ablk_cra_exit,
> +	.cra_u.ablkcipher	=3D {
> +		.min_keysize	=3D DES_KEY_SIZE,
> +		.max_keysize	=3D DES_KEY_SIZE,
> +		.setkey		=3D rk_tdes_setkey,
> +		.encrypt	=3D rk_des_ecb_encrypt,
> +		.decrypt	=3D rk_des_ecb_decrypt,
> +	}
> +};
> +
> +struct crypto_alg rk_cbc_des_alg =3D {
> +	.cra_name		=3D "cbc(des)",
> +	.cra_driver_name	=3D "cbc-des-rk",
> +	.cra_priority		=3D 300,
> +	.cra_flags		=3D CRYPTO_ALG_TYPE_ABLKCIPHER |
> +				  CRYPTO_ALG_ASYNC,
> +	.cra_blocksize		=3D DES_BLOCK_SIZE,
> +	.cra_ctxsize		=3D sizeof(struct rk_cipher_ctx),
> +	.cra_alignmask		=3D 0x07,
> +	.cra_type		=3D &crypto_ablkcipher_type,
> +	.cra_module		=3D THIS_MODULE,
> +	.cra_init		=3D rk_ablk_cra_init,
> +	.cra_exit		=3D rk_ablk_cra_exit,
> +	.cra_u.ablkcipher	=3D {
> +		.min_keysize	=3D DES_KEY_SIZE,
> +		.max_keysize	=3D DES_KEY_SIZE,
> +		.ivsize		=3D DES_BLOCK_SIZE,
> +		.setkey		=3D rk_tdes_setkey,
> +		.encrypt	=3D rk_des_cbc_encrypt,
> +		.decrypt	=3D rk_des_cbc_decrypt,
> +	}
> +};
> +
> +struct crypto_alg rk_ecb_des3_ede_alg =3D {
> +	.cra_name		=3D "ecb(des3_ede)",
> +	.cra_driver_name	=3D "ecb-des3-ede-rk",
> +	.cra_priority		=3D 300,
> +	.cra_flags		=3D CRYPTO_ALG_TYPE_ABLKCIPHER |
> +				  CRYPTO_ALG_ASYNC,
> +	.cra_blocksize		=3D DES_BLOCK_SIZE,
> +	.cra_ctxsize		=3D sizeof(struct rk_cipher_ctx),
> +	.cra_alignmask		=3D 0x07,
> +	.cra_type		=3D &crypto_ablkcipher_type,
> +	.cra_module		=3D THIS_MODULE,
> +	.cra_init		=3D rk_ablk_cra_init,
> +	.cra_exit		=3D rk_ablk_cra_exit,
> +	.cra_u.ablkcipher	=3D {
> +		.min_keysize	=3D DES3_EDE_KEY_SIZE,
> +		.max_keysize	=3D DES3_EDE_KEY_SIZE,
> +		.ivsize		=3D DES_BLOCK_SIZE,
> +		.setkey		=3D rk_tdes_setkey,
> +		.encrypt	=3D rk_des3_ede_ecb_encrypt,
> +		.decrypt	=3D rk_des3_ede_ecb_decrypt,
> +	}
> +};
> +
> +struct crypto_alg rk_cbc_des3_ede_alg =3D {
> +	.cra_name		=3D "cbc(des3_ede)",
> +	.cra_driver_name	=3D "cbc-des3-ede-rk",
> +	.cra_priority		=3D 300,
> +	.cra_flags		=3D CRYPTO_ALG_TYPE_ABLKCIPHER |
> +				  CRYPTO_ALG_ASYNC,
> +	.cra_blocksize		=3D DES_BLOCK_SIZE,
> +	.cra_ctxsize		=3D sizeof(struct rk_cipher_ctx),
> +	.cra_alignmask		=3D 0x07,
> +	.cra_type		=3D &crypto_ablkcipher_type,
> +	.cra_module		=3D THIS_MODULE,
> +	.cra_init		=3D rk_ablk_cra_init,
> +	.cra_exit		=3D rk_ablk_cra_exit,
> +	.cra_u.ablkcipher	=3D {
> +		.min_keysize	=3D DES3_EDE_KEY_SIZE,
> +		.max_keysize	=3D DES3_EDE_KEY_SIZE,
> +		.ivsize		=3D DES_BLOCK_SIZE,
> +		.setkey		=3D rk_tdes_setkey,
> +		.encrypt	=3D rk_des3_ede_cbc_encrypt,
> +		.decrypt	=3D rk_des3_ede_cbc_decrypt,
> +	}
> +};


--=20
Thanks,
Caesar
