From: Tudor Ambarus <tudor.ambarus@microchip.com>
Subject: Re: Kernel panic when using ccm(aes) with the Atmel AES HW
 accelerator
Date: Thu, 26 Oct 2017 15:34:56 +0300
Message-ID: <4e822b84-2d5a-1b9d-a36b-faf04fcbfcf8@microchip.com>
References: <CAGkQfmP6Kq4DEBbGU7AW71PjbUJ2acdJF5PVDm6VqZkUaaoEzA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: <linux-crypto@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Cyrille Pitchen <cyrille.pitchen@atmel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Nicolas Ferre <nicolas.ferre@microchip.com>
To: Romain Izard <romain.izard.pro@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:49823 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932185AbdJZMe5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 26 Oct 2017 08:34:57 -0400
In-Reply-To: <CAGkQfmP6Kq4DEBbGU7AW71PjbUJ2acdJF5PVDm6VqZkUaaoEzA@mail.gmail.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi, Romain,

On 10/18/2017 04:32 PM, Romain Izard wrote:
> diff --git a/drivers/crypto/atmel-aes.c b/drivers/crypto/atmel-aes.c
> index 29e20c37f3a6..f3eabe1f1490 100644
> --- a/drivers/crypto/atmel-aes.c
> +++ b/drivers/crypto/atmel-aes.c
> @@ -80,6 +80,7 @@
>   #define AES_FLAGS_BUSY         BIT(3)
>   #define AES_FLAGS_DUMP_REG     BIT(4)
>   #define AES_FLAGS_OWN_SHA      BIT(5)
> +#define AES_FLAGS_CIPHERTAIL   BIT(6)

not really needed, see below.

> 
>   #define AES_FLAGS_PERSISTENT   (AES_FLAGS_INIT | AES_FLAGS_BUSY)
> 
> @@ -156,6 +157,7 @@ struct atmel_aes_authenc_ctx {
> 
>   struct atmel_aes_reqctx {
>          unsigned long           mode;
> +       u32                     ciphertail[AES_BLOCK_SIZE / sizeof(u32)];
How about renaming this variable to "lastc"? Ci, i=1..n is the usual
notation for the ciphertext blocks.

The assumption that the last ciphertext block is of AES_BLOCK_SIZE size
is correct, this driver is meant just for AES.

>   };
> 
>   #ifdef CONFIG_CRYPTO_DEV_ATMEL_AUTHENC
> @@ -496,6 +498,11 @@ static void atmel_aes_authenc_complete(struct
> atmel_aes_dev *dd, int err);
> 
>   static inline int atmel_aes_complete(struct atmel_aes_dev *dd, int err)
>   {
> +       struct ablkcipher_request *req = ablkcipher_request_cast(dd->areq);
> +       struct crypto_ablkcipher *ablkcipher = crypto_ablkcipher_reqtfm(req);
> +       struct atmel_aes_reqctx *rctx = ablkcipher_request_ctx(req);
> +       int ivsize = crypto_ablkcipher_ivsize(ablkcipher);
> +
>   #ifdef CONFIG_CRYPTO_DEV_ATMEL_AUTHENC
>          atmel_aes_authenc_complete(dd, err);
>   #endif
> @@ -503,6 +510,17 @@ static inline int atmel_aes_complete(struct
> atmel_aes_dev *dd, int err)
>          clk_disable(dd->iclk);
>          dd->flags &= ~AES_FLAGS_BUSY;
> 
> +       if (rctx->mode & AES_FLAGS_CIPHERTAIL) {
> +               if (rctx->mode & AES_FLAGS_ENCRYPT) {
> +                       scatterwalk_map_and_copy(req->info, req->dst,
> +                                                req->nbytes - ivsize,
> +                                                ivsize, 0);
> +               } else {
> +                       memcpy(req->info, rctx->ciphertail, ivsize);

why don't we make the same assumption and replace ivsize with
AES_BLOCK_SIZE? Is there any chance that req->info was allocated with
less than AES_BLOCK_SIZE size?

> +                       memset(rctx->ciphertail, 0, ivsize);

memset to zero is not necessary.

> +               }
> +       }
> +
>          if (dd->is_async)
>                  dd->areq->complete(dd->areq, err);
> 
> @@ -1071,11 +1089,13 @@ static int atmel_aes_ctr_start(struct atmel_aes_dev *dd)
> 
>   static int atmel_aes_crypt(struct ablkcipher_request *req, unsigned long mode)
>   {
> +       struct crypto_ablkcipher *ablkcipher;
>          struct atmel_aes_base_ctx *ctx;
>          struct atmel_aes_reqctx *rctx;
>          struct atmel_aes_dev *dd;
> 
> -       ctx = crypto_ablkcipher_ctx(crypto_ablkcipher_reqtfm(req));
> +       ablkcipher = crypto_ablkcipher_reqtfm(req);
> +       ctx = crypto_ablkcipher_ctx(ablkcipher);

you can initialize these variables at declaration.

>          switch (mode & AES_FLAGS_OPMODE_MASK) {
>          case AES_FLAGS_CFB8:
>                  ctx->block_size = CFB8_BLOCK_SIZE;
> @@ -1103,7 +1123,15 @@ static int atmel_aes_crypt(struct
> ablkcipher_request *req, unsigned long mode)
>                  return -ENODEV;
> 
>          rctx = ablkcipher_request_ctx(req);

while here, please initialize this at declaration.

Also, this one:
'''
         dd = atmel_aes_find_dev(ctx);
         if (!dd)
                 return -ENODEV;

'''
should be moved at the beginning of the function. If an initialization
might fail, let's check it as soon as we can, so that we don't waste
resources.

> -       rctx->mode = mode;
> +
> +       if (!(mode & AES_FLAGS_ENCRYPT)) {
> +               int ivsize = crypto_ablkcipher_ivsize(ablkcipher);
> +
> +               scatterwalk_map_and_copy(rctx->ciphertail, req->src,
> +                               (req->nbytes - ivsize), ivsize, 0);
> +       }
> +       rctx->mode = mode | AES_FLAGS_CIPHERTAIL;

saving the last ciphertext block is a requirement for skcipher. This
flag is redundant, there's no need to use it.

Thank you, Romain!
ta
