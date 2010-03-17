From: Felipe Balbi <me@felipebalbi.com>
Subject: Re: [PATCH 1/2] sec: omap sha1 & md5 driver
Date: Wed, 17 Mar 2010 19:08:06 +0200
Message-ID: <20100317170805.GB3857@gandalf>
References: <cover.1268830685.git.dmitry.kasatkin@nokia.com>
 <2f55c827126b6cfc3b09b5b6df7532fc5ea4403e.1268830685.git.dmitry.kasatkin@nokia.com>
Reply-To: me@felipebalbi.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	linux-omap@vger.kernel.org
To: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Return-path: <linux-omap-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <2f55c827126b6cfc3b09b5b6df7532fc5ea4403e.1268830685.git.dmitry.kasatkin@nokia.com>
Sender: linux-omap-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Mar 17, 2010 at 03:12:50PM +0200, Dmitry Kasatkin wrote:
> Earlier kernel contained omap sha1 and md5 driver, which was not maintained,
> was not ported to new crypto APIs and removed from the source tree.
> 
> This driver implements async and sync crypto API.
> 
> Signed-off-by: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
> ---
>  drivers/crypto/omap-sha1-md5.c | 1449 ++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 1449 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/crypto/omap-sha1-md5.c
> 
> diff --git a/drivers/crypto/omap-sha1-md5.c b/drivers/crypto/omap-sha1-md5.c
> new file mode 100644
> index 0000000..c57c6de
> --- /dev/null
> +++ b/drivers/crypto/omap-sha1-md5.c
> @@ -0,0 +1,1449 @@
> +/*
> + * Cryptographic API.
> + *
> + * Support for OMAP SHA1/MD5 HW acceleration.
> + *
> + * Copyright (c) 2007 Instituto Nokia de Tecnologia - INdT
> + * Authors: David Cohen <david.cohen@indt.org.br>
> + *          Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as published
> + * by the Free Software Foundation.
> + *
> + * This driver is based on padlock-sha.c driver.
> + */
> +
> +#define pr_fmt(fmt) "%s: " fmt, __func__

how about pr_info() and friends ?

> +#include <linux/version.h>
> +#include <linux/err.h>
> +#include <linux/device.h>
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/errno.h>
> +#include <linux/cryptohash.h>
> +#include <linux/interrupt.h>
> +#include <linux/kernel.h>
> +#include <linux/clk.h>
> +#include <linux/irq.h>
> +#include <linux/platform_device.h>
> +#include <linux/scatterlist.h>
> +#include <linux/dma-mapping.h>
> +#include <linux/delay.h>
> +#include <linux/crypto.h>
> +#include <crypto/scatterwalk.h>
> +#include <crypto/algapi.h>
> +#include <crypto/sha.h>
> +#include <crypto/hash.h>
> +#include <crypto/internal/hash.h>
> +
> +#include <plat/cpu.h>
> +#include <plat/dma.h>
> +#include <mach/irqs.h>
> +#include <mach/io.h>
> +
> +/* OMAP3 SHAM2 module */
> +#define OMAP34XX_SEC_SHA1MD5_BASE	(L4_34XX_BASE + 0xC3000)

these should come from platform code as a struct resource

> +#define DRIVER_NAME			"omap-sha1-md5"

this should be avoided.

> +#ifdef CONFIG_ARCH_OMAP24XX
> +#define SHA1_MD5_ICLK	"sha_ick"
> +#endif
> +#ifdef CONFIG_ARCH_OMAP34XX
> +#define SHA1_MD5_ICLK	"sha12_ick"
> +#endif

use CLKDEV

> +#define FLAGS_UPDATE		0x0001
> +#define FLAGS_FINUP		0x0002
> +#define FLAGS_FINAL		0x0004
> +#define FLAGS_MAY_SLEEP		0x0008
> +#define FLAGS_BYPASS_INIT	0x0010
> +#define FLAGS_BYPASS		0x0030 /* it's a mask */
> +#define FLAGS_FAST		0x0040
> +#define FLAGS_SHA1		0x0080
> +#define FLAGS_INPROGRESS	0x0100
> +#define FLAGS_DMA_ACTIVE	0x0200
> +#define FLAGS_READY		0x0400
> +#define FLAGS_CLEAN		0x0800
> +#define FLAGS_DMA		0x1000

how about using BIT() macro ?

> +struct omap_sha1_md5_ctx {
> +	unsigned long	flags;
> +	int		digsize;
> +	size_t		bufcnt;
> +	size_t		digcnt;
> +	size_t		dma_size;
> +	u8		*buffer;
> +	size_t		buffer_size;
> +
> +	/* shash stuff */
> +	struct crypto_shash	*shash_fb;
> +	u8			*data;
> +
> +	/* ahash stuff */
> +	struct crypto_ahash	*ahash_fb;
> +	struct ahash_request	*req;
> +
> +	/* ahash walk state */
> +	struct scatterlist *sg;
> +	unsigned int	offset;	/* offset in current sg */
> +	unsigned int	length;	/* length left in current sg */
> +	unsigned int	total;	/* total request */
> +};
> +
> +struct omap_sha1_md5_dev {
> +	unsigned long			phys_base;
> +	struct device			*dev;
> +	void __iomem 			*io_base;
> +	int				irq;
> +	struct clk			*iclk;
> +	struct omap_sha1_md5_ctx	*hw_ctx;
> +	wait_queue_head_t		wq;
> +	spinlock_t			lock;
> +	int				dma;
> +	dma_addr_t			dma_addr;
> +	dma_addr_t			buffer_addr;
> +	int				dma_lch;
> +	struct completion		dma_wait;
> +	struct tasklet_struct		done_task;
> +};
> +
> +/* device data */
> +static struct omap_sha1_md5_dev *dd;

