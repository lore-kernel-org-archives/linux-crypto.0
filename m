Return-Path: <SRS0=f1VZ=XN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0A19C4CEC9
	for <linux-crypto@archiver.kernel.org>; Wed, 18 Sep 2019 06:07:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A00A8218AE
	for <linux-crypto@archiver.kernel.org>; Wed, 18 Sep 2019 06:07:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mCkLg44c"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725903AbfIRGHE (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 18 Sep 2019 02:07:04 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:33460 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725820AbfIRGHD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 18 Sep 2019 02:07:03 -0400
Received: by mail-io1-f68.google.com with SMTP id m11so13491666ioo.0;
        Tue, 17 Sep 2019 23:07:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=xalXB+zTcS0a+NMwK6if7JfXclkW8Yw6EeltTUmJSNA=;
        b=mCkLg44cRp2Svoewt1KhkC3tid98DJttP2esBlzdQwhZPAWASBkiH611EYr5BePZdK
         dJkuNmhANIrMB1391wJmKOXXRYjfpdr8hruc+oSEFgeyEslnz+zsYLBUrF09MxgaJi3T
         vtQg//UME82O3yUgwA51hGLq2/gauIDCH3LTr8n4/iP3l/Sx3OYBvN/7+YgfxQsPf7RN
         1vLnBoOZExYF25Ly6MSK3ErJsy5/VM/IrKbsqeNTuRe3kd4P2vyxJaDMi07u4fVDEhO6
         NNczEq8AFqMlZaAITh0AseocEXNPXwsKNHGlAGjOJ+oq5ZdljvKUHlwVtMuv4SuYAu+N
         /TRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=xalXB+zTcS0a+NMwK6if7JfXclkW8Yw6EeltTUmJSNA=;
        b=jCCnAUsr5N6heen14Y3DH46Mzi9TNEPMErym+iLEP27hxCwSv8Oz/ewLcJ/pk8GDxd
         y4n6Fx2XJ/xZ+DLOvZpVZ37wSwyBr/Br80xbIpr+iFbMXx2RdSLMeVREu6OTqAP/oUqq
         nZDcRxhDeHCiMvJoDS7gvZfe2i2JNQXy9CQIFpxV/FeZqh9K7+/zurMWK0H6jFjTfPQm
         WyL1IB9LaPalzJlU75yroFqQSUJN+4Oelt7OLb8LniI7o5KHrYiSsE39+GygQmCKhLJM
         ww5UF3ELmA5yr2nwJiK2GeMoTGAHIWLFnrVB5IVw4QvPIyR+Kur4VJizfplhrSc+bFw6
         jdgw==
X-Gm-Message-State: APjAAAUjHLeOt2kwNb5zSaDQjkvrYA51J2lXHN8g3TDoVXPa0RjOBDjp
        NKzWqbOVuYjvVeZnIt2GTkV5TtFjD09Tmm/0REJ3vucz
X-Google-Smtp-Source: APXvYqzxMeequQiMeVWwi/Vg3pYCFtkRl+fqjNXDxgxDuKnQaDI8xt3/nmXnbaFmGcXXGukoHgRCqjNiWfa58icF464=
X-Received: by 2002:a6b:f315:: with SMTP id m21mr1482025ioh.12.1568786822793;
 Tue, 17 Sep 2019 23:07:02 -0700 (PDT)
MIME-Version: 1.0
References: <20190904023515.7107-1-andrew.smirnov@gmail.com>
 <20190904023515.7107-8-andrew.smirnov@gmail.com> <VI1PR0402MB3485C8B22FD2B66F8FD9653E98B70@VI1PR0402MB3485.eurprd04.prod.outlook.com>
In-Reply-To: <VI1PR0402MB3485C8B22FD2B66F8FD9653E98B70@VI1PR0402MB3485.eurprd04.prod.outlook.com>
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
Date:   Tue, 17 Sep 2019 23:06:50 -0700
Message-ID: <CAHQ1cqFf+XS7Hcdsup0hBD-o3fF5JhUREmaCdnhJ2hUaiv7fLw@mail.gmail.com>
Subject: Re: [PATCH 07/12] crypto: caam - use devres to de-initialize the RNG
To:     Horia Geanta <horia.geanta@nxp.com>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Sep 9, 2019 at 8:39 AM Horia Geanta <horia.geanta@nxp.com> wrote:
>
> On 9/4/2019 5:35 AM, Andrey Smirnov wrote:
> > Use devres to de-initialize the RNG and drop explicit de-initialization
> > code in caam_remove().
> >
> > Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>
> > Cc: Chris Healy <cphealy@gmail.com>
> > Cc: Lucas Stach <l.stach@pengutronix.de>
> > Cc: Horia Geant=C4=83 <horia.geanta@nxp.com>
> > Cc: Herbert Xu <herbert@gondor.apana.org.au>
> > Cc: Iuliana Prodan <iuliana.prodan@nxp.com>
> > Cc: linux-crypto@vger.kernel.org
> > Cc: linux-kernel@vger.kernel.org
> > ---
> >  drivers/crypto/caam/ctrl.c | 129 ++++++++++++++++++++-----------------
> >  1 file changed, 70 insertions(+), 59 deletions(-)
> >
> > diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
> > index 254963498abc..25f8f76551a5 100644
> > --- a/drivers/crypto/caam/ctrl.c
> > +++ b/drivers/crypto/caam/ctrl.c
> > @@ -175,6 +175,73 @@ static inline int run_descriptor_deco0(struct devi=
ce *ctrldev, u32 *desc,
> >       return 0;
> >  }
> >
> > +/*
> > + * deinstantiate_rng - builds and executes a descriptor on DECO0,
> > + *                  which deinitializes the RNG block.
> > + * @ctrldev - pointer to device
> > + * @state_handle_mask - bitmask containing the instantiation status
> > + *                   for the RNG4 state handles which exist in
> > + *                   the RNG4 block: 1 if it's been instantiated
> > + *
> > + * Return: - 0 if no error occurred
> > + *      - -ENOMEM if there isn't enough memory to allocate the descrip=
tor
> > + *      - -ENODEV if DECO0 couldn't be acquired
> > + *      - -EAGAIN if an error occurred when executing the descriptor
> > + */
> > +static int deinstantiate_rng(struct device *ctrldev, int state_handle_=
mask)
> I assume this function is not modified, only moved further up
> to avoid forward declaration.
>

Correct.

> > +     if (!ret) {
> > +             ret =3D devm_add_action_or_reset(ctrldev, devm_deinstanti=
ate_rng,
> > +                                            ctrldev);
> >       }
> Braces not needed.
>

OK, will remove in next version.

> Is there any guidance wrt. when *not* to use devres?
>

Not that I now of.

Thanks,
Andrey Smirnov
