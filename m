Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDCD0C432BE
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Aug 2021 05:57:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B541060F58
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Aug 2021 05:57:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233851AbhHCF5q (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 3 Aug 2021 01:57:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230096AbhHCF5p (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 3 Aug 2021 01:57:45 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F08BFC06175F;
        Mon,  2 Aug 2021 22:57:33 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id nd39so34607446ejc.5;
        Mon, 02 Aug 2021 22:57:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=qQa6pcdJaaMybmAqLpeWfvCz1Z6vyYF74Ui12REMt0Y=;
        b=MKDI89hQxBB75T66Cxr+3sMAw5RTYmdxyXrIbty6Fk59/5zzGTnvkmKmleFqN7Jl4/
         fr5wWt5vi2YO94IbLbdIr77talJ7AWKAw2Z8LLOxUjKQPDCjyRhqxP/xkWNqVZbqCTcX
         xduJiYwAynfga8rpYKq87G/LaPvwc8g9egsj5PVAjWMDF7x5KNZJcmQ7sUvEcO1Xq3E+
         VTta3CDQwO+yaST3/C2rP8cNGBaxZx0CTARZhRVwV95fr9VgtWHlN3NONyW+9Uy7NhAf
         zf53rvZlzOCW07YgMCoi8JMZKRtMCoefnl6AGGu7yJO+FNdqAXilSlNUhlfykpk73VH3
         EV1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=qQa6pcdJaaMybmAqLpeWfvCz1Z6vyYF74Ui12REMt0Y=;
        b=adzF7+me6cpoiIMpwDo/aGxFKpRYk97NefPOsSw5Rx5KeMMlHXuWFJs3UTpDIaIX5P
         IjJwEUNR9vwPXg0JJ0EgXcFnHG0SGV2SDp659QiAGuAgJ3/+mXLAY9XCpXlJsSNtfIvQ
         9kA1NDxIJHjqkP9VQMZyxW1By77mbJAN4OjD2nGRBH7AHqOrqU7usaTpQ82toIeuVKWq
         INjtWBJoAFBvgX33HtXWWe68DSHdfRSHDsyfjVeB/DfhG1Eu4wWhLg+Dll6j5p9G3kyg
         QY7NHekmBMiMqG7JU/EQOi27MlPRU9W0DYoeXFjf3fPXHqZFgxRA8QI+C8RXTue+bQCI
         3E2g==
X-Gm-Message-State: AOAM531aZpAfdgu9YkNIevfwylUUnmE5i8gW+Sm/gvfxqaoJX/1ObMwe
        apAaQuW/sWMpIX8Rqt7xVskdOpVn4gnNbEMMQj0=
X-Google-Smtp-Source: ABdhPJxPMFgHsfkBt7LZofGu0k24QG5zQkPYVOdEGwglJ8jIO0bAUlV1qhoCbD6yKmhAwpZJDSBysbj4kczcgbP4GYw=
X-Received: by 2002:a17:906:4784:: with SMTP id cw4mr18747979ejc.160.1627970252517;
 Mon, 02 Aug 2021 22:57:32 -0700 (PDT)
MIME-Version: 1.0
References: <20210726152724.2281408-1-mudongliangabcd@gmail.com> <YQg4lehajLpQjyPd@Red>
In-Reply-To: <YQg4lehajLpQjyPd@Red>
From:   Dongliang Mu <mudongliangabcd@gmail.com>
Date:   Tue, 3 Aug 2021 13:57:06 +0800
Message-ID: <CAD-N9QWvR-7caWCnk1CMo8sWPEC=CfKU2_v=YkTVr0o5L7wehA@mail.gmail.com>
Subject: Re: [PATCH] crypto: sun8i-ce: fix multiple memory leaks in sun8i_ce_hash_run
To:     Corentin Labbe <clabbe.montjoie@gmail.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Eric Biggers <ebiggers@google.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Corentin Labbe <clabbe@baylibre.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-sunxi@lists.linux.dev,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Aug 3, 2021 at 2:25 AM Corentin Labbe <clabbe.montjoie@gmail.com> w=
rote:
>
> Le Mon, Jul 26, 2021 at 11:27:12PM +0800, Dongliang Mu a =C3=A9crit :
> > In sun8i_ce_hash_run, all the dma_mmap_sg/single will cause memory leak
> > due to no corresponding unmap operation if errors happen.
> >
> > Fix this by adding error handling part for all the dma_mmap_sg/single.
> >
>
> I think it could be better worded, error handling is already there (but b=
ad).

Sure. How about "Fix this by freeing the objects allocated by
dma_mmap_sg/single when errors occur."?

>
> > Fixes: 56f6d5aee88d ("crypto: sun8i-ce - support hash algorithms")
> > Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
> > ---
> >  .../crypto/allwinner/sun8i-ce/sun8i-ce-hash.c | 28 +++++++++----------
> >  1 file changed, 13 insertions(+), 15 deletions(-)
> >
> > diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c b/driver=
s/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c
> > index 88194718a806..d454ad99deee 100644
> > --- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c
> > +++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c
> > @@ -286,16 +286,14 @@ int sun8i_ce_hash_run(struct crypto_engine *engin=
e, void *breq)
> >
> >       /* the padding could be up to two block. */
> >       buf =3D kzalloc(bs * 2, GFP_KERNEL | GFP_DMA);
> > -     if (!buf) {
> > -             err =3D -ENOMEM;
> > -             goto theend;
>
> Please keep all goto error for being consistent.

OK, no problem.

BTW, usually for the 1st malloc failure, I prefer returning with errno dire=
ctly.

>
> > -     }
> > +     if (!buf)
> > +             return -ENOMEM;
> >       bf =3D (__le32 *)buf;
> >
> >       result =3D kzalloc(digestsize, GFP_KERNEL | GFP_DMA);
> >       if (!result) {
> > -             err =3D -ENOMEM;
> > -             goto theend;
> > +             kfree(buf);
> > +             return -ENOMEM;
> >       }
> >
> >       flow =3D rctx->flow;
> > @@ -321,7 +319,7 @@ int sun8i_ce_hash_run(struct crypto_engine *engine,=
 void *breq)
> >       if (nr_sgs <=3D 0 || nr_sgs > MAX_SG) {
> >               dev_err(ce->dev, "Invalid sg number %d\n", nr_sgs);
> >               err =3D -EINVAL;
> > -             goto theend;
> > +             goto err_result;
> >       }
> >
> >       len =3D areq->nbytes;
> > @@ -334,7 +332,7 @@ int sun8i_ce_hash_run(struct crypto_engine *engine,=
 void *breq)
> >       if (len > 0) {
> >               dev_err(ce->dev, "remaining len %d\n", len);
> >               err =3D -EINVAL;
> > -             goto theend;
> > +             goto err_unmap_sg;
> >       }
> >       addr_res =3D dma_map_single(ce->dev, result, digestsize, DMA_FROM=
_DEVICE);
> >       cet->t_dst[0].addr =3D cpu_to_le32(addr_res);
> > @@ -342,7 +340,7 @@ int sun8i_ce_hash_run(struct crypto_engine *engine,=
 void *breq)
> >       if (dma_mapping_error(ce->dev, addr_res)) {
> >               dev_err(ce->dev, "DMA map dest\n");
> >               err =3D -EINVAL;
> > -             goto theend;
> > +             goto err_unmap_sg;
> >       }
> >
> >       byte_count =3D areq->nbytes;
> > @@ -392,7 +390,7 @@ int sun8i_ce_hash_run(struct crypto_engine *engine,=
 void *breq)
> >       if (dma_mapping_error(ce->dev, addr_pad)) {
> >               dev_err(ce->dev, "DMA error on padding SG\n");
> >               err =3D -EINVAL;
> > -             goto theend;
> > +             goto err_addr_res;
> >       }
> >
> >       if (ce->variant->hash_t_dlen_in_bits)
> > @@ -405,15 +403,15 @@ int sun8i_ce_hash_run(struct crypto_engine *engin=
e, void *breq)
> >       err =3D sun8i_ce_run_task(ce, flow, crypto_tfm_alg_name(areq->bas=
e.tfm));
> >
> >       dma_unmap_single(ce->dev, addr_pad, j * 4, DMA_TO_DEVICE);
> > +err_addr_res:
> > +     dma_unmap_single(ce->dev, addr_res, digestsize, DMA_FROM_DEVICE);
> > +err_unmap_sg:
> >       dma_unmap_sg(ce->dev, areq->src, sg_nents(areq->src),
> >                    DMA_TO_DEVICE);
> > -     dma_unmap_single(ce->dev, addr_res, digestsize, DMA_FROM_DEVICE);
> > -
> > -
> >       memcpy(areq->result, result, algt->alg.hash.halg.digestsize);
>
> The result should be copied only when everything is ok. Please add a "if =
(!err)"

Sure.

>
> Thanks for your work
> Regards
