Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD3A9CA0FE6
	for <linux-crypto@archiver.kernel.org>; Fri,  1 Sep 2023 06:09:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231667AbjIAGJm (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 1 Sep 2023 02:09:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230508AbjIAGJl (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 1 Sep 2023 02:09:41 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF93CEA
        for <linux-crypto@vger.kernel.org>; Thu, 31 Aug 2023 23:09:36 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id 2adb3069b0e04-5007616b756so2908969e87.3
        for <linux-crypto@vger.kernel.org>; Thu, 31 Aug 2023 23:09:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shruggie-ro.20230601.gappssmtp.com; s=20230601; t=1693548575; x=1694153375; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2X9aQ6kjaHcqnoXrvZ4rj7x9p81exKW6dfx0r3OrpVM=;
        b=WFaq3mBDGe9rpOX0hOyEJC18H672JhLx4EpHNkuw3dTRTQs0k4ZBQGaQb7iLf8TuVj
         YxGxfbxdyajq4bRZDqKO6vdNuHCrjOWXNfjUCeswGe1xHZIkwfR5lJusRNe9MQ94mnAk
         HduuWvkO/I8eJ035+NTldZft/Kxg3pLbEsrgdlY6PzpXvJvAVQqyuYeBBXa7Qb36F8RC
         jUqaB97Zp3HSiNaPNtgfmWqCjZNfmOdpOFQwYRRBXDm1HcS9LuhsmPO4tz3H6lqzonJK
         fnLy55r6LMVCTuIMILnki2nWe1Qd/8UqNorldyng5CzUHANC5EEvBGAQaos26vesa52W
         WEHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693548575; x=1694153375;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2X9aQ6kjaHcqnoXrvZ4rj7x9p81exKW6dfx0r3OrpVM=;
        b=aQEGspBLjSYXvLjC4NsNqKbaSRCbd/mWXGYNl9Br+/41DhHYMM9Yxr4auWRokB6Gm+
         NF1cSR4uHje1OwBWxRLa9or8Nucj0LJNQ2FnkGZpNV9zpoe5PcTCLVT1kGCLOsRBqx+S
         mk2E8e4gcSyf63+/KISUszDilGaGrGecoJcC4F2OOA3naPvnH2Jhf6+fX7LXc2gF0Cjf
         wU/jOy8zJ7nN3eBs0s3wmw6lVKmXYrGUWC+ilSSE1MNC+BqCe4SBsirYsAPa4j77DvNo
         CGhiZC0oirrBvbu2di9ZHzSFLWhsAgngx7wISRH9Ku4SRLnbbRetW3ZV/Ua2KcHo0+PX
         5ukQ==
X-Gm-Message-State: AOJu0YzvTjxoeWqnQtnmQLe0BRDGX9HiwrcaomE454C8AoPSJOUXvAzC
        VmPHYJQirZHP2c57t9QJdlY5fyoQFOAho7gZK7hn6g==
X-Google-Smtp-Source: AGHT+IEpbjisJgojrc9V4dY+OL0FoJj+82T7LyPCLjB0dO7jvYU5ogexJvk1/AAyEF+s9N5djuw56V22H4SpW3S7s/E=
X-Received: by 2002:ac2:530b:0:b0:4fb:829b:196e with SMTP id
 c11-20020ac2530b000000b004fb829b196emr862178lfh.2.1693548575001; Thu, 31 Aug
 2023 23:09:35 -0700 (PDT)
MIME-Version: 1.0
References: <20230828102329.20867-1-aboutphysycs@gmail.com> <20230828114806.cjshfg7tpxiwyy6i@viti.kaiser.cx>
In-Reply-To: <20230828114806.cjshfg7tpxiwyy6i@viti.kaiser.cx>
From:   Alexandru Ardelean <alex@shruggie.ro>
Date:   Fri, 1 Sep 2023 09:09:23 +0300
Message-ID: <CAH3L5QrGn6+A7FiRc502E+8o3ZOWnukr+fXqVp-VrLC8kmj79A@mail.gmail.com>
Subject: Re: [PATCH] char: hw_random: xgene-rng: removed unneeded call to platform_set_drvdata()
To:     Martin Kaiser <lists@kaiser.cx>
Cc:     Andrei Coardos <aboutphysycs@gmail.com>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        yuzhe@nfschina.com, u.kleine-koenig@pengutronix.de,
        herbert@gondor.apana.org.au, olivia@selenic.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Aug 28, 2023 at 2:48=E2=80=AFPM Martin Kaiser <lists@kaiser.cx> wro=
te:
>
> Andrei Coardos (aboutphysycs@gmail.com) wrote:
>
> > This function call was found to be unnecessary as there is no equivalen=
t
> > platform_get_drvdata() call to access the private data of the driver. A=
lso,
> > the private data is defined in this driver, so there is no risk of it b=
eing
> > accessed outside of this driver file.
>
> > Signed-off-by: Andrei Coardos <aboutphysycs@gmail.com>
> > ---
> >  drivers/char/hw_random/xgene-rng.c | 1 -
> >  1 file changed, 1 deletion(-)
>
> > diff --git a/drivers/char/hw_random/xgene-rng.c b/drivers/char/hw_rando=
m/xgene-rng.c
> > index 7c8f3cb7c6af..9d64b5931a27 100644
> > --- a/drivers/char/hw_random/xgene-rng.c
> > +++ b/drivers/char/hw_random/xgene-rng.c
> > @@ -321,7 +321,6 @@ static int xgene_rng_probe(struct platform_device *=
pdev)
> >               return -ENOMEM;
>
> >       ctx->dev =3D &pdev->dev;
> > -     platform_set_drvdata(pdev, ctx);
>
> >       ctx->csr_base =3D devm_platform_ioremap_resource(pdev, 0);
> >       if (IS_ERR(ctx->csr_base))
> > --
> > 2.34.1
>
> This one's ok, too. 67fb1e295839 ("hwrng: xgene - Simplify using
> devm_clk_get_optional_enabled()") removed the platform_get_drvdata call.
>

Reviewed-by: Alexandru Ardelean <alex@shruggie.ro>

> Reviewed-by: Martin Kaiser <martin@kaiser.cx>
