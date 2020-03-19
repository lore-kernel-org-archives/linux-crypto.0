Return-Path: <SRS0=HVQB=5E=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B9D4C4332E
	for <linux-crypto@archiver.kernel.org>; Thu, 19 Mar 2020 13:38:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E376E20787
	for <linux-crypto@archiver.kernel.org>; Thu, 19 Mar 2020 13:38:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lLruOAFc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727898AbgCSNHU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 19 Mar 2020 09:07:20 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:40625 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727884AbgCSNHT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 19 Mar 2020 09:07:19 -0400
Received: by mail-wr1-f65.google.com with SMTP id f3so2881414wrw.7;
        Thu, 19 Mar 2020 06:07:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=IAGVxgGFxdcnCrZTDttJX0fXIuKoP1EiqE+ObCSCHjo=;
        b=lLruOAFcOCPtYJtR/2ABKWDl4GK0L8S6ks41hHfdvTIVprnzPZ0dsW/CsjdWBeDoOA
         y4e9xW1mCUTRgZDMSd1z6YvItVTRUc22KeDD7lKgHa4M2me7zTH7EGKTH3XgWKN/hPoa
         42WKSTdIJrjBxcYgtnU4Z15V6kufmAdZcBaj3Mg0Ub1sMWDA+Vqq6oHV1KY5aCYn3pK6
         TQcKkLmYsOAWaqaRbYAH3bnUibFiAewm9BpMFOLmEKYrk3gsXp5Vxce593J4prw18Pcm
         4B/zjRt9OCIMBKneq1rpb3nlGg/yK2YAA3B7isBmVE/QOjumbRA1uYefexsn6esZVYZ9
         EbXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=IAGVxgGFxdcnCrZTDttJX0fXIuKoP1EiqE+ObCSCHjo=;
        b=Ph9Jf55qCpacIRZCpzCbTJ4hoNMdR8KnsJLIXIi4kLX12Y+9udODhQn8Oemhcn2SJf
         ulChECWrtWPxIzwYafC4v9aG1ZJX+w1i1jjLaY4SKLqtuGHieAkzPoHw4cGBpN4Dvg8a
         JPCY3OP2Tu0OlIZkSpX5+7ALq95p9aIYi+LKOqgm5YcC8qKCXwls26YB0imUZqYVWVke
         Y8GuHOMQ0Oxio8OeMf0cFwvlHwTUghSBXnwXFSFtTLQ99T+7dugki9c9Rc723KU6Pm5L
         QGzRbs4MkouSDk6PzA4uQJaZJZmnXHpkTLE/+3xBJAbI0PFvomrJd+0NJP0rHUtYCOYH
         E6Xg==
X-Gm-Message-State: ANhLgQ1ij1jrjnpCQI250xh8eoESsyd+lX6KNKGwQmhuIhcfN5u/gruE
        2249A4LJfO6iFDLENkfnbOL1nwC8aIzx9FSSr8DqLg==
X-Google-Smtp-Source: ADFU+vu0myIgsfnN06h6k9VdOZjRHUJdy5H/u1cwR3LYksaqa3YS/NZu4fQSC+iE1nJcbmWbpvYZ4Awnw6S4bqnQFdo=
X-Received: by 2002:a5d:5092:: with SMTP id a18mr4218509wrt.202.1584623237491;
 Thu, 19 Mar 2020 06:07:17 -0700 (PDT)
MIME-Version: 1.0
References: <20200316150047.30828-1-andrew.smirnov@gmail.com>
 <20200316150047.30828-5-andrew.smirnov@gmail.com> <0f5819d6-3485-1d2c-effd-4ae6d54f2498@nxp.com>
In-Reply-To: <0f5819d6-3485-1d2c-effd-4ae6d54f2498@nxp.com>
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
Date:   Thu, 19 Mar 2020 06:07:05 -0700
Message-ID: <CAHQ1cqHYRA9sg_UCF2pos8fhVJuYejSW08C=Yx0mt8Bsj19Khg@mail.gmail.com>
Subject: Re: [PATCH v8 4/8] crypto: caam - simplify RNG implementation
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

On Tue, Mar 17, 2020 at 2:58 PM Horia Geant=C4=83 <horia.geanta@nxp.com> wr=
ote:
>
> On 3/16/2020 5:01 PM, Andrey Smirnov wrote:
> > @@ -335,15 +225,18 @@ int caam_rng_init(struct device *ctrldev)
> >       if (!devres_open_group(ctrldev, caam_rng_init, GFP_KERNEL))
> >               return -ENOMEM;
> >
> > -     ctx =3D devm_kzalloc(ctrldev, sizeof(*ctx), GFP_DMA | GFP_KERNEL)=
;
> > +     ctx =3D devm_kzalloc(ctrldev, sizeof(*ctx), GFP_KERNEL);
> >       if (!ctx)
> >               return -ENOMEM;
> >
> > +     ctx->ctrldev =3D ctrldev;
> > +
> >       ctx->rng.name    =3D "rng-caam";
> >       ctx->rng.init    =3D caam_init;
> >       ctx->rng.cleanup =3D caam_cleanup;
> >       ctx->rng.read    =3D caam_read;
> >       ctx->rng.priv    =3D (unsigned long)ctx;
> > +     ctx->rng.quality =3D 1024;
> >
> Nitpick: setting the quality should be moved to patch
> "crypto: caam - limit single JD RNG output to maximum of 16 bytes"
>

Ugh, looks like I messed this up while making v8. Will fix in v9.

Thanks,
Andrey Smirnov
