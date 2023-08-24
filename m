Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B609DC3DA6F
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Aug 2023 08:29:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234168AbjHXI23 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 24 Aug 2023 04:28:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238902AbjHXI2S (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 24 Aug 2023 04:28:18 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C796D1732
        for <linux-crypto@vger.kernel.org>; Thu, 24 Aug 2023 01:28:13 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id 2adb3069b0e04-5007c8308c3so6929729e87.0
        for <linux-crypto@vger.kernel.org>; Thu, 24 Aug 2023 01:28:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shruggie-ro.20221208.gappssmtp.com; s=20221208; t=1692865692; x=1693470492;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vdz3KnRZnnKJHF7J9lrCuaBuAwD4CdeMT7lxdX3j5vc=;
        b=OCpq3/YFdKki4ePqQ2OXlshJpxa/mA43T4UO7SU7d4+WreOX5+PnixbkcrPVZH19PP
         9sd1g0nuxwCYjZzfVr1GnOGJ37Inz85fkDmmqv+fO6S1HNcOHu09DPeH7VK+SwiaVHRc
         y+qTURdnXyQ86obknrhWx4iCN3TBPaaakm5/kTOFiVwHpIVA7P6AJ6EiXt7BxSyX2GHl
         hfKv4ctvyqapZy4kl3hJMQPV/kDxsedq0wn2LdUnSJiaNvI3pXrMQrrOuWCu1XpYR/rR
         zwBdIaPgrxvSM6qXjXelh5I+VMh//R5p48/DJSI/LNuwVwKTbCltptPQNjB+KsesP2DB
         Ccrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692865692; x=1693470492;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vdz3KnRZnnKJHF7J9lrCuaBuAwD4CdeMT7lxdX3j5vc=;
        b=Sow5OnexG2lQSI8dn4SsucbV+d76cM18WWqBGUthtu4Q7TkleuL1ycMwWNAQ3tuKbF
         C+rB5W7jQlYAAC5DD6X9+LeOGE4Pb5pdVgV7fBxmnE/SkXU6qeD7gsnnVPiOG27XCKeK
         c2pXD6BqikEwhqV+WTSb0N/JJcIHe0ZL4AnrOP2Acy+g/Xb6LQ3Lq/ljOkKsHQ3Mmiq+
         7E8AUr1w6TPj1mgp6NUcI7OvEDOWUKo1JN4hvx7zrkFE5TetxVEHKHSbWZojvhLSiHqA
         BJiQ8WRxS353IzJdkH7qTZihv/GhtGT1n5CSTU4eNiA5BvO/ziK6lVrLlFfgPR3J4psT
         QSwQ==
X-Gm-Message-State: AOJu0Ywo8t630WwAMy9Z51PEbt1u9a6V+Sgh3RqbTLOjR243vLeZZj2M
        kKt+Fhth6+H3lybgwUPJsct0az4kqw+WN+a47YSJADfHjirhWEFvIi8=
X-Google-Smtp-Source: AGHT+IGqOaHfuFjakkSUTWio9q6lciJOqJWxMjbjAGnb3Ha4GwjzLDCj4ijaZAm6Ry2cuzS3pGhTYTdIzgYA30+EVmo=
X-Received: by 2002:a05:6512:553:b0:500:8fcb:e0c9 with SMTP id
 h19-20020a056512055300b005008fcbe0c9mr4056323lfl.69.1692865691841; Thu, 24
 Aug 2023 01:28:11 -0700 (PDT)
MIME-Version: 1.0
References: <20230823112139.4012-1-aboutphysycs@gmail.com> <20230823134417.pe4jm3xqj6tdslav@viti.kaiser.cx>
In-Reply-To: <20230823134417.pe4jm3xqj6tdslav@viti.kaiser.cx>
From:   Alexandru Ardelean <alex@shruggie.ro>
Date:   Thu, 24 Aug 2023 11:28:00 +0300
Message-ID: <CAH3L5QpmVqNMr_kSFa_rar5ZEjLv_5Xxjss4syVX2_0bCuL5vQ@mail.gmail.com>
Subject: Re: [PATCH] char: hw_random: hisi-rng: removed unneeded call to platform_set_drvdata()
To:     Martin Kaiser <lists@kaiser.cx>
Cc:     Andrei Coardos <aboutphysycs@gmail.com>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        herbert@gondor.apana.org.au, olivia@selenic.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Aug 23, 2023 at 4:44=E2=80=AFPM Martin Kaiser <lists@kaiser.cx> wro=
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
> >  drivers/char/hw_random/hisi-rng.c | 2 --
> >  1 file changed, 2 deletions(-)
>
> > diff --git a/drivers/char/hw_random/hisi-rng.c b/drivers/char/hw_random=
/hisi-rng.c
> > index 96438f85cafa..b6f27566e0ba 100644
> > --- a/drivers/char/hw_random/hisi-rng.c
> > +++ b/drivers/char/hw_random/hisi-rng.c
> > @@ -79,8 +79,6 @@ static int hisi_rng_probe(struct platform_device *pde=
v)
> >       if (!rng)
> >               return -ENOMEM;
>
> > -     platform_set_drvdata(pdev, rng);
> > -
> >       rng->base =3D devm_platform_ioremap_resource(pdev, 0);
> >       if (IS_ERR(rng->base))
> >               return PTR_ERR(rng->base);
> > --
> > 2.34.1
>
> This one can go.
>

Reviewed-by: Alexandru Ardelean <alex@shruggie.ro>

> Reviewed-by: Martin Kaiser <martin@kaiser.cx>
