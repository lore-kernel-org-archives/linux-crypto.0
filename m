Return-Path: <SRS0=Q+7j=3Q=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABEFFC2D0DB
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Jan 2020 13:44:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7AAFD207FD
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Jan 2020 13:44:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FeYTk/q3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726101AbgA0Noq (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 27 Jan 2020 08:44:46 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:35384 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725828AbgA0Noq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 Jan 2020 08:44:46 -0500
Received: by mail-wr1-f67.google.com with SMTP id g17so11354556wro.2;
        Mon, 27 Jan 2020 05:44:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wJSM4ovv9urnItT3LFQeBCPJ1eUfCvXrI8Ak3RPAcP0=;
        b=FeYTk/q3iZiBUCABCEpMEd1HkkmgIvE5pd8LUwS4kaiUJQRaevvB1H2gJiOIcCTH5R
         nC7oWr8w2PUdWvEfbEcpaWMndGq6UB9df0/gUzaj9yzEHjLlRMFTLjkkid9WbXN6p36C
         0qKrsVRtT2Xo8oyImwkafwMI54Y/3/uXKTyrI6VT7tbWO1aOxMj1YGib6VNfZR/R44/X
         XwWHdW6kjTJrTgtssS38yOnWGjaHcnEg60BwZnL9WACleTBI5qBzI0aW7KwXJd5Doj6z
         M6nupCmMBlNdG8YSaeZMBZj1dNqCEEN/wfAuAqhS7FfGT5o8j0VePqSbkGKRLx4bxzz0
         eQ0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wJSM4ovv9urnItT3LFQeBCPJ1eUfCvXrI8Ak3RPAcP0=;
        b=f2lPhz49x+JE/pN6nXlZdjPWGJWfKc2bMhygIGGxW6Nuv2X6XSz6g5DXXSIuyeR7B3
         wNLCq7y9h0BmmnHHNE7chGbXfSrCHsgiWXgOI1R4So3YBVJR4P5xgKu6Y95dDMY6J+pk
         FEGIBdeyt4pq4cpoE59vzfYWGiAf14pdpRvuXVz7jWwx9pLfMfjlVvPMrOkSEFZY0pTb
         Q29Ntc5S+qJxITy1RKgAufpcT9JHdWXYd4crC+Q4Xvv27+uRbiWqbxD8082qLfqkayHR
         Xa/qz/Cn6iND2sB/ggUbbOUj5hKUIb7BcPO7lt4hxCwAlwQmkgZZsj+fGmsFDKqMxpRG
         gMRQ==
X-Gm-Message-State: APjAAAXPcEXYCCJadPyi4VLU1iBjCoLwHoA3BtxyowdsGCIZ+RbCXxKB
        tvsXsXtnpvRDDTJy10yGztUbP8k5WmxkexdBegU=
X-Google-Smtp-Source: APXvYqzr/40tz/O3/Nl+urt8glsN4lt1n5Ym9GpkWk99Tb3CAgn8sqibjWHF2t5MJu0tVo55XyH3VrjpzNTVhAOCMd4=
X-Received: by 2002:a5d:6390:: with SMTP id p16mr22908043wru.170.1580132684214;
 Mon, 27 Jan 2020 05:44:44 -0800 (PST)
MIME-Version: 1.0
References: <20200108154047.12526-1-andrew.smirnov@gmail.com>
 <20200108154047.12526-3-andrew.smirnov@gmail.com> <VI1PR0402MB3485A38A9A71500E632191AD98350@VI1PR0402MB3485.eurprd04.prod.outlook.com>
In-Reply-To: <VI1PR0402MB3485A38A9A71500E632191AD98350@VI1PR0402MB3485.eurprd04.prod.outlook.com>
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
Date:   Mon, 27 Jan 2020 05:44:32 -0800
Message-ID: <CAHQ1cqHmn2JwNVjOGdbjuSnf6abfOUVe4xoCE=qvV8++jSFdZg@mail.gmail.com>
Subject: Re: [PATCH v6 2/7] crypto: caam - drop global context pointer and init_done
To:     Horia Geanta <horia.geanta@nxp.com>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jan 13, 2020 at 1:41 AM Horia Geanta <horia.geanta@nxp.com> wrote:
>
> On 1/8/2020 5:42 PM, Andrey Smirnov wrote:
> > @@ -342,18 +324,16 @@ int caam_rng_init(struct device *ctrldev)
> >       if (!rng_inst)
> >               return 0;
> >
> > -     rng_ctx = kmalloc(sizeof(*rng_ctx), GFP_DMA | GFP_KERNEL);
> > -     if (!rng_ctx)
> > +     ctx = devm_kzalloc(ctrldev, sizeof(*ctx), GFP_DMA | GFP_KERNEL);
> > +     if (!ctx)
> >               return -ENOMEM;
> >
> > -     dev_info(ctrldev, "registering rng-caam\n");
> > +     ctx->rng.name    = "rng-caam";
> > +     ctx->rng.init    = caam_init;
> > +     ctx->rng.cleanup = caam_cleanup;
> > +     ctx->rng.read    = caam_read;
> >
> > -     err = hwrng_register(&caam_rng);
> > -     if (!err) {
> > -             init_done = true;
> > -             return err;
> > -     }
> > +     dev_info(ctrldev, "registering rng-caam\n");
> >
> > -     kfree(rng_ctx);
> > -     return err;
> > +     return devm_hwrng_register(ctrldev, &ctx->rng);
> This means hwrng_unregister() is called only when ctrldev is removed.
>
> OTOH caam_rng_init() could be called multiple times, e.g. if there's only one
> jrdev left in the system and it's removed then added back.
> This will lead to caam_rng_init() -> hwrng_register() called twice
> with the same "rng-caam" name, without a hwrng_unregister() called in-between.
>

True, but the logic you describe is broken in reality due to circular
reference from HWRNG, which we never fixed. I'll fix both in v7.

Thanks,
Andrey Smirnov
