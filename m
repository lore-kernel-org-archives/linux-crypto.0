Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D35CCA0FE1
	for <linux-crypto@archiver.kernel.org>; Fri,  1 Sep 2023 06:10:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233040AbjIAGKz (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 1 Sep 2023 02:10:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235363AbjIAGKy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 1 Sep 2023 02:10:54 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB75A1702
        for <linux-crypto@vger.kernel.org>; Thu, 31 Aug 2023 23:10:37 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id 2adb3069b0e04-500bdef7167so3380727e87.0
        for <linux-crypto@vger.kernel.org>; Thu, 31 Aug 2023 23:10:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shruggie-ro.20230601.gappssmtp.com; s=20230601; t=1693548636; x=1694153436; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RnvPYauBqEhoq6cEWkhu+3J3mdV3Lw0zys/CSbD9y3Y=;
        b=hDs1CSUDRDSMWFrZAU7WBPq/dzh/msik2KEl9pC0F1i2eDRwiRg6FplxLq0XYMZwoN
         Vra7OBOm8ptzw5/QcuynABEW/2vjvsGUkSqKmTipZqHdanxO3ZAEIo6xft/U9JeuzG+R
         PTIMz7Ht9wWDMMZ/7wuXAKtFh/4ckouYrhtvXCHp91T5vkhF791o+USW2tGTKgJQVl9Z
         r8MZjrT0VjOBbZITAx9Jz6mdeN90XrF92hAGm3Bs84kjze2C7VNR2tHJ20+HeB4lz4C2
         403slfAZTry3GzEOO6wWuimLh0gss+T8hJXggDtiku5CzJhLkI0oJQ50TIdH4Vsj6s/p
         C8FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693548636; x=1694153436;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RnvPYauBqEhoq6cEWkhu+3J3mdV3Lw0zys/CSbD9y3Y=;
        b=aMoKjhEc5il4R9ZMB4eRE5+6gjGMhSbVSrLtOpfxN/GnorFkCgkZpTelkXfKvzjtKm
         Ln7NlfS9x0UV8NryGoawN/twCEXwVzlMf9KOO9THUSGQUH1qzCLLp7Y3YfeTAq+aB0lE
         zxhB8J1p0NWH9mYr621IPfsjgsj//vYE8IfGGoh+3OAAgVaCK/9S0bpRETpoSmy1zE4l
         6OfIQULf4nQSzd+RddNu0laeJLxQDYjm1tQcNlt1agLmckl4+aE2PJn8c4i2KLb3ZlTJ
         jN2vKQgcOKfuNRcCcdjlwrlLo92qZJH7o1P8q8aHGgwMwjSSWf+e1i3aTyVaU7prg9s6
         w8eg==
X-Gm-Message-State: AOJu0YzosL7rRd0/Xk3Jv0F4v5Lw4iCiLPVi+vNXK9ZtihiixyyHVm0o
        ywkab8t8uRlfybCrEGB7nyj24pdclV911irzt67E/w==
X-Google-Smtp-Source: AGHT+IFfpk0jvivYElHU0ScyZpVNHhBz1jFdw6GqRbKwakO/nrfLuO2h+aoNjxmjGGUgwFDEnHv5mD9BffZyvn8UUyw=
X-Received: by 2002:ac2:482e:0:b0:4f8:5e62:b94b with SMTP id
 14-20020ac2482e000000b004f85e62b94bmr427790lft.9.1693548636078; Thu, 31 Aug
 2023 23:10:36 -0700 (PDT)
MIME-Version: 1.0
References: <20230828102943.21097-1-aboutphysycs@gmail.com> <CAH3L5Qpg84+Dc0MzfEWtJmfZYsXwdNHD6OZ6bRTfyB8xcr5HdQ@mail.gmail.com>
In-Reply-To: <CAH3L5Qpg84+Dc0MzfEWtJmfZYsXwdNHD6OZ6bRTfyB8xcr5HdQ@mail.gmail.com>
From:   Alexandru Ardelean <alex@shruggie.ro>
Date:   Fri, 1 Sep 2023 09:10:25 +0300
Message-ID: <CAH3L5QrqFDYw6cQEqR6NZ94XV1bgSTDVx8wGeRQWOWFC5FaJ5w@mail.gmail.com>
Subject: Re: [PATCH] char: hw_random: xiphera-trng: removed unnneded platform_set_drvdata()
To:     Andrei Coardos <aboutphysycs@gmail.com>
Cc:     linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        herbert@gondor.apana.org.au, olivia@selenic.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Sep 1, 2023 at 9:04=E2=80=AFAM Alexandru Ardelean <alex@shruggie.ro=
> wrote:
>
> On Mon, Aug 28, 2023 at 1:29=E2=80=AFPM Andrei Coardos <aboutphysycs@gmai=
l.com> wrote:
> >
> > This function call was found to be unnecessary as there is no equivalen=
t
> > platform_get_drvdata() call to access the private data of the driver. A=
lso,
> > the private data is defined in this driver, so there is no risk of it b=
eing
> > accessed outside of this driver file.
> >
> > Signed-off-by: Andrei Coardos <aboutphysycs@gmail.com>
> > ---
> >  drivers/char/hw_random/xiphera-trng.c | 2 --
> >  1 file changed, 2 deletions(-)
> >
> > diff --git a/drivers/char/hw_random/xiphera-trng.c b/drivers/char/hw_ra=
ndom/xiphera-trng.c
> > index 2a9fea72b2e0..1fa4b70246f0 100644
> > --- a/drivers/char/hw_random/xiphera-trng.c
> > +++ b/drivers/char/hw_random/xiphera-trng.c
> > @@ -122,8 +122,6 @@ static int xiphera_trng_probe(struct platform_devic=
e *pdev)
> >                 return ret;
> >         }
> >
> > -       platform_set_drvdata(pdev, trng);
> > -
> >         return 0;
>
> This entire block could become now:
>
>         return devm_hwrng_register(dev, &trng->rng);
>

Coming back here.
I wonder if there is a desire to keep the prints above.
If yes, then this is fine as-is.
With that:

Reviewed-by: Alexandru Ardelean <alex@shruggie.ro>

> >  }
> >
> > --
> > 2.34.1
> >
