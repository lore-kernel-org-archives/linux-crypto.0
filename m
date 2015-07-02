From: Felipe Balbi <balbi@ti.com>
Subject: Re: [PATCH 05/10] crypto: omap-aes: Add support for GCM mode
Date: Thu, 2 Jul 2015 03:04:17 -0500
Message-ID: <20150702080417.GE4033@saruman.tx.rr.com>
References: <1435814320-30347-1-git-send-email-lokeshvutla@ti.com>
 <1435814320-30347-6-git-send-email-lokeshvutla@ti.com>
Reply-To: <balbi@ti.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BQPnanjtCNWHyqYD"
Cc: <herbert@gondor.apana.org.au>, <linux-crypto@vger.kernel.org>,
	<davem@davemloft.net>, <linux-omap@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <t-kristo@ti.com>, <nsekhar@ti.com>
To: Lokesh Vutla <lokeshvutla@ti.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:42306 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752808AbbGBIEW (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 2 Jul 2015 04:04:22 -0400
Content-Disposition: inline
In-Reply-To: <1435814320-30347-6-git-send-email-lokeshvutla@ti.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

--BQPnanjtCNWHyqYD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 02, 2015 at 10:48:35AM +0530, Lokesh Vutla wrote:
> OMAP AES hw supports aes gcm mode.

here you refer to it as 'gcm'

> Adding support for GCM mode in omap-aes driver.

while here and in subject as 'GCM'.

> Signed-off-by: Lokesh Vutla <lokeshvutla@ti.com>
> ---
>  drivers/crypto/Makefile       |    3 +-
>  drivers/crypto/omap-aes-gcm.c |  304 +++++++++++++++++++++++++++++++++++=
++++++

why does this have to be a separate source file ? Patch gets really
large with all the macro and structure definition being shuffled around.

>  drivers/crypto/omap-aes.c     |  238 +++++++++-----------------------
>  drivers/crypto/omap-aes.h     |  205 +++++++++++++++++++++++++++
>  4 files changed, 575 insertions(+), 175 deletions(-)
>  create mode 100644 drivers/crypto/omap-aes-gcm.c
>  create mode 100644 drivers/crypto/omap-aes.h
>=20
> diff --git a/drivers/crypto/Makefile b/drivers/crypto/Makefile
> index fb84be7..3afad7b 100644
> --- a/drivers/crypto/Makefile
> +++ b/drivers/crypto/Makefile
> @@ -13,7 +13,8 @@ obj-$(CONFIG_CRYPTO_DEV_MXS_DCP) +=3D mxs-dcp.o
>  obj-$(CONFIG_CRYPTO_DEV_NIAGARA2) +=3D n2_crypto.o
>  n2_crypto-y :=3D n2_core.o n2_asm.o
>  obj-$(CONFIG_CRYPTO_DEV_NX) +=3D nx/
> -obj-$(CONFIG_CRYPTO_DEV_OMAP_AES) +=3D omap-aes.o
> +obj-$(CONFIG_CRYPTO_DEV_OMAP_AES) +=3D omap-aes-driver.o
> +omap-aes-driver-objs :=3D omap-aes.o omap-aes-gcm.o

=2E.. I mean, considering you unconditionally link these two together...

> diff --git a/drivers/crypto/omap-aes-gcm.c b/drivers/crypto/omap-aes-gcm.c
> new file mode 100644
> index 0000000..1be9d91
> --- /dev/null
> +++ b/drivers/crypto/omap-aes-gcm.c
> @@ -0,0 +1,304 @@
> +/*
> + * Cryptographic API.
> + *
> + * Support for OMAP AES GCM HW acceleration.
> + *
> + * Copyright (c) 2015 Texas Instruments Incorporated
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as pub=
lished
> + * by the Free Software Foundation.
> + *
> + */
> +
> +#include <linux/err.h>
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/errno.h>
> +#include <linux/kernel.h>
> +#include <linux/platform_device.h>
> +#include <linux/scatterlist.h>
> +#include <linux/dma-mapping.h>
> +#include <linux/dmaengine.h>
> +#include <linux/omap-dma.h>
> +#include <linux/pm_runtime.h>
> +#include <linux/of.h>
> +#include <linux/of_device.h>
> +#include <linux/of_address.h>
> +#include <linux/io.h>
> +#include <linux/crypto.h>
> +#include <linux/interrupt.h>
> +#include <crypto/scatterwalk.h>
> +#include <crypto/aes.h>
> +#include "omap-aes.h"
> +
> +static int omap_aes_gcm_handle_queue(struct omap_aes_dev *dd,
> +				     struct aead_request *req);
> +
> +static void omap_aes_gcm_finish_req(struct omap_aes_dev *dd, int ret)
> +{
> +	struct aead_request *req =3D dd->aead_req;
> +
> +	dd->flags &=3D ~FLAGS_BUSY;
> +	dd->in_sg =3D NULL;
> +	dd->out_sg =3D NULL;
> +
> +	req->base.complete(&req->base, ret);
> +}
> +
> +static void omap_aes_gcm_done_task(struct omap_aes_dev *dd)
> +{
> +	u8 *tag;
> +	int alen, clen, i, ret =3D 0, nsg;
> +
> +	alen =3D ALIGN(dd->assoc_len, AES_BLOCK_SIZE);
> +	clen =3D ALIGN(dd->total, AES_BLOCK_SIZE);
> +
> +	nsg =3D 1 + !!(dd->assoc_len && dd->total);
> +
> +	if (!dd->pio_only) {
> +		dma_sync_sg_for_device(dd->dev, dd->out_sg, dd->out_sg_len,
> +				       DMA_FROM_DEVICE);
> +		dma_unmap_sg(dd->dev, dd->in_sg, dd->in_sg_len, DMA_TO_DEVICE);
> +		dma_unmap_sg(dd->dev, dd->out_sg, dd->out_sg_len,
> +			     DMA_FROM_DEVICE);
> +		omap_aes_crypt_dma_stop(dd);
> +	}
> +
> +	if (dd->flags & FLAGS_ENCRYPT)
> +		scatterwalk_map_and_copy(dd->ctx->auth_tag, dd->aead_req->dst,
> +					 dd->total, dd->authsize, 1);
> +
> +	if (!(dd->flags & FLAGS_ENCRYPT)) {
> +		tag =3D (u8 *)dd->ctx->auth_tag;
> +		for (i =3D 0; i < dd->authsize; i++) {
> +			if (tag[i]) {
> +				dev_err(dd->dev, "GCM decryption: Tag Message is wrong\n");
> +				ret =3D -EBADMSG;
> +			}
> +		}
> +	}
> +
> +	omap_aes_gcm_finish_req(dd, ret);
> +	omap_aes_gcm_handle_queue(dd, NULL);
> +}
> +
> +static int omap_aes_gcm_copy_buffers(struct omap_aes_dev *dd,
> +				     struct aead_request *req)
> +{
> +	void *buf_in;
> +	int alen, clen;
> +	struct crypto_aead *aead =3D crypto_aead_reqtfm(req);
> +	unsigned int authlen =3D crypto_aead_authsize(aead);
> +	u32 dec =3D !(dd->flags & FLAGS_ENCRYPT);
> +
> +	alen =3D req->assoclen;
> +	clen =3D req->cryptlen - (dec * authlen);
> +
> +	dd->sgs_copied =3D 0;
> +
> +	sg_init_table(dd->in_sgl, 2);
> +	buf_in =3D sg_virt(req->assoc);
> +	sg_set_buf(dd->in_sgl, buf_in, alen);
> +
> +	buf_in =3D sg_virt(req->src);
> +	sg_set_buf(&dd->in_sgl[1], buf_in, clen);
> +
> +	dd->in_sg =3D dd->in_sgl;
> +	dd->total =3D clen;
> +	dd->assoc_len =3D req->assoclen;
> +	dd->authsize =3D authlen;
> +	dd->out_sg =3D req->dst;
> +
> +	dd->in_sg_len =3D scatterwalk_bytes_sglen(dd->in_sg, alen + clen);
> +	dd->out_sg_len =3D scatterwalk_bytes_sglen(dd->out_sg, clen);
> +
> +	return 0;
> +}
> +
> +static void tcrypt_complete(struct crypto_async_request *req, int err)
> +{
> +	struct tcrypt_result *res =3D req->data;
> +
> +	if (err =3D=3D -EINPROGRESS)
> +		return;
> +
> +	res->err =3D err;
> +	complete(&res->completion);
> +}
> +
> +static int do_encrypt_iv(struct aead_request *req, u32 *tag)
> +{
> +	struct scatterlist iv_sg;
> +	struct ablkcipher_request *ablk_req;
> +	struct crypto_ablkcipher *tfm;
> +	struct tcrypt_result result;
> +	struct omap_aes_ctx *ctx =3D crypto_aead_ctx(crypto_aead_reqtfm(req));
> +	int ret =3D 0;
> +
> +	tfm =3D crypto_alloc_ablkcipher("ctr(aes)", 0, 0);
> +	ablk_req =3D ablkcipher_request_alloc(tfm, GFP_KERNEL);
> +	if (!ablk_req) {
> +		pr_err("skcipher: Failed to allocate request\n");
> +		return -1;
> +	}
> +
> +	init_completion(&result.completion);
> +
> +	sg_init_one(&iv_sg, tag, AES_BLOCK_SIZE);
> +	ablkcipher_request_set_callback(ablk_req, CRYPTO_TFM_REQ_MAY_BACKLOG,
> +					tcrypt_complete, &result);
> +	ret =3D crypto_ablkcipher_setkey(tfm, (u8 *)ctx->key, ctx->keylen);

looks like you should check result here.

> +	ablkcipher_request_set_crypt(ablk_req, &iv_sg, &iv_sg, AES_BLOCK_SIZE,
> +				     req->iv);
> +	ret =3D crypto_ablkcipher_encrypt(ablk_req);
> +	switch (ret) {
> +	case 0:
> +		break;
> +	case -EINPROGRESS:
> +	case -EBUSY:
> +		ret =3D wait_for_completion_interruptible(&result.completion);
> +		if (!ret) {
> +			ret =3D result.err;
> +			if (!ret) {
> +				reinit_completion(&result.completion);
> +				break;
> +			}
> +		}
> +		/* fall through */
> +	default:
> +		pr_err("Encryptio of IV failed for GCM mode");

Encryption.

> +		break;
> +	}
> +
> +	ablkcipher_request_free(ablk_req);
> +	crypto_free_ablkcipher(tfm);
> +	return ret;
> +}
> +
> +void omap_aes_gcm_dma_out_callback(void *data)
> +{
> +	struct omap_aes_dev *dd =3D data;
> +	int i, val;
> +	u32 *auth_tag, tag[4];
> +
> +	if (!(dd->flags & FLAGS_ENCRYPT))
> +		scatterwalk_map_and_copy(tag, dd->aead_req->src, dd->total,
> +					 dd->authsize, 0);
> +
> +	auth_tag =3D dd->ctx->auth_tag;
> +	for (i =3D 0; i < 4; i++) {
> +		val =3D omap_aes_read(dd, AES_REG_TAG_N(dd, i));
> +		auth_tag[i] =3D val ^ auth_tag[i];
> +		if (!(dd->flags & FLAGS_ENCRYPT))
> +			auth_tag[i] =3D auth_tag[i] ^ tag[i];
> +	}
> +
> +	/* dma_lch_out - completed */
> +	omap_aes_gcm_done_task(dd);
> +}
> +
> +static int omap_aes_gcm_handle_queue(struct omap_aes_dev *dd,
> +				     struct aead_request *req)
> +{
> +	struct omap_aes_ctx *ctx;
> +	struct crypto_async_request *async_req, *backlog;
> +	struct omap_aes_reqctx *rctx;
> +	unsigned long flags;
> +	int err, ret =3D 0;
> +
> +	spin_lock_irqsave(&dd->lock, flags);
> +	if (req)
> +		ret =3D crypto_enqueue_request(&dd->aead_queue, &req->base);
> +	if (dd->flags & FLAGS_BUSY) {
> +		spin_unlock_irqrestore(&dd->lock, flags);
> +		return ret;
> +	}
> +	backlog =3D crypto_get_backlog(&dd->aead_queue);
> +	async_req =3D crypto_dequeue_request(&dd->aead_queue);
> +	if (async_req)
> +		dd->flags |=3D FLAGS_BUSY;
> +	spin_unlock_irqrestore(&dd->lock, flags);
> +
> +	if (!async_req)
> +		return ret;
> +
> +	if (backlog)
> +		backlog->complete(backlog, -EINPROGRESS);
> +
> +	req =3D aead_request_cast(async_req);
> +
> +	ctx =3D crypto_aead_ctx(crypto_aead_reqtfm(req));
> +	rctx =3D aead_request_ctx(req);
> +
> +	dd->ctx =3D ctx;
> +	ctx->dd =3D dd;
> +	dd->aead_req =3D req;
> +
> +	rctx->mode &=3D FLAGS_MODE_MASK;
> +	dd->flags =3D (dd->flags & ~FLAGS_MODE_MASK) | rctx->mode;
> +
> +	err =3D omap_aes_gcm_copy_buffers(dd, req);
> +	if (err)
> +		return err;
> +
> +	err =3D omap_aes_write_ctrl(dd);
> +	if (!err)
> +		err =3D omap_aes_crypt_dma_start(dd);
> +
> +	if (err) {
> +		omap_aes_gcm_finish_req(dd, err);
> +		omap_aes_gcm_handle_queue(dd, NULL);
> +	}
> +
> +	return ret;
> +}
> +
> +static int omap_aes_gcm_crypt(struct aead_request *req, unsigned long mo=
de)
> +{
> +	struct omap_aes_ctx *ctx =3D crypto_aead_ctx(crypto_aead_reqtfm(req));
> +	struct omap_aes_reqctx *rctx =3D aead_request_ctx(req);
> +	struct omap_aes_dev *dd;
> +	__be32 counter =3D cpu_to_be32(1);
> +	int err;
> +
> +	memset(ctx->auth_tag, 0, sizeof(ctx->auth_tag));
> +	memcpy(req->iv + 12, &counter, 4);
> +
> +	/* Create E(K, IV) */
> +	err =3D do_encrypt_iv(req, ctx->auth_tag);
> +	if (err)
> +		return err;
> +
> +	dd =3D omap_aes_find_dev(ctx);
> +	if (!dd)
> +		return -ENODEV;
> +	rctx->mode =3D mode;
> +
> +	return omap_aes_gcm_handle_queue(dd, req);
> +}
> +
> +int omap_aes_gcm_encrypt(struct aead_request *req)
> +{
> +	return omap_aes_gcm_crypt(req, FLAGS_ENCRYPT | FLAGS_GCM);
> +}
> +
> +int omap_aes_gcm_decrypt(struct aead_request *req)
> +{
> +	return omap_aes_gcm_crypt(req, FLAGS_GCM);
> +}
> +
> +int omap_aes_gcm_setkey(struct crypto_aead *tfm, const u8 *key,
> +			unsigned int keylen)
> +{
> +	struct omap_aes_ctx *ctx =3D crypto_aead_ctx(tfm);
> +
> +	if (keylen !=3D AES_KEYSIZE_128 && keylen !=3D AES_KEYSIZE_192 &&
> +	    keylen !=3D AES_KEYSIZE_256)
> +		return -EINVAL;
> +
> +	memcpy(ctx->key, key, keylen);
> +	ctx->keylen =3D keylen;
> +
> +	return 0;
> +}
> diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
> index d974ab6..e5e9a19 100644
> --- a/drivers/crypto/omap-aes.c
> +++ b/drivers/crypto/omap-aes.c
> @@ -36,157 +36,7 @@
>  #include <linux/interrupt.h>
>  #include <crypto/scatterwalk.h>
>  #include <crypto/aes.h>
> -
> -#define DST_MAXBURST			4
> -#define DMA_MIN				(DST_MAXBURST * sizeof(u32))
> -
> -#define _calc_walked(inout) (dd->inout##_walk.offset - dd->inout##_sg->o=
ffset)
> -
> -/* OMAP TRM gives bitfields as start:end, where start is the higher bit
> -   number. For example 7:0 */
> -#define FLD_MASK(start, end)	(((1 << ((start) - (end) + 1)) - 1) << (end=
))
> -#define FLD_VAL(val, start, end) (((val) << (end)) & FLD_MASK(start, end=
))
> -
> -#define AES_REG_KEY(dd, x)		((dd)->pdata->key_ofs - \
> -						((x ^ 0x01) * 0x04))
> -#define AES_REG_IV(dd, x)		((dd)->pdata->iv_ofs + ((x) * 0x04))
> -
> -#define AES_REG_CTRL(dd)		((dd)->pdata->ctrl_ofs)
> -#define AES_REG_CTRL_CTR_WIDTH_MASK	GENMASK(8, 7)
> -#define AES_REG_CTRL_CTR_WIDTH_32	0
> -#define AES_REG_CTRL_CTR_WIDTH_64	BIT(7)
> -#define AES_REG_CTRL_CTR_WIDTH_96	BIT(8)
> -#define AES_REG_CTRL_CTR_WIDTH_128	GENMASK(8, 7)
> -#define AES_REG_CTRL_CTR		BIT(6)
> -#define AES_REG_CTRL_CBC		BIT(5)
> -#define AES_REG_CTRL_KEY_SIZE		GENMASK(4, 3)
> -#define AES_REG_CTRL_DIRECTION		BIT(2)
> -#define AES_REG_CTRL_INPUT_READY	BIT(1)
> -#define AES_REG_CTRL_OUTPUT_READY	BIT(0)
> -#define AES_REG_CTRL_MASK		GENMASK(24, 2)
> -
> -#define AES_REG_DATA_N(dd, x)		((dd)->pdata->data_ofs + ((x) * 0x04))
> -
> -#define AES_REG_REV(dd)			((dd)->pdata->rev_ofs)
> -
> -#define AES_REG_MASK(dd)		((dd)->pdata->mask_ofs)
> -#define AES_REG_MASK_SIDLE		BIT(6)
> -#define AES_REG_MASK_START		BIT(5)
> -#define AES_REG_MASK_DMA_OUT_EN		BIT(3)
> -#define AES_REG_MASK_DMA_IN_EN		BIT(2)
> -#define AES_REG_MASK_SOFTRESET		BIT(1)
> -#define AES_REG_AUTOIDLE		BIT(0)
> -
> -#define AES_REG_LENGTH_N(x)		(0x54 + ((x) * 0x04))
> -
> -#define AES_REG_IRQ_STATUS(dd)         ((dd)->pdata->irq_status_ofs)
> -#define AES_REG_IRQ_ENABLE(dd)         ((dd)->pdata->irq_enable_ofs)
> -#define AES_REG_IRQ_DATA_IN            BIT(1)
> -#define AES_REG_IRQ_DATA_OUT           BIT(2)
> -#define DEFAULT_TIMEOUT		(5*HZ)
> -
> -#define FLAGS_MODE_MASK		0x000f
> -#define FLAGS_ENCRYPT		BIT(0)
> -#define FLAGS_CBC		BIT(1)
> -#define FLAGS_GIV		BIT(2)
> -#define FLAGS_CTR		BIT(3)
> -
> -#define FLAGS_INIT		BIT(4)
> -#define FLAGS_FAST		BIT(5)
> -#define FLAGS_BUSY		BIT(6)
> -
> -#define AES_BLOCK_WORDS		(AES_BLOCK_SIZE >> 2)
> -
> -struct omap_aes_ctx {
> -	struct omap_aes_dev *dd;
> -
> -	int		keylen;
> -	u32		key[AES_KEYSIZE_256 / sizeof(u32)];
> -	unsigned long	flags;
> -};
> -
> -struct omap_aes_reqctx {
> -	unsigned long mode;
> -};
> -
> -#define OMAP_AES_QUEUE_LENGTH	1
> -#define OMAP_AES_CACHE_SIZE	0
> -
> -struct omap_aes_algs_info {
> -	struct crypto_alg	*algs_list;
> -	unsigned int		size;
> -	unsigned int		registered;
> -};
> -
> -struct omap_aes_pdata {
> -	struct omap_aes_algs_info	*algs_info;
> -	unsigned int	algs_info_size;
> -
> -	void		(*trigger)(struct omap_aes_dev *dd, int length);
> -
> -	u32		key_ofs;
> -	u32		iv_ofs;
> -	u32		ctrl_ofs;
> -	u32		data_ofs;
> -	u32		rev_ofs;
> -	u32		mask_ofs;
> -	u32             irq_enable_ofs;
> -	u32             irq_status_ofs;
> -
> -	u32		dma_enable_in;
> -	u32		dma_enable_out;
> -	u32		dma_start;
> -
> -	u32		major_mask;
> -	u32		major_shift;
> -	u32		minor_mask;
> -	u32		minor_shift;
> -};
> -
> -struct omap_aes_dev {
> -	struct list_head	list;
> -	unsigned long		phys_base;
> -	void __iomem		*io_base;
> -	struct omap_aes_ctx	*ctx;
> -	struct device		*dev;
> -	unsigned long		flags;
> -	int			err;
> -
> -	spinlock_t		lock;
> -	struct crypto_queue	queue;
> -
> -	struct tasklet_struct	done_task;
> -	struct tasklet_struct	queue_task;
> -
> -	struct ablkcipher_request	*req;
> -
> -	/*
> -	 * total is used by PIO mode for book keeping so introduce
> -	 * variable total_save as need it to calc page_order
> -	 */
> -	size_t				total;
> -	size_t				total_save;
> -
> -	struct scatterlist		*in_sg;
> -	struct scatterlist		*out_sg;
> -
> -	/* Buffers for copying for unaligned cases */
> -	struct scatterlist		in_sgl;
> -	struct scatterlist		out_sgl;
> -	struct scatterlist		*orig_out;
> -	int				sgs_copied;
> -
> -	struct scatter_walk		in_walk;
> -	struct scatter_walk		out_walk;
> -	int			dma_in;
> -	struct dma_chan		*dma_lch_in;
> -	int			dma_out;
> -	struct dma_chan		*dma_lch_out;
> -	int			in_sg_len;
> -	int			out_sg_len;
> -	int			pio_only;
> -	const struct omap_aes_pdata	*pdata;
> -};
> +#include "omap-aes.h"
> =20
>  /* keep registered devices data here */
>  static LIST_HEAD(dev_list);
> @@ -202,7 +52,7 @@ static DEFINE_SPINLOCK(list_lock);
>  	_read_ret;						\
>  })
>  #else
> -static inline u32 omap_aes_read(struct omap_aes_dev *dd, u32 offset)
> +inline u32 omap_aes_read(struct omap_aes_dev *dd, u32 offset)
>  {
>  	return __raw_readl(dd->io_base + offset);
>  }
> @@ -216,7 +66,7 @@ static inline u32 omap_aes_read(struct omap_aes_dev *d=
d, u32 offset)
>  		__raw_writel(value, dd->io_base + offset);		\
>  	} while (0)
>  #else
> -static inline void omap_aes_write(struct omap_aes_dev *dd, u32 offset,
> +inline void omap_aes_write(struct omap_aes_dev *dd, u32 offset,
>  				  u32 value)
>  {
>  	__raw_writel(value, dd->io_base + offset);
> @@ -251,7 +101,7 @@ static int omap_aes_hw_init(struct omap_aes_dev *dd)
>  	return 0;
>  }
> =20
> -static int omap_aes_write_ctrl(struct omap_aes_dev *dd)
> +int omap_aes_write_ctrl(struct omap_aes_dev *dd)
>  {
>  	unsigned int key32;
>  	int i, err;
> @@ -263,7 +113,11 @@ static int omap_aes_write_ctrl(struct omap_aes_dev *=
dd)
> =20
>  	key32 =3D dd->ctx->keylen / sizeof(u32);
> =20
> -	/* it seems a key should always be set even if it has not changed */
> +	/* RESET the key as previous HASH keys should not get affected*/
> +	if (dd->flags & FLAGS_GCM)
> +		for (i =3D 0; i < 0x40; i =3D i + 4)
> +			omap_aes_write(dd, i, 0x0);
> +
>  	for (i =3D 0; i < key32; i++) {
>  		omap_aes_write(dd, AES_REG_KEY(dd, i),
>  			__le32_to_cpu(dd->ctx->key[i]));
> @@ -272,12 +126,20 @@ static int omap_aes_write_ctrl(struct omap_aes_dev =
*dd)
>  	if ((dd->flags & (FLAGS_CBC | FLAGS_CTR)) && dd->req->info)
>  		omap_aes_write_n(dd, AES_REG_IV(dd, 0), dd->req->info, 4);
> =20
> +	if ((dd->flags & (FLAGS_GCM)) && dd->aead_req->iv)
> +		omap_aes_write_n(dd, AES_REG_IV(dd, 0),
> +				 (u32 *)dd->aead_req->iv, 4);
> +
>  	val =3D FLD_VAL(((dd->ctx->keylen >> 3) - 1), 4, 3);
>  	if (dd->flags & FLAGS_CBC)
>  		val |=3D AES_REG_CTRL_CBC;
> -	if (dd->flags & FLAGS_CTR)
> +
> +	if (dd->flags & (FLAGS_CTR | FLAGS_GCM))
>  		val |=3D AES_REG_CTRL_CTR | AES_REG_CTRL_CTR_WIDTH_128;
> =20
> +	if (dd->flags & FLAGS_GCM)
> +		val |=3D AES_REG_CTRL_GCM;
> +
>  	if (dd->flags & FLAGS_ENCRYPT)
>  		val |=3D AES_REG_CTRL_DIRECTION;
> =20
> @@ -308,6 +170,8 @@ static void omap_aes_dma_trigger_omap4(struct omap_ae=
s_dev *dd, int length)
>  {
>  	omap_aes_write(dd, AES_REG_LENGTH_N(0), length);
>  	omap_aes_write(dd, AES_REG_LENGTH_N(1), 0);
> +	if (dd->flags & FLAGS_GCM)
> +		omap_aes_write(dd, AES_REG_A_LEN, dd->assoc_len);
> =20
>  	omap_aes_dma_trigger_omap2(dd, length);
>  }
> @@ -322,7 +186,7 @@ static void omap_aes_dma_stop(struct omap_aes_dev *dd)
>  	omap_aes_write_mask(dd, AES_REG_MASK(dd), 0, mask);
>  }
> =20
> -static struct omap_aes_dev *omap_aes_find_dev(struct omap_aes_ctx *ctx)
> +struct omap_aes_dev *omap_aes_find_dev(struct omap_aes_ctx *ctx)
>  {
>  	struct omap_aes_dev *dd =3D NULL, *tmp;
> =20
> @@ -410,12 +274,11 @@ static void sg_copy_buf(void *buf, struct scatterli=
st *sg,
>  	scatterwalk_done(&walk, out, 0);
>  }
> =20
> -static int omap_aes_crypt_dma(struct crypto_tfm *tfm,
> -		struct scatterlist *in_sg, struct scatterlist *out_sg,
> -		int in_sg_len, int out_sg_len)
> +static int omap_aes_crypt_dma(struct omap_aes_dev *dd,
> +			      struct scatterlist *in_sg,
> +			      struct scatterlist *out_sg,
> +			      int in_sg_len, int out_sg_len)
>  {
> -	struct omap_aes_ctx *ctx =3D crypto_tfm_ctx(tfm);
> -	struct omap_aes_dev *dd =3D ctx->dd;
>  	struct dma_async_tx_descriptor *tx_in, *tx_out;
>  	struct dma_slave_config cfg;
>  	int ret;
> @@ -476,7 +339,10 @@ static int omap_aes_crypt_dma(struct crypto_tfm *tfm,
>  		return -EINVAL;
>  	}
> =20
> -	tx_out->callback =3D omap_aes_dma_out_callback;
> +	if (dd->flags & FLAGS_GCM)
> +		tx_out->callback =3D omap_aes_gcm_dma_out_callback;
> +	else
> +		tx_out->callback =3D omap_aes_dma_out_callback;
>  	tx_out->callback_param =3D dd;
> =20
>  	dmaengine_submit(tx_in);
> @@ -491,10 +357,8 @@ static int omap_aes_crypt_dma(struct crypto_tfm *tfm,
>  	return 0;
>  }
> =20
> -static int omap_aes_crypt_dma_start(struct omap_aes_dev *dd)
> +int omap_aes_crypt_dma_start(struct omap_aes_dev *dd)
>  {
> -	struct crypto_tfm *tfm =3D crypto_ablkcipher_tfm(
> -					crypto_ablkcipher_reqtfm(dd->req));
>  	int err;
> =20
>  	pr_debug("total: %d\n", dd->total);
> @@ -515,7 +379,7 @@ static int omap_aes_crypt_dma_start(struct omap_aes_d=
ev *dd)
>  		}
>  	}
> =20
> -	err =3D omap_aes_crypt_dma(tfm, dd->in_sg, dd->out_sg, dd->in_sg_len,
> +	err =3D omap_aes_crypt_dma(dd, dd->in_sg, dd->out_sg, dd->in_sg_len,
>  				 dd->out_sg_len);
>  	if (err && !dd->pio_only) {
>  		dma_unmap_sg(dd->dev, dd->in_sg, dd->in_sg_len, DMA_TO_DEVICE);
> @@ -537,7 +401,7 @@ static void omap_aes_finish_req(struct omap_aes_dev *=
dd, int err)
>  	req->base.complete(&req->base, err);
>  }
> =20
> -static int omap_aes_crypt_dma_stop(struct omap_aes_dev *dd)
> +int omap_aes_crypt_dma_stop(struct omap_aes_dev *dd)
>  {
>  	int err =3D 0;
> =20
> @@ -551,7 +415,7 @@ static int omap_aes_crypt_dma_stop(struct omap_aes_de=
v *dd)
>  	return err;
>  }
> =20
> -static int omap_aes_check_aligned(struct scatterlist *sg, int total)
> +int omap_aes_check_aligned(struct scatterlist *sg, int total)
>  {
>  	int len =3D 0;
> =20
> @@ -594,9 +458,9 @@ static int omap_aes_copy_sgs(struct omap_aes_dev *dd)
> =20
>  	sg_copy_buf(buf_in, dd->in_sg, 0, dd->total, 0);
> =20
> -	sg_init_table(&dd->in_sgl, 1);
> -	sg_set_buf(&dd->in_sgl, buf_in, total);
> -	dd->in_sg =3D &dd->in_sgl;
> +	sg_init_table(dd->in_sgl, 1);
> +	sg_set_buf(dd->in_sgl, buf_in, total);
> +	dd->in_sg =3D dd->in_sgl;
> =20
>  	sg_init_table(&dd->out_sgl, 1);
>  	sg_set_buf(&dd->out_sgl, buf_out, total);
> @@ -665,6 +529,7 @@ static int omap_aes_handle_queue(struct omap_aes_dev =
*dd,
>  	ctx->dd =3D dd;
> =20
>  	err =3D omap_aes_write_ctrl(dd);
> +
>  	if (!err)
>  		err =3D omap_aes_crypt_dma_start(dd);
>  	if (err) {
> @@ -694,7 +559,7 @@ static void omap_aes_done_task(unsigned long data)
>  	}
> =20
>  	if (dd->sgs_copied) {
> -		buf_in =3D sg_virt(&dd->in_sgl);
> +		buf_in =3D sg_virt(dd->in_sgl);
>  		buf_out =3D sg_virt(&dd->out_sgl);
> =20
>  		sg_copy_buf(buf_out, dd->orig_out, 0, dd->total_save, 1);
> @@ -811,6 +676,30 @@ static int omap_aes_cra_init(struct crypto_tfm *tfm)
>  	return 0;
>  }
> =20
> +static int omap_aes_gcm_cra_init(struct crypto_tfm *tfm)
> +{
> +	struct omap_aes_dev *dd =3D NULL;
> +	int err;
> +
> +	/* Find AES device, currently picks the first device */
> +	spin_lock_bh(&list_lock);
> +	list_for_each_entry(dd, &dev_list, list) {
> +		break;
> +	}
> +	spin_unlock_bh(&list_lock);
> +
> +	err =3D pm_runtime_get_sync(dd->dev);
> +	if (err < 0) {
> +		dev_err(dd->dev, "%s: failed to get_sync(%d)\n",
> +			__func__, err);
> +		return err;
> +	}
> +
> +	tfm->crt_aead.reqsize =3D sizeof(struct omap_aes_reqctx);
> +
> +	return 0;
> +}
> +
>  static void omap_aes_cra_exit(struct crypto_tfm *tfm)
>  {
>  	struct omap_aes_dev *dd =3D NULL;
> @@ -899,7 +788,7 @@ static struct crypto_alg algs_ctr[] =3D {
>  		.encrypt	=3D omap_aes_ctr_encrypt,
>  		.decrypt	=3D omap_aes_ctr_decrypt,
>  	}
> -} ,
> +},
>  };
> =20
>  static struct omap_aes_algs_info omap_aes_algs_info_ecb_cbc[] =3D {
> @@ -1179,6 +1068,7 @@ static int omap_aes_probe(struct platform_device *p=
dev)
> =20
>  	spin_lock_init(&dd->lock);
>  	crypto_init_queue(&dd->queue, OMAP_AES_QUEUE_LENGTH);
> +	crypto_init_queue(&dd->aead_queue, OMAP_AES_QUEUE_LENGTH);
> =20
>  	err =3D (dev->of_node) ? omap_aes_get_res_of(dd, dev, &res) :
>  			       omap_aes_get_res_pdev(dd, pdev, &res);
> diff --git a/drivers/crypto/omap-aes.h b/drivers/crypto/omap-aes.h
> new file mode 100644
> index 0000000..0863874
> --- /dev/null
> +++ b/drivers/crypto/omap-aes.h
> @@ -0,0 +1,205 @@
> +/*
> + * Cryptographic API.
> + *
> + * Support for OMAP AES HW ACCELERATOR defines
> + *
> + * Copyright (c) 2015 Texas Instruments Incorporated
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as pub=
lished
> + * by the Free Software Foundation.
> + *
> + */
> +#ifndef __OMAP_AES_REGS_H__
> +#define __OMAP_AES_REGS_H__
> +
> +#define DST_MAXBURST			4
> +#define DMA_MIN				(DST_MAXBURST * sizeof(u32))
> +
> +#define _calc_walked(inout) (dd->inout##_walk.offset - dd->inout##_sg->o=
ffset)
> +
> +/* OMAP TRM gives bitfields as start:end, where start is the higher bit
> +   number. For example 7:0 */
> +#define FLD_MASK(start, end)	(((1 << ((start) - (end) + 1)) - 1) << (end=
))
> +#define FLD_VAL(val, start, end) (((val) << (end)) & FLD_MASK(start, end=
))
> +
> +#define AES_REG_KEY(dd, x)		((dd)->pdata->key_ofs - \
> +						((x ^ 0x01) * 0x04))
> +#define AES_REG_IV(dd, x)		((dd)->pdata->iv_ofs + ((x) * 0x04))
> +
> +#define AES_REG_CTRL(dd)		((dd)->pdata->ctrl_ofs)
> +#define AES_REG_CTRL_CONTEXT_READY	BIT(31)
> +#define AES_REG_CTRL_CTR_WIDTH_MASK	GENMASK(8, 7)
> +#define AES_REG_CTRL_CTR_WIDTH_32	0
> +#define AES_REG_CTRL_CTR_WIDTH_64	BIT(7)
> +#define AES_REG_CTRL_CTR_WIDTH_96	BIT(8)
> +#define AES_REG_CTRL_CTR_WIDTH_128	GENMASK(8, 7)
> +#define AES_REG_CTRL_GCM		GENMASK(17, 16)
> +#define AES_REG_CTRL_CTR		BIT(6)
> +#define AES_REG_CTRL_CBC		BIT(5)
> +#define AES_REG_CTRL_KEY_SIZE		GENMASK(4, 3)
> +#define AES_REG_CTRL_DIRECTION		BIT(2)
> +#define AES_REG_CTRL_INPUT_READY	BIT(1)
> +#define AES_REG_CTRL_OUTPUT_READY	BIT(0)
> +#define AES_REG_CTRL_MASK		GENMASK(24, 2)
> +
> +#define AES_REG_C_LEN_0			0x54
> +#define AES_REG_C_LEN_1			0x58
> +#define AES_REG_A_LEN			0x5C
> +
> +#define AES_REG_DATA_N(dd, x)		((dd)->pdata->data_ofs + ((x) * 0x04))
> +#define AES_REG_TAG_N(dd, x)		(0x70 + ((x) * 0x04))
> +
> +#define AES_REG_REV(dd)			((dd)->pdata->rev_ofs)
> +
> +#define AES_REG_MASK(dd)		((dd)->pdata->mask_ofs)
> +#define AES_REG_MASK_SIDLE		BIT(6)
> +#define AES_REG_MASK_START		BIT(5)
> +#define AES_REG_MASK_DMA_OUT_EN		BIT(3)
> +#define AES_REG_MASK_DMA_IN_EN		BIT(2)
> +#define AES_REG_MASK_SOFTRESET		BIT(1)
> +#define AES_REG_AUTOIDLE		BIT(0)
> +
> +#define AES_REG_LENGTH_N(x)		(0x54 + ((x) * 0x04))
> +
> +#define AES_REG_IRQ_STATUS(dd)         ((dd)->pdata->irq_status_ofs)
> +#define AES_REG_IRQ_ENABLE(dd)         ((dd)->pdata->irq_enable_ofs)
> +#define AES_REG_IRQ_DATA_IN            BIT(1)
> +#define AES_REG_IRQ_DATA_OUT           BIT(2)
> +#define DEFAULT_TIMEOUT		(5 * HZ)
> +
> +#define FLAGS_MODE_MASK		0x001f
> +#define FLAGS_ENCRYPT		BIT(0)
> +#define FLAGS_CBC		BIT(1)
> +#define FLAGS_GIV		BIT(2)
> +#define FLAGS_CTR		BIT(3)
> +#define FLAGS_GCM		BIT(4)
> +
> +#define FLAGS_INIT		BIT(5)
> +#define FLAGS_FAST		BIT(6)
> +#define FLAGS_BUSY		BIT(7)
> +
> +#define AES_ASSOC_DATA_COPIED	BIT(0)
> +#define AES_IN_DATA_COPIED	BIT(1)
> +#define AES_OUT_DATA_COPIED	BIT(2)
> +
> +#define AES_BLOCK_WORDS		(AES_BLOCK_SIZE >> 2)
> +
> +struct tcrypt_result {
> +	struct completion completion;
> +	int err;
> +};
> +
> +struct omap_aes_ctx {
> +	struct omap_aes_dev *dd;
> +
> +	int		keylen;
> +	u32		key[AES_KEYSIZE_256 / sizeof(u32)];
> +	u32		auth_tag[AES_BLOCK_SIZE / sizeof(u32)];
> +	unsigned long	flags;
> +};
> +
> +struct omap_aes_reqctx {
> +	unsigned long mode;
> +};
> +
> +#define OMAP_AES_QUEUE_LENGTH	1
> +#define OMAP_AES_CACHE_SIZE	0
> +
> +struct omap_aes_algs_info {
> +	struct crypto_alg	*algs_list;
> +	unsigned int		size;
> +	unsigned int		registered;
> +};
> +
> +struct omap_aes_pdata {
> +	struct omap_aes_algs_info	*algs_info;
> +	unsigned int	algs_info_size;
> +
> +	void (*trigger)(struct omap_aes_dev *dd, int length);
> +
> +	u32		key_ofs;
> +	u32		iv_ofs;
> +	u32		ctrl_ofs;
> +	u32		data_ofs;
> +	u32		rev_ofs;
> +	u32		mask_ofs;
> +	u32             irq_enable_ofs;
> +	u32             irq_status_ofs;
> +
> +	u32		dma_enable_in;
> +	u32		dma_enable_out;
> +	u32		dma_start;
> +
> +	u32		major_mask;
> +	u32		major_shift;
> +	u32		minor_mask;
> +	u32		minor_shift;
> +};
> +
> +struct omap_aes_dev {
> +	struct list_head	list;
> +	unsigned long		phys_base;
> +	void __iomem		*io_base;
> +	struct omap_aes_ctx	*ctx;
> +	struct device		*dev;
> +	unsigned long		flags;
> +	int			err;
> +
> +	/* Lock to acquire omap_aes_dd */
> +	spinlock_t		lock;
> +	struct crypto_queue	queue;
> +	struct crypto_queue	aead_queue;
> +
> +	struct tasklet_struct	done_task;
> +	struct tasklet_struct	queue_task;
> +
> +	struct ablkcipher_request	*req;
> +	struct aead_request		*aead_req;
> +
> +	/*
> +	 * total is used by PIO mode for book keeping so introduce
> +	 * variable total_save as need it to calc page_order
> +	 */
> +	size_t				total;
> +	size_t				total_save;
> +	size_t				assoc_len;
> +	size_t				authsize;
> +
> +	struct scatterlist		*in_sg;
> +	struct scatterlist		*assoc_sg;
> +	struct scatterlist		*out_sg;
> +
> +	/* Buffers for copying for unaligned cases */
> +	struct scatterlist		in_sgl[2];
> +	struct scatterlist		out_sgl;
> +	struct scatterlist		aead_sgl[2];
> +	struct scatterlist		*orig_out;
> +	int				sgs_copied;
> +
> +	struct scatter_walk		in_walk;
> +	struct scatter_walk		out_walk;
> +	int			dma_in;
> +	struct dma_chan		*dma_lch_in;
> +	int			dma_out;
> +	struct dma_chan		*dma_lch_out;
> +	int			in_sg_len;
> +	int			out_sg_len;
> +	int			pio_only;
> +	const struct omap_aes_pdata	*pdata;
> +};
> +
> +u32 omap_aes_read(struct omap_aes_dev *dd, u32 offset);
> +void omap_aes_write(struct omap_aes_dev *dd, u32 offset, u32 value);
> +struct omap_aes_dev *omap_aes_find_dev(struct omap_aes_ctx *ctx);
> +int omap_aes_gcm_setkey(struct crypto_aead *tfm, const u8 *key,
> +			unsigned int keylen);
> +int omap_aes_gcm_encrypt(struct aead_request *req);
> +int omap_aes_gcm_decrypt(struct aead_request *req);
> +int omap_aes_write_ctrl(struct omap_aes_dev *dd);
> +int omap_aes_check_aligned(struct scatterlist *sg, int total);
> +int omap_aes_crypt_dma_start(struct omap_aes_dev *dd);
> +void omap_aes_gcm_dma_out_callback(void *data);
> +int omap_aes_crypt_dma_stop(struct omap_aes_dev *dd);
> +
> +#endif
> --=20
> 1.7.9.5
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

