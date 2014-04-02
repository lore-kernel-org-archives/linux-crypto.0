From: Sonic Zhang <sonic.adi@gmail.com>
Subject: Re: [PATCH] crypt: bfin_crc: access crc registers by ioread32 and
 iowrite32 functions
Date: Wed, 2 Apr 2014 12:57:17 +0800
Message-ID: <CAJxxZ0PpNzh-QsRqWpg_3rys8w3=7iaU5W_Ckw=DAcMK_j14yA@mail.gmail.com>
References: <1395910353-2853-1-git-send-email-sonic.adi@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-crypto@vger.kernel.org,
	adi-buildroot-devel@lists.sourceforge.net,
	Sonic Zhang <sonic.zhang@analog.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ob0-f179.google.com ([209.85.214.179]:49666 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754937AbaDBE5R (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 2 Apr 2014 00:57:17 -0400
Received: by mail-ob0-f179.google.com with SMTP id va2so12197061obc.24
        for <linux-crypto@vger.kernel.org>; Tue, 01 Apr 2014 21:57:17 -0700 (PDT)
In-Reply-To: <1395910353-2853-1-git-send-email-sonic.adi@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Ping

On Thu, Mar 27, 2014 at 4:52 PM, Sonic Zhang <sonic.adi@gmail.com> wrote:
> From: Sonic Zhang <sonic.zhang@analog.com>
>
> Move architecture independant crc header file out of the blackfin folder.
>
> Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
> ---
>  drivers/crypto/bfin_crc.c                          | 38 ++++++++++++----------
>  .../include/asm => drivers/crypto}/bfin_crc.h      |  0
>  2 files changed, 21 insertions(+), 17 deletions(-)
>  rename {arch/blackfin/include/asm => drivers/crypto}/bfin_crc.h (100%)
>
> diff --git a/drivers/crypto/bfin_crc.c b/drivers/crypto/bfin_crc.c
> index c9ff298..d4f731d 100644
> --- a/drivers/crypto/bfin_crc.c
> +++ b/drivers/crypto/bfin_crc.c
> @@ -30,9 +30,11 @@
>  #include <crypto/internal/hash.h>
>
>  #include <asm/blackfin.h>
> -#include <asm/bfin_crc.h>
>  #include <asm/dma.h>
>  #include <asm/portmux.h>
> +#include <asm/io.h>
> +
> +#include "bfin_crc.h"
>
>  #define CRC_CCRYPTO_QUEUE_LENGTH       5
>
> @@ -54,7 +56,7 @@ struct bfin_crypto_crc {
>         int                     irq;
>         int                     dma_ch;
>         u32                     poly;
> -       volatile struct crc_register *regs;
> +       struct crc_register     *regs;
>
>         struct ahash_request    *req; /* current request in operation */
>         struct dma_desc_array   *sg_cpu; /* virt addr of sg dma descriptors */
> @@ -132,13 +134,13 @@ static struct scatterlist *sg_get(struct scatterlist *sg_list, unsigned int nent
>
>  static int bfin_crypto_crc_init_hw(struct bfin_crypto_crc *crc, u32 key)
>  {
> -       crc->regs->datacntrld = 0;
> -       crc->regs->control = MODE_CALC_CRC << OPMODE_OFFSET;
> -       crc->regs->curresult = key;
> +       iowrite32(0, &crc->regs->datacntrld);
> +       iowrite32(MODE_CALC_CRC << OPMODE_OFFSET, &crc->regs->control);
> +       iowrite32(key, &crc->regs->curresult);
>
>         /* setup CRC interrupts */
> -       crc->regs->status = CMPERRI | DCNTEXPI;
> -       crc->regs->intrenset = CMPERRI | DCNTEXPI;
> +       iowrite32(CMPERRI | DCNTEXPI, &crc->regs->status);
> +       iowrite32(CMPERRI | DCNTEXPI, &crc->regs->intrenset);
>
>         return 0;
>  }
> @@ -402,13 +404,13 @@ finish_update:
>                 ctx->sg_buflen += CHKSUM_DIGEST_SIZE;
>
>         /* set CRC data count before start DMA */
> -       crc->regs->datacnt = ctx->sg_buflen >> 2;
> +       iowrite32(ctx->sg_buflen >> 2, &crc->regs->datacnt);
>
>         /* setup and enable CRC DMA */
>         bfin_crypto_crc_config_dma(crc);
>
>         /* finally kick off CRC operation */
> -       crc->regs->control |= BLKEN;
> +       iowrite32(ioread32(&crc->regs->control) | BLKEN, &crc->regs->control);
>
>         return -EINPROGRESS;
>  }
> @@ -530,13 +532,14 @@ static irqreturn_t bfin_crypto_crc_handler(int irq, void *dev_id)
>  {
>         struct bfin_crypto_crc *crc = dev_id;
>
> -       if (crc->regs->status & DCNTEXP) {
> -               crc->regs->status = DCNTEXP;
> +       if (ioread32(&crc->regs->status) & DCNTEXP) {
> +               iowrite32(DCNTEXP, &crc->regs->status);
>
>                 /* prepare results */
> -               put_unaligned_le32(crc->regs->result, crc->req->result);
> +               put_unaligned_le32(ioread32(&crc->regs->result),
> +                       crc->req->result);
>
> -               crc->regs->control &= ~BLKEN;
> +               iowrite32(ioread32(&crc->regs->control) & ~BLKEN, &crc->regs->control);
>                 crc->busy = 0;
>
>                 if (crc->req->base.complete)
> @@ -560,7 +563,7 @@ static int bfin_crypto_crc_suspend(struct platform_device *pdev, pm_message_t st
>         struct bfin_crypto_crc *crc = platform_get_drvdata(pdev);
>         int i = 100000;
>
> -       while ((crc->regs->control & BLKEN) && --i)
> +       while ((ioread32(&crc->regs->control) & BLKEN) && --i)
>                 cpu_relax();
>
>         if (i == 0)
> @@ -648,10 +651,11 @@ static int bfin_crypto_crc_probe(struct platform_device *pdev)
>          */
>         crc->sg_mid_buf = (u8 *)(crc->sg_cpu + ((CRC_MAX_DMA_DESC + 1) << 1));
>
> -       crc->regs->control = 0;
> -       crc->regs->poly = crc->poly = (u32)pdev->dev.platform_data;
> +       iowrite32(0, &crc->regs->control);
> +       crc->poly = (u32)pdev->dev.platform_data;
> +       iowrite32(crc->poly, &crc->regs->poly);
>
> -       while (!(crc->regs->status & LUTDONE) && (--timeout) > 0)
> +       while (!(ioread32(&crc->regs->status) & LUTDONE) && (--timeout) > 0)
>                 cpu_relax();
>
>         if (timeout == 0)
> diff --git a/arch/blackfin/include/asm/bfin_crc.h b/drivers/crypto/bfin_crc.h
> similarity index 100%
> rename from arch/blackfin/include/asm/bfin_crc.h
> rename to drivers/crypto/bfin_crc.h
> --
> 1.8.2.3
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
