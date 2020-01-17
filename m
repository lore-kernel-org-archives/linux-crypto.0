Return-Path: <SRS0=A/Go=3G=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28F15C33CB1
	for <linux-crypto@archiver.kernel.org>; Fri, 17 Jan 2020 12:16:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0084C2073A
	for <linux-crypto@archiver.kernel.org>; Fri, 17 Jan 2020 12:16:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="g7pz9kl1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727040AbgAQMQU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 17 Jan 2020 07:16:20 -0500
Received: from mail-ot1-f66.google.com ([209.85.210.66]:42327 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726892AbgAQMQP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 17 Jan 2020 07:16:15 -0500
Received: by mail-ot1-f66.google.com with SMTP id 66so22333973otd.9
        for <linux-crypto@vger.kernel.org>; Fri, 17 Jan 2020 04:16:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OLdYBE/MVxP+IEJf5xYlwkMrALul6wc+ioyfNkUWx5I=;
        b=g7pz9kl1SZ/Rtizxe7LcT2bFiTs+MSNviUNGniWPuzf45z2CYzL4iGWTrXAGs2wWGZ
         EyXJFu8BIuzwBomcBYL/A+bXs32khfiabuAK2svc8iM1uDRZGHgjKn88EgfPDwX9S5X6
         SDFUCbO/O9xR2SsCQ8Z5cznpog8IU9TZ9OxIw1befHw/r4+lSKAX1GGztcvA7Nyx26Kw
         bvahlLr5o0k1MQHyx6bPEH1u/boYopqP6Vg2/U5ijC9+y3fBL5yIgWav4qRoyPbu0abz
         qBsayuGbjmAupos/roG3h4teNpMMYntyCbdo+Qb0Exs0+bN+TBEGmApbtLWp96xtyIMw
         0m5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OLdYBE/MVxP+IEJf5xYlwkMrALul6wc+ioyfNkUWx5I=;
        b=kc6DRbQIi6bfWvG9MN9ek7v6whwS7rCIf2f4S6029cve0FISj71Id8R3z9asdU1oua
         zEHcNyceijSPZtdTN+MmuU+M6E2iswaQJf6Mf9h3tgkdWqeb890vPbaUeg3O4+3R3Tvd
         2u8rpTmg0xJKTJMix5xdVt9Jnip848PIKZpX+mvQfwlQu+KCGoyOOja9IuuV0Omeo9li
         xR9+ffd08htC24BChry3WkTXcVdKJ9exhZ6E+SFkjtMd8UyY1SzykV0C81Gp04bXVNHU
         yf7trLvuAlCerv+qXn5fKQYnCwt2MMg6sKxaYbUPMzSyyPp122/ARPDqlnL7pE/rMi+8
         ADOg==
X-Gm-Message-State: APjAAAVJlNdIOjqb2ZPmM9zjL5ZS3E0mdsgGLTTH2iixdCf8l2+MjMyf
        XfljVTS4wX+krU729utwkUrqBT1XNw+YPdN+INgNGQ==
X-Google-Smtp-Source: APXvYqwUSNCN2VPjDlM+0347SqxocVqyJCbtMj2edv7XT6B2yU4dwOF6tZWsqNRaBrPa01DezuFaq6ETWxnNC4uSscs=
X-Received: by 2002:a9d:6e14:: with SMTP id e20mr6073905otr.283.1579263374814;
 Fri, 17 Jan 2020 04:16:14 -0800 (PST)
MIME-Version: 1.0
References: <20200116154852.84532-1-colin.king@canonical.com> <e6fd526e-316f-539d-9f5e-c039041c4f2e@amd.com>
In-Reply-To: <e6fd526e-316f-539d-9f5e-c039041c4f2e@amd.com>
From:   Jens Wiklander <jens.wiklander@linaro.org>
Date:   Fri, 17 Jan 2020 13:16:03 +0100
Message-ID: <CAHUa44FFshAu+4Ue3Q4MDb_+sHCr20KjM3N=usJZsANvdr47eg@mail.gmail.com>
Subject: Re: [PATCH][next][V2] tee: fix memory allocation failure checks on
 drv_data and amdtee
To:     "Thomas, Rijo-john" <Rijo-john.Thomas@amd.com>
Cc:     Colin King <colin.king@canonical.com>,
        Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>,
        Gary R Hook <gary.hook@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Jan 17, 2020 at 7:40 AM Thomas, Rijo-john
<Rijo-john.Thomas@amd.com> wrote:
>
>
>
> On 16/01/20 9:18 pm, Colin King wrote:
> > From: Colin Ian King <colin.king@canonical.com>
> >
> > Currently the memory allocation failure checks on drv_data and
> > amdtee are using IS_ERR rather than checking for a null pointer.
> > Fix these checks to use the conventional null pointer check.
> >
> > Addresses-Coverity: ("Dereference null return")
> > Fixes: 757cc3e9ff1d ("tee: add AMD-TEE driver")
> > Signed-off-by: Colin Ian King <colin.king@canonical.com>
>
> Reviewed-by: Rijo Thomas <Rijo-john.Thomas@amd.com>

Acked-by: Jens Wiklander <jens.wiklander@linaro.org>

Thanks,
Jens

>
> Thanks,
> Rijo
>
> > ---
> > V2: update to apply against cryptodev-2.6 tree tip
> > ---
> >  drivers/tee/amdtee/core.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/tee/amdtee/core.c b/drivers/tee/amdtee/core.c
> > index be8937eb5d43..6370bb55f512 100644
> > --- a/drivers/tee/amdtee/core.c
> > +++ b/drivers/tee/amdtee/core.c
> > @@ -446,11 +446,11 @@ static int __init amdtee_driver_init(void)
> >       }
> >
> >       drv_data = kzalloc(sizeof(*drv_data), GFP_KERNEL);
> > -     if (IS_ERR(drv_data))
> > +     if (!drv_data)
> >               return -ENOMEM;
> >
> >       amdtee = kzalloc(sizeof(*amdtee), GFP_KERNEL);
> > -     if (IS_ERR(amdtee)) {
> > +     if (!amdtee) {
> >               rc = -ENOMEM;
> >               goto err_kfree_drv_data;
> >       }
> >