--=20
balbi

--BQPnanjtCNWHyqYD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJVlPCBAAoJEIaOsuA1yqRElfgP/jstQOahYVjy7N7aeE56wK4C
5c+9R27LdA9GgrpsB/BinSVICGtTBI2hkydMIvAvRnk2mxR9/HehCP5LkbBxXnyQ
O6MrTsc5zQyEMLgCd8JK2CekZt5EYQl10sAjPTW0Q/AIjGsWjdEShk1etCCnsGAi
ovDe6rHQWesqah76t922A65NTViHDYLvRzqH8j7+CrgX81c0yiETfj4tqrzKVOBs
wRCrLbMM4POtXtgQTHMACEqL03EVnzeU/TyPmd/pnMT1RRpcz33wPr9IixShU/gD
FeQ1Rb4tcrXZoK0Q1CpfL9TNCF8YjcnkOfzXGYG0zn/Lrvhc8B2DjogVjONeAvLN
5mVBgM52ErKqwI1rRWTSrdyvImj7yWzFDZS6D/uRwWCXibX86VL5KDBDyeU02F/9
QpaEJyS2WxxbIP8NPOJIYHS2WsQt9pgO+OSigWLireM/xoenlb3CQ2n8F+jg7FkP
RyTow8QxadkgvkjKkHi/HZlIwlvpud77pzqiZiJADsoBUyuU/7nIVqTkVY+WZCTH
wIg39+/dcY9tA6WErlygMJbX8mWasyuJH9ljFSGRYZUD5Z9u99F4fCVd3W/XCOi1
fPWp3ZYKn/6dDGN8fEm7ohHkjCRQpH/uTJKPjXmVBncrBGfDRFlprQyu5xDLTSQX
bczV5It5Eh7JHCxARFKx
=RbP/
-----END PGP SIGNATURE-----

--BQPnanjtCNWHyqYD--
