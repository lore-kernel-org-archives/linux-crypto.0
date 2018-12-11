Return-Path: <SRS0=eKEb=OU=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-pl1-f194.google.com ([209.85.214.194]:45306 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726158AbeLKXkR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 11 Dec 2018 18:40:17 -0500
Received: by mail-pl1-f194.google.com with SMTP id a14so7655967plm.12
        for <linux-crypto@vger.kernel.org>; Tue, 11 Dec 2018 15:40:16 -0800 (PST)
MIME-Version: 1.0
References: <20181210234929.5729-1-natechancellor@gmail.com>
In-Reply-To: <20181210234929.5729-1-natechancellor@gmail.com>
From: Nick Desaulniers <ndesaulniers@google.com>
Date: Tue, 11 Dec 2018 15:40:04 -0800
Message-ID: <CAKwvOdkB0BViLgVyWBQZw4jZgFjp-3m2ndjiJmutsbevYjy7nA@mail.gmail.com>
Subject: Re: [PATCH] crypto: ux500 - Use proper enum in cryp_set_dma_transfer
To: Nathan Chancellor <natechancellor@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Dec 10, 2018 at 3:49 PM Nathan Chancellor
<natechancellor@gmail.com> wrote:
>
> Clang warns when one enumerated type is implicitly converted to another:
>
> drivers/crypto/ux500/cryp/cryp_core.c:559:5: warning: implicit
> conversion from enumeration type 'enum dma_data_direction' to different
> enumeration type 'enum dma_transfer_direction' [-Wenum-conversion]
>                                 direction, DMA_CTRL_ACK);
>                                 ^~~~~~~~~
> drivers/crypto/ux500/cryp/cryp_core.c:583:5: warning: implicit
> conversion from enumeration type 'enum dma_data_direction' to different
> enumeration type 'enum dma_transfer_direction' [-Wenum-conversion]
>                                 direction,
>                                 ^~~~~~~~~
> 2 warnings generated.
>
> dmaengine_prep_slave_sg expects an enum from dma_transfer_direction.
> Because we know the value of the dma_data_direction enum from the
> switch statement, we can just use the proper value from
> dma_transfer_direction so there is no more conversion.
>
> DMA_TO_DEVICE = DMA_MEM_TO_DEV = 1
> DMA_FROM_DEVICE = DMA_DEV_TO_MEM = 2
>
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>

Deja vu!
These particular enums get mixed up ALL THE TIME. Thanks for fixing
probably every instance of this bug (via patches before this one).
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>

> ---
>  drivers/crypto/ux500/cryp/cryp_core.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/crypto/ux500/cryp/cryp_core.c b/drivers/crypto/ux500/cryp/cryp_core.c
> index d2663a4e1f5e..a92a66b1ff46 100644
> --- a/drivers/crypto/ux500/cryp/cryp_core.c
> +++ b/drivers/crypto/ux500/cryp/cryp_core.c
> @@ -556,7 +556,7 @@ static int cryp_set_dma_transfer(struct cryp_ctx *ctx,
>                 desc = dmaengine_prep_slave_sg(channel,
>                                 ctx->device->dma.sg_src,
>                                 ctx->device->dma.sg_src_len,
> -                               direction, DMA_CTRL_ACK);
> +                               DMA_MEM_TO_DEV, DMA_CTRL_ACK);
>                 break;
>
>         case DMA_FROM_DEVICE:
> @@ -580,7 +580,7 @@ static int cryp_set_dma_transfer(struct cryp_ctx *ctx,
>                 desc = dmaengine_prep_slave_sg(channel,
>                                 ctx->device->dma.sg_dst,
>                                 ctx->device->dma.sg_dst_len,
> -                               direction,
> +                               DMA_DEV_TO_MEM,
>                                 DMA_CTRL_ACK |
>                                 DMA_PREP_INTERRUPT);
>
> --
> 2.20.0
>


-- 
Thanks,
~Nick Desaulniers
