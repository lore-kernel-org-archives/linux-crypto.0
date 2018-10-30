Return-Path: <SRS0=rgpc=NK=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-eopbgr730061.outbound.protection.outlook.com ([40.107.73.61]:59392
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727719AbeJ3Uu3 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 Oct 2018 16:50:29 -0400
From: "Srikanth, Jampala" <Jampala.Srikanth@cavium.com>
To: Wenwen Wang <wang6495@umn.edu>
CC: Kangjie Lu <kjlu@umn.edu>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "kstewart@linuxfoundation.org" <kstewart@linuxfoundation.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "pombredanne@nexb.com" <pombredanne@nexb.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "baijiaju1990@gmail.com" <baijiaju1990@gmail.com>,
        "Gadam, Sreerama" <Sreerama.Gadam@cavium.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crypto: cavium/nitrox - fix a DMA pool free failure
Date: Tue, 30 Oct 2018 11:56:23 +0000
Message-ID: <BYAPR07MB46140E96ED4162B33655480BF4CC0@BYAPR07MB4614.namprd07.prod.outlook.com>
References: <1539910247-9250-1-git-send-email-wang6495@umn.edu>,<CAAa=b7eOM+NPNxaanw-mK-i05UfQ7uhCsN2ViiSoe0_YB-ppyA@mail.gmail.com>
In-Reply-To: <CAAa=b7eOM+NPNxaanw-mK-i05UfQ7uhCsN2ViiSoe0_YB-ppyA@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Wenwen,

Thanks for the patch. We can't think of any such scenarios,=20
 where our device can corrupt meta data of the given context pointer as per=
 our usage in the device.=20
But having meta data in separate pointer prevents unexpected behavior.=20

Thanks
srikanth

________________________________________
From: linux-crypto-owner@vger.kernel.org <linux-crypto-owner@vger.kernel.or=
g> on behalf of Wenwen Wang <wang6495@umn.edu>
Sent: Tuesday, October 30, 2018 12:07 AM
To: Wenwen Wang
Cc: Kangjie Lu; herbert@gondor.apana.org.au; David S. Miller; kstewart@linu=
xfoundation.org; tglx@linutronix.de; pombredanne@nexb.com; Greg Kroah-Hartm=
an; baijiaju1990@gmail.com; Srikanth, Jampala; Gadam, Sreerama; linux-crypt=
o@vger.kernel.org; open list
Subject: Re: [PATCH] crypto: cavium/nitrox - fix a DMA pool free failure

External Email

Hello,

Can anyone confirm this bug? Thanks!

Wenwen

On Thu, Oct 18, 2018 at 7:51 PM Wenwen Wang <wang6495@umn.edu> wrote:
>
> In crypto_alloc_context(), a DMA pool is allocated through dma_pool_alloc=
()
> to hold the crypto context. The meta data of the DMA pool, including the
> pool used for the allocation 'ndev->ctx_pool' and the base address of the
> DMA pool used by the device 'dma', are then stored to the beginning of th=
e
> pool. These meta data are eventually used in crypto_free_context() to fre=
e
> the DMA pool through dma_pool_free(). However, given that the DMA pool ca=
n
> also be accessed by the device, a malicious device can modify these meta
> data, especially when the device is controlled to deploy an attack. This
> can cause an unexpected DMA pool free failure.
>
> To avoid the above issue, this patch introduces a new structure
> crypto_ctx_hdr and a new field chdr in the structure nitrox_crypto_ctx ho=
ld
> the meta data information of the DMA pool after the allocation. Note that
> the original structure ctx_hdr is not changed to ensure the compatibility=
.
>
> Signed-off-by: Wenwen Wang <wang6495@umn.edu>
> ---
>  drivers/crypto/cavium/nitrox/nitrox_algs.c | 12 +++++++-----
>  drivers/crypto/cavium/nitrox/nitrox_lib.c  | 22 +++++++++++++++++-----
>  drivers/crypto/cavium/nitrox/nitrox_req.h  |  7 +++++++
>  3 files changed, 31 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/crypto/cavium/nitrox/nitrox_algs.c b/drivers/crypto/=
cavium/nitrox/nitrox_algs.c
> index 2ae6124..5d54ebc 100644
> --- a/drivers/crypto/cavium/nitrox/nitrox_algs.c
> +++ b/drivers/crypto/cavium/nitrox/nitrox_algs.c
> @@ -73,7 +73,7 @@ static int flexi_aes_keylen(int keylen)
>  static int nitrox_skcipher_init(struct crypto_skcipher *tfm)
>  {
>         struct nitrox_crypto_ctx *nctx =3D crypto_skcipher_ctx(tfm);
> -       void *fctx;
> +       struct crypto_ctx_hdr *chdr;
>
>         /* get the first device */
>         nctx->ndev =3D nitrox_get_first_device();
> @@ -81,12 +81,14 @@ static int nitrox_skcipher_init(struct crypto_skciphe=
r *tfm)
>                 return -ENODEV;
>
>         /* allocate nitrox crypto context */
> -       fctx =3D crypto_alloc_context(nctx->ndev);
> -       if (!fctx) {
> +       chdr =3D crypto_alloc_context(nctx->ndev);
> +       if (!chdr) {
>                 nitrox_put_device(nctx->ndev);
>                 return -ENOMEM;
>         }
> -       nctx->u.ctx_handle =3D (uintptr_t)fctx;
> +       nctx->chdr =3D chdr;
> +       nctx->u.ctx_handle =3D (uintptr_t)((u8 *)chdr->vaddr +
> +                                        sizeof(struct ctx_hdr));
>         crypto_skcipher_set_reqsize(tfm, crypto_skcipher_reqsize(tfm) +
>                                     sizeof(struct nitrox_kcrypt_request))=
;
>         return 0;
> @@ -102,7 +104,7 @@ static void nitrox_skcipher_exit(struct crypto_skciph=
er *tfm)
>
>                 memset(&fctx->crypto, 0, sizeof(struct crypto_keys));
>                 memset(&fctx->auth, 0, sizeof(struct auth_keys));
> -               crypto_free_context((void *)fctx);
> +               crypto_free_context((void *)nctx->chdr);
>         }
>         nitrox_put_device(nctx->ndev);
>
> diff --git a/drivers/crypto/cavium/nitrox/nitrox_lib.c b/drivers/crypto/c=
avium/nitrox/nitrox_lib.c
> index 4d31df0..28baf1a 100644
> --- a/drivers/crypto/cavium/nitrox/nitrox_lib.c
> +++ b/drivers/crypto/cavium/nitrox/nitrox_lib.c
> @@ -146,12 +146,19 @@ static void destroy_crypto_dma_pool(struct nitrox_d=
evice *ndev)
>  void *crypto_alloc_context(struct nitrox_device *ndev)
>  {
>         struct ctx_hdr *ctx;
> +       struct crypto_ctx_hdr *chdr;
>         void *vaddr;
>         dma_addr_t dma;
>
> +       chdr =3D kmalloc(sizeof(*chdr), GFP_KERNEL);
> +       if (!chdr)
> +               return NULL;
> +
>         vaddr =3D dma_pool_alloc(ndev->ctx_pool, (GFP_KERNEL | __GFP_ZERO=
), &dma);
> -       if (!vaddr)
> +       if (!vaddr) {
> +               kfree(chdr);
>                 return NULL;
> +       }
>
>         /* fill meta data */
>         ctx =3D vaddr;
> @@ -159,7 +166,11 @@ void *crypto_alloc_context(struct nitrox_device *nde=
v)
>         ctx->dma =3D dma;
>         ctx->ctx_dma =3D dma + sizeof(struct ctx_hdr);
>
> -       return ((u8 *)vaddr + sizeof(struct ctx_hdr));
> +       chdr->pool =3D ndev->ctx_pool;
> +       chdr->dma =3D dma;
> +       chdr->vaddr =3D vaddr;
> +
> +       return chdr;
>  }
>
>  /**
> @@ -168,13 +179,14 @@ void *crypto_alloc_context(struct nitrox_device *nd=
ev)
>   */
>  void crypto_free_context(void *ctx)
>  {
> -       struct ctx_hdr *ctxp;
> +       struct crypto_ctx_hdr *ctxp;
>
>         if (!ctx)
>                 return;
>
> -       ctxp =3D (struct ctx_hdr *)((u8 *)ctx - sizeof(struct ctx_hdr));
> -       dma_pool_free(ctxp->pool, ctxp, ctxp->dma);
> +       ctxp =3D ctx;
> +       dma_pool_free(ctxp->pool, ctxp->vaddr, ctxp->dma);
> +       kfree(ctxp);
>  }
>
>  /**
> diff --git a/drivers/crypto/cavium/nitrox/nitrox_req.h b/drivers/crypto/c=
avium/nitrox/nitrox_req.h
> index d091b6f..19f0a20 100644
> --- a/drivers/crypto/cavium/nitrox/nitrox_req.h
> +++ b/drivers/crypto/cavium/nitrox/nitrox_req.h
> @@ -181,12 +181,19 @@ struct flexi_crypto_context {
>         struct auth_keys auth;
>  };
>
> +struct crypto_ctx_hdr {
> +       struct dma_pool *pool;
> +       dma_addr_t dma;
> +       void *vaddr;
> +};
> +
>  struct nitrox_crypto_ctx {
>         struct nitrox_device *ndev;
>         union {
>                 u64 ctx_handle;
>                 struct flexi_crypto_context *fctx;
>         } u;
> +       struct crypto_ctx_hdr *chdr;
>  };
>
>  struct nitrox_kcrypt_request {
> --
> 2.7.4
>
