Return-Path: <SRS0=1Gsi=PR=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-it1-f196.google.com ([209.85.166.196]:52330 "EHLO
        mail-it1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727387AbfAIFgG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 9 Jan 2019 00:36:06 -0500
Received: by mail-it1-f196.google.com with SMTP id g76so9961068itg.2
        for <linux-crypto@vger.kernel.org>; Tue, 08 Jan 2019 21:36:05 -0800 (PST)
MIME-Version: 1.0
References: <1545968644-191671-1-git-send-email-yuehaibing@huawei.com>
In-Reply-To: <1545968644-191671-1-git-send-email-yuehaibing@huawei.com>
From: Raveendra Padasalagi <raveendra.padasalagi@broadcom.com>
Date: Wed, 9 Jan 2019 11:05:54 +0530
Message-ID: <CAAFb_vocPLiiPeV210Y-CMj7cVdfQx4OvDzaygkihzJzXhj2NA@mail.gmail.com>
Subject: Re: [PATCH -next] crypto: brcm - Fix some set-but-not-used warning
To: YueHaibing <yuehaibing@huawei.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@google.com>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Stefan Agner <stefan@agner.ch>, linux-crypto@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi YueHaibing,

Please add below fixes tag in the commit message,
Fixes: 9d12ba86f818 ("crypto: brcm - Add Broadcom SPU driver")

Otherwise patch looks good to me.

-Raveendra

On Fri, Dec 28, 2018 at 9:07 AM YueHaibing <yuehaibing@huawei.com> wrote:
>
> Fixes gcc '-Wunused-but-set-variable' warning:
>
> drivers/crypto/bcm/cipher.c: In function 'handle_ahash_req':
> drivers/crypto/bcm/cipher.c:720:15: warning:
>  variable 'chunk_start' set but not used [-Wunused-but-set-variable]
>
> drivers/crypto/bcm/cipher.c: In function 'spu_rx_callback':
> drivers/crypto/bcm/cipher.c:1679:31: warning:
>  variable 'areq' set but not used [-Wunused-but-set-variable]
>
> drivers/crypto/bcm/cipher.c:1678:22: warning:
>  variable 'ctx' set but not used [-Wunused-but-set-variable]
>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>  drivers/crypto/bcm/cipher.c | 6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
>
> diff --git a/drivers/crypto/bcm/cipher.c b/drivers/crypto/bcm/cipher.c
> index c9393ff..9a66c29 100644
> --- a/drivers/crypto/bcm/cipher.c
> +++ b/drivers/crypto/bcm/cipher.c
> @@ -717,7 +717,7 @@ static int handle_ahash_req(struct iproc_reqctx_s *rctx)
>          */
>         unsigned int new_data_len;
>
> -       unsigned int chunk_start = 0;
> +       unsigned int __maybe_unused chunk_start = 0;
>         u32 db_size;     /* Length of data field, incl gcm and hash padding */
>         int pad_len = 0; /* total pad len, including gcm, hash, stat padding */
>         u32 data_pad_len = 0;   /* length of GCM/CCM padding */
> @@ -1675,8 +1675,6 @@ static void spu_rx_callback(struct mbox_client *cl, void *msg)
>         struct spu_hw *spu = &iproc_priv.spu;
>         struct brcm_message *mssg = msg;
>         struct iproc_reqctx_s *rctx;
> -       struct iproc_ctx_s *ctx;
> -       struct crypto_async_request *areq;
>         int err = 0;
>
>         rctx = mssg->ctx;
> @@ -1686,8 +1684,6 @@ static void spu_rx_callback(struct mbox_client *cl, void *msg)
>                 err = -EFAULT;
>                 goto cb_finish;
>         }
> -       areq = rctx->parent;
> -       ctx = rctx->ctx;
>
>         /* process the SPU status */
>         err = spu->spu_status_process(rctx->msg_buf.rx_stat);
>
>
>
>
>
