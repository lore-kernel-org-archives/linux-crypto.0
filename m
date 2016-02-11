From: Lothar =?UTF-8?B?V2HDn21hbm4=?= <LW-bxm8fMRDkQLDiMYJYoSAnRvVK+yQ3ZXh@public.gmane.org>
Subject: Re: [PATCH 3/3] crypto: add basic driver for the MXC SCC
Date: Thu, 11 Feb 2016 16:45:54 +0100
Message-ID: <20160211164554.4091ab73@ipc1.ka-ro>
References: <1455199485-24458-1-git-send-email-s.trumtrar@pengutronix.de>
	<1455199485-24458-3-git-send-email-s.trumtrar@pengutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Shawn Guo <shawnguo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
	Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
	Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>,
	devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>,
	Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>,
	Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	kernel-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>,
	linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
To: Steffen Trumtrar <s.trumtrar-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1455199485-24458-3-git-send-email-s.trumtrar-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

Hi,

On Thu, 11 Feb 2016 15:04:45 +0100 Steffen Trumtrar wrote:
> According to the Freescale GPL driver code, there are two different
> Security Controller (SCC) versions: SCC and SCC2.
>=20
> The SCC is found on older i.MX SoCs, e.g. the i.MX25. This is the
> version implemented and tested here.
>=20
> As there is no publicly available documentation for this IP core,
> all information about this unit is gathered from the GPL'ed driver
> from Freescale.
>=20
> Signed-off-by: Steffen Trumtrar <s.trumtrar-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org>
> ---
>  drivers/crypto/Kconfig   |   9 +
>  drivers/crypto/Makefile  |   1 +
>  drivers/crypto/mxc-scc.c | 756 +++++++++++++++++++++++++++++++++++++=
++++++++++
>  3 files changed, 766 insertions(+)
>  create mode 100644 drivers/crypto/mxc-scc.c
>=20
> diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
> index 07d494276aad..ece3e231ee4d 100644
> --- a/drivers/crypto/Kconfig
> +++ b/drivers/crypto/Kconfig
> @@ -339,6 +339,15 @@ config CRYPTO_DEV_SAHARA
>  	  This option enables support for the SAHARA HW crypto accelerator
>  	  found in some Freescale i.MX chips.
> =20
> +config CRYPTO_DEV_MXC_SCC
> +	tristate "Support for Freescale Security Controller (SCC)"
> +	depends on ARCH_MXC && OF
> +	select CRYPTO_BLKCIPHER
> +	select CRYPTO_DES
> +	help
> +	  This option enables support for the Security Controller (SCC)
> +	  found in Freescale i.MX25 chips.
> +
>  config CRYPTO_DEV_S5P
>  	tristate "Support for Samsung S5PV210/Exynos crypto accelerator"
>  	depends on ARCH_S5PV210 || ARCH_EXYNOS
> diff --git a/drivers/crypto/Makefile b/drivers/crypto/Makefile
> index 713de9d11148..3c6432dd09d9 100644
> --- a/drivers/crypto/Makefile
> +++ b/drivers/crypto/Makefile
> @@ -23,6 +23,7 @@ obj-$(CONFIG_CRYPTO_DEV_PICOXCELL) +=3D picoxcell_c=
rypto.o
>  obj-$(CONFIG_CRYPTO_DEV_PPC4XX) +=3D amcc/
>  obj-$(CONFIG_CRYPTO_DEV_S5P) +=3D s5p-sss.o
>  obj-$(CONFIG_CRYPTO_DEV_SAHARA) +=3D sahara.o
> +obj-$(CONFIG_CRYPTO_DEV_MXC_SCC) +=3D mxc-scc.o
>  obj-$(CONFIG_CRYPTO_DEV_TALITOS) +=3D talitos.o
>  obj-$(CONFIG_CRYPTO_DEV_UX500) +=3D ux500/
>  obj-$(CONFIG_CRYPTO_DEV_QAT) +=3D qat/
> diff --git a/drivers/crypto/mxc-scc.c b/drivers/crypto/mxc-scc.c
> new file mode 100644
> index 000000000000..f8cc00d1d92e
> --- /dev/null
> +++ b/drivers/crypto/mxc-scc.c
> @@ -0,0 +1,756 @@
> +/*
> + * Copyright (C) 2016 Pengutronix, Steffen Trumtrar <kernel@pengutro=
nix.de>
> + *
> + * The driver is based on information gathered from
> + * drivers/mxc/security/mxc_scc.c which can be found in
> + * the Freescale linux-2.6-imx.git in the imx_2.6.35_maintain branch=
=2E
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * version 2, as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + */
> +#include <linux/clk.h>
> +#include <linux/crypto.h>
> +#include <linux/interrupt.h>
> +#include <linux/io.h>
> +#include <linux/irq.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/mutex.h>
> +#include <linux/of.h>
> +#include <linux/of_device.h>
> +#include <linux/platform_device.h>
> +
> +#include <crypto/algapi.h>
> +#include <crypto/des.h>
> +
> +/* Secure Memory (SCM) registers */
> +#define SCC_SCM_RED_START		0x0000
> +#define SCC_SCM_BLACK_START		0x0004
> +#define SCC_SCM_LENGTH			0x0008
> +#define SCC_SCM_CTRL			0x000C
> +#define SCC_SCM_STATUS			0x0010
> +#define SCC_SCM_ERROR_STATUS		0x0014
> +#define SCC_SCM_INTR_CTRL		0x0018
> +#define SCC_SCM_CFG			0x001C
> +#define SCC_SCM_INIT_VECTOR_0		0x0020
> +#define SCC_SCM_INIT_VECTOR_1		0x0024
> +#define SCC_SCM_RED_MEMORY		0x0400
> +#define SCC_SCM_BLACK_MEMORY		0x0800
> +
> +/* Security Monitor (SMN) Registers */
> +#define SCC_SMN_STATUS			0x1000
> +#define SCC_SMN_COMMAND		0x1004
> +#define SCC_SMN_SEQ_START		0x1008
> +#define SCC_SMN_SEQ_END		0x100C
> +#define SCC_SMN_SEQ_CHECK		0x1010
> +#define SCC_SMN_BIT_COUNT		0x1014
> +#define SCC_SMN_BITBANK_INC_SIZE	0x1018
> +#define SCC_SMN_BITBANK_DECREMENT	0x101C
> +#define SCC_SMN_COMPARE_SIZE		0x1020
> +#define SCC_SMN_PLAINTEXT_CHECK	0x1024
> +#define SCC_SMN_CIPHERTEXT_CHECK	0x1028
> +#define SCC_SMN_TIMER_IV		0x102C
> +#define SCC_SMN_TIMER_CONTROL		0x1030
> +#define SCC_SMN_DEBUG_DETECT_STAT	0x1034
> +#define SCC_SMN_TIMER			0x1038
> +
> +#define SCC_SCM_CTRL_START_CIPHER	BIT(2)
> +#define SCC_SCM_CTRL_CBC_MODE		BIT(1)
> +#define SCC_SCM_CTRL_DECRYPT_MODE	BIT(0)
> +
> +#define SCC_SCM_STATUS_LEN_ERR		BIT(12)
> +#define SCC_SCM_STATUS_SMN_UNBLOCKED	BIT(11)
> +#define SCC_SCM_STATUS_CIPHERING_DONE	BIT(10)
> +#define SCC_SCM_STATUS_ZEROIZING_DONE	BIT(9)
> +#define SCC_SCM_STATUS_INTR_STATUS	BIT(8)
> +#define SCC_SCM_STATUS_SEC_KEY		BIT(7)
> +#define SCC_SCM_STATUS_INTERNAL_ERR	BIT(6)
> +#define SCC_SCM_STATUS_BAD_SEC_KEY	BIT(5)
> +#define SCC_SCM_STATUS_ZEROIZE_FAIL	BIT(4)
> +#define SCC_SCM_STATUS_SMN_BLOCKED	BIT(3)
> +#define SCC_SCM_STATUS_CIPHERING	BIT(2)
> +#define SCC_SCM_STATUS_ZEROIZING	BIT(1)
> +#define SCC_SCM_STATUS_BUSY		BIT(0)
> +
> +#define SCC_SMN_STATUS_STATE_MASK	0x0000001F
> +#define SCC_SMN_STATE_START		0x0
> +/* The SMN is zeroizing its RAM during reset */
> +#define SCC_SMN_STATE_ZEROIZE_RAM	0x5
> +/* SMN has passed internal checks */
> +#define SCC_SMN_STATE_HEALTH_CHECK	0x6
> +/* Fatal Security Violation. SMN is locked, SCM is inoperative. */
> +#define SCC_SMN_STATE_FAIL		0x9
> +/* SCC is in secure state. SCM is using secret key. */
> +#define SCC_SMN_STATE_SECURE		0xA
> +/* SCC is not secure. SCM is using default key. */
> +#define SCC_SMN_STATE_NON_SECURE	0xC
> +
> +#define SCC_SCM_INTR_CTRL_ZEROIZE_MEM	BIT(2)
> +#define SCC_SCM_INTR_CTRL_CLR_INTR	BIT(1)
> +#define SCC_SCM_INTR_CTRL_MASK_INTR	BIT(0)
> +
> +/* Size, in blocks, of Red memory. */
> +#define SCC_SCM_CFG_BLACK_SIZE_MASK	0x07fe0000
> +#define SCC_SCM_CFG_BLACK_SIZE_SHIFT	17
> +/* Size, in blocks, of Black memory. */
> +#define SCC_SCM_CFG_RED_SIZE_MASK	0x0001ff80
> +#define SCC_SCM_CFG_RED_SIZE_SHIFT	7
> +/* Number of bytes per block. */
> +#define SCC_SCM_CFG_BLOCK_SIZE_MASK	0x0000007f
> +
> +#define SCC_SMN_COMMAND_TAMPER_LOCK	BIT(4)
> +#define SCC_SMN_COMMAND_CLR_INTR	BIT(3)
> +#define SCC_SMN_COMMAND_CLR_BIT_BANK	BIT(2)
> +#define SCC_SMN_COMMAND_EN_INTR	BIT(1)
> +#define SCC_SMN_COMMAND_SET_SOFTWARE_ALARM  BIT(0)
> +
> +#define SCC_KEY_SLOTS			20
> +#define SCC_MAX_KEY_SIZE		32
> +#define SCC_KEY_SLOT_SIZE		32
> +
> +#define SCC_CRC_CCITT_START		0xFFFF
> +
> +/*
> + * Offset into each RAM of the base of the area which is not
> + * used for Stored Keys.
> + */
> +#define SCC_NON_RESERVED_OFFSET	(SCC_KEY_SLOTS * SCC_KEY_SLOT_SIZE)
> +
> +/* Fixed padding for appending to plaintext to fill out a block */
> +static char scc_block_padding[8] =3D { 0x80, 0, 0, 0, 0, 0, 0, 0 };
> +
> +enum mxc_scc_state {
> +	SCC_STATE_OK,
> +	SCC_STATE_UNIMPLEMENTED,
> +	SCC_STATE_FAILED
> +};
> +
> +struct mxc_scc {
> +	struct device		*dev;
> +	void __iomem		*base;
> +	struct clk		*clk;
> +	struct mutex		mutex;
> +	spinlock_t		lock;
> +	struct crypto_queue	queue;
> +	struct crypto_async_request *req;
> +	int			block_size_bytes;
> +	int			black_ram_size_blocks;
> +	int			memory_size_bytes;
> +	int			bytes_remaining;
> +
> +	void __iomem		*red_memory;
> +	void __iomem		*black_memory;
> +};
> +
> +struct mxc_scc_ctx {
> +	struct mxc_scc		*scc;
> +	struct scatterlist	*sg_src;
> +	size_t			src_nents;
> +	struct scatterlist	*sg_dst;
> +	size_t			dst_nents;
> +	unsigned int		offset;
> +	unsigned int		size;
> +	unsigned int		ctrl;
> +};
> +
> +struct mxc_scc_crypto_tmpl {
> +	struct mxc_scc *scc;
> +	struct crypto_alg alg;
> +};
> +
> +static int mxc_scc_get_data(struct mxc_scc_ctx *ctx,
> +			    struct crypto_async_request *req)
> +{
> +	struct ablkcipher_request *ablkreq =3D ablkcipher_request_cast(req)=
;
> +	struct mxc_scc *scc =3D ctx->scc;
> +	size_t len;
> +	void __iomem *from;
> +
> +	if (ctx->ctrl & SCC_SCM_CTRL_DECRYPT_MODE)
> +		from =3D scc->red_memory;
> +	else
> +		from =3D scc->black_memory;
> +
> +	dev_dbg(scc->dev, "pcopy: from 0x%p %d bytes\n", from,
> +		ctx->dst_nents * 8);
> +	len =3D sg_pcopy_from_buffer(ablkreq->dst, ctx->dst_nents,
> +				   from, ctx->size, ctx->offset);
> +	if (!len) {
> +		dev_err(scc->dev, "pcopy err from 0x%p (len=3D%d)\n", from, len);
> +		return -EINVAL;
> +	}
> +
> +#ifdef DEBUG
> +	print_hex_dump(KERN_ERR,
> +		       "red memory@"__stringify(__LINE__)": ",
> +		       DUMP_PREFIX_ADDRESS, 16, 4,
> +		       scc->red_memory, ctx->size, 1);
> +	print_hex_dump(KERN_ERR,
> +		       "black memory@"__stringify(__LINE__)": ",
> +		       DUMP_PREFIX_ADDRESS, 16, 4,
> +		       scc->black_memory, ctx->size, 1);
> +#endif
> +
> +	ctx->offset +=3D len;
> +
> +	if (ctx->offset < ablkreq->nbytes)
> +		return -EINPROGRESS;
> +
> +	return 0;
> +}
> +
> +static int mxc_scc_ablkcipher_req_init(struct ablkcipher_request *re=
q,
> +				       struct mxc_scc_ctx *ctx)
> +{
> +	struct mxc_scc *scc =3D ctx->scc;
> +
> +	ctx->src_nents =3D sg_nents_for_len(req->src, req->nbytes);
> +	if (ctx->src_nents < 0) {
> +		dev_err(scc->dev, "Invalid number of src SC");
> +		return ctx->src_nents;
> +	}
> +
> +	ctx->dst_nents =3D sg_nents_for_len(req->dst, req->nbytes);
> +	if (ctx->dst_nents < 0) {
> +		dev_err(scc->dev, "Invalid number of dst SC");
> +		return ctx->dst_nents;
> +	}
> +
> +	ctx->size =3D 0;
> +	ctx->offset =3D 0;
> +
> +	return 0;
> +}
> +
> +static int mxc_scc_put_data(struct mxc_scc_ctx *ctx,
> +			     struct ablkcipher_request *req)
> +{
> +	u8 padding_buffer[sizeof(u16) + sizeof(scc_block_padding)];
> +	size_t len =3D min_t(size_t, req->nbytes - ctx->offset,
> +			   ctx->scc->bytes_remaining);
> +	unsigned int padding_byte_count =3D 0;
> +	struct mxc_scc *scc =3D ctx->scc;
> +	void __iomem *to;
> +
> +	if (ctx->ctrl & SCC_SCM_CTRL_DECRYPT_MODE)
> +		to =3D scc->black_memory;
> +	else
> +		to =3D scc->red_memory;
> +
> +	if (ctx->ctrl & SCC_SCM_CTRL_CBC_MODE && req->info)
> +		memcpy(scc->base + SCC_SCM_INIT_VECTOR_0, req->info,
> +		       scc->block_size_bytes);
> +
> +	len =3D sg_pcopy_to_buffer(req->src, ctx->src_nents,
> +				 to, len, ctx->offset);
> +	if (!len) {
> +		dev_err(scc->dev, "pcopy err to 0x%p (len=3D%d)\n", to, len);
> +		return -EINVAL;
> +	}
> +
> +	ctx->size =3D len;
> +
> +#ifdef DEBUG
> +	dev_dbg(scc->dev, "copied %d bytes to 0x%p\n", len, to);
> +	print_hex_dump(KERN_ERR,
> +		       "init vector0@"__stringify(__LINE__)": ",
> +		       DUMP_PREFIX_ADDRESS, 16, 4,
> +		       scc->base + SCC_SCM_INIT_VECTOR_0, scc->block_size_bytes,
> +		       1);
> +	print_hex_dump(KERN_ERR,
> +		       "red memory@"__stringify(__LINE__)": ",
> +		       DUMP_PREFIX_ADDRESS, 16, 4,
> +		       scc->red_memory, ctx->size, 1);
> +	print_hex_dump(KERN_ERR,
> +		       "black memory@"__stringify(__LINE__)": ",
> +		       DUMP_PREFIX_ADDRESS, 16, 4,
> +		       scc->black_memory, ctx->size, 1);
> +#endif
> +
> +	scc->bytes_remaining -=3D len;
> +
> +	padding_byte_count =3D len % scc->block_size_bytes;
> +
> +	if (padding_byte_count) {
> +		memcpy(padding_buffer, scc_block_padding, padding_byte_count);
> +		memcpy(to + len, padding_buffer, padding_byte_count);
> +		ctx->size +=3D padding_byte_count;
> +	}
> +
> +#ifdef DEBUG
> +	print_hex_dump(KERN_ERR,
> +		       "data to encrypt@"__stringify(__LINE__)": ",
> +		       DUMP_PREFIX_ADDRESS, 16, 4,
> +		       to, ctx->size, 1);
> +#endif
> +
> +	return 0;
> +}
> +
> +static void mxc_scc_ablkcipher_next(struct mxc_scc_ctx *ctx,
> +				    struct crypto_async_request *req)
> +{
> +	struct ablkcipher_request *ablkreq =3D ablkcipher_request_cast(req)=
;
> +	struct mxc_scc *scc =3D ctx->scc;
> +	int err;
> +
> +	mutex_lock(&scc->mutex);
> +
> +	dev_dbg(scc->dev, "dispatch request (nbytes=3D%d, src=3D%p, dst=3D%=
p)\n",
> +		ablkreq->nbytes, ablkreq->src, ablkreq->dst);
> +
> +	writel(0, scc->base + SCC_SCM_ERROR_STATUS);
> +
> +	err =3D mxc_scc_put_data(ctx, ablkreq);
> +	if (err)
> +		mutex_unlock(&scc->mutex);
> +
Did you really intend to continue with the mutex unlocked in case of
error, or should the error condition be conveyed to the caller somehow?

