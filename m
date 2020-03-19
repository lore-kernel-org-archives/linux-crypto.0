Return-Path: <SRS0=HVQB=5E=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B2E2C4332B
	for <linux-crypto@archiver.kernel.org>; Thu, 19 Mar 2020 13:01:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5877520732
	for <linux-crypto@archiver.kernel.org>; Thu, 19 Mar 2020 13:01:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QdY2l/TV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726663AbgCSNA0 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 19 Mar 2020 09:00:26 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:40045 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725787AbgCSNA0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 19 Mar 2020 09:00:26 -0400
Received: by mail-wm1-f65.google.com with SMTP id z12so2149166wmf.5;
        Thu, 19 Mar 2020 06:00:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=89ymcr/0CQ8G/h/07WdAPH8+H6QLZMiQMSSP5qcJ8x8=;
        b=QdY2l/TVmUpe3UueK+In/PS5VMXf9wcunGIIMHs+MdR1r4wVlT4Wp6fv+ZwFnPYO6x
         VomZXtrw08LH38j/JnK8Rt6XpkC+39OBlGnFxwlBK2NlmEvh/903jAi6KBCnCuZ8cZDt
         p4glf+a+iy4YzZLInjxELMN8U6u68h9GLnzRm0IIyTOOUCSv+9u6HKACeQQCLsk7aiWL
         EV5PbpIltBHM57/iMu9pbYbHYAjqARY5gn9jyqiJqGErpZJOUgtSVAx/5TPR0idPadnf
         5WtCqvknyR+B9p07jcqcnq346iV8eeeE8Xi2pCJpxT25NXfXka+SuC9vgd7mdCiFquFl
         u03Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=89ymcr/0CQ8G/h/07WdAPH8+H6QLZMiQMSSP5qcJ8x8=;
        b=JETF1qi2H8mW1IPL8kQxoa5clr7/97nwhcKfuuP+D78Ejf/Kmf0xDKxT8wN9+WlR56
         Sr3eExlA+NCvbbxgU+rjbPmZ9WDW9MpKO78G9tk1EAz8JymXzL7o4EFKunIleKn144w/
         sSv+SCCOMGdCMeT5azVByY9yotXedU9qVHnDfbE5eYLmDbe7eojXwCYQfVrFWMPYDLsX
         f3Y6JHwSFAvN27KTlHsZfZl0PVO0wLRJwD4uXqsO+/EAFrf3JolXxau3J/zi/CPmKvr/
         oNCYiS5v1YU5BECpNPxs49VDWwW9CI+TsmSNPUsyEiX8BaTNDvGbrmPqdPpVsbKEzKmm
         6F1A==
X-Gm-Message-State: ANhLgQ0WjlWZUqdOUA7f9IVqgZEdwbfflq2w3Pb0NhFDPZCqTdBJ4MmO
        EYrQHpEYk7eVP8Wr1E5TLYmA6bFNHQmB8EB/f76ekQ==
X-Google-Smtp-Source: ADFU+vvc7E1zOMM7lFKAo7l9c1uKku2++H9whPC3pZbk9Khxamid9dTyneWiwofdtMbT4z5fXm7n0otdDQpDL7zdphI=
X-Received: by 2002:a7b:c456:: with SMTP id l22mr3445690wmi.184.1584622823530;
 Thu, 19 Mar 2020 06:00:23 -0700 (PDT)
MIME-Version: 1.0
References: <20200316150047.30828-1-andrew.smirnov@gmail.com>
 <20200316150047.30828-4-andrew.smirnov@gmail.com> <49971beb-0681-de92-95f5-b18e1be05ce3@nxp.com>
In-Reply-To: <49971beb-0681-de92-95f5-b18e1be05ce3@nxp.com>
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
Date:   Thu, 19 Mar 2020 06:00:10 -0700
Message-ID: <CAHQ1cqGcR=u8QPeD7PQtsZYEQL=5VQWv4r=LPC=VFET2X1VOHw@mail.gmail.com>
Subject: Re: [PATCH v8 3/8] crypto: caam - drop global context pointer and init_done
To:     =?UTF-8?Q?Horia_Geant=C4=83?= <horia.geanta@nxp.com>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Mar 17, 2020 at 9:45 AM Horia Geant=C4=83 <horia.geanta@nxp.com> wr=
ote:
>
> On 3/16/2020 5:01 PM, Andrey Smirnov wrote:
> > diff --git a/drivers/crypto/caam/caamrng.c b/drivers/crypto/caam/caamrn=
g.c
> > index 69a02ac5de54..753625f2b2c0 100644
> > --- a/drivers/crypto/caam/caamrng.c
> > +++ b/drivers/crypto/caam/caamrng.c
> > @@ -70,6 +70,7 @@ struct buf_data {
> >
> >  /* rng per-device context */
> >  struct caam_rng_ctx {
> > +     struct hwrng rng;
> >       struct device *jrdev;
> >       dma_addr_t sh_desc_dma;
> >       u32 sh_desc[DESC_RNG_LEN];
> > @@ -78,13 +79,10 @@ struct caam_rng_ctx {
> >       struct buf_data bufs[2];
> >  };
> [...]
> > +static struct caam_rng_ctx *to_caam_rng_ctx(struct hwrng *r)
> > +{
> > +     return (struct caam_rng_ctx *)r->priv;
> > +}
> [...]
> > -static struct hwrng caam_rng =3D {
> > -     .name           =3D "rng-caam",
> > -     .init           =3D caam_init,
> > -     .cleanup        =3D caam_cleanup,
> > -     .read           =3D caam_read,
> > -};
> I would keep this statically allocated, see below.
>
> > @@ -342,18 +332,27 @@ int caam_rng_init(struct device *ctrldev)
> >       if (!rng_inst)
> >               return 0;
> >
> > -     rng_ctx =3D kmalloc(sizeof(*rng_ctx), GFP_DMA | GFP_KERNEL);
> > -     if (!rng_ctx)
> > +     if (!devres_open_group(ctrldev, caam_rng_init, GFP_KERNEL))
> > +             return -ENOMEM;
> > +
> > +     ctx =3D devm_kzalloc(ctrldev, sizeof(*ctx), GFP_DMA | GFP_KERNEL)=
;
> > +     if (!ctx)
> >               return -ENOMEM;
> >
> > +     ctx->rng.name    =3D "rng-caam";
> > +     ctx->rng.init    =3D caam_init;
> > +     ctx->rng.cleanup =3D caam_cleanup;
> > +     ctx->rng.read    =3D caam_read;
> > +     ctx->rng.priv    =3D (unsigned long)ctx;
> > +
> >       dev_info(ctrldev, "registering rng-caam\n");
> >
> > -     err =3D hwrng_register(&caam_rng);
> > -     if (!err) {
> > -             init_done =3D true;
> > -             return err;
> > +     ret =3D devm_hwrng_register(ctrldev, &ctx->rng);
> Now that hwrng.priv is used to keep driver's private data / caam_rng_ctx,
> and thus container_of() is no longer needed to get from hwrng struct
> to caam_rng_ctx, it's no longer needed to embed struct hwrng
> into caam_rng_ctx.
>

Why do we want this change though? It doesn't allow us to constify
"struct hwrng", don't seem to give any other benefits (maybe I am
missing something?) at the same time creating a new implicit global
variable. I'd rather not do this.

Thanks,
Andrey Smirnov
