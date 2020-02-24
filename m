Return-Path: <SRS0=ApwQ=4M=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B71FBC11D2F
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Feb 2020 16:37:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 86EF320836
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Feb 2020 16:37:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OyK0PgTu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727438AbgBXQhk (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 24 Feb 2020 11:37:40 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:51431 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727160AbgBXQhk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 Feb 2020 11:37:40 -0500
Received: by mail-wm1-f68.google.com with SMTP id t23so9640377wmi.1;
        Mon, 24 Feb 2020 08:37:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=G+aCWrTPtazwLlxUW4Ddtt63F9Ca8NXitPxy5zGxSeo=;
        b=OyK0PgTuu8fZ6LWuZ+3xulzUbpo6OkLEHg5JQCENw1b0M3fbmycMihPs93zkd4g5Ip
         6zUV3hF0GXG8uun2UldTFXG7dSb3ET1ASbVPw2A7sw38RPRA4C9hrEZzG8/kvgu50uyd
         iJvZJRooEICcStMF8z8Aezj9eQM5Mw293VUUj/fsbAkJgtKjGHD9mTCpikqyZZIfW4Gn
         FT5CmFQYYmNGDbXI9RyYjHeUmsqoWo6XjFkgYtSuPDBoMdeIPwN3ytRNq6sEEXWM5IVf
         uFuZxFka9JOmO2uNGtwA6uPVvgsRuccqNw4AHCGPw8X7NuLGyo1pAOZ6UUPW4pRl0XDt
         DxbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=G+aCWrTPtazwLlxUW4Ddtt63F9Ca8NXitPxy5zGxSeo=;
        b=uJIQWfxqDKicuAaRhbS/DUBwxnRj7tpCj45FyapevJ/8YOfHHBJTkeCj2868YLf27L
         TyOvEWPJR8KQm1DZpWO/JgXOkPbjUO8IexuFtD5oBXltoLO9ouNvpR+ehVM5OOcVyuqq
         KsXEzlzlsnSUvRfd/npsdSZq35372EPyWmDwagU/0gZZxYIzxtbqmG4/iuVsSEOiXfvz
         5V7kRKngy700gGbHHRrLrB71T3E9ivHR2KqOL+trC5Sl1qFMFFuz6dGiRsDWQoWBEFiK
         iYTr+bhXWqbt9SukaA6thn8oAUSCfqloa5KOxnwzLV8t71jhEIv2N8a3Le/qgqR4BI0D
         GU+Q==
X-Gm-Message-State: APjAAAXoOxLmP2z+GMdA4QZoEl1f9+hiEi7OqCB2PJMrTvttV6nf/AMb
        j+3qOrkjeUoxJ+3RvWQyqg8ROvh0j4DrCyQPJuQ=
X-Google-Smtp-Source: APXvYqypeNv5N1UPqLrdNY1QVTfMCrOJzcCdwq3nCvUSqZP/cKgLDJ52UQni4EZNo2D8GxsZtIZcJ6xTcainQzr/3EA=
X-Received: by 2002:a05:600c:217:: with SMTP id 23mr22797412wmi.124.1582562258838;
 Mon, 24 Feb 2020 08:37:38 -0800 (PST)
MIME-Version: 1.0
References: <20200127165646.19806-1-andrew.smirnov@gmail.com>
 <20200127165646.19806-7-andrew.smirnov@gmail.com> <VI1PR0402MB34857006B42E8F0DAFECC514981B0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
In-Reply-To: <VI1PR0402MB34857006B42E8F0DAFECC514981B0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
Date:   Mon, 24 Feb 2020 08:37:27 -0800
Message-ID: <CAHQ1cqHDotfJVUM9+Dk7=LyFxDhSWmud66HiZSzbZkKtn9R0Ug@mail.gmail.com>
Subject: Re: [PATCH v7 6/9] crypto: caam - check if RNG job failed
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

On Wed, Feb 12, 2020 at 2:41 AM Horia Geanta <horia.geanta@nxp.com> wrote:
>
> On 1/27/2020 6:57 PM, Andrey Smirnov wrote:
> > @@ -60,12 +65,12 @@ static struct caam_rng_ctx *to_caam_rng_ctx(struct hwrng *r)
> >  static void caam_rng_done(struct device *jrdev, u32 *desc, u32 err,
> >                         void *context)
> >  {
> > -     struct completion *done = context;
> > +     struct caam_rng_job_ctx *jctx = context;
> >
> >       if (err)
> > -             caam_jr_strstatus(jrdev, err);
> > +             *jctx->err = caam_jr_strstatus(jrdev, err);
> >
> > -     complete(done);
> > +     complete(jctx->done);
> >  }
> >
> >  static u32 *caam_init_desc(u32 *desc, dma_addr_t dst_dma, int len)
> > @@ -89,6 +94,10 @@ static int caam_rng_read_one(struct device *jrdev,
> >  {
> >       dma_addr_t dst_dma;
> >       int err;
> > +     struct caam_rng_job_ctx jctx = {
> > +             .done = done,
> > +             .err  = &err,
> > +     };
> >
> >       len = min_t(int, len, CAAM_RNG_MAX_FIFO_STORE_SIZE);
> >
> > @@ -101,7 +110,7 @@ static int caam_rng_read_one(struct device *jrdev,
> >       init_completion(done);
> >       err = caam_jr_enqueue(jrdev,
> >                             caam_init_desc(desc, dst_dma, len),
> > -                           caam_rng_done, done);
> > +                           caam_rng_done, &jctx);
> AFAICT there's a race condition b/w caam_jr_enqueue() and caam_rng_done(),
> both writing to "err":
> caam_jr_enqueue()
>         -> JR interrupt -> caam_jr_interrupt() -> tasklet_schedule()...
>         -> spin_unlock_bh()
>         -> caam_jr_dequeue() -> caam_rng_done() -> write err
>         -> return 0 -> write err
>

Yes, I thought it didn't really matter for calling
wait_for_completion(done), but now that I think on it again, it can
return wrong result code from vcaam_rng_read_one(). Will fix in v8.

Thanks,
Andrey Smirnov