> +	dev_dbg(scc->dev, "Start encryption (0x%p/0x%p)\n",
> +		(void *)readl(scc->base + SCC_SCM_RED_START),
> +		(void *)readl(scc->base + SCC_SCM_BLACK_START));
> +
> +	/* clear interrupt control registers */
> +	writel(SCC_SCM_INTR_CTRL_CLR_INTR,
> +	       scc->base + SCC_SCM_INTR_CTRL);
> +
> +	writel((ctx->size / ctx->scc->block_size_bytes) - 1,
> +	       scc->base + SCC_SCM_LENGTH);
> +
> +	dev_dbg(scc->dev, "Process %d block(s) in 0x%p\n",
> +		ctx->size / ctx->scc->block_size_bytes,
> +		(ctx->ctrl & SCC_SCM_CTRL_DECRYPT_MODE) ? scc->black_memory :
> +		scc->red_memory);
> +
> +	writel(ctx->ctrl, scc->base + SCC_SCM_CTRL);
> +}
> +
> +static irqreturn_t mxc_scc_int(int irq, void *priv)
> +{
> +	struct crypto_async_request *req;
> +	struct mxc_scc_ctx *ctx;
> +	struct mxc_scc *scc =3D priv;
> +	int status;
> +	int ret;
> +
> +	status =3D readl(scc->base + SCC_SCM_STATUS);
> +
> +	/* clear interrupt control registers */
> +	writel(SCC_SCM_INTR_CTRL_CLR_INTR, scc->base + SCC_SCM_INTR_CTRL);
> +
> +	if (status & SCC_SCM_STATUS_BUSY)
> +		return IRQ_NONE;
> +
> +	spin_lock_bh(&scc->lock);
> +	req =3D scc->req;
> +	spin_unlock_bh(&scc->lock);
>
What is the purpos of this locking?

> +	if (req) {
> +		ctx =3D crypto_tfm_ctx(req->tfm);
> +		ret =3D mxc_scc_get_data(ctx, req);
> +		if (ret !=3D -EINPROGRESS) {
> +			scc->req =3D NULL;
> +			scc->bytes_remaining =3D scc->memory_size_bytes;
> +			req->complete(req, ret);
> +			mutex_unlock(&scc->mutex);
> +		} else {
> +			mxc_scc_ablkcipher_next(ctx, req);
> +		}
> +	}
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static int mxc_scc_cra_init(struct crypto_tfm *tfm)
> +{
> +	struct mxc_scc_ctx *ctx =3D crypto_tfm_ctx(tfm);
> +	struct crypto_alg *alg =3D tfm->__crt_alg;
> +	struct mxc_scc_crypto_tmpl *algt;
> +
> +	algt =3D container_of(alg, struct mxc_scc_crypto_tmpl, alg);
> +
> +	ctx->scc =3D algt->scc;
> +	return 0;
> +}
> +
> +static void mxc_scc_dequeue_req_unlocked(struct mxc_scc_ctx *ctx)
> +{
> +	struct crypto_async_request *req, *backlog;
> +
> +	spin_lock_bh(&ctx->scc->lock);
> +	backlog =3D crypto_get_backlog(&ctx->scc->queue);
> +	req =3D crypto_dequeue_request(&ctx->scc->queue);
> +	ctx->scc->req =3D req;
> +	spin_unlock_bh(&ctx->scc->lock);
> +
> +	if (!req)
> +		return;
> +
> +	if (backlog)
> +		backlog->complete(backlog, -EINPROGRESS);
> +
> +	ctx =3D crypto_tfm_ctx(req->tfm);
> +	mxc_scc_ablkcipher_next(ctx, req);
> +}
> +
> +
One blank line is sufficient.
=20
> +static int mxc_scc_queue_req(struct mxc_scc_ctx *ctx,
> +			     struct crypto_async_request *req)
> +{
> +	int ret;
> +
> +	spin_lock_bh(&ctx->scc->lock);
> +	ret =3D crypto_enqueue_request(&ctx->scc->queue, req);
> +	spin_unlock_bh(&ctx->scc->lock);
> +
> +	if (ret !=3D -EINPROGRESS)
> +		return ret;
> +
> +	mxc_scc_dequeue_req_unlocked(ctx);
> +
> +	return -EINPROGRESS;
> +}
> +
> +
dto.

> +static int mxc_scc_des3_op(struct mxc_scc_ctx *ctx,
> +			   struct ablkcipher_request *req)
> +{
> +	int err;
> +
> +	err =3D mxc_scc_ablkcipher_req_init(req, ctx);
> +	if (err)
> +		return err;
> +
> +	return mxc_scc_queue_req(ctx, &req->base);
> +}
> +
> +static int mxc_scc_ecb_des_encrypt(struct ablkcipher_request *req)
> +{
> +	struct crypto_ablkcipher *cipher =3D crypto_ablkcipher_reqtfm(req);
> +	struct mxc_scc_ctx *ctx =3D crypto_ablkcipher_ctx(cipher);
> +
> +	ctx->ctrl =3D SCC_SCM_CTRL_START_CIPHER;
> +
> +	return mxc_scc_des3_op(ctx, req);
> +}
> +
> +static int mxc_scc_ecb_des_decrypt(struct ablkcipher_request *req)
> +{
> +	struct crypto_ablkcipher *cipher =3D crypto_ablkcipher_reqtfm(req);
> +	struct mxc_scc_ctx *ctx =3D crypto_ablkcipher_ctx(cipher);
> +
> +	ctx->ctrl =3D SCC_SCM_CTRL_START_CIPHER;
> +	ctx->ctrl |=3D SCC_SCM_CTRL_DECRYPT_MODE;
> +
> +	return mxc_scc_des3_op(ctx, req);
> +}
> +
> +static int mxc_scc_cbc_des_encrypt(struct ablkcipher_request *req)
> +{
> +	struct crypto_ablkcipher *cipher =3D crypto_ablkcipher_reqtfm(req);
> +	struct mxc_scc_ctx *ctx =3D crypto_ablkcipher_ctx(cipher);
> +
> +	ctx->ctrl =3D SCC_SCM_CTRL_START_CIPHER;
> +	ctx->ctrl |=3D SCC_SCM_CTRL_CBC_MODE;
> +
> +	return mxc_scc_des3_op(ctx, req);
> +}
> +
> +static int mxc_scc_cbc_des_decrypt(struct ablkcipher_request *req)
> +{
> +	struct crypto_ablkcipher *cipher =3D crypto_ablkcipher_reqtfm(req);
> +	struct mxc_scc_ctx *ctx =3D crypto_ablkcipher_ctx(cipher);
> +
> +	ctx->ctrl =3D SCC_SCM_CTRL_START_CIPHER;
> +	ctx->ctrl |=3D SCC_SCM_CTRL_CBC_MODE;
> +	ctx->ctrl |=3D SCC_SCM_CTRL_DECRYPT_MODE;
> +
> +	return mxc_scc_des3_op(ctx, req);
> +}
> +
> +static void mxc_scc_hw_init(struct mxc_scc *scc)
> +{
> +	int offset;
> +
> +	offset =3D SCC_NON_RESERVED_OFFSET / scc->block_size_bytes;
> +
> +	/* Fill the RED_START register */
> +	writel(offset, scc->base + SCC_SCM_RED_START);
> +
> +	/* Fill the BLACK_START register */
> +	writel(offset, scc->base + SCC_SCM_BLACK_START);
> +
> +	scc->red_memory =3D scc->base + SCC_SCM_RED_MEMORY +
> +			  SCC_NON_RESERVED_OFFSET;
> +
> +	scc->black_memory =3D scc->base + SCC_SCM_BLACK_MEMORY +
> +			    SCC_NON_RESERVED_OFFSET;
> +
> +	scc->bytes_remaining =3D scc->memory_size_bytes;
> +}
> +
> +static int mxc_scc_get_config(struct mxc_scc *scc)
> +{
> +	int config;
> +
> +	config =3D readl(scc->base + SCC_SCM_CFG);
> +
> +	scc->block_size_bytes =3D config & SCC_SCM_CFG_BLOCK_SIZE_MASK;
> +
> +	scc->black_ram_size_blocks =3D (config & SCC_SCM_CFG_BLACK_SIZE_MAS=
K);
>
useless parens.

[...]
> +static int mxc_scc_crypto_register(struct mxc_scc *scc)
> +{
> +	unsigned int i, k;
> +	int err =3D 0;
> +
> +	for (i =3D 0; i < ARRAY_SIZE(scc_crypto_algs); i++) {
> +		scc_crypto_algs[i]->scc =3D scc;
> +		err =3D crypto_register_alg(&scc_crypto_algs[i]->alg);
> +		if (err)
> +			goto err_out;
> +	}
> +
> +	return 0;
> +err_out:
>
blank line before label?

> +	for (k =3D 0; k < i; k++)
> +		crypto_unregister_alg(&scc_crypto_algs[k]->alg);
>
You could decrement i back to zero instead of using another loop index.

[...]
> +static int mxc_scc_probe(struct platform_device *pdev)
> +{
> +	struct device *dev =3D &pdev->dev;
> +	struct resource *res;
> +	struct mxc_scc *scc;
> +	enum mxc_scc_state state;
> +	int irq;
> +	int ret;
> +
> +	scc =3D devm_kzalloc(dev, sizeof(*scc), GFP_KERNEL);
> +	if (!scc)
> +		return -ENOMEM;
> +
> +	res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (!res)
> +		return -ENOENT;
>
No need for this check, devm_ioremap_resource() will take care of it.

> +	scc->base =3D devm_ioremap_resource(dev, res);
> +	if (IS_ERR(scc->base))
> +		return PTR_ERR(scc->base);
> +
> +	scc->clk =3D devm_clk_get(&pdev->dev, "ipg");
> +	if (IS_ERR(scc->clk)) {
> +		dev_err(dev, "Could not get ipg clock\n");
> +		return PTR_ERR(scc->clk);
> +	}
> +
> +	clk_prepare_enable(scc->clk);
> +
> +	/* clear error status register */
> +	writel(0x0, scc->base + SCC_SCM_ERROR_STATUS);
> +
> +	/* clear interrupt control registers */
> +	writel(SCC_SCM_INTR_CTRL_CLR_INTR |
> +	       SCC_SCM_INTR_CTRL_MASK_INTR,
> +	       scc->base + SCC_SCM_INTR_CTRL);
> +
> +	writel(SCC_SMN_COMMAND_CLR_INTR |
> +	       SCC_SMN_COMMAND_EN_INTR,
> +	       scc->base + SCC_SMN_COMMAND);
> +
> +	scc->dev =3D dev;
> +	platform_set_drvdata(pdev, scc);
> +
> +	ret =3D mxc_scc_get_config(scc);
> +	if (ret)
> +		goto err_out;
> +
> +	state =3D mxc_scc_get_state(scc);
> +
> +	if (state !=3D SCC_STATE_OK) {
> +		dev_err(dev, "SCC in unusable state %d\n", state);
> +		ret =3D -EINVAL;
> +		goto err_out;
> +	}
> +
> +	mxc_scc_hw_init(scc);
> +
> +	irq =3D platform_get_irq(pdev, 0);
> +	if (irq < 0) {
> +		dev_err(dev, "failed to get irq resource\n");
> +		goto err_out;
> +	}
> +
> +	ret =3D devm_request_threaded_irq(dev, irq, NULL, mxc_scc_int,
> +					IRQF_ONESHOT, dev_name(dev), scc);
> +	if (ret)
> +		goto err_out;
> +
This should be removed, as it is done below again after initializing
all data structures that might be used by the interrupt handler.

> +	irq =3D platform_get_irq(pdev, 1);
> +	if (irq < 0) {
> +		dev_err(dev, "failed to get irq resource\n");
> +		goto err_out;
> +	}
> +
> +	mutex_init(&scc->mutex);
> +	spin_lock_init(&scc->lock);
> +	/* FIXME: calculate queue from RAM slots */
> +	crypto_init_queue(&scc->queue, 50);
> +
> +	ret =3D devm_request_threaded_irq(dev, irq, NULL, mxc_scc_int,
> +					IRQF_ONESHOT, dev_name(dev), scc);
> +	if (ret)
> +		goto err_out;
> +
> +	ret =3D mxc_scc_crypto_register(scc);
> +	if (ret) {
> +		dev_err(dev, "could not register algorithms");
> +		goto err_out;
> +	}
> +
> +	dev_info(dev, "registered successfully.\n");
> +
> +	return 0;
> +
> +err_out:
> +	clk_disable_unprepare(scc->clk);
> +
> +	return ret;
> +}
> +
> +static int mxc_scc_remove(struct platform_device *pdev)
> +{
> +	struct mxc_scc *scc =3D platform_get_drvdata(pdev);
> +
> +	mxc_scc_crypto_unregister();
> +
> +	clk_disable_unprepare(scc->clk);
> +
> +	return 0;
> +}


Lothar Wa=C3=9Fmann
--
To unsubscribe from this list: send the line "unsubscribe devicetree" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
