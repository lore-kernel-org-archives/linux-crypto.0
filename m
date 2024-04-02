Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com [209.85.128.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C493417756
	for <linux-crypto@vger.kernel.org>; Tue,  2 Apr 2024 05:02:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712034173; cv=none; b=udlVeFZMSrqRJ7Xh0kxpiCGWSnz4r4UsSIV0HJCNRs4FpPE/mb3V5wlzV7fslmtLjroLi4ufjjKlFKWnAaXdCOGgVWJpQUwB6NY0njIDG6Upc4fiDHvpSrdz0e7PyVwVSXVuq4+zNzYDGIf98p7lIXCb52FsB2eFKi6WjQ9qr9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712034173; c=relaxed/simple;
	bh=N5594JZxh0hsgrzvXv1vKxNUlWMYC08R+Apy8FGtcI4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jY3VmPuXOqFRf79rZDkpM3yVau1r6+2U1onO/TXxokINRKJJKrUSm+z3y80kKOTmAqQGJENiyxRu7GY4vlF+Zgimudwiml7tPJ3mvY9klWN40PaMeKp19S09LmvcAbyNfMzDcDICmcm4TrPanhQ8xgUwWctuTMt0zTU8ghPT5YE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=Hw7+tMjg; arc=none smtp.client-ip=209.85.128.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="Hw7+tMjg"
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-6152be7c58bso1253477b3.0
        for <linux-crypto@vger.kernel.org>; Mon, 01 Apr 2024 22:02:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1712034171; x=1712638971; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DbuKTCjwajZhwESfMGZmK+kjEU4iQwxS1rsboAdDRQk=;
        b=Hw7+tMjgK6IROxJSvx95nhp6WLGq9MfQySkG/JhUh/27qgWw1FEU7j/FdhVXSrRnnO
         vPkcg3KNF8M4CSN/AkPL8OQjIiE0Hofqf2r64gHnsmIafpqR5uls9cK+LFYLgWcPoePJ
         mAk+kg39zwRn8dX0WPkvK52bj3uUsEQUTTFPk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712034171; x=1712638971;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DbuKTCjwajZhwESfMGZmK+kjEU4iQwxS1rsboAdDRQk=;
        b=Tlm8x2va06yFy6J+7K68qzJSF+4goL5iXDu+RCZTC6ioGTHObjJ1mwlxJpmO7gSQNv
         tVdN+Wblh1So/9bPc8NltLcXyh5Wsr+LsFiw4j6IvqW5oEjGhX99AZQcdo33HMmqWXl+
         MxtmBnPudGDImy5CY2RMW0PapI/H0LKW2gTtAu+DHjW5u/iJSWVAPVMiDHLOjZ58hHb1
         IrI0KoKsp6YG3II55ji0rF+0CiH3k9Avhxg0fIbuqzWChR0cVSDURGqCuyIZQs03Q3Dm
         P1G6fXWtHS873Bx8ThHiZ7DLF9S17Pj34NTDeCaeYQKJcRM7BUo1QvvaUzxhoVT6rBF+
         j1ZA==
X-Forwarded-Encrypted: i=1; AJvYcCUiS4orjXO1lfxw1i9Zg1hAsA+jQzpFbbNVLlPX/09LpIo89HelKPTjKwptOqZJQvzGrsKQ6vU9fQZVEWS43scSvoXswfSzQKyDPnpi
X-Gm-Message-State: AOJu0YzgXCx7jX3xu+m2npB00LWbqhCRmkJWFD+7pG4XwScZFk0VSLRN
	DCwSx50FYonOVeZqpQSwEKkLmrEOWxnh1uTGDOr9DH1ja7oUVUR5FPq4Ebu7YE3xHVJOgkqZn4m
	sHrr+4LWd1H95UawbZhcHS7b3Jn5/hu8sr4GWpw==
X-Google-Smtp-Source: AGHT+IEPYwxV2BhFPzHGM4NOaeLP9xfhMmk1ERe+NT9Ljlbi8YkDwIGKuLHY++qK2gh7wN3/D3+FR/+BlVOxTpWFIxw=
X-Received: by 2002:a0d:cad1:0:b0:615:2849:6086 with SMTP id
 m200-20020a0dcad1000000b0061528496086mr469191ywd.10.1712034170769; Mon, 01
 Apr 2024 22:02:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240328182652.3587727-1-pavitrakumarm@vayavyalabs.com>
 <20240328182652.3587727-2-pavitrakumarm@vayavyalabs.com> <6e486947-54cb-4ff5-bcf3-97e6ae106412@linux.microsoft.com>
 <CALxtO0=tvJh+h9W+1eN4xLQtwOugteABpA0QUTrgJ=f_dgeVoA@mail.gmail.com> <0ca1f15a-f883-407f-8837-c2a9891637f4@linux.microsoft.com>
In-Reply-To: <0ca1f15a-f883-407f-8837-c2a9891637f4@linux.microsoft.com>
From: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
Date: Tue, 2 Apr 2024 10:32:39 +0530
Message-ID: <CALxtO0mgfDfFEcCbihKFwyLVO+9OxPoyVdacJ41rHZH08jbiNA@mail.gmail.com>
Subject: Re: [PATCH v1 1/4] Add SPAcc driver to Linux kernel
To: Easwar Hariharan <eahariha@linux.microsoft.com>
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org, 
	Ruud.Derwig@synopsys.com, manjunath.hadli@vayavyalabs.com, 
	bhoomikak@vayavyalabs.com, shwetar <shwetar@vayavyalabs.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Sure Easwar,
   Thanks for the feedback. I will try to split the patches into
smaller, more manageable ones.

Warm regards,
PK

On Mon, Apr 1, 2024 at 10:04=E2=80=AFPM Easwar Hariharan
<eahariha@linux.microsoft.com> wrote:
>
> On 4/1/2024 12:21 AM, Pavitrakumar Managutte wrote:
> > Hi Easwar,
> >   My comments are embedded below. Also should I wait for more comments
> > from you or
> > should I go ahead and push v2 with the below fixes ?
> >
> > Warm regards,
> > PK
> >
>
> <snip>
>
> Please see more comments below, and go ahead and push a v2. If possible, =
split
> the series into more patches. I leave it to you to group them by file or =
logical
>  functionality, so long as each individual commit compiles neatly so as t=
o not break
> future git bisects.
>
>
> On 3/28/2024 11:26 AM, Pavitrakumar M wrote:
> > Signed-off-by: shwetar <shwetar@vayavyalabs.com>
> > Signed-off-by: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
> > Acked-by: Ruud Derwig <Ruud.Derwig@synopsys.com>
> > ---
> >  drivers/crypto/dwc-spacc/spacc_aead.c      | 1382 ++++++++++
> >  drivers/crypto/dwc-spacc/spacc_ahash.c     | 1183 ++++++++
> >  drivers/crypto/dwc-spacc/spacc_core.c      | 2917 ++++++++++++++++++++
> >  drivers/crypto/dwc-spacc/spacc_core.h      |  839 ++++++
> >  drivers/crypto/dwc-spacc/spacc_device.c    |  324 +++
> >  drivers/crypto/dwc-spacc/spacc_device.h    |  236 ++
> >  drivers/crypto/dwc-spacc/spacc_hal.c       |  365 +++
> >  drivers/crypto/dwc-spacc/spacc_hal.h       |  113 +
> >  drivers/crypto/dwc-spacc/spacc_interrupt.c |  204 ++
> >  drivers/crypto/dwc-spacc/spacc_manager.c   |  670 +++++
> >  drivers/crypto/dwc-spacc/spacc_skcipher.c  |  754 +++++
> >  11 files changed, 8987 insertions(+)
> >  create mode 100644 drivers/crypto/dwc-spacc/spacc_aead.c
> >  create mode 100644 drivers/crypto/dwc-spacc/spacc_ahash.c
> >  create mode 100644 drivers/crypto/dwc-spacc/spacc_core.c
> >  create mode 100644 drivers/crypto/dwc-spacc/spacc_core.h
> >  create mode 100644 drivers/crypto/dwc-spacc/spacc_device.c
> >  create mode 100644 drivers/crypto/dwc-spacc/spacc_device.h
> >  create mode 100644 drivers/crypto/dwc-spacc/spacc_hal.c
> >  create mode 100644 drivers/crypto/dwc-spacc/spacc_hal.h
> >  create mode 100644 drivers/crypto/dwc-spacc/spacc_interrupt.c
> >  create mode 100644 drivers/crypto/dwc-spacc/spacc_manager.c
> >  create mode 100644 drivers/crypto/dwc-spacc/spacc_skcipher.c
> > diff --git a/drivers/crypto/dwc-spacc/spacc_ahash.c b/drivers/crypto/dw=
c-spacc/spacc_ahash.c
> > new file mode 100644
> > index 000000000000..53c76ee16c53
> > --- /dev/null
> > +++ b/drivers/crypto/dwc-spacc/spacc_ahash.c
> > @@ -0,0 +1,1183 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +
>
> <snip>
>
> > +
> > +static int spacc_hash_init(struct ahash_request *req)
> > +{
> > +     int x =3D 0, rc =3D 0;
> > +     struct crypto_ahash *reqtfm =3D crypto_ahash_reqtfm(req);
> > +     struct spacc_crypto_ctx *tctx =3D crypto_ahash_ctx(reqtfm);
> > +     struct spacc_crypto_reqctx *ctx =3D ahash_request_ctx(req);
> > +     const struct spacc_alg *salg =3D spacc_tfm_ahash(&reqtfm->base);
> > +     struct spacc_priv *priv =3D dev_get_drvdata(tctx->dev);
> > +
> > +
> > +     ctx->digest_buf =3D NULL;
> > +
> > +     ctx->single_shot =3D 0;
> > +     ctx->total_nents =3D 0;
> > +     ctx->cur_part_pck =3D 0;
> > +     ctx->final_part_pck =3D 0;
> > +     ctx->rem_len =3D 0;
> > +     ctx->rem_nents =3D 0;
> > +     ctx->first_ppp_chunk =3D 1;
> > +     ctx->small_pck =3D 1;
> > +     tctx->ppp_sgl =3D NULL;
> > +
> > +     if (tctx->handle < 0 || !tctx->ctx_valid) {
> > +             priv =3D NULL;
> > +             dev_dbg(tctx->dev, "%s: open SPAcc context\n", __func__);
> > +
> > +             for (x =3D 0; x < ELP_CAPI_MAX_DEV && salg->dev[x]; x++) =
{
> > +                     priv =3D dev_get_drvdata(salg->dev[x]);
> > +                     tctx->dev =3D get_device(salg->dev[x]);
> > +                     if (spacc_isenabled(&priv->spacc, salg->mode->id,=
 0)) {
> > +                             tctx->handle =3D spacc_open(&priv->spacc,
> > +                                                       CRYPTO_MODE_NUL=
L,
> > +                                             salg->mode->id, -1, 0,
> > +                                             spacc_digest_cb, reqtfm);
> > +                     }
> > +
> > +                     if (tctx->handle >=3D 0)
> > +                             break;
> > +
> > +                     put_device(salg->dev[x]);
> > +             }
> > +
> > +             if (tctx->handle < 0) {
> > +                     dev_dbg(salg->dev[0], "Failed to open SPAcc conte=
xt\n");
> > +                     goto fallback;
> > +             }
> > +
> > +             rc =3D spacc_set_operation(&priv->spacc, tctx->handle,
> > +                                      OP_ENCRYPT, ICV_HASH, IP_ICV_OFF=
SET,
> > +                                      0, 0, 0);
> > +             if (rc < 0) {
> > +                     spacc_close(&priv->spacc, tctx->handle);
> > +                     dev_dbg(salg->dev[0], "Failed to open SPAcc conte=
xt\n");
> > +                     tctx->handle =3D -1;
> > +                     put_device(tctx->dev);
> > +                     goto fallback;
> > +             }
> > +             tctx->ctx_valid =3D true;
> > +     } else {
> > +             ;/* do nothing */
> > +     }
>
> Do we need this else?
>
> > +
> > +     /* alloc ppp_sgl */
> > +     tctx->ppp_sgl =3D kmalloc(sizeof(*(tctx->ppp_sgl)) * 2, GFP_KERNE=
L);
> > +     if (!tctx->ppp_sgl)
> > +             return -ENOMEM;
> > +
> > +     sg_init_table(tctx->ppp_sgl, 2);
> > +
> > +     return 0;
> > +fallback:
> > +
> > +     ctx->fb.hash_req.base =3D req->base;
> > +     ahash_request_set_tfm(&ctx->fb.hash_req, tctx->fb.hash);
> > +
> > +     return crypto_ahash_init(&ctx->fb.hash_req);
> > +}
> > +
> > +static int spacc_hash_final_part_pck(struct ahash_request *req)
> > +{
> > +     struct crypto_ahash *reqtfm =3D crypto_ahash_reqtfm(req);
> > +     struct spacc_crypto_ctx *tctx =3D crypto_ahash_ctx(reqtfm);
> > +     struct spacc_crypto_reqctx *ctx =3D ahash_request_ctx(req);
> > +     struct spacc_priv *priv =3D dev_get_drvdata(tctx->dev);
> > +
> > +     int rc;
> > +
> > +     ctx->final_part_pck =3D 1;
> > +
> > +     /* In all the final calls the data is same as prev update and
> > +      * hence we can skip this init dma part and just enQ ddt
> > +      * No use in calling initdata, just process remaining bytes in pp=
p_sgl
> > +      * and be done with it.
> > +      */
> > +
> > +     rc =3D spacc_hash_init_dma(tctx->dev, req, 1);
> > +
> > +     if (rc < 0)
> > +             return -ENOMEM;
> > +
> > +     if (rc =3D=3D 0) {
> > +             ;/* small packet */
> > +     }
>
> Please cleanup these do-nothing comment code paths throughout.
>
> > +
> > +     /* enqueue ddt for the remaining bytes of data, everything else
> > +      * would have been processed already, req->nbytes need not be
> > +      * processed
> > +      * Since this will hit only for small pkts, hence the condition
> > +      *  ctx->rem_len-req->nbytes for the small pkt len
> > +      */
> > +     if (ctx->rem_len)
> > +             rc =3D spacc_packet_enqueue_ddt(&priv->spacc,
> > +                             ctx->acb.new_handle, &ctx->src, &ctx->dst=
,
> > +                             tctx->ppp_sgl[0].length,
> > +                             0, tctx->ppp_sgl[0].length, 0, 0, 0);
> > +     else {
> > +             /* zero msg handling */
> > +             rc =3D spacc_packet_enqueue_ddt(&priv->spacc,
> > +                             ctx->acb.new_handle,
> > +                             &ctx->src, &ctx->dst, 0, 0, 0, 0, 0, 0);
> > +     }
> > +
> > +     if (rc < 0) {
> > +             spacc_hash_cleanup_dma(tctx->dev, req);
> > +             spacc_close(&priv->spacc, ctx->acb.new_handle);
> > +
> > +             if (rc !=3D -EBUSY) {
> > +                     dev_err(tctx->dev, "ERR: Failed to enqueue job: %=
d\n", rc);
> > +                     return rc;
> > +             }
> > +
> > +             if (!(req->base.flags & CRYPTO_TFM_REQ_MAY_BACKLOG))
> > +                     return -EBUSY;
> > +     }
> > +
> > +     return -EINPROGRESS;
> > +}
> > +
>
> <snip>
>
> Thanks,
> Easwar