shouldn't be necessary. You have a platform_device and you already use
platform_set_drvdata(), you already pass it as the dev_id for irq and as
a parameter to tasklet_init()

> +static int omap_sha1_md5_update_dma_slow(struct omap_sha1_md5_ctx *ctx);
> +static int omap_sha1_md5_update_dma_stop(struct omap_sha1_md5_ctx *ctx);
> +static void omap_sha1_md5_hw_cleanup(struct omap_sha1_md5_ctx *ctx, u8 *out);

reorganize the code so you don't need these.

> +static inline u32 omap_sha1_md5_read(struct omap_sha1_md5_dev *dd, u32 offset)
> +{
> +	return __raw_readl(dd->io_base + offset);
> +}
> +
> +static inline void omap_sha1_md5_write(struct omap_sha1_md5_dev *dd,
> +					u32 offset, u32 value)
> +{
> +	__raw_writel(value, dd->io_base + offset);
> +}
> +
> +static void omap_sha1_md5_write_mask(struct omap_sha1_md5_dev *dd, u32 address,
> +					u32 value, u32 mask)
> +{
> +	u32 val;
> +
> +	val = omap_sha1_md5_read(dd, address);
> +	val &= ~mask;
> +	val |= value;
> +	omap_sha1_md5_write(dd, address, val);
> +}
> +
> +static int omap_sha1_md5_wait(struct omap_sha1_md5_dev *dd, u32 offset, u32 bit)
> +{
> +	unsigned long timeout = jiffies + DEFAULT_TIMEOUT_INTERVAL;
> +
> +	while (!(omap_sha1_md5_read(dd, offset) & bit)) {
> +		if (time_is_before_jiffies(timeout))
> +			return -ETIMEDOUT;
> +	}
> +
> +	return 0;
> +}

I'm wondering if you really want a function call just for a busy wait...
how about inlining this function ?

