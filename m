Return-Path: <SRS0=b5ak=PZ=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-wm1-f65.google.com ([209.85.128.65]:36611 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727498AbfAQKdU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Jan 2019 05:33:20 -0500
Date: Thu, 17 Jan 2019 11:33:14 +0100
From: Corentin Labbe <clabbe.montjoie@gmail.com>
To: Kalyani Akula <kalyani.akula@xilinx.com>
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kalyani Akula <kalyania@xilinx.com>,
        Sarat Chand Savitala <saratcha@xilinx.com>
Subject: Re: [RFC PATCH 5/5] crypto: Add Xilinx AES driver
Message-ID: <20190117103314.GA10028@Red>
References: <1547708541-23730-1-git-send-email-kalyani.akula@xilinx.com>
 <1547708541-23730-6-git-send-email-kalyani.akula@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1547708541-23730-6-git-send-email-kalyani.akula@xilinx.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jan 17, 2019 at 12:32:21PM +0530, Kalyani Akula wrote:
> This patch adds AES driver support for the Xilinx
> ZynqMP SoC.
> 
> Signed-off-by: Kalyani Akula <kalyani.akula@xilinx.com>
> ---
>  drivers/crypto/Kconfig      |  11 ++
>  drivers/crypto/Makefile     |   1 +
>  drivers/crypto/zynqmp-aes.c | 331 ++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 343 insertions(+)
>  create mode 100644 drivers/crypto/zynqmp-aes.c
> 

Hello I have some comment below

> diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
> index 5a90075..66d9faa 100644
> --- a/drivers/crypto/Kconfig
> +++ b/drivers/crypto/Kconfig
> @@ -667,6 +667,17 @@ config CRYPTO_DEV_ROCKCHIP
>  	  This driver interfaces with the hardware crypto accelerator.
>  	  Supporting cbc/ecb chainmode, and aes/des/des3_ede cipher mode.
>  
> +config CRYPTO_DEV_ZYNQMP_AES
> +	tristate "Support for Xilinx ZynqMP AES hw accelerator"
> +	depends on ARCH_ZYNQMP || COMPILE_TEST
> +	select CRYPTO_AES
> +	select CRYPTO_BLKCIPHER

BLKCIPHER is deprecated, please use skcipher

> +	help
> +	  Xilinx ZynqMP has AES-GCM engine used for symmetric key
> +	  encryption and decryption. This driver interfaces with AES hw
> +	  accelerator. Select this if you want to use the ZynqMP module
> +	  for AES algorithms.
> +
>  config CRYPTO_DEV_MEDIATEK
>  	tristate "MediaTek's EIP97 Cryptographic Engine driver"
>  	depends on (ARM && ARCH_MEDIATEK) || COMPILE_TEST
> diff --git a/drivers/crypto/Makefile b/drivers/crypto/Makefile
> index 8e7e225..991b343 100644
> --- a/drivers/crypto/Makefile
> +++ b/drivers/crypto/Makefile
> @@ -47,3 +47,4 @@ obj-$(CONFIG_CRYPTO_DEV_BCM_SPU) += bcm/
>  obj-$(CONFIG_CRYPTO_DEV_SAFEXCEL) += inside-secure/
>  obj-$(CONFIG_CRYPTO_DEV_ARTPEC6) += axis/
>  obj-y += hisilicon/
> +obj-$(CONFIG_CRYPTO_DEV_ZYNQMP_AES) += zynqmp-aes.o
> diff --git a/drivers/crypto/zynqmp-aes.c b/drivers/crypto/zynqmp-aes.c
> new file mode 100644
> index 0000000..3a38d2d
> --- /dev/null
> +++ b/drivers/crypto/zynqmp-aes.c
> @@ -0,0 +1,331 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Xilinx ZynqMP AES Driver.
> + * Copyright (c) 2018 Xilinx Inc.
> + */
> +
> +#include <crypto/aes.h>
> +#include <crypto/scatterwalk.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/of_device.h>
> +#include <linux/scatterlist.h>
> +#include <linux/spinlock.h>
> +#include <linux/firmware/xlnx-zynqmp.h>
> +
> +#define ZYNQMP_AES_QUEUE_LENGTH			1
> +#define ZYNQMP_AES_IV_SIZE			12
> +#define ZYNQMP_AES_GCM_SIZE			16
> +#define ZYNQMP_AES_KEY_SIZE			32
> +
> +#define ZYNQMP_AES_DECRYPT			0
> +#define ZYNQMP_AES_ENCRYPT			1
> +
> +#define ZYNQMP_AES_KUP_KEY			0
> +
> +#define ZYNQMP_AES_GCM_TAG_MISMATCH_ERR		0x01
> +#define ZYNQMP_AES_SIZE_ERR			0x06
> +#define ZYNQMP_AES_WRONG_KEY_SRC_ERR		0x13
> +#define ZYNQMP_AES_PUF_NOT_PROGRAMMED		0xE300
> +
> +#define ZYNQMP_AES_BLOCKSIZE			0x04
> +
> +struct zynqmp_aes_dev {
> +	struct list_head list;
> +	struct device *dev;
> +	/* the lock protects queue and dev list */
> +	spinlock_t lock;
> +	struct crypto_queue queue;
> +};
> +
> +struct zynqmp_aes_op {
> +	struct zynqmp_aes_dev *dd;
> +	void *src;
> +	void *dst;
> +	int len;
> +	u8 key[ZYNQMP_AES_KEY_SIZE];
> +	u8 *iv;
> +	u32 keylen;
> +	u32 keytype;
> +};
> +
> +struct zynqmp_aes_data {
> +	u64 src;
> +	u64 iv;
> +	u64 key;
> +	u64 dst;
> +	u64 size;
> +	u64 optype;
> +	u64 keysrc;
> +};
> +
> +struct zynqmp_aes_drv {
> +	struct list_head dev_list;
> +	/* the lock protects dev list */
> +	spinlock_t lock;
> +};
> +
> +static struct zynqmp_aes_drv zynqmp_aes = {
> +	.dev_list = LIST_HEAD_INIT(zynqmp_aes.dev_list),
> +	.lock = __SPIN_LOCK_UNLOCKED(zynqmp_aes.lock),
> +};
> +
> +static struct zynqmp_aes_dev *zynqmp_aes_find_dev(struct zynqmp_aes_op *ctx)
> +{
> +	struct zynqmp_aes_dev *aes_dd = NULL;
> +	struct zynqmp_aes_dev *tmp;
> +
> +	spin_lock_bh(&zynqmp_aes.lock);
> +	if (!ctx->dd) {
> +		list_for_each_entry(tmp, &zynqmp_aes.dev_list, list) {
> +			aes_dd = tmp;
> +			break;
> +		}
> +		ctx->dd = aes_dd;
> +	} else {
> +		aes_dd = ctx->dd;
> +	}
> +	spin_unlock_bh(&zynqmp_aes.lock);
> +
> +	return aes_dd;
> +}
> +
> +static int zynqmp_setkey_blk(struct crypto_tfm *tfm, const u8 *key,
> +			     unsigned int len)
> +{
> +	struct zynqmp_aes_op *op = crypto_tfm_ctx(tfm);
> +

You should validate more the keylen.

> +	op->keylen = len;
> +	memcpy(op->key, key, len);
> +
> +	return 0;
> +}
> +
> +static int zynqmp_setkeytype(struct crypto_tfm *tfm, const u8 *keytype,
> +			     unsigned int len)
> +{
> +	struct zynqmp_aes_op *op = crypto_tfm_ctx(tfm);
> +
> +	op->keytype = (u32)(*keytype);

You should validate more what keytype is given.

> +
> +	return 0;
> +}
> +
> +static int zynqmp_aes_xcrypt(struct blkcipher_desc *desc,
> +			     struct scatterlist *dst,
> +			     struct scatterlist *src,
> +			     unsigned int nbytes,
> +			     unsigned int flags)
> +{
> +	struct zynqmp_aes_op *op = crypto_blkcipher_ctx(desc->tfm);
> +	struct zynqmp_aes_dev *dd = zynqmp_aes_find_dev(op);
> +	const struct zynqmp_eemi_ops *eemi_ops = zynqmp_pm_get_eemi_ops();
> +	int err, ret, copy_bytes, src_data = 0, dst_data = 0;
> +	dma_addr_t dma_addr, dma_addr_buf;
> +	struct zynqmp_aes_data *abuf;
> +	struct blkcipher_walk walk;
> +	unsigned int data_size;
> +	size_t dma_size;
> +	char *kbuf;
> +
> +	if (!eemi_ops || !eemi_ops->aes)
> +		return -ENOTSUPP;
> +
> +	if (op->keytype == ZYNQMP_AES_KUP_KEY)
> +		dma_size = nbytes + ZYNQMP_AES_KEY_SIZE
> +			+ ZYNQMP_AES_IV_SIZE;
> +	else
> +		dma_size = nbytes + ZYNQMP_AES_IV_SIZE;
> +
> +	kbuf = dma_alloc_coherent(dd->dev, dma_size, &dma_addr, GFP_KERNEL);
> +	if (!kbuf)
> +		return -ENOMEM;
> +
> +	abuf = dma_alloc_coherent(dd->dev, sizeof(struct zynqmp_aes_data),
> +				  &dma_addr_buf, GFP_KERNEL);
> +	if (!abuf) {
> +		dma_free_coherent(dd->dev, dma_size, kbuf, dma_addr);
> +		return -ENOMEM;
> +	}
> +
> +	data_size = nbytes;
> +	blkcipher_walk_init(&walk, dst, src, data_size);
> +	err = blkcipher_walk_virt(desc, &walk);
> +	op->iv = walk.iv;
> +
> +	while ((nbytes = walk.nbytes)) {
> +		op->src = walk.src.virt.addr;
> +		memcpy(kbuf + src_data, op->src, nbytes);
> +		src_data = src_data + nbytes;
> +		nbytes &= (ZYNQMP_AES_BLOCKSIZE - 1);
> +		err = blkcipher_walk_done(desc, &walk, nbytes);
> +	}
> +	memcpy(kbuf + data_size, op->iv, ZYNQMP_AES_IV_SIZE);
> +	abuf->src = dma_addr;
> +	abuf->dst = dma_addr;
> +	abuf->iv = abuf->src + data_size;
> +	abuf->size = data_size - ZYNQMP_AES_GCM_SIZE;
> +	abuf->optype = flags;
> +	abuf->keysrc = op->keytype;
> +
> +	if (op->keytype == ZYNQMP_AES_KUP_KEY) {
> +		memcpy(kbuf + data_size + ZYNQMP_AES_IV_SIZE,
> +		       op->key, ZYNQMP_AES_KEY_SIZE);
> +
> +		abuf->key = abuf->src + data_size + ZYNQMP_AES_IV_SIZE;
> +	} else {
> +		abuf->key = 0;
> +	}
> +	eemi_ops->aes(dma_addr_buf, &ret);
> +
> +	if (ret != 0) {
> +		switch (ret) {
> +		case ZYNQMP_AES_GCM_TAG_MISMATCH_ERR:
> +			dev_err(dd->dev, "ERROR: Gcm Tag mismatch\n\r");
> +			break;
> +		case ZYNQMP_AES_SIZE_ERR:
> +			dev_err(dd->dev, "ERROR : Non word aligned data\n\r");
> +			break;
> +		case ZYNQMP_AES_WRONG_KEY_SRC_ERR:
> +			dev_err(dd->dev, "ERROR: Wrong KeySrc, enable secure mode\n\r");
> +			break;
> +		case ZYNQMP_AES_PUF_NOT_PROGRAMMED:
> +			dev_err(dd->dev, "ERROR: PUF is not registered\r\n");
> +			break;
> +		default:
> +			dev_err(dd->dev, "ERROR: Invalid");
> +			break;
> +		}
> +		goto END;
> +	}
> +	if (flags)
> +		copy_bytes = data_size;
> +	else
> +		copy_bytes = data_size - ZYNQMP_AES_GCM_SIZE;
> +
> +	blkcipher_walk_init(&walk, dst, src, copy_bytes);
> +	err = blkcipher_walk_virt(desc, &walk);
> +
> +	while ((nbytes = walk.nbytes)) {
> +		memcpy(walk.dst.virt.addr, kbuf + dst_data, nbytes);
> +		dst_data = dst_data + nbytes;
> +		nbytes &= (ZYNQMP_AES_BLOCKSIZE - 1);
> +		err = blkcipher_walk_done(desc, &walk, nbytes);
> +	}
> +END:
> +	dma_free_coherent(dd->dev, dma_size, kbuf, dma_addr);
> +	dma_free_coherent(dd->dev, sizeof(struct zynqmp_aes_data),
> +			  abuf, dma_addr_buf);

You should erase the key/IV from the bounce buffer.

> +	return err;
> +}
> +
> +static int zynqmp_aes_decrypt(struct blkcipher_desc *desc,
> +			      struct scatterlist *dst,
> +			      struct scatterlist *src,
> +			      unsigned int nbytes)
> +{
> +	return zynqmp_aes_xcrypt(desc, dst, src, nbytes, ZYNQMP_AES_DECRYPT);
> +}
> +
> +static int zynqmp_aes_encrypt(struct blkcipher_desc *desc,
> +			      struct scatterlist *dst,
> +			      struct scatterlist *src,
> +			      unsigned int nbytes)
> +{
> +	return zynqmp_aes_xcrypt(desc, dst, src, nbytes, ZYNQMP_AES_ENCRYPT);
> +}
> +
> +static struct crypto_alg zynqmp_alg = {
> +	.cra_name		=	"xilinx-zynqmp-aes",
> +	.cra_driver_name	=	"zynqmp-aes",

Since the driver is for GCM, GCM must appear in the name

> +	.cra_priority		=	400,
> +	.cra_flags		=	CRYPTO_ALG_TYPE_BLKCIPHER |
> +					CRYPTO_ALG_KERN_DRIVER_ONLY,
> +	.cra_blocksize		=	ZYNQMP_AES_BLOCKSIZE,
> +	.cra_ctxsize		=	sizeof(struct zynqmp_aes_op),
> +	.cra_alignmask		=	15,
> +	.cra_type		=	&crypto_blkcipher_type,
> +	.cra_module		=	THIS_MODULE,
> +	.cra_u			=	{
> +	.blkcipher	=	{
> +			.min_keysize	=	0,
> +			.max_keysize	=	ZYNQMP_AES_KEY_SIZE,
> +			.setkey		=	zynqmp_setkey_blk,
> +			.setkeytype	=	zynqmp_setkeytype,
> +			.encrypt	=	zynqmp_aes_encrypt,
> +			.decrypt	=	zynqmp_aes_decrypt,
> +			.ivsize		=	ZYNQMP_AES_IV_SIZE,
> +		}
> +	}
> +};
> +
> +static const struct of_device_id zynqmp_aes_dt_ids[] = {
> +	{ .compatible = "xlnx,zynqmp-aes" },
> +	{ /* sentinel */ }
> +};
> +MODULE_DEVICE_TABLE(of, zynqmp_aes_dt_ids);
> +
> +static int zynqmp_aes_probe(struct platform_device *pdev)
> +{
> +	struct zynqmp_aes_dev *aes_dd;
> +	struct device *dev = &pdev->dev;
> +	int ret;
> +
> +	aes_dd = devm_kzalloc(dev, sizeof(*aes_dd), GFP_KERNEL);
> +	if (!aes_dd)
> +		return -ENOMEM;
> +
> +	aes_dd->dev = dev;
> +	platform_set_drvdata(pdev, aes_dd);
> +
> +	ret = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(44));
> +	if (ret < 0) {
> +		dev_err(dev, "no usable DMA configuration");
> +		return ret;
> +	}
> +
> +	INIT_LIST_HEAD(&aes_dd->list);
> +	crypto_init_queue(&aes_dd->queue, ZYNQMP_AES_QUEUE_LENGTH);
> +	list_add_tail(&aes_dd->list, &zynqmp_aes.dev_list);
> +

Same problem than the SHA3 driver, you init a queue without never using it.
And same problem for device list that seems useless at all in the current situation.

Regards
