From: Kim Phillips <kim.phillips-KZfg59tc24xl57MIdRCFDg@public.gmane.org>
Subject: Re: [PATCH v1] crypto: driver for tegra AES hardware
Date: Sat, 5 Nov 2011 18:10:25 -0500
Message-ID: <20111105181025.69918e625a169ccb30d9b7c8@freescale.com>
References: <1320489734-9085-1-git-send-email-vwadekar@nvidia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: <herbert-F6s6mLieUQo7FNHlEwC/lvQIK84fMopw@public.gmane.org>, <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
	<linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, <linux-tegra-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: <vwadekar-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-tegra-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1320489734-9085-1-git-send-email-vwadekar-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Sender: linux-tegra-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

On Sat, 5 Nov 2011 16:12:14 +0530
<vwadekar-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org> wrote:

> +config CRYPTO_DEV_TEGRA_AES
> +	tristate "Support for TEGRA AES hw engine"
> +	depends on ARCH_TEGRA
> +	select CRYPTO_AES
> +	help
> +	  TEGRA processors have AES module accelerator. Select this if you
> +	  want to use the TEGRA module for AES algorithms.
> +

"To compile this driver as a module, choose M here: the module
will be called tegra-aes."

> +static int aes_start_crypt(struct tegra_aes_dev *dd, u32 in_addr, u32 out_addr,
> +	int nblocks, int mode, bool upd_iv)
> +{
> +	u32 cmdq[AES_HW_MAX_ICQ_LENGTH];
> +	int i, eng_busy, icq_empty, ret;
> +	u32 value;
> +
> +	/* reset all the interrupt bits */
> +	aes_writel(dd, 0xFFFFFFFF, TEGRA_AES_INTR_STATUS);
> +
> +	/* enable error, dma xfer complete interrupts */
> +	aes_writel(dd, 0x33, TEGRA_AES_INT_ENB);
> +
> +	/* this module is shared with the other hardware blocks
> +	 * and there have been cases where another user of the VDE
> +	 * has caused this irq to trigger */
> +	enable_irq(dd->irq);

do the other users of the VDE cause this IRQ to trigger in error?
If so, they should be fixed.  If not, and the IRQ line is shared by
h/w, then all users of the IRQ should request_irq with IRQF_SHARED,
and return IRQ_NONE if the IRQ wasn't for them.  Either way, the IRQ
should be left enabled.

> +	value = aes_readl(dd, TEGRA_AES_CMDQUE_CONTROL);
> +	/* access SDRAM through AHB */
> +	value &= ~TEGRA_AES_CMDQ_CTRL_SRC_STM_SEL_FIELD;
> +	value &= ~TEGRA_AES_CMDQ_CTRL_DST_STM_SEL_FIELD;
> +	value |= (TEGRA_AES_CMDQ_CTRL_SRC_STM_SEL_FIELD |
> +		  TEGRA_AES_CMDQ_CTRL_DST_STM_SEL_FIELD |
> +		  TEGRA_AES_CMDQ_CTRL_ICMDQEN_FIELD);

unnecessary parens

> +	ret = wait_for_completion_timeout(&dd->op_complete,
> +			msecs_to_jiffies(150));

alignment

> +	total = dd->total;
> +	rctx = ablkcipher_request_ctx(req);
> +	ctx = crypto_ablkcipher_ctx(crypto_ablkcipher_reqtfm(req));
> +	rctx->mode &= FLAGS_MODE_MASK;
> +	dd->flags = (dd->flags & ~FLAGS_MODE_MASK) | rctx->mode;
> +
> +	dd->iv = (u8 *)req->info;
> +	dd->ivlen = crypto_ablkcipher_ivsize(crypto_ablkcipher_reqtfm(req));

cleaner:

tfm = crypto_ablkcipher_reqtfm(req);
...
ctx = crypto_ablkcipher_ctx(tfm);
...
dd->ivlen = crypto_ablkcipher_ivsize(tfm);

> +	/* assign new context to device */
> +	ctx->dd = dd;
> +	dd->ctx = ctx;
> +
> +	if (ctx->flags & FLAGS_NEW_KEY) {
> +		/* copy the key */
> +		memset(dd->ivkey_base, 0, AES_HW_KEY_TABLE_LENGTH_BYTES);
> +		memcpy(dd->ivkey_base, ctx->key, ctx->keylen);

these really should be writes to mutually exclusive addresses.

> +		addr_in = sg_dma_address(in_sg);
> +		addr_out = sg_dma_address(out_sg);
> +		dd->flags |= FLAGS_FAST;
> +		count = min((int)sg_dma_len(in_sg), (int)dma_max);

use min_t

> +static irqreturn_t aes_irq(int irq, void *dev_id)
> +{
> +	struct tegra_aes_dev *dd = (struct tegra_aes_dev *)dev_id;
> +	u32 value = aes_readl(dd, TEGRA_AES_INTR_STATUS);
> +
> +	dev_dbg(dd->dev, "irq_stat: 0x%x", value);
> +	if (value & TEGRA_AES_INT_ERROR_MASK)
> +		aes_writel(dd, TEGRA_AES_INT_ERROR_MASK, TEGRA_AES_INTR_STATUS);
> +
> +	if (!(value & TEGRA_AES_ENGINE_BUSY_FIELD))
> +		complete(&dd->op_complete);
> +
> +	return IRQ_HANDLED;

return IRQ_NONE if there was no error and (value &
TEGRA_AES_ENGINE_BUSY_FIELD).

> +	ret = aes_start_crypt(dd, (u32)dd->dma_buf_in,
> +		(u32)dd->dma_buf_out, 1, dd->flags, true);

alignment

> +static int tegra_aes_rng_reset(struct crypto_rng *tfm, u8 *seed,
> +	unsigned int slen)

alignment

> +	/* copy the key to the key slot */
> +	memset(dd->ivkey_base, 0, AES_HW_KEY_TABLE_LENGTH_BYTES);
> +	memcpy(dd->ivkey_base, seed + DEFAULT_RNG_BLK_SZ, AES_KEYSIZE_128);

should be to mutually exclusive addresses

> +	/* set seed to the aes hw slot */
> +	memcpy(dd->buf_in, dd->iv, DEFAULT_RNG_BLK_SZ);
> +	ret = aes_start_crypt(dd, (u32)dd->dma_buf_in,
> +			dd->dma_buf_out, 1, FLAGS_CBC, false);

alignment

> +static int __devexit tegra_aes_remove(struct platform_device *pdev)
> +{
> +	struct device *dev = &pdev->dev;
> +	struct tegra_aes_dev *dd = platform_get_drvdata(pdev);
> +	int i;
> +
> +	if (!dd)
> +		return -ENODEV;
> +

when would this condition be met?

> +/* init vector select */
> +#define TEGRA_AES_SECURE_IV_SELECT_SHIFT	(10)

no parens

Kim