> +static int omap_sha1_md5_wait_for_output_ready(struct omap_sha1_md5_ctx *ctx)
> +{
> +	int err;
> +
> +	pr_debug("enter\n");

save a dev pointer from the platform_device inside omap_sha1_md5_ctx and
use dev_dbg();

> +	if (ctx->flags & FLAGS_READY)
> +		return 0;
> +
> +	if (ctx->flags & FLAGS_DMA) {
> +		unsigned long timeout;
> +		if (!(ctx->flags & FLAGS_MAY_SLEEP))
> +			return -EINPROGRESS;
> +		timeout = wait_event_interruptible_timeout(dd->wq,
> +				(ctx->flags & FLAGS_READY),
> +				DEFAULT_TIMEOUT_INTERVAL);

		if (err < 0)
			return err;

> +		err = timeout > 0 ? 0 : -ETIMEDOUT;
> +	} else {
> +		err = omap_sha1_md5_wait(dd, SHA_REG_CTRL,
> +					  SHA_REG_CTRL_OUTPUT_READY);

		if (err < 0)
			return err;
> +	}
> +	pr_debug("exit: %d\n", (omap_sha1_md5_read(dd, SHA_REG_CTRL)
> +			& SHA_REG_CTRL_OUTPUT_READY) != 0);

	dev_dbg();

> +
> +	return err;

	return 0;

> +}
> +
> +static irqreturn_t omap_sha1_md5_irq(int irq, void *dev_id)
> +{
> +	struct omap_sha1_md5_ctx *ctx = dd->hw_ctx;

	struct omap_sha1_md5_ctx *ctx = dev_id;

> +	pr_debug("enter\n");

get rid of this line

> +	pr_debug("ready: %d\n", (omap_sha1_md5_read(dd, SHA_REG_CTRL) &
> +			SHA_REG_CTRL_OUTPUT_READY) != 0);

	dev_dbg();

> +
> +	if (!ctx) {
> +		dev_err(dd->dev, "unknown interrupt.\n");
> +		return IRQ_HANDLED;
> +	}
> +
> +	if (unlikely(ctx->flags & FLAGS_FINAL))
> +		/* final -> allow device to go to power-saving mode */
> +		omap_sha1_md5_write_mask(dd, SHA_REG_CTRL, 0,
> +					 SHA_REG_CTRL_LENGTH);
> +
> +	omap_sha1_md5_write_mask(dd, SHA_REG_CTRL, SHA_REG_CTRL_OUTPUT_READY,
> +				 SHA_REG_CTRL_OUTPUT_READY);
> +
> +	if (likely(!(ctx->flags & FLAGS_FINAL)))
> +		return IRQ_HANDLED;
> +
> +	ctx->flags |= FLAGS_READY;
> +
> +	pr_debug("DIGEST READY\n");

get rid of this.

> +	/* hash is done */
> +	if (ctx->flags & FLAGS_MAY_SLEEP)
> +		wake_up_interruptible(&dd->wq);
> +	else
> +		tasklet_schedule(&dd->done_task);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static int omap_sha1_md5_wait_for_dma(struct omap_sha1_md5_ctx *ctx)
> +{
> +	int err = 0;
> +
> +	pr_debug("enter\n");

get rid of this

> +	if ((ctx->flags & FLAGS_INPROGRESS) && !(ctx->flags & FLAGS_FINUP)) {
> +		unsigned long timeout;
> +		if (!(ctx->flags & FLAGS_MAY_SLEEP))
> +			return -EINPROGRESS;
> +		pr_debug("do wait\n");
> +		timeout = wait_for_completion_timeout(&dd->dma_wait,
> +			DEFAULT_TIMEOUT_INTERVAL);
> +		err = timeout > 0 ? 0 : -ETIMEDOUT;
> +	}
> +	pr_debug("exit\n");

and this

> +
> +	return err;
> +}
> +
> +static void omap_sha1_md5_done(unsigned long data)
> +{
> +	struct omap_sha1_md5_ctx *ctx = dd->hw_ctx;

	struct omap_sha1_md5_ctx *ctx = (struct omap_sha1_md5_ctx *) data;

> +	pr_debug("enter\n");

and this.

> +
> +	if (ctx->flags & FLAGS_FINAL)
> +		omap_sha1_md5_hw_cleanup(ctx, ctx->req->result);
> +
> +	if (ctx->req && ctx->req->base.complete)
> +		ctx->req->base.complete(&ctx->req->base, 0);
> +
> +	pr_debug("exit\n");

this too.

> +}
> +
> +static void omap_sha1_md5_dma_callback(int lch, u16 ch_status, void *data)
> +{
> +	struct omap_sha1_md5_ctx *ctx = dd->hw_ctx;

	struct omap_sha1_md5_ctx *ctx = data;

> +	pr_debug("enter\n");

this too.

> +
> +	ctx->flags &= ~FLAGS_DMA_ACTIVE;
> +
> +	omap_sha1_md5_update_dma_stop(ctx);
> +	omap_sha1_md5_update_dma_slow(ctx);
> +
> +	if (!(ctx->flags & FLAGS_DMA_ACTIVE)) {
> +		ctx->flags &= ~FLAGS_INPROGRESS;
> +		if (!(ctx->flags & FLAGS_FINAL)) {
> +			/* irq handler will complete the the hash */
> +			if (ctx->flags & FLAGS_MAY_SLEEP)
> +				complete(&dd->dma_wait);
> +			else
> +				tasklet_schedule(&dd->done_task);
> +		}
> +	}
> +
> +	pr_debug("exit\n");

kill this.

> +}
> +
> +static int omap_sha1_md5_hw_init(struct omap_sha1_md5_ctx *ctx, int use_dma)
> +{
> +	int err;
> +
> +	pr_debug("enter\n");

and this.

> +static int omap_sha1_md5_xmit_cpu(struct omap_sha1_md5_ctx *ctx,
> +				const u8 *buf, size_t length, int final)
> +{
> +	int err, count, len32;
> +	const u32 *buffer = (const u32 *)buf;

why this ? couldn't you change the function prototype to pass const u32 *
already ?

> +	pr_debug("digcnt: %d, length: %d, final: %d\n",
> +				 ctx->digcnt, length, final);

dev_dbg();

> +static size_t omap_sha1_md5_append_buffer(struct omap_sha1_md5_ctx *ctx,
> +				const u8 *data, size_t length)
> +{
> +	size_t count = min(length, ctx->buffer_size - ctx->bufcnt);
> +
> +	count = min(count, ctx->total);
> +	if (count <= 0)
> +		return 0;

can min() return a negative ?

> +	memcpy(ctx->buffer + ctx->bufcnt, data, count);
> +	ctx->bufcnt += count;

add a blank line before return.

> +static int omap_sha1_md5_update_cpu(struct omap_sha1_md5_ctx *ctx,
> +				const u8 *data, size_t length)
> +{
> +	unsigned int count;
> +	int err;
> +
> +	pr_debug("enter\n");

get rid of this.

> +
> +	if (ctx->bufcnt) {
> +		count = min(length, SHA1_MD5_BLOCK_SIZE - ctx->bufcnt);
> +		omap_sha1_md5_append_cpu(ctx, data, count);
> +		data += count;
> +		length -= count;
> +		if (!length)
> +			return 0;
> +		ctx->bufcnt = 0;
> +		err = omap_sha1_md5_xmit_cpu(ctx, ctx->buffer,
> +					    SHA1_MD5_BLOCK_SIZE, 0);
> +		if (err)
> +			return err;
> +	}
> +	/* We need to save the last buffer <= 64 to digest it with
> +	 * CLOSE_HASH = 1 */

multiline comment style is:

/*
 * We need to save the last buffer <= 64 to digest it with
 * CLOSE_HASH = 1
 */

> +static int omap_sha1_md5_update_dma_slow(struct omap_sha1_md5_ctx *ctx)
> +{
> +	unsigned int final;
> +	size_t count;
> +
> +	pr_debug("enter, total: %d\n", ctx->total);

either get rid of this or change to something really meaningful with
dev_dbg()

> +
> +	if (!ctx->total) {
> +		pr_debug("no data\n");
> +		return 0;
> +	}
> +
> +	omap_sha1_md5_append_sg(ctx);
> +
> +	final = (ctx->flags & FLAGS_FINUP) && !ctx->total;
> +
> +	pr_debug("bufcnt: %u, digcnt: %d, final: %d\n",
> +		 ctx->bufcnt, ctx->digcnt, final);

same here.

> +	if (final || (ctx->bufcnt == ctx->buffer_size && ctx->total)) {
> +		count = ctx->bufcnt;
> +		ctx->bufcnt = 0;
> +		return omap_sha1_md5_xmit_dma(ctx, dd->buffer_addr, count,
> +					      final);
> +	}
> +
> +	return 0;
> +}
> +
> +static int omap_sha1_md5_update_dma_stop(struct omap_sha1_md5_ctx *ctx)
> +{
> +	pr_debug("enter\n");

remove.

> +static int omap_sha1_md5_init(struct omap_sha1_md5_ctx *ctx)
> +{
> +	unsigned long flags;
> +
> +	pr_debug("enter, digest size: %d\n", ctx->digsize);

either remove or change to something useful with dev_dbg()

> +static int omap_sha1_md5_final(struct omap_sha1_md5_ctx *ctx)
> +{
> +	int err = 0, use_dma = !!ctx->req;
> +
> +	pr_debug("enter\n");

remove.

> +	if (ctx->bufcnt) {
> +		/* DMA is overhead if only data is <=64b */
> +		if (ctx->bufcnt <= 64)
> +			/* still use dma if it has been used already */
> +			use_dma = dd->dma_lch >= 0;
> +		if (use_dma)
> +			err = omap_sha1_md5_xmit_dma(ctx, dd->buffer_addr,
> +							ctx->bufcnt, 1);
> +		else
> +			err = omap_sha1_md5_xmit_cpu(ctx, ctx->buffer,
> +							ctx->bufcnt, 1);
> +	}
> +
> +	if (err)
> +		return err;
> +
> +	err = omap_sha1_md5_wait_for_output_ready(ctx);
> +
> +	pr_debug("exit\n");

and this.

> +
> +	return err;
> +}
> +
> +static void omap_sha1_md5_hw_cleanup(struct omap_sha1_md5_ctx *ctx, u8 *out)
> +{
> +	unsigned long flags;
> +
> +	pr_debug("enter\n");

and this.

> +	if (ctx->flags & FLAGS_BYPASS)
> +		goto exit;
> +
> +	spin_lock_irqsave(&dd->lock, flags);
> +	if (ctx->flags & FLAGS_CLEAN) {
> +		spin_unlock_irqrestore(&dd->lock, flags);
> +		pr_debug("exit: already clean\n");
> +		return;
> +	}
> +	ctx->flags |= FLAGS_CLEAN;
> +	spin_unlock_irqrestore(&dd->lock, flags);
> +
> +	if (dd->dma_lch >= 0) {
> +		/* We can free the channels */
> +		omap_free_dma(dd->dma_lch);
> +		dd->dma_lch = -1;
> +	}
> +
> +	omap_sha1_md5_copy_hash(ctx, (u32 *)out);
> +	clk_disable(dd->iclk);
> +
> +	if (dd->buffer_addr)
> +		dma_unmap_single(dd->dev, dd->buffer_addr, ctx->buffer_size,
> +				 DMA_TO_DEVICE);
> +	if (ctx->buffer) {
> +		free_page((unsigned long)ctx->buffer);
> +		ctx->buffer = NULL;
> +	}
> +
> +exit:
> +	if (dd->hw_ctx == ctx)
> +		dd->hw_ctx = NULL;
> +	pr_debug("exit\n");

and this.

> +/* ******************** SHASH ********************************************* */
> +
> +static int omap_shash_update_bypass(struct shash_desc *desc,
> +					const u8 *data,
> +					size_t length)
> +{
> +	struct omap_sha1_md5_ctx *ctx = crypto_shash_ctx(desc->tfm);
> +	struct omap_sha1_md5_desc *_ctx = shash_desc_ctx(desc);

this is prone to cause problems when someone tries to play around with
this driver. Could you change the names to something more meaningful ?

at least omap_sha1_md5_desc could be called *desc, maybe...

> +	pr_debug("length: %d\n", length);

dev_dbg();

> +	if (ctx->flags & FLAGS_BYPASS_INIT) {
> +		int err = crypto_shash_init(&_ctx->fallback);
> +		pr_debug("switching to bypass, err: %d\n", err);
> +		ctx->flags &= ~FLAGS_BYPASS_INIT;
> +		if (err)
> +			return err;
> +	}
> +
> +	if (length)
> +		return crypto_shash_update(&_ctx->fallback, data, length);
> +
> +	return 0;
> +}
> +
> +static int omap_shash_init(struct shash_desc *desc)
> +{
> +	struct omap_sha1_md5_ctx *ctx = crypto_shash_ctx(desc->tfm);
> +	struct omap_sha1_md5_desc *_ctx = shash_desc_ctx(desc);
> +	int err;
> +
> +	pr_debug("enter\n");

remove.

> +
> +	_ctx->fallback.tfm = ctx->shash_fb;
> +	_ctx->fallback.flags = desc->flags & CRYPTO_TFM_REQ_MAY_SLEEP;
> +
> +	ctx->digsize = crypto_shash_digestsize(desc->tfm);
> +
> +	if (desc->flags & CRYPTO_TFM_REQ_MAY_SLEEP)
> +		ctx->flags |= FLAGS_MAY_SLEEP;
> +
> +	err = omap_sha1_md5_init(ctx);
> +
> +	pr_debug("exit\n");

remove.

> +	return err;
> +}
> +
> +static int omap_shash_update(struct shash_desc *desc, const u8 *data,
> +		      size_t length)
> +{
> +	struct omap_sha1_md5_ctx *ctx = crypto_shash_ctx(desc->tfm);
> +
> +	pr_debug("length: %d, bypass: %d\n", length,
> +		 (ctx->flags & FLAGS_BYPASS) != 0);

dev_dbg();

> +	if (!length)
> +		return 0;
> +
> +	if (ctx->flags & FLAGS_BYPASS)
> +		return omap_shash_update_bypass(desc, data, length);
> +
> +	if ((ctx->flags & FLAGS_FINUP) &&
> +		    ((ctx->digcnt + ctx->bufcnt + length) < 9)) {
> +		/* OMAP HW accel works only with buffers >= 9 */
> +		/* will switch to bypass in final() */
> +		omap_sha1_md5_append_cpu(ctx, data, length);
> +		return 0;
> +	}
> +
> +	return omap_sha1_md5_update_cpu(ctx, data, length);
> +}
> +
> +static int omap_shash_final(struct shash_desc *desc, u8 *out)
> +{
> +	struct omap_sha1_md5_ctx *ctx = crypto_shash_ctx(desc->tfm);
> +	struct omap_sha1_md5_desc *_ctx = shash_desc_ctx(desc);
> +	int err = 0;
> +
> +	pr_debug("enter\n");

remove.

> +	ctx->flags |= FLAGS_FINUP;
> +
> +	/* OMAP HW accel works only with buffers >= 9 */
> +	if ((ctx->flags & FLAGS_BYPASS_INIT) ||
> +	    ((ctx->digcnt + ctx->bufcnt) < 9 && !(ctx->flags & FLAGS_BYPASS))) {
> +		ctx->flags |= FLAGS_BYPASS;
> +		err = omap_shash_update_bypass(desc, ctx->buffer, ctx->bufcnt);
> +		if (err)
> +			goto exit;
> +	}
> +
> +	if (unlikely(ctx->flags & FLAGS_BYPASS))
> +		err = crypto_shash_final(&_ctx->fallback, out);
> +	else
> +		err = omap_sha1_md5_final(ctx);
> +
> +exit:
> +	omap_sha1_md5_hw_cleanup(ctx, out);
> +
> +	return err;
> +}
> +
> +static int omap_shash_finup(struct shash_desc *desc, const u8 *data,
> +		     size_t length, u8 *out)
> +{
> +	struct omap_sha1_md5_ctx *ctx = crypto_shash_ctx(desc->tfm);
> +	int err1, err2;
> +
> +	pr_debug("length: %d\n", length);

dev_dbg() or remove.

> +	ctx->flags |= FLAGS_FINUP;
> +
> +	err1 = omap_shash_update(desc, data, length);
> +
> +	/*
> +	 * final() has to be always called to cleanup resources
> +	 * even if udpate() failed
> +	 */
> +	err2 = omap_shash_final(desc, out);
> +
> +	return err1 ?: err2;
> +}
> +
> +static int omap_shash_cra_init(struct crypto_tfm *tfm)
> +{
> +	struct crypto_shash *hash = __crypto_shash_cast(tfm);
> +	struct omap_sha1_md5_ctx *ctx = crypto_tfm_ctx(tfm);
> +	const char *alg_name = tfm->__crt_alg->cra_name;
> +
> +	pr_debug("enter\n");

remove.

> +	ctx->req = NULL;
> +
> +	/* Allocate a fallback and abort if it failed. */
> +	ctx->shash_fb = crypto_alloc_shash(alg_name, 0,
> +					 CRYPTO_ALG_ASYNC |
> +					 CRYPTO_ALG_NEED_FALLBACK);
> +	if (IS_ERR(ctx->shash_fb)) {
> +		dev_err(dd->dev, "fallback driver '%s' could not be loaded.\n",
> +			alg_name);
> +		return PTR_ERR(ctx->shash_fb);
> +	}
> +
> +	hash->descsize += crypto_shash_descsize(ctx->shash_fb);
> +
> +	return 0;
> +}
> +
> +static void omap_shash_cra_exit(struct crypto_tfm *tfm)
> +{
> +	struct omap_sha1_md5_ctx *ctx = crypto_tfm_ctx(tfm);
> +
> +	pr_debug("enter\n");

remove.

> +	crypto_free_shash(ctx->shash_fb);
> +	ctx->shash_fb = NULL;
> +	pr_debug("exit\n");

remove.

> +}
> +
> +/* ******************** AHASH ********************************************* */
> +
> +static int omap_ahash_init_bypass(struct omap_sha1_md5_ctx *ctx,
> +				    struct ahash_request *req)
> +{
> +	int err = 0;
> +	u32 flags;
> +
> +	pr_debug("length: %d\n", req->nbytes);
> +
> +	flags = req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP;
> +	ctx->req = ahash_request_alloc(ctx->ahash_fb,
> +					flags ? GFP_KERNEL : GFP_ATOMIC);
> +	if (!ctx->req) {
> +		pr_err("Failed to allocate request\n");
> +		return -ENOMEM;
> +	}
> +
> +	ahash_request_set_callback(ctx->req, flags,
> +					req->base.complete, req->base.data);
> +
> +	ahash_request_set_crypt(ctx->req, req->src, req->result,
> +				req->nbytes); /* needed before init? */
> +	err = crypto_ahash_init(ctx->req);
> +
> +	ctx->flags &= ~FLAGS_BYPASS_INIT;
> +
> +	pr_debug("switching to bypass, err: %d\n", err);

dev_dbg(). Also do you call err even a possible success ??

> +	return err;
> +}
> +
> +static int omap_ahash_update_bypass(struct omap_sha1_md5_ctx *ctx,
> +				    struct ahash_request *req)
> +{
> +	int err;
> +
> +	pr_debug("length: %d\n", req->nbytes);

dev_dbg() or remove.

> +	if (ctx->flags & FLAGS_BYPASS_INIT) {
> +		err = omap_ahash_init_bypass(ctx, req);
> +		if (err)
> +			return err;
> +	}
> +
> +	if (!req->nbytes)
> +		return 0;
> +
> +	ahash_request_set_crypt(ctx->req, req->src, req->result,
> +				req->nbytes);
> +	err = crypto_ahash_update(ctx->req);
> +
> +	pr_debug("exit: %d\n", err);

remove.

> +	return err;
> +}
> +
> +static int omap_ahash_init(struct ahash_request *req)
> +{
> +	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
> +	struct omap_sha1_md5_ctx *ctx = crypto_ahash_ctx(tfm);
> +	int err;
> +
> +	pr_debug("enter, reqsize: %d\n", tfm->reqsize);

dev_dbg() or remove.

> +	ctx->digsize = crypto_ahash_digestsize(tfm);
> +	ctx->req = req;
> +
> +	if (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP)
> +		ctx->flags |= FLAGS_MAY_SLEEP;
> +
> +	err = omap_sha1_md5_init(ctx);
> +
> +	pr_debug("exit\n");

remove.

> +	return err;
> +
> +}
> +
> +static int omap_ahash_update_dma_fast(struct omap_sha1_md5_ctx *ctx)
> +{
> +	unsigned int length;
> +
> +	pr_debug("enter\n");

remove.

> +	ctx->flags |= FLAGS_FAST;
> +
> +	length = min(ctx->total, sg_dma_len(ctx->sg));
> +	ctx->total = length;
> +
> +	if (!dma_map_sg(dd->dev, ctx->sg, 1, DMA_TO_DEVICE)) {
> +		dev_err(dd->dev, "dma_map_sg  error\n");
> +		return -EINVAL;
> +	}
> +
> +	ctx->total -= length;
> +
> +	return omap_sha1_md5_xmit_dma(ctx, sg_dma_address(ctx->sg), length, 1);
> +}
> +
> +static int omap_ahash_update_dma(struct omap_sha1_md5_ctx *ctx,
> +				 struct ahash_request *req)
> +{
> +	pr_debug("enter\n");

remove.

> +	ctx->req = req;
> +	ctx->total = req->nbytes;
> +	ctx->sg = req->src;
> +	ctx->offset = 0;
> +	ctx->length = ctx->sg->length;
> +
> +	pr_debug("nbytes: %u, digcnt: %d, final: %d\n",
> +		 ctx->total, ctx->digcnt, (ctx->flags & FLAGS_FINUP) != 0);
> +
> +	if (sg_is_last(ctx->sg)) {
> +		/* may be can use faster functions */
> +		int aligned = IS_ALIGNED((u32)ctx->sg->offset, sizeof(u32));
> +		int digest = (ctx->flags & FLAGS_FINUP) &&
> +				!(ctx->flags & FLAGS_UPDATE);
> +		if (digest && aligned)
> +			/* digest: first and final */
> +			return omap_ahash_update_dma_fast(ctx);
> +	}
> +
> +	return omap_sha1_md5_update_dma_slow(ctx);
> +}
> +
> +static int omap_ahash_update(struct ahash_request *req)
> +{
> +	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
> +	struct omap_sha1_md5_ctx *ctx = crypto_ahash_ctx(tfm);
> +	int err;
> +
> +	pr_debug("enter\n");

remove.

> +	if (!req->nbytes)
> +		return 0;
> +
> +	if (ctx->flags & FLAGS_BYPASS)
> +		return omap_ahash_update_bypass(ctx, req);
> +
> +	if ((ctx->flags & FLAGS_FINUP) &&
> +		    ((ctx->digcnt + ctx->bufcnt + req->nbytes) < 9)) {
> +		/* OMAP HW accel works only with buffers >= 9 */
> +		/* will switch to bypass in final() */
> +		/* final has the same request and data */
> +		return 0;
> +	}
> +
> +	init_completion(&dd->dma_wait);
> +
> +	err = omap_ahash_update_dma(ctx, req);

	if (err) {
		dev_dbg(...);
		return err;
	}

> +
> +	ctx->flags |= FLAGS_UPDATE;
> +
> +	/* wait for dma completion before can take more data */
> +	if (!err)
> +		err = omap_sha1_md5_wait_for_dma(ctx);

remove the unnecessary branch on success.

> +	pr_debug("exit: %d\n", err);

remove.

> +
> +	return err;
> +}
> +
> +static int omap_ahash_final(struct ahash_request *req)
> +{
> +	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
> +	struct omap_sha1_md5_ctx *ctx = crypto_ahash_ctx(tfm);
> +	int err = 0;
> +
> +	pr_debug("enter\n");

remove.

> +
> +	ctx->flags |= FLAGS_FINUP;
> +
> +	/* OMAP HW accel works only with buffers >= 9 */
> +	if ((ctx->flags & FLAGS_BYPASS_INIT) ||
> +	    ((ctx->digcnt + ctx->bufcnt + req->nbytes) < 9 &&
> +		    !(ctx->flags & FLAGS_BYPASS))) {
> +		ctx->flags |= FLAGS_BYPASS;
> +		err = omap_ahash_update_bypass(ctx, req);
> +		if (err)
> +			goto exit;
> +	}
> +
> +	if (unlikely(ctx->flags & FLAGS_BYPASS)) {
> +		err = crypto_ahash_final(ctx->req);
> +		ahash_request_free(ctx->req);
> +	} else {
> +		ctx->req = req;
> +		err = omap_sha1_md5_final(ctx);
> +	}
> +
> +exit:
> +	if (err != -EINPROGRESS)
> +		omap_sha1_md5_hw_cleanup(ctx, req->result);
> +
> +	pr_debug("exit\n");

remove.

> +
> +	return err;
> +}
> +
> +static int omap_ahash_finup(struct ahash_request *req)
> +{
> +	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
> +	struct omap_sha1_md5_ctx *ctx = crypto_ahash_ctx(tfm);
> +	int err1, err2;
> +
> +	pr_debug("enter\n");

remove.

> +	ctx->flags |= FLAGS_FINUP;
> +
> +	err1 = omap_ahash_update(req);
> +	if (err1 == -EINPROGRESS)
> +		return err1;
> +
> +	/*
> +	 * final() has to be always called to cleanup resources
> +	 * even if udpate() failed
> +	 */
> +	err2 = omap_ahash_final(req);
> +
> +	return err1 ?: err2;
> +}
> +
> +static int omap_ahash_digest(struct ahash_request *req)
> +{
> +	pr_debug("enter\n");

remove.

> +	return omap_ahash_init(req) ?: omap_ahash_finup(req);
> +}
> +
> +static int omap_ahash_cra_init(struct crypto_tfm *tfm)
> +{
> +	struct crypto_ahash *ahash = __crypto_ahash_cast(tfm);
> +	struct omap_sha1_md5_ctx *ctx = crypto_tfm_ctx(tfm);
> +	const char *alg_name = tfm->__crt_alg->cra_name;
> +
> +	pr_debug("enter\n");

remove.

> +	ctx->req = NULL;
> +
> +	/* Allocate a fallback and abort if it failed. */
> +	ctx->ahash_fb = crypto_alloc_ahash(alg_name, 0,
> +					 CRYPTO_ALG_ASYNC |
> +					 CRYPTO_ALG_NEED_FALLBACK);
> +	if (IS_ERR(ctx->ahash_fb)) {
> +		dev_err(dd->dev, "fallback driver '%s' could not be loaded.\n",
> +			alg_name);
> +		return PTR_ERR(ctx->ahash_fb);
> +	}
> +
> +	pr_debug("ctx size: %d\n", sizeof(*ctx));
> +	pr_debug("ahash->reqsize: %d\n", crypto_ahash_reqsize(ahash));
> +	pr_debug("fb->reqsize: %d\n", crypto_ahash_reqsize(ctx->ahash_fb));

please clean up these.
you shouldn't need so many prints at once and use dev_dbg()

> +	return 0;
> +}
> +
> +static void omap_ahash_cra_exit(struct crypto_tfm *tfm)
> +{
> +	struct omap_sha1_md5_ctx *ctx = crypto_tfm_ctx(tfm);
> +
> +	pr_debug("enter\n");

remove.

> +	crypto_free_ahash(ctx->ahash_fb);
> +	ctx->ahash_fb = NULL;
> +	pr_debug("exit\n");

remove.

> +static int omap_sha1_md5_probe(struct platform_device *pdev)

missing section definition

> +{

	static struct omap_sha1_md5_dev *dd;

> +	struct device *dev = &pdev->dev;
> +	struct resource *res;
> +	int rc;
> +
> +	dd = kzalloc(sizeof(struct omap_sha1_md5_dev), GFP_KERNEL);
> +	if (dd == NULL) {
> +		dev_err(dev, "unable to alloc data struct.\n");
> +		rc = -ENOMEM;
> +		goto data_err;
> +	}
> +	dd->dev = dev;
> +	platform_set_drvdata(pdev, dd);
> +
> +	spin_lock_init(&dd->lock);
> +	init_waitqueue_head(&dd->wq);
> +	tasklet_init(&dd->done_task, omap_sha1_md5_done, (unsigned long)dd);
> +
> +	/* Get the base address */
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (!res) {
> +		dev_err(dev, "no MEM resource info\n");
> +		rc = -ENODEV;
> +		goto res_err;
> +	}
> +	dd->phys_base = res->start;
> +
> +	/* Get the DMA */
> +	res = platform_get_resource(pdev, IORESOURCE_DMA, 0);
> +	if (!res)
> +		dev_info(dev, "no DMA resource info\n");
> +	else
> +		dd->dma = res->start;
> +
> +	/* for some reason non-dma hash calculation sometimes fails with irq */
> +	if (dd->dma) {
> +		/* Get the IRQ */
> +		res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);

		platform_get_irq();

> +	/* Initializing the clock */
> +	dd->iclk = clk_get(NULL, SHA1_MD5_ICLK);

		clk_get(&pdev->dev, "ick");

> +	dd->io_base = ioremap(dd->phys_base, SZ_4K);
> +	if (!dd->io_base) {
> +		dev_err(dev, "can't ioremap\n");
> +		rc = -ENOMEM;
> +		goto io_err;
> +	}
> +
> +	clk_enable(dd->iclk);
> +	dev_info(dev, "hw accel on OMAP rev %u.%u\n",
> +		(omap_sha1_md5_read(dd, SHA_REG_REV) & SHA_REG_REV_MAJOR) >> 4,
> +		omap_sha1_md5_read(dd, SHA_REG_REV) & SHA_REG_REV_MINOR);

	dev_dbg() ??

> +	clk_disable(dd->iclk);
> +
> +	/*now register API*/

fix the comment style.

> +static int omap_sha1_md5_remove(struct platform_device *pdev)

missing section definition

> +{

	static struct omap_sha1_md5_dev *dd = 	platform_get_drvdata(pdev);

> +	crypto_unregister_ahash(&omap_md5_aalg);
> +	crypto_unregister_ahash(&omap_sha1_aalg);
> +	crypto_unregister_shash(&omap_sha1_alg);
> +	crypto_unregister_shash(&omap_md5_alg);
> +	tasklet_kill(&dd->done_task);
> +	iounmap(dd->io_base);
> +	clk_put(dd->iclk);
> +	if (dd->irq)
> +		free_irq(dd->irq, dd);

0 is a valid irq number.

> +	kfree(dd);
> +
> +	return 0;
> +}
> +
> +#ifdef CONFIG_ARCH_OMAP24XX
> +static struct resource sha1_md5_resources[] = {
> +	{
> +		.start	= OMAP24XX_SEC_SHA1MD5_BASE,
> +		.end	= OMAP24XX_SEC_SHA1MD5_BASE + 0x64,
> +		.flags	= IORESOURCE_MEM,
> +	},
> +	{
> +		.start	= INT_24XX_SHA1MD5,
> +		.flags	= IORESOURCE_IRQ,
> +	}
> +};
> +#endif
> +#ifdef CONFIG_ARCH_OMAP34XX
> +static struct resource sha1_md5_resources[] = {
> +	{
> +		.start	= OMAP34XX_SEC_SHA1MD5_BASE,
> +		.end	= OMAP34XX_SEC_SHA1MD5_BASE + 0x64,
> +		.flags	= IORESOURCE_MEM,
> +	},
> +	{
> +		.start	= INT_34XX_SHA1MD52_IRQ,
> +		.flags	= IORESOURCE_IRQ,
> +	},
> +	{
> +		.start	= OMAP34XX_DMA_SHA1MD5_RX,
> +		.flags	= IORESOURCE_DMA,
> +	}
> +};
> +#endif
> +
> +static void omap_sha1_md5_release(struct device *dev)
> +{
> +}
> +
> +static struct platform_device sha1_md5_device = {
> +	.name		= "omap-sha1-md5",
> +	.id		= -1,
> +	.num_resources	= ARRAY_SIZE(sha1_md5_resources),
> +	.resource	= sha1_md5_resources,
> +	.dev.release	= omap_sha1_md5_release,
> +};

the platform_device should come from mach-omap[12]/

> +static struct platform_driver omap_sha1_md5_driver = {
> +	.probe	= omap_sha1_md5_probe,
> +	.remove	= omap_sha1_md5_remove,
> +	.driver	= {
> +		.name	= DRIVER_NAME,
> +		.owner	= THIS_MODULE,
> +	},
> +};
> +
> +static int __init omap_sha1_md5_mod_init(void)
> +{
> +	int ret;
> +
> +	pr_info("loading %s driver\n", DRIVER_NAME);
> +
> +	if (!cpu_class_is_omap2() ||
> +		omap_type() != OMAP2_DEVICE_TYPE_SEC) {
> +		pr_err("Unsupported cpu\n");
> +		return -ENODEV;
> +	}
> +
> +	ret = platform_driver_register(&omap_sha1_md5_driver);
> +	if (ret)
> +		return ret;
> +
> +	ret = platform_device_register(&sha1_md5_device);
> +	if (ret)
> +		goto err;
> +
> +	return 0;
> +
> +err:
> +	platform_driver_unregister(&omap_sha1_md5_driver);
> +
> +	return ret;
> +}

this should be simply:

static int __init omap_sha1_md5_mod_init(void)
{
	return platform_driver_register(&omap_sha1_md5_driver);
}

depending on the section you use on probe() it should use
platform_driver_probe(&omap_sha1_md5_driver, omap_sha1_md5_probe)
instead.

> +static void __exit omap_sha1_md5_mod_exit(void)
> +{
> +	platform_device_unregister(&sha1_md5_device);

not here.

-- 
balbi
