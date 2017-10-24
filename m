From: Tudor Ambarus <tudor.ambarus@microchip.com>
Subject: Re: Kernel panic when using ccm(aes) with the Atmel AES HW
 accelerator
Date: Tue, 24 Oct 2017 18:25:08 +0300
Message-ID: <16357069-115f-ba62-d32b-baaed3aa6dfd@microchip.com>
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
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:5793 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932210AbdJXPZK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 24 Oct 2017 11:25:10 -0400
In-Reply-To: <CAGkQfmP6Kq4DEBbGU7AW71PjbUJ2acdJF5PVDm6VqZkUaaoEzA@mail.gmail.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi, Romain,

On 10/18/2017 04:32 PM, Romain Izard wrote:
> diff --git a/crypto/ccm.c b/crypto/ccm.c
> index 1ce37ae0ce56..e7c2121a3ab2 100644
> --- a/crypto/ccm.c
> +++ b/crypto/ccm.c
> @@ -47,6 +47,7 @@ struct crypto_ccm_req_priv_ctx {
>          u8 odata[16];
>          u8 idata[16];
>          u8 auth_tag[16];
> +       u8 iv[16];
>          u32 flags;
>          struct scatterlist src[3];
>          struct scatterlist dst[3];
> @@ -248,32 +249,22 @@ static void crypto_ccm_encrypt_done(struct
> crypto_async_request *areq, int err)
>          aead_request_complete(req, err);
>   }
> 
> -static inline int crypto_ccm_check_iv(const u8 *iv)
> -{
> -       /* 2 <= L <= 8, so 1 <= L' <= 7. */
> -       if (1 > iv[0] || iv[0] > 7)
> -               return -EINVAL;
> -
> -       return 0;
> -}
> -
> -static int crypto_ccm_init_crypt(struct aead_request *req, u8 *tag)
> +static int crypto_ccm_init_crypt(struct aead_request *req, u8 *tag, u8* iv)
>   {
>          struct crypto_ccm_req_priv_ctx *pctx = crypto_ccm_reqctx(req);
>          struct scatterlist *sg;
> -       u8 *iv = req->iv;
> -       int err;
> +       u8 L = req->iv[0] + 1;
> 
> -       err = crypto_ccm_check_iv(iv);
> -       if (err)
> -               return err;
> -
> -       pctx->flags = aead_request_flags(req);
> +       if (2 > L || L > 8)
> +               return -EINVAL;
> 
>           /* Note: rfc 3610 and NIST 800-38C require counter of
>           * zero to encrypt auth tag.
>           */
> -       memset(iv + 15 - iv[0], 0, iv[0] + 1);
> +       memcpy(iv, req->iv, 16 - L);
> +       memset(iv + 16 - L, 0, L);
> +
> +       pctx->flags = aead_request_flags(req);
> 
>          sg_init_table(pctx->src, 3);
>          sg_set_buf(pctx->src, tag, 16);
> @@ -301,10 +292,10 @@ static int crypto_ccm_encrypt(struct aead_request *req)
>          struct scatterlist *dst;
>          unsigned int cryptlen = req->cryptlen;
>          u8 *odata = pctx->odata;
> -       u8 *iv = req->iv;
> +       u8 *iv = pctx->iv;
>          int err;
> 
> -       err = crypto_ccm_init_crypt(req, odata);
> +       err = crypto_ccm_init_crypt(req, odata, iv);
>          if (err)
>                  return err;
> 
> @@ -363,12 +354,12 @@ static int crypto_ccm_decrypt(struct aead_request *req)
>          unsigned int cryptlen = req->cryptlen;
>          u8 *authtag = pctx->auth_tag;
>          u8 *odata = pctx->odata;
> -       u8 *iv = req->iv;
> +       u8 *iv = pctx->iv;
>          int err;
> 
>          cryptlen -= authsize;
> 
> -       err = crypto_ccm_init_crypt(req, authtag);
> +       err = crypto_ccm_init_crypt(req, authtag, iv);
>          if (err)
>                  return err;

Looks good. Can you please submit with a commit message?

Thanks,
ta
