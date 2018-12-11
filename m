Return-Path: <SRS0=eKEb=OU=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-pf1-f196.google.com ([209.85.210.196]:46785 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726158AbeLKXqJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 11 Dec 2018 18:46:09 -0500
Received: by mail-pf1-f196.google.com with SMTP id c73so7882802pfe.13
        for <linux-crypto@vger.kernel.org>; Tue, 11 Dec 2018 15:46:08 -0800 (PST)
MIME-Version: 1.0
References: <20181210234954.5862-1-natechancellor@gmail.com>
In-Reply-To: <20181210234954.5862-1-natechancellor@gmail.com>
From: Nick Desaulniers <ndesaulniers@google.com>
Date: Tue, 11 Dec 2018 15:45:56 -0800
Message-ID: <CAKwvOd=2ORedFQbBFE+pyhEb-XTu0BVLGWRxYN3dLi7gaSdz+w@mail.gmail.com>
Subject: Re: [PATCH] crypto: ux500 - Use proper enum in hash_set_dma_transfer
To: Nathan Chancellor <natechancellor@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Dec 10, 2018 at 3:50 PM Nathan Chancellor
<natechancellor@gmail.com> wrote:
>
> Clang warns when one enumerated type is implicitly converted to another:
>
> drivers/crypto/ux500/hash/hash_core.c:169:4: warning: implicit
> conversion from enumeration type 'enum dma_data_direction' to different
> enumeration type 'enum dma_transfer_direction' [-Wenum-conversion]
>                         direction, DMA_CTRL_ACK | DMA_PREP_INTERRUPT);
>                         ^~~~~~~~~
> 1 warning generated.
>
> dmaengine_prep_slave_sg expects an enum from dma_transfer_direction.
> We know that the only direction supported by this function is
> DMA_TO_DEVICE because of the check at the top of this function so we can
> just use the equivalent value from dma_transfer_direction.

That's correct. Thanks for fixing up yet another one of these enum
confusions. (I'm beginning to think we should change the values of the
enum members so that things break when aliased as such. Unfortunately,
that would result in runtime bugs rather than strong type system based
compile time checks; but this warning from Clang helps).
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>

>
> DMA_TO_DEVICE = DMA_MEM_TO_DEV = 1
>
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> ---
>  drivers/crypto/ux500/hash/hash_core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/crypto/ux500/hash/hash_core.c b/drivers/crypto/ux500/hash/hash_core.c
> index 633321a8dd03..a0bb8a6eec3f 100644
> --- a/drivers/crypto/ux500/hash/hash_core.c
> +++ b/drivers/crypto/ux500/hash/hash_core.c
> @@ -166,7 +166,7 @@ static int hash_set_dma_transfer(struct hash_ctx *ctx, struct scatterlist *sg,
>                 __func__);
>         desc = dmaengine_prep_slave_sg(channel,
>                         ctx->device->dma.sg, ctx->device->dma.sg_len,
> -                       direction, DMA_CTRL_ACK | DMA_PREP_INTERRUPT);
> +                       DMA_MEM_TO_DEV, DMA_CTRL_ACK | DMA_PREP_INTERRUPT);
>         if (!desc) {
>                 dev_err(ctx->device->dev,
>                         "%s: dmaengine_prep_slave_sg() failed!\n", __func__);
> --
> 2.20.0
>


-- 
Thanks,
~Nick Desaulniers
