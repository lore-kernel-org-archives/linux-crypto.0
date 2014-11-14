From: Andrew Bresticker <abrestic@chromium.org>
Subject: Re: [PATCH 1/2] crypto: Add Imagination Technologies hw hash accelerator
Date: Fri, 14 Nov 2014 15:59:02 -0800
Message-ID: <CAL1qeaGN9q_WHP2YJ3fY3r11v0pitcmwbjam5dRzeZhHCp7c8g@mail.gmail.com>
References: <1415621455-10468-1-git-send-email-james.hartley@imgtec.com>
	<1415621455-10468-2-git-send-email-james.hartley@imgtec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Herbert Xu <herbert@gondor.apana.org.au>, davem@davemloft.net,
	Grant Likely <grant.likely@linaro.org>,
	Rob Herring <robh+dt@kernel.org>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	joe@perches.com, mchehab@osg.samsung.com,
	Antti Palosaari <crope@iki.fi>, jg1.han@samsung.com,
	linux-crypto@vger.kernel.org,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>,
	Ezequiel Garcia <ezequiel.garcia@imgtec.com>
To: James Hartley <james.hartley@imgtec.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-vc0-f177.google.com ([209.85.220.177]:41867 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754715AbaKNX7E (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 14 Nov 2014 18:59:04 -0500
Received: by mail-vc0-f177.google.com with SMTP id ij19so4174380vcb.36
        for <linux-crypto@vger.kernel.org>; Fri, 14 Nov 2014 15:59:02 -0800 (PST)
In-Reply-To: <1415621455-10468-2-git-send-email-james.hartley@imgtec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi James,

On Mon, Nov 10, 2014 at 4:10 AM, James Hartley <james.hartley@imgtec.com> wrote:
> This adds support for the Imagination Technologies hash
> accelerator that provides hardware acceleration for
> SHA1 SHA224 SHA256 and MD5 Hashes.
>
> Signed-off-by: James Hartley <james.hartley@imgtec.com>

It's going to take me a little longer to get through the crypto API
parts of the driver, but here are some initial comments.

> diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
> index 2fb0fdf..4b931eb 100644
> --- a/drivers/crypto/Kconfig
> +++ b/drivers/crypto/Kconfig
> @@ -436,4 +436,17 @@ config CRYPTO_DEV_QCE
>           hardware. To compile this driver as a module, choose M here. The
>           module will be called qcrypto.
>
> +config CRYPTO_DEV_IMGTEC_HASH
> +        tristate "Imagination Technologies hardware hash accelerator"

Is there no meaningful depends-on here?  There's no MACH_PISTACHIO
yet, but perhaps MIPS for now?  Also, {readl,writel}_relaxed aren't
available on all architectures.

> +        select CRYPTO_ALG_API
> +        select CRYPTO_MD5
> +        select CRYPTO_SHA1
> +        select CRYPTO_SHA224
> +        select CRYPTO_SHA256
> +        select CRYPTO_HASH
> +        help
> +          This driver interfaces with the Imagination Technologies
> +          hardware hash accelerator. Supporting MD5/SHA1/SHA224/SHA256
> +          hashing algorithms.
> +
>  endif # CRYPTO_HW

> diff --git a/drivers/crypto/img-hash.c b/drivers/crypto/img-hash.c
> new file mode 100644
> index 0000000..e58c81a
> --- /dev/null
> +++ b/drivers/crypto/img-hash.c

> @@ -0,0 +1,1048 @@
> +/*
> +* Copyright (c) 2014 Imagination Technologies
> +* Author:  Will Thomas
> +*
> +* This program is free software; you can redistribute it and/or modify
> +* it under the terms of the GNU General Public License version 2 as published
> +* by the Free Software Foundation.
> +*
> +*      Interface structure taken from omap-sham driver
> +*/

Comment style is incorrect here, the *s in multi-line comments should
be aligned.

> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/clk.h>
> +#include <linux/platform_device.h>
> +#include <linux/io.h>
> +#include <linux/scatterlist.h>
> +#include <linux/interrupt.h>
> +#include <linux/of_device.h>
> +#include <crypto/sha.h>
> +#include <crypto/md5.h>
> +#include <crypto/internal/hash.h>

#includes should be sorted in alphabetical order, with a newline
separating the linux/ and crypto/ includes.

> +#define MD5_BLOCK_SIZE                 64

There's already MD5_HMAC_BLOCK_SIZE #define'd in crypto/md5.h.

> +#define CR_RESET                       0
> +#define CR_RESET_SET                   1
> +#define CR_RESET_UNSET                 0
> +
> +#define CR_MESSAGE_LENGTH_H            0x4
> +#define CR_MESSAGE_LENGTH_L            0x8
> +
> +#define        CR_CONTROL                      0xc
> +#define CR_CONTROL_BYTE_ORDER_3210     0
> +#define CR_CONTROL_BYTE_ORDER_0123     1
> +#define CR_CONTROL_BYTE_ORDER_2310     2
> +#define CR_CONTROL_BYTE_ORDER_1032     3
> +#define CR_CONTROL_ALGO_MD5    0
> +#define CR_CONTROL_ALGO_SHA1   1
> +#define CR_CONTROL_ALGO_SHA224 2
> +#define CR_CONTROL_ALGO_SHA256 3
> +
> +#define CR_INTSTAT                     0x10
> +#define CR_INTENAB                     0x14
> +#define CR_INTCLEAR                    0x18
> +#define CR_INT_RESULTS_AVAILABLE       (1<<0)
> +#define CR_INT_NEW_RESULTS_SET         (1<<1)
> +#define CR_INT_RESULT_READ_ERR         (1<<2)
> +#define CR_INT_MESSAGE_WRITE_ERROR     (1<<3)
> +#define CR_INT_STATUS                  (1<<8)

Use the BIT() macro for single-bit fields like this.

> +#define CR_RESULT_QUEUE                0x1c
> +#define CR_RSD0                                0x40
> +#define CR_CORE_REV                    0x50
> +#define CR_CORE_DES1           0x60
> +#define CR_CORE_DES2           0x70
> +
> +#define DRIVER_FLAGS_BUSY              BIT(0)
> +#define DRIVER_FLAGS_FINAL             BIT(1)
> +#define DRIVER_FLAGS_DMA_ACTIVE                BIT(2)
> +#define DRIVER_FLAGS_OUTPUT_READY      BIT(3)
> +#define DRIVER_FLAGS_INIT              BIT(4)
> +#define DRIVER_FLAGS_CPU               BIT(5)
> +#define DRIVER_FLAGS_DMA_READY         BIT(6)
> +#define DRIVER_FLAGS_ERROR             BIT(7)
> +#define DRIVER_FLAGS_SG                        BIT(8)
> +#define DRIVER_FLAGS_FINUP             BIT(9)
> +#define DRIVER_FLAGS_SHA1              BIT(18)
> +#define DRIVER_FLAGS_SHA224            BIT(19)
> +#define DRIVER_FLAGS_SHA256            BIT(20)
> +#define DRIVER_FLAGS_MD5               BIT(21)
> +
> +#define OP_UPDATE                      1
> +#define OP_FINAL                       2
> +
> +#define IMG_HASH_QUEUE_LENGTH          20
> +#define IMG_HASH_DMA_THRESHOLD         64
> +#ifdef __LITTLE_ENDIAN
> +#define IMG_HASH_BYTE_ORDER            (CR_CONTROL_BYTE_ORDER_3210)
> +#else
> +#define IMG_HASH_BYTE_ORDER            (CR_CONTROL_BYTE_ORDER_0123)
> +#endif
> +
> +struct img_hash_dev;
> +
> +struct img_hash_request_ctx {
> +       struct img_hash_dev     *hdev;
> +       u8 digest[SHA256_DIGEST_SIZE] __aligned(sizeof(u32));
> +       unsigned long           flags;
> +       size_t                  digsize;
> +
> +       dma_addr_t              dma_addr;
> +       size_t                  dma_ct;
> +
> +       /* sg root*/

nit: put a space between 'root' and '*/'.

> +       struct scatterlist      *sgfirst;
> +       /* walk state */
> +       struct scatterlist      *sg;
> +       size_t                  nents;
> +       size_t                  offset;
> +       unsigned int            total;
> +       size_t                  sent;
> +
> +       unsigned long           op;
> +
> +       size_t                  bufcnt;
> +       u8 buffer[0] __aligned(sizeof(u32));
> +};
> +
> +struct img_hash_ctx {
> +       struct img_hash_dev     *hdev;
> +       unsigned long           flags;
> +       struct crypto_shash     *fallback;
> +};
> +
> +struct img_hash_dev {
> +       struct list_head        list;
> +/*     phys_addr_t             phys_base;*/

Is this not needed anymore?

> +       struct device           *dev;
> +       struct clk              *iclk;
> +       int                     irq;
> +       void __iomem            *io_base;
> +
> +       phys_addr_t             bus_addr;
> +       void __iomem            *cpu_addr;
> +
> +       spinlock_t              lock;
> +       int                     err;
> +       struct tasklet_struct   done_task;
> +       struct tasklet_struct   dma_task;
> +
> +       unsigned long           flags;
> +       struct crypto_queue     queue;
> +       struct ahash_request    *req;
> +
> +       struct dma_chan         *dma_lch;
> +       struct dma_slave_config dma_conf;

Do we really need to keep around the DMA config?  It's only used in
img_hash_dma_init() - dmaengine_slave_config() makes a deep copy of
this structure.

> +};
> +
> +struct img_hash_drv {
> +       struct list_head dev_list;
> +       spinlock_t lock;
> +};
> +
> +static struct img_hash_drv img_hash = {
> +       .dev_list = LIST_HEAD_INIT(img_hash.dev_list),
> +       .lock = __SPIN_LOCK_UNLOCKED(img_hash.lock),
> +};

It looks like the only purpose of this list is to get the
corresponding struct img_hash_dev in img_hash_init().  If there's
never going to be multiple instances within an SoC, perhaps you could
just use a global?  Otherwise, you could do something like the
qualcomm driver, see drivers/crypto/qce/sha.c.  It looks like there is
some precedent for this device list though...

> +static inline u32 img_hash_read(struct img_hash_dev *hdev, u32 offset)
> +{
> +       return readl_relaxed(hdev->io_base + offset);
> +}
> +
> +static inline void img_hash_write(struct img_hash_dev *hdev,
> +                                               u32 offset, u32 value)
> +{
> +       writel_relaxed(value, hdev->io_base + offset);
> +}

Is this IP present on Meta SoCs?  If so, you may want to use vanilla
readl/writel instead, as the relaxed variants aren't defined for Meta.

> +static inline u32 img_hash_result_queue(struct img_hash_dev *hdev)

Maybe call this "img_hash_read_result_queue" to make it more obvious
as to what it's doing?

> +{
> +       return be32_to_cpu(img_hash_read(hdev, CR_RESULT_QUEUE));
> +}
> +
> +static void img_hash_write_ctrl(struct img_hash_dev *hdev, int dma)

This could have a more obvious name as well, maybe img_hash_start or
img_hash_enable?

Also, use bool instead of int for boolean flags like "dma" here.

> +{
> +       struct img_hash_request_ctx *ctx = ahash_request_ctx(hdev->req);
> +       u32 cr = IMG_HASH_BYTE_ORDER << 8;

This shift should be #define'd.

> +
> +       if (ctx->flags & DRIVER_FLAGS_MD5)
> +               cr |= CR_CONTROL_ALGO_MD5;
> +       else if (ctx->flags & DRIVER_FLAGS_SHA1)
> +               cr |= CR_CONTROL_ALGO_SHA1;
> +       else if (ctx->flags & DRIVER_FLAGS_SHA224)
> +               cr |= CR_CONTROL_ALGO_SHA224;
> +       else if (ctx->flags & DRIVER_FLAGS_SHA256)
> +               cr |= CR_CONTROL_ALGO_SHA256;
> +       dev_dbg(hdev->dev, "Starting hash process\n");
> +       img_hash_write(hdev, CR_CONTROL, cr);
> +
> +       /*
> +        * The hardware block requires two cycles between writing the control
> +        * register and writing the first word of data in non DMA mode, to
> +        * ensure the first data write is not grouped in burst with the control
> +        * register write a read is issued to 'flush' the bus.
> +        */
> +       if (!dma)
> +               img_hash_read(hdev, CR_CONTROL);
> +}
> +
> +static int img_hash_xmit_cpu(struct img_hash_dev *hdev, const u8 *buf,
> +                               size_t length, int final)
> +{
> +       int count, len32;

These should both be unsigned.

> +       const u32 *buffer = (const u32 *)buf;
> +
> +       dev_dbg(hdev->dev, "xmit_cpu:  length: %u\n", length);
> +
> +       if (final)
> +               hdev->flags |= DRIVER_FLAGS_FINAL;
> +
> +       hdev->flags |= DRIVER_FLAGS_CPU;
> +
> +       len32 = DIV_ROUND_UP(length, sizeof(u32));
> +       for (count = 0; count < len32; count++)
> +               writel_relaxed(buffer[count], hdev->cpu_addr);
> +
> +       return -EINPROGRESS;
> +}
> +
> +static int img_hash_update_cpu(struct img_hash_dev *hdev)
> +{
> +       struct img_hash_request_ctx *ctx = ahash_request_ctx(hdev->req);
> +       int bufcnt;

unsigned

> +
> +       ctx->bufcnt = sg_copy_to_buffer(hdev->req->src, sg_nents(ctx->sg),
> +                               ctx->buffer, hdev->req->nbytes);
> +
> +       ctx->total = hdev->req->nbytes;
> +       bufcnt = hdev->req->nbytes;
> +       ctx->bufcnt = 0;
> +
> +       img_hash_write_ctrl(hdev, 0);
> +
> +       return img_hash_xmit_cpu(hdev, ctx->buffer, bufcnt, 1);
> +}
> +
> +static int img_hash_copy_ready_hash(struct ahash_request *req)
> +{
> +       struct img_hash_request_ctx *ctx = ahash_request_ctx(req);
> +
> +       if (!req->result)
> +               return -EINVAL;
> +
> +       memcpy(req->result, ctx->digest, ctx->digsize);
> +
> +       return 0;
> +}
> +
> +static int img_hash_finish(struct ahash_request *req)
> +{
> +       return img_hash_copy_ready_hash(req);
> +}

Why is img_hash_copy_ready_hash() separate from img_hash_finish()?

> +static void img_hash_copy_hash(struct ahash_request *req)
> +{
> +       struct img_hash_request_ctx *ctx = ahash_request_ctx(req);
> +       u32 *hash = (u32 *) ctx->digest;
> +       int i;
> +
> +       for (i = (ctx->digsize / sizeof(u32)) - 1; i >= 0; i--)
> +               hash[i] = img_hash_result_queue(ctx->hdev);
> +}
> +
> +static void img_hash_finish_req(struct ahash_request *req, int err)
> +{
> +       struct img_hash_request_ctx *ctx = ahash_request_ctx(req);
> +       struct img_hash_dev *hdev =  ctx->hdev;
> +
> +       if (!err) {
> +               img_hash_copy_hash(req);
> +               if (DRIVER_FLAGS_FINAL & hdev->flags)
> +                       err = img_hash_finish(req);
> +       } else {
> +               ctx->flags |= DRIVER_FLAGS_ERROR;
> +       }
> +
> +       hdev->flags &= ~(DRIVER_FLAGS_DMA_READY | DRIVER_FLAGS_OUTPUT_READY |
> +               DRIVER_FLAGS_CPU | DRIVER_FLAGS_BUSY | DRIVER_FLAGS_FINAL);
> +
> +       clk_disable_unprepare(hdev->iclk);
> +
> +       if (req->base.complete)
> +               req->base.complete(&req->base, err);
> +
> +       tasklet_schedule(&hdev->done_task);
> +}
> +
> +static void img_hash_dma_callback(void *data)
> +{
> +       struct img_hash_dev *hdev = (struct img_hash_dev *) data;
> +       struct img_hash_request_ctx *ctx = ahash_request_ctx(hdev->req);
> +
> +       if (ctx->bufcnt) {
> +               img_hash_xmit_cpu(hdev, ctx->buffer, ctx->bufcnt, 0);
> +               ctx->bufcnt = 0;
> +       }
> +       if (ctx->sg)
> +               tasklet_schedule(&hdev->dma_task);
> +}
> +
> +static int img_hash_update_dma(struct img_hash_dev *hdev)
> +{
> +       struct img_hash_request_ctx *ctx = ahash_request_ctx(hdev->req);
> +
> +       img_hash_write_ctrl(hdev, 1);
> +
> +       pr_debug("xmit dma size: %d\n", ctx->total);

For driver related messages, please use the equivalent dev_*() functions.

> +
> +       if (ctx->flags & DRIVER_FLAGS_FINUP && !ctx->total)
> +               hdev->flags |= DRIVER_FLAGS_FINAL;
> +
> +       hdev->flags |= DRIVER_FLAGS_DMA_ACTIVE | DRIVER_FLAGS_FINAL;
> +
> +       tasklet_schedule(&hdev->dma_task);
> +
> +       return -EINPROGRESS;
> +

Extra newline.

> +}
> +
> +static int img_hash_update_req(struct img_hash_dev *hdev)
> +{
> +       struct ahash_request *req = hdev->req;
> +       int err = 0;
> +
> +       if (req->nbytes < IMG_HASH_DMA_THRESHOLD)
> +               err = img_hash_update_cpu(hdev);
> +       else
> +               err = img_hash_update_dma(hdev);
> +
> +       return err;
> +}
> +
> +static int img_hash_final_req(struct img_hash_dev *hdev)
> +{
> +       struct ahash_request *req = hdev->req;
> +       struct img_hash_request_ctx *ctx = ahash_request_ctx(req);
> +       int err = 0;
> +       int count = ctx->bufcnt;
> +
> +       ctx->bufcnt = 0;
> +
> +       if (req->nbytes  >= IMG_HASH_DMA_THRESHOLD) {
> +               ctx->bufcnt = 0;
> +               err = img_hash_update_dma(hdev);
> +       } else {
> +               err = img_hash_xmit_cpu(hdev, ctx->buffer, count, 1);
> +       }
> +
> +       return err;
> +}
> +
> +static int img_hash_hw_init(struct img_hash_dev *hdev)
> +{
> +       unsigned long long nbits;
> +       u32 u, l;
> +
> +       clk_prepare_enable(hdev->iclk);
> +
> +       img_hash_write(hdev, CR_RESET, CR_RESET_SET);
> +       img_hash_write(hdev, CR_RESET, CR_RESET_UNSET);
> +       img_hash_write(hdev, CR_INTENAB, CR_INT_NEW_RESULTS_SET);
> +
> +       nbits = (hdev->req->nbytes << 3);
> +       u = nbits >> 32;
> +       l = nbits;
> +       img_hash_write(hdev, CR_MESSAGE_LENGTH_H, u);
> +       img_hash_write(hdev, CR_MESSAGE_LENGTH_L, l);
> +
> +       if (!(DRIVER_FLAGS_INIT & hdev->flags)) {
> +               hdev->flags |= DRIVER_FLAGS_INIT;
> +               hdev->err = 0;
> +       }
> +       pr_debug("hw initialized, nbits: %llx\n", nbits);
> +       return 0;
> +}
> +
> +static int img_hash_init(struct ahash_request *req)
> +{
> +       struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
> +       struct img_hash_ctx *tctx = crypto_ahash_ctx(tfm);
> +       struct img_hash_request_ctx *ctx = ahash_request_ctx(req);
> +       struct img_hash_dev *hdev = NULL;
> +       struct img_hash_dev *tmp;
> +
> +       spin_lock_bh(&img_hash.lock);
> +       if (!tctx->hdev) {
> +               list_for_each_entry(tmp, &img_hash.dev_list, list) {
> +                       hdev = tmp;
> +                       break;
> +               }
> +               tctx->hdev = hdev;
> +
> +       } else {
> +               hdev = tctx->hdev;
> +       }
> +
> +       spin_unlock_bh(&img_hash.lock);
> +       ctx->hdev = hdev;
> +       ctx->flags = 0;
> +       ctx->digsize = crypto_ahash_digestsize(tfm);
> +
> +       switch (ctx->digsize) {
> +       case SHA1_DIGEST_SIZE:
> +               ctx->flags |= DRIVER_FLAGS_SHA1;
> +               break;
> +       case SHA256_DIGEST_SIZE:
> +               ctx->flags |= DRIVER_FLAGS_SHA256;
> +               break;
> +       case SHA224_DIGEST_SIZE:
> +               ctx->flags |= DRIVER_FLAGS_SHA224;
> +               break;
> +       case MD5_DIGEST_SIZE:
> +               ctx->flags |= DRIVER_FLAGS_MD5;
> +               break;
> +       default:
> +               return -EINVAL;
> +       }
> +
> +       ctx->bufcnt = 0;
> +       ctx->offset = 0;
> +       ctx->sent = 0;
> +       return 0;
> +
> +}
> +
> +static int img_hash_handle_queue(struct img_hash_dev *hdev,
> +                               struct ahash_request *req)
> +{
> +       struct crypto_async_request *async_req, *backlog;
> +       struct img_hash_request_ctx *ctx;
> +       unsigned long flags;
> +       int err = 0, res = 0;
> +
> +       spin_lock_irqsave(&hdev->lock, flags);
> +
> +       if (req)
> +               res = ahash_enqueue_request(&hdev->queue, req);
> +
> +       if (DRIVER_FLAGS_BUSY & hdev->flags) {
> +               spin_unlock_irqrestore(&hdev->lock, flags);
> +               return res;
> +       }
> +
> +       backlog = crypto_get_backlog(&hdev->queue);
> +       async_req = crypto_dequeue_request(&hdev->queue);
> +       if (async_req)
> +               hdev->flags |= DRIVER_FLAGS_BUSY;
> +
> +       spin_unlock_irqrestore(&hdev->lock, flags);
> +
> +       if (!async_req)
> +               return res;
> +
> +       if (backlog)
> +               backlog->complete(backlog, -EINPROGRESS);
> +
> +       req = ahash_request_cast(async_req);
> +       hdev->req = req;
> +       ctx = ahash_request_ctx(req);
> +
> +       dev_info(hdev->dev, "handling new req, op: %lu, nbytes: %d\n",
> +                                               ctx->op, req->nbytes);
> +
> +       err = img_hash_hw_init(hdev);
> +
> +       if (err)
> +               goto err1;
> +
> +       if (ctx->op == OP_UPDATE) {
> +               err = img_hash_update_req(hdev);
> +               if (err != -EINPROGRESS && (ctx->flags & DRIVER_FLAGS_FINUP))
> +                       /* update does not call final so must here */
> +                       err = img_hash_final_req(hdev);
> +       } else if (ctx->op == OP_FINAL) {
> +               err = img_hash_final_req(hdev);
> +       }
> +
> +err1:
> +       if (err != -EINPROGRESS)
> +               /* done_task will not finish so do it here */
> +               img_hash_finish_req(req, err);
> +
> +       return res;
> +}
> +
> +static int img_hash_enqueue(struct ahash_request *req, unsigned int op)
> +{
> +       struct img_hash_request_ctx *ctx = ahash_request_ctx(req);
> +       struct img_hash_ctx *tctx = crypto_tfm_ctx(req->base.tfm);
> +       struct img_hash_dev *hdev = tctx->hdev;
> +
> +       ctx->op = op;
> +
> +       return img_hash_handle_queue(hdev, req);
> +}
> +
> +static int img_hash_update(struct ahash_request *req)
> +{
> +       struct img_hash_request_ctx *ctx = ahash_request_ctx(req);
> +
> +       ctx->total = req->nbytes;
> +       ctx->sg = req->src;
> +       ctx->sgfirst = req->src;
> +       ctx->nents = sg_nents(ctx->sg);
> +
> +       if (ctx->flags & DRIVER_FLAGS_FINUP) {
> +               if (ctx->total < IMG_HASH_DMA_THRESHOLD)
> +                       ctx->flags |= DRIVER_FLAGS_CPU;
> +       }
> +       return img_hash_enqueue(req, OP_UPDATE);
> +}
> +
> +static int img_hash_final(struct ahash_request *req)
> +{
> +       struct img_hash_request_ctx *ctx = ahash_request_ctx(req);
> +
> +       ctx->flags |= DRIVER_FLAGS_FINUP;
> +
> +       if (ctx->flags & DRIVER_FLAGS_ERROR)
> +               return 0;
> +
> +       if (ctx->bufcnt)
> +               return img_hash_enqueue(req, OP_FINAL);
> +
> +       return img_hash_finish(req);
> +}
> +
> +static int img_hash_finup(struct ahash_request *req)
> +{
> +       struct img_hash_request_ctx *ctx = ahash_request_ctx(req);
> +       int err1, err2;
> +
> +       ctx->flags |= DRIVER_FLAGS_FINUP;
> +
> +       err1 = img_hash_update(req);
> +       if (err1 == -EINPROGRESS || err1 == -EBUSY)
> +               return err1;
> +       err2 = img_hash_final(req);
> +       return err1 ?: err2;
> +}
> +
> +static int img_hash_digest(struct ahash_request *req)
> +{
> +       return img_hash_init(req) ?: img_hash_finup(req);
> +}
> +
> +static int img_cra_hash_init_alg(struct crypto_tfm *tfm,
> +                                       const char *base_alg_name)
> +{
> +       struct img_hash_ctx *ctx = crypto_tfm_ctx(tfm);
> +       const char *alg_name = crypto_tfm_alg_name(tfm);
> +       int err = -ENOMEM;
> +
> +       ctx->fallback = crypto_alloc_shash(alg_name, 0,
> +                                               CRYPTO_ALG_NEED_FALLBACK);
> +       if (IS_ERR(ctx->fallback)) {
> +               pr_err("Could not load fallback driver.\n");
> +               err = PTR_ERR(ctx->fallback);
> +               goto err;
> +       }
> +       crypto_ahash_set_reqsize(__crypto_ahash_cast(tfm),
> +                                       sizeof(struct img_hash_request_ctx) +
> +                                       IMG_HASH_DMA_THRESHOLD);
> +
> +       return 0;
> +
> +err:
> +       return err;
> +}
> +
> +static int img_cra_sha1_init(struct crypto_tfm *tfm)
> +{
> +       return img_cra_hash_init_alg(tfm, "sha1");
> +}
> +
> +static int img_cra_sha224_init(struct crypto_tfm *tfm)
> +{
> +       return img_cra_hash_init_alg(tfm, "sha224");
> +}
> +
> +static int img_cra_sha256_init(struct crypto_tfm *tfm)
> +{
> +       return img_cra_hash_init_alg(tfm, "sha256");
> +}
> +
> +static int img_cra_md5_init(struct crypto_tfm *tfm)
> +{
> +       return img_cra_hash_init_alg(tfm, "md5");
> +}
> +
> +static void img_hash_cra_exit(struct crypto_tfm *tfm)
> +{
> +       struct img_hash_ctx *tctx = crypto_tfm_ctx(tfm);
> +
> +       crypto_free_shash(tctx->fallback);
> +}
> +
> +static irqreturn_t img_irq_handler(int irq, void *dev_id)
> +{
> +       struct img_hash_dev *hdev = dev_id;
> +       u32 reg;
> +
> +       reg = img_hash_read(hdev, CR_INTSTAT);
> +       img_hash_write(hdev, CR_INTCLEAR, reg);
> +
> +       if (reg & CR_INT_NEW_RESULTS_SET) {
> +               dev_dbg(hdev->dev, "IRQ CR_INT_NEW_RESULTS_SET\n");
> +               if (DRIVER_FLAGS_BUSY & hdev->flags) {
> +                       hdev->flags |= DRIVER_FLAGS_OUTPUT_READY;
> +                       if (!(DRIVER_FLAGS_CPU & hdev->flags))
> +                               hdev->flags |= DRIVER_FLAGS_DMA_READY;
> +                       tasklet_schedule(&hdev->done_task);
> +               } else {
> +                       dev_warn(hdev->dev,
> +                               "HASH interrupt when no active requests.\n");
> +               }
> +

Extra newline.

> +       } else if (reg & CR_INT_RESULTS_AVAILABLE) {
> +               dev_warn(hdev->dev, "IRQ CR_INT_RESULTS_AVAILABLE\n");
> +       } else if (reg & CR_INT_RESULT_READ_ERR) {
> +               dev_warn(hdev->dev, "IRQ CR_INT_RESULT_READ_ERR\n");
> +       } else if (reg & CR_INT_MESSAGE_WRITE_ERROR) {
> +               dev_warn(hdev->dev, "IRQ CR_INT_MESSAGE_WRITE_ERROR\n");

Are the above three unexpected?  If so, the dev_warn() message would
be more helpful if it indicated that.

> +       }
> +       return IRQ_HANDLED;
> +}
> +
> +static struct ahash_alg img_algs[] = {
> +       {
> +       .init = img_hash_init,

Indentation is off here.  Members of the struct should be indented one
level from the open brace.

> +       .update = img_hash_update,
> +       .final = img_hash_final,
> +       .finup = img_hash_finup,
> +       .digest = img_hash_digest,
> +       .halg = {
> +               .digestsize = MD5_DIGEST_SIZE,
> +               .base = {
> +                       .cra_name = "md5",
> +                               .cra_driver_name = "img-md5",
> +                               .cra_priority = 301,
> +                       .cra_flags =
> +                       CRYPTO_ALG_ASYNC |
> +                       CRYPTO_ALG_NEED_FALLBACK,
> +                       .cra_blocksize = MD5_BLOCK_SIZE,
> +                       .cra_ctxsize = sizeof(struct img_hash_ctx),
> +                       .cra_init = img_cra_md5_init,
> +                       .cra_exit = img_hash_cra_exit,
> +                       .cra_module = THIS_MODULE,
> +                       }
> +               }
> +       },
> +       {
> +       .init = img_hash_init,
> +       .update = img_hash_update,
> +       .final = img_hash_final,
> +       .finup = img_hash_finup,
> +       .digest = img_hash_digest,
> +       .halg = {
> +               .digestsize = SHA1_DIGEST_SIZE,
> +               .base = {
> +                       .cra_name = "sha1",
> +                       .cra_driver_name = "img-sha1",
> +                       .cra_priority = 3000,
> +                       .cra_flags =
> +                       CRYPTO_ALG_ASYNC |
> +                       CRYPTO_ALG_NEED_FALLBACK,
> +                       .cra_blocksize = SHA1_BLOCK_SIZE,
> +                       .cra_ctxsize = sizeof(struct img_hash_ctx),
> +                       .cra_init = img_cra_sha1_init,
> +                       .cra_exit = img_hash_cra_exit,
> +                       .cra_module = THIS_MODULE,
> +                       }
> +               }
> +       },
> +       {
> +       .init = img_hash_init,
> +       .update = img_hash_update,
> +       .final = img_hash_final,
> +       .finup = img_hash_finup,
> +       .digest = img_hash_digest,
> +       .halg = {
> +               .digestsize = SHA224_DIGEST_SIZE,
> +               .base = {
> +                       .cra_name = "sha224",
> +                       .cra_driver_name = "img-sha224",
> +                       .cra_priority = 3000,
> +                       .cra_flags =
> +                       CRYPTO_ALG_ASYNC |
> +                       CRYPTO_ALG_NEED_FALLBACK,
> +                       .cra_blocksize = SHA224_BLOCK_SIZE,
> +                       .cra_ctxsize = sizeof(struct img_hash_ctx),
> +                       .cra_init = img_cra_sha224_init,
> +                       .cra_exit = img_hash_cra_exit,
> +                       .cra_module = THIS_MODULE,
> +                       }
> +               }
> +       },
> +       {
> +       .init = img_hash_init,
> +       .update = img_hash_update,
> +       .final = img_hash_final,
> +       .finup = img_hash_finup,
> +       .digest = img_hash_digest,
> +       .halg = {
> +               .digestsize = SHA256_DIGEST_SIZE,
> +               .base = {
> +                       .cra_name = "sha256",
> +                       .cra_driver_name = "img-sha256",
> +                       .cra_priority = 301,
> +                       .cra_flags =
> +                       CRYPTO_ALG_ASYNC |
> +                       CRYPTO_ALG_NEED_FALLBACK,
> +                       .cra_blocksize = SHA256_BLOCK_SIZE,
> +                       .cra_ctxsize = sizeof(struct img_hash_ctx),
> +                       .cra_init = img_cra_sha256_init,
> +                       .cra_exit = img_hash_cra_exit,
> +                       .cra_module = THIS_MODULE,
> +                       }
> +               }
> +       }
> +};
> +
> +static int img_register_algs(struct img_hash_dev *hdev)
> +{
> +       int i, err;
> +
> +       for (i = 0; i < ARRAY_SIZE(img_algs); i++) {
> +               err = crypto_register_ahash(&img_algs[i]);
> +               if (err)
> +                       goto err_reg;
> +       }
> +       return 0;
> +
> +err_reg:
> +       for (; i--; )
> +               crypto_unregister_ahash(&img_algs[i]);
> +
> +       return err;
> +}
> +
> +static int img_unregister_algs(struct img_hash_dev *hdev)
> +{
> +       int i;
> +
> +       for (i = 0; i < ARRAY_SIZE(img_algs); i++)
> +               crypto_unregister_ahash(&img_algs[i]);
> +       return 0;
> +}
> +
> +static int img_hash_update_dma_stop(struct img_hash_dev *hdev)
> +{
> +       struct img_hash_request_ctx *ctx = ahash_request_ctx(hdev->req);
> +
> +       if (ctx->flags & DRIVER_FLAGS_SG)
> +               dma_unmap_sg(hdev->dev, ctx->sg, ctx->dma_ct, DMA_TO_DEVICE);
> +
> +       return 0;
> +}
> +
> +static void img_hash_done_task(unsigned long data)
> +{
> +       struct img_hash_dev *hdev = (struct img_hash_dev *) data;
> +       int err = 0;
> +
> +       if (!(DRIVER_FLAGS_BUSY & hdev->flags)) {
> +               img_hash_handle_queue(hdev, NULL);
> +               return;
> +       }
> +
> +       if (DRIVER_FLAGS_CPU & hdev->flags) {
> +               if (DRIVER_FLAGS_OUTPUT_READY & hdev->flags) {
> +                       hdev->flags &= ~DRIVER_FLAGS_OUTPUT_READY;
> +                       goto finish;
> +               }
> +       } else if (DRIVER_FLAGS_DMA_READY & hdev->flags) {
> +               if (DRIVER_FLAGS_DMA_ACTIVE & hdev->flags) {
> +                       hdev->flags &= ~DRIVER_FLAGS_DMA_ACTIVE;
> +                       img_hash_update_dma_stop(hdev);
> +                       if (hdev->err) {
> +                               err = hdev->err;
> +                               goto finish;
> +                       }
> +               }
> +               if (DRIVER_FLAGS_OUTPUT_READY & hdev->flags) {
> +                       hdev->flags &= ~(DRIVER_FLAGS_DMA_READY |
> +                                       DRIVER_FLAGS_OUTPUT_READY);
> +                       goto finish;
> +               }
> +       }
> +       return;
> +
> +finish:
> +       img_hash_finish_req(hdev->req, err);
> +}
> +
> +static void img_hash_xmit_dma(struct img_hash_dev *hdev, struct scatterlist *sg)
> +{
> +       struct dma_async_tx_descriptor *desc;
> +       struct img_hash_request_ctx *ctx = ahash_request_ctx(hdev->req);
> +
> +       ctx->dma_ct = dma_map_sg(hdev->dev, sg, 1, DMA_MEM_TO_DEV);
> +       if (ctx->dma_ct == 0) {
> +               dev_err(hdev->dev, "Invalid DMA sg\n");
> +               hdev->err = -EINVAL;
> +               return;
> +       }
> +
> +       desc = dmaengine_prep_slave_sg(hdev->dma_lch,
> +                                       sg,
> +                                       ctx->dma_ct,
> +                                       DMA_MEM_TO_DEV,
> +                                       DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
> +       if (!desc) {
> +               dev_err(hdev->dev, "Null DMA descriptor\n");
> +               hdev->err = -EINVAL;
> +               return;
> +       }
> +       desc->callback = img_hash_dma_callback;
> +       desc->callback_param = hdev;
> +       dmaengine_submit(desc);
> +       dma_async_issue_pending(hdev->dma_lch);
> +}
> +
> +static void img_hash_dma_task(unsigned long d)
> +{
> +       struct img_hash_dev *hdev = (struct img_hash_dev *) d;
> +       struct img_hash_request_ctx *ctx = ahash_request_ctx(hdev->req);
> +       char *addr;

u8 *?

> +       size_t nbytes, bleft, bsend, len, tbc;
> +       struct scatterlist tsg;
> +
> +       if (!ctx->sg)
> +               return;
> +       if (!hdev)
> +               pr_err("invalid ptr for hash device");

This shouldn't be possible.

> +
> +       addr = sg_virt(ctx->sg);
> +       nbytes = ctx->sg->length - ctx->offset;
> +       bleft = nbytes % 4;
> +       bsend = (nbytes / 4);
> +
> +

Extra newline.

> +       if (bsend) {
> +               sg_init_one(&tsg, addr + ctx->offset, bsend * 4);
> +               img_hash_xmit_dma(hdev, &tsg);
> +               ctx->sent += bsend * 4;
> +       }
> +
> +       if (bleft) {
> +               ctx->bufcnt = sg_pcopy_to_buffer(ctx->sgfirst, ctx->nents,
> +                                       ctx->buffer, bleft, ctx->sent);
> +               tbc = 0;
> +               ctx->sg = sg_next(ctx->sg);
> +               while (ctx->sg && (ctx->bufcnt < 4)) {
> +                       len = ctx->sg->length;
> +                       if (likely(len > (4 - ctx->bufcnt)))
> +                               len = 4 - ctx->bufcnt;
> +                       tbc = sg_pcopy_to_buffer(ctx->sgfirst, ctx->nents,
> +                                       ctx->buffer + ctx->bufcnt, len,
> +                                       ctx->sent + ctx->bufcnt);
> +                       ctx->bufcnt += tbc;
> +                       if (tbc >= ctx->sg->length) {
> +                               ctx->sg = sg_next(ctx->sg);
> +                               tbc = 0;
> +                       }
> +               }
> +
> +               ctx->sent += ctx->bufcnt;
> +               ctx->offset = tbc;
> +
> +               if (!bsend)
> +                       img_hash_dma_callback(hdev);

The chunk above deserves a comment.  It's really not obvious as to
what's going on here or why it's necessary.  It looks like it's meant
to deal with extra bytes if the size is not a multiple of 4, but I'm
not sure why we can't just DMA those bytes as well - it's not like
we're capable of transmitting less than 32-bits with xmit_cpu either.

> +       } else {
> +               ctx->offset = 0;
> +               ctx->sg = sg_next(ctx->sg);
> +
> +       }
> +}

The placement of the above 4 functions is strange.  I would expect to
see them near their non-DMA counterparts.

> +static int img_hash_dma_init(struct img_hash_dev *hdev)
> +{
> +       int err = -EINVAL;
> +
> +       hdev->dma_lch = dma_request_slave_channel(hdev->dev, "tx");
> +       if (!hdev->dma_lch) {
> +               dev_err(hdev->dev, "Couldn't aquire a slave DMA channel.\n");
> +               return -EBUSY;
> +       }
> +       hdev->dma_conf.direction = DMA_MEM_TO_DEV;
> +       hdev->dma_conf.dst_addr = hdev->bus_addr;
> +       hdev->dma_conf.dst_addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
> +       hdev->dma_conf.dst_maxburst = 16;
> +       hdev->dma_conf.device_fc = false;
> +
> +       err = dmaengine_slave_config(hdev->dma_lch,  &hdev->dma_conf);
> +       if (err) {
> +               dev_err(hdev->dev, "Couldn't configure DMA slave.\n");
> +               return err;
> +       }
> +       return 0;
> +}
> +
> +static const struct of_device_id img_hash_match[] = {
> +       { .compatible = "img,img-hash-accelerator-rev1" },
> +       {}
> +};
> +MODULE_DEVICE_TABLE(of, img_hash_match)
> +
> +static int img_hash_probe(struct platform_device *pdev)
> +{
> +       struct img_hash_dev *hdev;
> +       struct device *dev = &pdev->dev;
> +       struct resource *hash_res;
> +       int err;
> +
> +       hdev = devm_kzalloc(dev, sizeof(*hdev), GFP_KERNEL);
> +       if (hdev == NULL) {
> +               err = -ENOMEM;
> +               goto sha_dev_err;

You can probably just return here.  The driver core will print an
error whenever a probe() fails.

> +       }
> +       spin_lock_init(&hdev->lock);
> +
> +       hdev->dev = dev;
> +
> +       platform_set_drvdata(pdev, hdev);
> +
> +       INIT_LIST_HEAD(&hdev->list);
> +
> +       tasklet_init(&hdev->done_task, img_hash_done_task,
> +               (unsigned long) hdev);
> +       tasklet_init(&hdev->dma_task, img_hash_dma_task,
> +               (unsigned long) hdev);
> +
> +       crypto_init_queue(&hdev->queue, IMG_HASH_QUEUE_LENGTH);
> +
> +       hash_res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +       if (!hash_res) {
> +               dev_err(dev, "no MEM resource info\n");
> +               err = -ENODEV;
> +               goto res_err;
> +       }

No need for the error check here.  devm_ioremap_resource() will handle
a NULL resource.

> +       hdev->io_base = devm_ioremap_resource(dev, hash_res);
> +       if (!hdev->io_base) {

devm_ioremap_resource() returns an ERR_PTR() on error, not NULL.

> +               dev_err(dev, "can't ioremap\n");
> +               err = -ENOMEM;
> +               goto hash_io_err;
> +       }
> +
> +       hash_res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
> +       if (!hash_res) {
> +               dev_err(dev, "no MEM resource info\n");
> +               err = -ENODEV;
> +               goto res_err;
> +       }
> +       hdev->bus_addr = hash_res->start;
> +       hdev->cpu_addr = devm_ioremap_resource(dev, hash_res);

Need to check return value.

> +       hdev->irq = platform_get_irq(pdev, 0);
> +       if (hdev->irq < 0) {
> +               dev_err(dev, "no IRQ resource info\n");
> +               err = hdev->irq;
> +               goto res_err;
> +       }
> +
> +       err = devm_request_irq(dev, hdev->irq, img_irq_handler, 0,
> +                       "img-hash-accelerator-rev1", hdev);

You could use dev_name(dev).

> +       if (err) {
> +               dev_err(dev, "unable to request img-hash-accelerator irq\n");
> +               goto res_err;
> +       }
> +       dev_info(dev, "using IRQ channel %d\n", hdev->irq);

dev_info() is a bit much.  Maybe just remove it or make it dev_dbg().

> +
> +       hdev->iclk = devm_clk_get(&pdev->dev, "hash_clk");
> +       if (IS_ERR(hdev->iclk)) {
> +               dev_err(dev, "clock initialization failed.\n");
> +               err = PTR_ERR(hdev->iclk);
> +               goto clk_err;
> +       }
> +
> +       err = img_hash_dma_init(hdev);
> +       if (err)
> +               goto err_dma;
> +
> +       dev_info(dev, "using %s for DMA transfers\n",
> +                       dma_chan_name(hdev->dma_lch));

Ditto.

> +
> +       spin_lock(&img_hash.lock);
> +       list_add_tail(&hdev->list, &img_hash.dev_list);
> +       spin_unlock(&img_hash.lock);
> +
> +       err = img_register_algs(hdev);
> +       if (err)
> +               goto err_algs;
> +       dev_info(dev, "data bus: 0x%x;\tsize:0x%x\n", hdev->bus_addr, 0x4);
> +       dev_info(dev, "Img MD5/SHA1/SHA224/SHA256 Hardware accelerator initialized\n");
> +
> +       return 0;
> +
> +err_algs:
> +       spin_lock(&img_hash.lock);
> +       list_del(&hdev->list);
> +       spin_unlock(&img_hash.lock);
> +       dma_release_channel(hdev->dma_lch);
> +err_dma:
> +       iounmap(hdev->io_base);

I think Vladimir mentioned this, but resources allocated with the
devres API usually do not need to be explicitly freed, and if they do,
they should be done with the corresponding devm_* free function.

> +hash_io_err:
> +       clk_put(hdev->iclk);
> +clk_err:
> +res_err:
> +       tasklet_kill(&hdev->done_task);
> +sha_dev_err:
> +       dev_err(dev, "initialization failed.\n");
> +       return err;
> +}
> +
> +static void img_hash_dma_cleanup(struct img_hash_dev *hdev)
> +{
> +       dma_release_channel(hdev->dma_lch);
> +}
> +
> +static int img_hash_remove(struct platform_device *pdev)
> +{
> +       static struct img_hash_dev *hdev;
> +
> +       hdev = platform_get_drvdata(pdev);
> +       if (!hdev)
> +               return -ENODEV;

This shouldn't be possible.

> +       spin_lock(&img_hash.lock);
> +       list_del(&hdev->list);
> +       spin_unlock(&img_hash.lock);
> +
> +       img_unregister_algs(hdev);
> +
> +       tasklet_kill(&hdev->done_task);
> +       tasklet_kill(&hdev->dma_task);
> +       img_hash_dma_cleanup(hdev);
> +
> +       iounmap(hdev->io_base);
> +       return 0;
> +}
> +
> +static struct platform_driver img_hash_driver = {
> +       .probe          = img_hash_probe,
> +       .remove         = img_hash_remove,
> +       .driver         = {
> +               .name   = "img-hash-accelerator-rev1",
> +               .of_match_table = of_match_ptr(img_hash_match),
> +       }
> +};
> +module_platform_driver(img_hash_driver);
> +
> +MODULE_LICENSE("GPL v2");
> +MODULE_DESCRIPTION("Imgtec SHA1/224/256 & MD5 hw accelerator driver");
> +MODULE_AUTHOR("Will Thomas.");
> +

Extra newline.
