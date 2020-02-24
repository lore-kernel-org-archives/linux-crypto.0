Return-Path: <SRS0=ApwQ=4M=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEC02C11D30
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Feb 2020 16:41:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7FD1E20836
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Feb 2020 16:41:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Bx7n5fAi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727706AbgBXQlF (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 24 Feb 2020 11:41:05 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:52654 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727730AbgBXQlF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 Feb 2020 11:41:05 -0500
Received: by mail-wm1-f68.google.com with SMTP id p9so9647756wmc.2;
        Mon, 24 Feb 2020 08:41:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0SHuRI7Htiab/lxIwL+TUGdCTRz+weTd4Cb1gMPoztA=;
        b=Bx7n5fAi5y0A78UMbnC291WL1mtT2tW3thmm78okwPEsIVq8CB3JKSO5Wia73SUUIn
         cjVkbPBjrqQBNVpB494itItVk7YaSz7CpCeil+VIiVAQOP5K8556a2On5Q4icSQpv3gX
         A3Vmm0ixj+kgxDQmkkykP2ZGvy6NgnZpTlS+y/AREspXoo44T80ks77cBWtq/YIXPXM2
         d3xcP7nP6f8EdvN9tBXouRgYj1CReS43ZRGlFuLDw8SKgr1sgy8tRbYM/zWl6v15eFFb
         j1HjfAVtpiBIIz+1vSk+xInR55tYZbZB+1DPxG03H3qODjgxF0CtpJsR7MAOAqssmTii
         dKZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0SHuRI7Htiab/lxIwL+TUGdCTRz+weTd4Cb1gMPoztA=;
        b=D+Rq7ytttUqpBRbeaS+2de2jGNgkknAzQtXUN39cUju/62BCPQbp5j5jcFZp3yq/UF
         xabakAuCXHAVNjpK3dBpm1GBjkzJoCeZR74yC0NwvFKJdhJ4vKhA5v5YqoacAjvNR+zX
         LDhqvHux0Yj1Dok49KxG8bflPgtABw4YZiK/oXCKlmVNqlZ47+/MgXvBqrWFCg4QjETF
         G2fKj+u6VKTceNn2qZ7RYFOV+SIToFajxjnm0YhewYMHQ95poyCDmdPAKv5oXcxddh1e
         CG0fVZlV2fYyIoT9hnYMkQjTfFhWTvp62hEkzrER+/Gx5NhgUETxJ3OrPWlrXpFFHhW/
         ymAQ==
X-Gm-Message-State: APjAAAX02DC9rddntdadloVBUCKjfnQ2Kg5DWl1p49Q/YZR45jvevZne
        3Iq+f6FOGTOMwFBZQZcMhhXCtrMUJgkUYuHjuxE=
X-Google-Smtp-Source: APXvYqxrOtpqEkpmpIMD54OftRmmsSkpjPZ+BwkaEN0EGpARQI/6S1ogW7Hl0PbK9QvOTD3GowfLOM9zKdj7/qzG47Y=
X-Received: by 2002:a7b:cd1a:: with SMTP id f26mr21672341wmj.184.1582562463700;
 Mon, 24 Feb 2020 08:41:03 -0800 (PST)
MIME-Version: 1.0
References: <20200127165646.19806-1-andrew.smirnov@gmail.com>
 <20200127165646.19806-5-andrew.smirnov@gmail.com> <VI1PR0402MB3485A733C0A6B57E129A339198180@VI1PR0402MB3485.eurprd04.prod.outlook.com>
In-Reply-To: <VI1PR0402MB3485A733C0A6B57E129A339198180@VI1PR0402MB3485.eurprd04.prod.outlook.com>
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
Date:   Mon, 24 Feb 2020 08:40:52 -0800
Message-ID: <CAHQ1cqE7ivNQLYrHo1Jt4S-z7traCJr=NYNTUxmTHHtJJjyNwQ@mail.gmail.com>
Subject: Re: [PATCH v7 4/9] crypto: caam - drop global context pointer and init_done
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

On Tue, Feb 11, 2020 at 12:57 PM Horia Geanta <horia.geanta@nxp.com> wrote:
>
> On 1/27/2020 6:57 PM, Andrey Smirnov wrote:
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
> >
> > -static struct caam_rng_ctx *rng_ctx;
> > -
> > -/*
> > - * Variable used to avoid double free of resources in case
> > - * algorithm registration was unsuccessful
> > - */
> > -static bool init_done;
> > +static struct caam_rng_ctx *to_caam_rng_ctx(struct hwrng *r)
> > +{
> > +     return container_of(r, struct caam_rng_ctx, rng);
> > +}
> [...]
> > -static struct hwrng caam_rng = {
> > -     .name           = "rng-caam",
> > -     .init           = caam_init,
> > -     .cleanup        = caam_cleanup,
> > -     .read           = caam_read,
> > -};
> [...]> +        ctx->rng.name    = "rng-caam";
> > +     ctx->rng.init    = caam_init;
> > +     ctx->rng.cleanup = caam_cleanup;
> > +     ctx->rng.read    = caam_read;
> An alternative (probably better) for storing caamrng context
> is to use what is already available in struct hwrng:
>  * @priv:               Private data, for use by the RNG driver.
>

OK, will do in v8.

Thanks,
Andrey Smirnov
